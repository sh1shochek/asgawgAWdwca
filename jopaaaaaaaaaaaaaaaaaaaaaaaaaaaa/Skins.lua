-- ReplicatedStorage.Database.Components.Libraries.Skins
-- Script path: ReplicatedStorage.Database.Components.Libraries.Skins
-- Decompile time: 15.29 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local u2 = nil;
local Signal = require(ReplicatedStorage.Packages.Signal);
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Weapons = Assets:WaitForChild("Weapons");
local Skins = Assets:WaitForChild("Skins");
local u3 = Signal.new();
u1.OnItemStockSchemasUpdated = u3;
local u4 = {};
local u5 = {};
local u6 = { {
        max = 0.07,
        wear = "Factory New"
    }, {
        max = 0.15,
        wear = "Minimal Wear"
    }, {
        max = 0.38,
        wear = "Field-Tested"
    }, {
        max = 0.45,
        wear = "Well-Worn"
    }, {
        max = 1,
        wear = "Battle-Scarred"
    } };
local table_freeze_ret = table.freeze({
    Weapon = true,
    WeaponL = true,
    WeaponR = true,
    CharmBase = true,
    KillTrak = true,
    KillTrackKnife = true,
    NamePlate = true
});
local table_freeze_ret2 = table.freeze({
    ScopeSplit = true,
    Lighter = true,
    Ammo = true,
    Bullet = true,
    Shell = true,
    EmptyShell = true,
    ReadyShell = true,
    Casing = true,
    Speedloader = true,
    RigPoints = true,
    ViewmodelLight = true
});
local u7 = {
    ["Factory New"] = "Mint Condition",
    ["Minimal Wear"] = "Near-Mint",
    ["Field-Tested"] = "Standard-Grade",
    ["Well-Worn"] = "Combat-Worn",
    ["Battle-Scarred"] = "War-Torn"
};

local function GetDataController() -- Line: 86
    -- upvalues: u2 (ref), ReplicatedStorage (copy)
    if not u2 then
        local success, result = pcall(function() -- Line: 88
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.DataController);
        end);

        if success then
            u2 = result;
        end;
    end;

    return u2;
end;

local function ResolveCharmFromId(p8: string) -- Line: 100
    -- upvalues: u2 (ref), ReplicatedStorage (copy), Players (copy)
    if not u2 then
        local success, result = pcall(function() -- Line: 88
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.DataController);
        end);

        if success then
            u2 = result;
        end;
    end;

    local v9 = u2;

    if not v9 then
        return nil;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return nil;
    end;

    local v10 = v9.Get(LocalPlayer, "Inventory");

    if not v10 or typeof(v10) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v10) do
        if v._id == p8 and v.Type == "Charm" then
            return {
                Skin = v.Skin,
                Pattern = v.Pattern
            };
        end;
    end;

    return nil;
end;

local function ValidateInputs(p11: string, p12: string) -- Line: 131
    local v13;

    if typeof(p11) == "string" and (typeof(p12) == "string" and p11 ~= "") then
        v13 = p12 ~= "";
    else
        v13 = false;
    end;

    return v13;
end;

local function Weld(p14: userdata, p15: userdata) -- Line: 137
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p14;
    WeldConstraint.Part1 = p15;
    WeldConstraint.Parent = p14;
end;

local function UpdateAvailableSkins(p16: string) -- Line: 146
    -- upvalues: u4 (ref), HttpService (copy), u3 (copy)
    u4 = HttpService:JSONDecode(p16);

    if #u3:GetConnections() > 0 then
        u3:Fire(u4);
    end;
end;

local function CreateSyntheticStockSchema(p17: string) -- Line: 155
    -- upvalues: GetWeaponProperties (copy)
    local v18 = GetWeaponProperties(p17);

    return v18 and {
        paintId = "stock",
        skin = "Stock",
        rarity = "Stock",
        supportsStatTrak = false,
        statTrakChance = 0,
        isEnabled = true,
        isMarketplaceVisible = false,
        collection = nil,
        description = "Standard issue finish.",
        caseRarity = "Stock",
        type = v18.Class,
        name = p17,
        floatRange = {
            min = 0,
            max = 0.07
        },
        floatChances = { {
                wear = "Factory New",
                chance = 100
            } },
        charmImages = {},
        wearImages = {},
        imageAssetId = v18.Icon or v18.ReverseIcon
    } or nil;
end;

local function GetSyntheticStockSchema(p19: string) -- Line: 192
    -- upvalues: u5 (copy), CreateSyntheticStockSchema (copy)
    local v20 = u5[p19] or CreateSyntheticStockSchema(p19);
    u5[p19] = v20;

    return v20;
end;

local function GetKillTrackValue(p21: any, p22: string) -- Line: 200
    -- upvalues: GetWeaponProperties (copy)
    local v23 = p21 or 0;
    local v24 = typeof(v23) == "number";
    assert(v24, "KillCount must be a number");
    local success, result = pcall(GetWeaponProperties, p22);

    if not (success and result) then
        return nil;
    end;

    if result.Class == "Melee" then
        local math_floor_ret = math.floor(v23);
        local math_clamp_ret = math.clamp(math_floor_ret, 0, 9999);

        return tostring(math_clamp_ret);
    end;

    local string_format = string.format;
    local math_floor_ret = math.floor(v23);

    return string_format("%06d", (math.clamp(math_floor_ret, 0, 999999)));
end;

local function GetWeaponFolder(p25: string) -- Line: 216
    -- upvalues: Weapons (copy)
    local v26 = Weapons:FindFirstChild(p25);

    if v26 and v26:IsA("Folder") then
        return v26;
    end;

    return nil;
end;

local function GetSkinTextureFolder(p27: string, p28: string, p29: string?) -- Line: 224
    -- upvalues: Skins (copy)
    local v30 = Skins:FindFirstChild(p27);

    if not v30 then
        return nil;
    end;

    if p29 and p27 == "Smoke Grenade" then
        local v31 = v30:FindFirstChild(p29);

        if v31 and v31:IsA("Folder") then
            return v31;
        end;
    end;

    local v32 = v30:FindFirstChild(p28);

    if v32 and v32:IsA("Folder") then
        return v32;
    end;

    return nil;
end;

local function GetSkinVariantFolder(p33: string, p34: string, p35: string?, p36: string) -- Line: 244
    -- upvalues: GetSkinTextureFolder (copy)
    local v37 = GetSkinTextureFolder(p33, p34, p35);

    if v37 then
        v37 = v37:FindFirstChild(p36);
    end;

    return v37;
end;

local function GetWearFromFloat(p38: any, p39: number) -- Line: 251
    -- upvalues: u6 (copy), u7 (copy)
    local math_max_ret = math.max(p38.floatRange.min, p38.floatRange.max - 1e-12);
    local math_clamp_ret = math.clamp(p39, p38.floatRange.min, math_max_ret);
    local math_clamp_ret2 = math.clamp(math_clamp_ret, 0, 1);

    for _, v in ipairs(u6) do
        if math_clamp_ret2 < v.max then
            return v.wear, u7[v.wear];
        end;
    end;

    return "Battle-Scarred", "War-Torn";
end;

local function GetWearTextureFolder(p40: userdata?, p41: any, p42: number) -- Line: 268
    -- upvalues: GetWearFromFloat (copy), u6 (copy)
    if not (p40 and p40:IsA("Folder")) then
        return nil;
    end;

    local v43 = GetWearFromFloat(p41, p42);

    if v43 then
        v43 = p40:FindFirstChild(v43);
    end;

    if v43 and v43:IsA("Folder") then
        return v43;
    end;

    for _, v in ipairs(u6) do
        local v44 = p40:FindFirstChild(v.wear);

        if v44 and v44:IsA("Folder") then
            return v44;
        end;
    end;

    return nil;
end;

local function ApplySkinTextures(p45: userdata, p46: userdata?) -- Line: 293
    if not p46 then
        return;
    end;

    for _, child in ipairs(p46:GetChildren()) do
        if child:IsA("SurfaceAppearance") then
            local v47 = child;

            for _, descendant in ipairs(p45:GetDescendants()) do
                if descendant:IsA("MeshPart") and descendant.Name == v47.Name then
                    local v48 = descendant:FindFirstChildOfClass("SurfaceAppearance");

                    if v48 then
                        v48:Destroy();
                    end;

                    v47:Clone().Parent = descendant;
                end;
            end;
        end;
    end;
end;

local function ForEachWeaponPart(p49: userdata, p50: function, ...) -- Line: 320
    local Weapon = p49:FindFirstChild("Weapon");

    if Weapon then
        p50(p49, Weapon, ...);

        return;
    end;

    local WeaponL = p49:FindFirstChild("WeaponL");
    local WeaponR = p49:FindFirstChild("WeaponR");

    if WeaponL then
        p50(p49, WeaponL, ...);
    end;

    if WeaponR then
        p50(p49, WeaponR, ...);
    end;
end;

local function AttachStatTrakToWeapon(p51: userdata, p52: userdata, p53: any, p54: string, p55: boolean) -- Line: 339
    -- upvalues: GetWeaponProperties (copy), Assets (copy), GetKillTrackValue (copy)
    local success, result = pcall(GetWeaponProperties, p54);
    local v56 = Assets.Other[success and (result and result.Class == "Melee") and "KillTrackKnife" or "KillTrak"]:Clone();
    local PrimaryPart = p52.PrimaryPart;
    local v57;

    if PrimaryPart then
        v57 = p52:FindFirstChild("KillTrack", true);
    else
        v57 = PrimaryPart;
    end;

    if not v57 then
        v56:Destroy();

        return;
    end;

    local PrimaryPart2 = v56.PrimaryPart;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = PrimaryPart2;
    WeldConstraint.Part1 = PrimaryPart;
    WeldConstraint.Parent = PrimaryPart2;
    v56:PivotTo(v57.WorldCFrame);
    local SurfaceGui = v56.Screen.SurfaceGui;
    SurfaceGui.TextLabel.Text = GetKillTrackValue(p53, p54);

    if p55 then
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize;
        SurfaceGui.CanvasSize = Vector2.new(100, 25);
        SurfaceGui.TextLabel.TextSize = 29;
        SurfaceGui.TextLabel.Size = UDim2.fromScale(1, 1);
    end;

    v56.Parent = p51;
end;

local function AttachNameTagToWeapon(p58: userdata, p59: userdata, p60: any, p61: boolean) -- Line: 375
    -- upvalues: Assets (copy)
    local v62 = Assets.Other.NamePlate:Clone();
    local PrimaryPart = p59.PrimaryPart;
    local v63;

    if PrimaryPart then
        v63 = PrimaryPart:FindFirstChild("Nametag");
    else
        v63 = PrimaryPart;
    end;

    if not v63 then
        v62:Destroy();

        return;
    end;

    local PrimaryPart2 = v62.PrimaryPart;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = PrimaryPart2;
    WeldConstraint.Part1 = PrimaryPart;
    WeldConstraint.Parent = PrimaryPart2;
    v62:PivotTo(v63.WorldCFrame);
    local SurfaceGui = v62.Screen.SurfaceGui;
    SurfaceGui.TextLabel.Text = tostring(p60);

    if p61 then
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize;
        SurfaceGui.CanvasSize = Vector2.new(100, 8);
        SurfaceGui.TextLabel.TextSize = 8.98;
        SurfaceGui.TextLabel.Size = UDim2.fromScale(0.95, 1);
        SurfaceGui.TextLabel.Position = UDim2.fromOffset(5, 0);
    end;

    v62.Parent = p58;
end;

local function FindCharmModels(p64: string, p65: number) -- Line: 401
    -- upvalues: Assets (copy)
    local Charms = Assets:FindFirstChild("Charms");
    local v66;

    if Charms then
        v66 = Charms:FindFirstChild("CharmBase");
    else
        v66 = Charms;
    end;

    if not (v66 and v66:IsA("Model")) then
        return nil, nil;
    end;

    local v67 = Charms:FindFirstChild(p64);

    if v67 then
        v67 = v67:FindFirstChild((tostring(p65)));
    end;

    if v67 and v67:IsA("Model") then
        return v66, v67;
    end;

    return v66, nil;
end;

local function MountSpecificCharm(p68: userdata, p69: userdata) -- Line: 418
    local v70 = p69:Clone();
    v70.Parent = p68;
    local Part = p68:FindFirstChild("Part");

    if Part and Part:IsA("BasePart") then
        v70:PivotTo(Part.CFrame);
        Part:Destroy();
    end;

    local HingeConstraint = p68:FindFirstChild("HingeConstraint", true);
    local v71 = HingeConstraint and (v70.PrimaryPart and v70.PrimaryPart:FindFirstChild("Attachment"));

    if v71 then
        HingeConstraint.Attachment1 = v71;
    end;
end;

local function AttachCharmToWeapon(p72: userdata, p73: string, p74: number, p75: string, p76: boolean) -- Line: 441
    -- upvalues: FindCharmModels (copy), MountSpecificCharm (copy)
    local v77, v78 = FindCharmModels(p73, p74);

    if not v77 then
        if not p76 then
            warn("Charm base not found for weapon:", p72.Name);
        end;

        return;
    end;

    if not v78 then
        if not p76 then
            warn("Specific charm not found for weapon:", p72.Name, p73, p74);
        end;

        return;
    end;

    local v79 = p72:FindFirstChild("Charm" .. p75, true);

    if not v79 then
        if not p76 then
            print("Charm attachment not found for weapon:", p72.Name, p75);
        end;

        return;
    end;

    local Parent = v79.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        return;
    end;

    local v80 = v77:Clone();
    v80.Parent = p72;
    v80:PivotTo(v79.WorldCFrame);

    if v80.PrimaryPart then
        local PrimaryPart = v80.PrimaryPart;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = PrimaryPart;
        WeldConstraint.Part1 = Parent;
        WeldConstraint.Parent = PrimaryPart;
    end;

    MountSpecificCharm(v80, v78);
end;

local function AttachCharm(p81: userdata, p82: any, p83: boolean) -- Line: 486
    -- upvalues: ResolveCharmFromId (copy), AttachCharmToWeapon (copy)
    if typeof(p82) ~= "table" then
        return;
    end;

    if not (p82._id and p82.Position) then
        return;
    end;

    local Position = p82.Position;
    local v84, v85;

    if p82.Skin and p82.Pattern then
        v84 = p82.Skin;
        v85 = p82.Pattern;
    else
        local v86 = ResolveCharmFromId(p82._id);

        if not v86 then
            return;
        end;

        v84 = v86.Skin;
        v85 = v86.Pattern;
    end;

    if not (v84 and v85) then
        return;
    end;

    if p81:FindFirstChild("Weapon") then
        AttachCharmToWeapon(p81, v84, v85, Position, p83);

        return;
    end;

    local WeaponL = p81:FindFirstChild("WeaponL");
    local WeaponR = p81:FindFirstChild("WeaponR");

    if WeaponL then
        AttachCharmToWeapon(p81, v84, v85, Position, p83);
    end;

    if p83 and WeaponR then
        AttachCharmToWeapon(p81, v84, v85, Position, p83);
    end;
end;

local function WaitForSkinInformation(p87: string, p88: string) -- Line: 536
    -- upvalues: u1 (copy), u4 (ref), u3 (copy)
    local SkinInformation = u1.GetSkinInformation(p87, p88);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p87, p88);
    end;

    return SkinInformation;
end;

local function DecorateModel(p89: userdata, p90: userdata?, p91: any, p92: number?, p93: string, p94: any, p95: any, p96: any, p97: boolean) -- Line: 547
    -- upvalues: ApplySkinTextures (copy), GetWearTextureFolder (copy), ForEachWeaponPart (copy), AttachStatTrakToWeapon (copy), AttachNameTagToWeapon (copy), AttachCharm (copy)
    ApplySkinTextures(p89, (GetWearTextureFolder(p90, p91, p92 or p91.floatRange.max)));

    if p94 then
        ForEachWeaponPart(p89, AttachStatTrakToWeapon, p94, p93, p97);
    end;

    if p95 then
        ForEachWeaponPart(p89, AttachNameTagToWeapon, p95, p97);
    end;

    if p96 then
        AttachCharm(p89, p96, p97);
    end;

    return p89;
end;

function u1.GetCharmModel(p98: string, p99: number) -- Line: 577
    -- upvalues: FindCharmModels (copy), MountSpecificCharm (copy)
    local v100, v101 = FindCharmModels(p98, p99);

    if not v100 then
        warn((`Skins.GetCharmModel: Charm base not found for charm "{p98}" with pattern "{p99}"`));

        return nil;
    end;

    if not v101 then
        warn((`Skins.GetCharmModel: Specific charm not found for charm "{p98}" with pattern "{p99}"`));

        return nil;
    end;

    local v102 = v100:Clone();
    v102.Name = p98;
    MountSpecificCharm(v102, v101);

    return v102;
end;

function u1.GetBadgeModel(p103: string) -- Line: 593
    -- upvalues: Assets (copy)
    local Badges = Assets:FindFirstChild("Badges");

    if not Badges then
        warn((`Skins.GetBadgeModel: Badges folder not found for badge "{p103}"`));

        return nil;
    end;

    local v104 = Badges:FindFirstChild(p103);

    if v104 and v104:IsA("Model") then
        return v104:Clone();
    end;

    warn((`Skins.GetBadgeModel: Badge model not found for "{p103}"`));

    return nil;
end;

function u1.GetWearNameForFloat(p105: any, p106: number) -- Line: 607
    -- upvalues: GetWearFromFloat (copy)
    return GetWearFromFloat(p105, p106);
end;

function u1.GetAbbreviatedWearName(p107: string) -- Line: 613
    return string.gsub(p107, "[^A-Z]", "");
end;

function u1.ObserveItemStockSchemas(p108: function) -- Line: 619
    -- upvalues: u3 (copy), u4 (ref)
    local u109 = u3:Connect(p108);

    if next(u4) ~= nil then
        p108(u4);
    end;

    return function() -- Line: 625
        -- upvalues: u109 (copy)
        if u109.Connected then
            u109:Disconnect();
        end;
    end;
end;

u1.GetKillTrackValue = GetKillTrackValue;

function u1.GetMagazine(p110: string, p111: string, p112: number?) -- Line: 638
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), Skins (copy), ApplySkinTextures (copy), GetWearTextureFolder (copy)
    local v113;

    if typeof(p110) == "string" and (typeof(p111) == "string" and p110 ~= "") then
        v113 = p111 ~= "";
    else
        v113 = false;
    end;

    if not v113 then
        return nil;
    end;

    local SkinInformation = u1.GetSkinInformation(p110, p111);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p110, p111);
    end;

    if not SkinInformation then
        return nil;
    end;

    local v114 = Weapons:FindFirstChild(p110);

    if not (v114 and v114:IsA("Folder")) then
        v114 = nil;
    end;

    if v114 then
        v114 = v114:FindFirstChild("Character");
    end;

    if not (v114 and v114:IsA("Model")) then
        return nil;
    end;

    local v115 = {};

    for _, descendant in ipairs(v114:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant:HasTag("CharacterMagazine") then
            table.insert(v115, descendant);
        end;
    end;

    if #v115 == 0 then
        return nil;
    end;

    local Model = Instance.new("Model");
    Model.Name = "Magazine";

    for _, v in ipairs(v115) do
        local v116 = v:Clone();
        v116.Parent = Model;

        if not Model.PrimaryPart then
            Model.PrimaryPart = v116;
        end;
    end;

    local v117 = Skins:FindFirstChild(p110);
    local v118;

    if v117 then
        v118 = v117:FindFirstChild(p111);

        if not (v118 and v118:IsA("Folder")) then
            v118 = nil;
        end;
    else
        v118 = nil;
    end;

    if v118 then
        v118 = v118:FindFirstChild("Character");
    end;

    ApplySkinTextures(Model, (GetWearTextureFolder(v118, SkinInformation, p112 or SkinInformation.floatRange.min)));

    return Model;
end;

local function GetGloveSourceParts(p119: userdata, p120: boolean) -- Line: 688
    local v121;

    if p120 then
        v121 = p119:FindFirstChild("Character");
    else
        v121 = nil;
    end;

    local v122 = {};

    for _, child in ipairs(p119:GetChildren()) do
        if child:IsA("BasePart") then
            local v123;

            if v121 then
                v123 = v121:FindFirstChild(child.Name);
            else
                v123 = v121;
            end;

            if v123 then
                if not v123:IsA("BasePart") then
                    v123 = child;
                end;
            else
                v123 = child;
            end;

            table.insert(v122, v123);
        end;
    end;

    return v122;
end;

local function BuildGloves(p124: string, p125: string, p126: number?, p127: boolean) -- Line: 700
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), GetGloveSourceParts (copy), Skins (copy), ApplySkinTextures (copy), GetWearTextureFolder (copy)
    local v128;

    if typeof(p124) == "string" and (typeof(p125) == "string" and p124 ~= "") then
        v128 = p125 ~= "";
    else
        v128 = false;
    end;

    if not v128 then
        return nil;
    end;

    local SkinInformation = u1.GetSkinInformation(p124, p125);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p124, p125);
    end;

    if not SkinInformation then
        return nil;
    end;

    local v129 = Weapons:FindFirstChild(p124);

    if not (v129 and v129:IsA("Folder")) then
        v129 = nil;
    end;

    if not v129 then
        return nil;
    end;

    local Model = Instance.new("Model");
    Model.Name = p124;

    for _, v in GetGloveSourceParts(v129, p127) do
        v:Clone().Parent = Model;
    end;

    local v130 = Skins:FindFirstChild(p124);
    local v131;

    if v130 then
        v131 = v130:FindFirstChild(p125);

        if not (v131 and v131:IsA("Folder")) then
            v131 = nil;
        end;
    else
        v131 = nil;
    end;

    if v131 then
        v131 = v131:FindFirstChild("Camera");
    end;

    ApplySkinTextures(Model, (GetWearTextureFolder(v131, SkinInformation, p126 or SkinInformation.floatRange.min)));

    return Model;
end;

function u1.GetGloves(p132: string, p133: string, p134: number?) -- Line: 732
    -- upvalues: BuildGloves (copy)
    return BuildGloves(p132, p133, p134, false);
end;

function u1.GetCharacterGloves(p135: string, p136: string, p137: number?) -- Line: 737
    -- upvalues: BuildGloves (copy)
    return BuildGloves(p135, p136, p137, true);
end;

function u1.GetCharacterGloveParts(p138: string) -- Line: 742
    -- upvalues: Weapons (copy), GetGloveSourceParts (copy)
    local v139 = Weapons:FindFirstChild(p138);

    if not (v139 and v139:IsA("Folder")) then
        v139 = nil;
    end;

    if v139 then
        return GetGloveSourceParts(v139, true);
    end;

    return nil;
end;

function u1.GetCharacterModel(p140: string, p141: string, p142: number?, p143: any, p144: any, p145: any, p146: table?, p147: string?) -- Line: 749
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), GetSkinTextureFolder (copy), DecorateModel (copy)
    local v148;

    if typeof(p140) == "string" and (typeof(p141) == "string" and p140 ~= "") then
        v148 = p141 ~= "";
    else
        v148 = false;
    end;

    if not v148 then
        return nil;
    end;

    local SkinInformation = u1.GetSkinInformation(p140, p141);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p140, p141);
    end;

    if not SkinInformation then
        warn((`SkinHandler.GetCharacterModel: Skin "{p141}" not found for weapon "{p140}"`));

        return nil;
    end;

    local v149 = Weapons:FindFirstChild(p140);

    if not (v149 and v149:IsA("Folder")) then
        v149 = nil;
    end;

    if v149 then
        v149 = v149:FindFirstChild("Character");
    end;

    if not (v149 and v149:IsA("Model")) then
        warn((`SkinHandler.GetCharacterModel: Base character model not found for weapon "{p140}"`));

        return nil;
    end;

    local v150 = v149:Clone();
    local v151 = GetSkinTextureFolder(p140, p141, p147);

    if v151 then
        v151 = v151:FindFirstChild("Character");
    end;

    return DecorateModel(v150, v151, SkinInformation, p142, p140, p143, p144, p145, false);
end;

function u1.GetWorldModel(p152: string, p153: string, p154: number?, p155: any, p156: any, p157: any, p158: table?) -- Line: 783
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), Skins (copy), DecorateModel (copy)
    local v159;

    if typeof(p152) == "string" and (typeof(p153) == "string" and p152 ~= "") then
        v159 = p153 ~= "";
    else
        v159 = false;
    end;

    if not v159 then
        return nil;
    end;

    local SkinInformation = u1.GetSkinInformation(p152, p153);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p152, p153);
    end;

    if not SkinInformation then
        return nil;
    end;

    local v160 = Weapons:FindFirstChild(p152);

    if not (v160 and v160:IsA("Folder")) then
        v160 = nil;
    end;

    if v160 then
        v160 = v160:FindFirstChild("Other");
    end;

    if v160 then
        v160 = v160:FindFirstChild("World");
    end;

    if not (v160 and v160:IsA("Model")) then
        return nil;
    end;

    local v161 = v160:Clone();
    local v162 = Skins:FindFirstChild(p152);
    local v163;

    if v162 then
        v163 = v162:FindFirstChild(p153);

        if not (v163 and v163:IsA("Folder")) then
            v163 = nil;
        end;
    else
        v163 = nil;
    end;

    if v163 then
        v163 = v163:FindFirstChild("Character");
    end;

    return DecorateModel(v161, v163, SkinInformation, p154, p152, p155, p156, p157, false);
end;

function u1.GetCameraModel(p164: string, p165: string, p166: number?, p167: any, p168: any, p169: any, p170: table?, p171: string?) -- Line: 816
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), GetSkinTextureFolder (copy), DecorateModel (copy)
    local v172;

    if typeof(p164) == "string" and (typeof(p165) == "string" and p164 ~= "") then
        v172 = p165 ~= "";
    else
        v172 = false;
    end;

    if not v172 then
        return nil;
    end;

    local SkinInformation = u1.GetSkinInformation(p164, p165);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p164, p165);
    end;

    if not SkinInformation then
        return nil;
    end;

    local v173 = Weapons:FindFirstChild(p164);

    if not (v173 and v173:IsA("Folder")) then
        v173 = nil;
    end;

    if v173 then
        v173 = v173:FindFirstChild("Camera");
    end;

    if not (v173 and v173:IsA("Model")) then
        return nil;
    end;

    local v174 = v173:Clone();
    local v175 = GetSkinTextureFolder(p164, p165, p171);

    if v175 then
        v175 = v175:FindFirstChild("Camera");
    end;

    return DecorateModel(v174, v175, SkinInformation, p166, p164, p167, p168, p169, true);
end;

local function GetSourceMeshPlacement(p176: userdata) -- Line: 850
    local Attribute = p176:GetAttribute("SourceMeshId");
    local Attribute2 = p176:GetAttribute("SourceSize");
    local Attribute3 = p176:GetAttribute("SourceOffset");

    if typeof(Attribute) ~= "string" then
        Attribute = p176.MeshId;
    end;

    if typeof(Attribute2) ~= "Vector3" then
        Attribute2 = p176.Size;
    end;

    if typeof(Attribute3) == "CFrame" then
        return Attribute, Attribute2, p176.CFrame * Attribute3;
    end;

    return Attribute, Attribute2, p176.CFrame;
end;

function u1.GetInspectModel(p177: string, p178: string, p179: number?, p180: any, p181: any, p182: any, p183: table?) -- Line: 861
    -- upvalues: Weapons (copy), u1 (copy), table_freeze_ret (copy), table_freeze_ret2 (copy), GetSourceMeshPlacement (copy)
    local v184 = Weapons:FindFirstChild(p177);

    if not (v184 and v184:IsA("Folder")) then
        v184 = nil;
    end;

    if v184 then
        v184 = v184:FindFirstChild("Character");
    end;

    local v185;

    if v184 and v184:IsA("Model") then
        v185 = u1.GetCameraModel(p177, p178, p179, p180, p181, p182, p183);
    else
        v185 = nil;
    end;

    if not (v185 and (v184 and v184:IsA("Model"))) then
        return u1.GetCharacterModel(p177, p178, p179, p180, p181, p182, p183);
    end;

    local Model = Instance.new("Model");
    Model.Name = p177;

    for _, child in v185:GetChildren() do
        if table_freeze_ret[child.Name] then
            child.Parent = Model;
        end;
    end;

    v185:Destroy();

    for _, descendant in Model:GetDescendants() do
        if descendant.Parent and table_freeze_ret2[string.gsub(descendant.Name, "%.%d+$", "")] then
            descendant:Destroy();
        end;
    end;

    local v186 = {};

    for _, descendant in v184:GetDescendants() do
        if descendant:IsA("MeshPart") then
            v186[GetSourceMeshPlacement(descendant)] = descendant;
        end;
    end;

    local CFrame_identity = CFrame.identity;
    local v187 = Vector3.new(0, 0, 0);
    local v188 = nil;

    for _, descendant in Model:GetDescendants() do
        local v189;

        if descendant:IsA("MeshPart") then
            v189 = v186[descendant.MeshId];
        else
            v189 = nil;
        end;

        if v189 then
            local _, v190, v191 = GetSourceMeshPlacement(v189);

            if v190.Magnitude > v187.Magnitude then
                CFrame_identity = v191;
                v188 = descendant;
                v187 = v190;
            end;
        end;
    end;

    if not v188 then
        Model:Destroy();

        return u1.GetCharacterModel(p177, p178, p179, p180, p181, p182, p183);
    end;

    Model.WorldPivot = v188.CFrame;
    Model:ScaleTo(v187.Magnitude / v188.Size.Magnitude);
    Model:PivotTo(CFrame_identity);
    Model.WorldPivot = v184:GetPivot();
    local InspectPivot = v184:FindFirstChild("InspectPivot", true);

    if InspectPivot and InspectPivot:IsA("Attachment") then
        local Attachment = Instance.new("Attachment");
        Attachment.Name = "InspectPivot";
        Attachment.Parent = v188;
        Attachment.WorldCFrame = InspectPivot.WorldCFrame;
    end;

    return Model;
end;

function u1.GetSkinInformation(p192: string, p193: string) -- Line: 933
    -- upvalues: u4 (ref), u5 (copy), CreateSyntheticStockSchema (copy)
    local v194;

    if typeof(p192) == "string" and (typeof(p193) == "string" and p192 ~= "") then
        v194 = p193 ~= "";
    else
        v194 = false;
    end;

    if not v194 then
        return nil;
    end;

    local v195 = u4[p192];

    if v195 and v195[p193] then
        return v195[p193];
    end;

    if p193 ~= "Stock" then
        return nil;
    end;

    local v196 = u5[p192] or CreateSyntheticStockSchema(p192);
    u5[p192] = v196;

    return v196;
end;

function u1.IsSkinAvailable(p197: string, p198: string) -- Line: 955
    -- upvalues: u1 (copy), Skins (copy)
    local SkinInformation = u1.GetSkinInformation(p197, p198);

    if not SkinInformation then
        return false;
    end;

    if SkinInformation.type ~= "Weapon" and (SkinInformation.type ~= "Melee" and (SkinInformation.type ~= "Glove" and SkinInformation.type ~= "Zeus x27")) then
        return true;
    end;

    local v199 = Skins:FindFirstChild(p197);

    if not (v199 and v199:IsA("Folder")) then
        return false;
    end;

    local v200 = Skins:FindFirstChild(p197);
    local v201;

    if v200 then
        v201 = v200:FindFirstChild(p198);

        if not (v201 and v201:IsA("Folder")) then
            v201 = nil;
        end;
    else
        v201 = nil;
    end;

    return v201 ~= nil;
end;

function u1.HasSkinTextures(p202: string, p203: string) -- Line: 980
    -- upvalues: Skins (copy)
    local v204;

    if typeof(p202) == "string" and (typeof(p203) == "string" and p202 ~= "") then
        v204 = p203 ~= "";
    else
        v204 = false;
    end;

    if not v204 then
        return false;
    end;

    local v205 = Skins:FindFirstChild(p202);

    if not (v205 and v205:IsA("Folder")) then
        return true;
    end;

    local v206 = Skins:FindFirstChild(p202);
    local v207;

    if v206 then
        v207 = v206:FindFirstChild(p203);

        if not (v207 and v207:IsA("Folder")) then
            v207 = nil;
        end;
    else
        v207 = nil;
    end;

    return v207 ~= nil;
end;

function u1.GetAllSkinsForWeapon(p208: string) -- Line: 996
    -- upvalues: u4 (ref)
    if typeof(p208) ~= "string" or p208 == "" then
        return nil;
    end;

    local v209 = u4[p208];

    if not v209 then
        return nil;
    end;

    local v210 = {};

    for _, v in pairs(v209) do
        table.insert(v210, v);
    end;

    return v210;
end;

function u1.GetWearImageForFloat(p211: any, p212: number) -- Line: 1015
    -- upvalues: GetWearFromFloat (copy)
    local v213 = GetWearFromFloat(p211, p212);

    if not v213 then
        return nil;
    end;

    for _, v in ipairs(p211.wearImages) do
        if v.wear == v213 then
            return v.assetId;
        end;
    end;

    return nil;
end;

local function getCharmImageForPattern(p214: any, p215: number?) -- Line: 1031
    for _, v in p214.charmImages or {} do
        if v.pattern == p215 then
            return v.assetId;
        end;
    end;

    return nil;
end;

function u1.GetItemIconImage(p216, p217) -- Line: 1043
    -- upvalues: u1 (copy)
    local v218;

    if p217.Type == "Charm" or p217.Name == "Charm" then
        local v219 = p217.Pattern or 1;
        v218 = nil;

        for _, v in p216.charmImages or {} do
            if v.pattern == v219 then
                v218 = v.assetId;
                break;
            end;
        end;
    else
        v218 = u1.GetWearImageForFloat(p216, p217.Float or 0);
    end;

    return v218 or p216.imageAssetId or "";
end;

function u1.GetBaseWeaponModel(p220: string, p221: string) -- Line: 1053
    -- upvalues: Weapons (copy)
    if typeof(p220) ~= "string" or p220 == "" then
        return nil;
    end;

    local v222 = Weapons:FindFirstChild(p220);

    if not (v222 and v222:IsA("Folder")) then
        v222 = nil;
    end;

    if not v222 then
        return nil;
    end;

    local v223 = v222:FindFirstChild(p221);

    if v223 and v223:IsA("Model") then
        return v223:Clone();
    end;

    return nil;
end;

local function SyncAvailableSkins() -- Line: 1070
    -- upvalues: ReplicatedStorage (copy), u4 (ref), HttpService (copy), u3 (copy)
    local Attribute = ReplicatedStorage:GetAttribute("AvaiableSkins");

    if Attribute then
        u4 = HttpService:JSONDecode(Attribute);

        if #u3:GetConnections() > 0 then
            u3:Fire(u4);
        end;
    end;
end;

local Attribute = ReplicatedStorage:GetAttribute("AvaiableSkins");

if Attribute then
    u4 = HttpService:JSONDecode(Attribute);

    if #u3:GetConnections() > 0 then
        u3:Fire(u4);
    end;
end;

ReplicatedStorage:GetAttributeChangedSignal("AvaiableSkins"):Connect(SyncAvailableSkins);

return u1;