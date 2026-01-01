Scriptname AotC_StartQuest extends Quest
{Agent of the Crescent - Alternate Perspective Start Quest
 Handles the dream sequence and spawns player in Beggar's Row.
 After completion, starts the main quest and stops itself.}

; =============================================================================
; PROPERTIES - These get filled in Creation Kit
; =============================================================================

Actor Property PlayerRef Auto
{The player reference}

ObjectReference Property AotC_SpawnMarker Auto
{XMarker in Beggar's Row where player spawns}

MiscObject Property AotC_TarnishedInsignia Auto
{The mysterious trinket - Tarnished Nightingale Insignia}

Armor Property AotC_RaggedRobes Auto
{Starting clothes - ragged robes}

Armor Property AotC_RaggedFootwraps Auto
{Starting shoes - footwraps}

Message Property AotC_Dream01 Auto
{Dream sequence message 1 - The Void}

Message Property AotC_Dream02 Auto
{Dream sequence message 2 - The Voice}

Message Property AotC_Dream03 Auto
{Dream sequence message 3 - The Command}

Message Property AotC_Dream04 Auto
{Dream sequence message 4 - The Awakening}

Quest Property AotC_MainQuest Auto
{The main quest to start after spawning}

; =============================================================================
; INITIALIZATION
; =============================================================================

Event OnInit()
    Debug.Trace("[AotC] StartQuest OnInit - IsRunning: " + IsRunning() + ", Stage: " + GetStage())
    
    If IsRunning()
        If GetStage() >= 10
            ; Stage already set by AP before script initialized
            StartPlayerInBeggarsRow()
        Else
            SetStage(10)
        EndIf
    EndIf
EndEvent

; =============================================================================
; EVENT - Fires when ANY stage is set on this quest
; =============================================================================

Event OnStageSet(Int auiStageID, Int auiItemID)
    If auiStageID == 10
        StartPlayerInBeggarsRow()
    EndIf
EndEvent

; =============================================================================
; MAIN FUNCTION - Called when Stage 10 is set
; =============================================================================

Function StartPlayerInBeggarsRow()
    Debug.Trace("[AotC] Starting player in Beggar's Row...")
    
    ; Show the dream sequence
    ShowDreamSequence()
    
    ; Strip player of everything (AP may have given default items)
    PlayerRef.RemoveAllItems()
    
    ; Give starting equipment
    PlayerRef.AddItem(AotC_RaggedRobes, 1, True)
    PlayerRef.AddItem(AotC_RaggedFootwraps, 1, True)
    PlayerRef.AddItem(AotC_TarnishedInsignia, 1, True)
    
    ; Equip the clothes
    PlayerRef.EquipItem(AotC_RaggedRobes, False, True)
    PlayerRef.EquipItem(AotC_RaggedFootwraps, False, True)
    
    ; Move player to Beggar's Row
    PlayerRef.MoveTo(AotC_SpawnMarker)
    
    ; Start the main quest
    If AotC_MainQuest
        AotC_MainQuest.Start()
        Debug.Trace("[AotC] Main quest started")
    Else
        Debug.Trace("[AotC] WARNING: Main quest property not set!")
    EndIf
    
    ; Clean up - stop this quest after a brief delay
    RegisterForSingleUpdate(1.0)
EndFunction

Event OnUpdate()
    Debug.Trace("[AotC] StartQuest stopping...")
    Stop()
EndEvent

; =============================================================================
; HELPER FUNCTIONS
; =============================================================================

Function ShowDreamSequence()
    ; Brief pause for immersion
    Utility.Wait(0.5)
    
    ; Message 1: The Void
    AotC_Dream01.Show()
    Utility.Wait(0.3)
    
    ; Message 2: The Voice  
    AotC_Dream02.Show()
    Utility.Wait(0.3)
    
    ; Message 3: The Command
    AotC_Dream03.Show()
    Utility.Wait(0.3)
    
    ; Message 4: The Awakening
    AotC_Dream04.Show()
EndFunction
