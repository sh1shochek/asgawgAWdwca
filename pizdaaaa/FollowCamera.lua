-- ReplicatedStorage.GameClient.CameraController.CameraTypes.FollowCamera
-- Script path: ReplicatedStorage.GameClient.CameraController.CameraTypes.FollowCamera
-- Decompile time: 4.07 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = 0;
local u7 = false;
local u8 = nil;
local u9 = 1;

function v1.SetTarget(p10: userdata?) -- Line: 22
    -- upvalues: u2 (ref), u7 (ref)
    if u2 ~= p10 and p10 ~= nil then
        u7 = true;
    end;

    u2 = p10;
end;

function v1.Update(p11: table, p12, p13: number, p14: number, p15: number) -- Line: 29
    -- upvalues: u2 (ref), u7 (ref), u8 (ref), u9 (ref), u4 (ref), u5 (ref), u6 (ref), u3 (ref)
    if not u2 then
        return p12;
    end;

    if u7 then
        u7 = false;
        u8 = p12;
        u9 = 0;
    end;

    if u4 == nil then
        u4 = p14;
        u5 = p13;
    end;

    if u4 == p14 and u5 == p13 then
        u6 = u6 + p15;
    else
        u6 = 0;
    end;

    u4 = p14;
    u5 = p13;

    if u6 >= 1 then
        local _, v16, _ = u2.CFrame:ToEulerAnglesYXZ();
        p14 = p14 + ((v16 - p14 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.clamp(p15 * 5, 0, 1);

        if p14 < -3.141592653589793 then
            p14 = p14 + 6.283185307179586;
        end;

        if p14 > 3.141592653589793 then
            p14 = p14 - 6.283185307179586;
        end;

        if u3 then
            u3.SetAngles(p14, p13);
        end;

        u4 = p14;
        u5 = p13;
    end;

    local v17 = CFrame.fromEulerAnglesYXZ(-p13, p14, 0) + (u2.Position + Vector3.new(0, 1.5, 0));

    if u9 >= 1 then
        return v17;
    end;

    u9 = math.min(1, u9 + p15 / 0.35);

    return u8:Lerp(v17, u9 * u9 * (3 - u9 * 2));
end;

function v1.Init(p18) -- Line: 93
    -- upvalues: u3 (ref)
    u3 = p18:GetModule("CameraController");
end;

return v1;