-- ReplicatedStorage.Controllers.InputController.ActionTemplates
-- Script path: ReplicatedStorage.Controllers.InputController.ActionTemplates
-- Decompile time: 2.08 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent:WaitForChild("Types"))
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local HintController = require(ReplicatedStorage.Controllers.HintController)
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
local InspectController = require(ReplicatedStorage.Controllers.InspectController)
local EquipInventorySlot = require(ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local Leaderboard = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard)
local LocalPlayer = Players.LocalPlayer
local u62 = nil

local function action(a1, a2, a3, a4) -- Line: 36 -- types: a1: string, a2: string, a3: string
    return table.freeze({Name = a1, Group = a2, Category = a3, Callback = a4})
end

local function weaponKey(a1, a2) -- Line: 46
    -- upvalues: action (val), LocalPlayer (val), CaseSceneController (val), BlackMarketSceneController (val)
    -- upvalues: InspectController (val)
    return action(a1, "Gameplay", "Weapon Keys", function(a1, a2_2) -- Line: 47
        -- upvalues: LocalPlayer (upval), CaseSceneController (upval), BlackMarketSceneController (upval)
        -- upvalues: InspectController (upval), a2 (val)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or a1 ~= Enum.UserInputState.Begin then
            return
        end
        if not CaseSceneController.IsActive()
            and not BlackMarketSceneController.IsActive()
            and not InspectController.IsActive() then
            a2()
            return
        end
    end)
end

function v1.placeholder(a1, a2) -- Line: 65 -- upvalues: action (val) -- types: a1: string, a2: string
    return action(a1, "Gameplay", a2, function() end)
end

function v1.equipSlot(a1, a2, a3) -- Line: 71
    -- upvalues: weaponKey (val), HintController (val), EquipInventorySlot (val)
    return weaponKey(a1, function() -- Line: 72 -- upvalues: a3 (val), HintController (upval), EquipInventorySlot (upval), a2 (val)
        if a3 then
            HintController:clearHint("Reload")
        end
        EquipInventorySlot(a2)
    end)
end

function v1.equipGrenade(a1, a2) -- Line: 82
    -- upvalues: weaponKey (val), EquipInventorySlot (val)
    return weaponKey(a1, function() -- Line: 83 -- upvalues: EquipInventorySlot (upval), a2 (val)
        EquipInventorySlot(4, function(a1) -- Line: 84 -- upvalues: a2 (upval)
            return a2[a1.Name] == true
        end)
    end)
end

function v1.useEquipped(a1, a2, a3) -- Line: 92
    -- upvalues: weaponKey (val), InventoryController (val), HintController (val)
    return weaponKey(a1, function() -- Line: 93 -- upvalues: InventoryController (upval), a3 (val), HintController (upval), a2 (val)
        local v1 = InventoryController.getCurrentEquipped()
        if v1 then
            a3(v1)
            HintController:clearHint(a2)
        end
    end)
end

function v1.cycleWeapons(a1, a2) -- Line: 104
    -- upvalues: action (val), LocalPlayer (val), MenuState (val), CaseSceneController (val)
    -- upvalues: BlackMarketSceneController (val), InspectController (val), Leaderboard (val), HintController (val)
    return action(a1, "Gameplay", "Weapon Keys", function(a1, a2_2) -- Line: 105
        -- upvalues: LocalPlayer (upval), MenuState (upval), CaseSceneController (upval)
        -- upvalues: BlackMarketSceneController (upval), InspectController (upval), Leaderboard (upval), a2 (val)
        -- upvalues: HintController (upval)
        if not LocalPlayer:GetAttribute("IsPlayerChatting") and a1 == Enum.UserInputState.Begin then
            if not MenuState.GetCurrentScreen()
                and not CaseSceneController.IsActive()
                and not BlackMarketSceneController.IsActive()
                and not InspectController.IsActive() then
                if Leaderboard.IsRightClickUnlockActive() and a2_2.UserInputType == Enum.UserInputType.MouseWheel then
                    return
                end
                a2()
                HintController:clearHint("Reload")
                return
            end
            return
        end
    end)
end

function v1.movement(a1, a2, a3) -- Line: 126
    -- upvalues: LocalPlayer (val), action (val), CharacterResolver (val)
    local Controls = require((LocalPlayer:WaitForChild("PlayerScripts")):WaitForChild("PlayerModule")):GetControls()
    return action(a1, "Default", "Movement Keys", function(a1, a2_2) -- Line: 130
        -- upvalues: LocalPlayer (upval), CharacterResolver (upval), Controls (val), a2 (val), a3 (val)
        if LocalPlayer:GetAttribute("IsPlayerChatting")
            or not CharacterResolver.isAliveCharacter(CharacterResolver.getPlayerCharacter(LocalPlayer)) then
            return
        end
        local activeController = Controls.activeController
        if activeController and activeController.UpdateMovement then
            activeController[a2] = if a1 ~= Enum.UserInputState.Begin then 0 else a3
            activeController:UpdateMovement(a1)
            return
        end
    end)
end

function v1.chat(a1, a2) -- Line: 151
    -- upvalues: action (val), u62 (ref), ReplicatedStorage (val)
    return action(a1, "Default", "Communication Options", function(a1, a2_2) -- Line: 156 -- upvalues: u62 (upval), ReplicatedStorage (upval), a2 (val) -- types: a2_2: userdata
        if a1 ~= Enum.UserInputState.Begin then
            return
        end
        if not u62 then
            u62 = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Chat)
        end
        u62.OpenChat(a2())
    end)
end

return v1