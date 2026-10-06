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
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
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
    -- upvalues: Grenades (copy)
    local v13 = Grenades[p12];

    if not v13 then
        return false;
    end;

    local v14 = 0;

    if p11 then
        for _, v in ipairs(p11._items) do
            if v.Name == p12 then
                v14 = v14 + 1;
            end;
        end;
    end;

    return v13 <= v14;
end;

function u1.autoPickup(u15) -- Line: 136
    -- upvalues: GetWeaponProperties (copy), NumberSlots (copy), InventoryController (copy), Grenades (copy), u7 (copy), Skins (copy), Rarities (copy), LocalPlayer (copy), Router (copy), Remotes (copy)
    local Attribute = u15.Model:GetAttribute("Weapon");

    if not Attribute then
        return;
    end;

    local v16 = GetWeaponProperties(Attribute);

    if not v16 then
        return;
    end;

    local u17 = NumberSlots[v16.Slot];

    if not u17 then
        return;
    end;

    local InventorySlot = InventoryController.getInventorySlot(u17);
    local v18 = Grenades[Attribute];
    local v19;

    if v18 then
        local v20 = 0;

        if InventorySlot then
            for _, v in ipairs(InventorySlot._items) do
                if v.Name == Attribute then
                    v20 = v20 + 1;
                end;
            end;
        end;

        if v18 <= v20 then
            v19 = true;
        else
            v19 = false;
        end;
    else
        v19 = false;
    end;

    if v19 then
        return;
    end;

    if InventorySlot then
        InventorySlot = #InventorySlot._items < InventorySlot._settings._strict_slot_space;
    end;

    if not (InventorySlot and u15.Model:GetAttribute("CanPickup")) then
        return;
    end;

    if not u15.SentPickupRequest then
        local os_clock_ret = os.clock();
        local v21 = u7[u17];
        local v22;

        if v21 and os_clock_ret - v21 < 1 then
            v22 = false;
        else
            u7[u17] = os_clock_ret;
            task.delay(1, function() -- Line: 91
                -- upvalues: u7 (ref), u17 (copy), os_clock_ret (copy)
                if u7[u17] == os_clock_ret then
                    u7[u17] = nil;
                end;
            end);
            v22 = true;
        end;

        if v22 then
            u15.SentPickupRequest = true;
            task.delay(1, function() -- Line: 163
                -- upvalues: u15 (copy)
                u15.SentPickupRequest = false;
            end);
            local SkinInformation = Skins.GetSkinInformation(u15.Weapon, u15.Skin);
            assert(SkinInformation, "Skin data not found for weapon: " .. u15.Weapon .. " and skin: " .. u15.Skin);
            local v23 = Rarities[SkinInformation.rarity];
            local math_floor_ret = math.floor(v23.Color.R * 255);
            local math_floor_ret2 = math.floor(v23.Color.G * 255);
            local math_floor_ret3 = math.floor(v23.Color.B * 255);

            if u15.Weapon == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
                return;
            end;

            Router.broadcastRouter("CreateNotification", "Item Picked Up", `You picked up a <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>{u15.Weapon:find("Zeus") and "Taser" or u15.Weapon} | {u15.Skin}</b></font>`, 2);
            Remotes.Inventory.PickupWeapon.Send({
                AllowAutoEquip = false,
                Identity = u15.Model.Name
            });
        end;
    end;
end;

function u1.updateState(p24: any, p25: number) -- Line: 190
    -- upvalues: u5 (ref), CharacterResolver (copy), LocalPlayer (copy), DataController (copy), GetWeaponProperties (copy)
    p24.AlphaTime = p24.AlphaTime + p25;
    local v26 = u5;
    local v27;

    if v26 == nil then
        v27 = false;
    else
        v27 = v26:IsDescendantOf(p24.Model);
    end;

    local v28 = v27 and "Hovering";
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter then
        LocalCharacter = LocalCharacter.PrimaryPart;
    end;

    local v29 = LocalCharacter and (LocalCharacter.Position - p24.Model.PrimaryPart.Position).Magnitude <= 6 and (v28 or "Proximity") or v28;

    if p24.Weapon == "C4" then
        local Attribute = LocalPlayer:GetAttribute("Team");

        if p24.AlphaTime >= 1 then
            local FlashingLight = p24.Model.Weapon:FindFirstChild("FlashingLight");
            p24.AlphaTime = 0;

            if FlashingLight then
                FlashingLight.Attachment.PointLight.Enabled = not FlashingLight.Attachment.PointLight.Enabled;
                FlashingLight.Attachment.PointLight.Color = Color3.fromRGB(255, 255, 15);
                FlashingLight.Attachment.PointLight.Brightness = 5;
            end;
        end;

        if Attribute ~= "Terrorists" then
            v29 = false;
        end;
    end;

    local v30 = (v29 == "Hovering" or v29 == "Proximity") and v29 and v29 or nil;

    if p24.LastHoveringState ~= v30 then
        p24.LastHoveringState = v30;
        p24.Model:SetAttribute("HoveringState", v30);
    end;

    local v31 = v30 ~= nil;

    if p24.IsInteractableTagged ~= v31 then
        p24.IsInteractableTagged = v31;

        if v31 then
            p24.Model:AddTag("IsHoveringInteractable");
        else
            p24.Model:RemoveTag("IsHoveringInteractable");
        end;
    end;

    if v30 == "Proximity" then
        local v32 = DataController.Get(LocalPlayer, "Settings.Game.Item.Auto Pickup Dropped Weapons");
        local v33 = GetWeaponProperties(p24.Weapon);

        if v33 then
            v33 = v33.Slot;
        end;

        if v32 ~= false or (v33 == "Grenade" or v33 == "C4") then
            p24:autoPickup();
        end;
    end;
end;

function u1.new(p34: userdata) -- Line: 255
    -- upvalues: u1 (copy), u3 (copy), u4 (ref), u6 (ref), RunServiceController (copy), u5 (ref), CenterScreenRaycast (copy), u2 (copy)
    local v35 = setmetatable({}, u1);
    v35.Model = p34;
    v35.AlphaTime = 0;
    v35.Weapon = v35.Model:GetAttribute("Weapon");
    v35.Skin = v35.Model:GetAttribute("Skin");
    v35.SentPickupRequest = false;
    v35.IsInteractableTagged = false;
    u3[v35] = true;
    u4 = u4 + 1;

    if u6 then
        return v35;
    end;

    u6 = RunServiceController.BindToHeartbeat("Observers.Game.WeaponDropped.Update", function(p36: number) -- Line: 67
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
                i:updateState(p36);
            end;
        end;
    end);

    return v35;
end;

function u1.destroy(p37) -- Line: 273
    -- upvalues: u3 (copy), u4 (ref), u6 (ref), u5 (ref)
    if u3[p37] then
        u3[p37] = nil;
        u4 = u4 - 1;

        if u4 <= 0 and u6 then
            u6:Disconnect();
            u6 = nil;
            u5 = nil;
        end;
    end;

    if p37.IsInteractableTagged then
        p37.Model:RemoveTag("IsHoveringInteractable");
        p37.IsInteractableTagged = false;
    end;

    if p37.LastHoveringState ~= nil then
        p37.Model:SetAttribute("HoveringState", nil);
        p37.LastHoveringState = nil;
    end;
end;

return u1;