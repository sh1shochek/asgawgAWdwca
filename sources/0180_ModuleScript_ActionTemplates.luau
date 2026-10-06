-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent:WaitForChild("Types"));
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
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

local function action(p3: string, p4: string, p5: string, p6: any) -- Line: 36
    return table.freeze({
        Name = p3,
        Group = p4,
        Category = p5,
        Callback = p6
    });
end;

local function weaponKey(p7: string, u8: function) -- Line: 46
    -- upvalues: action (copy), LocalPlayer (copy), CaseSceneController (copy), BlackMarketSceneController (copy), InspectController (copy)
    return action(p7, "Gameplay", "Weapon Keys", function(p9: any, p10: userdata) -- Line: 47
        -- upvalues: LocalPlayer (ref), CaseSceneController (ref), BlackMarketSceneController (ref), InspectController (ref), u8 (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p9 ~= Enum.UserInputState.Begin then
            return;
        end;

        if CaseSceneController.IsActive() or (BlackMarketSceneController.IsActive() or InspectController.IsActive()) then
            return;
        end;

        u8();
    end);
end;

function v1.placeholder(p11: string, p12: string) -- Line: 65
    -- upvalues: action (copy)
    return action(p11, "Gameplay", p12, function() -- Line: 66
    end);
end;

function v1.equipSlot(p13: string, u14: number, u15: boolean?) -- Line: 71
    -- upvalues: weaponKey (copy), HintController (copy), EquipInventorySlot (copy)
    return weaponKey(p13, function() -- Line: 72
        -- upvalues: u15 (copy), HintController (ref), EquipInventorySlot (ref), u14 (copy)
        if u15 then
            HintController:clearHint("Reload");
        end;

        EquipInventorySlot(u14);
    end);
end;

function v1.equipGrenade(p16: string, u17: table) -- Line: 82
    -- upvalues: weaponKey (copy), EquipInventorySlot (copy)
    return weaponKey(p16, function() -- Line: 83
        -- upvalues: EquipInventorySlot (ref), u17 (copy)
        EquipInventorySlot(4, function(p18) -- Line: 84
            -- upvalues: u17 (ref)
            return u17[p18.Name] == true;
        end);
    end);
end;

function v1.useEquipped(p19: string, u20: string, u21: function) -- Line: 92
    -- upvalues: weaponKey (copy), InventoryController (copy), HintController (copy)
    return weaponKey(p19, function() -- Line: 93
        -- upvalues: InventoryController (ref), u21 (copy), HintController (ref), u20 (copy)
        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if CurrentEquipped then
            u21(CurrentEquipped);
            HintController:clearHint(u20);
        end;
    end);
end;

function v1.cycleWeapons(p22: string, u23: function) -- Line: 104
    -- upvalues: action (copy), LocalPlayer (copy), MenuState (copy), CaseSceneController (copy), BlackMarketSceneController (copy), InspectController (copy), Leaderboard (copy), HintController (copy)
    return action(p22, "Gameplay", "Weapon Keys", function(p24: any, p25: userdata) -- Line: 105
        -- upvalues: LocalPlayer (ref), MenuState (ref), CaseSceneController (ref), BlackMarketSceneController (ref), InspectController (ref), Leaderboard (ref), u23 (copy), HintController (ref)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or p24 ~= Enum.UserInputState.Begin then
            return;
        end;

        if MenuState.GetCurrentScreen() or (CaseSceneController.IsActive() or (BlackMarketSceneController.IsActive() or (InspectController.IsActive() or Leaderboard.IsRightClickUnlockActive() and p25.UserInputType == Enum.UserInputType.MouseWheel))) then
            return;
        end;

        u23();
        HintController:clearHint("Reload");
    end);
end;

function v1.movement(p26: string, u27: string, u28: number) -- Line: 126
    -- upvalues: LocalPlayer (copy), action (copy), CharacterResolver (copy)
    local Controls = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls();

    return action(p26, "Default", "Movement Keys", function(p29: any, p30: userdata) -- Line: 130
        -- upvalues: LocalPlayer (ref), CharacterResolver (ref), Controls (copy), u27 (copy), u28 (copy)
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

        activeController[u27] = p29 ~= Enum.UserInputState.Begin and 0 or u28;
        activeController:UpdateMovement(p29);
    end);
end;

function v1.chat(p31: string, u32: function) -- Line: 151
    -- upvalues: action (copy), u2 (ref), ReplicatedStorage (copy)
    return action(p31, "Default", "Communication Options", function(p33: any, p34: userdata) -- Line: 156
        -- upvalues: u2 (ref), ReplicatedStorage (ref), u32 (copy)
        if p33 ~= Enum.UserInputState.Begin then
            return;
        end;

        if not u2 then
            u2 = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Chat);
        end;

        u2.OpenChat(u32());
    end);
end;

return v1;