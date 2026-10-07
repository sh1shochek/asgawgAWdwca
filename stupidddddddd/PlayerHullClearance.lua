-- ReplicatedStorage.MovementV2.Simulation.PlayerHullClearance
-- Script path: ReplicatedStorage.MovementV2.Simulation.PlayerHullClearance
-- Decompile time: 2.46 ms

require(script.Parent.Parent.Types)
require(script.Parent.Config)
local PlayerContacts = require(script.Parent.PlayerContacts)
local v1 = {}

local function halfSize(a1, a2) -- Line: 15
    local PlayerSizeDucking = if a1 ~= "Ducking" then a2.PlayerSizeStanding else a2.PlayerSizeDucking
    return PlayerSizeDucking * 0.5
end

function v1.bounds(a1, a2, a3) -- Line: 19 -- types: a1: vector
    local PlayerSizeStanding = a3.PlayerSizeStanding
    local PlayerSizeDucking = a3.PlayerSizeDucking
    local v1 = Vector3.new(
        math.max(PlayerSizeStanding.X, PlayerSizeDucking.X),
        math.max(PlayerSizeStanding.Y, PlayerSizeDucking.Y),
        (math.max(PlayerSizeStanding.Z, PlayerSizeDucking.Z))
    ) * 0.5
    local PlayerSizeDucking_2 = if a2 ~= "Ducking" then a3.PlayerSizeStanding else a3.PlayerSizeDucking
    local v2 = PlayerSizeDucking_2 * 0.5 + v1
    return a1 - v2, a1 + v2
end

function v1.overlaps(a1, a2, a3, a4, a5) -- Line: 30 -- upvalues: PlayerContacts (val) -- types: a1: vector, a3: vector
    local PlayerSizeDucking = if a2 ~= "Ducking" then a5.PlayerSizeStanding else a5.PlayerSizeDucking
    local v1 = PlayerSizeDucking * 0.5
    local PlayerSizeDucking_2 = if a4 ~= "Ducking" then a5.PlayerSizeStanding else a5.PlayerSizeDucking
    local v2 = v1 + PlayerSizeDucking_2 * 0.5
    v1 = a1 - a3
    local DefaultContactEpsilon = PlayerContacts.DefaultContactEpsilon
    local v3 = false
    if (math.abs(v1.X)) < v2.X - DefaultContactEpsilon then
        v3 = false
        if (math.abs(v1.Y)) < v2.Y - DefaultContactEpsilon then
            v3 = (math.abs(v1.Z)) < v2.Z - DefaultContactEpsilon
        end
    end
    return v3
end

return table.freeze(v1)