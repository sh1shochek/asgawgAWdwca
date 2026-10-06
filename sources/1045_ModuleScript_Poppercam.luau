-- Decompiled with Potassium's decompiler.

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local Players = game:GetService("Players");
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local ZoomController = require(script.Parent:WaitForChild("ZoomController"));
local LocalPlayer = Players.LocalPlayer;
local UserFlag = FlagUtil.getUserFlag("UserFixCameraFPError");
local u1 = {};
u1.__index = u1;
local CFrame_new_ret = CFrame.new();

local function cframeToAxis(p2) -- Line: 19
    local v3, v4 = p2:ToAxisAngle();

    return v3 * v4;
end;

local function axisToCFrame(p5: vector) -- Line: 24
    -- upvalues: CFrame_new_ret (copy)
    local Magnitude = p5.Magnitude;

    if Magnitude > 0.00001 then
        return CFrame.fromAxisAngle(p5, Magnitude);
    end;

    return CFrame_new_ret;
end;

local function extractRotation(p6) -- Line: 32
    local _, _, _, v7, v8, v9, v10, v11, v12, v13, v14, v15 = p6:GetComponents();

    return CFrame.new(0, 0, 0, v7, v8, v9, v10, v11, v12, v13, v14, v15);
end;

function u1.new() -- Line: 37
    -- upvalues: u1 (copy)
    return setmetatable({
        lastCFrame = nil
    }, u1);
end;

function u1.Step(p16: table, p17: number, p18) -- Line: 43
    -- upvalues: CFrame_new_ret (copy)
    local v19 = p16.lastCFrame or p18;
    p16.lastCFrame = p18;
    local Position = p18.Position;
    local _, _, _, v20, v21, v22, v23, v24, v25, v26, v27, v28 = p18:GetComponents();
    local CFrame_new_ret2 = CFrame.new(0, 0, 0, v20, v21, v22, v23, v24, v25, v26, v27, v28);
    local p = v19.p;
    local _, _, _, v29, v30, v31, v32, v33, v34, v35, v36, v37 = v19:GetComponents();
    local CFrame_new_ret3 = CFrame.new(0, 0, 0, v29, v30, v31, v32, v33, v34, v35, v36, v37);
    local u38 = (Position - p) / p17;
    local v39, v40 = (CFrame_new_ret2 * CFrame_new_ret3:inverse()):ToAxisAngle();
    local u41 = v39 * v40 / p17;

    return {
        extrapolate = function(p42) -- Line: 58, Name: extrapolate
            -- upvalues: u38 (copy), Position (copy), u41 (copy), CFrame_new_ret (ref), CFrame_new_ret2 (copy)
            local v43 = u41 * p42;
            local Magnitude = v43.Magnitude;
            local v44;

            if Magnitude > 0.00001 then
                v44 = CFrame.fromAxisAngle(v43, Magnitude);
            else
                v44 = CFrame_new_ret;
            end;

            return v44 * CFrame_new_ret2 + (u38 * p42 + Position);
        end,

        posVelocity = u38,
        rotVelocity = u41
    };
end;

function u1.Reset(p45) -- Line: 71
    p45.lastCFrame = nil;
end;

local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"));
local u46 = setmetatable({}, BaseOcclusion);
u46.__index = u46;

function u46.new() -- Line: 81
    -- upvalues: BaseOcclusion (copy), u46 (copy), u1 (copy)
    local v47 = BaseOcclusion.new();
    local v48 = setmetatable(v47, u46);
    v48.focusExtrapolator = u1.new();

    return v48;
end;

function u46.GetOcclusionMode(p49) -- Line: 87
    return Enum.DevCameraOcclusionMode.Zoom;
end;

function u46.Enable(p50, p51) -- Line: 91
    p50.focusExtrapolator:Reset();
end;

function u46.Update(p52, p53, p54, p55, p56) -- Line: 95
    -- upvalues: LocalPlayer (copy), UserFlag (copy), ZoomController (copy)
    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return p54, p55;
    end;

    local v57;

    if UserFlag then
        v57 = CFrame.lookAlong(p55.p, -p54.LookVector) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1);
    else
        v57 = CFrame.new(p55.p, p54.p) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1);
    end;

    local v58 = p52.focusExtrapolator:Step(p53, v57);
    local v59 = ZoomController.Update(p53, v57, v58);

    return v57 * CFrame.new(0, 0, v59), p55;
end;

function u46.CharacterAdded(p60, p61, p62) -- Line: 124
end;

function u46.CharacterRemoving(p63, p64, p65) -- Line: 128
end;

function u46.OnCameraSubjectChanged(p66, p67) -- Line: 131
end;

return u46;