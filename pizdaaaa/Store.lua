-- ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Store
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Store
-- Decompile time: 99.47 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local PolicyService = game:GetService("PolicyService");
local MarketplaceService = game:GetService("MarketplaceService");
local RunService = game:GetService("RunService");
local GuiService = game:GetService("GuiService");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = {};
local LocalPlayer = Players.LocalPlayer;

local function HasRobloxSubscription() -- Line: 27
    -- upvalues: RunService (copy), LocalPlayer (copy)
    return RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription;
end;

local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = nil;
local u27 = nil;
local u28 = nil;

if RunService:IsStudio() then
    u13 = {
        AllowedExternalLinkReferences = {},
        AreAdsAllowed = true,
        ArePaidRandomItemsRestricted = false,
        IsContentSharingAllowed = true,
        IsEligibleToPurchaseCommerceProduct = true,
        IsEligibleToPurchaseSubscription = true,
        IsPaidItemTradingAllowed = true,
        IsPhotoToAvatarAllowed = true,
        IsSubjectToChinaPolicies = true
    };
else
    task.spawn(function() -- Line: 60
        -- upvalues: PolicyService (copy), LocalPlayer (copy), u13 (ref)
        local success, result = pcall(function() -- Line: 61
            -- upvalues: PolicyService (ref), LocalPlayer (ref)
            return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer);
        end);
        u13 = success and result and result or {
            AllowedExternalLinkReferences = {},
            AreAdsAllowed = false,
            ArePaidRandomItemsRestricted = true,
            IsContentSharingAllowed = false,
            IsEligibleToPurchaseCommerceProduct = false,
            IsEligibleToPurchaseSubscription = false,
            IsPaidItemTradingAllowed = false,
            IsPhotoToAvatarAllowed = false,
            IsSubjectToChinaPolicies = false
        };
    end);
end;

local function GetPolicyInfo() -- Line: 80
    -- upvalues: u13 (ref)
    while not u13 do
        task.wait();
    end;

    return u13;
end;

local function FadeAway(p29) -- Line: 94
    -- upvalues: TweenService (copy)
    if not p29 then
        return;
    end;

    local function FadeElement(p30) -- Line: 97
        -- upvalues: TweenService (ref)
        if p30:IsA("TextButton") or p30:IsA("TextLabel") then
            TweenService:Create(p30, TweenInfo.new(0.5), {
                TextTransparency = 1,
                BackgroundTransparency = 1,
                TextStrokeTransparency = 1
            }):Play();

            return;
        end;

        if p30:IsA("ImageButton") or p30:IsA("ImageLabel") then
            TweenService:Create(p30, TweenInfo.new(0.5), {
                ImageTransparency = 1,
                BackgroundTransparency = 1
            }):Play();

            return;
        end;

        if p30:IsA("Frame") then
            TweenService:Create(p30, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play();

            return;
        end;

        if p30:IsA("UIStroke") then
            TweenService:Create(p30, TweenInfo.new(0.5), {
                Transparency = 1
            }):Play();
        end;
    end;

    FadeElement(p29);

    for _, descendant in p29:GetDescendants() do
        FadeElement(descendant);
    end;
end;

local function FadeIn(p31, p32) -- Line: 115
    -- upvalues: TweenService (copy)
    local TweenInfo_new_ret = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, p32);

    local function v35(p33) -- Line: 118
        -- upvalues: TweenService (ref), TweenInfo_new_ret (copy)
        local v34;

        if p33:IsA("TextButton") or p33:IsA("TextLabel") then
            v34 = {
                TextTransparency = p33.TextTransparency,
                BackgroundTransparency = p33.BackgroundTransparency,
                TextStrokeTransparency = p33.TextStrokeTransparency
            };
        elseif p33:IsA("ImageButton") or p33:IsA("ImageLabel") then
            v34 = {
                ImageTransparency = p33.ImageTransparency,
                BackgroundTransparency = p33.BackgroundTransparency
            };
        elseif p33:IsA("Frame") then
            v34 = {
                BackgroundTransparency = p33.BackgroundTransparency
            };
        elseif p33:IsA("CanvasGroup") then
            v34 = {
                GroupTransparency = p33.GroupTransparency
            };
        else
            if not p33:IsA("UIStroke") then
                return;
            end;

            v34 = {
                Transparency = p33.Transparency
            };
        end;

        for i in v34 do
            p33[i] = 1;
        end;

        TweenService:Create(p33, TweenInfo_new_ret, v34):Play();
    end;

    v35(p31);

    for _, descendant in p31:GetDescendants() do
        v35(descendant);
    end;
end;

function u1.HasContent(p36: userdata) -- Line: 152
    if not p36 then
        return false;
    end;

    if p36:FindFirstChild("Home") then
        return true;
    end;

    local Credits = p36:FindFirstChild("Credits");

    if Credits then
        for _, child in Credits:GetChildren() do
            if child:IsA("Frame") and child.Name ~= "Null" then
                return true;
            end;
        end;

        return false;
    end;

    for _, child in p36:GetChildren() do
        if child:IsA("TextButton") then
            return true;
        end;

        if child:IsA("Frame") and child.Name ~= "Null" then
            return true;
        end;
    end;

    return false;
end;

function u1.UpdateNullUI() -- Line: 183
    -- upvalues: u10 (ref), u9 (ref), u1 (copy)
    if not (u10 and u9) then
        return;
    end;

    local v37 = nil;

    if u9.CurrentTabUnder and (u9.CurrentTabUnder:IsA("GuiObject") and u9.CurrentTabUnder.Visible) then
        v37 = u9.CurrentTabUnder;
    elseif u9.CurrentTab and (u9.CurrentTab:IsA("GuiObject") and (u9.CurrentTab.Visible and u9.CurrentTab.Parent == u9.HolderUI)) then
        v37 = u9.CurrentTab;
    else
        for _, child in ipairs(u9.HolderUI:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                v37 = child;
                break;
            end;
        end;
    end;

    if not v37 then
        u10.Visible = false;

        return;
    end;

    if u1.HasContent(v37) then
        u10.Visible = false;

        return;
    end;

    u10.MainText.Text = "Not added yet. Coming soon with updates.";
    u10.Visible = true;
end;

local u38 = false;
local u39 = {};

local function OnStoreFrame(u40) -- Line: 223
    -- upvalues: u39 (copy)
    u39[u40] = true;

    return {
        Disconnect = function() -- Line: 227, Name: Disconnect
            -- upvalues: u39 (ref), u40 (copy)
            u39[u40] = nil;
        end
    };
end;

local function IsVisibleOnScreen(p41: userdata?) -- Line: 233
    if not p41 then
        return false;
    end;

    while p41 and p41:IsA("GuiObject") do
        if not p41.Visible then
            return false;
        end;

        p41 = p41.Parent;
    end;

    return true;
end;

local function IsVisibleInStore(p42: userdata) -- Line: 245
    -- upvalues: u11 (ref)
    while p42 and (p42 ~= u11 and p42:IsA("GuiObject")) do
        if not p42.Visible then
            return false;
        end;

        p42 = p42.Parent;
    end;

    return true;
end;

function u1.StyleKreditsTab(p43: userdata) -- Line: 256
    p43:SetAttribute("CustomStyle", "GoldIridescent");
    p43.AutoButtonColor = false;
    p43.BackgroundColor3 = Color3.fromRGB(120, 95, 45);
    p43.BackgroundTransparency = 0.8;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.fromRGB(255, 210, 120);
    UIStroke.Transparency = 0.55;
    UIStroke.Parent = p43;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 228, 160)), ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 180, 90)) });
    UIGradient.Rotation = 90;
    UIGradient.Parent = p43.TabText;
end;

function u1.AnimateCard(u44: userdata, u45: boolean, u46: number?) -- Line: 279
    -- upvalues: TweenService (copy), u15 (ref), GuiService (copy), IsVisibleInStore (copy), u39 (copy)
    local Icon = u44.Icon;
    local Color = u44.CanvasGroup.Color;

    if u45 then
        u45 = u44.CanvasGroup.Shine.UIGradient;
    end;

    local UIShadow = u44.Blur.Color.UIShadow;
    local Size = Icon.Size;
    local TweenInfo_new_ret = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
    local u47 = {
        {
            Icon,
            {
                Size = UDim2.fromScale(Size.X.Scale * 1.08, Size.Y.Scale * 1.08)
            },
            {
                Size = Size
            }
        },
        {
            Color,
            {
                BackgroundTransparency = 0
            },
            {
                BackgroundTransparency = Color.BackgroundTransparency
            }
        },
        {
            u44.UIStroke,
            {
                Transparency = 0
            },
            {
                Transparency = u44.UIStroke.Transparency
            }
        },
        {
            UIShadow,
            {
                Transparency = 0.15
            },
            {
                Transparency = UIShadow.Transparency
            }
        }
    };
    local u48 = false;
    local os_clock_ret = os.clock();

    local function Shimmer() -- Line: 298
        -- upvalues: os_clock_ret (ref), u45 (copy), TweenService (ref)
        os_clock_ret = os.clock();

        if not u45 then
            return;
        end;

        u45.Offset = Vector2.new(-1, 0);
        TweenService:Create(u45, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Offset = Vector2.new(1, 0)
        }):Play();
    end;

    local function SetHovered(p49: boolean) -- Line: 309
        -- upvalues: u48 (ref), u15 (ref), Shimmer (copy), u47 (copy), TweenService (ref), TweenInfo_new_ret (copy)
        if p49 == u48 then
            return;
        end;

        u48 = p49;

        if p49 then
            u15.Play("UI.mainmenu_rollover");
            Shimmer();
        end;

        for _, v in u47 do
            TweenService:Create(v[1], TweenInfo_new_ret, p49 and v[2] or v[3]):Play();
        end;
    end;

    u44.MouseEnter:Connect(function() -- Line: 327
        -- upvalues: SetHovered (copy)
        SetHovered(true);
    end);
    u44.MouseLeave:Connect(function() -- Line: 331
        -- upvalues: SetHovered (copy)
        SetHovered(false);
    end);

    for _, descendant in u44:GetDescendants() do
        if descendant:IsA("GuiButton") then
            descendant.SelectionGained:Connect(function() -- Line: 340
                -- upvalues: SetHovered (copy)
                SetHovered(true);
            end);
            descendant.SelectionLost:Connect(function() -- Line: 344
                -- upvalues: GuiService (ref), SetHovered (copy), u44 (copy)
                task.defer(function() -- Line: 345
                    -- upvalues: GuiService (ref), SetHovered (ref), u44 (ref)
                    local SelectedObject = GuiService.SelectedObject;
                    local v50;

                    if SelectedObject == nil then
                        v50 = false;
                    else
                        v50 = SelectedObject:IsDescendantOf(u44);
                    end;

                    SetHovered(v50);
                end);
            end);
        end;
    end;

    if u46 then
        local function u51() -- Line: 354
            -- upvalues: os_clock_ret (ref), u46 (copy), IsVisibleInStore (ref), u44 (copy), Shimmer (copy)
            if u46 <= os.clock() - os_clock_ret and IsVisibleInStore(u44) then
                Shimmer();
            end;
        end;

        u39[u51] = true;

        ({}).Disconnect = function() -- Line: 227, Name: Disconnect
            -- upvalues: u39 (ref), u51 (copy)
            u39[u51] = nil;
        end;
    end;
end;

function u1.AnimateFeatured(u52: userdata) -- Line: 362
    -- upvalues: IsVisibleInStore (copy), u39 (copy)
    local Icon = u52.Icon;
    local UIGradient = u52.UIStroke.UIGradient;
    local UIGradient2 = u52.Amount.UIGradient;
    local Position = Icon.Position;

    local function u53() -- Line: 368
        -- upvalues: IsVisibleInStore (ref), u52 (copy), Icon (copy), Position (copy), UIGradient (copy), UIGradient2 (copy)
        if not IsVisibleInStore(u52) then
            return;
        end;

        local os_clock_ret = os.clock();
        Icon.Position = Position + UDim2.fromScale(0, math.sin(os_clock_ret * 1.6) * 0.01);
        UIGradient.Rotation = os_clock_ret * 30 % 360;
        UIGradient2.Offset = Vector2.new(math.sin(os_clock_ret * 1.2) * 0.3, 0);
    end;

    u39[u53] = true;

    ({}).Disconnect = function() -- Line: 227, Name: Disconnect
        -- upvalues: u39 (ref), u53 (copy)
        u39[u53] = nil;
    end;
end;

function u1.Draw() -- Line: 381
    -- upvalues: u1 (copy), u9 (ref), u26 (ref), u11 (ref), u12 (copy), u13 (ref), u6 (ref), u25 (ref), u8 (ref)
    local function OnHomeSection(u54) -- Line: 384
        -- upvalues: u1 (ref)
        return function() -- Line: 385
            -- upvalues: u1 (ref), u54 (copy)
            u1.UpdateNullUI();
            u1.ScrollHome(u54);
        end;
    end;

    u9 = u26:CreateTab(u11);
    local u55 = "Home";
    local v56 = u9:CreatePage("Home", 1, false, false, nil, false, function() -- Line: 385
        -- upvalues: u1 (ref), u55 (copy)
        u1.UpdateNullUI();
        u1.ScrollHome(u55);
    end);
    u12.Home = u1.homeTab(v56);
    local u57 = "Containers";
    u9:CreatePage("Containers", 2, false, false, nil, false, function() -- Line: 385
        -- upvalues: u1 (ref), u57 (copy)
        u1.UpdateNullUI();
        u1.ScrollHome(u57);
    end, v56);
    u12.Containers = u1.homeSection(u12.Home, "Containers", "CONTAINERS", 5, 0.8);
    local u58 = "Gamepasses";
    u9:CreatePage("Gamepasses", 3, false, false, nil, false, function() -- Line: 385
        -- upvalues: u1 (ref), u58 (copy)
        u1.UpdateNullUI();
        u1.ScrollHome(u58);
    end, v56);
    u12.Gamepasses = u1.homeSection(u12.Home, "Gamepasses", "GAMEPASSES", 4, 0.8);
    local v59 = {
        {
            Header = 0.1,
            Rows = 0,
            Row = 0.42,
            Section = u12.Containers.Parent
        },
        {
            Header = 0.1,
            Rows = 0,
            Row = 0.42,
            Section = u12.Gamepasses.Parent
        }
    };

    while not u13 do
        task.wait();
    end;

    if not u13.ArePaidRandomItemsRestricted then
        local u60 = "Kredits";
        u9:CreatePage("Kredits", 4, false, false, nil, false, function() -- Line: 385
            -- upvalues: u1 (ref), u60 (copy)
            u1.UpdateNullUI();
            u1.ScrollHome(u60);
        end, v56);
        u12.Credits = u1.creditsTab(u1.homeSection(u12.Home, "Kredits", "KREDITS"));
        table.insert(v59, {
            Header = 0.1,
            Content = 0.82,
            Section = u12.Credits.Parent.Parent
        });
        u1.StyleKreditsTab(u9.Pages.Kredits.Button);
    end;

    for _, child in u9.HolderUI:GetChildren() do
        if child:IsA("GuiObject") then
            child:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 418
                -- upvalues: child (copy), u1 (ref)
                if child.Visible then
                    u1.UpdateNullUI();
                end;
            end);
        end;
    end;

    u1.CreditsLabel(u9.TabUI);
    u1.DrawHome();
    local v61 = 0;

    for i, v in u6.GetItems("Containers") do
        if v.Available then
            local v62 = v.Gamepasses and v.Gamepasses[1];

            if v.Gamepasses and u25 then
                u25.Preload(v.Gamepasses);
            end;

            u1.CreateItem(u12.Containers, i, v.Price, v.RobuxPrice, v.Thumbnail, v.Color, true, v.New, v62);
            v61 = v61 + 1;
        end;
    end;

    v59[1].Rows = math.ceil(v61 / 5);

    while not u13 do
        task.wait();
    end;

    if not u13.ArePaidRandomItemsRestricted then
        for i, v in u8 do
            u1.CreditsFrame(u12.Credits, v, i);
        end;
    end;

    u1.DrawHomeScroll(v59);
    u1.DrawGamepasses();
    local v63 = v59[2];
    local v64 = (#u12.Gamepasses:GetChildren() - 1) / 4;
    v63.Rows = math.ceil(v64);
    u1.DrawHomeScroll(v59);
    u1.UpdateNullUI();
end;

local function FetchProductInfo(p65) -- Line: 474
    -- upvalues: MarketplaceService (copy)
    local u66 = #p65;

    if u66 == 0 then
        return;
    end;

    for _, v in p65 do
        task.spawn(function() -- Line: 482
            -- upvalues: MarketplaceService (ref), v (copy), u66 (ref)
            local success, success = pcall(MarketplaceService.GetProductInfoAsync, MarketplaceService, v.GamepassId, v.CategoryName == "DevProducts" and Enum.InfoType.Product or Enum.InfoType.GamePass);

            if success then
                if success then
                    success = success.IsForSale;
                end;
            end;

            v.ForSale = success == true;
            u66 = u66 - 1;
        end);
    end;

    local v67 = os.clock() + 15;

    while u66 > 0 and os.clock() < v67 do
        task.wait();
    end;
end;

local u68 = {};

local function Owns(p69) -- Line: 504
    -- upvalues: u27 (ref)
    if not p69 or p69.Items then
        return false;
    end;

    local v70 = u27[p69.Name];

    if not v70 then
        if p69.Name == "3x Open" then
            v70 = u27["5x Open"];
        else
            v70 = false;
        end;
    end;

    return v70;
end;

local function DrawGamepassPrices(p71, p72, u73, p74) -- Line: 511
    -- upvalues: u20 (ref), u27 (ref), RunService (copy), LocalPlayer (copy), u21 (ref), u4 (ref), u24 (ref), u18 (ref)
    local u75 = p74.Upgrade and u20.Gamepasses[p74.Upgrade];

    if u75 and u27[u20.Gamepasses[u75.Requires].Name] then
        u73 = p74.Upgrade;
        p72.Parent.Tag.Visible = true;
    else
        u75 = p74;
    end;

    local Credits = u75.Credits;

    if Credits then
        local u76;

        if RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription then
            u76 = math.floor(Credits * 0.9) or Credits;
        else
            u76 = Credits;
        end;

        p72.Robux.Size = UDim2.fromScale(0.38, 1);
        p72.Credits.Visible = true;
        p71:DrawCredits(p72.Credits, Credits, function() -- Line: 525
            -- upvalues: u21 (ref), u76 (copy), u4 (ref), u75 (ref), u24 (ref), u18 (ref), u73 (ref)
            if u21.Get("Credits") < u76 then
                u4:Create("Not Enough Credits", Color3.fromRGB(255, 151, 153));

                return;
            end;

            u24:Create("Item Purchase", `Are you sure you want to purchase {u75.Items and (u75.DisplayName or u75.Name) or `{u75.Name} Gamepass`}?`, function() -- Line: 533
                -- upvalues: u18 (ref), u73 (ref), u4 (ref), u76 (ref)
                u18.Gui.BuyGamepass.Fire(u73);
                u4:Create(`-${u76}`, Color3.fromRGB(255, 151, 153));
            end);
        end);
    else
        p72.Robux.Size = UDim2.fromScale(0.795, 1);
        p72.Credits.Visible = false;
    end;

    p71:DrawRobux(p72.Robux, u73);
end;

function u1.DrawGamepasses() -- Line: 547
    -- upvalues: u20 (ref), FetchProductInfo (copy), u1 (copy), u12 (copy), u25 (ref), u68 (copy), u27 (ref), DrawGamepassPrices (copy)
    local v77 = {};

    for i, v in u20 do
        if i ~= "Gifts" then
            local v78 = i;

            for i2, v2 in v do
                if v2.Visible then
                    table.insert(v77, {
                        ForSale = false,
                        CategoryName = v78,
                        GamepassId = i2,
                        Gamepass = v2
                    });
                end;
            end;
        end;
    end;

    FetchProductInfo(v77);
    table.sort(v77, function(p79, p80) -- Line: 571
        return (p79.Gamepass.Index or (p79.Gamepass.LayoutOrder or 0)) < (p80.Gamepass.Index or (p80.Gamepass.LayoutOrder or 0));
    end);

    for _, v in v77 do
        if v.ForSale then
            local GamepassId = v.GamepassId;
            local Gamepass = v.Gamepass;
            local v81 = u1.gamepassFrame(u12.Gamepasses, GamepassId, Gamepass.DisplayName, Gamepass.Thumbnail, Gamepass.Description, Gamepass.Index or (Gamepass.LayoutOrder or 0), Gamepass.Color);
            local Price = v81.Price;
            u1.AnimateCard(v81, false);
            local v82 = u25.new();
            u68[GamepassId] = v82;
            v82:DrawGift(Price.Gift, GamepassId);
            local v83;

            if Gamepass and not Gamepass.Items then
                v83 = u27[Gamepass.Name];

                if not v83 then
                    if Gamepass.Name == "3x Open" then
                        v83 = u27["5x Open"];
                    else
                        v83 = false;
                    end;
                end;
            else
                v83 = false;
            end;

            if v83 then
                Price.Owned.Visible = true;
                Price.Credits.Visible = false;
                Price.Robux.Visible = false;
            else
                DrawGamepassPrices(v82, Price, GamepassId, Gamepass);
            end;
        end;
    end;

    u1.UpdateNullUI();
end;

function u1.UpdateGamepasses() -- Line: 609
    -- upvalues: u20 (ref), u12 (copy), u27 (ref), FadeAway (copy), FadeIn (copy), DrawGamepassPrices (copy), u68 (copy)
    for i, v in u20 do
        if i ~= "Gifts" then
            for i2, v2 in v do
                local u84 = u12.Gamepasses:FindFirstChild((tostring(i2))) or u12.Gamepasses:FindFirstChild(i2);

                if u84 then
                    local Price = u84:FindFirstChild("Price");

                    if Price then
                        local Owned = Price:FindFirstChild("Owned");
                        local v85;

                        if v2 and not v2.Items then
                            v85 = u27[v2.Name];

                            if not v85 then
                                if v2.Name == "3x Open" then
                                    v85 = u27["5x Open"];
                                else
                                    v85 = false;
                                end;
                            end;
                        else
                            v85 = false;
                        end;

                        if v85 and (Owned and not Owned.Visible) then
                            FadeAway(Price.Credits);
                            FadeAway(Price.Robux);
                            FadeAway(u84.Tag);
                            task.delay(0.5, function() -- Line: 634
                                -- upvalues: Price (copy), u84 (copy), Owned (copy), FadeIn (ref)
                                Price.Credits.Visible = false;
                                Price.Robux.Visible = false;
                                u84.Tag.Visible = false;
                                Owned.Visible = true;
                                FadeIn(Owned, 0);
                            end);
                        elseif v2.Upgrade then
                            local v86;

                            if v2 and not v2.Items then
                                v86 = u27[v2.Name];

                                if not v86 then
                                    if v2.Name == "3x Open" then
                                        v86 = u27["5x Open"];
                                    else
                                        v86 = false;
                                    end;
                                end;
                            else
                                v86 = false;
                            end;

                            if not v86 then
                                DrawGamepassPrices(u68[i2], Price, i2, v2);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local u87 = nil;
local u88 = nil;
local u89 = 1;
local u90 = {};

local function ActiveBundles() -- Line: 840
    -- upvalues: u16 (ref)
    local UnixTimestamp = DateTime.now().UnixTimestamp;
    local v91 = {};

    for i, v in u16 do
        if v.Date.From <= UnixTimestamp and UnixTimestamp < v.Date.To then
            table.insert(v91, i);
        end;
    end;

    return v91;
end;

local function StepBundle(p92: number) -- Line: 853
    -- upvalues: ActiveBundles (copy), u87 (ref)
    local v93 = ActiveBundles();

    if #v93 == 0 then
        return nil;
    end;

    return v93[((table.find(v93, u87) or 0) - 1 + p92) % #v93 + 1];
end;

local function OnScreen() -- Line: 865
    -- upvalues: u23 (ref)
    if u23.IsOpen() then
        return false;
    end;

    local v94 = Bundle;

    while v94 and not v94:IsA("LayerCollector") do
        if v94:IsA("GuiObject") and not v94.Visible then
            return false;
        end;

        v94 = v94.Parent;
    end;

    local v95;

    if v94 == nil then
        v95 = false;
    else
        v95 = v94.Enabled;
    end;

    return v95;
end;

function u1.DrawHome() -- Line: 883
    -- upvalues: u25 (ref), u87 (ref), ActiveBundles (copy), u5 (ref), u15 (ref), u1 (copy)
    BundleButtons = u25.new();
    u87 = ActiveBundles()[1];
    u5:Add("Bundle_RightArrow", Bundle.RightArrow.MouseButton1Click:Connect(function() -- Line: 888
        -- upvalues: u15 (ref), u1 (ref)
        u15.Play("UI.submenu_click");
        u1.SwitchBundle(1);
    end));
    u5:Add("Bundle_LeftArrow", Bundle.LeftArrow.MouseButton1Click:Connect(function() -- Line: 894
        -- upvalues: u15 (ref), u1 (ref)
        u15.Play("UI.submenu_click");
        u1.SwitchBundle(-1);
    end));
    u1.UpdateBundle();
end;

function u1.SwitchBundle(p96: number) -- Line: 903
    -- upvalues: u87 (ref), ActiveBundles (copy), u89 (ref), u1 (copy)
    local v97 = ActiveBundles();
    local v98;

    if #v97 == 0 then
        v98 = nil;
    else
        v98 = v97[((table.find(v97, u87) or 0) - 1 + p96) % #v97 + 1];
    end;

    u87 = v98;
    u89 = p96;
    u1.UpdateBundle();
end;

local u99 = {};
local u100 = nil;

local function HighlightHome(p101: string) -- Line: 913
    -- upvalues: u9 (ref)
    local v102 = u9.Pages[p101];

    if u9.ActiveButton ~= v102.Button then
        u9:ActivateTab(v102.Button, v102.Page, v102.IsUnderHold, v102.UnderUI, v102.HasUnderHold);
    end;
end;

function u1.ScrollHome(p103: string) -- Line: 921
    -- upvalues: u99 (copy), u12 (copy), TweenService (copy), u100 (ref)
    local v104 = u99[p103];

    if not v104 then
        return;
    end;

    local Scroll = u12.Home.Scroll;
    local u105 = TweenService:Create(Scroll, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        CanvasPosition = Vector2.new(0, v104 * Scroll.AbsoluteWindowSize.Y)
    });
    u105.Completed:Connect(function() -- Line: 932
        -- upvalues: u100 (ref), u105 (copy), Scroll (copy)
        if u100 == u105 then
            Scroll.ScrollingEnabled = true;
        end;
    end);
    u100 = u105;
    Scroll.ScrollingEnabled = false;
    u105:Play();
end;

function u1.DrawHomeScroll(u106) -- Line: 944
    -- upvalues: u12 (copy), u99 (copy), u5 (ref), TweenService (copy), u9 (ref), u100 (ref)
    local Hero = u12.Home.Hero;
    local Blackout = u12.Home.Blackout;
    local Scroll = u12.Home.Scroll;
    local Parent = u12.Home.Parent;
    u99.Home = 0;
    local v107 = 0.94;

    for _, v in u106 do
        if v.Rows then
            v.Content = v.Rows * v.Row;
        end;

        v.Top = v107;
        v.Height = v.Header + v.Content;
        v107 = v107 + v.Height;
    end;

    local math_max_ret = math.max(v107, u106[#u106].Top + 1);
    Scroll.CanvasSize = UDim2.fromScale(0, math_max_ret);

    for _, v in u106 do
        local Section = v.Section;
        Section.Position = UDim2.fromScale(0, v.Top / math_max_ret);
        Section.Size = UDim2.fromScale(1, v.Height / math_max_ret);
        Section.Items.Position = UDim2.fromScale(0.5, v.Header / v.Height);
        Section.Items.Size = UDim2.fromScale(1, v.Content / v.Height);
        Section.Title.Position = UDim2.fromScale(0.5, 0.02 / v.Height);
        Section.Title.Size = UDim2.fromScale(0.14, 0.034 / v.Height);

        if v.Rows then
            Section.Items.UIGridLayout.CellSize = UDim2.fromScale(0.17, 0.9 / v.Rows);
            Section.Items.UIGridLayout.CellPadding = UDim2.fromScale(0.012, 0.1 / v.Rows);
        end;

        u99[Section.Name] = v.Top;
    end;

    Scroll.ScrollingEnabled = true;
    u5:Add("Home_Scroll", Scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 990
        -- upvalues: Scroll (copy), TweenService (ref), u99 (ref), Hero (copy), Blackout (copy), u9 (ref), Parent (copy), u100 (ref), u106 (copy)
        local v108 = Scroll.CanvasPosition.Y / Scroll.AbsoluteWindowSize.Y;
        local math_clamp_ret = math.clamp(v108 / 0.94, 0, 1);
        local Value = TweenService:GetValue(math_clamp_ret, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local math_clamp_ret2 = math.clamp((v108 - 0.94) / (u99.Gamepasses - 0.94), 0, 1);
        Hero.GroupTransparency = Value * 0.8 + math_clamp_ret2 * 0.2;
        Hero.Visible = math_clamp_ret2 < 1;
        Hero.Position = UDim2.fromScale(0.5, 0.5 - Value * 0.04);
        Hero.UIScale.Scale = 1 + Value * 0.12;
        Blackout.BackgroundTransparency = 1 - Value * 0.45;
        Hero.Interactable = math_clamp_ret < 0.5;

        if u9.CurrentTab ~= Parent or u100 and u100.PlaybackState == Enum.PlaybackState.Playing then
            return;
        end;

        local v109 = "Home";

        for _, v in u106 do
            if v.Top - 0.4 <= v108 then
                v109 = v.Section.Name;
            end;
        end;

        local v110 = u9.Pages[v109];

        if u9.ActiveButton ~= v110.Button then
            u9:ActivateTab(v110.Button, v110.Page, v110.IsUnderHold, v110.UnderUI, v110.HasUnderHold);
        end;
    end));
end;

function u1.AnimateBundle(p111) -- Line: 1020
    -- upvalues: TweenService (copy), u89 (ref)
    local Bundle_Background = Bundle.Background;
    local Outgoing = Bundle_Background:FindFirstChild("Outgoing");

    if Outgoing then
        Outgoing:Destroy();
    end;

    if Bundle_Background.Image ~= p111.Thumbnail then
        local u112 = Bundle_Background:Clone();
        u112.Name = "Outgoing";
        u112.Parent = Bundle_Background;
        local v113 = TweenService:Create(u112, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ImageTransparency = 1,
            Position = UDim2.fromScale(0.5 - u89 * 0.04, 0.5)
        });
        v113.Completed:Connect(function() -- Line: 1035
            -- upvalues: u112 (copy)
            u112:Destroy();
        end);
        v113:Play();
    end;

    Bundle_Background.Image = p111.Thumbnail;
    Bundle.Top.Position = UDim2.fromScale(u89 * 0.03, 0);
    Bundle.Top.Title.TextTransparency = 1;
    TweenService:Create(Bundle.Top, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0, 0)
    }):Play();
    TweenService:Create(Bundle.Top.Title, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play();
    TweenService:Create(Bundle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Color = p111.Color
    }):Play();
end;

function u1.UpdateBundle() -- Line: 1052
    -- upvalues: u16 (ref), u87 (ref), ActiveBundles (copy), u1 (copy), u5 (ref), RunService (copy), OnScreen (copy), TweenService (copy), u88 (ref), u6 (ref), u19 (ref), u14 (ref), u90 (copy), FadeIn (copy), u89 (ref), LocalPlayer (copy), u21 (ref), u4 (ref), u24 (ref), u18 (ref), u22 (ref)
    if not Bundle then
        return;
    end;

    local u114 = u16[u87];

    if not u114 then
        Bundle.Visible = false;

        return;
    end;

    local Name = u114.Name;
    local u115 = u87;
    local v116 = #ActiveBundles() > 1;
    u1.ClearBundle();
    Bundle.Visible = true;
    Bundle.Top.Title.Text = Name;
    u1.AnimateBundle(u114);
    Bundle.Bottom.ProgressBar.Visible = v116;
    Bundle.LeftArrow.Visible = v116;
    Bundle.RightArrow.Visible = v116;
    Bundle.Bottom.ProgressBar.Bar.Size = UDim2.fromScale(0, 1);

    if v116 then
        local u117 = 0;
        u5:Add("Bundle_Cycle", RunService.Heartbeat:Connect(function(p118) -- Line: 1084
            -- upvalues: OnScreen (ref), u117 (ref), u1 (ref), TweenService (ref)
            if not OnScreen() then
                return;
            end;

            u117 = u117 + p118;

            if u117 >= 8.2 then
                u1.SwitchBundle(1);

                return;
            end;

            Bundle.Bottom.ProgressBar.Bar.Size = UDim2.fromScale(TweenService:GetValue(math.min(u117 / 8, 1), Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 1);
        end));
    end;

    u88 = task.spawn(function() -- Line: 1100
        -- upvalues: u114 (copy), u88 (ref), u1 (ref), u87 (ref), u115 (copy)
        while true do
            local v119 = u114.Date.To - DateTime.now().UnixTimestamp;
            Bundle.Top.Timer.Text = DateTime.fromUnixTimestamp(v119):FormatUniversalTime("DDD:HH:mm:ss", "en-us");

            if v119 <= 0 then
                break;
            end;

            task.wait(1);

            if u87 ~= u115 then
                return;
            end;
        end;

        u88 = nil;
        u1.SwitchBundle(1);
    end);
    local v120 = {};
    local v121 = 0;

    for i, v in u114.Items do
        table.insert(v120, {
            Item = i,
            Price = v
        });
    end;

    table.sort(v120, function(p122, p123) -- Line: 1123
        return p122.Price.LayoutOrder < p123.Price.LayoutOrder;
    end);
    BundleItems.UIGridLayout.CellSize = UDim2.fromScale(math.min(0.23, (1 - (#v120 - 1) * 0.015) / #v120), 0.8);

    for _, v in v120 do
        local Price = v.Price;
        local v124, v125 = unpack(v.Item:split("_"));
        local v126 = u6.GetCategory(v124) or u19.Get(v124);
        local v127 = u6.GetItem(v124, v125) or u14.GetWeaponSkin(v124, v125);

        if v126 and v127 then
            local v128, v129 = u1.CreateBundleItem(BundleItems, Name, v126.DisplayName or v124, v127.DisplayName or v125, "Bundle Item", v127.Thumbnail, u114.Color, u114.ItemBackground, Price, v124, v125, v127.Rarity, v127.Description or v126.GuiInformation.Description, u115);
            table.insert(u90, v129);
            v128.LayoutOrder = Price.LayoutOrder;
            local v130 = v121 * 0.06;
            local Position = v128.Icon.Position;
            v121 = v121 + 1;
            FadeIn(v128, v130);
            v128.Icon.Position = Position + UDim2.fromOffset(u89 * 18, 0);
            TweenService:Create(v128.Icon, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, v130), {
                Position = Position
            }):Play();
        end;
    end;

    local GamepassId = u114.GamepassId;
    local Credits = u114.Price.Credits;
    local u131;

    if RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription then
        u131 = math.floor(Credits * 0.9) or Credits;
    else
        u131 = Credits;
    end;

    BundleButtons:DrawCredits(Bundle.Price.Credits, Credits, function() -- Line: 1165
        -- upvalues: u21 (ref), u131 (copy), u4 (ref), u24 (ref), Name (copy), u18 (ref), u115 (copy), u22 (ref)
        if u21.Get("Credits") < u131 then
            u4:Create("Not Enough Credits", Color3.fromRGB(255, 151, 153));

            return;
        end;

        u24:Create("Bundle Purchase", `Are you sure you want to purchase {Name} Bundle?`, function(p132) -- Line: 1172
            -- upvalues: u18 (ref), u115 (ref), u22 (ref), u4 (ref), u131 (ref)
            u18.Gui.BuyBundle.Fire(u115 + (p132 and u22.PayLocked or 0));
            u4:Create(`-${u131}`, Color3.fromRGB(255, 151, 153));
        end, u131);
    end);
    BundleButtons:DrawRobux(Bundle.Price.Robux, GamepassId);
    BundleButtons:DrawGift(Bundle.Price.Gift, GamepassId);
end;

function u1.ClearBundle(p133) -- Line: 1182
    -- upvalues: u5 (ref), u90 (copy), u88 (ref)
    for _, child in BundleItems:GetChildren() do
        if child:IsA("TextButton") then
            local Attribute = child:GetAttribute("ConnectName");
            u5:Removes(`{Attribute}_MouseEnter`, `{Attribute}_MouseLeave`, (`{Attribute}_Button1Click`));
            child:SetAttribute("ConnectName", nil);
            child:Destroy();
        end;
    end;

    BundleButtons:Clear();

    for i, v in u90 do
        v:Clear();
        u90[i] = nil;
    end;

    u5:Remove("Bundle_Cycle");

    if u88 then
        pcall(task.cancel, u88);
        u88 = nil;
    end;
end;

function u1.CreateItem(p134, u135, u136, u137, u138, p139, u140, p141, p142) -- Line: 1210
    -- upvalues: u1 (copy), u6 (ref), u25 (ref), u17 (ref), u13 (ref), HttpService (copy), u15 (ref), TweenService (copy), u5 (ref)
    local storeItem = u1.storeItem;
    local v143;

    if u140 then
        v143 = u6.GetItem("Containers", u135).DisplayName or u135;
    else
        v143 = u135;
    end;

    local u144 = storeItem(p134, v143, u136, u137, u138, p139, p141);

    if u25 then
        local v145 = u25.new();

        if p142 then
            v145:DrawRobux(u144.Price.Robux, p142);
        else
            u144.Price.Robux.Visible = false;
        end;

        if u136 then
            v145:DrawCredits(u144.Price.Credits, u136, function() -- Line: 1221
                -- upvalues: u140 (copy), u17 (ref), u136 (copy), u137 (copy), u135 (copy), u138 (copy)
                if u140 then
                    u17.SetVisible(true, u136, u137, u135, u138);
                end;
            end);
        end;
    end;

    if u140 then
        while not u13 do
            task.wait();
        end;

        if u13.ArePaidRandomItemsRestricted and (u144:FindFirstChild("Price") and u144.Price:FindFirstChild("Robux")) then
            u144.Price.Robux.Visible = false;
        end;
    end;

    local v146 = HttpService:GenerateGUID(false);
    u144:SetAttribute("ConnectName", v146);

    local function Enter() -- Line: 1238
        -- upvalues: u15 (ref), TweenService (ref), u144 (copy)
        u15.Play("UI.mainmenu_rollover");
        TweenService:Create(u144.Icon, TweenInfo.new(0.25), {
            Size = UDim2.fromScale(1.1, 0.8)
        }):Play();
        TweenService:Create(u144.CanvasGroup.Color.Frame, TweenInfo.new(0.25), {
            BackgroundTransparency = 0
        }):Play();
    end;

    local function Leave() -- Line: 1245
        -- upvalues: TweenService (ref), u144 (copy)
        TweenService:Create(u144.Icon, TweenInfo.new(0.25), {
            Size = UDim2.fromScale(1, 0.6525)
        }):Play();
        TweenService:Create(u144.CanvasGroup.Color.Frame, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.5
        }):Play();
    end;

    u5:Add(`{v146}_MouseEnter`, u144.MouseEnter:Connect(Enter));
    u5:Add(`{v146}_MouseLeave`, u144.MouseLeave:Connect(Leave));
    u5:Add(`{v146}_SelectionGained`, u144.SelectionGained:Connect(Enter));
    u5:Add(`{v146}_SelectionLost`, u144.SelectionLost:Connect(Leave));
    u5:Add(`{v146}_Button1Click`, u144.MouseButton1Click:Connect(function() -- Line: 1255
        -- upvalues: u140 (copy), u17 (ref), u136 (copy), u137 (copy), u135 (copy), u138 (copy)
        if u140 then
            u17.SetVisible(true, u136, u137, u135, u138);
        end;
    end));
end;

function u1.CreateBundleItem(p147, p148, u149, u150, p151, p152, p153, p154, u155, u156, u157, u158, u159, u160) -- Line: 1262
    -- upvalues: u1 (copy), RunService (copy), LocalPlayer (copy), u25 (ref), HttpService (copy), u5 (ref), u15 (ref), TweenService (copy), u23 (ref), u21 (ref), u4 (ref), u24 (ref), u18 (ref), u22 (ref)
    local u161 = u1.bundleItem(p147, u149, u150, p151, p152, p153, p154);
    local Credits = u155.Credits;
    local GamepassId = u155.GamepassId;
    local Robux = u155.Robux;
    local u162;

    if RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription then
        u162 = math.floor(Credits * 0.9) or Credits;
    else
        u162 = Credits;
    end;

    local v163 = u25.new();
    local v164 = HttpService:GenerateGUID(false);
    u161:SetAttribute("ConnectName", v164);
    u5:Add(`{v164}_MouseEnter`, u161.Icon.MouseEnter:Connect(function() -- Line: 1275
        -- upvalues: u15 (ref), TweenService (ref), u161 (copy)
        u15.Play("UI.mainmenu_rollover");
        TweenService:Create(u161.Icon, TweenInfo.new(0.25), {
            Size = UDim2.fromScale(1, 0.625)
        }):Play();
        TweenService:Create(u161.Inspect, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.9
        }):Play();
        TweenService:Create(u161.Frame.ImageColor.Frame, TweenInfo.new(0.25), {
            BackgroundTransparency = 0
        }):Play();
    end));
    u5:Add(`{v164}_MouseLeave`, u161.Icon.MouseLeave:Connect(function() -- Line: 1283
        -- upvalues: TweenService (ref), u161 (copy)
        TweenService:Create(u161.Icon, TweenInfo.new(0.25), {
            Size = UDim2.fromScale(0.98, 0.575)
        }):Play();
        TweenService:Create(u161.Inspect, TweenInfo.new(0.25), {
            BackgroundTransparency = 1
        }):Play();
        TweenService:Create(u161.Frame.ImageColor.Frame, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.5
        }):Play();
    end));
    u23.Register(u161, function() -- Line: 1289
        -- upvalues: u156 (copy), u157 (copy), u158 (copy), u159 (copy)
        return table.pack(u156, u157, u158, u159);
    end);
    u5:Add(`{v164}_Button1Click`, u161.Icon.MouseButton1Click:Connect(function() -- Line: 1293
        -- upvalues: u23 (ref), u161 (copy)
        u23.Browse(u161);
    end));
    v163:DrawCredits(u161.Price.Credits, Credits, function() -- Line: 1297
        -- upvalues: u21 (ref), u162 (copy), u4 (ref), u24 (ref), u149 (copy), u150 (copy), u155 (copy), u18 (ref), u160 (copy), u22 (ref), u156 (copy), u157 (copy)
        if u21.Get("Credits") < u162 then
            u4:Create("Not Enough Credits", Color3.fromRGB(255, 151, 153));

            return;
        end;

        u24:Create("Item Purchase", `Are you sure you want to purchase {u149} | {u150}?`, function(p165) -- Line: 1304
            -- upvalues: u155 (ref), u18 (ref), u160 (ref), u22 (ref), u156 (ref), u157 (ref), u4 (ref), u162 (ref)
            local _ = u155.ItemType;
            u18.Gui.BuyBundleItem.Fire({
                BundleIndex = u160 + (p165 and u22.PayLocked or 0),
                ItemName = `{u156}_{u157}`
            });
            u4:Create(`-${u162}`, Color3.fromRGB(255, 151, 153));
        end, u162);
    end);
    u161.Price.Robux.Title.Text = Robux;
    v163:DrawRobux(u161.Price.Robux, GamepassId);
    v163:DrawGift(u161.Price.Gift, GamepassId);

    return u161, v163;
end;

function u1.CreditsFrame(p166, p167, p168) -- Line: 1323
    -- upvalues: u25 (ref), u19 (ref), u14 (ref), u1 (copy), u7 (ref), TweenService (copy), u23 (ref)
    local v169 = u25.new();
    local v170;

    if p167.BonusReward then
        local u171, u172 = unpack(p167.BonusReward:split("_"));
        local v173 = u19.Get(u171);
        local WeaponSkin = u14.GetWeaponSkin(u171, u172);
        local v174 = `{v173.DisplayName or u171} | {WeaponSkin.DisplayName or u172}`;
        local u175 = WeaponSkin.Description or v173.GuiInformation.Description;
        v170 = u1.creditsBonusFrame(p166.Packs, p167.Credits, p167.Bonus, p168, p167.Color, p167.Tag, v174, WeaponSkin.Thumbnail, WeaponSkin.Rarity, u7[WeaponSkin.Rarity]);
        local Item = v170.Item;
        Item.MouseEnter:Connect(function() -- Line: 1340
            -- upvalues: TweenService (ref), Item (copy)
            TweenService:Create(Item.Inspect, TweenInfo.new(0.25), {
                BackgroundTransparency = 0.9
            }):Play();
            TweenService:Create(Item.UIStroke, TweenInfo.new(0.25), {
                Transparency = 0.2
            }):Play();
            TweenService:Create(Item.Thumbnail, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Rotation = -6
            }):Play();
        end);
        Item.MouseLeave:Connect(function() -- Line: 1346
            -- upvalues: TweenService (ref), Item (copy)
            TweenService:Create(Item.Inspect, TweenInfo.new(0.25), {
                BackgroundTransparency = 1
            }):Play();
            TweenService:Create(Item.UIStroke, TweenInfo.new(0.25), {
                Transparency = 0.6
            }):Play();
            TweenService:Create(Item.Thumbnail, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Rotation = 0
            }):Play();
        end);
        Item.MouseButton1Click:Connect(function() -- Line: 1352
            -- upvalues: u23 (ref), u171 (copy), u172 (copy), WeaponSkin (copy), u175 (copy)
            u23.Item(u171, u172, WeaponSkin.Rarity, u175);
        end);
        u1.AnimateCard(v170, true, 4.5);
        u1.AnimateFeatured(v170);
    else
        v170 = u1.creditsFrame(p166.Packs.Main, p167.Credits, p167.Bonus, p168, p167.Tag);
        u1.AnimateCard(v170, true);
    end;

    v169:DrawRobux(v170.Price.Robux, p167.GamepassId);
    v169:DrawGift(v170.Price.Gift, p167.GamepassId);
end;

function u1.CreditsLabel(p176: userdata, p177: any) -- Line: 1368
    -- upvalues: u1 (copy), u21 (ref), LocalPlayer (copy), TweenService (copy), u13 (ref), u4 (ref)
    local u178 = u1.creditsLabel(p177);
    u178.Parent = p176;
    local u179 = u21.Get("Credits");
    local Breakdown = u178.Breakdown;
    local Position = Breakdown.Position;
    local u180 = false;

    local function GetLocked() -- Line: 1382
        -- upvalues: LocalPlayer (ref)
        return LocalPlayer:GetAttribute("LockedKredits") or 0;
    end;

    local function ShowBreakdown(p181) -- Line: 1386
        -- upvalues: LocalPlayer (ref), u180 (ref), Breakdown (copy), Position (copy), TweenService (ref)
        if p181 then
            p181 = (LocalPlayer:GetAttribute("LockedKredits") or 0) > 0;
        end;

        if p181 == u180 then
            return;
        end;

        u180 = p181;

        if not p181 then
            TweenService:Create(Breakdown, TweenInfo.new(0.15), {
                GroupTransparency = 1
            }):Play();
            task.delay(0.15, function() -- Line: 1402
                -- upvalues: u180 (ref), Breakdown (ref)
                if not u180 then
                    Breakdown.Visible = false;
                end;
            end);

            return;
        end;

        Breakdown.Visible = true;
        Breakdown.Position = Position - UDim2.fromOffset(0, 6);
        TweenService:Create(Breakdown, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            GroupTransparency = 0,
            Position = Position
        }):Play();
    end;

    local function UpdateCredits() -- Line: 1410
        -- upvalues: LocalPlayer (ref), u178 (copy), u179 (ref), Breakdown (copy), ShowBreakdown (copy)
        local v182 = LocalPlayer:GetAttribute("LockedKredits") or 0;
        u178.Title.Text = u179;
        u178.Lock.Visible = v182 > 0;
        Breakdown.Own.Value.Text = math.max(u179 - v182, 0);
        Breakdown.Locked.Value.Text = v182;

        if v182 <= 0 then
            ShowBreakdown(false);
        end;
    end;

    u21.Changed("Credits"):Connect(function(p183) -- Line: 1423
        -- upvalues: u179 (ref), LocalPlayer (ref), u178 (copy), Breakdown (copy), ShowBreakdown (copy)
        u179 = p183;
        local v184 = LocalPlayer:GetAttribute("LockedKredits") or 0;
        u178.Title.Text = u179;
        u178.Lock.Visible = v184 > 0;
        Breakdown.Own.Value.Text = math.max(u179 - v184, 0);
        Breakdown.Locked.Value.Text = v184;

        if v184 <= 0 then
            ShowBreakdown(false);
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("LockedKredits"):Connect(UpdateCredits);

    for _, v in { u178, u178.Lock } do
        v.MouseEnter:Connect(function() -- Line: 1432
            -- upvalues: ShowBreakdown (copy)
            ShowBreakdown(true);
        end);
        v.MouseLeave:Connect(function() -- Line: 1436
            -- upvalues: ShowBreakdown (copy)
            ShowBreakdown(false);
        end);
        v.InputBegan:Connect(function(p185) -- Line: 1440
            -- upvalues: ShowBreakdown (copy)
            if p185.UserInputType == Enum.UserInputType.Touch then
                ShowBreakdown(true);
                task.delay(2.5, ShowBreakdown, false);
            end;
        end);
    end;

    local v186 = LocalPlayer:GetAttribute("LockedKredits") or 0;
    u178.Title.Text = u179;
    u178.Lock.Visible = v186 > 0;
    Breakdown.Own.Value.Text = math.max(u179 - v186, 0);
    Breakdown.Locked.Value.Text = v186;

    if v186 <= 0 then
        ShowBreakdown(false);
    end;

    u178.BuyCredits.MouseButton1Click:Connect(function() -- Line: 1452
        -- upvalues: u13 (ref), u4 (ref), u1 (ref)
        while not u13 do
            task.wait();
        end;

        if u13.ArePaidRandomItemsRestricted then
            u4:Create("Not Available", Color3.fromRGB(255, 151, 153));

            return;
        end;

        u1.OpenCreditsTab();
    end);

    return u178;
end;

function u1.OpenCreditsTab() -- Line: 1465
    -- upvalues: u17 (ref), u3 (ref), u28 (ref), u9 (ref)
    if u17.onCooldown or u17.IsOpeningCase() then
        return;
    end;

    u17.Close();
    u3.Visible(true);
    u28.Activate();
    u9:OpenTab("Kredits");
end;

function u1.Activate() -- Line: 1476
    -- upvalues: u28 (ref), u9 (ref)
    u28.Activate();
    u9:OpenTab("Home");
end;

function u1.Init(p187) -- Line: 1483
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u26 (ref), u6 (ref), u14 (ref), u15 (ref), u7 (ref), u8 (ref), u16 (ref), u17 (ref), u18 (ref), u21 (ref), u22 (ref), u19 (ref), u20 (ref), u23 (ref)
    u2 = p187:GetModule("Gui");
    u3 = u2.GetComponent("MainMenu");
    u5 = p187:GetModule("Maid").new();
    u26 = u2.GetComponent("Tabs");
    u6 = p187:GetModule("ItemManager");
    u14 = p187:GetModule("SkinManager");
    u15 = p187:GetModule("SoundManager");
    u7 = p187:GetModule("RarityColors");
    u8 = p187:GetModule("CreditsPrices");
    u16 = p187:GetModule("BundlesData");
    u17 = p187:GetModule("CaseInspect");
    u18 = p187:GetModule("Network");
    u21 = p187:GetModule("ProfileData");
    u22 = p187:GetModule("Enums");
    u19 = p187:GetModule("WeaponManager");
    u20 = p187:GetModule("GamepassesData");
    u23 = u2.GetComponent("Inspect");
end;

function u1.Start(p188) -- Line: 1503
    -- upvalues: u24 (ref), u2 (ref), u4 (ref), u25 (ref), u11 (ref), u3 (ref), u38 (ref), IsVisibleOnScreen (copy), RunService (copy), u39 (copy), u28 (ref), u10 (ref), u1 (copy), u27 (ref), u21 (ref)
    u24 = u2.GetComponent("Notify");
    u4 = u2.GetComponent("MenuNotification");
    u25 = u2.GetComponent("PurchaseButtons");
    u11 = u3.AddTab("Store");
    local u189 = nil;

    local function RefreshStoreConnection() -- Line: 1516
        -- upvalues: u38 (ref), IsVisibleOnScreen (ref), u11 (ref), u189 (ref), RunService (ref), u39 (ref)
        u38 = IsVisibleOnScreen(u11);

        if u38 and not u189 then
            u189 = RunService.RenderStepped:Connect(function() -- Line: 1520
                -- upvalues: u39 (ref)
                for i in u39 do
                    i();
                end;
            end);

            return;
        end;

        if not u38 and u189 then
            u189:Disconnect();
            u189 = nil;
        end;
    end;

    local v190 = u11;

    while v190 and v190:IsA("GuiObject") do
        v190:GetPropertyChangedSignal("Visible"):Connect(RefreshStoreConnection);
        v190 = v190.Parent;
    end;

    RefreshStoreConnection();
    u28 = u3.AddButton("Store", u11, UDim2.fromScale(0.075, 0.032), UDim2.fromScale(0.56, 0.015));
    u10 = u1.newNull();
    u10.Parent = u11;
    u27 = u21.Get("Gamepasses");
    u21.Changed("Gamepasses"):Connect(function(p191) -- Line: 1545
        -- upvalues: u27 (ref), u1 (ref)
        u27 = p191;
        u1.UpdateGamepasses();
    end);
    u1.Draw();
end;

function u1.newNull() -- Line: 1556
    local Frame = Instance.new("Frame");
    Frame.Name = "Null";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.35, 0.035);
    Frame.Visible = false;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "MainText";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 4;
    TextLabel.Position = UDim2.fromScale(0.08, 0.5);
    TextLabel.Size = UDim2.fromScale(0.92, 1.1);
    TextLabel.Text = "Not added yet. Coming soon with updates.";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.25;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "IconInfo";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://80205853195967";
    ImageLabel.Position = UDim2.fromScale(0, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;

    return Frame;
end;

function u1.storeItem(p192, p193, p194, p195, p196, p197, p198) -- Line: 1821
    -- upvalues: RunService (copy), LocalPlayer (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "StoreFrame";
    TextButton.Active = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.Size = UDim2.fromOffset(100, 100);
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Icon";
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = `rbxassetid://{p196}`;
    ImageButton.Interactable = false;
    ImageButton.Position = UDim2.fromScale(0.5, 0.326252);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(1, 0.652504);
    ImageButton.ZIndex = 5;
    ImageButton.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "ItemName";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.504, 0.68);
    TextLabel.Size = UDim2.fromScale(0.9, 0.088421);
    TextLabel.Text = p193;
    TextLabel.TextColor3 = Color3.fromRGB(222, 222, 222);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.85;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = TextButton;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "CanvasGroup";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    CanvasGroup.Interactable = false;
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    CanvasGroup.ZIndex = -1;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = p197;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.401583, 0),
        NumberSequenceKeypoint.new(0.582591, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame;
    Frame.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 0.825432);
    Frame2.Size = UDim2.fromScale(1, 0.349136);
    Frame2.ZIndex = 3;
    Frame2.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BackgroundTransparency = 0.9;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 0.65);
    Frame3.Size = UDim2.new(1, 0, 0, 1);
    Frame3.ZIndex = 4;
    Frame3.Parent = CanvasGroup;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Color";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
    Frame4.Position = UDim2.fromScale(0.5, 0.499999);
    Frame4.Size = UDim2.fromScale(0.99, 0.995);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.Parent = Frame4;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Frame";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundColor3 = p197;
    ImageLabel.BackgroundTransparency = 0.5;
    ImageLabel.BorderColor3 = Color3.new();
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.ImageColor3 = p197;
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = 86;
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.769),
        NumberSequenceKeypoint.new(0.489, 0.9),
        NumberSequenceKeypoint.new(0.846476, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = ImageLabel;
    ImageLabel.Parent = Frame4;
    Frame4.Parent = CanvasGroup;
    CanvasGroup.Parent = TextButton;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Price";
    Frame5.AnchorPoint = Vector2.new(0.5, 1);
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0.5, 0.98);
    Frame5.Size = UDim2.fromScale(0.88, 0.16);
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Robux";
    TextButton2.Active = false;
    TextButton2.AnchorPoint = Vector2.new(1, 0.5);
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundTransparency = 0.95;
    TextButton2.LayoutOrder = 2;
    TextButton2.Position = UDim2.fromScale(0.85, 0.5);
    TextButton2.Size = UDim2.fromScale(0.4, 0.8);
    TextButton2.TextTransparency = 1;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Transparency = 0.875;
    UIStroke.Parent = TextButton2;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner3.BottomRightRadius = UDim.new(0.1, 0);
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.TopLeftRadius = UDim.new(0.1, 0);
    UICorner3.TopRightRadius = UDim.new(0.1, 0);
    UICorner3.Parent = TextButton2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel2.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel2.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel2.TextScaled = true;
    TextLabel2.Parent = TextButton2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Icon";
    TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.LayoutOrder = 1;
    TextLabel3.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel3.RichText = true;
    TextLabel3.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel3.Text = "";
    TextLabel3.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel3.Parent = TextButton2;
    TextButton2.Parent = Frame5;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Credits";
    TextButton3.Active = false;
    TextButton3.AnchorPoint = Vector2.new(1, 0.5);
    TextButton3.AutoButtonColor = false;
    TextButton3.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton3.BackgroundTransparency = 0.95;
    TextButton3.LayoutOrder = 1;
    TextButton3.Position = UDim2.fromScale(0.606394, 0.5);
    TextButton3.Size = UDim2.fromScale(0.4, 0.8);
    TextButton3.TextTransparency = 1;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel4.RichText = true;
    TextLabel4.Size = UDim2.fromScale(0.464995, 0.8);

    if RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription then
        local v199 = tonumber(p194) * 0.9;
        TextLabel4.Text = `{math.floor(v199)}`;
    else
        TextLabel4.Text = p194;
    end;

    TextLabel4.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel4.TextScaled = true;
    TextLabel4.Parent = TextButton3;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Icon";
    ImageLabel2.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://138240378050344";
    ImageLabel2.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel2.LayoutOrder = 1;
    ImageLabel2.Position = UDim2.fromScale(0.02, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = TextButton3;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Transparency = 0.875;
    UIStroke2.Parent = TextButton3;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner4.BottomRightRadius = UDim.new(0.1, 0);
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.TopLeftRadius = UDim.new(0.1, 0);
    UICorner4.TopRightRadius = UDim.new(0.1, 0);
    UICorner4.Parent = TextButton3;
    TextButton3.Parent = Frame5;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.Padding = UDim.new(0.05, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame5;
    Frame5.Parent = TextButton;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Blur";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.Interactable = false;
    Frame6.Position = UDim2.fromScale(0.5, 0.5);
    Frame6.Size = UDim2.fromScale(1, 1);
    Frame6.ZIndex = -2;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Frame";
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.5, 0.323826);
    Frame7.Size = UDim2.fromScale(1, 0.647653);
    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "UIShadow";
    UIShadow.BlurRadius = UDim.new(0.1, 0);
    UIShadow.Color = p197;
    UIShadow.Spread = UDim2.fromScale(-0.05, -0.05);
    UIShadow.Parent = Frame7;
    Frame7.Parent = Frame6;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Frame";
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.5, 0.823826);
    Frame8.Size = UDim2.fromScale(1, 0.352347);
    local UIShadow2 = Instance.new("UIShadow");
    UIShadow2.Name = "UIShadow";
    UIShadow2.BlurRadius = UDim.new(0.1, 0);
    UIShadow2.Spread = UDim2.fromScale(-0.05, -0.05);
    UIShadow2.Parent = Frame8;
    Frame8.Parent = Frame6;
    Frame6.Parent = TextButton;
    local TextButton4 = Instance.new("TextButton");
    TextButton4.Name = "Inspect";
    TextButton4.Active = false;
    TextButton4.AnchorPoint = Vector2.new(1, 0.5);
    TextButton4.AutoButtonColor = false;
    TextButton4.BackgroundTransparency = 1;
    TextButton4.LayoutOrder = 3;
    TextButton4.Position = UDim2.fromScale(0.96, 0.08);
    TextButton4.Size = UDim2.fromScale(0.085, 0.0800044);
    TextButton4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton4.TextTransparency = 1;
    TextButton4.Visible = false;
    TextButton4.ZIndex = 8;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.new(1, 1, 1);
    UIStroke3.Transparency = 0.8;
    UIStroke3.Parent = TextButton4;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.BottomLeftRadius = UDim.new(0.4, 0);
    UICorner5.BottomRightRadius = UDim.new(0.4, 0);
    UICorner5.CornerRadius = UDim.new(0.4, 0);
    UICorner5.TopLeftRadius = UDim.new(0.4, 0);
    UICorner5.TopRightRadius = UDim.new(0.4, 0);
    UICorner5.Parent = TextButton4;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Icon";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://112684033134382";
    ImageLabel3.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel3.LayoutOrder = 1;
    ImageLabel3.Position = UDim2.new(0.5, 0, 0.5, 2);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(2, 2);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = TextButton4;
    TextButton4.Parent = TextButton;

    if p198 then
        local Frame9 = Instance.new("Frame");
        Frame9.Name = "New";
        Frame9.BackgroundColor3 = Color3.fromRGB(106, 177, 207);
        Frame9.Position = UDim2.fromScale(0.05, 0.04);
        Frame9.Size = UDim2.fromScale(0.18, 0.1);
        Frame9.ZIndex = 10;
        local UICorner6 = Instance.new("UICorner");
        UICorner6.Name = "UICorner";
        UICorner6.BottomLeftRadius = UDim.new(0.125, 0);
        UICorner6.BottomRightRadius = UDim.new(0.125, 0);
        UICorner6.CornerRadius = UDim.new(0.125, 0);
        UICorner6.TopLeftRadius = UDim.new(0.125, 0);
        UICorner6.TopRightRadius = UDim.new(0.125, 0);
        UICorner6.Parent = Frame9;
        local TextLabel5 = Instance.new("TextLabel");
        TextLabel5.Name = "TextLabel";
        TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel5.BackgroundTransparency = 1;
        TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
        TextLabel5.Position = UDim2.fromScale(0.5, 0.5);
        TextLabel5.Size = UDim2.fromScale(0.8, 0.8);
        TextLabel5.Text = "NEW";
        TextLabel5.TextColor3 = Color3.fromRGB(40, 40, 48);
        TextLabel5.TextScaled = true;
        TextLabel5.Parent = Frame9;
        Frame9.Parent = TextButton;
    end;

    TextButton.Parent = p192;

    return TextButton;
end;

function u1.creditsTab(p200) -- Line: 2268
    local Frame = Instance.new("Frame");
    Frame.Name = "Credits";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Packs";
    Frame2.Active = true;
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.02);
    Frame2.Selectable = true;
    Frame2.SelectionGroup = true;
    Frame2.Size = UDim2.fromScale(0.72, 0.86);
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 2.15;
    UIAspectRatioConstraint.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Main";
    Frame3.BackgroundTransparency = 1;
    Frame3.Size = UDim2.fromScale(0.68, 1);
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(0.035, 0.03);
    UIGridLayout.CellSize = UDim2.fromScale(0.31, 0.485);
    UIGridLayout.FillDirectionMaxCells = 3;
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.Parent = Frame3;
    Frame3.Parent = Frame2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Disclaimer";
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.5, 1.035);
    Frame4.Size = UDim2.fromScale(1, 0.04);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "MainText";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.03, 0.5);
    TextLabel.RichText = true;
    TextLabel.Size = UDim2.fromScale(0.97, 0.8);
    TextLabel.Text = "<b><font color=\"#FFA500\">PLEASE NOTE:</font></b> Bonus Kredits are <b>already included</b> in the amount shown. Buying <b>220 Kredits</b> (which includes 20 bonus) gives you <b><font color=\"#55FF55\">220 Kredits total</font></b>, not 240.";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.35;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame4;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "IconInfo";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://80205853195967";
    ImageLabel.ImageTransparency = 0.35;
    ImageLabel.Position = UDim2.fromScale(0, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame4;
    Frame4.Parent = Frame2;
    Frame2.Parent = Frame;
    Frame.Parent = p200;

    return Frame;
end;

function u1.homeTab(p201) -- Line: 2351
    local Frame = Instance.new("Frame");
    Frame.Name = "Home";
    Frame.Active = true;
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundTransparency = 1;
    Frame.ClipsDescendants = true;
    Frame.Position = UDim2.fromScale(0.5, 0.0580001);
    Frame.Selectable = true;
    Frame.SelectionGroup = true;
    Frame.Size = UDim2.fromScale(1, 0.94);
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Hero";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = CanvasGroup;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0.006, 0);
    UIPadding.PaddingLeft = UDim.new(0.012, 0);
    UIPadding.PaddingRight = UDim.new(0.012, 0);
    UIPadding.PaddingTop = UDim.new(0.006, 0);
    UIPadding.Parent = CanvasGroup;
    Bundle = Instance.new("Frame");
    Bundle.Name = "Bundle";
    Bundle.AnchorPoint = Vector2.new(0.5, 0);
    Bundle.BackgroundTransparency = 1;
    Bundle.Position = UDim2.fromScale(0.5, 0.025);
    Bundle.Size = UDim2.fromScale(0.9, 0.5);
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(255, 45, 52);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.006;
    UIStroke.Transparency = 0.47;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.215116, 0.21875),
        NumberSequenceKeypoint.new(0.314482, 0.06875),
        NumberSequenceKeypoint.new(0.479915, 0.1875),
        NumberSequenceKeypoint.new(0.627378, 0.09375),
        NumberSequenceKeypoint.new(0.72463, 0.25625),
        NumberSequenceKeypoint.new(0.906977, 0.3125),
        NumberSequenceKeypoint.new(0.926533, 0.0625),
        NumberSequenceKeypoint.new(1, 0)
    });
    UIGradient.Parent = UIStroke;
    UIStroke.Parent = Bundle;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Background";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://119291554707383";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Crop;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.04, 0);
    UICorner.BottomRightRadius = UDim.new(0.04, 0);
    UICorner.CornerRadius = UDim.new(0.04, 0);
    UICorner.TopLeftRadius = UDim.new(0.04, 0);
    UICorner.TopRightRadius = UDim.new(0.04, 0);
    UICorner.Parent = ImageLabel;
    ImageLabel.Parent = Bundle;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Top";
    Frame2.BackgroundTransparency = 1;
    Frame2.Size = UDim2.fromScale(1, 0.8);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Timer";
    TextLabel.AnchorPoint = Vector2.new(1, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.fromScale(0.887481, 0.0790598);
    TextLabel.Size = UDim2.fromScale(0.0808535, 0.0755027);
    TextLabel.Text = "41:06:46:36";
    TextLabel.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel.TextStrokeTransparency = 5;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.ZIndex = 343;
    TextLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.0209924, 0.0317509);
    TextLabel2.Size = UDim2.fromScale(0.485742, 0.282139);
    TextLabel2.Text = "Alpha";
    TextLabel2.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextStrokeTransparency = 5;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 343;
    TextLabel2.Parent = Frame2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Article";
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.0227944, 0.290127);
    TextLabel3.Size = UDim2.fromScale(0.485742, 0.109142);
    TextLabel3.Text = "BUNDLE";
    TextLabel3.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextStrokeTransparency = 5;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.ZIndex = 343;
    TextLabel3.Parent = Frame2;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Description";
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.02, 0.469895);
    TextLabel4.Size = UDim2.fromScale(0.479137, 0.447313);
    TextLabel4.Text = "";
    TextLabel4.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel4.TextScaled = true;
    TextLabel4.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextStrokeTransparency = 5;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 343;
    TextLabel4.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Limited";
    Frame3.AnchorPoint = Vector2.new(1, 0);
    Frame3.BackgroundColor3 = Color3.fromRGB(240, 240, 240);
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.993553, 0.0768248);
    Frame3.Size = UDim2.fromScale(0.10497, 0.0863753);
    Frame3.ZIndex = 343;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(171, 171, 171)), ColorSequenceKeypoint.new(0.570934, Color3.fromRGB(226, 226, 226)), ColorSequenceKeypoint.new(1, Color3.fromRGB(227, 227, 227)) });
    UIGradient2.Rotation = 16;
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.00222222, 0),
        NumberSequenceKeypoint.new(0.98, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = Frame3;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "TextLabel";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel5.Size = UDim2.fromScale(0.8, 0.8);
    TextLabel5.Text = "LIMITED";
    TextLabel5.TextColor3 = Color3.fromRGB(77, 77, 77);
    TextLabel5.TextScaled = true;
    TextLabel5.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextStrokeTransparency = 5;
    TextLabel5.ZIndex = 343;
    TextLabel5.Parent = Frame3;
    Frame3.Parent = Frame2;
    Frame2.Parent = Bundle;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Price";
    Frame4.AnchorPoint = Vector2.new(1, 1);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(1, 0.948116);
    Frame4.Size = UDim2.fromScale(0.370212, 0.130723);
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Robux";
    TextButton.Active = false;
    TextButton.AnchorPoint = Vector2.new(1, 0.5);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton.BackgroundTransparency = 0.95;
    TextButton.Position = UDim2.fromScale(0.85, 0.5);
    TextButton.Size = UDim2.fromScale(0.225386, 0.8);
    TextButton.TextTransparency = 1;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Transparency = 0.875;
    UIStroke2.Parent = TextButton;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner2.BottomRightRadius = UDim.new(0.1, 0);
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.TopLeftRadius = UDim.new(0.1, 0);
    UICorner2.TopRightRadius = UDim.new(0.1, 0);
    UICorner2.Parent = TextButton;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Title";
    TextLabel6.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel6.Size = UDim2.fromScale(0.464995, 0.7);
    TextLabel6.Text = "999";
    TextLabel6.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel6.TextScaled = true;
    TextLabel6.Parent = TextButton;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Icon";
    TextLabel7.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.LayoutOrder = 1;
    TextLabel7.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel7.RichText = true;
    TextLabel7.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel7.Text = "";
    TextLabel7.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel7.TextScaled = true;
    TextLabel7.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel7.Parent = TextButton;
    TextButton.Parent = Frame4;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Gift";
    TextButton2.Active = false;
    TextButton2.AnchorPoint = Vector2.new(1, 0.5);
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundTransparency = 0.95;
    TextButton2.Position = UDim2.fromScale(0.95, 0.5);
    TextButton2.Size = UDim2.fromScale(0.8, 0.8);
    TextButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton2.TextTransparency = 1;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.new(1, 1, 1);
    UIStroke3.Transparency = 0.875;
    UIStroke3.Parent = TextButton2;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner3.BottomRightRadius = UDim.new(0.1, 0);
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.TopLeftRadius = UDim.new(0.1, 0);
    UICorner3.TopRightRadius = UDim.new(0.1, 0);
    UICorner3.Parent = TextButton2;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Icon";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://117975901841067";
    ImageLabel2.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel2.LayoutOrder = 1;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = TextButton2;
    TextButton2.Parent = Frame4;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Credits";
    TextButton3.Active = false;
    TextButton3.AnchorPoint = Vector2.new(1, 0.5);
    TextButton3.AutoButtonColor = false;
    TextButton3.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton3.BackgroundTransparency = 0.95;
    TextButton3.Position = UDim2.fromScale(0.606394, 0.5);
    TextButton3.Size = UDim2.fromScale(0.25, 0.8);
    TextButton3.TextTransparency = 1;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "Title";
    TextLabel8.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel8.Size = UDim2.fromScale(0.464995, 0.7);
    TextLabel8.Text = "2999";
    TextLabel8.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel8.TextScaled = true;
    TextLabel8.Parent = TextButton3;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Icon";
    ImageLabel3.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://138240378050344";
    ImageLabel3.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel3.LayoutOrder = 1;
    ImageLabel3.Position = UDim2.fromScale(0.02, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = TextButton3;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "UIStroke";
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.Color = Color3.new(1, 1, 1);
    UIStroke4.Transparency = 0.875;
    UIStroke4.Parent = TextButton3;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner4.BottomRightRadius = UDim.new(0.1, 0);
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.TopLeftRadius = UDim.new(0.1, 0);
    UICorner4.TopRightRadius = UDim.new(0.1, 0);
    UICorner4.Parent = TextButton3;
    TextButton3.Parent = Frame4;
    Frame4.Parent = Bundle;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Bottom";
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0, 1);
    Frame5.Size = UDim2.fromScale(1, 0.15);
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "ProgressBar";
    Frame6.AnchorPoint = Vector2.new(0.5, 0);
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame6.BackgroundTransparency = 0.8;
    Frame6.BorderColor3 = Color3.new();
    Frame6.BorderSizePixel = 0;
    Frame6.Position = UDim2.fromScale(0.5, 0.126);
    Frame6.Size = UDim2.fromScale(0.98, 0.12);
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Bar";
    Frame7.AnchorPoint = Vector2.new(0, 0.5);
    Frame7.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame7.BorderColor3 = Color3.new();
    Frame7.BorderSizePixel = 0;
    Frame7.Position = UDim2.fromScale(0, 0.5);
    Frame7.Size = UDim2.fromScale(0.720349, 1);
    Frame7.Parent = Frame6;
    Frame6.Parent = Frame5;
    Frame5.Parent = Bundle;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.BottomLeftRadius = UDim.new(0.04, 0);
    UICorner5.BottomRightRadius = UDim.new(0.04, 0);
    UICorner5.CornerRadius = UDim.new(0.04, 0);
    UICorner5.TopLeftRadius = UDim.new(0.04, 0);
    UICorner5.TopRightRadius = UDim.new(0.04, 0);
    UICorner5.Parent = Bundle;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "LeftArrow";
    ImageButton.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://122092056328472";
    ImageButton.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageButton.Position = UDim2.fromScale(0.005, 0.5);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(0.11, 0.11);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton.Parent = Bundle;
    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "UIShadow";
    UIShadow.BlurRadius = UDim.new(0.1, 0);
    UIShadow.Transparency = 0.21;
    UIShadow.Parent = Bundle;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 3.47;
    UIAspectRatioConstraint.Parent = Bundle;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "RightArrow";
    ImageButton2.AnchorPoint = Vector2.new(1, 0.5);
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://122092056328472";
    ImageButton2.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageButton2.Position = UDim2.fromScale(0.995, 0.5);
    ImageButton2.Rotation = 180;
    ImageButton2.ScaleType = Enum.ScaleType.Fit;
    ImageButton2.Size = UDim2.fromScale(0.11, 0.11);
    ImageButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton2.Parent = Bundle;
    Bundle.Parent = CanvasGroup;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Items";
    Frame8.AnchorPoint = Vector2.new(0.5, 1);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.5, 1);
    Frame8.Size = UDim2.fromScale(1, 0.471428);
    BundleItems = Instance.new("Frame");
    BundleItems.Name = "Items";
    BundleItems.AnchorPoint = Vector2.new(0.5, 0.5);
    BundleItems.BackgroundTransparency = 1;
    BundleItems.Position = UDim2.fromScale(0.5, 0.550195);
    BundleItems.Size = UDim2.fromScale(1, 0.899609);
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(0.015, 0);
    UIGridLayout.CellSize = UDim2.fromScale(0.23, 0.8);
    UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.AspectRatio = 1.01;
    UIAspectRatioConstraint2.Parent = UIGridLayout;
    UIGridLayout.Parent = BundleItems;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingLeft = UDim.new(0.05, 0);
    UIPadding2.PaddingRight = UDim.new(0.05, 0);
    UIPadding2.Parent = BundleItems;
    BundleItems.Parent = Frame8;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "Title";
    TextLabel9.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(0.5, 0.075);
    TextLabel9.Size = UDim2.fromScale(0.14, 0.071);
    TextLabel9.Text = "BUNDLE ITEMS";
    TextLabel9.TextColor3 = Color3.new(1, 1, 1);
    TextLabel9.TextScaled = true;
    TextLabel9.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel9.TextStrokeTransparency = 5;
    TextLabel9.ZIndex = 343;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Frame";
    Frame9.AnchorPoint = Vector2.new(1, 0.5);
    Frame9.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame9.BackgroundTransparency = 0.2;
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.Position = UDim2.new(0, 0, 0.5, -1);
    Frame9.Size = UDim2.new(1.5, 0, 0, 2);
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) });
    UIGradient3.Parent = Frame9;
    Frame9.Parent = TextLabel9;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Frame";
    Frame10.AnchorPoint = Vector2.new(0, 0.5);
    Frame10.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame10.BackgroundTransparency = 0.2;
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.new(1, 0, 0.5, -1);
    Frame10.Size = UDim2.new(1.5, 0, 0, 2);
    local UIGradient4 = Instance.new("UIGradient");
    UIGradient4.Name = "UIGradient";
    UIGradient4.Rotation = 180;
    UIGradient4.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) });
    UIGradient4.Parent = Frame10;
    Frame10.Parent = TextLabel9;
    local UIShadow2 = Instance.new("UIShadow");
    UIShadow2.Name = "UIShadow";
    UIShadow2.BlurRadius = UDim.new(1, 0);
    UIShadow2.Spread = UDim2.fromScale(-0.1, 0);
    UIShadow2.Transparency = 0.67;
    UIShadow2.Parent = TextLabel9;
    TextLabel9.Parent = Frame8;
    Frame8.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Blackout";
    Frame11.BackgroundColor3 = Color3.new();
    Frame11.BackgroundTransparency = 1;
    Frame11.BorderSizePixel = 0;
    Frame11.Interactable = false;
    Frame11.Size = UDim2.fromScale(1, 1);
    Frame11.ZIndex = 2;
    Frame11.Parent = Frame;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "Scroll";
    ScrollingFrame.Active = false;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.ScrollBarThickness = 8;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.Size = UDim2.fromScale(1, 1);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.ZIndex = 3;
    ScrollingFrame.Parent = Frame;
    Frame.Parent = p201;

    return Frame;
end;

function u1.homeSection(p202, p203, p204, p205, p206) -- Line: 2944
    local Frame = Instance.new("Frame");
    Frame.Name = p203;
    Frame.BackgroundTransparency = 1;

    if p204 then
        local v207 = p202.Hero.Items.Title:Clone();
        v207.Text = p204;
        v207.Parent = Frame;
    end;

    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Items";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundTransparency = 1;

    if p205 then
        local UIGridLayout = Instance.new("UIGridLayout");
        UIGridLayout.Name = "UIGridLayout";
        UIGridLayout.FillDirectionMaxCells = p205;
        UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
        UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
        UIAspectRatioConstraint.AspectRatio = p206;
        UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
        UIAspectRatioConstraint.Parent = UIGridLayout;
        UIGridLayout.Parent = Frame2;
    end;

    Frame2.Parent = Frame;
    Frame.Parent = p202.Scroll;

    return Frame2;
end;

function u1.bundleItem(p208, p209, p210, p211, p212, p213, p214) -- Line: 2983
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "StoreFrame";
    TextButton.Active = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.Size = UDim2.fromOffset(100, 100);
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Icon";
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = `rbxassetid://{p212}`;
    ImageButton.Interactable = true;
    ImageButton.Position = UDim2.fromScale(0.5, 0.287589);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(0.98, 0.575374);
    ImageButton.ZIndex = 15;
    ImageButton.Parent = TextButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Shadow";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://186491278";
    ImageLabel.ImageTransparency = 0.24;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Slice;
    ImageLabel.Size = UDim2.new(1, 30, 1, 30);
    ImageLabel.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel.Visible = false;
    ImageLabel.ZIndex = -9999;
    ImageLabel.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "ItemName";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.504, 0.6);
    TextLabel.Size = UDim2.fromScale(0.891734, 0.088421);
    TextLabel.Text = `{p209} | {p210}`;
    TextLabel.TextColor3 = Color3.fromRGB(222, 222, 222);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.85;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = TextButton;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Frame";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    CanvasGroup.Interactable = false;
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    CanvasGroup.ZIndex = -1;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.Parent = CanvasGroup;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = p213;
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.004;
    UIStroke.Transparency = 0.68;
    UIStroke.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "Color";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = p213;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) });
    UIGradient.Parent = Frame;
    Frame.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 0.788419);
    Frame2.Size = UDim2.fromScale(1, 0.423161);
    Frame2.ZIndex = 3;
    Frame2.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BackgroundTransparency = 0.9;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 0.576839);
    Frame3.Size = UDim2.new(1, 0, 0, 1);
    Frame3.ZIndex = 4;
    Frame3.Parent = CanvasGroup;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "ImageColor";
    Frame4.AnchorPoint = Vector2.new(1, 0.5);
    Frame4.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
    Frame4.Position = UDim2.fromScale(1, 0.499999);
    Frame4.Size = UDim2.fromScale(0.99, 0.995);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.Parent = Frame4;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Frame";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundColor3 = p213;
    ImageLabel2.BorderColor3 = Color3.new();
    ImageLabel2.BorderSizePixel = 0;
    ImageLabel2.Image = p214;
    ImageLabel2.ImageColor3 = p213;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = -39;
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.71875),
        NumberSequenceKeypoint.new(0.498943, 0.96875),
        NumberSequenceKeypoint.new(0.846195, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = ImageLabel2;
    ImageLabel2.Parent = Frame4;
    Frame4.Parent = CanvasGroup;
    CanvasGroup.Parent = TextButton;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Price";
    Frame5.AnchorPoint = Vector2.new(1, 1);
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(1, 0.99);
    Frame5.Size = UDim2.fromScale(1, 0.159575);
    Frame5.ZIndex = 10;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Robux";
    TextButton2.Active = false;
    TextButton2.AnchorPoint = Vector2.new(1, 0.5);
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundTransparency = 0.95;
    TextButton2.LayoutOrder = 2;
    TextButton2.Position = UDim2.fromScale(0.85, 0.5);
    TextButton2.Size = UDim2.fromScale(0.3, 0.8);
    TextButton2.TextTransparency = 1;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Transparency = 0.875;
    UIStroke2.Parent = TextButton2;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner3.BottomRightRadius = UDim.new(0.1, 0);
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.TopLeftRadius = UDim.new(0.1, 0);
    UICorner3.TopRightRadius = UDim.new(0.1, 0);
    UICorner3.Parent = TextButton2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel2.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel2.Text = "999";
    TextLabel2.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel2.TextScaled = true;
    TextLabel2.Parent = TextButton2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Icon";
    TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.LayoutOrder = 1;
    TextLabel3.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel3.RichText = true;
    TextLabel3.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel3.Text = "";
    TextLabel3.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel3.Parent = TextButton2;
    TextButton2.Parent = Frame5;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Gift";
    TextButton3.Active = false;
    TextButton3.AnchorPoint = Vector2.new(1, 0.5);
    TextButton3.AutoButtonColor = false;
    TextButton3.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton3.BackgroundTransparency = 0.95;
    TextButton3.LayoutOrder = 3;
    TextButton3.Position = UDim2.fromScale(0.95, 0.5);
    TextButton3.Size = UDim2.fromScale(1.2, 0.8);
    TextButton3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton3.TextTransparency = 1;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.new(1, 1, 1);
    UIStroke3.Transparency = 0.875;
    UIStroke3.Parent = TextButton3;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner4.BottomRightRadius = UDim.new(0.1, 0);
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.TopLeftRadius = UDim.new(0.1, 0);
    UICorner4.TopRightRadius = UDim.new(0.1, 0);
    UICorner4.Parent = TextButton3;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Icon";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://117975901841067";
    ImageLabel3.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel3.LayoutOrder = 1;
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = TextButton3;
    TextButton3.Parent = Frame5;
    local TextButton4 = Instance.new("TextButton");
    TextButton4.Name = "Credits";
    TextButton4.Active = false;
    TextButton4.AnchorPoint = Vector2.new(1, 0.5);
    TextButton4.AutoButtonColor = false;
    TextButton4.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton4.BackgroundTransparency = 0.95;
    TextButton4.LayoutOrder = 1;
    TextButton4.Position = UDim2.fromScale(0.606394, 0.5);
    TextButton4.Size = UDim2.fromScale(0.35, 0.8);
    TextButton4.TextTransparency = 1;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel4.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel4.Text = "2999";
    TextLabel4.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel4.TextScaled = true;
    TextLabel4.Parent = TextButton4;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Icon";
    ImageLabel4.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://138240378050344";
    ImageLabel4.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel4.LayoutOrder = 1;
    ImageLabel4.Position = UDim2.fromScale(0.02, 0.5);
    ImageLabel4.ScaleType = Enum.ScaleType.Fit;
    ImageLabel4.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = TextButton4;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "UIStroke";
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.Color = Color3.new(1, 1, 1);
    UIStroke4.Transparency = 0.875;
    UIStroke4.Parent = TextButton4;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner5.BottomRightRadius = UDim.new(0.1, 0);
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.TopLeftRadius = UDim.new(0.1, 0);
    UICorner5.TopRightRadius = UDim.new(0.1, 0);
    UICorner5.Parent = TextButton4;
    TextButton4.Parent = Frame5;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.025, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame5;
    Frame5.Parent = TextButton;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Blur";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.Interactable = false;
    Frame6.Position = UDim2.fromScale(0.5, 0.5);
    Frame6.Size = UDim2.fromScale(1, 1);
    Frame6.ZIndex = -2;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Color";
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.5, 0.286314);
    Frame7.Size = UDim2.fromScale(1, 0.572628);
    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "UIShadow";
    UIShadow.BlurRadius = UDim.new(0.1, 0);
    UIShadow.Color = p213;
    UIShadow.Parent = Frame7;
    Frame7.Parent = Frame6;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Main";
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.5, 0.786314);
    Frame8.Size = UDim2.fromScale(1, 0.427372);
    local UIShadow2 = Instance.new("UIShadow");
    UIShadow2.Name = "UIShadow";
    UIShadow2.BlurRadius = UDim.new(0.1, 0);
    UIShadow2.Parent = Frame8;
    Frame8.Parent = Frame6;
    Frame6.Parent = TextButton;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "ClassName";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.504, 0.69);
    TextLabel5.Size = UDim2.fromScale(0.891734, 0.0715785);
    TextLabel5.Text = p211;
    TextLabel5.TextColor3 = Color3.fromRGB(222, 222, 222);
    TextLabel5.TextScaled = true;
    TextLabel5.TextStrokeTransparency = 0.85;
    TextLabel5.TextTransparency = 0.5;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.Parent = TextButton;
    local TextButton5 = Instance.new("TextButton");
    TextButton5.Name = "Inspect";
    TextButton5.Active = false;
    TextButton5.Interactable = false;
    TextButton5.AnchorPoint = Vector2.new(1, 0.5);
    TextButton5.AutoButtonColor = false;
    TextButton5.BackgroundTransparency = 1;
    TextButton5.LayoutOrder = 3;
    TextButton5.Position = UDim2.fromScale(0.96, 0.08);
    TextButton5.Size = UDim2.fromScale(0.085, 0.0800044);
    TextButton5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton5.TextTransparency = 1;
    TextButton5.ZIndex = 8;
    local UIStroke5 = Instance.new("UIStroke");
    UIStroke5.Name = "UIStroke";
    UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke5.Color = Color3.new(1, 1, 1);
    UIStroke5.Transparency = 0.8;
    UIStroke5.Parent = TextButton5;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UICorner";
    UICorner6.BottomLeftRadius = UDim.new(0.4, 0);
    UICorner6.BottomRightRadius = UDim.new(0.4, 0);
    UICorner6.CornerRadius = UDim.new(0.4, 0);
    UICorner6.TopLeftRadius = UDim.new(0.4, 0);
    UICorner6.TopRightRadius = UDim.new(0.4, 0);
    UICorner6.Parent = TextButton5;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Icon";
    ImageLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://112684033134382";
    ImageLabel5.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel5.LayoutOrder = 1;
    ImageLabel5.Position = UDim2.new(0.5, 0, 0.5, 2);
    ImageLabel5.ScaleType = Enum.ScaleType.Fit;
    ImageLabel5.Size = UDim2.fromScale(2, 2);
    ImageLabel5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel5.Parent = TextButton5;
    TextButton5.Parent = TextButton;
    TextButton.Parent = p208;

    return TextButton;
end;

function u1.creditsIcon(p215, p216, p217) -- Line: 3429
    local Frame = Instance.new("Frame");
    Frame.Name = "Icon";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.8;
    Frame.Position = p216;
    Frame.Size = p217;
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame.ZIndex = 5;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 0.8;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(0.756, 0.756);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame2;
    Frame2.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Logo";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://138240378050344";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel.Parent = Frame;
    Frame.Parent = p215;

    return Frame;
end;

function u1.creditsFrame(p218, p219, p220, p221, p222) -- Line: 3481
    -- upvalues: u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "CreditsFrame";
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = p221;
    Frame.Size = UDim2.fromOffset(100, 100);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Transparency = 0.7;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6, 0.6), NumberSequenceKeypoint.new(1, 0.85) });
    UIGradient.Parent = UIStroke;
    UIStroke.Parent = Frame;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "CanvasGroup";
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
    CanvasGroup.Interactable = false;
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    CanvasGroup.ZIndex = -1;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Color";
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 0.75;
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.fromScale(1, 1);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = 90;
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.45),
        NumberSequenceKeypoint.new(0.45, 0.8),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = Frame2;
    Frame2.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Bottom";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.fromScale(1, 0.4);
    Frame3.ZIndex = 2;
    Frame3.Parent = CanvasGroup;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Line";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BackgroundTransparency = 0.9;
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0.5, 0.6);
    Frame4.Size = UDim2.new(1, 0, 0, 1);
    Frame4.ZIndex = 3;
    Frame4.Parent = CanvasGroup;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Shine";
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BorderSizePixel = 0;
    Frame5.Size = UDim2.fromScale(1, 1);
    Frame5.ZIndex = 4;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Offset = Vector2.new(-1, 0);
    UIGradient3.Rotation = 25;
    UIGradient3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 1),
        NumberSequenceKeypoint.new(0.5, 0.88),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient3.Parent = Frame5;
    Frame5.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Blur";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.Interactable = false;
    Frame6.Position = UDim2.fromScale(0.5, 0.5);
    Frame6.Size = UDim2.fromScale(1, 1);
    Frame6.ZIndex = -2;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Color";
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.5, 0.3);
    Frame7.Size = UDim2.fromScale(1, 0.6);
    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "UIShadow";
    UIShadow.BlurRadius = UDim.new(0.1, 0);
    UIShadow.Spread = UDim2.fromScale(-0.05, -0.05);
    UIShadow.Transparency = 0.55;
    UIShadow.Parent = Frame7;
    Frame7.Parent = Frame6;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Main";
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.5, 0.8);
    Frame8.Size = UDim2.fromScale(1, 0.4);
    local UIShadow2 = Instance.new("UIShadow");
    UIShadow2.Name = "UIShadow";
    UIShadow2.BlurRadius = UDim.new(0.1, 0);
    UIShadow2.Spread = UDim2.fromScale(-0.05, -0.05);
    UIShadow2.Parent = Frame8;
    Frame8.Parent = Frame6;
    Frame6.Parent = Frame;

    if p222 then
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Tag";
        TextLabel.BackgroundTransparency = 1;
        TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Italic);
        TextLabel.Position = UDim2.fromScale(0.05, 0.045);
        TextLabel.Size = UDim2.fromScale(0.6, 0.085);
        TextLabel.Text = p222;
        TextLabel.TextColor3 = Color3.new(1, 1, 1);
        TextLabel.TextScaled = true;
        TextLabel.TextStrokeTransparency = 0.85;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel.ZIndex = 10;
        local UIGradient4 = Instance.new("UIGradient");
        UIGradient4.Name = "UIGradient";
        UIGradient4.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(175, 175, 185)) });
        UIGradient4.Rotation = 90;
        UIGradient4.Parent = TextLabel;
        TextLabel.Parent = Frame;
    end;

    u1.creditsIcon(Frame, UDim2.fromScale(0.5, 0.3), UDim2.fromScale(0.42, 0.42));
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Amount";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.06, 0.69);
    TextLabel.Size = UDim2.fromScale(0.58, 0.1);
    TextLabel.Text = `{p219} KREDITS`;
    TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;

    if p220 > 0 then
        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Name = "Bonus";
        TextLabel2.AnchorPoint = Vector2.new(1, 0.5);
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        TextLabel2.Position = UDim2.fromScale(0.94, 0.69);
        TextLabel2.Size = UDim2.fromScale(0.3, 0.07);
        TextLabel2.Text = `{p220} Bonus`;
        TextLabel2.TextColor3 = Color3.fromRGB(222, 222, 222);
        TextLabel2.TextScaled = true;
        TextLabel2.TextTransparency = 0.5;
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
        TextLabel2.Parent = Frame;
    end;

    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Price";
    Frame9.AnchorPoint = Vector2.new(0.5, 1);
    Frame9.BackgroundTransparency = 1;
    Frame9.Position = UDim2.fromScale(0.5, 0.96);
    Frame9.Size = UDim2.fromScale(0.88, 0.135);
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Robux";
    TextButton.Active = false;
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton.BackgroundTransparency = 0.95;
    TextButton.LayoutOrder = 1;
    TextButton.Size = UDim2.fromScale(0.8, 1);
    TextButton.TextTransparency = 1;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Transparency = 0.875;
    UIStroke2.Parent = TextButton;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.Parent = TextButton;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.92, 0.525);
    TextLabel2.Size = UDim2.fromScale(0.55, 0.75);
    TextLabel2.Text = "???";
    TextLabel2.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel2.ZIndex = 2;
    TextLabel2.Parent = TextButton;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Icon";
    TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.Position = UDim2.fromScale(0.06, 0.5);
    TextLabel3.RichText = true;
    TextLabel3.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel3.Text = "";
    TextLabel3.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 2;
    TextLabel3.Parent = TextButton;
    TextButton.Parent = Frame9;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Gift";
    TextButton2.Active = false;
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundTransparency = 0.95;
    TextButton2.LayoutOrder = 2;
    TextButton2.Size = UDim2.fromScale(1, 1);
    TextButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton2.TextTransparency = 1;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.new(1, 1, 1);
    UIStroke3.Transparency = 0.875;
    UIStroke3.Parent = TextButton2;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = TextButton2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://117975901841067";
    ImageLabel.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel.Parent = TextButton2;
    TextButton2.Parent = Frame9;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.025, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame9;
    Frame9.Parent = Frame;
    Frame.Parent = p218;

    return Frame;
end;

function u1.creditsBonusFrame(p223, p224, p225, p226, p227, p228, p229, p230, p231, p232) -- Line: 3811
    -- upvalues: u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Featured";
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(1, 0);
    Frame.Size = UDim2.fromScale(0.3, 1);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 0.25;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, p227),
        ColorSequenceKeypoint.new(0.4, p227),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 248, 225)),
        ColorSequenceKeypoint.new(0.6, p227),
        ColorSequenceKeypoint.new(1, p227)
    });
    UIGradient.Parent = UIStroke;
    UIStroke.Parent = Frame;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "CanvasGroup";
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
    CanvasGroup.Interactable = false;
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    CanvasGroup.ZIndex = -1;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Color";
    Frame2.BackgroundColor3 = p227;
    Frame2.BackgroundTransparency = 0.35;
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.fromScale(1, 1);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = 90;
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.5, 0.75),
        NumberSequenceKeypoint.new(0.62, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = Frame2;
    Frame2.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Bottom";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.fromScale(1, 0.4);
    Frame3.ZIndex = 2;
    Frame3.Parent = CanvasGroup;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Line";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BackgroundTransparency = 0.9;
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0.5, 0.6);
    Frame4.Size = UDim2.new(1, 0, 0, 1);
    Frame4.ZIndex = 3;
    Frame4.Parent = CanvasGroup;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Shine";
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BorderSizePixel = 0;
    Frame5.Size = UDim2.fromScale(1, 1);
    Frame5.ZIndex = 4;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Offset = Vector2.new(-1, 0);
    UIGradient3.Rotation = 25;
    UIGradient3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 1),
        NumberSequenceKeypoint.new(0.5, 0.85),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient3.Parent = Frame5;
    Frame5.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Blur";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.Interactable = false;
    Frame6.Position = UDim2.fromScale(0.5, 0.5);
    Frame6.Size = UDim2.fromScale(1, 1);
    Frame6.ZIndex = -2;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Color";
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.5, 0.5);
    Frame7.Size = UDim2.fromScale(1, 1);
    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "UIShadow";
    UIShadow.BlurRadius = UDim.new(0.1, 0);
    UIShadow.Color = p227;
    UIShadow.Spread = UDim2.fromScale(-0.04, -0.04);
    UIShadow.Transparency = 0.4;
    UIShadow.Parent = Frame7;
    Frame7.Parent = Frame6;
    Frame6.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Tag";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Italic);
    TextLabel.Position = UDim2.fromScale(0.06, 0.03);
    TextLabel.Size = UDim2.fromScale(0.5, 0.048);
    TextLabel.Text = p228;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.85;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 10;
    local UIGradient4 = Instance.new("UIGradient");
    UIGradient4.Name = "UIGradient";
    UIGradient4.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(175, 175, 185)) });
    UIGradient4.Rotation = 90;
    UIGradient4.Parent = TextLabel;
    TextLabel.Parent = Frame;
    u1.creditsIcon(Frame, UDim2.fromScale(0.5, 0.25), UDim2.fromScale(0.26, 0.26));
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Amount";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.465);
    TextLabel2.Size = UDim2.fromScale(0.85, 0.065);
    TextLabel2.Text = `{p224} KREDITS`;
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.ZIndex = 5;
    local UIGradient5 = Instance.new("UIGradient");
    UIGradient5.Name = "UIGradient";
    UIGradient5.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, p227), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 248, 225)), ColorSequenceKeypoint.new(1, p227) });
    UIGradient5.Rotation = 15;
    UIGradient5.Parent = TextLabel2;
    TextLabel2.Parent = Frame;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Bonus";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.525);
    TextLabel3.Size = UDim2.fromScale(0.5, 0.035);
    TextLabel3.Text = `{p225} Bonus`;
    TextLabel3.TextColor3 = Color3.fromRGB(222, 222, 222);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.4;
    TextLabel3.ZIndex = 5;
    TextLabel3.Parent = Frame;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Item";
    ImageButton.AnchorPoint = Vector2.new(0.5, 0);
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = p232;
    ImageButton.BackgroundTransparency = 0.85;
    ImageButton.Position = UDim2.fromScale(0.5, 0.625);
    ImageButton.Size = UDim2.fromScale(0.9, 0.205);
    ImageButton.ZIndex = 5;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.Parent = ImageButton;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = p232;
    UIStroke2.Transparency = 0.6;
    UIStroke2.Parent = ImageButton;
    local UIGradient6 = Instance.new("UIGradient");
    UIGradient6.Name = "UIGradient";
    UIGradient6.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.8) });
    UIGradient6.Parent = ImageButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Thumbnail";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = `rbxassetid://{p230}`;
    ImageLabel.Position = UDim2.fromScale(0.03, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.42, 0.9);
    ImageLabel.ZIndex = 6;
    ImageLabel.Parent = ImageButton;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Caption";
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.49, 0.17);
    TextLabel4.Size = UDim2.fromScale(0.46, 0.15);
    TextLabel4.Text = "+ BONUS ITEM";
    TextLabel4.TextColor3 = Color3.fromRGB(222, 222, 222);
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.45;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 6;
    TextLabel4.Parent = ImageButton;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "ItemName";
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.49, 0.35);
    TextLabel5.Size = UDim2.fromScale(0.46, 0.24);
    TextLabel5.Text = p229;
    TextLabel5.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel5.TextScaled = true;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.ZIndex = 6;
    TextLabel5.Parent = ImageButton;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Rarity";
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.49, 0.62);
    TextLabel6.Size = UDim2.fromScale(0.46, 0.17);
    TextLabel6.Text = p231;
    TextLabel6.TextColor3 = p232;
    TextLabel6.TextScaled = true;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel6.ZIndex = 6;
    TextLabel6.Parent = ImageButton;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Inspect";
    TextButton.Active = false;
    TextButton.AnchorPoint = Vector2.new(1, 0);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.Interactable = false;
    TextButton.Position = UDim2.fromScale(0.97, 0.08);
    TextButton.Size = UDim2.fromScale(0.22, 0.22);
    TextButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton.TextTransparency = 1;
    TextButton.ZIndex = 8;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.new(1, 1, 1);
    UIStroke3.Transparency = 0.8;
    UIStroke3.Parent = TextButton;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.4, 0);
    UICorner4.Parent = TextButton;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Icon";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://112684033134382";
    ImageLabel2.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel2.Position = UDim2.new(0.5, 0, 0.5, 2);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(2, 2);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.ZIndex = 8;
    ImageLabel2.Parent = TextButton;
    TextButton.Parent = ImageButton;
    ImageButton.Parent = Frame;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Price";
    Frame8.AnchorPoint = Vector2.new(0.5, 1);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.5, 0.965);
    Frame8.Size = UDim2.fromScale(0.9, 0.085);
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Robux";
    TextButton2.Active = false;
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundTransparency = 0.95;
    TextButton2.LayoutOrder = 1;
    TextButton2.Size = UDim2.fromScale(0.82, 1);
    TextButton2.TextTransparency = 1;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "UIStroke";
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.Color = Color3.new(1, 1, 1);
    UIStroke4.Transparency = 0.875;
    UIStroke4.Parent = TextButton2;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.Parent = TextButton2;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Title";
    TextLabel7.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.92, 0.525);
    TextLabel7.Size = UDim2.fromScale(0.55, 0.75);
    TextLabel7.Text = "???";
    TextLabel7.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel7.TextScaled = true;
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel7.ZIndex = 2;
    TextLabel7.Parent = TextButton2;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "Icon";
    TextLabel8.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.Position = UDim2.fromScale(0.05, 0.5);
    TextLabel8.RichText = true;
    TextLabel8.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel8.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel8.Text = "";
    TextLabel8.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel8.TextScaled = true;
    TextLabel8.ZIndex = 2;
    TextLabel8.Parent = TextButton2;
    TextButton2.Parent = Frame8;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Gift";
    TextButton3.Active = false;
    TextButton3.AutoButtonColor = false;
    TextButton3.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton3.BackgroundTransparency = 0.95;
    TextButton3.LayoutOrder = 2;
    TextButton3.Size = UDim2.fromScale(1, 1);
    TextButton3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton3.TextTransparency = 1;
    local UIStroke5 = Instance.new("UIStroke");
    UIStroke5.Name = "UIStroke";
    UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke5.Color = Color3.new(1, 1, 1);
    UIStroke5.Transparency = 0.875;
    UIStroke5.Parent = TextButton3;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UICorner";
    UICorner6.CornerRadius = UDim.new(0.1, 0);
    UICorner6.Parent = TextButton3;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Icon";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://117975901841067";
    ImageLabel3.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel3.Parent = TextButton3;
    TextButton3.Parent = Frame8;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.025, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame8;
    Frame8.Parent = Frame;
    Frame.Parent = p223;

    return Frame;
end;

function u1.creditsLabel(p233) -- Line: 4271
    local Frame = Instance.new("Frame");
    Frame.Name = "Credits";
    Frame.AnchorPoint = Vector2.new(1, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(253, 253, 253);
    Frame.BackgroundTransparency = 0.95;
    Frame.Position = UDim2.fromScale(p233 and 0.85 or 0.97, 0.5);
    Frame.Size = UDim2.fromScale(p233 and 0.29 or 0.062546, 0.6);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.29124, 0.525);
    TextLabel.Size = UDim2.fromScale(0.582481, 0.8);
    TextLabel.Text = "1000";
    TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://138240378050344";
    ImageLabel.ImageColor3 = Color3.fromRGB(240, 240, 240);
    ImageLabel.Position = UDim2.fromScale(0.95, 0.538124);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Transparency = 0.875;
    UIStroke.Parent = Frame;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "BuyCredits";
    ImageButton.Active = true;
    ImageButton.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton.BackgroundColor3 = Color3.fromRGB(253, 253, 253);
    ImageButton.BackgroundTransparency = 0.95;
    ImageButton.Position = UDim2.fromScale(1.075, 0.5);
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel2.Size = UDim2.fromScale(1, 1);
    TextLabel2.Text = "+";
    TextLabel2.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel2.TextScaled = true;
    TextLabel2.Parent = ImageButton;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = ImageButton;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Transparency = 0.875;
    UIStroke2.Parent = ImageButton;
    ImageButton.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Lock";
    Frame2.AnchorPoint = Vector2.new(1, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(253, 253, 253);
    Frame2.BackgroundTransparency = 0.95;
    Frame2.Position = UDim2.fromScale(-0.075, 0.5);
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame2.Visible = false;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Icon";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://108829592125034";
    ImageLabel2.ImageColor3 = Color3.fromRGB(240, 240, 240);
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.Parent = Frame2;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.Parent = Frame2;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.new(1, 1, 1);
    UIStroke3.Transparency = 0.875;
    UIStroke3.Parent = Frame2;
    Frame2.Parent = Frame;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Breakdown";
    CanvasGroup.AnchorPoint = Vector2.new(1, 0);
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(16, 17, 20);
    CanvasGroup.BackgroundTransparency = 0.1;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Position = UDim2.new(1, 0, 1, 6);
    CanvasGroup.Size = UDim2.fromScale(4.4, 1.9);
    CanvasGroup.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    CanvasGroup.Visible = false;
    CanvasGroup.ZIndex = 50;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = CanvasGroup;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "UIStroke";
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.BorderStrokePosition = Enum.BorderStrokePosition.Inner;
    UIStroke4.Color = Color3.new(1, 1, 1);
    UIStroke4.Transparency = 0.875;
    UIStroke4.Parent = CanvasGroup;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0.12, 0);
    UIPadding.PaddingLeft = UDim.new(0.05, 0);
    UIPadding.PaddingRight = UDim.new(0.05, 0);
    UIPadding.PaddingTop = UDim.new(0.12, 0);
    UIPadding.Parent = CanvasGroup;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.Padding = UDim.new(0.1, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = CanvasGroup;

    for i, v in { { "Own", "rbxassetid://138240378050344", "Kredits" }, { "Locked", "rbxassetid://108829592125034", "Tradelocked" } } do
        local Frame3 = Instance.new("Frame");
        Frame3.Name = v[1];
        Frame3.BackgroundTransparency = 1;
        Frame3.LayoutOrder = i;
        Frame3.Size = UDim2.fromScale(1, 0.45);
        local ImageLabel3 = Instance.new("ImageLabel");
        ImageLabel3.Name = "Icon";
        ImageLabel3.AnchorPoint = Vector2.new(0, 0.5);
        ImageLabel3.BackgroundTransparency = 1;
        ImageLabel3.Image = v[2];
        ImageLabel3.ImageColor3 = Color3.fromRGB(240, 240, 240);
        ImageLabel3.Position = UDim2.fromScale(0, 0.5);
        ImageLabel3.ScaleType = Enum.ScaleType.Fit;
        ImageLabel3.Size = UDim2.fromScale(0.8, 0.8);
        ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        ImageLabel3.Parent = Frame3;
        local TextLabel3 = Instance.new("TextLabel");
        TextLabel3.Name = "Value";
        TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
        TextLabel3.BackgroundTransparency = 1;
        TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        TextLabel3.Position = UDim2.fromScale(0.17, 0.5);
        TextLabel3.Size = UDim2.fromScale(0.43, 0.85);
        TextLabel3.Text = "0";
        TextLabel3.TextColor3 = Color3.fromRGB(240, 240, 240);
        TextLabel3.TextScaled = true;
        TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel3.Parent = Frame3;
        local TextLabel4 = Instance.new("TextLabel");
        TextLabel4.Name = "Caption";
        TextLabel4.AnchorPoint = Vector2.new(1, 0.5);
        TextLabel4.BackgroundTransparency = 1;
        TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
        TextLabel4.Position = UDim2.fromScale(1, 0.5);
        TextLabel4.Size = UDim2.fromScale(0.4, 0.65);
        TextLabel4.Text = v[3];
        TextLabel4.TextColor3 = Color3.fromRGB(150, 150, 150);
        TextLabel4.TextScaled = true;
        TextLabel4.TextXAlignment = Enum.TextXAlignment.Right;
        TextLabel4.Parent = Frame3;
        Frame3.Parent = CanvasGroup;
    end;

    CanvasGroup.Parent = Frame;

    return Frame;
end;

function u1.gamepassFrame(p234, p235, p236, p237, p238, p239, p240) -- Line: 4497
    local Frame = Instance.new("Frame");
    Frame.Name = p235;
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = p239;
    Frame.Size = UDim2.fromOffset(100, 100);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = p240;
    UIStroke.Transparency = 0.45;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6, 0.6), NumberSequenceKeypoint.new(1, 0.85) });
    UIGradient.Parent = UIStroke;
    UIStroke.Parent = Frame;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "CanvasGroup";
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
    CanvasGroup.Interactable = false;
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    CanvasGroup.ZIndex = -1;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Color";
    Frame2.BackgroundColor3 = p240;
    Frame2.BackgroundTransparency = 0.45;
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.fromScale(1, 1);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = 90;
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.45),
        NumberSequenceKeypoint.new(0.45, 0.8),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = Frame2;
    Frame2.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Bottom";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.fromScale(1, 0.4);
    Frame3.ZIndex = 2;
    Frame3.Parent = CanvasGroup;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Line";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BackgroundTransparency = 0.9;
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0.5, 0.6);
    Frame4.Size = UDim2.new(1, 0, 0, 1);
    Frame4.ZIndex = 3;
    Frame4.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Blur";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.BackgroundTransparency = 1;
    Frame5.Interactable = false;
    Frame5.Position = UDim2.fromScale(0.5, 0.5);
    Frame5.Size = UDim2.fromScale(1, 1);
    Frame5.ZIndex = -2;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Color";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.Position = UDim2.fromScale(0.5, 0.3);
    Frame6.Size = UDim2.fromScale(1, 0.6);
    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "UIShadow";
    UIShadow.BlurRadius = UDim.new(0.1, 0);
    UIShadow.Color = p240;
    UIShadow.Spread = UDim2.fromScale(-0.05, -0.05);
    UIShadow.Transparency = 0.55;
    UIShadow.Parent = Frame6;
    Frame6.Parent = Frame5;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Main";
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.5, 0.8);
    Frame7.Size = UDim2.fromScale(1, 0.4);
    local UIShadow2 = Instance.new("UIShadow");
    UIShadow2.Name = "UIShadow";
    UIShadow2.BlurRadius = UDim.new(0.1, 0);
    UIShadow2.Spread = UDim2.fromScale(-0.05, -0.05);
    UIShadow2.Parent = Frame7;
    Frame7.Parent = Frame5;
    Frame5.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Tag";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Italic);
    TextLabel.Position = UDim2.fromScale(0.05, 0.04);
    TextLabel.Size = UDim2.fromScale(0.6, 0.075);
    TextLabel.Text = "UPGRADE";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.85;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Visible = false;
    TextLabel.ZIndex = 10;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(175, 175, 185)) });
    UIGradient3.Rotation = 90;
    UIGradient3.Parent = TextLabel;
    TextLabel.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = `rbxassetid://{p237}`;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.3);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.62, 0.42);
    ImageLabel.ZIndex = 5;
    ImageLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "GamepassName";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.06, 0.625);
    TextLabel2.Size = UDim2.fromScale(0.88, 0.075);
    TextLabel2.Text = p236;
    TextLabel2.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Description";
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.06, 0.708);
    TextLabel3.Size = UDim2.fromScale(0.88, 0.11);
    TextLabel3.Text = p238;
    TextLabel3.TextColor3 = Color3.fromRGB(222, 222, 222);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.45;
    TextLabel3.TextWrapped = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel3.Parent = Frame;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Price";
    Frame8.AnchorPoint = Vector2.new(0.5, 1);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.5, 0.965);
    Frame8.Size = UDim2.fromScale(0.88, 0.125);
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Owned";
    Frame9.BackgroundColor3 = Color3.fromRGB(18, 188, 103);
    Frame9.BackgroundTransparency = 0.85;
    Frame9.LayoutOrder = 0;
    Frame9.Size = UDim2.fromScale(0.795, 1);
    Frame9.Visible = false;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.Parent = Frame9;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.Color = Color3.fromRGB(18, 188, 103);
    UIStroke2.Transparency = 0.55;
    UIStroke2.Parent = Frame9;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Icon";
    ImageLabel2.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://79889419533417";
    ImageLabel2.ImageColor3 = Color3.fromRGB(120, 230, 170);
    ImageLabel2.Position = UDim2.fromScale(0.06, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = Frame9;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.5, 0.525);
    TextLabel4.Size = UDim2.fromScale(0.6, 0.65);
    TextLabel4.Text = "OWNED";
    TextLabel4.TextColor3 = Color3.fromRGB(200, 245, 220);
    TextLabel4.TextScaled = true;
    TextLabel4.Parent = Frame9;
    Frame9.Parent = Frame8;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Credits";
    TextButton.Active = false;
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton.BackgroundTransparency = 0.95;
    TextButton.LayoutOrder = 1;
    TextButton.Size = UDim2.fromScale(0.38, 1);
    TextButton.TextTransparency = 1;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.new(1, 1, 1);
    UIStroke3.Transparency = 0.875;
    UIStroke3.Parent = TextButton;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = TextButton;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Title";
    TextLabel5.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.92, 0.525);
    TextLabel5.Size = UDim2.fromScale(0.6, 0.75);
    TextLabel5.Text = "???";
    TextLabel5.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel5.TextScaled = true;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel5.Parent = TextButton;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Icon";
    ImageLabel3.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://138240378050344";
    ImageLabel3.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel3.Position = UDim2.fromScale(0.06, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.75, 0.75);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = TextButton;
    TextButton.Parent = Frame8;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Robux";
    TextButton2.Active = false;
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundTransparency = 0.95;
    TextButton2.LayoutOrder = 2;
    TextButton2.Size = UDim2.fromScale(0.38, 1);
    TextButton2.TextTransparency = 1;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "UIStroke";
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.Color = Color3.new(1, 1, 1);
    UIStroke4.Transparency = 0.875;
    UIStroke4.Parent = TextButton2;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.Parent = TextButton2;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Title";
    TextLabel6.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.92, 0.525);
    TextLabel6.Size = UDim2.fromScale(0.55, 0.75);
    TextLabel6.Text = "???";
    TextLabel6.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel6.TextScaled = true;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel6.ZIndex = 2;
    TextLabel6.Parent = TextButton2;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Icon";
    TextLabel7.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.Position = UDim2.fromScale(0.06, 0.5);
    TextLabel7.RichText = true;
    TextLabel7.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel7.Text = "";
    TextLabel7.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel7.TextScaled = true;
    TextLabel7.ZIndex = 2;
    TextLabel7.Parent = TextButton2;
    TextButton2.Parent = Frame8;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Gift";
    TextButton3.Active = false;
    TextButton3.AutoButtonColor = false;
    TextButton3.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton3.BackgroundTransparency = 0.95;
    TextButton3.LayoutOrder = 3;
    TextButton3.Size = UDim2.fromScale(1, 1);
    TextButton3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton3.TextTransparency = 1;
    local UIStroke5 = Instance.new("UIStroke");
    UIStroke5.Name = "UIStroke";
    UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke5.Color = Color3.new(1, 1, 1);
    UIStroke5.Transparency = 0.875;
    UIStroke5.Parent = TextButton3;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UICorner";
    UICorner6.CornerRadius = UDim.new(0.1, 0);
    UICorner6.Parent = TextButton3;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Icon";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://117975901841067";
    ImageLabel4.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel4.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel4.ScaleType = Enum.ScaleType.Fit;
    ImageLabel4.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel4.Parent = TextButton3;
    TextButton3.Parent = Frame8;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.025, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame8;
    Frame8.Parent = Frame;
    Frame.Parent = p234;

    return Frame;
end;

return u1;