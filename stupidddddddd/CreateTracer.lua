-- ReplicatedStorage.Components.Common.VFXLibary.CreateTracer
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateTracer
-- Decompile time: 3.00 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool)
local Tracers = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Tracers")
local Debris = workspace:WaitForChild("Debris")
local u35 = ObjectPool.new(Tracers:WaitForChild("Default"), {
    InitialSize = 8,
    MaxRetained = 48,
    Reset = function(a1) -- Line: 54 -- types: a1: userdata
        a1.TopAttachment.Position = Vector3.new(0, 0, 0)
        a1.BottomAttachment.Position = Vector3.new(0, 0, 0)
        a1.LeftAttachment.Position = Vector3.new(0, 0, 0)
        a1.RightAttachment.Position = Vector3.new(0, 0, 0)
    end,
})
local u36 = {}
local u37 = nil
local u38 = {}
local u39 = {}

local function retireTracer(a1, a2) -- Line: 82 -- upvalues: u35 (val), u36 (val) -- types: a1: number, a2: table
    u35:Release(a2.Part, a2.Lease)
    u36[a1] = u36[#u36]
    u36[#u36] = nil
end

local function updateTracers(a1) -- Line: 88
    -- upvalues: u36 (val), u35 (val), u38 (val), u39 (val), u37 (ref)
    local Part, v1, v2, v3, v4
    debug.profilebegin("VFX.TracerUpdate")
    for i = #u36, 1, -1 do
        v1 = u36[i]
        v1.Elapsed = v1.Elapsed + a1
        Part = v1.Part
        if 1 <= v1.Elapsed then
            u35:Release(v1.Part, v1.Lease)
            u36[i] = u36[#u36]
            u36[#u36] = nil
        elseif Part.Parent ~= nil then
            v2 = 5 + 995 * (v1.Elapsed / 1)
            if v1.MaxDistance == nil or not (v1.MaxDistance <= v2) then
                u38[#u38 + 1] = Part
                v3 = u39
                v4 = #u39 + 1
                v3[v4] = (CFrame.new(v1.Origin + v1.Direction * v2))
                v4 = 0.1 * (math.min(v2 / 50, 1))
                if v1.HalfWidth ~= v4 then
                    v1.HalfWidth = v4
                    Part.TopAttachment.Position = Vector3.new(0, v4, 0)
                    Part.BottomAttachment.Position = Vector3.new(0, -v4, 0)
                    Part.LeftAttachment.Position = Vector3.new(-v4, 0, 0)
                    Part.RightAttachment.Position = Vector3.new(v4, 0, 0)
                end
            else
                u35:Release(v1.Part, v1.Lease)
                u36[i] = u36[#u36]
                u36[#u36] = nil
            end
        else
            u35:Release(v1.Part, v1.Lease)
            u36[i] = u36[#u36]
            u36[#u36] = nil
        end
    end
    if #u38 > 0 then
        workspace:BulkMoveTo(u38, u39, Enum.BulkMoveMode.FireCFrameChanged)
        table.clear(u38)
        table.clear(u39)
    end
    if #u36 == 0 and u37 then
        u37:Disconnect()
        u37 = nil
    end
    debug.profileend()
end

local function ensureUpdaterBound() -- Line: 137 -- upvalues: u37 (ref), RunServiceController (val), updateTracers (val)
    if not u37 then
        u37 = RunServiceController.BindToHeartbeat("VFX.TracerUpdater", updateTracers)
    end
end

return function(a1, a2, a3, a4) -- Line: 146
    -- upvalues: u35 (val), Debris (val), u36 (val), u37 (ref), RunServiceController (val), updateTracers (val)
    debug.profilebegin("VFX.Tracer")
    if not a2 then
        debug.profileend()
        return
    end
    if a4 == true and a1 <= 5 then
        debug.profileend()
        return
    end
    debug.profilebegin("VFX.Tracer.Acquire")
    local v1, v2 = u35:Acquire()
    v1.CollisionGroup = "Debris"
    v1.CanCollide = false
    v1.CanQuery = false
    v1.CanTouch = false
    v1.Anchored = true
    debug.profileend()
    debug.profilebegin("VFX.Tracer.Parent")
    v1.TopAttachment.Position = Vector3.new(0, 0, 0)
    v1.BottomAttachment.Position = Vector3.new(0, 0, 0)
    v1.LeftAttachment.Position = Vector3.new(0, 0, 0)
    v1.RightAttachment.Position = Vector3.new(0, 0, 0)
    v1.CFrame = CFrame.new(a2 + a3 * 5)
    v1.Parent = Debris
    debug.profileend()
    table.insert(u36, {
        Elapsed = 0,
        Part = v1,
        Lease = v2,
        Origin = a2,
        Direction = a3,
        MaxDistance = if a4 ~= true then nil else math.max(a1, 0),
    })
    if not u37 then
        u37 = RunServiceController.BindToHeartbeat("VFX.TracerUpdater", updateTracers)
    end
    debug.profileend()
end