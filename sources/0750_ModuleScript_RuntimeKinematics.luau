-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = setmetatable({}, {
    __mode = "k"
});

function u1.write(p3: userdata?, p4: vector, p5: boolean, p6: vector?) -- Line: 15
    -- upvalues: u2 (copy)
    if p3 == nil then
        return;
    end;

    local v7 = u2[p3];

    if v7 == nil then
        u2[p3] = {
            Velocity = p4,
            OnGround = p5,
            Position = p6
        };

        return;
    end;

    v7.Velocity = p4;
    v7.OnGround = p5;
    v7.Position = p6;
end;

function u1.clear(p8: userdata?) -- Line: 35
    -- upvalues: u2 (copy)
    if p8 ~= nil then
        u2[p8] = nil;
    end;
end;

function u1.read(p9: userdata?) -- Line: 41
    -- upvalues: u2 (copy)
    if p9 == nil then
        return nil;
    end;

    return u2[p9];
end;

function u1.getVelocity(p10: userdata?, p11: userdata?) -- Line: 45
    -- upvalues: u1 (copy)
    local v12 = u1.read(p10);

    if v12 ~= nil then
        return v12.Velocity, true;
    end;

    if p11 == nil then
        return Vector3.new(0, 0, 0), false;
    end;

    return p11.AssemblyLinearVelocity, false;
end;

function u1.getPosition(p13: userdata?, p14: userdata?) -- Line: 58
    -- upvalues: u1 (copy)
    local v15 = u1.read(p13);

    if v15 ~= nil and v15.Position ~= nil then
        return v15.Position, true;
    end;

    if p14 == nil then
        return Vector3.new(0, 0, 0), false;
    end;

    return p14.Position, false;
end;

function u1.isOnGround(p16: userdata?) -- Line: 71
    -- upvalues: u1 (copy)
    local v17 = u1.read(p16);

    if v17 == nil then
        return false, false;
    end;

    return v17.OnGround, true;
end;

function u1.resolve(p18: userdata?, p19: userdata?) -- Line: 80
    -- upvalues: u1 (copy)
    local Velocity, v20 = u1.getVelocity(p18, p19);
    local v21, v22 = u1.isOnGround(p18);
    local Vector3_new_ret = Vector3.new(Velocity.X, 0, Velocity.Z);

    return Velocity, Vector3_new_ret, Vector3_new_ret.Magnitude, Velocity.Y, v21, v20 or v22;
end;

return table.freeze(u1);