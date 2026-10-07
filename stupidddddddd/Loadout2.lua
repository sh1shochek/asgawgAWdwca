-- ReplicatedStorage.Interface.Screens.Menu.Loadout
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Loadout
-- Decompile time: 82.45 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation)
local Router = require(ReplicatedStorage.Database.Security.Router)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local ItemEquipment = require(ReplicatedStorage.Components.Common.ItemEquipment)
local CalculateGridRenderCount = require(ReplicatedStorage.Components.Common.CalculateGridRenderCount)
local UpdateStatusFrame = ItemEquipment.UpdateStatusFrame
local IsEquippedOnTeam = ItemEquipment.IsEquippedOnTeam
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local UseItemFrame = require(script.Parent.UseItemFrame)
local ItemIcon = require(script.ItemIcon)
local Sort = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local WeaponCategories = require(ReplicatedStorage.Database.Custom.GameStats.WeaponCategories)
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber)
local u159 = "Counter-Terrorists"
local u160 = nil
local u161 = "Newest"
local u162 = false
local u163 = nil
local u164 = nil
local u165 = false
local u166 = nil
local u167 = nil
local u168 = nil
local u169 = nil
local u170 = nil
local u171 = nil
local u172 = nil
local u173 = nil
local u174 = false
local u175 = nil
local u176 = nil
local u177 = false
local u178 = false
local u179 = false
local u180 = nil
local u181 = 0
local u182 = 0
local u183 = false
local u184 = 0
local u185 = nil
local u186 = nil
local u187 = nil
local u188 = {}
local u189 = {}
local u190 = 0
local u191 = false
local u192 = false
local u196 = UDim2.fromScale(0.2, 0.2)
local u200 = Vector2.new(0, 0)
local u205 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u206 = {Pistol = "Pistols", SMG = "Mid Tier", Heavy = "Mid Tier", Rifle = "Rifles"}
local u211 = {
    ["Incendiary Grenade"] = true,
    ["Decoy Grenade"] = true,
    ["Smoke Grenade"] = true,
    ["HE Grenade"] = true,
    Flashbang = true,
    Molotov = true,
}
local u218 = {
    Charm = true,
    ["Charm Capsule"] = true,
    Sticker = true,
    ["Sticker Capsule"] = true,
    Grenade = true,
    Case = true,
    Package = true,
    Booth = true,
}
local u227 = {
    Glove = "Equipped Gloves",
    Melee = "Equipped Melee",
    ["Zeus x27"] = "Equipped Zeus x27",
    Badge = "Equipped Badge",
    ["Music Kit"] = "Equipped Music Kit",
    Graffiti = "Equipped Graffiti",
}
local u234 = {
    ["Equipped Gloves"] = "Gloves",
    ["Equipped Melee"] = "Melee",
    ["Equipped Zeus x27"] = "Zeus",
    ["Equipped Badge"] = "Badge",
    ["Equipped Music Kit"] = "Music Kit",
    ["Equipped Graffiti"] = "Spray",
}
local u241 = {"Melee", "Gloves", "Zeus", "Badge", "Music Kit", "Spray"}
local u248 = {"Badge", "Gloves", "Melee", "Music Kit", "Spray", "Zeus"}
local u255 = {
    Melee = "Melee",
    Gloves = "Glove",
    Badge = "Badge",
    Zeus = "Zeus x27",
    ["Music Kit"] = "Music Kit",
    Spray = "Graffiti",
}
local u262 = {
    Weapon = true,
    Melee = true,
    Glove = true,
    ["Zeus x27"] = true,
    Badge = true,
    Charm = true,
}

local function CanInspectItem(a1) -- Line: 216 -- upvalues: u262 (val)
    local v1 = false
    if a1 ~= nil then
        v1 = u262[a1.Type] == true
    end
    return v1
end

local u270 = {Melee = "Melee", Gloves = "Glove"}
local u271 = {"ButtonCT", "ButtonT"}
local u274 = {Terrorists = {"Glock-18"}, ["Counter-Terrorists"] = {"USP-S", "P2000"}}
local u280 = nil

local function GetTeamFrame(a1) -- Line: 241 -- upvalues: u280 (ref) -- types: a1: string
    local v1 = u280.Container.Teams:FindFirstChild(a1)
    local v2 = ("[Loadout] Missing %* team panel"):format(a1)
    assert(v1 and v1:IsA("Frame"), v2)
    return v1
end

local function ClearFrame(a1, a2) -- Line: 247 -- types: a2: table
    for i, v in ipairs(a1:GetChildren()) do
        if not table.find(a2, v.Name) then
            v:Destroy()
        end
    end
end

local u283 = {"Charm", "Inspect", "ReplaceCT", "ReplaceT", "Unlock"}

local function GetVisibleInformationFrameButtons() -- Line: 260 -- upvalues: u283 (val), u187 (ref)
    local v1
    local v2 = {}
    for i, j in u283 do
        v1 = u187[j]
        if v1 and v1.Visible then
            table.insert(v2, v1)
        end
    end
    local QuickUnlock = u187:FindFirstChild("QuickUnlock")
    if QuickUnlock and QuickUnlock.Visible then
        table.insert(v2, QuickUnlock)
    end
    return v2
end

local function v1() -- Line: 275 -- upvalues: u187 (ref), GetVisibleInformationFrameButtons (val)
    local v1 = false
    if u187 ~= nil then
        v1 = #GetVisibleInformationFrameButtons() > 0
    end
    return v1
end

local function v2(a1) -- Line: 279
    local Charm = a1.Charm
    local v1 = false
    if Charm ~= nil then
        v1 = false
        if Charm ~= false then
            v1 = true
            if type(Charm) ~= "string" then
                v1 = true
                if Charm ~= true then
                    v1 = type(Charm) == "table"
                end
            end
        end
    end
    return v1
end

local function FindWeaponSlotOnTeam(a1, a2, a3) -- Line: 284
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = DataController.Get(LocalPlayer, "Loadout")
    local v2 = DataController.Get(LocalPlayer, "Inventory")
    if v1 and v2 then
        local v3 = v1[a2]
        if v3 and v3.Loadout and v3.Loadout[a3] then
            for i, v in ipairs(v3.Loadout[a3].Options) do
                if v and v ~= "" then
                    for i2, i3 in ipairs(v2) do
                        if i3._id == v and i3.Name == a1 then
                            return i
                        end
                    end
                end
            end
            return nil
        end
        return nil
    end
    return nil
end

local function ReplaceItemOnTeam(a1, a2) -- Line: 309
    -- upvalues: GetWeaponProperties (val), u206 (val), FindWeaponSlotOnTeam (val), Remotes (val), u227 (val)
    if a1.Type == "Weapon" then
        local v1
        local success, result = pcall(GetWeaponProperties, a1.Name)
        if not (if not success then nil else if not result then nil else if not result.Type then nil else u206[result.Type]) then
            return
        end
        Remotes.Inventory.EquipLoadoutSkin.Send({
            Type = v1,
            Slot = (FindWeaponSlotOnTeam(a1.Name, a2, v1) or 1) - 1,
            Team = a2,
            Identifier = a1._id,
        })
        return
    end
    if a1.Type == "Melee" then
        if a1.Name == "CT Knife" and a2 == "Terrorists" then
            return
        end
        if a1.Name == "T Knife" and a2 == "Counter-Terrorists" then
            return
        end
    end
    local v2 = u227[a1.Type]
    if v2 then
        Remotes.Inventory.EquipSpecialItem.Send({Identifier = a1._id, Path = v2, Team = a2})
    end
end

function u0.SetupInformationFrameNavigation() -- Line: 348
    -- upvalues: u187 (ref), GetVisibleInformationFrameButtons (val)
    local v1
    if not u187 then
        return
    end
    local v2 = GetVisibleInformationFrameButtons()
    table.sort(v2, function(a1, a2) -- Line: 354
        return a1.LayoutOrder < a2.LayoutOrder
    end)
    for i, v in ipairs(v2) do
        v1 = i > 1 and i - 1 or #v2
        v.NextSelectionUp = v2[v1]
        v1 = i < #v2 and i + 1 or 1
        v.NextSelectionDown = v2[v1]
        v.NextSelectionLeft = nil
        v.NextSelectionRight = nil
    end
end

function u0.SelectFirstInformationFrameButton() -- Line: 366
    -- upvalues: u187 (ref), u0 (val), GetVisibleInformationFrameButtons (val), GuiService (val)
    if u187 and u187.Visible then
        u0.SetupInformationFrameNavigation()
        local v1 = GetVisibleInformationFrameButtons()[1]
        if v1 then
            GuiService.SelectedObject = v1
        end
        return
    end
end

function u0.SetupInformationFrame(a1) -- Line: 379
    -- upvalues: Profiler (val), u187 (ref), u262 (val), GetWeaponProperties (val), IsEquippedOnTeam (val)
    local v1, v2, v3, v4, v5, v6
    Profiler.mark("UI.Loadout.SetupInformationFrame")
    local v7 = a1.Type == "Weapon"
    local v8 = a1.Type == "Melee"
    local v9 = a1.Type == "Glove"
    local v10 = a1.Type == "Badge"
    local v11 = a1.Type == "Zeus x27"
    local Inspect = u187.Inspect
    local v12 = false
    if a1 ~= nil then
        v12 = u262[a1.Type] == true
    end
    Inspect.Visible = v12
    if u187.Unlock then
        local Unlock = u187.Unlock
        v12 = true
        if a1.Type ~= "Case" then
            v12 = a1.Type == "Package"
        end
        Unlock.Visible = v12
    end
    if u187.Loadout then
        u187.Loadout.Visible = false
    end
    local QuickUnlock = u187:FindFirstChild("QuickUnlock")
    if QuickUnlock then
        QuickUnlock.Visible = false
    end
    local UnlockDivider = u187:FindFirstChild("UnlockDivider")
    if UnlockDivider then
        UnlockDivider.Visible = false
    end
    local v13 = v7 or v11 or a1.Type == "Charm"
    if u187.Charm then
        u187.Charm.Visible = v13
        if v13 then
            local TextLabel = u187.Charm:FindFirstChildWhichIsA("TextLabel", true)
            if TextLabel then
                if a1.Type ~= "Charm" then
                    local Charm = a1.Charm
                    local v14 = false
                    if Charm ~= nil then
                        v14 = false
                        if Charm ~= false then
                            v14 = true
                            if type(Charm) ~= "string" then
                                v14 = true
                                if Charm ~= true then
                                    v14 = type(Charm) == "table"
                                end
                            end
                        end
                    end
                    TextLabel.Text = if not v14 then "Attach Charm" else "Detach Charm"
                else
                    TextLabel.Text = "Attach to Weapon"
                end
            end
        end
    end
    local u169 = false
    local u173 = false

    local function applyTeamRestriction(a1) -- Line: 424 -- upvalues: u169 (ref), u173 (ref) -- types: a1: string?
        local v1 = true
        if a1 ~= "Both" then
            v1 = a1 == "Counter-Terrorists"
        end
        u169 = v1
        v1 = true
        if a1 ~= "Both" then
            v1 = a1 == "Terrorists"
        end
        u173 = v1
    end

    if v7 then
        local success, result = pcall(GetWeaponProperties, a1.Name)
        if success and result then
            local Team = result.Team
            v3 = true
            if Team ~= "Both" then
                v3 = Team == "Counter-Terrorists"
            end
            u169 = v3
            v3 = true
            if Team ~= "Both" then
                v3 = Team == "Terrorists"
            end
            u173 = v3
        end
    elseif v8 then
        u169 = a1.Name ~= "T Knife"
        u173 = a1.Name ~= "CT Knife"
    elseif v9 then
        v1 = GetWeaponProperties(a1.Name)
        if v1 then
            local Team_2 = v1.Team
            v2 = true
            if Team_2 ~= "Both" then
                v2 = Team_2 == "Counter-Terrorists"
            end
            u169 = v2
            v2 = true
            if Team_2 ~= "Both" then
                v2 = Team_2 == "Terrorists"
            end
            u173 = v2
        end
    elseif v10 or v11 then
        u169 = true
        u173 = true
    end
    v1 = IsEquippedOnTeam(a1._id, "Counter-Terrorists")
    local v15 = IsEquippedOnTeam(a1._id, "Terrorists")
    v2 = v7 or v8 or v9 or v10 or v11
    if u187.ReplaceCT then
        v4 = v2 and u169 and not v1
        u187.ReplaceCT.Visible = v4
    end
    if u187.ReplaceT then
        v4 = v2 and u173 and not v15
        u187.ReplaceT.Visible = v4
    end
    v3 = {
        {dividerName = "CharmDivider", action = u187.Charm},
        {dividerName = "InspectDivider", action = u187.Inspect},
        {dividerName = "ReplaceCTDivider", action = u187.ReplaceCT},
        {dividerName = "ReplaceTDivider", action = u187.ReplaceT},
        {dividerName = "LoadoutDivider", action = u187.Loadout},
    }
    v4 = {UnlockDivider = true}
    for i, v in ipairs(v3) do
        v4[v.dividerName] = true
    end
    for i2, i3 in ipairs(v3) do
        v5 = u187:FindFirstChild(i3.dividerName)
        if v5 and i3.action then
            v6 = false
            if i3.action.Visible then
                for i4, j in ipairs(u187:GetChildren()) do
                    if not v4[j.Name] and j ~= v5 and j ~= i3.action then
                        if not j:IsA("Frame") and not j:IsA("TextButton") then
                            continue
                        end
                        if j.LayoutOrder < v5.LayoutOrder and j.Visible then
                            v6 = true
                            break
                        end
                    end
                end
            end
            v5.Visible = v6
        end
    end
end

local function PositionInformationFrame(a1, a2) -- Line: 497
    -- upvalues: u187 (ref), UserInputService (val), Mouse (val)
    local AbsolutePosition_2, AbsoluteSize_2, v1, v2
    local Parent = u187.Parent.Parent
    local AbsolutePosition = Parent.AbsolutePosition
    local AbsoluteSize = Parent.AbsoluteSize
    local v3 = (UserInputService:GetLastInputType()) == Enum.UserInputType.Gamepad1
    local X = nil
    local Y = nil
    if v3 then
        if a1 then
            AbsolutePosition_2 = a1.AbsolutePosition
            AbsoluteSize_2 = a1.AbsoluteSize
            X = AbsolutePosition_2.X + AbsoluteSize_2.X / 2
            Y = AbsolutePosition_2.Y + AbsoluteSize_2.Y / 2
        end
    elseif not a2 then
        X = Mouse.X
        Y = Mouse.Y
    elseif a1 then
        AbsolutePosition_2 = a1.AbsolutePosition
        AbsoluteSize_2 = a1.AbsoluteSize
        X = AbsolutePosition_2.X + AbsoluteSize_2.X / 2
        Y = AbsolutePosition_2.Y + AbsoluteSize_2.Y / 2
    end
    if not X or not Y then
        v1 = 0.5
        v2 = 0.5
    else
        v1 = (X - AbsolutePosition.X) / AbsoluteSize.X
        v2 = (Y - AbsolutePosition.Y) / AbsoluteSize.Y + u187.Size.Y.Scale / 2
        local v4 = 1 - v1
        v1 = if not (u187.Size.X.Scale + 0.01 <= v4) then v1 - u187.Size.X.Scale / 2 - 0.01 else v1 + u187.Size.X.Scale / 2 + 0.01
    end
    u187.Position = UDim2.fromScale(v1, v2)
end

local function ShowContextMenu(a1, a2, a3, a4) -- Line: 535
    -- upvalues: DataController (val), LocalPlayer (val), u185 (ref), u186 (ref), u187 (ref), Router (val), u0 (val)
    -- upvalues: GetVisibleInformationFrameButtons (val), PositionInformationFrame (val), Profiler (val)
    local v1 = DataController.Get(LocalPlayer, "Inventory")
    if v1 then
        for i, v in ipairs(v1) do
            if v._id == a1._id then
                a1 = v
                break
            end
        end
    end
    u185 = a1._id
    u186 = a3
    if not u187 then
        return
    end
    Router.broadcastRouter("RunInterfaceSound", "UI Click")
    u0.SetupInformationFrame(a1)
    local v2 = false
    if u187 ~= nil then
        v2 = #GetVisibleInformationFrameButtons() > 0
    end
    if not v2 then
        u187.Visible = false
        u185 = nil
        u186 = nil
        return
    end
    if not a4 then
        u187.Visible = not u187.Visible
    else
        u187.Visible = true
    end
    if u187.Visible then
        PositionInformationFrame(a3, a4)
        Profiler.defer("UI.Loadout.InformationNavigationDeferred", function() -- Line: 577 -- upvalues: u0 (upval), a4 (val)
            u0.SetupInformationFrameNavigation()
            if a4 then
                u0.SelectFirstInformationFrameButton()
            end
        end)
        return
    end
    u185 = nil
    u186 = nil
end

local function HideContextMenu() -- Line: 591 -- upvalues: u187 (ref), u185 (ref), u186 (ref)
    if u187 then
        u187.Visible = false
    end
    u185 = nil
    u186 = nil
end

local function GetInventoryItemFromIdentifier(a1) -- Line: 602
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = ipairs
    for i, v in v1(DataController.Get(LocalPlayer, "Inventory") or {}) do
        if v._id == a1 then
            return v
        end
    end
    return nil
end

local function GetCurrentInventoryItem() -- Line: 611 -- upvalues: u185 (ref), GetInventoryItemFromIdentifier (val)
    if u185 then
        return (GetInventoryItemFromIdentifier(u185))
    end
    return nil
end

local u302 = nil
Collections.ObserveAvailableCollections(function(a1) -- Line: 618 -- upvalues: u302 (ref)
    u302 = a1
end)

local function v3(a1, a2) -- Line: 624 -- upvalues: GetWeaponProperties (val) -- types: a1: string?
    if a1 and type(a1) == "string" and a1 ~= "" then
        local success, result = pcall(GetWeaponProperties, a1)
        local v1 = success
        if v1 then
            v1 = false
            if result ~= nil then
                v1 = false
                if result.Team ~= nil then
                    v1 = true
                    if result.Team ~= "Both" then
                        v1 = result.Team == a2
                    end
                end
            end
        end
        return v1
    end
    return false
end

local function GetSortedLoadoutItemIds() -- Line: 636
    -- upvalues: DataController (val), LocalPlayer (val), Sort (val), u161 (ref), u302 (ref), u218 (val), u211 (val)
    -- upvalues: GetWeaponProperties (val), u159 (ref), u160 (ref), u163 (ref), u255 (val), u270 (val), u164 (ref)
    -- upvalues: u162 (ref)
    local Name_5, result_4, result_5, success_4, success_5, v1, v2, v3
    local v4 = DataController.Get(LocalPlayer, "Inventory")
    if not v4 then
        return {}
    end
    local u363 = Sort.GetSortComparisonFunction(u161, LocalPlayer, function() -- Line: 642 -- upvalues: u302 (upval)
        return u302
    end)
    local v5 = {}
    local v6 = {}
    for i, v in ipairs(v4) do
        if v
            and v._id
            and not v5[v._id]
            and not u218[v.Type]
            and not u211[v.Name]
            and v.Name
            and type(v.Name) == "string" then
            success_4, result_4 = pcall(GetWeaponProperties, v.Name)
            if not success_4 or not result_4 or not result_4.Team then
                v5[v._id] = true
                table.insert(v6, v)
            else
                Name_5 = v.Name
                v2 = u159
                if not Name_5 or type(Name_5) ~= "string" then
                    v1 = false
                elseif Name_5 ~= "" then
                    success_5, result_5 = pcall(GetWeaponProperties, Name_5)
                    v1 = success_5
                    if v1 then
                        v1 = false
                        if result_5 ~= nil then
                            v1 = false
                            if result_5.Team ~= nil then
                                v1 = true
                                if result_5.Team ~= "Both" then
                                    v1 = result_5.Team == v2
                                end
                            end
                        end
                    end
                else
                    v1 = false
                end
                if v1 then
                    v5[v._id] = true
                    table.insert(v6, v)
                end
            end
        end
    end
    if u160 then
        local result, success
        v3 = {}
        for i2, i3 in ipairs(v6) do
            if i3.Type ~= "Case"
                and i3.Type ~= "Package"
                and i3.Type ~= "Charm Capsule"
                and i3.Type ~= "Sticker Capsule"
                and i3.Name
                and type(i3.Name) == "string" then
                success, result = pcall(GetWeaponProperties, i3.Name)
                if success and result and result.Type == u160 then
                    table.insert(v3, i3)
                end
            end
        end
        v6 = v3
    end
    if u163 then
        local Name_2, Name_3, result_2, result_3, success_2, success_3, v7, v8, v9
        v3 = u255[u163.sidebarName]
        local v10 = u270[u163.sidebarName]
        local v11 = if u163.teamKey ~= "CT" then "Terrorists" else "Counter-Terrorists"
        local v12 = {}
        for i4, j in ipairs(v6) do
            if j.Type == v3 then
                success_2, result_2 = pcall(GetWeaponProperties, j.Name)
                if not v10 or not success_2 or not result_2 or not result_2.Class or result_2.Class == v10 then
                    Name_2 = j.Name
                    v7 = if v11 ~= "Counter-Terrorists" then "CT" else "T"
                    if Name_2 ~= ("%* Knife"):format(v7) and Name_2 ~= ("%* Gloves"):format(v7) then
                        v8 = not success_2 or not result_2 or not result_2.Team
                        Name_3 = j.Name
                        if not Name_3 or type(Name_3) ~= "string" then
                            v9 = false
                        elseif Name_3 ~= "" then
                            success_3, result_3 = pcall(GetWeaponProperties, Name_3)
                            v9 = success_3
                            if v9 then
                                v9 = false
                                if result_3 ~= nil then
                                    v9 = false
                                    if result_3.Team ~= nil then
                                        v9 = true
                                        if result_3.Team ~= "Both" then
                                            v9 = result_3.Team == v11
                                        end
                                    end
                                end
                            end
                        else
                            v9 = false
                        end
                        if v8 or v9 then
                            table.insert(v12, j)
                        end
                    end
                end
            end
        end
        v6 = v12
    end
    if u164 then
        local v13, v14
        v3 = {}
        for i5, k in ipairs(v6) do
            v13 = k.Name == u164.weaponName
            v14 = true
            if u164.skinName ~= nil then
                v14 = k.Skin == u164.skinName
            end
            if v13 and v14 then
                table.insert(v3, k)
            end
        end
        v6 = v3
    end
    if u363 then
        if not u162 then
            table.sort(v6, u363)
        else
            table.sort(v6, function(a1, a2) -- Line: 741 -- upvalues: u363 (val)
                local v1, v2 = u363(a1, a2)
                if v2 then
                    return v1
                end
                return u363(a2, a1)
            end)
        end
    end
    v3 = table.create(#v6)
    for i6, n in ipairs(v6) do
        table.insert(v3, n._id)
    end
    return v3
end

local function CreateMissingItemTemplates(a1, a2, a3) -- Line: 766
    -- upvalues: u189 (ref), GetInventoryItemFromIdentifier (val), u0 (val)
    local v1, v2
    for i = a2, a3 do
        v1 = u189[i]
        v2 = v1 and GetInventoryItemFromIdentifier(v1)
        if v2 and not v3:FindFirstChild(v1) then
            u0.CreateItemTemplate(v2)
        end
    end
end

local function ApplySortedLayoutOrder(a1) -- Line: 776 -- upvalues: u189 (ref) -- types: a1: userdata
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("ImageButton")
            and v.Name ~= "UIGridLayout"
            and v.Name ~= "UIListLayout"
            and v.Name ~= "UIPadding" then
            for i2, i3 in ipairs(u189) do
                if i3 == v.Name then
                    v.LayoutOrder = i2
                    break
                end
            end
        end
    end
end

local function RenderLoadoutTemplates() -- Line: 794
    -- upvalues: Profiler (val), u280 (ref), u190 (ref), u189 (ref), CreateMissingItemTemplates (val)
    -- upvalues: ApplySortedLayoutOrder (val)
    Profiler.mark("UI.Loadout.RenderLoadoutTemplates")
    if not u280 then
        return
    end
    local Container = u280.Container.List.Container
    local v1 = math.min(u190 + 25, #u189)
    CreateMissingItemTemplates(Container, u190 + 1, v1)
    u190 = v1
    ApplySortedLayoutOrder(Container)
end

local function OnLoadoutScrollPositionChanged() -- Line: 809
    -- upvalues: u280 (ref), u190 (ref), u189 (ref), Profiler (val), CreateMissingItemTemplates (val)
    -- upvalues: ApplySortedLayoutOrder (val)
    if not u280 then
        return
    end
    local Container = u280.Container.List.Container
    local Y = Container.CanvasPosition.Y
    local v1 = Container.AbsoluteCanvasSize.Y - Container.AbsoluteSize.Y
    if v1 > 0 and u190 < #u189 and v1 - Y < 200 then
        Profiler.mark("UI.Loadout.RenderLoadoutTemplates")
        if not u280 then
            return
        end
        local Container_2 = u280.Container.List.Container
        local v2 = math.min(u190 + 25, #u189)
        CreateMissingItemTemplates(Container_2, u190 + 1, v2)
        u190 = v2
        ApplySortedLayoutOrder(Container_2)
    end
end

local function CalculateLoadoutInitialRenderCount() -- Line: 828 -- upvalues: u280 (ref), CalculateGridRenderCount (val)
    if u280 and u280.Visible then
        return CalculateGridRenderCount(u280.Container.List.Container)
    end
    return 50
end

local function RenderInitialLoadoutTemplates() -- Line: 837
    -- upvalues: Profiler (val), u280 (ref), u190 (ref), CalculateGridRenderCount (val), u189 (ref)
    -- upvalues: CreateMissingItemTemplates (val), ApplySortedLayoutOrder (val), u191 (ref)
    Profiler.mark("UI.Loadout.RenderInitialLoadoutTemplates")
    if u280 and u280.Visible then
        local Container = u280.Container.List.Container
        u190 = 0
        local v1 = math.min(
            math.max(if not u280 then 50 else if u280.Visible then CalculateGridRenderCount(u280.Container.List.Container) else 50, 50),
            #u189
        )
        CreateMissingItemTemplates(Container, 1, v1)
        ApplySortedLayoutOrder(Container)
        u190 = v1
        u191 = false
        return
    end
end

local function UpdateLoadoutTemplates() -- Line: 858
    -- upvalues: Profiler (val), u280 (ref), u189 (ref), u190 (ref), u191 (ref), RenderInitialLoadoutTemplates (val)
    Profiler.mark("UI.Loadout.UpdateLoadoutTemplates")
    if not u280 then
        return
    end
    local Container = u280.Container.List.Container
    local v1 = {}
    for i, v in ipairs(u189) do
        v1[v] = true
    end
    for i2, i3 in ipairs(Container:GetChildren()) do
        if i3:IsA("ImageButton") and i3.Name ~= "UIGridLayout" and i3.Name ~= "UIPadding" and not v1[i3.Name] then
            i3:Destroy()
        end
    end
    u190 = 0
    u191 = true
    if u280.Visible then
        RenderInitialLoadoutTemplates()
    end
end

local function RefreshSortedList() -- Line: 891
    -- upvalues: u280 (ref), u192 (ref), u191 (ref), u189 (ref), GetSortedLoadoutItemIds (val)
    -- upvalues: UpdateLoadoutTemplates (val)
    if u280 and u280.Visible then
        u189 = GetSortedLoadoutItemIds()
        UpdateLoadoutTemplates()
        return
    end
    u192 = true
    u191 = true
end

local function AnimateSortButton(a1, a2) -- Line: 904
    -- upvalues: TweenService (val), u205 (val)
    TweenService:Create(a1, u205, {BackgroundTransparency = if not a2 then 1 else 0.85}):Play()
end

local function FadeCategoryLabels(a1, a2) -- Line: 913
    -- upvalues: TweenService (val)
    local Price, WeaponName
    local v1 = if not a2 then 1 else 0
    local v2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("Frame") and v:FindFirstChild("Price") and v:FindFirstChild("WeaponName") then
            Price = v:FindFirstChild("Price")
            WeaponName = v:FindFirstChild("WeaponName")
            TweenService:Create(Price, v2, {TextTransparency = v1}):Play()
            TweenService:Create(WeaponName, v2, {TextTransparency = v1}):Play()
        end
    end
end

local function CloseAllDropdowns() -- Line: 934 -- upvalues: u280 (ref)
    local DropdownContent = u280.Container.List.Top.Filter.DropdownContent
    local DropdownContent_2 = u280.Container.List.Top.Weapon.DropdownContent
    DropdownContent.Visible = false
    DropdownContent_2.Visible = false
end

local function UpdateResetButtonVisibility() -- Line: 944 -- upvalues: u280 (ref), u160 (ref), u163 (ref)
    local Reset = u280.Container.List.Top:FindFirstChild("Reset")
    if Reset then
        local v1 = true
        if u160 == nil then
            v1 = true
            if u163 == nil then
                v1 = u280.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons"
            end
        end
        Reset.Visible = v1
    end
end

local function CreateDropdownOption(a1, a2, a3, a4, a5) -- Line: 957
    -- upvalues: ReplicatedStorage (val), TweenService (val), u205 (val)
    local SortingTemplate = ReplicatedStorage.Assets.UI.Loadout:FindFirstChild("SortingTemplate")
    if not SortingTemplate then
        return nil
    end
    local u16 = SortingTemplate:Clone()
    u16.Name = a2
    u16.LayoutOrder = a4
    u16.BackgroundTransparency = 1
    u16.Parent = a1
    local Frame = u16:FindFirstChild("Frame")
    if Frame then
        local TextButton = Frame:FindFirstChild("TextButton")
        if TextButton then
            TextButton.Text = a3
        end
        Frame.BackgroundTransparency = 1
        Frame.Active = false
    end
    u16.MouseEnter:Connect(function() -- Line: 988 -- upvalues: u16 (val), TweenService (upval), u205 (upval)
        TweenService:Create(u16, u205, {BackgroundTransparency = 0.85}):Play()
    end)
    u16.MouseLeave:Connect(function() -- Line: 991 -- upvalues: u16 (val), TweenService (upval), u205 (upval)
        TweenService:Create(u16, u205, {BackgroundTransparency = 1}):Play()
    end)
    u16.MouseButton1Click:Connect(a5)
    return u16
end

local function ClearDropdownOptions(a1) -- Line: 1001 -- types: a1: userdata
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
end

local function GetWeaponsInCategory(a1) -- Line: 1011
    -- upvalues: DataController (val), LocalPlayer (val), u218 (val), u211 (val), GetWeaponProperties (val)
    local result, success
    local v1 = DataController.Get(LocalPlayer, "Inventory")
    if not v1 then
        return {}
    end
    local v2 = {}
    local v3 = a1
    for i, v in ipairs(v1) do
        if not u218[v.Type] and not u211[v.Name] then
            success, result = pcall(GetWeaponProperties, v.Name)
            if success and result then
                if not v3 or result.Type == v3 then
                    v2[v.Name] = true
                end
            end
        end
    end
    local v4 = {}
    for k in pairs(v2) do
        table.insert(v4, k)
    end
    table.sort(v4)
    return v4
end

local function GetLoadoutCategoryForWeapon(a1) -- Line: 1042
    -- upvalues: GetWeaponProperties (val), u206 (val)
    local success, result = pcall(GetWeaponProperties, a1)
    if success and result and result.Type then
        return u206[result.Type]
    end
    return nil
end

local function IsValidStarterPistol(a1, a2) -- Line: 1052 -- upvalues: u274 (val) -- types: a1: string
    local v1 = u274[a2]
    if not v1 then
        return false
    end
    return table.find(v1, a1) ~= nil
end

local function IsMouseOverPlayerFrame(a1) -- Line: 1060 -- upvalues: u280 (ref), PlayerGui (val) -- types: a1: userdata
    local Teams = u280.Container.Teams
    for i, v in ipairs((PlayerGui:GetGuiObjectsAtPosition(a1.X, a1.Y))) do
        if v.Name ~= "DragIcon" then
            if v ~= Teams and not v:IsDescendantOf(Teams) then
                continue
            end
            return true
        end
    end
    return false
end

local function CreateDragIcon(a1) -- Line: 1077 -- upvalues: GetResolvedSkinInformation (val), Skins (val), u196 (val)
    local v1 = GetResolvedSkinInformation(a1.Name, a1.Skin)
    if not v1 then
        return nil
    end
    local imageAssetId = Skins.GetWearImageForFloat(v1, a1.Float or 0.9999) or v1.imageAssetId or ""
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "DragIcon"
    ImageLabel.Size = u196
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = imageAssetId
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = 100
    ImageLabel.Active = false
    return ImageLabel
end

local function CleanupPendingDrag() -- Line: 1104
    -- upvalues: u173 (ref), u171 (ref), u172 (ref), u174 (ref), u175 (ref)
    if u173 then
        u173:Disconnect()
        u173 = nil
    end
    u171 = nil
    u172 = nil
    u174 = false
    u175 = nil
end

local u328 = {}
u328["Counter-Terrorists"] = Color3.fromHex("5B9BFF")
u328.Terrorists = Color3.fromHex("E5B84C")
local u341 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local u342 = {}
local u343 = {}

local function AddDropOverlay(a1, a2) -- Line: 1140
    -- upvalues: u328 (val), u159 (ref), TweenService (val), u341 (val), u343 (val), u342 (val)
    if a1 and a1:IsA("GuiObject") then
        local Frame = Instance.new("Frame")
        Frame.Name = if not a2 then "DropDim" else "DropHighlight"
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.BorderSizePixel = 0
        Frame.Active = false
        Frame.Selectable = false
        Frame.Interactable = false
        Frame.ZIndex = 50
        if not a2 then
            Frame.BackgroundColor3 = Color3.new(0, 0, 0)
            Frame.BackgroundTransparency = 0.45
        else
            local v1 = u328[u159] or u328["Counter-Terrorists"]
            Frame.BackgroundColor3 = v1
            Frame.BackgroundTransparency = 0.85
            local UIStroke = Instance.new("UIStroke")
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Color = v1
            UIStroke.Thickness = 2
            UIStroke.Parent = Frame
            local v2 = TweenService:Create(UIStroke, u341, {Transparency = 0.6})
            v2:Play()
            table.insert(u343, v2)
        end
        Frame.Parent = a1
        table.insert(u342, Frame)
        return
    end
end

local function HideAllMoveFrames() -- Line: 1179 -- upvalues: u343 (val), u342 (val)
    for i, j in u343 do
        j:Cancel()
    end
    table.clear(u343)
    for k, n in u342 do
        n:Destroy()
    end
    table.clear(u342)
end

local function CleanupDrag() -- Line: 1193
    -- upvalues: u173 (ref), u171 (ref), u172 (ref), u174 (ref), u175 (ref), u170 (ref), u166 (ref), u165 (ref)
    -- upvalues: u167 (ref), u168 (ref), u169 (ref), HideAllMoveFrames (val), u183 (ref), u0 (val)
    if u173 then
        u173:Disconnect()
        u173 = nil
    end
    u171 = nil
    u172 = nil
    u174 = false
    u175 = nil
    if u170 then
        u170:Disconnect()
        u170 = nil
    end
    if u166 then
        u166:Destroy()
        u166 = nil
    end
    local v1 = u165
    u165 = false
    u167 = nil
    u168 = nil
    u169 = nil
    HideAllMoveFrames()
    if v1 and not u183 then
        u0.RefreshSelectedWeapon()
    end
end

local u347 = nil

local function ShowControllerClickShield() -- Line: 1228 -- upvalues: u347 (ref), PlayerGui (val)
    if u347 then
        return
    end
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LoadoutControllerClickShield"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = (if not MainGui then 0 else if not MainGui:IsA("ScreenGui") then 0 else MainGui.DisplayOrder) + 1
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "Sink"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton.Active = true
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.Parent = ScreenGui
    ScreenGui.Parent = PlayerGui
    u347 = ScreenGui
end

local function HideControllerClickShield() -- Line: 1254 -- upvalues: u347 (ref), u178 (ref)
    local u0 = u347
    if not u0 then
        return
    end
    task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u0 (val), u178 (upval)
        if u347 == u0 and not u178 then
            u347 = nil
            u0:Destroy()
        end
    end)
end

local function EnableVirtualCursor(a1) -- Line: 1275
    -- upvalues: u178 (ref), GuiService (val), GamepadNavigation (val), GamepadService (val)
    -- upvalues: ShowControllerClickShield (val)
    if u178 then
        return
    end
    u178 = true
    GuiService.AutoSelectGuiEnabled = false
    GuiService.SelectedObject = nil
    if a1 then
        GamepadNavigation.ScrollIntoView(a1)
    end
    pcall(function() -- Line: 1287 -- upvalues: GamepadService (upval), a1 (val)
        GamepadService:EnableGamepadCursor(a1)
    end)
    ShowControllerClickShield()
end

local function DisableVirtualCursor() -- Line: 1295
    -- upvalues: u178 (ref), GamepadService (val), GuiService (val), u347 (ref)
    if not u178 then
        return
    end
    u178 = false
    pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
        GamepadService:DisableGamepadCursor()
    end)
    GuiService.AutoSelectGuiEnabled = true
    local u7 = u347
    if not u7 then
        return
    end
    task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u7 (val), u178 (upval)
        if u347 == u7 and not u178 then
            u347 = nil
            u7:Destroy()
        end
    end)
end

local function CleanupControllerHeld(a1) -- Line: 1311
    -- upvalues: u180 (ref), CleanupDrag (val), u176 (ref), u179 (ref), u178 (ref), GamepadService (val)
    -- upvalues: GuiService (val), u347 (ref), HideAllMoveFrames (val), GamepadNavigation (val)
    local v1 = u180
    CleanupDrag()
    u176 = nil
    u180 = nil
    u179 = false
    if u178 then
        u178 = false
        pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
            GamepadService:DisableGamepadCursor()
        end)
        GuiService.AutoSelectGuiEnabled = true
        local u14 = u347
        if u14 then
            task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u14 (val), u178 (upval)
                if u347 == u14 and not u178 then
                    u347 = nil
                    u14:Destroy()
                end
            end)
        end
    end
    HideAllMoveFrames()
    if a1 and v1 and GamepadNavigation.IsUsable(v1) then
        GamepadNavigation.ScrollIntoView(v1)
        GuiService.SelectedObject = v1
    end
end

local function GetSlotIndexInList(a1, a2, a3) -- Line: 1331
    -- upvalues: DataController (val), LocalPlayer (val), u159 (ref)
    local v1 = DataController.Get(LocalPlayer, "Loadout")
    local v2 = v1 and v1[u159]
    local Loadout = v2 and v2.Loadout and v2.Loadout[a3]
    if Loadout then
        for i, v in ipairs(Loadout.Options) do
            if v == a1.Name then
                return i
            end
        end
    end
    local v3 = 0
    for i2, i3 in ipairs(a2:GetChildren()) do
        if i3:IsA("GuiObject") then
            v3 = v3 + 1
            if i3 == a1 then
                return v3
            end
        end
    end
    return 1
end

local function GetLoadoutSlotInfo(a1) -- Line: 1359 -- upvalues: GetSlotIndexInList (val) -- types: a1: userdata
    local Parent = a1.Parent
    if Parent and Parent:IsA("Frame") then
        local Parent_2 = Parent.Parent
        local Parent_3 = Parent_2
        if Parent_3 then
            Parent_3 = false
            if Parent_2.Name == "List" then
                Parent_3 = Parent_2.Parent
            end
        end
        if Parent_3 and Parent_3:IsA("Frame") then
            local Name = Parent_3.Name
            if Name ~= "Mid Tier" and Name ~= "Pistols" and Name ~= "Rifles" then
                return nil, nil
            end
            return Name, (GetSlotIndexInList(Parent, Parent_2, Name))
        end
        return nil, nil
    end
    return nil, nil
end

local function GetInventoryItemFromButton(a1) -- Line: 1385
    -- upvalues: GetInventoryItemFromIdentifier (val)
    if a1 and a1:IsA("ImageButton") then
        return (GetInventoryItemFromIdentifier(a1.Name))
    end
    return nil
end

local function GetEquippedItemFromButton(a1) -- Line: 1391
    -- upvalues: GetLoadoutSlotInfo (val), GetInventoryItemFromIdentifier (val)
    local Parent = a1.Parent
    if Parent and Parent:IsA("Frame") then
        local Name = Parent.Name
        local v1, v2 = GetLoadoutSlotInfo(a1)
        if v1 and v2 then
            return (GetInventoryItemFromIdentifier(Name)), v1, v2
        end
    end
    return nil, nil, nil
end

local u357 = {"Pistols", "Mid Tier", "Rifles"}

local function ShowGunSlotHighlights(a1) -- Line: 1411
    -- upvalues: u159 (ref), u280 (ref), u357 (val), GetSlotIndexInList (val), AddDropOverlay (val)
    local List, v1, v2, v3
    local v4 = if u159 ~= "Counter-Terrorists" then "T" else "CT"
    local v5 = u280.Container.Teams:FindFirstChild(v4)
    assert(v5 and v5:IsA("Frame"), (("[Loadout] Missing %* team panel"):format(v4)))
    local Guns = v5:FindFirstChild("Guns")
    if not Guns then
        return
    end
    local v6 = nil
    local v7 = nil
    for i, j in u357, v6, v7 do
        v3 = Guns:FindFirstChild(j)
        List = v3 and v3:FindFirstChild("List")
        if v3 and List then
            v1 = false
            for k, n in List:GetChildren() do
                if n:IsA("Frame") and n:FindFirstChild("Button") then
                    v2 = v8(j, (GetSlotIndexInList(n, List, j)))
                    v1 = v1 or v2
                    AddDropOverlay(n, v2)
                end
            end
            AddDropOverlay(v3:FindFirstChild("Title"), v1)
        end
    end
end

local function GetEquipmentSlotForItem(a1) -- Line: 1443
    -- upvalues: u227 (val), GetWeaponProperties (val), u234 (val), u159 (ref), u280 (ref)
    local v1 = u227[a1.Type]
    if not v1 then
        local success, result = pcall(GetWeaponProperties, a1.Name)
        local Class = success and result and result.Class
        v1 = if Class ~= "Melee" then if Class ~= "Glove" then nil else "Equipped Gloves" else "Equipped Melee"
    end
    local v2 = v1 and u234[v1]
    if not v2 then
        return nil
    end
    local v3 = if u159 ~= "Counter-Terrorists" then "T" else "CT"
    local v4 = u280.Container.Teams:FindFirstChild(v3)
    local v5 = ("[Loadout] Missing %* team panel"):format(v3)
    assert(v4 and v4:IsA("Frame"), v5)
    local Equipments = v4:FindFirstChild("Equipments")
    local v6 = Equipments and Equipments:FindFirstChild(v2)
    if v6 and v6:IsA("GuiObject") then
        return v6
    end
    return nil
end

local function ShowMoveFramesForItem(a1) -- Line: 1475
    -- upvalues: HideAllMoveFrames (val), GetEquipmentSlotForItem (val), u227 (val), AddDropOverlay (val), u159 (ref)
    -- upvalues: u280 (ref), ShowGunSlotHighlights (val), GetWeaponProperties (val), u206 (val), u274 (val)
    local u88, v1
    HideAllMoveFrames()
    local v2 = GetEquipmentSlotForItem(a1)
    local v3 = true
    if u227[a1.Type] == nil then
        v3 = v2 ~= nil
    end
    if v3 then
        AddDropOverlay(v2, true)
        local v4 = if u159 ~= "Counter-Terrorists" then "T" else "CT"
        local v5 = u280.Container.Teams:FindFirstChild(v4)
        v1 = ("[Loadout] Missing %* team panel"):format(v4)
        assert(v5 and v5:IsA("Frame"), v1)
        AddDropOverlay(v5:FindFirstChild("Viewport"), true)
        ShowGunSlotHighlights(function() -- Line: 1484
            return false
        end)
        return
    end
    local success, result = pcall(GetWeaponProperties, a1.Name)
    local u66 = if not success then nil else if not result then nil else if not result.Type then nil else u206[result.Type]
    if not u66 then
        return
    end
    local Name_2 = a1.Name
    local v6 = u159
    if not Name_2 or type(Name_2) ~= "string" then
        u88 = false
    elseif Name_2 ~= "" then
        local success_2, result_2 = pcall(GetWeaponProperties, Name_2)
        u88 = success_2
        if u88 then
            u88 = false
            if result_2 ~= nil then
                u88 = false
                if result_2.Team ~= nil then
                    u88 = true
                    if result_2.Team ~= "Both" then
                        u88 = result_2.Team == v6
                    end
                end
            end
        end
    else
        u88 = false
    end
    local Name_3 = a1.Name
    v1 = u274[u159]
    local u102 = if v1 then table.find(v1, Name_3) ~= nil else false
    ShowGunSlotHighlights(function(a1, a2) -- Line: 1497 -- upvalues: u88 (val), u66 (val), u102 (val) -- types: a1: string, a2: number
        if u88 and a1 == u66 then
            local v1 = false
            if a1 == "Pistols" then
                v1 = false
                if a2 == 1 then
                    v1 = not u102
                end
            end
            return not v1
        end
        return false
    end)
end

local u365 = nil

local function GetDropTargetCategory(a1) -- Line: 1515
    -- upvalues: u176 (ref), GetInventoryItemFromIdentifier (val), u168 (ref), GetWeaponProperties (val), u206 (val)
    -- upvalues: u280 (ref), PlayerGui (val), GetSlotIndexInList (val)
    local Parent, Parent_2, v1, v2
    local v3 = u176 and GetInventoryItemFromIdentifier(u176)
    local Name = u168 or v3 and v3.Name
    if not Name then
        return nil, nil
    end
    local success, result = pcall(GetWeaponProperties, Name)
    if not (if not success then nil else if not result then nil else if not result.Type then nil else u206[result.Type]) then
        return nil, nil
    end
    local Teams = u280.Container.Teams
    local v4 = false
    local v5 = nil
    for i, v in ipairs((PlayerGui:GetGuiObjectsAtPosition(a1.X, a1.Y))) do
        if v.Name ~= "DragIcon" then
            if v == Teams or v:IsDescendantOf(Teams) then
                v4 = true
            end
            if not v5 then
                v1 = v
                while v1 do
                    if v1 == Teams then
                        break
                    end
                    Parent = v1.Parent
                    if Parent and Parent.Name == "List" then
                        Parent_2 = Parent.Parent
                        if not Parent_2 or Parent_2.Name ~= v2 then
                            break
                        end
                        v5 = GetSlotIndexInList(v1, Parent, v2)
                        break
                    end
                    v1 = Parent
                end
            end
        end
    end
    if not v4 then
        return nil, nil
    end
    return v2, v5
end

local function GetCurrentCategoryOptions(a1) -- Line: 1568
    -- upvalues: DataController (val), LocalPlayer (val), u159 (ref)
    local v1 = DataController.Get(LocalPlayer, "Loadout")
    local v2 = v1 and v1[u159]
    if v2 and v2.Loadout and v2.Loadout[a1] then
        return v2.Loadout[a1].Options
    end
    return nil
end

local function IsItemEquippedInCategory(a1, a2) -- Line: 1577
    -- upvalues: DataController (val), LocalPlayer (val), u159 (ref)
    local v1 = ipairs
    local v2 = DataController.Get(LocalPlayer, "Loadout")
    local v3 = v2 and v2[u159]
    for i, v in v1((if not v3 then nil else if not v3.Loadout then nil else if v3.Loadout[a2] then v3.Loadout[a2].Options else nil) or {}) do
        if v == a1 then
            return true, i
        end
    end
    return false, nil
end

local function IsWeaponEquippedInCategory(a1, a2) -- Line: 1589
    -- upvalues: DataController (val), LocalPlayer (val), u159 (ref), GetInventoryItemFromIdentifier (val)
    local Options, v1
    local v2 = DataController.Get(LocalPlayer, "Loadout")
    local v3 = v2 and v2[u159]
    if not (if not v3 then nil else if not v3.Loadout then nil else if v3.Loadout[a2] then v3.Loadout[a2].Options else nil) then
        return false, nil, nil
    end
    for i, v in ipairs(Options) do
        if v and v ~= "" then
            v1 = GetInventoryItemFromIdentifier(v)
            if v1 and v1.Name == a1 then
                return true, i, v
            end
        end
    end
    return false, nil, nil
end

local function RefreshSelectedWeaponIfIdle() -- Line: 1613 -- upvalues: u165 (ref), u176 (ref), u0 (val)
    if not u165 and not u176 then
        u0.RefreshSelectedWeapon()
    end
end

local function SendEquipRequest(a1, a2) -- Line: 1620
    -- upvalues: u183 (ref), u184 (ref), u165 (ref), u176 (ref), u0 (val)
    if u183 then
        return false
    end
    u183 = true
    u184 = u184 + 1
    local u7 = u184
    a1.Send(a2)
    task.delay(5, function() -- Line: 1629 -- upvalues: u7 (val), u184 (upval), u183 (upval), u165 (upval), u176 (upval), u0 (upval)
        if u7 == u184 and u183 then
            u183 = false
            if not u165 and not u176 then
                u0.RefreshSelectedWeapon()
            end
            return
        end
    end)
    return true
end

local function EquipLoadoutSkin(a1, a2, a3) -- Line: 1640
    -- upvalues: Remotes (val), u159 (ref), u183 (ref), u184 (ref), u165 (ref), u176 (ref), u0 (val)
    local EquipLoadoutSkin = Remotes.Inventory.EquipLoadoutSkin
    local v1 = {Type = a1, Slot = a2 - 1, Team = u159, Identifier = a3}
    if u183 then
        return false
    end
    u183 = true
    u184 = u184 + 1
    local u14 = u184
    EquipLoadoutSkin.Send(v1)
    task.delay(5, function() -- Line: 1629 -- upvalues: u14 (val), u184 (upval), u183 (upval), u165 (upval), u176 (upval), u0 (upval)
        if u14 == u184 and u183 then
            u183 = false
            if not u165 and not u176 then
                u0.RefreshSelectedWeapon()
            end
            return
        end
    end)
    return true
end

local function SwapLoadoutSkins(a1, a2, a3) -- Line: 1649
    -- upvalues: Remotes (val), u159 (ref), u183 (ref), u184 (ref), u165 (ref), u176 (ref), u0 (val)
    local SwapLoadoutSkins = Remotes.Inventory.SwapLoadoutSkins
    local v1 = {Type = a1, SlotOne = a2 - 1, SlotTwo = a3 - 1, Team = u159}
    if u183 then
        return false
    end
    u183 = true
    u184 = u184 + 1
    local u15 = u184
    SwapLoadoutSkins.Send(v1)
    task.delay(5, function() -- Line: 1629 -- upvalues: u15 (val), u184 (upval), u183 (upval), u165 (upval), u176 (upval), u0 (upval)
        if u15 == u184 and u183 then
            u183 = false
            if not u165 and not u176 then
                u0.RefreshSelectedWeapon()
            end
            return
        end
    end)
    return true
end

local function EquipSpecialItem(a1, a2) -- Line: 1660
    -- upvalues: Remotes (val), u159 (ref), u183 (ref), u184 (ref), u165 (ref), u176 (ref), u0 (val)
    local EquipSpecialItem = Remotes.Inventory.EquipSpecialItem
    if u183 then
        return false
    end
    u183 = true
    u184 = u184 + 1
    local u12 = u184
    EquipSpecialItem.Send({Path = a1, Team = u159, Identifier = a2})
    task.delay(5, function() -- Line: 1629 -- upvalues: u12 (val), u184 (upval), u183 (upval), u165 (upval), u176 (upval), u0 (upval)
        if u12 == u184 and u183 then
            u183 = false
            if not u165 and not u176 then
                u0.RefreshSelectedWeapon()
            end
            return
        end
    end)
    return true
end

local function GetSpecialItemPathByClass(a1) -- Line: 1669 -- upvalues: GetWeaponProperties (val) -- types: a1: string
    local success, result = pcall(GetWeaponProperties, a1)
    local Class = success and result and result.Class
    if Class == "Melee" then
        return "Equipped Melee"
    end
    if Class == "Glove" then
        return "Equipped Gloves"
    end
    return nil
end

local function u377() -- Line: 1680
    -- upvalues: u280 (ref), u176 (ref), u180 (ref), CleanupDrag (val), u179 (ref), u178 (ref), GamepadService (val)
    -- upvalues: GuiService (val), u347 (ref), HideAllMoveFrames (val), GamepadNavigation (val)
    -- upvalues: CloseButtonRegistry (val)
    if u280 and u280.Visible then
        if u176 then
            local v1 = u180
            CleanupDrag()
            u176 = nil
            u180 = nil
            u179 = false
            if u178 then
                u178 = false
                pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
                    GamepadService:DisableGamepadCursor()
                end)
                GuiService.AutoSelectGuiEnabled = true
                local u17 = u347
                if u17 then
                    task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u17 (val), u178 (upval)
                        if u347 == u17 and not u178 then
                            u347 = nil
                            u17:Destroy()
                        end
                    end)
                end
            end
            HideAllMoveFrames()
            if v1 and GamepadNavigation.IsUsable(v1) then
                GamepadNavigation.ScrollIntoView(v1)
                GuiService.SelectedObject = v1
            end
            CloseButtonRegistry.MarkUsed()
        end
        return
    end
end

local function ConnectGamepadPickUp(a1) -- Line: 1696
    -- upvalues: u176 (ref), u183 (ref), u182 (ref), u365 (ref)
    a1.Activated:Connect(function(a1_2) -- Line: 1697 -- upvalues: u176 (upval), u183 (upval), u182 (upval), u365 (upval), a1 (val)
        if a1_2
            and a1_2.UserInputType == Enum.UserInputType.Gamepad1
            and not u176
            and not u183
            and 0.25 < os.clock() - u182 then
            u365(a1)
        end
    end)
end

local function ConnectButtonActivation(a1, a2) -- Line: 1711 -- types: a1: userdata, a2: function
    a1.MouseButton1Click:Connect(a2)
    a1.Activated:Connect(function(a1) -- Line: 1713 -- upvalues: a2 (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            a2()
        end
    end)
end

function u0.HandleSpecialItemDrop() -- Line: 1723
    -- upvalues: u167 (ref), u169 (ref), u227 (val), u168 (ref), GetWeaponProperties (val), Remotes (val), u159 (ref)
    -- upvalues: u183 (ref), u184 (ref), u165 (ref), u176 (ref), u0 (val)
    if u167 and u169 then
        local v1 = u227[u169]
        if not v1 and u168 then
            local success, result = pcall(GetWeaponProperties, u168)
            local Class = success and result and result.Class
            v1 = if Class ~= "Melee" then if Class ~= "Glove" then nil else "Equipped Gloves" else "Equipped Melee"
        end
        if not v1 then
            return
        end
        local v2 = u167
        local EquipSpecialItem = Remotes.Inventory.EquipSpecialItem
        if u183 then
            return
        end
        u183 = true
        u184 = u184 + 1
        local u31 = u184
        EquipSpecialItem.Send({Path = v1, Team = u159, Identifier = v2})
        task.delay(5, function() -- Line: 1629 -- upvalues: u31 (val), u184 (upval), u183 (upval), u165 (upval), u176 (upval), u0 (upval)
            if u31 == u184 and u183 then
                u183 = false
                if not u165 and not u176 then
                    u0.RefreshSelectedWeapon()
                end
                return
            end
        end)
        return
    end
end

function u0.HandleDrop(a1, a2) -- Line: 1742
    -- upvalues: u167 (ref), u168 (ref), u159 (ref), GetWeaponProperties (val), u206 (val), DataController (val)
    -- upvalues: LocalPlayer (val), u274 (val), IsItemEquippedInCategory (val), Remotes (val), u183 (ref), u184 (ref)
    -- upvalues: u165 (ref), u176 (ref), u0 (val), IsWeaponEquippedInCategory (val)
    if u167 and u168 then
        local Options, v1, v2, v3, v4, v5
        local v6 = u168
        local v7 = u159
        if not v6 or type(v6) ~= "string" then
            v1 = false
        elseif v6 ~= "" then
            local success, result = pcall(GetWeaponProperties, v6)
            v1 = success
            if v1 then
                v1 = false
                if result ~= nil then
                    v1 = false
                    if result.Team ~= nil then
                        v1 = true
                        if result.Team ~= "Both" then
                            v1 = result.Team == v7
                        end
                    end
                end
            end
        else
            v1 = false
        end
        if not v1 then
            return
        end
        local success_2, result_2 = pcall(GetWeaponProperties, u168)
        if (if not success_2 then nil else if not result_2 then nil else if not result_2.Type then nil else u206[result_2.Type]) ~= a1 then
            return
        end
        v7 = DataController.Get(LocalPlayer, "Loadout")
        local v8 = v7 and v7[u159]
        if not (if not v8 then nil else if not v8.Loadout then nil else if v8.Loadout[a1] then v8.Loadout[a1].Options else nil) then
            return
        end
        if a1 ~= "Pistols" then
            v7 = 1
        else
            v4 = u274[u159]
            v7 = if if v4 then table.find(v4, u168) ~= nil else false then 1 else 2
        end
        v8, v2 = IsItemEquippedInCategory(u167, a1)
        if v8 and v2 then
            if a2 and v7 <= a2 and a2 <= #Options and v2 ~= a2 then
                local SwapLoadoutSkins = Remotes.Inventory.SwapLoadoutSkins
                v5 = {Type = a1, SlotOne = v2 - 1, SlotTwo = a2 - 1, Team = u159}
                if u183 then
                    return
                end
                u183 = true
                u184 = u184 + 1
                local u110 = u184
                SwapLoadoutSkins.Send(v5)
                task.delay(5, function() -- Line: 1629 -- upvalues: u110 (val), u184 (upval), u183 (upval), u165 (upval), u176 (upval), u0 (upval)
                    if u110 == u184 and u183 then
                        u183 = false
                        if not u165 and not u176 then
                            u0.RefreshSelectedWeapon()
                        end
                        return
                    end
                end)
            end
            return
        end
        v3, v4 = IsWeaponEquippedInCategory(u168, a1)
        if v3 and v4 then
            v5 = u167
            local EquipLoadoutSkin = Remotes.Inventory.EquipLoadoutSkin
            local v9 = {Type = a1, Slot = v4 - 1, Team = u159, Identifier = v5}
            if u183 then
                return
            end
            u183 = true
            u184 = u184 + 1
            local u137 = u184
            EquipLoadoutSkin.Send(v9)
            task.delay(5, function() -- Line: 1629 -- upvalues: u137 (val), u184 (upval), u183 (upval), u165 (upval), u176 (upval), u0 (upval)
                if u137 == u184 and u183 then
                    u183 = false
                    if not u165 and not u176 then
                        u0.RefreshSelectedWeapon()
                    end
                    return
                end
            end)
            return
        end
        if a2 and a2 < v7 then
            return
        end
        v5 = if not (v7 <= #Options) then v7 else math.clamp(a2 or v7, v7, #Options)
        local v10 = u167
        local EquipLoadoutSkin_2 = Remotes.Inventory.EquipLoadoutSkin
        local v11 = {Type = a1, Slot = v5 - 1, Team = u159, Identifier = v10}
        if u183 then
            return
        end
        u183 = true
        u184 = u184 + 1
        local u178 = u184
        EquipLoadoutSkin_2.Send(v11)
        task.delay(5, function() -- Line: 1629 -- upvalues: u178 (val), u184 (upval), u183 (upval), u165 (upval), u176 (upval), u0 (upval)
            if u178 == u184 and u183 then
                u183 = false
                if not u165 and not u176 then
                    u0.RefreshSelectedWeapon()
                end
                return
            end
        end)
        return
    end
end

local function StartItemDrag(a1) -- Line: 1803
    -- upvalues: CreateDragIcon (val), u165 (ref), u166 (ref), u167 (ref), u168 (ref), u169 (ref)
    -- upvalues: ShowMoveFramesForItem (val), u0 (val), PlayerGui (val), UserInputService (val), u200 (val), u170 (ref)
    -- upvalues: RunServiceController (val)
    local v1 = CreateDragIcon(a1)
    if not v1 then
        return false
    end
    u165 = true
    u166 = v1
    u167 = a1._id
    u168 = a1.Name
    u169 = a1.Type
    ShowMoveFramesForItem(a1)
    u0.SetSelectedWeapon(a1, true)
    local MainGui = PlayerGui:FindFirstChild("MainGui") or PlayerGui
    v1.Parent = MainGui
    local MouseLocation = UserInputService:GetMouseLocation()
    v1.Position = UDim2.fromOffset(MouseLocation.X + u200.X, MouseLocation.Y + u200.Y)
    u170 = RunServiceController.BindToRenderStep("UI.Loadout.DragIcon", function() -- Line: 1828 -- upvalues: u166 (upval), UserInputService (upval), u200 (upval)
        if u166 then
            local MouseLocation = UserInputService:GetMouseLocation()
            u166.Position = UDim2.fromOffset(MouseLocation.X + u200.X, MouseLocation.Y + u200.Y)
        end
    end)
    return true
end

local function BeginActualDrag(a1) -- Line: 1841
    -- upvalues: u173 (ref), u171 (ref), u172 (ref), u174 (ref), u175 (ref), u165 (ref), u176 (ref), StartItemDrag (val)
    if u173 then
        u173:Disconnect()
        u173 = nil
    end
    u171 = nil
    u172 = nil
    u174 = false
    u175 = nil
    if not u165 and not u176 then
        StartItemDrag(a1)
        return
    end
end

function u0.OnItemMouseDown(a1, a2, a3) -- Line: 1855
    -- upvalues: UserInputService (val), u176 (ref), u182 (ref), u165 (ref), u171 (ref), u172 (ref), u174 (ref)
    -- upvalues: u175 (ref), u173 (ref), RunServiceController (val), GetInventoryItemFromIdentifier (val)
    -- upvalues: StartItemDrag (val)
    local MouseLocation = UserInputService:GetMouseLocation()
    if not u176 and not (os.clock() - u182 < 0.25) then
        if not u165 and not u171 then
            u171 = a1
            u172 = MouseLocation
            u174 = a2 or false
            u175 = a3
            u173 = RunServiceController.BindToRenderStep("UI.Loadout.PendingDrag", function() -- Line: 1876
                -- upvalues: u171 (upval), u172 (upval), u176 (upval), u173 (upval), u174 (upval), u175 (upval)
                -- upvalues: UserInputService (upval), GetInventoryItemFromIdentifier (upval), u165 (upval)
                -- upvalues: StartItemDrag (upval)
                if u171 and u172 then
                    if u176 then
                        if u173 then
                            u173:Disconnect()
                            u173 = nil
                        end
                        u171 = nil
                        u172 = nil
                        u174 = false
                        u175 = nil
                        return
                    end
                    if 10 <= (UserInputService:GetMouseLocation() - u172).Magnitude then
                        local v1 = u171
                        if u173 then
                            u173:Disconnect()
                            u173 = nil
                        end
                        u171 = nil
                        u172 = nil
                        u174 = false
                        u175 = nil
                        local v2 = v1 and GetInventoryItemFromIdentifier(v1)
                        if v2 then
                            if u173 then
                                u173:Disconnect()
                                u173 = nil
                            end
                            u171 = nil
                            u172 = nil
                            u174 = false
                            u175 = nil
                            if not u165 then
                                if u176 then
                                    return
                                end
                                StartItemDrag(v2)
                            end
                        end
                    end
                end
            end)
            return
        end
        return
    end
end

function u0.OnItemClick(a1) -- Line: 1901 -- upvalues: u163 (ref), u0 (val)
    u163 = nil
    u0.SortByWeapon(a1.Name)
end

local function DropDraggedItem() -- Line: 1910
    -- upvalues: UserInputService (val), GuiService (val), u169 (ref), u227 (val), u168 (ref), GetWeaponProperties (val)
    -- upvalues: IsMouseOverPlayerFrame (val), u0 (val), GetDropTargetCategory (val)
    local MouseLocation = UserInputService:GetMouseLocation()
    local GuiInset = GuiService:GetGuiInset()
    local v1 = Vector2.new(MouseLocation.X - GuiInset.X, MouseLocation.Y - GuiInset.Y)
    local v2 = u169 and u227[u169]
    if not v2 and u168 then
        local success, result = pcall(GetWeaponProperties, u168)
        if success and result then
            if result.Class == "Melee" or result.Class == "Glove" then
                v2 = true
            end
        end
    end
    if v2 and IsMouseOverPlayerFrame(v1) then
        u0.HandleSpecialItemDrop()
        return
    end
    if not v2 then
        local v3, v4 = GetDropTargetCategory(v1)
        if v3 then
            u0.HandleDrop(v3, v4)
        end
    end
end

function u0.EndDrag() -- Line: 1939
    -- upvalues: u171 (ref), u165 (ref), u174 (ref), u175 (ref), UserInputService (val), u173 (ref), u172 (ref)
    -- upvalues: GetInventoryItemFromIdentifier (val), u0 (val), ShowContextMenu (val), DropDraggedItem (val)
    -- upvalues: CleanupDrag (val)
    if u171 and not u165 then
        local v1 = u171
        local v2 = u174
        local v3 = u175
        local MouseLocation = UserInputService:GetMouseLocation()
        if u173 then
            u173:Disconnect()
            u173 = nil
        end
        u171 = nil
        u172 = nil
        u174 = false
        u175 = nil
        local v4 = v1 and GetInventoryItemFromIdentifier(v1)
        if not v4 then
            return
        end
        if v2 then
            u0.OnItemClick(v4)
            return
        end
        ShowContextMenu(v4, MouseLocation, v3, false)
        return
    end
    if not u165 then
        return
    end
    DropDraggedItem()
    CleanupDrag()
end

function u365(a1) -- Line: 1975
    -- upvalues: CleanupDrag (val), GetInventoryItemFromIdentifier (val), GetLoadoutSlotInfo (val), u176 (ref)
    -- upvalues: u180 (ref), u181 (ref), u179 (ref), u178 (ref), GuiService (val), GamepadNavigation (val)
    -- upvalues: GamepadService (val), ShowControllerClickShield (val), StartItemDrag (val), u347 (ref)
    -- upvalues: HideAllMoveFrames (val)
    CleanupDrag()
    local v1 = if not a1 then nil else if not a1:IsA("ImageButton") then nil else GetInventoryItemFromIdentifier(a1.Name)
    if not v1 then
        local Parent = a1.Parent
        if not Parent or not Parent:IsA("Frame") then
            v1 = nil
        else
            local Name = Parent.Name
            local v2, v3 = GetLoadoutSlotInfo(a1)
            v1 = if not v2 then nil else if not v3 then nil else GetInventoryItemFromIdentifier(Name)
        end
    end
    if not v1 then
        return
    end
    u176 = v1._id
    u180 = a1
    u181 = os.clock()
    u179 = false
    if not u178 then
        u178 = true
        GuiService.AutoSelectGuiEnabled = false
        GuiService.SelectedObject = nil
        if a1 then
            GamepadNavigation.ScrollIntoView(a1)
        end
        pcall(function() -- Line: 1287 -- upvalues: GamepadService (upval), a1 (val)
            GamepadService:EnableGamepadCursor(a1)
        end)
        ShowControllerClickShield()
    end
    if not StartItemDrag(v1) then
        local v4 = u180
        CleanupDrag()
        u176 = nil
        u180 = nil
        u179 = false
        if u178 then
            u178 = false
            pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
                GamepadService:DisableGamepadCursor()
            end)
            GuiService.AutoSelectGuiEnabled = true
            local u70 = u347
            if u70 then
                task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u70 (val), u178 (upval)
                    if u347 == u70 and not u178 then
                        u347 = nil
                        u70:Destroy()
                    end
                end)
            end
        end
        HideAllMoveFrames()
        if v4 and GamepadNavigation.IsUsable(v4) then
            GamepadNavigation.ScrollIntoView(v4)
            GuiService.SelectedObject = v4
        end
    end
end

local function u389() -- Line: 1998
    -- upvalues: u182 (ref), u165 (ref), DropDraggedItem (val), u180 (ref), CleanupDrag (val), u176 (ref), u179 (ref)
    -- upvalues: u178 (ref), GamepadService (val), GuiService (val), u347 (ref), HideAllMoveFrames (val)
    -- upvalues: GamepadNavigation (val)
    u182 = os.clock()
    if u165 then
        DropDraggedItem()
    end
    local v1 = u180
    CleanupDrag()
    u176 = nil
    u180 = nil
    u179 = false
    if u178 then
        u178 = false
        pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
            GamepadService:DisableGamepadCursor()
        end)
        GuiService.AutoSelectGuiEnabled = true
        local u18 = u347
        if u18 then
            task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u18 (val), u178 (upval)
                if u347 == u18 and not u178 then
                    u347 = nil
                    u18:Destroy()
                end
            end)
        end
    end
    HideAllMoveFrames()
    if v1 and GamepadNavigation.IsUsable(v1) then
        GamepadNavigation.ScrollIntoView(v1)
        GuiService.SelectedObject = v1
    end
end

local function InspectInventoryItem(a1) -- Line: 2010
    -- upvalues: u262 (val), Router (val), u187 (ref), u185 (ref), u186 (ref)
    local v1 = false
    if a1 ~= nil then
        v1 = u262[a1.Type] == true
    end
    if not v1 then
        return
    end
    Router.broadcastRouter("RunInterfaceSound", "UI Click")
    if u187 then
        u187.Visible = false
    end
    u185 = nil
    u186 = nil
    Router.broadcastRouter(
        "WeaponInspect",
        a1.Name,
        a1.Skin,
        a1.Float,
        a1.StatTrack,
        a1.NameTag,
        a1.Charm,
        a1.Stickers,
        a1.Type,
        a1.Pattern,
        a1._id,
        a1.Serial,
        a1.IsTradeable
    )
end

function u0.CreateItemTemplate(a1) -- Line: 2035
    -- upvalues: Profiler (val), GetResolvedSkinInformation (val), ReplicatedStorage (val), Rarities (val), u280 (ref)
    -- upvalues: Skins (val), GetSkinDisplayName (val), ItemIcon (val), u0 (val), UserInputService (val)
    -- upvalues: GetInventoryItemFromIdentifier (val), ShowContextMenu (val), u176 (ref), u183 (ref), u182 (ref)
    -- upvalues: u365 (ref), UpdateStatusFrame (val)
    Profiler.mark("UI.Loadout.CreateItemTemplate")
    local _id = a1._id
    local v1 = GetResolvedSkinInformation(a1.Name, a1.Skin)
    if v1 then
        local u17 = ReplicatedStorage.Assets.UI.Loadout.ItemTemplate:Clone()
        u17.ItemContent.Rarity.BackgroundColor3 = Rarities[v1.rarity].Color
        u17.Parent = u280.Container.List.Container
        local imageAssetId = Skins.GetWearImageForFloat(v1, a1.Float or 0.9999) or v1.imageAssetId or ""
        u17.ItemContent.Content.Icon.Image = imageAssetId
        local v2 = GetSkinDisplayName.GetWeaponDisplayName(a1.Name, a1.NameTag)
        local v3 = a1.StatTrack and "KillTrak™ " .. v2 or v2
        if a1.Type == "Melee" then
            v3 = "★ " .. v3
        end
        GetSkinDisplayName.ApplyNameLabel(u17.Bottom.Footer.WeaponName, v3, a1.NameTag)
        u17.Bottom.Footer.SkinName.Text = GetSkinDisplayName(a1.Skin)
        u17.Name = _id
        local Icon = u17.ItemContent.Content.Icon
        local v4, v5 = ItemIcon.CreateIconHoverTweens(
            Icon,
            (ItemIcon.CreateIconDropShadow(Icon, ItemIcon.GetDropShadowImageForItem(a1, imageAssetId), u17.ItemContent.Content))
        )
        u17.MouseEnter:Connect(v4)
        u17.MouseLeave:Connect(v5)
        u17.MouseButton1Down:Connect(function() -- Line: 2074 -- upvalues: u0 (upval), _id (val), u17 (val)
            u0.OnItemMouseDown(_id, false, u17)
        end)
        u17.MouseButton2Click:Connect(function() -- Line: 2078
            -- upvalues: UserInputService (upval), GetInventoryItemFromIdentifier (upval), _id (val)
            -- upvalues: ShowContextMenu (upval), u17 (val)
            local MouseLocation = UserInputService:GetMouseLocation()
            local v1 = GetInventoryItemFromIdentifier(_id)
            if v1 then
                ShowContextMenu(v1, MouseLocation, u17, false)
            end
        end)
        u17.Selectable = true
        u17.SelectionGained:Connect(v4)
        u17.SelectionLost:Connect(v5)
        u17.Activated:Connect(function(a1) -- Line: 1697 -- upvalues: u176 (upval), u183 (upval), u182 (upval), u365 (upval), u17 (val)
            if a1
                and a1.UserInputType == Enum.UserInputType.Gamepad1
                and not u176
                and not u183
                and 0.25 < os.clock() - u182 then
                u365(u17)
            end
        end)
        UpdateStatusFrame(u17, _id)
    end
end

function u0.CreateLoadoutTemplate(a1, a2, a3) -- Line: 2098
    -- upvalues: Profiler (val), GetResolvedSkinInformation (val), GetWeaponProperties (val), ReplicatedStorage (val)
    -- upvalues: Rarities (val), Skins (val), GetSkinDisplayName (val), ItemIcon (val), u0 (val), UserInputService (val)
    -- upvalues: GetInventoryItemFromIdentifier (val), ShowContextMenu (val), u328 (val), u165 (ref), u176 (ref)
    -- upvalues: u183 (ref), u182 (ref), u365 (ref), InspectInventoryItem (val)
    Profiler.mark("UI.Loadout.CreateLoadoutTemplate")
    local _id = a2._id
    local v1 = GetResolvedSkinInformation(a2.Name, a2.Skin)
    local success, result = pcall(GetWeaponProperties, a2.Name)
    local Cost = success and result and result.Cost or 0
    if v1 then
        local u36 = ReplicatedStorage.Assets.UI.Loadout:FindFirstChild(if a3 ~= "Counter-Terrorists" then "LoadoutTemplateT" else "LoadoutTemplateCT"):Clone()
        u36.Rarity.BackgroundColor3 = Rarities[v1.rarity].Color
        u36.Parent = a1
        u36.Name = _id
        local imageAssetId = Skins.GetWearImageForFloat(v1, a2.Float or 0.9999) or v1.imageAssetId or ""
        u36.Content.Footer.Cost.Text = "$" .. tostring(Cost)
        GetSkinDisplayName.ApplyNameLabel(
            u36.Content.Footer.Frame.WeaponName,
            GetSkinDisplayName.GetWeaponDisplayName(a2.Name, a2.NameTag),
            a2.NameTag
        )
        local SkinName = u36.Content.Footer.Frame.SkinName
        SkinName.Text = GetSkinDisplayName(a2.Skin)
        local v2 = Rarities[v1.rarity]
        if v2 then
            local Color_2 = if v1.rarity ~= "Forbidden" then v2.Color else Color3.fromRGB(200, 60, 60)
            SkinName.TextColor3 = Color_2
        end
        u36.Content.Icon.Image = imageAssetId
        local Icon = u36.Content.Icon
        local u131, u132 = ItemIcon.CreateIconHoverTweens(
            Icon,
            (ItemIcon.CreateIconDropShadow(Icon, ItemIcon.GetDropShadowImageForItem(a2, imageAssetId), u36.Content))
        )
        u36.Button.MouseEnter:Connect(u131)
        u36.Button.MouseLeave:Connect(u132)
        u36.Button.MouseButton1Down:Connect(function() -- Line: 2148 -- upvalues: u0 (upval), _id (val), u36 (val)
            u0.OnItemMouseDown(_id, true, u36)
        end)
        u36.Button.MouseButton2Click:Connect(function() -- Line: 2151
            -- upvalues: UserInputService (upval), GetInventoryItemFromIdentifier (upval), _id (val)
            -- upvalues: ShowContextMenu (upval), u36 (val)
            local MouseLocation = UserInputService:GetMouseLocation()
            local v1 = GetInventoryItemFromIdentifier(_id)
            if v1 then
                ShowContextMenu(v1, MouseLocation, u36, false)
            end
        end)
        local UIStroke = u36:FindFirstChildOfClass("UIStroke")
        local Color = UIStroke
        if Color then
            Color = UIStroke.Color
        end
        local u174 = u328[a3]
        if not u174 then
            u174 = u328["Counter-Terrorists"]
        end

        local function setCardLit(a1) -- Line: 2163
            -- upvalues: u165 (upval), u176 (upval), UIStroke (val), Color (val), u174 (val)
            if not a1 then
                if UIStroke and Color then
                    UIStroke.Color = if not a1 then Color else u174
                end
                return
            end
            if not u165 and not u176 then
                if UIStroke and Color then
                    UIStroke.Color = if not a1 then Color else u174
                end
                return
            end
        end

        u36.Button.MouseEnter:Connect(function() -- Line: 2172
            -- upvalues: GetInventoryItemFromIdentifier (upval), _id (val), u0 (upval), u165 (upval), u176 (upval)
            -- upvalues: UIStroke (val), Color (val), u174 (val)
            local v1 = GetInventoryItemFromIdentifier(_id)
            if v1 then
                u0.OnLoadoutItemHover(v1)
            end
            if not u165 then
                if u176 then
                    return
                end
                if UIStroke and Color then
                    UIStroke.Color = u174
                end
            end
        end)
        u36.Button.MouseLeave:Connect(function() -- Line: 2179 -- upvalues: UIStroke (val), Color (val)
            if UIStroke and Color then
                UIStroke.Color = Color
            end
        end)
        u36.Button.Selectable = true
        u36.Button.SelectionGained:Connect(function() -- Line: 2184
            -- upvalues: GetInventoryItemFromIdentifier (upval), _id (val), u0 (upval), u131 (val), u165 (upval)
            -- upvalues: u176 (upval), UIStroke (val), Color (val), u174 (val)
            local v1 = GetInventoryItemFromIdentifier(_id)
            if v1 then
                u0.OnLoadoutItemHover(v1)
            end
            u131()
            if not u165 then
                if u176 then
                    return
                end
                if UIStroke and Color then
                    UIStroke.Color = u174
                end
            end
        end)
        u36.Button.SelectionLost:Connect(function() -- Line: 2192 -- upvalues: u132 (val), UIStroke (val), Color (val)
            u132()
            if UIStroke and Color then
                UIStroke.Color = Color
            end
        end)
        local Button = u36.Button
        Button.Activated:Connect(function(a1) -- Line: 1697 -- upvalues: u176 (upval), u183 (upval), u182 (upval), u365 (upval), Button (val)
            if a1
                and a1.UserInputType == Enum.UserInputType.Gamepad1
                and not u176
                and not u183
                and 0.25 < os.clock() - u182 then
                u365(Button)
            end
        end)
        local Inspect = u36:FindFirstChild("Inspect")
        if Inspect and Inspect:IsA("GuiButton") then
            local function u229() -- Line: 2201
                -- upvalues: u165 (upval), u176 (upval), u182 (upval), GetInventoryItemFromIdentifier (upval), _id (val)
                -- upvalues: InspectInventoryItem (upval)
                if not u165 and not u176 then
                    local v1 = os.clock() - u182
                    if not (v1 < 0.25) then
                        v1 = GetInventoryItemFromIdentifier(_id)
                        if v1 then
                            InspectInventoryItem(v1)
                        end
                        return
                    end
                end
            end

            Inspect.MouseButton1Click:Connect(u229)
            Inspect.Activated:Connect(function(a1) -- Line: 1713 -- upvalues: u229 (val)
                if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                    u229()
                end
            end)
        end
    end
end

function u0.PopulateWeaponDropdown() -- Line: 2216
    -- upvalues: u280 (ref), ClearDropdownOptions (val), CreateDropdownOption (val), u0 (val)
    -- upvalues: GetWeaponsInCategory (val), u160 (ref)
    local Scroll = u280.Container.List.Top.Weapon.DropdownContent.Scroll
    if not Scroll then
        return
    end
    if not Scroll:IsA("Frame") and not Scroll:IsA("ScrollingFrame") then
        return
    end
    ClearDropdownOptions(Scroll)
    CreateDropdownOption(Scroll, "All", "All Weapons", 0, function() -- Line: 2227 -- upvalues: u0 (upval), Scroll (val)
        u0.SortByWeapon(nil)
        Scroll.Parent.Visible = false
    end)
    for i, v in ipairs((GetWeaponsInCategory(u160))) do
        CreateDropdownOption(Scroll, v, v, i, function() -- Line: 2235 -- upvalues: u0 (upval), v (val), Scroll (val)
            u0.SortByWeapon(v)
            Scroll.Parent.Visible = false
        end)
    end
end

function u0.SortByCategory(a1) -- Line: 2244
    -- upvalues: u160 (ref), u164 (ref), u163 (ref), u280 (ref), u0 (val), u192 (ref), u191 (ref), u189 (ref)
    -- upvalues: GetSortedLoadoutItemIds (val), UpdateLoadoutTemplates (val)
    u164 = nil
    u163 = nil
    u280.Container.List.Top.Filter.Container.Left.Title.Text = a1 or "All Categories"
    u0.PopulateWeaponDropdown()
    u280.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons"
    local Reset = u280.Container.List.Top:FindFirstChild("Reset")
    if Reset then
        local v1 = true
        if a1 == nil then
            v1 = true
            if u163 == nil then
                v1 = u280.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons"
            end
        end
        Reset.Visible = v1
    end
    if u280 and u280.Visible then
        u189 = GetSortedLoadoutItemIds()
        UpdateLoadoutTemplates()
        return
    end
    u192 = true
    u191 = true
end

function u0.SortByWeapon(a1, a2) -- Line: 2260
    -- upvalues: u164 (ref), u163 (ref), u280 (ref), Sort (val), u161 (ref), LocalPlayer (val), u302 (ref), u192 (ref)
    -- upvalues: u191 (ref), u189 (ref), GetSortedLoadoutItemIds (val), UpdateLoadoutTemplates (val), u160 (ref)
    u164 = a1 and {weaponName = a1, skinName = a2} or nil
    u163 = nil
    u280.Container.List.Top.Weapon.Container.Left.Title.Text = a1 or "All Weapons"
    if Sort.GetSortComparisonFunction(u161, LocalPlayer, function() -- Line: 2267 -- upvalues: u302 (upval)
        return u302
    end) then
        if not u280 then
            u192 = true
            u191 = true
        elseif u280.Visible then
            u189 = GetSortedLoadoutItemIds()
            UpdateLoadoutTemplates()
        else
            u192 = true
            u191 = true
        end
    end
    local Reset = u280.Container.List.Top:FindFirstChild("Reset")
    if Reset then
        local v1 = true
        if u160 == nil then
            v1 = true
            if u163 == nil then
                v1 = u280.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons"
            end
        end
        Reset.Visible = v1
    end
end

function u0.SortBySkinMetadata(a1) -- Line: 2279
    -- upvalues: Profiler (val), u161 (ref), u280 (ref), Sort (val), LocalPlayer (val), u302 (ref), u192 (ref)
    -- upvalues: u191 (ref), u189 (ref), GetSortedLoadoutItemIds (val), UpdateLoadoutTemplates (val)
    Profiler.mark("UI.Loadout.SortBySkinMetadata")
    u161 = a1
    u280.Container.List.Top.Filter.Container.Left.Title.Text = a1
    if not Sort.GetSortComparisonFunction(a1, LocalPlayer, function() -- Line: 2284 -- upvalues: u302 (upval)
        return u302
    end) then
        return
    end
    if u280 and u280.Visible then
        u189 = GetSortedLoadoutItemIds()
        UpdateLoadoutTemplates()
        return
    end
    u192 = true
    u191 = true
end

function u0.UpdateInventoryContainer() -- Line: 2294
    -- upvalues: Profiler (val), u280 (ref), u192 (ref), u191 (ref), u176 (ref), GetInventoryItemFromIdentifier (val)
    -- upvalues: u180 (ref), CleanupDrag (val), u179 (ref), u178 (ref), GamepadService (val), GuiService (val)
    -- upvalues: u347 (ref), HideAllMoveFrames (val), GamepadNavigation (val), DataController (val), LocalPlayer (val)
    -- upvalues: u185 (ref), u187 (ref), u186 (ref), u0 (val), u161 (ref)
    Profiler.mark("UI.Loadout.UpdateInventoryContainer")
    if not u280 then
        return
    end
    if not u280.Visible then
        u192 = true
        u191 = true
        return
    end
    if u176 and not GetInventoryItemFromIdentifier(u176) then
        local v1 = u180
        CleanupDrag()
        u176 = nil
        u180 = nil
        u179 = false
        if u178 then
            u178 = false
            pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
                GamepadService:DisableGamepadCursor()
            end)
            GuiService.AutoSelectGuiEnabled = true
            local u26 = u347
            if u26 then
                task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u26 (val), u178 (upval)
                    if u347 == u26 and not u178 then
                        u347 = nil
                        u26:Destroy()
                    end
                end)
            end
        end
        HideAllMoveFrames()
        if v1 and GamepadNavigation.IsUsable(v1) then
            GamepadNavigation.ScrollIntoView(v1)
            GuiService.SelectedObject = v1
        end
    end
    local v2 = {}
    for i, v in ipairs((DataController.Get(LocalPlayer, "Inventory"))) do
        if v and v._id then
            v2[v._id] = true
        end
    end
    if u185 and not v2[u185] then
        if u187 then
            u187.Visible = false
        end
        u185 = nil
        u186 = nil
    end
    for i2, i3 in ipairs(u280.Container.List.Container:GetChildren()) do
        if i3:IsA("ImageButton") and i3.Name ~= "UIGridLayout" and i3.Name ~= "UIPadding" and not v2[i3.Name] then
            i3:Destroy()
        end
    end
    u0.PopulateWeaponDropdown()
    u0.SortBySkinMetadata(u161)
end

function u0.UpdateLoadoutContainer(a1) -- Line: 2340
    -- upvalues: Profiler (val), u180 (ref), CleanupDrag (val), u176 (ref), u179 (ref), u178 (ref), GamepadService (val)
    -- upvalues: GuiService (val), u347 (ref), HideAllMoveFrames (val), GamepadNavigation (val), u159 (ref), u280 (ref)
    -- upvalues: ClearFrame (val), GetInventoryItemFromIdentifier (val), u0 (val)
    local Count, List_2, List_3, Options, Parent, Title, v1, v2, v3
    Profiler.mark("UI.Loadout.UpdateLoadoutContainer")
    local v4 = u180
    CleanupDrag()
    u176 = nil
    u180 = nil
    u179 = false
    if u178 then
        u178 = false
        pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
            GamepadService:DisableGamepadCursor()
        end)
        GuiService.AutoSelectGuiEnabled = true
        local u18 = u347
        if u18 then
            task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u18 (val), u178 (upval)
                if u347 == u18 and not u178 then
                    u347 = nil
                    u18:Destroy()
                end
            end)
        end
    end
    HideAllMoveFrames()
    if v4 and GamepadNavigation.IsUsable(v4) then
        GamepadNavigation.ScrollIntoView(v4)
        GuiService.SelectedObject = v4
    end
    v4 = if u159 ~= "Counter-Terrorists" then "T" else "CT"
    local v5 = u280.Container.Teams:FindFirstChild(v4)
    local v6 = ("[Loadout] Missing %* team panel"):format(v4)
    assert(v5 and v5:IsA("Frame"), v6)
    local Guns = v5:FindFirstChild("Guns")
    local SelectedObject = GuiService.SelectedObject
    local v7 = nil
    local Name = nil
    for i, v in ipairs({"Mid Tier", "Pistols", "Rifles"}) do
        List_2 = Guns:FindFirstChild(v).List
        if SelectedObject and SelectedObject:IsDescendantOf(List_2) then
            Parent = SelectedObject
            while Parent.Parent do
                if Parent.Parent == List_2 then
                    break
                end
                Parent = Parent.Parent
            end
            v7 = v
            Name = Parent.Name
            break
        end
    end
    for i2, i3 in ipairs({"Mid Tier", "Pistols", "Rifles"}) do
        List_3 = Guns:FindFirstChild(i3).List
        ClearFrame(List_3, {"UIListLayout", "Frame"})
        v1 = a1[u159]
        assert(v1, (("[Loadout] Failed to get player team loadout for %*"):format(u159)))
        Options = v1.Loadout[i3].Options
        v2 = 0
        for i4, j in ipairs(Options) do
            v3 = GetInventoryItemFromIdentifier(j)
            if v3 then
                u0.CreateLoadoutTemplate(List_3, v3, u159)
                if List_3:FindFirstChild(v3._id) then
                    v2 = v2 + 1
                end
            end
        end
        Title = (Guns:FindFirstChild(i3)):FindFirstChild("Title")
        Count = Title and Title:FindFirstChild("Count")
        if Count and Count:IsA("TextLabel") then
            Count.Text = ("%* %*"):format(v2, if v2 ~= 1 then "ITEMS" else "ITEM")
        end
    end
    u0.RefreshSelectedWeapon()
    if v7 then
        local List = (Guns:FindFirstChild(v7)).List
        task.defer(function() -- Line: 2400 -- upvalues: GuiService (upval), GamepadNavigation (upval), Name (ref), List (val)
            if GuiService.SelectedObject ~= nil and GamepadNavigation.IsUsable(GuiService.SelectedObject) then
                return
            end
            local v1 = Name and List:FindFirstChild(Name)
            local Button = v1 and v1:FindFirstChild("Button")
            if not Button then
                for i, j in List:GetChildren() do
                    Button = j:IsA("Frame") and j:FindFirstChild("Button") or nil
                    if Button then
                        break
                    end
                end
            end
            if Button and Button:IsA("GuiObject") and GamepadNavigation.IsUsable(Button) then
                GuiService.SelectedObject = Button
            end
        end)
    end
end

function u0.UpdateSidebarFrames(a1, a2) -- Line: 2423
    -- upvalues: Profiler (val), u159 (ref), u280 (ref), u234 (val), GetInventoryItemFromIdentifier (val)
    -- upvalues: GetResolvedSkinInformation (val), Skins (val), Rarities (val)
    Profiler.mark("UI.Loadout.UpdateSidebarFrames")
    local v1 = a2 or u159
    local v2 = if v1 ~= "Counter-Terrorists" then "T" else "CT"
    local v3 = u280.Container.Teams:FindFirstChild(v2)
    assert(v3 and v3:IsA("Frame"), (("[Loadout] Missing %* team panel"):format(v2)))
    local Equipments = v3:FindFirstChild("Equipments")
    if not Equipments then
        return
    end
    local v4 = a1[v1]
    if v4 and v4.Equipped then
        local imageAssetId, v5, v6, v7, v8, v9, v10
        for k, v in pairs(u234) do
            v5 = v4.Equipped[k]
            v6 = Equipments:FindFirstChild(v)
            if v6 then
                v7 = nil
                v8 = false
                if v5 and v5 ~= "" then
                    v9 = GetInventoryItemFromIdentifier(v5)
                    if v9 then
                        v7 = v9
                        v10 = GetResolvedSkinInformation(v9.Name, v9.Skin)
                        if v10 then
                            v8 = true
                            imageAssetId = Skins.GetWearImageForFloat(v10, v9.Float or 0.9999) or v10.imageAssetId or ""
                            v6.Container.Icon.Image = imageAssetId
                            v6.Container.Icon.Visible = true
                            v6.Rarity.BackgroundColor3 = Rarities[v10.rarity].Color
                            v6.Rarity.Visible = true
                        end
                    end
                end
                if not v8 then
                    v6.Container.Icon.Visible = false
                    v6.Rarity.Visible = false
                end
                v6:SetAttribute("EquippedItemId", v7 and v7._id)
                v6:SetAttribute("SidebarName", v)
                v6:SetAttribute("TeamKey", if v1 ~= "Counter-Terrorists" then "T" else "CT")
            end
        end
        return
    end
end

local u400 = {}
local u405 = Color3.fromRGB(200, 60, 60)
local u406 = {
    Glove = "Gloves",
    Melee = "Knife",
    Badge = "Badge",
    ["Music Kit"] = "Music Kit",
    Graffiti = "Spray",
    ["Zeus x27"] = "Zeus",
}
local u413 = {
    RIFLE = "Rifle",
    SNIPER = "Sniper",
    SMG = "SMG",
    PISTOL = "Pistol",
    HEAVY = "Heavy",
    MELEE = "Knife",
}

local function v4() -- Line: 2520 -- upvalues: u159 (ref)
    if u159 == "Counter-Terrorists" then
        return "CT"
    end
    return "T"
end

local function ComputeWeaponStats(a1) -- Line: 2525
    if type(a1) == "table" and type(a1.Spread) == "table" and type(a1.DamagePerPart) == "table" then
        local FireModes = a1.FireModes and a1.FireModes.Primary
        local FireRate = FireModes and FireModes.FireRate or a1.FireRate
        local Spread_2 = FireModes and FireModes.Spread or a1.Spread
        local Torso = a1.DamagePerPart.Torso
        if type(FireRate) == "number"
            and not (FireRate <= 0)
            and type(Torso) == "number"
            and type(a1.WalkSpeed) == "number" then
            local v1
            local v2 = a1.BulletsPerShot or 1
            local v3 = Torso * (if not (v2 > 1) then 1 else v2 * 0.35)
            local Min = Spread_2.Range and Spread_2.Range.Min or 0
            local v4 = Spread_2.PerShot or 0
            local v5 = {
                Damage = math.sqrt((math.clamp(v3 / 143, 0, 1))) * 100,
                FireRate = math.clamp(60 / FireRate / 900, 0, 1) * 100,
                Accuracy = 100 / (1 + Min * 0.6 + v4 * 0.1),
                Mobility = math.clamp((a1.WalkSpeed - 10) / 10.2, 0, 1) * 100,
            }
            for i, j in v5 do
                v1 = math.round(j)
                v5[i] = (math.max(v1, 4))
            end
            return v5
        end
        return nil
    end
    return nil
end

local function PaintWeaponDetails(a1, a2) -- Line: 2558
    -- upvalues: u280 (ref), GetResolvedSkinInformation (val), GetWeaponProperties (val), Rarities (val), u405 (val)
    -- upvalues: Skins (val), GetSkinDisplayName (val), u406 (val), u413 (val), WeaponCategories (val)
    -- upvalues: CommaNumber (val), ComputeWeaponStats (val)
    local v1 = u280.Container.Teams:FindFirstChild(a1)
    assert(v1 and v1:IsA("Frame"), (("[Loadout] Missing %* team panel"):format(a1)))
    local Viewport = v1:FindFirstChild("Viewport")
    local Details = Viewport and Viewport:FindFirstChild("Details")
    if not Details then
        return
    end
    Details.Visible = a2 ~= nil
    if not a2 then
        return
    end
    local v2 = GetResolvedSkinInformation(a2.Name, a2.Skin)
    local success, result = pcall(GetWeaponProperties, a2.Name)
    if not success then
        result = nil
    end
    local v3 = v2 and Rarities[v2.rarity]
    local Color = if not v2 then if not v3 then Rarities.Stock.Color else v3.Color else if v2.rarity ~= "Forbidden" then if not v3 then Rarities.Stock.Color else v3.Color else u405
    Details.Render.Image = if not v2 then "" else Skins.GetWearImageForFloat(v2, a2.Float or 0.9999) or v2.imageAssetId or ""
    local v4 = GetSkinDisplayName.GetWeaponDisplayName(a2.Name, a2.NameTag)
    local v5 = if not a2.StatTrack then v4 else "KillTrak™ " .. v4
    if a2.Type == "Melee" then
        v5 = "★ " .. v5
    end
    GetSkinDisplayName.ApplyNameLabel(Details.WeaponName, v5, a2.NameTag)
    Details.SkinLine.SkinName.Text = GetSkinDisplayName(a2.Skin)
    Details.SkinLine.SkinName.TextColor3 = Color
    Details.SkinLine.Diamond.BackgroundColor3 = Color
    local Class = result and result.Class
    local v6 = u406[a2.Type] or (if Class ~= "Glove" then if Class ~= "Melee" then u413[WeaponCategories.GetLabel(a2.Name)] or "Equipment" else "Knife" else "Gloves")
    local Cost = result and result.Cost
    Details.Meta.Text = if type(Cost) ~= "number" or not (Cost > 0) then v6 else ("%*  ·  $%*"):format(v6, (CommaNumber(Cost)))
    local v7 = if a2.Type ~= "Weapon" then nil else ComputeWeaponStats(result)
    Details.Stats.Visible = v7 ~= nil
    Details.Divider.Visible = v7 ~= nil
    if v7 then
        local v8
        for i, j in v7 do
            v8 = Details.Stats:FindFirstChild(i)
            if v8 then
                v8.Track.Fill.Size = UDim2.fromScale(j / 100, 1)
                v8.Value.Text = tostring(j)
            end
        end
    end
end

local function GetDefaultSelectedItem() -- Line: 2622
    -- upvalues: DataController (val), LocalPlayer (val), u159 (ref), GetInventoryItemFromIdentifier (val)
    local Options, v1, v2, v3, v4, v5
    local v6 = {"Rifles", "Mid Tier", "Pistols"}
    local v7 = nil
    local v8 = nil
    for i, j in v6, v7, v8 do
        v4 = DataController.Get(LocalPlayer, "Loadout")
        v5 = v4 and v4[u159]
        Options = (if not v5 then nil else if not v5.Loadout then nil else if v5.Loadout[j] then v5.Loadout[j].Options else nil) or {}
        v2 = nil
        v3 = nil
        for k, n in Options, v2, v3 do
            v1 = not (n == "") and GetInventoryItemFromIdentifier(n) or nil
            if v1 then
                return v1
            end
        end
    end
    return nil
end

function u0.SetSelectedWeapon(a1, a2) -- Line: 2640
    -- upvalues: u165 (ref), u176 (ref), u159 (ref), u400 (val), PaintWeaponDetails (val)
    local v1
    if not a1 then
        return
    end
    if a2 then
        v1 = if u159 ~= "Counter-Terrorists" then "T" else "CT"
        if not a2 then
            u400[v1] = a1._id
        end
        PaintWeaponDetails(v1, a1)
        return
    end
    if not u165 and not u176 then
        v1 = if u159 ~= "Counter-Terrorists" then "T" else "CT"
        if not a2 then
            u400[v1] = a1._id
        end
        PaintWeaponDetails(v1, a1)
        return
    end
end

function u0.RefreshSelectedWeapon() -- Line: 2655
    -- upvalues: u159 (ref), u400 (val), GetInventoryItemFromIdentifier (val), IsEquippedOnTeam (val)
    -- upvalues: GetDefaultSelectedItem (val), PaintWeaponDetails (val)
    local v1
    local v2 = u400[if u159 ~= "Counter-Terrorists" then "T" else "CT"]
    local v3 = v2 and GetInventoryItemFromIdentifier(v2)
    if not v3 or not IsEquippedOnTeam(v2, u159) then
        v3 = GetDefaultSelectedItem()
        u400[v1] = v3 and v3._id
    end
    PaintWeaponDetails(v1, v3)
end

function u0.OnLoadoutItemHover(a1) -- Line: 2666 -- upvalues: u0 (val)
    u0.SetSelectedWeapon(a1)
end

local function SetupSidebarHoverEvents() -- Line: 2672
    -- upvalues: Profiler (val), u280 (ref), u248 (val), u188 (val), u0 (val), GetInventoryItemFromIdentifier (val)
    local Equipments, showEquippedItem, v1, v2, v3, v4
    Profiler.mark("UI.Loadout.SetupSidebarHoverEvents")
    local Teams = u280.Container.Teams
    for i, v in ipairs({"CT", "T"}) do
        v4 = Teams:FindFirstChild(v)
        if v4 then
            Equipments = v4:FindFirstChild("Equipments")
            if Equipments then
                for i2, i3 in ipairs(u248) do
                    local u50 = Equipments:FindFirstChild(i3)
                    if u50 then
                        v1 = v .. "_" .. i3
                        v2 = v1 .. "_Selection"
                        for j, k in {v1, v2} do
                            v3 = u188[k]
                            if v3 then
                                v3:Disconnect()
                            end
                        end

                        function showEquippedItem() -- Line: 2704
                            -- upvalues: u50 (val), u0 (upval), GetInventoryItemFromIdentifier (upval)
                            local Attribute = u50:GetAttribute("EquippedItemId")
                            if Attribute and Attribute ~= "" then
                                u0.SetSelectedWeapon((GetInventoryItemFromIdentifier(Attribute)))
                            end
                        end

                        u188[v1] = (u50.MouseEnter:Connect(showEquippedItem))
                        u188[v2] = (u50.SelectionGained:Connect(showEquippedItem))
                    end
                end
            end
        end
    end
end

local u422 = {ButtonCT = u328["Counter-Terrorists"], ButtonT = u328.Terrorists}

local function UpdateTeamToggle(a1) -- Line: 2729 -- upvalues: u422 (val), u280 (ref) -- types: a1: string
    local ActiveBar, InactiveDim, v1, v2
    local v3 = nil
    local v4 = nil
    for i, j in u422, v3, v4 do
        v1 = u280.Teams:FindFirstChild(i)
        if v1 and v1:IsA("GuiObject") then
            v2 = i == ("Button%*"):format(a1)
            InactiveDim = v1:FindFirstChild("InactiveDim")
            if not InactiveDim then
                InactiveDim = Instance.new("Frame")
                InactiveDim.Name = "InactiveDim"
                InactiveDim.BackgroundColor3 = Color3.new(0, 0, 0)
                InactiveDim.BackgroundTransparency = 0.45
                InactiveDim.BorderSizePixel = 0
                InactiveDim.Size = UDim2.fromScale(1, 1)
                InactiveDim.ZIndex = 20
                InactiveDim.Interactable = false
                InactiveDim.Parent = v1
            end
            InactiveDim.Visible = not v2
            ActiveBar = v1:FindFirstChild("ActiveBar")
            if not ActiveBar then
                ActiveBar = Instance.new("Frame")
                ActiveBar.Name = "ActiveBar"
                ActiveBar.BackgroundColor3 = j
                ActiveBar.BorderSizePixel = 0
                ActiveBar.AnchorPoint = Vector2.new(0.5, 1)
                ActiveBar.Position = UDim2.fromScale(0.5, 1)
                ActiveBar.Size = UDim2.new(1, 0, 0, 3)
                ActiveBar.ZIndex = 20
                ActiveBar.Interactable = false
                ActiveBar.Parent = v1
            end
            ActiveBar.Visible = v2
        end
    end
end

function u0.SelectTeam(a1) -- Line: 2768
    -- upvalues: Profiler (val), u280 (ref), u159 (ref), UpdateTeamToggle (val), u160 (ref), u164 (ref), u163 (ref)
    -- upvalues: DataController (val), LocalPlayer (val), u0 (val)
    local v1
    Profiler.mark("UI.Loadout.SelectTeam")
    local CT = u280.Container.Teams:FindFirstChild("CT")
    assert(CT and CT:IsA("Frame"), "[Loadout] Missing CT team panel")
    CT.Visible = a1 == "CT"
    local T = u280.Container.Teams:FindFirstChild("T")
    assert(T and T:IsA("Frame"), "[Loadout] Missing T team panel")
    T.Visible = a1 == "T"
    if a1 ~= "CT" then
        v1 = false
        if a1 == "T" then
            v1 = "Terrorists"
        end
    else
        v1 = "Counter-Terrorists"
    end
    u159 = v1
    UpdateTeamToggle(a1)
    u160 = nil
    u164 = nil
    u163 = nil
    u280.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories"
    u280.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons"
    local v2 = DataController.Get(LocalPlayer, "Loadout")
    u0.UpdateLoadoutContainer(v2)
    u0.UpdateSidebarFrames(v2)
    u0.UpdateInventoryContainer()
    u0.PopulateWeaponDropdown()
end

local function RefreshItemStatusFrames() -- Line: 2794 -- upvalues: u280 (ref), UpdateStatusFrame (val)
    if u280 and u280.Visible then
        for i, v in ipairs(u280.Container.List.Container:GetChildren()) do
            if v:IsA("Frame") and v.Name ~= "UIGridLayout" and v.Name ~= "UIListLayout" and v.Name ~= "UIPadding" then
                UpdateStatusFrame(v, v.Name)
            end
        end
    end
end

function u0.Initialize(a1, a2) -- Line: 2813
    -- upvalues: Profiler (val), u280 (ref), CleanupDrag (val), u180 (ref), u176 (ref), u179 (ref), u178 (ref)
    -- upvalues: GamepadService (val), GuiService (val), u347 (ref), HideAllMoveFrames (val), u192 (ref), u0 (val)
    -- upvalues: u161 (ref), u191 (ref), RenderInitialLoadoutTemplates (val), u190 (ref), u189 (ref)
    -- upvalues: CreateMissingItemTemplates (val), ApplySortedLayoutOrder (val), OnLoadoutScrollPositionChanged (val)
    -- upvalues: u187 (ref), u185 (ref), u186 (ref), MenuState (val), Router (val), CloseButtonRegistry (val)
    -- upvalues: GetInventoryItemFromIdentifier (val), InspectInventoryItem (val), Remotes (val), UseItemFrame (val)
    -- upvalues: ReplaceItemOnTeam (val), ItemIcon (val), FadeCategoryLabels (val), DataController (val)
    -- upvalues: LocalPlayer (val), u183 (ref), SetupSidebarHoverEvents (val), RefreshItemStatusFrames (val), u165 (ref)
    -- upvalues: UserInputService (val), u389 (ref), u171 (ref), u181 (ref), u377 (ref), GetLoadoutSlotInfo (val)
    -- upvalues: u177 (ref), TweenService (val), u205 (val), u162 (ref), ClearDropdownOptions (val), u160 (ref)
    -- upvalues: u164 (ref), u163 (ref)
    local Guns, v1, v2
    Profiler.mark("UI.Loadout.Initialize")
    u280 = a2
    ;(u280:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 2818
        -- upvalues: u280 (upval), CleanupDrag (upval), u180 (upval), u176 (upval), u179 (upval), u178 (upval)
        -- upvalues: GamepadService (upval), GuiService (upval), u347 (upval), HideAllMoveFrames (upval), u192 (upval)
        -- upvalues: u0 (upval), u161 (upval), u191 (upval), RenderInitialLoadoutTemplates (upval)
        if u280.Visible then
            if u192 then
                u192 = false
                u0.SortBySkinMetadata(u161)
            end
            if u191 then
                RenderInitialLoadoutTemplates()
            end
            return
        end
        CleanupDrag()
        CleanupDrag()
        u176 = nil
        u180 = nil
        u179 = false
        if u178 then
            u178 = false
            pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
                GamepadService:DisableGamepadCursor()
            end)
            GuiService.AutoSelectGuiEnabled = true
            local u17 = u347
            if u17 then
                task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u17 (val), u178 (upval)
                    if u347 == u17 and not u178 then
                        u347 = nil
                        u17:Destroy()
                    end
                end)
            end
        end
        HideAllMoveFrames()
    end)
    local Container = u280.Container.List.Container
    ;(Container:GetPropertyChangedSignal("CanvasPosition")):Connect(function() -- Line: 2839
        -- upvalues: u280 (upval), u190 (upval), u189 (upval), Profiler (upval), CreateMissingItemTemplates (upval)
        -- upvalues: ApplySortedLayoutOrder (upval)
        if not u280 then
            return
        end
        local Container = u280.Container.List.Container
        local Y = Container.CanvasPosition.Y
        local v1 = Container.AbsoluteCanvasSize.Y - Container.AbsoluteSize.Y
        if v1 > 0 and u190 < #u189 and v1 - Y < 200 then
            Profiler.mark("UI.Loadout.RenderLoadoutTemplates")
            if not u280 then
                return
            end
            local Container_2 = u280.Container.List.Container
            local v2 = math.min(u190 + 25, #u189)
            CreateMissingItemTemplates(Container_2, u190 + 1, v2)
            u190 = v2
            ApplySortedLayoutOrder(Container_2)
        end
    end)
    ;(Container:GetPropertyChangedSignal("AbsoluteCanvasSize")):Connect(function() -- Line: 2844 -- upvalues: Profiler (upval), OnLoadoutScrollPositionChanged (upval)
        Profiler.defer("UI.Loadout.ScrollDeferred", OnLoadoutScrollPositionChanged)
    end)
    local Menu = a1:FindFirstChild("Menu")
    if Menu then
        (Menu:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 2851
            -- upvalues: Menu (val), CleanupDrag (upval), u180 (upval), u176 (upval), u179 (upval), u178 (upval)
            -- upvalues: GamepadService (upval), GuiService (upval), u347 (upval), HideAllMoveFrames (upval)
            -- upvalues: u187 (upval), u185 (upval), u186 (upval), MenuState (upval), Router (upval)
            if not Menu.Visible then
                CleanupDrag()
                CleanupDrag()
                u176 = nil
                u180 = nil
                u179 = false
                if u178 then
                    u178 = false
                    pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
                        GamepadService:DisableGamepadCursor()
                    end)
                    GuiService.AutoSelectGuiEnabled = true
                    local u17 = u347
                    if u17 then
                        task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u17 (val), u178 (upval)
                            if u347 == u17 and not u178 then
                                u347 = nil
                                u17:Destroy()
                            end
                        end)
                    end
                end
                HideAllMoveFrames()
                if u187 then
                    u187.Visible = false
                end
                u185 = nil
                u186 = nil
                if MenuState.IsInspectActive() then
                    Router.broadcastRouter("WeaponInspectClose")
                end
            end
        end)
    end
    u187 = u280.Ignore.Information
    if u187 then
        u187.Visible = false
        CloseButtonRegistry.Add(u187, nil, function() -- Line: 2869 -- upvalues: Router (upval), u186 (upval), u187 (upval), u185 (upval), GuiService (upval)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            local v1 = u186
            if u187 then
                u187.Visible = false
            end
            u185 = nil
            u186 = nil
            if v1 then
                local Button = v1:FindFirstChild("Button")
                if Button and Button:IsA("GuiButton") then
                    GuiService.SelectedObject = Button
                end
            end
        end)
        if u187.Inspect then
            u187.Inspect.Selectable = true

            local function handleInspectClick() -- Line: 2883
                -- upvalues: u185 (upval), GetInventoryItemFromIdentifier (upval), InspectInventoryItem (upval)
                -- upvalues: Router (upval)
                local v1 = if not u185 then nil else GetInventoryItemFromIdentifier(u185)
                if v1 then
                    InspectInventoryItem(v1)
                    return
                end
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
            end

            local Inspect = u187.Inspect
            Inspect.MouseButton1Click:Connect(handleInspectClick)
            Inspect.Activated:Connect(function(a1) -- Line: 1713 -- upvalues: handleInspectClick (val)
                if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                    handleInspectClick()
                end
            end)
        end
        if u187.Charm then
            u187.Charm.Selectable = true

            local function handleCharmClick() -- Line: 2896
                -- upvalues: Router (upval), u185 (upval), GetInventoryItemFromIdentifier (upval), u187 (upval)
                -- upvalues: u186 (upval), Remotes (upval), u280 (upval), UseItemFrame (upval)
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                local v1 = if not u185 then nil else GetInventoryItemFromIdentifier(u185)
                if v1 then
                    local Charm = v1.Charm
                    local v2 = false
                    if Charm ~= nil then
                        v2 = false
                        if Charm ~= false then
                            v2 = true
                            if type(Charm) ~= "string" then
                                v2 = true
                                if Charm ~= true then
                                    v2 = type(Charm) == "table"
                                end
                            end
                        end
                    end
                    if u187 then
                        u187.Visible = false
                    end
                    u185 = nil
                    u186 = nil
                    if v2 then
                        Remotes.Inventory.RemoveWeaponCharm.Send({WeaponId = v1._id})
                        return
                    end
                    u280.Visible = false
                    UseItemFrame.TriggerAction("AttachCharm", v1)
                end
            end

            local Charm = u187.Charm
            Charm.MouseButton1Click:Connect(handleCharmClick)
            Charm.Activated:Connect(function(a1) -- Line: 1713 -- upvalues: handleCharmClick (val)
                if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                    handleCharmClick()
                end
            end)
        end
        UseItemFrame.OnClosed:Connect(function() -- Line: 2913 -- upvalues: MenuState (upval), u280 (upval)
            if MenuState.GetCurrentScreen() == "Loadout" then
                u280.Visible = true
            end
        end)
        if u187.Unlock then
            u187.Unlock.Selectable = true
            u187.Unlock.Visible = false
        end

        local function setupReplaceButton(a1, a2) -- Line: 2924
            -- upvalues: Router (upval), u185 (upval), GetInventoryItemFromIdentifier (upval), u187 (upval)
            -- upvalues: u186 (upval), ReplaceItemOnTeam (upval)
            if not a1 then
                return
            end
            a1.Selectable = true

            local function u3() -- Line: 2930
                -- upvalues: Router (upval), u185 (upval), GetInventoryItemFromIdentifier (upval), u187 (upval)
                -- upvalues: u186 (upval), ReplaceItemOnTeam (upval), a2 (val)
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                local v1 = if not u185 then nil else GetInventoryItemFromIdentifier(u185)
                if v1 then
                    if u187 then
                        u187.Visible = false
                    end
                    u185 = nil
                    u186 = nil
                    ReplaceItemOnTeam(v1, a2)
                end
            end

            a1.MouseButton1Click:Connect(u3)
            a1.Activated:Connect(function(a1) -- Line: 1713 -- upvalues: u3 (val)
                if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                    u3()
                end
            end)
        end

        local ReplaceT = u187.ReplaceT
        if ReplaceT then
            ReplaceT.Selectable = true
            local u113 = "Terrorists"

            local function u114() -- Line: 2930
                -- upvalues: Router (upval), u185 (upval), GetInventoryItemFromIdentifier (upval), u187 (upval)
                -- upvalues: u186 (upval), ReplaceItemOnTeam (upval), u113 (val)
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                local v1 = if not u185 then nil else GetInventoryItemFromIdentifier(u185)
                if v1 then
                    if u187 then
                        u187.Visible = false
                    end
                    u185 = nil
                    u186 = nil
                    ReplaceItemOnTeam(v1, u113)
                end
            end

            ReplaceT.MouseButton1Click:Connect(u114)
            ReplaceT.Activated:Connect(function(a1) -- Line: 1713 -- upvalues: u114 (val)
                if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                    u114()
                end
            end)
        end
        local ReplaceCT = u187.ReplaceCT
        if ReplaceCT then
            ReplaceCT.Selectable = true
            local u128 = "Counter-Terrorists"

            local function u129() -- Line: 2930
                -- upvalues: Router (upval), u185 (upval), GetInventoryItemFromIdentifier (upval), u187 (upval)
                -- upvalues: u186 (upval), ReplaceItemOnTeam (upval), u128 (val)
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                local v1 = if not u185 then nil else GetInventoryItemFromIdentifier(u185)
                if v1 then
                    if u187 then
                        u187.Visible = false
                    end
                    u185 = nil
                    u186 = nil
                    ReplaceItemOnTeam(v1, u128)
                end
            end

            ReplaceCT.MouseButton1Click:Connect(u129)
            ReplaceCT.Activated:Connect(function(a1) -- Line: 1713 -- upvalues: u129 (val)
                if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                    u129()
                end
            end)
        end
    end
    Profiler.spawn("UI.Loadout.PreloadDropShadows", ItemIcon.PreloadDropShadows)
    for i, v in ipairs({"CT", "T"}) do
        v2 = u280.Container.Teams:FindFirstChild(v)
        v1 = ("[Loadout] Missing %* team panel"):format(v)
        assert(v2 and v2:IsA("Frame"), v1)
        Guns = v2:FindFirstChild("Guns")
        for i2, i3 in ipairs({"Mid Tier", "Pistols", "Rifles"}) do
            local List = Guns:FindFirstChild(i3).List
            if List and List:IsA("Frame") then
                List.MouseEnter:Connect(function() -- Line: 2956 -- upvalues: FadeCategoryLabels (upval), List (val)
                    FadeCategoryLabels(List, true)
                end)
                List.MouseLeave:Connect(function() -- Line: 2959 -- upvalues: FadeCategoryLabels (upval), List (val)
                    FadeCategoryLabels(List, false)
                end)
            end
        end
    end
    DataController.CreateListener(LocalPlayer, "Loadout", function(a1) -- Line: 2966
        -- upvalues: Profiler (upval), u183 (upval), u0 (upval), SetupSidebarHoverEvents (upval)
        -- upvalues: RefreshItemStatusFrames (upval)
        Profiler.mark("UI.Loadout.LoadoutChanged")
        u183 = false
        u0.UpdateLoadoutContainer(a1)
        u0.UpdateSidebarFrames(a1, "Counter-Terrorists")
        u0.UpdateSidebarFrames(a1, "Terrorists")
        SetupSidebarHoverEvents()
        RefreshItemStatusFrames()
    end)
    Remotes.Inventory.LoadoutResponse.Listen(function() -- Line: 2978 -- upvalues: u183 (upval), u165 (upval), u176 (upval), u0 (upval)
        u183 = false
        if not u165 and not u176 then
            u0.RefreshSelectedWeapon()
        end
    end)
    DataController.CreateListener(LocalPlayer, "Inventory", function() -- Line: 2983 -- upvalues: Profiler (upval), u0 (upval), RefreshItemStatusFrames (upval)
        Profiler.mark("UI.Loadout.InventoryChanged")
        u0.UpdateInventoryContainer()
        RefreshItemStatusFrames()
    end)
    UserInputService.InputEnded:Connect(function(a1, a2) -- Line: 2990
        -- upvalues: u176 (upval), u179 (upval), u389 (upval), u165 (upval), u171 (upval), u0 (upval)
        if a1.UserInputType ~= Enum.UserInputType.MouseButton1 and a1.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if u176 then
            if a1.UserInputType == Enum.UserInputType.MouseButton1 and u179 then
                u389()
            end
            return
        end
        if u165 or u171 then
            u0.EndDrag()
        end
    end)
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 3012
        -- upvalues: u176 (upval), u181 (upval), u179 (upval), u377 (upval), u280 (upval), UserInputService (upval)
        -- upvalues: GuiService (upval), GetInventoryItemFromIdentifier (upval), GetLoadoutSlotInfo (upval)
        -- upvalues: InspectInventoryItem (upval)
        if a1.UserInputType == Enum.UserInputType.MouseButton1 then
            if u176 and 0.05 < os.clock() - u181 then
                u179 = true
            end
            return
        end
        if a1.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return
        end
        if a1.KeyCode == Enum.KeyCode.ButtonA then
            if u176 and 0.05 < os.clock() - u181 then
                u179 = true
                return
            end
            return
        end
        if a1.KeyCode == Enum.KeyCode.ButtonB then
            u377()
            return
        end
        if a1.KeyCode ~= Enum.KeyCode.ButtonX then
            return
        end
        if u280.Visible and not u176 and not UserInputService:GetFocusedTextBox() then
            local SelectedObject = GuiService.SelectedObject
            if SelectedObject and SelectedObject:IsA("GuiButton") and SelectedObject:IsDescendantOf(u280) then
                local v1 = if not SelectedObject then nil else if not SelectedObject:IsA("ImageButton") then nil else GetInventoryItemFromIdentifier(SelectedObject.Name)
                if not v1 then
                    local Parent = SelectedObject.Parent
                    if not Parent or not Parent:IsA("Frame") then
                        v1 = nil
                    else
                        local Name = Parent.Name
                        local v2, v3 = GetLoadoutSlotInfo(SelectedObject)
                        v1 = if not v2 then nil else if not v3 then nil else GetInventoryItemFromIdentifier(Name)
                    end
                end
                local Attribute = SelectedObject:GetAttribute("EquippedItemId")
                if not v1 and type(Attribute) == "string" and Attribute ~= "" then
                    v1 = GetInventoryItemFromIdentifier(Attribute)
                end
                if v1 then
                    InspectInventoryItem(v1)
                end
                return
            end
            return
        end
    end)
    UserInputService.InputEnded:Connect(function(a1, a2) -- Line: 3058 -- upvalues: u176 (upval), u179 (upval), u389 (upval)
        if a1.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return
        end
        if a1.KeyCode == Enum.KeyCode.ButtonA and u176 and u179 then
            u389()
        end
    end)
    UserInputService.LastInputTypeChanged:Connect(function(a1) -- Line: 3074
        -- upvalues: u178 (upval), u177 (upval), u180 (upval), CleanupDrag (upval), u176 (upval), u179 (upval)
        -- upvalues: GamepadService (upval), GuiService (upval), u347 (upval), HideAllMoveFrames (upval)
        if u178 and a1 ~= Enum.UserInputType.Keyboard and a1 ~= Enum.UserInputType.Touch then
            return
        end
        local v1 = u177
        u177 = a1 == Enum.UserInputType.Gamepad1
        if v1 and not u177 then
            CleanupDrag()
            u176 = nil
            u180 = nil
            u179 = false
            if u178 then
                u178 = false
                pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
                    GamepadService:DisableGamepadCursor()
                end)
                GuiService.AutoSelectGuiEnabled = true
                local u25 = u347
                if u25 then
                    task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u25 (val), u178 (upval)
                        if u347 == u25 and not u178 then
                            u347 = nil
                            u25:Destroy()
                        end
                    end)
                end
            end
            HideAllMoveFrames()
        end
        if not v1 and u177 then
            CleanupDrag()
        end
    end)
    u177 = (UserInputService:GetLastInputType()) == Enum.UserInputType.Gamepad1
    local Filter = u280.Container.List.Top.Filter
    local Scroll = Filter.DropdownContent.Scroll
    Filter.MouseButton1Click:Connect(function() -- Line: 3105 -- upvalues: Scroll (val), u280 (upval)
        local Visible = Scroll.Parent.Visible
        local DropdownContent = u280.Container.List.Top.Filter.DropdownContent
        local DropdownContent_2 = u280.Container.List.Top.Weapon.DropdownContent
        DropdownContent.Visible = false
        DropdownContent_2.Visible = false
        Scroll.Parent.Visible = not Visible
    end)
    for i4, j in ipairs(Scroll:GetChildren()) do
        if j:IsA("TextButton") then
            j.BackgroundTransparency = 1
            j.MouseEnter:Connect(function() -- Line: 3114 -- upvalues: j (val), TweenService (upval), u205 (upval)
                TweenService:Create(j, u205, {BackgroundTransparency = 0.85}):Play()
            end)
            j.MouseLeave:Connect(function() -- Line: 3117 -- upvalues: j (val), TweenService (upval), u205 (upval)
                TweenService:Create(j, u205, {BackgroundTransparency = 1}):Play()
            end)
            j.MouseButton1Click:Connect(function() -- Line: 3120 -- upvalues: u0 (upval), j (val), Scroll (val)
                u0.SortBySkinMetadata(j.Name)
                Scroll.Parent.Visible = false
            end)
        end
    end
    local Reverse = u280.Container.List.Top.Filter.Container.Left.Reverse
    if Reverse then
        Reverse.Selectable = true

        local function u245() -- Line: 3130
            -- upvalues: u162 (upval), Reverse (val), u0 (upval), u161 (upval), Router (upval)
            u162 = not u162
            local ImageLabel = Reverse:FindFirstChildOfClass("ImageLabel")
            if ImageLabel then
                ImageLabel.Rotation = if not u162 then 0 else 180
            end
            u0.SortBySkinMetadata(u161)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
        end

        Reverse.MouseButton1Click:Connect(u245)
        Reverse.Activated:Connect(function(a1) -- Line: 1713 -- upvalues: u245 (val)
            if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                u245()
            end
        end)
    end
    local Weapon = u280.Container.List.Top.Weapon
    local Scroll_2 = Weapon.DropdownContent.Scroll
    if Scroll_2 then
        if Scroll_2:IsA("Frame") or Scroll_2:IsA("ScrollingFrame") then
            ClearDropdownOptions(Scroll_2)
            Weapon.MouseButton1Click:Connect(function() -- Line: 3148 -- upvalues: Scroll_2 (val), u280 (upval)
                local Visible = Scroll_2.Parent.Visible
                local DropdownContent = u280.Container.List.Top.Filter.DropdownContent
                local DropdownContent_2 = u280.Container.List.Top.Weapon.DropdownContent
                DropdownContent.Visible = false
                DropdownContent_2.Visible = false
                Scroll_2.Parent.Visible = not Visible
            end)
        end
    end
    local Reset = u280.Container.List.Top.Reset
    if Reset then
        Reset.Visible = false
        Reset.MouseButton1Click:Connect(function() -- Line: 3160
            -- upvalues: u160 (upval), u164 (upval), u163 (upval), Weapon (val), Reset (val), u0 (upval), u280 (upval)
            -- upvalues: u161 (upval)
            u160 = nil
            u164 = nil
            u163 = nil
            Weapon.Container.Left.Title.Text = "All Weapons"
            Reset.Visible = false
            u0.PopulateWeaponDropdown()
            for i, v in ipairs(u280.Container.List.Container:GetChildren()) do
                if v:IsA("ImageButton") then
                    v.Visible = true
                end
            end
            u0.SortBySkinMetadata(u161)
        end)
    end
end

function u0.ViewInLoadout(a1) -- Line: 3184
    -- upvalues: GetInventoryItemFromIdentifier (val), GetWeaponProperties (val), u160 (ref), u280 (ref), u0 (val)
    -- upvalues: u163 (ref), MenuState (val)
    local v1 = GetInventoryItemFromIdentifier(a1)
    if not v1 then
        return
    end
    local Name = v1.Name
    local Skin = v1.Skin
    local success, result = pcall(GetWeaponProperties, Name)
    if success and result and result.Type then
        u160 = result.Type
        u280.Container.List.Top.Filter.Container.Left.Title.Text = result.Type
        u0.PopulateWeaponDropdown()
    end
    u0.SortByWeapon(Name, Skin)
    local Reset = u280.Container.List.Top:FindFirstChild("Reset")
    if Reset then
        local v2 = true
        if u160 == nil then
            v2 = true
            if u163 == nil then
                v2 = u280.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons"
            end
        end
        Reset.Visible = v2
    end
    if not u280.Visible then
        MenuState.SetScreen("Loadout")
        u280.Visible = true
    end
end

function u0.Start() -- Line: 3212
    -- upvalues: Profiler (val), DataController (val), LocalPlayer (val), u0 (val), SetupSidebarHoverEvents (val)
    -- upvalues: u160 (ref), u164 (ref), u163 (ref), u280 (ref), u161 (ref), u241 (val), u176 (ref), u182 (ref)
    -- upvalues: ActivateButton (val), u159 (ref), MenuState (val), u180 (ref), CleanupDrag (val), u179 (ref)
    -- upvalues: u178 (ref), GamepadService (val), GuiService (val), u347 (ref), HideAllMoveFrames (val), u271 (val)
    -- upvalues: CloseButtonRegistry (val), GamepadNavigation (val)
    debug.setmemorycategory("UI.Loadout.Start")
    Profiler.mark("UI.Loadout.Start.Begin")
    DataController.WaitForDataLoaded(LocalPlayer)
    Profiler.mark("UI.Loadout.Start.DataLoaded")
    u0.SelectTeam("CT")
    Profiler.mark("UI.Loadout.Start.InitialTeam")
    local v1 = DataController.Get(LocalPlayer, "Loadout")
    if v1 then
        u0.UpdateSidebarFrames(v1, "Counter-Terrorists")
        u0.UpdateSidebarFrames(v1, "Terrorists")
        SetupSidebarHoverEvents()
    end
    u0.PopulateWeaponDropdown()
    u0.SortBySkinMetadata("Newest")

    local function ClearFiltersAndShowAll() -- Line: 3234
        -- upvalues: u160 (upval), u164 (upval), u163 (upval), u280 (upval), u0 (upval), u161 (upval)
        u160 = nil
        u164 = nil
        u163 = nil
        u280.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories"
        u280.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons"
        for i, v in ipairs(u280.Container.List.Container:GetChildren()) do
            if v:IsA("ImageButton") then
                v.Visible = true
            end
        end
        u0.SortBySkinMetadata(u161)
        local Reset = u280.Container.List.Top:FindFirstChild("Reset")
        if Reset then
            local v1 = true
            if u160 == nil then
                v1 = true
                if u163 == nil then
                    v1 = u280.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons"
                end
            end
            Reset.Visible = v1
        end
    end

    local u48 = {}

    local function SetupSidebarButtonClicks() -- Line: 3255
        -- upvalues: Profiler (upval), u280 (upval), u241 (upval), u176 (upval), u182 (upval), u163 (upval)
        -- upvalues: ClearFiltersAndShowAll (val), u160 (upval), u164 (upval), u0 (upval), u161 (upval), u48 (val)
        local Equipments, v1, v2, v3, v4
        Profiler.mark("UI.Loadout.SetupSidebarButtonClicks")
        for i, v in ipairs({"CT", "T"}) do
            v3 = u280.Container.Teams:FindFirstChild(v)
            v4 = ("[Loadout] Missing %* team panel"):format(v)
            assert(v3 and v3:IsA("Frame"), v4)
            Equipments = v3:FindFirstChild("Equipments")
            for i2, i3 in ipairs(u241) do
                v1 = Equipments[i3]
                v1.Selectable = true
                v1.Active = true
                v2 = ("%*_%*"):format(v, i3)
                if u48[v2] then
                    u48[v2]:Disconnect()
                end
                u48[v2] = (v1.Activated:Connect(function() -- Line: 3268
                    -- upvalues: u176 (upval), u182 (upval), u163 (upval), v (val), i3 (val)
                    -- upvalues: ClearFiltersAndShowAll (upval), u160 (upval), u164 (upval), u280 (upval), u0 (upval)
                    -- upvalues: u161 (upval)
                    if not u176 then
                        local v1 = os.clock() - u182
                        if not (v1 < 0.25) then
                            v1 = u163
                            if v1 then
                                v1 = false
                                if u163.teamKey == v then
                                    v1 = u163.sidebarName == i3
                                end
                            end
                            if v1 then
                                u163 = nil
                                ClearFiltersAndShowAll()
                                return
                            end
                            u160 = nil
                            u164 = nil
                            u280.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories"
                            u280.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons"
                            u163 = {teamKey = v, sidebarName = i3}
                            u0.SortBySkinMetadata(u161)
                            local Reset = u280.Container.List.Top:FindFirstChild("Reset")
                            if Reset then
                                local v2 = true
                                if u160 == nil then
                                    v2 = true
                                    if u163 == nil then
                                        v2 = u280.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons"
                                    end
                                end
                                Reset.Visible = v2
                            end
                            return
                        end
                    end
                end))
            end
        end
    end

    SetupSidebarButtonClicks()
    ActivateButton(u280.Teams.ButtonCT)
    ActivateButton(u280.Teams.ButtonT)

    local function SwitchToTeam(a1) -- Line: 3321
        -- upvalues: u159 (upval), u0 (upval), u163 (upval), ClearFiltersAndShowAll (val), Profiler (upval)
        -- upvalues: SetupSidebarButtonClicks (val)
        local v1 = if a1 ~= "CT" then "Terrorists" else "Counter-Terrorists"
        if u159 == v1 then
            return
        end
        u0.SelectTeam(a1)
        u163 = nil
        ClearFiltersAndShowAll()
        Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks)
    end

    u280.Teams.ButtonCT.MouseButton1Click:Connect(function() -- Line: 3335
        -- upvalues: u159 (upval), u0 (upval), u163 (upval), ClearFiltersAndShowAll (val), Profiler (upval)
        -- upvalues: SetupSidebarButtonClicks (val)
        if u159 == "Counter-Terrorists" then
            return
        end
        u0.SelectTeam("CT")
        u163 = nil
        ClearFiltersAndShowAll()
        Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks)
    end)
    u280.Teams.ButtonT.MouseButton1Click:Connect(function() -- Line: 3339
        -- upvalues: u159 (upval), u0 (upval), u163 (upval), ClearFiltersAndShowAll (val), Profiler (upval)
        -- upvalues: SetupSidebarButtonClicks (val)
        if u159 == "Terrorists" then
            return
        end
        u0.SelectTeam("T")
        u163 = nil
        ClearFiltersAndShowAll()
        Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks)
    end)
    local RegisterBumperOverride = MenuState.RegisterBumperOverride
    local v2 = u280
    local v3 = u280
    local Teams_3 = u280.Teams
    RegisterBumperOverride(v2, function(a1) -- Line: 3345
        -- upvalues: u176 (upval), u180 (upval), CleanupDrag (upval), u179 (upval), u178 (upval), GamepadService (upval)
        -- upvalues: GuiService (upval), u347 (upval), HideAllMoveFrames (upval), u159 (upval), MenuState (upval)
        -- upvalues: u280 (upval), u271 (upval), u0 (upval), u163 (upval), ClearFiltersAndShowAll (val)
        -- upvalues: Profiler (upval), SetupSidebarButtonClicks (val)
        local v1
        if u176 then
            CleanupDrag()
            u176 = nil
            u180 = nil
            u179 = false
            if u178 then
                u178 = false
                pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
                    GamepadService:DisableGamepadCursor()
                end)
                GuiService.AutoSelectGuiEnabled = true
                local u15 = u347
                if u15 then
                    task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u15 (val), u178 (upval)
                        if u347 == u15 and not u178 then
                            u347 = nil
                            u15:Destroy()
                        end
                    end)
                end
            end
            HideAllMoveFrames()
        end
        local v2 = if u159 ~= "Counter-Terrorists" then "ButtonT" else "ButtonCT"
        local v3 = MenuState.GetNextBumperTab(u280.Teams, u271, v2, a1)
        if v3 and v3 ~= v2 then
            local v4 = if (if v3 ~= "ButtonCT" then "T" else "CT") ~= "CT" then "Terrorists" else "Counter-Terrorists"
            if u159 ~= v4 then
                u0.SelectTeam(v1)
                u163 = nil
                ClearFiltersAndShowAll()
                Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks)
            end
        end
        v1 = u280.Teams:FindFirstChild(v3 or v2)
        if v1 and v1:IsA("GuiObject") then
            GuiService.SelectedObject = v1
        end
        return true
    end, v3, Teams_3, function() -- Line: 3364 -- upvalues: u176 (upval)
        return u176 ~= nil
    end)
    CloseButtonRegistry.AddHandler(function() -- Line: 3369 -- upvalues: u176 (upval), u280 (upval)
        local Visible = false
        if u176 ~= nil then
            Visible = u280.Visible
        end
        return Visible
    end, function() -- Line: 3371
        -- upvalues: u180 (upval), CleanupDrag (upval), u176 (upval), u179 (upval), u178 (upval), GamepadService (upval)
        -- upvalues: GuiService (upval), u347 (upval), HideAllMoveFrames (upval), GamepadNavigation (upval)
        local v1 = u180
        CleanupDrag()
        u176 = nil
        u180 = nil
        u179 = false
        if u178 then
            u178 = false
            pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
                GamepadService:DisableGamepadCursor()
            end)
            GuiService.AutoSelectGuiEnabled = true
            local u13 = u347
            if u13 then
                task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u13 (val), u178 (upval)
                    if u347 == u13 and not u178 then
                        u347 = nil
                        u13:Destroy()
                    end
                end)
            end
        end
        HideAllMoveFrames()
        if v1 and GamepadNavigation.IsUsable(v1) then
            GamepadNavigation.ScrollIntoView(v1)
            GuiService.SelectedObject = v1
        end
    end)
    ;(GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled")):Connect(function() -- Line: 3378
        -- upvalues: u178 (upval), u176 (upval), GamepadService (upval), u180 (upval), CleanupDrag (upval), u179 (upval)
        -- upvalues: GuiService (upval), u347 (upval), HideAllMoveFrames (upval), GamepadNavigation (upval)
        if u178 and u176 and not GamepadService.GamepadCursorEnabled then
            local v1 = u180
            CleanupDrag()
            u176 = nil
            u180 = nil
            u179 = false
            if u178 then
                u178 = false
                pcall(function() -- Line: 1300 -- upvalues: GamepadService (upval)
                    GamepadService:DisableGamepadCursor()
                end)
                GuiService.AutoSelectGuiEnabled = true
                local u17 = u347
                if u17 then
                    task.delay(0.25, function() -- Line: 1259 -- upvalues: u347 (upval), u17 (val), u178 (upval)
                        if u347 == u17 and not u178 then
                            u347 = nil
                            u17:Destroy()
                        end
                    end)
                end
            end
            HideAllMoveFrames()
            if v1 and GamepadNavigation.IsUsable(v1) then
                GamepadNavigation.ScrollIntoView(v1)
                GuiService.SelectedObject = v1
            end
        end
    end)
    u280.Teams.ButtonCT.Interactable = true
    u280.Teams.ButtonT.Interactable = true
end

return u0