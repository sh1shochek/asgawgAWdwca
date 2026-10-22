-- ReplicatedStorage.Shared.Managers.SoundManager.SoundData.Footsteps
-- Script path: ReplicatedStorage.Shared.Managers.SoundManager.SoundData.Footsteps
-- Decompile time: 6.62 ms

-- Decompiled with Potassium's decompiler.

local v1 = {
    Entries = require(script.Sounds)
};

for _, v in v1.Entries do
    v.RangeScale = 1.0007809316854543;
end;

v1.Surfaces = {
    Concrete = {
        Step = "Footsteps.ConcreteCt",
        Land = "Footsteps.LandConcrete",
        Volume = 0.9,
        LandVolume = 0.9,
        Pitch = NumberRange.new(0.99, 1.01),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Wood = {
        Step = "Footsteps.Wood",
        Land = "Footsteps.Wood",
        Volume = 0.8,
        LandVolume = 0.9,
        Pitch = NumberRange.new(0.92, 0.97),
        LandPitch = NumberRange.new(0.92, 0.97)
    },
    MetalSolid = {
        Step = "Footsteps.MetalGrate",
        Land = "Footsteps.LandMetalSolid",
        LandVolume = 0.4,
        Pitch = NumberRange.new(0.9, 0.95),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    MetalGrate = {
        Step = "Footsteps.MetalGrate",
        Land = "Footsteps.LandMetalGrate",
        Volume = 0.9,
        LandVolume = 0.4,
        Pitch = NumberRange.new(0.99, 1.01),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    MetalChainlink = {
        Step = "Footsteps.MetalChainlink",
        Land = "Footsteps.LandMetalGrate",
        LandVolume = 0.9,
        Pitch = NumberRange.new(0.99, 1.01),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Ladder = {
        Step = "Footsteps.Ladder",
        Land = "Footsteps.LandMetalSolid",
        LandVolume = 0.4,
        Pitch = NumberRange.new(0.92, 0.97),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Grass = {
        Step = "Footsteps.Grass",
        Land = "Footsteps.LandGrass",
        Volume = 0.2,
        LandVolume = 0.4,
        Pitch = NumberRange.new(0.99, 1.01),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Dirt = {
        Step = "Footsteps.Dirt",
        Land = "Footsteps.LandDirt",
        Volume = 0.8,
        LandVolume = 0.6,
        Pitch = NumberRange.new(0.92, 0.97),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Mud = {
        Step = "Footsteps.Mud",
        Land = "Footsteps.LandMud",
        LandVolume = 0.6,
        Pitch = NumberRange.new(0.92, 0.97),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Sand = {
        Step = "Footsteps.Sand",
        Land = "Footsteps.LandSand",
        Volume = 0.9,
        LandVolume = 0.3,
        Pitch = NumberRange.new(0.9, 1),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Gravel = {
        Step = "Footsteps.Gravel",
        Land = "Footsteps.LandGravel",
        LandVolume = 0.5,
        Pitch = NumberRange.new(0.92, 0.97),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Snow = {
        Step = "Footsteps.Snow",
        Land = "Footsteps.LandSnow",
        Volume = 0.7,
        LandVolume = 0.5,
        Pitch = NumberRange.new(0.92, 0.97),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Tile = {
        Step = "Footsteps.Tile",
        Land = "Footsteps.LandTile",
        Volume = 0.75,
        LandVolume = 0.9,
        Pitch = NumberRange.new(0.94, 0.96),
        LandPitch = NumberRange.new(0.94, 0.96)
    },
    Carpet = {
        Step = "Footsteps.Carpet",
        Land = "Footsteps.LandCarpet",
        LandVolume = 0.4,
        Pitch = NumberRange.new(0.92, 0.97),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Rubber = {
        Step = "Footsteps.Rubber",
        Land = "Footsteps.LandRubber",
        Volume = 0.5,
        LandVolume = 0.6,
        Pitch = NumberRange.new(0.92, 0.97),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Glass = {
        Step = "Footsteps.Tile",
        Land = "Footsteps.LandGlass",
        Volume = 0.85,
        LandVolume = 0.5,
        Pitch = NumberRange.new(0.96, 0.98),
        LandPitch = NumberRange.new(0.99, 1.01)
    },
    Cardboard = {
        Step = "Impacts.Cardboard.CardboardBoxImpactSoft",
        Land = "Footsteps.LandCardboard",
        Volume = 0.5,
        Pitch = NumberRange.new(0.92, 0.97),
        LandPitch = NumberRange.new(0.99, 1.01)
    }
};
v1.Surfaces.Default = v1.Surfaces.Concrete;
v1.Materials = {
    [Enum.Material.Concrete] = "Concrete",
    [Enum.Material.Cobblestone] = "Concrete",
    [Enum.Material.Brick] = "Concrete",
    [Enum.Material.Pavement] = "Concrete",
    [Enum.Material.Rock] = "Concrete",
    [Enum.Material.Basalt] = "Concrete",
    [Enum.Material.Limestone] = "Concrete",
    [Enum.Material.Sandstone] = "Concrete",
    [Enum.Material.Slate] = "Concrete",
    [Enum.Material.Wood] = "Wood",
    [Enum.Material.WoodPlanks] = "Wood",
    [Enum.Material.Metal] = "MetalSolid",
    [Enum.Material.CorrodedMetal] = "MetalSolid",
    [Enum.Material.DiamondPlate] = "MetalSolid",
    [Enum.Material.Foil] = "MetalSolid",
    [Enum.Material.Grass] = "Grass",
    [Enum.Material.LeafyGrass] = "Grass",
    [Enum.Material.Ground] = "Dirt",
    [Enum.Material.Mud] = "Mud",
    [Enum.Material.Sand] = "Sand",
    [Enum.Material.Snow] = "Snow",
    [Enum.Material.Ice] = "Snow",
    [Enum.Material.Glacier] = "Snow",
    [Enum.Material.Glass] = "Glass",
    [Enum.Material.ForceField] = "Glass",
    [Enum.Material.Fabric] = "Carpet",
    [Enum.Material.Rubber] = "Rubber",
    [Enum.Material.Cardboard] = "Cardboard",
    [Enum.Material.Plastic] = "Default",
    [Enum.Material.SmoothPlastic] = "Default"
};

return v1;