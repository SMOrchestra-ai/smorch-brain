# INDEX FILE GUIDE
# How navigation maps work in the EO workspace

## What is an index.md?

An index.md is a navigation map. It sits at the top of every folder and tells Claude (or any AI tool) what files are in this folder, what each file contains, and when it was last updated.

Think of it like a table of contents for a folder.

## Why index.md Matters

Without an index.md, Claude has to scan every file in a folder to find what it needs. This wastes context window (Claude's working memory) and makes responses slower. With an index.md, Claude reads ONE file and knows exactly where to look.

**Example:** If Claude needs your ICP details, instead of opening all 10 files in projects/{name}/brain/, it reads the index.md, sees that icp.md contains "Customer persona, pains, dream outcome, buyer journey," and goes straight there.

## Template: Root index.md

```markdown
# Workspace Navigation Map

Last updated: {date}

## Folders

| Folder | Purpose | Key Files |
|--------|---------|-----------|
| about-me/ | Founder context (your story, skills, resources) | 6 files |
| brain/ | AI settings (identity card + operational playbook) | 2 files |
| projects/ | Project workspaces (one per venture) | {project-name}/ |
| templates/ | Task recipes (copy-paste into Claude) | {count} templates |
| output/ | Session deliverables | created per session |

## Quick Actions

- Update AI identity: edit brain/profile-settings.md, then paste into Claude Settings
- Update work rules: edit brain/cowork-instructions.md, then paste into .claude/CLAUDE.md
- Update project context: edit projects/{name}/CLAUDE.md
- Add founder context: add files to about-me/
- Create task recipes: add files to templates/
```

## Template: Subfolder index.md

```markdown
# {Folder Name}

## Purpose
{1 sentence explaining what this folder contains}

## Files

| File | Contains | Updated |
|------|----------|---------|
| {filename} | {1-line description} | {date} |
| {filename} | {1-line description} | {date} |
```

## Auto-Generation Rules

The 1-eo-brain-ingestion skill generates all index.md files automatically. The rules:

1. **Root index.md** lists all top-level folders with purpose and key file counts
2. **Subfolder index.md** lists all files with one-line descriptions and dates
3. **Descriptions are extracted** from the file's first heading or summary section
4. **Dates use ISO format** (YYYY-MM-DD)
5. **If a new file is added** to a folder, the index.md should be updated (downstream skills handle this)

## When to Manually Update

Almost never. The only case: if you manually add a new file to a folder, update that folder's index.md with a new row in the Files table. Or ask Claude to do it: "Update the index.md in about-me/ - I added a new file called my-network.md about my professional connections."
