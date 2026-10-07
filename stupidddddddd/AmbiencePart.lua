-- ReplicatedStorage.Controllers.Observers.Game.AmbiencePart
-- Script path: ReplicatedStorage.Controllers.Observers.Game.AmbiencePart
-- Decompile time: 2.80 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Sound = require(ReplicatedStorage.Classes.Sound)
local u31 = {}
local u32 = nil
local u33 = 0

local function isPointInsideZone(a1, a2) -- Line: 40 -- types: a1: vector, a2: table
    local v1 = a2.BoundsCFrame:PointToObjectSpace(a1)
    local HalfSize = a2.HalfSize
    local v2 = false
    if (math.abs(v1.X)) <= HalfSize.X then
        v2 = false
        if (math.abs(v1.Y)) <= HalfSize.Y then
            v2 = (math.abs(v1.Z)) <= HalfSize.Z
        end
    end
    return v2
end

local function stopHeartbeatIfIdle() -- Line: 50 -- upvalues: u31 (val), u32 (ref), u33 (ref)
    if next(u31) == nil then
        if u32 then
            u32:Disconnect()
            u32 = nil
        end
        u33 = 0
    end
end

local function stepZones(a1) -- Line: 62
    -- upvalues: u33 (ref), Workspace (val), u31 (val), u32 (ref)
    local CurrentVolume, HalfSize, MaximumVolume, v1, v2, v3, v4
    u33 = u33 + a1
    if u33 < 0.06666666666666667 then
        return
    end
    local v5 = u33
    u33 = 0
    local CurrentCamera = Workspace.CurrentCamera
    local Position = CurrentCamera and CurrentCamera.CFrame.Position
    if not Position then
        return
    end
    local v6 = math.min(1, v5 * 3)
    for k, v in pairs(u31) do
        if k:IsDescendantOf(Workspace) then
            v2 = v.BoundsCFrame:PointToObjectSpace(Position)
            HalfSize = v.HalfSize
            v1 = false
            if (math.abs(v2.X)) <= HalfSize.X then
                v1 = false
                if (math.abs(v2.Y)) <= HalfSize.Y then
                    v1 = (math.abs(v2.Z)) <= HalfSize.Z
                end
            end
            for i, i2 in ipairs(v.SoundDataList) do
                MaximumVolume = v1 and i2.MaximumVolume or 0
                CurrentVolume = i2.CurrentVolume
                v3 = MaximumVolume - CurrentVolume
                if MaximumVolume > 0 and not i2.Playing then
                    i2.GlobalSound:Resume()
                    i2.Playing = true
                end
                v4 = math.abs(v3)
                if not (v4 <= 0.002) then
                    v4 = CurrentVolume + v3 * v6
                    i2.GlobalSound.Volume = v4
                    i2.CurrentVolume = v4
                else
                    if CurrentVolume ~= MaximumVolume then
                        i2.GlobalSound.Volume = MaximumVolume
                    end
                    i2.CurrentVolume = MaximumVolume
                    if MaximumVolume == 0 and i2.Playing then
                        i2.GlobalSound:Pause()
                        i2.Playing = false
                    end
                end
            end
        else
            u31[k] = nil
        end
    end
    if next(u31) == nil then
        if u32 then
            u32:Disconnect()
            u32 = nil
        end
        u33 = 0
    end
end

local function ensureHeartbeat() -- Line: 120 -- upvalues: u32 (ref), RunServiceController (val), stepZones (val)
    if u32 then
        return
    end
    u32 = RunServiceController.BindToHeartbeat("Observers.Game.AmbiencePart.UpdateZones", stepZones)
end

return (Observers.observeTag("AmbiencePart", function(a1) -- Line: 131
    -- upvalues: Janitor (val), Sound (val), SoundService (val), u31 (val), u32 (ref), RunServiceController (val)
    -- upvalues: stepZones (val), u33 (ref)
    local v1
    if not a1:IsDescendantOf(workspace) then
        return function() end
    end
    local v2 = {}
    for i, j in a1:GetChildren() do
        if j:IsA("Sound") then
            table.insert(v2, j)
        end
    end
    if #v2 <= 0 then
        return function() end
    end
    local u113 = Janitor.new()
    local v3 = {}
    local v4 = nil
    local v5 = nil
    for k, n in v2, v4, v5 do
        v1 = u113:Add((n:Clone()))
        v1.RollOffMode = Enum.RollOffMode.Inverse
        v1.RollOffMaxDistance = 10000
        v1.RollOffMinDistance = 10000
        v1.SoundGroup = Sound.GameplaySoundGroup
        v1.Parent = SoundService
        v1.PlayOnRemove = false
        v1.Volume = 0
        table.insert(v3, {
            CurrentVolume = 0,
            Playing = false,
            MaximumVolume = 0 < n.Volume and n.Volume or 1,
            GlobalSound = v1,
        })
    end
    local u37 = {SoundDataList = v3, BoundsCFrame = a1.CFrame}
    u37.HalfSize = a1.Size / 2
    u31[a1] = u37
    u113:Add(((a1:GetPropertyChangedSignal("CFrame")):Connect(function() -- Line: 176 -- upvalues: u37 (val), a1 (val)
        u37.BoundsCFrame = a1.CFrame
    end)))
    u113:Add(((a1:GetPropertyChangedSignal("Size")):Connect(function() -- Line: 179 -- upvalues: u37 (val), a1 (val)
        u37.HalfSize = a1.Size / 2
    end)))
    if not u32 then
        u32 = RunServiceController.BindToHeartbeat("Observers.Game.AmbiencePart.UpdateZones", stepZones)
    end
    u113:Add(function() -- Line: 184 -- upvalues: u31 (upval), a1 (val), u32 (upval), u33 (upval)
        u31[a1] = nil
        if next(u31) == nil then
            if u32 then
                u32:Disconnect()
                u32 = nil
            end
            u33 = 0
        end
    end)
    return function() -- Line: 189 -- upvalues: u113 (val)
        u113:Cleanup()
    end
end))