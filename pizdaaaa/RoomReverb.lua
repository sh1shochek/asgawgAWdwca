-- ReplicatedStorage.Shared.Managers.SoundManager.RoomReverb
-- Script path: ReplicatedStorage.Shared.Managers.SoundManager.RoomReverb
-- Decompile time: 7.29 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {
    [Enum.Material.Fabric] = 0.7,
    [Enum.Material.Carpet] = 0.7,
    [Enum.Material.Snow] = 0.6,
    [Enum.Material.Cardboard] = 0.5,
    [Enum.Material.Rubber] = 0.5,
    [Enum.Material.Sand] = 0.4,
    [Enum.Material.Mud] = 0.35,
    [Enum.Material.LeafyGrass] = 0.3,
    [Enum.Material.Leather] = 0.25,
    [Enum.Material.Grass] = 0.2,
    [Enum.Material.Wood] = 0.15,
    [Enum.Material.Ground] = 0.15,
    [Enum.Material.WoodPlanks] = 0.11,
    [Enum.Material.Sandstone] = 0.1,
    [Enum.Material.CrackedLava] = 0.1,
    [Enum.Material.Salt] = 0.1,
    [Enum.Material.RoofShingles] = 0.1,
    [Enum.Material.ClayRoofTiles] = 0.08,
    [Enum.Material.Limestone] = 0.07,
    [Enum.Material.Pebble] = 0.06
};
local u3 = {
    [Enum.Material.Plastic] = 0.9,
    [Enum.Material.Wood] = 0.4,
    [Enum.Material.WoodPlanks] = 0.3,
    [Enum.Material.Marble] = 0.95,
    [Enum.Material.Basalt] = 0.75,
    [Enum.Material.Slate] = 0.7,
    [Enum.Material.CrackedLava] = 0.6,
    [Enum.Material.Concrete] = 0.5,
    [Enum.Material.Limestone] = 0.7,
    [Enum.Material.Granite] = 0.75,
    [Enum.Material.Pavement] = 0.6,
    [Enum.Material.Pebble] = 0.7,
    [Enum.Material.Cobblestone] = 0.7,
    [Enum.Material.Rock] = 0.5,
    [Enum.Material.Sandstone] = 0.6,
    [Enum.Material.CorrodedMetal] = 0.2,
    [Enum.Material.DiamondPlate] = 0.4,
    [Enum.Material.Foil] = 0.95,
    [Enum.Material.Metal] = 0.85,
    [Enum.Material.Grass] = 0.3,
    [Enum.Material.LeafyGrass] = 0.25,
    [Enum.Material.Sand] = 0.2,
    [Enum.Material.Fabric] = 0.5,
    [Enum.Material.Snow] = 0.6,
    [Enum.Material.Mud] = 0.4,
    [Enum.Material.Ground] = 0.3,
    [Enum.Material.Asphalt] = 0.35,
    [Enum.Material.Salt] = 0.3,
    [Enum.Material.Ice] = 0.98,
    [Enum.Material.Glacier] = 0.95,
    [Enum.Material.Water] = 0.99,
    [Enum.Material.Cardboard] = 0.4,
    [Enum.Material.Carpet] = 0.25,
    [Enum.Material.CeramicTiles] = 0.9,
    [Enum.Material.ClayRoofTiles] = 0.6,
    [Enum.Material.RoofShingles] = 0.6,
    [Enum.Material.Leather] = 0.7,
    [Enum.Material.Plaster] = 0.6,
    [Enum.Material.Rubber] = 0.8
};
local u4 = {
    [Enum.Material.Metal] = true,
    [Enum.Material.CorrodedMetal] = true,
    [Enum.Material.DiamondPlate] = true,
    [Enum.Material.Foil] = true
};
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.RespectCanCollide = false;
local Random_new_ret = Random.new();
local u5 = nil;
local u6 = 0;
local table_freeze_ret = table.freeze({
    WetLevel = -40.90196080028514,
    DecayTime = 0.4,
    DecayRatio = 0.5,
    Density = 1,
    Diffusion = 1,
    LowShelfFrequency = 150,
    LateDelayTime = 0
});
local table_clone_ret = table.clone(table_freeze_ret);

local function Reset() -- Line: 111
    -- upvalues: table_freeze_ret (copy), table_clone_ret (copy)
    for i, v in table_freeze_ret do
        table_clone_ret[i] = v;
    end;
end;

function v1.Build(p7: userdata) -- Line: 118
    -- upvalues: table_clone_ret (copy), u5 (ref)
    local AudioReverb = Instance.new("AudioReverb");
    AudioReverb.Name = "RoomReverb";
    AudioReverb.DryLevel = 1.5;
    AudioReverb.LowShelfGain = -8;
    AudioReverb.ReferenceFrequency = 2200;

    for i, v in table_clone_ret do
        AudioReverb[i] = v;
    end;

    AudioReverb.Parent = p7;
    u5 = AudioReverb;

    return AudioReverb;
end;

local function Sample(p8: vector, p9: userdata, p10: number, p11: userdata) -- Line: 135
    -- upvalues: RaycastParams_new_ret (copy), u2 (copy), u3 (copy), u4 (copy)
    RaycastParams_new_ret.FilterDescendantsInstances = { p9 };

    if not workspace:Raycast(p8, Vector3.new(0, 100, 0), RaycastParams_new_ret) then
        return nil, 0, 0, 0, 0;
    end;

    local v12 = 0;
    local v13 = 0;
    local v14 = 0;
    local v15 = 0;
    local v16 = 0;

    for i = 1, p10 do
        local v17 = p11:NextUnitVector();
        local X = v17.X;
        local math_abs_ret = math.abs(v17.Y);
        local Vector3_new_ret = Vector3.new(X, math_abs_ret, v17.Z);
        local v18 = p8;
        local _ = i;
        p8 = v18;

        for i2 = 0, 4 do
            local v19 = workspace:Raycast(p8, Vector3_new_ret * 100, RaycastParams_new_ret);

            if not v19 then
                break;
            end;

            v12 = v12 + 1;
            v13 = v13 + v19.Distance;
            v14 = v14 + (u2[v19.Material] or 0.03);
            v15 = v15 + (u3[v19.Material] or 1);
            v16 = v16 + (u4[v19.Material] and 1 or 0);
            local Normal = v19.Normal;
            Vector3_new_ret = Vector3_new_ret - 2 * Vector3_new_ret:Dot(Normal) * Normal;
            p8 = v19.Position + Normal * 0.01;
            v18 = p8;
            local _ = i2;
            p8 = v18;
        end;
    end;

    if v12 == 0 then
        return nil, 0, 0, 0, 0;
    end;

    return v12 / (p10 * 5), v13 / v12, v14 / v12, v15 / v12, v16 / v12;
end;

local function SetGoal(p20: number, p21: number, p22: number, p23: number, p24: number) -- Line: 185
    -- upvalues: table_clone_ret (copy)
    local math_clamp_ret = math.clamp(p21 / 25, 0, 1);
    table_clone_ret.WetLevel = p20 * 23.000000000000004 + -40.90196080028514;
    table_clone_ret.DecayTime = math_clamp_ret * 1.4 * p20 + 0.4;
    table_clone_ret.DecayRatio = (1 - p22) * 0.75;
    table_clone_ret.Density = 1 - p24;
    table_clone_ret.Diffusion = p23;
    table_clone_ret.LowShelfFrequency = math.max(p21 / 144 * 800, 100);
    table_clone_ret.LateDelayTime = p21 / 108 * 0.05;
end;

local function Measure(p25: vector, p26: userdata) -- Line: 197
    -- upvalues: Sample (copy), Random_new_ret (copy), table_clone_ret (copy)
    local v27, v28, v29, v30, v31 = Sample(p25, p26, 8, Random_new_ret);

    if v27 and v27 >= 0.5 then
        local math_clamp_ret = math.clamp(v28 / 25, 0, 1);
        table_clone_ret.WetLevel = v27 * 23.000000000000004 + -40.90196080028514;
        table_clone_ret.DecayTime = math_clamp_ret * 1.4 * v27 + 0.4;
        table_clone_ret.DecayRatio = (1 - v29) * 0.75;
        table_clone_ret.Density = 1 - v31;
        table_clone_ret.Diffusion = v30;
        table_clone_ret.LowShelfFrequency = math.max(v28 / 144 * 800, 100);
        table_clone_ret.LateDelayTime = v28 / 108 * 0.05;

        return;
    end;

    table_clone_ret.WetLevel = -17.901960800285135;
    table_clone_ret.DecayTime = 1.24;
    table_clone_ret.DecayRatio = 0.7275;
    table_clone_ret.Density = 1;
    table_clone_ret.Diffusion = 0.6;
    table_clone_ret.LowShelfFrequency = 100;
    table_clone_ret.LateDelayTime = 0.006944444444444445;
    local v32 = table_clone_ret;
    v32.WetLevel = v32.WetLevel + 4;
end;

local function GetGeometry() -- Line: 210
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Geometry");
    end;

    return Map;
end;

local u33 = {};
local u34 = nil;

local function SampleClosed(p35: vector, p36: userdata) -- Line: 222
    -- upvalues: Sample (copy)
    local v37 = Sample(p35, p36, 16, Random.new(1));
    local v38;

    if v37 == nil then
        v38 = false;
    else
        v38 = v37 >= 0.5;
    end;

    return v38;
end;

function v1.IsClosed(p39: vector) -- Line: 227
    -- upvalues: u34 (ref), u33 (copy), Sample (copy), RaycastParams_new_ret (copy)
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Geometry");
    end;

    if not Map then
        return false;
    end;

    if Map ~= u34 then
        table.clear(u33);
        u34 = Map;
    end;

    local math_floor_ret = math.floor(p39.X / 4);
    local math_floor_ret2 = math.floor(p39.Y / 4);
    local math_floor_ret3 = math.floor(p39.Z / 4);
    local Vector3_new_ret = Vector3.new(math_floor_ret, math_floor_ret2, math_floor_ret3);
    local v40 = u33[Vector3_new_ret];

    if v40 then
        RaycastParams_new_ret.FilterDescendantsInstances = { Map };

        if not workspace:Raycast(v40.Origin, p39 - v40.Origin, RaycastParams_new_ret) then
            return v40.Closed;
        end;

        local v41 = Sample(p39, Map, 16, Random.new(1));
        local v42;

        if v41 == nil then
            v42 = false;
        else
            v42 = v41 >= 0.5;
        end;

        return v42;
    end;

    local v43 = {
        Origin = p39
    };
    local v44 = Sample(p39, Map, 16, Random.new(1));
    local v45;

    if v44 == nil then
        v45 = false;
    else
        v45 = v44 >= 0.5;
    end;

    v43.Closed = v45;
    u33[Vector3_new_ret] = v43;

    return v43.Closed;
end;

function v1.Update(p46: number, p47: vector?) -- Line: 257
    -- upvalues: u5 (ref), u6 (ref), Measure (copy), table_freeze_ret (copy), table_clone_ret (copy)
    local v48 = u5;

    if not (v48 and v48.Parent) then
        return;
    end;

    u6 = u6 + p46;

    if u6 >= 0.03333333333333333 then
        u6 = 0;
        local Map = workspace:FindFirstChild("Map");

        if Map then
            Map = Map:FindFirstChild("Geometry");
        end;

        if Map and p47 then
            Measure(p47, Map);
        else
            for i, v in table_freeze_ret do
                table_clone_ret[i] = v;
            end;
        end;
    end;

    local v49 = 1 - math.exp(p46 * -4);

    for i, v in table_clone_ret do
        v48[i] = v48[i] + (v - v48[i]) * v49;
    end;
end;

return v1;