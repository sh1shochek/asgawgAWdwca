-- ReplicatedStorage.GameClient.Gui.HUD.Scope
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Scope
-- Decompile time: 13.14 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
game:GetService("TweenService");
game:GetService("HttpService");
local RunService = game:GetService("RunService");
local _ = Players.LocalPlayer;
local _ = workspace.CurrentCamera;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = 0;
local u11 = 1;
local u12 = 0;
local u13 = 0;
local u14 = 70;
local u15 = 70;
local u16 = 70;
local u17 = 25;
local u18 = 40;
local u19 = 70;
local u20 = true;
local u21 = false;

function u1.Draw() -- Line: 48
    -- upvalues: u19 (ref), u10 (ref), u17 (ref), u18 (ref), u20 (ref), u3 (ref), RunService (copy), u1 (copy)
    u19 = u10 > 1 and u17 or u18;

    if u20 then
        u3:Add("PostSimulation", RunService.PostSimulation:Connect(u1.Update));
        Scope.Center.Size = UDim2.fromScale(0.9, 0.9);
        u1.LineCheck();
        u20 = false;
    end;
end;

function u1.LineCheck() -- Line: 62
    -- upvalues: u9 (ref)
    local v22 = UserSettings().GameSettings.SavedQualityLevel.Value >= 4 and 1 or 2;

    if u9.AbsoluteSize.Y > 1200 or u9.AbsoluteSize.X > 2000 then
        v22 = v22 + 2;
    end;

    Scope.Line.Vertical.Size = UDim2.new(0, v22, 0.05, 0);
    Scope.Line.Horizontal.Size = UDim2.new(0.05, 0, 0, v22);
    Scope.Line.Vertical.Bottom.Size = UDim2.new(0, v22, 1000, 0);
    Scope.Line.Vertical.Top.Size = UDim2.new(0, v22, 1000, 0);
    Scope.Line.Horizontal.Left.Size = UDim2.new(0, 1000, 0, v22);
    Scope.Line.Horizontal.Right.Size = UDim2.new(0, 1000, 0, v22);
end;

function u1.Update(p23) -- Line: 78
    -- upvalues: u10 (ref), u21 (ref), u12 (ref), u11 (ref), u18 (ref), u17 (ref), u14 (ref), u13 (ref), u16 (ref), u15 (ref), u19 (ref), u7 (ref)
    if u10 == 0 or (not Scope.Visible or (BindsController.FramePriority.MainMenu or u21)) then
        return;
    end;

    u12 = math.clamp(u12, 0, 1);
    u11 = math.lerp(u11, u12, p23 * 10);
    local math_lerp_ret = math.lerp(0.9, 0.8, 1 - u11);
    Scope.Center.Size = UDim2.fromScale(math_lerp_ret, math_lerp_ret);
    Scope.BlurLine.GroupTransparency = math.clamp(1 - u11, 0, 0.7);
    Scope.Line.GroupTransparency = math.clamp((1 - u11) * 5, 0, 1);
    local math_lerp_ret2 = math.lerp(0.15, 0, u11);
    Scope.BlurLine.Vertical.Size = UDim2.fromScale(math_lerp_ret2, math_lerp_ret);
    Scope.BlurLine.Horizontal.Size = UDim2.fromScale(math_lerp_ret2, math_lerp_ret);
    local v24 = u18 and (u17 and u18 - u17) or 0;
    local v25 = v24 == 0 and 0.05 or (math.lerp(0.05, 0.01, (u14 - u17) / v24) or 0.05);
    Scope.Line.Vertical.Size = UDim2.new(0, Scope.Line.Vertical.Size.X.Offset, v25, 0);
    Scope.Line.Horizontal.Size = UDim2.new(v25, 0, 0, Scope.Line.Horizontal.Size.Y.Offset);
    u13 = math.min(u13 + p23, 0.05);
    local v26 = u13 / 0.05;
    u16 = math.lerp(u15, u19, v26 * v26 * (3 - v26 * 2));
    u7.SetFOVAmount(u16);
end;

function u1.Clear() -- Line: 114
    -- upvalues: u20 (ref), u11 (ref), u13 (ref), u15 (ref), u14 (ref), u16 (ref), u7 (ref), u3 (ref)
    u20 = true;
    u11 = 1;
    u13 = 0;
    u15 = u14;
    u16 = u14;

    if not BindsController.FramePriority.MainMenu then
        u7.SetFOVAmount(u14);
    end;

    u3:Remove("PostSimulation");
end;

function u1.Enabled(p27, p28) -- Line: 171
    -- upvalues: u10 (ref), u1 (copy)
    if not Scope then
        return;
    end;

    if p28 then
        Scope.Visible = false;
    else
        Scope.Visible = p27 or u10 > 0;
    end;

    if Scope.Visible then
        u1.Draw();

        return;
    end;

    u1.Clear();
end;

function u1.SetWeapon(p29, p30, p31) -- Line: 191
    -- upvalues: u10 (ref), u15 (ref), u16 (ref), u14 (ref), u13 (ref), u17 (ref), u18 (ref), u1 (copy)
    local v32 = p29 or 0;

    if v32 ~= u10 then
        u15 = u10 > 0 and u16 or u14;
        u13 = 0;
    end;

    u10 = v32;
    u17 = p31 or 25;
    u18 = p30 or 40;
    u1.Enabled();
end;

function u1.SetOffset(p33) -- Line: 207
    -- upvalues: u12 (ref)
    u12 = math.clamp(p33, 0, 1);
end;

function u1.SetBuymenuOpen(p34) -- Line: 213
    -- upvalues: u21 (ref), u13 (ref), u15 (ref), u14 (ref), u16 (ref), u7 (ref), u10 (ref), u1 (copy)
    u21 = p34;

    if not Scope then
        return;
    end;

    if not p34 then
        Scope.Visible = u10 > 0;

        if Scope.Visible then
            u1.Draw();
        end;

        return;
    end;

    Scope.Visible = false;
    u13 = 0;
    u15 = u14;
    u16 = u14;
    u7.SetFOVAmount(u14);
end;

function u1.Init(p35) -- Line: 237
    -- upvalues: u2 (ref), u5 (ref), u3 (ref), u6 (ref), u4 (ref), u7 (ref)
    u2 = p35:GetModule("Gui");
    u5 = p35:GetModule("WeaponController");
    u3 = p35:GetModule("Maid").new();
    u6 = p35:GetModule("WeaponManager");
    BindsController = p35:GetModule("BindsController");
    u4 = p35:GetModule("Math");
    u7 = p35:GetModule("CameraController");
end;

function u1.Start(p36) -- Line: 248
    -- upvalues: u2 (ref), u8 (ref), u9 (ref), u1 (copy), u3 (ref), u14 (ref)
    SettingsModule = u2.GetComponent("Settings");
    u8 = u2.GetComponent("Crosshair");
    u9 = u2.Handler;
    u1.new();
    u3:Add("SavedQualityLevel", UserSettings().GameSettings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function() -- Line: 257
        -- upvalues: u1 (ref)
        u1.LineCheck();
    end));
    SettingsModule:AddPlayerConnection("Game", "Gameplay", "Field Of View", function(p37) -- Line: 262
        -- upvalues: u14 (ref)
        u14 = p37;
    end);
end;

function u1.new() -- Line: 276
    -- upvalues: u9 (ref)
    Scope = Instance.new("Frame");
    Scope.Name = "Scope";
    Scope.AnchorPoint = Vector2.new(0.5, 0.5);
    Scope.BackgroundTransparency = 1;
    Scope.Position = UDim2.fromScale(0.5, 0.5);
    Scope.Size = UDim2.fromScale(1, 1);
    Scope.ZIndex = 0;
    Scope.Visible = false;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Center";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://113185216979037";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.ZIndex = 2;
    local Frame = Instance.new("Frame");
    Frame.Name = "Left";
    Frame.AnchorPoint = Vector2.new(1, 0.5);
    Frame.BackgroundColor3 = Color3.new();
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0, 0.5);
    Frame.Size = UDim2.fromScale(2, 1);
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame.Parent = ImageLabel;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Right";
    Frame2.AnchorPoint = Vector2.new(0, 0.5);
    Frame2.BackgroundColor3 = Color3.new();
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(1, 0.5);
    Frame2.Size = UDim2.fromScale(2, 1);
    Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame2.Parent = ImageLabel;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Top";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 0);
    Frame3.Size = UDim2.fromScale(5, 0.5);
    Frame3.Parent = ImageLabel;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Bottom";
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.BackgroundColor3 = Color3.new();
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0.5, 1);
    Frame4.Size = UDim2.fromScale(5, 0.5);
    Frame4.Parent = ImageLabel;
    ImageLabel.Parent = Scope;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "BlurLine";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Vertical";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://104255695771233";
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.Size = UDim2.fromScale(0.02, 0.9);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.TileSize = UDim2.fromScale(0.2, 1);
    ImageLabel2.ZIndex = 2;
    ImageLabel2.Parent = CanvasGroup;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Horizontal";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://104255695771233";
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel3.Rotation = 90;
    ImageLabel3.Size = UDim2.fromScale(0.02, 0.9);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.TileSize = UDim2.fromScale(0.2, 1);
    ImageLabel3.ZIndex = 2;
    ImageLabel3.Parent = CanvasGroup;
    CanvasGroup.Parent = Scope;
    local CanvasGroup2 = Instance.new("CanvasGroup");
    CanvasGroup2.Name = "Line";
    CanvasGroup2.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup2.BackgroundTransparency = 1;
    CanvasGroup2.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup2.Size = UDim2.fromScale(1, 1);
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Vertical";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.BackgroundColor3 = Color3.new();
    Frame5.BackgroundTransparency = 0.8;
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.fromScale(0.5, 0.5);
    Frame5.Size = UDim2.new(0, 1, 0.05, 0);
    Frame5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Bottom";
    Frame6.AnchorPoint = Vector2.new(0.5, 0);
    Frame6.BackgroundColor3 = Color3.new();
    Frame6.BorderColor3 = Color3.new();
    Frame6.BorderSizePixel = 0;
    Frame6.Position = UDim2.fromScale(0.5, 1);
    Frame6.Size = UDim2.new(0, 1, 1000, 0);
    Frame6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame6.Parent = Frame5;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Top";
    Frame7.AnchorPoint = Vector2.new(0.5, 1);
    Frame7.BackgroundColor3 = Color3.new();
    Frame7.BorderColor3 = Color3.new();
    Frame7.BorderSizePixel = 0;
    Frame7.Position = UDim2.fromScale(0.5, 0);
    Frame7.Size = UDim2.new(0, 1, 1000, 0);
    Frame7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame7.Parent = Frame5;
    Frame5.Parent = CanvasGroup2;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Horizontal";
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame8.BackgroundColor3 = Color3.new();
    Frame8.BackgroundTransparency = 0.8;
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Position = UDim2.fromScale(0.5, 0.5);
    Frame8.Size = UDim2.new(0.05, 0, 0, 1);
    Frame8.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Left";
    Frame9.AnchorPoint = Vector2.new(1, 0.5);
    Frame9.BackgroundColor3 = Color3.new();
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.Position = UDim2.fromScale(0, 0.5);
    Frame9.Size = UDim2.fromOffset(1000, 1);
    Frame9.Parent = Frame8;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Right";
    Frame10.AnchorPoint = Vector2.new(0, 0.5);
    Frame10.BackgroundColor3 = Color3.new();
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.fromScale(1, 0.5);
    Frame10.Size = UDim2.fromOffset(1000, 1);
    Frame10.Parent = Frame8;
    Frame8.Parent = CanvasGroup2;
    CanvasGroup2.Parent = Scope;
    Scope.Parent = u9.HUD;
end;

return u1;