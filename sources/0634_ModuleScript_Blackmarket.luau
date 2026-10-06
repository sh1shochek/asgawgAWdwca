-- Decompiled with Potassium's decompiler.

local v1 = {};
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
local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local BlackMarketDealer = Remotes.BlackMarketDealer;
local TweenInfo_new_ret = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, (1 / 0));
local u2 = {
    [Enum.KeyCode.DPadUp] = true,
    [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true,
    [Enum.KeyCode.DPadRight] = true
};
local u3 = {
    case = true,
    package = true,
    console = true
};
local TweenInfo_new_ret2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local Color3_fromRGB_ret = Color3.fromRGB(255, 244, 200);
local TweenInfo_new_ret3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local TweenInfo_new_ret4 = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret5 = TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = nil;
local u12 = nil;
local u13 = {};
local u14 = {};
local u15 = {};
local u16 = {};
local u17 = nil;
local u18 = nil;
local u19 = {};
local Random_new_ret = Random.new();
local u20 = nil;
local u21 = false;
local u22 = nil;
local u23 = nil;
local u24 = 0;
local u25 = nil;
local u26 = nil;
local u27 = {};
local u28 = nil;
local u29 = (-1 / 0);
local u30 = true;
local u31 = false;
local u32 = false;
local u33 = false;
local u34 = {};
local u35 = {};
local u36 = {};
local u37 = {};
local u38 = false;
local u39 = false;
local u40 = 0;
local u41 = nil;
local u42 = false;

local function notify(p43: string) -- Line: 318
    -- upvalues: Router (copy)
    Router.broadcastRouter("CreateNotification", "Black Market", p43, 5);
end;

local function isPointerBlocked() -- Line: 329
    -- upvalues: u38 (ref), u39 (ref), GuiService (copy)
    return u38 or (u39 or GuiService.MenuIsOpen);
end;

local function setWaitingForDeal(p44: boolean) -- Line: 343
    -- upvalues: u6 (ref), u42 (ref), u8 (ref), u7 (ref)
    local v45 = u6;

    if not v45 or p44 == u42 then
        return;
    end;

    u42 = p44;
    v45.Visible = p44;
    local v46 = u8;

    if not v46 then
        return;
    end;

    if p44 then
        v46:Play();

        return;
    end;

    if u7 then
        v46:Cancel();
        u7.Rotation = 0;
    end;
end;

local function setNavigationVisible(p47: boolean) -- Line: 372
    -- upvalues: u5 (ref)
    local v48 = u5 and u5:FindFirstChild("Top");

    if not v48 then
        return;
    end;

    for _, v in ipairs({ "Top", "Bottom" }) do
        local v49 = v48:FindFirstChild(v);

        if v49 and v49:IsA("GuiObject") then
            v49.Visible = p47;
        end;
    end;
end;

local function escapeRichText(p50: string) -- Line: 389
    return p50:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
end;

local function getRarityColor(p51: string?) -- Line: 395
    -- upvalues: Rarities (copy)
    if p51 then
        p51 = Rarities[p51];
    end;

    return p51 and p51.Color or Rarities.Stock.Color;
end;

local function formatCountdown(p52: number) -- Line: 402
    local math_floor_ret = math.floor(p52);
    local math_max_ret = math.max(math_floor_ret, 0);

    return string.format("%02d:%02d:%02d", math_max_ret // 3600, math_max_ret % 3600 // 60, math_max_ret % 60);
end;

local function canInspectCard(p53) -- Line: 414
    -- upvalues: u3 (copy), Skins (copy)
    if u3[tostring(p53.offerKind)] or typeof(p53.float) ~= "number" then
        return false;
    end;

    return Skins.GetSkinInformation(p53.name, p53.skin) ~= nil;
end;

local function isCardPurchased(p54) -- Line: 432
    -- upvalues: u35 (copy), u22 (ref)
    if u35[tostring(p54.cardId)] then
        return true;
    end;

    local v55;

    if typeof(u22) == "table" then
        v55 = u22.buyEnabled == false;
    else
        v55 = false;
    end;

    return not v55 and p54.status ~= "available";
end;

local function toPreviewItem(p56) -- Line: 448
    -- upvalues: LocalPlayer (copy)
    return {
        Serial = 0,
        IsTradeable = true,
        NameTag = false,
        Charm = false,
        _id = p56.cardId,
        Type = p56.type,
        Name = p56.name,
        Skin = p56.skin,
        Rarity = p56.rarity,
        Float = p56.float,
        StatTrack = p56.isStattrak and 0 or false,
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

local function resolveCardImage(p57: any, p58: any, p59: boolean) -- Line: 484
    -- upvalues: Skins (copy), Cases (copy)
    if p58 then
        local v60;

        if p59 then
            v60 = Skins.GetWearImageForFloat(p58, p57.float) or nil;
        else
            v60 = nil;
        end;

        return v60 or p58.imageAssetId or "";
    end;

    local CaseByName = Cases.GetCaseByName(p57.skin);

    return CaseByName and CaseByName.imageAssetId or "";
end;

local function tintCard(p61: userdata, p62: string?) -- Line: 496
    -- upvalues: Rarities (copy)
    if p62 then
        p62 = Rarities[p62];
    end;

    local v63 = p62 and p62.Color or Rarities.Stock.Color;
    local BG = p61:FindFirstChild("BG");

    if BG and BG:IsA("ImageLabel") then
        BG.ImageColor3 = v63;
    end;

    local Pattern = p61:FindFirstChild("Pattern");

    if Pattern and Pattern:IsA("ImageLabel") then
        Pattern.ImageColor3 = v63;
    end;

    local Effects = p61:FindFirstChild("Effects");

    if Effects then
        Effects = Effects:FindFirstChild("Effect");
    end;

    if Effects and Effects:IsA("ImageLabel") then
        Effects.ImageColor3 = v63;
    end;

    local ItemTemplate = p61:FindFirstChild("ItemTemplate");

    if not ItemTemplate then
        return;
    end;

    local v64 = ItemTemplate:FindFirstChildOfClass("UIShadow");

    if v64 then
        v64.Color = v63;
    end;

    local Glow = ItemTemplate:FindFirstChild("Glow");

    if Glow and Glow:IsA("ImageLabel") then
        Glow.ImageColor3 = v63;
    end;

    local ItemContent = ItemTemplate:FindFirstChild("ItemContent");

    if ItemContent then
        ItemContent = ItemContent:FindFirstChild("Content");
    end;

    if ItemContent then
        ItemContent = ItemContent:FindFirstChild("Rarity");
    end;

    if ItemContent and ItemContent:IsA("ImageLabel") then
        ItemContent.ImageColor3 = v63;
    end;
end;

local function renderSlot(p65: table, p66: any) -- Line: 540
    -- upvalues: BlackMarketSceneController (copy), Skins (copy), u3 (copy), tintCard (copy), Cases (copy), GetSkinDisplayName (copy), CommaNumber (copy), u22 (ref), u35 (copy), u36 (copy)
    p65.Card = p66;

    if not p66 then
        BlackMarketSceneController.SetCardVisible(p65.Part, false);

        return;
    end;

    BlackMarketSceneController.SetCardVisible(p65.Part, true);
    local Back = p65.Back;
    local SkinInformation = Skins.GetSkinInformation(p66.name, p66.skin);
    local v67 = not u3[tostring(p66.offerKind)] and typeof(p66.float) == "number";
    tintCard(Back, p66.rarity);
    local ItemTemplate = Back:FindFirstChild("ItemTemplate");

    if ItemTemplate then
        ItemTemplate = ItemTemplate:FindFirstChild("ItemContent");
    end;

    local v68;

    if ItemTemplate then
        v68 = ItemTemplate:FindFirstChild("Content");
    else
        v68 = ItemTemplate;
    end;

    if v68 then
        v68 = v68:FindFirstChild("Icon");
    end;

    if v68 and v68:IsA("ImageLabel") then
        local v69;

        if SkinInformation then
            local v70;

            if v67 then
                v70 = Skins.GetWearImageForFloat(SkinInformation, p66.float) or nil;
            else
                v70 = nil;
            end;

            v69 = v70 or (SkinInformation.imageAssetId or "");
        else
            local CaseByName = Cases.GetCaseByName(p66.skin);
            v69 = CaseByName and CaseByName.imageAssetId or "";
        end;

        v68.Image = v69;
    end;

    if ItemTemplate then
        ItemTemplate = ItemTemplate:FindFirstChild("Inspect");
    end;

    if ItemTemplate and ItemTemplate:IsA("GuiObject") then
        local v71;

        if u3[tostring(p66.offerKind)] or typeof(p66.float) ~= "number" then
            v71 = false;
        else
            v71 = Skins.GetSkinInformation(p66.name, p66.skin) ~= nil;
        end;

        ItemTemplate.Visible = v71;
    end;

    local Bottom = Back:FindFirstChild("Bottom");

    if Bottom then
        local Skin = Bottom:FindFirstChild("Skin");

        if Skin and Skin:IsA("TextLabel") then
            local FullItemDisplayName = GetSkinDisplayName.GetFullItemDisplayName(p66.name, p66.skin, false, true);

            if FullItemDisplayName == "" then
                local CaseByName = Cases.GetCaseByName(p66.skin);

                if CaseByName then
                    FullItemDisplayName = CaseByName.name;
                else
                    FullItemDisplayName = `{GetSkinDisplayName.GetWeaponDisplayName(p66.name)} | {GetSkinDisplayName.GetSkinDisplayName(p66.skin, true)}`;
                end;
            end;

            Skin.RichText = true;
            local v72 = FullItemDisplayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");

            if p66.isStattrak then
                v72 = `<font color="rgb(255,132,32)">KillTrak™</font> {v72}`;
            end;

            Skin.Text = v72;
        end;

        local RAP = Bottom:FindFirstChild("RAP");

        if RAP and RAP:IsA("TextLabel") then
            local v73 = tonumber(p66.rapPrice) or 0;
            RAP.Text = `RAP: {CommaNumber((math.floor(v73)))}`;
        end;

        local FloatNumber = Bottom:FindFirstChild("FloatNumber");

        if FloatNumber and FloatNumber:IsA("TextLabel") then
            FloatNumber.Visible = true;
            FloatNumber.Text = not v67 and "" or string.format("%.13f", p66.float);
        end;

        if RAP and FloatNumber then
            RAP.LayoutOrder = v67 and 3 or 1;
            FloatNumber.LayoutOrder = v67 and 1 or 3;
        end;

        local v74;

        if typeof(u22) == "table" then
            v74 = u22.buyEnabled == false;
        else
            v74 = false;
        end;

        local v75;

        if p66.status == "available" then
            v75 = not v74;
        else
            v75 = false;
        end;

        local v76;

        if u35[tostring(p66.cardId)] then
            v76 = true;
        else
            local v77;

            if typeof(u22) == "table" then
                v77 = u22.buyEnabled == false;
            else
                v77 = false;
            end;

            v76 = not v77 and p66.status ~= "available";
        end;

        local Interact = Bottom:FindFirstChild("Interact");
        local v78;

        if Interact then
            v78 = Interact:FindFirstChild("Buy");
        else
            v78 = Interact;
        end;

        local v79;

        if v78 then
            v79 = v78:FindFirstChild("Amount");
        else
            v79 = v78;
        end;

        if v79 and v79:IsA("TextLabel") then
            local v80;

            if v76 then
                v80 = "PURCHASED";
            else
                local v81 = tonumber(p66.price) or 0;
                v80 = `BUY ({CommaNumber((math.floor(v81)))})`;
            end;

            v79.Text = v80;
        end;

        if Interact then
            Interact = Interact:FindFirstChild("Decline");
        end;

        if Interact and Interact:IsA("GuiObject") then
            Interact.Visible = false;
        end;

        local BuyWideLayout = p65.BuyWideLayout;

        if v78 and v78:IsA("GuiObject") then
            if BuyWideLayout then
                v78.Position = BuyWideLayout.Position;
                v78.Size = BuyWideLayout.Size;
            end;

            v78.Visible = v75 or v76;
        end;
    end;

    local Discount = Back:FindFirstChild("Discount");
    local v82;

    if Discount then
        v82 = Discount:FindFirstChild("Title");
    else
        v82 = Discount;
    end;

    local v83 = tonumber(p66.discount) or 0;

    if Discount and Discount:IsA("GuiObject") then
        Discount.Visible = v83 > 0;
    end;

    if v82 and v82:IsA("TextLabel") then
        v82.Text = `- {math.floor(v83 * 100 + 0.5)}%`;
    end;

    local v84 = u36[tostring(p66.cardId)];

    if v84 == nil then
        local v85;

        if u35[tostring(p66.cardId)] then
            v85 = true;
        else
            local v86;

            if typeof(u22) == "table" then
                v86 = u22.buyEnabled == false;
            else
                v86 = false;
            end;

            v85 = not v86 and p66.status ~= "available";
        end;

        v84 = v85 and true or v84;
    end;

    if v84 ~= nil then
        BlackMarketSceneController.SetCardFaceUp(p65.Part, v84, false);
    end;
end;

local function updateCountdown() -- Line: 682
    -- upvalues: u23 (ref), u25 (ref), u4 (ref), u10 (copy)
    local v87 = u23;

    if not v87 then
        return;
    end;

    local v88 = v87 - os.clock();
    local math_floor_ret = math.floor(v88);
    local math_max_ret = math.max(math_floor_ret, 0);
    local string_format_ret = string.format("%02d:%02d:%02d", math_max_ret // 3600, math_max_ret % 3600 // 60, math_max_ret % 60);

    if string_format_ret == u25 then
        return;
    end;

    u25 = string_format_ret;
    local Title = u4:FindFirstChild("Title");

    if Title and Title:IsA("TextLabel") then
        Title.Text = `<font color="rgb(255,223,0)">{string_format_ret}</font> LEFT`;
    end;

    for _, v in u10 do
        local v89 = v.Card and v.Back:FindFirstChild("Expires");

        if v89 then
            v89 = v89:FindFirstChild("TextLabel");
        end;

        if v89 and v89:IsA("TextLabel") then
            v89.Text = `<font color="rgb(167,167,167)">EXPIRES IN</font> <font color="rgb(255,255,255)">{string_format_ret}</font>`;
        end;
    end;
end;

local function setDealDeadline(p90) -- Line: 722
    -- upvalues: u23 (ref), u25 (ref)
    local v91 = typeof(p90) == "table" and tonumber(p90.msRemaining) or nil;
    local v92;

    if v91 then
        v92 = os.clock() + v91 / 1000;
    else
        v92 = nil;
    end;

    u23 = v92;
    u25 = nil;
end;

local function preloadCardArt() -- Line: 735
    -- upvalues: u10 (copy), ContentProvider (copy)
    local u93 = {};

    for _, v in u10 do
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
            table.insert(u93, ItemTemplate);
        end;
    end;

    if #u93 > 0 then
        task.spawn(function() -- Line: 748
            -- upvalues: ContentProvider (ref), u93 (copy)
            ContentProvider:PreloadAsync(u93);
        end);
    end;
end;

local function dealSignature(p94) -- Line: 761
    if typeof(p94) ~= "table" or typeof(p94.cards) ~= "table" then
        return "";
    end;

    local v95 = {};

    for i, v in p94.cards do
        local v96 = typeof(v) == "table" and (v.cardId or "") or "";
        v95[i] = tostring(v96);
    end;

    return table.concat(v95, "|");
end;

local function renderDeal(p97) -- Line: 775
    -- upvalues: u22 (ref), u10 (copy), renderSlot (copy), BlackMarketSceneController (copy), preloadCardArt (copy), u25 (ref), updateCountdown (copy)
    u22 = p97;
    local v98 = typeof(p97) == "table" and (typeof(p97.cards) == "table" and p97.cards) or {};

    for i, v in u10 do
        renderSlot(v, v98[i]);
    end;

    BlackMarketSceneController.NotifyDealRendered();
    preloadCardArt();
    u25 = nil;
    updateCountdown();
end;

local function requestDeal() -- Line: 802
    -- upvalues: u23 (ref), u29 (ref), BlackMarketDealer (copy)
    local v99 = u23;

    if v99 and v99 - os.clock() > 0 then
        return;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret - u29 < 10 then
        return;
    end;

    u29 = os_clock_ret;
    BlackMarketDealer.RequestDeal.Send();
end;

local function regionRect(p100: table) -- Line: 827
    local Element = p100.Element;
    local AbsolutePosition = Element.AbsolutePosition;
    local AbsoluteSize = Element.AbsoluteSize;
    local Scale = p100.Scale.Scale;

    if Scale <= 0 or Scale >= 1 then
        return AbsolutePosition, AbsoluteSize;
    end;

    local AnchorPoint = Element.AnchorPoint;
    local v101 = AbsoluteSize / Scale;

    return AbsolutePosition + AbsoluteSize * AnchorPoint - v101 * AnchorPoint, v101;
end;

local function regionBounds(p102: table, p103: table) -- Line: 847
    local AbsoluteSize = p102.Back.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return nil, nil;
    end;

    local Element = p103.Element;
    local AbsolutePosition = Element.AbsolutePosition;
    local AbsoluteSize2 = Element.AbsoluteSize;
    local Scale = p103.Scale.Scale;
    local v104;

    if Scale <= 0 or Scale >= 1 then
        v104 = AbsoluteSize2;
    else
        local AnchorPoint = Element.AnchorPoint;
        v104 = AbsoluteSize2 / Scale;
        AbsolutePosition = AbsolutePosition + AbsoluteSize2 * AnchorPoint - v104 * AnchorPoint;
    end;

    local v105 = AbsolutePosition - p102.Back.AbsolutePosition;

    return v105 / AbsoluteSize, (v105 + v104) / AbsoluteSize;
end;

local function isRegionVisible(p106: userdata, p107: userdata) -- Line: 861
    while p106 and p106 ~= p107 do
        if p106:IsA("GuiObject") and not p106.Visible then
            return false;
        end;

        p106 = p106.Parent;
    end;

    return true;
end;

local function projectCardRect(p108: userdata, p109, p110, p111: boolean) -- Line: 892
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return nil, nil, false;
    end;

    local Size = p108.Size;
    local CFrame = p108.CFrame;
    local v112 = (1 / 0);
    local v113 = (-1 / 0);
    local v114 = (1 / 0);
    local v115 = (-1 / 0);
    local v116 = 0;
    local v117 = 0;

    for i = 1, 4 do
        local v118;

        if i == 2 and true or i == 3 then
            v118 = p110.X;
        else
            v118 = p109.X;
        end;

        local v119;

        if i == 3 and true or i == 4 then
            v119 = p110.Y;
        else
            v119 = p109.Y;
        end;

        local v120;

        if p111 then
            v120 = 0.5 - v118;
        else
            v120 = v118 - 0.5;
        end;

        local v121 = workspace_CurrentCamera:WorldToViewportPoint(CFrame:PointToWorldSpace((Vector3.new(v120 * Size.X, (0.5 - v119) * Size.Y, 0))));

        if v121.Z <= 0 then
            return nil, nil, false;
        end;

        v114 = math.min(v114, v121.X);
        v115 = math.max(v115, v121.X);
        v112 = math.min(v112, v121.Y);
        v113 = math.max(v113, v121.Y);
        local v122;

        if i == 1 then
            v116 = v121.X;
            v122 = i;
        elseif i == 2 then
            v117 = v121.X;
            v122 = i;
        else
            v122 = i;
        end;
    end;

    return Vector2.new(v114, v112), Vector2.new(v115 - v114, v113 - v112), v116 < v117;
end;

local function setHoveredRegion(p123: table?) -- Line: 943
    -- upvalues: u28 (ref), Router (copy)
    if u28 == p123 then
        return;
    end;

    local v124 = u28;
    u28 = p123;

    if v124 then
        v124.HoverOut:Play();
    end;

    if p123 then
        p123.HoverIn:Play();
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
    end;
end;

local function clearCardHover() -- Line: 964
    -- upvalues: u10 (copy), u28 (ref)
    local function rest(p125: table) -- Line: 965
        p125.HoverIn:Cancel();
        p125.HoverOut:Cancel();
        p125.Press:Cancel();
        p125.Scale.Scale = 1;
    end;

    for _, v in u10 do
        local v126 = v;

        for _, v2 in v.Regions do
            v2.HoverIn:Cancel();
            v2.HoverOut:Cancel();
            v2.Press:Cancel();
            v2.Scale.Scale = 1;
        end;

        if v126.FlipRegion then
            local FlipRegion = v126.FlipRegion;
            FlipRegion.HoverIn:Cancel();
            FlipRegion.HoverOut:Cancel();
            FlipRegion.Press:Cancel();
            FlipRegion.Scale.Scale = 1;
        end;
    end;

    u28 = nil;
end;

local function pressRegion(u127: table) -- Line: 993
    -- upvalues: u28 (ref)
    u127.Press:Play();
    task.delay(0.15, function() -- Line: 995
        -- upvalues: u28 (ref), u127 (copy)
        if u28 == u127 then
            u127.HoverIn:Play();

            return;
        end;

        u127.HoverOut:Play();
    end);
end;

local function isCardDiscontinued(p128) -- Line: 1011
    -- upvalues: Cases (copy)
    if typeof(p128) ~= "table" then
        return false;
    end;

    local CaseByName = Cases.GetCaseByName(p128.skin);

    if CaseByName then
        return not Cases.IsCaseForSale(CaseByName.caseId);
    end;

    return false;
end;

local function flipCardUp(p129: table) -- Line: 1027
    -- upvalues: BlackMarketSceneController (copy), u37 (copy), Cases (copy)
    BlackMarketSceneController.SetCardFaceUp(p129.Part, true, true);
    local v130 = tostring(p129.Card.cardId);

    if not BlackMarketSceneController.IsCardFaceUp(p129.Part) or u37[v130] then
        return;
    end;

    u37[v130] = true;
    local Card = p129.Card;
    local v131;

    if typeof(Card) == "table" then
        local CaseByName = Cases.GetCaseByName(Card.skin);

        if CaseByName then
            v131 = not Cases.IsCaseForSale(CaseByName.caseId);
        else
            v131 = false;
        end;
    else
        v131 = false;
    end;

    if v131 then
        BlackMarketSceneController.PlayDiscontinuedLine();

        return;
    end;

    BlackMarketSceneController.PlayRarityLine(p129.Card.rarity);
end;

local function promptRefresh() -- Line: 1052
    -- upvalues: u38 (ref), u39 (ref), DevProducts (copy), Router (copy), u22 (ref), u28 (ref), MarketplaceService (copy), LocalPlayer (copy)
    if u38 or u39 then
        return;
    end;

    local v132 = DevProducts["Black Market Refresh"];

    if not (v132 and (v132.DevProductId and v132.DevProductId > 0)) then
        Router.broadcastRouter("CreateNotification", "Black Market", "Refreshing the deal is not available yet.", 5);

        return;
    end;

    if u22 and u22.refreshEnabled == false then
        Router.broadcastRouter("CreateNotification", "Black Market", "The dealer is not taking refreshes right now.", 5);

        return;
    end;

    u38 = true;

    if u28 ~= nil then
        local v133 = u28;
        u28 = nil;

        if v133 then
            v133.HoverOut:Play();
        end;
    end;

    MarketplaceService:PromptProductPurchase(LocalPlayer, v132.DevProductId);
    Router.broadcastRouter("RunInterfaceSound", "UI Click");
end;

local function ensureTargetLayer() -- Line: 1089
    -- upvalues: u12 (ref), LocalPlayer (copy), u4 (ref), GamepadNavigation (copy), u11 (ref)
    if u12 then
        return u12;
    end;

    local v134 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v134 then
        return nil;
    end;

    local v135 = u4:FindFirstAncestorWhichIsA("ScreenGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "BlackmarketCardTargets";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = (not v135 and 0 or v135.DisplayOrder) - 1;
    ScreenGui.Enabled = false;
    ScreenGui:SetAttribute(GamepadNavigation.NO_FALLBACK_ATTRIBUTE, true);
    ScreenGui.Parent = v134;
    local Frame = Instance.new("Frame");
    Frame.Name = "Targets";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Parent = ScreenGui;
    u11 = ScreenGui;
    u12 = Frame;

    return Frame;
end;

local function isCanvasMirrored(p136: userdata) -- Line: 1133
    local v137 = p136:FindFirstAncestorOfClass("SurfaceGui");
    local v138;

    if v137 == nil then
        v138 = false;
    else
        v138 = v137.Face == Enum.NormalId.Front;
    end;

    return v138;
end;

local function getPressPoint(p139: userdata, p140: userdata?) -- Line: 1147
    -- upvalues: GuiService (copy), UserInputService (copy)
    if p140 and (p140.UserInputType == Enum.UserInputType.MouseButton1 or p140.UserInputType == Enum.UserInputType.Touch) then
        return Vector2.new(p140.Position.X, p140.Position.Y) + GuiService:GetGuiInset();
    end;

    if p140 or not UserInputService.MouseEnabled then
        return p139.AbsolutePosition + p139.AbsoluteSize / 2;
    end;

    return UserInputService:GetMouseLocation();
end;

local function createCircle(p141: userdata, p142: string) -- Line: 1162
    local Frame = Instance.new("Frame");
    Frame.Name = p142;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.BorderSizePixel = 0;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;
    Frame.Parent = p141;

    return Frame;
end;

local function createFlipBurst(p143: userdata) -- Line: 1187
    -- upvalues: createCircle (copy), TweenService (copy), TweenInfo_new_ret3 (copy), TweenInfo_new_ret4 (copy), Random_new_ret (copy), TweenInfo_new_ret5 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "FlipBurst";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = 5;
    Frame.Visible = false;
    local v144 = createCircle(Frame, "Flash");
    v144.BackgroundColor3 = Color3.new(1, 1, 1);
    local v145 = createCircle(Frame, "Ring");
    v145.BackgroundTransparency = 1;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Parent = v145;
    local v146 = { TweenService:Create(v144, TweenInfo_new_ret3, {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0.4, 0.4)
        }), TweenService:Create(v145, TweenInfo_new_ret4, {
            Size = UDim2.fromScale(1, 1)
        }) };
    local v147 = TweenService:Create(UIStroke, TweenInfo_new_ret4, {
        Thickness = 0,
        Transparency = 1
    });
    table.insert(v146, v147);
    local NumberSequence_new_ret = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.6, 0.15), NumberSequenceKeypoint.new(1, 0) });
    local v148 = {};

    for i = 1, 10 do
        local v149 = i / 10 * 3.141592653589793 * 2 + Random_new_ret:NextNumber(-0.25, 0.25);
        local Vector2_new_ret = Vector2.new(math.cos(v149), (math.sin(v149)));
        local v150 = Random_new_ret:NextNumber(0.9, 1.5) / 2;
        local v151 = Random_new_ret:NextNumber(0.35, 0.6) / 2;
        local Frame2 = Instance.new("Frame");
        Frame2.Name = "Streak";
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame2.BorderSizePixel = 0;
        Frame2.Rotation = math.deg(v149);
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(1, 0);
        UICorner.Parent = Frame2;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Transparency = NumberSequence_new_ret;
        UIGradient.Parent = Frame2;
        Frame2.Parent = Frame;
        local v152 = Vector2_new_ret * 0.1;
        local v153 = Vector2_new_ret * v150;
        local v154 = {
            Frame = Frame2,
            Start = UDim2.fromScale(0.5 + v152.X, 0.5 + v152.Y),
            StartSize = UDim2.fromScale(v151, 0.03)
        };
        table.insert(v148, v154);
        local v155 = {
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5 + v153.X, 0.5 + v153.Y),
            Size = UDim2.fromScale(v151 * 0.15, 0.015)
        };
        table.insert(v146, TweenService:Create(Frame2, TweenInfo_new_ret5, v155));
        local _ = i;
    end;

    local v156 = TweenService:Create(UIStroke, TweenInfo_new_ret4, {
        Transparency = 1
    });
    local u157 = {
        IsBusy = false,
        Holder = Frame,
        Flash = v144,
        Ring = v145,
        RingStroke = UIStroke,
        Streaks = v148,
        Tweens = v146,
        FadeTween = v156
    };

    local function release() -- Line: 1273
        -- upvalues: Frame (copy), u157 (copy)
        Frame.Visible = false;
        u157.IsBusy = false;
    end;

    v147.Completed:Connect(release);
    v156.Completed:Connect(release);
    Frame.Parent = p143;

    return u157;
end;

local function acquireFlipBurst(p158: userdata) -- Line: 1287
    -- upvalues: u19 (copy), createFlipBurst (copy)
    for _, v in u19 do
        if not v.IsBusy then
            return v;
        end;
    end;

    local v159 = createFlipBurst(p158);
    table.insert(u19, v159);

    return v159;
end;

local function playFlipBurst(p160, p161: number, p162, p163: boolean) -- Line: 1307
    -- upvalues: u12 (ref), u19 (copy), createFlipBurst (copy), Random_new_ret (copy)
    local v164 = u12;

    if not v164 then
        return;
    end;

    local v165;

    for _, v in u19 do
        if not v.IsBusy then
            v165 = v;
            break;
        end;
    end;

    v165 = createFlipBurst(v164);
    table.insert(u19, v165);
    v165.IsBusy = true;
    local Holder = v165.Holder;
    Holder.Position = UDim2.fromOffset(p160.X, p160.Y);
    Holder.Size = UDim2.fromOffset(p161 * 2, p161 * 2);
    Holder.Rotation = p163 and 0 or Random_new_ret:NextNumber(0, 360);
    local RingStroke = v165.RingStroke;
    RingStroke.Transparency = 0;
    v165.Flash.Visible = not p163;

    for _, v in v165.Streaks do
        v.Frame.Visible = not p163;
    end;

    if p163 then
        v165.Ring.Size = UDim2.fromScale(0.6, 0.6);
        RingStroke.Color = p162;
        RingStroke.Thickness = 2;
        Holder.Visible = true;
        v165.FadeTween:Play();

        return;
    end;

    v165.Flash.Size = UDim2.fromScale(0.125, 0.125);
    v165.Flash.BackgroundTransparency = 0.05;
    v165.Ring.Size = UDim2.fromScale(0.15, 0.15);
    RingStroke.Color = p162:Lerp(Color3.new(1, 1, 1), 0.25);
    RingStroke.Thickness = math.max(p161 * 0.09, 2);

    for i, v in v165.Streaks do
        v.Frame.Position = v.Start;
        v.Frame.Size = v.StartSize;
        v.Frame.BackgroundTransparency = 0;
        local Frame = v.Frame;
        local v166;

        if i % 2 == 0 then
            v166 = Color3.new(1, 1, 1);
        else
            v166 = p162;
        end;

        Frame.BackgroundColor3 = v166;
    end;

    Holder.Visible = true;

    for _, v in v165.Tweens do
        v:Play();
    end;
end;

local function getCardPointUnder(p167: userdata, p168) -- Line: 1360
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return p167.Position;
    end;

    local v169 = workspace_CurrentCamera:ViewportPointToRay(p168.X, p168.Y);
    local LookVector = p167.CFrame.LookVector;
    local v170 = v169.Direction:Dot(LookVector);

    if math.abs(v170) < 0.001 then
        return p167.Position;
    end;

    local v171 = (p167.Position - v169.Origin):Dot(LookVector) / v170;

    return v169.Origin + v169.Direction * v171;
end;

local function playFlipEffect(p172: table, p173: userdata, p174: userdata?) -- Line: 1384
    -- upvalues: Rarities (copy), getPressPoint (copy), GuiService (copy), playFlipBurst (copy), getCardPointUnder (copy)
    local v175 = p172.Card and p172.Card.rarity;

    if v175 then
        v175 = Rarities[v175];
    end;

    local v176 = v175 and v175.Color or Rarities.Stock.Color;
    local v177 = getPressPoint(p173, p174);
    local math_clamp_ret = math.clamp(p173.AbsoluteSize.Y * 0.28, 36, 110);
    local ReducedMotionEnabled = GuiService.ReducedMotionEnabled;
    playFlipBurst(v177, math_clamp_ret, v176, ReducedMotionEnabled);

    if ReducedMotionEnabled then
        return;
    end;

    local Sparkles = p172.Sparkles;
    local v178;

    if Sparkles then
        v178 = Sparkles.Parent;
    else
        v178 = Sparkles;
    end;

    if not (Sparkles and (v178 and (v178:IsA("Attachment") and v178.Parent))) then
        local v179 = p172.Part.Size.Y * 0.075;
        v178 = Instance.new("Attachment");
        v178.Name = "FlipSparkleOrigin";
        v178.Parent = p172.Part;
        Sparkles = Instance.new("ParticleEmitter");
        Sparkles.Name = "FlipSparkles";
        Sparkles.Texture = "rbxasset://textures/particles/sparkles_main.dds";
        Sparkles.Rate = 0;
        Sparkles.Lifetime = NumberRange.new(0.35, 0.7);
        Sparkles.Speed = NumberRange.new(p172.Part.Size.Y * 1.2, p172.Part.Size.Y * 2.4);
        Sparkles.SpreadAngle = Vector2.new(180, 180);
        Sparkles.Drag = 6;
        Sparkles.Rotation = NumberRange.new(0, 360);
        Sparkles.RotSpeed = NumberRange.new(-240, 240);
        Sparkles.LightEmission = 1;
        Sparkles.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, v179), NumberSequenceKeypoint.new(0.25, v179 * 1.2), NumberSequenceKeypoint.new(1, 0) });
        Sparkles.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0.2), NumberSequenceKeypoint.new(1, 1) });
        Sparkles.Parent = v178;
        p172.Sparkles = Sparkles;
    end;

    if v178 and v178:IsA("Attachment") then
        v178.WorldPosition = getCardPointUnder(p172.Part, v177);
    end;

    Sparkles.Color = ColorSequence.new(Color3.new(1, 1, 1), v176);
    Sparkles:Emit(14);
end;

local function createTarget(u180: table, u181: table, u182: boolean, p183: string) -- Line: 1454
    -- upvalues: ensureTargetLayer (copy), BlackMarketSceneController (copy), u28 (ref), Router (copy), u38 (ref), u39 (ref), GuiService (copy), playFlipEffect (copy), u13 (copy)
    local v184 = ensureTargetLayer();

    if not v184 then
        return;
    end;

    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = p183;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.ImageTransparency = 1;
    ImageButton.AutoButtonColor = false;
    ImageButton.AnchorPoint = Vector2.zero;
    ImageButton.ZIndex = u182 and 0 or 1;
    ImageButton.Visible = false;
    ImageButton.Parent = v184;

    local function hover() -- Line: 1474
        -- upvalues: u182 (copy), BlackMarketSceneController (ref), u180 (copy), u181 (copy), u28 (ref), Router (ref)
        if u182 and BlackMarketSceneController.IsCardFaceUp(u180.Part) then
            return;
        end;

        local v185 = u181;

        if u28 == v185 then
            return;
        end;

        local v186 = u28;
        u28 = v185;

        if v186 then
            v186.HoverOut:Play();
        end;

        if v185 then
            v185.HoverIn:Play();
            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        end;
    end;

    ImageButton.MouseEnter:Connect(hover);
    ImageButton.SelectionGained:Connect(hover);

    local function v188() -- Line: 1483
        -- upvalues: u28 (ref), u181 (copy)
        if u28 == u181 then
            if u28 == nil then
                return;
            end;

            local v187 = u28;
            u28 = nil;

            if v187 then
                v187.HoverOut:Play();
            end;
        end;
    end;

    ImageButton.MouseLeave:Connect(v188);
    ImageButton.SelectionLost:Connect(v188);
    ImageButton.Activated:Connect(function(p189: userdata?) -- Line: 1492
        -- upvalues: u38 (ref), u39 (ref), GuiService (ref), Router (ref), u181 (copy), u28 (ref), u182 (copy), playFlipEffect (ref), u180 (copy), ImageButton (copy)
        if u38 or (u39 or GuiService.MenuIsOpen) then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local u190 = u181;
        u190.Press:Play();
        task.delay(0.15, function() -- Line: 995
            -- upvalues: u28 (ref), u190 (copy)
            if u28 == u190 then
                u190.HoverIn:Play();

                return;
            end;

            u190.HoverOut:Play();
        end);

        if u182 then
            playFlipEffect(u180, ImageButton, p189);
        end;

        u181.Activate();
    end);
    local v191 = {
        Button = ImageButton,
        Slot = u180,
        Region = u181,
        IsFlip = u182
    };
    local v192;

    if u182 then
        v192 = u180.Front;
    else
        v192 = u180.Back;
    end;

    local v193 = v192:FindFirstAncestorOfClass("SurfaceGui");
    local v194;

    if v193 == nil then
        v194 = false;
    else
        v194 = v193.Face == Enum.NormalId.Front;
    end;

    v191.IsMirrored = v194;
    table.insert(u13, v191);
end;

local function targetRect(p195: table) -- Line: 1525
    -- upvalues: BlackMarketSceneController (copy), projectCardRect (copy), isRegionVisible (copy)
    local Slot = p195.Slot;

    if Slot.Card == nil or not BlackMarketSceneController.IsCardShown(Slot.Part) then
        return nil, nil;
    end;

    if p195.IsFlip then
        local v196, v197 = projectCardRect(Slot.Part, Vector2.zero, Vector2.one, false);

        if not (v196 and (v197 and v197.Y > 0)) then
            return nil, nil;
        end;

        if v197.X < 12 then
            v196 = Vector2.new(v196.X + (v197.X - 12) / 2, v196.Y);
            v197 = Vector2.new(12, v197.Y);
        end;

        return v196, v197;
    end;

    if not (BlackMarketSceneController.IsCardFaceUp(Slot.Part) and isRegionVisible(p195.Region.Element, Slot.Back)) then
        return nil, nil;
    end;

    local Region = p195.Region;
    local AbsoluteSize = Slot.Back.AbsoluteSize;
    local v198, v199;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        v198 = nil;
        v199 = nil;
    else
        local Element = Region.Element;
        local AbsolutePosition = Element.AbsolutePosition;
        local AbsoluteSize2 = Element.AbsoluteSize;
        local Scale = Region.Scale.Scale;
        local v200;

        if Scale <= 0 or Scale >= 1 then
            v200 = AbsoluteSize2;
        else
            local AnchorPoint = Element.AnchorPoint;
            v200 = AbsoluteSize2 / Scale;
            AbsolutePosition = AbsolutePosition + AbsoluteSize2 * AnchorPoint - v200 * AnchorPoint;
        end;

        local v201 = AbsolutePosition - Slot.Back.AbsolutePosition;
        v198 = v201 / AbsoluteSize;
        v199 = (v201 + v200) / AbsoluteSize;
    end;

    if not (v198 and v199) then
        return nil, nil;
    end;

    local v202, v203, v204 = projectCardRect(Slot.Part, v198, v199, p195.IsMirrored);

    if v202 and (v203 and (v204 and (v203.X >= 12 and v203.Y > 0))) then
        return v202, v203;
    end;

    return nil, nil;
end;

local function refreshCardTargets() -- Line: 1591
    -- upvalues: u38 (ref), u39 (ref), GuiService (copy), BlackMarketSceneController (copy), u14 (copy), u15 (copy), u16 (copy), u13 (copy), targetRect (copy), u20 (ref), u28 (ref), u9 (ref), GamepadNavigation (copy), u21 (ref)
    local v205 = u38 or (u39 or GuiService.MenuIsOpen) or BlackMarketSceneController.IsPresenting();
    table.clear(u14);
    table.clear(u15);
    table.clear(u16);
    local v206 = nil;
    local v207 = nil;
    local v208 = false;

    for _, v in u13 do
        local Slot = v.Slot;
        local Button = v.Button;
        local v209, v210;

        if v205 then
            v209 = nil;
            v210 = nil;
        else
            v209, v210 = targetRect(v);
        end;

        if v209 and v210 then
            Button.Position = UDim2.fromOffset(v209.X, v209.Y);
            Button.Size = UDim2.fromOffset(v210.X, v210.Y);
            Button.Visible = true;
            v206 = v206 or Button;

            if Slot == u20 then
                v207 = v207 or Button;
            end;

            if v.IsFlip then
                u14[Slot] = Button;
            elseif v209.Y < (u16[Slot] or (1 / 0)) then
                u16[Slot] = v209.Y;
                u15[Slot] = Button;
            end;
        else
            Button.Visible = false;

            if u28 == v.Region then
                v208 = true;
            end;
        end;
    end;

    for i, v in u14 do
        v.NextSelectionDown = u15[i];
    end;

    for _, v in u13 do
        local Button = v.Button;

        if not v.IsFlip and Button.Visible then
            local Slot = v.Slot;
            local v211;

            if u15[Slot] == Button then
                v211 = u14[Slot];
            else
                v211 = nil;
            end;

            if Button.NextSelectionUp ~= v211 then
                Button.NextSelectionUp = v211;
            end;
        end;
    end;

    local v212 = nil;
    local v213 = u9;
    local v214;

    if v213 == nil then
        v214 = false;
    else
        v214 = GamepadNavigation.IsUsable(v213);
    end;

    if v213 and v214 then
        local v215 = v213.AbsolutePosition.X + v213.AbsoluteSize.X / 2;
        local v216 = (1 / 0);

        for _, v in u14 do
            local math_abs_ret = math.abs(v.AbsolutePosition.X + v.AbsoluteSize.X / 2 - v215);

            if math_abs_ret < v216 then
                v212 = v;
                v216 = math_abs_ret;
            end;
        end;
    end;

    for _, v in u14 do
        local v217;

        if v214 then
            v217 = v213;
        else
            v217 = nil;
        end;

        v.NextSelectionUp = v217;
    end;

    if v213 then
        v213.NextSelectionDown = v212;
    end;

    if v208 and u28 ~= nil then
        local v218 = u28;
        u28 = nil;

        if v218 then
            v218.HoverOut:Play();
        end;
    end;

    if v205 then
        return;
    end;

    if u21 and v206 then
        u21 = false;
        GuiService.SelectedObject = v206;

        return;
    end;

    local SelectedObject = GuiService.SelectedObject;

    if not SelectedObject then
        if u20 then
            GuiService.SelectedObject = v207 or v206;

            if not (v207 or v206) then
                u20 = nil;
            end;
        end;

        return;
    end;

    u20 = nil;

    for _, v in u13 do
        if v.Button == SelectedObject then
            u20 = v.Slot;

            return;
        end;
    end;
end;

local function createGlint(p219: userdata) -- Line: 1742
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
        local v220;

        if v then
            v220 = UDim2.fromScale(0.14, 1);
        else
            v220 = UDim2.fromScale(1, 0.14);
        end;

        Frame2.Size = v220;
        Frame2.BackgroundColor3 = Color3_fromRGB_ret;
        Frame2.BorderSizePixel = 0;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Rotation = v and 90 or 0;
        UIGradient.Transparency = NumberSequence_new_ret;
        UIGradient.Parent = Frame2;
        Frame2.Parent = Frame;
    end;

    Frame.Parent = p219;

    return Frame;
end;

local function scheduleGlint(p221: table, p222: table, p223: number) -- Line: 1783
    -- upvalues: Random_new_ret (copy)
    local Vector2_zero = Vector2.zero;
    local v224 = -1;

    for i = 1, 12 do
        local Vector2_new_ret = Vector2.new(Random_new_ret:NextNumber(0.12, 0.88), Random_new_ret:NextNumber(0.15, 0.85));
        local _ = i;
        local v225 = (1 / 0);

        for _, v in p221.Glints do
            if v ~= p222 and v.Lifetime > 0 then
                v225 = math.min(v225, (v.Spot - Vector2_new_ret).Magnitude);
            end;
        end;

        if v224 < v225 then
            v224 = v225;
        else
            Vector2_new_ret = Vector2_zero;
        end;

        if v225 >= 0.22 then
            Vector2_zero = Vector2_new_ret;
            break;
        end;

        Vector2_zero = Vector2_new_ret;
    end;

    p222.StartsAt = p223;
    p222.Lifetime = Random_new_ret:NextNumber(1.4, 2.6);
    p222.Size = Random_new_ret:NextNumber(0.09, 0.17);
    p222.Spot = Vector2_zero;
    p222.Frame.Position = UDim2.fromScale(Vector2_zero.X, Vector2_zero.Y);
end;

local function scatterCardGlints() -- Line: 1814
    -- upvalues: u10 (copy), scheduleGlint (copy), Random_new_ret (copy)
    local os_clock_ret = os.clock();

    for _, v in u10 do
        local v226 = v;

        for _, v2 in v.Glints do
            scheduleGlint(v226, v2, os_clock_ret + Random_new_ret:NextNumber(0, 4.2));
        end;
    end;
end;

local function updateCardGlints() -- Line: 1830
    -- upvalues: GuiService (copy), u10 (copy), BlackMarketSceneController (copy), scheduleGlint (copy), Random_new_ret (copy)
    local os_clock_ret = os.clock();
    local ReducedMotionEnabled = GuiService.ReducedMotionEnabled;

    for _, v in u10 do
        local v227 = not ReducedMotionEnabled;

        if v227 then
            if v.Card == nil then
                v227 = false;
            else
                v227 = BlackMarketSceneController.IsCardFaceUp(v.Part);
            end;
        end;

        local v228 = v;

        for _, v2 in v.Glints do
            if v227 then
                if v2.StartsAt + v2.Lifetime < os_clock_ret then
                    scheduleGlint(v228, v2, os_clock_ret + Random_new_ret:NextNumber(0.2, 1.6));
                end;

                local v229 = (os_clock_ret - v2.StartsAt) / v2.Lifetime;
                local v230;

                if v229 >= 0 then
                    v230 = v229 <= 1;
                else
                    v230 = false;
                end;

                v2.Frame.Visible = v230;

                if v230 then
                    local math_sin_ret = math.sin(v229 * 3.141592653589793);
                    v2.Frame.Size = UDim2.fromScale(v2.Size * math_sin_ret, v2.Size * math_sin_ret);
                    v2.Frame.Rotation = v229 * 45;
                end;
            else
                v2.Frame.Visible = false;
            end;
        end;
    end;
end;

local function shouldSelectOnOpen() -- Line: 1865
    -- upvalues: UserInputService (copy)
    return UserInputService.GamepadEnabled and not UserInputService.MouseEnabled and true or UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1;
end;

local function startCardInput() -- Line: 1883
    -- upvalues: ensureTargetLayer (copy), u11 (ref), BlackMarketSceneController (copy), u21 (ref), Router (copy), UserInputService (copy), u38 (ref), u39 (ref), GuiService (copy), u2 (copy), u27 (copy), u17 (ref), RunServiceController (copy), refreshCardTargets (copy), scatterCardGlints (copy), u18 (ref), updateCardGlints (copy)
    ensureTargetLayer();

    if u11 then
        u11.Enabled = true;
    end;

    local function skipForPad() -- Line: 1898
        -- upvalues: BlackMarketSceneController (ref), u21 (ref), Router (ref)
        BlackMarketSceneController.SkipPresentation();
        u21 = true;
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end;

    local os_clock_ret = os.clock();
    local u231 = false;
    local v233 = UserInputService.InputBegan:Connect(function(p232: userdata) -- Line: 1909
        -- upvalues: BlackMarketSceneController (ref), u38 (ref), u39 (ref), GuiService (ref), os_clock_ret (copy), u2 (ref), u21 (ref), Router (ref)
        if not (BlackMarketSceneController.IsPresenting() and (not (u38 or (u39 or GuiService.MenuIsOpen)) and os.clock() - os_clock_ret >= 0.3)) then
            return;
        end;

        local UserInputType = p232.UserInputType;
        local KeyCode = p232.KeyCode;

        if not u2[KeyCode] then
            if UserInputType == Enum.UserInputType.MouseButton1 or (UserInputType == Enum.UserInputType.Touch or (KeyCode == Enum.KeyCode.ButtonA or (KeyCode == Enum.KeyCode.Return or KeyCode == Enum.KeyCode.Space))) then
                BlackMarketSceneController.SkipPresentation();
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
            end;

            return;
        end;

        BlackMarketSceneController.SkipPresentation();
        u21 = true;
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    table.insert(u27, v233);
    local v235 = UserInputService.InputChanged:Connect(function(p234: userdata) -- Line: 1935
        -- upvalues: u231 (ref), os_clock_ret (copy), BlackMarketSceneController (ref), u38 (ref), u39 (ref), GuiService (ref), u21 (ref), Router (ref)
        if p234.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return;
        end;

        local Magnitude = Vector2.new(p234.Position.X, p234.Position.Y).Magnitude;

        if Magnitude < 0.2 then
            u231 = true;

            return;
        end;

        if not (u231 and (Magnitude >= 0.5 and (os.clock() - os_clock_ret >= 0.3 and BlackMarketSceneController.IsPresenting()))) or (u38 or (u39 or GuiService.MenuIsOpen)) then
            return;
        end;

        BlackMarketSceneController.SkipPresentation();
        u21 = true;
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    table.insert(u27, v235);
    u21 = UserInputService.GamepadEnabled and not UserInputService.MouseEnabled and true or UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1;
    u17 = RunServiceController.BindToHeartbeat("UI.Blackmarket.CardTargets", refreshCardTargets);
    refreshCardTargets();
    scatterCardGlints();
    u18 = RunServiceController.BindToRenderStep("UI.Blackmarket.CardGlints", updateCardGlints);
end;

local function bindSlot(u236: table) -- Line: 1988
    -- upvalues: TweenService (copy), TweenInfo_new_ret2 (copy), createTarget (copy), BlackMarketSceneController (copy), flipCardUp (copy), u36 (copy), createGlint (copy), u33 (ref), InspectController (copy), toPreviewItem (copy), ReplicatedStorage (copy), u3 (copy), u35 (copy), u22 (ref), Router (copy), BlackMarketDealer (copy)
    local u237 = {};

    local function addRegion(p238: userdata?, p239: function) -- Line: 1991
        -- upvalues: TweenService (ref), TweenInfo_new_ret2 (ref), u237 (copy), createTarget (ref), u236 (copy)
        if not (p238 and p238:IsA("GuiObject")) then
            return;
        end;

        local v240 = p238:FindFirstChildOfClass("UIScale") or Instance.new("UIScale");
        v240.Parent = p238;
        local v241 = {
            Element = p238,
            Activate = p239,
            Scale = v240,
            HoverIn = TweenService:Create(v240, TweenInfo_new_ret2, {
                Scale = 0.95
            }),
            HoverOut = TweenService:Create(v240, TweenInfo_new_ret2, {
                Scale = 1
            }),
            Press = TweenService:Create(v240, TweenInfo_new_ret2, {
                Scale = 0.9
            })
        };
        table.insert(u237, v241);
        createTarget(u236, v241, false, p238.Name);
    end;

    if u236.Front.AnchorPoint == Vector2.zero and (u236.Front.Position == UDim2.fromScale(0, 0) and u236.Front.Size == UDim2.fromScale(1, 1)) then
        u236.Front.AnchorPoint = Vector2.new(0.5, 0.5);
        u236.Front.Position = UDim2.fromScale(0.5, 0.5);
    end;

    local v242 = u236.Front:FindFirstChildOfClass("UIScale") or Instance.new("UIScale");
    v242.Parent = u236.Front;
    local v243 = {
        Element = u236.Front,

        Activate = function() -- Line: 2033, Name: Activate
            -- upvalues: BlackMarketSceneController (ref), u236 (copy), flipCardUp (ref), u36 (ref)
            if BlackMarketSceneController.IsCardFaceUp(u236.Part) then
                BlackMarketSceneController.SetCardFaceUp(u236.Part, false, true);
            else
                flipCardUp(u236);
            end;

            if u236.Card then
                u36[tostring(u236.Card.cardId)] = BlackMarketSceneController.IsCardFaceUp(u236.Part);
            end;
        end,

        Scale = v242,
        HoverIn = TweenService:Create(v242, TweenInfo_new_ret2, {
            Scale = 0.95
        }),
        HoverOut = TweenService:Create(v242, TweenInfo_new_ret2, {
            Scale = 1
        }),
        Press = TweenService:Create(v242, TweenInfo_new_ret2, {
            Scale = 0.9
        })
    };
    u236.FlipRegion = v243;
    createTarget(u236, v243, true, "Flip");
    local ItemTemplate = u236.Back:FindFirstChild("ItemTemplate");

    if ItemTemplate then
        ItemTemplate = ItemTemplate:FindFirstChild("ItemContent");
    end;

    local u244;

    if ItemTemplate then
        u244 = ItemTemplate:FindFirstChild("Content");
    else
        u244 = ItemTemplate;
    end;

    if u244 then
        u244 = u244:FindFirstChild("Icon");
    end;

    local Parent = u236.Back.Parent;

    if u244 and (u244:IsA("GuiObject") and (Parent and Parent:IsA("SurfaceGui"))) then
        local Frame = Instance.new("Frame");
        Frame.Name = "Glints";
        Frame.BackgroundTransparency = 1;
        Frame.Active = false;
        Frame.ZIndex = u236.Back.ZIndex + 1;
        Frame.Parent = Parent;

        local function fitGlintLayer() -- Line: 2077
            -- upvalues: u244 (copy), Parent (copy), Frame (copy)
            local v245 = u244.AbsolutePosition - Parent.AbsolutePosition;
            Frame.Position = UDim2.fromOffset(v245.X, v245.Y);
            Frame.Size = UDim2.fromOffset(u244.AbsoluteSize.X, u244.AbsoluteSize.Y);
        end;

        u244:GetPropertyChangedSignal("AbsolutePosition"):Connect(fitGlintLayer);
        u244:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitGlintLayer);
        local v246 = u244.AbsolutePosition - Parent.AbsolutePosition;
        Frame.Position = UDim2.fromOffset(v246.X, v246.Y);
        Frame.Size = UDim2.fromOffset(u244.AbsoluteSize.X, u244.AbsoluteSize.Y);

        for i = 1, 6 do
            local Glints = u236.Glints;
            local v247 = {
                StartsAt = (-1 / 0),
                Lifetime = 0,
                Size = 0,
                Frame = createGlint(Frame),
                Spot = Vector2.zero
            };
            table.insert(Glints, v247);
            local _ = i;
        end;
    end;

    if ItemTemplate then
        ItemTemplate = ItemTemplate:FindFirstChild("Inspect");
    end;

    addRegion(ItemTemplate, function() -- Line: 2098
        -- upvalues: u236 (copy), u33 (ref), InspectController (ref), toPreviewItem (ref)
        local Card = u236.Card;

        if Card then
            u33 = true;
            InspectController.ShowInspect((toPreviewItem(Card)));
        end;
    end);
    local Bottom = u236.Back:FindFirstChild("Bottom");

    if Bottom then
        Bottom = Bottom:FindFirstChild("Interact");
    end;

    if Bottom then
        local Buy = Bottom:FindFirstChild("Buy");
        local View = Bottom:FindFirstChild("View");
        local v248;

        if View then
            v248 = View:FindFirstChild("Title");
        else
            v248 = View;
        end;

        if v248 and v248:IsA("TextLabel") then
            v248.Text = "VIEW ON MARKETPLACE";
        end;

        if Buy and (Buy:IsA("GuiObject") and (View and View:IsA("GuiObject"))) then
            u236.BuyWideLayout = {
                Position = UDim2.new(View.Position.X.Scale, View.Position.X.Offset, Buy.Position.Y.Scale, Buy.Position.Y.Offset),
                Size = UDim2.new(View.Size.X.Scale, View.Size.X.Offset, Buy.Size.Y.Scale, Buy.Size.Y.Offset)
            };
        end;

        addRegion(Bottom:FindFirstChild("View"), function() -- Line: 2136
            -- upvalues: u236 (copy), ReplicatedStorage (ref), u33 (ref), u3 (ref)
            local Card = u236.Card;

            if not Card then
                return;
            end;

            local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
            local GlobalMarketPlace = require(ReplicatedStorage.Interface.Screens.Menu.GlobalMarketPlace);
            u33 = true;
            GlobalMarketPlace.SetReturnScreen("Blackmarket");
            local v249 = not u3[tostring(Card.offerKind)] and typeof(Card.float) == "number";
            local SearchForItem = GlobalMarketPlace.SearchForItem;
            local name = Card.name;
            local skin = Card.skin;
            local v250 = {};
            local v251;

            if v249 then
                v251 = Card.float;
            else
                v251 = nil;
            end;

            v250.Float = v251;
            v250.StatTrak = Card.isStattrak == true;
            SearchForItem(name, skin, v250);
            Top.openFrame("GlobalMarketPlace");
        end);
        addRegion(Bottom:FindFirstChild("Buy"), function() -- Line: 2160
            -- upvalues: u236 (copy), u35 (ref), u22 (ref), Router (ref), BlackMarketDealer (ref)
            local Card = u236.Card;

            if not (Card and (Card.status == "available" and not u35[tostring(Card.cardId)])) then
                return;
            end;

            if u22 and u22.buyEnabled == false then
                Router.broadcastRouter("CreateNotification", "Black Market", "The dealer is not taking Trade Tokens right now.", 5);

                return;
            end;

            BlackMarketDealer.BuyCard.Send(Card.cardId);
        end);
    end;

    u236.Regions = u237;
end;

local function ensureSlots() -- Line: 2183
    -- upvalues: u31 (ref), BlackMarketSceneController (copy), u10 (copy), bindSlot (copy)
    if u31 then
        return;
    end;

    local Cards = BlackMarketSceneController.GetCards();

    if #Cards == 0 then
        return;
    end;

    for i, v in Cards do
        local CardFaces, v252 = BlackMarketSceneController.GetCardFaces(v);

        if CardFaces and (CardFaces:IsA("GuiObject") and (v252 and v252:IsA("GuiObject"))) then
            local v253 = {
                Card = nil,
                Part = v,
                Back = CardFaces,
                Front = v252,
                Regions = {},
                Glints = {}
            };
            u10[i] = v253;
            bindSlot(v253);
        end;
    end;

    u31 = #u10 > 0;
end;

local function beginPaidRoll() -- Line: 2218
    -- upvalues: u39 (ref), u32 (ref), u6 (ref), u42 (ref), u8 (ref), u40 (ref), u7 (ref)
    u39 = true;

    if u32 then
        local v254 = u6;

        if v254 and u42 ~= true then
            u42 = true;
            v254.Visible = true;
            local v255 = u8;

            if v255 then
                v255:Play();
            end;
        end;
    end;

    u40 = u40 + 1;
    local u256 = u40;
    task.delay(60, function() -- Line: 2230
        -- upvalues: u256 (copy), u40 (ref), u39 (ref), u6 (ref), u42 (ref), u8 (ref), u7 (ref)
        if u256 ~= u40 then
            return;
        end;

        u39 = false;
        local v257 = u6;

        if v257 then
            if u42 == false then
                return;
            end;

            u42 = false;
            v257.Visible = false;
            local v258 = u8;

            if not v258 then
                return;
            end;

            if u7 then
                v258:Cancel();
                u7.Rotation = 0;
            end;
        end;
    end);
end;

local function finishPaidRoll() -- Line: 2244
    -- upvalues: u40 (ref), u39 (ref), u6 (ref), u42 (ref), u8 (ref), u7 (ref)
    u40 = u40 + 1;
    u39 = false;
    local v259 = u6;

    if v259 then
        if u42 == false then
            return;
        end;

        u42 = false;
        v259.Visible = false;
        local v260 = u8;

        if not v260 then
            return;
        end;

        if u7 then
            v260:Cancel();
            u7.Rotation = 0;
        end;
    end;
end;

local function playPaidRoll() -- Line: 2263
    -- upvalues: BlackMarketSceneController (copy), clearCardHover (copy)
    if not BlackMarketSceneController.IsActive() then
        return;
    end;

    clearCardHover();
    BlackMarketSceneController.Redeal();
    BlackMarketSceneController.PlayRefreshLine();
end;

local function applyDeal(p261: any, p262: boolean) -- Line: 2280
    -- upvalues: dealSignature (copy), u22 (ref), u35 (copy), u36 (copy), u37 (copy), u40 (ref), u39 (ref), u6 (ref), u42 (ref), u8 (ref), u7 (ref), BlackMarketSceneController (copy), clearCardHover (copy), renderDeal (copy)
    local v263 = dealSignature(p261) ~= dealSignature(u22);

    if v263 or p262 then
        table.clear(u35);
        table.clear(u36);
        table.clear(u37);
    end;

    if p262 then
        u40 = u40 + 1;
        u39 = false;
        local v264 = u6;

        if v264 and u42 ~= false then
            u42 = false;
            v264.Visible = false;
            local v265 = u8;

            if v265 and u7 then
                v265:Cancel();
                u7.Rotation = 0;
            end;
        end;

        if BlackMarketSceneController.IsActive() then
            clearCardHover();
            BlackMarketSceneController.Redeal();
            BlackMarketSceneController.PlayRefreshLine();
        end;
    elseif v263 and BlackMarketSceneController.IsActive() then
        BlackMarketSceneController.ResetCards();
    end;

    renderDeal(p261);
end;

local function openFrame() -- Line: 2310
    -- upvalues: u33 (ref), MenuSceneController (copy), setNavigationVisible (copy), BlackMarketSceneController (copy), u30 (ref), ensureSlots (copy), u10 (copy), u34 (copy), startCardInput (copy), renderDeal (copy), u22 (ref), u23 (ref), u29 (ref), BlackMarketDealer (copy), u39 (ref), u6 (ref), u42 (ref), u8 (ref), u7 (ref), u24 (ref), u26 (ref), RunServiceController (copy), updateCountdown (copy)
    local v266 = u33;
    u33 = false;
    MenuSceneController.HideMenuScene(true, true);
    setNavigationVisible(false);
    BlackMarketSceneController.Show(v266 or not u30);
    ensureSlots();

    if v266 then
        for _, v in u10 do
            if u34[v.Part] then
                BlackMarketSceneController.SetCardFaceUp(v.Part, true, false);
            end;
        end;
    end;

    table.clear(u34);
    startCardInput();
    renderDeal(u22);
    local v267 = u23;

    if not v267 or v267 - os.clock() <= 0 then
        local os_clock_ret = os.clock();

        if os_clock_ret - u29 >= 10 then
            u29 = os_clock_ret;
            BlackMarketDealer.RequestDeal.Send();
        end;
    end;

    local v268 = u39;
    local v269 = u6;

    if v269 and v268 ~= u42 then
        u42 = v268;
        v269.Visible = v268;
        local v270 = u8;

        if v270 then
            if v268 then
                v270:Play();
            elseif u7 then
                v270:Cancel();
                u7.Rotation = 0;
            end;
        end;
    end;

    u24 = (1 / 0);
    u26 = RunServiceController.BindToHeartbeat("UI.Blackmarket.Countdown", function(p271: number) -- Line: 2342
        -- upvalues: u24 (ref), updateCountdown (ref), u23 (ref), u29 (ref), BlackMarketDealer (ref)
        u24 = u24 + p271;

        if u24 < 0.25 then
            return;
        end;

        u24 = 0;
        updateCountdown();
        local v272 = u23;

        if v272 and v272 - os.clock() > 0 then
            return;
        end;

        local os_clock_ret = os.clock();

        if os_clock_ret - u29 < 10 then
            return;
        end;

        u29 = os_clock_ret;
        BlackMarketDealer.RequestDeal.Send();
    end);
end;

local function closeFrame() -- Line: 2359
    -- upvalues: u27 (copy), u17 (ref), u18 (ref), clearCardHover (copy), u11 (ref), u13 (copy), u6 (ref), u42 (ref), u8 (ref), u7 (ref), u21 (ref), u20 (ref), u26 (ref), u34 (copy), u33 (ref), u10 (copy), BlackMarketSceneController (copy), setNavigationVisible (copy), u5 (ref), MenuSceneController (copy)
    for _, v in u27 do
        v:Disconnect();
    end;

    table.clear(u27);

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    if u18 then
        u18:Disconnect();
        u18 = nil;
    end;

    clearCardHover();

    if u11 then
        u11.Enabled = false;
    end;

    for _, v in u13 do
        v.Button.Visible = false;
    end;

    local v273 = u6;

    if v273 and u42 ~= false then
        u42 = false;
        v273.Visible = false;
        local v274 = u8;

        if v274 and u7 then
            v274:Cancel();
            u7.Rotation = 0;
        end;
    end;

    u21 = false;
    u20 = nil;

    if u26 then
        u26:Disconnect();
        u26 = nil;
    end;

    table.clear(u34);

    if u33 then
        for _, v in u10 do
            u34[v.Part] = BlackMarketSceneController.IsCardFaceUp(v.Part);
        end;
    end;

    BlackMarketSceneController.Hide();

    if not u33 then
        setNavigationVisible(true);
    end;

    if u5 and u5.Visible then
        MenuSceneController.ShowMenuScene();
    end;
end;

local function syncScreenState() -- Line: 2432
    -- upvalues: u4 (ref), u5 (ref), u32 (ref), openFrame (copy), closeFrame (copy)
    local v275 = u4.Visible and (u5 == nil and true or u5.Visible);

    if v275 == u32 then
        return;
    end;

    u32 = v275;

    if v275 then
        openFrame();

        return;
    end;

    closeFrame();
end;

function v1.SetIntroEnabled(p276: boolean) -- Line: 2453
    -- upvalues: u30 (ref)
    u30 = p276 ~= false;
end;

function v1.Initialize(p277: userdata, p278: userdata) -- Line: 2460
    -- upvalues: u4 (ref), Constants (copy), u5 (ref), u6 (ref), u7 (ref), u8 (ref), TweenService (copy), TweenInfo_new_ret (copy), ReplicatedStorage (copy), ActivateButton (copy), CloseButtonRegistry (copy), promptRefresh (copy), u9 (ref), syncScreenState (copy), u32 (ref), openFrame (copy), closeFrame (copy)
    u4 = p278;

    if not Constants.BLACK_MARKET_ENABLED then
        p278.Visible = false;

        return;
    end;

    local Parent = p278.Parent;

    if not (Parent and (Parent:IsA("GuiObject") and Parent)) then
        Parent = nil;
    end;

    u5 = Parent;
    local Loading = p277:FindFirstChild("Loading");
    local v279;

    if Loading then
        v279 = Loading:FindFirstChild("Loading");
    else
        v279 = Loading;
    end;

    if Loading and (Loading:IsA("GuiObject") and (v279 and v279:IsA("GuiObject"))) then
        u6 = Loading;
        u7 = v279;
        u8 = TweenService:Create(v279, TweenInfo_new_ret, {
            Rotation = 359
        });
    end;

    local function goBack() -- Line: 2481
        -- upvalues: ReplicatedStorage (ref)
        require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Dashboard");
    end;

    local Back = p278:FindFirstChild("Back");

    if Back and Back:IsA("GuiButton") then
        ActivateButton(Back);
        Back.Activated:Connect(goBack);
    end;

    CloseButtonRegistry.Add(p278, nil, goBack);
    local Refresh = p278:FindFirstChild("Refresh");

    if Refresh and Refresh:IsA("GuiButton") then
        ActivateButton(Refresh);
        Refresh.Activated:Connect(promptRefresh);
        u9 = Refresh;
    end;

    p278:GetPropertyChangedSignal("Visible"):Connect(syncScreenState);

    if u5 then
        u5:GetPropertyChangedSignal("Visible"):Connect(syncScreenState);
    end;

    local v280 = u4.Visible and (u5 == nil and true or u5.Visible);

    if v280 == u32 then
        return;
    end;

    u32 = v280;

    if v280 then
        openFrame();

        return;
    end;

    closeFrame();
end;

function v1.Start() -- Line: 2513
    -- upvalues: Constants (copy), MarketplaceService (copy), DevProducts (copy), u38 (ref), u41 (ref), applyDeal (copy), u39 (ref), u32 (ref), u6 (ref), u42 (ref), u8 (ref), u40 (ref), u7 (ref), BlackMarketDealer (copy), Router (copy), u23 (ref), u25 (ref), dealSignature (copy), u22 (ref), u35 (copy), u10 (copy), renderSlot (copy), BlackMarketSceneController (copy)
    if not Constants.BLACK_MARKET_ENABLED then
        return;
    end;

    MarketplaceService.PromptProductPurchaseFinished:Connect(function(p281: number, p282: number, p283: boolean) -- Line: 2524
        -- upvalues: DevProducts (ref), u38 (ref), u41 (ref), applyDeal (ref), u39 (ref), u32 (ref), u6 (ref), u42 (ref), u8 (ref), u40 (ref), u7 (ref)
        local v284 = DevProducts["Black Market Refresh"];

        if not v284 or p282 ~= v284.DevProductId then
            return;
        end;

        u38 = false;
        local v285 = u41;
        u41 = nil;

        if v285 then
            if v285.success then
                applyDeal(v285.deal, true);
            end;
        elseif p283 then
            u39 = true;

            if u32 then
                local v286 = u6;

                if v286 and u42 ~= true then
                    u42 = true;
                    v286.Visible = true;
                    local v287 = u8;

                    if v287 then
                        v287:Play();
                    end;
                end;
            end;

            u40 = u40 + 1;
            local u288 = u40;
            task.delay(60, function() -- Line: 2230
                -- upvalues: u288 (copy), u40 (ref), u39 (ref), u6 (ref), u42 (ref), u8 (ref), u7 (ref)
                if u288 ~= u40 then
                    return;
                end;

                u39 = false;
                local v289 = u6;

                if v289 then
                    if u42 == false then
                        return;
                    end;

                    u42 = false;
                    v289.Visible = false;
                    local v290 = u8;

                    if not v290 then
                        return;
                    end;

                    if u7 then
                        v290:Cancel();
                        u7.Rotation = 0;
                    end;
                end;
            end);
        end;
    end);
    BlackMarketDealer.DealData.Listen(function(p291) -- Line: 2546
        -- upvalues: u38 (ref), u39 (ref), u41 (ref), u40 (ref), u6 (ref), u42 (ref), u8 (ref), u7 (ref), Router (ref), u23 (ref), u25 (ref), dealSignature (ref), u22 (ref), applyDeal (ref)
        local v292;

        if typeof(p291) == "table" then
            v292 = p291.isRefresh == true;
        else
            v292 = false;
        end;

        local v293 = v292 and u38 and not u39;

        if v293 and (p291.success or not (u41 and u41.success)) then
            u41 = p291;
        end;

        if typeof(p291) ~= "table" or not p291.success then
            if u39 and v292 then
                u40 = u40 + 1;
                u39 = false;
                local v294 = u6;

                if v294 and u42 ~= false then
                    u42 = false;
                    v294.Visible = false;
                    local v295 = u8;

                    if v295 and u7 then
                        v295:Cancel();
                        u7.Rotation = 0;
                    end;
                end;
            end;

            local v296 = typeof(p291) == "table" and p291.message or "The Black Market is unavailable.";
            Router.broadcastRouter("CreateNotification", "Black Market", v296, 5);

            return;
        end;

        local deal = p291.deal;
        local v297;

        if typeof(deal) == "table" then
            v297 = tonumber(deal.msRemaining) or nil;
        else
            v297 = nil;
        end;

        local v298;

        if v297 then
            v298 = os.clock() + v297 / 1000;
        else
            v298 = nil;
        end;

        u23 = v298;
        u25 = nil;

        if v293 then
            return;
        end;

        local v299 = dealSignature(p291.deal) ~= dealSignature(u22);

        if v292 then
            v292 = u39 or v299;
        end;

        applyDeal(p291.deal, v292);
    end);
    BlackMarketDealer.BuyCardResult.Listen(function(p300) -- Line: 2598
        -- upvalues: Router (ref), u35 (ref), u10 (ref), renderSlot (ref), BlackMarketSceneController (ref)
        if typeof(p300) ~= "table" or not p300.success then
            local v301 = typeof(p300) == "table" and p300.message or "The purchase failed.";
            Router.broadcastRouter("CreateNotification", "Black Market", v301, 5);

            return;
        end;

        local cardId = p300.cardId;

        if cardId ~= nil then
            u35[tostring(cardId)] = true;

            for _, v in u10 do
                if v.Card and tostring(v.Card.cardId) == tostring(cardId) then
                    renderSlot(v, v.Card);
                end;
            end;
        end;

        Router.broadcastRouter("RunStoreSound", "Successful Purchase");
        BlackMarketSceneController.PlayPurchaseLine();
    end);
end;

return v1;