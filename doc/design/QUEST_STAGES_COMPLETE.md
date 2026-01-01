# Agent of the Crescent - Complete Quest Stages Specification

## Document Purpose

This document consolidates all quest stages across the mod's multiple quest structures:

1. **AotC_StartQuest** - The Alternate Perspective integration (already implemented)
2. **AotC_MainQuest** - The primary redemption arc tracking progression
3. **AotC_ShadowsOfThePast** - Optional lore-hunting side quest (Phase 3+)
4. **AotC_NightTheftTracker** - Story Manager event quest for nighttime theft tracking
5. **AotC_ShadowFence** - Shadow Fence NPC management
6. **AotC_WaningMoon** - Post-redemption Main Quest integration
7. **AotC_ShadowsCalling** - Alternative entry for non-AP players

**Note:** Main quest stages are spaced 20 apart (10, 30, 50, etc.) to allow room for future intermediate stages if needed.

---

# Quest 1: AotC_StartQuest (IMPLEMENTED)

## Purpose
Handles the Alternate Perspective integration - the opening sequence and initial spawn.

## Properties
- **Start Game Enabled:** NO (started by AP)
- **Run Once:** YES
- **Priority:** 50

## Stages

| Stage | Name | Description |
|-------|------|-------------|
| 0 | Not Started | Initial state |
| 10 | Selected | AP has started the quest and set this stage |

## Script Flow
```
OnInit() fires after AP sets Stage 10
    → Check if already at Stage 10 (AP timing quirk)
    → If yes: Call StartPlayerInBeggarsRow() directly
    → Show dream sequence (4 messages)
    → Give starting items
    → MoveTo spawn marker
    → Start AotC_MainQuest
    → Stop this quest
```

## Current Status: ✅ COMPLETE

---

# Quest 2: AotC_MainQuest

## Purpose
The primary quest tracking the player's redemption arc through the Thieves Guild storyline.

## Properties
- **Quest ID:** `AotC_MainQuest`
- **Quest Name:** "Shadow's Redemption"
- **Start Game Enabled:** NO (started by AotC_StartQuest)
- **Run Once:** YES
- **Allow Repeated Stages:** NO
- **Priority:** 50

## Quest Aliases

| Alias Name | Type | Fill Type | Purpose |
|------------|------|-----------|---------|
| PlayerRef | ReferenceAlias | Forced to Player | Track player |
| ShadowFence | ReferenceAlias | Created Reference | The summoned fence NPC |
| NocturnalShrine | ReferenceAlias | Specific Reference | Twilight Sepulcher shrine |
| SapphireRef | ReferenceAlias | Specific Reference | Sapphire NPC (for proximity) |
| MercerRef | ReferenceAlias | Specific Reference | Mercer Frey (for proximity) |

---

## Stage Reference

### Stage 0 - Not Started
- **Description:** Quest not yet initiated
- **Log Entry:** None
- **Completion Conditions:** None (initial state)

---

### Stage 10 - Awakening
- **Description:** Player has spawned in Beggar's Row via AotC_StartQuest
- **Log Entry:**
  > *I awoke in the filth of Riften's Ratway with nothing but rags and fragmented memories. A tarnished insignia clutched in my hand - cold metal that whispers of failure and second chances. I was something once. Something of shadow. I failed, and Nocturnal stripped everything from me.*
  >
  > *Now she offers redemption: Find the Thieves Guild. Find the betrayer who stole her Key. Return what was taken.*
  >
  > *I have nothing. I am nothing. Yet.*

- **Objectives Displayed:**
  - [ ] Find Nocturnal's Reminder in your inventory
  - [ ] Read Nocturnal's Reminder

- **Completion Conditions:**
  - Player reads the book `AotC_NocturnalReminder`

- **On Completion:**
  - Advance to Stage 15
  - Grant Lesser Power: "Whisper to Shadow" (summon Shadow Fence)

- **Script Actions:**
  - Register for book read event
  - Start tracking systems (offerings globals initialized)

---

### Stage 15 - The Path Forward
- **Description:** Player understands their mission
- **Log Entry:**
  > *The note is clear: Find a man named Brynjolf in the Riften marketplace. He leads what remains of the Thieves Guild. They are the path to the betrayer - to Mercer Frey and the Skeleton Key.*
  >
  > *But I cannot simply walk in. I must prove myself worthy - to the Guild, and to Nocturnal. The shadows demand offerings. Stolen goods fenced through her agent. The work of a true thief.*

- **Objectives Displayed:**
  - [ ] Find the Thieves Guild in Riften
  - [ ] Prove yourself through shadow's work
    - Stolen goods fenced: (0/500 gold) - through Shadow Fence

- **Completion Conditions:**
  - Player joins Thieves Guild faction (rank >= 0) AND
  - Gold fenced through Shadow Fence >= 500

- **On Completion:**
  - Advance to Stage 20

- **Script Actions:**
  - Register for faction change event (TG)
  - Poll/track gold fenced via Shadow Fence
  - Update objective display on progress

---

### Stage 20 - Accepted by Shadows
- **Description:** Player has joined the Guild and proven initial worth
- **Log Entry:**
  > *I've found the Guild and earned a place among them. They are diminished - a shadow of what they once were. Mercer Frey leads them still, bleeding them dry while they blame bad luck and broken traditions.*
  >
  > *The Guild does not know me. But sometimes, when I pass Sapphire in the Flagon, I feel... something. A cold weight in my chest. The Insignia grows colder. The shadows reach toward her like they're trying to remember.*
  >
  > *I must rise among them. Prove my worth through offerings of shadow. And discover what Mercer is truly hiding.*

- **Objectives Displayed:**
  - [ ] Complete the First Offerings (0/3)
    - [ ] Offering of Wealth - Fence 1,000 gold through the Shadow Fence
    - [ ] Offering of Cunning - Complete 5 Thieves Guild jobs
    - [ ] Offering of Boldness - Successfully pickpocket 25 people
  - [ ] Continue rising in the Guild

- **Completion Conditions:**
  - All 3 First Offerings complete (tracked via bitmask)

- **On Completion:**
  - Grant Lesser Power: "Shadow's Whisper" (Detect Life)
  - Deliver courier letter: `AotC_NocturnalLetter01`
  - Display notification: "Nocturnal acknowledges your progress..."
  - Advance to Stage 30

- **Tracking Implementation:**
  - Offering of Wealth: `AotC_FencedGold` GlobalVariable >= 1000
  - Offering of Cunning: Track TG radiant quest completions
  - Offering of Boldness: `Game.QueryStat("Pockets Picked")` >= 25

---

### Stage 30 - Shadow's Whisper
- **Description:** First power restored, deeper into the Guild
- **Log Entry:**
  > *Nocturnal returns a fragment of what I was. I can sense the living through walls now - the shadows whisper their locations to me. It is a taste of former power, a reminder of what I lost.*
  >
  > *The Guild speaks of troubles. Jobs going wrong. Maven Black-Briar's displeasure. Something is rotten at the heart of this organization, and I suspect I know who.*
  >
  > *Mercer watches me. I feel his eyes even when I cannot see them. The shadows around him feel... wrong. They recoil from him like water from hot iron.*

- **Objectives Displayed:**
  - [ ] Complete the Second Offerings (0/3)
    - [ ] Offering of Darkness - Steal 40 items during nighttime (9 PM - 5 AM)
    - [ ] Offering of Ambition - Steal from a Jarl's residence
    - [ ] Offering of Secrets - Discover the truth about Mercer Frey
  - [ ] Continue the Guild questline

- **Completion Conditions:**
  - All 3 Second Offerings complete AND
  - TG Quest "Speaking With Silence" (TG06) complete

- **On Completion:**
  - Grant Lesser Power: "Shadow's Step" (Invisibility)
  - Deliver courier letter: `AotC_NocturnalLetter02`
  - Display notification: "The shadows welcome you deeper..."
  - Advance to Stage 40

- **Tracking Implementation:**
  - Offering of Darkness: `AotC_NightTheftCount` GlobalVariable >= 40 (via Story Manager)
  - Offering of Ambition: Check stolen items from Jarl residence locations
  - Offering of Secrets: GetStageDone on TG06

---

### Stage 40 - The Betrayer Revealed
- **Description:** Mercer's treachery exposed
- **Log Entry:**
  > *Mercer Frey. Murderer. Traitor. Thief of the Skeleton Key itself.*
  >
  > *Twenty-five years he has held Nocturnal's artifact. Twenty-five years the Guild has withered under his "leadership." And I... I was there when it happened. I had the chance to stop him. I hesitated. I failed.*
  >
  > *Karliah has returned, seeking justice for Gallus. She does not know me - or does she sense something? When our eyes met in Snow Veil Sanctum, I felt the Insignia pulse with cold.*
  >
  > *This time, I will not hesitate.*

- **Objectives Displayed:**
  - [ ] Hunt down Mercer Frey
  - [ ] Reclaim the Skeleton Key

- **Completion Conditions:**
  - TG Quest "Blindsighted" (TG08A) complete

- **On Completion:**
  - Deliver courier letter: `AotC_NocturnalLetter03`
  - Advance to Stage 50

- **Script Actions:**
  - Monitor TG08A (Blindsighted) completion

---

### Stage 50 - The Key Reclaimed
- **Description:** Mercer dead, Key recovered
- **Log Entry:**
  > *Mercer Frey is dead. The Skeleton Key rests in my hands once more - cold metal that hums with potential. I could keep it. Use it. Unlock anything, become unstoppable.*
  >
  > *But that is not my path. I know now what I must do.*
  >
  > *Karliah speaks of restoring the Nightingales, of returning the Key to the Twilight Sepulcher. She does not know that I walked those halls once before, in a life I cannot remember. She does not know that one of Nocturnal's lost pieces already stands beside her.*
  >
  > *The Sepulcher awaits.*

- **Objectives Displayed:**
  - [ ] Return the Skeleton Key to the Twilight Sepulcher

- **Completion Conditions:**
  - TG Quest "Darkness Returns" (TG09) complete

- **On Completion:**
  - Grant Lesser Power: "Shadow's Embrace" (Speed burst + muffle)
  - Advance to Stage 60

- **Optional Trigger (If Player Keeps Key Too Long):**
  - After 7 in-game days holding Key without returning:
  - Deliver courier letter: `AotC_NocturnalLetter04` (reminder)

---

### Stage 60 - Darkness Returns
- **Description:** Key returned, near the end
- **Log Entry:**
  > *The Key rests once more in the Sepulcher. I walked the Pilgrim's Path, faced the spectral sentinels, and emerged. Nocturnal's presence filled that place - vast, cold, knowing.*
  >
  > *She did not speak to me directly. Not yet. But I felt her acknowledgment. Her patience.*
  >
  > *The work is not complete. I must rise to lead the Guild I once abandoned. Restore what Mercer corrupted. Only then will the circle close.*

- **Objectives Displayed:**
  - [ ] Become the Guild Master of the Thieves Guild
  - [ ] Return to Nocturnal's shrine in the Twilight Sepulcher

- **Completion Conditions:**
  - Player has Guild Master rank in Thieves Guild AND
  - Player activates Nocturnal's shrine in the inner sanctum

- **On Completion:**
  - Trigger final sequence
  - Advance to Stage 70

- **Script Actions:**
  - Monitor faction rank for Guild Master
  - Add activation script to shrine (or use trigger box)

---

### Stage 70 - Redemption (PRIMARY ARC COMPLETE)
- **Description:** Full redemption achieved
- **Log Entry:**
  > *It is done.*
  >
  > *I knelt before Nocturnal's shrine as Guild Master, my debts paid in full. The shadows parted, and she spoke - not as the cold judge who condemned me, but as something almost... satisfied.*
  >
  > *"You have redeemed what was lost. The Key is returned. The betrayer is dead. The Guild rises again under worthy leadership."*
  >
  > *"Your failure is forgiven. Your power is restored. You are my Agent once more - my Agent of the Crescent, waxing toward fullness."*
  >
  > *The Tarnished Insignia blazed with sudden warmth. When the light faded, it gleamed like new - no, better than new. A symbol of redemption earned.*
  >
  > *But her final words trouble me still:*
  >
  > *"The World-Eater stirs. Dragons return to Skyrim. If Alduin succeeds, there will be no shadows left - only ash and fire. Your redemption was just the beginning. Now... prevent a future failure."*
  >
  > *It seems my work has only begun.*

- **Objectives Displayed:**
  - [X] Quest Complete - Shadow's Redemption

- **On Completion:**
  - Grant Greater Power: "Shadow Form" (Ethereal + speed)
  - Grant Ability: "Nocturnal's Redeemed" (passive thief bonuses)
  - Transform `AotC_TarnishedInsignia` → `AotC_RestoredInsignia`
  - Play completion sound/visual effect
  - Set `AotC_QuestComplete` global to 1
  - **Start AotC_WaningMoon quest** (post-redemption MQ integration)
  - Keep quest running for post-game tracking

---

### Stage 200 - Abandoned (FAIL STATE)
- **Description:** Player forsook Nocturnal
- **Log Entry:**
  > *I have forsaken Nocturnal. Turned my back on her bargain. Sought redemption elsewhere - or simply rejected redemption entirely.*
  >
  > *Her voice came one final time, cold as the void between stars:*
  >
  > *"You were given a second chance. You squandered it. There will be no third."*
  >
  > *The Insignia crumbled to dust in my hands. The shadows no longer answer my call - they recoil from me now, as they recoiled from Mercer. I am marked. Cursed. Whatever I might have become, that path is closed forever.*
  >
  > *I must find my own way forward, bearing the weight of two failures.*

- **Objectives Displayed:**
  - [X] Quest Failed - Nocturnal Abandoned

- **Trigger Conditions:**
  - Player changes deity in Wintersun after receiving warning AND
  - Player confirms the change despite warning

- **On Completion:**
  - Remove all granted AotC powers
  - Remove `AotC_TarnishedInsignia` (crumbles)
  - Grant Ability: "Nocturnal's Rejection" (permanent curse debuff)
  - Set `AotC_NocturnalAbandoned` global to 1
  - Stop quest

---

## Global Variables

| Variable Name | Type | Purpose |
|---------------|------|---------|
| `AotC_FencedGold` | Int | Gold fenced through Shadow Fence |
| `AotC_NightTheftCount` | Int | Items stolen during nighttime |
| `AotC_TGJobsComplete` | Int | Radiant TG jobs completed |
| `AotC_OfferingsComplete` | Int | Bitmask of completed offerings |
| `AotC_QuestComplete` | Bool | True when Stage 70 reached |
| `AotC_NocturnalAbandoned` | Bool | True when Stage 200 reached |
| `AotC_ShadowFenceGoldCap` | Int | Current fence gold capacity |
| `AotC_ShadowFenceTier` | Int | Current fence progression tier |
| `AotC_KeyHoldDays` | Int | Days holding Skeleton Key (for reminder) |

## Offerings Bitmask

| Bit | Hex | Offering |
|-----|-----|----------|
| 0 | 0x01 | Wealth I (500g fenced) |
| 1 | 0x02 | Wealth II (1000g fenced) |
| 2 | 0x04 | Cunning (5 TG jobs) |
| 3 | 0x08 | Boldness (25 pickpockets) |
| 4 | 0x10 | Darkness (40 nighttime thefts) |
| 5 | 0x20 | Ambition (Jarl residence theft) |
| 6 | 0x40 | Secrets (Speaking With Silence) |

---

# Quest 3: AotC_ShadowsOfThePast (Side Quest)

## Purpose
Optional lore-hunting quest tracking discovery of Brynjolf's hidden journal pages.

## Properties
- **Quest ID:** `AotC_ShadowsOfThePast`
- **Quest Name:** "Shadows of the Past"
- **Type:** Miscellaneous Quest
- **Start Game Enabled:** NO (started by reading Brynjolf's Journal)
- **Run Once:** YES

## Trigger
Player reads `AotC_BrynjolfJournal` (book placed near Brynjolf's bed in the Cistern)

## Prerequisites
- Shadow Fence hint dialogue (unlocks at 40+ nighttime thefts)
- Player must discover the journal themselves - NO quest markers

---

## Stages

### Stage 0 - Not Started
- **Description:** Quest not yet initiated

---

### Stage 10 - Journal Discovered
- **Description:** Player found and read Brynjolf's journal
- **Log Entry:**
  > *I found a personal journal near Brynjolf's bed in the Cistern. Several pages have been torn out. The entries span decades - speaking of dreams from Nocturnal, a command to "find the child, protect the child," and growing suspicion about Mercer Frey.*
  >
  > *Brynjolf has been watching Sapphire for years. He believes she is important somehow - connected to Nocturnal's designs. And in the final entry, he writes of sensing something familiar in me.*
  >
  > *The missing pages might still exist. Hidden somewhere. What was Brynjolf trying to bury?*

- **Objectives Displayed:**
  - [ ] Discover the truth hidden in Brynjolf's missing pages (0/4 found)

- **Completion Conditions:**
  - Automatically advances as pages are found

---

### Stage 20 - First Page Found
- **Description:** Glover's confession discovered
- **Log Entry:**
  > *I found a torn page from Brynjolf's journal hidden in Glover Mallory's house in Raven Rock.*
  >
  > *It describes Glover's confession - not just abandoning a woman and child, but the woman herself. "Impossibly beautiful." Otherworldly. She appeared in a barn and waited for him as if she knew he would come.*
  >
  > *They lived together for a year. When the child was born, Glover felt watched. Shadows moved wrong. Dreams he couldn't remember.*
  >
  > *So he ran. Years later, he returned to find the village burned. Everyone dead.*
  >
  > *Three pages remain missing.*

- **Objectives Displayed:**
  - [ ] Discover the truth hidden in Brynjolf's missing pages (1/4 found)

---

### Stage 30 - Second Page Found
- **Description:** Gallus's notes discovered
- **Log Entry:**
  > *Another page, found in Snow Veil Sanctum - the place where Mercer's betrayal was revealed.*
  >
  > *Brynjolf followed Mercer here years ago. He found old Guild records. Gallus's handwriting. Notes about Nocturnal's agents beyond the Nightingale Trinity - "shadows that watch, guardians that protect her interests."*
  >
  > *One guardian was assigned to watch over "something precious." The notes don't say what. But Gallus's final entry reads: "The guardian has gone silent. Mercer claims ignorance. I don't believe him."*
  >
  > *This was written weeks before Gallus died.*
  >
  > *Two pages remain missing.*

- **Objectives Displayed:**
  - [ ] Discover the truth hidden in Brynjolf's missing pages (2/4 found)

---

### Stage 40 - Third Page Found
- **Description:** Nightingale revelation
- **Log Entry:**
  > *A page hidden in Nightingale Hall itself. Written the night Brynjolf took the oath.*
  >
  > *He finally understood. The dreams were real. Nocturnal spoke to him because she needed someone to do what she could not - find Sapphire, protect her, keep her close.*
  >
  > *But protect her from what? Standing in the Hall, Brynjolf felt the answer: Mercer. The Skeleton Key. Something Mercer feared about "a traumatized girl with no memory of her true nature."*
  >
  > *And there's more. During the oath, Brynjolf sensed another presence. "A hole where something should be." The guardian Gallus wrote about - still out there. Broken. Lost. But not gone.*
  >
  > *One page remains.*

- **Objectives Displayed:**
  - [ ] Discover the truth hidden in Brynjolf's missing pages (3/4 found)

---

### Stage 50 - All Pages Found (QUEST COMPLETE)
- **Description:** Full truth revealed
- **Log Entry:**
  > *The final page. Found in Irkngthand, where Mercer met his end. Written just before Brynjolf went to confront him.*
  >
  > *Nocturnal whispered to him the night before: "The circle closes. The guardian returns. Watch for the one the shadows remember."*
  >
  > *He writes of me. The beggar he found in the Riften marketplace. The one the shadows lean toward, just as they lean toward Sapphire. The one who looks at Mercer with "recognition they don't understand."*
  >
  > *"If we survive this, I need to know who they really are."*
  >
  > *The truth is staggering. Sapphire is precious to Nocturnal - perhaps more than precious. Brynjolf has been her secret guardian for years, acting on a divine dream. And I... I was a guardian too. One who failed. One the shadows remember even when I do not.*
  >
  > *Nocturnal took everything from me as punishment. Now she offers it back.*
  >
  > *The shadows remember. Now, so do I.*

- **Objectives Displayed:**
  - [X] Quest Complete - The truth revealed

- **On Completion:**
  - Set `AotC_LoreComplete` global to 1
  - Optional: Unlock new dialogue with Brynjolf (Stage 2+)

---

## Page Locations

| Page | Location | Cell | Discovery Context |
|------|----------|------|-------------------|
| Journal | Brynjolf's bed area | RiftenRaggedFlagonCistern | After Shadow Fence hint |
| Page 1 | Glover's basement | DLC2RavenRock (Solstheim) | Dragonborn DLC exploration |
| Page 2 | Snow Veil Sanctum | SnowVeilSanctum | After "Speaking With Silence" |
| Page 3 | Nightingale Hall | NightingaleHall | After becoming Nightingale |
| Page 4 | Irkngthand | Irkngthand | During/after "Blindsighted" |

---

# Quest 4: AotC_NightTheftTracker (Story Manager)

## Purpose
Event-driven quest that fires on every theft to check for nighttime conditions.

## Properties
- **Quest ID:** `AotC_NightTheftTracker`
- **Start Game Enabled:** NO (started by Story Manager only)
- **Run Once:** NO (must be re-triggerable)

## Story Manager Setup

**Event:** Player Add Item
**Node Conditions:**
- GetEventData OwnerRef != None
- GetEventData OwnerRef != PlayerRef
- GetGlobalValue AotC_QuestComplete == 0 (stop tracking after quest complete)

## Script

```papyrus
Scriptname AotC_NightTheftScript extends Quest

GlobalVariable Property AotC_NightTheftCount Auto
GlobalVariable Property AotC_MainQuestStage Auto
Message Property AotC_NightTheftNotification Auto

Event OnStoryPlayerAddItem(ObjectReference akOwner, ObjectReference akContainer, Location akLocation, Form akItemBase)
    ; Only fires when item had a non-player owner (stolen!)
    
    ; Check if main quest is active
    If AotC_MainQuestStage.GetValue() < 30
        Stop()
        Return
    EndIf
    
    ; Calculate current game hour
    Float currentTime = Utility.GetCurrentGameTime()
    Float currentHour = (currentTime - Math.Floor(currentTime)) * 24.0
    
    ; Check if nighttime (9 PM to 5 AM)
    If currentHour >= 21.0 || currentHour < 5.0
        ; Nighttime theft - count it!
        AotC_NightTheftCount.Mod(1)
        
        Int count = AotC_NightTheftCount.GetValueInt()
        
        ; Subtle feedback at milestones
        If count == 10
            Debug.Notification("The night witnesses your devotion...")
        ElseIf count == 25
            Debug.Notification("Nocturnal's domain embraces your work...")
        ElseIf count == 40
            Debug.Notification("The Offering of Darkness is complete.")
            ; Main quest handles the actual completion
        EndIf
    EndIf
    
    ; Stop quest so Story Manager can re-trigger it
    Stop()
EndEvent
```

---

# Quest 5: AotC_ShadowFence (Support Quest)

## Purpose
Manages the Shadow Fence NPC and fencing interactions.

## Properties
- **Quest ID:** `AotC_ShadowFence`
- **Start Game Enabled:** NO (started when player receives Insignia)
- **Run Once:** NO

## Functionality
- Creates/manages the Shadow Fence actor when summoned
- Tracks gold received from fencing
- Updates fence gold cap based on progression tier
- Handles fence dialogue variations

## Shadow Fence Progression

| Tier | Trigger | Gold Cap | Buy Rate | Demeanor |
|------|---------|----------|----------|----------|
| 0 | Quest Start | 250 | 10% | Dismissive |
| 1 | 500g fenced | 500 | 12% | Less contemptuous |
| 2 | First TG job | 750 | 15% | Acknowledging |
| 3 | Joined Guild | 1000 | 18% | Professional |
| 4 | City influence | 1500 | 22% | Respectful |
| 5 | Killed Mercer | 2500 | 28% | Warm |
| 6 | Returned Key | 5000 | 35% | Near-equal |

---

# Quest 6: AotC_WaningMoon (Post-Redemption MQ Integration)

## Purpose
Bridges the completed redemption arc to Skyrim's Main Quest, providing Nocturnal's perspective on the dragon crisis.

## Properties
- **Quest ID:** `AotC_WaningMoon`
- **Quest Name:** "The Waning Moon"
- **Type:** Main Quest (Miscellaneous display)
- **Start Game Enabled:** NO (started by AotC_MainQuest Stage 70)
- **Run Once:** YES

## Design Philosophy
**Assume nothing about the player.** They may have:
- Never triggered Helgen/dragons
- Be mid-Main Quest
- Already defeated Alduin
- Never intend to do the Main Quest

Our systems detect MQ state and adapt content accordingly.

---

## MQ State Detection

Before triggering content, we check Main Quest progress:

| State Value | Condition | Path |
|-------------|-----------|------|
| 4 | MQ17 (Dragonslayer) complete | Path C: Post-MQ |
| 3 | MQ02 (Dragon Rising) complete | Path A: Dragonborn |
| 2 | MQ01 (Before the Storm) complete | Path B-1: Helgen witnessed |
| 1 | MQ01 not complete | Path B-2: Dragons not encountered |

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

---

## Stages

### Stage 0 - Not Started
- **Description:** Quest not yet initiated
- **Trigger:** AotC_MainQuest reaches Stage 70

---

### Stage 10 - Nocturnal's Warning
- **Description:** Player informed of dragon threat via dream
- **Trigger:** 24-48 hours after Stage 70 completion + player sleeps
- **Variation:** Dream content varies based on MQ state (see below)

#### Path A Dream (Dragonborn Confirmed):

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
> *You wake.*

#### Path B-1 Dream (Helgen Witnessed):

> *"The World-Eater returns. You witnessed his arrival at Helgen, though you may not have known what you saw."*
>
> *"There is a prophecy. A Dragonborn who can consume dragon souls. The only mortal weapon against Alduin."*
>
> *"Discover if you are this Dragonborn. Seek out the Greybeards. Answer their summons. If you carry the dragon blood... the shadows will need you more than ever."*

#### Path B-2 Dream (Dragons Not Encountered):

> *"The World-Eater stirs. You may not have seen the signs yet, but dragons return to Skyrim."*
>
> *"There is a prophecy. A Dragonborn who can end this threat. The shadows need this champion to succeed."*
>
> *"Watch the skies. When the dragons come - and they will come - you may find yourself more connected to them than you expect."*
>
> *"Or perhaps another will rise to face them. Either way, the shadows are invested in their defeat."*

- **Journal Entry (Path A):**
  > *Another dream from Nocturnal. Another task - but this one I was already bound to.*
  >
  > *She knows I am Dragonborn. She showed me what Alduin's victory would mean: not just the death of Skyrim, but the death of shadow itself. No darkness. No secrets. No night for thieves to work.*
  >
  > *The dragon crisis isn't just about saving the world. It's about preserving the very concept of darkness.*
  >
  > *Nocturnal promises aid. I don't know what form that will take, but knowing the shadows themselves have stakes in this fight... it changes things.*

- **Reward Granted:**
  - **Lesser Power: "Evergloam's Shroud"**
    - Once per day
    - 60 seconds: Dragons cannot detect you while sneaking
    - Visual: Subtle shadow wisps

- **Objectives (Path A):**
  - [ ] Defeat Alduin, the World-Eater

- **Objectives (Path B):**
  - [ ] Learn more about the dragon threat
  - [ ] Discover if you are Dragonborn

---

### Stage 20 - Dragonborn Confirmed
- **Description:** Player has absorbed a dragon soul (for Path B players who progress)
- **Trigger:** MQ02 stage 200 complete (first dragon soul absorbed)
- **Note:** Path A players skip this stage (already confirmed)

- **Insignia Pulse + Message:**
  > *The Insignia flares cold against your chest. A whisper:*
  >
  > *"So. You are the Dragonborn. This is... unexpected. And fortunate. The shadows will aid you when you hunt the World-Eater."*

- **On Completion:**
  - Grant Evergloam's Shroud if not already granted
  - Update objectives to match Path A

---

### Stage 30 - Shadow's Vigil (Optional)
- **Description:** Mid-MQ acknowledgment
- **Trigger:** MQ13 (Alduin's Bane) complete - player learns Dragonrend
- **Note:** Subtle check-in, not required for progression

- **Insignia Pulse + Message:**
  > *The Insignia grows warm against your chest. Not hot - comforting. Encouraging.*
  >
  > *A whisper, barely audible:*
  >
  > *"You carry the words that ground the World-Eater. Use them well. The shadows watch."*

- **No mechanical reward** - narrative reinforcement only

---

### Stage 40 - The World-Eater Falls
- **Description:** Alduin defeated, final rewards granted
- **Trigger:** MQ17 (Dragonslayer) complete

- **Dream Sequence (next sleep):**
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

- **Journal Entry:**
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

- **Rewards:**

  1. **Insignia Final Transformation:**
     - `AotC_RestoredInsignia` → `AotC_FullMoonInsignia`
     - All previous bonuses PLUS:
       - Muffle effect while sneaking
       - 10% chance on hit: Become invisible for 3 seconds
       - Subtle shadow particle visual effect

  2. **Passive Ability: "Nocturnal's Chosen"**
     - Permanent +15% better prices with fences
     - Permanent +10% pickpocket success chance
     - Dragons deal 10% less damage to you

  3. **Afterlife Promise:**
     - Narrative significance
     - Player's soul destined for the Evergloam upon death
     - Could hook into death alternative mods

- **On Completion:**
  - Advance to Stage 100

---

### Stage 100 - Complete
- **Description:** Quest finished
- **Objectives:**
  - [X] Quest Complete - The Waning Moon

---

### Stage 200 - Post-MQ Path
- **Description:** Player had already defeated Alduin before reaching Stage 70
- **Trigger:** AotC_MainQuest Stage 70 AND MQ17 already complete

- **Dream Sequence (immediate, no delay):**
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

- **Journal Entry:**
  > *When I completed my redemption, Nocturnal revealed something I never expected: the dragon crisis wasn't just about Skyrim. Alduin's victory would have burned away the very concept of shadow.*
  >
  > *And I stopped him. Before I even knew what was at stake.*
  >
  > *She called it "more than redemption." Said the balance was restored beyond what she'd asked. I'm not sure what that means for my future, but the look she gave me - if a Daedric Prince can look at anyone - was something I've never seen from her.*
  >
  > *Gratitude. From the Mistress of Shadows herself.*

- **Rewards:**
  - Skip directly to Stage 40 rewards (Full Moon Insignia, Nocturnal's Chosen)
  - Advance to Stage 100

---

## Global Variables (WaningMoon)

| Variable Name | Type | Purpose |
|---------------|------|---------|
| `AotC_MQState` | Int | Cached MQ progress state (0-4) |
| `AotC_WaningMoonStarted` | Bool | Whether post-70 content has begun |
| `AotC_DragonbornConfirmed` | Bool | Player has absorbed a dragon soul |
| `AotC_AlduinDefeated` | Bool | MQ17 complete |

---

# Quest 7: AotC_ShadowsCalling (Alternative Entry)

## Purpose
Provides entry to AotC content for players NOT using Alternate Perspective who discover the mod through the Thieves Guild.

## Properties
- **Quest ID:** `AotC_ShadowsCalling`
- **Quest Name:** "Shadow's Calling"
- **Type:** Miscellaneous
- **Start Game Enabled:** NO
- **Run Once:** YES

## Trigger Conditions
Player completes TG09 (Darkness Returns) AND:
- AotC_MainQuest is NOT running
- AotC_StartQuest is NOT running
- Player sleeps

---

## Stages

### Stage 0 - Not Started
- **Description:** Quest not yet initiated

---

### Stage 10 - Dream Received
- **Description:** Player receives Insignia and direction to Sepulcher

- **Dream Sequence:**
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

- **On Stage Set:**
  - Player receives `AotC_TarnishedInsignia`
  - Grant Lesser Power: "Whisper to Shadow" (summon Shadow Fence)

- **Objectives:**
  - [ ] Return to the Twilight Sepulcher
  - [ ] Speak with Nocturnal

---

### Stage 20 - Sepulcher Visited
- **Description:** Player reaches Nocturnal's shrine

- **Dialogue/Scene:**
  > *The shrine pulses with dark light. Nocturnal's presence fills the chamber.*
  >
  > *"You returned what the traitor stole. You restored my connection to your world. For this, you have already proven your worth."*
  >
  > *"But you did not know the full stakes. Alduin returns. The World-Eater seeks to rule, not to end. If he succeeds, this realm will burn with eternal dragonfire."*
  >
  > *"Shadows cannot exist in such a world. My realm would wither. My influence would fade."*
  >
  > *"I cannot act against him directly. But you can. You, who walk between shadow and light. You, who the dragons cannot ignore."*
  >
  > *"Take my blessing. Use it to cloak yourself from the fire-born. And when you face the World-Eater... remember that the shadows stand with you."*

- **On Completion:**
  - Grant all accumulated AotC powers (compressed progression)
  - Advance to Stage 30

---

### Stage 30 - Blessing Received
- **Description:** Nocturnal grants powers, quest merges to WaningMoon

- **Rewards (all at once):**
  - Lesser Power: "Shadow's Whisper" (Detect Life)
  - Lesser Power: "Shadow's Step" (Invisibility)
  - Lesser Power: "Shadow's Embrace" (Speed burst + muffle)
  - Greater Power: "Shadow Form" (Ethereal + speed)
  - Ability: "Nocturnal's Redeemed" (passive thief bonuses)
  - Transform `AotC_TarnishedInsignia` → `AotC_RestoredInsignia`
  - Lesser Power: "Evergloam's Shroud" (dragon detection immunity)

- **On Completion:**
  - Start AotC_WaningMoon at Stage 10 (or Stage 200 if MQ complete)
  - Advance to Stage 40

---

### Stage 40 - Complete
- **Description:** Quest finished, merged into WaningMoon
- **Objectives:**
  - [X] Quest Complete

---

## Design Note

This is a **compressed** version of AotC for players who proved themselves by returning the Skeleton Key without using our Alternate Perspective start.

**They skip:**
- The redemption arc (already redeemed via Key return)
- The Offering system (already a Nightingale)
- Progressive power unlocks (get them all at once)

**They gain:**
- The Insignia and its bonuses
- The dragon crisis context
- Access to Waning Moon content
- The afterlife promise upon MQ completion

---

# Courier Letter Triggers

| Letter | Trigger Stage | Delivery Method |
|--------|---------------|-----------------|
| `AotC_NocturnalLetter01` | Stage 20 → 30 | On stage transition |
| `AotC_NocturnalLetter02` | Stage 30 → 40 | On stage transition |
| `AotC_NocturnalLetter03` | Stage 40 → 50 | On stage transition |
| `AotC_NocturnalLetter04` | 7 days holding Key | Conditional check |

---

# Integration Points

## Thieves Guild Quests Referenced

| Quest ID | Quest Name | Our Hook |
|----------|------------|----------|
| TG00 | A Chance Arrangement | Join faction trigger |
| TG02 | Loud and Clear | Brynjolf dialogue injection |
| TG06 | Speaking With Silence | Offering of Secrets completion |
| TG08A | Blindsighted | Stage 40 → 50 transition |
| TG09 | Darkness Returns | Stage 50 → 60 transition / ShadowsCalling trigger |
| TGLeadership | Under New Management | Guild Master rank check |
| TGCity* | City Influence quests | Shadow Fence tier 4 |

## Main Quest Referenced

| Quest ID | Quest Name | Our Hook |
|----------|------------|----------|
| MQ01 | Before the Storm | MQ state detection (Helgen) |
| MQ02 | Dragon Rising | MQ state detection (Dragonborn confirm) |
| MQ13 | Alduin's Bane | Optional Stage 30 (WaningMoon) |
| MQ17 | Dragonslayer | Stage 40 completion (WaningMoon) |

## Wintersun Integration

- On quest start: Set Nocturnal as deity (if Wintersun installed)
- Monitor deity changes via polling (every 30 seconds)
- First non-Nocturnal worship: Warning message
- Confirmed deity change: Trigger Stage 200

---

# Implementation Priority

## Phase 1 - Core Loop
1. [ ] AotC_MainQuest stages 10-20
2. [ ] AotC_NocturnalReminder note item
3. [ ] Basic Shadow Fence (summon + simple vendor)
4. [ ] Gold fencing tracking
5. [ ] Faction join detection

## Phase 2 - Offerings System
1. [ ] Nighttime theft tracking (Story Manager)
2. [ ] Pickpocket stat tracking
3. [ ] TG job completion tracking
4. [ ] Jarl residence theft detection
5. [ ] Stages 20-40 complete

## Phase 3 - TG Integration
1. [ ] TG quest completion detection
2. [ ] Courier letter delivery
3. [ ] Stages 40-70 complete
4. [ ] Powers implementation
5. [ ] Insignia transformation

## Phase 4 - Lore & Polish
1. [ ] AotC_ShadowsOfThePast quest
2. [ ] Brynjolf journal + pages
3. [ ] Sapphire proximity system
4. [ ] Wintersun integration
5. [ ] Stage 200 fail state

## Phase 5 - MQ Integration
1. [ ] MQ state detection system
2. [ ] AotC_WaningMoon quest
3. [ ] Dream delivery system
4. [ ] Path A/B/C content variations
5. [ ] Evergloam's Shroud power
6. [ ] Full Moon Insignia transformation
7. [ ] Nocturnal's Chosen ability

## Phase 6 - Alternative Entry
1. [ ] AotC_ShadowsCalling quest
2. [ ] TG09 completion detection
3. [ ] Compressed blessing sequence
4. [ ] Integration into WaningMoon

---

# Testing Checklist

## Per-Stage Testing (MainQuest)

- [ ] Stage 10: Spawns correctly, note in inventory, power granted
- [ ] Stage 15: Objectives display, tracking works
- [ ] Stage 20: Guild join detected, offerings track, stage advances
- [ ] Stage 30: Power granted, letter delivered, new offerings appear
- [ ] Stage 40: TG quest detected, stage advances
- [ ] Stage 50: TG quest detected, power granted, reminder timer works
- [ ] Stage 60: Guild Master detected, shrine activatable
- [ ] Stage 70: All rewards granted, insignia transforms, WaningMoon starts
- [ ] Stage 200: Warning appears, curse applied, quest fails properly

## WaningMoon Testing

- [ ] MQ state detection works at various MQ progress points
- [ ] Path A: Dream triggers correctly for confirmed Dragonborn
- [ ] Path B-1: Dream variation for Helgen-witnessed player
- [ ] Path B-2: Dream variation for pre-Helgen player
- [ ] Path C: Immediate acknowledgment for post-MQ player
- [ ] Stage 20: Dragonborn confirmation triggers for Path B players
- [ ] Stage 30: Mid-MQ acknowledgment triggers
- [ ] Stage 40: Alduin defeat rewards grant correctly
- [ ] Full Moon Insignia stats are correct
- [ ] Nocturnal's Chosen ability applies correctly

## ShadowsCalling Testing

- [ ] Triggers correctly after TG09 (not before)
- [ ] Doesn't trigger if AotC already running
- [ ] Dream delivers and Insignia appears
- [ ] Sepulcher dialogue plays
- [ ] All powers granted at once
- [ ] Correctly merges into WaningMoon

## Integration Testing

- [ ] Shadow Fence summonable and functional
- [ ] Fencing gold tracks correctly
- [ ] Nighttime theft detects time correctly
- [ ] TG quest hooks don't break vanilla progression
- [ ] MQ quest hooks don't break vanilla progression
- [ ] Lore pages spawn in correct locations
- [ ] Wintersun deity change detected (if installed)
- [ ] No conflicts with AYOP-TG
- [ ] No conflicts with Alternate Perspective

---

# Summary: Complete Quest Flow

## Primary Path (AP Start → Full Completion)

```
[Alternate Perspective Start Selection]
    ↓
AotC_StartQuest (Stage 10)
    ↓ Spawn in Beggar's Row, receive Insignia
AotC_MainQuest (Stage 10) - Awakening
    ↓ Read Nocturnal's Reminder
AotC_MainQuest (Stage 15) - The Path Forward
    ↓ Join Guild + Fence 500g
AotC_MainQuest (Stage 20) - Accepted by Shadows
    ↓ Complete First Offerings
AotC_MainQuest (Stage 30) - Shadow's Whisper
    ↓ Complete Second Offerings + TG06
AotC_MainQuest (Stage 40) - The Betrayer Revealed
    ↓ Complete TG08A (kill Mercer)
AotC_MainQuest (Stage 50) - The Key Reclaimed
    ↓ Complete TG09 (return Key)
AotC_MainQuest (Stage 60) - Darkness Returns
    ↓ Become Guild Master + Visit Shrine
AotC_MainQuest (Stage 70) - Redemption ✓
    ↓ [WaningMoon starts automatically]
AotC_WaningMoon (Stage 10) - Nocturnal's Warning
    ↓ [varies by MQ state]
AotC_WaningMoon (Stage 40) - The World-Eater Falls
    ↓ Complete MQ17 (defeat Alduin)
AotC_WaningMoon (Stage 100) - Complete ✓
```

## Alternative Path (Non-AP → ShadowsCalling)

```
[Player completes vanilla TG through TG09]
    ↓ Sleep triggers dream
AotC_ShadowsCalling (Stage 10) - Dream Received
    ↓ Visit Twilight Sepulcher
AotC_ShadowsCalling (Stage 20) - Sepulcher Visited
    ↓ Receive Nocturnal's blessing
AotC_ShadowsCalling (Stage 30) - Blessing Received
    ↓ [Merges into WaningMoon]
AotC_WaningMoon (Stage 10+) - [continues as above]
```

## Optional Content

```
AotC_ShadowsOfThePast (Stages 10-50)
    → Discover Brynjolf's journal
    → Find 4 missing pages
    → Learn the truth about Sapphire and the player's past
```

---

*Last Updated: January 2026*
*Document Version: 3.0 - Complete with MQ Integration*
