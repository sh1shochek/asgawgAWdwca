-- ReplicatedStorage.Shared.WeaponConstructor.Types.BombWeapon
-- Script path: ReplicatedStorage.Shared.WeaponConstructor.Types.BombWeapon
-- Decompile time: 13.88 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local u2 = nil;
local u3 = nil;
local u4 = RunService:IsClient();
local u5 = RunService:IsServer();
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local SoundManager = require(game:GetService("ReplicatedStorage").Shared.Managers.SoundManager);
local f32 = require(game:GetService("ReplicatedStorage").Shared.Utility.Math).f32;
local OverlapParams_new_ret = OverlapParams.new();
OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
local u11 = {};

local function RefreshConfig() -- Line: 30
    -- upvalues: u11 (copy), u2 (ref)
    u11.CanPlant = u2.Get("Bomb", "CanPlant");
    u11.DuckCollisionSize = u2.Get("Character", "DuckCollisionSize");
    u11.StandCollisionSize = u2.Get("Character", "StandCollisionSize");
end;

local function ClearDisplay(p12) -- Line: 41
    -- upvalues: u3 (ref)
    local Viewmodel = p12.Viewmodel;
    local SetBombDisplay = u3.SetBombDisplay;

    if Viewmodel then
        Viewmodel = Viewmodel:FindFirstChild("Weapon");
    end;

    SetBombDisplay(Viewmodel, 0);
end;

function u1.Init(p13) -- Line: 47
    -- upvalues: u2 (ref), u3 (ref), u4 (copy), u6 (ref), u10 (ref), u11 (copy), RefreshConfig (copy)
    u2 = p13:GetModule("GameConfiguration");
    u3 = p13:GetModule("CharacterModel");

    if u4 then
        u6 = p13:GetModule("Gui");
    else
        u10 = p13:GetModule("PlayerHandler");
    end;

    u11.CanPlant = u2.Get("Bomb", "CanPlant");
    u11.DuckCollisionSize = u2.Get("Character", "DuckCollisionSize");
    u11.StandCollisionSize = u2.Get("Character", "StandCollisionSize");
    u2.Updated:Connect(RefreshConfig);
end;

function u1.Start(p14) -- Line: 61
    -- upvalues: u4 (copy), u7 (ref), u6 (ref), u8 (ref), u9 (ref)
    if u4 then
        u7 = u6.GetComponent("Notification");
        u8 = p14:GetModule("WeaponController");
        u9 = p14:GetModule("WeaponConstructor");
    end;
end;

local u15 = nil;

local function GetPlantParams() -- Line: 75
    -- upvalues: u15 (ref), OverlapParams_new_ret (copy)
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Zones");
    end;

    if Map then
        Map = Map:FindFirstChild("Plants");
    end;

    if Map ~= u15 then
        u15 = Map;
        OverlapParams_new_ret.FilterDescendantsInstances = { Map };
    end;

    return OverlapParams_new_ret;
end;

function u1.CanPlantHere(p16) -- Line: 88
    -- upvalues: u11 (copy), GetPlantParams (copy)
    if not (u11.CanPlant[p16.Team] and p16.OnGround) then
        return false;
    end;

    local v17 = p16.Ducked and u11.DuckCollisionSize or u11.StandCollisionSize;

    return #workspace:GetPartBoundsInBox(CFrame.new(p16.Position), v17, (GetPlantParams())) > 0;
end;

local function CancelPlant(p18: any, p19: any, p20: number, p21: boolean) -- Line: 101
    -- upvalues: f32 (copy), u3 (ref)
    p18.NextPlant = f32(p20 + 0.5);

    if not p21 then
        p18.PoseFadeLeft = p18.Data.PlantCancelFade;
        p18:StopAllAnimations();
        local Viewmodel = p18.Viewmodel;
        local SetBombDisplay = u3.SetBombDisplay;

        if Viewmodel then
            Viewmodel = Viewmodel:FindFirstChild("Weapon");
        end;

        SetBombDisplay(Viewmodel, 0);
    end;

    p19.Planting = false;
end;

function u1.Reset(p22) -- Line: 115
    p22.PacketDirty = true;
    p22.Firing = false;
    p22.Planting = false;
    p22.NextPlant = 0;
end;

function u1.Plant(p23, p24, p25, p26) -- Line: 123
    -- upvalues: u5 (copy), SoundManager (copy), u10 (ref), f32 (copy)
    if not p25 then
        p23:StopAllAnimations();
        p23:PlayAnimation("Plant", true);

        if u5 then
            local Simulation = p24.Simulation;
            local v27 = SoundManager.Pack("Weapons.Bomb.c4-initiate");

            if v27 and Simulation then
                u10.BroadcastSound(v27, Simulation.Position, p24.PlayerInstance);
            end;
        end;
    end;

    p23.FireDelay = f32(p23.Timer + p23.Data.FireRate[p23.Mode]);
end;

function u1.TickCommand(p28, p29, p30, p31, p32) -- Line: 144
    -- upvalues: u4 (copy), f32 (copy), u9 (ref), u8 (ref), u11 (copy), GetPlantParams (copy), u3 (ref), u1 (copy), u7 (ref)
    local WishBooleans = p30.WishBooleans;
    local Simulation = p29.Simulation;
    local Timer = p28.Timer;

    if u4 and (Simulation.Planting and p28.FireDelay <= Timer) then
        Simulation.Planting = false;
        p28.NextPlant = f32(Timer + 0.5);

        if not p31 then
            local v33 = u9.GetNextSlot(u8.GetWeaponInventory(), p28.Slot) or 3;
            u8.UpdateKeyState("WishEquip", v33);
        end;

        return nil, nil, nil;
    end;

    local v34 = Simulation.Ducked and u11.DuckCollisionSize or u11.StandCollisionSize;
    local PartBoundsInBox = workspace:GetPartBoundsInBox(CFrame.new(Simulation.Position), v34, (GetPlantParams()));

    if not Simulation.Planting or #PartBoundsInBox ~= 0 then
        if WishBooleans.WishFire then
            if p28.NextPlant <= Timer and (Simulation.OnGround and (not Simulation.Planting and u11.CanPlant[Simulation.Team])) then
                if #PartBoundsInBox > 0 then
                    u1.Plant(p28, p29, p31, WishBooleans.WishFire);
                    Simulation.Planting = true;
                elseif u4 and not p31 then
                    u7.SetNotifyVisibility(true, "Bomb must be planted at bomb site", 4);
                end;
            end;
        elseif Simulation.Planting then
            p28.NextPlant = f32(Timer + 0.5);

            if not p31 then
                p28.PoseFadeLeft = p28.Data.PlantCancelFade;
                p28:StopAllAnimations();
                local Viewmodel = p28.Viewmodel;
                local SetBombDisplay = u3.SetBombDisplay;

                if Viewmodel then
                    Viewmodel = Viewmodel:FindFirstChild("Weapon");
                end;

                SetBombDisplay(Viewmodel, 0);
            end;

            Simulation.Planting = false;
        end;

        return nil, nil, nil;
    end;

    p28.NextPlant = f32(Timer + 0.5);

    if not p31 then
        p28.PoseFadeLeft = p28.Data.PlantCancelFade;
        p28:StopAllAnimations();
        local Viewmodel = p28.Viewmodel;
        local SetBombDisplay = u3.SetBombDisplay;

        if Viewmodel then
            Viewmodel = Viewmodel:FindFirstChild("Weapon");
        end;

        SetBombDisplay(Viewmodel, 0);
    end;

    Simulation.Planting = false;

    return nil, nil, nil;
end;

return u1;