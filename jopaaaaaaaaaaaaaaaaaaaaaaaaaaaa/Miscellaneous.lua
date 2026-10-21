-- ReplicatedStorage.Database.Audio.Miscellaneous
-- Script path: ReplicatedStorage.Database.Audio.Miscellaneous
-- Decompile time: 3.47 ms

-- Decompiled with Potassium's decompiler.

return table.freeze({
    ["Open Garage"] = {
        Identifiers = { 113908883188966 },
        Properties = {
            RollOffMaxDistance = 60,
            RollOffMinDistance = 10,
            Volume = 1
        }
    },
    ["Close Garage"] = {
        Identifiers = { 108976400967979 },
        Properties = {
            RollOffMaxDistance = 60,
            RollOffMinDistance = 10,
            Volume = 1
        }
    },
    ["Electricity Zap"] = {
        Identifiers = { 79873000109115, 102584329392475, 120727679421473 },
        Properties = {
            RollOffMode = Enum.RollOffMode.InverseTapered,
            RollOffMaxDistance = 110,
            RollOffMinDistance = 6,
            Volume = 0.5,
            Persistent = true,
            WarmOnUse = true
        }
    }
});