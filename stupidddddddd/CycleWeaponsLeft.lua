-- ReplicatedStorage.Controllers.InputController.Actions.CycleWeaponsLeft
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.CycleWeaponsLeft
-- Decompile time: 0.15 ms

return (require(script.Parent.Parent.ActionTemplates)).cycleWeapons(
    "Cycle Weapons Left",
    (require((game:GetService("ReplicatedStorage")).Components.Common.UserInput.EquipSlotLeft))
)