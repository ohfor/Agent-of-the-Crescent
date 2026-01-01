# Shadow Fence - Complete Dialogue Specification

## Overview

The Shadow Fence serves three functions:
1. **Mechanical:** Fencing stolen goods for gold
2. **Progression:** Reflecting the player's standing with Nocturnal through demeanor
3. **Narrative:** Delivering story content, warnings, and lore

Dialogue is structured in layers:
- **Greeting lines:** Spoken on summon, set tone and may flag available story content
- **Core dialogue:** Always available barter/information options
- **Story dialogue:** Unlocks based on quest stage, delivers key narrative beats
- **Ambient lines:** Random variations for texture, prevent repetition

Player engagement is optional. Those who want lore can dig. Those who want to fence and leave can do so in 2-3 clicks.

---

## Character Voice

The Shadow Fence is:
- **Ancient** - They've served Nocturnal for eras, seen countless mortals rise and fall
- **Sardonic** - Dry humor, particularly when unimpressed
- **Professional** - Business is business, even in shadow
- **Increasingly respectful** - As the player proves themselves

They are NOT:
- Servile or fawning (even at max tier)
- Cryptic for the sake of cryptic
- Warm (until very late game, and even then, restrained)

---

## Dialogue Structure Per Tier

Each tier includes:
- 3-5 greeting variations (randomly selected)
- Core menu options
- Tier-specific optional dialogue
- Story-gated dialogue (when applicable)

---

# TIER 0 - Dismissive (Quest Start)
**Trigger:** Player has Insignia, first summons

## Greetings

1. *"So. You're the one she dragged back from nothing. I expected... more."*

2. *"Another fallen agent. How novel. Let's see if you last longer than the others."*

3. *"The shadows remember you. I don't. Prove you're worth remembering."*

4. *"You smell like failure and Ratway filth. Charming. What do you want?"*

5. *"She gave you another chance. Don't waste my time proving her wrong."*

## Core Menu

**[Trade]** → Opens barter menu
- On exit: *"Try not to get caught. It reflects poorly on all of us."*

**[Who are you?]**
> *"A shadow that speaks. A servant of the Lady. A fence for those she favors - or tolerates, in your case."*
> 
> *"I buy what you steal. I pay what it's worth to her. The arrangement is simple."*

**[What happened to me?]**
> *"You failed. Spectacularly, from what I gather. The Lady doesn't strip agents of everything for minor infractions."*
>
> *"What exactly you did? Not my concern. That you have a chance to redeem yourself? That's unusual. Don't squander it."*

**[Tell me about Nocturnal.]**
> *"She is shadow. She is secret. She is the space between what is known and what is hidden."*
>
> *"And she is not a subject for idle conversation with fallen agents who haven't earned the right to speak her name."*
>
> *"Prove yourself. Then perhaps we'll talk theology."*

**[Goodbye]**
> *"Don't summon me unless you have goods to move. I'm not here for company."*

---

# TIER 1 - Less Contemptuous (500g fenced)
**Trigger:** `AotC_FencedGold >= 500`

## Greetings

1. *"You again. At least you're bringing merchandise now."*

2. *"Still alive? Still stealing? Progress, I suppose."*

3. *"The shadows whisper you've been busy. Show me."*

4. *"Back so soon? Either you're productive or desperate. Let's find out."*

5. *"You're starting to smell less like failure. Marginally."*

## New Dialogue Options

**[Any news from Nocturnal?]**
> *"News? I'm a fence, not a courier."*
>
> *"...But since you ask. The Lady watches. That's more than most get."*
>
> *"Keep stealing. Keep proving yourself. Perhaps one day she'll have words for you directly."*

**[What can you tell me about the Thieves Guild?]**
> *"A shadow of what it was. Mercer Frey's leadership has been... questionable."*
>
> *"The Lady's influence there has waned. Something is wrong. Something beyond bad luck."*
>
> *"If you want to serve her, that Guild is where you need to be. Fix what's broken."*

---

# TIER 2 - Acknowledging (First TG job complete)
**Trigger:** `AotC_TGJobsComplete >= 1`

## Greetings

1. *"The Guild's put you to work. Good. Real thieves, not just scavengers."*

2. *"Word travels through shadow. You're making a name for yourself."*

3. *"Brynjolf's taken notice of you. So has the Lady."*

4. *"You're starting to look like someone worth investing in."*

5. *"The Ratway suits you less each day. That's meant as a compliment."*

## New Dialogue Options

**[Tell me about Mercer Frey.]**
> *"The Guild Master. Holds the position by experience and intimidation."*
>
> *"There's something... off about him. The shadows don't move right around that man."*
>
> *"I have no proof of anything. Just a feeling that's persisted for twenty-five years."*
>
> *"Watch him. Closely."*

**[Is there something wrong with the Guild?]**
> *"Wrong? The Guild has been in decline for decades. Jobs go sour. Luck runs dry."*
>
> *"Some say they've lost Nocturnal's favor. I say that's too simple."*
>
> *"Favor isn't lost. It's stolen. Someone - or something - has been bleeding the Lady's blessing from that Guild."*
>
> *"Find out who. Find out why."*

---

# TIER 3 - Professional (Joined Guild officially)
**Trigger:** Player in Thieves Guild faction, rank >= 0

## Greetings

1. *"A proper Guild member now. The shadows acknowledge you."*

2. *"Brynjolf vouched for you. Don't make him regret it."*

3. *"Welcome to the family, such as it is. Let's do business."*

4. *"You've come far from that wretch in Beggar's Row. Farther to go still."*

5. *"The Lady sees a thief where once she saw a failure. Keep that trajectory."*

## New Dialogue Options

**[Any word from the Lady?]**
> *"She's... attentive. More than usual."*
>
> *"Something's stirring. In the Guild, in the world. I feel it in the shadows."*
>
> *"She hasn't spoken directly. But her attention is fixed on Riften. On you. On Mercer Frey."*
>
> *"Be ready for anything."*

**[Tell me about the Nightingales.]**
> *"Ah. You've heard whispers."*
>
> *"The Trinity. Three mortals bound to Nocturnal's service directly. More than agents - avatars of her will."*
>
> *"There should be three. There aren't. The Trinity is broken. Has been for twenty-five years."*
>
> *"Why? That's the question, isn't it."*

**[There's a woman in the Guild - Sapphire...]** *(Only if player has encountered Sapphire)*
> *"...What about her?"*
>
> *A pause. The Fence seems... careful.*
>
> *"She's a Guild member. Competent. Cold. Keeps to herself."*
>
> *"Why do you ask?"*

*[Follow-up: Something feels strange when I'm near her.]*
> *"Does it now."*
>
> *Another pause. Longer.*
>
> *"Some things are not mine to explain. But I'll say this: trust that feeling. The shadows don't lie. They remember things even when we don't."*
>
> *"Leave it at that. For now."*

---

# TIER 4 - Respectful (City influence established)
**Trigger:** At least one TGCity quest complete

## Greetings

1. *"The Guild's influence spreads. Your work, I understand."*

2. *"Cities are starting to remember who runs the shadows. Well done."*

3. *"You're building something. The Lady approves."*

4. *"Maven Black-Briar speaks well of the Guild again. That's your doing."*

5. *"From nothing to this. I admit, I underestimated you."*

## New Dialogue Options

**[What's really going on with this Guild?]**
> *"You want the truth? Fine. You've earned a piece of it."*
>
> *"Twenty-five years ago, a Nightingale went silent. Around the same time, the Guild's luck turned sour. Around the same time, Mercer Frey became indispensable."*
>
> *"Coincidence? In the Lady's domain, there are no coincidences."*
>
> *"Something was taken from her. Something precious. And someone has been hiding it ever since."*

**[You mentioned a Nightingale went silent...]**
> *"Gallus Desidenius. The previous Guild Master. Brilliant thief. Loyal servant of Nocturnal."*
>
> *"Dead, supposedly. Killed by a rival. But the shadows never confirmed it. No funeral rites reached the Evergloam."*
>
> *"His soul is... somewhere. Unresolved. That's unusual. And troubling."*

---

# TIER 5 - Warm (Mercer killed)
**Trigger:** TG08A (Blindsighted) complete

## Greetings

1. *"The betrayer is dead. I felt it the moment his shadow ceased."*

2. *"Mercer Frey. Twenty-five years of lies, ended by your blade."*

3. *"You hold the Skeleton Key. The Lady's own instrument, returned at last."*

4. *"I knew you were different. From that first summon in the Ratway. I knew."*

5. *"The shadows are singing. They haven't sung in twenty-five years."*

## Changed Demeanor

The Fence's entire bearing shifts. Less guarded. Almost collegial.

## New Dialogue Options

**[Tell me about the Skeleton Key.]**
> *"The Key unlocks potential. Any potential. Physical locks, mental blocks, magical barriers - all yield to it."*
>
> *"Mercer used it to pick the Guild clean. Used it to unlock secrets he had no right to know. Used it to hide from Nocturnal's sight."*
>
> *"In your hands... it could do so much. Unlock anything. Become anything."*
>
> *"But that's not why you carry it. Is it."*

**[I need to return it to the Sepulcher.]**
> *"Yes. You do."*
>
> *"Others would keep it. Use it. Justify the theft with good intentions."*
>
> *"But you understand. The Key isn't yours. It was never Mercer's. It belongs to shadow, and to shadow it must return."*
>
> *"The Lady chose well, giving you this second chance."*

**[What was Mercer's connection to me?]** *(Story delivery)*
> *"Ah. You've felt it, then. The recognition. The rage you couldn't explain."*
>
> *"Twenty-five years ago, when Mercer stole the Key and killed Gallus... there was a witness. A guardian. Someone who could have stopped him."*
>
> *"They hesitated. Just for a moment. And Mercer destroyed them for it."*
>
> *"Not killed. Destroyed. Stripped of memory, of power, of everything that made them who they were."*
>
> *"The Lady salvaged what she could. Gave the broken pieces a chance to become whole again."*
>
> *"You are those pieces."*

---

# TIER 6 - Near-Equal (Key returned)
**Trigger:** TG09 (Darkness Returns) complete

## Greetings

1. *"The Key rests in the Sepulcher once more. The Evergloam sings your name."*

2. *"You walked the Pilgrim's Path. Faced the spectral guardians. Returned what was stolen."*

3. *"I have served Nocturnal for eras. Rarely have I seen such... completion."*

4. *"Agent of the Crescent. That's what she calls you now. Waxing toward fullness."*

5. *"The shadows lean toward you now, the way they lean toward her chosen. It's quite something."*

## Changed Demeanor

Genuine respect. The Fence now speaks as colleague to colleague, not servant to penitent.

## New Dialogue Options

**[What happens now?]**
> *"Now? You finish what you started."*
>
> *"The Guild still needs leadership. Mercer's rot runs deep. Someone needs to cut it out, root and stem."*
>
> *"Become Guild Master. Restore what was broken. Complete the circle."*
>
> *"Then... then the Lady will speak to you directly. And your redemption will be absolute."*

**[Tell me about the Evergloam.]**
> *"Home. For those of us bound to shadow."*
>
> *"It's not a place, exactly. More a... state. Eternal twilight. The moment between day and night, stretched into infinity."*
>
> *"Those who serve Nocturnal faithfully go there when they die. Continue serving, in shadow, forever."*
>
> *"It sounds like a curse to some. To us? It sounds like peace."*

**[What is Sapphire to Nocturnal?]** *(If asked about Sapphire earlier)*
> *"You've earned this answer."*
>
> *"Sapphire is precious to the Lady. More than precious. The shadows themselves watch over her."*
>
> *"Her origins are... complicated. Not entirely mortal, if you understand my meaning."*
>
> *"Brynjolf has protected her for years, on Nocturnal's instruction. You were assigned the same task, once. Before Mercer destroyed you."*
>
> *"She doesn't know what she is. Perhaps she never will. But the Lady loves her, in whatever way a Daedric Prince can love."*
>
> *"Guard her. Even now. Even unknowing."*

---

# TIER 7 - Redeemed (Guild Master, Stage 70 complete)
**Trigger:** AotC_MainQuest Stage 70 complete

## Greetings

1. *"Guild Master. Agent of the Crescent. You've risen higher than I dreamed possible."*

2. *"The Insignia gleams. The Lady smiles. All is as it should be."*

3. *"I watched you crawl from the Ratway with nothing. Look at you now."*

4. *"The shadows no longer lean toward you. They embrace you."*

5. *"It has been... an honor, watching your redemption unfold."*

## Changed Demeanor

The Fence is now genuinely warm. They've witnessed something rare - true redemption - and they're moved by it.

## Story Delivery: The Waning Moon

**[The Lady wanted to speak with me?]** *(Triggers WaningMoon Stage 10 content)*

> *"She does. And through me, she will."*
>
> *The Fence's eyes darken, their voice taking on harmonic undertones - Nocturnal speaking through them.*

**If Path A (Dragonborn confirmed):**
> *"My Agent. My Crescent, waxing toward fullness. You have redeemed yourself beyond expectation."*
>
> *"But redemption is not the end. A new threat rises."*
>
> *"The World-Eater returns. Not to end this kalpa, but to rule it. Eternal dragonfire. A world without shadow."*
>
> *"You are Dragonborn. You carry the only weapon that can end him. I cannot act against Alduin directly - but I can aid you."*
>
> *"Take this blessing. When you hunt dragons, the shadows will hide you from their sight."*
>
> *The Fence's eyes clear. They stagger slightly.*
>
> *"That was... intense. Even for her."*

**If Path B-1 (Helgen witnessed, not confirmed Dragonborn):**
> *"My Agent. A new threat rises that concerns us both."*
>
> *"You witnessed Helgen's destruction. The dragon that caused it was Alduin - the World-Eater."*
>
> *"There is a prophecy. A Dragonborn who can consume dragon souls. If you carry this gift, the Greybeards will know."*
>
> *"Seek them out. Discover what you are. The shadows need the Dragonborn to succeed."*

**If Path B-2 (Pre-Helgen):**
> *"My Agent. The world shifts in ways you may not yet perceive."*
>
> *"Dragons return to Skyrim. Their lord seeks dominion, not destruction. If he succeeds, there will be no darkness left."*
>
> *"Watch the skies. When the dragons come, you may find yourself more connected to them than you expect."*
>
> *"Or perhaps another will rise. Either way, the shadows have stakes in this conflict."*

**If Path C (Alduin already defeated):**
> *The Fence's eyes widen before Nocturnal's presence even fully manifests.*
>
> *"You... you have already ended the World-Eater."*
>
> *A pause. When Nocturnal speaks through them, there's surprise in the voice.*
>
> *"The fire that threatened shadow is quenched. You did this without knowing the stakes. Without knowing what Alduin's victory would have meant."*
>
> *"My Agent. You sought redemption for past failure. But you had already succeeded in a task I would have given you."*
>
> *"This changes much. You have my gratitude. A rare gift."*

---

# POST-WANING MOON CONTENT

## After Stage 40 (Alduin Defeated)

New greeting variations:

1. *"Dragon-Slayer. Shadow-Keeper. The Evergloam remembers what you've done."*

2. *"The fire is quenched. The shadows endure. Because of you."*

3. *"Full Moon Agent. That's your title now. You've waxed complete."*

4. *"I've served Nocturnal for eras. Never seen one rise as you have."*

5. *"The Lady speaks of you to the other shadows. You're becoming legend."*

## New Dialogue Options

**[What did Nocturnal promise me about death?]**
> *"The Evergloam awaits you. When your mortal life ends - truly ends - your soul goes to her realm."*
>
> *"Not as punishment. As reward. You'll serve in shadow for eternity. Continue the work you've done in life."*
>
> *"Some would call it a curse. But you understand. You've touched the Evergloam. You know what peace waits there."*
>
> *"Live fully. Steal grandly. Die eventually. And come home."*

**[Is there more to do?]**
> *"The world never stops needing thieves. The Guild never stops needing leadership."*
>
> *"And Sapphire... she still doesn't know what she is. Perhaps one day, if the Lady wills it, you'll be the one to tell her."*
>
> *"But those are matters for another time. For now? Enjoy what you've earned."*
>
> *"You've done something extraordinary. Let yourself feel it."*

---

# SPECIAL DIALOGUE: SHADOWS OF THE PAST INTEGRATION

## If AotC_ShadowsOfThePast Stage >= 10 (Journal found)

**[I found Brynjolf's journal.]**
> *"Did you now. Interesting reading, I imagine."*
>
> *"Brynjolf has been Nocturnal's instrument longer than he knows. Dreams he couldn't quite remember. Compulsions he couldn't explain."*
>
> *"He protects Sapphire because the Lady asked him to. Twenty years of quiet guardianship."*
>
> *"If you found the journal, you might find the missing pages. They tell a story he tried to bury."*

## If AotC_ShadowsOfThePast Stage >= 50 (All pages found)

**[I know the truth now. About Sapphire. About me.]**
> *"Then you understand what you were. What you failed. What you've redeemed."*
>
> *"Two guardians she had. One to protect her person - that was you. One to protect her future - that was Brynjolf."*
>
> *"When Mercer destroyed you, Brynjolf had to carry both burdens. He's done well. But you're back now."*
>
> *"The Lady's pieces are falling into place. After twenty-five years, the pattern completes."*

---

# SPECIAL DIALOGUE: WINTERSUN WARNING

## If Player Shows Signs of Deity Change

**[I'm considering following a different god.]**
> *The Fence goes very still.*
>
> *"Think carefully about what you're saying."*
>
> *"The Lady gave you a second chance when you deserved oblivion. She has invested in your redemption."*
>
> *"To abandon her now... it would not be forgiven. Not twice."*
>
> *"I'm not threatening you. I'm warning you. As close to a friend as a shadow can be."*
>
> *"Choose another path if you must. But understand: there is no coming back from that choice."*

---

# AMBIENT LINES (Random barks during barter)

## Tier 0-2 (Dismissive/Neutral)
- *"Stolen goods only. I don't buy legitimate merchandise - where's the fun in that?"*
- *"The Lady takes her cut. You get what's left. That's the arrangement."*
- *"Try to bring me something interesting next time."*
- *"Quantity has a quality of its own, I suppose."*
- *"At least you're consistent."*

## Tier 3-4 (Professional)
- *"Quality merchandise. The Guild's training shows."*
- *"You have a good eye. Most thieves grab everything. You grab what matters."*
- *"The shadows speak well of your work."*
- *"Business is improving. Keep it up."*
- *"The Lady notices those who serve with skill."*

## Tier 5-6 (Warm)
- *"A pleasure, as always."*
- *"You've become one of my better clients. Don't let it go to your head."*
- *"The Evergloam stirs when you bring offerings. She's pleased."*
- *"I find myself looking forward to your summons. Strange feeling."*
- *"Work like this reminds me why I serve."*

## Tier 7+ (Redeemed)
- *"Whatever you need. I'm at your service."*
- *"The Full Moon Agent, gracing me with stolen goods. I'm honored."*
- *"The shadows themselves envy our arrangement."*
- *"You've made an old shadow believe in redemption. Thank you for that."*
- *"Bring me anything. Everything. I'll make sure it reaches the right buyers."*

---

# IMPLEMENTATION NOTES

## Dialogue Conditions

Each dialogue option requires condition checks:
- `GetGlobalValue AotC_ShadowFenceTier >= X`
- `GetStageDone AotC_MainQuest X`
- `GetStageDone AotC_WaningMoon X`
- `GetStageDone AotC_ShadowsOfThePast X`
- `GetInFaction ThievesGuildFaction >= 0`

## Greeting Selection

Use `GetRandomPercent` combined with tier checks to select from appropriate greeting pool. Higher tiers should completely replace lower tier greetings, not add to them.

## Story Delivery Flags

After delivering major story content, set flags to prevent repetition:
- `AotC_SF_DeliveredMercerTruth`
- `AotC_SF_DeliveredWaningMoon`
- `AotC_SF_DeliveredSapphireTruth`
- `AotC_SF_DeliveredAfterlifePromise`

## Voice Considerations

If voice acting is planned:
- Tiers 0-2: Cold, clipped, impatient
- Tiers 3-4: Neutral, businesslike
- Tiers 5-6: Warmer, more conversational
- Tier 7+: Almost fond, mentorly
- Nocturnal possession: Harmonic undertones, reverb, slower cadence

---

*Last Updated: January 2026*
*Document Version: 1.0*
