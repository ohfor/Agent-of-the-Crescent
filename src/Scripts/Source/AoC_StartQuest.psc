Scriptname AoC_StartQuest extends Quest
{Agent of the Crescent - Alternate Perspective Start Quest
 Handles the dream sequence and spawns player in Beggar's Row}

; =============================================================================
; PROPERTIES - These get filled in Creation Kit
; =============================================================================

Actor Property PlayerRef Auto
{The player reference}

ObjectReference Property AoC_SpawnMarker Auto
{XMarker in Beggar's Row where player spawns}

MiscObject Property AoC_TarnishedInsignia Auto
{The mysterious trinket - Tarnished Nightingale Insignia}

Armor Property AoC_RaggedRobes Auto
{Starting clothes - ragged robes}

Armor Property AoC_RaggedFootwraps Auto
{Starting shoes - footwraps}

Message Property AoC_Dream01 Auto
{Dream sequence message 1 - The Void}

Message Property AoC_Dream02 Auto
{Dream sequence message 2 - The Voice}

Message Property AoC_Dream03 Auto
{Dream sequence message 3 - The Command}

Message Property AoC_Dream04 Auto
{Dream sequence message 4 - The Awakening}

; =============================================================================
; QUEST FRAGMENT - Called when AP starts this quest
; =============================================================================

Function Fragment_0()
    ; Show the dream sequence
    ShowDreamSequence()
    
    ; Strip player of everything
    PlayerRef.RemoveAllItems()
    
    ; Give starting equipment
    PlayerRef.AddItem(AoC_RaggedRobes, 1, true)
    PlayerRef.AddItem(AoC_RaggedFootwraps, 1, true)
    PlayerRef.AddItem(AoC_TarnishedInsignia, 1, true)
    
    ; Equip the clothes
    PlayerRef.EquipItem(AoC_RaggedRobes, false, true)
    PlayerRef.EquipItem(AoC_RaggedFootwraps, false, true)
    
    ; Move player to Beggar's Row
    PlayerRef.MoveTo(AoC_SpawnMarker)
    
    ; Clean up - stop this quest
    Stop()
EndFunction

; =============================================================================
; HELPER FUNCTIONS
; =============================================================================

Function ShowDreamSequence()
    ; Brief pause for immersion
    Utility.Wait(0.5)
    
    ; Message 1: The Void
    AoC_Dream01.Show()
    Utility.Wait(0.3)
    
    ; Message 2: The Voice  
    AoC_Dream02.Show()
    Utility.Wait(0.3)
    
    ; Message 3: The Command
    AoC_Dream03.Show()
    Utility.Wait(0.3)
    
    ; Message 4: The Awakening
    AoC_Dream04.Show()
EndFunction
