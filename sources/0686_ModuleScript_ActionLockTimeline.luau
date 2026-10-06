-- Decompiled with Potassium's decompiler.

local Config = require(script.Parent.Config);
local Serial = require(script.Parent.Serial);
local u1 = {
    HistorySeconds = Config.PolicySeconds.PredictionReplay + 1
};
u1.MaxPoints = math.ceil(u1.HistorySeconds * Config.MaxSimulationHz) + 2;

function u1.new(p2: boolean?) -- Line: 15
    return {
        Revision = 0,
        Initial = p2 == true,
        Points = {}
    };
end;

function u1.isLockedAt(p3: table?, p4: number) -- Line: 19
    if p3 == nil then
        return false;
    end;

    local Points = p3.Points;

    for i = #Points, 1, -1 do
        local v5 = Points[i];

        if v5.ServerTime <= p4 then
            return v5.Locked;
        end;

        local _ = i;
    end;

    return p3.Initial;
end;

function u1.record(p6: table, p7: number, p8: boolean) -- Line: 33
    -- upvalues: u1 (copy), Serial (copy)
    local Points = p6.Points;
    local v9 = Points[#Points];
    local v10;

    if v9 == nil then
        v10 = p6.Initial;
    else
        v10 = v9.Locked;
    end;

    if v10 == p8 then
        return false;
    end;

    assert(v9 == nil and true or v9.ServerTime <= p7, "action locks must follow the authority clock");

    if v9 == nil or p7 ~= v9.ServerTime then
        Points[#Points + 1] = {
            ServerTime = p7,
            Locked = p8
        };
    else
        v9.Locked = p8;
    end;

    while #Points > 1 and Points[2].ServerTime <= p7 - u1.HistorySeconds do
        p6.Initial = assert(table.remove(Points, 1)).Locked;
    end;

    p6.Revision = Serial.addUInt32(p6.Revision, 1);
    assert(#Points <= u1.MaxPoints, "action locks must be coalesced once per world tick");

    return true;
end;

function u1.validate(p11) -- Line: 55
    -- upvalues: Serial (copy), u1 (copy)
    if type(p11) ~= "table" or (not Serial.isUInt32(p11.Revision) or type(p11.Initial) ~= "boolean") then
        return false;
    end;

    local Points = p11.Points;

    if type(Points) ~= "table" or #Points > u1.MaxPoints then
        return false;
    end;

    local v12 = (-1 / 0);

    for _, v in Points do
        if type(v) ~= "table" or type(v.Locked) ~= "boolean" then
            return false;
        end;

        local ServerTime = v.ServerTime;

        if type(ServerTime) ~= "number" or (ServerTime ~= ServerTime or (ServerTime < 0 or (ServerTime >= (1 / 0) or ServerTime <= v12))) then
            return false;
        end;

        v12 = ServerTime;
    end;

    return true;
end;

return table.freeze(u1);