-- ReplicatedStorage.Components.Common.SurvivalBuyRules
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local Survival = require(ReplicatedStorage.Database.Custom.GameStats.Gamemodes.Survival);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local u11 = {
    BUY_STATION_RADIUS = 9,
    BUY_STATIONS_FOLDER = "BuyStation",
    BUY_STATION_TAG = "SurvivalBuyStation",
    BUY_STATION_ARRIVED_ATTRIBUTE = "ArrivedAt",
    BUY_STATION_DEPARTED_ATTRIBUTE = "DepartedAt",
    BUY_STATION_ARRIVE_SECONDS = 1.6,
    BUY_STATION_DEPART_SECONDS = 1.5,
    IsSurvival = IsSurvivalMode,

    GetArmorPool = function(p1: string) -- Line: 47, Name: GetArmorPool
        -- upvalues: IsSurvivalMode (copy)
        return p1 == "Kevlar + Helmet" and IsSurvivalMode() and 150 or 100;
    end,

    GetFullReserve = function(p2: table) -- Line: 55, Name: GetFullReserve
        -- upvalues: IsSurvivalMode (copy)
        local v3 = tonumber(p2.Capacity) or 0;

        if IsSurvivalMode() then
            return v3 * 2;
        end;

        return v3;
    end,

    IsSurvivalOnlyEquipment = function(p4: string) -- Line: 60, Name: IsSurvivalOnlyEquipment
        -- upvalues: Survival (copy)
        return Survival.SurvivalOnlyEquipment[p4] == true;
    end,

    IsSold = function(p5: string) -- Line: 65, Name: IsSold
        -- upvalues: Survival (copy), IsSurvivalMode (copy)
        local v6 = Survival.UnsoldItems[p5] and IsSurvivalMode();

        return not v6;
    end,

    GetGrenadeLimit = function(p7: string) -- Line: 71, Name: GetGrenadeLimit
        -- upvalues: Grenades (copy), IsSurvivalMode (copy)
        local v8 = Grenades[p7];

        return v8 and IsSurvivalMode() and (1 / 0) or v8;
    end,

    GetPrice = function(p9: string, p10: number) -- Line: 81, Name: GetPrice
        -- upvalues: IsSurvivalMode (copy), Survival (copy)
        if IsSurvivalMode() then
            return Survival.Prices[p9] or p10;
        end;

        return p10;
    end
};

function u11.GetMissingAmmo(p12: table) -- Line: 91
    -- upvalues: u11 (copy)
    local Properties = p12.Properties;

    if not (Properties and (typeof(Properties.Rounds) == "number" and typeof(Properties.Capacity) == "number")) then
        return 0;
    end;

    local FullReserve = u11.GetFullReserve(Properties);
    local v13;

    if typeof(p12.Rounds) == "number" then
        v13 = p12.Rounds;
    else
        v13 = Properties.Rounds;
    end;

    local v14;

    if typeof(p12.Capacity) == "number" then
        v14 = p12.Capacity;
    else
        v14 = FullReserve;
    end;

    return math.max(Properties.Rounds - v13, 0) + math.max(FullReserve - v14, 0);
end;

function u11.GetAmmoPrice(p15: table) -- Line: 104
    -- upvalues: u11 (copy)
    local v16 = 0;

    for _, v in pairs(p15) do
        local _items = v._items;

        if _items then
            for _, v2 in ipairs(_items) do
                local MissingAmmo = u11.GetMissingAmmo(v2);

                if MissingAmmo > 0 then
                    local Properties = v2.Properties;
                    local v17 = Properties.Rounds + u11.GetFullReserve(Properties);
                    local v18 = Properties.Rounds + Properties.Capacity;

                    if v17 > 0 and v18 > 0 then
                        local v19 = u11.GetPrice(v2.Name, tonumber(Properties.Cost) or 0) * 0.15;
                        v16 = v16 + math.max(v19, 50) * math.min(MissingAmmo / v18, v17 / v18);
                    end;
                end;
            end;
        end;
    end;

    if v16 <= 0 then
        return 0;
    end;

    local v20 = math.ceil(v16 / 10) * 10;

    return math.max(v20, 10);
end;

return u11;