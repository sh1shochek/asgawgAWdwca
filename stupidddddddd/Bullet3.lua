-- ReplicatedStorage.Components.Common.VFXLibary.CreateMarker.Components.Bullet
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateMarker.Components.Bullet
-- Decompile time: 0.28 ms

return table.freeze({
    Images = {"http://www.roblox.com/asset/?id=4784881970", "http://www.roblox.com/asset/?id=4784905666"},
    Properties = {
        Color3 = Color3.fromRGB(255, 255, 255),
        Transparency = function() -- Line: 8
            return math.random(0, 2) / 10
        end,
        Rotation = function() -- Line: 11
            return math.random(0, 360)
        end,
        SizeRange = function() -- Line: 14
            return math.random(6, 8) / 10
        end,
    },
})