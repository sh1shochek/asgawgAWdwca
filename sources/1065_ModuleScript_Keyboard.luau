-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");
script.Parent.Parent:WaitForChild("CommonUtils");
local Vector3_new_ret = Vector3.new();
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"));
local u1 = setmetatable({}, BaseCharacterController);
u1.__index = u1;

function u1.new(p2) -- Line: 25
    -- upvalues: BaseCharacterController (copy), u1 (copy)
    local v3 = BaseCharacterController.new();
    local v4 = setmetatable(v3, u1);
    v4.CONTROL_ACTION_PRIORITY = p2;
    v4.forwardValue = 0;
    v4.backwardValue = 0;
    v4.leftValue = 0;
    v4.rightValue = 0;
    v4.jumpEnabled = true;

    return v4;
end;

function u1.Enable(p5: table, p6: boolean) -- Line: 40
    -- upvalues: Vector3_new_ret (copy)
    if p6 == p5.enabled then
        return true;
    end;

    p5.forwardValue = 0;
    p5.backwardValue = 0;
    p5.leftValue = 0;
    p5.rightValue = 0;
    p5.moveVector = Vector3_new_ret;
    p5.jumpRequested = false;
    p5:UpdateJump();

    if p6 then
        p5:BindContextActions();
        p5:ConnectFocusEventListeners();
    else
        p5._connectionUtil:disconnectAll();
    end;

    p5.enabled = p6;

    return true;
end;

function u1.UpdateMovement(p7, p8) -- Line: 67
    -- upvalues: Vector3_new_ret (copy)
    if p8 == Enum.UserInputState.Cancel then
        p7.moveVector = Vector3_new_ret;

        return;
    end;

    p7.moveVector = Vector3.new(p7.leftValue + p7.rightValue, 0, p7.forwardValue + p7.backwardValue);
end;

function u1.UpdateJump(p9) -- Line: 75
    p9.isJumping = p9.jumpRequested;
end;

function u1.BindContextActions(u10) -- Line: 79
    -- upvalues: ContextActionService (copy)
    ContextActionService:BindActionAtPriority("moveForwardAction", function(p11, p12, p13) -- Line: 84
        -- upvalues: u10 (copy)
        u10.forwardValue = p12 == Enum.UserInputState.Begin and -1 or 0;
        u10:UpdateMovement(p12);

        return Enum.ContextActionResult.Pass;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterForward);
    ContextActionService:BindActionAtPriority("moveBackwardAction", function(p14, p15, p16) -- Line: 90
        -- upvalues: u10 (copy)
        u10.backwardValue = p15 == Enum.UserInputState.Begin and 1 or 0;
        u10:UpdateMovement(p15);

        return Enum.ContextActionResult.Pass;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterBackward);
    ContextActionService:BindActionAtPriority("moveLeftAction", function(p17, p18, p19) -- Line: 96
        -- upvalues: u10 (copy)
        u10.leftValue = p18 == Enum.UserInputState.Begin and -1 or 0;
        u10:UpdateMovement(p18);

        return Enum.ContextActionResult.Pass;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterLeft);
    ContextActionService:BindActionAtPriority("moveRightAction", function(p20, p21, p22) -- Line: 102
        -- upvalues: u10 (copy)
        u10.rightValue = p21 == Enum.UserInputState.Begin and 1 or 0;
        u10:UpdateMovement(p21);

        return Enum.ContextActionResult.Pass;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterRight);
    ContextActionService:BindActionAtPriority("jumpAction", function(p23, p24, p25) -- Line: 108
        -- upvalues: u10 (copy)
        u10.jumpRequested = u10.jumpEnabled and p24 == Enum.UserInputState.Begin;
        u10:UpdateJump();

        return Enum.ContextActionResult.Pass;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterJump);
    u10._connectionUtil:trackBoundFunction("moveForwardAction", function() -- Line: 152
        -- upvalues: ContextActionService (ref)
        ContextActionService:UnbindAction("moveForwardAction");
    end);
    u10._connectionUtil:trackBoundFunction("moveBackwardAction", function() -- Line: 155
        -- upvalues: ContextActionService (ref)
        ContextActionService:UnbindAction("moveBackwardAction");
    end);
    u10._connectionUtil:trackBoundFunction("moveLeftAction", function() -- Line: 158
        -- upvalues: ContextActionService (ref)
        ContextActionService:UnbindAction("moveLeftAction");
    end);
    u10._connectionUtil:trackBoundFunction("moveRightAction", function() -- Line: 161
        -- upvalues: ContextActionService (ref)
        ContextActionService:UnbindAction("moveRightAction");
    end);
    u10._connectionUtil:trackBoundFunction("jumpAction", function() -- Line: 164
        -- upvalues: ContextActionService (ref)
        ContextActionService:UnbindAction("jumpAction");
    end);
end;

function u1.ConnectFocusEventListeners(u26) -- Line: 169
    -- upvalues: Vector3_new_ret (copy), UserInputService (copy)
    local function onFocusReleased() -- Line: 170
        -- upvalues: u26 (copy), Vector3_new_ret (ref)
        u26.moveVector = Vector3_new_ret;
        u26.forwardValue = 0;
        u26.backwardValue = 0;
        u26.leftValue = 0;
        u26.rightValue = 0;
        u26.jumpRequested = false;
        u26:UpdateJump();
    end;

    u26._connectionUtil:trackConnection("textBoxFocusReleased", UserInputService.TextBoxFocusReleased:Connect(onFocusReleased));
    u26._connectionUtil:trackConnection("textBoxFocused", UserInputService.TextBoxFocused:Connect(function(p27) -- Line: 180, Name: onTextFocusGained
        -- upvalues: u26 (copy)
        u26.jumpRequested = false;
        u26:UpdateJump();
    end));
    u26._connectionUtil:trackConnection("windowFocusReleased", UserInputService.WindowFocusReleased:Connect(onFocusReleased));
end;

return u1;