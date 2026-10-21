-- ReplicatedStorage.Components.Common.GeneratorProtocol
-- Script path: ReplicatedStorage.Components.Common.GeneratorProtocol
-- Decompile time: 3.29 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    ASSET_NAME = "Generator",
    SPAWNS_FOLDER = "GeneratorSpawns",
    INTERACTABLE_FOLDER = "Interactable",
    GENERATORS_FOLDER = "Generators",
    KEY_ATTRIBUTE = "Generator",
    HEALTH_ATTRIBUTE = "Health",
    MAX_HEALTH_ATTRIBUTE = "MaxHealth",
    DESTROYED_ATTRIBUTE = "Destroyed",
    TAG = "SurvivalGenerator",
    TIER_TEXTURES = table.freeze({ "rbxassetid://82417477410867", "rbxassetid://84731451880094", "rbxassetid://82524592324406", "rbxassetid://136240493163749" }),
    TIER_THRESHOLDS = table.freeze({ 0.75, 0.5, 0.25 })
};

function u1.TierFor(p2: number, p3: number) -- Line: 36
    -- upvalues: u1 (copy)
    local v4 = p3 <= 0 and 0 or p2 / p3;

    for i, v in u1.TIER_THRESHOLDS do
        if v < v4 then
            return i;
        end;
    end;

    return #u1.TIER_THRESHOLDS + 1;
end;

return u1;