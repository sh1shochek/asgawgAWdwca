-- ReplicatedStorage.Interface.Screens.Menu.Inventory
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Inventory
-- Decompile time: 111.06 ms

local u0 = {}
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation)
local ItemEquipment = require(ReplicatedStorage.Components.Common.ItemEquipment)
local CalculateGridRenderCount = require(ReplicatedStorage.Components.Common.CalculateGridRenderCount)
local UpdateStatusFrame = ItemEquipment.UpdateStatusFrame
local IsEquippedOnTeam = ItemEquipment.IsEquippedOnTeam
local ApplyWearAndSerialBadges = require(ReplicatedStorage.Components.Common.ApplyWearAndSerialBadges)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Buttons = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Buttons)
local Sort = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades)
local UseItemFrame = require(script.Parent.UseItemFrame)
local Loadout = require(script.Parent.Loadout)
local Store = require(script.Parent.Store)
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local u187 = {}
local u194 = table.find(GetUserPlatform(), "PC") ~= nil
local u195 = nil
local u196 = nil
local u197 = nil
local u198 = nil
local u199 = 0
local u200 = false
local u201 = nil
local u202 = nil
local u203 = false
local u204 = false
local u205 = nil
local u206 = 0
local u207 = nil
local u208 = {}
local u209 = nil
local u210 = nil
local u211 = nil
local u212 = nil
local u213 = nil
local u214 = {}
local u215 = {}
local u216 = {}
local u217 = {}
local u218 = {}
local u219 = false
local u220 = nil
local u221 = nil
local u222 = nil
local u223 = false
local u224 = {["Charm Capsule"] = "Charm Pack", Package = "Package"}
local u227 = {
    Special = "Drop Gold",
    Red = "Drop Red",
    Pink = "Drop Pink",
    Purple = "Drop Purple",
    Blue = "Drop Blue",
}
local u228 = {Glove = "Equipped Gloves", Badge = "Equipped Badge", ["Zeus x27"] = "Equipped Zeus x27"}
local u232 = {Pistol = "Pistols", SMG = "Mid Tier", Heavy = "Mid Tier", Rifle = "Rifles"}
local u237 = {}

local function setReverseSortVisual(a1, a2) -- Line: 166 -- types: a1: userdata, a2: boolean
    local ImageLabel = a1:FindFirstChildOfClass("ImageLabel")
    if ImageLabel then
        ImageLabel.Rotation = if not a2 then 0 else 180
    end
end

local function ClearQuickOpenPending(a1) -- Line: 173
    -- upvalues: u207 (ref), Store (val), u204 (ref)
    if a1 and u207 ~= a1 then
        return false
    end
    if u207 then
        Store.ClearPendingOpenCaseRequest(u207)
    end
    u204 = false
    u207 = nil
    return true
end

local u241 = {"Charm", "Inspect", "ReplaceCT", "ReplaceT", "Unlock"}

local function GetVisibleInformationFrameButtons() -- Line: 190 -- upvalues: u241 (val), u209 (ref)
    local v1
    local v2 = {}
    for i, j in u241 do
        v1 = u209[j]
        if v1 and v1.Visible then
            table.insert(v2, v1)
        end
    end
    local QuickUnlock = u209:FindFirstChild("QuickUnlock")
    if QuickUnlock and QuickUnlock.Visible then
        table.insert(v2, QuickUnlock)
    end
    return v2
end

local function hasAnyInformationFrameButton() -- Line: 205
    -- upvalues: u209 (ref), GetVisibleInformationFrameButtons (val)
    local v1 = false
    if u209 ~= nil then
        v1 = #GetVisibleInformationFrameButtons() > 0
    end
    return v1
end

local function ItemHasCharm(a1) -- Line: 209
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

local function GetInventoryItemFromIdentifier(a1, a2) -- Line: 216 -- types: a1: table, a2: string
    for i, v in ipairs(a1) do
        if v._id == a2 then
            return v
        end
    end
    return nil
end

local function IsWeaponEquippedInTeamCategory(a1, a2, a3) -- Line: 231
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = DataController.Get(LocalPlayer, "Loadout")
    local v2 = DataController.Get(LocalPlayer, "Inventory")
    if v1 and v2 then
        local v3 = v1[a2]
        if v3 and v3.Loadout and v3.Loadout[a3] then
            local v4
            local Options = v3.Loadout[a3].Options
            local v5 = a1
            for i, v in ipairs(Options) do
                if v and v ~= "" then
                    for i2, i3 in ipairs(v2) do
                        if i3._id == v then
                            v4 = i3
                            if v4 and v4.Name == v5 then
                                return true, i
                            end
                            break
                        end
                    end
                    v4 = nil
                    if v4 and v4.Name == v5 then
                        return true, i
                    end
                end
            end
            return false, nil
        end
        return false, nil
    end
    return false, nil
end

local function GetWeaponCategory(a1) -- Line: 262
    -- upvalues: GetWeaponProperties (val), u232 (val)
    local success, result = pcall(GetWeaponProperties, a1)
    if success and result and result.Type then
        return u232[result.Type]
    end
    return nil
end

local function ReplaceItemOnTeam(a1, a2) -- Line: 273
    -- upvalues: GetWeaponProperties (val), u232 (val), IsWeaponEquippedInTeamCategory (val), Remotes (val), Top (val)
    -- upvalues: Loadout (val), Profiler (val), u228 (val)
    local v1
    if a1.Type ~= "Weapon" then
        if a1.Type == "Melee" then
            if a1.Name == "CT Knife" and a2 == "Terrorists" then
                return
            end
            if a1.Name == "T Knife" and a2 == "Counter-Terrorists" then
                return
            end
            Remotes.Inventory.EquipSpecialItem.Send({Path = "Equipped Melee", Identifier = a1._id, Team = a2})
            return
        end
        if u228[a1.Type] then
            Remotes.Inventory.EquipSpecialItem.Send({Identifier = a1._id, Path = u228[a1.Type], Team = a2})
        end
        return
    end
    local Name = a1.Name
    local success, result = pcall(GetWeaponProperties, Name)
    if not (if not success then nil else if not result then nil else if not result.Type then nil else u232[result.Type]) then
        return
    end
    local v2, v3 = IsWeaponEquippedInTeamCategory(Name, a2, v1)
    if v2 and v3 then
        Remotes.Inventory.EquipLoadoutSkin.Send({Type = v1, Slot = v3 - 1, Team = a2, Identifier = a1._id})
        return
    end
    Top.openFrame("Loadout")
    Loadout.SelectTeam(if a2 ~= "Counter-Terrorists" then "T" else "CT")
    Loadout.SortByCategory(nil)
    Loadout.SortByWeapon(Name)
    Profiler.defer("UI.Inventory.LoadoutWeaponFilterDeferred", Loadout.SortByWeapon, Name)
end

local function SetDropdownOpen(a1, a2) -- Line: 324 -- types: a1: userdata?, a2: boolean
    if not a1 then
        return
    end
    a1.Visible = a2
    a1.Active = a2
    local Scroll = a1:FindFirstChild("Scroll")
    if Scroll and Scroll:IsA("GuiObject") then
        Scroll.Visible = a2
        Scroll.Active = a2
    end
end

local function setSortDropdownOpen(a1) -- Line: 339 -- upvalues: u210 (ref) -- types: a1: boolean
    local v1 = u210
    if not v1 then
        return
    end
    v1.Visible = a1
    v1.Active = a1
    local Scroll = v1:FindFirstChild("Scroll")
    if Scroll and Scroll:IsA("GuiObject") then
        Scroll.Visible = a1
        Scroll.Active = a1
    end
end

local function BindSortDropdownFocus(a1, a2, a3, a4) -- Line: 344
    -- upvalues: GuiService (val), Profiler (val)
    local function getInitialSortOption() -- Line: 350 -- upvalues: a1 (val), a3 (val)
        local v1 = a1.Scroll:FindFirstChild((a3()))
        if v1 and v1:IsA("GuiButton") and v1.Selectable then
            return v1
        end
        for i, v in ipairs(a1.Scroll:GetChildren()) do
            if v:IsA("GuiButton") and v.Selectable then
                return v
            end
        end
        return nil
    end

    ;(a1:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 363
        -- upvalues: GuiService (upval), a1 (val), getInitialSortOption (val), Profiler (upval), a4 (val), a2 (val)
        if GuiService.SelectedObject == nil then
            return
        end
        if a1.Visible then
            local u5 = getInitialSortOption()
            if not u5 then
                return
            end
            Profiler.defer(a4, function() -- Line: 370 -- upvalues: a1 (upval), GuiService (upval), u5 (val)
                if a1.Visible then
                    GuiService.SelectedObject = u5
                end
            end)
            return
        end
        local SelectedObject = GuiService.SelectedObject
        if SelectedObject and SelectedObject:IsDescendantOf(a1.Scroll) then
            GuiService.SelectedObject = a2
        end
    end)
end

local function BindSearchTap(a1, a2) -- Line: 387 -- types: a1: userdata, a2: userdata
    a1.MouseButton1Click:Connect(function() -- Line: 388 -- upvalues: a2 (val)
        a2:CaptureFocus()
    end)
    a1.Activated:Connect(function() -- Line: 391 -- upvalues: a2 (val)
        a2:CaptureFocus()
    end)
end

local function IsMouseOverVisibleGui(a1, a2) -- Line: 396 -- types: a1: userdata?, a2: userdata
    if a1 and a1.Visible then
        local AbsolutePosition = a1.AbsolutePosition
        local AbsoluteSize = a1.AbsoluteSize
        local v1 = false
        if AbsolutePosition.X <= a2.X then
            v1 = false
            if a2.X <= AbsolutePosition.X + AbsoluteSize.X then
                v1 = false
                if AbsolutePosition.Y <= a2.Y then
                    v1 = a2.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                end
            end
        end
        return v1
    end
    return false
end

local function IsMouseOverBlockingUI() -- Line: 407 -- upvalues: Mouse (val), u211 (ref), u210 (ref), u209 (ref)
    local v1
    local v2 = Vector2.new(Mouse.X, Mouse.Y)
    if u211.Ignore.ItemNotification.Visible then
        return true
    end
    local v3 = u210
    if not v3 then
        v1 = false
    elseif v3.Visible then
        local AbsolutePosition = v3.AbsolutePosition
        local AbsoluteSize = v3.AbsoluteSize
        v1 = false
        if AbsolutePosition.X <= v2.X then
            v1 = false
            if v2.X <= AbsolutePosition.X + AbsoluteSize.X then
                v1 = false
                if AbsolutePosition.Y <= v2.Y then
                    v1 = v2.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                end
            end
        end
    else
        v1 = false
    end
    if v1 then
        return v1
    end
    v3 = u209
    if v3 and v3.Visible then
        local AbsolutePosition_2 = v3.AbsolutePosition
        local AbsoluteSize_2 = v3.AbsoluteSize
        v1 = false
        if AbsolutePosition_2.X <= v2.X then
            v1 = false
            if v2.X <= AbsolutePosition_2.X + AbsoluteSize_2.X then
                v1 = false
                if AbsolutePosition_2.Y <= v2.Y then
                    v1 = v2.Y <= AbsolutePosition_2.Y + AbsoluteSize_2.Y
                end
            end
        end
        return v1
    end
    return false
end

local function shouldRunInventoryUpdate() -- Line: 418 -- upvalues: u211 (ref)
    local Visible = false
    if u211 ~= nil then
        Visible = u211.Visible
    end
    return Visible
end

local function stopInventoryUpdate() -- Line: 424 -- upvalues: u222 (ref)
    if u222 then
        u222:Disconnect()
        u222 = nil
    end
end

local function updateInventoryHeartbeat(a1) -- Line: 433
    -- upvalues: Profiler (val), u211 (ref), u212 (ref), u222 (ref), u194 (val), u0 (val)
    Profiler.mark("UI.Inventory.Heartbeat")
    if u211 and u212 then
        local Visible = false
        if u211 ~= nil then
            Visible = u211.Visible
        end
        if not Visible or not u194 or not u211.Visible then
            u211.Ignore.Hover.Visible = false
        else
            u0.UpdateHoverFrame(a1)
        end
        if Visible and u211.Ignore.ItemNotification.Visible then
            u211.Ignore.ItemNotification.Holder.Light.Rotation = u211.Ignore.ItemNotification.Holder.Light.Rotation + a1 * 10
        end
        if not Visible and u222 then
            u222:Disconnect()
            u222 = nil
        end
        return
    end
    if u222 then
        u222:Disconnect()
        u222 = nil
    end
end

local function syncInventoryUpdate() -- Line: 459
    -- upvalues: u211 (ref), u212 (ref), u215 (val), u216 (val), u199 (ref), u222 (ref), RunServiceController (val)
    -- upvalues: updateInventoryHeartbeat (val)
    if u211 and u212 then
        local v1 = 0
        for i, v in ipairs(u215) do
            if not u216[v._id] then
                v1 = v1 + 1
            end
        end
        local Alert = u212.Menu.Top.Bottom.Buttons.Inventory.Alert
        Alert.TextLabel.Text = v1
        Alert.Visible = v1 > 0
        local v2 = #u215
        local Holder = u211.Ignore.ItemNotification.Holder
        local v3 = u199
        Holder.Amount.TextLabel.Text = ("%* / %*"):format(v3, v2)
        Holder.Right.Visible = u199 < v2
        Holder.Left.Visible = u199 > 1
        local Visible = false
        if u211 ~= nil then
            Visible = u211.Visible
        end
        if not Visible then
            updateInventoryHeartbeat(0)
            return
        end
        if u222 then
            return
        end
        u222 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat)
        updateInventoryHeartbeat(0)
        return
    end
end

local function CalculateHoverPosition(a1) -- Line: 491 -- upvalues: u211 (ref), GuiService (val)
    local AbsolutePosition_2 = u211.AbsolutePosition
    local AbsoluteSize_2 = u211.Ignore.Hover.AbsoluteSize
    local AbsolutePosition = a1.AbsolutePosition
    local AbsoluteSize_3 = u211.AbsoluteSize
    local AbsoluteSize = a1.AbsoluteSize
    local v1 = AbsolutePosition.X - AbsolutePosition_2.X
    local v2 = AbsolutePosition.Y - AbsolutePosition_2.Y
    local v3 = AbsoluteSize_3.X - (v1 + AbsoluteSize.X)
    local v4 = AbsoluteSize_2.X + 8 <= v3 and (v1 + AbsoluteSize.X + 8 + AbsoluteSize_2.X / 2) / AbsoluteSize_3.X or (v1 - 8 - AbsoluteSize_2.X / 2) / AbsoluteSize_3.X
    v3 = math.max((v2 + AbsoluteSize.Y / 2) / AbsoluteSize_3.Y, AbsoluteSize_2.Y / 2 / AbsoluteSize_3.Y)
    local v5 = 1 - AbsoluteSize_2.Y / 2 / AbsoluteSize_3.Y
    v3 = math.min(v3, v5)
    local Y = (GuiService:GetGuiInset()).Y
    if AbsolutePosition_2.Y + v3 * AbsoluteSize_3.Y - AbsoluteSize_2.Y / 2 <= Y then
        v3 = v3 + 30 / AbsoluteSize_3.Y
        v3 = math.min(v3, v5)
    end
    return UDim2.fromScale(v4, v3)
end

local function ReportViewedItems() -- Line: 538 -- upvalues: u217 (val), Remotes (val)
    local v1 = {}
    for i in u217 do
        table.insert(v1, i)
    end
    table.clear(u217)
    if #v1 > 0 then
        Remotes.Player.NewInventoryItemsSeen.Send({Dismissed = false, ItemIds = v1})
    end
end

local function MarkItemViewed(a1) -- Line: 549
    -- upvalues: u216 (val), u217 (val), u219 (ref), ReportViewedItems (val)
    if u216[a1] then
        return
    end
    u216[a1] = true
    u217[a1] = true
    if not u219 then
        u219 = true
        task.delay(2, function() -- Line: 558 -- upvalues: u219 (upval), ReportViewedItems (upval)
            u219 = false
            ReportViewedItems()
        end)
    end
end

local function DismissItemNotifications() -- Line: 565
    -- upvalues: u211 (ref), u199 (ref), u220 (ref), u215 (val), u218 (val), u217 (val), Remotes (val), u214 (ref)
    -- upvalues: u216 (val), u223 (ref), syncInventoryUpdate (val)
    u211.Ignore.ItemNotification.Visible = false
    u199 = 0
    u220 = nil
    local v1 = {}
    local v2 = {}
    local v3 = os.clock()
    for i, v in ipairs(u215) do
        table.insert(v1, v._id)
        v2[v._id] = true
        u218[v._id] = v3
    end
    if #v1 > 0 then
        table.clear(u217)
        Remotes.Player.NewInventoryItemsSeen.Send({Dismissed = true, ItemIds = v1})
        local v4 = {}
        for i2, i3 in ipairs(u214) do
            if not v2[i3] then
                table.insert(v4, i3)
            end
        end
        u214 = v4
    end
    table.clear(u215)
    table.clear(u216)
    u223 = false
    syncInventoryUpdate()
end

local function FindQueuedItemIndex(a1) -- Line: 597 -- upvalues: u215 (val) -- types: a1: string
    for i, v in ipairs(u215) do
        if v._id == a1 then
            return i
        end
    end
    return nil
end

local function RefreshNewInventoryItems() -- Line: 607
    -- upvalues: u215 (val), u199 (ref), DataController (val), LocalPlayer (val), u214 (ref), u216 (val), u211 (ref)
    -- upvalues: u223 (ref), u0 (val), u220 (ref), syncInventoryUpdate (val)
    local v1, v2
    local v3 = u215[u199]
    local v4 = {}
    local v5 = DataController.Get(LocalPlayer, "Inventory")
    if type(v5) == "table" then
        for i, v in ipairs(v5) do
            if v._id then
                v4[v._id] = v
            end
        end
    end
    table.clear(u215)
    local v6 = {}
    for i2, i3 in ipairs(u214) do
        v6[i3] = true
        v2 = v4[i3]
        if v2 then
            table.insert(u215, v2)
        end
    end
    local v7 = nil
    for j in u216, nil, v7 do
        if not v6[j] then
            u216[j] = nil
        end
    end
    local Visible = false
    if u211 ~= nil then
        Visible = u211.Ignore.ItemNotification.Visible
    end
    local Visible_2 = Visible and u211.Visible
    if #u215 ~= 0 then
        v7 = v3
        if v7 then
            local _id = v3._id
            for i4, k in ipairs(u215) do
                if k._id == _id then
                    v7 = i4
                    if not v7 then
                        v1 = 0
                        for i5, n in ipairs(u215) do
                            if not u216[n._id] then
                                break
                            end
                            v1 = v1 + 1
                        end
                        u199 = v1
                        if Visible_2 then
                            u0.NextInventoryItem((math.min(v1 + 1, #u215)))
                        elseif Visible then
                            u211.Ignore.ItemNotification.Visible = false
                        end
                    else
                        u199 = v7
                    end
                    v7 = u220
                    if v7 then
                        v1 = u220
                        for i6, m in ipairs(u215) do
                            if m._id == v1 then
                                v7 = i6
                                if v7 then
                                    u220 = nil
                                    if not u211 or not u211.Visible then
                                        u199 = v7 - 1
                                    else
                                        u0.NextInventoryItem(v7)
                                    end
                                end
                                syncInventoryUpdate()
                                return
                            end
                        end
                        v7 = nil
                    end
                    if v7 then
                        u220 = nil
                        if not u211 or not u211.Visible then
                            u199 = v7 - 1
                        else
                            u0.NextInventoryItem(v7)
                        end
                    end
                    syncInventoryUpdate()
                    return
                end
            end
            v7 = nil
        end
        if not v7 then
            v1 = 0
            for i7, i52 in ipairs(u215) do
                if not u216[i52._id] then
                    break
                end
                v1 = v1 + 1
            end
            u199 = v1
            if Visible_2 then
                u0.NextInventoryItem((math.min(v1 + 1, #u215)))
            elseif Visible then
                u211.Ignore.ItemNotification.Visible = false
            end
        else
            u199 = v7
        end
    else
        if Visible then
            u211.Ignore.ItemNotification.Visible = false
        end
        u199 = 0
        u223 = false
    end
    v7 = u220
    if v7 then
        v1 = u220
        for i8, i62 in ipairs(u215) do
            if i62._id == v1 then
                v7 = i8
                if v7 then
                    u220 = nil
                    if not u211 or not u211.Visible then
                        u199 = v7 - 1
                    else
                        u0.NextInventoryItem(v7)
                    end
                end
                syncInventoryUpdate()
                return
            end
        end
        v7 = nil
    end
    if v7 then
        u220 = nil
        if not u211 or not u211.Visible then
            u199 = v7 - 1
        else
            u0.NextInventoryItem(v7)
        end
    end
    syncInventoryUpdate()
end

local function InspectInventoryItem(a1) -- Line: 683 -- upvalues: Router (val)
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

local function GetIconImage(a1, a2, a3) -- Line: 703 -- upvalues: Skins (val) -- types: a3: boolean
    if not a2 then
        return ""
    end
    if a3 then
        return a2.imageAssetId or ""
    end
    if a1.Type ~= "Charm" then
        return Skins.GetWearImageForFloat(a2, a1.Float or 0.9999) or a2.imageAssetId or ""
    end
    local Pattern = a1.Pattern
    if Pattern and a2.charmImages then
        for i, v in ipairs(a2.charmImages) do
            if v.pattern == Pattern then
                return v.assetId
            end
        end
    end
    return a2.imageAssetId or ""
end

local function GetItemDisplayName(a1, a2, a3) -- Line: 728
    -- upvalues: GetSkinDisplayName (val), u224 (val)
    local v1 = GetSkinDisplayName.GetWeaponDisplayName(a1.Name, a1.NameTag)
    local caseType = a3 and a2.caseType and u224[a2.caseType] or a3 and a2.caseType or a1.StatTrack and "KillTrak™ " .. v1 or v1
    return (if a1.Type ~= "Melee" then "" else "★ ") .. caseType
end

local function findCharmInventoryItemInList(a1, a2) -- Line: 741 -- types: a2: table?
    if a1 and a1 ~= false and a2 then
        local _id = nil
        if type(a1) == "table" then
            _id = a1._id
        elseif type(a1) == "string" then
            _id = a1
        end
        if not _id then
            return nil
        end
        for i, v in ipairs(a2) do
            if v._id == _id and v.Type == "Charm" then
                return v
            end
        end
        return nil
    end
    return nil
end

local function syncItemTemplateCharmIcon(a1, a2) -- Line: 767
    -- upvalues: DataController (val), LocalPlayer (val), findCharmInventoryItemInList (val)
    -- upvalues: GetResolvedSkinInformation (val), GetIconImage (val)
    local Charm = a1.ItemContent:FindFirstChild("Charm")
    if Charm and Charm:IsA("ImageLabel") then
        local v1 = ""
        if a2.Type == "Weapon" then
            local Charm_2 = a2.Charm
            local v2 = false
            if Charm_2 ~= nil then
                v2 = false
                if Charm_2 ~= false then
                    v2 = true
                    if type(Charm_2) ~= "string" then
                        v2 = true
                        if Charm_2 ~= true then
                            v2 = type(Charm_2) == "table"
                        end
                    end
                end
            end
            if v2 then
                local v3 = findCharmInventoryItemInList(a2.Charm, (DataController.Get(LocalPlayer, "Inventory")))
                local v4 = v3 and GetResolvedSkinInformation(v3.Name, v3.Skin)
                if v4 then
                    v1 = GetIconImage(v3, v4, false)
                end
            end
        end
        if v1 == "" then
            Charm.Visible = false
            Charm.Image = ""
            return
        end
        Charm.Image = v1
        Charm.Visible = true
        return
    end
end

local function GetCollectionNameForItem(a1) -- Line: 792
    -- upvalues: Cases (val), u201 (ref), GetResolvedSkinInformation (val)
    local v1
    if a1.Type ~= "Case" then
        v1 = GetResolvedSkinInformation(a1.Name, a1.Skin)
        return v1 and v1.collection or nil
    end
    v1 = Cases.GetCaseByName(a1.Skin)
    if v1 and u201 then
        for i, v in ipairs(u201) do
            if v.cases then
                for i2, i3 in ipairs(v.cases) do
                    if i3 == v1.name then
                        return v.name
                    end
                end
            end
        end
        return nil
    end
    return nil
end

local function GetSortedInventoryData() -- Line: 821
    -- upvalues: DataController (val), LocalPlayer (val), u202 (ref), u211 (ref), Sort (val), u201 (ref), Grenades (val)
    -- upvalues: u203 (ref)
    local v1, v2
    local v3 = DataController.Get(LocalPlayer, "Inventory")
    if not v3 then
        return {}
    end
    local u79 = Sort.GetSortComparisonFunction(u202 or u211.Frame.Right.Top.Filter.Container.Left.Title.Text, LocalPlayer, function() -- Line: 829 -- upvalues: u201 (upval)
        return u201
    end)
    local v4 = {}
    local v5 = nil
    local v6 = nil
    for i, j in v3, v5, v6 do
        v2 = j and Grenades[j.Name]
        v1 = j
        if v1 then
            v1 = true
            if j.Type ~= "Case" then
                v1 = j.Type == "Package"
            end
        end
        if j and j._id and j.Name and (v1 or j.Skin) and not v2 then
            table.insert(v4, j)
        end
    end
    if u79 then
        if u203 then
            table.sort(v4, function(a1, a2) -- Line: 847 -- upvalues: u79 (val)
                local v1, v2 = u79(a1, a2)
                if v2 then
                    return v1
                end
                return u79(a2, a1)
            end)
            return v4
        end
        table.sort(v4, u79)
    end
    return v4
end

local function IsNotFiltered(a1, a2) -- Line: 866
    -- upvalues: Buttons (val), GetWeaponProperties (val)
    if a2 and #a2 ~= 0 then
        local v1, v2, v3, v4
        local v5 = Buttons.GetEffectiveItemType(a1)
        local v6 = Buttons.IsCapsule(a1)
        local v7 = a1
        for i, v in ipairs(a2) do
            if v5 == v then
                return true
            end
            if v7.Type and v7.Type == v and not v6 then
                return true
            end
            v4 = nil
            if v7.Name then
                v4 = GetWeaponProperties(v7.Name)
            end
            if string.find(v, ":") then
                v1 = string.split(v, ":")
                v2 = v1[1]
                v3 = v1[2]
                if v2 == "Weapon" and v4 and v4.Class == "Weapon" and v4.Type == v3 then
                    return true
                end
            elseif v4 and v4.Class == v then
                return true
            end
        end
        return false
    end
    return true
end

local function SetSearchTokens(a1, a2) -- Line: 916 -- types: a1: table, a2: string
    table.clear(a1)
    if a2 ~= "" then
        for i, v in ipairs(string.split(string.lower(a2), " ")) do
            if v ~= "" then
                table.insert(a1, v)
            end
        end
    end
end

local function MatchesSearchQuery(a1) -- Line: 928 -- upvalues: u208 (val), GetSkinDisplayName (val)
    if #u208 == 0 then
        return true
    end
    local v1 = GetSkinDisplayName.GetSearchIdentity(a1.Name, a1.Skin):lower()
    for i, v in ipairs(u208) do
        if string.find(v1, v, 1, true) == nil then
            return false
        end
    end
    return true
end

local function ApplyFilterToSortedData(a1) -- Line: 943
    -- upvalues: Buttons (val), u237 (val), DataController (val), LocalPlayer (val), IsNotFiltered (val), u208 (val)
    -- upvalues: MatchesSearchQuery (val)
    local v1, v2, v3
    local v4 = {}
    local v5 = nil
    local v6 = nil
    for i, j in Buttons, v5, v6 do
        if type(j) == "table" then
            v2 = nil
            v3 = nil
            for k, n in j, v2, v3 do
                if u237[k] then
                    for m, i5 in n.Search do
                        table.insert(v4, i5)
                    end
                end
            end
        end
    end
    local v7 = {}
    v5 = DataController.Get(LocalPlayer, "Inventory")
    if v5 then
        local _id
        for i2, v in ipairs(v5) do
            if v.Charm then
                if type(v.Charm) ~= "table" then
                    _id = false
                    if type(v.Charm) == "string" then
                        _id = v.Charm
                    end
                else
                    _id = v.Charm._id
                    if not _id then
                        _id = false
                        if type(v.Charm) == "string" then
                            _id = v.Charm
                        end
                    end
                end
                if _id then
                    v7[_id] = true
                end
            end
        end
    end
    v6 = {}
    for i3, i6 in ipairs(a1) do
        v1 = IsNotFiltered(i6, v4)
        if v1 and i6.Type == "Charm" and v7[i6._id] then
            v1 = false
        end
        if v1 then
            table.insert(v6, i6)
        end
    end
    local v8 = #u208
    if v8 > 0 then
        v8 = {}
        for i4, i7 in ipairs(v6) do
            if MatchesSearchQuery(i7) then
                table.insert(v8, i7)
            end
        end
        v6 = v8
    end
    return v6
end

local function CreateMissingItemTemplates(a1, a2, a3) -- Line: 1006
    -- upvalues: u187 (ref), u0 (val)
    local v1
    for i = a2, a3 do
        v1 = u187[i]
        if v1 and not a1:FindFirstChild(v1._id) then
            u0.CreateItemTemplate(v1)
        end
    end
end

local function ApplySortedLayoutOrder(a1) -- Line: 1015 -- upvalues: u187 (ref) -- types: a1: userdata
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("Frame") and v.Name ~= "UIGridLayout" and v.Name ~= "UIListLayout" and v.Name ~= "UIPadding" then
            for i2, i3 in ipairs(u187) do
                if i3._id == v.Name then
                    v.LayoutOrder = i2
                    break
                end
            end
        end
    end
end

local function RenderInventoryTemplates() -- Line: 1033
    -- upvalues: Profiler (val), u211 (ref), u206 (ref), u187 (ref), CreateMissingItemTemplates (val)
    -- upvalues: ApplySortedLayoutOrder (val)
    Profiler.mark("UI.Inventory.RenderInventoryTemplates")
    if u211 and u211.Visible then
        local Container = u211.Frame.Right.Container
        local v1 = math.min(u206 + 25, #u187)
        CreateMissingItemTemplates(Container, u206 + 1, v1)
        u206 = v1
        ApplySortedLayoutOrder(Container)
    end
end

local function OnScrollPositionChanged() -- Line: 1046
    -- upvalues: u211 (ref), u206 (ref), u187 (ref), Profiler (val), CreateMissingItemTemplates (val)
    -- upvalues: ApplySortedLayoutOrder (val)
    if u211 and u211.Visible then
        local Y = u211.Frame.Right.Container.CanvasPosition.Y
        local v1 = u211.Frame.Right.Container.AbsoluteCanvasSize.Y - u211.Frame.Right.Container.AbsoluteSize.Y
        if v1 > 0 and u206 < #u187 and v1 - Y < 200 then
            Profiler.mark("UI.Inventory.RenderInventoryTemplates")
            if u211 and u211.Visible then
                local Container_2 = u211.Frame.Right.Container
                local v2 = math.min(u206 + 25, #u187)
                CreateMissingItemTemplates(Container_2, u206 + 1, v2)
                u206 = v2
                ApplySortedLayoutOrder(Container_2)
            end
        end
    end
end

local function CalculateInitialRenderCount() -- Line: 1065 -- upvalues: u211 (ref), CalculateGridRenderCount (val)
    if u211 and u211.Visible then
        return CalculateGridRenderCount(u211.Frame.Right.Container)
    end
    return 50
end

local function RenderInitialTemplates() -- Line: 1074
    -- upvalues: Profiler (val), u211 (ref), u206 (ref), CalculateGridRenderCount (val), u187 (ref)
    -- upvalues: CreateMissingItemTemplates (val), ApplySortedLayoutOrder (val)
    Profiler.mark("UI.Inventory.RenderInitialTemplates")
    if u211 and u211.Visible then
        local Container = u211.Frame.Right.Container
        u206 = 0
        local v1 = math.min(
            math.max(if not u211 then 50 else if u211.Visible then CalculateGridRenderCount(u211.Frame.Right.Container) else 50, 50),
            #u187
        )
        CreateMissingItemTemplates(Container, 1, v1)
        ApplySortedLayoutOrder(Container)
        u206 = v1
        return
    end
end

local function IsItemTemplate(a1) -- Line: 1094 -- types: a1: userdata
    local v1 = a1:IsA("ImageButton")
    if v1 then
        v1 = false
        if a1.Name ~= "UIGridLayout" then
            v1 = false
            if a1.Name ~= "UIListLayout" then
                v1 = false
                if a1.Name ~= "UIPadding" then
                    v1 = false
                    if a1.Name ~= "Title" then
                        v1 = a1.Name ~= "Label"
                    end
                end
            end
        end
    end
    return v1
end

local function UpdateInventoryTemplates() -- Line: 1105
    -- upvalues: Profiler (val), u211 (ref), u206 (ref), RenderInitialTemplates (val)
    local v1
    Profiler.mark("UI.Inventory.UpdateInventoryTemplates")
    if not u211 then
        return
    end
    for i, v in ipairs(u211.Frame.Right.Container:GetChildren()) do
        v1 = v:IsA("ImageButton")
        if v1 then
            v1 = false
            if v.Name ~= "UIGridLayout" then
                v1 = false
                if v.Name ~= "UIListLayout" then
                    v1 = false
                    if v.Name ~= "UIPadding" then
                        v1 = false
                        if v.Name ~= "Title" then
                            v1 = v.Name ~= "Label"
                        end
                    end
                end
            end
        end
        if v1 then
            v:Destroy()
        end
    end
    u206 = 0
    if u211.Visible then
        RenderInitialTemplates()
    end
end

local function ApplyCurrentSort() -- Line: 1128
    -- upvalues: Profiler (val), u211 (ref), u187 (ref), GetSortedInventoryData (val), ApplyFilterToSortedData (val)
    -- upvalues: UpdateInventoryTemplates (val)
    Profiler.mark("UI.Inventory.ApplyCurrentSort")
    if not u211 or not u211.Visible then
        return
    end
    u187 = GetSortedInventoryData()
    u187 = ApplyFilterToSortedData(u187)
    UpdateInventoryTemplates()
end

local function ConnectButtonActivation(a1, a2) -- Line: 1147 -- types: a1: userdata, a2: function
    a1.MouseButton1Click:Connect(a2)
    a1.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: a2 (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            a2()
        end
    end)
end

local function AnimateSortButton(a1, a2, a3, a4, a5) -- Line: 1158
    -- upvalues: Router (val), u209 (ref), u202 (ref), Profiler (val), u211 (ref), u187 (ref)
    -- upvalues: GetSortedInventoryData (val), ApplyFilterToSortedData (val), UpdateInventoryTemplates (val)
    a2.Selectable = true

    local function handleSortOptionClick() -- Line: 1167
        -- upvalues: Router (upval), u209 (upval), u202 (upval), a3 (val), Profiler (upval), u211 (upval), u187 (upval)
        -- upvalues: GetSortedInventoryData (upval), ApplyFilterToSortedData (upval), UpdateInventoryTemplates (upval)
        -- upvalues: a4 (val), a1 (val), a2 (val), a5 (val)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        if u209 then
            u209.Visible = false
        end
        u202 = a3
        Profiler.mark("UI.Inventory.ApplyCurrentSort")
        if u211 and u211.Visible then
            u187 = GetSortedInventoryData()
            u187 = ApplyFilterToSortedData(u187)
            UpdateInventoryTemplates()
        end
        a4.Text = a3
        for i, v in ipairs(a1:GetChildren()) do
            if v:IsA("TextButton") then
                v.Frame.BackgroundTransparency = if v ~= a2 then 1 else 0
            end
        end
        a5()
    end

    a2.MouseButton1Click:Connect(handleSortOptionClick)
    a2.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: handleSortOptionClick (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            handleSortOptionClick()
        end
    end)
end

function u0.CreateItemTemplate(a1) -- Line: 1188
    -- upvalues: Profiler (val), Cases (val), GetResolvedSkinInformation (val), Rarities (val), GetIconImage (val)
    -- upvalues: ReplicatedStorage (val), u211 (ref), GetWeaponProperties (val), syncItemTemplateCharmIcon (val)
    -- upvalues: ApplyWearAndSerialBadges (val), GetSkinDisplayName (val), u224 (val), UpdateStatusFrame (val)
    -- upvalues: Mouse (val), u210 (ref), u209 (ref), DataController (val), LocalPlayer (val), Router (val), u198 (ref)
    -- upvalues: u195 (ref), u0 (val), GetVisibleInformationFrameButtons (val), UserInputService (val), u197 (ref)
    -- upvalues: u205 (ref), u194 (val), u196 (ref)
    Profiler.mark("UI.Inventory.CreateItemTemplate")
    if a1 and a1._id then
        local v1 = true
        if a1.Type ~= "Case" then
            v1 = a1.Type == "Package"
        end
        local v2 = v1 and Cases.GetCaseByName(a1.Skin) or GetResolvedSkinInformation(a1.Name, a1.Skin)
        if not v2 then
            print((("[Inventory] Skipping template creation for item: %* | %* (Type: %*) - No item information found"):format(
                a1.Name,
                a1.Skin,
                a1.Type
            )))
            return
        end
        local caseRarity = v1 and v2.caseRarity or v2.rarity
        local v3 = Rarities[caseRarity]
        local v4 = GetIconImage(a1, v2, v1)
        local u58 = ReplicatedStorage.Assets.UI.Inventory.ItemTemplate:Clone()
        u58.ItemContent.Rarity.BackgroundColor3 = v3.Color
        u58.Parent = u211.Frame.Right.Container
        u58.ItemContent.Content.Icon.Image = v4
        u58.Name = a1._id
        local v5 = GetWeaponProperties(a1.Name)
        if v5 and v5.InventoryIconData then
            local Icon = u58.ItemContent.Content.Icon
            local ScaleType = v5.InventoryIconData.ScaleType or u58.ItemContent.Content.Icon.ScaleType or u58.ItemContent.Content.Icon.Position
            Icon.ScaleType = ScaleType
            local Icon_2 = u58.ItemContent.Content.Icon
            local Size = v5.InventoryIconData.Size or u58.itemTemplate.ItemContent.Content.Icon.Size
            Icon_2.Size = Size
        end
        syncItemTemplateCharmIcon(u58, a1)
        ApplyWearAndSerialBadges(u58, a1, v2)
        local ApplyNameLabel = GetSkinDisplayName.ApplyNameLabel
        local WeaponName = u58.Bottom.Footer.WeaponName
        local v6 = a1
        local v7 = GetSkinDisplayName.GetWeaponDisplayName(v6.Name, v6.NameTag)
        local caseType = v1 and v2.caseType and u224[v2.caseType] or v1 and v2.caseType or v6.StatTrack and "KillTrak™ " .. v7 or v7
        ApplyNameLabel(WeaponName, (if v6.Type ~= "Melee" then "" else "★ ") .. caseType, a1.NameTag)
        u58.Bottom.Footer.SkinName.Text = GetSkinDisplayName(v1 and v2.skin or a1.Skin or "")
        UpdateStatusFrame(u58, a1._id)
        u58.Selectable = true

        local function handleItemSelection(a1_2) -- Line: 1245
            -- upvalues: u211 (upval), Mouse (upval), u210 (upval), u209 (upval), DataController (upval)
            -- upvalues: LocalPlayer (upval), a1 (ref), Router (upval), u198 (upval), u58 (val), u195 (upval)
            -- upvalues: u0 (upval), GetVisibleInformationFrameButtons (upval), UserInputService (upval)
            -- upvalues: Profiler (upval), u197 (upval), u205 (upval)
            if not u211.Ignore.ItemNotification.Visible then
                local v1, v2
                local v3 = Vector2.new(Mouse.X, Mouse.Y)
                if not u211.Ignore.ItemNotification.Visible then
                    v2 = u210
                    if not v2 then
                        v1 = false
                    elseif v2.Visible then
                        local AbsolutePosition = v2.AbsolutePosition
                        local AbsoluteSize = v2.AbsoluteSize
                        v1 = false
                        if AbsolutePosition.X <= v3.X then
                            v1 = false
                            if v3.X <= AbsolutePosition.X + AbsoluteSize.X then
                                v1 = false
                                if AbsolutePosition.Y <= v3.Y then
                                    v1 = v3.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                                end
                            end
                        end
                    else
                        v1 = false
                    end
                    if not v1 then
                        v2 = u209
                        if not v2 then
                            v1 = false
                        elseif v2.Visible then
                            local AbsolutePosition_2 = v2.AbsolutePosition
                            local AbsoluteSize_2 = v2.AbsoluteSize
                            v1 = false
                            if AbsolutePosition_2.X <= v3.X then
                                v1 = false
                                if v3.X <= AbsolutePosition_2.X + AbsoluteSize_2.X then
                                    v1 = false
                                    if AbsolutePosition_2.Y <= v3.Y then
                                        v1 = v3.Y <= AbsolutePosition_2.Y + AbsoluteSize_2.Y
                                    end
                                end
                            end
                        else
                            v1 = false
                        end
                    end
                else
                    v1 = true
                end
                if not v1 then
                    v1 = DataController.Get(LocalPlayer, "Inventory")
                    if v1 then
                        for i, v in ipairs(v1) do
                            if v._id == a1._id then
                                a1 = v
                                break
                            end
                        end
                    end
                    v3 = true
                    if a1.Type ~= "Case" then
                        v3 = a1.Type == "Package"
                    end
                    v2 = true
                    if a1.Type ~= "Charm Capsule" then
                        v2 = a1.Type == "Sticker Capsule"
                    end
                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    u198 = u58
                    u195 = a1
                    u0.SetupInformationFrame(a1)
                    local v4 = false
                    if u209 ~= nil then
                        v4 = #GetVisibleInformationFrameButtons() > 0
                    end
                    if not v4 then
                        u209.Visible = false
                        return
                    end

                    local function positionInformationFrame() -- Line: 1275
                        -- upvalues: u209 (upval), UserInputService (upval), a1_2 (val), u58 (upval), Mouse (upval)
                        local AbsolutePosition_2, AbsoluteSize_2, v1, v2
                        local Parent = u209.Parent.Parent
                        local AbsolutePosition = Parent.AbsolutePosition
                        local AbsoluteSize = Parent.AbsoluteSize
                        local v3 = (UserInputService:GetLastInputType()) == Enum.UserInputType.Gamepad1
                        local X = nil
                        local Y = nil
                        if v3 then
                            if u58 and u58:IsA("GuiObject") then
                                AbsolutePosition_2 = u58.AbsolutePosition
                                AbsoluteSize_2 = u58.AbsoluteSize
                                X = AbsolutePosition_2.X + AbsoluteSize_2.X / 2
                                Y = AbsolutePosition_2.Y + AbsoluteSize_2.Y / 2
                            end
                        elseif not a1_2 then
                            X = Mouse.X
                            Y = Mouse.Y
                        elseif u58 and u58:IsA("GuiObject") then
                            AbsolutePosition_2 = u58.AbsolutePosition
                            AbsoluteSize_2 = u58.AbsoluteSize
                            X = AbsolutePosition_2.X + AbsoluteSize_2.X / 2
                            Y = AbsolutePosition_2.Y + AbsoluteSize_2.Y / 2
                        end
                        if not X then
                            v1 = 0.5
                            v2 = 0.5
                        else
                            v1 = (X - AbsolutePosition.X) / AbsoluteSize.X
                            v2 = (Y - AbsolutePosition.Y) / AbsoluteSize.Y + u209.Size.Y.Scale / 2
                            local v4 = 1 - v1
                            v1 = if not (u209.Size.X.Scale + 0.01 <= v4) then v1 - u209.Size.X.Scale / 2 - 0.01 else v1 + u209.Size.X.Scale / 2 + 0.01
                        end
                        u209.Position = UDim2.fromScale(v1, v2)
                    end

                    if not v3 and not v2 then
                        if not a1_2 then
                            u209.Visible = not u209.Visible
                        else
                            u209.Visible = true
                        end
                        if not u209.Visible then
                            if u197 then
                                u205 = tick()
                            end
                            return
                        end
                        positionInformationFrame()
                        u211.Ignore.Hover.Visible = false
                        Profiler.defer("UI.Inventory.InformationNavigationDeferred", function() -- Line: 1335 -- upvalues: u0 (upval), a1_2 (val)
                            u0.SetupInformationFrameNavigation()
                            if a1_2 then
                                u0.SelectFirstInformationFrameButton()
                            end
                        end)
                        return
                    end
                    u209.Visible = true
                    positionInformationFrame()
                    u211.Ignore.Hover.Visible = false
                    if a1_2 then
                        Profiler.defer("UI.Inventory.InformationNavigationDeferred", function() -- Line: 1317 -- upvalues: u0 (upval)
                            u0.SetupInformationFrameNavigation()
                            u0.SelectFirstInformationFrameButton()
                        end)
                    end
                    return
                end
            end
        end

        u58.MouseButton1Click:Connect(function() -- Line: 1346 -- upvalues: handleItemSelection (val)
            handleItemSelection(false)
        end)
        u58.Activated:Connect(function(a1) -- Line: 1349 -- upvalues: handleItemSelection (val)
            if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                handleItemSelection(true)
            end
        end)
        if u194 then
            u58.MouseEnter:Connect(function() -- Line: 1357 -- upvalues: u196 (upval), a1 (ref), u197 (upval), u58 (val), u205 (upval)
                u196 = a1
                u197 = u58
                u205 = tick()
            end)
            u58.MouseLeave:Connect(function() -- Line: 1363 -- upvalues: u197 (upval), u196 (upval), u205 (upval)
                u197 = nil
                u196 = nil
                u205 = nil
            end)
        end
        return
    end
end

function u0.UpdateInventory(a1) -- Line: 1373
    -- upvalues: Profiler (val), u211 (ref), u195 (ref), u198 (ref), u196 (ref), u209 (ref), u187 (ref)
    -- upvalues: GetSortedInventoryData (val), ApplyFilterToSortedData (val), UpdateInventoryTemplates (val)
    Profiler.mark("UI.Inventory.UpdateInventory")
    if not u211 then
        return
    end
    if a1 and type(a1) == "table" then
        local v1
        if not u211.Visible then
            return
        end
        local Container = u211.Frame.Right.Container
        local v2 = {}
        for i, v in ipairs(a1) do
            if v and v._id then
                v2[v._id] = true
            end
        end
        if u195 and u195._id and not v2[u195._id] then
            u195 = nil
            u198 = nil
            u196 = nil
            if u209 then
                u209.Visible = false
            end
        end
        for i2, i3 in ipairs(Container:GetChildren()) do
            v1 = i3:IsA("ImageButton")
            if v1 then
                v1 = false
                if i3.Name ~= "UIGridLayout" then
                    v1 = false
                    if i3.Name ~= "UIListLayout" then
                        v1 = false
                        if i3.Name ~= "UIPadding" then
                            v1 = false
                            if i3.Name ~= "Title" then
                                v1 = i3.Name ~= "Label"
                            end
                        end
                    end
                end
            end
            if v1 and not v2[i3.Name] then
                i3:Destroy()
            end
        end
        Profiler.mark("UI.Inventory.ApplyCurrentSort")
        if not u211 or not u211.Visible then
            return
        end
        u187 = GetSortedInventoryData()
        u187 = ApplyFilterToSortedData(u187)
        UpdateInventoryTemplates()
        return
    end
    print("UpdateInventory received invalid inventory data:", a1)
end

function u0.UpdateTemplates(a1) -- Line: 1420
    -- upvalues: Profiler (val), u211 (ref), GetResolvedSkinInformation (val), Rarities (val), GetIconImage (val)
    -- upvalues: syncItemTemplateCharmIcon (val), UpdateStatusFrame (val)
    Profiler.mark("UI.Inventory.UpdateTemplates")
    if u211 and u211.Visible then
        local Container = u211.Frame.Right.Container
        if a1 then
            local v1, v2
            for i, v in ipairs(a1) do
                v1 = Container:FindFirstChild(v._id)
                if v1 and v1:IsA("Frame") then
                    v2 = GetResolvedSkinInformation(v.Name, v.Skin)
                    if v2 then
                        v1.Main.RarityFrame.UIGradient.Color = Rarities[v2.rarity].ColorSequence
                        v1.Main.Glow.UIGradient.Color = Rarities[v2.rarity].ColorSequence
                        v1.Main.Icon.Image = GetIconImage(v, v2, false)
                    end
                    syncItemTemplateCharmIcon(v1, v)
                    UpdateStatusFrame(v1, v._id)
                end
            end
        end
        return
    end
end

function u0.SetupInformationFrameNavigation() -- Line: 1449
    -- upvalues: u209 (ref), GetVisibleInformationFrameButtons (val)
    local v1
    if not u209 then
        return
    end
    local v2 = GetVisibleInformationFrameButtons()
    table.sort(v2, function(a1, a2) -- Line: 1455
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

function u0.SetupItemNotificationNavigation() -- Line: 1472 -- upvalues: u211 (ref)
    if u211 and u211.Ignore.ItemNotification then
        local Holder = u211.Ignore.ItemNotification.Holder
        local Left = if not Holder.Left.Visible then nil else Holder.Left
        local Right = if not Holder.Right.Visible then nil else Holder.Right
        local v1 = {}
        for i, j in {Holder.ViewLoadout, Holder.Continue} do
            if j and j.Visible then
                table.insert(v1, j)
            end
        end
        table.sort(v1, function(a1, a2) -- Line: 1487
            return a1.AbsolutePosition.X < a2.AbsolutePosition.X
        end)
        local v2 = v1[1]
        local v3 = v1[#v1]
        for i2, v in ipairs(v1) do
            v.NextSelectionLeft = v1[i2 - 1] or Left
            v.NextSelectionRight = v1[i2 + 1] or Right
            v.NextSelectionUp = Right or Left
            v.NextSelectionDown = nil
        end
        if Left then
            Left.NextSelectionLeft = nil
            Left.NextSelectionRight = Right or v2
            Left.NextSelectionUp = nil
            Left.NextSelectionDown = v2
        end
        if Right then
            Right.NextSelectionLeft = Left or v3
            Right.NextSelectionRight = nil
            Right.NextSelectionUp = nil
            Right.NextSelectionDown = v3
        end
        return
    end
end

function u0.EnsureItemNotificationSelection() -- Line: 1516
    -- upvalues: UserInputService (val), u211 (ref), GuiService (val), u0 (val)
    if UserInputService.GamepadEnabled and u211.Ignore.ItemNotification.Visible then
        local Holder = u211.Ignore.ItemNotification.Holder
        local SelectedObject = GuiService.SelectedObject
        if SelectedObject
            and SelectedObject:IsDescendantOf(Holder)
            and SelectedObject:IsA("GuiButton")
            and SelectedObject.Visible then
            return
        end
        if SelectedObject == Holder.Left and Holder.Right.Visible then
            GuiService.SelectedObject = Holder.Right
            return
        end
        if SelectedObject == Holder.Right and Holder.Left.Visible then
            GuiService.SelectedObject = Holder.Left
            return
        end
        u0.SelectFirstItemNotificationButton()
        return
    end
end

function u0.SelectFirstItemNotificationButton() -- Line: 1537
    -- upvalues: UserInputService (val), u211 (ref), GuiService (val)
    if not UserInputService.GamepadEnabled then
        return
    end
    if u211 and u211.Ignore.ItemNotification and u211.Ignore.ItemNotification.Visible then
        local Holder = u211.Ignore.ItemNotification.Holder
        if Holder.ViewLoadout and Holder.ViewLoadout.Visible and Holder.ViewLoadout.Selectable then
            GuiService.SelectedObject = Holder.ViewLoadout
            return
        end
        if Holder.Continue and Holder.Continue.Visible and Holder.Continue.Selectable then
            GuiService.SelectedObject = Holder.Continue
        end
        return
    end
end

function u0.SelectFirstInformationFrameButton() -- Line: 1561
    -- upvalues: u209 (ref), u0 (val), GetVisibleInformationFrameButtons (val), GuiService (val)
    if u209 and u209.Visible then
        u0.SetupInformationFrameNavigation()
        local v1 = GetVisibleInformationFrameButtons()[1]
        if v1 then
            GuiService.SelectedObject = v1
        end
        return
    end
end

function u0.SetupInformationFrame(a1) -- Line: 1576
    -- upvalues: Profiler (val), DataController (val), LocalPlayer (val), u209 (ref), Cases (val)
    -- upvalues: GetWeaponProperties (val), IsEquippedOnTeam (val)
    local Charm, Inspect, QuickUnlock, Team, Team_2, TextLabel, Unlock, UnlockDivider, applyTeamRestriction, result, success, u213, u217, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17
    Profiler.mark("UI.Inventory.SetupInformationFrame")
    local v18 = DataController.Get(LocalPlayer, "Inventory")
    if v18 then
        local _id = a1._id
        for i, v in ipairs(v18) do
            if v._id == _id then
                a1 = v or a1
                v8 = a1.Type == "Weapon"
                v11 = a1.Type == "Melee"
                v12 = a1.Type == "Glove"
                v13 = a1.Type == "Badge"
                v14 = a1.Type == "Zeus x27"
                Inspect = u209.Inspect
                v16 = v8
                if not v16 then
                    v16 = v12
                    if not v16 then
                        v16 = v11
                        if not v16 then
                            v16 = v14
                            if not v16 then
                                v16 = true
                                if a1.Type ~= "Charm" then
                                    v16 = v13
                                end
                            end
                        end
                    end
                end
                Inspect.Visible = v16
                v15 = if a1.Type ~= "Case" then nil else Cases.GetCaseByName(a1.Skin)
                Unlock = u209.Unlock
                v17 = true
                if a1.Type ~= "Package" then
                    v17 = false
                    if v15 ~= nil then
                        v17 = Cases.HasCaseModel(v15.caseId)
                    end
                end
                Unlock.Visible = v17
                u209.Loadout.Visible = false
                QuickUnlock = u209:FindFirstChild("QuickUnlock")
                if QuickUnlock then
                    QuickUnlock.Visible = false
                end
                UnlockDivider = u209:FindFirstChild("UnlockDivider")
                if UnlockDivider then
                    UnlockDivider.Visible = false
                end
                v1 = v8 or v14 or a1.Type == "Charm"
                if not u209.Charm then
                    warn("[Inventory] InformationFrame.Charm element not found - item type:", a1.Type)
                end
                if u209.Charm then
                    u209.Charm.Visible = v1
                    if v1 then
                        TextLabel = u209.Charm:FindFirstChildWhichIsA("TextLabel", true)
                        if TextLabel then
                            if a1.Type ~= "Charm" then
                                Charm = a1.Charm
                                v2 = false
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
                                TextLabel.Text = if not v2 then "Attach Charm" else "Detach Charm"
                            else
                                TextLabel.Text = "Attach to Weapon"
                            end
                        end
                    end
                end
                u213 = false
                u217 = false

                function applyTeamRestriction(a1) -- Line: 1631
                    -- upvalues: u213 (ref), u217 (ref)
                    local v1 = true
                    if a1 ~= "Both" then
                        v1 = a1 == "Counter-Terrorists"
                    end
                    u213 = v1
                    v1 = true
                    if a1 ~= "Both" then
                        v1 = a1 == "Terrorists"
                    end
                    u217 = v1
                end

                if v8 then
                    success, result = pcall(GetWeaponProperties, a1.Name)
                    if success and result then
                        Team = result.Team
                        v6 = true
                        if Team ~= "Both" then
                            v6 = Team == "Counter-Terrorists"
                        end
                        u213 = v6
                        v6 = true
                        if Team ~= "Both" then
                            v6 = Team == "Terrorists"
                        end
                        u217 = v6
                    end
                elseif v11 then
                    u213 = a1.Name ~= "T Knife"
                    u217 = a1.Name ~= "CT Knife"
                elseif v12 then
                    v3 = GetWeaponProperties(a1.Name)
                    if v3 then
                        Team_2 = v3.Team
                        v5 = true
                        if Team_2 ~= "Both" then
                            v5 = Team_2 == "Counter-Terrorists"
                        end
                        u213 = v5
                        v5 = true
                        if Team_2 ~= "Both" then
                            v5 = Team_2 == "Terrorists"
                        end
                        u217 = v5
                    end
                elseif v13 or v14 then
                    u213 = true
                    u217 = true
                end
                v3 = IsEquippedOnTeam(a1._id, "Counter-Terrorists")
                v4 = IsEquippedOnTeam(a1._id, "Terrorists")
                v5 = v8 or v11 or v12 or v13 or v14
                if u209.ReplaceCT then
                    v7 = v5 and u213 and not v3
                    u209.ReplaceCT.Visible = v7
                end
                if u209.ReplaceT then
                    v7 = v5 and u217 and not v4
                    u209.ReplaceT.Visible = v7
                end
                v6 = {
                    {dividerName = "CharmDivider", action = u209.Charm},
                    {dividerName = "InspectDivider", action = u209.Inspect},
                    {dividerName = "ReplaceCTDivider", action = u209.ReplaceCT},
                    {dividerName = "ReplaceTDivider", action = u209.ReplaceT},
                    {dividerName = "LoadoutDivider", action = u209.Loadout},
                }
                v7 = {UnlockDivider = true}
                for i2, i3 in ipairs(v6) do
                    v7[i3.dividerName] = true
                end
                for i4, j in ipairs(v6) do
                    v9 = u209:FindFirstChild(j.dividerName)
                    if v9 and j.action then
                        v10 = false
                        if j.action.Visible then
                            for i5, k in ipairs(u209:GetChildren()) do
                                if not v7[k.Name] and k ~= v9 and k ~= j.action then
                                    if not k:IsA("Frame") and not k:IsA("TextButton") then
                                        continue
                                    end
                                    if k.LayoutOrder < v9.LayoutOrder and k.Visible then
                                        v10 = true
                                        break
                                    end
                                end
                            end
                        end
                        v9.Visible = v10
                    end
                end
                return
            end
        end
        a1 = a1
    end
    v8 = a1.Type == "Weapon"
    v11 = a1.Type == "Melee"
    v12 = a1.Type == "Glove"
    v13 = a1.Type == "Badge"
    v14 = a1.Type == "Zeus x27"
    Inspect = u209.Inspect
    v16 = v8
    if not v16 then
        v16 = v12
        if not v16 then
            v16 = v11
            if not v16 then
                v16 = v14
                if not v16 then
                    v16 = true
                    if a1.Type ~= "Charm" then
                        v16 = v13
                    end
                end
            end
        end
    end
    Inspect.Visible = v16
    v15 = if a1.Type ~= "Case" then nil else Cases.GetCaseByName(a1.Skin)
    Unlock = u209.Unlock
    v17 = true
    if a1.Type ~= "Package" then
        v17 = false
        if v15 ~= nil then
            v17 = Cases.HasCaseModel(v15.caseId)
        end
    end
    Unlock.Visible = v17
    u209.Loadout.Visible = false
    QuickUnlock = u209:FindFirstChild("QuickUnlock")
    if QuickUnlock then
        QuickUnlock.Visible = false
    end
    UnlockDivider = u209:FindFirstChild("UnlockDivider")
    if UnlockDivider then
        UnlockDivider.Visible = false
    end
    v1 = v8 or v14 or a1.Type == "Charm"
    if not u209.Charm then
        warn("[Inventory] InformationFrame.Charm element not found - item type:", a1.Type)
    end
    if u209.Charm then
        u209.Charm.Visible = v1
        if v1 then
            TextLabel = u209.Charm:FindFirstChildWhichIsA("TextLabel", true)
            if TextLabel then
                if a1.Type ~= "Charm" then
                    Charm = a1.Charm
                    v2 = false
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
                    TextLabel.Text = if not v2 then "Attach Charm" else "Detach Charm"
                else
                    TextLabel.Text = "Attach to Weapon"
                end
            end
        end
    end
    u213 = false
    u217 = false

    function applyTeamRestriction(a1) -- Line: 1631 -- upvalues: u213 (ref), u217 (ref) -- types: a1: string?
        local v1 = true
        if a1 ~= "Both" then
            v1 = a1 == "Counter-Terrorists"
        end
        u213 = v1
        v1 = true
        if a1 ~= "Both" then
            v1 = a1 == "Terrorists"
        end
        u217 = v1
    end

    if v8 then
        success, result = pcall(GetWeaponProperties, a1.Name)
        if success and result then
            Team = result.Team
            v6 = true
            if Team ~= "Both" then
                v6 = Team == "Counter-Terrorists"
            end
            u213 = v6
            v6 = true
            if Team ~= "Both" then
                v6 = Team == "Terrorists"
            end
            u217 = v6
        end
    elseif v11 then
        u213 = a1.Name ~= "T Knife"
        u217 = a1.Name ~= "CT Knife"
    elseif v12 then
        v3 = GetWeaponProperties(a1.Name)
        if v3 then
            Team_2 = v3.Team
            v5 = true
            if Team_2 ~= "Both" then
                v5 = Team_2 == "Counter-Terrorists"
            end
            u213 = v5
            v5 = true
            if Team_2 ~= "Both" then
                v5 = Team_2 == "Terrorists"
            end
            u217 = v5
        end
    elseif v13 or v14 then
        u213 = true
        u217 = true
    end
    v3 = IsEquippedOnTeam(a1._id, "Counter-Terrorists")
    v4 = IsEquippedOnTeam(a1._id, "Terrorists")
    v5 = v8 or v11 or v12 or v13 or v14
    if u209.ReplaceCT then
        v7 = v5 and u213 and not v3
        u209.ReplaceCT.Visible = v7
    end
    if u209.ReplaceT then
        v7 = v5 and u217 and not v4
        u209.ReplaceT.Visible = v7
    end
    v6 = {
        {dividerName = "CharmDivider", action = u209.Charm},
        {dividerName = "InspectDivider", action = u209.Inspect},
        {dividerName = "ReplaceCTDivider", action = u209.ReplaceCT},
        {dividerName = "ReplaceTDivider", action = u209.ReplaceT},
        {dividerName = "LoadoutDivider", action = u209.Loadout},
    }
    v7 = {UnlockDivider = true}
    for i6, n in ipairs(v6) do
        v7[n.dividerName] = true
    end
    for i7, m in ipairs(v6) do
        v9 = u209:FindFirstChild(m.dividerName)
        if v9 and m.action then
            v10 = false
            if m.action.Visible then
                for i8, i52 in ipairs(u209:GetChildren()) do
                    if not v7[i52.Name] and i52 ~= v9 and i52 ~= m.action then
                        if not i52:IsA("Frame") and not i52:IsA("TextButton") then
                            continue
                        end
                        if i52.LayoutOrder < v9.LayoutOrder and i52.Visible then
                            v10 = true
                            break
                        end
                    end
                end
            end
            v9.Visible = v10
        end
    end
end

function u0.ShowNewItemNotification(a1) -- Line: 1710
    -- upvalues: Profiler (val), u215 (val), u220 (ref), u211 (ref), u221 (ref), u0 (val), u199 (ref)
    -- upvalues: syncInventoryUpdate (val)
    local v1
    Profiler.mark("UI.Inventory.ShowNewItemNotification")
    local _id = a1._id
    for i, v in ipairs(u215) do
        if v._id == _id then
            v1 = i
            if not v1 then
                u220 = a1._id
            else
                u220 = nil
                if not u211.Visible then
                    u199 = v1 - 1
                else
                    u221 = a1._id
                    u0.NextInventoryItem(v1)
                end
            end
            u211.Visible = true
            syncInventoryUpdate()
            return
        end
    end
    v1 = nil
    if not v1 then
        u220 = a1._id
    else
        u220 = nil
        if not u211.Visible then
            u199 = v1 - 1
        else
            u221 = a1._id
            u0.NextInventoryItem(v1)
        end
    end
    u211.Visible = true
    syncInventoryUpdate()
end

function u0.NextInventoryItem(a1) -- Line: 1736
    -- upvalues: Profiler (val), u215 (val), u199 (ref), u216 (val), u217 (val), u219 (ref), ReportViewedItems (val)
    -- upvalues: Cases (val), GetResolvedSkinInformation (val), Rarities (val), GetSkinDisplayName (val)
    -- upvalues: GetIconImage (val), u211 (ref), u223 (ref), Router (val), u0 (val), syncInventoryUpdate (val)
    Profiler.mark("UI.Inventory.NextInventoryItem")
    local v1 = u215[a1]
    u199 = a1
    if v1 then
        local Skin, v2
        local _id = v1._id
        if not u216[_id] then
            u216[_id] = true
            u217[_id] = true
            if not u219 then
                u219 = true
                task.delay(2, function() -- Line: 558 -- upvalues: u219 (upval), ReportViewedItems (upval)
                    u219 = false
                    ReportViewedItems()
                end)
            end
        end
        local v3 = true
        if v1.Type ~= "Case" then
            v3 = v1.Type == "Package"
        end
        local v4 = v3 and Cases.GetCaseByName(v1.Skin) or GetResolvedSkinInformation(v1.Name, v1.Skin)
        local Blue = Rarities[if not v4 then v1.Rarity or "Blue" else v3 and v4.caseRarity or v4.rarity or v1.Rarity or "Blue"] or Rarities.Blue
        if not v3 or not v4 or not v4.Skin then
            v2 = GetSkinDisplayName.GetWeaponDisplayName(v1.Name, v1.NameTag)
            Skin = ("%* | %*"):format(v1.StatTrack and "KillTrak™ " .. v2 or v2, v1.Skin)
        else
            Skin = v4.Skin
        end
        v2 = GetIconImage(v1, v4, v3)
        local ViewLoadout = u211.Ignore.ItemNotification.Holder.ViewLoadout
        local v5 = false
        if v1.Type ~= "Case" then
            v5 = v1.Type ~= "Package"
        end
        ViewLoadout.Visible = v5
        u211.Ignore.ItemNotification.Holder.RarityFrame.UIGradient.Color = Blue.ColorSequence
        u211.Ignore.ItemNotification.Holder.Background.ImageColor3 = Blue.Color
        u211.Ignore.ItemNotification.Holder.IconShadow.Image = v2
        u211.Ignore.ItemNotification.Holder.Light.ImageColor3 = Blue.Color
        GetSkinDisplayName.ApplyNameLabel(u211.Ignore.ItemNotification.Holder.WeaponName, Skin, v1.NameTag)
        u211.Ignore.ItemNotification.Holder.Icon.Image = v2
        u211.Ignore.ItemNotification.Visible = true
        if not u223 then
            u223 = true
            Router.broadcastRouter("RunInterfaceSound", "New Item Reveal")
        end
        u211.Ignore.ItemNotification.Holder.Title.TextColor3 = Color3.new(Blue.Color.R * 0.56, Blue.Color.G * 0.56, Blue.Color.B * 0.56)
        Profiler.defer("UI.Inventory.ItemNotificationDeferred", function() -- Line: 1785 -- upvalues: u0 (upval)
            u0.SetupItemNotificationNavigation()
            u0.EnsureItemNotificationSelection()
        end)
        syncInventoryUpdate()
    end
end

local u331 = {
    Blue = 1,
    Purple = 2,
    Pink = 3,
    Red = 4,
    Special = 5,
    Forbidden = 6,
    Stock = 7,
}
local u332 = {
    Blue = "Blue",
    Purple = "Purple",
    Pink = "Pink",
    Red = "Red",
    Special = "★ Special",
    Forbidden = "★ Special",
}

local function ClearHoverCollectionFrames(a1) -- Line: 1815 -- types: a1: userdata
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("Frame") and v.Name ~= "UIListLayout" then
            v:Destroy()
        end
    end
end

local function HideHoverCollection() -- Line: 1823 -- upvalues: u211 (ref), ClearHoverCollectionFrames (val)
    local Collection = u211.Ignore.Hover.Collection
    if Collection then
        ClearHoverCollectionFrames(Collection)
        Collection.Visible = false
    end
    u211.Ignore.Hover.CollectionName.Visible = false
    u211.Ignore.Hover.CollectionSpacer.Visible = false
end

local function ShowHoverCollection(a1, a2) -- Line: 1833
    -- upvalues: u211 (ref), DataController (val), LocalPlayer (val), ClearHoverCollectionFrames (val)
    -- upvalues: GetResolvedSkinInformation (val), u331 (val), ReplicatedStorage (val), Rarities (val)
    local gun, item, rarity, v1, v2, v3
    local Collection = u211.Ignore.Hover.Collection
    local v4 = DataController.Get(LocalPlayer, "Inventory")
    ClearHoverCollectionFrames(Collection)
    local v5 = {}
    if v4 then
        for i, v in ipairs(v4) do
            if v.Name and v.Skin then
                v5[v.Name .. "|" .. v.Skin] = true
            end
        end
    end
    local v6 = {}
    for i2, i3 in ipairs(a1.items) do
        if i3.itemName and i3.skinName then
            v1 = GetResolvedSkinInformation(i3.itemName, i3.skinName)
            if v1 then
                table.insert(v6, {
                    item = i3,
                    rarity = v1.rarity,
                    rarityOrder = u331[v1.rarity] or 99,
                })
            end
        end
    end
    table.sort(v6, function(a1, a2) -- Line: 1862
        if a1.rarityOrder ~= a2.rarityOrder then
            return a1.rarityOrder < a2.rarityOrder
        end
        return a1.item.itemName < a2.item.itemName
    end)
    local CollectionNameTemplate = ReplicatedStorage.Assets.UI.Inventory.CollectionNameTemplate
    for i4, j in ipairs(v6) do
        item = j.item
        v2 = GetResolvedSkinInformation(item.itemName, item.skinName)
        if v2 and CollectionNameTemplate then
            v3 = CollectionNameTemplate:Clone()
            v3.Parent = Collection
            v3.LayoutOrder = i4
            v3.Visible = true
            gun = v3.gun
            gun.Text = "[" .. item.itemName .. "] | " .. item.skinName
            rarity = v2.rarity and Rarities[v2.rarity]
            if rarity then
                gun.TextColor3 = rarity.Color
            end
            gun.Visible = true
            v3.ImageLabel.Visible = v5[item.itemName .. "|" .. item.skinName] == true
        end
    end
    a2.Visible = true
    Collection.Visible = true
    u211.Ignore.Hover.CollectionSpacer.Visible = true
end

function u0.UpdateHoverFrame(a1) -- Line: 1897
    -- upvalues: u205 (ref), Mouse (val), u211 (ref), u210 (ref), u209 (ref), u197 (ref), u196 (ref)
    -- upvalues: CalculateHoverPosition (val), Cases (val), GetResolvedSkinInformation (val), GetSkinDisplayName (val)
    -- upvalues: u224 (val), GetCollectionNameForItem (val), Collections (val), ShowHoverCollection (val)
    -- upvalues: ClearHoverCollectionFrames (val), Rarities (val), u332 (val), Skins (val), GetWeaponProperties (val)
    local v1, v2
    local v3 = tick() - (u205 or 0)
    local v4 = Vector2.new(Mouse.X, Mouse.Y)
    if not u211.Ignore.ItemNotification.Visible then
        v2 = u210
        if not v2 then
            v1 = false
        elseif v2.Visible then
            local AbsolutePosition = v2.AbsolutePosition
            local AbsoluteSize = v2.AbsoluteSize
            v1 = false
            if AbsolutePosition.X <= v4.X then
                v1 = false
                if v4.X <= AbsolutePosition.X + AbsoluteSize.X then
                    v1 = false
                    if AbsolutePosition.Y <= v4.Y then
                        v1 = v4.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                    end
                end
            end
        else
            v1 = false
        end
        if not v1 then
            v2 = u209
            if not v2 then
                v1 = false
            elseif v2.Visible then
                local AbsolutePosition_2 = v2.AbsolutePosition
                local AbsoluteSize_2 = v2.AbsoluteSize
                v1 = false
                if AbsolutePosition_2.X <= v4.X then
                    v1 = false
                    if v4.X <= AbsolutePosition_2.X + AbsoluteSize_2.X then
                        v1 = false
                        if AbsolutePosition_2.Y <= v4.Y then
                            v1 = v4.Y <= AbsolutePosition_2.Y + AbsoluteSize_2.Y
                        end
                    end
                end
            else
                v1 = false
            end
        end
    else
        v1 = true
    end
    if u211.Visible and not v1 and not u209.Visible and u197 and u196 and v3 > 0.75 then
        u211.Ignore.Hover.Position = CalculateHoverPosition(u197)
        v4 = u196
        v2 = true
        if v4.Type ~= "Case" then
            v2 = v4.Type == "Package"
        end
        local v5 = v2 and Cases.GetCaseByName(v4.Skin) or GetResolvedSkinInformation(v4.Name, v4.Skin)
        if v5 then
            local description_2, v6
            local v7 = GetSkinDisplayName.GetWeaponDisplayName(v4.Name, v4.NameTag)
            local caseType = v2 and v5.caseType and u224[v5.caseType] or v2 and v5.caseType or v4.StatTrack and "KillTrak™ " .. v7 or v7
            local v8 = (if v4.Type ~= "Melee" then "" else "★ ") .. caseType
            v7 = GetSkinDisplayName(v2 and v5.skin or v4.Skin)
            local v9 = if v7 ~= "Vanilla" then " | " .. v7 else ""
            GetSkinDisplayName.ApplyNameLabel(u211.Ignore.Hover.ItemName.Frame.ItemName, v8 .. v9, v4.NameTag)
            local v10 = GetCollectionNameForItem(v4)
            u211.Ignore.Hover.ItemName.Frame.Collection.Text = v10 or ""
            local CollectionIcon = u211.Ignore.Hover.ItemName.CollectionIcon
            local v11 = v10 and Collections.GetCollectionByName(v10)
            if not v11 or not v11.imageAssetId then
                CollectionIcon.Visible = false
            else
                CollectionIcon.Image = v11.imageAssetId
                CollectionIcon.Visible = true
            end
            local CollectionName = u211.Ignore.Hover.CollectionName
            if not v10 then
                CollectionName.Visible = false
            else
                CollectionName.Text = v10 .. ":"
                CollectionName.Visible = true
            end
            local v12 = v10 and not v2 and Collections.GetCollectionByName(v10)
            if not v12 or not v12.items then
                local Collection = u211.Ignore.Hover.Collection
                if Collection then
                    ClearHoverCollectionFrames(Collection)
                    Collection.Visible = false
                end
                u211.Ignore.Hover.CollectionName.Visible = false
                u211.Ignore.Hover.CollectionSpacer.Visible = false
            else
                ShowHoverCollection(v12, CollectionName)
            end
            if v2 then
                description_2 = v5.description
            else
                local v13
                if v4.Type == "Weapon" or v4.Type == "Melee" or v4.Type == "Glove" then
                    v13 = GetResolvedSkinInformation(
                        if v4.Type ~= "Melee" then if v4.Type ~= "Glove" then v4.Name else "T Glove" else "T Knife",
                        "Stock"
                    )
                    description_2 = v13 and v13.description
                elseif v4.Type ~= "Zeus x27" then
                    description_2 = v5.description
                else
                    v13 = GetResolvedSkinInformation(
                        if v4.Type ~= "Melee" then if v4.Type ~= "Glove" then v4.Name else "T Glove" else "T Knife",
                        "Stock"
                    )
                    description_2 = v13 and v13.description
                end
            end
            u211.Ignore.Hover.Description.Text = description_2 or ""
            local v14 = true
            if v4.Type ~= "Charm Capsule" then
                v14 = v4.Type == "Sticker Capsule"
            end
            u211.Ignore.Hover.Information.Visible = not (v2 or v14)
            local caseRarity = v2 and v5.caseRarity or v5.rarity
            local v15 = caseRarity and Rarities[caseRarity]
            if not v15 then
                u211.Ignore.Hover.Information.Rarity.Label.Text = ""
            else
                u211.Ignore.Hover.Information.Rarity.Label.Text = u332[caseRarity] or caseRarity
                u211.Ignore.Hover.Information.Rarity.Label.TextColor3 = v15.Color
            end
            local Exterior = u211.Ignore.Hover.Information.Exterior
            local v16 = nil
            local v17 = nil
            if not v2 then
                local v18
                v18, v6 = Skins.GetWearNameForFloat(v5, v4.Float or v5.floatRange.max)
                v16 = v18
                v17 = v6
            end
            if not v16 or not v17 then
                Exterior.Visible = false
            else
                Exterior.Label.Text = v17
                Exterior.Visible = true
            end
            local Team = u211.Ignore.Hover.Information.Team.Team
            v6 = nil
            if v4.Type == "Melee"
                or v4.Type == "Glove"
                or v4.Type == "Badge"
                or v4.Type == "Charm"
                or v4.Type == "Zeus x27" then
                v6 = "Both"
            elseif v4.Type == "Weapon" then
                local v19 = GetWeaponProperties(v4.Name)
                local Team_2 = v19 and v19.Team
                if Team_2 then
                    v6 = if Team_2 == "Counter-Terrorists" then Team_2 else if Team_2 ~= "Terrorists" then "Both" else Team_2
                end
            end
            if v6 then
                Team.CT.Visible = v6 ~= "Terrorists"
                Team.T.Visible = v6 ~= "Counter-Terrorists"
                Team.Label.Visible = true
                Team.Label.Text = v6
            end
        end
        u211.Ignore.Hover.Visible = true
        return
    end
    u211.Ignore.Hover.Visible = false
end

function u0.Initialize(a1, a2) -- Line: 2046
    -- upvalues: Profiler (val), u212 (ref), u211 (ref), u209 (ref), CloseButtonRegistry (val), Router (val), u198 (ref)
    -- upvalues: GuiService (val), Collections (val), u201 (ref), u195 (ref), ActivateButton (val), Remotes (val)
    -- upvalues: UseItemFrame (val), MenuState (val), u204 (ref), Cases (val), Store (val), ReplaceItemOnTeam (val)
    -- upvalues: u199 (ref), u215 (val), u0 (val), UserInputService (val), LocalPlayer (val)
    -- upvalues: DismissItemNotifications (val), Loadout (val), u210 (ref), BindSortDropdownFocus (val), u202 (ref)
    -- upvalues: u203 (ref), u187 (ref), GetSortedInventoryData (val), ApplyFilterToSortedData (val)
    -- upvalues: UpdateInventoryTemplates (val), BindSearchTap (val), DataController (val)
    -- upvalues: GetResolvedSkinInformation (val), Rarities (val), GetIconImage (val), GetWeaponProperties (val)
    -- upvalues: syncItemTemplateCharmIcon (val), GetSkinDisplayName (val), TweenService (val), u194 (val), u196 (ref)
    -- upvalues: u197 (ref), u205 (ref), Sort (val), u227 (val), u223 (ref), SetSearchTokens (val), u213 (ref)
    -- upvalues: ContentProvider (val), u208 (val), syncInventoryUpdate (val), u221 (ref), ReportViewedItems (val)
    -- upvalues: OnScrollPositionChanged (val)
    local v1, v2, v3, v4, v5, v6
    Profiler.mark("UI.Inventory.Initialize")
    u212 = a1
    u211 = a2
    u209 = a2.Ignore.Information
    CloseButtonRegistry.Add(u209, nil, function() -- Line: 2052 -- upvalues: Router (upval), u209 (upval), u198 (upval), GuiService (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        u209.Visible = false
        if u198 and u198:FindFirstChild("Button") then
            local Button = u198:FindFirstChild("Button")
            if Button and Button:IsA("GuiButton") then
                GuiService.SelectedObject = Button
                return
            end
        end
    end)
    Collections.ObserveAvailableCollections(function(a1) -- Line: 2065 -- upvalues: u201 (upval)
        u201 = a1
    end)
    u209.Inspect.Selectable = true

    local function handleInspectClick() -- Line: 2071 -- upvalues: Router (upval), u195 (upval), u209 (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        if u195 then
            u209.Visible = false
            local v1 = u195
            Router.broadcastRouter(
                "WeaponInspect",
                v1.Name,
                v1.Skin,
                v1.Float,
                v1.StatTrack,
                v1.NameTag,
                v1.Charm,
                v1.Stickers,
                v1.Type,
                v1.Pattern,
                v1._id,
                v1.Serial,
                v1.IsTradeable
            )
        end
    end

    ActivateButton(u209.Inspect)
    local v7 = u209.Inspect
    v7.MouseButton1Click:Connect(handleInspectClick)
    v7.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: handleInspectClick (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            handleInspectClick()
        end
    end)
    if u209.Charm then
        u209.Charm.Selectable = true

        local function handleCharmClick() -- Line: 2084
            -- upvalues: Router (upval), u195 (upval), u209 (upval), Remotes (upval), u211 (upval), UseItemFrame (upval)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            if u195 then
                local Charm = u195.Charm
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
                u209.Visible = false
                if v1 then
                    Remotes.Inventory.RemoveWeaponCharm.Send({WeaponId = u195._id})
                    return
                end
                u211.Visible = false
                UseItemFrame.TriggerAction("AttachCharm", u195)
            end
        end

        v5 = u209.Charm
        v5.MouseButton1Click:Connect(handleCharmClick)
        v5.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: handleCharmClick (val)
            if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                handleCharmClick()
            end
        end)
    end
    UseItemFrame.OnItemSelected:Connect(function(a1, a2) -- Line: 2101 -- upvalues: UseItemFrame (upval)
        local v1 = UseItemFrame.GetActions().Get(a2.ActionType)
        if v1 then
            v1.OnItemSelected(a1, a2)
        end
    end)
    UseItemFrame.OnClosed:Connect(function(a1) -- Line: 2110 -- upvalues: MenuState (upval), u211 (upval)
        if MenuState.GetCurrentScreen() == "Inventory" then
            u211.Visible = true
        end
    end)
    u209.Unlock.Selectable = true

    local function handleUnlockClick() -- Line: 2119
        -- upvalues: u204 (upval), Router (upval), u195 (upval), Cases (upval), Store (upval), u209 (upval)
        -- upvalues: u211 (upval)
        if u204 then
            return
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        if not u195 then
            return
        end
        local v1 = Cases.GetCaseByName(u195.Skin)
        if v1 and Cases.HasCaseModel(v1.caseId) then
            Store.OpenCaseContent(v1.caseId, "Open", u195._id)
            u209.Visible = false
            u211.Visible = false
            return
        end
    end

    v5 = u209.Unlock
    v5.MouseButton1Click:Connect(handleUnlockClick)
    v5.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: handleUnlockClick (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            handleUnlockClick()
        end
    end)

    function v5(a1, a2) -- Line: 2137
        -- upvalues: Router (upval), u195 (upval), u209 (upval), ReplaceItemOnTeam (upval)
        if not a1 then
            return
        end
        a1.Selectable = true

        local function u3() -- Line: 2143
            -- upvalues: Router (upval), u195 (upval), u209 (upval), ReplaceItemOnTeam (upval), a2 (val)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            if u195 then
                u209.Visible = false
                ReplaceItemOnTeam(u195, a2)
            end
        end

        a1.MouseButton1Click:Connect(u3)
        a1.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: u3 (val)
            if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                u3()
            end
        end)
    end

    local v8 = u209.ReplaceT
    if v8 then
        v8.Selectable = true
        local u88 = "Terrorists"

        local function u89() -- Line: 2143
            -- upvalues: Router (upval), u195 (upval), u209 (upval), ReplaceItemOnTeam (upval), u88 (val)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            if u195 then
                u209.Visible = false
                ReplaceItemOnTeam(u195, u88)
            end
        end

        v8.MouseButton1Click:Connect(u89)
        v8.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: u89 (val)
            if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                u89()
            end
        end)
    end
    v8 = u209.ReplaceCT
    if v8 then
        v8.Selectable = true
        local u103 = "Counter-Terrorists"

        local function u104() -- Line: 2143
            -- upvalues: Router (upval), u195 (upval), u209 (upval), ReplaceItemOnTeam (upval), u103 (val)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            if u195 then
                u209.Visible = false
                ReplaceItemOnTeam(u195, u103)
            end
        end

        v8.MouseButton1Click:Connect(u104)
        v8.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: u104 (val)
            if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                u104()
            end
        end)
    end
    v8 = u211.Ignore.ItemNotification

    local function v9(a1) -- Line: 2157
        -- upvalues: u199 (upval), u215 (upval), Router (upval), u0 (upval)
        local v1 = u199 + a1
        if v1 >= 1 and v1 <= #u215 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u0.NextInventoryItem(v1)
        end
    end

    v8.Holder.Left.Selectable = true
    v8.Holder.Right.Selectable = true
    v8.Holder.Left.MouseButton1Click:Connect(function() -- Line: 2167 -- upvalues: u199 (upval), u215 (upval), Router (upval), u0 (upval)
        local v1 = u199 + -1
        if v1 >= 1 and v1 <= #u215 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u0.NextInventoryItem(v1)
        end
    end)
    v8.Holder.Right.MouseButton1Click:Connect(function() -- Line: 2170 -- upvalues: u199 (upval), u215 (upval), Router (upval), u0 (upval)
        local v1 = u199 + 1
        if v1 >= 1 and v1 <= #u215 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u0.NextInventoryItem(v1)
        end
    end)
    MenuState.RegisterBumperOverride(v8, function(a1) -- Line: 2176 -- upvalues: u199 (upval), u215 (upval), Router (upval), u0 (upval) -- types: a1: boolean
        local v1 = u199 + (if not a1 then 1 else -1)
        if v1 >= 1 and v1 <= #u215 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u0.NextInventoryItem(v1)
        end
        return true
    end, v8)
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 2182
        -- upvalues: LocalPlayer (upval), UserInputService (upval), u211 (upval), u199 (upval), u215 (upval)
        -- upvalues: Router (upval), u0 (upval)
        if not a2
            and not LocalPlayer:GetAttribute("IsPlayerChatting")
            and not UserInputService:GetFocusedTextBox()
            and u211
            and u211.Ignore.ItemNotification
            and u211.Ignore.ItemNotification.Visible then
            local v1
            if a1.KeyCode == Enum.KeyCode.Left then
                v1 = u199 + -1
                if v1 >= 1 and v1 <= #u215 then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    u0.NextInventoryItem(v1)
                end
                return
            end
            if a1.KeyCode ~= Enum.KeyCode.Right then
                return
            end
            v1 = u199 + 1
            if v1 >= 1 and v1 <= #u215 then
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                u0.NextInventoryItem(v1)
            end
            return
        end
    end)
    u211.Ignore.ItemNotification.Holder.Continue.Selectable = true
    u211.Ignore.ItemNotification.Holder.ViewLoadout.Selectable = true

    local function handleContinueClick() -- Line: 2208 -- upvalues: Router (upval), DismissItemNotifications (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        DismissItemNotifications()
    end

    local v10 = u211.Ignore.ItemNotification.Holder.Continue
    v10.MouseButton1Click:Connect(handleContinueClick)
    v10.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: handleContinueClick (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            handleContinueClick()
        end
    end)

    local function handleViewLoadoutClick() -- Line: 2215
        -- upvalues: u215 (upval), u199 (upval), Router (upval), DismissItemNotifications (upval), u211 (upval)
        -- upvalues: Loadout (upval)
        local v1 = u215[u199]
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        DismissItemNotifications()
        if v1 then
            if v1.Type == "Melee" or v1.Type == "Glove" or v1.Type == "Weapon" or v1.Type == "Zeus x27" then
                u211.Visible = false
                Loadout.ViewInLoadout(v1._id)
            end
        end
    end

    local v11 = u211.Ignore.ItemNotification.Holder.ViewLoadout
    v11.MouseButton1Click:Connect(handleViewLoadoutClick)
    v11.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: handleViewLoadoutClick (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            handleViewLoadoutClick()
        end
    end)
    local Filter = u211.Frame.Right.Top.Filter
    local DropdownContent = Filter.DropdownContent
    u210 = DropdownContent
    Filter.Active = true
    Filter.Selectable = true
    local v12 = u210
    if v12 then
        v12.Visible = false
        v12.Active = false
        local v13 = v12:FindFirstChild("Scroll")
        if v13 and v13:IsA("GuiObject") then
            v13.Visible = false
            v13.Active = false
        end
    end
    Filter.Activated:Connect(function() -- Line: 2245 -- upvalues: DropdownContent (val), u210 (upval), Router (upval)
        local v1 = not DropdownContent.Visible
        local v2 = u210
        if v2 then
            v2.Visible = v1
            v2.Active = v1
            local Scroll = v2:FindFirstChild("Scroll")
            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = v1
                Scroll.Active = v1
            end
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
    end)
    BindSortDropdownFocus(DropdownContent, Filter, function() -- Line: 2251 -- upvalues: u202 (upval), Filter (val)
        return u202 or Filter.Container.Left.Title.Text
    end, "UI.Inventory.SortFocusDeferred")
    local ReverseSort = u211.Frame.Right.Top.ReverseSort
    ReverseSort.Selectable = true
    ReverseSort.Activated:Connect(function() -- Line: 2257
        -- upvalues: u203 (upval), ReverseSort (val), Profiler (upval), u211 (upval), u187 (upval)
        -- upvalues: GetSortedInventoryData (upval), ApplyFilterToSortedData (upval), UpdateInventoryTemplates (upval)
        -- upvalues: Router (upval)
        u203 = not u203
        local v1 = u203
        local ImageLabel = ReverseSort:FindFirstChildOfClass("ImageLabel")
        if ImageLabel then
            ImageLabel.Rotation = if not v1 then 0 else 180
        end
        Profiler.mark("UI.Inventory.ApplyCurrentSort")
        if u211 and u211.Visible then
            u187 = GetSortedInventoryData()
            u187 = ApplyFilterToSortedData(u187)
            UpdateInventoryTemplates()
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
    end)
    for i, j in {"Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float", "Serial"} do
        local u1024 = DropdownContent.Scroll:FindFirstChild(j)
        if u1024 then
            local Scroll = DropdownContent.Scroll
            local Title_3 = Filter.Container.Left.Title

            local function u1030() -- Line: 2274 -- upvalues: u210 (upval)
                local v1 = u210
                if not v1 then
                    return
                end
                v1.Visible = false
                v1.Active = false
                local Scroll = v1:FindFirstChild("Scroll")
                if Scroll and Scroll:IsA("GuiObject") then
                    Scroll.Visible = false
                    Scroll.Active = false
                end
            end

            u1024.Selectable = true

            local function handleSortOptionClick() -- Line: 1167
                -- upvalues: Router (upval), u209 (upval), u202 (upval), j (val), Profiler (upval), u211 (upval)
                -- upvalues: u187 (upval), GetSortedInventoryData (upval), ApplyFilterToSortedData (upval)
                -- upvalues: UpdateInventoryTemplates (upval), Title_3 (val), Scroll (val), u1024 (val), u1030 (val)
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                if u209 then
                    u209.Visible = false
                end
                u202 = j
                Profiler.mark("UI.Inventory.ApplyCurrentSort")
                if u211 and u211.Visible then
                    u187 = GetSortedInventoryData()
                    u187 = ApplyFilterToSortedData(u187)
                    UpdateInventoryTemplates()
                end
                Title_3.Text = j
                for i, v in ipairs(Scroll:GetChildren()) do
                    if v:IsA("TextButton") then
                        v.Frame.BackgroundTransparency = if v ~= u1024 then 1 else 0
                    end
                end
                u1030()
            end

            u1024.MouseButton1Click:Connect(handleSortOptionClick)
            u1024.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: handleSortOptionClick (val)
                if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                    handleSortOptionClick()
                end
            end)
        end
    end
    local Title = u211.Frame.Right.Top.Search.Container.Container.Title
    BindSearchTap(u211.Frame.Right.Top.Search, Title)
    local v14 = u211.Frame.Right.Top.TradeUp
    local TradeUp = u211.Frame.TradeUp
    local u996 = {Blue = true, Purple = true, Pink = true}
    local u997 = {Blue = "Purple", Purple = "Pink", Pink = "Red"}
    local u998 = {"Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float", "Serial"}
    local u999 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Container = TradeUp.TradeContainer.Container
    local ItemTemplate = Container.ItemTemplate
    local Exchange = TradeUp.TradeContainer.Exchange
    local ItemTemplate_2 = Exchange.ItemTemplate
    local AddTemplate = Exchange.AddTemplate
    ItemTemplate.Visible = false
    ItemTemplate_2.Visible = false
    AddTemplate.Visible = false
    local v15 = {ItemTemplate, ItemTemplate_2, AddTemplate}
    local v16 = nil
    local v17 = nil
    for k, n in v15, v16, v17 do
        for i2, v in ipairs(n:GetDescendants()) do
            if v:IsA("GuiObject") then
                v.Active = false
                if v:IsA("GuiButton") then
                    v.Interactable = false
                    v.Selectable = false
                end
            end
        end
        if not n:FindFirstChildOfClass("UIScale") then
            Instance.new("UIScale").Parent = n
        end
    end
    for m, i5 in {ItemTemplate, ItemTemplate_2} do
        v1 = i5:FindFirstChild("Context")
        if v1 and v1:IsA("GuiObject") then
            v1.Visible = false
        end
    end
    for i6, i7 in {Container, Exchange} do
        v1 = i7:FindFirstChildOfClass("UIGridLayout")
        if v1 then
            v1.SortOrder = Enum.SortOrder.LayoutOrder
        end
    end
    local u547 = nil
    for i3, i8 in ipairs(TradeUp.Warning:GetChildren()) do
        if i8.Name == "WarningForTradeUp" then
            v2 = i8:FindFirstChild("Container")
            v3 = v2 and v2:FindFirstChild("Left")
            v4 = v3 and v3:FindFirstChild("Title")
            if v4 and v4:IsA("TextLabel") and string.find(v4.Text, "Selected For Exchange", 1, true) then
                u547 = v4
                break
            end
        end
    end
    local u402 = "Newest"
    local u403 = false
    local u404 = {}
    local u405 = {}
    local u406 = nil
    local selectTradeUpItem = nil
    local deselectTradeUpItem = nil
    local u410 = {}
    local u411 = true
    local v18 = LocalPlayer
    DataController.CreateListener(v18, "Inventory", function() -- Line: 2375 -- upvalues: u411 (ref)
        u411 = true
    end)

    local function v19(a1) -- Line: 2380
        local v1 = string.lower((a1.Name or "") .. " " .. (a1.Skin or ""))
        if string.find(v1, "zeus", 1, true) then
            v1 = v1 .. " taser"
        end
        return v1
    end

    local function tradeUpMatchesSearch(a1) -- Line: 2388 -- upvalues: u404 (val) -- types: a1: string
        if #u404 == 0 then
            return true
        end
        for i, v in ipairs(u404) do
            if string.find(a1, v, 1, true) == nil then
                return false
            end
        end
        return true
    end

    local u420 = {}
    Collections.ObserveAvailableCollections(function() -- Line: 2402 -- upvalues: u420 (val), u411 (ref)
        table.clear(u420)
        u411 = true
    end)

    local function collectionHasNextTier(a1, a2) -- Line: 2406
        -- upvalues: u997 (val), u201 (upval), u420 (val), GetResolvedSkinInformation (upval)
        if a1 and a1 ~= "" then
            local items, v1, v2
            local v3 = u997[a2]
            if not v3 or not u201 then
                return false
            end
            local v4 = a1 .. "|" .. v3
            local v5 = u420[v4]
            if v5 ~= nil then
                return v5
            end
            local v6 = false
            for i, v in ipairs(u201) do
                if v.name == a1 then
                    v1 = ipairs
                    items = v.items or {}
                    for i2, i3 in v1(items) do
                        v2 = GetResolvedSkinInformation(i3.itemName, i3.skinName)
                        if v2 and v2.rarity == v3 then
                            u420[v4] = true
                            return v6
                        end
                    end
                    break
                end
            end
            u420[v4] = v6
            return v6
        end
        return false
    end

    local u431 = {}

    local function getEligibleTradeUpInfo(a1) -- Line: 2442
        -- upvalues: u431 (val), GetResolvedSkinInformation (upval), u996 (val), collectionHasNextTier (val)
        if a1.Type ~= "Weapon" and a1.Type ~= "Zeus x27" then
            return nil
        end
        local v1 = (a1.Name or "") .. "|" .. (a1.Skin or "")
        local v2 = u431[v1]
        if v2 == nil then
            v2 = GetResolvedSkinInformation(a1.Name, a1.Skin)
            if v2 then
                u431[v1] = v2
            end
        end
        if not v2 then
            return nil
        end
        local rarity = v2.rarity
        if rarity and u996[rarity] then
            if not collectionHasNextTier(v2.collection, rarity) then
                return nil
            end
            return v2
        end
        return nil
    end

    local function getTradeUpKey(a1, a2) -- Line: 2470
        return (tostring(a2.rarity)) .. "|" .. (if not a1.StatTrack then "N" else "ST")
    end

    local function isTradeUpSelected(a1) -- Line: 2474 -- upvalues: u405 (val) -- types: a1: string
        return table.find(u405, a1) ~= nil
    end

    local function updateTradeUpWarning() -- Line: 2478 -- upvalues: u547 (ref), u405 (val)
        if u547 then
            u547.Text = ("%*/%* Selected For Exchange"):format(#u405, 10)
        end
    end

    local function clearRenderedItems(a1, a2) -- Line: 2485 -- types: a1: userdata, a2: userdata
        for i, v in ipairs(a1:GetChildren()) do
            if v:IsA("GuiObject") and v ~= a2 then
                v:Destroy()
            end
        end
    end

    local function buildTradeUpFrame(a1, a2, a3, a4, a5) -- Line: 2494
        -- upvalues: Rarities (upval), GetIconImage (upval), GetWeaponProperties (upval)
        -- upvalues: syncItemTemplateCharmIcon (upval), GetSkinDisplayName (upval), Router (upval), TweenService (upval)
        -- upvalues: u999 (val), u194 (upval), u196 (upval), u197 (upval), u205 (upval)
        local v1 = Rarities[a4.rarity]
        local u10 = a1:Clone()
        u10.Name = a3._id
        u10.Parent = a2
        u10.Visible = true
        u10.Selectable = true
        u10.ItemContent.Rarity.BackgroundColor3 = v1.Color
        u10.ItemContent.Content.Icon.Image = GetIconImage(a3, a4, false)
        local v2 = GetWeaponProperties(a3.Name)
        if v2 and v2.InventoryIconData then
            local Icon = u10.ItemContent.Content.Icon
            local ScaleType = v2.InventoryIconData.ScaleType or u10.ItemContent.Content.Icon.ScaleType
            Icon.ScaleType = ScaleType
            local Icon_2 = u10.ItemContent.Content.Icon
            local Size = v2.InventoryIconData.Size or u10.ItemContent.Content.Icon.Size
            Icon_2.Size = Size
        end
        syncItemTemplateCharmIcon(u10, a3)
        local v3 = GetSkinDisplayName.GetWeaponDisplayName(a3.Name, a3.NameTag)
        local v4 = a3.StatTrack and "KillTrak™ " .. v3 or v3
        GetSkinDisplayName.ApplyNameLabel(u10.Bottom.Footer.WeaponName, v4, a3.NameTag)
        u10.Bottom.Footer.SkinName.Text = GetSkinDisplayName(a3.Skin or "")
        local Context = u10:FindFirstChild("Context")
        local Inspect = u10.ItemContent:FindFirstChild("Inspect")
        if Inspect then
            Inspect.Visible = true
            Inspect.Active = true
            Inspect.Interactable = true
            Inspect.MouseButton1Click:Connect(function() -- Line: 2539 -- upvalues: Router (upval), a3 (val)
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                local v1 = a3
                Router.broadcastRouter(
                    "WeaponInspect",
                    v1.Name,
                    v1.Skin,
                    v1.Float,
                    v1.StatTrack,
                    v1.NameTag,
                    v1.Charm,
                    v1.Stickers,
                    v1.Type,
                    v1.Pattern,
                    v1._id,
                    v1.Serial,
                    v1.IsTradeable
                )
            end)
        end
        local UIScale = u10:FindFirstChildOfClass("UIScale")
        u10.MouseEnter:Connect(function() -- Line: 2547
            -- upvalues: Context (val), Router (upval), TweenService (upval), UIScale (val), u999 (upval), u194 (upval)
            -- upvalues: u196 (upval), a3 (val), u197 (upval), u10 (val), u205 (upval)
            if Context then
                Context.Visible = true
            end
            Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
            TweenService:Create(UIScale, u999, {Scale = 0.95}):Play()
            if u194 then
                u196 = a3
                u197 = u10
                u205 = tick()
            end
        end)
        u10.MouseLeave:Connect(function() -- Line: 2560
            -- upvalues: Context (val), TweenService (upval), UIScale (val), u999 (upval), u194 (upval), u197 (upval)
            -- upvalues: u10 (val), u196 (upval), u205 (upval)
            if Context then
                Context.Visible = false
            end
            TweenService:Create(UIScale, u999, {Scale = 1}):Play()
            if u194 and u197 == u10 then
                u197 = nil
                u196 = nil
                u205 = nil
            end
        end)
        u10.SelectionGained:Connect(function() -- Line: 2571 -- upvalues: Context (val)
            if Context then
                Context.Visible = true
            end
        end)
        u10.SelectionLost:Connect(function() -- Line: 2576 -- upvalues: Context (val)
            if Context then
                Context.Visible = false
            end
        end)
        u10.MouseButton1Down:Connect(function() -- Line: 2581 -- upvalues: TweenService (upval), UIScale (val), u999 (upval)
            TweenService:Create(UIScale, u999, {Scale = 0.9}):Play()
        end)
        u10.MouseButton1Up:Connect(function() -- Line: 2584 -- upvalues: TweenService (upval), UIScale (val), u999 (upval)
            TweenService:Create(UIScale, u999, {Scale = 0.95}):Play()
        end)
        u10.MouseButton1Click:Connect(function() -- Line: 2589 -- upvalues: a5 (val)
            a5()
        end)
        u10.Activated:Connect(function(a1) -- Line: 2592 -- upvalues: a5 (val)
            if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                a5()
            end
        end)
        return u10
    end

    local u452 = {}
    local u453 = 0
    local u454 = 0
    local u455 = 0

    local function renderNextTradeUpBatch(a1) -- Line: 2611
        -- upvalues: u453 (ref), u452 (val), buildTradeUpFrame (val), ItemTemplate (val), Container (val)
        -- upvalues: selectTradeUpItem (ref), u454 (ref)
        local v1
        local v2 = u453 + 1
        local v3 = math.min(u453 + a1, #u452)
        for i = v2, v3 do
            local u16 = u452[i]
            v1 = buildTradeUpFrame(ItemTemplate, Container, u16.item, u16.info, function() -- Line: 2621 -- upvalues: selectTradeUpItem (upval), u16 (val)
                selectTradeUpItem(u16.item, u16.info)
            end)
            u454 = u454 + 1
            v1.LayoutOrder = u454
        end
        u453 = v3
    end

    local function rebuildTradeUpPool() -- Line: 2632
        -- upvalues: u411 (ref), u410 (val), DataController (upval), LocalPlayer (upval), getEligibleTradeUpInfo (val)
        -- upvalues: Sort (upval), u402 (ref), u201 (upval), u403 (ref)
        local v1, v2, v3
        u411 = false
        table.clear(u410)
        local v4 = DataController.Get(LocalPlayer, "Inventory")
        if not v4 then
            return
        end
        for i, v in ipairs(v4) do
            if v and v._id then
                v2 = getEligibleTradeUpInfo(v)
                if v2 then
                    v3 = {
                        item = v,
                        info = v2,
                        key = (tostring(v2.rarity)) .. "|" .. (if not v.StatTrack then "N" else "ST"),
                    }
                    v1 = string.lower((v.Name or "") .. " " .. (v.Skin or ""))
                    if string.find(v1, "zeus", 1, true) then
                        v1 = v1 .. " taser"
                    end
                    v3.searchable = v1
                    table.insert(u410, v3)
                end
            end
        end
        local v5 = LocalPlayer
        local u26 = Sort.GetSortComparisonFunction(u402, v5, function() -- Line: 2656 -- upvalues: u201 (upval)
            return u201
        end)
        if u26 then
            table.sort(u410, function(a1, a2) -- Line: 2660 -- upvalues: u403 (upval), u26 (val)
                if not u403 then
                    return u26(a1.item, a2.item)
                end
                local v1, v2 = u26(a1.item, a2.item)
                if v2 then
                    return v1
                end
                return u26(a2.item, a1.item)
            end)
        end
    end

    local function renderTradeUpContainer() -- Line: 2674
        -- upvalues: u455 (ref), clearRenderedItems (val), Container (val), ItemTemplate (val), u452 (val), u453 (ref)
        -- upvalues: u454 (ref), u411 (ref), rebuildTradeUpPool (val), u410 (val), u405 (val), u406 (ref)
        -- upvalues: tradeUpMatchesSearch (val), renderNextTradeUpBatch (val), TradeUp (val)
        u455 = u455 + 1
        local u60 = u455
        clearRenderedItems(Container, ItemTemplate)
        table.clear(u452)
        u453 = 0
        u454 = 0
        if u411 then
            rebuildTradeUpPool()
        end
        for i, v in ipairs(u410) do
            if not (table.find(u405, v.item._id) ~= nil) then
                if u406 == nil then
                    if tradeUpMatchesSearch(v.searchable) then
                        table.insert(u452, v)
                    end
                elseif v.key == u406 and tradeUpMatchesSearch(v.searchable) then
                    table.insert(u452, v)
                end
            end
        end
        renderNextTradeUpBatch(25)
        if #u452 > 25 then
            task.defer(function() -- Line: 2700 -- upvalues: u60 (val), u455 (upval), TradeUp (upval), renderNextTradeUpBatch (upval)
                if u60 == u455 and TradeUp.Visible then
                    renderNextTradeUpBatch(25)
                end
            end)
        end
    end

    ;(Container:GetPropertyChangedSignal("CanvasPosition")):Connect(function() -- Line: 2709
        -- upvalues: TradeUp (val), u453 (ref), u452 (val), Container (val), renderNextTradeUpBatch (val)
        if TradeUp.Visible then
            local v1 = u453
            if not (#u452 <= v1) then
                v1 = Container.AbsoluteCanvasSize.Y - Container.AbsoluteSize.Y
                if v1 > 0 and v1 - Container.CanvasPosition.Y < 200 then
                    renderNextTradeUpBatch(25)
                end
                return
            end
        end
    end)
    local u481 = {}
    local u482 = {}
    for i9 = 1, 10 do
        v6 = AddTemplate:Clone()
        v6.Name = ("AddSlot%*"):format(i9)
        v6.Visible = true
        v6.LayoutOrder = i9 + 100
        v6.Active = false
        v6.Interactable = false
        v6.Selectable = false
        v6.Parent = Exchange
        u481[i9] = v6
        u482[v6] = true
    end

    local function v20() -- Line: 2736 -- upvalues: u405 (val), u481 (val)
        local v1
        local v2 = #u405
        for i, v in ipairs(u481) do
            v1 = v2 < i
            v.Visible = v1
        end
    end

    local function v21(a1, a2, a3) -- Line: 2744
        -- upvalues: buildTradeUpFrame (val), ItemTemplate_2 (val), Exchange (val), deselectTradeUpItem (ref)
        local _id = a1._id
        buildTradeUpFrame(ItemTemplate_2, Exchange, a1, a2, function() -- Line: 2751 -- upvalues: deselectTradeUpItem (upval), _id (val)
            local v0
            deselectTradeUpItem(_id)
            return
        end).LayoutOrder = a3
    end

    local function renderTradeUpExchange() -- Line: 2759
        -- upvalues: Exchange (val), ItemTemplate_2 (val), AddTemplate (val), u482 (val), DataController (upval)
        -- upvalues: LocalPlayer (upval), u405 (val), getEligibleTradeUpInfo (val), buildTradeUpFrame (val)
        -- upvalues: deselectTradeUpItem (ref), u481 (val)
        local v1, v2
        for i, v in ipairs(Exchange:GetChildren()) do
            if v:IsA("GuiObject") and v ~= ItemTemplate_2 and v ~= AddTemplate and not u482[v] then
                v:Destroy()
            end
        end
        local v3 = DataController.Get(LocalPlayer, "Inventory")
        if v3 then
            v1 = #u405
            if v1 > 0 then
                local v4, v5
                v1 = {}
                for i2, i3 in ipairs(v3) do
                    if i3 and i3._id then
                        v1[i3._id] = i3
                    end
                end
                local v6 = 0
                for i4, j in ipairs(u405) do
                    v4 = v1[j]
                    v5 = v4 and getEligibleTradeUpInfo(v4)
                    if v5 then
                        v6 = v6 + 1
                        local _id = v4._id
                        buildTradeUpFrame(ItemTemplate_2, Exchange, v4, v5, function() -- Line: 2751 -- upvalues: deselectTradeUpItem (upval), _id (val)
                            local v0
                            deselectTradeUpItem(_id)
                            return
                        end).LayoutOrder = v6
                    end
                end
            end
        end
        v1 = #u405
        for i5, k in ipairs(u481) do
            v2 = v1 < i5
            k.Visible = v2
        end
    end

    local function renderTradeUp() -- Line: 2795
        -- upvalues: renderTradeUpContainer (val), renderTradeUpExchange (val), u547 (ref), u405 (val)
        renderTradeUpContainer()
        renderTradeUpExchange()
        if u547 then
            u547.Text = ("%*/%* Selected For Exchange"):format(#u405, 10)
        end
    end

    function selectTradeUpItem(a1, a2) -- Line: 2801
        -- upvalues: Router (upval), u405 (val), u406 (ref), renderTradeUpContainer (val), u452 (val), u453 (ref)
        -- upvalues: Container (val), renderNextTradeUpBatch (val), buildTradeUpFrame (val), ItemTemplate_2 (val)
        -- upvalues: Exchange (val), deselectTradeUpItem (ref), u481 (val), u547 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        local v1 = #u405
        if not (v1 >= 10) then
            v1 = table.find(u405, a1._id) ~= nil
            if not v1 then
                local v2, v3
                v1 = (tostring(a2.rarity)) .. "|" .. (if not a1.StatTrack then "N" else "ST")
                if u406 and v1 ~= u406 then
                    return
                end
                if #u405 == 0 then
                    u406 = v1
                end
                table.insert(u405, a1._id)
                if not v3 then
                    local v4
                    for i, v in ipairs(u452) do
                        if v.item._id == a1._id then
                            table.remove(u452, i)
                            if not (i <= u453) then
                                break
                            end
                            u453 = u453 - 1
                            v4 = Container:FindFirstChild(a1._id)
                            if not v4 then
                                break
                            end
                            v4:Destroy()
                            break
                        end
                    end
                    if u453 < 50 and u453 < #u452 then
                        renderNextTradeUpBatch(50 - u453)
                    end
                else
                    renderTradeUpContainer()
                end
                local v5 = #u405
                local _id = a1._id
                buildTradeUpFrame(ItemTemplate_2, Exchange, a1, a2, function() -- Line: 2751 -- upvalues: deselectTradeUpItem (upval), _id (val)
                    local v0
                    deselectTradeUpItem(_id)
                    return
                end).LayoutOrder = v5
                v5 = #u405
                for i2, i3 in ipairs(u481) do
                    v2 = v5 < i2
                    i3.Visible = v2
                end
                if u547 then
                    u547.Text = ("%*/%* Selected For Exchange"):format(#u405, 10)
                end
                return
            end
        end
    end

    function deselectTradeUpItem(a1) -- Line: 2848
        -- upvalues: Router (upval), u405 (val), u406 (ref), renderTradeUpContainer (val), Exchange (val), u482 (val)
        -- upvalues: u481 (val), u547 (ref)
        local v1, v2
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        local v3 = table.find(u405, a1)
        if not v3 then
            return
        end
        table.remove(u405, v3)
        if #u405 == 0 then
            u406 = nil
        end
        renderTradeUpContainer()
        local v4 = Exchange:FindFirstChild(a1)
        if v4 and not u482[v4] then
            v4:Destroy()
        end
        for i, v in ipairs(u405) do
            v1 = Exchange:FindFirstChild(v)
            if v1 then
                v1.LayoutOrder = i
            end
        end
        local v5 = #u405
        for i2, i3 in ipairs(u481) do
            v2 = v5 < i2
            i3.Visible = v2
        end
        if u547 then
            u547.Text = ("%*/%* Selected For Exchange"):format(#u405, 10)
        end
    end

    function v6() -- Line: 2878 -- upvalues: u405 (val), u406 (ref)
        table.clear(u405)
        u406 = nil
    end

    local u561 = false
    local u562 = false
    local u563 = nil
    local u564 = 0
    local u565 = nil
    local u566 = false
    local u567 = false
    local u568 = false
    local Title_2 = TradeUp.Options.Proceed.Container.Title
    local Text = Title_2.Text
    local Position = TradeUp.Options.Cancel.Position
    local Position_2 = TradeUp.Options.Proceed.Position
    local u589 = UDim2.new(0.405, 0, Position.Y.Scale, Position.Y.Offset)
    local u597 = UDim2.new(0.595, 0, Position_2.Y.Scale, Position_2.Y.Offset)
    local u605 = UDim2.new(0.5, 0, Position_2.Y.Scale, Position_2.Y.Offset)
    local Frame = TradeUp.TradeContainer.Contract.Frame
    local Position_3 = Frame.Position
    local u617 = UDim2.new(Position_3.X.Scale, Position_3.X.Offset, 1.5, 0)
    local u622 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local u627 = Color3.fromRGB(49, 75, 114)
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "DrawingCanvas"
    Frame_2.BackgroundTransparency = 1
    Frame_2.AnchorPoint = Vector2.new(Frame.AnchorPoint.X, 0)
    Frame_2.Position = UDim2.new(Position_3.X.Scale, Position_3.X.Offset, 0, 0)
    Frame_2.Size = UDim2.new(Frame.Size.X.Scale, Frame.Size.X.Offset, 1, 0)
    Frame_2.ClipsDescendants = true
    Frame_2.ZIndex = 10
    Frame_2.Active = true
    Frame_2.Parent = TradeUp.TradeContainer.Contract
    local u661 = 0
    local u662 = false
    local u663 = nil

    local function v22() -- Line: 2942 -- upvalues: u662 (ref), u663 (ref), u661 (ref), Frame_2 (val)
        u662 = false
        u663 = nil
        u661 = 0
        for i, v in ipairs(Frame_2:GetChildren()) do
            v:Destroy()
        end
    end

    local function toContractCanvasPoint(a1) -- Line: 2952 -- upvalues: Frame_2 (val) -- types: a1: vector
        local AbsolutePosition = Frame_2.AbsolutePosition
        local AbsoluteSize = Frame_2.AbsoluteSize
        return Vector2.new(math.clamp(a1.X - AbsolutePosition.X, 0, AbsoluteSize.X), (math.clamp(a1.Y - AbsolutePosition.Y, 0, AbsoluteSize.Y)))
    end

    local function createContractInkFrame() -- Line: 2961 -- upvalues: u627 (val)
        local Frame = Instance.new("Frame")
        Frame.BackgroundColor3 = u627
        Frame.BorderSizePixel = 0
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
        Frame.ZIndex = 10
        return Frame
    end

    local function addContractDrawPoint(a1) -- Line: 2972
        -- upvalues: u661 (ref), u663 (ref), u627 (val), Frame_2 (val)
        if u661 >= 2500 then
            return
        end
        local v1 = u663
        if v1 and (a1 - v1).Magnitude < 2 then
            return
        end
        u661 = u661 + 1
        local Frame = Instance.new("Frame")
        Frame.BackgroundColor3 = u627
        Frame.BorderSizePixel = 0
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
        Frame.ZIndex = 10
        Frame.Position = UDim2.fromOffset(a1.X, a1.Y)
        Frame.Size = UDim2.fromScale(0.01, 0.01)
        Frame.Parent = Frame_2
        if v1 then
            local v2 = a1 - v1
            local v3 = (a1 + v1) / 2
            local Frame_3 = Instance.new("Frame")
            Frame_3.BackgroundColor3 = u627
            Frame_3.BorderSizePixel = 0
            Frame_3.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame_3.SizeConstraint = Enum.SizeConstraint.RelativeYY
            Frame_3.ZIndex = 10
            Frame_3.Position = UDim2.fromOffset(v3.X, v3.Y)
            Frame_3.Size = UDim2.new(0, v2.Magnitude, 0.01, 0)
            Frame_3.Rotation = math.deg((math.atan(v2.Y / v2.X)))
            Frame_3.Parent = Frame_2
        end
        u663 = a1
    end

    Frame_2.InputBegan:Connect(function(a1) -- Line: 3005 -- upvalues: u662 (ref), u663 (ref), addContractDrawPoint (val), toContractCanvasPoint (val)
        if a1.UserInputType == Enum.UserInputType.MouseButton1 or a1.UserInputType == Enum.UserInputType.Touch then
            u662 = true
            u663 = nil
            addContractDrawPoint(toContractCanvasPoint(a1.Position))
        end
    end)
    UserInputService.InputChanged:Connect(function(a1) -- Line: 3017 -- upvalues: u662 (ref), addContractDrawPoint (val), toContractCanvasPoint (val)
        if not u662 then
            return
        end
        if a1.UserInputType == Enum.UserInputType.MouseMovement or a1.UserInputType == Enum.UserInputType.Touch then
            addContractDrawPoint(toContractCanvasPoint(a1.Position))
        end
    end)
    UserInputService.InputEnded:Connect(function(a1) -- Line: 3029 -- upvalues: u662 (ref), u663 (ref)
        if a1.UserInputType == Enum.UserInputType.MouseButton1 or a1.UserInputType == Enum.UserInputType.Touch then
            u662 = false
            u663 = nil
        end
    end)
    local u685 = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
    local u698 = {
        {maxLevel = 5, title = "Recruit"},
        {maxLevel = 10, title = "Private"},
        {maxLevel = 15, title = "Corporal"},
        {maxLevel = 20, title = "Sergeant"},
        {maxLevel = 25, title = "Master Sergeant"},
        {maxLevel = 30, title = "Lieutenant"},
        {maxLevel = 35, title = "Captain"},
        {maxLevel = 40, title = "Global Elite"},
    }
    local u707 = 0

    local function v23() -- Line: 3056 -- upvalues: Router (upval)
        Router.broadcastRouter("RunInterfaceSound", (("TradeUp Type %*"):format((math.random(1, 3)))))
    end

    local function v24() -- Line: 3061 -- upvalues: u685 (val)
        local v1 = os.date("*t")
        return string.format("%s %d, %d", u685[v1.month], v1.day, v1.year)
    end

    local function getPlayerRankTitle() -- Line: 3066
        -- upvalues: DataController (upval), LocalPlayer (upval), u698 (val)
        local v1 = DataController.Get(LocalPlayer, "Level")
        local v2 = type(v1) == "table" and tonumber(v1.Level) or 1
        for i, v in ipairs(u698) do
            if v2 <= v.maxLevel then
                return v.title
            end
        end
        return "Global Elite"
    end

    local function runContractTypewriter() -- Line: 3078
        -- upvalues: u707 (ref), TradeUp (val), LocalPlayer (upval), u685 (val), getPlayerRankTitle (val)
        -- upvalues: Router (upval)
        u707 = u707 + 1
        local u2 = u707
        local Frame = TradeUp.TradeContainer.Contract.Frame
        local v1 = Frame:FindFirstChild("1")
        local v2 = Frame:FindFirstChild("2")
        if v1 and v2 then
            local v3 = {}
            local v4 = {label = v1:FindFirstChild("ID"), text = tostring(LocalPlayer.UserId)}
            local v5 = {label = v1:FindFirstChild("Name"), text = LocalPlayer.Name}
            local v6 = {label = v1:FindFirstChild("Number"), text = tostring(10)}
            local v7 = {label = v2:FindFirstChild("Date")}
            local v8 = os.date("*t")
            v7.text = string.format("%s %d, %d", u685[v8.month], v8.day, v8.year)
            local v9 = {label = v2:FindFirstChild("Rank"), text = getPlayerRankTitle()}
            v3[1] = v4
            v3[2] = v5
            v3[3] = v6
            v3[4] = v7
            v3[5] = v9
            local u64 = {}
            local u97 = 0
            for i, v in ipairs(v3) do
                if v.label and v.label:IsA("TextLabel") then
                    v.label.Text = ""
                    u97 = math.max(u97, #v.text)
                    table.insert(u64, v)
                end
            end
            task.spawn(function() -- Line: 3109 -- upvalues: u2 (val), u707 (upval), u97 (ref), u64 (val), Router (upval)
                task.wait(0.2)
                if u2 ~= u707 then
                    return
                end
                local v1 = u97
                for i = 1, v1 do
                    task.wait(0.12)
                    if u2 ~= u707 then
                        return
                    end
                    for i2, v in ipairs(u64) do
                        if i <= #v.text then
                            v.label.Text = string.sub(v.text, 1, i)
                        end
                    end
                    Router.broadcastRouter("RunInterfaceSound", (("TradeUp Type %*"):format((math.random(1, 3)))))
                end
            end)
            return
        end
    end

    local u712 = 0

    local function v25(a1) -- Line: 3140 -- upvalues: GetSkinDisplayName (upval)
        if not a1 then
            return ""
        end
        local v1 = GetSkinDisplayName.GetWeaponDisplayName(a1.Name, a1.NameTag)
        local v2 = a1.Skin or ""
        if v2 ~= "" then
            return (("%* | %*"):format(v1, v2))
        end
        return v1
    end

    local function v26(a1, a2) -- Line: 3153 -- types: a1: string, a2: number
        local v1 = utf8.offset(a1, a2 + 1)
        if v1 then
            return (string.sub(a1, 1, v1 - 1))
        end
        return a1
    end

    local function getContractSlotLabel(a1) -- Line: 3162 -- upvalues: TradeUp (val) -- types: a1: number
        local Frame = TradeUp.TradeContainer.Contract.Frame
        local v1 = tostring(a1)
        local v2 = Frame:FindFirstChild("3") and Frame["3"]:FindFirstChild(v1) or Frame:FindFirstChild("4") and Frame["4"]:FindFirstChild(v1)
        if v2 and v2:IsA("TextLabel") then
            return v2
        end
        return nil
    end

    local function v27() -- Line: 3173 -- upvalues: TradeUp (val)
        local v1 = TradeUp.TradeContainer.Contract.Frame:FindFirstChild("2")
        local Received = v1 and v1:FindFirstChild("Received")
        if Received and Received:IsA("TextLabel") then
            return Received
        end
        return nil
    end

    local function clearContractSlots() -- Line: 3184 -- upvalues: getContractSlotLabel (val), TradeUp (val)
        local v1
        for i = 1, 10 do
            v1 = getContractSlotLabel(i)
            if v1 then
                v1.Text = ""
            end
        end
        local v2 = TradeUp.TradeContainer.Contract.Frame:FindFirstChild("2")
        local Received = v2 and v2:FindFirstChild("Received")
        local v3 = if not Received then nil else if not Received:IsA("TextLabel") then nil else Received
        if v3 then
            v3.Text = ""
        end
    end

    local function clearContractHeaderFields() -- Line: 3198 -- upvalues: TradeUp (val)
        local v1, v2, v3
        local v4 = {{"1", "ID", "Name", "Number"}, {"2", "Date", "Rank"}}
        local v5 = nil
        local v6 = nil
        for i, j in v4, v5, v6 do
            v2 = TradeUp.TradeContainer.Contract.Frame:FindFirstChild(j[1])
            v3 = #j
            for k = 2, v3 do
                v1 = v2 and v2:FindFirstChild(j[k])
                if v1 and v1:IsA("TextLabel") then
                    v1.Text = ""
                end
            end
        end
    end

    local setTradeUpVisible = nil

    local function finishTradeUpReveal(a1) -- Line: 3215
        -- upvalues: setTradeUpVisible (ref), GetResolvedSkinInformation (upval), Router (upval), u227 (upval)
        -- upvalues: u223 (upval), u0 (upval), MenuState (upval)
        setTradeUpVisible(false)
        if not a1 then
            return
        end
        local v1 = GetResolvedSkinInformation(a1.Name, a1.Skin)
        local rarity = v1 and v1.rarity or a1.Rarity or "Blue"
        Router.broadcastRouter("RunStoreSound", u227[rarity] or "Drop Blue")

        local function showNotification() -- Line: 3226 -- upvalues: u223 (upval), u0 (upval), a1 (val)
            u223 = false
            u0.ShowNewItemNotification(a1)
        end

        local u22 = nil
        u22 = MenuState.OnInspectStateChanged:Connect(function(a1_2) -- Line: 3232 -- upvalues: u22 (ref), u223 (upval), u0 (upval), a1 (val) -- types: a1_2: boolean
            if a1_2 then
                return
            end
            u22:Disconnect()
            u22 = nil
            u223 = false
            u0.ShowNewItemNotification(a1)
        end)
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
        if u22 and not Router.broadcastRouter("IsInspectActive") then
            u22:Disconnect()
            u223 = false
            u0.ShowNewItemNotification(a1)
        end
    end

    local function runContractConfirmReveal(a1) -- Line: 3252
        -- upvalues: u712 (ref), clearContractSlots (val), getContractSlotLabel (val), Router (upval), u565 (ref)
        -- upvalues: TradeUp (val), GetSkinDisplayName (upval), TweenService (upval), finishTradeUpReveal (val)
        u712 = u712 + 1
        local u3 = u712
        clearContractSlots()
        task.spawn(function() -- Line: 3257
            -- upvalues: getContractSlotLabel (upval), a1 (val), u3 (val), u712 (upval), Router (upval), u565 (upval)
            -- upvalues: TradeUp (upval), GetSkinDisplayName (upval), TweenService (upval), finishTradeUpReveal (upval)
            local v1, v2, v3, v4, v5, v6
            for i = 1, 10 do
                v3 = getContractSlotLabel(i)
                v4 = a1[i] or ""
                if v3 then
                    v5 = utf8.len(v4) or #v4
                    for j = 1, v5 do
                        task.wait(0.06)
                        if u3 ~= u712 then
                            return
                        end
                        v2 = utf8.offset(v4, j + 1)
                        v3.Text = if not v2 then v4 else string.sub(v4, 1, v2 - 1)
                        Router.broadcastRouter("RunInterfaceSound", (("TradeUp Type %*"):format((math.random(1, 3)))))
                    end
                end
            end
            while u3 == u712 do
                if u565 ~= nil then
                    break
                end
                task.wait(0.05)
            end
            if u3 ~= u712 then
                return
            end
            local v7 = TradeUp.TradeContainer.Contract.Frame:FindFirstChild("2")
            local Received = v7 and v7:FindFirstChild("Received")
            local v8 = if not Received then nil else if not Received:IsA("TextLabel") then nil else Received
            v7 = u565
            if v7 then
                v3 = GetSkinDisplayName.GetWeaponDisplayName(v7.Name, v7.NameTag)
                v4 = v7.Skin or ""
                v1 = if v4 == "" then v3 else ("%* | %*"):format(v3, v4)
            else
                v1 = ""
            end
            if v8 then
                v3 = utf8.len(v1) or #v1
                for k = 1, v3 do
                    task.wait(0.06)
                    if u3 ~= u712 then
                        return
                    end
                    v6 = utf8.offset(v1, k + 1)
                    v8.Text = if not v6 then v1 else string.sub(v1, 1, v6 - 1)
                    Router.broadcastRouter("RunInterfaceSound", (("TradeUp Type %*"):format((math.random(1, 3)))))
                end
            end
            task.wait(0.1)
            if u3 ~= u712 then
                return
            end
            local Approved = TradeUp.TradeContainer.Contract:FindFirstChild("Approved")
            if Approved and Approved:IsA("ImageLabel") then
                Approved.Size = UDim2.fromScale(0.65, 0.65)
                Approved.ImageTransparency = 0.85
                Approved.Visible = true
                Router.broadcastRouter("RunInterfaceSound", "TradeUp Approved")

                local function stampStep(a1, a2) -- Line: 3308
                    -- upvalues: TweenService (upval), Approved (val)
                    return TweenService:Create(Approved, TweenInfo.new(a1, Enum.EasingStyle.Linear), a2)
                end

                v4 = {}
                v5 = {ImageTransparency = 0, Size = UDim2.fromScale(0.35, 0.35)}
                local v9 = TweenService:Create(Approved, TweenInfo.new(0.2, Enum.EasingStyle.Linear), v5)
                v6 = {Size = UDim2.fromScale(0.365, 0.365)}
                v5 = TweenService:Create(Approved, TweenInfo.new(0.03, Enum.EasingStyle.Linear), v6)
                local v10 = {Size = UDim2.fromScale(0.35, 0.35)}
                v4[1] = v9
                v4[2] = v5
                v4[3] = stampStep(0.03, v10)
                for i2, v in ipairs(v4) do
                    v:Play()
                    v.Completed:Wait()
                    if u3 ~= u712 then
                        return
                    end
                end
            end
            task.wait(1.25)
            if u3 ~= u712 then
                return
            end
            finishTradeUpReveal(u565)
        end)
    end

    local function skipContractReveal() -- Line: 3334 -- upvalues: u712 (ref), u565 (ref), finishTradeUpReveal (val)
        u712 = u712 + 1
        local u2 = u712
        task.spawn(function() -- Line: 3338 -- upvalues: u2 (val), u712 (upval), u565 (upval), finishTradeUpReveal (upval)
            while u2 == u712 do
                if u565 ~= nil then
                    break
                end
                task.wait(0.05)
            end
            if u2 ~= u712 then
                return
            end
            finishTradeUpReveal(u565)
        end)
    end

    local function setTradeUpItemSelectionState() -- Line: 3350
        -- upvalues: u561 (ref), u566 (ref), u567 (ref), u568 (ref), u707 (ref), u712 (ref), TradeUp (val)
        -- upvalues: Title_2 (val), Text (val), Position (val), Position_2 (val), u562 (ref), u212 (upval), u662 (ref)
        -- upvalues: u663 (ref), u661 (ref), Frame_2 (val)
        local v1
        u561 = false
        u566 = false
        u567 = false
        u568 = false
        u707 = u707 + 1
        u712 = u712 + 1
        TradeUp.Options.Clear.Visible = true
        TradeUp.Options.Proceed.Visible = true
        TradeUp.Options.Cancel.Visible = false
        Title_2.Text = Text
        TradeUp.Options.Cancel.Position = Position
        TradeUp.Options.Proceed.Position = Position_2
        TradeUp.Top.Visible = true
        if u562 and u212 and u212.Menu then
            u212.Menu.Top.Visible = true
        end
        u562 = false
        TradeUp.TradeContainer.Container.Visible = true
        TradeUp.TradeContainer.Exchange.Visible = true
        TradeUp.TradeContainer.Contract.Visible = false
        u662 = false
        u663 = nil
        u661 = 0
        for i, v in ipairs(Frame_2:GetChildren()) do
            v:Destroy()
        end
        for i2, i3 in ipairs(TradeUp.Warning:GetChildren()) do
            if i3:IsA("GuiObject") then
                v1 = i3.Name ~= "WarningForContract"
                i3.Visible = v1
            end
        end
    end

    local function setTradeUpContractState() -- Line: 3390
        -- upvalues: u561 (ref), TradeUp (val), Title_2 (val), u589 (val), u597 (val), u212 (upval), u562 (ref)
        -- upvalues: u662 (ref), u663 (ref), u661 (ref), Frame_2 (val), clearContractHeaderFields (val)
        -- upvalues: clearContractSlots (val), u707 (ref), Frame (val), u617 (val), TweenService (upval), u622 (val)
        -- upvalues: Position_3 (val), runContractTypewriter (val), Router (upval)
        u561 = true
        TradeUp.Options.Clear.Visible = false
        TradeUp.Options.Proceed.Visible = true
        TradeUp.Options.Cancel.Visible = true
        Title_2.Text = "CONFIRM"
        TradeUp.Options.Cancel.Position = u589
        TradeUp.Options.Proceed.Position = u597
        TradeUp.Top.Visible = false
        if u212 and u212.Menu then
            u212.Menu.Top.Visible = false
            u562 = true
        end
        for i, v in ipairs(TradeUp.Warning:GetChildren()) do
            if v:IsA("GuiObject") then
                v.Visible = false
            end
        end
        u662 = false
        u663 = nil
        u661 = 0
        for i2, i3 in ipairs(Frame_2:GetChildren()) do
            i3:Destroy()
        end
        clearContractHeaderFields()
        clearContractSlots()
        local Approved = TradeUp.TradeContainer.Contract:FindFirstChild("Approved")
        if Approved and Approved:IsA("ImageLabel") then
            Approved.Visible = false
        end
        TradeUp.TradeContainer.Container.Visible = false
        TradeUp.TradeContainer.Exchange.Visible = false
        u707 = u707 + 1
        local u94 = u707
        Frame.Position = u617
        if not TradeUp.TradeContainer.Contract.Visible then
            TradeUp.TradeContainer.Contract.Visible = true
        end
        task.delay(0.18, function() -- Line: 3438
            -- upvalues: u94 (val), u707 (upval), TweenService (upval), Frame (upval), u622 (upval), Position_3 (upval)
            -- upvalues: runContractTypewriter (upval), Router (upval)
            if u94 ~= u707 then
                return
            end
            local v1 = TweenService:Create(Frame, u622, {Position = Position_3})
            v1.Completed:Connect(function() -- Line: 3447 -- upvalues: u94 (upval), u707 (upval), runContractTypewriter (upval)
                if u94 ~= u707 then
                    return
                end
                runContractTypewriter()
            end)
            Router.broadcastRouter("RunInterfaceSound", "TradeUp Contract Slide")
            v1:Play()
        end)
    end

    function setTradeUpVisible(a1) -- Line: 3459
        -- upvalues: u211 (upval), TradeUp (val), u197 (upval), u196 (upval), u205 (upval), MenuState (upval)
        -- upvalues: u209 (upval), DismissItemNotifications (upval), setTradeUpItemSelectionState (val), u405 (val)
        -- upvalues: u406 (ref), renderTradeUp (ref), u561 (ref), u566 (ref), u567 (ref), u568 (ref), u707 (ref)
        -- upvalues: u712 (ref), u662 (ref), u663 (ref), u661 (ref), Frame_2 (val), Position (val), Position_2 (val)
        -- upvalues: Title_2 (val), Text (val), u562 (ref), u212 (upval)
        u211.Frame.Categories.Visible = not a1
        u211.Frame.Right.Visible = not a1
        TradeUp.Visible = a1
        u197 = nil
        u196 = nil
        u205 = nil
        u211.Ignore.Hover.Visible = false
        if a1 then
            MenuState.EnterTradeUp()
            if u209 then
                u209.Visible = false
            end
            if u211.Ignore.ItemNotification.Visible then
                DismissItemNotifications()
            end
            setTradeUpItemSelectionState()
            table.clear(u405)
            u406 = nil
            renderTradeUp()
            return
        end
        MenuState.ExitTradeUp()
        u561 = false
        u566 = false
        u567 = false
        u568 = false
        u707 = u707 + 1
        u712 = u712 + 1
        u662 = false
        u663 = nil
        u661 = 0
        for i, v in ipairs(Frame_2:GetChildren()) do
            v:Destroy()
        end
        TradeUp.Options.Cancel.Position = Position
        TradeUp.Options.Proceed.Position = Position_2
        Title_2.Text = Text
        if u562 and u212 and u212.Menu then
            u212.Menu.Top.Visible = true
        end
        u562 = false
    end

    local v28 = TradeUp.Options.Clear
    local v29 = TradeUp.Options.Proceed
    local v30 = TradeUp.Options.Cancel
    ActivateButton(v28)
    v28.Selectable = true

    local function u736() -- Line: 3510 -- upvalues: Router (upval), u405 (val), u406 (ref), renderTradeUp (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        table.clear(u405)
        u406 = nil
        renderTradeUp()
    end

    v28.MouseButton1Click:Connect(u736)
    v28.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: u736 (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            u736()
        end
    end)
    ActivateButton(v29)
    v29.Selectable = true

    local function handleTradeUpProceedClick() -- Line: 3519
        -- upvalues: u567 (ref), u561 (ref), u568 (ref), Router (upval), u712 (ref), u565 (ref)
        -- upvalues: finishTradeUpReveal (val), u563 (ref), u566 (ref), u405 (val), TradeUp (val), u605 (val)
        -- upvalues: Title_2 (val), DataController (upval), LocalPlayer (upval), GetSkinDisplayName (upval), u564 (ref)
        -- upvalues: Remotes (upval), clearContractSlots (val), getContractSlotLabel (val), TweenService (upval)
        -- upvalues: setTradeUpContractState (val)
        if u567 then
            if u561 and not u568 then
                u568 = true
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                u712 = u712 + 1
                local u11 = u712
                task.spawn(function() -- Line: 3338 -- upvalues: u11 (val), u712 (upval), u565 (upval), finishTradeUpReveal (upval)
                    while u11 == u712 do
                        if u565 ~= nil then
                            break
                        end
                        task.wait(0.05)
                    end
                    if u11 ~= u712 then
                        return
                    end
                    finishTradeUpReveal(u565)
                end)
            end
            return
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        if not u561 then
            if #u405 == 10 then
                setTradeUpContractState()
            end
            return
        end
        if not u563 and not u566 and #u405 == 10 then
            local v1, v2, v3, v4
            u567 = true
            u568 = false
            TradeUp.Options.Cancel.Visible = false
            TradeUp.Options.Proceed.Position = u605
            Title_2.Text = "SKIP"
            local v5 = DataController.Get(LocalPlayer, "Inventory") or {}
            local v6 = {}
            for i, v in ipairs(v5) do
                if v and v._id then
                    v6[v._id] = v
                end
            end
            local u115 = {}
            for i2, i3 in ipairs(u405) do
                v2 = v6[i3]
                if v2 then
                    v3 = GetSkinDisplayName.GetWeaponDisplayName(v2.Name, v2.NameTag)
                    v4 = v2.Skin or ""
                    v1 = if v4 == "" then v3 else ("%* | %*"):format(v3, v4)
                else
                    v1 = ""
                end
                table.insert(u115, v1)
            end
            u565 = nil
            u566 = false
            u564 = u564 + 1
            local v7 = ("TradeUp_%*"):format(u564)
            u563 = v7
            Remotes.Store.TradeUpItems.Send({ItemIds = table.clone(u405), RequestId = v7})
            u712 = u712 + 1
            local u90 = u712
            clearContractSlots()
            task.spawn(function() -- Line: 3257
                -- upvalues: getContractSlotLabel (upval), u115 (val), u90 (val), u712 (upval), Router (upval)
                -- upvalues: u565 (upval), TradeUp (upval), GetSkinDisplayName (upval), TweenService (upval)
                -- upvalues: finishTradeUpReveal (upval)
                local v1, v2, v3, v4, v5, v6
                for i = 1, 10 do
                    v3 = getContractSlotLabel(i)
                    v4 = u115[i] or ""
                    if v3 then
                        v5 = utf8.len(v4) or #v4
                        for j = 1, v5 do
                            task.wait(0.06)
                            if u90 ~= u712 then
                                return
                            end
                            v2 = utf8.offset(v4, j + 1)
                            v3.Text = if not v2 then v4 else string.sub(v4, 1, v2 - 1)
                            Router.broadcastRouter("RunInterfaceSound", (("TradeUp Type %*"):format((math.random(1, 3)))))
                        end
                    end
                end
                while u90 == u712 do
                    if u565 ~= nil then
                        break
                    end
                    task.wait(0.05)
                end
                if u90 ~= u712 then
                    return
                end
                local v7 = TradeUp.TradeContainer.Contract.Frame:FindFirstChild("2")
                local Received = v7 and v7:FindFirstChild("Received")
                local v8 = if not Received then nil else if not Received:IsA("TextLabel") then nil else Received
                v7 = u565
                if v7 then
                    v3 = GetSkinDisplayName.GetWeaponDisplayName(v7.Name, v7.NameTag)
                    v4 = v7.Skin or ""
                    v1 = if v4 == "" then v3 else ("%* | %*"):format(v3, v4)
                else
                    v1 = ""
                end
                if v8 then
                    v3 = utf8.len(v1) or #v1
                    for k = 1, v3 do
                        task.wait(0.06)
                        if u90 ~= u712 then
                            return
                        end
                        v6 = utf8.offset(v1, k + 1)
                        v8.Text = if not v6 then v1 else string.sub(v1, 1, v6 - 1)
                        Router.broadcastRouter("RunInterfaceSound", (("TradeUp Type %*"):format((math.random(1, 3)))))
                    end
                end
                task.wait(0.1)
                if u90 ~= u712 then
                    return
                end
                local Approved = TradeUp.TradeContainer.Contract:FindFirstChild("Approved")
                if Approved and Approved:IsA("ImageLabel") then
                    Approved.Size = UDim2.fromScale(0.65, 0.65)
                    Approved.ImageTransparency = 0.85
                    Approved.Visible = true
                    Router.broadcastRouter("RunInterfaceSound", "TradeUp Approved")

                    local function stampStep(a1, a2) -- Line: 3308
                        -- upvalues: TweenService (upval), Approved (val)
                        return TweenService:Create(Approved, TweenInfo.new(a1, Enum.EasingStyle.Linear), a2)
                    end

                    v4 = {}
                    v5 = {ImageTransparency = 0, Size = UDim2.fromScale(0.35, 0.35)}
                    local v9 = TweenService:Create(Approved, TweenInfo.new(0.2, Enum.EasingStyle.Linear), v5)
                    v6 = {Size = UDim2.fromScale(0.365, 0.365)}
                    v5 = TweenService:Create(Approved, TweenInfo.new(0.03, Enum.EasingStyle.Linear), v6)
                    local v10 = {Size = UDim2.fromScale(0.35, 0.35)}
                    v4[1] = v9
                    v4[2] = v5
                    v4[3] = stampStep(0.03, v10)
                    for i2, v in ipairs(v4) do
                        v:Play()
                        v.Completed:Wait()
                        if u90 ~= u712 then
                            return
                        end
                    end
                end
                task.wait(1.25)
                if u90 ~= u712 then
                    return
                end
                finishTradeUpReveal(u565)
            end)
            return
        end
    end

    v29.MouseButton1Click:Connect(handleTradeUpProceedClick)
    v29.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: handleTradeUpProceedClick (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            handleTradeUpProceedClick()
        end
    end)
    ActivateButton(v30)
    v30.Selectable = true

    local function handleTradeUpCancelClick() -- Line: 3579
        -- upvalues: u567 (ref), Router (upval), u712 (ref), u566 (ref), u405 (val), u406 (ref)
        -- upvalues: setTradeUpItemSelectionState (val), renderTradeUp (ref)
        if u567 then
            return
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        u712 = u712 + 1
        if u566 then
            table.clear(u405)
            u406 = nil
        end
        setTradeUpItemSelectionState()
        renderTradeUp()
    end

    v30.MouseButton1Click:Connect(handleTradeUpCancelClick)
    v30.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: handleTradeUpCancelClick (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            handleTradeUpCancelClick()
        end
    end)
    Remotes.Store.TradeUpCompleted.Listen(function(a1) -- Line: 3597 -- upvalues: u563 (ref), DataController (upval), LocalPlayer (upval), u566 (ref), u565 (ref)
        local RequestId_2 = if not a1 then nil else if typeof(a1.RequestId) ~= "string" then nil else a1.RequestId
        if u563 and RequestId_2 == u563 then
            u563 = nil
            DataController.ApplyInventoryDelta(LocalPlayer, {a1.InventoryItem}, a1.DeletedItemIds)
            u566 = true
            u565 = a1.InventoryItem
            return
        end
    end)
    Remotes.Store.TradeUpDenied.Listen(function(a1) -- Line: 3612
        -- upvalues: u563 (ref), u712 (ref), u567 (ref), u568 (ref), TradeUp (val), setTradeUpVisible (ref)
        local RequestId_2 = if not a1 then nil else if typeof(a1.RequestId) ~= "string" then nil else a1.RequestId
        if RequestId_2 and u563 and RequestId_2 ~= u563 then
            return
        end
        u563 = nil
        u712 = u712 + 1
        u567 = false
        u568 = false
        if TradeUp.Visible then
            setTradeUpVisible(false)
        end
    end)
    ActivateButton(v14)
    v14.Selectable = true

    local function u800() -- Line: 3628 -- upvalues: setTradeUpVisible (ref), Router (upval)
        setTradeUpVisible(true)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
    end

    v14.MouseButton1Click:Connect(u800)
    v14.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: u800 (val)
        if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
            u800()
        end
    end)
    u213 = (function() -- Line: 3634
        -- upvalues: u211 (upval), Router (upval), BindSortDropdownFocus (upval), u402 (ref), u403 (ref), u411 (ref)
        -- upvalues: renderTradeUpContainer (val), u998 (val), BindSearchTap (upval), TradeUp (val)
        -- upvalues: SetSearchTokens (upval), u404 (val)
        local Top = u211.Frame.TradeUp.Top
        local Weapon = Top.Weapon
        local Click = Weapon.Click
        local DropdownContent = Weapon.DropdownContent
        local Title = Weapon.Container.Left.Title
        Weapon.Active = false
        Click.Selectable = true
        if DropdownContent then
            DropdownContent.Visible = false
            DropdownContent.Active = false
            local Scroll = DropdownContent:FindFirstChild("Scroll")
            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = false
                Scroll.Active = false
            end
        end
        Click.Activated:Connect(function() -- Line: 3649 -- upvalues: DropdownContent (val), Router (upval)
            local v1 = not DropdownContent.Visible
            local v2 = DropdownContent
            if v2 then
                v2.Visible = v1
                v2.Active = v1
                local Scroll = v2:FindFirstChild("Scroll")
                if Scroll and Scroll:IsA("GuiObject") then
                    Scroll.Visible = v1
                    Scroll.Active = v1
                end
            end
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
        end)
        BindSortDropdownFocus(DropdownContent, Click, function() -- Line: 3654 -- upvalues: u402 (upval), Click (val)
            return u402 or Click.Frame.TextLabel.Text
        end, "UI.Inventory.TradeUpSortFocusDeferred")
        local ReverseSort = Weapon.Container.Left.ReverseSort
        ReverseSort.Selectable = true
        ReverseSort.Activated:Connect(function() -- Line: 3661
            -- upvalues: u403 (upval), ReverseSort (val), u411 (upval), renderTradeUpContainer (upval), Router (upval)
            u403 = not u403
            local v1 = u403
            local ImageLabel = ReverseSort:FindFirstChildOfClass("ImageLabel")
            if ImageLabel then
                ImageLabel.Rotation = if not v1 then 0 else 180
            end
            u411 = true
            renderTradeUpContainer()
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
        end)
        for i, j in u998 do
            local u81 = DropdownContent.Scroll:FindFirstChild(j)
            if u81 and u81:IsA("TextButton") then
                u81.Selectable = true

                local function handleSortOptionClick() -- Line: 3674
                    -- upvalues: Router (upval), u402 (upval), j (val), u411 (upval), Title (val), DropdownContent (val)
                    -- upvalues: u81 (val), renderTradeUpContainer (upval)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    u402 = j
                    u411 = true
                    Title.Text = j
                    for i, v in ipairs(DropdownContent.Scroll:GetChildren()) do
                        if v:IsA("TextButton") then
                            v.Frame.BackgroundTransparency = if v ~= u81 then 1 else 0
                        end
                    end
                    renderTradeUpContainer()
                    local v1 = DropdownContent
                    if not v1 then
                        return
                    end
                    v1.Visible = false
                    v1.Active = false
                    local Scroll = v1:FindFirstChild("Scroll")
                    if Scroll and Scroll:IsA("GuiObject") then
                        Scroll.Visible = false
                        Scroll.Active = false
                    end
                end

                u81.MouseButton1Click:Connect(handleSortOptionClick)
                u81.Activated:Connect(function(a1) -- Line: 1149 -- upvalues: handleSortOptionClick (val)
                    if a1 and a1.UserInputType == Enum.UserInputType.Gamepad1 then
                        handleSortOptionClick()
                    end
                end)
            end
        end
        local Title_2 = Top.Search.Container.Title
        BindSearchTap(Top.Search, Title_2)
        ;(Title_2:GetPropertyChangedSignal("Text")):Connect(function() -- Line: 3694
            -- upvalues: TradeUp (upval), SetSearchTokens (upval), u404 (upval), Title_2 (val)
            -- upvalues: renderTradeUpContainer (upval)
            if not TradeUp.Visible then
                return
            end
            SetSearchTokens(u404, Title_2.Text)
            renderTradeUpContainer()
        end)
        return {
            setDropdownOpen = function(a1) -- Line: 3641 -- upvalues: DropdownContent (val) -- types: a1: boolean
                local v1 = DropdownContent
                if not v1 then
                    return
                end
                v1.Visible = a1
                v1.Active = a1
                local Scroll = v1:FindFirstChild("Scroll")
                if Scroll and Scroll:IsA("GuiObject") then
                    Scroll.Visible = a1
                    Scroll.Active = a1
                end
            end,
            searchTextBox = Title_2,
        }
    end)()
    u211.Frame.TradeUp.Top.TradeUp.Visible = false
    setTradeUpVisible(false)
    clearContractSlots()
    clearContractHeaderFields()
    task.spawn(function() -- Line: 3721 -- upvalues: TradeUp (val), ContentProvider (upval), u212 (upval)
        local ImageLabel
        local v1 = {}
        local v2 = {}
        for i, v in ipairs(TradeUp.TradeContainer.Contract:GetDescendants()) do
            if v:IsA("ImageLabel") then
                if v.Image ~= "" and not v2[v.Image] then
                    v2[v.Image] = true
                    table.insert(v1, v.Image)
                end
            elseif v:IsA("ImageButton") and v.Image ~= "" and not v2[v.Image] then
                v2[v.Image] = true
                table.insert(v1, v.Image)
            end
        end
        if #v1 == 0 then
            return
        end
        ContentProvider:PreloadAsync(v1)
        local Frame = Instance.new("Frame")
        Frame.Name = "TradeUpContractImageWarmup"
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromOffset(1, 1)
        Frame.Position = UDim2.fromOffset(0, 0)
        for i2, i3 in ipairs(v1) do
            ImageLabel = Instance.new("ImageLabel")
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.ImageTransparency = 0.99
            ImageLabel.Size = UDim2.fromOffset(1, 1)
            ImageLabel.Image = i3
            ImageLabel.Parent = Frame
        end
        Frame.Parent = u212
        task.wait(0.5)
        Frame:Destroy()
    end)
    if u212 and u212.Menu then
        (u212.Menu.Top:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 3760 -- upvalues: u561 (ref), u212 (upval)
            if u561 and u212.Menu.Top.Visible then
                u212.Menu.Top.Visible = false
            end
        end)
    end
    Router.observerRouter("ResetInventoryToGrid", function() -- Line: 3768 -- upvalues: setTradeUpVisible (ref)
        setTradeUpVisible(false)
    end)
    ;(Title:GetPropertyChangedSignal("Text")):Connect(function() -- Line: 3773
        -- upvalues: u211 (upval), SetSearchTokens (upval), u208 (upval), Title (val), Profiler (upval), u187 (upval)
        -- upvalues: GetSortedInventoryData (upval), ApplyFilterToSortedData (upval), UpdateInventoryTemplates (upval)
        if not u211.Visible then
            return
        end
        SetSearchTokens(u208, Title.Text)
        Profiler.mark("UI.Inventory.ApplyCurrentSort")
        if not u211 or not u211.Visible then
            return
        end
        u187 = GetSortedInventoryData()
        u187 = ApplyFilterToSortedData(u187)
        UpdateInventoryTemplates()
    end)

    local function handleInventoryClosed() -- Line: 3782
        -- upvalues: u210 (upval), setTradeUpVisible (ref), u208 (upval), Title (val), u404 (val), u405 (val)
        -- upvalues: u406 (ref), u213 (upval), UpdateInventoryTemplates (upval)
        local v1 = u210
        if v1 then
            v1.Visible = false
            v1.Active = false
            local Scroll = v1:FindFirstChild("Scroll")
            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = false
                Scroll.Active = false
            end
        end
        setTradeUpVisible(false)
        table.clear(u208)
        Title.Text = ""
        table.clear(u404)
        table.clear(u405)
        u406 = nil
        if u213 then
            u213.setDropdownOpen(false)
            u213.searchTextBox.Text = ""
        end
        UpdateInventoryTemplates()
    end

    ;(u211:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 3804
        -- upvalues: syncInventoryUpdate (upval), u211 (upval), Profiler (upval), u187 (upval)
        -- upvalues: GetSortedInventoryData (upval), ApplyFilterToSortedData (upval), UpdateInventoryTemplates (upval)
        -- upvalues: u221 (upval), u215 (upval), u199 (upval), u0 (upval), ReportViewedItems (upval), MenuState (upval)
        -- upvalues: handleInventoryClosed (val)
        syncInventoryUpdate()
        if not u211.Visible then
            u221 = nil
            ReportViewedItems()
            if not MenuState.IsInspectActive() then
                handleInventoryClosed()
            end
            return
        end
        Profiler.mark("UI.Inventory.ApplyCurrentSort")
        if u211 and u211.Visible then
            u187 = GetSortedInventoryData()
            u187 = ApplyFilterToSortedData(u187)
            UpdateInventoryTemplates()
        end
        local v1 = u221
        u221 = nil
        local v2 = u215[u199]
        local Visible = false
        if v1 ~= nil then
            Visible = false
            if v2 ~= nil then
                Visible = false
                if v2._id == v1 then
                    Visible = u211.Ignore.ItemNotification.Visible
                end
            end
        end
        local v3 = #u215
        if not Visible and v3 > 0 and u199 < v3 then
            u0.NextInventoryItem(u199 + 1)
            return
        end
    end)
    MenuState.OnInspectStateChanged:Connect(function(a1) -- Line: 3835 -- upvalues: u211 (upval), handleInventoryClosed (val) -- types: a1: boolean
        if a1 then
            return
        end
        task.defer(function() -- Line: 3839 -- upvalues: u211 (upval), handleInventoryClosed (upval)
            if not u211.Visible then
                handleInventoryClosed()
            end
        end)
    end)
    if u212 and u212.Menu then
        (u212.Menu:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 3848
            -- upvalues: u212 (upval), u211 (upval), handleInventoryClosed (val), syncInventoryUpdate (upval)
            if not u212.Menu.Visible and u211.Visible then
                u211.Visible = false
                handleInventoryClosed()
                syncInventoryUpdate()
            end
        end)
    end
    ;(u211.Frame.Right.Container:GetPropertyChangedSignal("CanvasPosition")):Connect(function() -- Line: 3858 -- upvalues: OnScrollPositionChanged (upval)
        OnScrollPositionChanged()
    end)
    ;(u211.Frame.Right.Container:GetPropertyChangedSignal("AbsoluteCanvasSize")):Connect(function() -- Line: 3862 -- upvalues: Profiler (upval), OnScrollPositionChanged (upval)
        Profiler.defer("UI.Inventory.ScrollDeferred", OnScrollPositionChanged)
    end)
end

function u0.Start() -- Line: 3869
    -- upvalues: Profiler (val), DataController (val), LocalPlayer (val), UserInputService (val), u211 (ref)
    -- upvalues: GuiService (val), Router (val), DismissItemNotifications (val), CloseButtonRegistry (val), u209 (ref)
    -- upvalues: u0 (val), syncInventoryUpdate (val), Skins (val), u218 (val), u214 (ref)
    -- upvalues: RefreshNewInventoryItems (val), Remotes (val), u207 (ref), Store (val), u204 (ref), u200 (ref)
    -- upvalues: u202 (ref), u187 (ref), GetSortedInventoryData (val), ApplyFilterToSortedData (val)
    -- upvalues: UpdateInventoryTemplates (val), u195 (ref), UpdateStatusFrame (val), MenuState (val), u215 (val)
    -- upvalues: u199 (ref), CollectionService (val), u237 (val), ActivateButton (val)
    debug.setmemorycategory("UI.Inventory.Start")
    Profiler.mark("UI.Inventory.Start.Begin")
    DataController.WaitForDataLoaded(LocalPlayer)
    Profiler.mark("UI.Inventory.Start.DataLoaded")
    Profiler.mark("UI.Inventory.Start.InitialCategory")
    local u19 = nil

    local function setupGamepadNavigation() -- Line: 3878
        -- upvalues: Profiler (upval), u19 (ref), UserInputService (upval), u211 (upval), GuiService (upval)
        -- upvalues: Router (upval), DismissItemNotifications (upval), CloseButtonRegistry (upval), u209 (upval)
        Profiler.mark("UI.Inventory.SetupGamepadNavigation")
        if u19 then
            u19:Disconnect()
        end
        u19 = UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 3885
            -- upvalues: u211 (upval), GuiService (upval), Router (upval), DismissItemNotifications (upval)
            -- upvalues: CloseButtonRegistry (upval), u209 (upval)
            if a1.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return
            end
            if u211 and u211.Visible and not a2 then
                local NextSelectionUp
                local KeyCode = a1.KeyCode
                local SelectedObject = GuiService.SelectedObject
                local ItemNotification = u211 and u211.Ignore.ItemNotification and u211.Ignore.ItemNotification.Visible
                if KeyCode == Enum.KeyCode.ButtonB then
                    if ItemNotification then
                        Router.broadcastRouter("RunInterfaceSound", "UI Click")
                        DismissItemNotifications()
                        CloseButtonRegistry.MarkUsed()
                        return
                    end
                    if u209 and u209.Visible then
                        u209.Visible = false
                        Router.broadcastRouter("RunInterfaceSound", "UI Click")
                        CloseButtonRegistry.MarkUsed()
                        return
                    end
                    if u211 and u211.Tabs.Inventory.Sort.Button.Options.Visible then
                        u211.Tabs.Inventory.Sort.Button.Options.Visible = false
                        Router.broadcastRouter("RunInterfaceSound", "UI Click")
                        CloseButtonRegistry.MarkUsed()
                        return
                    end
                end
                local v1 = KeyCode == Enum.KeyCode.DPadUp
                if v1 then
                    NextSelectionUp = SelectedObject and SelectedObject:IsA("GuiButton") and (v1 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown)
                else
                    NextSelectionUp = false
                    if KeyCode == Enum.KeyCode.DPadDown then
                        NextSelectionUp = SelectedObject and SelectedObject:IsA("GuiButton") and (v1 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown)
                    end
                end
                if ItemNotification then
                    local Holder = u211.Ignore.ItemNotification.Holder
                    if NextSelectionUp and NextSelectionUp:IsDescendantOf(Holder) and NextSelectionUp.Visible then
                        GuiService.SelectedObject = NextSelectionUp
                    end
                    return
                end
                local Visible = u209 and u209.Visible and SelectedObject and SelectedObject:IsDescendantOf(u209)
                if NextSelectionUp then
                    if not Visible or NextSelectionUp:IsDescendantOf(u209) then
                        GuiService.SelectedObject = NextSelectionUp
                    end
                end
                return
            end
        end)
    end

    local u21 = nil

    local function setupSelectionProtection() -- Line: 3953
        -- upvalues: Profiler (upval), u21 (ref), GuiService (upval), u211 (upval), u0 (upval), u209 (upval)
        Profiler.mark("UI.Inventory.SetupSelectionProtection")
        if u21 then
            u21:Disconnect()
        end
        u21 = GuiService.Changed:Connect(function(a1) -- Line: 3959 -- upvalues: u211 (upval), GuiService (upval), Profiler (upval), u0 (upval), u209 (upval)
            if a1 ~= "SelectedObject" then
                return
            end
            local ItemNotification = u211 and u211.Ignore.ItemNotification
            if ItemNotification and ItemNotification.Visible then
                local Holder = ItemNotification.Holder
                local SelectedObject = GuiService.SelectedObject
                if SelectedObject and SelectedObject ~= Holder.Continue and SelectedObject ~= Holder.ViewLoadout then
                    if not SelectedObject:IsDescendantOf(Holder) or not SelectedObject:IsA("GuiButton") then
                        Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u0.SelectFirstItemNotificationButton)
                    end
                end
                return
            end
            if u209 and u209.Visible then
                local SelectedObject_2 = GuiService.SelectedObject
                if SelectedObject_2 and not SelectedObject_2:IsDescendantOf(u209) then
                    Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u0.SelectFirstInformationFrameButton)
                end
                return
            end
        end)
    end

    if u211 then
        (u211:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 3998
            -- upvalues: u211 (upval), Profiler (upval), u19 (ref), UserInputService (upval), GuiService (upval)
            -- upvalues: Router (upval), DismissItemNotifications (upval), CloseButtonRegistry (upval), u209 (upval)
            -- upvalues: u21 (ref), u0 (upval)
            if not u211.Visible then
                if u19 then
                    u19:Disconnect()
                    u19 = nil
                end
                if u21 then
                    u21:Disconnect()
                    u21 = nil
                end
                return
            end
            Profiler.mark("UI.Inventory.SetupGamepadNavigation")
            if u19 then
                u19:Disconnect()
            end
            u19 = UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 3885
                -- upvalues: u211 (upval), GuiService (upval), Router (upval), DismissItemNotifications (upval)
                -- upvalues: CloseButtonRegistry (upval), u209 (upval)
                if a1.UserInputType ~= Enum.UserInputType.Gamepad1 then
                    return
                end
                if u211 and u211.Visible and not a2 then
                    local NextSelectionUp
                    local KeyCode = a1.KeyCode
                    local SelectedObject = GuiService.SelectedObject
                    local ItemNotification = u211 and u211.Ignore.ItemNotification and u211.Ignore.ItemNotification.Visible
                    if KeyCode == Enum.KeyCode.ButtonB then
                        if ItemNotification then
                            Router.broadcastRouter("RunInterfaceSound", "UI Click")
                            DismissItemNotifications()
                            CloseButtonRegistry.MarkUsed()
                            return
                        end
                        if u209 and u209.Visible then
                            u209.Visible = false
                            Router.broadcastRouter("RunInterfaceSound", "UI Click")
                            CloseButtonRegistry.MarkUsed()
                            return
                        end
                        if u211 and u211.Tabs.Inventory.Sort.Button.Options.Visible then
                            u211.Tabs.Inventory.Sort.Button.Options.Visible = false
                            Router.broadcastRouter("RunInterfaceSound", "UI Click")
                            CloseButtonRegistry.MarkUsed()
                            return
                        end
                    end
                    local v1 = KeyCode == Enum.KeyCode.DPadUp
                    if v1 then
                        NextSelectionUp = SelectedObject and SelectedObject:IsA("GuiButton") and (v1 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown)
                    else
                        NextSelectionUp = false
                        if KeyCode == Enum.KeyCode.DPadDown then
                            NextSelectionUp = SelectedObject and SelectedObject:IsA("GuiButton") and (v1 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown)
                        end
                    end
                    if ItemNotification then
                        local Holder = u211.Ignore.ItemNotification.Holder
                        if NextSelectionUp and NextSelectionUp:IsDescendantOf(Holder) and NextSelectionUp.Visible then
                            GuiService.SelectedObject = NextSelectionUp
                        end
                        return
                    end
                    local Visible = u209 and u209.Visible and SelectedObject and SelectedObject:IsDescendantOf(u209)
                    if NextSelectionUp then
                        if not Visible or NextSelectionUp:IsDescendantOf(u209) then
                            GuiService.SelectedObject = NextSelectionUp
                        end
                    end
                    return
                end
            end)
            Profiler.mark("UI.Inventory.SetupSelectionProtection")
            if u21 then
                u21:Disconnect()
            end
            u21 = GuiService.Changed:Connect(function(a1) -- Line: 3959 -- upvalues: u211 (upval), GuiService (upval), Profiler (upval), u0 (upval), u209 (upval)
                if a1 ~= "SelectedObject" then
                    return
                end
                local ItemNotification = u211 and u211.Ignore.ItemNotification
                if ItemNotification and ItemNotification.Visible then
                    local Holder = ItemNotification.Holder
                    local SelectedObject = GuiService.SelectedObject
                    if SelectedObject
                        and SelectedObject ~= Holder.Continue
                        and SelectedObject ~= Holder.ViewLoadout then
                        if not SelectedObject:IsDescendantOf(Holder) or not SelectedObject:IsA("GuiButton") then
                            Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u0.SelectFirstItemNotificationButton)
                        end
                    end
                    return
                end
                if u209 and u209.Visible then
                    local SelectedObject_2 = GuiService.SelectedObject
                    if SelectedObject_2 and not SelectedObject_2:IsDescendantOf(u209) then
                        Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u0.SelectFirstInformationFrameButton)
                    end
                    return
                end
            end)
            if not UserInputService.GamepadEnabled then
                return
            end
            Profiler.defer("UI.Inventory.AutoSelectDeferred", function() -- Line: 4004 -- upvalues: GuiService (upval), u211 (upval)
                local Button
                local v1 = 0
                while v1 < 5 do
                    task.wait(0.1)
                    v1 = v1 + 1
                    if GuiService.SelectedObject or not u211 or not u211.Visible then
                        break
                    end
                    if u211.Frame.Right.Container then
                        for i, v in ipairs(u211.Frame.Right.Container:GetChildren()) do
                            if v:IsA("Frame")
                                and v.Name ~= "UIGridLayout"
                                and v.Name ~= "UIListLayout"
                                and v.Name ~= "UIPadding" then
                                Button = v:FindFirstChild("Button")
                                if Button and Button:IsA("GuiButton") and Button.Selectable and Button.Visible then
                                    GuiService.SelectedObject = Button
                                    return
                                end
                            end
                        end
                    end
                end
            end)
        end)
    end
    syncInventoryUpdate()
    Skins.OnItemStockSchemasUpdated:Connect(function(a1) -- Line: 4052 -- upvalues: Profiler (upval), DataController (upval), LocalPlayer (upval), u0 (upval)
        Profiler.mark("UI.Inventory.ItemStockSchemasUpdated")
        local v1 = DataController.Get(LocalPlayer, "Inventory")
        u0.UpdateTemplates(v1)
    end)
    local v1 = LocalPlayer
    DataController.CreateListener(v1, "New Inventory Items", function(a1) -- Line: 4059 -- upvalues: Profiler (upval), u218 (upval), u214 (upval), RefreshNewInventoryItems (upval)
        Profiler.mark("UI.Inventory.NewInventoryItemsChanged")
        if type(a1) ~= "table" then
            return
        end
        local v1 = os.clock()
        for i, j in u218 do
            if 10 <= v1 - j then
                u218[i] = nil
            end
        end
        local v2 = {}
        for i2, v in ipairs(a1) do
            if not u218[v] then
                table.insert(v2, v)
            end
        end
        u214 = v2
        RefreshNewInventoryItems()
    end)
    Remotes.Store.CaseOpenDenied.Listen(function(a1) -- Line: 4084 -- upvalues: u207 (upval), Store (upval), u204 (upval), Router (upval)
        local RequestId_2 = if not a1 then nil else if typeof(a1.RequestId) ~= "string" then nil else a1.RequestId
        local v1 = RequestId_2 and u207 == RequestId_2
        if v1 then
            if not RequestId_2 or u207 == RequestId_2 then
                if u207 then
                    Store.ClearPendingOpenCaseRequest(u207)
                end
                u204 = false
                u207 = nil
            end
        end
        if v1 and a1 and a1.Reason == "RateLimited" then
            local v2 = (tonumber(a1.RetryAfterMs) or 0) / 1000
            local v3 = if not (v2 > 0) then "Quick open is rate limited. Please wait a moment and try again." else string.format("Quick open is rate limited. Wait %.1fs and try again.", v2)
            Router.broadcastRouter("CreateMenuNotification", "Error", v3)
        end
    end)
    v1 = LocalPlayer
    DataController.CreateListener(v1, "Inventory", function(a1) -- Line: 4099
        -- upvalues: Profiler (upval), u0 (upval), RefreshNewInventoryItems (upval), u200 (upval), u211 (upval)
        -- upvalues: u202 (upval), u187 (upval), GetSortedInventoryData (upval), ApplyFilterToSortedData (upval)
        -- upvalues: UpdateInventoryTemplates (upval), u209 (upval), u195 (upval)
        Profiler.mark("UI.Inventory.InventoryChanged")
        u0.UpdateInventory(a1)
        RefreshNewInventoryItems()
        if not u200 then
            u211.Frame.Right.Top.Filter.Container.Left.Title.Text = "Newest"
            u202 = "Newest"
            u200 = true
        end
        Profiler.mark("UI.Inventory.ApplyCurrentSort")
        if u211 and u211.Visible then
            u187 = GetSortedInventoryData()
            u187 = ApplyFilterToSortedData(u187)
            UpdateInventoryTemplates()
        end
        if u209 and u209.Visible and u195 and u195._id and type(a1) == "table" then
            local v1
            local _id = u195._id
            for i, v in ipairs(a1) do
                if v._id == _id then
                    v1 = v
                    if v1 then
                        u195 = v1
                        u0.SetupInformationFrame(v1)
                    end
                    return
                end
            end
            v1 = nil
            if v1 then
                u195 = v1
                u0.SetupInformationFrame(v1)
            end
        end
    end)
    v1 = LocalPlayer
    DataController.CreateListener(v1, "Loadout", function() -- Line: 4127 -- upvalues: Profiler (upval), u211 (upval), UpdateStatusFrame (upval)
        Profiler.mark("UI.Inventory.LoadoutChanged")
        if u211 and u211.Visible then
            local v1
            for i, v in ipairs(u211.Frame.Right.Container:GetChildren()) do
                v1 = v:IsA("ImageButton")
                if v1 then
                    v1 = false
                    if v.Name ~= "UIGridLayout" then
                        v1 = false
                        if v.Name ~= "UIListLayout" then
                            v1 = false
                            if v.Name ~= "UIPadding" then
                                v1 = false
                                if v.Name ~= "Title" then
                                    v1 = v.Name ~= "Label"
                                end
                            end
                        end
                    end
                end
                if v1 then
                    UpdateStatusFrame(v, v.Name)
                end
            end
        end
    end)
    MenuState.OnInspectStateChanged:Connect(function(a1) -- Line: 4140
        -- upvalues: Profiler (upval), u215 (upval), u211 (upval), u199 (upval), u0 (upval)
        if not a1 then
            Profiler.defer("UI.Inventory.InspectClosedDeferred", function() -- Line: 4142 -- upvalues: u215 (upval), u211 (upval), u199 (upval), u0 (upval)
                local v1 = #u215
                if u211.Visible and v1 > 0 and u199 < v1 then
                    u0.NextInventoryItem(u199 + 1)
                end
            end)
        end
    end)
    Router.observerRouter("QuickOpenResolved", function(a1) -- Line: 4155 -- upvalues: u207 (upval), Store (upval), u204 (upval)
        if typeof(a1) == "string" then
            if a1 and u207 ~= a1 then
                return
            end
            if u207 then
                Store.ClearPendingOpenCaseRequest(u207)
            end
            u204 = false
            u207 = nil
        end
    end)
    Router.observerRouter("ShowNewItemNotification", u0.ShowNewItemNotification)
    for i, j in CollectionService:GetTagged("CategoryFilter") do
        u237[j.Name] = true
        ActivateButton(j.Button)
        j.Button.Activated:Connect(function() -- Line: 4168
            -- upvalues: u237 (upval), j (val), Profiler (upval), u211 (upval), u187 (upval)
            -- upvalues: GetSortedInventoryData (upval), ApplyFilterToSortedData (upval)
            -- upvalues: UpdateInventoryTemplates (upval)
            u237[j.Name] = not u237[j.Name]
            j.Button.ImageLabel.Visible = u237[j.Name]
            Profiler.mark("UI.Inventory.ApplyCurrentSort")
            if not u211 or not u211.Visible then
                return
            end
            u187 = GetSortedInventoryData()
            u187 = ApplyFilterToSortedData(u187)
            UpdateInventoryTemplates()
        end)
    end
    for k, n in CollectionService:GetTagged("CategoryButtons") do
        n.Activated:Connect(function() -- Line: 4176 -- upvalues: n (val)
            local v1 = n.Parent[("%*Filter"):format(n.Name)]
            v1.Visible = not n.Parent[("%*Filter"):format(n.Name)].Visible
            n.Icon.Rotation = if not n.Parent[("%*Filter"):format(n.Name)].Visible then 0 else 180
        end)
    end
end

return u0