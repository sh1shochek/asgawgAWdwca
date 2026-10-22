-- ReplicatedStorage.Shared.WeaponConstructor
-- Script path: ReplicatedStorage.Shared.WeaponConstructor
-- Decompile time: 25.64 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
u1.AnimationEventNames = table.freeze({ "equip", "screwon", "screwoff", "screw1", "screw2", "screw3", "slidestart", "slidefinish", "magout", "magin", "magin2", "maghit", "magdrop", "open", "press", "press1", "press2", "press3", "press4", "press5", "press6", "press7", "press8", "press9", "press10", "press11", "toggle" });
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local f32 = require(ReplicatedStorage.Shared.Utility.Math).f32;
local TemplateOverrides = require(ReplicatedStorage.Shared.TemplateOverrides);
local u2 = {};
local u3 = RunService:IsServer();
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
local u4 = nil;
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
local u16 = nil;
local u17 = {};

local function RefreshConfig() -- Line: 73
    -- upvalues: u17 (copy), u6 (ref)
    u17.Recoil = u6.Get("Weapon", "Recoil");
    u17.Spread = u6.Get("Weapon", "Spread");
    u17.SpreadScale = u6.Get("Weapon", "SpreadScale") or 1;
    u17.NonIdleSpreadScale = u6.Get("Weapon", "NonIdleSpreadScale") or 1;
    u17.AirRecoveryTimeScale = u6.Get("Weapon", "AirRecoveryTimeScale");
    u17.AirInaccuracyScale = u6.Get("Weapon", "AirInaccuracyScale");
    u17.AirAccuracyPenaltyScale = u6.Get("Weapon", "AirAccuracyPenaltyScale");
    u17.MovementThreshold = u6.Get("Weapon", "MovementThreshold");
    u17.MovementCurveExponent = u6.Get("Weapon", "MovementCurveExponent");
    u17.JumpSpeedThreshold = u6.Get("Weapon", "JumpSpeedThreshold");
    u17.InaccuracyMaxFallingPenalty = u6.Get("Weapon", "InaccuracyMaxFallingPenalty");
    u17.RecoilDecayBase = u6.Get("Weapon", "RecoilDecayBase");
    u17.RecoilDecayThreshold = u6.Get("Weapon", "RecoilDecayThreshold") / u6.Get("Game", "TickRate");
    u17.RecoilDecayCoefficient = u6.Get("Weapon", "RecoilDecayCoefficient");
    u17.TickInterval = 1 / u6.Get("Game", "TickRate");
end;

function u1.CalculateNextAttackTime(p18: table, p19: number) -- Line: 117
    -- upvalues: u17 (copy), f32 (copy)
    local Timer = p18.Timer;
    local FireDelay = p18.FireDelay;
    local v20 = Timer - FireDelay;

    if v20 >= 0 and u17.TickInterval >= v20 then
        Timer = FireDelay;
    end;

    p18.FireDelay = f32(Timer + f32(p19));

    return Timer;
end;

function u1.new(p21: string, p22: number, p23: string, p24: string, p25: string, p26: number, p27: number, p28: number, p29: boolean?, p30: string?, p31: number?, p32: table?) -- Line: 135
    -- upvalues: u4 (ref), u1 (copy), TemplateOverrides (copy), u8 (ref), u2 (copy), u10 (ref), u15 (ref), u16 (ref), u14 (ref)
    local v33 = u4.Get(p21);
    local v34 = setmetatable({}, u1);
    v34.PacketDirty = true;
    v34.Name = p21;
    v34.Owner = p23 or "tair2000gg";
    v34.Slot = p22;
    v34.Skin = p24 or "Stock";
    v34.SkinID = p25 or "111-111-111-111";
    v34.NameTag = p30;
    v34.KillTrack = p31;
    v34.KillTrackColor = p32;
    local table_clone_ret = table.clone(v33.Data);
    v34.Data = table_clone_ret;
    TemplateOverrides.ApplyWeapon(p21, table_clone_ret);
    table_clone_ret.Ammo = p26 or table_clone_ret.Ammo;
    table_clone_ret.ReserveAmmo = p27 or table_clone_ret.ReserveAmmo;
    v34.RefundAvailable = p29 ~= false;
    v34.Equipping = false;
    v34.Reloading = false;
    v34.AmmoClip = false;
    v34.ShotgunShellLoaded = false;
    v34.Firing = false;
    v34.WannaShoot = false;
    v34.Inspecting = false;
    v34.WaitForNoAttack = false;
    v34.FireDelay = 0;
    v34.LastShotTime = 0;
    v34.EquipDelay = 0;
    v34.ReloadDelay = 0;
    v34.AmmoDelay = 0;
    v34.InspectDelay = 0;
    v34.RecoilIndex = 0;
    v34.RandomSeed = 0;
    v34.AccuracyPenalty = 0;
    v34.Timer = 0;
    v34.Mode = p28 or 1;
    v34.AltFunctionHeld = false;
    local AltFunction = table_clone_ret.AltFunction;

    if AltFunction then
        local Name = AltFunction.Name;
        v34.AltFunctionRun = u8.new();
        v34.AltFunctionModule = u2[Name];
        v34.AltFunctionDelay = 0;

        if Name == "Burst" then
            v34.BurstFireRemaining = 0;
        elseif Name == "Silencer" then
            v34.Silencer = false;
            v34.SilencerAction = false;
            v34.SilencerDelay = 0;
        elseif Name == "ScopeRifle" then
            v34.SavedZoom = 0;
        elseif Name == "Scope" then
            v34.ZoomLevel = 0;
            v34.SavedZoom = 0;
            v34.SniperShotActive = false;
            v34.SniperUnscopeAt = 0;
            v34.IsSniper = AltFunction.Type == "Sniper";
        end;
    end;

    local Type = table_clone_ret.Type;

    if Type == "Bomb" then
        v34.NextPlant = 0;
    end;

    v34.NameEnum = u10.WeaponsNum[p21];

    if Type == "Melee" then
        v34.ZoomLevel = 0;
        v34.Behavior = u15;

        return v34;
    end;

    if Type == "Bomb" then
        v34.Behavior = u16;

        return v34;
    end;

    v34.Behavior = u14;

    return v34;
end;

function u1.GetSetting(p35: table, p36: string, p37: string, p38: string, p39: any) -- Line: 285
    local v40 = p35.SettingAccessor and p35.SettingAccessor(p36, p37, p38);

    return v40 == nil and p39 and p39 or v40;
end;

function u1.IsScoped(p41) -- Line: 302
    if (p41.ZoomLevel or 0) > 0 then
        return true;
    end;

    local v42;

    if p41.SniperShotActive == true then
        v42 = (p41.SavedZoom or 0) > 0;
    else
        v42 = false;
    end;

    return v42;
end;

local function InspectLength(p43) -- Line: 323
    -- upvalues: u12 (ref)
    local v44 = p43.Animators and p43.Animators[u12.PickVariant(p43.Animators, "Inspect", p43.RandomSeed)];
    local v45 = v44 and v44.Asset and v44.Asset.length;

    if not (v45 and (v45 > 0 and v45)) then
        v45 = p43.Data.InspectDelay;
    end;

    return v45;
end;

function u1.Inspect(p46, p47) -- Line: 330
    -- upvalues: f32 (copy), u12 (ref)
    if p46.Equipping or (p46.Firing or (p46.Inspecting or (p46.Reloading or p46.Timer <= p46.FireDelay))) then
        return;
    end;

    if p46.ZoomLevel and p46.ZoomLevel > 0 or (p46.SavedZoom and p46.SavedZoom > 0 or p46.Silencer) then
        return;
    end;

    p46.Inspecting = true;
    local Timer = p46.Timer;
    local v48 = p46.Animators and p46.Animators[u12.PickVariant(p46.Animators, "Inspect", p46.RandomSeed)];
    local v49 = v48 and v48.Asset and v48.Asset.length;

    if not (v49 and (v49 > 0 and v49)) then
        v49 = p46.Data.InspectDelay;
    end;

    p46.InspectDelay = f32(Timer + v49);

    if p47 then
        return;
    end;

    local v50 = p46.Animators and p46.Animators[u12.CurrentVariant(p46, "Inspect")];

    if v50 and (v50.Playing and v50.Direction < 0) then
        p46:ReverseAnimation("Inspect");

        return;
    end;

    p46:StopAllAnimations("Inspect");
    p46:PlayAnimation("Inspect", true);
end;

function u1.StopInspect(p51: table, p52: any, p53: boolean?) -- Line: 373
    if not p51.Inspecting then
        return;
    end;

    p51.Inspecting = false;
    p51.InspectDelay = p51.Timer;

    if p52 then
        return;
    end;

    if p53 then
        p51:StopAnimation("Inspect");

        return;
    end;

    p51:ReverseAnimation("Inspect");
end;

function u1.RunAltFunction(p54: table, p55: boolean?) -- Line: 390
    -- upvalues: f32 (copy)
    p54.PacketDirty = true;
    local AltFunction = p54.Data.AltFunction;

    if not AltFunction then
        return;
    end;

    if p54.Equipping or (p54.Reloading or p54.Firing) then
        return;
    end;

    if p54.Silencer then
        return;
    end;

    local Timer = p54.Timer;

    if Timer < p54.AltFunctionDelay then
        return;
    end;

    if AltFunction.Name == "Silencer" and (p54.Mode == 1 and not p54:GetSetting("Game", "Gameplay", "Detach Silencer on M4A1-S and USP-S", false)) then
        p54.AltFunctionDelay = f32(Timer + AltFunction.DelayBetweenSwitch);

        if not p55 and p54.SettingBlocked then
            p54.SettingBlocked("Removal of the silencer is disabled.\nEnable it in settings");
        end;

        return;
    end;

    p54.AltFunctionDelay = f32(Timer + AltFunction.DelayBetweenSwitch);

    if AltFunction.Name == "Silencer" and not p55 then
        p54:StopAllAnimations();
    end;

    p54.AltFunctionModule.Run(p54, p55);
    local v56;

    if p54.ZoomLevel and p54.ZoomLevel > 0 then
        v56 = true;
    elseif AltFunction.Name == "ScopeRifle" then
        v56 = p54.Mode == 2;
    else
        v56 = false;
    end;

    if v56 then
        p54.AccuracyPenalty = f32(p54.AccuracyPenalty + (p54.Data.Inaccuracy.AltSwitch or 0));
    end;
end;

function u1.WriteState(p57, p58) -- Line: 443
    local Data = p57.Data;
    local v59 = p58 or {};
    v59.NameEnum = p57.NameEnum;
    v59.Slot = p57.Slot;
    v59.Timer = p57.Timer;
    v59.AccuracyPenalty = p57.AccuracyPenalty;
    v59.RandomSeed = p57.RandomSeed;
    v59.RecoilIndex = p57.RecoilIndex;
    v59.Ammo = Data.Ammo;
    v59.ReserveAmmo = Data.ReserveAmmo;
    v59.Equipping = p57.Equipping;
    v59.Reloading = p57.Reloading;
    v59.AmmoClip = p57.AmmoClip;
    v59.ShotgunShellLoaded = p57.ShotgunShellLoaded;
    v59.Firing = p57.Firing;
    v59.WannaShoot = p57.WannaShoot;
    v59.Inspecting = p57.Inspecting;
    v59.WaitForNoAttack = p57.WaitForNoAttack;
    v59.EquipDelay = p57.EquipDelay;
    v59.ReloadDelay = p57.ReloadDelay;
    v59.AmmoDelay = p57.AmmoDelay;
    v59.FireDelay = p57.FireDelay;
    v59.LastShotTime = p57.LastShotTime;
    v59.InspectDelay = p57.InspectDelay;
    v59.Mode = p57.Mode;
    v59.AltFunctionDelay = p57.AltFunctionDelay;
    v59.BurstFireRemaining = p57.BurstFireRemaining;
    v59.Silencer = p57.Silencer;
    v59.SilencerAction = p57.SilencerAction;
    v59.SilencerDelay = p57.SilencerDelay;
    v59.ZoomLevel = p57.ZoomLevel;
    v59.SavedZoom = p57.SavedZoom;
    v59.SniperShotActive = p57.SniperShotActive;
    v59.SniperUnscopeAt = p57.SniperUnscopeAt;
    v59.NextPlant = p57.NextPlant;

    return v59;
end;

function u1.ReadState(p60, p61) -- Line: 512
    local Data = p60.Data;

    for i, v in p61 do
        if i == "Ammo" or i == "ReserveAmmo" then
            Data[i] = v;
        else
            p60[i] = v;
        end;
    end;

    p60.PacketDirty = true;
end;

function u1.GetNextSlot(p62: any, p63: number) -- Line: 531
    local v64 = nil;

    for i in p62 do
        if i ~= p63 and (not v64 or i < v64) then
            v64 = i;
        end;
    end;

    return v64;
end;

u1.BUY_ACK = 128;
u1.EQUIP_ACK = 64;
u1.RESET_ACK = 32;

function u1.ResetRound(p65: any, p66: any, p67: boolean) -- Line: 569
    -- upvalues: u3 (copy), u11 (ref), u1 (copy)
    for _, v in p66 do
        v.Resimulating = p67;
        v:Reset();
    end;

    local Simulation = p65.Simulation;
    Simulation.PreparationStartCommand = Simulation.CommandCount;
    local RoundSpawn = p65.RoundSpawn;

    if RoundSpawn then
        Simulation.Position = RoundSpawn;
        Simulation.Velocity = Vector3.new(0, 0, 0);
        Simulation.FallingVelocity = 0;

        if u3 then
            u11.MarkTeleported("Character", p65.Identifier);
        end;
    end;

    u1.GiveFreeEquipment(Simulation, u3 and p65.PlayerInstance or nil);
end;

function u1.GiveFreeEquipment(p68: any, p69: userdata?) -- Line: 606
    -- upvalues: u5 (ref), GameStats (copy)
    local v70 = u5.Get(GameStats:GetAttribute("Gamemode"));

    if v70 and v70.FreeArmor then
        p68:SetArmorValue(p69, 100);
        p68:SetHasHelmet(p69, true);
    end;

    if v70 and v70.FreeDefuseKit then
        p68:SetDefuseKit(p69, p68.Team == "CT");
    end;
end;

function u1.ProcessCommand(p71: any, p72: any, p73: any, p74: any, p75: boolean, p76: any) -- Line: 619
    -- upvalues: u1 (copy), f32 (copy), u14 (ref)
    local WishBooleans = p74.WishBooleans;
    local WishEquip = p74.WishEquip;
    local ResetAck = p74.ResetAck;

    if WishEquip then
        local v77 = WishEquip % u1.EQUIP_ACK;
        ResetAck = ResetAck or u1.RESET_ACK <= v77;
        WishEquip = v77 % u1.RESET_ACK;
    end;

    local v78 = (WishBooleans.WishFire or WishBooleans.WishFire2) and true or false;
    local v79;

    if p71 then
        v79 = p71.Simulation;
    else
        v79 = p71;
    end;

    local v80 = p74.SkippedTicks or 0;
    p74.SkippedTicks = nil;
    local v81 = p71.WeaponTimer or 0;

    for i = 1, v80 do
        v81 = f32(v81 + p76);
        local _ = i;
    end;

    local v82 = f32(v81 + p76);
    p71.WeaponTimer = v82;
    local v83 = v79.CommandCount + 1 + v80;
    v79.CommandCount = v83;
    local v84 = v83 % 65536;
    local v85 = p73[WishEquip];

    if v85 and v85 ~= p72 then
        v85.PacketDirty = true;
        v85:Equip(p71, p75);
        v85.EquipDelay = f32(v85.Timer + v85.Data.EquipDelay);
        v85.Equipping = true;
        v85.WaitForNoAttack = true;
        v85.RecoilIndex = 0;
        v85.AccuracyPenalty = 0;
        v85.ReloadDelay = 0;
        v85.InspectDelay = 0;
        v79.Planting = false;
        v85.Planting = false;

        for i, _ in WishBooleans do
            WishBooleans[i] = false;
        end;
    else
        v85 = p72;
    end;

    if v85 then
        for _, v in p73 do
            v.Timer = v82;
            v.RandomSeed = v84;
        end;

        if v85 then
            v85.Timer = v82;
            v85.RandomSeed = v84;
        end;

        if ResetAck then
            u1.ResetRound(p71, p73, p75);
        end;

        local Timer = v85.Timer;
        v85.Resimulating = p75;

        if v79 and (v79.Preparation and (WishBooleans.WishFire or (WishBooleans.WishReload or WishBooleans.WishFire2))) then
            local v86 = v85.Data and v85.Data.Type == "Melee";

            for i in WishBooleans do
                if i ~= "WishInspect" then
                    if i ~= "WishDrop" then
                        if i ~= "WishFire2" or v86 then
                            WishBooleans[i] = false;
                        end;
                    end;
                end;
            end;
        end;

        local v87;

        if WishBooleans.WishDrop then
            v87 = v85:Drop(p71, true, p75);

            if v87 then
                v87.PacketDirty = true;
                v87:Equip(p71, p75);
                v87.EquipDelay = f32(v87.Timer + v87.Data.EquipDelay);
                v87.Equipping = true;
                v87.WaitForNoAttack = true;
                v87.RecoilIndex = 0;
                v87.AccuracyPenalty = 0;
                v87.ReloadDelay = 0;
                v87.InspectDelay = 0;
                v79.Planting = false;

                for i, _ in WishBooleans do
                    WishBooleans[i] = false;
                end;
            else
                v87 = v85;
            end;
        else
            v87 = v85;
        end;

        local Data = v87.Data;

        if not v78 then
            v87.WaitForNoAttack = false;
        end;

        if v87 and p71 then
            v79.CurrentWeapon = v87;
            v79.Constants.Speed = Data.Speed[v87.Mode];
        end;

        local v88 = nil;
        local v89 = nil;
        local v90 = nil;
        local Behavior = v87.Behavior;
        local v91 = nil;
        local v92 = nil;
        local v93 = nil;

        if Behavior and not v87.Equipping then
            if Behavior.ResumeZoom then
                Behavior.ResumeZoom(v87);
            end;

            if Behavior.BurstTail then
                v91, v92, v93 = Behavior.BurstTail(v87, p71, p74, p75);
            end;
        end;

        for i = 1, v80 do
            v87:UpdateAccuracyPenalty(p71, p76);
            local _ = i;
        end;

        v87:UpdateAccuracyPenalty(p71, p76);

        if v87.Equipping and v87.EquipDelay <= Timer then
            if v87.BurstFireRemaining then
                v87.BurstFireRemaining = 0;
            end;

            v87.FireDelay = math.max(Timer, v87.FireDelay);
            v87.ReloadDelay = Timer;
            v87.InspectDelay = Timer;
            v87.AltFunctionDelay = Timer;
            v87.Inspecting = false;
            v87.Equipping = false;
            local Behavior2 = v87.Behavior;

            if Data.Ammo == 0 and Behavior2.Reload then
                Behavior2.Reload(v87, p75, p71);
            end;
        end;

        if not v87.Equipping then
            local v94 = WishBooleans.WishFire and (Data.Automatic ~= false and true or not v87.WannaShoot);

            if WishBooleans.WishFire and not v94 then
                v87.PacketDirty = true;
                v87.Firing = false;
            end;

            if v87.Inspecting then
                if v94 then
                    v94 = v87.Behavior ~= u14 and true or Data.Ammo > 0;
                end;

                if WishBooleans.WishReload and (v87.Behavior == u14 and Data.Ammo < Data.ClipSize) then
                    local _ = Data.ReserveAmmo > 0;
                end;

                local v95 = WishBooleans.WishFire2 and (Data.AltFunction ~= nil and true or Data.Type == "Melee");

                if v94 or (v95 or WishBooleans.WishReload) then
                    local v96 = v95 and Data.AltFunction and Data.AltFunction.Name;
                    v87:StopInspect(p75, v96 == "Scope" and true or v96 == "ScopeRifle");
                elseif v87.InspectDelay < Timer then
                    v87.Inspecting = false;
                end;
            end;

            if v79.Defusing then
                WishBooleans.WishFire = false;
            end;

            if Behavior and Behavior.TickCommand then
                v88, v89, v90 = Behavior.TickCommand(v87, p71, p74, p75, p76);
            end;

            if WishBooleans.WishInspect and not (v79.Planting or v79.Defusing) then
                v87:Inspect(p75);
            end;
        end;

        if v91 then
            if v88 then
                v93 = v90;
                v92 = v89;
                v91 = v88;
            end;
        else
            v93 = v90;
            v92 = v89;
            v91 = v88;
        end;

        return v91, v92, v93;
    end;
end;

function u1.Recoil(p97, p98) -- Line: 960
    -- upvalues: u17 (copy), u4 (ref)
    if not u17.Recoil then
        return;
    end;

    local v99 = p97.Data.Recoil.Table[p97.Mode];
    local v100 = math.floor(p97.RecoilIndex) % u4.RecoilTableSize * 8;
    p98.Simulation:KickBack(buffer.readf32(v99, v100), (buffer.readf32(v99, v100 + 4)));
end;

function u1.GetRecoveryTime(p101, p102) -- Line: 974
    -- upvalues: u17 (copy), u9 (ref)
    local Simulation = p102.Simulation;
    local Recovery = p101.Data.Recovery;

    if Simulation.Climbing then
        return Recovery.Stand;
    end;

    if not Simulation.OnGround then
        return Recovery.Duck * u17.AirRecoveryTimeScale;
    end;

    local v103, v104;

    if Simulation:HasDuckFlag() then
        v103 = Recovery.Duck;
        v104 = Recovery.DuckFinal;
    else
        v103 = Recovery.Stand;
        v104 = Recovery.StandFinal;
    end;

    if v104 ~= -1 then
        v103 = u9.RemapValueClamped(math.floor(p101.RecoilIndex), Recovery.TransitionStartBullet, Recovery.TransitionEndBullet, v103, v104);
    end;

    return v103;
end;

function u1.GetInaccuracy(p105, p106) -- Line: 1009
    -- upvalues: u17 (copy), u9 (ref)
    if not u17.Spread then
        return 0;
    end;

    local Constants = p106.Constants;
    local Data = p105.Data;
    local Mode = p105.Mode;
    local v107 = Data.Speed[Mode] / 0.0694;
    local Velocity = p106.Velocity;
    local AccuracyPenalty = p105.AccuracyPenalty;
    local v108 = u9.RemapValueClamped(vector.magnitude(Velocity * Vector3.new(1, 0, 1)) / 0.0694, v107 * Constants.DuckModifier, v107 * u17.MovementThreshold, 0, 1);

    if v108 > 0 then
        if not p106.IsWalking then
            v108 = v108 ^ u17.MovementCurveExponent;
        end;

        AccuracyPenalty = AccuracyPenalty + v108 * Data.Inaccuracy.Move[Mode];
    end;

    if not p106.OnGround then
        local v109 = Data.Inaccuracy.JumpInitial[Mode] * u17.AirInaccuracyScale;
        local math_sqrt_ret = math.sqrt(Constants.JumpImpulse / 0.0694);
        local v110 = math.abs(Velocity.Y) / 0.0694;
        local math_sqrt_ret2 = math.sqrt(v110);
        local math_map_ret = math.map(math_sqrt_ret2, math_sqrt_ret * u17.JumpSpeedThreshold, math_sqrt_ret, 0, v109);
        AccuracyPenalty = AccuracyPenalty + math.clamp(math_map_ret, 0, u17.InaccuracyMaxFallingPenalty * v109);
    end;

    local math_min_ret = math.min(1, AccuracyPenalty);
    local v111 = Data.Inaccuracy.Stand[Mode];

    if v111 < math_min_ret then
        math_min_ret = v111 + (math_min_ret - v111) * u17.NonIdleSpreadScale;
    end;

    return math_min_ret * u17.SpreadScale;
end;

function u1.UpdateAccuracyPenalty(p112, p113, p114) -- Line: 1084
    -- upvalues: u17 (copy), f32 (copy)
    local Simulation = p113.Simulation;
    local Inaccuracy = p112.Data.Inaccuracy;
    local Mode = p112.Mode;
    local AltFunction = p112.Data.AltFunction;
    local v115 = AltFunction and AltFunction.Name == "Silencer" and 2 or 1;
    local v116 = f32(Simulation.Climbing and Inaccuracy.Ladder[Mode] + Inaccuracy.Ladder[v115] or not Simulation.OnGround and Inaccuracy.Stand[Mode] + Inaccuracy.Jump[Mode] * u17.AirAccuracyPenaltyScale or (Simulation:HasDuckFlag() and Inaccuracy.Duck[Mode] or Inaccuracy.Stand[Mode]));
    local AccuracyPenalty = p112.AccuracyPenalty;

    if p112.RecoilIndex == 0 and v116 == AccuracyPenalty then
        return;
    end;

    if AccuracyPenalty < v116 then
        AccuracyPenalty = v116;
    elseif AccuracyPenalty > 0 and AccuracyPenalty ~= v116 then
        local v117 = p114 * -(u17.RecoilDecayBase / p112:GetRecoveryTime(p113));
        local math_exp_ret = math.exp(v117);
        AccuracyPenalty = f32((math.lerp(v116, AccuracyPenalty, math_exp_ret)));
    end;

    p112.AccuracyPenalty = AccuracyPenalty;
    local RecoilIndex = p112.RecoilIndex;

    if RecoilIndex > 0 and p112.Timer > f32(f32((p112.LastShotTime or 0) + f32(p112.Data.FireRate[v115])) + f32(u17.RecoilDecayThreshold)) then
        local math_exp_ret = math.exp(p114 * -(u17.RecoilDecayBase * u17.RecoilDecayCoefficient));
        p112.RecoilIndex = f32((math.lerp(0, RecoilIndex, math_exp_ret)));
    end;
end;

function u1.OnLand(p118, p119) -- Line: 1149
    -- upvalues: f32 (copy)
    local v120 = p118.Data.Inaccuracy.Land[p118.Mode] * (p119.FallingVelocity / 0.0694);
    p118.AccuracyPenalty = f32(p118.AccuracyPenalty + v120);
    local math_clamp_ret = math.clamp(v120, -1, 1);
    local v121 = Random.new(p118.RandomSeed):NextNumber() * 2 - 1;
    local math_asin_ret = math.asin(math_clamp_ret);
    local v122 = math.deg(math_asin_ret) * 0.2;
    local v123 = v121 * v122 * 0.1;
    p119.AimPunchAngle = p119.AimPunchAngle + vector.create(-v122, v123, 0);

    if p119.SeenAimPunch then
        p119.SeenAimPunch = p119.SeenAimPunch + vector.create(-v122, v123, 0);
    end;
end;

function u1.GetSpread(p124) -- Line: 1175
    -- upvalues: u17 (copy)
    return p124.Data.Spread[p124.Mode] * u17.SpreadScale;
end;

function u1.GetSpreadScale() -- Line: 1180
    -- upvalues: u17 (copy)
    return u17.SpreadScale or 1;
end;

function u1.Equip(p125) -- Line: 1184
end;

function u1.PlayAnimation(p126) -- Line: 1186
end;

function u1.ReverseAnimation(p127) -- Line: 1188
end;

function u1.StopAnimation(p128) -- Line: 1190
end;

function u1.StopAllAnimations(p129) -- Line: 1192
end;

function u1.IsPlayingFire(p130) -- Line: 1194
    return false;
end;

function u1.Reset(p131) -- Line: 1196
    -- upvalues: u4 (ref)
    p131.PacketDirty = true;
    p131:StopAllAnimations();
    p131.Equipping = false;
    p131.Reloading = false;
    p131.AmmoClip = false;
    p131.ShotgunShellLoaded = false;
    p131.Firing = false;
    p131.WannaShoot = false;
    p131.Inspecting = false;
    p131.AltFunctionHeld = false;
    p131.WaitForNoAttack = false;
    p131.FireDelay = 0;
    p131.LastShotTime = 0;
    p131.EquipDelay = 0;
    p131.ReloadDelay = 0;
    p131.AmmoDelay = 0;
    p131.InspectDelay = 0;

    if p131.AltFunctionDelay then
        p131.AltFunctionDelay = 0;
    end;

    p131.RecoilIndex = 0;
    p131.AccuracyPenalty = 0;
    local Data = u4.Get(p131.Name).Data;

    if Data.ClipSize then
        p131.Data.Ammo = Data.ClipSize;
        p131.Data.ReserveAmmo = Data.ReserveAmmo;
    end;

    p131.Behavior.Reset(p131);
end;

function u1.Init(p132) -- Line: 1241
    -- upvalues: u4 (ref), u6 (ref), u11 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u5 (ref), u12 (ref), u14 (ref), u15 (ref), u16 (ref), RefreshConfig (copy), u2 (copy)
    u4 = p132:GetModule("WeaponManager");
    u6 = p132:GetModule("GameConfiguration");
    u11 = p132:GetModule("Entities");
    u7 = p132:GetModule("Bullet");
    u8 = p132:GetModule("Signal");
    u9 = p132:GetModule("Math");
    u10 = p132:GetModule("Enums");
    u5 = p132:GetModule("GamemodesConfig");
    u12 = p132:GetModule("AnimationManager");
    u14 = require(script.Types.GunWeapon);
    u15 = require(script.Types.MeleeWeapon);
    u16 = require(script.Types.BombWeapon);
    RefreshConfig();
    u6.Updated:Connect(RefreshConfig);
    u14:Init(p132);
    u15:Init(p132);
    u16:Init(p132);

    for _, child in ipairs(script.AltFunctions:GetChildren()) do
        u2[child.Name] = require(child);
    end;
end;

function u1.Start(p133) -- Line: 1276
    -- upvalues: u13 (ref)
    u13 = p133:GetModule("BufferScheme").GetScheme("WeaponState");
end;

function u1.CanPlantHere(p134) -- Line: 1280
    -- upvalues: u16 (ref)
    return u16.CanPlantHere(p134);
end;

return u1;