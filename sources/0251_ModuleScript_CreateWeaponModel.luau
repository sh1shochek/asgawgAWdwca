-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local Other = ReplicatedStorage.Assets.Other;
local Character = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("MuzzleFlashes"):WaitForChild("Character");
require(ReplicatedStorage.Database.Custom.Types);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local GetMuzzleFlash = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.GetMuzzleFlash);
local ThirdPersonWeaponStash = require(ReplicatedStorage.Components.Common.ThirdPersonWeaponStash);
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Attachments = require(ReplicatedStorage.Database.Custom.GameStats.Character.Attachments);
local u1 = { "PrimaryAttachment", "SecondaryAttachment", "MeleeAttachment" };
local u2 = {
    MuzzlePartL = 1,
    MuzzlePartR = 1,
    MuzzlePart = 1,
    RootPart = 1,
    Hitbox = 1,
    Insert = 1,
    move = 1
};
local u3 = CFrame.new(0, -0.4, 0.24) * CFrame.Angles(0, 3.141592653589793, 0);
local u4 = CFrame.new(0, 0.2, 0.8) * CFrame.Angles(1.5707963267948966, 0.20943951023931956, 0.17453292519943295);
local u5 = {};
local u6 = {};

local function dlog(p7: userdata?, p8: string, ...) -- Line: 119
    -- upvalues: DebugFlags (copy)
    if not DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
        return;
    end;

    warn((not p7 and "[ThirdPersonWeaponModels] " or "[ThirdPersonWeaponModels] " .. p7.Name .. " - ") .. p8:format(...));
end;

local function destroyInstance(p9: userdata?) -- Line: 129
    if p9 then
        p9:Destroy();
    end;
end;

local function GetSmokeGrenadeTeam(p10: userdata, p11: string) -- Line: 138
    if p11 ~= "Smoke Grenade" then
        return nil;
    end;

    local Attribute = p10:GetAttribute("Team");

    if Attribute == "Counter-Terrorists" or Attribute == "Terrorists" then
        return Attribute;
    end;

    return nil;
end;

local function IsWeaponEquippedInHand(p12: string, p13: string, p14: table) -- Line: 151
    local v15;

    if p12 == p14.Name then
        v15 = p13 == p14.Skin;
    else
        v15 = false;
    end;

    return v15;
end;

local function GetCharacterData(p16: userdata) -- Line: 157
    -- upvalues: u5 (copy)
    local v17 = u5[p16] or {
        Character = nil
    };
    u5[p16] = v17;

    return v17;
end;

local function GetJointPart(p18: string, p19: userdata) -- Line: 165
    -- upvalues: Attachments (copy)
    local v20 = Attachments.WEAPON_JOINT_PARTS[p18] or Attachments.DEFAULT_JOINT_PART;
    local v21 = p19:WaitForChild(v20, 10);
    local v22 = `Failed to get joint part: {v20} for weapon: {p18}`;
    assert(v21, v22);

    return v21;
end;

local function GetUpperTorso(p23: userdata) -- Line: 174
    local v24 = p23:FindFirstChild("HumanoidRootPart") or p23:WaitForChild("HumanoidRootPart", 10);

    if not (v24 and v24:IsA("BasePart")) then
        return nil;
    end;

    local v25 = p23:FindFirstChild("UpperTorso") or p23:WaitForChild("UpperTorso", 10);

    if v25 and v25:IsA("BasePart") then
        return v25;
    end;

    return nil;
end;

local function SetWeaponProperties(p26: userdata) -- Line: 191
    -- upvalues: u2 (copy)
    for _, descendant in ipairs(p26:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "WeaponModel";
            descendant.CastShadow = false;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
            descendant.Anchored = false;
            descendant.Massless = true;
            local v27 = u2[descendant.Name];

            if v27 then
                descendant.Transparency = v27;
            end;
        end;
    end;
end;

local function SetupMuzzleFlashPart(p28: userdata?, p29: any) -- Line: 211
    -- upvalues: GetMuzzleFlash (copy), Character (copy)
    if not (p28 and p29.MuzzleType) then
        return;
    end;

    GetMuzzleFlash(p28, Character, p29.MuzzleType, "WeldConstraint");

    if p29.HasSuppressor then
        GetMuzzleFlash(p28, Character, "Suppressor", "WeldConstraint");
    end;
end;

local function SetModelVisible(p30: userdata, p31: boolean) -- Line: 224
    -- upvalues: u2 (copy)
    for _, descendant in ipairs(p30:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = u2[descendant.Name] or (p31 and 0 or 1);
        end;
    end;
end;

local function CreateWeldForWeapon(p32: userdata, u33: userdata) -- Line: 234
    local Parent = u33.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        error((`Character attachment parent is not a BasePart: {u33.Name}`));
    end;

    local u34 = p32:FindFirstChild("Insert", true) or p32.PrimaryPart;

    if not u34 then
        error("Weapon model has no PrimaryPart or Insert part");
    end;

    local WeaponAttachment = u34:FindFirstChild("WeaponAttachment");

    if not WeaponAttachment then
        WeaponAttachment = Instance.new("Attachment");
        WeaponAttachment.Name = "WeaponAttachment";
        WeaponAttachment.Parent = u34;
    end;

    p32:PivotTo(Parent.CFrame * u33.CFrame * WeaponAttachment.CFrame:Inverse() * u34.CFrame:Inverse() * p32:GetPivot());

    if not pcall(function() -- Line: 258
        -- upvalues: u34 (copy), u33 (copy), WeaponAttachment (ref)
        local AttachmentConstraint = Instance.new("AttachmentConstraint");
        AttachmentConstraint.Parent = u34;
        AttachmentConstraint.Attachment0 = u33;
        AttachmentConstraint.Attachment1 = WeaponAttachment;
    end) then
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Parent = u34;
        WeldConstraint.Part0 = Parent;
        WeldConstraint.Part1 = u34;
    end;
end;

local function GetPlayerAttachmentsFolder(p35: userdata) -- Line: 275
    -- upvalues: CharacterResolver (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p35);

    if not PlayerCharacter then
        return nil;
    end;

    local WeaponAttachments = PlayerCharacter:FindFirstChild("WeaponAttachments");

    if WeaponAttachments and WeaponAttachments:IsA("Folder") then
        return WeaponAttachments;
    end;

    if WeaponAttachments then
        WeaponAttachments:Destroy();
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "WeaponAttachments";
    Folder.Parent = PlayerCharacter;

    return Folder;
end;

local function GetOrCreateCharacterFolder(p36: userdata, p37: string) -- Line: 291
    local v38 = nil;

    for _, child in ipairs(p36:GetChildren()) do
        if child.Name == p37 then
            if child:IsA("Folder") and not v38 then
                v38 = child;
            elseif child then
                child:Destroy();
            end;
        end;
    end;

    if v38 then
        return v38;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = p37;
    Folder.Parent = p36;

    return Folder;
end;

local function ToModelWithPrimaryPart(p39: userdata) -- Line: 318
    local v40 = p39:Clone();
    local v41;

    if v40:IsA("Model") then
        v41 = v40;
    else
        v41 = Instance.new("Model");
        v40.Parent = v41;
    end;

    local v42 = v41.PrimaryPart or v41:FindFirstChildWhichIsA("BasePart", true);

    if v42 then
        if not v41.PrimaryPart then
            v41.PrimaryPart = v42;
        end;

        return v41;
    end;

    if v41 then
        v41:Destroy();
    end;

    return nil;
end;

local function GetOrCreateTorsoAttachment(p43: userdata, p44: string, p45) -- Line: 340
    -- upvalues: GetUpperTorso (copy)
    local v46 = p43:FindFirstChild(p44, true);

    if v46 and v46:IsA("Attachment") then
        v46.CFrame = p45;

        return v46;
    end;

    local v47 = GetUpperTorso(p43);

    if not v47 then
        return nil;
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = p44;
    Attachment.CFrame = p45;
    Attachment.Parent = v47;

    return Attachment;
end;

local function AttachHolsterModel(p48: userdata, p49: userdata, p50: userdata, p51: string) -- Line: 361
    -- upvalues: SetWeaponProperties (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy)
    SetWeaponProperties(p49);
    CreateWeldForWeapon(p49, p50);
    local v52 = GetPlayerAttachmentsFolder(p48);

    if not v52 then
        if p49 then
            p49:Destroy();
        end;

        return nil;
    end;

    p49.Name = p51;
    p49.Parent = v52;

    return p49;
end;

local function CreateObjectiveKitHolsterModel(p53: userdata, p54: userdata) -- Line: 378
    -- upvalues: Other (copy), dlog (copy), u3 (copy), GetOrCreateTorsoAttachment (copy), ToModelWithPrimaryPart (copy), SetWeaponProperties (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy)
    local DefuseKit = Other:FindFirstChild("DefuseKit");

    if not DefuseKit then
        dlog(p53, "objective kit holster skipped: missing template Assets.Other.DefuseKit");

        return nil;
    end;

    local BodyBackAttachment = p54:FindFirstChild("BodyBackAttachment", true);
    local v55;

    if BodyBackAttachment and BodyBackAttachment:IsA("Attachment") then
        v55 = BodyBackAttachment.CFrame * u3;
    else
        v55 = u3;
    end;

    local v56 = GetOrCreateTorsoAttachment(p54, "ObjectiveKitAttachment", v55);

    if not v56 then
        dlog(p53, "objective kit holster skipped: no valid character attachment");

        return nil;
    end;

    local v57 = ToModelWithPrimaryPart(DefuseKit);

    if not v57 then
        dlog(p53, "objective kit holster skipped: template has no BasePart");

        return nil;
    end;

    SetWeaponProperties(v57);
    CreateWeldForWeapon(v57, v56);
    local v58 = GetPlayerAttachmentsFolder(p53);

    if not v58 then
        if v57 then
            v57:Destroy();
        end;

        return nil;
    end;

    v57.Name = "ObjectiveKitHolster";
    v57.Parent = v58;

    return v57;
end;

local function DestroyObjectiveKitHolsters(p59: userdata, p60: table) -- Line: 406
    -- upvalues: CharacterResolver (copy)
    local ObjectiveKitHolsterModel = p60.ObjectiveKitHolsterModel;

    if ObjectiveKitHolsterModel then
        ObjectiveKitHolsterModel:Destroy();
    end;

    p60.ObjectiveKitHolsterModel = nil;
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p59);
    local v61;

    if PlayerCharacter then
        v61 = PlayerCharacter:FindFirstChild("WeaponAttachments");
    else
        v61 = nil;
    end;

    if not v61 then
        return;
    end;

    for _, child in ipairs(v61:GetChildren()) do
        if child:IsA("Model") and (child.Name == "ObjectiveKitHolster" and child) then
            child:Destroy();
        end;
    end;
end;

local function UpdateObjectiveKitHolster(p62: userdata, p63: userdata) -- Line: 425
    -- upvalues: u5 (copy), DestroyObjectiveKitHolsters (copy), CreateObjectiveKitHolsterModel (copy)
    local v64 = u5[p62] or {
        Character = nil
    };
    u5[p62] = v64;
    local v65;

    if p62:GetAttribute("Team") == "Counter-Terrorists" then
        v65 = p62:GetAttribute("HasDefuseKit") == true and true or p62:GetAttribute("HasRescueKit") == true;
    else
        v65 = false;
    end;

    local ObjectiveKitHolsterModel = v64.ObjectiveKitHolsterModel;

    if v65 and (ObjectiveKitHolsterModel and ObjectiveKitHolsterModel.Parent) then
        return;
    end;

    DestroyObjectiveKitHolsters(p62, v64);

    if v65 then
        v64.ObjectiveKitHolsterModel = CreateObjectiveKitHolsterModel(p62, p63);
    end;
end;

local function CreateBombHolsterModel(p66: userdata, p67: userdata, p68: any) -- Line: 443
    -- upvalues: GetOrCreateTorsoAttachment (copy), u4 (copy), dlog (copy), Skins (copy), SetWeaponProperties (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy)
    local v69 = GetOrCreateTorsoAttachment(p67, "BombAttachment", u4);

    if not v69 then
        dlog(p66, "bomb holster skipped: no valid character attachment (missing UpperTorso)");

        return nil;
    end;

    local CharacterModel = Skins.GetCharacterModel("C4", p68.Skin or "", p68.Float, p68.StatTrack, p68.NameTag, false, p68.Stickers);

    if not CharacterModel then
        dlog(p66, "bomb holster skipped: SkinHandler returned nil for C4");

        return nil;
    end;

    SetWeaponProperties(CharacterModel);
    CreateWeldForWeapon(CharacterModel, v69);
    local v70 = GetPlayerAttachmentsFolder(p66);

    if not v70 then
        if CharacterModel then
            CharacterModel:Destroy();
        end;

        return nil;
    end;

    CharacterModel.Name = "BombHolster";
    CharacterModel.Parent = v70;

    return CharacterModel;
end;

local function DestroyBombHolster(p71: table) -- Line: 470
    local BombHolsterModel = p71.BombHolsterModel;

    if BombHolsterModel then
        BombHolsterModel:Destroy();
    end;

    p71.BombHolsterModel = nil;
    p71.BombHolsterVisible = nil;
end;

local function UpdateBombHolster(p72: userdata, p73: userdata, p74: table?) -- Line: 478
    -- upvalues: u5 (copy), HttpService (copy), CreateBombHolsterModel (copy), SetModelVisible (copy)
    local v75 = u5[p72] or {
        Character = nil
    };
    u5[p72] = v75;
    local Attribute = p72:GetAttribute("Slot5");
    local v76;

    if Attribute then
        v76 = HttpService:JSONDecode(Attribute);
    else
        v76 = nil;
    end;

    if not v76 or v76.Weapon ~= "C4" then
        local BombHolsterModel = v75.BombHolsterModel;

        if BombHolsterModel then
            BombHolsterModel:Destroy();
        end;

        v75.BombHolsterModel = nil;
        v75.BombHolsterVisible = nil;

        return;
    end;

    local BombHolsterModel = v75.BombHolsterModel;

    if not (BombHolsterModel and BombHolsterModel.Parent) then
        local BombHolsterModel2 = v75.BombHolsterModel;

        if BombHolsterModel2 then
            BombHolsterModel2:Destroy();
        end;

        v75.BombHolsterModel = nil;
        v75.BombHolsterVisible = nil;
        BombHolsterModel = CreateBombHolsterModel(p72, p73, v76);
        v75.BombHolsterModel = BombHolsterModel;
    end;

    if p74 then
        p74 = p74.Name == "C4";
    end;

    local v77 = not p74;

    if BombHolsterModel and v75.BombHolsterVisible ~= v77 then
        SetModelVisible(BombHolsterModel, v77);
        v75.BombHolsterVisible = v77;
    end;
end;

local function CacheWeaponCharacterModel(p78: userdata, p79: userdata, p80: number, p81: table, p82: boolean) -- Line: 505
    -- upvalues: Skins (copy), dlog (copy), SetWeaponProperties (copy), u1 (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy), u5 (copy), SetModelVisible (copy)
    local Weapon = p81.Weapon;
    local Skin = p81.Skin;
    local GetCharacterModel = Skins.GetCharacterModel;
    local Float = p81.Float;
    local StatTrack = p81.StatTrack;
    local NameTag = p81.NameTag;
    local Stickers = p81.Stickers;
    local v83;

    if Weapon == "Smoke Grenade" then
        v83 = p78:GetAttribute("Team");

        if v83 ~= "Counter-Terrorists" and v83 ~= "Terrorists" then
            v83 = nil;
        end;
    else
        v83 = nil;
    end;

    local v84 = GetCharacterModel(Weapon, Skin, Float, StatTrack, NameTag, false, Stickers, v83);

    if not v84 then
        dlog(p78, "holster skipped: SkinHandler returned nil for slot=%d weapon=%s skin=%s", p80, Weapon, Skin);

        return;
    end;

    SetWeaponProperties(v84);
    local v85 = u1[p80];
    local v86;

    if v85 then
        v86 = p79:FindFirstChild(v85, true);
    else
        v86 = nil;
    end;

    if not v86 then
        dlog(p78, "missing character attachment for slot=%d weapon=%s (expected %s)", p80, Weapon, (tostring(v85)));
        error((`Missing character attachment for slot: {p80}`));
    end;

    CreateWeldForWeapon(v84, v86);
    local v87 = GetPlayerAttachmentsFolder(p78);

    if v87 then
        v84.Parent = v87;
        v84.Name = Weapon;
    end;

    local v88 = u5[p78] or {
        Character = nil
    };
    u5[p78] = v88;
    v88[p80] = {
        StatTrack = p81.StatTrack,
        Stickers = p81.Stickers,
        NameTag = p81.NameTag,
        Model = v84,
        Float = p81.Float,
        Charm = p81.Charm,
        Weapon = Weapon,
        Skin = Skin,
        Visible = p82
    };
    dlog(p78, "cached holster slot=%d weapon=%s skin=%s visible=%s", p80, Weapon, Skin, "unknown");
    SetModelVisible(v84, p82);
end;

local function DestroyEquippedModels(p89: table) -- Line: 575
    local EquippedModels = p89.EquippedModels;

    if EquippedModels then
        for _, v in pairs(EquippedModels) do
            for _, v2 in v.Motors do
                v2:Destroy();
            end;

            local Model = v.Model;

            if Model then
                Model:Destroy();
            end;
        end;
    end;

    p89.EquippedModels = nil;
    p89.ActiveEquipped = nil;
end;

local function ClearPlayerCache(p90: userdata) -- Line: 589
    -- upvalues: u6 (copy), u5 (copy), DestroyEquippedModels (copy), dlog (copy)
    local v91 = u6[p90];

    if v91 then
        v91:Disconnect();
        u6[p90] = nil;
    end;

    local v92 = u5[p90];

    if v92 then
        local Character2 = v92.Character;
        DestroyEquippedModels(v92);
        local ObjectiveKitHolsterModel = v92.ObjectiveKitHolsterModel;

        if ObjectiveKitHolsterModel then
            ObjectiveKitHolsterModel:Destroy();
        end;

        v92.ObjectiveKitHolsterModel = nil;
        local BombHolsterModel = v92.BombHolsterModel;

        if BombHolsterModel then
            BombHolsterModel:Destroy();
        end;

        v92.BombHolsterModel = nil;
        v92.BombHolsterVisible = nil;

        for i, v in pairs(v92) do
            if typeof(i) == "number" and typeof(v) == "table" then
                local Model = v.Model;

                if Model then
                    Model:Destroy();
                end;

                v92[i] = nil;
            end;
        end;

        if Character2 then
            for _, v in { "WeaponModel", "WeaponAttachments" } do
                local v93 = Character2:FindFirstChild(v);

                if v93 and v93:IsA("Folder") then
                    v93:ClearAllChildren();
                end;
            end;
        end;
    end;

    dlog(p90, "cleared player cache (destroyed holsters)");
    u5[p90] = nil;
end;

local function InitializePlayerCache(u94: userdata, p95: userdata) -- Line: 627
    -- upvalues: u5 (copy), ClearPlayerCache (copy), u6 (copy), DestroyEquippedModels (copy)
    local v96 = u5[u94] or {
        Character = nil
    };
    u5[u94] = v96;

    if v96.Character == p95 then
        return;
    end;

    if v96.Character then
        ClearPlayerCache(u94);
        v96 = u5[u94] or {
            Character = nil
        };
        u5[u94] = v96;
    end;

    v96.Character = p95;
    local v97 = u6[u94];

    if v97 then
        v97:Disconnect();
    end;

    u6[u94] = p95.AncestryChanged:Connect(function(p98, p99) -- Line: 644
        -- upvalues: u5 (ref), u94 (copy), DestroyEquippedModels (ref)
        local v100 = u5[u94];

        if p99 or not v100 then
            return;
        end;

        DestroyEquippedModels(v100);
        v100.ObjectiveKitHolsterModel = nil;
        v100.BombHolsterModel = nil;

        for i, v in pairs(v100) do
            if typeof(i) == "number" and typeof(v) == "table" then
                v100[i] = nil;
            end;
        end;

        v100.Character = nil;
    end);
end;

local function UpdateCachedWeapon(p101: userdata, p102: userdata, p103: number, p104: table, p105: table) -- Line: 664
    -- upvalues: GetWeaponProperties (copy), u5 (copy), SetModelVisible (copy), dlog (copy), CacheWeaponCharacterModel (copy)
    local v106 = GetWeaponProperties(p104.Weapon);

    if v106 and v106.ShootingOptions == "Dual" then
        return;
    end;

    local v107 = u5[p101] or {
        Character = nil
    };
    u5[p101] = v107;
    local v108 = v107[p103];
    local Skin = p104.Skin;
    local v109;

    if p104.Weapon == p105.Name then
        v109 = Skin == p105.Skin;
    else
        v109 = false;
    end;

    local v110 = not v109;

    if v108 then
        local v111;

        if v108.Skin == p104.Skin then
            v111 = v108.Weapon == p104.Weapon;
        else
            v111 = false;
        end;

        if v111 and v108.Model then
            if v108.Visible ~= v110 then
                SetModelVisible(v108.Model, v110);
                v108.Visible = v110;
            end;

            return;
        end;

        local Model = v108.Model;

        if Model then
            Model:Destroy();
        end;
    end;

    v107[p103] = nil;
    dlog(p101, "holster slot=%d weapon=%s skin=%s equippedInHand=%s", p103, p104.Weapon, p104.Skin, (tostring(v109)));
    CacheWeaponCharacterModel(p101, p102, p103, p104, v110);
end;

local function CreateCharacterWeapons(p112: userdata, p113: userdata, p114: table, p115: table) -- Line: 709
    -- upvalues: InitializePlayerCache (copy), u5 (copy), UpdateCachedWeapon (copy), UpdateObjectiveKitHolster (copy), UpdateBombHolster (copy)
    InitializePlayerCache(p112, p113);
    local v116 = u5[p112] or {
        Character = nil
    };
    u5[p112] = v116;

    for i = 1, 3 do
        local v117 = v116[i];
        local v118;

        if p115[i] or not v117 then
            v118 = i;
        else
            local Model = v117.Model;

            if Model then
                Model:Destroy();
            end;

            v116[i] = nil;
            v118 = i;
        end;
    end;

    for i, v in pairs(p115) do
        if v then
            UpdateCachedWeapon(p112, p113, i, v, p114);
        end;
    end;

    UpdateObjectiveKitHolster(p112, p113);
    UpdateBombHolster(p112, p113, p114);
end;

local function SetupSuppressorState(p119: userdata, p120: any, p121: boolean) -- Line: 739
    local Silencer = p119:FindFirstChild("Silencer", true);

    if Silencer and p120.HasSuppressor then
        Silencer.Transparency = p121 and 0 or 1;
    end;
end;

local function ResolveWeaponBindPart(p122: userdata, p123: string?) -- Line: 755
    if p123 then
        local v124 = p122:FindFirstChild(p123, true);

        if v124 and v124:IsA("BasePart") then
            return v124;
        end;
    end;

    if p122.PrimaryPart then
        return p122.PrimaryPart;
    end;

    local Insert = p122:FindFirstChild("Insert", true);

    if Insert and Insert:IsA("BasePart") then
        return Insert;
    end;

    return p122:FindFirstChildWhichIsA("BasePart", true);
end;

local function CreateMotor6DAttachment(p125: userdata, p126: userdata, p127: string?) -- Line: 777
    -- upvalues: ResolveWeaponBindPart (copy), ThirdPersonWeaponStash (copy)
    local v128 = ResolveWeaponBindPart(p126, p127);

    if not v128 then
        warn((`CreateMotor6DAttachment: no bindable part on "{p126.Name}", skipping attachment`));

        return nil;
    end;

    local CFrame_identity = CFrame.identity;
    local CFrame_identity2 = CFrame.identity;
    local Properties = p126:FindFirstChild("Properties");

    if Properties then
        for _, v in ipairs(p127 and { "LEFT", "RIGHT" } or { "" }) do
            local v129 = Properties:FindFirstChild("C0" .. v);

            if v129 then
                CFrame_identity = v129.Value;
            end;

            local v130 = Properties:FindFirstChild("C1" .. v);

            if v130 then
                CFrame_identity2 = v130.Value;
            end;
        end;
    end;

    ThirdPersonWeaponStash.PoseForJoint(v128, p125, CFrame_identity, CFrame_identity2);
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = "WeaponAttachment" .. (p127 or "");
    Motor6D.C0 = CFrame_identity;
    Motor6D.C1 = CFrame_identity2;
    Motor6D.Part0 = p125;
    Motor6D.Part1 = v128;
    Motor6D.Parent = p125;

    return Motor6D;
end;

local function CreateDualMotor6DAttachments(p131: userdata, p132: userdata) -- Line: 816
    -- upvalues: CreateMotor6DAttachment (copy)
    local RightHand = p131:FindFirstChild("RightHand");
    local LeftHand = p131:FindFirstChild("LeftHand");

    if not (RightHand and LeftHand) then
        warn("CreateDualMotor6DAttachments: Could not find RightHand or LeftHand for dual weapon");

        return {};
    end;

    local v133 = {};
    local v134 = CreateMotor6DAttachment(RightHand, p132, "HandleR");

    if v134 then
        table.insert(v133, v134);
    end;

    local v135 = CreateMotor6DAttachment(LeftHand, p132, "HandleL");

    if v135 then
        table.insert(v133, v135);
    end;

    return v133;
end;

local function CreateEquippedMotors(p136: userdata, p137: userdata, p138: userdata, p139: boolean) -- Line: 835
    -- upvalues: CreateDualMotor6DAttachments (copy), CreateMotor6DAttachment (copy)
    if p139 then
        return CreateDualMotor6DAttachments(p136, p138);
    end;

    local v140 = CreateMotor6DAttachment(p137, p138, nil);

    return v140 and { v140 } or {};
end;

local function GetEquippedModelKey(p141: userdata, p142: table) -- Line: 851
    -- upvalues: HttpService (copy)
    local Stickers = p142.Stickers;
    local table_concat = table.concat;
    local v143 = {};
    local Name = p142.Name;
    local Skin = p142.Skin;
    local v144 = tostring(p142.Float);
    local v145 = tostring(p142.StatTrack);
    local v146 = tostring(p142.NameTag);
    local v147 = typeof(Stickers) ~= "table" and "" or HttpService:JSONEncode(Stickers);
    local v148;

    if p142.Name == "Smoke Grenade" then
        v148 = p141:GetAttribute("Team");

        if v148 ~= "Counter-Terrorists" and v148 ~= "Terrorists" then
            v148 = nil;
        end;
    else
        v148 = nil;
    end;

    v143[1], v143[2], v143[3], v143[4], v143[5], v143[6], v143[7] = Name, Skin, v144, v145, v146, v147, tostring(v148);

    return table_concat(v143, "|");
end;

local function ParkActiveEquipped(p149: table) -- Line: 865
    -- upvalues: ThirdPersonWeaponStash (copy)
    local ActiveEquipped = p149.ActiveEquipped;

    if not ActiveEquipped then
        return;
    end;

    p149.ActiveEquipped = nil;
    ThirdPersonWeaponStash.Park(ActiveEquipped.Model, ActiveEquipped.Motors);
end;

local function EvictEquippedModels(p150: table) -- Line: 874
    local v151 = 0;
    local v152 = (1 / 0);
    local v153 = nil;

    for i, v in pairs(p150) do
        v151 = v151 + 1;

        if v.LastUsed < v152 then
            v152 = v.LastUsed;
            v153 = i;
        end;
    end;

    if v151 > 8 and v153 then
        local Model = p150[v153].Model;

        if Model then
            Model:Destroy();
        end;

        p150[v153] = nil;
    end;
end;

local function CreateEquippedWeapon(p154: userdata, p155: userdata, p156: table) -- Line: 890
    -- upvalues: Attachments (copy), GetWeaponProperties (copy), u5 (copy), ThirdPersonWeaponStash (copy), GetOrCreateCharacterFolder (copy), GetEquippedModelKey (copy), CreateEquippedMotors (copy), Skins (copy), dlog (copy), SetWeaponProperties (copy), GetMuzzleFlash (copy), Character (copy), EvictEquippedModels (copy)
    if not p155.Parent then
        return nil;
    end;

    local Name = p156.Name;
    local v157 = Attachments.WEAPON_JOINT_PARTS[Name] or Attachments.DEFAULT_JOINT_PART;
    local v158 = p155:WaitForChild(v157, 10);
    local v159 = `Failed to get joint part: {v157} for weapon: {Name}`;
    assert(v158, v159);
    local v160 = GetWeaponProperties(p156.Name);

    if not v160 then
        return nil;
    end;

    local v161 = u5[p154] or {
        Character = nil
    };
    u5[p154] = v161;
    local ActiveEquipped = v161.ActiveEquipped;

    if ActiveEquipped then
        v161.ActiveEquipped = nil;
        ThirdPersonWeaponStash.Park(ActiveEquipped.Model, ActiveEquipped.Motors);
    end;

    local v162 = GetOrCreateCharacterFolder(p155, "WeaponModel");
    v162:ClearAllChildren();
    local WeaponAttachment = v158:FindFirstChild("WeaponAttachment");

    if WeaponAttachment then
        WeaponAttachment:Destroy();
    end;

    local WeaponAttachmentHandleR = v158:FindFirstChild("WeaponAttachmentHandleR");

    if WeaponAttachmentHandleR then
        WeaponAttachmentHandleR:Destroy();
    end;

    local LeftHand = p155:FindFirstChild("LeftHand");
    local v163 = LeftHand and LeftHand:FindFirstChild("WeaponAttachmentHandleL");

    if v163 then
        v163:Destroy();
    end;

    local v164 = v161.EquippedModels or {};
    v161.EquippedModels = v164;
    local v165 = GetEquippedModelKey(p154, p156);
    local v166 = v160.ShootingOptions == "Dual";
    local v167 = v164[v165];

    if v167 then
        v164[v165] = nil;

        if ThirdPersonWeaponStash.TryUnpark(v167.Model, v162) then
            local IsSuppressed = p156.IsSuppressed;
            local Silencer = v167.Model:FindFirstChild("Silencer", true);

            if Silencer and v160.HasSuppressor then
                Silencer.Transparency = IsSuppressed and 0 or 1;
            end;

            v167.Motors = CreateEquippedMotors(p155, v158, v167.Model, v166);

            if #v167.Motors == 0 then
                local Model = v167.Model;

                if Model then
                    Model:Destroy();
                end;

                return nil;
            end;

            ThirdPersonWeaponStash.Release(v167.Motors);
            v167.LastUsed = os.clock();
            v164[v165] = v167;
            v161.ActiveEquipped = v167;

            return v158;
        end;
    end;

    local GetCharacterModel = Skins.GetCharacterModel;
    local Name2 = p156.Name;
    local Skin = p156.Skin;
    local Float = p156.Float;
    local StatTrack = p156.StatTrack;
    local NameTag = p156.NameTag;
    local Stickers = p156.Stickers;
    local v168;

    if p156.Name == "Smoke Grenade" then
        v168 = p154:GetAttribute("Team");

        if v168 ~= "Counter-Terrorists" and v168 ~= "Terrorists" then
            v168 = nil;
        end;
    else
        v168 = nil;
    end;

    local v169 = GetCharacterModel(Name2, Skin, Float, StatTrack, NameTag, false, Stickers, v168);

    if not v169 then
        dlog(p154, "equipped weapon skipped: SkinHandler returned nil for weapon=%s skin=%s", p156.Name, p156.Skin);

        return nil;
    end;

    SetWeaponProperties(v169);
    local IsSuppressed = p156.IsSuppressed;
    local Silencer = v169:FindFirstChild("Silencer", true);

    if Silencer and v160.HasSuppressor then
        Silencer.Transparency = IsSuppressed and 0 or 1;
    end;

    local v170 = v160.MuzzleType and v169:FindFirstChild("Interactables");

    if v170 then
        if v166 then
            local MuzzlePartL = v170:FindFirstChild("MuzzlePartL");

            if MuzzlePartL and v160.MuzzleType then
                GetMuzzleFlash(MuzzlePartL, Character, v160.MuzzleType, "WeldConstraint");

                if v160.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartL, Character, "Suppressor", "WeldConstraint");
                end;
            end;

            local MuzzlePartR = v170:FindFirstChild("MuzzlePartR");

            if MuzzlePartR and v160.MuzzleType then
                GetMuzzleFlash(MuzzlePartR, Character, v160.MuzzleType, "WeldConstraint");

                if v160.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartR, Character, "Suppressor", "WeldConstraint");
                end;
            end;
        else
            local MuzzlePart = v170:FindFirstChild("MuzzlePart");

            if MuzzlePart and v160.MuzzleType then
                GetMuzzleFlash(MuzzlePart, Character, v160.MuzzleType, "WeldConstraint");

                if v160.HasSuppressor then
                    GetMuzzleFlash(MuzzlePart, Character, "Suppressor", "WeldConstraint");
                end;
            end;
        end;
    end;

    local v171 = CreateEquippedMotors(p155, v158, v169, v166);

    if #v171 == 0 then
        dlog(p154, "equipped weapon skipped: nothing to joint on weapon=%s", p156.Name);

        if v169 then
            v169:Destroy();
        end;

        return nil;
    end;

    v169.Name = "Equipped";
    v169.Parent = v162;
    local v172 = {
        Model = v169,
        Motors = v171,
        LastUsed = os.clock()
    };
    v164[v165] = v172;
    v161.ActiveEquipped = v172;
    EvictEquippedModels(v164);

    return v158;
end;

local v178 = setmetatable({}, {
    __call = function(p173: any, p174: userdata, p175: table, p176: table) -- Line: 1001, Name: __call
        -- upvalues: CharacterResolver (copy), InitializePlayerCache (copy), CreateEquippedWeapon (copy), CreateCharacterWeapons (copy), ClearPlayerCache (copy)
        local PlayerCharacter = CharacterResolver.getPlayerCharacter(p174);

        if PlayerCharacter then
            InitializePlayerCache(p174, PlayerCharacter);
            local v177 = CreateEquippedWeapon(p174, PlayerCharacter, p175);
            CreateCharacterWeapons(p174, PlayerCharacter, p175, p176);

            if v177 then
                return v177, ClearPlayerCache;
            end;
        end;

        return nil, nil;
    end
});
v178.ClearPlayerCache = ClearPlayerCache;

function v178.RefreshObjectiveKitHolster(p179: userdata) -- Line: 1024
    -- upvalues: CharacterResolver (copy), InitializePlayerCache (copy), UpdateObjectiveKitHolster (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p179);

    if PlayerCharacter then
        InitializePlayerCache(p179, PlayerCharacter);
        UpdateObjectiveKitHolster(p179, PlayerCharacter);
    end;
end;

function v178.RefreshBombHolster(p180: userdata) -- Line: 1032
    -- upvalues: CharacterResolver (copy), InitializePlayerCache (copy), HttpService (copy), UpdateBombHolster (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p180);

    if not PlayerCharacter then
        return;
    end;

    InitializePlayerCache(p180, PlayerCharacter);
    local Attribute = p180:GetAttribute("CurrentEquipped");
    local v181;

    if Attribute then
        v181 = HttpService:JSONDecode(Attribute);
    else
        v181 = nil;
    end;

    UpdateBombHolster(p180, PlayerCharacter, v181);
end;

function v178.RefreshSuppressorState(p182: userdata, p183: table) -- Line: 1046
    -- upvalues: CharacterResolver (copy), GetWeaponProperties (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p182);

    if PlayerCharacter then
        PlayerCharacter = PlayerCharacter:FindFirstChild("WeaponModel");
    end;

    if PlayerCharacter then
        PlayerCharacter = PlayerCharacter:FindFirstChild("Equipped");
    end;

    if not (PlayerCharacter and PlayerCharacter:IsA("Model")) then
        return false;
    end;

    local v184 = GetWeaponProperties(p183.Name);

    if not v184 then
        return false;
    end;

    local IsSuppressed = p183.IsSuppressed;
    local Silencer = PlayerCharacter:FindFirstChild("Silencer", true);

    if Silencer and v184.HasSuppressor then
        Silencer.Transparency = IsSuppressed and 0 or 1;
    end;

    return true;
end;

Players.PlayerRemoving:Connect(ClearPlayerCache);

return v178;