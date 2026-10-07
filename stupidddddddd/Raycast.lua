-- ReplicatedStorage.Shared.Raycast
-- Script path: ReplicatedStorage.Shared.Raycast
-- Decompile time: 4.59 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Sift = require((ReplicatedStorage:WaitForChild("Packages")):WaitForChild("Sift"))
local u23 = table.freeze({Reactor = -1})
local u28 = table.freeze({["Sandy Brick"] = 0, IndoorWall = 0})
local u107 = table.freeze({
    [Enum.Material.Asphalt] = 0,
    [Enum.Material.Basalt] = 0,
    [Enum.Material.Brick] = 0,
    [Enum.Material.Cobblestone] = 0,
    [Enum.Material.Concrete] = 0,
    [Enum.Material.CrackedLava] = 0,
    [Enum.Material.DiamondPlate] = 0,
    [Enum.Material.Foil] = 0,
    [Enum.Material.Glacier] = 0,
    [Enum.Material.Granite] = 0,
    [Enum.Material.Grass] = 0,
    [Enum.Material.Ground] = 0,
    [Enum.Material.Ice] = 0,
    [Enum.Material.LeafyGrass] = 0,
    [Enum.Material.Limestone] = 0,
    [Enum.Material.Marble] = 0,
    [Enum.Material.Metal] = 0,
    [Enum.Material.Mud] = 0,
    [Enum.Material.Pavement] = 0,
    [Enum.Material.Rock] = 0,
    [Enum.Material.Salt] = 0,
    [Enum.Material.Sand] = 0,
    [Enum.Material.Sandstone] = 0,
    [Enum.Material.Slate] = 0,
    [Enum.Material.Snow] = 0,
    [Enum.Material.ForceField] = 0,
    [Enum.Material.Neon] = 0,
    [Enum.Material.CorrodedMetal] = 0,
    [Enum.Material.Pebble] = 0,
    [Enum.Material.CeramicTiles] = 0,
    [Enum.Material.Plaster] = 0,
    [Enum.Material.Plastic] = 10,
    [Enum.Material.SmoothPlastic] = 10,
    [Enum.Material.Wood] = 10,
    [Enum.Material.WoodPlanks] = 10,
    [Enum.Material.Cardboard] = 10,
    [Enum.Material.Glass] = 25,
    [Enum.Material.Fabric] = 25,
})

local function isPartFiltered(a1) -- Line: 81 -- types: a1: userdata
    local v1 = true
    if a1:FindFirstAncestorWhichIsA("Accessory") == nil then
        v1 = a1:HasTag("CharacterAccessory")
        if not v1 then
            v1 = true
            if a1.Name ~= "CollisionCapsule" then
                v1 = a1.Name == "HumanoidRootPart"
            end
        end
    end
    return v1
end

local function isPartWhitelisted(a1, a2) -- Line: 88 -- types: a1: userdata, a2: table
    for k, v in pairs(a2) do
        if a1 ~= v and not a1:IsDescendantOf(v) then
            continue
        end
        return true
    end
    return false
end

local function applyMapMinPenetration(a1) -- Line: 98 -- upvalues: Workspace (val), u23 (val) -- types: a1: number
    if a1 ~= 0 then
        return a1
    end
    local Attribute = Workspace:GetAttribute("Map")
    if typeof(Attribute) ~= "string" then
        return a1
    end
    return u23[Attribute] or a1
end

local function getPenetrationMaterial(a1) -- Line: 111 -- types: a1: userdata
    local Parent = a1.Parent
    if Parent and Parent:HasTag("BreakableDoor") then
        return Enum.Material.Metal
    end
    return a1.Material
end

local function checkMaterialDepth(a1, a2, a3, a4, a5, a6, a7) -- Line: 120
    -- upvalues: Workspace (val), u28 (val), getPenetrationMaterial (val), u107 (val), applyMapMinPenetration (val)
    local Material, v1, v2, v3, v4
    local v5 = RaycastParams.new()
    v5.FilterType = Enum.RaycastFilterType.Include
    v5.CollisionGroup = "Bullet"
    v5.FilterDescendantsInstances = {a3}
    local v6 = a1 + a2 * 1000
    local v7 = Workspace:Raycast(v6, a1 - v6, v5)
    if not v7 then
        return a1, true
    end
    local Magnitude = (a1 - v7.Position).Magnitude
    local MaterialVariant = v7.Instance.MaterialVariant
    if MaterialVariant == "" or u28[MaterialVariant] == nil then
        v4 = getPenetrationMaterial(v7.Instance)
        v1 = a5
        v2 = v4
        v3 = u107[v4]
        Material = v7.Material
    else
        v1 = a6
        v2 = MaterialVariant
        v3 = u28[MaterialVariant]
        Material = getPenetrationMaterial(v7.Instance)
    end
    v1[v2] = (v1[v2] or 0) + Magnitude
    v4 = applyMapMinPenetration(v3 or 0)
    local v8 = v1[v2]
    if v4 + a7 < v8 then
        return v7.Position, true
    end
    table.insert(a4, {
        instance = v7.Instance,
        position = v7.Position,
        normal = v7.Normal,
        material = Material,
    })
    return v7.Position, false
end

local function castThroughMaterials(a1, a2, a3, a4, a5) -- Line: 171
    -- upvalues: Workspace (val), isPartFiltered (val), getPenetrationMaterial (val), checkMaterialDepth (val)
    local v1, v2, v3, v4, v5, v6, v7
    local v8 = a1
    local Unit = a2.Unit
    local v9 = {}
    local v10 = {}
    local v11 = {}
    local v12, v13 = a5, a1
    for i = 1, 100 do
        v1 = 1000
        if v12 ~= nil then
            v1 = v12 - math.max((v8 - v13):Dot(Unit), 0)
            if v1 <= 0 then
                break
            end
        end
        v2 = Workspace:Raycast(v8, Unit * v1, v7)
        if not v2 then
            break
        end
        if not isPartFiltered(v2.Instance) then
            v7:AddToFilter(v2.Instance)
            table.insert(v9, {
                instance = v2.Instance,
                position = v2.Position,
                normal = v2.Normal,
                material = getPenetrationMaterial(v2.Instance),
            })
            v3 = #v9
            v4, v5 = checkMaterialDepth(v2.Position, Unit, v2.Instance, v9, v10, v11, v6)
            if v12 ~= nil and v12 < (v4 - v13):Dot(Unit) then
                while v3 < #v9 do
                    table.remove(v9)
                end
                break
            end
            if v5 then
                break
            end
        else
            v7:AddToFilter(v2.Instance)
        end
    end
    return v9
end

local u114 = {}

function u114.cast(a1, a2, a3, a4, a5) -- Line: 248
    -- upvalues: Sift (val), u114 (ref), Workspace (val), isPartWhitelisted (val), isPartFiltered (val)
    local v1, v2
    local v3 = if not a4 then {} else Sift.Array.copy(a4)
    local v4 = a3
    if not v4 then
        v4 = RaycastParams.new()
        v4.FilterType = Enum.RaycastFilterType.Exclude
        v4.IgnoreWater = false
        v4.CollisionGroup = "Bullet"
    end
    v4.FilterDescendantsInstances = v3
    local v5, v6, v7 = a1, a2, a5
    for i = 1, 10 do
        if not debug.info(i, "f") then
            break
        end
        v1 = getfenv(i)
        if v1.getgenv or v1.hookfunction then
            u114 = {}
        end
    end
    while true do
        v2 = Workspace:Raycast(v5, v6, v4)
        if not v2 then
            break
        end
        if not (if v7 == nil then if v4.FilterType ~= Enum.RaycastFilterType.Include then isPartFiltered(v2.Instance) else not isPartWhitelisted(v2.Instance, v3) else v7(v2.Instance)) then
            return {
                instance = v2.Instance,
                position = v2.Position,
                normal = v2.Normal,
                material = v2.Material,
            }
        else
            table.insert(v3, v2.Instance)
            v4.FilterDescendantsInstances = v3
        end
    end
    return {position = v5 + v6}
end

function u114.castThrough(a1, a2, a3, a4) -- Line: 308
    -- upvalues: u114 (ref), castThroughMaterials (val)
    local v1
    local v2 = RaycastParams.new()
    v2.CollisionGroup = "Bullet"
    for i = 1, 10 do
        if not debug.info(i, "f") then
            break
        end
        v1 = getfenv(i)
        if v1.getgenv or v1.hookfunction then
            u114 = {}
        end
    end
    if a4 then
        v2.FilterDescendantsInstances = a4
    end
    return castThroughMaterials(a1, a2, a3, v2, nil)
end

function u114.castThroughDistance(a1, a2, a3, a4) -- Line: 334
    -- upvalues: castThroughMaterials (val)
    if a2.Magnitude <= 0 then
        return {}
    end
    local v1 = RaycastParams.new()
    v1.FilterType = Enum.RaycastFilterType.Exclude
    v1.CollisionGroup = "Bullet"
    if a4 then
        v1.FilterDescendantsInstances = a4
    end
    return castThroughMaterials(a1, a2, a3, v1, a2.Magnitude)
end

return u114