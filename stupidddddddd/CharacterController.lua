-- ReplicatedStorage.Controllers.CharacterController
-- Script path: ReplicatedStorage.Controllers.CharacterController
-- Decompile time: 0.22 ms

local LocalCharacter = require(script.LocalCharacter)
local RemoteCharacters = require(script.RemoteCharacters)
return {
    Initialize = function() -- Line: 11 -- upvalues: LocalCharacter (val), RemoteCharacters (val)
        LocalCharacter.Initialize()
        RemoteCharacters.Initialize()
    end,
    Start = LocalCharacter.Start,
    getCurrentCharacter = LocalCharacter.getCurrentCharacter,
    GetWalkState = LocalCharacter.GetWalkState,
    GetCrouchState = LocalCharacter.GetCrouchState,
    walk = LocalCharacter.walk,
    crouch = LocalCharacter.crouch,
    jump = LocalCharacter.jump,
    PredictDoorUse = LocalCharacter.PredictDoorUse,
    IsDoorInUseRange = LocalCharacter.IsDoorInUseRange,
    TrackCharacter = RemoteCharacters.Track,
    UntrackCharacter = RemoteCharacters.Untrack,
}