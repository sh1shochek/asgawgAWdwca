-- Decompiled with Potassium's decompiler.

local Config = require(script.Parent.Parent.Config);
local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
local u1 = {};
u1.__index = u1;

local function isFinite(p2: number) -- Line: 84
    local v3;

    if p2 == p2 and p2 > (-1 / 0) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

function u1.new(p4: any, p5: boolean?) -- Line: 88
    -- upvalues: Config (copy), u1 (copy)
    local v6 = type(p4) == "table";
    assert(v6, "derived config is required");
    local math_max_ret = math.max(p4.RemoteSnapshotEveryTicks, 1);
    local math_max_ret2 = math.max(math_max_ret * 2, p4.RemoteHistoryTicks - p4.RenderInterpolationTicks - math_max_ret);

    return setmetatable({
        _anchorTick = nil,
        _latestTicks = 0,
        _latestAtSeconds = 0,
        _position = nil,
        _windowHead = 1,
        _windowTail = 0,
        _lateKey = nil,
        _jitterTicks = 0,
        _lateKeyDirty = false,
        _lastMode = "Unanchored",
        _lastErrorTicks = 0,
        _lastMinMarginTicks = nil,
        _lastRate = 1,
        _hardRebases = 0,
        _frames = 0,
        _extrapolatingFrames = 0,
        _holdingFrames = 0,
        _config = p4,
        _hz = p4.SimulationHz,
        _renderOffsetTicks = p4.RenderInterpolationTicks,
        _horizonTicks = p4.RenderInterpolationTicks + p4.MaxRemoteExtrapolationTicks,
        _maxBehindTicks = math_max_ret2,
        _deepestLagTicks = math_max_ret2 * 0.75,
        _spacingTicks = p4.SimulationHz * Config.PolicySeconds.RemoteSnapshotPeriod,
        _spectator = p5 == true,
        _bufferTicks = p5 and 2 or 0,
        _windowKeys = {},
        _windowTimes = {},
        _sortScratch = {}
    }, u1);
end;

function u1.setSpectator(p7: table, p8: boolean) -- Line: 127
    p7._spectator = p8;
    p7._bufferTicks = p8 and 2 or 0;
end;

local function targetTicks(p9) -- Line: 133
    return 0.005 * p9._hz + p9._bufferTicks;
end;

local function clearWindow(p10) -- Line: 137
    table.clear(p10._windowKeys);
    table.clear(p10._windowTimes);
    p10._windowHead = 1;
    p10._windowTail = 0;
    p10._lateKey = nil;
    p10._jitterTicks = 0;
    p10._lateKeyDirty = false;
end;

local function pushMargin(p11: any, p12: number, p13: number) -- Line: 147
    local v14 = p11._windowTail + 1;
    p11._windowKeys[v14] = p12;
    p11._windowTimes[v14] = p13;
    p11._windowTail = v14;
    p11._lateKeyDirty = true;
end;

local function lateArrivalKey(p15: any, p16: number) -- Line: 156
    local _windowKeys = p15._windowKeys;
    local _windowTimes = p15._windowTimes;
    local _windowHead = p15._windowHead;

    while _windowHead <= p15._windowTail and _windowTimes[_windowHead] < p16 - 1.5 do
        _windowKeys[_windowHead] = nil;
        _windowTimes[_windowHead] = nil;
        _windowHead = _windowHead + 1;
        p15._lateKeyDirty = true;
    end;

    if p15._windowTail >= _windowHead then
        p15._windowHead = _windowHead;

        if p15._lateKeyDirty then
            local _sortScratch = p15._sortScratch;
            table.clear(_sortScratch);
            table.move(_windowKeys, _windowHead, p15._windowTail, 1, _sortScratch);
            table.sort(_sortScratch);
            local v17 = _sortScratch[math.floor(#_sortScratch * 0.05) + 1];
            p15._lateKey = v17;
            p15._jitterTicks = _sortScratch[math.floor(#_sortScratch * 0.5) + 1] - v17;
            p15._lateKeyDirty = false;
        end;

        return p15._lateKey;
    end;

    p15._windowHead = 1;
    p15._windowTail = 0;
    p15._lateKey = nil;

    return nil;
end;

local function settledPosition(p18: any, p19: number) -- Line: 187
    local v20 = math.max(p19 - p18._latestAtSeconds, 0) * p18._hz;

    return math.min(p18._latestTicks + p18._renderOffsetTicks - p18._spacingTicks - (0.005 * p18._hz + p18._bufferTicks) + v20, p18._latestTicks + p18._horizonTicks);
end;

function u1.observe(p21: table, p22: number, p23: number) -- Line: 193
    -- upvalues: Serial (copy)
    local v24 = Serial.isUInt32(p22);
    assert(v24, "invalid remote server tick");
    local v25;

    if p23 == p23 and p23 > (-1 / 0) then
        v25 = p23 < (1 / 0);
    else
        v25 = false;
    end;

    if v25 then
        v25 = p23 >= 0;
    end;

    assert(v25, "invalid observation time");
    local _anchorTick = p21._anchorTick;

    if _anchorTick == nil then
        p21._anchorTick = p22;
        p21._latestTicks = 0;
        p21._latestAtSeconds = p23;

        return true;
    end;

    local v26 = Serial.deltaUInt32(p22, _anchorTick);

    if v26 <= p21._latestTicks then
        return false;
    end;

    local v27 = p21._windowTail + 1;
    p21._windowKeys[v27] = p21._latestTicks + p21._renderOffsetTicks - p23 * p21._hz;
    p21._windowTimes[v27] = p23;
    p21._windowTail = v27;
    p21._lateKeyDirty = true;
    p21._latestTicks = v26;
    p21._latestAtSeconds = p23;

    return true;
end;

local function rebase(p28: any, p29: number, p30: number) -- Line: 215
    -- upvalues: Serial (copy)
    local v31 = assert(p28._anchorTick);
    local _latestTicks = p28._latestTicks;
    p28._anchorTick = Serial.addUInt32(v31, _latestTicks);
    p28._latestTicks = 0;
    table.clear(p28._windowKeys);
    table.clear(p28._windowTimes);
    p28._windowHead = 1;
    p28._windowTail = 0;
    p28._lateKey = nil;
    p28._jitterTicks = 0;
    p28._lateKeyDirty = false;
    p28._hardRebases = p28._hardRebases + 1;
    p28._lastMode = "Rebased";
    local v32 = math.max(p29 - p28._latestAtSeconds, 0) * p28._hz;
    local math_min_ret = math.min(p28._latestTicks + p28._renderOffsetTicks - p28._spacingTicks - (0.005 * p28._hz + p28._bufferTicks) + v32, p28._latestTicks + p28._horizonTicks);

    return math.max(math_min_ret, p30 - _latestTicks), _latestTicks;
end;

function u1.advance(p33: table, p34: number?, p35: number) -- Line: 227
    -- upvalues: rebase (copy), lateArrivalKey (copy)
    local v36;

    if p34 == nil then
        v36 = true;
    else
        if p34 == p34 and p34 > (-1 / 0) then
            v36 = p34 < (1 / 0);
        else
            v36 = false;
        end;

        if v36 then
            v36 = p34 >= 0;
        end;
    end;

    assert(v36, "invalid remote render delta");
    local v37;

    if p35 == p35 and p35 > (-1 / 0) then
        v37 = p35 < (1 / 0);
    else
        v37 = false;
    end;

    if v37 then
        v37 = p35 >= 0;
    end;

    assert(v37, "invalid remote clock time");

    if p33._anchorTick == nil then
        p33._lastMode = "Unanchored";
        p33._lastErrorTicks = 0;

        return nil, 0;
    end;

    local _hz = p33._hz;
    local _position = p33._position;

    if _position == nil then
        local v38 = math.max(p35 - p33._latestAtSeconds, 0) * p33._hz;
        p33._position = math.min(p33._latestTicks + p33._renderOffsetTicks - p33._spacingTicks - (0.005 * p33._hz + p33._bufferTicks) + v38, p33._latestTicks + p33._horizonTicks);
        p33._lastMode = "Anchored";
        p33._lastErrorTicks = 0;

        return p33:current();
    end;

    p33._frames = p33._frames + 1;
    local v39 = p34 or 0;
    local v40 = v39 * _hz;
    local v41 = _position + v40;
    local v42 = p33._latestTicks + p33._renderOffsetTicks - v41;

    if p33._maxBehindTicks < v42 then
        local v43;
        v41, v43 = rebase(p33, p35, v41);
        _position = _position - v43;
        p33._lastErrorTicks = 0;
        p33._lastMinMarginTicks = nil;
    else
        local v44 = lateArrivalKey(p33, p35);

        if v44 == nil then
            p33._lastMode = "FreeRun";
            p33._lastErrorTicks = 0;
            p33._lastMinMarginTicks = nil;
        else
            local v45 = v44 - (v41 - p35 * _hz);
            local v46 = v45 - (0.005 * p33._hz + p33._bufferTicks);
            p33._lastMinMarginTicks = v45;
            p33._lastErrorTicks = v46;
            local v47;

            if p33._spectator then
                v47 = p33._deepestLagTicks;
            else
                local _deepestLagTicks = p33._deepestLagTicks;
                local v48 = math.clamp(p33._jitterTicks, 0, 3) + 4;
                v47 = math.min(_deepestLagTicks, v48);
            end;

            local v49 = v46 < 0 and v47 <= v42 and 0 or v46;

            if v39 > 0 and v49 ~= 0 then
                local v50 = v49 * (1 - math.exp(-v39 / (v49 > 0 and 0.6 or 0.3)));
                v41 = v41 + math.clamp(v50, -0.06999999999999995 * v40, 0.06000000000000005 * v40);
            end;

            p33._lastMode = "Slew";
        end;
    end;

    local v51 = p33._latestTicks + p33._horizonTicks;

    if v51 < v41 then
        v41 = math.max(v51, _position);
        p33._lastMode = "Holding";
        p33._holdingFrames = p33._holdingFrames + 1;
    elseif v41 - p33._renderOffsetTicks > p33._latestTicks then
        if p33._lastMode ~= "Rebased" then
            p33._lastMode = "Extrapolating";
        end;

        p33._extrapolatingFrames = p33._extrapolatingFrames + 1;
    end;

    p33._lastRate = v40 <= 0 and 1 or (v41 - _position) / v40;
    p33._position = v41;

    return p33:current();
end;

function u1.current(p52) -- Line: 309
    -- upvalues: Serial (copy)
    local _anchorTick = p52._anchorTick;
    local _position = p52._position;

    if _anchorTick == nil or _position == nil then
        return nil, 0;
    end;

    local math_floor_ret = math.floor(_position);

    return Serial.addUInt32(_anchorTick, math_floor_ret), _position - math_floor_ret;
end;

function u1.diagnostics(p53) -- Line: 318
    -- upvalues: Serial (copy)
    local _hz = p53._hz;
    local _position = p53._position;
    local _lastMinMarginTicks = p53._lastMinMarginTicks;
    local table_freeze = table.freeze;
    local v54 = {
        Mode = p53._lastMode,
        DriftTicks = p53._lastErrorTicks,
        HardRebases = p53._hardRebases
    };
    local v55;

    if p53._anchorTick == nil then
        v55 = nil;
    else
        v55 = Serial.addUInt32(p53._anchorTick, p53._latestTicks);
    end;

    v54.LatestObservedTick = v55;
    v54.DelayMs = _position == nil and 0 or (p53._latestTicks + p53._renderOffsetTicks - _position) * 1000 / _hz;
    local v56;

    if _lastMinMarginTicks == nil then
        v56 = nil;
    else
        v56 = _lastMinMarginTicks * 1000 / _hz;
    end;

    v54.WindowMinMarginMs = v56;
    v54.TargetMarginMs = (0.005 * p53._hz + p53._bufferTicks) * 1000 / _hz;
    v54.WindowSamples = math.max(p53._windowTail - p53._windowHead + 1, 0);
    v54.BufferTicks = p53._bufferTicks;
    v54.Rate = p53._lastRate;
    v54.Frames = p53._frames;
    v54.ExtrapolatingFrames = p53._extrapolatingFrames;
    v54.HoldingFrames = p53._holdingFrames;

    return table_freeze(v54);
end;

return table.freeze(u1);