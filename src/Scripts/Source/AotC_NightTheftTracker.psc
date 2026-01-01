Scriptname AotC_NightTheftTracker extends Quest
{Story Manager Event Quest for tracking nighttime theft.

 This quest is started by the Story Manager when the player adds an item
 that had a previous owner (i.e., was stolen). We check if it's nighttime
 and increment the counter if so.
 
 CRITICAL: This quest must be set up correctly in Story Manager:
 - Event Type: Player Add Item
 - Conditions: 
   - GetEventData OwnerRef != None
   - GetEventData OwnerRef != PlayerRef
 - "Shares Event" must be CHECKED
 - This quest stops itself after each event so SM can re-trigger it
}

; =============================================================================
; PROPERTIES
; =============================================================================

GlobalVariable Property AotC_NightTheftCount Auto
{The counter tracking nighttime thefts}

GlobalVariable Property AotC_QuestStage Auto
{Main quest stage - we only track during active quest}

GlobalVariable Property AotC_Threshold_NightTheft Auto
{The threshold for completion (default 40)}

; Nighttime hours (9 PM to 5 AM)
Float Property fNightStart = 21.0 AutoReadOnly
Float Property fNightEnd = 5.0 AutoReadOnly

; =============================================================================
; STORY MANAGER EVENT
; =============================================================================

Event OnStoryPlayerGetItem(ObjectReference akOwner, ObjectReference akContainer, Location akLocation, Form akItemBase, Int aiAcquireType)
    ; NOTE: Different Papyrus versions use different event signatures
    ; If this doesn't compile, try OnStoryPlayerAddItem instead
    
    ProcessTheft()
EndEvent

; Alternative event signature for some Papyrus versions
; Uncomment if the above doesn't work
;Event OnStoryPlayerAddItem(ObjectReference akOwner, ObjectReference akContainer, Location akLocation, Form akItemBase)
;    ProcessTheft()
;EndEvent

; =============================================================================
; MAIN LOGIC
; =============================================================================

Function ProcessTheft()
    ; Check if main quest is in a stage where we track this
    ; We start tracking at stage 50 (when Offering of Darkness becomes relevant)
    Int mainStage = AotC_QuestStage.GetValueInt()
    If mainStage < 50 || mainStage >= 130
        ; Not in tracking range, stop and exit
        Stop()
        Return
    EndIf
    
    ; Check if it's already complete
    If AotC_NightTheftCount.GetValue() >= AotC_Threshold_NightTheft.GetValue()
        ; Already complete, no need to track more
        Stop()
        Return
    EndIf
    
    ; Check if it's nighttime
    If IsNighttime()
        ; Increment the counter
        Int newCount = AotC_NightTheftCount.GetValueInt() + 1
        AotC_NightTheftCount.SetValueInt(newCount)
        
        ; Milestone feedback
        If newCount == 10
            Debug.Notification("The night witnesses your devotion...")
        ElseIf newCount == 25
            Debug.Notification("Nocturnal's domain embraces your work...")
        ElseIf newCount == 40
            Debug.Notification("The Offering of Darkness is complete.")
        EndIf
        
        Debug.Trace("[AotC] Night theft count: " + newCount)
    EndIf
    
    ; CRITICAL: Stop the quest so Story Manager can re-trigger it
    Stop()
EndFunction

; =============================================================================
; HELPER FUNCTIONS
; =============================================================================

Bool Function IsNighttime()
    ; Get current game hour (0.0 to 23.99...)
    Float currentTime = Utility.GetCurrentGameTime()
    Float currentHour = (currentTime - Math.Floor(currentTime)) * 24.0
    
    ; Nighttime is 9 PM (21:00) to 5 AM (05:00)
    ; This wraps around midnight
    If currentHour >= fNightStart || currentHour < fNightEnd
        Return True
    EndIf
    
    Return False
EndFunction
