-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
local Config = require(script.Parent.Config);
local u1 = {
    CanonicalFields = table.freeze({ "Position", "Velocity", "LookYaw", "VerticalLook", "BaseMoveSpeed", "MovementMode", "Stance", "OnGround", "GroundNormal", "WallNormal", "GroundSurfaceFriction", "DuckAmount", "DuckTimeMsecs", "IsDucking", "DuckSpeed", "DuckCooldownSeconds", "Stamina", "LastJumpCommandNumber", "PreviousButtons", "JumpBufferTicksRemaining", "JumpHullActive", "StuckStepTicks", "WeaponMoveSpeed", "WeaponScopedMoveSpeed", "VelocityModifier", "MovementTick" })
};

function u1.fieldMask(p2: string) -- Line: 41
    -- upvalues: u1 (copy)
    local table_find_ret = table.find(u1.CanonicalFields, p2);
    local v3 = `unknown canonical MovementState field {p2}`;
    assert(table_find_ret ~= nil, v3);

    return bit32.lshift(1, table_find_ret - 1);
end;

function u1.canonicalMismatch(p4, p5) -- Line: 48
    -- upvalues: u1 (copy)
    local v6 = 0;
    local v7 = 0;

    for i, v in u1.CanonicalFields do
        if p4[v] ~= p5[v] then
            v6 = v6 + 1;
            local bit32_lshift_ret = bit32.lshift(1, i - 1);
            v7 = bit32.bor(v7, bit32_lshift_ret);
        end;
    end;

    return v6, v7;
end;

function u1.mismatchLabel(p8: number) -- Line: 59
    -- upvalues: u1 (copy)
    if p8 == 0 then
        return "none";
    end;

    local v9 = {};

    for i, v in u1.CanonicalFields do
        local bit32_lshift_ret = bit32.lshift(1, i - 1);

        if bit32.band(p8, bit32_lshift_ret) ~= 0 then
            v9[#v9 + 1] = v;
        end;
    end;

    if #v9 == 0 then
        return string.format("unknown(0x%X)", p8);
    end;

    return table.concat(v9, ",");
end;

function u1.new(p10: vector, p11: number?, p12: number?, p13: number?, p14: number?, p15: number?) -- Line: 72
    -- upvalues: Config (copy)
    local v16 = p14 or Config.Default.DefaultBaseMoveSpeed;

    return {
        Velocity = Vector3.new(0, 0, 0),
        VelocityModifier = 1,
        MovementTick = 0,
        MovementMode = "Walking",
        Stance = "Standing",
        OnGround = false,
        GroundNormal = Vector3.new(0, 1, 0),
        WallNormal = Vector3.new(0, 0, 0),
        GroundSurfaceFriction = 1,
        DuckAmount = 0,
        DuckTimeMsecs = 0,
        IsDucking = false,
        DuckSpeed = 8,
        DuckCooldownSeconds = 0,
        Stamina = 100,
        LastJumpCommandNumber = 4294967295,
        PreviousButtons = 0,
        JumpBufferTicksRemaining = 0,
        JumpHullActive = false,
        StuckStepTicks = 0,
        Position = p10,
        LookYaw = p12 or 0,
        VerticalLook = p13 or 0,
        BaseMoveSpeed = p11 or Config.Default.DefaultBaseMoveSpeed,
        WeaponMoveSpeed = v16,
        WeaponScopedMoveSpeed = p15 or v16
    };
end;

function u1.clone(p17) -- Line: 111
    return {
        Position = p17.Position,
        Velocity = p17.Velocity,
        LookYaw = p17.LookYaw,
        VerticalLook = p17.VerticalLook,
        BaseMoveSpeed = p17.BaseMoveSpeed,
        WeaponMoveSpeed = p17.WeaponMoveSpeed,
        WeaponScopedMoveSpeed = p17.WeaponScopedMoveSpeed,
        VelocityModifier = p17.VelocityModifier,
        MovementTick = p17.MovementTick,
        MovementMode = p17.MovementMode,
        Stance = p17.Stance,
        OnGround = p17.OnGround,
        GroundNormal = p17.GroundNormal,
        WallNormal = p17.WallNormal,
        GroundSurfaceFriction = p17.GroundSurfaceFriction,
        DuckAmount = p17.DuckAmount,
        DuckTimeMsecs = p17.DuckTimeMsecs,
        IsDucking = p17.IsDucking,
        DuckSpeed = p17.DuckSpeed,
        DuckCooldownSeconds = p17.DuckCooldownSeconds,
        Stamina = p17.Stamina,
        LastJumpCommandNumber = p17.LastJumpCommandNumber,
        PreviousButtons = p17.PreviousButtons,
        JumpBufferTicksRemaining = p17.JumpBufferTicksRemaining,
        JumpHullActive = p17.JumpHullActive,
        StuckStepTicks = p17.StuckStepTicks
    };
end;

function u1.cloneInto(p18, p19) -- Line: 143
    table.clear(p18);
    p18.Position = p19.Position;
    p18.Velocity = p19.Velocity;
    p18.LookYaw = p19.LookYaw;
    p18.VerticalLook = p19.VerticalLook;
    p18.BaseMoveSpeed = p19.BaseMoveSpeed;
    p18.WeaponMoveSpeed = p19.WeaponMoveSpeed;
    p18.WeaponScopedMoveSpeed = p19.WeaponScopedMoveSpeed;
    p18.VelocityModifier = p19.VelocityModifier;
    p18.MovementTick = p19.MovementTick;
    p18.MovementMode = p19.MovementMode;
    p18.Stance = p19.Stance;
    p18.OnGround = p19.OnGround;
    p18.GroundNormal = p19.GroundNormal;
    p18.WallNormal = p19.WallNormal;
    p18.GroundSurfaceFriction = p19.GroundSurfaceFriction;
    p18.DuckAmount = p19.DuckAmount;
    p18.DuckTimeMsecs = p19.DuckTimeMsecs;
    p18.IsDucking = p19.IsDucking;
    p18.DuckSpeed = p19.DuckSpeed;
    p18.DuckCooldownSeconds = p19.DuckCooldownSeconds;
    p18.Stamina = p19.Stamina;
    p18.LastJumpCommandNumber = p19.LastJumpCommandNumber;
    p18.PreviousButtons = p19.PreviousButtons;
    p18.JumpBufferTicksRemaining = p19.JumpBufferTicksRemaining;
    p18.JumpHullActive = p19.JumpHullActive;
    p18.StuckStepTicks = p19.StuckStepTicks;

    return p18;
end;

function u1.noneSupport() -- Line: 174
    return {
        Kind = 0,
        SourceId = 0,
        Anchor = Vector3.new(0, 0, 0),
        Velocity = Vector3.new(0, 0, 0)
    };
end;

function u1.cloneSupport(p20) -- Line: 183
    return {
        Kind = p20.Kind,
        SourceId = p20.SourceId,
        Anchor = p20.Anchor,
        Velocity = p20.Velocity
    };
end;

return table.freeze(u1);