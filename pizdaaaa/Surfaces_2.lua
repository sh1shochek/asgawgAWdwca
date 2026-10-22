-- ReplicatedStorage.Shared.Managers.SoundManager.Surfaces
-- Script path: ReplicatedStorage.Shared.Managers.SoundManager.Surfaces
-- Decompile time: 4.72 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    HardSpeed = 4.9,
    MinSpeed = 1,
    MaxVolumeSpeed = 22.2
};
local v2 = {
    Bullet = "Impacts.Concrete.ConcreteImpactBullet",
    Hard = "Impacts.Concrete.ConcreteImpactHard",
    Soft = "Impacts.Concrete.ConcreteImpactSoft"
};
local v3 = {
    Bullet = "Impacts.Concrete.RockImpactHard",
    Hard = "Impacts.Concrete.RockImpactHard",
    Soft = "Impacts.Concrete.RockImpactSoft"
};
local v4 = {
    Bullet = "Impacts.Concrete.RockImpactSoft",
    Hard = "Impacts.Concrete.RockImpactHard",
    Soft = "Impacts.Concrete.RockImpactSoft"
};
local v5 = {
    Bullet = "Impacts.Surfaces.CarpetImpactBullet",
    Hard = "Impacts.Carpet.CarpetImpact",
    Soft = "Impacts.Carpet.CarpetImpact"
};
local v6 = {
    Bullet = "Impacts.Cardboard.CardboardBoxImpactBullet",
    Hard = "Impacts.Cardboard.CardboardBoxImpactHard",
    Soft = "Impacts.Cardboard.CardboardBoxImpactSoft"
};
local v7 = {
    Bullet = "Impacts.Metal.MetalSolidImpactBullet"
};
local v8 = {
    Bullet = "Impacts.Metal.MetalBoxImpactBullet"
};
local v9 = {
    Bullet = "Impacts.Glass.GlassImpactBullet"
};
local v10 = {
    Bullet = "Impacts.Snow.SnowImpactBullet"
};
local v11 = {
    Bullet = "Impacts.Surfaces.GrassImpactBullet"
};
local v12 = {
    Bullet = "Impacts.Surfaces.SandImpactBullet"
};
local v13 = {
    Bullet = "Impacts.Surfaces.TileImpactBullet"
};
u1.Default = {
    Bullet = "Impacts.Surfaces.DefaultImpactBullet"
};
u1.Materials = {
    Concrete = v2,
    Cobblestone = v2,
    Brick = v2,
    Pavement = v2,
    Asphalt = v2,
    Rock = v3,
    Basalt = v3,
    Limestone = v3,
    Sandstone = v4,
    Slate = v4,
    Pebble = v4,
    Metal = v7,
    DiamondPlate = v7,
    CorrodedMetal = {
        Bullet = "Impacts.Metal.MetalBarrelImpactHard"
    },
    Foil = v8,
    Plastic = v8,
    SmoothPlastic = v8,
    Glass = v9,
    ForceField = v9,
    Ice = v9,
    Glacier = v10,
    Snow = v10,
    Grass = v11,
    LeafyGrass = v11,
    Ground = {
        Bullet = "Impacts.Surfaces.DirtImpactBullet"
    },
    Mud = {
        Bullet = "Impacts.Surfaces.MudImpactBullet"
    },
    Sand = v12,
    Salt = v12,
    Marble = v13,
    Granite = v13,
    CeramicTiles = v13,
    Fabric = v5,
    Carpet = v5,
    Rubber = {
        Bullet = "Impacts.Rubber.RubberTireImpactBullet",
        Hard = "Impacts.Rubber.RubberTireImpactHard",
        Soft = "Impacts.Rubber.RubberTireImpactSoft"
    },
    Cardboard = v6,
    Cardstock = v6,
    Plaster = v2
};
local v14 = {};

for _, v in Enum.Material:GetEnumItems() do
    v14[v.Value] = v.Name;
end;

u1.Names = v14;

function u1.Get(p15: string?) -- Line: 156
    -- upvalues: u1 (copy)
    return p15 and u1.Materials[p15] or u1.Default;
end;

function u1.Impact(p16: string?, p17: number) -- Line: 163
    -- upvalues: u1 (copy)
    if p17 < u1.MinSpeed then
        return nil;
    end;

    local v18 = u1.Get(p16);

    if u1.HardSpeed <= p17 then
        return v18.Hard or v18.Soft;
    end;

    return v18.Soft or v18.Hard;
end;

function u1.ImpactVolume(p19: number) -- Line: 186
    -- upvalues: u1 (copy)
    local v20 = p19 / u1.MaxVolumeSpeed;

    return math.min(v20 * v20, 1);
end;

return u1;