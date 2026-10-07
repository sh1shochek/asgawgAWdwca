-- ReplicatedStorage.Components.Common.MarketplaceDropdown
-- Script path: ReplicatedStorage.Components.Common.MarketplaceDropdown
-- Decompile time: 2.54 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Signal = require(ReplicatedStorage.Packages.Signal)
local CollectionServiceUtility = require(ReplicatedStorage.Shared.CollectionServiceUtility)
local u22 = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local u27 = TweenInfo.new(0.36, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local InventoryDropdownTemplate = ReplicatedStorage.Assets.TradingUI.Templates:WaitForChild("InventoryDropdownTemplate")
local u35 = nil
local u36 = {}
u36.__index = u36

function u36.new(a1, a2, a3, a4) -- Line: 24
    -- upvalues: u36 (val), InventoryDropdownTemplate (val), Signal (val), CollectionServiceUtility (val)
    -- upvalues: TweenService (val), u27 (val), u22 (val)
    assert(#a2 > 0, "Marketplace dropdowns require at least one option")
    local v1 = a3 or {}
    local u18 = setmetatable({}, u36)
    u18.Instance = a1
    u18._config = v1
    u18._template = a4 or InventoryDropdownTemplate
    u18.OptionSelected = Signal.new()
    u18.Option = a2[1] or ""
    u18._expanded = false
    u18._expandedSize = UDim2.fromScale(1, 2)
    u18._hiddenSize = UDim2.fromScale(1, 0)
    a1.Activated:Connect(function() -- Line: 41 -- upvalues: u18 (val)
        u18:Toggle()
    end)
    u18._pointer = CollectionServiceUtility.FindDescendantWithTag(a1, "DropdownPointer")
    if u18._pointer then
        u18._pointer.Rotation = 0
    end
    a1.ClipsDescendants = false
    local Frame = Instance.new("Frame")
    Frame.Name = "Dropdown"
    local _hiddenSize = if not v1.tweenVisibility then u18._expandedSize else u18._hiddenSize
    Frame.Size = _hiddenSize
    local AnchorPoint = v1.AnchorPoint or Vector2.new(0.5, 0)
    Frame.AnchorPoint = AnchorPoint
    local Position = v1.Position or UDim2.new(0.5, 0, 1, 2)
    Frame.Position = Position
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = a1.ZIndex + 1
    Frame.Visible = false
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    if v1.VerticalAlignment then
        UIListLayout.VerticalAlignment = v1.VerticalAlignment
    end
    UIListLayout.Parent = Frame
    Frame.Parent = a1
    local v2 = CollectionServiceUtility.FindDescendantWithTag(a1, "SelectedOptionText")
    if v2 then
        v2.Text = u18.Option
    end
    u18._selectedOptionText = v2
    u18._optionInstances = {}
    u18.OptionSelected:Connect(function(a1) -- Line: 81 -- upvalues: u18 (val) -- types: a1: string
        u18:SelectOption(a1)
        u18:Hide()
    end)
    u18._expandTween = TweenService:Create(Frame, u27, {Size = u18._expandedSize})
    u18._closeTween = TweenService:Create(Frame, u22, {Size = u18._hiddenSize})
    u18._closeTween.Completed:Connect(function(a1) -- Line: 89 -- upvalues: u18 (val), Frame (val)
        if a1 == Enum.PlaybackState.Completed and not u18._expanded then
            Frame.Visible = false
        end
    end)
    u18._dropdownFrame = Frame
    u18:SetOptions(a2)
    return u18
end

function u36:SelectOption(a2) -- Line: 102 -- types: a2: string
    local v1
    self.Option = a2
    local _optionInstances = self._optionInstances
    local v2 = nil
    local v3 = nil
    local v4, v5 = self, a2
    for i, j in _optionInstances, v2, v3 do
        v1 = i ~= v5
        j.Visible = v1
    end
    if v4._selectedOptionText then
        v4._selectedOptionText.Text = v5
    end
end

function u36:SetOptions(a2) -- Line: 114 -- upvalues: CollectionServiceUtility (val) -- types: a2: table
    local v1, v2
    for i, j in self._optionInstances do
        j:Destroy()
    end
    self._optionInstances = {}
    local v3 = nil
    local v4 = nil
    for k, n in a2, v3, v4 do
        v1 = self._template:Clone()
        v1.Name = n
        v1.Size = UDim2.fromScale(1, 0.5)
        v2 = CollectionServiceUtility.FindDescendantWithTag(v1, "OptionText")
        if v2 then
            v2.Text = n
        end
        v1.Activated:Connect(function() -- Line: 130 -- upvalues: self (val), n (val)
            self.OptionSelected:Fire(n)
        end)
        self._optionInstances[n] = v1
        v1.Parent = self._dropdownFrame
    end
    self.OptionSelected:Fire(a2[1])
end

function u36:Expand() -- Line: 141 -- upvalues: u35 (ref)
    if self._expanded then
        return
    end
    self._expanded = true
    if u35 and u35 ~= self then
        u35:Hide()
    end
    u35 = self
    if self._pointer then
        self._pointer.Rotation = 180
    end
    self._dropdownFrame.Visible = true
    if not self._config.tweenVisibility then
        self._dropdownFrame.Size = self._expandedSize
        return
    end
    self._closeTween:Cancel()
    self._expandTween:Play()
end

function u36:Hide() -- Line: 168 -- upvalues: u35 (ref)
    if not self._expanded then
        return
    end
    self._expanded = false
    if u35 == self then
        u35 = nil
    end
    if self._pointer then
        self._pointer.Rotation = 0
    end
    if self._config.tweenVisibility then
        self._expandTween:Cancel()
        self._closeTween:Play()
        return
    end
    self._dropdownFrame.Size = self._hiddenSize
    self._dropdownFrame.Visible = false
end

function u36:Toggle() -- Line: 192
    if self._expanded then
        self:Hide()
        return
    end
    self:Expand()
end

return u36