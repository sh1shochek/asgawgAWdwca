-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local HapticService = game:GetService("HapticService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local u2 = {};
local u3 = nil;

local function IsVibrationsEnabled() -- Line: 32
    -- upvalues: UserInputService (copy), DataController (copy), LocalPlayer (copy)
    local v4 = UserInputService:GetLastInputType() == Enum.UserInputType.Touch and "Mobile" or "Controller";
    local v5 = DataController.Get(LocalPlayer, "Settings.Game.Other." .. v4 .. " Haptics/Vibrations");
    local v6;

    if v5 == nil then
        v6 = false;
    else
        v6 = v5 ~= false;
    end;

    return v6;
end;

local function updateQueue(p7: number) -- Line: 41
    -- upvalues: u2 (copy), HapticService (copy), u3 (ref)
    for i, v in pairs(u2) do
        v.Length = v.Length - p7;

        if HapticService:IsMotorSupported(v.InputMotor, i) then
            HapticService:SetMotor(v.InputMotor, i, v.Intensity);
        end;

        if v.Length <= 0 then
            HapticService:SetMotor(v.InputMotor, i, 0);
            u2[i] = nil;
        end;
    end;

    if next(u2) == nil and u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

function v1.vibrate(p8: any, p9: number, p10: number) -- Line: 64
    -- upvalues: UserInputService (copy), DataController (copy), LocalPlayer (copy), u2 (copy), u3 (ref), RunServiceController (copy), updateQueue (copy)
    local v11 = UserInputService:GetLastInputType() == Enum.UserInputType.Touch and "Mobile" or "Controller";
    local v12 = DataController.Get(LocalPlayer, "Settings.Game.Other." .. v11 .. " Haptics/Vibrations");
    local v13;

    if v12 == nil then
        v13 = false;
    else
        v13 = v12 ~= false;
    end;

    if not v13 then
        return;
    end;

    local Gamepad1 = Enum.UserInputType.Gamepad1;
    local v14 = u2[p8];

    if v14 then
        v14.InputMotor = Gamepad1;

        if v14.Length < p10 then
            v14.Length = p10;
        end;

        if v14.Intensity < p9 then
            v14.Intensity = p9;
        end;
    else
        u2[p8] = {
            InputMotor = Gamepad1,
            Intensity = p9,
            Length = p10
        };
    end;

    if not u3 then
        u3 = RunServiceController.BindToRenderStep("HapticsController.UpdateQueue", updateQueue);
    end;
end;

return v1;