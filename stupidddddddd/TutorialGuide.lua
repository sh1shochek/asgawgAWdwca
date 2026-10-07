-- ReplicatedStorage.Controllers.TutorialGuide
-- Script path: ReplicatedStorage.Controllers.TutorialGuide
-- Decompile time: 28.64 ms

local v1, v2, v3, v4, v5
local v6 = {}
local HttpService = game:GetService("HttpService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local TutorialZones = require(ReplicatedStorage.Controllers.TutorialZones)
local LocalPlayer = Players.LocalPlayer
local u45 = {3.5, 2}
local u53 = Color3.fromRGB(255, 236, 60)
local u54 = {
    "Characters",
    "TutorialDummies",
    "TutorialEscorts",
    "TutorialRetakers",
    "TutorialCTSquad",
    "TutorialBAttackers",
}
local u61 = {"Range_Entry", "Range_Exit", "Site_Entry", "Site_Exit"}

local function flat(a1) -- Line: 159 -- types: a1: vector
    return (Vector3.new(a1.X, 0, a1.Z))
end

local function flatDistance(a1, a2) -- Line: 163 -- types: a1: vector, a2: vector
    local v1 = a1 - a2
    return Vector3.new(v1.X, 0, v1.Z).Magnitude
end

local u69 = RaycastParams.new()
u69.FilterType = Enum.RaycastFilterType.Exclude
local u71 = nil
local u73 = RaycastParams.new()
u73.FilterType = Enum.RaycastFilterType.Include
local u75 = nil

local function isFloorSlab(a1) -- Line: 178 -- types: a1: userdata
    local Size = a1.Size
    local v1 = false
    if 0.99 < a1.CFrame.UpVector.Y then
        v1 = false
        if Size.Y <= 2 then
            v1 = 300 <= Size.X * Size.Z
        end
    end
    return v1
end

local u77 = {}
local u78 = {}

local function collectLanes(a1) -- Line: 187 -- upvalues: u77 (val), u78 (val) -- types: a1: userdata?
    local LookVector, Position, Unit, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
    table.clear(u77)
    table.clear(u78)
    if not a1 then
        return
    end
    for i, j in a1:GetDescendants() do
        if j:IsA("BasePart")
            and j.Name == "Arrow"
            and not (8 < j.Size.Magnitude)
            and not (j.CFrame.UpVector.Y < 0.99) then
            LookVector = j.CFrame.LookVector
            v8 = Vector3.new(LookVector.X, 0, LookVector.Z)
            if not (v8.Magnitude < 0.5) then
                Unit = v8.Unit
                if Unit.X < -0.5 or (math.abs(Unit.X)) <= 0.5 and Unit.Z < 0 then
                    Unit = -Unit
                end
                Position = j.Position
                v10 = Vector3.new(Position.X, 0, Position.Z)
                v11 = nil
                v1 = u77
                for k, n in v1 do
                    v6 = math.abs((n.Axis:Dot(Unit)))
                    if v6 >= 0.98 then
                        v6 = v10 - n.Origin
                        if (v6 - n.Axis * v6:Dot(n.Axis)).Magnitude <= 2 then
                            v11 = n
                            break
                        end
                    end
                end
                if not v11 then
                    table.insert(u77, {
                        Min = 0,
                        Max = 0,
                        Origin = v10,
                        Axis = Unit,
                        Joins = {},
                    })
                else
                    v1 = (v10 - v11.Origin):Dot(v11.Axis)
                    v11.Min = math.min(v11.Min, v1)
                    v11.Max = math.max(v11.Max, v1)
                end
            end
        end
    end
    local v12 = #u77
    for m = 1, v12 do
        v8 = m + 1
        v7 = #u77
        for i5 = v8, v7 do
            v9 = u77[m]
            v10 = u77[i5]
            v11 = v9.Axis.X * v10.Axis.Z - v9.Axis.Z * v10.Axis.X
            v1 = math.abs(v11)
            if not (v1 < 0.2) then
                v1 = v10.Origin - v9.Origin
                v2 = (v1.X * v10.Axis.Z - v1.Z * v10.Axis.X) / v11
                v3 = (v1.X * v9.Axis.Z - v1.Z * v9.Axis.X) / v11
                if v9.Min - 16 <= v2 and v2 <= v9.Max + 16 and v10.Min - 16 <= v3 and v3 <= v10.Max + 16 then
                    table.insert(u78, v9.Origin + v9.Axis * v2)
                    v4 = #u78
                    table.insert(v9.Joins, {T = v2, Node = v4})
                    table.insert(v10.Joins, {T = v3, Node = v4})
                    v5 = math.min(v9.Min, v2)
                    v6 = math.max(v9.Max, v2)
                    v9.Min = v5
                    v9.Max = v6
                    v5 = math.min(v10.Min, v3)
                    v6 = math.max(v10.Max, v3)
                    v10.Min = v5
                    v10.Max = v6
                end
            end
        end
    end
end

local function refreshFloors(a1) -- Line: 257
    -- upvalues: u75 (ref), collectLanes (val), u73 (val)
    if a1 == u75 then
        return
    end
    u75 = a1
    collectLanes(a1)
    local v1 = {}
    local Zones = a1 and a1:FindFirstChild("Zones")
    if a1 then
        local Size, v2
        for i, j in a1:GetDescendants() do
            if j:IsA("BasePart") and j.CanQuery and j.Transparency < 0.9 then
                if not Zones or not j:IsDescendantOf(Zones) then
                    Size = j.Size
                    v2 = false
                    if 0.99 < j.CFrame.UpVector.Y then
                        v2 = false
                        if Size.Y <= 2 then
                            v2 = 300 <= Size.X * Size.Z
                        end
                    end
                    if v2 then
                        table.insert(v1, j)
                    end
                end
            end
        end
    end
    u73.FilterDescendantsInstances = v1
end

local function refreshIgnore() -- Line: 283
    -- upvalues: refreshFloors (val), u71 (ref), GetRayIgnore (val), u54 (val), u61 (val), u69 (val)
    local v1
    local Map = workspace:FindFirstChild("Map")
    refreshFloors(Map)
    u71 = Map and Map:FindFirstChild("Geometry")
    local v2 = GetRayIgnore()
    for i, j in u54 do
        v1 = workspace:FindFirstChild(j)
        if v1 then
            table.insert(v2, v1)
        end
    end
    local v3 = nil
    local v4 = nil
    for k, n in u61, v3, v4 do
        v1 = u71 and u71:FindFirstChild(n)
        if v1 then
            table.insert(v2, v1)
        end
    end
    u69.FilterDescendantsInstances = v2
end

local function snapToFloor(a1) -- Line: 304 -- upvalues: u73 (val), u71 (ref) -- types: a1: vector
    local v1 = a1 + Vector3.new(0, 3, 0)
    local v2 = workspace:Raycast(v1, Vector3.new(0, -15, 0), u73)
    if not v2 then
        return a1
    end
    local v3 = u71
    local v4 = false
    if v3 ~= nil then
        v4 = v2.Instance:IsDescendantOf(v3)
    end
    return v2.Position + Vector3.new(0, if not v4 then 0 else 0.25, 0)
end

local function isClearLine(a1, a2) -- Line: 316
    -- upvalues: u73 (val), u71 (ref), u69 (val)
    local Instance, v1, v2, v3, v4, v5
    local v6 = a1 + Vector3.new(0, 3, 0)
    local v7 = workspace:Raycast(v6, Vector3.new(0, -15, 0), u73)
    if v7 then
        v3 = u71
        v4 = false
        if v3 ~= nil then
            v4 = v7.Instance:IsDescendantOf(v3)
        end
        v2 = v7.Position + Vector3.new(0, if not v4 then 0 else 0.25, 0)
    else
        v2 = a1
    end
    local v8 = v2 + Vector3.new(0, 2.5999999046325684, 0)
    v3 = a2 + Vector3.new(0, 3, 0)
    v4 = workspace:Raycast(v3, Vector3.new(0, -15, 0), u73)
    if v4 then
        v5 = u71
        local v9 = false
        if v5 ~= nil then
            v9 = v4.Instance:IsDescendantOf(v5)
        end
        v7 = v4.Position + Vector3.new(0, if not v9 then 0 else 0.25, 0)
    else
        v7 = a2
    end
    v2 = v7 + Vector3.new(0, 2.5999999046325684, 0) - v8
    if v2.Magnitude < 0.1 then
        return true
    end
    v6 = CFrame.lookAt(v8, v8 + v2)
    v7 = table.clone(u69.FilterDescendantsInstances)
    local Map = workspace:FindFirstChild("Map")
    local Zones = Map and Map:FindFirstChild("Zones")
    if Zones then
        table.insert(v7, Zones)
    end
    v5 = RaycastParams.new()
    v5.FilterType = Enum.RaycastFilterType.Exclude
    for i = 1, 6 do
        v5.FilterDescendantsInstances = v7
        v1 = workspace:Blockcast(v6, Vector3.new(4.5, 4, 0.20000000298023224), v2, v5)
        if not v1 then
            return true
        end
        Instance = v1.Instance
        if Instance:IsA("BasePart") and not (Instance.Transparency < 0.9) then
            continue
        end
        return false
    end
    return false
end

local function decodeRoute() -- Line: 351 -- upvalues: LocalPlayer (val), HttpService (val)
    local Attribute = LocalPlayer:GetAttribute("TutorialGuide")
    if typeof(Attribute) ~= "string" then
        return nil
    end
    local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
    if success and typeof(result) == "table" and typeof(result.p) == "table" then
        local v1 = {}
        for i, j in result.p do
            if typeof(j) == "table" and typeof(j[1]) == "number" then
                table.insert(v1, (Vector3.new(j[1], j[2], j[3])))
            end
        end
        if #v1 == 0 then
            return nil
        end
        return {
            Points = v1,
            Radius = if typeof(result.r) ~= "number" then 5 else result.r,
            Key = Attribute,
        }
    end
    return nil
end

local function remainingPoints(a1, a2) -- Line: 377 -- types: a1: table, a2: vector
    local v1, v2, v3, v4
    local v5 = #a1
    if v5 <= 1 then
        return table.clone(a1)
    end
    local v6 = Vector3.new(a2.X, 0, a2.Z)
    local v7 = {}
    local v8 = {}
    local v9 = (1 / 0)
    local v10 = v5 - 1
    for i = 1, v10 do
        v2 = a1[i]
        v1 = Vector3.new(v2.X, 0, v2.Z)
        v2 = a1[i + 1]
        v2 = Vector3.new(v2.X, 0, v2.Z) - v1
        v3 = v2:Dot(v2)
        v4 = if not (v3 > 1e-06) then 0 else (v6 - v1):Dot(v2) / v3
        v7[i] = (v6 - (v1 + v2 * math.clamp(v4, 0, 1))).Magnitude
        v8[i] = v4
        v9 = math.min(v9, v7[i])
    end
    v10 = 1
    for j = v5 - 1, 1, -1 do
        if v7[j] <= v9 + 2 then
            v10 = j
            break
        end
    end
    local v11 = v10 + 1
    if v10 ~= 1 then
        if 1 <= v8[v10] then
            v11 = v10 + 2
        end
    elseif v8[1] <= 0 then
        v11 = 1
    elseif 1 <= v8[v10] then
        v11 = v10 + 2
    end
    v11 = math.min(v11, v5)
    return table.move(a1, v11, v5, 1, {})
end

local function computePath(a1, a2) -- Line: 418
    -- upvalues: u45 (val), PathfindingService (val)
    local v1, v2
    for i, j in u45 do
        v2 = {AgentHeight = 5, AgentCanJump = true, WaypointSpacing = 4, AgentRadius = j}
        v1 = PathfindingService:CreatePath(v2)
        if pcall(v1.ComputeAsync, v1, a1, a2) and v1.Status == Enum.PathStatus.Success then
            v2 = {}
            for k, n in v1:GetWaypoints() do
                table.insert(v2, n.Position)
            end
            return v2
        end
    end
    return nil
end

local function lanePath(a1, a2) -- Line: 443
    -- upvalues: u77 (val), u78 (val), isClearLine (val)
    local Magnitude, X_9, Y_2, Z, v1, v2, v3, v4, v5, v6, v7, v8
    if #u77 == 0 then
        return nil
    end
    local v9 = {
        Vector3.new(a1.X, 0, a1.Z),
        (Vector3.new(a2.X, 0, a2.Z)),
    }
    for i, j in u78 do
        v9[i + 2] = j
    end
    local u319 = {}

    local function link(a1, a2, a3) -- Line: 453 -- upvalues: u319 (val) -- types: a1: number, a2: number, a3: number
        local v1 = u319[a1] or {}
        u319[a1] = v1
        table.insert(u319[a1], {a2, a3})
        v1 = u319[a2] or {}
        u319[a2] = v1
        table.insert(u319[a2], {a1, a3})
    end

    local v10 = a1 - a2
    link(1, 2, Vector3.new(v10.X, 0, v10.Z).Magnitude * 1.6)
    local v11 = nil
    local v12 = nil
    local v13, v14 = a1, a2
    for k, n in u77, v11, v12 do
        v10 = {}
        for m, i5 in n.Joins do
            table.insert(v10, {T = i5.T, Node = i5.Node + 2})
        end
        v1 = {v13, v14}
        v2 = nil
        v3 = nil
        for i6, i7 in v1, v2, v3 do
            v4 = math.clamp(((Vector3.new(i7.X, 0, i7.Z)) - n.Origin):Dot(n.Axis), n.Min, n.Max)
            v5 = n.Origin + n.Axis * v4
            v6 = i7 - v5
            Magnitude = Vector3.new(v6.X, 0, v6.Z).Magnitude
            if Magnitude <= 30 then
                if Magnitude < 1 then
                    table.insert(v9, v5)
                    table.insert(v10, {T = v4, Node = #v9})
                    link(i6, #v9, Magnitude * 1.6)
                else
                    v6 = isClearLine
                    X_9 = v5.X
                    Y_2 = i7.Y
                    Z = v5.Z
                    if v6(i7, (Vector3.new(X_9, Y_2, Z))) then
                        table.insert(v9, v5)
                        table.insert(v10, {T = v4, Node = #v9})
                        link(i6, #v9, Magnitude * 1.6)
                    end
                end
            end
        end
        table.sort(v10, function(a1, a2) -- Line: 478
            return a1.T < a2.T
        end)
        v1 = #v10
        for i8 = 2, v1 do
            link(v10[i8 - 1].Node, v10[i8].Node, v10[i8].T - v10[i8 - 1].T)
        end
    end
    local v15 = {0}
    v11 = {}
    v12 = {}
    while true do
        v7 = nil
        v8 = (1 / 0)
        for i9, i10 in v15 do
            if not v12[i9] and i10 < v8 then
                v7 = i9
                v8 = i10
            end
        end
        if v7 == nil or v7 == 2 then
            break
        end
        v12[v7] = true
        v10 = u319[v7]
        if v10 then
            for i11, i12 in v10 do
                v4 = i12[1]
                v5 = v8 + i12[2]
                if v5 < (v15[v4] or (1 / 0)) then
                    v15[v4] = v5
                    v11[v4] = v7
                end
            end
        end
    end
    if v11[2] ~= nil and v11[2] ~= 1 then
        v7 = {v14}
        v8 = v11[2]
        while v8 do
            if v8 == 1 then
                break
            end
            v10 = Vector3.new(v9[v8].X, v13.Y, v9[v8].Z)
            v3 = v10 - v7[1]
            if 0.5 < Vector3.new(v3.X, 0, v3.Z).Magnitude then
                table.insert(v7, 1, v10)
            end
            v8 = v11[v8]
        end
        v2 = v13 - v7[1]
        if 0.5 < Vector3.new(v2.X, 0, v2.Z).Magnitude then
            table.insert(v7, 1, v13)
            return v7
        end
        v7[1] = v13
        return v7
    end
    return nil
end

local function walkLeg(a1, a2) -- Line: 534
    -- upvalues: lanePath (val), isClearLine (val), u73 (val), u71 (ref), computePath (val)
    local v1, v2, v3, v4
    local v5 = lanePath(a1, a2)
    if v5 then
        return v5
    end
    if isClearLine(a1, a2) then
        return {a1, a2}
    end
    local v6 = a1 + Vector3.new(0, 3, 0)
    local v7 = workspace:Raycast(v6, Vector3.new(0, -15, 0), u73)
    if v7 then
        v3 = u71
        v4 = false
        if v3 ~= nil then
            v4 = v7.Instance:IsDescendantOf(v3)
        end
        v1 = v7.Position + Vector3.new(0, if not v4 then 0 else 0.25, 0)
    else
        v1 = a1
    end
    v6 = a2 + Vector3.new(0, 3, 0)
    v7 = workspace:Raycast(v6, Vector3.new(0, -15, 0), u73)
    if v7 then
        v3 = u71
        v4 = false
        if v3 ~= nil then
            v4 = v7.Instance:IsDescendantOf(v3)
        end
        v2 = v7.Position + Vector3.new(0, if not v4 then 0 else 0.25, 0)
    else
        v2 = a2
    end
    v6 = computePath(v1, v2)
    if not v6 then
        v3 = a1 - a2
        v7 = Vector3.new(v3.X, 0, v3.Z)
        if 3 < v7.Magnitude then
            local v8
            local v9 = a2 + v7.Unit * 3
            local v10 = v9 + Vector3.new(0, 3, 0)
            local v11 = workspace:Raycast(v10, Vector3.new(0, -15, 0), u73)
            if v11 then
                local v12 = u71
                local v13 = false
                if v12 ~= nil then
                    v13 = v11.Instance:IsDescendantOf(v12)
                end
                v8 = v11.Position + Vector3.new(0, if not v13 then 0 else 0.25, 0)
            else
                v8 = v9
            end
            v6 = computePath(v1, v8)
            if v6 then
                table.insert(v6, a2)
            end
        end
    end
    if not v6 then
        return {a1, a2}
    end
    v6[1] = a1
    return v6
end

local function simplify(a1) -- Line: 562 -- types: a1: table
    local Magnitude, Magnitude_2, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
    if #a1 < 3 then
        return a1
    end
    local v12 = table.create(#a1, false)
    local v13 = #a1
    v12[1] = true
    v12[v13] = true
    v13 = {{1, #a1}}
    local v14 = a1
    while #v13 > 0 do
        v7 = table.remove(v13)
        v8 = v7[1]
        v9 = v7[2]
        v11 = v14[v8]
        v10 = Vector3.new(v11.X, 0, v11.Z)
        v11 = v14[v9]
        v11 = Vector3.new(v11.X, 0, v11.Z) - v10
        Magnitude = v11.Magnitude
        v1 = 0
        v2 = 0
        v4 = v8 + 1
        v3 = v9 - 1
        for i = v4, v3 do
            v6 = v14[i]
            v5 = Vector3.new(v6.X, 0, v6.Z)
            Magnitude_2 = if not (Magnitude > 0.001) then (v5 - v10).Magnitude else v11:Cross(v5 - v10).Magnitude / Magnitude
            if v1 < Magnitude_2 then
                v1 = Magnitude_2
                v2 = i
            end
        end
        if v1 > 0.5 then
            v12[v2] = true
            table.insert(v13, {v8, v2})
            table.insert(v13, {v2, v9})
        end
    end
    v7 = {}
    for j, k in v14 do
        if v12[j] then
            table.insert(v7, k)
        end
    end
    return v7
end

local function roundCorners(a1) -- Line: 600 -- upvalues: isClearLine (val) -- types: a1: table
    local Magnitude, Magnitude_2, v1, v2, v3, v4, v5, v6, v7
    local v8 = a1
    for i = 1, 2 do
        if #v8 < 3 then
            return v8
        end
        v5 = {v8[1]}
        v6 = #v8 - 1
        for j = 2, v6 do
            v7 = v8[j - 1]
            v1 = v8[j]
            v2 = v8[j + 1]
            Magnitude = (v1 - v7).Magnitude
            Magnitude_2 = (v2 - v1).Magnitude
            if Magnitude < 0.001 then
                table.insert(v5, v1)
            elseif not (Magnitude_2 < 0.001) then
                v3 = v1:Lerp(v7, (math.min(Magnitude * 0.25, 2)) / Magnitude)
                v4 = v1:Lerp(v2, (math.min(Magnitude_2 * 0.25, 2)) / Magnitude_2)
                if not isClearLine(v3, v4) then
                    table.insert(v5, v1)
                else
                    table.insert(v5, v3)
                    table.insert(v5, v4)
                end
            else
                table.insert(v5, v1)
            end
        end
        table.insert(v5, v8[#v8])
        v8 = v5
    end
    return v8
end

local function knotGap(a1, a2) -- Line: 629 -- types: a1: vector, a2: vector
    local v1 = a1 - a2
    return (math.max(Vector3.new(v1.X, 0, v1.Z).Magnitude ^ 0.5, 0.0001))
end

local function spline(a1) -- Line: 634 -- types: a1: table
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
    local v17 = #a1
    if v17 < 2 then
        return a1
    end
    local v18 = {a1[1]}
    local v19 = v17 - 1
    local v20 = a1
    for i = 1, v19 do
        v13 = v20[i]
        v14 = v20[i + 1]
        v15 = if i <= 1 then v13 + (v13 - v14) else v20[i - 1]
        v16 = if not (i + 2 <= v17) then v14 + (v14 - v13) else v20[i + 2]
        v4 = v15 - v13
        v1 = math.max(Vector3.new(v4.X, 0, v4.Z).Magnitude ^ 0.5, 0.0001)
        v5 = v13 - v14
        v2 = v1 + math.max(Vector3.new(v5.X, 0, v5.Z).Magnitude ^ 0.5, 0.0001)
        v6 = v14 - v16
        v3 = v2 + math.max(Vector3.new(v6.X, 0, v6.Z).Magnitude ^ 0.5, 0.0001)
        v8 = v13 - v14
        v4 = math.max(1, (math.ceil((Vector3.new(v8.X, 0, v8.Z)).Magnitude / 0.5)))
        for j = 1, v4 do
            v7 = v1 + (v2 - v1) * (j / v4)
            v8 = v15 * ((v1 - v7) / v1) + v13 * (v7 / v1)
            v9 = v13 * ((v2 - v7) / (v2 - v1)) + v14 * ((v7 - v1) / (v2 - v1))
            v10 = v14 * ((v3 - v7) / (v3 - v2)) + v16 * ((v7 - v2) / (v3 - v2))
            v11 = v8 * ((v2 - v7) / v2) + v9 * (v7 / v2)
            v12 = v9 * ((v3 - v7) / (v3 - v1)) + v10 * ((v7 - v1) / (v3 - v1))
            table.insert(v18, v11 * ((v2 - v7) / (v2 - v1)) + v12 * ((v7 - v1) / (v2 - v1)))
        end
    end
    return v18
end

local function resample(a1) -- Line: 663 -- types: a1: table
    local Magnitude, v1, v2, v3
    local v4 = {a1[1]}
    local v5 = 0
    local v6 = 0
    local v7 = #a1
    for i = 2, v7 do
        v2 = a1[i - 1]
        v3 = a1[i]
        v1 = v2 - v3
        Magnitude = Vector3.new(v1.X, 0, v1.Z).Magnitude
        if not (Magnitude < 0.001) then
            v1 = 0.5 - v6
            while v1 <= Magnitude do
                table.insert(v4, (v2:Lerp(v3, v1 / Magnitude)))
                v1 = v1 + 0.5
            end
            v6 = Magnitude - (v1 - 0.5)
            v5 = v5 + Magnitude
        end
    end
    v2 = v4[#v4] - a1[#a1]
    if 0.01 < Vector3.new(v2.X, 0, v2.Z).Magnitude then
        table.insert(v4, a1[#a1])
    end
    return v4, v5
end

local function sampleCurve(a1, a2) -- Line: 688 -- types: a1: table, a2: number
    local v1 = a2 / 0.5 + 1
    local v2 = math.clamp(math.floor(v1), 1, #a1)
    local v3 = math.min(v2 + 1, #a1)
    local v4 = a1[v2]:Lerp(a1[v3], v1 - (math.floor(v1)))
    local v5 = a1[math.max(v2 - 1, 1)]
    local v6 = a1[math.min(v2 + 2, #a1)] - v5
    return v4, (Vector3.new(v6.X, 0, v6.Z))
end

local u95 = {}
for i, j in {1, -1} do
    v1 = Vector3.new(j * 0.6691306063588582, 0, 0.7431448254773942)
    v2 = Vector3.new(-j * 0.7431448254773942, 0, 0.6691306063588582)
    v3 = Vector3.new(0, 0, -0.8360379338264465) + v1 * 0.6996858843423915
    v4 = v3 + v2 * 0.315 - v1 * 0.34984294217119577
    table.insert(u95, {
        ClassName = "WedgePart",
        Size = Vector3.new(0.05000000074505806, 0.6299999952316284, 0.6996858716011047),
        Offset = CFrame.fromMatrix(v4, v2:Cross(v1), v2, v1),
    })
    v5 = v3 + v1 * 0.7751570578288043 + v2 * 0.315
    table.insert(u95, {
        ClassName = "Part",
        Size = Vector3.new(0.6299999952316284, 0.05000000074505806, 1.5503140687942505),
        Offset = CFrame.fromMatrix(v5, v2, (Vector3.new(0, 1, 0))),
    })
end
local u108 = nil
local u109 = {}

local function ensureFolder() -- Line: 734 -- upvalues: u108 (ref), u109 (val)
    if u108 and u108.Parent then
        return u108
    end
    local Folder = Instance.new("Folder")
    Folder.Name = "TutorialGuide"
    Folder.Parent = workspace.CurrentCamera
    u108 = Folder
    table.clear(u109)
    return Folder
end

local function newPart(a1) -- Line: 746 -- upvalues: u53 (val), u108 (ref), u109 (val) -- types: a1: string?
    local v1
    local v2 = Instance.new(a1 or "Part")
    v2.Anchored = true
    v2.CanCollide = false
    v2.CanQuery = false
    v2.CanTouch = false
    v2.CastShadow = false
    v2.Material = Enum.Material.Neon
    v2.Color = u53
    v2.Transparency = 1
    if not u108 or not u108.Parent then
        local Folder = Instance.new("Folder")
        Folder.Name = "TutorialGuide"
        Folder.Parent = workspace.CurrentCamera
        u108 = Folder
        table.clear(u109)
        v1 = Folder
    else
        v1 = u108
    end
    v2.Parent = v1
    return v2
end

local function getChevron(a1) -- Line: 760
    -- upvalues: u108 (ref), u109 (val), u95 (val), u53 (val)
    local Folder_2, v1, v2
    if not u108 or not u108.Parent then
        local Folder = Instance.new("Folder")
        Folder.Name = "TutorialGuide"
        Folder.Parent = workspace.CurrentCamera
        u108 = Folder
        table.clear(u109)
    end
    local v3 = u109[a1]
    if v3 then
        return v3
    end
    local v4 = {}
    local v5 = nil
    local v6 = nil
    for i, j in u95, v5, v6 do
        v2 = Instance.new(j.ClassName or "Part")
        v2.Anchored = true
        v2.CanCollide = false
        v2.CanQuery = false
        v2.CanTouch = false
        v2.CastShadow = false
        v2.Material = Enum.Material.Neon
        v2.Color = u53
        v2.Transparency = 1
        if not u108 or not u108.Parent then
            Folder_2 = Instance.new("Folder")
            Folder_2.Name = "TutorialGuide"
            Folder_2.Parent = workspace.CurrentCamera
            u108 = Folder_2
            table.clear(u109)
            v1 = Folder_2
        else
            v1 = u108
        end
        v2.Parent = v1
        v2.Size = j.Size
        table.insert(v4, v2)
    end
    local v7 = {
        Along = 0,
        Traveled = 0,
        Stop = 0,
        Active = false,
        Transparency = 1,
        Parts = v4,
    }
    u109[a1] = v7
    return v7
end

local function setChevronTransparency(a1, a2) -- Line: 778 -- types: a1: table, a2: number
    if a1.Transparency == a2 then
        return
    end
    if (math.abs(a1.Transparency - a2)) < 0.02 and a2 ~= 1 then
        return
    end
    a1.Transparency = a2
    for i, j in a1.Parts do
        j.Transparency = a2
    end
end

local u116 = {}
local u117 = {}

local function placeChevron(a1, a2, a3) -- Line: 795
    -- upvalues: u95 (val), u116 (val), u117 (val)
    local v1 = (CFrame.lookAt(a2, a2 + a3)) * CFrame.new(0, 0.05, 0)
    for i, j in u95 do
        table.insert(u116, a1.Parts[i])
        table.insert(u117, v1 * j.Offset)
    end
end

local function hideParts() -- Line: 803 -- upvalues: u109 (val)
    local v1 = nil
    local v2 = nil
    for i, j in u109, v1, v2 do
        j.Active = false
        if j.Transparency ~= 1 then
            if (math.abs(j.Transparency - 1)) < 0.02 then end
            j.Transparency = 1
            for k, n in j.Parts do
                n.Transparency = 1
            end
        end
    end
end

local u120 = 0

local function buildTrail(a1, a2, a3) -- Line: 816
    -- upvalues: refreshIgnore (val), remainingPoints (val), walkLeg (val), u120 (ref), u69 (val), u73 (val), u71 (ref)
    -- upvalues: resample (val), spline (val), roundCorners (val), simplify (val)
    local v1, v2, v3, v4, v5, v6, v7
    refreshIgnore()
    local v8 = {a2}
    local v9 = (remainingPoints(a1.Points, a2))
    local v10 = nil
    local v11 = nil
    local v12, v13 = a3, a2
    for i, j in v9, v10, v11 do
        v2 = walkLeg(a2, j)
        v3 = #v2
        for k = 2, v3 do
            table.insert(v8, v2[k])
        end
    end
    if v12 ~= u120 then
        return nil
    end
    v9 = #v8
    for n = 2, v9 do
        v1 = v8[n] - v13
        v7 = Vector3.new(v1.X, 0, v1.Z)
        if 0.5 < v7.Magnitude then
            v1 = -v7.Unit * 6
            v2 = workspace:Raycast(v13, v1, u69)
            if not ((if not v2 then 6 else math.max(v2.Distance - 0.5, 0)) > 0.5) then
                break
            end
            table.insert(v8, 1, v13 + v1.Unit * v3)
            break
        end
    end
    v10 = nil
    v11 = nil
    for m, i5 in v8, v10, v11 do
        v3 = i5 + Vector3.new(0, 3, 0)
        v4 = workspace:Raycast(v3, Vector3.new(0, -15, 0), u73)
        if v4 then
            v5 = u71
            v6 = false
            if v5 ~= nil then
                v6 = v4.Instance:IsDescendantOf(v5)
            end
            v2 = v4.Position + Vector3.new(0, if not v6 then 0 else 0.25, 0)
        else
            v2 = i5
        end
        v8[m] = v2
    end
    v9, v10 = resample((spline((roundCorners((simplify(v8)))))))
    if #v9 < 2 then
        return nil
    end
    return {Dense = v9, Total = v10, Floor = {}}
end

local function floorSample(a1, a2) -- Line: 860 -- upvalues: u73 (val), u71 (ref) -- types: a1: table, a2: number
    local v1
    local v2 = a1.Floor[a2]
    if v2 then
        return v2
    end
    local v3 = a1.Dense[a2]
    local v4 = v3 + Vector3.new(0, 3, 0)
    local v5 = workspace:Raycast(v4, Vector3.new(0, -15, 0), u73)
    if v5 then
        local v6 = u71
        local v7 = false
        if v6 ~= nil then
            v7 = v5.Instance:IsDescendantOf(v6)
        end
        v1 = v5.Position + Vector3.new(0, if not v7 then 0 else 0.25, 0)
    else
        v1 = v3
    end
    a1.Floor[a2] = v1
    return v1
end

local function floorPointAt(a1, a2) -- Line: 871
    -- upvalues: sampleCurve (val), u73 (val), u71 (ref)
    local v1, v2, v3, v4, v5, v6, v7, v8
    _, v6 = sampleCurve(a1.Dense, a2)
    local v9 = a2 / 0.5 + 1
    local v10 = math.clamp(math.floor(v9), 1, #a1.Dense)
    local v11 = math.min(v10 + 1, #a1.Dense)
    local v12 = a1.Floor[v10]
    if not v12 then
        v1 = a1.Dense[v10]
        v2 = v1 + Vector3.new(0, 3, 0)
        v3 = workspace:Raycast(v2, Vector3.new(0, -15, 0), u73)
        if v3 then
            v4 = u71
            v5 = false
            if v4 ~= nil then
                v5 = v3.Instance:IsDescendantOf(v4)
            end
            v8 = v3.Position + Vector3.new(0, if not v5 then 0 else 0.25, 0)
        else
            v8 = v1
        end
        a1.Floor[v10] = v8
        v7 = v8
    else
        v7 = v12
    end
    v1 = a1.Floor[v11]
    if not v1 then
        v3 = a1.Dense[v11]
        v4 = v3 + Vector3.new(0, 3, 0)
        v5 = workspace:Raycast(v4, Vector3.new(0, -15, 0), u73)
        if v5 then
            local v13 = u71
            local v14 = false
            if v13 ~= nil then
                v14 = v5.Instance:IsDescendantOf(v13)
            end
            v2 = v5.Position + Vector3.new(0, if not v14 then 0 else 0.25, 0)
        else
            v2 = v3
        end
        a1.Floor[v11] = v2
        v8 = v2
    else
        v8 = v1
    end
    return v7:Lerp(v8, v9 - (math.floor(v9))), v6
end

local function projectOnto(a1, a2, a3) -- Line: 881 -- types: a1: table, a2: vector, a3: number
    local Dense = a1.Dense

    local function search(a1, a2_2) -- Line: 883 -- upvalues: Dense (val), a2 (val) -- types: a1: number, a2_2: number
        local Magnitude, v1
        local v2 = (1 / 0)
        local v3 = a1
        for i = a1, a2_2 do
            v1 = Dense[i] - a2
            Magnitude = Vector3.new(v1.X, 0, v1.Z).Magnitude
            if Magnitude < v2 then
                v2 = Magnitude
                v3 = i
            end
        end
        return v3, v2
    end

    local v1, v2 = search(math.max(1, a3 - 80), (math.min(#Dense, a3 + 80)))
    if v2 > 7 then
        local v3, v4 = search(1, #Dense)
        v1 = v3
        v2 = v4
    end
    return (v1 - 1) * 0.5, v2, v1
end

local u136 = nil
local u137 = nil
local u138 = nil
local u139 = 0
local u140 = 0
local u141 = 1
local u142 = 0
local u143 = false
local u144 = true
local u145 = 0
local u146 = false

local function freeChevron() -- Line: 918 -- upvalues: u109 (val), getChevron (val)
    for i, j in u109 do
        if not j.Active then
            return j
        end
    end
    return (getChevron(#u109 + 1))
end

local function spawnGroup(a1) -- Line: 928 -- upvalues: u139 (ref), u109 (val), getChevron (val) -- types: a1: table
    local v1, v2
    local v3 = math.max(u139 - 6, 0)
    local v4 = a1.Total - 3
    local v5 = a1
    for i = 1, 3 do
        v1 = v3 + (3 - i) * 2.6
        if 2 <= v4 - v1 then
            for j, k in u109 do
                if not k.Active then
                    k.Active = true
                    v2.Trail = v5
                    v2.Along = v1
                    v2.Traveled = 0
                    v2.Stop = v4
                    break
                end
            end
            v2 = getChevron(#u109 + 1)
            v2.Active = true
            v2.Trail = v5
            v2.Along = v1
            v2.Traveled = 0
            v2.Stop = v4
        end
    end
end

local function draw(a1) -- Line: 942
    -- upvalues: u142 (ref), u143 (ref), u139 (ref), u140 (ref), u137 (ref), u144 (ref), u109 (val), u145 (ref)
    -- upvalues: u146 (ref), u116 (val), u117 (val), floorPointAt (val), placeChevron (val)
    local v1, v2
    u142 = math.clamp(u142 + (if not u143 then -a1 else a1) * 3, 0, 1)
    u139 = u139 + (u140 - u139) * math.min(1, a1 * 12)
    local v3 = u137
    if not (u142 <= 0) and v3 then
        local Trail, v4, v5, v6, v7, v8, v9
        u144 = false
        if u143 and not u146 then
            u145 = u145 + a1
            if u145 >= 1 then
                u146 = true
            end
        end
        table.clear(u116)
        table.clear(u117)
        v1 = nil
        v2 = nil
        for i, j in u109, v1, v2 do
            Trail = j.Trail
            if j.Active and Trail then
                v8 = a1 * 15
                j.Along = j.Along + v8
                j.Traveled = j.Traveled + v8
                v9 = j.Stop - j.Along
                if not (v9 <= 0) then
                    v4 = (math.clamp(j.Traveled / 2, 0, 1)) * math.clamp(v9 / 6, 0, 1) * u142
                    v5, v6 = floorPointAt(Trail, j.Along)
                    if 0.01 < v6.Magnitude then
                        placeChevron(j, v5, v6.Unit)
                    end
                    v7 = math.floor((1 - v4) / 0.02 + 0.5) * 0.02
                    if j.Transparency ~= v7 then
                        if not ((math.abs(j.Transparency - v7)) < 0.02) then
                            j.Transparency = v7
                            for k, n in j.Parts do
                                n.Transparency = v7
                            end
                        elseif v7 == 1 then
                            j.Transparency = v7
                            for m, i5 in j.Parts do
                                i5.Transparency = v7
                            end
                        end
                    end
                else
                    j.Active = false
                    if j.Transparency ~= 1 then
                        if (math.abs(j.Transparency - 1)) < 0.02 then end
                        j.Transparency = 1
                        for i6, i7 in j.Parts do
                            i7.Transparency = 1
                        end
                    end
                end
            end
        end
        if #u116 > 0 then
            workspace:BulkMoveTo(u116, u117, Enum.BulkMoveMode.FireCFrameChanged)
        end
        return
    end
    if not u144 then
        u144 = true
        v1 = nil
        v2 = nil
        for i8, i9 in u109, v1, v2 do
            i9.Active = false
            if i9.Transparency ~= 1 then
                if (math.abs(i9.Transparency - 1)) < 0.02 then end
                i9.Transparency = 1
                for i10, i11 in i9.Parts do
                    i11.Transparency = 1
                end
            end
        end
    end
    u145 = 1
end

local u150 = false

local function prewarm() -- Line: 997 -- upvalues: u150 (ref), getChevron (val)
    if u150 then
        return
    end
    u150 = true
    for i = 1, 24 do
        getChevron(i)
        if i % 4 == 0 then
            task.wait()
        end
    end
end

local function track(a1) -- Line: 1010
    -- upvalues: u120 (ref), u136 (ref), CharacterResolver (val), u143 (ref), TutorialZones (val), u137 (ref)
    -- upvalues: u146 (ref), projectOnto (val), u141 (ref), u140 (ref), prewarm (val), buildTrail (val), u145 (ref)
    -- upvalues: u139 (ref), spawnGroup (val)
    local Magnitude, Position_2, search, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
    local v13 = nil
    local v14 = false
    local v15 = a1
    while v15 == u120 do
        v8 = u136
        v9 = CharacterResolver.getLocalCharacter()
        v10 = v9 and CharacterResolver.getRootPart(v9)
        if v8 and v10 and CharacterResolver.isAliveCharacter(v9) then
            Position_2 = v10.Position
            v12 = Position_2 - v8.Points[#v8.Points]
            Magnitude = Vector3.new(v12.X, 0, v12.Z).Magnitude
            v11 = TutorialZones.IsInside(Position_2)
            if not v11 then
                v11 = true
                if not (Magnitude <= v8.Radius) then
                    v11 = v14 and Magnitude <= math.max(v8.Radius * 1.6, 20)
                end
            end
            if v11 then
                u143 = false
                u137 = nil
                task.wait(0.1)
                continue
            end
            v11 = u137
            v12 = true
            if v11 ~= nil then
                v12 = u146
            end
            if v11 then
                v1, v2, v3 = projectOnto(v11, Position_2, u141)
                u140 = v1
                u141 = v3
                if v2 > 7 then
                    v13 = v13 or os.clock()
                    v12 = 0.75 <= os.clock() - v13
                end
            end
            if v12 then
                prewarm()
                if v15 ~= u120 then
                    return
                end
                v1 = buildTrail(v8, Position_2, v15)
                if v15 ~= u120 then
                    return
                end
                u137 = v1
                u146 = false
                u145 = 0
                u141 = 1
                u139 = 0
                u140 = 0
                if v1 then
                    local Position = v10.Position
                    local Dense = v1.Dense

                    function search(a1, a2) -- Line: 883
                        -- upvalues: Dense (val), Position (val)
                        local Magnitude, v1
                        local v2 = (1 / 0)
                        local v3 = a1
                        for i = a1, a2 do
                            v1 = Dense[i] - Position
                            Magnitude = Vector3.new(v1.X, 0, v1.Z).Magnitude
                            if Magnitude < v2 then
                                v2 = Magnitude
                                v3 = i
                            end
                        end
                        return v3, v2
                    end

                    v4, v5 = search(1, (math.min(#Dense, 81)))
                    if v5 > 7 then
                        v6, v7 = search(1, #Dense)
                        v4 = v6
                    end
                    v2 = (v4 - 1) * 0.5
                    u141 = v4
                    u139 = v2
                    u140 = v2
                    spawnGroup(v1)
                end
            end
            u143 = u137 ~= nil
            task.wait(0.1)
            continue
        end
        u143 = false
        task.wait(0.1)
    end
end

local function sync() -- Line: 1078
    -- upvalues: IsTutorialMode (val), decodeRoute (val), u136 (ref), u120 (ref), u137 (ref), u143 (ref), u142 (ref)
    -- upvalues: u144 (ref), u109 (val), u138 (ref), RunServiceController (val), draw (val), track (val)
    local v1 = if not IsTutorialMode() then nil else decodeRoute()
    if v1 and u136 and v1.Key == u136.Key then
        return
    end
    u120 = u120 + 1
    u136 = v1
    u137 = nil
    if not v1 then
        u143 = false
        return
    end
    u142 = 0
    u144 = true
    local v2 = nil
    local v3 = nil
    for i, j in u109, v2, v3 do
        j.Active = false
        if j.Transparency ~= 1 then
            if (math.abs(j.Transparency - 1)) < 0.02 then end
            j.Transparency = 1
            for k, n in j.Parts do
                n.Transparency = 1
            end
        end
    end
    if not u138 then
        u138 = RunServiceController.BindToHeartbeat("TutorialGuide.Draw", draw)
    end
    task.spawn(track, u120)
end

function v6.Start() -- Line: 1100 -- upvalues: LocalPlayer (val), sync (val)
    (LocalPlayer:GetAttributeChangedSignal("TutorialGuide")):Connect(sync)
    sync()
end

return v6