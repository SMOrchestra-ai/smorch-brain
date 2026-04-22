# SOP-12: Claude Code as Application Backend — Skill/Plugin/Template/Context Injection

**Version:** 1.0
**Date:** 2026-04-17
**Owner:** Mamoun Alamouri
**Scope:** Every project that uses Claude Code as the AI execution layer
**Status:** Standard — all new AI-powered features MUST follow this pattern
**Reference Implementation:** `content-automation` (runtime/src/assembler/)

---

## Why This SOP Exists

We are phasing out direct Claude API calls in favor of Claude Code subprocess execution with skill injection. This gives us:

1. **Structured context** — Skills define the AI's role, constraints, and output format
2. **Reusability** — Same skill works across projects via smorch-brain distribution
3. **Versioning** — Skills are git-tracked, not hardcoded in API call strings
4. **Quality control** — Skills go through audit before deployment
5. **No API key management per app** — Claude Code handles auth
6. **Full tool access** — Claude Code can read files, run commands, use MCP tools

**Migration path:** Claude API → Claude Code subprocess with CLAUDE.md injection

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                   YOUR APPLICATION                    │
│  (Next.js, Node.js, n8n, or any runtime)             │
│                                                       │
│  1. Receives request (API route, webhook, cron)       │
│  2. Resolves which skill to use                       │
│  3. Assembles context (user data, templates, config)  │
│  4. Writes CLAUDE.md to temp directory                │
│  5. Spawns Claude Code subprocess                     │
│  6. Reads output from temp directory                  │
│  7. Returns result to caller                          │
└─────────────┬───────────────────────────────────────┘
              │
              │  subprocess call
              ▼
┌─────────────────────────────────────────────────────┐
│                 CLAUDE CODE SUBPROCESS                 │
│                                                       │
│  Reads: $tmpdir/CLAUDE.md (generated instructions)    │
│  Reads: .claude/skills/{resolved-skill}/ (skill def)  │
│  Reads: templates/{output-template}.md (format spec)  │
│  Reads: context/{injected-context}.md (business data) │
│                                                       │
│  Executes the task using all available tools           │
│  Writes output to $tmpdir/output/                     │
└─────────────────────────────────────────────────────┘
```

---

## The 5 Injection Layers

Every Claude Code task receives up to 5 layers of context. Each layer has a specific purpose:

### Layer 1: CLAUDE.md (Task Instructions)
**What:** Generated per-request. Tells Claude Code exactly what to produce.
**Where:** Written to `$tmpdir/CLAUDE.md` before subprocess spawn.
**Contains:**
- Role definition ("You are a content generation engine for SMOrchestra.ai")
- Asset type, language, topics, style
- Output format and constraints
- References to skill and template files

**Example:**
```markdown
# Content Generation Task

**Asset type:** linkedin_post
**Language:** Arabic (ar)
**Topics:** signal-based-selling, mena-market
**Style:** contrarian, direct

Your job:
1. Read the skill in `.claude/skills/` — voice, structure, patterns
2. Follow the output template in `templates/output-template.md`
3. Incorporate source material from `context/source.md`
4. Write output to `output/result.md`
```

### Layer 2: Skills (How to Do It)
**What:** Reusable skill definitions that encode expertise.
**Where:** `.claude/skills/{skill-name}/` directory in the project, or resolved from smorch-brain.
**Contains:**
- SKILL.md — the skill definition (voice, constraints, patterns, examples)
- Supporting files (reference data, example outputs)

**Resolution order (first match wins):**
1. `{assetType}::{topic}::{language}` — most specific
2. `{assetType}::{topic}` — topic-specific
3. `{assetType}` — generic fallback

**Example:** For a LinkedIn post about signal-selling in Arabic:
1. Try: `linkedin_post::signal-based-selling::ar`
2. Try: `linkedin_post::signal-based-selling`
3. Fallback: `linkedin_post`

### Layer 3: Templates (What Shape the Output Takes)
**What:** Output format specifications.
**Where:** `templates/{template-name}.md` in the project.
**Contains:**
- Required sections and their order
- Formatting rules (max length, heading structure)
- Placeholder markers for variable content

**Example:** `templates/linkedin-post.md`
```markdown
## Output Format

Hook line (max 12 words, pattern interrupt)
---
Body (3 paragraphs, max 3 sentences each)
---
CTA (single low-friction ask)
---
Hashtags (3-5, relevant to MENA + topic)
```

### Layer 4: Context (What to Work With)
**What:** Request-specific data injected at runtime.
**Where:** Written to `$tmpdir/context/` before subprocess spawn.
**Contains:**
- Source material (articles, transcripts, data)
- User-specific data (founder profile, product info, scores)
- Business context (ICP, positioning, brand voice)

**Sources of context:**
- Database queries (Supabase)
- User input (form data, API payload)
- smorch-context repo (business context files)
- Previous step output (pipeline chaining)

### Layer 5: Plugins (Extended Capabilities)
**What:** Claude Code plugins that add project-specific tools and workflows.
**Where:** Registered in `.claude/settings.json` or project CLAUDE.md.
**Contains:**
- MCP server connections (Supabase, GHL, n8n, SSH)
- Custom tool definitions
- Workflow orchestration rules

**Example:** EO-MENA uses `eo-microsaas-plugin` which provides 6 build skills.

---

## Implementation Pattern

### Step 1: Skill Resolution

```typescript
// skill-resolver.ts
export async function resolveSkillPath(
  assetType: string,
  topics: string[],
  language: string,
): Promise<string> {
  // Try each topic with exact language
  for (const topic of topics) {
    const entry = resolveSkill(assetType, topic, language);
    if (entry) return entry.skillDir;
  }
  // Try without language
  for (const topic of topics) {
    const entry = resolveSkill(assetType, topic);
    if (entry) return entry.skillDir;
  }
  // Generic fallback
  const fallback = resolveSkill(assetType);
  if (fallback) return fallback.skillDir;

  throw new Error(`No skill found for ${assetType}/${topics}/${language}`);
}
```

### Step 2: CLAUDE.md Generation

```typescript
// claude-md-writer.ts
export async function writeTmpdirClaudeMd(params: {
  context: string;
  template: string;
  sourceMaterial: string;
  assetType: string;
  language: string;
  topics: string[];
  style: string;
}): Promise<string> {
  const sections: string[] = [];

  // 1. Role & Task
  sections.push(`# Task\nYou are a ${params.assetType} generator...`);

  // 2. Skill reference
  sections.push(`Read the skill in \`.claude/skills/\``);

  // 3. Template reference
  sections.push(`Follow the output template in \`templates/\``);

  // 4. Context injection
  sections.push(`Source material:\n${params.sourceMaterial}`);

  // 5. Output instructions
  sections.push(`Write output to \`output/result.md\``);

  return sections.join('\n\n---\n\n');
}
```

### Step 3: Subprocess Execution

```typescript
// executor.ts
import { execFile } from 'child_process';

export async function executeClaudeCode(
  tmpdir: string,
  skillDir: string,
  timeout: number = 300_000, // 5 min default
): Promise<string> {
  return new Promise((resolve, reject) => {
    const proc = execFile('claude', [
      '--print',           // Non-interactive, output only
      '--add-dir', skillDir,  // Inject skill directory
      '--add-dir', tmpdir,    // Inject task context
      'Execute the task described in CLAUDE.md',
    ], {
      cwd: tmpdir,
      timeout,
      env: { ...process.env, CLAUDE_CODE_ENTRYPOINT: 'skill' },
    });

    let output = '';
    proc.stdout?.on('data', (d) => output += d);
    proc.on('close', (code) => {
      if (code === 0) resolve(output);
      else reject(new Error(`Claude Code exited with ${code}`));
    });
  });
}
```

### Step 4: Output Collection

```typescript
// collector.ts
import { readFile } from 'fs/promises';
import { join } from 'path';

export async function collectOutput(tmpdir: string): Promise<{
  content: string;
  metadata: Record<string, unknown>;
}> {
  const content = await readFile(join(tmpdir, 'output', 'result.md'), 'utf-8');
  const metadata = JSON.parse(
    await readFile(join(tmpdir, 'output', 'metadata.json'), 'utf-8').catch(() => '{}')
  );
  return { content, metadata };
}
```

---

## Temp Directory Structure

```
$tmpdir/
├── CLAUDE.md              ← Generated task instructions (Layer 1)
├── .claude/
│   └── skills/
│       └── {resolved}/    ← Skill definition (Layer 2)
│           ├── SKILL.md
│           └── examples/
├── templates/
│   └── output-template.md ← Output format spec (Layer 3)
├── context/
│   ├── source.md          ← Source material (Layer 4)
│   ├── user-data.json     ← User-specific data
│   └── business.md        ← Business context
└── output/                ← Claude Code writes here
    ├── result.md
    └── metadata.json
```

---

## Skill Management

### Creating a New Skill

1. Create skill directory: `.claude/skills/{skill-name}/`
2. Write `SKILL.md` (under 500 lines per smorch-brain SOP)
3. Add examples in `examples/` subdirectory
4. Register in project's skill config (skillMap in config.ts)
5. Run `smorch audit` before push
6. Test with a sample request

### Skill Distribution

Skills that are reusable across projects live in `smorch-brain/skills/`.
Project-specific skills live in the project's `.claude/skills/`.

Distribution flow:
```
smorch-brain/skills/ → smorch push → target project/.claude/skills/
```

### Skill Versioning

Skills are versioned via git (no separate version numbers).
The skill resolver always uses the local copy. To update:
```bash
smorch pull  # Pulls latest skills from smorch-brain
```

---

## Migration Guide: Claude API → Claude Code Subprocess

### Before (Direct API call)
```typescript
// OLD — libs/gpt.js pattern
import Anthropic from '@anthropic-ai/sdk';
const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
const response = await client.messages.create({
  model: 'claude-sonnet-4-20250514',
  system: 'You are a scoring engine...',  // Hardcoded prompt
  messages: [{ role: 'user', content: userInput }],
});
```

### After (Skill-injected subprocess)
```typescript
// NEW — skill injection pattern
const skillDir = await resolveSkillPath('assessment', ['eo-scoring'], 'ar');
const tmpdir = await prepareTmpDir({ context, template, sourceMaterial });
await writeTmpdirClaudeMd({ assetType: 'assessment', language: 'ar', ... });
const result = await executeClaudeCode(tmpdir, skillDir);
const output = await collectOutput(tmpdir);
```

### Migration checklist:
- [ ] Identify all Claude/OpenAI API calls in the codebase
- [ ] For each call, extract the system prompt into a SKILL.md
- [ ] Create output template from the expected response format
- [ ] Create the subprocess execution wrapper
- [ ] Remove ANTHROPIC_API_KEY / OPENAI_API_KEY from .env
- [ ] Test with real requests
- [ ] Verify output quality matches or exceeds API-direct approach

---

## Projects Using This Pattern

| Project | Status | Pattern | Notes |
|---------|--------|---------|-------|
| content-automation | ✅ Active | Full subprocess + skill resolver | Reference implementation |
| EO-MENA | ✅ Active | Plugin-based (eo-microsaas-plugin) | 6 build skills |
| EO-Scorecard-Platform | ❌ Legacy | Direct OpenAI GPT-4 API | Migration needed |
| Signal-Sales-Engine | 🔜 Planned | Will use for lead scoring + campaign gen | |
| digital-revenue-score | 🔜 Planned | Will use for score generation | |

---

## Quality Gates

Before deploying a skill-injected feature:

1. **Skill audit** — `smorch audit` passes, SKILL.md under 500 lines
2. **Dry run** — Execute with test data, verify output format matches template
3. **Fallback** — If Claude Code subprocess fails, app must handle gracefully (error state, not crash)
4. **Timeout** — Every subprocess has a timeout (default 5 min, configurable)
5. **Output validation** — Parse output and verify required sections exist
6. **Cost check** — Subprocess calls consume Claude Code usage; monitor in production

---

## Anti-Patterns (DO NOT)

- ❌ Hardcode system prompts in API route files
- ❌ Use Claude API directly when Claude Code subprocess is available
- ❌ Put API keys in .env when skill injection removes the need
- ❌ Create skills longer than 500 lines (split into sub-skills)
- ❌ Skip the skill resolver and hardcode skill paths
- ❌ Let Claude Code subprocess run without a timeout
- ❌ Ignore subprocess exit codes (non-zero = failure)
- ❌ Write output to locations outside $tmpdir
