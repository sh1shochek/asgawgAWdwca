-- ReplicatedStorage.Database.Custom.Constants
-- Script path: ReplicatedStorage.Database.Custom.Constants
-- Decompile time: 222.74 ms

local Defusal, PlaceId_2, UnrankedComp, freeze_2, getActiveGamemode, u209, u213, u244, v1, v2, v3, v4, v5
local RunService = game:GetService("RunService")
local v6 = RunService:IsStudio()
local PrivateServerOwnerId = if not RunService:IsServer() then 0 else game.PrivateServerOwnerId
local u16 = table.freeze({UnrankedComp = 89844875164241, Deathmatch = 107028954108065, Defusal = 100334860793031, Tutorial = 0})
local u19 = table.freeze({
    UnrankedComp = 108194354348181,
    Deathmatch = 135434213652028,
    Defusal = 114234929420007,
    Tutorial = 135154320945903,
})
local u28 = table.freeze({
    Mobile = table.freeze({UnrankedComp = 128037611684480, Deathmatch = 103953226898816, Defusal = 75364289796924}),
    Console = table.freeze({UnrankedComp = 132331296438894, Deathmatch = 122102693569834, Defusal = 86299871106535}),
})

local function isInGamemodeSubplaceSet(a1, a2) -- Line: 45
    for k, v in pairs(a2) do
        if v == a1 then
            return true
        end
    end
    return false
end

local function getDevicePlatform(a1) -- Line: 56 -- upvalues: u28 (val)
    for k, v in pairs(u28.Mobile) do
        if v == a1 then
            if true then
                return "Mobile"
            end
            for k2, i in pairs(u28.Console) do
                if i == a1 then
                    if true then
                        return "Console"
                    end
                    return nil
                end
            end
            if false then
                return "Console"
            end
            return nil
        end
    end
    if false then
        return "Mobile"
    end
    for k3, j in pairs(u28.Console) do
        if j == a1 then
            if true then
                return "Console"
            end
            return nil
        end
    end
    if false then
        return "Console"
    end
    return nil
end

local function getActivePlaceEnvironment(a1) -- Line: 68 -- upvalues: u16 (val), u19 (val), u28 (val)
    local v1
    for k, v in pairs(u16) do
        if v == a1 then
            if true then
                return "Dev"
            end
            for k2, i in pairs(u19) do
                if i == a1 then
                    v1 = true
                    if not v1 then
                        for k3, j in pairs(u28.Mobile) do
                            if j == a1 then
                                if false then
                                    for k4, k5 in pairs(u28.Console) do
                                        if k5 == a1 then
                                            if false then
                                                return "Dev"
                                            end
                                            return "Prod"
                                        end
                                    end
                                    v1 = nil
                                else
                                    v1 = "Mobile"
                                end
                                if v1 == nil and game.GameId ~= 7633926880 then
                                    return "Dev"
                                end
                                return "Prod"
                            end
                        end
                        if true then
                            for k6, n in pairs(u28.Console) do
                                if n == a1 then
                                    if false then
                                        return "Dev"
                                    end
                                    return "Prod"
                                end
                            end
                            v1 = nil
                        else
                            v1 = "Mobile"
                        end
                        if v1 == nil and game.GameId ~= 7633926880 then
                            return "Dev"
                        end
                    end
                    return "Prod"
                end
            end
            v1 = false
            if not v1 then
                for k7, m in pairs(u28.Mobile) do
                    if m == a1 then
                        if false then
                            for k8, i5 in pairs(u28.Console) do
                                if i5 == a1 then
                                    if false then
                                        return "Dev"
                                    end
                                    return "Prod"
                                end
                            end
                            v1 = nil
                        else
                            v1 = "Mobile"
                        end
                        if v1 == nil and game.GameId ~= 7633926880 then
                            return "Dev"
                        end
                        return "Prod"
                    end
                end
                if true then
                    for k9, i6 in pairs(u28.Console) do
                        if i6 == a1 then
                            if false then
                                return "Dev"
                            end
                            return "Prod"
                        end
                    end
                    v1 = nil
                else
                    v1 = "Mobile"
                end
                if v1 == nil and game.GameId ~= 7633926880 then
                    return "Dev"
                end
            end
            return "Prod"
        end
    end
    if false then
        return "Dev"
    end
    for k10, i7 in pairs(u19) do
        if i7 == a1 then
            v1 = true
            if not v1 then
                for k11, i8 in pairs(u28.Mobile) do
                    if i8 == a1 then
                        if false then
                            for k12, i9 in pairs(u28.Console) do
                                if i9 == a1 then
                                    if false then
                                        return "Dev"
                                    end
                                    return "Prod"
                                end
                            end
                            v1 = nil
                        else
                            v1 = "Mobile"
                        end
                        if v1 == nil and game.GameId ~= 7633926880 then
                            return "Dev"
                        end
                        return "Prod"
                    end
                end
                if true then
                    for k13, i10 in pairs(u28.Console) do
                        if i10 == a1 then
                            if false then
                                return "Dev"
                            end
                            return "Prod"
                        end
                    end
                    v1 = nil
                else
                    v1 = "Mobile"
                end
                if v1 == nil and game.GameId ~= 7633926880 then
                    return "Dev"
                end
            end
            return "Prod"
        end
    end
    v1 = false
    if not v1 then
        for k14, i11 in pairs(u28.Mobile) do
            if i11 == a1 then
                if false then
                    for k15, i12 in pairs(u28.Console) do
                        if i12 == a1 then
                            if false then
                                return "Dev"
                            end
                            return "Prod"
                        end
                    end
                    v1 = nil
                else
                    v1 = "Mobile"
                end
                if v1 == nil and game.GameId ~= 7633926880 then
                    return "Dev"
                end
                return "Prod"
            end
        end
        if true then
            for k16, i13 in pairs(u28.Console) do
                if i13 == a1 then
                    if false then
                        return "Dev"
                    end
                    return "Prod"
                end
            end
            v1 = nil
        else
            v1 = "Mobile"
        end
        if v1 == nil and game.GameId ~= 7633926880 then
            return "Dev"
        end
    end
    return "Prod"
end

local function getActiveGamemodeSubplaceIds(a1, a2) -- Line: 81
    -- upvalues: u16 (val), u19 (val), u28 (val)
    if a1 == "Dev" then
        return u16
    end
    if not a2 then
        return u19
    end
    local v1 = u28[a2]
    return table.freeze({
        UnrankedComp = v1.UnrankedComp,
        Deathmatch = v1.Deathmatch,
        Defusal = v1.Defusal,
        Tutorial = u19.Tutorial,
    })
end

local function getDeviceServerPlaceId(a1, a2) -- Line: 100
    -- upvalues: u28 (val), u19 (val)
    local v1 = u28[a1]
    if not v1 then
        return nil
    end
    for k, v in pairs(u19) do
        if v == a2 and v1[k] then
            return v1[k]
        end
    end
    return nil
end

local PlaceId = game.PlaceId
for k12, i9 in pairs(u28.Mobile) do
    if i9 == PlaceId then
        if false then
            for k13, i10 in pairs(u28.Console) do
                if i10 == PlaceId then
                    v1 = "Console"
                    PlaceId_2 = game.PlaceId
                    for k14, i11 in pairs(u16) do
                        if i11 == PlaceId_2 then
                            v3 = true
                            if not v3 then
                                for k15, i12 in pairs(u19) do
                                    if i12 == PlaceId_2 then
                                        v3 = true
                                        if v3 then
                                            v2 = "Prod"
                                        else
                                            for k16, i13 in pairs(u28.Mobile) do
                                                if i13 == PlaceId_2 then
                                                    if false then
                                                        for k17, i14 in pairs(u28.Console) do
                                                            if i14 == PlaceId_2 then
                                                                u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                                Defusal = u209.Defusal
                                                                UnrankedComp = u209.UnrankedComp
                                                                if UnrankedComp == Defusal then
                                                                    u213 = 0
                                                                else
                                                                    u213 = UnrankedComp
                                                                    if not u213 then
                                                                        u213 = 0
                                                                    end
                                                                end

                                                                function getActiveGamemode(a1) -- Line: 127
                                                                    -- upvalues: u209 (val), u213 (val), u16 (val)
                                                                    -- upvalues: u19 (val)
                                                                    if a1 == 101836176558619 then
                                                                        return "trading"
                                                                    end
                                                                    if a1 == u209.Deathmatch then
                                                                        return "deathmatch"
                                                                    end
                                                                    if a1 == u209.Defusal then
                                                                        return "casual"
                                                                    end
                                                                    if u213 ~= 0 and a1 == u213 then
                                                                        return "competitive"
                                                                    end
                                                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                                        return "tutorial"
                                                                    end
                                                                    local v1 = {u16, u19}
                                                                    local v2 = nil
                                                                    local v3 = nil
                                                                    local v4 = a1
                                                                    for i, j in v1, v2, v3 do
                                                                        if v4 == j.Deathmatch then
                                                                            return "deathmatch"
                                                                        end
                                                                        if v4 == j.Defusal then
                                                                            return "casual"
                                                                        end
                                                                        if j.UnrankedComp ~= j.Defusal
                                                                            and v4 == j.UnrankedComp then
                                                                            return "competitive"
                                                                        end
                                                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                                            return "tutorial"
                                                                        end
                                                                    end
                                                                    return "casual"
                                                                end

                                                                u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                                freeze_2 = table.freeze
                                                                v4 = {
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
                                                                    ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                                }
                                                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                                v4.EVENT_END_TIMES = {
                                                                    ["MEDAL.TV"] = os.time({
                                                                        year = 2026,
                                                                        month = 3,
                                                                        day = 1,
                                                                        hour = 0,
                                                                        min = 0,
                                                                        sec = 0,
                                                                    }),
                                                                }

                                                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                                                    if typeof(a1) == "string" and u244[a1] then
                                                                        return u244[a1]
                                                                    end
                                                                    return (getActiveGamemode(game.PlaceId))
                                                                end

                                                                v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                                v5.UNIVERSE_ID = game.GameId
                                                                v5.PLACE_ID = game.PlaceId
                                                                v4.SESSION_DATA = v5
                                                                v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                                v4.AIM_ASSIST_CONFIGS = {
                                                                    PLAYER = {
                                                                        TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                                        Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                                        Magnetism = {
                                                                            Enabled = true,
                                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                                            MaxAngleVertical = 0.10471975511965978,
                                                                            PullStrength = 0.11344640137963143,
                                                                            StopThreshold = 0.008726646259971648,
                                                                            MaxDistance = 125,
                                                                        },
                                                                        VerticalMagnetism = {
                                                                            Enabled = true,
                                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                                            MaxAngleVertical = 0.10471975511965978,
                                                                            PullStrength = 0.11344640137963143,
                                                                            StopThreshold = 0.008726646259971648,
                                                                            MaxDistance = 125,
                                                                        },
                                                                        RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                                    },
                                                                }
                                                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                                    Notifications = 15,
                                                                    FavoriteGame = 15,
                                                                    InviteFriend = 15,
                                                                    JoinGroup = 15,
                                                                    LikeGame = 15,
                                                                })
                                                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                                v4.GAMEMODE_PLACE_IDS = {
                                                                    Trading = 101836176558619,
                                                                    Deathmatch = u209.Deathmatch,
                                                                    Casual = u209.Defusal,
                                                                    Competitive = u213,
                                                                    Tutorial = u209.Tutorial,
                                                                }
                                                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                                return freeze_2(v4)
                                                            end
                                                        end
                                                        v3 = nil
                                                    else
                                                        v3 = "Mobile"
                                                    end
                                                    u209 = getActiveGamemodeSubplaceIds(
                                                        if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                                        v1
                                                    )
                                                    Defusal = u209.Defusal
                                                    UnrankedComp = u209.UnrankedComp
                                                    if UnrankedComp == Defusal then
                                                        u213 = 0
                                                    else
                                                        u213 = UnrankedComp
                                                        if not u213 then
                                                            u213 = 0
                                                        end
                                                    end

                                                    function getActiveGamemode(a1) -- Line: 127
                                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                        if a1 == 101836176558619 then
                                                            return "trading"
                                                        end
                                                        if a1 == u209.Deathmatch then
                                                            return "deathmatch"
                                                        end
                                                        if a1 == u209.Defusal then
                                                            return "casual"
                                                        end
                                                        if u213 ~= 0 and a1 == u213 then
                                                            return "competitive"
                                                        end
                                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                            return "tutorial"
                                                        end
                                                        local v1 = {u16, u19}
                                                        local v2 = nil
                                                        local v3 = nil
                                                        local v4 = a1
                                                        for i, j in v1, v2, v3 do
                                                            if v4 == j.Deathmatch then
                                                                return "deathmatch"
                                                            end
                                                            if v4 == j.Defusal then
                                                                return "casual"
                                                            end
                                                            if j.UnrankedComp ~= j.Defusal
                                                                and v4 == j.UnrankedComp then
                                                                return "competitive"
                                                            end
                                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                                return "tutorial"
                                                            end
                                                        end
                                                        return "casual"
                                                    end

                                                    u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                    freeze_2 = table.freeze
                                                    v4 = {
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
                                                    }
                                                    v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                    v4.EVENT_END_TIMES = {
                                                        ["MEDAL.TV"] = os.time({
                                                            year = 2026,
                                                            month = 3,
                                                            day = 1,
                                                            hour = 0,
                                                            min = 0,
                                                            sec = 0,
                                                        }),
                                                    }

                                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                                        if typeof(a1) == "string" and u244[a1] then
                                                            return u244[a1]
                                                        end
                                                        return (getActiveGamemode(game.PlaceId))
                                                    end

                                                    v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                    v5.UNIVERSE_ID = game.GameId
                                                    v5.PLACE_ID = game.PlaceId
                                                    v4.SESSION_DATA = v5
                                                    v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                    v4.AIM_ASSIST_CONFIGS = {
                                                        PLAYER = {
                                                            TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                            Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                            Magnetism = {
                                                                Enabled = true,
                                                                MaxAngleHorizontal = 0.20943951023931956,
                                                                MaxAngleVertical = 0.10471975511965978,
                                                                PullStrength = 0.11344640137963143,
                                                                StopThreshold = 0.008726646259971648,
                                                                MaxDistance = 125,
                                                            },
                                                            VerticalMagnetism = {
                                                                Enabled = true,
                                                                MaxAngleHorizontal = 0.20943951023931956,
                                                                MaxAngleVertical = 0.10471975511965978,
                                                                PullStrength = 0.11344640137963143,
                                                                StopThreshold = 0.008726646259971648,
                                                                MaxDistance = 125,
                                                            },
                                                            RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                        },
                                                    }
                                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                        Notifications = 15,
                                                        FavoriteGame = 15,
                                                        InviteFriend = 15,
                                                        JoinGroup = 15,
                                                        LikeGame = 15,
                                                    })
                                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                    v4.GAMEMODE_PLACE_IDS = {
                                                        Trading = 101836176558619,
                                                        Deathmatch = u209.Deathmatch,
                                                        Casual = u209.Defusal,
                                                        Competitive = u213,
                                                        Tutorial = u209.Tutorial,
                                                    }
                                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                    return freeze_2(v4)
                                                end
                                            end
                                            if true then
                                                for k18, i15 in pairs(u28.Console) do
                                                    if i15 == PlaceId_2 then
                                                        u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                        Defusal = u209.Defusal
                                                        UnrankedComp = u209.UnrankedComp
                                                        if UnrankedComp == Defusal then
                                                            u213 = 0
                                                        else
                                                            u213 = UnrankedComp
                                                            if not u213 then
                                                                u213 = 0
                                                            end
                                                        end

                                                        function getActiveGamemode(a1) -- Line: 127
                                                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                            if a1 == 101836176558619 then
                                                                return "trading"
                                                            end
                                                            if a1 == u209.Deathmatch then
                                                                return "deathmatch"
                                                            end
                                                            if a1 == u209.Defusal then
                                                                return "casual"
                                                            end
                                                            if u213 ~= 0 and a1 == u213 then
                                                                return "competitive"
                                                            end
                                                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                                return "tutorial"
                                                            end
                                                            local v1 = {u16, u19}
                                                            local v2 = nil
                                                            local v3 = nil
                                                            local v4 = a1
                                                            for i, j in v1, v2, v3 do
                                                                if v4 == j.Deathmatch then
                                                                    return "deathmatch"
                                                                end
                                                                if v4 == j.Defusal then
                                                                    return "casual"
                                                                end
                                                                if j.UnrankedComp ~= j.Defusal
                                                                    and v4 == j.UnrankedComp then
                                                                    return "competitive"
                                                                end
                                                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                                    return "tutorial"
                                                                end
                                                            end
                                                            return "casual"
                                                        end

                                                        u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                        freeze_2 = table.freeze
                                                        v4 = {
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
                                                            ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                        }
                                                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                        v4.EVENT_END_TIMES = {
                                                            ["MEDAL.TV"] = os.time({
                                                                year = 2026,
                                                                month = 3,
                                                                day = 1,
                                                                hour = 0,
                                                                min = 0,
                                                                sec = 0,
                                                            }),
                                                        }

                                                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                            -- upvalues: u244 (val), getActiveGamemode (val)
                                                            if typeof(a1) == "string" and u244[a1] then
                                                                return u244[a1]
                                                            end
                                                            return (getActiveGamemode(game.PlaceId))
                                                        end

                                                        v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                        v5.UNIVERSE_ID = game.GameId
                                                        v5.PLACE_ID = game.PlaceId
                                                        v4.SESSION_DATA = v5
                                                        v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                        v4.AIM_ASSIST_CONFIGS = {
                                                            PLAYER = {
                                                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                                Magnetism = {
                                                                    Enabled = true,
                                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                                    MaxAngleVertical = 0.10471975511965978,
                                                                    PullStrength = 0.11344640137963143,
                                                                    StopThreshold = 0.008726646259971648,
                                                                    MaxDistance = 125,
                                                                },
                                                                VerticalMagnetism = {
                                                                    Enabled = true,
                                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                                    MaxAngleVertical = 0.10471975511965978,
                                                                    PullStrength = 0.11344640137963143,
                                                                    StopThreshold = 0.008726646259971648,
                                                                    MaxDistance = 125,
                                                                },
                                                                RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                            },
                                                        }
                                                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                            Notifications = 15,
                                                            FavoriteGame = 15,
                                                            InviteFriend = 15,
                                                            JoinGroup = 15,
                                                            LikeGame = 15,
                                                        })
                                                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                        v4.GAMEMODE_PLACE_IDS = {
                                                            Trading = 101836176558619,
                                                            Deathmatch = u209.Deathmatch,
                                                            Casual = u209.Defusal,
                                                            Competitive = u213,
                                                            Tutorial = u209.Tutorial,
                                                        }
                                                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                        v4.ACTIVE_DEVICE_PLATFORM = v1
                                                        v4.IS_DEVICE_SERVER = v1 ~= nil
                                                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                        return freeze_2(v4)
                                                    end
                                                end
                                                v3 = nil
                                            else
                                                v3 = "Mobile"
                                            end
                                            v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                                        end
                                        u209 = getActiveGamemodeSubplaceIds(v2, v1)
                                        Defusal = u209.Defusal
                                        UnrankedComp = u209.UnrankedComp
                                        if UnrankedComp == Defusal then
                                            u213 = 0
                                        else
                                            u213 = UnrankedComp
                                            if not u213 then
                                                u213 = 0
                                            end
                                        end

                                        function getActiveGamemode(a1) -- Line: 127
                                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                            if a1 == 101836176558619 then
                                                return "trading"
                                            end
                                            if a1 == u209.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if a1 == u209.Defusal then
                                                return "casual"
                                            end
                                            if u213 ~= 0 and a1 == u213 then
                                                return "competitive"
                                            end
                                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                return "tutorial"
                                            end
                                            local v1 = {u16, u19}
                                            local v2 = nil
                                            local v3 = nil
                                            local v4 = a1
                                            for i, j in v1, v2, v3 do
                                                if v4 == j.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if v4 == j.Defusal then
                                                    return "casual"
                                                end
                                                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                    return "competitive"
                                                end
                                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                    return "tutorial"
                                                end
                                            end
                                            return "casual"
                                        end

                                        u244 = table.freeze({
                                            Competitive = "competitive",
                                            Deathmatch = "deathmatch",
                                            Casual = "casual",
                                        })
                                        freeze_2 = table.freeze
                                        v4 = {
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
                                        }
                                        v4.ITEM_CATEGORIES = table.freeze({
                                            "All",
                                            "Pistol",
                                            "SMG",
                                            "Rifle",
                                            "Heavy",
                                            "Equipment",
                                            "Miscellaneous",
                                        })
                                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Type",
                                            "Float",
                                        })
                                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Equipped",
                                            "Type",
                                            "Float",
                                            "Serial",
                                        })
                                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                        v4.EVENT_END_TIMES = {
                                            ["MEDAL.TV"] = os.time({
                                                year = 2026,
                                                month = 3,
                                                day = 1,
                                                hour = 0,
                                                min = 0,
                                                sec = 0,
                                            }),
                                        }

                                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                            -- upvalues: u244 (val), getActiveGamemode (val)
                                            if typeof(a1) == "string" and u244[a1] then
                                                return u244[a1]
                                            end
                                            return (getActiveGamemode(game.PlaceId))
                                        end

                                        v5 = {
                                            VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                        }
                                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                        v5.UNIVERSE_ID = game.GameId
                                        v5.PLACE_ID = game.PlaceId
                                        v4.SESSION_DATA = v5
                                        v4.VIP_MENU_PANEL_WHITELIST = {
                                            363101315,
                                            3659308968,
                                            1243042178,
                                            107643044,
                                            9236102964,
                                            38260227,
                                            40222641,
                                            3436218611,
                                        }
                                        v4.AIM_ASSIST_CONFIGS = {
                                            PLAYER = {
                                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                Magnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                VerticalMagnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                            },
                                        }
                                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                            Notifications = 15,
                                            FavoriteGame = 15,
                                            InviteFriend = 15,
                                            JoinGroup = 15,
                                            LikeGame = 15,
                                        })
                                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                        v4.GAMEMODE_PLACE_IDS = {
                                            Trading = 101836176558619,
                                            Deathmatch = u209.Deathmatch,
                                            Casual = u209.Defusal,
                                            Competitive = u213,
                                            Tutorial = u209.Tutorial,
                                        }
                                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                        v4.ACTIVE_DEVICE_PLATFORM = v1
                                        v4.IS_DEVICE_SERVER = v1 ~= nil
                                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                        return freeze_2(v4)
                                    end
                                end
                                v3 = false
                                if v3 then
                                    v2 = "Prod"
                                else
                                    for k19, i16 in pairs(u28.Mobile) do
                                        if i16 == PlaceId_2 then
                                            if false then
                                                for k20, i17 in pairs(u28.Console) do
                                                    if i17 == PlaceId_2 then
                                                        u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                        Defusal = u209.Defusal
                                                        UnrankedComp = u209.UnrankedComp
                                                        if UnrankedComp == Defusal then
                                                            u213 = 0
                                                        else
                                                            u213 = UnrankedComp
                                                            if not u213 then
                                                                u213 = 0
                                                            end
                                                        end

                                                        function getActiveGamemode(a1) -- Line: 127
                                                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                            if a1 == 101836176558619 then
                                                                return "trading"
                                                            end
                                                            if a1 == u209.Deathmatch then
                                                                return "deathmatch"
                                                            end
                                                            if a1 == u209.Defusal then
                                                                return "casual"
                                                            end
                                                            if u213 ~= 0 and a1 == u213 then
                                                                return "competitive"
                                                            end
                                                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                                return "tutorial"
                                                            end
                                                            local v1 = {u16, u19}
                                                            local v2 = nil
                                                            local v3 = nil
                                                            local v4 = a1
                                                            for i, j in v1, v2, v3 do
                                                                if v4 == j.Deathmatch then
                                                                    return "deathmatch"
                                                                end
                                                                if v4 == j.Defusal then
                                                                    return "casual"
                                                                end
                                                                if j.UnrankedComp ~= j.Defusal
                                                                    and v4 == j.UnrankedComp then
                                                                    return "competitive"
                                                                end
                                                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                                    return "tutorial"
                                                                end
                                                            end
                                                            return "casual"
                                                        end

                                                        u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                        freeze_2 = table.freeze
                                                        v4 = {
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
                                                            ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                        }
                                                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                        v4.EVENT_END_TIMES = {
                                                            ["MEDAL.TV"] = os.time({
                                                                year = 2026,
                                                                month = 3,
                                                                day = 1,
                                                                hour = 0,
                                                                min = 0,
                                                                sec = 0,
                                                            }),
                                                        }

                                                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                            -- upvalues: u244 (val), getActiveGamemode (val)
                                                            if typeof(a1) == "string" and u244[a1] then
                                                                return u244[a1]
                                                            end
                                                            return (getActiveGamemode(game.PlaceId))
                                                        end

                                                        v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                        v5.UNIVERSE_ID = game.GameId
                                                        v5.PLACE_ID = game.PlaceId
                                                        v4.SESSION_DATA = v5
                                                        v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                        v4.AIM_ASSIST_CONFIGS = {
                                                            PLAYER = {
                                                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                                Magnetism = {
                                                                    Enabled = true,
                                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                                    MaxAngleVertical = 0.10471975511965978,
                                                                    PullStrength = 0.11344640137963143,
                                                                    StopThreshold = 0.008726646259971648,
                                                                    MaxDistance = 125,
                                                                },
                                                                VerticalMagnetism = {
                                                                    Enabled = true,
                                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                                    MaxAngleVertical = 0.10471975511965978,
                                                                    PullStrength = 0.11344640137963143,
                                                                    StopThreshold = 0.008726646259971648,
                                                                    MaxDistance = 125,
                                                                },
                                                                RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                            },
                                                        }
                                                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                            Notifications = 15,
                                                            FavoriteGame = 15,
                                                            InviteFriend = 15,
                                                            JoinGroup = 15,
                                                            LikeGame = 15,
                                                        })
                                                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                        v4.GAMEMODE_PLACE_IDS = {
                                                            Trading = 101836176558619,
                                                            Deathmatch = u209.Deathmatch,
                                                            Casual = u209.Defusal,
                                                            Competitive = u213,
                                                            Tutorial = u209.Tutorial,
                                                        }
                                                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                        v4.ACTIVE_DEVICE_PLATFORM = v1
                                                        v4.IS_DEVICE_SERVER = v1 ~= nil
                                                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                        return freeze_2(v4)
                                                    end
                                                end
                                                v3 = nil
                                            else
                                                v3 = "Mobile"
                                            end
                                            u209 = getActiveGamemodeSubplaceIds(
                                                if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                                v1
                                            )
                                            Defusal = u209.Defusal
                                            UnrankedComp = u209.UnrankedComp
                                            if UnrankedComp == Defusal then
                                                u213 = 0
                                            else
                                                u213 = UnrankedComp
                                                if not u213 then
                                                    u213 = 0
                                                end
                                            end

                                            function getActiveGamemode(a1) -- Line: 127
                                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                if a1 == 101836176558619 then
                                                    return "trading"
                                                end
                                                if a1 == u209.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if a1 == u209.Defusal then
                                                    return "casual"
                                                end
                                                if u213 ~= 0 and a1 == u213 then
                                                    return "competitive"
                                                end
                                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                    return "tutorial"
                                                end
                                                local v1 = {u16, u19}
                                                local v2 = nil
                                                local v3 = nil
                                                local v4 = a1
                                                for i, j in v1, v2, v3 do
                                                    if v4 == j.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if v4 == j.Defusal then
                                                        return "casual"
                                                    end
                                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                        return "competitive"
                                                    end
                                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                        return "tutorial"
                                                    end
                                                end
                                                return "casual"
                                            end

                                            u244 = table.freeze({
                                                Competitive = "competitive",
                                                Deathmatch = "deathmatch",
                                                Casual = "casual",
                                            })
                                            freeze_2 = table.freeze
                                            v4 = {
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
                                            }
                                            v4.ITEM_CATEGORIES = table.freeze({
                                                "All",
                                                "Pistol",
                                                "SMG",
                                                "Rifle",
                                                "Heavy",
                                                "Equipment",
                                                "Miscellaneous",
                                            })
                                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Type",
                                                "Float",
                                            })
                                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Equipped",
                                                "Type",
                                                "Float",
                                                "Serial",
                                            })
                                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                            v4.EVENT_END_TIMES = {
                                                ["MEDAL.TV"] = os.time({
                                                    year = 2026,
                                                    month = 3,
                                                    day = 1,
                                                    hour = 0,
                                                    min = 0,
                                                    sec = 0,
                                                }),
                                            }

                                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                -- upvalues: u244 (val), getActiveGamemode (val)
                                                if typeof(a1) == "string" and u244[a1] then
                                                    return u244[a1]
                                                end
                                                return (getActiveGamemode(game.PlaceId))
                                            end

                                            v5 = {
                                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                            }
                                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                            v5.UNIVERSE_ID = game.GameId
                                            v5.PLACE_ID = game.PlaceId
                                            v4.SESSION_DATA = v5
                                            v4.VIP_MENU_PANEL_WHITELIST = {
                                                363101315,
                                                3659308968,
                                                1243042178,
                                                107643044,
                                                9236102964,
                                                38260227,
                                                40222641,
                                                3436218611,
                                            }
                                            v4.AIM_ASSIST_CONFIGS = {
                                                PLAYER = {
                                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                    Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                    Magnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    VerticalMagnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                },
                                            }
                                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                Notifications = 15,
                                                FavoriteGame = 15,
                                                InviteFriend = 15,
                                                JoinGroup = 15,
                                                LikeGame = 15,
                                            })
                                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                            v4.GAMEMODE_PLACE_IDS = {
                                                Trading = 101836176558619,
                                                Deathmatch = u209.Deathmatch,
                                                Casual = u209.Defusal,
                                                Competitive = u213,
                                                Tutorial = u209.Tutorial,
                                            }
                                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                            v4.ACTIVE_DEVICE_PLATFORM = v1
                                            v4.IS_DEVICE_SERVER = v1 ~= nil
                                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                            return freeze_2(v4)
                                        end
                                    end
                                    if true then
                                        for k21, i18 in pairs(u28.Console) do
                                            if i18 == PlaceId_2 then
                                                u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                Defusal = u209.Defusal
                                                UnrankedComp = u209.UnrankedComp
                                                if UnrankedComp == Defusal then
                                                    u213 = 0
                                                else
                                                    u213 = UnrankedComp
                                                    if not u213 then
                                                        u213 = 0
                                                    end
                                                end

                                                function getActiveGamemode(a1) -- Line: 127
                                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                    if a1 == 101836176558619 then
                                                        return "trading"
                                                    end
                                                    if a1 == u209.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if a1 == u209.Defusal then
                                                        return "casual"
                                                    end
                                                    if u213 ~= 0 and a1 == u213 then
                                                        return "competitive"
                                                    end
                                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                        return "tutorial"
                                                    end
                                                    local v1 = {u16, u19}
                                                    local v2 = nil
                                                    local v3 = nil
                                                    local v4 = a1
                                                    for i, j in v1, v2, v3 do
                                                        if v4 == j.Deathmatch then
                                                            return "deathmatch"
                                                        end
                                                        if v4 == j.Defusal then
                                                            return "casual"
                                                        end
                                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                            return "competitive"
                                                        end
                                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                            return "tutorial"
                                                        end
                                                    end
                                                    return "casual"
                                                end

                                                u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                freeze_2 = table.freeze
                                                v4 = {
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
                                                    ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                }
                                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                v4.EVENT_END_TIMES = {
                                                    ["MEDAL.TV"] = os.time({
                                                        year = 2026,
                                                        month = 3,
                                                        day = 1,
                                                        hour = 0,
                                                        min = 0,
                                                        sec = 0,
                                                    }),
                                                }

                                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                                    if typeof(a1) == "string" and u244[a1] then
                                                        return u244[a1]
                                                    end
                                                    return (getActiveGamemode(game.PlaceId))
                                                end

                                                v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                v5.UNIVERSE_ID = game.GameId
                                                v5.PLACE_ID = game.PlaceId
                                                v4.SESSION_DATA = v5
                                                v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                v4.AIM_ASSIST_CONFIGS = {
                                                    PLAYER = {
                                                        TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                        Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                        Magnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        VerticalMagnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                    },
                                                }
                                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                    Notifications = 15,
                                                    FavoriteGame = 15,
                                                    InviteFriend = 15,
                                                    JoinGroup = 15,
                                                    LikeGame = 15,
                                                })
                                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                v4.GAMEMODE_PLACE_IDS = {
                                                    Trading = 101836176558619,
                                                    Deathmatch = u209.Deathmatch,
                                                    Casual = u209.Defusal,
                                                    Competitive = u213,
                                                    Tutorial = u209.Tutorial,
                                                }
                                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                return freeze_2(v4)
                                            end
                                        end
                                        v3 = nil
                                    else
                                        v3 = "Mobile"
                                    end
                                    v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                                end
                            else
                                v2 = "Dev"
                            end
                            u209 = getActiveGamemodeSubplaceIds(v2, v1)
                            Defusal = u209.Defusal
                            UnrankedComp = u209.UnrankedComp
                            if UnrankedComp == Defusal then
                                u213 = 0
                            else
                                u213 = UnrankedComp
                                if not u213 then
                                    u213 = 0
                                end
                            end

                            function getActiveGamemode(a1) -- Line: 127
                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                if a1 == 101836176558619 then
                                    return "trading"
                                end
                                if a1 == u209.Deathmatch then
                                    return "deathmatch"
                                end
                                if a1 == u209.Defusal then
                                    return "casual"
                                end
                                if u213 ~= 0 and a1 == u213 then
                                    return "competitive"
                                end
                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                    return "tutorial"
                                end
                                local v1 = {u16, u19}
                                local v2 = nil
                                local v3 = nil
                                local v4 = a1
                                for i, j in v1, v2, v3 do
                                    if v4 == j.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if v4 == j.Defusal then
                                        return "casual"
                                    end
                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                        return "competitive"
                                    end
                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                        return "tutorial"
                                    end
                                end
                                return "casual"
                            end

                            u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                            freeze_2 = table.freeze
                            v4 = {
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
                            }
                            v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                "Quality",
                                "RAP",
                                "Newest",
                                "Alphabetical",
                                "Collection",
                                "Equipped",
                                "Type",
                                "Float",
                                "Serial",
                            })
                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                            v4.EVENT_END_TIMES = {
                                ["MEDAL.TV"] = os.time({
                                    year = 2026,
                                    month = 3,
                                    day = 1,
                                    hour = 0,
                                    min = 0,
                                    sec = 0,
                                }),
                            }

                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                -- upvalues: u244 (val), getActiveGamemode (val)
                                if typeof(a1) == "string" and u244[a1] then
                                    return u244[a1]
                                end
                                return (getActiveGamemode(game.PlaceId))
                            end

                            v5 = {
                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                            }
                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                            v5.UNIVERSE_ID = game.GameId
                            v5.PLACE_ID = game.PlaceId
                            v4.SESSION_DATA = v5
                            v4.VIP_MENU_PANEL_WHITELIST = {
                                363101315,
                                3659308968,
                                1243042178,
                                107643044,
                                9236102964,
                                38260227,
                                40222641,
                                3436218611,
                            }
                            v4.AIM_ASSIST_CONFIGS = {
                                PLAYER = {
                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                    Friction = {
                                        Enabled = true,
                                        BubbleRadius = 2.4,
                                        MinSensitivity = 0.5,
                                        MaxSensitivity = 1,
                                    },
                                    Magnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    VerticalMagnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    RecoilAssist = {
                                        Enabled = true,
                                        ReductionAmount = 0.5,
                                        HorizontalReductionAmount = 0.85,
                                        RequiresTarget = false,
                                    },
                                },
                            }
                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                Notifications = 15,
                                FavoriteGame = 15,
                                InviteFriend = 15,
                                JoinGroup = 15,
                                LikeGame = 15,
                            })
                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                            v4.GAMEMODE_PLACE_IDS = {
                                Trading = 101836176558619,
                                Deathmatch = u209.Deathmatch,
                                Casual = u209.Defusal,
                                Competitive = u213,
                                Tutorial = u209.Tutorial,
                            }
                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                            v4.ACTIVE_DEVICE_PLATFORM = v1
                            v4.IS_DEVICE_SERVER = v1 ~= nil
                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                            return freeze_2(v4)
                        end
                    end
                    v3 = false
                    if not v3 then
                        for k22, i19 in pairs(u19) do
                            if i19 == PlaceId_2 then
                                v3 = true
                                if v3 then
                                    v2 = "Prod"
                                else
                                    for k23, i20 in pairs(u28.Mobile) do
                                        if i20 == PlaceId_2 then
                                            if false then
                                                for k24, i21 in pairs(u28.Console) do
                                                    if i21 == PlaceId_2 then
                                                        u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                        Defusal = u209.Defusal
                                                        UnrankedComp = u209.UnrankedComp
                                                        if UnrankedComp == Defusal then
                                                            u213 = 0
                                                        else
                                                            u213 = UnrankedComp
                                                            if not u213 then
                                                                u213 = 0
                                                            end
                                                        end

                                                        function getActiveGamemode(a1) -- Line: 127
                                                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                            if a1 == 101836176558619 then
                                                                return "trading"
                                                            end
                                                            if a1 == u209.Deathmatch then
                                                                return "deathmatch"
                                                            end
                                                            if a1 == u209.Defusal then
                                                                return "casual"
                                                            end
                                                            if u213 ~= 0 and a1 == u213 then
                                                                return "competitive"
                                                            end
                                                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                                return "tutorial"
                                                            end
                                                            local v1 = {u16, u19}
                                                            local v2 = nil
                                                            local v3 = nil
                                                            local v4 = a1
                                                            for i, j in v1, v2, v3 do
                                                                if v4 == j.Deathmatch then
                                                                    return "deathmatch"
                                                                end
                                                                if v4 == j.Defusal then
                                                                    return "casual"
                                                                end
                                                                if j.UnrankedComp ~= j.Defusal
                                                                    and v4 == j.UnrankedComp then
                                                                    return "competitive"
                                                                end
                                                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                                    return "tutorial"
                                                                end
                                                            end
                                                            return "casual"
                                                        end

                                                        u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                        freeze_2 = table.freeze
                                                        v4 = {
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
                                                            ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                        }
                                                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                        v4.EVENT_END_TIMES = {
                                                            ["MEDAL.TV"] = os.time({
                                                                year = 2026,
                                                                month = 3,
                                                                day = 1,
                                                                hour = 0,
                                                                min = 0,
                                                                sec = 0,
                                                            }),
                                                        }

                                                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                            -- upvalues: u244 (val), getActiveGamemode (val)
                                                            if typeof(a1) == "string" and u244[a1] then
                                                                return u244[a1]
                                                            end
                                                            return (getActiveGamemode(game.PlaceId))
                                                        end

                                                        v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                        v5.UNIVERSE_ID = game.GameId
                                                        v5.PLACE_ID = game.PlaceId
                                                        v4.SESSION_DATA = v5
                                                        v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                        v4.AIM_ASSIST_CONFIGS = {
                                                            PLAYER = {
                                                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                                Magnetism = {
                                                                    Enabled = true,
                                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                                    MaxAngleVertical = 0.10471975511965978,
                                                                    PullStrength = 0.11344640137963143,
                                                                    StopThreshold = 0.008726646259971648,
                                                                    MaxDistance = 125,
                                                                },
                                                                VerticalMagnetism = {
                                                                    Enabled = true,
                                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                                    MaxAngleVertical = 0.10471975511965978,
                                                                    PullStrength = 0.11344640137963143,
                                                                    StopThreshold = 0.008726646259971648,
                                                                    MaxDistance = 125,
                                                                },
                                                                RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                            },
                                                        }
                                                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                            Notifications = 15,
                                                            FavoriteGame = 15,
                                                            InviteFriend = 15,
                                                            JoinGroup = 15,
                                                            LikeGame = 15,
                                                        })
                                                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                        v4.GAMEMODE_PLACE_IDS = {
                                                            Trading = 101836176558619,
                                                            Deathmatch = u209.Deathmatch,
                                                            Casual = u209.Defusal,
                                                            Competitive = u213,
                                                            Tutorial = u209.Tutorial,
                                                        }
                                                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                        v4.ACTIVE_DEVICE_PLATFORM = v1
                                                        v4.IS_DEVICE_SERVER = v1 ~= nil
                                                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                        return freeze_2(v4)
                                                    end
                                                end
                                                v3 = nil
                                            else
                                                v3 = "Mobile"
                                            end
                                            u209 = getActiveGamemodeSubplaceIds(
                                                if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                                v1
                                            )
                                            Defusal = u209.Defusal
                                            UnrankedComp = u209.UnrankedComp
                                            if UnrankedComp == Defusal then
                                                u213 = 0
                                            else
                                                u213 = UnrankedComp
                                                if not u213 then
                                                    u213 = 0
                                                end
                                            end

                                            function getActiveGamemode(a1) -- Line: 127
                                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                if a1 == 101836176558619 then
                                                    return "trading"
                                                end
                                                if a1 == u209.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if a1 == u209.Defusal then
                                                    return "casual"
                                                end
                                                if u213 ~= 0 and a1 == u213 then
                                                    return "competitive"
                                                end
                                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                    return "tutorial"
                                                end
                                                local v1 = {u16, u19}
                                                local v2 = nil
                                                local v3 = nil
                                                local v4 = a1
                                                for i, j in v1, v2, v3 do
                                                    if v4 == j.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if v4 == j.Defusal then
                                                        return "casual"
                                                    end
                                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                        return "competitive"
                                                    end
                                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                        return "tutorial"
                                                    end
                                                end
                                                return "casual"
                                            end

                                            u244 = table.freeze({
                                                Competitive = "competitive",
                                                Deathmatch = "deathmatch",
                                                Casual = "casual",
                                            })
                                            freeze_2 = table.freeze
                                            v4 = {
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
                                            }
                                            v4.ITEM_CATEGORIES = table.freeze({
                                                "All",
                                                "Pistol",
                                                "SMG",
                                                "Rifle",
                                                "Heavy",
                                                "Equipment",
                                                "Miscellaneous",
                                            })
                                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Type",
                                                "Float",
                                            })
                                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Equipped",
                                                "Type",
                                                "Float",
                                                "Serial",
                                            })
                                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                            v4.EVENT_END_TIMES = {
                                                ["MEDAL.TV"] = os.time({
                                                    year = 2026,
                                                    month = 3,
                                                    day = 1,
                                                    hour = 0,
                                                    min = 0,
                                                    sec = 0,
                                                }),
                                            }

                                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                -- upvalues: u244 (val), getActiveGamemode (val)
                                                if typeof(a1) == "string" and u244[a1] then
                                                    return u244[a1]
                                                end
                                                return (getActiveGamemode(game.PlaceId))
                                            end

                                            v5 = {
                                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                            }
                                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                            v5.UNIVERSE_ID = game.GameId
                                            v5.PLACE_ID = game.PlaceId
                                            v4.SESSION_DATA = v5
                                            v4.VIP_MENU_PANEL_WHITELIST = {
                                                363101315,
                                                3659308968,
                                                1243042178,
                                                107643044,
                                                9236102964,
                                                38260227,
                                                40222641,
                                                3436218611,
                                            }
                                            v4.AIM_ASSIST_CONFIGS = {
                                                PLAYER = {
                                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                    Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                    Magnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    VerticalMagnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                },
                                            }
                                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                Notifications = 15,
                                                FavoriteGame = 15,
                                                InviteFriend = 15,
                                                JoinGroup = 15,
                                                LikeGame = 15,
                                            })
                                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                            v4.GAMEMODE_PLACE_IDS = {
                                                Trading = 101836176558619,
                                                Deathmatch = u209.Deathmatch,
                                                Casual = u209.Defusal,
                                                Competitive = u213,
                                                Tutorial = u209.Tutorial,
                                            }
                                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                            v4.ACTIVE_DEVICE_PLATFORM = v1
                                            v4.IS_DEVICE_SERVER = v1 ~= nil
                                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                            return freeze_2(v4)
                                        end
                                    end
                                    if true then
                                        for k25, i22 in pairs(u28.Console) do
                                            if i22 == PlaceId_2 then
                                                u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                Defusal = u209.Defusal
                                                UnrankedComp = u209.UnrankedComp
                                                if UnrankedComp == Defusal then
                                                    u213 = 0
                                                else
                                                    u213 = UnrankedComp
                                                    if not u213 then
                                                        u213 = 0
                                                    end
                                                end

                                                function getActiveGamemode(a1) -- Line: 127
                                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                    if a1 == 101836176558619 then
                                                        return "trading"
                                                    end
                                                    if a1 == u209.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if a1 == u209.Defusal then
                                                        return "casual"
                                                    end
                                                    if u213 ~= 0 and a1 == u213 then
                                                        return "competitive"
                                                    end
                                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                        return "tutorial"
                                                    end
                                                    local v1 = {u16, u19}
                                                    local v2 = nil
                                                    local v3 = nil
                                                    local v4 = a1
                                                    for i, j in v1, v2, v3 do
                                                        if v4 == j.Deathmatch then
                                                            return "deathmatch"
                                                        end
                                                        if v4 == j.Defusal then
                                                            return "casual"
                                                        end
                                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                            return "competitive"
                                                        end
                                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                            return "tutorial"
                                                        end
                                                    end
                                                    return "casual"
                                                end

                                                u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                freeze_2 = table.freeze
                                                v4 = {
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
                                                    ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                }
                                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                v4.EVENT_END_TIMES = {
                                                    ["MEDAL.TV"] = os.time({
                                                        year = 2026,
                                                        month = 3,
                                                        day = 1,
                                                        hour = 0,
                                                        min = 0,
                                                        sec = 0,
                                                    }),
                                                }

                                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                                    if typeof(a1) == "string" and u244[a1] then
                                                        return u244[a1]
                                                    end
                                                    return (getActiveGamemode(game.PlaceId))
                                                end

                                                v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                v5.UNIVERSE_ID = game.GameId
                                                v5.PLACE_ID = game.PlaceId
                                                v4.SESSION_DATA = v5
                                                v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                v4.AIM_ASSIST_CONFIGS = {
                                                    PLAYER = {
                                                        TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                        Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                        Magnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        VerticalMagnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                    },
                                                }
                                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                    Notifications = 15,
                                                    FavoriteGame = 15,
                                                    InviteFriend = 15,
                                                    JoinGroup = 15,
                                                    LikeGame = 15,
                                                })
                                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                v4.GAMEMODE_PLACE_IDS = {
                                                    Trading = 101836176558619,
                                                    Deathmatch = u209.Deathmatch,
                                                    Casual = u209.Defusal,
                                                    Competitive = u213,
                                                    Tutorial = u209.Tutorial,
                                                }
                                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                return freeze_2(v4)
                                            end
                                        end
                                        v3 = nil
                                    else
                                        v3 = "Mobile"
                                    end
                                    v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                                end
                                u209 = getActiveGamemodeSubplaceIds(v2, v1)
                                Defusal = u209.Defusal
                                UnrankedComp = u209.UnrankedComp
                                if UnrankedComp == Defusal then
                                    u213 = 0
                                else
                                    u213 = UnrankedComp
                                    if not u213 then
                                        u213 = 0
                                    end
                                end

                                function getActiveGamemode(a1) -- Line: 127
                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                    if a1 == 101836176558619 then
                                        return "trading"
                                    end
                                    if a1 == u209.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if a1 == u209.Defusal then
                                        return "casual"
                                    end
                                    if u213 ~= 0 and a1 == u213 then
                                        return "competitive"
                                    end
                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                        return "tutorial"
                                    end
                                    local v1 = {u16, u19}
                                    local v2 = nil
                                    local v3 = nil
                                    local v4 = a1
                                    for i, j in v1, v2, v3 do
                                        if v4 == j.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if v4 == j.Defusal then
                                            return "casual"
                                        end
                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                            return "competitive"
                                        end
                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                            return "tutorial"
                                        end
                                    end
                                    return "casual"
                                end

                                u244 = table.freeze({
                                    Competitive = "competitive",
                                    Deathmatch = "deathmatch",
                                    Casual = "casual",
                                })
                                freeze_2 = table.freeze
                                v4 = {
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
                                }
                                v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Type",
                                    "Float",
                                })
                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Equipped",
                                    "Type",
                                    "Float",
                                    "Serial",
                                })
                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                v4.EVENT_END_TIMES = {
                                    ["MEDAL.TV"] = os.time({
                                        year = 2026,
                                        month = 3,
                                        day = 1,
                                        hour = 0,
                                        min = 0,
                                        sec = 0,
                                    }),
                                }

                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                    if typeof(a1) == "string" and u244[a1] then
                                        return u244[a1]
                                    end
                                    return (getActiveGamemode(game.PlaceId))
                                end

                                v5 = {
                                    VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                }
                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                v5.UNIVERSE_ID = game.GameId
                                v5.PLACE_ID = game.PlaceId
                                v4.SESSION_DATA = v5
                                v4.VIP_MENU_PANEL_WHITELIST = {
                                    363101315,
                                    3659308968,
                                    1243042178,
                                    107643044,
                                    9236102964,
                                    38260227,
                                    40222641,
                                    3436218611,
                                }
                                v4.AIM_ASSIST_CONFIGS = {
                                    PLAYER = {
                                        TargetSelection = {
                                            Enabled = true,
                                            MaxDistance = 125,
                                            MaxAngle = 0.5235987755982988,
                                        },
                                        Friction = {
                                            Enabled = true,
                                            BubbleRadius = 2.4,
                                            MinSensitivity = 0.5,
                                            MaxSensitivity = 1,
                                        },
                                        Magnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        VerticalMagnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        RecoilAssist = {
                                            Enabled = true,
                                            ReductionAmount = 0.5,
                                            HorizontalReductionAmount = 0.85,
                                            RequiresTarget = false,
                                        },
                                    },
                                }
                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                    Notifications = 15,
                                    FavoriteGame = 15,
                                    InviteFriend = 15,
                                    JoinGroup = 15,
                                    LikeGame = 15,
                                })
                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                v4.GAMEMODE_PLACE_IDS = {
                                    Trading = 101836176558619,
                                    Deathmatch = u209.Deathmatch,
                                    Casual = u209.Defusal,
                                    Competitive = u213,
                                    Tutorial = u209.Tutorial,
                                }
                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                return freeze_2(v4)
                            end
                        end
                        v3 = false
                        if v3 then
                            v2 = "Prod"
                        else
                            for k26, i23 in pairs(u28.Mobile) do
                                if i23 == PlaceId_2 then
                                    if false then
                                        for k27, i24 in pairs(u28.Console) do
                                            if i24 == PlaceId_2 then
                                                u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                Defusal = u209.Defusal
                                                UnrankedComp = u209.UnrankedComp
                                                if UnrankedComp == Defusal then
                                                    u213 = 0
                                                else
                                                    u213 = UnrankedComp
                                                    if not u213 then
                                                        u213 = 0
                                                    end
                                                end

                                                function getActiveGamemode(a1) -- Line: 127
                                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                    if a1 == 101836176558619 then
                                                        return "trading"
                                                    end
                                                    if a1 == u209.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if a1 == u209.Defusal then
                                                        return "casual"
                                                    end
                                                    if u213 ~= 0 and a1 == u213 then
                                                        return "competitive"
                                                    end
                                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                        return "tutorial"
                                                    end
                                                    local v1 = {u16, u19}
                                                    local v2 = nil
                                                    local v3 = nil
                                                    local v4 = a1
                                                    for i, j in v1, v2, v3 do
                                                        if v4 == j.Deathmatch then
                                                            return "deathmatch"
                                                        end
                                                        if v4 == j.Defusal then
                                                            return "casual"
                                                        end
                                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                            return "competitive"
                                                        end
                                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                            return "tutorial"
                                                        end
                                                    end
                                                    return "casual"
                                                end

                                                u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                freeze_2 = table.freeze
                                                v4 = {
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
                                                    ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                }
                                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                v4.EVENT_END_TIMES = {
                                                    ["MEDAL.TV"] = os.time({
                                                        year = 2026,
                                                        month = 3,
                                                        day = 1,
                                                        hour = 0,
                                                        min = 0,
                                                        sec = 0,
                                                    }),
                                                }

                                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                                    if typeof(a1) == "string" and u244[a1] then
                                                        return u244[a1]
                                                    end
                                                    return (getActiveGamemode(game.PlaceId))
                                                end

                                                v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                v5.UNIVERSE_ID = game.GameId
                                                v5.PLACE_ID = game.PlaceId
                                                v4.SESSION_DATA = v5
                                                v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                v4.AIM_ASSIST_CONFIGS = {
                                                    PLAYER = {
                                                        TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                        Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                        Magnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        VerticalMagnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                    },
                                                }
                                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                    Notifications = 15,
                                                    FavoriteGame = 15,
                                                    InviteFriend = 15,
                                                    JoinGroup = 15,
                                                    LikeGame = 15,
                                                })
                                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                v4.GAMEMODE_PLACE_IDS = {
                                                    Trading = 101836176558619,
                                                    Deathmatch = u209.Deathmatch,
                                                    Casual = u209.Defusal,
                                                    Competitive = u213,
                                                    Tutorial = u209.Tutorial,
                                                }
                                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                return freeze_2(v4)
                                            end
                                        end
                                        v3 = nil
                                    else
                                        v3 = "Mobile"
                                    end
                                    u209 = getActiveGamemodeSubplaceIds(
                                        if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                        v1
                                    )
                                    Defusal = u209.Defusal
                                    UnrankedComp = u209.UnrankedComp
                                    if UnrankedComp == Defusal then
                                        u213 = 0
                                    else
                                        u213 = UnrankedComp
                                        if not u213 then
                                            u213 = 0
                                        end
                                    end

                                    function getActiveGamemode(a1) -- Line: 127
                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                        if a1 == 101836176558619 then
                                            return "trading"
                                        end
                                        if a1 == u209.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if a1 == u209.Defusal then
                                            return "casual"
                                        end
                                        if u213 ~= 0 and a1 == u213 then
                                            return "competitive"
                                        end
                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                            return "tutorial"
                                        end
                                        local v1 = {u16, u19}
                                        local v2 = nil
                                        local v3 = nil
                                        local v4 = a1
                                        for i, j in v1, v2, v3 do
                                            if v4 == j.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if v4 == j.Defusal then
                                                return "casual"
                                            end
                                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                return "competitive"
                                            end
                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                return "tutorial"
                                            end
                                        end
                                        return "casual"
                                    end

                                    u244 = table.freeze({
                                        Competitive = "competitive",
                                        Deathmatch = "deathmatch",
                                        Casual = "casual",
                                    })
                                    freeze_2 = table.freeze
                                    v4 = {
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
                                    }
                                    v4.ITEM_CATEGORIES = table.freeze({
                                        "All",
                                        "Pistol",
                                        "SMG",
                                        "Rifle",
                                        "Heavy",
                                        "Equipment",
                                        "Miscellaneous",
                                    })
                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Type",
                                        "Float",
                                    })
                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Equipped",
                                        "Type",
                                        "Float",
                                        "Serial",
                                    })
                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                    v4.EVENT_END_TIMES = {
                                        ["MEDAL.TV"] = os.time({
                                            year = 2026,
                                            month = 3,
                                            day = 1,
                                            hour = 0,
                                            min = 0,
                                            sec = 0,
                                        }),
                                    }

                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                        if typeof(a1) == "string" and u244[a1] then
                                            return u244[a1]
                                        end
                                        return (getActiveGamemode(game.PlaceId))
                                    end

                                    v5 = {
                                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                    }
                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                    v5.UNIVERSE_ID = game.GameId
                                    v5.PLACE_ID = game.PlaceId
                                    v4.SESSION_DATA = v5
                                    v4.VIP_MENU_PANEL_WHITELIST = {
                                        363101315,
                                        3659308968,
                                        1243042178,
                                        107643044,
                                        9236102964,
                                        38260227,
                                        40222641,
                                        3436218611,
                                    }
                                    v4.AIM_ASSIST_CONFIGS = {
                                        PLAYER = {
                                            TargetSelection = {
                                                Enabled = true,
                                                MaxDistance = 125,
                                                MaxAngle = 0.5235987755982988,
                                            },
                                            Friction = {
                                                Enabled = true,
                                                BubbleRadius = 2.4,
                                                MinSensitivity = 0.5,
                                                MaxSensitivity = 1,
                                            },
                                            Magnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            VerticalMagnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            RecoilAssist = {
                                                Enabled = true,
                                                ReductionAmount = 0.5,
                                                HorizontalReductionAmount = 0.85,
                                                RequiresTarget = false,
                                            },
                                        },
                                    }
                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                        Notifications = 15,
                                        FavoriteGame = 15,
                                        InviteFriend = 15,
                                        JoinGroup = 15,
                                        LikeGame = 15,
                                    })
                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                    v4.GAMEMODE_PLACE_IDS = {
                                        Trading = 101836176558619,
                                        Deathmatch = u209.Deathmatch,
                                        Casual = u209.Defusal,
                                        Competitive = u213,
                                        Tutorial = u209.Tutorial,
                                    }
                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                    return freeze_2(v4)
                                end
                            end
                            if true then
                                for k28, i25 in pairs(u28.Console) do
                                    if i25 == PlaceId_2 then
                                        u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                        Defusal = u209.Defusal
                                        UnrankedComp = u209.UnrankedComp
                                        if UnrankedComp == Defusal then
                                            u213 = 0
                                        else
                                            u213 = UnrankedComp
                                            if not u213 then
                                                u213 = 0
                                            end
                                        end

                                        function getActiveGamemode(a1) -- Line: 127
                                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                            if a1 == 101836176558619 then
                                                return "trading"
                                            end
                                            if a1 == u209.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if a1 == u209.Defusal then
                                                return "casual"
                                            end
                                            if u213 ~= 0 and a1 == u213 then
                                                return "competitive"
                                            end
                                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                return "tutorial"
                                            end
                                            local v1 = {u16, u19}
                                            local v2 = nil
                                            local v3 = nil
                                            local v4 = a1
                                            for i, j in v1, v2, v3 do
                                                if v4 == j.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if v4 == j.Defusal then
                                                    return "casual"
                                                end
                                                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                    return "competitive"
                                                end
                                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                    return "tutorial"
                                                end
                                            end
                                            return "casual"
                                        end

                                        u244 = table.freeze({
                                            Competitive = "competitive",
                                            Deathmatch = "deathmatch",
                                            Casual = "casual",
                                        })
                                        freeze_2 = table.freeze
                                        v4 = {
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
                                            ITEM_CATEGORIES = table.freeze({
                                                "All",
                                                "Pistol",
                                                "SMG",
                                                "Rifle",
                                                "Heavy",
                                                "Equipment",
                                                "Miscellaneous",
                                            }),
                                        }
                                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Type",
                                            "Float",
                                        })
                                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Equipped",
                                            "Type",
                                            "Float",
                                            "Serial",
                                        })
                                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                        v4.EVENT_END_TIMES = {
                                            ["MEDAL.TV"] = os.time({
                                                year = 2026,
                                                month = 3,
                                                day = 1,
                                                hour = 0,
                                                min = 0,
                                                sec = 0,
                                            }),
                                        }

                                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                            -- upvalues: u244 (val), getActiveGamemode (val)
                                            if typeof(a1) == "string" and u244[a1] then
                                                return u244[a1]
                                            end
                                            return (getActiveGamemode(game.PlaceId))
                                        end

                                        v5 = {
                                            VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                        }
                                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                        v5.UNIVERSE_ID = game.GameId
                                        v5.PLACE_ID = game.PlaceId
                                        v4.SESSION_DATA = v5
                                        v4.VIP_MENU_PANEL_WHITELIST = {
                                            363101315,
                                            3659308968,
                                            1243042178,
                                            107643044,
                                            9236102964,
                                            38260227,
                                            40222641,
                                            3436218611,
                                        }
                                        v4.AIM_ASSIST_CONFIGS = {
                                            PLAYER = {
                                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                Magnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                VerticalMagnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                            },
                                        }
                                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                            Notifications = 15,
                                            FavoriteGame = 15,
                                            InviteFriend = 15,
                                            JoinGroup = 15,
                                            LikeGame = 15,
                                        })
                                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                        v4.GAMEMODE_PLACE_IDS = {
                                            Trading = 101836176558619,
                                            Deathmatch = u209.Deathmatch,
                                            Casual = u209.Defusal,
                                            Competitive = u213,
                                            Tutorial = u209.Tutorial,
                                        }
                                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                        v4.ACTIVE_DEVICE_PLATFORM = v1
                                        v4.IS_DEVICE_SERVER = v1 ~= nil
                                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                        return freeze_2(v4)
                                    end
                                end
                                v3 = nil
                            else
                                v3 = "Mobile"
                            end
                            v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                        end
                    else
                        v2 = "Dev"
                    end
                    u209 = getActiveGamemodeSubplaceIds(v2, v1)
                    Defusal = u209.Defusal
                    UnrankedComp = u209.UnrankedComp
                    if UnrankedComp == Defusal then
                        u213 = 0
                    else
                        u213 = UnrankedComp
                        if not u213 then
                            u213 = 0
                        end
                    end

                    function getActiveGamemode(a1) -- Line: 127
                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                        if a1 == 101836176558619 then
                            return "trading"
                        end
                        if a1 == u209.Deathmatch then
                            return "deathmatch"
                        end
                        if a1 == u209.Defusal then
                            return "casual"
                        end
                        if u213 ~= 0 and a1 == u213 then
                            return "competitive"
                        end
                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                            return "tutorial"
                        end
                        local v1 = {u16, u19}
                        local v2 = nil
                        local v3 = nil
                        local v4 = a1
                        for i, j in v1, v2, v3 do
                            if v4 == j.Deathmatch then
                                return "deathmatch"
                            end
                            if v4 == j.Defusal then
                                return "casual"
                            end
                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                return "competitive"
                            end
                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                return "tutorial"
                            end
                        end
                        return "casual"
                    end

                    u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                    freeze_2 = table.freeze
                    v4 = {
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
                    }
                    v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                        "Quality",
                        "RAP",
                        "Newest",
                        "Alphabetical",
                        "Collection",
                        "Equipped",
                        "Type",
                        "Float",
                        "Serial",
                    })
                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                    v4.EVENT_END_TIMES = {
                        ["MEDAL.TV"] = os.time({
                            year = 2026,
                            month = 3,
                            day = 1,
                            hour = 0,
                            min = 0,
                            sec = 0,
                        }),
                    }

                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                        -- upvalues: u244 (val), getActiveGamemode (val)
                        if typeof(a1) == "string" and u244[a1] then
                            return u244[a1]
                        end
                        return (getActiveGamemode(game.PlaceId))
                    end

                    v5 = {
                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                    }
                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                    v5.UNIVERSE_ID = game.GameId
                    v5.PLACE_ID = game.PlaceId
                    v4.SESSION_DATA = v5
                    v4.VIP_MENU_PANEL_WHITELIST = {
                        363101315,
                        3659308968,
                        1243042178,
                        107643044,
                        9236102964,
                        38260227,
                        40222641,
                        3436218611,
                    }
                    v4.AIM_ASSIST_CONFIGS = {
                        PLAYER = {
                            TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                            Friction = {
                                Enabled = true,
                                BubbleRadius = 2.4,
                                MinSensitivity = 0.5,
                                MaxSensitivity = 1,
                            },
                            Magnetism = {
                                Enabled = true,
                                MaxAngleHorizontal = 0.20943951023931956,
                                MaxAngleVertical = 0.10471975511965978,
                                PullStrength = 0.11344640137963143,
                                StopThreshold = 0.008726646259971648,
                                MaxDistance = 125,
                            },
                            VerticalMagnetism = {
                                Enabled = true,
                                MaxAngleHorizontal = 0.20943951023931956,
                                MaxAngleVertical = 0.10471975511965978,
                                PullStrength = 0.11344640137963143,
                                StopThreshold = 0.008726646259971648,
                                MaxDistance = 125,
                            },
                            RecoilAssist = {
                                Enabled = true,
                                ReductionAmount = 0.5,
                                HorizontalReductionAmount = 0.85,
                                RequiresTarget = false,
                            },
                        },
                    }
                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                        Notifications = 15,
                        FavoriteGame = 15,
                        InviteFriend = 15,
                        JoinGroup = 15,
                        LikeGame = 15,
                    })
                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                    v4.GAMEMODE_PLACE_IDS = {
                        Trading = 101836176558619,
                        Deathmatch = u209.Deathmatch,
                        Casual = u209.Defusal,
                        Competitive = u213,
                        Tutorial = u209.Tutorial,
                    }
                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                    v4.ACTIVE_DEVICE_PLATFORM = v1
                    v4.IS_DEVICE_SERVER = v1 ~= nil
                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                    return freeze_2(v4)
                end
            end
            v1 = nil
        else
            v1 = "Mobile"
        end
        PlaceId_2 = game.PlaceId
        for k29, i26 in pairs(u16) do
            if i26 == PlaceId_2 then
                v3 = true
                if not v3 then
                    for k30, i27 in pairs(u19) do
                        if i27 == PlaceId_2 then
                            v3 = true
                            if v3 then
                                v2 = "Prod"
                            else
                                for k31, i28 in pairs(u28.Mobile) do
                                    if i28 == PlaceId_2 then
                                        if false then
                                            for k32, i29 in pairs(u28.Console) do
                                                if i29 == PlaceId_2 then
                                                    u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                    Defusal = u209.Defusal
                                                    UnrankedComp = u209.UnrankedComp
                                                    if UnrankedComp == Defusal then
                                                        u213 = 0
                                                    else
                                                        u213 = UnrankedComp
                                                        if not u213 then
                                                            u213 = 0
                                                        end
                                                    end

                                                    function getActiveGamemode(a1) -- Line: 127
                                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                        if a1 == 101836176558619 then
                                                            return "trading"
                                                        end
                                                        if a1 == u209.Deathmatch then
                                                            return "deathmatch"
                                                        end
                                                        if a1 == u209.Defusal then
                                                            return "casual"
                                                        end
                                                        if u213 ~= 0 and a1 == u213 then
                                                            return "competitive"
                                                        end
                                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                            return "tutorial"
                                                        end
                                                        local v1 = {u16, u19}
                                                        local v2 = nil
                                                        local v3 = nil
                                                        local v4 = a1
                                                        for i, j in v1, v2, v3 do
                                                            if v4 == j.Deathmatch then
                                                                return "deathmatch"
                                                            end
                                                            if v4 == j.Defusal then
                                                                return "casual"
                                                            end
                                                            if j.UnrankedComp ~= j.Defusal
                                                                and v4 == j.UnrankedComp then
                                                                return "competitive"
                                                            end
                                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                                return "tutorial"
                                                            end
                                                        end
                                                        return "casual"
                                                    end

                                                    u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                    freeze_2 = table.freeze
                                                    v4 = {
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
                                                        ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                    }
                                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                    v4.EVENT_END_TIMES = {
                                                        ["MEDAL.TV"] = os.time({
                                                            year = 2026,
                                                            month = 3,
                                                            day = 1,
                                                            hour = 0,
                                                            min = 0,
                                                            sec = 0,
                                                        }),
                                                    }

                                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                                        if typeof(a1) == "string" and u244[a1] then
                                                            return u244[a1]
                                                        end
                                                        return (getActiveGamemode(game.PlaceId))
                                                    end

                                                    v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                    v5.UNIVERSE_ID = game.GameId
                                                    v5.PLACE_ID = game.PlaceId
                                                    v4.SESSION_DATA = v5
                                                    v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                    v4.AIM_ASSIST_CONFIGS = {
                                                        PLAYER = {
                                                            TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                            Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                            Magnetism = {
                                                                Enabled = true,
                                                                MaxAngleHorizontal = 0.20943951023931956,
                                                                MaxAngleVertical = 0.10471975511965978,
                                                                PullStrength = 0.11344640137963143,
                                                                StopThreshold = 0.008726646259971648,
                                                                MaxDistance = 125,
                                                            },
                                                            VerticalMagnetism = {
                                                                Enabled = true,
                                                                MaxAngleHorizontal = 0.20943951023931956,
                                                                MaxAngleVertical = 0.10471975511965978,
                                                                PullStrength = 0.11344640137963143,
                                                                StopThreshold = 0.008726646259971648,
                                                                MaxDistance = 125,
                                                            },
                                                            RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                        },
                                                    }
                                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                        Notifications = 15,
                                                        FavoriteGame = 15,
                                                        InviteFriend = 15,
                                                        JoinGroup = 15,
                                                        LikeGame = 15,
                                                    })
                                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                    v4.GAMEMODE_PLACE_IDS = {
                                                        Trading = 101836176558619,
                                                        Deathmatch = u209.Deathmatch,
                                                        Casual = u209.Defusal,
                                                        Competitive = u213,
                                                        Tutorial = u209.Tutorial,
                                                    }
                                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                    return freeze_2(v4)
                                                end
                                            end
                                            v3 = nil
                                        else
                                            v3 = "Mobile"
                                        end
                                        u209 = getActiveGamemodeSubplaceIds(
                                            if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                            v1
                                        )
                                        Defusal = u209.Defusal
                                        UnrankedComp = u209.UnrankedComp
                                        if UnrankedComp == Defusal then
                                            u213 = 0
                                        else
                                            u213 = UnrankedComp
                                            if not u213 then
                                                u213 = 0
                                            end
                                        end

                                        function getActiveGamemode(a1) -- Line: 127
                                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                            if a1 == 101836176558619 then
                                                return "trading"
                                            end
                                            if a1 == u209.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if a1 == u209.Defusal then
                                                return "casual"
                                            end
                                            if u213 ~= 0 and a1 == u213 then
                                                return "competitive"
                                            end
                                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                return "tutorial"
                                            end
                                            local v1 = {u16, u19}
                                            local v2 = nil
                                            local v3 = nil
                                            local v4 = a1
                                            for i, j in v1, v2, v3 do
                                                if v4 == j.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if v4 == j.Defusal then
                                                    return "casual"
                                                end
                                                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                    return "competitive"
                                                end
                                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                    return "tutorial"
                                                end
                                            end
                                            return "casual"
                                        end

                                        u244 = table.freeze({
                                            Competitive = "competitive",
                                            Deathmatch = "deathmatch",
                                            Casual = "casual",
                                        })
                                        freeze_2 = table.freeze
                                        v4 = {
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
                                        }
                                        v4.ITEM_CATEGORIES = table.freeze({
                                            "All",
                                            "Pistol",
                                            "SMG",
                                            "Rifle",
                                            "Heavy",
                                            "Equipment",
                                            "Miscellaneous",
                                        })
                                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Type",
                                            "Float",
                                        })
                                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Equipped",
                                            "Type",
                                            "Float",
                                            "Serial",
                                        })
                                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                        v4.EVENT_END_TIMES = {
                                            ["MEDAL.TV"] = os.time({
                                                year = 2026,
                                                month = 3,
                                                day = 1,
                                                hour = 0,
                                                min = 0,
                                                sec = 0,
                                            }),
                                        }

                                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                            -- upvalues: u244 (val), getActiveGamemode (val)
                                            if typeof(a1) == "string" and u244[a1] then
                                                return u244[a1]
                                            end
                                            return (getActiveGamemode(game.PlaceId))
                                        end

                                        v5 = {
                                            VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                        }
                                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                        v5.UNIVERSE_ID = game.GameId
                                        v5.PLACE_ID = game.PlaceId
                                        v4.SESSION_DATA = v5
                                        v4.VIP_MENU_PANEL_WHITELIST = {
                                            363101315,
                                            3659308968,
                                            1243042178,
                                            107643044,
                                            9236102964,
                                            38260227,
                                            40222641,
                                            3436218611,
                                        }
                                        v4.AIM_ASSIST_CONFIGS = {
                                            PLAYER = {
                                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                Magnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                VerticalMagnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                            },
                                        }
                                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                            Notifications = 15,
                                            FavoriteGame = 15,
                                            InviteFriend = 15,
                                            JoinGroup = 15,
                                            LikeGame = 15,
                                        })
                                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                        v4.GAMEMODE_PLACE_IDS = {
                                            Trading = 101836176558619,
                                            Deathmatch = u209.Deathmatch,
                                            Casual = u209.Defusal,
                                            Competitive = u213,
                                            Tutorial = u209.Tutorial,
                                        }
                                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                        v4.ACTIVE_DEVICE_PLATFORM = v1
                                        v4.IS_DEVICE_SERVER = v1 ~= nil
                                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                        return freeze_2(v4)
                                    end
                                end
                                if true then
                                    for k33, i30 in pairs(u28.Console) do
                                        if i30 == PlaceId_2 then
                                            u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                            Defusal = u209.Defusal
                                            UnrankedComp = u209.UnrankedComp
                                            if UnrankedComp == Defusal then
                                                u213 = 0
                                            else
                                                u213 = UnrankedComp
                                                if not u213 then
                                                    u213 = 0
                                                end
                                            end

                                            function getActiveGamemode(a1) -- Line: 127
                                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                if a1 == 101836176558619 then
                                                    return "trading"
                                                end
                                                if a1 == u209.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if a1 == u209.Defusal then
                                                    return "casual"
                                                end
                                                if u213 ~= 0 and a1 == u213 then
                                                    return "competitive"
                                                end
                                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                    return "tutorial"
                                                end
                                                local v1 = {u16, u19}
                                                local v2 = nil
                                                local v3 = nil
                                                local v4 = a1
                                                for i, j in v1, v2, v3 do
                                                    if v4 == j.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if v4 == j.Defusal then
                                                        return "casual"
                                                    end
                                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                        return "competitive"
                                                    end
                                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                        return "tutorial"
                                                    end
                                                end
                                                return "casual"
                                            end

                                            u244 = table.freeze({
                                                Competitive = "competitive",
                                                Deathmatch = "deathmatch",
                                                Casual = "casual",
                                            })
                                            freeze_2 = table.freeze
                                            v4 = {
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
                                                ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                            }
                                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Type",
                                                "Float",
                                            })
                                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Equipped",
                                                "Type",
                                                "Float",
                                                "Serial",
                                            })
                                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                            v4.EVENT_END_TIMES = {
                                                ["MEDAL.TV"] = os.time({
                                                    year = 2026,
                                                    month = 3,
                                                    day = 1,
                                                    hour = 0,
                                                    min = 0,
                                                    sec = 0,
                                                }),
                                            }

                                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                -- upvalues: u244 (val), getActiveGamemode (val)
                                                if typeof(a1) == "string" and u244[a1] then
                                                    return u244[a1]
                                                end
                                                return (getActiveGamemode(game.PlaceId))
                                            end

                                            v5 = {
                                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                            }
                                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                            v5.UNIVERSE_ID = game.GameId
                                            v5.PLACE_ID = game.PlaceId
                                            v4.SESSION_DATA = v5
                                            v4.VIP_MENU_PANEL_WHITELIST = {
                                                363101315,
                                                3659308968,
                                                1243042178,
                                                107643044,
                                                9236102964,
                                                38260227,
                                                40222641,
                                                3436218611,
                                            }
                                            v4.AIM_ASSIST_CONFIGS = {
                                                PLAYER = {
                                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                    Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                    Magnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    VerticalMagnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                },
                                            }
                                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                Notifications = 15,
                                                FavoriteGame = 15,
                                                InviteFriend = 15,
                                                JoinGroup = 15,
                                                LikeGame = 15,
                                            })
                                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                            v4.GAMEMODE_PLACE_IDS = {
                                                Trading = 101836176558619,
                                                Deathmatch = u209.Deathmatch,
                                                Casual = u209.Defusal,
                                                Competitive = u213,
                                                Tutorial = u209.Tutorial,
                                            }
                                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                            v4.ACTIVE_DEVICE_PLATFORM = v1
                                            v4.IS_DEVICE_SERVER = v1 ~= nil
                                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                            return freeze_2(v4)
                                        end
                                    end
                                    v3 = nil
                                else
                                    v3 = "Mobile"
                                end
                                v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                            end
                            u209 = getActiveGamemodeSubplaceIds(v2, v1)
                            Defusal = u209.Defusal
                            UnrankedComp = u209.UnrankedComp
                            if UnrankedComp == Defusal then
                                u213 = 0
                            else
                                u213 = UnrankedComp
                                if not u213 then
                                    u213 = 0
                                end
                            end

                            function getActiveGamemode(a1) -- Line: 127
                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                if a1 == 101836176558619 then
                                    return "trading"
                                end
                                if a1 == u209.Deathmatch then
                                    return "deathmatch"
                                end
                                if a1 == u209.Defusal then
                                    return "casual"
                                end
                                if u213 ~= 0 and a1 == u213 then
                                    return "competitive"
                                end
                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                    return "tutorial"
                                end
                                local v1 = {u16, u19}
                                local v2 = nil
                                local v3 = nil
                                local v4 = a1
                                for i, j in v1, v2, v3 do
                                    if v4 == j.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if v4 == j.Defusal then
                                        return "casual"
                                    end
                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                        return "competitive"
                                    end
                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                        return "tutorial"
                                    end
                                end
                                return "casual"
                            end

                            u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                            freeze_2 = table.freeze
                            v4 = {
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
                            }
                            v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                "Quality",
                                "RAP",
                                "Newest",
                                "Alphabetical",
                                "Collection",
                                "Equipped",
                                "Type",
                                "Float",
                                "Serial",
                            })
                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                            v4.EVENT_END_TIMES = {
                                ["MEDAL.TV"] = os.time({
                                    year = 2026,
                                    month = 3,
                                    day = 1,
                                    hour = 0,
                                    min = 0,
                                    sec = 0,
                                }),
                            }

                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                -- upvalues: u244 (val), getActiveGamemode (val)
                                if typeof(a1) == "string" and u244[a1] then
                                    return u244[a1]
                                end
                                return (getActiveGamemode(game.PlaceId))
                            end

                            v5 = {
                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                            }
                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                            v5.UNIVERSE_ID = game.GameId
                            v5.PLACE_ID = game.PlaceId
                            v4.SESSION_DATA = v5
                            v4.VIP_MENU_PANEL_WHITELIST = {
                                363101315,
                                3659308968,
                                1243042178,
                                107643044,
                                9236102964,
                                38260227,
                                40222641,
                                3436218611,
                            }
                            v4.AIM_ASSIST_CONFIGS = {
                                PLAYER = {
                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                    Friction = {
                                        Enabled = true,
                                        BubbleRadius = 2.4,
                                        MinSensitivity = 0.5,
                                        MaxSensitivity = 1,
                                    },
                                    Magnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    VerticalMagnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    RecoilAssist = {
                                        Enabled = true,
                                        ReductionAmount = 0.5,
                                        HorizontalReductionAmount = 0.85,
                                        RequiresTarget = false,
                                    },
                                },
                            }
                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                Notifications = 15,
                                FavoriteGame = 15,
                                InviteFriend = 15,
                                JoinGroup = 15,
                                LikeGame = 15,
                            })
                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                            v4.GAMEMODE_PLACE_IDS = {
                                Trading = 101836176558619,
                                Deathmatch = u209.Deathmatch,
                                Casual = u209.Defusal,
                                Competitive = u213,
                                Tutorial = u209.Tutorial,
                            }
                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                            v4.ACTIVE_DEVICE_PLATFORM = v1
                            v4.IS_DEVICE_SERVER = v1 ~= nil
                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                            return freeze_2(v4)
                        end
                    end
                    v3 = false
                    if v3 then
                        v2 = "Prod"
                    else
                        for k34, i31 in pairs(u28.Mobile) do
                            if i31 == PlaceId_2 then
                                if false then
                                    for k35, i32 in pairs(u28.Console) do
                                        if i32 == PlaceId_2 then
                                            u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                            Defusal = u209.Defusal
                                            UnrankedComp = u209.UnrankedComp
                                            if UnrankedComp == Defusal then
                                                u213 = 0
                                            else
                                                u213 = UnrankedComp
                                                if not u213 then
                                                    u213 = 0
                                                end
                                            end

                                            function getActiveGamemode(a1) -- Line: 127
                                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                if a1 == 101836176558619 then
                                                    return "trading"
                                                end
                                                if a1 == u209.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if a1 == u209.Defusal then
                                                    return "casual"
                                                end
                                                if u213 ~= 0 and a1 == u213 then
                                                    return "competitive"
                                                end
                                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                    return "tutorial"
                                                end
                                                local v1 = {u16, u19}
                                                local v2 = nil
                                                local v3 = nil
                                                local v4 = a1
                                                for i, j in v1, v2, v3 do
                                                    if v4 == j.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if v4 == j.Defusal then
                                                        return "casual"
                                                    end
                                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                        return "competitive"
                                                    end
                                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                        return "tutorial"
                                                    end
                                                end
                                                return "casual"
                                            end

                                            u244 = table.freeze({
                                                Competitive = "competitive",
                                                Deathmatch = "deathmatch",
                                                Casual = "casual",
                                            })
                                            freeze_2 = table.freeze
                                            v4 = {
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
                                                ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                            }
                                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Type",
                                                "Float",
                                            })
                                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Equipped",
                                                "Type",
                                                "Float",
                                                "Serial",
                                            })
                                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                            v4.EVENT_END_TIMES = {
                                                ["MEDAL.TV"] = os.time({
                                                    year = 2026,
                                                    month = 3,
                                                    day = 1,
                                                    hour = 0,
                                                    min = 0,
                                                    sec = 0,
                                                }),
                                            }

                                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                -- upvalues: u244 (val), getActiveGamemode (val)
                                                if typeof(a1) == "string" and u244[a1] then
                                                    return u244[a1]
                                                end
                                                return (getActiveGamemode(game.PlaceId))
                                            end

                                            v5 = {
                                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                            }
                                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                            v5.UNIVERSE_ID = game.GameId
                                            v5.PLACE_ID = game.PlaceId
                                            v4.SESSION_DATA = v5
                                            v4.VIP_MENU_PANEL_WHITELIST = {
                                                363101315,
                                                3659308968,
                                                1243042178,
                                                107643044,
                                                9236102964,
                                                38260227,
                                                40222641,
                                                3436218611,
                                            }
                                            v4.AIM_ASSIST_CONFIGS = {
                                                PLAYER = {
                                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                    Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                    Magnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    VerticalMagnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                },
                                            }
                                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                Notifications = 15,
                                                FavoriteGame = 15,
                                                InviteFriend = 15,
                                                JoinGroup = 15,
                                                LikeGame = 15,
                                            })
                                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                            v4.GAMEMODE_PLACE_IDS = {
                                                Trading = 101836176558619,
                                                Deathmatch = u209.Deathmatch,
                                                Casual = u209.Defusal,
                                                Competitive = u213,
                                                Tutorial = u209.Tutorial,
                                            }
                                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                            v4.ACTIVE_DEVICE_PLATFORM = v1
                                            v4.IS_DEVICE_SERVER = v1 ~= nil
                                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                            return freeze_2(v4)
                                        end
                                    end
                                    v3 = nil
                                else
                                    v3 = "Mobile"
                                end
                                u209 = getActiveGamemodeSubplaceIds(
                                    if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                    v1
                                )
                                Defusal = u209.Defusal
                                UnrankedComp = u209.UnrankedComp
                                if UnrankedComp == Defusal then
                                    u213 = 0
                                else
                                    u213 = UnrankedComp
                                    if not u213 then
                                        u213 = 0
                                    end
                                end

                                function getActiveGamemode(a1) -- Line: 127
                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                    if a1 == 101836176558619 then
                                        return "trading"
                                    end
                                    if a1 == u209.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if a1 == u209.Defusal then
                                        return "casual"
                                    end
                                    if u213 ~= 0 and a1 == u213 then
                                        return "competitive"
                                    end
                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                        return "tutorial"
                                    end
                                    local v1 = {u16, u19}
                                    local v2 = nil
                                    local v3 = nil
                                    local v4 = a1
                                    for i, j in v1, v2, v3 do
                                        if v4 == j.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if v4 == j.Defusal then
                                            return "casual"
                                        end
                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                            return "competitive"
                                        end
                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                            return "tutorial"
                                        end
                                    end
                                    return "casual"
                                end

                                u244 = table.freeze({
                                    Competitive = "competitive",
                                    Deathmatch = "deathmatch",
                                    Casual = "casual",
                                })
                                freeze_2 = table.freeze
                                v4 = {
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
                                }
                                v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Type",
                                    "Float",
                                })
                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Equipped",
                                    "Type",
                                    "Float",
                                    "Serial",
                                })
                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                v4.EVENT_END_TIMES = {
                                    ["MEDAL.TV"] = os.time({
                                        year = 2026,
                                        month = 3,
                                        day = 1,
                                        hour = 0,
                                        min = 0,
                                        sec = 0,
                                    }),
                                }

                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                    if typeof(a1) == "string" and u244[a1] then
                                        return u244[a1]
                                    end
                                    return (getActiveGamemode(game.PlaceId))
                                end

                                v5 = {
                                    VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                }
                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                v5.UNIVERSE_ID = game.GameId
                                v5.PLACE_ID = game.PlaceId
                                v4.SESSION_DATA = v5
                                v4.VIP_MENU_PANEL_WHITELIST = {
                                    363101315,
                                    3659308968,
                                    1243042178,
                                    107643044,
                                    9236102964,
                                    38260227,
                                    40222641,
                                    3436218611,
                                }
                                v4.AIM_ASSIST_CONFIGS = {
                                    PLAYER = {
                                        TargetSelection = {
                                            Enabled = true,
                                            MaxDistance = 125,
                                            MaxAngle = 0.5235987755982988,
                                        },
                                        Friction = {
                                            Enabled = true,
                                            BubbleRadius = 2.4,
                                            MinSensitivity = 0.5,
                                            MaxSensitivity = 1,
                                        },
                                        Magnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        VerticalMagnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        RecoilAssist = {
                                            Enabled = true,
                                            ReductionAmount = 0.5,
                                            HorizontalReductionAmount = 0.85,
                                            RequiresTarget = false,
                                        },
                                    },
                                }
                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                    Notifications = 15,
                                    FavoriteGame = 15,
                                    InviteFriend = 15,
                                    JoinGroup = 15,
                                    LikeGame = 15,
                                })
                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                v4.GAMEMODE_PLACE_IDS = {
                                    Trading = 101836176558619,
                                    Deathmatch = u209.Deathmatch,
                                    Casual = u209.Defusal,
                                    Competitive = u213,
                                    Tutorial = u209.Tutorial,
                                }
                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                return freeze_2(v4)
                            end
                        end
                        if true then
                            for k36, i33 in pairs(u28.Console) do
                                if i33 == PlaceId_2 then
                                    u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                    Defusal = u209.Defusal
                                    UnrankedComp = u209.UnrankedComp
                                    if UnrankedComp == Defusal then
                                        u213 = 0
                                    else
                                        u213 = UnrankedComp
                                        if not u213 then
                                            u213 = 0
                                        end
                                    end

                                    function getActiveGamemode(a1) -- Line: 127
                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                        if a1 == 101836176558619 then
                                            return "trading"
                                        end
                                        if a1 == u209.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if a1 == u209.Defusal then
                                            return "casual"
                                        end
                                        if u213 ~= 0 and a1 == u213 then
                                            return "competitive"
                                        end
                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                            return "tutorial"
                                        end
                                        local v1 = {u16, u19}
                                        local v2 = nil
                                        local v3 = nil
                                        local v4 = a1
                                        for i, j in v1, v2, v3 do
                                            if v4 == j.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if v4 == j.Defusal then
                                                return "casual"
                                            end
                                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                return "competitive"
                                            end
                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                return "tutorial"
                                            end
                                        end
                                        return "casual"
                                    end

                                    u244 = table.freeze({
                                        Competitive = "competitive",
                                        Deathmatch = "deathmatch",
                                        Casual = "casual",
                                    })
                                    freeze_2 = table.freeze
                                    v4 = {
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
                                        ITEM_CATEGORIES = table.freeze({
                                            "All",
                                            "Pistol",
                                            "SMG",
                                            "Rifle",
                                            "Heavy",
                                            "Equipment",
                                            "Miscellaneous",
                                        }),
                                    }
                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Type",
                                        "Float",
                                    })
                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Equipped",
                                        "Type",
                                        "Float",
                                        "Serial",
                                    })
                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                    v4.EVENT_END_TIMES = {
                                        ["MEDAL.TV"] = os.time({
                                            year = 2026,
                                            month = 3,
                                            day = 1,
                                            hour = 0,
                                            min = 0,
                                            sec = 0,
                                        }),
                                    }

                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                        if typeof(a1) == "string" and u244[a1] then
                                            return u244[a1]
                                        end
                                        return (getActiveGamemode(game.PlaceId))
                                    end

                                    v5 = {
                                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                    }
                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                    v5.UNIVERSE_ID = game.GameId
                                    v5.PLACE_ID = game.PlaceId
                                    v4.SESSION_DATA = v5
                                    v4.VIP_MENU_PANEL_WHITELIST = {
                                        363101315,
                                        3659308968,
                                        1243042178,
                                        107643044,
                                        9236102964,
                                        38260227,
                                        40222641,
                                        3436218611,
                                    }
                                    v4.AIM_ASSIST_CONFIGS = {
                                        PLAYER = {
                                            TargetSelection = {
                                                Enabled = true,
                                                MaxDistance = 125,
                                                MaxAngle = 0.5235987755982988,
                                            },
                                            Friction = {
                                                Enabled = true,
                                                BubbleRadius = 2.4,
                                                MinSensitivity = 0.5,
                                                MaxSensitivity = 1,
                                            },
                                            Magnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            VerticalMagnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            RecoilAssist = {
                                                Enabled = true,
                                                ReductionAmount = 0.5,
                                                HorizontalReductionAmount = 0.85,
                                                RequiresTarget = false,
                                            },
                                        },
                                    }
                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                        Notifications = 15,
                                        FavoriteGame = 15,
                                        InviteFriend = 15,
                                        JoinGroup = 15,
                                        LikeGame = 15,
                                    })
                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                    v4.GAMEMODE_PLACE_IDS = {
                                        Trading = 101836176558619,
                                        Deathmatch = u209.Deathmatch,
                                        Casual = u209.Defusal,
                                        Competitive = u213,
                                        Tutorial = u209.Tutorial,
                                    }
                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                    return freeze_2(v4)
                                end
                            end
                            v3 = nil
                        else
                            v3 = "Mobile"
                        end
                        v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                    end
                else
                    v2 = "Dev"
                end
                u209 = getActiveGamemodeSubplaceIds(v2, v1)
                Defusal = u209.Defusal
                UnrankedComp = u209.UnrankedComp
                if UnrankedComp == Defusal then
                    u213 = 0
                else
                    u213 = UnrankedComp
                    if not u213 then
                        u213 = 0
                    end
                end

                function getActiveGamemode(a1) -- Line: 127 -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                    if a1 == 101836176558619 then
                        return "trading"
                    end
                    if a1 == u209.Deathmatch then
                        return "deathmatch"
                    end
                    if a1 == u209.Defusal then
                        return "casual"
                    end
                    if u213 ~= 0 and a1 == u213 then
                        return "competitive"
                    end
                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                        return "tutorial"
                    end
                    local v1 = {u16, u19}
                    local v2 = nil
                    local v3 = nil
                    local v4 = a1
                    for i, j in v1, v2, v3 do
                        if v4 == j.Deathmatch then
                            return "deathmatch"
                        end
                        if v4 == j.Defusal then
                            return "casual"
                        end
                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                            return "competitive"
                        end
                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                            return "tutorial"
                        end
                    end
                    return "casual"
                end

                u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                freeze_2 = table.freeze
                v4 = {
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
                }
                v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                    "Quality",
                    "RAP",
                    "Newest",
                    "Alphabetical",
                    "Collection",
                    "Equipped",
                    "Type",
                    "Float",
                    "Serial",
                })
                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                v4.EVENT_END_TIMES = {
                    ["MEDAL.TV"] = os.time({
                        year = 2026,
                        month = 3,
                        day = 1,
                        hour = 0,
                        min = 0,
                        sec = 0,
                    }),
                }

                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                    -- upvalues: u244 (val), getActiveGamemode (val)
                    if typeof(a1) == "string" and u244[a1] then
                        return u244[a1]
                    end
                    return (getActiveGamemode(game.PlaceId))
                end

                v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                v5.UNIVERSE_ID = game.GameId
                v5.PLACE_ID = game.PlaceId
                v4.SESSION_DATA = v5
                v4.VIP_MENU_PANEL_WHITELIST = {
                    363101315,
                    3659308968,
                    1243042178,
                    107643044,
                    9236102964,
                    38260227,
                    40222641,
                    3436218611,
                }
                v4.AIM_ASSIST_CONFIGS = {
                    PLAYER = {
                        TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                        Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                        Magnetism = {
                            Enabled = true,
                            MaxAngleHorizontal = 0.20943951023931956,
                            MaxAngleVertical = 0.10471975511965978,
                            PullStrength = 0.11344640137963143,
                            StopThreshold = 0.008726646259971648,
                            MaxDistance = 125,
                        },
                        VerticalMagnetism = {
                            Enabled = true,
                            MaxAngleHorizontal = 0.20943951023931956,
                            MaxAngleVertical = 0.10471975511965978,
                            PullStrength = 0.11344640137963143,
                            StopThreshold = 0.008726646259971648,
                            MaxDistance = 125,
                        },
                        RecoilAssist = {
                            Enabled = true,
                            ReductionAmount = 0.5,
                            HorizontalReductionAmount = 0.85,
                            RequiresTarget = false,
                        },
                    },
                }
                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                    Notifications = 15,
                    FavoriteGame = 15,
                    InviteFriend = 15,
                    JoinGroup = 15,
                    LikeGame = 15,
                })
                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                v4.GAMEMODE_PLACE_IDS = {
                    Trading = 101836176558619,
                    Deathmatch = u209.Deathmatch,
                    Casual = u209.Defusal,
                    Competitive = u213,
                    Tutorial = u209.Tutorial,
                }
                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                v4.ACTIVE_DEVICE_PLATFORM = v1
                v4.IS_DEVICE_SERVER = v1 ~= nil
                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                return freeze_2(v4)
            end
        end
        v3 = false
        if not v3 then
            for k37, i34 in pairs(u19) do
                if i34 == PlaceId_2 then
                    v3 = true
                    if v3 then
                        v2 = "Prod"
                    else
                        for k38, i35 in pairs(u28.Mobile) do
                            if i35 == PlaceId_2 then
                                if false then
                                    for k39, i36 in pairs(u28.Console) do
                                        if i36 == PlaceId_2 then
                                            u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                            Defusal = u209.Defusal
                                            UnrankedComp = u209.UnrankedComp
                                            if UnrankedComp == Defusal then
                                                u213 = 0
                                            else
                                                u213 = UnrankedComp
                                                if not u213 then
                                                    u213 = 0
                                                end
                                            end

                                            function getActiveGamemode(a1) -- Line: 127
                                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                if a1 == 101836176558619 then
                                                    return "trading"
                                                end
                                                if a1 == u209.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if a1 == u209.Defusal then
                                                    return "casual"
                                                end
                                                if u213 ~= 0 and a1 == u213 then
                                                    return "competitive"
                                                end
                                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                    return "tutorial"
                                                end
                                                local v1 = {u16, u19}
                                                local v2 = nil
                                                local v3 = nil
                                                local v4 = a1
                                                for i, j in v1, v2, v3 do
                                                    if v4 == j.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if v4 == j.Defusal then
                                                        return "casual"
                                                    end
                                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                        return "competitive"
                                                    end
                                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                        return "tutorial"
                                                    end
                                                end
                                                return "casual"
                                            end

                                            u244 = table.freeze({
                                                Competitive = "competitive",
                                                Deathmatch = "deathmatch",
                                                Casual = "casual",
                                            })
                                            freeze_2 = table.freeze
                                            v4 = {
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
                                                ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                            }
                                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Type",
                                                "Float",
                                            })
                                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Equipped",
                                                "Type",
                                                "Float",
                                                "Serial",
                                            })
                                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                            v4.EVENT_END_TIMES = {
                                                ["MEDAL.TV"] = os.time({
                                                    year = 2026,
                                                    month = 3,
                                                    day = 1,
                                                    hour = 0,
                                                    min = 0,
                                                    sec = 0,
                                                }),
                                            }

                                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                -- upvalues: u244 (val), getActiveGamemode (val)
                                                if typeof(a1) == "string" and u244[a1] then
                                                    return u244[a1]
                                                end
                                                return (getActiveGamemode(game.PlaceId))
                                            end

                                            v5 = {
                                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                            }
                                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                            v5.UNIVERSE_ID = game.GameId
                                            v5.PLACE_ID = game.PlaceId
                                            v4.SESSION_DATA = v5
                                            v4.VIP_MENU_PANEL_WHITELIST = {
                                                363101315,
                                                3659308968,
                                                1243042178,
                                                107643044,
                                                9236102964,
                                                38260227,
                                                40222641,
                                                3436218611,
                                            }
                                            v4.AIM_ASSIST_CONFIGS = {
                                                PLAYER = {
                                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                    Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                    Magnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    VerticalMagnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                },
                                            }
                                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                Notifications = 15,
                                                FavoriteGame = 15,
                                                InviteFriend = 15,
                                                JoinGroup = 15,
                                                LikeGame = 15,
                                            })
                                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                            v4.GAMEMODE_PLACE_IDS = {
                                                Trading = 101836176558619,
                                                Deathmatch = u209.Deathmatch,
                                                Casual = u209.Defusal,
                                                Competitive = u213,
                                                Tutorial = u209.Tutorial,
                                            }
                                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                            v4.ACTIVE_DEVICE_PLATFORM = v1
                                            v4.IS_DEVICE_SERVER = v1 ~= nil
                                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                            return freeze_2(v4)
                                        end
                                    end
                                    v3 = nil
                                else
                                    v3 = "Mobile"
                                end
                                u209 = getActiveGamemodeSubplaceIds(
                                    if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                    v1
                                )
                                Defusal = u209.Defusal
                                UnrankedComp = u209.UnrankedComp
                                if UnrankedComp == Defusal then
                                    u213 = 0
                                else
                                    u213 = UnrankedComp
                                    if not u213 then
                                        u213 = 0
                                    end
                                end

                                function getActiveGamemode(a1) -- Line: 127
                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                    if a1 == 101836176558619 then
                                        return "trading"
                                    end
                                    if a1 == u209.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if a1 == u209.Defusal then
                                        return "casual"
                                    end
                                    if u213 ~= 0 and a1 == u213 then
                                        return "competitive"
                                    end
                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                        return "tutorial"
                                    end
                                    local v1 = {u16, u19}
                                    local v2 = nil
                                    local v3 = nil
                                    local v4 = a1
                                    for i, j in v1, v2, v3 do
                                        if v4 == j.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if v4 == j.Defusal then
                                            return "casual"
                                        end
                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                            return "competitive"
                                        end
                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                            return "tutorial"
                                        end
                                    end
                                    return "casual"
                                end

                                u244 = table.freeze({
                                    Competitive = "competitive",
                                    Deathmatch = "deathmatch",
                                    Casual = "casual",
                                })
                                freeze_2 = table.freeze
                                v4 = {
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
                                }
                                v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Type",
                                    "Float",
                                })
                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Equipped",
                                    "Type",
                                    "Float",
                                    "Serial",
                                })
                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                v4.EVENT_END_TIMES = {
                                    ["MEDAL.TV"] = os.time({
                                        year = 2026,
                                        month = 3,
                                        day = 1,
                                        hour = 0,
                                        min = 0,
                                        sec = 0,
                                    }),
                                }

                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                    if typeof(a1) == "string" and u244[a1] then
                                        return u244[a1]
                                    end
                                    return (getActiveGamemode(game.PlaceId))
                                end

                                v5 = {
                                    VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                }
                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                v5.UNIVERSE_ID = game.GameId
                                v5.PLACE_ID = game.PlaceId
                                v4.SESSION_DATA = v5
                                v4.VIP_MENU_PANEL_WHITELIST = {
                                    363101315,
                                    3659308968,
                                    1243042178,
                                    107643044,
                                    9236102964,
                                    38260227,
                                    40222641,
                                    3436218611,
                                }
                                v4.AIM_ASSIST_CONFIGS = {
                                    PLAYER = {
                                        TargetSelection = {
                                            Enabled = true,
                                            MaxDistance = 125,
                                            MaxAngle = 0.5235987755982988,
                                        },
                                        Friction = {
                                            Enabled = true,
                                            BubbleRadius = 2.4,
                                            MinSensitivity = 0.5,
                                            MaxSensitivity = 1,
                                        },
                                        Magnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        VerticalMagnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        RecoilAssist = {
                                            Enabled = true,
                                            ReductionAmount = 0.5,
                                            HorizontalReductionAmount = 0.85,
                                            RequiresTarget = false,
                                        },
                                    },
                                }
                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                    Notifications = 15,
                                    FavoriteGame = 15,
                                    InviteFriend = 15,
                                    JoinGroup = 15,
                                    LikeGame = 15,
                                })
                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                v4.GAMEMODE_PLACE_IDS = {
                                    Trading = 101836176558619,
                                    Deathmatch = u209.Deathmatch,
                                    Casual = u209.Defusal,
                                    Competitive = u213,
                                    Tutorial = u209.Tutorial,
                                }
                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                return freeze_2(v4)
                            end
                        end
                        if true then
                            for k40, i37 in pairs(u28.Console) do
                                if i37 == PlaceId_2 then
                                    u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                    Defusal = u209.Defusal
                                    UnrankedComp = u209.UnrankedComp
                                    if UnrankedComp == Defusal then
                                        u213 = 0
                                    else
                                        u213 = UnrankedComp
                                        if not u213 then
                                            u213 = 0
                                        end
                                    end

                                    function getActiveGamemode(a1) -- Line: 127
                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                        if a1 == 101836176558619 then
                                            return "trading"
                                        end
                                        if a1 == u209.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if a1 == u209.Defusal then
                                            return "casual"
                                        end
                                        if u213 ~= 0 and a1 == u213 then
                                            return "competitive"
                                        end
                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                            return "tutorial"
                                        end
                                        local v1 = {u16, u19}
                                        local v2 = nil
                                        local v3 = nil
                                        local v4 = a1
                                        for i, j in v1, v2, v3 do
                                            if v4 == j.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if v4 == j.Defusal then
                                                return "casual"
                                            end
                                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                return "competitive"
                                            end
                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                return "tutorial"
                                            end
                                        end
                                        return "casual"
                                    end

                                    u244 = table.freeze({
                                        Competitive = "competitive",
                                        Deathmatch = "deathmatch",
                                        Casual = "casual",
                                    })
                                    freeze_2 = table.freeze
                                    v4 = {
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
                                        ITEM_CATEGORIES = table.freeze({
                                            "All",
                                            "Pistol",
                                            "SMG",
                                            "Rifle",
                                            "Heavy",
                                            "Equipment",
                                            "Miscellaneous",
                                        }),
                                    }
                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Type",
                                        "Float",
                                    })
                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Equipped",
                                        "Type",
                                        "Float",
                                        "Serial",
                                    })
                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                    v4.EVENT_END_TIMES = {
                                        ["MEDAL.TV"] = os.time({
                                            year = 2026,
                                            month = 3,
                                            day = 1,
                                            hour = 0,
                                            min = 0,
                                            sec = 0,
                                        }),
                                    }

                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                        if typeof(a1) == "string" and u244[a1] then
                                            return u244[a1]
                                        end
                                        return (getActiveGamemode(game.PlaceId))
                                    end

                                    v5 = {
                                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                    }
                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                    v5.UNIVERSE_ID = game.GameId
                                    v5.PLACE_ID = game.PlaceId
                                    v4.SESSION_DATA = v5
                                    v4.VIP_MENU_PANEL_WHITELIST = {
                                        363101315,
                                        3659308968,
                                        1243042178,
                                        107643044,
                                        9236102964,
                                        38260227,
                                        40222641,
                                        3436218611,
                                    }
                                    v4.AIM_ASSIST_CONFIGS = {
                                        PLAYER = {
                                            TargetSelection = {
                                                Enabled = true,
                                                MaxDistance = 125,
                                                MaxAngle = 0.5235987755982988,
                                            },
                                            Friction = {
                                                Enabled = true,
                                                BubbleRadius = 2.4,
                                                MinSensitivity = 0.5,
                                                MaxSensitivity = 1,
                                            },
                                            Magnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            VerticalMagnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            RecoilAssist = {
                                                Enabled = true,
                                                ReductionAmount = 0.5,
                                                HorizontalReductionAmount = 0.85,
                                                RequiresTarget = false,
                                            },
                                        },
                                    }
                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                        Notifications = 15,
                                        FavoriteGame = 15,
                                        InviteFriend = 15,
                                        JoinGroup = 15,
                                        LikeGame = 15,
                                    })
                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                    v4.GAMEMODE_PLACE_IDS = {
                                        Trading = 101836176558619,
                                        Deathmatch = u209.Deathmatch,
                                        Casual = u209.Defusal,
                                        Competitive = u213,
                                        Tutorial = u209.Tutorial,
                                    }
                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                    return freeze_2(v4)
                                end
                            end
                            v3 = nil
                        else
                            v3 = "Mobile"
                        end
                        v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                    end
                    u209 = getActiveGamemodeSubplaceIds(v2, v1)
                    Defusal = u209.Defusal
                    UnrankedComp = u209.UnrankedComp
                    if UnrankedComp == Defusal then
                        u213 = 0
                    else
                        u213 = UnrankedComp
                        if not u213 then
                            u213 = 0
                        end
                    end

                    function getActiveGamemode(a1) -- Line: 127
                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                        if a1 == 101836176558619 then
                            return "trading"
                        end
                        if a1 == u209.Deathmatch then
                            return "deathmatch"
                        end
                        if a1 == u209.Defusal then
                            return "casual"
                        end
                        if u213 ~= 0 and a1 == u213 then
                            return "competitive"
                        end
                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                            return "tutorial"
                        end
                        local v1 = {u16, u19}
                        local v2 = nil
                        local v3 = nil
                        local v4 = a1
                        for i, j in v1, v2, v3 do
                            if v4 == j.Deathmatch then
                                return "deathmatch"
                            end
                            if v4 == j.Defusal then
                                return "casual"
                            end
                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                return "competitive"
                            end
                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                return "tutorial"
                            end
                        end
                        return "casual"
                    end

                    u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                    freeze_2 = table.freeze
                    v4 = {
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
                    }
                    v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                        "Quality",
                        "RAP",
                        "Newest",
                        "Alphabetical",
                        "Collection",
                        "Equipped",
                        "Type",
                        "Float",
                        "Serial",
                    })
                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                    v4.EVENT_END_TIMES = {
                        ["MEDAL.TV"] = os.time({
                            year = 2026,
                            month = 3,
                            day = 1,
                            hour = 0,
                            min = 0,
                            sec = 0,
                        }),
                    }

                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                        -- upvalues: u244 (val), getActiveGamemode (val)
                        if typeof(a1) == "string" and u244[a1] then
                            return u244[a1]
                        end
                        return (getActiveGamemode(game.PlaceId))
                    end

                    v5 = {
                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                    }
                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                    v5.UNIVERSE_ID = game.GameId
                    v5.PLACE_ID = game.PlaceId
                    v4.SESSION_DATA = v5
                    v4.VIP_MENU_PANEL_WHITELIST = {
                        363101315,
                        3659308968,
                        1243042178,
                        107643044,
                        9236102964,
                        38260227,
                        40222641,
                        3436218611,
                    }
                    v4.AIM_ASSIST_CONFIGS = {
                        PLAYER = {
                            TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                            Friction = {
                                Enabled = true,
                                BubbleRadius = 2.4,
                                MinSensitivity = 0.5,
                                MaxSensitivity = 1,
                            },
                            Magnetism = {
                                Enabled = true,
                                MaxAngleHorizontal = 0.20943951023931956,
                                MaxAngleVertical = 0.10471975511965978,
                                PullStrength = 0.11344640137963143,
                                StopThreshold = 0.008726646259971648,
                                MaxDistance = 125,
                            },
                            VerticalMagnetism = {
                                Enabled = true,
                                MaxAngleHorizontal = 0.20943951023931956,
                                MaxAngleVertical = 0.10471975511965978,
                                PullStrength = 0.11344640137963143,
                                StopThreshold = 0.008726646259971648,
                                MaxDistance = 125,
                            },
                            RecoilAssist = {
                                Enabled = true,
                                ReductionAmount = 0.5,
                                HorizontalReductionAmount = 0.85,
                                RequiresTarget = false,
                            },
                        },
                    }
                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                        Notifications = 15,
                        FavoriteGame = 15,
                        InviteFriend = 15,
                        JoinGroup = 15,
                        LikeGame = 15,
                    })
                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                    v4.GAMEMODE_PLACE_IDS = {
                        Trading = 101836176558619,
                        Deathmatch = u209.Deathmatch,
                        Casual = u209.Defusal,
                        Competitive = u213,
                        Tutorial = u209.Tutorial,
                    }
                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                    v4.ACTIVE_DEVICE_PLATFORM = v1
                    v4.IS_DEVICE_SERVER = v1 ~= nil
                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                    return freeze_2(v4)
                end
            end
            v3 = false
            if v3 then
                v2 = "Prod"
            else
                for k41, i38 in pairs(u28.Mobile) do
                    if i38 == PlaceId_2 then
                        if false then
                            for k42, i39 in pairs(u28.Console) do
                                if i39 == PlaceId_2 then
                                    u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                    Defusal = u209.Defusal
                                    UnrankedComp = u209.UnrankedComp
                                    if UnrankedComp == Defusal then
                                        u213 = 0
                                    else
                                        u213 = UnrankedComp
                                        if not u213 then
                                            u213 = 0
                                        end
                                    end

                                    function getActiveGamemode(a1) -- Line: 127
                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                        if a1 == 101836176558619 then
                                            return "trading"
                                        end
                                        if a1 == u209.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if a1 == u209.Defusal then
                                            return "casual"
                                        end
                                        if u213 ~= 0 and a1 == u213 then
                                            return "competitive"
                                        end
                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                            return "tutorial"
                                        end
                                        local v1 = {u16, u19}
                                        local v2 = nil
                                        local v3 = nil
                                        local v4 = a1
                                        for i, j in v1, v2, v3 do
                                            if v4 == j.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if v4 == j.Defusal then
                                                return "casual"
                                            end
                                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                return "competitive"
                                            end
                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                return "tutorial"
                                            end
                                        end
                                        return "casual"
                                    end

                                    u244 = table.freeze({
                                        Competitive = "competitive",
                                        Deathmatch = "deathmatch",
                                        Casual = "casual",
                                    })
                                    freeze_2 = table.freeze
                                    v4 = {
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
                                        ITEM_CATEGORIES = table.freeze({
                                            "All",
                                            "Pistol",
                                            "SMG",
                                            "Rifle",
                                            "Heavy",
                                            "Equipment",
                                            "Miscellaneous",
                                        }),
                                    }
                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Type",
                                        "Float",
                                    })
                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Equipped",
                                        "Type",
                                        "Float",
                                        "Serial",
                                    })
                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                    v4.EVENT_END_TIMES = {
                                        ["MEDAL.TV"] = os.time({
                                            year = 2026,
                                            month = 3,
                                            day = 1,
                                            hour = 0,
                                            min = 0,
                                            sec = 0,
                                        }),
                                    }

                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                        if typeof(a1) == "string" and u244[a1] then
                                            return u244[a1]
                                        end
                                        return (getActiveGamemode(game.PlaceId))
                                    end

                                    v5 = {
                                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                    }
                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                    v5.UNIVERSE_ID = game.GameId
                                    v5.PLACE_ID = game.PlaceId
                                    v4.SESSION_DATA = v5
                                    v4.VIP_MENU_PANEL_WHITELIST = {
                                        363101315,
                                        3659308968,
                                        1243042178,
                                        107643044,
                                        9236102964,
                                        38260227,
                                        40222641,
                                        3436218611,
                                    }
                                    v4.AIM_ASSIST_CONFIGS = {
                                        PLAYER = {
                                            TargetSelection = {
                                                Enabled = true,
                                                MaxDistance = 125,
                                                MaxAngle = 0.5235987755982988,
                                            },
                                            Friction = {
                                                Enabled = true,
                                                BubbleRadius = 2.4,
                                                MinSensitivity = 0.5,
                                                MaxSensitivity = 1,
                                            },
                                            Magnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            VerticalMagnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            RecoilAssist = {
                                                Enabled = true,
                                                ReductionAmount = 0.5,
                                                HorizontalReductionAmount = 0.85,
                                                RequiresTarget = false,
                                            },
                                        },
                                    }
                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                        Notifications = 15,
                                        FavoriteGame = 15,
                                        InviteFriend = 15,
                                        JoinGroup = 15,
                                        LikeGame = 15,
                                    })
                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                    v4.GAMEMODE_PLACE_IDS = {
                                        Trading = 101836176558619,
                                        Deathmatch = u209.Deathmatch,
                                        Casual = u209.Defusal,
                                        Competitive = u213,
                                        Tutorial = u209.Tutorial,
                                    }
                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                    return freeze_2(v4)
                                end
                            end
                            v3 = nil
                        else
                            v3 = "Mobile"
                        end
                        u209 = getActiveGamemodeSubplaceIds(if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod", v1)
                        Defusal = u209.Defusal
                        UnrankedComp = u209.UnrankedComp
                        if UnrankedComp == Defusal then
                            u213 = 0
                        else
                            u213 = UnrankedComp
                            if not u213 then
                                u213 = 0
                            end
                        end

                        function getActiveGamemode(a1) -- Line: 127
                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                            if a1 == 101836176558619 then
                                return "trading"
                            end
                            if a1 == u209.Deathmatch then
                                return "deathmatch"
                            end
                            if a1 == u209.Defusal then
                                return "casual"
                            end
                            if u213 ~= 0 and a1 == u213 then
                                return "competitive"
                            end
                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                return "tutorial"
                            end
                            local v1 = {u16, u19}
                            local v2 = nil
                            local v3 = nil
                            local v4 = a1
                            for i, j in v1, v2, v3 do
                                if v4 == j.Deathmatch then
                                    return "deathmatch"
                                end
                                if v4 == j.Defusal then
                                    return "casual"
                                end
                                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                    return "competitive"
                                end
                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                    return "tutorial"
                                end
                            end
                            return "casual"
                        end

                        u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                        freeze_2 = table.freeze
                        v4 = {
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
                        }
                        v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                            "Quality",
                            "RAP",
                            "Newest",
                            "Alphabetical",
                            "Collection",
                            "Equipped",
                            "Type",
                            "Float",
                            "Serial",
                        })
                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                        v4.EVENT_END_TIMES = {
                            ["MEDAL.TV"] = os.time({
                                year = 2026,
                                month = 3,
                                day = 1,
                                hour = 0,
                                min = 0,
                                sec = 0,
                            }),
                        }

                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                            -- upvalues: u244 (val), getActiveGamemode (val)
                            if typeof(a1) == "string" and u244[a1] then
                                return u244[a1]
                            end
                            return (getActiveGamemode(game.PlaceId))
                        end

                        v5 = {
                            VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                        }
                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                        v5.UNIVERSE_ID = game.GameId
                        v5.PLACE_ID = game.PlaceId
                        v4.SESSION_DATA = v5
                        v4.VIP_MENU_PANEL_WHITELIST = {
                            363101315,
                            3659308968,
                            1243042178,
                            107643044,
                            9236102964,
                            38260227,
                            40222641,
                            3436218611,
                        }
                        v4.AIM_ASSIST_CONFIGS = {
                            PLAYER = {
                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                Friction = {
                                    Enabled = true,
                                    BubbleRadius = 2.4,
                                    MinSensitivity = 0.5,
                                    MaxSensitivity = 1,
                                },
                                Magnetism = {
                                    Enabled = true,
                                    MaxAngleHorizontal = 0.20943951023931956,
                                    MaxAngleVertical = 0.10471975511965978,
                                    PullStrength = 0.11344640137963143,
                                    StopThreshold = 0.008726646259971648,
                                    MaxDistance = 125,
                                },
                                VerticalMagnetism = {
                                    Enabled = true,
                                    MaxAngleHorizontal = 0.20943951023931956,
                                    MaxAngleVertical = 0.10471975511965978,
                                    PullStrength = 0.11344640137963143,
                                    StopThreshold = 0.008726646259971648,
                                    MaxDistance = 125,
                                },
                                RecoilAssist = {
                                    Enabled = true,
                                    ReductionAmount = 0.5,
                                    HorizontalReductionAmount = 0.85,
                                    RequiresTarget = false,
                                },
                            },
                        }
                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                            Notifications = 15,
                            FavoriteGame = 15,
                            InviteFriend = 15,
                            JoinGroup = 15,
                            LikeGame = 15,
                        })
                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                        v4.GAMEMODE_PLACE_IDS = {
                            Trading = 101836176558619,
                            Deathmatch = u209.Deathmatch,
                            Casual = u209.Defusal,
                            Competitive = u213,
                            Tutorial = u209.Tutorial,
                        }
                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                        v4.ACTIVE_DEVICE_PLATFORM = v1
                        v4.IS_DEVICE_SERVER = v1 ~= nil
                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                        return freeze_2(v4)
                    end
                end
                if true then
                    for k43, i40 in pairs(u28.Console) do
                        if i40 == PlaceId_2 then
                            u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                            Defusal = u209.Defusal
                            UnrankedComp = u209.UnrankedComp
                            if UnrankedComp == Defusal then
                                u213 = 0
                            else
                                u213 = UnrankedComp
                                if not u213 then
                                    u213 = 0
                                end
                            end

                            function getActiveGamemode(a1) -- Line: 127
                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                if a1 == 101836176558619 then
                                    return "trading"
                                end
                                if a1 == u209.Deathmatch then
                                    return "deathmatch"
                                end
                                if a1 == u209.Defusal then
                                    return "casual"
                                end
                                if u213 ~= 0 and a1 == u213 then
                                    return "competitive"
                                end
                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                    return "tutorial"
                                end
                                local v1 = {u16, u19}
                                local v2 = nil
                                local v3 = nil
                                local v4 = a1
                                for i, j in v1, v2, v3 do
                                    if v4 == j.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if v4 == j.Defusal then
                                        return "casual"
                                    end
                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                        return "competitive"
                                    end
                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                        return "tutorial"
                                    end
                                end
                                return "casual"
                            end

                            u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                            freeze_2 = table.freeze
                            v4 = {
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
                                ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                            }
                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                "Quality",
                                "RAP",
                                "Newest",
                                "Alphabetical",
                                "Collection",
                                "Equipped",
                                "Type",
                                "Float",
                                "Serial",
                            })
                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                            v4.EVENT_END_TIMES = {
                                ["MEDAL.TV"] = os.time({
                                    year = 2026,
                                    month = 3,
                                    day = 1,
                                    hour = 0,
                                    min = 0,
                                    sec = 0,
                                }),
                            }

                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                -- upvalues: u244 (val), getActiveGamemode (val)
                                if typeof(a1) == "string" and u244[a1] then
                                    return u244[a1]
                                end
                                return (getActiveGamemode(game.PlaceId))
                            end

                            v5 = {
                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                            }
                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                            v5.UNIVERSE_ID = game.GameId
                            v5.PLACE_ID = game.PlaceId
                            v4.SESSION_DATA = v5
                            v4.VIP_MENU_PANEL_WHITELIST = {
                                363101315,
                                3659308968,
                                1243042178,
                                107643044,
                                9236102964,
                                38260227,
                                40222641,
                                3436218611,
                            }
                            v4.AIM_ASSIST_CONFIGS = {
                                PLAYER = {
                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                    Friction = {
                                        Enabled = true,
                                        BubbleRadius = 2.4,
                                        MinSensitivity = 0.5,
                                        MaxSensitivity = 1,
                                    },
                                    Magnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    VerticalMagnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    RecoilAssist = {
                                        Enabled = true,
                                        ReductionAmount = 0.5,
                                        HorizontalReductionAmount = 0.85,
                                        RequiresTarget = false,
                                    },
                                },
                            }
                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                Notifications = 15,
                                FavoriteGame = 15,
                                InviteFriend = 15,
                                JoinGroup = 15,
                                LikeGame = 15,
                            })
                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                            v4.GAMEMODE_PLACE_IDS = {
                                Trading = 101836176558619,
                                Deathmatch = u209.Deathmatch,
                                Casual = u209.Defusal,
                                Competitive = u213,
                                Tutorial = u209.Tutorial,
                            }
                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                            v4.ACTIVE_DEVICE_PLATFORM = v1
                            v4.IS_DEVICE_SERVER = v1 ~= nil
                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                            return freeze_2(v4)
                        end
                    end
                    v3 = nil
                else
                    v3 = "Mobile"
                end
                v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
            end
        else
            v2 = "Dev"
        end
        u209 = getActiveGamemodeSubplaceIds(v2, v1)
        Defusal = u209.Defusal
        UnrankedComp = u209.UnrankedComp
        if UnrankedComp == Defusal then
            u213 = 0
        else
            u213 = UnrankedComp
            if not u213 then
                u213 = 0
            end
        end

        function getActiveGamemode(a1) -- Line: 127 -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
            if a1 == 101836176558619 then
                return "trading"
            end
            if a1 == u209.Deathmatch then
                return "deathmatch"
            end
            if a1 == u209.Defusal then
                return "casual"
            end
            if u213 ~= 0 and a1 == u213 then
                return "competitive"
            end
            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                return "tutorial"
            end
            local v1 = {u16, u19}
            local v2 = nil
            local v3 = nil
            local v4 = a1
            for i, j in v1, v2, v3 do
                if v4 == j.Deathmatch then
                    return "deathmatch"
                end
                if v4 == j.Defusal then
                    return "casual"
                end
                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                    return "competitive"
                end
                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                    return "tutorial"
                end
            end
            return "casual"
        end

        u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
        freeze_2 = table.freeze
        v4 = {
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
        }
        v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
            "Quality",
            "RAP",
            "Newest",
            "Alphabetical",
            "Collection",
            "Equipped",
            "Type",
            "Float",
            "Serial",
        })
        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
        v4.EVENT_END_TIMES = {
            ["MEDAL.TV"] = os.time({
                year = 2026,
                month = 3,
                day = 1,
                hour = 0,
                min = 0,
                sec = 0,
            }),
        }

        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171 -- upvalues: u244 (val), getActiveGamemode (val)
            if typeof(a1) == "string" and u244[a1] then
                return u244[a1]
            end
            return (getActiveGamemode(game.PlaceId))
        end

        v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
        v5.JOB_ID = if not v6 then game.JobId else "Studio"
        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
        v5.UNIVERSE_ID = game.GameId
        v5.PLACE_ID = game.PlaceId
        v4.SESSION_DATA = v5
        v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
        v4.AIM_ASSIST_CONFIGS = {
            PLAYER = {
                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                Magnetism = {
                    Enabled = true,
                    MaxAngleHorizontal = 0.20943951023931956,
                    MaxAngleVertical = 0.10471975511965978,
                    PullStrength = 0.11344640137963143,
                    StopThreshold = 0.008726646259971648,
                    MaxDistance = 125,
                },
                VerticalMagnetism = {
                    Enabled = true,
                    MaxAngleHorizontal = 0.20943951023931956,
                    MaxAngleVertical = 0.10471975511965978,
                    PullStrength = 0.11344640137963143,
                    StopThreshold = 0.008726646259971648,
                    MaxDistance = 125,
                },
                RecoilAssist = {
                    Enabled = true,
                    ReductionAmount = 0.5,
                    HorizontalReductionAmount = 0.85,
                    RequiresTarget = false,
                },
            },
        }
        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
            Notifications = 15,
            FavoriteGame = 15,
            InviteFriend = 15,
            JoinGroup = 15,
            LikeGame = 15,
        })
        v4.ACTIVE_PLACE_ENVIRONMENT = v2
        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
        v4.GAMEMODE_PLACE_IDS = {
            Trading = 101836176558619,
            Deathmatch = u209.Deathmatch,
            Casual = u209.Defusal,
            Competitive = u213,
            Tutorial = u209.Tutorial,
        }
        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
        v4.ACTIVE_DEVICE_PLATFORM = v1
        v4.IS_DEVICE_SERVER = v1 ~= nil
        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
        return freeze_2(v4)
    end
end
if true then
    for k44, i41 in pairs(u28.Console) do
        if i41 == PlaceId then
            v1 = "Console"
            PlaceId_2 = game.PlaceId
            for k45, i42 in pairs(u16) do
                if i42 == PlaceId_2 then
                    v3 = true
                    if not v3 then
                        for k46, i43 in pairs(u19) do
                            if i43 == PlaceId_2 then
                                v3 = true
                                if v3 then
                                    v2 = "Prod"
                                else
                                    for k47, i44 in pairs(u28.Mobile) do
                                        if i44 == PlaceId_2 then
                                            if false then
                                                for k48, i45 in pairs(u28.Console) do
                                                    if i45 == PlaceId_2 then
                                                        u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                        Defusal = u209.Defusal
                                                        UnrankedComp = u209.UnrankedComp
                                                        if UnrankedComp == Defusal then
                                                            u213 = 0
                                                        else
                                                            u213 = UnrankedComp
                                                            if not u213 then
                                                                u213 = 0
                                                            end
                                                        end

                                                        function getActiveGamemode(a1) -- Line: 127
                                                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                            if a1 == 101836176558619 then
                                                                return "trading"
                                                            end
                                                            if a1 == u209.Deathmatch then
                                                                return "deathmatch"
                                                            end
                                                            if a1 == u209.Defusal then
                                                                return "casual"
                                                            end
                                                            if u213 ~= 0 and a1 == u213 then
                                                                return "competitive"
                                                            end
                                                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                                return "tutorial"
                                                            end
                                                            local v1 = {u16, u19}
                                                            local v2 = nil
                                                            local v3 = nil
                                                            local v4 = a1
                                                            for i, j in v1, v2, v3 do
                                                                if v4 == j.Deathmatch then
                                                                    return "deathmatch"
                                                                end
                                                                if v4 == j.Defusal then
                                                                    return "casual"
                                                                end
                                                                if j.UnrankedComp ~= j.Defusal
                                                                    and v4 == j.UnrankedComp then
                                                                    return "competitive"
                                                                end
                                                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                                    return "tutorial"
                                                                end
                                                            end
                                                            return "casual"
                                                        end

                                                        u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                        freeze_2 = table.freeze
                                                        v4 = {
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
                                                            ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                        }
                                                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                        v4.EVENT_END_TIMES = {
                                                            ["MEDAL.TV"] = os.time({
                                                                year = 2026,
                                                                month = 3,
                                                                day = 1,
                                                                hour = 0,
                                                                min = 0,
                                                                sec = 0,
                                                            }),
                                                        }

                                                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                            -- upvalues: u244 (val), getActiveGamemode (val)
                                                            if typeof(a1) == "string" and u244[a1] then
                                                                return u244[a1]
                                                            end
                                                            return (getActiveGamemode(game.PlaceId))
                                                        end

                                                        v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                        v5.UNIVERSE_ID = game.GameId
                                                        v5.PLACE_ID = game.PlaceId
                                                        v4.SESSION_DATA = v5
                                                        v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                        v4.AIM_ASSIST_CONFIGS = {
                                                            PLAYER = {
                                                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                                Magnetism = {
                                                                    Enabled = true,
                                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                                    MaxAngleVertical = 0.10471975511965978,
                                                                    PullStrength = 0.11344640137963143,
                                                                    StopThreshold = 0.008726646259971648,
                                                                    MaxDistance = 125,
                                                                },
                                                                VerticalMagnetism = {
                                                                    Enabled = true,
                                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                                    MaxAngleVertical = 0.10471975511965978,
                                                                    PullStrength = 0.11344640137963143,
                                                                    StopThreshold = 0.008726646259971648,
                                                                    MaxDistance = 125,
                                                                },
                                                                RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                            },
                                                        }
                                                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                            Notifications = 15,
                                                            FavoriteGame = 15,
                                                            InviteFriend = 15,
                                                            JoinGroup = 15,
                                                            LikeGame = 15,
                                                        })
                                                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                        v4.GAMEMODE_PLACE_IDS = {
                                                            Trading = 101836176558619,
                                                            Deathmatch = u209.Deathmatch,
                                                            Casual = u209.Defusal,
                                                            Competitive = u213,
                                                            Tutorial = u209.Tutorial,
                                                        }
                                                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                        v4.ACTIVE_DEVICE_PLATFORM = v1
                                                        v4.IS_DEVICE_SERVER = v1 ~= nil
                                                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                        return freeze_2(v4)
                                                    end
                                                end
                                                v3 = nil
                                            else
                                                v3 = "Mobile"
                                            end
                                            u209 = getActiveGamemodeSubplaceIds(
                                                if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                                v1
                                            )
                                            Defusal = u209.Defusal
                                            UnrankedComp = u209.UnrankedComp
                                            if UnrankedComp == Defusal then
                                                u213 = 0
                                            else
                                                u213 = UnrankedComp
                                                if not u213 then
                                                    u213 = 0
                                                end
                                            end

                                            function getActiveGamemode(a1) -- Line: 127
                                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                if a1 == 101836176558619 then
                                                    return "trading"
                                                end
                                                if a1 == u209.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if a1 == u209.Defusal then
                                                    return "casual"
                                                end
                                                if u213 ~= 0 and a1 == u213 then
                                                    return "competitive"
                                                end
                                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                    return "tutorial"
                                                end
                                                local v1 = {u16, u19}
                                                local v2 = nil
                                                local v3 = nil
                                                local v4 = a1
                                                for i, j in v1, v2, v3 do
                                                    if v4 == j.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if v4 == j.Defusal then
                                                        return "casual"
                                                    end
                                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                        return "competitive"
                                                    end
                                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                        return "tutorial"
                                                    end
                                                end
                                                return "casual"
                                            end

                                            u244 = table.freeze({
                                                Competitive = "competitive",
                                                Deathmatch = "deathmatch",
                                                Casual = "casual",
                                            })
                                            freeze_2 = table.freeze
                                            v4 = {
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
                                            }
                                            v4.ITEM_CATEGORIES = table.freeze({
                                                "All",
                                                "Pistol",
                                                "SMG",
                                                "Rifle",
                                                "Heavy",
                                                "Equipment",
                                                "Miscellaneous",
                                            })
                                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Type",
                                                "Float",
                                            })
                                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Equipped",
                                                "Type",
                                                "Float",
                                                "Serial",
                                            })
                                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                            v4.EVENT_END_TIMES = {
                                                ["MEDAL.TV"] = os.time({
                                                    year = 2026,
                                                    month = 3,
                                                    day = 1,
                                                    hour = 0,
                                                    min = 0,
                                                    sec = 0,
                                                }),
                                            }

                                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                -- upvalues: u244 (val), getActiveGamemode (val)
                                                if typeof(a1) == "string" and u244[a1] then
                                                    return u244[a1]
                                                end
                                                return (getActiveGamemode(game.PlaceId))
                                            end

                                            v5 = {
                                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                            }
                                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                            v5.UNIVERSE_ID = game.GameId
                                            v5.PLACE_ID = game.PlaceId
                                            v4.SESSION_DATA = v5
                                            v4.VIP_MENU_PANEL_WHITELIST = {
                                                363101315,
                                                3659308968,
                                                1243042178,
                                                107643044,
                                                9236102964,
                                                38260227,
                                                40222641,
                                                3436218611,
                                            }
                                            v4.AIM_ASSIST_CONFIGS = {
                                                PLAYER = {
                                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                    Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                    Magnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    VerticalMagnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                },
                                            }
                                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                Notifications = 15,
                                                FavoriteGame = 15,
                                                InviteFriend = 15,
                                                JoinGroup = 15,
                                                LikeGame = 15,
                                            })
                                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                            v4.GAMEMODE_PLACE_IDS = {
                                                Trading = 101836176558619,
                                                Deathmatch = u209.Deathmatch,
                                                Casual = u209.Defusal,
                                                Competitive = u213,
                                                Tutorial = u209.Tutorial,
                                            }
                                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                            v4.ACTIVE_DEVICE_PLATFORM = v1
                                            v4.IS_DEVICE_SERVER = v1 ~= nil
                                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                            return freeze_2(v4)
                                        end
                                    end
                                    if true then
                                        for k49, i46 in pairs(u28.Console) do
                                            if i46 == PlaceId_2 then
                                                u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                Defusal = u209.Defusal
                                                UnrankedComp = u209.UnrankedComp
                                                if UnrankedComp == Defusal then
                                                    u213 = 0
                                                else
                                                    u213 = UnrankedComp
                                                    if not u213 then
                                                        u213 = 0
                                                    end
                                                end

                                                function getActiveGamemode(a1) -- Line: 127
                                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                    if a1 == 101836176558619 then
                                                        return "trading"
                                                    end
                                                    if a1 == u209.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if a1 == u209.Defusal then
                                                        return "casual"
                                                    end
                                                    if u213 ~= 0 and a1 == u213 then
                                                        return "competitive"
                                                    end
                                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                        return "tutorial"
                                                    end
                                                    local v1 = {u16, u19}
                                                    local v2 = nil
                                                    local v3 = nil
                                                    local v4 = a1
                                                    for i, j in v1, v2, v3 do
                                                        if v4 == j.Deathmatch then
                                                            return "deathmatch"
                                                        end
                                                        if v4 == j.Defusal then
                                                            return "casual"
                                                        end
                                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                            return "competitive"
                                                        end
                                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                            return "tutorial"
                                                        end
                                                    end
                                                    return "casual"
                                                end

                                                u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                freeze_2 = table.freeze
                                                v4 = {
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
                                                    ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                }
                                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                v4.EVENT_END_TIMES = {
                                                    ["MEDAL.TV"] = os.time({
                                                        year = 2026,
                                                        month = 3,
                                                        day = 1,
                                                        hour = 0,
                                                        min = 0,
                                                        sec = 0,
                                                    }),
                                                }

                                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                                    if typeof(a1) == "string" and u244[a1] then
                                                        return u244[a1]
                                                    end
                                                    return (getActiveGamemode(game.PlaceId))
                                                end

                                                v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                v5.UNIVERSE_ID = game.GameId
                                                v5.PLACE_ID = game.PlaceId
                                                v4.SESSION_DATA = v5
                                                v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                v4.AIM_ASSIST_CONFIGS = {
                                                    PLAYER = {
                                                        TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                        Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                        Magnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        VerticalMagnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                    },
                                                }
                                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                    Notifications = 15,
                                                    FavoriteGame = 15,
                                                    InviteFriend = 15,
                                                    JoinGroup = 15,
                                                    LikeGame = 15,
                                                })
                                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                v4.GAMEMODE_PLACE_IDS = {
                                                    Trading = 101836176558619,
                                                    Deathmatch = u209.Deathmatch,
                                                    Casual = u209.Defusal,
                                                    Competitive = u213,
                                                    Tutorial = u209.Tutorial,
                                                }
                                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                return freeze_2(v4)
                                            end
                                        end
                                        v3 = nil
                                    else
                                        v3 = "Mobile"
                                    end
                                    v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                                end
                                u209 = getActiveGamemodeSubplaceIds(v2, v1)
                                Defusal = u209.Defusal
                                UnrankedComp = u209.UnrankedComp
                                if UnrankedComp == Defusal then
                                    u213 = 0
                                else
                                    u213 = UnrankedComp
                                    if not u213 then
                                        u213 = 0
                                    end
                                end

                                function getActiveGamemode(a1) -- Line: 127
                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                    if a1 == 101836176558619 then
                                        return "trading"
                                    end
                                    if a1 == u209.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if a1 == u209.Defusal then
                                        return "casual"
                                    end
                                    if u213 ~= 0 and a1 == u213 then
                                        return "competitive"
                                    end
                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                        return "tutorial"
                                    end
                                    local v1 = {u16, u19}
                                    local v2 = nil
                                    local v3 = nil
                                    local v4 = a1
                                    for i, j in v1, v2, v3 do
                                        if v4 == j.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if v4 == j.Defusal then
                                            return "casual"
                                        end
                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                            return "competitive"
                                        end
                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                            return "tutorial"
                                        end
                                    end
                                    return "casual"
                                end

                                u244 = table.freeze({
                                    Competitive = "competitive",
                                    Deathmatch = "deathmatch",
                                    Casual = "casual",
                                })
                                freeze_2 = table.freeze
                                v4 = {
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
                                }
                                v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Type",
                                    "Float",
                                })
                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Equipped",
                                    "Type",
                                    "Float",
                                    "Serial",
                                })
                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                v4.EVENT_END_TIMES = {
                                    ["MEDAL.TV"] = os.time({
                                        year = 2026,
                                        month = 3,
                                        day = 1,
                                        hour = 0,
                                        min = 0,
                                        sec = 0,
                                    }),
                                }

                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                    if typeof(a1) == "string" and u244[a1] then
                                        return u244[a1]
                                    end
                                    return (getActiveGamemode(game.PlaceId))
                                end

                                v5 = {
                                    VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                }
                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                v5.UNIVERSE_ID = game.GameId
                                v5.PLACE_ID = game.PlaceId
                                v4.SESSION_DATA = v5
                                v4.VIP_MENU_PANEL_WHITELIST = {
                                    363101315,
                                    3659308968,
                                    1243042178,
                                    107643044,
                                    9236102964,
                                    38260227,
                                    40222641,
                                    3436218611,
                                }
                                v4.AIM_ASSIST_CONFIGS = {
                                    PLAYER = {
                                        TargetSelection = {
                                            Enabled = true,
                                            MaxDistance = 125,
                                            MaxAngle = 0.5235987755982988,
                                        },
                                        Friction = {
                                            Enabled = true,
                                            BubbleRadius = 2.4,
                                            MinSensitivity = 0.5,
                                            MaxSensitivity = 1,
                                        },
                                        Magnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        VerticalMagnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        RecoilAssist = {
                                            Enabled = true,
                                            ReductionAmount = 0.5,
                                            HorizontalReductionAmount = 0.85,
                                            RequiresTarget = false,
                                        },
                                    },
                                }
                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                    Notifications = 15,
                                    FavoriteGame = 15,
                                    InviteFriend = 15,
                                    JoinGroup = 15,
                                    LikeGame = 15,
                                })
                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                v4.GAMEMODE_PLACE_IDS = {
                                    Trading = 101836176558619,
                                    Deathmatch = u209.Deathmatch,
                                    Casual = u209.Defusal,
                                    Competitive = u213,
                                    Tutorial = u209.Tutorial,
                                }
                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                return freeze_2(v4)
                            end
                        end
                        v3 = false
                        if v3 then
                            v2 = "Prod"
                        else
                            for k50, i47 in pairs(u28.Mobile) do
                                if i47 == PlaceId_2 then
                                    if false then
                                        for k51, i48 in pairs(u28.Console) do
                                            if i48 == PlaceId_2 then
                                                u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                Defusal = u209.Defusal
                                                UnrankedComp = u209.UnrankedComp
                                                if UnrankedComp == Defusal then
                                                    u213 = 0
                                                else
                                                    u213 = UnrankedComp
                                                    if not u213 then
                                                        u213 = 0
                                                    end
                                                end

                                                function getActiveGamemode(a1) -- Line: 127
                                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                    if a1 == 101836176558619 then
                                                        return "trading"
                                                    end
                                                    if a1 == u209.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if a1 == u209.Defusal then
                                                        return "casual"
                                                    end
                                                    if u213 ~= 0 and a1 == u213 then
                                                        return "competitive"
                                                    end
                                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                        return "tutorial"
                                                    end
                                                    local v1 = {u16, u19}
                                                    local v2 = nil
                                                    local v3 = nil
                                                    local v4 = a1
                                                    for i, j in v1, v2, v3 do
                                                        if v4 == j.Deathmatch then
                                                            return "deathmatch"
                                                        end
                                                        if v4 == j.Defusal then
                                                            return "casual"
                                                        end
                                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                            return "competitive"
                                                        end
                                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                            return "tutorial"
                                                        end
                                                    end
                                                    return "casual"
                                                end

                                                u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                freeze_2 = table.freeze
                                                v4 = {
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
                                                    ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                }
                                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                v4.EVENT_END_TIMES = {
                                                    ["MEDAL.TV"] = os.time({
                                                        year = 2026,
                                                        month = 3,
                                                        day = 1,
                                                        hour = 0,
                                                        min = 0,
                                                        sec = 0,
                                                    }),
                                                }

                                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                                    if typeof(a1) == "string" and u244[a1] then
                                                        return u244[a1]
                                                    end
                                                    return (getActiveGamemode(game.PlaceId))
                                                end

                                                v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                v5.UNIVERSE_ID = game.GameId
                                                v5.PLACE_ID = game.PlaceId
                                                v4.SESSION_DATA = v5
                                                v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                v4.AIM_ASSIST_CONFIGS = {
                                                    PLAYER = {
                                                        TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                        Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                        Magnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        VerticalMagnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                    },
                                                }
                                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                    Notifications = 15,
                                                    FavoriteGame = 15,
                                                    InviteFriend = 15,
                                                    JoinGroup = 15,
                                                    LikeGame = 15,
                                                })
                                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                v4.GAMEMODE_PLACE_IDS = {
                                                    Trading = 101836176558619,
                                                    Deathmatch = u209.Deathmatch,
                                                    Casual = u209.Defusal,
                                                    Competitive = u213,
                                                    Tutorial = u209.Tutorial,
                                                }
                                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                return freeze_2(v4)
                                            end
                                        end
                                        v3 = nil
                                    else
                                        v3 = "Mobile"
                                    end
                                    u209 = getActiveGamemodeSubplaceIds(
                                        if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                        v1
                                    )
                                    Defusal = u209.Defusal
                                    UnrankedComp = u209.UnrankedComp
                                    if UnrankedComp == Defusal then
                                        u213 = 0
                                    else
                                        u213 = UnrankedComp
                                        if not u213 then
                                            u213 = 0
                                        end
                                    end

                                    function getActiveGamemode(a1) -- Line: 127
                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                        if a1 == 101836176558619 then
                                            return "trading"
                                        end
                                        if a1 == u209.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if a1 == u209.Defusal then
                                            return "casual"
                                        end
                                        if u213 ~= 0 and a1 == u213 then
                                            return "competitive"
                                        end
                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                            return "tutorial"
                                        end
                                        local v1 = {u16, u19}
                                        local v2 = nil
                                        local v3 = nil
                                        local v4 = a1
                                        for i, j in v1, v2, v3 do
                                            if v4 == j.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if v4 == j.Defusal then
                                                return "casual"
                                            end
                                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                return "competitive"
                                            end
                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                return "tutorial"
                                            end
                                        end
                                        return "casual"
                                    end

                                    u244 = table.freeze({
                                        Competitive = "competitive",
                                        Deathmatch = "deathmatch",
                                        Casual = "casual",
                                    })
                                    freeze_2 = table.freeze
                                    v4 = {
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
                                    }
                                    v4.ITEM_CATEGORIES = table.freeze({
                                        "All",
                                        "Pistol",
                                        "SMG",
                                        "Rifle",
                                        "Heavy",
                                        "Equipment",
                                        "Miscellaneous",
                                    })
                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Type",
                                        "Float",
                                    })
                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Equipped",
                                        "Type",
                                        "Float",
                                        "Serial",
                                    })
                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                    v4.EVENT_END_TIMES = {
                                        ["MEDAL.TV"] = os.time({
                                            year = 2026,
                                            month = 3,
                                            day = 1,
                                            hour = 0,
                                            min = 0,
                                            sec = 0,
                                        }),
                                    }

                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                        if typeof(a1) == "string" and u244[a1] then
                                            return u244[a1]
                                        end
                                        return (getActiveGamemode(game.PlaceId))
                                    end

                                    v5 = {
                                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                    }
                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                    v5.UNIVERSE_ID = game.GameId
                                    v5.PLACE_ID = game.PlaceId
                                    v4.SESSION_DATA = v5
                                    v4.VIP_MENU_PANEL_WHITELIST = {
                                        363101315,
                                        3659308968,
                                        1243042178,
                                        107643044,
                                        9236102964,
                                        38260227,
                                        40222641,
                                        3436218611,
                                    }
                                    v4.AIM_ASSIST_CONFIGS = {
                                        PLAYER = {
                                            TargetSelection = {
                                                Enabled = true,
                                                MaxDistance = 125,
                                                MaxAngle = 0.5235987755982988,
                                            },
                                            Friction = {
                                                Enabled = true,
                                                BubbleRadius = 2.4,
                                                MinSensitivity = 0.5,
                                                MaxSensitivity = 1,
                                            },
                                            Magnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            VerticalMagnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            RecoilAssist = {
                                                Enabled = true,
                                                ReductionAmount = 0.5,
                                                HorizontalReductionAmount = 0.85,
                                                RequiresTarget = false,
                                            },
                                        },
                                    }
                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                        Notifications = 15,
                                        FavoriteGame = 15,
                                        InviteFriend = 15,
                                        JoinGroup = 15,
                                        LikeGame = 15,
                                    })
                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                    v4.GAMEMODE_PLACE_IDS = {
                                        Trading = 101836176558619,
                                        Deathmatch = u209.Deathmatch,
                                        Casual = u209.Defusal,
                                        Competitive = u213,
                                        Tutorial = u209.Tutorial,
                                    }
                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                    return freeze_2(v4)
                                end
                            end
                            if true then
                                for k52, i49 in pairs(u28.Console) do
                                    if i49 == PlaceId_2 then
                                        u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                        Defusal = u209.Defusal
                                        UnrankedComp = u209.UnrankedComp
                                        if UnrankedComp == Defusal then
                                            u213 = 0
                                        else
                                            u213 = UnrankedComp
                                            if not u213 then
                                                u213 = 0
                                            end
                                        end

                                        function getActiveGamemode(a1) -- Line: 127
                                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                            if a1 == 101836176558619 then
                                                return "trading"
                                            end
                                            if a1 == u209.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if a1 == u209.Defusal then
                                                return "casual"
                                            end
                                            if u213 ~= 0 and a1 == u213 then
                                                return "competitive"
                                            end
                                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                return "tutorial"
                                            end
                                            local v1 = {u16, u19}
                                            local v2 = nil
                                            local v3 = nil
                                            local v4 = a1
                                            for i, j in v1, v2, v3 do
                                                if v4 == j.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if v4 == j.Defusal then
                                                    return "casual"
                                                end
                                                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                    return "competitive"
                                                end
                                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                    return "tutorial"
                                                end
                                            end
                                            return "casual"
                                        end

                                        u244 = table.freeze({
                                            Competitive = "competitive",
                                            Deathmatch = "deathmatch",
                                            Casual = "casual",
                                        })
                                        freeze_2 = table.freeze
                                        v4 = {
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
                                            ITEM_CATEGORIES = table.freeze({
                                                "All",
                                                "Pistol",
                                                "SMG",
                                                "Rifle",
                                                "Heavy",
                                                "Equipment",
                                                "Miscellaneous",
                                            }),
                                        }
                                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Type",
                                            "Float",
                                        })
                                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Equipped",
                                            "Type",
                                            "Float",
                                            "Serial",
                                        })
                                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                        v4.EVENT_END_TIMES = {
                                            ["MEDAL.TV"] = os.time({
                                                year = 2026,
                                                month = 3,
                                                day = 1,
                                                hour = 0,
                                                min = 0,
                                                sec = 0,
                                            }),
                                        }

                                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                            -- upvalues: u244 (val), getActiveGamemode (val)
                                            if typeof(a1) == "string" and u244[a1] then
                                                return u244[a1]
                                            end
                                            return (getActiveGamemode(game.PlaceId))
                                        end

                                        v5 = {
                                            VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                        }
                                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                        v5.UNIVERSE_ID = game.GameId
                                        v5.PLACE_ID = game.PlaceId
                                        v4.SESSION_DATA = v5
                                        v4.VIP_MENU_PANEL_WHITELIST = {
                                            363101315,
                                            3659308968,
                                            1243042178,
                                            107643044,
                                            9236102964,
                                            38260227,
                                            40222641,
                                            3436218611,
                                        }
                                        v4.AIM_ASSIST_CONFIGS = {
                                            PLAYER = {
                                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                Magnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                VerticalMagnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                            },
                                        }
                                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                            Notifications = 15,
                                            FavoriteGame = 15,
                                            InviteFriend = 15,
                                            JoinGroup = 15,
                                            LikeGame = 15,
                                        })
                                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                        v4.GAMEMODE_PLACE_IDS = {
                                            Trading = 101836176558619,
                                            Deathmatch = u209.Deathmatch,
                                            Casual = u209.Defusal,
                                            Competitive = u213,
                                            Tutorial = u209.Tutorial,
                                        }
                                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                        v4.ACTIVE_DEVICE_PLATFORM = v1
                                        v4.IS_DEVICE_SERVER = v1 ~= nil
                                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                        return freeze_2(v4)
                                    end
                                end
                                v3 = nil
                            else
                                v3 = "Mobile"
                            end
                            v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                        end
                    else
                        v2 = "Dev"
                    end
                    u209 = getActiveGamemodeSubplaceIds(v2, v1)
                    Defusal = u209.Defusal
                    UnrankedComp = u209.UnrankedComp
                    if UnrankedComp == Defusal then
                        u213 = 0
                    else
                        u213 = UnrankedComp
                        if not u213 then
                            u213 = 0
                        end
                    end

                    function getActiveGamemode(a1) -- Line: 127
                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                        if a1 == 101836176558619 then
                            return "trading"
                        end
                        if a1 == u209.Deathmatch then
                            return "deathmatch"
                        end
                        if a1 == u209.Defusal then
                            return "casual"
                        end
                        if u213 ~= 0 and a1 == u213 then
                            return "competitive"
                        end
                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                            return "tutorial"
                        end
                        local v1 = {u16, u19}
                        local v2 = nil
                        local v3 = nil
                        local v4 = a1
                        for i, j in v1, v2, v3 do
                            if v4 == j.Deathmatch then
                                return "deathmatch"
                            end
                            if v4 == j.Defusal then
                                return "casual"
                            end
                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                return "competitive"
                            end
                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                return "tutorial"
                            end
                        end
                        return "casual"
                    end

                    u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                    freeze_2 = table.freeze
                    v4 = {
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
                    }
                    v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                        "Quality",
                        "RAP",
                        "Newest",
                        "Alphabetical",
                        "Collection",
                        "Equipped",
                        "Type",
                        "Float",
                        "Serial",
                    })
                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                    v4.EVENT_END_TIMES = {
                        ["MEDAL.TV"] = os.time({
                            year = 2026,
                            month = 3,
                            day = 1,
                            hour = 0,
                            min = 0,
                            sec = 0,
                        }),
                    }

                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                        -- upvalues: u244 (val), getActiveGamemode (val)
                        if typeof(a1) == "string" and u244[a1] then
                            return u244[a1]
                        end
                        return (getActiveGamemode(game.PlaceId))
                    end

                    v5 = {
                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                    }
                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                    v5.UNIVERSE_ID = game.GameId
                    v5.PLACE_ID = game.PlaceId
                    v4.SESSION_DATA = v5
                    v4.VIP_MENU_PANEL_WHITELIST = {
                        363101315,
                        3659308968,
                        1243042178,
                        107643044,
                        9236102964,
                        38260227,
                        40222641,
                        3436218611,
                    }
                    v4.AIM_ASSIST_CONFIGS = {
                        PLAYER = {
                            TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                            Friction = {
                                Enabled = true,
                                BubbleRadius = 2.4,
                                MinSensitivity = 0.5,
                                MaxSensitivity = 1,
                            },
                            Magnetism = {
                                Enabled = true,
                                MaxAngleHorizontal = 0.20943951023931956,
                                MaxAngleVertical = 0.10471975511965978,
                                PullStrength = 0.11344640137963143,
                                StopThreshold = 0.008726646259971648,
                                MaxDistance = 125,
                            },
                            VerticalMagnetism = {
                                Enabled = true,
                                MaxAngleHorizontal = 0.20943951023931956,
                                MaxAngleVertical = 0.10471975511965978,
                                PullStrength = 0.11344640137963143,
                                StopThreshold = 0.008726646259971648,
                                MaxDistance = 125,
                            },
                            RecoilAssist = {
                                Enabled = true,
                                ReductionAmount = 0.5,
                                HorizontalReductionAmount = 0.85,
                                RequiresTarget = false,
                            },
                        },
                    }
                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                        Notifications = 15,
                        FavoriteGame = 15,
                        InviteFriend = 15,
                        JoinGroup = 15,
                        LikeGame = 15,
                    })
                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                    v4.GAMEMODE_PLACE_IDS = {
                        Trading = 101836176558619,
                        Deathmatch = u209.Deathmatch,
                        Casual = u209.Defusal,
                        Competitive = u213,
                        Tutorial = u209.Tutorial,
                    }
                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                    v4.ACTIVE_DEVICE_PLATFORM = v1
                    v4.IS_DEVICE_SERVER = v1 ~= nil
                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                    return freeze_2(v4)
                end
            end
            v3 = false
            if not v3 then
                for k53, i50 in pairs(u19) do
                    if i50 == PlaceId_2 then
                        v3 = true
                        if v3 then
                            v2 = "Prod"
                        else
                            for k54, i51 in pairs(u28.Mobile) do
                                if i51 == PlaceId_2 then
                                    if false then
                                        for k55, i52 in pairs(u28.Console) do
                                            if i52 == PlaceId_2 then
                                                u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                                Defusal = u209.Defusal
                                                UnrankedComp = u209.UnrankedComp
                                                if UnrankedComp == Defusal then
                                                    u213 = 0
                                                else
                                                    u213 = UnrankedComp
                                                    if not u213 then
                                                        u213 = 0
                                                    end
                                                end

                                                function getActiveGamemode(a1) -- Line: 127
                                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                    if a1 == 101836176558619 then
                                                        return "trading"
                                                    end
                                                    if a1 == u209.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if a1 == u209.Defusal then
                                                        return "casual"
                                                    end
                                                    if u213 ~= 0 and a1 == u213 then
                                                        return "competitive"
                                                    end
                                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                        return "tutorial"
                                                    end
                                                    local v1 = {u16, u19}
                                                    local v2 = nil
                                                    local v3 = nil
                                                    local v4 = a1
                                                    for i, j in v1, v2, v3 do
                                                        if v4 == j.Deathmatch then
                                                            return "deathmatch"
                                                        end
                                                        if v4 == j.Defusal then
                                                            return "casual"
                                                        end
                                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                            return "competitive"
                                                        end
                                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                            return "tutorial"
                                                        end
                                                    end
                                                    return "casual"
                                                end

                                                u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                                                freeze_2 = table.freeze
                                                v4 = {
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
                                                    ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                                }
                                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
                                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                                v4.EVENT_END_TIMES = {
                                                    ["MEDAL.TV"] = os.time({
                                                        year = 2026,
                                                        month = 3,
                                                        day = 1,
                                                        hour = 0,
                                                        min = 0,
                                                        sec = 0,
                                                    }),
                                                }

                                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                                    if typeof(a1) == "string" and u244[a1] then
                                                        return u244[a1]
                                                    end
                                                    return (getActiveGamemode(game.PlaceId))
                                                end

                                                v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                                v5.UNIVERSE_ID = game.GameId
                                                v5.PLACE_ID = game.PlaceId
                                                v4.SESSION_DATA = v5
                                                v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
                                                v4.AIM_ASSIST_CONFIGS = {
                                                    PLAYER = {
                                                        TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                        Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                        Magnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        VerticalMagnetism = {
                                                            Enabled = true,
                                                            MaxAngleHorizontal = 0.20943951023931956,
                                                            MaxAngleVertical = 0.10471975511965978,
                                                            PullStrength = 0.11344640137963143,
                                                            StopThreshold = 0.008726646259971648,
                                                            MaxDistance = 125,
                                                        },
                                                        RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                    },
                                                }
                                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                    Notifications = 15,
                                                    FavoriteGame = 15,
                                                    InviteFriend = 15,
                                                    JoinGroup = 15,
                                                    LikeGame = 15,
                                                })
                                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                                v4.GAMEMODE_PLACE_IDS = {
                                                    Trading = 101836176558619,
                                                    Deathmatch = u209.Deathmatch,
                                                    Casual = u209.Defusal,
                                                    Competitive = u213,
                                                    Tutorial = u209.Tutorial,
                                                }
                                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                                return freeze_2(v4)
                                            end
                                        end
                                        v3 = nil
                                    else
                                        v3 = "Mobile"
                                    end
                                    u209 = getActiveGamemodeSubplaceIds(
                                        if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                        v1
                                    )
                                    Defusal = u209.Defusal
                                    UnrankedComp = u209.UnrankedComp
                                    if UnrankedComp == Defusal then
                                        u213 = 0
                                    else
                                        u213 = UnrankedComp
                                        if not u213 then
                                            u213 = 0
                                        end
                                    end

                                    function getActiveGamemode(a1) -- Line: 127
                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                        if a1 == 101836176558619 then
                                            return "trading"
                                        end
                                        if a1 == u209.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if a1 == u209.Defusal then
                                            return "casual"
                                        end
                                        if u213 ~= 0 and a1 == u213 then
                                            return "competitive"
                                        end
                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                            return "tutorial"
                                        end
                                        local v1 = {u16, u19}
                                        local v2 = nil
                                        local v3 = nil
                                        local v4 = a1
                                        for i, j in v1, v2, v3 do
                                            if v4 == j.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if v4 == j.Defusal then
                                                return "casual"
                                            end
                                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                return "competitive"
                                            end
                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                return "tutorial"
                                            end
                                        end
                                        return "casual"
                                    end

                                    u244 = table.freeze({
                                        Competitive = "competitive",
                                        Deathmatch = "deathmatch",
                                        Casual = "casual",
                                    })
                                    freeze_2 = table.freeze
                                    v4 = {
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
                                    }
                                    v4.ITEM_CATEGORIES = table.freeze({
                                        "All",
                                        "Pistol",
                                        "SMG",
                                        "Rifle",
                                        "Heavy",
                                        "Equipment",
                                        "Miscellaneous",
                                    })
                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Type",
                                        "Float",
                                    })
                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Equipped",
                                        "Type",
                                        "Float",
                                        "Serial",
                                    })
                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                    v4.EVENT_END_TIMES = {
                                        ["MEDAL.TV"] = os.time({
                                            year = 2026,
                                            month = 3,
                                            day = 1,
                                            hour = 0,
                                            min = 0,
                                            sec = 0,
                                        }),
                                    }

                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                        if typeof(a1) == "string" and u244[a1] then
                                            return u244[a1]
                                        end
                                        return (getActiveGamemode(game.PlaceId))
                                    end

                                    v5 = {
                                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                    }
                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                    v5.UNIVERSE_ID = game.GameId
                                    v5.PLACE_ID = game.PlaceId
                                    v4.SESSION_DATA = v5
                                    v4.VIP_MENU_PANEL_WHITELIST = {
                                        363101315,
                                        3659308968,
                                        1243042178,
                                        107643044,
                                        9236102964,
                                        38260227,
                                        40222641,
                                        3436218611,
                                    }
                                    v4.AIM_ASSIST_CONFIGS = {
                                        PLAYER = {
                                            TargetSelection = {
                                                Enabled = true,
                                                MaxDistance = 125,
                                                MaxAngle = 0.5235987755982988,
                                            },
                                            Friction = {
                                                Enabled = true,
                                                BubbleRadius = 2.4,
                                                MinSensitivity = 0.5,
                                                MaxSensitivity = 1,
                                            },
                                            Magnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            VerticalMagnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            RecoilAssist = {
                                                Enabled = true,
                                                ReductionAmount = 0.5,
                                                HorizontalReductionAmount = 0.85,
                                                RequiresTarget = false,
                                            },
                                        },
                                    }
                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                        Notifications = 15,
                                        FavoriteGame = 15,
                                        InviteFriend = 15,
                                        JoinGroup = 15,
                                        LikeGame = 15,
                                    })
                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                    v4.GAMEMODE_PLACE_IDS = {
                                        Trading = 101836176558619,
                                        Deathmatch = u209.Deathmatch,
                                        Casual = u209.Defusal,
                                        Competitive = u213,
                                        Tutorial = u209.Tutorial,
                                    }
                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                    return freeze_2(v4)
                                end
                            end
                            if true then
                                for k56, i53 in pairs(u28.Console) do
                                    if i53 == PlaceId_2 then
                                        u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                        Defusal = u209.Defusal
                                        UnrankedComp = u209.UnrankedComp
                                        if UnrankedComp == Defusal then
                                            u213 = 0
                                        else
                                            u213 = UnrankedComp
                                            if not u213 then
                                                u213 = 0
                                            end
                                        end

                                        function getActiveGamemode(a1) -- Line: 127
                                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                            if a1 == 101836176558619 then
                                                return "trading"
                                            end
                                            if a1 == u209.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if a1 == u209.Defusal then
                                                return "casual"
                                            end
                                            if u213 ~= 0 and a1 == u213 then
                                                return "competitive"
                                            end
                                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                return "tutorial"
                                            end
                                            local v1 = {u16, u19}
                                            local v2 = nil
                                            local v3 = nil
                                            local v4 = a1
                                            for i, j in v1, v2, v3 do
                                                if v4 == j.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if v4 == j.Defusal then
                                                    return "casual"
                                                end
                                                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                    return "competitive"
                                                end
                                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                    return "tutorial"
                                                end
                                            end
                                            return "casual"
                                        end

                                        u244 = table.freeze({
                                            Competitive = "competitive",
                                            Deathmatch = "deathmatch",
                                            Casual = "casual",
                                        })
                                        freeze_2 = table.freeze
                                        v4 = {
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
                                            ITEM_CATEGORIES = table.freeze({
                                                "All",
                                                "Pistol",
                                                "SMG",
                                                "Rifle",
                                                "Heavy",
                                                "Equipment",
                                                "Miscellaneous",
                                            }),
                                        }
                                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Type",
                                            "Float",
                                        })
                                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Equipped",
                                            "Type",
                                            "Float",
                                            "Serial",
                                        })
                                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                        v4.EVENT_END_TIMES = {
                                            ["MEDAL.TV"] = os.time({
                                                year = 2026,
                                                month = 3,
                                                day = 1,
                                                hour = 0,
                                                min = 0,
                                                sec = 0,
                                            }),
                                        }

                                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                            -- upvalues: u244 (val), getActiveGamemode (val)
                                            if typeof(a1) == "string" and u244[a1] then
                                                return u244[a1]
                                            end
                                            return (getActiveGamemode(game.PlaceId))
                                        end

                                        v5 = {
                                            VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                        }
                                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                        v5.UNIVERSE_ID = game.GameId
                                        v5.PLACE_ID = game.PlaceId
                                        v4.SESSION_DATA = v5
                                        v4.VIP_MENU_PANEL_WHITELIST = {
                                            363101315,
                                            3659308968,
                                            1243042178,
                                            107643044,
                                            9236102964,
                                            38260227,
                                            40222641,
                                            3436218611,
                                        }
                                        v4.AIM_ASSIST_CONFIGS = {
                                            PLAYER = {
                                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                Magnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                VerticalMagnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                            },
                                        }
                                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                            Notifications = 15,
                                            FavoriteGame = 15,
                                            InviteFriend = 15,
                                            JoinGroup = 15,
                                            LikeGame = 15,
                                        })
                                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                        v4.GAMEMODE_PLACE_IDS = {
                                            Trading = 101836176558619,
                                            Deathmatch = u209.Deathmatch,
                                            Casual = u209.Defusal,
                                            Competitive = u213,
                                            Tutorial = u209.Tutorial,
                                        }
                                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                        v4.ACTIVE_DEVICE_PLATFORM = v1
                                        v4.IS_DEVICE_SERVER = v1 ~= nil
                                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                        return freeze_2(v4)
                                    end
                                end
                                v3 = nil
                            else
                                v3 = "Mobile"
                            end
                            v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                        end
                        u209 = getActiveGamemodeSubplaceIds(v2, v1)
                        Defusal = u209.Defusal
                        UnrankedComp = u209.UnrankedComp
                        if UnrankedComp == Defusal then
                            u213 = 0
                        else
                            u213 = UnrankedComp
                            if not u213 then
                                u213 = 0
                            end
                        end

                        function getActiveGamemode(a1) -- Line: 127
                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                            if a1 == 101836176558619 then
                                return "trading"
                            end
                            if a1 == u209.Deathmatch then
                                return "deathmatch"
                            end
                            if a1 == u209.Defusal then
                                return "casual"
                            end
                            if u213 ~= 0 and a1 == u213 then
                                return "competitive"
                            end
                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                return "tutorial"
                            end
                            local v1 = {u16, u19}
                            local v2 = nil
                            local v3 = nil
                            local v4 = a1
                            for i, j in v1, v2, v3 do
                                if v4 == j.Deathmatch then
                                    return "deathmatch"
                                end
                                if v4 == j.Defusal then
                                    return "casual"
                                end
                                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                    return "competitive"
                                end
                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                    return "tutorial"
                                end
                            end
                            return "casual"
                        end

                        u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                        freeze_2 = table.freeze
                        v4 = {
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
                        }
                        v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                            "Quality",
                            "RAP",
                            "Newest",
                            "Alphabetical",
                            "Collection",
                            "Equipped",
                            "Type",
                            "Float",
                            "Serial",
                        })
                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                        v4.EVENT_END_TIMES = {
                            ["MEDAL.TV"] = os.time({
                                year = 2026,
                                month = 3,
                                day = 1,
                                hour = 0,
                                min = 0,
                                sec = 0,
                            }),
                        }

                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                            -- upvalues: u244 (val), getActiveGamemode (val)
                            if typeof(a1) == "string" and u244[a1] then
                                return u244[a1]
                            end
                            return (getActiveGamemode(game.PlaceId))
                        end

                        v5 = {
                            VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                        }
                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                        v5.UNIVERSE_ID = game.GameId
                        v5.PLACE_ID = game.PlaceId
                        v4.SESSION_DATA = v5
                        v4.VIP_MENU_PANEL_WHITELIST = {
                            363101315,
                            3659308968,
                            1243042178,
                            107643044,
                            9236102964,
                            38260227,
                            40222641,
                            3436218611,
                        }
                        v4.AIM_ASSIST_CONFIGS = {
                            PLAYER = {
                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                Friction = {
                                    Enabled = true,
                                    BubbleRadius = 2.4,
                                    MinSensitivity = 0.5,
                                    MaxSensitivity = 1,
                                },
                                Magnetism = {
                                    Enabled = true,
                                    MaxAngleHorizontal = 0.20943951023931956,
                                    MaxAngleVertical = 0.10471975511965978,
                                    PullStrength = 0.11344640137963143,
                                    StopThreshold = 0.008726646259971648,
                                    MaxDistance = 125,
                                },
                                VerticalMagnetism = {
                                    Enabled = true,
                                    MaxAngleHorizontal = 0.20943951023931956,
                                    MaxAngleVertical = 0.10471975511965978,
                                    PullStrength = 0.11344640137963143,
                                    StopThreshold = 0.008726646259971648,
                                    MaxDistance = 125,
                                },
                                RecoilAssist = {
                                    Enabled = true,
                                    ReductionAmount = 0.5,
                                    HorizontalReductionAmount = 0.85,
                                    RequiresTarget = false,
                                },
                            },
                        }
                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                            Notifications = 15,
                            FavoriteGame = 15,
                            InviteFriend = 15,
                            JoinGroup = 15,
                            LikeGame = 15,
                        })
                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                        v4.GAMEMODE_PLACE_IDS = {
                            Trading = 101836176558619,
                            Deathmatch = u209.Deathmatch,
                            Casual = u209.Defusal,
                            Competitive = u213,
                            Tutorial = u209.Tutorial,
                        }
                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                        v4.ACTIVE_DEVICE_PLATFORM = v1
                        v4.IS_DEVICE_SERVER = v1 ~= nil
                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                        return freeze_2(v4)
                    end
                end
                v3 = false
                if v3 then
                    v2 = "Prod"
                else
                    for k57, i54 in pairs(u28.Mobile) do
                        if i54 == PlaceId_2 then
                            if false then
                                for k58, i55 in pairs(u28.Console) do
                                    if i55 == PlaceId_2 then
                                        u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                        Defusal = u209.Defusal
                                        UnrankedComp = u209.UnrankedComp
                                        if UnrankedComp == Defusal then
                                            u213 = 0
                                        else
                                            u213 = UnrankedComp
                                            if not u213 then
                                                u213 = 0
                                            end
                                        end

                                        function getActiveGamemode(a1) -- Line: 127
                                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                            if a1 == 101836176558619 then
                                                return "trading"
                                            end
                                            if a1 == u209.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if a1 == u209.Defusal then
                                                return "casual"
                                            end
                                            if u213 ~= 0 and a1 == u213 then
                                                return "competitive"
                                            end
                                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                return "tutorial"
                                            end
                                            local v1 = {u16, u19}
                                            local v2 = nil
                                            local v3 = nil
                                            local v4 = a1
                                            for i, j in v1, v2, v3 do
                                                if v4 == j.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if v4 == j.Defusal then
                                                    return "casual"
                                                end
                                                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                    return "competitive"
                                                end
                                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                    return "tutorial"
                                                end
                                            end
                                            return "casual"
                                        end

                                        u244 = table.freeze({
                                            Competitive = "competitive",
                                            Deathmatch = "deathmatch",
                                            Casual = "casual",
                                        })
                                        freeze_2 = table.freeze
                                        v4 = {
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
                                            ITEM_CATEGORIES = table.freeze({
                                                "All",
                                                "Pistol",
                                                "SMG",
                                                "Rifle",
                                                "Heavy",
                                                "Equipment",
                                                "Miscellaneous",
                                            }),
                                        }
                                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Type",
                                            "Float",
                                        })
                                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                            "Quality",
                                            "RAP",
                                            "Newest",
                                            "Alphabetical",
                                            "Collection",
                                            "Equipped",
                                            "Type",
                                            "Float",
                                            "Serial",
                                        })
                                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                        v4.EVENT_END_TIMES = {
                                            ["MEDAL.TV"] = os.time({
                                                year = 2026,
                                                month = 3,
                                                day = 1,
                                                hour = 0,
                                                min = 0,
                                                sec = 0,
                                            }),
                                        }

                                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                            -- upvalues: u244 (val), getActiveGamemode (val)
                                            if typeof(a1) == "string" and u244[a1] then
                                                return u244[a1]
                                            end
                                            return (getActiveGamemode(game.PlaceId))
                                        end

                                        v5 = {
                                            VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                        }
                                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                        v5.UNIVERSE_ID = game.GameId
                                        v5.PLACE_ID = game.PlaceId
                                        v4.SESSION_DATA = v5
                                        v4.VIP_MENU_PANEL_WHITELIST = {
                                            363101315,
                                            3659308968,
                                            1243042178,
                                            107643044,
                                            9236102964,
                                            38260227,
                                            40222641,
                                            3436218611,
                                        }
                                        v4.AIM_ASSIST_CONFIGS = {
                                            PLAYER = {
                                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                Magnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                VerticalMagnetism = {
                                                    Enabled = true,
                                                    MaxAngleHorizontal = 0.20943951023931956,
                                                    MaxAngleVertical = 0.10471975511965978,
                                                    PullStrength = 0.11344640137963143,
                                                    StopThreshold = 0.008726646259971648,
                                                    MaxDistance = 125,
                                                },
                                                RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                            },
                                        }
                                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                            Notifications = 15,
                                            FavoriteGame = 15,
                                            InviteFriend = 15,
                                            JoinGroup = 15,
                                            LikeGame = 15,
                                        })
                                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                        v4.GAMEMODE_PLACE_IDS = {
                                            Trading = 101836176558619,
                                            Deathmatch = u209.Deathmatch,
                                            Casual = u209.Defusal,
                                            Competitive = u213,
                                            Tutorial = u209.Tutorial,
                                        }
                                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                        v4.ACTIVE_DEVICE_PLATFORM = v1
                                        v4.IS_DEVICE_SERVER = v1 ~= nil
                                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                        return freeze_2(v4)
                                    end
                                end
                                v3 = nil
                            else
                                v3 = "Mobile"
                            end
                            u209 = getActiveGamemodeSubplaceIds(
                                if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                v1
                            )
                            Defusal = u209.Defusal
                            UnrankedComp = u209.UnrankedComp
                            if UnrankedComp == Defusal then
                                u213 = 0
                            else
                                u213 = UnrankedComp
                                if not u213 then
                                    u213 = 0
                                end
                            end

                            function getActiveGamemode(a1) -- Line: 127
                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                if a1 == 101836176558619 then
                                    return "trading"
                                end
                                if a1 == u209.Deathmatch then
                                    return "deathmatch"
                                end
                                if a1 == u209.Defusal then
                                    return "casual"
                                end
                                if u213 ~= 0 and a1 == u213 then
                                    return "competitive"
                                end
                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                    return "tutorial"
                                end
                                local v1 = {u16, u19}
                                local v2 = nil
                                local v3 = nil
                                local v4 = a1
                                for i, j in v1, v2, v3 do
                                    if v4 == j.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if v4 == j.Defusal then
                                        return "casual"
                                    end
                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                        return "competitive"
                                    end
                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                        return "tutorial"
                                    end
                                end
                                return "casual"
                            end

                            u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                            freeze_2 = table.freeze
                            v4 = {
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
                            }
                            v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                "Quality",
                                "RAP",
                                "Newest",
                                "Alphabetical",
                                "Collection",
                                "Equipped",
                                "Type",
                                "Float",
                                "Serial",
                            })
                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                            v4.EVENT_END_TIMES = {
                                ["MEDAL.TV"] = os.time({
                                    year = 2026,
                                    month = 3,
                                    day = 1,
                                    hour = 0,
                                    min = 0,
                                    sec = 0,
                                }),
                            }

                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                -- upvalues: u244 (val), getActiveGamemode (val)
                                if typeof(a1) == "string" and u244[a1] then
                                    return u244[a1]
                                end
                                return (getActiveGamemode(game.PlaceId))
                            end

                            v5 = {
                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                            }
                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                            v5.UNIVERSE_ID = game.GameId
                            v5.PLACE_ID = game.PlaceId
                            v4.SESSION_DATA = v5
                            v4.VIP_MENU_PANEL_WHITELIST = {
                                363101315,
                                3659308968,
                                1243042178,
                                107643044,
                                9236102964,
                                38260227,
                                40222641,
                                3436218611,
                            }
                            v4.AIM_ASSIST_CONFIGS = {
                                PLAYER = {
                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                    Friction = {
                                        Enabled = true,
                                        BubbleRadius = 2.4,
                                        MinSensitivity = 0.5,
                                        MaxSensitivity = 1,
                                    },
                                    Magnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    VerticalMagnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    RecoilAssist = {
                                        Enabled = true,
                                        ReductionAmount = 0.5,
                                        HorizontalReductionAmount = 0.85,
                                        RequiresTarget = false,
                                    },
                                },
                            }
                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                Notifications = 15,
                                FavoriteGame = 15,
                                InviteFriend = 15,
                                JoinGroup = 15,
                                LikeGame = 15,
                            })
                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                            v4.GAMEMODE_PLACE_IDS = {
                                Trading = 101836176558619,
                                Deathmatch = u209.Deathmatch,
                                Casual = u209.Defusal,
                                Competitive = u213,
                                Tutorial = u209.Tutorial,
                            }
                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                            v4.ACTIVE_DEVICE_PLATFORM = v1
                            v4.IS_DEVICE_SERVER = v1 ~= nil
                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                            return freeze_2(v4)
                        end
                    end
                    if true then
                        for k59, i56 in pairs(u28.Console) do
                            if i56 == PlaceId_2 then
                                u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                Defusal = u209.Defusal
                                UnrankedComp = u209.UnrankedComp
                                if UnrankedComp == Defusal then
                                    u213 = 0
                                else
                                    u213 = UnrankedComp
                                    if not u213 then
                                        u213 = 0
                                    end
                                end

                                function getActiveGamemode(a1) -- Line: 127
                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                    if a1 == 101836176558619 then
                                        return "trading"
                                    end
                                    if a1 == u209.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if a1 == u209.Defusal then
                                        return "casual"
                                    end
                                    if u213 ~= 0 and a1 == u213 then
                                        return "competitive"
                                    end
                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                        return "tutorial"
                                    end
                                    local v1 = {u16, u19}
                                    local v2 = nil
                                    local v3 = nil
                                    local v4 = a1
                                    for i, j in v1, v2, v3 do
                                        if v4 == j.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if v4 == j.Defusal then
                                            return "casual"
                                        end
                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                            return "competitive"
                                        end
                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                            return "tutorial"
                                        end
                                    end
                                    return "casual"
                                end

                                u244 = table.freeze({
                                    Competitive = "competitive",
                                    Deathmatch = "deathmatch",
                                    Casual = "casual",
                                })
                                freeze_2 = table.freeze
                                v4 = {
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
                                    ITEM_CATEGORIES = table.freeze({
                                        "All",
                                        "Pistol",
                                        "SMG",
                                        "Rifle",
                                        "Heavy",
                                        "Equipment",
                                        "Miscellaneous",
                                    }),
                                }
                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Type",
                                    "Float",
                                })
                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Equipped",
                                    "Type",
                                    "Float",
                                    "Serial",
                                })
                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                v4.EVENT_END_TIMES = {
                                    ["MEDAL.TV"] = os.time({
                                        year = 2026,
                                        month = 3,
                                        day = 1,
                                        hour = 0,
                                        min = 0,
                                        sec = 0,
                                    }),
                                }

                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                    if typeof(a1) == "string" and u244[a1] then
                                        return u244[a1]
                                    end
                                    return (getActiveGamemode(game.PlaceId))
                                end

                                v5 = {
                                    VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                }
                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                v5.UNIVERSE_ID = game.GameId
                                v5.PLACE_ID = game.PlaceId
                                v4.SESSION_DATA = v5
                                v4.VIP_MENU_PANEL_WHITELIST = {
                                    363101315,
                                    3659308968,
                                    1243042178,
                                    107643044,
                                    9236102964,
                                    38260227,
                                    40222641,
                                    3436218611,
                                }
                                v4.AIM_ASSIST_CONFIGS = {
                                    PLAYER = {
                                        TargetSelection = {
                                            Enabled = true,
                                            MaxDistance = 125,
                                            MaxAngle = 0.5235987755982988,
                                        },
                                        Friction = {
                                            Enabled = true,
                                            BubbleRadius = 2.4,
                                            MinSensitivity = 0.5,
                                            MaxSensitivity = 1,
                                        },
                                        Magnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        VerticalMagnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        RecoilAssist = {
                                            Enabled = true,
                                            ReductionAmount = 0.5,
                                            HorizontalReductionAmount = 0.85,
                                            RequiresTarget = false,
                                        },
                                    },
                                }
                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                    Notifications = 15,
                                    FavoriteGame = 15,
                                    InviteFriend = 15,
                                    JoinGroup = 15,
                                    LikeGame = 15,
                                })
                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                v4.GAMEMODE_PLACE_IDS = {
                                    Trading = 101836176558619,
                                    Deathmatch = u209.Deathmatch,
                                    Casual = u209.Defusal,
                                    Competitive = u213,
                                    Tutorial = u209.Tutorial,
                                }
                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                return freeze_2(v4)
                            end
                        end
                        v3 = nil
                    else
                        v3 = "Mobile"
                    end
                    v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                end
            else
                v2 = "Dev"
            end
            u209 = getActiveGamemodeSubplaceIds(v2, v1)
            Defusal = u209.Defusal
            UnrankedComp = u209.UnrankedComp
            if UnrankedComp == Defusal then
                u213 = 0
            else
                u213 = UnrankedComp
                if not u213 then
                    u213 = 0
                end
            end

            function getActiveGamemode(a1) -- Line: 127 -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                if a1 == 101836176558619 then
                    return "trading"
                end
                if a1 == u209.Deathmatch then
                    return "deathmatch"
                end
                if a1 == u209.Defusal then
                    return "casual"
                end
                if u213 ~= 0 and a1 == u213 then
                    return "competitive"
                end
                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                    return "tutorial"
                end
                local v1 = {u16, u19}
                local v2 = nil
                local v3 = nil
                local v4 = a1
                for i, j in v1, v2, v3 do
                    if v4 == j.Deathmatch then
                        return "deathmatch"
                    end
                    if v4 == j.Defusal then
                        return "casual"
                    end
                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                        return "competitive"
                    end
                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                        return "tutorial"
                    end
                end
                return "casual"
            end

            u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
            freeze_2 = table.freeze
            v4 = {
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
            }
            v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                "Quality",
                "RAP",
                "Newest",
                "Alphabetical",
                "Collection",
                "Equipped",
                "Type",
                "Float",
                "Serial",
            })
            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
            v4.EVENT_END_TIMES = {
                ["MEDAL.TV"] = os.time({
                    year = 2026,
                    month = 3,
                    day = 1,
                    hour = 0,
                    min = 0,
                    sec = 0,
                }),
            }

            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171 -- upvalues: u244 (val), getActiveGamemode (val)
                if typeof(a1) == "string" and u244[a1] then
                    return u244[a1]
                end
                return (getActiveGamemode(game.PlaceId))
            end

            v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
            v5.JOB_ID = if not v6 then game.JobId else "Studio"
            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
            v5.UNIVERSE_ID = game.GameId
            v5.PLACE_ID = game.PlaceId
            v4.SESSION_DATA = v5
            v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
            v4.AIM_ASSIST_CONFIGS = {
                PLAYER = {
                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                    Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                    Magnetism = {
                        Enabled = true,
                        MaxAngleHorizontal = 0.20943951023931956,
                        MaxAngleVertical = 0.10471975511965978,
                        PullStrength = 0.11344640137963143,
                        StopThreshold = 0.008726646259971648,
                        MaxDistance = 125,
                    },
                    VerticalMagnetism = {
                        Enabled = true,
                        MaxAngleHorizontal = 0.20943951023931956,
                        MaxAngleVertical = 0.10471975511965978,
                        PullStrength = 0.11344640137963143,
                        StopThreshold = 0.008726646259971648,
                        MaxDistance = 125,
                    },
                    RecoilAssist = {
                        Enabled = true,
                        ReductionAmount = 0.5,
                        HorizontalReductionAmount = 0.85,
                        RequiresTarget = false,
                    },
                },
            }
            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                Notifications = 15,
                FavoriteGame = 15,
                InviteFriend = 15,
                JoinGroup = 15,
                LikeGame = 15,
            })
            v4.ACTIVE_PLACE_ENVIRONMENT = v2
            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
            v4.GAMEMODE_PLACE_IDS = {
                Trading = 101836176558619,
                Deathmatch = u209.Deathmatch,
                Casual = u209.Defusal,
                Competitive = u213,
                Tutorial = u209.Tutorial,
            }
            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
            v4.ACTIVE_DEVICE_PLATFORM = v1
            v4.IS_DEVICE_SERVER = v1 ~= nil
            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
            return freeze_2(v4)
        end
    end
    v1 = nil
else
    v1 = "Mobile"
end
PlaceId_2 = game.PlaceId
for k60, i57 in pairs(u16) do
    if i57 == PlaceId_2 then
        v3 = true
        if not v3 then
            for k61, i58 in pairs(u19) do
                if i58 == PlaceId_2 then
                    v3 = true
                    if v3 then
                        v2 = "Prod"
                    else
                        for k62, i59 in pairs(u28.Mobile) do
                            if i59 == PlaceId_2 then
                                if false then
                                    for k63, i60 in pairs(u28.Console) do
                                        if i60 == PlaceId_2 then
                                            u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                            Defusal = u209.Defusal
                                            UnrankedComp = u209.UnrankedComp
                                            if UnrankedComp == Defusal then
                                                u213 = 0
                                            else
                                                u213 = UnrankedComp
                                                if not u213 then
                                                    u213 = 0
                                                end
                                            end

                                            function getActiveGamemode(a1) -- Line: 127
                                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                                if a1 == 101836176558619 then
                                                    return "trading"
                                                end
                                                if a1 == u209.Deathmatch then
                                                    return "deathmatch"
                                                end
                                                if a1 == u209.Defusal then
                                                    return "casual"
                                                end
                                                if u213 ~= 0 and a1 == u213 then
                                                    return "competitive"
                                                end
                                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                                    return "tutorial"
                                                end
                                                local v1 = {u16, u19}
                                                local v2 = nil
                                                local v3 = nil
                                                local v4 = a1
                                                for i, j in v1, v2, v3 do
                                                    if v4 == j.Deathmatch then
                                                        return "deathmatch"
                                                    end
                                                    if v4 == j.Defusal then
                                                        return "casual"
                                                    end
                                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                        return "competitive"
                                                    end
                                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                        return "tutorial"
                                                    end
                                                end
                                                return "casual"
                                            end

                                            u244 = table.freeze({
                                                Competitive = "competitive",
                                                Deathmatch = "deathmatch",
                                                Casual = "casual",
                                            })
                                            freeze_2 = table.freeze
                                            v4 = {
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
                                                ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                                            }
                                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Type",
                                                "Float",
                                            })
                                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                                "Quality",
                                                "RAP",
                                                "Newest",
                                                "Alphabetical",
                                                "Collection",
                                                "Equipped",
                                                "Type",
                                                "Float",
                                                "Serial",
                                            })
                                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                            v4.EVENT_END_TIMES = {
                                                ["MEDAL.TV"] = os.time({
                                                    year = 2026,
                                                    month = 3,
                                                    day = 1,
                                                    hour = 0,
                                                    min = 0,
                                                    sec = 0,
                                                }),
                                            }

                                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                                -- upvalues: u244 (val), getActiveGamemode (val)
                                                if typeof(a1) == "string" and u244[a1] then
                                                    return u244[a1]
                                                end
                                                return (getActiveGamemode(game.PlaceId))
                                            end

                                            v5 = {
                                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                            }
                                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                            v5.UNIVERSE_ID = game.GameId
                                            v5.PLACE_ID = game.PlaceId
                                            v4.SESSION_DATA = v5
                                            v4.VIP_MENU_PANEL_WHITELIST = {
                                                363101315,
                                                3659308968,
                                                1243042178,
                                                107643044,
                                                9236102964,
                                                38260227,
                                                40222641,
                                                3436218611,
                                            }
                                            v4.AIM_ASSIST_CONFIGS = {
                                                PLAYER = {
                                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                                    Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                                                    Magnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    VerticalMagnetism = {
                                                        Enabled = true,
                                                        MaxAngleHorizontal = 0.20943951023931956,
                                                        MaxAngleVertical = 0.10471975511965978,
                                                        PullStrength = 0.11344640137963143,
                                                        StopThreshold = 0.008726646259971648,
                                                        MaxDistance = 125,
                                                    },
                                                    RecoilAssist = {Enabled = true, ReductionAmount = 0.5, HorizontalReductionAmount = 0.85, RequiresTarget = false},
                                                },
                                            }
                                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                                Notifications = 15,
                                                FavoriteGame = 15,
                                                InviteFriend = 15,
                                                JoinGroup = 15,
                                                LikeGame = 15,
                                            })
                                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                            v4.GAMEMODE_PLACE_IDS = {
                                                Trading = 101836176558619,
                                                Deathmatch = u209.Deathmatch,
                                                Casual = u209.Defusal,
                                                Competitive = u213,
                                                Tutorial = u209.Tutorial,
                                            }
                                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                            v4.ACTIVE_DEVICE_PLATFORM = v1
                                            v4.IS_DEVICE_SERVER = v1 ~= nil
                                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                            return freeze_2(v4)
                                        end
                                    end
                                    v3 = nil
                                else
                                    v3 = "Mobile"
                                end
                                u209 = getActiveGamemodeSubplaceIds(
                                    if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod",
                                    v1
                                )
                                Defusal = u209.Defusal
                                UnrankedComp = u209.UnrankedComp
                                if UnrankedComp == Defusal then
                                    u213 = 0
                                else
                                    u213 = UnrankedComp
                                    if not u213 then
                                        u213 = 0
                                    end
                                end

                                function getActiveGamemode(a1) -- Line: 127
                                    -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                    if a1 == 101836176558619 then
                                        return "trading"
                                    end
                                    if a1 == u209.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if a1 == u209.Defusal then
                                        return "casual"
                                    end
                                    if u213 ~= 0 and a1 == u213 then
                                        return "competitive"
                                    end
                                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                        return "tutorial"
                                    end
                                    local v1 = {u16, u19}
                                    local v2 = nil
                                    local v3 = nil
                                    local v4 = a1
                                    for i, j in v1, v2, v3 do
                                        if v4 == j.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if v4 == j.Defusal then
                                            return "casual"
                                        end
                                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                            return "competitive"
                                        end
                                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                            return "tutorial"
                                        end
                                    end
                                    return "casual"
                                end

                                u244 = table.freeze({
                                    Competitive = "competitive",
                                    Deathmatch = "deathmatch",
                                    Casual = "casual",
                                })
                                freeze_2 = table.freeze
                                v4 = {
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
                                }
                                v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Type",
                                    "Float",
                                })
                                v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                    "Quality",
                                    "RAP",
                                    "Newest",
                                    "Alphabetical",
                                    "Collection",
                                    "Equipped",
                                    "Type",
                                    "Float",
                                    "Serial",
                                })
                                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                v4.EVENT_END_TIMES = {
                                    ["MEDAL.TV"] = os.time({
                                        year = 2026,
                                        month = 3,
                                        day = 1,
                                        hour = 0,
                                        min = 0,
                                        sec = 0,
                                    }),
                                }

                                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                    -- upvalues: u244 (val), getActiveGamemode (val)
                                    if typeof(a1) == "string" and u244[a1] then
                                        return u244[a1]
                                    end
                                    return (getActiveGamemode(game.PlaceId))
                                end

                                v5 = {
                                    VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                }
                                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                v5.UNIVERSE_ID = game.GameId
                                v5.PLACE_ID = game.PlaceId
                                v4.SESSION_DATA = v5
                                v4.VIP_MENU_PANEL_WHITELIST = {
                                    363101315,
                                    3659308968,
                                    1243042178,
                                    107643044,
                                    9236102964,
                                    38260227,
                                    40222641,
                                    3436218611,
                                }
                                v4.AIM_ASSIST_CONFIGS = {
                                    PLAYER = {
                                        TargetSelection = {
                                            Enabled = true,
                                            MaxDistance = 125,
                                            MaxAngle = 0.5235987755982988,
                                        },
                                        Friction = {
                                            Enabled = true,
                                            BubbleRadius = 2.4,
                                            MinSensitivity = 0.5,
                                            MaxSensitivity = 1,
                                        },
                                        Magnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        VerticalMagnetism = {
                                            Enabled = true,
                                            MaxAngleHorizontal = 0.20943951023931956,
                                            MaxAngleVertical = 0.10471975511965978,
                                            PullStrength = 0.11344640137963143,
                                            StopThreshold = 0.008726646259971648,
                                            MaxDistance = 125,
                                        },
                                        RecoilAssist = {
                                            Enabled = true,
                                            ReductionAmount = 0.5,
                                            HorizontalReductionAmount = 0.85,
                                            RequiresTarget = false,
                                        },
                                    },
                                }
                                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                    Notifications = 15,
                                    FavoriteGame = 15,
                                    InviteFriend = 15,
                                    JoinGroup = 15,
                                    LikeGame = 15,
                                })
                                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                v4.GAMEMODE_PLACE_IDS = {
                                    Trading = 101836176558619,
                                    Deathmatch = u209.Deathmatch,
                                    Casual = u209.Defusal,
                                    Competitive = u213,
                                    Tutorial = u209.Tutorial,
                                }
                                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                v4.ACTIVE_DEVICE_PLATFORM = v1
                                v4.IS_DEVICE_SERVER = v1 ~= nil
                                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                return freeze_2(v4)
                            end
                        end
                        if true then
                            for k64, i61 in pairs(u28.Console) do
                                if i61 == PlaceId_2 then
                                    u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                    Defusal = u209.Defusal
                                    UnrankedComp = u209.UnrankedComp
                                    if UnrankedComp == Defusal then
                                        u213 = 0
                                    else
                                        u213 = UnrankedComp
                                        if not u213 then
                                            u213 = 0
                                        end
                                    end

                                    function getActiveGamemode(a1) -- Line: 127
                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                        if a1 == 101836176558619 then
                                            return "trading"
                                        end
                                        if a1 == u209.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if a1 == u209.Defusal then
                                            return "casual"
                                        end
                                        if u213 ~= 0 and a1 == u213 then
                                            return "competitive"
                                        end
                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                            return "tutorial"
                                        end
                                        local v1 = {u16, u19}
                                        local v2 = nil
                                        local v3 = nil
                                        local v4 = a1
                                        for i, j in v1, v2, v3 do
                                            if v4 == j.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if v4 == j.Defusal then
                                                return "casual"
                                            end
                                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                return "competitive"
                                            end
                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                return "tutorial"
                                            end
                                        end
                                        return "casual"
                                    end

                                    u244 = table.freeze({
                                        Competitive = "competitive",
                                        Deathmatch = "deathmatch",
                                        Casual = "casual",
                                    })
                                    freeze_2 = table.freeze
                                    v4 = {
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
                                        ITEM_CATEGORIES = table.freeze({
                                            "All",
                                            "Pistol",
                                            "SMG",
                                            "Rifle",
                                            "Heavy",
                                            "Equipment",
                                            "Miscellaneous",
                                        }),
                                    }
                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Type",
                                        "Float",
                                    })
                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Equipped",
                                        "Type",
                                        "Float",
                                        "Serial",
                                    })
                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                    v4.EVENT_END_TIMES = {
                                        ["MEDAL.TV"] = os.time({
                                            year = 2026,
                                            month = 3,
                                            day = 1,
                                            hour = 0,
                                            min = 0,
                                            sec = 0,
                                        }),
                                    }

                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                        if typeof(a1) == "string" and u244[a1] then
                                            return u244[a1]
                                        end
                                        return (getActiveGamemode(game.PlaceId))
                                    end

                                    v5 = {
                                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                    }
                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                    v5.UNIVERSE_ID = game.GameId
                                    v5.PLACE_ID = game.PlaceId
                                    v4.SESSION_DATA = v5
                                    v4.VIP_MENU_PANEL_WHITELIST = {
                                        363101315,
                                        3659308968,
                                        1243042178,
                                        107643044,
                                        9236102964,
                                        38260227,
                                        40222641,
                                        3436218611,
                                    }
                                    v4.AIM_ASSIST_CONFIGS = {
                                        PLAYER = {
                                            TargetSelection = {
                                                Enabled = true,
                                                MaxDistance = 125,
                                                MaxAngle = 0.5235987755982988,
                                            },
                                            Friction = {
                                                Enabled = true,
                                                BubbleRadius = 2.4,
                                                MinSensitivity = 0.5,
                                                MaxSensitivity = 1,
                                            },
                                            Magnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            VerticalMagnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            RecoilAssist = {
                                                Enabled = true,
                                                ReductionAmount = 0.5,
                                                HorizontalReductionAmount = 0.85,
                                                RequiresTarget = false,
                                            },
                                        },
                                    }
                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                        Notifications = 15,
                                        FavoriteGame = 15,
                                        InviteFriend = 15,
                                        JoinGroup = 15,
                                        LikeGame = 15,
                                    })
                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                    v4.GAMEMODE_PLACE_IDS = {
                                        Trading = 101836176558619,
                                        Deathmatch = u209.Deathmatch,
                                        Casual = u209.Defusal,
                                        Competitive = u213,
                                        Tutorial = u209.Tutorial,
                                    }
                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                    return freeze_2(v4)
                                end
                            end
                            v3 = nil
                        else
                            v3 = "Mobile"
                        end
                        v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
                    end
                    u209 = getActiveGamemodeSubplaceIds(v2, v1)
                    Defusal = u209.Defusal
                    UnrankedComp = u209.UnrankedComp
                    if UnrankedComp == Defusal then
                        u213 = 0
                    else
                        u213 = UnrankedComp
                        if not u213 then
                            u213 = 0
                        end
                    end

                    function getActiveGamemode(a1) -- Line: 127
                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                        if a1 == 101836176558619 then
                            return "trading"
                        end
                        if a1 == u209.Deathmatch then
                            return "deathmatch"
                        end
                        if a1 == u209.Defusal then
                            return "casual"
                        end
                        if u213 ~= 0 and a1 == u213 then
                            return "competitive"
                        end
                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                            return "tutorial"
                        end
                        local v1 = {u16, u19}
                        local v2 = nil
                        local v3 = nil
                        local v4 = a1
                        for i, j in v1, v2, v3 do
                            if v4 == j.Deathmatch then
                                return "deathmatch"
                            end
                            if v4 == j.Defusal then
                                return "casual"
                            end
                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                return "competitive"
                            end
                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                return "tutorial"
                            end
                        end
                        return "casual"
                    end

                    u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                    freeze_2 = table.freeze
                    v4 = {
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
                    }
                    v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                        "Quality",
                        "RAP",
                        "Newest",
                        "Alphabetical",
                        "Collection",
                        "Equipped",
                        "Type",
                        "Float",
                        "Serial",
                    })
                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                    v4.EVENT_END_TIMES = {
                        ["MEDAL.TV"] = os.time({
                            year = 2026,
                            month = 3,
                            day = 1,
                            hour = 0,
                            min = 0,
                            sec = 0,
                        }),
                    }

                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                        -- upvalues: u244 (val), getActiveGamemode (val)
                        if typeof(a1) == "string" and u244[a1] then
                            return u244[a1]
                        end
                        return (getActiveGamemode(game.PlaceId))
                    end

                    v5 = {
                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                    }
                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                    v5.UNIVERSE_ID = game.GameId
                    v5.PLACE_ID = game.PlaceId
                    v4.SESSION_DATA = v5
                    v4.VIP_MENU_PANEL_WHITELIST = {
                        363101315,
                        3659308968,
                        1243042178,
                        107643044,
                        9236102964,
                        38260227,
                        40222641,
                        3436218611,
                    }
                    v4.AIM_ASSIST_CONFIGS = {
                        PLAYER = {
                            TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                            Friction = {
                                Enabled = true,
                                BubbleRadius = 2.4,
                                MinSensitivity = 0.5,
                                MaxSensitivity = 1,
                            },
                            Magnetism = {
                                Enabled = true,
                                MaxAngleHorizontal = 0.20943951023931956,
                                MaxAngleVertical = 0.10471975511965978,
                                PullStrength = 0.11344640137963143,
                                StopThreshold = 0.008726646259971648,
                                MaxDistance = 125,
                            },
                            VerticalMagnetism = {
                                Enabled = true,
                                MaxAngleHorizontal = 0.20943951023931956,
                                MaxAngleVertical = 0.10471975511965978,
                                PullStrength = 0.11344640137963143,
                                StopThreshold = 0.008726646259971648,
                                MaxDistance = 125,
                            },
                            RecoilAssist = {
                                Enabled = true,
                                ReductionAmount = 0.5,
                                HorizontalReductionAmount = 0.85,
                                RequiresTarget = false,
                            },
                        },
                    }
                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                        Notifications = 15,
                        FavoriteGame = 15,
                        InviteFriend = 15,
                        JoinGroup = 15,
                        LikeGame = 15,
                    })
                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                    v4.GAMEMODE_PLACE_IDS = {
                        Trading = 101836176558619,
                        Deathmatch = u209.Deathmatch,
                        Casual = u209.Defusal,
                        Competitive = u213,
                        Tutorial = u209.Tutorial,
                    }
                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                    v4.ACTIVE_DEVICE_PLATFORM = v1
                    v4.IS_DEVICE_SERVER = v1 ~= nil
                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                    return freeze_2(v4)
                end
            end
            v3 = false
            if v3 then
                v2 = "Prod"
            else
                for k65, i62 in pairs(u28.Mobile) do
                    if i62 == PlaceId_2 then
                        if false then
                            for k66, i63 in pairs(u28.Console) do
                                if i63 == PlaceId_2 then
                                    u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                    Defusal = u209.Defusal
                                    UnrankedComp = u209.UnrankedComp
                                    if UnrankedComp == Defusal then
                                        u213 = 0
                                    else
                                        u213 = UnrankedComp
                                        if not u213 then
                                            u213 = 0
                                        end
                                    end

                                    function getActiveGamemode(a1) -- Line: 127
                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                        if a1 == 101836176558619 then
                                            return "trading"
                                        end
                                        if a1 == u209.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if a1 == u209.Defusal then
                                            return "casual"
                                        end
                                        if u213 ~= 0 and a1 == u213 then
                                            return "competitive"
                                        end
                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                            return "tutorial"
                                        end
                                        local v1 = {u16, u19}
                                        local v2 = nil
                                        local v3 = nil
                                        local v4 = a1
                                        for i, j in v1, v2, v3 do
                                            if v4 == j.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if v4 == j.Defusal then
                                                return "casual"
                                            end
                                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                return "competitive"
                                            end
                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                return "tutorial"
                                            end
                                        end
                                        return "casual"
                                    end

                                    u244 = table.freeze({
                                        Competitive = "competitive",
                                        Deathmatch = "deathmatch",
                                        Casual = "casual",
                                    })
                                    freeze_2 = table.freeze
                                    v4 = {
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
                                        ITEM_CATEGORIES = table.freeze({
                                            "All",
                                            "Pistol",
                                            "SMG",
                                            "Rifle",
                                            "Heavy",
                                            "Equipment",
                                            "Miscellaneous",
                                        }),
                                    }
                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Type",
                                        "Float",
                                    })
                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Equipped",
                                        "Type",
                                        "Float",
                                        "Serial",
                                    })
                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                    v4.EVENT_END_TIMES = {
                                        ["MEDAL.TV"] = os.time({
                                            year = 2026,
                                            month = 3,
                                            day = 1,
                                            hour = 0,
                                            min = 0,
                                            sec = 0,
                                        }),
                                    }

                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                        if typeof(a1) == "string" and u244[a1] then
                                            return u244[a1]
                                        end
                                        return (getActiveGamemode(game.PlaceId))
                                    end

                                    v5 = {
                                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                    }
                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                    v5.UNIVERSE_ID = game.GameId
                                    v5.PLACE_ID = game.PlaceId
                                    v4.SESSION_DATA = v5
                                    v4.VIP_MENU_PANEL_WHITELIST = {
                                        363101315,
                                        3659308968,
                                        1243042178,
                                        107643044,
                                        9236102964,
                                        38260227,
                                        40222641,
                                        3436218611,
                                    }
                                    v4.AIM_ASSIST_CONFIGS = {
                                        PLAYER = {
                                            TargetSelection = {
                                                Enabled = true,
                                                MaxDistance = 125,
                                                MaxAngle = 0.5235987755982988,
                                            },
                                            Friction = {
                                                Enabled = true,
                                                BubbleRadius = 2.4,
                                                MinSensitivity = 0.5,
                                                MaxSensitivity = 1,
                                            },
                                            Magnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            VerticalMagnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            RecoilAssist = {
                                                Enabled = true,
                                                ReductionAmount = 0.5,
                                                HorizontalReductionAmount = 0.85,
                                                RequiresTarget = false,
                                            },
                                        },
                                    }
                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                        Notifications = 15,
                                        FavoriteGame = 15,
                                        InviteFriend = 15,
                                        JoinGroup = 15,
                                        LikeGame = 15,
                                    })
                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                    v4.GAMEMODE_PLACE_IDS = {
                                        Trading = 101836176558619,
                                        Deathmatch = u209.Deathmatch,
                                        Casual = u209.Defusal,
                                        Competitive = u213,
                                        Tutorial = u209.Tutorial,
                                    }
                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                    return freeze_2(v4)
                                end
                            end
                            v3 = nil
                        else
                            v3 = "Mobile"
                        end
                        u209 = getActiveGamemodeSubplaceIds(if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod", v1)
                        Defusal = u209.Defusal
                        UnrankedComp = u209.UnrankedComp
                        if UnrankedComp == Defusal then
                            u213 = 0
                        else
                            u213 = UnrankedComp
                            if not u213 then
                                u213 = 0
                            end
                        end

                        function getActiveGamemode(a1) -- Line: 127
                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                            if a1 == 101836176558619 then
                                return "trading"
                            end
                            if a1 == u209.Deathmatch then
                                return "deathmatch"
                            end
                            if a1 == u209.Defusal then
                                return "casual"
                            end
                            if u213 ~= 0 and a1 == u213 then
                                return "competitive"
                            end
                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                return "tutorial"
                            end
                            local v1 = {u16, u19}
                            local v2 = nil
                            local v3 = nil
                            local v4 = a1
                            for i, j in v1, v2, v3 do
                                if v4 == j.Deathmatch then
                                    return "deathmatch"
                                end
                                if v4 == j.Defusal then
                                    return "casual"
                                end
                                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                    return "competitive"
                                end
                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                    return "tutorial"
                                end
                            end
                            return "casual"
                        end

                        u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                        freeze_2 = table.freeze
                        v4 = {
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
                        }
                        v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                            "Quality",
                            "RAP",
                            "Newest",
                            "Alphabetical",
                            "Collection",
                            "Equipped",
                            "Type",
                            "Float",
                            "Serial",
                        })
                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                        v4.EVENT_END_TIMES = {
                            ["MEDAL.TV"] = os.time({
                                year = 2026,
                                month = 3,
                                day = 1,
                                hour = 0,
                                min = 0,
                                sec = 0,
                            }),
                        }

                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                            -- upvalues: u244 (val), getActiveGamemode (val)
                            if typeof(a1) == "string" and u244[a1] then
                                return u244[a1]
                            end
                            return (getActiveGamemode(game.PlaceId))
                        end

                        v5 = {
                            VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                        }
                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                        v5.UNIVERSE_ID = game.GameId
                        v5.PLACE_ID = game.PlaceId
                        v4.SESSION_DATA = v5
                        v4.VIP_MENU_PANEL_WHITELIST = {
                            363101315,
                            3659308968,
                            1243042178,
                            107643044,
                            9236102964,
                            38260227,
                            40222641,
                            3436218611,
                        }
                        v4.AIM_ASSIST_CONFIGS = {
                            PLAYER = {
                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                Friction = {
                                    Enabled = true,
                                    BubbleRadius = 2.4,
                                    MinSensitivity = 0.5,
                                    MaxSensitivity = 1,
                                },
                                Magnetism = {
                                    Enabled = true,
                                    MaxAngleHorizontal = 0.20943951023931956,
                                    MaxAngleVertical = 0.10471975511965978,
                                    PullStrength = 0.11344640137963143,
                                    StopThreshold = 0.008726646259971648,
                                    MaxDistance = 125,
                                },
                                VerticalMagnetism = {
                                    Enabled = true,
                                    MaxAngleHorizontal = 0.20943951023931956,
                                    MaxAngleVertical = 0.10471975511965978,
                                    PullStrength = 0.11344640137963143,
                                    StopThreshold = 0.008726646259971648,
                                    MaxDistance = 125,
                                },
                                RecoilAssist = {
                                    Enabled = true,
                                    ReductionAmount = 0.5,
                                    HorizontalReductionAmount = 0.85,
                                    RequiresTarget = false,
                                },
                            },
                        }
                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                            Notifications = 15,
                            FavoriteGame = 15,
                            InviteFriend = 15,
                            JoinGroup = 15,
                            LikeGame = 15,
                        })
                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                        v4.GAMEMODE_PLACE_IDS = {
                            Trading = 101836176558619,
                            Deathmatch = u209.Deathmatch,
                            Casual = u209.Defusal,
                            Competitive = u213,
                            Tutorial = u209.Tutorial,
                        }
                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                        v4.ACTIVE_DEVICE_PLATFORM = v1
                        v4.IS_DEVICE_SERVER = v1 ~= nil
                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                        return freeze_2(v4)
                    end
                end
                if true then
                    for k67, i64 in pairs(u28.Console) do
                        if i64 == PlaceId_2 then
                            u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                            Defusal = u209.Defusal
                            UnrankedComp = u209.UnrankedComp
                            if UnrankedComp == Defusal then
                                u213 = 0
                            else
                                u213 = UnrankedComp
                                if not u213 then
                                    u213 = 0
                                end
                            end

                            function getActiveGamemode(a1) -- Line: 127
                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                if a1 == 101836176558619 then
                                    return "trading"
                                end
                                if a1 == u209.Deathmatch then
                                    return "deathmatch"
                                end
                                if a1 == u209.Defusal then
                                    return "casual"
                                end
                                if u213 ~= 0 and a1 == u213 then
                                    return "competitive"
                                end
                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                    return "tutorial"
                                end
                                local v1 = {u16, u19}
                                local v2 = nil
                                local v3 = nil
                                local v4 = a1
                                for i, j in v1, v2, v3 do
                                    if v4 == j.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if v4 == j.Defusal then
                                        return "casual"
                                    end
                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                        return "competitive"
                                    end
                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                        return "tutorial"
                                    end
                                end
                                return "casual"
                            end

                            u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                            freeze_2 = table.freeze
                            v4 = {
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
                                ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                            }
                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                "Quality",
                                "RAP",
                                "Newest",
                                "Alphabetical",
                                "Collection",
                                "Equipped",
                                "Type",
                                "Float",
                                "Serial",
                            })
                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                            v4.EVENT_END_TIMES = {
                                ["MEDAL.TV"] = os.time({
                                    year = 2026,
                                    month = 3,
                                    day = 1,
                                    hour = 0,
                                    min = 0,
                                    sec = 0,
                                }),
                            }

                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                -- upvalues: u244 (val), getActiveGamemode (val)
                                if typeof(a1) == "string" and u244[a1] then
                                    return u244[a1]
                                end
                                return (getActiveGamemode(game.PlaceId))
                            end

                            v5 = {
                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                            }
                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                            v5.UNIVERSE_ID = game.GameId
                            v5.PLACE_ID = game.PlaceId
                            v4.SESSION_DATA = v5
                            v4.VIP_MENU_PANEL_WHITELIST = {
                                363101315,
                                3659308968,
                                1243042178,
                                107643044,
                                9236102964,
                                38260227,
                                40222641,
                                3436218611,
                            }
                            v4.AIM_ASSIST_CONFIGS = {
                                PLAYER = {
                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                    Friction = {
                                        Enabled = true,
                                        BubbleRadius = 2.4,
                                        MinSensitivity = 0.5,
                                        MaxSensitivity = 1,
                                    },
                                    Magnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    VerticalMagnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    RecoilAssist = {
                                        Enabled = true,
                                        ReductionAmount = 0.5,
                                        HorizontalReductionAmount = 0.85,
                                        RequiresTarget = false,
                                    },
                                },
                            }
                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                Notifications = 15,
                                FavoriteGame = 15,
                                InviteFriend = 15,
                                JoinGroup = 15,
                                LikeGame = 15,
                            })
                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                            v4.GAMEMODE_PLACE_IDS = {
                                Trading = 101836176558619,
                                Deathmatch = u209.Deathmatch,
                                Casual = u209.Defusal,
                                Competitive = u213,
                                Tutorial = u209.Tutorial,
                            }
                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                            v4.ACTIVE_DEVICE_PLATFORM = v1
                            v4.IS_DEVICE_SERVER = v1 ~= nil
                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                            return freeze_2(v4)
                        end
                    end
                    v3 = nil
                else
                    v3 = "Mobile"
                end
                v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
            end
        else
            v2 = "Dev"
        end
        u209 = getActiveGamemodeSubplaceIds(v2, v1)
        Defusal = u209.Defusal
        UnrankedComp = u209.UnrankedComp
        if UnrankedComp == Defusal then
            u213 = 0
        else
            u213 = UnrankedComp
            if not u213 then
                u213 = 0
            end
        end

        function getActiveGamemode(a1) -- Line: 127 -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
            if a1 == 101836176558619 then
                return "trading"
            end
            if a1 == u209.Deathmatch then
                return "deathmatch"
            end
            if a1 == u209.Defusal then
                return "casual"
            end
            if u213 ~= 0 and a1 == u213 then
                return "competitive"
            end
            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                return "tutorial"
            end
            local v1 = {u16, u19}
            local v2 = nil
            local v3 = nil
            local v4 = a1
            for i, j in v1, v2, v3 do
                if v4 == j.Deathmatch then
                    return "deathmatch"
                end
                if v4 == j.Defusal then
                    return "casual"
                end
                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                    return "competitive"
                end
                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                    return "tutorial"
                end
            end
            return "casual"
        end

        u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
        freeze_2 = table.freeze
        v4 = {
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
        }
        v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
            "Quality",
            "RAP",
            "Newest",
            "Alphabetical",
            "Collection",
            "Equipped",
            "Type",
            "Float",
            "Serial",
        })
        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
        v4.EVENT_END_TIMES = {
            ["MEDAL.TV"] = os.time({
                year = 2026,
                month = 3,
                day = 1,
                hour = 0,
                min = 0,
                sec = 0,
            }),
        }

        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171 -- upvalues: u244 (val), getActiveGamemode (val)
            if typeof(a1) == "string" and u244[a1] then
                return u244[a1]
            end
            return (getActiveGamemode(game.PlaceId))
        end

        v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
        v5.JOB_ID = if not v6 then game.JobId else "Studio"
        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
        v5.UNIVERSE_ID = game.GameId
        v5.PLACE_ID = game.PlaceId
        v4.SESSION_DATA = v5
        v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
        v4.AIM_ASSIST_CONFIGS = {
            PLAYER = {
                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                Magnetism = {
                    Enabled = true,
                    MaxAngleHorizontal = 0.20943951023931956,
                    MaxAngleVertical = 0.10471975511965978,
                    PullStrength = 0.11344640137963143,
                    StopThreshold = 0.008726646259971648,
                    MaxDistance = 125,
                },
                VerticalMagnetism = {
                    Enabled = true,
                    MaxAngleHorizontal = 0.20943951023931956,
                    MaxAngleVertical = 0.10471975511965978,
                    PullStrength = 0.11344640137963143,
                    StopThreshold = 0.008726646259971648,
                    MaxDistance = 125,
                },
                RecoilAssist = {
                    Enabled = true,
                    ReductionAmount = 0.5,
                    HorizontalReductionAmount = 0.85,
                    RequiresTarget = false,
                },
            },
        }
        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
            Notifications = 15,
            FavoriteGame = 15,
            InviteFriend = 15,
            JoinGroup = 15,
            LikeGame = 15,
        })
        v4.ACTIVE_PLACE_ENVIRONMENT = v2
        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
        v4.GAMEMODE_PLACE_IDS = {
            Trading = 101836176558619,
            Deathmatch = u209.Deathmatch,
            Casual = u209.Defusal,
            Competitive = u213,
            Tutorial = u209.Tutorial,
        }
        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
        v4.ACTIVE_DEVICE_PLATFORM = v1
        v4.IS_DEVICE_SERVER = v1 ~= nil
        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
        return freeze_2(v4)
    end
end
v3 = false
if not v3 then
    for k68, i65 in pairs(u19) do
        if i65 == PlaceId_2 then
            v3 = true
            if v3 then
                v2 = "Prod"
            else
                for k69, i66 in pairs(u28.Mobile) do
                    if i66 == PlaceId_2 then
                        if false then
                            for k70, i67 in pairs(u28.Console) do
                                if i67 == PlaceId_2 then
                                    u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                                    Defusal = u209.Defusal
                                    UnrankedComp = u209.UnrankedComp
                                    if UnrankedComp == Defusal then
                                        u213 = 0
                                    else
                                        u213 = UnrankedComp
                                        if not u213 then
                                            u213 = 0
                                        end
                                    end

                                    function getActiveGamemode(a1) -- Line: 127
                                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                        if a1 == 101836176558619 then
                                            return "trading"
                                        end
                                        if a1 == u209.Deathmatch then
                                            return "deathmatch"
                                        end
                                        if a1 == u209.Defusal then
                                            return "casual"
                                        end
                                        if u213 ~= 0 and a1 == u213 then
                                            return "competitive"
                                        end
                                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                            return "tutorial"
                                        end
                                        local v1 = {u16, u19}
                                        local v2 = nil
                                        local v3 = nil
                                        local v4 = a1
                                        for i, j in v1, v2, v3 do
                                            if v4 == j.Deathmatch then
                                                return "deathmatch"
                                            end
                                            if v4 == j.Defusal then
                                                return "casual"
                                            end
                                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                                return "competitive"
                                            end
                                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                                return "tutorial"
                                            end
                                        end
                                        return "casual"
                                    end

                                    u244 = table.freeze({
                                        Competitive = "competitive",
                                        Deathmatch = "deathmatch",
                                        Casual = "casual",
                                    })
                                    freeze_2 = table.freeze
                                    v4 = {
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
                                        ITEM_CATEGORIES = table.freeze({
                                            "All",
                                            "Pistol",
                                            "SMG",
                                            "Rifle",
                                            "Heavy",
                                            "Equipment",
                                            "Miscellaneous",
                                        }),
                                    }
                                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Type",
                                        "Float",
                                    })
                                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                        "Quality",
                                        "RAP",
                                        "Newest",
                                        "Alphabetical",
                                        "Collection",
                                        "Equipped",
                                        "Type",
                                        "Float",
                                        "Serial",
                                    })
                                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                                    v4.EVENT_END_TIMES = {
                                        ["MEDAL.TV"] = os.time({
                                            year = 2026,
                                            month = 3,
                                            day = 1,
                                            hour = 0,
                                            min = 0,
                                            sec = 0,
                                        }),
                                    }

                                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                        -- upvalues: u244 (val), getActiveGamemode (val)
                                        if typeof(a1) == "string" and u244[a1] then
                                            return u244[a1]
                                        end
                                        return (getActiveGamemode(game.PlaceId))
                                    end

                                    v5 = {
                                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                                    }
                                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                                    v5.UNIVERSE_ID = game.GameId
                                    v5.PLACE_ID = game.PlaceId
                                    v4.SESSION_DATA = v5
                                    v4.VIP_MENU_PANEL_WHITELIST = {
                                        363101315,
                                        3659308968,
                                        1243042178,
                                        107643044,
                                        9236102964,
                                        38260227,
                                        40222641,
                                        3436218611,
                                    }
                                    v4.AIM_ASSIST_CONFIGS = {
                                        PLAYER = {
                                            TargetSelection = {
                                                Enabled = true,
                                                MaxDistance = 125,
                                                MaxAngle = 0.5235987755982988,
                                            },
                                            Friction = {
                                                Enabled = true,
                                                BubbleRadius = 2.4,
                                                MinSensitivity = 0.5,
                                                MaxSensitivity = 1,
                                            },
                                            Magnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            VerticalMagnetism = {
                                                Enabled = true,
                                                MaxAngleHorizontal = 0.20943951023931956,
                                                MaxAngleVertical = 0.10471975511965978,
                                                PullStrength = 0.11344640137963143,
                                                StopThreshold = 0.008726646259971648,
                                                MaxDistance = 125,
                                            },
                                            RecoilAssist = {
                                                Enabled = true,
                                                ReductionAmount = 0.5,
                                                HorizontalReductionAmount = 0.85,
                                                RequiresTarget = false,
                                            },
                                        },
                                    }
                                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                        Notifications = 15,
                                        FavoriteGame = 15,
                                        InviteFriend = 15,
                                        JoinGroup = 15,
                                        LikeGame = 15,
                                    })
                                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                                    v4.GAMEMODE_PLACE_IDS = {
                                        Trading = 101836176558619,
                                        Deathmatch = u209.Deathmatch,
                                        Casual = u209.Defusal,
                                        Competitive = u213,
                                        Tutorial = u209.Tutorial,
                                    }
                                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                                    v4.ACTIVE_DEVICE_PLATFORM = v1
                                    v4.IS_DEVICE_SERVER = v1 ~= nil
                                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                                    return freeze_2(v4)
                                end
                            end
                            v3 = nil
                        else
                            v3 = "Mobile"
                        end
                        u209 = getActiveGamemodeSubplaceIds(if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod", v1)
                        Defusal = u209.Defusal
                        UnrankedComp = u209.UnrankedComp
                        if UnrankedComp == Defusal then
                            u213 = 0
                        else
                            u213 = UnrankedComp
                            if not u213 then
                                u213 = 0
                            end
                        end

                        function getActiveGamemode(a1) -- Line: 127
                            -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                            if a1 == 101836176558619 then
                                return "trading"
                            end
                            if a1 == u209.Deathmatch then
                                return "deathmatch"
                            end
                            if a1 == u209.Defusal then
                                return "casual"
                            end
                            if u213 ~= 0 and a1 == u213 then
                                return "competitive"
                            end
                            if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                return "tutorial"
                            end
                            local v1 = {u16, u19}
                            local v2 = nil
                            local v3 = nil
                            local v4 = a1
                            for i, j in v1, v2, v3 do
                                if v4 == j.Deathmatch then
                                    return "deathmatch"
                                end
                                if v4 == j.Defusal then
                                    return "casual"
                                end
                                if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                    return "competitive"
                                end
                                if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                    return "tutorial"
                                end
                            end
                            return "casual"
                        end

                        u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                        freeze_2 = table.freeze
                        v4 = {
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
                        }
                        v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                        v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                        v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                            "Quality",
                            "RAP",
                            "Newest",
                            "Alphabetical",
                            "Collection",
                            "Equipped",
                            "Type",
                            "Float",
                            "Serial",
                        })
                        v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                        v4.EVENT_END_TIMES = {
                            ["MEDAL.TV"] = os.time({
                                year = 2026,
                                month = 3,
                                day = 1,
                                hour = 0,
                                min = 0,
                                sec = 0,
                            }),
                        }

                        function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                            -- upvalues: u244 (val), getActiveGamemode (val)
                            if typeof(a1) == "string" and u244[a1] then
                                return u244[a1]
                            end
                            return (getActiveGamemode(game.PlaceId))
                        end

                        v5 = {
                            VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                        }
                        v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                        v5.JOB_ID = if not v6 then game.JobId else "Studio"
                        v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                        v5.UNIVERSE_ID = game.GameId
                        v5.PLACE_ID = game.PlaceId
                        v4.SESSION_DATA = v5
                        v4.VIP_MENU_PANEL_WHITELIST = {
                            363101315,
                            3659308968,
                            1243042178,
                            107643044,
                            9236102964,
                            38260227,
                            40222641,
                            3436218611,
                        }
                        v4.AIM_ASSIST_CONFIGS = {
                            PLAYER = {
                                TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                Friction = {
                                    Enabled = true,
                                    BubbleRadius = 2.4,
                                    MinSensitivity = 0.5,
                                    MaxSensitivity = 1,
                                },
                                Magnetism = {
                                    Enabled = true,
                                    MaxAngleHorizontal = 0.20943951023931956,
                                    MaxAngleVertical = 0.10471975511965978,
                                    PullStrength = 0.11344640137963143,
                                    StopThreshold = 0.008726646259971648,
                                    MaxDistance = 125,
                                },
                                VerticalMagnetism = {
                                    Enabled = true,
                                    MaxAngleHorizontal = 0.20943951023931956,
                                    MaxAngleVertical = 0.10471975511965978,
                                    PullStrength = 0.11344640137963143,
                                    StopThreshold = 0.008726646259971648,
                                    MaxDistance = 125,
                                },
                                RecoilAssist = {
                                    Enabled = true,
                                    ReductionAmount = 0.5,
                                    HorizontalReductionAmount = 0.85,
                                    RequiresTarget = false,
                                },
                            },
                        }
                        v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                            Notifications = 15,
                            FavoriteGame = 15,
                            InviteFriend = 15,
                            JoinGroup = 15,
                            LikeGame = 15,
                        })
                        v4.ACTIVE_PLACE_ENVIRONMENT = v2
                        v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                        v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                        v4.GAMEMODE_PLACE_IDS = {
                            Trading = 101836176558619,
                            Deathmatch = u209.Deathmatch,
                            Casual = u209.Defusal,
                            Competitive = u213,
                            Tutorial = u209.Tutorial,
                        }
                        v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                        v4.ACTIVE_DEVICE_PLATFORM = v1
                        v4.IS_DEVICE_SERVER = v1 ~= nil
                        v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                        return freeze_2(v4)
                    end
                end
                if true then
                    for k71, i68 in pairs(u28.Console) do
                        if i68 == PlaceId_2 then
                            u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                            Defusal = u209.Defusal
                            UnrankedComp = u209.UnrankedComp
                            if UnrankedComp == Defusal then
                                u213 = 0
                            else
                                u213 = UnrankedComp
                                if not u213 then
                                    u213 = 0
                                end
                            end

                            function getActiveGamemode(a1) -- Line: 127
                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                if a1 == 101836176558619 then
                                    return "trading"
                                end
                                if a1 == u209.Deathmatch then
                                    return "deathmatch"
                                end
                                if a1 == u209.Defusal then
                                    return "casual"
                                end
                                if u213 ~= 0 and a1 == u213 then
                                    return "competitive"
                                end
                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                    return "tutorial"
                                end
                                local v1 = {u16, u19}
                                local v2 = nil
                                local v3 = nil
                                local v4 = a1
                                for i, j in v1, v2, v3 do
                                    if v4 == j.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if v4 == j.Defusal then
                                        return "casual"
                                    end
                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                        return "competitive"
                                    end
                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                        return "tutorial"
                                    end
                                end
                                return "casual"
                            end

                            u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                            freeze_2 = table.freeze
                            v4 = {
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
                                ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                            }
                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                "Quality",
                                "RAP",
                                "Newest",
                                "Alphabetical",
                                "Collection",
                                "Equipped",
                                "Type",
                                "Float",
                                "Serial",
                            })
                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                            v4.EVENT_END_TIMES = {
                                ["MEDAL.TV"] = os.time({
                                    year = 2026,
                                    month = 3,
                                    day = 1,
                                    hour = 0,
                                    min = 0,
                                    sec = 0,
                                }),
                            }

                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                -- upvalues: u244 (val), getActiveGamemode (val)
                                if typeof(a1) == "string" and u244[a1] then
                                    return u244[a1]
                                end
                                return (getActiveGamemode(game.PlaceId))
                            end

                            v5 = {
                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                            }
                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                            v5.UNIVERSE_ID = game.GameId
                            v5.PLACE_ID = game.PlaceId
                            v4.SESSION_DATA = v5
                            v4.VIP_MENU_PANEL_WHITELIST = {
                                363101315,
                                3659308968,
                                1243042178,
                                107643044,
                                9236102964,
                                38260227,
                                40222641,
                                3436218611,
                            }
                            v4.AIM_ASSIST_CONFIGS = {
                                PLAYER = {
                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                    Friction = {
                                        Enabled = true,
                                        BubbleRadius = 2.4,
                                        MinSensitivity = 0.5,
                                        MaxSensitivity = 1,
                                    },
                                    Magnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    VerticalMagnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    RecoilAssist = {
                                        Enabled = true,
                                        ReductionAmount = 0.5,
                                        HorizontalReductionAmount = 0.85,
                                        RequiresTarget = false,
                                    },
                                },
                            }
                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                Notifications = 15,
                                FavoriteGame = 15,
                                InviteFriend = 15,
                                JoinGroup = 15,
                                LikeGame = 15,
                            })
                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                            v4.GAMEMODE_PLACE_IDS = {
                                Trading = 101836176558619,
                                Deathmatch = u209.Deathmatch,
                                Casual = u209.Defusal,
                                Competitive = u213,
                                Tutorial = u209.Tutorial,
                            }
                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                            v4.ACTIVE_DEVICE_PLATFORM = v1
                            v4.IS_DEVICE_SERVER = v1 ~= nil
                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                            return freeze_2(v4)
                        end
                    end
                    v3 = nil
                else
                    v3 = "Mobile"
                end
                v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
            end
            u209 = getActiveGamemodeSubplaceIds(v2, v1)
            Defusal = u209.Defusal
            UnrankedComp = u209.UnrankedComp
            if UnrankedComp == Defusal then
                u213 = 0
            else
                u213 = UnrankedComp
                if not u213 then
                    u213 = 0
                end
            end

            function getActiveGamemode(a1) -- Line: 127 -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                if a1 == 101836176558619 then
                    return "trading"
                end
                if a1 == u209.Deathmatch then
                    return "deathmatch"
                end
                if a1 == u209.Defusal then
                    return "casual"
                end
                if u213 ~= 0 and a1 == u213 then
                    return "competitive"
                end
                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                    return "tutorial"
                end
                local v1 = {u16, u19}
                local v2 = nil
                local v3 = nil
                local v4 = a1
                for i, j in v1, v2, v3 do
                    if v4 == j.Deathmatch then
                        return "deathmatch"
                    end
                    if v4 == j.Defusal then
                        return "casual"
                    end
                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                        return "competitive"
                    end
                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                        return "tutorial"
                    end
                end
                return "casual"
            end

            u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
            freeze_2 = table.freeze
            v4 = {
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
            }
            v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                "Quality",
                "RAP",
                "Newest",
                "Alphabetical",
                "Collection",
                "Equipped",
                "Type",
                "Float",
                "Serial",
            })
            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
            v4.EVENT_END_TIMES = {
                ["MEDAL.TV"] = os.time({
                    year = 2026,
                    month = 3,
                    day = 1,
                    hour = 0,
                    min = 0,
                    sec = 0,
                }),
            }

            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171 -- upvalues: u244 (val), getActiveGamemode (val)
                if typeof(a1) == "string" and u244[a1] then
                    return u244[a1]
                end
                return (getActiveGamemode(game.PlaceId))
            end

            v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
            v5.JOB_ID = if not v6 then game.JobId else "Studio"
            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
            v5.UNIVERSE_ID = game.GameId
            v5.PLACE_ID = game.PlaceId
            v4.SESSION_DATA = v5
            v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
            v4.AIM_ASSIST_CONFIGS = {
                PLAYER = {
                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                    Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                    Magnetism = {
                        Enabled = true,
                        MaxAngleHorizontal = 0.20943951023931956,
                        MaxAngleVertical = 0.10471975511965978,
                        PullStrength = 0.11344640137963143,
                        StopThreshold = 0.008726646259971648,
                        MaxDistance = 125,
                    },
                    VerticalMagnetism = {
                        Enabled = true,
                        MaxAngleHorizontal = 0.20943951023931956,
                        MaxAngleVertical = 0.10471975511965978,
                        PullStrength = 0.11344640137963143,
                        StopThreshold = 0.008726646259971648,
                        MaxDistance = 125,
                    },
                    RecoilAssist = {
                        Enabled = true,
                        ReductionAmount = 0.5,
                        HorizontalReductionAmount = 0.85,
                        RequiresTarget = false,
                    },
                },
            }
            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                Notifications = 15,
                FavoriteGame = 15,
                InviteFriend = 15,
                JoinGroup = 15,
                LikeGame = 15,
            })
            v4.ACTIVE_PLACE_ENVIRONMENT = v2
            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
            v4.GAMEMODE_PLACE_IDS = {
                Trading = 101836176558619,
                Deathmatch = u209.Deathmatch,
                Casual = u209.Defusal,
                Competitive = u213,
                Tutorial = u209.Tutorial,
            }
            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
            v4.ACTIVE_DEVICE_PLATFORM = v1
            v4.IS_DEVICE_SERVER = v1 ~= nil
            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
            return freeze_2(v4)
        end
    end
    v3 = false
    if v3 then
        v2 = "Prod"
    else
        for k72, i69 in pairs(u28.Mobile) do
            if i69 == PlaceId_2 then
                if false then
                    for k73, i70 in pairs(u28.Console) do
                        if i70 == PlaceId_2 then
                            u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                            Defusal = u209.Defusal
                            UnrankedComp = u209.UnrankedComp
                            if UnrankedComp == Defusal then
                                u213 = 0
                            else
                                u213 = UnrankedComp
                                if not u213 then
                                    u213 = 0
                                end
                            end

                            function getActiveGamemode(a1) -- Line: 127
                                -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                                if a1 == 101836176558619 then
                                    return "trading"
                                end
                                if a1 == u209.Deathmatch then
                                    return "deathmatch"
                                end
                                if a1 == u209.Defusal then
                                    return "casual"
                                end
                                if u213 ~= 0 and a1 == u213 then
                                    return "competitive"
                                end
                                if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                                    return "tutorial"
                                end
                                local v1 = {u16, u19}
                                local v2 = nil
                                local v3 = nil
                                local v4 = a1
                                for i, j in v1, v2, v3 do
                                    if v4 == j.Deathmatch then
                                        return "deathmatch"
                                    end
                                    if v4 == j.Defusal then
                                        return "casual"
                                    end
                                    if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                        return "competitive"
                                    end
                                    if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                        return "tutorial"
                                    end
                                end
                                return "casual"
                            end

                            u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                            freeze_2 = table.freeze
                            v4 = {
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
                                ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                            }
                            v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                            v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                                "Quality",
                                "RAP",
                                "Newest",
                                "Alphabetical",
                                "Collection",
                                "Equipped",
                                "Type",
                                "Float",
                                "Serial",
                            })
                            v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                            v4.EVENT_END_TIMES = {
                                ["MEDAL.TV"] = os.time({
                                    year = 2026,
                                    month = 3,
                                    day = 1,
                                    hour = 0,
                                    min = 0,
                                    sec = 0,
                                }),
                            }

                            function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                                -- upvalues: u244 (val), getActiveGamemode (val)
                                if typeof(a1) == "string" and u244[a1] then
                                    return u244[a1]
                                end
                                return (getActiveGamemode(game.PlaceId))
                            end

                            v5 = {
                                VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                            }
                            v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                            v5.JOB_ID = if not v6 then game.JobId else "Studio"
                            v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                            v5.UNIVERSE_ID = game.GameId
                            v5.PLACE_ID = game.PlaceId
                            v4.SESSION_DATA = v5
                            v4.VIP_MENU_PANEL_WHITELIST = {
                                363101315,
                                3659308968,
                                1243042178,
                                107643044,
                                9236102964,
                                38260227,
                                40222641,
                                3436218611,
                            }
                            v4.AIM_ASSIST_CONFIGS = {
                                PLAYER = {
                                    TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                                    Friction = {
                                        Enabled = true,
                                        BubbleRadius = 2.4,
                                        MinSensitivity = 0.5,
                                        MaxSensitivity = 1,
                                    },
                                    Magnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    VerticalMagnetism = {
                                        Enabled = true,
                                        MaxAngleHorizontal = 0.20943951023931956,
                                        MaxAngleVertical = 0.10471975511965978,
                                        PullStrength = 0.11344640137963143,
                                        StopThreshold = 0.008726646259971648,
                                        MaxDistance = 125,
                                    },
                                    RecoilAssist = {
                                        Enabled = true,
                                        ReductionAmount = 0.5,
                                        HorizontalReductionAmount = 0.85,
                                        RequiresTarget = false,
                                    },
                                },
                            }
                            v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                                Notifications = 15,
                                FavoriteGame = 15,
                                InviteFriend = 15,
                                JoinGroup = 15,
                                LikeGame = 15,
                            })
                            v4.ACTIVE_PLACE_ENVIRONMENT = v2
                            v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                            v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                            v4.GAMEMODE_PLACE_IDS = {
                                Trading = 101836176558619,
                                Deathmatch = u209.Deathmatch,
                                Casual = u209.Defusal,
                                Competitive = u213,
                                Tutorial = u209.Tutorial,
                            }
                            v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                            v4.ACTIVE_DEVICE_PLATFORM = v1
                            v4.IS_DEVICE_SERVER = v1 ~= nil
                            v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                            return freeze_2(v4)
                        end
                    end
                    v3 = nil
                else
                    v3 = "Mobile"
                end
                u209 = getActiveGamemodeSubplaceIds(if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod", v1)
                Defusal = u209.Defusal
                UnrankedComp = u209.UnrankedComp
                if UnrankedComp == Defusal then
                    u213 = 0
                else
                    u213 = UnrankedComp
                    if not u213 then
                        u213 = 0
                    end
                end

                function getActiveGamemode(a1) -- Line: 127 -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                    if a1 == 101836176558619 then
                        return "trading"
                    end
                    if a1 == u209.Deathmatch then
                        return "deathmatch"
                    end
                    if a1 == u209.Defusal then
                        return "casual"
                    end
                    if u213 ~= 0 and a1 == u213 then
                        return "competitive"
                    end
                    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                        return "tutorial"
                    end
                    local v1 = {u16, u19}
                    local v2 = nil
                    local v3 = nil
                    local v4 = a1
                    for i, j in v1, v2, v3 do
                        if v4 == j.Deathmatch then
                            return "deathmatch"
                        end
                        if v4 == j.Defusal then
                            return "casual"
                        end
                        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                            return "competitive"
                        end
                        if j.Tutorial ~= 0 and v4 == j.Tutorial then
                            return "tutorial"
                        end
                    end
                    return "casual"
                end

                u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                freeze_2 = table.freeze
                v4 = {
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
                }
                v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
                v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                    "Quality",
                    "RAP",
                    "Newest",
                    "Alphabetical",
                    "Collection",
                    "Equipped",
                    "Type",
                    "Float",
                    "Serial",
                })
                v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                v4.EVENT_END_TIMES = {
                    ["MEDAL.TV"] = os.time({
                        year = 2026,
                        month = 3,
                        day = 1,
                        hour = 0,
                        min = 0,
                        sec = 0,
                    }),
                }

                function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                    -- upvalues: u244 (val), getActiveGamemode (val)
                    if typeof(a1) == "string" and u244[a1] then
                        return u244[a1]
                    end
                    return (getActiveGamemode(game.PlaceId))
                end

                v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
                v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                v5.JOB_ID = if not v6 then game.JobId else "Studio"
                v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                v5.UNIVERSE_ID = game.GameId
                v5.PLACE_ID = game.PlaceId
                v4.SESSION_DATA = v5
                v4.VIP_MENU_PANEL_WHITELIST = {
                    363101315,
                    3659308968,
                    1243042178,
                    107643044,
                    9236102964,
                    38260227,
                    40222641,
                    3436218611,
                }
                v4.AIM_ASSIST_CONFIGS = {
                    PLAYER = {
                        TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                        Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
                        Magnetism = {
                            Enabled = true,
                            MaxAngleHorizontal = 0.20943951023931956,
                            MaxAngleVertical = 0.10471975511965978,
                            PullStrength = 0.11344640137963143,
                            StopThreshold = 0.008726646259971648,
                            MaxDistance = 125,
                        },
                        VerticalMagnetism = {
                            Enabled = true,
                            MaxAngleHorizontal = 0.20943951023931956,
                            MaxAngleVertical = 0.10471975511965978,
                            PullStrength = 0.11344640137963143,
                            StopThreshold = 0.008726646259971648,
                            MaxDistance = 125,
                        },
                        RecoilAssist = {
                            Enabled = true,
                            ReductionAmount = 0.5,
                            HorizontalReductionAmount = 0.85,
                            RequiresTarget = false,
                        },
                    },
                }
                v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                    Notifications = 15,
                    FavoriteGame = 15,
                    InviteFriend = 15,
                    JoinGroup = 15,
                    LikeGame = 15,
                })
                v4.ACTIVE_PLACE_ENVIRONMENT = v2
                v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                v4.GAMEMODE_PLACE_IDS = {
                    Trading = 101836176558619,
                    Deathmatch = u209.Deathmatch,
                    Casual = u209.Defusal,
                    Competitive = u213,
                    Tutorial = u209.Tutorial,
                }
                v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                v4.ACTIVE_DEVICE_PLATFORM = v1
                v4.IS_DEVICE_SERVER = v1 ~= nil
                v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                return freeze_2(v4)
            end
        end
        if true then
            for k74, i71 in pairs(u28.Console) do
                if i71 == PlaceId_2 then
                    u209 = getActiveGamemodeSubplaceIds("Prod", v1)
                    Defusal = u209.Defusal
                    UnrankedComp = u209.UnrankedComp
                    if UnrankedComp == Defusal then
                        u213 = 0
                    else
                        u213 = UnrankedComp
                        if not u213 then
                            u213 = 0
                        end
                    end

                    function getActiveGamemode(a1) -- Line: 127
                        -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
                        if a1 == 101836176558619 then
                            return "trading"
                        end
                        if a1 == u209.Deathmatch then
                            return "deathmatch"
                        end
                        if a1 == u209.Defusal then
                            return "casual"
                        end
                        if u213 ~= 0 and a1 == u213 then
                            return "competitive"
                        end
                        if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
                            return "tutorial"
                        end
                        local v1 = {u16, u19}
                        local v2 = nil
                        local v3 = nil
                        local v4 = a1
                        for i, j in v1, v2, v3 do
                            if v4 == j.Deathmatch then
                                return "deathmatch"
                            end
                            if v4 == j.Defusal then
                                return "casual"
                            end
                            if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
                                return "competitive"
                            end
                            if j.Tutorial ~= 0 and v4 == j.Tutorial then
                                return "tutorial"
                            end
                        end
                        return "casual"
                    end

                    u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
                    freeze_2 = table.freeze
                    v4 = {
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
                        ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"}),
                    }
                    v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
                    v4.INVENTORY_SORTING_OPTIONS = table.freeze({
                        "Quality",
                        "RAP",
                        "Newest",
                        "Alphabetical",
                        "Collection",
                        "Equipped",
                        "Type",
                        "Float",
                        "Serial",
                    })
                    v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
                    v4.EVENT_END_TIMES = {
                        ["MEDAL.TV"] = os.time({
                            year = 2026,
                            month = 3,
                            day = 1,
                            hour = 0,
                            min = 0,
                            sec = 0,
                        }),
                    }

                    function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171
                        -- upvalues: u244 (val), getActiveGamemode (val)
                        if typeof(a1) == "string" and u244[a1] then
                            return u244[a1]
                        end
                        return (getActiveGamemode(game.PlaceId))
                    end

                    v5 = {
                        VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil,
                    }
                    v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
                    v5.JOB_ID = if not v6 then game.JobId else "Studio"
                    v5.GAMEMODE = getActiveGamemode(game.PlaceId)
                    v5.UNIVERSE_ID = game.GameId
                    v5.PLACE_ID = game.PlaceId
                    v4.SESSION_DATA = v5
                    v4.VIP_MENU_PANEL_WHITELIST = {
                        363101315,
                        3659308968,
                        1243042178,
                        107643044,
                        9236102964,
                        38260227,
                        40222641,
                        3436218611,
                    }
                    v4.AIM_ASSIST_CONFIGS = {
                        PLAYER = {
                            TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
                            Friction = {
                                Enabled = true,
                                BubbleRadius = 2.4,
                                MinSensitivity = 0.5,
                                MaxSensitivity = 1,
                            },
                            Magnetism = {
                                Enabled = true,
                                MaxAngleHorizontal = 0.20943951023931956,
                                MaxAngleVertical = 0.10471975511965978,
                                PullStrength = 0.11344640137963143,
                                StopThreshold = 0.008726646259971648,
                                MaxDistance = 125,
                            },
                            VerticalMagnetism = {
                                Enabled = true,
                                MaxAngleHorizontal = 0.20943951023931956,
                                MaxAngleVertical = 0.10471975511965978,
                                PullStrength = 0.11344640137963143,
                                StopThreshold = 0.008726646259971648,
                                MaxDistance = 125,
                            },
                            RecoilAssist = {
                                Enabled = true,
                                ReductionAmount = 0.5,
                                HorizontalReductionAmount = 0.85,
                                RequiresTarget = false,
                            },
                        },
                    }
                    v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
                        Notifications = 15,
                        FavoriteGame = 15,
                        InviteFriend = 15,
                        JoinGroup = 15,
                        LikeGame = 15,
                    })
                    v4.ACTIVE_PLACE_ENVIRONMENT = v2
                    v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
                    v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
                    v4.GAMEMODE_PLACE_IDS = {
                        Trading = 101836176558619,
                        Deathmatch = u209.Deathmatch,
                        Casual = u209.Defusal,
                        Competitive = u213,
                        Tutorial = u209.Tutorial,
                    }
                    v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
                    v4.ACTIVE_DEVICE_PLATFORM = v1
                    v4.IS_DEVICE_SERVER = v1 ~= nil
                    v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
                    return freeze_2(v4)
                end
            end
            v3 = nil
        else
            v3 = "Mobile"
        end
        v2 = if v3 ~= nil then "Prod" else if game.GameId ~= 7633926880 then "Dev" else "Prod"
    end
else
    v2 = "Dev"
end
u209 = getActiveGamemodeSubplaceIds(v2, v1)
Defusal = u209.Defusal
UnrankedComp = u209.UnrankedComp
if UnrankedComp == Defusal then
    u213 = 0
else
    u213 = UnrankedComp
    if not u213 then
        u213 = 0
    end
end

function getActiveGamemode(a1) -- Line: 127 -- upvalues: u209 (val), u213 (val), u16 (val), u19 (val)
    if a1 == 101836176558619 then
        return "trading"
    end
    if a1 == u209.Deathmatch then
        return "deathmatch"
    end
    if a1 == u209.Defusal then
        return "casual"
    end
    if u213 ~= 0 and a1 == u213 then
        return "competitive"
    end
    if u209.Tutorial ~= 0 and a1 == u209.Tutorial then
        return "tutorial"
    end
    local v1 = {u16, u19}
    local v2 = nil
    local v3 = nil
    local v4 = a1
    for i, j in v1, v2, v3 do
        if v4 == j.Deathmatch then
            return "deathmatch"
        end
        if v4 == j.Defusal then
            return "casual"
        end
        if j.UnrankedComp ~= j.Defusal and v4 == j.UnrankedComp then
            return "competitive"
        end
        if j.Tutorial ~= 0 and v4 == j.Tutorial then
            return "tutorial"
        end
    end
    return "casual"
end

u244 = table.freeze({Competitive = "competitive", Deathmatch = "deathmatch", Casual = "casual"})
freeze_2 = table.freeze
v4 = {
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
}
v4.ITEM_CATEGORIES = table.freeze({"All", "Pistol", "SMG", "Rifle", "Heavy", "Equipment", "Miscellaneous"})
v4.MARKETPLACE_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Type", "Float"})
v4.INVENTORY_SORTING_OPTIONS = table.freeze({"Quality", "RAP", "Newest", "Alphabetical", "Collection", "Equipped", "Type", "Float", "Serial"})
v4.ACTIVE_EVENTS = {["MEDAL.TV"] = false}
v4.EVENT_END_TIMES = {
    ["MEDAL.TV"] = os.time({
        year = 2026,
        month = 3,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0,
    }),
}

function v4.GetGamemodeFromServerGamemode(a1) -- Line: 171 -- upvalues: u244 (val), getActiveGamemode (val)
    if typeof(a1) == "string" and u244[a1] then
        return u244[a1]
    end
    return (getActiveGamemode(game.PlaceId))
end

v5 = {VIP_SERVER_OWNER = PrivateServerOwnerId > 0 and PrivateServerOwnerId or nil}
v5.PRIVATE_SERVER_ID = if not v6 then game.PrivateServerId else "Studio"
v5.JOB_ID = if not v6 then game.JobId else "Studio"
v5.GAMEMODE = getActiveGamemode(game.PlaceId)
v5.UNIVERSE_ID = game.GameId
v5.PLACE_ID = game.PlaceId
v4.SESSION_DATA = v5
v4.VIP_MENU_PANEL_WHITELIST = {363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641, 3436218611}
v4.AIM_ASSIST_CONFIGS = {
    PLAYER = {
        TargetSelection = {Enabled = true, MaxDistance = 125, MaxAngle = 0.5235987755982988},
        Friction = {Enabled = true, BubbleRadius = 2.4, MinSensitivity = 0.5, MaxSensitivity = 1},
        Magnetism = {
            Enabled = true,
            MaxAngleHorizontal = 0.20943951023931956,
            MaxAngleVertical = 0.10471975511965978,
            PullStrength = 0.11344640137963143,
            StopThreshold = 0.008726646259971648,
            MaxDistance = 125,
        },
        VerticalMagnetism = {
            Enabled = true,
            MaxAngleHorizontal = 0.20943951023931956,
            MaxAngleVertical = 0.10471975511965978,
            PullStrength = 0.11344640137963143,
            StopThreshold = 0.008726646259971648,
            MaxDistance = 125,
        },
        RecoilAssist = {
            Enabled = true,
            ReductionAmount = 0.5,
            HorizontalReductionAmount = 0.85,
            RequiresTarget = false,
        },
    },
}
v4.PROMOTIONAL_REWARD_CREDITS = table.freeze({
    Notifications = 15,
    FavoriteGame = 15,
    InviteFriend = 15,
    JoinGroup = 15,
    LikeGame = 15,
})
v4.ACTIVE_PLACE_ENVIRONMENT = v2
v4.GAMEMODE_SUBPLACE_IDS = {Prod = u19, Dev = u16}
v4.ACTIVE_GAMEMODE_SUBPLACE_IDS = u209
v4.GAMEMODE_PLACE_IDS = {
    Trading = 101836176558619,
    Deathmatch = u209.Deathmatch,
    Casual = u209.Defusal,
    Competitive = u213,
    Tutorial = u209.Tutorial,
}
v4.DEVICE_GAMEMODE_SUBPLACE_IDS = u28
v4.ACTIVE_DEVICE_PLATFORM = v1
v4.IS_DEVICE_SERVER = v1 ~= nil
v4.GetDeviceServerPlaceId = getDeviceServerPlaceId
return freeze_2(v4)