-- ReplicatedStorage.MovementV2.Client.DestructibleTimeline
-- Script path: ReplicatedStorage.MovementV2.Client.DestructibleTimeline
-- Decompile time: 6.39 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)
local Config = require(script.Parent.Parent.Config)
local DestructibleFrame = require(script.Parent.Parent.Collision.DestructibleFrame)
local Serial = require(script.Parent.Parent.Serial)
local u28 = {}
u28.__index = u28

local function immutableTransition(a1, a2) -- Line: 32 -- types: a1: number
    return (table.freeze({ServerTick = a1, Frame = a2}))
end

local function latestTransition(a1) -- Line: 39
    return a1._transitions[#a1._transitions]
end

local function retainedTransition(a1, a2) -- Line: 43 -- upvalues: Serial (val) -- types: a2: number
    local v1
    for i = #a1._transitions, 1, -1 do
        v1 = a1._transitions[i]
        if 0 <= (Serial.deltaUInt32(a2, v1.ServerTick)) then
            return v1
        end
    end
    return nil
end

local function requestBaseline(a1, a2) -- Line: 53 -- types: a2: string
    a1._needsBaseline = true
    if a1._requestFired then
        return
    end
    a1._requestFired = true
    local v1 = a1._transitions[#a1._transitions]
    a1.BaselineNeeded:Fire(a1._expectedEpoch, if v1 ~= nil then v1.Frame.Revision else 0, a2)
end

local function prune(a1, a2) -- Line: 63 -- upvalues: Serial (val) -- types: a2: number
    while true do
        if not (#a1._transitions > 1)
            or (Serial.deltaUInt32(a2, a1._transitions[2].ServerTick)) < a1._retentionTicks then
            break
        end
        table.remove(a1._transitions, 1)
    end
end

local function deactivate(a1, a2, a3) -- Line: 73
    -- upvalues: Serial (val), DestructibleFrame (val)
    local v1, v2, v3, v4
    local v5 = {}
    local v6 = {}
    local v7 = 0
    local v8 = nil
    local v9 = nil
    local v10, v11 = a1, a3
    for i, j in a2, v8, v9 do
        if Serial.isUInt16(j) and j ~= 0 and not (v10.Count < j) and not (j <= v7) then
            v1 = j - 1
            v2 = math.floor(v1 / 8) + 1
            v3 = bit32.lshift(1, v1 % 8)
            v4 = v5[v2]
            if v4 == nil then
                v4 = string.byte(v10.ActiveBits, v2)
                v6[#v6 + 1] = v2
            end
            if bit32.band(v4, v3) == 0 then
                return nil, "DeltaDeactivatesInactiveSource"
            end
            v5[v2] = (bit32.band(v4, (bit32.bnot(v3))))
            continue
        end
        return nil, "InvalidDeltaIndices"
    end
    local v12 = table.create(#v6 * 2 + 1)
    v8 = 1
    local v13 = nil
    local v14 = nil
    for k, n in v6, v13, v14 do
        if v8 < n then
            v12[#v12 + 1] = (string.sub(v10.ActiveBits, v8, n - 1))
        end
        v12[#v12 + 1] = (string.char(v5[n]))
        v8 = n + 1
    end
    if v8 <= #v10.ActiveBits then
        v12[#v12 + 1] = (string.sub(v10.ActiveBits, v8))
    end
    return (DestructibleFrame.New(v10.Epoch, v11, v10.Count, table.concat(v12))), nil
end

function u28.new(a1, a2, a3) -- Line: 117
    -- upvalues: Config (val), Serial (val), DestructibleFrame (val), Signal (val), u28 (val)
    local v1 = Config.derive(a1)
    assert(Serial.isNonZeroUInt16(a2), "destructible timeline epoch must be a non-zero u16")
    local v2, v3 = DestructibleFrame.Validate(a2, 0, a3, string.rep("\000", (math.ceil(a3 / 8))))
    assert(v2, v3)
    return (setmetatable({
        _needsBaseline = true,
        _requestFired = false,
        _expectedEpoch = a2,
        _expectedCount = a3,
        _retentionTicks = v1.PredictionReplayTicks,
        _transitions = {},
        BaselineNeeded = Signal.new(),
    }, u28))
end

function u28.fork(a1) -- Line: 143 -- upvalues: Signal (val), u28 (val)
    local v1 = table.clone(a1)
    v1._transitions = table.clone(a1._transitions)
    v1.BaselineNeeded = Signal.new()
    return (setmetatable(v1, u28))
end

function u28.destroy(a1) -- Line: 150
    a1.BaselineNeeded:Destroy()
    table.clear(a1._transitions)
end

function u28.needsBaseline(a1) -- Line: 155
    return a1._needsBaseline
end

function u28.requestBaseline(a1, a2) -- Line: 159 -- types: a1: table, a2: string
    a1._needsBaseline = true
    if a1._requestFired then
        return
    end
    a1._requestFired = true
    local v1 = a1._transitions[#a1._transitions]
    a1.BaselineNeeded:Fire(a1._expectedEpoch, if v1 ~= nil then v1.Frame.Revision else 0, a2)
end

function u28.latestRevision(a1) -- Line: 163
    local v1 = a1._transitions[#a1._transitions]
    if v1 == nil then
        return 0
    end
    return v1.Frame.Revision
end

function u28.consumeBaseline(a1, a2, a3) -- Line: 168
    -- upvalues: Serial (val), DestructibleFrame (val)
    local v1
    if not Serial.isUInt32(a2) then
        return false, "InvalidBaselineServerTick"
    end
    local v2, v3 = DestructibleFrame.Validate(a3.Epoch, a3.Revision, a3.Count, a3.ActiveBits)
    if not v2 then
        return false, v3
    end
    if a3.Epoch ~= a1._expectedEpoch then
        a1._needsBaseline = true
        if not a1._requestFired then
            a1._requestFired = true
            v1 = a1._transitions[#a1._transitions]
            a1.BaselineNeeded:Fire(a1._expectedEpoch, if v1 ~= nil then v1.Frame.Revision else 0, "BaselineEpochMismatch")
        end
        return false, "BaselineEpochMismatch"
    end
    if a3.Count ~= a1._expectedCount then
        a1._needsBaseline = true
        if not a1._requestFired then
            a1._requestFired = true
            v1 = a1._transitions[#a1._transitions]
            a1.BaselineNeeded:Fire(a1._expectedEpoch, if v1 ~= nil then v1.Frame.Revision else 0, "BaselineCountMismatch")
        end
        return false, "BaselineCountMismatch"
    end
    v1 = a1._transitions[#a1._transitions]
    if v1 ~= nil and v1.Frame.Revision == a3.Revision and v1.Frame.ActiveBits == a3.ActiveBits then
        a1._needsBaseline = false
        a1._requestFired = false
        return true, nil, false
    end
    local v4 = DestructibleFrame.New(a3.Epoch, a3.Revision, a3.Count, a3.ActiveBits)
    table.clear(a1._transitions)
    a1._transitions[1] = (table.freeze({ServerTick = a2, Frame = v4}))
    a1._needsBaseline = false
    a1._requestFired = false
    return true, nil, true
end

function u28.consumeDelta(a1, a2, a3, a4, a5) -- Line: 200
    -- upvalues: Serial (val), deactivate (val), prune (val)
    local v1
    if a1._needsBaseline then
        a1._needsBaseline = true
        if not a1._requestFired then
            a1._requestFired = true
            v1 = a1._transitions[#a1._transitions]
            a1.BaselineNeeded:Fire(a1._expectedEpoch, if v1 ~= nil then v1.Frame.Revision else 0, "DeltaWithoutBaseline")
        end
        return false, "BaselineRequired"
    end
    if a2 ~= a1._expectedEpoch then
        a1._needsBaseline = true
        if not a1._requestFired then
            a1._requestFired = true
            v1 = a1._transitions[#a1._transitions]
            a1.BaselineNeeded:Fire(a1._expectedEpoch, if v1 ~= nil then v1.Frame.Revision else 0, "DeltaEpochMismatch")
        end
        return false, "DeltaEpochMismatch"
    end
    if Serial.isUInt32(a3) and Serial.isUInt32(a4) then
        local v2
        v1 = a1._transitions[#a1._transitions]
        if v1 == nil then
            a1._needsBaseline = true
            if not a1._requestFired then
                a1._requestFired = true
                v2 = a1._transitions[#a1._transitions]
                a1.BaselineNeeded:Fire(a1._expectedEpoch, if v2 ~= nil then v2.Frame.Revision else 0, "DeltaWithoutBaseline")
            end
            return false, "BaselineRequired"
        end
        if a3 ~= Serial.addUInt32(v1.Frame.Revision, 1) then
            a1._needsBaseline = true
            if not a1._requestFired then
                a1._requestFired = true
                v2 = a1._transitions[#a1._transitions]
                a1.BaselineNeeded:Fire(a1._expectedEpoch, if v2 ~= nil then v2.Frame.Revision else 0, "DestructibleRevisionGap")
            end
            return false, "DestructibleRevisionGap"
        end
        v2 = Serial.deltaUInt32(a4, v1.ServerTick)
        if v2 <= 0 then
            a1._needsBaseline = true
            if not a1._requestFired then
                a1._requestFired = true
                v2 = a1._transitions[#a1._transitions]
                a1.BaselineNeeded:Fire(a1._expectedEpoch, if v2 ~= nil then v2.Frame.Revision else 0, "DeltaTickNotNewer")
            end
            return false, "DeltaTickNotNewer"
        end
        if type(a5) == "table" and #a5 ~= 0 then
            local v3, v4
            v2, v3 = deactivate(v1.Frame, a5, a3)
            if v2 ~= nil then
                local _transitions = a1._transitions
                v4 = #a1._transitions + 1
                _transitions[v4] = (table.freeze({ServerTick = a4, Frame = v2}))
                prune(a1, a4)
                return true, nil
            end
            a1._needsBaseline = true
            if not a1._requestFired then
                a1._requestFired = true
                v4 = a1._transitions[#a1._transitions]
                a1.BaselineNeeded:Fire(a1._expectedEpoch, if v4 ~= nil then v4.Frame.Revision else 0, v3 or "InvalidDelta")
            end
            return false, v3
        end
        a1._needsBaseline = true
        if not a1._requestFired then
            a1._requestFired = true
            v2 = a1._transitions[#a1._transitions]
            a1.BaselineNeeded:Fire(a1._expectedEpoch, if v2 ~= nil then v2.Frame.Revision else 0, "InvalidDeltaIndices")
        end
        return false, "InvalidDeltaIndices"
    end
    a1._needsBaseline = true
    if not a1._requestFired then
        a1._requestFired = true
        v1 = a1._transitions[#a1._transitions]
        a1.BaselineNeeded:Fire(a1._expectedEpoch, if v1 ~= nil then v1.Frame.Revision else 0, "InvalidDeltaStamp")
    end
    return false, "InvalidDeltaStamp"
end

function u28.resolve(a1, a2, a3) -- Line: 246
    -- upvalues: Serial (val), retainedTransition (val), prune (val)
    local v1, v2
    if not Serial.isUInt32(a2) then
        return nil, "InvalidResolveServerTick"
    end
    if a3 ~= nil and not Serial.isUInt32(a3) then
        return nil, "InvalidExpectedRevision"
    end
    if a1._needsBaseline then
        a1._needsBaseline = true
        if not a1._requestFired then
            a1._requestFired = true
            v1 = a1._transitions[#a1._transitions]
            a1.BaselineNeeded:Fire(a1._expectedEpoch, if v1 ~= nil then v1.Frame.Revision else 0, "BaselineRequired")
        end
        return nil, "BaselineRequired"
    end
    v1 = retainedTransition(a1, a2)
    if v1 == nil then
        a1._needsBaseline = true
        if not a1._requestFired then
            a1._requestFired = true
            v2 = a1._transitions[#a1._transitions]
            a1.BaselineNeeded:Fire(a1._expectedEpoch, if v2 ~= nil then v2.Frame.Revision else 0, "DestructibleFrameOutsideRetention")
        end
        return nil, "DestructibleFrameOutsideRetention"
    end
    if a3 ~= nil and v1.Frame.Revision ~= a3 then
        a1._needsBaseline = true
        if not a1._requestFired then
            a1._requestFired = true
            v2 = a1._transitions[#a1._transitions]
            a1.BaselineNeeded:Fire(a1._expectedEpoch, if v2 ~= nil then v2.Frame.Revision else 0, "DestructibleRevisionMismatch")
        end
        return nil, "DestructibleRevisionMismatch"
    end
    prune(a1, a2)
    return v1.Frame, nil
end

function u28.predict(a1, a2, a3) -- Line: 272
    -- upvalues: Serial (val), retainedTransition (val)
    if not Serial.isUInt32(a2) then
        return nil, "InvalidResolveServerTick"
    end
    local v1 = retainedTransition(a1, a2) or a1._transitions[1]
    if v1 == nil then
        return nil, "DestructibleFrameOutsideRetention"
    end
    if a3 ~= nil and v1.Frame.Revision ~= a3 then
        return nil, "DestructibleRevisionMismatch"
    end
    return v1.Frame, nil
end

function u28.peek(a1, a2, a3) -- Line: 288
    -- upvalues: Serial (val), retainedTransition (val)
    if not Serial.isUInt32(a2) then
        return nil, "InvalidResolveServerTick"
    end
    if a3 ~= nil and not Serial.isUInt32(a3) then
        return nil, "InvalidExpectedRevision"
    end
    if a1._needsBaseline then
        return nil, "BaselineRequired"
    end
    local v1 = retainedTransition(a1, a2)
    if v1 == nil then
        return nil, "DestructibleFrameOutsideRetention"
    end
    if a3 ~= nil and v1.Frame.Revision ~= a3 then
        return nil, "DestructibleRevisionMismatch"
    end
    return v1.Frame, nil
end

return table.freeze(u28)