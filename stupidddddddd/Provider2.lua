-- ReplicatedFirst.Provider
-- Script path: ReplicatedFirst.Provider
-- Decompile time: 3.03 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Janitor = require((ReplicatedStorage:WaitForChild("Shared")):WaitForChild("Janitor"))
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor
local Loader = script:WaitForChild("Loader")
local u56 = "Loading Profile"
local u57 = 0
local u58 = 0
local u59 = false
local u60 = 0
local Frame = Instance.new("Frame")
Frame.Name = "InputBlocker"
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.Position = UDim2.new(0, 0, 0, 0)
Frame.BackgroundTransparency = 1
Frame.Active = true
Frame.ZIndex = 6767
Frame.Parent = Loader
local u80 = {TextLabel = "TextTransparency", ImageLabel = "ImageTransparency", Frame = "BackgroundTransparency"}
ReplicatedFirst:RemoveDefaultLoadingScreen()
Loader.Parent = PlayerGui

local function ProcessFinished(a1) -- Line: 60
    -- upvalues: ReplicatedStorage (val), StarterGui (val), u59 (ref), PlayerGui (val), Loader (val), u80 (val)
    -- upvalues: TweenService (val)
    local v1 = ((ReplicatedStorage:WaitForChild("Assets")):WaitForChild("UI")):FindFirstChild("MainGui") or StarterGui:FindFirstChild("MainGui")
    if not u59 then
        local v2, v3, v4
        u59 = true
        if v1 then
            v1.Parent = PlayerGui
        end
        for i, v in ipairs(Loader:GetDescendants()) do
            v3 = u80[v.ClassName]
            if v3 and v.Visible and v[v3] < 1 then
                v4 = TweenService
                v2 = TweenInfo.new(0.95)
                v4:Create(v, v2, {[v3] = 1}):Play()
            end
        end
        task.delay(1, function() -- Line: 78 -- upvalues: a1 (val)
            a1:Destroy()
        end)
    end
end

task.spawn(function() -- Line: 89 -- upvalues: ContentProvider (val), Loader (val)
    ContentProvider:PreloadAsync((Loader:GetDescendants()))
end)
task.spawn(function() -- Line: 93
    -- upvalues: Janitor (val), Frame (val), Loader (val), RunService (val), u58 (ref), u56 (ref), u57 (ref), u60 (ref)
    -- upvalues: LocalPlayer (val), ProcessFinished (val), ReplicatedStorage (val), ContentProvider (val)
    local v1 = Janitor.new()
    v1:Add(Frame)
    v1:Add(Loader)
    local u12 = tick()
    local u13 = -1
    local u15 = tick()
    local u16 = 0
    local u17 = ""
    v1:Add((RunService.Heartbeat:Connect(function(a1) -- Line: 104
        -- upvalues: u58 (upval), u56 (upval), u57 (upval), u15 (ref), u17 (ref), Loader (upval), u13 (ref), u16 (ref)
        -- upvalues: u12 (ref), u60 (upval)
        local v1
        local v2 = 25
        local v3 = tick()
        if not (u58 > 0) or u56 ~= "Loading Assets" then
            if 0.35 <= v3 - u12 then
                u60 = (u60 + 1) % 3
                u12 = v3
            end
            v1 = "Loading Profile" .. string.rep(".", u60 + 1)
            if v1 ~= u17 then
                Loader.LoadingScreen.Title.Text = v1
                u17 = v1
            end
            if Loader.LoadingScreen.Title.TextTransparency ~= 0 then
                Loader.LoadingScreen.Title.TextTransparency = 0
            end
        else
            v1 = math.min(u57, u58)
            local v4 = v3 - u15
            local v5 = v1 / u58
            local v6 = ("Loading Assets (%*/%*)"):format(v1, u58)
            if v6 ~= u17 then
                Loader.LoadingScreen.Title.Text = v6
                u17 = v6
            end
            if v1 ~= u13 then
                Loader.LoadingScreen.Title.TextTransparency = 1 - v5
                Loader.LoadingScreen.Icon.ImageTransparency = 1 - v5
                u13 = v1
            end
            if v4 > 0 then
                v2 = math.min(25 + (u57 - u16) / v4 * 2, 95)
            end
            u16 = u57
            u15 = v3
        end
        Loader.LoadingScreen.Extra.Progress.Rotation = Loader.LoadingScreen.Extra.Progress.Rotation + a1 * v2
    end)))
    repeat
        task.wait()
    until LocalPlayer:GetAttribute("DataLoaded")
    task.delay(4, ProcessFinished, v1)
    task.spawn(function() -- Line: 160
        -- upvalues: ReplicatedStorage (upval), u56 (upval), u57 (upval), u58 (upval), ContentProvider (upval)
        local v1, v2
        local Assets = ReplicatedStorage:WaitForChild("Assets")
        local v3 = {}
        local v4 = {"UI", "TradingUI"}
        local v5 = nil
        local v6 = nil
        for i, j in v4, v5, v6 do
            v2 = Assets:FindFirstChild(j)
            if v2 then
                for k, n in v2:GetDescendants() do
                    table.insert(v3, n)
                end
            end
        end
        local Sounds = ReplicatedStorage:WaitForChild("Sounds", 10)
        if Sounds then
            for m, i5 in Sounds:GetDescendants() do
                table.insert(v3, i5)
            end
        end
        u56 = "Loading Assets"
        u57 = 0
        u58 = #v3
        v5 = u58
        for i6 = 1, v5, 64 do
            v1 = math.min(i6 + 64 - 1, u58)
            v2 = table.create(v1 - i6 + 1)
            for i7 = i6, v1 do
                table.insert(v2, v3[i7])
            end
            ContentProvider:PreloadAsync(v2, function() -- Line: 192 -- upvalues: u57 (upval)
                u57 = u57 + 1
            end)
            task.wait()
        end
    end)
end)