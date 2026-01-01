# Agent of the Crescent - Complete Creation Kit Setup Guide

## Document Purpose

This guide walks you through creating all the records needed for the Agent of the Crescent mod in Creation Kit. It assumes you've already completed the "Hello World" phase and have a working `AgentOfTheCrescent.esp` with:
- ✅ `AotC_StartQuest` - The AP integration quest
- ✅ Dream sequence messages (4)
- ✅ Spawn marker in Beggar's Row
- ✅ Tarnished Insignia misc item
- ✅ Starting equipment references

---

## Table of Contents

1. [Overview of What We're Building](#overview)
2. [Global Variables](#global-variables)
3. [The Main Quest](#the-main-quest)
4. [Quest Stages and Objectives](#quest-stages-and-objectives)
5. [The Shadow Fence System](#the-shadow-fence-system)
6. [Night Theft Tracker (Story Manager)](#night-theft-tracker)
7. [Powers and Abilities](#powers-and-abilities)
8. [Courier Letters](#courier-letters)
9. [The Restored Insignia](#the-restored-insignia)
10. [Linking Everything Together](#linking-everything-together)
11. [Compiling Scripts](#compiling-scripts)
12. [Testing Checklist](#testing-checklist)

---

## Overview

### Records to Create

| Category | Records | Count |
|----------|---------|-------|
| Quest | AotC_MainQuest, AotC_NightTheftTracker, AotC_ShadowFence | 3 |
| GlobalVariable | Tracking and threshold globals | 11 |
| Spell | Powers and abilities | 7 |
| MagicEffect | Effects for spells | 8+ |
| Book | Courier letters | 3 |
| Armor | Restored Insignia amulet | 1 |
| Message | Notifications | 3 |
| Actor | Shadow Fence NPC | 1 |
| FormList | (optional) Jarl residences | 1 |

### Files Needed

Make sure these scripts are in `Data/Scripts/Source/`:
- `AotC_StartQuest.psc` (updated)
- `AotC_MainQuest.psc` (new)
- `AotC_ShadowFenceAlias.psc` (new)
- `AotC_NightTheftTracker.psc` (new)

---

## Global Variables

Global variables store persistent values across the game session. We need these for tracking progress.

### Creating Global Variables

1. In Creation Kit, go to **Miscellaneous → Global**
2. Right-click → **New**
3. For each global below, create with the specified settings

### Tracking Globals

| Editor ID | Type | Initial Value | Purpose |
|-----------|------|---------------|---------|
| `AotC_FencedGold` | Float | 0 | Gold fenced through Shadow Fence |
| `AotC_NightTheftCount` | Float | 0 | Items stolen at night |
| `AotC_OfferingsComplete` | Short | 0 | Bitmask of completed offerings |
| `AotC_QuestStage` | Short | 0 | Mirror of main quest stage |
| `AotC_ShadowFenceTier` | Short | 0 | Current fence progression tier |

### Threshold Globals (Tunable)

| Editor ID | Type | Initial Value | Purpose |
|-----------|------|---------------|---------|
| `AotC_Threshold_FencedGold_I` | Float | 500 | First fencing threshold |
| `AotC_Threshold_FencedGold_II` | Float | 1500 | Second fencing threshold |
| `AotC_Threshold_Pickpocket` | Short | 25 | Pickpocket count needed |
| `AotC_Threshold_TGJobs` | Short | 5 | TG jobs needed |
| `AotC_Threshold_NightTheft` | Short | 40 | Nighttime thefts needed |

### State Globals

| Editor ID | Type | Initial Value | Purpose |
|-----------|------|---------------|---------|
| `AotC_QuestComplete` | Short | 0 | 1 when quest complete |
| `AotC_NocturnalAbandoned` | Short | 0 | 1 if player forsook Nocturnal |

---

## The Main Quest

### Create the Quest Record

1. Go to **Character → Quest**
2. Right-click → **New**
3. **Quest Data Tab:**

| Field | Value |
|-------|-------|
| ID | `AotC_MainQuest` |
| Name | Shadow's Redemption |
| Priority | 50 |
| Type | Side Quest (or Miscellaneous) |
| **Start Game Enabled** | ❌ UNCHECKED |
| Run Once | ✅ Checked |
| Allow Repeated Stages | ❌ Unchecked |

4. Click **OK** to create, then reopen to edit

### Quest Aliases Tab

Create these aliases:

#### Alias 1: PlayerRef
1. Right-click in alias list → **New Reference Alias**
2. Settings:
   - Alias Name: `PlayerRef`
   - Fill Type: **Forced Reference**
   - Forced Reference: Select `PlayerRef` from dropdown

#### Alias 2: ThievesGuildFaction
1. Right-click → **New Reference Alias** (we'll use this for faction, or create a faction alias if available)
   - Actually, factions are referenced directly via properties, not aliases
   - Skip this - we'll link faction in script properties

### Scripts Tab

1. Click **Add**
2. In the script list, find `AotC_MainQuest`
   - If not visible, you need to compile it first (see [Compiling Scripts](#compiling-scripts))
3. Select it and click **OK**
4. With the script selected, click **Properties**
5. Fill in each property (see [Property Reference](#main-quest-properties) below)

---

## Quest Stages and Objectives

### Creating Stages

Go to the **Quest Stages** tab and add:

#### Stage 10 - Awakening
1. Click **New Stage** → Enter `10`
2. **Log Entry:**
   ```
   I awoke in the filth of Riften's Ratway with nothing but rags and fragmented memories. A tarnished insignia clutched in my hand whispers of failure and second chances.
   
   Nocturnal offers redemption: Find the Thieves Guild. Find the betrayer. Return the Skeleton Key.
   ```
3. ✅ Check **Start Up Stage** (this is where the quest begins)

#### Stage 30 - Accepted by Shadows
1. Add Stage `30`
2. **Log Entry:**
   ```
   I've found the Guild and earned a place among them. Mercer Frey leads them still, bleeding them dry while they blame bad luck.
   
   I must rise among them. Prove my worth through offerings of shadow.
   ```

#### Stage 50 - First Offerings Complete
1. Add Stage `50`
2. **Log Entry:**
   ```
   Nocturnal returns a fragment of my former power - I can sense the living through walls. But there is more to reclaim.
   
   The Guild speaks of troubles. Something rotten at the heart of this organization.
   ```

#### Stage 70 - Betrayer Revealed
1. Add Stage `70`
2. **Log Entry:**
   ```
   Mercer Frey. Murderer. Traitor. Thief of the Skeleton Key itself.
   
   Karliah has returned seeking justice. This time, I will not hesitate.
   ```

#### Stage 90 - Key Reclaimed
1. Add Stage `90`
2. **Log Entry:**
   ```
   Mercer is dead. The Skeleton Key rests in my hands once more.
   
   But the work is not complete. The Key must be returned to the Twilight Sepulcher.
   ```

#### Stage 110 - Darkness Returns
1. Add Stage `110`
2. **Log Entry:**
   ```
   The Key rests once more in the Sepulcher. But redemption is not yet complete.
   
   I must rise to lead the Guild I once abandoned.
   ```

#### Stage 130 - Redemption (Complete)
1. Add Stage `130`
2. **Log Entry:**
   ```
   It is done. I knelt before Nocturnal's shrine as Guild Master. The shadows welcomed me back.
   
   The Tarnished Insignia now gleams with renewed purpose. I am her Agent once more.
   ```
3. ✅ Check **Complete Quest**

#### Stage 200 - Abandoned (Fail)
1. Add Stage `200`
2. **Log Entry:**
   ```
   I have forsaken Nocturnal. Her voice is silent forever. The shadows turn cold.
   
   I must find my own way forward, bearing the weight of two failures.
   ```
3. ✅ Check **Fail Quest**

---

### Creating Objectives

Go to **Quest Objectives** tab:

#### Objective 10 - Find the Guild
| Field | Value |
|-------|-------|
| Index | 10 |
| Display Text | Find the Thieves Guild in Riften |
| Displayed When Stage <= | 30 |
| Completed When Stage >= | 30 |

#### Objective 20 - Prove Worth (Initial)
| Field | Value |
|-------|-------|
| Index | 20 |
| Display Text | Fence stolen goods through the shadows (0/500 gold) |
| Displayed When Stage >= | 10 |
| Displayed When Stage <= | 30 |

#### Objective 30 - First Offerings
These display at Stage 30:

| Index | Display Text |
|-------|-------------|
| 31 | Offering of Wealth: Fence 1,500 gold total |
| 32 | Offering of Cunning: Complete 5 Guild jobs |
| 33 | Offering of Boldness: Pick 25 pockets |

All three:
- Displayed When Stage >= 30
- Displayed When Stage <= 50

#### Objective 50 - Second Offerings
| Index | Display Text |
|-------|-------------|
| 51 | Offering of Darkness: Steal 40 items at night |
| 52 | Offering of Secrets: Discover the betrayer's crimes |

Both:
- Displayed When Stage >= 50
- Displayed When Stage <= 70

#### Objective 70 - Hunt Mercer
| Index | Display Text |
|-------|-------------|
| 70 | Hunt down Mercer Frey |
| 71 | Reclaim the Skeleton Key |

- Displayed When Stage >= 70
- Completed When Stage >= 90

#### Objective 90 - Return Key
| Index | Display Text |
|-------|-------------|
| 90 | Return the Skeleton Key to the Twilight Sepulcher |

- Displayed When Stage >= 90
- Completed When Stage >= 110

#### Objective 110 - Final Steps
| Index | Display Text |
|-------|-------------|
| 110 | Become the Guild Master |
| 111 | Return to Nocturnal's shrine |

- Displayed When Stage >= 110
- Completed When Stage >= 130

---

## The Shadow Fence System

The Shadow Fence is a summonable NPC that acts as the player's exclusive fence for redemption purposes.

### Create the Shadow Fence NPC

1. Go to **Actors → Actor**
2. Right-click → **New**
3. **Actor Tab:**

| Field | Value |
|-------|-------|
| ID | `AotC_ShadowFence` |
| Name | Shadow |
| Race | Select a race (Elder or Nord works) |
| Flags | ✅ Unique, ✅ Essential |

4. **Traits Tab:**
   - Set appearance (dark, hooded figure)
   - Use Nightingale-style outfit if available

5. **AI Data Tab:**
   - Aggression: Unaggressive
   - Confidence: Foolhardy
   - Assistance: Helps Nobody
   - Morality: No Crime

6. **Factions Tab:**
   - Add to a fence faction or create `AotC_ShadowFenceFaction`

7. **Inventory Tab:**
   - Add gold: ~2000 (starting fence gold)

### Create the Vendor Faction

For the Shadow Fence to buy items:

1. Go to **Character → Faction**
2. Create `AotC_ShadowFenceFaction`
3. Set up as vendor faction:
   - ✅ Vendor
   - Vendor Buy/Sell List: Create or use existing stolen goods list
   - Check **Not Sell** for items you don't want them to sell back

### Create the Shadow Fence Quest

This quest manages the Shadow Fence actor:

1. Go to **Character → Quest**
2. Create `AotC_ShadowFence`
3. Settings:
   - Start Game Enabled: ❌ NO (started when summoning power used)
   - Run Once: ❌ NO (can be summoned multiple times)

4. **Aliases Tab:**
   - Create `ShadowFenceRef` alias
   - Fill Type: **Create Reference to Object**
   - Object: `AotC_ShadowFence`
   - Create At: Near player (use XMarker alias or script placement)

5. **Scripts Tab:**
   - Attach `AotC_ShadowFenceAlias` to the `ShadowFenceRef` alias
   - Fill the alias script's properties

### Create the Summoning Power

1. Go to **Magic → Spell**
2. Create `AotC_WhisperToShadow`
3. Settings:

| Field | Value |
|-------|-------|
| ID | `AotC_WhisperToShadow` |
| Name | Whisper to Shadow |
| Type | Lesser Power |
| Cast Type | Fire and Forget |
| Delivery | Self |
| Casting Time | 0 |

4. **Effects:**
   - Create a Script Effect that starts the Shadow Fence quest
   - Or use a direct script to spawn/summon the NPC

**Alternative (Simpler):** Create a power that adds a spell which triggers a script to:
1. Find a safe spawn point near the player
2. Create reference to Shadow Fence
3. MoveTo near player
4. Set up to despawn after 3 minutes

---

## Night Theft Tracker

This uses the Story Manager to detect theft events.

### Create the Tracker Quest

1. Go to **Character → Quest**
2. Create `AotC_NightTheftTracker`
3. Settings:
   - Start Game Enabled: ❌ NO
   - Run Once: ❌ NO (must be re-triggerable)

4. **Scripts Tab:**
   - Attach `AotC_NightTheftTracker`
   - Fill properties (globals)

### Set Up Story Manager

1. Go to **Character → SM Event Node**
2. Navigate to: **Player Add Item** event
3. Right-click → **New Quest Node**
4. Settings:

| Field | Value |
|-------|-------|
| Quest | `AotC_NightTheftTracker` |
| ✅ Shares Event | CHECKED (critical!) |
| Flags | Do All Before Repeating: ❌ |

5. **Conditions Tab:**
   Add conditions to filter to theft only:
   ```
   GetEventData OwnerRef != None
   GetEventData OwnerRef != PlayerRef
   ```

6. Position this node appropriately in the SM tree (not blocking vanilla nodes)

---

## Powers and Abilities

### Shadow's Whisper (Detect Life)

1. **Create Magic Effect:**
   - ID: `AotC_ShadowWhisperEffect`
   - Archetype: Detect Life
   - Magnitude: 200 (large radius)
   - Duration: 30

2. **Create Spell:**
   - ID: `AotC_ShadowWhisper`
   - Name: Shadow's Whisper
   - Type: Lesser Power
   - Add the effect

### Shadow's Step (Invisibility)

1. **Create Magic Effect:**
   - ID: `AotC_ShadowStepEffect`
   - Archetype: Invisibility
   - Duration: 15

2. **Create Spell:**
   - ID: `AotC_ShadowStep`
   - Name: Shadow's Step
   - Type: Lesser Power

### Shadow's Embrace (Speed Burst)

1. **Create Magic Effects:**
   - `AotC_ShadowEmbraceSpeed`: Fortify SpeedMult, Magnitude 100, Duration 5
   - `AotC_ShadowEmbraceMuffle`: Muffle, Duration 5

2. **Create Spell:**
   - ID: `AotC_ShadowEmbrace`
   - Name: Shadow's Embrace
   - Type: Lesser Power
   - Add both effects

### Shadow Form (Ethereal)

1. **Create Magic Effects:**
   - `AotC_ShadowFormEthereal`: Ethereal (Become Ethereal base), Duration 20
   - `AotC_ShadowFormSpeed`: Fortify SpeedMult, Magnitude 50, Duration 20

2. **Create Spell:**
   - ID: `AotC_ShadowForm`
   - Name: Shadow Form
   - Type: Greater Power

### Nocturnal's Redeemed (Passive)

1. **Create Magic Effects:**
   - Fortify Pickpocket 15
   - Fortify Lockpicking 15
   - Fortify Sneak 10
   - Fortify Barter 10

2. **Create Spell:**
   - ID: `AotC_NightingaleRedeemed`
   - Name: Nocturnal's Redeemed
   - Type: Ability
   - Cast Type: Constant Effect

### Nocturnal's Rejection (Curse)

1. **Create Magic Effects:**
   - Fortify Sneak -10 (debuff)
   - Fortify Barter -5

2. **Create Spell:**
   - ID: `AotC_NocturnalRejection`
   - Name: Nocturnal's Rejection
   - Type: Ability
   - Cast Type: Constant Effect

---

## Courier Letters

### Create Book Items

1. Go to **Items → Book**
2. Create each letter:

#### AotC_Letter01
| Field | Value |
|-------|-------|
| ID | `AotC_Letter01` |
| Name | Unmarked Letter |
| Book Text | (see content below) |
| Flags | ❌ NOT: Teaches Spell, Teaches Skill |
| Weight | 0 |
| Value | 0 |

**Content:**
```
You have found your way to the Guild. Good.

They are diminished, corrupt, led by the very one who stole from me. But they have purpose yet - and so do you.

Rise among them. Prove your worth. And when the moment comes...

Do not hesitate.
```

#### AotC_Letter02
| Field | Value |
|-------|-------|
| ID | `AotC_Letter02` |
| Name | Unmarked Letter |

**Content:**
```
At last, the Guild sees what you have always known. The betrayer is exposed.

Karliah seeks justice for her fallen lover. You seek redemption for your failure. Your paths align.

Hunt him. End him. Reclaim what he stole.

The shadows grow impatient.
```

#### AotC_Letter03
| Field | Value |
|-------|-------|
| ID | `AotC_Letter03` |
| Name | Unmarked Letter |

**Content:**
```
The betrayer is dead. The Key returns to worthy hands.

You have done well. But the work is not complete.

Return my Key to the Sepulcher. Walk the Pilgrim's Path. Then rise to lead what you once abandoned.

Only then will your debt be paid.
```

---

## The Restored Insignia

### Create the Amulet

1. Go to **Items → Armor**
2. Create `AotC_RestoredInsignia`
3. Settings:

| Field | Value |
|-------|-------|
| ID | `AotC_RestoredInsignia` |
| Name | Restored Nightingale Insignia |
| Armor Type | Clothing |
| Body Template | Amulet slot |
| Weight | 0.5 |
| Value | 2500 |
| Armor Rating | 0 |

4. **Enchantment:**
   Create `AotC_RestoredInsigniaEnchantment`:
   - Fortify Sneak 20
   - Muffle 0.5 (50% noise reduction)
   - Fortify Stamina 30

5. **Model:**
   - Use existing Nightingale amulet mesh or Amulet of Articulation

---

## Messages

Create notification messages:

| ID | Message Text |
|----|--------------|
| `AotC_Msg_OfferingComplete` | An offering is complete. Nocturnal acknowledges your devotion. |
| `AotC_Msg_PowerRestored` | A fragment of your former power returns... |
| `AotC_Msg_Redemption` | You have walked the path of shadow and emerged redeemed. Nocturnal's favor flows through you once more. |

For each:
1. Go to **Miscellaneous → Message**
2. Create with ❌ NOT a Message Box (just notification)

---

## Linking Everything Together

### Update AotC_StartQuest Properties

Open `AotC_StartQuest` and add the new property:

| Property | Value |
|----------|-------|
| AotC_MainQuest | Select `AotC_MainQuest` |

### Main Quest Properties

Open `AotC_MainQuest` script properties and fill:

**Core References:**
| Property | Value |
|----------|-------|
| PlayerRef | PlayerRef |
| ThievesGuildFaction | TG (from Skyrim.esm) |

**TG Quest References:**
| Property | Value |
|----------|-------|
| TG03 | TG03 (Speaking With Silence) |
| TG08A | TG08A (Blindsighted) |
| TG08B | TG08B |
| TG09 | TG09 (Darkness Returns) |

**Globals:**
Link all `AotC_*` globals to their corresponding properties.

**Spells:**
Link all created spells.

**Items:**
| Property | Value |
|----------|-------|
| AotC_TarnishedInsignia | Your existing misc item |
| AotC_RestoredInsignia | The new amulet |

**Letters:**
Link all three `AotC_Letter*` books.

**Messages:**
Link all notification messages.

---

## Compiling Scripts

### Method 1: Creation Kit Compiler

1. In CK, go to **Gameplay → Papyrus Script Manager**
2. Find your scripts in the list
3. Select each and click **Compile**
4. Check the output window for errors

### Method 2: Command Line (Recommended)

1. Open Command Prompt in your Skyrim directory
2. Run:
   ```
   Papyrus Compiler\PapyrusCompiler.exe "Data\Scripts\Source\AotC_MainQuest.psc" -f="TESV_Papyrus_Flags.flg" -i="Data\Scripts\Source" -o="Data\Scripts"
   ```
3. Repeat for each script

### Verify Compilation

Check that `.pex` files exist in `Data/Scripts/`:
- `AotC_MainQuest.pex`
- `AotC_ShadowFenceAlias.pex`
- `AotC_NightTheftTracker.pex`

---

## Testing Checklist

### Stage 10 Tests
- [ ] Select AotC start from AP dragon
- [ ] Dream sequence plays
- [ ] Spawns in Beggar's Row
- [ ] Has rags and Tarnished Insignia
- [ ] Main quest appears in journal at Stage 10
- [ ] "Whisper to Shadow" power in powers menu
- [ ] Objectives visible: "Find the Thieves Guild", "Fence stolen goods"

### Shadow Fence Tests
- [ ] Power summons Shadow Fence
- [ ] Can sell stolen items to Shadow Fence
- [ ] Gold tracking updates (`AotC_FencedGold` global)
- [ ] Fence despawns after timeout

### Stage 30 Tests
- [ ] Joining TG + fencing 500g advances to Stage 30
- [ ] Journal updates with new objectives
- [ ] First offerings objectives visible

### Offering Tracking Tests
- [ ] Pickpocket stat tracking works
- [ ] Night theft tracking works (steal at night)
- [ ] Notification appears at milestones

### Power Grant Tests
- [ ] Stage 50 grants Shadow's Whisper
- [ ] Stage 70 grants Shadow's Step
- [ ] Stage 110 grants Shadow's Embrace
- [ ] Stage 130 grants Shadow Form + Redeemed

### TG Integration Tests
- [ ] Speaking With Silence completion detected
- [ ] Blindsighted completion detected
- [ ] Darkness Returns completion detected

### Completion Tests
- [ ] Stage 130 removes Tarnished Insignia
- [ ] Stage 130 adds Restored Insignia
- [ ] Restored Insignia has enchantment
- [ ] Quest completes properly

### Fail State Tests
- [ ] Stage 200 removes all powers
- [ ] Stage 200 applies curse
- [ ] Quest fails properly

---

## Troubleshooting

### Script Not Compiling
- Ensure all referenced Forms exist in CK
- Check for typos in property names
- Verify Papyrus source files are in correct location

### Quest Not Starting
- Verify AotC_StartQuest starts AotC_MainQuest
- Check "Start Game Enabled" is OFF for main quest
- Verify script properties are filled

### Tracking Not Working
- Check global variables exist and are linked
- Verify Story Manager node conditions
- Add Debug.Trace statements to diagnose

### Powers Not Granting
- Verify spell records exist
- Check script property links
- Test with console: `player.addspell <formid>`

---

## File Summary

After completing this guide, your mod should contain:

```
AgentOfTheCrescent.esp
├── Quests
│   ├── AotC_StartQuest (existing)
│   ├── AotC_MainQuest (new)
│   ├── AotC_NightTheftTracker (new)
│   └── AotC_ShadowFence (new)
├── GlobalVariables (11)
├── Spells (7)
├── MagicEffects (8+)
├── Books (3 letters)
├── Armor (1 amulet)
├── Messages (3)
├── Actors
│   └── AotC_ShadowFence
└── Story Manager Nodes (1)
```

Scripts in `Data/Scripts/`:
- `AotC_StartQuest.pex`
- `AotC_MainQuest.pex`
- `AotC_ShadowFenceAlias.pex`
- `AotC_NightTheftTracker.pex`

---

*Last Updated: January 2026*
