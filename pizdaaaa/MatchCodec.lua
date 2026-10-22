-- ReplicatedStorage.Shared.Utility.MatchCodec
-- Script path: ReplicatedStorage.Shared.Utility.MatchCodec
-- Decompile time: 12.42 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local HttpService = game:GetService("HttpService");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;

local function NewWriter() -- Line: 26
    return {
        Length = 0,
        Buffer = buffer.create(64)
    };
end;

local function Ensure(p12: any, p13: number) -- Line: 30
    local v14 = p12.Length + p13;
    local buffer_len_ret = buffer.len(p12.Buffer);

    if v14 <= buffer_len_ret then
        return;
    end;

    while buffer_len_ret < v14 do
        buffer_len_ret = buffer_len_ret * 2;
    end;

    local buffer_create_ret = buffer.create(buffer_len_ret);
    buffer.copy(buffer_create_ret, 0, p12.Buffer, 0, p12.Length);
    p12.Buffer = buffer_create_ret;
end;

local function WriteU8(p15: any, p16: number) -- Line: 48
    -- upvalues: Ensure (copy)
    Ensure(p15, 1);
    buffer.writeu8(p15.Buffer, p15.Length, p16);
    p15.Length = p15.Length + 1;
end;

local function WriteU16(p17: any, p18: number) -- Line: 54
    -- upvalues: Ensure (copy)
    Ensure(p17, 2);
    buffer.writeu16(p17.Buffer, p17.Length, p18);
    p17.Length = p17.Length + 2;
end;

local function WriteChunk(p19: any, p20: buffer) -- Line: 60
    -- upvalues: Ensure (copy)
    local buffer_len_ret = buffer.len(p20);
    Ensure(p19, 2);
    buffer.writeu16(p19.Buffer, p19.Length, buffer_len_ret);
    p19.Length = p19.Length + 2;
    Ensure(p19, buffer_len_ret);
    buffer.copy(p19.Buffer, p19.Length, p20, 0, buffer_len_ret);
    p19.Length = p19.Length + buffer_len_ret;
end;

local function Finish(p21) -- Line: 70
    local buffer_create_ret = buffer.create(p21.Length);
    buffer.copy(buffer_create_ret, 0, p21.Buffer, 0, p21.Length);

    return buffer_create_ret;
end;

local function NewReader(p22: buffer) -- Line: 77
    return {
        Offset = 0,
        Buffer = p22
    };
end;

local function ReadU8(p23) -- Line: 81
    local buffer_readu8_ret = buffer.readu8(p23.Buffer, p23.Offset);
    p23.Offset = p23.Offset + 1;

    return buffer_readu8_ret;
end;

local function ReadU16(p24) -- Line: 88
    local buffer_readu16_ret = buffer.readu16(p24.Buffer, p24.Offset);
    p24.Offset = p24.Offset + 2;

    return buffer_readu16_ret;
end;

local function ReadChunk(p25) -- Line: 95
    local buffer_readu16_ret = buffer.readu16(p25.Buffer, p25.Offset);
    p25.Offset = p25.Offset + 2;
    local buffer_create_ret = buffer.create(buffer_readu16_ret);
    buffer.copy(buffer_create_ret, 0, p25.Buffer, p25.Offset, buffer_readu16_ret);
    p25.Offset = p25.Offset + buffer_readu16_ret;

    return buffer_create_ret;
end;

local function PackRows(p26, p27, p28) -- Line: 107
    -- upvalues: Ensure (copy), WriteChunk (copy)
    Ensure(p26, 2);
    buffer.writeu16(p26.Buffer, p26.Length, #p28);
    p26.Length = p26.Length + 2;

    for _, v in p28 do
        WriteChunk(p26, p27:PackScheme(v));
    end;
end;

local function UnpackRows(p29, p30) -- Line: 115
    local buffer_readu16_ret = buffer.readu16(p29.Buffer, p29.Offset);
    p29.Offset = p29.Offset + 2;
    local table_create_ret = table.create(buffer_readu16_ret);

    for i = 1, buffer_readu16_ret do
        local buffer_readu16_ret2 = buffer.readu16(p29.Buffer, p29.Offset);
        p29.Offset = p29.Offset + 2;
        local buffer_create_ret = buffer.create(buffer_readu16_ret2);
        buffer.copy(buffer_create_ret, 0, p29.Buffer, p29.Offset, buffer_readu16_ret2);
        p29.Offset = p29.Offset + buffer_readu16_ret2;
        table.insert(table_create_ret, p30:UnpackScheme(buffer_create_ret));
        local _ = i;
    end;

    return table_create_ret;
end;

local function ScoreToRow(p31) -- Line: 128
    return {
        UserId = tostring(p31.UserId),
        Kills = p31.Kills or 0,
        Deaths = p31.Deaths or 0,
        Assists = p31.Assists or 0,
        HeadshotPct = p31.HeadshotPct or 0,
        Money = p31.Money or 0
    };
end;

local function EventToRow(p32) -- Line: 139
    -- upvalues: u2 (ref)
    local Assist = p32.Assist;
    local v33 = nil;

    if p32.Weapon then
        if typeof(p32.Weapon) == "number" then
            v33 = p32.Weapon;
        elseif u2 and u2.WeaponsNum then
            v33 = u2.WeaponsNum[p32.Weapon];
        end;
    end;

    local v34 = {
        Type = p32.Type,
        Time = p32.Time or 0
    };
    local v35;

    if p32.Killer then
        v35 = tostring(p32.Killer) or nil;
    else
        v35 = nil;
    end;

    v34.Killer = v35;
    local v36;

    if p32.Victim then
        v36 = tostring(p32.Victim) or nil;
    else
        v36 = nil;
    end;

    v34.Victim = v36;
    local v37;

    if Assist and Assist ~= 0 then
        v37 = tostring(Assist) or nil;
    else
        v37 = nil;
    end;

    v34.Assist = v37;
    v34.Weapon = v33;
    v34.Headshot = p32.Headshot or false;
    v34.Penetration = p32.Penetration or false;
    local v38;

    if p32.Planter then
        v38 = tostring(p32.Planter) or nil;
    else
        v38 = nil;
    end;

    v34.Planter = v38;
    local v39;

    if p32.Defuser then
        v39 = tostring(p32.Defuser) or nil;
    else
        v39 = nil;
    end;

    v34.Defuser = v39;
    v34.Winner = p32.Winner or 0;
    v34.Reason = p32.Reason and tostring(p32.Reason) or nil;

    return v34;
end;

function v1.PackAnalytics(p40) -- Line: 168
    -- upvalues: PackRows (copy), u3 (ref), u4 (ref), HttpService (copy), u5 (ref)
    local v41 = {
        Length = 0,
        Buffer = buffer.create(64)
    };
    PackRows(v41, u3, p40.WeaponStats or {});
    PackRows(v41, u4, p40.GamemodePlaytime or {});
    local v42 = {};

    if p40.Matches and typeof(p40.Matches) == "table" then
        for _, v in pairs(p40.Matches) do
            local v43 = nil;
            local v44;

            if typeof(v) == "table" then
                v44 = table.clone(v);
                v44.Time = v44.Time or (v44.Timestamp or os.time());
            elseif typeof(v) == "string" then
                local v45;

                if v:sub(1, 1) == "{" then
                    local v46;
                    v46, v45 = pcall(HttpService.JSONDecode, HttpService, v);

                    if v46 and typeof(v45) == "table" then
                        v45.Time = v45.Time or (v45.Timestamp or os.time());
                    else
                        v45 = v43;
                    end;
                else
                    v45 = v43;
                end;

                v44 = v45 or {
                    Gamemode = 1,
                    Map = 1,
                    Result = 1,
                    Kills = 0,
                    Deaths = 0,
                    Assists = 0,
                    Score = 0,
                    CTScore = 0,
                    TScore = 0,
                    Index = tonumber(v) or 0,
                    Time = os.time()
                };
            else
                v44 = typeof(v) == "number" and {
                    Gamemode = 1,
                    Map = 1,
                    Result = 1,
                    Kills = 0,
                    Deaths = 0,
                    Assists = 0,
                    Score = 0,
                    CTScore = 0,
                    TScore = 0,
                    Index = v,
                    Time = os.time()
                } or v43;
            end;

            if v44 then
                v44.Index = v44.Index or 0;
                v44.Gamemode = v44.Gamemode or 1;
                v44.Map = v44.Map or 1;
                v44.Time = v44.Time or os.time();
                v44.Result = v44.Result or 1;
                v44.Kills = v44.Kills or 0;
                v44.Deaths = v44.Deaths or 0;
                v44.Assists = v44.Assists or 0;
                v44.Score = v44.Score or 0;
                v44.CTScore = v44.CTScore or 0;
                v44.TScore = v44.TScore or 0;
                table.insert(v42, v44);
            end;
        end;
    end;

    PackRows(v41, u5, v42);
    local buffer_create_ret = buffer.create(v41.Length);
    buffer.copy(buffer_create_ret, 0, v41.Buffer, 0, v41.Length);

    return buffer_create_ret;
end;

function v1.UnpackAnalytics(p47: buffer) -- Line: 241
    -- upvalues: UnpackRows (copy), u3 (ref), u4 (ref), u5 (ref)
    local v48 = {
        Offset = 0,
        Buffer = p47
    };

    return {
        WeaponStats = UnpackRows(v48, u3),
        GamemodePlaytime = UnpackRows(v48, u4),
        Matches = UnpackRows(v48, u5)
    };
end;

function v1.PackMatch(p49) -- Line: 251
    -- upvalues: WriteChunk (copy), u6 (ref), Ensure (copy), u7 (ref), PackRows (copy), u8 (ref), u9 (ref), u10 (ref), ScoreToRow (copy), u11 (ref), EventToRow (copy)
    local v50 = {
        Length = 0,
        Buffer = buffer.create(64)
    };
    WriteChunk(v50, u6:PackScheme({
        Index = p49.Index,
        Gamemode = p49.Gamemode,
        Map = p49.Map,
        Timestamp = p49.Timestamp,
        Duration = p49.Duration,
        Winner = p49.Winner,
        CTScore = p49.CTScore,
        TScore = p49.TScore
    }));
    local Players = p49.Players;
    Ensure(v50, 2);
    buffer.writeu16(v50.Buffer, v50.Length, #Players);
    v50.Length = v50.Length + 2;

    for _, v in Players do
        local v51 = v.HitDistribution or {};
        WriteChunk(v50, u7:PackScheme({
            UserId = tostring(v.UserId),
            Name = v.Name,
            Team = v.Team,
            Won = v.Won,
            Kills = v.Kills,
            Deaths = v.Deaths,
            Assists = v.Assists,
            Headshots = v.Headshots,
            Damage = v.Damage,
            DamageTaken = v.DamageTaken,
            Shots = v.Shots,
            Hits = v.Hits,
            MVPs = v.MVPs,
            Score = v.Score,
            LongestKillstreak = v.LongestKillstreak,
            BombPlants = v.BombPlants,
            BombDefuses = v.BombDefuses,
            MeleeKills = v.MeleeKills,
            ADR = v.ADR,
            HSP = v.HSP,
            MatchClass = v.MatchClass,
            MatchClassInfo = v.MatchClassInfo,
            Hit1 = v51[1] or 0,
            Hit2 = v51[2] or 0,
            Hit3 = v51[3] or 0,
            Hit4 = v51[4] or 0
        }));
        PackRows(v50, u8, v.WeaponStats);
        local v52 = v.RoundAccuracy or {};
        Ensure(v50, 2);
        buffer.writeu16(v50.Buffer, v50.Length, #v52);
        v50.Length = v50.Length + 2;

        for _, v2 in v52 do
            local math_clamp_ret = math.clamp(v2, 0, 100);
            Ensure(v50, 1);
            buffer.writeu8(v50.Buffer, v50.Length, math_clamp_ret);
            v50.Length = v50.Length + 1;
        end;
    end;

    local v53 = p49.Rounds or {};
    local v54 = #v53;
    Ensure(v50, 2);
    buffer.writeu16(v50.Buffer, v50.Length, v54);
    v50.Length = v50.Length + 2;

    for i = 1, v54 do
        local v55 = v53[i];
        WriteChunk(v50, u9:PackScheme({
            Round = v55.Round,
            CTScore = v55.CTScore,
            TScore = v55.TScore,
            Winner = v55.Winner or 0,
            Reason = v55.Reason or ""
        }));
        local v56 = v55.Scoreboard or {};
        local v57 = #v56;
        Ensure(v50, 2);
        buffer.writeu16(v50.Buffer, v50.Length, v57);
        v50.Length = v50.Length + 2;
        local _ = i;

        for i2 = 1, v57 do
            WriteChunk(v50, u10:PackScheme((ScoreToRow(v56[i2]))));
            local _ = i2;
        end;

        local v58 = v55.Events or {};
        local v59 = #v58;
        Ensure(v50, 2);
        buffer.writeu16(v50.Buffer, v50.Length, v59);
        v50.Length = v50.Length + 2;

        for i2 = 1, v59 do
            WriteChunk(v50, u11:PackScheme((EventToRow(v58[i2]))));
            local _ = i2;
        end;
    end;

    local v60 = p49.ScoreOverTime or {};
    local v61 = #v60;
    Ensure(v50, 2);
    buffer.writeu16(v50.Buffer, v50.Length, v61);
    v50.Length = v50.Length + 2;

    for i = 1, v61 do
        local v62 = v60[i];
        local CT = v62.CT;
        Ensure(v50, 1);
        buffer.writeu8(v50.Buffer, v50.Length, CT);
        v50.Length = v50.Length + 1;
        local T = v62.T;
        Ensure(v50, 1);
        buffer.writeu8(v50.Buffer, v50.Length, T);
        v50.Length = v50.Length + 1;
        local _ = i;
    end;

    local buffer_create_ret = buffer.create(v50.Length);
    buffer.copy(buffer_create_ret, 0, v50.Buffer, 0, v50.Length);

    return buffer_create_ret;
end;

function v1.UnpackMatch(p63: buffer) -- Line: 365
    -- upvalues: u6 (ref), u7 (ref), UnpackRows (copy), u8 (ref), u9 (ref), u10 (ref), u11 (ref)
    if buffer.len(p63) == 0 then
        return nil;
    end;

    local v64 = {
        Offset = 0,
        Buffer = p63
    };
    local buffer_readu16_ret = buffer.readu16(v64.Buffer, v64.Offset);
    v64.Offset = v64.Offset + 2;
    local buffer_create_ret = buffer.create(buffer_readu16_ret);
    buffer.copy(buffer_create_ret, 0, v64.Buffer, v64.Offset, buffer_readu16_ret);
    v64.Offset = v64.Offset + buffer_readu16_ret;
    local v65 = u6:UnpackScheme(buffer_create_ret);
    local buffer_readu16_ret2 = buffer.readu16(v64.Buffer, v64.Offset);
    v64.Offset = v64.Offset + 2;
    local table_create_ret = table.create(buffer_readu16_ret2);

    for i = 1, buffer_readu16_ret2 do
        local buffer_readu16_ret3 = buffer.readu16(v64.Buffer, v64.Offset);
        v64.Offset = v64.Offset + 2;
        local buffer_create_ret2 = buffer.create(buffer_readu16_ret3);
        buffer.copy(buffer_create_ret2, 0, v64.Buffer, v64.Offset, buffer_readu16_ret3);
        v64.Offset = v64.Offset + buffer_readu16_ret3;
        local v66 = u7:UnpackScheme(buffer_create_ret2);
        v66.HitDistribution = {
            v66.Hit1,
            v66.Hit2,
            v66.Hit3,
            v66.Hit4
        };
        v66.WeaponStats = UnpackRows(v64, u8);
        local buffer_readu16_ret4 = buffer.readu16(v64.Buffer, v64.Offset);
        v64.Offset = v64.Offset + 2;
        local table_create_ret2 = table.create(buffer_readu16_ret4);
        local _ = i;

        for i2 = 1, buffer_readu16_ret4 do
            local buffer_readu8_ret = buffer.readu8(v64.Buffer, v64.Offset);
            v64.Offset = v64.Offset + 1;
            table.insert(table_create_ret2, buffer_readu8_ret);
            local _ = i2;
        end;

        v66.RoundAccuracy = table_create_ret2;
        table.insert(table_create_ret, v66);
    end;

    v65.Players = table_create_ret;
    local buffer_readu16_ret3 = buffer.readu16(v64.Buffer, v64.Offset);
    v64.Offset = v64.Offset + 2;
    local table_create_ret2 = table.create(buffer_readu16_ret3);

    for i = 1, buffer_readu16_ret3 do
        local buffer_readu16_ret4 = buffer.readu16(v64.Buffer, v64.Offset);
        v64.Offset = v64.Offset + 2;
        local buffer_create_ret2 = buffer.create(buffer_readu16_ret4);
        buffer.copy(buffer_create_ret2, 0, v64.Buffer, v64.Offset, buffer_readu16_ret4);
        v64.Offset = v64.Offset + buffer_readu16_ret4;
        local v67 = u9:UnpackScheme(buffer_create_ret2);
        v67.Scoreboard = UnpackRows(v64, u10);
        local buffer_readu16_ret5 = buffer.readu16(v64.Buffer, v64.Offset);
        v64.Offset = v64.Offset + 2;
        local table_create_ret3 = table.create(buffer_readu16_ret5);
        local _ = i;

        for i2 = 1, buffer_readu16_ret5 do
            local buffer_readu16_ret6 = buffer.readu16(v64.Buffer, v64.Offset);
            v64.Offset = v64.Offset + 2;
            local buffer_create_ret3 = buffer.create(buffer_readu16_ret6);
            buffer.copy(buffer_create_ret3, 0, v64.Buffer, v64.Offset, buffer_readu16_ret6);
            v64.Offset = v64.Offset + buffer_readu16_ret6;
            table.insert(table_create_ret3, u11:UnpackScheme(buffer_create_ret3));
            local _ = i2;
        end;

        v67.Events = table_create_ret3;
        table.insert(table_create_ret2, v67);
    end;

    v65.Rounds = table_create_ret2;
    local buffer_readu16_ret4 = buffer.readu16(v64.Buffer, v64.Offset);
    v64.Offset = v64.Offset + 2;
    local table_create_ret3 = table.create(buffer_readu16_ret4);

    for i = 1, buffer_readu16_ret4 do
        local v68 = {};
        local buffer_readu8_ret = buffer.readu8(v64.Buffer, v64.Offset);
        v64.Offset = v64.Offset + 1;
        v68.CT = buffer_readu8_ret;
        local buffer_readu8_ret2 = buffer.readu8(v64.Buffer, v64.Offset);
        v64.Offset = v64.Offset + 1;
        v68.T = buffer_readu8_ret2;
        table.insert(table_create_ret3, v68);
        local _ = i;
    end;

    v65.ScoreOverTime = table_create_ret3;

    return v65;
end;

function v1.Init(p69) -- Line: 433
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref)
    u2 = p69:GetModule("Enums");
    local Module = p69:GetModule("BufferScheme");
    u3 = Module.new("AnalyticsWeaponRow", {
        Weapon = "u8",
        Kills = "u32",
        Shots = "u32",
        Hits = "u32"
    });
    u4 = Module.new("AnalyticsGamemodeRow", {
        Gamemode = "u8",
        Time = "u32"
    });
    u5 = Module.new(
        "AnalyticsSummaryRow",
        {
            Index = "u32",
            Gamemode = "u8",
            Map = "u8",
            Time = "u32",
            Result = "u8",
            Kills = "u16",
            Deaths = "u16",
            Assists = "u16",
            Score = "u16",
            CTScore = "u8",
            TScore = "u8"
        }
    );
    u6 = Module.new(
        "MatchHeader",
        {
            Index = "u32",
            Gamemode = "u8",
            Map = "u8",
            Timestamp = "u32",
            Duration = "u16",
            Winner = "u8",
            CTScore = "u8",
            TScore = "u8"
        }
    );
    u7 = Module.new(
        "MatchPlayerRow",
        {
            Won = "boolean",
            UserId = "string",
            Name = "string",
            Team = "u8",
            Kills = "u16",
            Deaths = "u16",
            Assists = "u16",
            Headshots = "u16",
            Damage = "u32",
            DamageTaken = "u32",
            Shots = "u16",
            Hits = "u16",
            MVPs = "u8",
            Score = "u16",
            LongestKillstreak = "u8",
            BombPlants = "u8",
            BombDefuses = "u8",
            MeleeKills = "u8",
            ADR = "u16",
            HSP = "u8",
            MatchClass = "u8",
            MatchClassInfo = "u32",
            Hit1 = "u16",
            Hit2 = "u16",
            Hit3 = "u16",
            Hit4 = "u16"
        }
    );
    u8 = Module.new(
        "MatchWeaponRow",
        {
            Weapon = "u8",
            Kills = "u16",
            Deaths = "u16",
            Assists = "u16",
            Headshots = "u16",
            Shots = "u16",
            Hits = "u16",
            Damage = "u32"
        }
    );
    u9 = Module.new(
        "MatchRoundHeader",
        {
            Round = "u8",
            CTScore = "u8",
            TScore = "u8",
            Winner = "u8",
            Reason = "string"
        }
    );
    u10 = Module.new(
        "MatchScoreRow",
        {
            UserId = "string",
            Kills = "u8",
            Deaths = "u8",
            Assists = "u8",
            HeadshotPct = "u8",
            Money = "u16"
        }
    );
    u11 = Module.new(
        "MatchEventRow",
        {
            Headshot = "boolean",
            Penetration = "boolean",
            Type = "u8",
            Time = "u16",
            Killer = "string",
            Victim = "string",
            Assist = "string",
            Weapon = "u8",
            Planter = "string",
            Defuser = "string",
            Winner = "u8",
            Reason = "string"
        }
    );
end;

return v1;