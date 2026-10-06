-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration);
local u2 = {};

local function ParseDateTimerTimestamp(u3) -- Line: 22
    -- upvalues: u2 (copy)
    local v4 = `{typeof(u3)}:{u3}`;
    local v5 = u2[v4];

    if v5 ~= nil then
        if v5 == false then
            return nil;
        end;

        return v5;
    end;

    local v6 = nil;

    if typeof(u3) == "number" then
        v6 = u3;
    else
        local v7 = tonumber(u3);

        if v7 then
            v6 = v7;
        else
            local success, result = pcall(function() -- Line: 38
                -- upvalues: u3 (copy)
                return DateTime.fromIsoDate(u3);
            end);

            if success and result then
                v6 = result.UnixTimestamp;
            end;
        end;
    end;

    if not v6 then
        u2[v4] = false;

        return nil;
    end;

    if v6 > 10000000000 then
        v6 = v6 / 1000;
    end;

    local math_floor_ret = math.floor(v6);
    u2[v4] = math_floor_ret;

    return math_floor_ret;
end;

function v1.NormalizeUnixTimestamp(p8: number) -- Line: 16
    if p8 > 10000000000 then
        p8 = p8 / 1000;
    end;

    return math.floor(p8);
end;

function v1.ConvertDateToTimer(p9: any, p10: number?) -- Line: 59
    -- upvalues: ParseDateTimerTimestamp (copy), FormatDuration (copy)
    local v11 = ParseDateTimerTimestamp(p9);

    if not v11 then
        return "00:00:00:00";
    end;

    if not p10 then
        local ServerTimeNow = workspace:GetServerTimeNow();
        p10 = math.floor(ServerTimeNow);
    end;

    return FormatDuration(v11 - math.floor(p10), "Always");
end;

return v1;