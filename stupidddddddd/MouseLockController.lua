-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.MouseLockController
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.MouseLockController
-- Decompile time: 2.72 ms

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
require(CommonUtils:WaitForChild("FlagUtil"))
local Value = Enum.ContextActionPriority.Medium.Value
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local GameSettings = UserSettings().GameSettings
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local u36 = {}
u36.__index = u36

function u36.new() -- Line: 31 -- upvalues: u36 (val), GameSettings (val), Players (val)
    local u3 = setmetatable({}, u36)
    u3.isMouseLocked = false
    u3.savedMouseCursor = nil
    u3.boundKeys = {Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift}
    u3.mouseLockToggledEvent = Instance.new("BindableEvent")
    local BoundKeys = script:FindFirstChild("BoundKeys")
    if not BoundKeys or not BoundKeys:IsA("StringValue") then
        if BoundKeys then
            BoundKeys:Destroy()
        end
        BoundKeys = Instance.new("StringValue")
        assert(BoundKeys, "")
        BoundKeys.Name = "BoundKeys"
        BoundKeys.Value = "LeftShift,RightShift"
        BoundKeys.Parent = script
    end
    if BoundKeys then
        BoundKeys.Changed:Connect(function(a1) -- Line: 56 -- upvalues: u3 (val)
            u3:OnBoundKeysObjectChanged(a1)
        end)
        u3:OnBoundKeysObjectChanged(BoundKeys.Value)
    end
    GameSettings.Changed:Connect(function(a1) -- Line: 63 -- upvalues: u3 (val)
        if a1 == "ControlMode" or a1 == "ComputerMovementMode" then
            u3:UpdateMouseLockAvailability()
        end
    end)
    ;(Players.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock")):Connect(function() -- Line: 70 -- upvalues: u3 (val)
        u3:UpdateMouseLockAvailability()
    end)
    ;(Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode")):Connect(function() -- Line: 75 -- upvalues: u3 (val)
        u3:UpdateMouseLockAvailability()
    end)
    u3:UpdateMouseLockAvailability()
    return u3
end

function u36.GetIsMouseLocked(a1) -- Line: 84
    return a1.isMouseLocked
end

function u36.GetBindableToggleEvent(a1) -- Line: 88
    return a1.mouseLockToggledEvent.Event
end

function u36.GetMouseLockOffset(a1) -- Line: 92
    return (Vector3.new(1.75, 0, 0))
end

function u36:UpdateMouseLockAvailability() -- Line: 96 -- upvalues: Players (val), GameSettings (val)
    local DevEnableMouseLock = Players.LocalPlayer.DevEnableMouseLock
    local v1 = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
    local v2 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
    local v3 = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
    local v4 = DevEnableMouseLock and v2 and not v3 and not v1
    if v4 ~= self.enabled then
        self:EnableMouseLock(v4)
    end
end

function u36:OnBoundKeysObjectChanged(a2) -- Line: 108 -- types: self: table, a2: string
    self.boundKeys = {}
    local v1 = self
    for i in string.gmatch(a2, "[^%s,]+") do
        for k, v in pairs(Enum.KeyCode:GetEnumItems()) do
            if i == v.Name then
                v1.boundKeys[#v1.boundKeys + 1] = v
                break
            end
        end
    end
    v1:UnbindContextActions()
    v1:BindContextActions()
end

function u36:OnMouseLockToggled() -- Line: 123 -- upvalues: CameraUtils (val)
    self.isMouseLocked = not self.isMouseLocked
    if not self.isMouseLocked then
        CameraUtils.restoreMouseIcon()
    else
        local CursorImage = script:FindFirstChild("CursorImage")
        if not CursorImage or not CursorImage:IsA("StringValue") or not CursorImage.Value then
            if CursorImage then
                CursorImage:Destroy()
            end
            local v1 = Instance.new("StringValue")
            assert(v1, "")
            v1.Name = "CursorImage"
            v1.Value = "rbxasset://textures/MouseLockedCursor.png"
            v1.Parent = script
            CameraUtils.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png")
        else
            CameraUtils.setMouseIconOverride(CursorImage.Value)
        end
    end
    self.mouseLockToggledEvent:Fire()
end

function u36:DoMouseLockSwitch(a2, a3, a4) -- Line: 148
    if a3 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass
    end
    self:OnMouseLockToggled()
    return Enum.ContextActionResult.Sink
end

function u36:BindContextActions() -- Line: 156 -- upvalues: ContextActionService (val), Value (val)
    local v1 = ContextActionService
    local v2 = Value
    local boundKeys = self.boundKeys
    local v3 = unpack(boundKeys)
    v1:BindActionAtPriority("MouseLockSwitchAction", function(a1, a2, a3) -- Line: 157 -- upvalues: self (val)
        return self:DoMouseLockSwitch(a1, a2, a3)
    end, false, v2, v3)
end

function u36.UnbindContextActions(a1) -- Line: 162 -- upvalues: ContextActionService (val)
    ContextActionService:UnbindAction("MouseLockSwitchAction")
end

function u36.IsMouseLocked(a1) -- Line: 166
    return a1.enabled and a1.isMouseLocked
end

function u36:EnableMouseLock(a2) -- Line: 170 -- upvalues: CameraUtils (val) -- types: self: table, a2: boolean
    if a2 ~= self.enabled then
        self.enabled = a2
        if self.enabled then
            self:BindContextActions()
            return
        end
        CameraUtils.restoreMouseIcon()
        self:UnbindContextActions()
        if self.isMouseLocked then
            self.mouseLockToggledEvent:Fire()
        end
        self.isMouseLocked = false
    end
end

return u36