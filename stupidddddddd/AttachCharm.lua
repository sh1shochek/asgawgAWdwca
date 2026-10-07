-- ReplicatedStorage.Interface.Screens.Menu.UseItemFrame.Actions.AttachCharm
-- Script path: ReplicatedStorage.Interface.Screens.Menu.UseItemFrame.Actions.AttachCharm
-- Decompile time: 3.34 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Types)
local LocalPlayer = Players.LocalPlayer
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local u35 = nil
u0.ActionType = "AttachCharm"

local function IsCharmEligibleWeapon(a1) -- Line: 43
    local v1 = true
    if a1.Type ~= "Weapon" then
        v1 = a1.Type == "Zeus x27"
    end
    return v1
end

local function WeaponsWithoutCharm(a1, a2) -- Line: 48
    local v1 = true
    if a1.Type ~= "Weapon" then
        v1 = a1.Type == "Zeus x27"
    end
    if not v1 then
        return false
    end
    v1 = false
    if a1.Charm ~= nil then
        v1 = false
        if a1.Charm ~= false then
            v1 = true
            if type(a1.Charm) ~= "string" then
                v1 = true
                if a1.Charm ~= true then
                    v1 = type(a1.Charm) == "table"
                end
            end
        end
    end
    return not v1
end

local function AllCharms(a1, a2) -- Line: 57 -- upvalues: DataController (val), LocalPlayer (val)
    if a1.Type ~= "Charm" then
        return false
    end
    local v1 = DataController.Get(LocalPlayer, "Inventory")
    if v1 then
        local _id
        for i, v in ipairs(v1) do
            if v.Charm then
                if type(v.Charm) ~= "table" then
                    _id = false
                    if type(v.Charm) == "string" then
                        _id = v.Charm
                    end
                else
                    _id = v.Charm._id
                    if not _id then
                        _id = false
                        if type(v.Charm) == "string" then
                            _id = v.Charm
                        end
                    end
                end
                if _id == a1._id then
                    return false
                end
            end
        end
    end
    return true
end

function u0.GetFilter(a1) -- Line: 81 -- upvalues: AllCharms (val), WeaponsWithoutCharm (val)
    local v1 = true
    if a1.Type ~= "Weapon" then
        v1 = a1.Type == "Zeus x27"
    end
    if v1 then
        return AllCharms
    end
    if a1.Type == "Charm" then
        return WeaponsWithoutCharm
    end
    return function() -- Line: 90
        return false
    end
end

function u0.GetContext(a1) -- Line: 95 -- upvalues: u0 (val)
    return {
        ActionType = u0.ActionType,
        SourceItem = a1,
        Title = if a1.Type ~= "Charm" then "Select Charm" else "Select Weapon",
    }
end

function u0.OnItemSelected(a1, a2) -- Line: 105 -- upvalues: u35 (ref), Router (val)
    local _id, _id_2, v1
    if not a2.SourceItem then
        return
    end
    local SourceItem = a2.SourceItem
    local v2 = true
    if SourceItem.Type ~= "Weapon" then
        v2 = SourceItem.Type == "Zeus x27"
    end
    if v2 then
        if a1.Type ~= "Charm" then
            return
        end
        _id = SourceItem._id
        _id_2 = a1._id
        u35 = {WeaponId = _id, CharmId = _id_2, WeaponItem = SourceItem}
        Router.broadcastRouter(
            "WeaponInspect",
            v1.Name,
            v1.Skin,
            v1.Float,
            v1.StatTrack,
            v1.NameTag,
            {Position = "1", _id = _id_2},
            v1.Stickers,
            v1.Type,
            v1.Pattern,
            v1._id,
            v1.Serial,
            v1.IsTradeable
        )
        return
    end
    if SourceItem.Type ~= "Charm" then
        return
    end
    v2 = true
    if a1.Type ~= "Weapon" then
        v2 = a1.Type == "Zeus x27"
    end
    if not v2 then
        return
    end
    _id = a1._id
    _id_2 = SourceItem._id
    u35 = {WeaponId = _id, CharmId = _id_2, WeaponItem = a1}
    Router.broadcastRouter(
        "WeaponInspect",
        v1.Name,
        v1.Skin,
        v1.Float,
        v1.StatTrack,
        v1.NameTag,
        {Position = "1", _id = _id_2},
        v1.Stickers,
        v1.Type,
        v1.Pattern,
        v1._id,
        v1.Serial,
        v1.IsTradeable
    )
end

function u0.ConfirmAttachment() -- Line: 162 -- upvalues: u35 (ref), Router (val), Remotes (val)
    if not u35 then
        return false
    end
    Remotes.Inventory.UpdateWeaponCharm.Send({
        WeaponId = u35.WeaponId,
        CharmId = u35.CharmId,
        Position = tostring(Router.broadcastRouter("GetCurrentCharmPosition") or 1),
    })
    u35 = nil
    Router.broadcastRouter("WeaponInspectClose")
    return true
end

function u0.CancelAttachment() -- Line: 180 -- upvalues: u35 (ref), Router (val)
    if not u35 then
        return false
    end
    u35 = nil
    Router.broadcastRouter("WeaponInspectClose")
    return true
end

function u0.HasPendingAttachment() -- Line: 191 -- upvalues: u35 (ref)
    return u35 ~= nil
end

function u0.Initialize() -- Line: 197 -- upvalues: MenuState (val), u35 (ref), Router (val), u0 (val)
    MenuState.OnInspectStateChanged:Connect(function(a1) -- Line: 199 -- upvalues: u35 (upval) -- types: a1: boolean
        if not a1 and u35 then
            u35 = nil
        end
    end)
    Router.observerRouter("ConfirmCharmAttachment", u0.ConfirmAttachment)
    Router.observerRouter("HasPendingCharmAttachment", u0.HasPendingAttachment)
    Router.observerRouter("CancelCharmAttachment", u0.CancelAttachment)
end

return u0