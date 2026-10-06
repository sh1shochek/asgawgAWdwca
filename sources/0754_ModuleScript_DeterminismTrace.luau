-- Decompiled with Potassium's decompiler.

local u1 = {};
local buffer_create_ret = buffer.create(4);
local u2 = {};
u2.__index = u2;
local u3 = {};
local u4 = {};
local table_freeze_ret = table.freeze({
    [0] = "unknown",
    [1] = "ReplicatedStorage.MovementV2.Simulation.ProvenSimulator",
    [2] = "ReplicatedStorage.MovementV2.Simulation.ProvenCollisionAdapter",
    [3] = "ReplicatedStorage.MovementV2.Simulation.PlayerContacts",
    [4] = "ReplicatedStorage.MovementV2.Simulation",
    [5] = "ReplicatedStorage.MovementV2.Client.PlayerContactAdapter",
    [6] = "ServerScriptService.MovementV2.AuthorityRuntime",
    [7] = "ReplicatedStorage.MovementV2.Client.Runtime"
});

local function sourceId(p5: string) -- Line: 115
    -- upvalues: u4 (copy)
    local v6 = u4[p5];

    if v6 ~= nil then
        return v6;
    end;

    local v7 = string.find(p5, "ProvenSimulator", 1, true) == nil and (string.find(p5, "ProvenCollisionAdapter", 1, true) == nil and (string.find(p5, "PlayerContacts", 1, true) == nil and (string.find(p5, "Client.PlayerContactAdapter", 1, true) == nil and (string.find(p5, "AuthorityRuntime", 1, true) == nil and (string.find(p5, "Client.Runtime", 1, true) == nil and (string.find(p5, "MovementV2.Simulation", 1, true) == nil and 0 or 4) or 7) or 6) or 5) or 3) or 2) or 1;
    u4[p5] = v7;

    return v7;
end;

local function finite(p8) -- Line: 137
    local v9;

    if typeof(p8) == "number" and (p8 == p8 and p8 > (-1 / 0)) then
        v9 = p8 < (1 / 0);
    else
        v9 = false;
    end;

    return v9;
end;

local function mix(p10: number, p11: number) -- Line: 141
    local bit32_bxor_ret = bit32.bxor(p10, p11);
    local v12 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;

    return bit32.band(v12, 4294967295);
end;

local function floatWord(p13) -- Line: 145
    -- upvalues: buffer_create_ret (copy)
    local v14;

    if typeof(p13) == "number" and (p13 == p13 and p13 > (-1 / 0)) then
        v14 = p13 < (1 / 0);
    else
        v14 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v14 and 0 or p13);

    return buffer.readu32(buffer_create_ret, 0);
end;

local function boolWord(p15) -- Line: 151
    return p15 == true and 1 or 0;
end;

local function stringWord(p16) -- Line: 155
    if typeof(p16) ~= "string" then
        return 0;
    end;

    local v17 = 2166136261;

    for i = 1, #p16 do
        local string_byte_ret = string.byte(p16, i);
        local bit32_bxor_ret = bit32.bxor(v17, string_byte_ret);
        local v18 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;
        v17 = bit32.band(v18, 4294967295);
        local _ = i;
    end;

    return v17;
end;

local function vectorHash(p19: number, p20: any) -- Line: 166
    -- upvalues: buffer_create_ret (copy)
    if typeof(p20) ~= "Vector3" then
        local bit32_bxor_ret = bit32.bxor(p19, 0);
        local v21 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;

        return bit32.band(v21, 4294967295);
    end;

    local X = p20.X;
    local v22;

    if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
        v22 = X < (1 / 0);
    else
        v22 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v22 and 0 or X);
    local buffer_readu32_ret = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret = bit32.bxor(p19, buffer_readu32_ret);
    local v23 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;
    local bit32_band_ret = bit32.band(v23, 4294967295);
    local Y = p20.Y;
    local v24;

    if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
        v24 = Y < (1 / 0);
    else
        v24 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v24 and 0 or Y);
    local buffer_readu32_ret2 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret2 = bit32.bxor(bit32_band_ret, buffer_readu32_ret2);
    local v25 = bit32.lrotate(bit32_bxor_ret2, 5) + 2654435769;
    local bit32_band_ret2 = bit32.band(v25, 4294967295);
    local Z = p20.Z;
    local v26;

    if typeof(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
        v26 = Z < (1 / 0);
    else
        v26 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v26 and 0 or Z);
    local buffer_readu32_ret3 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret3 = bit32.bxor(bit32_band_ret2, buffer_readu32_ret3);
    local v27 = bit32.lrotate(bit32_bxor_ret3, 5) + 2654435769;

    return bit32.band(v27, 4294967295);
end;

local function vector2Hash(p28: number, p29: any) -- Line: 175
    -- upvalues: buffer_create_ret (copy)
    if typeof(p29) ~= "Vector2" then
        local bit32_bxor_ret = bit32.bxor(p28, 0);
        local v30 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;

        return bit32.band(v30, 4294967295);
    end;

    local X = p29.X;
    local v31;

    if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
        v31 = X < (1 / 0);
    else
        v31 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v31 and 0 or X);
    local buffer_readu32_ret = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret = bit32.bxor(p28, buffer_readu32_ret);
    local v32 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;
    local bit32_band_ret = bit32.band(v32, 4294967295);
    local Y = p29.Y;
    local v33;

    if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
        v33 = Y < (1 / 0);
    else
        v33 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v33 and 0 or Y);
    local buffer_readu32_ret2 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret2 = bit32.bxor(bit32_band_ret, buffer_readu32_ret2);
    local v34 = bit32.lrotate(bit32_bxor_ret2, 5) + 2654435769;

    return bit32.band(v34, 4294967295);
end;

local function registerSite(p35: string, p36: string) -- Line: 183
    -- upvalues: u3 (copy)
    local v37;

    if typeof(p35) == "string" then
        v37 = 2166136261;

        for i = 1, #p35 do
            local string_byte_ret = string.byte(p35, i);
            local bit32_bxor_ret = bit32.bxor(v37, string_byte_ret);
            local v38 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;
            v37 = bit32.band(v38, 4294967295);
            local _ = i;
        end;
    else
        v37 = 0;
    end;

    local v39 = u3[v37];

    if v39 == nil then
        u3[v37] = table.freeze({
            Label = p35,
            Source = p36
        });

        return v37;
    end;

    if v39.Label ~= p35 then
        error((`MovementV2 determinism trace site collision: {v39.Label} / {p35}`));
    end;

    return v37;
end;

local function stateHash(p40) -- Line: 197
    -- upvalues: vectorHash (copy), buffer_create_ret (copy)
    local v41 = vectorHash(vectorHash(2166136261, p40.Position), p40.Velocity);
    local LookYaw = p40.LookYaw;
    local v42;

    if typeof(LookYaw) == "number" and (LookYaw == LookYaw and LookYaw > (-1 / 0)) then
        v42 = LookYaw < (1 / 0);
    else
        v42 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v42 and 0 or LookYaw);
    local buffer_readu32_ret = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret = bit32.bxor(v41, buffer_readu32_ret);
    local v43 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;
    local bit32_band_ret = bit32.band(v43, 4294967295);
    local VerticalLook = p40.VerticalLook;
    local v44;

    if typeof(VerticalLook) == "number" and (VerticalLook == VerticalLook and VerticalLook > (-1 / 0)) then
        v44 = VerticalLook < (1 / 0);
    else
        v44 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v44 and 0 or VerticalLook);
    local buffer_readu32_ret2 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret2 = bit32.bxor(bit32_band_ret, buffer_readu32_ret2);
    local v45 = bit32.lrotate(bit32_bxor_ret2, 5) + 2654435769;
    local bit32_band_ret2 = bit32.band(v45, 4294967295);
    local Tick = p40.Tick;
    local v46;

    if typeof(Tick) == "number" and (Tick == Tick and Tick > (-1 / 0)) then
        v46 = Tick < (1 / 0);
    else
        v46 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v46 and 0 or Tick);
    local buffer_readu32_ret3 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret3 = bit32.bxor(bit32_band_ret2, buffer_readu32_ret3);
    local v47 = bit32.lrotate(bit32_bxor_ret3, 5) + 2654435769;
    local bit32_band_ret3 = bit32.band(v47, 4294967295);
    local bit32_bxor_ret4 = bit32.bxor(bit32_band_ret3, p40.OnGround == true and 1 or 0);
    local v48 = bit32.lrotate(bit32_bxor_ret4, 5) + 2654435769;
    local bit32_band_ret4 = bit32.band(v48, 4294967295);
    local bit32_bxor_ret5 = bit32.bxor(bit32_band_ret4, p40.GroundSupportIsDynamicPlayer == true and 1 or 0);
    local v49 = bit32.lrotate(bit32_bxor_ret5, 5) + 2654435769;
    local v50 = vectorHash(vectorHash(bit32.band(v49, 4294967295), p40.GroundNormal), p40.WallNormal);
    local GroundSurfaceFriction = p40.GroundSurfaceFriction;
    local v51;

    if typeof(GroundSurfaceFriction) == "number" and (GroundSurfaceFriction == GroundSurfaceFriction and GroundSurfaceFriction > (-1 / 0)) then
        v51 = GroundSurfaceFriction < (1 / 0);
    else
        v51 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v51 and 0 or GroundSurfaceFriction);
    local buffer_readu32_ret4 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret6 = bit32.bxor(v50, buffer_readu32_ret4);
    local v52 = bit32.lrotate(bit32_bxor_ret6, 5) + 2654435769;
    local bit32_band_ret5 = bit32.band(v52, 4294967295);
    local DuckAmount = p40.DuckAmount;
    local v53;

    if typeof(DuckAmount) == "number" and (DuckAmount == DuckAmount and DuckAmount > (-1 / 0)) then
        v53 = DuckAmount < (1 / 0);
    else
        v53 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v53 and 0 or DuckAmount);
    local buffer_readu32_ret5 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret7 = bit32.bxor(bit32_band_ret5, buffer_readu32_ret5);
    local v54 = bit32.lrotate(bit32_bxor_ret7, 5) + 2654435769;
    local bit32_band_ret6 = bit32.band(v54, 4294967295);
    local DuckTimeMsecs = p40.DuckTimeMsecs;
    local v55;

    if typeof(DuckTimeMsecs) == "number" and (DuckTimeMsecs == DuckTimeMsecs and DuckTimeMsecs > (-1 / 0)) then
        v55 = DuckTimeMsecs < (1 / 0);
    else
        v55 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v55 and 0 or DuckTimeMsecs);
    local buffer_readu32_ret6 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret8 = bit32.bxor(bit32_band_ret6, buffer_readu32_ret6);
    local v56 = bit32.lrotate(bit32_bxor_ret8, 5) + 2654435769;
    local bit32_band_ret7 = bit32.band(v56, 4294967295);
    local bit32_bxor_ret9 = bit32.bxor(bit32_band_ret7, p40.IsDucking == true and 1 or 0);
    local v57 = bit32.lrotate(bit32_bxor_ret9, 5) + 2654435769;
    local bit32_band_ret8 = bit32.band(v57, 4294967295);
    local bit32_bxor_ret10 = bit32.bxor(bit32_band_ret8, p40.DuckHeld == true and 1 or 0);
    local v58 = bit32.lrotate(bit32_bxor_ret10, 5) + 2654435769;
    local bit32_band_ret9 = bit32.band(v58, 4294967295);
    local v59 = p40.DuckFatigueLevel or p40.DuckSpeed;
    local v60;

    if typeof(v59) == "number" and (v59 == v59 and v59 > (-1 / 0)) then
        v60 = v59 < (1 / 0);
    else
        v60 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v60 and 0 or v59);
    local buffer_readu32_ret7 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret11 = bit32.bxor(bit32_band_ret9, buffer_readu32_ret7);
    local v61 = bit32.lrotate(bit32_bxor_ret11, 5) + 2654435769;
    local bit32_band_ret10 = bit32.band(v61, 4294967295);
    local v62 = p40.DuckFatigueTimerMsecs or p40.DuckCooldownSeconds;
    local v63;

    if typeof(v62) == "number" and (v62 == v62 and v62 > (-1 / 0)) then
        v63 = v62 < (1 / 0);
    else
        v63 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v63 and 0 or v62);
    local buffer_readu32_ret8 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret12 = bit32.bxor(bit32_band_ret10, buffer_readu32_ret8);
    local v64 = bit32.lrotate(bit32_bxor_ret12, 5) + 2654435769;
    local bit32_band_ret11 = bit32.band(v64, 4294967295);
    local v65 = p40.MovementType or p40.MovementMode;
    local v66;

    if typeof(v65) == "string" then
        v66 = 2166136261;

        for i = 1, #v65 do
            local string_byte_ret = string.byte(v65, i);
            local bit32_bxor_ret13 = bit32.bxor(v66, string_byte_ret);
            local v67 = bit32.lrotate(bit32_bxor_ret13, 5) + 2654435769;
            v66 = bit32.band(v67, 4294967295);
            local _ = i;
        end;
    else
        v66 = 0;
    end;

    local bit32_bxor_ret13 = bit32.bxor(bit32_band_ret11, v66);
    local v68 = bit32.lrotate(bit32_bxor_ret13, 5) + 2654435769;
    local bit32_band_ret12 = bit32.band(v68, 4294967295);
    local Stance = p40.Stance;
    local v69;

    if typeof(Stance) == "string" then
        v69 = 2166136261;

        for i = 1, #Stance do
            local string_byte_ret = string.byte(Stance, i);
            local bit32_bxor_ret14 = bit32.bxor(v69, string_byte_ret);
            local v70 = bit32.lrotate(bit32_bxor_ret14, 5) + 2654435769;
            v69 = bit32.band(v70, 4294967295);
            local _ = i;
        end;
    else
        v69 = 0;
    end;

    local bit32_bxor_ret14 = bit32.bxor(bit32_band_ret12, v69);
    local v71 = bit32.lrotate(bit32_bxor_ret14, 5) + 2654435769;
    local bit32_band_ret13 = bit32.band(v71, 4294967295);
    local Stamina = p40.Stamina;
    local v72;

    if typeof(Stamina) == "number" and (Stamina == Stamina and Stamina > (-1 / 0)) then
        v72 = Stamina < (1 / 0);
    else
        v72 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v72 and 0 or Stamina);
    local buffer_readu32_ret9 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret15 = bit32.bxor(bit32_band_ret13, buffer_readu32_ret9);
    local v73 = bit32.lrotate(bit32_bxor_ret15, 5) + 2654435769;
    local bit32_band_ret14 = bit32.band(v73, 4294967295);
    local v74 = p40.LastJumpTick or p40.LastJumpCommandNumber;
    local v75;

    if typeof(v74) == "number" and (v74 == v74 and v74 > (-1 / 0)) then
        v75 = v74 < (1 / 0);
    else
        v75 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v75 and 0 or v74);
    local buffer_readu32_ret10 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret16 = bit32.bxor(bit32_band_ret14, buffer_readu32_ret10);
    local v76 = bit32.lrotate(bit32_bxor_ret16, 5) + 2654435769;
    local bit32_band_ret15 = bit32.band(v76, 4294967295);
    local bit32_bxor_ret17 = bit32.bxor(bit32_band_ret15, p40.JumpHeld == true and 1 or 0);
    local v77 = bit32.lrotate(bit32_bxor_ret17, 5) + 2654435769;
    local bit32_band_ret16 = bit32.band(v77, 4294967295);
    local PreviousButtons = p40.PreviousButtons;
    local v78;

    if typeof(PreviousButtons) == "number" and (PreviousButtons == PreviousButtons and PreviousButtons > (-1 / 0)) then
        v78 = PreviousButtons < (1 / 0);
    else
        v78 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v78 and 0 or PreviousButtons);
    local buffer_readu32_ret11 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret18 = bit32.bxor(bit32_band_ret16, buffer_readu32_ret11);
    local v79 = bit32.lrotate(bit32_bxor_ret18, 5) + 2654435769;
    local bit32_band_ret17 = bit32.band(v79, 4294967295);
    local JumpBufferTicksRemaining = p40.JumpBufferTicksRemaining;
    local v80;

    if typeof(JumpBufferTicksRemaining) == "number" and (JumpBufferTicksRemaining == JumpBufferTicksRemaining and JumpBufferTicksRemaining > (-1 / 0)) then
        v80 = JumpBufferTicksRemaining < (1 / 0);
    else
        v80 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v80 and 0 or JumpBufferTicksRemaining);
    local buffer_readu32_ret12 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret19 = bit32.bxor(bit32_band_ret17, buffer_readu32_ret12);
    local v81 = bit32.lrotate(bit32_bxor_ret19, 5) + 2654435769;
    local bit32_band_ret18 = bit32.band(v81, 4294967295);
    local bit32_bxor_ret20 = bit32.bxor(bit32_band_ret18, p40.JumpHullActive == true and 1 or 0);
    local v82 = bit32.lrotate(bit32_bxor_ret20, 5) + 2654435769;
    local bit32_band_ret19 = bit32.band(v82, 4294967295);
    local StuckStepTicks = p40.StuckStepTicks;
    local v83;

    if typeof(StuckStepTicks) == "number" and (StuckStepTicks == StuckStepTicks and StuckStepTicks > (-1 / 0)) then
        v83 = StuckStepTicks < (1 / 0);
    else
        v83 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v83 and 0 or StuckStepTicks);
    local buffer_readu32_ret13 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret21 = bit32.bxor(bit32_band_ret19, buffer_readu32_ret13);
    local v84 = bit32.lrotate(bit32_bxor_ret21, 5) + 2654435769;
    local bit32_band_ret20 = bit32.band(v84, 4294967295);
    local BaseMoveSpeed = p40.BaseMoveSpeed;
    local v85;

    if typeof(BaseMoveSpeed) == "number" and (BaseMoveSpeed == BaseMoveSpeed and BaseMoveSpeed > (-1 / 0)) then
        v85 = BaseMoveSpeed < (1 / 0);
    else
        v85 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v85 and 0 or BaseMoveSpeed);
    local buffer_readu32_ret14 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret22 = bit32.bxor(bit32_band_ret20, buffer_readu32_ret14);
    local v86 = bit32.lrotate(bit32_bxor_ret22, 5) + 2654435769;
    local bit32_band_ret21 = bit32.band(v86, 4294967295);
    local WeaponMoveSpeed = p40.WeaponMoveSpeed;
    local v87;

    if typeof(WeaponMoveSpeed) == "number" and (WeaponMoveSpeed == WeaponMoveSpeed and WeaponMoveSpeed > (-1 / 0)) then
        v87 = WeaponMoveSpeed < (1 / 0);
    else
        v87 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v87 and 0 or WeaponMoveSpeed);
    local buffer_readu32_ret15 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret23 = bit32.bxor(bit32_band_ret21, buffer_readu32_ret15);
    local v88 = bit32.lrotate(bit32_bxor_ret23, 5) + 2654435769;
    local bit32_band_ret22 = bit32.band(v88, 4294967295);
    local WeaponScopedMoveSpeed = p40.WeaponScopedMoveSpeed;
    local v89;

    if typeof(WeaponScopedMoveSpeed) == "number" and (WeaponScopedMoveSpeed == WeaponScopedMoveSpeed and WeaponScopedMoveSpeed > (-1 / 0)) then
        v89 = WeaponScopedMoveSpeed < (1 / 0);
    else
        v89 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v89 and 0 or WeaponScopedMoveSpeed);
    local buffer_readu32_ret16 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret24 = bit32.bxor(bit32_band_ret22, buffer_readu32_ret16);
    local v90 = bit32.lrotate(bit32_bxor_ret24, 5) + 2654435769;
    local bit32_band_ret23 = bit32.band(v90, 4294967295);
    local VelocityModifier = p40.VelocityModifier;
    local v91;

    if typeof(VelocityModifier) == "number" and (VelocityModifier == VelocityModifier and VelocityModifier > (-1 / 0)) then
        v91 = VelocityModifier < (1 / 0);
    else
        v91 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v91 and 0 or VelocityModifier);
    local buffer_readu32_ret17 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret25 = bit32.bxor(bit32_band_ret23, buffer_readu32_ret17);
    local v92 = bit32.lrotate(bit32_bxor_ret25, 5) + 2654435769;

    return bit32.band(v92, 4294967295);
end;

local function auxiliaryHash(p93, p94) -- Line: 231
    -- upvalues: buffer_create_ret (copy), vectorHash (copy)
    local v95 = 2166136261;

    if p93 ~= nil then
        local Kind = p93.Kind;
        local v96;

        if typeof(Kind) == "number" and (Kind == Kind and Kind > (-1 / 0)) then
            v96 = Kind < (1 / 0);
        else
            v96 = false;
        end;

        buffer.writef32(buffer_create_ret, 0, not v96 and 0 or Kind);
        local buffer_readu32_ret = buffer.readu32(buffer_create_ret, 0);
        local bit32_bxor_ret = bit32.bxor(v95, buffer_readu32_ret);
        local v97 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;
        local bit32_band_ret = bit32.band(v97, 4294967295);
        local SourceId = p93.SourceId;
        local v98;

        if typeof(SourceId) == "number" and (SourceId == SourceId and SourceId > (-1 / 0)) then
            v98 = SourceId < (1 / 0);
        else
            v98 = false;
        end;

        buffer.writef32(buffer_create_ret, 0, not v98 and 0 or SourceId);
        local buffer_readu32_ret2 = buffer.readu32(buffer_create_ret, 0);
        local bit32_bxor_ret2 = bit32.bxor(bit32_band_ret, buffer_readu32_ret2);
        local v99 = bit32.lrotate(bit32_bxor_ret2, 5) + 2654435769;
        v95 = vectorHash(vectorHash(bit32.band(v99, 4294967295), p93.Anchor), p93.Velocity);
    end;

    if p94 ~= nil then
        local CommandNumber = p94.CommandNumber;
        local v100;

        if typeof(CommandNumber) == "number" and (CommandNumber == CommandNumber and CommandNumber > (-1 / 0)) then
            v100 = CommandNumber < (1 / 0);
        else
            v100 = false;
        end;

        buffer.writef32(buffer_create_ret, 0, not v100 and 0 or CommandNumber);
        local buffer_readu32_ret = buffer.readu32(buffer_create_ret, 0);
        local bit32_bxor_ret = bit32.bxor(v95, buffer_readu32_ret);
        local v101 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;
        local bit32_band_ret = bit32.band(v101, 4294967295);
        local Move = p94.Move;
        local v102;

        if typeof(Move) == "Vector2" then
            local X = Move.X;
            local v103;

            if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
                v103 = X < (1 / 0);
            else
                v103 = false;
            end;

            buffer.writef32(buffer_create_ret, 0, not v103 and 0 or X);
            local buffer_readu32_ret2 = buffer.readu32(buffer_create_ret, 0);
            local bit32_bxor_ret2 = bit32.bxor(bit32_band_ret, buffer_readu32_ret2);
            local v104 = bit32.lrotate(bit32_bxor_ret2, 5) + 2654435769;
            local bit32_band_ret2 = bit32.band(v104, 4294967295);
            local Y = Move.Y;
            local v105;

            if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
                v105 = Y < (1 / 0);
            else
                v105 = false;
            end;

            buffer.writef32(buffer_create_ret, 0, not v105 and 0 or Y);
            local buffer_readu32_ret3 = buffer.readu32(buffer_create_ret, 0);
            local bit32_bxor_ret3 = bit32.bxor(bit32_band_ret2, buffer_readu32_ret3);
            local v106 = bit32.lrotate(bit32_bxor_ret3, 5) + 2654435769;
            v102 = bit32.band(v106, 4294967295);
        else
            local bit32_bxor_ret2 = bit32.bxor(bit32_band_ret, 0);
            local v107 = bit32.lrotate(bit32_bxor_ret2, 5) + 2654435769;
            v102 = bit32.band(v107, 4294967295);
        end;

        local LookYaw = p94.LookYaw;
        local v108;

        if typeof(LookYaw) == "number" and (LookYaw == LookYaw and LookYaw > (-1 / 0)) then
            v108 = LookYaw < (1 / 0);
        else
            v108 = false;
        end;

        buffer.writef32(buffer_create_ret, 0, not v108 and 0 or LookYaw);
        local buffer_readu32_ret2 = buffer.readu32(buffer_create_ret, 0);
        local bit32_bxor_ret2 = bit32.bxor(v102, buffer_readu32_ret2);
        local v109 = bit32.lrotate(bit32_bxor_ret2, 5) + 2654435769;
        local bit32_band_ret2 = bit32.band(v109, 4294967295);
        local VerticalLook = p94.VerticalLook;
        local v110;

        if typeof(VerticalLook) == "number" and (VerticalLook == VerticalLook and VerticalLook > (-1 / 0)) then
            v110 = VerticalLook < (1 / 0);
        else
            v110 = false;
        end;

        buffer.writef32(buffer_create_ret, 0, not v110 and 0 or VerticalLook);
        local buffer_readu32_ret3 = buffer.readu32(buffer_create_ret, 0);
        local bit32_bxor_ret3 = bit32.bxor(bit32_band_ret2, buffer_readu32_ret3);
        local v111 = bit32.lrotate(bit32_bxor_ret3, 5) + 2654435769;
        local bit32_band_ret3 = bit32.band(v111, 4294967295);
        local Buttons = p94.Buttons;
        local v112;

        if typeof(Buttons) == "number" and (Buttons == Buttons and Buttons > (-1 / 0)) then
            v112 = Buttons < (1 / 0);
        else
            v112 = false;
        end;

        buffer.writef32(buffer_create_ret, 0, not v112 and 0 or Buttons);
        local buffer_readu32_ret4 = buffer.readu32(buffer_create_ret, 0);
        local bit32_bxor_ret4 = bit32.bxor(bit32_band_ret3, buffer_readu32_ret4);
        local v113 = bit32.lrotate(bit32_bxor_ret4, 5) + 2654435769;
        local bit32_band_ret4 = bit32.band(v113, 4294967295);
        local Kind = p94.Kind;
        local v114;

        if typeof(Kind) == "number" and (Kind == Kind and Kind > (-1 / 0)) then
            v114 = Kind < (1 / 0);
        else
            v114 = false;
        end;

        buffer.writef32(buffer_create_ret, 0, not v114 and 0 or Kind);
        local buffer_readu32_ret5 = buffer.readu32(buffer_create_ret, 0);
        local bit32_bxor_ret5 = bit32.bxor(bit32_band_ret4, buffer_readu32_ret5);
        local v115 = bit32.lrotate(bit32_bxor_ret5, 5) + 2654435769;
        local bit32_band_ret5 = bit32.band(v115, 4294967295);
        local SourceId = p94.SourceId;
        local v116;

        if typeof(SourceId) == "number" and (SourceId == SourceId and SourceId > (-1 / 0)) then
            v116 = SourceId < (1 / 0);
        else
            v116 = false;
        end;

        buffer.writef32(buffer_create_ret, 0, not v116 and 0 or SourceId);
        local buffer_readu32_ret6 = buffer.readu32(buffer_create_ret, 0);
        local bit32_bxor_ret6 = bit32.bxor(bit32_band_ret5, buffer_readu32_ret6);
        local v117 = bit32.lrotate(bit32_bxor_ret6, 5) + 2654435769;
        local bit32_band_ret6 = bit32.band(v117, 4294967295);
        local Revision = p94.Revision;
        local v118;

        if typeof(Revision) == "number" and (Revision == Revision and Revision > (-1 / 0)) then
            v118 = Revision < (1 / 0);
        else
            v118 = false;
        end;

        buffer.writef32(buffer_create_ret, 0, not v118 and 0 or Revision);
        local buffer_readu32_ret7 = buffer.readu32(buffer_create_ret, 0);
        local bit32_bxor_ret7 = bit32.bxor(bit32_band_ret6, buffer_readu32_ret7);
        local v119 = bit32.lrotate(bit32_bxor_ret7, 5) + 2654435769;
        v95 = vectorHash(vectorHash(bit32.band(v119, 4294967295), p94.Delta), p94.Velocity);
    end;

    return v95;
end;

local function eventFlags(p120, p121) -- Line: 254
    local v122 = 0;

    if p120.OnGround == true then
        v122 = bit32.bor(v122, 1);
    end;

    if p120.Stance == "Ducking" or p120.DuckAmount >= 0.999 then
        v122 = bit32.bor(v122, 2);
    end;

    if p120.MovementMode == "Ladder" or p120.MovementType == "Ladder" then
        v122 = bit32.bor(v122, 4);
    end;

    if p120.JumpHullActive == true then
        v122 = bit32.bor(v122, 8);
    end;

    if p120.IsDucking == true then
        v122 = bit32.bor(v122, 16);
    end;

    if p121 ~= nil and (p121.Kind ~= nil and p121.Kind ~= 0) then
        v122 = bit32.bor(v122, 32);
    end;

    return v122;
end;

local function writeEvent(p123: table, p124: number, p125: number, p126: number, p127: number, p128: number, p129: number, p130: number, p131: vector, p132: vector, p133: number, p134: number) -- Line: 277
    if p123.Count >= 128 then
        p123.Overflow = true;

        return;
    end;

    local v135 = p123.BaseOffset + 16 + p123.Count * 48;
    local Buffer = p123.Buffer;
    buffer.writeu32(Buffer, v135 + 0, p124);
    local math_clamp_ret = math.clamp(p126, 0, 65535);
    buffer.writeu16(Buffer, v135 + 4, math_clamp_ret);
    local bit32_lshift_ret = bit32.lshift(p125, 2);
    local bit32_bor_ret = bit32.bor(p127, bit32_lshift_ret);
    buffer.writeu8(Buffer, v135 + 6, bit32_bor_ret);
    buffer.writeu8(Buffer, v135 + 7, p128);
    buffer.writeu32(Buffer, v135 + 8, p129);
    buffer.writeu32(Buffer, v135 + 12, p130);
    buffer.writef32(Buffer, v135 + 16, p131.X);
    buffer.writef32(Buffer, v135 + 16 + 4, p131.Y);
    buffer.writef32(Buffer, v135 + 16 + 8, p131.Z);
    buffer.writef32(Buffer, v135 + 28, p132.X);
    buffer.writef32(Buffer, v135 + 28 + 4, p132.Y);
    buffer.writef32(Buffer, v135 + 28 + 8, p132.Z);
    local v136;

    if typeof(p133) == "number" and (p133 == p133 and p133 > (-1 / 0)) then
        v136 = p133 < (1 / 0);
    else
        v136 = false;
    end;

    buffer.writef32(Buffer, v135 + 40, not v136 and 0 or p133);
    local bit32_band_ret = bit32.band(p134, 4294967295);
    buffer.writeu32(Buffer, v135 + 44, bit32_band_ret);
    p123.Count = p123.Count + 1;
end;

function u1.checkpoint(p137: table?, p138: string, p139: any, p140: any, p141: any, p142: number?, p143: string?, p144: number?) -- Line: 314
    -- upvalues: writeEvent (copy), registerSite (copy), sourceId (copy), eventFlags (copy), stateHash (copy), auxiliaryHash (copy)
    if p137 == nil then
        return;
    end;

    if p143 == nil or p144 == nil then
        p143, p144 = debug.info(p142 or 2, "sl");
    end;

    local v145 = typeof(p139.Position) ~= "Vector3" and Vector3.new(0, 0, 0) or p139.Position;
    local v146 = typeof(p139.Velocity) ~= "Vector3" and Vector3.new(0, 0, 0) or p139.Velocity;
    writeEvent(p137, registerSite(p138, p143), sourceId(p143), p144, 1, eventFlags(p139, p140), stateHash(p139), auxiliaryHash(p140, p141), v145, v146, p139.DuckAmount or 0, (p140 == nil or typeof(p140.SourceId) ~= "number") and 0 or p140.SourceId);
end;

function u1.vector(p147: table?, p148: string, p149: vector, p150: vector, p151: number?, p152: number?, p153: number?, p154: string?, p155: number?) -- Line: 351
    -- upvalues: vectorHash (copy), writeEvent (copy), registerSite (copy), sourceId (copy), buffer_create_ret (copy)
    if p147 == nil then
        return;
    end;

    if p154 == nil or p155 == nil then
        p154, p155 = debug.info(p153 or 2, "sl");
    end;

    local v156 = vectorHash(vectorHash(2166136261, p149), p150);
    local v157 = registerSite(p148, p154);
    local v158 = sourceId(p154);
    local v159;

    if typeof(p151) == "number" and (p151 == p151 and p151 > (-1 / 0)) then
        v159 = p151 < (1 / 0);
    else
        v159 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v159 and 0 or p151);
    local buffer_readu32_ret = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret = bit32.bxor(2166136261, buffer_readu32_ret);
    local v160 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;
    local bit32_band_ret = bit32.band(v160, 4294967295);
    local v161;

    if typeof(p152) == "number" and (p152 == p152 and p152 > (-1 / 0)) then
        v161 = p152 < (1 / 0);
    else
        v161 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v161 and 0 or p152);
    local buffer_readu32_ret2 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret2 = bit32.bxor(bit32_band_ret, buffer_readu32_ret2);
    local v162 = bit32.lrotate(bit32_bxor_ret2, 5) + 2654435769;
    writeEvent(p147, v157, v158, p155, 1, 0, v156, bit32.band(v162, 4294967295), p149, p150, p151 or 0, p152 or 0);
end;

function u1.collision(p163: table?, p164: string, p165: vector, p166: vector, p167: any, p168: number?) -- Line: 388
    -- upvalues: vectorHash (copy), buffer_create_ret (copy), writeEvent (copy), registerSite (copy), sourceId (copy)
    if p163 == nil then
        return;
    end;

    local debug_info_ret, v169 = debug.info(p168 or 2, "sl");
    local v170 = 0;

    if p167.startSolid == true or p167.StartSolid == true then
        v170 = bit32.bor(v170, 64);
    end;

    if p167.allSolid == true or p167.AllSolid == true then
        v170 = bit32.bor(v170, 128);
    end;

    local v171 = p167.fraction or (p167.Fraction or 1);
    local v172 = p167.endPos or (p167.ResolvedPosition or p165:Lerp(p166, v171));
    local v173 = p167.normal or (p167.Normal or Vector3.new(0, 0, 0));
    local hullRecord = p167.hullRecord;
    local v174 = p167.SourceId or (hullRecord and (hullRecord.sourceId or 0) or 0);
    local v175 = vectorHash(2166136261, v173);
    local v176;

    if typeof(v171) == "number" and (v171 == v171 and v171 > (-1 / 0)) then
        v176 = v171 < (1 / 0);
    else
        v176 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v176 and 0 or v171);
    local buffer_readu32_ret = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret = bit32.bxor(v175, buffer_readu32_ret);
    local v177 = bit32.lrotate(bit32_bxor_ret, 5) + 2654435769;
    local bit32_band_ret = bit32.band(v177, 4294967295);
    local bit32_bxor_ret2 = bit32.bxor(bit32_band_ret, v170);
    local v178 = bit32.lrotate(bit32_bxor_ret2, 5) + 2654435769;
    local bit32_band_ret2 = bit32.band(v178, 4294967295);
    local v179;

    if typeof(v174) == "number" and (v174 == v174 and v174 > (-1 / 0)) then
        v179 = v174 < (1 / 0);
    else
        v179 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v179 and 0 or v174);
    local buffer_readu32_ret2 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret3 = bit32.bxor(bit32_band_ret2, buffer_readu32_ret2);
    local v180 = bit32.lrotate(bit32_bxor_ret3, 5) + 2654435769;
    local bit32_band_ret3 = bit32.band(v180, 4294967295);
    local v181 = p167.PlaneId or p167.planeNum;
    local v182;

    if typeof(v181) == "number" and (v181 == v181 and v181 > (-1 / 0)) then
        v182 = v181 < (1 / 0);
    else
        v182 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v182 and 0 or v181);
    local buffer_readu32_ret3 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret4 = bit32.bxor(bit32_band_ret3, buffer_readu32_ret3);
    local v183 = bit32.lrotate(bit32_bxor_ret4, 5) + 2654435769;
    local bit32_band_ret4 = bit32.band(v183, 4294967295);
    local Kind = p167.Kind;

    if Kind then
        hullRecord = Kind;
    elseif hullRecord then
        hullRecord = hullRecord.kind;
    end;

    local v184;

    if typeof(hullRecord) == "number" and (hullRecord == hullRecord and hullRecord > (-1 / 0)) then
        v184 = hullRecord < (1 / 0);
    else
        v184 = false;
    end;

    buffer.writef32(buffer_create_ret, 0, not v184 and 0 or hullRecord);
    local buffer_readu32_ret4 = buffer.readu32(buffer_create_ret, 0);
    local bit32_bxor_ret5 = bit32.bxor(bit32_band_ret4, buffer_readu32_ret4);
    local v185 = bit32.lrotate(bit32_bxor_ret5, 5) + 2654435769;
    local bit32_band_ret5 = bit32.band(v185, 4294967295);
    local v186 = vectorHash(vectorHash(2166136261, p165), p166);
    writeEvent(p163, registerSite(p164, debug_info_ret), sourceId(debug_info_ret), v169, 2, v170, v186, bit32_band_ret5, v172, v173, v171, v174);
end;

local function resetRecorder(p187: table, p188: number, p189: number, p190: number) -- Line: 435
    p187.Count = 0;
    p187.Overflow = false;
    local Buffer = p187.Buffer;
    local BaseOffset = p187.BaseOffset;
    buffer.writeu8(Buffer, BaseOffset, 2);
    buffer.writeu8(Buffer, BaseOffset + 1, 0);
    buffer.writeu8(Buffer, BaseOffset + 2, 0);
    buffer.writeu8(Buffer, BaseOffset + 3, 0);
    buffer.writeu16(Buffer, BaseOffset + 4, p188);
    buffer.writeu16(Buffer, BaseOffset + 6, 0);
    buffer.writeu32(Buffer, BaseOffset + 8, p189);
    buffer.writeu32(Buffer, BaseOffset + 12, p190);
end;

function u2.new(p191: number) -- Line: 450
    -- upvalues: u2 (copy)
    local v192;

    if p191 % 1 == 0 then
        v192 = p191 > 0;
    else
        v192 = false;
    end;

    assert(v192, "determinism trace capacity must be positive");
    local table_create_ret = table.create(p191);
    local buffer_create_ret2 = buffer.create(p191 * 6160);

    for i = 1, p191 do
        table_create_ret[i] = {
            Generation = 0,
            CommandNumber = 0,
            ServerTick = 0,
            Recorder = {
                Count = 0,
                Overflow = false,
                Buffer = buffer_create_ret2,
                BaseOffset = (i - 1) * 6160
            }
        };
        local _ = i;
    end;

    return setmetatable({
        Capacity = p191,
        Slots = table_create_ret
    }, u2);
end;

function u2.clear(p193) -- Line: 474
    for _, v in p193.Slots do
        v.Generation = 0;
        v.CommandNumber = 0;
        v.ServerTick = 0;
        v.Recorder.Count = 0;
        v.Recorder.Overflow = false;
    end;
end;

function u2.begin(p194: table, p195: number, p196: number, p197: number) -- Line: 484
    local v198 = p194.Slots[p196 % p194.Capacity + 1];
    v198.Generation = p195;
    v198.CommandNumber = p196;
    v198.ServerTick = p197;
    local Recorder = v198.Recorder;
    Recorder.Count = 0;
    Recorder.Overflow = false;
    local Buffer = Recorder.Buffer;
    local BaseOffset = Recorder.BaseOffset;
    buffer.writeu8(Buffer, BaseOffset, 2);
    buffer.writeu8(Buffer, BaseOffset + 1, 0);
    buffer.writeu8(Buffer, BaseOffset + 2, 0);
    buffer.writeu8(Buffer, BaseOffset + 3, 0);
    buffer.writeu16(Buffer, BaseOffset + 4, p195);
    buffer.writeu16(Buffer, BaseOffset + 6, 0);
    buffer.writeu32(Buffer, BaseOffset + 8, p196);
    buffer.writeu32(Buffer, BaseOffset + 12, p197);

    return v198.Recorder;
end;

function u2.finish(p199: table, p200: table) -- Line: 493
    buffer.writeu8(p200.Buffer, p200.BaseOffset + 1, p200.Overflow and 1 or 0);
    buffer.writeu8(p200.Buffer, p200.BaseOffset + 2, p200.Count);
end;

local function cloneUsed(p201: buffer, p202: number?) -- Line: 499
    local v203 = p202 or 0;
    local v204 = buffer.readu8(p201, v203 + 2) * 48 + 16;
    local buffer_create_ret2 = buffer.create(v204);
    buffer.copy(buffer_create_ret2, 0, p201, v203, v204);

    return buffer_create_ret2;
end;

function u2.get(p205: table, p206: number, p207: number, p208: number) -- Line: 508
    local v209 = p205.Slots[p207 % p205.Capacity + 1];

    if v209.Generation ~= p206 or (v209.CommandNumber ~= p207 or v209.ServerTick ~= p208) then
        return nil;
    end;

    local Buffer = v209.Recorder.Buffer;
    local v210 = v209.Recorder.BaseOffset or 0;
    local v211 = buffer.readu8(Buffer, v210 + 2) * 48 + 16;
    local buffer_create_ret2 = buffer.create(v211);
    buffer.copy(buffer_create_ret2, 0, Buffer, v210, v211);

    return buffer_create_ret2;
end;

function u1.encodeRequest(p212: number, p213: number, p214: number) -- Line: 516
    local buffer_create_ret2 = buffer.create(12);
    buffer.writeu8(buffer_create_ret2, 0, 2);
    buffer.writeu8(buffer_create_ret2, 1, 0);
    buffer.writeu16(buffer_create_ret2, 2, p212);
    buffer.writeu32(buffer_create_ret2, 4, p213);
    buffer.writeu32(buffer_create_ret2, 8, p214);

    return buffer_create_ret2;
end;

function u1.decodeRequest(p215) -- Line: 526
    if typeof(p215) == "buffer" and (buffer.len(p215) == 12 and buffer.readu8(p215, 0) == 2) then
        return buffer.readu16(p215, 2), buffer.readu32(p215, 4), buffer.readu32(p215, 8);
    end;

    return nil, nil, nil;
end;

function u1.unavailable(p216: number, p217: number, p218: number) -- Line: 533
    local buffer_create_ret2 = buffer.create(16);
    buffer.writeu8(buffer_create_ret2, 0, 2);
    buffer.writeu8(buffer_create_ret2, 1, 2);
    buffer.writeu8(buffer_create_ret2, 2, 0);
    buffer.writeu16(buffer_create_ret2, 4, p216);
    buffer.writeu32(buffer_create_ret2, 8, p217);
    buffer.writeu32(buffer_create_ret2, 12, p218);

    return buffer_create_ret2;
end;

function u1.identity(p219) -- Line: 544
    if typeof(p219) ~= "buffer" or (buffer.len(p219) < 16 or buffer.readu8(p219, 0) ~= 2) then
        return nil, nil, nil, nil;
    end;

    local buffer_readu8_ret = buffer.readu8(p219, 2);

    if buffer_readu8_ret > 128 or buffer.len(p219) ~= buffer_readu8_ret * 48 + 16 then
        return nil, nil, nil, nil;
    end;

    local buffer_readu16_ret = buffer.readu16(p219, 4);
    local buffer_readu32_ret = buffer.readu32(p219, 8);
    local buffer_readu32_ret2 = buffer.readu32(p219, 12);
    local buffer_readu8_ret2 = buffer.readu8(p219, 1);

    return buffer_readu16_ret, buffer_readu32_ret, buffer_readu32_ret2, bit32.band(buffer_readu8_ret2, 2) ~= 0;
end;

local function readEvent(p220: buffer, p221: number) -- Line: 558
    local v222 = (p221 - 1) * 48 + 16;
    local buffer_readu8_ret = buffer.readu8(p220, v222 + 6);
    local v223 = {
        SiteId = buffer.readu32(p220, v222 + 0),
        SourceId = bit32.rshift(buffer_readu8_ret, 2),
        Line = buffer.readu16(p220, v222 + 4),
        Kind = bit32.band(buffer_readu8_ret, 3),
        Flags = buffer.readu8(p220, v222 + 7),
        StateHash = buffer.readu32(p220, v222 + 8),
        AuxHash = buffer.readu32(p220, v222 + 12)
    };
    local buffer_readf32_ret = buffer.readf32(p220, v222 + 16);
    local buffer_readf32_ret2 = buffer.readf32(p220, v222 + 16 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p220, v222 + 16 + 8);
    v223.Position = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local buffer_readf32_ret4 = buffer.readf32(p220, v222 + 28);
    local buffer_readf32_ret5 = buffer.readf32(p220, v222 + 28 + 4);
    local buffer_readf32_ret6 = buffer.readf32(p220, v222 + 28 + 8);
    v223.Velocity = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    v223.Scalar = buffer.readf32(p220, v222 + 40);
    v223.ObjectId = buffer.readu32(p220, v222 + 44);

    return v223;
end;

local function eventClass(p224: table, p225: table) -- Line: 584
    return (p224.SiteId ~= p225.SiteId or p224.Kind ~= p225.Kind) and "ControlFlow" or (p224.Position ~= p225.Position and "Position" or (p224.Velocity ~= p225.Velocity and (p224.Kind == 2 and "CollisionNormal" or "Velocity") or (p224.Flags ~= p225.Flags and "StateFlags" or (p224.Scalar ~= p225.Scalar and (p224.Kind == 2 and "CollisionFraction" or "ScalarState") or (p224.ObjectId ~= p225.ObjectId and (p224.Kind == 2 and "CollisionSource" or "SupportSource") or (p224.StateHash ~= p225.StateHash and (p224.Kind == 2 and "CollisionQueryInput" or "HiddenState") or (p224.AuxHash ~= p225.AuxHash and (p224.Kind == 2 and "CollisionResult" or "InputOrSupport") or nil)))))));
end;

function u1.describe(p226) -- Line: 614
    -- upvalues: u1 (copy), readEvent (copy), u3 (copy), table_freeze_ret (copy)
    if u1.identity(p226) == nil or typeof(p226) ~= "buffer" then
        return nil;
    end;

    local buffer_readu8_ret = buffer.readu8(p226, 2);
    local table_create_ret = table.create(buffer_readu8_ret);

    for i = 1, buffer_readu8_ret do
        local v227 = readEvent(p226, i);
        local v228 = u3[v227.SiteId];
        local v229 = {
            Index = i
        };
        local v230;

        if v228 == nil then
            v230 = string.format("site-0x%08X", v227.SiteId);
        else
            v230 = v228.Label;
        end;

        v229.Label = v230;
        local v231;

        if v228 == nil then
            v231 = table_freeze_ret[v227.SourceId] or "unknown";
        else
            v231 = v228.Source;
        end;

        v229.Source = v231;
        v229.Event = v227;
        table_create_ret[i] = v229;
        local _ = i;
    end;

    return table_create_ret;
end;

function u1.compare(p232: buffer, p233: buffer) -- Line: 634
    -- upvalues: u1 (copy), readEvent (copy), eventClass (copy), u3 (copy), table_freeze_ret (copy)
    local v234, v235, v236 = u1.identity(p232);
    local v237, v238, v239 = u1.identity(p233);

    if v234 == nil or (v237 == nil or (v234 ~= v237 or (v235 ~= v238 or v236 ~= v239))) then
        return nil;
    end;

    local buffer_readu8_ret = buffer.readu8(p232, 2);
    local buffer_readu8_ret2 = buffer.readu8(p233, 2);
    local buffer_readu8_ret3 = buffer.readu8(p232, 1);
    local v240 = bit32.band(buffer_readu8_ret3, 1) ~= 0;
    local buffer_readu8_ret4 = buffer.readu8(p233, 1);
    local v241 = bit32.band(buffer_readu8_ret4, 1) ~= 0;
    local math_min_ret = math.min(buffer_readu8_ret, buffer_readu8_ret2);

    for i = 1, math_min_ret do
        local v242 = readEvent(p232, i);
        local v243 = readEvent(p233, i);
        local v244 = eventClass(v242, v243);

        if v244 ~= nil then
            local v245 = u3[v242.SiteId] or u3[v243.SiteId];
            local v246 = {
                Matched = false,
                Classification = v244,
                EventIndex = i
            };
            local v247;

            if v245 == nil then
                v247 = string.format("site-0x%08X", v242.SiteId);
            else
                v247 = v245.Label;
            end;

            v246.Label = v247;
            v246.Source = v245 == nil and "unknown" or v245.Source;
            v246.ClientSource = table_freeze_ret[v242.SourceId] or "unknown";
            v246.ServerSource = table_freeze_ret[v243.SourceId] or "unknown";
            v246.Client = v242;
            v246.Server = v243;
            v246.ClientCount = buffer_readu8_ret;
            v246.ServerCount = buffer_readu8_ret2;
            v246.ClientOverflow = v240;
            v246.ServerOverflow = v241;

            return v246;
        end;

        local _ = i;
    end;

    if buffer_readu8_ret == buffer_readu8_ret2 and v240 == v241 then
        return {
            Matched = true,
            Classification = "NoRecordedDifference",
            Label = "trace-end",
            Source = "MovementV2.Simulation.DeterminismTrace",
            ClientSource = "trace-end",
            ServerSource = "trace-end",
            Client = nil,
            Server = nil,
            EventIndex = math_min_ret,
            ClientCount = buffer_readu8_ret,
            ServerCount = buffer_readu8_ret2,
            ClientOverflow = v240,
            ServerOverflow = v241
        };
    end;

    local v248 = math_min_ret + 1;
    local v249;

    if v248 <= buffer_readu8_ret then
        v249 = readEvent(p232, v248);
    else
        v249 = nil;
    end;

    local v250;

    if v248 <= buffer_readu8_ret2 then
        v250 = readEvent(p233, v248);
    else
        v250 = nil;
    end;

    local v251 = v249 or v250;
    local v252;

    if v251 == nil then
        v252 = nil;
    else
        v252 = u3[v251.SiteId];
    end;

    local v253 = {
        Matched = false,
        Classification = (v240 or v241) and "TraceOverflow" or "ControlFlowLength",
        EventIndex = math_min_ret + 1
    };
    local v254;

    if v252 == nil then
        v254 = v251 == nil and "trace-end" or string.format("site-0x%08X", v251.SiteId);
    else
        v254 = v252.Label;
    end;

    v253.Label = v254;
    v253.Source = v252 == nil and "MovementV2.Simulation.DeterminismTrace" or v252.Source;
    v253.ClientSource = v249 == nil and "trace-end" or (table_freeze_ret[v249.SourceId] or "unknown");
    v253.ServerSource = v250 == nil and "trace-end" or (table_freeze_ret[v250.SourceId] or "unknown");
    v253.Client = v249;
    v253.Server = v250;
    v253.ClientCount = buffer_readu8_ret;
    v253.ServerCount = buffer_readu8_ret2;
    v253.ClientOverflow = v240;
    v253.ServerOverflow = v241;

    return v253;
end;

u1.Ring = u2;
u1.MaxEvents = 128;

return table.freeze(u1);