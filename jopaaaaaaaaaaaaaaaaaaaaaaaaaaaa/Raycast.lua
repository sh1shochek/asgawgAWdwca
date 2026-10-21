-- ReplicatedStorage.Shared.Raycast
-- Script path: ReplicatedStorage.Shared.Raycast
-- Decompile time: 10.61 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Sift = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Sift"));
local table_freeze_ret = table.freeze({
    Reactor = -1
});
local table_freeze_ret2 = table.freeze({
    ["Sandy Brick"] = 0,
    IndoorWall = 0
});
local table_freeze_ret3 = table.freeze({
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
    [Enum.Material.Fabric] = 25
});

local function isPartFiltered(p1: userdata) -- Line: 81
    return p1:FindFirstAncestorWhichIsA("Accessory") ~= nil and true or (p1:HasTag("CharacterAccessory") or (p1.Name == "CollisionCapsule" and true or p1.Name == "HumanoidRootPart"));
end;

local function isPartWhitelisted(p2: userdata, p3: table) -- Line: 88
    for _, v in pairs(p3) do
        if p2 == v or p2:IsDescendantOf(v) then
            return true;
        end;
    end;

    return false;
end;

local function applyMapMinPenetration(p4: number) -- Line: 98
    -- upvalues: Workspace (copy), table_freeze_ret (copy)
    if p4 ~= 0 then
        return p4;
    end;

    local Attribute = Workspace:GetAttribute("Map");

    if typeof(Attribute) == "string" then
        return table_freeze_ret[Attribute] or p4;
    end;

    return p4;
end;

local function getPenetrationMaterial(p5: userdata) -- Line: 111
    local Parent = p5.Parent;

    if Parent and Parent:HasTag("BreakableDoor") then
        return Enum.Material.Metal;
    end;

    return p5.Material;
end;

local function checkMaterialDepth(p6: vector, p7: vector, p8: userdata, p9: table, p10: table, p11: table, p12: number, p13: boolean) -- Line: 120
    -- upvalues: Workspace (copy), table_freeze_ret2 (copy), getPenetrationMaterial (copy), table_freeze_ret3 (copy), applyMapMinPenetration (copy)
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    RaycastParams_new_ret.CollisionGroup = "Bullet";
    RaycastParams_new_ret.FilterDescendantsInstances = { p8 };
    local v14 = p6 + p7 * 1000;
    local v15 = Workspace:Raycast(v14, p6 - v14, RaycastParams_new_ret);

    if not v15 then
        return p6, true;
    end;

    local Magnitude = (p6 - v15.Position).Magnitude;
    local MaterialVariant = v15.Instance.MaterialVariant;
    local v16, v17;

    if MaterialVariant == "" or table_freeze_ret2[MaterialVariant] == nil then
        MaterialVariant = getPenetrationMaterial(v15.Instance);
        v16 = table_freeze_ret3[MaterialVariant];
        v17 = v15.Material;
    else
        v16 = table_freeze_ret2[MaterialVariant];
        v17 = getPenetrationMaterial(v15.Instance);
        p10 = p11;
    end;

    if not p13 then
        p10[MaterialVariant] = (p10[MaterialVariant] or 0) + Magnitude;
        local v18 = applyMapMinPenetration(v16 or 0);

        if p10[MaterialVariant] > v18 + p12 then
            return v15.Position, true;
        end;
    end;

    table.insert(p9, {
        instance = v15.Instance,
        position = v15.Position,
        normal = v15.Normal,
        material = v17
    });

    return v15.Position, false;
end;

local function castThroughMaterials(p19: vector, p20: vector, p21: number, p22: userdata, p23: number?, p24: userdata?) -- Line: 174
    -- upvalues: Workspace (copy), isPartFiltered (copy), getPenetrationMaterial (copy), checkMaterialDepth (copy)
    local Unit = p20.Unit;
    local v25 = p19;
    local v26 = {};
    local v27 = {};
    local v28 = {};

    for i = 1, 100 do
        local v29;

        if p23 == nil then
            v29 = 1000;
        else
            local v30 = (p19 - v25):Dot(Unit);
            v29 = p23 - math.max(v30, 0);

            if v29 <= 0 then
                break;
            end;
        end;

        local v31 = Workspace:Raycast(p19, Unit * v29, p22);

        if not v31 then
            break;
        end;

        local v32;

        if isPartFiltered(v31.Instance) then
            p22:AddToFilter(v31.Instance);
            v32 = i;
        else
            p22:AddToFilter(v31.Instance);
            local v33 = {
                instance = v31.Instance,
                position = v31.Position,
                normal = v31.Normal,
                material = getPenetrationMaterial(v31.Instance)
            };
            table.insert(v28, v33);
            local v34 = #v28;
            local Position = v31.Position;
            local Instance = v31.Instance;
            local v35;

            if p24 == nil then
                v35 = false;
            else
                v35 = v31.Instance:IsDescendantOf(p24);
            end;

            local v36;
            p19, v36 = checkMaterialDepth(Position, Unit, Instance, v28, v26, v27, p21, v35);

            if p23 ~= nil and p23 < (p19 - v25):Dot(Unit) then
                while v34 < #v28 do
                    table.remove(v28);
                end;

                break;
            end;

            if v36 then
                break;
            end;

            v32 = i;
        end;
    end;

    return v28;
end;

local u37 = {};

function u37.cast(p38: vector, p39: vector, p40: userdata?, p41: table?, p42: function?) -- Line: 253
    -- upvalues: Sift (copy), u37 (ref), Workspace (copy), isPartWhitelisted (copy), isPartFiltered (copy)
    local v43 = not p41 and {} or Sift.Array.copy(p41);

    if not p40 then
        p40 = RaycastParams.new();
        p40.FilterType = Enum.RaycastFilterType.Exclude;
        p40.IgnoreWater = false;
        p40.CollisionGroup = "Bullet";
    end;

    p40.FilterDescendantsInstances = v43;

    for i = 1, 10 do
        if not debug.info(i, "f") then
            break;
        end;

        local v44 = getfenv(i);
        local v45;

        if v44.getgenv or v44.hookfunction then
            u37 = {};
            v45 = i;
        else
            v45 = i;
        end;
    end;

    while true do
        local v46 = Workspace:Raycast(p38, p39, p40);

        if not v46 then
            break;
        end;

        local v47;

        if p42 == nil then
            if p40.FilterType == Enum.RaycastFilterType.Include then
                v47 = not isPartWhitelisted(v46.Instance, v43);
            else
                v47 = isPartFiltered(v46.Instance);
            end;
        else
            v47 = p42(v46.Instance);
        end;

        if not v47 then
            return {
                instance = v46.Instance,
                position = v46.Position,
                normal = v46.Normal,
                material = v46.Material
            };
        end;

        table.insert(v43, v46.Instance);
        p40.FilterDescendantsInstances = v43;
    end;

    return {
        position = p38 + p39
    };
end;

function u37.castThrough(p48: vector, p49: vector, p50: number, p51: table?) -- Line: 313
    -- upvalues: u37 (ref), castThroughMaterials (copy)
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.CollisionGroup = "Bullet";

    for i = 1, 10 do
        if not debug.info(i, "f") then
            break;
        end;

        local v52 = getfenv(i);
        local v53;

        if v52.getgenv or v52.hookfunction then
            u37 = {};
            v53 = i;
        else
            v53 = i;
        end;
    end;

    if p51 then
        RaycastParams_new_ret.FilterDescendantsInstances = p51;
    end;

    return castThroughMaterials(p48, p49, p50, RaycastParams_new_ret, nil);
end;

function u37.castThroughDistance(p54: vector, p55: vector, p56: number, p57: table?, p58: userdata?) -- Line: 340
    -- upvalues: castThroughMaterials (copy)
    if p55.Magnitude <= 0 then
        return {};
    end;

    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.CollisionGroup = "Bullet";

    if p57 then
        RaycastParams_new_ret.FilterDescendantsInstances = p57;
    end;

    return castThroughMaterials(p54, p55, p56, RaycastParams_new_ret, p55.Magnitude, p58);
end;

return u37;