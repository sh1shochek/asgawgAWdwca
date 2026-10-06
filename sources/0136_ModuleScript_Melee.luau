-- Decompiled with Potassium's decompiler.

return table.freeze({
    Images = { "rbxassetid://88027686092020" },
    Properties = {
        Color3 = Color3.fromRGB(56, 56, 56),

        Transparency = function() -- Line: 7, Name: Transparency
            return math.random(0, 4) / 10;
        end,

        Rotation = function() -- Line: 10, Name: Rotation
            return math.random(-20, 20);
        end,

        SizeRange = function() -- Line: 13, Name: SizeRange
            return math.random(10, 12) / 10;
        end
    }
});