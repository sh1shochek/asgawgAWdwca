-- ReplicatedStorage.Controllers.Observers.Game.WeaponDropped.Weapon
-- Script path: ReplicatedStorage.Controllers.Observers.Game.WeaponDropped.Weapon
-- Decompile time: 7.66 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast);
local SurvivalBuyRules = require(ReplicatedStorage.Components.Common.SurvivalBuyRules);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local LocalPlayer = Players.LocalPlayer;
local u2 = {
    ProximityRange = 6,
    HoverRange = 10
};
local u3 = {};
local u4 = 0;
local u5 = nil;
local u6 = nil;
local u7 = {};

local function UpdateHoveredInstance() -- Line: 50
    -- upvalues: u5 (ref), CenterScreenRaycast (copy)
    u5 = CenterScreenRaycast.GetInstance(10);
end;

local function StopSharedHeartbeatIfIdle() -- Line: 54
    -- upvalues: u4 (ref), u6 (ref), u5 (ref)
    if u4 <= 0 and u6 then
        u6:Disconnect();
        u6 = nil;
        u5 = nil;
    end;
end;

local function EnsureSharedHeartbeat() -- Line: 62
    -- upvalues: u6 (ref), RunServiceController (copy), u4 (ref), u5 (ref), CenterScreenRaycast (copy), u2 (copy), u3 (copy)
    if u6 then
        return;
    end;

    u6 = RunServiceController.BindToHeartbeat("Observers.Game.WeaponDropped.Update", function(p8: number) -- Line: 67
        -- upvalues: u4 (ref), u6 (ref), u5 (ref), CenterScreenRaycast (ref), u2 (ref), u3 (ref)
        if u4 <= 0 then
            if u4 <= 0 and u6 then
                u6:Disconnect();
                u6 = nil;
                u5 = nil;
            end;

            return;
        end;

        u5 = CenterScreenRaycast.GetInstance(u2.HoverRange);

        for i in pairs(u3) do
            if i.Model.PrimaryPart then
                i:updateState(p8);
            end;
        end;
    end);
end;

local function ReserveAutoPickupSlot(u9: number) -- Line: 83
    -- upvalues: u7 (copy)
    local os_clock_ret = os.clock();
    local v10 = u7[u9];

    if v10 and os_clock_ret - v10 < 1 then
        return false;
    end;

    u7[u9] = os_clock_ret;
    task.delay(1, function() -- Line: 91
        -- upvalues: u7 (ref), u9 (copy), os_clock_ret (copy)
        if u7[u9] == os_clock_ret then
            u7[u9] = nil;
        end;
    end);

    return true;
end;

local function HasReachedDuplicateLimit(p11: any, p12: string) -- Line: 116
    -- upvalues: SurvivalBuyRules (copy)
    local GrenadeLimit = SurvivalBuyRules.GetGrenadeLimit(p12);

    if not GrenadeLimit then
        return false;
    end;

    local v13 = 0;

    if p11 then
        for _, v in ipairs(p11._items) do
            if v.Name == p12 then
                v13 = v13 + 1;
            end;
        end;
    end;

    return GrenadeLimit <= v13;
end;

function u1.autoPickup(u14) -- Line: 136
    -- upvalues: GetWeaponProperties (copy), NumberSlots (copy), InventoryController (copy), HasReachedDuplicateLimit (copy), u7 (copy), Skins (copy), Rarities (copy), LocalPlayer (copy), Router (copy), Remotes (copy)
    local Attribute = u14.Model:GetAttribute("Weapon");

    if not Attribute then
        return;
    end;

    local v15 = GetWeaponProperties(Attribute);

    if not v15 then
        return;
    end;

    local u16 = NumberSlots[v15.Slot];

    if not u16 then
        return;
    end;

    local InventorySlot = InventoryController.getInventorySlot(u16);

    if HasReachedDuplicateLimit(InventorySlot, Attribute) then
        return;
    end;

    if InventorySlot then
        InventorySlot = #InventorySlot._items < InventorySlot._settings._strict_slot_space;
    end;

    if not (InventorySlot and u14.Model:GetAttribute("CanPickup")) then
        return;
    end;

    if not u14.SentPickupRequest then
        local os_clock_ret = os.clock();
        local v17 = u7[u16];
        local v18;

        if v17 and os_clock_ret - v17 < 1 then
            v18 = false;
        else
            u7[u16] = os_clock_ret;
            task.delay(1, function() -- Line: 91
                -- upvalues: u7 (ref), u16 (copy), os_clock_ret (copy)
                if u7[u16] == os_clock_ret then
                    u7[u16] = nil;
                end;
            end);
            v18 = true;
        end;

        if v18 then
            u14.SentPickupRequest = true;
            task.delay(1, function() -- Line: 163
                -- upvalues: u14 (copy)
                u14.SentPickupRequest = false;
            end);
            local SkinInformation = Skins.GetSkinInformation(u14.Weapon, u14.Skin);
            assert(SkinInformation, "Skin data not found for weapon: " .. u14.Weapon .. " and skin: " .. u14.Skin);
            local v19 = Rarities[SkinInformation.rarity];
            local math_floor_ret = math.floor(v19.Color.R * 255);
            local math_floor_ret2 = math.floor(v19.Color.G * 255);
            local math_floor_ret3 = math.floor(v19.Color.B * 255);

            if u14.Weapon == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
                return;
            end;

            Router.broadcastRouter("CreateNotification", "Item Picked Up", `You picked up a <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>{u14.Weapon:find("Zeus") and "Taser" or u14.Weapon} | {u14.Skin}</b></font>`, 2);
            Remotes.Inventory.PickupWeapon.Send({
                AllowAutoEquip = false,
                Identity = u14.Model.Name
            });
        end;
    end;
end;

function u1.updateState(p20: any, p21: number) -- Line: 190
    -- upvalues: u5 (ref), CharacterResolver (copy), LocalPlayer (copy), DataController (copy), GetWeaponProperties (copy)
    p20.AlphaTime = p20.AlphaTime + p21;
    local v22 = u5;
    local v23;

    if v22 == nil then
        v23 = false;
    else
        v23 = v22:IsDescendantOf(p20.Model);
    end;

    local v24 = v23 and "Hovering";
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter then
        LocalCharacter = LocalCharacter.PrimaryPart;
    end;

    local v25 = LocalCharacter and (LocalCharacter.Position - p20.Model.PrimaryPart.Position).Magnitude <= 6 and (v24 or "Proximity") or v24;

    if p20.Weapon == "C4" then
        local Attribute = LocalPlayer:GetAttribute("Team");

        if p20.AlphaTime >= 1 then
            local FlashingLight = p20.Model.Weapon:FindFirstChild("FlashingLight");
            p20.AlphaTime = 0;

            if FlashingLight then
                FlashingLight.Attachment.PointLight.Enabled = not FlashingLight.Attachment.PointLight.Enabled;
                FlashingLight.Attachment.PointLight.Color = Color3.fromRGB(255, 255, 15);
                FlashingLight.Attachment.PointLight.Brightness = 5;
            end;
        end;

        if Attribute ~= "Terrorists" then
            v25 = false;
        end;
    end;

    local v26 = (v25 == "Hovering" or v25 == "Proximity") and v25 and v25 or nil;

    if p20.LastHoveringState ~= v26 then
        p20.LastHoveringState = v26;
        p20.Model:SetAttribute("HoveringState", v26);
    end;

    local v27 = v26 ~= nil;

    if p20.IsInteractableTagged ~= v27 then
        p20.IsInteractableTagged = v27;

        if v27 then
            p20.Model:AddTag("IsHoveringInteractable");
        else
            p20.Model:RemoveTag("IsHoveringInteractable");
        end;
    end;

    if v26 == "Proximity" then
        local v28 = DataController.Get(LocalPlayer, "Settings.Game.Item.Auto Pickup Dropped Weapons");
        local v29 = GetWeaponProperties(p20.Weapon);

        if v29 then
            v29 = v29.Slot;
        end;

        if v28 ~= false or (v29 == "Grenade" or v29 == "C4") then
            p20:autoPickup();
        end;
    end;
end;

function u1.new(p30: userdata) -- Line: 255
    -- upvalues: u1 (copy), u3 (copy), u4 (ref), u6 (ref), RunServiceController (copy), u5 (ref), CenterScreenRaycast (copy), u2 (copy)
    local v31 = setmetatable({}, u1);
    v31.Model = p30;
    v31.AlphaTime = 0;
    v31.Weapon = v31.Model:GetAttribute("Weapon");
    v31.Skin = v31.Model:GetAttribute("Skin");
    v31.SentPickupRequest = false;
    v31.IsInteractableTagged = false;
    u3[v31] = true;
    u4 = u4 + 1;

    if u6 then
        return v31;
    end;

    u6 = RunServiceController.BindToHeartbeat("Observers.Game.WeaponDropped.Update", function(p32: number) -- Line: 67
        -- upvalues: u4 (ref), u6 (ref), u5 (ref), CenterScreenRaycast (ref), u2 (ref), u3 (ref)
        if u4 <= 0 then
            if u4 <= 0 and u6 then
                u6:Disconnect();
                u6 = nil;
                u5 = nil;
            end;

            return;
        end;

        u5 = CenterScreenRaycast.GetInstance(u2.HoverRange);

        for i in pairs(u3) do
            if i.Model.PrimaryPart then
                i:updateState(p32);
            end;
        end;
    end);

    return v31;
end;

function u1.destroy(p33) -- Line: 273
    -- upvalues: u3 (copy), u4 (ref), u6 (ref), u5 (ref)
    if u3[p33] then
        u3[p33] = nil;
        u4 = u4 - 1;

        if u4 <= 0 and u6 then
            u6:Disconnect();
            u6 = nil;
            u5 = nil;
        end;
    end;

    if p33.IsInteractableTagged then
        p33.Model:RemoveTag("IsHoveringInteractable");
        p33.IsInteractableTagged = false;
    end;

    if p33.LastHoveringState ~= nil then
        p33.Model:SetAttribute("HoveringState", nil);
        p33.LastHoveringState = nil;
    end;
end;

return u1;