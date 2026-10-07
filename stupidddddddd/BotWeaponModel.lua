-- ReplicatedStorage.Components.Common.BotWeaponModel
-- Script path: ReplicatedStorage.Components.Common.BotWeaponModel
-- Decompile time: 7.25 ms

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetWeaponProperties = require(script.Parent.GetWeaponProperties)
local Attachments = require(ReplicatedStorage.Database.Custom.GameStats.Character.Attachments)
local GetMuzzleFlash = require(script.Parent.VFXLibary.CreateMuzzleFlash.GetMuzzleFlash)
local ThirdPersonWeaponStash = require(script.Parent.ThirdPersonWeaponStash)
local u34 = {}
local u37 = table.freeze({
    MuzzlePart = true,
    MuzzlePartL = true,
    MuzzlePartR = true,
    RootPart = true,
    Hitbox = true,
    Insert = true,
    move = true,
})
local u38 = {}

function u34.destroy(a1) -- Line: 34 -- types: a1: table?
    if a1 == nil then
        return
    end
    for i, j in a1.Motors do
        j:Destroy()
    end
    a1.Model:Destroy()
end

function u34.stow(a1, a2) -- Line: 45
    -- upvalues: u38 (val), u34 (val), ThirdPersonWeaponStash (val)
    if a2 == nil then
        return
    end
    local v1 = u38[a1]
    if v1 == nil then
        u38[a1] = {}
    end
    u34.destroy(v1[a2.Name])
    v1[a2.Name] = a2
    ThirdPersonWeaponStash.Park(a2.Model, a2.Motors)
end

function u34.clear(a1) -- Line: 60 -- upvalues: u38 (val), u34 (val) -- types: a1: userdata
    local v1 = u38[a1]
    if v1 == nil then
        return
    end
    u38[a1] = nil
    for i, j in v1 do
        u34.destroy(j)
    end
end

local function joinMotor(a1, a2, a3, a4, a5) -- Line: 71
    -- upvalues: ThirdPersonWeaponStash (val)
    local identity = CFrame.identity
    local identity_2 = CFrame.identity
    local Properties = a1.Model:FindFirstChild("Properties")
    if Properties then
        local v1 = Properties:FindFirstChild("C0" .. a4)
        local v2 = Properties:FindFirstChild("C1" .. a4)
        if v1 and v1:IsA("CFrameValue") then
            identity = v1.Value
        end
        if v2 and v2:IsA("CFrameValue") then
            identity_2 = v2.Value
        end
    end
    ThirdPersonWeaponStash.PoseForJoint(a3, a2, identity, identity_2)
    local Motor6D = Instance.new("Motor6D")
    Motor6D.Name = a5
    Motor6D.C0 = identity
    Motor6D.C1 = identity_2
    Motor6D.Part0 = a2
    Motor6D.Part1 = a3
    Motor6D.Parent = a2
    a1.Motors[#a1.Motors + 1] = Motor6D
end

local function joinHands(a1, a2, a3, a4) -- Line: 93
    -- upvalues: joinMotor (val)
    local Model = a2.Model
    if not a4 then
        joinMotor(a2, a3, Model.PrimaryPart, "", "WeaponAttachment")
        return true
    end
    local v1 = Model:FindFirstChild("HandleR", true)
    local HandleL = Model:FindFirstChild("HandleL", true)
    if v1 ~= nil and HandleL ~= nil and v1:IsA("BasePart") and HandleL:IsA("BasePart") then
        joinMotor(a2, a1:FindFirstChild("RightHand"), v1, "RIGHT", "WeaponAttachmentHandleR")
        joinMotor(a2, a1:FindFirstChild("LeftHand"), HandleL, "LEFT", "WeaponAttachmentHandleL")
        return true
    end
    return false
end

function u34.attach(a1, a2, a3) -- Line: 108
    -- upvalues: GetWeaponProperties (val), ReplicatedStorage (val), Attachments (val), u38 (val)
    -- upvalues: ThirdPersonWeaponStash (val), joinHands (val), u34 (val), HttpService (val), u37 (val)
    -- upvalues: GetMuzzleFlash (val)
    local v1 = GetWeaponProperties(a2)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Weapons = if not Assets then nil else Assets:FindFirstChild("Weapons")
    local v2 = if not Weapons then nil else Weapons:FindFirstChild(a2)
    local Character = if not v2 then nil else v2:FindFirstChild("Character")
    local WeaponModel = a1:FindFirstChild("WeaponModel")
    if v1 ~= nil and Character ~= nil and Character:IsA("Model") and WeaponModel ~= nil then
        local v3 = v1.ShootingOptions == "Dual"
        local v4 = a1:FindFirstChild(Attachments.WEAPON_JOINT_PARTS[a2] or Attachments.DEFAULT_JOINT_PART)
        if v4 ~= nil and v4:IsA("BasePart") then
            local Attribute, Character_2, Interactables, MuzzleFlashes, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
            if not v3 then
                v7 = u38[a1]
                v8 = if not v7 then nil else v7[a2]
                if v8 then
                    v7[a2] = nil
                    if ThirdPersonWeaponStash.TryUnpark(v8.Model, WeaponModel) then
                        if not joinHands(a1, v8, v4, v3) then
                            u34.destroy(v8)
                            return nil
                        end
                        ThirdPersonWeaponStash.Release(v8.Motors)
                        v8.Revision = a3
                        v8.Model:SetAttribute("WeaponRevision", a3)
                        return v8
                    end
                end
                Attribute = a1:GetAttribute("BotLoadout")
                v9 = if type(Attribute) ~= "string" then nil else HttpService:JSONDecode(Attribute)
                v10 = v9 and v9.Weapons[a2]
                v11 = if not v10 then Character:Clone() else require(ReplicatedStorage.Database.Components.Libraries.Skins).GetCharacterModel(
                    a2,
                    v10.Skin,
                    v10.Float,
                    false,
                    false,
                    false,
                    {},
                    a1:GetAttribute("Team")
                )
                if v11 == nil then
                    return nil
                end
                if v11.PrimaryPart == nil then
                    v11:Destroy()
                    return nil
                end
                v12 = {Model = v11, Name = a2, Revision = a3}
                v12.Motors = {}
                v12.Muzzles = {}
                v12.MuzzleType = v1.MuzzleType
                v5, v6, v13 = a1, a2, a3
                for m, i5 in v11:GetDescendants() do
                    if i5:IsA("BasePart") then
                        i5.CollisionGroup = "WeaponModel"
                        i5.CanCollide = false
                        i5.CanTouch = false
                        i5.CanQuery = false
                        i5.Anchored = false
                        i5.Massless = true
                        i5.CastShadow = false
                        if u37[i5.Name] or i5.Name == "Silencer" then
                            i5.Transparency = 1
                        end
                    elseif i5:IsA("BaseScript") then
                        i5:Destroy()
                    end
                end
                if not joinHands(v5, v12, v4, v3) then
                    v11:Destroy()
                    return nil
                end
                MuzzleFlashes = if not Assets then nil else Assets:FindFirstChild("MuzzleFlashes")
                Character_2 = if not MuzzleFlashes then nil else MuzzleFlashes:FindFirstChild("Character")
                Interactables = v11:FindFirstChild("Interactables")
                if Interactables then
                    for i6, i7 in if not v3 then {"MuzzlePart"} else {"MuzzlePartR", "MuzzlePartL"} do
                        v14 = Interactables:FindFirstChild(i7)
                        if v14 and v14:IsA("BasePart") then
                            v12.Muzzles[#v12.Muzzles + 1] = v14
                            if Character_2 and v1.MuzzleType and Character_2:FindFirstChild(v1.MuzzleType) then
                                GetMuzzleFlash(v14, Character_2, v1.MuzzleType, "WeldConstraint")
                            end
                        end
                    end
                end
                v11.Name = "Equipped"
                v11:SetAttribute("WeaponName", v6)
                v11:SetAttribute("WeaponRevision", v13)
                v11.Parent = WeaponModel
                return v12
            end
            if a1:FindFirstChild("LeftHand") ~= nil and a1:FindFirstChild("RightHand") ~= nil then
                v7 = u38[a1]
                v8 = if not v7 then nil else v7[a2]
                if v8 then
                    v7[a2] = nil
                    if ThirdPersonWeaponStash.TryUnpark(v8.Model, WeaponModel) then
                        if not joinHands(a1, v8, v4, v3) then
                            u34.destroy(v8)
                            return nil
                        end
                        ThirdPersonWeaponStash.Release(v8.Motors)
                        v8.Revision = a3
                        v8.Model:SetAttribute("WeaponRevision", a3)
                        return v8
                    end
                end
                Attribute = a1:GetAttribute("BotLoadout")
                v9 = if type(Attribute) ~= "string" then nil else HttpService:JSONDecode(Attribute)
                v10 = v9 and v9.Weapons[a2]
                v11 = if not v10 then Character:Clone() else require(ReplicatedStorage.Database.Components.Libraries.Skins).GetCharacterModel(
                    a2,
                    v10.Skin,
                    v10.Float,
                    false,
                    false,
                    false,
                    {},
                    a1:GetAttribute("Team")
                )
                if v11 == nil then
                    return nil
                end
                if v11.PrimaryPart == nil then
                    v11:Destroy()
                    return nil
                end
                v12 = {Model = v11, Name = a2, Revision = a3}
                v12.Motors = {}
                v12.Muzzles = {}
                v12.MuzzleType = v1.MuzzleType
                v5, v6, v13 = a1, a2, a3
                for i, j in v11:GetDescendants() do
                    if j:IsA("BasePart") then
                        j.CollisionGroup = "WeaponModel"
                        j.CanCollide = false
                        j.CanTouch = false
                        j.CanQuery = false
                        j.Anchored = false
                        j.Massless = true
                        j.CastShadow = false
                        if u37[j.Name] or j.Name == "Silencer" then
                            j.Transparency = 1
                        end
                    elseif j:IsA("BaseScript") then
                        j:Destroy()
                    end
                end
                if not joinHands(v5, v12, v4, v3) then
                    v11:Destroy()
                    return nil
                end
                MuzzleFlashes = if not Assets then nil else Assets:FindFirstChild("MuzzleFlashes")
                Character_2 = if not MuzzleFlashes then nil else MuzzleFlashes:FindFirstChild("Character")
                Interactables = v11:FindFirstChild("Interactables")
                if Interactables then
                    for k, n in if not v3 then {"MuzzlePart"} else {"MuzzlePartR", "MuzzlePartL"} do
                        v14 = Interactables:FindFirstChild(n)
                        if v14 and v14:IsA("BasePart") then
                            v12.Muzzles[#v12.Muzzles + 1] = v14
                            if Character_2 and v1.MuzzleType and Character_2:FindFirstChild(v1.MuzzleType) then
                                GetMuzzleFlash(v14, Character_2, v1.MuzzleType, "WeldConstraint")
                            end
                        end
                    end
                end
                v11.Name = "Equipped"
                v11:SetAttribute("WeaponName", v6)
                v11:SetAttribute("WeaponRevision", v13)
                v11.Parent = WeaponModel
                return v12
            end
            return nil
        end
        return nil
    end
    return nil
end

return table.freeze(u34)