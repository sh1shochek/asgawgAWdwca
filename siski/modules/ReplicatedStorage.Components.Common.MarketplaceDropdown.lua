-- ReplicatedStorage.Components.Common.MarketplaceDropdown
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Signal = require(ReplicatedStorage.Packages.Signal);
local CollectionServiceUtility = require(ReplicatedStorage.Shared.CollectionServiceUtility);
local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);
local TweenInfo_new_ret2 = TweenInfo.new(0.36, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);
local InventoryDropdownTemplate = ReplicatedStorage.Assets.TradingUI.Templates:WaitForChild("InventoryDropdownTemplate");
local u1 = nil;
local u2 = {};
u2.__index = u2;

local function findDropdownRow(p3: userdata) -- Line: 29
    while true do
        local Parent = p3.Parent;

        if not (Parent and (Parent:IsA("GuiObject") and not (Parent:IsA("ScrollingFrame") or (Parent.ClipsDescendants or Parent:FindFirstChildWhichIsA("UIGridStyleLayout") ~= nil)))) then
            break;
        end;

        p3 = Parent;
    end;

    return p3;
end;

local function getTopSiblingZIndex(p4: userdata) -- Line: 45
    local ZIndex = p4.ZIndex;

    for _, child in p4.Parent:GetChildren() do
        if child ~= p4 and child:IsA("GuiObject") then
            ZIndex = math.max(ZIndex, child.ZIndex + 1);
        end;
    end;

    return ZIndex;
end;

function u2.new(p5: userdata, p6: table, p7: table?, p8: userdata?) -- Line: 55
    -- upvalues: u2 (copy), InventoryDropdownTemplate (copy), Signal (copy), CollectionServiceUtility (copy), TweenService (copy), TweenInfo_new_ret2 (copy), TweenInfo_new_ret (copy)
    assert(#p6 > 0, "Marketplace dropdowns require at least one option");
    local v9 = p7 or {};
    local u10 = setmetatable({}, u2);
    u10.Instance = p5;
    u10._config = v9;
    u10._template = p8 or InventoryDropdownTemplate;
    u10.OptionSelected = Signal.new();
    u10.Option = p6[1] or "";
    u10._expanded = false;
    u10._expandedSize = UDim2.fromScale(1, 2);
    u10._hiddenSize = UDim2.fromScale(1, 0);
    p5.Activated:Connect(function() -- Line: 72
        -- upvalues: u10 (copy)
        u10:Toggle();
    end);
    u10._pointer = CollectionServiceUtility.FindDescendantWithTag(p5, "DropdownPointer");

    if u10._pointer then
        u10._pointer.Rotation = 0;
    end;

    p5.ClipsDescendants = false;
    local Frame = Instance.new("Frame");
    Frame.Name = "Dropdown";
    local v11;

    if v9.tweenVisibility then
        v11 = u10._hiddenSize;
    else
        v11 = u10._expandedSize;
    end;

    Frame.Size = v11;
    Frame.AnchorPoint = v9.AnchorPoint or Vector2.new(0.5, 0);
    Frame.Position = v9.Position or UDim2.new(0.5, 0, 1, 2);
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = p5.ZIndex + 1;
    Frame.Visible = false;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;

    if v9.VerticalAlignment then
        UIListLayout.VerticalAlignment = v9.VerticalAlignment;
    end;

    UIListLayout.Parent = Frame;
    Frame.Parent = p5;
    local v12 = CollectionServiceUtility.FindDescendantWithTag(p5, "SelectedOptionText");

    if v12 then
        v12.Text = u10.Option;
    end;

    u10._selectedOptionText = v12;
    u10._optionInstances = {};
    u10.OptionSelected:Connect(function(p13: string) -- Line: 112
        -- upvalues: u10 (copy)
        u10:SelectOption(p13);
        u10:Hide();
    end);
    u10._expandTween = TweenService:Create(Frame, TweenInfo_new_ret2, {
        Size = u10._expandedSize
    });
    u10._closeTween = TweenService:Create(Frame, TweenInfo_new_ret, {
        Size = u10._hiddenSize
    });
    u10._closeTween.Completed:Connect(function(p14) -- Line: 120
        -- upvalues: u10 (copy), Frame (copy)
        if p14 == Enum.PlaybackState.Completed and not u10._expanded then
            Frame.Visible = false;
            u10:_lowerRow();
        end;
    end);
    u10._dropdownFrame = Frame;
    u10:SetOptions(p6);

    return u10;
end;

function u2.SelectOption(p15: any, p16: string) -- Line: 134
    p15.Option = p16;

    for i, v in p15._optionInstances do
        v.Visible = i ~= p16;
    end;

    if p15._selectedOptionText then
        p15._selectedOptionText.Text = p16;
    end;
end;

function u2.SetOptions(u17: any, p18: table) -- Line: 146
    -- upvalues: CollectionServiceUtility (copy)
    for _, v in u17._optionInstances do
        v:Destroy();
    end;

    u17._optionInstances = {};

    for _, v in p18 do
        local v19 = u17._template:Clone();
        v19.Name = v;
        v19.Size = UDim2.fromScale(1, 0.5);
        local v20 = CollectionServiceUtility.FindDescendantWithTag(v19, "OptionText");

        if v20 then
            v20.Text = v;
        end;

        v19.Activated:Connect(function() -- Line: 162
            -- upvalues: u17 (copy), v (copy)
            u17.OptionSelected:Fire(v);
        end);
        u17._optionInstances[v] = v19;
        v19.Parent = u17._dropdownFrame;
    end;

    u17.OptionSelected:Fire(p18[1]);
end;

function u2.Expand(p21) -- Line: 173
    -- upvalues: u1 (ref)
    if p21._expanded then
        return;
    end;

    p21._expanded = true;

    if u1 and u1 ~= p21 then
        u1:Hide();
    end;

    u1 = p21;

    if p21._pointer then
        p21._pointer.Rotation = 180;
    end;

    p21:_raiseRow();
    p21._dropdownFrame.Visible = true;

    if not p21._config.tweenVisibility then
        p21._dropdownFrame.Size = p21._expandedSize;

        return;
    end;

    p21._closeTween:Cancel();
    p21._expandTween:Play();
end;

function u2.Hide(p22) -- Line: 201
    -- upvalues: u1 (ref)
    if not p22._expanded then
        return;
    end;

    p22._expanded = false;

    if u1 == p22 then
        u1 = nil;
    end;

    if p22._pointer then
        p22._pointer.Rotation = 0;
    end;

    if p22._config.tweenVisibility then
        p22._expandTween:Cancel();
        p22._closeTween:Play();

        return;
    end;

    p22._dropdownFrame.Size = p22._hiddenSize;
    p22._dropdownFrame.Visible = false;
    p22:_lowerRow();
end;

function u2._raiseRow(p23) -- Line: 227
    -- upvalues: findDropdownRow (copy), getTopSiblingZIndex (copy)
    local v24 = findDropdownRow(p23.Instance);

    if p23._raisedRow ~= v24 then
        p23:_lowerRow();
        p23._raisedRow = v24;
        p23._rowZIndex = v24.ZIndex;
    end;

    v24.ZIndex = getTopSiblingZIndex(v24);
end;

function u2._lowerRow(p25) -- Line: 237
    local _raisedRow = p25._raisedRow;

    if _raisedRow and p25._rowZIndex then
        _raisedRow.ZIndex = p25._rowZIndex;
    end;

    p25._raisedRow = nil;
    p25._rowZIndex = nil;
end;

function u2.Toggle(p26) -- Line: 246
    if p26._expanded then
        p26:Hide();

        return;
    end;

    p26:Expand();
end;

return u2;