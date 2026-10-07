-- ReplicatedStorage.Controllers.HapticsController
-- Script path: ReplicatedStorage.Controllers.HapticsController
-- Decompile time: 1.27 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HapticService = game:GetService("HapticService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local u30 = {}
local u31 = nil

local function IsVibrationsEnabled() -- Line: 32
    -- upvalues: UserInputService (val), DataController (val), LocalPlayer (val)
    local v1 = DataController.Get(
        LocalPlayer,
        "Settings.Game.Other." .. (if not ((UserInputService:GetLastInputType()) == Enum.UserInputType.Touch) then "Controller" else "Mobile") .. " Haptics/Vibrations"
    )
    local v2 = false
    if v1 ~= nil then
        v2 = v1 ~= false
    end
    return v2
end

local function updateQueue(a1) -- Line: 41 -- upvalues: u30 (val), HapticService (val), u31 (ref) -- types: a1: number
    local InputMotor_2, Intensity, v1
    for k, v in pairs(u30) do
        v.Length = v.Length - a1
        v1 = HapticService
        if v1:IsMotorSupported(v.InputMotor, k) then
            v1 = HapticService
            InputMotor_2 = v.InputMotor
            Intensity = v.Intensity
            v1:SetMotor(InputMotor_2, k, Intensity)
        end
        if v.Length <= 0 then
            HapticService:SetMotor(v.InputMotor, k, 0)
            u30[k] = nil
        end
    end
    if next(u30) == nil and u31 then
        u31:Disconnect()
        u31 = nil
    end
end

function v1.vibrate(a1, a2, a3) -- Line: 64
    -- upvalues: UserInputService (val), DataController (val), LocalPlayer (val), u30 (val), u31 (ref)
    -- upvalues: RunServiceController (val), updateQueue (val)
    local v1 = DataController.Get(
        LocalPlayer,
        "Settings.Game.Other." .. (if not ((UserInputService:GetLastInputType()) == Enum.UserInputType.Touch) then "Controller" else "Mobile") .. " Haptics/Vibrations"
    )
    local v2 = false
    if v1 ~= nil then
        v2 = v1 ~= false
    end
    if not v2 then
        return
    end
    local Gamepad1 = Enum.UserInputType.Gamepad1
    local v3 = u30[a1]
    if not v3 then
        u30[a1] = {InputMotor = Gamepad1, Intensity = a2, Length = a3}
    else
        v3.InputMotor = Gamepad1
        if v3.Length < a3 then
            v3.Length = a3
        end
        if v3.Intensity < a2 then
            v3.Intensity = a2
        end
    end
    if not u31 then
        u31 = RunServiceController.BindToRenderStep("HapticsController.UpdateQueue", updateQueue)
    end
end

return v1