# Speaker Notes = Recording Scripts

Every slide gets a full recording script in the speaker notes field. This is not a bullet summary for the presenter to riff from. It is the actual video script, word for word, that Mamoun reads/adapts while recording.

## Format

```
SCRIPT (START_TIME - END_TIME)

[STAGE DIRECTION]

"Spoken script paragraph one.

Spoken script paragraph two.

Spoken script paragraph three."

[TRANSITION: description]
```

## Components

### Timestamp Range

Top of every speaker note. Format: `SCRIPT (M:SS - M:SS)`

Timestamps should be realistic for the content density on that slide. Rough guide:
- Title slide: 30-45 seconds
- Reality Check / Concept slides: 60-90 seconds
- Strategy / Toolkit slides: 60-90 seconds
- Step slides: 60-120 seconds depending on complexity
- CTA slide: 30-45 seconds

The total should add up to the target video length. For a 20-minute video with 15 slides, average ~80 seconds per slide.

### Stage Directions

Bracketed instructions for energy, camera, and pacing. Place them before the spoken text and between paragraphs when the energy or delivery shifts.

Common stage directions:
```
[ENERGY: High. Direct to camera. Pattern interrupt.]
[ENERGY: Calm. Teaching mode.]
[ENERGY: Build intensity through this section]
[LEAN IN: This is the key insight]
[PAUSE for emphasis]
[SHOW SCREEN: Demo the interface]
[TRANSITION: Quick cut]
[TRANSITION: "Now the toolkit"]
[TRANSITION: Next slide]
[TRANSITION: Step N]
```

Stage directions are short, actionable. Not paragraphs of direction. One line max.

### Spoken Script

Written in first person, conversational, direct. This is how Mamoun actually talks on camera.

Tone rules:
- Short sentences dominate. Vary rhythm with occasional longer ones
- Direct address: "you" constantly. "What if I told you..." / "Here's what you do..."
- Pattern interrupts in opening slides. Bold claims that stop the scroll
- No hedging: "this will" not "this might"
- Repeat the key takeaway differently at least twice per script block
- Use concrete examples, not abstract concepts

What to avoid:
- Academic or formal language
- "In this video, we will explore..." type intros
- Passive voice
- Filler phrases: "it's important to note that", "as we discussed earlier"

### Transition Line

Last line of every speaker note. Tells the editor (or Mamoun) what comes next.

```
[TRANSITION: Quick cut]
[TRANSITION: Next slide]
[TRANSITION: "Now let's talk about deployment"]
[TRANSITION: Step 7]
```

## Script Density

Each slide's script should feel complete on its own. Someone reading just one slide's notes should understand the full message for that segment without needing context from other slides.

For step slides, the script should cover:
1. What this step does (one sentence)
2. Why it matters (one sentence)
3. How to do it (the bulk of the script)
4. Common mistake or pro tip (optional but powerful)

## Arabic Speaker Notes

Same structure, Gulf Arabic conversational tone. Stage directions stay in Arabic:

```
SCRIPT (M:SS - M:SS)

[الطاقة: عالية. مباشر للكاميرا]

"النص المنطوق هنا..."

[الانتقال: القطع السريع]
```

Arabic script rules:
- Gulf Arabic, not MSA formal
- Mix English tech terms naturally (Claude, MicroSaaS, deploy, etc.)
- Same timestamp ranges as the English version
- Same density: complete script per slide, not bullet prompts
- Same stage direction pattern, just translated

### Arabic Stage Direction Reference

```
[الطاقة: عالية]           = [ENERGY: High]
[الطاقة: هادئة. وضع التعليم]  = [ENERGY: Calm. Teaching mode.]
[اقترب: هذه النقطة المهمة]   = [LEAN IN: Key insight]
[توقف للتأثير]             = [PAUSE for emphasis]
[عرض الشاشة]              = [SHOW SCREEN]
[الانتقال: القطع السريع]     = [TRANSITION: Quick cut]
[الانتقال: الخطوة التالية]    = [TRANSITION: Next step]
```

## Example: Title Slide Script

```
SCRIPT (0:00 - 0:45)

[ENERGY: High. Direct to camera. Pattern interrupt.]

"What if I told you that you can go from zero, no technical co-founder, no coding skills, no funding, to a shipped, working SaaS product... in a single weekend?

Not a landing page. Not a Figma mockup. A real product that people can sign up for and use.

My name is Mamoun Alamouri. I spent 20 years selling enterprise tech at Cisco, Avaya, and Uniphore. I'm NOT a developer. And over the past year, I've built multiple SaaS products using nothing but Claude and structured context files.

9 steps. That's all it takes. Let's go."

[TRANSITION: Quick cut]
```

## Example: Step Slide Script

```
SCRIPT (8:00 - 10:00)

[ENERGY: Teaching mode. Methodical.]

"Step 3: Build your context files. This is where 90% of people fail because they skip it.

Claude is powerful, but it has no memory between conversations unless you give it context. Your job: create a set of structured files that tell Claude everything about your project.

You need these files: a project brief that defines the problem, a technical requirements doc, user stories, and a CLAUDE.md file that acts as the project's operating manual.

Here's the key insight most people miss: the quality of what Claude builds is directly proportional to the quality of context you give it. Garbage in, garbage out. But structured context in? Magic out.

I spend 2-3 hours on context files before I write a single line of code. That investment saves 20 hours of back-and-forth later."

[TRANSITION: Step 4]
```
