-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local StarterGui = game:GetService("StarterGui");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Janitor = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Janitor"));
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor;
local Loader = script:WaitForChild("Loader");
local u1 = "Loading Profile";
local u2 = 0;
local u3 = 0;
local u4 = false;
local u5 = 0;
local Frame = Instance.new("Frame");
Frame.Name = "InputBlocker";
Frame.Size = UDim2.new(1, 0, 1, 0);
Frame.Position = UDim2.new(0, 0, 0, 0);
Frame.BackgroundTransparency = 1;
Frame.Active = true;
Frame.ZIndex = 6767;
Frame.Parent = Loader;
local u6 = {
    TextLabel = "TextTransparency",
    ImageLabel = "ImageTransparency",
    Frame = "BackgroundTransparency"
};
ReplicatedFirst:RemoveDefaultLoadingScreen();
Loader.Parent = PlayerGui;

local function ProcessFinished(u7) -- Line: 60
    -- upvalues: ReplicatedStorage (copy), StarterGui (copy), u4 (ref), PlayerGui (copy), Loader (copy), u6 (copy), TweenService (copy)
    local v8 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):FindFirstChild("MainGui") or StarterGui:FindFirstChild("MainGui");

    if not u4 then
        u4 = true;

        if v8 then
            v8.Parent = PlayerGui;
        end;

        for _, descendant in ipairs(Loader:GetDescendants()) do
            local v9 = u6[descendant.ClassName];

            if v9 and (descendant.Visible and descendant[v9] < 1) then
                TweenService:Create(descendant, TweenInfo.new(0.95), {
                    [v9] = 1
                }):Play();
            end;
        end;

        task.delay(1, function() -- Line: 78
            -- upvalues: u7 (copy)
            u7:Destroy();
        end);
    end;
end;

task.spawn(function() -- Line: 89
    -- upvalues: ContentProvider (copy), Loader (copy)
    ContentProvider:PreloadAsync(Loader:GetDescendants());
end);
task.spawn(function() -- Line: 93
    -- upvalues: Janitor (copy), Frame (copy), Loader (copy), RunService (copy), u3 (ref), u1 (ref), u2 (ref), u5 (ref), LocalPlayer (copy), ProcessFinished (copy), ReplicatedStorage (copy), ContentProvider (copy)
    local v10 = Janitor.new();
    v10:Add(Frame);
    v10:Add(Loader);
    local u11 = tick();
    local u12 = -1;
    local u13 = tick();
    local u14 = 0;
    local u15 = "";
    v10:Add(RunService.Heartbeat:Connect(function(p16: number) -- Line: 104
        -- upvalues: u3 (ref), u1 (ref), u2 (ref), u13 (ref), u15 (ref), Loader (ref), u12 (ref), u14 (ref), u11 (ref), u5 (ref)
        local v17 = 25;
        local v18 = tick();

        if u3 > 0 and u1 == "Loading Assets" then
            local math_min_ret = math.min(u2, u3);
            local v19 = v18 - u13;
            local v20 = math_min_ret / u3;
            local v21 = `Loading Assets ({math_min_ret}/{u3})`;

            if v21 ~= u15 then
                Loader.LoadingScreen.Title.Text = v21;
                u15 = v21;
            end;

            if math_min_ret ~= u12 then
                Loader.LoadingScreen.Title.TextTransparency = 1 - v20;
                Loader.LoadingScreen.Icon.ImageTransparency = 1 - v20;
                u12 = math_min_ret;
            end;

            if v19 > 0 then
                v17 = math.min(25 + (u2 - u14) / v19 * 2, 95);
            end;

            u14 = u2;
            u13 = v18;
        else
            if v18 - u11 >= 0.35 then
                u5 = (u5 + 1) % 3;
                u11 = v18;
            end;

            local v22 = "Loading Profile" .. string.rep(".", u5 + 1);

            if v22 ~= u15 then
                Loader.LoadingScreen.Title.Text = v22;
                u15 = v22;
            end;

            if Loader.LoadingScreen.Title.TextTransparency ~= 0 then
                Loader.LoadingScreen.Title.TextTransparency = 0;
            end;
        end;

        Loader.LoadingScreen.Extra.Progress.Rotation = Loader.LoadingScreen.Extra.Progress.Rotation + p16 * v17;
    end));

    repeat
        task.wait();
    until LocalPlayer:GetAttribute("DataLoaded");

    task.delay(4, ProcessFinished, v10);
    task.spawn(function() -- Line: 160
        -- upvalues: ReplicatedStorage (ref), u1 (ref), u2 (ref), u3 (ref), ContentProvider (ref)
        local Assets = ReplicatedStorage:WaitForChild("Assets");
        local v23 = {};

        for _, v in { "UI", "TradingUI" } do
            local v24 = Assets:FindFirstChild(v);

            if v24 then
                for _, descendant in v24:GetDescendants() do
                    table.insert(v23, descendant);
                end;
            end;
        end;

        local Sounds = ReplicatedStorage:WaitForChild("Sounds", 10);

        if Sounds then
            for _, descendant in Sounds:GetDescendants() do
                table.insert(v23, descendant);
            end;
        end;

        u1 = "Loading Assets";
        u2 = 0;
        u3 = #v23;

        for i = 1, u3, 64 do
            local math_min_ret = math.min(i + 64 - 1, u3);
            local table_create_ret = table.create(math_min_ret - i + 1);
            local _ = i;

            for i2 = i, math_min_ret do
                table.insert(table_create_ret, v23[i2]);
                local _ = i2;
            end;

            ContentProvider:PreloadAsync(table_create_ret, function() -- Line: 192
                -- upvalues: u2 (ref)
                u2 = u2 + 1;
            end);
            task.wait();
        end;
    end);
end);