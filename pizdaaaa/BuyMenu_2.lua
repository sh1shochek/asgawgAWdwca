-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu
-- Decompile time: 45.20 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
local GuiService = game:GetService("GuiService");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local SurvivalVoiceController = require(ReplicatedStorage.Controllers.SurvivalVoiceController);
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea);
local SurvivalBuyRules = require(ReplicatedStorage.Components.Common.SurvivalBuyRules);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local SurvivalState = require(ReplicatedStorage.Components.Common.SurvivalState);
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local GetBadgeIcon = require(ReplicatedStorage.Components.Common.GetBadgeIcon);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Spring = require(ReplicatedStorage.Shared.Spring);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local Income = require(ReplicatedStorage.Database.Custom.GameStats.Income);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation);
local WeaponStats = require(script:WaitForChild("WeaponStats"));
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
local Color3_fromRGB_ret = Color3.fromRGB(149, 149, 149);
local Color3_new_ret = Color3.new(1, 1, 1);
local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = { "Equipment", "Pistols", "Mid Tier", "Rifles" };
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 205, 70);
local Color3_fromRGB_ret3 = Color3.fromRGB(14, 14, 16);
local u3 = {
    Team = true,
    Money = true,
    Slot1 = true,
    Slot2 = true,
    Armor = true,
    CompetitivePlayerColor = true,
    DisplayName = true
};
local u4 = Janitor.new();
local u5 = Spring.new(1, 8, 0);
local u6 = {};
local u7 = false;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = setmetatable({}, {
    __mode = "k"
});
local u12 = {
    ["1"] = "Kevlar",
    ["2"] = "Kevlar + Helmet"
};
local u13 = {
    Kevlar = true,
    ["Kevlar + Helmet"] = true,
    ["Defuse Kit"] = true,
    ["Rescue Kit"] = true
};
local u14 = {
    Kevlar = true,
    ["Kevlar + Helmet"] = true
};
local u15 = {
    ["3"] = "Health",
    ["5"] = "Ammo"
};
local u16 = {
    Kevlar = "Kevlar Vest",
    ["Kevlar + Helmet"] = "Kevlar & Helmet"
};
local u17 = {
    Terrorists = { "Glock-18" },
    ["Counter-Terrorists"] = { "USP-S", "P2000" }
};
local u18 = nil;
local u19 = {};
local u20 = {};
local u21 = false;
local u22 = nil;
local u23 = {};
local u24 = 0;
local u25 = 0;
local u26 = nil;
local Color3_fromRGB_ret4 = Color3.fromRGB(255, 70, 70);
local Color3_fromRGB_ret5 = Color3.fromRGB(235, 40, 40);

local function CommaNumber(p27: number) -- Line: 202
    return tostring(p27):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function IsPricedGamemode() -- Line: 206
    local Attribute = workspace:GetAttribute("Gamemode");
    local v28;

    if Attribute == "Deathmatch" then
        v28 = false;
    else
        v28 = Attribute ~= "Tutorial";
    end;

    return v28;
end;

local function GetInventoryItemFromIdentifier(p29: table, p30: string) -- Line: 211
    for _, v in ipairs(p29) do
        if v._id == p30 then
            return v;
        end;
    end;

    return nil;
end;

local function ResolveTemplateInventoryItem(p31) -- Line: 224
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local Attribute = p31:GetAttribute("InventoryItemId");

    if not (Attribute and (Attribute ~= "" and Attribute ~= "__buymenu_zeus_placeholder__")) then
        return nil;
    end;

    if string.sub(Attribute, 1, 10) == "equipment:" then
        return nil;
    end;

    local v32 = DataController.Get(LocalPlayer, "Inventory");

    if not v32 or typeof(v32) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v32) do
        if v._id == Attribute then
            return v;
        end;
    end;

    return nil;
end;

local function ResolveTemplateSkinName(p33) -- Line: 240
    -- upvalues: ResolveTemplateInventoryItem (copy)
    local v34 = ResolveTemplateInventoryItem(p33);

    if v34 then
        v34 = v34.Skin;
    end;

    if typeof(v34) == "string" and v34 ~= "" then
        return v34;
    end;

    return nil;
end;

local function GetSkinRender(p35) -- Line: 248
    -- upvalues: GetWeaponProperties (copy), GetResolvedSkinInformation (copy), Skins (copy)
    local v36 = GetWeaponProperties(p35.Name);
    local v37;

    if v36 then
        v37 = GetResolvedSkinInformation(p35.Name, p35.Skin);
    else
        v37 = v36;
    end;

    if not v37 then
        return nil;
    end;

    local v38 = Skins.GetWearImageForFloat(v37, p35.Float or 0.9999) or v37.imageAssetId;

    if v38 and (v38 ~= "" and (v38 ~= v36.Icon and v38 ~= v36.ReverseIcon)) then
        return v38;
    end;

    return nil;
end;

local function GetWeaponStatsPanel() -- Line: 263
    -- upvalues: u8 (ref)
    if u8 then
        return u8:FindFirstChild("WeaponStats");
    end;

    return nil;
end;

local function ClearWeaponInfoFrame() -- Line: 268
    -- upvalues: u8 (ref), WeaponStats (copy)
    local v39;

    if u8 then
        v39 = u8:FindFirstChild("WeaponStats");
    else
        v39 = nil;
    end;

    if v39 then
        WeaponStats.Clear(v39);
        v39.Visible = true;
    end;
end;

local function ShowWeaponInfoFrame(p40) -- Line: 277
    -- upvalues: u8 (ref), ResolveTemplateInventoryItem (copy), Skins (copy), WeaponStats (copy), GetSkinDisplayName (copy), GetSkinRender (copy)
    local v41;

    if u8 then
        v41 = u8:FindFirstChild("WeaponStats");
    else
        v41 = nil;
    end;

    local Attribute = p40:GetAttribute("Weapon");

    if not (v41 and (Attribute and Attribute ~= "")) then
        return;
    end;

    local v42 = ResolveTemplateInventoryItem(p40);
    local v43 = ResolveTemplateInventoryItem(p40);

    if v43 then
        v43 = v43.Skin;
    end;

    if typeof(v43) ~= "string" or v43 == "" then
        v43 = nil;
    end;

    local v44;

    if v43 == nil then
        v44 = false;
    else
        v44 = v43 ~= "Stock";
    end;

    local v45;

    if v44 then
        v45 = Skins.GetSkinInformation(Attribute, v43);
    else
        v45 = nil;
    end;

    local Fill = WeaponStats.Fill;
    local v46 = {};
    local v47;

    if v42 then
        v47 = v42.NameTag;
    else
        v47 = v42;
    end;

    v46.DisplayName = GetSkinDisplayName.GetWeaponDisplayName(Attribute, v47);
    local v48;

    if v44 then
        v48 = GetSkinDisplayName(v43);
    else
        v48 = nil;
    end;

    v46.SkinName = v48;

    if v45 then
        v45 = v45.rarity;
    end;

    v46.Rarity = v45;
    v46.Price = not p40.Cost.Visible and "" or p40.Cost.Text;
    v46.Icon = v42 and GetSkinRender(v42) or p40.Icon.Image;

    if not Fill(v41, Attribute, v46) then
        local v49;

        if u8 then
            v49 = u8:FindFirstChild("WeaponStats");
        else
            v49 = nil;
        end;

        if v49 then
            WeaponStats.Clear(v49);
            v49.Visible = true;
        end;
    end;
end;

local function IsObjectiveEquipmentAvailableForPlayer(p50: string, p51: string?, p52: any) -- Line: 303
    if p51 ~= "Counter-Terrorists" then
        return false;
    end;

    if p50 == "Defuse Kit" then
        return p52 == "Bomb Defusal";
    end;

    return p50 ~= "Rescue Kit" and true or p52 == "Hostage Rescue";
end;

local function IsCompetitiveServerGamemode() -- Line: 321
    return workspace:GetAttribute("ServerGamemode") == "Competitive";
end;

local function IsEquipmentAvailableForLocalPlayer(p53: string) -- Line: 325
    -- upvalues: SurvivalBuyRules (copy), IsSurvivalMode (copy), u13 (copy), u14 (copy), LocalPlayer (copy)
    if SurvivalBuyRules.IsSurvivalOnlyEquipment(p53) then
        return IsSurvivalMode();
    end;

    if u13[p53] and (workspace:GetAttribute("ServerGamemode") ~= "Competitive" and not (u14[p53] and IsSurvivalMode())) then
        return false;
    end;

    if p53 ~= "Defuse Kit" and p53 ~= "Rescue Kit" then
        return true;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");
    local Attribute2 = workspace:GetAttribute("Gamemode");

    if Attribute ~= "Counter-Terrorists" then
        return false;
    end;

    if p53 == "Defuse Kit" then
        return Attribute2 == "Bomb Defusal";
    end;

    return p53 ~= "Rescue Kit" and true or Attribute2 == "Hostage Rescue";
end;

local function GetEquipmentByTemplate(p54: string) -- Line: 347
    -- upvalues: u12 (copy), IsEquipmentAvailableForLocalPlayer (copy), u15 (copy)
    local v55 = u12[p54];

    if v55 then
        if IsEquipmentAvailableForLocalPlayer(v55) then
            return v55;
        end;

        return nil;
    end;

    local v56 = u15[p54];

    if v56 and IsEquipmentAvailableForLocalPlayer(v56) then
        return v56;
    end;

    if p54 == "3" then
        return IsEquipmentAvailableForLocalPlayer("Defuse Kit") and "Defuse Kit" or (IsEquipmentAvailableForLocalPlayer("Rescue Kit") and "Rescue Kit" or nil);
    end;

    return nil;
end;

local function GetPlayerArmorState(p57: userdata) -- Line: 378
    -- upvalues: HttpService (copy)
    local Attribute = p57:GetAttribute("Armor");

    if typeof(Attribute) == "string" and Attribute ~= "" then
        local success, result = pcall(function() -- Line: 381
            -- upvalues: HttpService (ref), Attribute (copy)
            return HttpService:JSONDecode(Attribute);
        end);

        if success and typeof(result) == "table" then
            return {
                Type = tostring(result.Type or ""),
                Health = tonumber(result.Health) or 0
            };
        end;
    end;

    return {
        Type = "",
        Health = 0
    };
end;

local function GetDisplayCost(p58: string, p59: any) -- Line: 398
    -- upvalues: GameState (copy), IsSurvivalMode (copy), InventoryController (copy), SurvivalBuyRules (copy), LocalPlayer (copy), GetPlayerArmorState (copy)
    local Attribute = workspace:GetAttribute("Gamemode");

    if Attribute == "Deathmatch" or (Attribute == "Tutorial" or GameState.GetState() == "Warmup") then
        return 0;
    end;

    if workspace:GetAttribute("VIPInfiniteCashEnabled") == true then
        return 0;
    end;

    local v60 = p58 == "Ammo" and IsSurvivalMode() and InventoryController.getCurrentInventory();

    if v60 then
        return SurvivalBuyRules.GetAmmoPrice(v60);
    end;

    local Cost = p59.Cost;

    if p58 == "Molotov" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
        Cost = 500;
    elseif p58 == "Kevlar + Helmet" then
        local v61 = GetPlayerArmorState(LocalPlayer);

        if v61.Type == "Kevlar" and v61.Health >= 100 then
            return SurvivalBuyRules.GetPrice("Helmet", 350);
        end;
    end;

    return SurvivalBuyRules.GetPrice(p58, Cost);
end;

local function IsEquipmentOwned(p62: string) -- Line: 427
    -- upvalues: LocalPlayer (copy), GetPlayerArmorState (copy)
    if p62 == "Defuse Kit" then
        return LocalPlayer:GetAttribute("HasDefuseKit") == true;
    end;

    if p62 == "Rescue Kit" then
        return LocalPlayer:GetAttribute("HasRescueKit") == true;
    end;

    local v63 = GetPlayerArmorState(LocalPlayer);

    if p62 ~= "Kevlar" and p62 ~= "Kevlar + Helmet" then
        return false;
    end;

    local v64;

    if v63.Health > 0 then
        v64 = v63.Type == p62;
    else
        v64 = false;
    end;

    return v64;
end;

local function IsEquipmentPurchaseBlockedForLocalPlayer(p65: string) -- Line: 442
    -- upvalues: LocalPlayer (copy), InventoryController (copy), SurvivalBuyRules (copy), IsEquipmentAvailableForLocalPlayer (copy), IsEquipmentOwned (copy), GetPlayerArmorState (copy)
    if p65 == "Health" then
        local Attribute = LocalPlayer:GetAttribute("Health");
        local Attribute2 = LocalPlayer:GetAttribute("MaxHealth");
        local v66;

        if typeof(Attribute) == "number" and typeof(Attribute2) == "number" then
            v66 = Attribute2 <= Attribute;
        else
            v66 = false;
        end;

        return v66;
    end;

    if p65 == "Ammo" then
        local CurrentInventory = InventoryController.getCurrentInventory();
        local v67;

        if CurrentInventory == nil then
            v67 = false;
        else
            v67 = SurvivalBuyRules.GetAmmoPrice(CurrentInventory) <= 0;
        end;

        return v67;
    end;

    if not IsEquipmentAvailableForLocalPlayer(p65) then
        return true;
    end;

    if p65 == "Defuse Kit" or p65 == "Rescue Kit" then
        return IsEquipmentOwned(p65);
    end;

    local v68 = GetPlayerArmorState(LocalPlayer);
    local v69;

    if v68.Type == "Kevlar + Helmet" then
        v69 = v68.Health > 0;
    else
        v69 = false;
    end;

    local v70;

    if v69 then
        v70 = v68.Health >= SurvivalBuyRules.GetArmorPool("Kevlar + Helmet");
    else
        v70 = v69;
    end;

    if p65 == "Kevlar" then
        local v71;

        if v68.Type == "Kevlar" then
            v71 = v68.Health >= 100;
        else
            v71 = false;
        end;

        return v71 or v70;
    end;

    if p65 == "Kevlar + Helmet" then
        return v69;
    end;

    return false;
end;

local function IsStarterPistolForLocalPlayer(p72: string) -- Line: 474
    -- upvalues: u17 (copy), LocalPlayer (copy)
    local v73 = u17[LocalPlayer:GetAttribute("Team")];

    if v73 then
        return table.find(v73, p72) ~= nil;
    end;

    return false;
end;

local function GetInventoryItemProperties(p74: string) -- Line: 482
    -- upvalues: ReplicatedStorage (copy)
    local v75 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p74) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(p74);

    if v75 then
        return require(v75);
    end;

    return nil;
end;

local function GetItemIcon(p76: string?) -- Line: 494
    -- upvalues: ReplicatedStorage (copy)
    if p76 then
        local v77 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p76) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(p76);

        if v77 then
            p76 = require(v77);
        else
            p76 = nil;
        end;
    end;

    if p76 then
        return p76.ReverseIcon or p76.Icon;
    end;

    return nil;
end;

local function GetArmorIcon(p78: userdata) -- Line: 502
    -- upvalues: GetPlayerArmorState (copy), ReplicatedStorage (copy)
    local v79 = GetPlayerArmorState(p78);

    if v79.Health <= 0 or v79.Type == "" then
        return nil;
    end;

    local Type = v79.Type;

    if Type then
        local v80 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Type) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Type);

        if v80 then
            Type = require(v80);
        else
            Type = nil;
        end;
    end;

    if Type then
        return Type.ReverseIcon or Type.Icon;
    end;

    return nil;
end;

local function GetParticipantColor(p81: userdata?) -- Line: 512
    -- upvalues: GetPreferenceColor (copy)
    if p81 then
        p81 = p81:GetAttribute("CompetitivePlayerColor");
    end;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" and typeof(p81) == "Color3" then
        return p81;
    end;

    return GetPreferenceColor();
end;

local function ApplyItemNameLabel(p82: userdata, p83: string, p84: any) -- Line: 521
    -- upvalues: u16 (copy), GetSkinDisplayName (copy)
    local v85 = u16[p83] or GetSkinDisplayName.GetWeaponDisplayName(p83, p84);

    if not GetSkinDisplayName.GetNameTag(p84) then
        v85 = string.upper(v85);
    end;

    GetSkinDisplayName.ApplyNameLabel(p82, v85, p84);
end;

local function GetSlotLook(p86: userdata) -- Line: 532
    -- upvalues: u11 (copy)
    local v87 = u11[p86];

    if v87 then
        return v87;
    end;

    local Icon = p86:FindFirstChild("Icon");
    local IconGlow = p86:FindFirstChild("IconGlow");
    local v88 = p86:FindFirstChildOfClass("UIStroke");
    local v89 = {};
    local v90;

    if Icon then
        v90 = Icon.Size;
    else
        v90 = UDim2.fromScale(1, 1);
    end;

    v89.IconSize = v90;
    v89.GlowTransparency = not IconGlow and 1 or IconGlow.ImageTransparency;
    local v91;

    if v88 then
        v91 = v88.Color;
    else
        v91 = Color3.new();
    end;

    v89.StrokeColor = v91;
    v89.StrokeThickness = not v88 and 1 or v88.Thickness;
    v89.StrokeTransparency = not v88 and 0 or v88.Transparency;
    u11[p86] = v89;

    return v89;
end;

local function SetSlotHighlight(p92: userdata, p93: number, p94: boolean) -- Line: 552
    -- upvalues: GetSlotLook (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local v95 = GetSlotLook(p92);
    local Icon = p92:FindFirstChild("Icon");
    local IconGlow = p92:FindFirstChild("IconGlow");

    if Icon then
        local IconSize = v95.IconSize;
        TweenService:Create(Icon, TweenInfo_new_ret, {
            Size = UDim2.new(IconSize.X.Scale * p93, IconSize.X.Offset * p93, IconSize.Y.Scale * p93, IconSize.Y.Offset * p93)
        }):Play();
    end;

    if IconGlow then
        local v96 = {};
        local v97;

        if p94 then
            v97 = v95.GlowTransparency - 0.12;
        else
            v97 = v95.GlowTransparency;
        end;

        v96.ImageTransparency = v97;
        TweenService:Create(IconGlow, TweenInfo_new_ret, v96):Play();
    end;
end;

local function ApplyTemplateColor(p98: any, p99) -- Line: 574
    -- upvalues: Color3_fromRGB_ret (copy), Color3_new_ret (copy)
    local v100 = p99 ~= Color3_fromRGB_ret;
    p98.Icon.ImageColor3 = p99;
    p98.IconGlow.ImageColor3 = p99;
    local v101;

    if v100 then
        v101 = Color3_new_ret;
    else
        v101 = Color3_fromRGB_ret;
    end;

    p98.ItemName.TextColor3 = v101;
    local v102;

    if v100 then
        v102 = Color3_new_ret;
    else
        v102 = Color3_fromRGB_ret;
    end;

    p98.Cost.TextColor3 = v102;
    local v103 = p98.Cost:FindFirstChildOfClass("UIGradient");

    if v103 then
        v103.Enabled = v100;
    end;
end;

local u104 = nil;

local function RefreshSlotOutline(p105) -- Line: 595
    -- upvalues: GetSlotLook (copy), u104 (ref), Color3_fromRGB_ret5 (copy), GetPreferenceColor (copy)
    local v106 = p105:FindFirstChildOfClass("UIStroke");

    if not v106 then
        return;
    end;

    local v107 = GetSlotLook(p105);
    local v108 = u104(p105);
    local Stroke = p105:FindFirstChild("Stroke");

    if Stroke then
        Stroke = Stroke:FindFirstChildOfClass("UIStroke");
    end;

    if Stroke then
        Stroke.Enabled = not v108 and p105:GetAttribute("OwnedMax") ~= true and true or false;
    end;

    if v108 then
        v106.Color = Color3_fromRGB_ret5;
        v106.Thickness = 2;
        v106.Transparency = 0;

        return;
    end;

    if p105:GetAttribute("OwnedMax") == true then
        v106.Color = GetPreferenceColor();
        v106.Thickness = v107.StrokeThickness;
        v106.Transparency = 0.1;

        return;
    end;

    v106.Color = v107.StrokeColor;
    v106.Thickness = v107.StrokeThickness;
    v106.Transparency = v107.StrokeTransparency;
end;

local function HideTemplate(p109) -- Line: 623
    p109:SetAttribute("IsEquipment", nil);
    p109:SetAttribute("Weapon", nil);
    p109:SetAttribute("OwnedMax", nil);
    p109.Visible = false;
end;

local u110 = nil;

local function setupBuyMenuTemplates() -- Line: 633
    -- upvalues: Profiler (copy), u110 (ref), u10 (copy), Router (copy), LocalPlayer (copy), u1 (copy), u12 (copy), IsEquipmentAvailableForLocalPlayer (copy), u15 (copy)
    Profiler.mark("UI.BuyMenu.SetupBuyMenuTemplates");
    u110();

    for _, v in ipairs(u10) do
        local Button = v.Button;

        if v.Category == "Equipment" then
            if Button.Name == "4" then
                local v111 = Router.broadcastRouter("GetEquippedInventoryItem", LocalPlayer, "Equipped.Equipped Zeus x27");
                u1.createTemplate(Button, not (v111 and v111.Name) and {
                    Name = "Zeus x27",
                    _id = "__buymenu_zeus_placeholder__"
                } or v111, false, "Equipped.Equipped Zeus x27");
            else
                local Name = Button.Name;
                local v112 = u12[Name];

                if v112 then
                    if not IsEquipmentAvailableForLocalPlayer(v112) then
                        v112 = nil;
                    end;
                else
                    v112 = u15[Name];

                    if not (v112 and IsEquipmentAvailableForLocalPlayer(v112)) then
                        if Name == "3" then
                            v112 = IsEquipmentAvailableForLocalPlayer("Defuse Kit") and "Defuse Kit" or (IsEquipmentAvailableForLocalPlayer("Rescue Kit") and "Rescue Kit" or nil);
                        else
                            v112 = nil;
                        end;
                    end;
                end;

                if v112 then
                    u1.createTemplate(Button, {
                        Name = v112,
                        _id = `equipment:{v112}`
                    }, true, nil);
                else
                    Button:SetAttribute("IsEquipment", nil);
                    Button:SetAttribute("Weapon", nil);
                    Button:SetAttribute("OwnedMax", nil);
                    Button.Visible = false;
                end;
            end;
        else
            u1.setupTemplate(Button, (`Loadout.{v.Category}.Options.{tonumber(Button.Name)}`));
        end;
    end;
end;

local function QueryInventoryItem(p113: any, p114: string) -- Line: 685
    for _, v in ipairs(p113) do
        for _, v2 in ipairs(v._items) do
            if v2.Name == p114 then
                return v2;
            end;
        end;
    end;

    return false;
end;

local function QueryRoundPurchasedInventoryItem(p115: any, p116: string) -- Line: 696
    -- upvalues: u6 (copy)
    for _, v in ipairs(p115) do
        for _, v2 in ipairs(v._items) do
            if v2.Name == p116 and table.find(u6, v2.Identifier) then
                return v2;
            end;
        end;
    end;

    return false;
end;

local function QueryInventoryItemPurchasedThisRound(p117: any, p118: string) -- Line: 711
    -- upvalues: QueryRoundPurchasedInventoryItem (copy), QueryInventoryItem (copy)
    return QueryRoundPurchasedInventoryItem(p117, p118) or QueryInventoryItem(p117, p118);
end;

local function IsUnrefundableStarterPistol(p119: string, p120: any) -- Line: 719
    -- upvalues: u17 (copy), LocalPlayer (copy), QueryRoundPurchasedInventoryItem (copy)
    local v121 = u17[LocalPlayer:GetAttribute("Team")];
    local v122;

    if v121 then
        v122 = table.find(v121, p119) ~= nil;
    else
        v122 = false;
    end;

    if v122 then
        return not p120 and true or not QueryRoundPurchasedInventoryItem(p120, p119);
    end;

    return false;
end;

local function GetInventoryItemCount(p123: any, p124: string) -- Line: 732
    local v125 = 0;

    for _, v in ipairs(p123) do
        for _, v2 in ipairs(v._items) do
            if v2.Name == p124 then
                v125 = v125 + 1;
            end;
        end;
    end;

    return v125;
end;

local function IsTutorialItemAllowed(p126: string) -- Line: 744
    -- upvalues: TutorialPurchaseLock (copy), LocalPlayer (copy)
    return TutorialPurchaseLock.isPurchaseAllowed(LocalPlayer, p126);
end;

local u127 = {};

u104 = function(p128) -- Line: 762
    -- upvalues: u127 (copy)
    return u127[p128.Icon] ~= nil;
end;

local function IsTutorialPulseWanted(p129: string, p130: any) -- Line: 770
    -- upvalues: TutorialPurchaseLock (copy), LocalPlayer (copy), GetInventoryItemCount (copy)
    local RequiredItems = TutorialPurchaseLock.getRequiredItems(LocalPlayer);

    if not (RequiredItems and table.find(RequiredItems, p129)) then
        return false;
    end;

    if p130 then
        p130 = GetInventoryItemCount(p130, p129) > 0;
    end;

    return not p130;
end;

local function StopTutorialPulse(p131: userdata, p132) -- Line: 778
    -- upvalues: u127 (copy), RefreshSlotOutline (copy)
    local v133 = u127[p131];

    if not v133 then
        return;
    end;

    u127[p131] = nil;
    v133.Color:Cancel();
    v133.Swell:Cancel();
    v133.Scale.Scale = 1;
    p131.ImageColor3 = p132 or v133.RestingColor;
    local Parent = p131.Parent;

    if Parent and Parent:IsA("TextButton") then
        RefreshSlotOutline(Parent);
    end;
end;

u110 = function() -- Line: 794
    -- upvalues: u127 (copy), StopTutorialPulse (copy)
    for i in u127 do
        StopTutorialPulse(i);
    end;
end;

local function SyncTutorialPulse(p134: any, p135, p136: boolean) -- Line: 805
    -- upvalues: u127 (copy), StopTutorialPulse (copy), TweenService (copy), Color3_fromRGB_ret4 (copy), RefreshSlotOutline (copy)
    local Icon = p134.Icon;
    local v137 = u127[Icon];

    if not p136 then
        StopTutorialPulse(Icon, p135);

        return;
    end;

    if v137 then
        if not p135 or p135 == v137.RestingColor then
            return;
        end;

        StopTutorialPulse(Icon, p135);
    end;

    local TutorialPulse = Icon:FindFirstChild("TutorialPulse");

    if not TutorialPulse then
        TutorialPulse = Instance.new("UIScale");
        TutorialPulse.Name = "TutorialPulse";
        TutorialPulse.Parent = Icon;
    end;

    TutorialPulse.Scale = 1;
    local TweenInfo_new_ret2 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
    local v138 = {
        Color = TweenService:Create(Icon, TweenInfo_new_ret2, {
            ImageColor3 = Color3_fromRGB_ret4
        }),
        Swell = TweenService:Create(TutorialPulse, TweenInfo_new_ret2, {
            Scale = 1.1
        }),
        Scale = TutorialPulse,
        RestingColor = p135 or Icon.ImageColor3
    };
    u127[Icon] = v138;
    v138.Color:Play();
    v138.Swell:Play();
    RefreshSlotOutline(p134);
end;

local function IsTutorialPurchasePending() -- Line: 848
    -- upvalues: InventoryController (copy), TutorialPurchaseLock (copy), LocalPlayer (copy), GetInventoryItemCount (copy)
    local CurrentInventory = InventoryController.getCurrentInventory();

    return TutorialPurchaseLock.isWaitingOnPurchase(LocalPlayer, function(p139: string) -- Line: 850
        -- upvalues: CurrentInventory (copy), GetInventoryItemCount (ref)
        if CurrentInventory then
            return GetInventoryItemCount(CurrentInventory, p139) > 0;
        end;

        return false;
    end);
end;

local function CanCarryDuplicate(p140: any, p141: string) -- Line: 858
    -- upvalues: GetInventoryItemCount (copy), SurvivalBuyRules (copy)
    local v142 = GetInventoryItemCount(p140, p141);
    local GrenadeLimit = SurvivalBuyRules.GetGrenadeLimit(p141);

    if GrenadeLimit then
        return v142 < GrenadeLimit;
    end;

    return v142 == 0;
end;

local function UpdateTemplateOwnership(p143: any, p144: string, p145: boolean, p146: any) -- Line: 871
    -- upvalues: IsEquipmentOwned (copy), GetInventoryItemCount (copy), SurvivalBuyRules (copy), GameState (copy), QueryRoundPurchasedInventoryItem (copy), RefreshSlotOutline (copy)
    local v147 = false;
    local v148 = false;

    if p145 then
        v147 = IsEquipmentOwned(p144);
    elseif p146 then
        v147 = GetInventoryItemCount(p146, p144) > 0;
        local v149 = GetInventoryItemCount(p146, p144);
        local GrenadeLimit = SurvivalBuyRules.GetGrenadeLimit(p144);

        if GrenadeLimit then
            v148 = v149 < GrenadeLimit;
        elseif v149 == 0 then
            v148 = true;
        else
            v148 = false;
        end;
    end;

    local Return = p143.Return;

    if v147 then
        local Attribute = workspace:GetAttribute("Gamemode");
        local v150;

        if Attribute == "Deathmatch" then
            v150 = false;
        else
            v150 = Attribute ~= "Tutorial";
        end;

        if v150 then
            if GameState.GetState() == "Warmup" then
                p145 = false;
            elseif not p145 then
                if p146 == nil then
                    p145 = false;
                else
                    p145 = QueryRoundPurchasedInventoryItem(p146, p144) ~= false;
                end;
            end;
        else
            p145 = v150;
        end;
    else
        p145 = v147;
    end;

    Return.Visible = p145;

    if v147 then
        v147 = not v148;
    end;

    p143:SetAttribute("OwnedMax", v147);
    RefreshSlotOutline(p143);
end;

local function WaitForAttribute(p151: userdata, p152: string) -- Line: 898
    local Attribute = p151:GetAttribute(p152);

    while not Attribute do
        Attribute = p151:GetAttribute(p152);
        task.wait();
    end;

    return Attribute;
end;

local function UpdateBuyMenuTimerText() -- Line: 907
    -- upvalues: GameState (copy), u8 (ref), GetTimerFormat (copy)
    local State = GameState.GetState();
    local v153;

    if State == "Buy Period" or State == "Round In Progress" then
        v153 = workspace:GetAttribute("BuyTimerRemaining");
    else
        v153 = nil;
    end;

    if typeof(v153) ~= "number" then
        v153 = workspace:GetAttribute("Timer");
    end;

    local v154;

    if typeof(v153) == "number" then
        local math_floor_ret = math.floor(v153);
        v154 = math.max(0, math_floor_ret);
    else
        v154 = 0;
    end;

    u8.PlayerPanel.BuyTime.Timer.Text = GetTimerFormat(v154);
end;

local function SetLoadoutIcon(p155: userdata?, p156: string?) -- Line: 925
    if not (p155 and p155:IsA("ImageLabel")) then
        return;
    end;

    p155.Image = p156 or "";
    p155.Visible = p156 ~= nil;
end;

local function GetFirstItemName(p157, p158) -- Line: 933
    -- upvalues: NumberSlots (copy)
    if p157 then
        p157 = p157[NumberSlots[p158]];
    end;

    if p157 then
        p157 = p157._items[1];
    end;

    if p157 then
        p157 = p157.Name;
    end;

    return p157;
end;

local function UpdatePlayerLoadout() -- Line: 940
    -- upvalues: u8 (ref), InventoryController (copy), NumberSlots (copy), ReplicatedStorage (copy), LocalPlayer (copy), GetPlayerArmorState (copy)
    local Loadout = u8.PlayerPanel.Loadout;
    local CurrentInventory = InventoryController.getCurrentInventory();
    local Primary = Loadout.Primary;
    local v159;

    if CurrentInventory then
        v159 = CurrentInventory[NumberSlots.Primary];
    else
        v159 = CurrentInventory;
    end;

    if v159 then
        v159 = v159._items[1];
    end;

    if v159 then
        v159 = v159.Name;
    end;

    if v159 then
        local v160 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(v159) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(v159);

        if v160 then
            v159 = require(v160);
        else
            v159 = nil;
        end;
    end;

    local v161;

    if v159 then
        v161 = v159.ReverseIcon or v159.Icon;
    else
        v161 = nil;
    end;

    if Primary and Primary:IsA("ImageLabel") then
        Primary.Image = v161 or "";
        Primary.Visible = v161 ~= nil;
    end;

    local Secondary = Loadout.Secondary;
    local v162;

    if CurrentInventory then
        v162 = CurrentInventory[NumberSlots.Secondary];
    else
        v162 = CurrentInventory;
    end;

    if v162 then
        v162 = v162._items[1];
    end;

    if v162 then
        v162 = v162.Name;
    end;

    if v162 then
        local v163 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(v162) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(v162);

        if v163 then
            v162 = require(v163);
        else
            v162 = nil;
        end;
    end;

    local v164;

    if v162 then
        v164 = v162.ReverseIcon or v162.Icon;
    else
        v164 = nil;
    end;

    if Secondary and Secondary:IsA("ImageLabel") then
        Secondary.Image = v164 or "";
        Secondary.Visible = v164 ~= nil;
    end;

    local Armor = Loadout.Armor;
    local v165 = GetPlayerArmorState(LocalPlayer);
    local v166;

    if v165.Health <= 0 or v165.Type == "" then
        v166 = nil;
    else
        local Type = v165.Type;

        if Type then
            local v167 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Type) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Type);

            if v167 then
                Type = require(v167);
            else
                Type = nil;
            end;
        end;

        if Type then
            v166 = Type.ReverseIcon or Type.Icon;
        else
            v166 = nil;
        end;
    end;

    if Armor and Armor:IsA("ImageLabel") then
        Armor.Image = v166 or "";
        Armor.Visible = v166 ~= nil;
    end;

    if CurrentInventory then
        CurrentInventory = CurrentInventory[NumberSlots.Grenade];
    end;

    local v168 = not CurrentInventory and {} or CurrentInventory._items;
    local Grenade1 = Loadout.Grenade1;

    for i = 1, math.max(#v168, 2) do
        local v169 = Loadout:FindFirstChild((`Grenade{i}`));

        if not v169 then
            v169 = Grenade1:Clone();
            v169.Name = `Grenade{i}`;
            v169.LayoutOrder = Grenade1.LayoutOrder + i - 1;
            v169.Parent = Loadout;
        end;

        local v170 = v168[i];

        if v170 then
            local Name = v168[i].Name;

            if Name then
                local v171 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Name) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Name);

                if v171 then
                    Name = require(v171);
                else
                    Name = nil;
                end;
            end;

            if Name then
                v170 = Name.ReverseIcon or Name.Icon;
            else
                v170 = nil;
            end;
        end;

        local v172;

        if v169 then
            if v169:IsA("ImageLabel") then
                v169.Image = v170 or "";
                v169.Visible = v170 ~= nil;
                v172 = i;
            else
                v172 = i;
            end;
        else
            v172 = i;
        end;
    end;

    for _, child in Loadout:GetChildren() do
        local v173 = tonumber(string.match(child.Name, "^Grenade(%d+)$"));

        if v173 and math.max(#v168, 2) < v173 then
            child:Destroy();
        end;
    end;
end;

local function UpdateLossBonus() -- Line: 972
    -- upvalues: u8 (ref), LocalPlayer (copy), Income (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy)
    local LossBonus = u8.PlayerPanel.LossBonus;
    local Attribute = workspace:GetAttribute("Gamemode");
    local Attribute2 = LocalPlayer:GetAttribute("Team");
    local v174 = Attribute2 == "Counter-Terrorists" and "CTLossStreak" or (Attribute2 == "Terrorists" and "TLossStreak" or nil);
    LossBonus.Visible = (Attribute == "Bomb Defusal" and true or Attribute == "Hostage Rescue") and v174 ~= nil;

    if not LossBonus.Visible then
        return;
    end;

    local v175 = tonumber(workspace:GetAttribute(v174)) or 0;
    local v176 = Income.RoundLoss[workspace:GetAttribute("ServerGamemode")] or Income.RoundLoss.Competitive;

    for _, child in LossBonus.Pips:GetChildren() do
        local v177 = tonumber(child.Name);

        if v177 and child:IsA("Frame") then
            local v178;

            if v177 <= v175 + 1 then
                v178 = Color3_fromRGB_ret2;
            else
                v178 = Color3_fromRGB_ret3;
            end;

            child.BackgroundColor3 = v178;
        end;
    end;

    LossBonus.Amount.Text = "+$" .. tostring(v176[v175] or (v176[0] or 0)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function UpdateNextRoundMoney() -- Line: 998
    -- upvalues: LocalPlayer (copy), u8 (ref)
    local Attribute = LocalPlayer:GetAttribute("MinimumNextRoundIncome");
    local NextRoundMoney = u8.PlayerPanel.NextRoundMoney;
    local Attribute2 = workspace:GetAttribute("Gamemode");
    local v179;

    if Attribute2 == "Deathmatch" then
        v179 = false;
    else
        v179 = Attribute2 ~= "Tutorial";
    end;

    if v179 then
        if typeof(Attribute) == "number" then
            v179 = Attribute > 0;
        else
            v179 = false;
        end;
    end;

    NextRoundMoney.Visible = v179;

    if NextRoundMoney.Visible then
        NextRoundMoney.Text = "NEXT ROUND  $" .. tostring(Attribute):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end;
end;

local function SetAvatarBadge(p180: userdata, p181: userdata) -- Line: 1008
    -- upvalues: Participants (copy), GetBadgeIcon (copy)
    local Attribute = p181:GetAttribute("Team");
    local v182 = (Participants.IsBot(p181) or typeof(Attribute) ~= "string") and "" or GetBadgeIcon(p181, Attribute);
    p180.Image = v182;
    p180.Visible = v182 ~= "";
end;

local function UpdatePlayerPanel() -- Line: 1017
    -- upvalues: Profiler (copy), u8 (ref), LocalPlayer (copy), Participants (copy), GetBadgeIcon (copy), GetPreferenceColor (copy), UpdatePlayerLoadout (copy), UpdateLossBonus (copy)
    Profiler.mark("UI.BuyMenu.UpdatePlayerPanel");

    if not u8 then
        return;
    end;

    local Badge = u8.PlayerPanel.Avatar.Badge;
    local v183 = LocalPlayer;
    local Attribute = v183:GetAttribute("Team");
    local v184 = (Participants.IsBot(v183) or typeof(Attribute) ~= "string") and "" or GetBadgeIcon(v183, Attribute);
    Badge.Image = v184;
    Badge.Visible = v184 ~= "";
    u8.PlayerPanel.Accent.BackgroundColor3 = GetPreferenceColor();
    UpdatePlayerLoadout();
    UpdateLossBonus();
    local Attribute2 = LocalPlayer:GetAttribute("MinimumNextRoundIncome");
    local NextRoundMoney = u8.PlayerPanel.NextRoundMoney;
    local Attribute3 = workspace:GetAttribute("Gamemode");
    local v185;

    if Attribute3 == "Deathmatch" then
        v185 = false;
    else
        v185 = Attribute3 ~= "Tutorial";
    end;

    if v185 then
        if typeof(Attribute2) == "number" then
            v185 = Attribute2 > 0;
        else
            v185 = false;
        end;
    end;

    NextRoundMoney.Visible = v185;

    if NextRoundMoney.Visible then
        NextRoundMoney.Text = "NEXT ROUND  $" .. tostring(Attribute2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end;
end;

local function GetSlotWeapon(p186: userdata, p187: number) -- Line: 1033
    -- upvalues: HttpService (copy)
    local Attribute = p186:GetAttribute((`Slot{p187}`));

    if typeof(Attribute) ~= "string" or Attribute == "" then
        return nil;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute);

    if success and (typeof(result) == "table" and typeof(result.Weapon) == "string") then
        return result.Weapon;
    end;

    return nil;
end;

local function FillTeammateRow(p188: any, p189: userdata) -- Line: 1045
    -- upvalues: Participants (copy), GetPreferenceColor (copy), GetSlotWeapon (copy), NumberSlots (copy), ReplicatedStorage (copy), GetPlayerArmorState (copy)
    p188.PlayerName.Text = Participants.DisplayName(p189);
    local Money = p188.Money;
    local v190 = tonumber(p189:GetAttribute("Money")) or 0;
    Money.Text = "$" .. tostring(v190):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    local Money2 = p188.Money;
    local Attribute = workspace:GetAttribute("Gamemode");
    local v191;

    if Attribute == "Deathmatch" then
        v191 = false;
    else
        v191 = Attribute ~= "Tutorial";
    end;

    Money2.Visible = v191;
    local Accent = p188.Accent;
    local v192;

    if p189 then
        v192 = p189:GetAttribute("CompetitivePlayerColor");
    else
        v192 = p189;
    end;

    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" or typeof(v192) ~= "Color3" then
        v192 = GetPreferenceColor();
    end;

    Accent.BackgroundColor3 = v192;
    local Primary = p188.Loadout.Primary;
    local v193 = GetSlotWeapon(p189, NumberSlots.Primary);

    if v193 then
        local v194 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(v193) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(v193);

        if v194 then
            v193 = require(v194);
        else
            v193 = nil;
        end;
    end;

    local v195;

    if v193 then
        v195 = v193.ReverseIcon or v193.Icon;
    else
        v195 = nil;
    end;

    if Primary and Primary:IsA("ImageLabel") then
        Primary.Image = v195 or "";
        Primary.Visible = v195 ~= nil;
    end;

    local Secondary = p188.Loadout.Secondary;
    local v196 = GetSlotWeapon(p189, NumberSlots.Secondary);

    if v196 then
        local v197 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(v196) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(v196);

        if v197 then
            v196 = require(v197);
        else
            v196 = nil;
        end;
    end;

    local v198;

    if v196 then
        v198 = v196.ReverseIcon or v196.Icon;
    else
        v198 = nil;
    end;

    if Secondary and Secondary:IsA("ImageLabel") then
        Secondary.Image = v198 or "";
        Secondary.Visible = v198 ~= nil;
    end;

    local Armor = p188.Loadout.Armor;
    local v199 = GetPlayerArmorState(p189);
    local v200;

    if v199.Health <= 0 or v199.Type == "" then
        v200 = nil;
    else
        local Type = v199.Type;

        if Type then
            local v201 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Type) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Type);

            if v201 then
                Type = require(v201);
            else
                Type = nil;
            end;
        end;

        if Type then
            v200 = Type.ReverseIcon or Type.Icon;
        else
            v200 = nil;
        end;
    end;

    if Armor then
        if not Armor:IsA("ImageLabel") then
            return;
        end;

        Armor.Image = v200 or "";
        Armor.Visible = v200 ~= nil;
    end;
end;

local function GetTeammates() -- Line: 1056
    -- upvalues: LocalPlayer (copy), Participants (copy)
    local v202 = {};
    local Attribute = LocalPlayer:GetAttribute("Team");

    if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
        return v202;
    end;

    for _, v in Participants.GetAll() do
        if v ~= LocalPlayer and v:GetAttribute("Team") == Attribute then
            table.insert(v202, v);
        end;
    end;

    table.sort(v202, function(p203, p204) -- Line: 1067
        -- upvalues: Participants (ref)
        local v205 = tonumber(p203:GetAttribute("Money")) or 0;
        local v206 = tonumber(p204:GetAttribute("Money")) or 0;

        if v205 == v206 then
            return Participants.DisplayName(p203) < Participants.DisplayName(p204);
        end;

        return v206 < v205;
    end);

    return v202;
end;

local function RefreshTeamList(p207: boolean?) -- Line: 1082
    -- upvalues: Profiler (copy), u21 (ref), u8 (ref), u18 (ref), GetTeammates (copy), u19 (copy), Participants (copy), FillTeammateRow (copy), GetBadgeIcon (copy)
    Profiler.mark("UI.BuyMenu.RefreshTeamList");
    u21 = false;

    if not (u8 and u18) then
        return;
    end;

    local List = u8.Teammates.List;
    local v208 = GetTeammates();
    local v209 = {};

    for i, v in ipairs(v208) do
        v209[v] = true;
        local v210 = u19[v];
        local v211 = v210 == nil;

        if not v210 then
            v210 = u18:Clone();
            v210.Name = "Teammate";
            v210.Avatar.Image = Participants.HeadshotImage(v);
            v210.Visible = true;
            v210.Parent = List;
            u19[v] = v210;
        end;

        v210.LayoutOrder = i;
        FillTeammateRow(v210, v);

        if v211 or p207 then
            local Badge = v210.Avatar.Badge;
            local Attribute = v:GetAttribute("Team");
            local v212 = (Participants.IsBot(v) or typeof(Attribute) ~= "string") and "" or GetBadgeIcon(v, Attribute);
            Badge.Image = v212;
            Badge.Visible = v212 ~= "";
        end;
    end;

    for i, v in u19 do
        if not v209[i] then
            v:Destroy();
            u19[i] = nil;
        end;
    end;

    local Count = u8.Teammates.Header:FindFirstChild("Count");

    if Count then
        Count.Text = tostring(#v208);
    end;
end;

local function QueueTeamRefresh() -- Line: 1124
    -- upvalues: u21 (ref), u8 (ref), RefreshTeamList (copy)
    if u21 or not (u8 and u8.Visible) then
        return;
    end;

    u21 = true;
    task.defer(RefreshTeamList);
end;

local function ObserveTeamParticipants() -- Line: 1132
    -- upvalues: Participants (copy), u20 (copy), u3 (copy), u21 (ref), u8 (ref), RefreshTeamList (copy)
    Participants.Observe(function(p213: userdata) -- Line: 1133
        -- upvalues: u20 (ref), u3 (ref), u21 (ref), u8 (ref), RefreshTeamList (ref)
        if u20[p213] then
            u20[p213]:Disconnect();
        end;

        u20[p213] = p213.AttributeChanged:Connect(function(p214: string) -- Line: 1137
            -- upvalues: u3 (ref), u21 (ref), u8 (ref), RefreshTeamList (ref)
            if u3[p214] and (not u21 and u8) then
                if not u8.Visible then
                    return;
                end;

                u21 = true;
                task.defer(RefreshTeamList);
            end;
        end);

        if not u21 and u8 then
            if not u8.Visible then
                return;
            end;

            u21 = true;
            task.defer(RefreshTeamList);
        end;
    end, function(p215: userdata) -- Line: 1143
        -- upvalues: u20 (ref), u21 (ref), u8 (ref), RefreshTeamList (ref)
        local v216 = u20[p215];

        if v216 then
            v216:Disconnect();
            u20[p215] = nil;
        end;

        if not u21 and u8 then
            if not u8.Visible then
                return;
            end;

            u21 = true;
            task.defer(RefreshTeamList);
        end;
    end);
end;

function u1.purchase(p217: string, p218: string?, p219: boolean) -- Line: 1156
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy), GetDisplayCost (copy), IsEquipmentPurchaseBlockedForLocalPlayer (copy), SurvivalDowned (copy), TutorialPurchaseLock (copy), IsInBuyArea (copy), GameState (copy), Grenades (copy), InventoryController (copy), NumberSlots (copy), u6 (copy), IsSurvivalMode (copy), Router (copy), SurvivalVoiceController (copy), Remotes (copy)
    local v220 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p217) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(p217);
    local v221;

    if v220 then
        v221 = require(v220);
    else
        v221 = nil;
    end;

    if not v221 then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("Money");
    local v222 = GetDisplayCost(p217, v221);
    local Attribute2 = workspace:GetAttribute("Gamemode");

    if p219 and IsEquipmentPurchaseBlockedForLocalPlayer(p217) then
        return;
    end;

    if SurvivalDowned.IsDowned(LocalPlayer) then
        return;
    end;

    if not TutorialPurchaseLock.isPurchaseAllowed(LocalPlayer, p217) then
        return;
    end;

    if not IsInBuyArea(LocalPlayer) then
        return;
    end;

    local v223 = (Attribute2 == "Deathmatch" or (Attribute2 == "Tutorial" or GameState.GetState() == "Warmup")) and 0 or v222;
    local v224 = (not p219 and Grenades[p217] ~= nil and true or false) and InventoryController.getCurrentInventory();

    if v224 then
        local v225 = v224[NumberSlots.Grenade];

        if v225 and #v225._items >= v225._settings._strict_slot_space then
            return;
        end;
    end;

    if not p219 and (LocalPlayer:GetAttribute("BuyMenu") and (Attribute2 == "Hostage Rescue" or Attribute2 == "Bomb Defusal")) then
        local CurrentInventory = InventoryController.getCurrentInventory();
        local v226 = NumberSlots[v221.Slot];

        if CurrentInventory then
            CurrentInventory = CurrentInventory[v226];
        end;

        if CurrentInventory then
            CurrentInventory = CurrentInventory._items[1];
        end;

        if CurrentInventory and table.find(u6, CurrentInventory.Identifier) then
            local Name = CurrentInventory.Name;
            local v227 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Name) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Name);
            local v228;

            if v227 then
                v228 = require(v227);
            else
                v228 = nil;
            end;

            if v228 then
                local Cost = v228.Cost;
                v223 = v222 - (CurrentInventory.Name == "Molotov" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" and 500 or Cost);
            end;
        end;
    end;

    if Attribute and v223 <= Attribute then
        if IsSurvivalMode() then
            Router.broadcastRouter("RunStoreSound", "Successful Purchase");
            local v229;

            if p219 then
                v229 = nil;
            else
                v229 = v221.Type;
            end;

            SurvivalVoiceController.OnPurchase(p217, p219, v229);
        else
            Router.broadcastRouter("RunInterfaceSound", "Successful Buy Menu Purchase");
        end;

        Remotes.Inventory.BuyMenuPurchase.Send({
            Equipment = p219,
            Name = p217,
            Path = p218 or ""
        });
    end;
end;

function u1.createTemplate(u230: any, u231: any, u232: boolean, u233: string?) -- Line: 1239
    -- upvalues: ReplicatedStorage (copy), GetSlotLook (copy), GetDisplayCost (copy), ApplyItemNameLabel (copy), LocalPlayer (copy), IsEquipmentPurchaseBlockedForLocalPlayer (copy), Color3_fromRGB_ret (copy), GetPreferenceColor (copy), Color3_new_ret (copy), UpdateTemplateOwnership (copy), InventoryController (copy), Router (copy), SetSlotHighlight (copy), ShowWeaponInfoFrame (copy), u4 (copy), u8 (ref), WeaponStats (copy), GuiService (copy), u1 (copy), IsInBuyArea (copy), Remotes (copy), u17 (copy), QueryRoundPurchasedInventoryItem (copy), QueryInventoryItem (copy)
    local Name = u231.Name;
    local v234 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Name) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Name);
    local v235;

    if v234 then
        v235 = require(v234);
    else
        v235 = nil;
    end;

    if not v235 then
        u230:SetAttribute("IsEquipment", nil);
        u230:SetAttribute("Weapon", nil);
        u230:SetAttribute("OwnedMax", nil);
        u230.Visible = false;

        return;
    end;

    GetSlotLook(u230);
    local v236 = GetDisplayCost(u231.Name, v235);
    u230.Icon.Image = v235.ReverseIcon or v235.Icon;
    u230.Cost.Text = "$" .. tostring(v236):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    local Cost = u230.Cost;
    local Attribute = workspace:GetAttribute("Gamemode");
    local v237;

    if Attribute == "Deathmatch" then
        v237 = false;
    else
        v237 = Attribute ~= "Tutorial";
    end;

    Cost.Visible = v237;
    u230.LayoutOrder = tonumber(u230.Name);
    ApplyItemNameLabel(u230.ItemName, u231.Name, u231.NameTag);
    u230.Visible = true;
    local v238 = tonumber(LocalPlayer:GetAttribute("Money")) or 0;
    local v239;

    if u232 then
        v239 = IsEquipmentPurchaseBlockedForLocalPlayer(u231.Name);
    else
        v239 = u232;
    end;

    local v240 = (v238 < v236 or v239) and Color3_fromRGB_ret or GetPreferenceColor();
    local v241 = v240 ~= Color3_fromRGB_ret;
    u230.Icon.ImageColor3 = v240;
    u230.IconGlow.ImageColor3 = v240;
    local v242;

    if v241 then
        v242 = Color3_new_ret;
    else
        v242 = Color3_fromRGB_ret;
    end;

    u230.ItemName.TextColor3 = v242;
    local v243;

    if v241 then
        v243 = Color3_new_ret;
    else
        v243 = Color3_fromRGB_ret;
    end;

    u230.Cost.TextColor3 = v243;
    local v244 = u230.Cost:FindFirstChildOfClass("UIGradient");

    if v244 then
        v244.Enabled = v241;
    end;

    u230:SetAttribute("Weapon", u231.Name);
    u230:SetAttribute("IsEquipment", u232);
    u230:SetAttribute("InventoryItemId", u231._id);
    UpdateTemplateOwnership(u230, u231.Name, u232, InventoryController.getCurrentInventory());

    local function hoverTemplate() -- Line: 1279
        -- upvalues: Router (ref), SetSlotHighlight (ref), u230 (copy), ShowWeaponInfoFrame (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        SetSlotHighlight(u230, 1.08, true);
        ShowWeaponInfoFrame(u230);
    end;

    u4:Add(u230.MouseEnter:Connect(hoverTemplate));
    u4:Add(u230.SelectionGained:Connect(hoverTemplate));
    u4:Add(u230.MouseLeave:Connect(function() -- Line: 1289
        -- upvalues: SetSlotHighlight (ref), u230 (copy), u8 (ref), WeaponStats (ref)
        SetSlotHighlight(u230, 1, false);
        local v245;

        if u8 then
            v245 = u8:FindFirstChild("WeaponStats");
        else
            v245 = nil;
        end;

        if v245 then
            WeaponStats.Clear(v245);
            v245.Visible = true;
        end;
    end));
    u4:Add(u230.SelectionLost:Connect(function() -- Line: 1294
        -- upvalues: SetSlotHighlight (ref), u230 (copy), GuiService (ref), u8 (ref), WeaponStats (ref)
        SetSlotHighlight(u230, 1, false);
        local SelectedObject = GuiService.SelectedObject;

        if not SelectedObject or SelectedObject:GetAttribute("Weapon") == nil then
            local v246;

            if u8 then
                v246 = u8:FindFirstChild("WeaponStats");
            else
                v246 = nil;
            end;

            if v246 then
                WeaponStats.Clear(v246);
                v246.Visible = true;
            end;
        end;
    end));
    u4:Add(u230.MouseButton1Down:Connect(function() -- Line: 1304
        -- upvalues: SetSlotHighlight (ref), u230 (copy)
        SetSlotHighlight(u230, 0.96, true);
    end));
    u4:Add(u230.MouseButton1Up:Connect(function() -- Line: 1307
        -- upvalues: SetSlotHighlight (ref), u230 (copy)
        SetSlotHighlight(u230, 1.08, true);
    end));
    u4:Add(u230.MouseButton1Click:Connect(function() -- Line: 1312
        -- upvalues: u1 (ref), u231 (copy), u233 (copy), u232 (copy)
        u1.purchase(u231.Name, u233, u232);
    end));
    u4:Add(u230.Return.MouseButton1Click:Connect(function() -- Line: 1317
        -- upvalues: u232 (copy), IsInBuyArea (ref), LocalPlayer (ref), Remotes (ref), u231 (copy), InventoryController (ref), u17 (ref), QueryRoundPurchasedInventoryItem (ref), QueryInventoryItem (ref)
        if u232 then
            if IsInBuyArea(LocalPlayer) then
                Remotes.Inventory.ReturnBuyMenuPurchase.Send({
                    Equipment = true,
                    Identifier = u231.Name
                });
            end;

            return;
        end;

        local CurrentInventory = InventoryController.getCurrentInventory();

        if not CurrentInventory then
            return;
        end;

        local Name2 = u231.Name;
        local v247 = u17[LocalPlayer:GetAttribute("Team")];
        local v248;

        if v247 then
            v248 = table.find(v247, Name2) ~= nil;
        else
            v248 = false;
        end;

        local v249;

        if v248 then
            v249 = not CurrentInventory and true or not QueryRoundPurchasedInventoryItem(CurrentInventory, Name2);
        else
            v249 = false;
        end;

        if v249 then
            return;
        end;

        local Name3 = u231.Name;
        local v250 = QueryRoundPurchasedInventoryItem(CurrentInventory, Name3) or QueryInventoryItem(CurrentInventory, Name3);

        if v250 and IsInBuyArea(LocalPlayer) then
            Remotes.Inventory.ReturnBuyMenuPurchase.Send({
                Equipment = false,
                Identifier = v250.Identifier
            });
        end;
    end));
end;

function u1.setupTemplate(p251: any, p252: string) -- Line: 1351
    -- upvalues: Router (copy), LocalPlayer (copy), SurvivalBuyRules (copy), u1 (copy)
    local v253 = Router.broadcastRouter("GetEquippedInventoryItem", LocalPlayer, p252);

    if v253 and (v253.Name and SurvivalBuyRules.IsSold(v253.Name)) then
        u1.createTemplate(p251, v253, false, p252);

        return;
    end;

    p251:SetAttribute("IsEquipment", nil);
    p251:SetAttribute("Weapon", nil);
    p251:SetAttribute("OwnedMax", nil);
    p251.Visible = false;
end;

function u1.updateBuyMenuTemplate(p254, p255) -- Line: 1361
    -- upvalues: u127 (copy), StopTutorialPulse (copy), ReplicatedStorage (copy), GetDisplayCost (copy), LocalPlayer (copy), IsEquipmentPurchaseBlockedForLocalPlayer (copy), TutorialPurchaseLock (copy), Color3_fromRGB_ret (copy), GetPreferenceColor (copy), Color3_new_ret (copy), SyncTutorialPulse (copy), GetInventoryItemCount (copy), UpdateTemplateOwnership (copy)
    local v256 = p255:GetAttribute("IsEquipment") == true;
    local Attribute = p255:GetAttribute("Weapon");

    if not Attribute then
        local Icon = p255.Icon;
        local _ = u127[Icon];
        StopTutorialPulse(Icon, nil);

        return;
    end;

    local v257 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Attribute) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Attribute);
    local v258;

    if v257 then
        v258 = require(v257);
    else
        v258 = nil;
    end;

    local v259 = nil;

    if v258 then
        local v260 = GetDisplayCost(Attribute, v258);
        p255.Cost.Text = "$" .. tostring(v260):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        local Attribute2 = LocalPlayer:GetAttribute("Money");
        local v261;

        if v256 then
            v261 = IsEquipmentPurchaseBlockedForLocalPlayer(Attribute);
        else
            v261 = v256;
        end;

        local v262 = not TutorialPurchaseLock.isPurchaseAllowed(LocalPlayer, Attribute);

        if Attribute2 then
            v259 = (Attribute2 < v260 or (v261 or v262)) and Color3_fromRGB_ret or GetPreferenceColor();
            local v263 = v259 ~= Color3_fromRGB_ret;
            p255.Icon.ImageColor3 = v259;
            p255.IconGlow.ImageColor3 = v259;
            local v264;

            if v263 then
                v264 = Color3_new_ret;
            else
                v264 = Color3_fromRGB_ret;
            end;

            p255.ItemName.TextColor3 = v264;
            local v265;

            if v263 then
                v265 = Color3_new_ret;
            else
                v265 = Color3_fromRGB_ret;
            end;

            p255.Cost.TextColor3 = v265;
            local v266 = p255.Cost:FindFirstChildOfClass("UIGradient");

            if v266 then
                v266.Enabled = v263;
            end;
        end;
    end;

    local RequiredItems = TutorialPurchaseLock.getRequiredItems(LocalPlayer);
    local v267;

    if RequiredItems and table.find(RequiredItems, Attribute) then
        local v268;

        if p254 then
            v268 = GetInventoryItemCount(p254, Attribute) > 0;
        else
            v268 = p254;
        end;

        v267 = not v268;
    else
        v267 = false;
    end;

    SyncTutorialPulse(p255, v259, v267);

    if p255.Visible then
        UpdateTemplateOwnership(p255, Attribute, v256, p254);
    end;
end;

local function getDroppedCategory(p269) -- Line: 1402
    local Slot = p269.Slot;

    if Slot == "Grenade" then
        return "Grenades";
    end;

    if Slot == "Secondary" then
        return "Pistols";
    end;

    if Slot ~= "Primary" then
        return nil;
    end;

    local Type = p269.Type;

    return (Type == "SMG" or Type == "Heavy") and "Mid Tier" or "Rifles";
end;

local function GetRootPart() -- Line: 1420
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    return Character;
end;

local function isWithinPickupRange(p270: userdata) -- Line: 1425
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if p270 then
        p270 = p270.PrimaryPart;
    end;

    if Character and p270 then
        return (Character.Position - p270.Position).Magnitude <= 45;
    end;

    return false;
end;

local u271 = {
    Pistols = 2,
    ["Mid Tier"] = 1,
    Rifles = 1,
    Grenades = 4
};

local function tryPickupDroppedWeapon(p272: userdata, p273: string) -- Line: 1441
    -- upvalues: LocalPlayer (copy), u271 (copy), InventoryController (copy), SurvivalBuyRules (copy), GetWeaponProperties (copy), NumberSlots (copy), Remotes (copy), GetCharacterVelocity (copy), CharacterResolver (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v274;

    if p272 then
        v274 = p272.PrimaryPart;
    else
        v274 = p272;
    end;

    local v275;

    if Character and v274 then
        v275 = (Character.Position - v274.Position).Magnitude <= 45;
    else
        v275 = false;
    end;

    if not v275 then
        return;
    end;

    if not p272:GetAttribute("CanPickup") then
        return;
    end;

    local v276 = u271[p273];

    if not v276 then
        return;
    end;

    local CurrentInventory = InventoryController.getCurrentInventory();

    if not CurrentInventory then
        return;
    end;

    local v277 = CurrentInventory[v276];

    if not v277 then
        return;
    end;

    if p273 == "Grenades" then
        local Attribute = p272:GetAttribute("Weapon");

        if #v277._items >= v277._settings._strict_slot_space then
            return;
        end;

        local GrenadeLimit = SurvivalBuyRules.GetGrenadeLimit(Attribute);

        if GrenadeLimit then
            local v278 = 0;

            for _, v in ipairs(v277._items) do
                if v.Name == Attribute then
                    v278 = v278 + 1;
                end;
            end;

            if GrenadeLimit <= v278 then
                return;
            end;
        end;
    elseif #v277._items >= v277._settings._strict_slot_space then
        local CurrentEquipped = InventoryController.getCurrentEquipped();
        local v279 = false;

        if CurrentEquipped then
            local v280 = GetWeaponProperties(CurrentEquipped.Name);

            if v280 and (NumberSlots[v280.Slot] == v276 and CurrentEquipped.drop) then
                CurrentEquipped:drop();
                v279 = true;
            end;
        end;

        if not v279 then
            local v281 = v277._items[1];

            if not (v281 and (v281.Properties and v281.Properties.Droppable)) then
                return;
            end;

            if CurrentEquipped and CurrentEquipped.Identifier == v281.Identifier then
                CurrentEquipped:unequip();
            end;

            Remotes.Inventory.DropWeapon.Send({
                CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
                Direction = workspace.CurrentCamera.CFrame.LookVector,
                Identifier = v281.Identifier
            });
        end;
    end;

    Remotes.Inventory.PickupWeapon.Send({
        AllowAutoEquip = true,
        Identity = p272.Name
    });
end;

local function SetDroppedCardDimmed(p282: any, p283: boolean) -- Line: 1519
    if p282:GetAttribute("OutOfRange") == true == p283 then
        return;
    end;

    p282:SetAttribute("OutOfRange", p283);
    local v284 = p283 and 0.6 or 0;
    p282.Icon.ImageTransparency = v284;
    p282.ItemName.TextTransparency = v284;
    p282.Owner.TextTransparency = v284;
end;

local function updateDroppedTemplateRangeStates() -- Line: 1530
    -- upvalues: Profiler (copy), u23 (copy), LocalPlayer (copy)
    Profiler.mark("UI.BuyMenu.UpdateDroppedTemplateRangeStates");

    for i, v in u23 do
        local Card = v.Card;
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        local v285;

        if i then
            v285 = i.PrimaryPart;
        else
            v285 = i;
        end;

        local v286;

        if Character and v285 then
            v286 = (Character.Position - v285.Position).Magnitude <= 45;
        else
            v286 = false;
        end;

        local v287 = not v286;

        if Card:GetAttribute("OutOfRange") == true ~= v287 then
            Card:SetAttribute("OutOfRange", v287);
            local v288 = v287 and 0.6 or 0;
            Card.Icon.ImageTransparency = v288;
            Card.ItemName.TextTransparency = v288;
            Card.Owner.TextTransparency = v288;
        end;
    end;
end;

local function PaintDroppedCard(p289: table) -- Line: 1537
    -- upvalues: GetPreferenceColor (copy), Participants (copy)
    p289.Card.Icon.ImageColor3 = GetPreferenceColor();
    local v290 = Participants.FromKey((p289.Model:GetAttribute("DroppedBy")));
    local Attribute = p289.Model:GetAttribute("DroppedByName");
    local Owner = p289.Card.Owner;
    local v291;

    if typeof(Attribute) == "string" then
        v291 = Attribute ~= "";
    else
        v291 = false;
    end;

    Owner.Visible = v291;
    p289.Card.Owner.Text = not p289.Card.Owner.Visible and "" or Attribute;
    local Owner2 = p289.Card.Owner;

    if v290 then
        v290 = v290:GetAttribute("CompetitivePlayerColor");
    end;

    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" or typeof(v290) ~= "Color3" then
        v290 = GetPreferenceColor();
    end;

    Owner2.TextColor3 = v290;
end;

local function HidesDroppedWeapons() -- Line: 1549
    -- upvalues: IsTutorialMode (copy), IsSurvivalMode (copy)
    return workspace:GetAttribute("Gamemode") == "Deathmatch" and true or (IsTutorialMode() or IsSurvivalMode());
end;

local function onWeaponDropped(u292: userdata) -- Line: 1553
    -- upvalues: IsTutorialMode (copy), IsSurvivalMode (copy), u23 (copy), u22 (ref), u24 (ref), LocalPlayer (copy), GetWeaponProperties (copy), u25 (ref), ApplyItemNameLabel (copy), u8 (ref), PaintDroppedCard (copy), Router (copy), SetSlotHighlight (copy), tryPickupDroppedWeapon (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" and true or (IsTutorialMode() or IsSurvivalMode()) then
        return;
    end;

    if u23[u292] or (not u22 or u24 >= 24) then
        return;
    end;

    local Attribute = u292:GetAttribute("Weapon");

    if not Attribute then
        return;
    end;

    if u292:GetAttribute("DroppedByTeam") ~= LocalPlayer:GetAttribute("Team") then
        return;
    end;

    local v293 = GetWeaponProperties(Attribute);
    local u294;

    if v293 then
        local Slot = v293.Slot;

        if Slot == "Grenade" then
            u294 = "Grenades";
        elseif Slot == "Secondary" then
            u294 = "Pistols";
        elseif Slot == "Primary" then
            local Type = v293.Type;
            u294 = (Type == "SMG" or Type == "Heavy") and "Mid Tier" or "Rifles";
        else
            u294 = nil;
        end;
    else
        u294 = v293;
    end;

    if not u294 then
        return;
    end;

    local u295 = u22:Clone();
    u25 = u25 + 1;
    u24 = u24 + 1;
    u295.Name = u292.Name;
    u295.LayoutOrder = u25;
    u295.Icon.Image = v293.ReverseIcon or v293.Icon;
    ApplyItemNameLabel(u295.ItemName, Attribute, u292:GetAttribute("NameTag"));
    u295.Visible = true;
    u295.Parent = u8.Dropped.Container;
    local v296 = {
        Card = u295,
        Category = u294,
        Model = u292
    };
    u23[u292] = v296;
    PaintDroppedCard(v296);
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v297;

    if u292 then
        v297 = u292.PrimaryPart;
    else
        v297 = u292;
    end;

    local v298;

    if Character and v297 then
        v298 = (Character.Position - v297.Position).Magnitude <= 45;
    else
        v298 = false;
    end;

    local v299 = not v298;

    if u295:GetAttribute("OutOfRange") == true ~= v299 then
        u295:SetAttribute("OutOfRange", v299);
        local v300 = v299 and 0.6 or 0;
        u295.Icon.ImageTransparency = v300;
        u295.ItemName.TextTransparency = v300;
        u295.Owner.TextTransparency = v300;
    end;

    u295.MouseEnter:Connect(function() -- Line: 1596
        -- upvalues: Router (ref), SetSlotHighlight (ref), u295 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        SetSlotHighlight(u295, 1.08, true);
    end);
    u295.MouseLeave:Connect(function() -- Line: 1600
        -- upvalues: SetSlotHighlight (ref), u295 (copy)
        SetSlotHighlight(u295, 1, false);
    end);
    u295.MouseButton1Click:Connect(function() -- Line: 1603
        -- upvalues: u292 (copy), LocalPlayer (ref), Router (ref), tryPickupDroppedWeapon (ref), u294 (copy)
        if u292.Parent and u292:GetAttribute("CanPickup") then
            local v301 = u292;
            local Character2 = LocalPlayer.Character;

            if Character2 then
                Character2 = Character2:FindFirstChild("HumanoidRootPart");
            end;

            if v301 then
                v301 = v301.PrimaryPart;
            end;

            local v302;

            if Character2 and v301 then
                v302 = (Character2.Position - v301.Position).Magnitude <= 45;
            else
                v302 = false;
            end;

            if v302 then
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                tryPickupDroppedWeapon(u292, u294);
            end;
        end;
    end);
end;

local function onWeaponDropRemoved(p303: userdata) -- Line: 1611
    -- upvalues: u23 (copy), u24 (ref)
    local v304 = u23[p303];

    if not v304 then
        return;
    end;

    u23[p303] = nil;
    u24 = u24 - 1;
    v304.Card:Destroy();
end;

local function updateDroppedFrameVisibility() -- Line: 1621
    -- upvalues: u8 (ref), IsTutorialMode (copy), IsSurvivalMode (copy)
    if not u8 then
        return;
    end;

    u8.Dropped.Visible = not (workspace:GetAttribute("Gamemode") == "Deathmatch" and true or (IsTutorialMode() or IsSurvivalMode()));
end;

local function cleanupAllDroppedEntries() -- Line: 1628
    -- upvalues: u23 (copy), u24 (ref)
    for _, v in u23 do
        v.Card:Destroy();
    end;

    table.clear(u23);
    u24 = 0;
end;

local function updateBuyMenuHeartbeat(p305: number) -- Line: 1639
    -- upvalues: Profiler (copy), u5 (copy), u8 (ref), IsInBuyArea (copy), LocalPlayer (copy), u1 (copy), IsTutorialMode (copy), InventoryController (copy), TutorialPurchaseLock (copy), GetInventoryItemCount (copy), u7 (ref), updateDroppedTemplateRangeStates (copy)
    Profiler.mark("UI.BuyMenu.Heartbeat");
    local Position = u5:getPosition();
    local math_round_ret = math.round(Position);
    local v306 = tostring(math_round_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    u8.PlayerPanel.Money.Text = "$" .. v306;
    u5:update(p305);

    if u8.Visible and not IsInBuyArea(LocalPlayer) then
        local Attribute = workspace:GetAttribute("Gamemode");

        if Attribute == "Bomb Defusal" or Attribute == "Hostage Rescue" then
            u1.closeFrame();

            return;
        end;
    end;

    if u8.Visible and IsTutorialMode() then
        local CurrentInventory = InventoryController.getCurrentInventory();

        if TutorialPurchaseLock.isWaitingOnPurchase(LocalPlayer, function(p307: string) -- Line: 850
            -- upvalues: CurrentInventory (copy), GetInventoryItemCount (ref)
            if CurrentInventory then
                return GetInventoryItemCount(CurrentInventory, p307) > 0;
            end;

            return false;
        end) then
            u7 = true;
        elseif u7 then
            u7 = false;
            u1.closeFrame();

            return;
        end;
    end;

    updateDroppedTemplateRangeStates();
end;

local function startBuyMenuUpdate() -- Line: 1672
    -- upvalues: u26 (ref), RunServiceController (copy), updateBuyMenuHeartbeat (copy)
    if u26 then
        return;
    end;

    u26 = RunServiceController.BindToHeartbeat("UI.BuyMenu.Update", updateBuyMenuHeartbeat);
    updateBuyMenuHeartbeat(0);
end;

local function stopBuyMenuUpdate() -- Line: 1681
    -- upvalues: u26 (ref)
    if u26 then
        u26:Disconnect();
        u26 = nil;
    end;
end;

local function NotifyTutorial(p308: string) -- Line: 1692
    -- upvalues: IsTutorialMode (copy), Remotes (copy)
    if not IsTutorialMode() then
        return;
    end;

    Remotes.Tutorial.ClientEvent.Send(p308);
end;

function u1.openFrame() -- Line: 1699
    -- upvalues: EndScreenController (copy), LocalPlayer (copy), IsInBuyArea (copy), TutorialPurchaseLock (copy), SurvivalDowned (copy), u8 (ref), CameraController (copy), u9 (ref), u26 (ref), RunServiceController (copy), updateBuyMenuHeartbeat (copy), WeaponStats (copy), UpdatePlayerPanel (copy), RefreshTeamList (copy), IsTutorialMode (copy), Remotes (copy)
    if EndScreenController.IsActive() then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("BuyMenu");

    if not IsInBuyArea(LocalPlayer) then
        return;
    end;

    if TutorialPurchaseLock.isBuyMenuLocked(LocalPlayer) then
        return;
    end;

    if SurvivalDowned.IsDowned(LocalPlayer) then
        return;
    end;

    if not Attribute or u8.Visible then
        return;
    end;

    CameraController.setForceLockOverride("BuyMenu", true);
    CameraController.setPerspective(true, true);
    u9.Gameplay.Bottom.Health.Visible = false;
    u9.Gameplay.Bottom.Middle.Visible = false;
    u9.Gameplay.Bottom.Armor.Visible = false;
    u9.Gameplay.Bottom.Money.Visible = false;
    u9.Gameplay.Bottom.Ammo.Visible = false;
    u8.Visible = true;

    if not u26 then
        u26 = RunServiceController.BindToHeartbeat("UI.BuyMenu.Update", updateBuyMenuHeartbeat);
        updateBuyMenuHeartbeat(0);
    end;

    local v309;

    if u8 then
        v309 = u8:FindFirstChild("WeaponStats");
    else
        v309 = nil;
    end;

    if v309 then
        WeaponStats.Clear(v309);
        v309.Visible = true;
    end;

    UpdatePlayerPanel();
    RefreshTeamList(true);

    if not IsTutorialMode() then
        return;
    end;

    Remotes.Tutorial.ClientEvent.Send("OpenedBuyMenu");
end;

function u1.closeFrame() -- Line: 1740
    -- upvalues: u8 (ref), CameraController (copy), u9 (ref), GetPlayerArmorState (copy), LocalPlayer (copy), u26 (ref), WeaponStats (copy), u7 (ref), IsTutorialMode (copy), Remotes (copy)
    if not u8.Visible then
        return;
    end;

    CameraController.setForceLockOverride("BuyMenu", false);
    CameraController.setPerspective(true, false);
    u9.Gameplay.Bottom.Health.Visible = true;
    u9.Gameplay.Bottom.Middle.Visible = true;
    u9.Gameplay.Bottom.Armor.Visible = GetPlayerArmorState(LocalPlayer).Health > 0;
    u9.Gameplay.Bottom.Money.Visible = true;
    u9.Gameplay.Bottom.Ammo.Visible = true;
    u8.Visible = false;

    if u26 then
        u26:Disconnect();
        u26 = nil;
    end;

    local v310;

    if u8 then
        v310 = u8:FindFirstChild("WeaponStats");
    else
        v310 = nil;
    end;

    if v310 then
        WeaponStats.Clear(v310);
        v310.Visible = true;
    end;

    u7 = false;

    if not IsTutorialMode() then
        return;
    end;

    Remotes.Tutorial.ClientEvent.Send("ClosedBuyMenu");
end;

function u1.toggleFrame() -- Line: 1761
    -- upvalues: EndScreenController (copy), LocalPlayer (copy), u8 (ref), u1 (copy), InventoryController (copy), TutorialPurchaseLock (copy), GetInventoryItemCount (copy)
    if EndScreenController.IsActive() then
        return;
    end;

    if LocalPlayer:GetAttribute("BuyMenu") and not u8.Visible then
        u1.openFrame();

        return;
    end;

    if u8.Visible then
        local CurrentInventory = InventoryController.getCurrentInventory();

        if TutorialPurchaseLock.isWaitingOnPurchase(LocalPlayer, function(p311: string) -- Line: 850
            -- upvalues: CurrentInventory (copy), GetInventoryItemCount (ref)
            if CurrentInventory then
                return GetInventoryItemCount(CurrentInventory, p311) > 0;
            end;

            return false;
        end) then
            return;
        end;

        u1.closeFrame();
    end;
end;

function u1.characterAdded(p312: userdata) -- Line: 1782
    -- upvalues: WaitForAttribute (copy), LocalPlayer (copy), u4 (copy), setupBuyMenuTemplates (copy)
    if not WaitForAttribute(LocalPlayer, "Money") then
        return;
    end;

    u4:Cleanup();
    setupBuyMenuTemplates();
end;

local function TakeDesignPrototypes() -- Line: 1801
    -- upvalues: u8 (ref), u18 (ref), u22 (ref)
    local List = u8.Teammates.List;
    u18 = List:FindFirstChild("TeammateTemplate");

    for _, child in List:GetChildren() do
        if child.Name == "Teammate" then
            child:Destroy();
        end;
    end;

    if u18 then
        u18.Parent = nil;
    end;

    for _, child in u8.Dropped.Container:GetChildren() do
        if child.Name == "Template" then
            if u22 then
                child:Destroy();
            else
                u22 = child;
                child.Parent = nil;
            end;
        end;
    end;
end;

local function CollectSlots() -- Line: 1826
    -- upvalues: u10 (copy), u2 (copy), u8 (ref)
    table.clear(u10);

    local function collect(p313: userdata?, p314: string) -- Line: 1828
        -- upvalues: u10 (ref)
        if p313 then
            p313 = p313:FindFirstChild("Items");
        end;

        if not p313 then
            return;
        end;

        for _, child in p313:GetChildren() do
            if child:IsA("TextButton") and tonumber(child.Name) then
                table.insert(u10, {
                    Button = child,
                    Category = p314
                });
            end;
        end;
    end;

    for _, v in u2 do
        collect(u8.Shop:FindFirstChild(v), v);
    end;

    collect(u8.Grenades, "Grenades");
end;

function u1.Initialize(p315, p316) -- Line: 1845
    -- upvalues: u9 (ref), u8 (ref), TakeDesignPrototypes (copy), CollectSlots (copy), Participants (copy), LocalPlayer (copy), UpdateBuyMenuTimerText (copy), UpdatePlayerPanel (copy), WeaponStats (copy), InventoryController (copy), u10 (copy), u1 (copy), u4 (copy), setupBuyMenuTemplates (copy), u20 (copy), u3 (copy), u21 (ref), RefreshTeamList (copy), Observers (copy), u23 (copy), u24 (ref), IsTutorialMode (copy), IsSurvivalMode (copy), UpdateLossBonus (copy), Remotes (copy), u6 (copy), RemoveFromArray (copy), UpdateNextRoundMoney (copy), u5 (copy), UpdatePlayerLoadout (copy), SurvivalDowned (copy), GameState (copy), SurvivalState (copy), DataController (copy), GetPreferenceColor (copy), PaintDroppedCard (copy), onWeaponDropped (copy)
    u9 = p315;
    u8 = p316;
    TakeDesignPrototypes();
    CollectSlots();
    u8.PlayerPanel.Avatar.Image = Participants.HeadshotImage(LocalPlayer);
    UpdateBuyMenuTimerText();
    UpdatePlayerPanel();
    local v317;

    if u8 then
        v317 = u8:FindFirstChild("WeaponStats");
    else
        v317 = nil;
    end;

    if v317 then
        WeaponStats.Clear(v317);
        v317.Visible = true;
    end;

    local function refreshBuyMenuTemplates() -- Line: 1855
        -- upvalues: InventoryController (ref), u10 (ref), u1 (ref)
        local CurrentInventory = InventoryController.getCurrentInventory();

        for _, v in ipairs(u10) do
            u1.updateBuyMenuTemplate(CurrentInventory, v.Button);
        end;
    end;

    local function rebuildBuyMenuTemplates() -- Line: 1862
        -- upvalues: u4 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy)
        u4:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
    end;

    Participants.Observe(function(p318: userdata) -- Line: 1133
        -- upvalues: u20 (ref), u3 (ref), u21 (ref), u8 (ref), RefreshTeamList (ref)
        if u20[p318] then
            u20[p318]:Disconnect();
        end;

        u20[p318] = p318.AttributeChanged:Connect(function(p319: string) -- Line: 1137
            -- upvalues: u3 (ref), u21 (ref), u8 (ref), RefreshTeamList (ref)
            if u3[p319] and (not u21 and u8) then
                if not u8.Visible then
                    return;
                end;

                u21 = true;
                task.defer(RefreshTeamList);
            end;
        end);

        if not u21 and u8 then
            if not u8.Visible then
                return;
            end;

            u21 = true;
            task.defer(RefreshTeamList);
        end;
    end, function(p320: userdata) -- Line: 1143
        -- upvalues: u20 (ref), u21 (ref), u8 (ref), RefreshTeamList (ref)
        local v321 = u20[p320];

        if v321 then
            v321:Disconnect();
            u20[p320] = nil;
        end;

        if not u21 and u8 then
            if not u8.Visible then
                return;
            end;

            u21 = true;
            task.defer(RefreshTeamList);
        end;
    end);
    Observers.observeAttribute(LocalPlayer, "Team", function() -- Line: 1871
        -- upvalues: u23 (ref), u24 (ref), u4 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy), UpdatePlayerPanel (ref)
        for _, v in u23 do
            v.Card:Destroy();
        end;

        table.clear(u23);
        u24 = 0;
        u4:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
        UpdatePlayerPanel();
    end);
    Observers.observeAttribute(workspace, "Gamemode", function() -- Line: 1877
        -- upvalues: u8 (ref), IsTutorialMode (ref), IsSurvivalMode (ref), u23 (ref), u24 (ref), u4 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy), UpdatePlayerPanel (ref)
        if u8 then
            u8.Dropped.Visible = not (workspace:GetAttribute("Gamemode") == "Deathmatch" and true or (IsTutorialMode() or IsSurvivalMode()));
        end;

        for _, v in u23 do
            v.Card:Destroy();
        end;

        table.clear(u23);
        u24 = 0;
        u4:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
        UpdatePlayerPanel();
    end);

    if u8 then
        u8.Dropped.Visible = not (workspace:GetAttribute("Gamemode") == "Deathmatch" and true or (IsTutorialMode() or IsSurvivalMode()));
    end;

    Observers.observeAttribute(workspace, "ServerGamemode", function() -- Line: 1888
        -- upvalues: u8 (ref), IsTutorialMode (ref), IsSurvivalMode (ref), u4 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy), UpdatePlayerPanel (ref), u21 (ref), RefreshTeamList (ref)
        if u8 then
            u8.Dropped.Visible = not (workspace:GetAttribute("Gamemode") == "Deathmatch" and true or (IsTutorialMode() or IsSurvivalMode()));
        end;

        u4:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
        UpdatePlayerPanel();

        if not u21 and u8 then
            if not u8.Visible then
                return;
            end;

            u21 = true;
            task.defer(RefreshTeamList);
        end;
    end);
    Observers.observeAttribute(workspace, "CTLossStreak", UpdateLossBonus);
    Observers.observeAttribute(workspace, "TLossStreak", UpdateLossBonus);
    Remotes.Inventory.NewInventoryItem.Listen(function(p322) -- Line: 1902
        -- upvalues: u6 (ref), refreshBuyMenuTemplates (copy)
        if p322.isPurchase ~= true then
            return;
        end;

        table.insert(u6, p322.identifier);
        refreshBuyMenuTemplates();
    end);
    Remotes.Inventory.RemoveInventoryItem.Listen(function(u323) -- Line: 1912
        -- upvalues: RemoveFromArray (ref), u6 (ref)
        RemoveFromArray(u6, function(p324, p325) -- Line: 1913
            -- upvalues: u323 (copy)
            return p325 == u323;
        end);
    end);
    Observers.observeAttribute(LocalPlayer, "MinimumNextRoundIncome", UpdateNextRoundMoney);
    Observers.observeAttribute(LocalPlayer, "Money", function(p326) -- Line: 1923
        -- upvalues: u5 (ref), u8 (ref), refreshBuyMenuTemplates (copy)
        u5:setGoal(p326);

        if u8.Visible then
            refreshBuyMenuTemplates();
        end;
    end);

    for _, v in ipairs({ "Armor", "HasDefuseKit", "HasRescueKit" }) do
        Observers.observeAttribute(LocalPlayer, v, function() -- Line: 1932
            -- upvalues: refreshBuyMenuTemplates (copy), UpdatePlayerLoadout (ref)
            refreshBuyMenuTemplates();
            UpdatePlayerLoadout();
        end);
    end;

    Observers.observeAttribute(LocalPlayer, "Health", refreshBuyMenuTemplates, function() -- Line: 1939
        -- upvalues: u8 (ref), IsSurvivalMode (ref)
        local v327 = u8.Visible and IsSurvivalMode();

        return v327;
    end);
    u8:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1944
        -- upvalues: u8 (ref), IsSurvivalMode (ref), refreshBuyMenuTemplates (copy)
        if u8.Visible and IsSurvivalMode() then
            refreshBuyMenuTemplates();
        end;
    end);
    Remotes.Inventory.RefillAmmo.Listen(function() -- Line: 1949
        -- upvalues: refreshBuyMenuTemplates (copy)
        task.defer(refreshBuyMenuTemplates);
    end);
    Observers.observeAttribute(workspace, "VIPInfiniteCashEnabled", refreshBuyMenuTemplates);
    Observers.observeAttribute(LocalPlayer, "TutorialStep", function() -- Line: 1954
        -- upvalues: refreshBuyMenuTemplates (copy)
        refreshBuyMenuTemplates();
    end);
    Observers.observeAttribute(LocalPlayer, SurvivalDowned.DOWNED_ATTRIBUTE, function() -- Line: 1959
        -- upvalues: u1 (ref)
        u1.closeFrame();

        return nil;
    end);
    Observers.observeAttribute(LocalPlayer, "BuyMenu", function() -- Line: 1965
        -- upvalues: u1 (ref)
        return function() -- Line: 1966
            -- upvalues: u1 (ref)
            u1.closeFrame();
        end;
    end);
    Observers.observeAttribute(workspace, "Timer", UpdateBuyMenuTimerText);
    Observers.observeAttribute(workspace, "BuyTimerRemaining", UpdateBuyMenuTimerText);
    GameState.ListenToState(function(p328, p329) -- Line: 1976
        -- upvalues: u6 (ref), u23 (ref), u24 (ref), UpdateBuyMenuTimerText (ref), refreshBuyMenuTemplates (copy), UpdatePlayerPanel (ref)
        if p329 == "Buy Period" then
            table.clear(u6);

            for _, v in u23 do
                v.Card:Destroy();
            end;

            table.clear(u23);
            u24 = 0;
        end;

        UpdateBuyMenuTimerText();
        refreshBuyMenuTemplates();
        UpdatePlayerPanel();
    end);
    Observers.observeAttribute(workspace, SurvivalState.RESUPPLY_ATTRIBUTE, function(p330) -- Line: 1989
        -- upvalues: u6 (ref), refreshBuyMenuTemplates (copy)
        if p330 == true then
            table.clear(u6);
            refreshBuyMenuTemplates();
        end;
    end);
    InventoryController.OnInventoryChanged:Connect(function(p331) -- Line: 1997
        -- upvalues: u10 (ref), u1 (ref), UpdatePlayerLoadout (ref)
        for _, v in ipairs(u10) do
            u1.updateBuyMenuTemplate(p331, v.Button);
        end;

        UpdatePlayerLoadout();
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 2005
        -- upvalues: refreshBuyMenuTemplates (copy), u8 (ref), GetPreferenceColor (ref), u21 (ref), RefreshTeamList (ref), u23 (ref), PaintDroppedCard (ref)
        refreshBuyMenuTemplates();
        u8.PlayerPanel.Accent.BackgroundColor3 = GetPreferenceColor();

        if not u21 and (u8 and u8.Visible) then
            u21 = true;
            task.defer(RefreshTeamList);
        end;

        for _, v in u23 do
            PaintDroppedCard(v);
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 2016
        -- upvalues: LocalPlayer (ref), u4 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy)
        if not LocalPlayer.Character then
            return;
        end;

        u4:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
    end);
    Observers.observeTag("WeaponDropped", function(u332: userdata) -- Line: 2026
        -- upvalues: onWeaponDropped (ref), u23 (ref), u24 (ref)
        onWeaponDropped(u332);

        return function() -- Line: 2028
            -- upvalues: u332 (copy), u23 (ref), u24 (ref)
            local v333 = u332;
            local v334 = u23[v333];

            if not v334 then
                return;
            end;

            u23[v333] = nil;
            u24 = u24 - 1;
            v334.Card:Destroy();
        end;
    end);
end;

function u1.Start() -- Line: 2034
    -- upvalues: LocalPlayer (copy), u1 (copy), CharacterResolver (copy)
    if LocalPlayer.Character then
        u1.characterAdded(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(u1.characterAdded);
    CharacterResolver.observeCharacter(LocalPlayer, function(u335: userdata?) -- Line: 2043
        -- upvalues: u1 (ref)
        if not u335 then
            u1.closeFrame();

            return nil;
        end;

        local function closeWhenDead() -- Line: 2049
            -- upvalues: u335 (copy), u1 (ref)
            if u335:GetAttribute("Dead") == true then
                u1.closeFrame();
            end;
        end;

        if u335:GetAttribute("Dead") == true then
            u1.closeFrame();
        end;

        local u336 = u335:GetAttributeChangedSignal("Dead"):Connect(closeWhenDead);

        return function() -- Line: 2058
            -- upvalues: u336 (copy)
            u336:Disconnect();
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(function() -- Line: 2063
        -- upvalues: LocalPlayer (ref), u1 (ref)
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            u1.closeFrame();
        end;
    end);
end;

return u1;