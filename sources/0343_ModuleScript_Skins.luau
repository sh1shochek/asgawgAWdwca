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
local u7 = {
    ["Factory New"] = "Mint Condition",
    ["Minimal Wear"] = "Near-Mint",
    ["Field-Tested"] = "Standard-Grade",
    ["Well-Worn"] = "Combat-Worn",
    ["Battle-Scarred"] = "War-Torn"
};

local function GetDataController() -- Line: 61
    -- upvalues: u2 (ref), ReplicatedStorage (copy)
    if not u2 then
        local success, result = pcall(function() -- Line: 63
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.DataController);
        end);

        if success then
            u2 = result;
        end;
    end;

    return u2;
end;

local function ResolveCharmFromId(p8: string) -- Line: 75
    -- upvalues: u2 (ref), ReplicatedStorage (copy), Players (copy)
    if not u2 then
        local success, result = pcall(function() -- Line: 63
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

local function ValidateInputs(p11: string, p12: string) -- Line: 106
    local v13;

    if typeof(p11) == "string" and (typeof(p12) == "string" and p11 ~= "") then
        v13 = p12 ~= "";
    else
        v13 = false;
    end;

    return v13;
end;

local function Weld(p14: userdata, p15: userdata) -- Line: 112
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p14;
    WeldConstraint.Part1 = p15;
    WeldConstraint.Parent = p14;
end;

local function UpdateAvailableSkins(p16: string) -- Line: 121
    -- upvalues: u4 (ref), HttpService (copy), u3 (copy)
    u4 = HttpService:JSONDecode(p16);

    if #u3:GetConnections() > 0 then
        u3:Fire(u4);
    end;
end;

local function CreateSyntheticStockSchema(p17: string) -- Line: 130
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

local function GetSyntheticStockSchema(p19: string) -- Line: 167
    -- upvalues: u5 (copy), CreateSyntheticStockSchema (copy)
    local v20 = u5[p19] or CreateSyntheticStockSchema(p19);
    u5[p19] = v20;

    return v20;
end;

local function GetKillTrackValue(p21: any, p22: string) -- Line: 175
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

local function GetWeaponFolder(p25: string) -- Line: 191
    -- upvalues: Weapons (copy)
    local v26 = Weapons:FindFirstChild(p25);

    if v26 and v26:IsA("Folder") then
        return v26;
    end;

    return nil;
end;

local function GetSkinTextureFolder(p27: string, p28: string, p29: string?) -- Line: 199
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

local function GetSkinVariantFolder(p33: string, p34: string, p35: string?, p36: string) -- Line: 219
    -- upvalues: GetSkinTextureFolder (copy)
    local v37 = GetSkinTextureFolder(p33, p34, p35);

    if v37 then
        v37 = v37:FindFirstChild(p36);
    end;

    return v37;
end;

local function GetWearFromFloat(p38: any, p39: number) -- Line: 226
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

local function GetWearTextureFolder(p40: userdata?, p41: any, p42: number) -- Line: 243
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

local function ApplySkinTextures(p45: userdata, p46: userdata?) -- Line: 268
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

local function ForEachWeaponPart(p49: userdata, p50: function, ...) -- Line: 295
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

local function AttachStatTrakToWeapon(p51: userdata, p52: userdata, p53: any, p54: string, p55: boolean) -- Line: 314
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

local function AttachNameTagToWeapon(p58: userdata, p59: userdata, p60: any, p61: boolean) -- Line: 350
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

local function FindCharmModels(p64: string, p65: number) -- Line: 376
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

local function MountSpecificCharm(p68: userdata, p69: userdata) -- Line: 393
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

local function AttachCharmToWeapon(p72: userdata, p73: string, p74: number, p75: string, p76: boolean) -- Line: 416
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

local function AttachCharm(p81: userdata, p82: any, p83: boolean) -- Line: 461
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

local function WaitForSkinInformation(p87: string, p88: string) -- Line: 511
    -- upvalues: u1 (copy), u4 (ref), u3 (copy)
    local SkinInformation = u1.GetSkinInformation(p87, p88);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p87, p88);
    end;

    return SkinInformation;
end;

local function DecorateModel(p89: userdata, p90: userdata?, p91: any, p92: number?, p93: string, p94: any, p95: any, p96: any, p97: boolean) -- Line: 522
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

function u1.GetCharmModel(p98: string, p99: number) -- Line: 552
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

function u1.GetBadgeModel(p103: string) -- Line: 568
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

function u1.GetWearNameForFloat(p105: any, p106: number) -- Line: 582
    -- upvalues: GetWearFromFloat (copy)
    return GetWearFromFloat(p105, p106);
end;

function u1.GetAbbreviatedWearName(p107: string) -- Line: 588
    return string.gsub(p107, "[^A-Z]", "");
end;

function u1.ObserveItemStockSchemas(p108: function) -- Line: 594
    -- upvalues: u3 (copy), u4 (ref)
    local u109 = u3:Connect(p108);

    if next(u4) ~= nil then
        p108(u4);
    end;

    return function() -- Line: 600
        -- upvalues: u109 (copy)
        if u109.Connected then
            u109:Disconnect();
        end;
    end;
end;

u1.GetKillTrackValue = GetKillTrackValue;

function u1.GetMagazine(p110: string, p111: string, p112: number?) -- Line: 613
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

function u1.GetGloves(p119: string, p120: string, p121: number?) -- Line: 661
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), Skins (copy), ApplySkinTextures (copy), GetWearTextureFolder (copy)
    local v122;

    if typeof(p119) == "string" and (typeof(p120) == "string" and p119 ~= "") then
        v122 = p120 ~= "";
    else
        v122 = false;
    end;

    if not v122 then
        return nil;
    end;

    local SkinInformation = u1.GetSkinInformation(p119, p120);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p119, p120);
    end;

    if not SkinInformation then
        return nil;
    end;

    local v123 = Weapons:FindFirstChild(p119);

    if not (v123 and v123:IsA("Folder")) then
        v123 = nil;
    end;

    if not v123 then
        return nil;
    end;

    local Model = Instance.new("Model");
    Model.Name = p119;

    for _, child in ipairs(v123:GetChildren()) do
        if child:IsA("BasePart") then
            child:Clone().Parent = Model;
        end;
    end;

    local v124 = Skins:FindFirstChild(p119);
    local v125;

    if v124 then
        v125 = v124:FindFirstChild(p120);

        if not (v125 and v125:IsA("Folder")) then
            v125 = nil;
        end;
    else
        v125 = nil;
    end;

    if v125 then
        v125 = v125:FindFirstChild("Camera");
    end;

    ApplySkinTextures(Model, (GetWearTextureFolder(v125, SkinInformation, p121 or SkinInformation.floatRange.min)));

    return Model;
end;

function u1.GetCharacterModel(p126: string, p127: string, p128: number?, p129: any, p130: any, p131: any, p132: table?, p133: string?) -- Line: 696
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), GetSkinTextureFolder (copy), DecorateModel (copy)
    local v134;

    if typeof(p126) == "string" and (typeof(p127) == "string" and p126 ~= "") then
        v134 = p127 ~= "";
    else
        v134 = false;
    end;

    if not v134 then
        return nil;
    end;

    local SkinInformation = u1.GetSkinInformation(p126, p127);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p126, p127);
    end;

    if not SkinInformation then
        warn((`SkinHandler.GetCharacterModel: Skin "{p127}" not found for weapon "{p126}"`));

        return nil;
    end;

    local v135 = Weapons:FindFirstChild(p126);

    if not (v135 and v135:IsA("Folder")) then
        v135 = nil;
    end;

    if v135 then
        v135 = v135:FindFirstChild("Character");
    end;

    if not (v135 and v135:IsA("Model")) then
        warn((`SkinHandler.GetCharacterModel: Base character model not found for weapon "{p126}"`));

        return nil;
    end;

    local v136 = v135:Clone();
    local v137 = GetSkinTextureFolder(p126, p127, p133);

    if v137 then
        v137 = v137:FindFirstChild("Character");
    end;

    return DecorateModel(v136, v137, SkinInformation, p128, p126, p129, p130, p131, false);
end;

function u1.GetWorldModel(p138: string, p139: string, p140: number?, p141: any, p142: any, p143: any, p144: table?) -- Line: 730
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), Skins (copy), DecorateModel (copy)
    local v145;

    if typeof(p138) == "string" and (typeof(p139) == "string" and p138 ~= "") then
        v145 = p139 ~= "";
    else
        v145 = false;
    end;

    if not v145 then
        return nil;
    end;

    local SkinInformation = u1.GetSkinInformation(p138, p139);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p138, p139);
    end;

    if not SkinInformation then
        return nil;
    end;

    local v146 = Weapons:FindFirstChild(p138);

    if not (v146 and v146:IsA("Folder")) then
        v146 = nil;
    end;

    if v146 then
        v146 = v146:FindFirstChild("Other");
    end;

    if v146 then
        v146 = v146:FindFirstChild("World");
    end;

    if not (v146 and v146:IsA("Model")) then
        return nil;
    end;

    local v147 = v146:Clone();
    local v148 = Skins:FindFirstChild(p138);
    local v149;

    if v148 then
        v149 = v148:FindFirstChild(p139);

        if not (v149 and v149:IsA("Folder")) then
            v149 = nil;
        end;
    else
        v149 = nil;
    end;

    if v149 then
        v149 = v149:FindFirstChild("Character");
    end;

    return DecorateModel(v147, v149, SkinInformation, p140, p138, p141, p142, p143, false);
end;

function u1.GetCameraModel(p150: string, p151: string, p152: number?, p153: any, p154: any, p155: any, p156: table?, p157: string?) -- Line: 763
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), GetSkinTextureFolder (copy), DecorateModel (copy)
    local v158;

    if typeof(p150) == "string" and (typeof(p151) == "string" and p150 ~= "") then
        v158 = p151 ~= "";
    else
        v158 = false;
    end;

    if not v158 then
        return nil;
    end;

    local SkinInformation = u1.GetSkinInformation(p150, p151);

    if not SkinInformation and next(u4) == nil then
        u3:Wait();
        SkinInformation = u1.GetSkinInformation(p150, p151);
    end;

    if not SkinInformation then
        return nil;
    end;

    local v159 = Weapons:FindFirstChild(p150);

    if not (v159 and v159:IsA("Folder")) then
        v159 = nil;
    end;

    if v159 then
        v159 = v159:FindFirstChild("Camera");
    end;

    if not (v159 and v159:IsA("Model")) then
        return nil;
    end;

    local v160 = v159:Clone();
    local v161 = GetSkinTextureFolder(p150, p151, p157);

    if v161 then
        v161 = v161:FindFirstChild("Camera");
    end;

    return DecorateModel(v160, v161, SkinInformation, p152, p150, p153, p154, p155, true);
end;

function u1.GetSkinInformation(p162: string, p163: string) -- Line: 795
    -- upvalues: u4 (ref), u5 (copy), CreateSyntheticStockSchema (copy)
    local v164;

    if typeof(p162) == "string" and (typeof(p163) == "string" and p162 ~= "") then
        v164 = p163 ~= "";
    else
        v164 = false;
    end;

    if not v164 then
        return nil;
    end;

    local v165 = u4[p162];

    if v165 and v165[p163] then
        return v165[p163];
    end;

    if p163 ~= "Stock" then
        return nil;
    end;

    local v166 = u5[p162] or CreateSyntheticStockSchema(p162);
    u5[p162] = v166;

    return v166;
end;

function u1.IsSkinAvailable(p167: string, p168: string) -- Line: 817
    -- upvalues: u1 (copy), Skins (copy)
    local SkinInformation = u1.GetSkinInformation(p167, p168);

    if not SkinInformation then
        return false;
    end;

    if SkinInformation.type ~= "Weapon" and (SkinInformation.type ~= "Melee" and (SkinInformation.type ~= "Glove" and SkinInformation.type ~= "Zeus x27")) then
        return true;
    end;

    local v169 = Skins:FindFirstChild(p167);

    if not (v169 and v169:IsA("Folder")) then
        return false;
    end;

    local v170 = Skins:FindFirstChild(p167);
    local v171;

    if v170 then
        v171 = v170:FindFirstChild(p168);

        if not (v171 and v171:IsA("Folder")) then
            v171 = nil;
        end;
    else
        v171 = nil;
    end;

    return v171 ~= nil;
end;

function u1.HasSkinTextures(p172: string, p173: string) -- Line: 842
    -- upvalues: Skins (copy)
    local v174;

    if typeof(p172) == "string" and (typeof(p173) == "string" and p172 ~= "") then
        v174 = p173 ~= "";
    else
        v174 = false;
    end;

    if not v174 then
        return false;
    end;

    local v175 = Skins:FindFirstChild(p172);

    if not (v175 and v175:IsA("Folder")) then
        return true;
    end;

    local v176 = Skins:FindFirstChild(p172);
    local v177;

    if v176 then
        v177 = v176:FindFirstChild(p173);

        if not (v177 and v177:IsA("Folder")) then
            v177 = nil;
        end;
    else
        v177 = nil;
    end;

    return v177 ~= nil;
end;

function u1.GetAllSkinsForWeapon(p178: string) -- Line: 858
    -- upvalues: u4 (ref)
    if typeof(p178) ~= "string" or p178 == "" then
        return nil;
    end;

    local v179 = u4[p178];

    if not v179 then
        return nil;
    end;

    local v180 = {};

    for _, v in pairs(v179) do
        table.insert(v180, v);
    end;

    return v180;
end;

function u1.GetWearImageForFloat(p181: any, p182: number) -- Line: 877
    -- upvalues: GetWearFromFloat (copy)
    local v183 = GetWearFromFloat(p181, p182);

    if not v183 then
        return nil;
    end;

    for _, v in ipairs(p181.wearImages) do
        if v.wear == v183 then
            return v.assetId;
        end;
    end;

    return nil;
end;

local function getCharmImageForPattern(p184: any, p185: number?) -- Line: 893
    for _, v in p184.charmImages or {} do
        if v.pattern == p185 then
            return v.assetId;
        end;
    end;

    return nil;
end;

function u1.GetItemIconImage(p186, p187) -- Line: 905
    -- upvalues: u1 (copy)
    local v188;

    if p187.Type == "Charm" or p187.Name == "Charm" then
        local v189 = p187.Pattern or 1;
        v188 = nil;

        for _, v in p186.charmImages or {} do
            if v.pattern == v189 then
                v188 = v.assetId;
                break;
            end;
        end;
    else
        v188 = u1.GetWearImageForFloat(p186, p187.Float or 0);
    end;

    return v188 or p186.imageAssetId or "";
end;

function u1.GetBaseWeaponModel(p190: string, p191: string) -- Line: 915
    -- upvalues: Weapons (copy)
    if typeof(p190) ~= "string" or p190 == "" then
        return nil;
    end;

    local v192 = Weapons:FindFirstChild(p190);

    if not (v192 and v192:IsA("Folder")) then
        v192 = nil;
    end;

    if not v192 then
        return nil;
    end;

    local v193 = v192:FindFirstChild(p191);

    if v193 and v193:IsA("Model") then
        return v193:Clone();
    end;

    return nil;
end;

local function SyncAvailableSkins() -- Line: 932
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