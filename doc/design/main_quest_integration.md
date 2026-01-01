# Main Quest Integration - The Dragon Crisis Connection

## Overview

This document specifies how Agent of the Crescent connects to Skyrim's Main Quest, providing narrative weight to the dragon crisis through Nocturnal's perspective while remaining fully resilient to any player progression state.

**Core Principle:** We assume nothing about the player's MQ progress. They may have never seen a dragon, may be mid-MQ, or may have already defeated Alduin. Our systems detect and adapt.

---

## Cosmological Stakes: Why Nocturnal Cares

### The World-Eater's Aberration

In Elder Scrolls cosmology, Alduin serves a specific function: to devour the world at the end of each kalpa (cosmic cycle), allowing creation to begin anew. The Daedric Princes, existing outside Mundus, would persist through this transition.

But this Alduin has **abandoned his ordained role**. He seeks to **rule** Mundus, not end it. This changes everything.

### The Threat to Shadow

A world conquered by Alduin would be:
- **Eternal dragonfire** - perpetual light that burns away darkness
- **Rule by fear of dragons** - mortals no longer fear the dark, they fear the sky
- **Secrets made meaningless** - only raw power matters under dragon dominion
- **Shadows burned away** - no night, no hiding, no theft

**The fundamental problem:** Shadows cannot exist without darkness. Darkness cannot exist in a world of eternal fire.

### The Evergloam's Grip

Nocturnal's realm, the Evergloam, exists in perpetual twilight. Its connection to Mundus depends on mortals:
- Fearing the dark
- Keeping secrets
- Working in shadow
- Believing in hidden things

If Alduin's vision succeeds, these concepts wither. The Evergloam's influence over Mundus **fades**. Nocturnal's agents, her Nightingales, her thieves - all lose their power as the very concept of shadow loses meaning.

This gives Nocturnal genuine existential stakes without making her seem weak or subservient to Aedric concerns. She's not afraid of Alduin personally - she's afraid of what his success means for her sphere of influence.

---

## Entry Points: Beyond Alternate Perspective

### Primary Entry: Alternate Perspective Start

The designed path - player selects our start in AP's menu, begins in Beggar's Row, progresses through the full AotC questline.

### Secondary Entry: Nocturnal's Calling (Non-AP Players)

For players not using Alternate Perspective, we need an organic discovery path.

**Trigger Conditions:**
- Player is NOT in AotC questline already
- Player has completed "Darkness Returns" (TG09) - returned the Skeleton Key
- Player has NOT completed MQ ("Dragonslayer")

**The Hook:**
After returning the Skeleton Key, during the player's next sleep, they experience a dream:

> *Darkness. Not the comforting darkness of shadow, but void.*
> 
> *A voice - cold, ancient, knowing.*
> 
> *"You returned what was stolen. You walked the Pilgrim's Path. You proved yourself worthy of my attention."*
> 
> *A pause. Something shifts in the void.*
> 
> *"But worthiness is not enough. The World-Eater stirs. Dragons return. If they succeed, there will be no shadows left for thieves to work in."*
> 
> *"Find me in the Sepulcher. We have much to discuss."*
> 
> *You wake with a weight on your chest. Looking down, you find a tarnished silver insignia clutched in your hand - cold metal that wasn't there when you fell asleep.*

**Result:**
- Player receives `AotC_TarnishedInsignia`
- Quest "Shadow's Calling" starts (simplified version of AotC for non-AP players)
- Player is directed to the Twilight Sepulcher

**Design Note:** This path skips the redemption arc (player already proved themselves by returning the Key) and jumps directly to the MQ integration content. It's a "late entry" that respects the player's existing accomplishment.

### Tertiary Entry: Post-MQ Acknowledgment

For players who defeat Alduin BEFORE engaging with our content:

**Trigger Conditions:**
- Player completes "Dragonslayer" (MQ17)
- Player later completes "Darkness Returns" (TG09)

**The Hook:**
Same dream trigger as above, but different content:

> *"You returned what was stolen. And you... you ended the World-Eater."*
> 
> *The voice sounds almost surprised. Almost impressed.*
> 
> *"The shadows endure because of you, though you did not know it. The fire that would have burned away all darkness is quenched."*
> 
> *"I would know the one who saved my realm without even meaning to. Come to the Sepulcher."*

**Result:**
- Player receives `AotC_TarnishedInsignia` (or upgraded version)
- Quest "Shadow's Gratitude" starts (acknowledgment/reward path)
- Nocturnal offers blessings for service already rendered

---

## The Waning Moon: Post-Redemption Questline

This content activates after the player completes Stage 70 of AotC_MainQuest (full redemption). It bridges the Thieves Guild story to the dragon crisis.

### Detection Logic

Before triggering any Waning Moon content, we check MQ state:

```
MQ State Detection:
├── MQ17 Complete? (Dragonslayer)
│   └── YES → Path C: Post-MQ Acknowledgment
│   └── NO → Continue checking...
├── MQ02 Complete? (Dragon Rising - first dragon killed)
│   └── YES → Path A: Player is Dragonborn
│   └── NO → Continue checking...
├── MQ01 Complete? (Before the Storm - Helgen)
│   └── YES → Path B-1: Pre-Dragonborn, Helgen witnessed
│   └── NO → Path B-2: Dragons not yet encountered
```

### Path A: The Dragonborn Agent

**Condition:** Player has absorbed at least one dragon soul (MQ02+ complete)

This is the most common scenario. The player is confirmed Dragonborn.

#### Stage 80 - The Waning Moon

**Trigger:** 24-48 hours after Stage 70 completion

**Dream Sequence:**

> *The Evergloam stretches before you - familiar now, almost welcoming. But something is wrong.*
> 
> *The perpetual twilight flickers. Above the horizon, a tear in the sky leaks fire.*
> 
> *Nocturnal's voice comes strained, distant:*
> 
> *"My Agent. You have redeemed yourself. The shadows know you again. But your work is not done."*
> 
> *"The World-Eater returns to Mundus. He seeks not to end this kalpa but to rule it. A world of dragons. A world of fire. A world where shadows cannot exist."*
> 
> *The tear widens. Heat presses against your face.*
> 
> *"I know what you are. Dragonborn. Devourer of dragon souls. You carry the only weapon that can end him."*
> 
> *"Do what you were born to do. End the World-Eater. Save the shadows."*
> 
> *"And know that when you face him, you do not face him alone. The Evergloam stands with you."*
> 
> *The fire grows brighter—*
> 
> *You wake.*

**Journal Entry:**

> *Another dream from Nocturnal. Another task - but this one I was already bound to.*
> 
> *She knows I am Dragonborn. She showed me what Alduin's victory would mean: not just the death of Skyrim, but the death of shadow itself. No darkness. No secrets. No night for thieves to work.*
> 
> *The dragon crisis isn't just about saving the world. It's about preserving the very concept of darkness.*
> 
> *Nocturnal promises aid. I don't know what form that will take, but knowing the shadows themselves have stakes in this fight... it changes things.*

**Reward Granted:**

**Ability: "Evergloam's Shroud"**
- Type: Lesser Power (once per day)
- Effect: For 60 seconds, dragons cannot detect you while sneaking
- Lore: The shadows of the Evergloam cloak you from the fire-born

**Objectives:**

- [ ] Defeat Alduin, the World-Eater

*(No quest markers - this ties to existing MQ, not a new dungeon)*

---

#### Stage 85 - Shadow's Vigil (Optional Mid-MQ Check-in)

**Trigger:** Player completes "Alduin's Bane" (MQ13 - learns Dragonrend)

This is a subtle acknowledgment that the player is progressing.

**Insignia Pulse + Message:**

> *The Insignia grows warm against your chest. Not hot - comforting. Encouraging.*
> 
> *A whisper, barely audible:*
> 
> *"You carry the words that ground the World-Eater. Use them well. The shadows watch."*

**No mechanical reward** - just narrative reinforcement that Nocturnal is paying attention.

---

#### Stage 90 - The World-Eater Falls

**Trigger:** Player completes "Dragonslayer" (MQ17 - Alduin defeated)

**Dream Sequence (that night's sleep):**

> *The Evergloam is still. Peaceful. The tear in the sky has healed.*
> 
> *Nocturnal's presence surrounds you - vast, cold, but... satisfied.*
> 
> *"It is done. The World-Eater is cast beyond the reach of Mundus. The fire recedes. The shadows endure."*
> 
> *"You have done what I could not. What no Daedric Prince could. You walked into the fire and emerged with the dragon's death on your hands."*
> 
> *The twilight deepens around you. It feels like an embrace.*
> 
> *"My Agent. My Crescent, now waxing toward fullness."*
> 
> *The Insignia blazes with cold light - not painful, but profound. Transformative.*
> 
> *"You have earned more than redemption. You have earned my eternal favor."*
> 
> *"When the time comes to leave your mortal shell, you will not face the uncertainty of Aetherius or the chaos of Oblivion's depths. You will come home. To the Evergloam. To serve at my side, in shadow, forever."*
> 
> *A pause. Almost warm.*
> 
> *"But that is far from now. Live. Steal. Prosper in darkness. And remember..."*
> 
> *"The shadows will always remember you."*
> 
> *You wake. The Insignia gleams like new silver against your chest.*

**Journal Entry:**

> *Alduin is dead. The World-Eater cast beyond Mundus, perhaps forever.*
> 
> *Nocturnal came to me in dreams one final time. She showed me the Evergloam healed, the fire gone, the shadows restored. She offered something I never expected: gratitude.*
> 
> *And a promise. When I die - truly die - I will not face the unknowns of Sovngarde or the Soul Cairn or whatever waits for mortals. I will go to the Evergloam. To serve Nocturnal eternally, in shadow.*
> 
> *Some might call that a curse. But after everything I've done, everything I've redeemed... it feels like coming home.*
> 
> *My Insignia has transformed. No longer tarnished. No longer merely restored. It gleams with something new - a symbol not of past failure, but of future purpose.*
> 
> *Agent of the Full Moon. That's what she called me. The crescent has waxed complete.*

**Rewards:**

1. **Insignia Final Transformation:**
   - `AotC_RestoredInsignia` → `AotC_FullMoonInsignia`
   - All previous bonuses PLUS:
   - Muffle effect while sneaking
   - 10% chance to become invisible for 3 seconds when hit
   - Subtle shadow particle visual effect

2. **Passive Ability: "Nocturnal's Chosen"**
   - Permanent +15% better prices with fences
   - Permanent +10% pickpocket chance
   - Dragons deal 10% less damage to you (lingering Evergloam protection)

3. **Afterlife Confirmation:**
   - Narrative only, but significant for roleplay
   - Upon death, player's soul goes to the Evergloam
   - Could theoretically tie into death alternative mods, but not required

**Quest Completes:** AotC_WaningMoon marked complete. Total AotC experience finished.

---

### Path B: Pre-Dragonborn States

For players who haven't triggered Dragon Rising yet.

#### Path B-1: Helgen Witnessed (MQ01 complete, MQ02 not)

Player saw the dragon at Helgen but hasn't killed one yet.

**Stage 80 Dream (Modified):**

> *"The World-Eater returns. You witnessed his arrival at Helgen, though you may not have known what you saw."*
> 
> *"There is a prophecy. A Dragonborn who can consume dragon souls. The only mortal weapon against Alduin."*
> 
> *"Discover if you are this Dragonborn. Seek out the Greybeards. Answer their summons. If you carry the dragon blood... the shadows will need you more than ever."*

**Objectives:**
- [ ] Discover if you are Dragonborn
- [ ] Answer the Greybeards' summons (if applicable)

**Note:** This gently pushes the player toward MQ without forcing anything.

---

#### Path B-2: Dragons Not Yet Encountered

Player hasn't even triggered Helgen (using AP skip, or just hasn't gone there).

**Stage 80 Dream (Modified):**

> *"The World-Eater stirs. You may not have seen the signs yet, but dragons return to Skyrim."*
> 
> *"There is a prophecy. A Dragonborn who can end this threat. The shadows need this champion to succeed."*
> 
> *"Watch the skies. When the dragons come - and they will come - you may find yourself more connected to them than you expect."*
> 
> *"Or perhaps another will rise to face them. Either way, the shadows are invested in their defeat."*

**Objectives:**
- [ ] Learn more about the dragon threat

**Note:** This is the most hands-off version. We acknowledge the threat without pushing MQ at all. If the player never engages MQ, the quest simply remains open - no failure state.

---

### Path C: Post-MQ (Alduin Already Defeated)

Player finished MQ before completing AotC Stage 70.

**Stage 80 (Immediate, no delay):**

> *The Evergloam opens before you - but different than you expected. Whole. Peaceful. Twilight undisturbed.*
> 
> *Nocturnal's voice carries surprise:*
> 
> *"You... you have already ended the World-Eater."*
> 
> *A long pause.*
> 
> *"The fire that threatened to consume all shadow is quenched. The Evergloam endures. And you - my newly redeemed Agent - you are the reason."*
> 
> *"You did not know the stakes. You could not have known what Alduin's victory would have meant for the realm of darkness. Yet you ended him anyway."*
> 
> *The twilight seems to bow toward you.*
> 
> *"This changes much. You sought redemption for past failure. But you had already succeeded in a task I would have given you. The balance is... more than restored."*
> 
> *"You have my gratitude, Dragonborn. A rare gift from the Mistress of Shadows."*

**Journal Entry:**

> *When I completed my redemption, Nocturnal revealed something I never expected: the dragon crisis wasn't just about Skyrim. Alduin's victory would have burned away the very concept of shadow.*
> 
> *And I stopped him. Before I even knew what was at stake.*
> 
> *She called it "more than redemption." Said the balance was restored beyond what she'd asked. I'm not sure what that means for my future, but the look she gave me - if a Daedric Prince can look at anyone - was something I've never seen from her.*
> 
> *Gratitude. From the Mistress of Shadows herself.*

**Rewards:**
- Skip directly to Stage 90 rewards (Insignia transformation, Nocturnal's Chosen ability)
- Additional unique dialogue from Shadow Fence acknowledging the Dragonborn status
- No "in-progress" content needed since MQ is already done

---

## State Detection: Technical Implementation

### Global Variables

| Variable | Type | Purpose |
|----------|------|---------|
| `AotC_MQState` | Int | Cached MQ progress state (0-4) |
| `AotC_WaningMoonStarted` | Bool | Whether post-70 content has begun |
| `AotC_DragonbornConfirmed` | Bool | Player has absorbed a dragon soul |
| `AotC_AlduinDefeated` | Bool | MQ17 complete |

### MQ State Values

```
AotC_MQState:
0 = Unknown/Not Checked
1 = Pre-Helgen (MQ01 not complete)
2 = Post-Helgen, Pre-Dragon Rising (MQ01 done, MQ02 not)
3 = Dragonborn Confirmed (MQ02+ done, MQ17 not)
4 = Alduin Defeated (MQ17 done)
```

### Detection Script (Pseudocode)

```papyrus
Function UpdateMQState()
    Quest MQ17 = Game.GetFormFromFile(0x046EEE, "Skyrim.esm") as Quest ; Dragonslayer
    Quest MQ02 = Game.GetFormFromFile(0x02610C, "Skyrim.esm") as Quest ; Dragon Rising
    Quest MQ01 = Game.GetFormFromFile(0x03372B, "Skyrim.esm") as Quest ; Before the Storm
    
    If MQ17.IsCompleted()
        AotC_MQState.SetValueInt(4)
        AotC_AlduinDefeated.SetValueInt(1)
    ElseIf MQ02.GetStageDone(200) ; Dragon soul absorbed
        AotC_MQState.SetValueInt(3)
        AotC_DragonbornConfirmed.SetValueInt(1)
    ElseIf MQ01.IsCompleted()
        AotC_MQState.SetValueInt(2)
    Else
        AotC_MQState.SetValueInt(1)
    EndIf
EndFunction
```

### Trigger Points

State detection should run:
1. When AotC_MainQuest reaches Stage 70
2. When player sleeps (to catch MQ progress changes)
3. When player enters the Twilight Sepulcher

---

## Quest Structure: AotC_WaningMoon

### Properties

- **Quest ID:** `AotC_WaningMoon`
- **Quest Name:** "The Waning Moon"
- **Type:** Main Quest (miscellaneous display)
- **Start Game Enabled:** NO
- **Run Once:** YES

### Stages

| Stage | Name | Condition |
|-------|------|-----------|
| 0 | Not Started | Initial |
| 10 | Nocturnal's Warning | Dream delivered, player informed of dragon threat |
| 20 | Dragonborn Confirmed | Player has absorbed dragon soul |
| 30 | Dragonrend Learned | Optional mid-point acknowledgment |
| 40 | Alduin Defeated | World-Eater ended, rewards granted |
| 100 | Complete | Quest finished |
| 200 | Skipped (Post-MQ) | Player had already defeated Alduin |

### Stage Flow by Path

**Path A (Dragonborn):**
```
Stage 70 (MainQuest) → Stage 10 → Stage 20 → [Stage 30] → Stage 40 → Stage 100
```

**Path B-1/B-2 (Pre-Dragonborn):**
```
Stage 70 (MainQuest) → Stage 10 → [wait for MQ progress] → Stage 20 → Stage 40 → Stage 100
```

**Path C (Post-MQ):**
```
Stage 70 (MainQuest) → Stage 200 → Stage 100 (immediate rewards)
```

---

## Alternative Entry Quest: AotC_ShadowsCalling

For players not using Alternate Perspective who discover our content through the Thieves Guild.

### Properties

- **Quest ID:** `AotC_ShadowsCalling`
- **Quest Name:** "Shadow's Calling"
- **Type:** Miscellaneous
- **Start Game Enabled:** NO

### Trigger

Player completes TG09 (Darkness Returns) AND:
- AotC_MainQuest is NOT running
- AotC_StartQuest is NOT running
- Player sleeps

### Stages

| Stage | Name | Description |
|-------|------|-------------|
| 10 | Dream Received | Player gets Insignia, directed to Sepulcher |
| 20 | Sepulcher Visited | Player speaks with Nocturnal manifestation |
| 30 | Blessing Received | Nocturnal grants powers, explains dragon threat |
| 40 | Complete | Merges into WaningMoon quest |

### Design Note

This is a **compressed** version of AotC for players who proved themselves by returning the Key without our start. They skip:
- The redemption arc (already redeemed via Key return)
- The Offering system (already a Nightingale)
- Progressive power unlocks (get them all at once)

They gain:
- The Insignia and its bonuses
- The dragon crisis context
- Access to Waning Moon content
- The afterlife promise upon MQ completion

---

## Rewards Summary

### Evergloam's Shroud (Stage 80)

- **Type:** Lesser Power
- **Recharge:** Once per day
- **Effect:** Dragons cannot detect you while sneaking for 60 seconds
- **Visual:** Subtle shadow wisps around player

### Full Moon Insignia (Stage 90/Path C)

Transformation of the Restored Insignia into its final form.

**Stats:**
- Fortify Sneak 15%
- Fortify Pickpocket 15%
- Fortify Lockpicking 10%
- Muffle (constant, while worn)
- 10% chance on hit: Become invisible for 3 seconds

**Visual:** 
- Gleaming silver crescent with subtle shadow particles
- No longer tarnished or merely "restored" - actively radiant

### Nocturnal's Chosen (Stage 90/Path C)

- **Type:** Passive Ability
- **Effects:**
  - +15% better prices with fences
  - +10% pickpocket success chance  
  - Dragons deal 10% less damage to you
- **Lore:** The lingering favor of the Evergloam

### Afterlife Promise

- **Type:** Narrative/Roleplay
- **Effect:** Upon character death, soul goes to the Evergloam
- **Implementation:** Could trigger unique death message if using death alternative mods
- **Otherwise:** Purely narrative, but meaningful for character closure

---

## Dialogue Variations

### Shadow Fence - Post Stage 90

New greeting rotation after Alduin's defeat:

> *"The Dragon-Slayer. The Shadow-Keeper. You wear many titles now, little thief - though perhaps 'little' no longer applies."*

> *"The Evergloam remembers what you did. The fire that would have consumed us all... quenched by your hands."*

> *"Nocturnal speaks of you differently now. Not as a failed servant seeking redemption, but as a champion. It is... unusual."*

### Brynjolf - Post Stage 90 (If Lore Quest Complete)

If player completed "Shadows of the Past" AND Stage 90:

> *"I always knew you were different, lad/lass. But Dragonborn? Savior of the shadows themselves? Even I couldn't have guessed that."*
> 
> *"The Guild owes you more than we can ever repay. Nocturnal owes you. And me? I'm just glad I was right about you from the start."*

---

## Compatibility Notes

### Mods That Alter MQ

- **Alternate Start - Live Another Life:** Compatible - same state detection works
- **Skyrim Unbound:** May need patch - different MQ trigger mechanisms
- **ASLAL Addons:** Should work if they use standard MQ quests
- **Realm of Lorkhan:** Compatible - player can skip Helgen

### Mods That Alter Dragons

- **Deadly Dragons:** Compatible - doesn't change quest completion
- **Dragon Combat Overhaul:** Compatible
- **Diverse Dragons:** Compatible

### Mods That Alter Death

- **Death Alternative:** Could hook into afterlife promise
- **Ashes:** Could trigger Evergloam destination
- **Note:** These are "nice to have" patches, not requirements

---

## Implementation Priority

### Phase 1: Core Detection

1. [ ] MQ state detection script
2. [ ] State caching and update triggers
3. [ ] Basic dream delivery system

### Phase 2: Path A (Dragonborn)

1. [ ] Stage 80 dream content
2. [ ] Evergloam's Shroud power
3. [ ] Stage 85 mid-point message
4. [ ] Stage 90 completion sequence
5. [ ] Final Insignia transformation
6. [ ] Nocturnal's Chosen ability

### Phase 3: Paths B & C

1. [ ] Path B-1/B-2 dialogue variations
2. [ ] Path C post-MQ flow
3. [ ] Appropriate reward timing

### Phase 4: Alternative Entry

1. [ ] AotC_ShadowsCalling quest
2. [ ] TG09 completion detection
3. [ ] Compressed blessing sequence
4. [ ] Integration into Waning Moon

---

## Summary

The Waning Moon questline transforms Agent of the Crescent from a Thieves Guild redemption story into something with cosmological stakes. By connecting to the Main Quest, we give players additional motivation to face Alduin while respecting their agency and progression choices.

**Key Design Principles:**

1. **Assume Nothing:** Player could be at any MQ state
2. **Detect and Adapt:** Different content paths for different states
3. **Support, Don't Override:** Nocturnal's interest adds to MQ, doesn't replace it
4. **Reward Exploration:** Multiple entry points for different player types
5. **Meaningful Stakes:** The dragon crisis matters to shadows, not just mortals
6. **Satisfying Closure:** The afterlife promise gives finality to the character arc

The shadows remember. Now they have a reason to care about the fire in the sky.

---

*Last Updated: January 2026*
*Document Version: 1.0*
