-- ReplicatedStorage.Components.Common.CharacterPose
-- Script path: ReplicatedStorage.Components.Common.CharacterPose
-- Decompile time: 1.35 ms

local u0 = {}

local function findMotor(a1, a2) -- Line: 24 -- types: a1: userdata, a2: string
    local v1 = a1:FindFirstChild(a2, true)
    if v1 and v1:IsA("Motor6D") then
        return v1
    end
    return nil
end

function u0.getJoints(a1) -- Line: 30 -- types: a1: userdata
    local RightShoulder = a1:FindFirstChild("RightShoulder", true)
    local v1 = if not RightShoulder then nil else if not RightShoulder:IsA("Motor6D") then nil else RightShoulder
    local LeftShoulder = a1:FindFirstChild("LeftShoulder", true)
    local v2 = if not LeftShoulder then nil else if not LeftShoulder:IsA("Motor6D") then nil else LeftShoulder
    local Waist = a1:FindFirstChild("Waist", true)
    local v3 = if not Waist then nil else if not Waist:IsA("Motor6D") then nil else Waist
    if v1 and v2 and v3 then
        local Neck = a1:FindFirstChild("Neck", true)
        local v4 = if not Neck then nil else if not Neck:IsA("Motor6D") then nil else Neck
        return {
            RightShoulder = v1,
            LeftShoulder = v2,
            Waist = v3,
            Neck = v4,
            BaseRightShoulderC0 = v1.C0,
            BaseLeftShoulderC0 = v2.C0,
            BaseWaistC0 = v3.C0,
            BaseNeckC0 = if not v4 then nil else v4.C0,
        }
    end
    return nil
end

function u0.composeRootCFrame(a1, a2) -- Line: 52 -- types: a1: vector, a2: number
    return (CFrame.new(a1)) * CFrame.Angles(0, a2, 0)
end

function u0.predictHeadCFrame(a1, a2, a3, a4) -- Line: 57
    -- upvalues: u0 (val)
    local Waist = a1.Waist
    local Neck = a1.Neck
    if Waist.Part0 and Waist.Part1 and Neck and Neck.Part1 and Neck.Part0 == Waist.Part1 and a1.BaseNeckC0 then
        local v1 = math.clamp(a4, -1, 1)
        local v2 = Waist.Part0.CFrame * a1.BaseWaistC0 * CFrame.Angles(v1 * 0.6283185307179585, 0, 0) * Waist.Transform * Waist.C1:Inverse() * a1.BaseNeckC0 * CFrame.Angles(v1 * 1.0471975511965976, 0, 0) * Neck.Transform * Neck.C1:Inverse()
        return (u0.composeRootCFrame(a2.Position, a3)) * a2:Inverse() * v2
    end
    return nil
end

function u0.applyVerticalLook(a1, a2, a3) -- Line: 78 -- types: a1: table, a2: number, a3: number?
    local v1 = math.clamp(a2, -1, 1)
    if a1.LastVerticalLook ~= nil and math.abs(v1 - a1.LastVerticalLook) < (a3 or 0.0001) then
        return
    end
    a1.RightShoulder.C0 = a1.BaseRightShoulderC0 * CFrame.Angles(v1 * 0.5235987755982988, 0, 0)
    a1.LeftShoulder.C0 = a1.BaseLeftShoulderC0 * CFrame.Angles(v1 * 0.5235987755982988, 0, 0)
    a1.Waist.C0 = a1.BaseWaistC0 * CFrame.Angles(v1 * 0.6283185307179585, 0, 0)
    local Neck = a1.Neck
    local BaseNeckC0 = a1.BaseNeckC0
    if Neck and BaseNeckC0 then
        Neck.C0 = BaseNeckC0 * CFrame.Angles(v1 * 1.0471975511965976, 0, 0)
    end
    a1.LastVerticalLook = v1
end

return table.freeze(u0)