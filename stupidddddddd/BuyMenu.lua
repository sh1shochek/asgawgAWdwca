-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu
-- Decompile time: 47.69 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea)
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock)
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Spring = require(ReplicatedStorage.Shared.Spring)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local BuyMenuInfo = require(script:WaitForChild("BuyMenuInfo"))
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots)
local u167 = Color3.fromRGB(149, 149, 149)
local u168 = {"CompetitivePlayerColor", "Armor", "HasDefuseKit", "HasRescueKit"}
local u174 = Janitor.new()
local u176 = Janitor.new()
local u181 = Spring.new(1, 8, 0)
local u182 = {}
local u183 = false
local u184 = nil
local u185 = nil
local u186 = {["1"] = "Kevlar", ["2"] = "Kevlar + Helmet"}
local u189 = {Kevlar = true, ["Kevlar + Helmet"] = true, ["Defuse Kit"] = true, ["Rescue Kit"] = true}
local u194 = {Terrorists = {"Glock-18"}, ["Counter-Terrorists"] = {"USP-S", "P2000"}}
local u200 = {}
local v1 = {Name = "Yellow", Color = Color3.fromRGB(255, 221, 51)}
local v2 = {Name = "Green", Color = Color3.fromRGB(0, 153, 0)}
local v3 = {Name = "Blue", Color = Color3.fromRGB(0, 102, 204)}
local v4 = {Name = "Purple", Color = Color3.fromRGB(153, 51, 204)}
local v5 = {Name = "Orange", Color = Color3.fromRGB(255, 128, 0)}
u200[1] = v1
u200[2] = v2
u200[3] = v3
u200[4] = v4
u200[5] = v5
local u232 = Janitor.new()
local u233 = {}
local u234 = {}
local u235 = nil
local u236 = {}
local u237 = {}
local u238 = nil
local u243 = Color3.fromRGB(255, 255, 255)
local u244 = {1, 2, 3, 4}
local u253 = Color3.fromRGB(255, 70, 70)
local u258 = Color3.fromRGB(235, 40, 40)

local function CommaNumber(a1) -- Line: 159 -- types: a1: number
    return tostring(a1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function GetInventoryItemFromIdentifier(a1, a2) -- Line: 163 -- types: a1: table, a2: string
    for i, v in ipairs(a1) do
        if v._id == a2 then
            return v
        end
    end
    return nil
end

local function ResolveTemplateInventoryItem(a1) -- Line: 176 -- upvalues: DataController (val), LocalPlayer (val)
    local Attribute = a1:GetAttribute("InventoryItemId")
    if Attribute and Attribute ~= "" and Attribute ~= "__buymenu_zeus_placeholder__" then
        if string.sub(Attribute, 1, 10) == "equipment:" then
            return nil
        end
        local v1 = DataController.Get(LocalPlayer, "Inventory")
        if v1 and typeof(v1) == "table" then
            for i, v in ipairs(v1) do
                if v._id == Attribute then
                    return v
                end
            end
            return nil
        end
        return nil
    end
    return nil
end

local function ResolveTemplateSkinName(a1) -- Line: 192 -- upvalues: ResolveTemplateInventoryItem (val)
    local v1 = ResolveTemplateInventoryItem(a1)
    local Skin = v1 and v1.Skin
    if typeof(Skin) == "string" and Skin ~= "" then
        return Skin
    end
    return nil
end

local function ShowWeaponInfoFrame(a1) -- Line: 199
    -- upvalues: u184 (ref), ResolveTemplateInventoryItem (val), Skins (val), GetSkinDisplayName (val), Rarities (val)
    -- upvalues: u243 (val), BuyMenuInfo (val), u244 (val)
    local Attribute = a1:GetAttribute("Weapon")
    if Attribute and Attribute ~= "" then
        local v1, v2, v3, v4
        local WeaponInfoFrame = u184.WeaponInfoFrame
        local v5 = ResolveTemplateInventoryItem(a1)
        local Skin = v5 and v5.Skin
        local v6 = if typeof(Skin) ~= "string" then nil else if Skin == "" then nil else Skin
        local rarity = nil
        if v6 and v6 ~= "Stock" then
            v3 = Skins.GetSkinInformation(Attribute, v6)
            if v3 and v3.rarity then
                rarity = v3.rarity
            end
        end
        v3 = ResolveTemplateInventoryItem(a1)
        local v7 = GetSkinDisplayName.GetWeaponDisplayName(Attribute, v3 and v3.NameTag)
        if not v6 or v6 == "Stock" or not rarity then
            GetSkinDisplayName.ApplyNameLabel(WeaponInfoFrame.WeaponName, v7, v3 and v3.NameTag)
            WeaponInfoFrame.WeaponName.TextColor3 = u243
        else
            v4 = Rarities[rarity]
            GetSkinDisplayName.ApplyNameLabel(
                WeaponInfoFrame.WeaponName,
                ("%* | %*"):format(v7, (GetSkinDisplayName(v6))),
                v3 and v3.NameTag
            )
            WeaponInfoFrame.WeaponName.TextColor3 = v4 and v4.Color or u243
        end
        v4 = BuyMenuInfo.Weapons[Attribute]
        local Stats = WeaponInfoFrame.Stats
        local Stars = v4 and v4.Stars or 0
        Stats.Info.Text = v4 and v4.Info or ""
        Stats.Tip.Text = v4 and v4.Tip or ""
        local v8 = Stars >= 1 and BuyMenuInfo.GetStarColor(Stars) or u243
        for i, v in ipairs(u244) do
            v1 = Stats.Difficulty:FindFirstChild((tostring(v)))
            if v1 then
                v1.Visible = v <= Stars
                if v2 then
                    v1.ImageColor3 = v8
                end
            end
        end
        WeaponInfoFrame.Visible = true
        return
    end
end

local function HideWeaponInfoFrame() -- Line: 254 -- upvalues: u184 (ref)
    if u184 and u184.WeaponInfoFrame then
        u184.WeaponInfoFrame.Visible = false
    end
end

local function IsObjectiveEquipmentAvailableForPlayer(a1, a2, a3) -- Line: 260 -- types: a1: string, a2: string?
    if a2 ~= "Counter-Terrorists" then
        return false
    end
    if a1 == "Defuse Kit" then
        return a3 == "Bomb Defusal"
    end
    if a1 == "Rescue Kit" then
        return a3 == "Hostage Rescue"
    end
    return true
end

local function IsCompetitiveServerGamemode() -- Line: 278
    return workspace:GetAttribute("ServerGamemode") == "Competitive"
end

local function IsEquipmentAvailableForLocalPlayer(a1) -- Line: 282
    -- upvalues: u189 (val), LocalPlayer (val)
    if u189[a1] and not (workspace:GetAttribute("ServerGamemode") == "Competitive") then
        return false
    end
    if a1 ~= "Defuse Kit" and a1 ~= "Rescue Kit" then
        return true
    end
    local Attribute = LocalPlayer:GetAttribute("Team")
    local Attribute_2 = workspace:GetAttribute("Gamemode")
    if Attribute ~= "Counter-Terrorists" then
        return false
    end
    if a1 == "Defuse Kit" then
        return Attribute_2 == "Bomb Defusal"
    end
    if a1 == "Rescue Kit" then
        return Attribute_2 == "Hostage Rescue"
    end
    return true
end

local function GetEquipmentByTemplate(a1) -- Line: 296
    -- upvalues: u186 (val), IsEquipmentAvailableForLocalPlayer (val), u189 (val), LocalPlayer (val)
    local v1
    local v2 = u186[a1]
    if v2 then
        if IsEquipmentAvailableForLocalPlayer(v2) then
            return v2
        end
        return nil
    end
    if a1 ~= "3" then
        return nil
    end
    if not u189["Defuse Kit"] or workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local Attribute = LocalPlayer:GetAttribute("Team")
        local Attribute_2 = workspace:GetAttribute("Gamemode")
        v1 = if Attribute == "Counter-Terrorists" then Attribute_2 == "Bomb Defusal" else false
    else
        v1 = false
    end
    if v1 then
        return "Defuse Kit"
    end
    if not u189["Rescue Kit"] or workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local Attribute_3 = LocalPlayer:GetAttribute("Team")
        local Attribute_4 = workspace:GetAttribute("Gamemode")
        v1 = if Attribute_3 == "Counter-Terrorists" then Attribute_4 == "Hostage Rescue" else false
    else
        v1 = false
    end
    if v1 then
        return "Rescue Kit"
    end
    return nil
end

local function GetPlayerArmorState(a1) -- Line: 321 -- upvalues: HttpService (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute("Armor")
    if typeof(Attribute) == "string" and Attribute ~= "" then
        local success, result = pcall(function() -- Line: 324 -- upvalues: HttpService (upval), Attribute (val)
            return HttpService:JSONDecode(Attribute)
        end)
        if success and typeof(result) == "table" then
            return {
                Type = tostring(result.Type or ""),
                Health = tonumber(result.Health) or 0,
            }
        end
    end
    return {Type = "", Health = 0}
end

local function GetDisplayCost(a1, a2) -- Line: 341
    -- upvalues: GameState (val), LocalPlayer (val), GetPlayerArmorState (val)
    local Attribute = workspace:GetAttribute("Gamemode")
    if Attribute ~= "Deathmatch" and Attribute ~= "Tutorial" and GameState.GetState() ~= "Warmup" then
        if workspace:GetAttribute("VIPInfiniteCashEnabled") == true then
            return 0
        end
        local Cost = a2.Cost
        if a1 == "Molotov" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
            return 500
        end
        if a1 == "Kevlar + Helmet" then
            local v1 = GetPlayerArmorState(LocalPlayer)
            if v1.Type == "Kevlar" and 100 <= v1.Health then
                Cost = 350
            end
        end
        return Cost
    end
    return 0
end

local function IsEquipmentOwnedBy(a1, a2) -- Line: 362
    -- upvalues: GetPlayerArmorState (val)
    if a2 == "Defuse Kit" then
        return a1:GetAttribute("HasDefuseKit") == true
    end
    if a2 == "Rescue Kit" then
        return a1:GetAttribute("HasRescueKit") == true
    end
    local v1 = GetPlayerArmorState(a1)
    if a2 ~= "Kevlar" and a2 ~= "Kevlar + Helmet" then
        return false
    end
    local v2 = false
    if 0 < v1.Health then
        v2 = v1.Type == a2
    end
    return v2
end

local function IsEquipmentOwned(a1) -- Line: 377
    -- upvalues: IsEquipmentOwnedBy (val), LocalPlayer (val)
    return (IsEquipmentOwnedBy(LocalPlayer, a1))
end

local function IsEquipmentPurchaseBlockedForLocalPlayer(a1) -- Line: 381
    -- upvalues: IsEquipmentAvailableForLocalPlayer (val), IsEquipmentOwnedBy (val), LocalPlayer (val)
    -- upvalues: GetPlayerArmorState (val)
    if not IsEquipmentAvailableForLocalPlayer(a1) then
        return true
    end
    if a1 ~= "Defuse Kit" and a1 ~= "Rescue Kit" then
        local v1 = GetPlayerArmorState(LocalPlayer)
        local v2 = false
        if v1.Type == "Kevlar + Helmet" then
            v2 = 0 < v1.Health
        end
        local v3 = v2 and 100 <= v1.Health
        if a1 ~= "Kevlar" then
            if a1 == "Kevlar + Helmet" then
                return v2
            end
            return false
        end
        local v4 = false
        if v1.Type == "Kevlar" then
            v4 = 100 <= v1.Health
        end
        return v4 or v3
    end
    return (IsEquipmentOwnedBy(LocalPlayer, a1))
end

local function IsStarterPistolForLocalPlayer(a1) -- Line: 403
    -- upvalues: u194 (val), LocalPlayer (val)
    local v1 = u194[LocalPlayer:GetAttribute("Team")]
    if not v1 then
        return false
    end
    return table.find(v1, a1) ~= nil
end

local function HideTemplate(a1) -- Line: 412
    a1:SetAttribute("IsEquipment", nil)
    a1:SetAttribute("Weapon", nil)
    a1.Visible = false
end

local u276 = nil

local function setupBuyMenuTemplates() -- Line: 421
    -- upvalues: Profiler (val), u276 (ref), u184 (ref), Router (val), LocalPlayer (val), u0 (val), u186 (val)
    -- upvalues: IsEquipmentAvailableForLocalPlayer (val), u189 (val)
    local Attribute, Attribute_2, Attribute_3, Attribute_4, Name, createTemplate, v1, v2, v3, v4, v5
    Profiler.mark("UI.BuyMenu.SetupBuyMenuTemplates")
    u276()
    for i, v in ipairs(u184.Menu.Container:GetDescendants()) do
        if v:IsA("TextButton") then
            if v.Parent.Name ~= "Equipment" then
                v1 = tonumber(v.Name)
                u0.setupTemplate(v, (("Loadout.%*.Options.%*"):format(v.Parent.Name, v1)))
            elseif v.Name ~= "4" then
                Name = v.Name
                v4 = u186[Name]
                if v4 then
                    v2 = if not IsEquipmentAvailableForLocalPlayer(v4) then nil else v4
                elseif Name == "3" then
                    if not u189["Defuse Kit"] or workspace:GetAttribute("ServerGamemode") == "Competitive" then
                        Attribute = LocalPlayer:GetAttribute("Team")
                        Attribute_2 = workspace:GetAttribute("Gamemode")
                        v5 = if Attribute == "Counter-Terrorists" then Attribute_2 == "Bomb Defusal" else false
                    else
                        v5 = false
                    end
                    if not v5 then
                        if not u189["Rescue Kit"] or workspace:GetAttribute("ServerGamemode") == "Competitive" then
                            Attribute_3 = LocalPlayer:GetAttribute("Team")
                            Attribute_4 = workspace:GetAttribute("Gamemode")
                            v5 = if Attribute_3 == "Counter-Terrorists" then Attribute_4 == "Hostage Rescue" else false
                        else
                            v5 = false
                        end
                        v2 = if not v5 then nil else "Rescue Kit"
                    else
                        v2 = "Defuse Kit"
                    end
                else
                    v2 = nil
                end
                if not v2 then
                    v:SetAttribute("IsEquipment", nil)
                    v:SetAttribute("Weapon", nil)
                    v.Visible = false
                else
                    createTemplate = u0.createTemplate
                    v5 = {Name = v2, _id = ("equipment:%*"):format(v2)}
                    createTemplate(v, v5, true, nil)
                end
            else
                v2 = Router.broadcastRouter("GetEquippedInventoryItem", LocalPlayer, "Equipped.Equipped Zeus x27")
                v3 = if not v2 then {Name = "Zeus x27", _id = "__buymenu_zeus_placeholder__"} else if not v2.Name then {Name = "Zeus x27", _id = "__buymenu_zeus_placeholder__"} else v2
                u0.createTemplate(v, v3, false, "Equipped.Equipped Zeus x27")
            end
        end
    end
end

local function GetInventoryItemProperties(a1) -- Line: 468 -- upvalues: ReplicatedStorage (val) -- types: a1: string
    local v1 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(a1) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(a1)
    if not v1 then
        return nil
    end
    return require(v1)
end

local function QueryInventoryItem(a1, a2) -- Line: 486 -- types: a2: string
    for i, v in ipairs(a1) do
        for i2, i3 in ipairs(v._items) do
            if i3.Name == v1 then
                return i3
            end
        end
    end
    return false
end

local function QueryRoundPurchasedInventoryItem(a1, a2) -- Line: 497 -- upvalues: u182 (val) -- types: a2: string
    for i, v in ipairs(a1) do
        for i2, i3 in ipairs(v._items) do
            if i3.Name == v1 and table.find(u182, i3.Identifier) then
                return i3
            end
        end
    end
    return false
end

local function QueryInventoryItemPurchasedThisRound(a1, a2) -- Line: 512
    -- upvalues: QueryRoundPurchasedInventoryItem (val), QueryInventoryItem (val)
    return QueryRoundPurchasedInventoryItem(a1, a2) or QueryInventoryItem(a1, a2)
end

local function IsUnrefundableStarterPistol(a1, a2) -- Line: 520
    -- upvalues: u194 (val), LocalPlayer (val), QueryRoundPurchasedInventoryItem (val)
    local v1 = u194[LocalPlayer:GetAttribute("Team")]
    if not (if v1 then table.find(v1, a1) ~= nil else false) then
        return false
    end
    if not a2 then
        return true
    end
    return not QueryRoundPurchasedInventoryItem(a2, a1)
end

local function GetInventoryItemCount(a1, a2) -- Line: 533 -- types: a2: string
    local v1 = 0
    for i, v in ipairs(a1) do
        for i2, i3 in ipairs(v._items) do
            if i3.Name == v2 then
                v1 = v1 + 1
            end
        end
    end
    return v1
end

local function IsTutorialItemAllowed(a1) -- Line: 545
    -- upvalues: TutorialPurchaseLock (val), LocalPlayer (val)
    return TutorialPurchaseLock.isPurchaseAllowed(LocalPlayer, a1)
end

local u285 = {}

local function IsTutorialPulseWanted(a1, a2) -- Line: 567
    -- upvalues: TutorialPurchaseLock (val), LocalPlayer (val), GetInventoryItemCount (val)
    local v1 = TutorialPurchaseLock.getRequiredItems(LocalPlayer)
    if v1 and table.find(v1, a1) then
        return not (a2 and 0 < (GetInventoryItemCount(a2, a1)))
    end
    return false
end

local function StopTutorialPulse(a1, a2) -- Line: 575 -- upvalues: u285 (val) -- types: a1: userdata, a2: userdata?
    local v1 = u285[a1]
    if not v1 then
        return
    end
    u285[a1] = nil
    local Parent = a1.Parent and a1.Parent:FindFirstChild("Background")
    local v2 = Parent and Parent:FindFirstChild("TutorialRequiredOutline")
    if v2 then
        v2:Destroy()
    end
    v1.Color:Cancel()
    v1.Swell:Cancel()
    v1.Scale.Scale = 1
    a1.ImageColor3 = a2 or v1.RestingColor
end

function u276() -- Line: 592 -- upvalues: u285 (val), StopTutorialPulse (val)
    for i in u285 do
        StopTutorialPulse(i)
    end
end

local function SyncTutorialPulse(a1, a2, a3) -- Line: 603
    -- upvalues: u285 (val), StopTutorialPulse (val), TweenService (val), u253 (val), u258 (val)
    local Background, TutorialPulse, UIStroke, v1, v2
    local Icon = a1.Icon
    local v3 = u285[Icon]
    if not a3 then
        StopTutorialPulse(Icon, a2)
        return
    end
    if not v3 then
        TutorialPulse = Icon:FindFirstChild("TutorialPulse")
        if not TutorialPulse then
            TutorialPulse = Instance.new("UIScale")
            TutorialPulse.Name = "TutorialPulse"
            TutorialPulse.Parent = Icon
        end
        TutorialPulse.Scale = 1
        v1 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        v2 = {
            Color = TweenService:Create(Icon, v1, {ImageColor3 = u253}),
            Swell = TweenService:Create(TutorialPulse, v1, {Scale = 1.1}),
            Scale = TutorialPulse,
            RestingColor = a2 or Icon.ImageColor3,
        }
        u285[Icon] = v2
        v2.Color:Play()
        v2.Swell:Play()
        Background = a1.Background
        if Background and not Background:FindFirstChild("TutorialRequiredOutline") then
            UIStroke = Instance.new("UIStroke")
            UIStroke.Name = "TutorialRequiredOutline"
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Color = u258
            UIStroke.Thickness = 2
            UIStroke.Parent = Background
        end
        return
    end
    if a2 and a2 ~= v3.RestingColor then
        StopTutorialPulse(Icon, a2)
        TutorialPulse = Icon:FindFirstChild("TutorialPulse")
        if not TutorialPulse then
            TutorialPulse = Instance.new("UIScale")
            TutorialPulse.Name = "TutorialPulse"
            TutorialPulse.Parent = Icon
        end
        TutorialPulse.Scale = 1
        v1 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        v2 = {
            Color = TweenService:Create(Icon, v1, {ImageColor3 = u253}),
            Swell = TweenService:Create(TutorialPulse, v1, {Scale = 1.1}),
            Scale = TutorialPulse,
            RestingColor = a2 or Icon.ImageColor3,
        }
        u285[Icon] = v2
        v2.Color:Play()
        v2.Swell:Play()
        Background = a1.Background
        if Background and not Background:FindFirstChild("TutorialRequiredOutline") then
            UIStroke = Instance.new("UIStroke")
            UIStroke.Name = "TutorialRequiredOutline"
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Color = u258
            UIStroke.Thickness = 2
            UIStroke.Parent = Background
        end
        return
    end
end

local function IsTutorialPurchasePending() -- Line: 655
    -- upvalues: InventoryController (val), TutorialPurchaseLock (val), LocalPlayer (val), GetInventoryItemCount (val)
    local u2 = InventoryController.getCurrentInventory()
    return TutorialPurchaseLock.isWaitingOnPurchase(LocalPlayer, function(a1) -- Line: 657 -- upvalues: u2 (val), GetInventoryItemCount (upval) -- types: a1: string
        if not u2 then
            return false
        end
        return 0 < (GetInventoryItemCount(u2, a1))
    end)
end

local function ResetTemplateTeammateIndicators(a1) -- Line: 666 -- upvalues: u200 (val)
    local v1
    local Teammates = a1.Teammates
    Teammates.Visible = false
    for i, v in ipairs(u200) do
        v1 = Teammates[v.Name]
        if v1 then
            v1.Visible = false
        end
    end
end

local function GetCompetitiveTeammateIndicator(a1, a2) -- Line: 677 -- upvalues: u200 (val) -- types: a2: userdata
    local Attribute = a2:GetAttribute("CompetitivePlayerColor")
    if not Attribute then
        return nil
    end
    local Teammates = a1.Teammates
    for i, v in ipairs(u200) do
        if Attribute == v.Color then
            return Teammates[v.Name]
        end
    end
    return nil
end

local function ClearCompetitiveTeammateInventoryCache() -- Line: 693 -- upvalues: u236 (val), u237 (val)
    table.clear(u236)
    table.clear(u237)
end

local function RequestCompetitiveTeammateInventory(a1) -- Line: 698
    -- upvalues: LocalPlayer (val), Players (val), u237 (val), Remotes (val)
    if a1 ~= LocalPlayer and a1:IsDescendantOf(Players) then
        if u237[a1] then
            return
        end
        local Attribute = LocalPlayer:GetAttribute("Team")
        if workspace:GetAttribute("ServerGamemode") == "Competitive" and a1:GetAttribute("Team") == Attribute then
            u237[a1] = true
            Remotes.Inventory.RequestSpectatedPlayerInventory.Send(a1)
            task.delay(0.15, function() -- Line: 714 -- upvalues: u237 (upval), a1 (val)
                u237[a1] = nil
            end)
            return
        end
        return
    end
end

local function RequestCompetitiveTeammateInventories() -- Line: 719
    -- upvalues: LocalPlayer (val), Players (val), RequestCompetitiveTeammateInventory (val)
    if not (workspace:GetAttribute("ServerGamemode") == "Competitive") then
        return
    end
    local Attribute = LocalPlayer:GetAttribute("Team")
    if not Attribute then
        return
    end
    if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
        return
    end
    for i, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v:GetAttribute("Team") == Attribute then
            RequestCompetitiveTeammateInventory(v)
        end
    end
end

local function PlayerHasTemplateItem(a1, a2, a3) -- Line: 736
    -- upvalues: IsEquipmentOwnedBy (val), LocalPlayer (val), InventoryController (val), u236 (val)
    if a3 then
        return (IsEquipmentOwnedBy(a1, a2))
    end
    local v1 = if a1 ~= LocalPlayer then u236[a1] else InventoryController.getCurrentInventory()
    if not v1 then
        return false
    end
    for i, v in ipairs(v1) do
        for i2, i3 in ipairs(v._items) do
            if i3.Name == v2 then
                return true
            end
        end
    end
    return false
end

local function UpdateTemplateTeammateIndicators(a1) -- Line: 759
    -- upvalues: u200 (val), LocalPlayer (val), Players (val), u236 (val), RequestCompetitiveTeammateInventory (val)
    -- upvalues: PlayerHasTemplateItem (val), GetCompetitiveTeammateIndicator (val)
    local v1
    local Teammates = a1.Teammates
    Teammates.Visible = false
    for i, v in ipairs(u200) do
        v1 = Teammates[v.Name]
        if v1 then
            v1.Visible = false
        end
    end
    if a1.Visible and workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local v2
        local Attribute = LocalPlayer:GetAttribute("Team")
        if not Attribute then
            return
        end
        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            return
        end
        local Attribute_2 = a1:GetAttribute("Weapon")
        if not Attribute_2 then
            return
        end
        local v3 = a1:GetAttribute("IsEquipment") == true
        local v4 = false
        local v5 = a1
        for i2, i3 in ipairs(Players:GetPlayers()) do
            if i3:GetAttribute("Team") == Attribute then
                if i3 ~= LocalPlayer and not v3 and not u236[i3] then
                    RequestCompetitiveTeammateInventory(i3)
                end
                if PlayerHasTemplateItem(i3, Attribute_2, v3) then
                    v2 = GetCompetitiveTeammateIndicator(v5, i3)
                    if v2 then
                        v2.Visible = true
                        v4 = true
                    end
                end
            end
        end
        v5.Teammates.Visible = v4
        return
    end
end

local function UpdateAllTeammateIndicators() -- Line: 798
    -- upvalues: Profiler (val), u184 (ref), UpdateTemplateTeammateIndicators (val)
    Profiler.mark("UI.BuyMenu.UpdateAllTeammateIndicators")
    if not u184 then
        return
    end
    for i, v in ipairs(u184.Menu.Container:GetDescendants()) do
        if v:IsA("TextButton") then
            UpdateTemplateTeammateIndicators(v)
        end
    end
end

local function CanCarryDuplicate(a1, a2) -- Line: 811
    -- upvalues: GetInventoryItemCount (val), Grenades (val)
    local v1 = GetInventoryItemCount(a1, a2)
    local v2 = Grenades[a2]
    if v2 then
        return v1 < v2
    end
    return v1 == 0
end

local function WaitForAttribute(a1, a2) -- Line: 820 -- types: a1: userdata, a2: string
    local Attribute = a1:GetAttribute(a2)
    while not Attribute do
        Attribute = a1:GetAttribute(a2)
        task.wait()
    end
    return Attribute
end

local function UpdateBuyMenuTimerText() -- Line: 829 -- upvalues: GameState (val), u184 (ref), GetTimerFormat (val)
    local v1 = GameState.GetState()
    local v2 = nil
    if v1 == "Buy Period" or v1 == "Round In Progress" then
        v2 = workspace:GetAttribute("BuyTimerRemaining")
    end
    if typeof(v2) ~= "number" then
        v2 = workspace:GetAttribute("Timer")
    end
    local v3 = if typeof(v2) ~= "number" then 0 else math.max(0, (math.floor(v2)))
    u184.Menu.TopFrame.Timer.Text = GetTimerFormat(v3)
end

local function ApplyTemplateColor(a1, a2) -- Line: 844 -- types: a2: userdata
    a1.ItemName.TextColor3 = a2
    a1.Keybind.TextColor3 = a2
    a1.Icon.ImageColor3 = a2
    a1.Cost.TextColor3 = a2
end

local function TweenTemplateIcon(a1, a2) -- Line: 851 -- upvalues: TweenService (val) -- types: a2: number
    TweenService:Create(a1.Icon, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(a2, a2)}):Play()
end

local function IsTemplateItemOwned(a1, a2) -- Line: 857
    -- upvalues: InventoryController (val), IsEquipmentOwnedBy (val), LocalPlayer (val), QueryInventoryItem (val)
    local v1 = InventoryController.getCurrentInventory()
    return a2 and IsEquipmentOwnedBy(LocalPlayer, a1) or v1 and QueryInventoryItem(v1, a1)
end

function u0.purchase(a1, a2, a3) -- Line: 866
    -- upvalues: ReplicatedStorage (val), LocalPlayer (val), GetDisplayCost (val)
    -- upvalues: IsEquipmentPurchaseBlockedForLocalPlayer (val), TutorialPurchaseLock (val), IsInBuyArea (val)
    -- upvalues: GameState (val), Grenades (val), InventoryController (val), NumberSlots (val), u182 (val), Router (val)
    -- upvalues: Remotes (val)
    local v1, v2, v3
    local v4 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(a1) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(a1)
    if not (if v4 then require(v4) else nil) then
        return
    end
    local Attribute = LocalPlayer:GetAttribute("Money")
    local v5 = GetDisplayCost(a1, v1)
    local v6 = v5
    local Attribute_2 = workspace:GetAttribute("Gamemode")
    if a3 and IsEquipmentPurchaseBlockedForLocalPlayer(a1) then
        return
    end
    if not TutorialPurchaseLock.isPurchaseAllowed(LocalPlayer, a1) or not IsInBuyArea(LocalPlayer) then
        return
    end
    if Attribute_2 == "Deathmatch" or Attribute_2 == "Tutorial" or GameState.GetState() == "Warmup" then
        v6 = 0
    end
    if not a3 and Grenades[a1] ~= nil then
        v2 = InventoryController.getCurrentInventory()
        if v2 then
            v3 = v2[NumberSlots.Grenade]
            if v3 and v3._settings._strict_slot_space <= #v3._items then
                return
            end
        end
    end
    if not a3 and LocalPlayer:GetAttribute("BuyMenu") then
        if Attribute_2 == "Hostage Rescue" or Attribute_2 == "Bomb Defusal" then
            v2 = InventoryController.getCurrentInventory()
            v3 = NumberSlots[v1.Slot]
            local v7 = v2 and v2[v3]
            local v8 = v7 and v7._items[1]
            if v8 and table.find(u182, v8.Identifier) then
                local Name = v8.Name
                local v9 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Name) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Name)
                local v10 = if v9 then require(v9) else nil
                if v10 then
                    local Cost = v10.Cost
                    if v8.Name == "Molotov" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
                        Cost = 500
                    end
                    v6 = v5 - Cost
                end
            end
        end
    end
    if Attribute and v6 <= Attribute then
        Router.broadcastRouter("RunInterfaceSound", "Successful Buy Menu Purchase")
        Remotes.Inventory.BuyMenuPurchase.Send({Equipment = a3, Name = a1, Path = a2 or ""})
    end
end

function u0.createTemplate(a1, a2, a3, a4) -- Line: 939
    -- upvalues: ReplicatedStorage (val), GetDisplayCost (val), GetSkinDisplayName (val), u200 (val), LocalPlayer (val)
    -- upvalues: IsEquipmentPurchaseBlockedForLocalPlayer (val), u167 (val), GetPreferenceColor (val)
    -- upvalues: InventoryController (val), IsEquipmentOwnedBy (val), GetInventoryItemCount (val), Grenades (val)
    -- upvalues: GameState (val), u194 (val), QueryRoundPurchasedInventoryItem (val), u174 (val), Router (val)
    -- upvalues: QueryInventoryItem (val), TweenService (val), TweenTemplateIcon (val), ShowWeaponInfoFrame (val)
    -- upvalues: u184 (ref), u0 (val), IsInBuyArea (val), Remotes (val)
    local v1, v2
    local Name = a2.Name
    local v3 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Name) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Name)
    if not (if v3 then require(v3) else nil) then
        a1.Visible = false
        return
    end
    local Attribute = workspace:GetAttribute("Gamemode")
    v3 = GetDisplayCost(a2.Name, v2)
    local ReverseIcon = v2.ReverseIcon or v2.Icon
    a1.Icon.Image = ReverseIcon
    a1.Cost.Text = "$" .. tostring(v3):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    a1.Keybind.Text = tostring((tonumber(a1.Name)))
    local Cost_2 = a1.Cost
    local v4 = false
    if Attribute ~= "Deathmatch" then
        v4 = Attribute ~= "Tutorial"
    end
    Cost_2.Visible = v4
    a1.LayoutOrder = tonumber(a1.Name)
    GetSkinDisplayName.ApplyNameLabel(a1.ItemName, GetSkinDisplayName.GetWeaponDisplayName(a2.Name, a2.NameTag), a2.NameTag)
    local Teammates = a1.Teammates
    Teammates.Visible = false
    for i, v in ipairs(u200) do
        v1 = Teammates[v.Name]
        if v1 then
            v1.Visible = false
        end
    end
    a1.Visible = true
    local v5 = tonumber((LocalPlayer:GetAttribute("Money"))) or 0
    v4 = a3 and IsEquipmentPurchaseBlockedForLocalPlayer(a2.Name)
    local v6 = if v5 < v3 then u167 or GetPreferenceColor() else v4 and u167 or GetPreferenceColor()
    a1.ItemName.TextColor3 = v6
    a1.Keybind.TextColor3 = v6
    a1.Icon.ImageColor3 = v6
    a1.Cost.TextColor3 = v6
    a1:SetAttribute("Weapon", a2.Name)
    a1:SetAttribute("IsEquipment", a3)
    a1:SetAttribute("InventoryItemId", a2._id)
    local v7 = InventoryController.getCurrentInventory()
    local v8 = false
    local v9 = false
    if a3 then
        local Name_5 = a2.Name
        v8 = IsEquipmentOwnedBy(LocalPlayer, Name_5)
    elseif v7 then
        v8 = 0 < (GetInventoryItemCount(v7, a2.Name))
        local Name_6 = a2.Name
        local v10 = GetInventoryItemCount(v7, Name_6)
        local v11 = Grenades[Name_6]
        v9 = if not v11 then v10 == 0 else v10 < v11
    end
    local Return = a1.Return
    local v12 = v8
    if v12 then
        v12 = false
        if GameState.GetState() ~= "Warmup" then
            v12 = false
            if Attribute ~= "Deathmatch" then
                v12 = false
                if Attribute ~= "Tutorial" then
                    v12 = a3
                    if not v12 then
                        local Name_7 = a2.Name
                        local v13 = u194[LocalPlayer:GetAttribute("Team")]
                        v12 = not (if if v13 then table.find(v13, Name_7) ~= nil else false then if v7 then not QueryRoundPurchasedInventoryItem(v7, Name_7) else true else false)
                    end
                end
            end
        end
    end
    Return.Visible = v12
    a1.Hover.Visible = v8
    v12 = if not v8 then 1 else if v9 then 1 else 0
    a1.Hover.UIStroke.Transparency = v12
    u174:Add((a1.MouseEnter:Connect(function() -- Line: 1009
        -- upvalues: Router (upval), a2 (val), a3 (val), InventoryController (upval), IsEquipmentOwnedBy (upval)
        -- upvalues: LocalPlayer (upval), QueryInventoryItem (upval), a1 (val), TweenService (upval)
        -- upvalues: TweenTemplateIcon (upval), ShowWeaponInfoFrame (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
        local Name = a2.Name
        local v1 = a3
        local v2 = InventoryController.getCurrentInventory()
        if (not v1 or not IsEquipmentOwnedBy(LocalPlayer, Name)) and (not v2 or not QueryInventoryItem(v2, Name)) then
            a1.Hover.UIStroke.Transparency = 1
            a1.Hover.Visible = true
            TweenService:Create(
                a1.Hover.UIStroke,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Transparency = 0.8}
            ):Play()
        end
        TweenTemplateIcon(a1, 0.7)
        ShowWeaponInfoFrame(a1)
    end)))
    u174:Add((a1.MouseLeave:Connect(function() -- Line: 1031
        -- upvalues: a2 (val), a3 (val), InventoryController (upval), IsEquipmentOwnedBy (upval), LocalPlayer (upval)
        -- upvalues: QueryInventoryItem (upval), a1 (val), TweenTemplateIcon (upval), u184 (upval)
        local Name = a2.Name
        local v1 = a3
        local v2 = InventoryController.getCurrentInventory()
        if (not v1 or not IsEquipmentOwnedBy(LocalPlayer, Name)) and (not v2 or not QueryInventoryItem(v2, Name)) then
            a1.Hover.UIStroke.Transparency = 1
            a1.Hover.Visible = false
        end
        TweenTemplateIcon(a1, 0.75)
        if u184 and u184.WeaponInfoFrame then
            u184.WeaponInfoFrame.Visible = false
        end
    end)))
    u174:Add((a1.MouseButton1Down:Connect(function() -- Line: 1044 -- upvalues: TweenTemplateIcon (upval), a1 (val)
        TweenTemplateIcon(a1, 0.65)
    end)))
    u174:Add((a1.MouseButton1Up:Connect(function() -- Line: 1047 -- upvalues: TweenTemplateIcon (upval), a1 (val)
        TweenTemplateIcon(a1, 0.7)
    end)))
    u174:Add((a1.MouseButton1Click:Connect(function() -- Line: 1052 -- upvalues: u0 (upval), a2 (val), a4 (val), a3 (val)
        u0.purchase(a2.Name, a4, a3)
    end)))
    u174:Add((a1.Return.MouseButton1Click:Connect(function() -- Line: 1057
        -- upvalues: a3 (val), IsInBuyArea (upval), LocalPlayer (upval), Remotes (upval), a2 (val)
        -- upvalues: InventoryController (upval), u194 (upval), QueryRoundPurchasedInventoryItem (upval)
        -- upvalues: QueryInventoryItem (upval)
        if a3 then
            if IsInBuyArea(LocalPlayer) then
                Remotes.Inventory.ReturnBuyMenuPurchase.Send({Equipment = true, Identifier = a2.Name})
            end
            return
        end
        local v1 = InventoryController.getCurrentInventory()
        if not v1 then
            return
        end
        local Name = a2.Name
        local v2 = u194[LocalPlayer:GetAttribute("Team")]
        if if if v2 then table.find(v2, Name) ~= nil else false then if v1 then not QueryRoundPurchasedInventoryItem(v1, Name) else true else false then
            return
        end
        local Name_2 = a2.Name
        local v3 = QueryRoundPurchasedInventoryItem(v1, Name_2) or QueryInventoryItem(v1, Name_2)
        if v3 and IsInBuyArea(LocalPlayer) then
            Remotes.Inventory.ReturnBuyMenuPurchase.Send({Equipment = false, Identifier = v3.Identifier})
        end
    end)))
end

function u0.setupTemplate(a1, a2) -- Line: 1091
    -- upvalues: Router (val), LocalPlayer (val), u0 (val)
    local v1 = Router.broadcastRouter("GetEquippedInventoryItem", LocalPlayer, a2)
    if v1 and v1.Name then
        u0.createTemplate(a1, v1, false, a2)
        return
    end
    a1:SetAttribute("IsEquipment", nil)
    a1:SetAttribute("Weapon", nil)
    a1.Visible = false
end

function u0.updateBuyMenuTemplate(a1, a2) -- Line: 1101
    -- upvalues: u285 (val), StopTutorialPulse (val), ReplicatedStorage (val), GetDisplayCost (val), LocalPlayer (val)
    -- upvalues: IsEquipmentPurchaseBlockedForLocalPlayer (val), TutorialPurchaseLock (val), u167 (val)
    -- upvalues: GetPreferenceColor (val), SyncTutorialPulse (val), GetInventoryItemCount (val)
    -- upvalues: IsEquipmentOwnedBy (val), Grenades (val), GameState (val), u194 (val)
    -- upvalues: QueryRoundPurchasedInventoryItem (val), TweenService (val), UpdateTemplateTeammateIndicators (val)
    local v1, v2, v3
    local Attribute = a2:GetAttribute("IsEquipment")
    local Attribute_2 = a2:GetAttribute("Weapon")
    if not Attribute_2 then
        local Icon = a2.Icon
        v2 = u285[Icon]
        StopTutorialPulse(Icon, nil)
        return
    end
    v2 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Attribute_2) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Attribute_2)
    local v4 = if v2 then require(v2) else nil
    v2 = nil
    if v4 then
        v3 = GetDisplayCost(Attribute_2, v4)
        a2.Cost.Text = "$" .. tostring(v3):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        local Attribute_3 = LocalPlayer:GetAttribute("Money")
        local v5 = Attribute and IsEquipmentPurchaseBlockedForLocalPlayer(Attribute_2)
        v1 = TutorialPurchaseLock.isPurchaseAllowed(LocalPlayer, Attribute_2)
        if Attribute_3 then
            v1 = if Attribute_3 < v3 then u167 or GetPreferenceColor() else if v5 then u167 or GetPreferenceColor() else not v1 and u167 or GetPreferenceColor()
            v2 = v1
            a2.ItemName.TextColor3 = v1
            a2.Keybind.TextColor3 = v1
            a2.Icon.ImageColor3 = v1
            a2.Cost.TextColor3 = v1
        end
    end
    v3 = SyncTutorialPulse
    local v6 = a2
    v1 = TutorialPurchaseLock.getRequiredItems(LocalPlayer)
    v3(
        v6,
        v2,
        if not v1 then false else if table.find(v1, Attribute_2) then not (a1 and 0 < (GetInventoryItemCount(a1, Attribute_2))) else false
    )
    if a2.Visible then
        v3 = false
        v6 = false
        if Attribute then
            v3 = IsEquipmentOwnedBy(LocalPlayer, Attribute_2)
        elseif a1 then
            v3 = 0 < (GetInventoryItemCount(a1, Attribute_2))
            local v7 = GetInventoryItemCount(a1, Attribute_2)
            v1 = Grenades[Attribute_2]
            v6 = if not v1 then v7 == 0 else v7 < v1
        end
        local Attribute_4 = workspace:GetAttribute("Gamemode")
        local Return = a2.Return
        v1 = v3
        if v1 then
            v1 = false
            if Attribute_4 ~= "Deathmatch" then
                v1 = false
                if Attribute_4 ~= "Tutorial" then
                    v1 = false
                    if GameState.GetState() ~= "Warmup" then
                        v1 = Attribute
                        if not v1 then
                            local v8 = u194[LocalPlayer:GetAttribute("Team")]
                            v1 = not (if if v8 then table.find(v8, Attribute_2) ~= nil else false then if a1 then not QueryRoundPurchasedInventoryItem(a1, Attribute_2) else true else false)
                        end
                    end
                end
            end
        end
        Return.Visible = v1
        a2.Hover.Visible = v3
        if not v3 then
            a2.Hover.UIStroke.Transparency = 1
            return
        else
            TweenService:Create(
                a2.Hover.UIStroke,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Transparency = if not v6 then 0 else 1}
            ):Play()
        end
    end
    UpdateTemplateTeammateIndicators(a2)
end

local function getDroppedCategory(a1) -- Line: 1181
    local Slot = a1.Slot
    if Slot == "Grenade" then
        return "Grenades"
    end
    if Slot == "Secondary" then
        return "Pistols"
    end
    if Slot ~= "Primary" then
        return nil
    end
    local Type = a1.Type
    if Type ~= "SMG" and Type ~= "Heavy" then
        return "Rifles"
    end
    return "Mid Tier"
end

local function getCategoryTemplateCount(a1) -- Line: 1199 -- types: a1: userdata
    local v1 = 0
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("Frame") and v.Name ~= "Template" then
            v1 = v1 + 1
        end
    end
    return v1
end

local function setDroppedLabelDimmed(a1, a2, a3, a4, a5) -- Line: 1210
    -- upvalues: 
    if not a1 then
        return
    end
    if a4 then
        a1:SetAttribute("_OrigColor", a1[a2])
        a1:SetAttribute("_OrigTrans", a1[a3])
        a1[a2] = (Color3.new(1, 1, 1))
        a1[a3] = a5
        return
    end
    local Attribute = a1:GetAttribute("_OrigColor")
    local Attribute_2 = a1:GetAttribute("_OrigTrans")
    if Attribute then
        a1[a2] = Attribute
    end
    if Attribute_2 ~= nil then
        a1[a3] = Attribute_2
    end
end

local function setDroppedTemplatePickedUp(a1, a2) -- Line: 1238
    -- upvalues: setDroppedLabelDimmed (val)
    local ImageLabel = a1:FindFirstChild("ImageLabel")
    local TextLabel = a1:FindFirstChild("TextLabel")
    if not a2 then
        local Attribute = a1:GetAttribute("_OrigBG")
        if Attribute then
            a1.BackgroundColor3 = Attribute
        end
    else
        a1:SetAttribute("_OrigBG", a1.BackgroundColor3)
        a1.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    end
    setDroppedLabelDimmed(ImageLabel, "ImageColor3", "ImageTransparency", a2, 0.6)
    setDroppedLabelDimmed(TextLabel, "TextColor3", "TextTransparency", a2, 0.8)
end

local function isWithinPickupRange(a1) -- Line: 1254 -- upvalues: LocalPlayer (val) -- types: a1: userdata
    local Character = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local PrimaryPart = a1 and a1.PrimaryPart
    if Character and PrimaryPart then
        return (Character.Position - PrimaryPart.Position).Magnitude <= 45
    end
    return false
end

local u314 = {Pistols = 2, ["Mid Tier"] = 1, Rifles = 1, Grenades = 4}

local function tryPickupDroppedWeapon(a1, a2) -- Line: 1270
    -- upvalues: LocalPlayer (val), u314 (val), InventoryController (val), Grenades (val), GetWeaponProperties (val)
    -- upvalues: NumberSlots (val), Remotes (val), GetCharacterVelocity (val), CharacterResolver (val), u235 (ref)
    local v1, v2, v3
    local Character = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local PrimaryPart = a1 and a1.PrimaryPart
    if not (if not Character then false else if PrimaryPart then (Character.Position - PrimaryPart.Position).Magnitude <= 45 else false)
        or not a1:GetAttribute("CanPickup") then
        return
    end
    local v4 = u314[a2]
    if not v4 then
        return
    end
    local v5 = InventoryController.getCurrentInventory()
    if not v5 then
        return
    end
    local v6 = v5[v4]
    if not v6 then
        return
    end
    if a2 == "Grenades" then
        local Attribute = a1:GetAttribute("Weapon")
        if v6._settings._strict_slot_space <= #v6._items then
            return
        end
        if Grenades[Attribute] then
            v3 = 0
            for i, v in ipairs(v6._items) do
                if v.Name == Attribute then
                    v3 = v3 + 1
                end
            end
            if Grenades[Attribute] <= v3 then
                return
            end
        end
        v2, v1 = a2, a1
        if v2 ~= "Grenades" then
            u235 = v4
        end
        Remotes.Inventory.PickupWeapon.Send({AllowAutoEquip = true, Identity = v1.Name})
        return
    end
    local v7 = #v6._items
    if v6._settings._strict_slot_space <= v7 then
        local v8
        v7 = InventoryController.getCurrentEquipped()
        v3 = false
        if v7 then
            v8 = GetWeaponProperties(v7.Name)
            if v8 and NumberSlots[v8.Slot] == v4 and v7.drop then
                v7:drop()
                v3 = true
            end
        end
        if not v3 then
            v8 = v6._items[1]
            if v8 and v8.Properties and v8.Properties.Droppable then
                if v7 and v7.Identifier == v8.Identifier then
                    v7:unequip()
                end
                Remotes.Inventory.DropWeapon.Send({
                    CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
                    Direction = workspace.CurrentCamera.CFrame.LookVector,
                    Identifier = v8.Identifier,
                })
                v2, v1 = a2, a1
                if v2 ~= "Grenades" then
                    u235 = v4
                end
                Remotes.Inventory.PickupWeapon.Send({AllowAutoEquip = true, Identity = v1.Name})
                return
            end
            return
        end
    end
    v2, v1 = a2, a1
    if v2 ~= "Grenades" then
        u235 = v4
    end
    Remotes.Inventory.PickupWeapon.Send({AllowAutoEquip = true, Identity = v1.Name})
end

local function getDroppedKey(a1, a2) -- Line: 1350 -- types: a1: string, a2: string
    return a1 .. "::" .. a2
end

local function findClosestModelInEntry(a1) -- Line: 1354 -- upvalues: LocalPlayer (val) -- types: a1: table
    local Magnitude
    local Character = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not Character then
        return nil
    end
    local v1 = nil
    local v2 = (1 / 0)
    for k in pairs(a1.models) do
        if k and k.Parent and k.PrimaryPart and k:GetAttribute("CanPickup") then
            Magnitude = (Character.Position - k.PrimaryPart.Position).Magnitude
            if Magnitude <= 45 and Magnitude < v2 then
                v1 = k
            end
        end
    end
    return v1
end

local function hasAnyModelInRange(a1) -- Line: 1373 -- upvalues: LocalPlayer (val) -- types: a1: table
    local Character = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not Character then
        return false
    end
    for k in pairs(a1.models) do
        if k and k.Parent and k.PrimaryPart and (Character.Position - k.PrimaryPart.Position).Magnitude <= 45 then
            return true
        end
    end
    return false
end

local function updateDroppedTemplateRangeStates() -- Line: 1388
    -- upvalues: Profiler (val), u233 (val), hasAnyModelInRange (val), setDroppedTemplatePickedUp (val)
    local Attribute, Attribute_2, Attribute_3, Attribute_4, Attribute_5, Attribute_6, ImageLabel, TextLabel, template, v1
    Profiler.mark("UI.BuyMenu.UpdateDroppedTemplateRangeStates")
    for k, v in pairs(u233) do
        if next(v.models) then
            v1 = hasAnyModelInRange(v)
            Attribute = v.template:GetAttribute("_OutOfRange")
            if v1 then
                if v1 and Attribute then
                    v.template:SetAttribute("_OutOfRange", nil)
                    template = v.template
                    ImageLabel = template:FindFirstChild("ImageLabel")
                    TextLabel = template:FindFirstChild("TextLabel")
                    Attribute_2 = template:GetAttribute("_OrigBG")
                    if Attribute_2 then
                        template.BackgroundColor3 = Attribute_2
                    end
                    if ImageLabel then
                        Attribute_3 = ImageLabel:GetAttribute("_OrigColor")
                        Attribute_4 = ImageLabel:GetAttribute("_OrigTrans")
                        if Attribute_3 then
                            ImageLabel.ImageColor3 = Attribute_3
                        end
                        if Attribute_4 ~= nil then
                            ImageLabel.ImageTransparency = Attribute_4
                        end
                    end
                    if TextLabel then
                        Attribute_5 = TextLabel:GetAttribute("_OrigColor")
                        Attribute_6 = TextLabel:GetAttribute("_OrigTrans")
                        if Attribute_5 then
                            TextLabel.TextColor3 = Attribute_5
                        end
                        if Attribute_6 ~= nil then
                            TextLabel.TextTransparency = Attribute_6
                        end
                    end
                end
            elseif not Attribute then
                v.template:SetAttribute("_OutOfRange", true)
                setDroppedTemplatePickedUp(v.template, true)
            elseif v1 and Attribute then
                v.template:SetAttribute("_OutOfRange", nil)
                template = v.template
                ImageLabel = template:FindFirstChild("ImageLabel")
                TextLabel = template:FindFirstChild("TextLabel")
                Attribute_2 = template:GetAttribute("_OrigBG")
                if Attribute_2 then
                    template.BackgroundColor3 = Attribute_2
                end
                if ImageLabel then
                    Attribute_3 = ImageLabel:GetAttribute("_OrigColor")
                    Attribute_4 = ImageLabel:GetAttribute("_OrigTrans")
                    if Attribute_3 then
                        ImageLabel.ImageColor3 = Attribute_3
                    end
                    if Attribute_4 ~= nil then
                        ImageLabel.ImageTransparency = Attribute_4
                    end
                end
                if TextLabel then
                    Attribute_5 = TextLabel:GetAttribute("_OrigColor")
                    Attribute_6 = TextLabel:GetAttribute("_OrigTrans")
                    if Attribute_5 then
                        TextLabel.TextColor3 = Attribute_5
                    end
                    if Attribute_6 ~= nil then
                        TextLabel.TextTransparency = Attribute_6
                    end
                end
            end
        end
    end
end

local function getModelCount(a1) -- Line: 1406 -- types: a1: table
    local v1 = 0
    for k in pairs(a1) do
        v1 = v1 + 1
    end
    return v1
end

local function updateDroppedTemplateLabel(a1) -- Line: 1414 -- types: a1: table
    local TextLabel = a1.template:FindFirstChild("TextLabel")
    if not TextLabel then
        return
    end
    local v1 = 0
    for k in pairs(a1.models) do
        v1 = v1 + 1
    end
    if v1 > 1 then
        TextLabel.Text = ("x%* %*"):format(v1, a1.weaponName)
        return
    end
    TextLabel.Text = a1.weaponName
end

local function onWeaponDropped(a1) -- Line: 1427
    -- upvalues: IsTutorialMode (val), LocalPlayer (val), GetWeaponProperties (val), u233 (val), u234 (val), u184 (ref)
    -- upvalues: getCategoryTemplateCount (val), GetPreferenceColor (val), findClosestModelInEntry (val), Router (val)
    -- upvalues: tryPickupDroppedWeapon (val), u232 (val)
    if workspace:GetAttribute("Gamemode") ~= "Deathmatch" and not IsTutorialMode() then
        local u30
        local Attribute = a1:GetAttribute("Weapon")
        if not Attribute or (a1:GetAttribute("DroppedByTeam")) ~= LocalPlayer:GetAttribute("Team") then
            return
        end
        local v1 = GetWeaponProperties(Attribute)
        if not v1 then
            return
        end
        local Slot = v1.Slot
        if Slot == "Grenade" then
            u30 = "Grenades"
        elseif Slot == "Secondary" then
            u30 = "Pistols"
        elseif Slot ~= "Primary" then
            u30 = nil
        else
            local Type = v1.Type
            u30 = if Type == "SMG" then "Mid Tier" else if Type ~= "Heavy" then "Rifles" else "Mid Tier"
        end
        if not u30 then
            return
        end
        local v2 = u30 .. "::" .. Attribute
        local v3 = u233[v2]
        if v3 then
            v3.models[a1] = true
            u234[a1] = v2
            v3.template:SetAttribute("_OutOfRange", nil)
            local template = v3.template
            local ImageLabel = template:FindFirstChild("ImageLabel")
            local TextLabel = template:FindFirstChild("TextLabel")
            local Attribute_3 = template:GetAttribute("_OrigBG")
            if Attribute_3 then
                template.BackgroundColor3 = Attribute_3
            end
            if ImageLabel then
                local Attribute_4 = ImageLabel:GetAttribute("_OrigColor")
                local Attribute_5 = ImageLabel:GetAttribute("_OrigTrans")
                if Attribute_4 then
                    ImageLabel.ImageColor3 = Attribute_4
                end
                if Attribute_5 ~= nil then
                    ImageLabel.ImageTransparency = Attribute_5
                end
            end
            if TextLabel then
                local Attribute_6 = TextLabel:GetAttribute("_OrigColor")
                local Attribute_7 = TextLabel:GetAttribute("_OrigTrans")
                if Attribute_6 then
                    TextLabel.TextColor3 = Attribute_6
                end
                if Attribute_7 ~= nil then
                    TextLabel.TextTransparency = Attribute_7
                end
            end
            local TextLabel_2 = v3.template:FindFirstChild("TextLabel")
            if TextLabel_2 then
                local v4 = 0
                for k in pairs(v3.models) do
                    v4 = v4 + 1
                end
                if not (v4 > 1) then
                    TextLabel_2.Text = v3.weaponName
                else
                    TextLabel_2.Text = ("x%* %*"):format(v4, v3.weaponName)
                end
            end
            local ImageButton = v3.template:FindFirstChild("ImageButton")
            if ImageButton then
                ImageButton.Active = true
            end
            return
        end
        local Dropped = u184.Menu:FindFirstChild("Dropped")
        if not Dropped then
            return
        end
        local Container = Dropped:FindFirstChild("Container")
        if not Container then
            return
        end
        local v5 = Container:FindFirstChild(u30)
        if not v5 or 4 <= (getCategoryTemplateCount(v5)) then
            return
        end
        local Template = Container:FindFirstChild("Template")
        if not Template then
            return
        end
        local v6 = Template:Clone()
        v6.Name = v2
        v6.Visible = true
        v6.Parent = v5
        local ReverseIcon = v1.ReverseIcon or v1.Icon
        local ImageLabel_2 = v6:FindFirstChild("ImageLabel")
        local TextLabel_3 = v6:FindFirstChild("TextLabel")
        local ImageButton_2 = v6:FindFirstChild("ImageButton")
        if ImageLabel_2 then
            ImageLabel_2.Image = ReverseIcon
            ImageLabel_2.ImageColor3 = GetPreferenceColor()
        end
        if TextLabel_3 then
            TextLabel_3.Text = Attribute
            TextLabel_3.TextColor3 = GetPreferenceColor()
        end
        local u181 = {template = v6, category = u30, weaponName = Attribute}
        u181.models = {[a1] = true}
        u233[v2] = u181
        u234[a1] = v2
        if ImageButton_2 then
            u232:Add((ImageButton_2.MouseButton1Click:Connect(function() -- Line: 1524
                -- upvalues: findClosestModelInEntry (upval), u181 (val), Router (upval), tryPickupDroppedWeapon (upval)
                -- upvalues: u30 (val)
                local v1 = findClosestModelInEntry(u181)
                if v1 then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    tryPickupDroppedWeapon(v1, u30)
                end
            end)))
        end
        return
    end
end

local function onWeaponDropRemoved(a1) -- Line: 1535
    -- upvalues: u234 (val), u233 (val), setDroppedTemplatePickedUp (val)
    local v1 = u234[a1]
    if not v1 then
        return
    end
    u234[a1] = nil
    local v2 = u233[v1]
    if not v2 then
        return
    end
    v2.models[a1] = nil
    if not next(v2.models) then
        v2.template:SetAttribute("_OutOfRange", nil)
        setDroppedTemplatePickedUp(v2.template, true)
        local ImageButton = v2.template:FindFirstChild("ImageButton")
        if not ImageButton then
            return
        end
        ImageButton.Active = false
        return
    end
    local TextLabel = v2.template:FindFirstChild("TextLabel")
    if not TextLabel then
        return
    end
    local v3 = 0
    for k in pairs(v2.models) do
        v3 = v3 + 1
    end
    if v3 > 1 then
        TextLabel.Text = ("x%* %*"):format(v3, v2.weaponName)
        return
    end
    TextLabel.Text = v2.weaponName
end

local function updateDroppedFrameVisibility() -- Line: 1561 -- upvalues: u184 (ref), IsTutorialMode (val)
    local Menu = u184 and u184.Menu and u184.Menu:FindFirstChild("Dropped")
    if not Menu then
        return
    end
    local v1 = false
    if (workspace:GetAttribute("Gamemode")) ~= "Deathmatch" then
        v1 = not IsTutorialMode()
    end
    Menu.Visible = v1
end

local function cleanupAllDroppedEntries() -- Line: 1570 -- upvalues: u233 (val), u234 (val), u232 (val), u184 (ref)
    for k, v in pairs(u233) do
        v.template:Destroy()
    end
    table.clear(u233)
    table.clear(u234)
    u232:Cleanup()
    local Menu = u184 and u184.Menu and u184.Menu:FindFirstChild("Dropped")
    if not Menu then
        return
    end
    local Container = Menu:FindFirstChild("Container")
    if not Container then
        return
    end
    for i, i2 in ipairs(Container:GetChildren()) do
        if i2:IsA("Frame") and i2.Name ~= "Template" then
            for i3, j in ipairs(i2:GetChildren()) do
                if j:IsA("Frame") then
                    j:Destroy()
                end
            end
        end
    end
end

local function updateBuyMenuHeartbeat(a1) -- Line: 1597
    -- upvalues: Profiler (val), u181 (val), u184 (ref), GetPreferenceColor (val), IsInBuyArea (val), LocalPlayer (val)
    -- upvalues: u0 (val), IsTutorialMode (val), InventoryController (val), TutorialPurchaseLock (val)
    -- upvalues: GetInventoryItemCount (val), u183 (ref), updateDroppedTemplateRangeStates (val)
    local u68
    Profiler.mark("UI.BuyMenu.Heartbeat")
    local v1 = tostring((math.round((u181:getPosition())))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    u184.Menu.TopFrame.Money.TextColor3 = GetPreferenceColor()
    u184.Menu.TopFrame.Money.Text = "$" .. v1
    u181:update(a1)
    if u184.Visible and not IsInBuyArea(LocalPlayer) then
        local Attribute = workspace:GetAttribute("Gamemode")
        if Attribute ~= "Bomb Defusal" and Attribute ~= "Hostage Rescue" then
            if u184.Visible and IsTutorialMode() then
                u68 = InventoryController.getCurrentInventory()
                if TutorialPurchaseLock.isWaitingOnPurchase(LocalPlayer, function(a1) -- Line: 657 -- upvalues: u68 (val), GetInventoryItemCount (upval) -- types: a1: string
                    local v1, v2
                    if u68 then
                        v2 = GetInventoryItemCount(u68, a1)
                        if v2 > 0 then
                            v1 = true
                        else
                            v1 = false
                        end
                        return v1
                    else
                        return false
                    end
                end) then
                    u183 = true
                elseif u183 then
                    u183 = false
                    u0.closeFrame()
                    return
                end
            end
            updateDroppedTemplateRangeStates()
            return
        end
        u0.closeFrame()
        return
    end
    if u184.Visible and IsTutorialMode() then
        u68 = InventoryController.getCurrentInventory()
        if TutorialPurchaseLock.isWaitingOnPurchase(LocalPlayer, function(a1) -- Line: 657 -- upvalues: u68 (val), GetInventoryItemCount (upval) -- types: a1: string
            local v1, v2
            if u68 then
                v2 = GetInventoryItemCount(u68, a1)
                if v2 > 0 then
                    v1 = true
                else
                    v1 = false
                end
                return v1
            else
                return false
            end
        end) then
            u183 = true
        elseif u183 then
            u183 = false
            u0.closeFrame()
            return
        end
    end
    updateDroppedTemplateRangeStates()
end

local function startBuyMenuUpdate() -- Line: 1631
    -- upvalues: u238 (ref), RunServiceController (val), updateBuyMenuHeartbeat (val)
    if u238 then
        return
    end
    u238 = RunServiceController.BindToHeartbeat("UI.BuyMenu.Update", updateBuyMenuHeartbeat)
    updateBuyMenuHeartbeat(0)
end

local function stopBuyMenuUpdate() -- Line: 1640 -- upvalues: u238 (ref)
    if u238 then
        u238:Disconnect()
        u238 = nil
    end
end

local function NotifyTutorial(a1) -- Line: 1651 -- upvalues: IsTutorialMode (val), Remotes (val) -- types: a1: string
    if not IsTutorialMode() then
        return
    end
    Remotes.Tutorial.ClientEvent.Send(a1)
end

function u0.openFrame() -- Line: 1658
    -- upvalues: EndScreenController (val), LocalPlayer (val), IsInBuyArea (val), TutorialPurchaseLock (val), u184 (ref)
    -- upvalues: CameraController (val), u185 (ref), u238 (ref), RunServiceController (val)
    -- upvalues: updateBuyMenuHeartbeat (val), RequestCompetitiveTeammateInventories (val)
    -- upvalues: UpdateAllTeammateIndicators (val), IsTutorialMode (val), Remotes (val)
    if EndScreenController.IsActive() then
        return
    end
    local Attribute = LocalPlayer:GetAttribute("BuyMenu")
    if not IsInBuyArea(LocalPlayer) or TutorialPurchaseLock.isBuyMenuLocked(LocalPlayer) then
        return
    end
    if Attribute and not u184.Visible then
        CameraController.setForceLockOverride("BuyMenu", true)
        CameraController.setPerspective(true, true)
        u185.Gameplay.Bottom.Health.Visible = false
        u185.Gameplay.Bottom.Middle.Visible = false
        u185.Gameplay.Bottom.Armor.Visible = false
        u185.Gameplay.Bottom.Money.Visible = false
        u185.Gameplay.Bottom.Ammo.Visible = false
        u184.Visible = true
        if not u238 then
            u238 = RunServiceController.BindToHeartbeat("UI.BuyMenu.Update", updateBuyMenuHeartbeat)
            updateBuyMenuHeartbeat(0)
        end
        if u184 and u184.WeaponInfoFrame then
            u184.WeaponInfoFrame.Visible = false
        end
        RequestCompetitiveTeammateInventories()
        UpdateAllTeammateIndicators()
        if not IsTutorialMode() then
            return
        end
        Remotes.Tutorial.ClientEvent.Send("OpenedBuyMenu")
        return
    end
end

function u0.closeFrame() -- Line: 1694
    -- upvalues: u184 (ref), CameraController (val), u185 (ref), GetPlayerArmorState (val), LocalPlayer (val)
    -- upvalues: u238 (ref), u183 (ref), IsTutorialMode (val), Remotes (val)
    if not u184.Visible then
        return
    end
    CameraController.setForceLockOverride("BuyMenu", false)
    CameraController.setPerspective(true, false)
    u185.Gameplay.Bottom.Health.Visible = true
    u185.Gameplay.Bottom.Middle.Visible = true
    u185.Gameplay.Bottom.Armor.Visible = 0 < GetPlayerArmorState(LocalPlayer).Health
    u185.Gameplay.Bottom.Money.Visible = true
    u185.Gameplay.Bottom.Ammo.Visible = true
    u184.Visible = false
    if u238 then
        u238:Disconnect()
        u238 = nil
    end
    if u184 and u184.WeaponInfoFrame then
        u184.WeaponInfoFrame.Visible = false
    end
    u183 = false
    if not IsTutorialMode() then
        return
    end
    Remotes.Tutorial.ClientEvent.Send("ClosedBuyMenu")
end

function u0.toggleFrame() -- Line: 1715
    -- upvalues: EndScreenController (val), LocalPlayer (val), u184 (ref), u0 (val), InventoryController (val)
    -- upvalues: TutorialPurchaseLock (val), GetInventoryItemCount (val)
    if EndScreenController.IsActive() then
        return
    end
    if LocalPlayer:GetAttribute("BuyMenu") and not u184.Visible then
        u0.openFrame()
        return
    end
    if u184.Visible then
        local u17 = InventoryController.getCurrentInventory()
        if TutorialPurchaseLock.isWaitingOnPurchase(LocalPlayer, function(a1) -- Line: 657 -- upvalues: u17 (val), GetInventoryItemCount (upval) -- types: a1: string
            local v1, v2
            if u17 then
                v2 = GetInventoryItemCount(u17, a1)
                if v2 > 0 then
                    v1 = true
                else
                    v1 = false
                end
                return v1
            else
                return false
            end
        end) then
            return
        end
        u0.closeFrame()
    end
end

function u0.characterAdded(a1) -- Line: 1736
    -- upvalues: WaitForAttribute (val), LocalPlayer (val), u174 (val), setupBuyMenuTemplates (val)
    if not WaitForAttribute(LocalPlayer, "Money") then
        return
    end
    u174:Cleanup()
    setupBuyMenuTemplates()
end

function u0.Initialize(a1, a2) -- Line: 1751
    -- upvalues: u185 (ref), u184 (ref), UpdateBuyMenuTimerText (val), InventoryController (val), u0 (val)
    -- upvalues: LocalPlayer (val), u176 (val), u236 (val), RequestCompetitiveTeammateInventory (val)
    -- upvalues: UpdateAllTeammateIndicators (val), u168 (val), Profiler (val), u237 (val), Players (val), Remotes (val)
    -- upvalues: RequestCompetitiveTeammateInventories (val), Observers (val), cleanupAllDroppedEntries (val)
    -- upvalues: u174 (val), setupBuyMenuTemplates (val), IsTutorialMode (val), u182 (val), RemoveFromArray (val)
    -- upvalues: u181 (val), GameState (val), DataController (val), u233 (val), GetPreferenceColor (val)
    -- upvalues: onWeaponDropped (val), onWeaponDropRemoved (val)
    u185 = a1
    u184 = a2
    UpdateBuyMenuTimerText()

    local function refreshBuyMenuTemplates() -- Line: 1755
        -- upvalues: InventoryController (upval), u184 (upval), u0 (upval)
        local v1 = InventoryController.getCurrentInventory()
        for i, v in ipairs(u184.Menu.Container:GetDescendants()) do
            if v:IsA("TextButton") then
                u0.updateBuyMenuTemplate(v1, v)
            end
        end
    end

    local function trackCompetitiveTeammate(a1) -- Line: 1764
        -- upvalues: LocalPlayer (upval), u176 (upval), u236 (upval), RequestCompetitiveTeammateInventory (upval)
        -- upvalues: UpdateAllTeammateIndicators (upval), u168 (upval)
        if a1 == LocalPlayer then
            return
        end
        u176:Add(((a1:GetAttributeChangedSignal("Team")):Connect(function() -- Line: 1769
            -- upvalues: a1 (val), LocalPlayer (upval), u236 (upval), RequestCompetitiveTeammateInventory (upval)
            -- upvalues: UpdateAllTeammateIndicators (upval)
            if (a1:GetAttribute("Team")) ~= LocalPlayer:GetAttribute("Team") then
                u236[a1] = nil
            end
            RequestCompetitiveTeammateInventory(a1)
            UpdateAllTeammateIndicators()
        end)))
        for i, v in ipairs(u168) do
            u176:Add(((a1:GetAttributeChangedSignal(v)):Connect(UpdateAllTeammateIndicators)))
        end
        for i2 = 1, 5 do
            u176:Add(((a1:GetAttributeChangedSignal("Slot" .. i2)):Connect(function() -- Line: 1783
                -- upvalues: RequestCompetitiveTeammateInventory (upval), a1 (val), UpdateAllTeammateIndicators (upval)
                RequestCompetitiveTeammateInventory(a1)
                UpdateAllTeammateIndicators()
            end)))
        end
    end

    ;(function() -- Line: 1790
        -- upvalues: Profiler (upval), u176 (upval), u236 (upval), u237 (upval), Players (upval)
        -- upvalues: trackCompetitiveTeammate (val), RequestCompetitiveTeammateInventory (upval)
        -- upvalues: UpdateAllTeammateIndicators (upval), Remotes (upval), LocalPlayer (upval)
        -- upvalues: RequestCompetitiveTeammateInventories (upval)
        Profiler.mark("UI.BuyMenu.SetupCompetitiveTeammateObservers")
        u176:Cleanup()
        table.clear(u236)
        table.clear(u237)
        u176:Add((Players.PlayerAdded:Connect(function(a1) -- Line: 1795
            -- upvalues: trackCompetitiveTeammate (upval), RequestCompetitiveTeammateInventory (upval)
            -- upvalues: UpdateAllTeammateIndicators (upval)
            trackCompetitiveTeammate(a1)
            RequestCompetitiveTeammateInventory(a1)
            UpdateAllTeammateIndicators()
        end)))
        u176:Add((Players.PlayerRemoving:Connect(function(a1) -- Line: 1800 -- upvalues: u236 (upval), u237 (upval), UpdateAllTeammateIndicators (upval)
            u236[a1] = nil
            u237[a1] = nil
            UpdateAllTeammateIndicators()
        end)))
        u176:Add((Remotes.Inventory.SpectatedPlayerInventory.Listen(function(a1) -- Line: 1805
            -- upvalues: LocalPlayer (upval), u236 (upval), u237 (upval), UpdateAllTeammateIndicators (upval)
            if a1.Player == LocalPlayer then
                return
            end
            u236[a1.Player] = a1.Inventory
            u237[a1.Player] = nil
            UpdateAllTeammateIndicators()
        end)))
        for i, v in ipairs(Players:GetPlayers()) do
            trackCompetitiveTeammate(v)
        end
        RequestCompetitiveTeammateInventories()
        UpdateAllTeammateIndicators()
    end)()
    Observers.observeAttribute(LocalPlayer, "Team", function() -- Line: 1831
        -- upvalues: cleanupAllDroppedEntries (upval), u236 (upval), u237 (upval), u174 (upval)
        -- upvalues: setupBuyMenuTemplates (upval), refreshBuyMenuTemplates (val)
        cleanupAllDroppedEntries()
        table.clear(u236)
        table.clear(u237)
        u174:Cleanup()
        setupBuyMenuTemplates()
        refreshBuyMenuTemplates()
    end)
    Observers.observeAttribute(workspace, "Gamemode", function() -- Line: 1840
        -- upvalues: u184 (upval), IsTutorialMode (upval), cleanupAllDroppedEntries (upval), u174 (upval)
        -- upvalues: setupBuyMenuTemplates (upval), refreshBuyMenuTemplates (val)
        local Menu = u184 and u184.Menu and u184.Menu:FindFirstChild("Dropped")
        if Menu then
            local v1 = false
            if (workspace:GetAttribute("Gamemode")) ~= "Deathmatch" then
                v1 = not IsTutorialMode()
            end
            Menu.Visible = v1
        end
        cleanupAllDroppedEntries()
        u174:Cleanup()
        setupBuyMenuTemplates()
        refreshBuyMenuTemplates()
    end)
    local Menu = u184 and u184.Menu and u184.Menu:FindFirstChild("Dropped")
    if Menu then
        local v1 = false
        if (workspace:GetAttribute("Gamemode")) ~= "Deathmatch" then
            v1 = not IsTutorialMode()
        end
        Menu.Visible = v1
    end
    Observers.observeAttribute(workspace, "ServerGamemode", function() -- Line: 1853
        -- upvalues: u184 (upval), IsTutorialMode (upval), u174 (upval), setupBuyMenuTemplates (upval)
        -- upvalues: refreshBuyMenuTemplates (val)
        local Menu = u184 and u184.Menu and u184.Menu:FindFirstChild("Dropped")
        if Menu then
            local v1 = false
            if (workspace:GetAttribute("Gamemode")) ~= "Deathmatch" then
                v1 = not IsTutorialMode()
            end
            Menu.Visible = v1
        end
        u174:Cleanup()
        setupBuyMenuTemplates()
        refreshBuyMenuTemplates()
    end)
    Remotes.Inventory.NewInventoryItem.Listen(function(a1) -- Line: 1863 -- upvalues: u182 (upval), refreshBuyMenuTemplates (val)
        if a1.isPurchase ~= true then
            return
        end
        table.insert(u182, a1.identifier)
        refreshBuyMenuTemplates()
    end)
    Remotes.Inventory.RemoveInventoryItem.Listen(function(a1) -- Line: 1873 -- upvalues: RemoveFromArray (upval), u182 (upval)
        RemoveFromArray(u182, function(a1_2, a2) -- Line: 1874 -- upvalues: a1 (val)
            return a2 == a1
        end)
    end)
    Observers.observeAttribute(LocalPlayer, "MinimumNextRoundIncome", function(a1) -- Line: 1880 -- upvalues: u184 (upval)
        u184.Menu.TopFrame.NextRoundMoney.Text = "Next Round Minimum:  $" .. tostring(a1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    end)
    Observers.observeAttribute(LocalPlayer, "Money", function(a1) -- Line: 1885 -- upvalues: u181 (upval), refreshBuyMenuTemplates (val)
        u181:setGoal(a1)
        refreshBuyMenuTemplates()
    end)
    for i, v in ipairs({"Armor", "HasDefuseKit", "HasRescueKit"}) do
        Observers.observeAttribute(LocalPlayer, v, refreshBuyMenuTemplates)
    end
    Observers.observeAttribute(workspace, "VIPInfiniteCashEnabled", refreshBuyMenuTemplates)
    Observers.observeAttribute(LocalPlayer, "Team", function() -- Line: 1895 -- upvalues: setupBuyMenuTemplates (upval), refreshBuyMenuTemplates (val)
        setupBuyMenuTemplates()
        refreshBuyMenuTemplates()
    end)
    Observers.observeAttribute(LocalPlayer, "TutorialStep", function() -- Line: 1900 -- upvalues: refreshBuyMenuTemplates (val)
        refreshBuyMenuTemplates()
    end)
    Observers.observeAttribute(LocalPlayer, "BuyMenu", function() -- Line: 1905 -- upvalues: u0 (upval)
        return function() -- Line: 1906 -- upvalues: u0 (upval)
            u0.closeFrame()
        end
    end)
    Observers.observeAttribute(workspace, "Timer", UpdateBuyMenuTimerText)
    Observers.observeAttribute(workspace, "BuyTimerRemaining", UpdateBuyMenuTimerText)
    GameState.ListenToState(function(a1, a2) -- Line: 1916
        -- upvalues: u182 (upval), cleanupAllDroppedEntries (upval), UpdateBuyMenuTimerText (upval)
        if a2 == "Buy Period" then
            table.clear(u182)
            cleanupAllDroppedEntries()
        end
        UpdateBuyMenuTimerText()
    end)
    InventoryController.OnInventoryChanged:Connect(function(a1) -- Line: 1926 -- upvalues: u184 (upval), u0 (upval)
        for i, v in ipairs(u184.Menu.Container:GetDescendants()) do
            if v:IsA("TextButton") then
                u0.updateBuyMenuTemplate(a1, v)
            end
        end
    end)
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 1935 -- upvalues: refreshBuyMenuTemplates (val), u233 (upval), GetPreferenceColor (upval)
        local ImageLabel, TextLabel
        refreshBuyMenuTemplates()
        for k, v in pairs(u233) do
            if not v.template:GetAttribute("_OrigBG") then
                ImageLabel = v.template:FindFirstChild("ImageLabel")
                TextLabel = v.template:FindFirstChild("TextLabel")
                if ImageLabel then
                    ImageLabel.ImageColor3 = GetPreferenceColor()
                end
                if TextLabel then
                    TextLabel.TextColor3 = GetPreferenceColor()
                end
            end
        end
    end)
    DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 1954
        -- upvalues: LocalPlayer (upval), u174 (upval), setupBuyMenuTemplates (upval), refreshBuyMenuTemplates (val)
        if not LocalPlayer.Character then
            return
        end
        u174:Cleanup()
        setupBuyMenuTemplates()
        refreshBuyMenuTemplates()
    end)
    Observers.observeTag("WeaponDropped", function(a1) -- Line: 1966 -- upvalues: onWeaponDropped (upval), onWeaponDropRemoved (upval) -- types: a1: userdata
        onWeaponDropped(a1)
        return function() -- Line: 1968 -- upvalues: onWeaponDropRemoved (upval), a1 (val)
            onWeaponDropRemoved(a1)
        end
    end)
end

function u0.Start() -- Line: 1974 -- upvalues: LocalPlayer (val), u0 (val), CharacterResolver (val)
    if LocalPlayer.Character then
        u0.characterAdded(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(u0.characterAdded)
    CharacterResolver.observeCharacter(LocalPlayer, function(a1) -- Line: 1983 -- upvalues: u0 (upval) -- types: a1: userdata?
        if not a1 then
            u0.closeFrame()
            return nil
        end
        if a1:GetAttribute("Dead") == true then
            u0.closeFrame()
        end
        local u22 = (a1:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 1989 -- upvalues: a1 (val), u0 (upval)
            if a1:GetAttribute("Dead") == true then
                u0.closeFrame()
            end
        end)
        return function() -- Line: 1998 -- upvalues: u22 (val)
            u22:Disconnect()
        end
    end)
    ;(LocalPlayer:GetAttributeChangedSignal("IsSpectating")):Connect(function() -- Line: 2003 -- upvalues: LocalPlayer (upval), u0 (upval)
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            u0.closeFrame()
        end
    end)
end

return u0