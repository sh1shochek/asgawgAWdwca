-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {
    EQUIP_PULLOUT_FRACTION = 0.925,
    DEFAULT_EQUIP_PULLOUT = 0.5,
    EQUIP_ACTION_LOCKOUT = 1,
    MELEE_EQUIP_LOCKOUT = 1,
    BURST_SHOT_COUNT = 3,
    BURST_SHOT_INTERVAL = 0.075,
    BURST_COOLDOWN = 0.15
};
local u2 = {};
local u3 = false;

function u1.PulloutSeconds(p4: number?) -- Line: 20
    -- upvalues: u1 (copy)
    if p4 == nil or p4 <= 0 then
        return u1.DEFAULT_EQUIP_PULLOUT;
    end;

    return p4 * u1.EQUIP_PULLOUT_FRACTION;
end;

local function clipLength(p5: userdata) -- Line: 27
    local v6 = 0;

    if p5:IsA("KeyframeSequence") then
        for _, v in p5:GetKeyframes() do
            v6 = math.max(v6, v.Time);
        end;
    else
        for _, descendant in p5:GetDescendants() do
            if descendant:IsA("FloatCurve") or descendant:IsA("RotationCurve") then
                for _, v in descendant:GetKeys() do
                    v6 = math.max(v6, v.Time);
                end;
            end;
        end;
    end;

    if v6 > 0 then
        return v6;
    end;

    return nil;
end;

local function fetchLength(p7: userdata, p8: userdata, p9: string, p10: string) -- Line: 45
    -- upvalues: clipLength (copy)
    local v11 = p8:FindFirstChild(p9);

    if v11 == nil or not v11:IsA("Animation") then
        return nil;
    end;

    local success, result = pcall(p7.GetAnimationClipAsync, p7, v11.AnimationId);

    if not success or result == nil then
        warn((`[WeaponTimings] {p10} {p9} clip unavailable: {tostring(result)}`));

        return nil;
    end;

    local v12 = clipLength(result);
    result:Destroy();

    return v12;
end;

function u1.Load() -- Line: 61
    -- upvalues: u3 (ref), ReplicatedStorage (copy), u2 (copy), fetchLength (copy)
    if u3 then
        return;
    end;

    u3 = true;
    local AnimationClipProvider = game:GetService("AnimationClipProvider");

    for _, child in ReplicatedStorage.Database.Custom.Weapons:GetChildren() do
        if child:IsA("ModuleScript") then
            local v13 = require(child);
            local CameraAnimations = v13.CameraAnimations;

            if v13.Class == "Weapon" and typeof(CameraAnimations) == "Instance" then
                u2[child.Name] = {
                    Equip = fetchLength(AnimationClipProvider, CameraAnimations, "Equip", child.Name),
                    Reload = fetchLength(AnimationClipProvider, CameraAnimations, "Reload", child.Name)
                };
            end;
        end;
    end;
end;

function u1.DrawSeconds(p14: string) -- Line: 84
    -- upvalues: u2 (copy), u1 (copy)
    local v15 = u2[p14];
    local v16;

    if v15 then
        v16 = v15.Equip;
    else
        v16 = nil;
    end;

    return u1.PulloutSeconds(v16);
end;

function u1.MinShotInterval(p17) -- Line: 90
    -- upvalues: u1 (copy)
    local v18 = p17.FireRate or 0;
    local FireModes = p17.FireModes;

    if FireModes ~= nil then
        if FireModes.Primary ~= nil and FireModes.Primary.FireRate ~= nil then
            v18 = math.min(v18, FireModes.Primary.FireRate);
        end;

        if FireModes.Secondary ~= nil and FireModes.Secondary.FireRate ~= nil then
            v18 = math.min(v18, FireModes.Secondary.FireRate);
        end;
    end;

    if p17.ShootingOptions == "Burst" then
        v18 = math.min(v18, (u1.BURST_SHOT_INTERVAL * u1.BURST_SHOT_COUNT + u1.BURST_COOLDOWN) / u1.BURST_SHOT_COUNT);
    end;

    return v18;
end;

function u1.ReloadSeconds(p19: string) -- Line: 109
    -- upvalues: u2 (copy)
    local v20 = u2[p19];

    if v20 then
        return v20.Reload;
    end;

    return nil;
end;

return table.freeze(u1);