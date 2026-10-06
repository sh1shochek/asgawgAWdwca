-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Database.Custom.Types);
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local ReplicateCharacterAction = require(ReplicatedStorage.Components.Common.ReplicateCharacterAction);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local workspace_CurrentCamera = workspace.CurrentCamera;
local u2 = { "StartThrow", "ThrowIdle" };

local function isCompetitiveFreezeTime() -- Line: 80
    -- upvalues: GameState (copy)
    local v3;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        v3 = GameState.GetState() == "Buy Period";
    else
        v3 = false;
    end;

    return v3;
end;

local function stopPlayingTracks(p4: any, p5: boolean) -- Line: 86
    for i, v in pairs(p4.Animations) do
        if v.IsPlaying and (v.Name ~= "Idle" and (not p5 or v.Name ~= "Equip")) then
            p4:stop(i);
        end;
    end;
end;

local function isOnThrowCooldown(p6) -- Line: 94
    local v7;

    if p6.LastThrowTime > 0 then
        v7 = tick() - p6.LastThrowTime < 0.7;
    else
        v7 = false;
    end;

    return v7;
end;

function u1.stopAllAnimations(p8) -- Line: 101
    -- upvalues: stopPlayingTracks (copy)
    if not (p8.CharacterAnimator and (p8.Viewmodel and p8.Viewmodel.Animation)) then
        return;
    end;

    stopPlayingTracks(p8.CharacterAnimator, false);
    stopPlayingTracks(p8.Viewmodel.Animation, false);
end;

function u1.StartThrow(p9) -- Line: 112
    -- upvalues: GameState (copy), CharacterResolver (copy), workspace_CurrentCamera (copy), stopPlayingTracks (copy), ReplicateCharacterAction (copy)
    if not p9.IsDestroyed then
        local v10;

        if workspace:GetAttribute("ServerGamemode") == "Competitive" then
            v10 = GameState.GetState() == "Buy Period";
        else
            v10 = false;
        end;

        if not (v10 or p9.EquipTime > 0 and tick() - p9.EquipTime < 0.7) then
            local v11;

            if p9.LastThrowTime > 0 then
                v11 = tick() - p9.LastThrowTime < 0.7;
            else
                v11 = false;
            end;

            if not (v11 or p9.ThrowStarted and not p9.ThrowFinished) then
                if p9.ThrowFinished then
                    p9.ThrowFinished = false;
                    p9.ThrowStarted = false;
                    p9.Janitor:Remove("ThrowGrenadeFinished");
                    p9.Janitor:Remove("ThrowGrenadeStoppedFallback");
                end;

                local LocalCharacter = CharacterResolver.getLocalCharacter();

                if LocalCharacter and LocalCharacter:GetAttribute("Dead") then
                    return;
                end;

                p9.ThrowStarted = true;

                if not (p9.Viewmodel and (not p9.Viewmodel.IsDestroyed and p9.Viewmodel.Model)) then
                    return;
                end;

                if p9.Viewmodel.Model.Parent ~= workspace_CurrentCamera then
                    if not p9.Viewmodel.equip then
                        return;
                    end;

                    p9.Viewmodel:equip(false);
                end;

                if p9.Viewmodel.Hidden then
                    p9.Viewmodel:unhide();
                end;

                local v12;

                if p9.LastThrowTime > 0 then
                    v12 = tick() - p9.LastThrowTime < 0.7;
                else
                    v12 = false;
                end;

                if v12 then
                    p9.ThrowStarted = false;

                    return;
                end;

                if p9.Viewmodel.IsDestroyed then
                    return;
                end;

                local Equip = p9.Viewmodel.Animation.Animations.Equip;

                if Equip then
                    Equip = Equip.IsPlaying;
                end;

                if Equip then
                    stopPlayingTracks(p9.Viewmodel.Animation, true);
                    stopPlayingTracks(p9.CharacterAnimator, true);
                else
                    p9:stopAllAnimations();
                end;

                p9.CharacterAnimator:play("StartThrow");
                p9.CharacterAnimator:play("ThrowIdle");
                ReplicateCharacterAction("StartThrow");

                if p9.Viewmodel and not (p9.Viewmodel.IsDestroyed or (not p9.Viewmodel.Model or p9.Viewmodel.Model.Parent ~= workspace_CurrentCamera)) then
                    local v13 = p9.Viewmodel.Animation:play("ThrowIdle");
                    p9.Viewmodel.Animation:play("StartThrow");

                    if v13 then
                        v13.Looped = true;
                    end;
                end;
            end;
        end;
    end;
end;

function u1.Throw(u14: any, u15: string) -- Line: 189
    -- upvalues: GameState (copy), CharacterResolver (copy), workspace_CurrentCamera (copy), RunService (copy), stopPlayingTracks (copy), u2 (copy), ReplicateCharacterAction (copy), Router (copy)
    if u14.ThrowFinished then
        return;
    end;

    local v16;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        v16 = GameState.GetState() == "Buy Period";
    else
        v16 = false;
    end;

    if v16 then
        if u14.ThrowStarted and not u14.ThrowFinished then
            u14:Cancel();
        end;

        return;
    end;

    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter and LocalCharacter:GetAttribute("Dead") then
        return;
    end;

    if not (u14.Viewmodel and (not u14.Viewmodel.IsDestroyed and u14.Viewmodel.Model)) then
        u14.ThrowStarted = false;

        return;
    end;

    if u14.Viewmodel.Model.Parent ~= workspace_CurrentCamera then
        if not u14.Viewmodel.equip then
            u14.ThrowStarted = false;

            return;
        end;

        u14.Viewmodel:equip(false);
        RunService.Heartbeat:Wait();

        if u14.Viewmodel.Model.Parent ~= workspace_CurrentCamera then
            u14.ThrowStarted = false;

            return;
        end;
    end;

    if u14.Viewmodel.Hidden then
        u14.Viewmodel:unhide();
    end;

    if not u14.Viewmodel.Animation then
        u14.ThrowStarted = false;

        return;
    end;

    u14.Janitor:Remove("ThrowGrenadeFinished");
    u14.Janitor:Remove("ThrowGrenadeStoppedFallback");
    local Equip = u14.Viewmodel.Animation.Animations.Equip;

    if Equip then
        Equip = Equip.IsPlaying;
    end;

    if Equip then
        u14.Viewmodel.Animation:stop("Equip");
        u14.CharacterAnimator:stop("Equip");
        stopPlayingTracks(u14.Viewmodel.Animation, false);
        stopPlayingTracks(u14.CharacterAnimator, false);
        RunService.Heartbeat:Wait();
    else
        for _, v in { u14.Viewmodel.Animation, u14.CharacterAnimator } do
            local v17 = v;

            for _, v2 in u2 do
                if v17.Animations[v2] then
                    v17:stop(v2);
                end;
            end;
        end;
    end;

    if not (u14.Viewmodel and (not u14.Viewmodel.IsDestroyed and u14.Viewmodel.Animation)) then
        u14.ThrowStarted = false;

        return;
    end;

    local v18 = u14.Viewmodel.Animation:play(u15);

    if not v18 then
        u14.ThrowStarted = false;

        return;
    end;

    local v19 = tick();

    while v18.Length == 0 and tick() - v19 < 0.5 do
        RunService.Heartbeat:Wait();
    end;

    if u14.IsDestroyed or (not u14.Viewmodel or u14.Viewmodel.IsDestroyed) then
        u14.ThrowStarted = false;

        return;
    end;

    u14.CharacterAnimator:play("Throw");
    ReplicateCharacterAction("Throw");
    u14.ThrowCompleted = false;

    local function completeThrow() -- Line: 287
        -- upvalues: u14 (copy), Router (ref), u15 (copy)
        if u14.ThrowCompleted then
            return;
        end;

        u14.ThrowCompleted = true;

        if u14.IsDestroyed or not u14.Identifier then
            return;
        end;

        u14.ThrowFinished = true;
        u14.ThrowStarted = false;
        u14.LastThrowTime = tick();

        if Router.broadcastRouter("PredictGrenadeThrow", u14.Identifier, u15) ~= true then
            u14.ThrowFinished = false;
            u14.ThrowCompleted = false;
            warn("[Grenade] Could not queue ordered grenade transition");
        end;
    end;

    if not v18.IsPlaying then
        u14.ThrowStarted = false;

        return;
    end;

    local function fallbackThrow() -- Line: 315
        -- upvalues: u14 (copy), completeThrow (copy)
        if not (u14.ThrowCompleted or (u14.IsDestroyed or (not u14.ThrowStarted or u14.ThrowFinished))) then
            completeThrow();
        end;
    end;

    u14.Janitor:Add(v18:GetMarkerReachedSignal("Throw"):Once(completeThrow), "Disconnect", "ThrowGrenadeFinished");
    u14.Janitor:Add(v18.Stopped:Once(function() -- Line: 325
        -- upvalues: u14 (copy), completeThrow (copy)
        task.delay(0.05, function() -- Line: 326
            -- upvalues: u14 (ref), completeThrow (ref)
            if not (u14.ThrowCompleted or u14.IsDestroyed) then
                completeThrow();
            end;
        end);
    end), "Disconnect", "ThrowGrenadeStoppedFallback");

    if v18.Length > 0 then
        local task_delay_ret = task.delay(v18.Length * 0.7, fallbackThrow);
        u14.Janitor:Add(function() -- Line: 336
            -- upvalues: task_delay_ret (copy)
            task.cancel(task_delay_ret);
        end, false, "ThrowGrenadeDelayFallback2");
    end;

    local task_delay_ret = task.delay(2, fallbackThrow);
    u14.Janitor:Add(function() -- Line: 343
        -- upvalues: task_delay_ret (copy)
        task.cancel(task_delay_ret);
    end, false, "ThrowGrenadeDelayFallback3");
end;

function u1.Cancel(p20) -- Line: 350
    -- upvalues: ReplicateCharacterAction (copy)
    if p20.ThrowFinished then
        return;
    end;

    p20.Janitor:Remove("ThrowGrenadeFinished");
    p20.Janitor:Remove("ThrowGrenadeStoppedFallback");
    p20.Janitor:Remove("ThrowGrenadeDelayFallback2");
    p20.Janitor:Remove("ThrowGrenadeDelayFallback3");
    p20.ThrowFinished = false;
    p20.ThrowStarted = false;
    p20.ThrowCompleted = false;
    p20:stopAllAnimations();
    ReplicateCharacterAction("CancelThrow");
end;

function u1.inspect(u21) -- Line: 370
    -- upvalues: ReplicateCharacterAction (copy)
    if u21.IsInspecting then
        return;
    end;

    if u21.ThrowStarted and not u21.ThrowFinished then
        u21:Cancel();
    end;

    u21.IsInspecting = true;
    u21:stopAllAnimations();
    local v22 = u21.Viewmodel.Animation:play("Inspect");
    ReplicateCharacterAction("Inspect");
    task.delay(v22.Length, function() -- Line: 385
        -- upvalues: u21 (copy)
        u21.IsInspecting = false;
    end);
end;

function u1.reload(p23) -- Line: 392
end;

function u1.drop(p24) -- Line: 396
    -- upvalues: GameState (copy), Remotes (copy), GetCharacterVelocity (copy), CharacterResolver (copy), workspace_CurrentCamera (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" or (GameState.GetState() == "Warmup" or not p24.Properties.Droppable) then
        return false;
    end;

    p24:unequip();
    Remotes.Inventory.DropWeapon.Send({
        CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
        Direction = workspace_CurrentCamera.CFrame.LookVector,
        Identifier = p24.Identifier
    });

    return true;
end;

function u1.equip(u25) -- Line: 416
    -- upvalues: GameState (copy), InputController (copy)
    u25.EquipTime = tick();
    u25.Janitor:Remove("EquipDelayThrow");
    u25.Viewmodel.Animation:stopAnimations();
    u25.CharacterAnimator:stopAnimations();
    u25.ThrowStarted = false;
    u25.ThrowFinished = false;
    u25.ThrowCompleted = false;
    u25.CharacterAnimator:play("Idle");
    u25.CharacterAnimator:play("Equip");
    u25.Viewmodel:equip(false);
    local task_delay_ret = task.delay(0.7, function() -- Line: 428
        -- upvalues: u25 (copy), GameState (ref), InputController (ref)
        if u25.IsDestroyed then
            return;
        end;

        if GameState.GetState() == "Buy Period" then
            return;
        end;

        if InputController.isActionPressed("Fire", { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 }) then
            u25:StartThrow();
        end;
    end);
    u25.Janitor:Add(function() -- Line: 440
        -- upvalues: task_delay_ret (copy)
        task.cancel(task_delay_ret);
    end, false, "EquipDelayThrow");
end;

function u1.unequip(p26) -- Line: 445
    p26.Janitor:Remove("EquipDelayThrow");
    p26.CharacterAnimator:stopAnimations();
    p26.Viewmodel:unequip();
    p26.IsInspecting = false;

    if p26.ThrowStarted and not p26.ThrowFinished then
        p26:Cancel();
    end;
end;

function u1.new(p27: userdata, p28: string, p29: string, p30: number, p31: string, p32: string, p33: number, p34: any, p35: any, p36: string?, p37: any, p38: table, p39: table) -- Line: 458
    -- upvalues: WeaponComponent (copy), u1 (copy)
    local v40 = WeaponComponent.new(p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38);
    local v41 = setmetatable(v40, u1);
    v41.IsInspecting = false;
    v41.ThrowStarted = false;
    v41.ThrowFinished = false;
    v41.ThrowCompleted = false;
    v41.LastThrowTime = 0;
    v41.EquipTime = 0;

    return v41;
end;

function u1.destroy(p42) -- Line: 490
    -- upvalues: WeaponComponent (copy)
    if p42.IsDestroyed then
        return;
    end;

    p42.IsDestroyed = true;

    if p42.Janitor then
        p42.Janitor:Destroy();
        p42.Janitor = nil;
    end;

    p42.ThrowFinished = nil;
    p42.ThrowStarted = nil;
    p42.ThrowCompleted = nil;
    p42.IsInspecting = nil;
    WeaponComponent.destroy(p42);
end;

return u1;