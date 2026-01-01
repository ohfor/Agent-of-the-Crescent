Scriptname AotC_ShadowFenceAlias extends ReferenceAlias
{Attached to the Shadow Fence NPC reference alias.
 Tracks gold value of items sold to the Shadow Fence.
 
 When items are added to the Shadow Fence's inventory (player sells),
 we calculate their value and update the tracking global.}

; =============================================================================
; PROPERTIES
; =============================================================================

Quest Property AotC_MainQuest Auto
{Reference to the main quest for calling AddFencedGold}

GlobalVariable Property AotC_FencedGold Auto
{Direct reference to the tracking global (backup if quest cast fails)}

; =============================================================================
; EVENTS
; =============================================================================

Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    ; This fires when items are added to the Shadow Fence's inventory
    ; akSourceContainer will be the player when they sell items
    
    If akSourceContainer == Game.GetPlayer()
        ; Player is selling to us
        Int itemValue = CalculateItemValue(akBaseItem, aiItemCount)
        
        If itemValue > 0
            ; Update the main quest's tracking
            AotC_MainQuest mainScript = AotC_MainQuest as AotC_MainQuest
            If mainScript
                mainScript.AddFencedGold(itemValue)
            Else
                ; Fallback: update global directly
                Float current = AotC_FencedGold.GetValue()
                AotC_FencedGold.SetValue(current + itemValue)
            EndIf
            
            Debug.Trace("[AotC] Shadow Fence received items worth " + itemValue + " gold")
        EndIf
    EndIf
EndEvent

; =============================================================================
; HELPER FUNCTIONS
; =============================================================================

Int Function CalculateItemValue(Form akBaseItem, Int aiItemCount)
    ; Get the base gold value of the item
    ; Note: This gets the BASE value, not the barter-adjusted value
    ; The actual gold the player receives depends on Speech skill, etc.
    ; For offering tracking, we use base value as the "worth" of the theft
    
    Int baseValue = akBaseItem.GetGoldValue()
    Return baseValue * aiItemCount
EndFunction

; =============================================================================
; FENCE DISMISSAL
; =============================================================================

Event OnUnload()
    ; Shadow Fence is being dismissed/despawned
    ; Any cleanup needed goes here
    Debug.Trace("[AotC] Shadow Fence dismissed")
EndEvent
