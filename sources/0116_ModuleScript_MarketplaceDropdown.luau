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

function u2.new(p3: userdata, p4: table, p5: table?, p6: userdata?) -- Line: 24
    -- upvalues: u2 (copy), InventoryDropdownTemplate (copy), Signal (copy), CollectionServiceUtility (copy), TweenService (copy), TweenInfo_new_ret2 (copy), TweenInfo_new_ret (copy)
    assert(#p4 > 0, "Marketplace dropdowns require at least one option");
    local v7 = p5 or {};
    local u8 = setmetatable({}, u2);
    u8.Instance = p3;
    u8._config = v7;
    u8._template = p6 or InventoryDropdownTemplate;
    u8.OptionSelected = Signal.new();
    u8.Option = p4[1] or "";
    u8._expanded = false;
    u8._expandedSize = UDim2.fromScale(1, 2);
    u8._hiddenSize = UDim2.fromScale(1, 0);
    p3.Activated:Connect(function() -- Line: 41
        -- upvalues: u8 (copy)
        u8:Toggle();
    end);
    u8._pointer = CollectionServiceUtility.FindDescendantWithTag(p3, "DropdownPointer");

    if u8._pointer then
        u8._pointer.Rotation = 0;
    end;

    p3.ClipsDescendants = false;
    local Frame = Instance.new("Frame");
    Frame.Name = "Dropdown";
    local v9;

    if v7.tweenVisibility then
        v9 = u8._hiddenSize;
    else
        v9 = u8._expandedSize;
    end;

    Frame.Size = v9;
    Frame.AnchorPoint = v7.AnchorPoint or Vector2.new(0.5, 0);
    Frame.Position = v7.Position or UDim2.new(0.5, 0, 1, 2);
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = p3.ZIndex + 1;
    Frame.Visible = false;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;

    if v7.VerticalAlignment then
        UIListLayout.VerticalAlignment = v7.VerticalAlignment;
    end;

    UIListLayout.Parent = Frame;
    Frame.Parent = p3;
    local v10 = CollectionServiceUtility.FindDescendantWithTag(p3, "SelectedOptionText");

    if v10 then
        v10.Text = u8.Option;
    end;

    u8._selectedOptionText = v10;
    u8._optionInstances = {};
    u8.OptionSelected:Connect(function(p11: string) -- Line: 81
        -- upvalues: u8 (copy)
        u8:SelectOption(p11);
        u8:Hide();
    end);
    u8._expandTween = TweenService:Create(Frame, TweenInfo_new_ret2, {
        Size = u8._expandedSize
    });
    u8._closeTween = TweenService:Create(Frame, TweenInfo_new_ret, {
        Size = u8._hiddenSize
    });
    u8._closeTween.Completed:Connect(function(p12) -- Line: 89
        -- upvalues: u8 (copy), Frame (copy)
        if p12 == Enum.PlaybackState.Completed and not u8._expanded then
            Frame.Visible = false;
        end;
    end);
    u8._dropdownFrame = Frame;
    u8:SetOptions(p4);

    return u8;
end;

function u2.SelectOption(p13: any, p14: string) -- Line: 102
    p13.Option = p14;

    for i, v in p13._optionInstances do
        v.Visible = i ~= p14;
    end;

    if p13._selectedOptionText then
        p13._selectedOptionText.Text = p14;
    end;
end;

function u2.SetOptions(u15: any, p16: table) -- Line: 114
    -- upvalues: CollectionServiceUtility (copy)
    for _, v in u15._optionInstances do
        v:Destroy();
    end;

    u15._optionInstances = {};

    for _, v in p16 do
        local v17 = u15._template:Clone();
        v17.Name = v;
        v17.Size = UDim2.fromScale(1, 0.5);
        local v18 = CollectionServiceUtility.FindDescendantWithTag(v17, "OptionText");

        if v18 then
            v18.Text = v;
        end;

        v17.Activated:Connect(function() -- Line: 130
            -- upvalues: u15 (copy), v (copy)
            u15.OptionSelected:Fire(v);
        end);
        u15._optionInstances[v] = v17;
        v17.Parent = u15._dropdownFrame;
    end;

    u15.OptionSelected:Fire(p16[1]);
end;

function u2.Expand(p19) -- Line: 141
    -- upvalues: u1 (ref)
    if p19._expanded then
        return;
    end;

    p19._expanded = true;

    if u1 and u1 ~= p19 then
        u1:Hide();
    end;

    u1 = p19;

    if p19._pointer then
        p19._pointer.Rotation = 180;
    end;

    p19._dropdownFrame.Visible = true;

    if not p19._config.tweenVisibility then
        p19._dropdownFrame.Size = p19._expandedSize;

        return;
    end;

    p19._closeTween:Cancel();
    p19._expandTween:Play();
end;

function u2.Hide(p20) -- Line: 168
    -- upvalues: u1 (ref)
    if not p20._expanded then
        return;
    end;

    p20._expanded = false;

    if u1 == p20 then
        u1 = nil;
    end;

    if p20._pointer then
        p20._pointer.Rotation = 0;
    end;

    if p20._config.tweenVisibility then
        p20._expandTween:Cancel();
        p20._closeTween:Play();

        return;
    end;

    p20._dropdownFrame.Size = p20._hiddenSize;
    p20._dropdownFrame.Visible = false;
end;

function u2.Toggle(p21) -- Line: 192
    if p21._expanded then
        p21:Hide();

        return;
    end;

    p21:Expand();
end;

return u2;