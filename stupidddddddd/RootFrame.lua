-- ReplicatedStorage.MovementV2.RootFrame
-- Script path: ReplicatedStorage.MovementV2.RootFrame
-- Decompile time: 0.91 ms

local Config = require(script.Parent.Simulation.Config)
require(script.Parent.Types)
local u11 = {DefaultRootHeightFromFeet = 3}

local function halfHeight(a1, a2) -- Line: 16
    local Y = if a1 ~= "Ducking" then a2.PlayerSizeStanding.Y else a2.PlayerSizeDucking.Y
    return Y * 0.5
end

function u11.visualStance(a1) -- Line: 21 -- types: a1: number?
    if 0.999 <= (a1 or 0) then
        return "Ducking"
    end
    return "Standing"
end

function u11.getDuckRootVerticalOffset(a1, a2, a3) -- Line: 26
    -- upvalues: Config (val)
    if a2 ~= false then
        return 0
    end
    local Default = a3 or Config.Default
    return (Default.PlayerSizeStanding.Y - Default.PlayerSizeDucking.Y) * (Default.DuckJumpOriginShiftFraction + 0.5) * math.clamp(a1 or 0, 0, 1)
end

function u11.rootToSimulationPosition(a1, a2, a3, a4) -- Line: 37
    -- upvalues: Config (val), u11 (val)
    local Default = a4 or Config.Default
    local DefaultRootHeightFromFeet = a3 or u11.DefaultRootHeightFromFeet
    local Y = if a2 ~= "Ducking" then Default.PlayerSizeStanding.Y else Default.PlayerSizeDucking.Y
    return a1 + Vector3.new(0, Y * 0.5 - DefaultRootHeightFromFeet, 0)
end

function u11.simulationToRootPosition(a1, a2, a3, a4) -- Line: 48
    -- upvalues: Config (val), u11 (val)
    local Default = a4 or Config.Default
    local DefaultRootHeightFromFeet = a3 or u11.DefaultRootHeightFromFeet
    local Y = if a2 ~= "Ducking" then Default.PlayerSizeStanding.Y else Default.PlayerSizeDucking.Y
    return a1 - Vector3.new(0, Y * 0.5 - DefaultRootHeightFromFeet, 0)
end

function u11.simulationToVisualRootPosition(a1, a2, a3, a4) -- Line: 59
    -- upvalues: u11 (val)
    return u11.simulationToRootPosition(a1, u11.visualStance(a2), a3, a4)
end

function u11.stateToRootPosition(a1, a2, a3) -- Line: 73 -- upvalues: u11 (val) -- types: a2: number?
    return u11.simulationToVisualRootPosition(a1.Position, a1.DuckAmount, a2, a3)
end

function u11.cframe(a1, a2, a3) -- Line: 81 -- upvalues: u11 (val) -- types: a2: number?
    return (CFrame.new(u11.stateToRootPosition(a1, a2, a3))) * CFrame.Angles(0, a1.LookYaw, 0)
end

return table.freeze(u11)