-- ReplicatedStorage.MovementV2.Client.DeterminismTraceCapture
-- Script path: ReplicatedStorage.MovementV2.Client.DeterminismTraceCapture
-- Decompile time: 7.25 ms

local DiagnosticProtocol = require(script.Parent.Parent.DiagnosticProtocol)
local Enums = require(script.Parent.Parent.Enums)
local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
require(script.Parent.Parent.Transport)
local DeterminismTrace = require(script.Parent.Parent.Simulation.DeterminismTrace)
local State = require(script.Parent.Parent.Simulation.State)
require(script.Parent.Parent.Simulation.Types)
require(script.Parent.PredictionRing)
require(script.Parent.Reconciler)
local u61 = {}
u61.__index = u61
local output = DiagnosticProtocol.output

local function traceKey(a1, a2, a3) -- Line: 70 -- types: a1: number, a2: number, a3: number
    return (("%*:%*:%*"):format(a1, a2, a3))
end

local function supportLabel(a1) -- Line: 74
    return (("%*:%*"):format(a1.Kind, a1.SourceId))
end

local function snapshotIdentity(a1) -- Line: 78
    return {
        Generation = a1.Generation,
        Sequence = a1.Sequence,
        CommandNumber = a1.LastProcessedCommand,
        ServerTick = a1.ServerTick,
    }
end

local function traceEventSummary(a1) -- Line: 87
    if a1 == nil then
        return "none"
    end
    return string.format(
        "line=%d pos=(%.8f,%.8f,%.8f) vel=(%.8f,%.8f,%.8f) flags=0x%02X scalar=%.8f object=%u state=0x%08X aux=0x%08X",
        a1.Line,
        a1.Position.X,
        a1.Position.Y,
        a1.Position.Z,
        a1.Velocity.X,
        a1.Velocity.Y,
        a1.Velocity.Z,
        a1.Flags,
        a1.Scalar,
        a1.ObjectId,
        a1.StateHash,
        a1.AuxHash
    )
end

local function isGroundTraceEvent(a1) -- Line: 108 -- types: a1: string
    local v1 = string.lower(a1)
    local v2 = true
    if string.find(v1, "ground", 1, true) == nil then
        v2 = true
        if string.find(v1, "duck", 1, true) == nil then
            v2 = true
            if string.find(v1, "support", 1, true) == nil then
                v2 = true
                if a1 ~= "simulation.input" then
                    v2 = true
                    if a1 ~= "simulation.outputConversion" then
                        v2 = a1 == "runtime.playerContacts.final"
                    end
                end
            end
        end
    end
    return v2
end

local function printGroundTrace(a1, a2) -- Line: 118
    -- upvalues: DeterminismTrace (val), output (val), isGroundTraceEvent (val), traceEventSummary (val)
    local v1 = DeterminismTrace.describe(a2)
    if v1 == nil then
        output((("[MovementV2.Trace] GROUND_TRACE_%* malformed"):format(a1)))
        return
    end
    local v2 = 0
    for i, j in v1 do
        if isGroundTraceEvent(j.Label) then
            v2 = v2 + 1
            output(string.format(
                "[MovementV2.Trace] GROUND_TRACE_%s event=%d stage=%s source=%s %s",
                a1,
                j.Index,
                j.Label,
                j.Source,
                traceEventSummary(j.Event)
            ))
        end
    end
    if v2 == 0 then
        output((("[MovementV2.Trace] GROUND_TRACE_%* no ground/duck/support events"):format(a1)))
    end
end

function u61.new(a1) -- Line: 146 -- upvalues: u61 (val) -- types: a1: table
    return (setmetatable({
        _lastRequestAt = (-1 / 0),
        _lastSuspiciousGroundObservedAt = (-1 / 0),
        _host = a1,
        _pendingComparisons = {},
    }, u61))
end

function u61.bind(a1, a2) -- Line: 155
    a1._channels = a2
end

function u61.reset(a1, a2) -- Line: 160 -- upvalues: DiagnosticProtocol (val), DeterminismTrace (val)
    a1._ring = if not DiagnosticProtocol.DeterminismTraceEnabled then nil else if a2 == nil then nil else DeterminismTrace.Ring.new(a2.PredictionReplayTicks)
    table.clear(a1._pendingComparisons)
    a1._pendingSuspiciousGroundTrace = nil
    a1._lastRequestAt = (-1 / 0)
    a1._lastSuspiciousGroundObservedAt = (-1 / 0)
end

function u61:begin(a2, a3, a4) -- Line: 170 -- types: self: table, a2: number, a3: number, a4: number
    local _ring = self._ring
    if _ring == nil then
        return nil
    end
    return (_ring:begin(a2, a3, a4))
end

function u61:finish(a2) -- Line: 175
    local _ring = self._ring
    if a2 ~= nil and _ring ~= nil then
        _ring:finish(a2)
    end
end

function u61:_send(a2, a3, a4, a5, a6) -- Line: 182
    -- upvalues: DeterminismTrace (val), output (val)
    local _channels = self._channels
    if _channels == nil then
        return false
    end
    local v1 = ("%*:%*:%*"):format(a2, a3, a4)
    if self._pendingComparisons[v1] ~= nil then
        return false
    end
    local v2 = os.clock()
    if v2 - self._lastRequestAt < 0.2 then
        return false
    end
    self._pendingComparisons[v1] = {Payload = a5, Reason = a6}
    self._lastRequestAt = v2
    _channels.Trace:FireServer((DeterminismTrace.encodeRequest(a2, a3, a4)))
    output(string.format("[MovementV2.Trace] REQUEST generation=%u cmd=%u tick=%u reason=%s", a2, a3, a4, a6))
    return true
end

function u61:_requestMismatchTrace(a2, a3, a4) -- Line: 220 -- upvalues: Serial (val), output (val), State (val)
    local _ring = self._ring
    if _ring ~= nil
        and a3 ~= nil
        and a3.ServerTick == a2.ServerTick
        and a2.LastProcessedCommand ~= Serial.UInt32Max
        and a4.ReconciliationMode ~= "Reuse"
        and not a4.PlayerContactCorrection then
        if a4.CanonicalStateMismatchCount == 0 and not a4.CanonicalSupportMismatch then
            return
        end
        local v1 = _ring:get(a2.Generation, a2.LastProcessedCommand, a2.ServerTick)
        if v1 ~= nil then
            self:_send(
                a2.Generation,
                a2.LastProcessedCommand,
                a2.ServerTick,
                v1,
                (("Mismatch:%*"):format((State.mismatchLabel(a4.CanonicalStateMismatchMask))))
            )
            return
        end
        local v2 = string.format(
            "[MovementV2.Trace] LOCAL_TRACE_UNAVAILABLE generation=%u cmd=%u tick=%u; prediction history was replaced before the mismatch could be paired",
            a2.Generation,
            a2.LastProcessedCommand,
            a2.ServerTick
        )
        output(v2)
        self._host.Report("TraceComparison", v2, {
            Generation = a2.Generation,
            Sequence = a2.Sequence,
            CommandNumber = a2.LastProcessedCommand,
            ServerTick = a2.ServerTick,
        })
        return
    end
end

function u61:_requestPendingSuspiciousGroundTrace(a2) -- Line: 258 -- upvalues: Serial (val), output (val)
    local _pendingSuspiciousGroundTrace = self._pendingSuspiciousGroundTrace
    if _pendingSuspiciousGroundTrace == nil then
        return
    end
    if a2.Generation ~= _pendingSuspiciousGroundTrace.Generation then
        self._pendingSuspiciousGroundTrace = nil
        return
    end
    if a2.LastProcessedCommand ~= Serial.UInt32Max
        and not ((Serial.deltaUInt32(a2.LastProcessedCommand, _pendingSuspiciousGroundTrace.CommandNumber)) < 0) then
        if self:_send(
            _pendingSuspiciousGroundTrace.Generation,
            _pendingSuspiciousGroundTrace.CommandNumber,
            _pendingSuspiciousGroundTrace.ServerTick,
            _pendingSuspiciousGroundTrace.Payload,
            "SuspiciousCrouchGroundLoss"
        ) then
            output((("[MovementV2.Trace] SUSPICIOUS_CONTEXT %*"):format(_pendingSuspiciousGroundTrace.Context)))
            self._pendingSuspiciousGroundTrace = nil
        end
        return
    end
end

function u61.onSnapshotCommitted(a1, a2, a3, a4, a5) -- Line: 288
    -- upvalues: Serial (val)
    if a1._ring == nil then
        return
    end
    local SynthesizedInput = a4.SynthesizedInput or 0 < a4.ServerHeldTickCount
    if not SynthesizedInput then
        if a5 then
            a1:_requestMismatchTrace(a2, a3, a4)
        end
        a1:_requestPendingSuspiciousGroundTrace(a2)
        return
    end
    local _pendingSuspiciousGroundTrace = a1._pendingSuspiciousGroundTrace
    if _pendingSuspiciousGroundTrace ~= nil
        and _pendingSuspiciousGroundTrace.Generation == a2.Generation
        and a2.LastProcessedCommand ~= Serial.UInt32Max
        and 0 <= (Serial.deltaUInt32(a2.LastProcessedCommand, _pendingSuspiciousGroundTrace.CommandNumber)) then
        a1._pendingSuspiciousGroundTrace = nil
    end
end

function u61.observePredictedStep(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 318
    -- upvalues: Enums (val), output (val)
    local _ring = a1._ring
    if _ring ~= nil and a9.LeftGround and not a9.Jumped and a5.OnGround then
        local IsDucking = Enums.Buttons.has(a3.Buttons, Enums.Buttons.Duck)
        if not IsDucking then
            IsDucking = Enums.Buttons.has(a5.PreviousButtons, Enums.Buttons.Duck)
            if not IsDucking then
                IsDucking = true
                if a5.Stance ~= "Ducking" then
                    IsDucking = true
                    if a7.Stance ~= "Ducking" then
                        IsDucking = a5.IsDucking or a7.IsDucking or a5.JumpHullActive or a7.JumpHullActive or 1e-06 < (math.abs(a7.DuckAmount - a5.DuckAmount))
                    end
                end
            end
        end
        if not IsDucking then
            return
        end
        local v1 = os.clock()
        if a1._pendingSuspiciousGroundTrace == nil then
            local v2 = v1 - a1._lastSuspiciousGroundObservedAt
            if not (v2 < 0.75) then
                v2 = _ring:get(a2, a3.CommandNumber, a4)
                if v2 == nil then
                    return
                end
                local v3 = string.format(
                    "buttons=0x%02X move=(%.3f,%.3f) prevPos=(%.8f,%.8f,%.8f) nextPos=(%.8f,%.8f,%.8f) prevVel=(%.8f,%.8f,%.8f) nextVel=(%.8f,%.8f,%.8f) stance=%s/%s duck=%.6f/%.6f jumpHull=%s/%s support=%s/%s",
                    a3.Buttons,
                    a3.Move.X,
                    a3.Move.Y,
                    a5.Position.X,
                    a5.Position.Y,
                    a5.Position.Z,
                    a7.Position.X,
                    a7.Position.Y,
                    a7.Position.Z,
                    a5.Velocity.X,
                    a5.Velocity.Y,
                    a5.Velocity.Z,
                    a7.Velocity.X,
                    a7.Velocity.Y,
                    a7.Velocity.Z,
                    a5.Stance,
                    a7.Stance,
                    a5.DuckAmount,
                    a7.DuckAmount,
                    tostring(a5.JumpHullActive),
                    tostring(a7.JumpHullActive),
                    ("%*:%*"):format(a6.Kind, a6.SourceId),
                    (("%*:%*"):format(a8.Kind, a8.SourceId))
                )
                a1._pendingSuspiciousGroundTrace = {
                    Generation = a2,
                    CommandNumber = a3.CommandNumber,
                    ServerTick = a4,
                    Payload = v2,
                    Context = v3,
                }
                a1._lastSuspiciousGroundObservedAt = v1
                output(string.format(
                    "[MovementV2.Trace] SUSPICIOUS_CROUCH_GROUND_LOSS generation=%u cmd=%u tick=%u %s",
                    a2,
                    a3.CommandNumber,
                    a4,
                    v3
                ))
                return
            end
        end
        return
    end
end

function u61.handleServerTrace(a1, a2, a3) -- Line: 401
    -- upvalues: DeterminismTrace (val), output (val), DiagnosticProtocol (val), printGroundTrace (val)
    local v1, v2, v3, v4 = DeterminismTrace.identity(a2)
    if v1 ~= nil and v2 ~= nil and v3 ~= nil then
        local v5, v6
        local v7 = ("%*:%*:%*"):format(v1, v2, v3)
        local v8 = a1._pendingComparisons[v7]
        if v8 == nil then
            return
        end
        a1._pendingComparisons[v7] = nil
        local v9 = {Generation = v1, Sequence = a3, CommandNumber = v2, ServerTick = v3}
        if v4 then
            v5 = string.format(
                "[MovementV2.Trace] SERVER_TRACE_UNAVAILABLE generation=%u cmd=%u tick=%u reason=%s; the authority trace aged out or the reported command/tick identity was not committed",
                v1,
                v2,
                v3,
                v8.Reason
            )
            output(v5)
            a1._host.Report("TraceComparison", v5, v9)
            return
        end
        if v8.Reason == "SuspiciousCrouchGroundLoss" and DiagnosticProtocol.VerboseGroundTraceEnabled then
            printGroundTrace("CLIENT", v8.Payload)
            printGroundTrace("SERVER", a2)
        end
        v5 = DeterminismTrace.compare(v8.Payload, a2)
        if v5 == nil then
            a1._host.Warn("authoritative simulation trace identity changed during comparison")
            return
        end
        if v5.Matched then
            v6 = string.format(
                "[MovementV2.Trace] NO_RECORDED_DIFFERENCE generation=%u cmd=%u tick=%u reason=%s clientEvents=%d serverEvents=%d overflow=%s/%s likelyCause=The fixed movement step matched; inspect command loss, timeline/replay barriers, player contacts, or presentation after this anchor",
                v1,
                v2,
                v3,
                v8.Reason,
                v5.ClientCount,
                v5.ServerCount,
                tostring(v5.ClientOverflow),
                (tostring(v5.ServerOverflow))
            )
            output(v6)
            a1._host.Report("TraceComparison", v6, v9)
            return
        end
        local format_2 = string.format
        local Reason_2 = v8.Reason
        local EventIndex = v5.EventIndex
        local ClientCount_2 = v5.ClientCount
        local ServerCount_2 = v5.ServerCount
        local Classification = v5.Classification
        local Label = v5.Label
        local ClientSource = v5.ClientSource
        local Client = v5.Client
        local ServerSource = v5.ServerSource
        local Server = v5.Server
        local v10 = if Server ~= nil then string.format(
            "line=%d pos=(%.8f,%.8f,%.8f) vel=(%.8f,%.8f,%.8f) flags=0x%02X scalar=%.8f object=%u state=0x%08X aux=0x%08X",
            Server.Line,
            Server.Position.X,
            Server.Position.Y,
            Server.Position.Z,
            Server.Velocity.X,
            Server.Velocity.Y,
            Server.Velocity.Z,
            Server.Flags,
            Server.Scalar,
            Server.ObjectId,
            Server.StateHash,
            Server.AuxHash
        ) else "none"
        local v11 = tostring(v5.ClientOverflow)
        local ServerOverflow_2 = v5.ServerOverflow
        v6 = format_2("[MovementV2.Trace] FIRST_DIVERGENCE generation=%u cmd=%u tick=%u reason=%s event=%d/%d:%d class=%s stage=%s clientSource=%s client={%s} serverSource=%s server={%s} overflow=%s/%s", v1, v2, v3, Reason_2, EventIndex, ClientCount_2, ServerCount_2, Classification, Label, ClientSource, if Client ~= nil then string.format(
            "line=%d pos=(%.8f,%.8f,%.8f) vel=(%.8f,%.8f,%.8f) flags=0x%02X scalar=%.8f object=%u state=0x%08X aux=0x%08X",
            Client.Line,
            Client.Position.X,
            Client.Position.Y,
            Client.Position.Z,
            Client.Velocity.X,
            Client.Velocity.Y,
            Client.Velocity.Z,
            Client.Flags,
            Client.Scalar,
            Client.ObjectId,
            Client.StateHash,
            Client.AuxHash
        ) else "none", ServerSource, v10, v11, (tostring(ServerOverflow_2)))
        output(v6)
        a1._host.Report("TraceComparison", v6, v9)
        return
    end
    a1._host.Warn("rejected malformed authoritative simulation trace")
end

return table.freeze(u61)