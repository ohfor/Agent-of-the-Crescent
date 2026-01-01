# Shadow's Redemption - Technical Implementation Guide

## Overview

This document outlines the technical structure and implementation approach for Shadow's Redemption, a quest mod adding a narrative alternate start focused on redemption through the Thieves Guild questline.

---

## Plugin Structure

### File: `ShadowsRedemption.esp`
- **Type:** ESP flagged as ESL (ESL-flagged ESP)
- **Master Dependencies:**
  - Skyrim.esm
  - Update.esm
  - Dawnguard.esm (for Serana/vampire-related aliases if needed later)
  - AlternatePerspective.esp (soft dependency - we add start option)
  - Wintersun - Faiths of Skyrim.esp (soft dependency - for deity tracking)

### Record Count Estimate (Stage 1)
| Record Type | Count | Notes |
|-------------|-------|-------|
| Quest | 1 | Main quest |
| Book | 5 | Note + 4 courier letters |
| MiscItem | 1 | Tarnished Insignia |
| Armor | 1 | Restored Insignia (amulet) |
| Spell | 6 | 4 powers + passive + curse |
| MagicEffect | 6+ | Effects for spells |
| Perk | 0-2 | If needed for passive effects |
| Message | 10+ | Opening sequence + alerts |
| FormList | 2-3 | Tracking lists |
| GlobalVariable | 5-8 | Quest state tracking |
| Quest Alias | 3-5 | Player, courier, etc. |
| Script | 3-5 | Main quest + utilities |

**Total:** ~40-50 records - well within ESL limits (2048 new records)

---

## Quest Structure

### Quest: `SR_MainQuest`

```
Quest Properties:
- Name: Shadow's Redemption
- Type: Main Quest (side quest priority display)
- Start Game Enabled: NO (started by AP start selection)
- Run Once: YES
- Allow Repeated Stages: NO
```

### Quest Aliases

| Alias | Type | Fill Type | Purpose |
|-------|------|-----------|---------|
| PlayerRef | Reference | Force to Player | Track player |
| CourierRef | Reference | Find Matching | Courier for letters |
| NocturnalShrine | Reference | Specific | Twilight Sepulcher shrine |
| TGFactionRef | Faction | Specific | Thieves Guild faction |

### Quest Stages
See `quest_stages.md` for full stage documentation.

Key implementation notes:
- Stage conditions use GetStageDone checks on TG quests
- Stolen goods tracking uses vanilla stats (GetStatValue)
- Faction rank checks for Guild progression
- Global variables for offering completion tracking

---

## Integration: Alternate Perspective

### Adding a Custom Start

Based on how AP typically works, we need to:

1. **Register our start option** with AP's start system
2. **Define spawn location** (Beggar's Row)
3. **Define starting conditions** (items, quest start)
4. **Optionally define a start category** ("Outcast" or "Fallen" perhaps)

Likely implementation approaches:
- AP may have a FormList or Keyword system for registering starts
- Or we may need to add a Quest Stage to AP's controller quest
- Worst case: we patch AP directly (less compatible)

**ACTION NEEDED:** Examine AP source scripts to understand registration system

### Spawn Handling

```papyrus
; Pseudocode for start handling

Function StartNocturnalFallen()
    ; Move player to Beggar's Row
    Game.GetPlayer().MoveTo(BeggarRowMarker)
    
    ; Initialize quest
    SR_MainQuest.Start()
    
    ; Set time of day
    GameHour.SetValue(6.0) ; 6 AM
    
    ; Remove AP default items if any
    ; Add our items
    ; Show opening sequence
EndFunction
```

---

## Integration: Wintersun

### Deity Tracking

Wintersun uses a global variable or actor value to track current deity. We need to:

1. **On quest start:** Set player's deity to Nocturnal
2. **Periodically:** Check if deity has changed
3. **On change attempt:** Warn player
4. **On confirmed change:** Fail quest, apply curse

### Implementation Options

**Option A: Polling**
```papyrus
Event OnUpdate()
    ; Check deity every N seconds
    If !IsPlayerWorshippingNocturnal()
        HandleDeityChange()
    EndIf
    RegisterForSingleUpdate(30.0) ; Check every 30 seconds
EndEvent
```

**Option B: Event Hook**
If Wintersun sends mod events when deity changes, register for those.

**Option C: Shrine Activation**
Hook shrine activation and intercept if player tries to adopt new deity.

**ACTION NEEDED:** Investigate Wintersun's script structure to determine best approach

### Setting Initial Deity

```papyrus
; Need to find Wintersun's API for this
; Possibilities:
; - Global variable: WS_CurrentDeity
; - Actor value
; - Quest stage
; - ModEvent
```

---

## Tracking Systems

### Stolen Goods Tracking

Vanilla provides `StatsStolen` tracked stat. Access via:
```papyrus
Int stolen = Game.QueryStat("Items Stolen")
Int value = Game.QueryStat("Value of Items Stolen") ; Not sure if this exists
```

**Alternative:** Track fence gold through TG fencing statistics if available.

**Fallback:** Create our own tracking by hooking container theft events (complex, avoid if possible).

### Offering Completion Tracking

Use a GlobalVariable as bitmask:
```papyrus
GlobalVariable Property SR_OfferingsComplete Auto

Function CompleteOffering(Int offeringBit)
    Int current = SR_OfferingsComplete.GetValueInt()
    SR_OfferingsComplete.SetValueInt(current | offeringBit)
    CheckOfferingProgress()
EndFunction

Function CheckOfferingProgress()
    Int offerings = SR_OfferingsComplete.GetValueInt()
    Int count = CountBits(offerings)
    ; Update objectives based on count
EndFunction
```

### Pickpocket Tracking
Vanilla stat: `Pockets Picked`
```papyrus
Int picked = Game.QueryStat("Pockets Picked")
```

### TG Job Tracking
Need to check TG quest variables or use a counter we increment via story manager event.

---

## Courier System

### Letter Delivery

Use vanilla courier system or custom approach:

**Option A: Vanilla Courier Quest Injection**
- Add our letters to the courier's package via script
- Trigger courier approach

**Option B: Custom Delivery**
- Create simple script that adds letter to player inventory
- Show notification "A courier has delivered a letter"
- Less immersive but simpler

**Option C: Story Manager Event**
- Hook into story manager
- Register for appropriate trigger (entering city, passing time, etc.)
- Spawn courier naturally

Stage 1 recommendation: Option B (simplest). Stage 2 can upgrade to Option A or C.

```papyrus
Function DeliverLetter(Book letterForm)
    Game.GetPlayer().AddItem(letterForm, 1)
    Debug.Notification("A mysterious letter has found its way into your possession...")
EndFunction
```

---

## Powers Implementation

### Shadow's Whisper (Detect Life variant)

```
SPELL: SR_ShadowWhisper
- Type: Lesser Power
- Cast Type: Fire and Forget
- Delivery: Self
- Cooldown: 24 hours (use perk or script)

MAGIC EFFECT: SR_ShadowWhisperEffect
- Base: Detect Life
- Magnitude: 200+ (large radius)
- Duration: 30 seconds
- Archetype: Detect Life
```

### Shadow's Step (Invisibility)

```
SPELL: SR_ShadowStep
- Type: Lesser Power
- Cast Type: Fire and Forget
- Delivery: Self
- Cooldown: 24 hours

MAGIC EFFECT: SR_ShadowStepEffect
- Base: Invisibility
- Duration: 15 seconds
```

### Shadow's Embrace (Movement Burst)

For Stage 1, implementing teleport is complex. Use speed burst instead:

```
SPELL: SR_ShadowEmbrace
- Type: Lesser Power
- Cast Type: Fire and Forget
- Delivery: Self
- Cooldown: 24 hours

MAGIC EFFECT: SR_ShadowEmbraceSpeed
- Archetype: Value Modifier
- Actor Value: SpeedMult
- Magnitude: 200 (triple speed)
- Duration: 5 seconds

MAGIC EFFECT: SR_ShadowEmbraceMuffle
- Archetype: Muffle
- Duration: 5 seconds
```

### Shadow Form (Ethereal + Speed)

```
SPELL: SR_ShadowForm
- Type: Greater Power
- Cast Type: Fire and Forget
- Delivery: Self
- Cooldown: 24 hours

MAGIC EFFECT: SR_ShadowFormEthereal
- Base: Become Ethereal
- Duration: 20 seconds

MAGIC EFFECT: SR_ShadowFormSpeed
- SpeedMult +50
- Duration: 20 seconds
```

### Passive Abilities

```
SPELL: SR_NightingaleRedeemed
- Type: Ability (constant effect)
- Cast Type: Constant Effect
- Delivery: Self

MAGIC EFFECTS:
- Fortify Pickpocket 15
- Fortify Lockpicking 15
- Fortify Barter 10 (represents fence prices)
- Fortify Sneak 10
```

---

## Script Files

### `SR_MainQuestScript.psc`
Main controller script attached to the quest.

Responsibilities:
- Track quest progression
- Monitor offerings
- Handle stage transitions
- Grant/remove powers
- Interface with Wintersun

### `SR_StartupScript.psc`
Handles the opening sequence and initial setup.

Responsibilities:
- Display message box sequence
- Grant starting items
- Set initial deity
- Register for tracking events

### `SR_WintersunMonitor.psc`
Monitors deity status.

Responsibilities:
- Periodic deity check
- Warning display on change attempt
- Quest failure handling

### `SR_TrackingFunctions.psc`
Utility functions for stat tracking.

Responsibilities:
- Query stolen goods
- Query pickpocket stats
- Check offering completion

---

## Testing Checklist

### Stage 1 MVP Tests

- [ ] Start selection appears in AP dragon menu
- [ ] Opening message sequence plays
- [ ] Player spawns in Beggar's Row
- [ ] Starting items present in inventory
- [ ] Quest active at Stage 10
- [ ] Note readable, advances to Stage 15
- [ ] Stolen goods tracking works
- [ ] Joining TG detected correctly
- [ ] Stage 20 completion grants power
- [ ] Courier letter delivered
- [ ] TG quest completion detected (Speaking With Silence)
- [ ] TG quest completion detected (Blindsighted)
- [ ] TG quest completion detected (Darkness Returns)
- [ ] Guild Master rank detected
- [ ] Final shrine interaction works
- [ ] All rewards granted on completion
- [ ] Insignia transformation works
- [ ] Deity change warning appears
- [ ] Quest fails properly on deity change
- [ ] Curse applied on abandonment
- [ ] No conflicts with existing TG mods (AYOP, etc.)

---

## Known Compatibility Concerns

### Thieves Guild Mods
- **AYOP-TG:** Should be compatible - we only READ TG quest stages, don't modify them
- **TG Enhancement Suite:** Need to verify quest names match
- **Opulent Thieves Guild:** Visual only, no conflict

### Alternate Start Mods
- **Realm of Lorkhan:** Potential conflict if both installed - need to check
- **Other AP addon starts:** Should be fine, just another option

### Lighting/Visual Mods
- **Lux/Lux Orbis:** No conflict - we don't modify lighting
- **JK's Interiors:** May affect Beggar's Row - need to verify spawn point

### Nocturnal-Related Mods
- **Wintersun:** Integration target - need careful handling
- **Undeath:** Separate deity concerns
- **Any mod affecting Twilight Sepulcher:** May need patch for final scene

---

## Future Stage 2 Additions

Items marked for Stage 2 enhancement:

1. **Voiced Nocturnal scene** - Replace message boxes with full scene
2. **Cloned Sepulcher interior** - Custom worldspace for opening/ending
3. **Karliah interactions** - Additional dialogue for TG quests
4. **Specific artifact offerings** - Optional powerful items to find
5. **MQ hook** - Dragon crisis connection after completion
6. **Visual effects** - Shadow VFX on power use, shrine interactions
7. **More robust Wintersun integration** - Event-based rather than polling
