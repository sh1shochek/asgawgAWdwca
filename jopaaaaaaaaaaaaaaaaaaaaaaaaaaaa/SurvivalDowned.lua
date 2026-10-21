-- ReplicatedStorage.Components.Common.SurvivalDowned
-- Script path: ReplicatedStorage.Components.Common.SurvivalDowned
-- Decompile time: 7.25 ms

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = {
    DOWNED_ATTRIBUTE = "IsDowned",
    BLEED_OUT_AT_ATTRIBUTE = "DownedBleedOutAt",
    BLEED_OUT_LEFT_ATTRIBUTE = "DownedBleedOutLeft",
    REVIVED_BY_ATTRIBUTE = "RevivedBy",
    REVIVER_COUNT_ATTRIBUTE = "ReviverCount",
    REVIVE_ENDS_AT_ATTRIBUTE = "ReviveEndsAt",
    REVIVING_ATTRIBUTE = "IsReviving",
    BLEED_OUT_SECONDS = 35,
    REVIVE_SECONDS = 4,
    REVIVE_SPEED = table.freeze({ 1, 1.6, 2, 2.35 }),
    REVIVE_RADIUS = 7,
    REVIVE_HEIGHT_TOLERANCE = 5,
    REVIVE_SERVER_SLACK = 1.5,
    LAST_STAND_SLOT = "Secondary",
    LAST_STAND_LOADOUT_PATH = "Loadout.Pistols.Options.1",
    DOWNED_HEALTH = 1,
    REVIVE_HEALTH_FRACTION = 0.5,
    EYE_DROP = 3.3,
    TOUCH_USE_IMAGE = "rbxassetid://126360878155762",
    POSE = table.freeze({
        LowerTorso = CFrame.new(0, -2.0131, 0.6566, 1, 0, 0, 0, 0.1415, -0.9899, 0, 0.9899, 0.1415),
        UpperTorso = CFrame.identity,
        Head = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.6886, 0.7251, 0, -0.7251, 0.6886),
        LeftUpperArm = CFrame.new(0, 0, 0, 0.8301, 0.5456, 0.1154, -0.5484, 0.8362, -0.0086, -0.1012, -0.0561, 0.9933),
        LeftLowerArm = CFrame.identity,
        LeftHand = CFrame.identity,
        RightUpperArm = CFrame.new(0, 0, 0, 0.9391, 0.2583, -0.2266, -0.3346, 0.8374, -0.4321, 0.0781, 0.4816, 0.8729),
        RightLowerArm = CFrame.identity,
        RightHand = CFrame.identity,
        LeftUpperLeg = CFrame.new(0, 0, 0, 0.9433, 0.1854, 0.2755, -0.0777, 0.9298, -0.3597, -0.3228, 0.3179, 0.8915),
        LeftLowerLeg = CFrame.identity,
        LeftFoot = CFrame.identity,
        RightUpperLeg = CFrame.new(0, 0, 0, 0.9883, -0.1495, 0.0315, 0.1504, 0.9882, -0.0294, -0.0267, 0.0338, 0.9991),
        RightLowerLeg = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.9848, -0.1736, 0, 0.1736, 0.9848),
        RightFoot = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.9962, 0.0872, 0, -0.0872, 0.9962)
    }),
    AIM_ELBOW_LIFT = 0.08726646259971647,
    AIM_FOREARM_BEND = 0.7853981633974483,
    AIM_PITCH_MIN = -0.2617993877991494,
    AIM_PITCH_MAX = 0.7853981633974483
};
local u2 = u1.POSE.LowerTorso:ToEulerAnglesXYZ();

function u1.IsDowned(p3: userdata?) -- Line: 103
    -- upvalues: u1 (copy)
    local v4;

    if p3 == nil then
        v4 = false;
    else
        v4 = p3:GetAttribute(u1.DOWNED_ATTRIBUTE) == true;
    end;

    return v4;
end;

function u1.IsReviving(p5: userdata?) -- Line: 107
    -- upvalues: u1 (copy)
    local v6;

    if p5 == nil then
        v6 = false;
    else
        v6 = typeof(p5:GetAttribute(u1.REVIVING_ATTRIBUTE)) == "number";
    end;

    return v6;
end;

function u1.AreHandsBusy(p7: userdata?) -- Line: 113
    -- upvalues: u1 (copy)
    return u1.IsDowned(p7) or u1.IsReviving(p7);
end;

function u1.CanUseSlot(p8: userdata?, p9: string?) -- Line: 119
    -- upvalues: u1 (copy)
    if u1.IsReviving(p8) then
        return false;
    end;

    return not u1.IsDowned(p8) or p9 == u1.LAST_STAND_SLOT;
end;

local function getPlayerFromUserIdAttribute(p10: userdata?, p11: string) -- Line: 126
    -- upvalues: Players (copy)
    local v12;

    if p10 then
        v12 = p10:GetAttribute(p11);
    else
        v12 = nil;
    end;

    if typeof(v12) == "number" then
        return Players:GetPlayerByUserId(v12);
    end;

    return nil;
end;

function u1.GetReviveTarget(p13: userdata?) -- Line: 132
    -- upvalues: u1 (copy), Players (copy)
    local REVIVING_ATTRIBUTE = u1.REVIVING_ATTRIBUTE;
    local v14;

    if p13 then
        v14 = p13:GetAttribute(REVIVING_ATTRIBUTE);
    else
        v14 = nil;
    end;

    if typeof(v14) == "number" then
        return Players:GetPlayerByUserId(v14);
    end;

    return nil;
end;

function u1.GetReviver(p15: userdata?) -- Line: 137
    -- upvalues: u1 (copy), Players (copy)
    local REVIVED_BY_ATTRIBUTE = u1.REVIVED_BY_ATTRIBUTE;
    local v16;

    if p15 then
        v16 = p15:GetAttribute(REVIVED_BY_ATTRIBUTE);
    else
        v16 = nil;
    end;

    if typeof(v16) == "number" then
        return Players:GetPlayerByUserId(v16);
    end;

    return nil;
end;

function u1.GetReviverCount(p17: userdata?) -- Line: 142
    -- upvalues: u1 (copy)
    local v18;

    if p17 then
        v18 = p17:GetAttribute(u1.REVIVER_COUNT_ATTRIBUTE);
    else
        v18 = nil;
    end;

    return typeof(v18) ~= "number" and 0 or v18;
end;

function u1.GetReviveSpeed(p19: number) -- Line: 148
    -- upvalues: u1 (copy)
    if p19 <= 0 then
        return 0;
    end;

    local REVIVE_SPEED = u1.REVIVE_SPEED;

    return REVIVE_SPEED[math.min(p19, #REVIVE_SPEED)];
end;

function u1.GetBleedOutLeft(p20: userdata) -- Line: 157
    -- upvalues: u1 (copy)
    local Attribute = p20:GetAttribute(u1.BLEED_OUT_LEFT_ATTRIBUTE);

    if typeof(Attribute) == "number" then
        return Attribute;
    end;

    local Attribute2 = p20:GetAttribute(u1.BLEED_OUT_AT_ATTRIBUTE);

    if typeof(Attribute2) ~= "number" then
        return 0;
    end;

    local v21 = Attribute2 - workspace:GetServerTimeNow();

    return math.max(v21, 0);
end;

function u1.GetReviveProgress(p22: userdata) -- Line: 170
    -- upvalues: u1 (copy)
    local Attribute = p22:GetAttribute(u1.REVIVE_ENDS_AT_ATTRIBUTE);

    if typeof(Attribute) ~= "number" then
        return nil;
    end;

    local GetReviveSpeed = u1.GetReviveSpeed;
    local ReviverCount = u1.GetReviverCount(p22);
    local v23 = GetReviveSpeed((math.max(ReviverCount, 1)));
    local v24 = 1 - (Attribute - workspace:GetServerTimeNow()) * v23 / u1.REVIVE_SECONDS;

    return math.clamp(v24, 0, 1);
end;

function u1.IsInReviveRange(p25: vector, p26: vector, p27: number?) -- Line: 183
    -- upvalues: u1 (copy)
    local v28 = p27 or 0;
    local v29;

    if Vector3.new(p25.X - p26.X, 0, p25.Z - p26.Z).Magnitude <= u1.REVIVE_RADIUS + v28 then
        v29 = math.abs(p25.Y - p26.Y) <= u1.REVIVE_HEIGHT_TOLERANCE + v28;
    else
        v29 = false;
    end;

    return v29;
end;

function u1.GetAimPose(p30: number) -- Line: 193
    -- upvalues: u1 (copy), u2 (copy)
    local AIM_ELBOW_LIFT = u1.AIM_ELBOW_LIFT;
    local AIM_FOREARM_BEND = u1.AIM_FOREARM_BEND;
    local math_clamp_ret = math.clamp(p30, u1.AIM_PITCH_MIN, u1.AIM_PITCH_MAX);

    return {
        RightUpperArm = CFrame.Angles(1.5707963267948966 - u2 + AIM_ELBOW_LIFT, 0, 0),
        RightLowerArm = CFrame.Angles(AIM_FOREARM_BEND, 0, 0),
        RightHand = CFrame.Angles(math_clamp_ret - AIM_ELBOW_LIFT - AIM_FOREARM_BEND, 0, 0)
    };
end;

function u1.GetPoseJoints(p31: userdata) -- Line: 205
    -- upvalues: u1 (copy)
    local v32 = {};

    for _, descendant in p31:GetDescendants() do
        if descendant:IsA("Motor6D") and (descendant.Part1 and u1.POSE[descendant.Part1.Name]) then
            table.insert(v32, descendant);
        end;
    end;

    return v32;
end;

return table.freeze(u1);