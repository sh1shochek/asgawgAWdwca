-- ReplicatedStorage.MovementV2.ActionLockTimeline
-- Script path: ReplicatedStorage.MovementV2.ActionLockTimeline
-- Decompile time: 1.32 ms

local Config = require(script.Parent.Config)
local Serial = require(script.Parent.Serial)
local u10 = {}
u10.HistorySeconds = Config.PolicySeconds.PredictionReplay + 1
u10.MaxPoints = math.ceil(u10.HistorySeconds * Config.MaxSimulationHz) + 2

function u10.new(a1) -- Line: 15 -- types: a1: boolean?
    return {Revision = 0, Initial = a1 == true, Points = {}}
end

function u10.isLockedAt(a1, a2) -- Line: 19 -- types: a1: table?, a2: number
    local v1
    if a1 == nil then
        return false
    end
    local Points = a1.Points
    for i = #Points, 1, -1 do
        v1 = Points[i]
        if v1.ServerTime <= a2 then
            return v1.Locked
        end
    end
    return a1.Initial
end

function u10.record(a1, a2, a3) -- Line: 33
    -- upvalues: u10 (val), Serial (val)
    local Points = a1.Points
    local v1 = Points[#Points]
    local Locked = if v1 == nil then a1.Initial else v1.Locked
    if Locked == a3 then
        return false
    end
    local v2 = true
    if v1 ~= nil then
        v2 = v1.ServerTime <= a2
    end
    assert(v2, "action locks must follow the authority clock")
    if v1 == nil or a2 ~= v1.ServerTime then
        Points[#Points + 1] = {ServerTime = a2, Locked = a3}
    else
        v1.Locked = a3
    end
    local v3 = a2 - u10.HistorySeconds
    while #Points > 1 do
        if not (Points[2].ServerTime <= v3) then
            break
        end
        a1.Initial = assert((table.remove(Points, 1))).Locked
    end
    a1.Revision = Serial.addUInt32(a1.Revision, 1)
    assert(#Points <= u10.MaxPoints, "action locks must be coalesced once per world tick")
    return true
end

function u10.validate(a1) -- Line: 55 -- upvalues: Serial (val), u10 (val)
    if type(a1) == "table" and Serial.isUInt32(a1.Revision) and type(a1.Initial) == "boolean" then
        local Points = a1.Points
        if type(Points) == "table" then
            local v1 = #Points
            if not (u10.MaxPoints < v1) then
                local ServerTime
                v1 = (-1 / 0)
                for i, j in Points do
                    if type(j) == "table" and type(j.Locked) == "boolean" then
                        ServerTime = j.ServerTime
                        if type(ServerTime) == "number"
                            and ServerTime == ServerTime
                            and not (ServerTime < 0)
                            and not (ServerTime >= (1 / 0))
                            and not (ServerTime <= v1) then
                            continue
                        end
                        return false
                    end
                    return false
                end
                return true
            end
        end
        return false
    end
    return false
end

return table.freeze(u10)