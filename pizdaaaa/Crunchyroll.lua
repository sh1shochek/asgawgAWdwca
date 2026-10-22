-- ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Crunchyroll
-- Decompile time: 4.19 ms

-- Decompiled with Potassium's decompiler.

local v1 = require("@self/roblox/animation_asset");
local v2 = require("@self/animation_solver");
local v3 = require("@self/rig");

return {
    load_keyframe_sequence = v1.load_keyframe_sequence,
    load_keyframe_sequence_metadata = v1.load_keyframe_sequence_metadata,
    create_rig = v3.create_rig,
    solve_animation = v2.solver
};