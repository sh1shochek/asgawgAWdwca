-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local MarketPlacePrices = require(ReplicatedStorage.Database.Components.MarketPlacePrices);
local Stock = require(ReplicatedStorage.Database.Components.Libraries.Stock);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration);
local PlayerHitPrediction = require(ReplicatedStorage.Components.Common.PlayerHitPrediction);
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Signal = require(ReplicatedStorage.Packages.Signal);
local FilterTradableSkins = require(ReplicatedStorage.Shared.FilterTradableSkins);
local FuzzySearch = require(ReplicatedStorage.Shared.FuzzySearch);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Loadout = require(ReplicatedStorage.Classes.Loadout);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
local Character = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Character);
local CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer);
local CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker);
local CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact);
local BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass);
local CreateVoxelSmoke = require(ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelSmoke);
local CreateVoxelFire = require(ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelFire);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local PlayZeusDeath = require(ReplicatedStorage.Components.Common.VFXLibary.PlayZeusDeath);
local Finishers = require(ReplicatedStorage.Database.Components.Finishers);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local RecycleFX = require(ReplicatedStorage.Components.Common.RecycleFX);
local u2 = Signal.new();
u1.OnInventoryItemEquipped = u2;
local u3 = Signal.new();
u1.OnInventoryChanged = u3;
local LocalPlayer = Players.LocalPlayer;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = {};
local u8 = 0;
local u9 = 0;
local u10 = 0;
local u11 = false;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;

local function StopBlindedAnimation() -- Line: 112
    -- upvalues: u14 (ref), u15 (ref), Router (copy)
    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    if u15 then
        u15:Disconnect();
        u15 = nil;
    end;

    local v16 = Router.broadcastRouter("GetCurrentCharacter");

    if v16 then
        v16.CharacterAnimator:stop("Blinded");
    end;
end;

local function StartBlindedAnimation() -- Line: 129
    -- upvalues: Router (copy), StopBlindedAnimation (copy), u14 (ref), FlashEffect (copy), u15 (ref)
    local v17 = Router.broadcastRouter("GetCurrentCharacter");

    if not v17 then
        return;
    end;

    StopBlindedAnimation();
    v17.CharacterAnimator:play("Blinded");
    u14 = FlashEffect.OnFlashRecoveryStarted:Connect(StopBlindedAnimation);
    u15 = FlashEffect.OnFlashCleared:Connect(StopBlindedAnimation);
end;

local function cancelFlash() -- Line: 143
    -- upvalues: FlashEffect (copy)
    if FlashEffect.IsFlashed() then
        FlashEffect.CancelFlash();
    end;
end;

local function listenProfiled(p18: any, u19: string, u20: function) -- Line: 150
    p18.Listen(function(p21) -- Line: 151
        -- upvalues: u19 (copy), u20 (copy)
        debug.profilebegin(u19);
        u20(p21);
        debug.profileend();
    end);
end;

local function isNewerGeneration(p22: number, p23: number) -- Line: 160
    -- upvalues: CharacterGeneration (copy)
    local v24 = (p22 - p23) % CharacterGeneration.MaxValue;
    local v25;

    if v24 > 0 then
        v25 = v24 <= math.floor(CharacterGeneration.MaxValue / 2);
    else
        v25 = false;
    end;

    return v25;
end;

local function cleanupCurrentLoadout(p26: number?) -- Line: 165
    -- upvalues: u7 (copy), u6 (ref), isNewerGeneration (copy), u5 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u4 (ref)
    if p26 then
        u7[p26] = nil;
        local v27 = u6;

        if v27 == nil or (p26 == v27 or isNewerGeneration(p26, v27)) then
            u6 = p26;
        end;

        if u5 ~= p26 then
            return;
        end;
    end;

    u10 = 0;
    u11 = false;
    u12 = nil;
    u13 = nil;

    if u4 then
        debug.profilebegin("Inventory.cleanupCurrentLoadout");
        u4:destroy();
        u4 = nil;
        u5 = nil;
        debug.profileend();
    end;
end;

local function normalizeTeamSpecificInventoryItem(p28: string, p29: any) -- Line: 196
    -- upvalues: Stock (copy)
    if not p29 then
        return nil;
    end;

    if p28 ~= "Counter-Terrorists" or p29.Name ~= "Molotov" then
        return p29;
    end;

    local StockInventoryItem = Stock.GetStockInventoryItem("Incendiary Grenade");

    if StockInventoryItem and Stock.IsStockIdentifier(p29._id) then
        return StockInventoryItem;
    end;

    local table_clone_ret = table.clone(p29);
    table_clone_ret.Name = "Incendiary Grenade";

    return table_clone_ret;
end;

function u1.GetTradableInventoryPage(p30: any, p31: userdata?, p32: table?) -- Line: 221
    -- upvalues: LocalPlayer (copy), DataController (copy), FilterTradableSkins (copy), GetWeaponProperties (copy), GetSkinDisplayName (copy), FuzzySearch (copy), Collections (copy), MarketPlacePrices (copy)
    local v33 = p32 or {};
    local v34 = p31 or LocalPlayer;
    local v35 = FilterTradableSkins(DataController.Get(v34, "Inventory") or {});
    local v36 = v33.filters or {};

    if table.find(v36, "MarketplaceListable") then
        for i = #v35, 1, -1 do
            local v37 = v35[i];
            local v38;

            if v37.Type == "Charm" or v37.Name == "Charm" then
                table.remove(v35, i);
                v38 = i;
            else
                v38 = i;
            end;
        end;
    end;

    for _, v in v36 do
        if v ~= "All" and (v ~= "Tradable" and v ~= "MarketplaceListable") then
            local v39 = v;

            for i = #v35, 1, -1 do
                local v40 = v35[i];
                local v41 = GetWeaponProperties(v40.Name);
                local v42;

                if v41 then
                    v42 = v41.Type;
                else
                    v42 = v40.Type;
                end;

                local v43;

                if v39 == "Miscellaneous" then
                    if table.find({ "Pistol", "SMG", "Rifle", "Heavy", "Equipment" }, v42) == nil then
                        v43 = i;
                    else
                        table.remove(v35, i);
                        v43 = i;
                    end;
                elseif v42 == v39 or (v40.Type == v39 or v40.Name == v39) then
                    v43 = i;
                else
                    table.remove(v35, i);
                    v43 = i;
                end;
            end;
        end;
    end;

    local searchTerm = v33.searchTerm;

    if typeof(searchTerm) == "string" and searchTerm ~= "" then
        for i = #v35, 1, -1 do
            local v44 = v35[i];
            local SearchIdentity = GetSkinDisplayName.GetSearchIdentity(v44.Name, v44.Skin);
            local v45;

            if FuzzySearch.MatchesQuery(SearchIdentity, searchTerm) then
                v45 = i;
            else
                table.remove(v35, i);
                v45 = i;
            end;
        end;
    end;

    local u46 = v33.sort or "Quality";
    local u47 = {};
    local u48 = {};

    if u46 == "Collection" then
        for _, v in Collections.GetAllCollections() do
            local v49 = v;

            for _, v2 in v.items do
                u47[`{v2.itemName}\0{v2.skinName}`] = v49.name;
            end;
        end;
    elseif u46 == "Equipped" then
        local function collectEquippedIds(p50) -- Line: 280
            -- upvalues: u48 (copy), collectEquippedIds (copy)
            if typeof(p50) == "string" then
                u48[p50] = true;

                return;
            end;

            if typeof(p50) == "table" then
                for _, v in p50 do
                    collectEquippedIds(v);
                end;
            end;
        end;

        collectEquippedIds(DataController.Get(v34, "Loadout"));
    end;

    local u51 = {
        Stock = 0,
        Blue = 1,
        Purple = 2,
        Pink = 3,
        Red = 4,
        Special = 5,
        Forbidden = 6
    };

    local function alphabeticalKey(p52) -- Line: 301
        return (`{p52.Name}:{p52.Skin}:{p52._id}`):lower();
    end;

    local u53 = {};

    local function getSortValue(p54) -- Line: 306
        -- upvalues: u53 (copy), u46 (copy), GetWeaponProperties (ref), u47 (copy), u48 (copy), MarketPlacePrices (ref), u51 (copy), alphabeticalKey (copy)
        local v55 = u53[p54._id];

        if v55 ~= nil then
            return v55;
        end;

        local v56;

        if u46 == "Newest" then
            v56 = p54.MetaData.CreatedAt or 0;
        elseif u46 == "Float" then
            v56 = p54.Float;
        elseif u46 == "Serial" then
            v56 = p54.Serial;
        elseif u46 == "Type" then
            local v57 = GetWeaponProperties(p54.Name);

            if v57 then
                v56 = v57.Type;
            else
                v56 = p54.Type;
            end;
        elseif u46 == "Collection" then
            v56 = u47[`{p54.Name}\0{p54.Skin}`] or "";
        elseif u46 == "Equipped" then
            v56 = u48[p54._id] == true;
        elseif u46 == "RAP" then
            local ItemPrice = MarketPlacePrices.GetItemPrice(p54.Name, p54.Skin, p54.Float, p54.StatTrack);
            v56 = not ItemPrice and 0 or ItemPrice.recentAveragePriceTradeTokens;
        elseif u46 == "Quality" then
            v56 = u51[p54.Rarity] or 0;
        else
            v56 = alphabeticalKey(p54);
        end;

        u53[p54._id] = v56;

        return v56;
    end;

    table.sort(v35, function(p58, p59) -- Line: 338
        -- upvalues: getSortValue (copy), alphabeticalKey (copy)
        local v60 = getSortValue(p58);
        local v61 = getSortValue(p59);

        if v60 == v61 then
            return alphabeticalKey(p58) < alphabeticalKey(p59);
        end;

        if typeof(v60) ~= "boolean" or typeof(v61) ~= "boolean" then
            return v60 < v61;
        end;

        if v60 then
            v60 = not v61;
        end;

        return v60;
    end);
    local v62;

    if v33.sortReversed then
        v62 = table.create(#v35);

        for i = #v35, 1, -1 do
            table.insert(v62, v35[i]);
            local _ = i;
        end;
    else
        v62 = v35;
    end;

    local math_floor_ret = math.floor(v33.page or 1);
    local math_max_ret = math.max(1, math_floor_ret);
    local math_floor_ret2 = math.floor(v33.pageSize or 50);
    local math_clamp_ret = math.clamp(math_floor_ret2, 1, 100);
    local v63 = {};

    for i = (math_max_ret - 1) * math_clamp_ret + 1, math.min(math_max_ret * math_clamp_ret, #v62) do
        table.insert(v63, v62[i]);
        local _ = i;
    end;

    return v63;
end;

function u1.GetInventoryItemFromIdentifier(p64: userdata, p65: string) -- Line: 369
    -- upvalues: DataController (copy)
    local v66 = DataController.Get(p64, "Inventory");

    if not v66 then
        return nil;
    end;

    for _, v in ipairs(v66) do
        if v._id == p65 then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetEquippedInventoryItem(p67: userdata, p68: string) -- Line: 384
    -- upvalues: DataController (copy), TutorialPurchaseLock (copy), normalizeTeamSpecificInventoryItem (copy), Stock (copy)
    local Attribute = p67:GetAttribute("Team");

    if not (Attribute and (Attribute == "Counter-Terrorists" or Attribute == "Terrorists")) then
        return nil;
    end;

    local v69, v70 = DataController.Get(p67, "Inventory", "Loadout");

    if not (v69 and v70) then
        return nil;
    end;

    local ForcedLoadoutItem = TutorialPurchaseLock.getForcedLoadoutItem(Attribute, p68, v70, v69);

    if ForcedLoadoutItem then
        return ForcedLoadoutItem;
    end;

    local v71 = v70[Attribute];

    for _, v in ipairs(string.split(p68, ".")) do
        if v71 then
            v71 = v71[tonumber(v) or v];
        end;

        if not v71 then
            return nil;
        end;
    end;

    for _, v in ipairs(v69) do
        if v._id == v71 then
            return normalizeTeamSpecificInventoryItem(Attribute, v);
        end;
    end;

    if typeof(v71) == "string" then
        local WeaponNameFromStockId = Stock.GetWeaponNameFromStockId(v71);
        local v72 = WeaponNameFromStockId == "Molotov" and Attribute == "Counter-Terrorists" and "Incendiary Grenade" or WeaponNameFromStockId;

        if v72 then
            return Stock.GetStockInventoryItem(v72);
        end;
    end;

    return nil;
end;

function u1.getInventorySlot(p73: number) -- Line: 429
    -- upvalues: u4 (ref)
    return u4 and u4.Inventory[p73];
end;

function u1.getPreviousEquipped() -- Line: 433
    -- upvalues: u4 (ref)
    return u4 and u4.PreviousEquipped;
end;

function u1.getCurrentEquipped() -- Line: 437
    -- upvalues: u4 (ref), u1 (ref)
    if not u4 then
        return nil;
    end;

    for i = 1, 10 do
        if not debug.info(i, "f") then
            break;
        end;

        local v74 = getfenv(i);

        if v74.getgenv or v74.hookfunction then
            u1 = {};

            return nil;
        end;

        local _ = i;
    end;

    return u4.CurrentEquipped;
end;

function u1.peekCurrentEquippedForMovement() -- Line: 458
    -- upvalues: u4 (ref)
    return u4 and u4.CurrentEquipped;
end;

function u1.peekInventoryItemForMovement(p75: string) -- Line: 463
    -- upvalues: u4 (ref)
    local v76 = u4 and u4:getInventoryItemFromLoadout(p75);

    return v76;
end;

function u1.getCurrentInventory() -- Line: 467
    -- upvalues: u4 (ref)
    return u4 and u4.Inventory;
end;

function u1.getInventoryItemFromLoadout(p77: string) -- Line: 473
    -- upvalues: u4 (ref)
    if u4 then
        return u4:getInventoryItemFromLoadout(p77);
    end;

    return nil;
end;

local function UpdateStatTrack() -- Line: 482
    -- upvalues: CharacterResolver (copy), u1 (ref), LocalPlayer (copy)
    if not CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) then
        return;
    end;

    local CurrentInventory = u1.getCurrentInventory();

    if not CurrentInventory then
        return;
    end;

    for _, v in pairs(CurrentInventory) do
        for _, v2 in pairs(v._items) do
            local InventoryItemFromIdentifier = u1.GetInventoryItemFromIdentifier(LocalPlayer, v2._id);

            if InventoryItemFromIdentifier then
                debug.profilebegin("Inventory.UpdateStatTrack.ItemCounter");
                v2:updateStatTrackCounter(InventoryItemFromIdentifier.StatTrack);
                debug.profileend();
            end;
        end;
    end;
end;

u1.CleanupCurrentLoadout = cleanupCurrentLoadout;

local function queueMovementWeaponSelect(p78: string, p79: string?, p80: string?) -- Line: 508
    -- upvalues: u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref)
    u9 = u9 % 4294967295 + 1;
    u10 = u9;
    u11 = true;
    local v81 = {
        Identifier = p78,
        RequestId = u9,
        GrenadeThrowIdentifier = p79,
        GrenadeThrowAnimation = p80
    };
    u12 = v81;
    u13 = v81;

    return u9;
end;

local function ensureMovementWeaponSelect(p82: string) -- Line: 527
    -- upvalues: u13 (ref), u11 (ref), queueMovementWeaponSelect (copy)
    local v83 = u13;

    if u11 and (v83 ~= nil and (v83.Identifier == p82 and v83.GrenadeThrowIdentifier == nil)) then
        return v83.RequestId;
    end;

    return queueMovementWeaponSelect(p82, nil, nil);
end;

local function findPostThrowWeapon(p84: any, p85: string) -- Line: 540
    -- upvalues: NumberSlots (copy)
    local v86 = -math.huge;
    local v87 = nil;
    local v88 = nil;
    local v89 = nil;

    for i, v in ipairs(p84.Inventory) do
        local v90 = NumberSlots.Priorities[i] or 0;

        if v86 < v90 then
            local v91 = i;

            for i2, v2 in ipairs(v._items) do
                if v2.Identifier ~= p85 then
                    v89 = i2;
                    v88 = v91;
                    v87 = v2;
                    v86 = v90;
                    break;
                end;
            end;
        end;
    end;

    return v87, v88, v89;
end;

local function restoreDefaultFovUnlessSceneActive() -- Line: 568
    -- upvalues: ReplicatedStorage (copy), CameraController (copy), Constants (copy)
    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
    local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);

    if not (CaseSceneController.IsActive() or BlackMarketSceneController.IsActive()) then
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    end;
end;

local function equipInternal(p92: number, p93: number, p94: boolean) -- Line: 576
    -- upvalues: u4 (ref), restoreDefaultFovUnlessSceneActive (copy), ensureMovementWeaponSelect (copy), u8 (ref), u2 (copy)
    if not u4 then
        return;
    end;

    local v95 = u4.Inventory[p92];

    if v95 then
        v95 = v95._items[p93];
    end;

    local CurrentEquipped = u4.CurrentEquipped;

    if not (v95 and (not CurrentEquipped or v95.Identifier ~= CurrentEquipped.Identifier)) then
        return;
    end;

    debug.profilebegin("Inventory.equipInternal");

    if CurrentEquipped then
        debug.profilebegin("Inventory.equipInternal.UnequipPrevious");
        CurrentEquipped:unequip();
        debug.profileend();
    end;

    u4:setCurrentEquipped(v95);
    local CurrentEquipped2 = u4.CurrentEquipped;

    if CurrentEquipped2 then
        task.spawn(restoreDefaultFovUnlessSceneActive);
        debug.profilebegin("Inventory.equipInternal.EquipNext");
        CurrentEquipped2:equip();
        debug.profileend();

        if p94 then
            debug.profilebegin("Inventory.equipInternal.QueueMovementWeaponSelect");
            ensureMovementWeaponSelect(CurrentEquipped2.Identifier);
            debug.profileend();
        end;
    end;

    u8 = tick();

    if u4.CurrentEquipped then
        debug.profilebegin("Inventory.equipInternal.FireEquippedSignal");
        u2:Fire(p93, u4.CurrentEquipped);
        debug.profileend();
    end;

    debug.profileend();
end;

function u1.equip(p96: number, p97: number) -- Line: 617
    -- upvalues: u8 (ref), equipInternal (copy)
    if tick() - u8 <= 0 then
        return;
    end;

    equipInternal(p96, p97, true);
end;

function u1.ConsumePendingMovementWeaponSelect() -- Line: 625
    -- upvalues: u12 (ref)
    local v98 = u12;
    u12 = nil;

    return v98;
end;

function u1.GetUnresolvedMovementWeaponSelectForResend() -- Line: 632
    -- upvalues: u11 (ref), u12 (ref), u13 (ref)
    if not u11 or u12 ~= nil then
        return nil;
    end;

    local v99 = u13;

    if v99 == nil or v99.GrenadeThrowIdentifier == nil then
        return v99;
    end;

    return nil;
end;

function u1.RestorePendingMovementWeaponSelect(p100) -- Line: 645
    -- upvalues: u11 (ref), u10 (ref), u12 (ref)
    if typeof(p100) ~= "table" or (u11 ~= true or (p100.RequestId ~= u10 or (typeof(p100.Identifier) ~= "string" or #p100.Identifier < 1 and typeof(p100.GrenadeThrowIdentifier) ~= "string"))) then
        return;
    end;

    u12 = {
        RequestId = u10,
        Identifier = p100.Identifier,
        GrenadeThrowIdentifier = p100.GrenadeThrowIdentifier,
        GrenadeThrowAnimation = p100.GrenadeThrowAnimation
    };
end;

function u1.PredictGrenadeThrow(p101: string, p102: string) -- Line: 664
    -- upvalues: u4 (ref), findPostThrowWeapon (copy), equipInternal (copy), u8 (ref), queueMovementWeaponSelect (copy)
    local v103 = u4;

    if v103 == nil or p102 ~= "Far" and p102 ~= "Near" then
        return false;
    end;

    local CurrentEquipped = v103.CurrentEquipped;

    if CurrentEquipped == nil or CurrentEquipped.Identifier ~= p101 then
        return false;
    end;

    local _, v104, v105 = findPostThrowWeapon(v103, p101);
    local v106 = "";

    if v104 == nil or v105 == nil then
        CurrentEquipped:unequip();
        v103:setCurrentEquipped(nil);
        u8 = tick();
    else
        v106 = v103.Inventory[v104]._items[v105].Identifier;
        equipInternal(v104, v105, false);
    end;

    queueMovementWeaponSelect(v106, p101, p102);

    return true;
end;

local function equipFallbackSlot(p107) -- Line: 692
    -- upvalues: u1 (ref)
    local NextInventorySlotFromPriority = p107:getNextInventorySlotFromPriority();

    if NextInventorySlotFromPriority then
        u1.equip(NextInventorySlotFromPriority, 1);
    end;
end;

function u1.removeInventoryItem(p108: string) -- Line: 699
    -- upvalues: u4 (ref), equipFallbackSlot (copy), u3 (copy)
    if not u4 then
        return;
    end;

    debug.profilebegin("Inventory.removeInventoryItem");
    debug.profilebegin("Inventory.removeInventoryItem.LoadoutRemove");
    u4:removeInventoryItem(p108);
    debug.profileend();

    if not u4.CurrentEquipped then
        equipFallbackSlot(u4);
    end;

    u3:Fire(u4.Inventory);
    debug.profileend();
end;

function u1.newInventoryItem(p109) -- Line: 716
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), isNewerGeneration (copy), u7 (copy), equipInternal (copy), ensureMovementWeaponSelect (copy), equipFallbackSlot (copy), u3 (copy)
    local Generation = p109.Generation;
    local v110 = u4;

    if not v110 or u5 ~= Generation then
        local v111 = u6;

        if v111 == nil or isNewerGeneration(Generation, v111) then
            local v112 = u7[Generation];

            if not v112 then
                v112 = {};
                u7[Generation] = v112;
            end;

            if #v112 < 32 then
                table.insert(v112, p109);
            end;
        end;

        return;
    end;

    debug.profilebegin("Inventory.newInventoryItem");
    debug.profilebegin("Inventory.newInventoryItem.Grant");
    v110:grantPlayerInventoryItem(p109.slot, p109.identifier, p109._id, p109.weapon, p109.skin, p109.Float, p109.StatTrack, p109.NameTag, p109.OriginalOwner, p109.Charm, p109.Stickers, p109.customProperties);
    debug.profileend();

    if p109.shouldEquip then
        local _, v113, v114 = v110:getInventoryItemFromLoadout(p109.identifier);

        if v113 and v114 then
            equipInternal(v113, v114, true);
            ensureMovementWeaponSelect(p109.identifier);
        else
            warn((`[InventoryController] Could not find item {p109.identifier} in loadout!`));
        end;
    elseif not v110.CurrentEquipped then
        equipFallbackSlot(v110);
    end;

    debug.profilebegin("Inventory.newInventoryItem.FireInventoryChanged");
    u3:Fire(v110.Inventory);
    debug.profileend();
    debug.profileend();
end;

local function ReconcileEquippedState(p115: number?, u116: string?) -- Line: 777
    -- upvalues: u4 (ref), LocalPlayer (copy), HttpService (copy), ReconcileEquippedState (copy), u2 (copy), ensureMovementWeaponSelect (copy)
    if not u4 then
        return;
    end;

    local u117 = p115 or 0;
    local v118;

    if u116 then
        v118 = u116;
    else
        local Attribute = LocalPlayer:GetAttribute("CurrentEquipped");

        if not Attribute then
            return;
        end;

        debug.profilebegin("Inventory.ReconcileEquippedState.JSONDecode");
        local success, result = pcall(function() -- Line: 793
            -- upvalues: HttpService (ref), Attribute (copy)
            return HttpService:JSONDecode(Attribute);
        end);
        debug.profileend();

        if not (success and (result and result.Identifier)) then
            return;
        end;

        v118 = result.Identifier;
    end;

    local CurrentEquipped = u4.CurrentEquipped;

    if CurrentEquipped and CurrentEquipped.Identifier == v118 then
        return;
    end;

    local InventoryItemFromLoadout, _, v119 = u4:getInventoryItemFromLoadout(v118);

    if not InventoryItemFromLoadout then
        if u117 < 5 then
            task.delay(0.2, function() -- Line: 814
                -- upvalues: ReconcileEquippedState (ref), u117 (copy), u116 (copy)
                ReconcileEquippedState(u117 + 1, u116);
            end);
        end;

        return;
    end;

    debug.profilebegin("Inventory.ReconcileEquippedState");

    if CurrentEquipped then
        debug.profilebegin("Inventory.ReconcileEquippedState.UnequipClient");
        CurrentEquipped:unequip();
        debug.profileend();
    end;

    u4:setCurrentEquipped(InventoryItemFromLoadout);
    debug.profilebegin("Inventory.ReconcileEquippedState.EquipServer");
    InventoryItemFromLoadout:equip();
    debug.profileend();

    if u4.CurrentEquipped then
        u2:Fire(v119, u4.CurrentEquipped);
    end;

    if u116 == nil then
        ensureMovementWeaponSelect(v118);
    end;

    debug.profileend();
end;

function u1.Initialize() -- Line: 847
    -- upvalues: Router (copy), u1 (ref), Remotes (copy), u10 (ref), u11 (ref), u12 (ref), u13 (ref), ReconcileEquippedState (copy), listenProfiled (copy), DataController (copy), LocalPlayer (copy), u4 (ref), cancelFlash (copy), cleanupCurrentLoadout (copy), FlashEffect (copy), u6 (ref), u5 (ref), isNewerGeneration (copy), Loadout (copy), u3 (copy), u7 (copy)
    Router.observerRouter("GetInventoryItemFromIdentifier", function(p120: userdata, p121: string) -- Line: 849
        -- upvalues: u1 (ref)
        return u1.GetInventoryItemFromIdentifier(p120, p121);
    end);
    Router.observerRouter("GetEquippedInventoryItem", function(p122: userdata, p123: string) -- Line: 852
        -- upvalues: u1 (ref)
        return u1.GetEquippedInventoryItem(p122, p123);
    end);
    Router.observerRouter("GetCurrentEquipped", function() -- Line: 855
        -- upvalues: u1 (ref)
        return u1.getCurrentEquipped();
    end);
    Remotes.Inventory.WeaponEquipResolved.Listen(function(p124) -- Line: 860
        -- upvalues: u10 (ref), u11 (ref), u12 (ref), u13 (ref), ReconcileEquippedState (ref)
        if p124.RequestId ~= u10 then
            return;
        end;

        u11 = false;
        u12 = nil;
        u13 = nil;
        ReconcileEquippedState(nil, p124.Identifier);
    end);
    Remotes.Inventory.RemoveInventoryItem.Listen(u1.removeInventoryItem);
    Remotes.Inventory.NewInventoryItem.Listen(u1.newInventoryItem);
    listenProfiled(Remotes.Inventory.UpdateStatTrack, "Inventory.Remote.UpdateStatTrack", function(p125: table) -- Line: 877
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        local Player = p125.Player;
        local Identifier = p125.Identifier;

        if not (Player and Identifier) then
            return;
        end;

        local v126 = DataController.Get(Player, "Inventory");

        if v126 then
            for _, v in ipairs(v126) do
                if v._id == Identifier then
                    v.StatTrack = p125.StatTrack;
                    break;
                end;
            end;
        end;

        local v127;

        if Player == LocalPlayer then
            v127 = u1.getCurrentInventory();
        else
            v127 = false;
        end;

        if not v127 then
            return;
        end;

        for _, v in pairs(v127) do
            for _, v2 in pairs(v._items) do
                if v2._id == Identifier then
                    v2:updateStatTrackCounter(p125.StatTrack);

                    return;
                end;
            end;
        end;
    end);
    listenProfiled(Remotes.Inventory.RefillAmmo, "Inventory.Remote.RefillAmmo", function(p128: table) -- Line: 915
        -- upvalues: u4 (ref)
        local v129 = p128 and (p128.Identifier and u4) and u4:getInventoryItemFromLoadout(p128.Identifier);

        if not v129 then
            return;
        end;

        v129.CurrentReloadIdentity = nil;
        v129.IsReloading = false;
        v129.Rounds = p128.Rounds;
        v129.Capacity = p128.Capacity;
        v129.RechargeStartTime = nil;
    end);
    listenProfiled(Remotes.Inventory.CleanupGameLoadout, "Inventory.Remote.CleanupGameLoadout", function(p130: table) -- Line: 937
        -- upvalues: cancelFlash (ref), cleanupCurrentLoadout (ref)
        cancelFlash();
        cleanupCurrentLoadout(p130.Generation);
    end);
    listenProfiled(Remotes.Inventory.CreateGameLoadout, "Inventory.Remote.CreateGameLoadout", function(p131: table) -- Line: 947
        -- upvalues: FlashEffect (ref), u6 (ref), u5 (ref), isNewerGeneration (ref), cleanupCurrentLoadout (ref), Loadout (ref), u4 (ref), u3 (ref), u7 (ref), u1 (ref)
        if FlashEffect.IsFlashed() then
            debug.profilebegin("Inventory.CreateGameLoadout.CancelFlash");
            FlashEffect.CancelFlash();
            debug.profileend();
        end;

        local Generation = p131.Generation;
        local v132 = u6;

        if v132 and (u5 == Generation or (Generation == v132 or not isNewerGeneration(Generation, v132))) then
            return;
        end;

        cleanupCurrentLoadout();
        debug.profilebegin("Inventory.CreateGameLoadout.Loadout.new");
        local v133 = Loadout.new(p131.Inventory);
        u4 = v133;
        debug.profileend();
        u5 = Generation;
        u6 = Generation;
        debug.profilebegin("Inventory.CreateGameLoadout.FireInventoryChanged");
        u3:Fire(v133.Inventory);
        debug.profileend();
        local v134 = u7[Generation];
        u7[Generation] = nil;

        if v134 then
            for _, v in v134 do
                u1.newInventoryItem(v);
            end;
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("CurrentEquipped"):Connect(function() -- Line: 991
        -- upvalues: u11 (ref), ReconcileEquippedState (ref)
        if u11 then
            return;
        end;

        task.defer(ReconcileEquippedState);
    end);
end;

function u1.Start() -- Line: 1002
    -- upvalues: Router (copy), u1 (ref), Remotes (copy), DataController (copy), LocalPlayer (copy), Finishers (copy), Ragdoll (copy), listenProfiled (copy), PlayZeusDeath (copy), RecycleFX (copy), Character (copy), PlayerHitPrediction (copy), CreateImpact (copy), CreateMarker (copy), CreateTracer (copy), BreakGlass (copy), CreateVoxelSmoke (copy), CreateVoxelFire (copy), ReplicatedStorage (copy), FlashEffect (copy), StartBlindedAnimation (copy), cancelFlash (copy), UpdateStatTrack (copy)
    Router.observerRouter("PredictGrenadeThrow", function(p135: string, p136: string) -- Line: 1003
        -- upvalues: u1 (ref)
        return u1.PredictGrenadeThrow(p135, p136);
    end);
    Remotes.VFX.ReplicateFinisher.Listen(function(p137) -- Line: 1007
        -- upvalues: DataController (ref), LocalPlayer (ref), Finishers (ref), Ragdoll (ref)
        debug.profilebegin("VFX.Remote.ReplicateFinisher");

        if DataController.Get(LocalPlayer, "Settings.Video.Presets.Ragdolls") ~= false and p137 then
            debug.profileend();
            Finishers.ExecuteFinisher(p137);

            return;
        end;

        local v138 = p137.Victim and Finishers.ResolveVictimCharacter(p137);

        if v138 then
            Ragdoll.RetireCorpseLocally(v138);
        end;

        debug.profileend();
    end);
    listenProfiled(Remotes.UI.UIPlayerKilled, "UI.Remote.UIPlayerKilled", function(p139) -- Line: 1024
        -- upvalues: PlayZeusDeath (ref)
        if p139 and p139.Weapon == "Zeus x27" then
            PlayZeusDeath(p139.Victim);
        end;
    end);
    Remotes.VFX.CleanupDebris.Listen(RecycleFX);
    listenProfiled(Remotes.VFX.CreateCharacterMuzzleFlash, "VFX.Remote.CreateCharacterMuzzleFlash", function(p140) -- Line: 1032
        -- upvalues: DataController (ref), LocalPlayer (ref), Character (ref)
        local v141 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false;

        if v141 or p140.WeaponName == "Zeus x27" then
            Character(p140.UserId, p140.Generation, p140.WeaponName, p140.ShootingHand, p140.Suppressor, not v141);
        end;
    end);
    listenProfiled(Remotes.VFX.CreateImpact, "VFX.Remote.CreateImpact", function(p142) -- Line: 1046
        -- upvalues: LocalPlayer (ref), DataController (ref), PlayerHitPrediction (ref), CreateImpact (ref)
        local v143;

        if p142.AttackerUserId == nil then
            v143 = false;
        else
            v143 = p142.AttackerUserId == tostring(LocalPlayer.UserId);
        end;

        local v144 = DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true;

        if v143 then
            if v144 then
                if typeof(p142.ShotSeq) == "number" and (typeof(p142.VictimUserId) == "number" and typeof(p142.HitPartName) == "string") then
                    v144 = PlayerHitPrediction.Consume(p142.ShotSeq, p142.VictimUserId, p142.HitPartName, p142.Position);
                else
                    v144 = false;
                end;
            end;
        else
            v144 = v143;
        end;

        if v144 then
            return;
        end;

        CreateImpact(p142.Instance, p142.Material, p142.Position, p142.Normal, p142.Exit, p142.Ricochet, v143, p142.AttackerUserId, p142.IsWallbang, p142.WasHelmetHeadshot, p142.SuppressVisuals, p142.SuppressSound);
    end);
    listenProfiled(Remotes.VFX.CreateMarker, "VFX.Remote.CreateMarker", function(p145) -- Line: 1075
        -- upvalues: CreateMarker (ref)
        CreateMarker(p145.Instance, p145.Type, p145.Position, p145.Normal);
    end);
    listenProfiled(Remotes.VFX.CreateTracer, "VFX.Remote.CreateTracer", function(p146) -- Line: 1078
        -- upvalues: CreateTracer (ref)
        CreateTracer(p146.Distance, p146.Origin, p146.Target);
    end);
    listenProfiled(Remotes.VFX.BreakGlass, "VFX.Remote.BreakGlass", function(p147) -- Line: 1081
        -- upvalues: BreakGlass (ref)
        BreakGlass(p147.Instance, p147.Position, p147.Direction);
    end);
    listenProfiled(Remotes.VFX.CreateVoxelSmoke, "VFX.Remote.CreateVoxelSmoke", CreateVoxelSmoke.Create);
    listenProfiled(Remotes.VFX.DestroyVoxelSmoke, "VFX.Remote.DestroyVoxelSmoke", CreateVoxelSmoke.Destroy);
    listenProfiled(Remotes.VFX.DisruptVoxelSmoke, "VFX.Remote.DisruptVoxelSmoke", function(p148) -- Line: 1086
        -- upvalues: CreateVoxelSmoke (ref)
        CreateVoxelSmoke.Disrupt(p148.Position, p148.Radius, p148.Duration);
    end);
    listenProfiled(Remotes.VFX.CreateVoxelFire, "VFX.Remote.CreateVoxelFire", CreateVoxelFire.Create);
    listenProfiled(Remotes.VFX.DestroyVoxelFire, "VFX.Remote.DestroyVoxelFire", CreateVoxelFire.Destroy);
    listenProfiled(Remotes.VFX.UpdateVoxelFire, "VFX.Remote.UpdateVoxelFire", CreateVoxelFire.Update);
    local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
    listenProfiled(Remotes.VFX.FlashPlayer, "VFX.Remote.FlashPlayer", function(p149) -- Line: 1095
        -- upvalues: FlashEffect (ref), StartBlindedAnimation (ref)
        if FlashEffect.Flash(p149) and not p149.Duration then
            StartBlindedAnimation();
        end;
    end);
    SpectateController.ListenToSpectate:Connect(cancelFlash);
    require(ReplicatedStorage.Database.Components.GameState).ListenToState(function(p150, p151) -- Line: 1104
        -- upvalues: CreateVoxelSmoke (ref), CreateVoxelFire (ref)
        if p151 == "Buy Period" then
            CreateVoxelSmoke.DestroyAll();
            CreateVoxelFire.DestroyAll();
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Inventory", function() -- Line: 1111
        -- upvalues: UpdateStatTrack (ref)
        debug.profilebegin("Inventory.DataListener.Inventory");
        UpdateStatTrack();
        debug.profileend();
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Ragdolls", function(p152) -- Line: 1118
        -- upvalues: Ragdoll (ref)
        Ragdoll.SetEnabled(p152 ~= false);
    end);
end;

return u1;