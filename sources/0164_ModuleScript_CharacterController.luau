-- Decompiled with Potassium's decompiler.

local script_LocalCharacter = require(script.LocalCharacter);
local script_RemoteCharacters = require(script.RemoteCharacters);

return {
    Initialize = function() -- Line: 11, Name: Initialize
        -- upvalues: script_LocalCharacter (copy), script_RemoteCharacters (copy)
        script_LocalCharacter.Initialize();
        script_RemoteCharacters.Initialize();
    end,

    Start = script_LocalCharacter.Start,
    getCurrentCharacter = script_LocalCharacter.getCurrentCharacter,
    GetWalkState = script_LocalCharacter.GetWalkState,
    GetCrouchState = script_LocalCharacter.GetCrouchState,
    walk = script_LocalCharacter.walk,
    crouch = script_LocalCharacter.crouch,
    jump = script_LocalCharacter.jump,
    PredictDoorUse = script_LocalCharacter.PredictDoorUse,
    IsDoorInUseRange = script_LocalCharacter.IsDoorInUseRange,
    TrackCharacter = script_RemoteCharacters.Track,
    UntrackCharacter = script_RemoteCharacters.Untrack
};