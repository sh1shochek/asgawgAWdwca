-- ReplicatedStorage.Controllers.Observers.Players.Components.CreateWeaponModel
-- Script path: ReplicatedStorage.Controllers.Observers.Players.Components.CreateWeaponModel
-- Decompile time: 15.69 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Other = ReplicatedStorage.Assets.Other
local Character = ((ReplicatedStorage:WaitForChild("Assets")):WaitForChild("MuzzleFlashes")):WaitForChild("Character")
require(ReplicatedStorage.Database.Custom.Types)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local GetMuzzleFlash = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.GetMuzzleFlash)
local ThirdPersonWeaponStash = require(ReplicatedStorage.Components.Common.ThirdPersonWeaponStash)
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Attachments = require(ReplicatedStorage.Database.Custom.GameStats.Character.Attachments)
local u73 = {"PrimaryAttachment", "SecondaryAttachment", "MeleeAttachment"}
local u77 = {
    MuzzlePartL = 1,
    MuzzlePartR = 1,
    MuzzlePart = 1,
    RootPart = 1,
    Hitbox = 1,
    Insert = 1,
    move = 1,
}
local u95 = (CFrame.new(0, -0.4, 0.24)) * CFrame.Angles(0, 3.141592653589793, 0)
local u106 = (CFrame.new(0, 0.2, 0.8)) * CFrame.Angles(1.5707963267948966, 0.20943951023931956, 0.17453292519943295)
local u107 = {}
local u108 = {}

local function dlog(a1, a2, ...) -- Line: 119 -- upvalues: DebugFlags (val) -- types: a1: userdata?, a2: string
    if not DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
        return
    end
    local v1 = if not a1 then "[ThirdPersonWeaponModels] " else "[ThirdPersonWeaponModels] " .. a1.Name .. " - "
    warn(v1 .. a2:format(...))
end

local function destroyInstance(a1) -- Line: 129 -- types: a1: userdata?
    if a1 then
        a1:Destroy()
    end
end

local function GetSmokeGrenadeTeam(a1, a2) -- Line: 138 -- types: a1: userdata, a2: string
    if a2 ~= "Smoke Grenade" then
        return nil
    end
    local Attribute = a1:GetAttribute("Team")
    if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
        return nil
    end
    return Attribute
end

local function IsWeaponEquippedInHand(a1, a2, a3) -- Line: 151 -- types: a1: string, a2: string, a3: table
    local v1 = false
    if a1 == a3.Name then
        v1 = a2 == a3.Skin
    end
    return v1
end

local function GetCharacterData(a1) -- Line: 157 -- upvalues: u107 (val) -- types: a1: userdata
    local v1 = u107[a1] or {}
    u107[a1] = v1
    return v1
end

local function GetJointPart(a1, a2) -- Line: 165 -- upvalues: Attachments (val) -- types: a1: string, a2: userdata
    local DEFAULT_JOINT_PART = Attachments.WEAPON_JOINT_PARTS[a1] or Attachments.DEFAULT_JOINT_PART
    local v1 = a2:WaitForChild(DEFAULT_JOINT_PART, 10)
    assert(v1, (("Failed to get joint part: %* for weapon: %*"):format(DEFAULT_JOINT_PART, a1)))
    return v1
end

local function GetUpperTorso(a1) -- Line: 174 -- types: a1: userdata
    local HumanoidRootPart = a1:FindFirstChild("HumanoidRootPart") or a1:WaitForChild("HumanoidRootPart", 10)
    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        local UpperTorso = a1:FindFirstChild("UpperTorso") or a1:WaitForChild("UpperTorso", 10)
        if UpperTorso and UpperTorso:IsA("BasePart") then
            return UpperTorso
        end
        return nil
    end
    return nil
end

local function SetWeaponProperties(a1) -- Line: 191 -- upvalues: u77 (val) -- types: a1: userdata
    local v1
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CollisionGroup = "WeaponModel"
            v.CastShadow = false
            v.CanCollide = false
            v.CanTouch = false
            v.CanQuery = false
            v.Anchored = false
            v.Massless = true
            v1 = u77[v.Name]
            if v1 then
                v.Transparency = v1
            end
        end
    end
end

local function SetupMuzzleFlashPart(a1, a2) -- Line: 211
    -- upvalues: GetMuzzleFlash (val), Character (val)
    if a1 and a2.MuzzleType then
        GetMuzzleFlash(a1, Character, a2.MuzzleType, "WeldConstraint")
        if a2.HasSuppressor then
            GetMuzzleFlash(a1, Character, "Suppressor", "WeldConstraint")
        end
        return
    end
end

local function SetModelVisible(a1, a2) -- Line: 224 -- upvalues: u77 (val) -- types: a1: userdata, a2: boolean
    local v1
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("BasePart") then
            v1 = u77[v.Name] or (if not a2 then 1 else 0)
            v.Transparency = v1
        end
    end
end

local function CreateWeldForWeapon(a1, a2) -- Line: 234 -- types: a1: userdata, a2: userdata
    local Parent = a2.Parent
    if not Parent or not Parent:IsA("BasePart") then
        error((("Character attachment parent is not a BasePart: %*"):format(a2.Name)))
    end
    local Insert = a1:FindFirstChild("Insert", true)
    if not Insert then
        Insert = a1.PrimaryPart
    end
    if not Insert then
        error("Weapon model has no PrimaryPart or Insert part")
    end
    local WeaponAttachment = Insert:FindFirstChild("WeaponAttachment")
    if not WeaponAttachment then
        WeaponAttachment = Instance.new("Attachment")
        WeaponAttachment.Name = "WeaponAttachment"
        WeaponAttachment.Parent = Insert
    end
    a1:PivotTo(Parent.CFrame * a2.CFrame * (WeaponAttachment.CFrame:Inverse()) * (Insert.CFrame:Inverse()) * (a1:GetPivot()))
    if not pcall(function() -- Line: 258 -- upvalues: Insert (val), a2 (val), WeaponAttachment (ref)
        local AttachmentConstraint
        AttachmentConstraint = Instance.new("AttachmentConstraint")
        AttachmentConstraint.Parent = Insert
        AttachmentConstraint.Attachment0 = a2
        AttachmentConstraint.Attachment1 = WeaponAttachment
        return
    end) then
        local WeldConstraint = Instance.new("WeldConstraint")
        WeldConstraint.Parent = Insert
        WeldConstraint.Part0 = Parent
        WeldConstraint.Part1 = Insert
    end
end

local function GetPlayerAttachmentsFolder(a1) -- Line: 275 -- upvalues: CharacterResolver (val) -- types: a1: userdata
    local v1 = CharacterResolver.getPlayerCharacter(a1)
    if not v1 then
        return nil
    end
    local WeaponAttachments = v1:FindFirstChild("WeaponAttachments")
    if WeaponAttachments and WeaponAttachments:IsA("Folder") then
        return WeaponAttachments
    end
    if WeaponAttachments then
        WeaponAttachments:Destroy()
    end
    local Folder = Instance.new("Folder")
    Folder.Name = "WeaponAttachments"
    Folder.Parent = v1
    return Folder
end

local function GetOrCreateCharacterFolder(a1, a2) -- Line: 291 -- types: a1: userdata, a2: string
    local v1 = nil
    local v2, v3 = a2, a1
    for i, v in ipairs(a1:GetChildren()) do
        if v.Name == v2 then
            if not v:IsA("Folder") then
                if v then
                    v:Destroy()
                end
            elseif not v1 then
                v1 = v
            elseif v then
                v:Destroy()
            end
        end
    end
    if v1 then
        return v1
    end
    local Folder = Instance.new("Folder")
    Folder.Name = v2
    Folder.Parent = v3
    return Folder
end

local function ToModelWithPrimaryPart(a1) -- Line: 318 -- types: a1: userdata
    local v1 = a1:Clone()
    local v2 = v1
    if not v1:IsA("Model") then
        v1.Parent = (Instance.new("Model"))
    end
    local PrimaryPart = v2.PrimaryPart or v2:FindFirstChildWhichIsA("BasePart", true)
    if not PrimaryPart then
        if v2 then
            v2:Destroy()
        end
        return nil
    end
    if not v2.PrimaryPart then
        v2.PrimaryPart = PrimaryPart
    end
    return v2
end

local function GetOrCreateTorsoAttachment(a1, a2, a3) -- Line: 340
    -- upvalues: GetUpperTorso (val)
    local v1 = a1:FindFirstChild(a2, true)
    if v1 and v1:IsA("Attachment") then
        v1.CFrame = a3
        return v1
    end
    local v2 = GetUpperTorso(a1)
    if not v2 then
        return nil
    end
    local Attachment = Instance.new("Attachment")
    Attachment.Name = a2
    Attachment.CFrame = a3
    Attachment.Parent = v2
    return Attachment
end

local function AttachHolsterModel(a1, a2, a3, a4) -- Line: 361
    -- upvalues: SetWeaponProperties (val), CreateWeldForWeapon (val), GetPlayerAttachmentsFolder (val)
    SetWeaponProperties(a2)
    CreateWeldForWeapon(a2, a3)
    local v1 = GetPlayerAttachmentsFolder(a1)
    if not v1 then
        if a2 then
            a2:Destroy()
        end
        return nil
    end
    a2.Name = a4
    a2.Parent = v1
    return a2
end

local function CreateObjectiveKitHolsterModel(a1, a2) -- Line: 378
    -- upvalues: Other (val), dlog (val), u95 (val), GetOrCreateTorsoAttachment (val), ToModelWithPrimaryPart (val)
    -- upvalues: SetWeaponProperties (val), CreateWeldForWeapon (val), GetPlayerAttachmentsFolder (val)
    local DefuseKit = Other:FindFirstChild("DefuseKit")
    if not DefuseKit then
        dlog(a1, "objective kit holster skipped: missing template Assets.Other.DefuseKit")
        return nil
    end
    local BodyBackAttachment = a2:FindFirstChild("BodyBackAttachment", true)
    local v1 = GetOrCreateTorsoAttachment(
        a2,
        "ObjectiveKitAttachment",
        if not BodyBackAttachment then u95 else if not BodyBackAttachment:IsA("Attachment") then u95 else BodyBackAttachment.CFrame * u95
    )
    if not v1 then
        dlog(a1, "objective kit holster skipped: no valid character attachment")
        return nil
    end
    local v2 = ToModelWithPrimaryPart(DefuseKit)
    if not v2 then
        dlog(a1, "objective kit holster skipped: template has no BasePart")
        return nil
    end
    SetWeaponProperties(v2)
    CreateWeldForWeapon(v2, v1)
    local v3 = GetPlayerAttachmentsFolder(a1)
    if not v3 then
        if v2 then
            v2:Destroy()
        end
        return nil
    end
    v2.Name = "ObjectiveKitHolster"
    v2.Parent = v3
    return v2
end

local function DestroyObjectiveKitHolsters(a1, a2) -- Line: 406
    -- upvalues: CharacterResolver (val)
    local WeaponAttachments
    local ObjectiveKitHolsterModel = a2.ObjectiveKitHolsterModel
    if ObjectiveKitHolsterModel then
        ObjectiveKitHolsterModel:Destroy()
    end
    a2.ObjectiveKitHolsterModel = nil
    local v1 = CharacterResolver.getPlayerCharacter(a1)
    if not (if not v1 then nil else v1:FindFirstChild("WeaponAttachments")) then
        return
    end
    for i, v in ipairs(WeaponAttachments:GetChildren()) do
        if v:IsA("Model") and v.Name == "ObjectiveKitHolster" and v then
            v:Destroy()
        end
    end
end

local function UpdateObjectiveKitHolster(a1, a2) -- Line: 425
    -- upvalues: u107 (val), DestroyObjectiveKitHolsters (val), CreateObjectiveKitHolsterModel (val)
    local v1 = u107[a1] or {}
    u107[a1] = v1
    local v2 = false
    if a1:GetAttribute("Team") == "Counter-Terrorists" then
        v2 = true
        if a1:GetAttribute("HasDefuseKit") ~= true then
            v2 = a1:GetAttribute("HasRescueKit") == true
        end
    end
    local ObjectiveKitHolsterModel = v1.ObjectiveKitHolsterModel
    if v2 and ObjectiveKitHolsterModel and ObjectiveKitHolsterModel.Parent then
        return
    end
    DestroyObjectiveKitHolsters(a1, v1)
    if v2 then
        v1.ObjectiveKitHolsterModel = CreateObjectiveKitHolsterModel(a1, a2)
    end
end

local function CreateBombHolsterModel(a1, a2, a3) -- Line: 443
    -- upvalues: GetOrCreateTorsoAttachment (val), u106 (val), dlog (val), Skins (val), SetWeaponProperties (val)
    -- upvalues: CreateWeldForWeapon (val), GetPlayerAttachmentsFolder (val)
    local v1 = GetOrCreateTorsoAttachment(a2, "BombAttachment", u106)
    if not v1 then
        dlog(a1, "bomb holster skipped: no valid character attachment (missing UpperTorso)")
        return nil
    end
    local v2 = Skins.GetCharacterModel("C4", a3.Skin or "", a3.Float, a3.StatTrack, a3.NameTag, false, a3.Stickers)
    if not v2 then
        dlog(a1, "bomb holster skipped: SkinHandler returned nil for C4")
        return nil
    end
    SetWeaponProperties(v2)
    CreateWeldForWeapon(v2, v1)
    local v3 = GetPlayerAttachmentsFolder(a1)
    if not v3 then
        if v2 then
            v2:Destroy()
        end
        return nil
    end
    v2.Name = "BombHolster"
    v2.Parent = v3
    return v2
end

local function DestroyBombHolster(a1) -- Line: 470 -- types: a1: table
    local BombHolsterModel = a1.BombHolsterModel
    if BombHolsterModel then
        BombHolsterModel:Destroy()
    end
    a1.BombHolsterModel = nil
    a1.BombHolsterVisible = nil
end

local function UpdateBombHolster(a1, a2, a3) -- Line: 478
    -- upvalues: u107 (val), HttpService (val), CreateBombHolsterModel (val), SetModelVisible (val)
    local v1 = u107[a1] or {}
    u107[a1] = v1
    local Attribute = a1:GetAttribute("Slot5")
    local v2 = if not Attribute then nil else HttpService:JSONDecode(Attribute)
    if v2 and v2.Weapon == "C4" then
        local BombHolsterModel = v1.BombHolsterModel
        if not BombHolsterModel or not BombHolsterModel.Parent then
            local BombHolsterModel_2 = v1.BombHolsterModel
            if BombHolsterModel_2 then
                BombHolsterModel_2:Destroy()
            end
            v1.BombHolsterModel = nil
            v1.BombHolsterVisible = nil
            v1.BombHolsterModel = (CreateBombHolsterModel(a1, a2, v2))
        end
        local v3 = not (a3 and a3.Name == "C4")
        if BombHolsterModel and v1.BombHolsterVisible ~= v3 then
            SetModelVisible(BombHolsterModel, v3)
            v1.BombHolsterVisible = v3
        end
        return
    end
    local BombHolsterModel_3 = v1.BombHolsterModel
    if BombHolsterModel_3 then
        BombHolsterModel_3:Destroy()
    end
    v1.BombHolsterModel = nil
    v1.BombHolsterVisible = nil
end

local function CacheWeaponCharacterModel(a1, a2, a3, a4, a5) -- Line: 505
    -- upvalues: Skins (val), dlog (val), SetWeaponProperties (val), u73 (val), CreateWeldForWeapon (val)
    -- upvalues: GetPlayerAttachmentsFolder (val), u107 (val), SetModelVisible (val)
    local v1
    local Weapon = a4.Weapon
    local Skin = a4.Skin
    local GetCharacterModel = Skins.GetCharacterModel
    local v2 = Skin
    local Float = a4.Float
    local StatTrack = a4.StatTrack
    local NameTag = a4.NameTag
    local Stickers = a4.Stickers
    if Weapon == "Smoke Grenade" then
        local Attribute = a1:GetAttribute("Team")
        v1 = if Attribute == "Counter-Terrorists" then Attribute else if Attribute ~= "Terrorists" then nil else Attribute
    else
        v1 = nil
    end
    local v3 = GetCharacterModel(Weapon, v2, Float, StatTrack, NameTag, false, Stickers, v1)
    if not v3 then
        dlog(a1, "holster skipped: SkinHandler returned nil for slot=%d weapon=%s skin=%s", a3, Weapon, Skin)
        return
    end
    SetWeaponProperties(v3)
    local v4 = u73[a3]
    if not (if not v4 then nil else a2:FindFirstChild(v4, true)) then
        dlog(a1, "missing character attachment for slot=%d weapon=%s (expected %s)", a3, Weapon, (tostring(v4)))
        error((("Missing character attachment for slot: %*"):format(a3)))
    end
    CreateWeldForWeapon(v3, v2)
    local v5 = GetPlayerAttachmentsFolder(a1)
    if v5 then
        v3.Parent = v5
        v3.Name = Weapon
    end
    local v6 = u107[a1] or {}
    u107[a1] = v6
    v6[a3] = {
        StatTrack = a4.StatTrack,
        Stickers = a4.Stickers,
        NameTag = a4.NameTag,
        Model = v3,
        Float = a4.Float,
        Charm = a4.Charm,
        Weapon = Weapon,
        Skin = Skin,
        Visible = a5,
    }
    dlog(a1, "cached holster slot=%d weapon=%s skin=%s visible=%s", a3, Weapon, Skin, "unknown")
    SetModelVisible(v3, a5)
end

local function DestroyEquippedModels(a1) -- Line: 575 -- types: a1: table
    local EquippedModels = a1.EquippedModels
    if EquippedModels then
        local Model
        for k, v in pairs(EquippedModels) do
            for i, j in v.Motors do
                j:Destroy()
            end
            Model = v.Model
            if Model then
                Model:Destroy()
            end
        end
    end
    a1.EquippedModels = nil
    a1.ActiveEquipped = nil
end

local function ClearPlayerCache(a1) -- Line: 589
    -- upvalues: u108 (val), u107 (val), DestroyEquippedModels (val), dlog (val)
    local v1
    local v2 = u108[a1]
    if v2 then
        v2:Disconnect()
        u108[a1] = nil
    end
    local v3 = u107[a1]
    if not v3 then
        v1 = a1
    else
        local Model
        local Character = v3.Character
        DestroyEquippedModels(v3)
        local ObjectiveKitHolsterModel = v3.ObjectiveKitHolsterModel
        if ObjectiveKitHolsterModel then
            ObjectiveKitHolsterModel:Destroy()
        end
        v3.ObjectiveKitHolsterModel = nil
        local BombHolsterModel = v3.BombHolsterModel
        if BombHolsterModel then
            BombHolsterModel:Destroy()
        end
        v3.BombHolsterModel = nil
        v3.BombHolsterVisible = nil
        v1 = a1
        for k, v in pairs(v3) do
            if typeof(k) == "number" and typeof(v) == "table" then
                Model = v.Model
                if Model then
                    Model:Destroy()
                end
                v3[k] = nil
            end
        end
        if Character then
            local v4
            for i, j in {"WeaponModel", "WeaponAttachments"} do
                v4 = Character:FindFirstChild(j)
                if v4 and v4:IsA("Folder") then
                    v4:ClearAllChildren()
                end
            end
        end
    end
    dlog(v1, "cleared player cache (destroyed holsters)")
    u107[v1] = nil
end

local function InitializePlayerCache(a1, a2) -- Line: 627
    -- upvalues: u107 (val), ClearPlayerCache (val), u108 (val), DestroyEquippedModels (val)
    local v1 = u107[a1] or {}
    u107[a1] = v1
    if v1.Character == a2 then
        return
    end
    if v1.Character then
        ClearPlayerCache(a1)
        v1 = u107[a1] or {}
        u107[a1] = v1
    end
    v1.Character = a2
    local v2 = u108[a1]
    if v2 then
        v2:Disconnect()
    end
    u108[a1] = (a2.AncestryChanged:Connect(function(a1_2, a2) -- Line: 644 -- upvalues: u107 (upval), a1 (val), DestroyEquippedModels (upval)
        local v1 = u107[a1]
        if not a2 and v1 then
            DestroyEquippedModels(v1)
            v1.ObjectiveKitHolsterModel = nil
            v1.BombHolsterModel = nil
            for k, v in pairs(v1) do
                if typeof(k) == "number" and typeof(v) == "table" then
                    v1[k] = nil
                end
            end
            v1.Character = nil
            return
        end
    end))
end

local function UpdateCachedWeapon(a1, a2, a3, a4, a5) -- Line: 664
    -- upvalues: GetWeaponProperties (val), u107 (val), SetModelVisible (val), dlog (val)
    -- upvalues: CacheWeaponCharacterModel (val)
    local v1 = GetWeaponProperties(a4.Weapon)
    if v1 and v1.ShootingOptions == "Dual" then
        return
    end
    local v2 = u107[a1] or {}
    u107[a1] = v2
    local v3 = v2[a3]
    local v4 = false
    if a4.Weapon == a5.Name then
        v4 = a4.Skin == a5.Skin
    end
    local v5 = not v4
    if v3 then
        local v6 = false
        if v3.Skin == a4.Skin then
            v6 = v3.Weapon == a4.Weapon
        end
        if v6 and v3.Model then
            if v3.Visible ~= v5 then
                SetModelVisible(v3.Model, v5)
                v3.Visible = v5
            end
            return
        end
        local Model = v3.Model
        if Model then
            Model:Destroy()
        end
    end
    v2[a3] = nil
    dlog(a1, "holster slot=%d weapon=%s skin=%s equippedInHand=%s", a3, a4.Weapon, a4.Skin, (tostring(v4)))
    CacheWeaponCharacterModel(a1, a2, a3, a4, v5)
end

local function CreateCharacterWeapons(a1, a2, a3, a4) -- Line: 709
    -- upvalues: InitializePlayerCache (val), u107 (val), UpdateCachedWeapon (val), UpdateObjectiveKitHolster (val)
    -- upvalues: UpdateBombHolster (val)
    local Model, v1
    InitializePlayerCache(a1, a2)
    local v2 = u107[a1] or {}
    u107[a1] = v2
    local v3, v4, v5, v6 = a4, a1, a2, a3
    for i = 1, 3 do
        v1 = v2[i]
        if not v3[i] and v1 then
            Model = v1.Model
            if Model then
                Model:Destroy()
            end
            v2[i] = nil
        end
    end
    for k, v in pairs(v3) do
        if v then
            UpdateCachedWeapon(v4, v5, k, v, v6)
        end
    end
    UpdateObjectiveKitHolster(v4, v5)
    UpdateBombHolster(v4, v5, v6)
end

local function SetupSuppressorState(a1, a2, a3) -- Line: 739 -- types: a1: userdata, a3: boolean
    local Silencer = a1:FindFirstChild("Silencer", true)
    if Silencer and a2.HasSuppressor then
        Silencer.Transparency = if not a3 then 1 else 0
    end
end

local function ResolveWeaponBindPart(a1, a2) -- Line: 755 -- types: a1: userdata, a2: string?
    if a2 then
        local v1 = a1:FindFirstChild(a2, true)
        if v1 and v1:IsA("BasePart") then
            return v1
        end
    end
    if a1.PrimaryPart then
        return a1.PrimaryPart
    end
    local Insert = a1:FindFirstChild("Insert", true)
    if Insert and Insert:IsA("BasePart") then
        return Insert
    end
    return a1:FindFirstChildWhichIsA("BasePart", true)
end

local function CreateMotor6DAttachment(a1, a2, a3) -- Line: 777
    -- upvalues: ResolveWeaponBindPart (val), ThirdPersonWeaponStash (val)
    local v1 = ResolveWeaponBindPart(a2, a3)
    if not v1 then
        warn((("CreateMotor6DAttachment: no bindable part on \"%*\", skipping attachment"):format(a2.Name)))
        return nil
    end
    local identity = CFrame.identity
    local identity_2 = CFrame.identity
    local Properties = a2:FindFirstChild("Properties")
    if Properties then
        local v2, v3
        for i, v in ipairs(a3 and {"LEFT", "RIGHT"} or {""}) do
            v2 = Properties:FindFirstChild("C0" .. v)
            if v2 then
                identity = v2.Value
            end
            v3 = Properties:FindFirstChild("C1" .. v)
            if v3 then
                identity_2 = v3.Value
            end
        end
    end
    ThirdPersonWeaponStash.PoseForJoint(v1, a1, identity, identity_2)
    local Motor6D = Instance.new("Motor6D")
    Motor6D.Name = "WeaponAttachment" .. (a3 or "")
    Motor6D.C0 = identity
    Motor6D.C1 = identity_2
    Motor6D.Part0 = a1
    Motor6D.Part1 = v1
    Motor6D.Parent = a1
    return Motor6D
end

local function CreateDualMotor6DAttachments(a1, a2) -- Line: 816
    -- upvalues: CreateMotor6DAttachment (val)
    local RightHand = a1:FindFirstChild("RightHand")
    local LeftHand = a1:FindFirstChild("LeftHand")
    if RightHand and LeftHand then
        local v1 = {}
        local v2 = CreateMotor6DAttachment(RightHand, a2, "HandleR")
        if v2 then
            table.insert(v1, v2)
        end
        local v3 = CreateMotor6DAttachment(LeftHand, a2, "HandleL")
        if v3 then
            table.insert(v1, v3)
        end
        return v1
    end
    warn("CreateDualMotor6DAttachments: Could not find RightHand or LeftHand for dual weapon")
    return {}
end

local function CreateEquippedMotors(a1, a2, a3, a4) -- Line: 835
    -- upvalues: CreateDualMotor6DAttachments (val), CreateMotor6DAttachment (val)
    if a4 then
        return (CreateDualMotor6DAttachments(a1, a3))
    end
    local v1 = CreateMotor6DAttachment(a2, a3, nil)
    if v1 then
        return {v1}
    end
    return {}
end

local function GetEquippedModelKey(a1, a2) -- Line: 851 -- upvalues: HttpService (val) -- types: a1: userdata, a2: table
    local v1
    local Stickers = a2.Stickers
    local concat = table.concat
    local v2 = {}
    local Name = a2.Name
    local Skin = a2.Skin
    local v3 = tostring(a2.Float)
    local v4 = tostring(a2.StatTrack)
    local v5 = tostring(a2.NameTag)
    local v6 = if typeof(Stickers) ~= "table" then "" else HttpService:JSONEncode(Stickers)
    if a2.Name == "Smoke Grenade" then
        local Attribute = a1:GetAttribute("Team")
        v1 = if Attribute == "Counter-Terrorists" then Attribute else if Attribute ~= "Terrorists" then nil else Attribute
    else
        v1 = nil
    end
    v2[1] = Name
    v2[2] = Skin
    v2[3] = v3
    v2[4] = v4
    v2[5] = v5
    v2[6] = v6
    v2[7] = (tostring(v1))
    return concat(v2, "|")
end

local function ParkActiveEquipped(a1) -- Line: 865 -- upvalues: ThirdPersonWeaponStash (val) -- types: a1: table
    local ActiveEquipped = a1.ActiveEquipped
    if not ActiveEquipped then
        return
    end
    a1.ActiveEquipped = nil
    ThirdPersonWeaponStash.Park(ActiveEquipped.Model, ActiveEquipped.Motors)
end

local function EvictEquippedModels(a1) -- Line: 874 -- types: a1: table
    local v1 = 0
    local v2 = nil
    local LastUsed = (1 / 0)
    for k, v in pairs(a1) do
        v1 = v1 + 1
        if v.LastUsed < LastUsed then
            v2 = k
            LastUsed = v.LastUsed
        end
    end
    if v1 > 8 and v2 then
        local Model = a1[v2].Model
        if Model then
            Model:Destroy()
        end
        a1[v2] = nil
    end
end

local function CreateEquippedWeapon(a1, a2, a3) -- Line: 890
    -- upvalues: Attachments (val), GetWeaponProperties (val), u107 (val), ThirdPersonWeaponStash (val)
    -- upvalues: GetOrCreateCharacterFolder (val), GetEquippedModelKey (val), CreateEquippedMotors (val), Skins (val)
    -- upvalues: dlog (val), SetWeaponProperties (val), GetMuzzleFlash (val), Character (val), EvictEquippedModels (val)
    local v1
    if not a2.Parent then
        return nil
    end
    local Name = a3.Name
    local DEFAULT_JOINT_PART = Attachments.WEAPON_JOINT_PARTS[Name] or Attachments.DEFAULT_JOINT_PART
    local v2 = a2:WaitForChild(DEFAULT_JOINT_PART, 10)
    assert(v2, (("Failed to get joint part: %* for weapon: %*"):format(DEFAULT_JOINT_PART, Name)))
    local v3 = GetWeaponProperties(a3.Name)
    if not v3 then
        return nil
    end
    local v4 = u107[a1] or {}
    u107[a1] = v4
    local ActiveEquipped = v4.ActiveEquipped
    if ActiveEquipped then
        v4.ActiveEquipped = nil
        ThirdPersonWeaponStash.Park(ActiveEquipped.Model, ActiveEquipped.Motors)
    end
    local v5 = GetOrCreateCharacterFolder(a2, "WeaponModel")
    v5:ClearAllChildren()
    local WeaponAttachment = v2:FindFirstChild("WeaponAttachment")
    if WeaponAttachment then
        WeaponAttachment:Destroy()
    end
    local WeaponAttachmentHandleR = v2:FindFirstChild("WeaponAttachmentHandleR")
    if WeaponAttachmentHandleR then
        WeaponAttachmentHandleR:Destroy()
    end
    local LeftHand = a2:FindFirstChild("LeftHand")
    if LeftHand then
        local WeaponAttachmentHandleL = LeftHand:FindFirstChild("WeaponAttachmentHandleL")
        if WeaponAttachmentHandleL then
            WeaponAttachmentHandleL:Destroy()
        end
    end
    local EquippedModels = v4.EquippedModels or {}
    v4.EquippedModels = EquippedModels
    local v6 = GetEquippedModelKey(a1, a3)
    local v7 = v3.ShootingOptions == "Dual"
    local v8 = EquippedModels[v6]
    if v8 then
        EquippedModels[v6] = nil
        if ThirdPersonWeaponStash.TryUnpark(v8.Model, v5) then
            local Model = v8.Model
            local IsSuppressed = a3.IsSuppressed
            local Silencer = Model:FindFirstChild("Silencer", true)
            if Silencer and v3.HasSuppressor then
                Silencer.Transparency = if not IsSuppressed then 1 else 0
            end
            v8.Motors = CreateEquippedMotors(a2, v2, v8.Model, v7)
            if #v8.Motors == 0 then
                local Model_2 = v8.Model
                if Model_2 then
                    Model_2:Destroy()
                end
                return nil
            end
            ThirdPersonWeaponStash.Release(v8.Motors)
            v8.LastUsed = os.clock()
            EquippedModels[v6] = v8
            v4.ActiveEquipped = v8
            return v2
        end
    end
    local GetCharacterModel = Skins.GetCharacterModel
    local Name_2 = a3.Name
    local Skin = a3.Skin
    local Float = a3.Float
    local StatTrack = a3.StatTrack
    local NameTag = a3.NameTag
    local Stickers = a3.Stickers
    if a3.Name == "Smoke Grenade" then
        local Attribute = a1:GetAttribute("Team")
        v1 = if Attribute == "Counter-Terrorists" then Attribute else if Attribute ~= "Terrorists" then nil else Attribute
    else
        v1 = nil
    end
    local v9 = GetCharacterModel(Name_2, Skin, Float, StatTrack, NameTag, false, Stickers, v1)
    if not v9 then
        dlog(a1, "equipped weapon skipped: SkinHandler returned nil for weapon=%s skin=%s", a3.Name, a3.Skin)
        return nil
    end
    SetWeaponProperties(v9)
    local IsSuppressed_2 = a3.IsSuppressed
    local Silencer_2 = v9:FindFirstChild("Silencer", true)
    if Silencer_2 and v3.HasSuppressor then
        Silencer_2.Transparency = if not IsSuppressed_2 then 1 else 0
    end
    local MuzzleType = v3.MuzzleType and v9:FindFirstChild("Interactables")
    if MuzzleType then
        if not v7 then
            local MuzzlePart = MuzzleType:FindFirstChild("MuzzlePart")
            if MuzzlePart and v3.MuzzleType then
                GetMuzzleFlash(MuzzlePart, Character, v3.MuzzleType, "WeldConstraint")
                if v3.HasSuppressor then
                    GetMuzzleFlash(MuzzlePart, Character, "Suppressor", "WeldConstraint")
                end
            end
        else
            local MuzzlePartL = MuzzleType:FindFirstChild("MuzzlePartL")
            if MuzzlePartL and v3.MuzzleType then
                GetMuzzleFlash(MuzzlePartL, Character, v3.MuzzleType, "WeldConstraint")
                if v3.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartL, Character, "Suppressor", "WeldConstraint")
                end
            end
            local MuzzlePartR = MuzzleType:FindFirstChild("MuzzlePartR")
            if MuzzlePartR and v3.MuzzleType then
                GetMuzzleFlash(MuzzlePartR, Character, v3.MuzzleType, "WeldConstraint")
                if v3.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartR, Character, "Suppressor", "WeldConstraint")
                end
            end
        end
    end
    local v10 = CreateEquippedMotors(a2, v2, v9, v7)
    if #v10 == 0 then
        dlog(a1, "equipped weapon skipped: nothing to joint on weapon=%s", a3.Name)
        if v9 then
            v9:Destroy()
        end
        return nil
    end
    v9.Name = "Equipped"
    v9.Parent = v5
    local v11 = {Model = v9, Motors = v10, LastUsed = os.clock()}
    EquippedModels[v6] = v11
    v4.ActiveEquipped = v11
    EvictEquippedModels(EquippedModels)
    return v2
end

local v1 = {
    __call = function(a1, a2, a3, a4) -- Line: 1001
        -- upvalues: CharacterResolver (val), InitializePlayerCache (val), CreateEquippedWeapon (val)
        -- upvalues: CreateCharacterWeapons (val), ClearPlayerCache (val)
        local v1 = CharacterResolver.getPlayerCharacter(a2)
        if v1 then
            InitializePlayerCache(a2, v1)
            local v2 = CreateEquippedWeapon(a2, v1, a3)
            CreateCharacterWeapons(a2, v1, a3, a4)
            if v2 then
                return v2, ClearPlayerCache
            end
        end
        return nil, nil
    end,
}
local v2 = setmetatable({}, v1)
v2.ClearPlayerCache = ClearPlayerCache

function v2.RefreshObjectiveKitHolster(a1) -- Line: 1024
    -- upvalues: CharacterResolver (val), InitializePlayerCache (val), UpdateObjectiveKitHolster (val)
    local v1 = CharacterResolver.getPlayerCharacter(a1)
    if v1 then
        InitializePlayerCache(a1, v1)
        UpdateObjectiveKitHolster(a1, v1)
    end
end

function v2.RefreshBombHolster(a1) -- Line: 1032
    -- upvalues: CharacterResolver (val), InitializePlayerCache (val), HttpService (val), UpdateBombHolster (val)
    local v1 = CharacterResolver.getPlayerCharacter(a1)
    if not v1 then
        return
    end
    InitializePlayerCache(a1, v1)
    local Attribute = a1:GetAttribute("CurrentEquipped")
    UpdateBombHolster(a1, v1, if not Attribute then nil else HttpService:JSONDecode(Attribute))
end

function v2.RefreshSuppressorState(a1, a2) -- Line: 1046
    -- upvalues: CharacterResolver (val), GetWeaponProperties (val)
    local v1 = CharacterResolver.getPlayerCharacter(a1)
    local WeaponModel = v1 and v1:FindFirstChild("WeaponModel")
    local Equipped = WeaponModel and WeaponModel:FindFirstChild("Equipped")
    if Equipped and Equipped:IsA("Model") then
        local v2 = GetWeaponProperties(a2.Name)
        if not v2 then
            return false
        end
        local IsSuppressed = a2.IsSuppressed
        local Silencer = Equipped:FindFirstChild("Silencer", true)
        if Silencer and v2.HasSuppressor then
            Silencer.Transparency = if not IsSuppressed then 1 else 0
        end
        return true
    end
    return false
end

Players.PlayerRemoving:Connect(ClearPlayerCache)
return v2