-- Stronghold (ModuleScript)
-- full path: ReplicatedStorage.Database.Custom.GameStats.Maps.Stronghold

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);

return table.freeze({
    Hidden = false,
    Icon = "rbxassetid://93651340552187",
    Radar = "",
    Gamemode = {
        Competitive = false,
        Deathmatch = false,
        Casual = false,
        Survival = "Zombie Survival"
    },
    Characters = {
        ["Counter-Terrorists"] = "IDF",
        Terrorists = "Anarchist"
    },
    Lighting = {
        Properties = require(script:WaitForChild("Properties")),
        Assets = ReplicatedStorage.Assets.Lighting.Stronghold
    },
    Terrain = {
        Position = Vector3.new(0, 0, 0),
        Terrain = nil,
        Resolution = 0,
        Properties = {
            WaterColor = Color3.fromRGB(12, 84, 92),
            WaterTransparency = 0.3,
            WaterReflectance = 1,
            WaterWaveSpeed = 10,
            WaterWaveSize = 0.15,
            Decoration = true,
            MaterialColors = {}
        }
    }
});