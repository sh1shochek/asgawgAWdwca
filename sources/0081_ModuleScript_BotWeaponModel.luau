-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GetWeaponProperties = require(script.Parent.GetWeaponProperties);
local Attachments = require(ReplicatedStorage.Database.Custom.GameStats.Character.Attachments);
local GetMuzzleFlash = require(script.Parent.VFXLibary.CreateMuzzleFlash.GetMuzzleFlash);
local ThirdPersonWeaponStash = require(script.Parent.ThirdPersonWeaponStash);
local u1 = {};
local table_freeze_ret = table.freeze({
    MuzzlePart = true,
    MuzzlePartL = true,
    MuzzlePartR = true,
    RootPart = true,
    Hitbox = true,
    Insert = true,
    move = true
});
local u2 = {};

function u1.destroy(p3: table?) -- Line: 34
    if p3 == nil then
        return;
    end;

    for _, v in p3.Motors do
        v:Destroy();
    end;

    p3.Model:Destroy();
end;

function u1.stow(p4: userdata, p5: table?) -- Line: 45
    -- upvalues: u2 (copy), u1 (copy), ThirdPersonWeaponStash (copy)
    if p5 == nil then
        return;
    end;

    local v6 = u2[p4];

    if v6 == nil then
        v6 = {};
        u2[p4] = v6;
    end;

    u1.destroy(v6[p5.Name]);
    v6[p5.Name] = p5;
    ThirdPersonWeaponStash.Park(p5.Model, p5.Motors);
end;

function u1.clear(p7: userdata) -- Line: 60
    -- upvalues: u2 (copy), u1 (copy)
    local v8 = u2[p7];

    if v8 == nil then
        return;
    end;

    u2[p7] = nil;

    for _, v in v8 do
        u1.destroy(v);
    end;
end;

local function joinMotor(p9: table, p10: userdata, p11: userdata, p12: string, p13: string) -- Line: 71
    -- upvalues: ThirdPersonWeaponStash (copy)
    local CFrame_identity = CFrame.identity;
    local CFrame_identity2 = CFrame.identity;
    local Properties = p9.Model:FindFirstChild("Properties");

    if Properties then
        local v14 = Properties:FindFirstChild("C0" .. p12);
        local v15 = Properties:FindFirstChild("C1" .. p12);

        if v14 and v14:IsA("CFrameValue") then
            CFrame_identity = v14.Value;
        end;

        if v15 and v15:IsA("CFrameValue") then
            CFrame_identity2 = v15.Value;
        end;
    end;

    ThirdPersonWeaponStash.PoseForJoint(p11, p10, CFrame_identity, CFrame_identity2);
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = p13;
    Motor6D.C0 = CFrame_identity;
    Motor6D.C1 = CFrame_identity2;
    Motor6D.Part0 = p10;
    Motor6D.Part1 = p11;
    Motor6D.Parent = p10;
    p9.Motors[#p9.Motors + 1] = Motor6D;
end;

local function joinHands(p16: userdata, p17: table, p18: userdata, p19: boolean) -- Line: 93
    -- upvalues: joinMotor (copy)
    local Model = p17.Model;

    if not p19 then
        joinMotor(p17, p18, Model.PrimaryPart, "", "WeaponAttachment");

        return true;
    end;

    local HandleR = Model:FindFirstChild("HandleR", true);
    local HandleL = Model:FindFirstChild("HandleL", true);

    if HandleR == nil or (HandleL == nil or not (HandleR:IsA("BasePart") and HandleL:IsA("BasePart"))) then
        return false;
    end;

    joinMotor(p17, p16:FindFirstChild("RightHand"), HandleR, "RIGHT", "WeaponAttachmentHandleR");
    joinMotor(p17, p16:FindFirstChild("LeftHand"), HandleL, "LEFT", "WeaponAttachmentHandleL");

    return true;
end;

function u1.attach(p20: userdata, p21: string, p22: number) -- Line: 108
    -- upvalues: GetWeaponProperties (copy), ReplicatedStorage (copy), Attachments (copy), u2 (copy), ThirdPersonWeaponStash (copy), joinHands (copy), u1 (copy), HttpService (copy), table_freeze_ret (copy), GetMuzzleFlash (copy)
    local v23 = GetWeaponProperties(p21);
    local Assets = ReplicatedStorage:FindFirstChild("Assets");
    local v24;

    if Assets then
        v24 = Assets:FindFirstChild("Weapons");
    else
        v24 = nil;
    end;

    local v25;

    if v24 then
        v25 = v24:FindFirstChild(p21);
    else
        v25 = nil;
    end;

    local v26;

    if v25 then
        v26 = v25:FindFirstChild("Character");
    else
        v26 = nil;
    end;

    local WeaponModel = p20:FindFirstChild("WeaponModel");

    if v23 == nil or (v26 == nil or (not v26:IsA("Model") or WeaponModel == nil)) then
        return nil;
    end;

    local v27 = v23.ShootingOptions == "Dual";
    local v28 = p20:FindFirstChild(Attachments.WEAPON_JOINT_PARTS[p21] or Attachments.DEFAULT_JOINT_PART);

    if v28 == nil or not v28:IsA("BasePart") then
        return nil;
    end;

    if v27 and (p20:FindFirstChild("LeftHand") == nil or p20:FindFirstChild("RightHand") == nil) then
        return nil;
    end;

    local v29 = u2[p20];
    local v30;

    if v29 then
        v30 = v29[p21];
    else
        v30 = nil;
    end;

    if v30 then
        v29[p21] = nil;

        if ThirdPersonWeaponStash.TryUnpark(v30.Model, WeaponModel) then
            if not joinHands(p20, v30, v28, v27) then
                u1.destroy(v30);

                return nil;
            end;

            ThirdPersonWeaponStash.Release(v30.Motors);
            v30.Revision = p22;
            v30.Model:SetAttribute("WeaponRevision", p22);

            return v30;
        end;
    end;

    local Attribute = p20:GetAttribute("BotLoadout");
    local v31;

    if type(Attribute) == "string" then
        v31 = HttpService:JSONDecode(Attribute);
    else
        v31 = nil;
    end;

    if v31 then
        v31 = v31.Weapons[p21];
    end;

    local v32;

    if v31 then
        v32 = require(ReplicatedStorage.Database.Components.Libraries.Skins).GetCharacterModel(p21, v31.Skin, v31.Float, false, false, false, {}, p20:GetAttribute("Team"));
    else
        v32 = v26:Clone();
    end;

    if v32 == nil then
        return nil;
    end;

    if v32.PrimaryPart == nil then
        v32:Destroy();

        return nil;
    end;

    local v33 = {
        Model = v32,
        Name = p21,
        Revision = p22,
        Motors = {},
        Muzzles = {},
        MuzzleType = v23.MuzzleType
    };

    for _, descendant in v32:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "WeaponModel";
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
            descendant.Anchored = false;
            descendant.Massless = true;
            descendant.CastShadow = false;

            if table_freeze_ret[descendant.Name] or descendant.Name == "Silencer" then
                descendant.Transparency = 1;
            end;
        elseif descendant:IsA("BaseScript") then
            descendant:Destroy();
        end;
    end;

    if not joinHands(p20, v33, v28, v27) then
        v32:Destroy();

        return nil;
    end;

    local v34;

    if Assets then
        v34 = Assets:FindFirstChild("MuzzleFlashes");
    else
        v34 = nil;
    end;

    local v35;

    if v34 then
        v35 = v34:FindFirstChild("Character");
    else
        v35 = nil;
    end;

    local Interactables = v32:FindFirstChild("Interactables");

    if Interactables then
        for _, v in v27 and { "MuzzlePartR", "MuzzlePartL" } or { "MuzzlePart" } do
            local v36 = Interactables:FindFirstChild(v);

            if v36 and v36:IsA("BasePart") then
                v33.Muzzles[#v33.Muzzles + 1] = v36;

                if v35 and (v23.MuzzleType and v35:FindFirstChild(v23.MuzzleType)) then
                    GetMuzzleFlash(v36, v35, v23.MuzzleType, "WeldConstraint");
                end;
            end;
        end;
    end;

    v32.Name = "Equipped";
    v32:SetAttribute("WeaponName", p21);
    v32:SetAttribute("WeaponRevision", p22);
    v32.Parent = WeaponModel;

    return v33;
end;

return table.freeze(u1);