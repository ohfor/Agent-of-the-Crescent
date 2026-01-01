# Alternate Perspective Integration Guide

## Complete Implementation Pattern for Custom Quest Starts

This document captures the working pattern for integrating custom quest-based alternate starts with the Alternate Perspective mod. It was developed through iterative debugging of the Agent of the Crescent mod.

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Critical Timing Issue](#critical-timing-issue)
4. [File Structure](#file-structure)
5. [Step-by-Step Implementation](#step-by-step-implementation)
6. [The Script Pattern](#the-script-pattern)
7. [Creation Kit Configuration](#creation-kit-configuration)
8. [JSON Registration](#json-registration)
9. [FormID Reference](#formid-reference)
10. [Debugging Techniques](#debugging-techniques)
11. [Common Pitfalls](#common-pitfalls)
12. [Checklist](#checklist)

---

## Overview

Alternate Perspective (AP) allows modders to register custom starting scenarios via JSON configuration files. When a player selects your scenario, AP:

1. Starts your quest
2. Sets stage 10 on your quest
3. Expects your quest to move the player out of the AP holding cell

**If your quest fails to move the player**, AP displays a fallback message after ~30 seconds and moves them to Helgen Inn.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    ALTERNATE PERSPECTIVE                        │
│                                                                 │
│  1. Player selects your start from menu                        │
│  2. AP calls: YourQuest.Start()                                │
│  3. AP calls: YourQuest.SetStage(10)                           │
│  4. AP waits for player to leave holding cell                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      YOUR QUEST SCRIPT                          │
│                                                                 │
│  OnInit() fires AFTER stage 10 is already set                  │
│  ├── Check if quest IsRunning() AND GetStage() >= 10           │
│  ├── If true: Call your main function directly                 │
│  └── If false: SetStage(10) to trigger OnStageSet()            │
│                                                                 │
│  Your main function:                                            │
│  ├── Show intro/dream sequence                                  │
│  ├── Give starting items                                        │
│  ├── MoveTo() spawn marker                                      │
│  └── Stop quest (cleanup)                                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Critical Timing Issue

### The Problem

When AP triggers your quest, the execution order is:

1. AP calls `Quest.Start()`
2. AP calls `Quest.SetStage(10)`
3. **Then** your script's `OnInit()` fires

This means by the time `OnInit()` runs, stage 10 is **already set**. If you rely solely on `OnStageSet(10)` to trigger your logic, it will **never fire** because the stage was set before the script initialized.

### The Solution

In `OnInit()`, check if the stage is already >= 10 and call your main function directly:

```papyrus
Event OnInit()
    If IsRunning()
        If GetStage() >= 10
            ; Stage already set by AP before we initialized
            StartPlayer()
        Else
            ; Normal case - trigger via stage
            SetStage(10)
        EndIf
    EndIf
EndEvent

Event OnStageSet(int auiStageID, int auiItemID)
    If auiStageID == 10
        StartPlayer()
    EndIf
EndEvent
```

This pattern handles both cases:
- **AP integration**: Stage already 10 → call function directly from OnInit()
- **Console testing**: `setstage QuestID 10` → triggers OnStageSet()

---

## File Structure

```
YourMod/
├── YourMod.esp                           # Plugin file (created in CK)
├── Scripts/
│   └── YourStartQuest.pex                # Compiled script
├── Scripts/Source/                       # Optional - for distribution
│   └── YourStartQuest.psc                # Source script
└── SKSE/
    └── AlternatePerspective/
        └── YourMod.json                  # AP registration
```

### Deployment Locations

| File | Location |
|------|----------|
| ESP | `Data/YourMod.esp` |
| Compiled Script | `Data/Scripts/YourStartQuest.pex` |
| Source Script | `Data/Scripts/Source/YourStartQuest.psc` |
| AP JSON | `Data/SKSE/AlternatePerspective/YourMod.json` |

---

## Step-by-Step Implementation

### 1. Create the Script Source File

Create `Data/Scripts/Source/YourStartQuest.psc`:

```papyrus
Scriptname YourStartQuest extends Quest
{Your custom alternate start}

; =============================================================================
; PROPERTIES - Fill these in Creation Kit's Scripts tab
; =============================================================================

Actor Property PlayerRef Auto
{The player reference}

ObjectReference Property SpawnMarker Auto
{XMarker at your spawn location}

; Add more properties for items, messages, etc.

; =============================================================================
; INITIALIZATION - Handles AP's timing quirk
; =============================================================================

Event OnInit()
    If IsRunning()
        If GetStage() >= 10
            ; AP already set stage 10 before script initialized
            StartPlayer()
        Else
            SetStage(10)
        EndIf
    EndIf
EndEvent

Event OnStageSet(int auiStageID, int auiItemID)
    If auiStageID == 10
        StartPlayer()
    EndIf
EndEvent

; =============================================================================
; MAIN FUNCTION
; =============================================================================

Function StartPlayer()
    ; Your intro sequence here (messages, etc.)
    
    ; Move player to spawn location
    PlayerRef.MoveTo(SpawnMarker)
    
    ; Cleanup
    RegisterForSingleUpdate(1.0)
EndFunction

Event OnUpdate()
    Stop()
EndEvent
```

### 2. Create Assets in Creation Kit

1. **Load masters** (Skyrim.esm at minimum)
2. **Create quest**: `Character > Quest > New`
   - Set ID (e.g., `YourStartQuest`)
   - **UNCHECK** "Start Game Enabled" 
   - Set priority (50 is fine)
3. **Create spawn marker**: Place XMarker in your target cell
4. **Create messages**: `Miscellaneous > Message` (check "Message Box" flag)
5. **Create items**: As needed for starting equipment

### 3. Configure the Quest

#### Quest Data Tab
- ID: `YourStartQuest`
- Priority: 50
- **Start Game Enabled: UNCHECKED** ← Critical!

#### Quest Stages Tab
- Add Stage 0 (initial)
- Add Stage 10 (triggered by AP)
- Leave stage fragments **empty** (logic is in main script)

#### Scripts Tab
1. Click **Add**
2. Select your script (e.g., `YourStartQuest`)
3. Click on the script, then **Properties**
4. Fill in ALL properties:
   - `PlayerRef` → Select "PlayerRef" from dropdown
   - `SpawnMarker` → Your XMarker reference
   - Other properties as needed

### 4. Get the FormID

After saving the ESP:

1. Find your quest in CK: `Character > Quest > YourStartQuest`
2. Note the FormID shown in the list (e.g., `00000D67`)
3. Convert hex to decimal for JSON:
   - `0x00000D67` = `3431` decimal

**Quick hex-to-decimal**: Use Windows Calculator in Programmer mode, or:
- `0x800` = 2048
- `0xD67` = 3431
- `0x1000` = 4096

### 5. Create JSON Registration

Create `Data/SKSE/AlternatePerspective/YourMod.json`:

```json
[
  {
    "mod": "YourMod.esp",
    "id": 3431,
    "text": "Your Start Name"
  }
]
```

**Fields:**
- `mod`: Exact filename of your ESP (case-sensitive on some systems)
- `id`: FormID of your quest in **decimal**
- `text`: Display name in AP's menu

---

## The Script Pattern

### Complete Working Example

```papyrus
Scriptname AotC_StartQuest extends Quest
{Agent of the Crescent - Alternate Perspective Start Quest}

; =============================================================================
; PROPERTIES - Fill in Creation Kit
; =============================================================================

Actor Property PlayerRef Auto
{The player reference}

ObjectReference Property AotC_SpawnMarker Auto
{XMarker in Beggar's Row where player spawns}

MiscObject Property AotC_TarnishedInsignia Auto
{Starting trinket}

Armor Property AotC_RaggedRobes Auto
{Starting clothes}

Armor Property AotC_RaggedFootwraps Auto
{Starting shoes}

Message Property AotC_Dream01 Auto
Message Property AotC_Dream02 Auto
Message Property AotC_Dream03 Auto
Message Property AotC_Dream04 Auto

; =============================================================================
; INITIALIZATION
; =============================================================================

Event OnInit()
    ; Debug output (remove for release)
    Debug.Notification("AotC OnInit fired!")
    Debug.Trace("[AotC] OnInit - IsRunning: " + IsRunning() + ", Stage: " + GetStage())
    
    If IsRunning()
        If GetStage() >= 10
            ; Stage already set by AP, run directly
            StartPlayerInBeggarsRow()
        Else
            SetStage(10)
        EndIf
    EndIf
EndEvent

Event OnStageSet(int auiStageID, int auiItemID)
    If auiStageID == 10
        StartPlayerInBeggarsRow()
    EndIf
EndEvent

; =============================================================================
; MAIN FUNCTION
; =============================================================================

Function StartPlayerInBeggarsRow()
    ; Show dream sequence
    ShowDreamSequence()
    
    ; Strip and re-equip
    PlayerRef.RemoveAllItems()
    PlayerRef.AddItem(AotC_RaggedRobes, 1, true)
    PlayerRef.AddItem(AotC_RaggedFootwraps, 1, true)
    PlayerRef.AddItem(AotC_TarnishedInsignia, 1, true)
    PlayerRef.EquipItem(AotC_RaggedRobes, false, true)
    PlayerRef.EquipItem(AotC_RaggedFootwraps, false, true)
    
    ; Move player
    PlayerRef.MoveTo(AotC_SpawnMarker)
    
    ; Cleanup after brief delay
    RegisterForSingleUpdate(1.0)
EndFunction

Event OnUpdate()
    Stop()
EndEvent

; =============================================================================
; HELPER FUNCTIONS
; =============================================================================

Function ShowDreamSequence()
    Utility.Wait(0.5)
    AotC_Dream01.Show()
    Utility.Wait(0.3)
    AotC_Dream02.Show()
    Utility.Wait(0.3)
    AotC_Dream03.Show()
    Utility.Wait(0.3)
    AotC_Dream04.Show()
EndFunction
```

---

## Creation Kit Configuration

### Quest Settings

| Setting | Value | Notes |
|---------|-------|-------|
| Start Game Enabled | **UNCHECKED** | AP starts the quest |
| Run Once | Unchecked | Allows reuse |
| Priority | 50 | Standard |
| Type | None/Misc | Doesn't matter for start quests |

### Property Binding

When filling script properties in CK:

1. **Actor properties** → Use dropdown to select `PlayerRef`
2. **ObjectReference properties** → Click "Pick", navigate to your XMarker
3. **Form properties** (Armor, MiscObject, etc.) → Type EditorID or FormID
4. **Message properties** → Click "Pick", select your message

**Verify all properties are filled!** Empty properties cause silent failures.

### Stage Fragments

For AP integration, you typically **don't need stage fragments**. All logic lives in the main quest script's `OnInit()` and `OnStageSet()` events.

If you do use fragments, remember:
- Fragment scripts are auto-generated with names like `QF_YourQuest_00000D67`
- They extend your quest script
- They add complexity - avoid unless needed

---

## JSON Registration

### File Location

```
Data/SKSE/AlternatePerspective/YourMod.json
```

AP scans this folder on game load and registers all valid entries.

### JSON Format

```json
[
  {
    "mod": "YourMod.esp",
    "id": 3431,
    "text": "Display Name in Menu"
  }
]
```

### Multiple Starts in One Mod

```json
[
  {
    "mod": "YourMod.esp",
    "id": 3431,
    "text": "Start Option A"
  },
  {
    "mod": "YourMod.esp",
    "id": 3432,
    "text": "Start Option B"
  }
]
```

### Troubleshooting JSON

- Validate JSON syntax at jsonlint.com
- Ensure `mod` exactly matches ESP filename
- Ensure `id` is decimal, not hex
- Check Papyrus log for AP errors:
  ```
  [Alternate Perspective] Quest selected: yourmod.esp/3431
  ```

---

## FormID Reference

### Converting Hex to Decimal

The CK shows FormIDs in hexadecimal. JSON needs decimal.

| Hex | Decimal |
|-----|---------|
| 0x800 | 2048 |
| 0xD62 | 3426 |
| 0xD67 | 3431 |
| 0x1000 | 4096 |

### Windows Calculator Method

1. Open Calculator
2. Switch to Programmer mode
3. Select HEX
4. Enter your FormID (without 0x)
5. Switch to DEC
6. Read the decimal value

### FormID Structure

Full FormIDs have the format: `XXYYYYYY`
- `XX` = Load order index (changes based on load order)
- `YYYYYY` = Record index (what you put in JSON)

For JSON, use only the record index (last 6 digits), ignoring load order.

---

## Debugging Techniques

### Enable Papyrus Logging

In `Skyrim.ini`:
```ini
[Papyrus]
fPostLoadUpdateTimeMS=500.0
bEnableLogging=1
bEnableTrace=1
bLoadDebugInformation=1
```

Logs appear in: `Documents/My Games/Skyrim Special Edition/Logs/Script/Papyrus.0.log`

### Debug Output in Script

```papyrus
Event OnInit()
    Debug.Notification("YourQuest OnInit!")
    Debug.Trace("[YourMod] OnInit - IsRunning: " + IsRunning() + ", Stage: " + GetStage())
    ; ...
EndEvent
```

- `Debug.Notification()` → Shows on-screen
- `Debug.Trace()` → Writes to Papyrus log

### What to Look For

**Success indicators:**
```
[Alternate Perspective] Quest selected: yourmod.esp/3431
[YourMod] OnInit - IsRunning: TRUE, Stage: 10
```

**Failure indicators:**
```
[YourMod] OnInit - IsRunning: FALSE, Stage: 0
error: Cannot call MoveTo() on a None object
```

### Console Commands for Testing

```
; Check quest state
sqv YourStartQuest

; Manually set stage (tests OnStageSet path)
setstage YourStartQuest 10

; Check if quest running
getquestrunning YourStartQuest
```

---

## Common Pitfalls

### 1. "Start Game Enabled" is Checked

**Symptom**: Quest runs on every game load, not just when selected from AP.

**Fix**: Uncheck "Start Game Enabled" in quest data tab.

### 2. OnStageSet Never Fires

**Symptom**: Nothing happens after selecting your start.

**Cause**: AP sets stage 10 before OnInit() runs.

**Fix**: Check stage in OnInit() and call function directly:
```papyrus
If GetStage() >= 10
    StartPlayer()
EndIf
```

### 3. MoveTo() Does Nothing

**Symptom**: Player stays in AP holding cell.

**Cause**: Usually a None reference.

**Fix**: 
- Verify SpawnMarker property is filled in CK
- Add debug: `Debug.Trace("Marker: " + SpawnMarker)`
- Ensure marker exists in a loaded cell

### 4. Properties Are None

**Symptom**: `Cannot call X on a None object`

**Cause**: Properties not filled in CK's Scripts tab.

**Fix**: 
- Open quest in CK
- Go to Scripts tab
- Click your script
- Click Properties
- Fill ALL fields

### 5. Wrong FormID in JSON

**Symptom**: Start doesn't appear in AP menu.

**Cause**: Hex/decimal mismatch or wrong FormID.

**Fix**: 
- Get FormID from CK
- Convert hex to decimal
- Verify in JSON

### 6. Script Not Attached

**Symptom**: No script output at all.

**Cause**: Script not attached to quest.

**Fix**: 
- Open quest → Scripts tab
- Click Add
- Select your script
- Fill properties

---

## Checklist

### Before Testing

- [ ] Script source file in `Data/Scripts/Source/`
- [ ] Script compiled (`.pex` in `Data/Scripts/`)
- [ ] ESP saved in `Data/`
- [ ] JSON in `Data/SKSE/AlternatePerspective/`
- [ ] ESP enabled in load order

### Quest Configuration (CK)

- [ ] Quest ID set
- [ ] "Start Game Enabled" **UNCHECKED**
- [ ] Stage 10 added
- [ ] Script attached on Scripts tab
- [ ] ALL script properties filled
- [ ] ESP saved after changes

### Script Requirements

- [ ] Extends `Quest`
- [ ] `OnInit()` checks `IsRunning()` and `GetStage()`
- [ ] Direct function call if stage >= 10
- [ ] `OnStageSet()` handles stage 10
- [ ] `MoveTo()` called on PlayerRef
- [ ] Quest stops after completion

### JSON Requirements

- [ ] Valid JSON syntax
- [ ] `mod` matches ESP filename exactly
- [ ] `id` is decimal (not hex)
- [ ] `text` is your display name

---

## Reference: AP Papyrus Log Messages

```
; Quest selected successfully
[Alternate Perspective] Quest selected: yourmod.esp/3431 / Name: Display Name

; Quest not found (wrong FormID or ESP)
[Alternate Perspective] Failed to find quest: yourmod.esp/9999

; Player didn't leave holding cell (your script failed)
[Alternate Perspective] Player stuck - moving to Helgen Inn
```

---

## Version History

- **v1.0** (2026-01-01): Initial documentation based on AotC development
  - Documented critical OnInit/OnStageSet timing issue
  - Added complete working script pattern
  - Included debugging techniques

---

## Credits

Developed during Agent of the Crescent mod creation.  
Alternate Perspective by Arthmoor.

---

*Last updated: January 1, 2026*
