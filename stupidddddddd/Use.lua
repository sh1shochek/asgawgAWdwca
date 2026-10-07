-- ReplicatedStorage.Controllers.InputController.Actions.Use
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.Use
-- Decompile time: 3.59 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
require(script.Parent.Parent.Types)
local LocalPlayer = Players.LocalPlayer
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController)
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)

local function CountTargetGrenades(a1, a2) -- Line: 40 -- types: a1: table, a2: string
    local v1 = 0
    for i, v in ipairs(a1) do
        if v.Name == a2 then
            v1 = v1 + 1
        end
    end
    return v1
end

local function computePriority(a1, a2) -- Line: 53
    -- upvalues: CharacterResolver (val)
    local v1 = CharacterResolver.getLocalCharacter()
    if v1 and v1.PrimaryPart then
        if a1:GetAttribute("HoveringState") == "Hovering" then
            return true
        end
        if a2:GetAttribute("HoveringState") == "Hovering" or a1:GetAttribute("CanPickup") == false then
            return false
        end
        if a2:GetAttribute("CanPickup") == false then
            return true
        end
        local v2 = a1
        local v3 = a2
        if v2.PrimaryPart and v3.PrimaryPart then
            return (v1.PrimaryPart.Position - v2.PrimaryPart.Position).Magnitude < (v1.PrimaryPart.Position - v3.PrimaryPart.Position).Magnitude
        end
        return false
    end
    return false
end

local function GetHoveredBreakableDoor() -- Line: 82 -- upvalues: CenterScreenRaycast (val), CollectionService (val)
    local v1 = {}
    local v2 = CenterScreenRaycast.FindTaggedModelInSight("BreakableDoor", 8)
    if v2 and v2:IsA("Model") and v2:GetAttribute("Destroyed") ~= true then
        local BreakableDoorHingePivot, BreakableDoorHingePivot_2
        table.insert(v1, v2)
        for i, j in CollectionService:GetTagged("BreakableDoor") do
            if j ~= v2 and j:GetAttribute("Destroyed") ~= true then
                BreakableDoorHingePivot = v2:FindFirstChild("BreakableDoorHingePivot")
                BreakableDoorHingePivot_2 = j:FindFirstChild("BreakableDoorHingePivot")
                if BreakableDoorHingePivot
                    and BreakableDoorHingePivot_2
                    and not (20 < (BreakableDoorHingePivot.Position - BreakableDoorHingePivot_2.Position).Magnitude) then
                    table.insert(v1, j)
                end
            end
        end
    end
    return v1
end

local function isGrenadeLimitHit(a1) -- Line: 117
    -- upvalues: GetWeaponProperties (val), NumberSlots (val), InventoryController (val), Grenades (val)
    local v1 = GetWeaponProperties(a1)
    if not v1 then
        return false
    end
    local v2 = InventoryController.getInventorySlot(NumberSlots[v1.Slot])
    if not v2 then
        return false
    end
    local v3 = v2._settings._strict_slot_space <= #v2._items
    local v4 = true
    local v5 = 0
    for i, v in ipairs(v2._items) do
        if v.Name == a1 then
            v5 = v5 + 1
        end
    end
    if not (Grenades[a1] <= v5) then
        v4 = v3
    end
    return v4
end

local function onUseBegin() -- Line: 133
    -- upvalues: CollectionService (val), Router (val), GetHoveredBreakableDoor (val), Workspace (val)
    -- upvalues: CharacterController (val), Remotes (val), computePriority (val), LocalPlayer (val), Grenades (val)
    -- upvalues: isGrenadeLimitHit (val), Skins (val), Rarities (val)
    local v1, v2
    local v3 = CollectionService:GetTagged("Bomb")[1]
    if v3
        and v3:GetAttribute("CanDefuse")
        and not v3:GetAttribute("IsGettingDefused")
        and not v3:GetAttribute("Defused") then
        Router.broadcastRouter("Start Defuse Bomb")
        return
    end
    local v4 = GetHoveredBreakableDoor()
    if #v4 > 0 then
        v1 = nil
        local v5 = nil
        for i, j in v4, v1, v5 do
            if Workspace:GetAttribute("MovementV2DoorDebug") == true then
                print(string.format(
                    "[MovementV2.Door] use-send source=Use model=%s clientTime=%.6f",
                    j:GetFullName(),
                    Workspace:GetServerTimeNow()
                ))
            end
            v2 = CharacterController.PredictDoorUse(j)
            Remotes.BreakableDoor.Use.Send({
                Model = j,
                ServerTick = if v2 == nil then nil else v2.ServerTick,
                TargetAngle = if v2 == nil then nil else v2.TargetAngle,
                RequestId = if v2 == nil then nil else v2.RequestId,
            })
        end
        return
    end
    local Tagged = CollectionService:GetTagged("IsHoveringInteractable")
    if #Tagged == 0 then
        return
    end
    table.sort(Tagged, computePriority)
    v1 = Tagged[1]
    local Attribute = v1:GetAttribute("Weapon")
    local Attribute_2 = v1:GetAttribute("Skin")
    if Attribute == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
        return
    end
    if Grenades[Attribute] ~= nil and isGrenadeLimitHit(Attribute) then
        return
    end
    if not v1:GetAttribute("CanPickup") then
        return
    end
    local v6 = Skins.GetSkinInformation(Attribute, Attribute_2)
    if v6 then
        v2 = Rarities[v6.rarity]
        Router.broadcastRouter("CreateNotification", "Item Picked Up", ("You picked up a <font color = \"rgb(%*, %*, %*)\"><b>%* | %*</b></font>"):format(
            math.floor(v2.Color.R * 255),
            math.floor(v2.Color.G * 255),
            math.floor(v2.Color.B * 255),
            if not Attribute:find("Zeus") then Attribute else "Taser",
            Attribute_2
        ), 2)
    end
    Remotes.Inventory.PickupWeapon.Send({AllowAutoEquip = true, Identity = v1.Name})
end

return table.freeze({
    Category = "Weapon Keys",
    Group = "Gameplay",
    Name = "Use",
    Callback = function(a1, a2) -- Line: 210
        -- upvalues: LocalPlayer (val), CharacterResolver (val), onUseBegin (val), CollectionService (val), Router (val)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or not CharacterResolver.getLocalCharacter() then
            return
        end
        if a1 == Enum.UserInputState.Begin then
            onUseBegin()
            return
        end
        if a1 == Enum.UserInputState.End then
            if CollectionService:GetTagged("Bomb")[1] then
                if not LocalPlayer:GetAttribute("IsDefusingBomb")
                    and not LocalPlayer:GetAttribute("IsLocallyDefusingBomb") then
                    if LocalPlayer:GetAttribute("IsRescuingHostage") then
                        Router.broadcastRouter("Cancel Rescue Hostage")
                    end
                    return
                end
                Router.broadcastRouter("Cancel Defuse Bomb")
                return
            end
            if LocalPlayer:GetAttribute("IsRescuingHostage") then
                Router.broadcastRouter("Cancel Rescue Hostage")
            end
        end
    end,
})