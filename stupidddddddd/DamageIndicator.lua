-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.DamageIndicator
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.DamageIndicator
-- Decompile time: 4.25 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local u35 = {Top = 90, Bottom = 270, Left = 0, Right = 180}
local u36 = nil
local u37 = {}

local function GetRelativeRotation(a1, a2, a3) -- Line: 54 -- types: a1: vector, a2: vector, a3: vector
    return (math.atan2(a3.Z - a1.Z, a3.X - a1.X)) - math.atan2(a2.Z - a1.Z, a2.X - a1.X)
end

local function GetQuadrantPosition(a1, a2) -- Line: 60 -- types: a1: string, a2: number
    local v1 = a2 / 3
    local v2 = {
        Top = UDim2.new(0.5, 0, 0, v1),
        Bottom = UDim2.new(0.5, 0, 1, -v1),
        Left = UDim2.new(0, v1, 0.5, 0),
        Right = UDim2.new(1, -v1, 0.5, 0),
    }
    return v2[a1]
end

local function NormalizeAngle(a1) -- Line: 70 -- types: a1: number
    local v1 = math.deg(a1) % 360
    if v1 > 180 then
        return v1 - 360
    end
    if v1 < -180 then
        v1 = v1 + 360
    end
    return v1
end

local function GetQuadrant(a1, a2, a3) -- Line: 81 -- types: a1: vector, a2: vector, a3: vector
    local v1 = a1 + a2
    local v2 = math.deg((math.atan2(a3.Z - a1.Z, a3.X - a1.X)) - (math.atan2(v1.Z - a1.Z, v1.X - a1.X))) % 360
    if v2 > 180 then
        v2 = v2 - 360
    elseif v2 < -180 then
        v2 = v2 + 360
    end
    if v2 >= -45 and v2 < 45 then
        return "Top"
    end
    if v2 >= 45 and v2 < 135 then
        return "Right"
    end
    if not (v2 >= 135) and not (v2 < -135) then
        return "Left"
    end
    return "Bottom"
end

local function scheduleCleanup(a1) -- Line: 99
    local u4 = task.delay(2, function() -- Line: 100 -- upvalues: a1 (val)
        a1:cleanup()
    end)
    a1.Janitor:Add(function() -- Line: 103 -- upvalues: u4 (val)
        if u4 then
            pcall(task.cancel, u4)
        end
    end)
    a1.CleanupThread = u4
end

function u0:construct() -- Line: 114 -- upvalues: GetQuadrantPosition (val), u35 (val), scheduleCleanup (val)
    local CameraPosition = self.CameraPosition
    local CameraLookVector = self.CameraLookVector
    local Position = self.Position
    local v1 = CameraPosition + CameraLookVector
    local v2 = math.deg((math.atan2(Position.Z - CameraPosition.Z, Position.X - CameraPosition.X)) - (math.atan2(v1.Z - CameraPosition.Z, v1.X - CameraPosition.X))) % 360
    if v2 > 180 then
        v2 = v2 - 360
    elseif v2 < -180 then
        v2 = v2 + 360
    end
    local v3 = if not (v2 >= -45) then if not (v2 >= 45) then if v2 >= 135 then "Bottom" else if not (v2 < -135) then "Left" else "Bottom" else if not (v2 < 135) then if v2 >= 135 then "Bottom" else if not (v2 < -135) then "Left" else "Bottom" else "Right" else if not (v2 < 45) then if not (v2 >= 45) then if v2 >= 135 then "Bottom" else if not (v2 < -135) then "Left" else "Bottom" else if not (v2 < 135) then if v2 >= 135 then "Bottom" else if not (v2 < -135) then "Left" else "Bottom" else "Right" else "Top"
    self.Template.Position = GetQuadrantPosition(v3, self.ScreenSize)
    self.Template.Rotation = u35[v3]
    self.Quadrant = v3
    scheduleCleanup(self)
end

function u0:cleanup() -- Line: 122 -- upvalues: LocalPlayer (val), TweenService (val)
    if self.Template and self.Template:IsDescendantOf(LocalPlayer.PlayerGui) then
        self.Janitor:Add((TweenService:Create(self.Template, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageTransparency = 1}))):Play()
        task.wait(0.5)
        self:destroy()
    end
end

function u0:refresh() -- Line: 134 -- upvalues: scheduleCleanup (val), TweenService (val)
    if self.CleanupThread then
        pcall(task.cancel, self.CleanupThread)
        self.CleanupThread = nil
    end
    if self.FadeTween then
        self.FadeTween:Cancel()
        self.FadeTween = nil
    end
    if self.SizeTween then
        self.SizeTween:Cancel()
        self.SizeTween = nil
    end
    local v1 = math.max(0, self.Template.ImageTransparency - 0.1)
    self.Template.ImageTransparency = v1
    scheduleCleanup(self)
    local v2 = self.Janitor:Add((TweenService:Create(self.Template, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(self.ScreenSize / 3, self.ScreenSize / 3),
        ImageTransparency = v1,
    })))
    v2:Play()
    self.SizeTween = v2
end

function u0.new(a1, a2, a3, a4, a5) -- Line: 162
    -- upvalues: u0 (val), Janitor (val), ReplicatedStorage (val), u36 (ref), Remotes (val), TweenService (val)
    -- upvalues: u37 (val)
    local u8 = setmetatable({}, u0)
    u8.Janitor = Janitor.new()
    u8.Template = u8.Janitor:Add((ReplicatedStorage.Assets.UI.DamageIndicator.Template:Clone()))
    u8.Template.Parent = u36
    u8.Template.ImageTransparency = 1
    u8.Template.Name = "Indicator"
    u8.Character = a1
    u8.ScreenSize = u36.AbsoluteSize.X
    u8.Position = a2
    u8.CameraLookVector = a3
    u8.CameraPosition = a4
    u8.Janitor:Add((Remotes.Character.CharacterDied.Listen(function() -- Line: 186 -- upvalues: u8 (val)
        u8:destroy()
    end)))
    u36.Visible = true
    u8:construct()
    u8.SizeTween = u8.Janitor:Add((TweenService:Create(u8.Template, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        ImageTransparency = 0.2,
        Size = UDim2.fromOffset(u8.ScreenSize / 3, u8.ScreenSize / 3),
    })))
    u8.SizeTween:Play()
    u37[a5] = u8
    return u8
end

function u0:destroy() -- Line: 215 -- upvalues: u37 (val)
    local Quadrant = self.Quadrant
    self.Janitor:Destroy()
    if Quadrant then
        u37[Quadrant] = nil
    end
end

function u0.Initialize(a1, a2) -- Line: 226
    -- upvalues: u36 (ref), Remotes (val), LocalPlayer (val), CurrentCamera (val), u37 (val), u0 (val)
    u36 = a2
    Remotes.UI.CreateDamageIndicator.Listen(function(a1) -- Line: 229
        -- upvalues: LocalPlayer (upval), CurrentCamera (upval), u37 (upval), u0 (upval)
        if LocalPlayer.Character then
            local Position = CurrentCamera.CFrame.Position
            local LookVector = CurrentCamera.CFrame.LookVector
            local v1 = Position + LookVector
            local v2 = math.deg((math.atan2(a1.Z - Position.Z, a1.X - Position.X)) - (math.atan2(v1.Z - Position.Z, v1.X - Position.X))) % 360
            if v2 > 180 then
                v2 = v2 - 360
            elseif v2 < -180 then
                v2 = v2 + 360
            end
            local v3 = if not (v2 >= -45) then if not (v2 >= 45) then if v2 >= 135 then "Bottom" else if not (v2 < -135) then "Left" else "Bottom" else if not (v2 < 135) then if v2 >= 135 then "Bottom" else if not (v2 < -135) then "Left" else "Bottom" else "Right" else if not (v2 < 45) then if not (v2 >= 45) then if v2 >= 135 then "Bottom" else if not (v2 < -135) then "Left" else "Bottom" else if not (v2 < 135) then if v2 >= 135 then "Bottom" else if not (v2 < -135) then "Left" else "Bottom" else "Right" else "Top"
            v2 = u37[v3]
            if v2 then
                v2:refresh()
                return
            end
            u0.new(LocalPlayer.Character, a1, LookVector, Position, v3)
        end
    end)
end

return u0