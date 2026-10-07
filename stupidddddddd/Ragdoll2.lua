-- ReplicatedStorage.Classes.Ragdoll
-- Script path: ReplicatedStorage.Classes.Ragdoll
-- Decompile time: 27.04 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
require(script:WaitForChild("Types"))
local Rig = require(script:WaitForChild("Rig"))
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Signal = require(ReplicatedStorage.Packages.Signal)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local u52 = {}
u52.__index = u52
local Debris = workspace:WaitForChild("Debris")
local u63 = math.clamp(Players.MaxPlayers * 2, 4, 24)
local u68 = CFrame.new(0, -100, 0)
local u69 = {}
local u70 = {}
local u71 = {}
local u72 = {}
local u73 = {}
local u74 = {}
local u78 = setmetatable({}, {__mode = "k"})
local u79 = {}
local u80 = 1
local u81 = false
local u85 = setmetatable({}, {__mode = "k"})
local u89 = setmetatable({}, {__mode = "k"})
local u90 = {}
local u91 = {}
local u92 = {}
local u93 = {}
local u97 = setmetatable({}, {__mode = "k"})
local u98 = {}
local u99 = 0
local u100 = 0
local u101 = true
local u102 = nil
local u104 = {AnimationController = true, CharacterModel = true, WeaponAttachments = true, WeaponModel = true}
local u105 = {RagdollReady = true, RagdollStaged = true}
local u106 = {
    Dead = true,
    Ragdolled = true,
    RagdollCreatedAt = true,
    PreparedRagdoll = true,
    ClientRagdoll = true,
}

local function profileScope(a1, a2) -- Line: 93 -- types: a1: string, a2: function
    debug.profilebegin(a1)
    local success, result = pcall(a2)
    debug.profileend()
    if not success then
        error(result, 0)
    end
    return result
end

local function startPreparationStageWorker() -- Line: 103 -- upvalues: u81 (ref), u80 (ref), u79 (val), RunService (val)
    if u81 then
        return
    end
    u81 = true
    task.spawn(function() -- Line: 109 -- upvalues: u80 (upval), u79 (upval), RunService (upval), u81 (upval)
        local result, success, v1
        while u80 <= #u79 do
            RunService.Heartbeat:Wait()
            v1 = u79[u80]
            u80 = u80 + 1
            success, result = pcall(v1.Callback)
            v1.Succeeded = success
            v1.Result = result
            v1.Completed = true
        end
        table.clear(u79)
        u80 = 1
        u81 = false
    end)
end

local function runPreparationStage(a1) -- Line: 127
    -- upvalues: u79 (val), u81 (ref), u80 (ref), RunService (val)
    local v1 = {Completed = false, Succeeded = false, Callback = a1}
    table.insert(u79, v1)
    if not u81 then
        u81 = true
        task.spawn(function() -- Line: 109 -- upvalues: u80 (upval), u79 (upval), RunService (upval), u81 (upval)
            local result, success, v1
            while u80 <= #u79 do
                RunService.Heartbeat:Wait()
                v1 = u79[u80]
                u80 = u80 + 1
                success, result = pcall(v1.Callback)
                v1.Succeeded = success
                v1.Result = result
                v1.Completed = true
            end
            table.clear(u79)
            u80 = 1
            u81 = false
        end)
    end
    while not v1.Completed do
        RunService.Heartbeat:Wait()
    end
    if not v1.Succeeded then
        error(v1.Result, 0)
    end
    return v1.Result
end

local function isVisualEffect(a1) -- Line: 146 -- types: a1: userdata
    return a1:IsA("ParticleEmitter") or a1:IsA("Trail") or a1:IsA("Beam") or a1:IsA("Fire") or a1:IsA("Smoke") or a1:IsA("Sparkles")
end

local function isExcludedRagdollContent(a1) -- Line: 155 -- upvalues: u104 (val) -- types: a1: userdata
    local v1 = true
    if u104[a1.Name] ~= true then
        v1 = a1:IsA("AnimationController") or a1:IsA("Script") or a1:IsA("LocalScript") or a1:IsA("ModuleScript") or a1:IsA("BillboardGui") or a1:IsA("SurfaceGui") or a1:IsA("Highlight") or a1:IsA("ProximityPrompt") or a1:IsA("ClickDetector")
    end
    return v1
end

local function markNonArchivableRagdollContent(a1) -- Line: 168
    -- upvalues: isExcludedRagdollContent (val), u89 (val)
    for i, j in a1:GetDescendants() do
        if isExcludedRagdollContent(j) then
            j.Archivable = false
        end
    end
    u89[a1] = true
end

local function getRagdollLifetime() -- Line: 177 -- upvalues: GameState (val)
    local v1 = false
    if GameState.GetState() == "Warmup" then
        v1 = workspace:GetAttribute("Gamemode") == "Deathmatch"
    end
    if v1 then
        return 10
    end
    return 15
end

local function cleanupAttachments(a1) -- Line: 182 -- types: a1: userdata
    local CharacterModel = a1:FindFirstChild("CharacterModel")
    if CharacterModel then
        CharacterModel:Destroy()
    end
end

local function getSourceCharacter(a1) -- Line: 189 -- upvalues: u71 (val) -- types: a1: userdata
    return u71[a1] or a1
end

local function destroyLocalCorpse(a1) -- Line: 193 -- upvalues: u70 (val), u71 (val), u102 (ref) -- types: a1: userdata
    local v1 = u70[a1]
    u70[a1] = nil
    if v1 then
        u71[v1] = nil
        u102(v1)
    end
end

local function destroyPreparedCorpse(a1) -- Line: 203
    -- upvalues: u74 (val), u102 (ref), u72 (val)
    local v1 = u74[a1]
    u74[a1] = nil
    if v1 then
        v1.Cancelled = true
        local Corpse = v1.Corpse
        v1.Corpse = nil
        if Corpse then
            u102(Corpse)
        end
    end
    local v2 = u72[a1]
    u72[a1] = nil
    if v2 then
        u102(v2)
    end
end

local function disconnectPreparationCleanup(a1) -- Line: 222 -- upvalues: u73 (val) -- types: a1: userdata
    local v1 = u73[a1]
    u73[a1] = nil
    if v1 then
        v1:Disconnect()
    end
end

local function clearCorpseDeathState(a1) -- Line: 230 -- upvalues: CollectionService (val) -- types: a1: userdata
    a1:SetAttribute("PreparedRagdoll", true)
    a1:SetAttribute("Dead", nil)
    a1:SetAttribute("Ragdolled", nil)
    a1:SetAttribute("RagdollCreatedAt", nil)
    CollectionService:RemoveTag(a1, "Ragdoll")
end

local function markCorpseAsPrepared(a1, a2) -- Line: 239
    -- upvalues: clearCorpseDeathState (val)
    a2.Name = ("__PreparedRagdoll_%*"):format(a1.Name)
    a2:SetAttribute("ClientRagdoll", true)
    clearCorpseDeathState(a2)
end

local function configureCorpseClone(a1, a2) -- Line: 245
    -- upvalues: clearCorpseDeathState (val), isVisualEffect (val), u78 (val)
    local Part0, Part1
    a2.Name = ("__PreparedRagdoll_%*"):format(a1.Name)
    a2:SetAttribute("ClientRagdoll", true)
    clearCorpseDeathState(a2)
    local v1 = {}
    local v2 = {}
    local v3 = a2
    for i, j in a2:GetDescendants() do
        if j:IsA("BasePart") or j:IsA("Decal") then
            j.LocalTransparencyModifier = 1
            table.insert(v1, j)
        elseif isVisualEffect(j) or j:IsA("Light") then
            table.insert(v2, {Instance = j, Enabled = j.Enabled})
            j.Enabled = false
        end
        if j:IsA("Motor6D") or j:IsA("Weld") or j:IsA("WeldConstraint") then
            Part0 = j.Part0
            Part1 = j.Part1
            if not Part0 then
                if Part1 and not Part1:IsDescendantOf(v3) then
                    j:Destroy()
                end
            elseif not Part0:IsDescendantOf(v3) or Part1 and not Part1:IsDescendantOf(v3) then
                j:Destroy()
            end
        elseif j:IsA("Highlight") then
            j:Destroy()
        end
    end
    u78[v3] = {Effects = v2, Renderables = v1}
end

local function setCorpseVisible(a1, a2) -- Line: 281 -- upvalues: u78 (val) -- types: a1: userdata, a2: boolean
    local v1 = u78[a1]
    if not v1 then
        return
    end
    local v2 = if not a2 then 1 else 0
    for i, j in v1.Renderables do
        if j.Parent then
            j.LocalTransparencyModifier = v2
        end
    end
    local v3 = nil
    local v4 = nil
    for k, n in v1.Effects, v3, v4 do
        if n.Instance.Parent then
            n.Instance.Enabled = a2 and n.Enabled
        end
    end
end

local function getCorpsePoolKey(a1) -- Line: 299 -- upvalues: CharacterResolver (val) -- types: a1: userdata
    local v1 = CharacterResolver.getPlayerFromCharacter(a1)
    local Name = if not v1 then a1.Name else tostring(v1.UserId)
    local Attribute = a1:GetAttribute("CharacterName")
    local Attribute_2 = a1:GetAttribute("EquippedGloves")
    local concat = table.concat
    local v2 = {}
    local v3 = tostring(Attribute or "")
    v2[1] = Name
    v2[2] = v3
    v2[3] = (tostring(Attribute_2 or ""))
    return concat(v2, "\000")
end

local function syncCorpseAppearance(a1, a2) -- Line: 307
    -- upvalues: u105 (val), u106 (val), clearCorpseDeathState (val)
    local v1
    local v2, v3 = a2, a1
    for i, j in a1:GetChildren() do
        v1 = v2:FindFirstChild(j.Name)
        if not j:IsA("BasePart") or not v1 or not v1:IsA("BasePart") then
            if j:IsA("BodyColors") and v1 and v1:IsA("BodyColors") then
                v1.HeadColor3 = j.HeadColor3
                v1.LeftArmColor3 = j.LeftArmColor3
                v1.LeftLegColor3 = j.LeftLegColor3
                v1.RightArmColor3 = j.RightArmColor3
                v1.RightLegColor3 = j.RightLegColor3
                v1.TorsoColor3 = j.TorsoColor3
            end
        elseif v1.Color ~= j.Color then
            v1.Color = j.Color
        end
    end
    for k in v2:GetAttributes() do
        if not u105[k] then
            v2:SetAttribute(k, nil)
        end
    end
    for n, m in v3:GetAttributes() do
        if not u105[n] and not u106[n] then
            v2:SetAttribute(n, m)
        end
    end
    v2.Name = ("__PreparedRagdoll_%*"):format(v3.Name)
    v2:SetAttribute("ClientRagdoll", true)
    clearCorpseDeathState(v2)
end

local function removePoolMembership(a1) -- Line: 339
    -- upvalues: u93 (val), u90 (val), u92 (val), u91 (val), u99 (ref)
    u93[a1] = nil
    local v1 = u90[a1]
    u90[a1] = nil
    if not v1 then
        return
    end
    local v2 = u92[v1]
    if v2 then
        for i = #v2, 1, -1 do
            if v2[i] == a1 then
                table.remove(v2, i)
            end
        end
        if #v2 == 0 then
            u92[v1] = nil
        end
    end
    local v3 = (u91[v1] or 1) - 1
    u91[v1] = if not (v3 > 0) then nil else v3
    u99 = math.max(0, u99 - 1)
end

local function u126(a1) -- Line: 364
    -- upvalues: removePoolMembership (val), u97 (val), u71 (val), u78 (val), CollectionService (val)
    removePoolMembership(a1)
    u97[a1] = nil
    u71[a1] = nil
    u78[a1] = nil
    CollectionService:RemoveTag(a1, "Ragdoll")
    a1:Destroy()
end

local function registerPoolMember(a1, a2) -- Line: 373
    -- upvalues: u90 (val), u91 (val), u99 (ref), u63 (val)
    local v1 = u90[a1]
    if v1 then
        return v1 == a2
    end
    if 2 <= (u91[a2] or 0) or u63 <= u99 then
        return false
    end
    u90[a1] = a2
    u91[a2] = (u91[a2] or 0) + 1
    u99 = u99 + 1
    return true
end

local function parkCorpse(a1) -- Line: 392 -- upvalues: u68 (val) -- types: a1: userdata
    debug.profilebegin("Ragdoll.Pool.Park")
    local success, result = pcall(function() -- Line: 393 -- upvalues: a1 (val), u68 (upval)
        a1:PivotTo(u68)
    end)
    debug.profileend()
    if not success then
        error(result, 0)
    end
end

function u102(a1) -- Line: 398
    -- upvalues: u97 (val), u90 (val), Debris (val), Rig (val), u126 (ref), u93 (val), setCorpseVisible (val)
    -- upvalues: clearCorpseDeathState (val), u68 (val), u92 (val)
    if not u97[a1] and u90[a1] and a1.Parent == Debris and Rig.ResetPrepared(a1) then
        if u93[a1] then
            return
        end
        setCorpseVisible(a1, false)
        a1.Name = "__PooledRagdoll"
        clearCorpseDeathState(a1)
        debug.profilebegin("Ragdoll.Pool.Park")
        local success, result = pcall(function() -- Line: 393 -- upvalues: a1 (val), u68 (upval)
            a1:PivotTo(u68)
        end)
        debug.profileend()
        if not success then
            error(result, 0)
        end
        local v1 = u90[a1]
        local v2 = u92[v1]
        if not v2 then
            u92[v1] = {}
        end
        u93[a1] = true
        table.insert(v2, a1)
        return
    end
    u126(a1)
end

local function acquirePooledCorpse(a1, a2) -- Line: 427
    -- upvalues: u92 (val), u93 (val), Debris (val), u90 (val), u97 (val), Rig (val), u126 (ref)
    -- upvalues: syncCorpseAppearance (val), setCorpseVisible (val), u68 (val)
    local result, success, v1
    local v2 = u92[a2]
    local v3 = a2
    while v2 do
        if not (#v2 > 0) then
            break
        end
        local u9 = table.remove(v2)
        if #v2 == 0 then
            u92[v3] = nil
        end
        if u93[u9] then
            u93[u9] = nil
            if u9.Parent == Debris and u90[u9] == v3 and not u97[u9] and Rig.ResetPrepared(u9) then
                syncCorpseAppearance(v1, u9)
                setCorpseVisible(u9, false)
                debug.profilebegin("Ragdoll.Pool.Park")
                success, result = pcall(function() -- Line: 393 -- upvalues: u9 (val), u68 (upval)
                    u9:PivotTo(u68)
                end)
                debug.profileend()
                if not success then
                    error(result, 0)
                end
                return u9
            end
            u126(u9)
        end
    end
    return nil
end

local function ensurePreparationCleanup(a1) -- Line: 456
    -- upvalues: u73 (val), u74 (val), u102 (ref), u72 (val)
    if u73[a1] then
        return
    end
    u73[a1] = (a1.AncestryChanged:Connect(function(a1_2, a2) -- Line: 461 -- upvalues: a1 (val), u74 (upval), u102 (upval), u72 (upval), u73 (upval)
        if a2 ~= nil then
            return
        end
        local v1 = a1
        local v2 = u74[v1]
        u74[v1] = nil
        if v2 then
            v2.Cancelled = true
            local Corpse = v2.Corpse
            v2.Corpse = nil
            if Corpse then
                u102(Corpse)
            end
        end
        local v3 = u72[v1]
        u72[v1] = nil
        if v3 then
            u102(v3)
        end
        v1 = a1
        v2 = u73[v1]
        u73[v1] = nil
        if v2 then
            v2:Disconnect()
        end
    end))
end

local function canPrepareSource(a1) -- Line: 470 -- upvalues: u101 (ref), u85 (val) -- types: a1: userdata
    local v1 = u101
    if v1 then
        v1 = false
        if a1.Parent ~= nil then
            v1 = false
            if a1:GetAttribute("ClientRagdoll") ~= true then
                v1 = false
                if a1:GetAttribute("Dead") ~= true then
                    v1 = not u85[a1]
                end
            end
        end
    end
    return v1
end

local function canPrewarmReserve() -- Line: 478 -- upvalues: GameState (val), u101 (ref)
    local v1 = GameState.GetState()
    local v2 = u101
    if v2 then
        v2 = true
        if v1 ~= "Warmup" then
            v2 = v1 == "Buy Period"
        end
    end
    return v2
end

local function isPreparationCurrent(a1, a2) -- Line: 483
    -- upvalues: u74 (val), u101 (ref), u85 (val)
    local v1 = false
    if u74[a1] == a2 then
        v1 = not a2.Cancelled
        if v1 then
            v1 = u101
            if v1 then
                v1 = false
                if a1.Parent ~= nil then
                    v1 = false
                    if a1:GetAttribute("ClientRagdoll") ~= true then
                        v1 = false
                        if a1:GetAttribute("Dead") ~= true then
                            v1 = not u85[a1]
                        end
                    end
                end
            end
        end
    end
    return v1
end

local function cloneCorpse(a1, a2, a3) -- Line: 489
    -- upvalues: configureCorpseClone (val)
    if a1.Parent and a1:GetAttribute("ClientRagdoll") ~= true then
        a1.Archivable = true
        debug.profilebegin(a2)
        local success, result = pcall(function() -- Line: 495 -- upvalues: a1 (val)
            return a1:Clone()
        end)
        debug.profileend()
        if not success then
            error(result, 0)
        end
        local u24 = result
        debug.profilebegin(a3)
        local success_2, result_2 = pcall(function() -- Line: 498 -- upvalues: configureCorpseClone (upval), a1 (val), u24 (val)
            configureCorpseClone(a1, u24)
        end)
        debug.profileend()
        if not success_2 then
            error(result_2, 0)
        end
        return u24
    end
    return nil
end

local function scheduleReservePrewarm(a1, a2) -- Line: 504
    -- upvalues: GameState (val), u101 (ref), u91 (val), u98 (val), u100 (ref), CharacterResolver (val), Players (val)
    -- upvalues: runPreparationStage (val), u85 (val), u89 (val), isExcludedRagdollContent (val), cloneCorpse (val)
    -- upvalues: Rig (val), u68 (val), u90 (val), u99 (ref), u63 (val), Debris (val), u102 (ref), u126 (ref)
    local v1 = GameState.GetState()
    local v2 = u101
    if v2 then
        v2 = true
        if v1 ~= "Warmup" then
            v2 = v1 == "Buy Period"
        end
    end
    if v2 and not (2 <= (u91[a2] or 0)) and u98[a2] == nil then
        local u17 = u100
        u98[a2] = u17
        local u23 = CharacterResolver.getPlayerFromCharacter(a1)

        local function isStale() -- Line: 516
            -- upvalues: u17 (val), u100 (upval), u23 (val), Players (upval), GameState (upval), u101 (upval)
            local v1 = true
            if u17 == u100 then
                local v2, v3
                if u23 == nil then
                    v3 = GameState.GetState()
                    v2 = u101
                    if v2 then
                        v2 = true
                        if v3 ~= "Warmup" then
                            v2 = v3 == "Buy Period"
                        end
                    end
                    v1 = not v2
                else
                    v1 = true
                    if u23.Parent == Players then
                        v3 = GameState.GetState()
                        v2 = u101
                        if v2 then
                            v2 = true
                            if v3 ~= "Warmup" then
                                v2 = v3 == "Buy Period"
                            end
                        end
                        v1 = not v2
                    end
                end
            end
            return v1
        end

        task.spawn(function() -- Line: 519
            -- upvalues: runPreparationStage (upval), u17 (val), u100 (upval), u23 (val), Players (upval)
            -- upvalues: GameState (upval), u101 (upval), a1 (val), u85 (upval), u89 (upval)
            -- upvalues: isExcludedRagdollContent (upval), cloneCorpse (upval), Rig (upval), u91 (upval), a2 (val)
            -- upvalues: u68 (upval), u90 (upval), u99 (upval), u63 (upval), Debris (upval), u102 (upval), u126 (upval)
            -- upvalues: u98 (upval)
            local u0 = nil
            local success, result = pcall(function() -- Line: 521
                -- upvalues: runPreparationStage (upval), u17 (upval), u100 (upval), u23 (upval), Players (upval)
                -- upvalues: GameState (upval), u101 (upval), a1 (upval), u85 (upval), u89 (upval)
                -- upvalues: isExcludedRagdollContent (upval), u0 (ref), cloneCorpse (upval), Rig (upval), u91 (upval)
                -- upvalues: a2 (upval), u68 (upval), u90 (upval), u99 (upval), u63 (upval), Debris (upval)
                -- upvalues: u102 (upval)
                runPreparationStage(function() -- Line: 522
                    -- upvalues: u17 (upval), u100 (upval), u23 (upval), Players (upval), GameState (upval)
                    -- upvalues: u101 (upval), a1 (upval), u85 (upval), u89 (upval), isExcludedRagdollContent (upval)
                    -- upvalues: u0 (upval), cloneCorpse (upval)
                    local v1
                    local v2 = true
                    if u17 == u100 then
                        local v3
                        if u23 == nil then
                            v3 = GameState.GetState()
                            v1 = u101
                            if v1 then
                                v1 = true
                                if v3 ~= "Warmup" then
                                    v1 = v3 == "Buy Period"
                                end
                            end
                            v2 = not v1
                        else
                            v2 = true
                            if u23.Parent == Players then
                                v3 = GameState.GetState()
                                v1 = u101
                                if v1 then
                                    v1 = true
                                    if v3 ~= "Warmup" then
                                        v1 = v3 == "Buy Period"
                                    end
                                end
                                v2 = not v1
                            end
                        end
                    end
                    if not v2 then
                        v1 = a1
                        v2 = u101
                        if v2 then
                            v2 = false
                            if v1.Parent ~= nil then
                                v2 = false
                                if v1:GetAttribute("ClientRagdoll") ~= true then
                                    v2 = false
                                    if v1:GetAttribute("Dead") ~= true then
                                        v2 = not u85[v1]
                                    end
                                end
                            end
                        end
                        if v2 then
                            if not u89[a1] then
                                v2 = a1
                                for i, j in v2:GetDescendants() do
                                    if isExcludedRagdollContent(j) then
                                        j.Archivable = false
                                    end
                                end
                                u89[v2] = true
                            end
                            u0 = cloneCorpse(a1, "Ragdoll.Pool.CloneReserve", "Ragdoll.Pool.ConfigureReserve")
                            return
                        end
                    end
                end)
                if u0 then
                    local v1
                    local v2 = true
                    if u17 == u100 then
                        local v3
                        if u23 == nil then
                            v1 = GameState.GetState()
                            v3 = u101
                            if v3 then
                                v3 = true
                                if v1 ~= "Warmup" then
                                    v3 = v1 == "Buy Period"
                                end
                            end
                            v2 = not v3
                        else
                            v2 = true
                            if u23.Parent == Players then
                                v1 = GameState.GetState()
                                v3 = u101
                                if v3 then
                                    v3 = true
                                    if v1 ~= "Warmup" then
                                        v3 = v1 == "Buy Period"
                                    end
                                end
                                v2 = not v3
                            end
                        end
                    end
                    if not v2 then
                        local u22 = u0
                        if runPreparationStage(function() -- Line: 536
                                -- upvalues: u17 (upval), u100 (upval), u23 (upval), Players (upval), GameState (upval)
                                -- upvalues: u101 (upval), a1 (upval), u85 (upval), Rig (upval), u22 (val)
                                local v0, v1, v2, v3
                                v0 = true
                                if u17 == u100 then
                                    if u23 == nil then
                                        v2 = GameState.GetState()
                                        v1 = u101
                                        if v1 then
                                            v1 = true
                                            if v2 ~= "Warmup" then
                                                v1 = v2 == "Buy Period"
                                            end
                                        end
                                        v0 = not v1
                                    else
                                        v0 = true
                                        if u23.Parent == Players then
                                            v2 = GameState.GetState()
                                            v1 = u101
                                            if v1 then
                                                v1 = true
                                                if v2 ~= "Warmup" then
                                                    v1 = v2 == "Buy Period"
                                                end
                                            end
                                            v0 = not v1
                                        end
                                    end
                                end
                                if not v0 then
                                    v1 = a1
                                    v0 = u101
                                    if v0 then
                                        v0 = false
                                        if v1.Parent ~= nil then
                                            v0 = false
                                            if v1:GetAttribute("ClientRagdoll") ~= true then
                                                v0 = false
                                                if v1:GetAttribute("Dead") ~= true then
                                                    v0 = not u85[v1]
                                                end
                                            end
                                        end
                                    end
                                    if v0 then
                                        return Rig.Prepare(u22) and Rig.StagePrepared(u22)
                                    end
                                end
                                return false
                            end) == true
                            and u17 == u100 then
                            local v4 = GameState.GetState()
                            v1 = u101
                            if v1 then
                                v1 = true
                                if v4 ~= "Warmup" then
                                    v1 = v4 == "Buy Period"
                                end
                            end
                            if v1 then
                                runPreparationStage(function() -- Line: 546
                                    -- upvalues: u17 (upval), u100 (upval), u23 (upval), Players (upval)
                                    -- upvalues: GameState (upval), u101 (upval), u91 (upval), a2 (upval), u22 (val)
                                    -- upvalues: u68 (upval), u90 (upval), u99 (upval), u63 (upval), Debris (upval)
                                    -- upvalues: u102 (upval), u0 (upval)
                                    local v1, v2
                                    local v3 = true
                                    if u17 == u100 then
                                        if u23 == nil then
                                            v2 = GameState.GetState()
                                            v1 = u101
                                            if v1 then
                                                v1 = true
                                                if v2 ~= "Warmup" then
                                                    v1 = v2 == "Buy Period"
                                                end
                                            end
                                            v3 = not v1
                                        else
                                            v3 = true
                                            if u23.Parent == Players then
                                                v2 = GameState.GetState()
                                                v1 = u101
                                                if v1 then
                                                    v1 = true
                                                    if v2 ~= "Warmup" then
                                                        v1 = v2 == "Buy Period"
                                                    end
                                                end
                                                v3 = not v1
                                            end
                                        end
                                    end
                                    if not v3 then
                                        v3 = u91[a2] or 0
                                        if not (v3 >= 2) then
                                            local u23_2 = u22
                                            debug.profilebegin("Ragdoll.Pool.Park")
                                            local success, result = pcall(function() -- Line: 393 -- upvalues: u23_2 (val), u68 (upval)
                                                u23_2:PivotTo(u68)
                                            end)
                                            debug.profileend()
                                            if not success then
                                                error(result, 0)
                                            end
                                            v1 = u22
                                            v2 = a2
                                            local v4 = u90[v1]
                                            if v4 then
                                                v3 = v4 == v2
                                            elseif 2 <= (u91[v2] or 0) then
                                                v3 = false
                                            elseif not (u63 <= u99) then
                                                u90[v1] = v2
                                                u91[v2] = (u91[v2] or 0) + 1
                                                u99 = u99 + 1
                                                v3 = true
                                            else
                                                v3 = false
                                            end
                                            if not v3 then
                                                return false
                                            end
                                            debug.profilebegin("Ragdoll.Pool.ParentReserve")
                                            local success_2, result_2 = pcall(function() -- Line: 554 -- upvalues: u22 (upval), Debris (upval)
                                                u22.Parent = Debris
                                            end)
                                            debug.profileend()
                                            if not success_2 then
                                                error(result_2, 0)
                                            end
                                            u102(u22)
                                            u0 = nil
                                            return true
                                        end
                                    end
                                    return false
                                end)
                                return
                            end
                        end
                        return
                    end
                end
            end)
            if u0 then
                u126(u0)
            end
            if u98[a2] == u17 then
                u98[a2] = nil
            end
            if not success then
                warn((("[Ragdoll] Reserve prewarm failed: %*"):format(result)))
            end
        end)
        return
    end
end

local function takePreparedCorpse(a1) -- Line: 575
    -- upvalues: u72 (val), u74 (val), u102 (ref), u73 (val)
    local Corpse = u72[a1]
    u72[a1] = nil
    local v1 = u74[a1]
    u74[a1] = nil
    if v1 then
        v1.Cancelled = true
        if not Corpse then
            Corpse = v1.Corpse
            v1.Corpse = nil
        elseif v1.Corpse then
            u102(v1.Corpse)
            v1.Corpse = nil
        end
    end
    local v2 = u73[a1]
    u73[a1] = nil
    if v2 then
        v2:Disconnect()
    end
    return Corpse
end

function u52.HideCharacterLocally(a1) -- Line: 596 -- upvalues: isVisualEffect (val) -- types: a1: userdata
    for i, j in a1:GetDescendants() do
        if j:IsA("BasePart") then
            j.LocalTransparencyModifier = 1
            j.CanCollide = false
            j.CanQuery = false
        elseif j:IsA("Decal") then
            j.LocalTransparencyModifier = 1
        elseif isVisualEffect(j) or j:IsA("BillboardGui") or j:IsA("SurfaceGui") or j:IsA("Highlight") then
            j.Enabled = false
        end
    end
end

function u52.PrepareCharacter(a1) -- Line: 616
    -- upvalues: u72 (val), u101 (ref), u85 (val), u74 (val), RunService (val), getCorpsePoolKey (val)
    -- upvalues: acquirePooledCorpse (val), u73 (val), u102 (ref), scheduleReservePrewarm (val)
    -- upvalues: runPreparationStage (val), u89 (val), isExcludedRagdollContent (val), cloneCorpse (val), u126 (ref)
    -- upvalues: Rig (val), u68 (val), u90 (val), u91 (val), u99 (ref), u63 (val), Debris (val)
    local v1
    if u72[a1] then
        return true
    end
    local v2 = u101
    if v2 then
        v2 = false
        if a1.Parent ~= nil then
            v2 = false
            if a1:GetAttribute("ClientRagdoll") ~= true then
                v2 = false
                if a1:GetAttribute("Dead") ~= true then
                    v2 = not u85[a1]
                end
            end
        end
    end
    if not v2 then
        return false
    end
    v2 = u74[a1]
    if v2 then
        local v3
        while u74[a1] == v2 do
            v3 = u101
            if v3 then
                v3 = false
                if a1.Parent ~= nil then
                    v3 = false
                    if a1:GetAttribute("ClientRagdoll") ~= true then
                        v3 = false
                        if a1:GetAttribute("Dead") ~= true then
                            v3 = not u85[a1]
                        end
                    end
                end
            end
            if not v3 then
                break
            end
            RunService.Heartbeat:Wait()
        end
        return u72[a1] ~= nil
    end
    local u61 = getCorpsePoolKey(a1)
    local v4 = acquirePooledCorpse(a1, u61)
    if v4 then
        u72[a1] = v4
        if not u73[a1] then
            u73[a1] = (a1.AncestryChanged:Connect(function(a1_2, a2) -- Line: 461 -- upvalues: a1 (val), u74 (upval), u102 (upval), u72 (upval), u73 (upval)
                if a2 ~= nil then
                    return
                end
                local v1 = a1
                local v2 = u74[v1]
                u74[v1] = nil
                if v2 then
                    v2.Cancelled = true
                    local Corpse = v2.Corpse
                    v2.Corpse = nil
                    if Corpse then
                        u102(Corpse)
                    end
                end
                local v3 = u72[v1]
                u72[v1] = nil
                if v3 then
                    u102(v3)
                end
                v1 = a1
                v2 = u73[v1]
                u73[v1] = nil
                if v2 then
                    v2:Disconnect()
                end
            end))
        end
        scheduleReservePrewarm(a1, u61)
        return true
    end
    local u82 = {Cancelled = false}
    u74[a1] = u82
    if not u73[a1] then
        u73[a1] = (a1.AncestryChanged:Connect(function(a1_2, a2) -- Line: 461 -- upvalues: a1 (val), u74 (upval), u102 (upval), u72 (upval), u73 (upval)
            if a2 ~= nil then
                return
            end
            local v1 = a1
            local v2 = u74[v1]
            u74[v1] = nil
            if v2 then
                v2.Cancelled = true
                local Corpse = v2.Corpse
                v2.Corpse = nil
                if Corpse then
                    u102(Corpse)
                end
            end
            local v3 = u72[v1]
            u72[v1] = nil
            if v3 then
                u102(v3)
            end
            v1 = a1
            v2 = u73[v1]
            u73[v1] = nil
            if v2 then
                v2:Disconnect()
            end
        end))
    end
    local success, result = pcall(function() -- Line: 648
        -- upvalues: runPreparationStage (upval), a1 (val), u82 (val), u74 (upval), u101 (upval), u85 (upval)
        -- upvalues: u89 (upval), isExcludedRagdollContent (upval), cloneCorpse (upval), u126 (upval), Rig (upval)
        -- upvalues: u68 (upval), u61 (val), u90 (upval), u91 (upval), u99 (upval), u63 (upval), Debris (upval)
        -- upvalues: u72 (upval), scheduleReservePrewarm (upval)
        runPreparationStage(function() -- Line: 650
            -- upvalues: a1 (upval), u82 (upval), u74 (upval), u101 (upval), u85 (upval), u89 (upval)
            -- upvalues: isExcludedRagdollContent (upval), cloneCorpse (upval), u126 (upval)
            local v1 = a1
            local v2 = u82
            local v3 = false
            if u74[v1] == v2 then
                v3 = not v2.Cancelled
                if v3 then
                    v3 = u101
                    if v3 then
                        v3 = false
                        if v1.Parent ~= nil then
                            v3 = false
                            if v1:GetAttribute("ClientRagdoll") ~= true then
                                v3 = false
                                if v1:GetAttribute("Dead") ~= true then
                                    v3 = not u85[v1]
                                end
                            end
                        end
                    end
                end
            end
            if not v3 then
                return
            end
            if not u89[a1] then
                debug.profilebegin("Ragdoll.Prepare.MarkNonArchivable")
                local success, result = pcall(function() -- Line: 655 -- upvalues: a1 (upval), isExcludedRagdollContent (upval), u89 (upval)
                    local v1 = a1
                    for i, j in v1:GetDescendants() do
                        if isExcludedRagdollContent(j) then
                            j.Archivable = false
                        end
                    end
                    u89[v1] = true
                end)
                debug.profileend()
                if not success then
                    error(result, 0)
                end
            end
            v3 = cloneCorpse(a1, "Ragdoll.Prepare.Clone", "Ragdoll.Prepare.ConfigureClone")
            if not v3 then
                return
            end
            v2 = a1
            local v4 = u82
            v1 = false
            if u74[v2] == v4 then
                v1 = not v4.Cancelled
                if v1 then
                    v1 = u101
                    if v1 then
                        v1 = false
                        if v2.Parent ~= nil then
                            v1 = false
                            if v2:GetAttribute("ClientRagdoll") ~= true then
                                v1 = false
                                if v2:GetAttribute("Dead") ~= true then
                                    v1 = not u85[v2]
                                end
                            end
                        end
                    end
                end
            end
            if not v1 then
                u126(v3)
                return
            end
            u82.Corpse = v3
        end)
        local Corpse = u82.Corpse
        if Corpse then
            local v1 = a1
            local v2 = u82
            local v3 = false
            if u74[v1] == v2 then
                v3 = not v2.Cancelled
                if v3 then
                    v3 = u101
                    if v3 then
                        v3 = false
                        if v1.Parent ~= nil then
                            v3 = false
                            if v1:GetAttribute("ClientRagdoll") ~= true then
                                v3 = false
                                if v1:GetAttribute("Dead") ~= true then
                                    v3 = not u85[v1]
                                end
                            end
                        end
                    end
                end
            end
            if v3 then
                local function isCorpseCurrent() -- Line: 675
                    -- upvalues: a1 (upval), u82 (upval), u74 (upval), u101 (upval), u85 (upval), Corpse (val)
                    local v1 = a1
                    local v2 = u82
                    local v3 = false
                    if u74[v1] == v2 then
                        v3 = not v2.Cancelled
                        if v3 then
                            v3 = u101
                            if v3 then
                                v3 = false
                                if v1.Parent ~= nil then
                                    v3 = false
                                    if v1:GetAttribute("ClientRagdoll") ~= true then
                                        v3 = false
                                        if v1:GetAttribute("Dead") ~= true then
                                            v3 = not u85[v1]
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if v3 then
                        v3 = u82.Corpse == Corpse
                    end
                    return v3
                end

                if runPreparationStage(function() -- Line: 680
                    -- upvalues: a1 (upval), u82 (upval), u74 (upval), u101 (upval), u85 (upval), Corpse (val)
                    -- upvalues: Rig (upval)
                    local v0, v1, v2, v3, v4
                    v1 = a1
                    v2 = u82
                    v0 = false
                    if u74[v1] == v2 then
                        v0 = not v2.Cancelled
                        if v0 then
                            v0 = u101
                            if v0 then
                                v0 = false
                                if v1.Parent ~= nil then
                                    v0 = false
                                    if v1:GetAttribute("ClientRagdoll") ~= true then
                                        v0 = false
                                        if v1:GetAttribute("Dead") ~= true then
                                            v0 = not u85[v1]
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if v0 then
                        v0 = u82.Corpse == Corpse
                    end
                    if v0 then
                        return Rig.Prepare(Corpse) and Rig.StagePrepared(Corpse)
                    else
                        return false
                    end
                end) == true then
                    local v4 = a1
                    local v5 = u82
                    v2 = false
                    if u74[v4] == v5 then
                        v2 = not v5.Cancelled
                        if v2 then
                            v2 = u101
                            if v2 then
                                v2 = false
                                if v4.Parent ~= nil then
                                    v2 = false
                                    if v4:GetAttribute("ClientRagdoll") ~= true then
                                        v2 = false
                                        if v4:GetAttribute("Dead") ~= true then
                                            v2 = not u85[v4]
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if v2 then
                        v2 = u82.Corpse == Corpse
                    end
                    if v2 then
                        if runPreparationStage(function() -- Line: 691
                            -- upvalues: a1 (upval), u82 (upval), u74 (upval), u101 (upval), u85 (upval), Corpse (val)
                            -- upvalues: u68 (upval), u61 (upval), u90 (upval), u91 (upval), u99 (upval), u63 (upval)
                            -- upvalues: Debris (upval)
                            local result, result_2, success, success_2, u31, v0, v1, v2, v3, v4
                            v1 = a1
                            v2 = u82
                            v0 = false
                            if u74[v1] == v2 then
                                v0 = not v2.Cancelled
                                if v0 then
                                    v0 = u101
                                    if v0 then
                                        v0 = false
                                        if v1.Parent ~= nil then
                                            v0 = false
                                            if v1:GetAttribute("ClientRagdoll") ~= true then
                                                v0 = false
                                                if v1:GetAttribute("Dead") ~= true then
                                                    v0 = not u85[v1]
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if v0 then
                                v0 = u82.Corpse == Corpse
                            end
                            if v0 then
                                u31 = Corpse
                                debug.profilebegin("Ragdoll.Pool.Park")
                                success, result = pcall(function() -- Line: 393 -- upvalues: u31 (val), u68 (upval)
                                    local v0, v1, v2
                                    u31:PivotTo(u68)
                                    return
                                end)
                                debug.profileend()
                                if not success then
                                    error(result, 0)
                                end
                                v0 = Corpse
                                v1 = u61
                                v2 = u90[v0]
                                if not v2 then
                                    if not (2 <= (u91[v1] or 0)) then
                                        if not (u63 <= u99) then
                                            u90[v0] = v1
                                            u91[v1] = (u91[v1] or 0) + 1
                                            u99 = u99 + 1
                                        end
                                    end
                                elseif v2 == v1 then
                                end
                                debug.profilebegin("Ragdoll.Prepare.ParentInitialPoolSlot")
                                success_2, result_2 = pcall(function() -- Line: 697 -- upvalues: Corpse (upval), Debris (upval)
                                    Corpse.Parent = Debris
                                    return
                                end)
                                debug.profileend()
                                if not success_2 then
                                    error(result_2, 0)
                                end
                                return true
                            else
                                return false
                            end
                        end) == true then
                            v5 = a1
                            local v6 = u82
                            v4 = false
                            if u74[v5] == v6 then
                                v4 = not v6.Cancelled
                                if v4 then
                                    v4 = u101
                                    if v4 then
                                        v4 = false
                                        if v5.Parent ~= nil then
                                            v4 = false
                                            if v5:GetAttribute("ClientRagdoll") ~= true then
                                                v4 = false
                                                if v5:GetAttribute("Dead") ~= true then
                                                    v4 = not u85[v5]
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if v4 then
                                v4 = u82.Corpse == Corpse
                            end
                            if v4 then
                                u72[a1] = Corpse
                                u82.Corpse = nil
                                u74[a1] = nil
                                scheduleReservePrewarm(a1, u61)
                                return true
                            end
                        end
                        return false
                    end
                end
                return false
            end
        end
        return false
    end)
    if u74[a1] == u82 then
        u74[a1] = nil
    end
    if u82.Corpse then
        u102(u82.Corpse)
        u82.Corpse = nil
    end
    if not success then
        v1 = u73[a1]
        u73[a1] = nil
        if v1 then
            v1:Disconnect()
        end
        error(result, 0)
    end
    if result ~= true and not u72[a1] then
        v1 = u73[a1]
        u73[a1] = nil
        if v1 then
            v1:Disconnect()
        end
    end
    return result == true
end

function u52.ActivateCharacter(a1, a2) -- Line: 730
    -- upvalues: u70 (val), u85 (val), u52 (val), u89 (val), isExcludedRagdollContent (val), Rig (val), u72 (val)
    -- upvalues: u74 (val), u102 (ref), u73 (val), cloneCorpse (val), u126 (ref), u90 (val), getCorpsePoolKey (val)
    -- upvalues: u91 (val), u99 (ref), u63 (val), u71 (val), setCorpseVisible (val), Debris (val), GameState (val)
    if a1:GetAttribute("ClientRagdoll") == true then
        return a1
    end
    local v1 = u70[a1]
    if v1 and v1.Parent then
        return v1
    end
    if u85[a1] then
        u52.HideCharacterLocally(a1)
        return a1
    end
    if not u89[a1] then
        debug.profilebegin("Ragdoll.Activate.MarkNonArchivable")
        local success, result = pcall(function() -- Line: 747 -- upvalues: a1 (val), isExcludedRagdollContent (upval), u89 (upval)
            local v1 = a1
            for i, j in v1:GetDescendants() do
                if isExcludedRagdollContent(j) then
                    j.Archivable = false
                end
            end
            u89[v1] = true
        end)
        debug.profileend()
        if not success then
            error(result, 0)
        end
    end
    debug.profilebegin("Ragdoll.Activate.CapturePose")
    local success_2, result_2 = pcall(function() -- Line: 752 -- upvalues: Rig (upval), a1 (val)
        return Rig.CapturePose(a1)
    end)
    debug.profileend()
    if not success_2 then
        error(result_2, 0)
    end
    local u48 = result_2
    debug.profilebegin("Ragdoll.Activate.TakePrepared")
    local success_3, result_3 = pcall(function() -- Line: 755 -- upvalues: a1 (val), u72 (upval), u74 (upval), u102 (upval), u73 (upval)
        local v1 = a1
        local Corpse = u72[v1]
        u72[v1] = nil
        local v2 = u74[v1]
        u74[v1] = nil
        if v2 then
            v2.Cancelled = true
            if not Corpse then
                Corpse = v2.Corpse
                v2.Corpse = nil
            elseif v2.Corpse then
                u102(v2.Corpse)
                v2.Corpse = nil
            end
        end
        local v3 = u73[v1]
        u73[v1] = nil
        if v3 then
            v3:Disconnect()
        end
        return Corpse
    end)
    debug.profileend()
    if not success_3 then
        error(result_3, 0)
    end
    local v2 = result_3 or cloneCorpse(a1, "Ragdoll.Activate.Clone", "Ragdoll.Activate.ConfigureFallbackClone")
    if not v2 then
        return a1
    end
    local u75 = v2
    if not Rig.IsPrepared(u75) then
        debug.profilebegin("Ragdoll.Activate.CompletePreparation")
        local success_4, result_4 = pcall(function() -- Line: 766 -- upvalues: Rig (upval), u75 (val)
            return Rig.Prepare(u75)
        end)
        debug.profileend()
        if not success_4 then
            error(result_4, 0)
        end
        if not (result_4 == true) then
            u126(u75)
            return a1
        end
    end
    if not u90[u75] then
        local v3 = getCorpsePoolKey(a1)
        local v4 = u90[u75]
        if not v4 then
            if not (2 <= (u91[v3] or 0)) and not (u63 <= u99) then
                u90[u75] = v3
                u91[v3] = (u91[v3] or 0) + 1
                u99 = u99 + 1
            end
        elseif v4 == v3 then
        end
    end
    debug.profilebegin("Ragdoll.Activate.ConfigureClone")
    local success_5, result_5 = pcall(function() -- Line: 778 -- upvalues: u75 (val), a1 (val), u70 (upval), u71 (upval)
        u75.Name = a1.Name
        u75:SetAttribute("PreparedRagdoll", nil)
        u75:SetAttribute("Dead", true)
        u70[a1] = u75
        u71[u75] = a1
    end)
    debug.profileend()
    if not success_5 then
        error(result_5, 0)
    end
    debug.profilebegin("Ragdoll.Activate.Rig")
    local success_6, result_6 = pcall(function() -- Line: 786 -- upvalues: Rig (upval), u75 (val), u48 (val), a2 (val)
        Rig.Activate(u75, u48, a2)
    end)
    debug.profileend()
    if not success_6 then
        error(result_6, 0)
    end
    debug.profilebegin("Ragdoll.Activate.Reveal")
    local success_7, result_7 = pcall(function() -- Line: 789 -- upvalues: setCorpseVisible (upval), u75 (val)
        setCorpseVisible(u75, true)
    end)
    debug.profileend()
    if not success_7 then
        error(result_7, 0)
    end
    debug.profilebegin("Ragdoll.Activate.Parent")
    local success_8, result_8 = pcall(function() -- Line: 793 -- upvalues: u75 (val), Debris (upval)
        if u75.Parent ~= Debris then
            u75.Parent = Debris
        end
    end)
    debug.profileend()
    if not success_8 then
        error(result_8, 0)
    end
    debug.profilebegin("Ragdoll.Activate.Cleanup")
    local success_9, result_9 = pcall(function() -- Line: 798 -- upvalues: a1 (val), u75 (val), u52 (upval)
        local CharacterModel = a1:FindFirstChild("CharacterModel")
        if CharacterModel then
            CharacterModel:Destroy()
        end
        local CharacterModel_2 = u75:FindFirstChild("CharacterModel")
        if CharacterModel_2 then
            CharacterModel_2:Destroy()
        end
        u52.HideCharacterLocally(a1)
    end)
    debug.profileend()
    if not success_9 then
        error(result_9, 0)
    end
    local delay = task.delay
    local v5 = false
    if GameState.GetState() == "Warmup" then
        v5 = workspace:GetAttribute("Gamemode") == "Deathmatch"
    end
    delay(if not v5 then 15 else 10, function() -- Line: 804 -- upvalues: u70 (upval), a1 (val), u75 (val), u71 (upval), u102 (upval)
        local v1 = u70[a1]
        if v1 == u75 then
            v1 = a1
            local v2 = u70[v1]
            u70[v1] = nil
            if v2 then
                u71[v2] = nil
                u102(v2)
            end
        end
    end)
    return u75
end

local function markPreparedCorpsesNonReusable(a1) -- Line: 813
    -- upvalues: u72 (val), u97 (val), u74 (val)
    local v1 = u72[a1]
    if v1 then
        u97[v1] = true
    end
    local v2 = u74[a1]
    if v2 and v2.Corpse then
        u97[v2.Corpse] = true
    end
end

function u52.RetireCorpseLocally(a1) -- Line: 825
    -- upvalues: u71 (val), u85 (val), u70 (val), u97 (val), u72 (val), u74 (val), u102 (ref), u73 (val), u52 (val)
    task.defer(function() -- Line: 826
        -- upvalues: a1 (val), u71 (upval), u85 (upval), u70 (upval), u97 (upval), u72 (upval), u74 (upval)
        -- upvalues: u102 (upval), u73 (upval), u52 (upval)
        local v1 = a1
        local v2 = u71[v1] or v1
        u85[v2] = true
        v1 = u70[v2]
        if v1 then
            u97[v1] = true
        end
        local v3 = u72[v2]
        if v3 then
            u97[v3] = true
        end
        local v4 = u74[v2]
        if v4 and v4.Corpse then
            u97[v4.Corpse] = true
        end
        v3 = u74[v2]
        u74[v2] = nil
        if v3 then
            v3.Cancelled = true
            local Corpse = v3.Corpse
            v3.Corpse = nil
            if Corpse then
                u102(Corpse)
            end
        end
        v4 = u72[v2]
        u72[v2] = nil
        if v4 then
            u102(v4)
        end
        v3 = u73[v2]
        u73[v2] = nil
        if v3 then
            v3:Disconnect()
        end
        v3 = u70[v2]
        u70[v2] = nil
        if v3 then
            u71[v3] = nil
            u102(v3)
        end
        if v2.Parent then
            local CharacterModel = v2:FindFirstChild("CharacterModel")
            if CharacterModel then
                CharacterModel:Destroy()
            end
            u52.HideCharacterLocally(v2)
        end
    end)
end

function u52.RecycleAll() -- Line: 844 -- upvalues: u69 (val), u70 (val), u71 (val), u102 (ref)
    local v1
    local v2 = {}
    for i in u69 do
        table.insert(v2, i)
    end
    for j, k in v2 do
        k:Destroy()
    end
    local v3 = {}
    for n in u70 do
        table.insert(v3, n)
    end
    for m, i5 in v3 do
        v1 = u70[i5]
        u70[i5] = nil
        if v1 then
            u71[v1] = nil
            u102(v1)
        end
    end
end

function u52.DestroyAll() -- Line: 862
    -- upvalues: u100 (ref), u52 (val), u72 (val), u74 (val), u97 (val), u102 (ref), u73 (val), u90 (val), u126 (ref)
    -- upvalues: u92 (val), u93 (val), u91 (val), u98 (val), u99 (ref)
    local Corpse, v1, v2
    u100 = u100 + 1
    u52.RecycleAll()
    local v3 = {}
    for i in u72 do
        v3[i] = true
    end
    for j in u74 do
        v3[j] = true
    end
    local v4 = nil
    local v5 = nil
    for k in v3, v4, v5 do
        v1 = u72[k]
        if v1 then
            u97[v1] = true
        end
        v2 = u74[k]
        if v2 and v2.Corpse then
            u97[v2.Corpse] = true
        end
        v1 = u74[k]
        u74[k] = nil
        if v1 then
            v1.Cancelled = true
            Corpse = v1.Corpse
            v1.Corpse = nil
            if Corpse then
                u102(Corpse)
            end
        end
        v2 = u72[k]
        u72[k] = nil
        if v2 then
            u102(v2)
        end
        v1 = u73[k]
        u73[k] = nil
        if v1 then
            v1:Disconnect()
        end
    end
    local v6 = {}
    for n in u90 do
        table.insert(v6, n)
    end
    for m, i5 in v6 do
        u126(i5)
    end
    table.clear(u92)
    table.clear(u93)
    table.clear(u91)
    table.clear(u98)
    u99 = 0
end

function u52.SetEnabled(a1) -- Line: 894 -- upvalues: u101 (ref), u52 (val), Players (val) -- types: a1: boolean
    if u101 == a1 then
        return
    end
    u101 = a1
    if not a1 then
        u52.DestroyAll()
        return
    end
    for i, j in Players:GetPlayers() do
        local Character = j.Character
        if Character then
            task.spawn(function() -- Line: 909 -- upvalues: u52 (upval), Character (val)
                local success, result = pcall(u52.PrepareCharacter, Character)
                if not success then
                    warn((("[Ragdoll] Re-enabled prewarm failed: %*"):format(result)))
                end
            end)
        end
    end
end

function u52.OnceAppearanceReady(a1, a2) -- Line: 919 -- types: a2: function
    a2()
end

function u52.SetupCharacterAppearance(a1) end

function u52.new(a1, a2) -- Line: 926
    -- upvalues: u52 (val), Janitor (val), u71 (val), u97 (val), Signal (val), Rig (val), u69 (val), GameState (val)
    local u5 = setmetatable({}, u52)
    u5.Janitor = Janitor.new()
    u5.SourceCharacter = u71[a1] or a1
    u5.CharacterModel = u52.ActivateCharacter(u5.SourceCharacter, a2.Velocity)
    if a2.Finisher == "Charred" or a2.Finisher == "Gold" or a2.Finisher == "Melted" then
        u97[u5.CharacterModel] = true
    end
    u5.OnDestroy = u5.Janitor:Add((Signal.new()))
    u5.OnAppearanceBuilt = u5.Janitor:Add((Signal.new()))
    u5.IsAppearanceBuilt = true
    u5.IsDestroyed = false
    Rig.ApplyImpulse(u5.CharacterModel, a2)
    u5.Janitor:Add((u5.CharacterModel.AncestryChanged:Connect(function(a1, a2) -- Line: 942 -- upvalues: u5 (val)
        if a2 == nil then
            u5:Destroy()
        end
    end)))
    u69[u5] = true
    local delay = task.delay
    local v1 = false
    if GameState.GetState() == "Warmup" then
        v1 = workspace:GetAttribute("Gamemode") == "Deathmatch"
    end
    delay(if not v1 then 15 else 10, function() -- Line: 949 -- upvalues: u5 (val)
        u5:Destroy()
    end)
    return u5
end

function u52:Destroy() -- Line: 955 -- upvalues: u69 (val), u70 (val), u71 (val), u102 (ref)
    if self.IsDestroyed then
        return
    end
    self.IsDestroyed = true
    u69[self] = nil
    self.OnDestroy:Fire()
    local SourceCharacter = self.SourceCharacter
    local v1 = u70[SourceCharacter]
    u70[SourceCharacter] = nil
    if v1 then
        u71[v1] = nil
        u102(v1)
    end
    task.defer(self.Janitor.Destroy, self.Janitor)
end

GameState.ListenToState(function(a1, a2) -- Line: 967 -- upvalues: u52 (val), u72 (val), scheduleReservePrewarm (val), getCorpsePoolKey (val)
    if a2 == "Buy Period" then
        u52.RecycleAll()
    end
    if a2 ~= "Warmup" and a2 ~= "Buy Period" then
        return
    end
    for i in u72 do
        scheduleReservePrewarm(i, getCorpsePoolKey(i))
    end
end)
Players.PlayerRemoving:Connect(function(a1) -- Line: 981 -- upvalues: u90 (val), u93 (val), u126 (ref), u97 (val) -- types: a1: userdata
    local v1
    local v2 = ("%*\000"):format(a1.UserId)
    local v3 = {}
    for i, j in u90 do
        v1 = #v2
        if string.sub(j, 1, v1) == v2 then
            table.insert(v3, i)
        end
    end
    for k, n in v3 do
        if not u93[n] then
            u97[n] = true
        else
            u126(n)
        end
    end
end)
u52.Rig = Rig
return u52