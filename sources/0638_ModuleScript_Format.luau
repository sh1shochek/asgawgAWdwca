-- Decompiled with Potassium's decompiler.

local u12 = {
    Number = function(p1: number) -- Line: 15, Name: Number
        local math_floor_ret = math.floor(p1);
        local math_max_ret = math.max(math_floor_ret, 0);

        return tostring(math_max_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end,

    Ratio = function(p2: number, p3: number) -- Line: 24, Name: Ratio
        if p3 <= 0 then
            return string.format("%.2f", p2);
        end;

        return string.format("%.2f", p2 / p3);
    end,

    Percent = function(p4: number, p5: number, p6: number?) -- Line: 33, Name: Percent
        if p5 <= 0 then
            return (p6 or 0) <= 0 and "0%" or string.format(`%.{p6}f%%`, 0);
        end;

        local v7 = p4 / p5 * 100;

        if (p6 or 0) > 0 then
            return string.format(`%.{p6}f%%`, v7);
        end;

        return string.format("%d%%", (math.floor(v7 + 0.5)));
    end,

    Decimal = function(p8: number, p9: number) -- Line: 47, Name: Decimal
        return string.format(`%.{p9}f`, p8);
    end,

    Signed = function(p10: number, p11: number) -- Line: 54, Name: Signed
        local string_format_ret = string.format(`%.{p11}f`, (math.abs(p10)));

        if p10 > 0 then
            return `+{string_format_ret}`;
        end;

        if p10 < 0 then
            return `-{string_format_ret}`;
        end;

        return string_format_ret;
    end
};

function u12.Money(p13: number) -- Line: 64
    -- upvalues: u12 (copy)
    return `${u12.Number(p13)}`;
end;

function u12.Share(p14: number, p15: number?) -- Line: 71
    if (p15 or 0) > 0 then
        return string.format(`%.{p15}f%%`, p14 * 100);
    end;

    return string.format("%d%%", (math.floor(p14 * 100 + 0.5)));
end;

function u12.TimePlayed(p16: number) -- Line: 81
    -- upvalues: u12 (copy)
    local math_floor_ret = math.floor(p16 / 60);
    local math_max_ret = math.max(math_floor_ret, 0);
    local math_floor_ret2 = math.floor(math_max_ret / 60);
    local v17 = math_max_ret % 60;

    if math_floor_ret2 <= 0 then
        return `{v17}M`;
    end;

    if math_floor_ret2 < 10 and v17 > 0 then
        return `{math_floor_ret2}HR {v17}M`;
    end;

    return `{u12.Number(math_floor_ret2)}HR`;
end;

function u12.Duration(p18: number) -- Line: 100
    local math_floor_ret = math.floor(p18);
    local math_max_ret = math.max(math_floor_ret, 0);

    return string.format("%02d:%02d", math.floor(math_max_ret / 60), math_max_ret % 60);
end;

function u12.DateTime(u19: number) -- Line: 108
    local success, result = pcall(function() -- Line: 109
        -- upvalues: u19 (copy)
        return DateTime.fromUnixTimestamp(u19):FormatLocalTime("MM/DD/YY , h:mm a", "en-us");
    end);

    if success and (typeof(result) == "string" and result ~= "") then
        return string.upper(result);
    end;

    return string.upper(os.date("%m/%d/%y , %I:%M %p", u19));
end;

function u12.MatchScore(p20: string, p21: number, p22: number) -- Line: 123
    local v23 = p20 == "Counter-Terrorists";
    local v24;

    if v23 then
        v24 = p21;
    else
        v24 = p22;
    end;

    if v23 then
        p21 = p22;
    end;

    return `<font color="{v23 and "rgb(165,183,212)" or "rgb(219,199,126)"}">{v24}</font> - <font color="{v23 and "rgb(219,199,126)" or "rgb(165,183,212)"}">{p21}</font>`;
end;

return u12;