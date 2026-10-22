-- ReplicatedStorage.Shared.Data.RagdollData
-- Script path: ReplicatedStorage.Shared.Data.RagdollData
-- Decompile time: 5.09 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    UnitsPerStud = 14.409,
    PushScale = 1,
    PlayerScale = 1.05,
    HeadshotScale = 3,
    DamageImpulseScale = 300,
    ExplosiveImpulseClamp = 30000,
    ExplosiveJitter = { 0.85, 1.15 },
    Gravity = 58.975,
    MaxVelocity = 138.8021375529183,
    MaxAngularVelocity = 62.83185307179586,
    LaunchVelocityClamp = 54.132833645638144,
    LastAliveVelocityAlpha = 0.2,
    Timestep = 0.016666666666666666,
    TotalMass = 85,
    MinLimbMass = 1,
    Inertia = 1,
    SleepTolerance = 0.06940106877645916,
    SleepToleranceMax = 0.6940106877645915,
    SleepAfterTime = 4,
    MaxCount = 8,
    FadeSpeed = 2.3529411764705883
};
local table_freeze_ret = table.freeze({
    ["50AE"] = 2000,
    ["762mm"] = 2000,
    ["556mm"] = 2000,
    ["556mm_box"] = 2400,
    ["338mag"] = 2400,
    ["9mm"] = 1600,
    buckshot = 600,
    ["45acp"] = 1700,
    ["357sig"] = 1600,
    ["57mm"] = 1600
});
u1.AmmoImpulse = table_freeze_ret;
u1.WeaponAmmo = table.freeze({
    ["AK-47"] = "762mm",
    ["SG 553"] = "556mm",
    AUG = "556mm",
    M4A4 = "556mm",
    ["M4A1-S"] = "556mm",
    FAMAS = "556mm",
    ["Galil AR"] = "556mm",
    ["SSG 08"] = "556mm",
    AWP = "338mag",
    G3SG1 = "762mm",
    ["SCAR-20"] = "762mm",
    ["Desert Eagle"] = "50AE",
    ["R8 Revolver"] = "357sig",
    ["Glock-18"] = "9mm",
    P2000 = "9mm",
    ["USP-S"] = "45acp",
    P250 = "357sig",
    ["Five-SeveN"] = "57mm",
    ["Tec-9"] = "9mm",
    ["CZ75-Auto"] = "357sig",
    ["Dual Berettas"] = "9mm",
    MP9 = "9mm",
    ["MAC-10"] = "45acp",
    MP7 = "57mm",
    ["MP5-SD"] = "9mm",
    ["UMP-45"] = "45acp",
    P90 = "57mm",
    ["PP-Bizon"] = "9mm",
    Nova = "buckshot",
    XM1014 = "buckshot",
    ["MAG-7"] = "buckshot",
    ["Sawed-Off"] = "buckshot",
    M249 = "556mm_box",
    Negev = "556mm_box"
});
local table_freeze_ret2 = table.freeze({
    Rifle = "556mm",
    Sniper = "338mag",
    SMG = "9mm",
    Pistol = "9mm",
    Shotgun = "buckshot",
    Machinegun = "556mm_box"
});

function u1.GetBulletImpulse(p2: string?, p3: string?, p4: boolean?) -- Line: 160
    -- upvalues: u1 (copy), table_freeze_ret2 (copy), table_freeze_ret (copy)
    local v5 = p2 and u1.WeaponAmmo[p2];

    if v5 then
        p3 = v5;
    elseif p3 then
        p3 = table_freeze_ret2[p3];
    end;

    return (p3 and table_freeze_ret[p3] or table_freeze_ret["9mm"]) * u1.PushScale * u1.PlayerScale * (p4 and u1.HeadshotScale or 1);
end;

u1.LimbOrder = table.freeze({ "LowerTorso", "UpperTorso", "Head", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot" });
local v6 = {};

for i, v in u1.LimbOrder do
    v6[v] = i;
end;

u1.LimbIndex = table.freeze(v6);
u1.RootLimb = "LowerTorso";
u1.Joints = table.freeze({
    {
        Child = "UpperTorso",
        Parent = "LowerTorso",
        Pivot = Vector3.new(0, -0.5, 0),
        X = { -25, 40, 1 },
        Y = { -30, 30, 1 },
        Z = { -20, 20, 1 }
    },
    {
        Child = "Head",
        Parent = "UpperTorso",
        Pivot = Vector3.new(0, -0.5, 0),
        X = { -40, 30, 1 },
        Y = { -60, 60, 1 },
        Z = { -35, 35, 1 }
    },
    {
        Child = "LeftUpperArm",
        Parent = "UpperTorso",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { -90, 90, 1 },
        Y = { -75, 75, 1 },
        Z = { -85, 30, 1 }
    },
    {
        Child = "RightUpperArm",
        Parent = "UpperTorso",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { -90, 90, 1 },
        Y = { -75, 75, 1 },
        Z = { -30, 85, 1 }
    },
    {
        Child = "LeftLowerArm",
        Parent = "LeftUpperArm",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { 0, 0, 0 },
        Y = { 0, 0, 0 },
        Z = { 0, 140, 1 }
    },
    {
        Child = "RightLowerArm",
        Parent = "RightUpperArm",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { 0, 0, 0 },
        Y = { 0, 0, 0 },
        Z = { -140, 0, 1 }
    },
    {
        Child = "LeftHand",
        Parent = "LeftLowerArm",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { -20, 20, 1 },
        Y = { -25, 25, 1 },
        Z = { -70, 70, 1 }
    },
    {
        Child = "RightHand",
        Parent = "RightLowerArm",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { -20, 20, 1 },
        Y = { -25, 25, 1 },
        Z = { -70, 70, 1 }
    },
    {
        Child = "LeftUpperLeg",
        Parent = "LowerTorso",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { -90, 30, 1 },
        Y = { -35, 35, 1 },
        Z = { -45, 20, 1 }
    },
    {
        Child = "RightUpperLeg",
        Parent = "LowerTorso",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { -90, 30, 1 },
        Y = { -35, 35, 1 },
        Z = { -20, 45, 1 }
    },
    {
        Child = "LeftLowerLeg",
        Parent = "LeftUpperLeg",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { 0, 135, 1 },
        Y = { 0, 0, 0 },
        Z = { 0, 0, 0 }
    },
    {
        Child = "RightLowerLeg",
        Parent = "RightUpperLeg",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { 0, 135, 1 },
        Y = { 0, 0, 0 },
        Z = { 0, 0, 0 }
    },
    {
        Child = "LeftFoot",
        Parent = "LeftLowerLeg",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { -45, 30, 1 },
        Y = { -15, 15, 1 },
        Z = { -20, 20, 1 }
    },
    {
        Child = "RightFoot",
        Parent = "RightLowerLeg",
        Pivot = Vector3.new(0, 0.5, 0),
        X = { -45, 30, 1 },
        Y = { -15, 15, 1 },
        Z = { -20, 20, 1 }
    }
});
local v7 = {};

for _, v in u1.Joints do
    v7[v.Child] = v.Parent;
end;

u1.ParentOf = table.freeze(v7);

return u1;