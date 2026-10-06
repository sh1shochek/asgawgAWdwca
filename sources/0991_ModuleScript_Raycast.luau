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

local function checkMaterialDepth(p6: vector, p7: vector, p8: userdata, p9: table, p10: table, p11: table, p12: number) -- Line: 120
    -- upvalues: Workspace (copy), table_freeze_ret2 (copy), getPenetrationMaterial (copy), table_freeze_ret3 (copy), applyMapMinPenetration (copy)
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    RaycastParams_new_ret.CollisionGroup = "Bullet";
    RaycastParams_new_ret.FilterDescendantsInstances = { p8 };
    local v13 = p6 + p7 * 1000;
    local v14 = Workspace:Raycast(v13, p6 - v13, RaycastParams_new_ret);

    if not v14 then
        return p6, true;
    end;

    local Magnitude = (p6 - v14.Position).Magnitude;
    local MaterialVariant = v14.Instance.MaterialVariant;
    local v15, v16;

    if MaterialVariant == "" or table_freeze_ret2[MaterialVariant] == nil then
        MaterialVariant = getPenetrationMaterial(v14.Instance);
        v15 = table_freeze_ret3[MaterialVariant];
        v16 = v14.Material;
    else
        v15 = table_freeze_ret2[MaterialVariant];
        v16 = getPenetrationMaterial(v14.Instance);
        p10 = p11;
    end;

    p10[MaterialVariant] = (p10[MaterialVariant] or 0) + Magnitude;
    local v17 = applyMapMinPenetration(v15 or 0);

    if p10[MaterialVariant] > v17 + p12 then
        return v14.Position, true;
    end;

    table.insert(p9, {
        instance = v14.Instance,
        position = v14.Position,
        normal = v14.Normal,
        material = v16
    });

    return v14.Position, false;
end;

local function castThroughMaterials(p18: vector, p19: vector, p20: number, p21: userdata, p22: number?) -- Line: 171
    -- upvalues: Workspace (copy), isPartFiltered (copy), getPenetrationMaterial (copy), checkMaterialDepth (copy)
    local Unit = p19.Unit;
    local v23 = p18;
    local v24 = {};
    local v25 = {};
    local v26 = {};

    for i = 1, 100 do
        local v27;

        if p22 == nil then
            v27 = 1000;
        else
            local v28 = (v23 - p18):Dot(Unit);
            v27 = p22 - math.max(v28, 0);

            if v27 <= 0 then
                break;
            end;
        end;

        local v29 = Workspace:Raycast(v23, Unit * v27, p21);

        if not v29 then
            break;
        end;

        local v30;

        if isPartFiltered(v29.Instance) then
            p21:AddToFilter(v29.Instance);
            v30 = i;
        else
            p21:AddToFilter(v29.Instance);
            local v31 = {
                instance = v29.Instance,
                position = v29.Position,
                normal = v29.Normal,
                material = getPenetrationMaterial(v29.Instance)
            };
            table.insert(v26, v31);
            local v32 = #v26;
            local v33;
            v23, v33 = checkMaterialDepth(v29.Position, Unit, v29.Instance, v26, v24, v25, p20);

            if p22 ~= nil and p22 < (v23 - p18):Dot(Unit) then
                while v32 < #v26 do
                    table.remove(v26);
                end;

                break;
            end;

            if v33 then
                break;
            end;

            v30 = i;
        end;
    end;

    return v26;
end;

local u34 = {};

function u34.cast(p35: vector, p36: vector, p37: userdata?, p38: table?, p39: function?) -- Line: 248
    -- upvalues: Sift (copy), u34 (ref), Workspace (copy), isPartWhitelisted (copy), isPartFiltered (copy)
    local v40 = not p38 and {} or Sift.Array.copy(p38);

    if not p37 then
        p37 = RaycastParams.new();
        p37.FilterType = Enum.RaycastFilterType.Exclude;
        p37.IgnoreWater = false;
        p37.CollisionGroup = "Bullet";
    end;

    p37.FilterDescendantsInstances = v40;

    for i = 1, 10 do
        if not debug.info(i, "f") then
            break;
        end;

        local v41 = getfenv(i);
        local v42;

        if v41.getgenv or v41.hookfunction then
            u34 = {};
            v42 = i;
        else
            v42 = i;
        end;
    end;

    while true do
        local v43 = Workspace:Raycast(p35, p36, p37);

        if not v43 then
            break;
        end;

        local v44;

        if p39 == nil then
            if p37.FilterType == Enum.RaycastFilterType.Include then
                v44 = not isPartWhitelisted(v43.Instance, v40);
            else
                v44 = isPartFiltered(v43.Instance);
            end;
        else
            v44 = p39(v43.Instance);
        end;

        if not v44 then
            return {
                instance = v43.Instance,
                position = v43.Position,
                normal = v43.Normal,
                material = v43.Material
            };
        end;

        table.insert(v40, v43.Instance);
        p37.FilterDescendantsInstances = v40;
    end;

    return {
        position = p35 + p36
    };
end;

function u34.castThrough(p45: vector, p46: vector, p47: number, p48: table?) -- Line: 308
    -- upvalues: u34 (ref), castThroughMaterials (copy)
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.CollisionGroup = "Bullet";

    for i = 1, 10 do
        if not debug.info(i, "f") then
            break;
        end;

        local v49 = getfenv(i);
        local v50;

        if v49.getgenv or v49.hookfunction then
            u34 = {};
            v50 = i;
        else
            v50 = i;
        end;
    end;

    if p48 then
        RaycastParams_new_ret.FilterDescendantsInstances = p48;
    end;

    return castThroughMaterials(p45, p46, p47, RaycastParams_new_ret, nil);
end;

function u34.castThroughDistance(p51: vector, p52: vector, p53: number, p54: table?) -- Line: 334
    -- upvalues: castThroughMaterials (copy)
    if p52.Magnitude <= 0 then
        return {};
    end;

    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.CollisionGroup = "Bullet";

    if p54 then
        RaycastParams_new_ret.FilterDescendantsInstances = p54;
    end;

    return castThroughMaterials(p51, p52, p53, RaycastParams_new_ret, p52.Magnitude);
end;

return u34;