-- ReplicatedStorage.Controllers.InputController.Actions.SecondaryFire
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.SecondaryFire
-- Decompile time: 1.73 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script.Parent.Parent.Types)
local GamepadTrigger = require(script.Parent.Parent.GamepadTrigger)
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
local InspectController = require(ReplicatedStorage.Controllers.InspectController)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local u52 = table.freeze({[Enum.KeyCode.ButtonL2] = true})
local u53 = false
return (table.freeze({
    Name = "Secondary Fire",
    Group = "Default",
    Category = "Weapon Keys",
    Callback = function(a1, a2) -- Line: 33
        -- upvalues: SpectateController (val), CaseSceneController (val), BlackMarketSceneController (val)
        -- upvalues: InspectController (val), u53 (ref), InventoryController (val), CharacterResolver (val)
        -- upvalues: GameState (val), GamepadTrigger (val), u52 (val)
        if SpectateController.IsSpectatingNow()
            and a1 == Enum.UserInputState.Begin
            and not SpectateController.IsControllerPress(a2) then
            SpectateController.RequestSwitch(1)
            return
        end
        if not SpectateController.IsLocalPlayerDead()
            and not CaseSceneController.IsActive()
            and not BlackMarketSceneController.IsActive()
            and not InspectController.IsActive() then
            local v1 = InventoryController.getCurrentEquipped()
            if CharacterResolver.getLocalCharacter() and v1 then
                if v1.Properties.Slot == "Grenade" and GameState.GetState() == "Buy Period" then
                    return
                end
                if a1 ~= Enum.UserInputState.Begin then
                    if v1.Properties.ShootingOptions == "Revolver" and a1 == Enum.UserInputState.End then
                        if GamepadTrigger.isStillPressed(a2, u52) then
                            return
                        end
                        u53 = false
                        v1:stopRevolverSecondaryFire()
                        return
                    end
                    local v2 = if not v1.Properties.HasScope then a1 else a1
                    if v1.Properties.Slot == "Grenade" and v2 == Enum.UserInputState.End then
                        u53 = false
                        if GameState.GetState() == "Buy Period" then
                            return
                        end
                        if v1.ThrowStarted and not v1.ThrowFinished then
                            v1:Throw("Near")
                            return
                        end
                        return
                    end
                    if v2 == Enum.UserInputState.End then
                        u53 = false
                    end
                    return
                end
                if v1.Properties.ShootingOptions == "Revolver" then
                    local v3 = GamepadTrigger.isTrigger(a2, u52)
                    if v3 and u53 then
                        return
                    end
                    if v3 then
                        u53 = true
                    end
                    v1:startRevolverSecondaryFire((GamepadTrigger.getInputBinding(a2)))
                    return
                end
                if v1.Properties.Class == "Grenade" then
                    if GameState.GetState() == "Buy Period" then
                        return
                    end
                    v1:StartThrow()
                    return
                end
                if v1.Properties.HasScope then
                    v1:scope(true)
                    return
                end
                if v1.Properties.HasSuppressor then
                    if v1.IsSuppressed then
                        v1:removeSuppressor()
                        return
                    end
                    v1:addSuppressor()
                    return
                end
                if v1.Properties.ShootingOptions == "Burst" then
                    v1:updateFireMode()
                    return
                end
                if v1.Properties.Type == "Equipment" and GameState.GetState() ~= "Buy Period" then
                    v1:shoot(true)
                    return
                end
                return
            end
            return
        end
        if a1 == Enum.UserInputState.End then
            u53 = false
        end
    end,
}))