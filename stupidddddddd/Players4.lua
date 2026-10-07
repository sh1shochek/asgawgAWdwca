-- ReplicatedStorage.Controllers.Observers.Players
-- Script path: ReplicatedStorage.Controllers.Observers.Players
-- Decompile time: 11.89 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Observers = require(ReplicatedStorage.Packages.Observers)
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
local LocalPlayer = Players.LocalPlayer
local CreateWeaponModel = require(script.Components.CreateWeaponModel)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local u39 = {}
local u40 = {}
local u41 = {}
local u42 = {}
local u43 = {}
local u44 = {}
local u45 = 1
local u46 = false
local u47 = nil

local function profileScope(a1, a2) -- Line: 37 -- types: a1: string, a2: function
    debug.profilebegin(a1)
    local success, result = pcall(a2)
    debug.profileend()
    if not success then
        error(result, 0)
    end
    return result
end

local function requestCharacterVisualRebuild(a1) -- Line: 47
    -- upvalues: u43 (val), u44 (val), u46 (ref), u45 (ref), RunService (val), Players (val), u47 (ref)
    if u43[a1] then
        return
    end
    u43[a1] = true
    table.insert(u44, a1)
    if u46 then
        return
    end
    u46 = true
    task.spawn(function() -- Line: 59
        -- upvalues: u45 (upval), u44 (upval), RunService (upval), u43 (upval), Players (upval), u47 (upval)
        -- upvalues: u46 (upval)
        while u45 <= #u44 do
            RunService.Heartbeat:Wait()
            local u10 = u44[u45]
            u45 = u45 + 1
            if u43[u10] then
                u43[u10] = nil
                if u10.Parent == Players then
                    task.spawn(function() -- Line: 73 -- upvalues: u47 (upval), u10 (val)
                        local success, result = pcall(u47, u10)
                        if not success then
                            warn((("[ThirdPersonWeaponModels] %* presentation rebuild failed: %*"):format(u10.Name, result)))
                        end
                    end)
                end
            end
        end
        table.clear(u44)
        u45 = 1
        u46 = false
    end)
end

local function cancelCharacterVisualRebuild(a1) -- Line: 88 -- upvalues: u43 (val) -- types: a1: userdata
    u43[a1] = nil
end

local function waitForPresentationRig(a1) -- Line: 92 -- types: a1: userdata
    local v1
    local v2 = {"HumanoidRootPart", "UpperTorso", "LeftHand", "RightHand"}
    local v3 = nil
    local v4 = nil
    local v5 = a1
    for i, j in v2, v3, v4 do
        v1 = v5:FindFirstChild(j) or v5:WaitForChild(j, 10)
        if v1 and v1:IsA("BasePart") then
            continue
        end
        return false
    end
    return true
end

local function clearCurrentEquippedVisuals(a1) -- Line: 104
    -- upvalues: u39 (val), u40 (val), CharacterResolver (val), CreateWeaponModel (val)
    u39[a1] = nil
    u40[a1] = nil
    local v1 = CharacterResolver.getPlayerCharacter(a1)
    if v1 then
        for i, v in ipairs(v1:GetChildren()) do
            if v:IsA("Folder") then
                if v.Name == "WeaponAttachments" or v.Name == "WeaponModel" then
                    v:ClearAllChildren()
                end
            end
        end
    end
    CreateWeaponModel.ClearPlayerCache(a1)
end

local function buildInventorySlots(a1) -- Line: 122 -- upvalues: HttpService (val) -- types: a1: userdata
    local Attribute
    local v1 = {}
    for i = 1, 3 do
        Attribute = a1:GetAttribute("Slot" .. i)
        if Attribute then
            v1[i] = (HttpService:JSONDecode(Attribute))
        end
    end
    return v1
end

local function stickerSignature(a1) -- Line: 135
    local Position, Rotation, X, Y, format, v1, v2, v3
    if typeof(a1) ~= "table" then
        return ""
    end
    local v4 = {}
    for i, v in ipairs(a1) do
        if typeof(v) ~= "table" then
            v4[i] = (tostring(v))
        else
            Position = v.Position
            Rotation = not (typeof(Position) ~= "table") and Position.Rotation or ""
            X = not (typeof(Position) ~= "table") and Position.X or ""
            Y = not (typeof(Position) ~= "table") and Position.Y or ""
            format = string.format
            v1 = tostring(v.Sticker or "")
            v2 = tostring(Rotation)
            v3 = tostring(X)
            v4[i] = (format("%s@%s,%s,%s", v1, v2, v3, (tostring(Y))))
        end
    end
    return table.concat(v4, ";")
end

local function visualSignature(a1) -- Line: 158 -- upvalues: stickerSignature (val)
    if typeof(a1) ~= "table" then
        return ""
    end
    return table.concat({
        tostring(a1.Identifier or ""),
        tostring(a1.Name or ""),
        tostring(a1.Skin or ""),
        tostring(a1.Float or ""),
        tostring(a1.StatTrack or ""),
        tostring(a1.NameTag or ""),
        (stickerSignature(a1.Stickers)),
    }, "|")
end

local function getEquippedWeaponName(a1) -- Line: 176
    if typeof(a1) ~= "string" then
        return ""
    end
    return string.match(a1, "\"Name\"%s*:%s*\"([^\"]+)\"") or ""
end

local function createInventoryListener(a1) -- Line: 188
    -- upvalues: Observers (val), DebugFlags (val), u43 (val), clearCurrentEquippedVisuals (val), HttpService (val)
    -- upvalues: visualSignature (val), u39 (val), u40 (val), CreateWeaponModel (val), u44 (val), u46 (ref), u45 (ref)
    -- upvalues: RunService (val), Players (val), u47 (ref)
    return Observers.observeAttribute(a1, "CurrentEquipped", function(a1_2) -- Line: 189
        -- upvalues: DebugFlags (upval), a1 (val), u43 (upval), clearCurrentEquippedVisuals (upval), HttpService (upval)
        -- upvalues: visualSignature (upval), u39 (upval), u40 (upval), CreateWeaponModel (upval), u44 (upval)
        -- upvalues: u46 (upval), u45 (upval), RunService (upval), Players (upval), u47 (upval)
        local v1
        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            warn(("[ThirdPersonWeaponModels] %s CurrentEquipped changed (%s bytes JSON)"):format(
                a1.Name,
                (tostring(not (typeof(a1_2) ~= "string") and #a1_2 or -1))
            ))
        end
        if not a1_2 then
            local v2 = a1
            u43[v2] = nil
            clearCurrentEquippedVisuals(a1)
            return function() end
        end
        local u41 = HttpService:JSONDecode(a1_2)
        local v3 = visualSignature(u41)
        if v3 ~= "" and u39[a1] == v3 then
            v1 = u41.IsSuppressed == true
            if u40[a1] ~= v1 then
                u40[a1] = v1
                debug.profilebegin("Observers.Players.RefreshSuppressorState")
                local success, result = pcall(function() -- Line: 213 -- upvalues: CreateWeaponModel (upval), a1 (upval), u41 (val)
                    return CreateWeaponModel.RefreshSuppressorState(a1, u41)
                end)
                debug.profileend()
                if not success then
                    error(result, 0)
                end
                if not result then
                    local v4 = a1
                    if not u43[v4] then
                        u43[v4] = true
                        table.insert(u44, v4)
                        if not u46 then
                            u46 = true
                            task.spawn(function() -- Line: 59
                                -- upvalues: u45 (upval), u44 (upval), RunService (upval), u43 (upval), Players (upval)
                                -- upvalues: u47 (upval), u46 (upval)
                                while u45 <= #u44 do
                                    RunService.Heartbeat:Wait()
                                    local u10 = u44[u45]
                                    u45 = u45 + 1
                                    if u43[u10] then
                                        u43[u10] = nil
                                        if u10.Parent == Players then
                                            task.spawn(function() -- Line: 73 -- upvalues: u47 (upval), u10 (val)
                                                local success, result = pcall(u47, u10)
                                                if not success then
                                                    warn((("[ThirdPersonWeaponModels] %* presentation rebuild failed: %*"):format(
                                                        u10.Name,
                                                        result
                                                    )))
                                                end
                                            end)
                                        end
                                    end
                                end
                                table.clear(u44)
                                u45 = 1
                                u46 = false
                            end)
                        end
                    end
                end
            end
            return function() end
        end
        u39[a1] = v3
        local v5 = a1
        u40[v5] = u41.IsSuppressed == true
        v1 = a1
        if not u43[v1] then
            u43[v1] = true
            table.insert(u44, v1)
            if not u46 then
                u46 = true
                task.spawn(function() -- Line: 59
                    -- upvalues: u45 (upval), u44 (upval), RunService (upval), u43 (upval), Players (upval), u47 (upval)
                    -- upvalues: u46 (upval)
                    while u45 <= #u44 do
                        RunService.Heartbeat:Wait()
                        local u10 = u44[u45]
                        u45 = u45 + 1
                        if u43[u10] then
                            u43[u10] = nil
                            if u10.Parent == Players then
                                task.spawn(function() -- Line: 73 -- upvalues: u47 (upval), u10 (val)
                                    local success, result = pcall(u47, u10)
                                    if not success then
                                        warn((("[ThirdPersonWeaponModels] %* presentation rebuild failed: %*"):format(u10.Name, result)))
                                    end
                                end)
                            end
                        end
                    end
                    table.clear(u44)
                    u45 = 1
                    u46 = false
                end)
            end
        end
        return function() -- Line: 229 -- upvalues: a1 (upval), clearCurrentEquippedVisuals (upval)
            if a1:GetAttribute("CurrentEquipped") ~= nil then
                return
            end
            clearCurrentEquippedVisuals(a1)
        end
    end)
end

local function refreshHolster(a1, a2) -- Line: 240
    -- upvalues: CreateWeaponModel (val), DebugFlags (val)
    local success, result = pcall(CreateWeaponModel[a2], a1)
    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(a1.Name, a2, (tostring(result))))
    end
end

local function refreshObjectiveKitHolster(a1) -- Line: 247
    -- upvalues: CreateWeaponModel (val), DebugFlags (val)
    local success, result = pcall(CreateWeaponModel.RefreshObjectiveKitHolster, a1)
    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(a1.Name, "RefreshObjectiveKitHolster", (tostring(result))))
    end
end

local function refreshBombHolster(a1) -- Line: 251
    -- upvalues: CreateWeaponModel (val), DebugFlags (val)
    debug.profilebegin("Observers.Players.RefreshBombHolster")
    local success, result = pcall(CreateWeaponModel.RefreshBombHolster, a1)
    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(a1.Name, "RefreshBombHolster", (tostring(result))))
    end
    debug.profileend()
end

local function scheduleHolsterRefresh(a1, a2, a3) -- Line: 259
    -- upvalues: u43 (val), Players (val)
    if not u43[a1] and not a2[a1] then
        a2[a1] = true
        task.defer(function() -- Line: 265 -- upvalues: a2 (val), a1 (val), Players (upval), u43 (upval), a3 (val)
            a2[a1] = nil
            if a1.Parent == Players and not u43[a1] then
                a3(a1)
            end
        end)
        return
    end
end

local function createObjectiveKitListener(a1) -- Line: 275
    -- upvalues: u41 (val), refreshObjectiveKitHolster (val), u43 (val), Players (val), Observers (val)
    local function onKitChanged() -- Line: 276
        -- upvalues: a1 (val), u41 (upval), refreshObjectiveKitHolster (upval), u43 (upval), Players (upval)
        local u0 = a1
        local u1 = u41
        local u2 = refreshObjectiveKitHolster
        if not u43[u0] and not u1[u0] then
            u1[u0] = true
            task.defer(function() -- Line: 265 -- upvalues: u1 (val), u0 (val), Players (upval), u43 (upval), u2 (val)
                u1[u0] = nil
                if u0.Parent == Players and not u43[u0] then
                    u2(u0)
                end
            end)
        end
        return function() end
    end

    local u7 = Observers.observeAttribute(a1, "HasDefuseKit", onKitChanged)
    local u13 = Observers.observeAttribute(a1, "HasRescueKit", onKitChanged)
    return function() -- Line: 283 -- upvalues: u7 (val), u13 (val)
        u7()
        u13()
    end
end

local function createBombHolsterListener(a1) -- Line: 291
    -- upvalues: u42 (val), refreshBombHolster (val), u43 (val), Players (val), Observers (val), u44 (val), u46 (ref)
    -- upvalues: u45 (ref), RunService (val), u47 (ref)
    local Attribute = a1:GetAttribute("CurrentEquipped")
    local u13 = typeof(Attribute) == "string" and string.match(Attribute, "\"Name\"%s*:%s*\"([^\"]+)\"") or ""
    local u22 = (a1:GetAttributeChangedSignal("Slot5")):Connect(function() -- Line: 295 -- upvalues: a1 (val), u42 (upval), refreshBombHolster (upval), u43 (upval), Players (upval)
        local u0 = a1
        local u1 = u42
        local u2 = refreshBombHolster
        if not u43[u0] then
            if u1[u0] then
                return
            end
            u1[u0] = true
            task.defer(function() -- Line: 265 -- upvalues: u1 (val), u0 (val), Players (upval), u43 (upval), u2 (val)
                u1[u0] = nil
                if u0.Parent == Players and not u43[u0] then
                    u2(u0)
                end
            end)
        end
    end)
    local u29 = Observers.observeAttribute(a1, "CurrentEquipped", function(a1_2) -- Line: 303
        -- upvalues: u13 (ref), a1 (val), u43 (upval), u44 (upval), u46 (upval), u45 (upval), RunService (upval)
        -- upvalues: Players (upval), u47 (upval)
        local v1
        if (typeof(a1_2) == "string" and string.match(a1_2, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") == u13 then
            return function() end
        end
        u13 = v1
        local v2 = a1
        if not u43[v2] then
            u43[v2] = true
            table.insert(u44, v2)
            if not u46 then
                u46 = true
                task.spawn(function() -- Line: 59
                    -- upvalues: u45 (upval), u44 (upval), RunService (upval), u43 (upval), Players (upval), u47 (upval)
                    -- upvalues: u46 (upval)
                    while u45 <= #u44 do
                        RunService.Heartbeat:Wait()
                        local u10 = u44[u45]
                        u45 = u45 + 1
                        if u43[u10] then
                            u43[u10] = nil
                            if u10.Parent == Players then
                                task.spawn(function() -- Line: 73 -- upvalues: u47 (upval), u10 (val)
                                    local success, result = pcall(u47, u10)
                                    if not success then
                                        warn((("[ThirdPersonWeaponModels] %* presentation rebuild failed: %*"):format(u10.Name, result)))
                                    end
                                end)
                            end
                        end
                    end
                    table.clear(u44)
                    u45 = 1
                    u46 = false
                end)
            end
        end
        return function() end
    end)
    return function() -- Line: 315 -- upvalues: u22 (val), u29 (val)
        u22:Disconnect()
        u29()
    end
end

function u47(a1) -- Line: 321
    -- upvalues: CharacterResolver (val), CreateWeaponModel (val), waitForPresentationRig (val), u43 (val), u44 (val)
    -- upvalues: u46 (ref), u45 (ref), RunService (val), Players (val), u47 (ref), HttpService (val), u39 (val)
    -- upvalues: visualSignature (val), u40 (val), buildInventorySlots (val), DebugFlags (val)
    local u4 = CharacterResolver.getPlayerCharacter(a1)
    if u4 and u4:GetAttribute("Dead") ~= true then
        if not waitForPresentationRig(u4) then
            CreateWeaponModel.ClearPlayerCache(a1)
            return
        end
        debug.profilebegin("Observers.Players.RebuildCharacterVisuals")
        local success, result = pcall(function() -- Line: 334
            -- upvalues: CharacterResolver (upval), a1 (val), u4 (val), u43 (upval), u44 (upval), u46 (upval)
            -- upvalues: u45 (upval), RunService (upval), Players (upval), u47 (upval), HttpService (upval), u39 (upval)
            -- upvalues: visualSignature (upval), u40 (upval), CreateWeaponModel (upval), buildInventorySlots (upval)
            -- upvalues: DebugFlags (upval)
            local v1 = CharacterResolver.getPlayerCharacter(a1)
            if v1 == u4 and u4:GetAttribute("Dead") ~= true then
                v1 = false
                local Attribute = a1:GetAttribute("CurrentEquipped")
                if Attribute then
                    local success, result = pcall(function() -- Line: 346 -- upvalues: HttpService (upval), Attribute (val)
                        return HttpService:JSONDecode(Attribute)
                    end)
                    if success and typeof(result) == "table" then
                        u39[a1] = (visualSignature(result))
                        local v2 = a1
                        u40[v2] = result.IsSuppressed == true
                        debug.profilebegin("Observers.Players.RebuildCharacterVisuals.Weapon")
                        local success_2, result_2 = pcall(function() -- Line: 352 -- upvalues: CreateWeaponModel (upval), a1 (upval), result (val), buildInventorySlots (upval)
                            CreateWeaponModel(a1, result, (buildInventorySlots(a1)))
                        end)
                        debug.profileend()
                        if not success_2 then
                            error(result_2, 0)
                        end
                        v1 = true
                    end
                end
                if not v1 then
                    debug.profilebegin("Observers.Players.RebuildCharacterVisuals.ObjectiveKit")
                    local success_3, result_3 = pcall(function() -- Line: 361 -- upvalues: a1 (upval), CreateWeaponModel (upval), DebugFlags (upval)
                        local v1 = a1
                        local success, result = pcall(CreateWeaponModel.RefreshObjectiveKitHolster, v1)
                        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
                            warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(v1.Name, "RefreshObjectiveKitHolster", (tostring(result))))
                        end
                    end)
                    debug.profileend()
                    if not success_3 then
                        error(result_3, 0)
                    end
                    debug.profilebegin("Observers.Players.RebuildCharacterVisuals.BombHolster")
                    local success_4, result_4 = pcall(function() -- Line: 364 -- upvalues: a1 (upval), CreateWeaponModel (upval), DebugFlags (upval)
                        local v1 = a1
                        debug.profilebegin("Observers.Players.RefreshBombHolster")
                        local success, result = pcall(CreateWeaponModel.RefreshBombHolster, v1)
                        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
                            warn(("[ThirdPersonWeaponModels] %s %s failed: %s"):format(v1.Name, "RefreshBombHolster", (tostring(result))))
                        end
                        debug.profileend()
                    end)
                    debug.profileend()
                    if not success_4 then
                        error(result_4, 0)
                    end
                end
                return
            end
            v1 = a1
            if u43[v1] then
                return
            end
            u43[v1] = true
            table.insert(u44, v1)
            if u46 then
                return
            end
            u46 = true
            task.spawn(function() -- Line: 59
                -- upvalues: u45 (upval), u44 (upval), RunService (upval), u43 (upval), Players (upval), u47 (upval)
                -- upvalues: u46 (upval)
                while u45 <= #u44 do
                    RunService.Heartbeat:Wait()
                    local u10 = u44[u45]
                    u45 = u45 + 1
                    if u43[u10] then
                        u43[u10] = nil
                        if u10.Parent == Players then
                            task.spawn(function() -- Line: 73 -- upvalues: u47 (upval), u10 (val)
                                local success, result = pcall(u47, u10)
                                if not success then
                                    warn((("[ThirdPersonWeaponModels] %* presentation rebuild failed: %*"):format(u10.Name, result)))
                                end
                            end)
                        end
                    end
                end
                table.clear(u44)
                u45 = 1
                u46 = false
            end)
        end)
        debug.profileend()
        if not success then
            error(result, 0)
        end
        return
    end
    debug.profilebegin("Observers.Players.RebuildCharacterVisuals.ClearCache")
    local success_2, result_2 = pcall(function() -- Line: 324 -- upvalues: CreateWeaponModel (upval), a1 (val)
        CreateWeaponModel.ClearPlayerCache(a1)
    end)
    debug.profileend()
    if not success_2 then
        error(result_2, 0)
    end
end

return (Observers.observePlayer(function(a1) -- Line: 374
    -- upvalues: LocalPlayer (val), Observers (val), DebugFlags (val), u43 (val), clearCurrentEquippedVisuals (val)
    -- upvalues: HttpService (val), visualSignature (val), u39 (val), u40 (val), CreateWeaponModel (val), u44 (val)
    -- upvalues: u46 (ref), u45 (ref), RunService (val), Players (val), u47 (ref), createObjectiveKitListener (val)
    -- upvalues: createBombHolsterListener (val), CharacterResolver (val), u41 (val), u42 (val)
    if a1 == LocalPlayer then
        return function() end
    end
    local u8 = Observers.observeAttribute(a1, "CurrentEquipped", function(a1_2) -- Line: 189
        -- upvalues: DebugFlags (upval), a1 (val), u43 (upval), clearCurrentEquippedVisuals (upval), HttpService (upval)
        -- upvalues: visualSignature (upval), u39 (upval), u40 (upval), CreateWeaponModel (upval), u44 (upval)
        -- upvalues: u46 (upval), u45 (upval), RunService (upval), Players (upval), u47 (upval)
        local v1
        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            warn(("[ThirdPersonWeaponModels] %s CurrentEquipped changed (%s bytes JSON)"):format(
                a1.Name,
                (tostring(not (typeof(a1_2) ~= "string") and #a1_2 or -1))
            ))
        end
        if not a1_2 then
            local v2 = a1
            u43[v2] = nil
            clearCurrentEquippedVisuals(a1)
            return function() end
        end
        local u41 = HttpService:JSONDecode(a1_2)
        local v3 = visualSignature(u41)
        if v3 ~= "" and u39[a1] == v3 then
            v1 = u41.IsSuppressed == true
            if u40[a1] ~= v1 then
                u40[a1] = v1
                debug.profilebegin("Observers.Players.RefreshSuppressorState")
                local success, result = pcall(function() -- Line: 213 -- upvalues: CreateWeaponModel (upval), a1 (upval), u41 (val)
                    return CreateWeaponModel.RefreshSuppressorState(a1, u41)
                end)
                debug.profileend()
                if not success then
                    error(result, 0)
                end
                if not result then
                    local v4 = a1
                    if not u43[v4] then
                        u43[v4] = true
                        table.insert(u44, v4)
                        if not u46 then
                            u46 = true
                            task.spawn(function() -- Line: 59
                                -- upvalues: u45 (upval), u44 (upval), RunService (upval), u43 (upval), Players (upval)
                                -- upvalues: u47 (upval), u46 (upval)
                                while u45 <= #u44 do
                                    RunService.Heartbeat:Wait()
                                    local u10 = u44[u45]
                                    u45 = u45 + 1
                                    if u43[u10] then
                                        u43[u10] = nil
                                        if u10.Parent == Players then
                                            task.spawn(function() -- Line: 73 -- upvalues: u47 (upval), u10 (val)
                                                local success, result = pcall(u47, u10)
                                                if not success then
                                                    warn((("[ThirdPersonWeaponModels] %* presentation rebuild failed: %*"):format(
                                                        u10.Name,
                                                        result
                                                    )))
                                                end
                                            end)
                                        end
                                    end
                                end
                                table.clear(u44)
                                u45 = 1
                                u46 = false
                            end)
                        end
                    end
                end
            end
            return function() end
        end
        u39[a1] = v3
        local v5 = a1
        u40[v5] = u41.IsSuppressed == true
        v1 = a1
        if not u43[v1] then
            u43[v1] = true
            table.insert(u44, v1)
            if not u46 then
                u46 = true
                task.spawn(function() -- Line: 59
                    -- upvalues: u45 (upval), u44 (upval), RunService (upval), u43 (upval), Players (upval), u47 (upval)
                    -- upvalues: u46 (upval)
                    while u45 <= #u44 do
                        RunService.Heartbeat:Wait()
                        local u10 = u44[u45]
                        u45 = u45 + 1
                        if u43[u10] then
                            u43[u10] = nil
                            if u10.Parent == Players then
                                task.spawn(function() -- Line: 73 -- upvalues: u47 (upval), u10 (val)
                                    local success, result = pcall(u47, u10)
                                    if not success then
                                        warn((("[ThirdPersonWeaponModels] %* presentation rebuild failed: %*"):format(u10.Name, result)))
                                    end
                                end)
                            end
                        end
                    end
                    table.clear(u44)
                    u45 = 1
                    u46 = false
                end)
            end
        end
        return function() -- Line: 229 -- upvalues: a1 (upval), clearCurrentEquippedVisuals (upval)
            if a1:GetAttribute("CurrentEquipped") ~= nil then
                return
            end
            clearCurrentEquippedVisuals(a1)
        end
    end)
    local u11 = createObjectiveKitListener(a1)
    local u14 = createBombHolsterListener(a1)
    local u19 = CharacterResolver.observeCharacter(a1, function() -- Line: 384
        -- upvalues: a1 (val), u43 (upval), u44 (upval), u46 (upval), u45 (upval), RunService (upval), Players (upval)
        -- upvalues: u47 (upval)
        local v1 = a1
        if not u43[v1] then
            u43[v1] = true
            table.insert(u44, v1)
            if not u46 then
                u46 = true
                task.spawn(function() -- Line: 59
                    -- upvalues: u45 (upval), u44 (upval), RunService (upval), u43 (upval), Players (upval), u47 (upval)
                    -- upvalues: u46 (upval)
                    while u45 <= #u44 do
                        RunService.Heartbeat:Wait()
                        local u10 = u44[u45]
                        u45 = u45 + 1
                        if u43[u10] then
                            u43[u10] = nil
                            if u10.Parent == Players then
                                task.spawn(function() -- Line: 73 -- upvalues: u47 (upval), u10 (val)
                                    local success, result = pcall(u47, u10)
                                    if not success then
                                        warn((("[ThirdPersonWeaponModels] %* presentation rebuild failed: %*"):format(u10.Name, result)))
                                    end
                                end)
                            end
                        end
                    end
                    table.clear(u44)
                    u45 = 1
                    u46 = false
                end)
            end
        end
        return function() end
    end)
    return function() -- Line: 388
        -- upvalues: u8 (val), u11 (val), u14 (val), u19 (val), u41 (upval), a1 (val), u42 (upval), u43 (upval)
        -- upvalues: CreateWeaponModel (upval), u39 (upval), u40 (upval)
        u8()
        u11()
        u14()
        u19()
        u41[a1] = nil
        u42[a1] = nil
        u43[a1] = nil
        CreateWeaponModel.ClearPlayerCache(a1)
        u39[a1] = nil
        u40[a1] = nil
    end
end))