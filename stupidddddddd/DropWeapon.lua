-- ReplicatedStorage.Controllers.InputController.Actions.DropWeapon
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.DropWeapon
-- Decompile time: 0.92 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local LocalPlayer = Players.LocalPlayer
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Router = require(ReplicatedStorage.Database.Security.Router)
return table.freeze({
    Name = "Drop Weapon",
    Group = "Gameplay",
    Category = "Weapon Keys",
    Callback = function(a1, a2) -- Line: 29
        -- upvalues: LocalPlayer (val), SpectateController (val), InventoryController (val), Skins (val), Rarities (val)
        -- upvalues: Router (val)
        if not LocalPlayer:GetAttribute("IsPlayerChatting") and a1 == Enum.UserInputState.Begin then
            if SpectateController.IsLocalPlayerDead() then
                return
            end
            local v1 = InventoryController.getCurrentEquipped()
            if not v1 then
                return
            end
            local v2 = Skins.GetSkinInformation(v1.Name, v1.Skin)
            if not v2 then
                return
            end
            local v3 = Rarities[v2.rarity]
            local v4 = math.floor(v3.Color.R * 255)
            local v5 = math.floor(v3.Color.G * 255)
            local v6 = math.floor(v3.Color.B * 255)
            if v1:drop() then
                Router.broadcastRouter("CreateNotification", "Item Dropped", ("You dropped your <font color = \"rgb(%*, %*, %*)\"><b>%* | %*</b></font>"):format(
                    v4,
                    v5,
                    v6,
                    if not v1.Name:find("Zeus") then v1.Name else "Taser",
                    v1.Skin
                ), 2)
            end
            return
        end
    end,
})