-- ReplicatedStorage.Interface.Screens.Menu.Career.Format
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.Format
-- Decompile time: 1.42 ms

local u0 = {}

function u0.Number(a1) -- Line: 15 -- types: a1: number
    return (tostring((math.max(math.floor(a1), 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

function u0.Ratio(a1, a2) -- Line: 24 -- types: a1: number, a2: number
    if a2 <= 0 then
        return string.format("%.2f", a1)
    end
    return string.format("%.2f", a1 / a2)
end

function u0.Percent(a1, a2, a3) -- Line: 33 -- types: a1: number, a2: number, a3: number?
    if a2 <= 0 then
        if 0 < (a3 or 0) then
            return (string.format(("%%.%*f%%%%"):format(a3), 0))
        end
        return "0%"
    end
    local v1 = a1 / a2 * 100
    if 0 < (a3 or 0) then
        return string.format(("%%.%*f%%%%"):format(a3), v1)
    end
    return string.format("%d%%", (math.floor(v1 + 0.5)))
end

function u0.Decimal(a1, a2) -- Line: 47 -- types: a1: number, a2: number
    return string.format(("%%.%*f"):format(a2), a1)
end

function u0.Signed(a1, a2) -- Line: 54 -- types: a1: number, a2: number
    local v1 = string.format(("%%.%*f"):format(a2), (math.abs(a1)))
    if a1 > 0 then
        return (("+%*"):format(v1))
    end
    if a1 < 0 then
        return (("-%*"):format(v1))
    end
    return v1
end

function u0.Money(a1) -- Line: 64 -- upvalues: u0 (val) -- types: a1: number
    return (("$%*"):format((u0.Number(a1))))
end

function u0.Share(a1, a2) -- Line: 71 -- types: a1: number, a2: number?
    if 0 < (a2 or 0) then
        return string.format(("%%.%*f%%%%"):format(a2), a1 * 100)
    end
    return string.format("%d%%", (math.floor(a1 * 100 + 0.5)))
end

function u0.TimePlayed(a1) -- Line: 81 -- upvalues: u0 (val) -- types: a1: number
    local v1 = math.max(math.floor(a1 / 60), 0)
    local v2 = math.floor(v1 / 60)
    local v3 = v1 % 60
    if v2 <= 0 then
        return (("%*M"):format(v3))
    end
    if v2 < 10 and v3 > 0 then
        return (("%*HR %*M"):format(v2, v3))
    end
    return (("%*HR"):format((u0.Number(v2))))
end

function u0.Duration(a1) -- Line: 100 -- types: a1: number
    local v1 = math.max(math.floor(a1), 0)
    return string.format("%02d:%02d", math.floor(v1 / 60), v1 % 60)
end

function u0.DateTime(a1) -- Line: 108 -- types: a1: number
    local success, result = pcall(function() -- Line: 109 -- upvalues: a1 (val)
        return DateTime.fromUnixTimestamp(a1):FormatLocalTime("MM/DD/YY , h:mm a", "en-us")
    end)
    if success and typeof(result) == "string" and result ~= "" then
        return string.upper(result)
    end
    return string.upper(os.date("%m/%d/%y , %I:%M %p", a1))
end

function u0.MatchScore(a1, a2, a3) -- Line: 123 -- types: a1: string, a2: number, a3: number
    local v1
    return (("<font color=\"%*\">%*</font> - <font color=\"%*\">%*</font>"):format(
        if not v1 then "rgb(219,199,126)" else "rgb(165,183,212)",
        if not (a1 == "Counter-Terrorists") then a3 else a2,
        if not v1 then "rgb(165,183,212)" else "rgb(219,199,126)",
        if not v1 then a2 else a3
    ))
end

return u0