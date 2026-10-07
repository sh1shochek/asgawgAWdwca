-- ReplicatedStorage.Shared.Zone
-- Script path: ReplicatedStorage.Shared.Zone
-- Decompile time: 14.41 ms

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat
local LocalPlayer = RunService:IsClient()
if LocalPlayer then
    LocalPlayer = Players.LocalPlayer
end
game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local enums = require(script.Enum).enums
local Janitor = require(script.Janitor)
local Signal = require(script.Signal)
local ZonePlusReference = require(script.ZonePlusReference)
local v1 = ZonePlusReference.getObject()
local ZoneController = script.ZoneController
local Tracker = ZoneController.Tracker
local CollectiveWorldModel = ZoneController.CollectiveWorldModel
local u50 = require(ZoneController)
local v2 = if not game:GetService("RunService"):IsClient() then "Server" else "Client"
local v3 = v1 and v1:FindFirstChild(v2)
if v3 then
    return require(v1.Value)
end
local u73 = {}
u73.__index = u73
if not v3 then
    ZonePlusReference.addToReplicatedStorage()
end
u73.enum = enums

function u73.new(a1) -- Line: 34
    -- upvalues: u73 (val), enums (val), Janitor (val), HttpService (val), u50 (val), Signal (val), LocalPlayer (val)
    local v1
    local u146 = {}
    setmetatable(u146, u73)
    local v2 = typeof(a1)
    if v2 ~= "table" and v2 ~= "Instance" then
        error("The zone container must be a model, folder, basepart or table!")
    end
    u146.accuracy = enums.Accuracy.High
    u146.autoUpdate = true
    u146.respectUpdateQueue = true
    local v3 = Janitor.new()
    u146.janitor = v3
    u146._updateConnections = v3:add(Janitor.new(), "destroy")
    u146.container = a1
    u146.zoneParts = {}
    u146.overlapParams = {}
    u146.region = nil
    u146.volume = nil
    u146.boundMin = nil
    u146.boundMax = nil
    u146.recommendedMaxParts = nil
    u146.zoneId = HttpService:GenerateGUID()
    u146.activeTriggers = {}
    u146.occupants = {}
    u146.trackingTouchedTriggers = {}
    u146.enterDetection = enums.Detection.Centre
    u146.exitDetection = enums.Detection.Centre
    u146._currentEnterDetection = nil
    u146._currentExitDetection = nil
    u146.totalPartVolume = 0
    u146.allZonePartsAreBlocks = true
    u146.trackedItems = {}
    u146.settingsGroupName = nil
    u146.worldModel = workspace
    u146.onItemDetails = {}
    u146.itemsToUntrack = {}
    u50.updateDetection(u146)
    u146.updated = v3:add(Signal.new(), "destroy")
    local v4 = {"player", "part", "localPlayer", "item"}
    local v5 = {"entered", "exited"}
    for k, v in pairs(v4) do
        local u131 = 0
        local u132 = 0
        for k2, i in pairs(v5) do
            v1 = v3:add(Signal.new(true), "destroy")
            local u173 = (i:sub(1, 1):upper()) .. i:sub(2)
            u146[v .. u173] = v1
            v1.connectionsChanged:Connect(function(a1) -- Line: 105
                -- upvalues: v (val), LocalPlayer (upval), u173 (val), u132 (ref), u131 (ref), u50 (upval), u146 (val)
                if v == "localPlayer" and not LocalPlayer and a1 == 1 then
                    error(("Can only connect to 'localPlayer%s' on the client!"):format(u173))
                end
                u132 = u131
                u131 = u131 + a1
                if u132 == 0 and u131 > 0 then
                    u50._registerConnection(u146, v, u173)
                    return
                end
                if u132 > 0 and u131 == 0 then
                    u50._deregisterConnection(u146, v)
                end
            end)
        end
    end
    u73.touchedConnectionActions = {}
    for k3, j in pairs(v4) do
        local u123 = u146[("_%sTouchedZone"):format(j)]
        if u123 then
            u146.trackingTouchedTriggers[j] = {}

            u73.touchedConnectionActions[j] = function(a1) -- Line: 129 -- upvalues: u123 (val), u146 (val)
                u123(u146, a1)
            end
        end
    end
    u146:_update()
    u50._registerZone(u146)
    v3:add(function() -- Line: 140 -- upvalues: u50 (upval), u146 (val)
        u50._deregisterZone(u146)
    end, true)
    return u146
end

function u73.fromRegion(a1, a2) -- Line: 147 -- upvalues: u73 (val)
    local createCube
    local Model = Instance.new("Model")

    function createCube(a1, a2) -- Line: 150 -- upvalues: createCube (val), Model (val)
        if not (2024 < a2.X) and not (2024 < a2.Y) and not (2024 < a2.Z) then
            local Part = Instance.new("Part")
            Part.CFrame = a1
            Part.Size = a2
            Part.Anchored = true
            Part.Parent = Model
            return
        end
        local v1 = a2 * 0.25
        local v2 = a2 * 0.5
        createCube(a1 * CFrame.new(-v1.X, -v1.Y, -v1.Z), v2)
        createCube(a1 * CFrame.new(-v1.X, -v1.Y, v1.Z), v2)
        createCube(a1 * CFrame.new(-v1.X, v1.Y, -v1.Z), v2)
        createCube(a1 * CFrame.new(-v1.X, v1.Y, v1.Z), v2)
        createCube(a1 * CFrame.new(v1.X, -v1.Y, -v1.Z), v2)
        createCube(a1 * CFrame.new(v1.X, -v1.Y, v1.Z), v2)
        createCube(a1 * CFrame.new(v1.X, v1.Y, -v1.Z), v2)
        createCube(a1 * CFrame.new(v1.X, v1.Y, v1.Z), v2)
    end

    createCube(a1, a2)
    local v1 = u73.new(Model)
    v1:relocate()
    return v1
end

function u73._calculateRegion(a1, a2, a3) -- Line: 179
    local Components, Components_2, Components_3, v1, v2, v3
    local v4 = {Min = {}, Max = {}}
    for k, v in pairs(v4) do
        v.Values = {}

        function v.parseCheck(a1, a2) -- Line: 183 -- upvalues: k (val)
            if k == "Min" then
                return a1 <= a2
            end
            if k == "Max" then
                return a2 <= a1
            end
        end

        function v:parse(a2) -- Line: 190
            local v1
            for k, v in pairs(a2) do
                v1 = self.Values[k] or v
                if self.parseCheck(v, v1) then
                    self.Values[k] = v
                end
            end
        end
    end
    for k2, i in pairs(a2) do
        v3 = i.Size * 0.5
        for k3, j in pairs({
            i.CFrame * CFrame.new(-v3.X, -v3.Y, -v3.Z),
            i.CFrame * CFrame.new(-v3.X, -v3.Y, v3.Z),
            i.CFrame * CFrame.new(-v3.X, v3.Y, -v3.Z),
            i.CFrame * CFrame.new(-v3.X, v3.Y, v3.Z),
            i.CFrame * CFrame.new(v3.X, -v3.Y, -v3.Z),
            i.CFrame * CFrame.new(v3.X, -v3.Y, v3.Z),
            i.CFrame * CFrame.new(v3.X, v3.Y, -v3.Z),
            i.CFrame * CFrame.new(v3.X, v3.Y, v3.Z),
        }) do
            Components, Components_2, Components_3 = j:GetComponents()
            v2 = {Components, Components_2, Components_3}
            v4.Min:parse(v2)
            v4.Max:parse(v2)
        end
    end
    local v5 = {}
    local v6 = {}

    local function roundToFour(a1) -- Line: 222
        return math.floor((a1 + 2) / 4) * 4
    end

    for k4, k5 in pairs(v4) do
        for k6, n in pairs(k5.Values) do
            v1 = n
            if not a3 then
                v2 = if k4 ~= "Min" then 2 else -2
                v1 = math.floor((n + v2 + 2) / 4) * 4
            end
            table.insert(not (k4 ~= "Min") and v5 or v6, v1)
        end
    end
    local v7 = Vector3.new((unpack(v5)))
    local v8 = Vector3.new((unpack(v6)))
    return Region3.new(v7, v8), v7, v8
end

function u73._displayBounds(a1) -- Line: 245
    if not a1.displayBoundParts then
        local Part
        a1.displayBoundParts = true
        for k, v in pairs({BoundMin = a1.boundMin, BoundMax = a1.boundMax}) do
            Part = Instance.new("Part")
            Part.Anchored = true
            Part.CanCollide = false
            Part.Transparency = 0.5
            Part.Size = Vector3.new(1, 1, 1)
            Part.Color = Color3.fromRGB(255, 0, 0)
            Part.CFrame = CFrame.new(v)
            Part.Name = k
            Part.Parent = workspace
            a1.janitor:add(Part, "Destroy")
        end
    end
end

function u73:_update() -- Line: 264 -- upvalues: RunService (val)
    local CollisionGroup, result, v1
    local container = self.container
    local v2 = {}
    local u245 = 0
    self._updateConnections:clean()
    local v3 = typeof(container)
    local v4 = {}
    if v3 == "table" then
        for k2, i in pairs(container) do
            if i:IsA("BasePart") then
                table.insert(v2, i)
            end
        end
    elseif v3 == "Instance" then
        if not container:IsA("BasePart") then
            table.insert(v4, container)
            for k, v in pairs(container:GetDescendants()) do
                if not v:IsA("BasePart") then
                    table.insert(v4, v)
                else
                    table.insert(v2, v)
                end
            end
        else
            table.insert(v2, container)
        end
    end
    self.zoneParts = v2
    self.overlapParams = {}
    local v5 = true
    for k3, j in pairs(v2) do
        _, result = pcall(function() -- Line: 298 -- upvalues: j (val)
            return j.Shape.Name
        end)
        if result ~= "Block" then
            v5 = false
        end
    end
    self.allZonePartsAreBlocks = v5
    local v6 = OverlapParams.new()
    v6.FilterType = Enum.RaycastFilterType.Include
    v6.MaxParts = #v2
    v6.FilterDescendantsInstances = v2
    self.overlapParams.zonePartsWhitelist = v6
    local v7 = OverlapParams.new()
    v7.FilterType = Enum.RaycastFilterType.Exclude
    v7.FilterDescendantsInstances = v2
    self.overlapParams.zonePartsIgnorelist = v7

    local function update() -- Line: 318 -- upvalues: self (val), u245 (ref), RunService (upval)
        if self.autoUpdate then
            local u8 = os.clock()
            if self.respectUpdateQueue then
                u245 = u245 + 1
                u8 = u8 + 0.1
            end
            local u9 = nil
            local v1 = RunService.Heartbeat:Connect(function() -- Line: 326 -- upvalues: u8 (ref), u9 (ref), self (upval), u245 (upval)
                local v1 = os.clock()
                if u8 <= v1 then
                    u9:Disconnect()
                    if self.respectUpdateQueue then
                        u245 = u245 - 1
                    end
                    if u245 == 0 and self.zoneId then
                        self:_update()
                    end
                end
            end)
        end
    end

    local v8 = {"Size", "Position"}

    local function verifyDefaultCollision(a1) -- Line: 340
        local CollisionGroup = a1.CollisionGroup
        local v1 = true
        if CollisionGroup ~= "Default" then
            v1 = CollisionGroup == "Debris"
        end
        if not v1 then
            error("Zone parts must belong to the 'Default' or 'Debris' CollisionGroup.")
        end
    end

    for k4, k5 in pairs(v2) do
        for k6, n in pairs(v8) do
            self._updateConnections:add((k5:GetPropertyChangedSignal(n)):Connect(update), "Disconnect")
        end
        CollisionGroup = k5.CollisionGroup
        v1 = true
        if CollisionGroup ~= "Default" then
            v1 = CollisionGroup == "Debris"
        end
        if not v1 then
            error("Zone parts must belong to the 'Default' or 'Debris' CollisionGroup.")
        end
        self._updateConnections:add((k5:GetPropertyChangedSignal("CollisionGroupId")):Connect(function() -- Line: 352 -- upvalues: k5 (val)
            local CollisionGroup = k5.CollisionGroup
            local v1 = true
            if CollisionGroup ~= "Default" then
                v1 = CollisionGroup == "Debris"
            end
            if not v1 then
                error("Zone parts must belong to the 'Default' or 'Debris' CollisionGroup.")
            end
        end), "Disconnect")
    end
    local v9 = {"ChildAdded", "ChildRemoved"}
    for k7, m in pairs(v4) do
        for k8, i5 in pairs(v9) do
            self._updateConnections:add(self.container[i5]:Connect(function(a1) -- Line: 359 -- upvalues: self (val), u245 (ref), RunService (upval)
                if a1:IsA("BasePart") and self.autoUpdate then
                    local u13 = os.clock()
                    if self.respectUpdateQueue then
                        u245 = u245 + 1
                        u13 = u13 + 0.1
                    end
                    local u14 = nil
                    local v1 = RunService.Heartbeat:Connect(function() -- Line: 326 -- upvalues: u13 (ref), u14 (ref), self (upval), u245 (upval)
                        local v1 = os.clock()
                        if u13 <= v1 then
                            u14:Disconnect()
                            if self.respectUpdateQueue then
                                u245 = u245 - 1
                            end
                            if u245 == 0 and self.zoneId then
                                self:_update()
                            end
                        end
                    end)
                end
            end), "Disconnect")
        end
    end
    local v10, v11, v12 = self:_calculateRegion(v2)
    local v13 = self:_calculateRegion(v2, true)
    self.region = v10
    self.exactRegion = v13
    self.boundMin = v11
    self.boundMax = v12
    local Size = v10.Size
    self.volume = Size.X * Size.Y * Size.Z
    self:_updateTouchedConnections()
    self.updated:Fire()
end

function u73._updateOccupants(a1, a2, a3) -- Line: 395
    local Character, v1
    local v2 = a1.occupants[a2]
    if not v2 then
        a1.occupants[a2] = {}
    end
    local v3 = {}
    local v4 = a3
    for k, v in pairs(v2) do
        v1 = v4[k]
        if v1 == nil or v1 ~= v then
            v2[k] = nil
            if not v3.exited then
                v3.exited = {}
            end
            table.insert(v3.exited, k)
        end
    end
    for k2, i in pairs(v4) do
        if v2[k2] == nil then
            Character = k2:IsA("Player") and k2.Character or true
            v2[k2] = Character
            if not v3.entered then
                v3.entered = {}
            end
            table.insert(v3.entered, k2)
        end
    end
    return v3
end

function u73._formTouchedConnection(a1, a2) -- Line: 425 -- upvalues: Janitor (val)
    local v1 = "_touchedJanitor" .. a2
    local v2 = a1[v1]
    if not v2 then
        a1[v1] = (a1.janitor:add(Janitor.new(), "destroy"))
    else
        v2:clean()
    end
    a1:_updateTouchedConnection(a2)
end

function u73:_updateTouchedConnection(a2) -- Line: 437
    local v1 = self["_touchedJanitor" .. a2]
    if not v1 then
        return
    end
    for k, v in pairs(self.zoneParts) do
        v1:add(v.Touched:Connect(self.touchedConnectionActions[a2], self), "Disconnect")
    end
end

function u73:_updateTouchedConnections() -- Line: 446
    local v1
    for k, v in pairs(self.touchedConnectionActions) do
        v1 = self["_touchedJanitor" .. k]
        if v1 then
            v1:cleanup()
            self:_updateTouchedConnection(k)
        end
    end
end

function u73._disconnectTouchedConnection(a1, a2) -- Line: 457
    local v1 = "_touchedJanitor" .. a2
    local v2 = a1[v1]
    if v2 then
        v2:cleanup()
        a1[v1] = nil
    end
end

local function round(a1, a2) -- Line: 466
    return (math.round(a1 * 10 ^ a2)) * 10 ^ (-a2)
end

function u73._partTouchedZone(a1, a2) -- Line: 469 -- upvalues: Janitor (val), Heartbeat (val), enums (val)
    local part = a1.trackingTouchedTriggers.part
    if part[a2] then
        return
    end
    local u5 = 0
    local u6 = false
    local Position = a2.Position
    local u9 = os.clock()
    local u17 = a1.janitor:add(Janitor.new(), "destroy")
    part[a2] = u17
    local v1 = {Seat = true, VehicleSeat = true}
    local v2 = {HumanoidRootPart = true}
    if not v1[a2.ClassName] and v2[a2.Name] then
        a2.CanTouch = false
    end
    local u37 = math.round(a2.Size.X * a2.Size.Y * a2.Size.Z * 100000) * 1e-05
    a1.totalPartVolume = a1.totalPartVolume + u37
    u17:add(Heartbeat:Connect(function() -- Line: 487
        -- upvalues: u5 (ref), enums (upval), a1 (val), a2 (val), u6 (ref), Position (ref), u9 (ref), u17 (val)
        local v1 = os.clock()
        if u5 <= v1 then
            local v2 = enums.Accuracy.getProperty(a1.accuracy)
            u5 = v1 + v2
            local v3 = a1:findPoint(a2.CFrame) or a1:findPart(a2)
            if not u6 then
                if v3 then
                    u6 = true
                    a1.partEntered:Fire(a2)
                    return
                end
                if 1.5 < (a2.Position - Position).Magnitude and v2 <= v1 - u9 then
                    u17:cleanup()
                    return
                end
            elseif not v3 then
                u6 = false
                Position = a2.Position
                u9 = os.clock()
                a1.partExited:Fire(a2)
            end
        end
    end), "Disconnect")
    u17:add(function() -- Line: 518 -- upvalues: part (val), a2 (val), a1 (val), u37 (val)
        part[a2] = nil
        a2.CanTouch = true
        a1.totalPartVolume = math.round((a1.totalPartVolume - u37) * 100000) * 1e-05
    end, true)
end

local u118 = {}

function u118.Ball(a1) -- Line: 526
    return "GetPartBoundsInRadius", {a1.Position, a1.Size.X}
end

function u118.Block(a1) -- Line: 529
    return "GetPartBoundsInBox", {a1.CFrame, a1.Size}
end

function u118.Other(a1) -- Line: 532
    return "GetPartsInPart", {a1}
end

function u73:_getRegionConstructor(a2, a3) -- Line: 536 -- upvalues: u118 (val)
    local success, result = pcall(function() -- Line: 537 -- upvalues: a2 (val)
        return a2.Shape.Name
    end)
    local v1 = nil
    local v2 = nil
    if success and self.allZonePartsAreBlocks then
        local v3 = u118[result]
        if v3 then
            local v4, v5 = v3(a2)
            v1 = v4
            v2 = v5
        end
    end
    if not v1 then
        v1 = "GetPartsInPart"
        v2 = {a2}
    end
    if a3 then
        table.insert(v2, a3)
    end
    return v1, v2
end

function u73.findLocalPlayer(a1) -- Line: 557 -- upvalues: LocalPlayer (val)
    if not LocalPlayer then
        error("Can only call 'findLocalPlayer' on the client!")
    end
    return a1:findPlayer(LocalPlayer)
end

function u73:_find(a2, a3) -- Line: 564 -- upvalues: u50 (val)
    u50.updateDetection(self)
    for k, v in pairs((u50.getTouchingZones(a3, false, self._currentEnterDetection, u50.trackers[a2]))) do
        if v == self then
            return true
        end
    end
    return false
end

function u73:findPlayer(a2) -- Line: 576
    local Character = a2.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    return self:_find("player", a2.Character)
end

function u73:findItem(a2) -- Line: 585
    return self:_find("item", a2)
end

function u73:findPart(a2) -- Line: 589
    local v1, v2 = self:_getRegionConstructor(a2, self.overlapParams.zonePartsWhitelist)
    local v3 = self.worldModel[v1](self.worldModel, unpack(v2))
    if #v3 > 0 then
        return true, v3
    end
    return false
end

function u73:getCheckerPart() -- Line: 599 -- upvalues: u50 (val)
    local checkerPart = self.checkerPart
    if not checkerPart then
        checkerPart = self.janitor:add(Instance.new("Part"), "Destroy")
        checkerPart.Size = Vector3.new(0.10000000149011612, 0.10000000149011612, 0.10000000149011612)
        checkerPart.Name = "ZonePlusCheckerPart"
        checkerPart.Anchored = true
        checkerPart.Transparency = 1
        checkerPart.CanCollide = false
        self.checkerPart = checkerPart
    end
    local worldModel = self.worldModel
    if worldModel == workspace then
        worldModel = u50.getWorkspaceContainer()
    end
    if checkerPart.Parent ~= worldModel then
        checkerPart.Parent = worldModel
    end
    return checkerPart
end

function u73:findPoint(a2) -- Line: 620
    local v1 = a2
    if typeof(a2) == "Vector3" then
        v1 = CFrame.new(a2)
    end
    local v2 = self:getCheckerPart()
    v2.CFrame = v1
    local v3, v4 = self:_getRegionConstructor(v2, self.overlapParams.zonePartsWhitelist)
    local v5 = self.worldModel[v3](self.worldModel, unpack(v4))
    if #v5 > 0 then
        return true, v5
    end
    return false
end

function u73:_getAll(a2) -- Line: 637 -- upvalues: u50 (val)
    u50.updateDetection(self)
    local v1 = {}
    local v2 = u50._getZonesAndItems(a2, {self = true}, self.volume, false, self._currentEnterDetection)[self]
    if v2 then
        for k, v in pairs(v2) do
            table.insert(v1, k)
        end
    end
    return v1
end

function u73.getPlayers(a1) -- Line: 650
    return a1:_getAll("player")
end

function u73.getItems(a1) -- Line: 654
    return a1:_getAll("item")
end

function u73.getParts(a1) -- Line: 658
    local v1 = {}
    if a1.activeTriggers.part then
        for k2, i in pairs(a1.trackingTouchedTriggers.part) do
            table.insert(v1, k2)
        end
        return v1
    end
    for k, v in pairs((a1.worldModel:GetPartBoundsInBox(a1.region.CFrame, a1.region.Size, a1.overlapParams.zonePartsIgnorelist))) do
        if a1:findPart(v) then
            table.insert(v1, v)
        end
    end
    return v1
end

function u73.getRandomPoint(a1) -- Line: 679
    local v1, v2, v3, v4
    local exactRegion = a1.exactRegion
    local Size = exactRegion.Size
    local CFrame_2 = exactRegion.CFrame
    local v5 = Random.new()
    local v6 = nil
    repeat
        v4, v1 = a1:findPoint(CFrame_2 * CFrame.new(v5:NextNumber(-Size.X / 2, Size.X / 2), v5:NextNumber(-Size.Y / 2, Size.Y / 2), v5:NextNumber(-Size.Z / 2, Size.Z / 2)))
        v3 = v1
        if v4 then
            v6 = true
        end
    until v6
    return v2.Position, v3
end

function u73.setAccuracy(a1, a2) -- Line: 698 -- upvalues: enums (val)
    local v1 = tonumber(a2)
    if not v1 then
        v1 = enums.Accuracy[a2]
        if not v1 then
            error(("'%s' is an invalid enumName!"):format(a2))
        end
    elseif not enums.Accuracy.getName(v1) then
        error(("%s is an invalid enumId!"):format(v1))
    end
    a1.accuracy = v1
end

function u73.setDetection(a1, a2) -- Line: 714 -- upvalues: enums (val)
    local v1 = tonumber(a2)
    if not v1 then
        v1 = enums.Detection[a2]
        if not v1 then
            error(("'%s' is an invalid enumName!"):format(a2))
        end
    elseif not enums.Detection.getName(v1) then
        error(("%s is an invalid enumId!"):format(v1))
    end
    a1.enterDetection = v1
    a1.exitDetection = v1
end

function u73:trackItem(a2) -- Line: 731 -- upvalues: Janitor (val), Tracker (val)
    local v1 = a2:IsA("BasePart")
    local v2 = false
    if not v1 then
        v2 = a2:FindFirstChild("HumanoidRootPart") ~= nil
    end
    assert(v1 or v2, "Only BaseParts or Characters/NPCs can be tracked!")
    if self.trackedItems[a2] then
        return
    end
    if self.itemsToUntrack[a2] then
        self.itemsToUntrack[a2] = nil
    end
    local v3 = self.janitor:add(Janitor.new(), "destroy")
    local v4 = {janitor = v3, item = a2, isBasePart = v1, isCharacter = v2}
    self.trackedItems[a2] = v4
    v3:add(a2.AncestryChanged:Connect(function() -- Line: 756 -- upvalues: a2 (val), self (val)
        if not a2:IsDescendantOf(game) then
            self:untrackItem(a2)
        end
    end), "Disconnect")
    require(Tracker).itemAdded:Fire(v4)
end

function u73:untrackItem(a2) -- Line: 766 -- upvalues: Tracker (val)
    local v1 = self.trackedItems[a2]
    if v1 then
        v1.janitor:destroy()
    end
    self.trackedItems[a2] = nil
    require(Tracker).itemRemoved:Fire(v1)
end

function u73.bindToGroup(a1, a2) -- Line: 777 -- upvalues: u50 (val)
    a1:unbindFromGroup()
    local v1 = u50.getGroup(a2) or u50.setGroup(a2)
    v1._memberZones[a1.zoneId] = a1
    a1.settingsGroupName = a2
end

function u73:unbindFromGroup() -- Line: 784 -- upvalues: u50 (val)
    if self.settingsGroupName then
        local v1 = u50.getGroup(self.settingsGroupName)
        if v1 then
            v1._memberZones[self.zoneId] = nil
        end
        self.settingsGroupName = nil
    end
end

function u73:relocate() -- Line: 794 -- upvalues: CollectiveWorldModel (val)
    if self.hasRelocated then
        return
    end
    local v1 = require(CollectiveWorldModel).setupWorldModel(self)
    self.worldModel = v1
    self.hasRelocated = true
    local container = self.container
    if typeof(container) == "table" then
        container = Instance.new("Folder")
        for k, v in pairs(self.zoneParts) do
            v.Parent = container
        end
    end
    self.relocationContainer = self.janitor:add(container, "Destroy", "RelocationContainer")
    container.Parent = v1
end

function u73:_onItemCallback(a2, a3, a4, a5) -- Line: 815
    local v1 = self.onItemDetails[a4]
    if not v1 then
        self.onItemDetails[a4] = {}
    end
    if #v1 == 0 then
        self.itemsToUntrack[a4] = true
    end
    table.insert(v1, a4)
    self:trackItem(a4)

    local function triggerCallback() -- Line: 827 -- upvalues: a5 (val), self (val), a4 (val)
        a5()
        if self.itemsToUntrack[a4] then
            self.itemsToUntrack[a4] = nil
            self:untrackItem(a4)
        end
    end

    if self:findItem(a4) ~= a3 then
        local u45 = nil
        local v2 = self[a2]:Connect(function(a1) -- Line: 840 -- upvalues: u45 (ref), a4 (val), a5 (val), self (val)
            if u45 and a1 == a4 then
                u45:Disconnect()
                u45 = nil
                a5()
                if self.itemsToUntrack[a4] then
                    self.itemsToUntrack[a4] = nil
                    self:untrackItem(a4)
                end
            end
        end)
        return
    end
    a5()
    if not self.itemsToUntrack[a4] then
        return
    end
    self.itemsToUntrack[a4] = nil
    self:untrackItem(a4)
end

function u73.onItemEnter(a1, ...) -- Line: 862
    a1:_onItemCallback("itemEntered", true, ...)
end

function u73.onItemExit(a1, ...) -- Line: 866
    a1:_onItemCallback("itemExited", false, ...)
end

function u73:destroy() -- Line: 870
    self:unbindFromGroup()
    self.janitor:destroy()
end

u73.Destroy = u73.destroy
return u73