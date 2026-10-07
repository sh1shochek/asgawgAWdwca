-- ReplicatedStorage.Controllers.CharacterController.HitFlinch
-- Script path: ReplicatedStorage.Controllers.CharacterController.HitFlinch
-- Decompile time: 2.08 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local v1 = {}
local u10 = {}

local function findNeckMotor(a1) -- Line: 34 -- types: a1: userdata
    local UpperTorso = a1:FindFirstChild("UpperTorso")
    local Head = if not UpperTorso then nil else UpperTorso:FindFirstChild("Head")
    if Head and Head:IsA("Motor6D") then
        return Head
    end
    local Neck = a1:FindFirstChild("Neck", true)
    if Neck and Neck:IsA("Motor6D") then
        return Neck
    end
    return nil
end

local function armFlinch(a1, a2) -- Line: 50
    -- upvalues: u10 (val), findNeckMotor (val)
    local Part1, Unit, v1, v2, v3
    local v4 = u10[a1]
    if v4 and v4.Neck.Parent then
        Part1 = v4.Neck.Part1
        v2 = Vector3.new(
            (if not a2 then Vector3.new(0, 0, 1) else if not Part1 then Vector3.new(0, 0, 1) else Part1.CFrame:VectorToObjectSpace(a2)).X,
            0,
            v1.Z
        )
        if not (0.01 < v2.Magnitude) then
            v3 = Vector3.new(1, 0, 0)
        else
            Unit = v2.Unit
            v3 = Vector3.new(0, 1, 0):Cross(Unit)
        end
        v4.Axis = v3
        v4.Pivot = if not Part1 then CFrame.identity else CFrame.new(0, -Part1.Size.Y / 2, 0)
        return v4
    end
    local v5 = findNeckMotor(a1)
    if not v5 then
        warn((("[HitFlinch] No neck Motor6D found on %*; hit flinch skipped"):format((a1:GetFullName()))))
        return nil
    end
    local Waist = a1:FindFirstChild("Waist", true)
    v4 = {
        HeadPitch = 0,
        BodyPitch = 0,
        Neck = v5,
        BaseC1 = v5.C1,
        Waist = Waist,
        WaistBaseC1 = Waist and Waist.C1,
    }
    u10[a1] = v4
    Part1 = v4.Neck.Part1
    v2 = Vector3.new(
        (if not a2 then Vector3.new(0, 0, 1) else if not Part1 then Vector3.new(0, 0, 1) else Part1.CFrame:VectorToObjectSpace(a2)).X,
        0,
        v1.Z
    )
    if not (0.01 < v2.Magnitude) then
        v3 = Vector3.new(1, 0, 0)
    else
        Unit = v2.Unit
        v3 = Vector3.new(0, 1, 0):Cross(Unit)
    end
    v4.Axis = v3
    v4.Pivot = if not Part1 then CFrame.identity else CFrame.new(0, -Part1.Size.Y / 2, 0)
    return v4
end

function v1.flickHead(a1, a2) -- Line: 83 -- upvalues: armFlinch (val) -- types: a1: userdata, a2: vector?
    local v1 = armFlinch(a1, a2)
    if v1 then
        v1.HeadPitch = math.min(1.5707963267948966, v1.HeadPitch + 1.2217304763960306)
    end
end

function v1.flinchBody(a1, a2) -- Line: 90 -- upvalues: armFlinch (val) -- types: a1: userdata, a2: vector?
    local v1 = armFlinch(a1, a2)
    if v1 then
        v1.BodyPitch = math.min(0.4363323129985824, v1.BodyPitch + 0.24434609527920614)
    end
end

RunServiceController.BindToRenderStep("CharacterController.HitFlinch.Update", function(a1) -- Line: 98 -- upvalues: u10 (val) -- types: a1: number
    local Neck, v1, v2
    local v3 = math.exp(a1 * -12)
    for k, v in pairs(u10) do
        Neck = v.Neck
        if not Neck.Parent then
            u10[k] = nil
        elseif not (v.HeadPitch <= 0) or not (v.BodyPitch <= 0) then
            v.HeadPitch = v.HeadPitch * v3
            v.BodyPitch = v.BodyPitch * v3
            v1 = v.HeadPitch + v.BodyPitch
            if not (v1 <= 0.008726646259971648) then
                v1 = v.HeadPitch + v.BodyPitch * 0.5
                v2 = v.HeadPitch * 0.3 + v.BodyPitch
                Neck.C1 = v.Pivot * CFrame.fromAxisAngle(v.Axis, -v1) * v.Pivot:Inverse() * v.BaseC1
                if v.Waist then
                    v.Waist.C1 = v.WaistBaseC1 * CFrame.fromAxisAngle(v.Axis, -v2)
                end
            else
                Neck.C1 = v.BaseC1
                if v.Waist then
                    v.Waist.C1 = v.WaistBaseC1
                end
                v.HeadPitch = 0
                v.BodyPitch = 0
            end
        end
    end
end)
return v1