-- ReplicatedStorage.Controllers.Observers.Game.Ping
-- Script path: ReplicatedStorage.Controllers.Observers.Game.Ping
-- Decompile time: 3.26 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local LocalPlayer = Players.LocalPlayer
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local u52 = {}

local function GetWeaponProperties(a1) -- Line: 46 -- upvalues: ReplicatedStorage (val) -- types: a1: string
    local v1 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(a1)
    if v1 and v1:IsA("ModuleScript") then
        local success, result = pcall(require, v1)
        if success and result then
            return result
        end
        return nil
    end
    return nil
end

local function UpdateVisibility(a1, a2) -- Line: 61
    -- upvalues: LocalPlayer (val), DataController (val)
    local Attribute = a2 or LocalPlayer:GetAttribute("Team")
    if not (DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") == "Disabled")
        and Attribute == a1.CurrentTeam then
        if a1.Model.Parent == nil and a1.OriginalParent then
            a1.Model.Parent = a1.OriginalParent
        end
        return
    end
    a1.Model.Parent = nil
end

local function UpdateAllMarkers(a1) -- Line: 71 -- upvalues: u52 (val), UpdateVisibility (val)
    for k, v in pairs(u52) do
        UpdateVisibility(v, a1)
    end
end

local function GetSpectatedTeam() -- Line: 77 -- upvalues: SpectateController (val), LocalPlayer (val)
    local v1 = SpectateController.GetPlayer()
    if v1 and v1 ~= LocalPlayer then
        return (v1:GetAttribute("Team"))
    end
    return nil
end

local function RefreshAllMarkers() -- Line: 85
    -- upvalues: SpectateController (val), LocalPlayer (val), u52 (val), UpdateVisibility (val)
    local v1 = SpectateController.GetPlayer()
    local v2 = if not v1 then nil else if v1 == LocalPlayer then nil else v1:GetAttribute("Team")
    for k, v in pairs(u52) do
        UpdateVisibility(v, v2)
    end
end

local function StyleBillboard(a1) -- Line: 92
    -- upvalues: Colors (val), Skins (val), ReplicatedStorage (val), Rarities (val)
    local v1 = Colors["Team Color"][a1.CurrentTeam]
    a1.Model.Name = a1.Identifier
    if not v1 then
        return
    end
    local BillboardGui = a1.Model:FindFirstChildOfClass("BillboardGui")
    if BillboardGui and BillboardGui:IsDescendantOf(workspace) then
        local v2
        local IsDanger = a1.IsDanger
        local v3 = false
        if typeof(a1.Weapon) == "string" then
            v3 = false
            if a1.Weapon ~= "" then
                v3 = false
                if typeof(a1.Skin) == "string" then
                    v3 = a1.Skin ~= ""
                end
            end
        end
        local v4 = not IsDanger and not v3
        BillboardGui.Info.Visible = v4
        v4 = IsDanger and not v3
        BillboardGui.Danger.Visible = v4
        BillboardGui.Weapon.Visible = v3
        if BillboardGui.Info.Visible then
            BillboardGui.Info.ImageColor3 = v1
            return
        end
        if not v3 then
            return
        end
        local Weapon_2 = a1.Weapon
        v4 = Skins.GetSkinInformation(Weapon_2, a1.Skin)
        local v5 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Weapon_2)
        if not v5 then
            v2 = nil
        elseif v5:IsA("ModuleScript") then
            local success, result = pcall(require, v5)
            v2 = if not success then nil else if not result then nil else result
        else
            v2 = nil
        end
        v5 = v4 and Rarities[v4.rarity]
        if v4 and v2 and v5 then
            BillboardGui.Weapon.Icon.ImageColor3 = v5.Color
            BillboardGui.Weapon.Icon.Image = v2.Icon
            return
        end
        BillboardGui.Weapon.Visible = false
        BillboardGui.Info.Visible = not IsDanger
        BillboardGui.Danger.Visible = IsDanger
        if BillboardGui.Info.Visible then
            BillboardGui.Info.ImageColor3 = v1
        end
        return
    end
end

local function CreatePositionPing(a1, a2) -- Line: 136
    -- upvalues: UpdateVisibility (val), SpectateController (val), LocalPlayer (val), StyleBillboard (val), u52 (val)
    local v1 = {
        Weapon = a1:GetAttribute("Weapon"),
        Skin = a1:GetAttribute("Skin"),
        Identifier = a2,
        CurrentTeam = a1:GetAttribute("Team"),
        IsDanger = a1:GetAttribute("IsDanger"),
        OriginalParent = a1.Parent,
        Model = a1,
    }
    local v2 = SpectateController.GetPlayer()
    UpdateVisibility(v1, if not v2 then nil else if v2 == LocalPlayer then nil else v2:GetAttribute("Team"))
    task.delay(0.016666666666666666, StyleBillboard, v1)
    u52[a2] = v1
    return function() -- Line: 150 -- upvalues: u52 (upval), a2 (val)
        u52[a2] = nil
    end
end

LocalPlayer.CharacterAdded:Connect(function() -- Line: 158 -- upvalues: u52 (val), UpdateVisibility (val)
    for k, v in pairs(u52) do
        UpdateVisibility(v, nil)
    end
end)
;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(RefreshAllMarkers)
DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Player Pings", RefreshAllMarkers)
SpectateController.ListenToSpectate:Connect(function(a1) -- Line: 163 -- upvalues: u52 (val), UpdateVisibility (val) -- types: a1: userdata?
    local Attribute = a1 and a1:GetAttribute("Team")
    for k, v in pairs(u52) do
        UpdateVisibility(v, Attribute)
    end
end)
return Observers.observeTag("PlayerPositionMarker", function(a1) -- Line: 170 -- upvalues: CreatePositionPing (val), HttpService (val) -- types: a1: userdata
    if a1:IsDescendantOf(workspace) then
        return (CreatePositionPing(a1, HttpService:GenerateGUID(false)))
    end
    return nil
end)