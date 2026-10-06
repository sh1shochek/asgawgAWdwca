-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local MarketPlacePrices = require(ReplicatedStorage.Database.Components.MarketPlacePrices);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = 0;
local u6 = "";
local u7 = false;
local u8 = {};

local function GetStoreHoverFrame() -- Line: 38
    -- upvalues: u2 (ref)
    local v9 = u2 and u2:FindFirstChild("StoreHoverFrame");

    if v9 and v9:IsA("Frame") then
        return v9;
    end;

    return nil;
end;

local function GetStoreHoverTextLabel(...) -- Line: 45
    -- upvalues: u2 (ref)
    local v10 = u2 and u2:FindFirstChild("StoreHoverFrame");

    if not (v10 and v10:IsA("Frame")) then
        v10 = nil;
    end;

    for _, v in { ... } do
        if not v10 then
            return nil;
        end;

        v10 = v10:FindFirstChild(v);
    end;

    if v10 and v10:IsA("TextLabel") then
        return v10;
    end;

    return nil;
end;

local function GetStoreHoverPriceLabel() -- Line: 60
    -- upvalues: GetStoreHoverTextLabel (copy)
    return GetStoreHoverTextLabel("Info", "Price", "Frame", "TextLabel");
end;

local function SetStoreHoverVisible(p11: boolean) -- Line: 66
    -- upvalues: u2 (ref)
    local v12 = u2 and u2:FindFirstChild("StoreHoverFrame");

    if not (v12 and v12:IsA("Frame")) then
        v12 = nil;
    end;

    if v12 then
        v12.Visible = p11;
    end;
end;

local function UpdateStoreHoverPosition() -- Line: 75
    -- upvalues: u2 (ref), UserInputService (copy), GuiService (copy), u3 (ref)
    local v13 = u2 and u2:FindFirstChild("StoreHoverFrame");

    if not (v13 and v13:IsA("Frame")) then
        v13 = nil;
    end;

    if not v13 then
        return;
    end;

    local Parent = v13.Parent;

    if not (Parent and Parent:IsA("GuiObject")) then
        return;
    end;

    local v14 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset();
    local AbsolutePosition = Parent.AbsolutePosition;
    local AbsoluteSize = Parent.AbsoluteSize;
    local AbsoluteSize2 = v13.AbsoluteSize;
    local AnchorPoint = v13.AnchorPoint;
    local v15 = AbsolutePosition.X + u3.STORE_HOVER_PADDING;
    local v16 = AbsolutePosition.Y + u3.STORE_HOVER_PADDING;
    local math_max_ret = math.max(v15, AbsolutePosition.X + AbsoluteSize.X - AbsoluteSize2.X - u3.STORE_HOVER_PADDING);
    local math_max_ret2 = math.max(v16, AbsolutePosition.Y + AbsoluteSize.Y - AbsoluteSize2.Y - u3.STORE_HOVER_PADDING);
    local math_clamp_ret = math.clamp(v14.X + u3.STORE_HOVER_MOUSE_OFFSET.X, v15, math_max_ret);
    local math_clamp_ret2 = math.clamp(v14.Y + u3.STORE_HOVER_MOUSE_OFFSET.Y, v16, math_max_ret2);
    v13.Position = UDim2.fromOffset(math.floor(math_clamp_ret - AbsolutePosition.X + AbsoluteSize2.X * AnchorPoint.X + 0.5), (math.floor(math_clamp_ret2 - AbsolutePosition.Y + AbsoluteSize2.Y * AnchorPoint.Y + 0.5)));
end;

local function GetStoreHoverPriceText(u17: string, u18: string, p19: any) -- Line: 107
    -- upvalues: MarketPlacePrices (copy), CommaNumber (copy)
    if p19 then
        local function GetWearTradeTokens(p20: number) -- Line: 109
            -- upvalues: MarketPlacePrices (ref), u17 (copy), u18 (copy)
            local ItemPrice = MarketPlacePrices.GetItemPrice(u17, u18, p20, false);

            if ItemPrice then
                ItemPrice = math.floor(ItemPrice.recentAveragePriceTradeTokens);
            end;

            if ItemPrice and ItemPrice <= 0 then
                return nil;
            end;

            return ItemPrice;
        end;

        local ItemPrice = MarketPlacePrices.GetItemPrice(u17, u18, p19.floatRange.min, false);

        if ItemPrice then
            ItemPrice = math.floor(ItemPrice.recentAveragePriceTradeTokens);
        end;

        if ItemPrice and ItemPrice <= 0 then
            ItemPrice = nil;
        end;

        local ItemPrice2 = MarketPlacePrices.GetItemPrice(u17, u18, p19.floatRange.max, false);

        if ItemPrice2 then
            ItemPrice2 = math.floor(ItemPrice2.recentAveragePriceTradeTokens);
        end;

        if ItemPrice2 and ItemPrice2 <= 0 then
            ItemPrice2 = nil;
        end;

        if ItemPrice and ItemPrice2 then
            return `{CommaNumber((math.min(ItemPrice, ItemPrice2)))}-{CommaNumber((math.max(ItemPrice, ItemPrice2)))}`;
        end;

        if ItemPrice2 then
            return CommaNumber(ItemPrice2) .. "-N/A";
        end;

        if ItemPrice then
            return "N/A-" .. CommaNumber(ItemPrice);
        end;
    end;

    return "N/A-N/A";
end;

local function UpdateStoreHoverContent(u21: userdata) -- Line: 131
    -- upvalues: Skins (copy), Rarities (copy), GetSkinDisplayName (copy), GetStoreHoverTextLabel (copy), u5 (ref), u6 (ref), GetStoreHoverPriceText (copy), u4 (ref)
    local Parent = u21.Parent;

    if not Parent then
        return false;
    end;

    local Attribute = Parent:GetAttribute("WeaponName");
    local Attribute2 = Parent:GetAttribute("SkinName");

    if typeof(Attribute) ~= "string" or typeof(Attribute2) ~= "string" then
        warn((`[Store] {Parent:GetFullName()} is missing WeaponName/SkinName attributes.`));

        return false;
    end;

    local SkinInformation = Skins.GetSkinInformation(Attribute, Attribute2);
    local v22 = not SkinInformation and "Stock" or SkinInformation.rarity;
    local v23 = Rarities[v22];
    local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(Attribute);
    local SkinDisplayName = GetSkinDisplayName.GetSkinDisplayName(Attribute2, true);
    local u24 = GetStoreHoverTextLabel("Info", "Price", "Frame", "TextLabel");
    local u25 = u5;
    local v26 = GetStoreHoverTextLabel("Info", "ItemName");

    if v26 then
        v26.Text = `{WeaponDisplayName} | {SkinDisplayName}`;
        local v27;

        if v23 then
            v27 = v23.Color;
        else
            v27 = Color3.fromRGB(243, 243, 243);
        end;

        v26.TextColor3 = v27;
    end;

    local v28 = GetStoreHoverTextLabel("Info", "RarityName");

    if v28 then
        v28.Text = string.upper(v22);

        if v23 then
            v28.TextColor3 = v23.Color;
        end;
    end;

    local v29 = GetStoreHoverTextLabel("Info", "Description", "TextLabel");

    if v29 then
        v29.Text = not SkinInformation and "" or SkinInformation.description;
    end;

    if u24 then
        u24.Text = u6;
        task.spawn(function() -- Line: 173
            -- upvalues: GetStoreHoverPriceText (ref), Attribute (copy), Attribute2 (copy), SkinInformation (copy), u4 (ref), u21 (copy), u5 (ref), u25 (copy), u24 (copy)
            local v30 = GetStoreHoverPriceText(Attribute, Attribute2, SkinInformation);

            if u4 == u21 and u5 == u25 then
                u24.Text = v30;
            end;
        end);
    end;

    return true;
end;

local function BindStoreHoverButton(u31: userdata) -- Line: 186
    -- upvalues: u8 (copy), u2 (ref), u5 (ref), u4 (ref), UpdateStoreHoverPosition (copy), UpdateStoreHoverContent (copy)
    if u8[u31] then
        return;
    end;

    if not (u2 and (u31:IsDescendantOf(u2) and u31:IsA("GuiButton"))) then
        return;
    end;

    u8[u31] = true;
    u31.MouseEnter:Connect(function() -- Line: 196
        -- upvalues: u5 (ref), u4 (ref), u31 (copy), UpdateStoreHoverPosition (ref), UpdateStoreHoverContent (ref), u2 (ref)
        u5 = u5 + 1;
        u4 = u31;
        UpdateStoreHoverPosition();

        if UpdateStoreHoverContent(u31) then
            local v32 = u2 and u2:FindFirstChild("StoreHoverFrame");

            if not (v32 and v32:IsA("Frame")) then
                v32 = nil;
            end;

            if v32 then
                v32.Visible = true;
            end;
        end;
    end);
    u31.MouseLeave:Connect(function() -- Line: 206
        -- upvalues: u4 (ref), u31 (copy), u5 (ref), u2 (ref)
        if u4 ~= u31 then
            return;
        end;

        u5 = u5 + 1;
        u4 = nil;
        local v33 = u2 and u2:FindFirstChild("StoreHoverFrame");

        if not (v33 and v33:IsA("Frame")) then
            v33 = nil;
        end;

        if v33 then
            v33.Visible = false;
        end;
    end);
end;

local function SetupStoreHoverButtons() -- Line: 219
    -- upvalues: u2 (ref), GetStoreHoverTextLabel (copy), u6 (ref), CollectionService (copy), u3 (ref), BindStoreHoverButton (copy), u7 (ref), RunServiceController (copy), u4 (ref), UpdateStoreHoverPosition (copy)
    local v34 = u2 and u2:FindFirstChild("StoreHoverFrame");

    if not (v34 and v34:IsA("Frame")) then
        v34 = nil;
    end;

    if v34 then
        local v35 = GetStoreHoverTextLabel("Info", "Price", "Frame", "TextLabel");
        u6 = v35 and v35.Text or "";
        v34.Visible = false;
    end;

    for _, v in ipairs(CollectionService:GetTagged(u3.STORE_HOVER_BUTTON_TAG)) do
        BindStoreHoverButton(v);
    end;

    if u7 then
        return;
    end;

    u7 = true;
    CollectionService:GetInstanceAddedSignal(u3.STORE_HOVER_BUTTON_TAG):Connect(BindStoreHoverButton);
    RunServiceController.BindToRenderStep("UI.Store.HoverFrameFollow", function() -- Line: 238
        -- upvalues: u4 (ref), u2 (ref), UpdateStoreHoverPosition (ref)
        if not u4 then
            return;
        end;

        if u2 and (u2.Visible and u4:IsDescendantOf(u2)) then
            UpdateStoreHoverPosition();

            return;
        end;

        u4 = nil;
        local v36 = u2 and u2:FindFirstChild("StoreHoverFrame");

        if not (v36 and v36:IsA("Frame")) then
            v36 = nil;
        end;

        if v36 then
            v36.Visible = false;
        end;
    end);
end;

function v1.Setup(p37: userdata, p38: table) -- Line: 256
    -- upvalues: u2 (ref), u3 (ref), SetupStoreHoverButtons (copy)
    u2 = p37;
    u3 = p38;
    SetupStoreHoverButtons();
end;

return v1;