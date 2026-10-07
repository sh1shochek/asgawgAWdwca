-- ReplicatedStorage.Database.Components.Finishers
-- Script path: ReplicatedStorage.Database.Components.Finishers
-- Decompile time: 5.35 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration)
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local LocalPlayer = Players.LocalPlayer
local u32 = {}
local u33 = {}
local u34 = {}

local function GetFinisherModule(a1) -- Line: 41 -- upvalues: u34 (val)
    local v1 = u34[a1.Finisher]
    assert(v1, (("\"%*\" is not a valid member of database.custom.finishers"):format(a1.Finisher)))
    return v1
end

local function findTutorialDummy(a1) -- Line: 51 -- upvalues: IsTutorialMode (val) -- types: a1: number
    if not IsTutorialMode() then
        return nil
    end
    local v1 = a1
    for i, j in workspace:GetChildren() do
        if j.Name ~= "Debris" then
            if j:IsA("Folder") and string.sub(j.Name, 1, 8) == "Tutorial" then
                for k, n in j:GetChildren() do
                    if n:IsA("Model")
                        and n:GetAttribute("TutorialDummy") == true
                        and n:GetAttribute("DummyUserId") == v1 then
                        return n
                    end
                end
            end
            continue
        end
        for m, i5 in j:GetChildren() do
            if i5:IsA("Model")
                and i5:GetAttribute("TutorialDummy") == true
                and i5:GetAttribute("DummyUserId") == v1 then
                return i5
            end
        end
    end
    return nil
end

function u0.ResolveVictimCharacter(a1) -- Line: 72
    -- upvalues: findTutorialDummy (val), ReplicatedStorage (val), Players (val), ClientCharacterPresentation (val)
    -- upvalues: CharacterGeneration (val)
    local v1
    if a1.Generation == 0 then
        return (findTutorialDummy(a1.Victim))
    end
    if a1.Victim <= -1000 then
        v1 = (require(ReplicatedStorage.Controllers.CharacterController.BotCharacters)).TakeCorpse(
            -a1.Victim - 1000,
            a1.Generation,
            a1.Position,
            a1.LookYaw
        )
        if v1 ~= nil and CharacterGeneration.Matches(v1, a1.Generation) then
            v1:PivotTo((CFrame.new(a1.Position)) * (CFrame.Angles(0, a1.LookYaw, 0)))
            v1:SetAttribute("Health", 0)
            v1:SetAttribute("Dead", true)
            return v1
        end
        return nil
    end
    local PlayerByUserId = Players:GetPlayerByUserId(a1.Victim)
    if PlayerByUserId == nil then
        return nil
    end
    v1 = ClientCharacterPresentation.Create(PlayerByUserId, a1.Generation)
    if v1 ~= nil and CharacterGeneration.Matches(v1, a1.Generation) then
        v1:PivotTo((CFrame.new(a1.Position)) * (CFrame.Angles(0, a1.LookYaw, 0)))
        v1:SetAttribute("Health", 0)
        v1:SetAttribute("Dead", true)
        return v1
    end
    return nil
end

function u0.IsFinisherValidForReplication(a1) -- Line: 105 -- upvalues: u34 (val), LocalPlayer (val)
    local v1
    local v2 = u34[a1.Finisher]
    assert(v2, (("\"%*\" is not a valid member of database.custom.finishers"):format(a1.Finisher)))
    local UserId = LocalPlayer.UserId
    if v2.Replication == "Killer" then
        v1 = true
        if a1.Killer ~= UserId then
            if v2.Replication == "Victim" then
                v1 = true
                if a1.Victim ~= UserId then
                    if v2.Replication ~= "Both" then
                        v1 = true
                        if v2.Replication ~= "All" then
                            v1 = false
                        end
                    else
                        v1 = true
                        if a1.Killer ~= UserId then
                            v1 = true
                            if a1.Victim ~= UserId then
                                v1 = true
                                if v2.Replication ~= "All" then
                                    v1 = false
                                end
                            end
                        end
                    end
                end
            elseif v2.Replication ~= "Both" then
                v1 = true
                if v2.Replication ~= "All" then
                    v1 = false
                end
            else
                v1 = true
                if a1.Killer ~= UserId then
                    v1 = true
                    if a1.Victim ~= UserId then
                        v1 = true
                        if v2.Replication ~= "All" then
                            v1 = false
                        end
                    end
                end
            end
        end
    elseif v2.Replication == "Victim" then
        v1 = true
        if a1.Victim ~= UserId then
            if v2.Replication ~= "Both" then
                v1 = true
                if v2.Replication ~= "All" then
                    v1 = false
                end
            else
                v1 = true
                if a1.Killer ~= UserId then
                    v1 = true
                    if a1.Victim ~= UserId then
                        v1 = true
                        if v2.Replication ~= "All" then
                            v1 = false
                        end
                    end
                end
            end
        end
    elseif v2.Replication ~= "Both" then
        v1 = true
        if v2.Replication ~= "All" then
            v1 = false
        end
    else
        v1 = true
        if a1.Killer ~= UserId then
            v1 = true
            if a1.Victim ~= UserId then
                v1 = true
                if v2.Replication ~= "All" then
                    v1 = false
                end
            end
        end
    end
    return v1
end

function u0.ExecuteFinisher(a1) -- Line: 118 -- upvalues: u0 (val), u34 (val), u33 (val), u32 (val)
    if not u0.IsFinisherValidForReplication(a1) then
        return
    end
    local u7 = u34[a1.Finisher]
    assert(u7, (("\"%*\" is not a valid member of database.custom.finishers"):format(a1.Finisher)))
    local success, result = pcall(function() -- Line: 124 -- upvalues: u0 (upval), a1 (val), u33 (upval), u32 (upval), u7 (val)
        local v1
        local v2 = u0.ResolveVictimCharacter(a1)
        if not v2 then
            warn((("Failed to execute finisher \"%*\": missing victim character \"%*\""):format(a1.Finisher, a1.Victim)))
            return nil
        end
        v2.Archivable = true
        local u42 = tostring(a1.Victim)
        local v3 = u33[u42]
        if v3 then
            v3.Destroy()
        end
        while true do
            if not (#u32 >= 8) then
                break
            end
            v1 = table.remove(u32, 1)
            if v1 then
                v1.Destroy()
            end
        end
        local u39 = u7.Finisher(v2, a1)
        local u40 = {Name = u42}

        function u40.Destroy() -- Line: 152 -- upvalues: u33 (upval), u42 (val), u39 (val)
            u33[u42] = nil
            u39.Destroy()
        end

        u33[u42] = u39
        table.insert(u32, u40)
        u39.OnDestroy:Once(function() -- Line: 161 -- upvalues: u32 (upval), u40 (val)
            local v1 = table.find(u32, u40)
            if v1 then
                table.remove(u32, v1)
            end
        end)
    end)
    if not success then
        warn((("Failed to execute finisher \"%*\": %*"):format(a1.Finisher, result)))
    end
end

for i, v in ipairs(ReplicatedStorage.Database.Custom.Finishers:GetChildren()) do
    if v:IsA("ModuleScript") then
        u34[v.Name] = (require(v))
    end
end
return u0