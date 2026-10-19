-- CycleWeaponsLeft (ModuleScript)
-- full path: ReplicatedStorage.Controllers.InputController.Actions.CycleWeaponsLeft

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActionTemplates = require(script.Parent.Parent.ActionTemplates);
local EquipSlotLeft = require(ReplicatedStorage.Components.Common.UserInput.EquipSlotLeft);

return ActionTemplates.cycleWeapons("Cycle Weapons Left", EquipSlotLeft);