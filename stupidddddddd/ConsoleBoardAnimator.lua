-- ReplicatedStorage.Controllers.CaseSceneController.ConsoleBoardAnimator
-- Script path: ReplicatedStorage.Controllers.CaseSceneController.ConsoleBoardAnimator
-- Decompile time: 18.84 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
require(ReplicatedStorage.Database.Custom.ConsoleTypes)
local ConsoleBoardPlanner = require(script.Parent:WaitForChild("ConsoleBoardPlanner"))
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Router = require(ReplicatedStorage.Database.Security.Router)
local COLUMN_COUNT = ConsoleBoardPlanner.COLUMN_COUNT
local ROW_COUNT = ConsoleBoardPlanner.ROW_COUNT
local u52 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local u57 = Color3.fromRGB(65, 65, 65)
local u62 = Color3.fromRGB(80, 80, 80)
local u67 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local u72 = Color3.new(1, 1, 1)
local u75 = TweenInfo.new(0.2)
local u80 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u85 = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local u90 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function getGridCells(a1) -- Line: 130 -- types: a1: userdata
    local v1 = {}
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("GuiObject") then
            table.insert(v1, v)
        end
    end
    table.sort(v1, function(a1, a2) -- Line: 137
        return a1.LayoutOrder < a2.LayoutOrder
    end)
    return v1
end

local function waitFor(a1, a2) -- Line: 143 -- types: a2: number
    task.wait(a2)
    return a1.State == "resolving"
end

local function waitForSound(a1, a2) -- Line: 148 -- upvalues: RunService (val) -- types: a2: userdata?
    while a1.State == "resolving" do
        if not a2 or not a2.Parent or not a2.IsPlaying then
            break
        end
        RunService.RenderStepped:Wait()
    end
    return a1.State == "resolving"
end

local function playSound(a1, a2) -- Line: 155 -- upvalues: Router (val) -- types: a2: string
    local u6 = Router.broadcastRouter("RunStoreSound", a2)
    assert(u6, (("[ConsoleBoardAnimator] Store sound \"%*\" is not registered"):format(a2)))
    a1.ActiveSounds[u6] = true
    a1.Cleanup:Add(u6, "Destroy", u6)
    u6.Destroying:Once(function() -- Line: 160 -- upvalues: a1 (val), u6 (val)
        a1.ActiveSounds[u6] = nil
        a1.Cleanup:RemoveNoClean(u6)
    end)
    return u6
end

local function stopSound(a1, a2) -- Line: 167 -- types: a2: userdata?
    if a2 and a1.ActiveSounds[a2] then
        a1.ActiveSounds[a2] = nil
        a2:Stop()
        a1.Cleanup:Remove(a2)
        return
    end
end

local function reelPosition(a1, a2) -- Line: 176 -- types: a1: table, a2: number
    return UDim2.new(
        a1.Position.X.Scale,
        a1.Position.X.Offset,
        a1.Position.Y.Scale + a1.Span.Scale * a2,
        a1.Position.Y.Offset + a1.Span.Offset * a2
    )
end

local function setArrowRows(a1, a2) -- Line: 185 -- upvalues: ROW_COUNT (val) -- types: a1: table
    local v1, v2
    local v3 = ROW_COUNT - 1
    for i = 0, v3 do
        v1 = a2[i] == true
        v2 = v4[i]
        v2.Visible = true
        v2.ImageTransparency = if not v1 then 1 else 0
    end
end

local function setArrowVisibility(a1, a2) -- Line: 194 -- upvalues: ROW_COUNT (val) -- types: a1: table
    local v1, v2
    local Arrows = a1.Arrows
    local v3 = ROW_COUNT - 1
    for i = 0, v3 do
        v1 = a2[i] == true
        v2 = Arrows[i]
        v2.Visible = true
        v2.ImageTransparency = if not v1 then 1 else 0
    end
    local RepeatArrows = a1.RepeatArrows
    v3 = ROW_COUNT - 1
    for j = 0, v3 do
        v1 = a2[j] == true
        v2 = RepeatArrows[j]
        v2.Visible = true
        v2.ImageTransparency = if not v1 then 1 else 0
    end
end

local function getColumnColor(a1, a2, a3, a4) -- Line: 199
    -- upvalues: u72 (val)
    if a1.ArrowColor then
        return a1.ArrowColor
    end
    if a2 < 1 and a4 ~= false then
        return u72
    end
    return a3
end

local function getArrowColor(a1, a2, a3, a4) -- Line: 209
    -- upvalues: u72 (val)
    local v1 = a1.ArrowColors[a3]
    if a1.ArrowColor then
        return a1.ArrowColor
    end
    if a2 < 1 and a4 ~= false then
        return u72
    end
    return v1
end

local function setLandingRows(a1, a2, a3, a4, a5) -- Line: 213
    -- upvalues: ROW_COUNT (val), u72 (val)
    local ArrowColor, v1, v2, v3, v4
    local v5 = ROW_COUNT - 1
    for i = 0, v5 do
        v3 = a4[i] == true
        v4 = v6.Arrows[i]
        v1 = v6.RepeatArrows[i]
        v2 = v7.ArrowColors[v4]
        v4.ImageColor3 = if not v7.ArrowColor then if not (v8 < 1) then v2 else if v9 == false then v2 else u72 else v7.ArrowColor
        v4.ImageTransparency = if not v3 then 1 else 0.05
        v1.ImageColor3 = ArrowColor
        v1.ImageTransparency = v2
    end
end

local function setReelProgress(a1, a2) -- Line: 233 -- types: a1: table, a2: number
    a1.Container.Position = UDim2.new(
        a1.Position.X.Scale,
        a1.Position.X.Offset,
        a1.Position.Y.Scale + a1.Span.Scale * a2,
        a1.Position.Y.Offset + a1.Span.Offset * a2
    )
    local RepeatContainer = a1.RepeatContainer
    local v1 = a2 - 1
    RepeatContainer.Position = UDim2.new(
        a1.Position.X.Scale,
        a1.Position.X.Offset,
        a1.Position.Y.Scale + a1.Span.Scale * v1,
        a1.Position.Y.Offset + a1.Span.Offset * v1
    )
end

local function setPatternProgress(a1, a2) -- Line: 238 -- types: a1: table, a2: number
    local PatternSpan = a1.PatternSpan
    a1.PatternPrimary.Position = UDim2.new(PatternSpan.Scale * a2, PatternSpan.Offset * a2, 0, 0)
    a1.PatternRepeat.Position = UDim2.new(PatternSpan.Scale * (a2 - 1), PatternSpan.Offset * (a2 - 1), 0, 0)
end

function u0.new(a1) -- Line: 244
    -- upvalues: getGridCells (val), Janitor (val), ConsoleBoardPlanner (val), u0 (val), COLUMN_COUNT (val)
    -- upvalues: ROW_COUNT (val), u62 (val)
    local Arrow, Arrow_2, Columns, ConnectedGrid, Frame, ImageLabel, Indicators, Pattern, Pattern_2, UIShadow, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
    local Main = a1:FindFirstChild("ConsoleLaptop", true).Screen.SurfaceGui.BundleMiniGame.Main
    local ArrowHolder = Main.ArrowHolder
    local v14 = Main["2"]
    local v15 = getGridCells(Main.Grids)
    local v16 = Janitor.new()
    local v17 = {
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
        Cleanup = v16,
        ActiveSounds = {},
        AliveRows = ConsoleBoardPlanner.createAllRows(),
        SurvivingRows = {},
        LandedRows = {},
        PlannedRows = {},
        SpinRows = {},
        PulseScaleByArrow = {},
        ScrollingCells = {},
    }
    local v18 = setmetatable(v17, u0)
    v17 = COLUMN_COUNT - 1
    for i = 0, v17 do
        v1 = ArrowHolder[tostring(i + 1)]
        Frame = v1.Frame
        v2 = v16:Add((Frame:Clone()))
        v2.Name = "ReelRepeat"
        v2.Parent = v1
        v3 = {}
        v4 = {}
        v5 = ROW_COUNT - 1
        for j = 0, v5 do
            Arrow = Frame[tostring(j + 1)].Arrow
            Arrow_2 = v2[(tostring(j + 1))].Arrow
            v3[j] = Arrow
            v4[j] = Arrow_2
            v18.ArrowColors[Arrow] = Arrow.ImageColor3
            Arrow.Visible = true
            Arrow.ImageTransparency = 1
        end
        Columns = v18.Columns
        v6 = {
            Container = Frame,
            RepeatContainer = v2,
            Position = Frame.Position,
            Span = Frame.Size.Y,
            Arrows = v3,
            RepeatArrows = v4,
        }
        Columns[i] = v6
        v2.Visible = false
        v5 = v14[tostring(i + 1)]
        ImageLabel = v5:FindFirstChildWhichIsA("ImageLabel", true)
        UIShadow = v5:FindFirstChildWhichIsA("UIShadow", true)
        Indicators = v18.Indicators
        v8 = {
            Image = ImageLabel,
            ImageColor = ImageLabel.ImageColor3,
            Shadow = UIShadow,
            ShadowTransparency = if not UIShadow then nil else UIShadow.Transparency,
            ShadowBlurRadius = if not UIShadow then nil else UIShadow.BlurRadius,
            ShadowSpread = if not UIShadow then nil else UIShadow.Spread,
        }
        Indicators[i] = v8
        ImageLabel.ImageColor3 = u62
        if UIShadow then
            UIShadow.Transparency = 1
        end
        v18.Grid[i] = {}
        v7 = ROW_COUNT - 1
        for k = 0, v7 do
            v9 = v15[k * COLUMN_COUNT + i + 1]
            Pattern = v9.Pattern
            ConnectedGrid = v9.ConnectedGrid
            Pattern_2 = ConnectedGrid.ArrowTemplate3.Pattern
            v10 = v16:Add((Pattern_2:Clone()))
            v10.Name = "PatternPrimary"
            v10.AnchorPoint = Vector2.zero
            v10.Position = UDim2.fromScale(0, 0)
            v10.Size = Pattern_2.TileSize
            v10.Rotation = 0
            v10.ScaleType = Enum.ScaleType.Stretch
            v10.Parent = Pattern_2
            v11 = v16:Add((v10:Clone()))
            v11.Name = "PatternRepeat"
            v11.Position = UDim2.new(-v10.Size.X.Scale, -v10.Size.X.Offset, 0, 0)
            v11.Parent = Pattern_2
            v12 = v18.Grid[i]
            v13 = {
                Frame = v9,
                Pattern = Pattern,
                Connected = ConnectedGrid,
                PatternMask = Pattern_2,
                PatternPrimary = v10,
                PatternRepeat = v11,
                PatternSpan = v10.Size.X,
                PatternMaskTransparency = Pattern_2.ImageTransparency,
                PatternMaskClips = Pattern_2.ClipsDescendants,
                BackgroundTransparency = v9.BackgroundTransparency,
                PatternTransparency = Pattern.ImageTransparency,
                ConnectedColor = ConnectedGrid.GroupColor3,
            }
            v12[k] = v13
            Pattern_2.ImageTransparency = 1
            Pattern_2.ClipsDescendants = true
        end
    end
    return v18
end

function u0:_tween(a2, a3, a4) -- Line: 358
    -- upvalues: TweenService (val), u75 (val)
    local u15 = TweenService:Create(a2, a4 or u75, a3)
    self.Cleanup:Add(u15, "Cancel", u15)
    u15.Completed:Once(function() -- Line: 366 -- upvalues: self (val), u15 (val)
        self.Cleanup:RemoveNoClean(u15)
    end)
    u15:Play()
    return u15
end

function u0:_activateIndicator(a2) -- Line: 373 -- upvalues: u72 (val), u80 (val), u90 (val) -- types: a2: number
    local u3 = self.Indicators[a2]
    local v1 = self:_tween(u3.Image, {ImageColor3 = u3.ImageColor:Lerp(u72, 0.35)}, u80)
    local Shadow = u3.Shadow
    if Shadow then
        local ShadowBlurRadius = u3.ShadowBlurRadius
        local ShadowSpread = u3.ShadowSpread
        self:_tween(Shadow, {
            Transparency = 0.05,
            BlurRadius = UDim.new(ShadowBlurRadius.Scale, ShadowBlurRadius.Offset + 18),
            Spread = UDim2.new(ShadowSpread.X.Scale, ShadowSpread.X.Offset + 8, ShadowSpread.Y.Scale, ShadowSpread.Y.Offset + 8),
        }, u80)
    end
    v1.Completed:Once(function(a1) -- Line: 386 -- upvalues: self (val), u3 (val), u90 (upval), Shadow (val)
        if a1 == Enum.PlaybackState.Completed and self.State == "resolving" then
            self:_tween(u3.Image, {ImageColor3 = u3.ImageColor}, u90)
            if Shadow then
                self:_tween(Shadow, {
                    BlurRadius = u3.ShadowBlurRadius,
                    Spread = u3.ShadowSpread,
                    Transparency = u3.ShadowTransparency,
                }, u90)
            end
            return
        end
    end)
end

function u0:_setCell(a2, a3, a4, a5) -- Line: 401
    -- upvalues: u57 (val), u72 (val)
    local ArrowColor
    local v1 = self.Columns[a2].Arrows[a3]
    local v2 = self.Grid[a2][a3]
    v1.Visible = true
    local v3 = {}
    if not a5 or a4 then
        local v4 = self.ArrowColors[v1]
        ArrowColor = if not self.ArrowColor then if not (a2 < 1) then v4 else u72 else self.ArrowColor
    else
        ArrowColor = u57
    end
    v3.ImageColor3 = ArrowColor
    v3.ImageTransparency = if not a4 then if not a5 then 1 else 0.2 else 0.05
    self:_tween(v1, v3)
    local Frame = v2.Frame
    v3 = {}
    local BackgroundTransparency = if not a4 then math.min(1, v2.BackgroundTransparency + 0.2) else v2.BackgroundTransparency
    v3.BackgroundTransparency = BackgroundTransparency
    self:_tween(Frame, v3)
    local Pattern = v2.Pattern
    v3 = {}
    local PatternTransparency = if not a4 then math.min(1, v2.PatternTransparency + 0.45) else v2.PatternTransparency
    v3.ImageTransparency = PatternTransparency
    self:_tween(Pattern, v3)
    if a4 then
        local Connected = v2.Connected
        local ConnectedColor = v2.ConnectedColor
        Connected.GroupColor3 = if not self.ArrowColor then if not (a2 < 1) then ConnectedColor else u72 else self.ArrowColor
    end
    local v5 = if not a4 then nil else true
    self.ScrollingCells[v2] = v5
    self:_tween(v2.Connected, {GroupTransparency = if not a4 then 1 else 0})
end

function u0:_greyRows(a2, a3) -- Line: 430 -- upvalues: u57 (val) -- types: a2: number
    local v1, v2, v3, v4
    local v5, v6 = self, a3
    for i = 0, a2 do
        v2 = v5.LandedRows[i]
        v3 = nil
        v4 = nil
        for j in v2, v3, v4 do
            if not v6 or v6[j] then
                v1 = v5.Grid[i][j]
                v5:_tween(v5.Columns[i].Arrows[j], {ImageTransparency = 0.2, ImageColor3 = u57})
                v5.ScrollingCells[v1] = nil
                v5:_tween(v1.Connected, {GroupTransparency = 1})
            end
        end
    end
end

function u0:_pulseArrow(a2, a3, a4, a5, a6) -- Line: 446
    -- upvalues: u80 (val), u85 (val)
    local u15 = self.PulseScaleByArrow[a2]
    if not u15 then
        u15 = self.Cleanup:Add((Instance.new("UIScale")))
        u15.Name = "ConsoleArrowPulse"
        u15.Parent = a2
        self.PulseScaleByArrow[a2] = u15
    end
    if a4 then
        self:_tween(a2, {ImageColor3 = a4}, u80)
    end
    ;(self:_tween(u15, {Scale = a3}, a5 or u85)).Completed:Once(function(a1) -- Line: 466 -- upvalues: self (val), u15 (ref), a6 (val), u80 (upval)
        if a1 == Enum.PlaybackState.Completed and self.State == "resolving" then
            self:_tween(u15, {Scale = 1}, a6 or u80)
        end
    end)
end

function u0:_transitionRarityColor(a2, a3) -- Line: 473
    -- upvalues: COLUMN_COUNT (val), ROW_COUNT (val), Profiler (val), RunService (val)
    self.ArrowColor = a3

    local function pulseArrow(a1, a2_2) -- Line: 475
        -- upvalues: self (val), a2 (val), a3 (val)
        local v1 = self.Columns[a1]
        local v2 = false
        if a1 <= a2 then
            v2 = self.AliveRows[a2_2] and self.LandedRows[a1][a2_2]
        end
        local v3 = false
        if a2 < a1 then
            v3 = v1.Arrows[a2_2].ImageTransparency < 1
        end
        if not v2 and not v3 then
            return true
        end
        self:_pulseArrow(v1.Arrows[a2_2], 1.18, a3)
        if v2 then
            self:_tween(self.Grid[a1][a2_2].Connected, {GroupColor3 = a3})
        end
        if v3 then
            self:_pulseArrow(v1.RepeatArrows[a2_2], 1.18, a3)
        end
        local v4 = self
        task.wait(0.015)
        return v4.State == "resolving"
    end

    local function pulsePath(a1) -- Line: 494
        -- upvalues: pulseArrow (val), a2 (val), COLUMN_COUNT (upval)
        if not pulseArrow(a2, a1) then
            return false
        end
        for i = COLUMN_COUNT - 1, 0, -1 do
            if i ~= a2 and not pulseArrow(i, a1) then
                return false
            end
        end
        return true
    end

    local u5 = ROW_COUNT
    local v1 = ROW_COUNT - 1
    for i = 0, v1 do
        Profiler.spawn("CaseScene.ConsoleBoard.RarityPath", function() -- Line: 509 -- upvalues: pulsePath (val), i (val), u5 (ref)
            pulsePath(i)
            u5 = u5 - 1
        end)
    end
    while u5 > 0 do
        if self.State ~= "resolving" then
            break
        end
        RunService.RenderStepped:Wait()
    end
    v1 = false
    if self.State == "resolving" then
        task.wait(0.3)
        v1 = self.State == "resolving"
    end
    return v1
end

function u0:_startPinkTeaseMelody() -- Line: 520 -- upvalues: playSound (val)
    if not self.TeaseMelody then
        self.TeaseMelody = playSound(self, "Console Pink Tease Melody")
    end
end

function u0:_stopPinkTeaseMelody() -- Line: 526 -- upvalues: u67 (val)
    local TeaseMelody = self.TeaseMelody
    self.TeaseMelody = nil
    if TeaseMelody and self.ActiveSounds[TeaseMelody] then
        (self:_tween(TeaseMelody, {PlaybackSpeed = 0.2, Volume = 0}, u67)).Completed:Once(function() -- Line: 537 -- upvalues: self (val), TeaseMelody (val)
            local v1 = self
            local v2 = TeaseMelody
            if v2 then
                if not v1.ActiveSounds[v2] then
                    return
                end
                v1.ActiveSounds[v2] = nil
                v2:Stop()
                v1.Cleanup:Remove(v2)
            end
        end)
        return
    end
end

function u0:_celebrateFullPath() -- Line: 542 -- upvalues: COLUMN_COUNT (val), ROW_COUNT (val), RunService (val)
    local v1, v2, v3, v4, v5, v6
    local v7 = os.clock()

    local function tweenPathScale(a1, a2) -- Line: 544
        -- upvalues: COLUMN_COUNT (upval), ROW_COUNT (upval), self (val)
        local v1
        local v2 = COLUMN_COUNT - 1
        local v3, v4 = a1, a2
        for i = 0, v2 do
            v1 = ROW_COUNT - 1
            for j = 0, v1 do
                if self.AliveRows[j] and self.LandedRows[i][j] then
                    self:_tween(self.PulseScaleByArrow[self.Columns[i].Arrows[j]], {Scale = v3}, v4)
                end
            end
        end
    end

    local v8 = 0
    while v8 <= 3.43 do
        v3 = math.exp(v8 * -0.606) * 0.06 * COLUMN_COUNT * 0.8
        v4 = TweenInfo.new(v3 * 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        v5 = TweenInfo.new(v3 * 0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        v6 = COLUMN_COUNT - 1
        for i = 0, v6 do
            v1 = v8 + 0.1
            while self.State == "resolving" do
                if not (os.clock() - v7 < v1) then
                    break
                end
                RunService.RenderStepped:Wait()
            end
            if self.State ~= "resolving" then
                return false
            end
            v2 = ROW_COUNT - 1
            for j = 0, v2 do
                if self.AliveRows[j] and self.LandedRows[i][j] then
                    self:_pulseArrow(self.Columns[i].Arrows[j], 1.5, nil, v4, v5)
                end
            end
            v8 = v8 + math.exp(v8 * -0.606) * 0.06
        end
    end
    tweenPathScale(1.25, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
    task.wait(0.08)
    if not (self.State == "resolving") then
        return false
    end
    local v9 = math.max(0, 4.2 - ((os.clock()) - v7))
    tweenPathScale(1.8, TweenInfo.new(v9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
    while self.State == "resolving" do
        if not (os.clock() - v7 < 4.2) then
            break
        end
        RunService.RenderStepped:Wait()
    end
    if self.State ~= "resolving" then
        return false
    end
    tweenPathScale(1, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
    task.wait(0.08)
    return self.State == "resolving"
end

function u0:_stopColumn(a2) -- Line: 608 -- types: a2: number
    local v1 = self.Spinning[a2]
    local Sound = v1 and v1.Sound
    if Sound and self.ActiveSounds[Sound] then
        self.ActiveSounds[Sound] = nil
        Sound:Stop()
        self.Cleanup:Remove(Sound)
    end
    self.Spinning[a2] = nil
    local v2 = self.Columns[a2]
    v2.Container.Position = v2.Position
    v2.RepeatContainer.Position = UDim2.new(
        v2.Position.X.Scale,
        v2.Position.X.Offset,
        v2.Position.Y.Scale + v2.Span.Scale * -1,
        v2.Position.Y.Offset + v2.Span.Offset * -1
    )
    v2.RepeatContainer.Visible = false
end

function u0:_revealRemainingColumns(a2) -- Line: 618
    -- upvalues: COLUMN_COUNT (val), setLandingRows (val), u52 (val), ROW_COUNT (val)
    local Sound, v1, v2, v3, v4, v5
    local v6 = a2 + 1
    local v7 = COLUMN_COUNT - 1
    for i = v6, v7 do
        v2 = self.Spinning[i]
        Sound = v2 and v2.Sound
        if Sound and self.ActiveSounds[Sound] then
            self.ActiveSounds[Sound] = nil
            Sound:Stop()
            self.Cleanup:Remove(Sound)
        end
        self.Spinning[i] = nil
        v3 = self.Columns[i]
        v4 = self.PlannedRows[i] or self.SpinRows[i]
        self.LandedRows[i] = v4
        v3.RepeatContainer.Visible = false
        setLandingRows(self, i, v3, v4)
        v3.Container.Position = UDim2.new(
            v3.Position.X.Scale,
            v3.Position.X.Offset,
            v3.Position.Y.Scale + v3.Span.Scale * -0.18,
            v3.Position.Y.Offset + v3.Span.Offset * -0.18
        )
        self:_tween(v3.Container, {Position = v3.Position}, u52)
        v5 = ROW_COUNT - 1
        for j = 0, v5 do
            v1 = v4[j] == true
            self:_setCell(i, j, false, v1)
        end
        task.wait(0.11)
        if not (self.State == "resolving") then
            return false
        end
    end
    task.wait(u52.Time)
    return self.State == "resolving"
end

function u0:_landColumn(a2) -- Line: 642 -- upvalues: setLandingRows (val), RunService (val), playSound (val)
    local RepeatContainer_2, v1, v2, v3, v4
    local columnIndex = a2.columnIndex
    local v5 = self.Spinning[columnIndex]
    local v6 = (os.clock() - v5.StartedAt) % 0.21
    if v6 > 0.01 then
        task.wait(0.21 - v6)
        if not (self.State == "resolving") then
            return false, {}
        end
    end
    self.Spinning[columnIndex] = nil
    local v7 = self.PlannedRows[columnIndex]
    local v8 = self.Columns[columnIndex]
    local v9 = os.clock()
    local v10 = false
    while self.State == "resolving" do
        v1 = math.min(((os.clock()) - v9) / 1.5, 1)
        v2 = (1 - (1 - v1) ^ 2) * 3
        if not v10 and v2 >= 2 then
            setLandingRows(self, columnIndex, v8, v7, false)
        end
        if v1 == 1 then
            v8.Container.Position = UDim2.new(
                v8.Position.X.Scale,
                v8.Position.X.Offset,
                v8.Position.Y.Scale + v8.Span.Scale * 0,
                v8.Position.Y.Offset + v8.Span.Offset * 0
            )
            v8.RepeatContainer.Position = UDim2.new(
                v8.Position.X.Scale,
                v8.Position.X.Offset,
                v8.Position.Y.Scale + v8.Span.Scale * -1,
                v8.Position.Y.Offset + v8.Span.Offset * -1
            )
            break
        end
        v5.Sound.PlaybackSpeed = math.min(v5.Sound.PlaybackSpeed, (math.max(0.1, 1 - v1)))
        v3 = v2 % 1
        v8.Container.Position = UDim2.new(
            v8.Position.X.Scale,
            v8.Position.X.Offset,
            v8.Position.Y.Scale + v8.Span.Scale * v3,
            v8.Position.Y.Offset + v8.Span.Offset * v3
        )
        RepeatContainer_2 = v8.RepeatContainer
        v4 = v3 - 1
        RepeatContainer_2.Position = UDim2.new(
            v8.Position.X.Scale,
            v8.Position.X.Offset,
            v8.Position.Y.Scale + v8.Span.Scale * v4,
            v8.Position.Y.Offset + v8.Span.Offset * v4
        )
        RunService.RenderStepped:Wait()
    end
    local Sound_3 = v5.Sound
    if Sound_3 and self.ActiveSounds[Sound_3] then
        self.ActiveSounds[Sound_3] = nil
        Sound_3:Stop()
        self.Cleanup:Remove(Sound_3)
    end
    if self.State ~= "resolving" then
        return false, {}
    end
    setLandingRows(self, columnIndex, v8, v7)
    self:_stopColumn(columnIndex)
    self.LastResolutionSound = playSound(self, if a2.result ~= "miss" then ("Console Connect %*"):format(columnIndex + 1) else "Console Fail")
    if a2.result == "hit" then
        self:_activateIndicator(columnIndex)
    end
    RunService.RenderStepped:Wait()
    if self.State ~= "resolving" then
        return false, {}
    end
    return true, v7
end

function u0:_spinColumn(a2, a3) -- Line: 690 -- upvalues: playSound (val), ROW_COUNT (val) -- types: a2: number
    local v1, v2
    local v3 = playSound(self, "Console Reel Spin")
    self.Spinning[a2] = {StartedAt = os.clock(), Sound = v3}
    local v4 = self.Columns[a2]
    v4.RepeatContainer.Visible = true
    v4.Container.Position = v4.Position
    v4.RepeatContainer.Position = UDim2.new(
        v4.Position.X.Scale,
        v4.Position.X.Offset,
        v4.Position.Y.Scale + v4.Span.Scale * -1,
        v4.Position.Y.Offset + v4.Span.Offset * -1
    )
    local Arrows = v4.Arrows
    local v5 = ROW_COUNT - 1
    for i = 0, v5 do
        v2 = a3[i] == true
        v1 = Arrows[i]
        v1.Visible = true
        v1.ImageTransparency = if not v2 then 1 else 0
    end
    local RepeatArrows = v4.RepeatArrows
    v5 = ROW_COUNT - 1
    for j = 0, v5 do
        v2 = a3[j] == true
        v1 = RepeatArrows[j]
        v1.Visible = true
        v1.ImageTransparency = if not v2 then 1 else 0
    end
end

function u0:_stopSpin() -- Line: 700
    if self.RenderConnection then
        self.Cleanup:Remove("RenderConnection")
        self.RenderConnection = nil
    end
    local ActiveSounds = self.ActiveSounds
    self.ActiveSounds = {}
    for i in ActiveSounds do
        i:Stop()
        self.Cleanup:Remove(i)
    end
    self.TeaseMelody = nil
    table.clear(self.Spinning)
    for j, k in self.Columns do
        k.Container.Position = k.Position
        k.RepeatContainer.Position = UDim2.new(k.Position.X.Scale, k.Position.X.Offset, k.Position.Y.Scale + k.Span.Scale * -1, k.Position.Y.Offset + k.Span.Offset * -1)
        k.RepeatContainer.Visible = false
    end
end

function u0:_prepareReels(a2) -- Line: 720 -- upvalues: ConsoleBoardPlanner (val) -- types: a2: table
    local v1 = ConsoleBoardPlanner.prepare(self.SpinRows, self.AliveRows, a2)
    self.SpinRows = v1.SpinRows
    self.SurvivingRows = v1.SurvivingRows
    self.PlannedRows = v1.PlannedRows
end

function u0:_applyStep(a2, a3) -- Line: 727 -- upvalues: ROW_COUNT (val)
    local columnIndex, v1, v2, v3
    local v4 = self.SurvivingRows[a2.columnIndex]
    local v5 = {}
    for i in self.AliveRows do
        if not v4[i] then
            v5[i] = true
        end
    end
    self.LandedRows[a2.columnIndex] = a3
    local v6 = ROW_COUNT - 1
    local v7 = a2
    for j = 0, v6 do
        columnIndex = v7.columnIndex
        v2 = v4[j] == true
        v3 = v8[j] == true
        v1:_setCell(columnIndex, j, v2, v3)
    end
    if v7.result ~= "miss" then
        v1:_greyRows(v7.columnIndex - 1, v5)
    end
    v1.AliveRows = v4
end

function u0:_finish() -- Line: 745 -- upvalues: Profiler (val)
    self.State = "completed"
    self:_stopSpin()
    local OnComplete = self.OnComplete
    self.OnComplete = nil
    Profiler.defer("CaseScene.ConsoleBoard.Complete", OnComplete)
end

function u0:_resolveStep(a2) -- Line: 753
    local v1, v2 = self:_landColumn(a2)
    if not v1 then
        return "cancelled"
    end
    self:_applyStep(a2, v2)
    if a2.result == "miss" then
        self:_stopPinkTeaseMelody()
        if self:_revealRemainingColumns(a2.columnIndex) then
            return "miss"
        end
        return "cancelled"
    end
    if a2.kind ~= "rarity" then
        return "continue"
    end
    if a2.rarity == "Red" then
        self:_stopPinkTeaseMelody()
    end
    if not self:_transitionRarityColor(a2.columnIndex, self.Indicators[a2.columnIndex].ImageColor) then
        return "cancelled"
    end
    if a2.rarity == "Pink" then
        self:_startPinkTeaseMelody()
    end
    return "continue"
end

function u0:_getFinalHoldDuration(a2) -- Line: 780
    if a2.result == "miss" then
        return 1.2
    end
    if self.FinalRarity == "Red" then
        return 2
    end
    return 0.8
end

function u0:_runResolution(a2) -- Line: 787 -- upvalues: waitForSound (val) -- types: a2: table
    local v1
    task.wait(0.63)
    if not (self.State == "resolving") then
        return
    end
    for i, j in a2 do
        v1 = self:_resolveStep(j)
        if v1 == "cancelled" then
            return
        end
        if v1 == "miss" then
            break
        end
    end
    if self.IsFullPath and not self:_celebrateFullPath() then
        return
    end
    task.wait((self:_getFinalHoldDuration(a2[#a2])))
    if not (self.State == "resolving") then
        return
    end
    if waitForSound(self, self.LastResolutionSound) then
        self:_finish()
    end
end

function u0:_tryResolve() -- Line: 812 -- upvalues: COLUMN_COUNT (val), ROW_COUNT (val), Profiler (val)
    if self.State == "spinning" and self.ReelsReady and self.SceneReady and self.Steps and self.OnComplete then
        local Arrows, RepeatArrows, v1, v2, v3, v4, v5
        self.State = "resolving"
        if self.IsSkipped then
            self:_finish()
            return
        end
        local Steps = self.Steps
        self:_prepareReels(Steps)
        local v6 = COLUMN_COUNT - 1
        for i = 0, v6 do
            v3 = self.Columns[i]
            v4 = self.SpinRows[i]
            Arrows = v3.Arrows
            v5 = ROW_COUNT - 1
            for j = 0, v5 do
                v1 = v4[j] == true
                v2 = Arrows[j]
                v2.Visible = true
                v2.ImageTransparency = if not v1 then 1 else 0
            end
            RepeatArrows = v3.RepeatArrows
            v5 = ROW_COUNT - 1
            for k = 0, v5 do
                v1 = v4[k] == true
                v2 = RepeatArrows[k]
                v2.Visible = true
                v2.ImageTransparency = if not v1 then 1 else 0
            end
        end
        Profiler.spawn("CaseScene.ConsoleBoard.Resolve", function() -- Line: 834 -- upvalues: self (val), Steps (val)
            self:_runResolution(Steps)
        end)
        return
    end
end

function u0.Start(a1) -- Line: 839
    -- upvalues: ConsoleBoardPlanner (val), COLUMN_COUNT (val), ROW_COUNT (val), RunServiceController (val)
    -- upvalues: setPatternProgress (val), Profiler (val)
    local Arrows, RepeatArrows, v1, v2, v3, v4, v5
    a1.State = "spinning"
    a1.SpinRows = ConsoleBoardPlanner.createInitialSpinRows()
    local v6 = COLUMN_COUNT - 1
    for i = 0, v6 do
        v3 = a1.Columns[i]
        v4 = a1.SpinRows[i]
        Arrows = v3.Arrows
        v5 = ROW_COUNT - 1
        for j = 0, v5 do
            v1 = v4[j] == true
            v2 = Arrows[j]
            v2.Visible = true
            v2.ImageTransparency = if not v1 then 1 else 0
        end
        RepeatArrows = v3.RepeatArrows
        v5 = ROW_COUNT - 1
        for k = 0, v5 do
            v1 = v4[k] == true
            v2 = RepeatArrows[k]
            v2.Visible = true
            v2.ImageTransparency = if not v1 then 1 else 0
        end
    end
    a1.RenderConnection = a1.Cleanup:Add(RunServiceController.BindToRenderStep(RunServiceController.CreateBindingName("CaseScene.ConsoleBoard.Render"), function() -- Line: 848 -- upvalues: a1 (val), setPatternProgress (upval)
        local RepeatContainer, v1, v2, v3
        for i, j in a1.Spinning do
            v1 = a1.Columns[i]
            v2 = (os.clock() - j.StartedAt) / 0.21 % 1
            v1.Container.Position = UDim2.new(
                v1.Position.X.Scale,
                v1.Position.X.Offset,
                v1.Position.Y.Scale + v1.Span.Scale * v2,
                v1.Position.Y.Offset + v1.Span.Offset * v2
            )
            RepeatContainer = v1.RepeatContainer
            v3 = v2 - 1
            RepeatContainer.Position = UDim2.new(
                v1.Position.X.Scale,
                v1.Position.X.Offset,
                v1.Position.Y.Scale + v1.Span.Scale * v3,
                v1.Position.Y.Offset + v1.Span.Offset * v3
            )
        end
        local v4 = os.clock() / 2.285714285714286 % 1
        for k in a1.ScrollingCells do
            setPatternProgress(k, v4)
        end
    end), "Disconnect", "RenderConnection")
    Profiler.spawn("CaseScene.ConsoleBoard.StartCascade", function() -- Line: 863 -- upvalues: COLUMN_COUNT (upval), a1 (val)
        local v1, v2
        task.wait(1)
        local v3 = COLUMN_COUNT - 1
        for i = 0, v3 do
            if a1.State == "spinning" and not a1.IsSkipped then
                v1 = a1
                v2 = a1.SpinRows[i]
                v1:_spinColumn(i, v2)
                if i < COLUMN_COUNT - 1 then
                    task.wait(0.12)
                end
                continue
            end
            return
        end
        a1.ReelsReady = true
        a1:_tryResolve()
    end)
end

function u0.SetSceneReady(a1) -- Line: 879
    a1.SceneReady = true
    a1:_tryResolve()
end

function u0.Resolve(a1, a2, a3) -- Line: 884
    -- upvalues: COLUMN_COUNT (val), ConsoleBoardPlanner (val)
    a1.IsFullPath = a2.finalColumnIndex == COLUMN_COUNT - 1
    a1.FinalRarity = a2.finalRarity
    a1.Steps = ConsoleBoardPlanner.getDisplaySteps(a2)
    a1.OnComplete = a3
    a1:_tryResolve()
end

function u0.Skip(a1) -- Line: 892
    a1.IsSkipped = true
    a1.ReelsReady = true
    a1:_stopSpin()
    if a1.State == "resolving" then
        a1:_finish()
        return
    end
    a1:_tryResolve()
end

function u0.Cancel(a1) -- Line: 903
    local Shadow
    a1.State = "cancelled"
    a1.OnComplete = nil
    a1:_stopSpin()
    a1.Cleanup:Cleanup()
    for i, j in a1.ArrowColors do
        i.Visible = true
        i.ImageColor3 = j
        i.ImageTransparency = 1
    end
    local v1 = nil
    local v2 = nil
    local v3 = a1
    for k, n in a1.Grid, v1, v2 do
        for m, i5 in n do
            i5.Frame.BackgroundTransparency = i5.BackgroundTransparency
            i5.Pattern.ImageTransparency = i5.PatternTransparency
            i5.Connected.GroupTransparency = 1
            i5.Connected.GroupColor3 = i5.ConnectedColor
            i5.PatternMask.ImageTransparency = i5.PatternMaskTransparency
            i5.PatternMask.ClipsDescendants = i5.PatternMaskClips
        end
    end
    table.clear(v3.ScrollingCells)
    for i6, i7 in v3.Indicators do
        i7.Image.ImageColor3 = i7.ImageColor
        Shadow = i7.Shadow
        if Shadow then
            Shadow.Transparency = i7.ShadowTransparency
            Shadow.BlurRadius = i7.ShadowBlurRadius
            Shadow.Spread = i7.ShadowSpread
        end
    end
end

return u0