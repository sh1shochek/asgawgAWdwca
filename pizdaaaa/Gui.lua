-- ReplicatedStorage.GameClient.Gui
-- Script path: ReplicatedStorage.GameClient.Gui
-- Decompile time: 10.10 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local LocalPlayer = game:GetService("Players").LocalPlayer;
local u2 = {};
local u3 = nil;
local u4 = setmetatable({}, {
    __mode = "k"
});

function u1.GetDotsTileSize(p5) -- Line: 22
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v6 = p5 or workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(1920, 1080);
    local math_min_ret = math.min(v6.X, v6.Y);
    local v7;

    if math_min_ret <= 720 then
        v7 = math.max(0.25, math_min_ret / 720 * 0.75);
    elseif math_min_ret <= 1080 then
        v7 = (math_min_ret - 720) / 360 * 0.25 + 0.75;
    elseif math_min_ret <= 1440 then
        v7 = (math_min_ret - 1080) / 360 * 0.5 + 1;
    else
        v7 = (math_min_ret - 1440) / 720 * 0.5 + 1.5;
    end;

    local math_round_ret = math.round(512 * v7);

    return UDim2.fromOffset(math_round_ret, math_round_ret);
end;

function u1.RegisterDotsImage(p8: userdata) -- Line: 40
    -- upvalues: u4 (copy), u1 (copy)
    if (p8:IsA("ImageLabel") or p8:IsA("ImageButton")) and string.find(p8.Image, "91991932054752") then
        u4[p8] = true;
        p8.TileSize = u1.GetDotsTileSize();
    end;
end;

local function updateAllDotsTileSizes() -- Line: 47
    -- upvalues: u1 (copy), u4 (copy)
    local DotsTileSize = u1.GetDotsTileSize();

    for i in pairs(u4) do
        if i and i.Parent then
            i.TileSize = DotsTileSize;
        else
            u4[i] = nil;
        end;
    end;
end;

local function setupDotTracker(u9: userdata) -- Line: 58
    -- upvalues: u4 (copy), u1 (copy)
    if u9:IsA("ImageLabel") or u9:IsA("ImageButton") then
        if string.find(u9.Image, "91991932054752") then
            u4[u9] = true;
            u9.TileSize = u1.GetDotsTileSize();
        end;

        u9:GetPropertyChangedSignal("Image"):Connect(function() -- Line: 64
            -- upvalues: u9 (copy), u4 (ref), u1 (ref)
            if not string.find(u9.Image, "91991932054752") then
                u4[u9] = nil;

                return;
            end;

            u4[u9] = true;
            u9.TileSize = u1.GetDotsTileSize();
        end);
    end;
end;

u1.Handler = nil;

function u1.GetComponent(p10) -- Line: 79
    -- upvalues: u2 (copy)
    return u2[p10];
end;

function u1.Init(p11) -- Line: 83
    -- upvalues: u3 (ref), u1 (copy), u2 (copy)
    u3 = p11:GetModule("Network");
    u1.new();
    local v12 = {
        Achievements = true,
        Battlepass = true,
        TradeUp = true
    };

    for _, v in pairs(script:QueryDescendants("ModuleScript")) do
        if not v12[v.Name] then
            os.clock();
            local v13 = require(v);
            u2[v.Name] = v13;

            if v13.Init then
                function v13.GetModule(p14, p15) -- Line: 113
                    -- upvalues: u1 (ref), u2 (ref)
                    return u1:GetModule(p15) or u2[p15];
                end;
            end;
        end;
    end;

    u3.Player.StartGameRunning.On(function() -- Line: 121
        -- upvalues: u2 (ref)
        for _, v in u2 do
            if v.Init then
                os.clock();
                v:Init();
            end;
        end;

        for _, v in u2 do
            task.defer(function() -- Line: 133
                -- upvalues: v (copy)
                if v.Start then
                    os.clock();
                    v:Start();
                end;
            end);
        end;

        for _, v in u2 do
            task.defer(function() -- Line: 143
                -- upvalues: v (copy)
                if v.Start2 then
                    os.clock();
                    v:Start2();
                end;
            end);
        end;
    end);
end;

function u1.new() -- Line: 156
    -- upvalues: LocalPlayer (copy), u1 (copy), setupDotTracker (copy), updateAllDotsTileSizes (copy)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "GUI";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Parent = LocalPlayer.PlayerGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "HUD";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Visible = false;
    Frame.Parent = ScreenGui;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundColor3 = Color3.fromRGB(16, 16, 16);
    ImageLabel.BackgroundTransparency = 0.9;
    ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0);
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.new(-1, 0, 0, 0);
    ImageLabel.Size = UDim2.new(1, 0, 1, 0);
    ImageLabel.ZIndex = -1;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.fromRGB(97, 97, 97);
    ImageLabel.ImageTransparency = 0.8;
    ImageLabel.ResampleMode = Enum.ResamplerMode.Default;
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.TileSize = u1.GetDotsTileSize();
    ImageLabel.Parent = ScreenGui;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Fade";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundColor3 = Color3.new();
    ImageLabel2.BorderColor3 = Color3.new();
    ImageLabel2.BorderSizePixel = 0;
    ImageLabel2.LayoutOrder = -3;
    ImageLabel2.Position = UDim2.fromScale(2, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Crop;
    ImageLabel2.Size = UDim2.fromScale(2, 1.2);
    ImageLabel2.TileSize = UDim2.fromScale(0.2, 1);
    ImageLabel2.ZIndex = 10000;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.08, 1),
        NumberSequenceKeypoint.new(0.15, 0),
        NumberSequenceKeypoint.new(0.85, 0),
        NumberSequenceKeypoint.new(0.925556, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = ImageLabel2;
    ImageLabel2.Parent = ScreenGui;
    ImageLabel.Visible = true;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "MainMenu";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame2.BackgroundTransparency = 1;
    Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame2.Size = UDim2.new(1, 0, 1, 0);
    Frame2.Parent = ScreenGui;
    ScreenGui:SetAttribute("CurrentTab", "EVERYTHING");
    u1.Handler = ScreenGui;
    ScreenGui.DescendantAdded:Connect(setupDotTracker);

    for _, descendant in ipairs(ScreenGui:GetDescendants()) do
        setupDotTracker(descendant);
    end;

    LocalPlayer.PlayerGui.DescendantAdded:Connect(setupDotTracker);

    for _, descendant in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
        setupDotTracker(descendant);
    end;

    local function bindCamera() -- Line: 282
        -- upvalues: updateAllDotsTileSizes (ref)
        local workspace_CurrentCamera = workspace.CurrentCamera;

        if workspace_CurrentCamera then
            workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateAllDotsTileSizes);
        end;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateAllDotsTileSizes);
    end;

    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 289
        -- upvalues: updateAllDotsTileSizes (ref)
        local workspace_CurrentCamera2 = workspace.CurrentCamera;

        if workspace_CurrentCamera2 then
            workspace_CurrentCamera2:GetPropertyChangedSignal("ViewportSize"):Connect(updateAllDotsTileSizes);
        end;

        updateAllDotsTileSizes();
    end);
    updateAllDotsTileSizes();
end;

return u1;