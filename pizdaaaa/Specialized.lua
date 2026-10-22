-- ReplicatedStorage.Shared.Utility.BufferScheme.Specialized
-- Script path: ReplicatedStorage.Shared.Utility.BufferScheme.Specialized
-- Decompile time: 33.42 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};
u1.CharacterState = {
    Booleans = { "HasWalkMovedSinceLastJump", "Defusing", "DoJump", "WasGround", "IsWalking", "Climbing", "DuckFlag", "Ducking", "HasDefuseKit", "Ducked", "AirFrictionReduced", "OnGround", "HasHelmet", "LastDuck", "StepDownFrameSkip", "Planting", "SkipMovementPhysics", "WannaJump" },
    Fields = {
        { "Pitch", "u16", false },
        { "HitPoints", "u16", false },
        { "Velocity", "vector", false },
        { "LadderNormal", "vector", false },
        { "StepUp", "float32", false },
        { "LastFullCrouchPosition", "vector", false },
        { "AimPunchAngle", "vector", false },
        { "DuckAmount", "float32", false },
        { "CurrentFrame", "u8", false },
        { "FallingVelocity", "float32", false },
        { "DuckSpeed", "float32", false },
        { "PerfectBhopChain", "u8", false },
        { "Speed", "float32", false },
        { "FlinchStack", "float32", false },
        { "IgnoreLadderJumpTime", "u16", false },
        { "AimPunchAngleVel", "vector", false },
        { "ViewPunchAngle", "vector", false },
        { "CameraOffset", "u8", false },
        { "PendingVelocityModifier", "float32", false },
        { "ArmorValue", "u8", false },
        { "DefuseTimer", "float32", false },
        { "PendingVelocityModifierTicks", "u8", false },
        { "VelocityModifier", "float32", false },
        { "Height", "u16", false },
        { "Yaw", "u16", false },
        { "Position", "vector", false },
        { "Stamina", "float32", false },
        { "DuckCooldown", "float32", false }
    }
};

function u2.CharacterState(p3) -- Line: 40
    local float32 = p3.float32;
    local u16 = p3.u16;
    local u8 = p3.u8;
    local vector = p3.vector;

    return function(p4, p5, p6, p7) -- Line: 45, Name: Full
        -- upvalues: u16 (copy), vector (copy), float32 (copy), u8 (copy)
        local v8 = p7 + 4;
        local v9 = 0;
        local Pitch = p6.Pitch;

        if Pitch ~= nil then
            v9 = bit32.bor(v9, 1);
            v8 = u16(p5, v8, Pitch);
        end;

        local HitPoints = p6.HitPoints;

        if HitPoints ~= nil then
            v9 = bit32.bor(v9, 2);
            v8 = u16(p5, v8, HitPoints);
        end;

        local Velocity = p6.Velocity;

        if Velocity ~= nil then
            v9 = bit32.bor(v9, 4);
            v8 = vector(p5, v8, Velocity);
        end;

        local LadderNormal = p6.LadderNormal;

        if LadderNormal ~= nil then
            v9 = bit32.bor(v9, 8);
            v8 = vector(p5, v8, LadderNormal);
        end;

        local StepUp = p6.StepUp;

        if StepUp ~= nil then
            v9 = bit32.bor(v9, 16);
            v8 = float32(p5, v8, StepUp);
        end;

        local LastFullCrouchPosition = p6.LastFullCrouchPosition;

        if LastFullCrouchPosition ~= nil then
            v9 = bit32.bor(v9, 32);
            v8 = vector(p5, v8, LastFullCrouchPosition);
        end;

        local AimPunchAngle = p6.AimPunchAngle;

        if AimPunchAngle ~= nil then
            v9 = bit32.bor(v9, 64);
            v8 = vector(p5, v8, AimPunchAngle);
        end;

        local DuckAmount = p6.DuckAmount;

        if DuckAmount ~= nil then
            v9 = bit32.bor(v9, 128);
            v8 = float32(p5, v8, DuckAmount);
        end;

        buffer.writeu8(p5, p7 + 0, v9);
        local v10 = 0;
        local CurrentFrame = p6.CurrentFrame;

        if CurrentFrame ~= nil then
            v10 = bit32.bor(v10, 1);
            v8 = u8(p5, v8, CurrentFrame);
        end;

        local FallingVelocity = p6.FallingVelocity;

        if FallingVelocity ~= nil then
            v10 = bit32.bor(v10, 2);
            v8 = float32(p5, v8, FallingVelocity);
        end;

        local DuckSpeed = p6.DuckSpeed;

        if DuckSpeed ~= nil then
            v10 = bit32.bor(v10, 4);
            v8 = float32(p5, v8, DuckSpeed);
        end;

        local PerfectBhopChain = p6.PerfectBhopChain;

        if PerfectBhopChain ~= nil then
            v10 = bit32.bor(v10, 8);
            v8 = u8(p5, v8, PerfectBhopChain);
        end;

        local Speed = p6.Speed;

        if Speed ~= nil then
            v10 = bit32.bor(v10, 16);
            v8 = float32(p5, v8, Speed);
        end;

        local FlinchStack = p6.FlinchStack;

        if FlinchStack ~= nil then
            v10 = bit32.bor(v10, 32);
            v8 = float32(p5, v8, FlinchStack);
        end;

        local IgnoreLadderJumpTime = p6.IgnoreLadderJumpTime;

        if IgnoreLadderJumpTime ~= nil then
            v10 = bit32.bor(v10, 64);
            v8 = u16(p5, v8, IgnoreLadderJumpTime);
        end;

        local AimPunchAngleVel = p6.AimPunchAngleVel;

        if AimPunchAngleVel ~= nil then
            v10 = bit32.bor(v10, 128);
            v8 = vector(p5, v8, AimPunchAngleVel);
        end;

        buffer.writeu8(p5, p7 + 1, v10);
        local v11 = 0;
        local ViewPunchAngle = p6.ViewPunchAngle;

        if ViewPunchAngle ~= nil then
            v11 = bit32.bor(v11, 1);
            v8 = vector(p5, v8, ViewPunchAngle);
        end;

        local CameraOffset = p6.CameraOffset;

        if CameraOffset ~= nil then
            v11 = bit32.bor(v11, 2);
            v8 = u8(p5, v8, CameraOffset);
        end;

        local PendingVelocityModifier = p6.PendingVelocityModifier;

        if PendingVelocityModifier ~= nil then
            v11 = bit32.bor(v11, 4);
            v8 = float32(p5, v8, PendingVelocityModifier);
        end;

        local ArmorValue = p6.ArmorValue;

        if ArmorValue ~= nil then
            v11 = bit32.bor(v11, 8);
            v8 = u8(p5, v8, ArmorValue);
        end;

        local DefuseTimer = p6.DefuseTimer;

        if DefuseTimer ~= nil then
            v11 = bit32.bor(v11, 16);
            v8 = float32(p5, v8, DefuseTimer);
        end;

        local PendingVelocityModifierTicks = p6.PendingVelocityModifierTicks;

        if PendingVelocityModifierTicks ~= nil then
            v11 = bit32.bor(v11, 32);
            v8 = u8(p5, v8, PendingVelocityModifierTicks);
        end;

        local VelocityModifier = p6.VelocityModifier;

        if VelocityModifier ~= nil then
            v11 = bit32.bor(v11, 64);
            v8 = float32(p5, v8, VelocityModifier);
        end;

        local Height = p6.Height;

        if Height ~= nil then
            v11 = bit32.bor(v11, 128);
            v8 = u16(p5, v8, Height);
        end;

        buffer.writeu8(p5, p7 + 2, v11);
        local v12 = 0;
        local Yaw = p6.Yaw;

        if Yaw ~= nil then
            v12 = bit32.bor(v12, 1);
            v8 = u16(p5, v8, Yaw);
        end;

        local Position = p6.Position;

        if Position ~= nil then
            v12 = bit32.bor(v12, 2);
            v8 = vector(p5, v8, Position);
        end;

        local Stamina = p6.Stamina;

        if Stamina ~= nil then
            v12 = bit32.bor(v12, 4);
            v8 = float32(p5, v8, Stamina);
        end;

        local DuckCooldown = p6.DuckCooldown;

        if DuckCooldown ~= nil then
            v12 = bit32.bor(v12, 8);
            v8 = float32(p5, v8, DuckCooldown);
        end;

        buffer.writeu8(p5, p7 + 3, v12);

        return v8;
    end, function(p13, p14, p15, p16, p17) -- Line: 262, Name: Delta
        -- upvalues: u16 (copy), vector (copy), float32 (copy), u8 (copy)
        local v18 = p17 + 4;
        local v19 = 0;
        local Pitch = p16.Pitch;
        local v20;

        if Pitch == nil or p15.Pitch == Pitch then
            v20 = false;
        else
            v19 = bit32.bor(v19, 1);
            v18 = u16(p14, v18, Pitch);
            v20 = true;
        end;

        local HitPoints = p16.HitPoints;

        if HitPoints ~= nil and p15.HitPoints ~= HitPoints then
            v19 = bit32.bor(v19, 2);
            v18 = u16(p14, v18, HitPoints);
            v20 = true;
        end;

        local Velocity = p16.Velocity;

        if Velocity ~= nil and p15.Velocity ~= Velocity then
            v19 = bit32.bor(v19, 4);
            v18 = vector(p14, v18, Velocity);
            v20 = true;
        end;

        local LadderNormal = p16.LadderNormal;

        if LadderNormal ~= nil and p15.LadderNormal ~= LadderNormal then
            v19 = bit32.bor(v19, 8);
            v18 = vector(p14, v18, LadderNormal);
            v20 = true;
        end;

        local StepUp = p16.StepUp;

        if StepUp ~= nil and p15.StepUp ~= StepUp then
            v19 = bit32.bor(v19, 16);
            v18 = float32(p14, v18, StepUp);
            v20 = true;
        end;

        local LastFullCrouchPosition = p16.LastFullCrouchPosition;

        if LastFullCrouchPosition ~= nil and p15.LastFullCrouchPosition ~= LastFullCrouchPosition then
            v19 = bit32.bor(v19, 32);
            v18 = vector(p14, v18, LastFullCrouchPosition);
            v20 = true;
        end;

        local AimPunchAngle = p16.AimPunchAngle;

        if AimPunchAngle ~= nil and p15.AimPunchAngle ~= AimPunchAngle then
            v19 = bit32.bor(v19, 64);
            v18 = vector(p14, v18, AimPunchAngle);
            v20 = true;
        end;

        local DuckAmount = p16.DuckAmount;

        if DuckAmount ~= nil and p15.DuckAmount ~= DuckAmount then
            v19 = bit32.bor(v19, 128);
            v18 = float32(p14, v18, DuckAmount);
            v20 = true;
        end;

        buffer.writeu8(p14, p17 + 0, v19);
        local v21 = 0;
        local CurrentFrame = p16.CurrentFrame;

        if CurrentFrame ~= nil and p15.CurrentFrame ~= CurrentFrame then
            v21 = bit32.bor(v21, 1);
            v18 = u8(p14, v18, CurrentFrame);
            v20 = true;
        end;

        local FallingVelocity = p16.FallingVelocity;

        if FallingVelocity ~= nil and p15.FallingVelocity ~= FallingVelocity then
            v21 = bit32.bor(v21, 2);
            v18 = float32(p14, v18, FallingVelocity);
            v20 = true;
        end;

        local DuckSpeed = p16.DuckSpeed;

        if DuckSpeed ~= nil and p15.DuckSpeed ~= DuckSpeed then
            v21 = bit32.bor(v21, 4);
            v18 = float32(p14, v18, DuckSpeed);
            v20 = true;
        end;

        local PerfectBhopChain = p16.PerfectBhopChain;

        if PerfectBhopChain ~= nil and p15.PerfectBhopChain ~= PerfectBhopChain then
            v21 = bit32.bor(v21, 8);
            v18 = u8(p14, v18, PerfectBhopChain);
            v20 = true;
        end;

        local Speed = p16.Speed;

        if Speed ~= nil and p15.Speed ~= Speed then
            v21 = bit32.bor(v21, 16);
            v18 = float32(p14, v18, Speed);
            v20 = true;
        end;

        local FlinchStack = p16.FlinchStack;

        if FlinchStack ~= nil and p15.FlinchStack ~= FlinchStack then
            v21 = bit32.bor(v21, 32);
            v18 = float32(p14, v18, FlinchStack);
            v20 = true;
        end;

        local IgnoreLadderJumpTime = p16.IgnoreLadderJumpTime;

        if IgnoreLadderJumpTime ~= nil and p15.IgnoreLadderJumpTime ~= IgnoreLadderJumpTime then
            v21 = bit32.bor(v21, 64);
            v18 = u16(p14, v18, IgnoreLadderJumpTime);
            v20 = true;
        end;

        local AimPunchAngleVel = p16.AimPunchAngleVel;

        if AimPunchAngleVel ~= nil and p15.AimPunchAngleVel ~= AimPunchAngleVel then
            v21 = bit32.bor(v21, 128);
            v18 = vector(p14, v18, AimPunchAngleVel);
            v20 = true;
        end;

        buffer.writeu8(p14, p17 + 1, v21);
        local v22 = 0;
        local ViewPunchAngle = p16.ViewPunchAngle;

        if ViewPunchAngle ~= nil and p15.ViewPunchAngle ~= ViewPunchAngle then
            v22 = bit32.bor(v22, 1);
            v18 = vector(p14, v18, ViewPunchAngle);
            v20 = true;
        end;

        local CameraOffset = p16.CameraOffset;

        if CameraOffset ~= nil and p15.CameraOffset ~= CameraOffset then
            v22 = bit32.bor(v22, 2);
            v18 = u8(p14, v18, CameraOffset);
            v20 = true;
        end;

        local PendingVelocityModifier = p16.PendingVelocityModifier;

        if PendingVelocityModifier ~= nil and p15.PendingVelocityModifier ~= PendingVelocityModifier then
            v22 = bit32.bor(v22, 4);
            v18 = float32(p14, v18, PendingVelocityModifier);
            v20 = true;
        end;

        local ArmorValue = p16.ArmorValue;

        if ArmorValue ~= nil and p15.ArmorValue ~= ArmorValue then
            v22 = bit32.bor(v22, 8);
            v18 = u8(p14, v18, ArmorValue);
            v20 = true;
        end;

        local DefuseTimer = p16.DefuseTimer;

        if DefuseTimer ~= nil and p15.DefuseTimer ~= DefuseTimer then
            v22 = bit32.bor(v22, 16);
            v18 = float32(p14, v18, DefuseTimer);
            v20 = true;
        end;

        local PendingVelocityModifierTicks = p16.PendingVelocityModifierTicks;

        if PendingVelocityModifierTicks ~= nil and p15.PendingVelocityModifierTicks ~= PendingVelocityModifierTicks then
            v22 = bit32.bor(v22, 32);
            v18 = u8(p14, v18, PendingVelocityModifierTicks);
            v20 = true;
        end;

        local VelocityModifier = p16.VelocityModifier;

        if VelocityModifier ~= nil and p15.VelocityModifier ~= VelocityModifier then
            v22 = bit32.bor(v22, 64);
            v18 = float32(p14, v18, VelocityModifier);
            v20 = true;
        end;

        local Height = p16.Height;

        if Height ~= nil and p15.Height ~= Height then
            v22 = bit32.bor(v22, 128);
            v18 = u16(p14, v18, Height);
            v20 = true;
        end;

        buffer.writeu8(p14, p17 + 2, v22);
        local v23 = 0;
        local Yaw = p16.Yaw;

        if Yaw ~= nil and p15.Yaw ~= Yaw then
            v23 = bit32.bor(v23, 1);
            v18 = u16(p14, v18, Yaw);
            v20 = true;
        end;

        local Position = p16.Position;

        if Position ~= nil and p15.Position ~= Position then
            v23 = bit32.bor(v23, 2);
            v18 = vector(p14, v18, Position);
            v20 = true;
        end;

        local Stamina = p16.Stamina;

        if Stamina ~= nil and p15.Stamina ~= Stamina then
            v23 = bit32.bor(v23, 4);
            v18 = float32(p14, v18, Stamina);
            v20 = true;
        end;

        local DuckCooldown = p16.DuckCooldown;

        if DuckCooldown ~= nil and p15.DuckCooldown ~= DuckCooldown then
            v23 = bit32.bor(v23, 8);
            v18 = float32(p14, v18, DuckCooldown);
            v20 = true;
        end;

        buffer.writeu8(p14, p17 + 3, v23);

        return v18, v20;
    end;
end;

u1.WeaponState = {
    Booleans = { "Reloading", "AmmoClip", "Equipping", "Silencer", "WannaShoot", "ShotgunShellLoaded", "WaitForNoAttack", "SilencerAction", "Firing", "SniperShotActive", "Inspecting" },
    Fields = { { "FireDelay", "float32", false }, { "Ammo", "u8", false }, { "Mode", "u8", false }, { "LastShotTime", "float32", false }, { "Slot", "u8", false }, { "ReserveAmmo", "u8", false }, { "RandomSeed", "u16", false }, { "RecoilIndex", "float32", false }, { "NameEnum", "u8", false }, { "BurstFireRemaining", "u8", false }, { "SniperUnscopeAt", "float32", false }, { "AccuracyPenalty", "float32", false }, { "NextPlant", "float32", false }, { "EquipDelay", "float32", false }, { "ZoomLevel", "u8", false }, { "AltFunctionDelay", "float32", false }, { "InspectDelay", "float32", false }, { "AmmoDelay", "float32", false }, { "ReloadDelay", "float32", false }, { "Timer", "float32", false }, { "SavedZoom", "u8", false }, { "SilencerDelay", "float32", false } }
};

function u2.WeaponState(p24) -- Line: 566
    local float32 = p24.float32;
    local u16 = p24.u16;
    local u8 = p24.u8;

    return function(p25, p26, p27, p28) -- Line: 570, Name: Full
        -- upvalues: float32 (copy), u8 (copy), u16 (copy)
        local v29 = p28 + 3;
        local v30 = 0;
        local FireDelay = p27.FireDelay;

        if FireDelay ~= nil then
            v30 = bit32.bor(v30, 1);
            v29 = float32(p26, v29, FireDelay);
        end;

        local Ammo = p27.Ammo;

        if Ammo ~= nil then
            v30 = bit32.bor(v30, 2);
            v29 = u8(p26, v29, Ammo);
        end;

        local Mode = p27.Mode;

        if Mode ~= nil then
            v30 = bit32.bor(v30, 4);
            v29 = u8(p26, v29, Mode);
        end;

        local LastShotTime = p27.LastShotTime;

        if LastShotTime ~= nil then
            v30 = bit32.bor(v30, 8);
            v29 = float32(p26, v29, LastShotTime);
        end;

        local Slot = p27.Slot;

        if Slot ~= nil then
            v30 = bit32.bor(v30, 16);
            v29 = u8(p26, v29, Slot);
        end;

        local ReserveAmmo = p27.ReserveAmmo;

        if ReserveAmmo ~= nil then
            v30 = bit32.bor(v30, 32);
            v29 = u8(p26, v29, ReserveAmmo);
        end;

        local RandomSeed = p27.RandomSeed;

        if RandomSeed ~= nil then
            v30 = bit32.bor(v30, 64);
            v29 = u16(p26, v29, RandomSeed);
        end;

        local RecoilIndex = p27.RecoilIndex;

        if RecoilIndex ~= nil then
            v30 = bit32.bor(v30, 128);
            v29 = float32(p26, v29, RecoilIndex);
        end;

        buffer.writeu8(p26, p28 + 0, v30);
        local v31 = 0;
        local NameEnum = p27.NameEnum;

        if NameEnum ~= nil then
            v31 = bit32.bor(v31, 1);
            v29 = u8(p26, v29, NameEnum);
        end;

        local BurstFireRemaining = p27.BurstFireRemaining;

        if BurstFireRemaining ~= nil then
            v31 = bit32.bor(v31, 2);
            v29 = u8(p26, v29, BurstFireRemaining);
        end;

        local SniperUnscopeAt = p27.SniperUnscopeAt;

        if SniperUnscopeAt ~= nil then
            v31 = bit32.bor(v31, 4);
            v29 = float32(p26, v29, SniperUnscopeAt);
        end;

        local AccuracyPenalty = p27.AccuracyPenalty;

        if AccuracyPenalty ~= nil then
            v31 = bit32.bor(v31, 8);
            v29 = float32(p26, v29, AccuracyPenalty);
        end;

        local NextPlant = p27.NextPlant;

        if NextPlant ~= nil then
            v31 = bit32.bor(v31, 16);
            v29 = float32(p26, v29, NextPlant);
        end;

        local EquipDelay = p27.EquipDelay;

        if EquipDelay ~= nil then
            v31 = bit32.bor(v31, 32);
            v29 = float32(p26, v29, EquipDelay);
        end;

        local ZoomLevel = p27.ZoomLevel;

        if ZoomLevel ~= nil then
            v31 = bit32.bor(v31, 64);
            v29 = u8(p26, v29, ZoomLevel);
        end;

        local AltFunctionDelay = p27.AltFunctionDelay;

        if AltFunctionDelay ~= nil then
            v31 = bit32.bor(v31, 128);
            v29 = float32(p26, v29, AltFunctionDelay);
        end;

        buffer.writeu8(p26, p28 + 1, v31);
        local v32 = 0;
        local InspectDelay = p27.InspectDelay;

        if InspectDelay ~= nil then
            v32 = bit32.bor(v32, 1);
            v29 = float32(p26, v29, InspectDelay);
        end;

        local AmmoDelay = p27.AmmoDelay;

        if AmmoDelay ~= nil then
            v32 = bit32.bor(v32, 2);
            v29 = float32(p26, v29, AmmoDelay);
        end;

        local ReloadDelay = p27.ReloadDelay;

        if ReloadDelay ~= nil then
            v32 = bit32.bor(v32, 4);
            v29 = float32(p26, v29, ReloadDelay);
        end;

        local Timer = p27.Timer;

        if Timer ~= nil then
            v32 = bit32.bor(v32, 8);
            v29 = float32(p26, v29, Timer);
        end;

        local SavedZoom = p27.SavedZoom;

        if SavedZoom ~= nil then
            v32 = bit32.bor(v32, 16);
            v29 = u8(p26, v29, SavedZoom);
        end;

        local SilencerDelay = p27.SilencerDelay;

        if SilencerDelay ~= nil then
            v32 = bit32.bor(v32, 32);
            v29 = float32(p26, v29, SilencerDelay);
        end;

        buffer.writeu8(p26, p28 + 2, v32);

        return v29;
    end, function(p33, p34, p35, p36, p37) -- Line: 741, Name: Delta
        -- upvalues: float32 (copy), u8 (copy), u16 (copy)
        local v38 = p37 + 3;
        local v39 = 0;
        local FireDelay = p36.FireDelay;
        local v40;

        if FireDelay == nil or p35.FireDelay == FireDelay then
            v40 = false;
        else
            v39 = bit32.bor(v39, 1);
            v38 = float32(p34, v38, FireDelay);
            v40 = true;
        end;

        local Ammo = p36.Ammo;

        if Ammo ~= nil and p35.Ammo ~= Ammo then
            v39 = bit32.bor(v39, 2);
            v38 = u8(p34, v38, Ammo);
            v40 = true;
        end;

        local Mode = p36.Mode;

        if Mode ~= nil and p35.Mode ~= Mode then
            v39 = bit32.bor(v39, 4);
            v38 = u8(p34, v38, Mode);
            v40 = true;
        end;

        local LastShotTime = p36.LastShotTime;

        if LastShotTime ~= nil and p35.LastShotTime ~= LastShotTime then
            v39 = bit32.bor(v39, 8);
            v38 = float32(p34, v38, LastShotTime);
            v40 = true;
        end;

        local Slot = p36.Slot;

        if Slot ~= nil and p35.Slot ~= Slot then
            v39 = bit32.bor(v39, 16);
            v38 = u8(p34, v38, Slot);
            v40 = true;
        end;

        local ReserveAmmo = p36.ReserveAmmo;

        if ReserveAmmo ~= nil and p35.ReserveAmmo ~= ReserveAmmo then
            v39 = bit32.bor(v39, 32);
            v38 = u8(p34, v38, ReserveAmmo);
            v40 = true;
        end;

        local RandomSeed = p36.RandomSeed;

        if RandomSeed ~= nil and p35.RandomSeed ~= RandomSeed then
            v39 = bit32.bor(v39, 64);
            v38 = u16(p34, v38, RandomSeed);
            v40 = true;
        end;

        local RecoilIndex = p36.RecoilIndex;

        if RecoilIndex ~= nil and p35.RecoilIndex ~= RecoilIndex then
            v39 = bit32.bor(v39, 128);
            v38 = float32(p34, v38, RecoilIndex);
            v40 = true;
        end;

        buffer.writeu8(p34, p37 + 0, v39);
        local v41 = 0;
        local NameEnum = p36.NameEnum;

        if NameEnum ~= nil and p35.NameEnum ~= NameEnum then
            v41 = bit32.bor(v41, 1);
            v38 = u8(p34, v38, NameEnum);
            v40 = true;
        end;

        local BurstFireRemaining = p36.BurstFireRemaining;

        if BurstFireRemaining ~= nil and p35.BurstFireRemaining ~= BurstFireRemaining then
            v41 = bit32.bor(v41, 2);
            v38 = u8(p34, v38, BurstFireRemaining);
            v40 = true;
        end;

        local SniperUnscopeAt = p36.SniperUnscopeAt;

        if SniperUnscopeAt ~= nil and p35.SniperUnscopeAt ~= SniperUnscopeAt then
            v41 = bit32.bor(v41, 4);
            v38 = float32(p34, v38, SniperUnscopeAt);
            v40 = true;
        end;

        local AccuracyPenalty = p36.AccuracyPenalty;

        if AccuracyPenalty ~= nil and p35.AccuracyPenalty ~= AccuracyPenalty then
            v41 = bit32.bor(v41, 8);
            v38 = float32(p34, v38, AccuracyPenalty);
            v40 = true;
        end;

        local NextPlant = p36.NextPlant;

        if NextPlant ~= nil and p35.NextPlant ~= NextPlant then
            v41 = bit32.bor(v41, 16);
            v38 = float32(p34, v38, NextPlant);
            v40 = true;
        end;

        local EquipDelay = p36.EquipDelay;

        if EquipDelay ~= nil and p35.EquipDelay ~= EquipDelay then
            v41 = bit32.bor(v41, 32);
            v38 = float32(p34, v38, EquipDelay);
            v40 = true;
        end;

        local ZoomLevel = p36.ZoomLevel;

        if ZoomLevel ~= nil and p35.ZoomLevel ~= ZoomLevel then
            v41 = bit32.bor(v41, 64);
            v38 = u8(p34, v38, ZoomLevel);
            v40 = true;
        end;

        local AltFunctionDelay = p36.AltFunctionDelay;

        if AltFunctionDelay ~= nil and p35.AltFunctionDelay ~= AltFunctionDelay then
            v41 = bit32.bor(v41, 128);
            v38 = float32(p34, v38, AltFunctionDelay);
            v40 = true;
        end;

        buffer.writeu8(p34, p37 + 1, v41);
        local v42 = 0;
        local InspectDelay = p36.InspectDelay;

        if InspectDelay ~= nil and p35.InspectDelay ~= InspectDelay then
            v42 = bit32.bor(v42, 1);
            v38 = float32(p34, v38, InspectDelay);
            v40 = true;
        end;

        local AmmoDelay = p36.AmmoDelay;

        if AmmoDelay ~= nil and p35.AmmoDelay ~= AmmoDelay then
            v42 = bit32.bor(v42, 2);
            v38 = float32(p34, v38, AmmoDelay);
            v40 = true;
        end;

        local ReloadDelay = p36.ReloadDelay;

        if ReloadDelay ~= nil and p35.ReloadDelay ~= ReloadDelay then
            v42 = bit32.bor(v42, 4);
            v38 = float32(p34, v38, ReloadDelay);
            v40 = true;
        end;

        local Timer = p36.Timer;

        if Timer ~= nil and p35.Timer ~= Timer then
            v42 = bit32.bor(v42, 8);
            v38 = float32(p34, v38, Timer);
            v40 = true;
        end;

        local SavedZoom = p36.SavedZoom;

        if SavedZoom ~= nil and p35.SavedZoom ~= SavedZoom then
            v42 = bit32.bor(v42, 16);
            v38 = u8(p34, v38, SavedZoom);
            v40 = true;
        end;

        local SilencerDelay = p36.SilencerDelay;

        if SilencerDelay ~= nil and p35.SilencerDelay ~= SilencerDelay then
            v42 = bit32.bor(v42, 32);
            v38 = float32(p34, v38, SilencerDelay);
            v40 = true;
        end;

        buffer.writeu8(p34, p37 + 2, v42);

        return v38, v40;
    end;
end;

u1.EntityCharacter = {
    Booleans = { "OnGround", "Climbing", "Ducking", "Ducked" },
    Fields = { { "Pitch", "angle16", false }, { "NoInterpParity", "u8", false }, { "BodyYaw", "angle16", false }, { "DisplayOffset", "fixed16_128", true }, { "LadderNormal", "half3", false }, { "Health", "u16", false }, { "Position", "vector", false }, { "LegDuck", "unorm8", false }, { "AnimationAlpha", "float32", false }, { "AimPunchAngle", "half3", false }, { "Yaw", "angle16", false } }
};

function u2.EntityCharacter(p43) -- Line: 976
    local angle16 = p43.angle16;
    local fixed16_128 = p43.fixed16_128;
    local float32 = p43.float32;
    local half3 = p43.half3;
    local u16 = p43.u16;
    local u8 = p43.u8;
    local unorm8 = p43.unorm8;
    local vector = p43.vector;

    return function(p44, p45, p46, p47) -- Line: 985, Name: Full
        -- upvalues: angle16 (copy), u8 (copy), fixed16_128 (copy), half3 (copy), u16 (copy), vector (copy), unorm8 (copy), float32 (copy)
        local v48 = p47 + 2;
        local v49 = 0;
        local Pitch = p46.Pitch;

        if Pitch ~= nil then
            v49 = bit32.bor(v49, 1);
            v48 = angle16(p45, v48, Pitch);
        end;

        local NoInterpParity = p46.NoInterpParity;

        if NoInterpParity ~= nil then
            v49 = bit32.bor(v49, 2);
            v48 = u8(p45, v48, NoInterpParity);
        end;

        local BodyYaw = p46.BodyYaw;

        if BodyYaw ~= nil then
            v49 = bit32.bor(v49, 4);
            v48 = angle16(p45, v48, BodyYaw);
        end;

        local DisplayOffset = p46.DisplayOffset;

        if DisplayOffset ~= nil then
            v49 = bit32.bor(v49, 8);
            v48 = fixed16_128(p45, v48, DisplayOffset);
        end;

        local LadderNormal = p46.LadderNormal;

        if LadderNormal ~= nil then
            v49 = bit32.bor(v49, 16);
            v48 = half3(p45, v48, LadderNormal);
        end;

        local Health = p46.Health;

        if Health ~= nil then
            v49 = bit32.bor(v49, 32);
            v48 = u16(p45, v48, Health);
        end;

        local Position = p46.Position;

        if Position ~= nil then
            v49 = bit32.bor(v49, 64);
            v48 = vector(p45, v48, Position);
        end;

        local LegDuck = p46.LegDuck;

        if LegDuck ~= nil then
            v49 = bit32.bor(v49, 128);
            v48 = unorm8(p45, v48, LegDuck);
        end;

        buffer.writeu8(p45, p47 + 0, v49);
        local v50 = 0;
        local AnimationAlpha = p46.AnimationAlpha;

        if AnimationAlpha ~= nil then
            v50 = bit32.bor(v50, 1);
            v48 = float32(p45, v48, AnimationAlpha);
        end;

        local AimPunchAngle = p46.AimPunchAngle;

        if AimPunchAngle ~= nil then
            v50 = bit32.bor(v50, 2);
            v48 = half3(p45, v48, AimPunchAngle);
        end;

        local Yaw = p46.Yaw;

        if Yaw ~= nil then
            v50 = bit32.bor(v50, 4);
            v48 = angle16(p45, v48, Yaw);
        end;

        buffer.writeu8(p45, p47 + 1, v50);

        return v48;
    end, function(p51, p52, p53, p54, p55) -- Line: 1075, Name: Delta
        -- upvalues: angle16 (copy), u8 (copy), fixed16_128 (copy), half3 (copy), u16 (copy), vector (copy), unorm8 (copy), float32 (copy)
        local v56 = p55 + 2;
        local v57 = 0;
        local Pitch = p54.Pitch;
        local v58;

        if Pitch == nil or p53.Pitch == Pitch then
            v58 = false;
        else
            v57 = bit32.bor(v57, 1);
            v56 = angle16(p52, v56, Pitch);
            v58 = true;
        end;

        local NoInterpParity = p54.NoInterpParity;

        if NoInterpParity ~= nil and p53.NoInterpParity ~= NoInterpParity then
            v57 = bit32.bor(v57, 2);
            v56 = u8(p52, v56, NoInterpParity);
            v58 = true;
        end;

        local BodyYaw = p54.BodyYaw;

        if BodyYaw ~= nil and p53.BodyYaw ~= BodyYaw then
            v57 = bit32.bor(v57, 4);
            v56 = angle16(p52, v56, BodyYaw);
            v58 = true;
        end;

        local DisplayOffset = p54.DisplayOffset;
        local DisplayOffset2 = p53.DisplayOffset;

        if DisplayOffset ~= nil and DisplayOffset2 ~= DisplayOffset then
            v58 = DisplayOffset2 == nil and true or v58;
            v57 = bit32.bor(v57, 8);
            v56 = fixed16_128(p52, v56, DisplayOffset);
        end;

        local LadderNormal = p54.LadderNormal;

        if LadderNormal ~= nil and p53.LadderNormal ~= LadderNormal then
            v57 = bit32.bor(v57, 16);
            v56 = half3(p52, v56, LadderNormal);
            v58 = true;
        end;

        local Health = p54.Health;

        if Health ~= nil and p53.Health ~= Health then
            v57 = bit32.bor(v57, 32);
            v56 = u16(p52, v56, Health);
            v58 = true;
        end;

        local Position = p54.Position;

        if Position ~= nil and p53.Position ~= Position then
            v57 = bit32.bor(v57, 64);
            v56 = vector(p52, v56, Position);
            v58 = true;
        end;

        local LegDuck = p54.LegDuck;

        if LegDuck ~= nil and p53.LegDuck ~= LegDuck then
            v57 = bit32.bor(v57, 128);
            v56 = unorm8(p52, v56, LegDuck);
            v58 = true;
        end;

        buffer.writeu8(p52, p55 + 0, v57);
        local v59 = 0;
        local AnimationAlpha = p54.AnimationAlpha;

        if AnimationAlpha ~= nil and p53.AnimationAlpha ~= AnimationAlpha then
            v59 = bit32.bor(v59, 1);
            v56 = float32(p52, v56, AnimationAlpha);
            v58 = true;
        end;

        local AimPunchAngle = p54.AimPunchAngle;

        if AimPunchAngle ~= nil and p53.AimPunchAngle ~= AimPunchAngle then
            v59 = bit32.bor(v59, 2);
            v56 = half3(p52, v56, AimPunchAngle);
            v58 = true;
        end;

        local Yaw = p54.Yaw;

        if Yaw ~= nil and p53.Yaw ~= Yaw then
            v59 = bit32.bor(v59, 4);
            v56 = angle16(p52, v56, Yaw);
            v58 = true;
        end;

        buffer.writeu8(p52, p55 + 1, v59);

        return v56, v58;
    end;
end;

return {
    Bind = function(p60, p61, p62) -- Line: 1192, Name: Bind
        -- upvalues: u1 (copy), u2 (copy)
        local v63 = u1[p60];

        if not (v63 and (#p61.BooleanKeys == #v63.Booleans and #p61.Enums == #v63.Fields)) then
            return nil;
        end;

        for i, v in v63.Booleans do
            if p61.BooleanKeys[i] ~= v or p61.Scheme[v] ~= "boolean" then
                return nil;
            end;
        end;

        for i, v in v63.Fields do
            local v64 = v[1];

            if p61.Enums[i] ~= v64 or p61.Scheme[v64] ~= v[2] then
                return nil;
            end;

            if (p61.Untracked and p61.Untracked[v64] and true or false) ~= v[3] then
                return nil;
            end;
        end;

        return u2[p60](p62);
    end
};