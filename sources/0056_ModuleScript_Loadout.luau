-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local LocalPlayer = Players.LocalPlayer;
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
local Grenade = require(ReplicatedStorage.Components.Grenade);
local Weapon = require(ReplicatedStorage.Components.Weapon);
local Melee = require(ReplicatedStorage.Components.Melee);
local C4 = require(ReplicatedStorage.Components.C4);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u2 = {
    Grenade = Grenade,
    Weapon = Weapon,
    Melee = Melee,
    C4 = C4
};

function u1.setCurrentEquipped(p3, p4) -- Line: 50
    p3.PreviousEquipped = p3.CurrentEquipped;
    p3.CurrentEquipped = p4;
end;

function u1.getNextInventorySlotFromPriority(p5) -- Line: 57
    -- upvalues: NumberSlots (copy)
    local v6 = -1;
    local v7 = nil;

    for i, v in ipairs(p5.Inventory) do
        local v8 = NumberSlots.Priorities[i] or 0;

        if #v._items >= 1 and v6 < v8 then
            v7 = i;
            v6 = v8;
        end;
    end;

    return v7;
end;

function u1.getInventoryItemFromLoadout(p9: any, p10: string) -- Line: 72
    local v11 = nil;
    local v12 = nil;
    local v13 = nil;

    for i, v in ipairs(p9.Inventory) do
        local v14 = i;

        for i2, v2 in ipairs(v._items) do
            if v2.Identifier == p10 then
                v13 = i2;
                v12 = v14;
                v11 = v2;
                break;
            end;
        end;
    end;

    return v11, v12, v13;
end;

function u1.removeInventoryItem(p15: any, p16: string) -- Line: 90
    local InventoryItemFromLoadout, v17, v18 = p15:getInventoryItemFromLoadout(p16);
    local v19;

    if InventoryItemFromLoadout then
        v19 = p15.Inventory[v17];
    else
        v19 = InventoryItemFromLoadout;
    end;

    if not v19 then
        return;
    end;

    table.remove(v19._items, v18);

    if p15.CurrentEquipped == InventoryItemFromLoadout then
        p15:setCurrentEquipped(nil);
    end;

    InventoryItemFromLoadout:destroy();
end;

function u1.grantPlayerInventoryItem(p20: any, p21: number, p22: string, p23: string?, p24: string, p25: string, p26: number, p27: any, p28: any, p29: string?, p30: any, p31: table, p32: table?) -- Line: 105
    -- upvalues: GetWeaponProperties (copy), u2 (copy), LocalPlayer (copy)
    local v33 = p20.Inventory[p21];
    local v34 = `{p21} does not exist in player inventory`;
    assert(v33, v34);
    local v35 = GetWeaponProperties(p24);
    local v36 = `Client couldn't find weapon properties for "{p24}"`;
    assert(v35, v36);
    local v37 = u2[v35.Class];
    local v38 = `Client couldn't find weapon component for "{p24}"`;
    assert(v37, v38);
    debug.profilebegin("Loadout.grantPlayerInventoryItem");
    debug.profilebegin("Loadout.grantPlayerInventoryItem.Component.new");
    local success, result = pcall(v37.new, LocalPlayer, p22, p23, p21, p24, p25, p26, p27, p28, p29, p30, p31, p32);
    debug.profileend();

    if not success then
        debug.profileend();
        error(result, 2);
    end;

    debug.profilebegin("Loadout.grantPlayerInventoryItem.InsertAndCleanup");
    table.insert(v33._items, result);
    p20.Janitor:Add(function() -- Line: 157
        -- upvalues: result (copy)
        if result and (getmetatable(result) and not result.IsDestroyed) then
            result:destroy();
        end;
    end);
    debug.profileend();
    debug.profileend();
end;

function u1.new(p39) -- Line: 169
    -- upvalues: u1 (copy), Janitor (copy), RunServiceController (copy), CharacterResolver (copy), LocalPlayer (copy)
    debug.profilebegin("Loadout.new");
    local u40 = setmetatable({}, u1);
    u40.Janitor = Janitor.new();
    u40.IsDestroyed = false;
    u40.Inventory = p39;
    u40.Janitor:Add(RunServiceController.BindToRenderStep("Classes.Loadout.RenderEquippedViewmodel", function(p41: number) -- Line: 175
        -- upvalues: u40 (copy), CharacterResolver (ref), LocalPlayer (ref)
        if u40.IsDestroyed then
            return;
        end;

        local PlayerCharacter = CharacterResolver.getPlayerCharacter(LocalPlayer);

        if PlayerCharacter and PlayerCharacter:GetAttribute("Dead") then
            return;
        end;

        if u40.CurrentEquipped and u40.CurrentEquipped.Viewmodel.IsEquipped then
            debug.profilebegin("Loadout.RenderEquippedViewmodel");
            u40.CurrentEquipped.Viewmodel:render(p41);
            debug.profileend();
        end;
    end));
    debug.profileend();

    return u40;
end;

function u1.destroy(p42) -- Line: 201
    if p42.IsDestroyed then
        return;
    end;

    debug.profilebegin("Loadout.destroy");
    p42.IsDestroyed = true;

    if p42.CurrentEquipped then
        if p42.CurrentEquipped.unequip then
            p42.CurrentEquipped:unequip();
        end;

        if p42.CurrentEquipped.destroy and not p42.CurrentEquipped.IsDestroyed then
            p42.CurrentEquipped:destroy();
        end;

        p42.CurrentEquipped = nil;
    end;

    if p42.PreviousEquipped then
        if p42.PreviousEquipped.destroy and not p42.PreviousEquipped.IsDestroyed then
            p42.PreviousEquipped:destroy();
        end;

        p42.PreviousEquipped = nil;
    end;

    if p42.Inventory then
        for _, v in ipairs(p42.Inventory) do
            if v._items then
                table.clear(v._items);
            end;
        end;
    end;

    p42.Janitor:Destroy();
    p42.Janitor = nil;
    p42.Inventory = nil;
    debug.profileend();
end;

return u1;