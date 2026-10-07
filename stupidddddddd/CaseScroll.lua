-- ReplicatedStorage.Interface.Screens.Menu.Store.CaseScroll
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Store.CaseScroll
-- Decompile time: 11.46 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
require(ReplicatedStorage.Database.Custom.Types)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
require(ReplicatedStorage.Database.Components.Libraries.Cases)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local u47 = nil
local u48 = nil
local u49 = nil
local u50 = 0

local function GetRandomCaseItem(a1) -- Line: 47
    local v1 = 0
    for i, v in ipairs(a1.contents) do
        v1 = v1 + v.weight
    end
    local v2 = math.random() * v1
    local v3 = 0
    for i2, i3 in ipairs(a1.contents) do
        v3 = v3 + i3.weight
        if v2 <= v3 then
            return i3, i3.isSpecial or false
        end
    end
    local v4 = a1.contents[1]
    return v4, v4.isSpecial or false
end

local function GenerateScrollItemList(a1, a2, a3, a4) -- Line: 66
    -- upvalues: u49 (ref), GetRandomCaseItem (val)
    local v1, v2
    local v3 = {}
    local CASE_SCROLL_ITEM_COUNT = u49.CASE_SCROLL_ITEM_COUNT
    local v4, v5, v6, v7 = a3, a2, a4, a1
    for i = 1, CASE_SCROLL_ITEM_COUNT do
        if i ~= v4 then
            v1, v2 = GetRandomCaseItem(v7)
            table.insert(v3, {item = v1, isGold = v2})
        else
            table.insert(v3, {item = v5, isGold = v6})
        end
    end
    return v3
end

local function CreateScrollItem(a1, a2, a3, a4) -- Line: 100
    -- upvalues: ReplicatedStorage (val), Rarities (val), Skins (val), u49 (ref)
    local CaseScroll = ReplicatedStorage.Assets.UI.Store.CaseScroll
    local GoldTemplate = if not a2.isGold then CaseScroll:FindFirstChild("ItemTemplate") else CaseScroll:FindFirstChild("GoldTemplate")
    if not GoldTemplate then
        warn("[Store] Missing case scroll template")
        return
    end
    local v1 = GoldTemplate:Clone()
    v1.Name = tostring(a3)
    v1.LayoutOrder = a3
    v1.Size = a4
    v1.SizeConstraint = Enum.SizeConstraint.RelativeXY
    v1.AutomaticSize = Enum.AutomaticSize.None
    v1.Parent = a1
    if a2.isGold then
        local Icon_2 = v1.Frame.Icon
        local DEFAULT_CASE_ICON = u49.SPECIAL_CASE_ICONS[string.lower(a2.item.skin.skinName)] or u49.DEFAULT_CASE_ICON
        Icon_2.Image = DEFAULT_CASE_ICON
        return
    end
    local v2 = Rarities[a2.item.rarity]
    local v3 = Skins.GetSkinInformation(a2.item.skin.weaponName, a2.item.skin.skinName)
    local Frame = v1:FindFirstChild("Frame")
    if v2 and v3 and Frame then
        local RarityFrame = Frame:FindFirstChild("RarityFrame")
        if RarityFrame then
            local UIGradient = RarityFrame:FindFirstChild("UIGradient")
            if UIGradient then
                UIGradient.Color = v2.ColorSequence
            end
        end
        local Icon = Frame:FindFirstChild("Icon")
        if Icon then
            Icon.Image = if v3 then if not v3.wearImages then if not v3.charmImages then v3.imageAssetId or "" else if not v3.charmImages[1] then v3.imageAssetId or "" else v3.charmImages[1].assetId else if not v3.wearImages[1] then if not v3.charmImages then v3.imageAssetId or "" else if not v3.charmImages[1] then v3.imageAssetId or "" else v3.charmImages[1].assetId else v3.wearImages[1].assetId else ""
        end
        local Rarity = Frame:FindFirstChild("Rarity")
        if Rarity then
            Rarity.ImageColor3 = v2.Color
            return
        end
    end
end

local function PopulateScrollContainer(a1, a2, a3, a4) -- Line: 147
    -- upvalues: CreateScrollItem (val)
    local v1, v2, v3, v4 = a1, a4, a2, a3
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v:Destroy()
        end
    end
    local UIListLayout = v1:FindFirstChildOfClass("UIListLayout")
    if UIListLayout then
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.Padding = UDim.new(0, v2)
    end
    for i2, i3 in ipairs(v3) do
        CreateScrollItem(v1, i3, i2, v4)
    end
end

local function ConfigureScrollContainer(a1, a2) -- Line: 172 -- types: a1: userdata, a2: number
    local v1 = math.max(a1.AbsoluteSize.X, 1)
    a1.CanvasSize = UDim2.fromScale(math.max(a2 / v1, 1), 0)
    a1:SetAttribute("ScrollMaxOffset", (math.max(0, a2 - v1)))
    a1:SetAttribute("ScrollViewportWidth", v1)
end

local function CalculateTargetOffset(a1, a2, a3, a4, a5) -- Line: 182
    -- upvalues: 
    local v1 = math.max(a1.AbsoluteSize.X, 1)
    local v2 = math.max(0, a2 - v1)
    if v2 <= 0 then
        return 0
    end
    return (math.clamp((a3 - 0.5) * a4 - v1 * 0.5 + a5, 0, v2))
end

local function AnimateScroll(a1, a2, a3, a4, a5, a6) -- Line: 200
    -- upvalues: u49 (ref), TweenService (val), u48 (ref), RunServiceController (val)
    local v1 = TweenInfo.new(u49.CASE_SCROLL_DURATION, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local u22 = TweenService:Create(a1, v1, {CanvasPosition = Vector2.new(a3, 0)})
    local u33 = TweenService:Create(a2, v1, {CanvasPosition = Vector2.new(a4, 0)})
    u48.currentTween = u22
    u48.currentZoomTween = u33
    local u36 = 0
    local u37 = nil

    local function stopRender() -- Line: 222 -- upvalues: u37 (ref), u48 (upval)
        if u37 then
            u37:Disconnect()
            u37 = nil
            u48.renderConnection = nil
        end
    end

    u37 = RunServiceController.BindToRenderStep("UI.Store.CaseOpeningSounds", function() -- Line: 229
        -- upvalues: u48 (upval), u37 (ref), a1 (val), a5 (val), u36 (ref), u49 (upval), a6 (val), u22 (val)
        if not u48.isOpening then
            if u37 then
                u37:Disconnect()
                u37 = nil
                u48.renderConnection = nil
            end
            return
        end
        local X = a1.CanvasPosition.X
        local v1 = math.floor(if not (a5 > 0) then 0 else X / a5) + 1
        if u36 < v1 and v1 <= u49.CASE_SCROLL_ITEM_COUNT then
            a6(v1)
            u36 = v1
        end
        if u22.PlaybackState == Enum.PlaybackState.Completed and u37 then
            u37:Disconnect()
            u37 = nil
            u48.renderConnection = nil
        end
    end)
    u48.renderConnection = u37
    u22.Completed:Connect(function() -- Line: 252 -- upvalues: u22 (val), u48 (upval), u37 (ref)
        if u22 == u48.currentTween and u37 then
            u37:Disconnect()
            u37 = nil
            u48.renderConnection = nil
        end
    end)
    task.delay(u49.CASE_SCROLL_DURATION * 0.86, function() -- Line: 259
        -- upvalues: u22 (val), u48 (upval), a1 (val), a2 (val), u33 (val), a3 (val), a4 (val), u37 (ref)
        if u22 ~= u48.currentTween or u22.PlaybackState == Enum.PlaybackState.Completed then
            return
        end
        if a1.Parent ~= nil and a2.Parent ~= nil then
            u22:Cancel()
            u33:Cancel()
            a1.CanvasPosition = Vector2.new(a3, 0)
            a2.CanvasPosition = Vector2.new(a4, 0)
        end
        if u37 then
            u37:Disconnect()
            u37 = nil
            u48.renderConnection = nil
        end
    end)
    u22:Play()
    u33:Play()
    return u22
end

local function FindWinningItem(a1, a2) -- Line: 283
    for i, v in ipairs(a1.contents) do
        if v.skin.skinName == a2.Skin and v.skin.weaponName == a2.Name then
            return v, v.isSpecial or false
        end
    end
    if a2.Type ~= "Melee" and a2.Type ~= "Glove" then
        local v1 = a1.contents[1]
        return v1, v1.isSpecial or false
    end
    return {
        isSpecial = true,
        rarity = "Special",
        skinId = "",
        weight = 0,
        skin = {weaponName = a2.Name, skinName = a2.Skin, type = a2.Type},
    }, true
end

local function ResetProgressBar() -- Line: 309 -- upvalues: u48 (ref), u47 (ref)
    local ProgressBarImage, v1
    if u48.progressRightTween then
        u48.progressRightTween:Cancel()
        u48.progressRightTween = nil
    end
    if u48.progressRightProxy then
        u48.progressRightProxy:Destroy()
        u48.progressRightProxy = nil
    end
    if not u47 then
        return
    end
    local ProgressBar = u47.Menu.OpenCase.Contents:FindFirstChild("ProgressBar")
    if not ProgressBar then
        return
    end
    local v2 = {"RightGradient", "LeftGradient"}
    local v3 = nil
    local v4 = nil
    for i, j in v2, v3, v4 do
        v1 = ProgressBar:FindFirstChild(j)
        ProgressBarImage = v1 and v1:FindFirstChild("ProgressBarImage") and v1.ProgressBarImage:FindFirstChild("UIGradient")
        if ProgressBarImage then
            ProgressBarImage.Transparency = NumberSequence.new(1)
            ProgressBarImage.Rotation = 90
        end
    end
end

local function MakeArcTransparency(a1, a2, a3) -- Line: 340 -- types: a1: number, a2: number, a3: number
    if a1 <= 0.001 then
        return NumberSequence.new(a3)
    end
    if a1 >= 0.999 then
        return NumberSequence.new(a2)
    end
    local v1 = math.clamp(a1 - 0.05, 0, 0.999)
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, a2),
        NumberSequenceKeypoint.new(v1, a2),
        NumberSequenceKeypoint.new(math.clamp(a1, v1 + 0.001, 1), a3),
        (NumberSequenceKeypoint.new(1, a3)),
    })
end

local function MakeFillTransparency(a1) -- Line: 357 -- upvalues: MakeArcTransparency (val) -- types: a1: number
    return MakeArcTransparency(a1, 0, 1)
end

local function MakeEraseTransparency(a1) -- Line: 361 -- upvalues: MakeArcTransparency (val) -- types: a1: number
    return MakeArcTransparency(a1, 1, 0)
end

local function AnimateProgressBar(a1) -- Line: 367
    -- upvalues: ResetProgressBar (val), u47 (ref), u50 (ref), u49 (ref), u48 (ref), TweenService (val)
    -- upvalues: MakeFillTransparency (val), MakeEraseTransparency (val), Profiler (val)
    ResetProgressBar()
    if not u47 then
        return
    end
    local ProgressBar = u47.Menu.OpenCase.Contents:FindFirstChild("ProgressBar")
    if not ProgressBar then
        return
    end
    local LeftGradient = ProgressBar:FindFirstChild("LeftGradient")
    local RightGradient = ProgressBar:FindFirstChild("RightGradient")
    if LeftGradient and RightGradient then
        local ProgressBarImage = LeftGradient:FindFirstChild("ProgressBarImage")
        local ProgressBarImage_2 = RightGradient:FindFirstChild("ProgressBarImage")
        if ProgressBarImage and ProgressBarImage_2 then
            local UIGradient = ProgressBarImage:FindFirstChild("UIGradient")
            local UIGradient_2 = ProgressBarImage_2:FindFirstChild("UIGradient")
            if UIGradient and UIGradient_2 then
                LeftGradient.ClipsDescendants = true
                RightGradient.ClipsDescendants = true
                UIGradient.Rotation = 90
                UIGradient_2.Rotation = -90
                UIGradient.Transparency = NumberSequence.new(1)
                UIGradient_2.Transparency = NumberSequence.new(1)
                ProgressBar.Visible = true
                u50 = u50 + 1
                local u49_2 = u50
                local u53 = a1 / u49.PROGRESS_BAR_LOOPS / 4

                local function runPhase(a1, a2, a3) -- Line: 407
                    -- upvalues: u48 (upval), u49_2 (val), u50 (upval), TweenService (upval)
                    if u48.isOpening and u49_2 == u50 then
                        local NumberValue = Instance.new("NumberValue")
                        NumberValue.Value = 0
                        local v1 = NumberValue.Changed:Connect(function(a1_2) -- Line: 418 -- upvalues: a1 (val), a2 (val)
                            a1.Transparency = a2(a1_2)
                        end)
                        u48.progressRightProxy = NumberValue
                        local v2 = TweenService:Create(NumberValue, TweenInfo.new(a3, Enum.EasingStyle.Linear), {Value = 1})
                        u48.progressRightTween = v2
                        v2:Play()
                        v2.Completed:Wait()
                        v1:Disconnect()
                        NumberValue:Destroy()
                        u48.progressRightProxy = nil
                        u48.progressRightTween = nil
                        return u48.isOpening and u49_2 == u50
                    end
                    return false
                end

                local u55 = {
                    {UIGradient, MakeFillTransparency},
                    {UIGradient_2, MakeFillTransparency},
                    {UIGradient, MakeEraseTransparency},
                    {UIGradient_2, MakeEraseTransparency},
                }
                Profiler.spawn("UI.Store.ProgressBarThread", function() -- Line: 444 -- upvalues: u49 (upval), u55 (val), runPhase (val), u53 (val)
                    local PROGRESS_BAR_LOOPS = u49.PROGRESS_BAR_LOOPS
                    for i = 1, PROGRESS_BAR_LOOPS do
                        for j, k in u55 do
                            if not runPhase(k[1], k[2], u53) then
                                return
                            end
                        end
                    end
                end)
                return
            end
            return
        end
        return
    end
end

function v1.Bind(a1, a2, a3) -- Line: 561
    -- upvalues: u47 (ref), u48 (ref), u49 (ref)
    u47 = a1
    u48 = a2
    u49 = a3
end

function v1.GetStoreItemIcon(a1) -- Line: 86
    if not a1 then
        return ""
    end
    if a1.wearImages and a1.wearImages[1] then
        return a1.wearImages[1].assetId
    end
    if a1.charmImages and a1.charmImages[1] then
        return a1.charmImages[1].assetId
    end
    return a1.imageAssetId or ""
end

v1.ResetProgressBar = ResetProgressBar

function v1.RunScrollAnimation(a1, a2) -- Line: 457
    -- upvalues: u48 (ref), u47 (ref), FindWinningItem (val), GenerateScrollItemList (val), u49 (ref)
    -- upvalues: PopulateScrollContainer (val), ConfigureScrollContainer (val), AnimateScroll (val), Router (val)
    -- upvalues: AnimateProgressBar (val), TweenService (val)
    if not u48.isOpening then
        return nil
    end
    local OpenCase = u47.Menu.OpenCase
    local CanvasGroup = OpenCase:FindFirstChild("CanvasGroup")
    local Zoom = OpenCase:FindFirstChild("Zoom")
    if CanvasGroup and Zoom then
        local Container = CanvasGroup:FindFirstChild("Container")
        local Container_2 = Zoom:FindFirstChild("Container")
        if Container and Container_2 then
            local v1
            local v2, v3 = FindWinningItem(a1, a2)
            local v4 = GenerateScrollItemList(a1, v2, u49.CASE_SCROLL_WINNING_INDEX, v3)
            local AbsoluteSize = u47 and u47.AbsoluteSize or Vector2.new(u49.CASE_SCROLL_ITEM_WIDTH * 5, 1000)
            local v5 = math.max(AbsoluteSize.X / 5, 1)
            local v6 = math.max(v5 * 0.65, 1)
            local v7 = UDim2.fromOffset(v5, v6)
            local v8 = UDim2.fromOffset(v5, v6 * 1.125)
            local Line = OpenCase:FindFirstChild("Line")
            if Line and Line:IsA("GuiObject") then
                Line.Size = UDim2.new(0.003, 0, 0, v6 * 1.125)
            end
            PopulateScrollContainer(Container, v4, v7, u49.CASE_SCROLL_ITEM_PADDING)
            PopulateScrollContainer(Container_2, v4, v8, u49.CASE_SCROLL_ITEM_PADDING)
            Container.CanvasPosition = Vector2.new(0, 0)
            Container_2.CanvasPosition = Vector2.new(0, 0)
            local u115 = v5 + u49.CASE_SCROLL_ITEM_PADDING
            local u118 = u49.CASE_SCROLL_ITEM_COUNT * u115
            task.wait()
            ConfigureScrollContainer(Container, u118)
            ConfigureScrollContainer(Container_2, u118)
            local X = AbsoluteSize.X
            local u139 = math.random(-math.floor(X / 11), (math.floor(X / 22)))
            local CASE_SCROLL_WINNING_INDEX = u49.CASE_SCROLL_WINNING_INDEX
            local v9 = math.max(Container.AbsoluteSize.X, 1)
            local v10 = math.max(0, u118 - v9)
            local v11 = if not (v10 <= 0) then math.clamp((CASE_SCROLL_WINNING_INDEX - 0.5) * u115 - v9 * 0.5 + u139, 0, v10) else 0
            local CASE_SCROLL_WINNING_INDEX_2 = u49.CASE_SCROLL_WINNING_INDEX
            v10 = math.max(Container_2.AbsoluteSize.X, 1)
            local v12 = math.max(0, u118 - v10)
            Container:SetAttribute("_scrollTarget", v11)
            Container_2:SetAttribute(
                "_scrollTarget",
                if not (v12 <= 0) then math.clamp((CASE_SCROLL_WINNING_INDEX_2 - 0.5) * u115 - v10 * 0.5 + u139, 0, v12) else 0
            )
            local u207 = tick()
            v10 = AnimateScroll(Container, Container_2, v11, v1, u115, function() -- Line: 506 -- upvalues: Router (upval)
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
            end)
            AnimateProgressBar(u49.CASE_SCROLL_DURATION)
            u48.viewportConnection = (workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize")):Connect(function() -- Line: 512
                -- upvalues: u48 (upval), Container (val), u118 (val), u49 (upval), u115 (val), u139 (val)
                -- upvalues: Container_2 (val), u207 (val), TweenService (upval)
                if not u48.isOpening then
                    return
                end
                local v1 = Container
                local v2 = u118
                local CASE_SCROLL_WINNING_INDEX = u49.CASE_SCROLL_WINNING_INDEX
                local v3 = math.max(v1.AbsoluteSize.X, 1)
                local v4 = math.max(0, v2 - v3)
                local v5 = if not (v4 <= 0) then math.clamp((CASE_SCROLL_WINNING_INDEX - 0.5) * u115 - v3 * 0.5 + u139, 0, v4) else 0
                v2 = Container_2
                local v6 = u118
                local CASE_SCROLL_WINNING_INDEX_2 = u49.CASE_SCROLL_WINNING_INDEX
                v4 = math.max(v2.AbsoluteSize.X, 1)
                local v7 = math.max(0, v6 - v4)
                v1 = if not (v7 <= 0) then math.clamp((CASE_SCROLL_WINNING_INDEX_2 - 0.5) * u115 - v4 * 0.5 + u139, 0, v7) else 0
                if u48.currentTween then
                    u48.currentTween:Cancel()
                end
                if u48.currentZoomTween then
                    u48.currentZoomTween:Cancel()
                end
                v2 = math.max(0.1, u49.CASE_SCROLL_DURATION - ((tick()) - u207))
                v6 = TweenInfo.new(v2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                local v8 = TweenService:Create(Container, v6, {CanvasPosition = Vector2.new(v5, 0)})
                local v9 = TweenService:Create(Container_2, v6, {CanvasPosition = Vector2.new(v1, 0)})
                u48.currentTween = v8
                u48.currentZoomTween = v9
                v8:Play()
                v9:Play()
            end)
            if v10 then
                local currentTween
                while u48.isOpening do
                    currentTween = u48.currentTween
                    if not currentTween then
                        break
                    end
                    currentTween.Completed:Wait()
                    if u48.currentTween == currentTween then
                        break
                    end
                end
            end
            if u48.viewportConnection then
                u48.viewportConnection:Disconnect()
                u48.viewportConnection = nil
            end
            u48.currentTween = nil
            u48.currentZoomTween = nil
            return v2
        end
        warn("[Store] Missing scroll containers for case opening")
        return nil
    end
    warn("[Store] Missing CanvasGroup or Zoom group in OpenCase UI")
    return nil
end

return v1