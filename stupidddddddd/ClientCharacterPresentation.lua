-- ReplicatedStorage.Components.Common.ClientCharacterPresentation
-- Script path: ReplicatedStorage.Components.Common.ClientCharacterPresentation
-- Decompile time: 10.13 ms

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration)
local CharacterPresentationDescriptor = require(ReplicatedStorage.Components.Common.CharacterPresentationDescriptor)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local u47 = {}
local Attributes = CharacterPresentationDescriptor.Attributes
local Characters = (ReplicatedStorage:WaitForChild("Assets")):WaitForChild("Characters")
local u57 = {}
local u58 = {}
local u59 = nil
local u60 = {}
local u61 = {}
local u62 = {}
local u63 = false
local u64 = 0

local function getCharactersFolder() -- Line: 32 -- upvalues: Workspace (val)
    return Workspace:FindFirstChild("Characters") or Workspace
end

local function disconnectCharacter(a1) -- Line: 36 -- upvalues: u57 (val) -- types: a1: userdata
    local v1 = u57[a1]
    if v1 ~= nil then
        u57[a1] = nil
        v1()
    end
end

local function setBodyColor(a1, a2) -- Line: 44 -- types: a1: userdata
    if typeof(a2) ~= "Color3" then
        return
    end
    local v1 = a1:FindFirstChild("Body Colors")
    if v1 ~= nil and v1:IsA("BodyColors") then
        v1.HeadColor3 = a2
        v1.LeftArmColor3 = a2
        v1.RightArmColor3 = a2
        v1.LeftLegColor3 = a2
        v1.RightLegColor3 = a2
        v1.TorsoColor3 = a2
        return
    end
end

local function attachGloves(a1, a2) -- Line: 60
    -- upvalues: HttpService (val), Skins (val), AttachGlovesToCharacter (val)
    if typeof(a2) == "string" and a2 ~= "" then
        local success, result = pcall(HttpService.JSONDecode, HttpService, a2)
        if success and typeof(result) == "table" then
            local Name_2 = result.Name
            local Skin = result.Skin
            local Float = result.Float
            if typeof(Name_2) == "string" and typeof(Skin) == "string" and typeof(Float) == "number" then
                local u32 = Skins.GetGloves(Name_2, Skin, Float)
                local CharacterArmor = a1:FindFirstChild("CharacterArmor")
                if u32 ~= nil and CharacterArmor ~= nil then
                    local success_2, result_2 = pcall(function() -- Line: 79 -- upvalues: AttachGlovesToCharacter (upval), u32 (val), a1 (val), CharacterArmor (val)
                        AttachGlovesToCharacter(u32:GetChildren(), a1, CharacterArmor, {collisionGroup = "Debris"})
                    end)
                    if not success_2 then
                        warn((("[CharacterPresentation] Failed to attach gloves to %*: %*"):format(a1.Name, result_2)))
                    end
                    return
                end
                return
            end
            return
        end
        return
    end
end

function u47.GetCulledFolder() -- Line: 90 -- upvalues: u59 (ref), ReplicatedStorage (val)
    local v1 = u59
    if v1 == nil or v1.Parent ~= ReplicatedStorage then
        v1 = Instance.new("Folder")
        v1.Name = "_PVS_CulledCharacters"
        v1.Archivable = false
        v1.Parent = ReplicatedStorage
        u59 = v1
    end
    return v1
end

function u47.PrepareRuntimeRig(a1) -- Line: 103 -- upvalues: CharacterResolver (val) -- types: a1: userdata
    local Folder, v1
    for i, j in a1:GetChildren() do
        if j:IsA("Humanoid") then
            j:Destroy()
        end
    end
    if CharacterResolver.getCameraPart(a1) == nil then
        CharacterResolver.createCameraPart(a1)
    end
    CharacterResolver.getOrCreateAnimator(a1)
    local v2 = {"WeaponModel", "WeaponAttachments"}
    local v3 = nil
    local v4 = nil
    local v5 = a1
    for k, n in v2, v3, v4 do
        v1 = v5:FindFirstChild(n)
        if v1 ~= nil then
            v1:Destroy()
        end
        Folder = Instance.new("Folder")
        Folder.Name = n
        Folder.Parent = v5
    end
    for m, i5 in v5:GetDescendants() do
        if i5:IsA("BasePart") then
            i5.CanCollide = false
            i5.CanTouch = false
            if i5.Name == "HumanoidRootPart" then
                i5.Anchored = true
                i5.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                i5.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

local function getRigKey(a1) -- Line: 136 -- upvalues: Attributes (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute(Attributes.CharacterName)
    if typeof(Attribute) == "string" and Attribute ~= "" then
        local Attribute_2 = a1:GetAttribute(Attributes.BodyColor)
        local concat = table.concat
        local v1 = {}
        local v2 = tostring((a1:GetAttribute(Attributes.EquippedGloves)))
        local v3 = if typeof(Attribute_2) ~= "Color3" then "" else Attribute_2:ToHex()
        v1[1] = Attribute
        v1[2] = v2
        v1[3] = v3
        return concat(v1, "|")
    end
    return nil
end

local function buildRig(a1) -- Line: 150
    -- upvalues: Attributes (val), Characters (val), u47 (val), attachGloves (val)
    local Attribute = a1:GetAttribute(Attributes.CharacterName)
    if typeof(Attribute) == "string" and Attribute ~= "" then
        local v1 = Characters:FindFirstChild(Attribute)
        if v1 ~= nil and v1:IsA("Model") then
            local v2 = v1:Clone()
            v2.Archivable = true
            v2:SetAttribute("CharacterName", Attribute)
            u47.PrepareRuntimeRig(v2)
            local Attribute_2 = a1:GetAttribute(Attributes.EquippedGloves)
            if typeof(Attribute_2) == "string" then
                v2:SetAttribute("EquippedGloves", Attribute_2)
                attachGloves(v2, Attribute_2)
            end
            local Attribute_3 = a1:GetAttribute(Attributes.BodyColor)
            if typeof(Attribute_3) ~= "Color3" then
                return v2
            end
            local v3 = v2:FindFirstChild("Body Colors")
            if v3 ~= nil then
                if not v3:IsA("BodyColors") then
                    return v2
                end
                v3.HeadColor3 = Attribute_3
                v3.LeftArmColor3 = Attribute_3
                v3.RightArmColor3 = Attribute_3
                v3.LeftLegColor3 = Attribute_3
                v3.RightLegColor3 = Attribute_3
                v3.TorsoColor3 = Attribute_3
            end
            return v2
        end
        warn((("[CharacterPresentation] Missing character template %*"):format((tostring(Attribute)))))
        return nil
    end
    return nil
end

local function takeSpare(a1) -- Line: 183 -- upvalues: u60 (val), getRigKey (val) -- types: a1: userdata
    local v1 = u60[a1]
    if v1 == nil then
        return nil
    end
    u60[a1] = nil
    if v1.Key == getRigKey(a1) then
        return v1.Rig
    end
    v1.Rig:Destroy()
    return nil
end

local function runSpareWorker() -- Line: 196
    -- upvalues: u61 (val), u64 (ref), u62 (val), Players (val), getRigKey (val), u60 (val), buildRig (val), u63 (ref)
    local v1, v2, v3, v4, v5
    while true do
        if not (#u61 > 0) then
            break
        end
        v1 = os.clock()
        v2 = v1 - u64
        if not (v2 < 1) then
            v2 = table.remove(u61, 1)
            u62[v2] = nil
            v3 = if v2.Parent ~= Players then nil else getRigKey(v2)
            v4 = u60[v2]
            if v3 ~= nil then
                if v4 == nil or v4.Key ~= v3 then
                    v5 = u60[v2]
                    if v5 ~= nil then
                        u60[v2] = nil
                        v5.Rig:Destroy()
                    end
                    v5 = buildRig(v2)
                    if v5 ~= nil then
                        u60[v2] = {Key = v3, Rig = v5}
                    end
                    task.wait(0.1)
                end
            end
        else
            task.wait(1 - (v1 - u64))
        end
    end
    u63 = false
end

local function queueSpare(a1) -- Line: 220
    -- upvalues: u62 (val), u61 (val), u63 (ref), runSpareWorker (val)
    if u62[a1] then
        return
    end
    u62[a1] = true
    table.insert(u61, a1)
    if not u63 then
        u63 = true
        task.spawn(runSpareWorker)
    end
end

function u47.IsOwned(a1) -- Line: 232 -- upvalues: CharacterPresentationDescriptor (val) -- types: a1: userdata?
    local v1 = false
    if a1 ~= nil then
        v1 = a1:GetAttribute(CharacterPresentationDescriptor.OwnedAttribute) == true
    end
    return v1
end

function u47.Release(a1, a2) -- Line: 236
    -- upvalues: u47 (val), u58 (val), u57 (val)
    local Character = a2 or (if not u47.IsOwned(a1.Character) then u58[a1] else a1.Character)
    if not u47.IsOwned(Character) then
        return
    end
    local v1 = u57[Character]
    if v1 ~= nil then
        u57[Character] = nil
        v1()
    end
    if u58[a1] == Character then
        u58[a1] = nil
    end
    if a1.Character == Character then
        a1.Character = nil
    end
    Character:Destroy()
end

function u47.Create(a1, a2) -- Line: 253
    -- upvalues: Players (val), u58 (val), u47 (val), CharacterGeneration (val), u64 (ref), u60 (val), getRigKey (val)
    -- upvalues: buildRig (val), u62 (val), u61 (val), u63 (ref), runSpareWorker (val)
    -- upvalues: CharacterPresentationDescriptor (val), Attributes (val), u57 (val), Workspace (val)
    if a1.Parent == Players and typeof(a2) == "number" then
        local Rig
        local v1 = u58[a1]
        if v1 ~= nil and v1.Parent == nil then
            u58[a1] = nil
            v1 = nil
        end
        local Character = if not u47.IsOwned(a1.Character) then v1 else a1.Character
        if Character ~= nil and CharacterGeneration.Get(Character) == a2 and Character.Parent ~= nil then
            if a1.Character ~= Character then
                a1.Character = Character
            end
            return Character
        end
        if Character ~= nil then
            u47.Release(a1, Character)
        end
        if v1 ~= nil and v1 ~= Character then
            u47.Release(a1, v1)
        end
        u64 = os.clock()
        local v2 = u60[a1]
        if v2 ~= nil then
            u60[a1] = nil
            if v2.Key ~= getRigKey(a1) then
                v2.Rig:Destroy()
                Rig = nil
            else
                Rig = v2.Rig
            end
        else
            Rig = nil
        end
        if not Rig then
            Rig = buildRig(a1)
        end
        if Rig == nil then
            return nil
        end
        if not u62[a1] then
            u62[a1] = true
            table.insert(u61, a1)
            if not u63 then
                u63 = true
                task.spawn(runSpareWorker)
            end
        end
        Rig.Name = a1.Name
        Rig:SetAttribute(CharacterPresentationDescriptor.OwnedAttribute, true)
        Rig:SetAttribute(CharacterPresentationDescriptor.OwnerUserIdAttribute, a1.UserId)
        Rig:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, true)
        Rig:SetAttribute("CharacterType", "PlayerCustomCharacter")
        CharacterGeneration.Set(Rig, a2)

        local function mirrorAttribute(a1_2, a2, a3) -- Line: 291
            -- upvalues: a1 (val), Rig (val)
            local Attribute = a1:GetAttribute(a1_2)
            Rig:SetAttribute(a2, if Attribute ~= nil then Attribute else a3)
        end

        local Attribute = a1:GetAttribute(Attributes.Health)
        Rig:SetAttribute("Health", if Attribute ~= nil then Attribute else 100)
        local Attribute_2 = a1:GetAttribute(Attributes.MaxHealth)
        Rig:SetAttribute("MaxHealth", if Attribute_2 ~= nil then Attribute_2 else 100)
        local Attribute_3 = a1:GetAttribute("Dead")
        Rig:SetAttribute("Dead", if Attribute_3 ~= nil then Attribute_3 else false)
        local Attribute_4 = a1:GetAttribute("CompetitivePlayerColor")
        Rig:SetAttribute("CompetitivePlayerColor", if Attribute_4 ~= nil then Attribute_4 else nil)
        local Attribute_5 = a1:GetAttribute(Attributes.SpawnPosition)
        local Attribute_6 = a1:GetAttribute(Attributes.SpawnYaw)
        if typeof(Attribute_5) ~= "Vector3" then
            Rig:PivotTo((CFrame.new(0, -1000, 0)))
        else
            Rig:PivotTo((CFrame.new(Attribute_5)) * (CFrame.Angles(0, if typeof(Attribute_6) ~= "number" then 0 else Attribute_6, 0)))
        end
        local u228 = {}

        local function connect(a1_2, a2) -- Line: 311
            -- upvalues: u228 (val), a1 (val)
            local v1 = u228
            local v2 = #u228 + 1
            v1[v2] = ((a1:GetAttributeChangedSignal(a1_2)):Connect(a2))
        end

        local Health_2 = Attributes.Health
        u228[#u228 + 1] = ((a1:GetAttributeChangedSignal(Health_2)):Connect(function() -- Line: 314 -- upvalues: Attributes (upval), a1 (val), Rig (val)
            local Attribute = a1:GetAttribute(Attributes.Health)
            Rig:SetAttribute("Health", if Attribute ~= nil then Attribute else 0)
        end))
        local MaxHealth_2 = Attributes.MaxHealth
        u228[#u228 + 1] = ((a1:GetAttributeChangedSignal(MaxHealth_2)):Connect(function() -- Line: 317 -- upvalues: Attributes (upval), a1 (val), Rig (val)
            local Attribute = a1:GetAttribute(Attributes.MaxHealth)
            Rig:SetAttribute("MaxHealth", if Attribute ~= nil then Attribute else 100)
        end))
        u228[#u228 + 1] = ((a1:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 320 -- upvalues: a1 (val), Rig (val)
            local Attribute = a1:GetAttribute("Dead")
            Rig:SetAttribute("Dead", if Attribute ~= nil then Attribute else false)
        end))
        u228[#u228 + 1] = ((a1:GetAttributeChangedSignal("CompetitivePlayerColor")):Connect(function() -- Line: 323 -- upvalues: a1 (val), Rig (val)
            local Attribute = a1:GetAttribute("CompetitivePlayerColor")
            Rig:SetAttribute("CompetitivePlayerColor", if Attribute ~= nil then Attribute else nil)
        end))
        local BodyColor = Attributes.BodyColor
        u228[#u228 + 1] = ((a1:GetAttributeChangedSignal(BodyColor)):Connect(function() -- Line: 326 -- upvalues: Rig (val), a1 (val), Attributes (upval)
            local Attribute = a1:GetAttribute(Attributes.BodyColor)
            if typeof(Attribute) ~= "Color3" then
                return
            end
            local v1 = Rig:FindFirstChild("Body Colors")
            if v1 ~= nil then
                if not v1:IsA("BodyColors") then
                    return
                end
                v1.HeadColor3 = Attribute
                v1.LeftArmColor3 = Attribute
                v1.RightArmColor3 = Attribute
                v1.LeftLegColor3 = Attribute
                v1.RightLegColor3 = Attribute
                v1.TorsoColor3 = Attribute
            end
        end))

        u57[Rig] = function() -- Line: 329 -- upvalues: u228 (val)
            for i, j in u228 do
                j:Disconnect()
            end
        end

        u228[#u228 + 1] = (Rig.Destroying:Connect(function() -- Line: 334 -- upvalues: Rig (val), u57 (upval), u58 (upval), a1 (val)
            local v1 = Rig
            local v2 = u57[v1]
            if v2 ~= nil then
                u57[v1] = nil
                v2()
            end
            if u58[a1] == Rig then
                u58[a1] = nil
            end
        end))
        local Characters = Workspace:FindFirstChild("Characters") or Workspace
        Rig.Parent = Characters
        u58[a1] = Rig
        a1.Character = Rig
        return Rig
    end
    return nil
end

function u47.ObserveLocalPlayer() -- Line: 347 -- upvalues: Players (val), Attributes (val), u47 (val)
    local LocalPlayer = Players.LocalPlayer

    local function refresh() -- Line: 349 -- upvalues: LocalPlayer (val), Attributes (upval), u47 (upval)
        local Attribute = LocalPlayer:GetAttribute(Attributes.Generation)
        if typeof(Attribute) == "number" and LocalPlayer:GetAttribute("Dead") ~= true then
            u47.Create(LocalPlayer, Attribute)
        end
    end

    local u3 = {}
    local v1 = (LocalPlayer:GetAttributeChangedSignal(Attributes.Generation)):Connect(refresh)
    local v2 = (LocalPlayer:GetAttributeChangedSignal(Attributes.CharacterName)):Connect(refresh)
    local AttributeChangedSignal_3 = LocalPlayer:GetAttributeChangedSignal("Dead")
    u3[1] = v1
    u3[2] = v2
    u3[3] = AttributeChangedSignal_3:Connect(refresh)
    local Attribute = LocalPlayer:GetAttribute(Attributes.Generation)
    if typeof(Attribute) == "number" and LocalPlayer:GetAttribute("Dead") ~= true then
        u47.Create(LocalPlayer, Attribute)
    end
    return function() -- Line: 361 -- upvalues: u3 (val), u47 (upval), LocalPlayer (val)
        for i, j in u3 do
            j:Disconnect()
        end
        u47.Release(LocalPlayer, LocalPlayer.Character)
    end
end

Players.PlayerRemoving:Connect(function(a1) -- Line: 175 -- upvalues: u60 (val) -- types: a1: userdata
    local v1 = u60[a1]
    if v1 ~= nil then
        u60[a1] = nil
        v1.Rig:Destroy()
    end
end)
return u47