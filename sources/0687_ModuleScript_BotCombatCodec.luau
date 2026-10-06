-- Decompiled with Potassium's decompiler.

local Serial = require(script.Parent.Serial);
local u1 = {};
local table_freeze_ret = table.freeze({
    Shoot = 1,
    Reload = 2,
    StartThrow = 3,
    Throw = 4,
    CancelThrow = 5
});
local table_freeze_ret2 = table.freeze({ "Shoot", "Reload", "StartThrow", "Throw", "CancelThrow" });
u1.Version = 1;
u1.MaxEvents = 8;
u1.MaxWireSize = 674;
u1.MaxEventAgeSeconds = 0.75;

local function finite(p2) -- Line: 31
    local v3;

    if type(p2) == "number" and (p2 == p2 and p2 > (-1 / 0)) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

function u1.validateEvent(p4) -- Line: 35
    -- upvalues: Serial (copy), table_freeze_ret (copy)
    if type(p4) == "table" and (Serial.isUInt32(p4.ActorId) and (p4.ActorId ~= 0 and (Serial.isNonZeroUInt16(p4.Generation) and (Serial.isUInt32(p4.WeaponRevision) and Serial.isUInt32(p4.Sequence))))) then
        local ServerTime = p4.ServerTime;
        local v5;

        if type(ServerTime) == "number" and (ServerTime == ServerTime and ServerTime > (-1 / 0)) then
            v5 = ServerTime < (1 / 0);
        else
            v5 = false;
        end;

        if v5 and (p4.ServerTime >= 0 and (type(p4.WeaponName) == "string" and (#p4.WeaponName >= 1 and #p4.WeaponName <= 48))) then
            if p4.Kind ~= "Shoot" then
                local v6;

                if table_freeze_ret[p4.Kind] == nil then
                    v6 = false;
                else
                    v6 = p4.Target == nil;
                end;

                return v6;
            end;

            local Target = p4.Target;
            local v7;

            if p4.Kind == "Shoot" and typeof(Target) == "Vector3" then
                local X = Target.X;

                if type(X) == "number" and (X == X and X > (-1 / 0)) then
                    v7 = X < (1 / 0);
                else
                    v7 = false;
                end;

                if v7 then
                    local Y = Target.Y;

                    if type(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
                        v7 = Y < (1 / 0);
                    else
                        v7 = false;
                    end;

                    if v7 then
                        local Z = Target.Z;

                        if type(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
                            v7 = Z < (1 / 0);
                        else
                            v7 = false;
                        end;

                        if v7 then
                            if math.abs(Target.X) <= 1000000 and math.abs(Target.Y) <= 1000000 then
                                v7 = math.abs(Target.Z) <= 1000000;
                            else
                                v7 = false;
                            end;
                        end;
                    end;
                end;
            else
                v7 = false;
            end;

            return v7;
        end;
    end;

    return false;
end;

function u1.encode(p8: table) -- Line: 65
    -- upvalues: u1 (copy), table_freeze_ret (copy)
    if type(p8) ~= "table" or (#p8 < 1 or #p8 > 8) then
        return nil, "InvalidEventCount";
    end;

    local v9 = 0;
    local v10 = 2;

    for i, v in p8 do
        if type(i) ~= "number" or (i % 1 ~= 0 or (i < 1 or (#p8 < i or not u1.validateEvent(v)))) then
            return nil, "InvalidEvent";
        end;

        v9 = v9 + 1;
        v10 = v10 + (#v.WeaponName + 24 + (v.Kind == "Shoot" and 12 or 0));
    end;

    if v9 ~= #p8 then
        return nil, "EventsNotDense";
    end;

    local buffer_create_ret = buffer.create(v10);
    buffer.writeu8(buffer_create_ret, 0, 1);
    buffer.writeu8(buffer_create_ret, 1, #p8);
    local v11 = 2;

    for _, v in p8 do
        buffer.writeu32(buffer_create_ret, v11, v.ActorId);
        buffer.writeu16(buffer_create_ret, v11 + 4, v.Generation);
        buffer.writeu32(buffer_create_ret, v11 + 6, v.WeaponRevision);
        buffer.writeu32(buffer_create_ret, v11 + 10, v.Sequence);
        buffer.writef64(buffer_create_ret, v11 + 14, v.ServerTime);
        buffer.writeu8(buffer_create_ret, v11 + 22, table_freeze_ret[v.Kind]);
        buffer.writeu8(buffer_create_ret, v11 + 23, #v.WeaponName);
        local v12 = v11 + 24;
        buffer.writestring(buffer_create_ret, v12, v.WeaponName);
        v11 = v12 + #v.WeaponName;

        if v.Kind == "Shoot" then
            local Target = v.Target;
            buffer.writef32(buffer_create_ret, v11, Target.X);
            buffer.writef32(buffer_create_ret, v11 + 4, Target.Y);
            buffer.writef32(buffer_create_ret, v11 + 8, Target.Z);
            v11 = v11 + 12;
        end;
    end;

    return buffer_create_ret, nil;
end;

function u1.decode(p13) -- Line: 112
    -- upvalues: u1 (copy), table_freeze_ret2 (copy)
    if typeof(p13) ~= "buffer" then
        return nil, "PayloadNotBuffer";
    end;

    local buffer_len_ret = buffer.len(p13);

    if buffer_len_ret < 2 or u1.MaxWireSize < buffer_len_ret then
        return nil, "InvalidPayloadSize";
    end;

    if buffer.readu8(p13, 0) ~= 1 then
        return nil, "VersionMismatch";
    end;

    local buffer_readu8_ret = buffer.readu8(p13, 1);

    if buffer_readu8_ret < 1 or buffer_readu8_ret > 8 then
        return nil, "InvalidEventCount";
    end;

    local table_create_ret = table.create(buffer_readu8_ret);
    local v14 = 2;

    for i = 1, buffer_readu8_ret do
        if buffer_len_ret < v14 + 24 then
            return nil, "TruncatedEvent";
        end;

        local buffer_readu8_ret2 = buffer.readu8(p13, v14 + 22);
        local buffer_readu8_ret3 = buffer.readu8(p13, v14 + 23);

        if table_freeze_ret2[buffer_readu8_ret2] == nil or (buffer_readu8_ret3 < 1 or buffer_readu8_ret3 > 48) or buffer_len_ret < v14 + 24 + buffer_readu8_ret3 + (buffer_readu8_ret2 == 1 and 12 or 0) then
            return nil, "InvalidEventBody";
        end;

        local v15 = {
            Target = nil,
            ActorId = buffer.readu32(p13, v14),
            Generation = buffer.readu16(p13, v14 + 4),
            WeaponRevision = buffer.readu32(p13, v14 + 6),
            Sequence = buffer.readu32(p13, v14 + 10),
            ServerTime = buffer.readf64(p13, v14 + 14),
            Kind = table_freeze_ret2[buffer_readu8_ret2],
            WeaponName = buffer.readstring(p13, v14 + 24, buffer_readu8_ret3)
        };
        v14 = v14 + (buffer_readu8_ret3 + 24);

        if buffer_readu8_ret2 == 1 then
            local buffer_readf32_ret = buffer.readf32(p13, v14);
            local buffer_readf32_ret2 = buffer.readf32(p13, v14 + 4);
            local buffer_readf32_ret3 = buffer.readf32(p13, v14 + 8);
            v15.Target = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
            v14 = v14 + 12;
        end;

        if not u1.validateEvent(v15) then
            return nil, "InvalidEvent";
        end;

        table_create_ret[#table_create_ret + 1] = v15;
        local _ = i;
    end;

    if v14 == buffer_len_ret then
        return table_create_ret, nil;
    end;

    return nil, "TrailingBytes";
end;

function u1.canPresent(p16: table, p17: any, p18: boolean, p19: number?, p20: number) -- Line: 173
    -- upvalues: u1 (copy), Serial (copy)
    if p18 then
        if p17 == nil then
            p18 = false;
        else
            p18 = not p17.Dead;

            if p18 then
                if p17.Health > 0 and (p16.ActorId == p17.ActorId and (p16.Generation == p17.Generation and (p16.WeaponName == p17.WeaponName and p16.WeaponRevision == p17.WeaponRevision))) then
                    if type(p20) == "number" and (p20 == p20 and p20 > (-1 / 0)) then
                        p18 = p20 < (1 / 0);
                    else
                        p18 = false;
                    end;

                    if p18 then
                        if p20 - p16.ServerTime >= -0.25 and p20 - p16.ServerTime <= u1.MaxEventAgeSeconds then
                            p18 = p19 == nil and true or Serial.isNewerUInt32(p16.Sequence, p19);
                        else
                            p18 = false;
                        end;
                    end;
                else
                    p18 = false;
                end;
            end;
        end;
    end;

    return p18;
end;

return table.freeze(u1);