-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local v1 = RunService:IsStudio();
local v2 = not RunService:IsServer() and 0 or game.PrivateServerOwnerId;
local table_freeze_ret = table.freeze({
    UnrankedComp = 89844875164241,
    Deathmatch = 107028954108065,
    Defusal = 100334860793031,
    Tutorial = 0
});
local table_freeze_ret2 = table.freeze({
    UnrankedComp = 108194354348181,
    Deathmatch = 135434213652028,
    Defusal = 114234929420007,
    Tutorial = 135154320945903
});
local table_freeze_ret3 = table.freeze({
    Mobile = table.freeze({
        UnrankedComp = 128037611684480,
        Deathmatch = 103953226898816,
        Defusal = 75364289796924
    }),
    Console = table.freeze({
        UnrankedComp = 132331296438894,
        Deathmatch = 122102693569834,
        Defusal = 86299871106535
    })
});

local function isInGamemodeSubplaceSet(p3, p4) -- Line: 45
    for _, v in pairs(p4) do
        if v == p3 then
            return true;
        end;
    end;

    return false;
end;

local function getDevicePlatform(p5) -- Line: 56
    -- upvalues: table_freeze_ret3 (copy)
    local v6 = false;

    for _, v in pairs(table_freeze_ret3.Mobile) do
        if v == p5 then
            v6 = true;
            break;
        end;
    end;

    if v6 then
        return "Mobile";
    end;

    local v7 = false;

    for _, v in pairs(table_freeze_ret3.Console) do
        if v == p5 then
            v7 = true;
            break;
        end;
    end;

    return v7 and "Console" or nil;
end;

local function getActivePlaceEnvironment(p8) -- Line: 68
    -- upvalues: table_freeze_ret (copy), table_freeze_ret2 (copy), table_freeze_ret3 (copy)
    local v9 = false;

    for _, v in pairs(table_freeze_ret) do
        if v == p8 then
            v9 = true;
            break;
        end;
    end;

    if v9 then
        return "Dev";
    end;

    local v10 = false;

    for _, v in pairs(table_freeze_ret2) do
        if v == p8 then
            v10 = true;
            break;
        end;
    end;

    if not v10 then
        local v11 = false;

        for _, v in pairs(table_freeze_ret3.Mobile) do
            if v == p8 then
                v11 = true;
                break;
            end;
        end;

        local v12;

        if v11 then
            v12 = "Mobile";
        else
            local v13 = false;

            for _, v in pairs(table_freeze_ret3.Console) do
                if v == p8 then
                    v13 = true;
                    break;
                end;
            end;

            v12 = v13 and "Console" or nil;
        end;

        if v12 == nil and game.GameId ~= 7633926880 then
            return "Dev";
        end;
    end;

    return "Prod";
end;

local game_PlaceId = game.PlaceId;

local function getDeviceServerPlaceId(p14: string, p15: number) -- Line: 100
    -- upvalues: table_freeze_ret3 (copy), table_freeze_ret2 (copy)
    local v16 = table_freeze_ret3[p14];

    if not v16 then
        return nil;
    end;

    for i, v in pairs(table_freeze_ret2) do
        if v == p15 and v16[i] then
            return v16[i];
        end;
    end;

    return nil;
end;

local function getActiveGamemodeSubplaceIds(p17: string, p18: string?) -- Line: 81
    -- upvalues: table_freeze_ret (copy), table_freeze_ret2 (copy), table_freeze_ret3 (copy)
    if p17 == "Dev" then
        return table_freeze_ret;
    end;

    if not p18 then
        return table_freeze_ret2;
    end;

    local v19 = table_freeze_ret3[p18];

    return table.freeze({
        UnrankedComp = v19.UnrankedComp,
        Deathmatch = v19.Deathmatch,
        Defusal = v19.Defusal,
        Tutorial = table_freeze_ret2.Tutorial
    });
end;

local v20 = false;

for _, v in pairs(table_freeze_ret3.Mobile) do
    if v == game_PlaceId then
        v20 = true;
        break;
    end;
end;

local v21;

if v20 then
    v21 = "Mobile";
else
    local v22 = false;

    for _, v in pairs(table_freeze_ret3.Console) do
        if v == game_PlaceId then
            v22 = true;
            break;
        end;
    end;

    if v22 then
        v21 = "Console";
    else
        v21 = nil;
    end;
end;

local game_PlaceId2 = game.PlaceId;
local v23 = false;

for _, v in pairs(table_freeze_ret) do
    if v == game_PlaceId2 then
        v23 = true;
        break;
    end;
end;

local v24;

if v23 then
    v24 = "Dev";
else
    local v25 = false;

    for _, v in pairs(table_freeze_ret2) do
        if v == game_PlaceId2 then
            v25 = true;
            break;
        end;
    end;

    if v25 then
        v24 = "Prod";
    else
        local v26 = false;

        for _, v in pairs(table_freeze_ret3.Mobile) do
            if v == game_PlaceId2 then
                v26 = true;
                break;
            end;
        end;

        local v27;

        if v26 then
            v27 = "Mobile";
        else
            local v28 = false;

            for _, v in pairs(table_freeze_ret3.Console) do
                if v == game_PlaceId2 then
                    v28 = true;
                    break;
                end;
            end;

            if v28 then
                v27 = "Console";
            else
                v27 = nil;
            end;
        end;

        if v27 == nil and game.GameId ~= 7633926880 then
            v24 = "Dev";
        else
            v24 = "Prod";
        end;
    end;
end;

local u29 = getActiveGamemodeSubplaceIds(v24, v21);
local UnrankedComp = u29.UnrankedComp;
local u30 = (UnrankedComp == u29.Defusal or not UnrankedComp) and 0 or UnrankedComp;

local function getActiveGamemode(p31) -- Line: 127
    -- upvalues: u29 (copy), u30 (copy), table_freeze_ret (copy), table_freeze_ret2 (copy)
    if p31 == 101836176558619 then
        return "trading";
    end;

    if p31 == u29.Deathmatch then
        return "deathmatch";
    end;

    if p31 == u29.Defusal then
        return "casual";
    end;

    if u30 ~= 0 and p31 == u30 then
        return "competitive";
    end;

    if u29.Tutorial ~= 0 and p31 == u29.Tutorial then
        return "tutorial";
    end;

    for _, v in { table_freeze_ret, table_freeze_ret2 } do
        if p31 == v.Deathmatch then
            return "deathmatch";
        end;

        if p31 == v.Defusal then
            return "casual";
        end;

        if v.UnrankedComp ~= v.Defusal and p31 == v.UnrankedComp then
            return "competitive";
        end;

        if v.Tutorial ~= 0 and p31 == v.Tutorial then
            return "tutorial";
        end;
    end;

    return "casual";
end;

local table_freeze_ret4 = table.freeze({
    Competitive = "competitive",
    Deathmatch = "deathmatch",
    Casual = "casual"
});

return table.freeze({
    SHOP_VERSION = "1.0.1",
    VERSION = "1.3",
    MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION = 100000,
    MARKETPLACE_MAX_LISTING_PRICE = 100000000,
    MARKET_TAX_PERCENT = 5,
    DEFAULT_CAMERA_FOV = 70,
    PRODUCTION_UNIVERSE_ID = 7633926880,
    TRADING_PLACE_ID = 101836176558619,
    TUTORIAL_TELEPORT_ENABLED = false,
    BLACK_MARKET_ENABLED = false,
    ITEM_CATEGORIES = table.freeze({ "All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous" }),
    MARKETPLACE_SORTING_OPTIONS = table.freeze({ "Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float" }),
    INVENTORY_SORTING_OPTIONS = table.freeze({ "Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial" }),
    ACTIVE_EVENTS = {
        ["MEDAL.TV"] = false
    },
    EVENT_END_TIMES = {
        ["MEDAL.TV"] = os.time({
            year = 2026,
            month = 3,
            day = 1,
            hour = 0,
            min = 0,
            sec = 0
        })
    },

    GetGamemodeFromServerGamemode = function(p32) -- Line: 171, Name: getGamemodeFromServerGamemode
        -- upvalues: table_freeze_ret4 (copy), getActiveGamemode (copy)
        if typeof(p32) == "string" and table_freeze_ret4[p32] then
            return table_freeze_ret4[p32];
        end;

        return getActiveGamemode(game.PlaceId);
    end,

    SESSION_DATA = {
        VIP_SERVER_OWNER = v2 > 0 and v2 and v2 or nil,
        PRIVATE_SERVER_ID = v1 and "Studio" or game.PrivateServerId,
        JOB_ID = v1 and "Studio" or game.JobId,
        GAMEMODE = getActiveGamemode(game.PlaceId),
        UNIVERSE_ID = game.GameId,
        PLACE_ID = game.PlaceId
    },
    VIP_MENU_PANEL_WHITELIST = { 363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611 },
    AIM_ASSIST_CONFIGS = {
        PLAYER = {
            TargetSelection = {
                Enabled = true,
                MaxDistance = 125,
                MaxAngle = 0.5235987755982988
            },
            Friction = {
                Enabled = true,
                BubbleRadius = 2.4,
                MinSensitivity = 0.5,
                MaxSensitivity = 1
            },
            Magnetism = {
                Enabled = true,
                MaxAngleHorizontal = 0.20943951023931956,
                MaxAngleVertical = 0.10471975511965978,
                PullStrength = 0.11344640137963143,
                StopThreshold = 0.008726646259971648,
                MaxDistance = 125
            },
            VerticalMagnetism = {
                Enabled = true,
                MaxAngleHorizontal = 0.20943951023931956,
                MaxAngleVertical = 0.10471975511965978,
                PullStrength = 0.11344640137963143,
                StopThreshold = 0.008726646259971648,
                MaxDistance = 125
            },
            RecoilAssist = {
                Enabled = true,
                ReductionAmount = 0.5,
                HorizontalReductionAmount = 0.85,
                RequiresTarget = false
            }
        }
    },
    PROMOTIONAL_REWARD_CREDITS = table.freeze({
        Notifications = 15,
        FavoriteGame = 15,
        InviteFriend = 15,
        JoinGroup = 15,
        LikeGame = 15
    }),
    ACTIVE_PLACE_ENVIRONMENT = v24,
    GAMEMODE_SUBPLACE_IDS = {
        Prod = table_freeze_ret2,
        Dev = table_freeze_ret
    },
    ACTIVE_GAMEMODE_SUBPLACE_IDS = u29,
    GAMEMODE_PLACE_IDS = {
        Trading = 101836176558619,
        Deathmatch = u29.Deathmatch,
        Casual = u29.Defusal,
        Competitive = u30,
        Tutorial = u29.Tutorial
    },
    DEVICE_GAMEMODE_SUBPLACE_IDS = table_freeze_ret3,
    ACTIVE_DEVICE_PLATFORM = v21,
    IS_DEVICE_SERVER = v21 ~= nil,
    GetDeviceServerPlaceId = getDeviceServerPlaceId
});