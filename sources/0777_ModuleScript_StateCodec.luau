-- Decompiled with Potassium's decompiler.

local Buttons = require(script.Parent.Buttons);
local Enums = require(script.Parent.Enums);
local Quantization = require(script.Parent.Quantization);
require(script.Parent.Types);
local u1 = {
    Version = 6,
    WireSize = 91
};
local isVector3Within = Quantization.isVector3Within;
local writeVector3F32 = Quantization.writeVector3F32;
local readVector3F32 = Quantization.readVector3F32;

local function numberWithin(p2: any, p3: number, p4: number) -- Line: 34
    -- upvalues: Quantization (copy)
    local v5 = Quantization.isFinite(p2);

    if v5 then
        if p3 <= p2 then
            v5 = p2 <= p4;
        else
            v5 = false;
        end;
    end;

    return v5;
end;

function u1.validate(p6) -- Line: 38
    -- upvalues: Quantization (copy), isVector3Within (copy), Buttons (copy)
    if typeof(p6) ~= "table" then
        return false, "StateNotTable";
    end;

    local MovementTick = p6.MovementTick;
    local v7 = Quantization.isFinite(MovementTick);

    if v7 then
        if MovementTick >= 0 then
            v7 = MovementTick <= 4294967295;
        else
            v7 = false;
        end;
    end;

    if not v7 or p6.MovementTick % 1 ~= 0 then
        return false, "InvalidMovementTick";
    end;

    if not isVector3Within(p6.Position, 1000000) then
        return false, "InvalidPosition";
    end;

    if not isVector3Within(p6.Velocity, 100000) then
        return false, "InvalidVelocity";
    end;

    if not Quantization.isFinite(p6.LookYaw) then
        return false, "InvalidLookYaw";
    end;

    local VerticalLook = p6.VerticalLook;
    local v8 = Quantization.isFinite(VerticalLook);

    if v8 then
        if VerticalLook >= -1 then
            v8 = VerticalLook <= 1;
        else
            v8 = false;
        end;
    end;

    if not v8 then
        return false, "InvalidVerticalLook";
    end;

    local BaseMoveSpeed = p6.BaseMoveSpeed;
    local v9 = Quantization.isFinite(BaseMoveSpeed);

    if v9 then
        if BaseMoveSpeed >= 0 then
            v9 = BaseMoveSpeed <= 10000;
        else
            v9 = false;
        end;
    end;

    if not v9 then
        return false, "InvalidBaseMoveSpeed";
    end;

    local WeaponMoveSpeed = p6.WeaponMoveSpeed;
    local v10 = Quantization.isFinite(WeaponMoveSpeed);

    if v10 then
        if WeaponMoveSpeed >= 0 then
            v10 = WeaponMoveSpeed <= 10000;
        else
            v10 = false;
        end;
    end;

    if not v10 then
        return false, "InvalidWeaponMoveSpeed";
    end;

    local WeaponScopedMoveSpeed = p6.WeaponScopedMoveSpeed;
    local v11 = Quantization.isFinite(WeaponScopedMoveSpeed);

    if v11 then
        if WeaponScopedMoveSpeed >= 0 then
            v11 = WeaponScopedMoveSpeed <= 10000;
        else
            v11 = false;
        end;
    end;

    if not v11 then
        return false, "InvalidWeaponScopedMoveSpeed";
    end;

    local VelocityModifier = p6.VelocityModifier;
    local v12 = Quantization.isFinite(VelocityModifier);

    if v12 then
        if VelocityModifier >= 0 then
            v12 = VelocityModifier <= 1;
        else
            v12 = false;
        end;
    end;

    if not v12 then
        return false, "InvalidVelocityModifier";
    end;

    if p6.MovementMode ~= "Walking" and p6.MovementMode ~= "Ladder" then
        return false, "InvalidMovementMode";
    end;

    if p6.Stance ~= "Standing" and p6.Stance ~= "Ducking" then
        return false, "InvalidStance";
    end;

    if typeof(p6.OnGround) ~= "boolean" then
        return false, "InvalidOnGround";
    end;

    if not isVector3Within(p6.GroundNormal, 2) then
        return false, "InvalidGroundNormal";
    end;

    if p6.OnGround and p6.GroundNormal.Magnitude <= 1e-8 then
        return false, "MissingGroundNormal";
    end;

    if not isVector3Within(p6.WallNormal, 2) then
        return false, "InvalidWallNormal";
    end;

    local GroundSurfaceFriction = p6.GroundSurfaceFriction;
    local v13 = Quantization.isFinite(GroundSurfaceFriction);

    if v13 then
        if GroundSurfaceFriction >= 0 then
            v13 = GroundSurfaceFriction <= 100;
        else
            v13 = false;
        end;
    end;

    if not v13 then
        return false, "InvalidGroundSurfaceFriction";
    end;

    local DuckAmount = p6.DuckAmount;
    local v14 = Quantization.isFinite(DuckAmount);

    if v14 then
        if DuckAmount >= 0 then
            v14 = DuckAmount <= 1;
        else
            v14 = false;
        end;
    end;

    if not v14 then
        return false, "InvalidDuckAmount";
    end;

    local DuckTimeMsecs = p6.DuckTimeMsecs;
    local v15 = Quantization.isFinite(DuckTimeMsecs);

    if v15 then
        if DuckTimeMsecs >= 0 then
            v15 = DuckTimeMsecs <= 60000;
        else
            v15 = false;
        end;
    end;

    if not v15 then
        return false, "InvalidDuckTimeMsecs";
    end;

    if typeof(p6.IsDucking) ~= "boolean" then
        return false, "InvalidIsDucking";
    end;

    local DuckSpeed = p6.DuckSpeed;
    local v16 = Quantization.isFinite(DuckSpeed);

    if v16 then
        if DuckSpeed >= 0 then
            v16 = DuckSpeed <= 100;
        else
            v16 = false;
        end;
    end;

    if not v16 then
        return false, "InvalidDuckSpeed";
    end;

    local DuckCooldownSeconds = p6.DuckCooldownSeconds;
    local v17 = Quantization.isFinite(DuckCooldownSeconds);

    if v17 then
        if DuckCooldownSeconds >= 0 then
            v17 = DuckCooldownSeconds <= 60;
        else
            v17 = false;
        end;
    end;

    if not v17 then
        return false, "InvalidDuckCooldownSeconds";
    end;

    local Stamina = p6.Stamina;
    local v18 = Quantization.isFinite(Stamina);

    if v18 then
        if Stamina >= 0 then
            v18 = Stamina <= 10000;
        else
            v18 = false;
        end;
    end;

    if not v18 then
        return false, "InvalidStamina";
    end;

    local LastJumpCommandNumber = p6.LastJumpCommandNumber;
    local v19 = Quantization.isFinite(LastJumpCommandNumber);

    if v19 then
        if LastJumpCommandNumber >= 0 then
            v19 = LastJumpCommandNumber <= 4294967295;
        else
            v19 = false;
        end;
    end;

    if not v19 or p6.LastJumpCommandNumber % 1 ~= 0 then
        return false, "InvalidLastJumpCommandNumber";
    end;

    if not Buttons.isValid(p6.PreviousButtons) then
        return false, "InvalidPreviousButtons";
    end;

    local JumpBufferTicksRemaining = p6.JumpBufferTicksRemaining;
    local v20 = Quantization.isFinite(JumpBufferTicksRemaining);

    if v20 then
        if JumpBufferTicksRemaining >= 0 then
            v20 = JumpBufferTicksRemaining <= 255;
        else
            v20 = false;
        end;
    end;

    if not v20 or p6.JumpBufferTicksRemaining % 1 ~= 0 then
        return false, "InvalidJumpBufferTicksRemaining";
    end;

    if typeof(p6.JumpHullActive) ~= "boolean" then
        return false, "InvalidJumpHullActive";
    end;

    local StuckStepTicks = p6.StuckStepTicks;
    local v21 = Quantization.isFinite(StuckStepTicks);

    if v21 then
        if StuckStepTicks >= 0 then
            v21 = StuckStepTicks <= 255;
        else
            v21 = false;
        end;
    end;

    if v21 and p6.StuckStepTicks % 1 == 0 then
        return true, nil;
    end;

    return false, "InvalidStuckStepTicks";
end;

local function writeNormal(p22: buffer, p23: number, p24: vector) -- Line: 126
    -- upvalues: Quantization (copy)
    local v25, v26, v27 = Quantization.quantizeNormal(p24);
    buffer.writei16(p22, p23, v25);
    buffer.writei16(p22, p23 + 2, v26);
    buffer.writei16(p22, p23 + 4, v27);

    return p23 + 6;
end;

local function readNormal(p28: buffer, p29: number) -- Line: 134
    -- upvalues: Quantization (copy)
    return Quantization.dequantizeNormal(buffer.readi16(p28, p29), buffer.readi16(p28, p29 + 2), (buffer.readi16(p28, p29 + 4))), p29 + 6;
end;

function u1.writeValidated(p30: buffer, p31: number, p32: any) -- Line: 144
    -- upvalues: writeVector3F32 (copy), Quantization (copy), Enums (copy)
    local v33;

    if p31 % 1 == 0 then
        v33 = p31 >= 0;
    else
        v33 = false;
    end;

    assert(v33, "invalid state write offset");
    local v34 = buffer.len(p30) >= p31 + 91;
    assert(v34, "state write exceeds target buffer");
    buffer.writeu8(p30, p31, 6);
    local v35 = writeVector3F32(p30, writeVector3F32(p30, p31 + 1, p32.Position), p32.Velocity);
    local v36 = Quantization.quantizeYaw(p32.LookYaw);
    buffer.writeu16(p30, v35, v36);
    local v37 = v35 + 2;
    local v38 = Quantization.quantizeSignedUnit(p32.VerticalLook);
    buffer.writei8(p30, v37, v38);
    local v39 = v37 + 1;
    local v40 = 0;

    if p32.OnGround then
        v40 = bit32.bor(v40, 1);
    end;

    if p32.IsDucking then
        v40 = bit32.bor(v40, 2);
    end;

    if p32.JumpHullActive then
        v40 = bit32.bor(v40, 4);
    end;

    buffer.writeu8(p30, v39, v40);
    local v41 = v39 + 1;
    local v42;

    if p32.MovementMode == "Ladder" then
        v42 = Enums.MovementMode.Ladder;
    else
        v42 = Enums.MovementMode.Walking;
    end;

    buffer.writeu8(p30, v41, v42);
    local v43 = v41 + 1;
    local v44;

    if p32.Stance == "Ducking" then
        v44 = Enums.Stance.Ducking;
    else
        v44 = Enums.Stance.Standing;
    end;

    buffer.writeu8(p30, v43, v44);
    local v45 = v43 + 1;
    local v46, v47, v48 = Quantization.quantizeNormal(p32.GroundNormal);
    buffer.writei16(p30, v45, v46);
    buffer.writei16(p30, v45 + 2, v47);
    buffer.writei16(p30, v45 + 4, v48);
    local v49 = v45 + 6;
    local v50, v51, v52 = Quantization.quantizeNormal(p32.WallNormal);
    buffer.writei16(p30, v49, v50);
    buffer.writei16(p30, v49 + 2, v51);
    buffer.writei16(p30, v49 + 4, v52);
    local v53 = v49 + 6;
    buffer.writef32(p30, v53, p32.GroundSurfaceFriction);
    local v54 = v53 + 4;
    buffer.writef32(p30, v54, p32.BaseMoveSpeed);
    local v55 = v54 + 4;
    local v56 = Quantization.quantizeUnitByte(p32.DuckAmount);
    buffer.writeu8(p30, v55, v56);
    local v57 = v55 + 1;
    buffer.writef32(p30, v57, p32.DuckTimeMsecs);
    local v58 = v57 + 4;
    buffer.writef32(p30, v58, p32.DuckSpeed);
    local v59 = v58 + 4;
    buffer.writef32(p30, v59, p32.DuckCooldownSeconds);
    local v60 = v59 + 4;
    buffer.writef32(p30, v60, p32.Stamina);
    local v61 = v60 + 4;
    buffer.writeu32(p30, v61, p32.LastJumpCommandNumber);
    local v62 = v61 + 4;
    buffer.writeu8(p30, v62, p32.PreviousButtons);
    local v63 = v62 + 1;
    buffer.writeu8(p30, v63, p32.JumpBufferTicksRemaining);
    local v64 = v63 + 1;
    buffer.writeu8(p30, v64, p32.StuckStepTicks);
    local v65 = v64 + 1;
    buffer.writef32(p30, v65, p32.WeaponMoveSpeed);
    local v66 = v65 + 4;
    buffer.writef32(p30, v66, p32.WeaponScopedMoveSpeed);
    local v67 = v66 + 4;
    buffer.writef32(p30, v67, p32.VelocityModifier);
    local v68 = v67 + 4;
    buffer.writeu32(p30, v68, p32.MovementTick);
    local v69 = v68 + 4;
    assert(v69 - p31 == 91, "MovementV2 state wire size drift");

    return v69;
end;

function u1.encode(p70) -- Line: 214
    -- upvalues: u1 (copy)
    local v71, v72 = u1.validate(p70);

    if not v71 then
        return nil, v72;
    end;

    local buffer_create_ret = buffer.create(91);
    u1.writeValidated(buffer_create_ret, 0, p70);

    return buffer_create_ret, nil;
end;

function u1.decodeFrom(p73, p74) -- Line: 225
    -- upvalues: readVector3F32 (copy), Quantization (copy), Enums (copy), u1 (copy)
    if typeof(p73) ~= "buffer" then
        return nil, nil, "StatePayloadNotBuffer";
    end;

    if typeof(p74) ~= "number" or (p74 % 1 ~= 0 or p74 < 0) then
        return nil, nil, "InvalidStateOffset";
    end;

    if buffer.len(p73) < p74 + 91 then
        return nil, nil, "StatePayloadSize";
    end;

    if buffer.readu8(p73, p74) ~= 6 then
        return nil, nil, "StateVersion";
    end;

    local v75, v76 = readVector3F32(p73, p74 + 1);
    local v77, v78 = readVector3F32(p73, v76);
    local v79 = Quantization.dequantizeYaw((buffer.readu16(p73, v78)));
    local v80 = v78 + 2;
    local v81 = Quantization.dequantizeSignedUnit((buffer.readi8(p73, v80)));
    local v82 = v80 + 1;
    local buffer_readu8_ret = buffer.readu8(p73, v82);
    local v83 = v82 + 1;

    if bit32.band(buffer_readu8_ret, 4294967288) ~= 0 then
        return nil, nil, "InvalidStateFlags";
    end;

    local buffer_readu8_ret2 = buffer.readu8(p73, v83);
    local v84 = v83 + 1;

    if Enums.MovementMode.Ladder < buffer_readu8_ret2 then
        return nil, nil, "InvalidMovementMode";
    end;

    local buffer_readu8_ret3 = buffer.readu8(p73, v84);
    local v85 = v84 + 1;

    if Enums.Stance.Ducking < buffer_readu8_ret3 then
        return nil, nil, "InvalidStance";
    end;

    local v86 = Quantization.dequantizeNormal(buffer.readi16(p73, v85), buffer.readi16(p73, v85 + 2), (buffer.readi16(p73, v85 + 4)));
    local v87 = v85 + 6;
    local v88 = Quantization.dequantizeNormal(buffer.readi16(p73, v87), buffer.readi16(p73, v87 + 2), (buffer.readi16(p73, v87 + 4)));
    local v89 = v87 + 6;
    local buffer_readf32_ret = buffer.readf32(p73, v89);
    local v90 = v89 + 4;
    local buffer_readf32_ret2 = buffer.readf32(p73, v90);
    local v91 = v90 + 4;
    local v92 = Quantization.dequantizeUnitByte((buffer.readu8(p73, v91)));
    local v93 = v91 + 1;
    local buffer_readf32_ret3 = buffer.readf32(p73, v93);
    local v94 = v93 + 4;
    local buffer_readf32_ret4 = buffer.readf32(p73, v94);
    local v95 = v94 + 4;
    local buffer_readf32_ret5 = buffer.readf32(p73, v95);
    local v96 = v95 + 4;
    local buffer_readf32_ret6 = buffer.readf32(p73, v96);
    local v97 = v96 + 4;
    local buffer_readu32_ret = buffer.readu32(p73, v97);
    local v98 = v97 + 4;
    local buffer_readu8_ret4 = buffer.readu8(p73, v98);
    local v99 = v98 + 1;
    local buffer_readu8_ret5 = buffer.readu8(p73, v99);
    local v100 = v99 + 1;
    local buffer_readu8_ret6 = buffer.readu8(p73, v100);
    local v101 = v100 + 1;
    local buffer_readf32_ret7 = buffer.readf32(p73, v101);
    local v102 = v101 + 4;
    local buffer_readf32_ret8 = buffer.readf32(p73, v102);
    local v103 = v102 + 4;
    local buffer_readf32_ret9 = buffer.readf32(p73, v103);
    local v104 = v103 + 4;
    local buffer_readu32_ret2 = buffer.readu32(p73, v104);
    local v105 = v104 + 4;
    assert(v105 - p74 == 91, "MovementV2 state wire size drift");
    local v106 = {
        Position = v75,
        Velocity = v77,
        LookYaw = v79,
        VerticalLook = v81,
        BaseMoveSpeed = buffer_readf32_ret2,
        WeaponMoveSpeed = buffer_readf32_ret7,
        WeaponScopedMoveSpeed = buffer_readf32_ret8,
        VelocityModifier = buffer_readf32_ret9,
        MovementTick = buffer_readu32_ret2,
        MovementMode = buffer_readu8_ret2 == Enums.MovementMode.Ladder and "Ladder" or "Walking",
        Stance = buffer_readu8_ret3 == Enums.Stance.Ducking and "Ducking" or "Standing",
        OnGround = bit32.band(buffer_readu8_ret, 1) ~= 0,
        GroundNormal = v86,
        WallNormal = v88,
        GroundSurfaceFriction = buffer_readf32_ret,
        DuckAmount = v92,
        DuckTimeMsecs = buffer_readf32_ret3,
        IsDucking = bit32.band(buffer_readu8_ret, 2) ~= 0,
        DuckSpeed = buffer_readf32_ret4,
        DuckCooldownSeconds = buffer_readf32_ret5,
        Stamina = buffer_readf32_ret6,
        LastJumpCommandNumber = buffer_readu32_ret,
        PreviousButtons = buffer_readu8_ret4,
        JumpBufferTicksRemaining = buffer_readu8_ret5,
        JumpHullActive = bit32.band(buffer_readu8_ret, 4) ~= 0,
        StuckStepTicks = buffer_readu8_ret6
    };
    local v107, v108 = u1.validate(v106);

    if v107 then
        return v106, v105, nil;
    end;

    return nil, nil, v108;
end;

function u1.decode(p109) -- Line: 332
    -- upvalues: u1 (copy)
    if typeof(p109) ~= "buffer" then
        return nil, "StatePayloadNotBuffer";
    end;

    if buffer.len(p109) ~= 91 then
        return nil, "StatePayloadSize";
    end;

    local v110, _, v111 = u1.decodeFrom(p109, 0);

    return v110, v111;
end;

function u1.canonicalize(p112) -- Line: 343
    -- upvalues: u1 (copy)
    local v113, v114 = u1.encode(p112);

    if v113 == nil then
        return nil, v114;
    end;

    return u1.decode(v113);
end;

return table.freeze(u1);