-- ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Character
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Character
-- Decompile time: 3.07 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam)
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration)
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local EmitParticles = require(script.Parent.EmitParticles)

local function executeMuzzleFlash(a1, a2) -- Line: 19
    -- upvalues: EmitParticles (val)
    debug.profilebegin("VFX.MuzzleFlash.Character.Execute")
    local v1 = a1:FindFirstChild(a2)
    if not v1 then
        debug.profileend()
        return nil
    end
    debug.profilebegin("VFX.MuzzleFlash.Character.EmitParticles")
    EmitParticles(v1)
    debug.profileend()
    debug.profileend()
    return a1.Position
end

local function dlog(a1, ...) -- Line: 34 -- upvalues: DebugFlags (val) -- types: a1: string
    if not DebugFlags.IsEnabled("WeaponFX") then
        return
    end
    warn(("[WeaponFX][MuzzleFlash.Character] " .. a1):format(...))
end

local function findTutorialDummy(a1) -- Line: 42 -- upvalues: IsTutorialMode (val) -- types: a1: number
    if not IsTutorialMode() then
        return nil
    end
    for i, j in workspace:GetChildren() do
        if j:IsA("Folder") and string.sub(j.Name, 1, 8) == "Tutorial" then
            for k, n in j:GetChildren() do
                if n:IsA("Model")
                    and n:GetAttribute("TutorialDummy") == true
                    and n:GetAttribute("DummyUserId") == a1 then
                    return n
                end
            end
        end
    end
    return nil
end

local function findDummyWeaponModel(a1, a2) -- Line: 59 -- types: a1: userdata, a2: string
    local v1 = a1:FindFirstChild(a2)
    if v1 and v1:IsA("Model") then
        return v1
    end
    for i, j in a1:GetChildren() do
        if j:IsA("Model") and j:FindFirstChild("Interactables") then
            return j
        end
    end
    return nil
end

return function(a1, a2, a3, a4, a5, a6) -- Line: 72
    -- upvalues: Players (val), findTutorialDummy (val), dlog (val), GetWeaponProperties (val)
    -- upvalues: ClientCharacterPresentation (val), CharacterGeneration (val), findDummyWeaponModel (val)
    -- upvalues: CreateZeusBeam (val), executeMuzzleFlash (val)
    local Interactables, MuzzlePart, MuzzleType, v1
    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate")
    local PlayerByUserId = Players:GetPlayerByUserId(a1)
    local v2 = if not PlayerByUserId then findTutorialDummy(a1) else nil
    if not PlayerByUserId and not v2 then
        dlog("player not found userId=%s weapon=%s", tostring(a1), (tostring(a3)))
        debug.profileend()
        return
    end
    local Name = if not PlayerByUserId then v2.Name else PlayerByUserId.Name
    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.GetWeaponProperties")
    local v3 = GetWeaponProperties(a3)
    debug.profileend()
    if not v3 then
        dlog("weapon properties missing player=%s weapon=%s", Name, (tostring(a3)))
        debug.profileend()
        return
    end
    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.FindWeaponModel")
    if not PlayerByUserId then
        v1 = findDummyWeaponModel(v2, a3)
        debug.profileend()
        if not v1 then
            dlog("missing equipped presentation player=%s weapon=%s", Name, (tostring(a3)))
            debug.profileend()
            return
        end
        debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.FindMuzzlePart")
        Interactables = v1:FindFirstChild("Interactables")
        if not Interactables then
            dlog("missing Interactables player=%s weapon=%s", Name, (tostring(a3)))
            debug.profileend()
            debug.profileend()
            return
        end
        MuzzlePart = Interactables:FindFirstChild("MuzzlePart")
        if v3.ShootingOptions == "Dual" then
            MuzzlePart = Interactables:FindFirstChild("MuzzlePart" .. (if a4 ~= "Left" then "R" else "L"))
        end
        if not MuzzlePart then
            dlog("missing muzzle part player=%s weapon=%s shootingHand=%s", Name, tostring(a3), (tostring(a4)))
            debug.profileend()
            debug.profileend()
            return
        end
        debug.profileend()
        if v3.MuzzleType == "Zeus x27" then
            debug.profilebegin("VFX.MuzzleFlash.Character.CreateZeusBeam")
            CreateZeusBeam(MuzzlePart)
            debug.profileend()
        end
        if a6 then
            debug.profileend()
            return
        end
        MuzzleType = a5 or v3.MuzzleType
        if not MuzzleType then
            debug.profileend()
            return
        end
        if not executeMuzzleFlash(MuzzlePart, MuzzleType) then
            dlog("executeMuzzleFlash failed player=%s weapon=%s override=%s", Name, tostring(a3), (tostring(a5)))
        end
        debug.profileend()
        return
    end
    local v4 = ClientCharacterPresentation.Create(PlayerByUserId, a2)
    if v4 and CharacterGeneration.Matches(v4, a2) then
        local WeaponModel = v4:FindFirstChild("WeaponModel")
        local Equipped = WeaponModel and WeaponModel:FindFirstChild("Equipped")
        v1 = if not Equipped then nil else if not Equipped:IsA("Model") then nil else Equipped
        debug.profileend()
        if not v1 then
            dlog("missing equipped presentation player=%s weapon=%s", Name, (tostring(a3)))
            debug.profileend()
            return
        end
        debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.FindMuzzlePart")
        Interactables = v1:FindFirstChild("Interactables")
        if not Interactables then
            dlog("missing Interactables player=%s weapon=%s", Name, (tostring(a3)))
            debug.profileend()
            debug.profileend()
            return
        end
        MuzzlePart = Interactables:FindFirstChild("MuzzlePart")
        if v3.ShootingOptions == "Dual" then
            MuzzlePart = Interactables:FindFirstChild("MuzzlePart" .. (if a4 ~= "Left" then "R" else "L"))
        end
        if not MuzzlePart then
            dlog("missing muzzle part player=%s weapon=%s shootingHand=%s", Name, tostring(a3), (tostring(a4)))
            debug.profileend()
            debug.profileend()
            return
        end
        debug.profileend()
        if v3.MuzzleType == "Zeus x27" then
            debug.profilebegin("VFX.MuzzleFlash.Character.CreateZeusBeam")
            CreateZeusBeam(MuzzlePart)
            debug.profileend()
        end
        if a6 then
            debug.profileend()
            return
        end
        MuzzleType = a5 or v3.MuzzleType
        if not MuzzleType then
            debug.profileend()
            return
        end
        if not executeMuzzleFlash(MuzzlePart, MuzzleType) then
            dlog("executeMuzzleFlash failed player=%s weapon=%s override=%s", Name, tostring(a3), (tostring(a5)))
        end
        debug.profileend()
        return
    end
    dlog("presentation missing player=%s generation=%s weapon=%s", Name, tostring(a2), (tostring(a3)))
    debug.profileend()
    debug.profileend()
end