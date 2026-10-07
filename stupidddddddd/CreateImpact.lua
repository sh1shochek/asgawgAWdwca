-- ReplicatedStorage.Components.Common.VFXLibary.CreateImpact
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateImpact
-- Decompile time: 6.80 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local Sound = require(ReplicatedStorage.Classes.Sound)
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool)
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local Materials = require(script.Components.Materials)
local Impacts = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Impacts")
local Debris = workspace:WaitForChild("Debris")
local u66 = {}
local u67 = {}

local function hasParticleEmitter(a1) -- Line: 46 -- types: a1: userdata
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            return true
        end
    end
    return false
end

local function getImpactTemplates(a1) -- Line: 55 -- upvalues: u66 (val), hasParticleEmitter (val)
    local v1 = u66[a1]
    if v1 then
        return v1
    end
    local v2 = {}
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("BasePart") and hasParticleEmitter(v) then
            v2[#v2 + 1] = v
        end
    end
    u66[a1] = v2
    return v2
end

local function resetImpactMarker(a1) -- Line: 71 -- types: a1: userdata
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v:Clear()
        end
    end
end

local function getImpactPool(a1) -- Line: 79
    -- upvalues: u67 (val), ObjectPool (val), resetImpactMarker (val)
    local v1 = u67[a1]
    if v1 then
        return v1
    end
    local v2 = ObjectPool.new(a1, {InitialSize = 2, MaxRetained = 60, Reset = resetImpactMarker})
    u67[a1] = v2
    return v2
end

local function createImpactMarker(a1) -- Line: 94
    -- upvalues: getImpactTemplates (val), u67 (val), ObjectPool (val), resetImpactMarker (val)
    local v1, v2
    debug.profilebegin("VFX.Impact.CreateImpactMarker")
    local v3 = getImpactTemplates(a1)
    if #v3 == 0 then
        debug.profileend()
        return nil, nil, nil
    end
    local v4 = v3[math.random(1, #v3)]
    local v5 = u67[v4]
    if not v5 then
        v2 = ObjectPool.new(v4, {InitialSize = 2, MaxRetained = 60, Reset = resetImpactMarker})
        u67[v4] = v2
        v1 = v2
    else
        v1 = v5
    end
    v5, v2 = v1:Acquire()
    v5.CollisionGroup = "Debris"
    v5.CanCollide = false
    v5.CanQuery = false
    v5.CanTouch = false
    v5.Anchored = true
    debug.profileend()
    return v5, v1, v2
end

local function IsHeadPart(a1) -- Line: 117 -- types: a1: userdata?
    if a1 and a1:IsA("BasePart") then
        return string.find(string.lower(a1.Name), "head", 1, true) ~= nil
    end
    return false
end

local function IsHeadImpact(a1, a2) -- Line: 126 -- types: a1: userdata?, a2: string
    if a2 ~= "Blood Splatter" then
        return false
    end
    if a1 and a1:IsA("BasePart") then
        return string.find(string.lower(a1.Name), "head", 1, true) ~= nil
    end
    return false
end

local function decodeArmor(a1) -- Line: 130 -- upvalues: HttpService (val)
    if typeof(a1) == "string" and a1 ~= "" then
        local success, result = pcall(HttpService.JSONDecode, HttpService, a1)
        if success and typeof(result) == "table" then
            return result
        end
        return nil
    end
    return nil
end

return function(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) -- Line: 140
    -- upvalues: Players (val), Impacts (val), Materials (val), Participants (val), HttpService (val)
    -- upvalues: CharacterResolver (val), FlashEffect (val), DebugFlags (val), Sound (val), createImpactMarker (val)
    -- upvalues: Debris (val)
    debug.profilebegin("VFX.Impact")
    if a2 == "Blood Splatter" and Players.LocalPlayer:GetAttribute("SK") then
        a2 = "Blood Splatter_SK"
    end
    local v1 = Impacts:FindFirstChild(Materials[a2] or a2)
    if v1 then
        local v2, v3, v4
        local v5 = false
        if a2 == "Blood Splatter" then
            v5 = if not a1 then false else if a1:IsA("BasePart") then string.find(string.lower(a1.Name), "head", 1, true) ~= nil else false
        end
        if not v5 then
            v5 = a10 ~= nil
        end
        local v6 = a10 == true
        debug.profilebegin("VFX.Impact.ResolveSound")
        local Name = v1.Name
        if v5 then
            Name = "Headshot"
            if a1 and not a6 and a10 == nil then
                local v7, v8
                v2 = a1:FindFirstAncestorOfClass("Model")
                local Attribute = if not v2 then nil else if v2:GetAttribute("Bot") ~= true then nil else v2:GetAttribute("CombatantId")
                if typeof(Attribute) == "number" then
                    v3 = Participants.FromKey(Participants.BotKey(Attribute))
                    if not v3 then
                        v7 = nil
                    else
                        local Attribute_2 = v3:GetAttribute("Armor")
                        if typeof(Attribute_2) ~= "string" then
                            v7 = nil
                        elseif Attribute_2 ~= "" then
                            local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute_2)
                            v7 = if not success then nil else if typeof(result) ~= "table" then nil else result
                        else
                            v7 = nil
                        end
                    end
                    v8 = false
                    if v7 ~= nil then
                        v8 = v7.Type == "Kevlar + Helmet"
                    end
                    v6 = v8
                elseif CharacterResolver.isPlayerCharacter(v2) then
                    v8 = workspace
                    if v2:IsDescendantOf(v8) then
                        v3 = CharacterResolver.getPlayerFromCharacter(v2)
                        if v3 and v3:IsDescendantOf(Players) then
                            local Attribute_3 = v3:GetAttribute("Armor")
                            if typeof(Attribute_3) ~= "string" then
                                v7 = nil
                            elseif Attribute_3 ~= "" then
                                local success_2, result_2 = pcall(HttpService.JSONDecode, HttpService, Attribute_3)
                                v7 = if not success_2 then nil else if typeof(result_2) ~= "table" then nil else result_2
                            else
                                v7 = nil
                            end
                            v8 = false
                            if v7 ~= nil then
                                v8 = v7.Type == "Kevlar + Helmet"
                            end
                            v6 = v8
                        end
                    end
                end
            end
            if v6 then
                Name = "Helmet Headshot"
            end
        end
        v2 = CharacterResolver.getCutoutBoard(a1)
        if v2 then
            Name = if not CharacterResolver.isCutoutHeadshot(v2, a3) then "Blood Splatter" else "Helmet Headshot"
        end
        debug.profileend()
        if a5 then
            if DebugFlags.IsEnabled("WeaponFX") then
                warn(("[WeaponFX][Client][ImpactSound] skipped material=%s pos=%s exit=%s suppressed=%s"):format(
                    tostring(a2),
                    tostring(a3),
                    tostring(a5),
                    (tostring(a12 == true))
                ))
            end
        elseif a12 ~= true then
            debug.profilebegin("VFX.Impact.PlaySound")
            local v9 = FlashEffect.IsFlashed()
            v3 = if not v9 then 1 else 0
            if DebugFlags.IsEnabled("WeaponFX") then
                warn(("[WeaponFX][Client][ImpactSound] play material=%s sound=%s pos=%s flashed=%s exit=%s melee=%s volumeMult=%s"):format(
                    tostring(a2),
                    tostring(Name),
                    tostring(a3),
                    tostring(v9),
                    tostring(a5),
                    tostring(a6),
                    (tostring(v3))
                ))
            end
            local Bullet = Sound.new("Bullet")
            v4 = a9 == true
            Bullet:PlaySoundAtPosition({Class = "Bullet", Position = a3, Name = Name}, nil, v3, a7 == true, v4)
            debug.profileend()
        elseif DebugFlags.IsEnabled("WeaponFX") then
            warn(("[WeaponFX][Client][ImpactSound] skipped material=%s pos=%s exit=%s suppressed=%s"):format(
                tostring(a2),
                tostring(a3),
                tostring(a5),
                (tostring(a12 == true))
            ))
        end
        if a2 == "Blood Splatter" and v6 then
            v1 = Impacts:FindFirstChild("Helmet Headshot") or v1
        end
        if a2 ~= "Blood Splatter" and a6 then
            debug.profileend()
            return
        end
        if a11 ~= true then
            local u530, u531, u532 = createImpactMarker(v1)
            if u530 and u531 and u532 then
                debug.profilebegin("VFX.Impact.ParentMarker")
                if not v5 or a2 ~= "Blood Splatter" or not a1 or not a1:IsA("BasePart") then
                    u530.CFrame = (CFrame.new(a3, a3 + a4)) + a4 * 0.1
                else
                    u530.CFrame = CFrame.new(a1.Position, a1.Position + Vector3.new(0, 1, 0))
                end
                u530.Parent = Debris
                u530.Transparency = 1
                debug.profileend()
                debug.profilebegin("VFX.Impact.EmitParticles")
                for i, v in ipairs(u530:GetDescendants()) do
                    if v:IsA("ParticleEmitter") then
                        v4 = v:GetAttribute("EmitDelay") or 0
                        local u665 = v:GetAttribute("EmitCount") or 1
                        if not (v4 <= 0) then
                            task.delay(v4, function() -- Line: 271 -- upvalues: u530 (val), v (val), u531 (val), u532 (val), u665 (val)
                                if u530.Parent and v.Parent and u531:IsAcquired(u530, u532) then
                                    v:Emit(u665)
                                end
                            end)
                        else
                            v:Emit(u665)
                        end
                    end
                end
                debug.profileend()
                task.delay(5, function() -- Line: 285 -- upvalues: u531 (val), u530 (val), u532 (val)
                    u531:Release(u530, u532)
                end)
                debug.profileend()
                return
            end
            debug.profileend()
            return
        end
    end
    debug.profileend()
end