-- Decompiled with Potassium's decompiler.

require(script.Parent.RuntimeTypes);
require(script.Parent.DestructibleTimeline);
local u1 = {};
local u2 = {};
u2.__index = u2;

function u1.controlVersion(p3) -- Line: 40
    return {
        Baseline = p3._pendingBaseline,
        Delta = p3._pendingDeltas[#p3._pendingDeltas],
        MoverBaseline = p3._pendingMoverBaseline,
        MoverDelta = p3._pendingMoverDeltas[#p3._pendingMoverDeltas]
    };
end;

function u1.controlsUnchanged(p4: any, p5: table?) -- Line: 49
    local v6;

    if p5 == nil or (p5.Baseline ~= p4._pendingBaseline or (p5.Delta ~= p4._pendingDeltas[#p4._pendingDeltas] or p5.MoverBaseline ~= p4._pendingMoverBaseline)) then
        v6 = false;
    else
        v6 = p5.MoverDelta == p4._pendingMoverDeltas[#p4._pendingMoverDeltas];
    end;

    return v6;
end;

local function consume(p7, p8, p9) -- Line: 57
    local Baseline = p7.Baseline;

    if Baseline ~= nil then
        local v10, v11 = p8:consumeBaseline(Baseline.ServerTick, Baseline.Frame);

        if not v10 then
            return false, v11;
        end;
    end;

    for _, v in p7.Deltas do
        local v12, v13 = p8:consumeDelta(v.Epoch, v.Revision, v.ServerTick, v.Indices);

        if not v12 then
            return false, v13;
        end;
    end;

    local MoverBaseline = p7.MoverBaseline;

    if MoverBaseline ~= nil then
        if MoverBaseline.Epoch ~= p7.Epoch then
            return false, "MoverEpochMismatch";
        end;

        local v14, v15 = p9:ConsumeBaseline(MoverBaseline.Epoch, MoverBaseline.Revision, MoverBaseline.ServerTick, MoverBaseline.Descriptors, MoverBaseline.ProgressAnchors);

        if not v14 then
            return false, v15;
        end;
    end;

    for _, v in p7.MoverDeltas do
        if v.Epoch ~= p7.Epoch then
            return false, "MoverEpochMismatch";
        end;

        local v16;

        if v.Kind == "MoverProgress" then
            local v17;
            v17, v16 = p9:ConsumeProgress(v.Epoch, v.Revision, v.ServerTick, v.Streams);
        else
            local v18;
            v18, v16 = p9:ConsumeDelta(v.Epoch, v.Revision, v.ServerTick, v.Descriptors);
        end;

        if v16 ~= nil then
            return false, v16;
        end;
    end;

    return true;
end;

function u2.bind(p19) -- Line: 104
    p19.Runtime:_bindCollisionSources(p19.Timeline, p19.Composer);
end;

function u2.restore(p20) -- Line: 108
    p20.Runtime:_bindCollisionSources(p20.LiveTimeline, p20.LiveComposer);
end;

function u2.destroy(p21) -- Line: 112
    p21:restore();
    p21.Timeline:destroy();

    if p21.Composer ~= nil then
        p21.Composer:Destroy();
    end;
end;

function u2.commit(p22) -- Line: 120
    -- upvalues: u1 (copy), consume (copy)
    local Runtime = p22.Runtime;
    local v23 = u1.controlsUnchanged(Runtime, p22.Version);
    assert(v23, "queued controls changed during owner staging");
    p22:restore();
    local v24, v25 = consume(p22, p22.LiveTimeline, p22.LiveComposer);
    assert(v24, v25);
    Runtime._pendingBaseline = nil;
    Runtime._pendingMoverBaseline = nil;
    Runtime._pendingDeltas = {};
    Runtime._pendingMoverDeltas = {};
    local _pendingReconciliationInstall = Runtime._pendingReconciliationInstall;
    local Composer = p22.Composer;

    if Composer ~= nil then
        p22.MoverRevisionToValidate = Composer:Revision();

        if _pendingReconciliationInstall ~= nil and _pendingReconciliationInstall.CollisionComposer ~= nil then
            p22.LiveComposer:AdoptReplay(_pendingReconciliationInstall.CollisionComposer, Composer);

            return;
        end;

        if _pendingReconciliationInstall == nil then
            p22.LiveComposer:CommitPrediction(Composer);
        end;
    end;
end;

function u1.prepare(p26) -- Line: 141
    -- upvalues: u1 (copy), u2 (copy), consume (copy)
    if p26._pendingBaseline == nil and (#p26._pendingDeltas == 0 and (p26._pendingMoverBaseline == nil and #p26._pendingMoverDeltas == 0)) then
        return nil, nil;
    end;

    local _collisionComposer = p26._collisionComposer;

    if not ((_collisionComposer ~= nil or p26._pendingMoverBaseline == nil and #p26._pendingMoverDeltas <= 0) and (_collisionComposer == nil or type(_collisionComposer.ForkControls) == "function")) then
        return nil, "MoverControlForkUnavailable";
    end;

    local v27 = assert(p26._timeline);
    local v28 = {
        Runtime = p26,
        Epoch = assert(p26._mapping).TopologyEpoch,
        Version = u1.controlVersion(p26),
        Baseline = p26._pendingBaseline,
        Deltas = table.clone(p26._pendingDeltas),
        MoverBaseline = p26._pendingMoverBaseline,
        MoverDeltas = table.clone(p26._pendingMoverDeltas),
        LiveTimeline = v27,
        Timeline = v27:fork(),
        LiveComposer = _collisionComposer
    };
    local v29;

    if _collisionComposer == nil then
        v29 = nil;
    else
        v29 = _collisionComposer:ForkControls();
    end;

    v28.Composer = v29;
    local v30 = setmetatable(v28, u2);
    local v31, v32, v33 = pcall(consume, v30, v30.Timeline, v30.Composer);

    if v31 and v32 then
        return v30, nil;
    end;

    v30:destroy();

    if not v31 then
        error(v32, 0);
    end;

    return nil, v33;
end;

return table.freeze(u1);