-- ReplicatedStorage.Components.Common.VFXLibary.CreateMarker.Components.Melee
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateMarker.Components.Melee
-- Decompile time: 0.51 ms

return table.freeze({
    Images = {"rbxassetid://88027686092020"},
    Properties = {
        Color3 = Color3.fromRGB(56, 56, 56),
        Transparency = function() -- Line: 7
            return math.random(0, 4) / 10
        end,
        Rotation = function() -- Line: 10
            return math.random(-20, 20)
        end,
        SizeRange = function() -- Line: 13
            return math.random(10, 12) / 10
        end,
    },
})