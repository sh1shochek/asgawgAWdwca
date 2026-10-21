-- ReplicatedStorage.Controllers.InputController.ActionTemplates
-- Script path: ReplicatedStorage.Controllers.InputController.ActionTemplates
-- Decompile time: 6.42 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent:WaitForChild("Types"));
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local HintController = require(ReplicatedStorage.Controllers.HintController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local EquipInventorySlot = require(ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Leaderboard = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;

local function action(p3: string, p4: string, p5: string, p6: any) -- Line: 37
    return table.freeze({
        Name = p3,
        Group = p4,
        Category = p5,
        Callback = p6
    });
end;

local function weaponKey(p7: string, u8: function) -- Line: 47
    -- upvalues: action (copy), LocalPlayer (copy), CaseSceneController (copy), BlackMarketSceneController (copy), InspectController (copy), InventoryController (copy), SurvivalDowned (copy)
    return action(p7, "Gameplay", "Weapon Keys", function(p9: any, p10: userdata) -- Line: 48
        -- upvalues: LocalPlayer (ref), CaseSceneController (ref), BlackMarketSceneController (ref), InspectController (ref), InventoryController (ref), SurvivalDowned (ref), u8 (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p9 ~= Enum.UserInputState.Begin then
            return;
        end;

        if CaseSceneController.IsActive() or (BlackMarketSceneController.IsActive() or InspectController.IsActive()) then
            return;
        end;

        local CurrentEquipped = InventoryController.getCurrentEquipped();
        local v11;

        if CurrentEquipped then
            v11 = CurrentEquipped.Properties.Slot;
        else
            v11 = nil;
        end;

        if not SurvivalDowned.CanUseSlot(LocalPlayer, v11) then
            return;
        end;

        u8();
    end);
end;

function v1.placeholder(p12: string, p13: string) -- Line: 72
    -- upvalues: action (copy)
    return action(p12, "Gameplay", p13, function() -- Line: 73
    end);
end;

function v1.equipSlot(p14: string, u15: number, u16: boolean?) -- Line: 78
    -- upvalues: weaponKey (copy), HintController (copy), EquipInventorySlot (copy)
    return weaponKey(p14, function() -- Line: 79
        -- upvalues: u16 (copy), HintController (ref), EquipInventorySlot (ref), u15 (copy)
        if u16 then
            HintController:clearHint("Reload");
        end;

        EquipInventorySlot(u15);
    end);
end;

function v1.equipGrenade(p17: string, u18: table) -- Line: 89
    -- upvalues: weaponKey (copy), EquipInventorySlot (copy)
    return weaponKey(p17, function() -- Line: 90
        -- upvalues: EquipInventorySlot (ref), u18 (copy)
        EquipInventorySlot(4, function(p19) -- Line: 91
            -- upvalues: u18 (ref)
            return u18[p19.Name] == true;
        end);
    end);
end;

function v1.useEquipped(p20: string, u21: string, u22: function) -- Line: 99
    -- upvalues: weaponKey (copy), InventoryController (copy), HintController (copy)
    return weaponKey(p20, function() -- Line: 100
        -- upvalues: InventoryController (ref), u22 (copy), HintController (ref), u21 (copy)
        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if CurrentEquipped then
            u22(CurrentEquipped);
            HintController:clearHint(u21);
        end;
    end);
end;

function v1.cycleWeapons(p23: string, u24: function) -- Line: 111
    -- upvalues: action (copy), LocalPlayer (copy), MenuState (copy), CaseSceneController (copy), BlackMarketSceneController (copy), InspectController (copy), Leaderboard (copy), HintController (copy)
    return action(p23, "Gameplay", "Weapon Keys", function(p25: any, p26: userdata) -- Line: 112
        -- upvalues: LocalPlayer (ref), MenuState (ref), CaseSceneController (ref), BlackMarketSceneController (ref), InspectController (ref), Leaderboard (ref), u24 (copy), HintController (ref)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or p25 ~= Enum.UserInputState.Begin then
            return;
        end;

        if MenuState.GetCurrentScreen() or (CaseSceneController.IsActive() or (BlackMarketSceneController.IsActive() or (InspectController.IsActive() or Leaderboard.IsRightClickUnlockActive() and p26.UserInputType == Enum.UserInputType.MouseWheel))) then
            return;
        end;

        u24();
        HintController:clearHint("Reload");
    end);
end;

function v1.movement(p27: string, u28: string, u29: number) -- Line: 133
    -- upvalues: LocalPlayer (copy), action (copy), CharacterResolver (copy)
    local Controls = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls();

    return action(p27, "Default", "Movement Keys", function(p30: any, p31: userdata) -- Line: 137
        -- upvalues: LocalPlayer (ref), CharacterResolver (ref), Controls (copy), u28 (copy), u29 (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if not CharacterResolver.isAliveCharacter(CharacterResolver.getPlayerCharacter(LocalPlayer)) then
            return;
        end;

        local activeController = Controls.activeController;

        if not (activeController and activeController.UpdateMovement) then
            return;
        end;

        activeController[u28] = p30 ~= Enum.UserInputState.Begin and 0 or u29;
        activeController:UpdateMovement(p30);
    end);
end;

function v1.chat(p32: string, u33: function) -- Line: 158
    -- upvalues: action (copy), u2 (ref), ReplicatedStorage (copy)
    return action(p32, "Default", "Communication Options", function(p34: any, p35: userdata) -- Line: 163
        -- upvalues: u2 (ref), ReplicatedStorage (ref), u33 (copy)
        if p34 ~= Enum.UserInputState.Begin then
            return;
        end;

        if not u2 then
            u2 = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Chat);
        end;

        u2.OpenChat(u33());
    end);
end;

return v1;