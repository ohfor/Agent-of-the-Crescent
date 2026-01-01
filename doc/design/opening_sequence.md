# Shadow's Redemption - Opening Sequence

## Stage 1 Implementation: Message Box Narrative

When the player selects the "Nocturnal's Fallen" start from Alternate Perspective, the following sequence plays before spawning them in Beggar's Row.

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
> *Not the comfortable darkness of shadow, but the cold emptiness of failure. Of purgatory. Of a soul suspended between punishment and purpose.*
>
> *[Continue]*

### Box 2 - The Memory
> *You remember... fragments. A title: Nightingale. A duty: guardian of twilight. A moment: steel in darkness, a choice unmade, a betrayer unspoken.*
>
> *You remember Gallus falling. You remember the Key vanishing into treacherous hands. You remember having the chance to stop it.*
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
> *"Your soul belongs to me. It always has. I could cast you into the Evergloam for eternity - a shadow among shadows, aware but powerless, forever."*
>
> *"But I am not wasteful. The Key remains lost. The betrayer breathes still. And you... you will have the chance to correct your failure."*
>
> *[Continue]*

### Box 5 - The Price
> *"I strip from you everything you were. Your skills. Your power. Your very name. You will be nothing - less than nothing. A beggar in the gutters of Riften."*
>
> *"Earn back what you have lost. Find the Guild. Find the betrayer. Return my Key."*
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
> *But somewhere in the back of your mind, shadows whisper. And you remember what must be done.*
>
> *[Continue]*

### Box 7 - Final (Optional - Game Tips)
> *You have begun Shadow's Redemption.*
>
> *• Find the Thieves Guild by seeking Brynjolf in Riften's marketplace*
> *• Steal and survive - prove your worth through shadow's work*
> *• Check your inventory for a note with guidance*
>
> *[Begin]*

---

## Stage 2 Enhancement: Voiced Nocturnal Scene

In Stage 2, we could replace Boxes 3-5 with an actual scene in a cloned Twilight Sepulcher interior where Nocturnal's manifestation speaks to the player.

### Scene Description (Future Implementation)
- Player loads into cloned Sepulcher inner sanctum
- Nocturnal's manifestation (giant spectral form) appears
- Camera focuses on her
- Voiced dialogue plays (or subtitled if we don't have VA)
- Visual effects: shadow tendrils, oppressive darkness at edges of screen
- After dialogue, screen whites out / player "dissolves"
- Fade to black, then spawn in Beggar's Row

### Dialogue Script (For Future Voice Acting)

**NOCTURNAL:**
*"Ah. You're aware again. Good."* (pause)
*"Do you know how long you've drifted in my realm? No? Time means little to the dead. Or the damned."*

*"Gallus Desidenius. You remember the name, don't you? You watched him die. You COULD have prevented it."*

*"Don't speak. I didn't summon your consciousness to hear excuses."*

*"The one called Mercer Frey stole more than a life that night. He took the Skeleton Key. MY Key. The lock of limitless potential, now in the hands of a mortal too stupid to understand what he possesses."*

*"And you - my trusted agent - you had the chance to stop him. One blade in the dark. One decisive moment."*

*"But you hesitated. Perhaps you didn't want to kill a fellow Nightingale without proof. Perhaps you were weak. The reason doesn't matter. Only the failure."*

(tone shifts - colder, more business-like)

*"I could unmake you. It would be trivial. But I am pragmatic, if nothing else. The Key must return. Frey must fall. And you... you owe me a debt that can only be paid in service."*

*"I'm giving you back to the mortal world. Stripped of everything you were. No skills. No name. No identity. You'll wake in the gutters of Riften with nothing but rags and purpose."*

*"Find the Guild. Rise among them. And when you finally face the betrayer - do not hesitate again."*

*"Succeed, and I may restore what you've lost. Fail me twice..."* (pause) *"...and there won't be enough of you left to suffer."*

*"Go."*

(scene ends)

---

## Alternative: Dream Sequence

If the voiced scene is too ambitious even for Stage 2, an intermediate option:

- Player spawns in Beggar's Row first
- After first sleep (using OnSleepStop event), a "dream" sequence plays
- Dream uses message boxes or image slides to show fragmented memories
- Nocturnal's dialogue appears as text overlays
- Player wakes with a clearer understanding of their mission

This is simpler than a full scene but more immersive than just startup message boxes.

---

## Spawn Location Details

### Cell: `RiftenBeggarRow`
### Specific Position: 
Need to identify safe spawn coordinates. Candidates:
- Near one of the bedrolls (thematically appropriate - you've been sleeping here)
- Against a wall in a corner (safe from any NPC pathing)
- Near the entrance (easy orientation)

### Time of Day
Set to early morning (6 AM?) - you're waking up

### Weather
N/A (interior cell)

### Player State on Spawn
- Standing position
- Looking toward exit
- No active effects
- Hunger/Cold/etc. at baseline if survival mods active

---

## Quest Initialization Script (Pseudocode)

```papyrus
Event OnInit()
    ; Called when quest starts
    
    ; Give starting items
    Game.GetPlayer().AddItem(SR_TarnishedInsignia, 1)
    Game.GetPlayer().AddItem(SR_NocturnalReminder, 1)
    Game.GetPlayer().AddItem(ClothesBeggarRobes, 1)
    Game.GetPlayer().AddItem(ClothesBeggarBoots, 1)
    Game.GetPlayer().AddItem(Apple, 1) ; or custom bruised apple
    
    ; Equip beggar clothes
    Game.GetPlayer().EquipItem(ClothesBeggarRobes)
    Game.GetPlayer().EquipItem(ClothesBeggarBoots)
    
    ; Remove any default items AP might give
    ; (investigate what AP does by default)
    
    ; Set Wintersun deity to Nocturnal
    ; (implementation depends on Wintersun API)
    
    ; Start tracking
    SetStage(10)
    
    ; Register for events
    RegisterForSingleUpdate(5.0) ; Start tracking loop after 5 seconds
EndEvent
```

---

## Character Background Text

For character creation or any "background" field if AP supports it:

> *Once a Nightingale, an elite agent of Nocturnal herself. When Mercer Frey betrayed the Thieves Guild and murdered Gallus Desidenius, you were positioned to intervene - and failed to act. For decades, your soul has paid the price. Now Nocturnal offers one chance at redemption: return the stolen Skeleton Key and bring down the betrayer, or fade into nothing.*
