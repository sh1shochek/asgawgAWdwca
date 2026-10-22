-- ReplicatedStorage.GameClient.Gui.MainMenu.Utils.Tabs
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.Utils.Tabs
-- Decompile time: 14.77 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local TweenService = game:GetService("TweenService");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local TweenInfo_new_ret = TweenInfo.new(0.25);
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(131, 216, 255);
local u7 = {};

function u1.CreateTab(p8: table, p9: userdata) -- Line: 26
    -- upvalues: u1 (copy), u7 (copy)
    local v10 = setmetatable({}, u1);
    v10.CurrentTab = nil;
    v10.CurrentTabUnder = nil;
    v10.UnderActivate = {};
    v10.Pages = {};
    v10.Hold = p9;
    local v11, v12, v13 = u1.new();
    v10.TabUI = v11;
    v10.HolderUI = v12;
    v10.TopHolder = v13;
    v10.TabUI.Parent = p9;
    v10.HolderUI.Parent = p9;
    table.insert(u7, v10);

    return v10;
end;

function u1.CreatePage(u14: table, p15: string, p16: number, u17: boolean, u18: boolean, p19: userdata, p20: boolean, u21: any, p22: userdata?) -- Line: 47
    -- upvalues: u1 (copy), u6 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    local u23 = nil;
    local u24;

    if u17 then
        u24 = nil;
    else
        u24 = p22 or u1.page();

        if not p22 then
            u24.Parent = u14.HolderUI;
        end;
    end;

    local u25 = u1.button();

    if p20 then
        local v26 = u1.icon();
        u25.Size = u6 and UDim2.new(0, 75, 1, 0) or UDim2.new(-0.043, 120, 1, 0);
        u25.TabText.Text = "";
        v26.Parent = u25;
    else
        u25.TabText.Text = p15:upper();
        local v27;

        if u6 then
            local UDim2_new = UDim2.new;
            local v28 = string.len(p15) * 8 + 18;
            v27 = UDim2_new(0, math.max(60, v28), 1, 0) or UDim2.new(0, string.len(p15) * 10 + 25, 1, 0);
        else
            v27 = UDim2.new(0, string.len(p15) * 10 + 25, 1, 0);
        end;

        u25.Size = v27;
    end;

    u25.LayoutOrder = p16 or 0;

    if not u18 then
        u25.Parent = u14.TopHolder;
    end;

    if u17 then
        u23 = u1.under();
        u23.Parent = u14.Hold;
        u14.UnderActivate[u23] = nil;
    end;

    if u18 then
        u25.Parent = p19;
        local Parent = u25.Parent.Parent;

        if not u14.UnderActivate[Parent] then
            u14.UnderActivate[Parent] = {
                u25,
                u24,
                u17,
                u23,
                u18,
                u21
            };
        end;
    end;

    u14.Pages[p15] = {
        Button = u25,
        Page = u24,
        IsUnderHold = u17,
        UnderUI = u23,
        HasUnderHold = u18,
        callback = u21
    };
    u25.MouseEnter:Connect(function() -- Line: 114
        -- upvalues: u14 (copy), u24 (ref), u25 (copy), u23 (ref), TweenService (ref), TweenInfo_new_ret (ref)
        if u14.CurrentTab == u24 and u14.ActiveButton == u25 or (u14.CurrentTab == u23 or u14.CurrentTabUnder == u24 and u24 ~= nil) then
            return;
        end;

        if u25:GetAttribute("CustomStyle") == "GoldIridescent" then
            TweenService:Create(u25, TweenInfo_new_ret, {
                BackgroundTransparency = 0.55
            }):Play();

            return;
        end;

        TweenService:Create(u25, TweenInfo_new_ret, {
            BackgroundTransparency = 0.9
        }):Play();
    end);
    u25.MouseLeave:Connect(function() -- Line: 127
        -- upvalues: u14 (copy), u24 (ref), u25 (copy), u23 (ref), TweenService (ref), TweenInfo_new_ret (ref)
        if u14.CurrentTab == u24 and u14.ActiveButton == u25 or (u14.CurrentTab == u23 or u14.CurrentTabUnder == u24 and u24 ~= nil) then
            return;
        end;

        if u25:GetAttribute("CustomStyle") == "GoldIridescent" then
            TweenService:Create(u25, TweenInfo_new_ret, {
                BackgroundTransparency = 0.8
            }):Play();

            return;
        end;

        TweenService:Create(u25, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        }):Play();
    end);
    u25.MouseButton1Click:Connect(function() -- Line: 141
        -- upvalues: u14 (copy), u24 (ref), u25 (copy), u23 (ref), u17 (copy), u18 (copy), u21 (copy)
        if u14.CurrentTab == u24 and u14.ActiveButton == u25 or u14.CurrentTab == u23 then
            return;
        end;

        u14:ActivateTab(u25, u24, u17, u23, u18, u21);

        if u17 and u14.UnderActivate[u23] then
            u14:ActivateTab(unpack(u14.UnderActivate[u23]));
        end;

        if u18 then
            u14.UnderActivate[u25.Parent.Parent] = {
                u25,
                u24,
                u17,
                u23,
                u18,
                u21
            };
        end;
    end);

    if not u14.CurrentTab then
        u14:ActivateTab(u25, u24, u17, u23, u18, u21);
    end;

    if u14.CurrentTab == u25.Parent.Parent and not u14.CurrentTabUnder then
        u14.UnderActivate[u25.Parent.Parent] = {
            u25,
            u24,
            u17,
            u23,
            u18,
            u21
        };
        u14:ActivateTab(unpack(u14.UnderActivate[u25.Parent.Parent]));
    end;

    if u17 == true then
        return u23.UnderHolder;
    end;

    if not (u17 or u18) then
        return u24;
    end;

    if u18 then
        return u24;
    end;
end;

function u1.ActivateTab(p29, p30, p31, p32, p33, p34, p35) -- Line: 183
    -- upvalues: u2 (ref), u4 (ref), TweenService (copy), TweenInfo_new_ret (copy), Color3_fromRGB_ret2 (copy)
    local v36 = p32 and p33 and p33 or p31;
    local v37 = p30.Parent.Parent ~= p29.CurrentTab;

    if p29.CurrentTab == v36 and p29.ActiveButton == p30 or p29.CurrentTabUnder == v36 then
        return;
    end;

    if p29.CurrentTab and v37 then
        p29:DeactivateTab(false);

        if p29.CurrentTabUnder then
            p29:DeactivateTab(true);
            p29.CurrentTabUnder = nil;
            p29.ActiveUnder = nil;
        end;
    end;

    if p29.CurrentTabUnder and p34 then
        p29:DeactivateTab(true);
    end;

    if p29.CurrentTabUnder then
        p29.CurrentTabUnder.Visible = p32;
    end;

    if v37 then
        p29.ActiveButton = p30;
        p29.CurrentTab = v36;
    else
        p29.ActiveUnder = p30;
        p29.CurrentTabUnder = v36;
    end;

    if p29.Hold.Name == "Inventory" then
        if v37 and not (p32 or p34) then
            u2.Handler:SetAttribute("CurrentTab", p30.TabText.Text);
        elseif p29.ActiveUnder and (not v37 or p32 and (not p34 and p29.ActiveUnder.Parent.Parent == p33)) then
            local Text = p29.ActiveUnder.TabText.Text;

            if Text:lower():find("all", 1, true) then
                u2.Handler:SetAttribute("CurrentTab", p29.ActiveButton.TabText.Text .. " " .. Text);
            else
                u2.Handler:SetAttribute("CurrentTab", Text);
            end;
        end;

        if p30.TabText.Text == "FUSER" then
            u4.DropDeactive("GLOBAL");
        end;
    else
        u4.DropDeactive("GLOBAL");
    end;

    if p35 then
        p35();
    end;

    if p30:GetAttribute("CustomStyle") == "GoldIridescent" then
        TweenService:Create(p30, TweenInfo_new_ret, {
            BackgroundTransparency = 0.35
        }):Play();
        TweenService:Create(p30.TabText, TweenInfo_new_ret, {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play();
    else
        TweenService:Create(p30, TweenInfo_new_ret, {
            BackgroundTransparency = 0.5,
            BackgroundColor3 = Color3_fromRGB_ret2
        }):Play();
        TweenService:Create(p30.TabText, TweenInfo_new_ret, {
            TextColor3 = Color3_fromRGB_ret2
        }):Play();
    end;

    v36.Visible = true;
end;

function u1.DeactivateTab(p38: table, p39: boolean) -- Line: 268
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy), Color3_fromRGB_ret (copy)
    local v40 = p39 and p38.ActiveUnder or p38.ActiveButton;
    local v41 = p39 and p38.CurrentTabUnder or p38.CurrentTab;

    if not (v40 and v41) then
        return;
    end;

    if v40:GetAttribute("CustomStyle") == "GoldIridescent" then
        TweenService:Create(v40, TweenInfo_new_ret, {
            BackgroundTransparency = 0.8
        }):Play();
        TweenService:Create(v40.TabText, TweenInfo_new_ret, {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play();
    else
        TweenService:Create(v40, TweenInfo_new_ret, {
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3_fromRGB_ret
        }):Play();
        TweenService:Create(v40.TabText, TweenInfo_new_ret, {
            TextColor3 = Color3_fromRGB_ret
        }):Play();
    end;

    v41.Visible = false;
end;

function u1.OpenTab(p42: table, p43: userdata) -- Line: 289
    local v44 = p42.Pages[p43];

    if not v44 then
        return;
    end;

    p42:ActivateTab(v44.Button, v44.Page, v44.IsUnderHold, v44.UnderUI, v44.HasUnderHold, v44.callback);

    if v44.IsUnderHold and (v44.UnderUI and p42.UnderActivate[v44.UnderUI]) then
        p42:ActivateTab(unpack(p42.UnderActivate[v44.UnderUI]));
    end;
end;

function u1.Find(p45: userdata) -- Line: 303
    -- upvalues: u7 (copy)
    for _, v in u7 do
        if v.Hold == p45 then
            return v;
        end;
    end;

    return nil;
end;

function u1.Locate(p46: userdata) -- Line: 313
    -- upvalues: u7 (copy)
    local v47 = nil;

    for _, v in u7 do
        if p46:IsDescendantOf(v.TopHolder) then
            return v, v.TopHolder, v.ActiveButton;
        end;

        if v.CurrentTab and (v.CurrentTab.Name == "PageUnder" and p46:IsDescendantOf(v.CurrentTab)) then
            return v, v.CurrentTab, v.ActiveUnder;
        end;

        if p46:IsDescendantOf(v.Hold) and (not v47 or v.Hold:IsDescendantOf(v47.Hold)) then
            v47 = v;
        end;
    end;

    return v47, nil, nil;
end;

function u1.Cycle(p48: table, p49: number) -- Line: 333
    local v50 = {};

    for _, child in p48.TopHolder:GetChildren() do
        if child:IsA("GuiButton") and child.Visible then
            table.insert(v50, child);
        end;
    end;

    if #v50 < 2 then
        return false;
    end;

    table.sort(v50, function(p51, p52) -- Line: 346
        return p51.AbsolutePosition.X < p52.AbsolutePosition.X;
    end);
    local v53 = v50[((table.find(v50, p48.ActiveButton) or 1) + p49 - 1) % #v50 + 1];

    for i, v in p48.Pages do
        if v.Button == v53 then
            p48:OpenTab(i);

            return true;
        end;
    end;

    return false;
end;

function u1.Init(p54) -- Line: 363
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref)
    u2 = p54:GetModule("Gui");
    u3 = p54:GetModule("Maid");
    u4 = p54:GetModule("Settings");
    u5 = p54:GetModule("GetUserPlatform");
    u6 = u5() == "Mobile";
end;

function u1.new() -- Line: 371
    -- upvalues: u6 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Page";
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(-1.27289e-7, 0);
    Frame.Size = u6 and UDim2.fromScale(1, 0.072) or UDim2.fromScale(1, 0.058);
    Frame.ZIndex = 2;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Line";
    Frame2.AnchorPoint = Vector2.new(0, 1);
    Frame2.BackgroundColor3 = Color3.fromRGB(160, 160, 163);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(-1.36239e-7, 0);
    Frame2.Size = UDim2.new(1, 0, 0, 2);
    Frame2.ZIndex = 5;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "TopHolder";
    Frame3.BackgroundTransparency = 1;
    Frame3.Size = UDim2.fromScale(1, 1);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "PaddingTop";
    UIPadding.PaddingBottom = UDim.new(0.2, 0);
    UIPadding.PaddingLeft = UDim.new(0.01, 0);
    UIPadding.PaddingRight = UDim.new(0.01, 0);
    UIPadding.PaddingTop = UDim.new(0.2, 0);
    UIPadding.Parent = Frame3;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "ListTopHolder";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = u6 and UDim.new(0.016, 0) or UDim.new(0.008, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame3;
    Frame3.Parent = Frame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "PageHolder";
    Frame4.BackgroundTransparency = 1;
    Frame4.Size = UDim2.fromScale(1, 1);

    return Frame, Frame4, Frame3;
end;

function u1.under() -- Line: 424
    -- upvalues: u6 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "PageUnder";
    Frame.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    Frame.BackgroundTransparency = 0.1;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = u6 and UDim2.fromScale(-1.27289e-7, 0.072) or UDim2.fromScale(-1.27289e-7, 0.058);
    Frame.Size = u6 and UDim2.fromScale(1, 0.072) or UDim2.fromScale(1, 0.058);
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "UnderHolder";
    Frame2.BackgroundTransparency = 1;
    Frame2.Size = UDim2.fromScale(1, 1);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "PaddingHolder";
    UIPadding.PaddingBottom = UDim.new(0.2, 0);
    UIPadding.PaddingLeft = UDim.new(0.01, 0);
    UIPadding.PaddingRight = UDim.new(0.01, 0);
    UIPadding.PaddingTop = UDim.new(0.2, 0);
    UIPadding.Parent = Frame2;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "LayoutHodler";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = u6 and UDim.new(0.016, 0) or UDim.new(0.008, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame2;
    Frame2.Parent = Frame;

    return Frame;
end;

function u1.page() -- Line: 462
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "Tab";
    ScrollingFrame.Active = true;
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.ScrollBarThickness = 8;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.Size = UDim2.fromScale(1, 1);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.Visible = false;

    return ScrollingFrame;
end;

function u1.button() -- Line: 479
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "TabButton";
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.LayoutOrder = 1;
    ImageButton.Size = UDim2.new(0, 120, 1, 0);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "TabCorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TabText";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(1, 0.75);
    TextLabel.Text = "NULL-CATEGORY";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.Parent = ImageButton;

    return ImageButton;
end;

function u1.icon() -- Line: 511
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://136926548005524";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.8, 0.8);

    return ImageLabel;
end;

return u1;