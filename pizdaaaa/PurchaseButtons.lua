-- ReplicatedStorage.GameClient.Gui.MainMenu.Utils.PurchaseButtons
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.Utils.PurchaseButtons
-- Decompile time: 10.81 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local TweenService = game:GetService("TweenService");
local MarketplaceService = game:GetService("MarketplaceService");
local RunService = game:GetService("RunService");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local LocalPlayer = game:GetService("Players").LocalPlayer;
local u6 = nil;

local function HasRobloxSubscription() -- Line: 24
    -- upvalues: RunService (copy), LocalPlayer (copy)
    return RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription;
end;

local u7 = {};

local function FetchProductInfo(u8) -- Line: 33
    -- upvalues: u7 (copy), MarketplaceService (copy)
    if u7[u8] ~= nil then
        return u7[u8];
    end;

    local success, result = pcall(function() -- Line: 39
        -- upvalues: MarketplaceService (ref), u8 (copy)
        return MarketplaceService:GetProductInfoAsync(u8, Enum.InfoType.Product);
    end);
    local v9;

    if success then
        v9 = "Product";
    else
        success, result = pcall(function() -- Line: 45
            -- upvalues: MarketplaceService (ref), u8 (copy)
            return MarketplaceService:GetProductInfoAsync(u8, Enum.InfoType.GamePass);
        end);
        v9 = "GamePass";
    end;

    if not (success and result) then
        return nil;
    end;

    local v10 = {
        InfoType = v9,
        ProductInfo = result
    };
    u7[u8] = v10;

    return v10;
end;

function u1.new() -- Line: 64
    -- upvalues: u1 (copy), u2 (ref)
    local v11 = setmetatable({}, u1);
    v11.Maid = u2.new();
    v11.RobuxRequestId = 0;

    return v11;
end;

function u1.Preload(u12) -- Line: 73
    -- upvalues: u7 (copy), FetchProductInfo (copy)
    if not u12 then
        return;
    end;

    task.spawn(function() -- Line: 78
        -- upvalues: u12 (copy), u7 (ref), FetchProductInfo (ref)
        for _, v in u12 do
            if v and (v > 0 and not u7[v]) then
                FetchProductInfo(v);
            end;
        end;
    end);
end;

local function DrawOldPrice(p13, p14) -- Line: 87
    local OldPrice = p13:FindFirstChild("OldPrice");

    if not OldPrice then
        local Title = p13.Title;
        OldPrice = Instance.new("TextLabel");
        OldPrice.Name = "OldPrice";
        OldPrice.AnchorPoint = Title.AnchorPoint;
        OldPrice.BackgroundTransparency = 1;
        OldPrice.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        OldPrice.Position = UDim2.fromScale(Title.Position.X.Scale, 0.1);
        OldPrice.RichText = true;
        OldPrice.Size = UDim2.fromScale(Title.Size.X.Scale, 0.38);
        OldPrice.TextColor3 = Title.TextColor3;
        OldPrice.TextScaled = true;
        OldPrice.TextTransparency = 0.5;
        OldPrice.TextXAlignment = Title.TextXAlignment;
        OldPrice.ZIndex = Title.ZIndex;
        OldPrice.Parent = p13;
    end;

    OldPrice.Text = `<s>{p14}</s>`;
end;

function u1.DrawCredits(p15, p16, p17, u18) -- Line: 116
    -- upvalues: RunService (copy), LocalPlayer (copy), DrawOldPrice (copy)
    p15.Maid:Removes("Credits_MouseEnter", "Credits_MouseLeave", "Credits_Button1Click");
    p15:base(p16, "Credits");
    p16.Title.RichText = true;

    if (RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription) and typeof(p17) == "number" then
        p16.Title.Text = math.floor(p17 * 0.9);
        DrawOldPrice(p16, p17);
    else
        p16.Title.Text = p17;
    end;

    p15.Maid:Add("Credits_Button1Click", p16.MouseButton1Click:Connect(function() -- Line: 129
        -- upvalues: u18 (copy)
        u18();
    end));
end;

function u1.GetProductInfo(p19) -- Line: 135
    -- upvalues: u7 (copy)
    if p19 then
        p19 = u7[p19];
    end;

    if p19 then
        p19 = p19.ProductInfo;
    end;

    return p19;
end;

local function UpdateSale(p20, p21, p22) -- Line: 140
    -- upvalues: TweenService (copy)
    local Sale = p20:FindFirstChild("Sale");

    if not Sale then
        return;
    end;

    if not (p21 and (p22 and (p22 > 0 and p22 < p21))) then
        TweenService:Create(Sale, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
            TextTransparency = 1
        }):Play();
        task.delay(0.15, function() -- Line: 153
            -- upvalues: Sale (copy)
            if Sale.TextTransparency == 1 then
                Sale.Text = "";
                Sale.Visible = false;
            end;
        end);

        return;
    end;

    Sale.Text = `<s>{p21}</s> <font color="rgb(18, 188, 103)">-{math.round((1 - p22 / p21) * 100)}%</font>`;
    Sale.Visible = true;
    TweenService:Create(Sale, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
        TextTransparency = 0
    }):Play();
end;

function u1.DrawRobux(u23, u24, u25, u26) -- Line: 162
    -- upvalues: UpdateSale (copy), u7 (copy), MarketplaceService (copy), LocalPlayer (copy), FetchProductInfo (copy)
    u23.Maid:Removes("Robux_MouseEnter", "Robux_MouseLeave", "Robux_Button1Click");
    u23:base(u24, "Robux");
    u23.RobuxRequestId = (u23.RobuxRequestId or 0) + 1;
    local RobuxRequestId = u23.RobuxRequestId;

    if not u25 or u25 <= 0 then
        u24.Title.Text = "???";
        UpdateSale(u24, nil, nil);

        return;
    end;

    local v27 = u7[u25];

    if not v27 then
        UpdateSale(u24, nil, nil);
        task.spawn(function() -- Line: 198
            -- upvalues: FetchProductInfo (ref), u25 (copy), u23 (copy), RobuxRequestId (copy), u24 (copy), UpdateSale (ref), u26 (copy), MarketplaceService (ref), LocalPlayer (ref)
            local v28 = FetchProductInfo(u25);

            if u23.RobuxRequestId ~= RobuxRequestId then
                return;
            end;

            if not v28 then
                u24.Title.Text = "???";
                UpdateSale(u24, nil, nil);

                return;
            end;

            local ProductInfo = v28.ProductInfo;
            local InfoType = v28.InfoType;
            pcall(function() -- Line: 214
                -- upvalues: u24 (ref), ProductInfo (copy), UpdateSale (ref), u26 (ref), u23 (ref), InfoType (copy), MarketplaceService (ref), LocalPlayer (ref), u25 (ref)
                u24.Title.Text = ProductInfo.PriceInRobux or "???";
                UpdateSale(u24, u26, ProductInfo.PriceInRobux);
                u23.Maid:Add("Robux_Button1Click", u24.MouseButton1Click:Connect(function() -- Line: 218
                    -- upvalues: ProductInfo (ref), InfoType (ref), MarketplaceService (ref), LocalPlayer (ref), u25 (ref)
                    if ProductInfo.IsForSale then
                        if InfoType == "GamePass" then
                            MarketplaceService:PromptGamePassPurchase(LocalPlayer, u25);

                            return;
                        end;

                        MarketplaceService:PromptProductPurchase(LocalPlayer, u25);
                    end;
                end));
            end);
        end);

        return;
    end;

    local ProductInfo = v27.ProductInfo;
    local InfoType = v27.InfoType;
    u24.Title.Text = ProductInfo.PriceInRobux or "???";
    UpdateSale(u24, u26, ProductInfo.PriceInRobux);
    u23.Maid:Add("Robux_Button1Click", u24.MouseButton1Click:Connect(function() -- Line: 184
        -- upvalues: ProductInfo (copy), InfoType (copy), MarketplaceService (ref), LocalPlayer (ref), u25 (copy)
        if ProductInfo.IsForSale then
            if InfoType == "GamePass" then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, u25);

                return;
            end;

            MarketplaceService:PromptProductPurchase(LocalPlayer, u25);
        end;
    end));
end;

function u1.DrawGift(p29, p30, u31) -- Line: 231
    -- upvalues: u6 (ref), u4 (ref)
    p29.Maid:Removes("Gift_MouseEnter", "Gift_MouseLeave", "Gift_Button1Click");
    p29:base(p30, "Gift");
    p29.Maid:Add("Gift_Button1Click", p30.MouseButton1Click:Connect(function() -- Line: 236
        -- upvalues: u31 (copy), u6 (ref), u4 (ref)
        if not u31 or u31 <= 0 then
            return;
        end;

        u6.Create(u31, function(p32) -- Line: 241
            -- upvalues: u4 (ref), u31 (ref)
            u4.Gui.GiftGamepass.Fire({
                GamepassId = u31,
                UserId = tonumber(p32)
            });
        end);
    end));
end;

function u1.Clear(p33) -- Line: 248
    p33.RobuxRequestId = (p33.RobuxRequestId or 0) + 1;
    p33.Maid:Cleanup();
end;

function u1.base(p34, u35, p36) -- Line: 253
    -- upvalues: TweenService (copy)
    p34.Maid:Add(`{p36}_MouseEnter`, u35.MouseEnter:Connect(function() -- Line: 254
        -- upvalues: TweenService (ref), u35 (copy)
        TweenService:Create(u35, TweenInfo.new(0.5), {
            BackgroundTransparency = 0.9
        }):Play();
    end));
    p34.Maid:Add(`{p36}_MouseLeave`, u35.MouseLeave:Connect(function() -- Line: 258
        -- upvalues: TweenService (ref), u35 (copy)
        TweenService:Create(u35, TweenInfo.new(0.5), {
            BackgroundTransparency = 0.95
        }):Play();
    end));
end;

function u1.Init(p37, p38) -- Line: 263
    -- upvalues: u2 (ref), u3 (ref), u4 (ref)
    u2 = p37:GetModule("Maid");
    u3 = p37:GetModule("Gui");
    u4 = p37:GetModule("Network");
end;

function u1.Start(p39) -- Line: 271
    -- upvalues: u6 (ref), u3 (ref), u5 (ref)
    u6 = u3.GetComponent("Gift");
    u5 = u3.GetComponent("MenuNotification");
end;

return u1;