-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
UserSettings():GetService("UserGameSettings");
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"));
local u1 = setmetatable({}, BaseCharacterController);
u1.__index = u1;

function u1.new() -- Line: 20
    -- upvalues: BaseCharacterController (copy), u1 (copy)
    local v2 = BaseCharacterController.new();
    local v3 = setmetatable(v2, u1);
    v3.isFollowStick = false;
    v3.thumbstickFrame = nil;
    v3.moveTouchObject = nil;
    v3.onTouchMovedConn = nil;
    v3.onTouchEndedConn = nil;
    v3.screenPos = nil;
    v3.stickImage = nil;
    v3.thumbstickSize = nil;

    return v3;
end;

function u1.Enable(p4: table, p5: boolean?, p6: any) -- Line: 35
    if p5 == nil then
        return false;
    end;

    local v7 = p5 and true or false;

    if p4.enabled == v7 then
        return true;
    end;

    p4.moveVector = Vector3.new(0, 0, 0);
    p4.isJumping = false;

    if v7 then
        if not p4.thumbstickFrame then
            p4:Create(p6);
        end;

        p4.thumbstickFrame.Visible = true;
    else
        p4.thumbstickFrame.Visible = false;
        p4:OnInputEnded();
    end;

    p4.enabled = v7;
end;

function u1.OnInputEnded(p8) -- Line: 56
    p8.thumbstickFrame.Position = p8.screenPos;
    p8.stickImage.Position = UDim2.new(0, p8.thumbstickFrame.Size.X.Offset / 2 - p8.thumbstickSize / 4, 0, p8.thumbstickFrame.Size.Y.Offset / 2 - p8.thumbstickSize / 4);
    p8.moveVector = Vector3.new(0, 0, 0);
    p8.isJumping = false;
    p8.thumbstickFrame.Position = p8.screenPos;
    p8.moveTouchObject = nil;
end;

function u1.Create(u9, u10) -- Line: 65
    -- upvalues: UserInputService (copy), GuiService (copy)
    if u9.thumbstickFrame then
        u9.thumbstickFrame:Destroy();
        u9.thumbstickFrame = nil;

        if u9.onTouchMovedConn then
            u9.onTouchMovedConn:Disconnect();
            u9.onTouchMovedConn = nil;
        end;

        if u9.onTouchEndedConn then
            u9.onTouchEndedConn:Disconnect();
            u9.onTouchEndedConn = nil;
        end;

        if u9.absoluteSizeChangedConn then
            u9.absoluteSizeChangedConn:Disconnect();
            u9.absoluteSizeChangedConn = nil;
        end;
    end;

    u9.thumbstickFrame = Instance.new("Frame");
    u9.thumbstickFrame.Name = "ThumbstickFrame";
    u9.thumbstickFrame.Active = true;
    u9.thumbstickFrame.Visible = false;
    u9.thumbstickFrame.BackgroundTransparency = 1;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "OuterImage";
    ImageLabel.Image = "rbxasset://textures/ui/TouchControlsSheet.png";
    ImageLabel.ImageRectOffset = Vector2.new();
    ImageLabel.ImageRectSize = Vector2.new(220, 220);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Position = UDim2.new(0, 0, 0, 0);
    u9.stickImage = Instance.new("ImageLabel");
    u9.stickImage.Name = "StickImage";
    u9.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png";
    u9.stickImage.ImageRectOffset = Vector2.new(220, 0);
    u9.stickImage.ImageRectSize = Vector2.new(111, 111);
    u9.stickImage.BackgroundTransparency = 1;
    u9.stickImage.ZIndex = 2;

    local function ResizeThumbstick() -- Line: 105
        -- upvalues: u10 (copy), u9 (copy), ImageLabel (copy)
        local v11 = math.min(u10.AbsoluteSize.X, u10.AbsoluteSize.Y) <= 500;
        u9.thumbstickSize = v11 and 70 or 120;
        u9.screenPos = v11 and UDim2.new(0, u9.thumbstickSize / 2 - 10, 1, -u9.thumbstickSize - 20) or UDim2.new(0, u9.thumbstickSize / 2, 1, -u9.thumbstickSize * 1.75);
        u9.thumbstickFrame.Size = UDim2.new(0, u9.thumbstickSize, 0, u9.thumbstickSize);
        u9.thumbstickFrame.Position = u9.screenPos;
        ImageLabel.Size = UDim2.new(0, u9.thumbstickSize, 0, u9.thumbstickSize);
        u9.stickImage.Size = UDim2.new(0, u9.thumbstickSize / 2, 0, u9.thumbstickSize / 2);
        u9.stickImage.Position = UDim2.new(0, u9.thumbstickSize / 2 - u9.thumbstickSize / 4, 0, u9.thumbstickSize / 2 - u9.thumbstickSize / 4);
    end;

    ResizeThumbstick();
    u9.absoluteSizeChangedConn = u10:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick);
    ImageLabel.Parent = u9.thumbstickFrame;
    u9.stickImage.Parent = u9.thumbstickFrame;
    local u12 = nil;

    local function DoMove(p13) -- Line: 127
        -- upvalues: u9 (copy)
        local v14 = p13 / (u9.thumbstickSize / 2);
        local magnitude = v14.magnitude;
        local v15;

        if magnitude < 0.05 then
            v15 = Vector3.new();
        else
            local v16 = v14.unit * math.min(1, (magnitude - 0.05) / 0.95);
            v15 = Vector3.new(v16.X, 0, v16.Y);
        end;

        u9.moveVector = v15;
    end;

    local function MoveStick(p17: vector) -- Line: 145
        -- upvalues: u12 (ref), u9 (copy)
        local Vector2_new_ret = Vector2.new(p17.X - u12.X, p17.Y - u12.Y);
        local magnitude = Vector2_new_ret.magnitude;
        local v18 = u9.thumbstickFrame.AbsoluteSize.X / 2;

        if u9.isFollowStick and v18 < magnitude then
            local v19 = Vector2_new_ret.unit * v18;
            u9.thumbstickFrame.Position = UDim2.new(0, p17.X - u9.thumbstickFrame.AbsoluteSize.X / 2 - v19.X, 0, p17.Y - u9.thumbstickFrame.AbsoluteSize.Y / 2 - v19.Y);
        else
            local math_min_ret = math.min(magnitude, v18);
            Vector2_new_ret = Vector2_new_ret.unit * math_min_ret;
        end;

        u9.stickImage.Position = UDim2.new(0, Vector2_new_ret.X + u9.stickImage.AbsoluteSize.X / 2, 0, Vector2_new_ret.Y + u9.stickImage.AbsoluteSize.Y / 2);
    end;

    u9.thumbstickFrame.InputBegan:Connect(function(p20: userdata) -- Line: 162
        -- upvalues: u9 (copy), u12 (ref)
        if u9.moveTouchObject or (p20.UserInputType ~= Enum.UserInputType.Touch or p20.UserInputState ~= Enum.UserInputState.Begin) then
            return;
        end;

        u9.moveTouchObject = p20;
        u9.thumbstickFrame.Position = UDim2.new(0, p20.Position.X - u9.thumbstickFrame.Size.X.Offset / 2, 0, p20.Position.Y - u9.thumbstickFrame.Size.Y.Offset / 2);
        u12 = Vector2.new(u9.thumbstickFrame.AbsolutePosition.X + u9.thumbstickFrame.AbsoluteSize.X / 2, u9.thumbstickFrame.AbsolutePosition.Y + u9.thumbstickFrame.AbsoluteSize.Y / 2);
        Vector2.new(p20.Position.X - u12.X, p20.Position.Y - u12.Y);
    end);
    u9.onTouchMovedConn = UserInputService.TouchMoved:Connect(function(p21: userdata, p22: boolean) -- Line: 177
        -- upvalues: u9 (copy), u12 (ref), MoveStick (copy)
        if p21 == u9.moveTouchObject then
            u12 = Vector2.new(u9.thumbstickFrame.AbsolutePosition.X + u9.thumbstickFrame.AbsoluteSize.X / 2, u9.thumbstickFrame.AbsolutePosition.Y + u9.thumbstickFrame.AbsoluteSize.Y / 2);
            local v23 = Vector2.new(p21.Position.X - u12.X, p21.Position.Y - u12.Y) / (u9.thumbstickSize / 2);
            local magnitude = v23.magnitude;
            local v24;

            if magnitude < 0.05 then
                v24 = Vector3.new();
            else
                local v25 = v23.unit * math.min(1, (magnitude - 0.05) / 0.95);
                v24 = Vector3.new(v25.X, 0, v25.Y);
            end;

            u9.moveVector = v24;
            MoveStick(p21.Position);
        end;
    end);
    u9.onTouchEndedConn = UserInputService.TouchEnded:Connect(function(p26, p27) -- Line: 187
        -- upvalues: u9 (copy)
        if p26 == u9.moveTouchObject then
            u9:OnInputEnded();
        end;
    end);
    GuiService.MenuOpened:Connect(function() -- Line: 193
        -- upvalues: u9 (copy)
        if u9.moveTouchObject then
            u9:OnInputEnded();
        end;
    end);
    u9.thumbstickFrame.Parent = u10;
end;

return u1;