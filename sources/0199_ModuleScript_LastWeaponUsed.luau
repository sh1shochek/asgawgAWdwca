-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);

local function equipFallback() -- Line: 23
    -- upvalues: InventoryController (copy)
    local CurrentInventory = InventoryController.getCurrentInventory();
    local CurrentEquipped = InventoryController.getCurrentEquipped();

    if not (CurrentInventory and CurrentEquipped) then
        return;
    end;

    local v1 = nil;
    local v2 = nil;

    for _, v in ipairs(CurrentInventory) do
        for i, v3 in ipairs(v._items) do
            if v3.Identifier ~= CurrentEquipped.Identifier then
                v1 = v3.Slot;
                v2 = i;
                break;
            end;
        end;
    end;

    if v1 and v2 then
        InventoryController.equip(v1, v2);
    end;
end;

return table.freeze({
    Name = "Last Weapon Used",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p3: any, p4: userdata) -- Line: 47, Name: onInput
        -- upvalues: LocalPlayer (copy), CaseSceneController (copy), BlackMarketSceneController (copy), InspectController (copy), InventoryController (copy), equipFallback (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or p3 ~= Enum.UserInputState.Begin then
            return;
        end;

        if CaseSceneController.IsActive() or (BlackMarketSceneController.IsActive() or InspectController.IsActive()) then
            return;
        end;

        local PreviousEquipped = InventoryController.getPreviousEquipped();

        if not PreviousEquipped then
            equipFallback();

            return;
        end;

        local _, v5, v6 = InventoryController.getInventoryItemFromLoadout(PreviousEquipped.Identifier);

        if v5 and v6 then
            InventoryController.equip(v5, v6);
        end;
    end
});