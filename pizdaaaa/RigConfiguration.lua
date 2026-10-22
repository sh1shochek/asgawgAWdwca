-- ReplicatedStorage.Classes.Ragdoll.Configuration.RigConfiguration
-- Script path: ReplicatedStorage.Classes.Ragdoll.Configuration.RigConfiguration
-- Decompile time: 6.17 ms

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
        LowerTorso = {
            CanCollide = true,
            Massless = false
        },
        LeftUpperArm = {
            CanCollide = false,
            Massless = true
        },
        LeftLowerArm = {
            CanCollide = false,
            Massless = true
        },
        LeftHand = {
            CanCollide = false,
            Massless = true
        },
        RightUpperArm = {
            CanCollide = false,
            Massless = true
        },
        RightLowerArm = {
            CanCollide = false,
            Massless = true
        },
        RightHand = {
            CanCollide = false,
            Massless = true
        },
        LeftUpperLeg = {
            CanCollide = false,
            Massless = true
        },
        LeftLowerLeg = {
            CanCollide = false,
            Massless = true
        },
        LeftFoot = {
            CanCollide = false,
            Massless = true
        },
        RightUpperLeg = {
            CanCollide = false,
            Massless = true
        },
        RightLowerLeg = {
            CanCollide = false,
            Massless = true
        },
        RightFoot = {
            CanCollide = false,
            Massless = true
        }
    })
};
local CFrame_fromMatrix_ret = CFrame.fromMatrix(Vector3.new(0, 0, 0), Vector3.new(0, 1, 0), Vector3.new(-1, -0, -0), Vector3.new(0, 0, 1));
v1.JointOrder = table.freeze({ "Neck", "Waist", "LeftShoulder", "RightShoulder", "LeftElbow", "RightElbow", "LeftWrist", "RightWrist", "LeftHip", "RightHip", "LeftKnee", "RightKnee", "LeftAnkle", "RightAnkle" });
v1.Joints = table.freeze({
    Neck = {
        {
            Kind = "BallSocket",
            Part0 = "UpperTorso",
            Part1 = "Head",
            LimitsEnabled = true,
            UpperAngle = 45,
            TwistLimitsEnabled = true,
            TwistLowerAngle = -45,
            TwistUpperAngle = 45,
            MaxFrictionTorque = 30,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.75, 0),
            Attachment1 = CFrame.new(0, -0.5, 0)
        }
    },
    Waist = {
        {
            Kind = "BallSocket",
            Part0 = "LowerTorso",
            Part1 = "UpperTorso",
            LimitsEnabled = false,
            UpperAngle = 45,
            TwistLimitsEnabled = false,
            TwistLowerAngle = -45,
            TwistUpperAngle = 45,
            MaxFrictionTorque = 0,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(-0.0322222114, 0.24981612, 0.0711319149) * CFrame_fromMatrix_ret,
            Attachment1 = CFrame.new(-0.0344865322, -0.750000119, 0.0731166005) * CFrame_fromMatrix_ret
        },
        {
            Kind = "Hinge",
            Part0 = "LowerTorso",
            Part1 = "UpperTorso",
            LimitsEnabled = true,
            LowerAngle = -20,
            UpperAngle = 20,
            AngularResponsiveness = 45,
            AngularSpeed = 35,
            AngularVelocity = 0,
            MotorMaxAcceleration = 500000,
            MotorMaxTorque = 0,
            ServoMaxTorque = 5,
            TargetAngle = 80,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.250000089, 0),
            Attachment1 = CFrame.new(0, -0.749815941, 0),
            ActuatorType = Enum.ActuatorType.Servo
        }
    },
    LeftShoulder = {
        {
            Kind = "BallSocket",
            Part0 = "LeftUpperArm",
            Part1 = "UpperTorso",
            LimitsEnabled = true,
            UpperAngle = 45,
            TwistLimitsEnabled = true,
            TwistLowerAngle = -180,
            TwistUpperAngle = 180,
            MaxFrictionTorque = 30,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0.5, 0.238000005, 0),
            Attachment1 = CFrame.new(-1, 0.5, 0)
        }
    },
    RightShoulder = {
        {
            Kind = "BallSocket",
            Part0 = "RightUpperArm",
            Part1 = "UpperTorso",
            LimitsEnabled = true,
            UpperAngle = 45,
            TwistLimitsEnabled = true,
            TwistLowerAngle = -180,
            TwistUpperAngle = 180,
            MaxFrictionTorque = 30,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(-0.5, 0.238000005, 0),
            Attachment1 = CFrame.new(1, 0.5, 0)
        }
    },
    LeftElbow = {
        {
            Kind = "Hinge",
            Part0 = "LeftLowerArm",
            Part1 = "LeftUpperArm",
            LimitsEnabled = true,
            LowerAngle = -90,
            UpperAngle = 0,
            AngularResponsiveness = 45,
            AngularSpeed = 0,
            AngularVelocity = 0,
            MotorMaxAcceleration = 500000,
            MotorMaxTorque = 0,
            ServoMaxTorque = 0,
            TargetAngle = 0,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.388368845, 0),
            Attachment1 = CFrame.new(0, -0.486131668, 0),
            ActuatorType = Enum.ActuatorType.None
        }
    },
    RightElbow = {
        {
            Kind = "Hinge",
            Part0 = "RightLowerArm",
            Part1 = "RightUpperArm",
            LimitsEnabled = true,
            LowerAngle = -90,
            UpperAngle = 0,
            AngularResponsiveness = 45,
            AngularSpeed = 0,
            AngularVelocity = 0,
            MotorMaxAcceleration = 500000,
            MotorMaxTorque = 0,
            ServoMaxTorque = 0,
            TargetAngle = 0,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.388368845, 0),
            Attachment1 = CFrame.new(0, -0.486131668, 0),
            ActuatorType = Enum.ActuatorType.None
        }
    },
    LeftWrist = {
        {
            Kind = "Hinge",
            Part0 = "LeftHand",
            Part1 = "LeftLowerArm",
            LimitsEnabled = true,
            LowerAngle = -0.0001,
            UpperAngle = 0,
            AngularResponsiveness = 45,
            AngularSpeed = 0,
            AngularVelocity = 0,
            MotorMaxAcceleration = 500000,
            MotorMaxTorque = 0,
            ServoMaxTorque = 0,
            TargetAngle = 0,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.125, 0),
            Attachment1 = CFrame.new(0, -0.38786912, 0),
            ActuatorType = Enum.ActuatorType.None
        }
    },
    RightWrist = {
        {
            Kind = "Hinge",
            Part0 = "RightHand",
            Part1 = "RightLowerArm",
            LimitsEnabled = true,
            LowerAngle = -0.0001,
            UpperAngle = 0,
            AngularResponsiveness = 45,
            AngularSpeed = 0,
            AngularVelocity = 0,
            MotorMaxAcceleration = 500000,
            MotorMaxTorque = 0,
            ServoMaxTorque = 0,
            TargetAngle = 0,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.125, 0),
            Attachment1 = CFrame.new(0, -0.38786912, 0),
            ActuatorType = Enum.ActuatorType.None
        }
    },
    LeftHip = {
        {
            Kind = "BallSocket",
            Part0 = "LeftUpperLeg",
            Part1 = "LowerTorso",
            LimitsEnabled = true,
            UpperAngle = 45,
            TwistLimitsEnabled = true,
            TwistLowerAngle = -90,
            TwistUpperAngle = 90,
            MaxFrictionTorque = 30,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.4120000005, 0),
            Attachment1 = CFrame.new(-0.5, -0.25, 0)
        }
    },
    RightHip = {
        {
            Kind = "BallSocket",
            Part0 = "RightUpperLeg",
            Part1 = "LowerTorso",
            LimitsEnabled = true,
            UpperAngle = 45,
            TwistLimitsEnabled = true,
            TwistLowerAngle = -90,
            TwistUpperAngle = 90,
            MaxFrictionTorque = 30,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.4120000005, 0),
            Attachment1 = CFrame.new(0.5, -0.25, 0)
        }
    },
    LeftKnee = {
        {
            Kind = "Hinge",
            Part0 = "LeftLowerLeg",
            Part1 = "LeftUpperLeg",
            LimitsEnabled = true,
            LowerAngle = 90,
            UpperAngle = 0,
            AngularResponsiveness = 45,
            AngularSpeed = 60,
            AngularVelocity = 0,
            MotorMaxAcceleration = 500000,
            MotorMaxTorque = 0,
            ServoMaxTorque = 0,
            TargetAngle = 80,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.462723136, 0),
            Attachment1 = CFrame.new(0, -0.4120000005, 0),
            ActuatorType = Enum.ActuatorType.None
        }
    },
    RightKnee = {
        {
            Kind = "Hinge",
            Part0 = "RightLowerLeg",
            Part1 = "RightUpperLeg",
            LimitsEnabled = true,
            LowerAngle = 90,
            UpperAngle = 0,
            AngularResponsiveness = 45,
            AngularSpeed = 60,
            AngularVelocity = 0,
            MotorMaxAcceleration = 500000,
            MotorMaxTorque = 0,
            ServoMaxTorque = 0,
            TargetAngle = 80,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.462723136, 0),
            Attachment1 = CFrame.new(0, -0.4120000005, 0),
            ActuatorType = Enum.ActuatorType.None
        }
    },
    LeftAnkle = {
        {
            Kind = "Hinge",
            Part0 = "LeftFoot",
            Part1 = "LeftLowerLeg",
            LimitsEnabled = true,
            LowerAngle = 0,
            UpperAngle = 0,
            AngularResponsiveness = 45,
            AngularSpeed = 0,
            AngularVelocity = 0,
            MotorMaxAcceleration = 500000,
            MotorMaxTorque = 0,
            ServoMaxTorque = 0,
            TargetAngle = 0,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.125, 0),
            Attachment1 = CFrame.new(0, -0.463, 0),
            ActuatorType = Enum.ActuatorType.None
        }
    },
    RightAnkle = {
        {
            Kind = "Hinge",
            Part0 = "RightFoot",
            Part1 = "RightLowerLeg",
            LimitsEnabled = true,
            LowerAngle = 0,
            UpperAngle = 0,
            AngularResponsiveness = 45,
            AngularSpeed = 0,
            AngularVelocity = 0,
            MotorMaxAcceleration = 500000,
            MotorMaxTorque = 0,
            ServoMaxTorque = 0,
            TargetAngle = 0,
            Radius = 0.15,
            Restitution = 0,
            Attachment0 = CFrame.new(0, 0.125, 0),
            Attachment1 = CFrame.new(0, -0.463, 0),
            ActuatorType = Enum.ActuatorType.None
        }
    }
});
local CFrame_new_ret = CFrame.new(
    0,
    0,
    0,
    0.535461783,
    -0.0941229165,
    0.839298308,
    -0.0081747584,
    0.9931463,
    0.116591692,
    -0.844519913,
    -0.0692914277,
    0.53102243
);
local CFrame_new_ret2 = CFrame.new(
    0,
    0,
    0,
    -0.535461783,
    0.0941229165,
    -0.839298308,
    -0.0081747584,
    0.9931463,
    0.116591692,
    0.844519913,
    0.0692914277,
    -0.53102243
);
v1.Colliders = table.freeze({
    Head = CFrame.new(-0.0200119019, 0.124855995, 0.0889816284) * CFrame_new_ret,
    LeftFoot = CFrame.new(-0.0200119019, 0.124856293, 0.0892562866) * CFrame_new_ret,
    LeftHand = CFrame.new(-0.0200119019, 0.12490201, 0.0892562866) * CFrame_new_ret,
    LeftLowerArm = CFrame.new(-0.0200119019, 0.048927784, 0.0892562866) * CFrame_new_ret,
    LeftLowerLeg = CFrame.new(-0.0200119019, 0.225759506, 0.0892562866) * CFrame_new_ret,
    LeftUpperArm = CFrame.new(0.0200119019, 0.456183195, -0.0892562866) * CFrame_new_ret2,
    RightFoot = CFrame.new(-0.0200119019, 0.124856174, 0.0892562866) * CFrame_new_ret,
    RightHand = CFrame.new(-0.0200119019, 0.12490201, 0.0892562866) * CFrame_new_ret,
    RightLowerArm = CFrame.new(-0.0200119019, 0.048927784, 0.0892562866) * CFrame_new_ret,
    RightLowerLeg = CFrame.new(-0.0200119019, 0.225759506, 0.0892562866) * CFrame_new_ret,
    RightUpperArm = CFrame.new(0.0200119019, 0.456183195, -0.0892562866) * CFrame_new_ret2,
    UpperTorso = CFrame.new(-0.0200119019, 0.124873638, 0.0892562866) * CFrame_new_ret
});
v1.ColliderSize = Vector3.new(0.5, 0.5, 0.5);

return v1;