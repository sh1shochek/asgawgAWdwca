-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local u2 = nil;
u1.ActionType = "AttachCharm";

local function IsCharmEligibleWeapon(p3) -- Line: 43
    return p3.Type == "Weapon" and true or p3.Type == "Zeus x27";
end;

local function WeaponsWithoutCharm(p4, p5) -- Line: 48
    if p4.Type ~= "Weapon" and p4.Type ~= "Zeus x27" then
        return false;
    end;

    local v6;

    if p4.Charm == nil or p4.Charm == false then
        v6 = false;
    else
        v6 = (type(p4.Charm) == "string" or p4.Charm == true) and true or type(p4.Charm) == "table";
    end;

    return not v6;
end;

local function AllCharms(p7, p8) -- Line: 57
    -- upvalues: DataController (copy), LocalPlayer (copy)
    if p7.Type ~= "Charm" then
        return false;
    end;

    local v9 = DataController.Get(LocalPlayer, "Inventory");

    if v9 then
        for _, v in ipairs(v9) do
            if v.Charm then
                local v10 = type(v.Charm) == "table" and v.Charm._id;

                if not v10 then
                    if type(v.Charm) == "string" then
                        v10 = v.Charm;
                    else
                        v10 = false;
                    end;
                end;

                if v10 == p7._id then
                    return false;
                end;
            end;
        end;
    end;

    return true;
end;

function u1.GetFilter(p11) -- Line: 81
    -- upvalues: AllCharms (copy), WeaponsWithoutCharm (copy)
    if p11.Type == "Weapon" and true or p11.Type == "Zeus x27" then
        return AllCharms;
    end;

    return p11.Type ~= "Charm" and function() -- Line: 90
        return false;
    end or WeaponsWithoutCharm;
end;

function u1.GetContext(p12) -- Line: 95
    -- upvalues: u1 (copy)
    return {
        ActionType = u1.ActionType,
        SourceItem = p12,
        Title = p12.Type == "Charm" and "Select Weapon" or "Select Charm"
    };
end;

function u1.OnItemSelected(p13, p14) -- Line: 105
    -- upvalues: u2 (ref), Router (copy)
    if not p14.SourceItem then
        return;
    end;

    local SourceItem = p14.SourceItem;
    local v15, v16;

    if SourceItem.Type == "Weapon" and true or SourceItem.Type == "Zeus x27" then
        if p13.Type ~= "Charm" then
            return;
        end;

        v15 = SourceItem._id;
        v16 = p13._id;
        p13 = SourceItem;
    else
        if SourceItem.Type ~= "Charm" then
            return;
        end;

        if p13.Type ~= "Weapon" and p13.Type ~= "Zeus x27" then
            return;
        end;

        v15 = p13._id;
        v16 = SourceItem._id;
    end;

    u2 = {
        WeaponId = v15,
        CharmId = v16,
        WeaponItem = p13
    };
    Router.broadcastRouter("WeaponInspect", p13.Name, p13.Skin, p13.Float, p13.StatTrack, p13.NameTag, {
        Position = "1",
        _id = v16
    }, p13.Stickers, p13.Type, p13.Pattern, p13._id, p13.Serial, p13.IsTradeable);
end;

function u1.ConfirmAttachment() -- Line: 162
    -- upvalues: u2 (ref), Router (copy), Remotes (copy)
    if not u2 then
        return false;
    end;

    local v17 = Router.broadcastRouter("GetCurrentCharmPosition") or 1;
    Remotes.Inventory.UpdateWeaponCharm.Send({
        WeaponId = u2.WeaponId,
        CharmId = u2.CharmId,
        Position = tostring(v17)
    });
    u2 = nil;
    Router.broadcastRouter("WeaponInspectClose");

    return true;
end;

function u1.CancelAttachment() -- Line: 180
    -- upvalues: u2 (ref), Router (copy)
    if not u2 then
        return false;
    end;

    u2 = nil;
    Router.broadcastRouter("WeaponInspectClose");

    return true;
end;

function u1.HasPendingAttachment() -- Line: 191
    -- upvalues: u2 (ref)
    return u2 ~= nil;
end;

function u1.Initialize() -- Line: 197
    -- upvalues: MenuState (copy), u2 (ref), Router (copy), u1 (copy)
    MenuState.OnInspectStateChanged:Connect(function(p18: boolean) -- Line: 199
        -- upvalues: u2 (ref)
        if not p18 and u2 then
            u2 = nil;
        end;
    end);
    Router.observerRouter("ConfirmCharmAttachment", u1.ConfirmAttachment);
    Router.observerRouter("HasPendingCharmAttachment", u1.HasPendingAttachment);
    Router.observerRouter("CancelCharmAttachment", u1.CancelAttachment);
end;

return u1;