-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard
-- Decompile time: 22.32 ms

local restoreTransparencyRecursive, setDeadTransparencyRecursive, storeTransparencyRecursive
local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local GetBadgeIcon = require(ReplicatedStorage.Components.Common.GetBadgeIcon)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat)
local ProfileInspect = require(script:WaitForChild("ProfileInspect"))
local u91 = {"Ping", "Money", "Kills", "Deaths", "Assists", "MVPs", "Score"}
local v1 = {
    IsDeathmatch = false,
    CounterTerroristsPosition = UDim2.fromScale(0.582, 0.782),
    TerroristsPosition = UDim2.fromScale(0.582, 0.355),
    Size = UDim2.fromScale(0.762, 0.365),
    Headers = {
        Ping = UDim2.fromScale(0.26958, 0.53351),
        Money = UDim2.fromScale(0.63825, 0.66217),
        Kills = UDim2.fromScale(0.70308, 0.66217),
        Deaths = UDim2.fromScale(0.75921, 0.66217),
        Assists = UDim2.fromScale(0.82029, 0.66217),
        MVPs = UDim2.fromScale(0.88294, 0.66217),
        Score = UDim2.fromScale(0.93732, 0.66217),
    },
}
local u141 = {}
u141.Deathmatch = {
    IsDeathmatch = true,
    CounterTerroristsPosition = UDim2.fromScale(0.503, 0.785),
    TerroristsPosition = UDim2.fromScale(0.503, 0.364),
    Size = UDim2.fromScale(0.921, 0.365),
    Headers = {
        Ping = UDim2.fromScale(0.12539, 0.53351),
        Money = UDim2.fromScale(0.57099, 0.66217),
        Kills = UDim2.fromScale(0.64935, 0.66217),
        Deaths = UDim2.fromScale(0.71718, 0.66217),
        Assists = UDim2.fromScale(0.79102, 0.66217),
        MVPs = UDim2.fromScale(0.86673, 0.66217),
        Score = UDim2.fromScale(0.93246, 0.66217),
    },
}
u141["Bomb Defusal"] = v1
u141["Hostage Rescue"] = v1
local u188 = Color3.new(1, 1, 1)
local u193 = Color3.fromRGB(139, 128, 98)
local u198 = Color3.fromRGB(165, 183, 212)
local u203 = Color3.fromRGB(219, 199, 126)
local u208 = Color3.fromRGB(81, 81, 81)
local u213 = Color3.fromRGB(95, 95, 95)
local u218 = Color3.fromRGB(255, 255, 255)
local u219 = {"Team1", "Team2"}
local u222 = {
    BombDefuse = "rbxassetid://138772806705472",
    BombExplode = "rbxassetid://97682949239067",
    BombObjective = "rbxassetid://97682949239067",
    Elimination = "rbxassetid://70876442749327",
    TimeExpiration = "rbxassetid://96043369049959",
    HostageRescue = "rbxassetid://138772806705472",
}
local u223 = nil
local u224 = nil
local u225 = nil
local u226 = nil
local u227 = false
local u228 = {}
local u229 = {}

local function commaNumber(a1) -- Line: 129 -- types: a1: number
    return tostring(a1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function clearFrame(a1) -- Line: 133 -- types: a1: userdata
    for i, v in ipairs(a1:GetChildren()) do
        if v.ClassName == "Frame" then
            v:Destroy()
        end
    end
end

local function getPlayersOnTeam(a1) -- Line: 141 -- upvalues: Participants (val)
    local v1 = {}
    for i, v in ipairs((Participants.GetAll())) do
        if v:GetAttribute("Team") == a1 then
            table.insert(v1, v)
        end
    end
    return v1
end

local function lightenTowardWhite(a1) -- Line: 153 -- upvalues: u188 (val) -- types: a1: UDim2
    return a1:Lerp(u188, 0.2)
end

local function getMousePositionInLeaderboard() -- Line: 157
    -- upvalues: UserInputService (val), GuiService (val), u223 (ref)
    local MouseLocation = UserInputService:GetMouseLocation()
    local GuiInset = GuiService:GetGuiInset()
    local v1 = MouseLocation.X - GuiInset.X
    local v2 = MouseLocation.Y - GuiInset.Y
    local AbsolutePosition = u223.AbsolutePosition
    local AbsoluteSize = u223.AbsoluteSize
    return UDim2.fromScale((v1 - AbsolutePosition.X) / AbsoluteSize.X, (v2 - AbsolutePosition.Y) / AbsoluteSize.Y)
end

local function resetProfileInspect() -- Line: 170 -- upvalues: u224 (ref), u225 (ref), ProfileInspect (val)
    if not u224 then
        return
    end
    u224.Visible = false
    if u225 then
        u224.Position = u225
    end
    ProfileInspect.Reset()
end

local function openProfileInspect(a1) -- Line: 182
    -- upvalues: u224 (ref), getMousePositionInLeaderboard (val), ProfileInspect (val)
    if not u224 then
        return
    end
    u224.Position = getMousePositionInLeaderboard()
    ProfileInspect.Populate(a1)
    u224.Visible = true
end

local function bindPlayerRowInteractions(a1, a2, a3) -- Line: 192
    -- upvalues: u188 (val), u224 (ref), getMousePositionInLeaderboard (val), ProfileInspect (val)
    local BackgroundColor3 = a1.BackgroundColor3
    local u4 = false

    local function applyBackgroundColor() -- Line: 200
        -- upvalues: a1 (val), u4 (ref), BackgroundColor3 (val), u188 (upval)
        a1.BackgroundColor3 = if not u4 then BackgroundColor3 else BackgroundColor3:Lerp(u188, 0.2)
    end

    a1.Active = true
    a3:Add((a1.MouseEnter:Connect(function() -- Line: 207 -- upvalues: u4 (ref), a1 (val), BackgroundColor3 (val), u188 (upval)
        u4 = true
        a1.BackgroundColor3 = if not u4 then BackgroundColor3 else BackgroundColor3:Lerp(u188, 0.2)
    end)))
    a3:Add((a1.MouseLeave:Connect(function() -- Line: 211 -- upvalues: u4 (ref), a1 (val), BackgroundColor3 (val), u188 (upval)
        u4 = false
        a1.BackgroundColor3 = if not u4 then BackgroundColor3 else BackgroundColor3:Lerp(u188, 0.2)
    end)))
    a3:Add((a1.InputBegan:Connect(function(a1) -- Line: 215
        -- upvalues: a2 (val), u224 (upval), getMousePositionInLeaderboard (upval), ProfileInspect (upval)
        if a1.UserInputType == Enum.UserInputType.MouseButton1 then
            if not u224 then
                return
            end
            u224.Position = getMousePositionInLeaderboard()
            ProfileInspect.Populate(a2)
            u224.Visible = true
        end
    end)))
end

local function getCharactersAlive(a1) -- Line: 222
    -- upvalues: RemoveFromArray (val), Participants (val)
    return RemoveFromArray(a1, function(a1, a2) -- Line: 223 -- upvalues: Participants (upval)
        return not Participants.IsAlive(a2)
    end)
end

local function updateAliveCounts() -- Line: 228
    -- upvalues: u223 (ref), getPlayersOnTeam (val), RemoveFromArray (val), Participants (val)
    if not u223 then
        return
    end
    local Attribute = workspace:GetAttribute("Gamemode")
    if Attribute ~= "Bomb Defusal" and Attribute ~= "Hostage Rescue" then
        return
    end
    local v1 = getPlayersOnTeam("Counter-Terrorists")
    local Terrorists = getPlayersOnTeam("Terrorists")
    local v2 = #v1
    local v3 = #Terrorists
    local v4 = RemoveFromArray(v1, function(a1, a2) -- Line: 223 -- upvalues: Participants (upval)
        return not Participants.IsAlive(a2)
    end)
    local v5 = RemoveFromArray(Terrorists, function(a1, a2) -- Line: 223 -- upvalues: Participants (upval)
        return not Participants.IsAlive(a2)
    end)
    u223.Team.CT.Alive.Text = ("ALIVE %*/%*"):format(tostring(#v4), (tostring(v2)))
    u223.Team.T.Alive.Text = ("ALIVE %*/%*"):format(tostring(#v5), (tostring(v3)))
end

local function observeAliveCountPlayer(a1) -- Line: 251
    -- upvalues: u229 (val), Janitor (val), updateAliveCounts (val)
    local v1 = u229[a1]
    if v1 then
        v1:Destroy()
    end
    local v2 = Janitor.new()
    u229[a1] = v2
    v2:Add(((a1:GetAttributeChangedSignal("Team")):Connect(updateAliveCounts)))
    v2:Add(((a1:GetAttributeChangedSignal("IsSpectating")):Connect(updateAliveCounts)))
    v2:Add(((a1:GetAttributeChangedSignal("Dead")):Connect(updateAliveCounts)))
    v2:Add(((a1:GetAttributeChangedSignal("Health")):Connect(updateAliveCounts)))
    updateAliveCounts()
end

local function updateGamemode() -- Line: 267 -- upvalues: u223 (ref), u141 (val), u91 (val)
    local Attribute = workspace:GetAttribute("Gamemode")
    u223.Team.CT.Score.Visible = Attribute ~= "Deathmatch"
    u223.Team.T.Score.Visible = Attribute ~= "Deathmatch"
    local v1 = ("%* | %*"):format(Attribute, (workspace:GetAttribute("Map")))
    u223.TopInfo.Gamemode.Text = v1
    u223.Top.TopInfo.Gamemode.Text = v1
    local v2 = u141[Attribute]
    if not v2 then
        return
    end
    u223["Counter-Terrorists"].Position = v2.CounterTerroristsPosition
    u223.Terrorists.Position = v2.TerroristsPosition
    local Text = u223.Text
    for i, v in ipairs(u91) do
        Text[v].Position = v2.Headers[v]
    end
    u223["Counter-Terrorists"].Size = v2.Size
    u223.Terrorists.Size = v2.Size
    u223.DeathmatchDivider.Visible = v2.IsDeathmatch
    u223.Team.Visible = not v2.IsDeathmatch
end

local function isCompetitiveRoundsMode() -- Line: 293
    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        return false
    end
    local Attribute = workspace:GetAttribute("Gamemode")
    local v1 = true
    if Attribute ~= "Bomb Defusal" then
        v1 = Attribute == "Hostage Rescue"
    end
    return v1
end

local function getRoundFrame(a1) -- Line: 301 -- upvalues: u223 (ref) -- types: a1: number
    if not u223 then
        return nil
    end
    local v1 = u223:FindFirstChild(if not (a1 <= 12) then "Results2" else "Results1")
    return v1 and v1:FindFirstChild((tostring(a1))) or nil
end

local function isPostHalftime() -- Line: 309
    local Attribute = workspace:GetAttribute("HalftimeRound")
    local Attribute_2 = workspace:GetAttribute("CurrentRound")
    local v1 = false
    if Attribute ~= nil then
        v1 = false
        if Attribute_2 ~= nil then
            v1 = Attribute < Attribute_2
        end
    end
    return v1
end

local function teamColor(a1) -- Line: 315 -- upvalues: u198 (val), u203 (val) -- types: a1: string
    if a1 == "Counter-Terrorists" then
        return u198
    end
    return u203
end

local function getTeamSlotName(a1, a2) -- Line: 320 -- types: a1: number, a2: string
    local v1 = a2 == "Terrorists"
    local v2 = false
    if a1 <= 12 then
        local Attribute = workspace:GetAttribute("HalftimeRound")
        local Attribute_2 = workspace:GetAttribute("CurrentRound")
        v2 = false
        if Attribute ~= nil then
            v2 = false
            if Attribute_2 ~= nil then
                v2 = Attribute < Attribute_2
            end
        end
    end
    if if not v2 then v1 else not v1 then
        return "Team1"
    end
    return "Team2"
end

local function decodeRoundResults() -- Line: 327 -- upvalues: HttpService (val)
    local Attribute = workspace:GetAttribute("RoundResults")
    if typeof(Attribute) == "string" and Attribute ~= "" then
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
        if success and typeof(result) == "table" then
            return result
        end
        return {}
    end
    return {}
end

local function applyLossBonusVisibility() -- Line: 339 -- upvalues: u223 (ref)
    local v1, v2
    if not u223 then
        return
    end
    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local Attribute = workspace:GetAttribute("Gamemode")
        v1 = true
        if Attribute ~= "Bomb Defusal" then
            v1 = Attribute == "Hostage Rescue"
        end
    else
        v1 = false
    end
    for i, v in ipairs({"LossBonus", "Results1", "Results2", "Spilter"}) do
        v2 = u223:FindFirstChild(v)
        if v2 then
            v2.Visible = v1
        end
    end
end

local function paintLossBar(a1, a2, a3) -- Line: 352
    -- upvalues: u208 (val)
    local v1
    if not a1 then
        return
    end
    local v2 = math.clamp(a2, 0, 4)
    local v3, v4 = a1, a3
    for i = 1, 4 do
        v1 = v3:FindFirstChild((tostring(i)))
        if v1 then
            v1.BackgroundColor3 = i <= v2 and v4 or u208
        end
    end
end

local function applyLossBars() -- Line: 363 -- upvalues: u223 (ref), paintLossBar (val), u203 (val), u198 (val)
    if not u223 then
        return
    end
    local LossBonus = u223:FindFirstChild("LossBonus")
    if not LossBonus then
        return
    end
    paintLossBar(LossBonus:FindFirstChild("Bar1"), workspace:GetAttribute("TLossStreak") or 0, u203)
    paintLossBar(LossBonus:FindFirstChild("Bar2"), workspace:GetAttribute("CTLossStreak") or 0, u198)
end

local function resetRoundFrame(a1) -- Line: 375 -- upvalues: u213 (val), u219 (val) -- types: a1: userdata
    local Icon, v1
    a1.BackgroundColor3 = u213
    for i, v in ipairs(u219) do
        v1 = a1:FindFirstChild(v)
        if v1 then
            v1.Visible = false
            v1.BackgroundTransparency = 0
            Icon = v1:FindFirstChild("Icon")
            if Icon then
                Icon.Image = ""
                Icon.ImageTransparency = 0
            end
        end
    end
end

local function paintRoundResult(a1, a2, a3, a4) -- Line: 391
    -- upvalues: u198 (val), u203 (val), u222 (val)
    local v1
    a1.BackgroundColor3 = if a2 ~= "Counter-Terrorists" then u203 else u198
    local v2 = a2 == "Terrorists"
    local v3 = false
    if a4 <= 12 then
        local Attribute = workspace:GetAttribute("HalftimeRound")
        local Attribute_2 = workspace:GetAttribute("CurrentRound")
        v3 = false
        if Attribute ~= nil then
            v3 = false
            if Attribute_2 ~= nil then
                v3 = Attribute < Attribute_2
            end
        end
    end
    v2 = a1:FindFirstChild(if not (if not v3 then v2 else not v2) then "Team2" else "Team1")
    local v4 = a1:FindFirstChild(if v1 ~= "Team1" then "Team1" else "Team2")
    if v2 then
        v2.Visible = true
        v2.BackgroundTransparency = 0
        v2.BackgroundColor3 = if a2 ~= "Counter-Terrorists" then u203 else u198
        local Icon = v2:FindFirstChild("Icon")
        if Icon then
            Icon.Image = u222[a3] or "rbxassetid://70876442749327"
            Icon.ImageColor3 = if a2 ~= "Counter-Terrorists" then u203 else u198
            Icon.ImageTransparency = 0
        end
    end
    if v4 then
        v4.Visible = false
    end
end

local function hasRoundResult(a1, a2) -- Line: 418 -- types: a1: table, a2: number
    for i, v in ipairs(a1) do
        if v.round == a2 then
            return true
        end
    end
    return false
end

local function applyTrophy(a1, a2) -- Line: 427 -- upvalues: u223 (ref), u188 (val) -- types: a1: string?, a2: table
    if not u223 then
        return
    end
    local Attribute = workspace:GetAttribute("RoundsToWin")
    if not Attribute then
        return
    end
    if a1 ~= "Counter-Terrorists" and a1 ~= "Terrorists" then
        return
    end
    local v1 = workspace:GetAttribute("CTScore") or 0
    local v2 = workspace:GetAttribute("TScore") or 0
    local v3 = not (a1 ~= "Counter-Terrorists") and v1 or v2
    local v4 = v1 + v2 + (Attribute - v3)
    if not (v4 < 1) and not (v4 > 24) then
        local Attribute_2, Attribute_3, Icon, v5, v6, v7
        if u223 then
            local v8 = u223:FindFirstChild(if not (v4 <= 12) then "Results2" else "Results1")
            v7 = v8 and v8:FindFirstChild((tostring(v4))) or nil
        else
            v7 = nil
        end
        if not v7 then
            return
        end
        for i, v in ipairs(a2) do
            if v.round == v4 then
                if true then
                    return
                end
                v5 = a1 == "Terrorists"
                v6 = false
                if v4 <= 12 then
                    Attribute_2 = workspace:GetAttribute("HalftimeRound")
                    Attribute_3 = workspace:GetAttribute("CurrentRound")
                    v6 = false
                    if Attribute_2 ~= nil then
                        v6 = false
                        if Attribute_3 ~= nil then
                            v6 = Attribute_2 < Attribute_3
                        end
                    end
                end
                v5 = v7:FindFirstChild(if not (if not v6 then v5 else not v5) then "Team2" else "Team1")
                if not v5 then
                    return
                end
                v5.Visible = true
                v5.BackgroundTransparency = 1
                Icon = v5:FindFirstChild("Icon")
                if Icon then
                    Icon.Image = "rbxassetid://4857633530"
                    Icon.ImageColor3 = u188
                    Icon.ImageTransparency = 0
                end
                return
            end
        end
        if false then
            return
        end
        v5 = a1 == "Terrorists"
        v6 = false
        if v4 <= 12 then
            Attribute_2 = workspace:GetAttribute("HalftimeRound")
            Attribute_3 = workspace:GetAttribute("CurrentRound")
            v6 = false
            if Attribute_2 ~= nil then
                v6 = false
                if Attribute_3 ~= nil then
                    v6 = Attribute_2 < Attribute_3
                end
            end
        end
        v5 = v7:FindFirstChild(if not (if not v6 then v5 else not v5) then "Team2" else "Team1")
        if not v5 then
            return
        end
        v5.Visible = true
        v5.BackgroundTransparency = 1
        Icon = v5:FindFirstChild("Icon")
        if Icon then
            Icon.Image = "rbxassetid://4857633530"
            Icon.ImageColor3 = u188
            Icon.ImageTransparency = 0
        end
        return
    end
end

local function refreshResults() -- Line: 469
    -- upvalues: u223 (ref), resetRoundFrame (val), decodeRoundResults (val), paintRoundResult (val), u218 (val)
    -- upvalues: applyTrophy (val), LocalPlayer (val)
    local round, v1, v2, v3, v4, v5
    if not u223 then
        return
    end
    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local Attribute = workspace:GetAttribute("Gamemode")
        v1 = true
        if Attribute ~= "Bomb Defusal" then
            v1 = Attribute == "Hostage Rescue"
        end
    else
        v1 = false
    end
    if not v1 then
        return
    end
    for i = 1, 24 do
        if u223 then
            v3 = u223:FindFirstChild(if i > 12 then "Results2" else "Results1")
            v2 = v3 and v3:FindFirstChild((tostring(i))) or nil
        else
            v2 = nil
        end
        if v2 then
            resetRoundFrame(v2)
        end
    end
    v1 = decodeRoundResults()
    for i2, v in ipairs(v1) do
        round = v.round
        if u223 then
            v5 = u223:FindFirstChild(if not (round <= 12) then "Results2" else "Results1")
            v4 = v5 and v5:FindFirstChild((tostring(round))) or nil
        else
            v4 = nil
        end
        if v4 then
            paintRoundResult(v4, v.winner, v.winType, v.round)
        end
    end
    local Attribute_2 = workspace:GetAttribute("CurrentRound")
    if Attribute_2 and Attribute_2 >= 1 and Attribute_2 <= 24 then
        local v6
        for i3, j in ipairs(v1) do
            if j.round == Attribute_2 then
                v6 = true
                if not v6 then
                    if u223 then
                        v2 = u223:FindFirstChild(if not (Attribute_2 <= 12) then "Results2" else "Results1")
                        v6 = v2 and v2:FindFirstChild((tostring(Attribute_2))) or nil
                    else
                        v6 = nil
                    end
                    if v6 then
                        v6.BackgroundColor3 = u218
                    end
                end
                applyTrophy(LocalPlayer:GetAttribute("Team"), v1)
                return
            end
        end
        v6 = false
        if not v6 then
            if u223 then
                v2 = u223:FindFirstChild(if not (Attribute_2 <= 12) then "Results2" else "Results1")
                v6 = v2 and v2:FindFirstChild((tostring(Attribute_2))) or nil
            else
                v6 = nil
            end
            if v6 then
                v6.BackgroundColor3 = u218
            end
        end
    end
    applyTrophy(LocalPlayer:GetAttribute("Team"), v1)
end

local function isTextObject(a1) -- Line: 512 -- types: a1: userdata
    return a1:IsA("TextLabel") or a1:IsA("TextButton")
end

local function isImageObject(a1) -- Line: 516 -- types: a1: userdata
    return a1:IsA("ImageLabel") or a1:IsA("ImageButton")
end

function storeTransparencyRecursive(a1, a2) -- Line: 521
    -- upvalues: storeTransparencyRecursive (val)
    if not a1:IsA("Frame") then
        local v1 = a1:IsA("TextLabel") or a1:IsA("TextButton")
        if not v1 then
            v1 = a1:IsA("ImageLabel") or a1:IsA("ImageButton")
            if v1 then
                a2[a1] = {
                    BackgroundTransparency = a1.BackgroundTransparency,
                    ImageTransparency = a1.ImageTransparency,
                }
            end
        else
            a2[a1] = {
                BackgroundTransparency = a1.BackgroundTransparency,
                TextTransparency = a1.TextTransparency,
            }
        end
    else
        a2[a1] = {BackgroundTransparency = a1.BackgroundTransparency}
    end
    for i, j in a1:GetChildren() do
        storeTransparencyRecursive(j, a2)
    end
end

function setDeadTransparencyRecursive(a1) -- Line: 544
    -- upvalues: setDeadTransparencyRecursive (val)
    if not a1:IsA("Frame") then
        local v1 = a1:IsA("TextLabel") or a1:IsA("TextButton")
        if not v1 then
            v1 = a1:IsA("ImageLabel") or a1:IsA("ImageButton")
            if v1 then
                a1.ImageTransparency = 0.5
                a1.BackgroundTransparency = 1
            end
        else
            a1.TextTransparency = 0.5
            a1.BackgroundTransparency = 1
        end
    else
        a1.BackgroundTransparency = 1
    end
    for i, v in ipairs(a1:GetChildren()) do
        setDeadTransparencyRecursive(v)
    end
end

function restoreTransparencyRecursive(a1, a2) -- Line: 560
    -- upvalues: restoreTransparencyRecursive (val)
    local v1 = a2[a1]
    if v1 then
        if not a1:IsA("Frame") then
            local v2 = a1:IsA("TextLabel") or a1:IsA("TextButton")
            if not v2 then
                v2 = a1:IsA("ImageLabel") or a1:IsA("ImageButton")
                if v2 then
                    a1.ImageTransparency = v1.ImageTransparency
                    a1.BackgroundTransparency = v1.BackgroundTransparency
                end
            else
                a1.TextTransparency = v1.TextTransparency
                a1.BackgroundTransparency = v1.BackgroundTransparency
            end
        else
            a1.BackgroundTransparency = v1.BackgroundTransparency
        end
    end
    for i, v in ipairs(a1:GetChildren()) do
        restoreTransparencyRecursive(v, a2)
    end
end

local function releaseParticipant(a1) -- Line: 581
    -- upvalues: u229 (val), u0 (val), updateAliveCounts (val)
    local v1 = u229[a1]
    u229[a1] = nil
    if v1 then
        v1:Destroy()
    end
    u0.cleanup(a1)
    updateAliveCounts()
end

function u0.createTemplate(a1, a2, a3) -- Line: 594
    -- upvalues: ReplicatedStorage (val), Participants (val), GetBadgeIcon (val), storeTransparencyRecursive (val)
    -- upvalues: LocalPlayer (val), u193 (val), bindPlayerRowInteractions (val), Observers (val)
    -- upvalues: setDeadTransparencyRecursive (val), restoreTransparencyRecursive (val), DataController (val)
    -- upvalues: HttpService (val)
    local u10 = ReplicatedStorage.Assets.UI.Leaderboard[a2]:Clone()
    u10.Player.Image = Participants.HeadshotImage(a1)
    u10.PlayerName.Text = ("%* (@%*)"):format(Participants.DisplayName(a1), (Participants.Name(a1)))
    local v1 = GetBadgeIcon(a1, a2)
    u10.Badge.Visible = v1 ~= ""
    u10.Badge.Image = v1
    u10.Assists.Amount.Text = "0"
    u10.Deaths.Amount.Text = "0"
    u10.Score.Amount.Text = "0"
    u10.Kills.Amount.Text = "0"
    u10.MVPs.Amount.Text = "0"
    u10.Money.Amount.Text = ""
    u10.LayoutOrder = 1
    u10.Ping.Text = "0"
    local u62 = {}
    u62[u10] = {BackgroundTransparency = u10.BackgroundTransparency}
    for i, j in u10:GetChildren() do
        storeTransparencyRecursive(j, u62)
    end
    if a1 == LocalPlayer then
        u10.BackgroundColor3 = u193
    end
    bindPlayerRowInteractions(u10, a1, a3)

    local function isTeammate() -- Line: 635 -- upvalues: a1 (val), LocalPlayer (upval)
        local Attribute = a1:GetAttribute("Team")
        return LocalPlayer:GetAttribute("Team") == Attribute
    end

    local function updateMoneyVisibility() -- Line: 642 -- upvalues: a1 (val), LocalPlayer (upval), u10 (val)
        local Attribute = workspace:GetAttribute("Gamemode")
        local Attribute_2 = a1:GetAttribute("Team")
        if not (LocalPlayer:GetAttribute("Team") == Attribute_2) and Attribute ~= "Deathmatch" then
            u10.Money.Amount.Text = ""
            return
        end
        local Attribute_3 = a1:GetAttribute("Money")
        local Amount = u10.Money.Amount
        local v1 = Attribute_3 ~= nil and ("$%*"):format((tostring(Attribute_3):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))) or ""
        Amount.Text = v1
    end

    a3:Add((Observers.observeAttribute(a1, "Money", updateMoneyVisibility)))
    updateMoneyVisibility()
    local UIStroke = u10.Player:FindFirstChildOfClass("UIStroke")

    local function updateTeamColors() -- Line: 656 -- upvalues: UIStroke (val), a1 (val), LocalPlayer (upval)
        if not UIStroke then
            return
        end
        local Attribute = a1:GetAttribute("Team")
        if not (LocalPlayer:GetAttribute("Team") == Attribute) then
            UIStroke.Enabled = false
            return
        end
        local Attribute_2 = a1:GetAttribute("CompetitivePlayerColor")
        if not Attribute_2 then
            UIStroke.Enabled = false
            return
        end
        UIStroke.Color = Attribute_2
        UIStroke.Enabled = true
    end

    if UIStroke then
        local Attribute = a1:GetAttribute("Team")
        if not (LocalPlayer:GetAttribute("Team") == Attribute) then
            UIStroke.Enabled = false
        else
            local Attribute_2 = a1:GetAttribute("CompetitivePlayerColor")
            if Attribute_2 then
                UIStroke.Color = Attribute_2
                UIStroke.Enabled = true
            else
                UIStroke.Enabled = false
            end
        end
    end

    local function updateTeamDependentState() -- Line: 679
        -- upvalues: updateMoneyVisibility (val), UIStroke (val), a1 (val), LocalPlayer (upval)
        updateMoneyVisibility()
        if not UIStroke then
            return
        end
        local Attribute = a1:GetAttribute("Team")
        if not (LocalPlayer:GetAttribute("Team") == Attribute) then
            UIStroke.Enabled = false
            return
        end
        local Attribute_2 = a1:GetAttribute("CompetitivePlayerColor")
        if not Attribute_2 then
            UIStroke.Enabled = false
            return
        end
        UIStroke.Color = Attribute_2
        UIStroke.Enabled = true
    end

    a3:Add((Observers.observeAttribute(LocalPlayer, "Team", updateTeamDependentState)))
    a3:Add((Observers.observeAttribute(a1, "Team", updateTeamDependentState)))
    a3:Add((Observers.observeAttribute(a1, "CompetitivePlayerColor", updateTeamColors)))
    a3:Add((Observers.observeAttribute(a1, "Kills", function(a1) -- Line: 689 -- upvalues: u10 (val)
        u10.Kills.Amount.Text = tostring(a1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        u10.LayoutOrder = -a1
    end)))
    for i2, v in ipairs({"Deaths", "Assists", "Score", "MVPs"}) do
        a3:Add((Observers.observeAttribute(a1, v, function(a1) -- Line: 696 -- upvalues: u10 (val), v (val)
            u10[v].Amount.Text = tostring(a1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end)))
    end
    a3:Add((Observers.observeAttribute(a1, "Ping", function(a1) -- Line: 702 -- upvalues: u10 (val)
        u10.Ping.Text = a1
    end)))

    local function updateDeadSymbol() -- Line: 707
        -- upvalues: a1 (val), Participants (upval), u10 (val), setDeadTransparencyRecursive (upval), u62 (val)
        -- upvalues: restoreTransparencyRecursive (upval)
        local v1 = a1:GetAttribute("IsSpectating") == true
        local v2 = not Participants.IsAlive(a1) or v1
        if u10:FindFirstChild("Dead") then
            u10.Dead.Visible = v2
        end
        if not v2 then
            local v3 = u62[u10]
            if v3 then
                u10.BackgroundTransparency = v3.BackgroundTransparency
            end
            for i, v in ipairs(u10:GetChildren()) do
                restoreTransparencyRecursive(v, u62)
            end
            return
        end
        if u10:FindFirstChild("Bomb") then
            u10.Bomb.Visible = false
        end
        if u10:FindFirstChild("DefuseKit") then
            u10.DefuseKit.Visible = false
        end
        u10.BackgroundTransparency = 1
        for i2, i3 in ipairs(u10:GetChildren()) do
            setDeadTransparencyRecursive(i3)
        end
    end

    local u207 = nil
    a3:Add((Observers.observeAttribute(a1, "IsSpectating", updateDeadSymbol)))

    local function updateLifeState() -- Line: 743 -- upvalues: updateDeadSymbol (val), u207 (ref)
        updateDeadSymbol()
        if u207 then
            u207()
        end
    end

    a3:Add(((a1:GetAttributeChangedSignal("Dead")):Connect(updateLifeState)))
    a3:Add(((a1:GetAttributeChangedSignal("Health")):Connect(updateLifeState)))
    a3:Add(((a1:GetAttributeChangedSignal("CompetitivePlayerColor")):Connect(updateTeamColors)))
    updateDeadSymbol()
    if not Participants.IsBot(a1) then
        local u268 = DataController.CreateListener(a1, ("Loadout.%*.Equipped.Equipped Badge"):format(a2), function() -- Line: 756 -- upvalues: GetBadgeIcon (upval), a1 (val), a2 (val), u10 (val)
            local v1 = GetBadgeIcon(a1, a2)
            u10.Badge.Image = v1
            u10.Badge.Visible = v1 ~= ""
        end)
        a3:Add(function() -- Line: 763 -- upvalues: DataController (upval), a1 (val), a2 (val), u268 (val)
            DataController.RemoveListener(a1, ("Loadout.%*.Equipped.Equipped Badge"):format(a2), u268)
        end)
    end

    function u207() -- Line: 769
        -- upvalues: a1 (val), LocalPlayer (upval), Participants (upval), a2 (val), u10 (val), HttpService (upval)
        local v1 = (a1:GetAttribute("Team")) == LocalPlayer:GetAttribute("Team")
        local v2 = a1:GetAttribute("IsSpectating") == true
        local v3 = Participants.IsAlive(a1) and not v2
        if a2 ~= "Terrorists" then
            if a2 == "Counter-Terrorists" then
                local DefuseKit = u10:FindFirstChild("DefuseKit")
                if DefuseKit then
                    local Attribute_3 = a1:GetAttribute("HasDefuseKit")
                    DefuseKit.Visible = v1 and v3 and Attribute_3 == true
                end
            end
            return
        end
        local Bomb = u10:FindFirstChild("Bomb")
        if not Bomb then
            return
        end
        local Attribute_2 = a1:GetAttribute("Slot5")
        if not Attribute_2 then
            Bomb.Visible = false
            return
        end
        local v4 = HttpService:JSONDecode(Attribute_2)
        Bomb.Visible = v1 and v3 and v4 and v4.Weapon == "C4"
    end

    if a2 == "Terrorists" then
        a3:Add((Observers.observeAttribute(a1, "Slot5", function() -- Line: 802 -- upvalues: u207 (ref), u10 (val)
            u207()
            return function() -- Line: 805 -- upvalues: u10 (upval)
                if u10:FindFirstChild("Bomb") then
                    u10.Bomb.Visible = false
                end
            end
        end)))
    elseif a2 == "Counter-Terrorists" then
        a3:Add((Observers.observeAttribute(a1, "HasDefuseKit", function() -- Line: 813 -- upvalues: u207 (ref), u10 (val)
            u207()
            return function() -- Line: 815 -- upvalues: u10 (upval)
                if u10:FindFirstChild("DefuseKit") then
                    u10.DefuseKit.Visible = false
                end
            end
        end)))
    end
    a3:Add((Observers.observeAttribute(LocalPlayer, "Team", u207)))
    u207()
    return u10
end

function u0.openFrame() -- Line: 832
    -- upvalues: EndScreenController (val), GameState (val), u223 (ref), u0 (val), u227 (ref)
    if not EndScreenController.IsActive() and GameState.GetState() ~= "Map Voting" then
        u227 = false
        u223.Visible = true
        return
    end
    if u223 and u223.Visible then
        u0.closeFrame()
    end
end

function u0.IsOpen() -- Line: 844 -- upvalues: u223 (ref)
    local Visible = false
    if u223 ~= nil then
        Visible = u223.Visible
    end
    return Visible
end

function u0.closeFrame() -- Line: 848
    -- upvalues: u223 (ref), u227 (ref), u224 (ref), u225 (ref), ProfileInspect (val), CameraController (val)
    u223.Visible = false
    u227 = false
    if u224 then
        u224.Visible = false
        if u225 then
            u224.Position = u225
        end
        ProfileInspect.Reset()
    end
    CameraController.setForceLockOverride("Leaderboard", false)
end

function u0.IsRightClickUnlockActive() -- Line: 855 -- upvalues: u227 (ref)
    return u227
end

function u0.characterAdded(a1, a2) -- Line: 859
    -- upvalues: Profiler (val), Janitor (val), u0 (val), u223 (ref), u228 (val)
    Profiler.scope("UI.Leaderboard.CharacterAdded", function() -- Line: 860 -- upvalues: Janitor (upval), u0 (upval), a1 (val), a2 (val), u223 (upval), u228 (upval)
        local v1 = Janitor.new()
        u0.cleanup(a1)
        local u12 = u0.createTemplate(a1, a2, v1)
        u12.Parent = u223:FindFirstChild(a2)
        v1:Add(function() -- Line: 865 -- upvalues: u12 (val)
            u12:Destroy()
        end)
        u228[a1] = v1
    end)
end

function u0.observePlayer(a1) -- Line: 872 -- upvalues: Observers (val), u0 (val) -- types: a1: userdata
    Observers.observeAttribute(a1, "Team", function(a1_2) -- Line: 873 -- upvalues: u0 (upval), a1 (val)
        if a1_2 == "Terrorists" or a1_2 == "Counter-Terrorists" then
            u0.characterAdded(a1, a1_2)
        end
        return function() -- Line: 879 -- upvalues: u0 (upval), a1 (upval)
            u0.cleanup(a1)
        end
    end)
end

function u0.cleanup(a1) -- Line: 885 -- upvalues: u228 (val) -- types: a1: userdata
    local v1 = u228[a1]
    u228[a1] = nil
    if v1 then
        v1:Destroy()
    end
end

function u0.Initialize(a1, a2) -- Line: 896
    -- upvalues: u223 (ref), u224 (ref), u225 (ref), ProfileInspect (val), u226 (ref), UserInputService (val)
    -- upvalues: u227 (ref), CameraController (val), Observers (val), updateGamemode (val), updateAliveCounts (val)
    -- upvalues: applyLossBonusVisibility (val), applyLossBars (val), refreshResults (val), u0 (val), LocalPlayer (val)
    -- upvalues: GetTimerFormat (val), observeAliveCountPlayer (val), u229 (val), Participants (val)
    u223 = a2
    u224 = a2:FindFirstChild("ProfileInspect")
    if u224 then
        u225 = u224.Position
        u224.Visible = false
        ProfileInspect.Bind(u224)
    end
    if u226 then
        u226:Disconnect()
        u226 = nil
    end
    u226 = UserInputService.InputBegan:Connect(function(a1) -- Line: 911 -- upvalues: u223 (upval), u227 (upval), CameraController (upval) -- types: a1: userdata
        if a1.UserInputType == Enum.UserInputType.MouseButton2 and u223 and u223.Visible then
            u227 = true
            CameraController.setForceLockOverride("Leaderboard", true)
        end
    end)
    Observers.observeAttribute(workspace, "Gamemode", function() -- Line: 919
        -- upvalues: updateGamemode (upval), updateAliveCounts (upval), applyLossBonusVisibility (upval)
        -- upvalues: applyLossBars (upval), refreshResults (upval)
        updateGamemode()
        updateAliveCounts()
        applyLossBonusVisibility()
        applyLossBars()
        refreshResults()
    end)
    Observers.observeAttribute(workspace, "Map", updateGamemode)
    Observers.observeAttribute(workspace, "ServerGamemode", function() -- Line: 927 -- upvalues: applyLossBonusVisibility (upval), applyLossBars (upval), refreshResults (upval)
        applyLossBonusVisibility()
        applyLossBars()
        refreshResults()
    end)
    Observers.observeAttribute(workspace, "GameState", function(a1) -- Line: 932 -- upvalues: u0 (upval), updateAliveCounts (upval) -- types: a1: string?
        if a1 == "Map Voting" then
            u0.closeFrame()
        end
        updateAliveCounts()
    end)
    Observers.observeAttribute(workspace, "CTScore", function(a1) -- Line: 940 -- upvalues: u223 (upval), refreshResults (upval)
        u223.Team.CT.Score.Text = tostring(a1)
        refreshResults()
        return function() -- Line: 943 -- upvalues: u223 (upval)
            u223.Team.CT.Score.Text = ""
        end
    end)
    Observers.observeAttribute(workspace, "TScore", function(a1) -- Line: 949 -- upvalues: u223 (upval), refreshResults (upval)
        u223.Team.T.Score.Text = tostring(a1)
        refreshResults()
        return function() -- Line: 952 -- upvalues: u223 (upval)
            u223.Team.T.Score.Text = ""
        end
    end)
    Observers.observeAttribute(workspace, "RoundResults", refreshResults)
    Observers.observeAttribute(workspace, "CurrentRound", refreshResults)
    Observers.observeAttribute(workspace, "RoundsToWin", refreshResults)
    Observers.observeAttribute(workspace, "HalftimeRound", refreshResults)
    Observers.observeAttribute(workspace, "CTLossStreak", applyLossBars)
    Observers.observeAttribute(workspace, "TLossStreak", applyLossBars)
    Observers.observeAttribute(LocalPlayer, "Team", refreshResults)
    applyLossBonusVisibility()
    applyLossBars()
    refreshResults()
    Observers.observeAttribute(workspace, "Timer", function(a1) -- Line: 976 -- upvalues: GetTimerFormat (upval), u223 (upval)
        local v1 = GetTimerFormat(a1)
        u223.TopInfo.Timer.Text = v1
        u223.Top.TopInfo.Timer.Text = v1
    end)
    Observers.observePlayer(function(a1) -- Line: 983
        -- upvalues: u0 (upval), observeAliveCountPlayer (upval), u229 (upval), updateAliveCounts (upval)
        u0.observePlayer(a1)
        observeAliveCountPlayer(a1)
        return function() -- Line: 986 -- upvalues: a1 (val), u229 (upval), u0 (upval), updateAliveCounts (upval)
            local v1 = a1
            local v2 = u229[v1]
            u229[v1] = nil
            if v2 then
                v2:Destroy()
            end
            u0.cleanup(v1)
            updateAliveCounts()
        end
    end)
    Participants.Observe(function(a1) -- Line: 992
        -- upvalues: Participants (upval), u0 (upval), observeAliveCountPlayer (upval)
        if Participants.IsBot(a1) then
            u0.observePlayer(a1)
            observeAliveCountPlayer(a1)
        end
    end, function(a1) -- Line: 997
        -- upvalues: Participants (upval), u229 (upval), u0 (upval), updateAliveCounts (upval)
        if Participants.IsBot(a1) then
            local v1 = u229[a1]
            u229[a1] = nil
            if v1 then
                v1:Destroy()
            end
            u0.cleanup(a1)
            updateAliveCounts()
        end
    end)
end

function u0.Start() -- Line: 1004 -- upvalues: clearFrame (val), u223 (ref), updateAliveCounts (val)
    clearFrame((u223:WaitForChild("Counter-Terrorists")))
    clearFrame((u223:WaitForChild("Terrorists")))
    updateAliveCounts()
end

return u0