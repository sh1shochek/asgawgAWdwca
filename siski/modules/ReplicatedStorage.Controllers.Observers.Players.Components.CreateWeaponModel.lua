-- ReplicatedStorage.Controllers.Observers.Players.Components.CreateWeaponModel
-- class: ModuleScript

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

local function dlog(p7: userdata?, p8: string, ...) -- Line: 120
    -- upvalues: DebugFlags (copy)
    if not DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
        return;
    end;

    warn((not p7 and "[ThirdPersonWeaponModels] " or "[ThirdPersonWeaponModels] " .. p7.Name .. " - ") .. p8:format(...));
end;

local function destroyInstance(p9: userdata?) -- Line: 130
    if p9 then
        p9:Destroy();
    end;
end;

local function GetSmokeGrenadeTeam(p10: userdata, p11: string) -- Line: 139
    if p11 ~= "Smoke Grenade" then
        return nil;
    end;

    local Attribute = p10:GetAttribute("Team");

    if Attribute == "Counter-Terrorists" or Attribute == "Terrorists" then
        return Attribute;
    end;

    return nil;
end;

local function IsWeaponEquippedInHand(p12: string, p13: string, p14: table) -- Line: 152
    local v15;

    if p12 == p14.Name then
        v15 = p13 == p14.Skin;
    else
        v15 = false;
    end;

    return v15;
end;

local function GetCharacterData(p16: userdata) -- Line: 158
    -- upvalues: u5 (copy)
    local v17 = u5[p16] or {
        Character = nil
    };
    u5[p16] = v17;

    return v17;
end;

local function GetJointPart(p18: string, p19: userdata) -- Line: 166
    -- upvalues: Attachments (copy)
    local v20 = Attachments.WEAPON_JOINT_PARTS[p18] or Attachments.DEFAULT_JOINT_PART;
    local v21 = p19:WaitForChild(v20, 10);
    local v22 = `Failed to get joint part: {v20} for weapon: {p18}`;
    assert(v21, v22);

    return v21;
end;

local function GetUpperTorso(p23: userdata) -- Line: 175
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

local function SetWeaponProperties(p26: userdata) -- Line: 192
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

local function SetupMuzzleFlashPart(p28: userdata?, p29: any) -- Line: 212
    -- upvalues: GetMuzzleFlash (copy), Character (copy)
    if not (p28 and p29.MuzzleType) then
        return;
    end;

    GetMuzzleFlash(p28, Character, p29.MuzzleType, "WeldConstraint");

    if p29.HasSuppressor then
        GetMuzzleFlash(p28, Character, "Suppressor", "WeldConstraint");
    end;
end;

local function SetModelVisible(p30: userdata, p31: userdata, p32: boolean) -- Line: 225
    -- upvalues: u2 (copy)
    if p32 then
        p32 = p30:GetAttribute("SpectatedFirstPerson") ~= true;
    end;

    for _, descendant in ipairs(p31:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = u2[descendant.Name] or (p32 and 0 or 1);
        end;
    end;
end;

local function CreateWeldForWeapon(p33: userdata, p34: userdata) -- Line: 237
    local Parent = p34.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        error((`Character attachment parent is not a BasePart: {p34.Name}`));
    end;

    local v35 = p33:FindFirstChild("Insert", true) or p33.PrimaryPart;

    if not v35 then
        error("Weapon model has no PrimaryPart or Insert part");
    end;

    local WeaponAttachment = v35:FindFirstChild("WeaponAttachment");

    if not WeaponAttachment then
        WeaponAttachment = Instance.new("Attachment");
        WeaponAttachment.Name = "WeaponAttachment";
        WeaponAttachment.Parent = v35;
    end;

    p33:PivotTo(Parent.CFrame * p34.CFrame * WeaponAttachment.CFrame:Inverse() * v35.CFrame:Inverse() * p33:GetPivot());
    local Weld = Instance.new("Weld");
    Weld.Name = "HolsterWeld";
    Weld.Part0 = Parent;
    Weld.Part1 = v35;
    Weld.C0 = p34.CFrame;
    Weld.C1 = WeaponAttachment.CFrame;
    Weld.Parent = v35;
end;

local function GetPlayerAttachmentsFolder(p36: userdata) -- Line: 275
    -- upvalues: CharacterResolver (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p36);

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

local function GetOrCreateCharacterFolder(p37: userdata, p38: string) -- Line: 291
    local v39 = nil;

    for _, child in ipairs(p37:GetChildren()) do
        if child.Name == p38 then
            if child:IsA("Folder") and not v39 then
                v39 = child;
            elseif child then
                child:Destroy();
            end;
        end;
    end;

    if v39 then
        return v39;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = p38;
    Folder.Parent = p37;

    return Folder;
end;

local function ToModelWithPrimaryPart(p40: userdata) -- Line: 318
    local v41 = p40:Clone();
    local v42;

    if v41:IsA("Model") then
        v42 = v41;
    else
        v42 = Instance.new("Model");
        v41.Parent = v42;
    end;

    local v43 = v42.PrimaryPart or v42:FindFirstChildWhichIsA("BasePart", true);

    if v43 then
        if not v42.PrimaryPart then
            v42.PrimaryPart = v43;
        end;

        return v42;
    end;

    if v42 then
        v42:Destroy();
    end;

    return nil;
end;

local function GetOrCreateTorsoAttachment(p44: userdata, p45: string, p46) -- Line: 340
    -- upvalues: GetUpperTorso (copy)
    local v47 = p44:FindFirstChild(p45, true);

    if v47 and v47:IsA("Attachment") then
        v47.CFrame = p46;

        return v47;
    end;

    local v48 = GetUpperTorso(p44);

    if not v48 then
        return nil;
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = p45;
    Attachment.CFrame = p46;
    Attachment.Parent = v48;

    return Attachment;
end;

local function AttachHolsterModel(p49: userdata, p50: userdata, p51: userdata, p52: string) -- Line: 361
    -- upvalues: SetWeaponProperties (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy)
    SetWeaponProperties(p50);
    CreateWeldForWeapon(p50, p51);
    local v53 = GetPlayerAttachmentsFolder(p49);

    if not v53 then
        if p50 then
            p50:Destroy();
        end;

        return nil;
    end;

    p50.Name = p52;
    p50.Parent = v53;

    return p50;
end;

local function CreateObjectiveKitHolsterModel(p54: userdata, p55: userdata) -- Line: 378
    -- upvalues: Other (copy), dlog (copy), u3 (copy), GetOrCreateTorsoAttachment (copy), ToModelWithPrimaryPart (copy), SetWeaponProperties (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy)
    local DefuseKit = Other:FindFirstChild("DefuseKit");

    if not DefuseKit then
        dlog(p54, "objective kit holster skipped: missing template Assets.Other.DefuseKit");

        return nil;
    end;

    local BodyBackAttachment = p55:FindFirstChild("BodyBackAttachment", true);
    local v56;

    if BodyBackAttachment and BodyBackAttachment:IsA("Attachment") then
        v56 = BodyBackAttachment.CFrame * u3;
    else
        v56 = u3;
    end;

    local v57 = GetOrCreateTorsoAttachment(p55, "ObjectiveKitAttachment", v56);

    if not v57 then
        dlog(p54, "objective kit holster skipped: no valid character attachment");

        return nil;
    end;

    local v58 = ToModelWithPrimaryPart(DefuseKit);

    if not v58 then
        dlog(p54, "objective kit holster skipped: template has no BasePart");

        return nil;
    end;

    SetWeaponProperties(v58);
    CreateWeldForWeapon(v58, v57);
    local v59 = GetPlayerAttachmentsFolder(p54);

    if not v59 then
        if v58 then
            v58:Destroy();
        end;

        return nil;
    end;

    v58.Name = "ObjectiveKitHolster";
    v58.Parent = v59;

    return v58;
end;

local function DestroyObjectiveKitHolsters(p60: userdata, p61: table) -- Line: 406
    -- upvalues: CharacterResolver (copy)
    local ObjectiveKitHolsterModel = p61.ObjectiveKitHolsterModel;

    if ObjectiveKitHolsterModel then
        ObjectiveKitHolsterModel:Destroy();
    end;

    p61.ObjectiveKitHolsterModel = nil;
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p60);
    local v62;

    if PlayerCharacter then
        v62 = PlayerCharacter:FindFirstChild("WeaponAttachments");
    else
        v62 = nil;
    end;

    if not v62 then
        return;
    end;

    for _, child in ipairs(v62:GetChildren()) do
        if child:IsA("Model") and (child.Name == "ObjectiveKitHolster" and child) then
            child:Destroy();
        end;
    end;
end;

local function UpdateObjectiveKitHolster(p63: userdata, p64: userdata) -- Line: 425
    -- upvalues: u5 (copy), DestroyObjectiveKitHolsters (copy), CreateObjectiveKitHolsterModel (copy)
    local v65 = u5[p63] or {
        Character = nil
    };
    u5[p63] = v65;
    local v66;

    if p63:GetAttribute("Team") == "Counter-Terrorists" then
        v66 = p63:GetAttribute("HasDefuseKit") == true and true or p63:GetAttribute("HasRescueKit") == true;
    else
        v66 = false;
    end;

    local ObjectiveKitHolsterModel = v65.ObjectiveKitHolsterModel;

    if v66 and (ObjectiveKitHolsterModel and ObjectiveKitHolsterModel.Parent) then
        return;
    end;

    DestroyObjectiveKitHolsters(p63, v65);

    if v66 then
        v65.ObjectiveKitHolsterModel = CreateObjectiveKitHolsterModel(p63, p64);
    end;
end;

local function CreateBombHolsterModel(p67: userdata, p68: userdata, p69: any) -- Line: 443
    -- upvalues: GetOrCreateTorsoAttachment (copy), u4 (copy), dlog (copy), Skins (copy), SetWeaponProperties (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy)
    local v70 = GetOrCreateTorsoAttachment(p68, "BombAttachment", u4);

    if not v70 then
        dlog(p67, "bomb holster skipped: no valid character attachment (missing UpperTorso)");

        return nil;
    end;

    local CharacterModel = Skins.GetCharacterModel("C4", p69.Skin or "", p69.Float, p69.StatTrack, p69.NameTag, false, p69.Stickers);

    if not CharacterModel then
        dlog(p67, "bomb holster skipped: SkinHandler returned nil for C4");

        return nil;
    end;

    SetWeaponProperties(CharacterModel);
    CreateWeldForWeapon(CharacterModel, v70);
    local v71 = GetPlayerAttachmentsFolder(p67);

    if not v71 then
        if CharacterModel then
            CharacterModel:Destroy();
        end;

        return nil;
    end;

    CharacterModel.Name = "BombHolster";
    CharacterModel.Parent = v71;

    return CharacterModel;
end;

local function DestroyBombHolster(p72: table) -- Line: 470
    local BombHolsterModel = p72.BombHolsterModel;

    if BombHolsterModel then
        BombHolsterModel:Destroy();
    end;

    p72.BombHolsterModel = nil;
    p72.BombHolsterVisible = nil;
end;

local function UpdateBombHolster(p73: userdata, p74: userdata, p75: table?) -- Line: 478
    -- upvalues: u5 (copy), HttpService (copy), CreateBombHolsterModel (copy), SetModelVisible (copy)
    local v76 = u5[p73] or {
        Character = nil
    };
    u5[p73] = v76;
    local Attribute = p73:GetAttribute("Slot5");
    local v77;

    if Attribute then
        v77 = HttpService:JSONDecode(Attribute);
    else
        v77 = nil;
    end;

    if not v77 or v77.Weapon ~= "C4" then
        local BombHolsterModel = v76.BombHolsterModel;

        if BombHolsterModel then
            BombHolsterModel:Destroy();
        end;

        v76.BombHolsterModel = nil;
        v76.BombHolsterVisible = nil;

        return;
    end;

    local BombHolsterModel = v76.BombHolsterModel;

    if not (BombHolsterModel and BombHolsterModel.Parent) then
        local BombHolsterModel2 = v76.BombHolsterModel;

        if BombHolsterModel2 then
            BombHolsterModel2:Destroy();
        end;

        v76.BombHolsterModel = nil;
        v76.BombHolsterVisible = nil;
        BombHolsterModel = CreateBombHolsterModel(p73, p74, v77);
        v76.BombHolsterModel = BombHolsterModel;
    end;

    if p75 then
        p75 = p75.Name == "C4";
    end;

    local v78 = not p75;

    if BombHolsterModel and v76.BombHolsterVisible ~= v78 then
        SetModelVisible(p74, BombHolsterModel, v78);
        v76.BombHolsterVisible = v78;
    end;
end;

local function CacheWeaponCharacterModel(p79: userdata, p80: userdata, p81: number, p82: table, p83: boolean) -- Line: 505
    -- upvalues: Skins (copy), dlog (copy), SetWeaponProperties (copy), u1 (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy), u5 (copy), SetModelVisible (copy)
    local Weapon = p82.Weapon;
    local Skin = p82.Skin;
    local GetCharacterModel = Skins.GetCharacterModel;
    local Float = p82.Float;
    local StatTrack = p82.StatTrack;
    local NameTag = p82.NameTag;
    local Stickers = p82.Stickers;
    local v84;

    if Weapon == "Smoke Grenade" then
        v84 = p79:GetAttribute("Team");

        if v84 ~= "Counter-Terrorists" and v84 ~= "Terrorists" then
            v84 = nil;
        end;
    else
        v84 = nil;
    end;

    local v85 = GetCharacterModel(Weapon, Skin, Float, StatTrack, NameTag, false, Stickers, v84);

    if not v85 then
        dlog(p79, "holster skipped: SkinHandler returned nil for slot=%d weapon=%s skin=%s", p81, Weapon, Skin);

        return;
    end;

    SetWeaponProperties(v85);
    local v86 = u1[p81];
    local v87;

    if v86 then
        v87 = p80:FindFirstChild(v86, true);
    else
        v87 = nil;
    end;

    if not v87 then
        dlog(p79, "missing character attachment for slot=%d weapon=%s (expected %s)", p81, Weapon, (tostring(v86)));
        error((`Missing character attachment for slot: {p81}`));
    end;

    CreateWeldForWeapon(v85, v87);
    local v88 = GetPlayerAttachmentsFolder(p79);

    if v88 then
        v85.Parent = v88;
        v85.Name = Weapon;
    end;

    local v89 = u5[p79] or {
        Character = nil
    };
    u5[p79] = v89;
    v89[p81] = {
        StatTrack = p82.StatTrack,
        Stickers = p82.Stickers,
        NameTag = p82.NameTag,
        Model = v85,
        Float = p82.Float,
        Charm = p82.Charm,
        Weapon = Weapon,
        Skin = Skin,
        Visible = p83
    };
    dlog(p79, "cached holster slot=%d weapon=%s skin=%s visible=%s", p81, Weapon, Skin, "unknown");
    SetModelVisible(p80, v85, p83);
end;

local function DestroyEquippedModels(p90: table) -- Line: 575
    local EquippedModels = p90.EquippedModels;

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

    p90.EquippedModels = nil;
    p90.ActiveEquipped = nil;
end;

local function DisconnectCharacter(p91: userdata) -- Line: 589
    -- upvalues: u6 (copy)
    local v92 = u6[p91];

    if v92 then
        for _, v in v92 do
            v:Disconnect();
        end;

        u6[p91] = nil;
    end;
end;

local function ClearPlayerCache(p93: userdata) -- Line: 599
    -- upvalues: u6 (copy), u5 (copy), DestroyEquippedModels (copy), dlog (copy)
    local v94 = u6[p93];

    if v94 then
        for _, v in v94 do
            v:Disconnect();
        end;

        u6[p93] = nil;
    end;

    local v95 = u5[p93];

    if v95 then
        local Character2 = v95.Character;
        DestroyEquippedModels(v95);
        local ObjectiveKitHolsterModel = v95.ObjectiveKitHolsterModel;

        if ObjectiveKitHolsterModel then
            ObjectiveKitHolsterModel:Destroy();
        end;

        v95.ObjectiveKitHolsterModel = nil;
        local BombHolsterModel = v95.BombHolsterModel;

        if BombHolsterModel then
            BombHolsterModel:Destroy();
        end;

        v95.BombHolsterModel = nil;
        v95.BombHolsterVisible = nil;

        for i, v in pairs(v95) do
            if typeof(i) == "number" and typeof(v) == "table" then
                local Model = v.Model;

                if Model then
                    Model:Destroy();
                end;

                v95[i] = nil;
            end;
        end;

        if Character2 then
            for _, v in { "WeaponModel", "WeaponAttachments" } do
                local v96 = Character2:FindFirstChild(v);

                if v96 and v96:IsA("Folder") then
                    v96:ClearAllChildren();
                end;
            end;
        end;
    end;

    dlog(p93, "cleared player cache (destroyed holsters)");
    u5[p93] = nil;
end;

local function RefreshHolsterVisibility(p97: userdata, p98: userdata) -- Line: 634
    -- upvalues: u5 (copy), SetModelVisible (copy)
    local v99 = u5[p97];

    if not v99 or v99.Character ~= p98 then
        return;
    end;

    for i, v in pairs(v99) do
        if typeof(i) == "number" and (typeof(v) == "table" and (v.Model and v.Visible ~= nil)) then
            SetModelVisible(p98, v.Model, v.Visible);
        end;
    end;

    local BombHolsterModel = v99.BombHolsterModel;

    if BombHolsterModel and v99.BombHolsterVisible ~= nil then
        SetModelVisible(p98, BombHolsterModel, v99.BombHolsterVisible);
    end;
end;

local function InitializePlayerCache(u100: userdata, u101: userdata) -- Line: 657
    -- upvalues: u5 (copy), ClearPlayerCache (copy), u6 (copy), RefreshHolsterVisibility (copy), DestroyEquippedModels (copy)
    local v102 = u5[u100] or {
        Character = nil
    };
    u5[u100] = v102;

    if v102.Character == u101 then
        return;
    end;

    if v102.Character then
        ClearPlayerCache(u100);
        v102 = u5[u100] or {
            Character = nil
        };
        u5[u100] = v102;
    end;

    v102.Character = u101;
    local v103 = u6[u100];

    if v103 then
        for _, v in v103 do
            v:Disconnect();
        end;

        u6[u100] = nil;
    end;

    u6[u100] = { u101:GetAttributeChangedSignal("SpectatedFirstPerson"):Connect(function() -- Line: 671
            -- upvalues: RefreshHolsterVisibility (ref), u100 (copy), u101 (copy)
            RefreshHolsterVisibility(u100, u101);
        end), (u101.AncestryChanged:Connect(function(p104, p105) -- Line: 674
            -- upvalues: u5 (ref), u100 (copy), DestroyEquippedModels (ref)
            local v106 = u5[u100];

            if p105 or not v106 then
                return;
            end;

            DestroyEquippedModels(v106);
            v106.ObjectiveKitHolsterModel = nil;
            v106.BombHolsterModel = nil;

            for i, v in pairs(v106) do
                if typeof(i) == "number" and typeof(v) == "table" then
                    v106[i] = nil;
                end;
            end;

            v106.Character = nil;
        end)) };
end;

local function UpdateCachedWeapon(p107: userdata, p108: userdata, p109: number, p110: table, p111: table) -- Line: 695
    -- upvalues: GetWeaponProperties (copy), u5 (copy), SetModelVisible (copy), dlog (copy), CacheWeaponCharacterModel (copy)
    local v112 = GetWeaponProperties(p110.Weapon);

    if v112 and v112.ShootingOptions == "Dual" then
        return;
    end;

    local v113 = u5[p107] or {
        Character = nil
    };
    u5[p107] = v113;
    local v114 = v113[p109];
    local Skin = p110.Skin;
    local v115;

    if p110.Weapon == p111.Name then
        v115 = Skin == p111.Skin;
    else
        v115 = false;
    end;

    local v116 = not v115;

    if v114 then
        local v117;

        if v114.Skin == p110.Skin then
            v117 = v114.Weapon == p110.Weapon;
        else
            v117 = false;
        end;

        if v117 and v114.Model then
            if v114.Visible ~= v116 then
                SetModelVisible(p108, v114.Model, v116);
                v114.Visible = v116;
            end;

            return;
        end;

        local Model = v114.Model;

        if Model then
            Model:Destroy();
        end;
    end;

    v113[p109] = nil;
    dlog(p107, "holster slot=%d weapon=%s skin=%s equippedInHand=%s", p109, p110.Weapon, p110.Skin, (tostring(v115)));
    CacheWeaponCharacterModel(p107, p108, p109, p110, v116);
end;

local function CreateCharacterWeapons(p118: userdata, p119: userdata, p120: table, p121: table) -- Line: 740
    -- upvalues: InitializePlayerCache (copy), u5 (copy), UpdateCachedWeapon (copy), UpdateObjectiveKitHolster (copy), UpdateBombHolster (copy)
    InitializePlayerCache(p118, p119);
    local v122 = u5[p118] or {
        Character = nil
    };
    u5[p118] = v122;

    for i = 1, 3 do
        local v123 = v122[i];
        local v124;

        if p121[i] or not v123 then
            v124 = i;
        else
            local Model = v123.Model;

            if Model then
                Model:Destroy();
            end;

            v122[i] = nil;
            v124 = i;
        end;
    end;

    for i, v in pairs(p121) do
        if v then
            UpdateCachedWeapon(p118, p119, i, v, p120);
        end;
    end;

    UpdateObjectiveKitHolster(p118, p119);
    UpdateBombHolster(p118, p119, p120);
end;

local function SetupSuppressorState(p125: userdata, p126: any, p127: boolean) -- Line: 770
    local Silencer = p125:FindFirstChild("Silencer", true);

    if Silencer and p126.HasSuppressor then
        Silencer.Transparency = p127 and 0 or 1;
    end;
end;

local function ResolveWeaponBindPart(p128: userdata, p129: string?) -- Line: 786
    if p129 then
        local v130 = p128:FindFirstChild(p129, true);

        if v130 and v130:IsA("BasePart") then
            return v130;
        end;
    end;

    if p128.PrimaryPart then
        return p128.PrimaryPart;
    end;

    local Insert = p128:FindFirstChild("Insert", true);

    if Insert and Insert:IsA("BasePart") then
        return Insert;
    end;

    return p128:FindFirstChildWhichIsA("BasePart", true);
end;

local function CreateMotor6DAttachment(p131: userdata, p132: userdata, p133: string?) -- Line: 808
    -- upvalues: ResolveWeaponBindPart (copy), ThirdPersonWeaponStash (copy)
    local v134 = ResolveWeaponBindPart(p132, p133);

    if not v134 then
        warn((`CreateMotor6DAttachment: no bindable part on "{p132.Name}", skipping attachment`));

        return nil;
    end;

    local CFrame_identity = CFrame.identity;
    local CFrame_identity2 = CFrame.identity;
    local Properties = p132:FindFirstChild("Properties");

    if Properties then
        for _, v in ipairs(p133 and { "LEFT", "RIGHT" } or { "" }) do
            local v135 = Properties:FindFirstChild("C0" .. v);

            if v135 then
                CFrame_identity = v135.Value;
            end;

            local v136 = Properties:FindFirstChild("C1" .. v);

            if v136 then
                CFrame_identity2 = v136.Value;
            end;
        end;
    end;

    ThirdPersonWeaponStash.PoseForJoint(p132, v134, p131, CFrame_identity, CFrame_identity2);
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = "WeaponAttachment" .. (p133 or "");
    Motor6D.C0 = CFrame_identity;
    Motor6D.C1 = CFrame_identity2;
    Motor6D.Part0 = p131;
    Motor6D.Part1 = v134;
    Motor6D.Parent = p131;

    return Motor6D;
end;

local function CreateDualMotor6DAttachments(p137: userdata, p138: userdata) -- Line: 847
    -- upvalues: CreateMotor6DAttachment (copy)
    local RightHand = p137:FindFirstChild("RightHand");
    local LeftHand = p137:FindFirstChild("LeftHand");

    if not (RightHand and LeftHand) then
        warn("CreateDualMotor6DAttachments: Could not find RightHand or LeftHand for dual weapon");

        return {};
    end;

    local v139 = {};
    local v140 = CreateMotor6DAttachment(RightHand, p138, "HandleR");

    if v140 then
        table.insert(v139, v140);
    end;

    local v141 = CreateMotor6DAttachment(LeftHand, p138, "HandleL");

    if v141 then
        table.insert(v139, v141);
    end;

    return v139;
end;

local function CreateEquippedMotors(p142: userdata, p143: userdata, p144: userdata, p145: boolean) -- Line: 866
    -- upvalues: CreateDualMotor6DAttachments (copy), CreateMotor6DAttachment (copy)
    if p145 then
        return CreateDualMotor6DAttachments(p142, p144);
    end;

    local v146 = CreateMotor6DAttachment(p143, p144, nil);

    return v146 and { v146 } or {};
end;

local function GetEquippedModelKey(p147: userdata, p148: table) -- Line: 882
    -- upvalues: HttpService (copy)
    local Stickers = p148.Stickers;
    local table_concat = table.concat;
    local v149 = {};
    local Name = p148.Name;
    local Skin = p148.Skin;
    local v150 = tostring(p148.Float);
    local v151 = tostring(p148.StatTrack);
    local v152 = tostring(p148.NameTag);
    local v153 = typeof(Stickers) ~= "table" and "" or HttpService:JSONEncode(Stickers);
    local v154;

    if p148.Name == "Smoke Grenade" then
        v154 = p147:GetAttribute("Team");

        if v154 ~= "Counter-Terrorists" and v154 ~= "Terrorists" then
            v154 = nil;
        end;
    else
        v154 = nil;
    end;

    v149[1], v149[2], v149[3], v149[4], v149[5], v149[6], v149[7] = Name, Skin, v150, v151, v152, v153, tostring(v154);

    return table_concat(v149, "|");
end;

local function ParkActiveEquipped(p155: table) -- Line: 896
    -- upvalues: ThirdPersonWeaponStash (copy)
    local ActiveEquipped = p155.ActiveEquipped;

    if not ActiveEquipped then
        return;
    end;

    p155.ActiveEquipped = nil;
    ThirdPersonWeaponStash.Park(ActiveEquipped.Model, ActiveEquipped.Motors);
end;

local function EvictEquippedModels(p156: table) -- Line: 905
    local v157 = 0;
    local v158 = (1 / 0);
    local v159 = nil;

    for i, v in pairs(p156) do
        v157 = v157 + 1;

        if v.LastUsed < v158 then
            v158 = v.LastUsed;
            v159 = i;
        end;
    end;

    if v157 > 8 and v159 then
        local Model = p156[v159].Model;

        if Model then
            Model:Destroy();
        end;

        p156[v159] = nil;
    end;
end;

local function CreateEquippedWeapon(p160: userdata, p161: userdata, p162: table) -- Line: 921
    -- upvalues: Attachments (copy), GetWeaponProperties (copy), u5 (copy), ThirdPersonWeaponStash (copy), GetOrCreateCharacterFolder (copy), GetEquippedModelKey (copy), CreateEquippedMotors (copy), Skins (copy), dlog (copy), SetWeaponProperties (copy), GetMuzzleFlash (copy), Character (copy), EvictEquippedModels (copy)
    if not p161.Parent then
        return nil;
    end;

    local Name = p162.Name;
    local v163 = Attachments.WEAPON_JOINT_PARTS[Name] or Attachments.DEFAULT_JOINT_PART;
    local v164 = p161:WaitForChild(v163, 10);
    local v165 = `Failed to get joint part: {v163} for weapon: {Name}`;
    assert(v164, v165);
    local v166 = GetWeaponProperties(p162.Name);

    if not v166 then
        return nil;
    end;

    local v167 = u5[p160] or {
        Character = nil
    };
    u5[p160] = v167;
    local ActiveEquipped = v167.ActiveEquipped;

    if ActiveEquipped then
        v167.ActiveEquipped = nil;
        ThirdPersonWeaponStash.Park(ActiveEquipped.Model, ActiveEquipped.Motors);
    end;

    local v168 = GetOrCreateCharacterFolder(p161, "WeaponModel");
    v168:ClearAllChildren();
    local WeaponAttachment = v164:FindFirstChild("WeaponAttachment");

    if WeaponAttachment then
        WeaponAttachment:Destroy();
    end;

    local WeaponAttachmentHandleR = v164:FindFirstChild("WeaponAttachmentHandleR");

    if WeaponAttachmentHandleR then
        WeaponAttachmentHandleR:Destroy();
    end;

    local LeftHand = p161:FindFirstChild("LeftHand");
    local v169 = LeftHand and LeftHand:FindFirstChild("WeaponAttachmentHandleL");

    if v169 then
        v169:Destroy();
    end;

    local v170 = v167.EquippedModels or {};
    v167.EquippedModels = v170;
    local v171 = GetEquippedModelKey(p160, p162);
    local v172 = v166.ShootingOptions == "Dual";
    local v173 = v170[v171];

    if v173 then
        v170[v171] = nil;

        if ThirdPersonWeaponStash.TryUnpark(v173.Model, v168) then
            local IsSuppressed = p162.IsSuppressed;
            local Silencer = v173.Model:FindFirstChild("Silencer", true);

            if Silencer and v166.HasSuppressor then
                Silencer.Transparency = IsSuppressed and 0 or 1;
            end;

            v173.Motors = CreateEquippedMotors(p161, v164, v173.Model, v172);

            if #v173.Motors == 0 then
                local Model = v173.Model;

                if Model then
                    Model:Destroy();
                end;

                return nil;
            end;

            ThirdPersonWeaponStash.Release(v173.Motors);
            v173.LastUsed = os.clock();
            v170[v171] = v173;
            v167.ActiveEquipped = v173;

            return v164;
        end;
    end;

    local GetCharacterModel = Skins.GetCharacterModel;
    local Name2 = p162.Name;
    local Skin = p162.Skin;
    local Float = p162.Float;
    local StatTrack = p162.StatTrack;
    local NameTag = p162.NameTag;
    local Stickers = p162.Stickers;
    local v174;

    if p162.Name == "Smoke Grenade" then
        v174 = p160:GetAttribute("Team");

        if v174 ~= "Counter-Terrorists" and v174 ~= "Terrorists" then
            v174 = nil;
        end;
    else
        v174 = nil;
    end;

    local v175 = GetCharacterModel(Name2, Skin, Float, StatTrack, NameTag, false, Stickers, v174);

    if not v175 then
        dlog(p160, "equipped weapon skipped: SkinHandler returned nil for weapon=%s skin=%s", p162.Name, p162.Skin);

        return nil;
    end;

    SetWeaponProperties(v175);
    local IsSuppressed = p162.IsSuppressed;
    local Silencer = v175:FindFirstChild("Silencer", true);

    if Silencer and v166.HasSuppressor then
        Silencer.Transparency = IsSuppressed and 0 or 1;
    end;

    local v176 = v166.MuzzleType and v175:FindFirstChild("Interactables");

    if v176 then
        if v172 then
            local MuzzlePartL = v176:FindFirstChild("MuzzlePartL");

            if MuzzlePartL and v166.MuzzleType then
                GetMuzzleFlash(MuzzlePartL, Character, v166.MuzzleType, "WeldConstraint");

                if v166.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartL, Character, "Suppressor", "WeldConstraint");
                end;
            end;

            local MuzzlePartR = v176:FindFirstChild("MuzzlePartR");

            if MuzzlePartR and v166.MuzzleType then
                GetMuzzleFlash(MuzzlePartR, Character, v166.MuzzleType, "WeldConstraint");

                if v166.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartR, Character, "Suppressor", "WeldConstraint");
                end;
            end;
        else
            local MuzzlePart = v176:FindFirstChild("MuzzlePart");

            if MuzzlePart and v166.MuzzleType then
                GetMuzzleFlash(MuzzlePart, Character, v166.MuzzleType, "WeldConstraint");

                if v166.HasSuppressor then
                    GetMuzzleFlash(MuzzlePart, Character, "Suppressor", "WeldConstraint");
                end;
            end;
        end;
    end;

    local v177 = CreateEquippedMotors(p161, v164, v175, v172);

    if #v177 == 0 then
        dlog(p160, "equipped weapon skipped: nothing to joint on weapon=%s", p162.Name);

        if v175 then
            v175:Destroy();
        end;

        return nil;
    end;

    v175.Name = "Equipped";
    v175.Parent = v168;
    local v178 = {
        Model = v175,
        Motors = v177,
        LastUsed = os.clock()
    };
    v170[v171] = v178;
    v167.ActiveEquipped = v178;
    EvictEquippedModels(v170);

    return v164;
end;

local v184 = setmetatable({}, {
    __call = function(p179: any, p180: userdata, p181: table, p182: table) -- Line: 1032, Name: __call
        -- upvalues: CharacterResolver (copy), InitializePlayerCache (copy), CreateEquippedWeapon (copy), CreateCharacterWeapons (copy), ClearPlayerCache (copy)
        local PlayerCharacter = CharacterResolver.getPlayerCharacter(p180);

        if PlayerCharacter then
            InitializePlayerCache(p180, PlayerCharacter);
            local v183 = CreateEquippedWeapon(p180, PlayerCharacter, p181);
            CreateCharacterWeapons(p180, PlayerCharacter, p181, p182);

            if v183 then
                return v183, ClearPlayerCache;
            end;
        end;

        return nil, nil;
    end
});
v184.ClearPlayerCache = ClearPlayerCache;

function v184.RefreshObjectiveKitHolster(p185: userdata) -- Line: 1055
    -- upvalues: CharacterResolver (copy), InitializePlayerCache (copy), UpdateObjectiveKitHolster (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p185);

    if PlayerCharacter then
        InitializePlayerCache(p185, PlayerCharacter);
        UpdateObjectiveKitHolster(p185, PlayerCharacter);
    end;
end;

function v184.RefreshBombHolster(p186: userdata) -- Line: 1063
    -- upvalues: CharacterResolver (copy), InitializePlayerCache (copy), HttpService (copy), UpdateBombHolster (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p186);

    if not PlayerCharacter then
        return;
    end;

    InitializePlayerCache(p186, PlayerCharacter);
    local Attribute = p186:GetAttribute("CurrentEquipped");
    local v187;

    if Attribute then
        v187 = HttpService:JSONDecode(Attribute);
    else
        v187 = nil;
    end;

    UpdateBombHolster(p186, PlayerCharacter, v187);
end;

function v184.RefreshSuppressorState(p188: userdata, p189: table) -- Line: 1077
    -- upvalues: CharacterResolver (copy), GetWeaponProperties (copy)
    local PlayerCharacter = CharacterResolver.getPlayerCharacter(p188);

    if PlayerCharacter then
        PlayerCharacter = PlayerCharacter:FindFirstChild("WeaponModel");
    end;

    if PlayerCharacter then
        PlayerCharacter = PlayerCharacter:FindFirstChild("Equipped");
    end;

    if not (PlayerCharacter and PlayerCharacter:IsA("Model")) then
        return false;
    end;

    local v190 = GetWeaponProperties(p189.Name);

    if not v190 then
        return false;
    end;

    local IsSuppressed = p189.IsSuppressed;
    local Silencer = PlayerCharacter:FindFirstChild("Silencer", true);

    if Silencer and v190.HasSuppressor then
        Silencer.Transparency = IsSuppressed and 0 or 1;
    end;

    return true;
end;

Players.PlayerRemoving:Connect(ClearPlayerCache);

return v184;