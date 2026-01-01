# Agent of the Crescent - Creation Kit Guide
## Hello World Version

This guide walks you through creating the ESP file in Creation Kit. By the end, you'll have a working alternate start that:
- Appears in Alternate Perspective's menu
- Shows a dream sequence
- Spawns you in Riften's Beggar's Row with rags and a trinket

---

## Prerequisites

1. **Creation Kit installed** (via Steam or Beth.net)
2. **Alternate Perspective** installed and working
3. The files from this repo in place:
   - `src/Scripts/Source/AoC_StartQuest.psc`
   - `src/SKSE/AlternatePerspective/AgentOfTheCrescent.json`

---

## Part 1: Setting Up Creation Kit

### First Launch Configuration

1. Launch Creation Kit (CK)
2. If prompted about "multiple master files", click **Yes** to allow it
3. Go to `File > Data...`
4. Check these masters:
   - [x] Skyrim.esm
   - [x] Update.esm
5. Click **OK**

> **Note**: We don't need Dawnguard.esm for Hello World. RiftenBeggarRow is a vanilla Skyrim.esm cell. We may add Dawnguard as a master later if we reference DLC content.

6. Wait for it to load (this takes a while first time)

### Create Your Plugin

1. Go to `File > Save`
2. Save as: `AgentOfTheCrescent.esp`
3. When prompted about ESL flag, click **Yes** (keeps it lightweight)

---

## Part 2: Create the Messages (Dream Sequence)

Messages are the popup text boxes the player sees.

### Message 1: The Void

1. In the left panel, navigate to: `Miscellaneous > Message`
2. Right-click > `New`
3. Fill in:
   - **ID**: `AotC_Dream01`
   - **Title**: (leave blank)
   - **Message Text**:
     ```
     Darkness. Cold. The endless void between stars.
     
     You float in nothing, feeling nothing, remembering... something.
     A blade falling. A moment of hesitation. Shadows screaming.
     ```
   - **Flags**: Check `Message Box` (important!)
4. Click **OK**

### Message 2: The Voice

1. Right-click > `New` in Messages
2. Fill in:
   - **ID**: `AotC_Dream02`
   - **Message Text**:
     ```
     A voice pierces the void - ancient, feminine, disappointed.
     
     "You were mine. My agent. My Nightingale. And when the moment came... you hesitated."
     ```
   - **Flags**: Check `Message Box`
3. Click **OK**

### Message 3: The Command

1. Right-click > `New`
2. Fill in:
   - **ID**: `AotC_Dream03`
   - **Message Text**:
     ```
     "I do not give second chances. But I am... curious. The shadows have need of a champion once more."
     
     "Find my Guild. Restore what was broken. Prove yourself worthy of the Crescent."
     ```
   - **Flags**: Check `Message Box`
3. Click **OK**

### Message 4: The Awakening

1. Right-click > `New`
2. Fill in:
   - **ID**: `AotC_Dream04`
   - **Message Text**:
     ```
     You wake with a gasp.
     
     The stench of Riften's underbelly fills your lungs. Damp stone. Rotting wood. 
     The muttering of beggars echoes in the darkness.
     
     In your hand, you clutch something cold - a tarnished insignia you don't remember taking.
     ```
   - **Flags**: Check `Message Box`
3. Click **OK**

---

## Part 3: Create the Items

### The Tarnished Insignia (MiscItem)

1. Navigate to: `Items > MiscItem`
2. Right-click > `New`
3. Fill in:
   - **ID**: `AotC_TarnishedInsignia`
   - **Name**: `Tarnished Insignia`
   - **Model**: `Clutter\Amulets\AmuletofArticulation01.nif` (or any small trinket mesh)
   - **Value**: 0
   - **Weight**: 0.1
4. Click **OK**

### Starting Clothes (Optional - or use vanilla)

For Hello World, we can use vanilla items:
- **Ragged Robes**: `0010A86E` (RaggedRobes)  
- **Footwraps**: `000261C0` (ClothesBootsBedraggled)

We'll reference these directly rather than creating new ones.

---

## Part 4: Create the Spawn Marker

We need an XMarker in Beggar's Row to spawn the player.

1. In the **Cell View** window, navigate to:
   - World Space: `Interiors`
   - Search/find: `RiftenBeggarRow`
2. Double-click to load the cell in the Render Window
3. In the Object Window, find: `WorldObjects > Static > XMarker`
4. Drag an XMarker into the Render Window
5. Position it somewhere sensible (near a bedroll, out of the way)
6. Double-click the marker to open its properties
7. Change the **Reference ID** to: `AotC_SpawnMarker`
8. Click **OK**

**Tip**: Use the `RiftenBeggarRow` cell - that's where Riften's homeless NPCs live, under the city.

---

## Part 5: Create the Quest

This is the heart of our mod.

### Create New Quest

1. Navigate to: `Character > Quest`
2. Right-click > `New`
3. In the **Quest Data** tab:
   - **ID**: `AotC_StartQuest`
   - **Priority**: 50
   - **Type**: Leave as default (None or Miscellaneous)
   - **Flags**: 
     - [x] Start Game Enabled
     - [ ] Everything else unchecked
4. **DON'T CLOSE YET** - we need more tabs

### Quest Aliases Tab

1. Click the **Quest Aliases** tab
2. Right-click in the alias list > `New Reference Alias`
3. Fill in:
   - **Alias Name**: `PlayerRef`
   - **Fill Type**: Select `Specific Reference`
   - Click `Select Forced Reference`, type `PlayerRef` and select it
4. Click **OK**

### Scripts Tab

1. Click the **Scripts** tab
2. Click **Add**
3. Type `AotC_StartQuest` and select it
   - If it's not there, you need to compile it first (see Troubleshooting)
4. Once attached, click on `AoC_StartQuest` in the list
5. Click **Properties**
6. Fill in each property:
   - `PlayerRef` → Point to your PlayerRef alias
   - `AotC_SpawnMarker` → Point to your XMarker
   - `AotC_TarnishedInsignia` → Point to your MiscItem
   - `AotC_RaggedRobes` → Type `0010A86E` or search for RaggedRobes
   - `AotC_RaggedFootwraps` → Type `000261C0` or search for ClothesBootsBedraggled
   - `AotC_Dream01` through `AotC_Dream04` → Point to your Messages

### Quest Stages Tab (Optional but Recommended)

1. Click **Quest Stages** tab
2. Add Stage `0` - Starting stage
3. Add Stage `10` - Complete (just for logging)

### Save the Quest

1. Click **OK** to close the Quest window
2. `File > Save`

---

## Part 6: Get the FormID

We need to know the FormID of `AoC_StartQuest` for the JSON file.

1. In the Object Window, find your quest: `Character > Quest > AotC_StartQuest`
2. The FormID is shown in the list (e.g., `xx000800`)
3. The `xx` is the load order position - we just need the last part
4. If it's `00000800`, that's `2048` in decimal

Update your `AgentOfTheCrescent.json`:
```json
[
  {
    "mod": "AgentOfTheCrescent.esp",
    "id": 2048,
    "text": "Agent of the Crescent"
  }
]
```

(If your FormID is different, convert the hex to decimal)

---

## Part 7: Compile the Script

If Creation Kit didn't auto-compile:

1. Open `src/Scripts/Source/AotC_StartQuest.psc` in a text editor
2. In Creation Kit, go to `Gameplay > Papyrus Script Manager`
3. Click **Compile All** (or find your script and compile it individually)
4. Check the output for errors

The compiled `.pex` file will appear in `Data/Scripts/`

---

## Part 8: Install and Test

### File Placement

Copy files to your Skyrim Data folder:
```
Data/
├── AgentOfTheCrescent.esp
├── Scripts/
│   └── AotC_StartQuest.pex
└── SKSE/
    └── AlternatePerspective/
        └── AgentOfTheCrescent.json
```

### Testing

1. Launch Skyrim with the mod enabled
2. Start a new game
3. In the Alternate Perspective starting room, talk to the Messenger
4. You should see "Agent of the Crescent" as an option
5. Select it
6. You should see the dream messages, then wake up in Beggar's Row

---

## Troubleshooting

### "Script not found" when attaching to quest
- Make sure `AotC_StartQuest.psc` is in `Data/Scripts/Source/`
- Try compiling manually via Papyrus Script Manager

### Quest doesn't appear in AP menu
- Check that JSON is in correct folder: `Data/SKSE/AlternatePerspective/`
- Verify the FormID in JSON matches the actual quest FormID
- Make sure ESP is enabled in your load order

### Player doesn't move to Beggar's Row
- Verify `AotC_SpawnMarker` exists and is properly linked
- Check script properties are all filled in

### "Beggar's Row" cell not found
- The cell ID is `RiftenBeggarRow` 
- Make sure Skyrim.esm is loaded as a master

---

## Next Steps

Once Hello World is working, we'll add:
1. The full quest (tracking Thieves Guild progress)
2. Wintersun integration
3. Powers progression
4. The Restored Insignia reward

But first - get this working! 🌙
