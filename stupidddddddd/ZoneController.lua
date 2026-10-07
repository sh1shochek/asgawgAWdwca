-- ReplicatedStorage.Shared.Zone.ZoneController
-- Script path: ReplicatedStorage.Shared.Zone.ZoneController
-- Decompile time: 10.93 ms

local Janitor = require(script.Parent.Janitor)
local Enum = require(script.Parent.Enum)
require(script.Parent.Signal)
local Tracker = require(script.Tracker)
local CollectiveWorldModel = require(script.CollectiveWorldModel)
local enums = Enum.enums
local Players = game:GetService("Players")
local u29 = {}
local u30 = 0
local u31 = {}
local u32 = {}
local u33 = {}
local u34 = {}
local u35 = {}
local u36 = {}
local u37 = 0
local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat
local u44 = {}
local LocalPlayer = RunService:IsClient()
if LocalPlayer then
    LocalPlayer = Players.LocalPlayer
end
local u49 = {}
local u50 = {}
u50.player = Tracker.new("player")
u50.item = Tracker.new("item")
u49.trackers = u50

local function dictLength(a1) -- Line: 40
    local v1 = 0
    for k, v in pairs(a1) do
        v1 = v1 + 1
    end
    return v1
end

local function fillOccupants(a1, a2, a3) -- Line: 48
    local v1 = a1[a2]
    if not v1 then
        a1[a2] = {}
    end
    local Character = a3:IsA("Player") and a3.Character
    v1[a3] = Character or true
end

local u60 = {}

function u60.player(a1) -- Line: 59 -- upvalues: u49 (val), u29 (val), u30 (ref)
    return u49._getZonesAndItems("player", u29, u30, true, a1)
end

function u60.localPlayer(a1) -- Line: 62 -- upvalues: LocalPlayer (val), u49 (val), u50 (val)
    local Character_2, v1, v2
    local v3 = {}
    local Character = LocalPlayer.Character
    if not Character then
        return v3
    end
    for k, v in pairs((u49.getTouchingZones(Character, true, a1, u50.player))) do
        if v.activeTriggers.localPlayer then
            v2 = LocalPlayer
            v1 = v3[v]
            if not v1 then
                v3[v] = {}
            end
            Character_2 = v2:IsA("Player") and v2.Character
            v1[v2] = Character_2 or true
        end
    end
    return v3
end

function u60.item(a1) -- Line: 76 -- upvalues: u49 (val), u29 (val), u30 (ref)
    return u49._getZonesAndItems("item", u29, u30, true, a1)
end

function u49._registerZone(a1) -- Line: 84 -- upvalues: u32 (val), Janitor (val), u49 (val)
    u32[a1] = true
    local v1 = a1.janitor:add(Janitor.new(), "destroy")
    a1._registeredJanitor = v1
    v1:add(a1.updated:Connect(function() -- Line: 88 -- upvalues: u49 (upval)
        u49._updateZoneDetails()
    end), "Disconnect")
    u49._updateZoneDetails()
end

function u49._deregisterZone(a1) -- Line: 94 -- upvalues: u32 (val), u49 (val)
    u32[a1] = nil
    a1._registeredJanitor:destroy()
    a1._registeredJanitor = nil
    u49._updateZoneDetails()
end

function u49._registerConnection(a1, a2) -- Line: 101 -- upvalues: u37 (ref), u29 (val), u49 (val), u31 (val), u60 (val)
    local v1 = 0
    for k, v in pairs(a1.activeTriggers) do
        v1 = v1 + 1
    end
    u37 = u37 + 1
    if v1 == 0 then
        u29[a1] = true
        u49._updateZoneDetails()
    end
    local v2 = u31[a2]
    u31[a2] = v2 and v2 + 1 or 1
    a1.activeTriggers[a2] = true
    if a1.touchedConnectionActions[a2] then
        a1:_formTouchedConnection(a2)
    end
    if u60[a2] then
        u49._formHeartbeat(a2)
    end
end

function u49.updateDetection(a1) -- Line: 121 -- upvalues: Tracker (val), enums (val)
    local Centre, v1
    local v2 = a1
    for k, v in pairs({enterDetection = "_currentEnterDetection", exitDetection = "_currentExitDetection"}) do
        Centre = v2[k]
        v1 = Tracker.getCombinedTotalVolumes()
        if Centre == enums.Detection.Automatic then
            Centre = if not (v1 > 729000) then enums.Detection.WholeBody else enums.Detection.Centre
        end
        v2[v] = Centre
    end
end

function u49._formHeartbeat(a1) -- Line: 140
    -- upvalues: u44 (val), Heartbeat (val), u29 (val), u49 (val), u60 (val), enums (val)
    if u44[a1] then
        return
    end
    local u3 = 0
    u44[a1] = (Heartbeat:Connect(function() -- Line: 150 -- upvalues: u3 (ref), u29 (upval), a1 (val), u49 (upval), u60 (upval), enums (upval)
        local v1 = os.clock()
        if u3 <= v1 then
            local _currentEnterDetection, accuracy, accuracy_2, settingsGroupName, v2, v3, v4, v5, v6, v7
            local v8 = nil
            local v9 = nil
            for k, v in pairs(u29) do
                if k.activeTriggers[a1] then
                    accuracy_2 = k.accuracy
                    if v8 == nil or accuracy_2 < v8 then
                        v8 = accuracy_2
                    end
                    u49.updateDetection(k)
                    _currentEnterDetection = k._currentEnterDetection
                    if v9 == nil or _currentEnterDetection < v9 then
                        v9 = _currentEnterDetection
                    end
                end
            end
            local v10 = v8
            local v11 = u60[a1](v9)
            local v12 = {}
            local v13 = {}
            for k2, i in pairs(v11) do
                settingsGroupName = k2.settingsGroupName and u49.getGroup(k2.settingsGroupName)
                if settingsGroupName and settingsGroupName.onlyEnterOnceExitedAll == true then
                    for k3, j in pairs(i) do
                        v6 = v12[k2.settingsGroupName]
                        if not v6 then
                            v12[k2.settingsGroupName] = {}
                        end
                        v6[k3] = k2
                    end
                    v13[k2] = i
                end
            end
            for k4, k5 in pairs(v13) do
                v2 = v12[k4.settingsGroupName]
                if v2 then
                    for k6, n in pairs(k5) do
                        v6 = v2[k6]
                        if v6 and v6 ~= k4 then
                            k5[k6] = nil
                        end
                    end
                end
            end
            local v14 = {{}, {}}
            for k7, m in pairs(u29) do
                if k7.activeTriggers[a1] then
                    accuracy = k7.accuracy
                    v3 = v11[k7] or {}
                    v4 = false
                    for k8, i5 in pairs(v3) do
                        v4 = true
                        break
                    end
                    if v4 and v10 < accuracy then
                        v10 = accuracy
                    end
                    v5 = k7:_updateOccupants(a1, v3)
                    v14[1][k7] = v5.exited
                    v14[2][k7] = v5.entered
                end
            end
            local v15 = {"Exited", "Entered"}
            for k9, i6 in pairs(v14) do
                v4 = a1 .. v15[k9]
                for k10, i7 in pairs(i6) do
                    v7 = k10[v4]
                    if v7 then
                        for k11, i8 in pairs(i7) do
                            v7:Fire(i8)
                        end
                    end
                end
            end
            u3 = v1 + enums.Accuracy.getProperty(v10)
        end
    end))
end

function u49._deregisterConnection(a1, a2) -- Line: 249
    -- upvalues: u37 (ref), u31 (val), u44 (val), u29 (val), u49 (val)
    local v1
    u37 = u37 - 1
    if u31[a2] ~= 1 then
        v1 = u31
        v1[a2] = v1[a2] - 1
    else
        u31[a2] = nil
        v1 = u44[a2]
        if v1 then
            u44[a2] = nil
            v1:Disconnect()
        end
    end
    a1.activeTriggers[a2] = nil
    v1 = 0
    for k, v in pairs(a1.activeTriggers) do
        v1 = v1 + 1
    end
    if v1 == 0 then
        u29[a1] = nil
        u49._updateZoneDetails()
    end
    if a1.touchedConnectionActions[a2] then
        a1:_disconnectTouchedConnection(a2)
    end
end

function u49._updateZoneDetails() -- Line: 271
    -- upvalues: u33 (ref), u34 (ref), u35 (ref), u36 (ref), u30 (ref), u32 (val), u29 (val)
    local v1
    u33 = {}
    u34 = {}
    u35 = {}
    u36 = {}
    u30 = 0
    for k, v in pairs(u32) do
        v1 = u29[k]
        if v1 then
            u30 = u30 + k.volume
        end
        for k2, i in pairs(k.zoneParts) do
            if v1 then
                table.insert(u33, i)
                u34[i] = k
            end
            table.insert(u35, i)
            u36[i] = k
        end
    end
end

function u49._getZonesAndItems(a1, a2, a3, a4, a5) -- Line: 293
    -- upvalues: u50 (val), u49 (val), Players (val), CollectiveWorldModel (val)
    local Character_2, Character_3, PlayerFromCharacter, v1, v2, v3
    local v4 = a3
    if not v4 then
        for k, v in pairs(a2) do
            v4 = v4 + k.volume
        end
    end
    local v5 = {}
    local v6 = u50[a1]
    if v6.totalVolume < v4 then
        local Character, v7
        for k8, i5 in pairs(v6.items) do
            for k9, i6 in pairs((u49.getTouchingZones(i5, a4, a5, v6))) do
                if not a4 or i6.activeTriggers[a1] then
                    v7 = i5
                    if a1 == "player" then
                        v7 = Players:GetPlayerFromCharacter(i5)
                    end
                    if v7 then
                        v3 = v5[i6]
                        if not v3 then
                            v5[i6] = {}
                        end
                        Character = v7:IsA("Player") and v7.Character
                        v3[v7] = Character or true
                    end
                end
            end
        end
        return v5
    end
    for k2, i in pairs(a2) do
        if not a4 then
            v1 = {}
            for k3, j in pairs((CollectiveWorldModel:GetPartBoundsInBox(k2.region.CFrame, k2.region.Size, v6.whitelistParams))) do
                v2 = v6.partToItem[j]
                if not v1[v2] then
                    v1[v2] = true
                end
            end
            for k4, k5 in pairs(v1) do
                if a1 == "player" then
                    PlayerFromCharacter = Players:GetPlayerFromCharacter(k4)
                    if k2:findPlayer(PlayerFromCharacter) then
                        v3 = v5[k2]
                        if not v3 then
                            v5[k2] = {}
                        end
                        Character_2 = PlayerFromCharacter:IsA("Player") and PlayerFromCharacter.Character
                        v3[PlayerFromCharacter] = Character_2 or true
                    end
                elseif k2:findItem(k4) then
                    v2 = v5[k2]
                    if not v2 then
                        v5[k2] = {}
                    end
                    Character_3 = k4:IsA("Player") and k4.Character
                    v2[k4] = Character_3 or true
                end
            end
        elseif k2.activeTriggers[a1] then
            v1 = {}
            for k6, n in pairs((CollectiveWorldModel:GetPartBoundsInBox(k2.region.CFrame, k2.region.Size, v6.whitelistParams))) do
                v2 = v6.partToItem[n]
                if not v1[v2] then
                    v1[v2] = true
                end
            end
            for k7, m in pairs(v1) do
                if a1 == "player" then
                    PlayerFromCharacter = Players:GetPlayerFromCharacter(k7)
                    if k2:findPlayer(PlayerFromCharacter) then
                        v3 = v5[k2]
                        if not v3 then
                            v5[k2] = {}
                        end
                        Character_2 = PlayerFromCharacter:IsA("Player") and PlayerFromCharacter.Character
                        v3[PlayerFromCharacter] = Character_2 or true
                    end
                elseif k2:findItem(k7) then
                    v2 = v5[k2]
                    if not v2 then
                        v5[k2] = {}
                    end
                    Character_3 = k7:IsA("Player") and k7.Character
                    v2[k7] = Character_3 or true
                end
            end
        end
    end
    return v5
end

function u49.getZones() -- Line: 354 -- upvalues: u32 (val)
    local v1 = {}
    for k, v in pairs(u32) do
        table.insert(v1, k)
    end
    return v1
end

function u49.getTouchingZones(a1, a2, a3, a4) -- Line: 374
    -- upvalues: enums (val), Tracker (val), u33 (ref), u35 (ref), u34 (ref), u36 (ref), CollectiveWorldModel (val)
    local v1, v2
    local v3 = nil
    if a4 then
        v3 = a4.exitDetections[a1]
        a4.exitDetections[a1] = nil
    end
    local Size = nil
    local CFrame = nil
    local v4 = a1:IsA("BasePart")
    local v5 = not v4
    local v6 = {}
    if v4 then
        Size = a1.Size
        CFrame = a1.CFrame
        table.insert(v6, a1)
    elseif (v3 or a3) ~= enums.Detection.WholeBody then
        local HumanoidRootPart = a1:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart then
            Size = HumanoidRootPart.Size
            CFrame = HumanoidRootPart.CFrame
            table.insert(v6, HumanoidRootPart)
        end
    else
        v1, v2 = Tracker.getCharacterSize(a1)
        Size = v1
        CFrame = v2
        v6 = a1:GetChildren()
    end
    if Size and CFrame then
        local v7, v8
        v1 = a2 and u33 or u35
        v2 = a2 and u34 or u36
        local v9 = OverlapParams.new()
        v9.FilterType = Enum.RaycastFilterType.Whitelist
        v9.MaxParts = #v1
        v9.FilterDescendantsInstances = v1
        local v10 = {}
        local v11 = {}
        local v12 = {}
        local v13, v14 = a1, a4
        for k, v in pairs((CollectiveWorldModel:GetPartBoundsInBox(CFrame, Size, v9))) do
            v8 = v2[v]
            if not v8 or not v8.allZonePartsAreBlocks then
                table.insert(v12, v)
            else
                v11[v8] = true
                v10[v] = v8
            end
        end
        local v15 = #v12
        local v16 = 0
        if v15 > 0 then
            local v17, v18
            v7 = OverlapParams.new()
            v7.FilterType = Enum.RaycastFilterType.Whitelist
            v7.MaxParts = v15
            v7.FilterDescendantsInstances = v12
            for k2, i in pairs(v6) do
                v17 = false
                if i:IsA("BasePart") then
                    if v5 and Tracker.bodyPartsToIgnore[i.Name] then
                        continue
                    end
                    for k3, j in pairs((CollectiveWorldModel:GetPartsInPart(i, v7))) do
                        if not v10[j] then
                            v18 = v2[j]
                            if v18 then
                                v11[v18] = true
                                v10[j] = v18
                                v16 = v16 + 1
                            end
                            if v16 == v15 then
                                v17 = true
                                break
                            end
                        end
                    end
                    if v17 then
                        break
                    end
                end
            end
        end
        v7 = {}
        local _currentExitDetection = nil
        for k4, k5 in pairs(v11) do
            if _currentExitDetection == nil or k4._currentExitDetection < _currentExitDetection then
                _currentExitDetection = k4._currentExitDetection
            end
            table.insert(v7, k4)
        end
        if _currentExitDetection and v14 then
            v14.exitDetections[v13] = _currentExitDetection
        end
        return v7, v10
    end
    return {}
end

local u90 = {}

function u49.setGroup(a1, a2) -- Line: 491 -- upvalues: u90 (val)
    local v1 = u90[a1]
    if not v1 then
        u90[a1] = {}
    end
    v1.onlyEnterOnceExitedAll = true
    v1._name = a1
    v1._memberZones = {}
    if typeof(a2) == "table" then
        for k, v in pairs(a2) do
            v1[k] = v
        end
    end
    return v1
end

function u49.getGroup(a1) -- Line: 515 -- upvalues: u90 (val)
    return u90[a1]
end

local u93 = nil
local u105 = string.format("ZonePlus%sContainer", if not RunService:IsClient() then "Server" else "Client")

function u49.getWorkspaceContainer() -- Line: 521 -- upvalues: u93 (ref), u105 (val)
    local v1 = u93 or workspace:FindFirstChild(u105)
    if not v1 then
        v1 = Instance.new("Folder")
        v1.Name = u105
        v1.Parent = workspace
        u93 = v1
    end
    return v1
end

return u49