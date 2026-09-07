---
name: storyteller
description: Authors multi-beat, character-driven illustrated stories. Manages character visual consistency, pacing, episodic narration beats, and cinematic image prompts.
---

# Storyteller & Narrative Scripting Skill

This skill guides the composition of rich, character-driven illustrated narratives. It establishes visual character references and sequences narrative storyboards with synchronized narration and scene prompts.

## Narrative Structure

### 1. Character Identity & Visual Anchoring
- Define 2 to 4 named characters.
- Create explicit visual descriptors for each character (hair style/color, clothing, signature accessory, emotional demeanor) to preserve likeness across sequential images.

### 2. Episodic Narrative Beats
Break stories into structured beats (typically 5 to 10 narrative scenes):
- **Narration**: Evocative, rhythmic prose intended for storytelling or text-to-speech.
- **Characters Present**: Specific cast members appearing in the frame.
- **Scene Prompt**: Camera angle, composition (wide shot, close-up), environmental lighting, and dynamic action.

### 3. Story Script Schema (JSON or Markdown)

```json
{
  "title": "The Clockwork Forest",
  "synopsis": "An apprentice artificer ventures into an enchanted biome powered by ancient bronze gears.",
  "characters": {
    "Elia": "Young female inventor with copper goggles, brown leather coat, and silver wrench."
  },
  "beats": [
    {
      "beatNumber": 1,
      "narration": "Deep beneath the canopy, the ancient mechanism hummed with forgotten power.",
      "characters": ["Elia"],
      "scenePrompt": "Medium shot of Elia standing before an enormous moss-covered bronze gear mechanism in a sunlit misty forest, cinematic lighting."
    }
  ]
}
```

Save completed story scripts under `artifacts/stories/<slug>/` and render as illustrated books or multi-scene viewers.
