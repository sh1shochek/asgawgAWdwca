-- ReplicatedStorage.MovementV2.Client.WorldReplay
-- Script path: ReplicatedStorage.MovementV2.Client.WorldReplay
-- Decompile time: 2.73 ms

require(script.Parent.RuntimeTypes)
require(script.Parent.DestructibleTimeline)
local u10 = {}
local u11 = {}
u11.__index = u11

function u10.controlVersion(a1) -- Line: 40
    return {
        Baseline = a1._pendingBaseline,
        Delta = a1._pendingDeltas[#a1._pendingDeltas],
        MoverBaseline = a1._pendingMoverBaseline,
        MoverDelta = a1._pendingMoverDeltas[#a1._pendingMoverDeltas],
    }
end

function u10.controlsUnchanged(a1, a2) -- Line: 49 -- types: a2: table?
    local v1 = false
    if a2 ~= nil then
        v1 = false
        if a2.Baseline == a1._pendingBaseline then
            v1 = false
            if a2.Delta == a1._pendingDeltas[#a1._pendingDeltas] then
                v1 = false
                if a2.MoverBaseline == a1._pendingMoverBaseline then
                    v1 = a2.MoverDelta == a1._pendingMoverDeltas[#a1._pendingMoverDeltas]
                end
            end
        end
    end
    return v1
end

local function consume(a1, a2, a3) -- Line: 57
    local v1, v2, v3, v4, v5, v6
    local Baseline = a1.Baseline
    if Baseline ~= nil then
        local v7
        v7, v5 = a2:consumeBaseline(Baseline.ServerTick, Baseline.Frame)
        if not v7 then
            return false, v5
        end
    end
    v5 = nil
    local v8 = nil
    for i, j in a1.Deltas, v5, v8 do
        v6, v1 = a2:consumeDelta(j.Epoch, j.Revision, j.ServerTick, j.Indices)
        if not v6 then
            return false, v1
        end
    end
    local MoverBaseline = a1.MoverBaseline
    if MoverBaseline ~= nil then
        if MoverBaseline.Epoch ~= a1.Epoch then
            return false, "MoverEpochMismatch"
        end
        v5, v8 = a3:ConsumeBaseline(
            MoverBaseline.Epoch,
            MoverBaseline.Revision,
            MoverBaseline.ServerTick,
            MoverBaseline.Descriptors,
            MoverBaseline.ProgressAnchors
        )
        if not v5 then
            return false, v8
        end
    end
    local MoverDeltas = a1.MoverDeltas
    v8 = nil
    local v9 = nil
    local v10, v11 = a1, a3
    for k, n in MoverDeltas, v8, v9 do
        if n.Epoch ~= v10.Epoch then
            return false, "MoverEpochMismatch"
        end
        if n.Kind ~= "MoverProgress" then
            v3, v4 = v11:ConsumeDelta(n.Epoch, n.Revision, n.ServerTick, n.Descriptors)
        else
            v3, v4 = v11:ConsumeProgress(n.Epoch, n.Revision, n.ServerTick, n.Streams)
        end
        v2 = v4
        if v2 ~= nil then
            return false, v2
        end
    end
    return true
end

function u11.bind(a1) -- Line: 104
    a1.Runtime:_bindCollisionSources(a1.Timeline, a1.Composer)
end

function u11:restore() -- Line: 108
    self.Runtime:_bindCollisionSources(self.LiveTimeline, self.LiveComposer)
end

function u11:destroy() -- Line: 112
    self:restore()
    self.Timeline:destroy()
    if self.Composer ~= nil then
        self.Composer:Destroy()
    end
end

function u11.commit(a1) -- Line: 120 -- upvalues: u10 (val), consume (val)
    local Runtime = a1.Runtime
    assert(u10.controlsUnchanged(Runtime, a1.Version), "queued controls changed during owner staging")
    a1:restore()
    local v1, v2 = consume(a1, a1.LiveTimeline, a1.LiveComposer)
    assert(v1, v2)
    Runtime._pendingBaseline = nil
    Runtime._pendingMoverBaseline = nil
    Runtime._pendingDeltas = {}
    Runtime._pendingMoverDeltas = {}
    local _pendingReconciliationInstall = Runtime._pendingReconciliationInstall
    local Composer = a1.Composer
    if Composer ~= nil then
        a1.MoverRevisionToValidate = Composer:Revision()
        if _pendingReconciliationInstall ~= nil and _pendingReconciliationInstall.CollisionComposer ~= nil then
            a1.LiveComposer:AdoptReplay(_pendingReconciliationInstall.CollisionComposer, Composer)
            return
        end
        if _pendingReconciliationInstall == nil then
            a1.LiveComposer:CommitPrediction(Composer)
        end
    end
end

function u10.prepare(a1) -- Line: 141 -- upvalues: u10 (val), u11 (val), consume (val)
    if a1._pendingBaseline == nil
        and #a1._pendingDeltas == 0
        and a1._pendingMoverBaseline == nil
        and #a1._pendingMoverDeltas == 0 then
        return nil, nil
    end
    local _collisionComposer = a1._collisionComposer
    local v1 = true
    if a1._pendingMoverBaseline == nil then
        v1 = #a1._pendingMoverDeltas > 0
    end
    if _collisionComposer == nil and v1 then
        return nil, "MoverControlForkUnavailable"
    end
    if _collisionComposer ~= nil and type(_collisionComposer.ForkControls) ~= "function" then
        return nil, "MoverControlForkUnavailable"
    end
    local v2 = assert(a1._timeline)
    local v3 = {
        Runtime = a1,
        Epoch = assert(a1._mapping).TopologyEpoch,
        Version = u10.controlVersion(a1),
        Baseline = a1._pendingBaseline,
        Deltas = table.clone(a1._pendingDeltas),
        MoverBaseline = a1._pendingMoverBaseline,
        MoverDeltas = table.clone(a1._pendingMoverDeltas),
        LiveTimeline = v2,
        Timeline = v2:fork(),
        LiveComposer = _collisionComposer,
        Composer = if _collisionComposer ~= nil then _collisionComposer:ForkControls() else nil,
    }
    local v4 = setmetatable(v3, u11)
    local success, result, v5 = pcall(consume, v4, v4.Timeline, v4.Composer)
    if success and result then
        return v4, nil
    end
    v4:destroy()
    if not success then
        error(result, 0)
    end
    return nil, v5
end

return table.freeze(u10)