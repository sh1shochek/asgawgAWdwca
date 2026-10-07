-- ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelFire
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelFire
-- Decompile time: 4.17 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
game:GetService("Workspace")
local GrenadeParticles = (ReplicatedStorage:WaitForChild("Assets")):WaitForChild("GrenadeParticles")
local InnerFire = GrenadeParticles:WaitForChild("InnerFire")
local OuterFire = GrenadeParticles:WaitForChild("OuterFire")
local u31 = {}

local function FlatDistance(a1, a2) -- Line: 25 -- types: a1: vector, a2: vector
    return ((Vector3.new(a1.X, 0, a1.Z)) - Vector3.new(a2.X, 0, a2.Z)).Magnitude
end

local function GetCenter(a1) -- Line: 30 -- types: a1: table
    local v1 = Vector3.new(0, 0, 0)
    for i, v in ipairs(a1) do
        v1 = v1 + v.Position
    end
    if #a1 > 0 then
        v1 = v1 / #a1
    end
    return v1
end

local function DisableEmitters(a1) -- Line: 42 -- types: a1: userdata
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("BasePart") then
            for i2, i3 in ipairs(v:GetDescendants()) do
                if i3:IsA("ParticleEmitter") then
                    i3.Enabled = false
                end
            end
        end
    end
end

local function GetSurfaceCFrame(a1, a2) -- Line: 56 -- types: a1: vector, a2: vector
    local Unit = a2.Unit
    if 0.99 < (math.abs(Unit.Y)) then
        return CFrame.new(a1)
    end
    local v1 = math.abs(Unit.X)
    local Unit_2 = if not (math.abs(Unit.Z) <= v1) then Vector3.new(0, Unit.Y, Unit.Z).Unit else Vector3.new(Unit.X, Unit.Y, 0).Unit
    v1 = Vector3.new(Unit_2.X, 0, Unit_2.Z)
    if v1.Magnitude < 0.01 then
        return CFrame.new(a1)
    end
    local Unit_3 = v1.Unit
    local v2 = Vector3.new(Unit_3.Z, 0, -Unit_3.X)
    return CFrame.fromMatrix(a1, v2, Unit_2, -(v2:Cross(Unit_2)).Unit)
end

local function CreateVoxel(a1, a2, a3, a4, a5, a6) -- Line: 92
    -- upvalues: InnerFire (val), OuterFire (val), GetSurfaceCFrame (val)
    local v1 = (a5 and InnerFire or OuterFire):Clone()
    v1.Name = if not a5 then "OuterFireVoxel" else "InnerFireVoxel"
    v1.Size = Vector3.new(a2, 0.2, a3)
    v1.CFrame = GetSurfaceCFrame(a1, a4)
    v1.Anchored = true
    v1.CanCollide = false
    v1.CanQuery = false
    v1.CanTouch = false
    v1.CastShadow = false
    v1.Parent = a6
    for i, v in ipairs(v1:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v.Enabled = true
        end
    end
    return v1
end

local u37 = {}

function u37:Create() -- Line: 127
    -- upvalues: u31 (val), CreateVoxel (val), TweenService (val), u37 (val)
    local Magnitude, Position, Position_2, Position_3, v1, v2
    debug.profilebegin("VFX.VoxelFire.Create")
    local Folder = Instance.new("Folder")
    Folder.Name = "VoxelFire_" .. self.FireId
    u31[self.FireId] = Folder
    debug.profilebegin("VFX.VoxelFire.Create.CalculateCenter")
    local Voxels = self.Voxels
    local v3 = Vector3.new(0, 0, 0)
    for i, v in ipairs(Voxels) do
        v3 = v3 + v.Position
    end
    if #Voxels > 0 then
        v3 = v3 / #Voxels
    end
    debug.profileend()
    local v4 = nil
    local Size = Vector3.new(0, 0, 0)
    local identity = CFrame.identity
    local v5 = (1 / 0)
    debug.profilebegin("VFX.VoxelFire.Create.CreateVoxels")
    for i2, i3 in ipairs(self.Voxels) do
        Position = i3.Position
        v1 = ((Vector3.new(Position.X, 0, Position.Z)) - Vector3.new(v3.X, 0, v3.Z)).Magnitude <= 4
        v2 = CreateVoxel(i3.Position, i3.SizeX, i3.SizeZ, i3.Normal, v1, Folder)
        Position_2 = i3.Position
        Position_3 = self.Position
        Magnitude = ((Vector3.new(Position_2.X, 0, Position_2.Z)) - Vector3.new(Position_3.X, 0, Position_3.Z)).Magnitude
        if Magnitude < v5 then
            v4 = v2
            Size = v2.Size
            identity = v2.CFrame
        end
    end
    Folder.Parent = workspace:WaitForChild("Debris")
    debug.profileend()
    if v4 then
        debug.profilebegin("VFX.VoxelFire.Create.LandingBurstTween")
        local v6 = Vector3.new(Size.X, 10, Size.Z)
        local v7 = identity + identity.UpVector * ((v6.Y - Size.Y) / 2)
        v4.Size = v6
        v4.CFrame = v7
        TweenService:Create(v4, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Size, CFrame = identity}):Play()
        debug.profileend()
    end
    task.delay(self.Duration, function() -- Line: 184 -- upvalues: u31 (upval), self (val), u37 (upval)
        if u31[self.FireId] then
            u37.Destroy(self.FireId)
        end
    end)
    debug.profileend()
end

function u37.Destroy(a1) -- Line: 192 -- upvalues: u31 (val), DisableEmitters (val) -- types: a1: string
    debug.profilebegin("VFX.VoxelFire.Destroy")
    local u5 = u31[a1]
    if u5 then
        DisableEmitters(u5)
        task.delay(2, function() -- Line: 199 -- upvalues: u5 (val)
            if u5.Parent then
                u5:Destroy()
            end
        end)
        u31[a1] = nil
    end
    debug.profileend()
end

function u37.Update(a1) -- Line: 210
    -- upvalues: u31 (val), DisableEmitters (val), CreateVoxel (val)
    debug.profilebegin("VFX.VoxelFire.Update")
    local u6 = u31[a1.FireId]
    if not u6 then
        debug.profileend()
        return
    end
    DisableEmitters(u6)
    task.delay(0.3, function() -- Line: 224 -- upvalues: u6 (val), a1 (val), CreateVoxel (upval)
        local Position, v1
        debug.profilebegin("VFX.VoxelFire.Update.DelayedRebuild")
        if not u6.Parent then
            debug.profileend()
            return
        end
        for i, v in ipairs(u6:GetChildren()) do
            if v:IsA("BasePart") then
                v:Destroy()
            end
        end
        if #a1.Voxels == 0 then
            debug.profileend()
            return
        end
        local Voxels = a1.Voxels
        local v2 = Vector3.new(0, 0, 0)
        for i2, i3 in ipairs(Voxels) do
            v2 = v2 + i3.Position
        end
        if #Voxels > 0 then
            v2 = v2 / #Voxels
        end
        local Parent = u6.Parent
        u6.Parent = nil
        for i4, j in ipairs(a1.Voxels) do
            Position = j.Position
            v1 = ((Vector3.new(Position.X, 0, Position.Z)) - Vector3.new(v2.X, 0, v2.Z)).Magnitude <= 4
            CreateVoxel(j.Position, j.SizeX, j.SizeZ, j.Normal, v1, u6)
        end
        u6.Parent = Parent
        debug.profileend()
    end)
    debug.profileend()
end

function u37.DestroyAll() -- Line: 258 -- upvalues: u31 (val)
    debug.profilebegin("VFX.VoxelFire.DestroyAll")
    for k, v in pairs(u31) do
        if v.Parent then
            v:Destroy()
        end
        u31[k] = nil
    end
    debug.profileend()
end

return u37