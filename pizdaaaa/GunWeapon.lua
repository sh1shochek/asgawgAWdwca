-- ReplicatedStorage.Shared.WeaponConstructor.Types.GunWeapon
-- Script path: ReplicatedStorage.Shared.WeaponConstructor.Types.GunWeapon
-- Decompile time: 20.98 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {
    Head = 1,
    UpperTorso = 2,
    LowerTorso = 3,
    LeftUpperArm = 4,
    LeftLowerArm = 4,
    LeftHand = 4,
    RightUpperArm = 5,
    RightLowerArm = 5,
    RightHand = 5,
    LeftUpperLeg = 6,
    LeftLowerLeg = 6,
    LeftFoot = 6,
    RightUpperLeg = 7,
    RightLowerLeg = 7,
    RightFoot = 7
};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u3 = game:GetService("RunService"):IsServer();
local u4 = game:GetService("RunService"):IsClient();
local SoundManager = require(ReplicatedStorage.Shared.Managers.SoundManager);
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local f32 = require(ReplicatedStorage.Shared.Utility.Math).f32;

local function Mul32(p16: number, p17: number) -- Line: 52
    return (p16 * (p17 // 65536) % 65536 * 65536 + p16 * (p17 % 65536)) % 4294967296;
end;

local function SpreadSeed(p18: number) -- Line: 61
    local bit32_rshift_ret = bit32.rshift(p18, 16);
    local bit32_bxor_ret = bit32.bxor(p18, bit32_rshift_ret);
    local v19 = (bit32_bxor_ret * 34283 % 65536 * 65536 + bit32_bxor_ret * 51819) % 4294967296;
    local bit32_rshift_ret2 = bit32.rshift(v19, 13);
    local bit32_bxor_ret2 = bit32.bxor(v19, bit32_rshift_ret2);
    local v20 = (bit32_bxor_ret2 * 49842 % 65536 * 65536 + bit32_bxor_ret2 * 44597) % 4294967296;
    local bit32_rshift_ret3 = bit32.rshift(v20, 16);
    local bit32_bxor_ret3 = bit32.bxor(v20, bit32_rshift_ret3);

    return bit32.band(bit32_bxor_ret3, 255) + 1;
end;

local function BurstReadyAt(p21: any, p22: any, p23: number) -- Line: 75
    -- upvalues: f32 (copy)
    local v24 = f32(p22.DelayBetweenBursts);
    local v25 = p21.LastShotTime or 0;

    for i = 1, p22.BaseBurstAmount - p23 do
        v25 = f32(v25 + v24);
        local _ = i;
    end;

    return v25;
end;

local function MarkUnappliedHit(p26: any, p27: number, p28: number) -- Line: 89
    local LastShotTelemetry = p26.LastShotTelemetry;

    if LastShotTelemetry then
        LastShotTelemetry.TargetIdentifier = p27;
        LastShotTelemetry.Rejected = true;
        LastShotTelemetry.RejectReason = p28;
    end;
end;

local function ReplicateWeaponSound(p29: any, p30: string?, p31: any) -- Line: 103
    -- upvalues: SoundManager (copy), u13 (ref)
    if p31 then
        p30 = p31;
    elseif p30 then
        p30 = SoundManager.Pack(p30);
    end;

    local v32;

    if p29 then
        v32 = p29.Simulation;
    else
        v32 = p29;
    end;

    if not (p30 and v32) then
        return;
    end;

    u13.BroadcastSound(p30, v32.Position, p29.PlayerInstance);
end;

local function FinishReload(p33) -- Line: 114
    p33.PacketDirty = true;
    p33.Reloading = false;
    p33.ShotgunShellLoaded = false;
    local AltFunctionModule = p33.AltFunctionModule;

    if AltFunctionModule and AltFunctionModule.Restore then
        AltFunctionModule.Restore(p33);
    end;
end;

local function MagazineTime(p34) -- Line: 143
    local Data = p34.Data;
    local ReloadAmmoTime = Data.ReloadAmmoTime;

    if ReloadAmmoTime then
        return ReloadAmmoTime;
    end;

    local v35 = nil;
    local Reload = Data.Reload;
    local v36 = p34.Animators and p34.Animators[Reload.Shotgun and "Reload2" or "Reload"];

    if v36 then
        local length = v36.Asset.length;

        for i, v in v36.EventNames do
            if v == "magin" or v == "magin2" then
                local v37 = v36.EventAlphas[i] * length;

                if not v35 or v37 < v35 then
                    v35 = v37;
                end;
            end;
        end;
    end;

    local v38 = v35 or Reload.Ammo or (Reload.Middle or Reload.Full);
    Data.ReloadAmmoTime = v38;

    return v38;
end;

function u1.Init(p39, p40) -- Line: 181
    -- upvalues: u6 (ref), u7 (ref), u9 (ref), u3 (copy), u8 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u5 (ref), u15 (ref), u10 (ref)
    u6 = p39:GetModule("Entities");
    u7 = p39:GetModule("Bullet");
    u9 = p39:GetModule("GameConfiguration");

    if not u3 then
        u10 = p39:GetModule("WeaponController");

        return;
    end;

    u8 = p39:GetModule("GameTracker");
    u11 = p39:GetModule("CharacterHandler");
    u12 = p39:GetModule("HitPoints");
    u13 = p39:GetModule("PlayerHandler");
    u14 = p39:GetModule("Tick");
    u5 = p39:GetModule("Network");
    u15 = p39:GetModule("Tattletale");
end;

local function ShotKind(p41) -- Line: 200
    local AltFunction = p41.Data.AltFunction;
    local v42 = p41.RecoilIndex == 0;

    if AltFunction and (AltFunction.Name == "Burst" and p41.Mode == 2) then
        return v42, "Burst";
    end;

    if v42 then
        return v42, "Tap";
    end;

    return v42, "Spray";
end;

function u1.ShotTelemetry(p43: any, p44: any, p45: number?, p46: any, p47: boolean?) -- Line: 209
    -- upvalues: u13 (ref), u14 (ref)
    local Player = u13.GetPlayer(p43.PlayerInstance);
    local Time = u14.GetTime();
    local v48 = p45 or Time;
    local AltFunction = p44.Data.AltFunction;
    local v49 = p44.RecoilIndex == 0;

    return {
        TargetIdentifier = 0,
        Hitbox = 0,
        AppliedDamage = 0,
        HealthBefore = 0,
        HealthAfter = 0,
        Rejected = false,
        RejectReason = 0,
        Lethal = false,
        SpreadSeedReplaced = p47 or false,
        RenderTime = v48,
        RewindMs = (Time - v48) * 1000,
        PingMs = Player and (Player.CurrentPing or 0) or 0,
        JitterMs = Player and Player.CurrentJitter or 0,
        FirstShot = v49,
        ShotType = AltFunction and (AltFunction.Name == "Burst" and p44.Mode == 2) and "Burst" or (v49 and "Tap" or "Spray"),
        Hit = p46 and next(p46) ~= nil and true or false
    };
end;

function u1.ApplyHits(p50, p51) -- Line: 237
    -- upvalues: u11 (ref), u2 (copy)
    if not (p51 and next(p51)) then
        return;
    end;

    local AllCharacters = u11.GetAllCharacters();

    for i, v in p51 do
        local v52 = AllCharacters[i];

        if v52 then
            local HitPoints = v52.Modifications.HitPoints;

            if HitPoints then
                local LastShotTelemetry = p50.LastShotTelemetry;
                local v53 = i;

                for _, v2 in v[1] and v and v or { v } do
                    local v54 = v52.Health or 0;
                    local v55 = {
                        Object = v2.Object,
                        Amount = v2.Damage,
                        Attacker = p50,
                        DamageType = v2.DamageType,
                        Penetration = v2.Penetration,
                        DespawnTick = true,
                        Direction = v2.Direction,
                        Position = v2.Position
                    };

                    if LastShotTelemetry then
                        if LastShotTelemetry.TargetIdentifier ~= v53 then
                            LastShotTelemetry.AppliedDamage = 0;
                            LastShotTelemetry.HealthBefore = v54;
                        end;

                        LastShotTelemetry.TargetIdentifier = v53;
                        LastShotTelemetry.Hitbox = u2[v2.Object and v2.Object.Name] or 0;
                    end;

                    local v56 = HitPoints.TakeDamage(v52, v55);

                    if LastShotTelemetry then
                        local v57 = v52.Health or v54;
                        LastShotTelemetry.HealthAfter = v57;
                        LastShotTelemetry.AppliedDamage = LastShotTelemetry.AppliedDamage + math.max(0, v54 - v57);
                        LastShotTelemetry.Rejected = LastShotTelemetry.AppliedDamage <= 0;
                        LastShotTelemetry.RejectReason = LastShotTelemetry.Rejected and (v56 or 7) or 0;
                        LastShotTelemetry.Lethal = v57 <= 0;
                    end;
                end;
            else
                local LastShotTelemetry = p50.LastShotTelemetry;

                if LastShotTelemetry then
                    LastShotTelemetry.TargetIdentifier = i;
                    LastShotTelemetry.Rejected = true;
                    LastShotTelemetry.RejectReason = 9;
                end;
            end;
        else
            local LastShotTelemetry = p50.LastShotTelemetry;

            if LastShotTelemetry then
                LastShotTelemetry.TargetIdentifier = i;
                LastShotTelemetry.Rejected = true;
                LastShotTelemetry.RejectReason = 8;
            end;
        end;
    end;
end;

function u1.Reset(p58) -- Line: 303
    p58.PacketDirty = true;
    local AltFunction = p58.Data.AltFunction;

    if AltFunction then
        AltFunction = AltFunction.Name;
    end;

    if AltFunction ~= "Silencer" then
        p58.Mode = 1;
    end;

    if AltFunction == "Burst" then
        p58.BurstFireRemaining = 0;
    elseif AltFunction == "Silencer" then
        if p58.Silencer then
            p58:StopAllAnimations();
        end;

        p58.AltFunctionModule.Clear(p58);
    elseif AltFunction == "ScopeRifle" then
        p58.SavedZoom = 0;
    elseif AltFunction == "Scope" then
        p58.ZoomLevel = 0;
        p58.SavedZoom = 0;
        p58.SniperShotActive = false;
        p58.SniperUnscopeAt = 0;
    end;

    if AltFunction == "Silencer" or AltFunction == "Scope" then
        p58.AltFunctionRun:Fire(p58);
    end;
end;

function u1.Fire(p59, p60, p61, p62, p63) -- Line: 347
    -- upvalues: u4 (copy), u10 (ref), SoundManager (copy), u13 (ref), u9 (ref), u15 (ref), u7 (ref), u3 (copy), u1 (copy), u8 (ref), f32 (copy)
    p59.PacketDirty = true;

    if p59.Reloading then
        return;
    end;

    local Data = p59.Data;

    if Data.Ammo > 0 then
        p59.RefundAvailable = false;
        p59.Firing = true;
        p59.WannaShoot = true;

        if not u9.Get("Weapon", "InfiniteAmmo") then
            Data.Ammo = Data.Ammo - 1;

            if not p61 then
                if u4 then
                    u10.OnWeaponShoot:Fire(p59);
                else
                    local v64;

                    if p60 then
                        v64 = p60.PlayerInstance;
                    else
                        v64 = p60;
                    end;

                    if v64 then
                        u15.CountShot(v64);
                    end;

                    local ClipSize = Data.ClipSize;

                    if ClipSize and Data.Ammo == math.max(1, ClipSize // 4) then
                        local v65 = SoundManager.Pack("Other.Lowammo");
                        local v66;

                        if p60 then
                            v66 = p60.Simulation;
                        else
                            v66 = p60;
                        end;

                        if v65 and v66 then
                            u13.BroadcastSound(v65, v66.Position, p60.PlayerInstance);
                        end;
                    end;
                end;
            end;
        end;

        local Mode = p59.Mode;
        local AltFunction = Data.AltFunction;
        local v67 = false;

        if AltFunction and (AltFunction.Name == "Burst" and Mode == 2) then
            if p59.BurstFireRemaining > 0 then
                p59.BurstFireRemaining = p59.BurstFireRemaining - 1;
                v67 = true;
            else
                p59.BurstFireRemaining = AltFunction.BaseBurstAmount - 1;
            end;
        end;

        local v68, v69, v70;

        if p61 then
            v68 = nil;
            v69 = nil;
            v70 = nil;
        else
            local v71;

            if AltFunction then
                if AltFunction.Name == "Silencer" then
                    v71 = p59.Mode == 2;
                else
                    v71 = false;
                end;
            else
                v71 = AltFunction;
            end;

            local WeaponFireSound, WeaponFireSound = SoundManager.GetWeaponFireSound(p59.Name, not v71);

            if WeaponFireSound then
                if u4 then
                    SoundManager.Play(WeaponFireSound, {
                        LocalReplicated = true
                    });
                else
                    if not WeaponFireSound then
                        if WeaponFireSound then
                            WeaponFireSound = SoundManager.Pack(WeaponFireSound);
                        end;
                    end;

                    local v72;

                    if p60 then
                        v72 = p60.Simulation;
                    else
                        v72 = p60;
                    end;

                    if WeaponFireSound and v72 then
                        u13.BroadcastSound(WeaponFireSound, v72.Position, p60.PlayerInstance);
                    end;
                end;
            end;

            local v73;

            if p59.Name == "Dual Berettas" then
                v73 = p59:IsPlayingFire();
            else
                v73 = false;
            end;

            if not v73 then
                p59:StopAllAnimations();
            end;

            local v74;

            if p59.Name == "Dual Berettas" then
                v74 = Data.Ammo % 2 == 0 and "Fire2" or "Fire1";
                p59.CharacterAnimation = v74;
            else
                v74 = AltFunction and (AltFunction.Name == "ScopeRifle" and p59.Mode == 2) and "FireLow" or "Fire";
            end;

            local v75 = p59:PlayAnimation(v74, true);

            if p59.Name == "Dual Berettas" and v75 then
                p59.FirePriority = (p59.FirePriority or 4) + 1;
                v75.Track.Priority = p59.FirePriority;
            end;

            local v76;
            v68, v69, v70, v76 = u7.new(p60, p59, p62, p63);

            if u3 then
                local v77 = u1.ShotTelemetry(p60, p59, p62, v70, v76);
                p60.LastShotTelemetry = v77;
                u8.OnShoot:Fire(p60, p59, v77);
            end;
        end;

        local Timer = p59.Timer;

        if not v67 then
            p59:CalculateNextAttackTime(Data.FireRate[Mode]);
            p59.LastShotTime = Timer;
        end;

        p59:Recoil(p60);
        p59.RecoilIndex = p59.RecoilIndex + 1;
        p59.AccuracyPenalty = f32(p59.AccuracyPenalty + Data.Inaccuracy.Fire[Mode]);

        return v68, v69, v70;
    end;

    if p59.BurstFireRemaining then
        p59.BurstFireRemaining = 0;
    end;

    p59.WannaShoot = true;

    if not p61 then
        if u4 then
            u10.OnWeaponEmpty:Fire(p59);

            return;
        end;

        local v78 = Data.Type == "Pistol" and "Other.ClipemptyPistol" or "Other.ClipemptyRifle";

        if v78 then
            v78 = SoundManager.Pack(v78);
        end;

        local v79;

        if p60 then
            v79 = p60.Simulation;
        else
            v79 = p60;
        end;

        if v78 then
            if not v79 then
                return;
            end;

            u13.BroadcastSound(v78, v79.Position, p60.PlayerInstance);
        end;
    end;
end;

function u1.Reload(p80, p81, p82) -- Line: 524
    -- upvalues: u3 (copy), u8 (ref), f32 (copy), MagazineTime (copy)
    p80.PacketDirty = true;

    if p80.Reloading then
        return;
    end;

    if p80.Timer <= p80.FireDelay then
        return;
    end;

    local Data = p80.Data;

    if Data.Ammo >= Data.ClipSize then
        return;
    end;

    if Data.ReserveAmmo <= 0 then
        return;
    end;

    if p80.Inspecting then
        p80:StopInspect(p81);
    end;

    if not p81 then
        p80:StopAllAnimations();
    end;

    p80.Reloading = true;
    p80.ShotgunShellLoaded = Data.Reload.Shotgun;

    if not Data.Reload.Shotgun then
        p80.RecoilIndex = p80.RecoilIndex + 1;
        p80.WannaShoot = false;
    end;

    if u3 and (not p81 and p82) then
        u8.OnWeaponReloaded:Fire(p82, p80);
    end;

    if p80.IsSniper or Data.AltFunction and Data.AltFunction.Name == "ScopeRifle" then
        p80.AltFunctionModule.Clear(p80);
    end;

    local Reload = Data.Reload;
    local Timer = p80.Timer;

    if Reload.Shotgun then
        p80.ReloadDelay = f32(Timer + Reload.Start);

        if not p81 then
            p80:PlayAnimation("Reload1");
        end;
    else
        p80.ReloadDelay = f32(Timer + Reload.Full);
        p80.AmmoDelay = f32(Timer + MagazineTime(p80));

        if not p81 then
            p80:PlayAnimation("Reload");
        end;
    end;
end;

function u1.AddReloadAmmo(p83, p84) -- Line: 596
    -- upvalues: u4 (copy), u10 (ref)
    p83.PacketDirty = true;
    local Data = p83.Data;
    local Shotgun = Data.Reload.Shotgun;

    if not (p83.Reloading and not (Shotgun and p83.ShotgunShellLoaded) and (Shotgun or not p83.AmmoClip)) then
        return;
    end;

    local math_min_ret = math.min(Shotgun and 1 or Data.ClipSize - Data.Ammo, Data.ClipSize - Data.Ammo, Data.ReserveAmmo);

    if math_min_ret <= 0 then
        return;
    end;

    Data.Ammo = Data.Ammo + math_min_ret;
    Data.ReserveAmmo = Data.ReserveAmmo - math_min_ret;

    if Shotgun then
        p83.ShotgunShellLoaded = true;
    else
        p83.RecoilIndex = 0;
        p83.AmmoClip = true;
    end;

    if u4 and not p84 then
        u10.OnWeaponReload:Fire(p83);
    end;
end;

function u1.ResumeZoom(p85) -- Line: 633
    local AltFunction = p85.Data.AltFunction;

    if p85.IsSniper and (AltFunction and (AltFunction.ClosesAfterFire and (p85.SniperShotActive and not (p85.Reloading or (p85.Data.Ammo <= 0 or p85.Timer < p85.FireDelay))))) then
        p85.AltFunctionModule.Fired(p85, false);
    end;
end;

function u1.BurstTail(p86, p87, p88, p89) -- Line: 645
    -- upvalues: f32 (copy), u1 (copy), u3 (copy)
    local AltFunction = p86.Data.AltFunction;
    local BurstFireRemaining = p86.BurstFireRemaining;

    if not (AltFunction and (AltFunction.Name == "Burst" and (BurstFireRemaining and (BurstFireRemaining > 0 and BurstFireRemaining < AltFunction.BaseBurstAmount)))) then
        return;
    end;

    local Timer = p86.Timer;
    local v90 = f32(AltFunction.DelayBetweenBursts);
    local v91 = p86.LastShotTime or 0;

    for i = 1, AltFunction.BaseBurstAmount - BurstFireRemaining do
        v91 = f32(v91 + v90);
        local _ = i;
    end;

    if Timer >= v91 then
        local Fire = u1.Fire;
        local RenderTime = p88.RenderTime;
        local RandomSeed = p86.RandomSeed;
        local bit32_rshift_ret = bit32.rshift(RandomSeed, 16);
        local bit32_bxor_ret = bit32.bxor(RandomSeed, bit32_rshift_ret);
        local v92 = (bit32_bxor_ret * 34283 % 65536 * 65536 + bit32_bxor_ret * 51819) % 4294967296;
        local bit32_rshift_ret2 = bit32.rshift(v92, 13);
        local bit32_bxor_ret2 = bit32.bxor(v92, bit32_rshift_ret2);
        local v93 = (bit32_bxor_ret2 * 49842 % 65536 * 65536 + bit32_bxor_ret2 * 44597) % 4294967296;
        local bit32_rshift_ret3 = bit32.rshift(v93, 16);
        local bit32_bxor_ret3 = bit32.bxor(v93, bit32_rshift_ret3);
        local v94, v95, v96 = Fire(p86, p87, p89, RenderTime, bit32.band(bit32_bxor_ret3, 255) + 1);

        if u3 then
            u1.ApplyHits(p87, v96);
        end;

        p86.BurstTailTimer = p86.Timer;

        return v94, v95, v96;
    end;
end;

function u1.TickCommand(p97, p98, p99, p100, p101) -- Line: 672
    -- upvalues: u1 (copy), f32 (copy), MagazineTime (copy), u3 (copy)
    local WishBooleans = p99.WishBooleans;
    local v102 = nil;
    local v103 = nil;
    local v104 = nil;
    local Data = p97.Data;
    local AltFunction = Data.AltFunction;
    local Timer = p97.Timer;
    local v105 = WishBooleans.WishFire and (Data.Automatic ~= false and true or not p97.WannaShoot);

    if WishBooleans.WishReload and p97.ReloadDelay < Timer then
        u1.Reload(p97, p100, p98);
    end;

    if p97.Reloading then
        local v106 = p97.ReloadDelay - Timer;
        local Reload = Data.Reload;

        if Reload.Shotgun then
            if v105 and Data.Ammo > 0 then
                p97.AmmoClip = false;
                p97.PacketDirty = true;
                p97.Reloading = false;
                p97.ShotgunShellLoaded = false;
                local AltFunctionModule = p97.AltFunctionModule;

                if AltFunctionModule and AltFunctionModule.Restore then
                    AltFunctionModule.Restore(p97);
                end;
            else
                if not p97.ShotgunShellLoaded and p97.AmmoDelay <= Timer then
                    u1.AddReloadAmmo(p97, p100);
                end;

                if v106 <= 0 then
                    if Data.Ammo == Data.ClipSize or Data.ReserveAmmo <= 0 then
                        if p97.AmmoClip then
                            p97.AmmoClip = false;
                            p97.PacketDirty = true;
                            p97.Reloading = false;
                            p97.ShotgunShellLoaded = false;
                            local AltFunctionModule = p97.AltFunctionModule;

                            if AltFunctionModule and AltFunctionModule.Restore then
                                AltFunctionModule.Restore(p97);
                            end;
                        else
                            p97.ReloadDelay = f32(Timer + Reload.End);
                            p97.AmmoClip = true;

                            if not p100 then
                                p97:StopAnimation("Reload2");
                                p97:PlayAnimation("Reload3");
                            end;
                        end;
                    else
                        p97.ShotgunShellLoaded = false;
                        p97.ReloadDelay = f32(Timer + Reload.Middle);
                        p97.AmmoDelay = f32(Timer + MagazineTime(p97));

                        if not p100 then
                            p97:PlayAnimation("Reload2");
                        end;
                    end;
                end;
            end;
        else
            if p97.AmmoDelay <= Timer then
                u1.AddReloadAmmo(p97, p100);
            end;

            if v106 <= 0 then
                p97.AmmoClip = false;
                p97.PacketDirty = true;
                p97.Reloading = false;
                p97.ShotgunShellLoaded = false;
                local AltFunctionModule = p97.AltFunctionModule;

                if AltFunctionModule and AltFunctionModule.Restore then
                    AltFunctionModule.Restore(p97);
                end;

                if p97.BurstFireRemaining then
                    p97.BurstFireRemaining = 0;
                end;
            end;
        end;
    end;

    local BurstFireRemaining = p97.BurstFireRemaining;
    local v107;

    if AltFunction then
        if AltFunction.Name == "Burst" and BurstFireRemaining < AltFunction.BaseBurstAmount then
            v107 = BurstFireRemaining > 0;
        else
            v107 = false;
        end;
    else
        v107 = AltFunction;
    end;

    local v108 = WishBooleans.WishFire or v107;
    local FireDelay = p97.FireDelay;

    if v107 then
        local v109 = f32(AltFunction.DelayBetweenBursts);
        FireDelay = p97.LastShotTime or 0;

        for i = 1, AltFunction.BaseBurstAmount - BurstFireRemaining do
            FireDelay = f32(FireDelay + v109);
            local _ = i;
        end;
    end;

    if v108 then
        local Automatic = Data.Automatic;

        if Automatic then
            local v110;

            if AltFunction then
                if AltFunction.Name == "Burst" then
                    v110 = p97.Mode == 2;
                else
                    v110 = false;
                end;
            else
                v110 = AltFunction;
            end;

            Automatic = not v110;
        end;

        if WishBooleans.WishFire and (p97.WannaShoot and not (v107 or Automatic and Data.Ammo > 0)) then
            v108 = false;
        end;

        if p97.WaitForNoAttack and not v107 then
            v108 = false;
        end;

        if v108 then
            if FireDelay <= Timer then
                local Fire = u1.Fire;
                local RenderTime = p99.RenderTime;
                local RandomSeed = p97.RandomSeed;
                local bit32_rshift_ret = bit32.rshift(RandomSeed, 16);
                local bit32_bxor_ret = bit32.bxor(RandomSeed, bit32_rshift_ret);
                local v111 = (bit32_bxor_ret * 34283 % 65536 * 65536 + bit32_bxor_ret * 51819) % 4294967296;
                local bit32_rshift_ret2 = bit32.rshift(v111, 13);
                local bit32_bxor_ret2 = bit32.bxor(v111, bit32_rshift_ret2);
                local v112 = (bit32_bxor_ret2 * 49842 % 65536 * 65536 + bit32_bxor_ret2 * 44597) % 4294967296;
                local bit32_rshift_ret3 = bit32.rshift(v112, 16);
                local bit32_bxor_ret3 = bit32.bxor(v112, bit32_rshift_ret3);
                v102, v103, v104 = Fire(p97, p98, p100, RenderTime, bit32.band(bit32_bxor_ret3, 255) + 1);

                if u3 then
                    u1.ApplyHits(p98, v104);
                end;
            elseif p97.Firing and p97.BurstTailTimer ~= Timer then
                p97.PacketDirty = true;
                p97.Firing = false;
            end;
        elseif p97.Firing then
            p97.PacketDirty = true;
            p97.Firing = false;
        end;
    elseif p97.Firing then
        p97.PacketDirty = true;
        p97.WannaShoot = false;
        p97.Firing = false;
    elseif p97.WannaShoot then
        p97.WannaShoot = false;
    end;

    if Data.Ammo == 0 and not (p97.Reloading or (WishBooleans.WishFire or WishBooleans.WishFire2)) then
        u1.Reload(p97, p100, p98);
    end;

    if p97.IsSniper and (not p97.Reloading and (AltFunction and AltFunction.ClosesAfterFire)) then
        p97.AltFunctionModule.Fired(p97, Timer < p97.FireDelay);
    end;

    local WishFire2 = WishBooleans.WishFire2;

    if WishFire2 then
        local v113;

        if AltFunction then
            v113 = AltFunction.Name == "Scope" and true or AltFunction.Name == "ScopeRifle";
        else
            v113 = AltFunction;
        end;

        if v113 then
            v113 = p97:GetSetting("Controls", "Keybinds", "Zoom Button Hold", "Repeat Disabled") == "Repeat Enabled";
        end;

        if v113 or not p97.AltFunctionHeld then
            p97:RunAltFunction(p100);
        end;
    end;

    p97.AltFunctionHeld = WishFire2;
    local SilencerDelay = p97.SilencerDelay;

    if p97.Silencer and (SilencerDelay and SilencerDelay ~= 0) then
        local v114 = SilencerDelay - Timer;
        local AltFunctionModule = p97.AltFunctionModule;

        if not p97.SilencerAction and v114 <= (p97.Mode == 1 and AltFunction.SilencerRemove.Remove or AltFunction.SilencerApply.Apply) then
            if p97.Mode == 1 then
                AltFunctionModule.Off(p97);
            else
                AltFunctionModule.On(p97);
            end;

            p97.SilencerAction = true;
        end;

        if v114 <= 0 then
            p97.FireDelay = Timer;
            p97.ReloadDelay = Timer;
            p97.InspectDelay = Timer;
            p97.AltFunctionDelay = Timer;
            AltFunctionModule.Clear(p97);
        end;
    end;

    return v102, v103, v104;
end;

return u1;