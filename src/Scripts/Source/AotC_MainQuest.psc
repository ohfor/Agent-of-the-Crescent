Scriptname AotC_MainQuest extends Quest
{Agent of the Crescent - Main Quest Controller
 Tracks player progression through the redemption arc and Thieves Guild questline.
 
 Stage Reference (20 apart for CK flexibility):
   10  - Awakening: Quest started, player in Beggar's Row
   30  - Accepted by Shadows: Joined TG + fenced 500g
   50  - First Offerings Complete: 3 offerings done → Shadow's Whisper
   70  - Betrayer Revealed: Second offerings + TG Speaking With Silence → Shadow's Step
   90  - Key Reclaimed: TG Blindsighted complete (Mercer dead)
   110 - Darkness Returns: TG09 complete → Shadow's Embrace
   130 - Redemption: Guild Master + shrine → Shadow Form + Redeemed
   200 - Abandoned: Failed state (forsook Nocturnal)
}

; =============================================================================
; PROPERTIES - Fill in Creation Kit
; =============================================================================

; --- Core References ---
Actor Property PlayerRef Auto
{The player actor}

Faction Property ThievesGuildFaction Auto
{The Thieves Guild faction - use TG faction from Skyrim.esm}

; --- Thieves Guild Quest References ---
Quest Property TG03 Auto
{Speaking With Silence - Mercer's betrayal revealed}

Quest Property TG08A Auto
{Blindsighted - Mercer confrontation (path A)}

Quest Property TG08B Auto
{Blindsighted - Mercer confrontation (path B)}

Quest Property TG09 Auto
{Darkness Returns - Return the Skeleton Key}

; --- Tracking Globals ---
GlobalVariable Property AotC_FencedGold Auto
{Gold value fenced through Shadow Fence - updated by alias script}

GlobalVariable Property AotC_NightTheftCount Auto
{Items stolen at night - updated by Story Manager quest}

GlobalVariable Property AotC_OfferingsComplete Auto
{Bitmask tracking which offerings are done}

GlobalVariable Property AotC_QuestStage Auto
{Mirrors quest stage for external script access}

; --- Threshold Constants (stored as globals for easy tuning) ---
GlobalVariable Property AotC_Threshold_FencedGold_I Auto
{First fencing threshold - default 500}

GlobalVariable Property AotC_Threshold_FencedGold_II Auto
{Second fencing threshold - default 1500}

GlobalVariable Property AotC_Threshold_Pickpocket Auto
{Pickpocket threshold - default 25}

GlobalVariable Property AotC_Threshold_TGJobs Auto
{TG jobs threshold - default 5}

GlobalVariable Property AotC_Threshold_NightTheft Auto
{Nighttime theft threshold - default 40}

; --- Powers & Abilities ---
Spell Property AotC_ShadowWhisper Auto
{Lesser Power: Detect Life - granted at Stage 50}

Spell Property AotC_ShadowStep Auto
{Lesser Power: Invisibility - granted at Stage 70}

Spell Property AotC_ShadowEmbrace Auto
{Lesser Power: Speed burst - granted at Stage 110}

Spell Property AotC_ShadowForm Auto
{Greater Power: Ethereal form - granted at Stage 130}

Spell Property AotC_NightingaleRedeemed Auto
{Ability: Passive thief bonuses - granted at Stage 130}

Spell Property AotC_NocturnalRejection Auto
{Ability: Curse debuff - granted at Stage 200}

Spell Property AotC_WhisperToShadow Auto
{Lesser Power: Summon Shadow Fence - granted at start}

; --- Items ---
MiscObject Property AotC_TarnishedInsignia Auto
{The tarnished insignia - removed at completion}

Armor Property AotC_RestoredInsignia Auto
{The restored insignia amulet - granted at completion}

; --- Courier Letters ---
Book Property AotC_Letter01 Auto
{Delivered after Stage 50}

Book Property AotC_Letter02 Auto
{Delivered after Stage 70}

Book Property AotC_Letter03 Auto
{Delivered after Stage 90}

; --- Messages ---
Message Property AotC_Msg_OfferingComplete Auto
{Generic "offering complete" notification}

Message Property AotC_Msg_PowerRestored Auto
{"A fragment of your power returns..." notification}

Message Property AotC_Msg_Redemption Auto
{Final completion message}

; =============================================================================
; OFFERING BITMASK CONSTANTS
; =============================================================================
; Using properties so they're accessible and documentable

Int Property OFFERING_WEALTH_I = 0x01 AutoReadOnly
{500 gold fenced}

Int Property OFFERING_WEALTH_II = 0x02 AutoReadOnly
{1500 gold fenced}

Int Property OFFERING_CUNNING = 0x04 AutoReadOnly
{5 TG radiant jobs complete}

Int Property OFFERING_BOLDNESS = 0x08 AutoReadOnly
{25 successful pickpockets}

Int Property OFFERING_DARKNESS = 0x10 AutoReadOnly
{40 items stolen at night}

Int Property OFFERING_AMBITION = 0x20 AutoReadOnly
{Stolen from a Jarl's residence}

Int Property OFFERING_SECRETS = 0x40 AutoReadOnly
{TG Speaking With Silence complete}

; =============================================================================
; INTERNAL STATE
; =============================================================================

Bool bIsTracking = False
Float fUpdateInterval = 5.0  ; Check every 5 seconds

; Cache previous stat values to detect changes
Int iLastPickpocketCount = 0
Int iLastTGJobCount = 0

; =============================================================================
; INITIALIZATION
; =============================================================================

Event OnInit()
    ; This quest is started by AotC_StartQuest after dream sequence
    Debug.Trace("[AotC] MainQuest OnInit - Stage: " + GetStage())
    
    If GetStage() == 0
        ; Quest just started, set to stage 10
        SetStage(10)
    EndIf
EndEvent

; =============================================================================
; STAGE HANDLING
; =============================================================================

Event OnStageSet(Int auiStageID, Int auiItemID)
    Debug.Trace("[AotC] MainQuest Stage Set: " + auiStageID)
    
    ; Update global mirror
    AotC_QuestStage.SetValueInt(auiStageID)
    
    If auiStageID == 10
        HandleStage10_Awakening()
    ElseIf auiStageID == 30
        HandleStage30_Accepted()
    ElseIf auiStageID == 50
        HandleStage50_FirstOfferings()
    ElseIf auiStageID == 70
        HandleStage70_BetrayerRevealed()
    ElseIf auiStageID == 90
        HandleStage90_KeyReclaimed()
    ElseIf auiStageID == 110
        HandleStage110_DarknessReturns()
    ElseIf auiStageID == 130
        HandleStage130_Redemption()
    ElseIf auiStageID == 200
        HandleStage200_Abandoned()
    EndIf
EndEvent

; =============================================================================
; STAGE HANDLERS
; =============================================================================

Function HandleStage10_Awakening()
    ; Quest has begun - player is in Beggar's Row
    Debug.Notification("[AotC] Your journey toward redemption begins...")
    
    ; Grant the Shadow Fence summoning power
    PlayerRef.AddSpell(AotC_WhisperToShadow, False)
    
    ; Initialize tracking globals
    AotC_FencedGold.SetValue(0)
    AotC_OfferingsComplete.SetValue(0)
    
    ; Start the update loop for tracking
    StartTracking()
EndFunction

Function HandleStage30_Accepted()
    ; Player joined guild and fenced initial gold
    Debug.Notification("[AotC] The shadows acknowledge your first steps...")
    
    ; No power at this stage - just progression acknowledgment
EndFunction

Function HandleStage50_FirstOfferings()
    ; First 3 offerings complete - grant Shadow's Whisper
    Debug.Notification("[AotC] Nocturnal returns a fragment of your sight...")
    
    PlayerRef.AddSpell(AotC_ShadowWhisper, False)
    
    ; Deliver first courier letter
    DeliverLetter(AotC_Letter01)
EndFunction

Function HandleStage70_BetrayerRevealed()
    ; Second offerings + Speaking With Silence - grant Shadow's Step
    Debug.Notification("[AotC] The shadows welcome you deeper...")
    
    PlayerRef.AddSpell(AotC_ShadowStep, False)
    
    ; Deliver second courier letter
    DeliverLetter(AotC_Letter02)
EndFunction

Function HandleStage90_KeyReclaimed()
    ; Blindsighted complete - Mercer is dead
    Debug.Notification("[AotC] The betrayer has fallen. The Key is yours once more.")
    
    ; Deliver third courier letter
    DeliverLetter(AotC_Letter03)
EndFunction

Function HandleStage110_DarknessReturns()
    ; TG09 complete - Key returned - grant Shadow's Embrace
    Debug.Notification("[AotC] The darkness bends to your will once more...")
    
    PlayerRef.AddSpell(AotC_ShadowEmbrace, False)
EndFunction

Function HandleStage130_Redemption()
    ; Quest complete! Guild Master + shrine activated
    
    ; Stop tracking - we're done
    StopTracking()
    
    ; Grant final rewards
    PlayerRef.AddSpell(AotC_ShadowForm, False)
    PlayerRef.AddSpell(AotC_NightingaleRedeemed, False)
    
    ; Transform insignia
    Int insigniaCount = PlayerRef.GetItemCount(AotC_TarnishedInsignia)
    If insigniaCount > 0
        PlayerRef.RemoveItem(AotC_TarnishedInsignia, insigniaCount, True)
    EndIf
    PlayerRef.AddItem(AotC_RestoredInsignia, 1, False)
    PlayerRef.EquipItem(AotC_RestoredInsignia, False, True)
    
    ; Show completion message
    If AotC_Msg_Redemption
        AotC_Msg_Redemption.Show()
    EndIf
    
    Debug.Notification("[AotC] Shadow's Redemption complete. You are redeemed.")
EndFunction

Function HandleStage200_Abandoned()
    ; Player forsook Nocturnal - fail state
    
    ; Stop tracking
    StopTracking()
    
    ; Remove all granted powers
    PlayerRef.RemoveSpell(AotC_WhisperToShadow)
    PlayerRef.RemoveSpell(AotC_ShadowWhisper)
    PlayerRef.RemoveSpell(AotC_ShadowStep)
    PlayerRef.RemoveSpell(AotC_ShadowEmbrace)
    
    ; Remove insignia (it crumbles)
    Int insigniaCount = PlayerRef.GetItemCount(AotC_TarnishedInsignia)
    If insigniaCount > 0
        PlayerRef.RemoveItem(AotC_TarnishedInsignia, insigniaCount, True)
    EndIf
    
    ; Apply curse
    PlayerRef.AddSpell(AotC_NocturnalRejection, False)
    
    Debug.Notification("[AotC] Nocturnal has abandoned you. The shadows turn cold.")
EndFunction

; =============================================================================
; TRACKING SYSTEM
; =============================================================================

Function StartTracking()
    If !bIsTracking
        bIsTracking = True
        ; Cache initial stat values
        iLastPickpocketCount = Game.QueryStat("Pockets Picked")
        iLastTGJobCount = GetTGJobCount()
        RegisterForSingleUpdate(fUpdateInterval)
        Debug.Trace("[AotC] Tracking started")
    EndIf
EndFunction

Function StopTracking()
    bIsTracking = False
    UnregisterForUpdate()
    Debug.Trace("[AotC] Tracking stopped")
EndFunction

Event OnUpdate()
    If !bIsTracking
        Return
    EndIf
    
    ; Check progress and update offerings
    CheckOfferingProgress()
    
    ; Check for stage advancement
    CheckStageAdvancement()
    
    ; Continue the update loop
    RegisterForSingleUpdate(fUpdateInterval)
EndEvent

; =============================================================================
; OFFERING PROGRESS CHECKS
; =============================================================================

Function CheckOfferingProgress()
    Int currentOfferings = AotC_OfferingsComplete.GetValueInt()
    Int newOfferings = currentOfferings
    
    ; --- Offering of Wealth I (500g fenced) ---
    If !HasOffering(OFFERING_WEALTH_I)
        If AotC_FencedGold.GetValue() >= AotC_Threshold_FencedGold_I.GetValue()
            newOfferings = Math.LogicalOr(newOfferings, OFFERING_WEALTH_I)
            Debug.Notification("Offering of Wealth (I) complete.")
        EndIf
    EndIf
    
    ; --- Offering of Wealth II (1500g fenced) ---
    If !HasOffering(OFFERING_WEALTH_II)
        If AotC_FencedGold.GetValue() >= AotC_Threshold_FencedGold_II.GetValue()
            newOfferings = Math.LogicalOr(newOfferings, OFFERING_WEALTH_II)
            Debug.Notification("Offering of Wealth (II) complete.")
        EndIf
    EndIf
    
    ; --- Offering of Boldness (pickpockets) ---
    If !HasOffering(OFFERING_BOLDNESS)
        Int currentPicks = Game.QueryStat("Pockets Picked")
        If currentPicks >= AotC_Threshold_Pickpocket.GetValueInt()
            newOfferings = Math.LogicalOr(newOfferings, OFFERING_BOLDNESS)
            Debug.Notification("Offering of Boldness complete.")
        EndIf
    EndIf
    
    ; --- Offering of Cunning (TG jobs) ---
    If !HasOffering(OFFERING_CUNNING)
        Int currentJobs = GetTGJobCount()
        If currentJobs >= AotC_Threshold_TGJobs.GetValueInt()
            newOfferings = Math.LogicalOr(newOfferings, OFFERING_CUNNING)
            Debug.Notification("Offering of Cunning complete.")
        EndIf
    EndIf
    
    ; --- Offering of Darkness (night theft) - tracked by Story Manager ---
    If !HasOffering(OFFERING_DARKNESS)
        If AotC_NightTheftCount.GetValue() >= AotC_Threshold_NightTheft.GetValue()
            newOfferings = Math.LogicalOr(newOfferings, OFFERING_DARKNESS)
            Debug.Notification("Offering of Darkness complete.")
        EndIf
    EndIf
    
    ; --- Offering of Secrets (TG Speaking With Silence) ---
    If !HasOffering(OFFERING_SECRETS)
        If TG03.GetStageDone(200)  ; TG03 stage 200 = quest complete
            newOfferings = Math.LogicalOr(newOfferings, OFFERING_SECRETS)
            Debug.Notification("Offering of Secrets complete. The betrayer is revealed.")
        EndIf
    EndIf
    
    ; Update global if changed
    If newOfferings != currentOfferings
        AotC_OfferingsComplete.SetValueInt(newOfferings)
    EndIf
EndFunction

Bool Function HasOffering(Int offeringBit)
    Return Math.LogicalAnd(AotC_OfferingsComplete.GetValueInt(), offeringBit) != 0
EndFunction

Int Function CountOfferings()
    Int offerings = AotC_OfferingsComplete.GetValueInt()
    Int count = 0
    
    If Math.LogicalAnd(offerings, OFFERING_WEALTH_I) != 0
        count += 1
    EndIf
    If Math.LogicalAnd(offerings, OFFERING_WEALTH_II) != 0
        count += 1
    EndIf
    If Math.LogicalAnd(offerings, OFFERING_CUNNING) != 0
        count += 1
    EndIf
    If Math.LogicalAnd(offerings, OFFERING_BOLDNESS) != 0
        count += 1
    EndIf
    If Math.LogicalAnd(offerings, OFFERING_DARKNESS) != 0
        count += 1
    EndIf
    If Math.LogicalAnd(offerings, OFFERING_AMBITION) != 0
        count += 1
    EndIf
    If Math.LogicalAnd(offerings, OFFERING_SECRETS) != 0
        count += 1
    EndIf
    
    Return count
EndFunction

; =============================================================================
; STAGE ADVANCEMENT CHECKS
; =============================================================================

Function CheckStageAdvancement()
    Int currentStage = GetStage()
    
    ; Stage 10 → 30: Join TG + fence 500g
    If currentStage == 10
        If IsInThievesGuild() && HasOffering(OFFERING_WEALTH_I)
            SetStage(30)
        EndIf
        
    ; Stage 30 → 50: Complete first 3 offerings (Wealth II, Cunning, Boldness)
    ElseIf currentStage == 30
        Bool hasFirstThree = HasOffering(OFFERING_WEALTH_II) && \
                            HasOffering(OFFERING_CUNNING) && \
                            HasOffering(OFFERING_BOLDNESS)
        If hasFirstThree
            SetStage(50)
        EndIf
        
    ; Stage 50 → 70: Complete second offerings (Darkness, Ambition, Secrets)
    ElseIf currentStage == 50
        Bool hasSecondThree = HasOffering(OFFERING_DARKNESS) && \
                             HasOffering(OFFERING_SECRETS)
        ; Note: Ambition is optional stretch goal, not required for progression
        If hasSecondThree
            SetStage(70)
        EndIf
        
    ; Stage 70 → 90: Blindsighted complete
    ElseIf currentStage == 70
        If IsTGQuestComplete(TG08A) || IsTGQuestComplete(TG08B)
            SetStage(90)
        EndIf
        
    ; Stage 90 → 110: Darkness Returns complete
    ElseIf currentStage == 90
        If IsTGQuestComplete(TG09)
            SetStage(110)
        EndIf
        
    ; Stage 110 → 130: Guild Master + shrine activation
    ; Note: Shrine activation handled separately via trigger/activation script
    ElseIf currentStage == 110
        If IsGuildMaster()
            ; We only auto-advance to 130 when shrine is activated
            ; This is handled by a separate activation script on the shrine
            ; For now, just ensure player knows to visit the shrine
        EndIf
    EndIf
EndFunction

; =============================================================================
; HELPER FUNCTIONS
; =============================================================================

Bool Function IsInThievesGuild()
    Return PlayerRef.IsInFaction(ThievesGuildFaction)
EndFunction

Bool Function IsGuildMaster()
    ; Guild Master is rank 4 in TG faction (0-indexed: 0,1,2,3,4)
    Return PlayerRef.GetFactionRank(ThievesGuildFaction) >= 4
EndFunction

Bool Function IsTGQuestComplete(Quest akQuest)
    ; Most TG quests use stage 200 for completion
    If akQuest
        Return akQuest.GetStageDone(200)
    EndIf
    Return False
EndFunction

Int Function GetTGJobCount()
    ; TG tracks jobs via globals or quest stages
    ; We need to count completed radiant jobs
    ; This is a simplified version - may need refinement based on actual TG tracking
    
    ; Option 1: Count via TG quest stages if available
    ; Option 2: Track ourselves via Story Manager (future enhancement)
    
    ; For now, return a placeholder that checks TG internals
    ; The actual implementation depends on how TG tracks this
    
    ; TG uses TGRMasterQuest to track jobs
    ; Jobs completed is stored in various ways...
    ; This needs research into TG's actual tracking mechanism
    
    Return 0  ; TODO: Implement proper TG job counting
EndFunction

Function DeliverLetter(Book akLetter)
    If akLetter
        PlayerRef.AddItem(akLetter, 1, False)
        Debug.Notification("A mysterious letter has found its way into your possession...")
    EndIf
EndFunction

; =============================================================================
; EXTERNAL INTERFACE
; Called by other scripts (e.g., shrine activation)
; =============================================================================

Function CompleteRedemption()
    ; Called by shrine activation script when player activates Nocturnal's shrine
    ; while at Stage 110 and is Guild Master
    If GetStage() == 110 && IsGuildMaster()
        SetStage(130)
    EndIf
EndFunction

Function AbandonNocturnal()
    ; Called by Wintersun monitor or other system when player forsakes Nocturnal
    If GetStage() < 130 && GetStage() != 200
        SetStage(200)
    EndIf
EndFunction

Function AddFencedGold(Int amount)
    ; Called by Shadow Fence alias script when player sells items
    Float current = AotC_FencedGold.GetValue()
    AotC_FencedGold.SetValue(current + amount)
    Debug.Trace("[AotC] Fenced gold updated: " + (current + amount))
EndFunction
