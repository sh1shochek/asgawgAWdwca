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
local u2 = { 3, 2, 4, 1, 5 };
local u3 = { "st", "nd", "rd" };
local u4 = CFrame.new(-0.251, 0.806, -0.406) * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local workspace_CurrentCamera = workspace.CurrentCamera;
local Characters = ReplicatedStorage.Assets.Characters;
local u5 = { {
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
local u6 = {
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
local u7 = {
    ["Counter-Terrorists"] = "CT",
    Terrorists = "T"
};
local u8 = Janitor.new();
local u9 = false;
local u10 = false;
local u11 = 0;
local u12 = true;
local u13 = "EndScreen";
local u14 = nil;
local u15 = nil;
local u16 = {
    RoundWonCT = true,
    RoundWonT = true,
    RoundLost = true,
    PlayerMVPCT = true,
    PlayerMVPT = true,
    MissionCompleted = true
};
local u17 = {
    MobileButtons = true
};

local function getOrdinalPlacementText(p18: number) -- Line: 222
    -- upvalues: u3 (copy)
    local v19 = p18 % 100;

    return `{p18}{v19 >= 11 and v19 <= 13 and "th" or (u3[p18 % 10] or "th")}`;
end;

local function collectPlayingPlayers(p20: table) -- Line: 228
    -- upvalues: IsPlayingTeam (copy)
    local v21 = {};

    for i, v in pairs(p20) do
        if IsPlayingTeam(v.Team) then
            table.insert(v21, {
                userId = i,
                data = v
            });
        end;
    end;

    return v21;
end;

local function sortPlayersByADR(p22: table) -- Line: 238
    -- upvalues: collectPlayingPlayers (copy)
    local v23 = collectPlayingPlayers(p22);
    table.sort(v23, function(p24, p25) -- Line: 240
        if (p24.data.ADR or 0) ~= (p25.data.ADR or 0) then
            return (p24.data.ADR or 0) > (p25.data.ADR or 0);
        end;

        if (p24.data.Score or 0) == (p25.data.Score or 0) then
            return (tonumber(p24.userId) or (1 / 0)) < (tonumber(p25.userId) or (1 / 0));
        end;

        return (p24.data.Score or 0) > (p25.data.Score or 0);
    end);

    return v23;
end;

local function rankFFAPlayers(p26: table) -- Line: 255
    -- upvalues: collectPlayingPlayers (copy)
    local v27 = collectPlayingPlayers(p26);
    table.sort(v27, function(p28, p29) -- Line: 257
        if (p28.data.Score or 0) ~= (p29.data.Score or 0) then
            return (p28.data.Score or 0) > (p29.data.Score or 0);
        end;

        if (p28.data.Kills or 0) ~= (p29.data.Kills or 0) then
            return (p28.data.Kills or 0) > (p29.data.Kills or 0);
        end;

        if (p28.data.Assists or 0) == (p29.data.Assists or 0) then
            return (tonumber(p28.userId) or (1 / 0)) < (tonumber(p29.userId) or (1 / 0));
        end;

        return (p28.data.Assists or 0) > (p29.data.Assists or 0);
    end);

    return v27;
end;

local function cleanupDebris() -- Line: 275
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

local function getMiddleFrame() -- Line: 290
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

local function getEndScreenFrame() -- Line: 296
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

local function getEndScreenModel() -- Line: 301
    local TutorialEndScreenScene = workspace:FindFirstChild("TutorialEndScreenScene");

    if TutorialEndScreenScene then
        TutorialEndScreenScene = TutorialEndScreenScene:FindFirstChild("EndScreen");
    end;

    if TutorialEndScreenScene then
        return TutorialEndScreenScene;
    end;

    local v30 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EndScreen");

    return v30;
end;

local function isPanel(p31: userdata) -- Line: 311
    return p31:IsA("Frame") or p31:IsA("CanvasGroup");
end;

local function setChildVisible(p32: userdata, p33: string, p34: boolean) -- Line: 315
    local v35 = p32:FindFirstChild(p33);

    if v35 then
        v35.Visible = p34;
    end;
end;

local function getTransparencyProperty(p36: userdata) -- Line: 322
    return (p36:IsA("TextLabel") or p36:IsA("TextButton")) and "TextTransparency" or ((p36:IsA("ImageLabel") or p36:IsA("ImageButton")) and "ImageTransparency" or (p36:IsA("Frame") and "BackgroundTransparency" or (p36:IsA("UIStroke") and "Transparency" or nil)));
end;

local function setElementTransparency(p37: userdata, p38: number) -- Line: 335
    -- upvalues: getTransparencyProperty (copy)
    local v39 = getTransparencyProperty(p37);

    if v39 then
        p37[v39] = p38;
    end;
end;

local function tweenElementTransparency(p40: userdata, p41: number) -- Line: 342
    -- upvalues: getTransparencyProperty (copy), TweenService (copy)
    local v42 = getTransparencyProperty(p40);

    if v42 then
        TweenService:Create(p40, TweenInfo.new(0.5), {
            [v42] = p41
        }):Play();
    end;
end;

local function shouldSkipFade(p43: userdata) -- Line: 349
    if p43:GetAttribute("SkipFade") then
        return true;
    end;

    local Parent = p43.Parent;

    while Parent and Parent:IsA("GuiObject") do
        if Parent:GetAttribute("SkipFade") then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function fadeFrame(p44: userdata, p45: number) -- Line: 363
    -- upvalues: shouldSkipFade (copy), TweenService (copy), tweenElementTransparency (copy)
    local v46;

    if shouldSkipFade(p44) then
        v46 = nil;
    else
        v46 = TweenService:Create(p44, TweenInfo.new(0.5), {
            BackgroundTransparency = p45
        });
    end;

    for _, descendant in p44:GetDescendants() do
        if not shouldSkipFade(descendant) then
            tweenElementTransparency(descendant, p45);
        end;
    end;

    if v46 then
        v46:Play();
    end;

    return v46;
end;

local function fadeInFrame(p47: userdata) -- Line: 383
    -- upvalues: shouldSkipFade (copy), getTransparencyProperty (copy), fadeFrame (copy)
    if not shouldSkipFade(p47) then
        p47.BackgroundTransparency = 1;
    end;

    for _, descendant in p47:GetDescendants() do
        if not shouldSkipFade(descendant) then
            local v48 = getTransparencyProperty(descendant);

            if v48 then
                descendant[v48] = 1;
            end;
        end;
    end;

    p47.Visible = true;

    return fadeFrame(p47, 0);
end;

local function getBarTweenInfo(p49: boolean?) -- Line: 404
    return TweenInfo.new(p49 and 0.375 or 0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
end;

local function playInterfaceSound(p50: string, p51: number?) -- Line: 409
    -- upvalues: Sound (copy), workspace_CurrentCamera (copy)
    local v52 = Sound.new("Interface"):play({
        Parent = workspace_CurrentCamera,
        Name = p50
    });

    if v52 and p51 then
        v52.PlaybackSpeed = p51;
    end;
end;

local function createBarSize(p53: number, p54) -- Line: 436
    return UDim2.new(p53, 0, p54.Scale, p54.Offset);
end;

local function setChildText(p55: userdata, p56: string, p57: string) -- Line: 440
    local v58 = p55:FindFirstChild(p56);

    if v58 then
        v58.Text = p57;
    end;
end;

local function storeFrameTransparency(p59: userdata) -- Line: 452
    local v60 = {};

    for _, descendant in p59:GetDescendants() do
        if descendant:IsA("UIStroke") then
            v60[descendant] = descendant.Transparency;
        end;
    end;

    return {
        BackgroundTransparency = p59.BackgroundTransparency,
        Strokes = v60
    };
end;

local function restoreFrameTransparency(p61: userdata, p62: table) -- Line: 465
    p61.BackgroundTransparency = p62.BackgroundTransparency;

    for i, v in pairs(p62.Strokes) do
        if i and i.Parent then
            i.Transparency = v;
        end;
    end;
end;

local function setRankDisplay(p63: userdata, p64: number) -- Line: 474
    -- upvalues: GetRankTitle (copy), LevelsIcon (copy)
    local v65 = `[{GetRankTitle(p64)} Rank {p64}]`;
    local TextLabel = p63:FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = v65;
    end;

    local Rank = p63:FindFirstChild("Rank");

    if Rank then
        Rank.Image = LevelsIcon[tostring(p64)] or "";
    end;
end;

local function populateLevelFrame(p66: number) -- Line: 483
    -- upvalues: PlayerGui (copy), u15 (ref), DataController (copy), LocalPlayer (copy), GetRankTitle (copy), LevelsIcon (copy), storeFrameTransparency (copy)
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

    local v67 = u15 or DataController.Get(LocalPlayer, "Level");

    if not v67 then
        return nil;
    end;

    local v68 = v67.Level or 1;
    local v69 = v67.Experience or 0;
    local v70 = v67.NextExperienceRequirement or 1000;
    local v71 = `[{GetRankTitle(v68)} Rank {v68}]`;
    local TextLabel = Level:FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = v71;
    end;

    local Rank = Level:FindFirstChild("Rank");

    if Rank then
        Rank.Image = LevelsIcon[tostring(v68)] or "";
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

    local v72 = `{v69}xp`;
    local Amount = CurrentInfo:FindFirstChild("Amount");

    if Amount then
        Amount.Text = v72;
    end;

    local v73 = `+{p66}xp`;
    local Amount2 = EarnedInfo:FindFirstChild("Amount");

    if Amount2 then
        Amount2.Text = v73;
    end;

    return {
        currentXP = v69,
        xpEarned = p66,
        nextLevelXP = math.max(v70, 1),
        currentLevel = v68,
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

local function calcInfoXOffset(p74: userdata, p75: userdata, p76: number) -- Line: 548
    local Parent = p75.Parent;

    return p74.AbsolutePosition.X + p76 * p74.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + p75.AnchorPoint.X * p75.AbsoluteSize.X;
end;

local function tweenInfoToBarEnd(p77: userdata, p78: userdata, p79: number, p80: userdata) -- Line: 560
    -- upvalues: TweenService (copy)
    local Position = p77.Position;
    local Parent = p77.Parent;

    return TweenService:Create(p77, p80, {
        Position = UDim2.new(0, p78.AbsolutePosition.X + p79 * p78.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + p77.AnchorPoint.X * p77.AbsoluteSize.X, Position.Y.Scale, Position.Y.Offset)
    });
end;

local function wouldOverlap(p81: userdata, p82: userdata, p83: number) -- Line: 570
    return p82.Parent.AbsolutePosition.X + p83 - p82.AnchorPoint.X * p82.AbsoluteSize.X < p81.AbsolutePosition.X + p81.AbsoluteSize.X + 5;
end;

local function calcInfoTopAlignedYOffset(p84: userdata, p85: number) -- Line: 578
    local Parent = p84.Parent;

    return p85 - (Parent and Parent.AbsolutePosition.Y or 0) + p84.AnchorPoint.Y * p84.AbsoluteSize.Y;
end;

local function getAdjustedEarnedPosition(p86: userdata, p87: userdata, p88: number) -- Line: 585
    local Y = p86.AbsolutePosition.Y;

    if p87.Parent.AbsolutePosition.X + p88 - p87.AnchorPoint.X * p87.AbsoluteSize.X < p86.AbsolutePosition.X + p86.AbsoluteSize.X + 5 then
        Y = Y + p86.AbsoluteSize.Y + -2;
    end;

    local Parent = p87.Parent;

    return UDim2.new(0, p88, 0, Y - (Parent and Parent.AbsolutePosition.Y or 0) + p87.AnchorPoint.Y * p87.AbsoluteSize.Y);
end;

local function playBarTween(p89: userdata, p90, p91: userdata, p92: userdata, p93: boolean, p94: number?) -- Line: 596
    -- upvalues: TweenService (copy), Sound (copy), workspace_CurrentCamera (copy)
    local v95 = TweenService:Create(p89, p91, {
        Size = p90
    });

    if p93 then
        local v96 = Sound.new("Interface"):play({
            Name = "XP Bar Fill",
            Parent = workspace_CurrentCamera
        });

        if v96 and p94 then
            v96.PlaybackSpeed = p94;
        end;
    end;

    v95:Play();
    p92:Play();
    v95.Completed:Wait();
end;

local function tweenInfoToBarEndWithOverlapCheck(p97: userdata, p98: userdata, p99: userdata, p100: number, p101: userdata) -- Line: 613
    -- upvalues: TweenService (copy)
    local Parent = p97.Parent;
    local v102 = p99.AbsolutePosition.X + p100 * p99.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + p97.AnchorPoint.X * p97.AbsoluteSize.X;
    local Y = p98.AbsolutePosition.Y;

    if p97.Parent.AbsolutePosition.X + v102 - p97.AnchorPoint.X * p97.AbsoluteSize.X < p98.AbsolutePosition.X + p98.AbsoluteSize.X + 5 then
        Y = Y + p98.AbsoluteSize.Y + -2;
    end;

    local Parent2 = p97.Parent;

    return TweenService:Create(p97, p101, {
        Position = UDim2.new(0, v102, 0, Y - (Parent2 and Parent2.AbsolutePosition.Y or 0) + p97.AnchorPoint.Y * p97.AbsoluteSize.Y)
    });
end;

local function animateLevelBar(p103: table) -- Line: 625
    -- upvalues: u9 (ref), tweenInfoToBarEnd (copy), playBarTween (copy), tweenInfoToBarEndWithOverlapCheck (copy), Sound (copy), workspace_CurrentCamera (copy), GetRankTitle (copy), LevelsIcon (copy), TweenService (copy)
    if not u9 then
        return;
    end;

    local math_clamp_ret = math.clamp(p103.currentXP / p103.nextLevelXP, 0, 1);
    local v104 = p103.currentXP + p103.xpEarned;
    local math_clamp_ret2 = math.clamp(v104 / p103.nextLevelXP, 0, 1);
    local v105 = p103.nextLevelXP <= v104;
    p103.currentBar.Visible = false;
    p103.earnedBar.Visible = false;
    local barHeight = p103.barHeight;
    p103.currentBar.Size = UDim2.new(0, 0, barHeight.Scale, barHeight.Offset);
    local barHeight2 = p103.barHeight;
    p103.earnedBar.Size = UDim2.new(0, 0, barHeight2.Scale, barHeight2.Offset);
    p103.currentInfo.Visible = false;
    p103.earnedInfo.Visible = false;
    local currentInfoTransparency = p103.currentInfoTransparency;
    p103.currentInfo.BackgroundTransparency = currentInfoTransparency.BackgroundTransparency;

    for i, v in pairs(currentInfoTransparency.Strokes) do
        if i and i.Parent then
            i.Transparency = v;
        end;
    end;

    local earnedInfoTransparency = p103.earnedInfoTransparency;
    p103.earnedInfo.BackgroundTransparency = earnedInfoTransparency.BackgroundTransparency;

    for i, v in pairs(earnedInfoTransparency.Strokes) do
        if i and i.Parent then
            i.Transparency = v;
        end;
    end;

    local levelBar = p103.levelBar;
    local currentInfo = p103.currentInfo;
    local Parent = currentInfo.Parent;
    local levelBar2 = p103.levelBar;
    local earnedInfo = p103.earnedInfo;
    local Parent2 = earnedInfo.Parent;
    local v106 = levelBar2.AbsolutePosition.X + 0 * levelBar2.AbsoluteSize.X - (Parent2 and Parent2.AbsolutePosition.X or 0) + earnedInfo.AnchorPoint.X * earnedInfo.AbsoluteSize.X;
    local Position = p103.currentInfo.Position;
    local Position2 = p103.earnedInfo.Position;
    p103.currentInfo.Position = UDim2.new(0, levelBar.AbsolutePosition.X + 0 * levelBar.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + currentInfo.AnchorPoint.X * currentInfo.AbsoluteSize.X, Position.Y.Scale, Position.Y.Offset);
    p103.earnedInfo.Position = UDim2.new(0, v106, Position2.Y.Scale, Position2.Y.Offset);
    task.wait(0.5);

    if not u9 then
        return;
    end;

    p103.currentBar.Visible = true;
    p103.currentInfo.Visible = true;

    if math_clamp_ret > 0 then
        local TweenInfo_new_ret = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
        local v107 = tweenInfoToBarEnd(p103.currentInfo, p103.levelBar, math_clamp_ret, TweenInfo_new_ret);
        local barHeight3 = p103.barHeight;
        playBarTween(p103.currentBar, UDim2.new(math_clamp_ret, 0, barHeight3.Scale, barHeight3.Offset), TweenInfo_new_ret, v107, true);

        if not u9 then
            return;
        end;
    end;

    if p103.xpEarned <= 0 then
        return;
    end;

    task.wait(0.6);

    if not u9 then
        return;
    end;

    local barHeight3 = p103.barHeight;
    p103.earnedBar.Size = UDim2.new(math_clamp_ret, 0, barHeight3.Scale, barHeight3.Offset);
    p103.earnedBar.Visible = true;
    p103.earnedInfo.Visible = true;
    local levelBar3 = p103.levelBar;
    local earnedInfo2 = p103.earnedInfo;
    local Parent3 = earnedInfo2.Parent;
    local v108 = levelBar3.AbsolutePosition.X + math_clamp_ret * levelBar3.AbsoluteSize.X - (Parent3 and Parent3.AbsolutePosition.X or 0) + earnedInfo2.AnchorPoint.X * earnedInfo2.AbsoluteSize.X;
    local currentInfo2 = p103.currentInfo;
    local earnedInfo3 = p103.earnedInfo;
    local Y = currentInfo2.AbsolutePosition.Y;

    if earnedInfo3.Parent.AbsolutePosition.X + v108 - earnedInfo3.AnchorPoint.X * earnedInfo3.AbsoluteSize.X < currentInfo2.AbsolutePosition.X + currentInfo2.AbsoluteSize.X + 5 then
        Y = Y + currentInfo2.AbsoluteSize.Y + -2;
    end;

    local Parent4 = earnedInfo3.Parent;
    local UDim2_new_ret = UDim2.new(0, v108, 0, Y - (Parent4 and Parent4.AbsolutePosition.Y or 0) + earnedInfo3.AnchorPoint.Y * earnedInfo3.AbsoluteSize.Y);
    p103.earnedInfo.Position = UDim2_new_ret;

    if not v105 then
        local TweenInfo_new_ret = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
        local v109 = tweenInfoToBarEndWithOverlapCheck(p103.earnedInfo, p103.currentInfo, p103.levelBar, math_clamp_ret2, TweenInfo_new_ret);
        local barHeight4 = p103.barHeight;
        playBarTween(p103.earnedBar, UDim2.new(math_clamp_ret2, 0, barHeight4.Scale, barHeight4.Offset), TweenInfo_new_ret, v109, true, 1.15);

        return;
    end;

    local TweenInfo_new_ret = TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
    local v110 = tweenInfoToBarEndWithOverlapCheck(p103.earnedInfo, p103.currentInfo, p103.levelBar, 1, TweenInfo_new_ret);
    local barHeight4 = p103.barHeight;
    playBarTween(p103.earnedBar, UDim2.new(1, 0, barHeight4.Scale, barHeight4.Offset), TweenInfo_new_ret, v110, true, 1.15);

    if not u9 then
        return;
    end;

    Sound.new("Interface"):play({
        Name = "Level Up",
        Parent = workspace_CurrentCamera
    });
    local math_clamp_ret3 = math.clamp((v104 - p103.nextLevelXP) / p103.nextLevelXP, 0, 1);
    local levelFrame = p103.levelFrame;
    local v111 = p103.currentLevel + 1;
    local v112 = `[{GetRankTitle(v111)} Rank {v111}]`;
    local TextLabel = levelFrame:FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = v112;
    end;

    local Rank = levelFrame:FindFirstChild("Rank");

    if Rank then
        Rank.Image = LevelsIcon[tostring(v111)] or "";
    end;

    local barHeight5 = p103.barHeight;
    p103.currentBar.Size = UDim2.new(0, 0, barHeight5.Scale, barHeight5.Offset);
    local barHeight6 = p103.barHeight;
    p103.earnedBar.Size = UDim2.new(0, 0, barHeight6.Scale, barHeight6.Offset);
    p103.currentInfo.Visible = false;
    local levelBar4 = p103.levelBar;
    local earnedInfo4 = p103.earnedInfo;
    local Parent5 = earnedInfo4.Parent;
    local earnedInfo5 = p103.earnedInfo;
    local Parent6 = earnedInfo5.Parent;
    p103.earnedInfo.Position = UDim2.new(0, levelBar4.AbsolutePosition.X + 0 * levelBar4.AbsoluteSize.X - (Parent5 and Parent5.AbsolutePosition.X or 0) + earnedInfo4.AnchorPoint.X * earnedInfo4.AbsoluteSize.X, 0, p103.currentInfo.AbsolutePosition.Y - (Parent6 and Parent6.AbsolutePosition.Y or 0) + earnedInfo5.AnchorPoint.Y * earnedInfo5.AbsoluteSize.Y);
    local v113 = tweenInfoToBarEnd(p103.earnedInfo, p103.levelBar, math_clamp_ret3, TweenInfo_new_ret);
    local barHeight7 = p103.barHeight;
    local v114 = TweenService:Create(p103.earnedBar, TweenInfo_new_ret, {
        Size = UDim2.new(math_clamp_ret3, 0, barHeight7.Scale, barHeight7.Offset)
    });
    v114:Play();
    v113:Play();
    v114.Completed:Wait();
end;

local function scaleUDim2(p115, p116: number) -- Line: 755
    return UDim2.new(p115.X.Scale * p116, p115.X.Offset * p116, p115.Y.Scale * p116, p115.Y.Offset * p116);
end;

local function getItemIcon(p117: table) -- Line: 764
    -- upvalues: Cases (copy), Skins (copy)
    local v118 = not p117.Type and "" or string.lower(p117.Type);
    local Name = p117.Name;

    if v118 == "credits" then
        return "rbxassetid://115958498634807";
    end;

    if v118 == "case" or (v118 == "sticker capsule" or (v118 == "charm pack" or v118 == "charm capsule")) then
        local CaseByName = Cases.GetCaseByName(Name);

        if CaseByName and CaseByName.imageAssetId then
            return CaseByName.imageAssetId;
        end;
    end;

    local v119 = p117.Skin and (Name and Skins.GetSkinInformation(Name, p117.Skin));

    if v119 then
        if v119.wearImages and v119.wearImages[1] then
            return v119.wearImages[1].assetId;
        end;

        if v119.charmImages and v119.charmImages[1] then
            return v119.charmImages[1].assetId;
        end;

        if v119.imageAssetId then
            return v119.imageAssetId;
        end;
    end;

    return "rbxassetid://18822070027";
end;

local function clearDropItems(p120: userdata) -- Line: 807
    for _, child in p120:GetChildren() do
        if child:IsA("Frame") and child.Name ~= "ItemTemplate" then
            child:Destroy();
        end;
    end;
end;

local function displayDrops(p121: table) -- Line: 815
    -- upvalues: u9 (ref), PlayerGui (copy), clearDropItems (copy), getItemIcon (copy), Rarities (copy), fadeInFrame (copy), TweenService (copy), u8 (copy)
    if not (u9 and (p121 and #p121 ~= 0)) then
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
    local v122;

    if Drops then
        v122 = Drops:FindFirstChild("Container");
    else
        v122 = Drops;
    end;

    local v123;

    if v122 then
        v123 = v122:FindFirstChild("ItemTemplate");
    else
        v123 = v122;
    end;

    if not v123 then
        return;
    end;

    v122:SetAttribute("SkipFade", true);
    v123.Visible = false;
    clearDropItems(v122);
    Drops.Visible = false;
    task.wait(0.8);

    if not u9 then
        return;
    end;

    local v124 = {};

    for i, v in ipairs(p121) do
        local reward = v.reward;
        local v125 = reward.type == "credits";
        local inventoryItem = reward.inventoryItem;

        if v125 or inventoryItem then
            local v126 = v123:Clone();
            v126.Name = "Drop_" .. i;
            v126.Visible = false;
            v126.Parent = v122;
            local Content = v126:FindFirstChild("Content");

            if Content then
                local Icon = Content:FindFirstChild("Icon");

                if Icon then
                    Icon.Image = v125 and "rbxassetid://115958498634807" or getItemIcon(inventoryItem);
                end;

                local v127 = Content:FindFirstChild("amount") or Content:FindFirstChild("Amount");

                if v127 then
                    if v125 and reward.amount then
                        v127.Visible = true;
                        v127.Text = `x{reward.amount}`;
                    else
                        v127.Visible = false;
                    end;
                end;

                local RarityFrame = Content:FindFirstChild("RarityFrame");

                if RarityFrame then
                    RarityFrame = RarityFrame:FindFirstChild("UIGradient");
                end;

                if RarityFrame then
                    if v125 then
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
                local Player = v126:FindFirstChild("Player", true);

                if Player and v.userId > 0 then
                    Player.Image = `rbxthumb://type=AvatarHeadShot&id={v.userId}&w=150&h=150`;
                end;

                table.insert(v124, {
                    item = v126,
                    content = Content,
                    originalSize = Size
                });
            else
                v126:Destroy();
            end;
        end;
    end;

    if #v124 == 0 then
        return;
    end;

    fadeInFrame(Drops);
    task.wait(0.5);

    if not u9 then
        return;
    end;

    local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out);

    for i, v in ipairs(v124) do
        task.delay((i - 1) * 0.35, function() -- Line: 918
            -- upvalues: u9 (ref), v (copy), TweenService (ref), TweenInfo_new_ret (copy), u8 (ref)
            if not u9 then
                return;
            end;

            v.item.Visible = true;
            local v128 = TweenService:Create(v.content, TweenInfo_new_ret, {
                Size = v.originalSize
            });
            u8:Add(v128, "Cancel");
            v128:Play();
        end);
    end;
end;

local function recordPanelVisibility(p129: userdata?, p130: table) -- Line: 931
    if p129 then
        for _, child in p129:GetChildren() do
            if child:IsA("Frame") or child:IsA("CanvasGroup") then
                p130[child.Name] = child.Visible;
            end;
        end;
    end;
end;

local function applyPanelVisibility(p131: userdata, p132: table, p133: table?) -- Line: 941
    for _, child in p131:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            local v134 = p132[child.Name];

            if v134 ~= nil and not (p133 and p133[child.Name]) then
                child.Visible = v134;
            end;
        end;
    end;
end;

local function captureVisibilitySnapshot(p135: userdata) -- Line: 952
    -- upvalues: recordPanelVisibility (copy), u14 (ref)
    local Gameplay = p135:FindFirstChild("Gameplay");
    local Menu = p135:FindFirstChild("Menu");
    local v136;

    if Gameplay then
        v136 = Gameplay:FindFirstChild("Middle") or nil;
    else
        v136 = nil;
    end;

    local v137 = {};
    local v138;

    if Gameplay then
        v138 = Gameplay.Visible or false;
    else
        v138 = false;
    end;

    v137.GameplayVisible = v138;
    v137.MenuVisible = Menu and Menu.Visible or false;
    v137.GameplayChildren = {};
    v137.MiddleChildren = {};
    recordPanelVisibility(Gameplay, v137.GameplayChildren);
    recordPanelVisibility(v136, v137.MiddleChildren);
    u14 = v137;
end;

local function restoreVisibilitySnapshot(p139: userdata, p140: boolean?) -- Line: 969
    -- upvalues: u14 (ref), applyPanelVisibility (copy), u17 (copy), u16 (copy)
    if not u14 then
        return;
    end;

    local v141 = u14;
    u14 = nil;
    local Gameplay = p139:FindFirstChild("Gameplay");
    local Menu = p139:FindFirstChild("Menu");
    local v142;

    if Gameplay then
        v142 = Gameplay:FindFirstChild("Middle") or nil;
    else
        v142 = nil;
    end;

    if Menu then
        Menu.Visible = v141.MenuVisible;
    end;

    if Gameplay then
        Gameplay.Visible = v141.GameplayVisible;
        applyPanelVisibility(Gameplay, v141.GameplayChildren);
    end;

    if v142 then
        applyPanelVisibility(v142, v141.MiddleChildren, u17);

        if p140 then
            for i in pairs(u16) do
                local v143 = v142:FindFirstChild(i);

                if v143 and (v143:IsA("Frame") or v143:IsA("CanvasGroup")) then
                    v143.Visible = false;
                end;
            end;
        end;
    end;
end;

local function enforceEndScreenVisibility(p144: userdata) -- Line: 1004
    -- upvalues: u13 (ref), MenuState (copy)
    local v145 = u13 == "Halftime";

    if p144:FindFirstChild("Menu") then
        MenuState.HideMenu();
    end;

    local Gameplay = p144:FindFirstChild("Gameplay");

    if not Gameplay then
        return;
    end;

    local Middle = Gameplay:FindFirstChild("Middle");
    local v146;

    if Middle then
        v146 = Middle:FindFirstChild("EndScreen") or nil;
    else
        v146 = nil;
    end;

    local v147;

    if Middle then
        v147 = Middle:FindFirstChild("Halftime") or nil;
    else
        v147 = nil;
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
            if child == v146 then
                child.Visible = not v145;
            elseif child == v147 then
                child.Visible = v145;
            else
                child.Visible = false;
            end;
        end;
    end;

    if v146 then
        v146.Visible = not v145;
    end;

    if v147 then
        v147.Visible = v145;
    end;
end;

local u148 = {
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

local function hidePanels(p149: userdata) -- Line: 1071
    for _, child in p149:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            child.Visible = false;
        end;
    end;
end;

local function setupResultFrame(p150: userdata?, p151: boolean, p152: any, p153: string, p154: string) -- Line: 1080
    -- upvalues: getTransparencyProperty (copy)
    if not p150 then
        return;
    end;

    p150.BackgroundTransparency = 0;

    for _, descendant in p150:GetDescendants() do
        local v155 = getTransparencyProperty(descendant);

        if v155 then
            descendant[v155] = 0;
        end;
    end;

    p150.Visible = p151;
    local Score = p150:FindFirstChild("Score");

    if Score then
        Score.BackgroundColor3 = p152.Background;
        local Glow = Score:FindFirstChild("Glow");

        if Glow and Glow:IsA("ImageLabel") then
            Glow.ImageColor3 = p152.Glow;
        end;

        local Pattern = Score:FindFirstChild("Pattern");

        if Pattern and Pattern:IsA("ImageLabel") then
            Pattern.ImageColor3 = p152.Pattern;
        end;

        local v156 = Score:FindFirstChildOfClass("UIStroke");

        if v156 then
            v156.Color = p152.Stroke;
        end;

        local TextLabel = Score:FindFirstChild("TextLabel");

        if TextLabel then
            TextLabel.Text = p153;
        end;
    end;

    local TextLabel = p150:FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = p154;
    end;
end;

local function bindVisibilityLock(u157: userdata) -- Line: 1119
    -- upvalues: u8 (copy), RunServiceController (copy), enforceEndScreenVisibility (copy)
    u8:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1121
        -- upvalues: enforceEndScreenVisibility (ref), u157 (copy)
        enforceEndScreenVisibility(u157);
    end), "Disconnect", "EndScreenVisibilityLock");
end;

local function showEndScreenUI(p158: table) -- Line: 1129
    -- upvalues: PlayerGui (copy), captureVisibilitySnapshot (copy), CameraController (copy), IsPlayingTeam (copy), Halftime (copy), u8 (copy), RunServiceController (copy), enforceEndScreenVisibility (copy), setupResultFrame (copy), u148 (copy)
    local isDraw = p158.isDraw;
    local didWin = p158.didWin;
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

    if p158.overlayMode == "Halftime" then
        if EndScreen then
            EndScreen.Visible = false;
        end;

        if Middle:FindFirstChild("Halftime") and IsPlayingTeam(p158.halftimeTeam) then
            Halftime.Show(p158.halftimeTeam);
        else
            Halftime.Hide();
        end;

        u8:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1121
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
    local tScore = p158.tScore;
    local ctScore = p158.ctScore;

    if isDraw or p158.winningTeam == "Counter-Terrorists" then
        tScore = p158.ctScore;
        ctScore = p158.tScore;
    end;

    local v159 = p158.scoreTextOverride or `<b>{tScore}</b> - {ctScore}`;
    setupResultFrame(EndScreen:FindFirstChild("Victory"), isDraw or didWin, u148.Victory, v159, isDraw and "Draw" or "Victory");
    local Defeat = EndScreen:FindFirstChild("Defeat");
    setupResultFrame(Defeat, not isDraw and not didWin, u148.Defeat, v159, isDraw and "Draw" or "Defeat");
    local showAccolades = p158.showAccolades;
    local MVP = EndScreen:FindFirstChild("MVP");

    if MVP then
        MVP.Visible = showAccolades;
    end;

    local returnToMenu = p158.returnToMenu;
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

    u8:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1121
        -- upvalues: enforceEndScreenVisibility (ref), MainGui (copy)
        enforceEndScreenVisibility(MainGui);
    end), "Disconnect", "EndScreenVisibilityLock");
end;

local function clearSkipFade(p160: userdata?) -- Line: 1223
    if p160 then
        p160:SetAttribute("SkipFade", nil);
    end;
end;

local function hideMvpSlots(p161: userdata) -- Line: 1229
    for i = 1, 5 do
        local v162 = p161:FindFirstChild((tostring(i)));
        local v163;

        if v162 then
            v162.Visible = false;
            v163 = i;
        else
            v163 = i;
        end;
    end;
end;

local function hideEndScreenUI() -- Line: 1235
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

local function getTeamLoadout(p164: string) -- Line: 1280
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v165 = DataController.Get(LocalPlayer, "Loadout");

    if type(v165) ~= "table" then
        return nil;
    end;

    local v166 = v165[p164 == "CT" and "Counter-Terrorists" or "Terrorists"];

    if type(v166) == "table" then
        return v166;
    end;

    return nil;
end;

local function getEquippedGloveId(p167: string) -- Line: 1290
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v168 = DataController.Get(LocalPlayer, "Loadout");
    local v169;

    if type(v168) == "table" then
        v169 = v168[p167 == "CT" and "Counter-Terrorists" or "Terrorists"];

        if type(v169) ~= "table" then
            v169 = nil;
        end;
    else
        v169 = nil;
    end;

    local v170 = v169 and v169.Equipped and v169.Equipped["Equipped Gloves"];

    if type(v170) == "string" and v170 ~= "" then
        return v170;
    end;

    return nil;
end;

local function findInventoryItem(p171: string) -- Line: 1299
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v172 = DataController.Get(LocalPlayer, "Inventory");

    if type(v172) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v172) do
        if v and v._id == p171 then
            return v;
        end;
    end;

    return nil;
end;

local function attachGlovesToCharacter(p173: userdata, p174: string, p175: table?) -- Line: 1313
    -- upvalues: DataController (copy), LocalPlayer (copy), findInventoryItem (copy), u6 (copy), Skins (copy), ReplicatedStorage (copy), AttachGlovesToCharacter (copy)
    local v176 = nil;
    local v177 = nil;
    local v178 = nil;

    if p175 then
        v176 = p175.Name;
        v177 = p175.Skin;
        v178 = p175.Float;
    else
        local v179 = DataController.Get(LocalPlayer, "Loadout");
        local v180;

        if type(v179) == "table" then
            v180 = v179[p174 == "CT" and "Counter-Terrorists" or "Terrorists"];

            if type(v180) ~= "table" then
                v180 = nil;
            end;
        else
            v180 = nil;
        end;

        local v181 = v180 and v180.Equipped and v180.Equipped["Equipped Gloves"];

        if type(v181) ~= "string" or v181 == "" then
            v181 = nil;
        end;

        if v181 then
            local v182 = findInventoryItem(v181);

            if v182 then
                v176 = v182.Name;
                v177 = v182.Skin;
                v178 = v182.Float;
            end;
        end;
    end;

    local v183 = v176 or u6[p174].Glove;
    local v184;

    if v177 and (v177 ~= "" and v178 ~= nil) then
        v184 = Skins.GetGloves(v183, v177, v178) or nil;
    else
        v184 = nil;
    end;

    local v185;

    if v184 then
        v185 = v184:GetChildren();
    else
        local v186 = ReplicatedStorage.Assets.Weapons:FindFirstChild(v183);

        if not v186 then
            return;
        end;

        v185 = v186:GetChildren();
    end;

    local v187 = p173:FindFirstChild("CharacterArmor") or Instance.new("Folder");
    v187.Name = "CharacterArmor";
    v187.Parent = p173;
    AttachGlovesToCharacter(v185, p173, v187);
end;

local function getEquippedWeaponFromLoadout(p188: string, p189: string) -- Line: 1359
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

local function attachWeaponToCharacter(p195: userdata, p196: string, p197: table?) -- Line: 1390
    -- upvalues: u6 (copy), getEquippedWeaponFromLoadout (copy), Skins (copy), u4 (copy)
    local Weapon = u6[p196].Weapon;
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
        Motor6D.C0 = u4;

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

local function calculateHSP(p200: number?, p201: number?) -- Line: 1470
    local v202 = p200 or 0;

    return v202 <= 0 and "0%" or `{math.floor((p201 or 0) / v202 * 100)}%`;
end;

local function getEquippedBadgeIcon(p203: userdata, p204: string) -- Line: 1480
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

local function populateMVPFrame(p208: table) -- Line: 1497
    -- upvalues: PlayerGui (copy), hideMvpSlots (copy), u2 (copy), Players (copy), getEquippedBadgeIcon (copy)
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
        local v209 = MVP:FindFirstChild((tostring(u2[i])));

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

local function positionCharacterOnGround(p220: userdata, p221: userdata, p222: userdata) -- Line: 1569
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

local function playPodiumAnimation(p227: userdata, p228: string, p229: boolean, p230: any) -- Line: 1591
    -- upvalues: u8 (copy)
    local Animation = Instance.new("Animation");
    Animation.AnimationId = p228;
    local v231 = p227:LoadAnimation(Animation);
    v231.Looped = p229;
    v231.Priority = p230;
    v231:Play();
    u8:Add(Animation);
    u8:Add(v231);
end;

local function spawnEndScreenCharacters(p232: table, p233: boolean) -- Line: 1609
    -- upvalues: populateMVPFrame (copy), u2 (copy), u7 (copy), Characters (copy), u6 (copy), CharacterResolver (copy), positionCharacterOnGround (copy), attachGlovesToCharacter (copy), attachWeaponToCharacter (copy), u5 (copy), playPodiumAnimation (copy), u8 (copy)
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
        local v236 = u2[i];
        local v237 = TutorialEndScreenScene:FindFirstChild((tostring(v236)));

        if v237 then
            local v238 = u7[v.data.Team];

            if v238 then
                local v239 = Characters:FindFirstChild(u6[v238].Character);

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
                        local v241 = u5[v236];

                        if OrCreateAnimator and v241 then
                            playPodiumAnimation(OrCreateAnimator, v241.Entrance, false, Enum.AnimationPriority.Action);
                            playPodiumAnimation(OrCreateAnimator, v241.Idle, true, Enum.AnimationPriority.Idle);
                        end;

                        u8:Add(v240, "Destroy");
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

local function animateCamera() -- Line: 1676
    -- upvalues: workspace_CurrentCamera (copy), CameraController (copy), TweenService (copy)
    local TutorialEndScreenScene = workspace:FindFirstChild("TutorialEndScreenScene");

    if TutorialEndScreenScene then
        TutorialEndScreenScene = TutorialEndScreenScene:FindFirstChild("EndScreen");
    end;

    if not TutorialEndScreenScene then
        TutorialEndScreenScene = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EndScreen");
    end;

    if not TutorialEndScreenScene then
        return nil;
    end;

    local Start = TutorialEndScreenScene:FindFirstChild("Start");
    local End = TutorialEndScreenScene:FindFirstChild("End");

    if not (Start and End) then
        warn("[EndScreen] Missing Start or End part!");

        return nil;
    end;

    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    workspace_CurrentCamera.CFrame = Start.CFrame;
    workspace_CurrentCamera.Focus = Start.CFrame;
    workspace_CurrentCamera.FieldOfView = 60;
    CameraController.setMouseEnabled(true);
    local v242 = TweenService:Create(workspace_CurrentCamera, TweenInfo.new(14, Enum.EasingStyle.Linear), {
        CFrame = End.CFrame
    });
    v242:Play();

    return v242;
end;

local function closeAllActiveScenes() -- Line: 1707
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

function u1.IsActive() -- Line: 1755
    -- upvalues: u9 (ref)
    return u9;
end;

local function cacheLevelData(p243) -- Line: 1759
    -- upvalues: u15 (ref)
    if p243 then
        u15 = {
            Level = p243.Level,
            Experience = p243.Experience,
            NextExperienceRequirement = p243.NextExperienceRequirement
        };
    end;
end;

local function showMainMenuAfterEndScreen() -- Line: 1769
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

function u1.ExitMapVoteToMenu() -- Line: 1789
    -- upvalues: u10 (ref), MenuState (copy), u9 (ref), u1 (copy), CameraController (copy), hideEndScreenUI (copy), showMainMenuAfterEndScreen (copy), u14 (ref), u12 (ref)
    if u10 then
        return;
    end;

    MenuState.SetWantsMainMenu(true);

    if u9 then
        u1._finishSequence(true);

        return;
    end;

    CameraController.setForceLockOverride("EndScreen", false);
    hideEndScreenUI();
    CameraController.SetEnabled(true);
    showMainMenuAfterEndScreen();
    u14 = nil;
    u12 = true;
end;

function u1._runSequence(u244: table) -- Line: 1808
    -- upvalues: u11 (ref), u12 (ref), u13 (ref), u10 (ref), cleanupDebris (copy), showEndScreenUI (copy), PlayerGui (copy), spawnEndScreenCharacters (copy), animateCamera (copy), u8 (copy), populateLevelFrame (copy), fadeFrame (copy), fadeInFrame (copy), animateLevelBar (copy), displayDrops (copy), u1 (copy)
    u11 = u11 + 1;
    local u245 = u11;
    u12 = u244.returnToMenu;
    u13 = u244.overlayMode;
    u10 = u244.locked;
    cleanupDebris();
    showEndScreenUI(u244);
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
        MainGui = MainGui:FindFirstChild("Close");
    end;

    if MainGui then
        MainGui.Visible = not u244.locked;
    end;

    local success, result = pcall(spawnEndScreenCharacters, u244.displayPlayers, u244.showAccolades);

    if not success then
        warn((`[EndScreen] Podium failed: {result}`));
    end;

    local v246 = animateCamera();

    if v246 then
        u8:Add(v246, "Cancel");
    end;

    if u244.showProgression then
        task.delay(4, function() -- Line: 1837
            -- upvalues: u245 (copy), u11 (ref), PlayerGui (ref), populateLevelFrame (ref), u244 (copy), fadeFrame (ref), fadeInFrame (ref), animateLevelBar (ref), displayDrops (ref)
            if u245 ~= u11 then
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
            local u247 = populateLevelFrame(u244.xpEarned);
            local v248 = u244.isDraw and Victory and Victory or (u244.didWin and Victory and Victory or Defeat);

            if v248 and v248.Visible then
                fadeFrame(v248, 1);
            end;

            task.delay(0.5, function() -- Line: 1858
                -- upvalues: u245 (ref), u11 (ref), Victory (copy), Defeat (copy), Level (copy), fadeInFrame (ref), u247 (copy), animateLevelBar (ref), displayDrops (ref), u244 (ref)
                if u245 ~= u11 then
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
                    task.spawn(function() -- Line: 1873
                        -- upvalues: u247 (ref), animateLevelBar (ref), displayDrops (ref), u244 (ref)
                        if u247 then
                            animateLevelBar(u247);
                        end;

                        displayDrops(u244.levelRewards);
                    end);
                end;
            end);
        end);
    end;

    if u244.locked then
        return;
    end;

    task.delay(u244.sequenceDuration or (u244.showProgression and 14 or 4), function() -- Line: 1891
        -- upvalues: u245 (copy), u11 (ref), u1 (ref), u244 (copy)
        if u245 ~= u11 then
            return;
        end;

        u1._finishSequence(u244.returnToMenu);
    end);
end;

function u1._finishSequence(p249: boolean?) -- Line: 1899
    -- upvalues: u10 (ref), u12 (ref), u11 (ref), u13 (ref), u9 (ref), CameraController (copy), u8 (copy), hideEndScreenUI (copy), PlayerGui (copy), u14 (ref), restoreVisibilitySnapshot (copy), MenuState (copy), showMainMenuAfterEndScreen (copy), DataController (copy), LocalPlayer (copy), u15 (ref)
    if u10 then
        return;
    end;

    if p249 == nil then
        p249 = u12;
    end;

    if typeof(p249) ~= "boolean" then
        p249 = p249 and true or u12;
    end;

    u11 = u11 + 1;
    u13 = "EndScreen";
    u9 = false;
    CameraController.setForceLockOverride("EndScreen", false);
    u8:Cleanup();
    hideEndScreenUI();
    CameraController.SetEnabled(true);
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if p249 or not (MainGui and u14) then
        showMainMenuAfterEndScreen();
        u14 = nil;
        u12 = true;
    else
        restoreVisibilitySnapshot(MainGui, true);
        MenuState.HideMenu();
        MainGui.Gameplay.Visible = true;
        CameraController.setPerspective(true, false);
    end;

    local v250 = DataController.Get(LocalPlayer, "Level");

    if v250 then
        u15 = {
            Level = v250.Level,
            Experience = v250.Experience,
            NextExperienceRequirement = v250.NextExperienceRequirement
        };
    end;
end;

function u1.Begin(p251: table) -- Line: 1937
    -- upvalues: u10 (ref), u9 (ref), u1 (copy), MenuState (copy), Router (copy), LocalPlayer (copy), IsPlayingTeam (copy), collectPlayingPlayers (copy), u3 (copy), closeAllActiveScenes (copy), SpectateController (copy), CameraController (copy)
    if u10 then
        return;
    end;

    local v252 = p251.Halftime == true and "Halftime" or "EndScreen";

    if u9 then
        warn("[EndScreen] Interrupting active sequence for new end screen");
        local success, result = pcall(u1._finishSequence, false);

        if not success then
            warn("[EndScreen] _finishSequence error during interrupt: " .. tostring(result));
        end;

        u9 = false;
    end;

    if MenuState.IsTradeUpActive() then
        return;
    end;

    if MenuState.IsCaseSceneActive() and Router.broadcastRouter("IsCaseSceneRolling") == true then
        return;
    end;

    local v253 = workspace:GetAttribute("Gamemode") == "Deathmatch";
    local v254;

    if p251.Players then
        v254 = p251.Players[tostring(LocalPlayer.UserId)] or nil;
    else
        v254 = nil;
    end;

    if not v254 then
        warn(("[EndScreen] Local player missing from payload (userId=%s, teamAttr=%s, winningTeam=%s)"):format(tostring(LocalPlayer.UserId), tostring(LocalPlayer:GetAttribute("Team")), (tostring(p251.WinningTeam))));

        if not IsPlayingTeam(LocalPlayer:GetAttribute("Team")) or v253 then
            return;
        end;
    end;

    local v255 = v254 and v254.Team or LocalPlayer:GetAttribute("Team");
    local v256 = p251.WinningTeam == "Draw";
    local v257 = nil;
    local v258, v259;

    if v253 then
        if not (v254 and IsPlayingTeam(v254.Team)) then
            if v254 then
                v254 = v254.Team;
            end;

            warn(("[EndScreen] Begin skipped for Deathmatch: invalid team data (team=%s)"):format((tostring(v254))));

            return;
        end;

        v258 = collectPlayingPlayers(p251.Players);
        table.sort(v258, function(p260, p261) -- Line: 257
            if (p260.data.Score or 0) ~= (p261.data.Score or 0) then
                return (p260.data.Score or 0) > (p261.data.Score or 0);
            end;

            if (p260.data.Kills or 0) ~= (p261.data.Kills or 0) then
                return (p260.data.Kills or 0) > (p261.data.Kills or 0);
            end;

            if (p260.data.Assists or 0) == (p261.data.Assists or 0) then
                return (tonumber(p260.userId) or (1 / 0)) < (tonumber(p261.userId) or (1 / 0));
            end;

            return (p260.data.Assists or 0) > (p261.data.Assists or 0);
        end);

        if #v258 == 0 then
            warn("[EndScreen] Begin skipped for Deathmatch: no eligible ranked players");

            return;
        end;

        local v262 = nil;

        for i, v in ipairs(v258) do
            if v.userId == tostring(LocalPlayer.UserId) then
                v262 = i;
                break;
            end;
        end;

        if not v262 then
            warn(("[EndScreen] Begin skipped for Deathmatch: local player missing from ranked list (userId=%s)"):format((tostring(LocalPlayer.UserId))));

            return;
        end;

        v259 = v262 == 1;
        local v263 = v262 % 100;
        v257 = `You placed {`{v262}{v263 >= 11 and v263 <= 13 and "th" or (u3[v262 % 10] or "th")}`}`;
    else
        if not IsPlayingTeam(v255) then
            warn(("[EndScreen] Begin skipped: invalid team (team=%s, teamAttr=%s, winningTeam=%s)"):format(tostring(v255), tostring(LocalPlayer:GetAttribute("Team")), (tostring(p251.WinningTeam))));

            return;
        end;

        v259 = not v256 and p251.WinningTeam == v255;
        local v264 = {};

        for i, v in pairs(p251.Players) do
            if v.Team == v255 then
                v264[i] = v;
            end;
        end;

        v258 = collectPlayingPlayers(v264);
        table.sort(v258, function(p265, p266) -- Line: 240
            if (p265.data.ADR or 0) ~= (p266.data.ADR or 0) then
                return (p265.data.ADR or 0) > (p266.data.ADR or 0);
            end;

            if (p265.data.Score or 0) == (p266.data.Score or 0) then
                return (tonumber(p265.userId) or (1 / 0)) < (tonumber(p266.userId) or (1 / 0));
            end;

            return (p265.data.Score or 0) > (p266.data.Score or 0);
        end);
    end;

    closeAllActiveScenes();
    SpectateController.Stop(false, true);
    CameraController.SetEnabled(false);
    u9 = true;
    local v267 = {};

    for i in pairs(p251.Players) do
        local v268 = tonumber(i);

        if v268 then
            table.insert(v267, v268);
        end;
    end;

    table.sort(v267);
    local v269 = {};

    for _, v in ipairs(v267) do
        local v270 = p251.Players[tostring(v)];

        if v270 then
            v270 = v270.LevelRewards;
        end;

        if v270 then
            local v271 = v;

            for _, v2 in ipairs(v270) do
                table.insert(v269, {
                    userId = v271,
                    reward = v2
                });
            end;
        end;
    end;

    u1._runSequence({
        displayPlayers = v258,
        didWin = v259,
        isDraw = v256,
        winningTeam = p251.WinningTeam,
        xpEarned = v254 and v254.ExperienceEarned or 0,
        levelRewards = v269,
        ctScore = p251.CTScore or 0,
        tScore = p251.TScore or 0,
        scoreTextOverride = v257,
        showAccolades = p251.ShowAccolades ~= false,
        showProgression = p251.ShowProgression ~= false,
        sequenceDuration = p251.SequenceDuration,
        returnToMenu = p251.ReturnToMenu ~= false,
        overlayMode = v252,
        halftimeTeam = v255,
        locked = p251.Locked == true
    });
end;

function u1.Initialize() -- Line: 2099
    -- upvalues: PlayerGui (copy), ActivateButton (copy), CloseButtonRegistry (copy), u9 (ref), MenuState (copy), u1 (copy), GameState (copy), DataController (copy), LocalPlayer (copy), u15 (ref), Remotes (copy)
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
            CloseButtonRegistry.Add(MainGui, Close, function() -- Line: 2111
                -- upvalues: u9 (ref), MenuState (ref), u1 (ref), GameState (ref)
                if not u9 then
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

    DataController.CreateListener(LocalPlayer, "Level", function(p272) -- Line: 2124
        -- upvalues: u15 (ref)
        if u15 == nil and p272 then
            u15 = {
                Level = p272.Level,
                Experience = p272.Experience,
                NextExperienceRequirement = p272.NextExperienceRequirement
            };
        end;
    end);
    Remotes.Match.EndScreen.Listen(function(p273: table) -- Line: 2130
        -- upvalues: u1 (ref)
        u1.Begin(p273);
    end);
end;

return u1;