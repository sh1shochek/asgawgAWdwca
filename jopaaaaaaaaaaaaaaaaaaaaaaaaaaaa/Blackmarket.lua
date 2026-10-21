-- ReplicatedStorage.Interface.Screens.Menu.Blackmarket
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Blackmarket
-- Decompile time: 41.99 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarketplaceService = game:GetService("MarketplaceService");
local UserInputService = game:GetService("UserInputService");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber);
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local BlackMarketDealer = Remotes.BlackMarketDealer;
local TweenInfo_new_ret = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, (1 / 0));
local u1 = {
    [Enum.KeyCode.DPadUp] = true,
    [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true,
    [Enum.KeyCode.DPadRight] = true
};
local TweenInfo_new_ret2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local Color3_fromRGB_ret = Color3.fromRGB(255, 244, 200);
local TweenInfo_new_ret3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local TweenInfo_new_ret4 = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret5 = TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);
local Random_new_ret = Random.new();
local u2 = {};
local u3 = false;
local u4 = false;
local u5 = {};
local u6 = {};
local u7 = nil;
local u8 = true;
local u9 = nil;
local u10 = nil;
local u11 = {};
local u12 = false;
local u13 = nil;
local u14 = (-1 / 0);
local u15 = nil;
local u16 = false;
local u17 = 0;
local u18 = 0;
local v19 = {};
local u20 = nil;
local u21 = {};
local u22 = false;
local u23 = false;
local u24 = {};
local u25 = nil;
local u26 = nil;
local u27 = {};
local u28 = nil;
local u29 = nil;
local u30 = false;
local u31 = nil;
local u32 = {};
local u33 = {};
local u34 = {
    case = true,
    package = true,
    console = true
};
local u35 = nil;
local u36 = {};
local u37 = nil;
local u38 = nil;
local u39 = nil;
local u40 = {};
local u41 = nil;
local u42 = false;
local u43 = nil;
local u44 = {
    case = true,
    package = true,
    console = true
};
local u45 = nil;
local u46 = {};
local u47 = nil;

for i, v in DevProducts do
    local string_match_ret = string.match(i, "^%+ ([%d,]+) Trade Tokens$");

    if string_match_ret and (typeof(v) == "table" and typeof(v.DevProductId) == "number") then
        local v48 = {};
        local string_gsub_ret = string.gsub(string_match_ret, ",", "");
        v48.Amount = tonumber(string_gsub_ret);
        v48.DevProductId = v.DevProductId;
        table.insert(u2, v48);
    end;
end;

table.sort(u2, function(p49, p50) -- Line: 345
    return p49.Amount < p50.Amount;
end);
local u51 = false;

local function notify(p52: string) -- Line: 356
    -- upvalues: Router (copy)
    Router.broadcastRouter("CreateNotification", "Black Market", p52, 5);
end;

local function notifyRegionRestricted() -- Line: 362
    -- upvalues: Router (copy)
    Router.broadcastRouter("CreateMenuNotification", "Error", "Paid random items are restricted in your region");
end;

local function isPointerBlocked() -- Line: 373
    -- upvalues: u30 (ref), u37 (ref), u4 (ref), GuiService (copy)
    return u30 or (u37 ~= nil and true or (u4 or GuiService.MenuIsOpen));
end;

local function setWaitingForDeal(p53: boolean) -- Line: 387
    -- upvalues: u13 (ref), u51 (ref), u45 (ref), u35 (ref)
    local v54 = u13;

    if not v54 or p53 == u51 then
        return;
    end;

    u51 = p53;
    v54.Visible = p53;
    local v55 = u45;

    if not v55 then
        return;
    end;

    if p53 then
        v55:Play();

        return;
    end;

    if u35 then
        v55:Cancel();
        u35.Rotation = 0;
    end;
end;

local function setNavigationVisible(p56: boolean) -- Line: 417
    -- upvalues: u29 (ref)
    local v57 = u29 and u29:FindFirstChild("Top");

    if v57 then
        v57 = v57:FindFirstChild("Bottom");
    end;

    if v57 and v57:IsA("GuiObject") then
        v57.Visible = p56;
    end;
end;

local function escapeRichText(p58: string) -- Line: 428
    return p58:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
end;

local function getRarityColor(p59: string?) -- Line: 434
    -- upvalues: Rarities (copy)
    if p59 then
        p59 = Rarities[p59];
    end;

    return p59 and p59.Color or Rarities.Stock.Color;
end;

local function formatCountdown(p60: number) -- Line: 441
    local math_floor_ret = math.floor(p60);
    local math_max_ret = math.max(math_floor_ret, 0);

    return string.format("%02d:%02d:%02d", math_max_ret // 3600, math_max_ret % 3600 // 60, math_max_ret % 60);
end;

local function canInspectCard(p61) -- Line: 453
    -- upvalues: u44 (copy), Skins (copy)
    if u44[tostring(p61.offerKind)] or typeof(p61.float) ~= "number" then
        return false;
    end;

    return Skins.GetSkinInformation(p61.name, p61.skin) ~= nil;
end;

local function isCardPurchased(p62) -- Line: 471
    -- upvalues: u36 (copy), u25 (ref)
    if u36[tostring(p62.cardId)] then
        return true;
    end;

    local v63;

    if typeof(u25) == "table" then
        v63 = u25.buyEnabled == false;
    else
        v63 = false;
    end;

    return not v63 and p62.status ~= "available";
end;

local function toPreviewItem(p64) -- Line: 487
    -- upvalues: LocalPlayer (copy)
    return {
        Serial = 0,
        IsTradeable = true,
        NameTag = false,
        Charm = false,
        _id = p64.cardId,
        Type = p64.type,
        Name = p64.name,
        Skin = p64.skin,
        Rarity = p64.rarity,
        Float = p64.float,
        StatTrack = p64.isStattrak and 0 or false,
        Stickers = {},
        MetaData = {
            LastTradeAt = 0,
            Origin = "Other",
            Owner = LocalPlayer.UserId,
            OriginalOwner = LocalPlayer.UserId,
            CreatedAt = os.time(),
            TradeHistory = {}
        }
    };
end;

local function resolveCardImage(p65: any, p66: any, p67: boolean) -- Line: 523
    -- upvalues: Skins (copy), Cases (copy)
    if p66 then
        local v68;

        if p67 then
            v68 = Skins.GetWearImageForFloat(p66, p65.float) or nil;
        else
            v68 = nil;
        end;

        return v68 or p66.imageAssetId or "";
    end;

    local CaseByName = Cases.GetCaseByName(p65.skin);

    return CaseByName and CaseByName.imageAssetId or "";
end;

local function tintCard(p69: userdata, p70: string?) -- Line: 535
    -- upvalues: Rarities (copy)
    if p70 then
        p70 = Rarities[p70];
    end;

    local v71 = p70 and p70.Color or Rarities.Stock.Color;
    local BG = p69:FindFirstChild("BG");

    if BG and BG:IsA("ImageLabel") then
        BG.ImageColor3 = v71;
    end;

    local Pattern = p69:FindFirstChild("Pattern");

    if Pattern and Pattern:IsA("ImageLabel") then
        Pattern.ImageColor3 = v71;
    end;

    local Effects = p69:FindFirstChild("Effects");

    if Effects then
        Effects = Effects:FindFirstChild("Effect");
    end;

    if Effects and Effects:IsA("ImageLabel") then
        Effects.ImageColor3 = v71;
    end;

    local ItemTemplate = p69:FindFirstChild("ItemTemplate");

    if not ItemTemplate then
        return;
    end;

    local v72 = ItemTemplate:FindFirstChildOfClass("UIShadow");

    if v72 then
        v72.Color = v71;
    end;

    local Glow = ItemTemplate:FindFirstChild("Glow");

    if Glow and Glow:IsA("ImageLabel") then
        Glow.ImageColor3 = v71;
    end;

    local ItemContent = ItemTemplate:FindFirstChild("ItemContent");

    if ItemContent then
        ItemContent = ItemContent:FindFirstChild("Content");
    end;

    if ItemContent then
        ItemContent = ItemContent:FindFirstChild("Rarity");
    end;

    if ItemContent and ItemContent:IsA("ImageLabel") then
        ItemContent.ImageColor3 = v71;
    end;
end;

local function renderSlot(p73: table, p74: any) -- Line: 579
    -- upvalues: BlackMarketSceneController (copy), Skins (copy), u44 (copy), tintCard (copy), Cases (copy), GetSkinDisplayName (copy), CommaNumber (copy), u25 (ref), u36 (copy), u5 (copy)
    p73.Card = p74;

    if not p74 then
        BlackMarketSceneController.SetCardVisible(p73.Part, false);

        return;
    end;

    BlackMarketSceneController.SetCardVisible(p73.Part, true);
    local Back = p73.Back;
    local SkinInformation = Skins.GetSkinInformation(p74.name, p74.skin);
    local v75 = not u44[tostring(p74.offerKind)] and typeof(p74.float) == "number";
    tintCard(Back, p74.rarity);
    local ItemTemplate = Back:FindFirstChild("ItemTemplate");

    if ItemTemplate then
        ItemTemplate = ItemTemplate:FindFirstChild("ItemContent");
    end;

    local v76;

    if ItemTemplate then
        v76 = ItemTemplate:FindFirstChild("Content");
    else
        v76 = ItemTemplate;
    end;

    if v76 then
        v76 = v76:FindFirstChild("Icon");
    end;

    if v76 and v76:IsA("ImageLabel") then
        local v77;

        if SkinInformation then
            local v78;

            if v75 then
                v78 = Skins.GetWearImageForFloat(SkinInformation, p74.float) or nil;
            else
                v78 = nil;
            end;

            v77 = v78 or (SkinInformation.imageAssetId or "");
        else
            local CaseByName = Cases.GetCaseByName(p74.skin);
            v77 = CaseByName and CaseByName.imageAssetId or "";
        end;

        v76.Image = v77;
    end;

    if ItemTemplate then
        ItemTemplate = ItemTemplate:FindFirstChild("Inspect");
    end;

    if ItemTemplate and ItemTemplate:IsA("GuiObject") then
        local v79;

        if u44[tostring(p74.offerKind)] or typeof(p74.float) ~= "number" then
            v79 = false;
        else
            v79 = Skins.GetSkinInformation(p74.name, p74.skin) ~= nil;
        end;

        ItemTemplate.Visible = v79;
    end;

    local Bottom = Back:FindFirstChild("Bottom");

    if Bottom then
        local Skin = Bottom:FindFirstChild("Skin");

        if Skin and Skin:IsA("TextLabel") then
            local FullItemDisplayName = GetSkinDisplayName.GetFullItemDisplayName(p74.name, p74.skin, false, true);

            if FullItemDisplayName == "" then
                local CaseByName = Cases.GetCaseByName(p74.skin);

                if CaseByName then
                    FullItemDisplayName = CaseByName.name;
                else
                    FullItemDisplayName = `{GetSkinDisplayName.GetWeaponDisplayName(p74.name)} | {GetSkinDisplayName.GetSkinDisplayName(p74.skin, true)}`;
                end;
            end;

            Skin.RichText = true;
            local v80 = FullItemDisplayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");

            if p74.isStattrak then
                v80 = `<font color="rgb(255,132,32)">KillTrak™</font> {v80}`;
            end;

            Skin.Text = v80;
        end;

        local RAP = Bottom:FindFirstChild("RAP");

        if RAP and RAP:IsA("TextLabel") then
            local v81 = tonumber(p74.rapPrice) or 0;
            RAP.Text = `RAP: {CommaNumber((math.floor(v81)))}`;
        end;

        local FloatNumber = Bottom:FindFirstChild("FloatNumber");

        if FloatNumber and FloatNumber:IsA("TextLabel") then
            FloatNumber.Visible = true;
            FloatNumber.Text = not v75 and "" or string.format("%.13f", p74.float);
        end;

        if RAP and FloatNumber then
            RAP.LayoutOrder = v75 and 3 or 1;
            FloatNumber.LayoutOrder = v75 and 1 or 3;
        end;

        local v82;

        if typeof(u25) == "table" then
            v82 = u25.buyEnabled == false;
        else
            v82 = false;
        end;

        local v83;

        if p74.status == "available" then
            v83 = not v82;
        else
            v83 = false;
        end;

        local v84;

        if u36[tostring(p74.cardId)] then
            v84 = true;
        else
            local v85;

            if typeof(u25) == "table" then
                v85 = u25.buyEnabled == false;
            else
                v85 = false;
            end;

            v84 = not v85 and p74.status ~= "available";
        end;

        local Interact = Bottom:FindFirstChild("Interact");
        local v86;

        if Interact then
            v86 = Interact:FindFirstChild("Buy");
        else
            v86 = Interact;
        end;

        local v87;

        if v86 then
            v87 = v86:FindFirstChild("Amount");
        else
            v87 = v86;
        end;

        if v87 and v87:IsA("TextLabel") then
            local v88;

            if v84 then
                v88 = "PURCHASED";
            else
                local v89 = tonumber(p74.price) or 0;
                v88 = `BUY ({CommaNumber((math.floor(v89)))})`;
            end;

            v87.Text = v88;
        end;

        if Interact then
            Interact = Interact:FindFirstChild("Decline");
        end;

        if Interact and Interact:IsA("GuiObject") then
            Interact.Visible = false;
        end;

        local BuyWideLayout = p73.BuyWideLayout;

        if v86 and v86:IsA("GuiObject") then
            if BuyWideLayout then
                v86.Position = BuyWideLayout.Position;
                v86.Size = BuyWideLayout.Size;
            end;

            v86.Visible = v83 or v84;
        end;
    end;

    local Discount = Back:FindFirstChild("Discount");
    local v90;

    if Discount then
        v90 = Discount:FindFirstChild("Title");
    else
        v90 = Discount;
    end;

    local v91 = tonumber(p74.discount) or 0;

    if Discount and Discount:IsA("GuiObject") then
        Discount.Visible = v91 > 0;
    end;

    if v90 and v90:IsA("TextLabel") then
        v90.Text = `- {math.floor(v91 * 100 + 0.5)}%`;
    end;

    local v92 = u5[tostring(p74.cardId)];

    if v92 == nil then
        local v93;

        if u36[tostring(p74.cardId)] then
            v93 = true;
        else
            local v94;

            if typeof(u25) == "table" then
                v94 = u25.buyEnabled == false;
            else
                v94 = false;
            end;

            v93 = not v94 and p74.status ~= "available";
        end;

        v92 = v93 and true or v92;
    end;

    if v92 ~= nil then
        BlackMarketSceneController.SetCardFaceUp(p73.Part, v92, false);
    end;
end;

local function updateCountdown() -- Line: 721
    -- upvalues: u26 (ref), u10 (ref), u38 (ref), u27 (copy)
    local v95 = u26;

    if not v95 then
        return;
    end;

    local v96 = v95 - os.clock();
    local math_floor_ret = math.floor(v96);
    local math_max_ret = math.max(math_floor_ret, 0);
    local string_format_ret = string.format("%02d:%02d:%02d", math_max_ret // 3600, math_max_ret % 3600 // 60, math_max_ret % 60);

    if string_format_ret == u10 then
        return;
    end;

    u10 = string_format_ret;
    local Title = u38:FindFirstChild("Title");

    if Title and Title:IsA("TextLabel") then
        Title.Text = `<font color="rgb(255,223,0)">{string_format_ret}</font> LEFT`;
    end;

    for _, v in u27 do
        local v97 = v.Card and v.Back:FindFirstChild("Expires");

        if v97 then
            v97 = v97:FindFirstChild("TextLabel");
        end;

        if v97 and v97:IsA("TextLabel") then
            v97.Text = `<font color="rgb(167,167,167)">EXPIRES IN</font> <font color="rgb(255,255,255)">{string_format_ret}</font>`;
        end;
    end;
end;

local function setDealDeadline(p98) -- Line: 761
    -- upvalues: u26 (ref), u10 (ref)
    local v99 = typeof(p98) == "table" and tonumber(p98.msRemaining) or nil;
    local v100;

    if v99 then
        v100 = os.clock() + v99 / 1000;
    else
        v100 = nil;
    end;

    u26 = v100;
    u10 = nil;
end;

local function preloadCardArt() -- Line: 774
    -- upvalues: u27 (copy), ContentProvider (copy)
    local u101 = {};

    for _, v in u27 do
        local ItemTemplate = v.Back:FindFirstChild("ItemTemplate");

        if ItemTemplate then
            ItemTemplate = ItemTemplate:FindFirstChild("ItemContent");
        end;

        if ItemTemplate then
            ItemTemplate = ItemTemplate:FindFirstChild("Content");
        end;

        if ItemTemplate then
            ItemTemplate = ItemTemplate:FindFirstChild("Icon");
        end;

        if ItemTemplate and (ItemTemplate:IsA("ImageLabel") and ItemTemplate.Image ~= "") then
            table.insert(u101, ItemTemplate);
        end;
    end;

    if #u101 > 0 then
        task.spawn(function() -- Line: 787
            -- upvalues: ContentProvider (ref), u101 (copy)
            ContentProvider:PreloadAsync(u101);
        end);
    end;
end;

local function dealSignature(p102) -- Line: 800
    if typeof(p102) ~= "table" or typeof(p102.cards) ~= "table" then
        return "";
    end;

    local v103 = {};

    for i, v in p102.cards do
        local v104 = typeof(v) == "table" and (v.cardId or "") or "";
        v103[i] = tostring(v104);
    end;

    return table.concat(v103, "|");
end;

local function renderDeal(p105) -- Line: 814
    -- upvalues: u25 (ref), u27 (copy), renderSlot (copy), BlackMarketSceneController (copy), preloadCardArt (copy), u10 (ref), updateCountdown (copy)
    u25 = p105;
    local v106 = typeof(p105) == "table" and (typeof(p105.cards) == "table" and p105.cards) or {};

    for i, v in u27 do
        renderSlot(v, v106[i]);
    end;

    BlackMarketSceneController.NotifyDealRendered();
    preloadCardArt();
    u10 = nil;
    updateCountdown();
end;

local function requestDeal() -- Line: 841
    -- upvalues: u26 (ref), u14 (ref), BlackMarketDealer (copy)
    local v107 = u26;

    if v107 and v107 - os.clock() > 0 then
        return;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret - u14 < 10 then
        return;
    end;

    u14 = os_clock_ret;
    BlackMarketDealer.RequestDeal.Send();
end;

local function regionRect(p108: table) -- Line: 866
    local Element = p108.Element;
    local AbsolutePosition = Element.AbsolutePosition;
    local AbsoluteSize = Element.AbsoluteSize;
    local Scale = p108.Scale.Scale;

    if Scale <= 0 or Scale >= 1 then
        return AbsolutePosition, AbsoluteSize;
    end;

    local AnchorPoint = Element.AnchorPoint;
    local v109 = AbsoluteSize / Scale;

    return AbsolutePosition + AbsoluteSize * AnchorPoint - v109 * AnchorPoint, v109;
end;

local function regionBounds(p110: table, p111: table) -- Line: 886
    local AbsoluteSize = p110.Back.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return nil, nil;
    end;

    local Element = p111.Element;
    local AbsolutePosition = Element.AbsolutePosition;
    local AbsoluteSize2 = Element.AbsoluteSize;
    local Scale = p111.Scale.Scale;
    local v112;

    if Scale <= 0 or Scale >= 1 then
        v112 = AbsoluteSize2;
    else
        local AnchorPoint = Element.AnchorPoint;
        v112 = AbsoluteSize2 / Scale;
        AbsolutePosition = AbsolutePosition + AbsoluteSize2 * AnchorPoint - v112 * AnchorPoint;
    end;

    local v113 = AbsolutePosition - p110.Back.AbsolutePosition;

    return v113 / AbsoluteSize, (v113 + v112) / AbsoluteSize;
end;

local function isRegionVisible(p114: userdata, p115: userdata) -- Line: 900
    while p114 and p114 ~= p115 do
        if p114:IsA("GuiObject") and not p114.Visible then
            return false;
        end;

        p114 = p114.Parent;
    end;

    return true;
end;

local function projectCardRect(p116: userdata, p117, p118, p119: boolean) -- Line: 931
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return nil, nil, false;
    end;

    local Size = p116.Size;
    local CFrame = p116.CFrame;
    local v120 = (1 / 0);
    local v121 = (1 / 0);
    local v122 = (-1 / 0);
    local v123 = (-1 / 0);
    local v124 = 0;
    local v125 = 0;

    for i = 1, 4 do
        local v126;

        if i == 2 and true or i == 3 then
            v126 = p118.X;
        else
            v126 = p117.X;
        end;

        local v127;

        if i == 3 and true or i == 4 then
            v127 = p118.Y;
        else
            v127 = p117.Y;
        end;

        local v128;

        if p119 then
            v128 = 0.5 - v126;
        else
            v128 = v126 - 0.5;
        end;

        local v129 = workspace_CurrentCamera:WorldToViewportPoint(CFrame:PointToWorldSpace((Vector3.new(v128 * Size.X, (0.5 - v127) * Size.Y, 0))));

        if v129.Z <= 0 then
            return nil, nil, false;
        end;

        v120 = math.min(v120, v129.X);
        v122 = math.max(v122, v129.X);
        v121 = math.min(v121, v129.Y);
        v123 = math.max(v123, v129.Y);
        local v130;

        if i == 1 then
            v124 = v129.X;
            v130 = i;
        elseif i == 2 then
            v125 = v129.X;
            v130 = i;
        else
            v130 = i;
        end;
    end;

    return Vector2.new(v120, v121), Vector2.new(v122 - v120, v123 - v121), v124 < v125;
end;

local function setHoveredRegion(p131: table?) -- Line: 982
    -- upvalues: u28 (ref), Router (copy)
    if u28 == p131 then
        return;
    end;

    local v132 = u28;
    u28 = p131;

    if v132 then
        v132.HoverOut:Play();
    end;

    if p131 then
        p131.HoverIn:Play();
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
    end;
end;

local function clearCardHover() -- Line: 1003
    -- upvalues: u27 (copy), u28 (ref)
    local function rest(p133: table) -- Line: 1004
        p133.HoverIn:Cancel();
        p133.HoverOut:Cancel();
        p133.Press:Cancel();
        p133.Scale.Scale = 1;
    end;

    for _, v in u27 do
        local v134 = v;

        for _, v2 in v.Regions do
            v2.HoverIn:Cancel();
            v2.HoverOut:Cancel();
            v2.Press:Cancel();
            v2.Scale.Scale = 1;
        end;

        if v134.FlipRegion then
            local FlipRegion = v134.FlipRegion;
            FlipRegion.HoverIn:Cancel();
            FlipRegion.HoverOut:Cancel();
            FlipRegion.Press:Cancel();
            FlipRegion.Scale.Scale = 1;
        end;
    end;

    u28 = nil;
end;

local function pressRegion(u135: table) -- Line: 1032
    -- upvalues: u28 (ref)
    u135.Press:Play();
    task.delay(0.15, function() -- Line: 1034
        -- upvalues: u28 (ref), u135 (copy)
        if u28 == u135 then
            u135.HoverIn:Play();

            return;
        end;

        u135.HoverOut:Play();
    end);
end;

local function isCardDiscontinued(p136) -- Line: 1050
    -- upvalues: Cases (copy)
    if typeof(p136) ~= "table" then
        return false;
    end;

    local CaseByName = Cases.GetCaseByName(p136.skin);

    if CaseByName then
        return not Cases.IsCaseForSale(CaseByName.caseId);
    end;

    return false;
end;

local function flipCardUp(p137: table) -- Line: 1066
    -- upvalues: BlackMarketSceneController (copy), u11 (copy), Cases (copy)
    BlackMarketSceneController.SetCardFaceUp(p137.Part, true, true);
    local v138 = tostring(p137.Card.cardId);

    if not BlackMarketSceneController.IsCardFaceUp(p137.Part) or u11[v138] then
        return;
    end;

    u11[v138] = true;
    local Card = p137.Card;
    local v139;

    if typeof(Card) == "table" then
        local CaseByName = Cases.GetCaseByName(Card.skin);

        if CaseByName then
            v139 = not Cases.IsCaseForSale(CaseByName.caseId);
        else
            v139 = false;
        end;
    else
        v139 = false;
    end;

    if v139 then
        BlackMarketSceneController.PlayDiscontinuedLine();

        return;
    end;

    BlackMarketSceneController.PlayRarityLine(p137.Card.rarity);
end;

local function promptTradeTokens(p140: number) -- Line: 1091
    -- upvalues: u30 (ref), u37 (ref), u4 (ref), u2 (copy), ReplicatedStorage (copy), Router (copy), CommaNumber (copy), u28 (ref), MarketplaceService (copy), LocalPlayer (copy)
    if u30 or (u37 or u4) then
        return;
    end;

    local v141 = nil;

    for _, v in u2 do
        if p140 <= v.Amount then
            v141 = v;
            break;
        end;

        v141 = v;
    end;

    if not (v141 and require(ReplicatedStorage.Interface.Screens.Menu.Store).CanBuyPaidCurrency()) then
        Router.broadcastRouter("CreateNotification", "Black Market", "You do not have enough Trade Tokens.", 5);

        return;
    end;

    local v142 = `You need {CommaNumber(p140)} more Trade {p140 == 1 and "Token" or "Tokens"}.`;
    Router.broadcastRouter("CreateNotification", "Black Market", v142, 5);
    u37 = v141.DevProductId;

    if u28 ~= nil then
        local v143 = u28;
        u28 = nil;

        if v143 then
            v143.HoverOut:Play();
        end;
    end;

    MarketplaceService:PromptProductPurchase(LocalPlayer, v141.DevProductId);
    Router.broadcastRouter("RunInterfaceSound", "UI Click");
end;

local function promptRefresh() -- Line: 1123
    -- upvalues: u30 (ref), u37 (ref), u4 (ref), DevProducts (copy), Router (copy), u25 (ref), u28 (ref), MarketplaceService (copy), LocalPlayer (copy)
    if u30 or (u37 or u4) then
        return;
    end;

    local v144 = DevProducts["Black Market Refresh"];

    if not (v144 and (v144.DevProductId and v144.DevProductId > 0)) then
        Router.broadcastRouter("CreateNotification", "Black Market", "Refreshing the deal is not available yet.", 5);

        return;
    end;

    if u25 and u25.refreshEnabled == false then
        Router.broadcastRouter("CreateNotification", "Black Market", "The dealer is not taking refreshes right now.", 5);

        return;
    end;

    u30 = true;

    if u28 ~= nil then
        local v145 = u28;
        u28 = nil;

        if v145 then
            v145.HoverOut:Play();
        end;
    end;

    MarketplaceService:PromptProductPurchase(LocalPlayer, v144.DevProductId);
    Router.broadcastRouter("RunInterfaceSound", "UI Click");
end;

local function ensureTargetLayer() -- Line: 1160
    -- upvalues: u39 (ref), LocalPlayer (copy), u38 (ref), GamepadNavigation (copy), u31 (ref)
    if u39 then
        return u39;
    end;

    local v146 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v146 then
        return nil;
    end;

    local v147 = u38:FindFirstAncestorWhichIsA("ScreenGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "BlackmarketCardTargets";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = (not v147 and 0 or v147.DisplayOrder) - 1;
    ScreenGui.Enabled = false;
    ScreenGui:SetAttribute(GamepadNavigation.NO_FALLBACK_ATTRIBUTE, true);
    ScreenGui.Parent = v146;
    local Frame = Instance.new("Frame");
    Frame.Name = "Targets";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Parent = ScreenGui;
    u31 = ScreenGui;
    u39 = Frame;

    return Frame;
end;

local function isCanvasMirrored(p148: userdata) -- Line: 1204
    local v149 = p148:FindFirstAncestorOfClass("SurfaceGui");
    local v150;

    if v149 == nil then
        v150 = false;
    else
        v150 = v149.Face == Enum.NormalId.Front;
    end;

    return v150;
end;

local function getPressPoint(p151: userdata, p152: userdata?) -- Line: 1218
    -- upvalues: GuiService (copy), UserInputService (copy)
    if p152 and (p152.UserInputType == Enum.UserInputType.MouseButton1 or p152.UserInputType == Enum.UserInputType.Touch) then
        return Vector2.new(p152.Position.X, p152.Position.Y) + GuiService:GetGuiInset();
    end;

    if p152 or not UserInputService.MouseEnabled then
        return p151.AbsolutePosition + p151.AbsoluteSize / 2;
    end;

    return UserInputService:GetMouseLocation();
end;

local function createCircle(p153: userdata, p154: string) -- Line: 1233
    local Frame = Instance.new("Frame");
    Frame.Name = p154;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.BorderSizePixel = 0;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;
    Frame.Parent = p153;

    return Frame;
end;

local function createFlipBurst(p155: userdata) -- Line: 1258
    -- upvalues: createCircle (copy), TweenService (copy), TweenInfo_new_ret3 (copy), TweenInfo_new_ret4 (copy), Random_new_ret (copy), TweenInfo_new_ret5 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "FlipBurst";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = 5;
    Frame.Visible = false;
    local v156 = createCircle(Frame, "Flash");
    v156.BackgroundColor3 = Color3.new(1, 1, 1);
    local v157 = createCircle(Frame, "Ring");
    v157.BackgroundTransparency = 1;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Parent = v157;
    local v158 = { TweenService:Create(v156, TweenInfo_new_ret3, {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0.4, 0.4)
        }), TweenService:Create(v157, TweenInfo_new_ret4, {
            Size = UDim2.fromScale(1, 1)
        }) };
    local v159 = TweenService:Create(UIStroke, TweenInfo_new_ret4, {
        Thickness = 0,
        Transparency = 1
    });
    table.insert(v158, v159);
    local NumberSequence_new_ret = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.6, 0.15), NumberSequenceKeypoint.new(1, 0) });
    local v160 = {};

    for i = 1, 10 do
        local v161 = i / 10 * 3.141592653589793 * 2 + Random_new_ret:NextNumber(-0.25, 0.25);
        local Vector2_new_ret = Vector2.new(math.cos(v161), (math.sin(v161)));
        local v162 = Random_new_ret:NextNumber(0.9, 1.5) / 2;
        local v163 = Random_new_ret:NextNumber(0.35, 0.6) / 2;
        local Frame2 = Instance.new("Frame");
        Frame2.Name = "Streak";
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame2.BorderSizePixel = 0;
        Frame2.Rotation = math.deg(v161);
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(1, 0);
        UICorner.Parent = Frame2;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Transparency = NumberSequence_new_ret;
        UIGradient.Parent = Frame2;
        Frame2.Parent = Frame;
        local v164 = Vector2_new_ret * 0.1;
        local v165 = Vector2_new_ret * v162;
        local v166 = {
            Frame = Frame2,
            Start = UDim2.fromScale(0.5 + v164.X, 0.5 + v164.Y),
            StartSize = UDim2.fromScale(v163, 0.03)
        };
        table.insert(v160, v166);
        local v167 = {
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5 + v165.X, 0.5 + v165.Y),
            Size = UDim2.fromScale(v163 * 0.15, 0.015)
        };
        table.insert(v158, TweenService:Create(Frame2, TweenInfo_new_ret5, v167));
        local _ = i;
    end;

    local v168 = TweenService:Create(UIStroke, TweenInfo_new_ret4, {
        Transparency = 1
    });
    local u169 = {
        IsBusy = false,
        Holder = Frame,
        Flash = v156,
        Ring = v157,
        RingStroke = UIStroke,
        Streaks = v160,
        Tweens = v158,
        FadeTween = v168
    };

    local function release() -- Line: 1344
        -- upvalues: Frame (copy), u169 (copy)
        Frame.Visible = false;
        u169.IsBusy = false;
    end;

    v159.Completed:Connect(release);
    v168.Completed:Connect(release);
    Frame.Parent = p155;

    return u169;
end;

local function acquireFlipBurst(p170: userdata) -- Line: 1358
    -- upvalues: u40 (copy), createFlipBurst (copy)
    for _, v in u40 do
        if not v.IsBusy then
            return v;
        end;
    end;

    local v171 = createFlipBurst(p170);
    table.insert(u40, v171);

    return v171;
end;

local function playFlipBurst(p172, p173: number, p174, p175: boolean) -- Line: 1378
    -- upvalues: u39 (ref), u40 (copy), createFlipBurst (copy), Random_new_ret (copy)
    local v176 = u39;

    if not v176 then
        return;
    end;

    local v177;

    for _, v in u40 do
        if not v.IsBusy then
            v177 = v;
            break;
        end;
    end;

    v177 = createFlipBurst(v176);
    table.insert(u40, v177);
    v177.IsBusy = true;
    local Holder = v177.Holder;
    Holder.Position = UDim2.fromOffset(p172.X, p172.Y);
    Holder.Size = UDim2.fromOffset(p173 * 2, p173 * 2);
    Holder.Rotation = p175 and 0 or Random_new_ret:NextNumber(0, 360);
    local RingStroke = v177.RingStroke;
    RingStroke.Transparency = 0;
    v177.Flash.Visible = not p175;

    for _, v in v177.Streaks do
        v.Frame.Visible = not p175;
    end;

    if p175 then
        v177.Ring.Size = UDim2.fromScale(0.6, 0.6);
        RingStroke.Color = p174;
        RingStroke.Thickness = 2;
        Holder.Visible = true;
        v177.FadeTween:Play();

        return;
    end;

    v177.Flash.Size = UDim2.fromScale(0.125, 0.125);
    v177.Flash.BackgroundTransparency = 0.05;
    v177.Ring.Size = UDim2.fromScale(0.15, 0.15);
    RingStroke.Color = p174:Lerp(Color3.new(1, 1, 1), 0.25);
    RingStroke.Thickness = math.max(p173 * 0.09, 2);

    for i, v in v177.Streaks do
        v.Frame.Position = v.Start;
        v.Frame.Size = v.StartSize;
        v.Frame.BackgroundTransparency = 0;
        local Frame = v.Frame;
        local v178;

        if i % 2 == 0 then
            v178 = Color3.new(1, 1, 1);
        else
            v178 = p174;
        end;

        Frame.BackgroundColor3 = v178;
    end;

    Holder.Visible = true;

    for _, v in v177.Tweens do
        v:Play();
    end;
end;

local function getCardPointUnder(p179: userdata, p180) -- Line: 1431
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return p179.Position;
    end;

    local v181 = workspace_CurrentCamera:ViewportPointToRay(p180.X, p180.Y);
    local LookVector = p179.CFrame.LookVector;
    local v182 = v181.Direction:Dot(LookVector);

    if math.abs(v182) < 0.001 then
        return p179.Position;
    end;

    local v183 = (p179.Position - v181.Origin):Dot(LookVector) / v182;

    return v181.Origin + v181.Direction * v183;
end;

local function playFlipEffect(p184: table, p185: userdata, p186: userdata?) -- Line: 1455
    -- upvalues: Rarities (copy), getPressPoint (copy), GuiService (copy), playFlipBurst (copy), getCardPointUnder (copy)
    local v187 = p184.Card and p184.Card.rarity;

    if v187 then
        v187 = Rarities[v187];
    end;

    local v188 = v187 and v187.Color or Rarities.Stock.Color;
    local v189 = getPressPoint(p185, p186);
    local math_clamp_ret = math.clamp(p185.AbsoluteSize.Y * 0.28, 36, 110);
    local ReducedMotionEnabled = GuiService.ReducedMotionEnabled;
    playFlipBurst(v189, math_clamp_ret, v188, ReducedMotionEnabled);

    if ReducedMotionEnabled then
        return;
    end;

    local Sparkles = p184.Sparkles;
    local v190;

    if Sparkles then
        v190 = Sparkles.Parent;
    else
        v190 = Sparkles;
    end;

    if not (Sparkles and (v190 and (v190:IsA("Attachment") and v190.Parent))) then
        local v191 = p184.Part.Size.Y * 0.075;
        v190 = Instance.new("Attachment");
        v190.Name = "FlipSparkleOrigin";
        v190.Parent = p184.Part;
        Sparkles = Instance.new("ParticleEmitter");
        Sparkles.Name = "FlipSparkles";
        Sparkles.Texture = "rbxasset://textures/particles/sparkles_main.dds";
        Sparkles.Rate = 0;
        Sparkles.Lifetime = NumberRange.new(0.35, 0.7);
        Sparkles.Speed = NumberRange.new(p184.Part.Size.Y * 1.2, p184.Part.Size.Y * 2.4);
        Sparkles.SpreadAngle = Vector2.new(180, 180);
        Sparkles.Drag = 6;
        Sparkles.Rotation = NumberRange.new(0, 360);
        Sparkles.RotSpeed = NumberRange.new(-240, 240);
        Sparkles.LightEmission = 1;
        Sparkles.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, v191), NumberSequenceKeypoint.new(0.25, v191 * 1.2), NumberSequenceKeypoint.new(1, 0) });
        Sparkles.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0.2), NumberSequenceKeypoint.new(1, 1) });
        Sparkles.Parent = v190;
        p184.Sparkles = Sparkles;
    end;

    if v190 and v190:IsA("Attachment") then
        v190.WorldPosition = getCardPointUnder(p184.Part, v189);
    end;

    Sparkles.Color = ColorSequence.new(Color3.new(1, 1, 1), v188);
    Sparkles:Emit(14);
end;

local function createTarget(u192: table, u193: table, u194: boolean, p195: string) -- Line: 1525
    -- upvalues: ensureTargetLayer (copy), BlackMarketSceneController (copy), u28 (ref), Router (copy), u30 (ref), u37 (ref), u4 (ref), GuiService (copy), playFlipEffect (copy), u32 (copy)
    local v196 = ensureTargetLayer();

    if not v196 then
        return;
    end;

    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = p195;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.ImageTransparency = 1;
    ImageButton.AutoButtonColor = false;
    ImageButton.AnchorPoint = Vector2.zero;
    ImageButton.ZIndex = u194 and 0 or 1;
    ImageButton.Visible = false;
    ImageButton.Parent = v196;

    local function hover() -- Line: 1545
        -- upvalues: u194 (copy), BlackMarketSceneController (ref), u192 (copy), u193 (copy), u28 (ref), Router (ref)
        if u194 and BlackMarketSceneController.IsCardFaceUp(u192.Part) then
            return;
        end;

        local v197 = u193;

        if u28 == v197 then
            return;
        end;

        local v198 = u28;
        u28 = v197;

        if v198 then
            v198.HoverOut:Play();
        end;

        if v197 then
            v197.HoverIn:Play();
            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        end;
    end;

    ImageButton.MouseEnter:Connect(hover);
    ImageButton.SelectionGained:Connect(hover);

    local function v200() -- Line: 1554
        -- upvalues: u28 (ref), u193 (copy)
        if u28 == u193 then
            if u28 == nil then
                return;
            end;

            local v199 = u28;
            u28 = nil;

            if v199 then
                v199.HoverOut:Play();
            end;
        end;
    end;

    ImageButton.MouseLeave:Connect(v200);
    ImageButton.SelectionLost:Connect(v200);
    ImageButton.Activated:Connect(function(p201: userdata?) -- Line: 1563
        -- upvalues: u30 (ref), u37 (ref), u4 (ref), GuiService (ref), Router (ref), u193 (copy), u28 (ref), u194 (copy), playFlipEffect (ref), u192 (copy), ImageButton (copy)
        if u30 or (u37 ~= nil and true or (u4 or GuiService.MenuIsOpen)) then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local u202 = u193;
        u202.Press:Play();
        task.delay(0.15, function() -- Line: 1034
            -- upvalues: u28 (ref), u202 (copy)
            if u28 == u202 then
                u202.HoverIn:Play();

                return;
            end;

            u202.HoverOut:Play();
        end);

        if u194 then
            playFlipEffect(u192, ImageButton, p201);
        end;

        u193.Activate();
    end);
    local v203 = {
        Button = ImageButton,
        Slot = u192,
        Region = u193,
        IsFlip = u194
    };
    local v204;

    if u194 then
        v204 = u192.Front;
    else
        v204 = u192.Back;
    end;

    local v205 = v204:FindFirstAncestorOfClass("SurfaceGui");
    local v206;

    if v205 == nil then
        v206 = false;
    else
        v206 = v205.Face == Enum.NormalId.Front;
    end;

    v203.IsMirrored = v206;
    table.insert(u32, v203);
end;

local function targetRect(p207: table) -- Line: 1596
    -- upvalues: BlackMarketSceneController (copy), projectCardRect (copy), isRegionVisible (copy)
    local Slot = p207.Slot;

    if Slot.Card == nil or not BlackMarketSceneController.IsCardShown(Slot.Part) then
        return nil, nil;
    end;

    if p207.IsFlip then
        local v208, v209 = projectCardRect(Slot.Part, Vector2.zero, Vector2.one, false);

        if not (v208 and (v209 and v209.Y > 0)) then
            return nil, nil;
        end;

        if v209.X < 12 then
            v208 = Vector2.new(v208.X + (v209.X - 12) / 2, v208.Y);
            v209 = Vector2.new(12, v209.Y);
        end;

        return v208, v209;
    end;

    if not (BlackMarketSceneController.IsCardFaceUp(Slot.Part) and isRegionVisible(p207.Region.Element, Slot.Back)) then
        return nil, nil;
    end;

    local Region = p207.Region;
    local AbsoluteSize = Slot.Back.AbsoluteSize;
    local v210, v211;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        v210 = nil;
        v211 = nil;
    else
        local Element = Region.Element;
        local AbsolutePosition = Element.AbsolutePosition;
        local AbsoluteSize2 = Element.AbsoluteSize;
        local Scale = Region.Scale.Scale;
        local v212;

        if Scale <= 0 or Scale >= 1 then
            v212 = AbsoluteSize2;
        else
            local AnchorPoint = Element.AnchorPoint;
            v212 = AbsoluteSize2 / Scale;
            AbsolutePosition = AbsolutePosition + AbsoluteSize2 * AnchorPoint - v212 * AnchorPoint;
        end;

        local v213 = AbsolutePosition - Slot.Back.AbsolutePosition;
        v210 = v213 / AbsoluteSize;
        v211 = (v213 + v212) / AbsoluteSize;
    end;

    if not (v210 and v211) then
        return nil, nil;
    end;

    local v214, v215, v216 = projectCardRect(Slot.Part, v210, v211, p207.IsMirrored);

    if v214 and (v215 and (v216 and (v215.X >= 12 and v215.Y > 0))) then
        return v214, v215;
    end;

    return nil, nil;
end;

local function refreshCardTargets() -- Line: 1662
    -- upvalues: u30 (ref), u37 (ref), u4 (ref), GuiService (copy), BlackMarketSceneController (copy), u33 (copy), u6 (copy), u46 (copy), u32 (copy), targetRect (copy), u47 (ref), u28 (ref), u7 (ref), GamepadNavigation (copy), u42 (ref)
    local v217 = u30 or (u37 ~= nil and true or (u4 or GuiService.MenuIsOpen)) or BlackMarketSceneController.IsPresenting();
    table.clear(u33);
    table.clear(u6);
    table.clear(u46);
    local v218 = nil;
    local v219 = nil;
    local v220 = false;

    for _, v in u32 do
        local Slot = v.Slot;
        local Button = v.Button;
        local v221, v222;

        if v217 then
            v221 = nil;
            v222 = nil;
        else
            v221, v222 = targetRect(v);
        end;

        if v221 and v222 then
            Button.Position = UDim2.fromOffset(v221.X, v221.Y);
            Button.Size = UDim2.fromOffset(v222.X, v222.Y);
            Button.Visible = true;
            v218 = v218 or Button;

            if Slot == u47 then
                v219 = v219 or Button;
            end;

            if v.IsFlip then
                u33[Slot] = Button;
            elseif v221.Y < (u46[Slot] or (1 / 0)) then
                u46[Slot] = v221.Y;
                u6[Slot] = Button;
            end;
        else
            Button.Visible = false;

            if u28 == v.Region then
                v220 = true;
            end;
        end;
    end;

    for i, v in u33 do
        v.NextSelectionDown = u6[i];
    end;

    for _, v in u32 do
        local Button = v.Button;

        if not v.IsFlip and Button.Visible then
            local Slot = v.Slot;
            local v223;

            if u6[Slot] == Button then
                v223 = u33[Slot];
            else
                v223 = nil;
            end;

            if Button.NextSelectionUp ~= v223 then
                Button.NextSelectionUp = v223;
            end;
        end;
    end;

    local v224 = nil;
    local v225 = u7;
    local v226;

    if v225 == nil then
        v226 = false;
    else
        v226 = GamepadNavigation.IsUsable(v225);
    end;

    if v225 and v226 then
        local v227 = v225.AbsolutePosition.X + v225.AbsoluteSize.X / 2;
        local v228 = (1 / 0);

        for _, v in u33 do
            local math_abs_ret = math.abs(v.AbsolutePosition.X + v.AbsoluteSize.X / 2 - v227);

            if math_abs_ret < v228 then
                v224 = v;
                v228 = math_abs_ret;
            end;
        end;
    end;

    for _, v in u33 do
        local v229;

        if v226 then
            v229 = v225;
        else
            v229 = nil;
        end;

        v.NextSelectionUp = v229;
    end;

    if v225 then
        v225.NextSelectionDown = v224;
    end;

    if v220 and u28 ~= nil then
        local v230 = u28;
        u28 = nil;

        if v230 then
            v230.HoverOut:Play();
        end;
    end;

    if v217 then
        return;
    end;

    if u42 and v218 then
        u42 = false;
        GuiService.SelectedObject = v218;

        return;
    end;

    local SelectedObject = GuiService.SelectedObject;

    if not SelectedObject then
        if u47 then
            GuiService.SelectedObject = v219 or v218;

            if not (v219 or v218) then
                u47 = nil;
            end;
        end;

        return;
    end;

    u47 = nil;

    for _, v in u32 do
        if v.Button == SelectedObject then
            u47 = v.Slot;

            return;
        end;
    end;
end;

local function createGlint(p231: userdata) -- Line: 1813
    -- upvalues: Color3_fromRGB_ret (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Glint";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Visible = false;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint.Parent = Frame;
    local NumberSequence_new_ret = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) });

    for _, v in { false, true } do
        local Frame2 = Instance.new("Frame");
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame2.Position = UDim2.fromScale(0.5, 0.5);
        local v232;

        if v then
            v232 = UDim2.fromScale(0.14, 1);
        else
            v232 = UDim2.fromScale(1, 0.14);
        end;

        Frame2.Size = v232;
        Frame2.BackgroundColor3 = Color3_fromRGB_ret;
        Frame2.BorderSizePixel = 0;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Rotation = v and 90 or 0;
        UIGradient.Transparency = NumberSequence_new_ret;
        UIGradient.Parent = Frame2;
        Frame2.Parent = Frame;
    end;

    Frame.Parent = p231;

    return Frame;
end;

local function scheduleGlint(p233: table, p234: table, p235: number) -- Line: 1854
    -- upvalues: Random_new_ret (copy)
    local Vector2_zero = Vector2.zero;
    local v236 = -1;

    for i = 1, 12 do
        local Vector2_new_ret = Vector2.new(Random_new_ret:NextNumber(0.12, 0.88), Random_new_ret:NextNumber(0.15, 0.85));
        local _ = i;
        local v237 = (1 / 0);

        for _, v in p233.Glints do
            if v ~= p234 and v.Lifetime > 0 then
                v237 = math.min(v237, (v.Spot - Vector2_new_ret).Magnitude);
            end;
        end;

        if v236 < v237 then
            v236 = v237;
        else
            Vector2_new_ret = Vector2_zero;
        end;

        if v237 >= 0.22 then
            Vector2_zero = Vector2_new_ret;
            break;
        end;

        Vector2_zero = Vector2_new_ret;
    end;

    p234.StartsAt = p235;
    p234.Lifetime = Random_new_ret:NextNumber(1.4, 2.6);
    p234.Size = Random_new_ret:NextNumber(0.09, 0.17);
    p234.Spot = Vector2_zero;
    p234.Frame.Position = UDim2.fromScale(Vector2_zero.X, Vector2_zero.Y);
end;

local function scatterCardGlints() -- Line: 1885
    -- upvalues: u27 (copy), scheduleGlint (copy), Random_new_ret (copy)
    local os_clock_ret = os.clock();

    for _, v in u27 do
        local v238 = v;

        for _, v2 in v.Glints do
            scheduleGlint(v238, v2, os_clock_ret + Random_new_ret:NextNumber(0, 4.2));
        end;
    end;
end;

local function updateCardGlints() -- Line: 1901
    -- upvalues: GuiService (copy), u27 (copy), BlackMarketSceneController (copy), scheduleGlint (copy), Random_new_ret (copy)
    local os_clock_ret = os.clock();
    local ReducedMotionEnabled = GuiService.ReducedMotionEnabled;

    for _, v in u27 do
        local v239 = not ReducedMotionEnabled;

        if v239 then
            if v.Card == nil then
                v239 = false;
            else
                v239 = BlackMarketSceneController.IsCardFaceUp(v.Part);
            end;
        end;

        local v240 = v;

        for _, v2 in v.Glints do
            if v239 then
                if v2.StartsAt + v2.Lifetime < os_clock_ret then
                    scheduleGlint(v240, v2, os_clock_ret + Random_new_ret:NextNumber(0.2, 1.6));
                end;

                local v241 = (os_clock_ret - v2.StartsAt) / v2.Lifetime;
                local v242;

                if v241 >= 0 then
                    v242 = v241 <= 1;
                else
                    v242 = false;
                end;

                v2.Frame.Visible = v242;

                if v242 then
                    local math_sin_ret = math.sin(v241 * 3.141592653589793);
                    v2.Frame.Size = UDim2.fromScale(v2.Size * math_sin_ret, v2.Size * math_sin_ret);
                    v2.Frame.Rotation = v241 * 45;
                end;
            else
                v2.Frame.Visible = false;
            end;
        end;
    end;
end;

local function shouldSelectOnOpen() -- Line: 1936
    -- upvalues: UserInputService (copy)
    return UserInputService.GamepadEnabled and not UserInputService.MouseEnabled and true or UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1;
end;

local function startCardInput() -- Line: 1954
    -- upvalues: ensureTargetLayer (copy), u31 (ref), BlackMarketSceneController (copy), u42 (ref), Router (copy), UserInputService (copy), u30 (ref), u37 (ref), u4 (ref), GuiService (copy), u1 (copy), u21 (copy), u43 (ref), RunServiceController (copy), refreshCardTargets (copy), scatterCardGlints (copy), u15 (ref), updateCardGlints (copy)
    ensureTargetLayer();

    if u31 then
        u31.Enabled = true;
    end;

    local function skipForPad() -- Line: 1969
        -- upvalues: BlackMarketSceneController (ref), u42 (ref), Router (ref)
        BlackMarketSceneController.SkipPresentation();
        u42 = true;
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end;

    local os_clock_ret = os.clock();
    local u243 = false;
    local v245 = UserInputService.InputBegan:Connect(function(p244: userdata) -- Line: 1980
        -- upvalues: BlackMarketSceneController (ref), u30 (ref), u37 (ref), u4 (ref), GuiService (ref), os_clock_ret (copy), u1 (ref), u42 (ref), Router (ref)
        if not (BlackMarketSceneController.IsPresenting() and (not (u30 or (u37 ~= nil or (u4 or GuiService.MenuIsOpen))) and os.clock() - os_clock_ret >= 0.3)) then
            return;
        end;

        local UserInputType = p244.UserInputType;
        local KeyCode = p244.KeyCode;

        if not u1[KeyCode] then
            if UserInputType == Enum.UserInputType.MouseButton1 or (UserInputType == Enum.UserInputType.Touch or (KeyCode == Enum.KeyCode.ButtonA or (KeyCode == Enum.KeyCode.Return or KeyCode == Enum.KeyCode.Space))) then
                BlackMarketSceneController.SkipPresentation();
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
            end;

            return;
        end;

        BlackMarketSceneController.SkipPresentation();
        u42 = true;
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    table.insert(u21, v245);
    local v247 = UserInputService.InputChanged:Connect(function(p246: userdata) -- Line: 2006
        -- upvalues: u243 (ref), os_clock_ret (copy), BlackMarketSceneController (ref), u30 (ref), u37 (ref), u4 (ref), GuiService (ref), u42 (ref), Router (ref)
        if p246.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return;
        end;

        local Magnitude = Vector2.new(p246.Position.X, p246.Position.Y).Magnitude;

        if Magnitude < 0.2 then
            u243 = true;

            return;
        end;

        if not (u243 and (Magnitude >= 0.5 and (os.clock() - os_clock_ret >= 0.3 and BlackMarketSceneController.IsPresenting()))) or (u30 or (u37 ~= nil or (u4 or GuiService.MenuIsOpen))) then
            return;
        end;

        BlackMarketSceneController.SkipPresentation();
        u42 = true;
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    table.insert(u21, v247);
    u42 = UserInputService.GamepadEnabled and not UserInputService.MouseEnabled and true or UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1;
    u43 = RunServiceController.BindToHeartbeat("UI.Blackmarket.CardTargets", refreshCardTargets);
    refreshCardTargets();
    scatterCardGlints();
    u15 = RunServiceController.BindToRenderStep("UI.Blackmarket.CardGlints", updateCardGlints);
end;

local function bindSlot(u248: table) -- Line: 2059
    -- upvalues: TweenService (copy), TweenInfo_new_ret2 (copy), createTarget (copy), BlackMarketSceneController (copy), flipCardUp (copy), u5 (copy), createGlint (copy), u12 (ref), InspectController (copy), toPreviewItem (copy), ReplicatedStorage (copy), u16 (ref), u44 (copy), u36 (copy), u25 (ref), Router (copy), u34 (copy), DataController (copy), LocalPlayer (copy), promptTradeTokens (copy), BlackMarketDealer (copy)
    local u249 = {};

    local function addRegion(p250: userdata?, p251: function) -- Line: 2062
        -- upvalues: TweenService (ref), TweenInfo_new_ret2 (ref), u249 (copy), createTarget (ref), u248 (copy)
        if not (p250 and p250:IsA("GuiObject")) then
            return;
        end;

        local v252 = p250:FindFirstChildOfClass("UIScale") or Instance.new("UIScale");
        v252.Parent = p250;
        local v253 = {
            Element = p250,
            Activate = p251,
            Scale = v252,
            HoverIn = TweenService:Create(v252, TweenInfo_new_ret2, {
                Scale = 0.95
            }),
            HoverOut = TweenService:Create(v252, TweenInfo_new_ret2, {
                Scale = 1
            }),
            Press = TweenService:Create(v252, TweenInfo_new_ret2, {
                Scale = 0.9
            })
        };
        table.insert(u249, v253);
        createTarget(u248, v253, false, p250.Name);
    end;

    if u248.Front.AnchorPoint == Vector2.zero and (u248.Front.Position == UDim2.fromScale(0, 0) and u248.Front.Size == UDim2.fromScale(1, 1)) then
        u248.Front.AnchorPoint = Vector2.new(0.5, 0.5);
        u248.Front.Position = UDim2.fromScale(0.5, 0.5);
    end;

    local v254 = u248.Front:FindFirstChildOfClass("UIScale") or Instance.new("UIScale");
    v254.Parent = u248.Front;
    local v255 = {
        Element = u248.Front,

        Activate = function() -- Line: 2104, Name: Activate
            -- upvalues: BlackMarketSceneController (ref), u248 (copy), flipCardUp (ref), u5 (ref)
            if BlackMarketSceneController.IsCardFaceUp(u248.Part) then
                BlackMarketSceneController.SetCardFaceUp(u248.Part, false, true);
            else
                flipCardUp(u248);
            end;

            if u248.Card then
                u5[tostring(u248.Card.cardId)] = BlackMarketSceneController.IsCardFaceUp(u248.Part);
            end;
        end,

        Scale = v254,
        HoverIn = TweenService:Create(v254, TweenInfo_new_ret2, {
            Scale = 0.95
        }),
        HoverOut = TweenService:Create(v254, TweenInfo_new_ret2, {
            Scale = 1
        }),
        Press = TweenService:Create(v254, TweenInfo_new_ret2, {
            Scale = 0.9
        })
    };
    u248.FlipRegion = v255;
    createTarget(u248, v255, true, "Flip");
    local ItemTemplate = u248.Back:FindFirstChild("ItemTemplate");

    if ItemTemplate then
        ItemTemplate = ItemTemplate:FindFirstChild("ItemContent");
    end;

    local u256;

    if ItemTemplate then
        u256 = ItemTemplate:FindFirstChild("Content");
    else
        u256 = ItemTemplate;
    end;

    if u256 then
        u256 = u256:FindFirstChild("Icon");
    end;

    local Parent = u248.Back.Parent;

    if u256 and (u256:IsA("GuiObject") and (Parent and Parent:IsA("SurfaceGui"))) then
        local Frame = Instance.new("Frame");
        Frame.Name = "Glints";
        Frame.BackgroundTransparency = 1;
        Frame.Active = false;
        Frame.ZIndex = u248.Back.ZIndex + 1;
        Frame.Parent = Parent;

        local function fitGlintLayer() -- Line: 2148
            -- upvalues: u256 (copy), Parent (copy), Frame (copy)
            local v257 = u256.AbsolutePosition - Parent.AbsolutePosition;
            Frame.Position = UDim2.fromOffset(v257.X, v257.Y);
            Frame.Size = UDim2.fromOffset(u256.AbsoluteSize.X, u256.AbsoluteSize.Y);
        end;

        u256:GetPropertyChangedSignal("AbsolutePosition"):Connect(fitGlintLayer);
        u256:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitGlintLayer);
        local v258 = u256.AbsolutePosition - Parent.AbsolutePosition;
        Frame.Position = UDim2.fromOffset(v258.X, v258.Y);
        Frame.Size = UDim2.fromOffset(u256.AbsoluteSize.X, u256.AbsoluteSize.Y);

        for i = 1, 6 do
            local Glints = u248.Glints;
            local v259 = {
                StartsAt = (-1 / 0),
                Lifetime = 0,
                Size = 0,
                Frame = createGlint(Frame),
                Spot = Vector2.zero
            };
            table.insert(Glints, v259);
            local _ = i;
        end;
    end;

    if ItemTemplate then
        ItemTemplate = ItemTemplate:FindFirstChild("Inspect");
    end;

    addRegion(ItemTemplate, function() -- Line: 2169
        -- upvalues: u248 (copy), u12 (ref), InspectController (ref), toPreviewItem (ref)
        local Card = u248.Card;

        if Card then
            u12 = true;
            InspectController.ShowInspect((toPreviewItem(Card)));
        end;
    end);
    local Bottom = u248.Back:FindFirstChild("Bottom");

    if Bottom then
        Bottom = Bottom:FindFirstChild("Interact");
    end;

    if Bottom then
        local Buy = Bottom:FindFirstChild("Buy");
        local View = Bottom:FindFirstChild("View");
        local v260;

        if View then
            v260 = View:FindFirstChild("Title");
        else
            v260 = View;
        end;

        if v260 and v260:IsA("TextLabel") then
            v260.Text = "VIEW ON MARKETPLACE";
        end;

        if Buy and (Buy:IsA("GuiObject") and (View and View:IsA("GuiObject"))) then
            u248.BuyWideLayout = {
                Position = UDim2.new(View.Position.X.Scale, View.Position.X.Offset, Buy.Position.Y.Scale, Buy.Position.Y.Offset),
                Size = UDim2.new(View.Size.X.Scale, View.Size.X.Offset, Buy.Size.Y.Scale, Buy.Size.Y.Offset)
            };
        end;

        addRegion(Bottom:FindFirstChild("View"), function() -- Line: 2207
            -- upvalues: u248 (copy), ReplicatedStorage (ref), u12 (ref), u16 (ref), u44 (ref)
            local Card = u248.Card;

            if not Card then
                return;
            end;

            local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
            local GlobalMarketPlace = require(ReplicatedStorage.Interface.Screens.Menu.GlobalMarketPlace);
            u12 = true;
            u16 = true;
            GlobalMarketPlace.SetReturnScreen("Blackmarket");
            local v261 = not u44[tostring(Card.offerKind)] and typeof(Card.float) == "number";
            local SearchForItem = GlobalMarketPlace.SearchForItem;
            local name = Card.name;
            local skin = Card.skin;
            local v262 = {};
            local v263;

            if v261 then
                v263 = Card.float;
            else
                v263 = nil;
            end;

            v262.Float = v263;
            v262.StatTrak = Card.isStattrak == true;
            SearchForItem(name, skin, v262);
            Top.openFrame("GlobalMarketPlace");
        end);
        addRegion(Bottom:FindFirstChild("Buy"), function() -- Line: 2232
            -- upvalues: u248 (copy), u36 (ref), u25 (ref), Router (ref), u34 (ref), ReplicatedStorage (ref), DataController (ref), LocalPlayer (ref), promptTradeTokens (ref), BlackMarketDealer (ref)
            local Card = u248.Card;

            if not (Card and (Card.status == "available" and not u36[tostring(Card.cardId)])) then
                return;
            end;

            if u25 and u25.buyEnabled == false then
                Router.broadcastRouter("CreateNotification", "Black Market", "The dealer is not taking Trade Tokens right now.", 5);

                return;
            end;

            if u34[tostring(Card.offerKind)] and not require(ReplicatedStorage.Interface.Screens.Menu.Store).CanBuyPaidCurrency() then
                Router.broadcastRouter("CreateMenuNotification", "Error", "Paid random items are restricted in your region");

                return;
            end;

            local v264 = tonumber(Card.price) or 0;
            local math_floor_ret = math.floor(v264);
            local v265 = DataController.Get(LocalPlayer, "TradeTokens");

            if typeof(v265) == "number" and v265 < math_floor_ret then
                promptTradeTokens(math_floor_ret - v265);

                return;
            end;

            BlackMarketDealer.BuyCard.Send(Card.cardId);
        end);
    end;

    u248.Regions = u249;
end;

local function ensureSlots() -- Line: 2275
    -- upvalues: u22 (ref), BlackMarketSceneController (copy), u27 (copy), bindSlot (copy)
    if u22 then
        return;
    end;

    local Cards = BlackMarketSceneController.GetCards();

    if #Cards == 0 then
        return;
    end;

    for i, v in Cards do
        local CardFaces, v266 = BlackMarketSceneController.GetCardFaces(v);

        if CardFaces and (CardFaces:IsA("GuiObject") and (v266 and v266:IsA("GuiObject"))) then
            local v267 = {
                Card = nil,
                Part = v,
                Back = CardFaces,
                Front = v266,
                Regions = {},
                Glints = {}
            };
            u27[i] = v267;
            bindSlot(v267);
        end;
    end;

    u22 = #u27 > 0;
end;

local function beginPaidRoll() -- Line: 2310
    -- upvalues: u4 (ref), u3 (ref), u13 (ref), u51 (ref), u45 (ref), u17 (ref), u35 (ref)
    u4 = true;

    if u3 then
        local v268 = u13;

        if v268 and u51 ~= true then
            u51 = true;
            v268.Visible = true;
            local v269 = u45;

            if v269 then
                v269:Play();
            end;
        end;
    end;

    u17 = u17 + 1;
    local u270 = u17;
    task.delay(60, function() -- Line: 2322
        -- upvalues: u270 (copy), u17 (ref), u4 (ref), u13 (ref), u51 (ref), u45 (ref), u35 (ref)
        if u270 ~= u17 then
            return;
        end;

        u4 = false;
        local v271 = u13;

        if v271 then
            if u51 == false then
                return;
            end;

            u51 = false;
            v271.Visible = false;
            local v272 = u45;

            if not v272 then
                return;
            end;

            if u35 then
                v272:Cancel();
                u35.Rotation = 0;
            end;
        end;
    end);
end;

local function finishPaidRoll() -- Line: 2336
    -- upvalues: u17 (ref), u4 (ref), u13 (ref), u51 (ref), u45 (ref), u35 (ref)
    u17 = u17 + 1;
    u4 = false;
    local v273 = u13;

    if v273 then
        if u51 == false then
            return;
        end;

        u51 = false;
        v273.Visible = false;
        local v274 = u45;

        if not v274 then
            return;
        end;

        if u35 then
            v274:Cancel();
            u35.Rotation = 0;
        end;
    end;
end;

local function playPaidRoll() -- Line: 2355
    -- upvalues: BlackMarketSceneController (copy), clearCardHover (copy)
    if not BlackMarketSceneController.IsActive() then
        return;
    end;

    clearCardHover();
    BlackMarketSceneController.Redeal();
    BlackMarketSceneController.PlayRefreshLine();
end;

local function applyDeal(p275: any, p276: boolean) -- Line: 2372
    -- upvalues: dealSignature (copy), u25 (ref), u36 (copy), u5 (copy), u11 (copy), u17 (ref), u4 (ref), u13 (ref), u51 (ref), u45 (ref), u35 (ref), BlackMarketSceneController (copy), clearCardHover (copy), renderDeal (copy)
    local v277 = dealSignature(p275) ~= dealSignature(u25);

    if v277 or p276 then
        table.clear(u36);
        table.clear(u5);
        table.clear(u11);
    end;

    if p276 then
        u17 = u17 + 1;
        u4 = false;
        local v278 = u13;

        if v278 and u51 ~= false then
            u51 = false;
            v278.Visible = false;
            local v279 = u45;

            if v279 and u35 then
                v279:Cancel();
                u35.Rotation = 0;
            end;
        end;

        if BlackMarketSceneController.IsActive() then
            clearCardHover();
            BlackMarketSceneController.Redeal();
            BlackMarketSceneController.PlayRefreshLine();
        end;
    elseif v277 and BlackMarketSceneController.IsActive() then
        BlackMarketSceneController.ResetCards();
    end;

    renderDeal(p275);
end;

local function openFrame() -- Line: 2402
    -- upvalues: u12 (ref), ReplicatedStorage (copy), u23 (ref), MenuSceneController (copy), u29 (ref), BlackMarketSceneController (copy), u8 (ref), ensureSlots (copy), u27 (copy), u24 (copy), startCardInput (copy), renderDeal (copy), u25 (ref), u26 (ref), u14 (ref), BlackMarketDealer (copy), u4 (ref), u13 (ref), u51 (ref), u45 (ref), u35 (ref), u18 (ref), u41 (ref), RunServiceController (copy), updateCountdown (copy)
    local v280 = u12;
    u12 = false;

    if not v280 then
        local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
        u23 = MenuSceneController.IsActive() or not SpectateController.IsSpectatingNow();
    end;

    MenuSceneController.HideMenuScene(true, true);
    local v281 = u29 and u29:FindFirstChild("Top");

    if v281 then
        v281 = v281:FindFirstChild("Bottom");
    end;

    if v281 and v281:IsA("GuiObject") then
        v281.Visible = false;
    end;

    BlackMarketSceneController.Show(v280 or not u8);
    ensureSlots();

    if v280 then
        for _, v in u27 do
            if u24[v.Part] then
                BlackMarketSceneController.SetCardFaceUp(v.Part, true, false);
            end;
        end;
    end;

    table.clear(u24);
    startCardInput();
    renderDeal(u25);
    local v282 = u26;

    if not v282 or v282 - os.clock() <= 0 then
        local os_clock_ret = os.clock();

        if os_clock_ret - u14 >= 10 then
            u14 = os_clock_ret;
            BlackMarketDealer.RequestDeal.Send();
        end;
    end;

    local v283 = u4;
    local v284 = u13;

    if v284 and v283 ~= u51 then
        u51 = v283;
        v284.Visible = v283;
        local v285 = u45;

        if v285 then
            if v283 then
                v285:Play();
            elseif u35 then
                v285:Cancel();
                u35.Rotation = 0;
            end;
        end;
    end;

    u18 = (1 / 0);
    u41 = RunServiceController.BindToHeartbeat("UI.Blackmarket.Countdown", function(p286: number) -- Line: 2439
        -- upvalues: u18 (ref), updateCountdown (ref), u26 (ref), u14 (ref), BlackMarketDealer (ref)
        u18 = u18 + p286;

        if u18 < 0.25 then
            return;
        end;

        u18 = 0;
        updateCountdown();
        local v287 = u26;

        if v287 and v287 - os.clock() > 0 then
            return;
        end;

        local os_clock_ret = os.clock();

        if os_clock_ret - u14 < 10 then
            return;
        end;

        u14 = os_clock_ret;
        BlackMarketDealer.RequestDeal.Send();
    end);
end;

local function closeFrame() -- Line: 2456
    -- upvalues: u21 (copy), u43 (ref), u15 (ref), clearCardHover (copy), u31 (ref), u32 (copy), u13 (ref), u51 (ref), u45 (ref), u35 (ref), u37 (ref), u42 (ref), u47 (ref), u41 (ref), u24 (copy), u12 (ref), u27 (copy), BlackMarketSceneController (copy), u29 (ref), u23 (ref), MenuSceneController (copy)
    for _, v in u21 do
        v:Disconnect();
    end;

    table.clear(u21);

    if u43 then
        u43:Disconnect();
        u43 = nil;
    end;

    if u15 then
        u15:Disconnect();
        u15 = nil;
    end;

    clearCardHover();

    if u31 then
        u31.Enabled = false;
    end;

    for _, v in u32 do
        v.Button.Visible = false;
    end;

    local v288 = u13;

    if v288 and u51 ~= false then
        u51 = false;
        v288.Visible = false;
        local v289 = u45;

        if v289 and u35 then
            v289:Cancel();
            u35.Rotation = 0;
        end;
    end;

    u37 = nil;
    u42 = false;
    u47 = nil;

    if u41 then
        u41:Disconnect();
        u41 = nil;
    end;

    table.clear(u24);

    if u12 then
        for _, v in u27 do
            u24[v.Part] = BlackMarketSceneController.IsCardFaceUp(v.Part);
        end;
    end;

    BlackMarketSceneController.Hide();

    if not u12 then
        local v290 = u29 and u29:FindFirstChild("Top");

        if v290 then
            v290 = v290:FindFirstChild("Bottom");
        end;

        if v290 and v290:IsA("GuiObject") then
            v290.Visible = true;
        end;
    end;

    if u29 and (u29.Visible and u23) then
        MenuSceneController.ShowMenuScene();
    end;
end;

local function syncScreenState() -- Line: 2533
    -- upvalues: u38 (ref), u29 (ref), u3 (ref), openFrame (copy), closeFrame (copy)
    local v291 = u38.Visible and (u29 == nil and true or u29.Visible);

    if v291 == u3 then
        return;
    end;

    u3 = v291;

    if v291 then
        openFrame();

        return;
    end;

    closeFrame();
end;

function v19.SetIntroEnabled(p292: boolean) -- Line: 2554
    -- upvalues: u8 (ref)
    u8 = p292 ~= false;
end;

function v19.Initialize(p293: userdata, u294: userdata) -- Line: 2561
    -- upvalues: u38 (ref), Constants (copy), u29 (ref), u13 (ref), u35 (ref), u45 (ref), TweenService (copy), TweenInfo_new_ret (copy), MenuState (copy), u16 (ref), u20 (ref), ReplicatedStorage (copy), ActivateButton (copy), CloseButtonRegistry (copy), promptRefresh (copy), u7 (ref), DataController (copy), LocalPlayer (copy), CommaNumber (copy), syncScreenState (copy), u3 (ref), openFrame (copy), closeFrame (copy)
    u38 = u294;

    if not Constants.BLACK_MARKET_ENABLED then
        u294.Visible = false;

        return;
    end;

    local Parent = u294.Parent;

    if not (Parent and (Parent:IsA("GuiObject") and Parent)) then
        Parent = nil;
    end;

    u29 = Parent;
    local Loading = p293:FindFirstChild("Loading");
    local v295;

    if Loading then
        v295 = Loading:FindFirstChild("Loading");
    else
        v295 = Loading;
    end;

    if Loading and (Loading:IsA("GuiObject") and (v295 and v295:IsA("GuiObject"))) then
        u13 = Loading;
        u35 = v295;
        u45 = TweenService:Create(v295, TweenInfo_new_ret, {
            Rotation = 359
        });
    end;

    MenuState.OnScreenChanged:Connect(function(p296: string?, p297: string?) -- Line: 2583
        -- upvalues: u16 (ref), u20 (ref)
        if p297 == "Blackmarket" then
            local v298 = u16 and p296 == "GlobalMarketPlace";
            u16 = false;

            if p296 and not v298 then
                u20 = p296;
            end;
        end;
    end);

    local function goBack() -- Line: 2594
        -- upvalues: ReplicatedStorage (ref), u20 (ref)
        require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame(u20 or "Dashboard");
    end;

    local Back = u294:FindFirstChild("Back");

    if Back and Back:IsA("GuiButton") then
        ActivateButton(Back);
        Back.Activated:Connect(goBack);
    end;

    CloseButtonRegistry.Add(u294, nil, goBack);
    local Refresh = u294:FindFirstChild("Refresh");

    if Refresh and Refresh:IsA("GuiButton") then
        ActivateButton(Refresh);
        Refresh.Activated:Connect(promptRefresh);
        u7 = Refresh;
    end;

    local TradeTokens = u294:FindFirstChild("TradeTokens");
    local u299;

    if TradeTokens then
        u299 = TradeTokens:FindFirstChild("TextLabel");
    else
        u299 = TradeTokens;
    end;

    if u299 and u299:IsA("TextLabel") then
        u299.Text = "0";
        DataController.CreateListener(LocalPlayer, "TradeTokens", function(p300) -- Line: 2623
            -- upvalues: u299 (copy), CommaNumber (ref)
            local v301 = tonumber(p300) or 0;
            u299.Text = CommaNumber((math.floor(v301)));

            return nil;
        end);
    end;

    if TradeTokens then
        TradeTokens = TradeTokens:FindFirstChild("PurchaseMore");
    end;

    if TradeTokens and TradeTokens:IsA("GuiButton") then
        ActivateButton(TradeTokens);
        TradeTokens.Activated:Connect(function() -- Line: 2631
            -- upvalues: ReplicatedStorage (ref), MenuState (ref)
            local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
            local Store = require(ReplicatedStorage.Interface.Screens.Menu.Store);
            Top.openFrame("Store");

            if MenuState.GetCurrentScreen() == "Store" then
                Store.OpenTab("TradeTokens");
            end;
        end);
        u294:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2642
            -- upvalues: u294 (copy), ReplicatedStorage (ref), TradeTokens (copy)
            if u294.Visible then
                TradeTokens.Visible = require(ReplicatedStorage.Interface.Screens.Menu.Store).CanBuyPaidCurrency();
            end;
        end);
    end;

    u294:GetPropertyChangedSignal("Visible"):Connect(syncScreenState);

    if u29 then
        u29:GetPropertyChangedSignal("Visible"):Connect(syncScreenState);
    end;

    local v302 = u38.Visible and (u29 == nil and true or u29.Visible);

    if v302 == u3 then
        return;
    end;

    u3 = v302;

    if v302 then
        openFrame();

        return;
    end;

    closeFrame();
end;

function v19.Start() -- Line: 2659
    -- upvalues: Constants (copy), MarketplaceService (copy), u37 (ref), DevProducts (copy), u30 (ref), u9 (ref), applyDeal (copy), u4 (ref), u3 (ref), u13 (ref), u51 (ref), u45 (ref), u17 (ref), u35 (ref), BlackMarketDealer (copy), Router (copy), u26 (ref), u10 (ref), dealSignature (copy), u25 (ref), u36 (copy), u27 (copy), renderSlot (copy), BlackMarketSceneController (copy)
    if not Constants.BLACK_MARKET_ENABLED then
        return;
    end;

    MarketplaceService.PromptProductPurchaseFinished:Connect(function(p303: number, p304: number, p305: boolean) -- Line: 2670
        -- upvalues: u37 (ref), DevProducts (ref), u30 (ref), u9 (ref), applyDeal (ref), u4 (ref), u3 (ref), u13 (ref), u51 (ref), u45 (ref), u17 (ref), u35 (ref)
        if p304 == u37 then
            u37 = nil;

            return;
        end;

        local v306 = DevProducts["Black Market Refresh"];

        if not v306 or p304 ~= v306.DevProductId then
            return;
        end;

        u30 = false;
        local v307 = u9;
        u9 = nil;

        if v307 then
            if v307.success then
                applyDeal(v307.deal, true);
            end;
        elseif p305 then
            u4 = true;

            if u3 then
                local v308 = u13;

                if v308 and u51 ~= true then
                    u51 = true;
                    v308.Visible = true;
                    local v309 = u45;

                    if v309 then
                        v309:Play();
                    end;
                end;
            end;

            u17 = u17 + 1;
            local u310 = u17;
            task.delay(60, function() -- Line: 2322
                -- upvalues: u310 (copy), u17 (ref), u4 (ref), u13 (ref), u51 (ref), u45 (ref), u35 (ref)
                if u310 ~= u17 then
                    return;
                end;

                u4 = false;
                local v311 = u13;

                if v311 then
                    if u51 == false then
                        return;
                    end;

                    u51 = false;
                    v311.Visible = false;
                    local v312 = u45;

                    if not v312 then
                        return;
                    end;

                    if u35 then
                        v312:Cancel();
                        u35.Rotation = 0;
                    end;
                end;
            end);
        end;
    end);
    BlackMarketDealer.DealData.Listen(function(p313) -- Line: 2698
        -- upvalues: u30 (ref), u4 (ref), u9 (ref), u17 (ref), u13 (ref), u51 (ref), u45 (ref), u35 (ref), Router (ref), u26 (ref), u10 (ref), dealSignature (ref), u25 (ref), applyDeal (ref)
        local v314;

        if typeof(p313) == "table" then
            v314 = p313.isRefresh == true;
        else
            v314 = false;
        end;

        local v315 = v314 and u30 and not u4;

        if v315 and (p313.success or not (u9 and u9.success)) then
            u9 = p313;
        end;

        if typeof(p313) ~= "table" or not p313.success then
            if u4 and v314 then
                u17 = u17 + 1;
                u4 = false;
                local v316 = u13;

                if v316 and u51 ~= false then
                    u51 = false;
                    v316.Visible = false;
                    local v317 = u45;

                    if v317 and u35 then
                        v317:Cancel();
                        u35.Rotation = 0;
                    end;
                end;
            end;

            local v318 = typeof(p313) == "table" and p313.message or "The Black Market is unavailable.";
            Router.broadcastRouter("CreateNotification", "Black Market", v318, 5);

            return;
        end;

        local deal = p313.deal;
        local v319;

        if typeof(deal) == "table" then
            v319 = tonumber(deal.msRemaining) or nil;
        else
            v319 = nil;
        end;

        local v320;

        if v319 then
            v320 = os.clock() + v319 / 1000;
        else
            v320 = nil;
        end;

        u26 = v320;
        u10 = nil;

        if v315 then
            return;
        end;

        local v321 = dealSignature(p313.deal) ~= dealSignature(u25);

        if v314 then
            v314 = u4 or v321;
        end;

        applyDeal(p313.deal, v314);
    end);
    BlackMarketDealer.BuyCardResult.Listen(function(p322) -- Line: 2750
        -- upvalues: Router (ref), u36 (ref), u27 (ref), renderSlot (ref), BlackMarketSceneController (ref)
        if typeof(p322) == "table" and p322.error == "REGION_RESTRICTED" then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Paid random items are restricted in your region");

            return;
        end;

        if typeof(p322) ~= "table" or not p322.success then
            local v323 = typeof(p322) == "table" and p322.message or "The purchase failed.";
            Router.broadcastRouter("CreateNotification", "Black Market", v323, 5);

            return;
        end;

        local cardId = p322.cardId;

        if cardId ~= nil then
            u36[tostring(cardId)] = true;

            for _, v in u27 do
                if v.Card and tostring(v.Card.cardId) == tostring(cardId) then
                    renderSlot(v, v.Card);
                end;
            end;
        end;

        Router.broadcastRouter("RunStoreSound", "Successful Purchase");
        BlackMarketSceneController.PlayPurchaseLine();
    end);
end;

return v19;