-- ReplicatedStorage.GameClient.Gui.HUD.DamageIndicator
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.DamageIndicator
-- Decompile time: 10.94 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local _ = Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local u2 = nil;
local u3 = {};
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = 0;
local u9 = 0;
local u10 = 0;
local u11 = 0;
local u12 = 0;
local TweenInfo_new_ret = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

local function IndicateDamage(u13: userdata, p14: number) -- Line: 51
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy)
    if p14 > 0 then
        u13.Visible = true;
        u13.ImageTransparency = 1 - p14 * 0.51;

        return;
    end;

    TweenService:Create(u13, TweenInfo_new_ret, {
        ImageTransparency = 1
    }):Play();
    task.delay(0.4, function() -- Line: 61
        -- upvalues: u13 (copy)
        if u13.ImageTransparency >= 0.99 then
            u13.Visible = false;
        end;
    end);
end;

local function CalcDamageDirection(p15: vector) -- Line: 69
    -- upvalues: workspace_CurrentCamera (copy), u8 (ref), u9 (ref), u11 (ref), u10 (ref)
    local CFrame = workspace_CurrentCamera.CFrame;
    local v16 = p15 - CFrame.Position;

    if v16.Magnitude <= 3.47 then
        u8 = 1;
        u9 = 1;
        u11 = 1;
        u10 = 1;

        return;
    end;

    local Unit = v16.Unit;
    local RightVector = CFrame.RightVector;
    local v17 = Unit:Dot(CFrame.LookVector);
    local v18 = Unit:Dot(RightVector);

    if v17 > 0 then
        if v17 > 0.3 then
            u8 = math.max(u8, v17);
        end;
    else
        local math_abs_ret = math.abs(v17);

        if math_abs_ret > 0.3 then
            u9 = math.max(u9, math_abs_ret);
        end;
    end;

    if v18 > 0 then
        if v18 > 0.3 then
            u11 = math.max(u11, v18);
        end;
    else
        local math_abs_ret = math.abs(v18);

        if math_abs_ret > 0.3 then
            u10 = math.max(u10, math_abs_ret);
        end;
    end;
end;

local function ProcessInput(p19: number) -- Line: 115
    -- upvalues: u12 (ref), u8 (ref), IndicateDamage (copy), u3 (copy), u9 (ref), u10 (ref), u11 (ref), u7 (ref)
    if os.clock() < u12 then
        local v20 = p19 * 1.5;

        if u8 > 0 then
            u8 = math.max(0, u8 - v20);

            if u8 > 0.4 then
                IndicateDamage(u3[1], u8);
            else
                u8 = 0;
                IndicateDamage(u3[1], -1);
            end;
        end;

        if u9 > 0 then
            u9 = math.max(0, u9 - v20);

            if u9 > 0.4 then
                IndicateDamage(u3[3], u9);
            else
                u9 = 0;
                IndicateDamage(u3[3], -1);
            end;
        end;

        if u10 > 0 then
            u10 = math.max(0, u10 - v20);

            if u10 > 0.4 then
                IndicateDamage(u3[4], u10);
            else
                u10 = 0;
                IndicateDamage(u3[4], -1);
            end;
        end;

        if u11 > 0 then
            u11 = math.max(0, u11 - v20);

            if u11 > 0.4 then
                IndicateDamage(u3[2], u11);

                return;
            end;

            u11 = 0;
            IndicateDamage(u3[2], -1);
        end;
    else
        if u8 > 0 or (u9 > 0 or (u10 > 0 or u11 > 0)) then
            u8 = 0;
            u9 = 0;
            u11 = 0;
            u10 = 0;
            IndicateDamage(u3[1], -1);
            IndicateDamage(u3[2], -1);
            IndicateDamage(u3[3], -1);
            IndicateDamage(u3[4], -1);
        end;

        u7:Remove("RenderStep");
    end;
end;

local function HideAll() -- Line: 177
    -- upvalues: u8 (ref), u9 (ref), u11 (ref), u10 (ref), u12 (ref), u3 (copy), u7 (ref)
    u8 = 0;
    u9 = 0;
    u11 = 0;
    u10 = 0;
    u12 = 0;

    for _, v in u3 do
        v.ImageTransparency = 1;
        v.Visible = false;
    end;

    u7:Remove("RenderStep");
end;

function u1.Enabled(p21) -- Line: 192
    -- upvalues: u2 (ref), u8 (ref), u9 (ref), u11 (ref), u10 (ref), u12 (ref), u3 (copy), u7 (ref)
    u2.Visible = p21;

    if not p21 then
        u8 = 0;
        u9 = 0;
        u11 = 0;
        u10 = 0;
        u12 = 0;

        for _, v in u3 do
            v.ImageTransparency = 1;
            v.Visible = false;
        end;

        u7:Remove("RenderStep");
    end;
end;

function u1.Reset() -- Line: 200
    -- upvalues: u8 (ref), u9 (ref), u11 (ref), u10 (ref), u12 (ref), u3 (copy), u7 (ref)
    u8 = 0;
    u9 = 0;
    u11 = 0;
    u10 = 0;
    u12 = 0;

    for _, v in u3 do
        v.ImageTransparency = 1;
        v.Visible = false;
    end;

    u7:Remove("RenderStep");
end;

function u1.OnDamageReceived(p22: vector) -- Line: 204
    -- upvalues: u2 (ref), u12 (ref), CalcDamageDirection (copy), u7 (ref), RunService (copy), ProcessInput (copy)
    if not (u2 and u2.Visible) then
        return;
    end;

    u12 = os.clock() + 1.2;
    CalcDamageDirection(p22);
    u7:Add("RenderStep", RunService.RenderStepped:Connect(ProcessInput));
end;

function u1.Init(p23) -- Line: 214
    -- upvalues: u6 (ref), u4 (ref), u5 (ref), u7 (ref)
    u6 = p23:GetModule("Gui");
    u4 = p23:GetModule("CharacterController");
    u5 = p23:GetModule("Network");
    u7 = p23:GetModule("Maid").new();
end;

function u1.Start(p24) -- Line: 221
    -- upvalues: u1 (copy), u5 (ref), u4 (ref), u8 (ref), u9 (ref), u11 (ref), u10 (ref), u12 (ref), u3 (copy), u7 (ref)
    u1.new();
    u5.Gui.DamageIndicator.On(u1.OnDamageReceived);
    u4.OnCharacterDestroy:Connect(function() -- Line: 228
        -- upvalues: u8 (ref), u9 (ref), u11 (ref), u10 (ref), u12 (ref), u3 (ref), u7 (ref)
        u8 = 0;
        u9 = 0;
        u11 = 0;
        u10 = 0;
        u12 = 0;

        for _, v in u3 do
            v.ImageTransparency = 1;
            v.Visible = false;
        end;

        u7:Remove("RenderStep");
    end);
    u4.OnCharacterSpawn:Connect(function() -- Line: 232
        -- upvalues: u8 (ref), u9 (ref), u11 (ref), u10 (ref), u12 (ref), u3 (ref), u7 (ref)
        u8 = 0;
        u9 = 0;
        u11 = 0;
        u10 = 0;
        u12 = 0;

        for _, v in u3 do
            v.ImageTransparency = 1;
            v.Visible = false;
        end;

        u7:Remove("RenderStep");
    end);
end;

function u1.new() -- Line: 237
    -- upvalues: u2 (ref), u3 (copy), u6 (ref)
    u2 = Instance.new("Frame");
    u2.Name = "DamageIndicator";
    u2.AnchorPoint = Vector2.new(0.5, 0.5);
    u2.BackgroundTransparency = 1;
    u2.Position = UDim2.fromScale(0.5, 0.5);
    u2.Size = UDim2.fromScale(0.5, 0.5);
    u2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Top";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://107108797035321";
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.2);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 0.5);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel.Visible = false;
    ImageLabel.Parent = u2;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Right";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://107108797035321";
    ImageLabel2.ImageTransparency = 1;
    ImageLabel2.Position = UDim2.fromScale(0.8, 0.5);
    ImageLabel2.Rotation = 90;
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(1, 0.5);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel2.Visible = false;
    ImageLabel2.Parent = u2;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Bottom";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://107108797035321";
    ImageLabel3.ImageTransparency = 1;
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.8);
    ImageLabel3.Rotation = 180;
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(1, 0.5);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel3.Visible = false;
    ImageLabel3.Parent = u2;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Left";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://107108797035321";
    ImageLabel4.ImageTransparency = 1;
    ImageLabel4.Position = UDim2.fromScale(0.2, 0.5);
    ImageLabel4.Rotation = 270;
    ImageLabel4.ScaleType = Enum.ScaleType.Fit;
    ImageLabel4.Size = UDim2.fromScale(1, 0.5);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel4.Visible = false;
    ImageLabel4.Parent = u2;
    u3[1] = ImageLabel;
    u3[2] = ImageLabel2;
    u3[3] = ImageLabel3;
    u3[4] = ImageLabel4;
    u2.Parent = u6.Handler.HUD;
end;

return u1;