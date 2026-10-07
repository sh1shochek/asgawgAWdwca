-- ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Inventory
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Inventory
-- Decompile time: 32.42 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
require(ReplicatedStorage.Database.Custom.Types)
local LocalPlayer = Players.LocalPlayer
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local EquipInventorySlot = require(ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot)
local GetInventoryItemIcon = require(ReplicatedStorage.Components.Common.GetInventoryItemIcon)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local u91 = nil
local u92 = 0
local u93 = nil
local u94 = nil
local u95 = {}
local u96 = nil
local u107 = table.find(GetUserPlatform(), "Console")
if u107 then
    u107 = #GetUserPlatform() <= 1
end
local u108 = {
    {type = "Primary", space = 1},
    {type = "Secondary", space = 1},
    {type = "Melee", space = 2},
    {type = "Grenade", space = 4},
    {type = "C4", space = 1},
}
local u118 = (utf8.char(9733)) .. " "
local u123 = Color3.new(1, 1, 1)
local u124 = {}
local u125 = {}
local u126 = nil

local function getWeaponFrames() -- Line: 117 -- upvalues: u126 (ref)
    if not u126 then
        return nil
    end
    return {u126.Primary, u126.Secondary, u126.Melee}
end

local function isZeusWeapon(a1) -- Line: 124
    local v1 = false
    if a1 ~= nil then
        v1 = a1.Name == "Zeus x27"
    end
    return v1
end

local function shouldDisplaySkinSuffix(a1) -- Line: 128 -- types: a1: string
    local v1 = false
    if a1 ~= "Vanilla" then
        v1 = a1 ~= "Stock"
    end
    return v1
end

local function getInventoryItemDisplayName(a1, a2) -- Line: 132
    -- upvalues: u118 (val), GetSkinDisplayName (val), LocalPlayer (val)
    local v1, v2
    if a2 ~= "Melee" then
        v1 = ""
    else
        v2 = false
        if a1 ~= nil then
            v2 = a1.Name == "Zeus x27"
        end
        v1 = not v2 and u118 or ""
    end
    v2 = GetSkinDisplayName.GetNameTag(a1.NameTag) ~= nil
    local v3 = v1 .. GetSkinDisplayName.GetWeaponDisplayName(a1.Name, a1.NameTag)
    local v4 = v3
    if a1.Skin and not v2 then
        local v5 = GetSkinDisplayName(a1.Skin)
        local v6 = false
        if v5 ~= "Vanilla" then
            v6 = v5 ~= "Stock"
        end
        v4 = v3 .. (v6 and " | " .. v5 or "")
    end
    if not v2 then
        if a1.Name == "T Knife" or a1.Name == "CT Knife" then
            v4 = "Knife"
        end
    end
    local OriginalOwner = a1.OriginalOwner
    if OriginalOwner and OriginalOwner ~= "" and OriginalOwner ~= LocalPlayer.Name then
        return (("%*'s \"%*\""):format(OriginalOwner, v4))
    end
    if v2 then
        v4 = ("\"%*\""):format(v4)
    end
    return v4
end

local function getWeaponColor(a1) -- Line: 163
    -- upvalues: DataController (val), LocalPlayer (val), GetPreferenceColor (val), GetResolvedSkinInformation (val)
    -- upvalues: Rarities (val)
    if a1 and DataController.Get(LocalPlayer, "Settings.Game.HUD.Glow Weapon with Rarity Color") == true then
        local v1 = GetResolvedSkinInformation(a1.Name, a1.Skin)
        local rarity = v1 and v1.rarity and Rarities[v1.rarity]
        if rarity then
            return rarity.Color
        end
        return (GetPreferenceColor())
    end
    return GetPreferenceColor()
end

local function getLabelFromContainer(a1, a2) -- Line: 174 -- types: a1: userdata?, a2: string
    if not a1 then
        return nil
    end
    if a1:IsA(a2) then
        return a1
    end
    return a1:FindFirstChildWhichIsA(a2, true)
end

local function getImageLabelFromContainer(a1) -- Line: 186
    -- upvalues: getLabelFromContainer (val)
    return getLabelFromContainer(a1, "ImageLabel")
end

local function getTextLabelFromContainer(a1) -- Line: 190
    -- upvalues: getLabelFromContainer (val)
    return getLabelFromContainer(a1, "TextLabel")
end

local function getMeleeImageLabels(a1) -- Line: 194
    local Weapon = a1:FindFirstChild("Weapon")
    local Melee = Weapon and Weapon:FindFirstChild("Melee") or nil
    local v1 = if Melee then if not Melee:IsA("ImageLabel") then Melee:FindFirstChildWhichIsA("ImageLabel", true) else Melee else nil
    local Zeus = a1:FindFirstChild("Zeus") or Weapon and Weapon:FindFirstChild("Zeus") or nil
    local v2 = if Zeus then if not Zeus:IsA("ImageLabel") then Zeus:FindFirstChildWhichIsA("ImageLabel", true) else Zeus else nil
    if not v1 and Weapon and Weapon:IsA("Frame") then
        v1 = Weapon:FindFirstChildOfClass("ImageLabel")
    end
    return v1, v2
end

local function getMeleeWeaponNameLabels(a1) -- Line: 209
    local Weapon = a1:FindFirstChild("Weapon")
    local WeaponName = Weapon and Weapon:FindFirstChild("WeaponName") or nil
    local v1 = if WeaponName then if not WeaponName:IsA("TextLabel") then WeaponName:FindFirstChildWhichIsA("TextLabel", true) else WeaponName else nil
    local Zeus = a1:FindFirstChild("Zeus") or Weapon and Weapon:FindFirstChild("Zeus") or nil
    if not Zeus then
        return v1, nil
    end
    if Zeus:IsA("TextLabel") then
        return v1, Zeus
    end
    return v1, (Zeus:FindFirstChildWhichIsA("TextLabel", true))
end

local function getFrameWeaponImageLabel(a1, a2) -- Line: 220 -- upvalues: getMeleeImageLabels (val)
    if not a1 then
        return nil
    end
    if a1.Name ~= "Melee" then
        return a1.Weapon:FindFirstChildOfClass("ImageLabel")
    end
    local v1, v2 = getMeleeImageLabels(a1)
    local v3 = false
    if a2 ~= nil then
        v3 = a2.Name == "Zeus x27"
    end
    return v3 and v2 or v1
end

local function getFrameWeaponNameLabel(a1, a2) -- Line: 236 -- upvalues: getMeleeWeaponNameLabels (val)
    if not a1 then
        return nil
    end
    if a1.Name ~= "Melee" then
        return (a1.Weapon:FindFirstChild("WeaponName"))
    end
    local v1, v2 = getMeleeWeaponNameLabels(a1)
    local v3 = false
    if a2 ~= nil then
        v3 = a2.Name == "Zeus x27"
    end
    return v3 and v2 or v1
end

local function clearFrameWeaponNameLabels(a1) -- Line: 252 -- upvalues: getMeleeWeaponNameLabels (val)
    if not a1 then
        return
    end
    if a1.Name ~= "Melee" then
        local WeaponName = a1.Weapon:FindFirstChild("WeaponName")
        if WeaponName then
            WeaponName.Visible = false
            WeaponName.Text = ""
        end
        return
    end
    local v1, v2 = getMeleeWeaponNameLabels(a1)
    if v1 then
        v1.Visible = false
        v1.Text = ""
    end
    if v2 then
        v2.Visible = false
        v2.Text = ""
    end
end

local function getVisibleWeaponImageLabel(a1) -- Line: 277 -- upvalues: getMeleeImageLabels (val)
    if not a1 then
        return nil
    end
    if a1.Name == "Melee" then
        local v1, v2 = getMeleeImageLabels(a1)
        if v2 and v2.Visible then
            return v2
        end
        if v1 and v1.Visible then
            return v1
        end
    end
    return a1.Weapon:FindFirstChildOfClass("ImageLabel")
end

local function updateMeleeInventoryFrame(a1, a2, a3) -- Line: 295
    -- upvalues: getMeleeImageLabels (val), getMeleeWeaponNameLabels (val), getWeaponColor (val)
    -- upvalues: GetSkinDisplayName (val), getInventoryItemDisplayName (val)
    local v1, v2, v3
    local v4, v5 = getMeleeImageLabels(a1)
    local v6, v7 = getMeleeWeaponNameLabels(a1)
    local v8 = nil
    local v9 = nil
    local v10 = {}
    a1:SetAttribute("Slot", 3)
    a1.Keybind.Text = "3"
    local v11, v12 = a3, a1
    for i, v in ipairs(a2._items) do
        table.insert(v10, (("$%*<%*>"):format(v.Name, v.Identifier)))
        v3 = false
        if v ~= nil then
            v3 = v.Name == "Zeus x27"
        end
        if not v3 then
            v8 = v
        else
            v9 = v
        end
    end
    if v4 then
        v4.Visible = v8 ~= nil
    end
    if v8 and v4 then
        v4.Image = v8.Properties.Icon
        v4.ImageColor3 = getWeaponColor(v8)
    end
    if v5 then
        v5.Visible = v9 ~= nil
    end
    if v9 and v5 then
        v5.Image = v9.Properties.Icon
        v5.ImageColor3 = getWeaponColor(v9)
    end
    local v13 = v11
    if not v13 or v13.Properties.Slot ~= "Melee" then
        v13 = v8 or v9
    end
    if not v13 then
        v12.Equip.Visible = false
        if v12 then
            if v12.Name ~= "Melee" then
                local WeaponName = v12.Weapon:FindFirstChild("WeaponName")
                if WeaponName then
                    WeaponName.Visible = false
                    WeaponName.Text = ""
                end
            else
                v1, v2 = getMeleeWeaponNameLabels(v12)
                if v1 then
                    v1.Visible = false
                    v1.Text = ""
                end
                if v2 then
                    v2.Visible = false
                    v2.Text = ""
                end
            end
        end
        if v4 then
            v4.Visible = false
        end
        if v5 then
            v5.Visible = false
        end
        return
    end
    if not v12 then
        v1 = nil
    elseif v12.Name ~= "Melee" then
        v1 = v12.Weapon:FindFirstChild("WeaponName")
    else
        local v14, v15 = getMeleeWeaponNameLabels(v12)
        v3 = false
        if v13 ~= nil then
            v3 = v13.Name == "Zeus x27"
        end
        v1 = v3 and v15 or v14
    end
    v2 = false
    if v11 ~= nil then
        v2 = v11.Properties.Slot == "Melee"
    end
    if v6 and v6 ~= v1 then
        v6.Visible = false
    end
    if v7 and v7 ~= v1 then
        v7.Visible = false
    end
    if not v1 then
        return
    end
    v1.TextColor3 = getWeaponColor(v13)
    GetSkinDisplayName.ApplyNameLabel(v1, getInventoryItemDisplayName(v13, "Melee"), v13.NameTag)
    v1.Visible = v2
end

local function getObjectiveKitAttributeName() -- Line: 370
    local Attribute = workspace:GetAttribute("Gamemode")
    if Attribute == "Bomb Defusal" then
        return "HasDefuseKit"
    end
    if Attribute == "Hostage Rescue" then
        return "HasRescueKit"
    end
    return nil
end

local function shouldShowObjectiveKitIcon(a1) -- Line: 380 -- types: a1: userdata?
    if a1 and a1:GetAttribute("Team") == "Counter-Terrorists" then
        local Attribute = workspace:GetAttribute("Gamemode")
        local v1 = if Attribute ~= "Bomb Defusal" then if Attribute ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
        local v2 = false
        if v1 ~= nil then
            v2 = a1:GetAttribute(v1) == true
        end
        return v2
    end
    return false
end

local function updateObjectiveKitIcon(a1) -- Line: 389 -- upvalues: u126 (ref) -- types: a1: userdata?
    local v1
    local DefuseKit = u126.Grenade.DefuseKit
    if not a1 then
        v1 = false
    elseif a1:GetAttribute("Team") == "Counter-Terrorists" then
        local Attribute = workspace:GetAttribute("Gamemode")
        local v2 = if Attribute ~= "Bomb Defusal" then if Attribute ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
        v1 = false
        if v2 ~= nil then
            v1 = a1:GetAttribute(v2) == true
        end
    else
        v1 = false
    end
    DefuseKit.Visible = v1
end

local function resetFadeTimer() -- Line: 393 -- upvalues: u96 (ref), u95 (val), u126 (ref)
    local Equip
    if u96 then
        task.cancel(u96)
        u96 = nil
    end
    for i, j in u95 do
        j:Cancel()
    end
    table.clear(u95)
    local v1 = if u126 then {u126.Primary, u126.Secondary, u126.Melee} else nil
    if not v1 then
        return
    end
    for i2, v in ipairs(v1) do
        if v:IsA("Frame") then
            Equip = v:FindFirstChild("Equip")
            if Equip and Equip:IsA("Frame") then
                Equip.BackgroundTransparency = 0.225
            end
            for k, n in v:QueryDescendants("ImageLabel, TextLabel") do
                if not n:IsA("ImageLabel") then
                    n.TextTransparency = 0.225
                else
                    n.ImageTransparency = 0.225
                end
            end
        end
    end
end

local function startFade() -- Line: 429
    -- upvalues: DataController (val), LocalPlayer (val), resetFadeTimer (val), u126 (ref), TweenService (val)
    -- upvalues: u95 (val), u96 (ref)
    local Equip, v1, v2, v3, v4
    local v5 = DataController.Get(LocalPlayer, "Settings.Game.Item.Always Show Inventory") ~= false
    resetFadeTimer()
    if v5 then
        return
    end
    local v6 = if u126 then {u126.Primary, u126.Secondary, u126.Melee} else nil
    if not v6 then
        return
    end
    for i, v in ipairs(v6) do
        if v:IsA("Frame") then
            Equip = v:FindFirstChild("Equip")
            if Equip and Equip:IsA("Frame") then
                v4 = TweenService:Create(Equip, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                u95[v.Name .. "_Equip"] = v4
                v4:Play()
            end
            for i2, j in v:QueryDescendants("ImageLabel", "TextLabel") do
                v1 = if not j:IsA("ImageLabel") then {TextTransparency = 1} else {ImageTransparency = 1}
                v2 = TweenService
                v3 = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
                v2 = v2:Create(j, v3, v1)
                u95[v.Name .. "_" .. j:GetFullName()] = v2
                v2:Play()
            end
        end
    end
    u96 = task.delay(5, function() -- Line: 472 -- upvalues: u96 (upval)
        u96 = nil
    end)
end

local function playPickupFlash(a1, a2) -- Line: 478
    -- upvalues: TweenService (val), u123 (val)
    local v1, v2
    local Attribute = a1:GetAttribute("DefaultSize")
    if not Attribute then
        return
    end
    local v3 = UDim2.new(Attribute.X.Scale * 1.1, Attribute.X.Offset * 1.1, Attribute.Y.Scale * 1.1, Attribute.Y.Offset * 1.1)
    for i = 1, 6 do
        v1 = TweenService:Create(a1, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageColor3 = u123, Size = v3})
        v1:Play()
        v1.Completed:Wait()
        v2 = TweenService:Create(a1, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageColor3 = a2, Size = Attribute})
        v2:Play()
        v2.Completed:Wait()
    end
end

local function startPickupFlash(a1, a2, a3) -- Line: 518
    -- upvalues: u124 (val), playPickupFlash (val)
    if u124[a1] then
        task.cancel(u124[a1])
        u124[a1] = nil
    end
    local Attribute = a2:GetAttribute("DefaultSize")
    if Attribute then
        a2.ImageColor3 = a3
        a2.Size = Attribute
    end
    u124[a1] = (task.spawn(function() -- Line: 530 -- upvalues: playPickupFlash (upval), a2 (val), a3 (val), u124 (upval), a1 (val)
        playPickupFlash(a2, a3)
        u124[a1] = nil
    end))
end

local function buildInventorySnapshot(a1) -- Line: 536
    local Identifier, _strict_type
    local v1 = {}
    local v2 = nil
    local v3 = nil
    for i, j in a1, v2, v3 do
        _strict_type = j._settings._strict_type
        v1[_strict_type] = {}
        for k, n in j._items do
            Identifier = n.Identifier
            if Identifier then
                v1[_strict_type][Identifier] = true
            end
        end
    end
    return v1
end

local function detectAndFlashNewItems(a1) -- Line: 551
    -- upvalues: buildInventorySnapshot (val), u125 (ref), u126 (ref), startPickupFlash (val), GetPreferenceColor (val)
    -- upvalues: getMeleeImageLabels (val), getWeaponColor (val)
    local Bomb, Grenade_2, Identifier, ImageLabel, _strict_type, v1, v2, v3, v4, v5, v6, v7
    local v8 = buildInventorySnapshot(a1)
    local v9 = nil
    local v10 = nil
    for i, j in a1, v9, v10 do
        _strict_type = j._settings._strict_type
        v7 = u125[_strict_type] or {}
        v1 = nil
        v2 = nil
        for k, n in j._items, v1, v2 do
            Identifier = n.Identifier
            if Identifier and not v7[Identifier] then
                if _strict_type == "Grenade" then
                    v3 = u126.Grenade.Grenades:FindFirstChild((tostring(k)))
                    if v3 then
                        Grenade_2 = v3:FindFirstChild("Grenade")
                        if Grenade_2 and Grenade_2.Visible then
                            startPickupFlash("Grenade_" .. k, Grenade_2, GetPreferenceColor())
                        end
                    end
                elseif _strict_type ~= "C4" then
                    v3 = u126:FindFirstChild(_strict_type)
                    if v3 and v3:FindFirstChild("Weapon") then
                        if _strict_type ~= "Melee" then
                            if not v3 then
                                ImageLabel = nil
                            elseif v3.Name ~= "Melee" then
                                ImageLabel = v3.Weapon:FindFirstChildOfClass("ImageLabel")
                            else
                                v4, v5 = getMeleeImageLabels(v3)
                                ImageLabel = if not v5 then if not v4 then v3.Weapon:FindFirstChildOfClass("ImageLabel") else if not v4.Visible then v3.Weapon:FindFirstChildOfClass("ImageLabel") else v4 else if not v5.Visible then if not v4 then v3.Weapon:FindFirstChildOfClass("ImageLabel") else if not v4.Visible then v3.Weapon:FindFirstChildOfClass("ImageLabel") else v4 else v5
                            end
                        elseif not v3 then
                            ImageLabel = nil
                        elseif v3.Name ~= "Melee" then
                            ImageLabel = v3.Weapon:FindFirstChildOfClass("ImageLabel")
                        else
                            v4, v5 = getMeleeImageLabels(v3)
                            v6 = false
                            if n ~= nil then
                                v6 = n.Name == "Zeus x27"
                            end
                            ImageLabel = v6 and v5 or v4
                        end
                        if ImageLabel and ImageLabel.Visible then
                            startPickupFlash(_strict_type .. "_" .. n.Name, ImageLabel, getWeaponColor(n))
                        end
                    end
                else
                    Bomb = u126.Grenade:FindFirstChild("Bomb")
                    if Bomb and Bomb.Visible then
                        startPickupFlash("C4", Bomb, GetPreferenceColor())
                    end
                end
            end
        end
    end
    u125 = v8
end

local function updateCurrentEquipped(a1, a2) -- Line: 599
    -- upvalues: u91 (ref), u92 (ref), TweenService (val), u93 (ref), getMeleeImageLabels (val)
    -- upvalues: getMeleeWeaponNameLabels (val), u126 (ref), GetPreferenceColor (val), getWeaponColor (val)
    -- upvalues: GetSkinDisplayName (val), getInventoryItemDisplayName (val), u107 (val)
    local v1, v2, v3, v4
    if u91 then
        if u91.Name ~= "Grenade" then
            v1 = u93
            if not v1 then
                v2 = u91
                if not v2 then
                    v1 = nil
                elseif v2.Name ~= "Melee" then
                    v1 = v2.Weapon:FindFirstChildOfClass("ImageLabel")
                else
                    v3, v4 = getMeleeImageLabels(v2)
                    v1 = if not v4 then if not v3 then v2.Weapon:FindFirstChildOfClass("ImageLabel") else if not v3.Visible then v2.Weapon:FindFirstChildOfClass("ImageLabel") else v3 else if not v4.Visible then if not v3 then v2.Weapon:FindFirstChildOfClass("ImageLabel") else if not v3.Visible then v2.Weapon:FindFirstChildOfClass("ImageLabel") else v3 else v4
                end
            end
            v2 = u91
            if v2 then
                if v2.Name ~= "Melee" then
                    local WeaponName = v2.Weapon:FindFirstChild("WeaponName")
                    if WeaponName then
                        WeaponName.Visible = false
                        WeaponName.Text = ""
                    end
                else
                    v3, v4 = getMeleeWeaponNameLabels(v2)
                    if v3 then
                        v3.Visible = false
                        v3.Text = ""
                    end
                    if v4 then
                        v4.Visible = false
                        v4.Text = ""
                    end
                end
            end
            u91.Equip.Visible = false
            if v1 then
                TweenService:Create(v1, TweenInfo.new(0.1), {Size = v1:GetAttribute("DefaultSize")}):Play()
            end
        else
            v1 = (u91:WaitForChild("Grenades")):FindFirstChild((tostring(u92)))
            if v1 then
                local Grenade = v1:FindFirstChild("Grenade")
                TweenService:Create(Grenade, TweenInfo.new(0.1), {Size = Grenade:GetAttribute("DefaultSize")}):Play()
            end
        end
    end
    v1 = u126:FindFirstChild((tostring(a2.Properties.Slot)))
    u91 = v1
    u93 = nil
    if v1 then
        if v1.Name ~= "Grenade" then
            local ImageLabel, WeaponName_2, v5
            if not v1 then
                ImageLabel = nil
            elseif v1.Name ~= "Melee" then
                ImageLabel = v1.Weapon:FindFirstChildOfClass("ImageLabel")
            else
                v3, v4 = getMeleeImageLabels(v1)
                v5 = false
                if a2 ~= nil then
                    v5 = a2.Name == "Zeus x27"
                end
                ImageLabel = v5 and v4 or v3
            end
            if not v1 then
                WeaponName_2 = nil
            elseif v1.Name ~= "Melee" then
                WeaponName_2 = v1.Weapon:FindFirstChild("WeaponName")
            else
                v4, v5 = getMeleeWeaponNameLabels(v1)
                local v6 = false
                if a2 ~= nil then
                    v6 = a2.Name == "Zeus x27"
                end
                WeaponName_2 = v6 and v5 or v4
            end
            u93 = ImageLabel
            if ImageLabel then
                ImageLabel.ImageColor3 = getWeaponColor(a2)
            end
            if v1 then
                if v1.Name ~= "Melee" then
                    local WeaponName_3 = v1.Weapon:FindFirstChild("WeaponName")
                    if WeaponName_3 then
                        WeaponName_3.Visible = false
                        WeaponName_3.Text = ""
                    end
                else
                    v4, v5 = getMeleeWeaponNameLabels(v1)
                    if v4 then
                        v4.Visible = false
                        v4.Text = ""
                    end
                    if v5 then
                        v5.Visible = false
                        v5.Text = ""
                    end
                end
            end
            if WeaponName_2 then
                WeaponName_2.TextColor3 = getWeaponColor(a2)
                GetSkinDisplayName.ApplyNameLabel(WeaponName_2, getInventoryItemDisplayName(a2, v1.Name), a2.NameTag)
                WeaponName_2.Visible = true
            end
            v1.Equip.Visible = true
            if ImageLabel then
                TweenService:Create(ImageLabel, TweenInfo.new(0.1), {
                    Size = (ImageLabel:GetAttribute("DefaultSize")) + UDim2.fromScale(0.1, 0.1),
                }):Play()
            end
        else
            v2 = v1.Grenades:FindFirstChild((tostring(a1)))
            u92 = a1
            if v2 then
                local Grenade_2 = v2:FindFirstChild("Grenade")
                Grenade_2.ImageColor3 = GetPreferenceColor()
                TweenService:Create(Grenade_2, TweenInfo.new(0.1), {
                    Size = (Grenade_2:GetAttribute("DefaultSize")) + UDim2.fromScale(0.1, 0.1),
                }):Play()
            end
        end
    end
    if not u107 then
        return
    end
    local CycleWeaponsIcons = v1 and v1:FindFirstChild("CycleWeaponsIcons")
    if CycleWeaponsIcons then
        CycleWeaponsIcons.Visible = u107
    end
end

local function convertInventoryDataToServerLoadout(a1) -- Line: 676 -- upvalues: u108 (val) -- types: a1: table
    if a1 and #a1 ~= 0 then
        local _settings, _strict_slot_space, _strict_type, v1, v2, v3
        local v4 = {}
        for i = 1, 5 do
            v1 = a1[i]
            _settings = if not v1 then nil else v1._settings
            v2 = {_items = {}}
            v3 = {}
            _strict_slot_space = if not _settings then u108[i].space else _settings._strict_slot_space
            v3._strict_slot_space = _strict_slot_space
            _strict_type = if not _settings then u108[i].type else _settings._strict_type
            v3._strict_type = _strict_type
            v2._settings = v3
            v4[i] = v2
            if v1 then
                for i2, v in ipairs(v1._items) do
                    table.insert(v4[i]._items, v)
                end
            end
        end
        return v4
    end
    return nil
end

local function updateInventoryFrame(a1, a2) -- Line: 702
    -- upvalues: GetPreferenceColor (val), u126 (ref), LocalPlayer (val), InventoryController (val)
    -- upvalues: updateMeleeInventoryFrame (val), getWeaponColor (val), GetSkinDisplayName (val)
    -- upvalues: getInventoryItemDisplayName (val), GetInventoryItemIcon (val)
    local Weapon, v1, v2, v3, v4, v5, v6, v7
    local v8 = GetPreferenceColor()
    u126.Grenade.DefuseKit.ImageColor3 = v8
    u126.Grenade.Bomb.ImageColor3 = v8
    local v9 = a2 or LocalPlayer
    local DefuseKit = u126.Grenade.DefuseKit
    if not v9 then
        v6 = false
    elseif v9:GetAttribute("Team") == "Counter-Terrorists" then
        local Attribute = workspace:GetAttribute("Gamemode")
        local v10 = if Attribute ~= "Bomb Defusal" then if Attribute ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
        v6 = false
        if v10 ~= nil then
            v6 = v9:GetAttribute(v10) == true
        end
    else
        v6 = false
    end
    DefuseKit.Visible = v6
    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        u126.Grenade.Bomb.Visible = false
    end
    v9 = InventoryController.getCurrentEquipped()
    local v11, v12 = a1, a2
    for i, v in ipairs(a1) do
        if v._settings._strict_type == "Melee" then
            updateMeleeInventoryFrame(u126.Melee, v, v9)
        elseif v._settings._strict_slot_space == 1 then
            v7 = u126:FindFirstChild(v._settings._strict_type)
            if v7 then
                v1 = v._items[1]
                if not v1 then
                    v7.Equip.Visible = false
                    v7.Weapon.WeaponName.Text = ""
                    v7.Weapon.WeaponName.Visible = false
                    for j, k in v7.Weapon:GetChildren() do
                        if k:IsA("ImageLabel") then
                            k.Visible = false
                        end
                    end
                else
                    Weapon = v7:FindFirstChild("Weapon")
                    v7:SetAttribute("Slot", v1.Slot)
                    v7.Keybind.Text = v1.Slot
                    if Weapon then
                        v2 = v7.Weapon:FindFirstChild(v1.Properties.Class)
                        v7.Weapon.WeaponName.TextColor3 = getWeaponColor(v1)
                        GetSkinDisplayName.ApplyNameLabel(
                            v7.Weapon.WeaponName,
                            getInventoryItemDisplayName(v1, v._settings._strict_type),
                            v1.NameTag
                        )
                        v3 = v9 and v9.Properties.Slot == v._settings._strict_type
                        v7.Weapon.WeaponName.Visible = v3
                        if v2 then
                            for n, m in v7.Weapon:GetChildren() do
                                if m:IsA("ImageLabel") then
                                    v5 = m == v2
                                    m.Visible = v5
                                end
                            end
                            v2.Image = v1.Properties.Icon
                            v2.ImageColor3 = getWeaponColor(v1)
                        end
                    end
                end
            elseif v._settings._strict_type == "C4" then
                u126.Grenade.Bomb.Visible = v._items[1]
            end
        elseif v._settings._strict_type == "Grenade" then
            for i2 = 1, 4 do
                v2 = u126.Grenade.Grenades:FindFirstChild((tostring(i2)))
                if v2 then
                    v3 = v._items[i2]
                    if not v3 then
                        v2.Grenade.Visible = false
                        v2.Dot.Visible = true
                    else
                        v2.Grenade.ImageColor3 = v8
                        v2.Grenade.Visible = true
                        v2.Dot.Visible = false
                        v4 = GetInventoryItemIcon(v3, (v12 or LocalPlayer):GetAttribute("Team"))
                        if v4 then
                            v2.Grenade.Image = v4
                        end
                    end
                end
            end
        end
    end
    for i5, i6 in u126:GetChildren() do
        if i6:IsA("Frame") then
            v7 = i6.Name == "Grenade"
            for i7, i8 in v11 do
                if #i8._items > 0 and i8._settings._strict_type == i6.Name then
                    v7 = true
                    break
                end
            end
            i6.Visible = v7
        end
    end
end

local function updateBotInventoryFrame(a1) -- Line: 809
    -- upvalues: u108 (val), HttpService (val), GetWeaponProperties (val), updateInventoryFrame (val)
    -- upvalues: updateCurrentEquipped (val)
    local v1, v2
    local v3 = {}
    for i, j in u108 do
        v2 = {_items = {}, _settings = {_strict_slot_space = j.space, _strict_type = j.type}}
        v3[i] = v2
    end
    local Attribute = a1:GetAttribute("BotGrenades")
    local success, result = pcall(HttpService.JSONDecode, HttpService, if type(Attribute) ~= "string" then "[]" else Attribute)
    local v4 = if not success then {} else if type(result) ~= "table" then {} else result
    local v5 = nil
    v2 = nil
    local v6 = a1
    for k, n in v4, v5, v2 do
        v1 = if type(n) ~= "string" then nil else GetWeaponProperties(n)
        if v1 and #v3[4]._items < u108[4].space then
            table.insert(v3[4]._items, {
                Skin = "Stock",
                Float = 0,
                Slot = 4,
                Name = n,
                Identifier = ("%*:%*"):format(n, k),
                Properties = v1,
            })
        end
    end
    local Attribute_2 = v6:GetAttribute("CurrentEquipped")
    local success_2, result_2 = pcall(HttpService.JSONDecode, HttpService, if type(Attribute_2) ~= "string" then "" else Attribute_2)
    local v7 = success_2
    if v7 then
        v7 = false
        if type(result_2) == "table" then
            v7 = type(result_2.Name) == "string"
        end
    end
    local v8 = if not v7 then nil else GetWeaponProperties(result_2.Name)
    v1 = nil
    local v9 = 1
    if v8 then
        local Identifier, v10
        local v11 = nil
        local v12 = nil
        for m, i5 in u108, v11, v12 do
            if i5.type == v8.Slot and i5.type == "Grenade" then
                for i6, i7 in v3[m]._items do
                    if i7.Name == result_2.Name then
                        v1 = i7
                        v9 = i6
                        updateInventoryFrame(v3, v6)
                        if v1 then
                            updateCurrentEquipped(v9, v1)
                        end
                        return
                    end
                end
                break
            end
            if i5.type == v8.Slot then
                v10 = {
                    Name = result_2.Name,
                    Skin = result_2.Skin,
                    Float = result_2.Float,
                }
                Identifier = result_2.Identifier or result_2.Name
                v10.Identifier = Identifier
                v10.Properties = v8
                v10.Slot = m
                table.insert(v3[m]._items, v10)
                break
            end
        end
    end
    updateInventoryFrame(v3, v6)
    if v1 then
        updateCurrentEquipped(v9, v1)
    end
end

local function disconnectBotInventory() -- Line: 873 -- upvalues: u94 (ref)
    if u94 then
        u94:Disconnect()
        u94 = nil
    end
end

local function refreshSpectatedInventory(a1) -- Line: 880
    -- upvalues: u94 (ref), Participants (val), Remotes (val), SpectateController (val), updateBotInventoryFrame (val)
    -- upvalues: u126 (ref)
    if u94 then
        u94:Disconnect()
        u94 = nil
    end
    if not Participants.IsBot(a1) then
        Remotes.Inventory.RequestSpectatedPlayerInventory.Send(a1)
        return
    end
    u94 = a1.AttributeChanged:Connect(function(a1_2) -- Line: 886
        -- upvalues: SpectateController (upval), a1 (val), updateBotInventoryFrame (upval), u126 (upval)
        if SpectateController.GetPlayer() ~= a1 then
            return
        end
        if a1_2 ~= "CurrentEquipped" and a1_2 ~= "BotGrenades" then
            if a1_2 == "HasDefuseKit" or a1_2 == "HasRescueKit" or a1_2 == "Team" then
                local v1
                local v2 = a1
                local DefuseKit = u126.Grenade.DefuseKit
                if not v2 then
                    v1 = false
                elseif v2:GetAttribute("Team") == "Counter-Terrorists" then
                    local Attribute = workspace:GetAttribute("Gamemode")
                    local v3 = if Attribute ~= "Bomb Defusal" then if Attribute ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
                    v1 = false
                    if v3 ~= nil then
                        v1 = v2:GetAttribute(v3) == true
                    end
                else
                    v1 = false
                end
                DefuseKit.Visible = v1
            end
            return
        end
        updateBotInventoryFrame(a1)
    end)
    updateBotInventoryFrame(a1)
end

local function restoreLocalEquipped(a1) -- Line: 900 -- upvalues: InventoryController (val), updateCurrentEquipped (val)
    local v1 = InventoryController.getCurrentEquipped()
    if a1 and v1 and v1.Identifier then
        local v2
        for i = 1, 5 do
            v2 = a1[i]
            if v2 and v2._items then
                for i2, v in ipairs(v2._items) do
                    if v.Identifier == v1.Identifier then
                        updateCurrentEquipped(i2, v)
                        return
                    end
                end
            end
        end
        return
    end
end

function v1.Initialize(a1, a2) -- Line: 921
    -- upvalues: u126 (ref), GetUserPlatform (val), EquipInventorySlot (val), InventoryController (val)
    local Size
    u126 = a2
    local v1 = table.find(GetUserPlatform(), "Mobile") ~= nil
    u126.Visible = not v1
    u126.Active = false
    for i, j in u126:QueryDescendants("GuiObject") do
        j.Active = false
    end
    for k, n in u126:QueryDescendants("ImageLabel, ImageButton") do
        if n.Parent.Name == "Weapon" or n.Name == "Grenade" or n.Name == "Bomb" then
            Size = n.Size
            n:SetAttribute("DefaultSize", Size)
        end
    end
    for m, i5 in u126:GetChildren() do
        if i5:IsA("Frame") and i5:FindFirstChild("Button") then
            i5.Button.MouseButton1Click:Connect(function() -- Line: 941 -- upvalues: i5 (val), EquipInventorySlot (upval)
                local Attribute = i5:GetAttribute("Slot")
                if Attribute then
                    EquipInventorySlot(Attribute)
                end
            end)
        end
    end
    for i6, i7 in u126.Grenade.Grenades:GetChildren() do
        if i7:IsA("Frame") then
            (i7:FindFirstChild("Button")).MouseButton1Click:Connect(function() -- Line: 952 -- upvalues: InventoryController (upval), i7 (val)
                InventoryController.equip(4, (tonumber(i7.Name)))
            end)
        end
    end
    local Bomb = u126.Grenade.Bomb
    if Bomb:IsA("ImageButton") then
        Bomb.MouseButton1Click:Connect(function() -- Line: 960 -- upvalues: Bomb (val), InventoryController (upval)
            if Bomb.Visible then
                InventoryController.equip(5, 1)
            end
        end)
    end
end

local function getSpectatedPlayer() -- Line: 969 -- upvalues: LocalPlayer (val), SpectateController (val)
    if LocalPlayer:GetAttribute("IsSpectating") == true then
        return SpectateController.GetPlayer()
    end
    return nil
end

function v1.Start() -- Line: 976
    -- upvalues: InventoryController (val), LocalPlayer (val), updateInventoryFrame (val), detectAndFlashNewItems (val)
    -- upvalues: updateCurrentEquipped (val), DataController (val), startFade (val), u126 (ref), getWeaponColor (val)
    -- upvalues: getMeleeImageLabels (val), getMeleeWeaponNameLabels (val), SpectateController (val)
    -- upvalues: refreshSpectatedInventory (val), Remotes (val), convertInventoryDataToServerLoadout (val), u94 (ref)
    -- upvalues: restoreLocalEquipped (val), Players (val)
    local v1, v2, v3
    InventoryController.OnInventoryChanged:Connect(function(a1) -- Line: 978 -- upvalues: LocalPlayer (upval), updateInventoryFrame (upval), detectAndFlashNewItems (upval)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            updateInventoryFrame(a1)
            detectAndFlashNewItems(a1)
        end
    end)
    InventoryController.OnInventoryItemEquipped:Connect(function(a1, a2) -- Line: 987
        -- upvalues: updateCurrentEquipped (upval), DataController (upval), LocalPlayer (upval), startFade (upval)
        updateCurrentEquipped(a1, a2)
        if not (DataController.Get(LocalPlayer, "Settings.Game.Item.Always Show Inventory") ~= false) then
            local Slot = a2.Properties.Slot
            if Slot == "Primary" or Slot == "Secondary" or Slot == "Melee" or Slot == "Grenade" then
                startFade()
            end
        end
    end)
    local v4 = LocalPlayer
    DataController.CreateListener(v4, "Settings.Game.HUD.Glow Weapon with Rarity Color", function() -- Line: 1002
        -- upvalues: InventoryController (upval), updateInventoryFrame (upval), u126 (upval), getWeaponColor (upval)
        -- upvalues: getMeleeImageLabels (upval), getMeleeWeaponNameLabels (upval)
        local v1 = InventoryController.getCurrentInventory()
        if v1 then
            updateInventoryFrame(v1)
        end
        local v2 = InventoryController.getCurrentEquipped()
        if v2 then
            local v3 = u126:FindFirstChild((tostring(v2.Properties.Slot)))
            if v3 and v3.Name ~= "Grenade" then
                local ImageLabel, WeaponName, v4, v5
                local v6 = getWeaponColor(v2)
                if not v3 then
                    ImageLabel = nil
                elseif v3.Name ~= "Melee" then
                    ImageLabel = v3.Weapon:FindFirstChildOfClass("ImageLabel")
                else
                    local v7
                    v7, v4 = getMeleeImageLabels(v3)
                    v5 = false
                    if v2 ~= nil then
                        v5 = v2.Name == "Zeus x27"
                    end
                    ImageLabel = v5 and v4 or v7
                end
                if ImageLabel then
                    ImageLabel.ImageColor3 = v6
                end
                if not v3 then
                    WeaponName = nil
                elseif v3.Name ~= "Melee" then
                    WeaponName = v3.Weapon:FindFirstChild("WeaponName")
                else
                    v4, v5 = getMeleeWeaponNameLabels(v3)
                    local v8 = false
                    if v2 ~= nil then
                        v8 = v2.Name == "Zeus x27"
                    end
                    WeaponName = v8 and v5 or v4
                end
                if WeaponName then
                    WeaponName.TextColor3 = v6
                end
            end
        end
    end)
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 1026
        -- upvalues: LocalPlayer (upval), SpectateController (upval), refreshSpectatedInventory (upval)
        -- upvalues: InventoryController (upval), updateInventoryFrame (upval)
        local v1
        if LocalPlayer:GetAttribute("IsSpectating") ~= true then
            v1 = InventoryController.getCurrentInventory()
            if v1 then
                updateInventoryFrame(v1)
            end
            return
        end
        v1 = SpectateController.GetPlayer()
        if not v1 then
            return
        end
        refreshSpectatedInventory(v1)
    end)

    local function updateLocalObjectiveKitIcon() -- Line: 1044 -- upvalues: LocalPlayer (upval), u126 (upval)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            local v1
            local v2 = LocalPlayer
            local DefuseKit = u126.Grenade.DefuseKit
            if not v2 then
                v1 = false
            elseif v2:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode")
                local v3 = if Attribute ~= "Bomb Defusal" then if Attribute ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
                v1 = false
                if v3 ~= nil then
                    v1 = v2:GetAttribute(v3) == true
                end
            else
                v1 = false
            end
            DefuseKit.Visible = v1
        end
    end

    ;(LocalPlayer:GetAttributeChangedSignal("HasDefuseKit")):Connect(updateLocalObjectiveKitIcon)
    ;(LocalPlayer:GetAttributeChangedSignal("HasRescueKit")):Connect(updateLocalObjectiveKitIcon)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(function() -- Line: 1055
        -- upvalues: LocalPlayer (upval), u126 (upval), SpectateController (upval), refreshSpectatedInventory (upval)
        -- upvalues: InventoryController (upval), updateInventoryFrame (upval)
        local v1
        if not LocalPlayer:GetAttribute("IsSpectating") then
            local v2
            v1 = LocalPlayer
            local DefuseKit = u126.Grenade.DefuseKit
            if not v1 then
                v2 = false
            elseif v1:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode")
                local v3 = if Attribute ~= "Bomb Defusal" then if Attribute ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
                v2 = false
                if v3 ~= nil then
                    v2 = v1:GetAttribute(v3) == true
                end
            else
                v2 = false
            end
            DefuseKit.Visible = v2
        end
        if LocalPlayer:GetAttribute("IsSpectating") ~= true then
            v1 = InventoryController.getCurrentInventory()
            if v1 then
                updateInventoryFrame(v1)
            end
            return
        end
        v1 = SpectateController.GetPlayer()
        if not v1 then
            return
        end
        refreshSpectatedInventory(v1)
    end)
    Remotes.Inventory.SpectatedPlayerInventory.Listen(function(a1) -- Line: 1062
        -- upvalues: LocalPlayer (upval), SpectateController (upval), convertInventoryDataToServerLoadout (upval)
        -- upvalues: updateInventoryFrame (upval), updateCurrentEquipped (upval)
        if LocalPlayer:GetAttribute("IsSpectating") ~= true then
            return
        end
        local v1 = SpectateController.GetPlayer()
        if v1 and a1.Player == v1 then
            local v2 = convertInventoryDataToServerLoadout(a1.Inventory)
            if not v2 then
                return
            end
            updateInventoryFrame(v2, v1)
            local v3 = a1.EquippedSlot or 0
            local v4 = a1.EquippedSlotSpace or 0
            if v3 > 0 and v4 > 0 then
                local v5 = v2[v3]
                if v5 and v5._items and v5._items[v4] then
                    local v6 = v5._items[v4]
                    updateCurrentEquipped(v4, v6)
                end
            end
            return
        end
    end)
    SpectateController.ListenToSpectate:Connect(function(a1) -- Line: 1090
        -- upvalues: refreshSpectatedInventory (upval), u126 (upval), u94 (upval), InventoryController (upval)
        -- upvalues: updateInventoryFrame (upval), restoreLocalEquipped (upval), LocalPlayer (upval)
        local v1, v2
        if a1 then
            refreshSpectatedInventory(a1)
            local DefuseKit = u126.Grenade.DefuseKit
            if not a1 then
                v1 = false
            elseif a1:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode")
                local v3 = if Attribute ~= "Bomb Defusal" then if Attribute ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
                v1 = false
                if v3 ~= nil then
                    v1 = a1:GetAttribute(v3) == true
                end
            else
                v1 = false
            end
            DefuseKit.Visible = v1
            return
        end
        if u94 then
            u94:Disconnect()
            u94 = nil
        end
        local v4 = InventoryController.getCurrentInventory()
        if v4 then
            updateInventoryFrame(v4)
        end
        restoreLocalEquipped(v4)
        v1 = LocalPlayer
        local DefuseKit_2 = u126.Grenade.DefuseKit
        if not v1 then
            v2 = false
        elseif v1:GetAttribute("Team") == "Counter-Terrorists" then
            local Attribute_2 = workspace:GetAttribute("Gamemode")
            local v5 = if Attribute_2 ~= "Bomb Defusal" then if Attribute_2 ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
            v2 = false
            if v5 ~= nil then
                v2 = v1:GetAttribute(v5) == true
            end
        else
            v2 = false
        end
        DefuseKit_2.Visible = v2
    end)

    local function updateSpectatedObjectiveKit() -- Line: 1109
        -- upvalues: LocalPlayer (upval), SpectateController (upval), u126 (upval)
        local v1 = if LocalPlayer:GetAttribute("IsSpectating") ~= true then nil else SpectateController.GetPlayer()
        if v1 then
            local v2
            local DefuseKit = u126.Grenade.DefuseKit
            if not v1 then
                v2 = false
            elseif v1:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode")
                local v3 = if Attribute ~= "Bomb Defusal" then if Attribute ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
                v2 = false
                if v3 ~= nil then
                    v2 = v1:GetAttribute(v3) == true
                end
            else
                v2 = false
            end
            DefuseKit.Visible = v2
        end
    end

    local function connectObjectiveKitSignals(a1) -- Line: 1116
        -- upvalues: LocalPlayer (upval), updateSpectatedObjectiveKit (val)
        if a1 == LocalPlayer then
            return
        end
        ;(a1:GetAttributeChangedSignal("HasDefuseKit")):Connect(updateSpectatedObjectiveKit)
        ;(a1:GetAttributeChangedSignal("HasRescueKit")):Connect(updateSpectatedObjectiveKit)
        ;(a1:GetAttributeChangedSignal("Team")):Connect(updateSpectatedObjectiveKit)
    end

    for i, v in ipairs(Players:GetPlayers()) do
        connectObjectiveKitSignals(v)
    end
    Players.PlayerAdded:Connect(connectObjectiveKitSignals)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(function() -- Line: 1131 -- upvalues: LocalPlayer (upval), SpectateController (upval), u126 (upval)
        local v1, v2, v3
        if not LocalPlayer:GetAttribute("IsSpectating") then
            v1 = LocalPlayer
            local DefuseKit_2 = u126.Grenade.DefuseKit
            if not v1 then
                v2 = false
            elseif v1:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute_2 = workspace:GetAttribute("Gamemode")
                v3 = if Attribute_2 ~= "Bomb Defusal" then if Attribute_2 ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
                v2 = false
                if v3 ~= nil then
                    v2 = v1:GetAttribute(v3) == true
                end
            else
                v2 = false
            end
            DefuseKit_2.Visible = v2
            return
        end
        if not (if LocalPlayer:GetAttribute("IsSpectating") ~= true then nil else SpectateController.GetPlayer()) then
            return
        end
        local DefuseKit = u126.Grenade.DefuseKit
        if not v1 then
            v2 = false
        elseif v1:GetAttribute("Team") == "Counter-Terrorists" then
            local Attribute = workspace:GetAttribute("Gamemode")
            v3 = if Attribute ~= "Bomb Defusal" then if Attribute ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
            v2 = false
            if v3 ~= nil then
                v2 = v1:GetAttribute(v3) == true
            end
        else
            v2 = false
        end
        DefuseKit.Visible = v2
    end)
    if not LocalPlayer:GetAttribute("IsSpectating") then
        v1 = LocalPlayer
        local DefuseKit_2 = u126.Grenade.DefuseKit
        if not v1 then
            v2 = false
        elseif v1:GetAttribute("Team") == "Counter-Terrorists" then
            local Attribute_2 = workspace:GetAttribute("Gamemode")
            v3 = if Attribute_2 ~= "Bomb Defusal" then if Attribute_2 ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
            v2 = false
            if v3 ~= nil then
                v2 = v1:GetAttribute(v3) == true
            end
        else
            v2 = false
        end
        DefuseKit_2.Visible = v2
    else
        v1 = if LocalPlayer:GetAttribute("IsSpectating") ~= true then nil else SpectateController.GetPlayer()
        if v1 then
            local DefuseKit = u126.Grenade.DefuseKit
            if not v1 then
                v2 = false
            elseif v1:GetAttribute("Team") == "Counter-Terrorists" then
                local Attribute = workspace:GetAttribute("Gamemode")
                v3 = if Attribute ~= "Bomb Defusal" then if Attribute ~= "Hostage Rescue" then nil else "HasRescueKit" else "HasDefuseKit"
                v2 = false
                if v3 ~= nil then
                    v2 = v1:GetAttribute(v3) == true
                end
            else
                v2 = false
            end
            DefuseKit.Visible = v2
        end
    end

    local function requestSpectatedInventoryUpdate() -- Line: 1146
        -- upvalues: LocalPlayer (upval), SpectateController (upval), refreshSpectatedInventory (upval)
        local v1 = if LocalPlayer:GetAttribute("IsSpectating") ~= true then nil else SpectateController.GetPlayer()
        if v1 then
            refreshSpectatedInventory(v1)
        end
    end

    Remotes.Inventory.NewInventoryItem.Listen(requestSpectatedInventoryUpdate)
    Remotes.Inventory.RemoveInventoryItem.Listen(requestSpectatedInventoryUpdate)
    DataController.CreateListener(LocalPlayer, "Settings.Game.Item.Always Show Inventory", startFade)
    task.wait(0.1)
    if DataController.Get(LocalPlayer, "Settings.Game.Item.Always Show Inventory") == false then
        startFade()
    end
end

return v1