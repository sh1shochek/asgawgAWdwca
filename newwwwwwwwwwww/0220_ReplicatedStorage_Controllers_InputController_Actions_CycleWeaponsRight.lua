-- CycleWeaponsRight (ModuleScript)
-- full path: ReplicatedStorage.Controllers.InputController.Actions.CycleWeaponsRight

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActionTemplates = require(script.Parent.Parent.ActionTemplates);
local EquipSlotRight = require(ReplicatedStorage.Components.Common.UserInput.EquipSlotRight);

return ActionTemplates.cycleWeapons("Cycle Weapons Right", EquipSlotRight);