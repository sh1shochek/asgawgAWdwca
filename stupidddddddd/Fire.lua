-- ReplicatedStorage.Controllers.InputController.Actions.Fire
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.Fire
-- Decompile time: 4.47 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local GamepadTrigger = require(script.Parent.Parent.GamepadTrigger)
local LocalPlayer = Players.LocalPlayer
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
local InspectController = require(ReplicatedStorage.Controllers.InspectController)
local HintController = require(ReplicatedStorage.Controllers.HintController)
local Router = require(ReplicatedStorage.Database.Security.Router)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local u82 = table.find(GetUserPlatform(), "Mobile")
if u82 then
    u82 = #GetUserPlatform() <= 1
end
local u83 = nil
local u84 = nil
local u85 = false
local u86 = false
local u87 = nil
local u88 = false
local u95 = table.freeze({[Enum.KeyCode.ButtonR2] = true, [Enum.KeyCode.ButtonL2] = true})
RunService:BindToRenderStep("FireAction.SameFrameFire", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 50 -- upvalues: u86 (ref), u87 (ref), u88 (ref), InventoryController (val), HintController (val)
    if not u86 then
        return
    end
    u86 = false
    local u2 = u87
    local u3 = u88
    u87 = nil
    u88 = false
    if not u2 then
        return
    end
    task.spawn(function() -- Line: 67 -- upvalues: InventoryController (upval), u2 (val), u3 (val), HintController (upval)
        local v1 = InventoryController.getCurrentEquipped()
        if v1 and v1.Identifier == u2.Identifier then
            if u3 then
                u2:fireBurst()
                return
            end
            debug.profilebegin("FireAction.Shot")
            u2:shoot()
            if u2.Rounds and u2.Rounds <= 0 then
                debug.profilebegin("FireAction.ReloadHint")
                HintController:createHint("Reload")
                debug.profileend()
            end
            debug.profileend()
            return
        end
        u2.IsBurstShooting = false
    end)
end)

local function cancelQueuedShot() -- Line: 92 -- upvalues: u83 (ref), u84 (ref)
    if u83 then
        task.cancel(u83)
        u83 = nil
        u84 = nil
    end
end

local function rejectInput(a1) -- Line: 101 -- upvalues: u85 (ref)
    if a1 == Enum.UserInputState.End then
        u85 = false
    end
end

return (table.freeze({
    Name = "Fire",
    Group = "Default",
    Category = "Weapon Keys",
    Callback = function(a1, a2) -- Line: 110
        -- upvalues: u82 (val), LocalPlayer (val), SpectateController (val), CaseSceneController (val)
        -- upvalues: BlackMarketSceneController (val), InspectController (val), u85 (ref), InventoryController (val)
        -- upvalues: CharacterResolver (val), GameState (val), Router (val), GamepadTrigger (val), u83 (ref), u84 (ref)
        -- upvalues: u86 (ref), u87 (ref), u88 (ref), RunService (val), HintController (val), u95 (val)
        if u82 and a2.UserInputType == Enum.UserInputType.MouseButton1 then
            return
        end
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return
        end
        if SpectateController.IsSpectatingNow()
            and a1 == Enum.UserInputState.Begin
            and not SpectateController.IsControllerPress(a2) then
            SpectateController.RequestSwitch(-1)
            return
        end
        if not SpectateController.IsLocalPlayerDead()
            and not CaseSceneController.IsActive()
            and not BlackMarketSceneController.IsActive()
            and not InspectController.IsActive() then
            local u38 = InventoryController.getCurrentEquipped()
            if u38 and CharacterResolver.getLocalCharacter() and GameState.GetState() ~= "Buy Period" then
                Router.broadcastRouter("Cancel Defuse Bomb")
                if a1 ~= Enum.UserInputState.Begin then
                    if a1 == Enum.UserInputState.End and u38.Properties.Class == "Weapon" then
                        if u38.Properties.ShootingOptions ~= "Revolver" then
                            u85 = false
                            u38.IsFireHeld = false
                            u38.FireInputBinding = nil
                            return
                        end
                        if GamepadTrigger.isStillPressed(a2, u95) then
                            return
                        end
                        u85 = false
                        local FireModes = u38.Properties.FireModes and u38.Properties.FireModes.Primary
                        if not FireModes or FireModes.CancelOnRelease ~= false then
                            u38:cancelRevolverCharge(false)
                            return
                        end
                        u38.IsFireHeld = false
                        u38.FireInputBinding = nil
                        return
                    end
                    if a1 == Enum.UserInputState.End and u38.Properties.Class == "C4" then
                        if GamepadTrigger.isStillPressed(a2, u95) then
                            return
                        end
                        u85 = false
                        u38:cancel()
                        return
                    end
                    if u38.Properties.Slot == "Grenade" and a1 == Enum.UserInputState.End then
                        u85 = false
                        if u38.ThrowStarted and not u38.ThrowFinished then
                            u38:Throw("Far")
                            return
                        end
                        return
                    end
                    if a1 == Enum.UserInputState.End then
                        u85 = false
                    end
                    return
                end
                local v1 = GamepadTrigger.isGamepadInput(a2)
                local Class = u38.Properties.Class
                local Slot = u38.Properties.Slot
                if v1 and u85 and Class == "Weapon" and not u38.Properties.Automatic then
                    return
                end
                if v1 then
                    u85 = true
                end
                if Class == "C4" then
                    u38:shoot()
                    return
                end
                if Slot == "Grenade" then
                    u38:StartThrow()
                    return
                end
                if Class == "Weapon" then
                    if u38.Properties.ShootingOptions == "Revolver" then
                        if u83 then
                            task.cancel(u83)
                            u83 = nil
                            u84 = nil
                        end
                        u38:startRevolverCharge((GamepadTrigger.getInputBinding(a2)))
                        return
                    end
                    u38.IsFireHeld = true
                    u38.FireInputBinding = GamepadTrigger.getInputBinding(a2)
                end
                if not u38.IsBurstShooting
                    and not u38.IsShooting
                    and u38.Properties.FireRate
                    and u38.Properties.FireRate < tick() - u38.AlternativeSwitchTick then
                    local v2
                    if u83 then
                        task.cancel(u83)
                        u83 = nil
                        u84 = nil
                    end
                    u38.IsBurstShooting = u38.AlternativeShootingOption == "Burst"
                    if u86 then
                        u38.IsBurstShooting = false
                        return
                    end
                    u86 = true
                    u87 = u38
                    u88 = v2
                    return
                end
                if not u38.Properties.Automatic
                    and u38.AlternativeShootingOption == "Default"
                    and u38.IsShooting
                    and u84 ~= u38.Identifier then
                    if u83 then
                        task.cancel(u83)
                    end
                    local NextShotDue = u38.NextShotDue
                    local v3 = if not NextShotDue then 0 else math.max(0, NextShotDue - (os.clock()))
                    if v3 <= 0.15 then
                        u84 = u38.Identifier
                        u83 = task.delay(v3, function() -- Line: 219
                            -- upvalues: RunService (upval), u83 (upval), u84 (upval), InventoryController (upval)
                            -- upvalues: u38 (val), HintController (upval)
                            RunService.Heartbeat:Wait()
                            RunService.Heartbeat:Wait()
                            u83 = nil
                            u84 = nil
                            local v1 = InventoryController.getCurrentEquipped()
                            if v1 and v1.Identifier == u38.Identifier and not v1.Properties.Automatic then
                                if v1.AlternativeShootingOption == "Burst" then
                                    return
                                end
                                if v1.Rounds <= 0 then
                                    HintController:createHint("Reload")
                                    return
                                end
                                v1:shoot()
                                return
                            end
                        end)
                        return
                    end
                end
                return
            end
            if a1 == Enum.UserInputState.End then
                u85 = false
            end
            return
        end
        if a1 == Enum.UserInputState.End then
            u85 = false
        end
    end,
}))