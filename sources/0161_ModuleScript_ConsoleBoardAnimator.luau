-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
require(ReplicatedStorage.Database.Custom.ConsoleTypes);
local ConsoleBoardPlanner = require(script.Parent:WaitForChild("ConsoleBoardPlanner"));
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Router = require(ReplicatedStorage.Database.Security.Router);
local COLUMN_COUNT = ConsoleBoardPlanner.COLUMN_COUNT;
local ROW_COUNT = ConsoleBoardPlanner.ROW_COUNT;
local TweenInfo_new_ret = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local Color3_fromRGB_ret = Color3.fromRGB(65, 65, 65);
local Color3_fromRGB_ret2 = Color3.fromRGB(80, 80, 80);
local TweenInfo_new_ret2 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local Color3_new_ret = Color3.new(1, 1, 1);
local TweenInfo_new_ret3 = TweenInfo.new(0.2);
local TweenInfo_new_ret4 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local TweenInfo_new_ret5 = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local TweenInfo_new_ret6 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

local function getGridCells(p2: userdata) -- Line: 130
    local v3 = {};

    for _, child in ipairs(p2:GetChildren()) do
        if child:IsA("GuiObject") then
            table.insert(v3, child);
        end;
    end;

    table.sort(v3, function(p4, p5) -- Line: 137
        return p4.LayoutOrder < p5.LayoutOrder;
    end);

    return v3;
end;

local function waitFor(p6: any, p7: number) -- Line: 143
    task.wait(p7);

    return p6.State == "resolving";
end;

local function waitForSound(p8: any, p9: userdata?) -- Line: 148
    -- upvalues: RunService (copy)
    while p8.State == "resolving" and (p9 and (p9.Parent and p9.IsPlaying)) do
        RunService.RenderStepped:Wait();
    end;

    return p8.State == "resolving";
end;

local function playSound(u10: any, p11: string) -- Line: 155
    -- upvalues: Router (copy)
    local u12 = Router.broadcastRouter("RunStoreSound", p11);
    local v13 = `[ConsoleBoardAnimator] Store sound "{p11}" is not registered`;
    assert(u12, v13);
    u10.ActiveSounds[u12] = true;
    u10.Cleanup:Add(u12, "Destroy", u12);
    u12.Destroying:Once(function() -- Line: 160
        -- upvalues: u10 (copy), u12 (copy)
        u10.ActiveSounds[u12] = nil;
        u10.Cleanup:RemoveNoClean(u12);
    end);

    return u12;
end;

local function stopSound(p14: any, p15: userdata?) -- Line: 167
    if not (p15 and p14.ActiveSounds[p15]) then
        return;
    end;

    p14.ActiveSounds[p15] = nil;
    p15:Stop();
    p14.Cleanup:Remove(p15);
end;

local function reelPosition(p16: table, p17: number) -- Line: 176
    return UDim2.new(p16.Position.X.Scale, p16.Position.X.Offset, p16.Position.Y.Scale + p16.Span.Scale * p17, p16.Position.Y.Offset + p16.Span.Offset * p17);
end;

local function setArrowRows(p18: table, p19: any) -- Line: 185
    -- upvalues: ROW_COUNT (copy)
    for i = 0, ROW_COUNT - 1 do
        local v20 = p19[i] == true;
        local v21 = p18[i];
        v21.Visible = true;
        v21.ImageTransparency = v20 and 0 or 1;
        local _ = i;
    end;
end;

local function setArrowVisibility(p22: table, p23: any) -- Line: 194
    -- upvalues: ROW_COUNT (copy)
    local Arrows = p22.Arrows;

    for i = 0, ROW_COUNT - 1 do
        local v24 = p23[i] == true;
        local v25 = Arrows[i];
        v25.Visible = true;
        v25.ImageTransparency = v24 and 0 or 1;
        local _ = i;
    end;

    local RepeatArrows = p22.RepeatArrows;

    for i = 0, ROW_COUNT - 1 do
        local v26 = p23[i] == true;
        local v27 = RepeatArrows[i];
        v27.Visible = true;
        v27.ImageTransparency = v26 and 0 or 1;
        local _ = i;
    end;
end;

local function getColumnColor(p28: any, p29: number, p30, p31: boolean?) -- Line: 199
    -- upvalues: Color3_new_ret (copy)
    if p28.ArrowColor then
        return p28.ArrowColor;
    end;

    if p29 < 1 and p31 ~= false then
        return Color3_new_ret;
    end;

    return p30;
end;

local function getArrowColor(p32: any, p33: number, p34: userdata, p35: boolean?) -- Line: 209
    -- upvalues: Color3_new_ret (copy)
    if p32.ArrowColor then
        return p32.ArrowColor;
    end;

    if p33 < 1 and p35 ~= false then
        return Color3_new_ret;
    end;

    return p32.ArrowColors[p34];
end;

local function setLandingRows(p36: any, p37: number, p38: table, p39: any, p40: boolean?) -- Line: 213
    -- upvalues: ROW_COUNT (copy), Color3_new_ret (copy)
    for i = 0, ROW_COUNT - 1 do
        local v41 = p38.Arrows[i];
        local v42 = p38.RepeatArrows[i];
        local v43 = p36.ArrowColors[v41];

        if p36.ArrowColor then
            v43 = p36.ArrowColor;
        elseif p37 < 1 and p40 ~= false then
            v43 = Color3_new_ret;
        end;

        local v44 = p39[i] == true and 0.05 or 1;
        v41.ImageColor3 = v43;
        v41.ImageTransparency = v44;
        v42.ImageColor3 = v43;
        v42.ImageTransparency = v44;
        local _ = i;
    end;
end;

local function setReelProgress(p45: table, p46: number) -- Line: 233
    p45.Container.Position = UDim2.new(p45.Position.X.Scale, p45.Position.X.Offset, p45.Position.Y.Scale + p45.Span.Scale * p46, p45.Position.Y.Offset + p45.Span.Offset * p46);
    local v47 = p46 - 1;
    p45.RepeatContainer.Position = UDim2.new(p45.Position.X.Scale, p45.Position.X.Offset, p45.Position.Y.Scale + p45.Span.Scale * v47, p45.Position.Y.Offset + p45.Span.Offset * v47);
end;

local function setPatternProgress(p48: table, p49: number) -- Line: 238
    local PatternSpan = p48.PatternSpan;
    p48.PatternPrimary.Position = UDim2.new(PatternSpan.Scale * p49, PatternSpan.Offset * p49, 0, 0);
    p48.PatternRepeat.Position = UDim2.new(PatternSpan.Scale * (p49 - 1), PatternSpan.Offset * (p49 - 1), 0, 0);
end;

function u1.new(p50: userdata) -- Line: 244
    -- upvalues: getGridCells (copy), Janitor (copy), ConsoleBoardPlanner (copy), u1 (copy), COLUMN_COUNT (copy), ROW_COUNT (copy), Color3_fromRGB_ret2 (copy)
    local Main = p50:FindFirstChild("ConsoleLaptop", true).Screen.SurfaceGui.BundleMiniGame.Main;
    local ArrowHolder = Main.ArrowHolder;
    local v51 = Main["2"];
    local v52 = getGridCells(Main.Grids);
    local v53 = Janitor.new();
    local v54 = {
        State = "idle",
        ReelsReady = false,
        SceneReady = false,
        IsSkipped = false,
        IsFullPath = false,
        Columns = {},
        Indicators = {},
        Grid = {},
        ArrowColors = {},
        Spinning = {},
        Cleanup = v53,
        ActiveSounds = {},
        AliveRows = ConsoleBoardPlanner.createAllRows(),
        SurvivingRows = {},
        LandedRows = {},
        PlannedRows = {},
        SpinRows = {},
        PulseScaleByArrow = {},
        ScrollingCells = {}
    };
    local v55 = setmetatable(v54, u1);

    for i = 0, COLUMN_COUNT - 1 do
        local v56 = ArrowHolder[tostring(i + 1)];
        local Frame = v56.Frame;
        local v57 = v53:Add(Frame:Clone());
        v57.Name = "ReelRepeat";
        v57.Parent = v56;
        local v58 = i;
        local v59 = {};
        local v60 = {};

        for i2 = 0, ROW_COUNT - 1 do
            local Arrow = Frame[tostring(i2 + 1)].Arrow;
            local Arrow2 = v57[tostring(i2 + 1)].Arrow;
            v59[i2] = Arrow;
            v60[i2] = Arrow2;
            v55.ArrowColors[Arrow] = Arrow.ImageColor3;
            Arrow.Visible = true;
            Arrow.ImageTransparency = 1;
            local _ = i2;
        end;

        v55.Columns[v58] = {
            Container = Frame,
            RepeatContainer = v57,
            Position = Frame.Position,
            Span = Frame.Size.Y,
            Arrows = v59,
            RepeatArrows = v60
        };
        v57.Visible = false;
        local v61 = v51[tostring(v58 + 1)];
        local v62 = v61:FindFirstChildWhichIsA("ImageLabel", true);
        local v63 = v61:FindFirstChildWhichIsA("UIShadow", true);
        local Indicators = v55.Indicators;
        local v64 = {
            Image = v62,
            ImageColor = v62.ImageColor3,
            Shadow = v63
        };
        local v65;

        if v63 then
            v65 = v63.Transparency;
        else
            v65 = nil;
        end;

        v64.ShadowTransparency = v65;
        local v66;

        if v63 then
            v66 = v63.BlurRadius;
        else
            v66 = nil;
        end;

        v64.ShadowBlurRadius = v66;
        local v67;

        if v63 then
            v67 = v63.Spread;
        else
            v67 = nil;
        end;

        v64.ShadowSpread = v67;
        Indicators[v58] = v64;
        v62.ImageColor3 = Color3_fromRGB_ret2;

        if v63 then
            v63.Transparency = 1;
        end;

        v55.Grid[v58] = {};

        for i2 = 0, ROW_COUNT - 1 do
            local v68 = v52[i2 * COLUMN_COUNT + v58 + 1];
            local Pattern = v68.Pattern;
            local ConnectedGrid = v68.ConnectedGrid;
            local Pattern2 = ConnectedGrid.ArrowTemplate3.Pattern;
            local v69 = v53:Add(Pattern2:Clone());
            v69.Name = "PatternPrimary";
            v69.AnchorPoint = Vector2.zero;
            v69.Position = UDim2.fromScale(0, 0);
            v69.Size = Pattern2.TileSize;
            v69.Rotation = 0;
            v69.ScaleType = Enum.ScaleType.Stretch;
            v69.Parent = Pattern2;
            local v70 = v53:Add(v69:Clone());
            v70.Name = "PatternRepeat";
            v70.Position = UDim2.new(-v69.Size.X.Scale, -v69.Size.X.Offset, 0, 0);
            v70.Parent = Pattern2;
            v55.Grid[v58][i2] = {
                Frame = v68,
                Pattern = Pattern,
                Connected = ConnectedGrid,
                PatternMask = Pattern2,
                PatternPrimary = v69,
                PatternRepeat = v70,
                PatternSpan = v69.Size.X,
                PatternMaskTransparency = Pattern2.ImageTransparency,
                PatternMaskClips = Pattern2.ClipsDescendants,
                BackgroundTransparency = v68.BackgroundTransparency,
                PatternTransparency = Pattern.ImageTransparency,
                ConnectedColor = ConnectedGrid.GroupColor3
            };
            Pattern2.ImageTransparency = 1;
            Pattern2.ClipsDescendants = true;
            local _ = i2;
        end;
    end;

    return v55;
end;

function u1._tween(u71: any, p72: userdata, p73: table, p74: userdata?) -- Line: 358
    -- upvalues: TweenService (copy), TweenInfo_new_ret3 (copy)
    local u75 = TweenService:Create(p72, p74 or TweenInfo_new_ret3, p73);
    u71.Cleanup:Add(u75, "Cancel", u75);
    u75.Completed:Once(function() -- Line: 366
        -- upvalues: u71 (copy), u75 (copy)
        u71.Cleanup:RemoveNoClean(u75);
    end);
    u75:Play();

    return u75;
end;

function u1._activateIndicator(u76: any, p77: number) -- Line: 373
    -- upvalues: Color3_new_ret (copy), TweenInfo_new_ret4 (copy), TweenInfo_new_ret6 (copy)
    local u78 = u76.Indicators[p77];
    local v79 = u76:_tween(u78.Image, {
        ImageColor3 = u78.ImageColor:Lerp(Color3_new_ret, 0.35)
    }, TweenInfo_new_ret4);
    local Shadow = u78.Shadow;

    if Shadow then
        local ShadowBlurRadius = u78.ShadowBlurRadius;
        local ShadowSpread = u78.ShadowSpread;
        u76:_tween(Shadow, {
            Transparency = 0.05,
            BlurRadius = UDim.new(ShadowBlurRadius.Scale, ShadowBlurRadius.Offset + 18),
            Spread = UDim2.new(ShadowSpread.X.Scale, ShadowSpread.X.Offset + 8, ShadowSpread.Y.Scale, ShadowSpread.Y.Offset + 8)
        }, TweenInfo_new_ret4);
    end;

    v79.Completed:Once(function(p80) -- Line: 386
        -- upvalues: u76 (copy), u78 (copy), TweenInfo_new_ret6 (ref), Shadow (copy)
        if p80 ~= Enum.PlaybackState.Completed or u76.State ~= "resolving" then
            return;
        end;

        u76:_tween(u78.Image, {
            ImageColor3 = u78.ImageColor
        }, TweenInfo_new_ret6);

        if Shadow then
            u76:_tween(Shadow, {
                BlurRadius = u78.ShadowBlurRadius,
                Spread = u78.ShadowSpread,
                Transparency = u78.ShadowTransparency
            }, TweenInfo_new_ret6);
        end;
    end);
end;

function u1._setCell(p81: any, p82: number, p83: number, p84: boolean, p85: boolean?) -- Line: 401
    -- upvalues: Color3_fromRGB_ret (copy), Color3_new_ret (copy)
    local v86 = p81.Columns[p82].Arrows[p83];
    local v87 = p81.Grid[p82][p83];
    v86.Visible = true;
    local v88 = {};
    local v89;

    if p85 and not p84 then
        v89 = Color3_fromRGB_ret;
    else
        v89 = p81.ArrowColors[v86];

        if p81.ArrowColor then
            v89 = p81.ArrowColor;
        elseif p82 < 1 then
            v89 = Color3_new_ret;
        end;
    end;

    v88.ImageColor3 = v89;
    v88.ImageTransparency = p84 and 0.05 or (p85 and 0.2 or 1);
    p81:_tween(v86, v88);
    local Frame = v87.Frame;
    local v90 = {};
    local v91;

    if p84 then
        v91 = v87.BackgroundTransparency;
    else
        v91 = math.min(1, v87.BackgroundTransparency + 0.2);
    end;

    v90.BackgroundTransparency = v91;
    p81:_tween(Frame, v90);
    local Pattern = v87.Pattern;
    local v92 = {};
    local v93;

    if p84 then
        v93 = v87.PatternTransparency;
    else
        v93 = math.min(1, v87.PatternTransparency + 0.45);
    end;

    v92.ImageTransparency = v93;
    p81:_tween(Pattern, v92);

    if p84 then
        local ConnectedColor = v87.ConnectedColor;

        if p81.ArrowColor then
            ConnectedColor = p81.ArrowColor;
        elseif p82 < 1 then
            ConnectedColor = Color3_new_ret;
        end;

        v87.Connected.GroupColor3 = ConnectedColor;
    end;

    p81.ScrollingCells[v87] = p84 and true or nil;
    p81:_tween(v87.Connected, {
        GroupTransparency = p84 and 0 or 1
    });
end;

function u1._greyRows(p94: any, p95: number, p96: any) -- Line: 430
    -- upvalues: Color3_fromRGB_ret (copy)
    for i = 0, p95 do
        local v97 = i;

        for i2 in p94.LandedRows[i] do
            if not p96 or p96[i2] then
                local v98 = p94.Grid[v97][i2];
                p94:_tween(p94.Columns[v97].Arrows[i2], {
                    ImageTransparency = 0.2,
                    ImageColor3 = Color3_fromRGB_ret
                });
                p94.ScrollingCells[v98] = nil;
                p94:_tween(v98.Connected, {
                    GroupTransparency = 1
                });
            end;
        end;
    end;
end;

function u1._pulseArrow(u99: any, p100: userdata, p101: number, p102, p103: userdata?, u104: userdata?) -- Line: 446
    -- upvalues: TweenInfo_new_ret4 (copy), TweenInfo_new_ret5 (copy)
    local u105 = u99.PulseScaleByArrow[p100];

    if not u105 then
        u105 = u99.Cleanup:Add(Instance.new("UIScale"));
        u105.Name = "ConsoleArrowPulse";
        u105.Parent = p100;
        u99.PulseScaleByArrow[p100] = u105;
    end;

    if p102 then
        u99:_tween(p100, {
            ImageColor3 = p102
        }, TweenInfo_new_ret4);
    end;

    u99:_tween(u105, {
        Scale = p101
    }, p103 or TweenInfo_new_ret5).Completed:Once(function(p106) -- Line: 466
        -- upvalues: u99 (copy), u105 (ref), u104 (copy), TweenInfo_new_ret4 (ref)
        if p106 == Enum.PlaybackState.Completed and u99.State == "resolving" then
            u99:_tween(u105, {
                Scale = 1
            }, u104 or TweenInfo_new_ret4);
        end;
    end);
end;

function u1._transitionRarityColor(u107: any, u108: number, u109) -- Line: 473
    -- upvalues: COLUMN_COUNT (copy), ROW_COUNT (copy), Profiler (copy), RunService (copy)
    u107.ArrowColor = u109;

    local function pulseArrow(p110: number, p111: number) -- Line: 475
        -- upvalues: u107 (copy), u108 (copy), u109 (copy)
        local v112 = u107.Columns[p110];
        local v113;

        if p110 <= u108 then
            v113 = u107.AliveRows[p111] and u107.LandedRows[p110][p111];
        else
            v113 = false;
        end;

        local v114;

        if u108 < p110 then
            v114 = v112.Arrows[p111].ImageTransparency < 1;
        else
            v114 = false;
        end;

        if not (v113 or v114) then
            return true;
        end;

        u107:_pulseArrow(v112.Arrows[p111], 1.18, u109);

        if v113 then
            u107:_tween(u107.Grid[p110][p111].Connected, {
                GroupColor3 = u109
            });
        end;

        if v114 then
            u107:_pulseArrow(v112.RepeatArrows[p111], 1.18, u109);
        end;

        task.wait(0.015);

        return u107.State == "resolving";
    end;

    local function pulsePath(p115: number) -- Line: 494
        -- upvalues: pulseArrow (copy), u108 (copy), COLUMN_COUNT (ref)
        if not pulseArrow(u108, p115) then
            return false;
        end;

        for i = COLUMN_COUNT - 1, 0, -1 do
            if i ~= u108 and not pulseArrow(i, p115) then
                return false;
            end;

            local _ = i;
        end;

        return true;
    end;

    local u116 = ROW_COUNT;

    for i = 0, ROW_COUNT - 1 do
        Profiler.spawn("CaseScene.ConsoleBoard.RarityPath", function() -- Line: 509
            -- upvalues: pulsePath (copy), i (copy), u116 (ref)
            pulsePath(i);
            u116 = u116 - 1;
        end);
        local _ = i;
    end;

    while u116 > 0 and u107.State == "resolving" do
        RunService.RenderStepped:Wait();
    end;

    local v117;

    if u107.State == "resolving" then
        task.wait(0.3);
        v117 = u107.State == "resolving";
    else
        v117 = false;
    end;

    return v117;
end;

function u1._startPinkTeaseMelody(p118) -- Line: 520
    -- upvalues: playSound (copy)
    if not p118.TeaseMelody then
        p118.TeaseMelody = playSound(p118, "Console Pink Tease Melody");
    end;
end;

function u1._stopPinkTeaseMelody(u119) -- Line: 526
    -- upvalues: TweenInfo_new_ret2 (copy)
    local TeaseMelody = u119.TeaseMelody;
    u119.TeaseMelody = nil;

    if not (TeaseMelody and u119.ActiveSounds[TeaseMelody]) then
        return;
    end;

    u119:_tween(TeaseMelody, {
        PlaybackSpeed = 0.2,
        Volume = 0
    }, TweenInfo_new_ret2).Completed:Once(function() -- Line: 537
        -- upvalues: u119 (copy), TeaseMelody (copy)
        local v120 = u119;
        local v121 = TeaseMelody;

        if v121 then
            if not v120.ActiveSounds[v121] then
                return;
            end;

            v120.ActiveSounds[v121] = nil;
            v121:Stop();
            v120.Cleanup:Remove(v121);
        end;
    end);
end;

function u1._celebrateFullPath(u122) -- Line: 542
    -- upvalues: COLUMN_COUNT (copy), ROW_COUNT (copy), RunService (copy)
    local os_clock_ret = os.clock();

    local function tweenPathScale(p123: number, p124: userdata) -- Line: 544
        -- upvalues: COLUMN_COUNT (ref), ROW_COUNT (ref), u122 (copy)
        for i = 0, COLUMN_COUNT - 1 do
            local v125 = i;

            for i2 = 0, ROW_COUNT - 1 do
                local v126;

                if u122.AliveRows[i2] and u122.LandedRows[v125][i2] then
                    u122:_tween(u122.PulseScaleByArrow[u122.Columns[v125].Arrows[i2]], {
                        Scale = p123
                    }, p124);
                    v126 = i2;
                else
                    v126 = i2;
                end;
            end;
        end;
    end;

    local v127 = 0;

    while v127 <= 3.43 do
        local v128 = math.exp(v127 * -0.606) * 0.06 * COLUMN_COUNT * 0.8;
        local TweenInfo_new_ret7 = TweenInfo.new(v128 * 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
        local TweenInfo_new_ret8 = TweenInfo.new(v128 * 0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for i = 0, COLUMN_COUNT - 1 do
            local v129 = i;

            while u122.State == "resolving" and os.clock() - os_clock_ret < v127 + 0.1 do
                RunService.RenderStepped:Wait();
            end;

            if u122.State ~= "resolving" then
                return false;
            end;

            for i2 = 0, ROW_COUNT - 1 do
                local v130;

                if u122.AliveRows[i2] and u122.LandedRows[v129][i2] then
                    u122:_pulseArrow(u122.Columns[v129].Arrows[i2], 1.5, nil, TweenInfo_new_ret7, TweenInfo_new_ret8);
                    v130 = i2;
                else
                    v130 = i2;
                end;
            end;

            v127 = v127 + math.exp(v127 * -0.606) * 0.06;
        end;
    end;

    tweenPathScale(1.25, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out));
    task.wait(0.08);

    if u122.State ~= "resolving" then
        return false;
    end;

    local v131 = 4.2 - (os.clock() - os_clock_ret);
    local math_max_ret = math.max(0, v131);
    tweenPathScale(1.8, TweenInfo.new(math_max_ret, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut));

    while u122.State == "resolving" and os.clock() - os_clock_ret < 4.2 do
        RunService.RenderStepped:Wait();
    end;

    if u122.State ~= "resolving" then
        return false;
    end;

    tweenPathScale(1, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out));
    task.wait(0.08);

    return u122.State == "resolving";
end;

function u1._stopColumn(p132: any, p133: number) -- Line: 608
    local v134 = p132.Spinning[p133];

    if v134 then
        v134 = v134.Sound;
    end;

    if v134 and p132.ActiveSounds[v134] then
        p132.ActiveSounds[v134] = nil;
        v134:Stop();
        p132.Cleanup:Remove(v134);
    end;

    p132.Spinning[p133] = nil;
    local v135 = p132.Columns[p133];
    v135.Container.Position = v135.Position;
    v135.RepeatContainer.Position = UDim2.new(v135.Position.X.Scale, v135.Position.X.Offset, v135.Position.Y.Scale + v135.Span.Scale * -1, v135.Position.Y.Offset + v135.Span.Offset * -1);
    v135.RepeatContainer.Visible = false;
end;

function u1._revealRemainingColumns(p136: any, p137: number) -- Line: 618
    -- upvalues: COLUMN_COUNT (copy), setLandingRows (copy), TweenInfo_new_ret (copy), ROW_COUNT (copy)
    for i = p137 + 1, COLUMN_COUNT - 1 do
        local v138 = p136.Spinning[i];

        if v138 then
            v138 = v138.Sound;
        end;

        if v138 and p136.ActiveSounds[v138] then
            p136.ActiveSounds[v138] = nil;
            v138:Stop();
            p136.Cleanup:Remove(v138);
        end;

        p136.Spinning[i] = nil;
        local v139 = p136.Columns[i];
        local v140 = p136.PlannedRows[i] or p136.SpinRows[i];
        p136.LandedRows[i] = v140;
        v139.RepeatContainer.Visible = false;
        setLandingRows(p136, i, v139, v140);
        v139.Container.Position = UDim2.new(v139.Position.X.Scale, v139.Position.X.Offset, v139.Position.Y.Scale + v139.Span.Scale * -0.18, v139.Position.Y.Offset + v139.Span.Offset * -0.18);
        p136:_tween(v139.Container, {
            Position = v139.Position
        }, TweenInfo_new_ret);
        local v141 = i;

        for i2 = 0, ROW_COUNT - 1 do
            p136:_setCell(v141, i2, false, v140[i2] == true);
            local _ = i2;
        end;

        task.wait(0.11);

        if p136.State ~= "resolving" then
            return false;
        end;
    end;

    task.wait(TweenInfo_new_ret.Time);

    return p136.State == "resolving";
end;

function u1._landColumn(p142, p143) -- Line: 642
    -- upvalues: setLandingRows (copy), RunService (copy), playSound (copy)
    local columnIndex = p143.columnIndex;
    local v144 = p142.Spinning[columnIndex];
    local v145 = (os.clock() - v144.StartedAt) % 0.21;

    if v145 > 0.01 then
        task.wait(0.21 - v145);

        if p142.State ~= "resolving" then
            return false, {};
        end;
    end;

    p142.Spinning[columnIndex] = nil;
    local v146 = p142.PlannedRows[columnIndex];
    local v147 = p142.Columns[columnIndex];
    local os_clock_ret = os.clock();
    local v148 = false;

    while p142.State == "resolving" do
        local v149 = (os.clock() - os_clock_ret) / 1.5;
        local math_min_ret = math.min(v149, 1);
        local v150 = (1 - (1 - math_min_ret) ^ 2) * 3;

        if not v148 and v150 >= 2 then
            setLandingRows(p142, columnIndex, v147, v146, false);
            v148 = true;
        end;

        if math_min_ret == 1 then
            v147.Container.Position = UDim2.new(v147.Position.X.Scale, v147.Position.X.Offset, v147.Position.Y.Scale + v147.Span.Scale * 0, v147.Position.Y.Offset + v147.Span.Offset * 0);
            v147.RepeatContainer.Position = UDim2.new(v147.Position.X.Scale, v147.Position.X.Offset, v147.Position.Y.Scale + v147.Span.Scale * -1, v147.Position.Y.Offset + v147.Span.Offset * -1);
            break;
        end;

        local Sound = v144.Sound;
        local PlaybackSpeed = v144.Sound.PlaybackSpeed;
        local math_max_ret = math.max(0.1, 1 - math_min_ret);
        Sound.PlaybackSpeed = math.min(PlaybackSpeed, math_max_ret);
        local v151 = v150 % 1;
        v147.Container.Position = UDim2.new(v147.Position.X.Scale, v147.Position.X.Offset, v147.Position.Y.Scale + v147.Span.Scale * v151, v147.Position.Y.Offset + v147.Span.Offset * v151);
        local v152 = v151 - 1;
        v147.RepeatContainer.Position = UDim2.new(v147.Position.X.Scale, v147.Position.X.Offset, v147.Position.Y.Scale + v147.Span.Scale * v152, v147.Position.Y.Offset + v147.Span.Offset * v152);
        RunService.RenderStepped:Wait();
    end;

    local Sound = v144.Sound;

    if Sound and p142.ActiveSounds[Sound] then
        p142.ActiveSounds[Sound] = nil;
        Sound:Stop();
        p142.Cleanup:Remove(Sound);
    end;

    if p142.State ~= "resolving" then
        return false, {};
    end;

    setLandingRows(p142, columnIndex, v147, v146);
    p142:_stopColumn(columnIndex);
    p142.LastResolutionSound = playSound(p142, p143.result == "miss" and "Console Fail" or `Console Connect {columnIndex + 1}`);

    if p143.result == "hit" then
        p142:_activateIndicator(columnIndex);
    end;

    RunService.RenderStepped:Wait();

    if p142.State == "resolving" then
        return true, v146;
    end;

    return false, {};
end;

function u1._spinColumn(p153: any, p154: number, p155: any) -- Line: 690
    -- upvalues: playSound (copy), ROW_COUNT (copy)
    local v156 = playSound(p153, "Console Reel Spin");
    p153.Spinning[p154] = {
        StartedAt = os.clock(),
        Sound = v156
    };
    local v157 = p153.Columns[p154];
    v157.RepeatContainer.Visible = true;
    v157.Container.Position = v157.Position;
    v157.RepeatContainer.Position = UDim2.new(v157.Position.X.Scale, v157.Position.X.Offset, v157.Position.Y.Scale + v157.Span.Scale * -1, v157.Position.Y.Offset + v157.Span.Offset * -1);
    local Arrows = v157.Arrows;

    for i = 0, ROW_COUNT - 1 do
        local v158 = p155[i] == true;
        local v159 = Arrows[i];
        v159.Visible = true;
        v159.ImageTransparency = v158 and 0 or 1;
        local _ = i;
    end;

    local RepeatArrows = v157.RepeatArrows;

    for i = 0, ROW_COUNT - 1 do
        local v160 = p155[i] == true;
        local v161 = RepeatArrows[i];
        v161.Visible = true;
        v161.ImageTransparency = v160 and 0 or 1;
        local _ = i;
    end;
end;

function u1._stopSpin(p162) -- Line: 700
    if p162.RenderConnection then
        p162.Cleanup:Remove("RenderConnection");
        p162.RenderConnection = nil;
    end;

    local ActiveSounds = p162.ActiveSounds;
    p162.ActiveSounds = {};

    for i in ActiveSounds do
        i:Stop();
        p162.Cleanup:Remove(i);
    end;

    p162.TeaseMelody = nil;
    table.clear(p162.Spinning);

    for _, v in p162.Columns do
        v.Container.Position = v.Position;
        v.RepeatContainer.Position = UDim2.new(v.Position.X.Scale, v.Position.X.Offset, v.Position.Y.Scale + v.Span.Scale * -1, v.Position.Y.Offset + v.Span.Offset * -1);
        v.RepeatContainer.Visible = false;
    end;
end;

function u1._prepareReels(p163: any, p164: table) -- Line: 720
    -- upvalues: ConsoleBoardPlanner (copy)
    local v165 = ConsoleBoardPlanner.prepare(p163.SpinRows, p163.AliveRows, p164);
    p163.SpinRows = v165.SpinRows;
    p163.SurvivingRows = v165.SurvivingRows;
    p163.PlannedRows = v165.PlannedRows;
end;

function u1._applyStep(p166, p167, p168) -- Line: 727
    -- upvalues: ROW_COUNT (copy)
    local v169 = p166.SurvivingRows[p167.columnIndex];
    local v170 = {};

    for i in p166.AliveRows do
        if not v169[i] then
            v170[i] = true;
        end;
    end;

    p166.LandedRows[p167.columnIndex] = p168;

    for i = 0, ROW_COUNT - 1 do
        p166:_setCell(p167.columnIndex, i, v169[i] == true, p168[i] == true);
        local _ = i;
    end;

    if p167.result ~= "miss" then
        p166:_greyRows(p167.columnIndex - 1, v170);
    end;

    p166.AliveRows = v169;
end;

function u1._finish(p171) -- Line: 745
    -- upvalues: Profiler (copy)
    p171.State = "completed";
    p171:_stopSpin();
    local OnComplete = p171.OnComplete;
    p171.OnComplete = nil;
    Profiler.defer("CaseScene.ConsoleBoard.Complete", OnComplete);
end;

function u1._resolveStep(p172, p173) -- Line: 753
    local v174, v175 = p172:_landColumn(p173);

    if not v174 then
        return "cancelled";
    end;

    p172:_applyStep(p173, v175);

    if p173.result == "miss" then
        p172:_stopPinkTeaseMelody();

        return p172:_revealRemainingColumns(p173.columnIndex) and "miss" or "cancelled";
    end;

    if p173.kind ~= "rarity" then
        return "continue";
    end;

    if p173.rarity == "Red" then
        p172:_stopPinkTeaseMelody();
    end;

    if not p172:_transitionRarityColor(p173.columnIndex, p172.Indicators[p173.columnIndex].ImageColor) then
        return "cancelled";
    end;

    if p173.rarity == "Pink" then
        p172:_startPinkTeaseMelody();
    end;

    return "continue";
end;

function u1._getFinalHoldDuration(p176, p177) -- Line: 780
    return p177.result == "miss" and 1.2 or (p176.FinalRarity == "Red" and 2 or 0.8);
end;

function u1._runResolution(p178: any, p179: table) -- Line: 787
    -- upvalues: waitForSound (copy)
    task.wait(0.63);

    if p178.State ~= "resolving" then
        return;
    end;

    for _, v in p179 do
        local v180 = p178:_resolveStep(v);

        if v180 == "cancelled" then
            return;
        end;

        if v180 == "miss" then
            break;
        end;
    end;

    if p178.IsFullPath and not p178:_celebrateFullPath() then
        return;
    end;

    local v181 = p178:_getFinalHoldDuration(p179[#p179]);
    task.wait(v181);

    if p178.State ~= "resolving" then
        return;
    end;

    if waitForSound(p178, p178.LastResolutionSound) then
        p178:_finish();
    end;
end;

function u1._tryResolve(u182) -- Line: 812
    -- upvalues: COLUMN_COUNT (copy), ROW_COUNT (copy), Profiler (copy)
    if u182.State ~= "spinning" or not (u182.ReelsReady and (u182.SceneReady and (u182.Steps and u182.OnComplete))) then
        return;
    end;

    u182.State = "resolving";

    if u182.IsSkipped then
        u182:_finish();

        return;
    end;

    local Steps = u182.Steps;
    u182:_prepareReels(Steps);

    for i = 0, COLUMN_COUNT - 1 do
        local v183 = u182.Columns[i];
        local v184 = u182.SpinRows[i];
        local Arrows = v183.Arrows;
        local _ = i;

        for i2 = 0, ROW_COUNT - 1 do
            local v185 = v184[i2] == true;
            local v186 = Arrows[i2];
            v186.Visible = true;
            v186.ImageTransparency = v185 and 0 or 1;
            local _ = i2;
        end;

        local RepeatArrows = v183.RepeatArrows;

        for i2 = 0, ROW_COUNT - 1 do
            local v187 = v184[i2] == true;
            local v188 = RepeatArrows[i2];
            v188.Visible = true;
            v188.ImageTransparency = v187 and 0 or 1;
            local _ = i2;
        end;
    end;

    Profiler.spawn("CaseScene.ConsoleBoard.Resolve", function() -- Line: 834
        -- upvalues: u182 (copy), Steps (copy)
        u182:_runResolution(Steps);
    end);
end;

function u1.Start(u189) -- Line: 839
    -- upvalues: ConsoleBoardPlanner (copy), COLUMN_COUNT (copy), ROW_COUNT (copy), RunServiceController (copy), setPatternProgress (copy), Profiler (copy)
    u189.State = "spinning";
    u189.SpinRows = ConsoleBoardPlanner.createInitialSpinRows();

    for i = 0, COLUMN_COUNT - 1 do
        local v190 = u189.Columns[i];
        local v191 = u189.SpinRows[i];
        local Arrows = v190.Arrows;
        local _ = i;

        for i2 = 0, ROW_COUNT - 1 do
            local v192 = v191[i2] == true;
            local v193 = Arrows[i2];
            v193.Visible = true;
            v193.ImageTransparency = v192 and 0 or 1;
            local _ = i2;
        end;

        local RepeatArrows = v190.RepeatArrows;

        for i2 = 0, ROW_COUNT - 1 do
            local v194 = v191[i2] == true;
            local v195 = RepeatArrows[i2];
            v195.Visible = true;
            v195.ImageTransparency = v194 and 0 or 1;
            local _ = i2;
        end;
    end;

    u189.RenderConnection = u189.Cleanup:Add(RunServiceController.BindToRenderStep(RunServiceController.CreateBindingName("CaseScene.ConsoleBoard.Render"), function() -- Line: 848
        -- upvalues: u189 (copy), setPatternProgress (ref)
        for i, v in u189.Spinning do
            local v196 = u189.Columns[i];
            local v197 = (os.clock() - v.StartedAt) / 0.21 % 1;
            v196.Container.Position = UDim2.new(v196.Position.X.Scale, v196.Position.X.Offset, v196.Position.Y.Scale + v196.Span.Scale * v197, v196.Position.Y.Offset + v196.Span.Offset * v197);
            local v198 = v197 - 1;
            v196.RepeatContainer.Position = UDim2.new(v196.Position.X.Scale, v196.Position.X.Offset, v196.Position.Y.Scale + v196.Span.Scale * v198, v196.Position.Y.Offset + v196.Span.Offset * v198);
        end;

        local v199 = os.clock() / 2.285714285714286 % 1;

        for i in u189.ScrollingCells do
            setPatternProgress(i, v199);
        end;
    end), "Disconnect", "RenderConnection");
    Profiler.spawn("CaseScene.ConsoleBoard.StartCascade", function() -- Line: 863
        -- upvalues: COLUMN_COUNT (ref), u189 (copy)
        task.wait(1);

        for i = 0, COLUMN_COUNT - 1 do
            if u189.State ~= "spinning" or u189.IsSkipped then
                return;
            end;

            u189:_spinColumn(i, u189.SpinRows[i]);
            local v200;

            if i < COLUMN_COUNT - 1 then
                task.wait(0.12);
                v200 = i;
            else
                v200 = i;
            end;
        end;

        u189.ReelsReady = true;
        u189:_tryResolve();
    end);
end;

function u1.SetSceneReady(p201) -- Line: 879
    p201.SceneReady = true;
    p201:_tryResolve();
end;

function u1.Resolve(p202: any, p203: any, p204: function) -- Line: 884
    -- upvalues: COLUMN_COUNT (copy), ConsoleBoardPlanner (copy)
    p202.IsFullPath = p203.finalColumnIndex == COLUMN_COUNT - 1;
    p202.FinalRarity = p203.finalRarity;
    p202.Steps = ConsoleBoardPlanner.getDisplaySteps(p203);
    p202.OnComplete = p204;
    p202:_tryResolve();
end;

function u1.Skip(p205) -- Line: 892
    p205.IsSkipped = true;
    p205.ReelsReady = true;
    p205:_stopSpin();

    if p205.State == "resolving" then
        p205:_finish();

        return;
    end;

    p205:_tryResolve();
end;

function u1.Cancel(p206) -- Line: 903
    p206.State = "cancelled";
    p206.OnComplete = nil;
    p206:_stopSpin();
    p206.Cleanup:Cleanup();

    for i, v in p206.ArrowColors do
        i.Visible = true;
        i.ImageColor3 = v;
        i.ImageTransparency = 1;
    end;

    for _, v in p206.Grid do
        for _, v2 in v do
            v2.Frame.BackgroundTransparency = v2.BackgroundTransparency;
            v2.Pattern.ImageTransparency = v2.PatternTransparency;
            v2.Connected.GroupTransparency = 1;
            v2.Connected.GroupColor3 = v2.ConnectedColor;
            v2.PatternMask.ImageTransparency = v2.PatternMaskTransparency;
            v2.PatternMask.ClipsDescendants = v2.PatternMaskClips;
        end;
    end;

    table.clear(p206.ScrollingCells);

    for _, v in p206.Indicators do
        v.Image.ImageColor3 = v.ImageColor;
        local Shadow = v.Shadow;

        if Shadow then
            Shadow.Transparency = v.ShadowTransparency;
            Shadow.BlurRadius = v.ShadowBlurRadius;
            Shadow.Spread = v.ShadowSpread;
        end;
    end;
end;

return u1;