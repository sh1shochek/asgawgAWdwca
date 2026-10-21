-- ReplicatedStorage.Controllers.CaseSceneController.ConsoleItemRoller
-- Script path: ReplicatedStorage.Controllers.CaseSceneController.ConsoleItemRoller
-- Decompile time: 7.05 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
require(ReplicatedStorage.Shared.Janitor);
local Router = require(ReplicatedStorage.Database.Security.Router);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local UDim2_fromScale_ret = UDim2.fromScale(0.196, 0.621);
local TweenInfo_new_ret = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local TweenInfo_new_ret2 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out);

local function pickOther(p2: table, p3: table) -- Line: 73
    local table_find_ret = table.find(p2, p3);

    if not table_find_ret or #p2 < 2 then
        return p2[math.random(1, #p2)];
    end;

    local math_random_ret = math.random(1, #p2 - 1);

    if table_find_ret <= math_random_ret then
        math_random_ret = math_random_ret + 1;
    end;

    return p2[math_random_ret];
end;

local function buildSequence(p4: table) -- Line: 84
    -- upvalues: pickOther (copy)
    local table_create_ret = table.create(42);
    table_create_ret[5] = p4.Winner;
    table_create_ret[4] = pickOther(p4.Pool, table_create_ret[5]);
    table_create_ret[3] = pickOther(p4.Pool, table_create_ret[4]);
    table_create_ret[2] = pickOther(p4.Pool, table_create_ret[3]);
    table_create_ret[1] = pickOther(p4.Pool, table_create_ret[2]);

    for i = 6, 42 do
        table_create_ret[i] = pickOther(p4.Pool, table_create_ret[i - 1]);
        local _ = i;
    end;

    return table_create_ret;
end;

local function createRoot(p5: userdata) -- Line: 96
    local Frame = Instance.new("Frame");
    Frame.Name = "ConsoleItemRoller";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.74, 0.36);
    Frame.BackgroundTransparency = 1;
    Frame.ClipsDescendants = true;
    Frame.ZIndex = 20;
    Frame.Parent = p5;

    return Frame;
end;

local function createTile(p6: userdata, p7: table) -- Line: 109
    -- upvalues: UDim2_fromScale_ret (copy)
    local Frame = Instance.new("Frame");
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Size = UDim2_fromScale_ret;
    Frame.BackgroundTransparency = 1;
    Frame.Visible = false;
    local UIScale = Instance.new("UIScale");
    UIScale.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Glow";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.56);
    ImageLabel.Size = UDim2.fromScale(1.19, 1.37);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://10906540366";
    ImageLabel.ImageColor3 = p7.Color;
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Parent = Frame;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Icon";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = p7.Image;
    ImageLabel2.ImageTransparency = 1;
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.ZIndex = 2;
    ImageLabel2.Parent = Frame;
    Frame.Parent = p6;

    return {
        Frame = Frame,
        Scale = UIScale,
        Icon = ImageLabel2,
        Glow = ImageLabel
    };
end;

local function createPointer(p8: userdata) -- Line: 148
    local Frame = Instance.new("Frame");
    Frame.Name = "Pointer";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.02);
    Frame.Size = UDim2.fromScale(0.32, 0.32);
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = 5;
    Instance.new("UIAspectRatioConstraint").Parent = Frame;
    local UIScale = Instance.new("UIScale");
    UIScale.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Arrow";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://106962999752773";
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Rotation = 90;
    ImageLabel.Parent = Frame;
    Frame.Parent = p8;

    return Frame, ImageLabel, UIScale;
end;

local function smoothstep(p9: number) -- Line: 176
    local math_clamp_ret = math.clamp(p9, 0, 1);

    return math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2);
end;

local function layoutTiles(p10: table, p11: number, p12: number) -- Line: 182
    for i, v in p10 do
        local v13 = i - p11;
        local v14 = 0.5 - v13 * 0.3333333333333333;
        local v15;

        if v14 > -0.3333333333333333 then
            v15 = v14 < 1.3333333333333333;
        else
            v15 = false;
        end;

        v.Frame.Visible = v15;

        if v15 then
            v.Frame.Position = UDim2.fromScale(v14, 0.5);
            local v16 = 1 - math.abs(v13);
            local math_clamp_ret = math.clamp(v16, 0, 1);
            local v17 = math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2);
            v.Scale.Scale = v17 * 0.51 + 1;
            local v18 = math.min(v14, 1 - v14) / 0.15;
            local math_clamp_ret2 = math.clamp(v18, 0, 1);
            local v19 = math_clamp_ret2 * math_clamp_ret2 * (3 - math_clamp_ret2 * 2) * p12;
            v.Icon.ImageTransparency = 1 - v19;
            v.Glow.ImageTransparency = 1 - (1 - (v17 * -0.4 + 0.8)) * v19;
        end;
    end;
end;

function v1.play(p20: userdata, u21: table, p22: any, p23: function) -- Line: 202
    -- upvalues: createRoot (copy), buildSequence (copy), createTile (copy), createPointer (copy), layoutTiles (copy), RunService (copy), RunServiceController (copy), Router (copy), TweenInfo_new_ret (copy), TweenService (copy), TweenInfo_new_ret2 (copy)
    local v24 = p22:Add((createRoot(p20)));
    local u25 = {};

    for i, v in buildSequence(u21) do
        u25[i] = createTile(v24, v);
    end;

    local u26, u27, v28 = createPointer(v24);
    local u29 = 0;
    local u30 = 0;
    local u31 = 39;
    local os_clock_ret = os.clock();

    local function swingPointer(p32: number) -- Line: 219
        -- upvalues: os_clock_ret (ref), u30 (ref), u29 (ref), u31 (ref), u26 (copy)
        local os_clock_ret2 = os.clock();
        local math_min_ret = math.min(os_clock_ret2 - os_clock_ret, 0.1);
        os_clock_ret = os_clock_ret2;

        while math_min_ret > 0 do
            local math_min_ret2 = math.min(math_min_ret, 0.004166666666666667);
            u30 = u30 - (1934.4424626135142 * u29 + 26.389378290154262 * u30) * math_min_ret2;
            u29 = u29 + u30 * math_min_ret2;
            math_min_ret = math_min_ret - math_min_ret2;
        end;

        local v33 = math.ceil(p32 - 0.5) + 0.5 - p32;
        local v34 = nil;
        local v35;

        if v33 < 0.26 then
            v35 = v33 * 38 / 0.26;
        else
            v35 = p32 < u31 and math.round(p32) ~= math.round(u31) and 38 or v34;
        end;

        u31 = p32;

        if v35 and u29 < v35 then
            u29 = v35;
            u30 = 0;
        end;

        u26.Rotation = u29;
    end;

    local function showWinner() -- Line: 250
        -- upvalues: layoutTiles (ref), u25 (copy), u26 (copy), u27 (copy), u21 (copy)
        layoutTiles(u25, 5, 1);
        u26.Rotation = 0;
        u27.ImageTransparency = 0;
        u27.ImageColor3 = u21.Winner.Color;

        return false;
    end;

    local os_clock_ret2 = os.clock();

    while p23() do
        local v36 = os.clock() - os_clock_ret2;
        local math_min_ret = math.min(v36 / 0.25, 1);
        layoutTiles(u25, 39, math_min_ret);
        u27.ImageTransparency = 1 - math_min_ret;

        if v36 >= 0.5 then
            break;
        end;

        RunService.RenderStepped:Wait();
    end;

    if not p23() then
        layoutTiles(u25, 5, 1);
        u26.Rotation = 0;
        u27.ImageTransparency = 0;
        u27.ImageColor3 = u21.Winner.Color;

        return false;
    end;

    local u37 = 5 + (math.random() < 0.5 and -1 or 1) * (0.26 + math.random() * 0.18);
    local u38 = 39;
    local math_round_ret = math.round(u38);
    local os_clock_ret3 = os.clock();
    local u39 = false;
    p22:Add(RunServiceController.BindToRenderStep(RunServiceController.CreateBindingName("CaseScene.ConsoleItemRoller"), function() -- Line: 284
        -- upvalues: os_clock_ret3 (copy), u38 (ref), u37 (copy), layoutTiles (ref), u25 (copy), swingPointer (copy), math_round_ret (ref), Router (ref), u39 (ref)
        local v40 = (os.clock() - os_clock_ret3) / 5;
        local math_min_ret = math.min(v40, 1);
        u38 = 39 + (u37 - 39) * (1 - (1 - math_min_ret) ^ 5);
        layoutTiles(u25, u38, 1);
        swingPointer(u38);
        local math_round_ret2 = math.round(u38);

        if math_round_ret2 ~= math_round_ret then
            math_round_ret = math_round_ret2;
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end;

        u39 = math_min_ret >= 1;
    end), "Disconnect", "ConsoleItemRollerScroll");

    while not u39 and p23() do
        RunService.RenderStepped:Wait();
    end;

    p22:Remove("ConsoleItemRollerScroll");

    if not p23() then
        layoutTiles(u25, 5, 1);
        u26.Rotation = 0;
        u27.ImageTransparency = 0;
        u27.ImageColor3 = u21.Winner.Color;

        return false;
    end;

    local os_clock_ret4 = os.clock();

    while p23() and os.clock() - os_clock_ret4 < 0.3 do
        swingPointer(u38);
        RunService.RenderStepped:Wait();
    end;

    if not p23() then
        layoutTiles(u25, 5, 1);
        u26.Rotation = 0;
        u27.ImageTransparency = 0;
        u27.ImageColor3 = u21.Winner.Color;

        return false;
    end;

    local v41 = u38;
    local os_clock_ret5 = os.clock();

    while p23() do
        local v42 = (os.clock() - os_clock_ret5) / TweenInfo_new_ret.Time;
        local math_min_ret = math.min(v42, 1);
        local Value = TweenService:GetValue(math_min_ret, TweenInfo_new_ret.EasingStyle, TweenInfo_new_ret.EasingDirection);
        u38 = v41 + (5 - v41) * Value;
        layoutTiles(u25, u38, 1);
        swingPointer(u38);

        if math_min_ret >= 1 then
            break;
        end;

        RunService.RenderStepped:Wait();
    end;

    if not p23() then
        layoutTiles(u25, 5, 1);
        u26.Rotation = 0;
        u27.ImageTransparency = 0;
        u27.ImageColor3 = u21.Winner.Color;

        return false;
    end;

    u27.ImageColor3 = u21.Winner.Color;
    v28.Scale = 1.45;
    TweenService:Create(u26, TweenInfo_new_ret2, {
        Rotation = 0
    }):Play();
    TweenService:Create(v28, TweenInfo_new_ret2, {
        Scale = 1
    }):Play();
    Router.broadcastRouter("RunStoreSound", u21.LandingSound);

    return true;
end;

return table.freeze(v1);