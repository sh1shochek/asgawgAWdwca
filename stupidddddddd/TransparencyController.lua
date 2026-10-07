-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.TransparencyController
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.TransparencyController
-- Decompile time: 4.56 ms

local VRService = game:GetService("VRService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local u15 = {"BasePart", "Decal", "Beam", "ParticleEmitter", "Trail", "Fire", "Smoke", "Sparkles", "Explosion"}
local u25 = {
    [Enum.AccessoryType.Hat] = true,
    [Enum.AccessoryType.Hair] = true,
    [Enum.AccessoryType.Face] = true,
    [Enum.AccessoryType.Eyebrow] = true,
    [Enum.AccessoryType.Eyelash] = true,
}
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local success, result = pcall(function() -- Line: 38
    return UserSettings():IsUserFeatureEnabled("UserHideCharacterParticlesInFirstPerson")
end)
local u54 = success and result
local u55 = {}
u55.__index = u55

local function resolveSubjectCharacter(a1) -- Line: 49 -- types: a1: userdata?
    if not a1 then
        return nil
    end
    if a1:IsA("Humanoid") then
        local Parent = a1.Parent
        if Parent and Parent:IsA("Model") then
            return Parent
        end
        return nil
    end
    if a1:IsA("VehicleSeat") and a1.Occupant then
        local Parent_2 = a1.Occupant.Parent
        if Parent_2 and Parent_2:IsA("Model") then
            return Parent_2
        end
        return nil
    end
    if a1:IsA("BasePart") then
        return a1:FindFirstAncestorOfClass("Model")
    end
    if a1:IsA("Model") then
        return a1
    end
    return nil
end

function u55.new() -- Line: 73 -- upvalues: u55 (val)
    local v1 = setmetatable({}, u55)
    v1.transparencyDirty = false
    v1.enabled = false
    v1.lastTransparency = nil
    v1.descendantAddedConn = nil
    v1.descendantRemovingConn = nil
    v1.toolDescendantAddedConns = {}
    v1.toolDescendantRemovingConns = {}
    v1.cachedParts = {}
    v1.character = nil
    return v1
end

function u55:HasToolAncestor(a2) -- Line: 89 -- types: self: table, a2: userdata
    if a2.Parent == nil then
        return false
    end
    assert(a2.Parent, "")
    return a2.Parent:IsA("Tool") or self:HasToolAncestor(a2.Parent)
end

function u55:IsValidPartToModify(a2) -- Line: 97 -- upvalues: u54 (ref), u15 (val) -- types: self: table, a2: userdata
    if u54 then
        for i, j in u15 do
            if a2:IsA(j) then
                return not self:HasToolAncestor(a2)
            end
        end
        return false
    end
    if not a2:IsA("BasePart") and not a2:IsA("Decal") then
        return false
    end
    return not self:HasToolAncestor(a2)
end

function u55:CachePartsRecursive(a2) -- Line: 112
    if a2 then
        if self:IsValidPartToModify(a2) then
            self.cachedParts[a2] = true
            self.transparencyDirty = true
        end
        for k, v in pairs(a2:GetChildren()) do
            self:CachePartsRecursive(v)
        end
    end
end

function u55:TeardownTransparency() -- Line: 124 -- upvalues: Players (val)
    local character = self.character
    if character then
        character = true
        if self.character:GetAttribute("Dead") ~= true then
            character = Players.LocalPlayer
            if character then
                character = false
                if Players.LocalPlayer.Character == self.character then
                    character = Players.LocalPlayer:GetAttribute("IsSpectating") == true
                end
            end
        end
    end
    local v1 = self
    for k, v in pairs(self.cachedParts) do
        k.LocalTransparencyModifier = if not character then 0 else 1
    end
    v1.cachedParts = {}
    v1.character = nil
    v1.transparencyDirty = true
    v1.lastTransparency = nil
    if v1.descendantAddedConn then
        v1.descendantAddedConn:disconnect()
        v1.descendantAddedConn = nil
    end
    if v1.descendantRemovingConn then
        v1.descendantRemovingConn:disconnect()
        v1.descendantRemovingConn = nil
    end
    for k2, i in pairs(v1.toolDescendantAddedConns) do
        i:Disconnect()
        v1.toolDescendantAddedConns[k2] = nil
    end
    for k3, j in pairs(v1.toolDescendantRemovingConns) do
        j:Disconnect()
        v1.toolDescendantRemovingConns[k3] = nil
    end
end

function u55:SetupTransparency(a2) -- Line: 164
    self:TeardownTransparency()
    self.character = a2
    if self.descendantAddedConn then
        self.descendantAddedConn:disconnect()
    end
    self.descendantAddedConn = a2.DescendantAdded:Connect(function(a1) -- Line: 171 -- upvalues: self (val), a2 (val)
        if self:IsValidPartToModify(a1) then
            self.cachedParts[a1] = true
            self.transparencyDirty = true
            return
        end
        if a1:IsA("Tool") then
            if self.toolDescendantAddedConns[a1] then
                self.toolDescendantAddedConns[a1]:Disconnect()
            end
            self.toolDescendantAddedConns[a1] = (a1.DescendantAdded:Connect(function(a1) -- Line: 181 -- upvalues: self (upval)
                self.cachedParts[a1] = nil
                if a1:IsA("BasePart") or a1:IsA("Decal") then
                    a1.LocalTransparencyModifier = 0
                end
            end))
            if self.toolDescendantRemovingConns[a1] then
                self.toolDescendantRemovingConns[a1]:disconnect()
            end
            self.toolDescendantRemovingConns[a1] = (a1.DescendantRemoving:Connect(function(a1) -- Line: 191 -- upvalues: a2 (upval), self (upval)
                wait()
                if a2 and a1 and a1:IsDescendantOf(a2) and self:IsValidPartToModify(a1) then
                    self.cachedParts[a1] = true
                    self.transparencyDirty = true
                end
            end))
        end
    end)
    if self.descendantRemovingConn then
        self.descendantRemovingConn:disconnect()
    end
    self.descendantRemovingConn = a2.DescendantRemoving:connect(function(a1) -- Line: 205 -- upvalues: self (val)
        if self.cachedParts[a1] then
            self.cachedParts[a1] = nil
            a1.LocalTransparencyModifier = 0
        end
    end)
    self:CachePartsRecursive(a2)
end

function u55.Enable(a1, a2) -- Line: 215 -- types: a1: table, a2: boolean
    if a1.enabled ~= a2 then
        a1.enabled = a2
    end
end

function u55.SetSubject(a1, a2) -- Line: 221 -- upvalues: resolveSubjectCharacter (val), CharacterResolver (val)
    local v1 = resolveSubjectCharacter(a2)
    if v1 and not CharacterResolver.getPlayerFromCharacter(v1) then
        v1 = nil
    end
    if v1 then
        a1:SetupTransparency(v1)
        return
    end
    a1:TeardownTransparency()
end

function u55.Update(a1, a2) -- Line: 233
    -- upvalues: resolveSubjectCharacter (val), CharacterResolver (val), Players (val), CameraUtils (val)
    -- upvalues: VRService (val), u25 (val)
    local CurrentCamera = workspace.CurrentCamera
    if CurrentCamera and a1.enabled then
        local Parent, VREnabled, v1
        local v2 = resolveSubjectCharacter(CurrentCamera.CameraSubject)
        local v3 = CharacterResolver.getLocalCharacter()
        local v4 = false
        if v2 ~= nil then
            v4 = false
            if v3 == v2 then
                v4 = Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson
            end
        end
        local magnitude = (CurrentCamera.Focus.p - CurrentCamera.CoordinateFrame.p).magnitude
        local v5 = magnitude < 2 and 1 - (magnitude - 0.5) / 1.5 or 0
        if v4 then
            v5 = 1
        end
        if v5 < 0.5 then
            v5 = 0
        end
        if a1.lastTransparency and v5 < 1 and a1.lastTransparency < 0.95 then
            local v6 = v5 - a1.lastTransparency
            local v7 = 2.8 * a2
            v6 = math.clamp(v6, -v7, v7)
            v5 = a1.lastTransparency + v6
        end
        v5 = math.clamp(CameraUtils.Round(v5, 2), 0, 1)
        if a1.transparencyDirty then
            VREnabled = VRService.VREnabled and VRService.AvatarGestures
            v1 = a1
            for k, v in pairs(a1.cachedParts) do
                if not VREnabled then
                    k.LocalTransparencyModifier = v5
                else
                    Parent = k.Parent
                    if not Parent or not Parent:IsA("Accessory") then
                        if k.Name ~= "Head" then
                            k.LocalTransparencyModifier = 0
                        else
                            k.LocalTransparencyModifier = v5
                        end
                    elseif u25[Parent.AccessoryType] then
                        k.LocalTransparencyModifier = v5
                    elseif k.Name ~= "Head" then
                        k.LocalTransparencyModifier = 0
                    else
                        k.LocalTransparencyModifier = v5
                    end
                end
            end
            v1.transparencyDirty = false
            v1.lastTransparency = v5
        elseif a1.lastTransparency ~= v5 then
            VREnabled = VRService.VREnabled and VRService.AvatarGestures
            v1 = a1
            for k2, i in pairs(a1.cachedParts) do
                if not VREnabled then
                    k2.LocalTransparencyModifier = v5
                else
                    Parent = k2.Parent
                    if not Parent or not Parent:IsA("Accessory") then
                        if k2.Name ~= "Head" then
                            k2.LocalTransparencyModifier = 0
                        else
                            k2.LocalTransparencyModifier = v5
                        end
                    elseif u25[Parent.AccessoryType] then
                        k2.LocalTransparencyModifier = v5
                    elseif k2.Name ~= "Head" then
                        k2.LocalTransparencyModifier = 0
                    else
                        k2.LocalTransparencyModifier = v5
                    end
                end
            end
            v1.transparencyDirty = false
            v1.lastTransparency = v5
        end
    end
end

return u55