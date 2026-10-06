-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local GuiService = game:GetService("GuiService");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"));
local CharacterUtil = require(CommonUtils:WaitForChild("CharacterUtil"));
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"));
local u1 = setmetatable({}, BaseCharacterController);
u1.__index = u1;

function u1.new() -- Line: 50
    -- upvalues: BaseCharacterController (copy), u1 (copy), ConnectionUtil (copy)
    local v2 = BaseCharacterController.new();
    local v3 = setmetatable(v2, u1);
    v3.parentUIFrame = nil;
    v3.jumpButton = nil;
    v3.externallyEnabled = false;
    v3.isJumping = false;
    v3._active = false;
    v3._connectionUtil = ConnectionUtil.new();

    return v3;
end;

function u1._reset(p4) -- Line: 64
    p4.isJumping = false;
    p4.touchObject = nil;

    if p4.jumpButton then
        p4.jumpButton.ImageRectOffset = Vector2.new(1, 146);
    end;
end;

function u1.EnableButton(u5, p6) -- Line: 74
    -- upvalues: GuiService (copy)
    if p6 == u5._active then
        u5:_reset();

        return;
    end;

    if p6 then
        if not u5.jumpButton then
            u5:Create();
        end;

        u5.jumpButton.Visible = false;
        u5._connectionUtil:trackConnection("JUMP_INPUT_ENDED", u5.jumpButton.InputEnded:Connect(function(p7) -- Line: 92
            -- upvalues: u5 (copy)
            if p7 == u5.touchObject then
                u5:_reset();
            end;
        end));
        u5._connectionUtil:trackConnection("MENU_OPENED", GuiService.MenuOpened:Connect(function() -- Line: 102
            -- upvalues: u5 (copy)
            if u5.touchObject then
                u5:_reset();
            end;
        end));
    else
        if u5.jumpButton then
            u5.jumpButton.Visible = false;
        end;

        u5._connectionUtil:disconnect("JUMP_INPUT_ENDED");
        u5._connectionUtil:disconnect("MENU_OPENED");
    end;

    u5:_reset();
    u5._active = p6;
end;

function u1.UpdateEnabled(p8) -- Line: 119
    -- upvalues: CharacterUtil (copy)
    local Child = CharacterUtil.getChild("Humanoid", "Humanoid");

    if Child and (p8.externallyEnabled and (Child.JumpPower > 0 and Child:GetStateEnabled(Enum.HumanoidStateType.Jumping))) then
        p8:EnableButton(true);

        return;
    end;

    p8:EnableButton(false);
end;

function u1._setupConfigurations(u9) -- Line: 128
    -- upvalues: CharacterUtil (copy)
    local function update() -- Line: 129
        -- upvalues: u9 (copy)
        u9:UpdateEnabled();
    end;

    local v13 = CharacterUtil.onChild("Humanoid", "Humanoid", function(p10) -- Line: 134
        -- upvalues: u9 (copy), update (copy)
        u9:UpdateEnabled();
        u9._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", p10:GetPropertyChangedSignal("JumpPower"):Connect(update));
        u9._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", p10.StateEnabledChanged:Connect(function(p11, p12) -- Line: 142
            -- upvalues: u9 (ref)
            if p11 == Enum.HumanoidStateType.Jumping and p12 ~= u9._active then
                u9:UpdateEnabled();
            end;
        end));
    end);
    u9._connectionUtil:trackConnection("HUMANOID", v13);
end;

function u1.Enable(p14, p15, p16) -- Line: 154
    if p16 then
        p14.parentUIFrame = p16;
    end;

    if p14.externallyEnabled == p15 then
        return;
    end;

    p14.externallyEnabled = p15;
    p14:UpdateEnabled();

    if p15 then
        p14:_setupConfigurations();

        return;
    end;

    p14._connectionUtil:disconnectAll();
end;

function u1.Create(u17) -- Line: 171
    if not u17.parentUIFrame then
        return;
    end;

    if u17.jumpButton then
        u17.jumpButton:Destroy();
        u17.jumpButton = nil;
    end;

    if u17.absoluteSizeChangedConn then
        u17.absoluteSizeChangedConn:Disconnect();
        u17.absoluteSizeChangedConn = nil;
    end;

    u17.jumpButton = Instance.new("ImageButton");
    u17.jumpButton.Name = "JumpButton";
    u17.jumpButton.Visible = false;
    u17.jumpButton.BackgroundTransparency = 1;
    u17.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
    u17.jumpButton.ImageRectOffset = Vector2.new(1, 146);
    u17.jumpButton.ImageRectSize = Vector2.new(144, 144);

    local function ResizeJumpButton() -- Line: 194
        -- upvalues: u17 (copy)
        local v18 = math.min(u17.parentUIFrame.AbsoluteSize.x, u17.parentUIFrame.AbsoluteSize.y) <= 500;
        local v19 = v18 and 70 or 120;
        u17.jumpButton.Size = UDim2.new(0, v19, 0, v19);
        u17.jumpButton.Position = v18 and UDim2.new(1, -(v19 * 1.5 - 10), 1, -v19 - 20) or UDim2.new(1, -(v19 * 1.5 - 10), 1, -v19 * 1.75);
    end;

    ResizeJumpButton();
    u17.absoluteSizeChangedConn = u17.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeJumpButton);
    u17.touchObject = nil;
    u17.jumpButton.InputBegan:connect(function(p20) -- Line: 208
        -- upvalues: u17 (copy)
        if u17.touchObject or (p20.UserInputType ~= Enum.UserInputType.Touch or p20.UserInputState ~= Enum.UserInputState.Begin) then
            return;
        end;

        u17.touchObject = p20;
        u17.jumpButton.ImageRectOffset = Vector2.new(146, 146);
        u17.isJumping = true;
    end);
    u17.jumpButton.Parent = u17.parentUIFrame;
end;

return u1;