-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");
script.Parent.Parent:WaitForChild("CommonUtils");
local None = Enum.UserInputType.None;
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"));
local u1 = setmetatable({}, BaseCharacterController);
u1.__index = u1;

function u1.new(p2) -- Line: 23
    -- upvalues: BaseCharacterController (copy), u1 (copy), None (copy)
    local v3 = BaseCharacterController.new();
    local v4 = setmetatable(v3, u1);
    v4.CONTROL_ACTION_PRIORITY = p2;
    v4.forwardValue = 0;
    v4.backwardValue = 0;
    v4.leftValue = 0;
    v4.rightValue = 0;
    v4.activeGamepad = None;
    v4.gamepadConnectedConn = nil;
    v4.gamepadDisconnectedConn = nil;

    return v4;
end;

function u1.Enable(p5: table, p6: boolean) -- Line: 39
    -- upvalues: None (copy)
    if p6 == p5.enabled then
        return true;
    end;

    p5.forwardValue = 0;
    p5.backwardValue = 0;
    p5.leftValue = 0;
    p5.rightValue = 0;
    p5.moveVector = Vector3.new(0, 0, 0);
    p5.isJumping = false;

    if p6 then
        p5.activeGamepad = p5:GetHighestPriorityGamepad();

        if p5.activeGamepad == None then
            return false;
        end;

        p5:BindContextActions();
        p5:ConnectGamepadConnectionListeners();
    else
        p5:UnbindContextActions();
        p5:DisconnectGamepadConnectionListeners();
        p5.activeGamepad = None;
    end;

    p5.enabled = p6;

    return true;
end;

function u1.GetHighestPriorityGamepad(p7) -- Line: 75
    -- upvalues: UserInputService (copy), None (copy)
    local ConnectedGamepads = UserInputService:GetConnectedGamepads();
    local v8 = None;

    for _, v in pairs(ConnectedGamepads) do
        if v.Value < v8.Value then
            v8 = v;
        end;
    end;

    return v8;
end;

function u1.BindContextActions(u9) -- Line: 86
    -- upvalues: None (copy), ContextActionService (copy)
    if u9.activeGamepad == None then
        return false;
    end;

    ContextActionService:BindActivate(u9.activeGamepad, Enum.KeyCode.ButtonR2);
    ContextActionService:BindActionAtPriority("jumpAction", function(p10, p11, p12) -- Line: 93
        -- upvalues: u9 (copy)
        u9.isJumping = p11 == Enum.UserInputState.Begin;

        return Enum.ContextActionResult.Sink;
    end, false, u9.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA);
    ContextActionService:BindActionAtPriority("moveThumbstick", function(p13, p14, p15) -- Line: 98
        -- upvalues: u9 (copy)
        if p14 == Enum.UserInputState.Cancel then
            u9.moveVector = Vector3.new(0, 0, 0);

            return Enum.ContextActionResult.Sink;
        end;

        if u9.activeGamepad ~= p15.UserInputType then
            return Enum.ContextActionResult.Pass;
        end;

        if p15.KeyCode == Enum.KeyCode.Thumbstick1 then
            if p15.Position.magnitude > 0.2 then
                u9.moveVector = Vector3.new(p15.Position.X, 0, -p15.Position.Y);
            else
                u9.moveVector = Vector3.new(0, 0, 0);
            end;

            return Enum.ContextActionResult.Sink;
        end;
    end, false, u9.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1);

    return true;
end;

function u1.UnbindContextActions(p16) -- Line: 127
    -- upvalues: None (copy), ContextActionService (copy)
    if p16.activeGamepad ~= None then
        ContextActionService:UnbindActivate(p16.activeGamepad, Enum.KeyCode.ButtonR2);
    end;

    ContextActionService:UnbindAction("moveThumbstick");
    ContextActionService:UnbindAction("jumpAction");
end;

function u1.OnNewGamepadConnected(p17) -- Line: 135
    -- upvalues: None (copy)
    local HighestPriorityGamepad = p17:GetHighestPriorityGamepad();

    if HighestPriorityGamepad == p17.activeGamepad then
        return;
    end;

    if HighestPriorityGamepad == None then
        warn("Gamepad:OnNewGamepadConnected found no connected gamepads");
        p17:UnbindContextActions();

        return;
    end;

    if p17.activeGamepad ~= None then
        p17:UnbindContextActions();
    end;

    p17.activeGamepad = HighestPriorityGamepad;
    p17:BindContextActions();
end;

function u1.OnCurrentGamepadDisconnected(p18) -- Line: 162
    -- upvalues: None (copy), ContextActionService (copy)
    if p18.activeGamepad ~= None then
        ContextActionService:UnbindActivate(p18.activeGamepad, Enum.KeyCode.ButtonR2);
    end;

    local HighestPriorityGamepad = p18:GetHighestPriorityGamepad();

    if p18.activeGamepad == None or HighestPriorityGamepad ~= p18.activeGamepad then
        if HighestPriorityGamepad == None then
            p18:UnbindContextActions();
            p18.activeGamepad = None;

            return;
        end;

        p18.activeGamepad = HighestPriorityGamepad;
        ContextActionService:BindActivate(p18.activeGamepad, Enum.KeyCode.ButtonR2);

        return;
    end;

    warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.");
    p18:UnbindContextActions();
    p18.activeGamepad = None;
end;

function u1.ConnectGamepadConnectionListeners(u19) -- Line: 187
    -- upvalues: UserInputService (copy)
    u19.gamepadConnectedConn = UserInputService.GamepadConnected:Connect(function(p20) -- Line: 188
        -- upvalues: u19 (copy)
        u19:OnNewGamepadConnected();
    end);
    u19.gamepadDisconnectedConn = UserInputService.GamepadDisconnected:Connect(function(p21) -- Line: 192
        -- upvalues: u19 (copy)
        if u19.activeGamepad == p21 then
            u19:OnCurrentGamepadDisconnected();
        end;
    end);
end;

function u1.DisconnectGamepadConnectionListeners(p22) -- Line: 200
    if p22.gamepadConnectedConn then
        p22.gamepadConnectedConn:Disconnect();
        p22.gamepadConnectedConn = nil;
    end;

    if p22.gamepadDisconnectedConn then
        p22.gamepadDisconnectedConn:Disconnect();
        p22.gamepadDisconnectedConn = nil;
    end;
end;

return u1;