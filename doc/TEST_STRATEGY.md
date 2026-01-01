# Agent of the Crescent - Complete Test Strategy

## Document Purpose

This guide provides a systematic approach to testing all mod functionality without requiring full Thieves Guild playthroughs. It uses console commands to simulate game states, verify tracking systems, and test all stage transitions.

---

## Table of Contents

1. [Testing Philosophy](#testing-philosophy)
2. [Essential Console Commands Reference](#essential-console-commands-reference)
3. [FormID Reference](#formid-reference)
4. [Test Suite 1: Initial Spawn](#test-suite-1-initial-spawn)
5. [Test Suite 2: Tracking Systems](#test-suite-2-tracking-systems)
6. [Test Suite 3: Stage Progressions](#test-suite-3-stage-progressions)
7. [Test Suite 4: Powers and Rewards](#test-suite-4-powers-and-rewards)
8. [Test Suite 5: Shadow Fence](#test-suite-5-shadow-fence)
9. [Test Suite 6: TG Integration](#test-suite-6-tg-integration)
10. [Test Suite 7: Fail States](#test-suite-7-fail-states)
11. [Test Suite 8: Edge Cases](#test-suite-8-edge-cases)
12. [Regression Test Checklist](#regression-test-checklist)
13. [Debug Logging](#debug-logging)

---

## Testing Philosophy

### Incremental Testing
Test each system in isolation before testing integration. A bug in tracking will cascade into stage advancement failures.

### Save States
Create named saves at key points:
- `AotC_Test_Fresh` - Clean new game, before selecting start
- `AotC_Test_Stage10` - Just spawned in Beggar's Row
- `AotC_Test_Stage30` - Joined TG, initial offerings
- `AotC_Test_Stage50` - First offerings complete
- `AotC_Test_PreMercer` - Before TG06 completion
- `AotC_Test_Complete` - Stage 130, fully redeemed

### Console Access
Enable console in Skyrim.ini if not already:
```ini
[General]
bAllowConsole=1
```

---

## Essential Console Commands Reference

### Quest Commands

| Command | Purpose |
|---------|---------|
| `sqv AotC_MainQuest` | Show all quest variables and aliases |
| `sqs AotC_MainQuest` | Show quest stage and objectives |
| `setstage AotC_MainQuest <stage>` | Force set quest stage |
| `getstage AotC_MainQuest` | Get current quest stage |
| `startquest AotC_MainQuest` | Start the quest |
| `stopquest AotC_MainQuest` | Stop the quest |
| `resetquest AotC_MainQuest` | Reset quest to initial state |
| `completequest AotC_MainQuest` | Mark quest complete |

### Global Variable Commands

| Command | Purpose |
|---------|---------|
| `getglobalvalue AotC_FencedGold` | Check fenced gold amount |
| `setglobalvalue AotC_FencedGold <value>` | Set fenced gold |
| `getglobalvalue AotC_NightTheftCount` | Check night theft count |
| `setglobalvalue AotC_NightTheftCount <value>` | Set night theft count |
| `getglobalvalue AotC_OfferingsComplete` | Check offerings bitmask |
| `setglobalvalue AotC_OfferingsComplete <value>` | Set offerings bitmask |
| `getglobalvalue AotC_QuestStage` | Check stage mirror global |

### Player Commands

| Command | Purpose |
|---------|---------|
| `player.addspell <formid>` | Add a spell/power |
| `player.removespell <formid>` | Remove a spell/power |
| `player.additem <formid> <count>` | Add items |
| `player.removeitem <formid> <count>` | Remove items |
| `player.addtofaction <formid> <rank>` | Add to faction |
| `player.setfactionrank <formid> <rank>` | Set faction rank |
| `player.getfactionrank <formid>` | Get faction rank |

### Stat Commands

| Command | Purpose |
|---------|---------|
| `getplayerstat "Pockets Picked"` | Check pickpocket count |
| `modplayerstat "Pockets Picked" <value>` | Modify pickpocket stat |

### Time Commands

| Command | Purpose |
|---------|---------|
| `set gamehour to <value>` | Set time (0-24) |
| `set gamehour to 22` | Set to 10 PM (nighttime) |
| `set gamehour to 10` | Set to 10 AM (daytime) |

### Thieves Guild Commands

| Command | Purpose |
|---------|---------|
| `setstage TG03 200` | Complete Speaking With Silence |
| `setstage TG08A 200` | Complete Blindsighted |
| `setstage TG09 200` | Complete Darkness Returns |
| `player.addtofaction 00029DA9 0` | Join Thieves Guild |
| `player.setfactionrank 00029DA9 4` | Set to Guild Master |

### Debug Commands

| Command | Purpose |
|---------|---------|
| `coc RiftenBeggarRow` | Teleport to Beggar's Row |
| `coc RiftenRaggedFlagonCistern` | Teleport to Cistern |
| `coc NightingaleHall` | Teleport to Nightingale Hall |
| `coc TwilightSepulcher01` | Teleport to Sepulcher |
| `tcl` | Toggle collision (fly through walls) |
| `tgm` | Toggle god mode |
| `tmm 1` | Reveal all map markers |

---

## FormID Reference

**IMPORTANT:** Replace these placeholder FormIDs with actual values from your ESP after creation.

### Quests
```
AotC_StartQuest      = XX000D62  (your existing quest)
AotC_MainQuest       = XX______  (fill in after creation)
AotC_NightTheftTracker = XX______
AotC_ShadowFence     = XX______
```

### Global Variables
```
AotC_FencedGold           = XX______
AotC_NightTheftCount      = XX______
AotC_OfferingsComplete    = XX______
AotC_QuestStage           = XX______
AotC_Threshold_FencedGold_I  = XX______
AotC_Threshold_FencedGold_II = XX______
AotC_Threshold_Pickpocket    = XX______
AotC_Threshold_TGJobs        = XX______
AotC_Threshold_NightTheft    = XX______
```

### Spells
```
AotC_WhisperToShadow    = XX______
AotC_ShadowWhisper      = XX______
AotC_ShadowStep         = XX______
AotC_ShadowEmbrace      = XX______
AotC_ShadowForm         = XX______
AotC_NightingaleRedeemed = XX______
AotC_NocturnalRejection = XX______
```

### Items
```
AotC_TarnishedInsignia  = XX000D63  (your existing item)
AotC_RestoredInsignia   = XX______
AotC_Letter01           = XX______
AotC_Letter02           = XX______
AotC_Letter03           = XX______
```

### Vanilla References
```
ThievesGuildFaction = 00029DA9
TG03 (Speaking With Silence) = 00021551
TG08A (Blindsighted) = 0004D8D6
TG09 (Darkness Returns) = 0004D8D7
```

---

## Test Suite 1: Initial Spawn

### Test 1.1: AP Integration
**Objective:** Verify the alternate start works correctly

**Steps:**
1. Start new game
2. In AP starting room, approach dragon statue
3. Verify "Agent of the Crescent" appears in start list
4. Select it
5. Wait for dream sequence

**Expected Results:**
- [ ] Start option visible in AP menu
- [ ] 4 dream message boxes appear in sequence
- [ ] Player spawns in Beggar's Row
- [ ] Player wearing ragged robes and footwraps
- [ ] Tarnished Insignia in inventory
- [ ] No other items in inventory

**Console Verification:**
```
; Check inventory
player.getitemcount XX000D63  ; Should return 1 (Insignia)

; Check quest
getstage AotC_StartQuest      ; Should be 10
getstage AotC_MainQuest       ; Should be 10
```

**Save Point:** Create `AotC_Test_Stage10`

---

### Test 1.2: Initial Quest State
**Objective:** Verify main quest initializes correctly

**Steps:**
1. Load `AotC_Test_Stage10`
2. Open quest journal
3. Check powers menu

**Expected Results:**
- [ ] "Shadow's Redemption" appears in quest log
- [ ] Stage 10 journal entry visible
- [ ] Objectives: "Find the Thieves Guild", "Fence stolen goods (0/500)"
- [ ] "Whisper to Shadow" power available

**Console Verification:**
```
sqs AotC_MainQuest            ; Check objectives displayed
sqv AotC_MainQuest            ; Check all variables
player.hasperk XX______       ; Or check spell
```

---

## Test Suite 2: Tracking Systems

### Test 2.1: Fenced Gold Tracking
**Objective:** Verify Shadow Fence gold tracking works

**Prerequisites:** Shadow Fence system implemented

**Steps:**
1. Load `AotC_Test_Stage10`
2. Steal some items (or add via console)
3. Summon Shadow Fence
4. Sell items
5. Check tracking

**Console Simulation (if Shadow Fence not ready):**
```
; Simulate fencing 100 gold
setglobalvalue AotC_FencedGold 100
; Verify
getglobalvalue AotC_FencedGold
```

**Expected Results:**
- [ ] `AotC_FencedGold` increases by item value sold
- [ ] Objective counter updates

---

### Test 2.2: Nighttime Theft Tracking
**Objective:** Verify Story Manager theft detection works

**Steps:**
1. Load any save with main quest active (stage 50+)
2. Set time to night:
   ```
   set gamehour to 22
   ```
3. Steal an item from an NPC or owned container
4. Check counter

**Console Verification:**
```
getglobalvalue AotC_NightTheftCount
```

**Comparison Test:**
1. Set time to day:
   ```
   set gamehour to 10
   ```
2. Steal another item
3. Verify counter did NOT increase

**Expected Results:**
- [ ] Stealing at night increments `AotC_NightTheftCount`
- [ ] Stealing during day does NOT increment counter
- [ ] Notification appears at 10, 25, 40 thefts

---

### Test 2.3: Pickpocket Stat Tracking
**Objective:** Verify vanilla stat reading works

**Steps:**
1. Note current pickpocket stat:
   ```
   getplayerstat "Pockets Picked"
   ```
2. Successfully pickpocket an NPC
3. Check stat again

**Console Simulation:**
```
; Add 25 pickpockets for testing
modplayerstat "Pockets Picked" 25
```

**Expected Results:**
- [ ] Stat increments on successful pickpocket
- [ ] Main quest reads this value correctly

---

### Test 2.4: Offerings Bitmask
**Objective:** Verify offering completion tracking

**Console Tests:**
```
; Check current offerings
getglobalvalue AotC_OfferingsComplete

; Set individual offerings (add values together):
; WEALTH_I = 1, WEALTH_II = 2, CUNNING = 4, BOLDNESS = 8
; DARKNESS = 16, AMBITION = 32, SECRETS = 64

; Example: Set Wealth I + Boldness complete (1 + 8 = 9)
setglobalvalue AotC_OfferingsComplete 9

; Example: Set all first offerings (1 + 2 + 4 + 8 = 15)
setglobalvalue AotC_OfferingsComplete 15
```

**Bitmask Reference:**
| Offering | Bit | Value | Cumulative |
|----------|-----|-------|------------|
| Wealth I | 0 | 1 | 1 |
| Wealth II | 1 | 2 | 3 |
| Cunning | 2 | 4 | 7 |
| Boldness | 3 | 8 | 15 |
| Darkness | 4 | 16 | 31 |
| Ambition | 5 | 32 | 63 |
| Secrets | 6 | 64 | 127 |

---

## Test Suite 3: Stage Progressions

### Test 3.1: Stage 10 → 30 (Natural)
**Objective:** Test joining TG and initial fencing

**Steps:**
1. Load `AotC_Test_Stage10`
2. Join Thieves Guild:
   ```
   player.addtofaction 00029DA9 0
   ```
3. Simulate fencing 500 gold:
   ```
   setglobalvalue AotC_FencedGold 500
   ```
4. Wait 5+ seconds (tracking poll interval)

**Expected Results:**
- [ ] Quest advances to Stage 30
- [ ] Journal updates
- [ ] New objectives appear

**Console Verification:**
```
getstage AotC_MainQuest       ; Should be 30
sqs AotC_MainQuest            ; Check new objectives
```

**Save Point:** Create `AotC_Test_Stage30`

---

### Test 3.2: Stage 30 → 50 (First Offerings)
**Objective:** Test first three offerings completion

**Steps:**
1. Load `AotC_Test_Stage30`
2. Complete offerings via console:
   ```
   ; Wealth II (1500 gold fenced)
   setglobalvalue AotC_FencedGold 1500
   
   ; Boldness (25 pickpockets) - may need script workaround
   ; Cunning (5 TG jobs) - may need script workaround
   
   ; Or set offerings directly:
   setglobalvalue AotC_OfferingsComplete 15  ; First 4 offerings
   ```
3. Wait for tracking poll

**Expected Results:**
- [ ] Quest advances to Stage 50
- [ ] "Shadow's Whisper" power granted
- [ ] Letter 01 delivered
- [ ] Notification: "Nocturnal returns a fragment..."

**Console Verification:**
```
getstage AotC_MainQuest
player.haspell XX______       ; Shadow's Whisper FormID
player.getitemcount XX______  ; Letter01 FormID
```

**Save Point:** Create `AotC_Test_Stage50`

---

### Test 3.3: Stage 50 → 70 (Second Offerings + TG06)
**Objective:** Test second offerings and TG integration

**Steps:**
1. Load `AotC_Test_Stage50`
2. Set offerings:
   ```
   ; Add Darkness (16) and Secrets (64) to existing (15)
   ; 15 + 16 + 64 = 95
   setglobalvalue AotC_OfferingsComplete 95
   
   ; Or just set night theft count
   setglobalvalue AotC_NightTheftCount 40
   ```
3. Complete Speaking With Silence:
   ```
   setstage TG03 200
   ```
4. Wait for tracking poll

**Expected Results:**
- [ ] Quest advances to Stage 70
- [ ] "Shadow's Step" power granted
- [ ] Letter 02 delivered

**Save Point:** Create `AotC_Test_Stage70`

---

### Test 3.4: Stage 70 → 90 (Blindsighted)
**Objective:** Test Mercer confrontation detection

**Steps:**
1. Load `AotC_Test_Stage70`
2. Complete Blindsighted:
   ```
   setstage TG08A 200
   ```
3. Wait for tracking poll

**Expected Results:**
- [ ] Quest advances to Stage 90
- [ ] Letter 03 delivered
- [ ] Journal: "Mercer is dead. The Key is yours."

**Save Point:** Create `AotC_Test_Stage90`

---

### Test 3.5: Stage 90 → 110 (Darkness Returns)
**Objective:** Test Key return detection

**Steps:**
1. Load `AotC_Test_Stage90`
2. Complete Darkness Returns:
   ```
   setstage TG09 200
   ```
3. Wait for tracking poll

**Expected Results:**
- [ ] Quest advances to Stage 110
- [ ] "Shadow's Embrace" power granted
- [ ] New objectives: "Become Guild Master", "Return to shrine"

**Save Point:** Create `AotC_Test_Stage110`

---

### Test 3.6: Stage 110 → 130 (Redemption)
**Objective:** Test final completion

**Steps:**
1. Load `AotC_Test_Stage110`
2. Set Guild Master rank:
   ```
   player.setfactionrank 00029DA9 4
   ```
3. For shrine activation, either:
   - Teleport and activate: `coc TwilightSepulcher01`
   - Or force stage: `setstage AotC_MainQuest 130`

**Expected Results:**
- [ ] Quest advances to Stage 130
- [ ] "Shadow Form" power granted
- [ ] "Nocturnal's Redeemed" ability granted
- [ ] Tarnished Insignia removed
- [ ] Restored Insignia added and equipped
- [ ] Quest marked complete

**Console Verification:**
```
getstage AotC_MainQuest       ; Should be 130
player.haspell XX______       ; Shadow Form
player.haspell XX______       ; Nocturnal's Redeemed
player.getitemcount XX______  ; Tarnished (should be 0)
player.getitemcount XX______  ; Restored (should be 1)
```

**Save Point:** Create `AotC_Test_Complete`

---

### Test 3.7: Force Stage Transitions
**Objective:** Verify manual stage setting works

**Steps:**
For each stage, test direct setting:
```
setstage AotC_MainQuest 10
setstage AotC_MainQuest 30
setstage AotC_MainQuest 50
setstage AotC_MainQuest 70
setstage AotC_MainQuest 90
setstage AotC_MainQuest 110
setstage AotC_MainQuest 130
```

**Expected Results:**
- [ ] Each stage sets correctly
- [ ] Stage handlers fire (check for power grants)
- [ ] Journal updates appropriately

---

## Test Suite 4: Powers and Rewards

### Test 4.1: Whisper to Shadow (Summon)
**Objective:** Test Shadow Fence summoning power

**Steps:**
1. Load any save with power available
2. Use "Whisper to Shadow" power
3. Verify Shadow Fence appears

**Expected Results:**
- [ ] Power appears in Powers menu
- [ ] Using power summons Shadow Fence near player
- [ ] Shadow Fence has vendor dialogue
- [ ] Shadow Fence despawns after ~3 minutes

---

### Test 4.2: Shadow's Whisper (Detect Life)
**Objective:** Test first restored power

**Steps:**
1. Grant power: `player.addspell XX______`
2. Go somewhere with NPCs
3. Use power

**Expected Results:**
- [ ] Power usable once per day
- [ ] Shows life detection effect
- [ ] Large radius (~200 units)
- [ ] Lasts 30 seconds

---

### Test 4.3: Shadow's Step (Invisibility)
**Objective:** Test invisibility power

**Steps:**
1. Grant power: `player.addspell XX______`
2. Use power near enemies

**Expected Results:**
- [ ] Player becomes invisible
- [ ] Lasts 15 seconds
- [ ] Breaks on attack/interaction
- [ ] Once per day cooldown

---

### Test 4.4: Shadow's Embrace (Speed)
**Objective:** Test speed burst power

**Steps:**
1. Grant power: `player.addspell XX______`
2. Use power
3. Move around

**Expected Results:**
- [ ] Significant speed increase
- [ ] Muffled footsteps
- [ ] Lasts 5 seconds
- [ ] Once per day cooldown

---

### Test 4.5: Shadow Form (Ethereal)
**Objective:** Test final power

**Steps:**
1. Grant power: `player.addspell XX______`
2. Use near enemies
3. Try to take damage
4. Try to attack

**Expected Results:**
- [ ] Player becomes ethereal
- [ ] Cannot take damage
- [ ] Cannot attack
- [ ] Increased movement speed
- [ ] Lasts 20 seconds

---

### Test 4.6: Nocturnal's Redeemed (Passive)
**Objective:** Test passive bonuses

**Steps:**
1. Grant ability: `player.addspell XX______`
2. Check active effects
3. Test pickpocket/lockpicking/sneak

**Console Verification:**
```
player.getav pickpocket
player.getav lockpicking
player.getav sneak
```

**Expected Results:**
- [ ] Ability appears in Active Effects
- [ ] +15% Pickpocket
- [ ] +15% Lockpicking
- [ ] +10% Sneak
- [ ] +10% Barter (with fences)

---

### Test 4.7: Restored Insignia
**Objective:** Test final reward item

**Steps:**
1. Add item: `player.additem XX______ 1`
2. Equip it
3. Check enchantment effects

**Expected Results:**
- [ ] Equips in amulet slot
- [ ] Shows enchantment in item description
- [ ] Fortify Sneak 20%
- [ ] Muffle effect
- [ ] Fortify Stamina 30

---

## Test Suite 5: Shadow Fence

### Test 5.1: Summoning
**Objective:** Test basic summon functionality

**Steps:**
1. Use "Whisper to Shadow" power
2. Wait for Shadow Fence to appear

**Expected Results:**
- [ ] Fence spawns near player
- [ ] Fence has appropriate appearance (dark, hooded)
- [ ] Fence is non-hostile

---

### Test 5.2: Vendor Functionality
**Objective:** Test buying/selling

**Steps:**
1. Summon Shadow Fence
2. Initiate dialogue
3. Select barter option
4. Sell a stolen item
5. Check gold tracking

**Expected Results:**
- [ ] Barter menu opens
- [ ] Can sell stolen items
- [ ] `AotC_FencedGold` increases appropriately
- [ ] Fence has gold to buy items

---

### Test 5.3: Gold Cap Scaling
**Objective:** Test fence gold capacity at different tiers

**Steps:**
1. At different quest stages, check fence gold amount
2. Compare to expected tier

**Console (to adjust tier):**
```
setglobalvalue AotC_ShadowFenceTier 0  ; 250 gold
setglobalvalue AotC_ShadowFenceTier 3  ; 1000 gold
setglobalvalue AotC_ShadowFenceTier 6  ; 5000 gold
```

---

### Test 5.4: Cooldown
**Objective:** Test 24-hour cooldown on summoning

**Steps:**
1. Use summoning power
2. Try to use again immediately
3. Wait 24 in-game hours: `set gamehour to <current + 24>`
4. Try again

**Expected Results:**
- [ ] Cannot summon twice in 24 hours
- [ ] Power available again after 24 hours

---

## Test Suite 6: TG Integration

### Test 6.1: Faction Join Detection
**Objective:** Verify TG membership detected

**Steps:**
1. Load `AotC_Test_Stage10`
2. Check faction:
   ```
   player.getfactionrank 00029DA9
   ```
3. Join faction:
   ```
   player.addtofaction 00029DA9 0
   ```
4. Check again

**Expected Results:**
- [ ] Initially not in faction (rank -1 or -2)
- [ ] After adding, rank is 0+
- [ ] Main quest detects membership

---

### Test 6.2: TG Quest Completion Detection
**Objective:** Verify we detect TG quest stages correctly

**Steps:**
For each TG quest:
```
; Check if complete
GetStageDone TG03 200
GetStageDone TG08A 200
GetStageDone TG09 200
```

**Expected Results:**
- [ ] Returns 0 if not complete
- [ ] Returns 1 if complete
- [ ] Main quest detects completion

---

### Test 6.3: Guild Master Rank Detection
**Objective:** Verify rank checking works

**Steps:**
1. Check current rank:
   ```
   player.getfactionrank 00029DA9
   ```
2. Set to Guild Master:
   ```
   player.setfactionrank 00029DA9 4
   ```
3. Verify detection

**Expected Results:**
- [ ] Rank 4 detected as Guild Master
- [ ] Main quest advances when rank achieved

---

## Test Suite 7: Fail States

### Test 7.1: Stage 200 (Abandoned)
**Objective:** Test fail state functionality

**Steps:**
1. Load any save before Stage 130
2. Force fail state:
   ```
   setstage AotC_MainQuest 200
   ```

**Expected Results:**
- [ ] All AotC powers removed
- [ ] "Whisper to Shadow" removed
- [ ] "Shadow's Whisper" removed (if had)
- [ ] "Shadow's Step" removed (if had)
- [ ] Tarnished Insignia removed
- [ ] "Nocturnal's Rejection" curse applied
- [ ] Quest marked as failed
- [ ] Journal shows fail entry

**Console Verification:**
```
player.haspell XX______       ; WhisperToShadow - should be gone
player.haspell XX______       ; NocturnalRejection - should be present
player.getitemcount XX______  ; TarnishedInsignia - should be 0
```

---

### Test 7.2: Curse Effects
**Objective:** Verify curse penalties work

**Steps:**
1. Load save with curse applied
2. Check active effects
3. Test affected skills

**Expected Results:**
- [ ] Curse appears in Active Effects
- [ ] Sneak penalty visible (-10%)
- [ ] Barter penalty visible (-5%)

---

## Test Suite 8: Edge Cases

### Test 8.1: Rapid Stage Advancement
**Objective:** Test skipping stages

**Steps:**
1. Load `AotC_Test_Stage10`
2. Jump directly to Stage 70:
   ```
   setstage AotC_MainQuest 70
   ```

**Expected Results:**
- [ ] Stage sets correctly
- [ ] Powers from skipped stages are NOT granted
- [ ] Quest doesn't break
- [ ] Can continue from Stage 70

---

### Test 8.2: Backward Stage Setting
**Objective:** Test setting earlier stage

**Steps:**
1. Load `AotC_Test_Stage50`
2. Try to set Stage 30:
   ```
   setstage AotC_MainQuest 30
   ```

**Expected Results:**
- [ ] Either: Stage doesn't change (quest prevents)
- [ ] Or: Stage changes but doesn't re-trigger handler
- [ ] Quest doesn't break

---

### Test 8.3: Double Power Grant
**Objective:** Ensure powers aren't granted twice

**Steps:**
1. Load `AotC_Test_Stage50`
2. Note current powers
3. Trigger Stage 50 handler again (reset and re-set)
4. Check for duplicate powers

**Expected Results:**
- [ ] Player doesn't have duplicate powers
- [ ] No script errors

---

### Test 8.4: Missing Insignia at Completion
**Objective:** Test completion if player somehow lost Insignia

**Steps:**
1. Load `AotC_Test_Stage110`
2. Remove Insignia:
   ```
   player.removeitem XX000D63 1
   ```
3. Trigger Stage 130:
   ```
   setstage AotC_MainQuest 130
   ```

**Expected Results:**
- [ ] Quest still completes
- [ ] Restored Insignia still granted
- [ ] No script errors

---

### Test 8.5: Quest Active After Completion
**Objective:** Verify quest state after Stage 130

**Steps:**
1. Load `AotC_Test_Complete`
2. Check quest status:
   ```
   isrunning AotC_MainQuest
   getstage AotC_MainQuest
   ```

**Expected Results:**
- [ ] Quest either: stopped, or still running but complete
- [ ] Stage remains at 130
- [ ] No active objectives
- [ ] Powers persist
- [ ] Restored Insignia persists

---

### Test 8.6: New Game After Completion
**Objective:** Test starting fresh character after completing once

**Steps:**
1. With previous character at Stage 130
2. Start completely new game
3. Select AotC start again

**Expected Results:**
- [ ] Quest starts fresh at Stage 10
- [ ] No carryover from previous character
- [ ] Globals reset to 0

---

## Regression Test Checklist

Use this checklist before each release:

### Core Functionality
- [ ] AP start selection works
- [ ] Dream sequence plays
- [ ] Spawns in correct location with correct items
- [ ] Main quest starts at Stage 10
- [ ] Whisper to Shadow power granted

### Tracking
- [ ] Fenced gold tracking works
- [ ] Night theft tracking works
- [ ] Offerings bitmask updates correctly
- [ ] TG quest completion detected
- [ ] TG faction membership detected

### Stage Transitions
- [ ] 10 → 30 works (TG join + 500g)
- [ ] 30 → 50 works (first offerings)
- [ ] 50 → 70 works (second offerings + TG06)
- [ ] 70 → 90 works (TG08)
- [ ] 90 → 110 works (TG09)
- [ ] 110 → 130 works (GM + shrine)

### Rewards
- [ ] Shadow's Whisper granted at 50
- [ ] Shadow's Step granted at 70
- [ ] Shadow's Embrace granted at 110
- [ ] Shadow Form granted at 130
- [ ] Nocturnal's Redeemed granted at 130
- [ ] Insignia transformation works

### Fail State
- [ ] Stage 200 removes powers
- [ ] Stage 200 applies curse
- [ ] Quest fails properly

### No Conflicts
- [ ] TG questline still completable normally
- [ ] No Papyrus errors in log
- [ ] No crashes or freezes

---

## Debug Logging

### Enable Papyrus Logging

In `Documents/My Games/Skyrim Special Edition/Skyrim.ini`:
```ini
[Papyrus]
fPostLoadUpdateTimeMS=500.0
bEnableLogging=1
bEnableTrace=1
bLoadDebugInformation=1
```

### Log Location
```
Documents/My Games/Skyrim Special Edition/Logs/Script/Papyrus.0.log
```

### What to Look For

**Success patterns:**
```
[AotC] MainQuest OnInit - Stage: 0
[AotC] MainQuest Stage Set: 10
[AotC] Tracking started
[AotC] Fenced gold updated: 500
[AotC] MainQuest Stage Set: 30
```

**Error patterns:**
```
error: Cannot call X on a None object
warning: Property X on script Y has not been filled
[AotC] WARNING: Main quest property not set!
```

### Adding Debug Output

To add temporary debug output in scripts:
```papyrus
Debug.Trace("[AotC] Variable value: " + someVariable)
Debug.Notification("Visible debug message")
Debug.MessageBox("Popup debug - click to continue")
```

---

## Quick Test Commands

### Full Reset
```
stopquest AotC_MainQuest
stopquest AotC_StartQuest
resetquest AotC_MainQuest
resetquest AotC_StartQuest
setglobalvalue AotC_FencedGold 0
setglobalvalue AotC_NightTheftCount 0
setglobalvalue AotC_OfferingsComplete 0
setglobalvalue AotC_QuestStage 0
player.removespell XX______  ; Each power
```

### Fast Forward to Stage 50
```
player.addtofaction 00029DA9 0
setglobalvalue AotC_FencedGold 1500
setglobalvalue AotC_OfferingsComplete 15
setstage AotC_MainQuest 50
```

### Fast Forward to Stage 130
```
player.addtofaction 00029DA9 4
setstage TG03 200
setstage TG08A 200
setstage TG09 200
setglobalvalue AotC_OfferingsComplete 127
setstage AotC_MainQuest 130
```

### Grant All Powers (Testing)
```
player.addspell XX______  ; WhisperToShadow
player.addspell XX______  ; ShadowWhisper
player.addspell XX______  ; ShadowStep
player.addspell XX______  ; ShadowEmbrace
player.addspell XX______  ; ShadowForm
player.addspell XX______  ; NightingaleRedeemed
```

---

*Last Updated: January 2026*
*Document Version: 1.0*
