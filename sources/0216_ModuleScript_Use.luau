-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);

local function CountTargetGrenades(p1: table, p2: string) -- Line: 40
    local v3 = 0;

    for _, v in ipairs(p1) do
        if v.Name == p2 then
            v3 = v3 + 1;
        end;
    end;

    return v3;
end;

local function computePriority(p4: userdata, p5: userdata) -- Line: 53
    -- upvalues: CharacterResolver (copy)
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if not (LocalCharacter and LocalCharacter.PrimaryPart) then
        return false;
    end;

    if p4:GetAttribute("HoveringState") == "Hovering" then
        return true;
    end;

    if p5:GetAttribute("HoveringState") == "Hovering" then
        return false;
    end;

    if p4:GetAttribute("CanPickup") == false then
        return false;
    end;

    if p5:GetAttribute("CanPickup") == false then
        return true;
    end;

    if p4.PrimaryPart and p5.PrimaryPart then
        return (LocalCharacter.PrimaryPart.Position - p4.PrimaryPart.Position).Magnitude < (LocalCharacter.PrimaryPart.Position - p5.PrimaryPart.Position).Magnitude;
    end;

    return false;
end;

local function GetHoveredBreakableDoor() -- Line: 82
    -- upvalues: CenterScreenRaycast (copy), CollectionService (copy)
    local v6 = {};
    local v7 = CenterScreenRaycast.FindTaggedModelInSight("BreakableDoor", 8);

    if v7 and (v7:IsA("Model") and v7:GetAttribute("Destroyed") ~= true) then
        table.insert(v6, v7);

        for _, v in CollectionService:GetTagged("BreakableDoor") do
            if v ~= v7 and v:GetAttribute("Destroyed") ~= true then
                local BreakableDoorHingePivot = v7:FindFirstChild("BreakableDoorHingePivot");
                local BreakableDoorHingePivot2 = v:FindFirstChild("BreakableDoorHingePivot");

                if BreakableDoorHingePivot and (BreakableDoorHingePivot2 and (BreakableDoorHingePivot.Position - BreakableDoorHingePivot2.Position).Magnitude <= 20) then
                    table.insert(v6, v);
                end;
            end;
        end;
    end;

    return v6;
end;

local function isGrenadeLimitHit(p8: string) -- Line: 117
    -- upvalues: GetWeaponProperties (copy), NumberSlots (copy), InventoryController (copy), Grenades (copy)
    local v9 = GetWeaponProperties(p8);

    if not v9 then
        return false;
    end;

    local InventorySlot = InventoryController.getInventorySlot(NumberSlots[v9.Slot]);

    if not InventorySlot then
        return false;
    end;

    local v10 = #InventorySlot._items >= InventorySlot._settings._strict_slot_space;
    local v11 = 0;
    local v12 = true;

    for _, v in ipairs(InventorySlot._items) do
        if v.Name == p8 then
            v11 = v11 + 1;
        end;
    end;

    if Grenades[p8] <= v11 then
        v10 = v12;
    end;

    return v10;
end;

local function onUseBegin() -- Line: 133
    -- upvalues: CollectionService (copy), Router (copy), GetHoveredBreakableDoor (copy), Workspace (copy), CharacterController (copy), Remotes (copy), computePriority (copy), LocalPlayer (copy), Grenades (copy), isGrenadeLimitHit (copy), Skins (copy), Rarities (copy)
    local v13 = CollectionService:GetTagged("Bomb")[1];

    if v13 and (v13:GetAttribute("CanDefuse") and not (v13:GetAttribute("IsGettingDefused") or v13:GetAttribute("Defused"))) then
        Router.broadcastRouter("Start Defuse Bomb");

        return;
    end;

    local v14 = GetHoveredBreakableDoor();

    if #v14 > 0 then
        for _, v in v14 do
            if Workspace:GetAttribute("MovementV2DoorDebug") == true then
                print(string.format("[MovementV2.Door] use-send source=Use model=%s clientTime=%.6f", v:GetFullName(), Workspace:GetServerTimeNow()));
            end;

            local v15 = CharacterController.PredictDoorUse(v);
            local Send = Remotes.BreakableDoor.Use.Send;
            local v16 = {
                Model = v
            };
            local v17;

            if v15 == nil then
                v17 = nil;
            else
                v17 = v15.ServerTick;
            end;

            v16.ServerTick = v17;
            local v18;

            if v15 == nil then
                v18 = nil;
            else
                v18 = v15.TargetAngle;
            end;

            v16.TargetAngle = v18;
            local v19;

            if v15 == nil then
                v19 = nil;
            else
                v19 = v15.RequestId;
            end;

            v16.RequestId = v19;
            Send(v16);
        end;

        return;
    end;

    local Tagged = CollectionService:GetTagged("IsHoveringInteractable");

    if #Tagged == 0 then
        return;
    end;

    table.sort(Tagged, computePriority);
    local v20 = Tagged[1];
    local Attribute = v20:GetAttribute("Weapon");
    local Attribute2 = v20:GetAttribute("Skin");

    if Attribute == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
        return;
    end;

    if Grenades[Attribute] ~= nil and isGrenadeLimitHit(Attribute) then
        return;
    end;

    if not v20:GetAttribute("CanPickup") then
        return;
    end;

    local SkinInformation = Skins.GetSkinInformation(Attribute, Attribute2);

    if SkinInformation then
        local v21 = Rarities[SkinInformation.rarity];
        local math_floor_ret = math.floor(v21.Color.R * 255);
        local math_floor_ret2 = math.floor(v21.Color.G * 255);
        local math_floor_ret3 = math.floor(v21.Color.B * 255);
        Router.broadcastRouter("CreateNotification", "Item Picked Up", `You picked up a <font color = "rgb({math_floor_ret}, {math_floor_ret2}, {math_floor_ret3})"><b>{Attribute:find("Zeus") and "Taser" or Attribute} | {Attribute2}</b></font>`, 2);
    end;

    Remotes.Inventory.PickupWeapon.Send({
        AllowAutoEquip = true,
        Identity = v20.Name
    });
end;

return table.freeze({
    Category = "Weapon Keys",
    Group = "Gameplay",
    Name = "Use",

    Callback = function(p22: any, p23: userdata) -- Line: 210, Name: onInput
        -- upvalues: LocalPlayer (copy), CharacterResolver (copy), onUseBegin (copy), CollectionService (copy), Router (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if not CharacterResolver.getLocalCharacter() then
            return;
        end;

        if p22 == Enum.UserInputState.Begin then
            onUseBegin();

            return;
        end;

        if p22 == Enum.UserInputState.End then
            if CollectionService:GetTagged("Bomb")[1] and (LocalPlayer:GetAttribute("IsDefusingBomb") or LocalPlayer:GetAttribute("IsLocallyDefusingBomb")) then
                Router.broadcastRouter("Cancel Defuse Bomb");

                return;
            end;

            if LocalPlayer:GetAttribute("IsRescuingHostage") then
                Router.broadcastRouter("Cancel Rescue Hostage");
            end;
        end;
    end
});