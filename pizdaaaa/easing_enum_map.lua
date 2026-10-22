-- ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll.roblox.easing_enum_map
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll.roblox.easing_enum_map
-- Decompile time: 6.01 ms

-- Decompiled with Potassium's decompiler.

local v1 = Enum or require("@lune/roblox").Enum;
local v2 = require("../easings");
local In = v1.PoseEasingDirection.In;
local Out = v1.PoseEasingDirection.Out;
local InOut = v1.PoseEasingDirection.InOut;

return {
    [v1.PoseEasingStyle.Linear] = {
        [In] = v2.linear,
        [Out] = v2.linear,
        [InOut] = v2.linear
    },
    [v1.PoseEasingStyle.Cubic] = {
        [In] = v2.cubic_in,
        [Out] = v2.cubic_out,
        [InOut] = v2.cubic_in_out
    },
    [v1.PoseEasingStyle.Bounce] = {
        [In] = v2.bounce_in,
        [Out] = v2.bounce_out,
        [InOut] = v2.bounce_in_out
    },
    [v1.PoseEasingStyle.Elastic] = {
        [In] = v2.elastic_in,
        [Out] = v2.elastic_out,
        [InOut] = v2.elastic_in_out
    },
    [v1.PoseEasingStyle.Constant] = {
        [In] = v2.constant,
        [Out] = v2.constant,
        [InOut] = v2.constant
    }
};