-- ReplicatedStorage.Controllers.CandyController.PickupFeed
-- Script path: ReplicatedStorage.Controllers.CandyController.PickupFeed
-- Decompile time: 6.62 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local SoundService = game:GetService("SoundService");
local GuiService = game:GetService("GuiService");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Font_new_ret = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Italic);
local Color3_fromRGB_ret = Color3.fromRGB(255, 205, 110);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 120, 20);
local NumberRange_new_ret = NumberRange.new(0.2, 0.8);
local NumberRange_new_ret2 = NumberRange.new(0.74, 0.88);
local Color3_fromRGB_ret3 = Color3.fromRGB(255, 130, 20);
local Color3_fromRGB_ret4 = Color3.fromRGB(255, 236, 190);
local Vector2_new_ret = Vector2.new(0.28363636363636363, 0.5);
local u2 = { 0, 2, 4, 7, 9, 12, 14, 16, 19 };
local LocalPlayer = Players.LocalPlayer;
local Random_new_ret = Random.new();
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = {};
local u8 = 1;
local u9 = 0;
local u10 = (-1 / 0);

local function now() -- Line: 113
    return os.clock();
end;

local function getGui() -- Line: 117
    -- upvalues: u6 (ref), LocalPlayer (copy)
    local v11 = u6;

    if v11 and v11.Parent then
        return v11;
    end;

    local v12 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v12 then
        return nil;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "CandyFeed";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 5;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Parent = v12;
    u6 = ScreenGui;

    return ScreenGui;
end;

local function makePopup() -- Line: 139
    -- upvalues: Color3_fromRGB_ret3 (copy), Vector2_new_ret (copy), Font_new_ret (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret4 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "CandyPopup";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 0.072);
    Frame.BackgroundTransparency = 1;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.AspectRatio = 2.2;
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint.Parent = Frame;
    Instance.new("UIScale").Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Glow";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.Position = UDim2.fromScale(0.42, 0.5);
    ImageLabel.Size = UDim2.fromScale(1.9, 3.6);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://10906540366";
    ImageLabel.ImageColor3 = Color3_fromRGB_ret3;
    ImageLabel.ImageTransparency = 1;
    ImageLabel.ZIndex = 1;
    ImageLabel.Parent = Frame;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Icon";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.Position = UDim2.fromScale(Vector2_new_ret.X, Vector2_new_ret.Y);
    ImageLabel2.Size = UDim2.fromScale(0.7272727272727273, 1.6);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://114576415464386";
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.ZIndex = 3;
    ImageLabel2.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Amount";
    TextLabel.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel.Position = UDim2.fromScale(1, 0.5);
    TextLabel.Size = UDim2.fromScale(0.4318181818181819, 0.95);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font_new_ret;
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.Text = "+1";
    TextLabel.ZIndex = 3;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new(Color3_fromRGB_ret, Color3_fromRGB_ret2);
    UIGradient.Rotation = 90;
    UIGradient.Parent = TextLabel;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.new(0, 0, 0);
    UIStroke.Thickness = 0.09;
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Parent = TextLabel;
    TextLabel.Parent = Frame;
    local v13 = {};

    for i = 1, 4 do
        local ImageLabel3 = Instance.new("ImageLabel");
        ImageLabel3.Name = `Spark{i}`;
        ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageLabel3.Size = UDim2.fromScale(0.40909090909090906, 0.9);
        ImageLabel3.BackgroundTransparency = 1;
        ImageLabel3.Image = "rbxasset://textures/particles/sparkles_main.dds";
        ImageLabel3.ImageColor3 = Color3_fromRGB_ret4;
        ImageLabel3.ZIndex = 4;
        ImageLabel3.Parent = Frame;
        v13[i] = ImageLabel3;
        local _ = i;
    end;

    return Frame, v13;
end;

local function setFade(p14: any, p15: number) -- Line: 214
    p14.Icon.ImageTransparency = p15;
    p14.Amount.TextTransparency = p15;
    p14.Amount.UIStroke.Transparency = p15;
end;

local function release(p16: number) -- Line: 220
    -- upvalues: u4 (copy), u3 (copy)
    local v17 = u4[p16];
    u4[p16] = u4[#u4];
    u4[#u4] = nil;
    v17.Frame.Parent = nil;
    u3[#u3 + 1] = {
        Frame = v17.Frame,
        Sparks = v17.Sparks
    };
end;

local function backOut(p18: number, p19: number) -- Line: 229
    return (p19 + 1) * (p18 - 1) ^ 3 + 1 + p19 * (p18 - 1) ^ 2;
end;

local function stepFlash(p20: table, p21: number) -- Line: 234
    -- upvalues: Vector2_new_ret (copy)
    local Frame = p20.Frame;
    local math_min_ret = math.min(p21 / 0.45, 1);
    Frame.Glow.ImageTransparency = math_min_ret * 1 + 0;
    local math_min_ret2 = math.min(p21 / 0.4, 1);
    local v22 = (1 - (1 - math_min_ret2) ^ 3) * 1.2;

    for i, v in p20.Sparks do
        if math_min_ret2 >= 1 then
            v.Visible = false;
        else
            local v23 = p20.SparkDirections[i];
            v.Position = UDim2.fromScale(Vector2_new_ret.X + v23.X * v22 / 2.2, Vector2_new_ret.Y + v23.Y * v22);
            v.ImageTransparency = math_min_ret2;
            v.Rotation = math_min_ret2 * 180;
        end;
    end;
end;

local function update() -- Line: 255
    -- upvalues: GuiService (copy), u4 (copy), u3 (copy), stepFlash (copy), u5 (ref)
    local os_clock_ret = os.clock();
    local ReducedMotionEnabled = GuiService.ReducedMotionEnabled;
    local v24 = 1;

    while v24 <= #u4 do
        local v25 = u4[v24];
        local v26 = os_clock_ret - v25.BornAt;

        if v26 >= 1.35 then
            local v27 = u4[v24];
            u4[v24] = u4[#u4];
            u4[#u4] = nil;
            v27.Frame.Parent = nil;
            u3[#u3 + 1] = {
                Frame = v27.Frame,
                Sparks = v27.Sparks
            };
        else
            local Frame = v25.Frame;
            local v28 = ReducedMotionEnabled and 0 or 1 - (1 - v26 / 1.35) ^ 3;
            Frame.Position = UDim2.fromScale(v25.Start.X + v25.Drift * v28, v25.Start.Y - v28 * 0.17);

            if ReducedMotionEnabled or v26 >= 0.24 then
                Frame.UIScale.Scale = v25.Size;
                Frame.Rotation = 0;
            else
                local v29 = v26 / 0.24;
                Frame.UIScale.Scale = v25.Size * ((v29 - 1) ^ 3 * 4 + 1 + (v29 - 1) ^ 2 * 3);
                Frame.Rotation = v25.Tilt * (1 - v29) ^ 2;
            end;

            if not (ReducedMotionEnabled or v25.FlashDone) then
                stepFlash(v25, (math.min(v26, 0.45)));
                v25.FlashDone = v26 >= 0.45;
            end;

            local math_clamp_ret = math.clamp((v26 - 0.8500000000000001) / 0.5, 0, 1);
            Frame.Icon.ImageTransparency = math_clamp_ret;
            Frame.Amount.TextTransparency = math_clamp_ret;
            Frame.Amount.UIStroke.Transparency = math_clamp_ret;
            v24 = v24 + 1;
        end;
    end;

    if #u4 == 0 and u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function playChime(p30: number) -- Line: 293
    -- upvalues: u9 (ref), u10 (ref), u7 (copy), u8 (ref), u1 (copy)
    u9 = p30 - u10 > 1 and 0 or u9 + 1;
    u10 = p30;
    local v31 = u7[u8];

    if v31 then
        u8 = u8 % #u7 + 1;
        v31.PlaybackSpeed = u1.LadderPitch(u9);
        v31.TimePosition = 0;
        v31:Play();
    end;
end;

function u1.LadderPitch(p32: number) -- Line: 309
    -- upvalues: u2 (copy)
    return 2 ^ (u2[math.min(p32 + 1, #u2)] / 12);
end;

function u1.Preload() -- Line: 314
    -- upvalues: u7 (copy), SoundService (copy), ContentProvider (copy)
    for _, v in u7 do
        v:Destroy();
    end;

    table.clear(u7);

    for i = 1, 4 do
        local Sound = Instance.new("Sound");
        Sound.Name = `CandyCollect{i}`;
        Sound.SoundId = "rbxassetid://15675059323";
        Sound.Volume = 0.5;
        Sound.Parent = SoundService;
        u7[i] = Sound;
        local _ = i;
    end;

    local table_clone_ret = table.clone(u7);
    table.insert(table_clone_ret, "rbxassetid://114576415464386");
    table.insert(table_clone_ret, "rbxassetid://10906540366");
    task.spawn(function() -- Line: 330
        -- upvalues: ContentProvider (ref), table_clone_ret (copy)
        pcall(ContentProvider.PreloadAsync, ContentProvider, table_clone_ret);
    end);
end;

function u1.Collect() -- Line: 336
    -- upvalues: u6 (ref), LocalPlayer (copy), Workspace (copy), u4 (copy), u3 (copy), makePopup (copy), u9 (ref), u10 (ref), u7 (copy), u8 (ref), u1 (copy), GuiService (copy), Random_new_ret (copy), NumberRange_new_ret (copy), NumberRange_new_ret2 (copy), Vector2_new_ret (copy), u5 (ref), RunServiceController (copy), update (copy)
    local v33 = u6;

    if not (v33 and v33.Parent) then
        local v34 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

        if v34 then
            v33 = Instance.new("ScreenGui");
            v33.Name = "CandyFeed";
            v33.IgnoreGuiInset = true;
            v33.ResetOnSpawn = false;
            v33.DisplayOrder = 5;
            v33.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
            v33.Parent = v34;
            u6 = v33;
        else
            v33 = nil;
        end;
    end;

    if not (v33 and Workspace.CurrentCamera) then
        return;
    end;

    if #u4 >= 40 then
        local v35 = 1;

        for i, v in u4 do
            if v.BornAt < u4[v35].BornAt then
                v35 = i;
            end;
        end;

        local v36 = u4[v35];
        u4[v35] = u4[#u4];
        u4[#u4] = nil;
        v36.Frame.Parent = nil;
        u3[#u3 + 1] = {
            Frame = v36.Frame,
            Sparks = v36.Sparks
        };
    end;

    local table_remove_ret = table.remove(u3);
    local v37, v38;

    if table_remove_ret then
        v37 = table_remove_ret.Frame;
        v38 = table_remove_ret.Sparks;
    else
        v37, v38 = makePopup();
    end;

    local os_clock_ret = os.clock();
    u9 = os_clock_ret - u10 > 1 and 0 or u9 + 1;
    u10 = os_clock_ret;
    local v39 = u7[u8];

    if v39 then
        u8 = u8 % #u7 + 1;
        v39.PlaybackSpeed = u1.LadderPitch(u9);
        v39.TimePosition = 0;
        v39:Play();
    end;

    local ReducedMotionEnabled = GuiService.ReducedMotionEnabled;
    local Vector2_new_ret2 = Vector2.new(Random_new_ret:NextNumber(NumberRange_new_ret.Min, NumberRange_new_ret.Max), Random_new_ret:NextNumber(NumberRange_new_ret2.Min, NumberRange_new_ret2.Max));
    local v40 = Random_new_ret:NextNumber(0, 6.283185307179586);
    local table_create_ret = table.create(4);

    for i, v in v38 do
        local v41 = v40 + (i - 1) / 4 * 2 * 3.141592653589793;
        table_create_ret[i] = Vector2.new(math.cos(v41), (math.sin(v41)));
        v.Visible = not ReducedMotionEnabled;
        v.Position = UDim2.fromScale(Vector2_new_ret.X, Vector2_new_ret.Y);
        v.ImageTransparency = 0;
    end;

    local v42 = {
        Frame = v37,
        Sparks = v38,
        Start = Vector2_new_ret2,
        Drift = Random_new_ret:NextNumber(-0.03, 0.03),
        Tilt = ReducedMotionEnabled and 0 or Random_new_ret:NextNumber(-14, 14),
        Size = math.min(u9, 8) * 0.05 + 1,
        SparkDirections = table_create_ret,
        FlashDone = ReducedMotionEnabled,
        BornAt = os_clock_ret
    };
    v37.Position = UDim2.fromScale(Vector2_new_ret2.X, Vector2_new_ret2.Y);
    v37.Rotation = v42.Tilt;
    v37.UIScale.Scale = not ReducedMotionEnabled and 0 or v42.Size;
    v37.Glow.ImageTransparency = ReducedMotionEnabled and 1 or 0;
    v37.Icon.ImageTransparency = 0;
    v37.Amount.TextTransparency = 0;
    v37.Amount.UIStroke.Transparency = 0;
    v37.Parent = v33;
    u4[#u4 + 1] = v42;

    if not u5 then
        u5 = RunServiceController.BindToRenderSteppedEvent("Survival.CandyFeed", update);
    end;
end;

function u1.Clear() -- Line: 397
    -- upvalues: u4 (copy), u3 (copy)
    while #u4 > 0 do
        local v43 = #u4;
        local v44 = u4[v43];
        u4[v43] = u4[#u4];
        u4[#u4] = nil;
        v44.Frame.Parent = nil;
        u3[#u3 + 1] = {
            Frame = v44.Frame,
            Sparks = v44.Sparks
        };
    end;
end;

return u1;