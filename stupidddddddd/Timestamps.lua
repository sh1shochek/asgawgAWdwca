-- ReplicatedStorage.Interface.Screens.Menu.Store.Timestamps
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Store.Timestamps
-- Decompile time: 0.82 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration)
local u11 = {}

local function ParseDateTimerTimestamp(a1) -- Line: 22 -- upvalues: u11 (val)
    local v1
    local v2 = ("%*:%*"):format(typeof(a1), a1)
    local v3 = u11[v2]
    if v3 ~= nil then
        if v3 == false then
            return nil
        end
        return v3
    end
    local UnixTimestamp = nil
    if typeof(a1) ~= "number" then
        v1 = tonumber(a1)
        if not v1 then
            local success, result = pcall(function() -- Line: 38 -- upvalues: a1 (val)
                return DateTime.fromIsoDate(a1)
            end)
            if success and result then
                UnixTimestamp = result.UnixTimestamp
            end
        else
            UnixTimestamp = v1
        end
    else
        UnixTimestamp = a1
    end
    if not UnixTimestamp then
        u11[v2] = false
        return nil
    end
    v1 = math.floor(if not (UnixTimestamp > 10000000000) then UnixTimestamp else UnixTimestamp / 1000)
    u11[v2] = v1
    return v1
end

function v1.NormalizeUnixTimestamp(a1) -- Line: 16 -- types: a1: number
    return (math.floor(if not (a1 > 10000000000) then a1 else a1 / 1000))
end

function v1.ConvertDateToTimer(a1, a2) -- Line: 59
    -- upvalues: ParseDateTimerTimestamp (val), FormatDuration (val)
    local v1 = ParseDateTimerTimestamp(a1)
    if not v1 then
        return "00:00:00:00"
    end
    return FormatDuration(v1 - math.floor(a2 or math.floor((workspace:GetServerTimeNow()))), "Always")
end

return v1