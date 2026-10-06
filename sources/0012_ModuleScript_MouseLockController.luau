-- Decompiled with Potassium's decompiler.

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
require(CommonUtils:WaitForChild("FlagUtil"));
local Value = Enum.ContextActionPriority.Medium.Value;
local Players = game:GetService("Players");
local ContextActionService = game:GetService("ContextActionService");
local GameSettings = UserSettings().GameSettings;
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 31
    -- upvalues: u1 (copy), GameSettings (copy), Players (copy)
    local u2 = setmetatable({}, u1);
    u2.isMouseLocked = false;
    u2.savedMouseCursor = nil;
    u2.boundKeys = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift };
    u2.mouseLockToggledEvent = Instance.new("BindableEvent");
    local BoundKeys = script:FindFirstChild("BoundKeys");

    if not (BoundKeys and BoundKeys:IsA("StringValue")) then
        if BoundKeys then
            BoundKeys:Destroy();
        end;

        BoundKeys = Instance.new("StringValue");
        assert(BoundKeys, "");
        BoundKeys.Name = "BoundKeys";
        BoundKeys.Value = "LeftShift,RightShift";
        BoundKeys.Parent = script;
    end;

    if BoundKeys then
        BoundKeys.Changed:Connect(function(p3) -- Line: 56
            -- upvalues: u2 (copy)
            u2:OnBoundKeysObjectChanged(p3);
        end);
        u2:OnBoundKeysObjectChanged(BoundKeys.Value);
    end;

    GameSettings.Changed:Connect(function(p4) -- Line: 63
        -- upvalues: u2 (copy)
        if p4 == "ControlMode" or p4 == "ComputerMovementMode" then
            u2:UpdateMouseLockAvailability();
        end;
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function() -- Line: 70
        -- upvalues: u2 (copy)
        u2:UpdateMouseLockAvailability();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- Line: 75
        -- upvalues: u2 (copy)
        u2:UpdateMouseLockAvailability();
    end);
    u2:UpdateMouseLockAvailability();

    return u2;
end;

function u1.GetIsMouseLocked(p5) -- Line: 84
    return p5.isMouseLocked;
end;

function u1.GetBindableToggleEvent(p6) -- Line: 88
    return p6.mouseLockToggledEvent.Event;
end;

function u1.GetMouseLockOffset(p7) -- Line: 92
    return Vector3.new(1.75, 0, 0);
end;

function u1.UpdateMouseLockAvailability(p8) -- Line: 96
    -- upvalues: Players (copy), GameSettings (copy)
    local v9 = Players.LocalPlayer.DevEnableMouseLock and (GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove) and not (Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable);

    if v9 ~= p8.enabled then
        p8:EnableMouseLock(v9);
    end;
end;

function u1.OnBoundKeysObjectChanged(p10: table, p11: string) -- Line: 108
    p10.boundKeys = {};

    for i in string.gmatch(p11, "[^%s,]+") do
        local v12 = i;

        for _, v in pairs(Enum.KeyCode:GetEnumItems()) do
            if v12 == v.Name then
                p10.boundKeys[#p10.boundKeys + 1] = v;
                break;
            end;
        end;
    end;

    p10:UnbindContextActions();
    p10:BindContextActions();
end;

function u1.OnMouseLockToggled(p13) -- Line: 123
    -- upvalues: CameraUtils (copy)
    p13.isMouseLocked = not p13.isMouseLocked;

    if p13.isMouseLocked then
        local CursorImage = script:FindFirstChild("CursorImage");

        if CursorImage and (CursorImage:IsA("StringValue") and CursorImage.Value) then
            CameraUtils.setMouseIconOverride(CursorImage.Value);
        else
            if CursorImage then
                CursorImage:Destroy();
            end;

            local StringValue = Instance.new("StringValue");
            assert(StringValue, "");
            StringValue.Name = "CursorImage";
            StringValue.Value = "rbxasset://textures/MouseLockedCursor.png";
            StringValue.Parent = script;
            CameraUtils.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png");
        end;
    else
        CameraUtils.restoreMouseIcon();
    end;

    p13.mouseLockToggledEvent:Fire();
end;

function u1.DoMouseLockSwitch(p14, p15, p16, p17) -- Line: 148
    if p16 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass;
    end;

    p14:OnMouseLockToggled();

    return Enum.ContextActionResult.Sink;
end;

function u1.BindContextActions(u18) -- Line: 156
    -- upvalues: ContextActionService (copy), Value (copy)
    ContextActionService:BindActionAtPriority("MouseLockSwitchAction", function(p19, p20, p21) -- Line: 157
        -- upvalues: u18 (copy)
        return u18:DoMouseLockSwitch(p19, p20, p21);
    end, false, Value, unpack(u18.boundKeys));
end;

function u1.UnbindContextActions(p22) -- Line: 162
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("MouseLockSwitchAction");
end;

function u1.IsMouseLocked(p23) -- Line: 166
    return p23.enabled and p23.isMouseLocked;
end;

function u1.EnableMouseLock(p24: table, p25: boolean) -- Line: 170
    -- upvalues: CameraUtils (copy)
    if p25 ~= p24.enabled then
        p24.enabled = p25;

        if p24.enabled then
            p24:BindContextActions();

            return;
        end;

        CameraUtils.restoreMouseIcon();
        p24:UnbindContextActions();

        if p24.isMouseLocked then
            p24.mouseLockToggledEvent:Fire();
        end;

        p24.isMouseLocked = false;
    end;
end;

return u1;