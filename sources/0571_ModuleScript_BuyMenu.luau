-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea);
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Spring = require(ReplicatedStorage.Shared.Spring);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local BuyMenuInfo = require(script:WaitForChild("BuyMenuInfo"));
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
local Color3_fromRGB_ret = Color3.fromRGB(149, 149, 149);
local u2 = { "CompetitivePlayerColor", "Armor", "HasDefuseKit", "HasRescueKit" };
local u3 = Janitor.new();
local u4 = Janitor.new();
local u5 = Spring.new(1, 8, 0);
local u6 = {};
local u7 = false;
local u8 = nil;
local u9 = nil;
local u10 = {
    ["1"] = "Kevlar",
    ["2"] = "Kevlar + Helmet"
};
local u11 = {
    Kevlar = true,
    ["Kevlar + Helmet"] = true,
    ["Defuse Kit"] = true,
    ["Rescue Kit"] = true
};
local u12 = {
    Terrorists = { "Glock-18" },
    ["Counter-Terrorists"] = { "USP-S", "P2000" }
};
local u13 = {
    {
        Name = "Yellow",
        Color = Color3.fromRGB(255, 221, 51)
    },
    {
        Name = "Green",
        Color = Color3.fromRGB(0, 153, 0)
    },
    {
        Name = "Blue",
        Color = Color3.fromRGB(0, 102, 204)
    },
    {
        Name = "Purple",
        Color = Color3.fromRGB(153, 51, 204)
    },
    {
        Name = "Orange",
        Color = Color3.fromRGB(255, 128, 0)
    }
};
local u14 = Janitor.new();
local u15 = {};
local u16 = {};
local u17 = nil;
local u18 = {};
local u19 = {};
local u20 = nil;
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 255, 255);
local u21 = { 1, 2, 3, 4 };
local Color3_fromRGB_ret3 = Color3.fromRGB(255, 70, 70);
local Color3_fromRGB_ret4 = Color3.fromRGB(235, 40, 40);

local function CommaNumber(p22: number) -- Line: 159
    return tostring(p22):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function GetInventoryItemFromIdentifier(p23: table, p24: string) -- Line: 163
    for _, v in ipairs(p23) do
        if v._id == p24 then
            return v;
        end;
    end;

    return nil;
end;

local function ResolveTemplateInventoryItem(p25) -- Line: 176
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local Attribute = p25:GetAttribute("InventoryItemId");

    if not (Attribute and (Attribute ~= "" and Attribute ~= "__buymenu_zeus_placeholder__")) then
        return nil;
    end;

    if string.sub(Attribute, 1, 10) == "equipment:" then
        return nil;
    end;

    local v26 = DataController.Get(LocalPlayer, "Inventory");

    if not v26 or typeof(v26) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v26) do
        if v._id == Attribute then
            return v;
        end;
    end;

    return nil;
end;

local function ResolveTemplateSkinName(p27) -- Line: 192
    -- upvalues: ResolveTemplateInventoryItem (copy)
    local v28 = ResolveTemplateInventoryItem(p27);

    if v28 then
        v28 = v28.Skin;
    end;

    if typeof(v28) == "string" and v28 ~= "" then
        return v28;
    end;

    return nil;
end;

local function ShowWeaponInfoFrame(p29) -- Line: 199
    -- upvalues: u8 (ref), ResolveTemplateInventoryItem (copy), Skins (copy), GetSkinDisplayName (copy), Rarities (copy), Color3_fromRGB_ret2 (copy), BuyMenuInfo (copy), u21 (copy)
    local Attribute = p29:GetAttribute("Weapon");

    if not Attribute or Attribute == "" then
        return;
    end;

    local WeaponInfoFrame = u8.WeaponInfoFrame;
    local v30 = ResolveTemplateInventoryItem(p29);

    if v30 then
        v30 = v30.Skin;
    end;

    if typeof(v30) ~= "string" or v30 == "" then
        v30 = nil;
    end;

    local v31 = nil;

    if v30 and v30 ~= "Stock" then
        local SkinInformation = Skins.GetSkinInformation(Attribute, v30);

        if SkinInformation and SkinInformation.rarity then
            v31 = SkinInformation.rarity;
        end;
    end;

    local v32 = ResolveTemplateInventoryItem(p29);
    local v33;

    if v32 then
        v33 = v32.NameTag;
    else
        v33 = v32;
    end;

    local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(Attribute, v33);

    if v30 and (v30 ~= "Stock" and v31) then
        local v34 = Rarities[v31];
        local ApplyNameLabel = GetSkinDisplayName.ApplyNameLabel;
        local WeaponName = WeaponInfoFrame.WeaponName;
        local v35 = `{WeaponDisplayName} | {GetSkinDisplayName(v30)}`;

        if v32 then
            v32 = v32.NameTag;
        end;

        ApplyNameLabel(WeaponName, v35, v32);
        WeaponInfoFrame.WeaponName.TextColor3 = v34 and v34.Color or Color3_fromRGB_ret2;
    else
        if v32 then
            v32 = v32.NameTag;
        end;

        GetSkinDisplayName.ApplyNameLabel(WeaponInfoFrame.WeaponName, WeaponDisplayName, v32);
        WeaponInfoFrame.WeaponName.TextColor3 = Color3_fromRGB_ret2;
    end;

    local v36 = BuyMenuInfo.Weapons[Attribute];
    local Stats = WeaponInfoFrame.Stats;
    local v37 = v36 and (v36.Stars or 0) or 0;
    Stats.Info.Text = v36 and (v36.Info or "") or "";
    Stats.Tip.Text = v36 and v36.Tip or "";
    local v38 = v37 >= 1 and BuyMenuInfo.GetStarColor(v37) or Color3_fromRGB_ret2;

    for _, v in ipairs(u21) do
        local v39 = Stats.Difficulty:FindFirstChild((tostring(v)));

        if v39 then
            local v40 = v <= v37;
            v39.Visible = v40;

            if v40 then
                v39.ImageColor3 = v38;
            end;
        end;
    end;

    WeaponInfoFrame.Visible = true;
end;

local function HideWeaponInfoFrame() -- Line: 254
    -- upvalues: u8 (ref)
    if u8 and u8.WeaponInfoFrame then
        u8.WeaponInfoFrame.Visible = false;
    end;
end;

local function IsObjectiveEquipmentAvailableForPlayer(p41: string, p42: string?, p43: any) -- Line: 260
    if p42 ~= "Counter-Terrorists" then
        return false;
    end;

    if p41 == "Defuse Kit" then
        return p43 == "Bomb Defusal";
    end;

    return p41 ~= "Rescue Kit" and true or p43 == "Hostage Rescue";
end;

local function IsCompetitiveServerGamemode() -- Line: 278
    return workspace:GetAttribute("ServerGamemode") == "Competitive";
end;

local function IsEquipmentAvailableForLocalPlayer(p44: string) -- Line: 282
    -- upvalues: u11 (copy), LocalPlayer (copy)
    if u11[p44] and workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        return false;
    end;

    if p44 ~= "Defuse Kit" and p44 ~= "Rescue Kit" then
        return true;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");
    local Attribute2 = workspace:GetAttribute("Gamemode");

    if Attribute ~= "Counter-Terrorists" then
        return false;
    end;

    if p44 == "Defuse Kit" then
        return Attribute2 == "Bomb Defusal";
    end;

    return p44 ~= "Rescue Kit" and true or Attribute2 == "Hostage Rescue";
end;

local function GetEquipmentByTemplate(p45: string) -- Line: 296
    -- upvalues: u10 (copy), IsEquipmentAvailableForLocalPlayer (copy), u11 (copy), LocalPlayer (copy)
    local v46 = u10[p45];

    if v46 then
        if IsEquipmentAvailableForLocalPlayer(v46) then
            return v46;
        end;

        return nil;
    end;

    if p45 ~= "3" then
        return nil;
    end;

    local v47;

    if u11["Defuse Kit"] and workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        v47 = false;
    else
        local Attribute = LocalPlayer:GetAttribute("Team");
        local Attribute2 = workspace:GetAttribute("Gamemode");

        if Attribute == "Counter-Terrorists" then
            v47 = Attribute2 == "Bomb Defusal";
        else
            v47 = false;
        end;
    end;

    if v47 then
        return "Defuse Kit";
    end;

    local v48;

    if u11["Rescue Kit"] and workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        v48 = false;
    else
        local Attribute = LocalPlayer:GetAttribute("Team");
        local Attribute2 = workspace:GetAttribute("Gamemode");

        if Attribute == "Counter-Terrorists" then
            v48 = Attribute2 == "Hostage Rescue";
        else
            v48 = false;
        end;
    end;

    return v48 and "Rescue Kit" or nil;
end;

local function GetPlayerArmorState(p49: userdata) -- Line: 321
    -- upvalues: HttpService (copy)
    local Attribute = p49:GetAttribute("Armor");

    if typeof(Attribute) == "string" and Attribute ~= "" then
        local success, result = pcall(function() -- Line: 324
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

local function GetDisplayCost(p50: string, p51: any) -- Line: 341
    -- upvalues: GameState (copy), LocalPlayer (copy), GetPlayerArmorState (copy)
    local Attribute = workspace:GetAttribute("Gamemode");

    if Attribute == "Deathmatch" or (Attribute == "Tutorial" or GameState.GetState() == "Warmup") then
        return 0;
    end;

    if workspace:GetAttribute("VIPInfiniteCashEnabled") == true then
        return 0;
    end;

    local Cost = p51.Cost;

    if p50 == "Molotov" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
        return 500;
    end;

    if p50 == "Kevlar + Helmet" then
        local v52 = GetPlayerArmorState(LocalPlayer);
        Cost = v52.Type == "Kevlar" and v52.Health >= 100 and 350 or Cost;
    end;

    return Cost;
end;

local function IsEquipmentOwnedBy(p53: userdata, p54: string) -- Line: 362
    -- upvalues: GetPlayerArmorState (copy)
    if p54 == "Defuse Kit" then
        return p53:GetAttribute("HasDefuseKit") == true;
    end;

    if p54 == "Rescue Kit" then
        return p53:GetAttribute("HasRescueKit") == true;
    end;

    local v55 = GetPlayerArmorState(p53);

    if p54 ~= "Kevlar" and p54 ~= "Kevlar + Helmet" then
        return false;
    end;

    local v56;

    if v55.Health > 0 then
        v56 = v55.Type == p54;
    else
        v56 = false;
    end;

    return v56;
end;

local function IsEquipmentOwned(p57: string) -- Line: 377
    -- upvalues: IsEquipmentOwnedBy (copy), LocalPlayer (copy)
    return IsEquipmentOwnedBy(LocalPlayer, p57);
end;

local function IsEquipmentPurchaseBlockedForLocalPlayer(p58: string) -- Line: 381
    -- upvalues: IsEquipmentAvailableForLocalPlayer (copy), IsEquipmentOwnedBy (copy), LocalPlayer (copy), GetPlayerArmorState (copy)
    if not IsEquipmentAvailableForLocalPlayer(p58) then
        return true;
    end;

    if p58 == "Defuse Kit" or p58 == "Rescue Kit" then
        return IsEquipmentOwnedBy(LocalPlayer, p58);
    end;

    local v59 = GetPlayerArmorState(LocalPlayer);
    local v60;

    if v59.Type == "Kevlar + Helmet" then
        v60 = v59.Health > 0;
    else
        v60 = false;
    end;

    local v61;

    if v60 then
        v61 = v59.Health >= 100;
    else
        v61 = v60;
    end;

    if p58 == "Kevlar" then
        local v62;

        if v59.Type == "Kevlar" then
            v62 = v59.Health >= 100;
        else
            v62 = false;
        end;

        return v62 or v61;
    end;

    if p58 == "Kevlar + Helmet" then
        return v60;
    end;

    return false;
end;

local function IsStarterPistolForLocalPlayer(p63: string) -- Line: 403
    -- upvalues: u12 (copy), LocalPlayer (copy)
    local v64 = u12[LocalPlayer:GetAttribute("Team")];

    if v64 then
        return table.find(v64, p63) ~= nil;
    end;

    return false;
end;

local function HideTemplate(p65) -- Line: 412
    p65:SetAttribute("IsEquipment", nil);
    p65:SetAttribute("Weapon", nil);
    p65.Visible = false;
end;

local u66 = nil;

local function setupBuyMenuTemplates() -- Line: 421
    -- upvalues: Profiler (copy), u66 (ref), u8 (ref), Router (copy), LocalPlayer (copy), u1 (copy), u10 (copy), IsEquipmentAvailableForLocalPlayer (copy), u11 (copy)
    Profiler.mark("UI.BuyMenu.SetupBuyMenuTemplates");
    u66();

    for _, descendant in ipairs(u8.Menu.Container:GetDescendants()) do
        if descendant:IsA("TextButton") then
            if descendant.Parent.Name == "Equipment" then
                if descendant.Name == "4" then
                    local v67 = Router.broadcastRouter("GetEquippedInventoryItem", LocalPlayer, "Equipped.Equipped Zeus x27");
                    u1.createTemplate(descendant, not (v67 and v67.Name) and {
                        Name = "Zeus x27",
                        _id = "__buymenu_zeus_placeholder__"
                    } or v67, false, "Equipped.Equipped Zeus x27");
                else
                    local Name = descendant.Name;
                    local v68 = u10[Name];

                    if v68 then
                        if not IsEquipmentAvailableForLocalPlayer(v68) then
                            v68 = nil;
                        end;
                    elseif Name == "3" then
                        local v69;

                        if u11["Defuse Kit"] and workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
                            v69 = false;
                        else
                            local Attribute = LocalPlayer:GetAttribute("Team");
                            local Attribute2 = workspace:GetAttribute("Gamemode");

                            if Attribute == "Counter-Terrorists" then
                                v69 = Attribute2 == "Bomb Defusal";
                            else
                                v69 = false;
                            end;
                        end;

                        if v69 then
                            v68 = "Defuse Kit";
                        else
                            local v70;

                            if u11["Rescue Kit"] and workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
                                v70 = false;
                            else
                                local Attribute = LocalPlayer:GetAttribute("Team");
                                local Attribute2 = workspace:GetAttribute("Gamemode");

                                if Attribute == "Counter-Terrorists" then
                                    v70 = Attribute2 == "Hostage Rescue";
                                else
                                    v70 = false;
                                end;
                            end;

                            v68 = v70 and "Rescue Kit" or nil;
                        end;
                    else
                        v68 = nil;
                    end;

                    if v68 then
                        u1.createTemplate(descendant, {
                            Name = v68,
                            _id = `equipment:{v68}`
                        }, true, nil);
                    else
                        descendant:SetAttribute("IsEquipment", nil);
                        descendant:SetAttribute("Weapon", nil);
                        descendant.Visible = false;
                    end;
                end;
            else
                u1.setupTemplate(descendant, (`Loadout.{descendant.Parent.Name}.Options.{tonumber(descendant.Name)}`));
            end;
        end;
    end;
end;

local function GetInventoryItemProperties(p71: string) -- Line: 468
    -- upvalues: ReplicatedStorage (copy)
    local v72 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p71) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(p71);

    if v72 then
        return require(v72);
    end;

    return nil;
end;

local function QueryInventoryItem(p73: any, p74: string) -- Line: 486
    for _, v in ipairs(p73) do
        for _, v2 in ipairs(v._items) do
            if v2.Name == p74 then
                return v2;
            end;
        end;
    end;

    return false;
end;

local function QueryRoundPurchasedInventoryItem(p75: any, p76: string) -- Line: 497
    -- upvalues: u6 (copy)
    for _, v in ipairs(p75) do
        for _, v2 in ipairs(v._items) do
            if v2.Name == p76 and table.find(u6, v2.Identifier) then
                return v2;
            end;
        end;
    end;

    return false;
end;

local function QueryInventoryItemPurchasedThisRound(p77: any, p78: string) -- Line: 512
    -- upvalues: QueryRoundPurchasedInventoryItem (copy), QueryInventoryItem (copy)
    return QueryRoundPurchasedInventoryItem(p77, p78) or QueryInventoryItem(p77, p78);
end;

local function IsUnrefundableStarterPistol(p79: string, p80: any) -- Line: 520
    -- upvalues: u12 (copy), LocalPlayer (copy), QueryRoundPurchasedInventoryItem (copy)
    local v81 = u12[LocalPlayer:GetAttribute("Team")];
    local v82;

    if v81 then
        v82 = table.find(v81, p79) ~= nil;
    else
        v82 = false;
    end;

    if v82 then
        return not p80 and true or not QueryRoundPurchasedInventoryItem(p80, p79);
    end;

    return false;
end;

local function GetInventoryItemCount(p83: any, p84: string) -- Line: 533
    local v85 = 0;

    for _, v in ipairs(p83) do
        for _, v2 in ipairs(v._items) do
            if v2.Name == p84 then
                v85 = v85 + 1;
            end;
        end;
    end;

    return v85;
end;

local function IsTutorialItemAllowed(p86: string) -- Line: 545
    -- upvalues: TutorialPurchaseLock (copy), LocalPlayer (copy)
    return TutorialPurchaseLock.isPurchaseAllowed(LocalPlayer, p86);
end;

local u87 = {};

local function IsTutorialPulseWanted(p88: string, p89: any) -- Line: 567
    -- upvalues: TutorialPurchaseLock (copy), LocalPlayer (copy), GetInventoryItemCount (copy)
    local RequiredItems = TutorialPurchaseLock.getRequiredItems(LocalPlayer);

    if not (RequiredItems and table.find(RequiredItems, p88)) then
        return false;
    end;

    if p89 then
        p89 = GetInventoryItemCount(p89, p88) > 0;
    end;

    return not p89;
end;

local function StopTutorialPulse(p90: userdata, p91) -- Line: 575
    -- upvalues: u87 (copy)
    local v92 = u87[p90];

    if not v92 then
        return;
    end;

    u87[p90] = nil;
    local v93 = p90.Parent and p90.Parent:FindFirstChild("Background");

    if v93 then
        v93 = v93:FindFirstChild("TutorialRequiredOutline");
    end;

    if v93 then
        v93:Destroy();
    end;

    v92.Color:Cancel();
    v92.Swell:Cancel();
    v92.Scale.Scale = 1;
    p90.ImageColor3 = p91 or v92.RestingColor;
end;

u66 = function() -- Line: 592
    -- upvalues: u87 (copy), StopTutorialPulse (copy)
    for i in u87 do
        StopTutorialPulse(i);
    end;
end;

local function SyncTutorialPulse(p94: any, p95, p96: boolean) -- Line: 603
    -- upvalues: u87 (copy), StopTutorialPulse (copy), TweenService (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy)
    local Icon = p94.Icon;
    local v97 = u87[Icon];

    if not p96 then
        StopTutorialPulse(Icon, p95);

        return;
    end;

    if v97 then
        if not p95 or p95 == v97.RestingColor then
            return;
        end;

        StopTutorialPulse(Icon, p95);
    end;

    local TutorialPulse = Icon:FindFirstChild("TutorialPulse");

    if not TutorialPulse then
        TutorialPulse = Instance.new("UIScale");
        TutorialPulse.Name = "TutorialPulse";
        TutorialPulse.Parent = Icon;
    end;

    TutorialPulse.Scale = 1;
    local TweenInfo_new_ret = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
    local v98 = {
        Color = TweenService:Create(Icon, TweenInfo_new_ret, {
            ImageColor3 = Color3_fromRGB_ret3
        }),
        Swell = TweenService:Create(TutorialPulse, TweenInfo_new_ret, {
            Scale = 1.1
        }),
        Scale = TutorialPulse,
        RestingColor = p95 or Icon.ImageColor3
    };
    u87[Icon] = v98;
    v98.Color:Play();
    v98.Swell:Play();
    local Background = p94.Background;

    if Background and not Background:FindFirstChild("TutorialRequiredOutline") then
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Name = "TutorialRequiredOutline";
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.Color = Color3_fromRGB_ret4;
        UIStroke.Thickness = 2;
        UIStroke.Parent = Background;
    end;
end;

local function IsTutorialPurchasePending() -- Line: 655
    -- upvalues: InventoryController (copy), TutorialPurchaseLock (copy), LocalPlayer (copy), GetInventoryItemCount (copy)
    local CurrentInventory = InventoryController.getCurrentInventory();

    return TutorialPurchaseLock.isWaitingOnPurchase(LocalPlayer, function(p99: string) -- Line: 657
        -- upvalues: CurrentInventory (copy), GetInventoryItemCount (ref)
        if CurrentInventory then
            return GetInventoryItemCount(CurrentInventory, p99) > 0;
        end;

        return false;
    end);
end;

local function ResetTemplateTeammateIndicators(p100) -- Line: 666
    -- upvalues: u13 (copy)
    local Teammates = p100.Teammates;
    Teammates.Visible = false;

    for _, v in ipairs(u13) do
        local v101 = Teammates[v.Name];

        if v101 then
            v101.Visible = false;
        end;
    end;
end;

local function GetCompetitiveTeammateIndicator(p102: any, p103: userdata) -- Line: 677
    -- upvalues: u13 (copy)
    local Attribute = p103:GetAttribute("CompetitivePlayerColor");

    if not Attribute then
        return nil;
    end;

    local Teammates = p102.Teammates;

    for _, v in ipairs(u13) do
        if Attribute == v.Color then
            return Teammates[v.Name];
        end;
    end;

    return nil;
end;

local function ClearCompetitiveTeammateInventoryCache() -- Line: 693
    -- upvalues: u18 (copy), u19 (copy)
    table.clear(u18);
    table.clear(u19);
end;

local function RequestCompetitiveTeammateInventory(u104: userdata) -- Line: 698
    -- upvalues: LocalPlayer (copy), Players (copy), u19 (copy), Remotes (copy)
    if u104 == LocalPlayer or not u104:IsDescendantOf(Players) then
        return;
    end;

    if u19[u104] then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");

    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" or u104:GetAttribute("Team") ~= Attribute then
        return;
    end;

    u19[u104] = true;
    Remotes.Inventory.RequestSpectatedPlayerInventory.Send(u104);
    task.delay(0.15, function() -- Line: 714
        -- upvalues: u19 (ref), u104 (copy)
        u19[u104] = nil;
    end);
end;

local function RequestCompetitiveTeammateInventories() -- Line: 719
    -- upvalues: LocalPlayer (copy), Players (copy), RequestCompetitiveTeammateInventory (copy)
    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");

    if not (Attribute and (Attribute == "Counter-Terrorists" or Attribute == "Terrorists")) then
        return;
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v:GetAttribute("Team") == Attribute then
            RequestCompetitiveTeammateInventory(v);
        end;
    end;
end;

local function PlayerHasTemplateItem(p105: userdata, p106: string, p107: boolean) -- Line: 736
    -- upvalues: IsEquipmentOwnedBy (copy), LocalPlayer (copy), InventoryController (copy), u18 (copy)
    if p107 then
        return IsEquipmentOwnedBy(p105, p106);
    end;

    local v108;

    if p105 == LocalPlayer then
        v108 = InventoryController.getCurrentInventory();
    else
        v108 = u18[p105];
    end;

    if not v108 then
        return false;
    end;

    for _, v in ipairs(v108) do
        for _, v2 in ipairs(v._items) do
            if v2.Name == p106 then
                return true;
            end;
        end;
    end;

    return false;
end;

local function UpdateTemplateTeammateIndicators(p109) -- Line: 759
    -- upvalues: u13 (copy), LocalPlayer (copy), Players (copy), u18 (copy), RequestCompetitiveTeammateInventory (copy), PlayerHasTemplateItem (copy), GetCompetitiveTeammateIndicator (copy)
    local Teammates = p109.Teammates;
    Teammates.Visible = false;

    for _, v in ipairs(u13) do
        local v110 = Teammates[v.Name];

        if v110 then
            v110.Visible = false;
        end;
    end;

    if not p109.Visible or workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");

    if not (Attribute and (Attribute == "Counter-Terrorists" or Attribute == "Terrorists")) then
        return;
    end;

    local Attribute2 = p109:GetAttribute("Weapon");

    if not Attribute2 then
        return;
    end;

    local v111 = p109:GetAttribute("IsEquipment") == true;
    local v112 = false;

    for _, v in ipairs(Players:GetPlayers()) do
        if v:GetAttribute("Team") == Attribute then
            if v ~= LocalPlayer and not (v111 or u18[v]) then
                RequestCompetitiveTeammateInventory(v);
            end;

            if PlayerHasTemplateItem(v, Attribute2, v111) then
                local v113 = GetCompetitiveTeammateIndicator(p109, v);

                if v113 then
                    v113.Visible = true;
                    v112 = true;
                end;
            end;
        end;
    end;

    p109.Teammates.Visible = v112;
end;

local function UpdateAllTeammateIndicators() -- Line: 798
    -- upvalues: Profiler (copy), u8 (ref), UpdateTemplateTeammateIndicators (copy)
    Profiler.mark("UI.BuyMenu.UpdateAllTeammateIndicators");

    if not u8 then
        return;
    end;

    for _, descendant in ipairs(u8.Menu.Container:GetDescendants()) do
        if descendant:IsA("TextButton") then
            UpdateTemplateTeammateIndicators(descendant);
        end;
    end;
end;

local function CanCarryDuplicate(p114: any, p115: string) -- Line: 811
    -- upvalues: GetInventoryItemCount (copy), Grenades (copy)
    local v116 = GetInventoryItemCount(p114, p115);
    local v117 = Grenades[p115];

    if v117 then
        return v116 < v117;
    end;

    return v116 == 0;
end;

local function WaitForAttribute(p118: userdata, p119: string) -- Line: 820
    local Attribute = p118:GetAttribute(p119);

    while not Attribute do
        Attribute = p118:GetAttribute(p119);
        task.wait();
    end;

    return Attribute;
end;

local function UpdateBuyMenuTimerText() -- Line: 829
    -- upvalues: GameState (copy), u8 (ref), GetTimerFormat (copy)
    local State = GameState.GetState();
    local v120;

    if State == "Buy Period" or State == "Round In Progress" then
        v120 = workspace:GetAttribute("BuyTimerRemaining");
    else
        v120 = nil;
    end;

    if typeof(v120) ~= "number" then
        v120 = workspace:GetAttribute("Timer");
    end;

    local v121;

    if typeof(v120) == "number" then
        local math_floor_ret = math.floor(v120);
        v121 = math.max(0, math_floor_ret);
    else
        v121 = 0;
    end;

    u8.Menu.TopFrame.Timer.Text = GetTimerFormat(v121);
end;

local function ApplyTemplateColor(p122: any, p123) -- Line: 844
    p122.ItemName.TextColor3 = p123;
    p122.Keybind.TextColor3 = p123;
    p122.Icon.ImageColor3 = p123;
    p122.Cost.TextColor3 = p123;
end;

local function TweenTemplateIcon(p124: any, p125: number) -- Line: 851
    -- upvalues: TweenService (copy)
    TweenService:Create(p124.Icon, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.fromScale(p125, p125)
    }):Play();
end;

local function IsTemplateItemOwned(p126: string, p127: boolean) -- Line: 857
    -- upvalues: InventoryController (copy), IsEquipmentOwnedBy (copy), LocalPlayer (copy), QueryInventoryItem (copy)
    local CurrentInventory = InventoryController.getCurrentInventory();
    local v128 = p127 and IsEquipmentOwnedBy(LocalPlayer, p126);

    if v128 then
        CurrentInventory = v128;
    elseif CurrentInventory then
        CurrentInventory = QueryInventoryItem(CurrentInventory, p126);
    end;

    return CurrentInventory;
end;

function u1.purchase(p129: string, p130: string?, p131: boolean) -- Line: 866
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy), GetDisplayCost (copy), IsEquipmentPurchaseBlockedForLocalPlayer (copy), TutorialPurchaseLock (copy), IsInBuyArea (copy), GameState (copy), Grenades (copy), InventoryController (copy), NumberSlots (copy), u6 (copy), Router (copy), Remotes (copy)
    local v132 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p129) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(p129);
    local v133;

    if v132 then
        v133 = require(v132);
    else
        v133 = nil;
    end;

    if not v133 then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("Money");
    local v134 = GetDisplayCost(p129, v133);
    local Attribute2 = workspace:GetAttribute("Gamemode");

    if p131 and IsEquipmentPurchaseBlockedForLocalPlayer(p129) then
        return;
    end;

    if not TutorialPurchaseLock.isPurchaseAllowed(LocalPlayer, p129) then
        return;
    end;

    if not IsInBuyArea(LocalPlayer) then
        return;
    end;

    local v135 = (Attribute2 == "Deathmatch" or (Attribute2 == "Tutorial" or GameState.GetState() == "Warmup")) and 0 or v134;
    local v136 = (not p131 and Grenades[p129] ~= nil and true or false) and InventoryController.getCurrentInventory();

    if v136 then
        local v137 = v136[NumberSlots.Grenade];

        if v137 and #v137._items >= v137._settings._strict_slot_space then
            return;
        end;
    end;

    if not p131 and (LocalPlayer:GetAttribute("BuyMenu") and (Attribute2 == "Hostage Rescue" or Attribute2 == "Bomb Defusal")) then
        local CurrentInventory = InventoryController.getCurrentInventory();
        local v138 = NumberSlots[v133.Slot];

        if CurrentInventory then
            CurrentInventory = CurrentInventory[v138];
        end;

        if CurrentInventory then
            CurrentInventory = CurrentInventory._items[1];
        end;

        if CurrentInventory and table.find(u6, CurrentInventory.Identifier) then
            local Name = CurrentInventory.Name;
            local v139 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Name) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Name);
            local v140;

            if v139 then
                v140 = require(v139);
            else
                v140 = nil;
            end;

            if v140 then
                local Cost = v140.Cost;
                v135 = v134 - (CurrentInventory.Name == "Molotov" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" and 500 or Cost);
            end;
        end;
    end;

    if Attribute and v135 <= Attribute then
        Router.broadcastRouter("RunInterfaceSound", "Successful Buy Menu Purchase");
        Remotes.Inventory.BuyMenuPurchase.Send({
            Equipment = p131,
            Name = p129,
            Path = p130 or ""
        });
    end;
end;

function u1.createTemplate(u141: any, u142: any, u143: boolean, u144: string?) -- Line: 939
    -- upvalues: ReplicatedStorage (copy), GetDisplayCost (copy), GetSkinDisplayName (copy), u13 (copy), LocalPlayer (copy), IsEquipmentPurchaseBlockedForLocalPlayer (copy), Color3_fromRGB_ret (copy), GetPreferenceColor (copy), InventoryController (copy), IsEquipmentOwnedBy (copy), GetInventoryItemCount (copy), Grenades (copy), GameState (copy), u12 (copy), QueryRoundPurchasedInventoryItem (copy), u3 (copy), Router (copy), QueryInventoryItem (copy), TweenService (copy), TweenTemplateIcon (copy), ShowWeaponInfoFrame (copy), u8 (ref), u1 (copy), IsInBuyArea (copy), Remotes (copy)
    local Name = u142.Name;
    local v145 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Name) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Name);
    local v146;

    if v145 then
        v146 = require(v145);
    else
        v146 = nil;
    end;

    if not v146 then
        u141.Visible = false;

        return;
    end;

    local Attribute = workspace:GetAttribute("Gamemode");
    local v147 = GetDisplayCost(u142.Name, v146);
    u141.Icon.Image = v146.ReverseIcon or v146.Icon;
    u141.Cost.Text = "$" .. tostring(v147):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    local Keybind = u141.Keybind;
    local v148 = tonumber(u141.Name);
    Keybind.Text = tostring(v148);
    local v149;

    if Attribute == "Deathmatch" then
        v149 = false;
    else
        v149 = Attribute ~= "Tutorial";
    end;

    u141.Cost.Visible = v149;
    u141.LayoutOrder = tonumber(u141.Name);
    GetSkinDisplayName.ApplyNameLabel(u141.ItemName, GetSkinDisplayName.GetWeaponDisplayName(u142.Name, u142.NameTag), u142.NameTag);
    local Teammates = u141.Teammates;
    Teammates.Visible = false;

    for _, v in ipairs(u13) do
        local v150 = Teammates[v.Name];

        if v150 then
            v150.Visible = false;
        end;
    end;

    u141.Visible = true;
    local v151 = tonumber(LocalPlayer:GetAttribute("Money")) or 0;
    local v152;

    if u143 then
        v152 = IsEquipmentPurchaseBlockedForLocalPlayer(u142.Name);
    else
        v152 = u143;
    end;

    local v153 = (v151 < v147 or v152) and Color3_fromRGB_ret or GetPreferenceColor();
    u141.ItemName.TextColor3 = v153;
    u141.Keybind.TextColor3 = v153;
    u141.Icon.ImageColor3 = v153;
    u141.Cost.TextColor3 = v153;
    u141:SetAttribute("Weapon", u142.Name);
    u141:SetAttribute("IsEquipment", u143);
    u141:SetAttribute("InventoryItemId", u142._id);
    local CurrentInventory = InventoryController.getCurrentInventory();
    local v154 = false;
    local v155 = false;

    if u143 then
        v154 = IsEquipmentOwnedBy(LocalPlayer, u142.Name);
    elseif CurrentInventory then
        v154 = GetInventoryItemCount(CurrentInventory, u142.Name) > 0;
        local Name2 = u142.Name;
        local v156 = GetInventoryItemCount(CurrentInventory, Name2);
        local v157 = Grenades[Name2];

        if v157 then
            v155 = v156 < v157;
        elseif v156 == 0 then
            v155 = true;
        else
            v155 = false;
        end;
    end;

    local Return = u141.Return;
    local v158;

    if v154 then
        if GameState.GetState() == "Warmup" or (Attribute == "Deathmatch" or Attribute == "Tutorial") then
            v158 = false;
        elseif u143 then
            v158 = u143;
        else
            local Name2 = u142.Name;
            local v159 = u12[LocalPlayer:GetAttribute("Team")];
            local v160;

            if v159 then
                v160 = table.find(v159, Name2) ~= nil;
            else
                v160 = false;
            end;

            local v161;

            if v160 then
                v161 = not CurrentInventory and true or not QueryRoundPurchasedInventoryItem(CurrentInventory, Name2);
            else
                v161 = false;
            end;

            v158 = not v161;
        end;
    else
        v158 = v154;
    end;

    Return.Visible = v158;
    u141.Hover.Visible = v154;
    u141.Hover.UIStroke.Transparency = v154 and not v155 and 0 or 1;
    u3:Add(u141.MouseEnter:Connect(function() -- Line: 1009
        -- upvalues: Router (ref), u142 (copy), u143 (copy), InventoryController (ref), IsEquipmentOwnedBy (ref), LocalPlayer (ref), QueryInventoryItem (ref), u141 (copy), TweenService (ref), TweenTemplateIcon (ref), ShowWeaponInfoFrame (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        local Name2 = u142.Name;
        local CurrentInventory2 = InventoryController.getCurrentInventory();
        local v162 = u143 and IsEquipmentOwnedBy(LocalPlayer, Name2);

        if v162 then
            CurrentInventory2 = v162;
        elseif CurrentInventory2 then
            CurrentInventory2 = QueryInventoryItem(CurrentInventory2, Name2);
        end;

        if not CurrentInventory2 then
            u141.Hover.UIStroke.Transparency = 1;
            u141.Hover.Visible = true;
            TweenService:Create(u141.Hover.UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 0.8
            }):Play();
        end;

        TweenTemplateIcon(u141, 0.7);
        ShowWeaponInfoFrame(u141);
    end));
    u3:Add(u141.MouseLeave:Connect(function() -- Line: 1031
        -- upvalues: u142 (copy), u143 (copy), InventoryController (ref), IsEquipmentOwnedBy (ref), LocalPlayer (ref), QueryInventoryItem (ref), u141 (copy), TweenTemplateIcon (ref), u8 (ref)
        local Name2 = u142.Name;
        local CurrentInventory2 = InventoryController.getCurrentInventory();
        local v163 = u143 and IsEquipmentOwnedBy(LocalPlayer, Name2);

        if v163 then
            CurrentInventory2 = v163;
        elseif CurrentInventory2 then
            CurrentInventory2 = QueryInventoryItem(CurrentInventory2, Name2);
        end;

        if not CurrentInventory2 then
            u141.Hover.UIStroke.Transparency = 1;
            u141.Hover.Visible = false;
        end;

        TweenTemplateIcon(u141, 0.75);

        if u8 and u8.WeaponInfoFrame then
            u8.WeaponInfoFrame.Visible = false;
        end;
    end));
    u3:Add(u141.MouseButton1Down:Connect(function() -- Line: 1044
        -- upvalues: TweenTemplateIcon (ref), u141 (copy)
        TweenTemplateIcon(u141, 0.65);
    end));
    u3:Add(u141.MouseButton1Up:Connect(function() -- Line: 1047
        -- upvalues: TweenTemplateIcon (ref), u141 (copy)
        TweenTemplateIcon(u141, 0.7);
    end));
    u3:Add(u141.MouseButton1Click:Connect(function() -- Line: 1052
        -- upvalues: u1 (ref), u142 (copy), u144 (copy), u143 (copy)
        u1.purchase(u142.Name, u144, u143);
    end));
    u3:Add(u141.Return.MouseButton1Click:Connect(function() -- Line: 1057
        -- upvalues: u143 (copy), IsInBuyArea (ref), LocalPlayer (ref), Remotes (ref), u142 (copy), InventoryController (ref), u12 (ref), QueryRoundPurchasedInventoryItem (ref), QueryInventoryItem (ref)
        if u143 then
            if IsInBuyArea(LocalPlayer) then
                Remotes.Inventory.ReturnBuyMenuPurchase.Send({
                    Equipment = true,
                    Identifier = u142.Name
                });
            end;

            return;
        end;

        local CurrentInventory2 = InventoryController.getCurrentInventory();

        if not CurrentInventory2 then
            return;
        end;

        local Name2 = u142.Name;
        local v164 = u12[LocalPlayer:GetAttribute("Team")];
        local v165;

        if v164 then
            v165 = table.find(v164, Name2) ~= nil;
        else
            v165 = false;
        end;

        local v166;

        if v165 then
            v166 = not CurrentInventory2 and true or not QueryRoundPurchasedInventoryItem(CurrentInventory2, Name2);
        else
            v166 = false;
        end;

        if v166 then
            return;
        end;

        local Name3 = u142.Name;
        local v167 = QueryRoundPurchasedInventoryItem(CurrentInventory2, Name3) or QueryInventoryItem(CurrentInventory2, Name3);

        if v167 and IsInBuyArea(LocalPlayer) then
            Remotes.Inventory.ReturnBuyMenuPurchase.Send({
                Equipment = false,
                Identifier = v167.Identifier
            });
        end;
    end));
end;

function u1.setupTemplate(p168: any, p169: string) -- Line: 1091
    -- upvalues: Router (copy), LocalPlayer (copy), u1 (copy)
    local v170 = Router.broadcastRouter("GetEquippedInventoryItem", LocalPlayer, p169);

    if v170 and v170.Name then
        u1.createTemplate(p168, v170, false, p169);

        return;
    end;

    p168:SetAttribute("IsEquipment", nil);
    p168:SetAttribute("Weapon", nil);
    p168.Visible = false;
end;

function u1.updateBuyMenuTemplate(p171, p172) -- Line: 1101
    -- upvalues: u87 (copy), StopTutorialPulse (copy), ReplicatedStorage (copy), GetDisplayCost (copy), LocalPlayer (copy), IsEquipmentPurchaseBlockedForLocalPlayer (copy), TutorialPurchaseLock (copy), Color3_fromRGB_ret (copy), GetPreferenceColor (copy), SyncTutorialPulse (copy), GetInventoryItemCount (copy), IsEquipmentOwnedBy (copy), Grenades (copy), GameState (copy), u12 (copy), QueryRoundPurchasedInventoryItem (copy), TweenService (copy), UpdateTemplateTeammateIndicators (copy)
    local Attribute = p172:GetAttribute("IsEquipment");
    local Attribute2 = p172:GetAttribute("Weapon");

    if not Attribute2 then
        local Icon = p172.Icon;
        local _ = u87[Icon];
        StopTutorialPulse(Icon, nil);

        return;
    end;

    local v173 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Attribute2) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Attribute2);
    local v174;

    if v173 then
        v174 = require(v173);
    else
        v174 = nil;
    end;

    local v175 = nil;

    if v174 then
        local v176 = GetDisplayCost(Attribute2, v174);
        p172.Cost.Text = "$" .. tostring(v176):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        local Attribute3 = LocalPlayer:GetAttribute("Money");
        local v177;

        if Attribute then
            v177 = IsEquipmentPurchaseBlockedForLocalPlayer(Attribute2);
        else
            v177 = Attribute;
        end;

        local v178 = not TutorialPurchaseLock.isPurchaseAllowed(LocalPlayer, Attribute2);

        if Attribute3 then
            v175 = (Attribute3 < v176 or (v177 or v178)) and Color3_fromRGB_ret or GetPreferenceColor();
            p172.ItemName.TextColor3 = v175;
            p172.Keybind.TextColor3 = v175;
            p172.Icon.ImageColor3 = v175;
            p172.Cost.TextColor3 = v175;
        end;
    end;

    local RequiredItems = TutorialPurchaseLock.getRequiredItems(LocalPlayer);
    local v179;

    if RequiredItems and table.find(RequiredItems, Attribute2) then
        local v180;

        if p171 then
            v180 = GetInventoryItemCount(p171, Attribute2) > 0;
        else
            v180 = p171;
        end;

        v179 = not v180;
    else
        v179 = false;
    end;

    SyncTutorialPulse(p172, v175, v179);

    if p172.Visible then
        local v181 = false;
        local v182 = false;

        if Attribute then
            v181 = IsEquipmentOwnedBy(LocalPlayer, Attribute2);
        elseif p171 then
            v181 = GetInventoryItemCount(p171, Attribute2) > 0;
            local v183 = GetInventoryItemCount(p171, Attribute2);
            local v184 = Grenades[Attribute2];

            if v184 then
                v182 = v183 < v184;
            elseif v183 == 0 then
                v182 = true;
            else
                v182 = false;
            end;
        end;

        local Attribute3 = workspace:GetAttribute("Gamemode");
        local Return = p172.Return;

        if v181 then
            if Attribute3 == "Deathmatch" or (Attribute3 == "Tutorial" or GameState.GetState() == "Warmup") then
                Attribute = false;
            elseif not Attribute then
                local v185 = u12[LocalPlayer:GetAttribute("Team")];
                local v186;

                if v185 then
                    v186 = table.find(v185, Attribute2) ~= nil;
                else
                    v186 = false;
                end;

                local v187;

                if v186 then
                    v187 = not p171 and true or not QueryRoundPurchasedInventoryItem(p171, Attribute2);
                else
                    v187 = false;
                end;

                Attribute = not v187;
            end;
        else
            Attribute = v181;
        end;

        Return.Visible = Attribute;
        p172.Hover.Visible = v181;

        if not v181 then
            p172.Hover.UIStroke.Transparency = 1;

            return;
        end;

        TweenService:Create(p172.Hover.UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = v182 and 1 or 0
        }):Play();
    end;

    UpdateTemplateTeammateIndicators(p172);
end;

local function getDroppedCategory(p188) -- Line: 1181
    local Slot = p188.Slot;

    if Slot == "Grenade" then
        return "Grenades";
    end;

    if Slot == "Secondary" then
        return "Pistols";
    end;

    if Slot ~= "Primary" then
        return nil;
    end;

    local Type = p188.Type;

    return (Type == "SMG" or Type == "Heavy") and "Mid Tier" or "Rifles";
end;

local function getCategoryTemplateCount(p189: userdata) -- Line: 1199
    local v190 = 0;

    for _, child in ipairs(p189:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Template" then
            v190 = v190 + 1;
        end;
    end;

    return v190;
end;

local function setDroppedLabelDimmed(p191: userdata?, p192: string, p193: string, p194: boolean, p195: number) -- Line: 1210
    if not p191 then
        return;
    end;

    if p194 then
        p191:SetAttribute("_OrigColor", p191[p192]);
        p191:SetAttribute("_OrigTrans", p191[p193]);
        p191[p192] = Color3.new(1, 1, 1);
        p191[p193] = p195;

        return;
    end;

    local Attribute = p191:GetAttribute("_OrigColor");
    local Attribute2 = p191:GetAttribute("_OrigTrans");

    if Attribute then
        p191[p192] = Attribute;
    end;

    if Attribute2 ~= nil then
        p191[p193] = Attribute2;
    end;
end;

local function setDroppedTemplatePickedUp(p196: userdata, p197: boolean) -- Line: 1238
    -- upvalues: setDroppedLabelDimmed (copy)
    local ImageLabel = p196:FindFirstChild("ImageLabel");
    local TextLabel = p196:FindFirstChild("TextLabel");

    if p197 then
        p196:SetAttribute("_OrigBG", p196.BackgroundColor3);
        p196.BackgroundColor3 = Color3.fromRGB(15, 15, 15);
    else
        local Attribute = p196:GetAttribute("_OrigBG");

        if Attribute then
            p196.BackgroundColor3 = Attribute;
        end;
    end;

    setDroppedLabelDimmed(ImageLabel, "ImageColor3", "ImageTransparency", p197, 0.6);
    setDroppedLabelDimmed(TextLabel, "TextColor3", "TextTransparency", p197, 0.8);
end;

local function isWithinPickupRange(p198: userdata) -- Line: 1254
    -- upvalues: LocalPlayer (copy)
    local v199 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if p198 then
        p198 = p198.PrimaryPart;
    end;

    if v199 and p198 then
        return (v199.Position - p198.Position).Magnitude <= 45;
    end;

    return false;
end;

local u200 = {
    Pistols = 2,
    ["Mid Tier"] = 1,
    Rifles = 1,
    Grenades = 4
};

local function tryPickupDroppedWeapon(p201: userdata, p202: string) -- Line: 1270
    -- upvalues: LocalPlayer (copy), u200 (copy), InventoryController (copy), Grenades (copy), GetWeaponProperties (copy), NumberSlots (copy), Remotes (copy), GetCharacterVelocity (copy), CharacterResolver (copy), u17 (ref)
    local v203 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
    local v204;

    if p201 then
        v204 = p201.PrimaryPart;
    else
        v204 = p201;
    end;

    local v205;

    if v203 and v204 then
        v205 = (v203.Position - v204.Position).Magnitude <= 45;
    else
        v205 = false;
    end;

    if not v205 then
        return;
    end;

    if not p201:GetAttribute("CanPickup") then
        return;
    end;

    local v206 = u200[p202];

    if not v206 then
        return;
    end;

    local CurrentInventory = InventoryController.getCurrentInventory();

    if not CurrentInventory then
        return;
    end;

    local v207 = CurrentInventory[v206];

    if not v207 then
        return;
    end;

    if p202 == "Grenades" then
        local Attribute = p201:GetAttribute("Weapon");

        if #v207._items >= v207._settings._strict_slot_space then
            return;
        end;

        if Grenades[Attribute] then
            local v208 = 0;

            for _, v in ipairs(v207._items) do
                if v.Name == Attribute then
                    v208 = v208 + 1;
                end;
            end;

            if Grenades[Attribute] <= v208 then
                return;
            end;
        end;
    elseif #v207._items >= v207._settings._strict_slot_space then
        local CurrentEquipped = InventoryController.getCurrentEquipped();
        local v209 = false;

        if CurrentEquipped then
            local v210 = GetWeaponProperties(CurrentEquipped.Name);

            if v210 and (NumberSlots[v210.Slot] == v206 and CurrentEquipped.drop) then
                CurrentEquipped:drop();
                v209 = true;
            end;
        end;

        if not v209 then
            local v211 = v207._items[1];

            if not (v211 and (v211.Properties and v211.Properties.Droppable)) then
                return;
            end;

            if CurrentEquipped and CurrentEquipped.Identifier == v211.Identifier then
                CurrentEquipped:unequip();
            end;

            Remotes.Inventory.DropWeapon.Send({
                CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
                Direction = workspace.CurrentCamera.CFrame.LookVector,
                Identifier = v211.Identifier
            });
        end;
    end;

    if p202 ~= "Grenades" then
        u17 = v206;
    end;

    Remotes.Inventory.PickupWeapon.Send({
        AllowAutoEquip = true,
        Identity = p201.Name
    });
end;

local function getDroppedKey(p212: string, p213: string) -- Line: 1350
    return p212 .. "::" .. p213;
end;

local function findClosestModelInEntry(p214: table) -- Line: 1354
    -- upvalues: LocalPlayer (copy)
    local v215 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if not v215 then
        return nil;
    end;

    local v216 = (1 / 0);
    local v217 = nil;

    for i in pairs(p214.models) do
        if i and (i.Parent and (i.PrimaryPart and i:GetAttribute("CanPickup"))) then
            local Magnitude = (v215.Position - i.PrimaryPart.Position).Magnitude;

            if Magnitude <= 45 and Magnitude < v216 then
                v217 = i;
                v216 = Magnitude;
            end;
        end;
    end;

    return v217;
end;

local function hasAnyModelInRange(p218: table) -- Line: 1373
    -- upvalues: LocalPlayer (copy)
    local v219 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if not v219 then
        return false;
    end;

    for i in pairs(p218.models) do
        if i and (i.Parent and (i.PrimaryPart and (v219.Position - i.PrimaryPart.Position).Magnitude <= 45)) then
            return true;
        end;
    end;

    return false;
end;

local function updateDroppedTemplateRangeStates() -- Line: 1388
    -- upvalues: Profiler (copy), u15 (copy), hasAnyModelInRange (copy), setDroppedTemplatePickedUp (copy)
    Profiler.mark("UI.BuyMenu.UpdateDroppedTemplateRangeStates");

    for _, v in pairs(u15) do
        if next(v.models) then
            local v220 = hasAnyModelInRange(v);
            local Attribute = v.template:GetAttribute("_OutOfRange");

            if v220 or Attribute then
                if v220 and Attribute then
                    v.template:SetAttribute("_OutOfRange", nil);
                    local template = v.template;
                    local ImageLabel = template:FindFirstChild("ImageLabel");
                    local TextLabel = template:FindFirstChild("TextLabel");
                    local Attribute2 = template:GetAttribute("_OrigBG");

                    if Attribute2 then
                        template.BackgroundColor3 = Attribute2;
                    end;

                    if ImageLabel then
                        local Attribute3 = ImageLabel:GetAttribute("_OrigColor");
                        local Attribute4 = ImageLabel:GetAttribute("_OrigTrans");

                        if Attribute3 then
                            ImageLabel.ImageColor3 = Attribute3;
                        end;

                        if Attribute4 ~= nil then
                            ImageLabel.ImageTransparency = Attribute4;
                        end;
                    end;

                    if TextLabel then
                        local Attribute3 = TextLabel:GetAttribute("_OrigColor");
                        local Attribute4 = TextLabel:GetAttribute("_OrigTrans");

                        if Attribute3 then
                            TextLabel.TextColor3 = Attribute3;
                        end;

                        if Attribute4 ~= nil then
                            TextLabel.TextTransparency = Attribute4;
                        end;
                    end;
                end;
            else
                v.template:SetAttribute("_OutOfRange", true);
                setDroppedTemplatePickedUp(v.template, true);
            end;
        end;
    end;
end;

local function getModelCount(p221: table) -- Line: 1406
    local v222 = 0;

    for _ in pairs(p221) do
        v222 = v222 + 1;
    end;

    return v222;
end;

local function updateDroppedTemplateLabel(p223: table) -- Line: 1414
    local TextLabel = p223.template:FindFirstChild("TextLabel");

    if not TextLabel then
        return;
    end;

    local v224 = 0;

    for _ in pairs(p223.models) do
        v224 = v224 + 1;
    end;

    if v224 > 1 then
        TextLabel.Text = `x{v224} {p223.weaponName}`;

        return;
    end;

    TextLabel.Text = p223.weaponName;
end;

local function onWeaponDropped(p225: userdata) -- Line: 1427
    -- upvalues: IsTutorialMode (copy), LocalPlayer (copy), GetWeaponProperties (copy), u15 (copy), u16 (copy), u8 (ref), getCategoryTemplateCount (copy), GetPreferenceColor (copy), findClosestModelInEntry (copy), Router (copy), tryPickupDroppedWeapon (copy), u14 (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" or IsTutorialMode() then
        return;
    end;

    local Attribute = p225:GetAttribute("Weapon");

    if not Attribute then
        return;
    end;

    if p225:GetAttribute("DroppedByTeam") ~= LocalPlayer:GetAttribute("Team") then
        return;
    end;

    local v226 = GetWeaponProperties(Attribute);

    if not v226 then
        return;
    end;

    local Slot = v226.Slot;
    local u227;

    if Slot == "Grenade" then
        u227 = "Grenades";
    elseif Slot == "Secondary" then
        u227 = "Pistols";
    elseif Slot == "Primary" then
        local Type = v226.Type;
        u227 = (Type == "SMG" or Type == "Heavy") and "Mid Tier" or "Rifles";
    else
        u227 = nil;
    end;

    if not u227 then
        return;
    end;

    local v228 = u227 .. "::" .. Attribute;
    local v229 = u15[v228];

    if v229 then
        v229.models[p225] = true;
        u16[p225] = v228;
        v229.template:SetAttribute("_OutOfRange", nil);
        local template = v229.template;
        local ImageLabel = template:FindFirstChild("ImageLabel");
        local TextLabel = template:FindFirstChild("TextLabel");
        local Attribute2 = template:GetAttribute("_OrigBG");

        if Attribute2 then
            template.BackgroundColor3 = Attribute2;
        end;

        if ImageLabel then
            local Attribute3 = ImageLabel:GetAttribute("_OrigColor");
            local Attribute4 = ImageLabel:GetAttribute("_OrigTrans");

            if Attribute3 then
                ImageLabel.ImageColor3 = Attribute3;
            end;

            if Attribute4 ~= nil then
                ImageLabel.ImageTransparency = Attribute4;
            end;
        end;

        if TextLabel then
            local Attribute3 = TextLabel:GetAttribute("_OrigColor");
            local Attribute4 = TextLabel:GetAttribute("_OrigTrans");

            if Attribute3 then
                TextLabel.TextColor3 = Attribute3;
            end;

            if Attribute4 ~= nil then
                TextLabel.TextTransparency = Attribute4;
            end;
        end;

        local TextLabel2 = v229.template:FindFirstChild("TextLabel");

        if TextLabel2 then
            local v230 = 0;

            for _ in pairs(v229.models) do
                v230 = v230 + 1;
            end;

            if v230 > 1 then
                TextLabel2.Text = `x{v230} {v229.weaponName}`;
            else
                TextLabel2.Text = v229.weaponName;
            end;
        end;

        local ImageButton = v229.template:FindFirstChild("ImageButton");

        if ImageButton then
            ImageButton.Active = true;
        end;

        return;
    end;

    local Dropped = u8.Menu:FindFirstChild("Dropped");

    if not Dropped then
        return;
    end;

    local Container = Dropped:FindFirstChild("Container");

    if not Container then
        return;
    end;

    local v231 = Container:FindFirstChild(u227);

    if not v231 then
        return;
    end;

    if getCategoryTemplateCount(v231) >= 4 then
        return;
    end;

    local Template = Container:FindFirstChild("Template");

    if not Template then
        return;
    end;

    local v232 = Template:Clone();
    v232.Name = v228;
    v232.Visible = true;
    v232.Parent = v231;
    local v233 = v226.ReverseIcon or v226.Icon;
    local ImageLabel = v232:FindFirstChild("ImageLabel");
    local TextLabel = v232:FindFirstChild("TextLabel");
    local ImageButton = v232:FindFirstChild("ImageButton");

    if ImageLabel then
        ImageLabel.Image = v233;
        ImageLabel.ImageColor3 = GetPreferenceColor();
    end;

    if TextLabel then
        TextLabel.Text = Attribute;
        TextLabel.TextColor3 = GetPreferenceColor();
    end;

    local u234 = {
        template = v232,
        category = u227,
        weaponName = Attribute,
        models = {
            [p225] = true
        }
    };
    u15[v228] = u234;
    u16[p225] = v228;

    if ImageButton then
        u14:Add((ImageButton.MouseButton1Click:Connect(function() -- Line: 1524
            -- upvalues: findClosestModelInEntry (ref), u234 (copy), Router (ref), tryPickupDroppedWeapon (ref), u227 (copy)
            local v235 = findClosestModelInEntry(u234);

            if v235 then
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                tryPickupDroppedWeapon(v235, u227);
            end;
        end)));
    end;
end;

local function onWeaponDropRemoved(p236: userdata) -- Line: 1535
    -- upvalues: u16 (copy), u15 (copy), setDroppedTemplatePickedUp (copy)
    local v237 = u16[p236];

    if not v237 then
        return;
    end;

    u16[p236] = nil;
    local v238 = u15[v237];

    if not v238 then
        return;
    end;

    v238.models[p236] = nil;

    if next(v238.models) then
        local TextLabel = v238.template:FindFirstChild("TextLabel");

        if not TextLabel then
            return;
        end;

        local v239 = 0;

        for _ in pairs(v238.models) do
            v239 = v239 + 1;
        end;

        if v239 > 1 then
            TextLabel.Text = `x{v239} {v238.weaponName}`;

            return;
        end;

        TextLabel.Text = v238.weaponName;
    else
        v238.template:SetAttribute("_OutOfRange", nil);
        setDroppedTemplatePickedUp(v238.template, true);
        local ImageButton = v238.template:FindFirstChild("ImageButton");

        if ImageButton then
            ImageButton.Active = false;
        end;
    end;
end;

local function updateDroppedFrameVisibility() -- Line: 1561
    -- upvalues: u8 (ref), IsTutorialMode (copy)
    local v240 = u8 and u8.Menu and u8.Menu:FindFirstChild("Dropped");

    if not v240 then
        return;
    end;

    local v241;

    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        v241 = false;
    else
        v241 = not IsTutorialMode();
    end;

    v240.Visible = v241;
end;

local function cleanupAllDroppedEntries() -- Line: 1570
    -- upvalues: u15 (copy), u16 (copy), u14 (copy), u8 (ref)
    for _, v in pairs(u15) do
        v.template:Destroy();
    end;

    table.clear(u15);
    table.clear(u16);
    u14:Cleanup();
    local v242 = u8 and u8.Menu and u8.Menu:FindFirstChild("Dropped");

    if not v242 then
        return;
    end;

    local Container = v242:FindFirstChild("Container");

    if not Container then
        return;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Template" then
            for _, child2 in ipairs(child:GetChildren()) do
                if child2:IsA("Frame") then
                    child2:Destroy();
                end;
            end;
        end;
    end;
end;

local function updateBuyMenuHeartbeat(p243: number) -- Line: 1597
    -- upvalues: Profiler (copy), u5 (copy), u8 (ref), GetPreferenceColor (copy), IsInBuyArea (copy), LocalPlayer (copy), u1 (copy), IsTutorialMode (copy), InventoryController (copy), TutorialPurchaseLock (copy), GetInventoryItemCount (copy), u7 (ref), updateDroppedTemplateRangeStates (copy)
    Profiler.mark("UI.BuyMenu.Heartbeat");
    local Position = u5:getPosition();
    local math_round_ret = math.round(Position);
    local v244 = tostring(math_round_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    u8.Menu.TopFrame.Money.TextColor3 = GetPreferenceColor();
    u8.Menu.TopFrame.Money.Text = "$" .. v244;
    u5:update(p243);

    if u8.Visible and not IsInBuyArea(LocalPlayer) then
        local Attribute = workspace:GetAttribute("Gamemode");

        if Attribute == "Bomb Defusal" or Attribute == "Hostage Rescue" then
            u1.closeFrame();

            return;
        end;
    end;

    if u8.Visible and IsTutorialMode() then
        local CurrentInventory = InventoryController.getCurrentInventory();

        if TutorialPurchaseLock.isWaitingOnPurchase(LocalPlayer, function(p245: string) -- Line: 657
            -- upvalues: CurrentInventory (copy), GetInventoryItemCount (ref)
            if CurrentInventory then
                return GetInventoryItemCount(CurrentInventory, p245) > 0;
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

local function startBuyMenuUpdate() -- Line: 1631
    -- upvalues: u20 (ref), RunServiceController (copy), updateBuyMenuHeartbeat (copy)
    if u20 then
        return;
    end;

    u20 = RunServiceController.BindToHeartbeat("UI.BuyMenu.Update", updateBuyMenuHeartbeat);
    updateBuyMenuHeartbeat(0);
end;

local function stopBuyMenuUpdate() -- Line: 1640
    -- upvalues: u20 (ref)
    if u20 then
        u20:Disconnect();
        u20 = nil;
    end;
end;

local function NotifyTutorial(p246: string) -- Line: 1651
    -- upvalues: IsTutorialMode (copy), Remotes (copy)
    if not IsTutorialMode() then
        return;
    end;

    Remotes.Tutorial.ClientEvent.Send(p246);
end;

function u1.openFrame() -- Line: 1658
    -- upvalues: EndScreenController (copy), LocalPlayer (copy), IsInBuyArea (copy), TutorialPurchaseLock (copy), u8 (ref), CameraController (copy), u9 (ref), u20 (ref), RunServiceController (copy), updateBuyMenuHeartbeat (copy), RequestCompetitiveTeammateInventories (copy), UpdateAllTeammateIndicators (copy), IsTutorialMode (copy), Remotes (copy)
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

    if not u20 then
        u20 = RunServiceController.BindToHeartbeat("UI.BuyMenu.Update", updateBuyMenuHeartbeat);
        updateBuyMenuHeartbeat(0);
    end;

    if u8 and u8.WeaponInfoFrame then
        u8.WeaponInfoFrame.Visible = false;
    end;

    RequestCompetitiveTeammateInventories();
    UpdateAllTeammateIndicators();

    if not IsTutorialMode() then
        return;
    end;

    Remotes.Tutorial.ClientEvent.Send("OpenedBuyMenu");
end;

function u1.closeFrame() -- Line: 1694
    -- upvalues: u8 (ref), CameraController (copy), u9 (ref), GetPlayerArmorState (copy), LocalPlayer (copy), u20 (ref), u7 (ref), IsTutorialMode (copy), Remotes (copy)
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

    if u20 then
        u20:Disconnect();
        u20 = nil;
    end;

    if u8 and u8.WeaponInfoFrame then
        u8.WeaponInfoFrame.Visible = false;
    end;

    u7 = false;

    if not IsTutorialMode() then
        return;
    end;

    Remotes.Tutorial.ClientEvent.Send("ClosedBuyMenu");
end;

function u1.toggleFrame() -- Line: 1715
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

        if TutorialPurchaseLock.isWaitingOnPurchase(LocalPlayer, function(p247: string) -- Line: 657
            -- upvalues: CurrentInventory (copy), GetInventoryItemCount (ref)
            if CurrentInventory then
                return GetInventoryItemCount(CurrentInventory, p247) > 0;
            end;

            return false;
        end) then
            return;
        end;

        u1.closeFrame();
    end;
end;

function u1.characterAdded(p248: userdata) -- Line: 1736
    -- upvalues: WaitForAttribute (copy), LocalPlayer (copy), u3 (copy), setupBuyMenuTemplates (copy)
    if not WaitForAttribute(LocalPlayer, "Money") then
        return;
    end;

    u3:Cleanup();
    setupBuyMenuTemplates();
end;

function u1.Initialize(p249, p250) -- Line: 1751
    -- upvalues: u9 (ref), u8 (ref), UpdateBuyMenuTimerText (copy), InventoryController (copy), u1 (copy), LocalPlayer (copy), u4 (copy), u18 (copy), RequestCompetitiveTeammateInventory (copy), UpdateAllTeammateIndicators (copy), u2 (copy), Profiler (copy), u19 (copy), Players (copy), Remotes (copy), RequestCompetitiveTeammateInventories (copy), Observers (copy), cleanupAllDroppedEntries (copy), u3 (copy), setupBuyMenuTemplates (copy), IsTutorialMode (copy), u6 (copy), RemoveFromArray (copy), u5 (copy), GameState (copy), DataController (copy), u15 (copy), GetPreferenceColor (copy), onWeaponDropped (copy), onWeaponDropRemoved (copy)
    u9 = p249;
    u8 = p250;
    UpdateBuyMenuTimerText();

    local function refreshBuyMenuTemplates() -- Line: 1755
        -- upvalues: InventoryController (ref), u8 (ref), u1 (ref)
        local CurrentInventory = InventoryController.getCurrentInventory();

        for _, descendant in ipairs(u8.Menu.Container:GetDescendants()) do
            if descendant:IsA("TextButton") then
                u1.updateBuyMenuTemplate(CurrentInventory, descendant);
            end;
        end;
    end;

    local function trackCompetitiveTeammate(u251: userdata) -- Line: 1764
        -- upvalues: LocalPlayer (ref), u4 (ref), u18 (ref), RequestCompetitiveTeammateInventory (ref), UpdateAllTeammateIndicators (ref), u2 (ref)
        if u251 == LocalPlayer then
            return;
        end;

        u4:Add(u251:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 1769
            -- upvalues: u251 (copy), LocalPlayer (ref), u18 (ref), RequestCompetitiveTeammateInventory (ref), UpdateAllTeammateIndicators (ref)
            if u251:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
                u18[u251] = nil;
            end;

            RequestCompetitiveTeammateInventory(u251);
            UpdateAllTeammateIndicators();
        end));

        for _, v in ipairs(u2) do
            u4:Add(u251:GetAttributeChangedSignal(v):Connect(UpdateAllTeammateIndicators));
        end;

        for i = 1, 5 do
            u4:Add(u251:GetAttributeChangedSignal("Slot" .. i):Connect(function() -- Line: 1783
                -- upvalues: RequestCompetitiveTeammateInventory (ref), u251 (copy), UpdateAllTeammateIndicators (ref)
                RequestCompetitiveTeammateInventory(u251);
                UpdateAllTeammateIndicators();
            end));
            local _ = i;
        end;
    end;

    (function() -- Line: 1790, Name: setupCompetitiveTeammateObservers
        -- upvalues: Profiler (ref), u4 (ref), u18 (ref), u19 (ref), Players (ref), trackCompetitiveTeammate (copy), RequestCompetitiveTeammateInventory (ref), UpdateAllTeammateIndicators (ref), Remotes (ref), LocalPlayer (ref), RequestCompetitiveTeammateInventories (ref)
        Profiler.mark("UI.BuyMenu.SetupCompetitiveTeammateObservers");
        u4:Cleanup();
        table.clear(u18);
        table.clear(u19);
        u4:Add(Players.PlayerAdded:Connect(function(p252) -- Line: 1795
            -- upvalues: trackCompetitiveTeammate (ref), RequestCompetitiveTeammateInventory (ref), UpdateAllTeammateIndicators (ref)
            trackCompetitiveTeammate(p252);
            RequestCompetitiveTeammateInventory(p252);
            UpdateAllTeammateIndicators();
        end));
        u4:Add(Players.PlayerRemoving:Connect(function(p253) -- Line: 1800
            -- upvalues: u18 (ref), u19 (ref), UpdateAllTeammateIndicators (ref)
            u18[p253] = nil;
            u19[p253] = nil;
            UpdateAllTeammateIndicators();
        end));
        u4:Add(Remotes.Inventory.SpectatedPlayerInventory.Listen(function(p254: table) -- Line: 1805
            -- upvalues: LocalPlayer (ref), u18 (ref), u19 (ref), UpdateAllTeammateIndicators (ref)
            if p254.Player == LocalPlayer then
                return;
            end;

            u18[p254.Player] = p254.Inventory;
            u19[p254.Player] = nil;
            UpdateAllTeammateIndicators();
        end));

        for _, v in ipairs(Players:GetPlayers()) do
            trackCompetitiveTeammate(v);
        end;

        RequestCompetitiveTeammateInventories();
        UpdateAllTeammateIndicators();
    end)();
    Observers.observeAttribute(LocalPlayer, "Team", function() -- Line: 1831
        -- upvalues: cleanupAllDroppedEntries (ref), u18 (ref), u19 (ref), u3 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy)
        cleanupAllDroppedEntries();
        table.clear(u18);
        table.clear(u19);
        u3:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
    end);
    Observers.observeAttribute(workspace, "Gamemode", function() -- Line: 1840
        -- upvalues: u8 (ref), IsTutorialMode (ref), cleanupAllDroppedEntries (ref), u3 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy)
        local v255 = u8 and u8.Menu and u8.Menu:FindFirstChild("Dropped");

        if v255 then
            local v256;

            if workspace:GetAttribute("Gamemode") == "Deathmatch" then
                v256 = false;
            else
                v256 = not IsTutorialMode();
            end;

            v255.Visible = v256;
        end;

        cleanupAllDroppedEntries();
        u3:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
    end);
    local v257 = u8 and u8.Menu and u8.Menu:FindFirstChild("Dropped");

    if v257 then
        local v258;

        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            v258 = false;
        else
            v258 = not IsTutorialMode();
        end;

        v257.Visible = v258;
    end;

    Observers.observeAttribute(workspace, "ServerGamemode", function() -- Line: 1853
        -- upvalues: u8 (ref), IsTutorialMode (ref), u3 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy)
        local v259 = u8 and u8.Menu and u8.Menu:FindFirstChild("Dropped");

        if v259 then
            local v260;

            if workspace:GetAttribute("Gamemode") == "Deathmatch" then
                v260 = false;
            else
                v260 = not IsTutorialMode();
            end;

            v259.Visible = v260;
        end;

        u3:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
    end);
    Remotes.Inventory.NewInventoryItem.Listen(function(p261) -- Line: 1863
        -- upvalues: u6 (ref), refreshBuyMenuTemplates (copy)
        if p261.isPurchase ~= true then
            return;
        end;

        table.insert(u6, p261.identifier);
        refreshBuyMenuTemplates();
    end);
    Remotes.Inventory.RemoveInventoryItem.Listen(function(u262) -- Line: 1873
        -- upvalues: RemoveFromArray (ref), u6 (ref)
        RemoveFromArray(u6, function(p263, p264) -- Line: 1874
            -- upvalues: u262 (copy)
            return p264 == u262;
        end);
    end);
    Observers.observeAttribute(LocalPlayer, "MinimumNextRoundIncome", function(p265) -- Line: 1880
        -- upvalues: u8 (ref)
        u8.Menu.TopFrame.NextRoundMoney.Text = "Next Round Minimum:  $" .. tostring(p265):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end);
    Observers.observeAttribute(LocalPlayer, "Money", function(p266) -- Line: 1885
        -- upvalues: u5 (ref), refreshBuyMenuTemplates (copy)
        u5:setGoal(p266);
        refreshBuyMenuTemplates();
    end);

    for _, v in ipairs({ "Armor", "HasDefuseKit", "HasRescueKit" }) do
        Observers.observeAttribute(LocalPlayer, v, refreshBuyMenuTemplates);
    end;

    Observers.observeAttribute(workspace, "VIPInfiniteCashEnabled", refreshBuyMenuTemplates);
    Observers.observeAttribute(LocalPlayer, "Team", function() -- Line: 1895
        -- upvalues: setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy)
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
    end);
    Observers.observeAttribute(LocalPlayer, "TutorialStep", function() -- Line: 1900
        -- upvalues: refreshBuyMenuTemplates (copy)
        refreshBuyMenuTemplates();
    end);
    Observers.observeAttribute(LocalPlayer, "BuyMenu", function() -- Line: 1905
        -- upvalues: u1 (ref)
        return function() -- Line: 1906
            -- upvalues: u1 (ref)
            u1.closeFrame();
        end;
    end);
    Observers.observeAttribute(workspace, "Timer", UpdateBuyMenuTimerText);
    Observers.observeAttribute(workspace, "BuyTimerRemaining", UpdateBuyMenuTimerText);
    GameState.ListenToState(function(p267, p268) -- Line: 1916
        -- upvalues: u6 (ref), cleanupAllDroppedEntries (ref), UpdateBuyMenuTimerText (ref)
        if p268 == "Buy Period" then
            table.clear(u6);
            cleanupAllDroppedEntries();
        end;

        UpdateBuyMenuTimerText();
    end);
    InventoryController.OnInventoryChanged:Connect(function(p269) -- Line: 1926
        -- upvalues: u8 (ref), u1 (ref)
        for _, descendant in ipairs(u8.Menu.Container:GetDescendants()) do
            if descendant:IsA("TextButton") then
                u1.updateBuyMenuTemplate(p269, descendant);
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 1935
        -- upvalues: refreshBuyMenuTemplates (copy), u15 (ref), GetPreferenceColor (ref)
        refreshBuyMenuTemplates();

        for _, v in pairs(u15) do
            if not v.template:GetAttribute("_OrigBG") then
                local ImageLabel = v.template:FindFirstChild("ImageLabel");
                local TextLabel = v.template:FindFirstChild("TextLabel");

                if ImageLabel then
                    ImageLabel.ImageColor3 = GetPreferenceColor();
                end;

                if TextLabel then
                    TextLabel.TextColor3 = GetPreferenceColor();
                end;
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 1954
        -- upvalues: LocalPlayer (ref), u3 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy)
        if not LocalPlayer.Character then
            return;
        end;

        u3:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
    end);
    Observers.observeTag("WeaponDropped", function(u270: userdata) -- Line: 1966
        -- upvalues: onWeaponDropped (ref), onWeaponDropRemoved (ref)
        onWeaponDropped(u270);

        return function() -- Line: 1968
            -- upvalues: onWeaponDropRemoved (ref), u270 (copy)
            onWeaponDropRemoved(u270);
        end;
    end);
end;

function u1.Start() -- Line: 1974
    -- upvalues: LocalPlayer (copy), u1 (copy), CharacterResolver (copy)
    if LocalPlayer.Character then
        u1.characterAdded(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(u1.characterAdded);
    CharacterResolver.observeCharacter(LocalPlayer, function(u271: userdata?) -- Line: 1983
        -- upvalues: u1 (ref)
        if not u271 then
            u1.closeFrame();

            return nil;
        end;

        local function closeWhenDead() -- Line: 1989
            -- upvalues: u271 (copy), u1 (ref)
            if u271:GetAttribute("Dead") == true then
                u1.closeFrame();
            end;
        end;

        if u271:GetAttribute("Dead") == true then
            u1.closeFrame();
        end;

        local u272 = u271:GetAttributeChangedSignal("Dead"):Connect(closeWhenDead);

        return function() -- Line: 1998
            -- upvalues: u272 (copy)
            u272:Disconnect();
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(function() -- Line: 2003
        -- upvalues: LocalPlayer (ref), u1 (ref)
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            u1.closeFrame();
        end;
    end);
end;

return u1;