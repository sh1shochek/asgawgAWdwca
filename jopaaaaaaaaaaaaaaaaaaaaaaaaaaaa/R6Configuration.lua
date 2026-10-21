-- ReplicatedStorage.Classes.Ragdoll.Configuration.R6Configuration
-- Script path: ReplicatedStorage.Classes.Ragdoll.Configuration.R6Configuration
-- Decompile time: 2.70 ms

-- Decompiled with Potassium's decompiler.

local v1 = {
    BodyParts = table.freeze({
        Head = {
            CanCollide = true,
            Massless = false
        },
        UpperTorso = {
            CanCollide = true,
            Massless = false
        },
        LeftUpperArm = {
            CanCollide = true,
            Massless = false
        },
        RightUpperArm = {
            CanCollide = true,
            Massless = false
        },
        LeftUpperLeg = {
            CanCollide = true,
            Massless = false
        },
        RightUpperLeg = {
            CanCollide = true,
            Massless = false
        }
    }),
    JointOrder = table.freeze({ "Neck", "Left Shoulder", "Right Shoulder", "Left Hip", "Right Hip" })
};

local function socket(p2: string, p3: number) -- Line: 28
    return {
        {
            Kind = "BallSocket",
            Part0 = "UpperTorso",
            FromMotor = true,
            LimitsEnabled = true,
            TwistLimitsEnabled = false,
            TwistLowerAngle = -45,
            TwistUpperAngle = 45,
            MaxFrictionTorque = 20,
            Radius = 0.15,
            Restitution = 0,
            Part1 = p2,
            UpperAngle = p3
        }
    };
end;

v1.Joints = table.freeze({
    Neck = socket("Head", 40),
    ["Left Shoulder"] = socket("LeftUpperArm", 100),
    ["Right Shoulder"] = socket("RightUpperArm", 100),
    ["Left Hip"] = socket("LeftUpperLeg", 70),
    ["Right Hip"] = socket("RightUpperLeg", 70)
});
v1.Colliders = table.freeze({});
v1.ColliderSize = Vector3.new(0.5, 0.5, 0.5);

return v1;