# The Tarnished Insignia - Design Document

## Overview

The Tarnished Insignia is the central artifact of the Agent of the Crescent questline. It represents Nocturnal's claim on the player, their means of proving devotion, and ultimately the symbol of their redemption or damnation.

Everything in this questline flows through this object. It is not merely a quest item - it is the player's contract, their lifeline, and their prison.

---

## Physical Properties

### Appearance Progression

| Stage | Name | Visual Description |
|-------|------|-------------------|
| Start | Tarnished Insignia | Dark, corroded metal. A crescent moon shape barely visible beneath tarnish and grime. Cold to the touch. |
| Mid | Insignia of Shadow | Cleaner, the crescent now visible. Dark metal with hints of purple luminescence in darkness. |
| End | Restored Nightingale Insignia | Gleaming black metal, crescent moon prominent. Faint wisps of shadow curl from its surface. |

### Mesh/Texture Options (Implementation)

**Stage 1 (MVP):** 
- Use existing amulet or misc item mesh
- Apply dark/purple tinted texture
- Candidates: `miscamulet01` mesh with custom texture, or the Nightingale Blade pommel asset if extractable

**Stage 2+:**
- Custom mesh depicting crescent moon
- Animated subtle glow/shadow effect
- Visual transformation between stages

### Item Properties

```
Type: MiscObject (not Armor - not equippable yet)
Weight: 0
Value: 0
Quest Item: YES (cannot be dropped, sold, or removed)
```

The Quest Item flag is crucial - this cannot be casually discarded. Destroying it must be a deliberate, scripted act with consequences.

---

## The Contract: What the Insignia Represents

When the player carries the Insignia, they are bound by Nocturnal's terms:

1. **Service** - Find the betrayer, return the Key
2. **Offering** - Prove worth through shadow's work (fencing, stealing, etc.)
3. **Loyalty** - Nocturnal is your patron; divided loyalty has consequences

The Insignia is proof of this contract. It allows the player to:
- Summon Nocturnal's agent (the Shadow Fence)
- Have their offerings counted toward redemption
- Eventually access restored powers

Without it, they are nothing - just another beggar in Riften.

---

## The Shadow Fence

### Concept

A manifestation of Nocturnal's presence - not quite a person, not quite a spirit. A shadow given purpose. This entity serves as:

1. **The player's only legitimate fence** for redemption purposes
2. **A narrative voice** delivering Nocturnal's will
3. **A progression indicator** through its behavior and offerings

### Summoning Mechanic

**Lesser Power: "Whisper to Shadow"**
- Added to player when Insignia enters inventory
- Removed if Insignia is removed/destroyed
- Cooldown: 24 hours (game time)
- Effect: Summons the Shadow Fence for ~3 minutes

**Summoning Flavor:**
- Shadows coalesce nearby
- A hooded figure steps from darkness
- Ambient sound: whispers, soft darkness
- The figure speaks first: *"You called. I answer. What do you offer?"*

### The Shadow Fence NPC

**Name:** Simply "Shadow" or "The Shadow" or no name at all (mysterious)

**Appearance:**
- Hooded dark robes (similar to Nightingale aesthetic)
- Face obscured or shadowed unnaturally
- Ghost shader or ethereal effect
- Does not walk - glides or manifests/demanifests

**Personality:** Sardonic professionalism
- Has seen countless mortals try and fail
- Mildly amused by your efforts
- Professional in transactions
- Occasionally drops hints or cryptic observations
- Loyal to Nocturnal, indifferent to you (initially)

**Example Dialogue:**

*Greeting (Early):*
> "Another soul crawling toward redemption. How... familiar. Show me what you've brought."

*Greeting (Mid):*
> "You persist. She notices. What offerings do you carry?"

*Greeting (Late):*
> "The shadows speak well of you, thief. Let us see what you've earned."

*On Purchase:*
> "These will find their way to where they belong. The Lady counts your offering."

*Dismissal:*
> "The darkness calls me back. Do not waste your next summoning."

*Idle (if summoned with nothing to sell):*
> "You summon me with empty hands? Time is shadow, mortal. Do not squander it."

### Progression Scaling

The Shadow Fence improves as the player proves themselves:

| Milestone | Gold Cap | Buy Rate | Shadow's Demeanor |
|-----------|----------|----------|-------------------|
| Quest Start | 250 | 10% | Dismissive, barely patient |
| 500 gold fenced | 500 | 12% | Slightly less contemptuous |
| First TG job complete | 750 | 15% | Acknowledges you're trying |
| Joined Guild officially | 1000 | 18% | Professional respect |
| Completed city influence | 1500 | 22% | Genuine acknowledgment |
| Killed Mercer | 2500 | 28% | Warmth (for a shadow) |
| Returned the Key | 5000 | 35% | Near-equal, speaks of "when" not "if" you're restored |

**Note on rates:** These are intentionally lower than Guild fences (~33% at Speech 0, up to 50%+ with perks). The Shadow takes a tithe for Nocturnal. This is punishment AND offering combined.

### Why Not Use Guild Fences?

The player CAN use Tonilia and other fences once they unlock them. The game won't stop them. However:

1. **Offerings don't count.** Only gold from the Shadow Fence contributes to "Offering of Wealth"
2. **Nocturnal is not watching.** The connection is through the Insignia, not the Guild
3. **The Guild is tainted.** Under Mercer's leadership, it has no blessing

We implement this through tracking: a script tracks gold received from Shadow Fence specifically, not general fencing.

**Optional Flavor:** When selling to a Guild fence, subtle feedback:
> *A chill runs through you. The shadows here feel... distant. Unwatching.*

This is a notification or subtle visual cue, not a block. Player choice matters.

---

## Offerings System

The player must prove their worth through shadow's work. The Insignia (via quests/scripts) tracks:

### Offering of Wealth
- **Requirement:** Fence X gold worth of stolen goods through Shadow Fence
- **Thresholds:** 500 → 1500 → 5000 → 15000 (example, needs balancing)
- **Purpose:** Proves you can acquire and move valuable goods

### Offering of Cunning  
- **Requirement:** Complete X Thieves Guild jobs (radiant)
- **Thresholds:** 3 → 7 → 15 → 25
- **Purpose:** Proves you can execute varied work

### Offering of Boldness
- **Requirement:** Pick X pockets successfully
- **Thresholds:** 10 → 25 → 50 → 100
- **Purpose:** Proves you have nerve

### Offering of Darkness
- **Requirement:** Steal X items during nighttime (9 PM - 5 AM)
- **Thresholds:** 15 → 40 → 80 → 150
- **Purpose:** Proves you honor Nocturnal's domain - the night itself

**Thematic Rationale:**
> *"The night is my domain. Those who would serve me must learn to work within it."*

This offering teaches the player to think like a true thief - not merely someone who steals, but someone who embraces the night. It's behavioral, immersive, and directly honors Nocturnal's nature as Lady of Night.

**Technical Implementation (Story Manager):**

The game's Story Manager provides a native `Player Add Item` event that fires whenever the player obtains an item. Crucially, this event includes `OwnerRef` - the Actor who owned the item before the player took it.

```
Story Manager Event: Player Add Item
└── Quest Node: AotC_NightTheftTracker
    └── Conditions:
        ├── GetEventData OwnerRef != None
        └── GetEventData OwnerRef != PlayerRef
    └── Quest starts, script fires:
        └── Check game time → if 21:00-05:00 → increment counter
```

**Script Concept:**
```papyrus
Scriptname AotC_NightTheftScript extends Quest

GlobalVariable Property AotC_NightTheftCount Auto
GlobalVariable Property AotC_NightTheftTarget Auto  ; Current threshold

Event OnStoryPlayerAddItem(ObjectReference akOwner, ObjectReference akContainer, Location akLocation, Form akItemBase)
    ; This only fires when item had a non-player owner (stolen!)
    
    float currentHour = Utility.GetCurrentGameTime()
    currentHour = (currentHour - Math.Floor(currentHour)) * 24.0
    
    if currentHour >= 21.0 || currentHour < 5.0
        ; Nighttime theft - count it!
        AotC_NightTheftCount.Mod(1)
        
        ; Subtle feedback (optional)
        if AotC_NightTheftCount.GetValue() as Int % 10 == 0
            Debug.Notification("The night witnesses your devotion...")
        endif
        
        ; Check milestone completion
        CheckNightTheftMilestone()
    endif
    
    ; Stop quest so it can fire again
    Stop()
EndEvent

Function CheckNightTheftMilestone()
    ; Implementation handles threshold checking and reward granting
EndFunction
```

**Why This Approach:**
- **Event-driven** - fires exactly when theft occurs, no polling
- **Native engine support** - Story Manager is stable and reliable
- **Precise timing** - checks time at the exact moment of theft
- **No performance overhead** - quest starts, fires, stops immediately
- **Proven pattern** - used by Gray Cowl of Nocturnal mod successfully

**Story Manager Node Setup:**
- Quest node must have "Shares Event" checked for compatibility
- Node should be placed appropriately in the event tree (not blocking vanilla nodes)
- Quest is `Start Game Enabled: No` (started by SM only)
- Quest stops itself after each event to be re-triggered

**Wintersun Synergy:**
This aligns perfectly with Wintersun's Nocturnal worship, which restricts the "Pray" power to nighttime hours (approximately 9 PM - 5 AM). Players worshipping Nocturnal are already primed to think about time-of-day mechanics.

**Design Note - Future Dark Brotherhood Mod:**
The Black Soul Gem offering concept is explicitly reserved for a potential Dark Brotherhood companion questline. Filling souls aligns with Sithis/Night Mother theming, not Thieves Guild/Nocturnal. Different flavor of darkness entirely - that questline would track soul trapping of NPCs (humanoid souls only) as offerings to the Void.

### Offering of Secrets
- **Requirement:** Progress through Thieves Guild main questline
- **Milestones:** Loud and Clear → Speaking with Silence → Hard Answers → Darkness Returns
- **Purpose:** The actual mission - find the betrayer, return the Key

---

## The Insignia's Powers

As offerings accumulate, the Insignia grants abilities:

### Stage 1: Whisper to Shadow (Start)
- Summon Shadow Fence
- 24-hour cooldown

### Stage 2: Shadow's Whisper (Offering of Cunning I)
- Detect Life effect, limited range
- Themed as "the shadows tell you where the living hide"
- Lesser power, 1/day

### Stage 3: Shadow's Step (Offering of Boldness II)
- Brief invisibility (10 seconds)
- Lesser power, 1/day

### Stage 4: Shadow's Embrace (Kill Mercer)
- Movement speed buff in sneak
- Passive while Insignia carried

### Stage 5: Shadow Form (Return the Key)
- Full Nightingale Agent power selection
- Insignia transforms to Restored state
- Player can choose: keep Insignia (passive bonuses) or "release" it (different ending?)

---

## Destroying the Insignia

The Insignia cannot be casually discarded. It is quest-locked. However, there may be a way to destroy it deliberately:

**Method:** Unknown to player initially. Perhaps:
- Casting it into fire at a specific shrine?
- Offering it to a rival Daedric Prince?
- A specific dialogue choice with Nocturnal?

**Consequences:**
- Quest fails immediately
- All granted powers removed
- Player receives a permanent curse: "Nocturnal's Disfavor"
  - Reduced luck (decreased loot quality? critical hit chance?)
  - Shadows no longer aid (detection radius increased?)
  - Fences refuse service permanently? (harsh)
- This is the BAD END for those who reject the path

**Why include this?**
- Player agency - they can reject Nocturnal's bargain
- Consequences matter - choices have weight
- Roleplaying option - maybe they find a different path
- Clean exit - if someone wants to abandon the questline

---

## Wintersun Integration (Future)

If player has Wintersun installed:

- Nocturnal is auto-set as deity when quest starts
- Shadow Fence offerings contribute to Wintersun devotion
- Changing deity triggers warning, then consequences:
  - First change: Nocturnal expresses displeasure, redemption progress halved
  - Persistent worship of another: Insignia begins to "reject" player, eventual destruction
- Completing the questline maxes Wintersun devotion

This makes the Nocturnal relationship feel persistent and real.

---

## Implementation Phases

### Phase 1 (MVP)
- [x] Basic Insignia item (placeholder mesh)
- [ ] Whisper to Shadow power
- [ ] Shadow Fence NPC (basic vendor functionality)
- [ ] Gold tracking for Offering of Wealth

### Phase 2
- [ ] Shadow Fence dialogue variations
- [ ] Progression-based gold cap and rates
- [ ] Visual/audio feedback on summoning
- [ ] Insignia transformation (visual)

### Phase 3
- [ ] Additional powers unlock
- [ ] Full offerings tracking system
- [ ] Integration with TG questline stages
- [ ] Wintersun integration

### Phase 4
- [ ] Insignia destruction option
- [ ] Consequences and alternate endings
- [ ] Custom mesh/textures
- [ ] Voice acting for Shadow Fence

---

## Open Questions

1. **Should the Shadow Fence be summonable anywhere, or only in "safe" locations?**
   - Anywhere is more useful
   - Restricted locations (cities, indoors) is more immersive
   - Compromise: Anywhere, but with contextual dialogue ("Bold, summoning me here...")

2. **Should the Shadow Fence buy non-stolen items?**
   - Probably not - this is about STOLEN goods as offerings
   - Or: buys anything, but only stolen items count toward offerings

3. **What happens if player completes TG questline before meeting offering thresholds?**
   - Redemption should require both story AND offerings
   - Or: Story completion counts as major offering, catches up progress

4. **Multiple Shadow Fence personas or one consistent entity?**
   - One consistent builds relationship
   - Multiple could represent different aspects of Nocturnal
   - Leaning toward: One, with evolving demeanor

5. **Should the Insignia eventually become equippable (amulet slot)?**
   - Thematic payoff for restoration
   - Competes with other amulets (opportunity cost = meaningful choice)
   - Yes, as final reward, with strong thief-oriented enchantment
