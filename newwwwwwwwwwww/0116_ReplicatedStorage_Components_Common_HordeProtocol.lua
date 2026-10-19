-- HordeProtocol (ModuleScript)
-- full path: ReplicatedStorage.Components.Common.HordeProtocol

-- Decompiled with Potassium's decompiler.

local Config = require(game:GetService("ReplicatedStorage").MovementV2.Simulation.Config);
local v1 = {
    STREAM_REMOTE = "HordeStream",
    HITBOX_FOLDER = "Horde",
    SPAWNS_FOLDER = "ZombieSpawns",
    SHELL_FOLDER = "HordeShells",
    ID_ATTRIBUTE = "HordeId",
    ZOMBIE_CHARACTER_FOLDER = "Zombies",
    ARCHETYPE_NORMAL = 1,
    ARCHETYPE_HEAVY = 2,
    ARCHETYPE_FLAMING = 3,
    ARCHETYPE_FLAMING_HEAVY = 4
};
v1.ARCHETYPE_FOLDERS = table.freeze({
    [v1.ARCHETYPE_NORMAL] = "Normal",
    [v1.ARCHETYPE_HEAVY] = "Heavy",
    [v1.ARCHETYPE_FLAMING] = "Flaming",
    [v1.ARCHETYPE_FLAMING_HEAVY] = "Heavy"
});
v1.ARCHETYPE_BURSTS = table.freeze({
    [v1.ARCHETYPE_FLAMING] = true,
    [v1.ARCHETYPE_FLAMING_HEAVY] = true
});
v1.POSITION_SCALE = 20;
v1.HEADER_BYTES = 10;
v1.BYTES_PER_ZOMBIE = 10;
v1.HEALTH_STEPS = 31;
v1.STATE_IDLE = 0;
v1.STATE_WALK = 1;
v1.STATE_RUN = 2;
v1.STATE_ATTACK = 3;
v1.STATE_DEAD = 4;
v1.STATE_STUNNED = 5;
v1.STATE_AIRBORNE = 6;
v1.LINK_GRAVITY = Config.Default.Gravity;
local POSITION_SCALE = v1.POSITION_SCALE;

function v1.modelName(p2: number) -- Line: 88
    return `Zombie{p2}`;
end;

function v1.writeHeader(p3: buffer, p4: number, p5: number) -- Line: 93
    buffer.writeu16(p3, 0, p4);
    buffer.writef64(p3, 2, p5);
end;

function v1.readHeader(p6: buffer) -- Line: 99
    return buffer.readu16(p6, 0), buffer.readf64(p6, 2);
end;

function v1.writeRecord(p7: buffer, p8: number, p9: number, p10: number, p11: number, p12: number, p13: number, p14: number, p15: number) -- Line: 104
    -- upvalues: POSITION_SCALE (copy)
    buffer.writeu16(p7, p8, p9);
    local math_round_ret = math.round(p10 * POSITION_SCALE);
    local math_clamp_ret = math.clamp(math_round_ret, -32768, 32767);
    buffer.writei16(p7, p8 + 2, math_clamp_ret);
    local math_round_ret2 = math.round(p11 * POSITION_SCALE);
    local math_clamp_ret2 = math.clamp(math_round_ret2, -32768, 32767);
    buffer.writei16(p7, p8 + 4, math_clamp_ret2);
    local math_round_ret3 = math.round(p12 * POSITION_SCALE);
    local math_clamp_ret3 = math.clamp(math_round_ret3, -32768, 32767);
    buffer.writei16(p7, p8 + 6, math_clamp_ret3);
    local math_floor_ret = math.floor(p13 % 6.283185307179586 / 6.283185307179586 * 255 + 0.5);
    buffer.writeu8(p7, p8 + 8, math_floor_ret);
    buffer.writeu8(p7, p8 + 9, p14 + p15 * 8);
end;

function v1.readRecord(p16: buffer, p17: number) -- Line: 124
    -- upvalues: POSITION_SCALE (copy)
    local buffer_readu16_ret = buffer.readu16(p16, p17);
    local v18 = buffer.readi16(p16, p17 + 2) / POSITION_SCALE;
    local v19 = buffer.readi16(p16, p17 + 4) / POSITION_SCALE;
    local v20 = buffer.readi16(p16, p17 + 6) / POSITION_SCALE;
    local v21 = buffer.readu8(p16, p17 + 8) / 255 * 6.283185307179586;
    local buffer_readu8_ret = buffer.readu8(p16, p17 + 9);

    return buffer_readu16_ret, v18, v19, v20, v21, buffer_readu8_ret % 8, buffer_readu8_ret // 8;
end;

return v1;