-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Notification
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Notification
-- Decompile time: 7.08 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
require(script:WaitForChild("Types"))
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local InputController = require(ReplicatedStorage.Controllers.InputController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local LocalPlayer = Players.LocalPlayer
local u60 = UDim2.fromScale(0.9, 0.2)
local u64 = UDim2.fromScale(0.9, 0.12)
local u69 = Color3.fromRGB(230, 36, 36)
local u74 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local Notification = ReplicatedStorage.Assets.UI.Notification
local u78 = {}
u78.Invulnerable = Notification:FindFirstChild("Invulnerable")
u78.Default = Notification:FindFirstChild("Default")
u78.Keybind = Notification:FindFirstChild("Keybind")
local u91 = nil

local function collectFadeTargets(a1) -- Line: 52 -- types: a1: userdata
    local u1 = {}

    local function collect(a1) -- Line: 54 -- upvalues: u1 (val) -- types: a1: userdata
        local function add(a1_2) -- Line: 55 -- upvalues: a1 (val), u1 (upval) -- types: a1_2: string
            local v1 = a1[a1_2]
            if typeof(v1) == "number" and v1 < 1 then
                table.insert(u1, {Instance = a1, Property = a1_2, Value = v1})
            end
        end

        if a1:IsA("GuiObject") then
            local BackgroundTransparency = a1.BackgroundTransparency
            if typeof(BackgroundTransparency) == "number" and BackgroundTransparency < 1 then
                table.insert(u1, {Property = "BackgroundTransparency", Instance = a1, Value = BackgroundTransparency})
            end
        end
        if a1:IsA("ImageLabel") or a1:IsA("ImageButton") then
            local ImageTransparency = a1.ImageTransparency
            if typeof(ImageTransparency) == "number" and ImageTransparency < 1 then
                table.insert(u1, {Property = "ImageTransparency", Instance = a1, Value = ImageTransparency})
            end
        end
        if a1:IsA("TextLabel") or a1:IsA("TextButton") or a1:IsA("TextBox") then
            local TextTransparency = a1.TextTransparency
            if typeof(TextTransparency) == "number" and TextTransparency < 1 then
                table.insert(u1, {Property = "TextTransparency", Instance = a1, Value = TextTransparency})
            end
            local TextStrokeTransparency = a1.TextStrokeTransparency
            if typeof(TextStrokeTransparency) == "number" and TextStrokeTransparency < 1 then
                table.insert(u1, {Property = "TextStrokeTransparency", Instance = a1, Value = TextStrokeTransparency})
            end
        end
        if a1:IsA("UIStroke") then
            local Transparency = a1.Transparency
            if typeof(Transparency) == "number" and Transparency < 1 then
                table.insert(u1, {Property = "Transparency", Instance = a1, Value = Transparency})
            end
        end
    end

    collect(a1)
    for i, j in a1:GetDescendants() do
        collect(j)
    end
    return u1
end

local function cleanupNotificationTemplate(a1) -- Line: 76
    -- upvalues: collectFadeTargets (val), TweenService (val), u74 (val), Debris (val)
    for i, j in collectFadeTargets(a1) do
        TweenService:Create(j.Instance, u74, {[j.Property] = 1}):Play()
    end
    Debris:AddItem(a1, 0.35)
end

local function destroyNotification(a1) -- Line: 84 -- upvalues: u91 (ref) -- types: a1: string
    local v1 = u91 and u91:FindFirstChild(a1)
    if v1 then
        v1:Destroy()
    end
end

local function getSpawnCardHeader() -- Line: 91 -- upvalues: u91 (ref)
    local v1 = u91 and u91:FindFirstChild("Deathmatch Invincibility")
    local Container = v1 and v1:FindFirstChild("Container")
    local Header = Container and Container:FindFirstChild("Header")
    return Header and Header:IsA("TextLabel") and Header or nil
end

local function getHeaderText(a1) -- Line: 99 -- upvalues: u78 (val) -- types: a1: boolean
    local Invulnerable = u78.Invulnerable
    local Container = Invulnerable and Invulnerable:FindFirstChild("Container")
    local Header = Container and Container:FindFirstChild("Header")
    local Text = Header and Header:IsA("TextLabel") and Header.Text or "Invulnerable"
    if a1 then
        return Text
    end
    local v1 = string.match(Text, "^[Ii][Nn](.+)$")
    if not v1 then
        return "Vulnerable"
    end
    return (string.upper((string.sub(v1, 1, 1)))) .. string.sub(v1, 2)
end

local function setSpawnCardInvulnerable(a1) -- Line: 115
    -- upvalues: u91 (ref), getHeaderText (val), GetPreferenceColor (val), u69 (val)
    local v1 = u91 and u91:FindFirstChild("Deathmatch Invincibility")
    local Container = v1 and v1:FindFirstChild("Container")
    local Header = Container and Container:FindFirstChild("Header")
    local v2 = Header and Header:IsA("TextLabel") and Header or nil
    if v2 then
        v2.Text = getHeaderText(a1)
        v2.TextColor3 = a1 and GetPreferenceColor() or u69
    end
end

local function clearSpawnCard() -- Line: 123 -- upvalues: u91 (ref), u0 (val)
    local v1 = u91 and u91:FindFirstChild("Deathmatch Invincibility")
    if v1 then
        v1:Destroy()
    end
    if workspace:GetAttribute("GameState") == "Warmup" then
        u0.createNotification("Default", "GameState", "Warmup", 1)
    end
end

local function onCleanup(a1, a2) -- Line: 135 -- upvalues: cleanupNotificationTemplate (val) -- types: a2: number
    if a2 <= tick() - a1:GetAttribute("Timestamp") then
        cleanupNotificationTemplate(a1)
    end
end

local function scheduleCleanup(a1, a2) -- Line: 142 -- upvalues: cleanupNotificationTemplate (val) -- types: a2: number
    task.delay(a2, function() -- Line: 143 -- upvalues: a1 (val), a2 (val), cleanupNotificationTemplate (upval)
        if a1 and a1.Parent then
            local v1 = a1
            if a2 <= tick() - v1:GetAttribute("Timestamp") then
                cleanupNotificationTemplate(v1)
            end
        end
    end)
end

function u0.createNotification(a1, a2, a3, a4) -- Line: 153
    -- upvalues: u91 (ref), LocalPlayer (val), u78 (val), u60 (val), u64 (val), collectFadeTargets (val)
    -- upvalues: TweenService (val), u74 (val), GetPreferenceColor (val), InputController (val)
    local v1
    if not u91 then
        return
    end
    local v2 = u91:FindFirstChild(a2)
    if not LocalPlayer:GetAttribute("Team") then
        return
    end
    if not v2 then
        local Instance, v3, v4, v5
        v1 = u78[a1]
        if not v1 then
            warn((("[Notification]: ReplicatedStorage.Assets.UI.Notification has no \"%*\" template"):format(a1)))
            return nil
        end
        local v6 = not (a1 ~= "Invulnerable") and u60 or u64
        v2 = v1:Clone()
        v2.Size = v6
        v2.LayoutOrder = -(a4 or 1)
        v2.Name = a2
        local v7 = collectFadeTargets(v2)
        for i, j in v7 do
            j.Instance[j.Property] = 1
        end
        v2.Parent = u91
        for k, n in v7 do
            v3 = TweenService
            Instance = n.Instance
            v4 = u74
            v5 = {}
            v5[n.Property] = n.Value
            v3:Create(Instance, v4, v5):Play()
        end
    end
    v2:SetAttribute("Timestamp", (tick()))
    v2.Right.BackgroundColor3 = GetPreferenceColor()
    v2.Left.BackgroundColor3 = GetPreferenceColor()
    if v2:FindFirstChild("TextLabel") then
        v2.TextLabel.Text = a3
    end
    if a1 == "Invulnerable" then
        v1 = InputController.GetActionKeybind("Buy Menu") or "B"
        v2.Container.Context.Text = ("[%*] Open the Buy Menu"):format(v1)
        v2.Container.Header.TextColor3 = GetPreferenceColor()
    end
    return v2
end

function u0.removeNotification(a1) -- Line: 207 -- upvalues: u91 (ref) -- types: a1: string
    local v1 = u91 and u91:FindFirstChild(a1)
    if v1 then
        v1:Destroy()
    end
end

function u0.Initialize(a1, a2) -- Line: 214
    -- upvalues: u91 (ref), LocalPlayer (val), u0 (val), getHeaderText (val), GetPreferenceColor (val), u69 (val)
    -- upvalues: cleanupNotificationTemplate (val), GameState (val), DataController (val)
    u91 = a2

    local function updateDeathmatchSpawnCard() -- Line: 217
        -- upvalues: LocalPlayer (upval), u91 (upval), u0 (upval), getHeaderText (upval), GetPreferenceColor (upval)
        -- upvalues: u69 (upval)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            return
        end
        if not (LocalPlayer:GetAttribute("Invincible") == true) and not LocalPlayer:GetAttribute("BuyMenu") then
            local v1 = u91 and u91:FindFirstChild("Deathmatch Invincibility")
            if v1 then
                v1:Destroy()
            end
            if workspace:GetAttribute("GameState") == "Warmup" then
                u0.createNotification("Default", "GameState", "Warmup", 1)
            end
            return
        end
        local GameState = u91:FindFirstChild("GameState")
        u0.createNotification("Invulnerable", "Deathmatch Invincibility", "", 0)
        local v2 = u91 and u91:FindFirstChild("Deathmatch Invincibility")
        local Container = v2 and v2:FindFirstChild("Container")
        local Header = Container and Container:FindFirstChild("Header")
        local v3 = Header and Header:IsA("TextLabel") and Header or nil
        if v3 then
            local v4
            v3.Text = getHeaderText(v4)
            v3.TextColor3 = v4 and GetPreferenceColor() or u69
        end
        if GameState then
            GameState:Destroy()
        end
    end

    ;(LocalPlayer:GetAttributeChangedSignal("BuyMenu")):Connect(function() -- Line: 237 -- upvalues: LocalPlayer (upval), u91 (upval), u0 (upval), cleanupNotificationTemplate (upval)
        local Attribute = workspace:GetAttribute("Gamemode")
        if not LocalPlayer:GetAttribute("BuyMenu") and Attribute == "Deathmatch" then
            if not LocalPlayer:GetAttribute("Invincible") then
                local v1 = u91 and u91:FindFirstChild("Deathmatch Invincibility")
                if v1 then
                    v1:Destroy()
                end
                if workspace:GetAttribute("GameState") == "Warmup" then
                    u0.createNotification("Default", "GameState", "Warmup", 1)
                end
            end
            local u43 = u0.createNotification("Default", "Your buy period has expired", "Your buy period has expired", 2)
            task.delay(2, function() -- Line: 246 -- upvalues: u43 (val), cleanupNotificationTemplate (upval)
                if u43 and u43.Parent then
                    cleanupNotificationTemplate(u43)
                end
            end)
        end
    end)
    ;(LocalPlayer:GetAttributeChangedSignal("Invincible")):Connect(updateDeathmatchSpawnCard)
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 257 -- upvalues: updateDeathmatchSpawnCard (val), u91 (upval), u0 (upval)
        local Attribute = workspace:GetAttribute("GameState")
        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            updateDeathmatchSpawnCard()
            return
        end
        local v1 = u91 and u91:FindFirstChild("Deathmatch Invincibility")
        if v1 then
            v1:Destroy()
        end
        if Attribute == "Warmup" then
            u0.createNotification("Default", "GameState", "Warmup", 1)
            return
        end
        local GameState = u91 and u91:FindFirstChild("GameState")
        if GameState then
            GameState:Destroy()
        end
    end)
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 274 -- upvalues: u91 (upval)
        local v1 = u91 and u91:FindFirstChild("Deathmatch Invincibility")
        if v1 then
            v1:Destroy()
        end
    end)
    GameState.ListenToState(function(a1) -- Line: 279 -- upvalues: u91 (upval)
        if a1 == "Warmup" then
            local GameState = u91 and u91:FindFirstChild("GameState")
            if GameState then
                GameState:Destroy()
            end
        end
    end)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(function() -- Line: 286 -- upvalues: u91 (upval)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            local v1 = u91 and u91:FindFirstChild("Deathmatch Invincibility")
            if v1 then
                v1:Destroy()
            end
        end
    end)

    local function refreshOpenNotifications() -- Line: 293 -- upvalues: GetPreferenceColor (upval), u91 (upval)
        local v1 = GetPreferenceColor()
        for i, v in ipairs(u91:GetChildren()) do
            if v:IsA("Frame") then
                v.Right.BackgroundColor3 = v1
                v.Left.BackgroundColor3 = v1
            end
        end
    end

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshOpenNotifications)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(refreshOpenNotifications)
end

function u0.Start() -- Line: 310 -- upvalues: Remotes (val), u0 (val), cleanupNotificationTemplate (val), Router (val)
    Remotes.UI.ShowNotification.Listen(function(a1) -- Line: 311 -- upvalues: u0 (upval), cleanupNotificationTemplate (upval)
        local u7 = u0.createNotification("Default", a1.header, a1.message, 2)
        local timeLength = a1.timeLength
        task.delay(timeLength, function() -- Line: 143 -- upvalues: u7 (val), timeLength (val), cleanupNotificationTemplate (upval)
            if u7 and u7.Parent then
                local v1 = u7
                if timeLength <= tick() - v1:GetAttribute("Timestamp") then
                    cleanupNotificationTemplate(v1)
                end
            end
        end)
    end)
    Router.observerRouter("CreateNotification", function(a1, a2, a3) -- Line: 316
        -- upvalues: u0 (upval), cleanupNotificationTemplate (upval)
        local u9 = u0.createNotification("Default", a1, a2, 2)
        task.delay(a3, function() -- Line: 143 -- upvalues: u9 (val), a3 (val), cleanupNotificationTemplate (upval)
            if u9 and u9.Parent then
                local v1 = u9
                if a3 <= tick() - v1:GetAttribute("Timestamp") then
                    cleanupNotificationTemplate(v1)
                end
            end
        end)
    end)
end

return u0