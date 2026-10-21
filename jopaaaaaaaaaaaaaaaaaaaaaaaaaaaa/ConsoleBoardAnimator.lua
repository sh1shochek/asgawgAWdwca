-- ReplicatedStorage.Controllers.CaseSceneController.ConsoleBoardAnimator
-- Script path: ReplicatedStorage.Controllers.CaseSceneController.ConsoleBoardAnimator
-- Decompile time: 26.95 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
require(ReplicatedStorage.Database.Custom.ConsoleTypes);
local ConsoleBoardPlanner = require(script.Parent:WaitForChild("ConsoleBoardPlanner"));
local ConsoleItemRoller = require(script.Parent:WaitForChild("ConsoleItemRoller"));
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Router = require(ReplicatedStorage.Database.Security.Router);
local ROW_COUNT = ConsoleBoardPlanner.ROW_COUNT;
local TweenInfo_new_ret = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In);
local TweenInfo_new_ret2 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local Color3_fromRGB_ret = Color3.fromRGB(65, 65, 65);
local Color3_fromRGB_ret2 = Color3.fromRGB(80, 80, 80);
local TweenInfo_new_ret3 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u2 = { { 0, 0 }, { 0.1, 0.25 }, { 0.6, 1 }, { 1, 0 } };
local Color3_new_ret = Color3.new(1, 1, 1);
local TweenInfo_new_ret4 = TweenInfo.new(0.2);
local TweenInfo_new_ret5 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local TweenInfo_new_ret6 = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local TweenInfo_new_ret7 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local TweenInfo_new_ret8 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local TweenInfo_new_ret9 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local TweenInfo_new_ret10 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local TweenInfo_new_ret11 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local TweenInfo_new_ret12 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

local function getGridCells(p3: userdata) -- Line: 173
    local v4 = {};

    for _, child in ipairs(p3:GetChildren()) do
        if child:IsA("GuiObject") then
            table.insert(v4, child);
        end;
    end;

    table.sort(v4, function(p5, p6) -- Line: 180
        return p5.LayoutOrder < p6.LayoutOrder;
    end);

    return v4;
end;

local function waitFor(p7: any, p8: number) -- Line: 186
    task.wait(p8);

    return p7.State == "resolving";
end;

local function waitWhileCompleted(p9: any, p10: number) -- Line: 191
    task.wait(p10);

    return p9.State == "completed";
end;

local function waitForSound(p11: any, p12: userdata?) -- Line: 196
    -- upvalues: RunService (copy)
    while p11.State == "resolving" and (p12 and (p12.Parent and p12.IsPlaying)) do
        RunService.RenderStepped:Wait();
    end;

    return p11.State == "resolving";
end;

local function playSound(u13: any, p14: string) -- Line: 203
    -- upvalues: Router (copy)
    local u15 = Router.broadcastRouter("RunStoreSound", p14);
    local v16 = `[ConsoleBoardAnimator] Store sound "{p14}" is not registered`;
    assert(u15, v16);
    u13.ActiveSounds[u15] = true;
    u13.Cleanup:Add(u15, "Destroy", u15);
    u15.Destroying:Once(function() -- Line: 208
        -- upvalues: u13 (copy), u15 (copy)
        u13.ActiveSounds[u15] = nil;
        u13.Cleanup:RemoveNoClean(u15);
    end);

    return u15;
end;

local function stopSound(p17: any, p18: userdata?) -- Line: 215
    if not (p18 and p17.ActiveSounds[p18]) then
        return;
    end;

    p17.ActiveSounds[p18] = nil;
    p18:Stop();
    p17.Cleanup:Remove(p18);
end;

local function reelPosition(p19: table, p20: number) -- Line: 224
    return UDim2.new(p19.Position.X.Scale, p19.Position.X.Offset, p19.Position.Y.Scale + p19.Span.Scale * p20, p19.Position.Y.Offset + p19.Span.Offset * p20);
end;

local function setArrowRows(p21: table, p22: any) -- Line: 233
    -- upvalues: ROW_COUNT (copy)
    for i = 0, ROW_COUNT - 1 do
        local v23 = p22[i] == true;
        local v24 = p21[i];
        v24.Visible = true;
        v24.ImageTransparency = v23 and 0 or 1;
        local _ = i;
    end;
end;

local function setArrowVisibility(p25: table, p26: any) -- Line: 242
    -- upvalues: ROW_COUNT (copy)
    local Arrows = p25.Arrows;

    for i = 0, ROW_COUNT - 1 do
        local v27 = p26[i] == true;
        local v28 = Arrows[i];
        v28.Visible = true;
        v28.ImageTransparency = v27 and 0 or 1;
        local _ = i;
    end;

    local RepeatArrows = p25.RepeatArrows;

    for i = 0, ROW_COUNT - 1 do
        local v29 = p26[i] == true;
        local v30 = RepeatArrows[i];
        v30.Visible = true;
        v30.ImageTransparency = v29 and 0 or 1;
        local _ = i;
    end;
end;

local function getColumnColor(p31: any, p32: number, p33, p34: boolean?) -- Line: 247
    -- upvalues: Color3_new_ret (copy)
    if p31.ArrowColor then
        return p31.ArrowColor;
    end;

    if p32 < 1 and p34 ~= false then
        return Color3_new_ret;
    end;

    return p33;
end;

local function getArrowColor(p35: any, p36: number, p37: userdata, p38: boolean?) -- Line: 257
    -- upvalues: Color3_new_ret (copy)
    if p35.ArrowColor then
        return p35.ArrowColor;
    end;

    if p36 < 1 and p38 ~= false then
        return Color3_new_ret;
    end;

    return p35.ArrowColors[p37];
end;

local function setLandingRows(p39: any, p40: number, p41: table, p42: any, p43: boolean?) -- Line: 261
    -- upvalues: ROW_COUNT (copy), Color3_new_ret (copy)
    for i = 0, ROW_COUNT - 1 do
        local v44 = p41.Arrows[i];
        local v45 = p41.RepeatArrows[i];
        local v46 = p39.ArrowColors[v44];

        if p39.ArrowColor then
            v46 = p39.ArrowColor;
        elseif p40 < 1 and p43 ~= false then
            v46 = Color3_new_ret;
        end;

        local v47 = p42[i] == true and 0.05 or 1;
        v44.ImageColor3 = v46;
        v44.ImageTransparency = v47;
        v45.ImageColor3 = v46;
        v45.ImageTransparency = v47;
        local _ = i;
    end;
end;

local function setReelProgress(p48: table, p49: number) -- Line: 281
    p48.Container.Position = UDim2.new(p48.Position.X.Scale, p48.Position.X.Offset, p48.Position.Y.Scale + p48.Span.Scale * p49, p48.Position.Y.Offset + p48.Span.Offset * p49);
    local v50 = p49 - 1;
    p48.RepeatContainer.Position = UDim2.new(p48.Position.X.Scale, p48.Position.X.Offset, p48.Position.Y.Scale + p48.Span.Scale * v50, p48.Position.Y.Offset + p48.Span.Offset * v50);
end;

local function setPatternProgress(p51: table, p52: number) -- Line: 286
    local PatternSpan = p51.PatternSpan;
    p51.PatternPrimary.Position = UDim2.new(PatternSpan.Scale * p52, PatternSpan.Offset * p52, 0, 0);
    p51.PatternRepeat.Position = UDim2.new(PatternSpan.Scale * (p52 - 1), PatternSpan.Offset * (p52 - 1), 0, 0);
end;

function u1.new(p53: userdata, p54: number) -- Line: 292
    -- upvalues: getGridCells (copy), Janitor (copy), ConsoleBoardPlanner (copy), u1 (copy), ROW_COUNT (copy), Color3_fromRGB_ret2 (copy)
    local ConsoleLaptop = p53:FindFirstChild("ConsoleLaptop", true);
    local SurfaceGui = ConsoleLaptop.Screen.SurfaceGui;
    local Main = SurfaceGui.BundleMiniGame.Main;
    local ArrowHolder = Main.ArrowHolder;
    local v55 = Main["2"];
    local v56 = getGridCells(Main.Grids);
    local v57 = Janitor.new();
    local v58 = {
        State = "idle",
        ReelsReady = false,
        SceneReady = false,
        IsSkipped = false,
        IsFullPath = false,
        RolledItem = false,
        Columns = {},
        Indicators = {},
        Grid = {},
        ArrowColors = {},
        Spinning = {},
        Cleanup = v57,
        ActiveSounds = {},
        AliveRows = ConsoleBoardPlanner.createAllRows(),
        SurvivingRows = {},
        LandedRows = {},
        PlannedRows = {},
        SpinRows = {},
        PulseScaleByArrow = {},
        ScrollingCells = {},
        ColumnCount = p54,
        BoardParts = {
            [Main] = Main.Position,
            [SurfaceGui.BundleMiniGame.Frame] = SurfaceGui.BundleMiniGame.Frame.Position
        },
        SideLights = {},
        Background = {
            Restore = {}
        },
        RollerParent = SurfaceGui.BundleMiniGame
    };
    local v59 = setmetatable(v58, u1);

    for _, v in { "RaritySideLightLeft", "RaritySideLightRight" } do
        local v60 = ConsoleLaptop:FindFirstChild(v);

        if v60 then
            v60 = v60:FindFirstChild("Light", true);
        end;

        if v60 then
            local v61 = v60:FindFirstChildOfClass("UIShadow");
            local SideLights = v59.SideLights;
            local v62 = {
                Frame = v60,
                FrameColor = v60.BackgroundColor3,
                FrameTransparency = v60.BackgroundTransparency,
                Glow = v61
            };
            local v63;

            if v61 then
                v63 = v61.Color;
            else
                v63 = nil;
            end;

            v62.GlowColor = v63;
            local v64;

            if v61 then
                v64 = v61.Transparency;
            else
                v64 = nil;
            end;

            v62.GlowTransparency = v64;
            table.insert(SideLights, v62);
        end;
    end;

    local Background = v59.Background;

    for _, child in SurfaceGui.BundleMiniGame:GetChildren() do
        if child:IsA("ImageLabel") then
            if child.Name == "Pattern" then
                Background.Pattern = child;
                Background.Restore[child] = {
                    Visible = child.Visible,
                    ImageTransparency = child.ImageTransparency,
                    ImageColor3 = child.ImageColor3
                };
            else
                if child.Name == "BG" and child.Visible then
                    Background.Artwork = child;
                    Background.Restore[child] = {
                        Visible = child.Visible,
                        ImageTransparency = child.ImageTransparency,
                        ImageColor3 = child.ImageColor3
                    };
                end;

                if child.Name == "BG" then
                    Background.Tintable = child;
                    Background.Restore[child] = {
                        Visible = child.Visible,
                        ImageTransparency = child.ImageTransparency,
                        ImageColor3 = child.ImageColor3
                    };
                end;
            end;
        end;
    end;

    for i = 0, p54 - 1 do
        local v65 = ArrowHolder[tostring(i + 1)];
        local Frame = v65.Frame;
        local v66 = v57:Add(Frame:Clone());
        v66.Name = "ReelRepeat";
        v66.Parent = v65;
        local v67 = i;
        local v68 = {};
        local v69 = {};

        for i2 = 0, ROW_COUNT - 1 do
            local Arrow = Frame[tostring(i2 + 1)].Arrow;
            local Arrow2 = v66[tostring(i2 + 1)].Arrow;
            v68[i2] = Arrow;
            v69[i2] = Arrow2;
            v59.ArrowColors[Arrow] = Arrow.ImageColor3;
            Arrow.Visible = true;
            Arrow.ImageTransparency = 1;
            local _ = i2;
        end;

        v59.Columns[v67] = {
            Container = Frame,
            RepeatContainer = v66,
            Position = Frame.Position,
            Span = Frame.Size.Y,
            Arrows = v68,
            RepeatArrows = v69
        };
        v66.Visible = false;
        local v70 = v55[tostring(v67 + 1)];
        local v71 = v70:FindFirstChildWhichIsA("ImageLabel", true);
        local v72 = v70:FindFirstChildWhichIsA("UIShadow", true);
        local Indicators = v59.Indicators;
        local v73 = {
            Image = v71,
            ImageColor = v71.ImageColor3,
            ImageTransparency = v71.ImageTransparency,
            Shadow = v72
        };
        local v74;

        if v72 then
            v74 = v72.Transparency;
        else
            v74 = nil;
        end;

        v73.ShadowTransparency = v74;
        local v75;

        if v72 then
            v75 = v72.BlurRadius;
        else
            v75 = nil;
        end;

        v73.ShadowBlurRadius = v75;
        local v76;

        if v72 then
            v76 = v72.Spread;
        else
            v76 = nil;
        end;

        v73.ShadowSpread = v76;
        Indicators[v67] = v73;
        v71.ImageColor3 = Color3_fromRGB_ret2;

        if v72 then
            v72.Transparency = 1;
        end;

        v59.Grid[v67] = {};

        for i2 = 0, ROW_COUNT - 1 do
            local v77 = v56[i2 * p54 + v67 + 1];
            local Pattern = v77.Pattern;
            local ConnectedGrid = v77.ConnectedGrid;
            local Pattern2 = ConnectedGrid.ArrowTemplate3.Pattern;
            local v78 = v57:Add(Pattern2:Clone());
            v78.Name = "PatternPrimary";
            v78.AnchorPoint = Vector2.zero;
            v78.Position = UDim2.fromScale(0, 0);
            v78.Size = Pattern2.TileSize;
            v78.Rotation = 0;
            v78.ScaleType = Enum.ScaleType.Stretch;
            v78.Parent = Pattern2;
            local v79 = v57:Add(v78:Clone());
            v79.Name = "PatternRepeat";
            v79.Position = UDim2.new(-v78.Size.X.Scale, -v78.Size.X.Offset, 0, 0);
            v79.Parent = Pattern2;
            v59.Grid[v67][i2] = {
                Frame = v77,
                Pattern = Pattern,
                Connected = ConnectedGrid,
                PatternMask = Pattern2,
                PatternPrimary = v78,
                PatternRepeat = v79,
                PatternSpan = v78.Size.X,
                PatternMaskTransparency = Pattern2.ImageTransparency,
                PatternMaskClips = Pattern2.ClipsDescendants,
                BackgroundTransparency = v77.BackgroundTransparency,
                PatternTransparency = Pattern.ImageTransparency,
                ConnectedColor = ConnectedGrid.GroupColor3
            };
            Pattern2.ImageTransparency = 1;
            Pattern2.ClipsDescendants = true;
            local _ = i2;
        end;
    end;

    return v59;
end;

function u1._tween(u80: any, p81: userdata, p82: table, p83: userdata?) -- Line: 453
    -- upvalues: TweenService (copy), TweenInfo_new_ret4 (copy)
    local u84 = TweenService:Create(p81, p83 or TweenInfo_new_ret4, p82);
    u80.Cleanup:Add(u84, "Cancel", u84);
    u84.Completed:Once(function() -- Line: 461
        -- upvalues: u80 (copy), u84 (copy)
        u80.Cleanup:RemoveNoClean(u84);
    end);
    u84:Play();

    return u84;
end;

function u1._activateIndicator(u85: any, p86: number) -- Line: 468
    -- upvalues: Color3_new_ret (copy), TweenInfo_new_ret5 (copy), TweenInfo_new_ret7 (copy)
    local u87 = u85.Indicators[p86];
    local v88 = u85:_tween(u87.Image, {
        ImageColor3 = u87.ImageColor:Lerp(Color3_new_ret, 0.35)
    }, TweenInfo_new_ret5);
    local Shadow = u87.Shadow;

    if Shadow then
        local ShadowBlurRadius = u87.ShadowBlurRadius;
        local ShadowSpread = u87.ShadowSpread;
        u85:_tween(Shadow, {
            Transparency = 0.05,
            BlurRadius = UDim.new(ShadowBlurRadius.Scale, ShadowBlurRadius.Offset + 18),
            Spread = UDim2.new(ShadowSpread.X.Scale, ShadowSpread.X.Offset + 8, ShadowSpread.Y.Scale, ShadowSpread.Y.Offset + 8)
        }, TweenInfo_new_ret5);
    end;

    v88.Completed:Once(function(p89) -- Line: 481
        -- upvalues: u85 (copy), u87 (copy), TweenInfo_new_ret7 (ref), Shadow (copy)
        if p89 ~= Enum.PlaybackState.Completed or u85.State ~= "resolving" then
            return;
        end;

        u85:_tween(u87.Image, {
            ImageColor3 = u87.ImageColor
        }, TweenInfo_new_ret7);

        if Shadow then
            u85:_tween(Shadow, {
                BlurRadius = u87.ShadowBlurRadius,
                Spread = u87.ShadowSpread,
                Transparency = u87.ShadowTransparency
            }, TweenInfo_new_ret7);
        end;
    end);
end;

function u1._setCell(p90: any, p91: number, p92: number, p93: boolean, p94: boolean?) -- Line: 496
    -- upvalues: Color3_fromRGB_ret (copy), Color3_new_ret (copy)
    local v95 = p90.Columns[p91].Arrows[p92];
    local v96 = p90.Grid[p91][p92];
    v95.Visible = true;
    local v97 = {};
    local v98;

    if p94 and not p93 then
        v98 = Color3_fromRGB_ret;
    else
        v98 = p90.ArrowColors[v95];

        if p90.ArrowColor then
            v98 = p90.ArrowColor;
        elseif p91 < 1 then
            v98 = Color3_new_ret;
        end;
    end;

    v97.ImageColor3 = v98;
    v97.ImageTransparency = p93 and 0.05 or (p94 and 0.2 or 1);
    p90:_tween(v95, v97);
    local Frame = v96.Frame;
    local v99 = {};
    local v100;

    if p93 then
        v100 = v96.BackgroundTransparency;
    else
        v100 = math.min(1, v96.BackgroundTransparency + 0.2);
    end;

    v99.BackgroundTransparency = v100;
    p90:_tween(Frame, v99);
    local Pattern = v96.Pattern;
    local v101 = {};
    local v102;

    if p93 then
        v102 = v96.PatternTransparency;
    else
        v102 = math.min(1, v96.PatternTransparency + 0.45);
    end;

    v101.ImageTransparency = v102;
    p90:_tween(Pattern, v101);

    if p93 then
        local ConnectedColor = v96.ConnectedColor;

        if p90.ArrowColor then
            ConnectedColor = p90.ArrowColor;
        elseif p91 < 1 then
            ConnectedColor = Color3_new_ret;
        end;

        v96.Connected.GroupColor3 = ConnectedColor;
    end;

    p90.ScrollingCells[v96] = p93 and true or nil;
    p90:_tween(v96.Connected, {
        GroupTransparency = p93 and 0 or 1
    });
end;

function u1._greyRows(p103: any, p104: number, p105: any) -- Line: 525
    -- upvalues: Color3_fromRGB_ret (copy)
    for i = 0, p104 do
        local v106 = i;

        for i2 in p103.LandedRows[i] do
            if not p105 or p105[i2] then
                local v107 = p103.Grid[v106][i2];
                p103:_tween(p103.Columns[v106].Arrows[i2], {
                    ImageTransparency = 0.2,
                    ImageColor3 = Color3_fromRGB_ret
                });
                p103.ScrollingCells[v107] = nil;
                p103:_tween(v107.Connected, {
                    GroupTransparency = 1
                });
            end;
        end;
    end;
end;

function u1._pulseArrow(u108: any, p109: userdata, p110: number, p111, p112: userdata?, u113: userdata?) -- Line: 541
    -- upvalues: TweenInfo_new_ret5 (copy), TweenInfo_new_ret6 (copy)
    local u114 = u108.PulseScaleByArrow[p109];

    if not u114 then
        u114 = u108.Cleanup:Add(Instance.new("UIScale"));
        u114.Name = "ConsoleArrowPulse";
        u114.Parent = p109;
        u108.PulseScaleByArrow[p109] = u114;
    end;

    if p111 then
        u108:_tween(p109, {
            ImageColor3 = p111
        }, TweenInfo_new_ret5);
    end;

    u108:_tween(u114, {
        Scale = p110
    }, p112 or TweenInfo_new_ret6).Completed:Once(function(p115) -- Line: 561
        -- upvalues: u108 (copy), u114 (ref), u113 (copy), TweenInfo_new_ret5 (ref)
        if p115 == Enum.PlaybackState.Completed and u108.State == "resolving" then
            u108:_tween(u114, {
                Scale = 1
            }, u113 or TweenInfo_new_ret5);
        end;
    end);
end;

function u1._pulsePaths(u116: any, u117: number, u118) -- Line: 569
    -- upvalues: ROW_COUNT (copy), Profiler (copy), RunService (copy)
    if u118 then
        u116.ArrowColor = u118;
    end;

    local function pulseArrow(p119: number, p120: number) -- Line: 573
        -- upvalues: u116 (copy), u117 (copy), u118 (copy)
        local v121 = u116.Columns[p119];
        local v122;

        if p119 <= u117 then
            v122 = u116.AliveRows[p120] and u116.LandedRows[p119][p120];
        else
            v122 = false;
        end;

        local v123;

        if u117 < p119 then
            v123 = v121.Arrows[p120].ImageTransparency < 1;
        else
            v123 = false;
        end;

        if not (v122 or v123) then
            return true;
        end;

        u116:_pulseArrow(v121.Arrows[p120], 1.18, u118);

        if v122 and u118 then
            u116:_tween(u116.Grid[p119][p120].Connected, {
                GroupColor3 = u118
            });
        end;

        if v123 then
            u116:_pulseArrow(v121.RepeatArrows[p120], 1.18, u118);
        end;

        task.wait(0.015);

        return u116.State == "resolving";
    end;

    local u124 = ROW_COUNT;

    local function pulsePath(p125: number) -- Line: 592
        -- upvalues: pulseArrow (copy), u117 (copy), u116 (copy)
        if not pulseArrow(u117, p125) then
            return false;
        end;

        for i = u116.ColumnCount - 1, 0, -1 do
            if i ~= u117 and not pulseArrow(i, p125) then
                return false;
            end;

            local _ = i;
        end;

        return true;
    end;

    for i = 0, ROW_COUNT - 1 do
        Profiler.spawn("CaseScene.ConsoleBoard.RarityPath", function() -- Line: 607
            -- upvalues: pulsePath (copy), i (copy), u124 (ref)
            pulsePath(i);
            u124 = u124 - 1;
        end);
        local _ = i;
    end;

    while u124 > 0 and u116.State == "resolving" do
        RunService.RenderStepped:Wait();
    end;

    local v126;

    if u116.State == "resolving" then
        task.wait(0.3);
        v126 = u116.State == "resolving";
    else
        v126 = false;
    end;

    return v126;
end;

function u1._startPinkTeaseMelody(p127) -- Line: 618
    -- upvalues: playSound (copy)
    if not p127.TeaseMelody then
        p127.TeaseMelody = playSound(p127, "Console Pink Tease Melody");
    end;
end;

function u1._stopPinkTeaseMelody(u128) -- Line: 624
    -- upvalues: TweenInfo_new_ret3 (copy)
    local TeaseMelody = u128.TeaseMelody;
    u128.TeaseMelody = nil;

    if not (TeaseMelody and u128.ActiveSounds[TeaseMelody]) then
        return;
    end;

    u128:_tween(TeaseMelody, {
        PlaybackSpeed = 0.2,
        Volume = 0
    }, TweenInfo_new_ret3).Completed:Once(function() -- Line: 635
        -- upvalues: u128 (copy), TeaseMelody (copy)
        local v129 = u128;
        local v130 = TeaseMelody;

        if v130 then
            if not v129.ActiveSounds[v130] then
                return;
            end;

            v129.ActiveSounds[v130] = nil;
            v130:Stop();
            v129.Cleanup:Remove(v130);
        end;
    end);
end;

function u1._celebrateFullPath(u131) -- Line: 640
    -- upvalues: ROW_COUNT (copy), RunService (copy)
    local os_clock_ret = os.clock();

    local function tweenPathScale(p132: number, p133: userdata) -- Line: 642
        -- upvalues: u131 (copy), ROW_COUNT (ref)
        for i = 0, u131.ColumnCount - 1 do
            local v134 = i;

            for i2 = 0, ROW_COUNT - 1 do
                local v135;

                if u131.AliveRows[i2] and u131.LandedRows[v134][i2] then
                    u131:_tween(u131.PulseScaleByArrow[u131.Columns[v134].Arrows[i2]], {
                        Scale = p132
                    }, p133);
                    v135 = i2;
                else
                    v135 = i2;
                end;
            end;
        end;
    end;

    local v136 = 0;

    while v136 <= 3.43 do
        local v137 = math.exp(v136 * -0.606) * 0.06 * u131.ColumnCount * 0.8;
        local TweenInfo_new_ret13 = TweenInfo.new(v137 * 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
        local TweenInfo_new_ret14 = TweenInfo.new(v137 * 0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for i = 0, u131.ColumnCount - 1 do
            local v138 = i;

            while u131.State == "resolving" and os.clock() - os_clock_ret < v136 + 0.1 do
                RunService.RenderStepped:Wait();
            end;

            if u131.State ~= "resolving" then
                return false;
            end;

            for i2 = 0, ROW_COUNT - 1 do
                local v139;

                if u131.AliveRows[i2] and u131.LandedRows[v138][i2] then
                    u131:_pulseArrow(u131.Columns[v138].Arrows[i2], 1.5, nil, TweenInfo_new_ret13, TweenInfo_new_ret14);
                    v139 = i2;
                else
                    v139 = i2;
                end;
            end;

            v136 = v136 + math.exp(v136 * -0.606) * 0.06;
        end;
    end;

    tweenPathScale(1.25, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out));
    task.wait(0.08);

    if u131.State ~= "resolving" then
        return false;
    end;

    local v140 = 4.2 - (os.clock() - os_clock_ret);
    local math_max_ret = math.max(0, v140);
    tweenPathScale(1.8, TweenInfo.new(math_max_ret, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut));

    while u131.State == "resolving" and os.clock() - os_clock_ret < 4.2 do
        RunService.RenderStepped:Wait();
    end;

    if u131.State ~= "resolving" then
        return false;
    end;

    tweenPathScale(1, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out));
    task.wait(0.08);

    return u131.State == "resolving";
end;

local function getChasePower(p141: number) -- Line: 706
    -- upvalues: u2 (copy)
    for i = 2, #u2 do
        local v142 = u2[i - 1];
        local v143 = u2[i];

        if p141 <= v143[1] then
            return v142[2] + (v143[2] - v142[2]) * (p141 - v142[1]) / (v143[1] - v142[1]);
        end;

        local _ = i;
    end;

    return 0;
end;

local function createChaseSegments(u144: any, u145: userdata, p146) -- Line: 717
    local X = u145.AbsoluteSize.X;
    local Y = u145.AbsoluteSize.Y;
    local v147 = math.min(X, Y) / 2;
    local v148 = math.max(X, Y) - v147 * 2;
    local u149 = 2 * (X + Y);
    local v150 = u149 / 40;
    local u151 = u145:Clone();
    u151:ClearAllChildren();
    u151.AnchorPoint = Vector2.zero;
    u151.Rotation = 0;
    u151.ImageColor3 = p146;
    u151.ImageTransparency = 1;
    local u152 = {};
    local math_round_ret = math.round(X / v150);
    local math_max_ret = math.max(1, math_round_ret);
    local math_round_ret2 = math.round(v148 / v150);
    local math_max_ret2 = math.max(1, math_round_ret2);

    local function addSegment(p153: number, p154: number, p155: number, p156: number, p157: number) -- Line: 736
        -- upvalues: u144 (copy), X (copy), Y (copy), u151 (copy), u145 (copy), u152 (copy), u149 (copy)
        local v158 = u144.Cleanup:Add(Instance.new("Frame"));
        v158.Name = "ConsoleGoldChase";
        v158.BackgroundTransparency = 1;
        v158.BorderSizePixel = 0;
        v158.ClipsDescendants = true;
        v158.Position = UDim2.fromScale(p153 / X, p154 / Y);
        v158.Size = UDim2.fromScale((p155 - p153) / X, (p156 - p154) / Y);
        local v159 = u151:Clone();
        v159.Position = UDim2.fromScale(-p153 / (p155 - p153), -p154 / (p156 - p154));
        v159.Size = UDim2.fromScale(X / (p155 - p153), Y / (p156 - p154));
        v159.Parent = v158;
        v158.Parent = u145;
        table.insert(u152, {
            Image = v159,
            Position = p157 / u149
        });
    end;

    for i = 0, math_max_ret - 1 do
        local v160 = X * i / math_max_ret;
        local v161 = X * (i + 1) / math_max_ret;
        addSegment(v160, 0, v161, v147, (v160 + v161) / 2);
        local _ = i;
    end;

    for i = 0, math_max_ret2 - 1 do
        local v162 = v147 + v148 * i / math_max_ret2;
        local v163 = v147 + v148 * (i + 1) / math_max_ret2;
        addSegment(X - v147, v162, X, v163, X + (v162 + v163) / 2);
        local _ = i;
    end;

    for i = 0, math_max_ret - 1 do
        local v164 = X * (math_max_ret - i - 1) / math_max_ret;
        local v165 = X * (math_max_ret - i) / math_max_ret;
        addSegment(v164, Y - v147, v165, Y, X + Y + X - (v164 + v165) / 2);
        local _ = i;
    end;

    for i = 0, math_max_ret2 - 1 do
        local v166 = v147 + v148 * (math_max_ret2 - i - 1) / math_max_ret2;
        local v167 = v147 + v148 * (math_max_ret2 - i) / math_max_ret2;
        addSegment(0, v166, v147, v167, 2 * X + Y + Y - (v166 + v167) / 2);
        local _ = i;
    end;

    u151:Destroy();

    return u152;
end;

function u1._chaseIndicatorsGold(p168) -- Line: 777
    -- upvalues: createChaseSegments (copy), RunServiceController (copy), getChasePower (copy)
    local v169, v170, v171 = p168.Indicators[p168.ColumnCount - 1].ImageColor:ToHSV();
    local u172 = {};

    for _, v in p168.Indicators do
        local AbsoluteSize = v.Image.AbsoluteSize;

        if v.Image.Visible and (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then
            local Color3_fromHSV_ret = Color3.fromHSV(v169 * (1 + (math.random() * 2 - 1) * 0.1), v170 * (1 - math.random() * 0.1), v171 * (1 - math.random() * 0.1));
            v.Image.ImageTransparency = 1;
            local v173 = {
                Offset = math.random(),
                Segments = createChaseSegments(p168, v.Image, Color3_fromHSV_ret)
            };
            table.insert(u172, v173);
        end;
    end;

    local os_clock_ret = os.clock();
    p168.Cleanup:Add(RunServiceController.BindToRenderStep(RunServiceController.CreateBindingName("CaseScene.ConsoleBoard.GoldChase"), function() -- Line: 802
        -- upvalues: os_clock_ret (copy), u172 (copy), getChasePower (ref)
        local v174 = (os.clock() - os_clock_ret) / 2.1;

        for _, v in u172 do
            local v175 = v;

            for _, v2 in v.Segments do
                v2.Image.ImageTransparency = 1 - getChasePower((v2.Position - v174 + v175.Offset) % 1);
            end;
        end;
    end), "Disconnect", "GoldChase");
end;

function u1._stopColumn(p176: any, p177: number) -- Line: 817
    local v178 = p176.Spinning[p177];

    if v178 then
        v178 = v178.Sound;
    end;

    if v178 and p176.ActiveSounds[v178] then
        p176.ActiveSounds[v178] = nil;
        v178:Stop();
        p176.Cleanup:Remove(v178);
    end;

    p176.Spinning[p177] = nil;
    local v179 = p176.Columns[p177];
    v179.Container.Position = v179.Position;
    v179.RepeatContainer.Position = UDim2.new(v179.Position.X.Scale, v179.Position.X.Offset, v179.Position.Y.Scale + v179.Span.Scale * -1, v179.Position.Y.Offset + v179.Span.Offset * -1);
    v179.RepeatContainer.Visible = false;
end;

function u1._revealRemainingColumns(p180: any, p181: number) -- Line: 827
    -- upvalues: setLandingRows (copy), TweenInfo_new_ret2 (copy), ROW_COUNT (copy)
    for i = p181 + 1, p180.ColumnCount - 1 do
        local v182 = p180.Spinning[i];

        if v182 then
            v182 = v182.Sound;
        end;

        if v182 and p180.ActiveSounds[v182] then
            p180.ActiveSounds[v182] = nil;
            v182:Stop();
            p180.Cleanup:Remove(v182);
        end;

        p180.Spinning[i] = nil;
        local v183 = p180.Columns[i];
        local v184 = p180.PlannedRows[i] or p180.SpinRows[i];
        p180.LandedRows[i] = v184;
        v183.RepeatContainer.Visible = false;
        setLandingRows(p180, i, v183, v184);
        v183.Container.Position = UDim2.new(v183.Position.X.Scale, v183.Position.X.Offset, v183.Position.Y.Scale + v183.Span.Scale * -0.18, v183.Position.Y.Offset + v183.Span.Offset * -0.18);
        p180:_tween(v183.Container, {
            Position = v183.Position
        }, TweenInfo_new_ret2);
        local v185 = i;

        for i2 = 0, ROW_COUNT - 1 do
            p180:_setCell(v185, i2, false, v184[i2] == true);
            local _ = i2;
        end;

        task.wait(0.11);

        if p180.State ~= "resolving" then
            return false;
        end;
    end;

    task.wait(TweenInfo_new_ret2.Time);

    return p180.State == "resolving";
end;

function u1._landColumn(p186, p187) -- Line: 851
    -- upvalues: setLandingRows (copy), RunService (copy), playSound (copy)
    local columnIndex = p187.columnIndex;
    local v188 = p186.Spinning[columnIndex];
    local v189 = (os.clock() - v188.StartedAt) % 0.21;

    if v189 > 0.01 then
        task.wait(0.21 - v189);

        if p186.State ~= "resolving" then
            return false, {};
        end;
    end;

    p186.Spinning[columnIndex] = nil;
    local v190 = p186.PlannedRows[columnIndex];
    local v191 = p186.Columns[columnIndex];
    local os_clock_ret = os.clock();
    local v192 = false;

    while p186.State == "resolving" do
        local v193 = (os.clock() - os_clock_ret) / 1.5;
        local math_min_ret = math.min(v193, 1);
        local v194 = (1 - (1 - math_min_ret) ^ 2) * 3;

        if not v192 and v194 >= 2 then
            setLandingRows(p186, columnIndex, v191, v190, false);
            v192 = true;
        end;

        if math_min_ret == 1 then
            v191.Container.Position = UDim2.new(v191.Position.X.Scale, v191.Position.X.Offset, v191.Position.Y.Scale + v191.Span.Scale * 0, v191.Position.Y.Offset + v191.Span.Offset * 0);
            v191.RepeatContainer.Position = UDim2.new(v191.Position.X.Scale, v191.Position.X.Offset, v191.Position.Y.Scale + v191.Span.Scale * -1, v191.Position.Y.Offset + v191.Span.Offset * -1);
            break;
        end;

        local Sound = v188.Sound;
        local PlaybackSpeed = v188.Sound.PlaybackSpeed;
        local math_max_ret = math.max(0.1, 1 - math_min_ret);
        Sound.PlaybackSpeed = math.min(PlaybackSpeed, math_max_ret);
        local v195 = v194 % 1;
        v191.Container.Position = UDim2.new(v191.Position.X.Scale, v191.Position.X.Offset, v191.Position.Y.Scale + v191.Span.Scale * v195, v191.Position.Y.Offset + v191.Span.Offset * v195);
        local v196 = v195 - 1;
        v191.RepeatContainer.Position = UDim2.new(v191.Position.X.Scale, v191.Position.X.Offset, v191.Position.Y.Scale + v191.Span.Scale * v196, v191.Position.Y.Offset + v191.Span.Offset * v196);
        RunService.RenderStepped:Wait();
    end;

    local Sound = v188.Sound;

    if Sound and p186.ActiveSounds[Sound] then
        p186.ActiveSounds[Sound] = nil;
        Sound:Stop();
        p186.Cleanup:Remove(Sound);
    end;

    if p186.State ~= "resolving" then
        return false, {};
    end;

    setLandingRows(p186, columnIndex, v191, v190);
    p186:_stopColumn(columnIndex);
    local v197;

    if p186.ColumnCount == 10 then
        v197 = `Console 10-Column Connect {columnIndex + 1}`;
    else
        v197 = `Console Connect {columnIndex + 1}`;
    end;

    p186.LastResolutionSound = playSound(p186, p187.result == "miss" and "Console Fail" or v197);

    if p187.result == "hit" then
        p186:_activateIndicator(columnIndex);
    end;

    RunService.RenderStepped:Wait();

    if p186.State == "resolving" then
        return true, v190;
    end;

    return false, {};
end;

function u1._spinColumn(p198: any, p199: number, p200: any) -- Line: 901
    -- upvalues: playSound (copy), ROW_COUNT (copy)
    local v201 = playSound(p198, "Console Reel Spin");
    p198.Spinning[p199] = {
        StartedAt = os.clock(),
        Sound = v201
    };
    local v202 = p198.Columns[p199];
    v202.RepeatContainer.Visible = true;
    v202.Container.Position = v202.Position;
    v202.RepeatContainer.Position = UDim2.new(v202.Position.X.Scale, v202.Position.X.Offset, v202.Position.Y.Scale + v202.Span.Scale * -1, v202.Position.Y.Offset + v202.Span.Offset * -1);
    local Arrows = v202.Arrows;

    for i = 0, ROW_COUNT - 1 do
        local v203 = p200[i] == true;
        local v204 = Arrows[i];
        v204.Visible = true;
        v204.ImageTransparency = v203 and 0 or 1;
        local _ = i;
    end;

    local RepeatArrows = v202.RepeatArrows;

    for i = 0, ROW_COUNT - 1 do
        local v205 = p200[i] == true;
        local v206 = RepeatArrows[i];
        v206.Visible = true;
        v206.ImageTransparency = v205 and 0 or 1;
        local _ = i;
    end;
end;

function u1._stopSpin(p207) -- Line: 911
    if p207.RenderConnection then
        p207.Cleanup:Remove("RenderConnection");
        p207.RenderConnection = nil;
    end;

    local ActiveSounds = p207.ActiveSounds;
    p207.ActiveSounds = {};

    for i in ActiveSounds do
        i:Stop();
        p207.Cleanup:Remove(i);
    end;

    p207.TeaseMelody = nil;
    table.clear(p207.Spinning);

    for _, v in p207.Columns do
        v.Container.Position = v.Position;
        v.RepeatContainer.Position = UDim2.new(v.Position.X.Scale, v.Position.X.Offset, v.Position.Y.Scale + v.Span.Scale * -1, v.Position.Y.Offset + v.Span.Offset * -1);
        v.RepeatContainer.Visible = false;
    end;
end;

function u1._prepareReels(p208: any, p209: table) -- Line: 931
    -- upvalues: ConsoleBoardPlanner (copy)
    local v210 = ConsoleBoardPlanner.prepare(p208.SpinRows, p208.AliveRows, p209, p208.ColumnCount);
    p208.SpinRows = v210.SpinRows;
    p208.SurvivingRows = v210.SurvivingRows;
    p208.PlannedRows = v210.PlannedRows;
end;

function u1._applyStep(p211, p212, p213) -- Line: 938
    -- upvalues: ROW_COUNT (copy)
    local v214 = p211.SurvivingRows[p212.columnIndex];
    local v215 = {};

    for i in p211.AliveRows do
        if not v214[i] then
            v215[i] = true;
        end;
    end;

    p211.LandedRows[p212.columnIndex] = p213;

    for i = 0, ROW_COUNT - 1 do
        p211:_setCell(p212.columnIndex, i, v214[i] == true, p213[i] == true);
        local _ = i;
    end;

    if p212.result ~= "miss" then
        p211:_greyRows(p212.columnIndex - 1, v215);
    end;

    p211.AliveRows = v214;
end;

function u1._finish(p216) -- Line: 956
    -- upvalues: Profiler (copy)
    p216.State = "completed";
    p216:_stopSpin();
    local OnComplete = p216.OnComplete;
    p216.OnComplete = nil;
    Profiler.defer("CaseScene.ConsoleBoard.Complete", OnComplete, p216.RolledItem);
end;

function u1._resolveStep(u217, u218) -- Line: 964
    -- upvalues: Profiler (copy)
    local v219, v220 = u217:_landColumn(u218);

    if not v219 then
        return "cancelled";
    end;

    u217:_applyStep(u218, v220);

    if u218.result == "miss" then
        u217:_stopPinkTeaseMelody();

        return u217:_revealRemainingColumns(u218.columnIndex) and "miss" or "cancelled";
    end;

    if u218.kind ~= "rarity" then
        Profiler.spawn("CaseScene.ConsoleBoard.BridgePulse", function() -- Line: 978
            -- upvalues: u217 (copy), u218 (copy)
            u217:_pulsePaths(u218.columnIndex);
        end);

        return "continue";
    end;

    if u218.columnIndex == u217.ColumnCount - 1 then
        u217:_stopPinkTeaseMelody();

        if u218.rarity == "Special" then
            u217:_chaseIndicatorsGold();
        end;
    end;

    u217:_setRarityAmbience(u217.Indicators[u218.columnIndex].ImageColor);

    if not u217:_pulsePaths(u218.columnIndex, u217.Indicators[u218.columnIndex].ImageColor) then
        return "cancelled";
    end;

    if u218.columnIndex == u217.ColumnCount - 3 then
        u217:_startPinkTeaseMelody();
    end;

    return "continue";
end;

function u1._getFinalHoldDuration(p221, p222) -- Line: 1000
    return p222.result == "miss" and 1.2 or ((p221.FinalRarity == "Red" or p221.FinalRarity == "Special") and 2 or 0.8);
end;

function u1._runResolution(p223: any, p224: table) -- Line: 1009
    -- upvalues: waitForSound (copy)
    task.wait(0.63);

    if p223.State ~= "resolving" then
        return;
    end;

    for _, v in p224 do
        local v225 = p223:_resolveStep(v);

        if v225 == "cancelled" then
            return;
        end;

        if v225 == "miss" then
            break;
        end;
    end;

    if p223.IsFullPath and not p223:_celebrateFullPath() then
        return;
    end;

    local v226 = p224[#p224];
    local RollerPlan = p223.RollerPlan;

    if not RollerPlan then
        local v227 = p223:_getFinalHoldDuration(v226);
        task.wait(v227);

        if p223.State ~= "resolving" then
            return;
        end;

        if waitForSound(p223, p223.LastResolutionSound) then
            p223:_finish();
        end;

        return;
    end;

    local v228 = v226.result == "miss" and 0.35 or p223:_getFinalHoldDuration(v226);
    task.wait(v228);
    local v229 = p223.State == "resolving" and p223:_playItemRoller(RollerPlan);
    p223.RolledItem = v229;

    if p223.RolledItem then
        task.wait(1.4);

        if p223.State == "resolving" then
            p223:_finish();
        end;
    end;
end;

function u1._setRarityAmbience(p230: any, p231) -- Line: 1046
    -- upvalues: TweenInfo_new_ret8 (copy), TweenInfo_new_ret9 (copy)
    for _, v in p230.SideLights do
        p230:_tween(v.Frame, {
            BackgroundTransparency = 0,
            BackgroundColor3 = p231
        }, TweenInfo_new_ret8);
        local Glow = v.Glow;

        if Glow then
            p230:_tween(Glow, {
                Transparency = 0.3,
                Color = p231
            }, TweenInfo_new_ret8);
        end;
    end;

    local Background = p230.Background;

    if Background.Pattern then
        p230:_tween(Background.Pattern, {
            ImageColor3 = p231
        }, TweenInfo_new_ret9);
    end;

    local Tintable = Background.Tintable;

    if not Tintable then
        return;
    end;

    if Tintable.Visible then
        p230:_tween(Tintable, {
            ImageColor3 = p231
        }, TweenInfo_new_ret9);

        return;
    end;

    Tintable.ImageColor3 = p231;
    Tintable.ImageTransparency = 1;
    Tintable.Visible = true;
    p230:_tween(Tintable, {
        ImageTransparency = Background.Restore[Tintable].ImageTransparency
    }, TweenInfo_new_ret9);

    if Background.Artwork then
        p230:_tween(Background.Artwork, {
            ImageTransparency = 1
        }, TweenInfo_new_ret9);
    end;
end;

function u1._playItemRoller(u232, p233) -- Line: 1077
    -- upvalues: TweenInfo_new_ret (copy), ConsoleItemRoller (copy)
    for i, v in u232.BoardParts do
        u232:_tween(i, {
            Position = v + UDim2.fromScale(0, 1.2)
        }, TweenInfo_new_ret);
    end;

    task.wait(TweenInfo_new_ret.Time);

    if u232.State == "resolving" then
        return ConsoleItemRoller.play(u232.RollerParent, p233, u232.Cleanup, function() -- Line: 1084
            -- upvalues: u232 (copy)
            return u232.State == "resolving";
        end);
    end;

    return false;
end;

function u1._tryResolve(u234) -- Line: 1089
    -- upvalues: ROW_COUNT (copy), Profiler (copy)
    if u234.State ~= "spinning" or not (u234.ReelsReady and (u234.SceneReady and (u234.Steps and u234.OnComplete))) then
        return;
    end;

    u234.State = "resolving";

    if u234.IsSkipped then
        u234:_finish();

        return;
    end;

    local Steps = u234.Steps;
    u234:_prepareReels(Steps);

    for i = 0, u234.ColumnCount - 1 do
        local v235 = u234.Columns[i];
        local v236 = u234.SpinRows[i];
        local Arrows = v235.Arrows;
        local _ = i;

        for i2 = 0, ROW_COUNT - 1 do
            local v237 = v236[i2] == true;
            local v238 = Arrows[i2];
            v238.Visible = true;
            v238.ImageTransparency = v237 and 0 or 1;
            local _ = i2;
        end;

        local RepeatArrows = v235.RepeatArrows;

        for i2 = 0, ROW_COUNT - 1 do
            local v239 = v236[i2] == true;
            local v240 = RepeatArrows[i2];
            v240.Visible = true;
            v240.ImageTransparency = v239 and 0 or 1;
            local _ = i2;
        end;
    end;

    Profiler.spawn("CaseScene.ConsoleBoard.Resolve", function() -- Line: 1111
        -- upvalues: u234 (copy), Steps (copy)
        u234:_runResolution(Steps);
    end);
end;

function u1.Start(u241) -- Line: 1116
    -- upvalues: ConsoleBoardPlanner (copy), ROW_COUNT (copy), RunServiceController (copy), setPatternProgress (copy), Profiler (copy)
    u241.State = "spinning";
    u241.SpinRows = ConsoleBoardPlanner.createInitialSpinRows(u241.ColumnCount);

    for i = 0, u241.ColumnCount - 1 do
        local v242 = u241.Columns[i];
        local v243 = u241.SpinRows[i];
        local Arrows = v242.Arrows;
        local _ = i;

        for i2 = 0, ROW_COUNT - 1 do
            local v244 = v243[i2] == true;
            local v245 = Arrows[i2];
            v245.Visible = true;
            v245.ImageTransparency = v244 and 0 or 1;
            local _ = i2;
        end;

        local RepeatArrows = v242.RepeatArrows;

        for i2 = 0, ROW_COUNT - 1 do
            local v246 = v243[i2] == true;
            local v247 = RepeatArrows[i2];
            v247.Visible = true;
            v247.ImageTransparency = v246 and 0 or 1;
            local _ = i2;
        end;
    end;

    u241.RenderConnection = u241.Cleanup:Add(RunServiceController.BindToRenderStep(RunServiceController.CreateBindingName("CaseScene.ConsoleBoard.Render"), function() -- Line: 1125
        -- upvalues: u241 (copy), setPatternProgress (ref)
        for i, v in u241.Spinning do
            local v248 = u241.Columns[i];
            local v249 = (os.clock() - v.StartedAt) / 0.21 % 1;
            v248.Container.Position = UDim2.new(v248.Position.X.Scale, v248.Position.X.Offset, v248.Position.Y.Scale + v248.Span.Scale * v249, v248.Position.Y.Offset + v248.Span.Offset * v249);
            local v250 = v249 - 1;
            v248.RepeatContainer.Position = UDim2.new(v248.Position.X.Scale, v248.Position.X.Offset, v248.Position.Y.Scale + v248.Span.Scale * v250, v248.Position.Y.Offset + v248.Span.Offset * v250);
        end;

        local v251 = os.clock() / 2.285714285714286 % 1;

        for i in u241.ScrollingCells do
            setPatternProgress(i, v251);
        end;
    end), "Disconnect", "RenderConnection");
    Profiler.spawn("CaseScene.ConsoleBoard.StartCascade", function() -- Line: 1140
        -- upvalues: u241 (copy)
        task.wait(1);

        for i = 0, u241.ColumnCount - 1 do
            if u241.State ~= "spinning" or u241.IsSkipped then
                return;
            end;

            u241:_spinColumn(i, u241.SpinRows[i]);
            local v252;

            if i < u241.ColumnCount - 1 then
                task.wait(0.12);
                v252 = i;
            else
                v252 = i;
            end;
        end;

        u241.ReelsReady = true;
        u241:_tryResolve();
    end);
end;

function u1.SetSceneReady(p253) -- Line: 1156
    p253.SceneReady = true;
    p253:_tryResolve();
end;

function u1.Resolve(p254: any, p255: any, p256: function, p257: any, p258: any) -- Line: 1161
    -- upvalues: ConsoleBoardPlanner (copy)
    p254.IsFullPath = p255.finalColumnIndex == p254.ColumnCount - 1;
    p254.RollerPlan = p257;
    p254.FinalRarity = p255.finalRarity or p258;
    p254.Steps = ConsoleBoardPlanner.getDisplaySteps(p255);
    p254.OnComplete = p256;
    p254:_tryResolve();
end;

function u1.Skip(p259) -- Line: 1177
    p259.IsSkipped = true;
    p259.ReelsReady = true;
    p259:_stopSpin();

    if p259.State == "resolving" then
        p259:_finish();

        return;
    end;

    p259:_tryResolve();
end;

function u1.PlayReset(u260) -- Line: 1191
    -- upvalues: TweenInfo_new_ret10 (copy), ROW_COUNT (copy), Color3_fromRGB_ret2 (copy), TweenInfo_new_ret12 (copy), TweenInfo_new_ret11 (copy)
    if u260.State ~= "completed" then
        return;
    end;

    u260.Cleanup:Remove("GoldChase");
    local Background = u260.Background;

    for i, v in Background.Restore do
        if i == Background.Tintable and not v.Visible then
            u260:_tween(i, {
                ImageTransparency = 1
            }, TweenInfo_new_ret10);
        else
            u260:_tween(i, {
                ImageTransparency = v.ImageTransparency,
                ImageColor3 = v.ImageColor3
            }, TweenInfo_new_ret10);
        end;
    end;

    for _, v in u260.SideLights do
        u260:_tween(v.Frame, {
            BackgroundColor3 = v.FrameColor,
            BackgroundTransparency = v.FrameTransparency
        }, TweenInfo_new_ret10);

        if v.Glow then
            u260:_tween(v.Glow, {
                Color = v.GlowColor,
                Transparency = v.GlowTransparency
            }, TweenInfo_new_ret10);
        end;
    end;

    local u261 = false;

    for i, v in u260.BoardParts do
        if i.Position ~= v then
            u261 = true;
        end;
    end;

    local function ease(p262: userdata, p263: table) -- Line: 1230
        -- upvalues: u261 (ref), u260 (copy), TweenInfo_new_ret10 (ref)
        local v264 = nil;

        for i, v in p263 do
            if p262[i] ~= v then
                v264 = v264 or {};
                v264[i] = v;
            end;
        end;

        if not v264 then
            return;
        end;

        if u261 then
            for i, v in v264 do
                p262[i] = v;
            end;

            return;
        end;

        u260:_tween(p262, v264, TweenInfo_new_ret10);
    end;

    table.clear(u260.ScrollingCells);

    for i, v in u260.Columns do
        local v265 = i;
        local v266 = v;

        for i2 = 0, ROW_COUNT - 1 do
            local v267 = v266.Arrows[i2];
            ease(v267, {
                ImageTransparency = 1
            });
            ease(v266.RepeatArrows[i2], {
                ImageTransparency = 1
            });
            local v268 = u260.PulseScaleByArrow[v267];

            if v268 then
                ease(v268, {
                    Scale = 1
                });
            end;

            local v269 = u260.Grid[v265][i2];
            ease(v269.Frame, {
                BackgroundTransparency = v269.BackgroundTransparency
            });
            ease(v269.Pattern, {
                ImageTransparency = v269.PatternTransparency
            });
            ease(v269.Connected, {
                GroupTransparency = 1
            });
            local _ = i2;
        end;
    end;

    for _, v in u260.Indicators do
        ease(v.Image, {
            ImageColor3 = Color3_fromRGB_ret2,
            ImageTransparency = v.ImageTransparency
        });

        if v.Shadow then
            ease(v.Shadow, {
                Transparency = 1
            });
        end;

        for _, child in v.Image:GetChildren() do
            local v270;

            if child.Name == "ConsoleGoldChase" then
                v270 = child:FindFirstChildOfClass("ImageLabel");
            else
                v270 = false;
            end;

            if v270 then
                ease(v270, {
                    ImageTransparency = 1
                });
            end;
        end;
    end;

    if not u261 then
        task.wait(TweenInfo_new_ret10.Time);
        local _ = u260.State == "completed";

        return;
    end;

    local ConsoleItemRoller2 = u260.RollerParent:FindFirstChild("ConsoleItemRoller");

    if ConsoleItemRoller2 then
        for _, descendant in ConsoleItemRoller2:GetDescendants() do
            if descendant:IsA("ImageLabel") and descendant.ImageTransparency < 1 then
                u260:_tween(descendant, {
                    ImageTransparency = 1
                }, TweenInfo_new_ret12);
            end;
        end;

        task.wait(TweenInfo_new_ret12.Time);

        if u260.State ~= "completed" then
            return;
        end;
    end;

    for i, v in u260.BoardParts do
        u260:_tween(i, {
            Position = v
        }, TweenInfo_new_ret11);
    end;

    task.wait(TweenInfo_new_ret11.Time);
    local _ = u260.State == "completed";
end;

function u1.Cancel(p271) -- Line: 1307
    p271.State = "cancelled";
    p271.OnComplete = nil;
    p271:_stopSpin();
    p271.Cleanup:Cleanup();

    for i, v in p271.ArrowColors do
        i.Visible = true;
        i.ImageColor3 = v;
        i.ImageTransparency = 1;
    end;

    for _, v in p271.Grid do
        for _, v2 in v do
            v2.Frame.BackgroundTransparency = v2.BackgroundTransparency;
            v2.Pattern.ImageTransparency = v2.PatternTransparency;
            v2.Connected.GroupTransparency = 1;
            v2.Connected.GroupColor3 = v2.ConnectedColor;
            v2.PatternMask.ImageTransparency = v2.PatternMaskTransparency;
            v2.PatternMask.ClipsDescendants = v2.PatternMaskClips;
        end;
    end;

    table.clear(p271.ScrollingCells);

    for i, v in p271.BoardParts do
        i.Position = v;
    end;

    for i, v in p271.Background.Restore do
        i.Visible = v.Visible;
        i.ImageTransparency = v.ImageTransparency;
        i.ImageColor3 = v.ImageColor3;
    end;

    for _, v in p271.SideLights do
        v.Frame.BackgroundColor3 = v.FrameColor;
        v.Frame.BackgroundTransparency = v.FrameTransparency;

        if v.Glow then
            v.Glow.Color = v.GlowColor;
            v.Glow.Transparency = v.GlowTransparency;
        end;
    end;

    for _, v in p271.Indicators do
        v.Image.ImageColor3 = v.ImageColor;
        v.Image.ImageTransparency = v.ImageTransparency;
        local Shadow = v.Shadow;

        if Shadow then
            Shadow.Transparency = v.ShadowTransparency;
            Shadow.BlurRadius = v.ShadowBlurRadius;
            Shadow.Spread = v.ShadowSpread;
        end;
    end;
end;

return u1;