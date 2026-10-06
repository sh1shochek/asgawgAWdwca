-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local RunServiceController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("RunServiceController"));
local _ = Players.LocalPlayer;
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Raycast = require(ReplicatedStorage.Shared.Raycast);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Spring = require(ReplicatedStorage.Shared.Spring);
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);
local castThroughDistance = Raycast.castThroughDistance;
local workspace_CurrentCamera = workspace.CurrentCamera;
local math_min = math.min;
local math_rad = math.rad;
local math_max = math.max;
local math_abs = math.abs;

local function getSpreadConfig(p2) -- Line: 52
    return p2.ActiveSpreadConfig or p2.Properties.Spread;
end;

local function getCharacterSpeedForSpread(p3) -- Line: 56
    return p3.CharacterSpeed < 6.4 and 0 or p3.CharacterSpeed;
end;

local function getRawBaseSpread(p4) -- Line: 61
    local Position = p4.Spread:getPosition();

    return type(Position) ~= "number" and 0 or Position;
end;

local function clampBaseSpreadForConfig(p5: number, p6: any) -- Line: 66
    if p6 then
        return math.clamp(p5, p6.Range.Min, p6.Range.Max);
    end;

    return p5;
end;

local function getNoScopeMinSpread(p7) -- Line: 75
    local v8 = p7 and p7.MovementMultiplier or 1;

    return v8 == 2 and 6 or (v8 == 3 and 12 or 15);
end;

local function resetMovementSpreadState(p9) -- Line: 80
    p9.CharacterSpeed = 0;
    p9.isInAir = false;
    p9.jumpStartSpeed = nil;
    p9.verticalVelocity = 0;
    p9.isAtJumpPeak = false;
end;

local function updateCharacterSpeed(p10) -- Line: 88
    -- upvalues: CharacterResolver (copy), RuntimeKinematics (copy)
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if not LocalCharacter then
        p10.CharacterSpeed = 0;
        p10.isInAir = false;
        p10.jumpStartSpeed = nil;
        p10.verticalVelocity = 0;
        p10.isAtJumpPeak = false;

        return;
    end;

    local v11, _, v12, v13, v14 = RuntimeKinematics.resolve(LocalCharacter, LocalCharacter.PrimaryPart);
    p10.verticalVelocity = v13;
    local isInAir = p10.isInAir;
    p10.isInAir = not v14;
    local Properties = p10.Properties;
    local v15 = p10.ActiveSpreadConfig or p10.Properties.Spread;
    local v16;

    if v15 then
        v16 = v15.Range;
    else
        v16 = v15;
    end;

    if v16 then
        v16 = v16.Min;
    end;

    local v17;

    if v15 then
        v17 = v15.PerShot;
    else
        v17 = v15;
    end;

    local v18;

    if v15 then
        v18 = v15.MovementMultiplier;
    else
        v18 = v15;
    end;

    local v19;

    if Properties.AimingOptions == "SniperScope" and (Properties.MuzzleType == "Sniper" and (v16 == 0 and v17 == 0)) then
        v19 = v18 == 2;
    else
        v19 = false;
    end;

    local v20 = v19 and p10.isInAir and math.abs(p10.verticalVelocity) <= 3;
    p10.isAtJumpPeak = v20;

    if p10.isInAir and not isInAir then
        p10.jumpStartSpeed = v11.Magnitude + (v15 and v15.JumpShotMinimum or 100);
    elseif not p10.isInAir and isInAir then
        p10.jumpStartSpeed = nil;
        p10.isAtJumpPeak = false;
    end;

    if not (p10.isInAir and p10.jumpStartSpeed) then
        p10.CharacterSpeed = v11.Magnitude;

        return;
    end;

    if v19 and p10.isAtJumpPeak then
        p10.CharacterSpeed = v12;

        return;
    end;

    p10.CharacterSpeed = p10.jumpStartSpeed;
end;

local function isSpreadSettled(p21) -- Line: 137
    local Position = p21.Spread:getPosition();
    local Goal = p21.Spread:getGoal();
    local Velocity = p21.Spread:getVelocity();

    if type(Position) ~= "number" or (type(Goal) ~= "number" or type(Velocity) ~= "number") then
        return false;
    end;

    local v22;

    if math.abs(Position - Goal) <= 0.001 then
        v22 = math.abs(Velocity) <= 0.001;
    else
        v22 = false;
    end;

    return v22;
end;

local function stopSpreadRecovery(p23) -- Line: 149
    if p23.SpreadRecoveryConnection then
        p23.SpreadRecoveryConnection:Disconnect();
        p23.SpreadRecoveryConnection = nil;
    end;
end;

local function ensureSpreadRecovery(u24) -- Line: 156
    -- upvalues: RunServiceController (copy)
    if u24.IsDestroyed or u24.SpreadRecoveryConnection then
        return;
    end;

    u24.SpreadRecoveryConnection = RunServiceController.BindToStepped(`{u24.BindingName}.SpreadRecovery`, function(p25: number, p26: number) -- Line: 163
        -- upvalues: u24 (copy)
        u24:updateSpread(p26);
    end);
end;

function u1._performRaycast(p27: any, p28: number) -- Line: 172
    -- upvalues: GetRayIgnore (copy), workspace_CurrentCamera (copy), math_min (copy), math_rad (copy), math_abs (copy), castThroughDistance (copy)
    local v29 = GetRayIgnore();
    local v30 = workspace_CurrentCamera.ViewportSize * 0.5;
    local v31 = workspace_CurrentCamera:ViewportPointToRay(v30.X, v30.Y);
    local v32 = math_min(p28, 69);
    local v33 = os.clock() * 1000000 % 2147483647;
    local math_floor_ret = math.floor(v33);
    local Random_new_ret = Random.new(math_floor_ret);
    local v34 = {
        Theta = Random_new_ret:NextNumber(-3.141592653589793, 3.141592653589793),
        Phi = Random_new_ret:NextNumber(0, (math_rad(v32 * 0.5)))
    };
    local Direction = v31.Direction;
    local v35 = Direction.Magnitude > 0 and Direction.Unit or Vector3.new(0, 0, 1);
    local v36 = math_abs(v35.Y) > 0.9999 and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0);
    local CFrame_lookAlong_ret = CFrame.lookAlong(Vector3.new(0, 0, 0), v35, v36);
    local CFrame_Angles_ret = CFrame.Angles(0, 0, v34.Theta);
    local CFrame_Angles_ret2 = CFrame.Angles(v34.Phi, 0, 0);
    local LookVector = (CFrame_lookAlong_ret * CFrame_Angles_ret * CFrame_Angles_ret2).LookVector;
    local Origin = v31.Origin;
    local v37 = p27.Properties.Range or 500;
    local v38 = {
        Distance = 0,
        Origin = Origin,
        Direction = LookVector,
        Hits = {}
    };
    local v39 = castThroughDistance(Origin, LookVector * v37, p27.Properties.Penetration or 0, v29);
    local v40 = v39[1];

    if not v40 then
        v38.Distance = v37;

        return v38;
    end;

    v38.Distance = (v40.position - Origin).Magnitude;
    local Hits = v38.Hits;

    for i = 1, #v39 do
        local v41 = v39[i];
        local v42;

        if v41.instance and v41.material then
            Hits[#Hits + 1] = {
                Position = v41.position,
                Instance = v41.instance,
                Material = v41.material.Name,
                Normal = v41.normal or Vector3.new(0, 0, 0),
                Exit = i % 2 == 0
            };
            v42 = i;
        else
            v42 = i;
        end;
    end;

    return v38;
end;

function u1.setSpreadConfig(p43, p44) -- Line: 240
    local v45 = p43.ActiveSpreadConfig or p43.Properties.Spread;
    p43.ActiveSpreadConfig = p44;
    local v46 = p43.ActiveSpreadConfig or p43.Properties.Spread;
    assert(v46, "Weapon properties missing spread configuration");
    p43.Spread:setFrequency(v46.RecoverySpeed);

    if v45 == v46 then
        return;
    end;

    local Position = p43.Spread:getPosition();
    local v47 = type(Position) ~= "number" and 0 or Position;
    local math_clamp_ret = math.clamp(v47, v46.Range.Min, v46.Range.Max);
    p43.Spread:reset(math_clamp_ret);
    p43.Spread:setGoal(v46.Range.Min);
end;

function u1.create(p48: any, p49: string?, p50: boolean?) -- Line: 261
    -- upvalues: math_max (copy)
    p48.LastShotTick = tick();

    if p49 == "SniperScope" and not p50 then
        local v51 = p48.ActiveSpreadConfig or p48.Properties.Spread;
        local v52 = v51 and v51.MovementMultiplier or 1;
        local v53 = v52 == 2 and 6 or (v52 == 3 and 12 or 15);
        local Position = p48.Spread:getPosition();

        if (type(Position) ~= "number" and 0 or Position) < v53 then
            p48.Spread:setPosition(v53);
        end;
    end;

    local Weapon = p48.Weapon;
    local v54;

    if p49 == "SniperScope" and (p50 and (Weapon.Name == "AWP" and tick() - (Weapon.ScopeStartTick or 0) < 0.2)) then
        v54 = false;
    else
        v54 = p50;
    end;

    local TrueSpread = p48:getTrueSpread();

    if p50 and not v54 then
        local v55 = p48.ActiveSpreadConfig or p48.Properties.Spread;
        local v56 = v55 and v55.MovementMultiplier or 1;
        TrueSpread = math_max(TrueSpread, v56 == 2 and 6 or (v56 == 3 and 12 or 15));
    end;

    p48:_updateShotSpread(p49, v54);

    return p48:_performRaycast(TrueSpread);
end;

function u1.getTrueSpread(p57) -- Line: 298
    return p57:getSpreadForConfig(p57.ActiveSpreadConfig or p57.Properties.Spread);
end;

function u1.getBaseSpread(p58) -- Line: 302
    local Position = p58.Spread:getPosition();

    return type(Position) ~= "number" and 0 or Position;
end;

function u1.getBaseSpreadForConfig(p59, p60) -- Line: 306
    local v61 = p60 or (p59.ActiveSpreadConfig or p59.Properties.Spread);
    local Position = p59.Spread:getPosition();
    local v62 = type(Position) ~= "number" and 0 or Position;

    if v61 then
        return math.clamp(v62, v61.Range.Min, v61.Range.Max);
    end;

    return v62;
end;

function u1.getMovementSpreadForConfig(p63, p64) -- Line: 311
    local v65 = p64 or (p63.ActiveSpreadConfig or p63.Properties.Spread);

    return (p63.CharacterSpeed < 6.4 and 0 or p63.CharacterSpeed) * (not v65 and 1 or v65.MovementMultiplier);
end;

function u1.getSpreadForConfig(p66, p67) -- Line: 318
    local v68 = p67 or (p66.ActiveSpreadConfig or p66.Properties.Spread);

    return p66:getBaseSpreadForConfig(v68) + p66:getMovementSpreadForConfig(v68);
end;

function u1.setBaseSpreadForConfig(p69: any, p70: number, p71: any) -- Line: 324
    local v72 = p71 or (p69.ActiveSpreadConfig or p69.Properties.Spread);
    assert(v72, "Weapon properties missing spread configuration");
    local Spread = p69.Spread;

    if v72 then
        p70 = math.clamp(p70, v72.Range.Min, v72.Range.Max);
    end;

    Spread:setPosition(p70);
end;

function u1.updateSpread(p73: any, p74: number) -- Line: 335
    -- upvalues: isSpreadSettled (copy)
    p73.Spread:update(p74);

    if not p73.IsActive and isSpreadSettled(p73) then
        p73.Spread:reset(p73.Spread:getGoal());

        if p73.SpreadRecoveryConnection then
            p73.SpreadRecoveryConnection:Disconnect();
            p73.SpreadRecoveryConnection = nil;
        end;
    end;
end;

function u1.setActive(u75: any, p76: boolean) -- Line: 344
    -- upvalues: updateCharacterSpeed (copy), RunServiceController (copy)
    if u75.IsDestroyed or u75.IsActive == p76 then
        return;
    end;

    u75.IsActive = p76;

    if p76 then
        updateCharacterSpeed(u75);

        if not (u75.IsDestroyed or u75.SpreadRecoveryConnection) then
            u75.SpreadRecoveryConnection = RunServiceController.BindToStepped(`{u75.BindingName}.SpreadRecovery`, function(p77: number, p78: number) -- Line: 163
                -- upvalues: u75 (copy)
                u75:updateSpread(p78);
            end);
        end;

        u75.CharacterSpeedConnection = RunServiceController.BindToHeartbeat(`{u75.BindingName}.CharacterSpeed`, function() -- Line: 366
            -- upvalues: updateCharacterSpeed (ref), u75 (copy)
            updateCharacterSpeed(u75);
        end);

        return;
    end;

    if u75.CharacterSpeedConnection then
        u75.CharacterSpeedConnection:Disconnect();
        u75.CharacterSpeedConnection = nil;
    end;

    u75.CharacterSpeed = 0;
    u75.isInAir = false;
    u75.jumpStartSpeed = nil;
    u75.verticalVelocity = 0;
    u75.isAtJumpPeak = false;
end;

function u1._updateShotSpread(p79: any, p80: string?, p81: boolean?) -- Line: 372
    local v82 = p79.ActiveSpreadConfig or p79.Properties.Spread;
    assert(v82, "Weapon properties missing spread configuration");
    local Range = v82.Range;
    local Min = Range.Min;
    local Max = Range.Max;

    if p80 == "SniperScope" then
        if p81 then
            Min = 0;
        else
            local v83 = v82 and (v82.MovementMultiplier or 1) or 1;
            Min = v83 == 2 and 6 or (v83 == 3 and 12 or 15);
        end;
    end;

    local Position = p79.Spread:getPosition();
    local v84 = type(Position) ~= "number" and 0 or Position;
    local math_clamp_ret = math.clamp(v84 + v82.PerShot, Min, Max);
    p79.Spread:setPosition(math_clamp_ret);
end;

function u1.new(p85, p86) -- Line: 392
    -- upvalues: u1 (copy), Janitor (copy), Spring (copy), RunServiceController (copy)
    local v87 = setmetatable({}, u1);
    v87.Janitor = Janitor.new();
    v87.IsDestroyed = false;
    v87.Properties = p86;
    v87.Weapon = p85;
    v87.CharacterSpeed = 0;
    v87.isInAir = false;
    v87.jumpStartSpeed = nil;
    v87.verticalVelocity = 0;
    v87.isAtJumpPeak = false;
    local Spread = p86.Spread;
    assert(Spread, "Weapon properties missing spread configuration");
    v87.Spread = Spring.new(1, Spread.RecoverySpeed, Spread.Range.Min);
    v87.LastShotTick = 0;
    v87.IsActive = false;
    v87.BindingName = RunServiceController.CreateBindingName("Components.Bullet");

    return v87;
end;

function u1.destroy(p88) -- Line: 424
    if p88.IsDestroyed then
        return;
    end;

    p88:setActive(false);

    if p88.SpreadRecoveryConnection then
        p88.SpreadRecoveryConnection:Disconnect();
        p88.SpreadRecoveryConnection = nil;
    end;

    p88.IsDestroyed = true;
    p88.Janitor:Destroy();
    p88.Properties = nil;
    p88.Weapon = nil;
    p88.Spread = nil;
    p88.Janitor = nil;
end;

return u1;