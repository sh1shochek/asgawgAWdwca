-- ReplicatedStorage.Database.Components.Libraries.Skins
-- Script path: ReplicatedStorage.Database.Components.Libraries.Skins
-- Decompile time: 13.27 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local u33 = nil
local Signal = require(ReplicatedStorage.Packages.Signal)
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Weapons = Assets:WaitForChild("Weapons")
local Skins = Assets:WaitForChild("Skins")
local u51 = Signal.new()
u0.OnItemStockSchemasUpdated = u51
local u52 = {}
local u53 = {}
local u54 = {
    {max = 0.07, wear = "Factory New"},
    {max = 0.15, wear = "Minimal Wear"},
    {max = 0.38, wear = "Field-Tested"},
    {max = 0.45, wear = "Well-Worn"},
    {max = 1, wear = "Battle-Scarred"},
}
local u60 = {
    ["Factory New"] = "Mint Condition",
    ["Minimal Wear"] = "Near-Mint",
    ["Field-Tested"] = "Standard-Grade",
    ["Well-Worn"] = "Combat-Worn",
    ["Battle-Scarred"] = "War-Torn",
}

local function GetDataController() -- Line: 61 -- upvalues: u33 (ref), ReplicatedStorage (val)
    if not u33 then
        local success, result = pcall(function() -- Line: 63 -- upvalues: ReplicatedStorage (upval)
            return require(ReplicatedStorage.Controllers.DataController)
        end)
        if success then
            u33 = result
        end
    end
    return u33
end

local function ResolveCharmFromId(a1) -- Line: 75
    -- upvalues: u33 (ref), ReplicatedStorage (val), Players (val)
    if not u33 then
        local success, result = pcall(function() -- Line: 63 -- upvalues: ReplicatedStorage (upval)
            return require(ReplicatedStorage.Controllers.DataController)
        end)
        if success then
            u33 = result
        end
    end
    local v1 = u33
    if not v1 then
        return nil
    end
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then
        return nil
    end
    local v2 = v1.Get(LocalPlayer, "Inventory")
    if v2 and typeof(v2) == "table" then
        for i, v in ipairs(v2) do
            if v._id == a1 and v.Type == "Charm" then
                return {Skin = v.Skin, Pattern = v.Pattern}
            end
        end
        return nil
    end
    return nil
end

local function ValidateInputs(a1, a2) -- Line: 106 -- types: a1: string, a2: string
    local v1 = false
    if typeof(a1) == "string" then
        v1 = false
        if typeof(a2) == "string" then
            v1 = false
            if a1 ~= "" then
                v1 = a2 ~= ""
            end
        end
    end
    return v1
end

local function Weld(a1, a2) -- Line: 112 -- types: a1: userdata, a2: userdata
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = a1
    WeldConstraint.Part1 = a2
    WeldConstraint.Parent = a1
end

local function UpdateAvailableSkins(a1) -- Line: 121
    -- upvalues: u52 (ref), HttpService (val), u51 (val)
    u52 = HttpService:JSONDecode(a1)
    if #u51:GetConnections() > 0 then
        u51:Fire(u52)
    end
end

local function CreateSyntheticStockSchema(a1) -- Line: 130 -- upvalues: GetWeaponProperties (val) -- types: a1: string
    local v1 = GetWeaponProperties(a1)
    if not v1 then
        return nil
    end
    local v2 = {
        paintId = "stock",
        skin = "Stock",
        rarity = "Stock",
        supportsStatTrak = false,
        statTrakChance = 0,
        isEnabled = true,
        isMarketplaceVisible = false,
        description = "Standard issue finish.",
        caseRarity = "Stock",
        type = v1.Class,
        name = a1,
        floatRange = {min = 0, max = 0.07},
        floatChances = {{wear = "Factory New", chance = 100}},
        charmImages = {},
        wearImages = {},
    }
    local Icon = v1.Icon or v1.ReverseIcon
    v2.imageAssetId = Icon
    return v2
end

local function GetSyntheticStockSchema(a1) -- Line: 167
    -- upvalues: u53 (val), CreateSyntheticStockSchema (val)
    local v1 = u53[a1] or CreateSyntheticStockSchema(a1)
    u53[a1] = v1
    return v1
end

local function GetKillTrackValue(a1, a2) -- Line: 175 -- upvalues: GetWeaponProperties (val) -- types: a2: string
    local v1 = a1 or 0
    assert(typeof(v1) == "number", "KillCount must be a number")
    local success, result = pcall(GetWeaponProperties, a2)
    if success and result then
        if result.Class == "Melee" then
            return (tostring((math.clamp(math.floor(v1), 0, 9999))))
        end
        return string.format("%06d", (math.clamp(math.floor(v1), 0, 999999)))
    end
    return nil
end

local function GetWeaponFolder(a1) -- Line: 191 -- upvalues: Weapons (val) -- types: a1: string
    local v1 = Weapons:FindFirstChild(a1)
    if v1 and v1:IsA("Folder") then
        return v1
    end
    return nil
end

local function GetSkinTextureFolder(a1, a2, a3) -- Line: 199
    -- upvalues: Skins (val)
    local v1
    local v2 = Skins:FindFirstChild(a1)
    if not v2 then
        return nil
    end
    if a3 and a1 == "Smoke Grenade" then
        v1 = v2:FindFirstChild(a3)
        if v1 and v1:IsA("Folder") then
            return v1
        end
    end
    v1 = v2:FindFirstChild(a2)
    if v1 and v1:IsA("Folder") then
        return v1
    end
    return nil
end

local function GetSkinVariantFolder(a1, a2, a3, a4) -- Line: 219
    -- upvalues: GetSkinTextureFolder (val)
    local v1 = GetSkinTextureFolder(a1, a2, a3)
    return v1 and v1:FindFirstChild(a4)
end

local function GetWearFromFloat(a1, a2) -- Line: 226 -- upvalues: u54 (val), u60 (val) -- types: a2: number
    local v1 = math.clamp(math.clamp(a2, a1.floatRange.min, (math.max(a1.floatRange.min, a1.floatRange.max - 1e-12))), 0, 1)
    for i, v in ipairs(u54) do
        if v1 < v.max then
            return v.wear, u60[v.wear]
        end
    end
    return "Battle-Scarred", "War-Torn"
end

local function GetWearTextureFolder(a1, a2, a3) -- Line: 243
    -- upvalues: GetWearFromFloat (val), u54 (val)
    if a1 and a1:IsA("Folder") then
        local v1
        local v2 = GetWearFromFloat(a2, a3)
        local v3 = v2 and a1:FindFirstChild(v2)
        if v3 and v3:IsA("Folder") then
            return v3
        end
        for i, v in ipairs(u54) do
            v1 = a1:FindFirstChild(v.wear)
            if v1 and v1:IsA("Folder") then
                return v1
            end
        end
        return nil
    end
    return nil
end

local function ApplySkinTextures(a1, a2) -- Line: 268 -- types: a1: userdata, a2: userdata?
    local SurfaceAppearance
    if not a2 then
        return
    end
    for i, v in ipairs(a2:GetChildren()) do
        if v:IsA("SurfaceAppearance") then
            for i2, i3 in ipairs(a1:GetDescendants()) do
                if i3:IsA("MeshPart") and i3.Name == v.Name then
                    SurfaceAppearance = i3:FindFirstChildOfClass("SurfaceAppearance")
                    if SurfaceAppearance then
                        SurfaceAppearance:Destroy()
                    end
                    v:Clone().Parent = i3
                end
            end
        end
    end
end

local function ForEachWeaponPart(a1, a2, ...) -- Line: 295 -- types: a1: userdata, a2: function
    local Weapon = a1:FindFirstChild("Weapon")
    if Weapon then
        a2(a1, Weapon, ...)
        return
    end
    local WeaponL = a1:FindFirstChild("WeaponL")
    local WeaponR = a1:FindFirstChild("WeaponR")
    if WeaponL then
        a2(a1, WeaponL, ...)
    end
    if WeaponR then
        a2(a1, WeaponR, ...)
    end
end

local function AttachStatTrakToWeapon(a1, a2, a3, a4, a5) -- Line: 314
    -- upvalues: GetWeaponProperties (val), Assets (val), GetKillTrackValue (val)
    local success, result = pcall(GetWeaponProperties, a4)
    local v1 = Assets.Other[if not success then "KillTrak" else if not result then "KillTrak" else if result.Class ~= "Melee" then "KillTrak" else "KillTrackKnife"]:Clone()
    local PrimaryPart = a2.PrimaryPart
    local KillTrack = PrimaryPart and a2:FindFirstChild("KillTrack", true)
    if not KillTrack then
        v1:Destroy()
        return
    end
    local PrimaryPart_2 = v1.PrimaryPart
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = PrimaryPart_2
    WeldConstraint.Part1 = PrimaryPart
    WeldConstraint.Parent = PrimaryPart_2
    v1:PivotTo(KillTrack.WorldCFrame)
    local SurfaceGui = v1.Screen.SurfaceGui
    SurfaceGui.TextLabel.Text = GetKillTrackValue(a3, a4)
    if a5 then
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
        SurfaceGui.CanvasSize = Vector2.new(100, 25)
        SurfaceGui.TextLabel.TextSize = 29
        SurfaceGui.TextLabel.Size = UDim2.fromScale(1, 1)
    end
    v1.Parent = a1
end

local function AttachNameTagToWeapon(a1, a2, a3, a4) -- Line: 350
    -- upvalues: Assets (val)
    local v1 = Assets.Other.NamePlate:Clone()
    local PrimaryPart = a2.PrimaryPart
    local Nametag = PrimaryPart and PrimaryPart:FindFirstChild("Nametag")
    if not Nametag then
        v1:Destroy()
        return
    end
    local PrimaryPart_2 = v1.PrimaryPart
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = PrimaryPart_2
    WeldConstraint.Part1 = PrimaryPart
    WeldConstraint.Parent = PrimaryPart_2
    v1:PivotTo(Nametag.WorldCFrame)
    local SurfaceGui = v1.Screen.SurfaceGui
    SurfaceGui.TextLabel.Text = tostring(a3)
    if a4 then
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
        SurfaceGui.CanvasSize = Vector2.new(100, 8)
        SurfaceGui.TextLabel.TextSize = 8.98
        SurfaceGui.TextLabel.Size = UDim2.fromScale(0.95, 1)
        SurfaceGui.TextLabel.Position = UDim2.fromOffset(5, 0)
    end
    v1.Parent = a1
end

local function FindCharmModels(a1, a2) -- Line: 376 -- upvalues: Assets (val) -- types: a1: string, a2: number
    local Charms = Assets:FindFirstChild("Charms")
    local CharmBase = Charms and Charms:FindFirstChild("CharmBase")
    if CharmBase and CharmBase:IsA("Model") then
        local v1 = Charms:FindFirstChild(a1)
        local v2 = v1 and v1:FindFirstChild((tostring(a2)))
        if v2 and v2:IsA("Model") then
            return CharmBase, v2
        end
        return CharmBase, nil
    end
    return nil, nil
end

local function MountSpecificCharm(a1, a2) -- Line: 393 -- types: a1: userdata, a2: userdata
    local v1 = a2:Clone()
    v1.Parent = a1
    local Part = a1:FindFirstChild("Part")
    if Part and Part:IsA("BasePart") then
        v1:PivotTo(Part.CFrame)
        Part:Destroy()
    end
    local HingeConstraint = a1:FindFirstChild("HingeConstraint", true)
    if HingeConstraint and v1.PrimaryPart then
        local Attachment = v1.PrimaryPart:FindFirstChild("Attachment")
        if Attachment then
            HingeConstraint.Attachment1 = Attachment
        end
    end
end

local function AttachCharmToWeapon(a1, a2, a3, a4, a5) -- Line: 416
    -- upvalues: FindCharmModels (val), MountSpecificCharm (val)
    local v1, v2 = FindCharmModels(a2, a3)
    if not v1 then
        if not a5 then
            warn("Charm base not found for weapon:", a1.Name)
        end
        return
    end
    if not v2 then
        if not a5 then
            warn("Specific charm not found for weapon:", a1.Name, a2, a3)
        end
        return
    end
    local v3 = a1:FindFirstChild("Charm" .. a4, true)
    if not v3 then
        if not a5 then
            print("Charm attachment not found for weapon:", a1.Name, a4)
        end
        return
    end
    local Parent = v3.Parent
    if Parent and Parent:IsA("BasePart") then
        local v4 = v1:Clone()
        v4.Parent = a1
        v4:PivotTo(v3.WorldCFrame)
        if v4.PrimaryPart then
            local PrimaryPart = v4.PrimaryPart
            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Part0 = PrimaryPart
            WeldConstraint.Part1 = Parent
            WeldConstraint.Parent = PrimaryPart
        end
        MountSpecificCharm(v4, v2)
        return
    end
end

local function AttachCharm(a1, a2, a3) -- Line: 461
    -- upvalues: ResolveCharmFromId (val), AttachCharmToWeapon (val)
    if typeof(a2) ~= "table" then
        return
    end
    if a2._id and a2.Position then
        local Pattern, Skin, WeaponL, WeaponR
        local Position = a2.Position
        if a2.Skin and a2.Pattern then
            Skin = a2.Skin
            Pattern = a2.Pattern
            if Skin and Pattern then
                if a1:FindFirstChild("Weapon") then
                    AttachCharmToWeapon(a1, Skin, Pattern, Position, a3)
                    return
                end
                WeaponL = a1:FindFirstChild("WeaponL")
                WeaponR = a1:FindFirstChild("WeaponR")
                if WeaponL then
                    AttachCharmToWeapon(a1, Skin, Pattern, Position, a3)
                end
                if a3 and WeaponR then
                    AttachCharmToWeapon(a1, Skin, Pattern, Position, a3)
                end
                return
            end
            return
        end
        local v1 = ResolveCharmFromId(a2._id)
        if not v1 then
            return
        end
        Skin = v1.Skin
        Pattern = v1.Pattern
        if Skin and Pattern then
            if a1:FindFirstChild("Weapon") then
                AttachCharmToWeapon(a1, Skin, Pattern, Position, a3)
                return
            end
            WeaponL = a1:FindFirstChild("WeaponL")
            WeaponR = a1:FindFirstChild("WeaponR")
            if WeaponL then
                AttachCharmToWeapon(a1, Skin, Pattern, Position, a3)
            end
            if a3 and WeaponR then
                AttachCharmToWeapon(a1, Skin, Pattern, Position, a3)
            end
            return
        end
        return
    end
end

local function WaitForSkinInformation(a1, a2) -- Line: 511
    -- upvalues: u0 (val), u52 (ref), u51 (val)
    local v1 = u0.GetSkinInformation(a1, a2)
    if not v1 and next(u52) == nil then
        u51:Wait()
        v1 = u0.GetSkinInformation(a1, a2)
    end
    return v1
end

local function DecorateModel(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 522
    -- upvalues: ApplySkinTextures (val), GetWearTextureFolder (val), ForEachWeaponPart (val)
    -- upvalues: AttachStatTrakToWeapon (val), AttachNameTagToWeapon (val), AttachCharm (val)
    ApplySkinTextures(a1, (GetWearTextureFolder(a2, a3, a4 or a3.floatRange.max)))
    if a6 then
        ForEachWeaponPart(a1, AttachStatTrakToWeapon, a6, a5, a9)
    end
    if a7 then
        ForEachWeaponPart(a1, AttachNameTagToWeapon, a7, a9)
    end
    if a8 then
        AttachCharm(a1, a8, a9)
    end
    return a1
end

function u0.GetCharmModel(a1, a2) -- Line: 552
    -- upvalues: FindCharmModels (val), MountSpecificCharm (val)
    local v1, v2 = FindCharmModels(a1, a2)
    if not v1 then
        warn((("Skins.GetCharmModel: Charm base not found for charm \"%*\" with pattern \"%*\""):format(a1, a2)))
        return nil
    end
    if not v2 then
        warn((("Skins.GetCharmModel: Specific charm not found for charm \"%*\" with pattern \"%*\""):format(a1, a2)))
        return nil
    end
    local v3 = v1:Clone()
    v3.Name = a1
    MountSpecificCharm(v3, v2)
    return v3
end

function u0.GetBadgeModel(a1) -- Line: 568 -- upvalues: Assets (val) -- types: a1: string
    local Badges = Assets:FindFirstChild("Badges")
    if not Badges then
        warn((("Skins.GetBadgeModel: Badges folder not found for badge \"%*\""):format(a1)))
        return nil
    end
    local v1 = Badges:FindFirstChild(a1)
    if v1 and v1:IsA("Model") then
        return v1:Clone()
    end
    warn((("Skins.GetBadgeModel: Badge model not found for \"%*\""):format(a1)))
    return nil
end

function u0.GetWearNameForFloat(a1, a2) -- Line: 582 -- upvalues: GetWearFromFloat (val) -- types: a2: number
    return GetWearFromFloat(a1, a2)
end

function u0.GetAbbreviatedWearName(a1) -- Line: 588 -- types: a1: string
    return string.gsub(a1, "[^A-Z]", "")
end

function u0.ObserveItemStockSchemas(a1) -- Line: 594 -- upvalues: u51 (val), u52 (ref) -- types: a1: function
    local u5 = u51:Connect(a1)
    if next(u52) ~= nil then
        a1(u52)
    end
    return function() -- Line: 600 -- upvalues: u5 (val)
        if u5.Connected then
            u5:Disconnect()
        end
    end
end

u0.GetKillTrackValue = GetKillTrackValue

function u0.GetMagazine(a1, a2, a3) -- Line: 613
    -- upvalues: u0 (val), u52 (ref), u51 (val), Weapons (val), Skins (val), ApplySkinTextures (val)
    -- upvalues: GetWearTextureFolder (val)
    local v1 = false
    if typeof(a1) == "string" then
        v1 = false
        if typeof(a2) == "string" then
            v1 = false
            if a1 ~= "" then
                v1 = a2 ~= ""
            end
        end
    end
    if not v1 then
        return nil
    end
    v1 = u0.GetSkinInformation(a1, a2)
    if not v1 and next(u52) == nil then
        u51:Wait()
        v1 = u0.GetSkinInformation(a1, a2)
    end
    if not v1 then
        return nil
    end
    local v2 = Weapons:FindFirstChild(a1)
    local v3 = if not v2 then nil else if not v2:IsA("Folder") then nil else v2
    local Character = v3 and v3:FindFirstChild("Character")
    if Character and Character:IsA("Model") then
        local v4, v5
        local v6 = {}
        for i, v in ipairs(Character:GetDescendants()) do
            if v:IsA("BasePart") and v:HasTag("CharacterMagazine") then
                table.insert(v6, v)
            end
        end
        if #v6 == 0 then
            return nil
        end
        local Model = Instance.new("Model")
        Model.Name = "Magazine"
        for i2, i3 in ipairs(v6) do
            v4 = i3:Clone()
            v4.Parent = Model
            if not Model.PrimaryPart then
                Model.PrimaryPart = v4
            end
        end
        local v7 = Skins:FindFirstChild(a1)
        if v7 then
            local v8 = v7:FindFirstChild(a2)
            v5 = if not v8 then nil else if not v8:IsA("Folder") then nil else v8
        else
            v5 = nil
        end
        local min = a3 or v1.floatRange.min
        ApplySkinTextures(Model, (GetWearTextureFolder(v5 and v5:FindFirstChild("Character"), v1, min)))
        return Model
    end
    return nil
end

function u0.GetGloves(a1, a2, a3) -- Line: 661
    -- upvalues: u0 (val), u52 (ref), u51 (val), Weapons (val), Skins (val), ApplySkinTextures (val)
    -- upvalues: GetWearTextureFolder (val)
    local v1, v2
    local v3 = false
    if typeof(a1) == "string" then
        v3 = false
        if typeof(a2) == "string" then
            v3 = false
            if a1 ~= "" then
                v3 = a2 ~= ""
            end
        end
    end
    if not v3 then
        return nil
    end
    v3 = u0.GetSkinInformation(a1, a2)
    if not v3 and next(u52) == nil then
        u51:Wait()
        v3 = u0.GetSkinInformation(a1, a2)
    end
    if not v3 then
        return nil
    end
    local v4 = Weapons:FindFirstChild(a1)
    if not (if not v4 then nil else if not v4:IsA("Folder") then nil else v4) then
        return nil
    end
    local Model = Instance.new("Model")
    Model.Name = a1
    for i, v in ipairs(v1:GetChildren()) do
        if v:IsA("BasePart") then
            v:Clone().Parent = Model
        end
    end
    local v5 = Skins:FindFirstChild(a1)
    if v5 then
        local v6 = v5:FindFirstChild(a2)
        v2 = if not v6 then nil else if not v6:IsA("Folder") then nil else v6
    else
        v2 = nil
    end
    local min = a3 or v3.floatRange.min
    ApplySkinTextures(Model, (GetWearTextureFolder(v2 and v2:FindFirstChild("Camera"), v3, min)))
    return Model
end

function u0.GetCharacterModel(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 696
    -- upvalues: u0 (val), u52 (ref), u51 (val), Weapons (val), GetSkinTextureFolder (val), DecorateModel (val)
    local v1 = false
    if typeof(a1) == "string" then
        v1 = false
        if typeof(a2) == "string" then
            v1 = false
            if a1 ~= "" then
                v1 = a2 ~= ""
            end
        end
    end
    if not v1 then
        return nil
    end
    v1 = u0.GetSkinInformation(a1, a2)
    if not v1 and next(u52) == nil then
        u51:Wait()
        v1 = u0.GetSkinInformation(a1, a2)
    end
    if not v1 then
        warn((("SkinHandler.GetCharacterModel: Skin \"%*\" not found for weapon \"%*\""):format(a2, a1)))
        return nil
    end
    local v2 = Weapons:FindFirstChild(a1)
    local v3 = if not v2 then nil else if not v2:IsA("Folder") then nil else v2
    local Character = v3 and v3:FindFirstChild("Character")
    if Character and Character:IsA("Model") then
        local v4 = Character:Clone()
        local v5 = GetSkinTextureFolder(a1, a2, a8)
        return (DecorateModel(v4, v5 and v5:FindFirstChild("Character"), v1, a3, a1, a4, a5, a6, false))
    end
    warn((("SkinHandler.GetCharacterModel: Base character model not found for weapon \"%*\""):format(a1)))
    return nil
end

function u0.GetWorldModel(a1, a2, a3, a4, a5, a6, a7) -- Line: 730
    -- upvalues: u0 (val), u52 (ref), u51 (val), Weapons (val), Skins (val), DecorateModel (val)
    local v1 = false
    if typeof(a1) == "string" then
        v1 = false
        if typeof(a2) == "string" then
            v1 = false
            if a1 ~= "" then
                v1 = a2 ~= ""
            end
        end
    end
    if not v1 then
        return nil
    end
    v1 = u0.GetSkinInformation(a1, a2)
    if not v1 and next(u52) == nil then
        u51:Wait()
        v1 = u0.GetSkinInformation(a1, a2)
    end
    if not v1 then
        return nil
    end
    local v2 = Weapons:FindFirstChild(a1)
    local v3 = if not v2 then nil else if not v2:IsA("Folder") then nil else v2
    local Other = v3 and v3:FindFirstChild("Other")
    local World = Other and Other:FindFirstChild("World")
    if World and World:IsA("Model") then
        local v4
        local v5 = World:Clone()
        local v6 = Skins:FindFirstChild(a1)
        if v6 then
            local v7 = v6:FindFirstChild(a2)
            v4 = if not v7 then nil else if not v7:IsA("Folder") then nil else v7
        else
            v4 = nil
        end
        return (DecorateModel(v5, v4 and v4:FindFirstChild("Character"), v1, a3, a1, a4, a5, a6, false))
    end
    return nil
end

function u0.GetCameraModel(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 763
    -- upvalues: u0 (val), u52 (ref), u51 (val), Weapons (val), GetSkinTextureFolder (val), DecorateModel (val)
    local v1 = false
    if typeof(a1) == "string" then
        v1 = false
        if typeof(a2) == "string" then
            v1 = false
            if a1 ~= "" then
                v1 = a2 ~= ""
            end
        end
    end
    if not v1 then
        return nil
    end
    v1 = u0.GetSkinInformation(a1, a2)
    if not v1 and next(u52) == nil then
        u51:Wait()
        v1 = u0.GetSkinInformation(a1, a2)
    end
    if not v1 then
        return nil
    end
    local v2 = Weapons:FindFirstChild(a1)
    local v3 = if not v2 then nil else if not v2:IsA("Folder") then nil else v2
    local Camera = v3 and v3:FindFirstChild("Camera")
    if Camera and Camera:IsA("Model") then
        local v4 = Camera:Clone()
        local v5 = GetSkinTextureFolder(a1, a2, a8)
        return (DecorateModel(v4, v5 and v5:FindFirstChild("Camera"), v1, a3, a1, a4, a5, a6, true))
    end
    return nil
end

function u0.GetSkinInformation(a1, a2) -- Line: 795
    -- upvalues: u52 (ref), u53 (val), CreateSyntheticStockSchema (val)
    local v1 = false
    if typeof(a1) == "string" then
        v1 = false
        if typeof(a2) == "string" then
            v1 = false
            if a1 ~= "" then
                v1 = a2 ~= ""
            end
        end
    end
    if not v1 then
        return nil
    end
    v1 = u52[a1]
    if v1 and v1[a2] then
        return v1[a2]
    end
    if a2 ~= "Stock" then
        return nil
    end
    local v2 = u53[a1] or CreateSyntheticStockSchema(a1)
    u53[a1] = v2
    return v2
end

function u0.IsSkinAvailable(a1, a2) -- Line: 817 -- upvalues: u0 (val), Skins (val) -- types: a1: string, a2: string
    local v1 = u0.GetSkinInformation(a1, a2)
    if not v1 then
        return false
    end
    if v1.type ~= "Weapon" and v1.type ~= "Melee" and v1.type ~= "Glove" and v1.type ~= "Zeus x27" then
        return true
    end
    local v2 = Skins:FindFirstChild(a1)
    if v2 and v2:IsA("Folder") then
        local v3
        local v4 = Skins:FindFirstChild(a1)
        if v4 then
            local v5 = v4:FindFirstChild(a2)
            v3 = if not v5 then nil else if not v5:IsA("Folder") then nil else v5
        else
            v3 = nil
        end
        return v3 ~= nil
    end
    return false
end

function u0.HasSkinTextures(a1, a2) -- Line: 842 -- upvalues: Skins (val) -- types: a1: string, a2: string
    local v1 = false
    if typeof(a1) == "string" then
        v1 = false
        if typeof(a2) == "string" then
            v1 = false
            if a1 ~= "" then
                v1 = a2 ~= ""
            end
        end
    end
    if not v1 then
        return false
    end
    v1 = Skins:FindFirstChild(a1)
    if v1 and v1:IsA("Folder") then
        local v2
        local v3 = Skins:FindFirstChild(a1)
        if v3 then
            local v4 = v3:FindFirstChild(a2)
            v2 = if not v4 then nil else if not v4:IsA("Folder") then nil else v4
        else
            v2 = nil
        end
        return v2 ~= nil
    end
    return true
end

function u0.GetAllSkinsForWeapon(a1) -- Line: 858 -- upvalues: u52 (ref) -- types: a1: string
    if typeof(a1) == "string" and a1 ~= "" then
        local v1 = u52[a1]
        if not v1 then
            return nil
        end
        local v2 = {}
        for k, v in pairs(v1) do
            table.insert(v2, v)
        end
        return v2
    end
    return nil
end

function u0.GetWearImageForFloat(a1, a2) -- Line: 877 -- upvalues: GetWearFromFloat (val) -- types: a2: number
    local v1 = GetWearFromFloat(a1, a2)
    if not v1 then
        return nil
    end
    for i, v in ipairs(a1.wearImages) do
        if v.wear == v1 then
            return v.assetId
        end
    end
    return nil
end

local function getCharmImageForPattern(a1, a2) -- Line: 893 -- types: a2: number?
    for i, j in a1.charmImages or {} do
        if j.pattern == a2 then
            return j.assetId
        end
    end
    return nil
end

function u0.GetItemIconImage(a1, a2) -- Line: 905 -- upvalues: u0 (val)
    local assetId, v1
    if a2.Type == "Charm" then
        v1 = a2.Pattern or 1
        for i, j in a1.charmImages or {} do
            if j.pattern == v1 then
                assetId = j.assetId
                return assetId or a1.imageAssetId or ""
            end
        end
        assetId = nil
    elseif a2.Name ~= "Charm" then
        assetId = u0.GetWearImageForFloat(a1, a2.Float or 0)
    else
        v1 = a2.Pattern or 1
        for k, n in a1.charmImages or {} do
            if n.pattern == v1 then
                assetId = n.assetId
                return assetId or a1.imageAssetId or ""
            end
        end
        assetId = nil
    end
    return assetId or a1.imageAssetId or ""
end

function u0.GetBaseWeaponModel(a1, a2) -- Line: 915 -- upvalues: Weapons (val) -- types: a1: string, a2: string
    if typeof(a1) == "string" and a1 ~= "" then
        local v1
        local v2 = Weapons:FindFirstChild(a1)
        if not (if not v2 then nil else if not v2:IsA("Folder") then nil else v2) then
            return nil
        end
        v2 = v1:FindFirstChild(a2)
        if v2 and v2:IsA("Model") then
            return (v2:Clone())
        end
        return nil
    end
    return nil
end

local Attribute = ReplicatedStorage:GetAttribute("AvaiableSkins")
if Attribute then
    u52 = HttpService:JSONDecode(Attribute)
    if #u51:GetConnections() > 0 then
        u51:Fire(u52)
    end
end
;(ReplicatedStorage:GetAttributeChangedSignal("AvaiableSkins")):Connect(function() -- Line: 932 -- upvalues: ReplicatedStorage (val), u52 (ref), HttpService (val), u51 (val)
    local Attribute = ReplicatedStorage:GetAttribute("AvaiableSkins")
    if Attribute then
        u52 = HttpService:JSONDecode(Attribute)
        if #u51:GetConnections() > 0 then
            u51:Fire(u52)
        end
    end
end)
return u0