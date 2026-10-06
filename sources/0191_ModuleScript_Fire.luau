-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local GamepadTrigger = require(script.Parent.Parent.GamepadTrigger);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local HintController = require(ReplicatedStorage.Controllers.HintController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local u1 = table.find(GetUserPlatform(), "Mobile") and #GetUserPlatform() <= 1;
local u2 = nil;
local u3 = nil;
local u4 = false;
local u5 = false;
local u6 = nil;
local u7 = false;
local table_freeze_ret = table.freeze({
    [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL2] = true
});
RunService:BindToRenderStep("FireAction.SameFrameFire", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 50
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), InventoryController (copy), HintController (copy)
    if not u5 then
        return;
    end;

    u5 = false;
    local u8 = u6;
    local u9 = u7;
    u6 = nil;
    u7 = false;

    if not u8 then
        return;
    end;

    task.spawn(function() -- Line: 67
        -- upvalues: InventoryController (ref), u8 (copy), u9 (copy), HintController (ref)
        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if not CurrentEquipped or CurrentEquipped.Identifier ~= u8.Identifier then
            u8.IsBurstShooting = false;

            return;
        end;

        if u9 then
            u8:fireBurst();

            return;
        end;

        debug.profilebegin("FireAction.Shot");
        u8:shoot();

        if u8.Rounds and u8.Rounds <= 0 then
            debug.profilebegin("FireAction.ReloadHint");
            HintController:createHint("Reload");
            debug.profileend();
        end;

        debug.profileend();
    end);
end);

local function cancelQueuedShot() -- Line: 92
    -- upvalues: u2 (ref), u3 (ref)
    if u2 then
        task.cancel(u2);
        u2 = nil;
        u3 = nil;
    end;
end;

local function rejectInput(p10) -- Line: 101
    -- upvalues: u4 (ref)
    if p10 == Enum.UserInputState.End then
        u4 = false;
    end;
end;

return table.freeze({
    Name = "Fire",
    Group = "Default",
    Category = "Weapon Keys",

    Callback = function(p11: any, p12: userdata) -- Line: 110, Name: onInput
        -- upvalues: u1 (copy), LocalPlayer (copy), SpectateController (copy), CaseSceneController (copy), BlackMarketSceneController (copy), InspectController (copy), u4 (ref), InventoryController (copy), CharacterResolver (copy), GameState (copy), Router (copy), GamepadTrigger (copy), u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), RunService (copy), HintController (copy), table_freeze_ret (copy)
        if u1 and p12.UserInputType == Enum.UserInputType.MouseButton1 then
            return;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if SpectateController.IsSpectatingNow() and (p11 == Enum.UserInputState.Begin and not SpectateController.IsControllerPress(p12)) then
            SpectateController.RequestSwitch(-1);

            return;
        end;

        if SpectateController.IsLocalPlayerDead() or (CaseSceneController.IsActive() or (BlackMarketSceneController.IsActive() or InspectController.IsActive())) then
            if p11 == Enum.UserInputState.End then
                u4 = false;
            end;

            return;
        end;

        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if not (CurrentEquipped and (CharacterResolver.getLocalCharacter() and GameState.GetState() ~= "Buy Period")) then
            if p11 == Enum.UserInputState.End then
                u4 = false;
            end;

            return;
        end;

        Router.broadcastRouter("Cancel Defuse Bomb");

        if p11 == Enum.UserInputState.Begin then
            local v13 = GamepadTrigger.isGamepadInput(p12);
            local Class = CurrentEquipped.Properties.Class;
            local Slot = CurrentEquipped.Properties.Slot;

            if v13 and (u4 and (Class == "Weapon" and not CurrentEquipped.Properties.Automatic)) then
                return;
            end;

            if v13 then
                u4 = true;
            end;

            if Class == "C4" then
                CurrentEquipped:shoot();

                return;
            end;

            if Slot == "Grenade" then
                CurrentEquipped:StartThrow();

                return;
            end;

            if Class == "Weapon" then
                if CurrentEquipped.Properties.ShootingOptions == "Revolver" then
                    if u2 then
                        task.cancel(u2);
                        u2 = nil;
                        u3 = nil;
                    end;

                    CurrentEquipped:startRevolverCharge(GamepadTrigger.getInputBinding(p12));

                    return;
                end;

                CurrentEquipped.IsFireHeld = true;
                CurrentEquipped.FireInputBinding = GamepadTrigger.getInputBinding(p12);
            end;

            local v14 = not CurrentEquipped.IsBurstShooting and (not CurrentEquipped.IsShooting and CurrentEquipped.Properties.FireRate) and tick() - CurrentEquipped.AlternativeSwitchTick > CurrentEquipped.Properties.FireRate;

            if v14 then
                if u2 then
                    task.cancel(u2);
                    u2 = nil;
                    u3 = nil;
                end;

                local v15 = CurrentEquipped.AlternativeShootingOption == "Burst";
                CurrentEquipped.IsBurstShooting = v15;

                if u5 then
                    CurrentEquipped.IsBurstShooting = false;

                    return;
                end;

                u5 = true;
                u6 = CurrentEquipped;
                u7 = v15;

                return;
            end;

            if not (CurrentEquipped.Properties.Automatic or (CurrentEquipped.AlternativeShootingOption ~= "Default" or (not CurrentEquipped.IsShooting or u3 == CurrentEquipped.Identifier))) then
                if u2 then
                    task.cancel(u2);
                end;

                local NextShotDue = CurrentEquipped.NextShotDue;
                local v16;

                if NextShotDue then
                    local v17 = NextShotDue - os.clock();
                    v16 = math.max(0, v17);
                else
                    v16 = 0;
                end;

                if v16 <= 0.15 then
                    u3 = CurrentEquipped.Identifier;
                    u2 = task.delay(v16, function() -- Line: 219
                        -- upvalues: RunService (ref), u2 (ref), u3 (ref), InventoryController (ref), CurrentEquipped (copy), HintController (ref)
                        RunService.Heartbeat:Wait();
                        RunService.Heartbeat:Wait();
                        u2 = nil;
                        u3 = nil;
                        local CurrentEquipped2 = InventoryController.getCurrentEquipped();

                        if not (CurrentEquipped2 and (CurrentEquipped2.Identifier == CurrentEquipped.Identifier and not CurrentEquipped2.Properties.Automatic)) then
                            return;
                        end;

                        if CurrentEquipped2.AlternativeShootingOption == "Burst" then
                            return;
                        end;

                        if CurrentEquipped2.Rounds <= 0 then
                            HintController:createHint("Reload");

                            return;
                        end;

                        CurrentEquipped2:shoot();
                    end);
                end;
            end;
        else
            if p11 == Enum.UserInputState.End and CurrentEquipped.Properties.Class == "Weapon" then
                if CurrentEquipped.Properties.ShootingOptions ~= "Revolver" then
                    u4 = false;
                    CurrentEquipped.IsFireHeld = false;
                    CurrentEquipped.FireInputBinding = nil;

                    return;
                end;

                if GamepadTrigger.isStillPressed(p12, table_freeze_ret) then
                    return;
                end;

                u4 = false;
                local v18 = CurrentEquipped.Properties.FireModes and CurrentEquipped.Properties.FireModes.Primary;

                if not v18 or v18.CancelOnRelease ~= false then
                    CurrentEquipped:cancelRevolverCharge(false);

                    return;
                end;

                CurrentEquipped.IsFireHeld = false;
                CurrentEquipped.FireInputBinding = nil;

                return;
            end;

            if p11 == Enum.UserInputState.End and CurrentEquipped.Properties.Class == "C4" then
                if GamepadTrigger.isStillPressed(p12, table_freeze_ret) then
                    return;
                end;

                u4 = false;
                CurrentEquipped:cancel();

                return;
            end;

            if CurrentEquipped.Properties.Slot == "Grenade" and p11 == Enum.UserInputState.End then
                u4 = false;

                if CurrentEquipped.ThrowStarted and not CurrentEquipped.ThrowFinished then
                    CurrentEquipped:Throw("Far");
                end;
            elseif p11 == Enum.UserInputState.End then
                u4 = false;
            end;
        end;
    end
});