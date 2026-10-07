-- ReplicatedStorage.MovementV2.Client.RemoteClock
-- Script path: ReplicatedStorage.MovementV2.Client.RemoteClock
-- Decompile time: 5.00 ms

local Config = require(script.Parent.Parent.Config)
local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
local u18 = {}
u18.__index = u18

local function isFinite(a1) -- Line: 84 -- types: a1: number
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a1 > (-1 / 0) then
            v1 = a1 < (1 / 0)
        end
    end
    return v1
end

function u18.new(a1, a2) -- Line: 88 -- upvalues: Config (val), u18 (val) -- types: a2: boolean?
    assert(type(a1) == "table", "derived config is required")
    local v1 = math.max(a1.RemoteSnapshotEveryTicks, 1)
    local v2 = math.max(v1 * 2, a1.RemoteHistoryTicks - a1.RenderInterpolationTicks - v1)
    return (setmetatable({
        _latestTicks = 0,
        _latestAtSeconds = 0,
        _windowHead = 1,
        _windowTail = 0,
        _jitterTicks = 0,
        _lateKeyDirty = false,
        _lastMode = "Unanchored",
        _lastErrorTicks = 0,
        _lastRate = 1,
        _hardRebases = 0,
        _frames = 0,
        _extrapolatingFrames = 0,
        _holdingFrames = 0,
        _config = a1,
        _hz = a1.SimulationHz,
        _renderOffsetTicks = a1.RenderInterpolationTicks,
        _horizonTicks = a1.RenderInterpolationTicks + a1.MaxRemoteExtrapolationTicks,
        _maxBehindTicks = v2,
        _deepestLagTicks = v2 * 0.75,
        _spacingTicks = a1.SimulationHz * Config.PolicySeconds.RemoteSnapshotPeriod,
        _spectator = a2 == true,
        _bufferTicks = if not a2 then 0 else 2,
        _windowKeys = {},
        _windowTimes = {},
        _sortScratch = {},
    }, u18))
end

function u18.setSpectator(a1, a2) -- Line: 127 -- types: a1: table, a2: boolean
    a1._spectator = a2
    a1._bufferTicks = if not a2 then 0 else 2
end

local function targetTicks(a1) -- Line: 133
    return 0.005 * a1._hz + a1._bufferTicks
end

local function clearWindow(a1) -- Line: 137
    table.clear(a1._windowKeys)
    table.clear(a1._windowTimes)
    a1._windowHead = 1
    a1._windowTail = 0
    a1._lateKey = nil
    a1._jitterTicks = 0
    a1._lateKeyDirty = false
end

local function pushMargin(a1, a2, a3) -- Line: 147 -- types: a2: number, a3: number
    local v1 = a1._windowTail + 1
    a1._windowKeys[v1] = a2
    a1._windowTimes[v1] = a3
    a1._windowTail = v1
    a1._lateKeyDirty = true
end

local function lateArrivalKey(a1, a2) -- Line: 156 -- types: a2: number
    local _windowKeys = a1._windowKeys
    local _windowTimes = a1._windowTimes
    local _windowHead = a1._windowHead
    local v1 = a2 - 1.5
    while _windowHead <= a1._windowTail do
        if not (_windowTimes[_windowHead] < v1) then
            break
        end
        _windowKeys[_windowHead] = nil
        _windowTimes[_windowHead] = nil
        _windowHead = _windowHead + 1
        a1._lateKeyDirty = true
    end
    if a1._windowTail < _windowHead then
        a1._windowHead = 1
        a1._windowTail = 0
        a1._lateKey = nil
        return nil
    end
    a1._windowHead = _windowHead
    if a1._lateKeyDirty then
        local _sortScratch = a1._sortScratch
        table.clear(_sortScratch)
        table.move(_windowKeys, _windowHead, a1._windowTail, 1, _sortScratch)
        table.sort(_sortScratch)
        local v2 = _sortScratch[math.floor(#_sortScratch * 0.05) + 1]
        a1._lateKey = v2
        a1._jitterTicks = _sortScratch[math.floor(#_sortScratch * 0.5) + 1] - v2
        a1._lateKeyDirty = false
    end
    return a1._lateKey
end

local function settledPosition(a1, a2) -- Line: 187 -- types: a2: number
    return (math.min(
        a1._latestTicks + a1._renderOffsetTicks - a1._spacingTicks - (0.005 * a1._hz + a1._bufferTicks) + (math.max(a2 - a1._latestAtSeconds, 0)) * a1._hz,
        a1._latestTicks + a1._horizonTicks
    ))
end

function u18.observe(a1, a2, a3) -- Line: 193 -- upvalues: Serial (val) -- types: a1: table, a2: number, a3: number
    assert(Serial.isUInt32(a2), "invalid remote server tick")
    local v1 = false
    if a3 == a3 then
        v1 = false
        if a3 > (-1 / 0) then
            v1 = a3 < (1 / 0)
        end
    end
    if v1 then
        v1 = a3 >= 0
    end
    assert(v1, "invalid observation time")
    local _anchorTick = a1._anchorTick
    if _anchorTick == nil then
        a1._anchorTick = a2
        a1._latestTicks = 0
        a1._latestAtSeconds = a3
        return true
    end
    v1 = Serial.deltaUInt32(a2, _anchorTick)
    if v1 <= a1._latestTicks then
        return false
    end
    local v2 = a1._latestTicks + a1._renderOffsetTicks - a3 * a1._hz
    local v3 = a1._windowTail + 1
    a1._windowKeys[v3] = v2
    a1._windowTimes[v3] = a3
    a1._windowTail = v3
    a1._lateKeyDirty = true
    a1._latestTicks = v1
    a1._latestAtSeconds = a3
    return true
end

local function rebase(a1, a2, a3) -- Line: 215 -- upvalues: Serial (val) -- types: a2: number, a3: number
    local v1 = assert(a1._anchorTick)
    local _latestTicks = a1._latestTicks
    a1._anchorTick = Serial.addUInt32(v1, _latestTicks)
    a1._latestTicks = 0
    table.clear(a1._windowKeys)
    table.clear(a1._windowTimes)
    a1._windowHead = 1
    a1._windowTail = 0
    a1._lateKey = nil
    a1._jitterTicks = 0
    a1._lateKeyDirty = false
    a1._hardRebases = a1._hardRebases + 1
    a1._lastMode = "Rebased"
    local v2 = (math.max(a2 - a1._latestAtSeconds, 0)) * a1._hz
    return (math.max(math.min(
        a1._latestTicks + a1._renderOffsetTicks - a1._spacingTicks - (0.005 * a1._hz + a1._bufferTicks) + v2,
        a1._latestTicks + a1._horizonTicks
    ), a3 - _latestTicks)), _latestTicks
end

function u18.advance(a1, a2, a3) -- Line: 227
    -- upvalues: rebase (val), lateArrivalKey (val)
    local v1, v2, v3, v4
    local v5 = true
    if a2 ~= nil then
        v5 = false
        if a2 == a2 then
            v5 = false
            if a2 > (-1 / 0) then
                v5 = a2 < (1 / 0)
            end
        end
        if v5 then
            v5 = a2 >= 0
        end
    end
    assert(v5, "invalid remote render delta")
    v5 = false
    if a3 == a3 then
        v5 = false
        if a3 > (-1 / 0) then
            v5 = a3 < (1 / 0)
        end
    end
    if v5 then
        v5 = a3 >= 0
    end
    assert(v5, "invalid remote clock time")
    if a1._anchorTick == nil then
        a1._lastMode = "Unanchored"
        a1._lastErrorTicks = 0
        return nil, 0
    end
    local _hz = a1._hz
    local _position = a1._position
    if _position == nil then
        v3 = (math.max(a3 - a1._latestAtSeconds, 0)) * a1._hz
        a1._position = math.min(
            a1._latestTicks + a1._renderOffsetTicks - a1._spacingTicks - (0.005 * a1._hz + a1._bufferTicks) + v3,
            a1._latestTicks + a1._horizonTicks
        )
        a1._lastMode = "Anchored"
        a1._lastErrorTicks = 0
        return a1:current()
    end
    a1._frames = a1._frames + 1
    local v6 = a2 or 0
    v3 = v6 * _hz
    local v7 = _position + v3
    local v8 = a1._latestTicks + a1._renderOffsetTicks - v7
    if not (a1._maxBehindTicks < v8) then
        v4 = lateArrivalKey(a1, a3)
        if v4 ~= nil then
            v1 = v4 - (v7 - a3 * _hz)
            v2 = v1 - (0.005 * a1._hz + a1._bufferTicks)
            a1._lastMinMarginTicks = v1
            a1._lastErrorTicks = v2
            local _deepestLagTicks = if not a1._spectator then math.min(a1._deepestLagTicks, (math.clamp(a1._jitterTicks, 0, 3)) + 4) else a1._deepestLagTicks
            if v2 < 0 and _deepestLagTicks <= v8 then
                v2 = 0
            end
            if v6 > 0 and v2 ~= 0 then
                local v9 = if not (v2 > 0) then 0.3 else 0.6
                v7 = v7 + math.clamp(v2 * (1 - (math.exp(-v6 / v9))), -0.06999999999999995 * v3, 0.06000000000000005 * v3)
            end
            a1._lastMode = "Slew"
        else
            a1._lastMode = "FreeRun"
            a1._lastErrorTicks = 0
            a1._lastMinMarginTicks = nil
        end
    else
        v1, v2 = rebase(a1, a3, v7)
        v7 = v1
        _position = _position - v2
        a1._lastErrorTicks = 0
        a1._lastMinMarginTicks = nil
    end
    v4 = a1._latestTicks + a1._horizonTicks
    if v4 < v7 then
        v7 = math.max(v4, _position)
        a1._lastMode = "Holding"
        a1._holdingFrames = a1._holdingFrames + 1
    elseif a1._latestTicks < v7 - a1._renderOffsetTicks then
        if a1._lastMode ~= "Rebased" then
            a1._lastMode = "Extrapolating"
        end
        a1._extrapolatingFrames = a1._extrapolatingFrames + 1
    end
    a1._lastRate = if not (v3 > 0) then 1 else (v7 - _position) / v3
    a1._position = v7
    return a1:current()
end

function u18:current() -- Line: 309 -- upvalues: Serial (val)
    local _anchorTick = self._anchorTick
    local _position = self._position
    if _anchorTick ~= nil and _position ~= nil then
        local v1 = math.floor(_position)
        return (Serial.addUInt32(_anchorTick, v1)), _position - v1
    end
    return nil, 0
end

function u18.diagnostics(a1) -- Line: 318 -- upvalues: Serial (val)
    local _hz = a1._hz
    local _position = a1._position
    local _lastMinMarginTicks = a1._lastMinMarginTicks
    return table.freeze({
        Mode = a1._lastMode,
        DriftTicks = a1._lastErrorTicks,
        HardRebases = a1._hardRebases,
        LatestObservedTick = if a1._anchorTick ~= nil then Serial.addUInt32(a1._anchorTick, a1._latestTicks) else nil,
        DelayMs = if _position ~= nil then (a1._latestTicks + a1._renderOffsetTicks - _position) * 1000 / _hz else 0,
        WindowMinMarginMs = if _lastMinMarginTicks ~= nil then _lastMinMarginTicks * 1000 / _hz else nil,
        TargetMarginMs = (0.005 * a1._hz + a1._bufferTicks) * 1000 / _hz,
        WindowSamples = math.max(a1._windowTail - a1._windowHead + 1, 0),
        BufferTicks = a1._bufferTicks,
        Rate = a1._lastRate,
        Frames = a1._frames,
        ExtrapolatingFrames = a1._extrapolatingFrames,
        HoldingFrames = a1._holdingFrames,
    })
end

return table.freeze(u18)