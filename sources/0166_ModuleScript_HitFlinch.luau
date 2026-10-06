-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local v1 = {};
local u2 = {};

local function findNeckMotor(p3: userdata) -- Line: 34
    local UpperTorso = p3:FindFirstChild("UpperTorso");
    local v4;

    if UpperTorso then
        v4 = UpperTorso:FindFirstChild("Head");
    else
        v4 = nil;
    end;

    if v4 and v4:IsA("Motor6D") then
        return v4;
    end;

    local Neck = p3:FindFirstChild("Neck", true);

    if Neck and Neck:IsA("Motor6D") then
        return Neck;
    end;

    return nil;
end;

local function armFlinch(p5: userdata, p6: vector?) -- Line: 50
    -- upvalues: u2 (copy), findNeckMotor (copy)
    local v7 = u2[p5];

    if not (v7 and v7.Neck.Parent) then
        local v8 = findNeckMotor(p5);

        if not v8 then
            warn((`[HitFlinch] No neck Motor6D found on {p5:GetFullName()}; hit flinch skipped`));

            return nil;
        end;

        local Waist = p5:FindFirstChild("Waist", true);
        v7 = {
            HeadPitch = 0,
            BodyPitch = 0,
            Neck = v8,
            BaseC1 = v8.C1,
            Waist = Waist
        };

        if Waist then
            Waist = Waist.C1;
        end;

        v7.WaistBaseC1 = Waist;
        u2[p5] = v7;
    end;

    local Part1 = v7.Neck.Part1;
    local v9 = not (p6 and Part1) and Vector3.new(0, 0, 1) or Part1.CFrame:VectorToObjectSpace(p6);
    local Vector3_new_ret = Vector3.new(v9.X, 0, v9.Z);
    v7.Axis = Vector3_new_ret.Magnitude <= 0.01 and Vector3.new(1, 0, 0) or (Vector3.new(0, 1, 0)):Cross(Vector3_new_ret.Unit);
    local v10;

    if Part1 then
        v10 = CFrame.new(0, -Part1.Size.Y / 2, 0);
    else
        v10 = CFrame.identity;
    end;

    v7.Pivot = v10;

    return v7;
end;

function v1.flickHead(p11: userdata, p12: vector?) -- Line: 83
    -- upvalues: armFlinch (copy)
    local v13 = armFlinch(p11, p12);

    if v13 then
        v13.HeadPitch = math.min(1.5707963267948966, v13.HeadPitch + 1.2217304763960306);
    end;
end;

function v1.flinchBody(p14: userdata, p15: vector?) -- Line: 90
    -- upvalues: armFlinch (copy)
    local v16 = armFlinch(p14, p15);

    if v16 then
        v16.BodyPitch = math.min(0.4363323129985824, v16.BodyPitch + 0.24434609527920614);
    end;
end;

RunServiceController.BindToRenderStep("CharacterController.HitFlinch.Update", function(p17: number) -- Line: 98
    -- upvalues: u2 (copy)
    local math_exp_ret = math.exp(p17 * -12);

    for i, v in pairs(u2) do
        local Neck = v.Neck;

        if Neck.Parent then
            if v.HeadPitch > 0 or v.BodyPitch > 0 then
                v.HeadPitch = v.HeadPitch * math_exp_ret;
                v.BodyPitch = v.BodyPitch * math_exp_ret;

                if v.HeadPitch + v.BodyPitch <= 0.008726646259971648 then
                    Neck.C1 = v.BaseC1;

                    if v.Waist then
                        v.Waist.C1 = v.WaistBaseC1;
                    end;

                    v.HeadPitch = 0;
                    v.BodyPitch = 0;
                else
                    local v18 = v.HeadPitch * 0.3 + v.BodyPitch;
                    Neck.C1 = v.Pivot * CFrame.fromAxisAngle(v.Axis, -(v.HeadPitch + v.BodyPitch * 0.5)) * v.Pivot:Inverse() * v.BaseC1;

                    if v.Waist then
                        v.Waist.C1 = v.WaistBaseC1 * CFrame.fromAxisAngle(v.Axis, -v18);
                    end;
                end;
            end;
        else
            u2[i] = nil;
        end;
    end;
end);

return v1;