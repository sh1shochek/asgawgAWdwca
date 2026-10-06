-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Router = require(ReplicatedStorage.Database.Security.Router);

return table.freeze({
    Name = "Drop Weapon",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p1: any, p2: userdata) -- Line: 29, Name: onInput
        -- upvalues: LocalPlayer (copy), SpectateController (copy), InventoryController (copy), Skins (copy), Rarities (copy), Router (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        if SpectateController.IsLocalPlayerDead() then
            return;
        end;

        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if not CurrentEquipped then
            return;
        end;

        local SkinInformation = Skins.GetSkinInformation(CurrentEquipped.Name, CurrentEquipped.Skin);

        if not SkinInformation then
            return;
        end;

        local v3 = Rarities[SkinInformation.rarity];
        local math_floor_ret = math.floor(v3.Color.R * 255);
        local math_floor_ret2 = math.floor(v3.Color.G * 255);
        local math_floor_ret3 = math.floor(v3.Color.B * 255);

        if CurrentEquipped:drop() then
            Router.broadcastRouter("CreateNotification", "Item Dropped", `You dropped your <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>{CurrentEquipped.Name:find("Zeus") and "Taser" or CurrentEquipped.Name} | {CurrentEquipped.Skin}</b></font>`, 2);
        end;
    end
});