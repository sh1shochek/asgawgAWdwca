-- ReplicatedStorage.Components.Common.SurvivalCandy
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HordeProtocol = require(ReplicatedStorage.Components.Common.HordeProtocol);
local u1 = {
    COUNT_ATTRIBUTE = "SurvivalCandy",
    PROFILE_FIELD = "Halloween2026Candy",
    PIECES_PER_KILL = table.freeze({
        [HordeProtocol.ARCHETYPE_NORMAL] = 2.6,
        [HordeProtocol.ARCHETYPE_HEAVY] = 7.8,
        [HordeProtocol.ARCHETYPE_FLAMING_HEAVY] = 7.8
    }),
    MAX_PIECES = 16,
    LIFETIME = 30,
    SERVER_GRACE = 3,
    MAGNET_RADIUS = 16,
    MAGNET_VERTICAL = 8,
    CLAIM_RADIUS = 40,
    TEMPLATE_FOLDER = "HalloweenCandies",
    KINDS = table.freeze({ "CandyCorn", "HardCandy", "ChocolateBar" }),
    MESH_IDS = table.freeze({
        CandyCorn = 81252871358159,
        ChocolateBar = 72250444065685,
        HardCandy = 91317282706948
    }),
    COLOR_MAP_ID = 126067301498450
};

function u1.RollPieces(p2: number, p3: userdata) -- Line: 64
    -- upvalues: u1 (copy), HordeProtocol (copy)
    local v4 = u1.PIECES_PER_KILL[p2] or u1.PIECES_PER_KILL[HordeProtocol.ARCHETYPE_NORMAL];
    local math_floor_ret = math.floor(v4);
    local v5 = p3:NextNumber() < v4 - math_floor_ret and 1 or 0;

    return math.clamp(math_floor_ret + v5, 0, u1.MAX_PIECES);
end;

return table.freeze(u1);