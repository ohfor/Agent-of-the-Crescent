Scriptname AotC_StartQuest extends Quest
{Agent of the Crescent - Alternate Perspective Start Quest
 Handles the dream sequence and spawns player in Beggar's Row}

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

Event OnInit()
    ; AP may just start the quest without setting a stage
    ; Check if we're running and stage 10 hasn't been set yet
    If IsRunning() && GetStage() < 10
        SetStage(10)
    EndIf
EndEvent

; =============================================================================
; EVENT - Fires when ANY stage is set on this quest
; =============================================================================

Event OnStageSet(int auiStageID, int auiItemID)
    If auiStageID == 10
        StartPlayerInBeggarsRow()
    EndIf
EndEvent

; =============================================================================
; MAIN FUNCTION - Called when Stage 10 is set
; =============================================================================

Function StartPlayerInBeggarsRow()
    ; Show the dream sequence
    ShowDreamSequence()
    
    ; Strip player of everything
    PlayerRef.RemoveAllItems()
    
    ; Give starting equipment
    PlayerRef.AddItem(AotC_RaggedRobes, 1, true)
    PlayerRef.AddItem(AotC_RaggedFootwraps, 1, true)
    PlayerRef.AddItem(AotC_TarnishedInsignia, 1, true)
    
    ; Equip the clothes
    PlayerRef.EquipItem(AotC_RaggedRobes, false, true)
    PlayerRef.EquipItem(AotC_RaggedFootwraps, false, true)
    
    ; Move player to Beggar's Row
    PlayerRef.MoveTo(AotC_SpawnMarker)
    
    ; Clean up - stop this quest after a brief delay
    RegisterForSingleUpdate(1.0)
EndFunction

Event OnUpdate()
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
