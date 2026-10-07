-- ReplicatedStorage.Interface.Screens.Menu.Store.Hover
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Store.Hover
-- Decompile time: 5.51 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local MarketPlacePrices = require(ReplicatedStorage.Database.Components.MarketPlacePrices)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local u52 = nil
local u53 = nil
local u54 = nil
local u55 = 0
local u56 = ""
local u57 = false
local u58 = {}

local function GetStoreHoverFrame() -- Line: 38 -- upvalues: u52 (ref)
    local StoreHoverFrame = u52 and u52:FindFirstChild("StoreHoverFrame")
    if StoreHoverFrame and StoreHoverFrame:IsA("Frame") then
        return StoreHoverFrame
    end
    return nil
end

local function GetStoreHoverTextLabel(...) -- Line: 45 -- upvalues: u52 (ref)
    local StoreHoverFrame = u52 and u52:FindFirstChild("StoreHoverFrame")
    local v1 = if not StoreHoverFrame then nil else if not StoreHoverFrame:IsA("Frame") then nil else StoreHoverFrame
    for i, j in {...} do
        if not v1 then
            return nil
        end
        v1 = v1:FindFirstChild(j)
    end
    if v1 and v1:IsA("TextLabel") then
        return v1
    end
    return nil
end

local function GetStoreHoverPriceLabel() -- Line: 60 -- upvalues: GetStoreHoverTextLabel (val)
    return GetStoreHoverTextLabel("Info", "Price", "Frame", "TextLabel")
end

local function SetStoreHoverVisible(a1) -- Line: 66 -- upvalues: u52 (ref) -- types: a1: boolean
    local StoreHoverFrame = u52 and u52:FindFirstChild("StoreHoverFrame")
    local v1 = if not StoreHoverFrame then nil else if not StoreHoverFrame:IsA("Frame") then nil else StoreHoverFrame
    if v1 then
        v1.Visible = a1
    end
end

local function UpdateStoreHoverPosition() -- Line: 75
    -- upvalues: u52 (ref), UserInputService (val), GuiService (val), u53 (ref)
    local v1
    local StoreHoverFrame = u52 and u52:FindFirstChild("StoreHoverFrame")
    if not (if not StoreHoverFrame then nil else if not StoreHoverFrame:IsA("Frame") then nil else StoreHoverFrame) then
        return
    end
    local Parent = v1.Parent
    if Parent and Parent:IsA("GuiObject") then
        local v2 = (UserInputService:GetMouseLocation()) - GuiService:GetGuiInset()
        local AbsolutePosition = Parent.AbsolutePosition
        local AbsoluteSize = Parent.AbsoluteSize
        local AbsoluteSize_2 = v1.AbsoluteSize
        local AnchorPoint = v1.AnchorPoint
        local v3 = AbsolutePosition.X + u53.STORE_HOVER_PADDING
        local v4 = AbsolutePosition.Y + u53.STORE_HOVER_PADDING
        local v5 = math.max(v3, AbsolutePosition.X + AbsoluteSize.X - AbsoluteSize_2.X - u53.STORE_HOVER_PADDING)
        local v6 = math.max(v4, AbsolutePosition.Y + AbsoluteSize.Y - AbsoluteSize_2.Y - u53.STORE_HOVER_PADDING)
        local v7 = math.clamp(v2.X + u53.STORE_HOVER_MOUSE_OFFSET.X, v3, v5)
        local v8 = math.clamp(v2.Y + u53.STORE_HOVER_MOUSE_OFFSET.Y, v4, v6)
        v1.Position = UDim2.fromOffset(
            math.floor(v7 - AbsolutePosition.X + AbsoluteSize_2.X * AnchorPoint.X + 0.5),
            (math.floor(v8 - AbsolutePosition.Y + AbsoluteSize_2.Y * AnchorPoint.Y + 0.5))
        )
        return
    end
end

local function GetStoreHoverPriceText(a1, a2, a3) -- Line: 107
    -- upvalues: MarketPlacePrices (val), CommaNumber (val)
    if a3 then
        local function GetWearTradeTokens(a1_2) -- Line: 109
            -- upvalues: MarketPlacePrices (upval), a1 (val), a2 (val)
            local v1 = MarketPlacePrices.GetItemPrice(a1, a2, a1_2, false)
            local v2 = v1 and math.floor(v1.recentAveragePriceTradeTokens)
            if v2 and v2 <= 0 then
                return nil
            end
            return v2
        end

        local min = a3.floatRange.min
        local v1 = MarketPlacePrices.GetItemPrice(a1, a2, min, false)
        local v2 = v1 and math.floor(v1.recentAveragePriceTradeTokens)
        local v3 = if not v2 then v2 else if not (v2 <= 0) then v2 else nil
        local max = a3.floatRange.max
        v2 = MarketPlacePrices.GetItemPrice(a1, a2, max, false)
        local v4 = v2 and math.floor(v2.recentAveragePriceTradeTokens)
        local v5 = if not v4 then v4 else if not (v4 <= 0) then v4 else nil
        if v3 and v5 then
            return (("%*-%*"):format(CommaNumber((math.min(v3, v5))), (CommaNumber((math.max(v3, v5))))))
        end
        if v5 then
            return (CommaNumber(v5)) .. "-N/A"
        end
        if v3 then
            return "N/A-" .. CommaNumber(v3)
        end
    end
    return "N/A-N/A"
end

local function UpdateStoreHoverContent(a1) -- Line: 131
    -- upvalues: Skins (val), Rarities (val), GetSkinDisplayName (val), GetStoreHoverTextLabel (val), u55 (ref)
    -- upvalues: u56 (ref), GetStoreHoverPriceText (val), u54 (ref)
    local Parent = a1.Parent
    if not Parent then
        return false
    end
    local Attribute = Parent:GetAttribute("WeaponName")
    local Attribute_2 = Parent:GetAttribute("SkinName")
    if typeof(Attribute) == "string" and typeof(Attribute_2) == "string" then
        local u21 = Skins.GetSkinInformation(Attribute, Attribute_2)
        local v1 = Rarities[if not u21 then "Stock" else u21.rarity]
        local v2 = GetSkinDisplayName.GetWeaponDisplayName(Attribute)
        local v3 = GetSkinDisplayName.GetSkinDisplayName(Attribute_2, true)
        local u43 = GetStoreHoverTextLabel("Info", "Price", "Frame", "TextLabel")
        local u44 = u55
        local v4 = GetStoreHoverTextLabel("Info", "ItemName")
        if v4 then
            v4.Text = ("%* | %*"):format(v2, v3)
            local Color = if not v1 then Color3.fromRGB(243, 243, 243) else v1.Color
            v4.TextColor3 = Color
        end
        local v5 = GetStoreHoverTextLabel("Info", "RarityName")
        if v5 then
            local rarity
            v5.Text = string.upper(rarity)
            if v1 then
                v5.TextColor3 = v1.Color
            end
        end
        local v6 = GetStoreHoverTextLabel("Info", "Description", "TextLabel")
        if v6 then
            v6.Text = if not u21 then "" else u21.description
        end
        if u43 then
            u43.Text = u56
            task.spawn(function() -- Line: 173
                -- upvalues: GetStoreHoverPriceText (upval), Attribute (val), Attribute_2 (val), u21 (val), u54 (upval)
                -- upvalues: a1 (val), u55 (upval), u44 (val), u43 (val)
                local v1 = GetStoreHoverPriceText(Attribute, Attribute_2, u21)
                if u54 == a1 and u55 == u44 then
                    u43.Text = v1
                end
            end)
        end
        return true
    end
    warn((("[Store] %* is missing WeaponName/SkinName attributes."):format((Parent:GetFullName()))))
    return false
end

local function BindStoreHoverButton(a1) -- Line: 186
    -- upvalues: u58 (val), u52 (ref), u55 (ref), u54 (ref), UpdateStoreHoverPosition (val)
    -- upvalues: UpdateStoreHoverContent (val)
    if u58[a1] then
        return
    end
    if u52 and a1:IsDescendantOf(u52) and a1:IsA("GuiButton") then
        u58[a1] = true
        a1.MouseEnter:Connect(function() -- Line: 196
            -- upvalues: u55 (upval), u54 (upval), a1 (val), UpdateStoreHoverPosition (upval)
            -- upvalues: UpdateStoreHoverContent (upval), u52 (upval)
            u55 = u55 + 1
            u54 = a1
            UpdateStoreHoverPosition()
            if UpdateStoreHoverContent(a1) then
                local StoreHoverFrame = u52 and u52:FindFirstChild("StoreHoverFrame")
                local v1 = if not StoreHoverFrame then nil else if not StoreHoverFrame:IsA("Frame") then nil else StoreHoverFrame
                if v1 then
                    v1.Visible = true
                end
            end
        end)
        a1.MouseLeave:Connect(function() -- Line: 206 -- upvalues: u54 (upval), a1 (val), u55 (upval), u52 (upval)
            if u54 ~= a1 then
                return
            end
            u55 = u55 + 1
            u54 = nil
            local StoreHoverFrame = u52 and u52:FindFirstChild("StoreHoverFrame")
            local v1 = if not StoreHoverFrame then nil else if not StoreHoverFrame:IsA("Frame") then nil else StoreHoverFrame
            if v1 then
                v1.Visible = false
            end
        end)
        return
    end
end

local function SetupStoreHoverButtons() -- Line: 219
    -- upvalues: u52 (ref), GetStoreHoverTextLabel (val), u56 (ref), CollectionService (val), u53 (ref)
    -- upvalues: BindStoreHoverButton (val), u57 (ref), RunServiceController (val), u54 (ref)
    -- upvalues: UpdateStoreHoverPosition (val)
    local StoreHoverFrame = u52 and u52:FindFirstChild("StoreHoverFrame")
    local v1 = if not StoreHoverFrame then nil else if not StoreHoverFrame:IsA("Frame") then nil else StoreHoverFrame
    if v1 then
        local v2 = GetStoreHoverTextLabel("Info", "Price", "Frame", "TextLabel")
        u56 = v2 and v2.Text or ""
        v1.Visible = false
    end
    for i, v in ipairs(CollectionService:GetTagged(u53.STORE_HOVER_BUTTON_TAG)) do
        BindStoreHoverButton(v)
    end
    if u57 then
        return
    end
    u57 = true
    ;(CollectionService:GetInstanceAddedSignal(u53.STORE_HOVER_BUTTON_TAG)):Connect(BindStoreHoverButton)
    RunServiceController.BindToRenderStep("UI.Store.HoverFrameFollow", function() -- Line: 238 -- upvalues: u54 (upval), u52 (upval), UpdateStoreHoverPosition (upval)
        if not u54 then
            return
        end
        if u52 and u52.Visible and u54:IsDescendantOf(u52) then
            UpdateStoreHoverPosition()
            return
        end
        u54 = nil
        local StoreHoverFrame = u52 and u52:FindFirstChild("StoreHoverFrame")
        local v1 = if not StoreHoverFrame then nil else if not StoreHoverFrame:IsA("Frame") then nil else StoreHoverFrame
        if v1 then
            v1.Visible = false
        end
    end)
end

function v1.Setup(a1, a2) -- Line: 256
    -- upvalues: u52 (ref), u53 (ref), SetupStoreHoverButtons (val)
    u52 = a1
    u53 = a2
    SetupStoreHoverButtons()
end

return v1