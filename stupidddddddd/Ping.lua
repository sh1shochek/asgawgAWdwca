-- ReplicatedStorage.Controllers.InputController.Actions.Ping
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.Ping
-- Decompile time: 1.95 ms

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera
local u42 = 0
local u44 = RaycastParams.new()
u44.FilterType = Enum.RaycastFilterType.Exclude
u44.IgnoreWater = false

local function GetWeaponDataFromInstance(a1) -- Line: 42 -- upvalues: CollectionService (val) -- types: a1: userdata?
    local Attribute, Attribute_2
    local Parent = a1
    while Parent do
        if CollectionService:HasTag(Parent, "WeaponDropped") then
            Attribute = Parent:GetAttribute("Weapon")
            Attribute_2 = Parent:GetAttribute("Skin")
            if not Attribute or not Attribute_2 then
                break
            end
            return Attribute, Attribute_2, Parent.Name
        end
        Parent = Parent.Parent
    end
    return nil, nil, nil
end

local function GetRaycastResult(...) -- Line: 60 -- upvalues: CurrentCamera (val), u44 (val)
    local Instance
    local v1 = {CurrentCamera, ...}
    u44.FilterDescendantsInstances = v1
    local v2 = workspace:Raycast(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector * 1000, u44)
    while v2 do
        if not v2.Instance then
            break
        end
        Instance = v2.Instance
        if not Instance:IsA("BasePart") or Instance.Transparency <= 0.98 then
            break
        end
        table.insert(v1, Instance)
        u44.FilterDescendantsInstances = v1
        v2 = workspace:Raycast(v2.Position, CurrentCamera.CFrame.LookVector.Unit * (1000 - v2.Distance), u44)
    end
    return v2
end

return (table.freeze({
    Name = "Ping",
    Group = "Gameplay",
    Category = "UI Keys",
    Callback = function(a1) -- Line: 88
        -- upvalues: DataController (val), LocalPlayer (val), CharacterResolver (val), GetRaycastResult (val)
        -- upvalues: GetWeaponDataFromInstance (val), Remotes (val), u42 (ref)
        if workspace:GetAttribute("Gamemode") == "Deathmatch"
            or DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") == "Disabled" then
            return
        end
        if CharacterResolver.isAliveCharacter(CharacterResolver.getPlayerCharacter(LocalPlayer))
            and a1 == Enum.UserInputState.Begin then
            local v1 = GetRaycastResult(CharacterResolver.getLocalCharacter())
            if not v1 then
                return
            end
            local v2, v3, v4 = GetWeaponDataFromInstance(v1.Instance)
            if not v2 or not v3 or not v4 then
                Remotes.Ping.CreatePlayerPositionPing.Send({IsDanger = tick() - u42 < 0.5, Position = v1.Position})
            else
                Remotes.Ping.CreatePlayerPositionPing.Send({
                    IsDanger = false,
                    Position = v1.Position,
                    WeaponIdentity = v4,
                    WeaponName = v2,
                    WeaponSkin = v3,
                })
            end
            u42 = tick()
            return
        end
    end,
}))