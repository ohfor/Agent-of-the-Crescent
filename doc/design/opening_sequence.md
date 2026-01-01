# Agent of the Crescent - Opening Sequence

## Stage 1 Implementation: Message Box Narrative

When the player selects the "Agent of the Crescent" start from Alternate Perspective, the following sequence plays before spawning them in Beggar's Row.

### Technical Flow
1. Player selects start option from AP dragon menu
2. Screen fades to black
3. Message box sequence plays (player clicks through)
4. Player spawns in Beggar's Row
5. Quest starts at Stage 10
6. Starting items added to inventory

---

## Message Box Sequence

### Box 1 - The Void
> *Darkness.*
> 
> *Not the comfortable darkness of shadow, but the cold emptiness of failure. Of purgatory. Of a soul suspended between punishment and oblivion.*
>
> *[Continue]*

### Box 2 - The Memory
> *You remember... fragments. An oath spoken in twilight. A duty sworn in shadow. A moment when steel flashed in darkness, when a choice hung in the air like held breath.*
>
> *A blade falling. A brother's betrayal. A Key vanishing into treacherous hands.*
>
> *You remember having the chance to act.*
>
> *You remember hesitating.*
>
> *[Continue]*

### Box 3 - The Judgment
> *And then: HER voice. Cold as moonless night, vast as the space between stars.*
>
> *"You failed me."*
>
> *Not angry. Something worse. Disappointed. Calculating. A goddess weighing the worth of a broken tool.*
>
> *[Continue]*

### Box 4 - The Sentence
> *"Your soul belongs to me. It always has. I could unmake you utterly - a shadow dispersed, aware of nothing, forever."*
>
> *"But I am not wasteful. The Key remains lost. The betrayer still breathes. And you... you owe me a debt that can only be paid in service."*
>
> *[Continue]*

### Box 5 - The Price
> *"I strip from you everything you were. Your skills. Your strength. Your very name. You will be nothing - less than nothing. A beggar in the gutters of Riften."*
>
> *"Find the Guild. Find the betrayer. Return my Key."*
>
> *"Succeed, and you may yet know my favor again. Fail..."*
>
> *[Continue]*

### Box 6 - The Awakening
> *The memory fades. Decades compress into moments.*
>
> *Darkness gives way to different darkness - damp stone, the smell of sewage, distant dripping. The weight of a mortal body, weak and hungry.*
>
> *You are in Riften. You are no one. You have nothing.*
>
> *But clutched in your hand, cold metal. And in the back of your mind, shadows whisper of what must be done.*
>
> *[Begin]*

---

## Lore Considerations

### What We Know (Canon)
- The Nightingale Trinity always consists of exactly THREE members
- At the time of Gallus's murder: Gallus, Mercer Frey, Karliah
- Nightingales are bound to guard the Twilight Sepulcher
- Nocturnal's relationship with her servants is transactional, not devotional
- The Evergloam is Nocturnal's plane of Oblivion
- Gallus was murdered ~25 years before 4E 201
- The murder weapon is never specified in canon

### What We Deliberately Keep Vague
- The player's exact role in past events
- Whether they held any formal title or position
- How exactly they were "positioned to act"
- Why they hesitated
- The specific nature of their punishment

This ambiguity serves multiple purposes:
1. Avoids contradicting the established Trinity lore
2. Allows player projection and interpretation
3. Creates mystery that can be revealed (or not) later
4. Gives us flexibility for future narrative development

### The "Agent of the Crescent" Title
This is NOT a title the player held in the past. Rather, it represents:
- Their current role as Nocturnal's agent of change
- The crescent moon symbolism (waxing toward fullness/redemption)
- Their mission to restore what was broken

The player becomes the Agent of the Crescent through their redemption arc - they weren't one before.

---

## Stage 2 Enhancement: Voiced Nocturnal Scene

In Stage 2, we could replace Boxes 3-5 with an actual scene in a custom void space where Nocturnal's presence manifests.

### Scene Description (Future Implementation)
- Player loads into a void/shadow space (not the actual Sepulcher)
- Nocturnal's presence manifests (shadow tendrils, disembodied voice, or spectral form)
- Camera work emphasizes her power and the player's insignificance
- Voiced dialogue plays (or subtitled if no VA)
- Visual effects: creeping shadows, oppressive darkness
- After dialogue, player "dissolves" into shadow
- Fade to black, then spawn in Beggar's Row

### Draft Dialogue Script (For Future Voice Acting)

**NOCTURNAL:**
*(cold, measured)*
*"Ah. You're aware again. Good."*

*(pause)*
*"Do you know how long you've drifted in my realm? No? Time means little to shadows. Or to the damned."*

*"You remember fragments, don't you? The moment when everything could have been different. When one decisive act might have preserved what was mine."*

*"Don't speak. I didn't summon your consciousness to hear excuses."*

*(tone shifts - harder)*
*"The one called Mercer Frey stole more than a life that night. He took the Skeleton Key. MY Key. And you - you had the chance to stop him."*

*"But you hesitated. Perhaps you weren't certain. Perhaps you were weak. The reason doesn't matter. Only the failure."*

*(businesslike)*
*"I could unmake you. It would be trivial. But I am pragmatic, if nothing else. The Key must return. The betrayer must fall. And you... you owe me a debt that can only be paid in service."*

*"I'm giving you back to the mortal world. Stripped of everything you were. No skills. No name. No identity. You'll wake in the gutters of Riften with nothing but rags and purpose."*

*"Find the Guild. Rise among them. And when you finally face the betrayer..."*

*(pause, emphasis)*
*"...do not hesitate again."*

*"Succeed, and I may restore what you've lost. Fail me twice..."*

*(cold finality)*
*"...and there won't be enough of you left to suffer."*

*"Go."*

---

## Alternative: Dream Sequence (Stage 2 Lite)

If the full voiced scene is too ambitious, an intermediate option:

- Player spawns in Beggar's Row first
- After first sleep (using OnSleepStop event), a "dream" sequence plays
- Dream uses message boxes or image slides to show fragmented memories
- Nocturnal's dialogue appears as text overlays
- Player wakes with a clearer understanding of their mission
- Could include flashes of visual "memories" (Gallus's ghost model, the Skeleton Key, etc.)

This is simpler than a full scene but more immersive than just startup message boxes.

---

## Spawn Location Details

### Cell: `RiftenBeggarRow`
### Spawn Point: XMarker placed in a discrete corner
- Near one of the bedrolls (thematically appropriate - you've been sleeping here)
- Against a wall (safe from NPC pathing issues)
- Facing toward the main area (easy orientation)

### Time of Day
- Set to early morning (~6 AM) - you're "waking up"
- Alternatively, let AP handle this naturally

### Player State on Spawn
- Standing position
- Default facing
- No active effects
- Survival stats at baseline (if survival mods active)

---

## Starting Equipment

| Item | Purpose |
|------|---------|
| Ragged Robes | Starting armor - you're destitute |
| Ragged Footwraps | Footwear - barely functional |
| Tarnished Nightingale Insignia | Quest item - link to your past |

### The Tarnished Insignia
- A MiscObject (weightless, no value)
- Cannot be sold or dropped (quest item flag)
- Description hints at its significance without explaining
- Will be relevant later in the questline (transformation to Restored Insignia)

---

## JSON Registration (Alternate Perspective)

```json
{
  "mod": "AgentOfTheCrescent.esp",
  "id": "0xD67",
  "text": "Agent of the Crescent",
  "description": "A soul in shadow, bound by an oath half-remembered. Nocturnal offers one chance at redemption - find the betrayer, return what was stolen, or fade into nothing.",
  "color": "0x9B59B6"
}
```

---

## Current Implementation Status

### Stage 1 MVP (COMPLETE)
- [x] Four message boxes displaying dream sequence
- [x] Player spawns in Beggar's Row
- [x] Starting equipment granted
- [x] Tarnished Insignia in inventory
- [x] Quest initializes correctly via AP

### Stage 2 (PLANNED)
- [ ] Expand to full 6-box sequence
- [ ] Add visual/audio elements if possible
- [ ] Consider voiced implementation
- [ ] Add starting note with guidance

### Future Considerations
- Integration with Wintersun (auto-set Nocturnal as deity?)
- Opening scene in custom cell
- Memory flashbacks during gameplay
- Connection to main Thieves Guild questline events
