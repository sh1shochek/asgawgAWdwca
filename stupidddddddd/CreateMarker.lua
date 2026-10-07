-- ReplicatedStorage.Components.Common.VFXLibary.CreateMarker
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateMarker
-- Decompile time: 2.49 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool)
local Other = Assets:WaitForChild("Other")
local Debris = workspace:WaitForChild("Debris")
local u22 = {}
u22.Bullet = require(script.Components.Bullet)
u22.Melee = require(script.Components.Melee)
local u40 = ObjectPool.new(Other:WaitForChild("HitMarker"), {InitialSize = 4, MaxRetained = 20})
local u44 = setmetatable({}, {__mode = "k"})
local u48 = setmetatable({}, {__mode = "k"})
local u49 = {}

local function initMarkerPart(a1) -- Line: 55 -- upvalues: u44 (val), u48 (val) -- types: a1: userdata
    a1.CollisionGroup = "Debris"
    a1.CanCollide = false
    a1.CanQuery = false
    a1.CanTouch = false
    local v1 = {}
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("Decal") then
            table.insert(v1, v)
        end
    end
    u44[a1] = v1
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Enabled = false
    WeldConstraint.Part0 = a1
    WeldConstraint.Parent = a1
    u48[a1] = WeldConstraint
    return WeldConstraint
end

return function(a1, a2, a3, a4) -- Line: 80
    -- upvalues: u22 (val), u49 (val), u40 (val), u48 (val), initMarkerPart (val), u44 (val), Debris (val)
    local release
    if a1 ~= nil and a1.ClassName == "Terrain" then
        return
    end
    local v1 = u22[a2]
    assert(v1, (("%* is not apart of library \"MarkerInfo\""):format(a2)))
    debug.profilebegin("VFX.Marker")
    local v2 = #u49
    if v2 >= 20 then
        v2 = table.remove(u49, 1)
        if v2 then
            v2()
        end
    end
    local u31, u32 = u40:Acquire()
    local u37 = u48[u31]
    if not u37 then
        u37 = initMarkerPart(u31)
    end
    local v3 = v1.Properties.SizeRange()
    u31.Size = Vector3.new(v3, v3, 0.001)
    u31.CFrame = (CFrame.new(a3, a3 + a4)) * CFrame.Angles(0, 0, v1.Properties.Rotation() * 3.141592653589793 / 180)
    for i, v in ipairs(u44[u31]) do
        v.Transparency = v1.Properties.Transparency()
        v.Texture = v1.Images[math.random(1, #v1.Images)]
        v.Color3 = v1.Properties.Color3
    end
    local v4 = false
    if a1 ~= nil then
        v4 = a1:IsA("BasePart") and not a1.Anchored
    end
    u31.Anchored = true
    u31.Parent = Debris
    if v4 then
        u37.Part1 = a1
        u37.Enabled = true
        u31.Anchored = false
    end
    local u100 = {}

    function release() -- Line: 124
        -- upvalues: u100 (val), u40 (upval), u31 (val), u32 (val), u37 (val), u49 (upval), release (val)
        for i, v in ipairs(u100) do
            v:Disconnect()
        end
        table.clear(u100)
        if u40:IsAcquired(u31, u32) then
            u37.Enabled = false
            u37.Part1 = nil
            u40:Release(u31, u32)
        end
        local v1 = table.find(u49, release)
        if v1 then
            table.remove(u49, v1)
        end
    end

    table.insert(u49, release)
    if a1 ~= nil and a1:IsA("BasePart") and a1:IsDescendantOf(workspace) then
        table.insert(u100, (a1.Destroying:Once(release)))
        table.insert(u100, ((a1:GetPropertyChangedSignal("Transparency")):Connect(function() -- Line: 147 -- upvalues: a1 (val), release (val)
            if a1.Transparency == 1 then
                release()
            end
        end)))
    end
    task.delay(15, release)
    debug.profileend()
end