-- ReplicatedStorage.Controllers.EndScreenController
-- Script path: ReplicatedStorage.Controllers.EndScreenController
-- Decompile time: 53.11 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local LevelsIcon = require(ReplicatedStorage.Database.Custom.GameStats.LevelsIcon)
local Sound = require(ReplicatedStorage.Classes.Sound)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local GetRankTitle = require(ReplicatedStorage.Components.Common.GetRankTitle)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation)
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam)
local AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter)
local Halftime = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Halftime)
local u126 = {3, 2, 4, 1, 5}
local u132 = {"st", "nd", "rd"}
local u146 = (CFrame.new(-0.251, 0.806, -0.406)) * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = workspace.CurrentCamera
local Characters = ReplicatedStorage.Assets.Characters
local u156 = {
    {Entrance = "rbxassetid://100747011940776", Idle = "rbxassetid://100747011940776"},
    {Entrance = "rbxassetid://103701913618746", Idle = "rbxassetid://100955283476946"},
    {Entrance = "rbxassetid://91396952135880", Idle = "rbxassetid://120200138438261"},
    {Entrance = "rbxassetid://136102955582599", Idle = "rbxassetid://74544097369437"},
    {Entrance = "rbxassetid://71439100344953", Idle = "rbxassetid://122693948164334"},
}
local u162 = {
    CT = {Character = "IDF", Weapon = "M4A1-S", Glove = "CT Glove"},
    T = {Character = "Anarchist", Weapon = "AK-47", Glove = "T Glove"},
}
local u165 = {["Counter-Terrorists"] = "CT", Terrorists = "T"}
local u169 = Janitor.new()
local u170 = false
local u171 = false
local u172 = 0
local u173 = true
local u174 = "EndScreen"
local u175 = nil
local u176 = nil
local u177 = {
    RoundWonCT = true,
    RoundWonT = true,
    RoundLost = true,
    PlayerMVPCT = true,
    PlayerMVPT = true,
    MissionCompleted = true,
}
local u178 = {MobileButtons = true}

local function getOrdinalPlacementText(a1) -- Line: 222 -- upvalues: u132 (val) -- types: a1: number
    local v1 = a1 % 100
    return (("%*%*"):format(a1, if not (v1 >= 11) then u132[a1 % 10] or "th" else not (v1 <= 13) and u132[a1 % 10] or "th"))
end

local function collectPlayingPlayers(a1) -- Line: 228 -- upvalues: IsPlayingTeam (val) -- types: a1: table
    local v1 = {}
    for k, v in pairs(a1) do
        if IsPlayingTeam(v.Team) then
            table.insert(v1, {userId = k, data = v})
        end
    end
    return v1
end

local function sortPlayersByADR(a1) -- Line: 238 -- upvalues: collectPlayingPlayers (val) -- types: a1: table
    local v1 = collectPlayingPlayers(a1)
    table.sort(v1, function(a1, a2) -- Line: 240
        local v1
        if (a1.data.ADR or 0) ~= (a2.data.ADR or 0) then
            v1 = a1.data.ADR or 0
            return (a2.data.ADR or 0) < v1
        end
        if (a1.data.Score or 0) == (a2.data.Score or 0) then
            return (tonumber(a1.userId) or (1 / 0)) < (tonumber(a2.userId) or (1 / 0))
        end
        v1 = a1.data.Score or 0
        return (a2.data.Score or 0) < v1
    end)
    return v1
end

local function rankFFAPlayers(a1) -- Line: 255 -- upvalues: collectPlayingPlayers (val) -- types: a1: table
    local v1 = collectPlayingPlayers(a1)
    table.sort(v1, function(a1, a2) -- Line: 257
        local v1
        if (a1.data.Score or 0) ~= (a2.data.Score or 0) then
            v1 = a1.data.Score or 0
            return (a2.data.Score or 0) < v1
        end
        if (a1.data.Kills or 0) ~= (a2.data.Kills or 0) then
            v1 = a1.data.Kills or 0
            return (a2.data.Kills or 0) < v1
        end
        if (a1.data.Assists or 0) == (a2.data.Assists or 0) then
            return (tonumber(a1.userId) or (1 / 0)) < (tonumber(a2.userId) or (1 / 0))
        end
        v1 = a1.data.Assists or 0
        return (a2.data.Assists or 0) < v1
    end)
    return v1
end

local function cleanupDebris() -- Line: 275 -- upvalues: Players (val), ClientCharacterPresentation (val)
    local Debris = workspace:FindFirstChild("Debris")
    if Debris then
        for i, j in Debris:GetChildren() do
            j:Destroy()
        end
    end
    for k, n in Players:GetPlayers() do
        ClientCharacterPresentation.Release(n, n.Character)
    end
end

local function getMiddleFrame() -- Line: 290 -- upvalues: PlayerGui (val)
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local Gameplay = MainGui and MainGui:FindFirstChild("Gameplay")
    return Gameplay and Gameplay:FindFirstChild("Middle")
end

local function getEndScreenFrame() -- Line: 296 -- upvalues: PlayerGui (val)
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local Gameplay = MainGui and MainGui:FindFirstChild("Gameplay")
    local v1 = Gameplay and Gameplay:FindFirstChild("Middle")
    return v1 and v1:FindFirstChild("EndScreen")
end

local function getEndScreenModel() -- Line: 301
    local TutorialEndScreenScene = workspace:FindFirstChild("TutorialEndScreenScene")
    local EndScreen = TutorialEndScreenScene and TutorialEndScreenScene:FindFirstChild("EndScreen")
    if EndScreen then
        return EndScreen
    end
    return workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EndScreen")
end

local function isPanel(a1) -- Line: 311 -- types: a1: userdata
    return a1:IsA("Frame") or a1:IsA("CanvasGroup")
end

local function setChildVisible(a1, a2, a3) -- Line: 315 -- types: a1: userdata, a2: string, a3: boolean
    local v1 = a1:FindFirstChild(a2)
    if v1 then
        v1.Visible = a3
    end
end

local function getTransparencyProperty(a1) -- Line: 322 -- types: a1: userdata
    if not a1:IsA("TextLabel") and not a1:IsA("TextButton") then
        if not a1:IsA("ImageLabel") and not a1:IsA("ImageButton") then
            if a1:IsA("Frame") then
                return "BackgroundTransparency"
            end
            if a1:IsA("UIStroke") then
                return "Transparency"
            end
            return nil
        end
        return "ImageTransparency"
    end
    return "TextTransparency"
end

local function setElementTransparency(a1, a2) -- Line: 335
    -- upvalues: getTransparencyProperty (val)
    local v1 = getTransparencyProperty(a1)
    if v1 then
        a1[v1] = a2
    end
end

local function tweenElementTransparency(a1, a2) -- Line: 342
    -- upvalues: getTransparencyProperty (val), TweenService (val)
    local v1 = getTransparencyProperty(a1)
    if v1 then
        TweenService:Create(a1, TweenInfo.new(0.5), {[v1] = a2}):Play()
    end
end

local function shouldSkipFade(a1) -- Line: 349 -- types: a1: userdata
    if a1:GetAttribute("SkipFade") then
        return true
    end
    local Parent = a1.Parent
    while Parent do
        if not Parent:IsA("GuiObject") then
            break
        end
        if Parent:GetAttribute("SkipFade") then
            return true
        end
        Parent = Parent.Parent
    end
    return false
end

local function fadeFrame(a1, a2) -- Line: 363
    -- upvalues: shouldSkipFade (val), TweenService (val), tweenElementTransparency (val)
    local v1 = nil
    if not shouldSkipFade(a1) then
        v1 = TweenService:Create(a1, TweenInfo.new(0.5), {BackgroundTransparency = a2})
    end
    for i, j in a1:GetDescendants() do
        if not shouldSkipFade(j) then
            tweenElementTransparency(j, a2)
        end
    end
    if v1 then
        v1:Play()
    end
    return v1
end

local function fadeInFrame(a1) -- Line: 383
    -- upvalues: shouldSkipFade (val), getTransparencyProperty (val), fadeFrame (val)
    local v1
    if not shouldSkipFade(a1) then
        a1.BackgroundTransparency = 1
    end
    for i, j in a1:GetDescendants() do
        if not shouldSkipFade(j) then
            v1 = getTransparencyProperty(j)
            if v1 then
                j[v1] = 1
            end
        end
    end
    a1.Visible = true
    return (fadeFrame(a1, 0))
end

local function getBarTweenInfo(a1) -- Line: 404 -- types: a1: boolean?
    return TweenInfo.new(if not a1 then 0.75 else 0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
end

local function playInterfaceSound(a1, a2) -- Line: 409
    -- upvalues: Sound (val), CurrentCamera (val)
    local v1 = (Sound.new("Interface")):play({Parent = CurrentCamera, Name = a1})
    if v1 and a2 then
        v1.PlaybackSpeed = a2
    end
end

local function createBarSize(a1, a2) -- Line: 436 -- types: a1: number, a2: UDim2
    return UDim2.new(a1, 0, a2.Scale, a2.Offset)
end

local function setChildText(a1, a2, a3) -- Line: 440 -- types: a1: userdata, a2: string, a3: string
    local v1 = a1:FindFirstChild(a2)
    if v1 then
        v1.Text = a3
    end
end

local function storeFrameTransparency(a1) -- Line: 452 -- types: a1: userdata
    local v1 = {}
    for i, j in a1:GetDescendants() do
        if j:IsA("UIStroke") then
            v1[j] = j.Transparency
        end
    end
    return {BackgroundTransparency = a1.BackgroundTransparency, Strokes = v1}
end

local function restoreFrameTransparency(a1, a2) -- Line: 465 -- types: a1: userdata, a2: table
    a1.BackgroundTransparency = a2.BackgroundTransparency
    for k, v in pairs(a2.Strokes) do
        if k and k.Parent then
            k.Transparency = v
        end
    end
end

local function setRankDisplay(a1, a2) -- Line: 474
    -- upvalues: GetRankTitle (val), LevelsIcon (val)
    local v1 = ("[%* Rank %*]"):format(GetRankTitle(a2), a2)
    local TextLabel = a1:FindFirstChild("TextLabel")
    if TextLabel then
        TextLabel.Text = v1
    end
    local Rank = a1:FindFirstChild("Rank")
    if Rank then
        Rank.Image = LevelsIcon[tostring(a2)] or ""
    end
end

local function populateLevelFrame(a1) -- Line: 483
    -- upvalues: PlayerGui (val), u176 (ref), DataController (val), LocalPlayer (val), GetRankTitle (val)
    -- upvalues: LevelsIcon (val), storeFrameTransparency (val)
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local Gameplay = MainGui and MainGui:FindFirstChild("Gameplay")
    local v1 = Gameplay and Gameplay:FindFirstChild("Middle")
    local v2 = v1 and v1:FindFirstChild("EndScreen")
    if not v2 then
        return nil
    end
    local Level = v2:FindFirstChild("Level")
    if not Level then
        return nil
    end
    local v3 = u176 or DataController.Get(LocalPlayer, "Level")
    if not v3 then
        return nil
    end
    local v4 = v3.Level or 1
    local v5 = v3.Experience or 0
    local v6 = v3.NextExperienceRequirement or 1000
    local v7 = ("[%* Rank %*]"):format(GetRankTitle(v4), v4)
    local TextLabel = Level:FindFirstChild("TextLabel")
    if TextLabel then
        TextLabel.Text = v7
    end
    local Rank = Level:FindFirstChild("Rank")
    if Rank then
        Rank.Image = LevelsIcon[tostring(v4)] or ""
    end
    local LevelBar = Level:FindFirstChild("LevelBar")
    if not LevelBar then
        return nil
    end
    local Current = LevelBar:FindFirstChild("Current")
    local Earned = LevelBar:FindFirstChild("Earned")
    if Current and Earned then
        local CurrentInfo = Level:FindFirstChild("CurrentInfo", true)
        local EarnedInfo = Level:FindFirstChild("EarnedInfo", true)
        if CurrentInfo and EarnedInfo then
            for i, j in {Current, Earned, CurrentInfo, EarnedInfo} do
                j:SetAttribute("SkipFade", true)
            end
            local v8 = ("%*xp"):format(v5)
            local Amount = CurrentInfo:FindFirstChild("Amount")
            if Amount then
                Amount.Text = v8
            end
            v8 = ("+%*xp"):format(a1)
            local Amount_2 = EarnedInfo:FindFirstChild("Amount")
            if Amount_2 then
                Amount_2.Text = v8
            end
            return {
                currentXP = v5,
                xpEarned = a1,
                nextLevelXP = math.max(v6, 1),
                currentLevel = v4,
                barHeight = Current.Size.Y,
                levelBar = LevelBar,
                levelFrame = Level,
                currentBar = Current,
                earnedBar = Earned,
                currentInfo = CurrentInfo,
                earnedInfo = EarnedInfo,
                currentInfoTransparency = storeFrameTransparency(CurrentInfo),
                earnedInfoTransparency = storeFrameTransparency(EarnedInfo),
            }
        end
        return nil
    end
    return nil
end

local function calcInfoXOffset(a1, a2, a3) -- Line: 548 -- types: a1: userdata, a2: userdata, a3: number
    local v1 = a1.AbsolutePosition.X + a3 * a1.AbsoluteSize.X
    local Parent = a2.Parent
    local X = Parent and Parent.AbsolutePosition.X or 0
    local v2 = a2.AnchorPoint.X * a2.AbsoluteSize.X
    return v1 - X + v2
end

local function tweenInfoToBarEnd(a1, a2, a3, a4) -- Line: 560
    -- upvalues: TweenService (val)
    local Position = a1.Position
    local v1 = a2.AbsolutePosition.X + a3 * a2.AbsoluteSize.X
    local Parent = a1.Parent
    local X = Parent and Parent.AbsolutePosition.X or 0
    local v2 = a1.AnchorPoint.X * a1.AbsoluteSize.X
    v1 = UDim2.new(0, v1 - X + v2, Position.Y.Scale, Position.Y.Offset)
    return TweenService:Create(a1, a4, {Position = v1})
end

local function wouldOverlap(a1, a2, a3) -- Line: 570 -- types: a1: userdata, a2: userdata, a3: number
    local v1 = a1.AbsolutePosition.X + a1.AbsoluteSize.X
    local X = a2.Parent.AbsolutePosition.X
    local v2 = a2.AnchorPoint.X * a2.AbsoluteSize.X
    return X + a3 - v2 < v1 + 5
end

local function calcInfoTopAlignedYOffset(a1, a2) -- Line: 578 -- types: a1: userdata, a2: number
    local Parent = a1.Parent
    local Y = Parent and Parent.AbsolutePosition.Y or 0
    local v1 = a1.AnchorPoint.Y * a1.AbsoluteSize.Y
    return a2 - Y + v1
end

local function getAdjustedEarnedPosition(a1, a2, a3) -- Line: 585 -- types: a1: userdata, a2: userdata, a3: number
    local Y = a1.AbsolutePosition.Y
    local v1 = a1.AbsolutePosition.X + a1.AbsoluteSize.X
    local X = a2.Parent.AbsolutePosition.X
    local v2 = a2.AnchorPoint.X * a2.AbsoluteSize.X
    if X + a3 - v2 < v1 + 5 then
        Y = Y + a1.AbsoluteSize.Y + -2
    end
    local new = UDim2.new
    local Parent = a2.Parent
    return new(0, a3, 0, Y - (Parent and Parent.AbsolutePosition.Y or 0) + a2.AnchorPoint.Y * a2.AbsoluteSize.Y)
end

local function playBarTween(a1, a2, a3, a4, a5, a6) -- Line: 596
    -- upvalues: TweenService (val), Sound (val), CurrentCamera (val)
    local v1 = TweenService:Create(a1, a3, {Size = a2})
    if a5 then
        local v2 = (Sound.new("Interface")):play({Name = "XP Bar Fill", Parent = CurrentCamera})
        if v2 and a6 then
            v2.PlaybackSpeed = a6
        end
    end
    v1:Play()
    a4:Play()
    v1.Completed:Wait()
end

local function tweenInfoToBarEndWithOverlapCheck(a1, a2, a3, a4, a5) -- Line: 613
    -- upvalues: TweenService (val)
    local v1 = a3.AbsolutePosition.X + a4 * a3.AbsoluteSize.X
    local Parent_2 = a1.Parent
    local X = Parent_2 and Parent_2.AbsolutePosition.X or 0
    local v2 = a1.AnchorPoint.X * a1.AbsoluteSize.X
    local v3 = v1 - X + v2
    local Y = a2.AbsolutePosition.Y
    v2 = a2.AbsolutePosition.X + a2.AbsoluteSize.X
    local X_2 = a1.Parent.AbsolutePosition.X
    local v4 = a1.AnchorPoint.X * a1.AbsoluteSize.X
    if X_2 + v3 - v4 < v2 + 5 then
        Y = Y + a2.AbsoluteSize.Y + -2
    end
    local new = UDim2.new
    local Parent = a1.Parent
    local Y_2 = Parent and Parent.AbsolutePosition.Y or 0
    local v5 = a1.AnchorPoint.Y * a1.AbsoluteSize.Y
    return TweenService:Create(a1, a5, {Position = new(0, v3, 0, Y - Y_2 + v5)})
end

local function animateLevelBar(a1) -- Line: 625
    -- upvalues: u170 (ref), tweenInfoToBarEnd (val), playBarTween (val), tweenInfoToBarEndWithOverlapCheck (val)
    -- upvalues: Sound (val), CurrentCamera (val), GetRankTitle (val), LevelsIcon (val), TweenService (val)
    local v1
    if not u170 then
        return
    end
    local v2 = math.clamp(a1.currentXP / a1.nextLevelXP, 0, 1)
    local v3 = a1.currentXP + a1.xpEarned
    local v4 = math.clamp(v3 / a1.nextLevelXP, 0, 1)
    local v5 = a1.nextLevelXP <= v3
    a1.currentBar.Visible = false
    a1.earnedBar.Visible = false
    local currentBar = a1.currentBar
    local barHeight = a1.barHeight
    currentBar.Size = UDim2.new(0, 0, barHeight.Scale, barHeight.Offset)
    local earnedBar = a1.earnedBar
    local barHeight_2 = a1.barHeight
    earnedBar.Size = UDim2.new(0, 0, barHeight_2.Scale, barHeight_2.Offset)
    a1.currentInfo.Visible = false
    a1.earnedInfo.Visible = false
    local currentInfo = a1.currentInfo
    local currentInfoTransparency = a1.currentInfoTransparency
    currentInfo.BackgroundTransparency = currentInfoTransparency.BackgroundTransparency
    for k, v in pairs(currentInfoTransparency.Strokes) do
        if k and k.Parent then
            k.Transparency = v
        end
    end
    local earnedInfo = a1.earnedInfo
    local earnedInfoTransparency = a1.earnedInfoTransparency
    earnedInfo.BackgroundTransparency = earnedInfoTransparency.BackgroundTransparency
    for k2, i in pairs(earnedInfoTransparency.Strokes) do
        if k2 and k2.Parent then
            k2.Transparency = i
        end
    end
    local levelBar = a1.levelBar
    local currentInfo_2 = a1.currentInfo
    local v6 = levelBar.AbsolutePosition.X + 0 * levelBar.AbsoluteSize.X
    local Parent = currentInfo_2.Parent
    local X = Parent and Parent.AbsolutePosition.X or 0
    local v7 = currentInfo_2.AnchorPoint.X * currentInfo_2.AbsoluteSize.X
    local v8 = v6 - X + v7
    local levelBar_2 = a1.levelBar
    local earnedInfo_2 = a1.earnedInfo
    local v9 = levelBar_2.AbsolutePosition.X + 0 * levelBar_2.AbsoluteSize.X
    local Parent_2 = earnedInfo_2.Parent
    local X_2 = Parent_2 and Parent_2.AbsolutePosition.X or 0
    local v10 = earnedInfo_2.AnchorPoint.X * earnedInfo_2.AbsoluteSize.X
    local v11 = v9 - X_2 + v10
    local Position = a1.currentInfo.Position
    local Position_2 = a1.earnedInfo.Position
    a1.currentInfo.Position = UDim2.new(0, v8, Position.Y.Scale, Position.Y.Offset)
    a1.earnedInfo.Position = UDim2.new(0, v11, Position_2.Y.Scale, Position_2.Y.Offset)
    task.wait(0.5)
    if not u170 then
        return
    end
    a1.currentBar.Visible = true
    a1.currentInfo.Visible = true
    if v2 > 0 then
        v9 = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local v12 = tweenInfoToBarEnd(a1.currentInfo, a1.levelBar, v2, v9)
        v7 = playBarTween
        local currentBar_2 = a1.currentBar
        local barHeight_3 = a1.barHeight
        v7(currentBar_2, UDim2.new(v2, 0, barHeight_3.Scale, barHeight_3.Offset), v9, v12, true)
        if not u170 then
            return
        end
    end
    if a1.xpEarned <= 0 then
        return
    end
    task.wait(0.6)
    if not u170 then
        return
    end
    local earnedBar_2 = a1.earnedBar
    local barHeight_4 = a1.barHeight
    earnedBar_2.Size = UDim2.new(v2, 0, barHeight_4.Scale, barHeight_4.Offset)
    a1.earnedBar.Visible = true
    a1.earnedInfo.Visible = true
    local levelBar_3 = a1.levelBar
    local earnedInfo_3 = a1.earnedInfo
    v10 = levelBar_3.AbsolutePosition.X + v2 * levelBar_3.AbsoluteSize.X
    local Parent_3 = earnedInfo_3.Parent
    local X_3 = Parent_3 and Parent_3.AbsolutePosition.X or 0
    local v13 = earnedInfo_3.AnchorPoint.X * earnedInfo_3.AbsoluteSize.X
    v9 = v10 - X_3 + v13
    local currentInfo_3 = a1.currentInfo
    local earnedInfo_4 = a1.earnedInfo
    local Y = currentInfo_3.AbsolutePosition.Y
    v13 = currentInfo_3.AbsolutePosition.X + currentInfo_3.AbsoluteSize.X
    local X_4 = earnedInfo_4.Parent.AbsolutePosition.X
    local v14 = earnedInfo_4.AnchorPoint.X * earnedInfo_4.AbsoluteSize.X
    if X_4 + v9 - v14 < v13 + 5 then
        Y = Y + currentInfo_3.AbsoluteSize.Y + -2
    end
    local new = UDim2.new
    local Parent_5 = earnedInfo_4.Parent
    local Y_2 = Parent_5 and Parent_5.AbsolutePosition.Y or 0
    local v15 = earnedInfo_4.AnchorPoint.Y * earnedInfo_4.AbsoluteSize.Y
    local v16 = new(0, v9, 0, Y - Y_2 + v15)
    a1.earnedInfo.Position = v16
    if not v5 then
        v7 = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        v10 = tweenInfoToBarEndWithOverlapCheck(a1.earnedInfo, a1.currentInfo, a1.levelBar, v4, v7)
        v1 = playBarTween
        local earnedBar_6 = a1.earnedBar
        local barHeight_9 = a1.barHeight
        v1(earnedBar_6, UDim2.new(v4, 0, barHeight_9.Scale, barHeight_9.Offset), v7, v10, true, 1.15)
        return
    end
    v7 = TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    v10 = tweenInfoToBarEndWithOverlapCheck(a1.earnedInfo, a1.currentInfo, a1.levelBar, 1, v7)
    v1 = playBarTween
    local earnedBar_3 = a1.earnedBar
    local barHeight_5 = a1.barHeight
    v1(earnedBar_3, UDim2.new(1, 0, barHeight_5.Scale, barHeight_5.Offset), v7, v10, true, 1.15)
    if not u170 then
        return
    end
    ;(Sound.new("Interface")):play({Name = "Level Up", Parent = CurrentCamera})
    v16 = math.clamp((v3 - a1.nextLevelXP) / a1.nextLevelXP, 0, 1)
    local levelFrame = a1.levelFrame
    local v17 = a1.currentLevel + 1
    v14 = ("[%* Rank %*]"):format(GetRankTitle(v17), v17)
    local TextLabel = levelFrame:FindFirstChild("TextLabel")
    if TextLabel then
        TextLabel.Text = v14
    end
    local Rank = levelFrame:FindFirstChild("Rank")
    if Rank then
        Rank.Image = LevelsIcon[tostring(v17)] or ""
    end
    local currentBar_3 = a1.currentBar
    local barHeight_6 = a1.barHeight
    currentBar_3.Size = UDim2.new(0, 0, barHeight_6.Scale, barHeight_6.Offset)
    local earnedBar_4 = a1.earnedBar
    local barHeight_7 = a1.barHeight
    earnedBar_4.Size = UDim2.new(0, 0, barHeight_7.Scale, barHeight_7.Offset)
    a1.currentInfo.Visible = false
    local levelBar_4 = a1.levelBar
    local earnedInfo_5 = a1.earnedInfo
    local v18 = levelBar_4.AbsolutePosition.X + 0 * levelBar_4.AbsoluteSize.X
    local Parent_6 = earnedInfo_5.Parent
    local X_5 = Parent_6 and Parent_6.AbsolutePosition.X or 0
    local v19 = earnedInfo_5.AnchorPoint.X * earnedInfo_5.AbsoluteSize.X
    v13 = v18 - X_5 + v19
    local earnedInfo_6 = a1.earnedInfo
    local Y_3 = a1.currentInfo.AbsolutePosition.Y
    local Parent_7 = earnedInfo_6.Parent
    local Y_4 = Parent_7 and Parent_7.AbsolutePosition.Y or 0
    v19 = earnedInfo_6.AnchorPoint.Y * earnedInfo_6.AbsoluteSize.Y
    v17 = Y_3 - Y_4 + v19
    a1.earnedInfo.Position = UDim2.new(0, v13, 0, v17)
    v14 = tweenInfoToBarEnd(a1.earnedInfo, a1.levelBar, v16, v7)
    local earnedBar_5 = a1.earnedBar
    local barHeight_8 = a1.barHeight
    local v20 = TweenService:Create(earnedBar_5, v7, {Size = UDim2.new(v16, 0, barHeight_8.Scale, barHeight_8.Offset)})
    v20:Play()
    v14:Play()
    v20.Completed:Wait()
end

local function scaleUDim2(a1, a2) -- Line: 755 -- types: a1: userdata, a2: number
    return UDim2.new(a1.X.Scale * a2, a1.X.Offset * a2, a1.Y.Scale * a2, a1.Y.Offset * a2)
end

local function getItemIcon(a1) -- Line: 764 -- upvalues: Cases (val), Skins (val) -- types: a1: table
    local v1
    local v2 = if not a1.Type then "" else string.lower(a1.Type)
    local Name = a1.Name
    if v2 == "credits" then
        return "rbxassetid://115958498634807"
    end
    if v2 ~= "case" and v2 ~= "sticker capsule" and v2 ~= "charm pack" and v2 ~= "charm capsule" then
        if a1.Skin and Name then
            v1 = Skins.GetSkinInformation(Name, a1.Skin)
            if v1 then
                if v1.wearImages and v1.wearImages[1] then
                    return v1.wearImages[1].assetId
                end
                if v1.charmImages and v1.charmImages[1] then
                    return v1.charmImages[1].assetId
                end
                if v1.imageAssetId then
                    return v1.imageAssetId
                end
            end
        end
        return "rbxassetid://18822070027"
    end
    v1 = Cases.GetCaseByName(Name)
    if v1 and v1.imageAssetId then
        return v1.imageAssetId
    end
    if a1.Skin and Name then
        v1 = Skins.GetSkinInformation(Name, a1.Skin)
        if v1 then
            if v1.wearImages and v1.wearImages[1] then
                return v1.wearImages[1].assetId
            end
            if v1.charmImages and v1.charmImages[1] then
                return v1.charmImages[1].assetId
            end
            if v1.imageAssetId then
                return v1.imageAssetId
            end
        end
    end
    return "rbxassetid://18822070027"
end

local function clearDropItems(a1) -- Line: 807 -- types: a1: userdata
    for i, j in a1:GetChildren() do
        if j:IsA("Frame") and j.Name ~= "ItemTemplate" then
            j:Destroy()
        end
    end
end

local function displayDrops(a1) -- Line: 815
    -- upvalues: u170 (ref), PlayerGui (val), clearDropItems (val), getItemIcon (val), Rarities (val), fadeInFrame (val)
    -- upvalues: TweenService (val), u169 (val)
    if u170 and a1 and #a1 ~= 0 then
        local Content, Icon, Player, Rarity, RarityFrame, Size, UIGradient, amount, inventoryItem, reward, v1, v2, v3
        local MainGui = PlayerGui:FindFirstChild("MainGui")
        local Gameplay = MainGui and MainGui:FindFirstChild("Gameplay")
        local v4 = Gameplay and Gameplay:FindFirstChild("Middle")
        local v5 = v4 and v4:FindFirstChild("EndScreen")
        if not v5 then
            return
        end
        local Drops = v5:FindFirstChild("Drops")
        local Container = Drops and Drops:FindFirstChild("Container")
        local ItemTemplate = Container and Container:FindFirstChild("ItemTemplate")
        if not ItemTemplate then
            return
        end
        Container:SetAttribute("SkipFade", true)
        ItemTemplate.Visible = false
        clearDropItems(Container)
        Drops.Visible = false
        task.wait(0.8)
        if not u170 then
            return
        end
        local v6 = {}
        for i, v in ipairs(a1) do
            reward = v.reward
            v1 = reward.type == "credits"
            inventoryItem = reward.inventoryItem
            if v1 or inventoryItem then
                v2 = ItemTemplate:Clone()
                v2.Name = "Drop_" .. i
                v2.Visible = false
                v2.Parent = Container
                Content = v2:FindFirstChild("Content")
                if Content then
                    Icon = Content:FindFirstChild("Icon")
                    if Icon then
                        Icon.Image = if not v1 then getItemIcon(inventoryItem) else "rbxassetid://115958498634807"
                    end
                    amount = Content:FindFirstChild("amount") or Content:FindFirstChild("Amount")
                    if amount then
                        if not v1 or not reward.amount then
                            amount.Visible = false
                        else
                            amount.Visible = true
                            amount.Text = ("x%*"):format(reward.amount)
                        end
                    end
                    RarityFrame = Content:FindFirstChild("RarityFrame")
                    UIGradient = RarityFrame and RarityFrame:FindFirstChild("UIGradient")
                    if UIGradient then
                        Rarity = if not v1 then inventoryItem and inventoryItem.Rarity else "Rare"
                        v3 = Rarity and Rarities[Rarity]
                        if v3 and v3.ColorSequence then
                            UIGradient.Color = v3.ColorSequence
                        end
                    end
                    Size = Content.Size
                    Content.Size = UDim2.new(Size.X.Scale * 1.25, Size.X.Offset * 1.25, Size.Y.Scale * 1.25, Size.Y.Offset * 1.25)
                    Player = v2:FindFirstChild("Player", true)
                    if Player and 0 < v.userId then
                        Player.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(v.userId)
                    end
                    table.insert(v6, {item = v2, content = Content, originalSize = Size})
                else
                    v2:Destroy()
                end
            end
        end
        if #v6 == 0 then
            return
        end
        fadeInFrame(Drops)
        task.wait(0.5)
        if not u170 then
            return
        end
        local u93 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        for i2, i3 in ipairs(v6) do
            task.delay((i2 - 1) * 0.35, function() -- Line: 918 -- upvalues: u170 (upval), i3 (val), TweenService (upval), u93 (val), u169 (upval)
                if not u170 then
                    return
                end
                i3.item.Visible = true
                local v1 = TweenService:Create(i3.content, u93, {Size = i3.originalSize})
                u169:Add(v1, "Cancel")
                v1:Play()
            end)
        end
        return
    end
end

local function recordPanelVisibility(a1, a2) -- Line: 931 -- types: a1: userdata?, a2: table
    if a1 then
        local v1
        for i, j in a1:GetChildren() do
            v1 = j:IsA("Frame") or j:IsA("CanvasGroup")
            if v1 then
                v2[j.Name] = j.Visible
            end
        end
    end
end

local function applyPanelVisibility(a1, a2, a3) -- Line: 941 -- types: a1: userdata, a2: table, a3: table?
    local v1
    for i, j in a1:GetChildren() do
        v1 = j:IsA("Frame") or j:IsA("CanvasGroup")
        if v1 then
            v1 = v2[j.Name]
            if v1 ~= nil then
                if not v3 or not v3[j.Name] then
                    j.Visible = v1
                end
            end
        end
    end
end

local function captureVisibilitySnapshot(a1) -- Line: 952
    -- upvalues: recordPanelVisibility (val), u175 (ref)
    local Gameplay = a1:FindFirstChild("Gameplay")
    local Menu = a1:FindFirstChild("Menu")
    local v1 = {GameplayVisible = Gameplay and Gameplay.Visible or false}
    v1.MenuVisible = Menu and Menu.Visible or false
    v1.GameplayChildren = {}
    v1.MiddleChildren = {}
    recordPanelVisibility(Gameplay, v1.GameplayChildren)
    recordPanelVisibility(Gameplay and Gameplay:FindFirstChild("Middle") or nil, v1.MiddleChildren)
    u175 = v1
end

local function restoreVisibilitySnapshot(a1, a2) -- Line: 969
    -- upvalues: u175 (ref), applyPanelVisibility (val), u178 (val), u177 (val)
    if not u175 then
        return
    end
    local v1 = u175
    u175 = nil
    local Gameplay = a1:FindFirstChild("Gameplay")
    local Menu = a1:FindFirstChild("Menu")
    local Middle = Gameplay and Gameplay:FindFirstChild("Middle") or nil
    if Menu then
        Menu.Visible = v1.MenuVisible
    end
    if Gameplay then
        Gameplay.Visible = v1.GameplayVisible
        applyPanelVisibility(Gameplay, v1.GameplayChildren)
    end
    if Middle then
        applyPanelVisibility(Middle, v1.MiddleChildren, u178)
        if a2 then
            local v2, v3
            for k in pairs(u177) do
                v2 = Middle:FindFirstChild(k)
                if v2 then
                    v3 = v2:IsA("Frame") or v2:IsA("CanvasGroup")
                    if v3 then
                        v2.Visible = false
                    end
                end
            end
        end
    end
end

local function enforceEndScreenVisibility(a1) -- Line: 1004
    -- upvalues: u174 (ref), MenuState (val)
    local v1
    local v2 = u174 == "Halftime"
    if a1:FindFirstChild("Menu") then
        MenuState.HideMenu()
    end
    local Gameplay = a1:FindFirstChild("Gameplay")
    if not Gameplay then
        return
    end
    local Middle = Gameplay:FindFirstChild("Middle")
    local EndScreen = Middle and Middle:FindFirstChild("EndScreen") or nil
    local Halftime = Middle and Middle:FindFirstChild("Halftime") or nil
    Gameplay.Visible = true
    for i, j in Gameplay:GetChildren() do
        if j:IsA("Frame") or j:IsA("CanvasGroup") then
            v1 = j == Middle
            j.Visible = v1
        end
    end
    if not Middle then
        return
    end
    Middle.Visible = true
    for k, n in Middle:GetChildren() do
        if n:IsA("Frame") or n:IsA("CanvasGroup") then
            if n == EndScreen then
                n.Visible = not v2
            elseif n ~= Halftime then
                n.Visible = false
            else
                n.Visible = v2
            end
        end
    end
    if EndScreen then
        EndScreen.Visible = not v2
    end
    if Halftime then
        Halftime.Visible = v2
    end
end

local u220 = {}
u220.Victory = {
    Background = Color3.fromRGB(11, 97, 31),
    Glow = Color3.fromRGB(46, 158, 78),
    Pattern = Color3.fromRGB(134, 255, 78),
    Stroke = Color3.fromRGB(48, 127, 48),
}
u220.Defeat = {
    Background = Color3.fromRGB(83, 9, 9),
    Glow = Color3.fromRGB(158, 14, 14),
    Pattern = Color3.fromRGB(255, 53, 53),
    Stroke = Color3.fromRGB(127, 48, 48),
}

local function hidePanels(a1) -- Line: 1071 -- types: a1: userdata
    local v1
    for i, j in a1:GetChildren() do
        v1 = j:IsA("Frame") or j:IsA("CanvasGroup")
        if v1 then
            j.Visible = false
        end
    end
end

local function setupResultFrame(a1, a2, a3, a4, a5) -- Line: 1080
    -- upvalues: getTransparencyProperty (val)
    local v1
    if not a1 then
        return
    end
    a1.BackgroundTransparency = 0
    for i, j in a1:GetDescendants() do
        v1 = getTransparencyProperty(j)
        if v1 then
            j[v1] = 0
        end
    end
    a1.Visible = a2
    local Score = a1:FindFirstChild("Score")
    if Score then
        Score.BackgroundColor3 = a3.Background
        local Glow = Score:FindFirstChild("Glow")
        if Glow and Glow:IsA("ImageLabel") then
            Glow.ImageColor3 = a3.Glow
        end
        local Pattern = Score:FindFirstChild("Pattern")
        if Pattern and Pattern:IsA("ImageLabel") then
            Pattern.ImageColor3 = a3.Pattern
        end
        local UIStroke = Score:FindFirstChildOfClass("UIStroke")
        if UIStroke then
            UIStroke.Color = a3.Stroke
        end
        local TextLabel = Score:FindFirstChild("TextLabel")
        if TextLabel then
            TextLabel.Text = a4
        end
    end
    local TextLabel_2 = a1:FindFirstChild("TextLabel")
    if TextLabel_2 then
        TextLabel_2.Text = a5
    end
end

local function bindVisibilityLock(a1) -- Line: 1119
    -- upvalues: u169 (val), RunServiceController (val), enforceEndScreenVisibility (val)
    u169:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1121 -- upvalues: enforceEndScreenVisibility (upval), a1 (val)
        enforceEndScreenVisibility(a1)
    end), "Disconnect", "EndScreenVisibilityLock")
end

local function showEndScreenUI(a1) -- Line: 1129
    -- upvalues: PlayerGui (val), captureVisibilitySnapshot (val), CameraController (val), IsPlayingTeam (val)
    -- upvalues: Halftime (val), u169 (val), RunServiceController (val), enforceEndScreenVisibility (val)
    -- upvalues: setupResultFrame (val), u220 (val)
    local v1, v2
    local isDraw = a1.isDraw
    local didWin = a1.didWin
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    if not MainGui then
        return
    end
    captureVisibilitySnapshot(MainGui)
    CameraController.setForceLockOverride("EndScreen", true)
    CameraController.setPerspective(false, true)
    local Menu = MainGui:FindFirstChild("Menu")
    if Menu then
        Menu.Visible = false
        CameraController.setForceLockOverride("Menu", false)
    end
    local Gameplay = MainGui:FindFirstChild("Gameplay")
    if not Gameplay then
        return
    end
    Gameplay.Visible = true
    local v3 = a1
    for i, j in Gameplay:GetChildren() do
        v1 = j:IsA("Frame") or j:IsA("CanvasGroup")
        if v1 then
            j.Visible = false
        end
    end
    local Middle = Gameplay:FindFirstChild("Middle")
    if not Middle then
        return
    end
    for k, n in Middle:GetChildren() do
        v2 = n:IsA("Frame") or n:IsA("CanvasGroup")
        if v2 then
            n.Visible = false
        end
    end
    Middle.Visible = true
    local EndScreen = Middle:FindFirstChild("EndScreen")
    if v3.overlayMode == "Halftime" then
        if EndScreen then
            EndScreen.Visible = false
        end
        if not Middle:FindFirstChild("Halftime") or not IsPlayingTeam(v3.halftimeTeam) then
            Halftime.Hide()
        else
            Halftime.Show(v3.halftimeTeam)
        end
        u169:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1121 -- upvalues: enforceEndScreenVisibility (upval), MainGui (val)
            enforceEndScreenVisibility(MainGui)
        end), "Disconnect", "EndScreenVisibilityLock")
        return
    end
    Halftime.Hide()
    if not EndScreen then
        return
    end
    local MapVote = EndScreen:FindFirstChild("MapVote")
    if MapVote then
        MapVote.Visible = false
    end
    local Top = EndScreen:FindFirstChild("Top")
    if Top then
        Top.Visible = false
    end
    EndScreen.Visible = true
    local tScore = v3.tScore
    local ctScore = v3.ctScore
    if isDraw or v3.winningTeam == "Counter-Terrorists" then
        tScore = v3.ctScore
        ctScore = v3.tScore
    end
    local scoreTextOverride = v3.scoreTextOverride or ("<b>%*</b> - %*"):format(tScore, ctScore)
    local v4 = if not isDraw then "Victory" else "Draw"
    setupResultFrame(EndScreen:FindFirstChild("Victory"), isDraw or didWin, u220.Victory, scoreTextOverride, v4)
    v4 = if not isDraw then "Defeat" else "Draw"
    setupResultFrame(EndScreen:FindFirstChild("Defeat"), not isDraw and not didWin, u220.Defeat, scoreTextOverride, v4)
    local showAccolades = v3.showAccolades
    local MVP = EndScreen:FindFirstChild("MVP")
    if MVP then
        MVP.Visible = showAccolades
    end
    local returnToMenu = v3.returnToMenu
    local Close = EndScreen:FindFirstChild("Close")
    if Close then
        Close.Visible = returnToMenu
    end
    local Level = EndScreen:FindFirstChild("Level")
    if Level then
        Level.Visible = false
    end
    local Drops = EndScreen:FindFirstChild("Drops")
    if Drops then
        Drops.Visible = false
    end
    u169:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1121 -- upvalues: enforceEndScreenVisibility (upval), MainGui (val)
        enforceEndScreenVisibility(MainGui)
    end), "Disconnect", "EndScreenVisibilityLock")
end

local function clearSkipFade(a1) -- Line: 1223 -- types: a1: userdata?
    if a1 then
        a1:SetAttribute("SkipFade", nil)
    end
end

local function hideMvpSlots(a1) -- Line: 1229 -- types: a1: userdata
    local v1
    for i = 1, 5 do
        v1 = a1:FindFirstChild((tostring(i)))
        if v1 then
            v1.Visible = false
        end
    end
end

local function hideEndScreenUI() -- Line: 1235
    -- upvalues: PlayerGui (val), Halftime (val), hideMvpSlots (val), clearDropItems (val)
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local Gameplay = MainGui and MainGui:FindFirstChild("Gameplay")
    local v1 = Gameplay and Gameplay:FindFirstChild("Middle")
    local v2 = v1 and v1:FindFirstChild("EndScreen")
    if not v2 then
        return
    end
    v2.Visible = false
    Halftime.Hide()
    local Victory = v2:FindFirstChild("Victory")
    if Victory then
        Victory.Visible = false
    end
    local Defeat = v2:FindFirstChild("Defeat")
    if Defeat then
        Defeat.Visible = false
    end
    local Level = v2:FindFirstChild("Level")
    if Level then
        Level.Visible = false
        local LevelBar = Level:FindFirstChild("LevelBar")
        if LevelBar then
            local Current = LevelBar:FindFirstChild("Current")
            if Current then
                Current:SetAttribute("SkipFade", nil)
            end
            local Earned = LevelBar:FindFirstChild("Earned")
            if Earned then
                Earned:SetAttribute("SkipFade", nil)
            end
        end
        local CurrentInfo = Level:FindFirstChild("CurrentInfo", true)
        if CurrentInfo then
            CurrentInfo:SetAttribute("SkipFade", nil)
        end
        local EarnedInfo = Level:FindFirstChild("EarnedInfo", true)
        if EarnedInfo then
            EarnedInfo:SetAttribute("SkipFade", nil)
        end
    end
    local MVP = v2:FindFirstChild("MVP")
    if MVP then
        MVP.Visible = false
        hideMvpSlots(MVP)
    end
    local Drops = v2:FindFirstChild("Drops")
    if Drops then
        Drops.Visible = false
        local Container = Drops:FindFirstChild("Container")
        if Container then
            Container:SetAttribute("SkipFade", nil)
            clearDropItems(Container)
        end
    end
    local MapVote = v2:FindFirstChild("MapVote")
    if MapVote then
        MapVote.Visible = true
    end
    local Top = v2:FindFirstChild("Top")
    if Top then
        Top.Visible = true
    end
end

local function getTeamLoadout(a1) -- Line: 1280
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = DataController.Get(LocalPlayer, "Loadout")
    if type(v1) ~= "table" then
        return nil
    end
    local v2 = v1[if a1 ~= "CT" then "Terrorists" else "Counter-Terrorists"]
    if type(v2) == "table" then
        return v2
    end
    return nil
end

local function getEquippedGloveId(a1) -- Line: 1290
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1
    local v2 = DataController.Get(LocalPlayer, "Loadout")
    if type(v2) == "table" then
        local v3 = v2[if a1 ~= "CT" then "Terrorists" else "Counter-Terrorists"]
        v1 = if type(v3) ~= "table" then nil else v3
    else
        v1 = nil
    end
    local Equipped = v1 and v1.Equipped and v1.Equipped["Equipped Gloves"]
    if type(Equipped) == "string" and Equipped ~= "" then
        return Equipped
    end
    return nil
end

local function findInventoryItem(a1) -- Line: 1299
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = DataController.Get(LocalPlayer, "Inventory")
    if type(v1) ~= "table" then
        return nil
    end
    for i, v in ipairs(v1) do
        if v and v._id == a1 then
            return v
        end
    end
    return nil
end

local function attachGlovesToCharacter(a1, a2, a3) -- Line: 1313
    -- upvalues: DataController (val), LocalPlayer (val), findInventoryItem (val), u162 (val), Skins (val)
    -- upvalues: ReplicatedStorage (val), AttachGlovesToCharacter (val)
    local CharacterArmor, v1, v2, v3
    local Name = nil
    local Skin = nil
    local Float = nil
    if not a3 then
        v3 = DataController.Get(LocalPlayer, "Loadout")
        if type(v3) == "table" then
            local v4 = v3[if a2 ~= "CT" then "Terrorists" else "Counter-Terrorists"]
            v2 = if type(v4) ~= "table" then nil else v4
        else
            v2 = nil
        end
        local Equipped = v2 and v2.Equipped and v2.Equipped["Equipped Gloves"]
        v1 = if type(Equipped) ~= "string" then nil else if Equipped == "" then nil else Equipped
        if v1 then
            v2 = findInventoryItem(v1)
            if v2 then
                Name = v2.Name
                Skin = v2.Skin
                Float = v2.Float
            end
        end
    else
        Name = a3.Name
        Skin = a3.Skin
        Float = a3.Float
    end
    local v5 = Name or u162[a2].Glove
    v1 = Skin and not (Skin == "") and not (Float == nil) and Skins.GetGloves(v5, Skin, Float) or nil
    if v1 then
        v2 = v1:GetChildren()
        CharacterArmor = a1:FindFirstChild("CharacterArmor") or Instance.new("Folder")
        CharacterArmor.Name = "CharacterArmor"
        CharacterArmor.Parent = a1
        AttachGlovesToCharacter(v2, a1, CharacterArmor)
        return
    end
    v3 = ReplicatedStorage.Assets.Weapons:FindFirstChild(v5)
    if not v3 then
        return
    end
    v2 = v3:GetChildren()
    CharacterArmor = a1:FindFirstChild("CharacterArmor") or Instance.new("Folder")
    CharacterArmor.Name = "CharacterArmor"
    CharacterArmor.Parent = a1
    AttachGlovesToCharacter(v2, a1, CharacterArmor)
end

local function getEquippedWeaponFromLoadout(a1, a2) -- Line: 1359
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1, v2
    local v3 = DataController.Get(LocalPlayer, "Loadout")
    if type(v3) == "table" then
        v2 = v3[if a1 ~= "CT" then "Terrorists" else "Counter-Terrorists"]
        v1 = if type(v2) ~= "table" then nil else v2
    else
        v1 = nil
    end
    local Loadout = v1 and v1.Loadout and v1.Loadout.Rifles
    if Loadout and type(Loadout.Options) == "table" then
        v2 = DataController.Get(LocalPlayer, "Inventory")
        if type(v2) ~= "table" then
            return nil
        end
        for i, v in ipairs(Loadout.Options) do
            if type(v) == "string" and v ~= "" then
                for i2, i3 in ipairs(v2) do
                    if i3 and i3._id == v and i3.Name == a2 then
                        return {
                            Skin = i3.Skin,
                            Float = i3.Float,
                            StatTrack = i3.StatTrack,
                            NameTag = i3.NameTag,
                        }
                    end
                end
            end
        end
        return nil
    end
    return nil
end

local function attachWeaponToCharacter(a1, a2, a3) -- Line: 1390
    -- upvalues: u162 (val), getEquippedWeaponFromLoadout (val), Skins (val), u146 (val)
    local Weapon = u162[a2].Weapon
    local v1 = nil
    local v2 = a3
    if not a3 or not a3.Skin or a3.Skin == "" then
        v2 = getEquippedWeaponFromLoadout(a2, Weapon)
    end
    if v2 and v2.Skin and v2.Skin ~= "" then
        v1 = Skins.GetCharacterModel(Weapon, v2.Skin, v2.Float, v2.StatTrack, v2.NameTag)
    end
    v1 = v1 or Skins.GetBaseWeaponModel(Weapon, "Character")
    if not v1 then
        return
    end
    v1.Name = Weapon
    local RightHand = a1:FindFirstChild("RightHand")
    if not RightHand then
        v1:Destroy()
        return
    end
    if not v1.PrimaryPart then
        local Weapon_2 = v1:FindFirstChild("Weapon")
        local Insert = Weapon_2 and Weapon_2:FindFirstChild("Insert")
        if not Insert then
            v1:Destroy()
            return
        end
        v1.PrimaryPart = Insert
    end
    for i, j in v1:GetDescendants() do
        if j:IsA("BasePart") then
            j.CanCollide = false
            j.CanQuery = false
            j.CanTouch = false
            j.Anchored = false
            j.Massless = true
        end
    end
    v1.Parent = a1
    local Motor6D = Instance.new("Motor6D")
    Motor6D.Name = "WeaponAttachment"
    Motor6D.Part0 = RightHand
    Motor6D.Part1 = v1.PrimaryPart
    Motor6D.Parent = RightHand
    if Weapon == "AK-47" then
        Motor6D.C0 = u146
        return
    end
    local Properties = v1:FindFirstChild("Properties")
    if Properties then
        local C0 = Properties:FindFirstChild("C0")
        local C1 = Properties:FindFirstChild("C1")
        if C0 then
            Motor6D.C0 = C0.Value
        end
        if C1 then
            Motor6D.C1 = C1.Value
        end
    end
end

local function calculateHSP(a1, a2) -- Line: 1470 -- types: a1: number?, a2: number?
    local v1 = a1 or 0
    if v1 <= 0 then
        return "0%"
    end
    return (("%*%%"):format((math.floor((a2 or 0) / v1 * 100))))
end

local function getEquippedBadgeIcon(a1, a2) -- Line: 1480
    -- upvalues: DataController (val), Skins (val)
    local v1, v2 = DataController.Get(a1, "Loadout", "Inventory")
    local v3 = v1 and v2 and v1[a2]
    local Equipped = v3 and v3.Equipped and v3.Equipped["Equipped Badge"]
    if Equipped and Equipped ~= "" then
        local v4
        for i, v in ipairs(v2) do
            if v._id == Equipped then
                v4 = Skins.GetSkinInformation(v.Name, v.Skin)
                return v4 and v4.imageAssetId or ""
            end
        end
        return ""
    end
    return ""
end

local function populateMVPFrame(a1) -- Line: 1497
    -- upvalues: PlayerGui (val), hideMvpSlots (val), u126 (val), Players (val), getEquippedBadgeIcon (val)
    local APR, Avatar, Category, HSP, KDA, Name, Pin, Player, PlayerByUserId, Score, Username, data, userId, v1, v2, v3, v4, v5
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local Gameplay = MainGui and MainGui:FindFirstChild("Gameplay")
    local v6 = Gameplay and Gameplay:FindFirstChild("Middle")
    local v7 = v6 and v6:FindFirstChild("EndScreen")
    if not v7 then
        return
    end
    local MVP = v7:FindFirstChild("MVP")
    if not MVP then
        return
    end
    hideMvpSlots(MVP)
    for i, v in ipairs(a1) do
        v5 = MVP:FindFirstChild((tostring(u126[i])))
        if v5 then
            data = v.data
            userId = v.userId
            v1 = tonumber(userId)
            PlayerByUserId = if not v1 then nil else Players:GetPlayerByUserId(v1)
            Name = data.Name or PlayerByUserId and PlayerByUserId.Name or ("Player_%*"):format(userId)
            Username = v5:FindFirstChild("Username")
            if Username then
                Username.Text = Name
            end
            v2 = ("%*-%*-%*"):format(data.Kills or 0, data.Deaths or 0, data.Assists or 0)
            KDA = v5:FindFirstChild("KDA")
            if KDA then
                KDA.Text = v2
            end
            v4 = data.Kills or 0
            v2 = if not (v4 <= 0) then ("%*%%"):format((math.floor((data.Headshots or 0) / v4 * 100))) else "0%"
            HSP = v5:FindFirstChild("HSP")
            if HSP then
                HSP.Text = v2
            end
            v2 = tostring((math.floor(data.ADR or 0)))
            APR = v5:FindFirstChild("APR")
            if APR then
                APR.Text = v2
            end
            Score = v5:FindFirstChild("Score")
            if not Score then
                for i2, j in v5:GetChildren() do
                    if j:IsA("TextLabel") and j.Name == "NameScore" and j.Text ~= "SCORE" then
                        Score = j
                        break
                    end
                end
            end
            if Score then
                Score.Text = tostring(data.Score or 0)
            end
            v3 = data.Accolade or "Participant"
            Category = v5:FindFirstChild("Category")
            if Category then
                Category.Text = v3
            end
            Player = v5:FindFirstChild("Player")
            if Player then
                Avatar = Player:FindFirstChild("Avatar")
                if Avatar then
                    Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(data.AvatarUserId or userId)
                end
            end
            Pin = v5:FindFirstChild("Pin")
            if Pin then
                v4 = if not PlayerByUserId then "" else if not data.Team then "" else getEquippedBadgeIcon(PlayerByUserId, data.Team)
                if v4 ~= "" then
                    Pin.Image = v4
                end
                Pin.Visible = v4 ~= ""
            end
            v5.Visible = true
        end
    end
end

local function positionCharacterOnGround(a1, a2, a3) -- Line: 1569 -- types: a1: userdata, a2: userdata, a3: userdata
    a1:PivotTo(a3.CFrame)
    local BoundingBox, BoundingBox_2 = a1:GetBoundingBox()
    local v1 = a2.Position.Y - (BoundingBox.Position.Y - BoundingBox_2.Y / 2)
    local v2 = RaycastParams.new()
    v2.FilterType = Enum.RaycastFilterType.Exclude
    v2.FilterDescendantsInstances = {a1, a3}
    v2.RespectCanCollide = true
    local v3 = a2.Position + Vector3.new(0, 16, 0)
    local v4 = workspace:Raycast(v3, Vector3.new(-0, -128, -0), v2)
    if not v4 then
        return false
    end
    local v5 = v4.Position.Y + v1 - a2.Position.Y
    a1:PivotTo((a1:GetPivot()) + (Vector3.new(0, v5, 0)))
    return true
end

local function playPodiumAnimation(a1, a2, a3, a4) -- Line: 1591
    -- upvalues: u169 (val)
    local Animation = Instance.new("Animation")
    Animation.AnimationId = a2
    local v1 = a1:LoadAnimation(Animation)
    v1.Looped = a3
    v1.Priority = a4
    v1:Play()
    u169:Add(Animation)
    u169:Add(v1)
end

local function spawnEndScreenCharacters(a1, a2) -- Line: 1609
    -- upvalues: populateMVPFrame (val), u126 (val), u165 (val), Characters (val), u162 (val), CharacterResolver (val)
    -- upvalues: positionCharacterOnGround (val), attachGlovesToCharacter (val), attachWeaponToCharacter (val)
    -- upvalues: u156 (val), playPodiumAnimation (val), u169 (val)
    local v1, v2, v3, v4, v5, v6, v7, v8
    local TutorialEndScreenScene = workspace:FindFirstChild("TutorialEndScreenScene")
    local EndScreen = TutorialEndScreenScene and TutorialEndScreenScene:FindFirstChild("EndScreen")
    local v9 = if not EndScreen then workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EndScreen") else EndScreen
    if not v9 then
        return {}
    end
    local v10 = {}
    for i = 1, (math.min(5, #a1)) do
        table.insert(v10, a1[i])
    end
    if a2 then
        populateMVPFrame(v10)
    end
    local v11 = {}
    for i2, v in ipairs(v10) do
        v1 = u126[i2]
        v2 = v9:FindFirstChild((tostring(v1)))
        if v2 then
            v3 = u165[v.data.Team]
            if v3 then
                v4 = Characters:FindFirstChild(u162[v3].Character)
                if v4 then
                    v5 = v4:Clone()
                    v5.Name = "EndScreenCharacter_" .. v.userId
                    v6 = CharacterResolver.getRootPart(v5)
                    if v6 then
                        v6.Anchored = true
                        if not positionCharacterOnGround(v5, v6, v2) then
                            warn((("[EndScreen] No ground found below position %*; using the position marker height"):format(v1)))
                        end
                        v5.Parent = v9
                        attachGlovesToCharacter(v5, v3, v.data.Gloves)
                        attachWeaponToCharacter(v5, v3, v.data.Weapon)
                        v7 = CharacterResolver.getOrCreateAnimator(v5)
                        v8 = u156[v1]
                        if v7 and v8 then
                            playPodiumAnimation(v7, v8.Entrance, false, Enum.AnimationPriority.Action)
                            playPodiumAnimation(v7, v8.Idle, true, Enum.AnimationPriority.Idle)
                        end
                        u169:Add(v5, "Destroy")
                        table.insert(v11, v5)
                    else
                        warn((("[EndScreen] Character template %* is missing a HumanoidRootPart"):format(v4.Name)))
                        v5:Destroy()
                    end
                end
            end
        end
    end
    return v11
end

local function animateCamera() -- Line: 1676
    -- upvalues: CurrentCamera (val), CameraController (val), TweenService (val)
    local TutorialEndScreenScene = workspace:FindFirstChild("TutorialEndScreenScene")
    local EndScreen = TutorialEndScreenScene and TutorialEndScreenScene:FindFirstChild("EndScreen")
    local v1 = if not EndScreen then workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EndScreen") else EndScreen
    if not v1 then
        return nil
    end
    local Start = v1:FindFirstChild("Start")
    local End = v1:FindFirstChild("End")
    if Start and End then
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CFrame = Start.CFrame
        CurrentCamera.Focus = Start.CFrame
        CurrentCamera.FieldOfView = 60
        CameraController.setMouseEnabled(true)
        local v2 = TweenService:Create(CurrentCamera, TweenInfo.new(14, Enum.EasingStyle.Linear), {CFrame = End.CFrame})
        v2:Play()
        return v2
    end
    warn("[EndScreen] Missing Start or End part!")
    return nil
end

local function closeAllActiveScenes() -- Line: 1707
    -- upvalues: MenuState (val), Router (val), PlayerGui (val), CameraController (val), ReplicatedStorage (val)
    MenuState.SetBlurEnabled(false)
    if MenuState.IsCaseSceneActive() then
        Router.broadcastRouter("CaseSceneCloseForGameEnd")
    end
    if MenuState.IsInspectActive() then
        Router.broadcastRouter("WeaponInspectCloseForGameEnd")
    end
    if MenuState.IsTradeUpActive() then
        return
    end
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local Menu = MainGui and MainGui:FindFirstChild("Menu")
    if Menu then
        if Menu.Visible then
            MenuState.HideMenu()
            CameraController.setForceLockOverride("Menu", false)
        end
        Menu.BackgroundTransparency = 1
    end
    local MainGui_2 = PlayerGui:FindFirstChild("MainGui")
    local Gameplay = MainGui_2 and MainGui_2:FindFirstChild("Gameplay")
    local v1 = Gameplay and Gameplay:FindFirstChild("Middle")
    if not v1 then
        return
    end
    local BuyMenu = v1:FindFirstChild("BuyMenu")
    if BuyMenu and BuyMenu.Visible then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu).closeFrame()
    end
    local TeamSelection = v1:FindFirstChild("TeamSelection")
    if TeamSelection and TeamSelection.Visible then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection).closeFrame()
    end
end

function u0.IsActive() -- Line: 1755 -- upvalues: u170 (ref)
    return u170
end

local function cacheLevelData(a1) -- Line: 1759 -- upvalues: u176 (ref)
    if a1 then
        u176 = {
            Level = a1.Level,
            Experience = a1.Experience,
            NextExperienceRequirement = a1.NextExperienceRequirement,
        }
    end
end

local function showMainMenuAfterEndScreen() -- Line: 1769
    -- upvalues: ReplicatedStorage (val), PlayerGui (val), CameraController (val)
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
    local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top)
    MenuSceneController.ShowMenuScene()
    Top.ResetToMainMenu()
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    if not MainGui then
        return
    end
    CameraController.setForceLockOverride("Menu", true)
    CameraController.setPerspective(true, true)
    MainGui.Menu.Visible = true
    MainGui.Gameplay.Visible = false
    MainGui.Gameplay.Bottom.Visible = false
end

function u0.ExitMapVoteToMenu() -- Line: 1789
    -- upvalues: u171 (ref), MenuState (val), u170 (ref), u0 (val), CameraController (val), hideEndScreenUI (val)
    -- upvalues: showMainMenuAfterEndScreen (val), u175 (ref), u173 (ref)
    if u171 then
        return
    end
    MenuState.SetWantsMainMenu(true)
    if u170 then
        u0._finishSequence(true)
        return
    end
    CameraController.setForceLockOverride("EndScreen", false)
    hideEndScreenUI()
    CameraController.SetEnabled(true)
    showMainMenuAfterEndScreen()
    u175 = nil
    u173 = true
end

function u0._runSequence(a1) -- Line: 1808
    -- upvalues: u172 (ref), u173 (ref), u174 (ref), u171 (ref), cleanupDebris (val), showEndScreenUI (val)
    -- upvalues: PlayerGui (val), spawnEndScreenCharacters (val), animateCamera (val), u169 (val)
    -- upvalues: populateLevelFrame (val), fadeFrame (val), fadeInFrame (val), animateLevelBar (val), displayDrops (val)
    -- upvalues: u0 (val)
    u172 = u172 + 1
    local u3 = u172
    u173 = a1.returnToMenu
    u174 = a1.overlayMode
    u171 = a1.locked
    cleanupDebris()
    showEndScreenUI(a1)
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local Gameplay = MainGui and MainGui:FindFirstChild("Gameplay")
    local v1 = Gameplay and Gameplay:FindFirstChild("Middle")
    local v2 = v1 and v1:FindFirstChild("EndScreen")
    local Close = v2 and v2:FindFirstChild("Close")
    if Close then
        Close.Visible = not a1.locked
    end
    local success, result = pcall(spawnEndScreenCharacters, a1.displayPlayers, a1.showAccolades)
    if not success then
        warn((("[EndScreen] Podium failed: %*"):format(result)))
    end
    local v3 = animateCamera()
    if v3 then
        u169:Add(v3, "Cancel")
    end
    if a1.showProgression then
        task.delay(4, function() -- Line: 1837
            -- upvalues: u3 (val), u172 (upval), PlayerGui (upval), populateLevelFrame (upval), a1 (val)
            -- upvalues: fadeFrame (upval), fadeInFrame (upval), animateLevelBar (upval), displayDrops (upval)
            if u3 ~= u172 then
                return
            end
            local MainGui = PlayerGui:FindFirstChild("MainGui")
            local Gameplay = MainGui and MainGui:FindFirstChild("Gameplay")
            local v1 = Gameplay and Gameplay:FindFirstChild("Middle")
            local v2 = v1 and v1:FindFirstChild("EndScreen")
            if not v2 then
                return
            end
            local Victory = v2:FindFirstChild("Victory")
            local Defeat = v2:FindFirstChild("Defeat")
            local Level = v2:FindFirstChild("Level")
            local u42 = populateLevelFrame(a1.xpEarned)
            local v3 = a1.isDraw and Victory or a1.didWin and Victory or Defeat
            if v3 and v3.Visible then
                fadeFrame(v3, 1)
            end
            task.delay(0.5, function() -- Line: 1858
                -- upvalues: u3 (upval), u172 (upval), Victory (val), Defeat (val), Level (val), fadeInFrame (upval)
                -- upvalues: u42 (val), animateLevelBar (upval), displayDrops (upval), a1 (upval)
                if u3 ~= u172 then
                    return
                end
                if Victory then
                    Victory.Visible = false
                end
                if Defeat then
                    Defeat.Visible = false
                end
                if Level then
                    fadeInFrame(Level)
                    task.spawn(function() -- Line: 1873 -- upvalues: u42 (upval), animateLevelBar (upval), displayDrops (upval), a1 (upval)
                        if u42 then
                            animateLevelBar(u42)
                        end
                        displayDrops(a1.levelRewards)
                    end)
                end
            end)
        end)
    end
    if a1.locked then
        return
    end
    task.delay(a1.sequenceDuration or (if not a1.showProgression then 4 else 14), function() -- Line: 1891 -- upvalues: u3 (val), u172 (upval), u0 (upval), a1 (val)
        if u3 ~= u172 then
            return
        end
        u0._finishSequence(a1.returnToMenu)
    end)
end

function u0._finishSequence(a1) -- Line: 1899
    -- upvalues: u171 (ref), u173 (ref), u172 (ref), u174 (ref), u170 (ref), CameraController (val), u169 (val)
    -- upvalues: hideEndScreenUI (val), PlayerGui (val), u175 (ref), restoreVisibilitySnapshot (val), MenuState (val)
    -- upvalues: showMainMenuAfterEndScreen (val), DataController (val), LocalPlayer (val), u176 (ref)
    if u171 then
        return
    end
    local v1 = if a1 ~= nil then a1 else u173
    if typeof(v1) ~= "boolean" then
        v1 = if not v1 then u173 else true
    end
    u172 = u172 + 1
    u174 = "EndScreen"
    u170 = false
    CameraController.setForceLockOverride("EndScreen", false)
    u169:Cleanup()
    hideEndScreenUI()
    CameraController.SetEnabled(true)
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    if v1 or not MainGui or not u175 then
        showMainMenuAfterEndScreen()
        u175 = nil
        u173 = true
    else
        restoreVisibilitySnapshot(MainGui, true)
        MenuState.HideMenu()
        MainGui.Gameplay.Visible = true
        CameraController.setPerspective(true, false)
    end
    local v2 = DataController.Get(LocalPlayer, "Level")
    if v2 then
        u176 = {
            Level = v2.Level,
            Experience = v2.Experience,
            NextExperienceRequirement = v2.NextExperienceRequirement,
        }
    end
end

function u0.Begin(a1) -- Line: 1937
    -- upvalues: u171 (ref), u170 (ref), u0 (val), MenuState (val), Router (val), LocalPlayer (val), IsPlayingTeam (val)
    -- upvalues: collectPlayingPlayers (val), u132 (val), closeAllActiveScenes (val), SpectateController (val)
    -- upvalues: CameraController (val)
    local LevelRewards, Team, _runSequence, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
    if u171 then
        return
    end
    local v11 = if a1.Halftime ~= true then "EndScreen" else "Halftime"
    if u170 then
        warn("[EndScreen] Interrupting active sequence for new end screen")
        local success, result = pcall(u0._finishSequence, false)
        if not success then
            warn("[EndScreen] _finishSequence error during interrupt: " .. tostring(result))
        end
        u170 = false
    end
    if MenuState.IsTradeUpActive() then
        return
    end
    if MenuState.IsCaseSceneActive() and Router.broadcastRouter("IsCaseSceneRolling") == true then
        return
    end
    local v12 = workspace:GetAttribute("Gamemode") == "Deathmatch"
    local v13 = a1.Players and a1.Players[tostring(LocalPlayer.UserId)] or nil
    if v13 then
        Team = v13 and v13.Team or LocalPlayer:GetAttribute("Team")
        v6 = a1.WinningTeam == "Draw"
        v8 = nil
        if v12 then
            if v13 and IsPlayingTeam(v13.Team) then
                v10 = collectPlayingPlayers(a1.Players)
                table.sort(v10, function(a1, a2) -- Line: 257
                    local v1
                    if (a1.data.Score or 0) ~= (a2.data.Score or 0) then
                        v1 = a1.data.Score or 0
                        return (a2.data.Score or 0) < v1
                    end
                    if (a1.data.Kills or 0) ~= (a2.data.Kills or 0) then
                        v1 = a1.data.Kills or 0
                        return (a2.data.Kills or 0) < v1
                    end
                    if (a1.data.Assists or 0) == (a2.data.Assists or 0) then
                        return (tonumber(a1.userId) or (1 / 0)) < (tonumber(a2.userId) or (1 / 0))
                    end
                    v1 = a1.data.Assists or 0
                    return (a2.data.Assists or 0) < v1
                end)
                if #v10 == 0 then
                    warn("[EndScreen] Begin skipped for Deathmatch: no eligible ranked players")
                    return
                end
                v2 = nil
                for i9, i82 in ipairs(v10) do
                    if i82.userId == tostring(LocalPlayer.UserId) then
                        v2 = i9
                        break
                    end
                end
                if not v2 then
                    warn(("[EndScreen] Begin skipped for Deathmatch: local player missing from ranked list (userId=%s)"):format((tostring(LocalPlayer.UserId))))
                    return
                end
                v7 = v2 == 1
                v4 = v2 % 100
                v8 = ("You placed %*"):format((("%*%*"):format(v2, if not (v4 >= 11) then u132[v2 % 10] or "th" else not (v4 <= 13) and u132[v2 % 10] or "th")))
                v9 = v10
                closeAllActiveScenes()
                SpectateController.Stop(false, true)
                CameraController.SetEnabled(false)
                u170 = true
                v10 = {}
                for k7 in pairs(a1.Players) do
                    v4 = tonumber(k7)
                    if v4 then
                        table.insert(v10, v4)
                    end
                end
                table.sort(v10)
                v2 = {}
                v1 = a1
                for i10, i92 in ipairs(v10) do
                    v5 = v1.Players[tostring(i92)]
                    LevelRewards = v5 and v5.LevelRewards
                    if LevelRewards then
                        for i11, i102 in ipairs(LevelRewards) do
                            table.insert(v2, {userId = i92, reward = i102})
                        end
                    end
                end
                _runSequence = u0._runSequence
                v3 = {
                    displayPlayers = v9,
                    didWin = v7,
                    isDraw = v6,
                    winningTeam = v1.WinningTeam,
                }
                v3.xpEarned = v13 and v13.ExperienceEarned or 0
                v3.levelRewards = v2
                v3.ctScore = v1.CTScore or 0
                v3.tScore = v1.TScore or 0
                v3.scoreTextOverride = v8
                v3.showAccolades = v1.ShowAccolades ~= false
                v3.showProgression = v1.ShowProgression ~= false
                v3.sequenceDuration = v1.SequenceDuration
                v3.returnToMenu = v1.ReturnToMenu ~= false
                v3.overlayMode = v11
                v3.halftimeTeam = Team
                v3.locked = v1.Locked == true
                _runSequence(v3)
                return
            end
            warn(("[EndScreen] Begin skipped for Deathmatch: invalid team data (team=%s)"):format((tostring(v13 and v13.Team))))
            return
        end
        if not IsPlayingTeam(Team) then
            warn(("[EndScreen] Begin skipped: invalid team (team=%s, teamAttr=%s, winningTeam=%s)"):format(
                tostring(Team),
                tostring((LocalPlayer:GetAttribute("Team"))),
                (tostring(a1.WinningTeam))
            ))
            return
        end
        v7 = not v6 and a1.WinningTeam == Team
        v10 = {}
        for k5, i52 in pairs(a1.Players) do
            if i52.Team == Team then
                v10[k5] = i52
            end
        end
        v9 = collectPlayingPlayers(v10)
        table.sort(v9, function(a1, a2) -- Line: 240
            local v1
            if (a1.data.ADR or 0) ~= (a2.data.ADR or 0) then
                v1 = a1.data.ADR or 0
                return (a2.data.ADR or 0) < v1
            end
            if (a1.data.Score or 0) == (a2.data.Score or 0) then
                return (tonumber(a1.userId) or (1 / 0)) < (tonumber(a2.userId) or (1 / 0))
            end
            v1 = a1.data.Score or 0
            return (a2.data.Score or 0) < v1
        end)
        closeAllActiveScenes()
        SpectateController.Stop(false, true)
        CameraController.SetEnabled(false)
        u170 = true
        v10 = {}
        for k6 in pairs(a1.Players) do
            v4 = tonumber(k6)
            if v4 then
                table.insert(v10, v4)
            end
        end
        table.sort(v10)
        v2 = {}
        v1 = a1
        for i7, i62 in ipairs(v10) do
            v5 = v1.Players[tostring(i62)]
            LevelRewards = v5 and v5.LevelRewards
            if LevelRewards then
                for i8, i72 in ipairs(LevelRewards) do
                    table.insert(v2, {userId = i62, reward = i72})
                end
            end
        end
        _runSequence = u0._runSequence
        v3 = {displayPlayers = v9, didWin = v7, isDraw = v6, winningTeam = v1.WinningTeam}
        v3.xpEarned = v13 and v13.ExperienceEarned or 0
        v3.levelRewards = v2
        v3.ctScore = v1.CTScore or 0
        v3.tScore = v1.TScore or 0
        v3.scoreTextOverride = v8
        v3.showAccolades = v1.ShowAccolades ~= false
        v3.showProgression = v1.ShowProgression ~= false
        v3.sequenceDuration = v1.SequenceDuration
        v3.returnToMenu = v1.ReturnToMenu ~= false
        v3.overlayMode = v11
        v3.halftimeTeam = Team
        v3.locked = v1.Locked == true
        _runSequence(v3)
        return
    end
    warn(("[EndScreen] Local player missing from payload (userId=%s, teamAttr=%s, winningTeam=%s)"):format(
        tostring(LocalPlayer.UserId),
        tostring((LocalPlayer:GetAttribute("Team"))),
        (tostring(a1.WinningTeam))
    ))
    if IsPlayingTeam(LocalPlayer:GetAttribute("Team")) and not v12 then
        Team = v13 and v13.Team or LocalPlayer:GetAttribute("Team")
        v6 = a1.WinningTeam == "Draw"
        if not v12 then
            if not IsPlayingTeam(Team) then
                warn(("[EndScreen] Begin skipped: invalid team (team=%s, teamAttr=%s, winningTeam=%s)"):format(
                    tostring(Team),
                    tostring((LocalPlayer:GetAttribute("Team"))),
                    (tostring(a1.WinningTeam))
                ))
                return
            end
            v7 = not v6 and a1.WinningTeam == Team
            v10 = {}
            for k, v in pairs(a1.Players) do
                if v.Team == Team then
                    v10[k] = v
                end
            end
            v9 = collectPlayingPlayers(v10)
            table.sort(v9, function(a1, a2) -- Line: 240
                local v1
                if (a1.data.ADR or 0) ~= (a2.data.ADR or 0) then
                    v1 = a1.data.ADR or 0
                    return (a2.data.ADR or 0) < v1
                end
                if (a1.data.Score or 0) == (a2.data.Score or 0) then
                    return (tonumber(a1.userId) or (1 / 0)) < (tonumber(a2.userId) or (1 / 0))
                end
                v1 = a1.data.Score or 0
                return (a2.data.Score or 0) < v1
            end)
            closeAllActiveScenes()
            SpectateController.Stop(false, true)
            CameraController.SetEnabled(false)
            u170 = true
            v10 = {}
            for k2 in pairs(a1.Players) do
                v4 = tonumber(k2)
                if v4 then
                    table.insert(v10, v4)
                end
            end
            table.sort(v10)
            v2 = {}
            v1 = a1
            for i, i2 in ipairs(v10) do
                v5 = v1.Players[tostring(i2)]
                LevelRewards = v5 and v5.LevelRewards
                if LevelRewards then
                    for i3, j in ipairs(LevelRewards) do
                        table.insert(v2, {userId = i2, reward = j})
                    end
                end
            end
            _runSequence = u0._runSequence
            v3 = {displayPlayers = v9, didWin = v7, isDraw = v6, winningTeam = v1.WinningTeam}
            v3.xpEarned = v13 and v13.ExperienceEarned or 0
            v3.levelRewards = v2
            v3.ctScore = v1.CTScore or 0
            v3.tScore = v1.TScore or 0
            v3.scoreTextOverride = nil
            v3.showAccolades = v1.ShowAccolades ~= false
            v3.showProgression = v1.ShowProgression ~= false
            v3.sequenceDuration = v1.SequenceDuration
            v3.returnToMenu = v1.ReturnToMenu ~= false
            v3.overlayMode = v11
            v3.halftimeTeam = Team
            v3.locked = v1.Locked == true
            _runSequence(v3)
            return
        end
        if v13 and IsPlayingTeam(v13.Team) then
            v10 = collectPlayingPlayers(a1.Players)
            table.sort(v10, function(a1, a2) -- Line: 257
                local v1
                if (a1.data.Score or 0) ~= (a2.data.Score or 0) then
                    v1 = a1.data.Score or 0
                    return (a2.data.Score or 0) < v1
                end
                if (a1.data.Kills or 0) ~= (a2.data.Kills or 0) then
                    v1 = a1.data.Kills or 0
                    return (a2.data.Kills or 0) < v1
                end
                if (a1.data.Assists or 0) == (a2.data.Assists or 0) then
                    return (tonumber(a1.userId) or (1 / 0)) < (tonumber(a2.userId) or (1 / 0))
                end
                v1 = a1.data.Assists or 0
                return (a2.data.Assists or 0) < v1
            end)
            if #v10 == 0 then
                warn("[EndScreen] Begin skipped for Deathmatch: no eligible ranked players")
                return
            end
            v2 = nil
            for i4, k3 in ipairs(v10) do
                if k3.userId == tostring(LocalPlayer.UserId) then
                    v2 = i4
                    break
                end
            end
            if not v2 then
                warn(("[EndScreen] Begin skipped for Deathmatch: local player missing from ranked list (userId=%s)"):format((tostring(LocalPlayer.UserId))))
                return
            end
            v7 = v2 == 1
            v4 = v2 % 100
            v8 = ("You placed %*"):format((("%*%*"):format(v2, if not (v4 >= 11) then u132[v2 % 10] or "th" else not (v4 <= 13) and u132[v2 % 10] or "th")))
            v9 = v10
            closeAllActiveScenes()
            SpectateController.Stop(false, true)
            CameraController.SetEnabled(false)
            u170 = true
            v10 = {}
            for k4 in pairs(a1.Players) do
                v4 = tonumber(k4)
                if v4 then
                    table.insert(v10, v4)
                end
            end
            table.sort(v10)
            v2 = {}
            v1 = a1
            for i5, n in ipairs(v10) do
                v5 = v1.Players[tostring(n)]
                LevelRewards = v5 and v5.LevelRewards
                if LevelRewards then
                    for i6, m in ipairs(LevelRewards) do
                        table.insert(v2, {userId = n, reward = m})
                    end
                end
            end
            _runSequence = u0._runSequence
            v3 = {displayPlayers = v9, didWin = v7, isDraw = v6, winningTeam = v1.WinningTeam}
            v3.xpEarned = v13 and v13.ExperienceEarned or 0
            v3.levelRewards = v2
            v3.ctScore = v1.CTScore or 0
            v3.tScore = v1.TScore or 0
            v3.scoreTextOverride = v8
            v3.showAccolades = v1.ShowAccolades ~= false
            v3.showProgression = v1.ShowProgression ~= false
            v3.sequenceDuration = v1.SequenceDuration
            v3.returnToMenu = v1.ReturnToMenu ~= false
            v3.overlayMode = v11
            v3.halftimeTeam = Team
            v3.locked = v1.Locked == true
            _runSequence(v3)
            return
        end
        warn(("[EndScreen] Begin skipped for Deathmatch: invalid team data (team=%s)"):format((tostring(v13 and v13.Team))))
        return
    end
end

function u0.Initialize() -- Line: 2099
    -- upvalues: PlayerGui (val), ActivateButton (val), CloseButtonRegistry (val), u170 (ref), MenuState (val), u0 (val)
    -- upvalues: GameState (val), DataController (val), LocalPlayer (val), u176 (ref), Remotes (val)
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local Gameplay = MainGui and MainGui:FindFirstChild("Gameplay")
    local v1 = Gameplay and Gameplay:FindFirstChild("Middle")
    local v2 = v1 and v1:FindFirstChild("EndScreen")
    if v2 then
        local Drops = v2:FindFirstChild("Drops")
        if Drops then
            Drops.Visible = false
        end
        local Close = v2:FindFirstChild("Close")
        if Close then
            ActivateButton(Close)
            CloseButtonRegistry.Add(v2, Close, function() -- Line: 2111 -- upvalues: u170 (upval), MenuState (upval), u0 (upval), GameState (upval)
                if u170 then
                    MenuState.SetWantsMainMenu(true)
                    u0._finishSequence(true)
                    return
                end
                if GameState.GetState() == "Map Voting" then
                    u0.ExitMapVoteToMenu()
                end
            end)
        end
    end
    DataController.CreateListener(LocalPlayer, "Level", function(a1) -- Line: 2124 -- upvalues: u176 (upval)
        if u176 == nil and a1 then
            u176 = {
                Level = a1.Level,
                Experience = a1.Experience,
                NextExperienceRequirement = a1.NextExperienceRequirement,
            }
        end
    end)
    Remotes.Match.EndScreen.Listen(function(a1) -- Line: 2130 -- upvalues: u0 (upval) -- types: a1: table
        u0.Begin(a1)
    end)
end

return u0