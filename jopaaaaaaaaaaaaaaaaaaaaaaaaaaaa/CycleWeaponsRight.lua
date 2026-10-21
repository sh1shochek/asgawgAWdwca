-- ReplicatedStorage.Controllers.InputController.Actions.CycleWeaponsRight
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.CycleWeaponsRight
-- Decompile time: 2.11 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActionTemplates = require(script.Parent.Parent.ActionTemplates);
local EquipSlotRight = require(ReplicatedStorage.Components.Common.UserInput.EquipSlotRight);

return ActionTemplates.cycleWeapons("Cycle Weapons Right", EquipSlotRight);