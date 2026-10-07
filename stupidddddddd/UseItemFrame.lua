-- ReplicatedStorage.Interface.Screens.Menu.UseItemFrame
-- Script path: ReplicatedStorage.Interface.Screens.Menu.UseItemFrame
-- Decompile time: 12.20 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases)
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections)
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation)
local CalculateGridRenderCount = require(ReplicatedStorage.Components.Common.CalculateGridRenderCount)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local ApplyWearAndSerialBadges = require(ReplicatedStorage.Components.Common.ApplyWearAndSerialBadges)
local Router = require(ReplicatedStorage.Database.Security.Router)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local Signal = require(ReplicatedStorage.Packages.Signal)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local Sort = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades)
local Actions = require(script.Actions)
local u115 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u116 = {"Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float", "Serial"}
local u125 = nil
local u126 = nil
local u127 = false
local u128 = nil
local u129 = nil
local u130 = false
local u131 = {}
local u132 = 0
local u133 = nil
local u134 = nil
local u135 = nil
local u136 = nil
local u137 = nil
local u138 = nil
u0.OnItemSelected = Signal.new()
u0.OnClosed = Signal.new()

local function MultiplyUdim2(a1, a2) -- Line: 91 -- types: a1: userdata, a2: number
    return UDim2.new(a1.X.Scale * a2, a1.X.Offset, a1.Y.Scale * a2, a1.Y.Offset)
end

local function ClearFrame(a1, a2) -- Line: 97 -- types: a1: userdata, a2: string
    for i, v in ipairs(a1:GetChildren()) do
        if v.ClassName == a2 or v:IsA("GuiButton") then
            v:Destroy()
        end
    end
end

local function CloseWithoutSelection() -- Line: 107 -- upvalues: u0 (val), u125 (ref)
    u0.OnClosed:Fire(u125)
    u0.Hide()
end

local function OnItemSelected(a1) -- Line: 112 -- upvalues: u125 (ref), u0 (val)
    if u125 then
        u0.OnItemSelected:Fire(a1, u125)
        u0.Hide()
    end
end

local function AnimateSortButton(a1, a2, a3, a4) -- Line: 121
    -- upvalues: TweenService (val), u115 (val), Router (val), u129 (ref), u0 (val)
    a2.MouseEnter:Connect(function() -- Line: 127 -- upvalues: TweenService (upval), a2 (val), u115 (upval)
        TweenService:Create(a2, u115, {BackgroundTransparency = 0.85}):Play()
    end)
    a2.MouseLeave:Connect(function() -- Line: 131 -- upvalues: TweenService (upval), a2 (val), u115 (upval)
        TweenService:Create(a2, u115, {BackgroundTransparency = 1}):Play()
    end)
    a2.MouseButton1Click:Connect(function() -- Line: 135 -- upvalues: Router (upval), u129 (upval), a3 (val), u0 (upval), a4 (val), a1 (val), a2 (val)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        u129 = a3
        u0.PopulateItems()
        a4.Text = a3
        for i, v in ipairs(a1:GetChildren()) do
            if v:IsA("TextButton") then
                v.Frame.BackgroundTransparency = if v ~= a2 then 1 else 0
            end
        end
        a1.Visible = false
    end)
end

local function AnimateButton(a1) -- Line: 151 -- upvalues: TweenService (val), u115 (val)
    local Size = a1.Size

    local function tweenToScale(a1_2) -- Line: 153
        -- upvalues: TweenService (upval), a1 (val), u115 (upval), Size (val)
        local v1 = TweenService
        local v2 = a1
        local v3 = u115
        local v4 = {}
        local v5 = Size
        v4.Size = UDim2.new(v5.X.Scale * a1_2, v5.X.Offset, v5.Y.Scale * a1_2, v5.Y.Offset)
        v1:Create(v2, v3, v4):Play()
    end

    a1.MouseEnter:Connect(function() -- Line: 157 -- upvalues: TweenService (upval), a1 (val), u115 (upval), Size (val)
        local v1 = TweenService
        local v2 = a1
        local v3 = u115
        local v4 = {}
        local v5 = Size
        v4.Size = UDim2.new(v5.X.Scale * 0.95, v5.X.Offset, v5.Y.Scale * 0.95, v5.Y.Offset)
        v1:Create(v2, v3, v4):Play()
    end)
    a1.MouseLeave:Connect(function() -- Line: 160 -- upvalues: TweenService (upval), a1 (val), u115 (upval), Size (val)
        local v1 = TweenService
        local v2 = a1
        local v3 = u115
        local v4 = {}
        local v5 = Size
        v4.Size = UDim2.new(v5.X.Scale * 1, v5.X.Offset, v5.Y.Scale * 1, v5.Y.Offset)
        v1:Create(v2, v3, v4):Play()
    end)
    a1.MouseButton1Down:Connect(function() -- Line: 163 -- upvalues: TweenService (upval), a1 (val), u115 (upval), Size (val)
        local v1 = TweenService
        local v2 = a1
        local v3 = u115
        local v4 = {}
        local v5 = Size
        v4.Size = UDim2.new(v5.X.Scale * 0.9, v5.X.Offset, v5.Y.Scale * 0.9, v5.Y.Offset)
        v1:Create(v2, v3, v4):Play()
    end)
    a1.MouseButton1Up:Connect(function() -- Line: 166 -- upvalues: TweenService (upval), a1 (val), u115 (upval), Size (val)
        local v1 = TweenService
        local v2 = a1
        local v3 = u115
        local v4 = {}
        local v5 = Size
        v4.Size = UDim2.new(v5.X.Scale * 0.95, v5.X.Offset, v5.Y.Scale * 0.95, v5.Y.Offset)
        v1:Create(v2, v3, v4):Play()
    end)
end

local function CalculateUseItemFrameInitialRenderCount() -- Line: 173
    -- upvalues: u134 (ref), CalculateGridRenderCount (val)
    if u134 and u134.Visible then
        return CalculateGridRenderCount(u134)
    end
    return 50
end

local function UseItemFrameLoadMoreItems() -- Line: 182
    -- upvalues: u134 (ref), u132 (ref), u131 (ref), u0 (val), OnItemSelected (val)
    local v1
    if not u134 then
        return
    end
    local v2 = u132 + 1
    local v3 = math.min(u132 + 25, #u131)
    for i = v2, v3 do
        v1 = u131[i]
        if v1 and not u134:FindFirstChild(v1._id) then
            u0.CreateItemTemplate(v1, OnItemSelected)
        end
    end
    u132 = v3
end

local function UseItemFrameOnScrollPositionChanged() -- Line: 201
    -- upvalues: u134 (ref), u132 (ref), u131 (ref), UseItemFrameLoadMoreItems (val)
    if not u134 then
        return
    end
    local Y = u134.CanvasPosition.Y
    local v1 = u134.AbsoluteCanvasSize.Y - u134.AbsoluteSize.Y
    if v1 > 0 and u132 < #u131 and v1 - Y < 200 then
        UseItemFrameLoadMoreItems()
    end
end

local function FindContainerAndSort(a1) -- Line: 220 -- upvalues: u134 (ref), u138 (ref) -- types: a1: userdata
    local Tabs = a1:FindFirstChild("Tabs")
    if not Tabs then
        return
    end
    local Inventory = Tabs:FindFirstChild("Inventory")
    if Inventory then
        u134 = Inventory:FindFirstChild("Container")
        u138 = Inventory:FindFirstChild("Sort")
    end
end

local function SetupSortButton(a1) -- Line: 233
    -- upvalues: u129 (ref), Router (val), u116 (val), AnimateSortButton (val)
    local TextLabel = (a1:FindFirstChild("Frame")):FindFirstChild("TextLabel")
    if TextLabel then
        TextLabel.Text = "Newest"
        u129 = "Newest"
    end
    a1.MouseButton1Click:Connect(function() -- Line: 240 -- upvalues: a1 (val), Router (upval)
        local Options = a1:FindFirstChild("Options")
        if Options then
            Options.Visible = not Options.Visible
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
        end
    end)
    local Options = a1:FindFirstChild("Options")
    if Options and TextLabel then
        local v1
        for i, j in u116 do
            v1 = Options:FindFirstChild(j)
            if v1 then
                AnimateSortButton(Options, v1, j, TextLabel)
            end
        end
        return
    end
end

local function findReverseSortButton(a1) -- Line: 262 -- upvalues: u138 (ref) -- types: a1: userdata
    local Frame = a1:FindFirstChild("Frame")
    local Right = Frame and Frame:FindFirstChild("Right")
    local Top = Right and Right:FindFirstChild("Top")
    local ReverseSort = Top and Top:FindFirstChild("ReverseSort")
    if ReverseSort and ReverseSort:IsA("GuiButton") then
        return ReverseSort
    end
    local ReverseSort_2 = u138 and u138:FindFirstChild("ReverseSort")
    if ReverseSort_2 and ReverseSort_2:IsA("GuiButton") then
        return ReverseSort_2
    end
    return nil
end

local function setupReverseSortButton(a1) -- Line: 274
    -- upvalues: findReverseSortButton (val), u130 (ref), u0 (val), Router (val)
    local v1 = findReverseSortButton(a1)
    if not v1 then
        return
    end
    local ImageLabel = v1:FindFirstChildOfClass("ImageLabel")
    v1.Selectable = true
    v1.Activated:Connect(function() -- Line: 282 -- upvalues: u130 (upval), ImageLabel (val), u0 (upval), Router (upval)
        u130 = not u130
        if ImageLabel then
            ImageLabel.Rotation = if not u130 then 0 else 180
        end
        u0.PopulateItems()
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
    end)
end

local function SetupTopBar(a1) -- Line: 294
    -- upvalues: u135 (ref), u136 (ref), CloseButtonRegistry (val), u133 (ref), Router (val), u0 (val), u125 (ref)
    local Top = a1:FindFirstChild("Top")
    if not Top then
        return true
    end
    u135 = Top:FindFirstChild("TextLabel")
    u136 = Top:FindFirstChild("Close")
    if not u136 then
        return false
    end
    CloseButtonRegistry.Add(u133, u136, function() -- Line: 306 -- upvalues: Router (upval), u0 (upval), u125 (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        local v1 = u125
        u0.OnClosed:Fire(v1)
        u0.Hide()
    end)
    return true
end

local function ConnectScrollLoading() -- Line: 313
    -- upvalues: u134 (ref), u132 (ref), u131 (ref), UseItemFrameLoadMoreItems (val)
    if u134 then
        (u134:GetPropertyChangedSignal("CanvasPosition")):Connect(function() -- Line: 315 -- upvalues: u134 (upval), u132 (upval), u131 (upval), UseItemFrameLoadMoreItems (upval)
            if not u134 then
                return
            end
            local Y = u134.CanvasPosition.Y
            local v1 = u134.AbsoluteCanvasSize.Y - u134.AbsoluteSize.Y
            if v1 > 0 and u132 < #u131 and v1 - Y < 200 then
                UseItemFrameLoadMoreItems()
            end
        end)
    end
end

local function ConnectStateListeners() -- Line: 322
    -- upvalues: DataController (val), LocalPlayer (val), u0 (val), MenuState (val), u125 (ref)
    DataController.CreateListener(LocalPlayer, "Inventory", function() -- Line: 323 -- upvalues: u0 (upval)
        if u0.IsVisible() then
            u0.PopulateItems()
        end
    end)
    MenuState.OnScreenChanged:Connect(function() -- Line: 329 -- upvalues: u0 (upval), u125 (upval)
        if u0.IsVisible() then
            local v1 = u125
            u0.OnClosed:Fire(v1)
            u0.Hide()
        end
    end)

    local function closeWhenActivated(a1) -- Line: 335 -- upvalues: u0 (upval), u125 (upval) -- types: a1: boolean
        if a1 and u0.IsVisible() then
            local v1 = u125
            u0.OnClosed:Fire(v1)
            u0.Hide()
        end
    end

    MenuState.OnInspectStateChanged:Connect(closeWhenActivated)
    MenuState.OnCaseSceneStateChanged:Connect(closeWhenActivated)
end

local function EnsureInitialized() -- Line: 347
    -- upvalues: u127 (ref), u137 (ref), PlayerGui (val), u133 (ref), u134 (ref), u138 (ref), SetupSortButton (val)
    -- upvalues: findReverseSortButton (val), u130 (ref), u0 (val), Router (val), SetupTopBar (val)
    -- upvalues: ConnectStateListeners (val), u132 (ref), u131 (ref), UseItemFrameLoadMoreItems (val)
    if u127 then
        return true
    end
    u137 = PlayerGui:FindFirstChild("MainGui")
    if not u137 then
        warn("[UseItemFrame] MainGui not found")
        return false
    end
    local Menu = u137:FindFirstChild("Menu")
    if not Menu then
        warn("[UseItemFrame] Menu frame not found")
        return false
    end
    u133 = Menu:FindFirstChild("UseItemFrame")
    if not u133 then
        warn("[UseItemFrame] UseItemFrame not found in Menu")
        return false
    end
    local Tabs = u133:FindFirstChild("Tabs")
    if Tabs then
        local Inventory = Tabs:FindFirstChild("Inventory")
        if Inventory then
            u134 = Inventory:FindFirstChild("Container")
            u138 = Inventory:FindFirstChild("Sort")
        end
    end
    if u138 then
        local Button = u138:FindFirstChild("Button")
        if Button then
            SetupSortButton(Button)
        end
    end
    local v1 = findReverseSortButton(u133)
    if v1 then
        local ImageLabel = v1:FindFirstChildOfClass("ImageLabel")
        v1.Selectable = true
        v1.Activated:Connect(function() -- Line: 282 -- upvalues: u130 (upval), ImageLabel (val), u0 (upval), Router (upval)
            u130 = not u130
            if ImageLabel then
                ImageLabel.Rotation = if not u130 then 0 else 180
            end
            u0.PopulateItems()
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
        end)
    end
    if not SetupTopBar(u133) then
        return
    end
    ConnectStateListeners()
    if u134 then
        (u134:GetPropertyChangedSignal("CanvasPosition")):Connect(function() -- Line: 315 -- upvalues: u134 (upval), u132 (upval), u131 (upval), UseItemFrameLoadMoreItems (upval)
            if not u134 then
                return
            end
            local Y = u134.CanvasPosition.Y
            local v1 = u134.AbsoluteCanvasSize.Y - u134.AbsoluteSize.Y
            if v1 > 0 and u132 < #u131 and v1 - Y < 200 then
                UseItemFrameLoadMoreItems()
            end
        end)
    end
    u127 = true
    return true
end

function u0.CreateItemTemplate(a1, a2) -- Line: 395
    -- upvalues: u134 (ref), Cases (val), GetResolvedSkinInformation (val), Rarities (val), Skins (val)
    -- upvalues: ReplicatedStorage (val), ApplyWearAndSerialBadges (val), GetSkinDisplayName (val), Router (val)
    -- upvalues: AnimateButton (val)
    if a1 and a1._id then
        local v1
        if not u134 then
            return
        end
        local v2 = a1.Type == "Case" and Cases.GetCaseByName(a1.Skin) or GetResolvedSkinInformation(a1.Name, a1.Skin)
        if not v2 then
            return
        end
        local caseRarity = v1 and v2.caseRarity or v2.rarity
        local v3 = Rarities[caseRarity]
        local assetId = nil
        if v1 then
            assetId = v2.imageAssetId or ""
        elseif a1.Type ~= "Charm" then
            assetId = Skins.GetWearImageForFloat(v2, a1.Float or 0.9999) or v2.imageAssetId or ""
        else
            local Pattern = a1.Pattern
            if Pattern and v2.charmImages then
                for i, v in ipairs(v2.charmImages) do
                    if v.pattern == Pattern then
                        assetId = v.assetId
                        break
                    end
                end
            end
            if not assetId then
                assetId = v2.imageAssetId or ""
            end
        end
        local v4 = ReplicatedStorage.Assets.UI.Inventory.ItemTemplate:Clone()
        v4.ItemContent.Rarity.BackgroundColor3 = v3.Color
        v4.Parent = u134
        v4.ItemContent.Content.Icon.Image = assetId
        v4.Name = a1._id
        ApplyWearAndSerialBadges(v4, a1, v2)
        local Charm = v4.ItemContent:FindFirstChild("Charm")
        if Charm and Charm:IsA("ImageLabel") then
            Charm.Visible = false
            Charm.Image = ""
        end
        local v5 = GetSkinDisplayName.GetWeaponDisplayName(a1.Name, a1.NameTag)
        GetSkinDisplayName.ApplyNameLabel(v4.Bottom.Footer.WeaponName, a1.StatTrack and "KillTrak™ " .. v5 or v5, a1.NameTag)
        local SkinName = v4.Bottom.Footer.SkinName
        local skin = v1 and v2.skin or a1.Skin
        SkinName.Text = skin
        if a1.Type == "Charm" then
            v4.MouseButton2Click:Connect(function() -- Line: 461 -- upvalues: Router (upval), a1 (val)
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
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
            end)
        end
        v4.MouseButton1Click:Connect(function() -- Line: 481 -- upvalues: Router (upval), a2 (val), a1 (val)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            a2(a1)
        end)
        AnimateButton(v4)
        return
    end
end

function u0.PopulateItems() -- Line: 491
    -- upvalues: u134 (ref), ClearFrame (val), u132 (ref), u131 (ref), DataController (val), LocalPlayer (val)
    -- upvalues: Grenades (val), u126 (ref), u125 (ref), u129 (ref), u138 (ref), Sort (val), u128 (ref), u130 (ref)
    -- upvalues: CalculateGridRenderCount (val), u0 (val), OnItemSelected (val)
    if not u134 then
        return
    end
    ClearFrame(u134, "Frame")
    u132 = 0
    u131 = {}
    local v1 = DataController.Get(LocalPlayer, "Inventory")
    if v1 and type(v1) == "table" then
        local v2, v3, v4, v5
        for i, v in ipairs(v1) do
            v2 = v and Grenades[v.Name]
            v3 = v and v.Type == "Case"
            if v and v._id and v.Name and (v3 or v.Skin) and not v2 and not v3 then
                v5 = true
                if u126 and u125 then
                    v5 = u126(v, u125)
                end
                if v5 then
                    table.insert(u131, v)
                end
            end
        end
        local u41 = Sort.GetSortComparisonFunction(u129 or u138 and u138.Button.Frame.TextLabel.Text or "Newest", LocalPlayer, function() -- Line: 530 -- upvalues: u128 (upval)
            return u128
        end)
        if u41 then
            if not u130 then
                table.sort(u131, u41)
            else
                table.sort(u131, function(a1, a2) -- Line: 536 -- upvalues: u41 (val)
                    local v1, v2 = u41(a1, a2)
                    if v2 then
                        return v1
                    end
                    return u41(a2, a1)
                end)
            end
        end
        local v6 = math.min(math.max(if not u134 then 50 else if u134.Visible then CalculateGridRenderCount(u134) else 50, 50), #u131)
        for i2 = 1, v6 do
            v4 = u131[i2]
            if v4 then
                u0.CreateItemTemplate(v4, OnItemSelected)
            end
        end
        u132 = v6
        return
    end
end

function u0.Show(a1, a2) -- Line: 565
    -- upvalues: EnsureInitialized (val), u133 (ref), u125 (ref), u126 (ref), u135 (ref), u0 (val)
    if not EnsureInitialized() then
        warn("[UseItemFrame] Failed to initialize")
        return
    end
    if not u133 then
        return
    end
    u125 = a1
    u126 = a2
    if u135 then
        local SourceItem = a1.SourceItem
        if SourceItem then
            local v1 = (if not SourceItem.StatTrack then "" else "KillTrak™ ") .. SourceItem.Name
            if SourceItem.Skin then
                v1 = v1 .. " | " .. SourceItem.Skin
            end
            u135.Text = ("Select an item to use with %*"):format(v1)
        elseif not a1.Title then
            u135.Text = "Select an item"
        else
            u135.Text = a1.Title
        end
    end
    u0.PopulateItems()
    u133.Visible = true
end

function u0.Hide() -- Line: 601 -- upvalues: u133 (ref), u125 (ref), u126 (ref)
    if u133 then
        u133.Visible = false
    end
    u125 = nil
    u126 = nil
end

function u0.IsVisible() -- Line: 612 -- upvalues: u133 (ref)
    return u133 and u133.Visible or false
end

function u0.Initialize(a1, a2) -- Line: 619
    -- upvalues: u137 (ref), u133 (ref), u134 (ref), u138 (ref), SetupSortButton (val), findReverseSortButton (val)
    -- upvalues: u130 (ref), u0 (val), Router (val), SetupTopBar (val), u132 (ref), u131 (ref)
    -- upvalues: UseItemFrameLoadMoreItems (val), u127 (ref)
    u137 = a1
    u133 = a2
    local Tabs = a2:FindFirstChild("Tabs")
    if Tabs then
        local Inventory = Tabs:FindFirstChild("Inventory")
        if Inventory then
            u134 = Inventory:FindFirstChild("Container")
            u138 = Inventory:FindFirstChild("Sort")
        end
    end
    if u138 then
        local Button = u138:FindFirstChild("Button")
        if Button then
            SetupSortButton(Button)
        end
    end
    local v1 = findReverseSortButton(a2)
    if v1 then
        local ImageLabel = v1:FindFirstChildOfClass("ImageLabel")
        v1.Selectable = true
        v1.Activated:Connect(function() -- Line: 282 -- upvalues: u130 (upval), ImageLabel (val), u0 (upval), Router (upval)
            u130 = not u130
            if ImageLabel then
                ImageLabel.Rotation = if not u130 then 0 else 180
            end
            u0.PopulateItems()
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
        end)
    end
    if not SetupTopBar(a2) then
        return
    end
    if u134 then
        (u134:GetPropertyChangedSignal("CanvasPosition")):Connect(function() -- Line: 315 -- upvalues: u134 (upval), u132 (upval), u131 (upval), UseItemFrameLoadMoreItems (upval)
            if not u134 then
                return
            end
            local Y = u134.CanvasPosition.Y
            local v1 = u134.AbsoluteCanvasSize.Y - u134.AbsoluteSize.Y
            if v1 > 0 and u132 < #u131 and v1 - Y < 200 then
                UseItemFrameLoadMoreItems()
            end
        end)
    end
    a2.Visible = false
    u127 = true
end

function u0.Start() -- Line: 646 -- upvalues: Actions (val), ConnectStateListeners (val)
    Actions.InitializeAll()
    ConnectStateListeners()
end

Collections.ObserveAvailableCollections(function(a1) -- Line: 655 -- upvalues: u128 (ref)
    u128 = a1
end)

function u0.TriggerAction(a1, a2) -- Line: 659 -- upvalues: Actions (val), u0 (val) -- types: a1: string
    local v1 = Actions.Get(a1)
    if not v1 then
        warn((("[UseItemFrame] Unknown action type: %*"):format(a1)))
        return
    end
    u0.Show(v1.GetContext(a2), v1.GetFilter(a2))
end

function u0.GetActions() -- Line: 669 -- upvalues: Actions (val)
    return Actions
end

return u0