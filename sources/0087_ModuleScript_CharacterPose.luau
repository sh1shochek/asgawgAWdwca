-- Decompiled with Potassium's decompiler.

local u1 = {};

local function findMotor(p2: userdata, p3: string) -- Line: 24
    local v4 = p2:FindFirstChild(p3, true);

    if v4 and v4:IsA("Motor6D") then
        return v4;
    end;

    return nil;
end;

function u1.getJoints(p5: userdata) -- Line: 30
    local RightShoulder = p5:FindFirstChild("RightShoulder", true);

    if not (RightShoulder and RightShoulder:IsA("Motor6D")) then
        RightShoulder = nil;
    end;

    local LeftShoulder = p5:FindFirstChild("LeftShoulder", true);

    if not (LeftShoulder and LeftShoulder:IsA("Motor6D")) then
        LeftShoulder = nil;
    end;

    local Waist = p5:FindFirstChild("Waist", true);

    if not (Waist and Waist:IsA("Motor6D")) then
        Waist = nil;
    end;

    if not (RightShoulder and (LeftShoulder and Waist)) then
        return nil;
    end;

    local Neck = p5:FindFirstChild("Neck", true);

    if not (Neck and Neck:IsA("Motor6D")) then
        Neck = nil;
    end;

    local v6 = {
        LastVerticalLook = nil,
        RightShoulder = RightShoulder,
        LeftShoulder = LeftShoulder,
        Waist = Waist,
        Neck = Neck,
        BaseRightShoulderC0 = RightShoulder.C0,
        BaseLeftShoulderC0 = LeftShoulder.C0,
        BaseWaistC0 = Waist.C0
    };
    local v7;

    if Neck then
        v7 = Neck.C0;
    else
        v7 = nil;
    end;

    v6.BaseNeckC0 = v7;

    return v6;
end;

function u1.composeRootCFrame(p8: vector, p9: number) -- Line: 52
    return CFrame.new(p8) * CFrame.Angles(0, p9, 0);
end;

function u1.predictHeadCFrame(p10: table, p11, p12: number, p13: number) -- Line: 57
    -- upvalues: u1 (copy)
    local Waist = p10.Waist;
    local Neck = p10.Neck;

    if not (Waist.Part0 and (Waist.Part1 and (Neck and (Neck.Part1 and (Neck.Part0 == Waist.Part1 and p10.BaseNeckC0))))) then
        return nil;
    end;

    local math_clamp_ret = math.clamp(p13, -1, 1);
    local v14 = Waist.Part0.CFrame * p10.BaseWaistC0 * CFrame.Angles(math_clamp_ret * 0.6283185307179585, 0, 0) * Waist.Transform * Waist.C1:Inverse() * p10.BaseNeckC0 * CFrame.Angles(math_clamp_ret * 1.0471975511965976, 0, 0) * Neck.Transform * Neck.C1:Inverse();

    return u1.composeRootCFrame(p11.Position, p12) * p11:Inverse() * v14;
end;

function u1.applyVerticalLook(p15: table, p16: number, p17: number?) -- Line: 78
    local math_clamp_ret = math.clamp(p16, -1, 1);

    if p15.LastVerticalLook ~= nil and (p17 or 0.0001) > math.abs(math_clamp_ret - p15.LastVerticalLook) then
        return;
    end;

    p15.RightShoulder.C0 = p15.BaseRightShoulderC0 * CFrame.Angles(math_clamp_ret * 0.5235987755982988, 0, 0);
    p15.LeftShoulder.C0 = p15.BaseLeftShoulderC0 * CFrame.Angles(math_clamp_ret * 0.5235987755982988, 0, 0);
    p15.Waist.C0 = p15.BaseWaistC0 * CFrame.Angles(math_clamp_ret * 0.6283185307179585, 0, 0);
    local Neck = p15.Neck;
    local BaseNeckC0 = p15.BaseNeckC0;

    if Neck and BaseNeckC0 then
        Neck.C0 = BaseNeckC0 * CFrame.Angles(math_clamp_ret * 1.0471975511965976, 0, 0);
    end;

    p15.LastVerticalLook = math_clamp_ret;
end;

return table.freeze(u1);