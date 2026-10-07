-- ReplicatedStorage.Controllers.InventoryController
-- Script path: ReplicatedStorage.Controllers.InventoryController
-- Decompile time: 17.20 ms

local ReconcileEquippedState
local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections)
local MarketPlacePrices = require(ReplicatedStorage.Database.Components.MarketPlacePrices)
local Stock = require(ReplicatedStorage.Database.Components.Libraries.Stock)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration)
local PlayerHitPrediction = require(ReplicatedStorage.Components.Common.PlayerHitPrediction)
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Signal = require(ReplicatedStorage.Packages.Signal)
local FilterTradableSkins = require(ReplicatedStorage.Shared.FilterTradableSkins)
local FuzzySearch = require(ReplicatedStorage.Shared.FuzzySearch)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local Loadout = require(ReplicatedStorage.Classes.Loadout)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots)
local Character = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Character)
local CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer)
local CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker)
local CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact)
local BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass)
local CreateVoxelSmoke = require(ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelSmoke)
local CreateVoxelFire = require(ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelFire)
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local PlayZeusDeath = require(ReplicatedStorage.Components.Common.VFXLibary.PlayZeusDeath)
local Finishers = require(ReplicatedStorage.Database.Components.Finishers)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local RecycleFX = require(ReplicatedStorage.Components.Common.RecycleFX)
local u183 = Signal.new()
u0.OnInventoryItemEquipped = u183
local u185 = Signal.new()
u0.OnInventoryChanged = u185
local LocalPlayer = Players.LocalPlayer
local u187 = nil
local u188 = nil
local u189 = nil
local u190 = {}
local u191 = 0
local u192 = 0
local u193 = 0
local u194 = false
local u195 = nil
local u196 = nil
local u197 = nil
local u198 = nil

local function StopBlindedAnimation() -- Line: 112 -- upvalues: u197 (ref), u198 (ref), Router (val)
    if u197 then
        u197:Disconnect()
        u197 = nil
    end
    if u198 then
        u198:Disconnect()
        u198 = nil
    end
    local GetCurrentCharacter = Router.broadcastRouter("GetCurrentCharacter")
    if GetCurrentCharacter then
        GetCurrentCharacter.CharacterAnimator:stop("Blinded")
    end
end

local function StartBlindedAnimation() -- Line: 129
    -- upvalues: Router (val), StopBlindedAnimation (val), u197 (ref), FlashEffect (val), u198 (ref)
    local GetCurrentCharacter = Router.broadcastRouter("GetCurrentCharacter")
    if not GetCurrentCharacter then
        return
    end
    StopBlindedAnimation()
    GetCurrentCharacter.CharacterAnimator:play("Blinded")
    u197 = FlashEffect.OnFlashRecoveryStarted:Connect(StopBlindedAnimation)
    u198 = FlashEffect.OnFlashCleared:Connect(StopBlindedAnimation)
end

local function cancelFlash() -- Line: 143 -- upvalues: FlashEffect (val)
    if FlashEffect.IsFlashed() then
        FlashEffect.CancelFlash()
    end
end

local function listenProfiled(a1, a2, a3) -- Line: 150 -- types: a2: string, a3: function
    a1.Listen(function(a1) -- Line: 151 -- upvalues: a2 (val), a3 (val)
        debug.profilebegin(a2)
        a3(a1)
        debug.profileend()
    end)
end

local function isNewerGeneration(a1, a2) -- Line: 160
    -- upvalues: CharacterGeneration (val)
    local v1 = (a1 - a2) % CharacterGeneration.MaxValue
    local v2 = false
    if v1 > 0 then
        v2 = v1 <= math.floor(CharacterGeneration.MaxValue / 2)
    end
    return v2
end

local function cleanupCurrentLoadout(a1) -- Line: 165
    -- upvalues: u190 (val), u189 (ref), isNewerGeneration (val), u188 (ref), u193 (ref), u194 (ref), u195 (ref)
    -- upvalues: u196 (ref), u187 (ref)
    if a1 then
        u190[a1] = nil
        local v1 = u189
        if v1 == nil or a1 == v1 or isNewerGeneration(a1, v1) then
            u189 = a1
        end
        if u188 ~= a1 then
            return
        end
    end
    u193 = 0
    u194 = false
    u195 = nil
    u196 = nil
    if u187 then
        debug.profilebegin("Inventory.cleanupCurrentLoadout")
        u187:destroy()
        u187 = nil
        u188 = nil
        debug.profileend()
    end
end

local function normalizeTeamSpecificInventoryItem(a1, a2) -- Line: 196 -- upvalues: Stock (val) -- types: a1: string
    if not a2 then
        return nil
    end
    if a1 == "Counter-Terrorists" and a2.Name == "Molotov" then
        local v1 = Stock.GetStockInventoryItem("Incendiary Grenade")
        if v1 and Stock.IsStockIdentifier(a2._id) then
            return v1
        end
        local v2 = table.clone(a2)
        v2.Name = "Incendiary Grenade"
        return v2
    end
    return a2
end

function u0.GetTradableInventoryPage(a1, a2, a3) -- Line: 221
    -- upvalues: LocalPlayer (val), DataController (val), FilterTradableSkins (val), GetWeaponProperties (val)
    -- upvalues: GetSkinDisplayName (val), FuzzySearch (val), Collections (val), MarketPlacePrices (val)
    local Type, v1, v2
    local v3 = a3 or {}
    local v4 = a2 or LocalPlayer
    local v5 = FilterTradableSkins(DataController.Get(v4, "Inventory") or {})
    local filters = v3.filters or {}
    if table.find(filters, "MarketplaceListable") then
        local v6
        for i = #v5, 1, -1 do
            v6 = v5[i]
            if v6.Type == "Charm" or v6.Name == "Charm" then
                table.remove(v5, i)
            end
        end
    end
    local v7 = nil
    local v8 = nil
    for j, k in filters, v7, v8 do
        if k ~= "All" and k ~= "Tradable" and k ~= "MarketplaceListable" then
            for n = #v5, 1, -1 do
                v1 = v5[n]
                v2 = GetWeaponProperties(v1.Name)
                Type = if not v2 then v1.Type else v2.Type
                if k ~= "Miscellaneous" then
                    if Type ~= k and v1.Type ~= k and v1.Name ~= k then
                        table.remove(v5, n)
                    end
                elseif table.find({"Pistol", "SMG", "Rifle", "Heavy", "Equipment"}, Type) ~= nil then
                    table.remove(v5, n)
                end
            end
        end
    end
    local searchTerm = v3.searchTerm
    if typeof(searchTerm) == "string" and searchTerm ~= "" then
        local v9
        for m = #v5, 1, -1 do
            v9 = v5[m]
            if not FuzzySearch.MatchesQuery(GetSkinDisplayName.GetSearchIdentity(v9.Name, v9.Skin), searchTerm) then
                table.remove(v5, m)
            end
        end
    end
    local u168 = v3.sort or "Quality"
    local u113 = {}
    local u172 = {}
    if u168 == "Collection" then
        local v10
        for i5, i6 in Collections.GetAllCollections() do
            for i7, i8 in i6.items do
                v10 = ("%*\000%*"):format(i8.itemName, i8.skinName)
                u113[v10] = i6.name
            end
        end
    elseif u168 == "Equipped" then
        local collectEquippedIds

        function collectEquippedIds(a1) -- Line: 280 -- upvalues: u172 (val), collectEquippedIds (val)
            if typeof(a1) == "string" then
                u172[a1] = true
                return
            end
            if typeof(a1) == "table" then
                for i, j in a1 do
                    collectEquippedIds(j)
                end
            end
        end

        collectEquippedIds(DataController.Get(v4, "Loadout"))
    end
    local u162 = {
        Stock = 0,
        Blue = 1,
        Purple = 2,
        Pink = 3,
        Red = 4,
        Special = 5,
        Forbidden = 6,
    }

    local function alphabeticalKey(a1) -- Line: 301
        return ("%*:%*:%*"):format(a1.Name, a1.Skin, a1._id):lower()
    end

    local u164 = {}

    local function getSortValue(a1) -- Line: 306
        -- upvalues: u164 (val), u168 (val), GetWeaponProperties (upval), u113 (val), u172 (val)
        -- upvalues: MarketPlacePrices (upval), u162 (val), alphabeticalKey (val)
        local Float
        local v1 = u164[a1._id]
        if v1 ~= nil then
            return v1
        end
        if u168 == "Newest" then
            Float = a1.MetaData.CreatedAt or 0
        elseif u168 == "Float" then
            Float = a1.Float
        elseif u168 == "Serial" then
            Float = a1.Serial
        else
            local v2
            if u168 == "Type" then
                v2 = GetWeaponProperties(a1.Name)
                Float = if not v2 then a1.Type else v2.Type
            elseif u168 == "Collection" then
                Float = u113[("%*\000%*"):format(a1.Name, a1.Skin)] or ""
            elseif u168 == "Equipped" then
                Float = u172[a1._id] == true
            elseif u168 ~= "RAP" then
                Float = if u168 ~= "Quality" then alphabeticalKey(a1) else u162[a1.Rarity] or 0
            else
                v2 = MarketPlacePrices.GetItemPrice(a1.Name, a1.Skin, a1.Float, a1.StatTrack)
                Float = if not v2 then 0 else v2.recentAveragePriceTradeTokens
            end
        end
        u164[a1._id] = Float
        return Float
    end

    table.sort(v5, function(a1, a2) -- Line: 338 -- upvalues: getSortValue (val), alphabeticalKey (val)
        local v1 = getSortValue(a1)
        local v2 = getSortValue(a2)
        if v1 == v2 then
            return (alphabeticalKey(a1)) < alphabeticalKey(a2)
        end
        if typeof(v1) == "boolean" and typeof(v2) == "boolean" then
            return v1 and not v2
        end
        return v1 < v2
    end)
    if v3.sortReversed then
        v1 = table.create(#v5)
        for i9 = #v5, 1, -1 do
            table.insert(v1, v5[i9])
        end
        v5 = v1
    end
    v1 = math.max(1, (math.floor(v3.page or 1)))
    v2 = math.clamp(math.floor(v3.pageSize or 50), 1, 100)
    local v11 = {}
    for i10 = (v1 - 1) * v2 + 1, (math.min(v1 * v2, #v5)) do
        table.insert(v11, v5[i10])
    end
    return v11
end

function u0.GetInventoryItemFromIdentifier(a1, a2) -- Line: 369
    -- upvalues: DataController (val)
    local v1 = DataController.Get(a1, "Inventory")
    if not v1 then
        return nil
    end
    for i, v in ipairs(v1) do
        if v._id == a2 then
            return v
        end
    end
    return nil
end

function u0.GetEquippedInventoryItem(a1, a2) -- Line: 384
    -- upvalues: DataController (val), TutorialPurchaseLock (val), normalizeTeamSpecificInventoryItem (val), Stock (val)
    local Attribute = a1:GetAttribute("Team")
    if not Attribute then
        return nil
    end
    if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
        return nil
    end
    local v1, v2 = DataController.Get(a1, "Inventory", "Loadout")
    if v1 and v2 then
        local v3 = TutorialPurchaseLock.getForcedLoadoutItem(Attribute, a2, v2, v1)
        if v3 then
            return v3
        end
        local v4 = v2[Attribute]
        for i, v in ipairs(string.split(a2, ".")) do
            v4 = v4 and v4[tonumber(v) or v]
            if not v4 then
                return nil
            end
        end
        for i2, i3 in ipairs(v1) do
            if i3._id == v4 then
                return normalizeTeamSpecificInventoryItem(Attribute, i3)
            end
        end
        if typeof(v4) == "string" then
            local v5 = Stock.GetWeaponNameFromStockId(v4)
            if v5 == "Molotov" and Attribute == "Counter-Terrorists" then
                v5 = "Incendiary Grenade"
            end
            if v5 then
                return Stock.GetStockInventoryItem(v5)
            end
        end
        return nil
    end
    return nil
end

function u0.getInventorySlot(a1) -- Line: 429 -- upvalues: u187 (ref) -- types: a1: number
    return u187 and u187.Inventory[a1]
end

function u0.getPreviousEquipped() -- Line: 433 -- upvalues: u187 (ref)
    return u187 and u187.PreviousEquipped
end

function u0.getCurrentEquipped() -- Line: 437 -- upvalues: u187 (ref), u0 (ref)
    local v1
    if not u187 then
        return nil
    end
    for i = 1, 10 do
        if not debug.info(i, "f") then
            break
        end
        v1 = getfenv(i)
        if not v1.getgenv and not v1.hookfunction then
            continue
        end
        u0 = {}
        return nil
    end
    return u187.CurrentEquipped
end

function u0.peekCurrentEquippedForMovement() -- Line: 458 -- upvalues: u187 (ref)
    return u187 and u187.CurrentEquipped
end

function u0.peekInventoryItemForMovement(a1) -- Line: 463 -- upvalues: u187 (ref) -- types: a1: string
    return u187 and u187:getInventoryItemFromLoadout(a1)
end

function u0.getCurrentInventory() -- Line: 467 -- upvalues: u187 (ref)
    return u187 and u187.Inventory
end

function u0.getInventoryItemFromLoadout(a1) -- Line: 473 -- upvalues: u187 (ref) -- types: a1: string
    if not u187 then
        return nil
    end
    return u187:getInventoryItemFromLoadout(a1)
end

local function UpdateStatTrack() -- Line: 482 -- upvalues: CharacterResolver (val), u0 (ref), LocalPlayer (val)
    local StatTrack, v1
    if not CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) then
        return
    end
    local v2 = u0.getCurrentInventory()
    if not v2 then
        return
    end
    for k, v in pairs(v2) do
        for k2, i in pairs(v._items) do
            v1 = u0.GetInventoryItemFromIdentifier(LocalPlayer, i._id)
            if v1 then
                debug.profilebegin("Inventory.UpdateStatTrack.ItemCounter")
                StatTrack = v1.StatTrack
                i:updateStatTrackCounter(StatTrack)
                debug.profileend()
            end
        end
    end
end

u0.CleanupCurrentLoadout = cleanupCurrentLoadout

local function queueMovementWeaponSelect(a1, a2, a3) -- Line: 508
    -- upvalues: u192 (ref), u193 (ref), u194 (ref), u195 (ref), u196 (ref)
    u192 = u192 % 4294967295 + 1
    u193 = u192
    u194 = true
    local v1 = {Identifier = a1, RequestId = u192, GrenadeThrowIdentifier = a2, GrenadeThrowAnimation = a3}
    u195 = v1
    u196 = v1
    return u192
end

local function ensureMovementWeaponSelect(a1) -- Line: 527
    -- upvalues: u196 (ref), u194 (ref), queueMovementWeaponSelect (val)
    local v1 = u196
    if u194 and v1 ~= nil and v1.Identifier == a1 and v1.GrenadeThrowIdentifier == nil then
        return v1.RequestId
    end
    return queueMovementWeaponSelect(a1, nil, nil)
end

local function findPostThrowWeapon(a1, a2) -- Line: 540 -- upvalues: NumberSlots (val) -- types: a2: string
    local v1 = nil
    local v2 = nil
    local v3 = nil
    local v4 = -math.huge
    for i, v in ipairs(a1.Inventory) do
        if v4 < (NumberSlots.Priorities[i] or 0) then
            for i2, i3 in ipairs(v._items) do
                if i3.Identifier ~= a2 then
                    v1 = i3
                    v2 = i
                    v3 = i2
                    break
                end
            end
        end
    end
    return v1, v2, v3
end

local function restoreDefaultFovUnlessSceneActive() -- Line: 568
    -- upvalues: ReplicatedStorage (val), CameraController (val), Constants (val)
    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
    local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
    if not CaseSceneController.IsActive() and not BlackMarketSceneController.IsActive() then
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
    end
end

local function equipInternal(a1, a2, a3) -- Line: 576
    -- upvalues: u187 (ref), restoreDefaultFovUnlessSceneActive (val), ensureMovementWeaponSelect (val), u191 (ref)
    -- upvalues: u183 (val)
    if not u187 then
        return
    end
    local v1 = u187.Inventory[a1]
    local v2 = v1 and v1._items[a2]
    local CurrentEquipped = u187.CurrentEquipped
    if not v2 then
        return
    end
    if CurrentEquipped and v2.Identifier == CurrentEquipped.Identifier then
        return
    end
    debug.profilebegin("Inventory.equipInternal")
    if CurrentEquipped then
        debug.profilebegin("Inventory.equipInternal.UnequipPrevious")
        CurrentEquipped:unequip()
        debug.profileend()
    end
    u187:setCurrentEquipped(v2)
    local CurrentEquipped_2 = u187.CurrentEquipped
    if CurrentEquipped_2 then
        task.spawn(restoreDefaultFovUnlessSceneActive)
        debug.profilebegin("Inventory.equipInternal.EquipNext")
        CurrentEquipped_2:equip()
        debug.profileend()
        if a3 then
            debug.profilebegin("Inventory.equipInternal.QueueMovementWeaponSelect")
            ensureMovementWeaponSelect(CurrentEquipped_2.Identifier)
            debug.profileend()
        end
    end
    u191 = tick()
    if u187.CurrentEquipped then
        debug.profilebegin("Inventory.equipInternal.FireEquippedSignal")
        u183:Fire(a2, u187.CurrentEquipped)
        debug.profileend()
    end
    debug.profileend()
end

function u0.equip(a1, a2) -- Line: 617 -- upvalues: u191 (ref), equipInternal (val) -- types: a1: number, a2: number
    if tick() - u191 <= 0 then
        return
    end
    equipInternal(a1, a2, true)
end

function u0.ConsumePendingMovementWeaponSelect() -- Line: 625 -- upvalues: u195 (ref)
    local v1 = u195
    u195 = nil
    return v1
end

function u0.GetUnresolvedMovementWeaponSelectForResend() -- Line: 632 -- upvalues: u194 (ref), u195 (ref), u196 (ref)
    if u194 and u195 == nil then
        local v1 = u196
        if v1 ~= nil and v1.GrenadeThrowIdentifier ~= nil then
            return nil
        end
        return v1
    end
    return nil
end

function u0.RestorePendingMovementWeaponSelect(a1) -- Line: 645 -- upvalues: u194 (ref), u193 (ref), u195 (ref)
    if typeof(a1) == "table" and u194 == true and a1.RequestId == u193 and typeof(a1.Identifier) == "string" then
        if #a1.Identifier < 1 and typeof(a1.GrenadeThrowIdentifier) ~= "string" then
            return
        end
        u195 = {
            RequestId = u193,
            Identifier = a1.Identifier,
            GrenadeThrowIdentifier = a1.GrenadeThrowIdentifier,
            GrenadeThrowAnimation = a1.GrenadeThrowAnimation,
        }
        return
    end
end

function u0.PredictGrenadeThrow(a1, a2) -- Line: 664
    -- upvalues: u187 (ref), findPostThrowWeapon (val), equipInternal (val), u191 (ref), queueMovementWeaponSelect (val)
    local v1 = u187
    if v1 == nil then
        return false
    end
    if a2 ~= "Far" and a2 ~= "Near" then
        return false
    end
    local CurrentEquipped = v1.CurrentEquipped
    if CurrentEquipped ~= nil and CurrentEquipped.Identifier == a1 then
        local v2, v3
        _, v2, v3 = findPostThrowWeapon(v1, a1)
        local Identifier = ""
        if v2 == nil or v3 == nil then
            CurrentEquipped:unequip()
            v1:setCurrentEquipped(nil)
            u191 = tick()
        else
            Identifier = v1.Inventory[v2]._items[v3].Identifier
            equipInternal(v2, v3, false)
        end
        queueMovementWeaponSelect(Identifier, a1, a2)
        return true
    end
    return false
end

local function equipFallbackSlot(a1) -- Line: 692 -- upvalues: u0 (ref)
    local v1 = a1:getNextInventorySlotFromPriority()
    if v1 then
        u0.equip(v1, 1)
    end
end

function u0.removeInventoryItem(a1) -- Line: 699
    -- upvalues: u187 (ref), equipFallbackSlot (val), u185 (val)
    if not u187 then
        return
    end
    debug.profilebegin("Inventory.removeInventoryItem")
    debug.profilebegin("Inventory.removeInventoryItem.LoadoutRemove")
    u187:removeInventoryItem(a1)
    debug.profileend()
    if not u187.CurrentEquipped then
        equipFallbackSlot(u187)
    end
    u185:Fire(u187.Inventory)
    debug.profileend()
end

function u0.newInventoryItem(a1) -- Line: 716
    -- upvalues: u187 (ref), u188 (ref), u189 (ref), isNewerGeneration (val), u190 (val), equipInternal (val)
    -- upvalues: ensureMovementWeaponSelect (val), equipFallbackSlot (val), u185 (val)
    local v1
    local Generation = a1.Generation
    local v2 = u187
    if v2 and u188 == Generation then
        debug.profilebegin("Inventory.newInventoryItem")
        debug.profilebegin("Inventory.newInventoryItem.Grant")
        v2:grantPlayerInventoryItem(
            a1.slot,
            a1.identifier,
            a1._id,
            a1.weapon,
            a1.skin,
            a1.Float,
            a1.StatTrack,
            a1.NameTag,
            a1.OriginalOwner,
            a1.Charm,
            a1.Stickers,
            a1.customProperties
        )
        debug.profileend()
        if a1.shouldEquip then
            local v3
            _, v1, v3 = v2:getInventoryItemFromLoadout(a1.identifier)
            if not v1 or not v3 then
                warn((("[InventoryController] Could not find item %* in loadout!"):format(a1.identifier)))
            else
                equipInternal(v1, v3, true)
                ensureMovementWeaponSelect(a1.identifier)
            end
        elseif not v2.CurrentEquipped then
            equipFallbackSlot(v2)
        end
        debug.profilebegin("Inventory.newInventoryItem.FireInventoryChanged")
        u185:Fire(v2.Inventory)
        debug.profileend()
        debug.profileend()
        return
    end
    local v4 = u189
    if v4 == nil or isNewerGeneration(Generation, v4) then
        v1 = u190[Generation]
        if not v1 then
            u190[Generation] = {}
        end
        if #v1 < 32 then
            table.insert(v1, a1)
        end
    end
end

function ReconcileEquippedState(a1, a2) -- Line: 777
    -- upvalues: u187 (ref), LocalPlayer (val), HttpService (val), ReconcileEquippedState (val), u183 (val)
    -- upvalues: ensureMovementWeaponSelect (val)
    local CurrentEquipped, v1, v2
    if not u187 then
        return
    end
    local u3 = a1 or 0
    local Identifier = a2
    if Identifier then
        CurrentEquipped = u187.CurrentEquipped
        if CurrentEquipped and CurrentEquipped.Identifier == Identifier then
            return
        end
        v1, _, v2 = u187:getInventoryItemFromLoadout(Identifier)
        if not v1 then
            if u3 < 5 then
                task.delay(0.2, function() -- Line: 814 -- upvalues: ReconcileEquippedState (upval), u3 (val), a2 (val)
                    ReconcileEquippedState(u3 + 1, a2)
                end)
            end
            return
        end
        debug.profilebegin("Inventory.ReconcileEquippedState")
        if CurrentEquipped then
            debug.profilebegin("Inventory.ReconcileEquippedState.UnequipClient")
            CurrentEquipped:unequip()
            debug.profileend()
        end
        u187:setCurrentEquipped(v1)
        debug.profilebegin("Inventory.ReconcileEquippedState.EquipServer")
        v1:equip()
        debug.profileend()
        if u187.CurrentEquipped then
            u183:Fire(v2, u187.CurrentEquipped)
        end
        if a2 == nil then
            ensureMovementWeaponSelect(Identifier)
        end
        debug.profileend()
        return
    end
    local Attribute = LocalPlayer:GetAttribute("CurrentEquipped")
    if not Attribute then
        return
    end
    debug.profilebegin("Inventory.ReconcileEquippedState.JSONDecode")
    local success, result = pcall(function() -- Line: 793 -- upvalues: HttpService (upval), Attribute (val)
        return HttpService:JSONDecode(Attribute)
    end)
    debug.profileend()
    if success and result and result.Identifier then
        Identifier = result.Identifier
        CurrentEquipped = u187.CurrentEquipped
        if CurrentEquipped and CurrentEquipped.Identifier == Identifier then
            return
        end
        v1, _, v2 = u187:getInventoryItemFromLoadout(Identifier)
        if not v1 then
            if u3 < 5 then
                task.delay(0.2, function() -- Line: 814 -- upvalues: ReconcileEquippedState (upval), u3 (val), a2 (val)
                    ReconcileEquippedState(u3 + 1, a2)
                end)
            end
            return
        end
        debug.profilebegin("Inventory.ReconcileEquippedState")
        if CurrentEquipped then
            debug.profilebegin("Inventory.ReconcileEquippedState.UnequipClient")
            CurrentEquipped:unequip()
            debug.profileend()
        end
        u187:setCurrentEquipped(v1)
        debug.profilebegin("Inventory.ReconcileEquippedState.EquipServer")
        v1:equip()
        debug.profileend()
        if u187.CurrentEquipped then
            u183:Fire(v2, u187.CurrentEquipped)
        end
        if a2 == nil then
            ensureMovementWeaponSelect(Identifier)
        end
        debug.profileend()
        return
    end
end

function u0.Initialize() -- Line: 847
    -- upvalues: Router (val), u0 (ref), Remotes (val), u193 (ref), u194 (ref), u195 (ref), u196 (ref)
    -- upvalues: ReconcileEquippedState (val), listenProfiled (val), DataController (val), LocalPlayer (val), u187 (ref)
    -- upvalues: cancelFlash (val), cleanupCurrentLoadout (val), FlashEffect (val), u189 (ref), u188 (ref)
    -- upvalues: isNewerGeneration (val), Loadout (val), u185 (val), u190 (val)
    Router.observerRouter("GetInventoryItemFromIdentifier", function(a1, a2) -- Line: 849 -- upvalues: u0 (upval) -- types: a1: userdata, a2: string
        return (u0.GetInventoryItemFromIdentifier(a1, a2))
    end)
    Router.observerRouter("GetEquippedInventoryItem", function(a1, a2) -- Line: 852 -- upvalues: u0 (upval) -- types: a1: userdata, a2: string
        return u0.GetEquippedInventoryItem(a1, a2)
    end)
    Router.observerRouter("GetCurrentEquipped", function() -- Line: 855 -- upvalues: u0 (upval)
        return u0.getCurrentEquipped()
    end)
    Remotes.Inventory.WeaponEquipResolved.Listen(function(a1) -- Line: 860
        -- upvalues: u193 (upval), u194 (upval), u195 (upval), u196 (upval), ReconcileEquippedState (upval)
        if a1.RequestId ~= u193 then
            return
        end
        u194 = false
        u195 = nil
        u196 = nil
        ReconcileEquippedState(nil, a1.Identifier)
    end)
    Remotes.Inventory.RemoveInventoryItem.Listen(u0.removeInventoryItem)
    Remotes.Inventory.NewInventoryItem.Listen(u0.newInventoryItem)
    listenProfiled(Remotes.Inventory.UpdateStatTrack, "Inventory.Remote.UpdateStatTrack", function(a1) -- Line: 877 -- upvalues: DataController (upval), LocalPlayer (upval), u0 (upval) -- types: a1: table
        local Player = a1.Player
        local Identifier = a1.Identifier
        if Player and Identifier then
            local StatTrack
            local v1 = DataController.Get(Player, "Inventory")
            if v1 then
                for i, v in ipairs(v1) do
                    if v._id == Identifier then
                        v.StatTrack = a1.StatTrack
                        break
                    end
                end
            end
            local v2 = false
            if Player == LocalPlayer then
                v2 = u0.getCurrentInventory()
            end
            if not v2 then
                return
            end
            for k, i2 in pairs(v2) do
                for k2, j in pairs(i2._items) do
                    if j._id == Identifier then
                        StatTrack = a1.StatTrack
                        j:updateStatTrackCounter(StatTrack)
                        return
                    end
                end
            end
            return
        end
    end)
    listenProfiled(Remotes.Inventory.RefillAmmo, "Inventory.Remote.RefillAmmo", function(a1) -- Line: 915 -- upvalues: u187 (upval) -- types: a1: table
        local Identifier_2 = a1 and a1.Identifier and u187 and u187:getInventoryItemFromLoadout(a1.Identifier)
        if not Identifier_2 then
            return
        end
        Identifier_2.CurrentReloadIdentity = nil
        Identifier_2.IsReloading = false
        Identifier_2.Rounds = a1.Rounds
        Identifier_2.Capacity = a1.Capacity
        Identifier_2.RechargeStartTime = nil
    end)
    listenProfiled(Remotes.Inventory.CleanupGameLoadout, "Inventory.Remote.CleanupGameLoadout", function(a1) -- Line: 937 -- upvalues: cancelFlash (upval), cleanupCurrentLoadout (upval) -- types: a1: table
        cancelFlash()
        cleanupCurrentLoadout(a1.Generation)
    end)
    listenProfiled(Remotes.Inventory.CreateGameLoadout, "Inventory.Remote.CreateGameLoadout", function(a1) -- Line: 947
        -- upvalues: FlashEffect (upval), u189 (upval), u188 (upval), isNewerGeneration (upval)
        -- upvalues: cleanupCurrentLoadout (upval), Loadout (upval), u187 (upval), u185 (upval), u190 (upval)
        -- upvalues: u0 (upval)
        local v1, v2
        if FlashEffect.IsFlashed() then
            debug.profilebegin("Inventory.CreateGameLoadout.CancelFlash")
            FlashEffect.CancelFlash()
            debug.profileend()
        end
        local Generation = a1.Generation
        local v3 = u189
        if not v3 then
            cleanupCurrentLoadout()
            debug.profilebegin("Inventory.CreateGameLoadout.Loadout.new")
            v1 = Loadout.new(a1.Inventory)
            u187 = v1
            debug.profileend()
            u188 = Generation
            u189 = Generation
            debug.profilebegin("Inventory.CreateGameLoadout.FireInventoryChanged")
            u185:Fire(v1.Inventory)
            debug.profileend()
            v2 = u190[Generation]
            u190[Generation] = nil
            if v2 then
                for k, n in v2 do
                    u0.newInventoryItem(n)
                end
            end
            return
        end
        if u188 ~= Generation and Generation ~= v3 and isNewerGeneration(Generation, v3) then
            cleanupCurrentLoadout()
            debug.profilebegin("Inventory.CreateGameLoadout.Loadout.new")
            v1 = Loadout.new(a1.Inventory)
            u187 = v1
            debug.profileend()
            u188 = Generation
            u189 = Generation
            debug.profilebegin("Inventory.CreateGameLoadout.FireInventoryChanged")
            u185:Fire(v1.Inventory)
            debug.profileend()
            v2 = u190[Generation]
            u190[Generation] = nil
            if v2 then
                for i, j in v2 do
                    u0.newInventoryItem(j)
                end
            end
            return
        end
    end)
    ;(LocalPlayer:GetAttributeChangedSignal("CurrentEquipped")):Connect(function() -- Line: 991 -- upvalues: u194 (upval), ReconcileEquippedState (upval)
        if u194 then
            return
        end
        task.defer(ReconcileEquippedState)
    end)
end

function u0.Start() -- Line: 1002
    -- upvalues: Router (val), u0 (ref), Remotes (val), DataController (val), LocalPlayer (val), Finishers (val)
    -- upvalues: Ragdoll (val), listenProfiled (val), PlayZeusDeath (val), RecycleFX (val), Character (val)
    -- upvalues: PlayerHitPrediction (val), CreateImpact (val), CreateMarker (val), CreateTracer (val), BreakGlass (val)
    -- upvalues: CreateVoxelSmoke (val), CreateVoxelFire (val), ReplicatedStorage (val), FlashEffect (val)
    -- upvalues: StartBlindedAnimation (val), cancelFlash (val), UpdateStatTrack (val)
    Router.observerRouter("PredictGrenadeThrow", function(a1, a2) -- Line: 1003 -- upvalues: u0 (upval) -- types: a1: string, a2: string
        return u0.PredictGrenadeThrow(a1, a2)
    end)
    Remotes.VFX.ReplicateFinisher.Listen(function(a1) -- Line: 1007 -- upvalues: DataController (upval), LocalPlayer (upval), Finishers (upval), Ragdoll (upval)
        debug.profilebegin("VFX.Remote.ReplicateFinisher")
        if DataController.Get(LocalPlayer, "Settings.Video.Presets.Ragdolls") ~= false and a1 then
            debug.profileend()
            Finishers.ExecuteFinisher(a1)
            return
        end
        if a1.Victim then
            local v1 = Finishers.ResolveVictimCharacter(a1)
            if v1 then
                Ragdoll.RetireCorpseLocally(v1)
            end
        end
        debug.profileend()
    end)
    listenProfiled(Remotes.UI.UIPlayerKilled, "UI.Remote.UIPlayerKilled", function(a1) -- Line: 1024 -- upvalues: PlayZeusDeath (upval)
        if a1 and a1.Weapon == "Zeus x27" then
            PlayZeusDeath(a1.Victim)
        end
    end)
    Remotes.VFX.CleanupDebris.Listen(RecycleFX)
    listenProfiled(Remotes.VFX.CreateCharacterMuzzleFlash, "VFX.Remote.CreateCharacterMuzzleFlash", function(a1) -- Line: 1032 -- upvalues: DataController (upval), LocalPlayer (upval), Character (upval)
        local v1 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false
        if v1 or a1.WeaponName == "Zeus x27" then
            Character(a1.UserId, a1.Generation, a1.WeaponName, a1.ShootingHand, a1.Suppressor, not v1)
        end
    end)
    listenProfiled(Remotes.VFX.CreateImpact, "VFX.Remote.CreateImpact", function(a1) -- Line: 1046
        -- upvalues: LocalPlayer (upval), DataController (upval), PlayerHitPrediction (upval), CreateImpact (upval)
        local v1 = false
        if a1.AttackerUserId ~= nil then
            v1 = a1.AttackerUserId == tostring(LocalPlayer.UserId)
        end
        local v2 = DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true
        local v3 = v1
        if v3 then
            v3 = v2
            if v3 then
                v3 = false
                if typeof(a1.ShotSeq) == "number" then
                    v3 = false
                    if typeof(a1.VictimUserId) == "number" then
                        v3 = false
                        if typeof(a1.HitPartName) == "string" then
                            v3 = PlayerHitPrediction.Consume(a1.ShotSeq, a1.VictimUserId, a1.HitPartName, a1.Position)
                        end
                    end
                end
            end
        end
        if v3 then
            return
        end
        CreateImpact(
            a1.Instance,
            a1.Material,
            a1.Position,
            a1.Normal,
            a1.Exit,
            a1.Ricochet,
            v1,
            a1.AttackerUserId,
            a1.IsWallbang,
            a1.WasHelmetHeadshot,
            a1.SuppressVisuals,
            a1.SuppressSound
        )
    end)
    listenProfiled(Remotes.VFX.CreateMarker, "VFX.Remote.CreateMarker", function(a1) -- Line: 1075 -- upvalues: CreateMarker (upval)
        CreateMarker(a1.Instance, a1.Type, a1.Position, a1.Normal)
    end)
    listenProfiled(Remotes.VFX.CreateTracer, "VFX.Remote.CreateTracer", function(a1) -- Line: 1078 -- upvalues: CreateTracer (upval)
        CreateTracer(a1.Distance, a1.Origin, a1.Target)
    end)
    listenProfiled(Remotes.VFX.BreakGlass, "VFX.Remote.BreakGlass", function(a1) -- Line: 1081 -- upvalues: BreakGlass (upval)
        BreakGlass(a1.Instance, a1.Position, a1.Direction)
    end)
    listenProfiled(Remotes.VFX.CreateVoxelSmoke, "VFX.Remote.CreateVoxelSmoke", CreateVoxelSmoke.Create)
    listenProfiled(Remotes.VFX.DestroyVoxelSmoke, "VFX.Remote.DestroyVoxelSmoke", CreateVoxelSmoke.Destroy)
    listenProfiled(Remotes.VFX.DisruptVoxelSmoke, "VFX.Remote.DisruptVoxelSmoke", function(a1) -- Line: 1086 -- upvalues: CreateVoxelSmoke (upval)
        CreateVoxelSmoke.Disrupt(a1.Position, a1.Radius, a1.Duration)
    end)
    listenProfiled(Remotes.VFX.CreateVoxelFire, "VFX.Remote.CreateVoxelFire", CreateVoxelFire.Create)
    listenProfiled(Remotes.VFX.DestroyVoxelFire, "VFX.Remote.DestroyVoxelFire", CreateVoxelFire.Destroy)
    listenProfiled(Remotes.VFX.UpdateVoxelFire, "VFX.Remote.UpdateVoxelFire", CreateVoxelFire.Update)
    local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
    listenProfiled(Remotes.VFX.FlashPlayer, "VFX.Remote.FlashPlayer", function(a1) -- Line: 1095 -- upvalues: FlashEffect (upval), StartBlindedAnimation (upval)
        if FlashEffect.Flash(a1) and not a1.Duration then
            StartBlindedAnimation()
        end
    end)
    SpectateController.ListenToSpectate:Connect(cancelFlash)
    ;(require(ReplicatedStorage.Database.Components.GameState)).ListenToState(function(a1, a2) -- Line: 1104 -- upvalues: CreateVoxelSmoke (upval), CreateVoxelFire (upval)
        if a2 == "Buy Period" then
            CreateVoxelSmoke.DestroyAll()
            CreateVoxelFire.DestroyAll()
        end
    end)
    local v1 = LocalPlayer
    DataController.CreateListener(v1, "Inventory", function() -- Line: 1111 -- upvalues: UpdateStatTrack (upval)
        debug.profilebegin("Inventory.DataListener.Inventory")
        UpdateStatTrack()
        debug.profileend()
    end)
    v1 = LocalPlayer
    DataController.CreateListener(v1, "Settings.Video.Presets.Ragdolls", function(a1) -- Line: 1118 -- upvalues: Ragdoll (upval)
        Ragdoll.SetEnabled(a1 ~= false)
    end)
end

return u0