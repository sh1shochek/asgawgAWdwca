-- ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelSmoke
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelSmoke
-- Decompile time: 9.72 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Smoke = ((ReplicatedStorage:WaitForChild("Assets")):WaitForChild("GrenadeParticles")):WaitForChild("Smoke")
local u26 = {}
u26.Terrorists = Color3.fromRGB(185, 170, 145)
u26["Counter-Terrorists"] = Color3.fromRGB(155, 170, 190)
local u37 = {}
local u38 = {}
local u39 = {}
local u40 = {}
local u41 = nil

local function StopEmitterLoop() -- Line: 50 -- upvalues: u41 (ref)
    if u41 then
        u41:Disconnect()
        u41 = nil
    end
end

local function StartEmitterLoop() -- Line: 57 -- upvalues: u41 (ref), RunServiceController (val), u40 (val)
    if u41 then
        return
    end
    u41 = RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function() -- Line: 62 -- upvalues: u40 (upval), u41 (upval)
        local v1, v2
        local v3 = tick()
        for k, v in pairs(u40) do
            if not k.Parent or not v.isActive then
                u40[k] = nil
            elseif not v.emissionStopped then
                if not v.lifetimeExtended then
                    v.lifetimeExtended = true
                    v.activatedTime = v3
                    for i, i2 in ipairs(v.emitters) do
                        if i2 and i2.Parent then
                            i2.Lifetime = NumberRange.new((1 / 0))
                        end
                    end
                end
                v1 = v3 - v.activatedTime
                if not (v1 >= 0.8) then
                    v2 = 0.1 + 0.30000000000000004 * (v1 / 0.8)
                    if not (v3 - v.lastEmitTime < v2) then
                        v.lastEmitTime = v3
                        for i3, j in ipairs(v.emitters) do
                            if j and j.Parent then
                                j:Emit(1)
                            end
                        end
                    end
                else
                    v.emissionStopped = true
                    u40[k] = nil
                end
            else
                u40[k] = nil
            end
        end
        if next(u40) == nil and u41 then
            u41:Disconnect()
            u41 = nil
        end
    end)
end

local function SetVoxelEmitting(a1, a2) -- Line: 112
    -- upvalues: u40 (val), u41 (ref), RunServiceController (val)
    local voxel = a1.voxel
    if a2 then
        u40[voxel] = a1
        if u41 then
            return
        end
        u41 = RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function() -- Line: 62 -- upvalues: u40 (upval), u41 (upval)
            local v1, v2
            local v3 = tick()
            for k, v in pairs(u40) do
                if not k.Parent or not v.isActive then
                    u40[k] = nil
                elseif not v.emissionStopped then
                    if not v.lifetimeExtended then
                        v.lifetimeExtended = true
                        v.activatedTime = v3
                        for i, i2 in ipairs(v.emitters) do
                            if i2 and i2.Parent then
                                i2.Lifetime = NumberRange.new((1 / 0))
                            end
                        end
                    end
                    v1 = v3 - v.activatedTime
                    if not (v1 >= 0.8) then
                        v2 = 0.1 + 0.30000000000000004 * (v1 / 0.8)
                        if not (v3 - v.lastEmitTime < v2) then
                            v.lastEmitTime = v3
                            for i3, j in ipairs(v.emitters) do
                                if j and j.Parent then
                                    j:Emit(1)
                                end
                            end
                        end
                    else
                        v.emissionStopped = true
                        u40[k] = nil
                    end
                else
                    u40[k] = nil
                end
            end
            if next(u40) == nil and u41 then
                u41:Disconnect()
                u41 = nil
            end
        end)
        return
    end
    u40[voxel] = nil
    if next(u40) == nil and u41 then
        u41:Disconnect()
        u41 = nil
    end
end

local function RayIntersectsAABB(a1, a2, a3, a4, a5) -- Line: 125
    -- upvalues: 
    local v1, v2, v3
    local v4 = 0
    local v5 = a5
    local v6 = math.abs(a2.X)
    if v6 < 0.0001 then
        if not (a1.X < a3.X) and not (a4.X < a1.X) then
            v6 = math.abs(a2.Y)
            if v6 < 0.0001 then
                if not (a1.Y < a3.Y) and not (a4.Y < a1.Y) then
                    if (math.abs(a2.Z)) < 0.0001 then
                        if not (a1.Z < a3.Z) and not (a4.Z < a1.Z) then
                            return v4 <= a5
                        end
                        return false
                    end
                    v6 = 1 / a2.Z
                    v2 = (a3.Z - a1.Z) * v6
                    v3 = (a4.Z - a1.Z) * v6
                    if v3 < v2 then
                        v1 = v3
                        v3 = v2
                        v2 = v1
                    end
                    v4 = math.max(v4, v2)
                    if math.min(v5, v3) < v4 then
                        return false
                    end
                    return v4 <= a5
                end
                return false
            end
            v6 = 1 / a2.Y
            v2 = (a3.Y - a1.Y) * v6
            v3 = (a4.Y - a1.Y) * v6
            if v3 < v2 then
                v1 = v3
                v3 = v2
                v2 = v1
            end
            v4 = math.max(v4, v2)
            v5 = math.min(v5, v3)
            if v5 < v4 then
                return false
            end
            if (math.abs(a2.Z)) < 0.0001 then
                if not (a1.Z < a3.Z) and not (a4.Z < a1.Z) then
                    return v4 <= a5
                end
                return false
            end
            v6 = 1 / a2.Z
            v2 = (a3.Z - a1.Z) * v6
            v3 = (a4.Z - a1.Z) * v6
            if v3 < v2 then
                v1 = v3
                v3 = v2
                v2 = v1
            end
            v4 = math.max(v4, v2)
            if math.min(v5, v3) < v4 then
                return false
            end
            return v4 <= a5
        end
        return false
    end
    v6 = 1 / a2.X
    v2 = (a3.X - a1.X) * v6
    v3 = (a4.X - a1.X) * v6
    if v3 < v2 then
        v1 = v3
        v3 = v2
        v2 = v1
    end
    v4 = math.max(v4, v2)
    v5 = math.min(v5, v3)
    if v5 < v4 then
        return false
    end
    v6 = math.abs(a2.Y)
    if v6 < 0.0001 then
        if not (a1.Y < a3.Y) and not (a4.Y < a1.Y) then
            if (math.abs(a2.Z)) < 0.0001 then
                if not (a1.Z < a3.Z) and not (a4.Z < a1.Z) then
                    return v4 <= a5
                end
                return false
            end
            v6 = 1 / a2.Z
            v2 = (a3.Z - a1.Z) * v6
            v3 = (a4.Z - a1.Z) * v6
            if v3 < v2 then
                v1 = v3
                v3 = v2
                v2 = v1
            end
            v4 = math.max(v4, v2)
            if math.min(v5, v3) < v4 then
                return false
            end
            return v4 <= a5
        end
        return false
    end
    v6 = 1 / a2.Y
    v2 = (a3.Y - a1.Y) * v6
    v3 = (a4.Y - a1.Y) * v6
    if v3 < v2 then
        v1 = v3
        v3 = v2
        v2 = v1
    end
    v4 = math.max(v4, v2)
    v5 = math.min(v5, v3)
    if v5 < v4 then
        return false
    end
    if (math.abs(a2.Z)) < 0.0001 then
        if not (a1.Z < a3.Z) and not (a4.Z < a1.Z) then
            return v4 <= a5
        end
        return false
    end
    v6 = 1 / a2.Z
    v2 = (a3.Z - a1.Z) * v6
    v3 = (a4.Z - a1.Z) * v6
    if v3 < v2 then
        v1 = v3
        v3 = v2
        v2 = v1
    end
    v4 = math.max(v4, v2)
    if math.min(v5, v3) < v4 then
        return false
    end
    return v4 <= a5
end

local function ConfigureEmitter(a1, a2, a3) -- Line: 196 -- types: a1: userdata, a2: number, a3: userdata?
    local v1 = {}
    for i, v in ipairs(a1.Size.Keypoints) do
        table.insert(v1, (NumberSequenceKeypoint.new(v.Time, v.Value * a2, v.Envelope * a2)))
    end
    a1.Size = NumberSequence.new(v1)
    if a3 then
        a1.Color = ColorSequence.new(a3)
    end
    a1.Enabled = false
end

local function CreateVoxel(a1, a2, a3, a4) -- Line: 212
    -- upvalues: Smoke (val), ConfigureEmitter (val), u38 (val)
    local v1 = Smoke:Clone()
    v1.Name = "SmokeVoxel"
    v1.Size = Vector3.new(a2, a2, a2)
    v1.Position = a1
    v1.Anchored = true
    v1.CanCollide = false
    v1.CanQuery = false
    v1.CanTouch = false
    v1.CastShadow = false
    v1.Parent = a3
    local v2 = a2 / 4
    local v3 = {}
    for i, v in ipairs(v1:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            ConfigureEmitter(v, v2, a4)
            table.insert(v3, v)
        end
    end
    for i2, i3 in ipairs(v1:GetChildren()) do
        if i3:IsA("BillboardGui") then
            i3:Destroy()
        end
    end
    local v4 = a2 / 2
    local v5 = Vector3.new(v4, v4, v4)
    u38[v1] = {
        isActive = false,
        lastEmitTime = 0,
        lifetimeExtended = false,
        activatedTime = 0,
        emissionStopped = false,
        voxel = v1,
        emitters = v3,
        scaleFactor = v2,
        teamColor = a4,
        minimum = a1 - v5,
        maximum = a1 + v5,
    }
    return v1
end

local function DestroyVoxels(a1) -- Line: 260 -- upvalues: u39 (val), u40 (val), u38 (val) -- types: a1: table
    for i, v in ipairs(a1) do
        if v:IsA("BasePart") then
            u39[v] = nil
            u40[v] = nil
            u38[v] = nil
            v:Destroy()
        end
    end
end

local function DeploySmoke(a1, a2) -- Line: 274
    -- upvalues: u38 (val), u39 (val), u40 (val), u41 (ref), RunServiceController (val)
    local Magnitude_2
    debug.profilebegin("VFX.VoxelSmoke.DeploySmoke")
    local v1 = Vector3.new(0, 0, 0)
    local v2 = {}
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("BasePart") then
            v1 = v1 + v.Position
            table.insert(v2, v)
        end
    end
    if #v2 == 0 then
        debug.profileend()
        return
    end
    v1 = v1 / #v2
    local v3 = 0
    for i2, i3 in ipairs(v2) do
        Magnitude_2 = (i3.Position - v1).Magnitude
        if v3 < Magnitude_2 then
            v3 = Magnitude_2
        end
    end
    if v3 == 0 then
        v3 = 1
    end
    for i4, j in ipairs(v2) do
        task.delay((j.Position - v1).Magnitude / v3 * a2, function() -- Line: 308
            -- upvalues: j (val), u38 (upval), u39 (upval), u40 (upval), u41 (upval), RunServiceController (upval)
            if not j.Parent then
                return
            end
            local v1 = u38[j]
            if v1 then
                v1.isActive = true
                u39[j] = v1
                u40[v1.voxel] = v1
                if u41 then
                    return
                end
                u41 = RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function() -- Line: 62 -- upvalues: u40 (upval), u41 (upval)
                    local v1, v2
                    local v3 = tick()
                    for k, v in pairs(u40) do
                        if not k.Parent or not v.isActive then
                            u40[k] = nil
                        elseif not v.emissionStopped then
                            if not v.lifetimeExtended then
                                v.lifetimeExtended = true
                                v.activatedTime = v3
                                for i, i2 in ipairs(v.emitters) do
                                    if i2 and i2.Parent then
                                        i2.Lifetime = NumberRange.new((1 / 0))
                                    end
                                end
                            end
                            v1 = v3 - v.activatedTime
                            if not (v1 >= 0.8) then
                                v2 = 0.1 + 0.30000000000000004 * (v1 / 0.8)
                                if not (v3 - v.lastEmitTime < v2) then
                                    v.lastEmitTime = v3
                                    for i3, j in ipairs(v.emitters) do
                                        if j and j.Parent then
                                            j:Emit(1)
                                        end
                                    end
                                end
                            else
                                v.emissionStopped = true
                                u40[k] = nil
                            end
                        else
                            u40[k] = nil
                        end
                    end
                    if next(u40) == nil and u41 then
                        u41:Disconnect()
                        u41 = nil
                    end
                end)
            end
        end)
    end
    debug.profileend()
end

local function FadeOutSmoke(a1) -- Line: 324
    -- upvalues: u38 (val), u39 (val), u40 (val), u41 (ref), DestroyVoxels (val)
    local v1
    debug.profilebegin("VFX.VoxelSmoke.FadeOutSmoke")
    local Children = a1:GetChildren()
    for i, v in ipairs(Children) do
        if v:IsA("BasePart") then
            v1 = u38[v]
            if v1 then
                v1.isActive = false
                u39[v] = nil
                u40[v1.voxel] = nil
                if next(u40) == nil and u41 then
                    u41:Disconnect()
                    u41 = nil
                end
                for i2, i3 in ipairs(v1.emitters) do
                    if i3 and i3.Parent then
                        i3.Enabled = false
                    end
                end
            end
        end
    end
    task.delay(6, function() -- Line: 344 -- upvalues: DestroyVoxels (upval), Children (val), u40 (upval), u41 (upval), a1 (val)
        debug.profilebegin("VFX.VoxelSmoke.FadeOutSmoke.DelayedCleanup")
        DestroyVoxels(Children)
        if next(u40) == nil and u41 then
            u41:Disconnect()
            u41 = nil
        end
        if a1.Parent then
            a1:Destroy()
        end
        debug.profileend()
    end)
    debug.profileend()
end

return {
    Create = function(a1) -- Line: 365
        -- upvalues: u37 (val), u26 (val), CreateVoxel (val), Workspace (val), DeploySmoke (val), FadeOutSmoke (val)
        debug.profilebegin("VFX.VoxelSmoke.Create")
        local Folder = Instance.new("Folder")
        Folder.Name = "VoxelSmoke_" .. a1.SmokeId
        u37[a1.SmokeId] = Folder
        local Team = a1.Team and u26[a1.Team]
        debug.profilebegin("VFX.VoxelSmoke.Create.CreateVoxels")
        for i, v in ipairs(a1.Voxels) do
            CreateVoxel(v.Position, v.Size, Folder, Team)
        end
        debug.profileend()
        Folder.Parent = Workspace:WaitForChild("Debris")
        DeploySmoke(Folder, a1.DeployTime)
        task.delay(a1.Duration, function() -- Line: 391 -- upvalues: u37 (upval), a1 (val), FadeOutSmoke (upval), Folder (val)
            if u37[a1.SmokeId] then
                FadeOutSmoke(Folder)
                u37[a1.SmokeId] = nil
            end
        end)
        debug.profileend()
    end,
    Destroy = function(a1) -- Line: 400 -- upvalues: u37 (val), FadeOutSmoke (val) -- types: a1: string
        debug.profilebegin("VFX.VoxelSmoke.Destroy")
        local v1 = u37[a1]
        if v1 then
            FadeOutSmoke(v1)
            u37[a1] = nil
        end
        debug.profileend()
    end,
    DestroyAll = function() -- Line: 410 -- upvalues: u37 (val), DestroyVoxels (val), u40 (val), u41 (ref)
        debug.profilebegin("VFX.VoxelSmoke.DestroyAll")
        for k, v in pairs(u37) do
            DestroyVoxels(v:GetChildren())
            v:Destroy()
            u37[k] = nil
        end
        if next(u40) == nil and u41 then
            u41:Disconnect()
            u41 = nil
        end
        debug.profileend()
    end,
    Disrupt = function(a1, a2, a3) -- Line: 425
        -- upvalues: u37 (val), u38 (val), u39 (val), u40 (val), u41 (ref), Smoke (val), ConfigureEmitter (val)
        -- upvalues: RunServiceController (val)
        debug.profilebegin("VFX.VoxelSmoke.Disrupt")
        local v1, v2, v3 = a1, a2, a3
        for k, v in pairs(u37) do
            for i, i2 in ipairs(v:GetChildren()) do
                if i2:IsA("BasePart") and not (v2 < (i2.Position - v1).Magnitude) then
                    local u47 = u38[i2]
                    if u47 and u47.isActive then
                        u47.isActive = false
                        u39[i2] = nil
                        u40[u47.voxel] = nil
                        if next(u40) == nil and u41 then
                            u41:Disconnect()
                            u41 = nil
                        end
                        local scaleFactor = u47.scaleFactor
                        for i3, j in ipairs(u47.emitters) do
                            if j and j.Parent then
                                j:Destroy()
                            end
                        end
                        u47.emitters = {}
                        local teamColor = u47.teamColor
                        task.delay(v3, function() -- Line: 455
                            -- upvalues: u38 (upval), i2 (val), Smoke (upval), ConfigureEmitter (upval)
                            -- upvalues: scaleFactor (val), teamColor (val), u47 (val), u39 (upval), u40 (upval)
                            -- upvalues: u41 (upval), RunServiceController (upval)
                            debug.profilebegin("VFX.VoxelSmoke.Disrupt.RestoreEmitters")
                            if u38[i2] and i2.Parent then
                                local v1
                                local v2 = {}
                                for i, v in ipairs(Smoke:GetDescendants()) do
                                    if v:IsA("ParticleEmitter") then
                                        v1 = v:Clone()
                                        ConfigureEmitter(v1, scaleFactor, teamColor)
                                        v1.Parent = i2
                                        table.insert(v2, v1)
                                    end
                                end
                                u47.emitters = v2
                                u47.lastEmitTime = 0
                                u47.isActive = true
                                u47.lifetimeExtended = false
                                u47.activatedTime = 0
                                u47.emissionStopped = false
                                u39[i2] = u47
                                local v3 = u47
                                u40[v3.voxel] = v3
                                if not u41 then
                                    u41 = RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function() -- Line: 62 -- upvalues: u40 (upval), u41 (upval)
                                        local v1, v2
                                        local v3 = tick()
                                        for k, v in pairs(u40) do
                                            if not k.Parent or not v.isActive then
                                                u40[k] = nil
                                            elseif not v.emissionStopped then
                                                if not v.lifetimeExtended then
                                                    v.lifetimeExtended = true
                                                    v.activatedTime = v3
                                                    for i, i2 in ipairs(v.emitters) do
                                                        if i2 and i2.Parent then
                                                            i2.Lifetime = NumberRange.new((1 / 0))
                                                        end
                                                    end
                                                end
                                                v1 = v3 - v.activatedTime
                                                if not (v1 >= 0.8) then
                                                    v2 = 0.1 + 0.30000000000000004 * (v1 / 0.8)
                                                    if not (v3 - v.lastEmitTime < v2) then
                                                        v.lastEmitTime = v3
                                                        for i3, j in ipairs(v.emitters) do
                                                            if j and j.Parent then
                                                                j:Emit(1)
                                                            end
                                                        end
                                                    end
                                                else
                                                    v.emissionStopped = true
                                                    u40[k] = nil
                                                end
                                            else
                                                u40[k] = nil
                                            end
                                        end
                                        if next(u40) == nil and u41 then
                                            u41:Disconnect()
                                            u41 = nil
                                        end
                                    end)
                                end
                                debug.profileend()
                                return
                            end
                            debug.profileend()
                        end)
                    end
                end
            end
        end
        debug.profileend()
    end,
    DoesRayIntersectActiveSmoke = function(a1, a2, a3) -- Line: 487
        -- upvalues: u39 (val), RayIntersectsAABB (val)
        for k, v in pairs(u39) do
            if RayIntersectsAABB(a1, a2, v.minimum, v.maximum, a3) then
                return true
            end
        end
        return false
    end,
}