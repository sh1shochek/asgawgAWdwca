-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu
-- Decompile time: 33.79 ms

local u0 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local LocalPlayer = Players.LocalPlayer
local u54 = RunService:IsStudio()
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps
local u59 = {
    {Name = "DropKnife", Label = "Drop Knife", Key = "KnifeDropEnabled"},
    {Name = "FreezeTimer", Label = "Freeze Timer", Key = "TimerFrozen"},
    {Name = "KillTrading", Label = "Kill Trading", Key = "KillTradingEnabled"},
    {Name = "InfiniteAmmo", Label = "Infinite Ammo", Key = "InfiniteAmmoEnabled"},
    {Name = "InfiniteCash", Label = "Infinite Cash", Key = "InfiniteCashEnabled"},
    {Name = "DisableTeamLimit", Label = "Disable Team Limit", Key = "DisableTeamLimitEnabled"},
    {Name = "FriendlyFire", Label = "Friendly Fire", Key = "FriendlyFireEnabled"},
    {Name = "PlayerCollisions", Label = "Player Collisions", Key = "PlayerCollisionsEnabled"},
    {Name = "CompetitiveMovement", Label = "Competitive Movement", Key = "CompetitiveMovementEnabled"},
}
local u69 = {"Easy", "Normal", "Hard", "Expert"}
local u74 = {}
u74.Easy = Color3.fromRGB(126, 211, 133)
u74.Normal = Color3.fromRGB(238, 238, 238)
u74.Hard = Color3.fromRGB(240, 168, 76)
u74.Expert = Color3.fromRGB(236, 88, 88)
local u95 = {}
local v1 = {
    Name = "TerroristBots",
    Label = "Terrorist Bots",
    Key = "BotTerrorists",
    OtherKey = "BotCounterTerrorists",
    Accent = Color3.fromRGB(222, 176, 82),
}
local v2 = {
    Name = "CounterTerroristBots",
    Label = "CT Bots",
    Key = "BotCounterTerrorists",
    OtherKey = "BotTerrorists",
    Accent = Color3.fromRGB(104, 158, 228),
}
u95[1] = v1
u95[2] = v2
local u112 = Color3.fromRGB(255, 255, 255)
local u117 = Color3.fromRGB(150, 150, 150)
local u122 = Color3.fromRGB(125, 206, 243)
local u127 = Color3.fromRGB(92, 92, 92)
local u132 = Color3.fromRGB(32, 32, 32)
local u137 = Color3.fromRGB(150, 44, 44)
local u142 = Color3.fromRGB(236, 96, 96)
local u147 = Color3.fromRGB(255, 255, 255)
local u152 = Color3.fromRGB(77, 77, 77)
local u157 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u162 = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local u167 = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local u172 = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local u177 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local u182 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u183 = {
    {
        Name = "Competitive",
        Mode = "COMPETITIVE",
        Description = "Classic round-based rules with economy and no respawns.",
        ServerGamemode = "Competitive",
        Image = "rbxassetid://94623163725066",
    },
    {
        Name = "Casual",
        Mode = "CASUAL",
        Description = "Relaxed round-based rules with lighter penalties.",
        ServerGamemode = "Casual",
        Image = "rbxassetid://129151622905807",
    },
    {
        Name = "Deathmatch",
        Mode = "DEATHMATCH",
        Description = "Fast respawn combat focused on eliminations.",
        ServerGamemode = "Deathmatch",
        Image = "rbxassetid://102545840590668",
    },
    {
        Name = "Surf",
        Mode = "SURF",
        Description = "Slide down ramps with CS:GO surf movement.",
        ServerGamemode = "Surf",
    },
}
local u188 = {
    GodMode = {Key = "GodModeEnabledPlayers", Title = "God Mode"},
    ESP = {Key = "ESPEnabledPlayers", Title = "ESP"},
}
local u191 = {}
local u192 = {}
local u193 = {}
local u194 = false
local u195 = nil
local u196 = {}
local u197 = "Settings"
local u198 = "KickPlayer"
local u199 = {}
local u200 = {}
local u201 = {}
local u202 = false
local u203 = nil
local u207 = setmetatable({}, {__mode = "k"})
local u211 = setmetatable({}, {__mode = "k"})
local u213 = Janitor.new()
local u215 = Janitor.new()
local u217 = Janitor.new()
local u219 = Janitor.new()
local u221 = Janitor.new()
local u222 = nil
local u223 = nil
local u224 = nil
local u225 = 0
local u226 = {}
local u227 = nil
local u228 = nil
local u229 = nil
local u230 = nil
local u231 = nil
local u232 = nil
local u233 = nil
local u234 = nil
local u235 = nil
local u236 = nil
local u237 = nil
local u238 = nil
local u239 = nil

local function canUseVIPMenu() -- Line: 178 -- upvalues: u54 (val), LocalPlayer (val)
    return u54 or LocalPlayer:GetAttribute("CanUseVIPMenu") == true
end

local function hasActiveCharacter() -- Line: 182 -- upvalues: LocalPlayer (val)
    local Character = LocalPlayer.Character
    local v1 = false
    if Character ~= nil then
        v1 = Character:IsDescendantOf(workspace)
    end
    return v1
end

local function isOnPlayingTeam() -- Line: 187 -- upvalues: LocalPlayer (val)
    local Attribute = LocalPlayer:GetAttribute("Team")
    local v1 = true
    if Attribute ~= "Counter-Terrorists" then
        v1 = Attribute == "Terrorists"
    end
    return v1
end

local function isInGameplayContext() -- Line: 192 -- upvalues: LocalPlayer (val)
    local Attribute = LocalPlayer:GetAttribute("Team")
    local v1 = true
    if Attribute ~= "Counter-Terrorists" then
        v1 = Attribute == "Terrorists"
    end
    if not v1 then
        v1 = LocalPlayer:GetAttribute("IsSpectating") == true
    end
    return v1
end

local function getMainGuiFromRoot() -- Line: 196 -- upvalues: u222 (ref)
    local Parent = u222 and u222.Parent
    local Parent_2 = Parent and Parent.Parent
    local Parent_3 = Parent_2 and Parent_2.Parent
    if Parent_3 and Parent_3:IsA("ScreenGui") then
        return Parent_3
    end
    return nil
end

local function isMainMenuVisible() -- Line: 206 -- upvalues: u222 (ref)
    local v1
    local Parent = u222 and u222.Parent
    local Parent_2 = Parent and Parent.Parent
    local Parent_3 = Parent_2 and Parent_2.Parent
    if not (if not Parent_3 then nil else if not Parent_3:IsA("ScreenGui") then nil else Parent_3) then
        return false
    end
    local Menu = v1:FindFirstChild("Menu")
    local Visible = false
    if Menu ~= nil then
        Visible = Menu:IsA("GuiObject") and Menu.Visible
    end
    return Visible
end

local function isTeamSelectionVisible() -- Line: 216 -- upvalues: u222 (ref)
    local v1
    local Parent = u222 and u222.Parent
    local Parent_2 = Parent and Parent.Parent
    local Parent_3 = Parent_2 and Parent_2.Parent
    if not (if not Parent_3 then nil else if not Parent_3:IsA("ScreenGui") then nil else Parent_3) then
        return false
    end
    local Gameplay = v1:FindFirstChild("Gameplay")
    if Gameplay and Gameplay:IsA("GuiObject") then
        local Middle = Gameplay:FindFirstChild("Middle")
        if Middle and Middle:IsA("GuiObject") then
            local TeamSelection = Middle:FindFirstChild("TeamSelection")
            local Visible = false
            if TeamSelection ~= nil then
                Visible = TeamSelection:IsA("GuiObject") and TeamSelection.Visible
            end
            return Visible
        end
        return false
    end
    return false
end

local function isLocalPlayerSpectating() -- Line: 236 -- upvalues: LocalPlayer (val)
    return LocalPlayer:GetAttribute("IsSpectating") == true
end

local function bindPress(a1, a2, a3) -- Line: 240 -- types: a2: userdata, a3: function
    if a2:IsA("GuiButton") then
        a1:Add((a2.MouseButton1Click:Connect(a3)))
        return
    end
    a2.Active = true
    a1:Add((a2.InputBegan:Connect(function(a1) -- Line: 249 -- upvalues: a3 (val)
        local UserInputType = a1.UserInputType
        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        a3()
    end)))
end

local function bindHover(a1, a2, a3) -- Line: 259 -- types: a2: userdata, a3: function
    a1:Add((a2.MouseEnter:Connect(function() -- Line: 260 -- upvalues: a3 (val)
        a3(true)
    end)))
    a1:Add((a2.MouseLeave:Connect(function() -- Line: 263 -- upvalues: a3 (val)
        a3(false)
    end)))
end

local function tween(a1, a2, a3) -- Line: 268
    -- upvalues: TweenService (val)
    local v1 = TweenService:Create(a1, a2, a3)
    v1:Play()
    return v1
end

local function paintButton(a1) -- Line: 274
    -- upvalues: u207 (val), u211 (val), u157 (val), TweenService (val)
    local v1 = u207[a1]
    if v1 then
        TweenService:Create(a1, u157, {
            BackgroundColor3 = if not u211[a1] then v1 else v1:Lerp(Color3.new(1, 1, 1), 0.12),
        }):Play()
    end
end

local function setButtonColor(a1, a2) -- Line: 282
    -- upvalues: u207 (val), paintButton (val)
    u207[a1] = a2
    paintButton(a1)
end

local function bindButtonHover(a1, a2) -- Line: 287
    -- upvalues: u207 (val), bindHover (val), u211 (val), paintButton (val)
    local BackgroundColor3 = u207[a2] or a2.BackgroundColor3
    u207[a2] = BackgroundColor3
    bindHover(a1, a2, function(a1) -- Line: 289 -- upvalues: u211 (upval), a2 (val), paintButton (upval)
        u211[a2] = if not a1 then nil else true
        paintButton(a2)
    end)
end

local function getScale(a1) -- Line: 295 -- types: a1: userdata
    local UIScale = a1:FindFirstChildOfClass("UIScale")
    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = a1
    end
    return UIScale
end

local function popIn(a1, a2, a3) -- Line: 305
    -- upvalues: u177 (val), TweenService (val)
    local UIScale = a1:FindFirstChildOfClass("UIScale")
    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = a1
    end
    UIScale.Scale = a2
    TweenService:Create(
        UIScale,
        if not a3 then u177 else TweenInfo.new(u177.Time, u177.EasingStyle, u177.EasingDirection, 0, false, a3),
        {Scale = 1}
    ):Play()
end

local function slideIn(a1, a2) -- Line: 315
    -- upvalues: u172 (val), TweenService (val)
    local Attribute = a1:GetAttribute("BasePosition")
    if typeof(Attribute) ~= "UDim2" then
        a1:SetAttribute("BasePosition", a1.Position)
    end
    a1.Position = Attribute + a2
    TweenService:Create(a1, u172, {Position = Attribute}):Play()
end

local function punchLabel(a1) -- Line: 326 -- upvalues: u182 (val), TweenService (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute("BaseSize")
    if typeof(Attribute) ~= "UDim2" then
        a1:SetAttribute("BaseSize", a1.Size)
    end
    local v1 = Attribute
    a1.Size = UDim2.new(v1.X.Scale, v1.X.Offset, v1.Y.Scale * 1.3, v1.Y.Offset)
    TweenService:Create(a1, u182, {Size = v1}):Play()
end

local function setLabelValue(a1, a2, a3) -- Line: 337
    -- upvalues: punchLabel (val)
    a1.TextColor3 = a3
    if a1.Text ~= a2 then
        a1.Text = a2
        punchLabel(a1)
    end
end

local function playClick() -- Line: 345 -- upvalues: Router (val)
    Router.broadcastRouter("RunInterfaceSound", "UI Click")
end

local function clearGenerated(a1, a2, a3) -- Line: 349 -- types: a1: userdata, a2: userdata, a3: table?
    local v1, v2 = a2, a3
    for i, v in ipairs(a1:GetChildren()) do
        if v ~= v1 then
            if not v2 then
                if v:IsA("GuiObject") then
                    v:Destroy()
                end
            elseif not v2[v.Name] and v:IsA("GuiObject") then
                v:Destroy()
            end
        end
    end
    v1.Visible = false
end

local function getTogglePlayers(a1) -- Line: 364 -- upvalues: u191 (ref) -- types: a1: string
    local v1 = u191[a1]
    if typeof(v1) == "table" then
        return v1
    end
    local v2 = {}
    u191[a1] = v2
    return v2
end

local function setLocalTogglePlayer(a1, a2, a3) -- Line: 375
    -- upvalues: u191 (ref)
    local v1, v2
    local v3 = u191[a1]
    if typeof(v3) ~= "table" then
        v2 = {}
        u191[a1] = v2
        v1 = v2
    else
        v1 = v3
    end
    v1[a2] = nil
    v2 = if not a3 then nil else true
    v1[(tostring(a2))] = v2
    return v1
end

local function isPlayerToggleEnabled(a1, a2) -- Line: 382 -- upvalues: u191 (ref) -- types: a1: string, a2: number
    local v1 = u191[a1]
    if typeof(v1) ~= "table" then
        return false
    end
    local v2 = true
    if v1[tostring(a2)] ~= true then
        v2 = v1[a2] == true
    end
    return v2
end

local function updateVoteKickHeader() -- Line: 391 -- upvalues: u232 (ref), u188 (val), u198 (ref)
    if not u232 then
        return
    end
    local v1 = u188[u198]
    u232.Text = string.upper(if not v1 then "Kick Player" else v1.Title)
end

local function updateRootPosition(a1) -- Line: 401
    -- upvalues: u230 (ref), u222 (ref), u172 (val), TweenService (val)
    local v1 = UDim2.new(0.5, if not u230.Visible then 0 else -(u230.AbsoluteSize.X + u222.AbsoluteSize.X * 0.02) / 2, 0.5, 0)
    if a1 then
        TweenService:Create(u222, u172, {Position = v1}):Play()
        return
    end
    u222.Position = v1
end

local function setTabVisual(a1, a2) -- Line: 411
    -- upvalues: u127 (val), u132 (val), u207 (val), paintButton (val)
    u207[a1] = if not a2 then u132 else u127
    paintButton(a1)
    local Selected = a1:FindFirstChild("Selected")
    if Selected and Selected:IsA("GuiObject") then
        Selected.Visible = a2
    end
end

local function staggerCards(a1) -- Line: 420 -- upvalues: popIn (val) -- types: a1: userdata
    local v1 = {}
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("GuiObject") and v.Visible then
            table.insert(v1, v)
        end
    end
    table.sort(v1, function(a1, a2) -- Line: 427
        return a1.LayoutOrder < a2.LayoutOrder
    end)
    for i2, i3 in ipairs(v1) do
        popIn(i3, 0.9, (i2 - 1) * 0.035)
    end
end

local function showPanel(a1, a2) -- Line: 435
    -- upvalues: u197 (ref), u227 (ref), u228 (ref), u229 (ref), u226 (ref), u127 (val), u132 (val), u207 (val)
    -- upvalues: paintButton (val), slideIn (val), staggerCards (val)
    local Selected, v1, v2
    u197 = a1
    u227.Visible = a1 == "Settings"
    u228.Visible = a1 == "MapSelect"
    u229.Visible = a1 == "ModeSelect"
    local v3, v4 = a2, a1
    for k, v in pairs(u226) do
        v2 = if not (k == v4) then u132 else u127
        u207[v] = v2
        paintButton(v)
        Selected = v:FindFirstChild("Selected")
        if Selected and Selected:IsA("GuiObject") then
            Selected.Visible = v1
        end
    end
    if v3 then
        slideIn(if v4 ~= "Settings" then if v4 ~= "MapSelect" then u229 else u228 else u227, UDim2.fromOffset(0, 16))
        if v4 ~= "Settings" then
            local v5
            staggerCards(v5)
        end
    end
end

local function showPlayers() -- Line: 453
    -- upvalues: u232 (ref), u188 (val), u198 (ref), u230 (ref), slideIn (val), updateRootPosition (val)
    if u232 then
        local v1 = u188[u198]
        u232.Text = string.upper(if not v1 then "Kick Player" else v1.Title)
    end
    if not u230.Visible then
        u230.Visible = true
        slideIn(u230, UDim2.fromOffset(-40, 0))
    end
    updateRootPosition(true)
end

local function hidePlayers(a1) -- Line: 462 -- upvalues: u230 (ref), updateRootPosition (val) -- types: a1: boolean
    u230.Visible = false
    updateRootPosition(a1)
end

local function getMapInfo(a1) -- Line: 467 -- upvalues: u196 (val), Maps (val) -- types: a1: string
    if u196[a1] ~= nil then
        return u196[a1]
    end
    local v1 = Maps:FindFirstChild(a1)
    local init = v1 and (if not v1:IsA("ModuleScript") then v1:FindFirstChild("init") else v1)
    if init and init:IsA("ModuleScript") then
        local v2
        local success, result = pcall(require, init)
        u196[a1] = if not success then nil else if typeof(result) ~= "table" then nil else result
        return v2
    end
    return nil
end

local function mapSupportsMode(a1, a2) -- Line: 484 -- upvalues: getMapInfo (val) -- types: a1: string, a2: string?
    if not a2 then
        return true
    end
    local v1 = getMapInfo(a1)
    local Gamemode = v1 and v1.Gamemode
    if typeof(Gamemode) ~= "table" then
        return false
    end
    local v2 = Gamemode[a2]
    local v3 = false
    if v2 ~= nil then
        v3 = v2 ~= false
    end
    return v3
end

local function loadAvailableMaps() -- Line: 499 -- upvalues: u193 (ref), Maps (val), u196 (val), u194 (ref)
    local Name, init, result, success, v1
    u193 = {}
    for i, v in ipairs(Maps:GetChildren()) do
        Name = v.Name
        init = if not v:IsA("ModuleScript") then v:FindFirstChild("init") else v
        if init and init:IsA("ModuleScript") then
            success, result = pcall(require, init)
            if success and typeof(result) == "table" and result.Hidden ~= true then
                u196[Name] = result
                if Name ~= "Tutorial Range" then
                    v1 = {Name = Name}
                    v1.Icon = not (typeof(result.Icon) ~= "string") and result.Icon or ""
                    table.insert(u193, v1)
                end
            end
        end
    end
    table.sort(u193, function(a1, a2) -- Line: 531
        return a1.Name < a2.Name
    end)
    u194 = true
end

local function getGamemodeIcon(a1) -- Line: 538 -- upvalues: u193 (ref), getMapInfo (val) -- types: a1: string
    local Gamemode, Name, v1, v2, v3
    local v4 = a1
    for i, v in ipairs(u193) do
        Name = v.Name
        if v4 then
            v3 = getMapInfo(Name)
            Gamemode = v3 and v3.Gamemode
            if typeof(Gamemode) == "table" then
                v1 = Gamemode[v4]
                v2 = false
                if v1 ~= nil then
                    v2 = v1 ~= false
                end
            else
                v2 = false
            end
        else
            v2 = true
        end
        if v2 and v.Icon ~= "" then
            return v.Icon
        end
    end
    return nil
end

local function setSegments(a1, a2, a3, a4) -- Line: 551
    -- upvalues: u152 (val), u147 (val), u157 (val), TweenService (val)
    local Frame, v1
    local UIListLayout = a1:FindFirstChildOfClass("UIListLayout")
    local v2 = if not (a2 > 4) then 0.03 else 0.012
    if UIListLayout then
        UIListLayout.Padding = UDim.new(v2, 0)
    end
    local v3 = {}
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("Frame") then
            table.insert(v3, v)
        end
    end
    for i2 = #v3 + 1, a2 do
        Frame = Instance.new("Frame")
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = u152
        Frame.Parent = a1
        v3[i2] = Frame
    end
    local v4 = (1 - v2 * (a2 - 1)) / a2
    for i3, j in ipairs(v3) do
        j.Name = tostring(i3)
        j.LayoutOrder = i3
        v1 = i3 <= a2
        j.Visible = v1
        j.Size = UDim2.fromScale(v4, 1)
        v1 = if not v5(i3) then u152 else v6 or u147
        if j.BackgroundColor3 ~= v1 then
            TweenService:Create(j, u157, {BackgroundColor3 = v1}):Play()
        end
    end
end

local function setArrowEnabled(a1, a2) -- Line: 585 -- types: a1: userdata, a2: boolean
    a1:SetAttribute("Enabled", a2)
    if a1:IsA("ImageButton") then
        a1.ImageTransparency = if not a2 then 0.75 else 0
    end
end

local function setToggleSelector(a1, a2) -- Line: 592
    -- upvalues: u112 (val), punchLabel (val), setSegments (val)
    local Title = a1.Title
    local v1 = if not a2 then "OFF" else "ON"
    Title.TextColor3 = u112
    if Title.Text ~= v1 then
        Title.Text = v1
        punchLabel(Title)
    end
    setSegments(a1.Bar, 2, function(a1) -- Line: 594 -- upvalues: a2 (val)
        return a1 == (if not a2 then 1 else 2)
    end)
    local Decrease = a1.Decrease
    Decrease:SetAttribute("Enabled", a2)
    if Decrease:IsA("ImageButton") then
        Decrease.ImageTransparency = if not a2 then 0.75 else 0
    end
    local Increase = a1.Increase
    v1 = not a2
    Increase:SetAttribute("Enabled", v1)
    if Increase:IsA("ImageButton") then
        Increase.ImageTransparency = if not v1 then 0.75 else 0
    end
end

local function isBotAutoFill() -- Line: 601 -- upvalues: u191 (ref)
    return u191.BotAutoFill ~= false
end

local function areBotsFrozen() -- Line: 605 -- upvalues: u191 (ref)
    return u191.BotsFrozen == true
end

local function getBotCount(a1) -- Line: 609 -- upvalues: u191 (ref) -- types: a1: string
    local v1 = u191[a1]
    if typeof(v1) == "number" then
        return v1
    end
    return 0
end

local function getBotDifficulty() -- Line: 614 -- upvalues: u191 (ref), u69 (val)
    local BotDifficulty = u191.BotDifficulty
    if table.find(u69, BotDifficulty) then
        return BotDifficulty
    end
    return u69[1]
end

local function refreshBotControls() -- Line: 619
    -- upvalues: u191 (ref), u95 (val), u201 (val), u117 (val), u112 (val), punchLabel (val), setSegments (val)
    -- upvalues: u69 (val), u74 (val), setToggleSelector (val)
    local Accent, Bar_2, Decrease_2, Increase_2, Key, OtherKey, Title_2, v1, v2, v3
    local v4 = u191.BotAutoFill ~= false
    for i, v in ipairs(u95) do
        v2 = u201[v.Name]
        if v2 then
            Key = v.Key
            v3 = u191[Key]
            if typeof(v3) ~= "number" then
                u138 = 0
            else
                local u138 = v3
            end
            Title_2 = v2.Title
            v3 = tostring(u138)
            Title_2.TextColor3 = if not v4 then u112 else u117
            if Title_2.Text ~= v3 then
                Title_2.Text = v3
                punchLabel(Title_2)
            end
            Bar_2 = v2.Bar
            Accent = if not v4 then v.Accent else u117
            setSegments(Bar_2, 14, function(a1) -- Line: 627 -- upvalues: u138 (val)
                return a1 <= u138
            end, Accent)
            Decrease_2 = v2.Decrease
            Decrease_2:SetAttribute("Enabled", u138 > 0)
            if Decrease_2:IsA("ImageButton") then
                Decrease_2.ImageTransparency = if not v3 then 0.75 else 0
            end
            Increase_2 = v2.Increase
            OtherKey = v.OtherKey
            v1 = u191[OtherKey]
            Increase_2:SetAttribute("Enabled", u138 + (if typeof(v1) ~= "number" then 0 else v1) < 14)
            if Increase_2:IsA("ImageButton") then
                Increase_2.ImageTransparency = if not v3 then 0.75 else 0
            end
        end
    end
    local BotDifficulty = u201.BotDifficulty
    if BotDifficulty then
        local v5
        local BotDifficulty_2 = u191.BotDifficulty
        local u31 = table.find(u69, if not table.find(u69, BotDifficulty_2) then u69[1] else BotDifficulty_2)
        local Title = BotDifficulty.Title
        local v6 = string.upper(v5)
        Title.TextColor3 = u74[v5]
        if Title.Text ~= v6 then
            Title.Text = v6
            punchLabel(Title)
        end
        setSegments(BotDifficulty.Bar, #u69, function(a1) -- Line: 639 -- upvalues: u31 (val)
            return a1 <= u31
        end, u74[v5])
        local Decrease = BotDifficulty.Decrease
        Decrease:SetAttribute("Enabled", u31 > 1)
        if Decrease:IsA("ImageButton") then
            Decrease.ImageTransparency = if not v6 then 0.75 else 0
        end
        local Increase = BotDifficulty.Increase
        Increase:SetAttribute("Enabled", u31 < #u69)
        if Increase:IsA("ImageButton") then
            Increase.ImageTransparency = if not v6 then 0.75 else 0
        end
    end
    if u201.BotAutoFill then
        setToggleSelector(u201.BotAutoFill, v4)
    end
    if u201.BotsFrozen then
        setToggleSelector(u201.BotsFrozen, u191.BotsFrozen == true)
    end
end

local function updateToggleIndicators() -- Line: 653
    -- upvalues: u59 (val), u201 (val), setToggleSelector (val), u191 (ref), refreshBotControls (val)
    local v1
    for i, v in ipairs(u59) do
        v1 = u201[v.Name]
        if v1 then
            setToggleSelector(v1, u191[v.Key] == true)
        end
    end
    refreshBotControls()
end

local function setCardSelected(a1, a2) -- Line: 663 -- upvalues: popIn (val) -- types: a1: userdata, a2: boolean
    local Badge = a1:FindFirstChild("Badge")
    if Badge and Badge:IsA("GuiObject") then
        local Visible = Badge.Visible
        Badge.Visible = a2
        if a2 and not Visible then
            popIn(Badge, 0.5)
        end
    end
    local Highlight = a1:FindFirstChild("Highlight", true)
    if Highlight and Highlight:IsA("UIStroke") then
        Highlight.Enabled = a2
    end
end

local function bindCardHover(a1, a2) -- Line: 679
    -- upvalues: bindHover (val), u172 (val), TweenService (val)
    local Image = a2:FindFirstChild("Image", true)
    if Image and Image:IsA("ImageLabel") then
        local ImageColor3 = Image.ImageColor3
        bindHover(a1, a2, function(a1) -- Line: 686 -- upvalues: Image (val), u172 (upval), ImageColor3 (val), TweenService (upval)
            local v1 = if not a1 then 1 else 1.06
            local v2 = u172
            local v3 = {
                ImageColor3 = if not a1 then ImageColor3 else ImageColor3:Lerp(Color3.new(1, 1, 1), 0.35),
                Size = UDim2.fromScale(v1, v1),
            }
            TweenService:Create(Image, v2, v3):Play()
        end)
        return
    end
end

local function refreshMaps() -- Line: 698
    -- upvalues: u193 (ref), u199 (val), u195 (ref), getMapInfo (val), setCardSelected (val), u191 (ref)
    local Gamemode, v1, v2, v3, v4, v5
    for i, v in ipairs(u193) do
        v2 = u199[v.Name]
        if v2 then
            v4 = u195
            if v4 then
                v5 = getMapInfo(v.Name)
                Gamemode = v5 and v5.Gamemode
                if typeof(Gamemode) == "table" then
                    v1 = Gamemode[v4]
                    v3 = false
                    if v1 ~= nil then
                        v3 = v1 ~= false
                    end
                else
                    v3 = false
                end
            else
                v3 = true
            end
            v2.Visible = v3
            setCardSelected(v2, u191.NextMap == v.Name)
        end
    end
end

local function buildMapEntries() -- Line: 708
    -- upvalues: u194 (ref), u217 (val), u199 (val), clearGenerated (val), u228 (ref), u237 (ref), u193 (ref)
    -- upvalues: bindCardHover (val), bindPress (val), Router (val), u191 (ref), Remotes (val), refreshMaps (val)
    local Image, MapName, v1
    if not u194 then
        return
    end
    u217:Cleanup()
    table.clear(u199)
    clearGenerated(u228, u237, nil)
    for i, v in ipairs(u193) do
        v1 = u237:Clone()
        v1.Name = v.Name
        v1.LayoutOrder = i
        v1.Visible = true
        Image = v1:FindFirstChild("Image", true)
        Image.Image = v.Icon
        MapName = v1:WaitForChild("MapName")
        MapName.Text = string.upper(v.Name)
        bindCardHover(u217, v1)
        bindPress(u217, v1, function() -- Line: 729 -- upvalues: Router (upval), u191 (upval), v (val), Remotes (upval), refreshMaps (upval)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u191.NextMap = v.Name
            Remotes.VIP.SetSetting.Send({Key = "NextMap", Value = v.Name})
            refreshMaps()
        end)
        v1.Parent = u228
        u199[v.Name] = v1
    end
    refreshMaps()
end

local function refreshModeCards() -- Line: 743
    -- upvalues: u191 (ref), u195 (ref), u183 (val), u200 (val), setCardSelected (val)
    local v1
    local NextGamemode_2 = if typeof(u191.NextGamemode) ~= "string" then u195 else u191.NextGamemode
    for i, v in ipairs(u183) do
        v1 = u200[v.Name]
        if v1 then
            setCardSelected(v1, NextGamemode_2 == v.ServerGamemode)
        end
    end
end

local function buildModeCards() -- Line: 754
    -- upvalues: u219 (val), u200 (val), clearGenerated (val), u229 (ref), u238 (ref), u183 (val), getGamemodeIcon (val)
    -- upvalues: bindCardHover (val), bindPress (val), Router (val), u195 (ref), Remotes (val), refreshModeCards (val)
    -- upvalues: showPanel (val), refreshMaps (val)
    local Description, Image, Image_2, Mode, v1
    u219:Cleanup()
    table.clear(u200)
    clearGenerated(u229, u238, nil)
    local UIListLayout = u229:FindFirstChildOfClass("UIListLayout")
    local Scale = if not UIListLayout then 0 else UIListLayout.Padding.Scale
    local v2 = #u183
    local v3 = (1 - Scale * (v2 - 1)) / v2
    for i, v in ipairs(u183) do
        v1 = u238:Clone()
        v1.Name = v.Name
        v1.LayoutOrder = i
        v1.Size = UDim2.fromScale(v3, 1)
        v1.Visible = true
        Mode = v1:WaitForChild("Mode")
        Description = v1:WaitForChild("Description")
        Image = v1:FindFirstChild("Image", true)
        Mode.Text = v.Mode
        Description.Text = v.Description
        Image_2 = v.Image or getGamemodeIcon(v.ServerGamemode) or ""
        Image.Image = Image_2
        bindCardHover(u219, v1)
        bindPress(u219, v1, function() -- Line: 780
            -- upvalues: Router (upval), u195 (upval), v (val), Remotes (upval), refreshModeCards (upval)
            -- upvalues: showPanel (upval), refreshMaps (upval)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u195 = v.ServerGamemode
            Remotes.VIP.SetSetting.Send({Key = "NextGamemode", Value = v.ServerGamemode})
            refreshModeCards()
            showPanel("MapSelect", true)
            refreshMaps()
        end)
        v1.Parent = u229
        u200[v.Name] = v1
    end
    refreshModeCards()
end

local function renderPlayers() -- Line: 796
    -- upvalues: u221 (val), clearGenerated (val), u231 (ref), u239 (ref), u188 (val), u198 (ref), u192 (ref)
    -- upvalues: LocalPlayer (val), u122 (val), u117 (val), u191 (ref), u142 (val), u207 (val), bindHover (val)
    -- upvalues: u211 (val), paintButton (val), bindPress (val), Router (val), Remotes (val), u230 (ref)
    -- upvalues: updateRootPosition (val)
    local Avatar, BackgroundColor3, Bomb, Key, Left, Name, UserId_3, setToggleModeVisual, v1, v2
    u221:Cleanup()
    clearGenerated(u231, u239, nil)
    local u145 = u188[u198]
    local v3 = 1
    for i, v in ipairs(u192) do
        if u198 ~= "KickPlayer" or v.UserId ~= LocalPlayer.UserId then
            local u32 = u239:Clone()
            u32.Name = tostring(v.UserId)
            u32.LayoutOrder = v3
            u32.Visible = true
            v3 = v3 + 1
            Left = u32:WaitForChild("Left")
            Avatar = Left:WaitForChild("Avatar")
            Name = Left:WaitForChild("Name")
            Bomb = Avatar:WaitForChild("Bomb")
            local State = (u32:WaitForChild("Right")):WaitForChild("State")
            local Selected = u32:WaitForChild("Selected")
            Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(v.UserId)
            Name.Text = v.DisplayName
            Bomb.Visible = v.Team == "Terrorists"

            function setToggleModeVisual(a1) -- Line: 824
                -- upvalues: Selected (val), State (val), u122 (upval), u117 (upval)
                Selected.Visible = a1
                State.Text = if not a1 then "OFF" else "ON"
                State.TextColor3 = if not a1 then u117 else u122
            end

            if not u145 then
                Selected.Visible = false
                State.Text = "KICK"
                State.TextColor3 = u142
            else
                Key = u145.Key
                UserId_3 = v.UserId
                v2 = u191[Key]
                if typeof(v2) == "table" then
                    v1 = true
                    if v2[tostring(UserId_3)] ~= true then
                        v1 = v2[UserId_3] == true
                    end
                else
                    v1 = false
                end
                Selected.Visible = v1
                State.Text = if not v1 then "OFF" else "ON"
                State.TextColor3 = if not v1 then u117 else u122
            end
            BackgroundColor3 = u207[u32] or u32.BackgroundColor3
            u207[u32] = BackgroundColor3
            bindHover(u221, u32, function(a1) -- Line: 289 -- upvalues: u211 (upval), u32 (val), paintButton (upval)
                u211[u32] = if not a1 then nil else true
                paintButton(u32)
            end)
            bindPress(u221, u32, function() -- Line: 839
                -- upvalues: Router (upval), u145 (val), v (val), u191 (upval), Selected (val), State (val)
                -- upvalues: u122 (upval), u117 (upval), Remotes (upval), u230 (upval), updateRootPosition (upval)
                local v1, v2
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                if not u145 then
                    Selected.Visible = true
                    Remotes.VIP.ExecuteAction.Send({Action = "KickPlayer", Params = v.UserId})
                    u230.Visible = false
                    updateRootPosition(true)
                    return
                end
                local Key = u145.Key
                local UserId = v.UserId
                local v3 = u191[Key]
                if typeof(v3) == "table" then
                    v1 = true
                    if v3[tostring(UserId)] ~= true then
                        v1 = v3[UserId] == true
                    end
                else
                    v1 = false
                end
                local v4 = not v1
                local Key_2 = u145.Key
                local UserId_2 = v.UserId
                v3 = u191[Key_2]
                if typeof(v3) ~= "table" then
                    v2 = {}
                    u191[Key_2] = v2
                    v1 = v2
                else
                    v1 = v3
                end
                v1[UserId_2] = nil
                v2 = if not v4 then nil else true
                v1[(tostring(UserId_2))] = v2
                Selected.Visible = v4
                State.Text = if not v4 then "OFF" else "ON"
                State.TextColor3 = if not v4 then u117 else u122
                Remotes.VIP.SetSetting.Send({Key = u145.Key, Value = v1})
            end)
            u32.Parent = u231
        end
    end
end

local function renderSettings() -- Line: 860
    -- upvalues: u215 (val), clearGenerated (val), u227 (ref), u234 (ref), u235 (ref), u236 (ref), u233 (ref)
    -- upvalues: u201 (val), u207 (val), bindHover (val), u211 (val), paintButton (val), bindPress (val), Router (val)
    -- upvalues: setToggleSelector (val), u59 (val), u191 (ref), Remotes (val), refreshBotControls (val), u95 (val)
    -- upvalues: u69 (val), isBotAutoFill (val), areBotsFrozen (val), u198 (ref), u188 (val), renderPlayers (val)
    -- upvalues: u232 (ref), u230 (ref), slideIn (val), updateRootPosition (val), u137 (val)
    local BackgroundColor3, Label_2, Left_2, Name, Title, v1, v2, v3
    u215:Cleanup()
    clearGenerated(u227, u234, {InputTemplate = true, ClickTemplate = true, SectionTemplate = true})
    u235.Visible = false
    u236.Visible = false
    u233.Visible = false
    table.clear(u201)
    local u18 = 0

    local function createSection(a1, a2, a3) -- Line: 871
        -- upvalues: u18 (ref), u233 (upval), u227 (upval)
        u18 = u18 + 1
        local v1 = math.ceil(a3 / 2)
        local v2 = v1 * 0.115 + (v1 - 1) * 0.022
        local v3 = v2 + 0.07
        local v4 = u233:Clone()
        v4.Name = a1
        v4.LayoutOrder = u18
        v4.Size = UDim2.fromScale(1, v3)
        v4.Visible = true
        local Label = v4:WaitForChild("Label")
        Label.Text = a2
        Label.Size = UDim2.fromScale(1, 0.035 / v3)
        local Grid = v4:WaitForChild("Grid")
        Grid.Position = UDim2.fromScale(0, 0.07 / v3)
        Grid.Size = UDim2.fromScale(1, v2 / v3)
        local UIGridLayout = Grid:FindFirstChildOfClass("UIGridLayout")
        UIGridLayout.CellSize = UDim2.fromScale(0.492, 0.115 / v2)
        UIGridLayout.CellPadding = UDim2.fromScale(0.016, 0.022 / v2)
        v4.Parent = u227
        return Grid
    end

    local function createRow(a1, a2, a3, a4) -- Line: 898 -- types: a1: userdata, a2: userdata, a3: string, a4: string
        local v1 = a1:Clone()
        v1.Name = a3
        v1.LayoutOrder = #a2:GetChildren()
        v1.Visible = true
        local Left = v1:WaitForChild("Left")
        Left:WaitForChild("Label").Text = a4
        v1.Parent = a2
        return v1
    end

    local function createSelector(a1, a2, a3, a4, a5, a6) -- Line: 910
        -- upvalues: u234 (upval), u215 (upval), u207 (upval), bindHover (upval), u211 (upval), paintButton (upval)
        -- upvalues: bindPress (upval), Router (upval), u201 (upval)
        local v1 = u234:Clone()
        v1.Name = a2
        v1.LayoutOrder = #a1:GetChildren()
        v1.Visible = true
        local Left = v1:WaitForChild("Left")
        Left:WaitForChild("Label").Text = a3
        v1.Parent = a1
        local Switch = (v1:WaitForChild("Right")):WaitForChild("Switch")
        local Selection = Switch:WaitForChild("Selection")
        local v2 = {
            Row = v1,
            Title = Selection:WaitForChild("Title"),
            Bar = Selection:WaitForChild("Frame"),
            Decrease = Switch:WaitForChild("Left"),
            Increase = Switch:WaitForChild("Right"),
        }
        Switch.AutoButtonColor = false
        local v3 = u207
        local BackgroundColor3 = u207[Switch] or Switch.BackgroundColor3
        v3[Switch] = BackgroundColor3
        bindHover(u215, Switch, function(a1) -- Line: 289 -- upvalues: u211 (upval), Switch (val), paintButton (upval)
            u211[Switch] = if not a1 then nil else true
            paintButton(Switch)
        end)

        local function step(a1, a2) -- Line: 931
            -- upvalues: bindPress (upval), u215 (upval), Router (upval)
            bindPress(u215, a1, function() -- Line: 932 -- upvalues: a1 (val), Router (upval), a2 (val)
                if a1:GetAttribute("Enabled") ~= false then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    a2()
                end
            end)
        end

        local Decrease = v2.Decrease
        bindPress(u215, Decrease, function() -- Line: 932 -- upvalues: Decrease (val), Router (upval), a4 (val)
            if Decrease:GetAttribute("Enabled") ~= false then
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                a4()
            end
        end)
        local Increase = v2.Increase
        bindPress(u215, Increase, function() -- Line: 932 -- upvalues: Increase (val), Router (upval), a5 (val)
            if Increase:GetAttribute("Enabled") ~= false then
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                a5()
            end
        end)
        if a6 then
            local u85 = false

            local function markArrow() -- Line: 945 -- upvalues: u85 (ref)
                u85 = true
                task.defer(function() -- Line: 947 -- upvalues: u85 (upval)
                    u85 = false
                end)
            end

            u215:Add((v2.Decrease.MouseButton1Down:Connect(markArrow)))
            u215:Add((v2.Increase.MouseButton1Down:Connect(markArrow)))
            bindPress(u215, Switch, function() -- Line: 953 -- upvalues: u85 (ref), Router (upval), a6 (val)
                if not u85 then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    a6()
                end
            end)
        end
        u201[a2] = v2
        return v2
    end

    local function createToggle(a1, a2, a3, a4, a5) -- Line: 965
        -- upvalues: setToggleSelector (upval), createSelector (val)
        local u5 = nil

        local function set(a1) -- Line: 973
            -- upvalues: a4 (val), a5 (val), setToggleSelector (upval), u5 (ref)
            if a1 == a4() then
                return
            end
            a5(a1)
            setToggleSelector(u5, a1)
        end

        u5 = createSelector(a1, a2, a3, function() -- Line: 980 -- upvalues: a4 (val), a5 (val), setToggleSelector (upval), u5 (ref)
            if a4() == false then
                return
            end
            a5(false)
            setToggleSelector(u5, false)
        end, function() -- Line: 982 -- upvalues: a4 (val), a5 (val), setToggleSelector (upval), u5 (ref)
            if a4() == true then
                return
            end
            a5(true)
            setToggleSelector(u5, true)
        end, function() -- Line: 984 -- upvalues: a4 (val), a5 (val), setToggleSelector (upval), u5 (ref)
            local v1 = not a4()
            if v1 == a4() then
                return
            end
            a5(v1)
            setToggleSelector(u5, v1)
        end)
        setToggleSelector(u5, a4())
    end

    local v4 = createSection("MatchRules", "MATCH RULES", #u59 + 1)
    for i, v in ipairs(u59) do
        createToggle(v4, v.Name, v.Label, function() -- Line: 993 -- upvalues: u191 (upval), v (val)
            return u191[v.Key] == true
        end, function(a1) -- Line: 995 -- upvalues: u191 (upval), v (val), Remotes (upval)
            u191[v.Key] = a1
            Remotes.VIP.SetSetting.Send({Key = v.Key, Value = a1})
        end)
    end
    local v5 = u235:Clone()
    v5.Name = "SetTimer"
    v5.LayoutOrder = #v4:GetChildren()
    v5.Visible = true
    local Label = (v5:WaitForChild("Left")):WaitForChild("Label")
    Label.Text = "Set Timer"
    v5.Parent = v4
    local TextBox = v5:FindFirstChildWhichIsA("TextBox", true)
    TextBox.Text = ""
    u215:Add((TextBox.FocusLost:Connect(function() -- Line: 1005 -- upvalues: TextBox (val), Remotes (upval)
        local v1 = tonumber(TextBox.Text)
        if not v1 then
            TextBox.Text = ""
            return
        end
        Remotes.VIP.ExecuteAction.Send({Action = "SetTimer", Params = math.clamp(math.floor(v1), 0, 9999)})
        TextBox.Text = ""
    end)))
    local v6 = createSection("Bots", "BOTS", 5)

    local function changeBotCount(a1, a2) -- Line: 1019
        -- upvalues: u191 (upval), refreshBotControls (upval), Remotes (upval)
        local Key = a1.Key
        local v1 = u191[Key]
        local v2 = (if typeof(v1) ~= "number" then 0 else v1) + a2
        if not (v2 < 0) then
            local OtherKey = a1.OtherKey
            local v3 = u191[OtherKey]
            if not (14 < v2 + (if typeof(v3) ~= "number" then 0 else v3)) then
                u191[a1.Key] = v2
                u191.BotAutoFill = false
                refreshBotControls()
                Remotes.VIP.SetSetting.Send({Key = a1.Key, Value = v2})
                return
            end
        end
    end

    for i2, i3 in ipairs(u95) do
        createSelector(v6, i3.Name, i3.Label, function() -- Line: 1031 -- upvalues: changeBotCount (val), i3 (val)
            changeBotCount(i3, -1)
        end, function() -- Line: 1033 -- upvalues: changeBotCount (val), i3 (val)
            changeBotCount(i3, 1)
        end)
    end

    local function shiftBotDifficulty(a1) -- Line: 1038
        -- upvalues: u69 (upval), u191 (upval), refreshBotControls (upval), Remotes (upval)
        local find = table.find
        local BotDifficulty = u191.BotDifficulty
        local v1 = if not table.find(u69, BotDifficulty) then u69[1] else BotDifficulty
        local v2 = find(u69, v1)
        local v3 = u69[math.clamp(v2 + a1, 1, #u69)]
        u191.BotDifficulty = v3
        refreshBotControls()
        Remotes.VIP.SetSetting.Send({Key = "BotDifficulty", Value = v3})
    end

    createSelector(v6, "BotDifficulty", "Bot Difficulty", function() -- Line: 1045 -- upvalues: shiftBotDifficulty (val)
        shiftBotDifficulty(-1)
    end, function() -- Line: 1047 -- upvalues: shiftBotDifficulty (val)
        shiftBotDifficulty(1)
    end)
    createToggle(v6, "BotAutoFill", "Auto Fill Bots", isBotAutoFill, function(a1) -- Line: 1051 -- upvalues: u191 (upval), refreshBotControls (upval), Remotes (upval)
        u191.BotAutoFill = a1
        refreshBotControls()
        Remotes.VIP.SetSetting.Send({Key = "BotAutoFill", Value = a1})
    end)
    createToggle(v6, "BotsFrozen", "Freeze Bots", areBotsFrozen, function(a1) -- Line: 1057 -- upvalues: u191 (upval), Remotes (upval)
        u191.BotsFrozen = a1
        Remotes.VIP.SetSetting.Send({Key = "BotsFrozen", Value = a1})
    end)

    local function openPlayers(a1) -- Line: 1063
        -- upvalues: u198 (upval), u188 (upval), Remotes (upval), renderPlayers (upval), u232 (upval), u230 (upval)
        -- upvalues: slideIn (upval), updateRootPosition (upval)
        if u188[a1] then
            Remotes.VIP.RequestData.Send("State")
        end
        Remotes.VIP.RequestData.Send("PlayerList")
        renderPlayers()
        if u232 then
            local v1 = u188[a1]
            u232.Text = string.upper(if not v1 then "Kick Player" else v1.Title)
        end
        if not u230.Visible then
            u230.Visible = true
            slideIn(u230, UDim2.fromOffset(-40, 0))
        end
        updateRootPosition(true)
    end

    local v7 = {
        {
            Name = "GodMode",
            Label = "God Mode",
            Button = "PLAYERS",
            Callback = function() -- Line: 1078
                -- upvalues: u198 (upval), u188 (upval), Remotes (upval), renderPlayers (upval), u232 (upval)
                -- upvalues: u230 (upval), slideIn (upval), updateRootPosition (upval)
                u198 = "GodMode"
                if u188.GodMode then
                    Remotes.VIP.RequestData.Send("State")
                end
                Remotes.VIP.RequestData.Send("PlayerList")
                renderPlayers()
                if u232 then
                    local v1 = u188[u198]
                    u232.Text = string.upper(if not v1 then "Kick Player" else v1.Title)
                end
                if not u230.Visible then
                    u230.Visible = true
                    slideIn(u230, UDim2.fromOffset(-40, 0))
                end
                updateRootPosition(true)
            end,
        },
        {
            Name = "ESP",
            Label = "ESP",
            Button = "PLAYERS",
            Callback = function() -- Line: 1086
                -- upvalues: u198 (upval), u188 (upval), Remotes (upval), renderPlayers (upval), u232 (upval)
                -- upvalues: u230 (upval), slideIn (upval), updateRootPosition (upval)
                u198 = "ESP"
                if u188.ESP then
                    Remotes.VIP.RequestData.Send("State")
                end
                Remotes.VIP.RequestData.Send("PlayerList")
                renderPlayers()
                if u232 then
                    local v1 = u188[u198]
                    u232.Text = string.upper(if not v1 then "Kick Player" else v1.Title)
                end
                if not u230.Visible then
                    u230.Visible = true
                    slideIn(u230, UDim2.fromOffset(-40, 0))
                end
                updateRootPosition(true)
            end,
        },
        {
            Name = "KickPlayer",
            Label = "Kick Player",
            Button = "PLAYERS",
            Callback = function() -- Line: 1094
                -- upvalues: u198 (upval), u188 (upval), Remotes (upval), renderPlayers (upval), u232 (upval)
                -- upvalues: u230 (upval), slideIn (upval), updateRootPosition (upval)
                u198 = "KickPlayer"
                if u188.KickPlayer then
                    Remotes.VIP.RequestData.Send("State")
                end
                Remotes.VIP.RequestData.Send("PlayerList")
                renderPlayers()
                if u232 then
                    local v1 = u188[u198]
                    u232.Text = string.upper(if not v1 then "Kick Player" else v1.Title)
                end
                if not u230.Visible then
                    u230.Visible = true
                    slideIn(u230, UDim2.fromOffset(-40, 0))
                end
                updateRootPosition(true)
            end,
        },
        {
            Name = "ResetScore",
            Label = "Reset Score",
            Button = "RESET",
            Callback = function() -- Line: 1102 -- upvalues: Remotes (upval)
                Remotes.VIP.ExecuteAction.Send({Action = "ResetScore"})
            end,
        },
        {
            Name = "EndGame",
            Label = "End Current Game",
            Button = "END GAME",
            Danger = true,
            Callback = function() -- Line: 1111 -- upvalues: Remotes (upval)
                Remotes.VIP.ExecuteAction.Send({Action = "EndGame"})
            end,
        },
    }
    local v8 = createSection("Actions", "SERVER ACTIONS", #v7)
    for i4, j in ipairs(v7) do
        v2 = u236
        Name = j.Name
        Label_2 = j.Label
        v1 = v2:Clone()
        v1.Name = Name
        v1.LayoutOrder = #v8:GetChildren()
        v1.Visible = true
        Left_2 = v1:WaitForChild("Left")
        Left_2:WaitForChild("Label").Text = Label_2
        v1.Parent = v8
        local Action = v1:FindFirstChild("Action", true)
        Title = Action:WaitForChild("Title")
        Title.Text = j.Button
        if j.Danger then
            Action.BackgroundColor3 = u137
        end
        v3 = u207
        BackgroundColor3 = u207[Action] or Action.BackgroundColor3
        v3[Action] = BackgroundColor3
        bindHover(u215, Action, function(a1) -- Line: 289 -- upvalues: u211 (upval), Action (val), paintButton (upval)
            u211[Action] = if not a1 then nil else true
            paintButton(Action)
        end)
        bindPress(u215, Action, function() -- Line: 1128 -- upvalues: Router (upval), j (val)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            j.Callback()
        end)
    end
    refreshBotControls()
end

local function setupTabs() -- Line: 1140
    -- upvalues: u226 (ref), u213 (val), u207 (val), bindHover (val), u211 (val), paintButton (val), bindPress (val)
    -- upvalues: u197 (ref), Router (val), u195 (ref), refreshMaps (val), refreshModeCards (val)
    -- upvalues: updateToggleIndicators (val), showPanel (val)
    local BackgroundColor3
    for k, v in pairs(u226) do
        BackgroundColor3 = u207[v] or v.BackgroundColor3
        u207[v] = BackgroundColor3
        bindHover(u213, v, function(a1) -- Line: 289 -- upvalues: u211 (upval), v (val), paintButton (upval)
            u211[v] = if not a1 then nil else true
            paintButton(v)
        end)
        bindPress(u213, v, function() -- Line: 1143
            -- upvalues: u197 (upval), k (val), Router (upval), u195 (upval), refreshMaps (upval)
            -- upvalues: refreshModeCards (upval), updateToggleIndicators (upval), showPanel (upval)
            if u197 == k then
                return
            end
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            if k == "MapSelect" then
                u195 = nil
                refreshMaps()
            elseif k ~= "ModeSelect" then
                updateToggleIndicators()
            else
                refreshModeCards()
            end
            showPanel(k, true)
        end)
    end
end

local function setupCloseButtons() -- Line: 1162
    -- upvalues: u230 (ref), u213 (val), u207 (val), bindHover (val), u211 (val), paintButton (val), bindPress (val)
    -- upvalues: Router (val), updateRootPosition (val), u222 (ref), u0 (val), CloseButtonRegistry (val)
    local Close = (u230:WaitForChild("Header")):FindFirstChild("Close")
    if Close and Close:IsA("GuiButton") then
        local BackgroundColor3 = u207[Close] or Close.BackgroundColor3
        u207[Close] = BackgroundColor3
        bindHover(u213, Close, function(a1) -- Line: 289 -- upvalues: u211 (upval), Close (val), paintButton (upval)
            u211[Close] = if not a1 then nil else true
            paintButton(Close)
        end)
        bindPress(u213, Close, function() -- Line: 1166 -- upvalues: Router (upval), u230 (upval), updateRootPosition (upval)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u230.Visible = false
            updateRootPosition(true)
        end)
    end
    local Close_2 = u222:WaitForChild("Close")
    if Close_2 and Close_2:IsA("GuiButton") then
        local BackgroundColor3_2 = u207[Close_2] or Close_2.BackgroundColor3
        u207[Close_2] = BackgroundColor3_2
        bindHover(u213, Close_2, function(a1) -- Line: 289 -- upvalues: u211 (upval), Close_2 (val), paintButton (upval)
            u211[Close_2] = if not a1 then nil else true
            paintButton(Close_2)
        end)
        bindPress(u213, Close_2, function() -- Line: 1175 -- upvalues: Router (upval), u0 (upval)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u0.closeFrame()
        end)
    end
    CloseButtonRegistry.Add(u222, nil, function() -- Line: 1182 -- upvalues: u230 (upval), updateRootPosition (upval), u0 (upval)
        if not u230.Visible then
            u0.closeFrame()
            return
        end
        u230.Visible = false
        updateRootPosition(true)
    end)
end

function u0.openFrame() -- Line: 1194
    -- upvalues: u54 (val), LocalPlayer (val), u222 (ref), EndScreenController (val), MenuState (val)
    -- upvalues: isTeamSelectionVisible (val), u202 (ref), CameraController (val), u203 (ref), u230 (ref)
    -- upvalues: showPanel (val), u197 (ref), u223 (ref), u162 (val), TweenService (val), u224 (ref), u225 (ref)
    -- upvalues: Remotes (val), refreshMaps (val), refreshModeCards (val)
    local v1 = u54 or LocalPlayer:GetAttribute("CanUseVIPMenu") == true
    if v1
        and u222
        and not EndScreenController.IsActive()
        and not MenuState.IsInspectActive()
        and not MenuState.IsCaseSceneActive() then
        local Attribute = LocalPlayer:GetAttribute("Team")
        v1 = true
        if Attribute ~= "Counter-Terrorists" then
            v1 = Attribute == "Terrorists"
        end
        if not v1 then
            v1 = LocalPlayer:GetAttribute("IsSpectating") == true
        end
        if v1 then
            local Visible
            local Parent = u222 and u222.Parent
            local Parent_2 = Parent and Parent.Parent
            local Parent_3 = Parent_2 and Parent_2.Parent
            local v2 = if not Parent_3 then nil else if not Parent_3:IsA("ScreenGui") then nil else Parent_3
            if v2 then
                local Menu = v2:FindFirstChild("Menu")
                Visible = false
                if Menu ~= nil then
                    Visible = Menu:IsA("GuiObject") and Menu.Visible
                end
            else
                Visible = false
            end
            if not Visible and not isTeamSelectionVisible() and not u202 then
                CameraController.setForceLockOverride("VIPMenu", true)
                v1 = LocalPlayer:GetAttribute("IsSpectating") == true
                if not v1 then
                    local Character = LocalPlayer.Character
                    v1 = false
                    if Character ~= nil then
                        v1 = Character:IsDescendantOf(workspace)
                    end
                    if v1 then
                        CameraController.setPerspective(true, true)
                    end
                end
                if u203 then
                    u203:Cancel()
                    u203 = nil
                end
                u202 = true
                u222.Visible = true
                u230.Visible = false
                v2 = UDim2.new(0.5, if not u230.Visible then 0 else -(u230.AbsoluteSize.X + u222.AbsoluteSize.X * 0.02) / 2, 0.5, 0)
                u222.Position = v2
                showPanel(u197, true)
                u223.Scale = 0.94
                TweenService:Create(u223, u162, {Scale = 1}):Play()
                if u224 then
                    u224.BackgroundTransparency = 1
                    TweenService:Create(u224, u162, {BackgroundTransparency = u225}):Play()
                end
                Remotes.VIP.RequestData.Send("State")
                Remotes.VIP.RequestData.Send("PlayerList")
                refreshMaps()
                refreshModeCards()
                return
            end
        end
    end
end

function u0.closeFrame() -- Line: 1236
    -- upvalues: u222 (ref), CameraController (val), LocalPlayer (val), u202 (ref), u223 (ref), u167 (val)
    -- upvalues: TweenService (val), u224 (ref), u203 (ref)
    if not u222 then
        return
    end
    CameraController.setForceLockOverride("VIPMenu", false)
    local v1 = LocalPlayer:GetAttribute("IsSpectating") == true
    if not v1 then
        local Character = LocalPlayer.Character
        v1 = false
        if Character ~= nil then
            v1 = Character:IsDescendantOf(workspace)
        end
        if v1 then
            CameraController.setPerspective(true, false)
        end
    end
    if not u202 then
        return
    end
    u202 = false
    local u40 = TweenService:Create(u223, u167, {Scale = 0.94})
    u40:Play()
    if u224 then
        TweenService:Create(u224, u167, {BackgroundTransparency = 1}):Play()
    end
    u203 = u40
    u40.Completed:Connect(function(a1) -- Line: 1256 -- upvalues: u203 (upval), u40 (val), u222 (upval)
        if a1 == Enum.PlaybackState.Completed and u203 == u40 then
            u203 = nil
            u222.Visible = false
        end
    end)
end

function u0.toggleFrame() -- Line: 1264 -- upvalues: u222 (ref), u202 (ref), u0 (val)
    if not u222 then
        return
    end
    if u202 then
        u0.closeFrame()
        return
    end
    u0.openFrame()
end

function u0.Initialize(a1, a2) -- Line: 1279
    -- upvalues: u222 (ref), u223 (ref), u224 (ref), u225 (ref), u226 (ref), u227 (ref), u228 (ref), u229 (ref)
    -- upvalues: u230 (ref), u231 (ref), u232 (ref), u233 (ref), u234 (ref), u235 (ref), u236 (ref), u237 (ref)
    -- upvalues: u238 (ref), u239 (ref), loadAvailableMaps (val), u197 (ref), u127 (val), u132 (val), u207 (val)
    -- upvalues: paintButton (val), renderSettings (val), buildModeCards (val), buildMapEntries (val), u213 (val)
    -- upvalues: u202 (ref), CameraController (val), u191 (ref), updateToggleIndicators (val), refreshMaps (val)
    -- upvalues: refreshModeCards (val), renderPlayers (val), Remotes (val), u192 (ref)
    local Selected, v1, v2
    u222 = a2
    local UIScale = a2:FindFirstChildOfClass("UIScale")
    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = a2
    end
    u223 = UIScale
    u224 = a2:FindFirstChild("Backdrop")
    if u224 then
        u225 = u224.BackgroundTransparency
    end
    local Frame = a2:WaitForChild("Frame")
    u226 = {
        Settings = Frame:WaitForChild("Settings"),
        MapSelect = Frame:WaitForChild("MapSelect"),
        ModeSelect = Frame:WaitForChild("ModeSelect"),
    }
    u227 = a2:WaitForChild("ScrollingFrame")
    u228 = a2:WaitForChild("SelectMap")
    u229 = a2:WaitForChild("SelectMode")
    u230 = a2:WaitForChild("VoteKick")
    u231 = u230:WaitForChild("Container")
    u232 = (u230:WaitForChild("Header")):WaitForChild("Title")
    u233 = u227:WaitForChild("SectionTemplate")
    u234 = u227:WaitForChild("ToggleTemplate")
    u235 = u227:WaitForChild("InputTemplate")
    u236 = u227:WaitForChild("ClickTemplate")
    u237 = u228:WaitForChild("Template")
    u238 = u229:WaitForChild("Template")
    u239 = u231:WaitForChild("Template")
    loadAvailableMaps()
    u222.Visible = false
    u230.Visible = false
    u197 = "Settings"
    u227.Visible = true
    u228.Visible = false
    u229.Visible = false
    for k, v in pairs(u226) do
        v2 = if not (k == "Settings") then u132 else u127
        u207[v] = v2
        paintButton(v)
        Selected = v:FindFirstChild("Selected")
        if Selected and Selected:IsA("GuiObject") then
            Selected.Visible = v1
        end
    end
    renderSettings()
    buildModeCards()
    buildMapEntries()
    u213:Add(((u222:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 1315 -- upvalues: u222 (upval), u202 (upval), CameraController (upval)
        if u222.Visible then
            return
        end
        u202 = false
        CameraController.setForceLockOverride("VIPMenu", false)
    end)))
    u213:Add((Remotes.VIP.SyncState.Listen(function(a1) -- Line: 1326
        -- upvalues: u191 (upval), u222 (upval), updateToggleIndicators (upval), refreshMaps (upval)
        -- upvalues: refreshModeCards (upval), u230 (upval), renderPlayers (upval)
        u191 = a1
        if not u222.Visible then
            return
        end
        updateToggleIndicators()
        refreshMaps()
        refreshModeCards()
        if u230.Visible then
            renderPlayers()
        end
    end)))
    u213:Add((Remotes.VIP.DataResponse.Listen(function(a1) -- Line: 1341
        -- upvalues: u191 (upval), u222 (upval), updateToggleIndicators (upval), refreshMaps (upval)
        -- upvalues: refreshModeCards (upval), u230 (upval), renderPlayers (upval), u192 (upval)
        if a1.Type ~= "State" then
            if a1.Type == "PlayerList" then
                u192 = a1.Data
                if u222.Visible and u230.Visible then
                    renderPlayers()
                end
            end
            return
        end
        u191 = a1.Data
        if not u222.Visible then
            return
        end
        updateToggleIndicators()
        refreshMaps()
        refreshModeCards()
        if not u230.Visible then
            return
        end
        renderPlayers()
    end)))
end

function u0.Start() -- Line: 1353 -- upvalues: setupTabs (val), setupCloseButtons (val), updateToggleIndicators (val)
    setupTabs()
    setupCloseButtons()
    updateToggleIndicators()
end

return u0