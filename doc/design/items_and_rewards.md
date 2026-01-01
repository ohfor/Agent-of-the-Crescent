# Shadow's Redemption - Items & Rewards Specification

## Starting Items

### SR_TarnishedInsignia
- **Type:** Misc Item (MiscItem)
- **Name:** "Tarnished Nightingale Insignia"
- **Weight:** 0.1
- **Value:** 0 (cannot be sold)
- **Model:** Use vanilla Nightingale insignia mesh if available, or a generic sigil/medallion
- **Description:** 
  > *A sigil of the Nightingales, blackened and cold to the touch. Whatever power it once held has been stripped away. Yet you cannot bring yourself to discard it - some fragment of memory clings to this tarnished metal.*

### SR_NocturnalReminder
- **Type:** Book (Note)
- **Name:** "Nocturnal's Reminder"
- **Weight:** 0
- **Value:** 0
- **Content:**
  > *The Key. The Betrayer. Redemption.*
  >
  > *You know what must be done. Do not fail me again.*
  >
  > *Find the Thieves Guild in Riften's depths. They are the path to what was lost. The one called Brynjolf seeks capable hands in the marketplace - make yourself useful to him.*
  >
  > *Prove your worth through shadow's work. Steal. Deceive. Rise. And when the moment comes to face the betrayer, do not hesitate as you once did.*
  >
  > *I will be watching.*

### Starting Equipment
- **Ragged Robes** (vanilla `ClothesBeggarRobes`)
- **Footwraps** (vanilla `ClothesBeggarBoots`) 
- **Apple** (vanilla, half-eaten appearance via rename: "Bruised Apple")
- No gold
- No weapons

---

## Courier Letters

### SR_NocturnalLetter01
- **Delivery Trigger:** Stage 20 complete (joined Guild, initial offerings done)
- **Name:** "Unmarked Letter"
- **Content:**
  > *You have found your way to the Guild. Good.*
  >
  > *They are diminished, corrupt, led by the very one who stole from me. But they have purpose yet - and so do you.*
  >
  > *The one called Mercer Frey carries my Key still. He believes himself clever. He believes himself safe. He is neither.*
  >
  > *Rise among them. Prove your worth. Continue your offerings. And when the moment comes...*
  >
  > *Do not hesitate.*

### SR_NocturnalLetter02
- **Delivery Trigger:** Stage 40 complete (Mercer betrayal revealed)
- **Name:** "Unmarked Letter"
- **Content:**
  > *At last, the Guild sees what you have always known. The betrayer is exposed.*
  >
  > *Karliah seeks justice for her fallen lover. You seek redemption for your failure. Your paths align, for now.*
  >
  > *Hunt him. End him. Reclaim what he stole.*
  >
  > *The shadows grow impatient.*

### SR_NocturnalLetter03
- **Delivery Trigger:** Stage 50 complete (Mercer dead, Key recovered)
- **Name:** "Unmarked Letter"  
- **Content:**
  > *The betrayer is dead. The Key returns to worthy hands.*
  >
  > *You have done well. But the work is not complete.*
  >
  > *Return my Key to the Sepulcher. Walk the Pilgrim's Path. And then... rise to lead what you once abandoned.*
  >
  > *Only then will your debt be paid.*

### SR_NocturnalLetter04 (Optional)
- **Delivery Trigger:** Player holds Skeleton Key for extended time without returning
- **Name:** "Unmarked Letter"
- **Content:**
  > *The Key is not yours to keep.*
  >
  > *I understand its allure. I designed it thus. But your redemption requires its return.*
  >
  > *Do not test my patience. The Sepulcher awaits.*

---

## Powers & Abilities

### SR_ShadowWhisper
- **Type:** Lesser Power
- **Name:** "Shadow's Whisper"
- **Granted:** Stage 30
- **Cooldown:** Once per day
- **Duration:** 30 seconds
- **Effect:** Detect Life effect, extended range (comparable to master-level spell)
- **Description:**
  > *Your eyes remember the shadows. Nocturnal returns a fragment of your sight, allowing you to sense all living beings nearby.*
- **Implementation:** Custom spell using Detect Life effect, magnitude ~200 (large range)

### SR_ShadowStep  
- **Type:** Lesser Power
- **Name:** "Shadow's Step"
- **Granted:** Stage 40
- **Cooldown:** Once per day
- **Duration:** 15 seconds
- **Effect:** Invisibility (breaks on attack/interaction as normal)
- **Description:**
  > *The shadows welcome you once more. For a brief time, you may walk unseen among your enemies.*
- **Implementation:** Custom spell using Invisibility effect

### SR_ShadowEmbrace
- **Type:** Lesser Power
- **Name:** "Shadow's Embrace"
- **Granted:** Stage 60
- **Cooldown:** Once per day
- **Effect:** Short-range teleport (blink) to target location within line of sight
- **Description:**
  > *The darkness bends to your will. You may step through shadow to emerge elsewhere.*
- **Implementation:** This is more complex - likely needs scripted teleport. Could simplify to "extreme speed burst" for Stage 1 if teleport is too complex.
- **Alternative (simpler):** 5 second effect granting 200% movement speed + muffle + reduce fall damage

### SR_ShadowForm
- **Type:** Greater Power
- **Name:** "Shadow Form"
- **Granted:** Stage 70 (quest complete)
- **Cooldown:** Once per day
- **Duration:** 20 seconds
- **Effect:** 
  - Ethereal (immune to all damage, cannot attack)
  - 50% increased movement speed
  - Muffle
  - Can pass through enemies
- **Description:**
  > *You become one with shadow itself. For a time, you exist between worlds - untouchable, unstoppable, a living darkness.*
- **Implementation:** Become Ethereal effect + speed buff + muffle

### SR_NightingaleRedeemed
- **Type:** Ability (constant effect)
- **Name:** "Nocturnal's Redeemed"
- **Granted:** Stage 70 (quest complete)
- **Effect:**
  - Fortify Pickpocket 15%
  - Fortify Lockpicking 15%
  - Prices 10% better with fences
  - Sneak 10% more effective
- **Description:**
  > *Nocturnal has restored your place among her chosen. The shadows themselves aid your endeavors.*
- **Implementation:** Constant effect ability with multiple enchantment effects

### SR_NocturnalRejection
- **Type:** Ability (constant effect, CURSE)
- **Name:** "Nocturnal's Rejection"
- **Granted:** Stage 200 (abandoned Nocturnal)
- **Effect:**
  - Sneak 10% less effective
  - Prices 5% worse everywhere
  - Lockpicking slightly harder
- **Description:**
  > *You betrayed Nocturnal's trust. The shadows no longer welcome you - they expose you instead.*
- **Implementation:** Constant effect debuff ability

---

## Final Reward Item

### SR_RestoredInsignia
- **Type:** Amulet (Armor, Amulet slot)
- **Name:** "Restored Nightingale Insignia"
- **Weight:** 0.5
- **Value:** 2500
- **Armor:** 0
- **Model:** Same as Tarnished version but with glow effect if possible, or use Nightingale amulet mesh
- **Enchantment:**
  - Fortify Sneak 20%
  - Muffle (50% noise reduction)
  - Fortify Stamina 30
- **Description:**
  > *The insignia that once marked your failure now gleams with renewed purpose. Nocturnal's favor flows through it, a tangible reminder of redemption earned.*
- **Implementation:** 
  - Created by script when quest completes
  - Removes SR_TarnishedInsignia from inventory
  - Adds SR_RestoredInsignia to inventory
  - If player dropped/sold the tarnished one, just add the restored one anyway

---

## Item Form IDs (Placeholder)
These will be assigned when we create the ESP. Using SR prefix for all.

| Item | Suggested FormID Pattern |
|------|-------------------------|
| SR_TarnishedInsignia | SR:000800 |
| SR_RestoredInsignia | SR:000801 |
| SR_NocturnalReminder | SR:000810 |
| SR_NocturnalLetter01 | SR:000811 |
| SR_NocturnalLetter02 | SR:000812 |
| SR_NocturnalLetter03 | SR:000813 |
| SR_NocturnalLetter04 | SR:000814 |
| SR_ShadowWhisper | SR:000820 |
| SR_ShadowStep | SR:000821 |
| SR_ShadowEmbrace | SR:000822 |
| SR_ShadowForm | SR:000823 |
| SR_NightingaleRedeemed | SR:000824 |
| SR_NocturnalRejection | SR:000825 |

---

## Leveled Considerations

All powers are granted at fixed strength regardless of player level. This is intentional:
- You're recovering FORMER power, not gaining new power
- The abilities should feel meaningful whether you're level 5 or level 50
- Keeps implementation simpler

The final passive bonuses (SR_NightingaleRedeemed) are percentile, so they scale naturally with player progression.
