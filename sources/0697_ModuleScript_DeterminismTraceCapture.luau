-- Decompiled with Potassium's decompiler.

local DiagnosticProtocol = require(script.Parent.Parent.DiagnosticProtocol);
local Enums = require(script.Parent.Parent.Enums);
local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
require(script.Parent.Parent.Transport);
local DeterminismTrace = require(script.Parent.Parent.Simulation.DeterminismTrace);
local State = require(script.Parent.Parent.Simulation.State);
require(script.Parent.Parent.Simulation.Types);
require(script.Parent.PredictionRing);
require(script.Parent.Reconciler);
local u1 = {};
u1.__index = u1;
local output = DiagnosticProtocol.output;

local function traceKey(p2: number, p3: number, p4: number) -- Line: 70
    return `{p2}:{p3}:{p4}`;
end;

local function supportLabel(p5) -- Line: 74
    return `{p5.Kind}:{p5.SourceId}`;
end;

local function snapshotIdentity(p6) -- Line: 78
    return {
        Generation = p6.Generation,
        Sequence = p6.Sequence,
        CommandNumber = p6.LastProcessedCommand,
        ServerTick = p6.ServerTick
    };
end;

local function traceEventSummary(p7) -- Line: 87
    return p7 == nil and "none" or string.format("line=%d pos=(%.8f,%.8f,%.8f) vel=(%.8f,%.8f,%.8f) flags=0x%02X scalar=%.8f object=%u state=0x%08X aux=0x%08X", p7.Line, p7.Position.X, p7.Position.Y, p7.Position.Z, p7.Velocity.X, p7.Velocity.Y, p7.Velocity.Z, p7.Flags, p7.Scalar, p7.ObjectId, p7.StateHash, p7.AuxHash);
end;

local function isGroundTraceEvent(p8: string) -- Line: 108
    local string_lower_ret = string.lower(p8);

    return (string.find(string_lower_ret, "ground", 1, true) ~= nil or (string.find(string_lower_ret, "duck", 1, true) ~= nil or (string.find(string_lower_ret, "support", 1, true) ~= nil or (p8 == "simulation.input" or p8 == "simulation.outputConversion")))) and true or p8 == "runtime.playerContacts.final";
end;

local function printGroundTrace(p9: string, p10: buffer) -- Line: 118
    -- upvalues: DeterminismTrace (copy), output (copy), isGroundTraceEvent (copy), traceEventSummary (copy)
    local v11 = DeterminismTrace.describe(p10);

    if v11 == nil then
        output((`[MovementV2.Trace] GROUND_TRACE_{p9} malformed`));

        return;
    end;

    local v12 = 0;

    for _, v in v11 do
        if isGroundTraceEvent(v.Label) then
            v12 = v12 + 1;
            output(string.format("[MovementV2.Trace] GROUND_TRACE_%s event=%d stage=%s source=%s %s", p9, v.Index, v.Label, v.Source, traceEventSummary(v.Event)));
        end;
    end;

    if v12 == 0 then
        output((`[MovementV2.Trace] GROUND_TRACE_{p9} no ground/duck/support events`));
    end;
end;

function u1.new(p13: table) -- Line: 146
    -- upvalues: u1 (copy)
    return setmetatable({
        _lastRequestAt = (-1 / 0),
        _lastSuspiciousGroundObservedAt = (-1 / 0),
        _host = p13,
        _pendingComparisons = {}
    }, u1);
end;

function u1.bind(p14, p15) -- Line: 155
    p14._channels = p15;
end;

function u1.reset(p16, p17) -- Line: 160
    -- upvalues: DiagnosticProtocol (copy), DeterminismTrace (copy)
    local v18;

    if DiagnosticProtocol.DeterminismTraceEnabled and p17 ~= nil then
        v18 = DeterminismTrace.Ring.new(p17.PredictionReplayTicks);
    else
        v18 = nil;
    end;

    p16._ring = v18;
    table.clear(p16._pendingComparisons);
    p16._pendingSuspiciousGroundTrace = nil;
    p16._lastRequestAt = (-1 / 0);
    p16._lastSuspiciousGroundObservedAt = (-1 / 0);
end;

function u1.begin(p19: table, p20: number, p21: number, p22: number) -- Line: 170
    local _ring = p19._ring;

    if _ring == nil then
        return nil;
    end;

    return _ring:begin(p20, p21, p22);
end;

function u1.finish(p23, p24) -- Line: 175
    local _ring = p23._ring;

    if p24 ~= nil and _ring ~= nil then
        _ring:finish(p24);
    end;
end;

function u1._send(p25: table, p26: number, p27: number, p28: number, p29: buffer, p30: string) -- Line: 182
    -- upvalues: DeterminismTrace (copy), output (copy)
    local _channels = p25._channels;

    if _channels == nil then
        return false;
    end;

    local v31 = `{p26}:{p27}:{p28}`;

    if p25._pendingComparisons[v31] ~= nil then
        return false;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret - p25._lastRequestAt < 0.2 then
        return false;
    end;

    p25._pendingComparisons[v31] = {
        Payload = p29,
        Reason = p30
    };
    p25._lastRequestAt = os_clock_ret;
    _channels.Trace:FireServer(DeterminismTrace.encodeRequest(p26, p27, p28));
    output(string.format("[MovementV2.Trace] REQUEST generation=%u cmd=%u tick=%u reason=%s", p26, p27, p28, p30));

    return true;
end;

function u1._requestMismatchTrace(p32, p33, p34, p35) -- Line: 220
    -- upvalues: Serial (copy), output (copy), State (copy)
    local _ring = p32._ring;

    if _ring == nil or (p34 == nil or (p34.ServerTick ~= p33.ServerTick or (p33.LastProcessedCommand == Serial.UInt32Max or (p35.ReconciliationMode == "Reuse" or (p35.PlayerContactCorrection or p35.CanonicalStateMismatchCount == 0 and not p35.CanonicalSupportMismatch))))) then
        return;
    end;

    local v36 = _ring:get(p33.Generation, p33.LastProcessedCommand, p33.ServerTick);

    if v36 ~= nil then
        p32:_send(p33.Generation, p33.LastProcessedCommand, p33.ServerTick, v36, (`Mismatch:{State.mismatchLabel(p35.CanonicalStateMismatchMask)}`));

        return;
    end;

    local string_format_ret = string.format("[MovementV2.Trace] LOCAL_TRACE_UNAVAILABLE generation=%u cmd=%u tick=%u; prediction history was replaced before the mismatch could be paired", p33.Generation, p33.LastProcessedCommand, p33.ServerTick);
    output(string_format_ret);
    p32._host.Report("TraceComparison", string_format_ret, {
        Generation = p33.Generation,
        Sequence = p33.Sequence,
        CommandNumber = p33.LastProcessedCommand,
        ServerTick = p33.ServerTick
    });
end;

function u1._requestPendingSuspiciousGroundTrace(p37, p38) -- Line: 258
    -- upvalues: Serial (copy), output (copy)
    local _pendingSuspiciousGroundTrace = p37._pendingSuspiciousGroundTrace;

    if _pendingSuspiciousGroundTrace == nil then
        return;
    end;

    if p38.Generation ~= _pendingSuspiciousGroundTrace.Generation then
        p37._pendingSuspiciousGroundTrace = nil;

        return;
    end;

    if p38.LastProcessedCommand == Serial.UInt32Max or Serial.deltaUInt32(p38.LastProcessedCommand, _pendingSuspiciousGroundTrace.CommandNumber) < 0 then
        return;
    end;

    if p37:_send(_pendingSuspiciousGroundTrace.Generation, _pendingSuspiciousGroundTrace.CommandNumber, _pendingSuspiciousGroundTrace.ServerTick, _pendingSuspiciousGroundTrace.Payload, "SuspiciousCrouchGroundLoss") then
        output((`[MovementV2.Trace] SUSPICIOUS_CONTEXT {_pendingSuspiciousGroundTrace.Context}`));
        p37._pendingSuspiciousGroundTrace = nil;
    end;
end;

function u1.onSnapshotCommitted(p39: table, p40: any, p41: any, p42: any, p43: boolean) -- Line: 288
    -- upvalues: Serial (copy)
    if p39._ring == nil then
        return;
    end;

    if p42.SynthesizedInput or p42.ServerHeldTickCount > 0 then
        local _pendingSuspiciousGroundTrace = p39._pendingSuspiciousGroundTrace;

        if _pendingSuspiciousGroundTrace ~= nil and (_pendingSuspiciousGroundTrace.Generation == p40.Generation and (p40.LastProcessedCommand ~= Serial.UInt32Max and Serial.deltaUInt32(p40.LastProcessedCommand, _pendingSuspiciousGroundTrace.CommandNumber) >= 0)) then
            p39._pendingSuspiciousGroundTrace = nil;
        end;

        return;
    end;

    if p43 then
        p39:_requestMismatchTrace(p40, p41, p42);
    end;

    p39:_requestPendingSuspiciousGroundTrace(p40);
end;

function u1.observePredictedStep(p44: table, p45: number, p46: any, p47: number, p48: any, p49: any, p50: any, p51: any, p52: any) -- Line: 318
    -- upvalues: Enums (copy), output (copy)
    local _ring = p44._ring;

    if _ring == nil or not (p52.LeftGround and (not p52.Jumped and p48.OnGround)) then
        return;
    end;

    if not (Enums.Buttons.has(p46.Buttons, Enums.Buttons.Duck) or Enums.Buttons.has(p48.PreviousButtons, Enums.Buttons.Duck) or (p48.Stance == "Ducking" or p50.Stance == "Ducking" or (p48.IsDucking or (p50.IsDucking or p48.JumpHullActive or (p50.JumpHullActive or math.abs(p50.DuckAmount - p48.DuckAmount) > 1e-6))))) then
        return;
    end;

    local os_clock_ret = os.clock();

    if p44._pendingSuspiciousGroundTrace ~= nil or os_clock_ret - p44._lastSuspiciousGroundObservedAt < 0.75 then
        return;
    end;

    local v53 = _ring:get(p45, p46.CommandNumber, p47);

    if v53 == nil then
        return;
    end;

    local string_format_ret = string.format("buttons=0x%02X move=(%.3f,%.3f) prevPos=(%.8f,%.8f,%.8f) nextPos=(%.8f,%.8f,%.8f) prevVel=(%.8f,%.8f,%.8f) nextVel=(%.8f,%.8f,%.8f) stance=%s/%s duck=%.6f/%.6f jumpHull=%s/%s support=%s/%s", p46.Buttons, p46.Move.X, p46.Move.Y, p48.Position.X, p48.Position.Y, p48.Position.Z, p50.Position.X, p50.Position.Y, p50.Position.Z, p48.Velocity.X, p48.Velocity.Y, p48.Velocity.Z, p50.Velocity.X, p50.Velocity.Y, p50.Velocity.Z, p48.Stance, p50.Stance, p48.DuckAmount, p50.DuckAmount, tostring(p48.JumpHullActive), tostring(p50.JumpHullActive), `{p49.Kind}:{p49.SourceId}`, (`{p51.Kind}:{p51.SourceId}`));
    p44._pendingSuspiciousGroundTrace = {
        Generation = p45,
        CommandNumber = p46.CommandNumber,
        ServerTick = p47,
        Payload = v53,
        Context = string_format_ret
    };
    p44._lastSuspiciousGroundObservedAt = os_clock_ret;
    output(string.format("[MovementV2.Trace] SUSPICIOUS_CROUCH_GROUND_LOSS generation=%u cmd=%u tick=%u %s", p45, p46.CommandNumber, p47, string_format_ret));
end;

function u1.handleServerTrace(p54: table, p55: any, p56: number?) -- Line: 401
    -- upvalues: DeterminismTrace (copy), output (copy), DiagnosticProtocol (copy), printGroundTrace (copy)
    local v57, v58, v59, v60 = DeterminismTrace.identity(p55);

    if v57 == nil or (v58 == nil or v59 == nil) then
        p54._host.Warn("rejected malformed authoritative simulation trace");

        return;
    end;

    local v61 = `{v57}:{v58}:{v59}`;
    local v62 = p54._pendingComparisons[v61];

    if v62 == nil then
        return;
    end;

    p54._pendingComparisons[v61] = nil;
    local v63 = {
        Generation = v57,
        Sequence = p56,
        CommandNumber = v58,
        ServerTick = v59
    };

    if v60 then
        local string_format_ret = string.format("[MovementV2.Trace] SERVER_TRACE_UNAVAILABLE generation=%u cmd=%u tick=%u reason=%s; the authority trace aged out or the reported command/tick identity was not committed", v57, v58, v59, v62.Reason);
        output(string_format_ret);
        p54._host.Report("TraceComparison", string_format_ret, v63);

        return;
    end;

    if v62.Reason == "SuspiciousCrouchGroundLoss" and DiagnosticProtocol.VerboseGroundTraceEnabled then
        printGroundTrace("CLIENT", v62.Payload);
        printGroundTrace("SERVER", p55);
    end;

    local v64 = DeterminismTrace.compare(v62.Payload, p55);

    if v64 == nil then
        p54._host.Warn("authoritative simulation trace identity changed during comparison");

        return;
    end;

    if v64.Matched then
        local string_format_ret = string.format("[MovementV2.Trace] NO_RECORDED_DIFFERENCE generation=%u cmd=%u tick=%u reason=%s clientEvents=%d serverEvents=%d overflow=%s/%s likelyCause=The fixed movement step matched; inspect command loss, timeline/replay barriers, player contacts, or presentation after this anchor", v57, v58, v59, v62.Reason, v64.ClientCount, v64.ServerCount, tostring(v64.ClientOverflow), (tostring(v64.ServerOverflow)));
        output(string_format_ret);
        p54._host.Report("TraceComparison", string_format_ret, v63);

        return;
    end;

    local string_format = string.format;
    local Reason = v62.Reason;
    local EventIndex = v64.EventIndex;
    local ClientCount = v64.ClientCount;
    local ServerCount = v64.ServerCount;
    local Classification = v64.Classification;
    local Label = v64.Label;
    local ClientSource = v64.ClientSource;
    local Client = v64.Client;
    local v65 = Client == nil and "none" or string.format("line=%d pos=(%.8f,%.8f,%.8f) vel=(%.8f,%.8f,%.8f) flags=0x%02X scalar=%.8f object=%u state=0x%08X aux=0x%08X", Client.Line, Client.Position.X, Client.Position.Y, Client.Position.Z, Client.Velocity.X, Client.Velocity.Y, Client.Velocity.Z, Client.Flags, Client.Scalar, Client.ObjectId, Client.StateHash, Client.AuxHash);
    local Server = v64.Server;
    local v66 = string_format("[MovementV2.Trace] FIRST_DIVERGENCE generation=%u cmd=%u tick=%u reason=%s event=%d/%d:%d class=%s stage=%s clientSource=%s client={%s} serverSource=%s server={%s} overflow=%s/%s", v57, v58, v59, Reason, EventIndex, ClientCount, ServerCount, Classification, Label, ClientSource, v65, v64.ServerSource, Server == nil and "none" or string.format("line=%d pos=(%.8f,%.8f,%.8f) vel=(%.8f,%.8f,%.8f) flags=0x%02X scalar=%.8f object=%u state=0x%08X aux=0x%08X", Server.Line, Server.Position.X, Server.Position.Y, Server.Position.Z, Server.Velocity.X, Server.Velocity.Y, Server.Velocity.Z, Server.Flags, Server.Scalar, Server.ObjectId, Server.StateHash, Server.AuxHash), tostring(v64.ClientOverflow), (tostring(v64.ServerOverflow)));
    output(v66);
    p54._host.Report("TraceComparison", v66, v63);
end;

return table.freeze(u1);