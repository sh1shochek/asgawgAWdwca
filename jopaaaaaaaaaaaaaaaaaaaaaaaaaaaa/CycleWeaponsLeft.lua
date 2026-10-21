-- ReplicatedStorage.Controllers.InputController.Actions.CycleWeaponsLeft
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.CycleWeaponsLeft
-- Decompile time: 2.56 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActionTemplates = require(script.Parent.Parent.ActionTemplates);
local EquipSlotLeft = require(ReplicatedStorage.Components.Common.UserInput.EquipSlotLeft);

return ActionTemplates.cycleWeapons("Cycle Weapons Left", EquipSlotLeft);