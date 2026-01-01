# Shadow's Redemption - Quest Stages Specification

## Quest ID: `SR_MainQuest`
## Quest Name: "Shadow's Redemption"

---

## Stage Reference

### Stage 0 - Not Started
- **Description:** Quest not yet initiated
- **Log Entry:** None
- **Completion Conditions:** None (initial state)

---

### Stage 10 - Awakening
- **Description:** Player has selected the Nocturnal start and spawned in Beggar's Row
- **Log Entry:** 
  > *I awoke in the filth of Riften's Ratway with nothing but rags and fragmented memories. A note in my possession speaks of a debt to Nocturnal - the Skeleton Key, a betrayer named Mercer Frey, and redemption. I was a Nightingale once. I failed. Now I must make amends or fade into nothing.*
- **Objectives Displayed:**
  - [ ] Read Nocturnal's Reminder
- **Completion Conditions:** Player reads the note item `SR_NocturnalReminder`
- **On Completion:** Advance to Stage 15

---

### Stage 15 - The Path Forward
- **Description:** Player has read the note and understands their mission
- **Log Entry:**
  > *The note speaks of finding the Thieves Guild. They are diminished but still operate somewhere in Riften's underworld. I must prove myself useful to them - they are the path to Mercer Frey and the Skeleton Key. But first, I must survive. I have nothing. I am nothing. Yet.*
- **Objectives Displayed:**
  - [ ] Find the Thieves Guild (0/1)
  - [ ] Stolen goods value: (X/500 gold)
- **Completion Conditions:** 
  - Player joins Thieves Guild (faction rank check) AND
  - Lifetime stolen goods value >= 500
- **On Completion:** Advance to Stage 20
- **Notes:** Stolen goods tracked via vanilla `StatsStolen` game stat or TG fencing stats

---

### Stage 20 - Accepted by Shadows
- **Description:** Player has joined the Thieves Guild
- **Log Entry:**
  > *I've found the Guild and earned a place among them. They are... diminished from what I remember. The glory days are long past. But Mercer Frey leads them still, unaware of what he truly stole or perhaps simply uncaring. I must rise in their ranks while proving my worth to Nocturnal through offerings of shadow.*
- **Objectives Displayed:**
  - [ ] Complete Offerings of Shadow (0/3)
    - [ ] Offering of Wealth - Fence 1000 gold worth of stolen goods
    - [ ] Offering of Cunning - Complete 5 radiant jobs for the Guild
    - [ ] Offering of Boldness - Successfully pickpocket 20 people
  - [ ] Stolen goods value: (X/2500 gold)
- **Completion Conditions:**
  - At least 3 of the 3 offerings complete AND
  - Lifetime stolen goods >= 2500
- **On Completion:** 
  - Grant `SR_ShadowWhisper` power
  - Trigger courier letter delivery (Letter 01)
  - Advance to Stage 30
- **Notes:** Offerings can be tracked via:
  - Wealth: TG fence gold stats
  - Cunning: TG radiant quest completion count
  - Boldness: Vanilla pickpocket success stat

---

### Stage 30 - Shadow's Whisper
- **Description:** Player has proven initial worth, receives first power restoration
- **Log Entry:**
  > *Nocturnal acknowledges my progress. A fragment of my former power has returned - I can sense the living through walls once more. But this is merely the beginning. The Guild speaks of troubles, of jobs going wrong, of Maven Black-Briar's displeasure. Something is rotten at the heart of this organization. I suspect I know who.*
- **Objectives Displayed:**
  - [ ] Complete Offerings of Shadow (0/3)
    - [ ] Offering of Darkness - Possess a filled Black Soul Gem
    - [ ] Offering of Ambition - Steal from a Jarl's residence
    - [ ] Offering of Secrets - Discover evidence of the betrayer (Complete "Speaking With Silence")
  - [ ] Stolen goods value: (X/5000 gold)
- **Completion Conditions:**
  - All 3 offerings complete AND
  - Lifetime stolen goods >= 5000 AND
  - TG Quest "Speaking With Silence" complete
- **On Completion:**
  - Grant `SR_ShadowStep` power
  - Trigger courier letter delivery (Letter 02)
  - Advance to Stage 40
- **Notes:** 
  - Black Soul Gem check: Player inventory contains filled black soul gem
  - Jarl residence: Check for items with specific stolen flags from major hold capitals
  - "Speaking With Silence" is TG quest where Mercer's betrayal is revealed

---

### Stage 40 - The Betrayer Revealed
- **Description:** Mercer's treachery is now known to the Guild
- **Log Entry:**
  > *Mercer Frey. After all these years, his crimes are finally exposed. He murdered Gallus, stole the Skeleton Key, and has been bleeding the Guild dry ever since. Karliah has returned seeking justice. I... remember her, though she does not know me. Or does she sense something? No matter. The hunt begins. This time, I will not fail.*
- **Objectives Displayed:**
  - [ ] Hunt down Mercer Frey (Complete "Blindsighted")
  - [ ] Reclaim the Skeleton Key
- **Completion Conditions:**
  - TG Quest "Blindsighted" complete
- **On Completion:**
  - Trigger courier letter delivery (Letter 03)
  - Advance to Stage 50
- **Notes:** This stage progresses naturally through TG questline

---

### Stage 50 - The Key Reclaimed
- **Description:** Mercer is dead, the Key recovered
- **Log Entry:**
  > *Mercer Frey is dead. The Skeleton Key is in my possession once more. Decades of failure, redeemed in a single blade stroke. But the work is not complete. The Key must be returned to the Twilight Sepulcher, and I... I must face Nocturnal directly. Karliah speaks of restoring the Nightingales. She does not know that one already stands beside her.*
- **Objectives Displayed:**
  - [ ] Return the Skeleton Key to the Twilight Sepulcher (Complete "Darkness Returns")
- **Completion Conditions:**
  - TG Quest "Darkness Returns" complete
- **On Completion:**
  - Grant `SR_ShadowEmbrace` power
  - Advance to Stage 60

---

### Stage 60 - Darkness Returns
- **Description:** The Skeleton Key has been returned
- **Log Entry:**
  > *The Key rests once more in the Sepulcher. I have walked the Pilgrim's Path, faced the sentinels, and emerged. Nocturnal's presence filled that place - she knows what I have done. But redemption is not yet complete. I must rise to lead the Guild I once abandoned. Only then will the circle close.*
- **Objectives Displayed:**
  - [ ] Become the Guild Master of the Thieves Guild
  - [ ] Final Offering: Return to Nocturnal's shrine in the Twilight Sepulcher
- **Completion Conditions:**
  - Player has Guild Master rank in Thieves Guild AND
  - Player activates the shrine/statue in Twilight Sepulcher inner sanctum
- **On Completion:**
  - Trigger final sequence
  - Advance to Stage 70

---

### Stage 70 - Redemption
- **Description:** Player completes the questline
- **Log Entry:**
  > *It is done. I knelt before Nocturnal's shrine as Guild Master, my debts paid in full. The shadows welcomed me back - not as the failure I was, but as something more. My full power has been restored, perhaps even enhanced. The Nightingale Insignia I've carried all this time gleams with new purpose.*
  >
  > *But Nocturnal's final words trouble me. "The World-Eater stirs. Dragons return to Skyrim. If Alduin succeeds, there will be no shadows left - only ash and fire. You have redeemed your past failure. Now prevent a future one."*
  >
  > *It seems my work has only begun.*
- **Objectives Displayed:**
  - [X] Quest Complete
- **Completion Conditions:** None (terminal state)
- **On Completion:**
  - Grant `SR_ShadowForm` greater power
  - Grant `SR_NightingaleRedeemed` passive ability
  - Transform `SR_TarnishedInsignia` into `SR_RestoredInsignia`
  - Set quest complete flag

---

### Stage 200 - Abandoned (Fail State)
- **Description:** Player abandoned Nocturnal for another deity
- **Log Entry:**
  > *I have forsaken Nocturnal and broken my pact. Her voice, once a whisper in the shadows, is silent forever. I feel... exposed. The darkness no longer welcomes me. Whatever I might have become, that path is closed now. I must find my own way forward, bearing the weight of two failures.*
- **Objectives Displayed:**
  - [X] Quest Failed - Nocturnal Abandoned
- **Completion Conditions:** Player changes deity in Wintersun after warning
- **On Completion:**
  - Remove all granted SR powers
  - Grant `SR_NocturnalRejection` permanent debuff
  - Set quest failed flag
  - Set global preventing future Nocturnal worship

---

## Tracking Variables

### Globals
| Variable | Type | Purpose |
|----------|------|---------|
| `SR_StolenGoldTotal` | Int | Tracks stolen goods value (may use vanilla stat instead) |
| `SR_OfferingsComplete` | Int | Bitmask of completed offerings |
| `SR_NocturnalAbandoned` | Bool | True if player broke pact, prevents re-engagement |
| `SR_QuestComplete` | Bool | True if quest finished successfully |

### Offerings Bitmask
| Bit | Offering |
|-----|----------|
| 0x01 | Wealth (fence 1000g) |
| 0x02 | Cunning (5 jobs) |
| 0x04 | Boldness (20 pickpockets) |
| 0x08 | Darkness (black soul gem) |
| 0x10 | Ambition (steal from Jarl) |
| 0x20 | Secrets (Speaking With Silence) |

---

## Courier Letters

### Letter 01 - After Stage 20
Delivered after joining Guild and completing initial offerings.

### Letter 02 - After Stage 40  
Delivered when Mercer's betrayal is revealed.

### Letter 03 - After Stage 50
Delivered when Mercer is dead and Key recovered.

### Letter 04 - If player delays returning Key
Optional reminder if player holds Key too long without returning it.

---

## Integration Points

### Thieves Guild Quests Referenced
- Joining the Guild (various entry quests)
- "Speaking With Silence" - Mercer betrayal reveal
- "Blindsighted" - Mercer confrontation
- "Darkness Returns" - Key return
- Guild Master promotion (requires city influence quests)

### Wintersun Integration
- Monitor player deity
- Trigger Stage 200 if deity changes from Nocturnal

### Alternate Perspective Integration  
- New start option in character creation
- Spawn point: Beggar's Row, Riften
- Starting items granted on spawn
