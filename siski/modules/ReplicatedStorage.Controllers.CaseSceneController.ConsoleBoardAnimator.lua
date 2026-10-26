-- ReplicatedStorage.Controllers.CaseSceneController.ConsoleBoardAnimator
-- class: ModuleScript

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
            local v65 = 0;

            while true do
                if v65 == 0 then
                    v65 = -1;

                    if child.Name == "Pattern" then
                        v65 = 1;
                        continue;
                    end;

                    if child.Name == "BG" and child.Visible then
                        Background.Artwork = child;
                        v65 = 2;
                        continue;
                    end;

                    if child.Name == "BG" then
                        Background.Tintable = child;
                        Background.Restore[child] = {
                            Visible = child.Visible,
                            ImageTransparency = child.ImageTransparency,
                            ImageColor3 = child.ImageColor3
                        };
                    end;

                    v65 = 3;
                    continue;
                elseif v65 == 1 then
                    v65 = -1;
                    Background.Pattern = child;
                    v65 = 2;
                    continue;
                elseif v65 == 2 then
                    v65 = -1;
                    Background.Restore[child] = {
                        Visible = child.Visible,
                        ImageTransparency = child.ImageTransparency,
                        ImageColor3 = child.ImageColor3
                    };
                    v65 = 3;
                    continue;
                elseif v65 == 3 then
                    v65 = -1;
                    break;
                else
                    break;
                end;
            end;
        end;
    end;

    for i = 0, p54 - 1 do
        local v66 = ArrowHolder[tostring(i + 1)];
        local Frame = v66.Frame;
        local v67 = v57:Add(Frame:Clone());
        v67.Name = "ReelRepeat";
        v67.Parent = v66;
        local v68 = i;
        local v69 = {};
        local v70 = {};

        for i2 = 0, ROW_COUNT - 1 do
            local Arrow = Frame[tostring(i2 + 1)].Arrow;
            local Arrow2 = v67[tostring(i2 + 1)].Arrow;
            v69[i2] = Arrow;
            v70[i2] = Arrow2;
            v59.ArrowColors[Arrow] = Arrow.ImageColor3;
            Arrow.Visible = true;
            Arrow.ImageTransparency = 1;
            local _ = i2;
        end;

        v59.Columns[v68] = {
            Container = Frame,
            RepeatContainer = v67,
            Position = Frame.Position,
            Span = Frame.Size.Y,
            Arrows = v69,
            RepeatArrows = v70
        };
        v67.Visible = false;
        local v71 = v55[tostring(v68 + 1)];
        local v72 = v71:FindFirstChildWhichIsA("ImageLabel", true);
        local v73 = v71:FindFirstChildWhichIsA("UIShadow", true);
        local Indicators = v59.Indicators;
        local v74 = {
            Image = v72,
            ImageColor = v72.ImageColor3,
            ImageTransparency = v72.ImageTransparency,
            Shadow = v73
        };
        local v75;

        if v73 then
            v75 = v73.Transparency;
        else
            v75 = nil;
        end;

        v74.ShadowTransparency = v75;
        local v76;

        if v73 then
            v76 = v73.BlurRadius;
        else
            v76 = nil;
        end;

        v74.ShadowBlurRadius = v76;
        local v77;

        if v73 then
            v77 = v73.Spread;
        else
            v77 = nil;
        end;

        v74.ShadowSpread = v77;
        Indicators[v68] = v74;
        v72.ImageColor3 = Color3_fromRGB_ret2;

        if v73 then
            v73.Transparency = 1;
        end;

        v59.Grid[v68] = {};

        for i2 = 0, ROW_COUNT - 1 do
            local v78 = v56[i2 * p54 + v68 + 1];
            local Pattern = v78.Pattern;
            local ConnectedGrid = v78.ConnectedGrid;
            local Pattern2 = ConnectedGrid.ArrowTemplate3.Pattern;
            local v79 = v57:Add(Pattern2:Clone());
            v79.Name = "PatternPrimary";
            v79.AnchorPoint = Vector2.zero;
            v79.Position = UDim2.fromScale(0, 0);
            v79.Size = Pattern2.TileSize;
            v79.Rotation = 0;
            v79.ScaleType = Enum.ScaleType.Stretch;
            v79.Parent = Pattern2;
            local v80 = v57:Add(v79:Clone());
            v80.Name = "PatternRepeat";
            v80.Position = UDim2.new(-v79.Size.X.Scale, -v79.Size.X.Offset, 0, 0);
            v80.Parent = Pattern2;
            v59.Grid[v68][i2] = {
                Frame = v78,
                Pattern = Pattern,
                Connected = ConnectedGrid,
                PatternMask = Pattern2,
                PatternPrimary = v79,
                PatternRepeat = v80,
                PatternSpan = v79.Size.X,
                PatternMaskTransparency = Pattern2.ImageTransparency,
                PatternMaskClips = Pattern2.ClipsDescendants,
                BackgroundTransparency = v78.BackgroundTransparency,
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

function u1._tween(u81: any, p82: userdata, p83: table, p84: userdata?) -- Line: 453
    -- upvalues: TweenService (copy), TweenInfo_new_ret4 (copy)
    local u85 = TweenService:Create(p82, p84 or TweenInfo_new_ret4, p83);
    u81.Cleanup:Add(u85, "Cancel", u85);
    u85.Completed:Once(function() -- Line: 461
        -- upvalues: u81 (copy), u85 (copy)
        u81.Cleanup:RemoveNoClean(u85);
    end);
    u85:Play();

    return u85;
end;

function u1._activateIndicator(u86: any, p87: number) -- Line: 468
    -- upvalues: Color3_new_ret (copy), TweenInfo_new_ret5 (copy), TweenInfo_new_ret7 (copy)
    local u88 = u86.Indicators[p87];
    local v89 = u86:_tween(u88.Image, {
        ImageColor3 = u88.ImageColor:Lerp(Color3_new_ret, 0.35)
    }, TweenInfo_new_ret5);
    local Shadow = u88.Shadow;

    if Shadow then
        local ShadowBlurRadius = u88.ShadowBlurRadius;
        local ShadowSpread = u88.ShadowSpread;
        u86:_tween(Shadow, {
            Transparency = 0.05,
            BlurRadius = UDim.new(ShadowBlurRadius.Scale, ShadowBlurRadius.Offset + 18),
            Spread = UDim2.new(ShadowSpread.X.Scale, ShadowSpread.X.Offset + 8, ShadowSpread.Y.Scale, ShadowSpread.Y.Offset + 8)
        }, TweenInfo_new_ret5);
    end;

    v89.Completed:Once(function(p90) -- Line: 481
        -- upvalues: u86 (copy), u88 (copy), TweenInfo_new_ret7 (ref), Shadow (copy)
        if p90 ~= Enum.PlaybackState.Completed or u86.State ~= "resolving" then
            return;
        end;

        u86:_tween(u88.Image, {
            ImageColor3 = u88.ImageColor
        }, TweenInfo_new_ret7);

        if Shadow then
            u86:_tween(Shadow, {
                BlurRadius = u88.ShadowBlurRadius,
                Spread = u88.ShadowSpread,
                Transparency = u88.ShadowTransparency
            }, TweenInfo_new_ret7);
        end;
    end);
end;

function u1._setCell(p91: any, p92: number, p93: number, p94: boolean, p95: boolean?) -- Line: 496
    -- upvalues: Color3_fromRGB_ret (copy), Color3_new_ret (copy)
    local v96 = p91.Columns[p92].Arrows[p93];
    local v97 = p91.Grid[p92][p93];
    v96.Visible = true;
    local v98 = {};
    local v99;

    if p95 and not p94 then
        v99 = Color3_fromRGB_ret;
    else
        v99 = p91.ArrowColors[v96];

        if p91.ArrowColor then
            v99 = p91.ArrowColor;
        elseif p92 < 1 then
            v99 = Color3_new_ret;
        end;
    end;

    v98.ImageColor3 = v99;
    v98.ImageTransparency = p94 and 0.05 or (p95 and 0.2 or 1);
    p91:_tween(v96, v98);
    local Frame = v97.Frame;
    local v100 = {};
    local v101;

    if p94 then
        v101 = v97.BackgroundTransparency;
    else
        v101 = math.min(1, v97.BackgroundTransparency + 0.2);
    end;

    v100.BackgroundTransparency = v101;
    p91:_tween(Frame, v100);
    local Pattern = v97.Pattern;
    local v102 = {};
    local v103;

    if p94 then
        v103 = v97.PatternTransparency;
    else
        v103 = math.min(1, v97.PatternTransparency + 0.45);
    end;

    v102.ImageTransparency = v103;
    p91:_tween(Pattern, v102);

    if p94 then
        local ConnectedColor = v97.ConnectedColor;

        if p91.ArrowColor then
            ConnectedColor = p91.ArrowColor;
        elseif p92 < 1 then
            ConnectedColor = Color3_new_ret;
        end;

        v97.Connected.GroupColor3 = ConnectedColor;
    end;

    p91.ScrollingCells[v97] = p94 and true or nil;
    p91:_tween(v97.Connected, {
        GroupTransparency = p94 and 0 or 1
    });
end;

function u1._greyRows(p104: any, p105: number, p106: any) -- Line: 525
    -- upvalues: Color3_fromRGB_ret (copy)
    for i = 0, p105 do
        local v107 = i;

        for i2 in p104.LandedRows[i] do
            if not p106 or p106[i2] then
                local v108 = p104.Grid[v107][i2];
                p104:_tween(p104.Columns[v107].Arrows[i2], {
                    ImageTransparency = 0.2,
                    ImageColor3 = Color3_fromRGB_ret
                });
                p104.ScrollingCells[v108] = nil;
                p104:_tween(v108.Connected, {
                    GroupTransparency = 1
                });
            end;
        end;
    end;
end;

function u1._pulseArrow(u109: any, p110: userdata, p111: number, p112, p113: userdata?, u114: userdata?) -- Line: 541
    -- upvalues: TweenInfo_new_ret5 (copy), TweenInfo_new_ret6 (copy)
    local u115 = u109.PulseScaleByArrow[p110];

    if not u115 then
        u115 = u109.Cleanup:Add(Instance.new("UIScale"));
        u115.Name = "ConsoleArrowPulse";
        u115.Parent = p110;
        u109.PulseScaleByArrow[p110] = u115;
    end;

    if p112 then
        u109:_tween(p110, {
            ImageColor3 = p112
        }, TweenInfo_new_ret5);
    end;

    u109:_tween(u115, {
        Scale = p111
    }, p113 or TweenInfo_new_ret6).Completed:Once(function(p116) -- Line: 561
        -- upvalues: u109 (copy), u115 (ref), u114 (copy), TweenInfo_new_ret5 (ref)
        if p116 == Enum.PlaybackState.Completed and u109.State == "resolving" then
            u109:_tween(u115, {
                Scale = 1
            }, u114 or TweenInfo_new_ret5);
        end;
    end);
end;

function u1._pulsePaths(u117: any, u118: number, u119) -- Line: 569
    -- upvalues: ROW_COUNT (copy), Profiler (copy), RunService (copy)
    if u119 then
        u117.ArrowColor = u119;
    end;

    local function pulseArrow(p120: number, p121: number) -- Line: 573
        -- upvalues: u117 (copy), u118 (copy), u119 (copy)
        local v122 = u117.Columns[p120];
        local v123;

        if p120 <= u118 then
            v123 = u117.AliveRows[p121] and u117.LandedRows[p120][p121];
        else
            v123 = false;
        end;

        local v124;

        if u118 < p120 then
            v124 = v122.Arrows[p121].ImageTransparency < 1;
        else
            v124 = false;
        end;

        if not (v123 or v124) then
            return true;
        end;

        u117:_pulseArrow(v122.Arrows[p121], 1.18, u119);

        if v123 and u119 then
            u117:_tween(u117.Grid[p120][p121].Connected, {
                GroupColor3 = u119
            });
        end;

        if v124 then
            u117:_pulseArrow(v122.RepeatArrows[p121], 1.18, u119);
        end;

        task.wait(0.015);

        return u117.State == "resolving";
    end;

    local u125 = ROW_COUNT;

    local function pulsePath(p126: number) -- Line: 592
        -- upvalues: pulseArrow (copy), u118 (copy), u117 (copy)
        if not pulseArrow(u118, p126) then
            return false;
        end;

        for i = u117.ColumnCount - 1, 0, -1 do
            if i ~= u118 and not pulseArrow(i, p126) then
                return false;
            end;

            local _ = i;
        end;

        return true;
    end;

    for i = 0, ROW_COUNT - 1 do
        Profiler.spawn("CaseScene.ConsoleBoard.RarityPath", function() -- Line: 607
            -- upvalues: pulsePath (copy), i (copy), u125 (ref)
            pulsePath(i);
            u125 = u125 - 1;
        end);
        local _ = i;
    end;

    while u125 > 0 and u117.State == "resolving" do
        RunService.RenderStepped:Wait();
    end;

    local v127;

    if u117.State == "resolving" then
        task.wait(0.3);
        v127 = u117.State == "resolving";
    else
        v127 = false;
    end;

    return v127;
end;

function u1._startPinkTeaseMelody(p128) -- Line: 618
    -- upvalues: playSound (copy)
    if not p128.TeaseMelody then
        p128.TeaseMelody = playSound(p128, "Console Pink Tease Melody");
    end;
end;

function u1._stopPinkTeaseMelody(u129) -- Line: 624
    -- upvalues: TweenInfo_new_ret3 (copy)
    local TeaseMelody = u129.TeaseMelody;
    u129.TeaseMelody = nil;

    if not (TeaseMelody and u129.ActiveSounds[TeaseMelody]) then
        return;
    end;

    u129:_tween(TeaseMelody, {
        PlaybackSpeed = 0.2,
        Volume = 0
    }, TweenInfo_new_ret3).Completed:Once(function() -- Line: 635
        -- upvalues: u129 (copy), TeaseMelody (copy)
        local v130 = u129;
        local v131 = TeaseMelody;

        if v131 then
            if not v130.ActiveSounds[v131] then
                return;
            end;

            v130.ActiveSounds[v131] = nil;
            v131:Stop();
            v130.Cleanup:Remove(v131);
        end;
    end);
end;

function u1._celebrateFullPath(u132) -- Line: 640
    -- upvalues: ROW_COUNT (copy), RunService (copy)
    local os_clock_ret = os.clock();

    local function tweenPathScale(p133: number, p134: userdata) -- Line: 642
        -- upvalues: u132 (copy), ROW_COUNT (ref)
        for i = 0, u132.ColumnCount - 1 do
            local v135 = i;

            for i2 = 0, ROW_COUNT - 1 do
                local v136;

                if u132.AliveRows[i2] and u132.LandedRows[v135][i2] then
                    u132:_tween(u132.PulseScaleByArrow[u132.Columns[v135].Arrows[i2]], {
                        Scale = p133
                    }, p134);
                    v136 = i2;
                else
                    v136 = i2;
                end;
            end;
        end;
    end;

    local v137 = 0;

    while v137 <= 3.43 do
        local v138 = math.exp(v137 * -0.606) * 0.06 * u132.ColumnCount * 0.8;
        local TweenInfo_new_ret13 = TweenInfo.new(v138 * 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
        local TweenInfo_new_ret14 = TweenInfo.new(v138 * 0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for i = 0, u132.ColumnCount - 1 do
            local v139 = i;

            while u132.State == "resolving" and os.clock() - os_clock_ret < v137 + 0.1 do
                RunService.RenderStepped:Wait();
            end;

            if u132.State ~= "resolving" then
                return false;
            end;

            for i2 = 0, ROW_COUNT - 1 do
                local v140;

                if u132.AliveRows[i2] and u132.LandedRows[v139][i2] then
                    u132:_pulseArrow(u132.Columns[v139].Arrows[i2], 1.5, nil, TweenInfo_new_ret13, TweenInfo_new_ret14);
                    v140 = i2;
                else
                    v140 = i2;
                end;
            end;

            v137 = v137 + math.exp(v137 * -0.606) * 0.06;
        end;
    end;

    tweenPathScale(1.25, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out));
    task.wait(0.08);

    if u132.State ~= "resolving" then
        return false;
    end;

    local v141 = 4.2 - (os.clock() - os_clock_ret);
    local math_max_ret = math.max(0, v141);
    tweenPathScale(1.8, TweenInfo.new(math_max_ret, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut));

    while u132.State == "resolving" and os.clock() - os_clock_ret < 4.2 do
        RunService.RenderStepped:Wait();
    end;

    if u132.State ~= "resolving" then
        return false;
    end;

    tweenPathScale(1, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out));
    task.wait(0.08);

    return u132.State == "resolving";
end;

local function getChasePower(p142: number) -- Line: 706
    -- upvalues: u2 (copy)
    for i = 2, #u2 do
        local v143 = u2[i - 1];
        local v144 = u2[i];

        if p142 <= v144[1] then
            return v143[2] + (v144[2] - v143[2]) * (p142 - v143[1]) / (v144[1] - v143[1]);
        end;

        local _ = i;
    end;

    return 0;
end;

local function createChaseSegments(u145: any, u146: userdata, p147) -- Line: 717
    local X = u146.AbsoluteSize.X;
    local Y = u146.AbsoluteSize.Y;
    local v148 = math.min(X, Y) / 2;
    local v149 = math.max(X, Y) - v148 * 2;
    local u150 = 2 * (X + Y);
    local v151 = u150 / 40;
    local u152 = u146:Clone();
    u152:ClearAllChildren();
    u152.AnchorPoint = Vector2.zero;
    u152.Rotation = 0;
    u152.ImageColor3 = p147;
    u152.ImageTransparency = 1;
    local u153 = {};
    local math_round_ret = math.round(X / v151);
    local math_max_ret = math.max(1, math_round_ret);
    local math_round_ret2 = math.round(v149 / v151);
    local math_max_ret2 = math.max(1, math_round_ret2);

    local function addSegment(p154: number, p155: number, p156: number, p157: number, p158: number) -- Line: 736
        -- upvalues: u145 (copy), X (copy), Y (copy), u152 (copy), u146 (copy), u153 (copy), u150 (copy)
        local v159 = u145.Cleanup:Add(Instance.new("Frame"));
        v159.Name = "ConsoleGoldChase";
        v159.BackgroundTransparency = 1;
        v159.BorderSizePixel = 0;
        v159.ClipsDescendants = true;
        v159.Position = UDim2.fromScale(p154 / X, p155 / Y);
        v159.Size = UDim2.fromScale((p156 - p154) / X, (p157 - p155) / Y);
        local v160 = u152:Clone();
        v160.Position = UDim2.fromScale(-p154 / (p156 - p154), -p155 / (p157 - p155));
        v160.Size = UDim2.fromScale(X / (p156 - p154), Y / (p157 - p155));
        v160.Parent = v159;
        v159.Parent = u146;
        table.insert(u153, {
            Image = v160,
            Position = p158 / u150
        });
    end;

    for i = 0, math_max_ret - 1 do
        local v161 = X * i / math_max_ret;
        local v162 = X * (i + 1) / math_max_ret;
        addSegment(v161, 0, v162, v148, (v161 + v162) / 2);
        local _ = i;
    end;

    for i = 0, math_max_ret2 - 1 do
        local v163 = v148 + v149 * i / math_max_ret2;
        local v164 = v148 + v149 * (i + 1) / math_max_ret2;
        addSegment(X - v148, v163, X, v164, X + (v163 + v164) / 2);
        local _ = i;
    end;

    for i = 0, math_max_ret - 1 do
        local v165 = X * (math_max_ret - i - 1) / math_max_ret;
        local v166 = X * (math_max_ret - i) / math_max_ret;
        addSegment(v165, Y - v148, v166, Y, X + Y + X - (v165 + v166) / 2);
        local _ = i;
    end;

    for i = 0, math_max_ret2 - 1 do
        local v167 = v148 + v149 * (math_max_ret2 - i - 1) / math_max_ret2;
        local v168 = v148 + v149 * (math_max_ret2 - i) / math_max_ret2;
        addSegment(0, v167, v148, v168, 2 * X + Y + Y - (v167 + v168) / 2);
        local _ = i;
    end;

    u152:Destroy();

    return u153;
end;

function u1._chaseIndicatorsGold(p169) -- Line: 777
    -- upvalues: createChaseSegments (copy), RunServiceController (copy), getChasePower (copy)
    local v170, v171, v172 = p169.Indicators[p169.ColumnCount - 1].ImageColor:ToHSV();
    local u173 = {};

    for _, v in p169.Indicators do
        local AbsoluteSize = v.Image.AbsoluteSize;

        if v.Image.Visible and (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then
            local Color3_fromHSV_ret = Color3.fromHSV(v170 * (1 + (math.random() * 2 - 1) * 0.1), v171 * (1 - math.random() * 0.1), v172 * (1 - math.random() * 0.1));
            v.Image.ImageTransparency = 1;
            local v174 = {
                Offset = math.random(),
                Segments = createChaseSegments(p169, v.Image, Color3_fromHSV_ret)
            };
            table.insert(u173, v174);
        end;
    end;

    local os_clock_ret = os.clock();
    p169.Cleanup:Add(RunServiceController.BindToRenderStep(RunServiceController.CreateBindingName("CaseScene.ConsoleBoard.GoldChase"), function() -- Line: 802
        -- upvalues: os_clock_ret (copy), u173 (copy), getChasePower (ref)
        local v175 = (os.clock() - os_clock_ret) / 2.1;

        for _, v in u173 do
            local v176 = v;

            for _, v2 in v.Segments do
                v2.Image.ImageTransparency = 1 - getChasePower((v2.Position - v175 + v176.Offset) % 1);
            end;
        end;
    end), "Disconnect", "GoldChase");
end;

function u1._stopColumn(p177: any, p178: number) -- Line: 817
    local v179 = p177.Spinning[p178];

    if v179 then
        v179 = v179.Sound;
    end;

    if v179 and p177.ActiveSounds[v179] then
        p177.ActiveSounds[v179] = nil;
        v179:Stop();
        p177.Cleanup:Remove(v179);
    end;

    p177.Spinning[p178] = nil;
    local v180 = p177.Columns[p178];
    v180.Container.Position = v180.Position;
    v180.RepeatContainer.Position = UDim2.new(v180.Position.X.Scale, v180.Position.X.Offset, v180.Position.Y.Scale + v180.Span.Scale * -1, v180.Position.Y.Offset + v180.Span.Offset * -1);
    v180.RepeatContainer.Visible = false;
end;

function u1._revealRemainingColumns(p181: any, p182: number) -- Line: 827
    -- upvalues: setLandingRows (copy), TweenInfo_new_ret2 (copy), ROW_COUNT (copy)
    for i = p182 + 1, p181.ColumnCount - 1 do
        local v183 = p181.Spinning[i];

        if v183 then
            v183 = v183.Sound;
        end;

        if v183 and p181.ActiveSounds[v183] then
            p181.ActiveSounds[v183] = nil;
            v183:Stop();
            p181.Cleanup:Remove(v183);
        end;

        p181.Spinning[i] = nil;
        local v184 = p181.Columns[i];
        local v185 = p181.PlannedRows[i] or p181.SpinRows[i];
        p181.LandedRows[i] = v185;
        v184.RepeatContainer.Visible = false;
        setLandingRows(p181, i, v184, v185);
        v184.Container.Position = UDim2.new(v184.Position.X.Scale, v184.Position.X.Offset, v184.Position.Y.Scale + v184.Span.Scale * -0.18, v184.Position.Y.Offset + v184.Span.Offset * -0.18);
        p181:_tween(v184.Container, {
            Position = v184.Position
        }, TweenInfo_new_ret2);
        local v186 = i;

        for i2 = 0, ROW_COUNT - 1 do
            p181:_setCell(v186, i2, false, v185[i2] == true);
            local _ = i2;
        end;

        task.wait(0.11);

        if p181.State ~= "resolving" then
            return false;
        end;
    end;

    task.wait(TweenInfo_new_ret2.Time);

    return p181.State == "resolving";
end;

function u1._landColumn(p187, p188) -- Line: 851
    -- upvalues: setLandingRows (copy), RunService (copy), playSound (copy)
    local columnIndex = p188.columnIndex;
    local v189 = p187.Spinning[columnIndex];
    local v190 = (os.clock() - v189.StartedAt) % 0.21;

    if v190 > 0.01 then
        task.wait(0.21 - v190);

        if p187.State ~= "resolving" then
            return false, {};
        end;
    end;

    p187.Spinning[columnIndex] = nil;
    local v191 = p187.PlannedRows[columnIndex];
    local v192 = p187.Columns[columnIndex];
    local os_clock_ret = os.clock();
    local v193 = false;

    while p187.State == "resolving" do
        local v194 = (os.clock() - os_clock_ret) / 1.5;
        local math_min_ret = math.min(v194, 1);
        local v195 = (1 - (1 - math_min_ret) ^ 2) * 3;

        if not v193 and v195 >= 2 then
            setLandingRows(p187, columnIndex, v192, v191, false);
            v193 = true;
        end;

        if math_min_ret == 1 then
            v192.Container.Position = UDim2.new(v192.Position.X.Scale, v192.Position.X.Offset, v192.Position.Y.Scale + v192.Span.Scale * 0, v192.Position.Y.Offset + v192.Span.Offset * 0);
            v192.RepeatContainer.Position = UDim2.new(v192.Position.X.Scale, v192.Position.X.Offset, v192.Position.Y.Scale + v192.Span.Scale * -1, v192.Position.Y.Offset + v192.Span.Offset * -1);
            break;
        end;

        local Sound = v189.Sound;
        local PlaybackSpeed = v189.Sound.PlaybackSpeed;
        local math_max_ret = math.max(0.1, 1 - math_min_ret);
        Sound.PlaybackSpeed = math.min(PlaybackSpeed, math_max_ret);
        local v196 = v195 % 1;
        v192.Container.Position = UDim2.new(v192.Position.X.Scale, v192.Position.X.Offset, v192.Position.Y.Scale + v192.Span.Scale * v196, v192.Position.Y.Offset + v192.Span.Offset * v196);
        local v197 = v196 - 1;
        v192.RepeatContainer.Position = UDim2.new(v192.Position.X.Scale, v192.Position.X.Offset, v192.Position.Y.Scale + v192.Span.Scale * v197, v192.Position.Y.Offset + v192.Span.Offset * v197);
        RunService.RenderStepped:Wait();
    end;

    local Sound = v189.Sound;

    if Sound and p187.ActiveSounds[Sound] then
        p187.ActiveSounds[Sound] = nil;
        Sound:Stop();
        p187.Cleanup:Remove(Sound);
    end;

    if p187.State ~= "resolving" then
        return false, {};
    end;

    setLandingRows(p187, columnIndex, v192, v191);
    p187:_stopColumn(columnIndex);
    local v198;

    if p187.ColumnCount == 10 then
        v198 = `Console 10-Column Connect {columnIndex + 1}`;
    else
        v198 = `Console Connect {columnIndex + 1}`;
    end;

    p187.LastResolutionSound = playSound(p187, p188.result == "miss" and "Console Fail" or v198);

    if p188.result == "hit" then
        p187:_activateIndicator(columnIndex);
    end;

    RunService.RenderStepped:Wait();

    if p187.State == "resolving" then
        return true, v191;
    end;

    return false, {};
end;

function u1._spinColumn(p199: any, p200: number, p201: any) -- Line: 901
    -- upvalues: playSound (copy), ROW_COUNT (copy)
    local v202 = playSound(p199, "Console Reel Spin");
    p199.Spinning[p200] = {
        StartedAt = os.clock(),
        Sound = v202
    };
    local v203 = p199.Columns[p200];
    v203.RepeatContainer.Visible = true;
    v203.Container.Position = v203.Position;
    v203.RepeatContainer.Position = UDim2.new(v203.Position.X.Scale, v203.Position.X.Offset, v203.Position.Y.Scale + v203.Span.Scale * -1, v203.Position.Y.Offset + v203.Span.Offset * -1);
    local Arrows = v203.Arrows;

    for i = 0, ROW_COUNT - 1 do
        local v204 = p201[i] == true;
        local v205 = Arrows[i];
        v205.Visible = true;
        v205.ImageTransparency = v204 and 0 or 1;
        local _ = i;
    end;

    local RepeatArrows = v203.RepeatArrows;

    for i = 0, ROW_COUNT - 1 do
        local v206 = p201[i] == true;
        local v207 = RepeatArrows[i];
        v207.Visible = true;
        v207.ImageTransparency = v206 and 0 or 1;
        local _ = i;
    end;
end;

function u1._stopSpin(p208) -- Line: 911
    if p208.RenderConnection then
        p208.Cleanup:Remove("RenderConnection");
        p208.RenderConnection = nil;
    end;

    local ActiveSounds = p208.ActiveSounds;
    p208.ActiveSounds = {};

    for i in ActiveSounds do
        i:Stop();
        p208.Cleanup:Remove(i);
    end;

    p208.TeaseMelody = nil;
    table.clear(p208.Spinning);

    for _, v in p208.Columns do
        v.Container.Position = v.Position;
        v.RepeatContainer.Position = UDim2.new(v.Position.X.Scale, v.Position.X.Offset, v.Position.Y.Scale + v.Span.Scale * -1, v.Position.Y.Offset + v.Span.Offset * -1);
        v.RepeatContainer.Visible = false;
    end;
end;

function u1._prepareReels(p209: any, p210: table) -- Line: 931
    -- upvalues: ConsoleBoardPlanner (copy)
    local v211 = ConsoleBoardPlanner.prepare(p209.SpinRows, p209.AliveRows, p210, p209.ColumnCount);
    p209.SpinRows = v211.SpinRows;
    p209.SurvivingRows = v211.SurvivingRows;
    p209.PlannedRows = v211.PlannedRows;
end;

function u1._applyStep(p212, p213, p214) -- Line: 938
    -- upvalues: ROW_COUNT (copy)
    local v215 = p212.SurvivingRows[p213.columnIndex];
    local v216 = {};

    for i in p212.AliveRows do
        if not v215[i] then
            v216[i] = true;
        end;
    end;

    p212.LandedRows[p213.columnIndex] = p214;

    for i = 0, ROW_COUNT - 1 do
        p212:_setCell(p213.columnIndex, i, v215[i] == true, p214[i] == true);
        local _ = i;
    end;

    if p213.result ~= "miss" then
        p212:_greyRows(p213.columnIndex - 1, v216);
    end;

    p212.AliveRows = v215;
end;

function u1._finish(p217) -- Line: 956
    -- upvalues: Profiler (copy)
    p217.State = "completed";
    p217:_stopSpin();
    local OnComplete = p217.OnComplete;
    p217.OnComplete = nil;
    Profiler.defer("CaseScene.ConsoleBoard.Complete", OnComplete, p217.RolledItem);
end;

function u1._resolveStep(u218, u219) -- Line: 964
    -- upvalues: Profiler (copy)
    local v220, v221 = u218:_landColumn(u219);

    if not v220 then
        return "cancelled";
    end;

    u218:_applyStep(u219, v221);

    if u219.result == "miss" then
        u218:_stopPinkTeaseMelody();

        return u218:_revealRemainingColumns(u219.columnIndex) and "miss" or "cancelled";
    end;

    if u219.kind ~= "rarity" then
        Profiler.spawn("CaseScene.ConsoleBoard.BridgePulse", function() -- Line: 978
            -- upvalues: u218 (copy), u219 (copy)
            u218:_pulsePaths(u219.columnIndex);
        end);

        return "continue";
    end;

    if u219.columnIndex == u218.ColumnCount - 1 then
        u218:_stopPinkTeaseMelody();

        if u219.rarity == "Special" then
            u218:_chaseIndicatorsGold();
        end;
    end;

    u218:_setRarityAmbience(u218.Indicators[u219.columnIndex].ImageColor);

    if not u218:_pulsePaths(u219.columnIndex, u218.Indicators[u219.columnIndex].ImageColor) then
        return "cancelled";
    end;

    if u219.columnIndex == u218.ColumnCount - 3 then
        u218:_startPinkTeaseMelody();
    end;

    return "continue";
end;

function u1._getFinalHoldDuration(p222, p223) -- Line: 1000
    return p223.result == "miss" and 1.2 or ((p222.FinalRarity == "Red" or p222.FinalRarity == "Special") and 2 or 0.8);
end;

function u1._runResolution(p224: any, p225: table) -- Line: 1009
    -- upvalues: waitForSound (copy)
    task.wait(0.63);

    if p224.State ~= "resolving" then
        return;
    end;

    for _, v in p225 do
        local v226 = p224:_resolveStep(v);

        if v226 == "cancelled" then
            return;
        end;

        if v226 == "miss" then
            break;
        end;
    end;

    if p224.IsFullPath and not p224:_celebrateFullPath() then
        return;
    end;

    local v227 = p225[#p225];
    local RollerPlan = p224.RollerPlan;

    if not RollerPlan then
        local v228 = p224:_getFinalHoldDuration(v227);
        task.wait(v228);

        if p224.State ~= "resolving" then
            return;
        end;

        if waitForSound(p224, p224.LastResolutionSound) then
            p224:_finish();
        end;

        return;
    end;

    local v229 = v227.result == "miss" and 0.35 or p224:_getFinalHoldDuration(v227);
    task.wait(v229);
    local v230 = p224.State == "resolving" and p224:_playItemRoller(RollerPlan);
    p224.RolledItem = v230;

    if p224.RolledItem then
        task.wait(1.4);

        if p224.State == "resolving" then
            p224:_finish();
        end;
    end;
end;

function u1._setRarityAmbience(p231: any, p232) -- Line: 1046
    -- upvalues: TweenInfo_new_ret8 (copy), TweenInfo_new_ret9 (copy)
    for _, v in p231.SideLights do
        p231:_tween(v.Frame, {
            BackgroundTransparency = 0,
            BackgroundColor3 = p232
        }, TweenInfo_new_ret8);
        local Glow = v.Glow;

        if Glow then
            p231:_tween(Glow, {
                Transparency = 0.3,
                Color = p232
            }, TweenInfo_new_ret8);
        end;
    end;

    local Background = p231.Background;

    if Background.Pattern then
        p231:_tween(Background.Pattern, {
            ImageColor3 = p232
        }, TweenInfo_new_ret9);
    end;

    local Tintable = Background.Tintable;

    if not Tintable then
        return;
    end;

    if Tintable.Visible then
        p231:_tween(Tintable, {
            ImageColor3 = p232
        }, TweenInfo_new_ret9);

        return;
    end;

    Tintable.ImageColor3 = p232;
    Tintable.ImageTransparency = 1;
    Tintable.Visible = true;
    p231:_tween(Tintable, {
        ImageTransparency = Background.Restore[Tintable].ImageTransparency
    }, TweenInfo_new_ret9);

    if Background.Artwork then
        p231:_tween(Background.Artwork, {
            ImageTransparency = 1
        }, TweenInfo_new_ret9);
    end;
end;

function u1._playItemRoller(u233, p234) -- Line: 1077
    -- upvalues: TweenInfo_new_ret (copy), ConsoleItemRoller (copy)
    for i, v in u233.BoardParts do
        u233:_tween(i, {
            Position = v + UDim2.fromScale(0, 1.2)
        }, TweenInfo_new_ret);
    end;

    task.wait(TweenInfo_new_ret.Time);

    if u233.State == "resolving" then
        return ConsoleItemRoller.play(u233.RollerParent, p234, u233.Cleanup, function() -- Line: 1084
            -- upvalues: u233 (copy)
            return u233.State == "resolving";
        end);
    end;

    return false;
end;

function u1._tryResolve(u235) -- Line: 1089
    -- upvalues: ROW_COUNT (copy), Profiler (copy)
    if u235.State ~= "spinning" or not (u235.ReelsReady and (u235.SceneReady and (u235.Steps and u235.OnComplete))) then
        return;
    end;

    u235.State = "resolving";

    if u235.IsSkipped then
        u235:_finish();

        return;
    end;

    local Steps = u235.Steps;
    u235:_prepareReels(Steps);

    for i = 0, u235.ColumnCount - 1 do
        local v236 = u235.Columns[i];
        local v237 = u235.SpinRows[i];
        local Arrows = v236.Arrows;
        local _ = i;

        for i2 = 0, ROW_COUNT - 1 do
            local v238 = v237[i2] == true;
            local v239 = Arrows[i2];
            v239.Visible = true;
            v239.ImageTransparency = v238 and 0 or 1;
            local _ = i2;
        end;

        local RepeatArrows = v236.RepeatArrows;

        for i2 = 0, ROW_COUNT - 1 do
            local v240 = v237[i2] == true;
            local v241 = RepeatArrows[i2];
            v241.Visible = true;
            v241.ImageTransparency = v240 and 0 or 1;
            local _ = i2;
        end;
    end;

    Profiler.spawn("CaseScene.ConsoleBoard.Resolve", function() -- Line: 1111
        -- upvalues: u235 (copy), Steps (copy)
        u235:_runResolution(Steps);
    end);
end;

function u1.Start(u242) -- Line: 1116
    -- upvalues: ConsoleBoardPlanner (copy), ROW_COUNT (copy), RunServiceController (copy), setPatternProgress (copy), Profiler (copy)
    u242.State = "spinning";
    u242.SpinRows = ConsoleBoardPlanner.createInitialSpinRows(u242.ColumnCount);

    for i = 0, u242.ColumnCount - 1 do
        local v243 = u242.Columns[i];
        local v244 = u242.SpinRows[i];
        local Arrows = v243.Arrows;
        local _ = i;

        for i2 = 0, ROW_COUNT - 1 do
            local v245 = v244[i2] == true;
            local v246 = Arrows[i2];
            v246.Visible = true;
            v246.ImageTransparency = v245 and 0 or 1;
            local _ = i2;
        end;

        local RepeatArrows = v243.RepeatArrows;

        for i2 = 0, ROW_COUNT - 1 do
            local v247 = v244[i2] == true;
            local v248 = RepeatArrows[i2];
            v248.Visible = true;
            v248.ImageTransparency = v247 and 0 or 1;
            local _ = i2;
        end;
    end;

    u242.RenderConnection = u242.Cleanup:Add(RunServiceController.BindToRenderStep(RunServiceController.CreateBindingName("CaseScene.ConsoleBoard.Render"), function() -- Line: 1125
        -- upvalues: u242 (copy), setPatternProgress (ref)
        for i, v in u242.Spinning do
            local v249 = u242.Columns[i];
            local v250 = (os.clock() - v.StartedAt) / 0.21 % 1;
            v249.Container.Position = UDim2.new(v249.Position.X.Scale, v249.Position.X.Offset, v249.Position.Y.Scale + v249.Span.Scale * v250, v249.Position.Y.Offset + v249.Span.Offset * v250);
            local v251 = v250 - 1;
            v249.RepeatContainer.Position = UDim2.new(v249.Position.X.Scale, v249.Position.X.Offset, v249.Position.Y.Scale + v249.Span.Scale * v251, v249.Position.Y.Offset + v249.Span.Offset * v251);
        end;

        local v252 = os.clock() / 2.285714285714286 % 1;

        for i in u242.ScrollingCells do
            setPatternProgress(i, v252);
        end;
    end), "Disconnect", "RenderConnection");
    Profiler.spawn("CaseScene.ConsoleBoard.StartCascade", function() -- Line: 1140
        -- upvalues: u242 (copy)
        task.wait(1);

        for i = 0, u242.ColumnCount - 1 do
            if u242.State ~= "spinning" or u242.IsSkipped then
                return;
            end;

            u242:_spinColumn(i, u242.SpinRows[i]);
            local v253;

            if i < u242.ColumnCount - 1 then
                task.wait(0.12);
                v253 = i;
            else
                v253 = i;
            end;
        end;

        u242.ReelsReady = true;
        u242:_tryResolve();
    end);
end;

function u1.SetSceneReady(p254) -- Line: 1156
    p254.SceneReady = true;
    p254:_tryResolve();
end;

function u1.Resolve(p255: any, p256: any, p257: function, p258: any, p259: any) -- Line: 1161
    -- upvalues: ConsoleBoardPlanner (copy)
    p255.IsFullPath = p256.finalColumnIndex == p255.ColumnCount - 1;
    p255.RollerPlan = p258;
    p255.FinalRarity = p256.finalRarity or p259;
    p255.Steps = ConsoleBoardPlanner.getDisplaySteps(p256);
    p255.OnComplete = p257;
    p255:_tryResolve();
end;

function u1.Skip(p260) -- Line: 1177
    p260.IsSkipped = true;
    p260.ReelsReady = true;
    p260:_stopSpin();

    if p260.State == "resolving" then
        p260:_finish();

        return;
    end;

    p260:_tryResolve();
end;

function u1.PlayReset(u261) -- Line: 1191
    -- upvalues: TweenInfo_new_ret10 (copy), ROW_COUNT (copy), Color3_fromRGB_ret2 (copy), TweenInfo_new_ret12 (copy), TweenInfo_new_ret11 (copy)
    if u261.State ~= "completed" then
        return;
    end;

    u261.Cleanup:Remove("GoldChase");
    local Background = u261.Background;

    for i, v in Background.Restore do
        if i == Background.Tintable and not v.Visible then
            u261:_tween(i, {
                ImageTransparency = 1
            }, TweenInfo_new_ret10);
        else
            u261:_tween(i, {
                ImageTransparency = v.ImageTransparency,
                ImageColor3 = v.ImageColor3
            }, TweenInfo_new_ret10);
        end;
    end;

    for _, v in u261.SideLights do
        u261:_tween(v.Frame, {
            BackgroundColor3 = v.FrameColor,
            BackgroundTransparency = v.FrameTransparency
        }, TweenInfo_new_ret10);

        if v.Glow then
            u261:_tween(v.Glow, {
                Color = v.GlowColor,
                Transparency = v.GlowTransparency
            }, TweenInfo_new_ret10);
        end;
    end;

    local u262 = false;

    for i, v in u261.BoardParts do
        if i.Position ~= v then
            u262 = true;
        end;
    end;

    local function ease(p263: userdata, p264: table) -- Line: 1230
        -- upvalues: u262 (ref), u261 (copy), TweenInfo_new_ret10 (ref)
        local v265 = nil;

        for i, v in p264 do
            if p263[i] ~= v then
                v265 = v265 or {};
                v265[i] = v;
            end;
        end;

        if not v265 then
            return;
        end;

        if u262 then
            for i, v in v265 do
                p263[i] = v;
            end;

            return;
        end;

        u261:_tween(p263, v265, TweenInfo_new_ret10);
    end;

    table.clear(u261.ScrollingCells);

    for i, v in u261.Columns do
        local v266 = i;
        local v267 = v;

        for i2 = 0, ROW_COUNT - 1 do
            local v268 = v267.Arrows[i2];
            ease(v268, {
                ImageTransparency = 1
            });
            ease(v267.RepeatArrows[i2], {
                ImageTransparency = 1
            });
            local v269 = u261.PulseScaleByArrow[v268];

            if v269 then
                ease(v269, {
                    Scale = 1
                });
            end;

            local v270 = u261.Grid[v266][i2];
            ease(v270.Frame, {
                BackgroundTransparency = v270.BackgroundTransparency
            });
            ease(v270.Pattern, {
                ImageTransparency = v270.PatternTransparency
            });
            ease(v270.Connected, {
                GroupTransparency = 1
            });
            local _ = i2;
        end;
    end;

    for _, v in u261.Indicators do
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
            local v271;

            if child.Name == "ConsoleGoldChase" then
                v271 = child:FindFirstChildOfClass("ImageLabel");
            else
                v271 = false;
            end;

            if v271 then
                ease(v271, {
                    ImageTransparency = 1
                });
            end;
        end;
    end;

    if not u262 then
        task.wait(TweenInfo_new_ret10.Time);
        local _ = u261.State == "completed";

        return;
    end;

    local ConsoleItemRoller2 = u261.RollerParent:FindFirstChild("ConsoleItemRoller");

    if ConsoleItemRoller2 then
        for _, descendant in ConsoleItemRoller2:GetDescendants() do
            if descendant:IsA("ImageLabel") and descendant.ImageTransparency < 1 then
                u261:_tween(descendant, {
                    ImageTransparency = 1
                }, TweenInfo_new_ret12);
            end;
        end;

        task.wait(TweenInfo_new_ret12.Time);

        if u261.State ~= "completed" then
            return;
        end;
    end;

    for i, v in u261.BoardParts do
        u261:_tween(i, {
            Position = v
        }, TweenInfo_new_ret11);
    end;

    task.wait(TweenInfo_new_ret11.Time);
    local _ = u261.State == "completed";
end;

function u1.Cancel(p272) -- Line: 1307
    p272.State = "cancelled";
    p272.OnComplete = nil;
    p272:_stopSpin();
    p272.Cleanup:Cleanup();

    for i, v in p272.ArrowColors do
        i.Visible = true;
        i.ImageColor3 = v;
        i.ImageTransparency = 1;
    end;

    for _, v in p272.Grid do
        for _, v2 in v do
            v2.Frame.BackgroundTransparency = v2.BackgroundTransparency;
            v2.Pattern.ImageTransparency = v2.PatternTransparency;
            v2.Connected.GroupTransparency = 1;
            v2.Connected.GroupColor3 = v2.ConnectedColor;
            v2.PatternMask.ImageTransparency = v2.PatternMaskTransparency;
            v2.PatternMask.ClipsDescendants = v2.PatternMaskClips;
        end;
    end;

    table.clear(p272.ScrollingCells);

    for i, v in p272.BoardParts do
        i.Position = v;
    end;

    for i, v in p272.Background.Restore do
        i.Visible = v.Visible;
        i.ImageTransparency = v.ImageTransparency;
        i.ImageColor3 = v.ImageColor3;
    end;

    for _, v in p272.SideLights do
        v.Frame.BackgroundColor3 = v.FrameColor;
        v.Frame.BackgroundTransparency = v.FrameTransparency;

        if v.Glow then
            v.Glow.Color = v.GlowColor;
            v.Glow.Transparency = v.GlowTransparency;
        end;
    end;

    for _, v in p272.Indicators do
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