-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
local GamepadTrigger = require(script.Parent.Parent.GamepadTrigger);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local table_freeze_ret = table.freeze({
    [Enum.KeyCode.ButtonL2] = true
});
local u1 = false;

return table.freeze({
    Name = "Secondary Fire",
    Group = "Default",
    Category = "Weapon Keys",

    Callback = function(p2: any, p3: userdata) -- Line: 33, Name: onInput
        -- upvalues: SpectateController (copy), CaseSceneController (copy), BlackMarketSceneController (copy), InspectController (copy), u1 (ref), InventoryController (copy), CharacterResolver (copy), GameState (copy), GamepadTrigger (copy), table_freeze_ret (copy)
        if SpectateController.IsSpectatingNow() and (p2 == Enum.UserInputState.Begin and not SpectateController.IsControllerPress(p3)) then
            SpectateController.RequestSwitch(1);

            return;
        end;

        if SpectateController.IsLocalPlayerDead() or (CaseSceneController.IsActive() or (BlackMarketSceneController.IsActive() or InspectController.IsActive())) then
            if p2 == Enum.UserInputState.End then
                u1 = false;
            end;

            return;
        end;

        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if not (CharacterResolver.getLocalCharacter() and CurrentEquipped) then
            return;
        end;

        if CurrentEquipped.Properties.Slot == "Grenade" and GameState.GetState() == "Buy Period" then
            return;
        end;

        if p2 == Enum.UserInputState.Begin then
            if CurrentEquipped.Properties.ShootingOptions == "Revolver" then
                local v4 = GamepadTrigger.isTrigger(p3, table_freeze_ret);

                if v4 and u1 then
                    return;
                end;

                if v4 then
                    u1 = true;
                end;

                CurrentEquipped:startRevolverSecondaryFire(GamepadTrigger.getInputBinding(p3));

                return;
            end;

            if CurrentEquipped.Properties.Class == "Grenade" then
                if GameState.GetState() ~= "Buy Period" then
                    CurrentEquipped:StartThrow();
                end;
            else
                if CurrentEquipped.Properties.HasScope then
                    CurrentEquipped:scope(true);

                    return;
                end;

                if CurrentEquipped.Properties.HasSuppressor then
                    if CurrentEquipped.IsSuppressed then
                        CurrentEquipped:removeSuppressor();

                        return;
                    end;

                    CurrentEquipped:addSuppressor();

                    return;
                end;

                if CurrentEquipped.Properties.ShootingOptions == "Burst" then
                    CurrentEquipped:updateFireMode();

                    return;
                end;

                if CurrentEquipped.Properties.Type == "Equipment" and GameState.GetState() ~= "Buy Period" then
                    CurrentEquipped:shoot(true);
                end;
            end;
        else
            if CurrentEquipped.Properties.ShootingOptions == "Revolver" and p2 == Enum.UserInputState.End then
                if GamepadTrigger.isStillPressed(p3, table_freeze_ret) then
                    return;
                end;

                u1 = false;
                CurrentEquipped:stopRevolverSecondaryFire();

                return;
            end;

            local _ = CurrentEquipped.Properties.HasScope;

            if CurrentEquipped.Properties.Slot == "Grenade" and p2 == Enum.UserInputState.End then
                u1 = false;

                if GameState.GetState() == "Buy Period" then
                    return;
                end;

                if CurrentEquipped.ThrowStarted and not CurrentEquipped.ThrowFinished then
                    CurrentEquipped:Throw("Near");
                end;
            elseif p2 == Enum.UserInputState.End then
                u1 = false;
            end;
        end;
    end
});