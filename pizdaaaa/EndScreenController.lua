-- ReplicatedStorage.Controllers.EndScreenController
-- Script path: ReplicatedStorage.Controllers.EndScreenController
-- Decompile time: 41.05 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local LevelsIcon = require(ReplicatedStorage.Database.Custom.GameStats.LevelsIcon);
local Sound = require(ReplicatedStorage.Classes.Sound);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetRankTitle = require(ReplicatedStorage.Components.Common.GetRankTitle);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation);
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam);
local AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter);
local Halftime = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Halftime);
local EndScreenTiming = require(ReplicatedStorage.Components.Common.EndScreenTiming);
local CatmullRomPath = require(ReplicatedStorage.Components.Common.CatmullRomPath);
local UDim2_fromScale_ret = UDim2.fromScale(0.5, 0.62);
local u2 = {
    GuiObject = { "BackgroundTransparency" },
    TextLabel = { "TextTransparency", "TextStrokeTransparency" },
    TextButton = { "TextTransparency", "TextStrokeTransparency" },
    ImageLabel = { "ImageTransparency" },
    ImageButton = { "ImageTransparency" },
    ScrollingFrame = { "ScrollBarImageTransparency" },
    UIStroke = { "Transparency" }
};
local u3 = { 3, 2, 4, 1, 5 };
local u4 = { "st", "nd", "rd" };
local u5 = CFrame.new(-0.251, 0.806, -0.406) * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local workspace_CurrentCamera = workspace.CurrentCamera;
local Characters = ReplicatedStorage.Assets.Characters;
local u6 = { {
        Entrance = "rbxassetid://100747011940776",
        Idle = "rbxassetid://100747011940776"
    }, {
        Entrance = "rbxassetid://103701913618746",
        Idle = "rbxassetid://100955283476946"
    }, {
        Entrance = "rbxassetid://91396952135880",
        Idle = "rbxassetid://120200138438261"
    }, {
        Entrance = "rbxassetid://136102955582599",
        Idle = "rbxassetid://74544097369437"
    }, {
        Entrance = "rbxassetid://71439100344953",
        Idle = "rbxassetid://122693948164334"
    } };
local u7 = {
    CT = {
        Character = "IDF",
        Weapon = "M4A1-S",
        Glove = "CT Glove"
    },
    T = {
        Character = "Anarchist",
        Weapon = "AK-47",
        Glove = "T Glove"
    }
};
local u8 = {
    ["Counter-Terrorists"] = "CT",
    Terrorists = "T"
};
local u9 = Janitor.new();
local u10 = false;
local u11 = false;
local u12 = 0;
local u13 = true;
local u14 = "EndScreen";
local u15 = nil;
local u16 = nil;
local u17 = {
    RoundWonCT = true,
    RoundWonT = true,
    RoundLost = true,
    PlayerMVPCT = true,
    PlayerMVPT = true,
    MissionCompleted = true
};
local u18 = {
    MobileButtons = true
};

local function getOrdinalPlacementText(p19: number) -- Line: 264
    -- upvalues: u4 (copy)
    local v20 = p19 % 100;

    return `{p19}{v20 >= 11 and v20 <= 13 and "th" or (u4[p19 % 10] or "th")}`;
end;

local function collectPlayingPlayers(p21: table) -- Line: 270
    -- upvalues: IsPlayingTeam (copy)
    local v22 = {};

    for i, v in pairs(p21) do
        if IsPlayingTeam(v.Team) then
            table.insert(v22, {
                userId = i,
                data = v
            });
        end;
    end;

    return v22;
end;

local function sortPlayersByADR(p23: table) -- Line: 280
    -- upvalues: collectPlayingPlayers (copy)
    local v24 = collectPlayingPlayers(p23);
    table.sort(v24, function(p25, p26) -- Line: 282
        if (p25.data.ADR or 0) ~= (p26.data.ADR or 0) then
            return (p25.data.ADR or 0) > (p26.data.ADR or 0);
        end;

        if (p25.data.Score or 0) == (p26.data.Score or 0) then
            return (tonumber(p25.userId) or (1 / 0)) < (tonumber(p26.userId) or (1 / 0));
        end;

        return (p25.data.Score or 0) > (p26.data.Score or 0);
    end);

    return v24;
end;

local function rankFFAPlayers(p27: table) -- Line: 297
    -- upvalues: collectPlayingPlayers (copy)
    local v28 = collectPlayingPlayers(p27);
    table.sort(v28, function(p29, p30) -- Line: 299
        if (p29.data.Score or 0) ~= (p30.data.Score or 0) then
            return (p29.data.Score or 0) > (p30.data.Score or 0);
        end;

        if (p29.data.Kills or 0) ~= (p30.data.Kills or 0) then
            return (p29.data.Kills or 0) > (p30.data.Kills or 0);
        end;

        if (p29.data.Assists or 0) == (p30.data.Assists or 0) then
            return (tonumber(p29.userId) or (1 / 0)) < (tonumber(p30.userId) or (1 / 0));
        end;

        return (p29.data.Assists or 0) > (p30.data.Assists or 0);
    end);

    return v28;
end;

local function cleanupDebris() -- Line: 317
    -- upvalues: Players (copy), ClientCharacterPresentation (copy)
    local Debris = workspace:FindFirstChild("Debris");

    if Debris then
        for _, child in Debris:GetChildren() do
            child:Destroy();
        end;
    end;

    for _, v in Players:GetPlayers() do
        ClientCharacterPresentation.Release(v, v.Character);
    end;
end;

local function getMiddleFrame() -- Line: 332
    -- upvalues: PlayerGui (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Gameplay");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Middle");
    end;

    return MainGui;
end;

local function getEndScreenFrame() -- Line: 338
    -- upvalues: PlayerGui (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Gameplay");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Middle");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("EndScreen");
    end;

    return MainGui;
end;

local function getEndScreenModel() -- Line: 343
    local TutorialEndScreenScene = workspace:FindFirstChild("TutorialEndScreenScene");

    if TutorialEndScreenScene then
        TutorialEndScreenScene = TutorialEndScreenScene:FindFirstChild("EndScreen");
    end;

    if TutorialEndScreenScene then
        return TutorialEndScreenScene;
    end;

    local v31 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EndScreen");

    return v31;
end;

local function isPanel(p32: userdata) -- Line: 353
    return p32:IsA("Frame") or p32:IsA("CanvasGroup");
end;

local function setChildVisible(p33: userdata, p34: string, p35: boolean) -- Line: 357
    local v36 = p33:FindFirstChild(p34);

    if v36 then
        v36.Visible = p35;
    end;
end;

local function getTransparencyProperty(p37: userdata) -- Line: 364
    return (p37:IsA("TextLabel") or p37:IsA("TextButton")) and "TextTransparency" or ((p37:IsA("ImageLabel") or p37:IsA("ImageButton")) and "ImageTransparency" or (p37:IsA("Frame") and "BackgroundTransparency" or (p37:IsA("UIStroke") and "Transparency" or nil)));
end;

local function setElementTransparency(p38: userdata, p39: number) -- Line: 377
    -- upvalues: getTransparencyProperty (copy)
    local v40 = getTransparencyProperty(p38);

    if v40 then
        p38[v40] = p39;
    end;
end;

local function tweenElementTransparency(p41: userdata, p42: number) -- Line: 384
    -- upvalues: getTransparencyProperty (copy), TweenService (copy)
    local v43 = getTransparencyProperty(p41);

    if v43 then
        TweenService:Create(p41, TweenInfo.new(0.5), {
            [v43] = p42
        }):Play();
    end;
end;

local function shouldSkipFade(p44: userdata) -- Line: 391
    if p44:GetAttribute("SkipFade") then
        return true;
    end;

    local Parent = p44.Parent;

    while Parent and Parent:IsA("GuiObject") do
        if Parent:GetAttribute("SkipFade") then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function fadeFrame(p45: userdata, p46: number) -- Line: 405
    -- upvalues: shouldSkipFade (copy), TweenService (copy), tweenElementTransparency (copy)
    local v47;

    if shouldSkipFade(p45) then
        v47 = nil;
    else
        v47 = TweenService:Create(p45, TweenInfo.new(0.5), {
            BackgroundTransparency = p46
        });
    end;

    for _, descendant in p45:GetDescendants() do
        if not shouldSkipFade(descendant) then
            tweenElementTransparency(descendant, p46);
        end;
    end;

    if v47 then
        v47:Play();
    end;

    return v47;
end;

local function fadeInFrame(p48: userdata) -- Line: 425
    -- upvalues: shouldSkipFade (copy), getTransparencyProperty (copy), fadeFrame (copy)
    if not shouldSkipFade(p48) then
        p48.BackgroundTransparency = 1;
    end;

    for _, descendant in p48:GetDescendants() do
        if not shouldSkipFade(descendant) then
            local v49 = getTransparencyProperty(descendant);

            if v49 then
                descendant[v49] = 1;
            end;
        end;
    end;

    p48.Visible = true;

    return fadeFrame(p48, 0);
end;

local function getBarTweenInfo(p50: boolean?) -- Line: 446
    return TweenInfo.new(p50 and 0.375 or 0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
end;

local function playInterfaceSound(p51: string, p52: number?) -- Line: 451
    -- upvalues: Sound (copy), workspace_CurrentCamera (copy)
    local v53 = Sound.new("Interface"):play({
        Parent = workspace_CurrentCamera,
        Name = p51
    });

    if v53 and p52 then
        v53.PlaybackSpeed = p52;
    end;
end;

local function createBarSize(p54: number, p55) -- Line: 478
    return UDim2.new(p54, 0, p55.Scale, p55.Offset);
end;

local function setChildText(p56: userdata, p57: string, p58: string) -- Line: 482
    local v59 = p56:FindFirstChild(p57);

    if v59 then
        v59.Text = p58;
    end;
end;

local function storeFrameTransparency(p60: userdata) -- Line: 494
    local v61 = {};

    for _, descendant in p60:GetDescendants() do
        if descendant:IsA("UIStroke") then
            v61[descendant] = descendant.Transparency;
        end;
    end;

    return {
        BackgroundTransparency = p60.BackgroundTransparency,
        Strokes = v61
    };
end;

local function restoreFrameTransparency(p62: userdata, p63: table) -- Line: 507
    p62.BackgroundTransparency = p63.BackgroundTransparency;

    for i, v in pairs(p63.Strokes) do
        if i and i.Parent then
            i.Transparency = v;
        end;
    end;
end;

local function setRankDisplay(p64: userdata, p65: number) -- Line: 516
    -- upvalues: GetRankTitle (copy), LevelsIcon (copy)
    local v66 = `[{GetRankTitle(p65)} Rank {p65}]`;
    local TextLabel = p64:FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = v66;
    end;

    local Rank = p64:FindFirstChild("Rank");

    if Rank then
        Rank.Image = LevelsIcon[tostring(p65)] or "";
    end;
end;

local function populateLevelFrame(p67: number) -- Line: 525
    -- upvalues: PlayerGui (copy), u16 (ref), DataController (copy), LocalPlayer (copy), GetRankTitle (copy), LevelsIcon (copy), storeFrameTransparency (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Gameplay");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Middle");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("EndScreen");
    end;

    if not MainGui then
        return nil;
    end;

    local Level = MainGui:FindFirstChild("Level");

    if not Level then
        return nil;
    end;

    local v68 = u16 or DataController.Get(LocalPlayer, "Level");

    if not v68 then
        return nil;
    end;

    local v69 = v68.Level or 1;
    local v70 = v68.Experience or 0;
    local v71 = v68.NextExperienceRequirement or 1000;
    local v72 = `[{GetRankTitle(v69)} Rank {v69}]`;
    local TextLabel = Level:FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = v72;
    end;

    local Rank = Level:FindFirstChild("Rank");

    if Rank then
        Rank.Image = LevelsIcon[tostring(v69)] or "";
    end;

    local LevelBar = Level:FindFirstChild("LevelBar");

    if not LevelBar then
        return nil;
    end;

    local Current = LevelBar:FindFirstChild("Current");
    local Earned = LevelBar:FindFirstChild("Earned");

    if not (Current and Earned) then
        return nil;
    end;

    local CurrentInfo = Level:FindFirstChild("CurrentInfo", true);
    local EarnedInfo = Level:FindFirstChild("EarnedInfo", true);

    if not (CurrentInfo and EarnedInfo) then
        return nil;
    end;

    for _, v in {
        Current,
        Earned,
        CurrentInfo,
        EarnedInfo
    } do
        v:SetAttribute("SkipFade", true);
    end;

    local v73 = `{v70}xp`;
    local Amount = CurrentInfo:FindFirstChild("Amount");

    if Amount then
        Amount.Text = v73;
    end;

    local v74 = `+{p67}xp`;
    local Amount2 = EarnedInfo:FindFirstChild("Amount");

    if Amount2 then
        Amount2.Text = v74;
    end;

    return {
        currentXP = v70,
        xpEarned = p67,
        nextLevelXP = math.max(v71, 1),
        currentLevel = v69,
        barHeight = Current.Size.Y,
        levelBar = LevelBar,
        levelFrame = Level,
        currentBar = Current,
        earnedBar = Earned,
        currentInfo = CurrentInfo,
        earnedInfo = EarnedInfo,
        currentInfoTransparency = storeFrameTransparency(CurrentInfo),
        earnedInfoTransparency = storeFrameTransparency(EarnedInfo)
    };
end;

local function calcInfoXOffset(p75: userdata, p76: userdata, p77: number) -- Line: 590
    local Parent = p76.Parent;

    return p75.AbsolutePosition.X + p77 * p75.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + p76.AnchorPoint.X * p76.AbsoluteSize.X;
end;

local function tweenInfoToBarEnd(p78: userdata, p79: userdata, p80: number, p81: userdata) -- Line: 602
    -- upvalues: TweenService (copy)
    local Position = p78.Position;
    local Parent = p78.Parent;

    return TweenService:Create(p78, p81, {
        Position = UDim2.new(0, p79.AbsolutePosition.X + p80 * p79.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + p78.AnchorPoint.X * p78.AbsoluteSize.X, Position.Y.Scale, Position.Y.Offset)
    });
end;

local function wouldOverlap(p82: userdata, p83: userdata, p84: number) -- Line: 612
    return p83.Parent.AbsolutePosition.X + p84 - p83.AnchorPoint.X * p83.AbsoluteSize.X < p82.AbsolutePosition.X + p82.AbsoluteSize.X + 5;
end;

local function calcInfoTopAlignedYOffset(p85: userdata, p86: number) -- Line: 620
    local Parent = p85.Parent;

    return p86 - (Parent and Parent.AbsolutePosition.Y or 0) + p85.AnchorPoint.Y * p85.AbsoluteSize.Y;
end;

local function getAdjustedEarnedPosition(p87: userdata, p88: userdata, p89: number) -- Line: 627
    local Y = p87.AbsolutePosition.Y;

    if p88.Parent.AbsolutePosition.X + p89 - p88.AnchorPoint.X * p88.AbsoluteSize.X < p87.AbsolutePosition.X + p87.AbsoluteSize.X + 5 then
        Y = Y + p87.AbsoluteSize.Y + -2;
    end;

    local Parent = p88.Parent;

    return UDim2.new(0, p89, 0, Y - (Parent and Parent.AbsolutePosition.Y or 0) + p88.AnchorPoint.Y * p88.AbsoluteSize.Y);
end;

local function playBarTween(p90: userdata, p91, p92: userdata, p93: userdata, p94: boolean, p95: number?) -- Line: 638
    -- upvalues: TweenService (copy), Sound (copy), workspace_CurrentCamera (copy)
    local v96 = TweenService:Create(p90, p92, {
        Size = p91
    });

    if p94 then
        local v97 = Sound.new("Interface"):play({
            Name = "XP Bar Fill",
            Parent = workspace_CurrentCamera
        });

        if v97 and p95 then
            v97.PlaybackSpeed = p95;
        end;
    end;

    v96:Play();
    p93:Play();
    v96.Completed:Wait();
end;

local function tweenInfoToBarEndWithOverlapCheck(p98: userdata, p99: userdata, p100: userdata, p101: number, p102: userdata) -- Line: 655
    -- upvalues: TweenService (copy)
    local Parent = p98.Parent;
    local v103 = p100.AbsolutePosition.X + p101 * p100.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + p98.AnchorPoint.X * p98.AbsoluteSize.X;
    local Y = p99.AbsolutePosition.Y;

    if p98.Parent.AbsolutePosition.X + v103 - p98.AnchorPoint.X * p98.AbsoluteSize.X < p99.AbsolutePosition.X + p99.AbsoluteSize.X + 5 then
        Y = Y + p99.AbsoluteSize.Y + -2;
    end;

    local Parent2 = p98.Parent;

    return TweenService:Create(p98, p102, {
        Position = UDim2.new(0, v103, 0, Y - (Parent2 and Parent2.AbsolutePosition.Y or 0) + p98.AnchorPoint.Y * p98.AbsoluteSize.Y)
    });
end;

local function animateLevelBar(p104: table) -- Line: 667
    -- upvalues: u10 (ref), tweenInfoToBarEnd (copy), playBarTween (copy), tweenInfoToBarEndWithOverlapCheck (copy), Sound (copy), workspace_CurrentCamera (copy), GetRankTitle (copy), LevelsIcon (copy), TweenService (copy)
    if not u10 then
        return;
    end;

    local math_clamp_ret = math.clamp(p104.currentXP / p104.nextLevelXP, 0, 1);
    local v105 = p104.currentXP + p104.xpEarned;
    local math_clamp_ret2 = math.clamp(v105 / p104.nextLevelXP, 0, 1);
    local v106 = p104.nextLevelXP <= v105;
    p104.currentBar.Visible = false;
    p104.earnedBar.Visible = false;
    local barHeight = p104.barHeight;
    p104.currentBar.Size = UDim2.new(0, 0, barHeight.Scale, barHeight.Offset);
    local barHeight2 = p104.barHeight;
    p104.earnedBar.Size = UDim2.new(0, 0, barHeight2.Scale, barHeight2.Offset);
    p104.currentInfo.Visible = false;
    p104.earnedInfo.Visible = false;
    local currentInfoTransparency = p104.currentInfoTransparency;
    p104.currentInfo.BackgroundTransparency = currentInfoTransparency.BackgroundTransparency;

    for i, v in pairs(currentInfoTransparency.Strokes) do
        if i and i.Parent then
            i.Transparency = v;
        end;
    end;

    local earnedInfoTransparency = p104.earnedInfoTransparency;
    p104.earnedInfo.BackgroundTransparency = earnedInfoTransparency.BackgroundTransparency;

    for i, v in pairs(earnedInfoTransparency.Strokes) do
        if i and i.Parent then
            i.Transparency = v;
        end;
    end;

    local levelBar = p104.levelBar;
    local currentInfo = p104.currentInfo;
    local Parent = currentInfo.Parent;
    local levelBar2 = p104.levelBar;
    local earnedInfo = p104.earnedInfo;
    local Parent2 = earnedInfo.Parent;
    local v107 = levelBar2.AbsolutePosition.X + 0 * levelBar2.AbsoluteSize.X - (Parent2 and Parent2.AbsolutePosition.X or 0) + earnedInfo.AnchorPoint.X * earnedInfo.AbsoluteSize.X;
    local Position = p104.currentInfo.Position;
    local Position2 = p104.earnedInfo.Position;
    p104.currentInfo.Position = UDim2.new(0, levelBar.AbsolutePosition.X + 0 * levelBar.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + currentInfo.AnchorPoint.X * currentInfo.AbsoluteSize.X, Position.Y.Scale, Position.Y.Offset);
    p104.earnedInfo.Position = UDim2.new(0, v107, Position2.Y.Scale, Position2.Y.Offset);
    task.wait(0.5);

    if not u10 then
        return;
    end;

    p104.currentBar.Visible = true;
    p104.currentInfo.Visible = true;

    if math_clamp_ret > 0 then
        local TweenInfo_new_ret = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
        local v108 = tweenInfoToBarEnd(p104.currentInfo, p104.levelBar, math_clamp_ret, TweenInfo_new_ret);
        local barHeight3 = p104.barHeight;
        playBarTween(p104.currentBar, UDim2.new(math_clamp_ret, 0, barHeight3.Scale, barHeight3.Offset), TweenInfo_new_ret, v108, true);

        if not u10 then
            return;
        end;
    end;

    if p104.xpEarned <= 0 then
        return;
    end;

    task.wait(0.6);

    if not u10 then
        return;
    end;

    local barHeight3 = p104.barHeight;
    p104.earnedBar.Size = UDim2.new(math_clamp_ret, 0, barHeight3.Scale, barHeight3.Offset);
    p104.earnedBar.Visible = true;
    p104.earnedInfo.Visible = true;
    local levelBar3 = p104.levelBar;
    local earnedInfo2 = p104.earnedInfo;
    local Parent3 = earnedInfo2.Parent;
    local v109 = levelBar3.AbsolutePosition.X + math_clamp_ret * levelBar3.AbsoluteSize.X - (Parent3 and Parent3.AbsolutePosition.X or 0) + earnedInfo2.AnchorPoint.X * earnedInfo2.AbsoluteSize.X;
    local currentInfo2 = p104.currentInfo;
    local earnedInfo3 = p104.earnedInfo;
    local Y = currentInfo2.AbsolutePosition.Y;

    if earnedInfo3.Parent.AbsolutePosition.X + v109 - earnedInfo3.AnchorPoint.X * earnedInfo3.AbsoluteSize.X < currentInfo2.AbsolutePosition.X + currentInfo2.AbsoluteSize.X + 5 then
        Y = Y + currentInfo2.AbsoluteSize.Y + -2;
    end;

    local Parent4 = earnedInfo3.Parent;
    local UDim2_new_ret = UDim2.new(0, v109, 0, Y - (Parent4 and Parent4.AbsolutePosition.Y or 0) + earnedInfo3.AnchorPoint.Y * earnedInfo3.AbsoluteSize.Y);
    p104.earnedInfo.Position = UDim2_new_ret;

    if not v106 then
        local TweenInfo_new_ret = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
        local v110 = tweenInfoToBarEndWithOverlapCheck(p104.earnedInfo, p104.currentInfo, p104.levelBar, math_clamp_ret2, TweenInfo_new_ret);
        local barHeight4 = p104.barHeight;
        playBarTween(p104.earnedBar, UDim2.new(math_clamp_ret2, 0, barHeight4.Scale, barHeight4.Offset), TweenInfo_new_ret, v110, true, 1.15);

        return;
    end;

    local TweenInfo_new_ret = TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
    local v111 = tweenInfoToBarEndWithOverlapCheck(p104.earnedInfo, p104.currentInfo, p104.levelBar, 1, TweenInfo_new_ret);
    local barHeight4 = p104.barHeight;
    playBarTween(p104.earnedBar, UDim2.new(1, 0, barHeight4.Scale, barHeight4.Offset), TweenInfo_new_ret, v111, true, 1.15);

    if not u10 then
        return;
    end;

    Sound.new("Interface"):play({
        Name = "Level Up",
        Parent = workspace_CurrentCamera
    });
    local math_clamp_ret3 = math.clamp((v105 - p104.nextLevelXP) / p104.nextLevelXP, 0, 1);
    local levelFrame = p104.levelFrame;
    local v112 = p104.currentLevel + 1;
    local v113 = `[{GetRankTitle(v112)} Rank {v112}]`;
    local TextLabel = levelFrame:FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = v113;
    end;

    local Rank = levelFrame:FindFirstChild("Rank");

    if Rank then
        Rank.Image = LevelsIcon[tostring(v112)] or "";
    end;

    local barHeight5 = p104.barHeight;
    p104.currentBar.Size = UDim2.new(0, 0, barHeight5.Scale, barHeight5.Offset);
    local barHeight6 = p104.barHeight;
    p104.earnedBar.Size = UDim2.new(0, 0, barHeight6.Scale, barHeight6.Offset);
    p104.currentInfo.Visible = false;
    local levelBar4 = p104.levelBar;
    local earnedInfo4 = p104.earnedInfo;
    local Parent5 = earnedInfo4.Parent;
    local earnedInfo5 = p104.earnedInfo;
    local Parent6 = earnedInfo5.Parent;
    p104.earnedInfo.Position = UDim2.new(0, levelBar4.AbsolutePosition.X + 0 * levelBar4.AbsoluteSize.X - (Parent5 and Parent5.AbsolutePosition.X or 0) + earnedInfo4.AnchorPoint.X * earnedInfo4.AbsoluteSize.X, 0, p104.currentInfo.AbsolutePosition.Y - (Parent6 and Parent6.AbsolutePosition.Y or 0) + earnedInfo5.AnchorPoint.Y * earnedInfo5.AbsoluteSize.Y);
    local v114 = tweenInfoToBarEnd(p104.earnedInfo, p104.levelBar, math_clamp_ret3, TweenInfo_new_ret);
    local barHeight7 = p104.barHeight;
    local v115 = TweenService:Create(p104.earnedBar, TweenInfo_new_ret, {
        Size = UDim2.new(math_clamp_ret3, 0, barHeight7.Scale, barHeight7.Offset)
    });
    v115:Play();
    v114:Play();
    v115.Completed:Wait();
end;

local function scaleUDim2(p116, p117: number) -- Line: 797
    return UDim2.new(p116.X.Scale * p117, p116.X.Offset * p117, p116.Y.Scale * p117, p116.Y.Offset * p117);
end;

local function getItemIcon(p118: table) -- Line: 806
    -- upvalues: Cases (copy), Skins (copy)
    local v119 = not p118.Type and "" or string.lower(p118.Type);
    local Name = p118.Name;

    if v119 == "credits" then
        return "rbxassetid://115958498634807";
    end;

    if v119 == "case" or (v119 == "sticker capsule" or (v119 == "charm pack" or v119 == "charm capsule")) then
        local CaseByName = Cases.GetCaseByName(Name);

        if CaseByName and CaseByName.imageAssetId then
            return CaseByName.imageAssetId;
        end;
    end;

    local v120 = p118.Skin and (Name and Skins.GetSkinInformation(Name, p118.Skin));

    if v120 then
        if v120.wearImages and v120.wearImages[1] then
            return v120.wearImages[1].assetId;
        end;

        if v120.charmImages and v120.charmImages[1] then
            return v120.charmImages[1].assetId;
        end;

        if v120.imageAssetId then
            return v120.imageAssetId;
        end;
    end;

    return "rbxassetid://18822070027";
end;

local function clearDropItems(p121: userdata) -- Line: 849
    for _, child in p121:GetChildren() do
        if child:IsA("Frame") and child.Name ~= "ItemTemplate" then
            child:Destroy();
        end;
    end;
end;

local function displayDrops(p122: table) -- Line: 857
    -- upvalues: u10 (ref), PlayerGui (copy), clearDropItems (copy), getItemIcon (copy), Rarities (copy), fadeInFrame (copy), TweenService (copy), u9 (copy)
    if not (u10 and (p122 and #p122 ~= 0)) then
        return;
    end;

    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Gameplay");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Middle");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("EndScreen");
    end;

    if not MainGui then
        return;
    end;

    local Drops = MainGui:FindFirstChild("Drops");
    local v123;

    if Drops then
        v123 = Drops:FindFirstChild("Container");
    else
        v123 = Drops;
    end;

    local v124;

    if v123 then
        v124 = v123:FindFirstChild("ItemTemplate");
    else
        v124 = v123;
    end;

    if not v124 then
        return;
    end;

    v123:SetAttribute("SkipFade", true);
    v124.Visible = false;
    clearDropItems(v123);
    Drops.Visible = false;
    task.wait(0.8);

    if not u10 then
        return;
    end;

    local v125 = {};

    for i, v in ipairs(p122) do
        local reward = v.reward;
        local v126 = reward.type == "credits";
        local inventoryItem = reward.inventoryItem;

        if v126 or inventoryItem then
            local v127 = v124:Clone();
            v127.Name = "Drop_" .. i;
            v127.Visible = false;
            v127.Parent = v123;
            local Content = v127:FindFirstChild("Content");

            if Content then
                local Icon = Content:FindFirstChild("Icon");

                if Icon then
                    Icon.Image = v126 and "rbxassetid://115958498634807" or getItemIcon(inventoryItem);
                end;

                local v128 = Content:FindFirstChild("amount") or Content:FindFirstChild("Amount");

                if v128 then
                    if v126 and reward.amount then
                        v128.Visible = true;
                        v128.Text = `x{reward.amount}`;
                    else
                        v128.Visible = false;
                    end;
                end;

                local RarityFrame = Content:FindFirstChild("RarityFrame");

                if RarityFrame then
                    RarityFrame = RarityFrame:FindFirstChild("UIGradient");
                end;

                if RarityFrame then
                    if v126 then
                        inventoryItem = "Rare";
                    elseif inventoryItem then
                        inventoryItem = inventoryItem.Rarity;
                    end;

                    if inventoryItem then
                        inventoryItem = Rarities[inventoryItem];
                    end;

                    if inventoryItem and inventoryItem.ColorSequence then
                        RarityFrame.Color = inventoryItem.ColorSequence;
                    end;
                end;

                local Size = Content.Size;
                Content.Size = UDim2.new(Size.X.Scale * 1.25, Size.X.Offset * 1.25, Size.Y.Scale * 1.25, Size.Y.Offset * 1.25);
                local Player = v127:FindFirstChild("Player", true);

                if Player and v.userId > 0 then
                    Player.Image = `rbxthumb://type=AvatarHeadShot&id={v.userId}&w=150&h=150`;
                end;

                table.insert(v125, {
                    item = v127,
                    content = Content,
                    originalSize = Size
                });
            else
                v127:Destroy();
            end;
        end;
    end;

    if #v125 == 0 then
        return;
    end;

    fadeInFrame(Drops);
    task.wait(0.5);

    if not u10 then
        return;
    end;

    local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out);

    for i, v in ipairs(v125) do
        task.delay((i - 1) * 0.35, function() -- Line: 960
            -- upvalues: u10 (ref), v (copy), TweenService (ref), TweenInfo_new_ret (copy), u9 (ref)
            if not u10 then
                return;
            end;

            v.item.Visible = true;
            local v129 = TweenService:Create(v.content, TweenInfo_new_ret, {
                Size = v.originalSize
            });
            u9:Add(v129, "Cancel");
            v129:Play();
        end);
    end;
end;

local function recordPanelVisibility(p130: userdata?, p131: table) -- Line: 973
    if p130 then
        for _, child in p130:GetChildren() do
            if child:IsA("Frame") or child:IsA("CanvasGroup") then
                p131[child.Name] = child.Visible;
            end;
        end;
    end;
end;

local function applyPanelVisibility(p132: userdata, p133: table, p134: table?) -- Line: 983
    for _, child in p132:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            local v135 = p133[child.Name];

            if v135 ~= nil and not (p134 and p134[child.Name]) then
                child.Visible = v135;
            end;
        end;
    end;
end;

local function captureVisibilitySnapshot(p136: userdata) -- Line: 994
    -- upvalues: recordPanelVisibility (copy), u15 (ref)
    local Gameplay = p136:FindFirstChild("Gameplay");
    local Menu = p136:FindFirstChild("Menu");
    local v137;

    if Gameplay then
        v137 = Gameplay:FindFirstChild("Middle") or nil;
    else
        v137 = nil;
    end;

    local v138 = {};
    local v139;

    if Gameplay then
        v139 = Gameplay.Visible or false;
    else
        v139 = false;
    end;

    v138.GameplayVisible = v139;
    v138.MenuVisible = Menu and Menu.Visible or false;
    v138.GameplayChildren = {};
    v138.MiddleChildren = {};
    recordPanelVisibility(Gameplay, v138.GameplayChildren);
    recordPanelVisibility(v137, v138.MiddleChildren);
    u15 = v138;
end;

local function restoreVisibilitySnapshot(p140: userdata, p141: boolean?) -- Line: 1011
    -- upvalues: u15 (ref), applyPanelVisibility (copy), u18 (copy), u17 (copy)
    if not u15 then
        return;
    end;

    local v142 = u15;
    u15 = nil;
    local Gameplay = p140:FindFirstChild("Gameplay");
    local Menu = p140:FindFirstChild("Menu");
    local v143;

    if Gameplay then
        v143 = Gameplay:FindFirstChild("Middle") or nil;
    else
        v143 = nil;
    end;

    if Menu then
        Menu.Visible = v142.MenuVisible;
    end;

    if Gameplay then
        Gameplay.Visible = v142.GameplayVisible;
        applyPanelVisibility(Gameplay, v142.GameplayChildren);
    end;

    if v143 then
        applyPanelVisibility(v143, v142.MiddleChildren, u18);

        if p141 then
            for i in pairs(u17) do
                local v144 = v143:FindFirstChild(i);

                if v144 and (v144:IsA("Frame") or v144:IsA("CanvasGroup")) then
                    v144.Visible = false;
                end;
            end;
        end;
    end;
end;

local function enforceEndScreenVisibility(p145: userdata) -- Line: 1046
    -- upvalues: u14 (ref), MenuState (copy)
    local v146 = u14 == "Halftime";

    if p145:FindFirstChild("Menu") then
        MenuState.HideMenu();
    end;

    local Gameplay = p145:FindFirstChild("Gameplay");

    if not Gameplay then
        return;
    end;

    local Middle = Gameplay:FindFirstChild("Middle");
    local v147;

    if Middle then
        v147 = Middle:FindFirstChild("EndScreen") or nil;
    else
        v147 = nil;
    end;

    local v148;

    if Middle then
        v148 = Middle:FindFirstChild("Halftime") or nil;
    else
        v148 = nil;
    end;

    Gameplay.Visible = true;

    for _, child in Gameplay:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            child.Visible = child == Middle;
        end;
    end;

    if not Middle then
        return;
    end;

    Middle.Visible = true;

    for _, child in Middle:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            if child == v147 then
                child.Visible = not v146;
            elseif child == v148 then
                child.Visible = v146;
            else
                child.Visible = false;
            end;
        end;
    end;

    if v147 then
        v147.Visible = not v146;
    end;

    if v148 then
        v148.Visible = v146;
    end;
end;

local u149 = {
    Victory = {
        Background = Color3.fromRGB(11, 97, 31),
        Glow = Color3.fromRGB(46, 158, 78),
        Pattern = Color3.fromRGB(134, 255, 78),
        Stroke = Color3.fromRGB(48, 127, 48)
    },
    Defeat = {
        Background = Color3.fromRGB(83, 9, 9),
        Glow = Color3.fromRGB(158, 14, 14),
        Pattern = Color3.fromRGB(255, 53, 53),
        Stroke = Color3.fromRGB(127, 48, 48)
    }
};

local function hidePanels(p150: userdata) -- Line: 1113
    for _, child in p150:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            child.Visible = false;
        end;
    end;
end;

local function setupResultFrame(p151: userdata?, p152: boolean, p153: any, p154: string?, p155: string) -- Line: 1122
    -- upvalues: getTransparencyProperty (copy)
    if not p151 then
        return;
    end;

    p151.BackgroundTransparency = 0;

    for _, descendant in p151:GetDescendants() do
        local v156 = getTransparencyProperty(descendant);

        if v156 then
            descendant[v156] = 0;
        end;
    end;

    p151.Visible = p152;
    local Score = p151:FindFirstChild("Score");

    if Score then
        Score.Visible = p154 ~= nil;
        Score.BackgroundColor3 = p153.Background;
        local Glow = Score:FindFirstChild("Glow");

        if Glow and Glow:IsA("ImageLabel") then
            Glow.ImageColor3 = p153.Glow;
        end;

        local Pattern = Score:FindFirstChild("Pattern");

        if Pattern and Pattern:IsA("ImageLabel") then
            Pattern.ImageColor3 = p153.Pattern;
        end;

        local v157 = Score:FindFirstChildOfClass("UIStroke");

        if v157 then
            v157.Color = p153.Stroke;
        end;

        local TextLabel = Score:FindFirstChild("TextLabel");

        if TextLabel and p154 then
            TextLabel.Text = p154;
        end;
    end;

    local TextLabel = p151:FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = p155;
        local Attribute = TextLabel:GetAttribute("AuthoredPosition");

        if not Attribute then
            Attribute = TextLabel.Position;
            TextLabel:SetAttribute("AuthoredPosition", Attribute);
        end;

        if not p154 then
            Attribute = UDim2.new(Attribute.X, UDim.new(0.5, 0));
        end;

        TextLabel.Position = Attribute;
    end;
end;

local function bindVisibilityLock(u158: userdata) -- Line: 1171
    -- upvalues: u9 (copy), RunServiceController (copy), enforceEndScreenVisibility (copy)
    u9:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1173
        -- upvalues: enforceEndScreenVisibility (ref), u158 (copy)
        enforceEndScreenVisibility(u158);
    end), "Disconnect", "EndScreenVisibilityLock");
end;

local function showEndScreenUI(p159: table) -- Line: 1181
    -- upvalues: PlayerGui (copy), captureVisibilitySnapshot (copy), CameraController (copy), IsPlayingTeam (copy), Halftime (copy), u9 (copy), RunServiceController (copy), enforceEndScreenVisibility (copy), setupResultFrame (copy), u149 (copy)
    local isDraw = p159.isDraw;
    local didWin = p159.didWin;
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if not MainGui then
        return;
    end;

    captureVisibilitySnapshot(MainGui);
    CameraController.setForceLockOverride("EndScreen", true);
    CameraController.setPerspective(false, true);
    local Menu = MainGui:FindFirstChild("Menu");

    if Menu then
        Menu.Visible = false;
        CameraController.setForceLockOverride("Menu", false);
    end;

    local Gameplay = MainGui:FindFirstChild("Gameplay");

    if not Gameplay then
        return;
    end;

    Gameplay.Visible = true;

    for _, child in Gameplay:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            child.Visible = false;
        end;
    end;

    local Middle = Gameplay:FindFirstChild("Middle");

    if not Middle then
        return;
    end;

    for _, child in Middle:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            child.Visible = false;
        end;
    end;

    Middle.Visible = true;
    local EndScreen = Middle:FindFirstChild("EndScreen");

    if p159.overlayMode == "Halftime" then
        if EndScreen then
            EndScreen.Visible = false;
        end;

        if Middle:FindFirstChild("Halftime") and IsPlayingTeam(p159.halftimeTeam) then
            Halftime.Show(p159.halftimeTeam);
        else
            Halftime.Hide();
        end;

        u9:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1173
            -- upvalues: enforceEndScreenVisibility (ref), MainGui (copy)
            enforceEndScreenVisibility(MainGui);
        end), "Disconnect", "EndScreenVisibilityLock");

        return;
    end;

    Halftime.Hide();

    if not EndScreen then
        return;
    end;

    local MapVote = EndScreen:FindFirstChild("MapVote");

    if MapVote then
        MapVote.Visible = false;
    end;

    local Top = EndScreen:FindFirstChild("Top");

    if Top then
        Top.Visible = false;
    end;

    EndScreen.Visible = true;
    local tScore = p159.tScore;
    local ctScore = p159.ctScore;

    if isDraw or p159.winningTeam == "Counter-Terrorists" then
        tScore = p159.ctScore;
        ctScore = p159.tScore;
    end;

    local v160;

    if p159.hideScore then
        v160 = nil;
    else
        v160 = p159.scoreTextOverride or `<b>{tScore}</b> - {ctScore}`;
    end;

    setupResultFrame(EndScreen:FindFirstChild("Victory"), isDraw or didWin, u149.Victory, v160, isDraw and "Draw" or "Victory");
    local Defeat = EndScreen:FindFirstChild("Defeat");
    setupResultFrame(Defeat, not isDraw and not didWin, u149.Defeat, v160, isDraw and "Draw" or "Defeat");
    local showAccolades = p159.showAccolades;
    local MVP = EndScreen:FindFirstChild("MVP");

    if MVP then
        MVP.Visible = showAccolades;
    end;

    local returnToMenu = p159.returnToMenu;
    local Close = EndScreen:FindFirstChild("Close");

    if Close then
        Close.Visible = returnToMenu;
    end;

    local Level = EndScreen:FindFirstChild("Level");

    if Level then
        Level.Visible = false;
    end;

    local Drops = EndScreen:FindFirstChild("Drops");

    if Drops then
        Drops.Visible = false;
    end;

    u9:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1173
        -- upvalues: enforceEndScreenVisibility (ref), MainGui (copy)
        enforceEndScreenVisibility(MainGui);
    end), "Disconnect", "EndScreenVisibilityLock");
end;

local function clearSkipFade(p161: userdata?) -- Line: 1277
    if p161 then
        p161:SetAttribute("SkipFade", nil);
    end;
end;

local function hideMvpSlots(p162: userdata) -- Line: 1283
    for i = 1, 5 do
        local v163 = p162:FindFirstChild((tostring(i)));
        local v164;

        if v163 then
            v163.Visible = false;
            v164 = i;
        else
            v164 = i;
        end;
    end;
end;

local function hideEndScreenUI() -- Line: 1289
    -- upvalues: PlayerGui (copy), Halftime (copy), hideMvpSlots (copy), clearDropItems (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Gameplay");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Middle");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("EndScreen");
    end;

    if not MainGui then
        return;
    end;

    MainGui.Visible = false;
    Halftime.Hide();
    local Victory = MainGui:FindFirstChild("Victory");

    if Victory then
        Victory.Visible = false;
    end;

    local Defeat = MainGui:FindFirstChild("Defeat");

    if Defeat then
        Defeat.Visible = false;
    end;

    local Level = MainGui:FindFirstChild("Level");

    if Level then
        Level.Visible = false;
        local LevelBar = Level:FindFirstChild("LevelBar");

        if LevelBar then
            local Current = LevelBar:FindFirstChild("Current");

            if Current then
                Current:SetAttribute("SkipFade", nil);
            end;

            local Earned = LevelBar:FindFirstChild("Earned");

            if Earned then
                Earned:SetAttribute("SkipFade", nil);
            end;
        end;

        local CurrentInfo = Level:FindFirstChild("CurrentInfo", true);

        if CurrentInfo then
            CurrentInfo:SetAttribute("SkipFade", nil);
        end;

        local EarnedInfo = Level:FindFirstChild("EarnedInfo", true);

        if EarnedInfo then
            EarnedInfo:SetAttribute("SkipFade", nil);
        end;
    end;

    local MVP = MainGui:FindFirstChild("MVP");

    if MVP then
        MVP.Visible = false;
        hideMvpSlots(MVP);
    end;

    local Drops = MainGui:FindFirstChild("Drops");

    if Drops then
        Drops.Visible = false;
        local Container = Drops:FindFirstChild("Container");

        if Container then
            Container:SetAttribute("SkipFade", nil);
            clearDropItems(Container);
        end;
    end;

    local MapVote = MainGui:FindFirstChild("MapVote");

    if MapVote then
        MapVote.Visible = true;
    end;

    local Top = MainGui:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;
end;

local function getTeamLoadout(p165: string) -- Line: 1334
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v166 = DataController.Get(LocalPlayer, "Loadout");

    if type(v166) ~= "table" then
        return nil;
    end;

    local v167 = v166[p165 == "CT" and "Counter-Terrorists" or "Terrorists"];

    if type(v167) == "table" then
        return v167;
    end;

    return nil;
end;

local function getEquippedGloveId(p168: string) -- Line: 1344
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v169 = DataController.Get(LocalPlayer, "Loadout");
    local v170;

    if type(v169) == "table" then
        v170 = v169[p168 == "CT" and "Counter-Terrorists" or "Terrorists"];

        if type(v170) ~= "table" then
            v170 = nil;
        end;
    else
        v170 = nil;
    end;

    local v171 = v170 and v170.Equipped and v170.Equipped["Equipped Gloves"];

    if type(v171) == "string" and v171 ~= "" then
        return v171;
    end;

    return nil;
end;

local function findInventoryItem(p172: string) -- Line: 1353
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v173 = DataController.Get(LocalPlayer, "Inventory");

    if type(v173) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v173) do
        if v and v._id == p172 then
            return v;
        end;
    end;

    return nil;
end;

local function attachGlovesToCharacter(p174: userdata, p175: string, p176: table?) -- Line: 1367
    -- upvalues: DataController (copy), LocalPlayer (copy), findInventoryItem (copy), u7 (copy), Skins (copy), AttachGlovesToCharacter (copy)
    local v177 = nil;
    local v178 = nil;
    local v179 = nil;

    if p176 then
        v177 = p176.Name;
        v178 = p176.Skin;
        v179 = p176.Float;
    else
        local v180 = DataController.Get(LocalPlayer, "Loadout");
        local v181;

        if type(v180) == "table" then
            v181 = v180[p175 == "CT" and "Counter-Terrorists" or "Terrorists"];

            if type(v181) ~= "table" then
                v181 = nil;
            end;
        else
            v181 = nil;
        end;

        local v182 = v181 and v181.Equipped and v181.Equipped["Equipped Gloves"];

        if type(v182) ~= "string" or v182 == "" then
            v182 = nil;
        end;

        if v182 then
            local v183 = findInventoryItem(v182);

            if v183 then
                v177 = v183.Name;
                v178 = v183.Skin;
                v179 = v183.Float;
            end;
        end;
    end;

    local v184 = v177 or u7[p175].Glove;
    local v185;

    if v178 and (v178 ~= "" and v179 ~= nil) then
        v185 = Skins.GetCharacterGloves(v184, v178, v179) or nil;
    else
        v185 = nil;
    end;

    local v186;

    if v185 then
        v186 = v185:GetChildren();
    else
        v186 = Skins.GetCharacterGloveParts(v184);

        if not v186 then
            return;
        end;
    end;

    local v187 = p174:FindFirstChild("CharacterArmor") or Instance.new("Folder");
    v187.Name = "CharacterArmor";
    v187.Parent = p174;
    AttachGlovesToCharacter(v186, p174, v187);
end;

local function getEquippedWeaponFromLoadout(p188: string, p189: string) -- Line: 1413
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v190 = DataController.Get(LocalPlayer, "Loadout");
    local v191;

    if type(v190) == "table" then
        v191 = v190[p188 == "CT" and "Counter-Terrorists" or "Terrorists"];

        if type(v191) ~= "table" then
            v191 = nil;
        end;
    else
        v191 = nil;
    end;

    local v192 = v191 and v191.Loadout and v191.Loadout.Rifles;

    if not v192 or type(v192.Options) ~= "table" then
        return nil;
    end;

    local v193 = DataController.Get(LocalPlayer, "Inventory");

    if type(v193) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v192.Options) do
        if type(v) == "string" and v ~= "" then
            local v194 = v;

            for _, v2 in ipairs(v193) do
                if v2 and (v2._id == v194 and v2.Name == p189) then
                    return {
                        Skin = v2.Skin,
                        Float = v2.Float,
                        StatTrack = v2.StatTrack,
                        NameTag = v2.NameTag
                    };
                end;
            end;
        end;
    end;

    return nil;
end;

local function attachWeaponToCharacter(p195: userdata, p196: string, p197: table?) -- Line: 1444
    -- upvalues: u7 (copy), getEquippedWeaponFromLoadout (copy), Skins (copy), u5 (copy)
    local Weapon = u7[p196].Weapon;
    local v198 = nil;

    if not (p197 and (p197.Skin and p197.Skin ~= "")) then
        p197 = getEquippedWeaponFromLoadout(p196, Weapon);
    end;

    if p197 and (p197.Skin and p197.Skin ~= "") then
        v198 = Skins.GetCharacterModel(Weapon, p197.Skin, p197.Float, p197.StatTrack, p197.NameTag);
    end;

    local v199 = v198 or Skins.GetBaseWeaponModel(Weapon, "Character");

    if not v199 then
        return;
    end;

    v199.Name = Weapon;
    local RightHand = p195:FindFirstChild("RightHand");

    if not RightHand then
        v199:Destroy();

        return;
    end;

    if not v199.PrimaryPart then
        local Weapon2 = v199:FindFirstChild("Weapon");

        if Weapon2 then
            Weapon2 = Weapon2:FindFirstChild("Insert");
        end;

        if not Weapon2 then
            v199:Destroy();

            return;
        end;

        v199.PrimaryPart = Weapon2;
    end;

    for _, descendant in v199:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = false;
            descendant.Massless = true;
        end;
    end;

    v199.Parent = p195;
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = "WeaponAttachment";
    Motor6D.Part0 = RightHand;
    Motor6D.Part1 = v199.PrimaryPart;
    Motor6D.Parent = RightHand;

    if Weapon == "AK-47" then
        Motor6D.C0 = u5;

        return;
    end;

    local Properties = v199:FindFirstChild("Properties");

    if Properties then
        local C0 = Properties:FindFirstChild("C0");
        local C1 = Properties:FindFirstChild("C1");

        if C0 then
            Motor6D.C0 = C0.Value;
        end;

        if C1 then
            Motor6D.C1 = C1.Value;
        end;
    end;
end;

local function calculateHSP(p200: number?, p201: number?) -- Line: 1524
    local v202 = p200 or 0;

    return v202 <= 0 and "0%" or `{math.floor((p201 or 0) / v202 * 100)}%`;
end;

local function getEquippedBadgeIcon(p203: userdata, p204: string) -- Line: 1534
    -- upvalues: DataController (copy), Skins (copy)
    local v205, v206 = DataController.Get(p203, "Loadout", "Inventory");

    if v205 then
        if v206 then
            v205 = v205[p204];
        else
            v205 = v206;
        end;
    end;

    local v207 = v205 and v205.Equipped and v205.Equipped["Equipped Badge"];

    if not v207 or v207 == "" then
        return "";
    end;

    for _, v in ipairs(v206) do
        if v._id == v207 then
            local SkinInformation = Skins.GetSkinInformation(v.Name, v.Skin);

            return SkinInformation and SkinInformation.imageAssetId or "";
        end;
    end;

    return "";
end;

local function populateMVPFrame(p208: table) -- Line: 1551
    -- upvalues: PlayerGui (copy), hideMvpSlots (copy), u3 (copy), Players (copy), getEquippedBadgeIcon (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Gameplay");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Middle");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("EndScreen");
    end;

    if not MainGui then
        return;
    end;

    local MVP = MainGui:FindFirstChild("MVP");

    if not MVP then
        return;
    end;

    hideMvpSlots(MVP);

    for i, v in ipairs(p208) do
        local v209 = MVP:FindFirstChild((tostring(u3[i])));

        if v209 then
            local data = v.data;
            local userId = v.userId;
            local v210 = tonumber(userId);
            local v211;

            if v210 then
                v211 = Players:GetPlayerByUserId(v210);
            else
                v211 = nil;
            end;

            local v212 = data.Name or (v211 and v211.Name or `Player_{userId}`);
            local Username = v209:FindFirstChild("Username");

            if Username then
                Username.Text = v212;
            end;

            local v213 = `{data.Kills or 0}-{data.Deaths or 0}-{data.Assists or 0}`;
            local KDA = v209:FindFirstChild("KDA");

            if KDA then
                KDA.Text = v213;
            end;

            local v214 = data.Kills or 0;
            local v215 = v214 <= 0 and "0%" or `{math.floor((data.Headshots or 0) / v214 * 100)}%`;
            local HSP = v209:FindFirstChild("HSP");

            if HSP then
                HSP.Text = v215;
            end;

            local math_floor_ret = math.floor(data.ADR or 0);
            local v216 = tostring(math_floor_ret);
            local APR = v209:FindFirstChild("APR");

            if APR then
                APR.Text = v216;
            end;

            local Score = v209:FindFirstChild("Score");

            if not Score then
                for _, child in v209:GetChildren() do
                    if child:IsA("TextLabel") and (child.Name == "NameScore" and child.Text ~= "SCORE") then
                        Score = child;
                        break;
                    end;
                end;
            end;

            if Score then
                Score.Text = tostring(data.Score or 0);
            end;

            local v217 = data.Accolade or "Participant";
            local Category = v209:FindFirstChild("Category");

            if Category then
                Category.Text = v217;
            end;

            local Player = v209:FindFirstChild("Player");
            local v218 = Player and Player:FindFirstChild("Avatar");

            if v218 then
                v218.Image = `rbxthumb://type=AvatarHeadShot&id={data.AvatarUserId or userId}&w=150&h=150`;
            end;

            local Pin = v209:FindFirstChild("Pin");

            if Pin then
                local v219 = not (v211 and data.Team) and "" or getEquippedBadgeIcon(v211, data.Team);

                if v219 ~= "" then
                    Pin.Image = v219;
                end;

                Pin.Visible = v219 ~= "";
            end;

            v209.Visible = true;
        end;
    end;
end;

local function positionCharacterOnGround(p220: userdata, p221: userdata, p222: userdata) -- Line: 1623
    p220:PivotTo(p222.CFrame);
    local BoundingBox, v223 = p220:GetBoundingBox();
    local v224 = p221.Position.Y - (BoundingBox.Position.Y - v223.Y / 2);
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = { p220, p222 };
    RaycastParams_new_ret.RespectCanCollide = true;
    local v225 = workspace:Raycast(p221.Position + Vector3.new(0, 16, 0), Vector3.new(-0, -128, -0), RaycastParams_new_ret);

    if not v225 then
        return false;
    end;

    local v226 = v225.Position.Y + v224 - p221.Position.Y;
    p220:PivotTo(p220:GetPivot() + Vector3.new(0, v226, 0));

    return true;
end;

local function playPodiumAnimation(p227: userdata, p228: string, p229: boolean, p230: any) -- Line: 1645
    -- upvalues: u9 (copy)
    local Animation = Instance.new("Animation");
    Animation.AnimationId = p228;
    local v231 = p227:LoadAnimation(Animation);
    v231.Looped = p229;
    v231.Priority = p230;
    v231:Play();
    u9:Add(Animation);
    u9:Add(v231);
end;

local function spawnEndScreenCharacters(p232: table, p233: boolean) -- Line: 1663
    -- upvalues: populateMVPFrame (copy), u3 (copy), u8 (copy), Characters (copy), u7 (copy), CharacterResolver (copy), positionCharacterOnGround (copy), attachGlovesToCharacter (copy), attachWeaponToCharacter (copy), u6 (copy), playPodiumAnimation (copy), u9 (copy)
    local TutorialEndScreenScene = workspace:FindFirstChild("TutorialEndScreenScene");

    if TutorialEndScreenScene then
        TutorialEndScreenScene = TutorialEndScreenScene:FindFirstChild("EndScreen");
    end;

    if not TutorialEndScreenScene then
        TutorialEndScreenScene = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EndScreen");
    end;

    if not TutorialEndScreenScene then
        return {};
    end;

    local v234 = {};

    for i = 1, math.min(5, #p232) do
        table.insert(v234, p232[i]);
        local _ = i;
    end;

    if p233 then
        populateMVPFrame(v234);
    end;

    local v235 = {};

    for i, v in ipairs(v234) do
        local v236 = u3[i];
        local v237 = TutorialEndScreenScene:FindFirstChild((tostring(v236)));

        if v237 then
            local v238 = u8[v.data.Team];

            if v238 then
                local v239 = Characters:FindFirstChild(u7[v238].Character);

                if v239 then
                    local v240 = v239:Clone();
                    v240.Name = "EndScreenCharacter_" .. v.userId;
                    local RootPart = CharacterResolver.getRootPart(v240);

                    if RootPart then
                        RootPart.Anchored = true;

                        if not positionCharacterOnGround(v240, RootPart, v237) then
                            warn((`[EndScreen] No ground found below position {v236}; using the position marker height`));
                        end;

                        v240.Parent = TutorialEndScreenScene;
                        attachGlovesToCharacter(v240, v238, v.data.Gloves);
                        attachWeaponToCharacter(v240, v238, v.data.Weapon);
                        local OrCreateAnimator = CharacterResolver.getOrCreateAnimator(v240);
                        local v241 = u6[v236];

                        if OrCreateAnimator and v241 then
                            playPodiumAnimation(OrCreateAnimator, v241.Entrance, false, Enum.AnimationPriority.Action);
                            playPodiumAnimation(OrCreateAnimator, v241.Idle, true, Enum.AnimationPriority.Idle);
                        end;

                        u9:Add(v240, "Destroy");
                        table.insert(v235, v240);
                    else
                        warn((`[EndScreen] Character template {v239.Name} is missing a HumanoidRootPart`));
                        v240:Destroy();
                    end;
                end;
            end;
        end;
    end;

    return v235;
end;

local function buildCameraPath(p242: userdata) -- Line: 1730
    -- upvalues: CatmullRomPath (copy)
    local v243 = {};
    local v244 = {};

    while true do
        local v245 = p242:FindFirstChild((tostring(#v243 + 1)));

        if not (v245 and v245:IsA("BasePart")) then
            break;
        end;

        table.insert(v243, v245.Position);
        table.insert(v244, v245.CFrame.LookVector);
    end;

    if #v243 < 2 then
        return nil;
    end;

    local v246 = {
        Alpha = 0,
        SamplesPerSpan = 24
    };
    local v247 = CatmullRomPath.spline(v243, v246);
    local v248 = CatmullRomPath.spline(v244, v246);

    for i, v in v248 do
        v248[i] = v.Unit;
    end;

    local v249, v250, v251 = CatmullRomPath.resample(v247, 0.25, nil, v248);

    return {
        Positions = v249,
        Looks = v251,
        Total = v250
    };
end;

local function sampleCameraPath(p252: table, p253: number) -- Line: 1758
    -- upvalues: CatmullRomPath (copy)
    local v254 = p252.Total * math.clamp(p253, 0, 1);
    local v255, v256, v257 = CatmullRomPath.locate(#p252.Positions, 0.25, v254);
    local v258 = p252.Positions[v255]:Lerp(p252.Positions[v256], v257);
    local v259 = p252.Looks[v255]:Lerp(p252.Looks[v256], v257);

    return CFrame.lookAt(v258, v258 + v259);
end;

local function takeEndScreenCamera(p260) -- Line: 1766
    -- upvalues: workspace_CurrentCamera (copy), CameraController (copy), u9 (copy)
    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    workspace_CurrentCamera.CFrame = p260;
    workspace_CurrentCamera.Focus = p260;
    workspace_CurrentCamera.FieldOfView = 60;
    CameraController.setMouseEnabled(true);
    u9:Add(workspace_CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function() -- Line: 1776
        -- upvalues: workspace_CurrentCamera (ref)
        if workspace_CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
            workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        end;
    end));
end;

local function animateCamera() -- Line: 1783
    -- upvalues: buildCameraPath (copy), takeEndScreenCamera (copy), sampleCameraPath (copy), u9 (copy), RunServiceController (copy), EndScreenTiming (copy), workspace_CurrentCamera (copy), TweenService (copy)
    local TutorialEndScreenScene = workspace:FindFirstChild("TutorialEndScreenScene");

    if TutorialEndScreenScene then
        TutorialEndScreenScene = TutorialEndScreenScene:FindFirstChild("EndScreen");
    end;

    if not TutorialEndScreenScene then
        TutorialEndScreenScene = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EndScreen");
    end;

    if not TutorialEndScreenScene then
        return;
    end;

    local CameraPath = TutorialEndScreenScene:FindFirstChild("CameraPath");

    if CameraPath then
        CameraPath = buildCameraPath(CameraPath);
    end;

    if CameraPath then
        takeEndScreenCamera(sampleCameraPath(CameraPath, 0));
        local os_clock_ret = os.clock();
        u9:Add(RunServiceController.BindToRenderStep("EndScreenController.CameraPath", Enum.RenderPriority.Camera.Value + 1, function() -- Line: 1795
            -- upvalues: sampleCameraPath (ref), CameraPath (copy), os_clock_ret (copy), EndScreenTiming (ref), workspace_CurrentCamera (ref)
            local v261 = sampleCameraPath(CameraPath, (os.clock() - os_clock_ret) / EndScreenTiming.DURATION);
            workspace_CurrentCamera.CFrame = v261;
            workspace_CurrentCamera.Focus = v261;
        end), "Disconnect");

        return;
    end;

    local Start = TutorialEndScreenScene:FindFirstChild("Start");
    local End = TutorialEndScreenScene:FindFirstChild("End");

    if not (Start and End) then
        warn("[EndScreen] Missing Start or End part!");

        return;
    end;

    takeEndScreenCamera(Start.CFrame);
    local v262 = TweenService:Create(workspace_CurrentCamera, TweenInfo.new(EndScreenTiming.DURATION, Enum.EasingStyle.Linear), {
        CFrame = End.CFrame
    });
    v262:Play();
    u9:Add(v262, "Cancel");
end;

local function collectSnapshotFadeTargets(p263: userdata) -- Line: 1826
    -- upvalues: u2 (copy)
    local u264 = {};

    local function add(p265: userdata) -- Line: 1828
        -- upvalues: u2 (ref), u264 (copy)
        for i, v in u2 do
            if p265:IsA(i) then
                for _, v2 in v do
                    table.insert(u264, {
                        Instance = p265,
                        Property = v2,
                        Base = p265[v2]
                    });
                end;
            end;
        end;
    end;

    add(p263);

    for _, descendant in p263:GetDescendants() do
        add(descendant);
    end;

    return u264;
end;

local function fadeLeaderboardSnapshot(u266: table, p267: number, p268: number) -- Line: 1845
    -- upvalues: u9 (copy), TweenService (copy)
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = p267;

    local function apply(p269: number) -- Line: 1847
        -- upvalues: u266 (copy)
        for _, v in u266 do
            v.Instance[v.Property] = v.Base + (1 - v.Base) * p269;
        end;
    end;

    for _, v in u266 do
        v.Instance[v.Property] = v.Base + (1 - v.Base) * p267;
    end;

    NumberValue.Changed:Connect(apply);
    u9:Add(NumberValue, "Destroy");
    TweenService:Create(NumberValue, TweenInfo.new(0.5), {
        Value = p268
    }):Play();
end;

local function showLeaderboardSnapshot(p270: userdata) -- Line: 1860
    -- upvalues: Router (copy), UDim2_fromScale_ret (copy), collectSnapshotFadeTargets (copy), u9 (copy), fadeLeaderboardSnapshot (copy)
    local v271 = Router.broadcastRouter("CreateLeaderboardSnapshot");

    if not v271 then
        return nil;
    end;

    v271.Name = "LeaderboardSnapshot";
    v271.AnchorPoint = Vector2.new(0.5, 0.5);
    v271.Position = UDim2_fromScale_ret;
    v271.Size = UDim2.fromScale(v271.Size.X.Scale * 0.9, v271.Size.Y.Scale * 0.9);
    v271.ZIndex = 2;
    local v272 = collectSnapshotFadeTargets(v271);
    v271.Parent = p270;
    u9:Add(v271, "Destroy");
    fadeLeaderboardSnapshot(v272, 1, 0);

    return v272;
end;

local function closeAllActiveScenes() -- Line: 1885
    -- upvalues: MenuState (copy), Router (copy), PlayerGui (copy), CameraController (copy), ReplicatedStorage (copy)
    MenuState.SetBlurEnabled(false);

    if MenuState.IsCaseSceneActive() then
        Router.broadcastRouter("CaseSceneCloseForGameEnd");
    end;

    if MenuState.IsInspectActive() then
        Router.broadcastRouter("WeaponInspectCloseForGameEnd");
    end;

    if MenuState.IsTradeUpActive() then
        return;
    end;

    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Menu");
    end;

    if MainGui then
        if MainGui.Visible then
            MenuState.HideMenu();
            CameraController.setForceLockOverride("Menu", false);
        end;

        MainGui.BackgroundTransparency = 1;
    end;

    local MainGui2 = PlayerGui:FindFirstChild("MainGui");

    if MainGui2 then
        MainGui2 = MainGui2:FindFirstChild("Gameplay");
    end;

    if MainGui2 then
        MainGui2 = MainGui2:FindFirstChild("Middle");
    end;

    if not MainGui2 then
        return;
    end;

    local BuyMenu = MainGui2:FindFirstChild("BuyMenu");

    if BuyMenu and BuyMenu.Visible then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu).closeFrame();
    end;

    local TeamSelection = MainGui2:FindFirstChild("TeamSelection");

    if TeamSelection and TeamSelection.Visible then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection).closeFrame();
    end;
end;

function u1.IsActive() -- Line: 1933
    -- upvalues: u10 (ref)
    return u10;
end;

local function cacheLevelData(p273) -- Line: 1937
    -- upvalues: u16 (ref)
    if p273 then
        u16 = {
            Level = p273.Level,
            Experience = p273.Experience,
            NextExperienceRequirement = p273.NextExperienceRequirement
        };
    end;
end;

local function showMainMenuAfterEndScreen() -- Line: 1947
    -- upvalues: ReplicatedStorage (copy), PlayerGui (copy), CameraController (copy)
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
    local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
    MenuSceneController.ShowMenuScene();
    Top.ResetToMainMenu();
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if not MainGui then
        return;
    end;

    CameraController.setForceLockOverride("Menu", true);
    CameraController.setPerspective(true, true);
    MainGui.Menu.Visible = true;
    MainGui.Gameplay.Visible = false;
    MainGui.Gameplay.Bottom.Visible = false;
end;

function u1.ExitMapVoteToMenu() -- Line: 1967
    -- upvalues: u11 (ref), MenuState (copy), u10 (ref), u1 (copy), CameraController (copy), hideEndScreenUI (copy), showMainMenuAfterEndScreen (copy), u15 (ref), u13 (ref)
    if u11 then
        return;
    end;

    MenuState.SetWantsMainMenu(true);

    if u10 then
        u1._finishSequence(true);

        return;
    end;

    CameraController.setForceLockOverride("EndScreen", false);
    hideEndScreenUI();
    CameraController.SetEnabled(true);
    showMainMenuAfterEndScreen();
    u15 = nil;
    u13 = true;
end;

function u1._runSequence(u274: table) -- Line: 1986
    -- upvalues: u12 (ref), u13 (ref), u14 (ref), u11 (ref), cleanupDebris (copy), showEndScreenUI (copy), PlayerGui (copy), showLeaderboardSnapshot (copy), spawnEndScreenCharacters (copy), animateCamera (copy), populateLevelFrame (copy), fadeFrame (copy), fadeLeaderboardSnapshot (copy), fadeInFrame (copy), animateLevelBar (copy), displayDrops (copy), EndScreenTiming (copy), u1 (copy)
    u12 = u12 + 1;
    local u275 = u12;
    u13 = u274.returnToMenu;
    u14 = u274.overlayMode;
    u11 = u274.locked;
    cleanupDebris();
    showEndScreenUI(u274);
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Gameplay");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Middle");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("EndScreen");
    end;

    local v276;

    if MainGui then
        v276 = MainGui:FindFirstChild("Close");
    else
        v276 = MainGui;
    end;

    if v276 then
        v276.Visible = not u274.locked;
    end;

    local u277;

    if u274.showLeaderboard and MainGui then
        u277 = showLeaderboardSnapshot(MainGui);
    else
        u277 = nil;
    end;

    if not u274.showLeaderboard then
        local success, result = pcall(spawnEndScreenCharacters, u274.displayPlayers, u274.showAccolades);

        if not success then
            warn((`[EndScreen] Podium failed: {result}`));
        end;
    end;

    animateCamera();

    if u274.showProgression then
        task.delay(u274.showLeaderboard and 6 or 4, function() -- Line: 2018
            -- upvalues: u275 (copy), u12 (ref), PlayerGui (ref), populateLevelFrame (ref), u274 (copy), fadeFrame (ref), u277 (copy), fadeLeaderboardSnapshot (ref), fadeInFrame (ref), animateLevelBar (ref), displayDrops (ref)
            if u275 ~= u12 then
                return;
            end;

            local MainGui2 = PlayerGui:FindFirstChild("MainGui");

            if MainGui2 then
                MainGui2 = MainGui2:FindFirstChild("Gameplay");
            end;

            if MainGui2 then
                MainGui2 = MainGui2:FindFirstChild("Middle");
            end;

            if MainGui2 then
                MainGui2 = MainGui2:FindFirstChild("EndScreen");
            end;

            if not MainGui2 then
                return;
            end;

            local Victory = MainGui2:FindFirstChild("Victory");
            local Defeat = MainGui2:FindFirstChild("Defeat");
            local Level = MainGui2:FindFirstChild("Level");
            local u278 = populateLevelFrame(u274.xpEarned);
            local v279 = u274.isDraw and Victory and Victory or (u274.didWin and Victory and Victory or Defeat);

            if v279 and v279.Visible then
                fadeFrame(v279, 1);
            end;

            if u277 then
                fadeLeaderboardSnapshot(u277, 0, 1);
            end;

            task.delay(0.5, function() -- Line: 2042
                -- upvalues: u275 (ref), u12 (ref), Victory (copy), Defeat (copy), Level (copy), fadeInFrame (ref), u278 (copy), animateLevelBar (ref), displayDrops (ref), u274 (ref)
                if u275 ~= u12 then
                    return;
                end;

                if Victory then
                    Victory.Visible = false;
                end;

                if Defeat then
                    Defeat.Visible = false;
                end;

                if Level then
                    fadeInFrame(Level);
                    task.spawn(function() -- Line: 2057
                        -- upvalues: u278 (ref), animateLevelBar (ref), displayDrops (ref), u274 (ref)
                        if u278 then
                            animateLevelBar(u278);
                        end;

                        displayDrops(u274.levelRewards);
                    end);
                end;
            end);
        end);
    end;

    if u274.locked then
        return;
    end;

    task.delay(u274.sequenceDuration or (u274.showProgression and EndScreenTiming.DURATION or 4), function() -- Line: 2075
        -- upvalues: u275 (copy), u12 (ref), u1 (ref), u274 (copy)
        if u275 ~= u12 then
            return;
        end;

        u1._finishSequence(u274.returnToMenu);
    end);
end;

function u1._finishSequence(p280: boolean?) -- Line: 2083
    -- upvalues: u11 (ref), u13 (ref), u12 (ref), u14 (ref), u10 (ref), CameraController (copy), u9 (copy), hideEndScreenUI (copy), PlayerGui (copy), u15 (ref), restoreVisibilitySnapshot (copy), MenuState (copy), showMainMenuAfterEndScreen (copy), DataController (copy), LocalPlayer (copy), u16 (ref)
    if u11 then
        return;
    end;

    if p280 == nil then
        p280 = u13;
    end;

    if typeof(p280) ~= "boolean" then
        p280 = p280 and true or u13;
    end;

    u12 = u12 + 1;
    u14 = "EndScreen";
    u10 = false;
    CameraController.setForceLockOverride("EndScreen", false);
    u9:Cleanup();
    hideEndScreenUI();
    CameraController.SetEnabled(true);
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if p280 or not (MainGui and u15) then
        showMainMenuAfterEndScreen();
        u15 = nil;
        u13 = true;
    else
        restoreVisibilitySnapshot(MainGui, true);
        MenuState.HideMenu();
        MainGui.Gameplay.Visible = true;
        CameraController.setPerspective(true, false);
    end;

    local v281 = DataController.Get(LocalPlayer, "Level");

    if v281 then
        u16 = {
            Level = v281.Level,
            Experience = v281.Experience,
            NextExperienceRequirement = v281.NextExperienceRequirement
        };
    end;
end;

function u1.Begin(p282: table) -- Line: 2121
    -- upvalues: u11 (ref), u10 (ref), u1 (copy), MenuState (copy), Router (copy), LocalPlayer (copy), IsPlayingTeam (copy), collectPlayingPlayers (copy), u4 (copy), closeAllActiveScenes (copy), SpectateController (copy), CameraController (copy)
    if u11 then
        return;
    end;

    local v283 = p282.Halftime == true and "Halftime" or "EndScreen";

    if u10 then
        warn("[EndScreen] Interrupting active sequence for new end screen");
        local success, result = pcall(u1._finishSequence, false);

        if not success then
            warn("[EndScreen] _finishSequence error during interrupt: " .. tostring(result));
        end;

        u10 = false;
    end;

    if MenuState.IsTradeUpActive() then
        return;
    end;

    if MenuState.IsCaseSceneActive() and Router.broadcastRouter("IsCaseSceneRolling") == true then
        return;
    end;

    local v284 = workspace:GetAttribute("Gamemode") == "Deathmatch";
    local v285;

    if p282.Players then
        v285 = p282.Players[tostring(LocalPlayer.UserId)] or nil;
    else
        v285 = nil;
    end;

    if not v285 then
        warn(("[EndScreen] Local player missing from payload (userId=%s, teamAttr=%s, winningTeam=%s)"):format(tostring(LocalPlayer.UserId), tostring(LocalPlayer:GetAttribute("Team")), (tostring(p282.WinningTeam))));

        if not IsPlayingTeam(LocalPlayer:GetAttribute("Team")) or v284 then
            return;
        end;
    end;

    local v286 = v285 and v285.Team or LocalPlayer:GetAttribute("Team");
    local v287 = p282.Cooperative == true;
    local v288 = not v287 and p282.WinningTeam == "Draw";
    local v289 = nil;
    local v290, v291;

    if v284 then
        if not (v285 and IsPlayingTeam(v285.Team)) then
            if v285 then
                v285 = v285.Team;
            end;

            warn(("[EndScreen] Begin skipped for Deathmatch: invalid team data (team=%s)"):format((tostring(v285))));

            return;
        end;

        v290 = collectPlayingPlayers(p282.Players);
        table.sort(v290, function(p292, p293) -- Line: 299
            if (p292.data.Score or 0) ~= (p293.data.Score or 0) then
                return (p292.data.Score or 0) > (p293.data.Score or 0);
            end;

            if (p292.data.Kills or 0) ~= (p293.data.Kills or 0) then
                return (p292.data.Kills or 0) > (p293.data.Kills or 0);
            end;

            if (p292.data.Assists or 0) == (p293.data.Assists or 0) then
                return (tonumber(p292.userId) or (1 / 0)) < (tonumber(p293.userId) or (1 / 0));
            end;

            return (p292.data.Assists or 0) > (p293.data.Assists or 0);
        end);

        if #v290 == 0 then
            warn("[EndScreen] Begin skipped for Deathmatch: no eligible ranked players");

            return;
        end;

        local v294 = nil;

        for i, v in ipairs(v290) do
            if v.userId == tostring(LocalPlayer.UserId) then
                v294 = i;
                break;
            end;
        end;

        if not v294 then
            warn(("[EndScreen] Begin skipped for Deathmatch: local player missing from ranked list (userId=%s)"):format((tostring(LocalPlayer.UserId))));

            return;
        end;

        v291 = v294 == 1;
        local v295 = v294 % 100;
        v289 = `You placed {`{v294}{v295 >= 11 and v295 <= 13 and "th" or (u4[v294 % 10] or "th")}`}`;
    else
        if not IsPlayingTeam(v286) then
            warn(("[EndScreen] Begin skipped: invalid team (team=%s, teamAttr=%s, winningTeam=%s)"):format(tostring(v286), tostring(LocalPlayer:GetAttribute("Team")), (tostring(p282.WinningTeam))));

            return;
        end;

        if v287 then
            v291 = p282.CooperativeVictory == true;
        else
            v291 = not v288 and p282.WinningTeam == v286;
        end;

        local v296 = {};

        for i, v in pairs(p282.Players) do
            if v.Team == v286 then
                v296[i] = v;
            end;
        end;

        v290 = collectPlayingPlayers(v296);
        table.sort(v290, function(p297, p298) -- Line: 282
            if (p297.data.ADR or 0) ~= (p298.data.ADR or 0) then
                return (p297.data.ADR or 0) > (p298.data.ADR or 0);
            end;

            if (p297.data.Score or 0) == (p298.data.Score or 0) then
                return (tonumber(p297.userId) or (1 / 0)) < (tonumber(p298.userId) or (1 / 0));
            end;

            return (p297.data.Score or 0) > (p298.data.Score or 0);
        end);
    end;

    closeAllActiveScenes();
    SpectateController.Stop(false, true);
    CameraController.SetEnabled(false);
    u10 = true;
    local v299 = {};

    for i in pairs(p282.Players) do
        local v300 = tonumber(i);

        if v300 then
            table.insert(v299, v300);
        end;
    end;

    table.sort(v299);
    local v301 = {};

    for _, v in ipairs(v299) do
        local v302 = p282.Players[tostring(v)];

        if v302 then
            v302 = v302.LevelRewards;
        end;

        if v302 then
            local v303 = v;

            for _, v2 in ipairs(v302) do
                table.insert(v301, {
                    userId = v303,
                    reward = v2
                });
            end;
        end;
    end;

    u1._runSequence({
        displayPlayers = v290,
        didWin = v291,
        isDraw = v288,
        winningTeam = p282.WinningTeam,
        xpEarned = v285 and v285.ExperienceEarned or 0,
        levelRewards = v301,
        ctScore = p282.CTScore or 0,
        tScore = p282.TScore or 0,
        scoreTextOverride = v289,
        hideScore = v287,
        showAccolades = p282.ShowAccolades ~= false,
        showLeaderboard = v287,
        showProgression = p282.ShowProgression ~= false,
        sequenceDuration = p282.SequenceDuration,
        returnToMenu = p282.ReturnToMenu ~= false,
        overlayMode = v283,
        halftimeTeam = v286,
        locked = p282.Locked == true
    });
end;

function u1.Initialize() -- Line: 2289
    -- upvalues: Router (copy), u1 (copy), PlayerGui (copy), ActivateButton (copy), CloseButtonRegistry (copy), u10 (ref), MenuState (copy), GameState (copy), DataController (copy), LocalPlayer (copy), u16 (ref), Remotes (copy)
    Router.observerRouter("IsEndScreenActive", u1.IsActive);
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("Gameplay");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Middle");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("EndScreen");
    end;

    if MainGui then
        local Drops = MainGui:FindFirstChild("Drops");

        if Drops then
            Drops.Visible = false;
        end;

        local Close = MainGui:FindFirstChild("Close");

        if Close then
            ActivateButton(Close);
            CloseButtonRegistry.Add(MainGui, Close, function() -- Line: 2303
                -- upvalues: u10 (ref), MenuState (ref), u1 (ref), GameState (ref)
                if not u10 then
                    if GameState.GetState() == "Map Voting" then
                        u1.ExitMapVoteToMenu();
                    end;

                    return;
                end;

                MenuState.SetWantsMainMenu(true);
                u1._finishSequence(true);
            end);
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Level", function(p304) -- Line: 2316
        -- upvalues: u16 (ref)
        if u16 == nil and p304 then
            u16 = {
                Level = p304.Level,
                Experience = p304.Experience,
                NextExperienceRequirement = p304.NextExperienceRequirement
            };
        end;
    end);
    Remotes.Match.EndScreen.Listen(function(p305: table) -- Line: 2322
        -- upvalues: u1 (ref)
        u1.Begin(p305);
    end);
end;

return u1;