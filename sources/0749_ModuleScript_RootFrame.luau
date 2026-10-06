-- Decompiled with Potassium's decompiler.

local Config = require(script.Parent.Simulation.Config);
require(script.Parent.Types);
local u1 = {
    DefaultRootHeightFromFeet = 3
};

local function halfHeight(p2, p3) -- Line: 16
    local v4;

    if p2 == "Ducking" then
        v4 = p3.PlayerSizeDucking.Y;
    else
        v4 = p3.PlayerSizeStanding.Y;
    end;

    return v4 * 0.5;
end;

function u1.visualStance(p5: number?) -- Line: 21
    return (p5 or 0) >= 0.999 and "Ducking" or "Standing";
end;

function u1.getDuckRootVerticalOffset(p6: number?, p7: boolean?, p8: any) -- Line: 26
    -- upvalues: Config (copy)
    if p7 ~= false then
        return 0;
    end;

    local v9 = p8 or Config.Default;

    return (v9.PlayerSizeStanding.Y - v9.PlayerSizeDucking.Y) * (v9.DuckJumpOriginShiftFraction + 0.5) * math.clamp(p6 or 0, 0, 1);
end;

function u1.rootToSimulationPosition(p10: vector, p11: any, p12: number?, p13: any) -- Line: 37
    -- upvalues: Config (copy), u1 (copy)
    local v14 = p13 or Config.Default;
    local v15;

    if p11 == "Ducking" then
        v15 = v14.PlayerSizeDucking.Y;
    else
        v15 = v14.PlayerSizeStanding.Y;
    end;

    return p10 + Vector3.new(0, v15 * 0.5 - (p12 or u1.DefaultRootHeightFromFeet), 0);
end;

function u1.simulationToRootPosition(p16: vector, p17: any, p18: number?, p19: any) -- Line: 48
    -- upvalues: Config (copy), u1 (copy)
    local v20 = p19 or Config.Default;
    local v21;

    if p17 == "Ducking" then
        v21 = v20.PlayerSizeDucking.Y;
    else
        v21 = v20.PlayerSizeStanding.Y;
    end;

    return p16 - Vector3.new(0, v21 * 0.5 - (p18 or u1.DefaultRootHeightFromFeet), 0);
end;

function u1.simulationToVisualRootPosition(p22: vector, p23: number?, p24: number?, p25: any) -- Line: 59
    -- upvalues: u1 (copy)
    return u1.simulationToRootPosition(p22, u1.visualStance(p23), p24, p25);
end;

function u1.stateToRootPosition(p26: any, p27: number?, p28: any) -- Line: 73
    -- upvalues: u1 (copy)
    return u1.simulationToVisualRootPosition(p26.Position, p26.DuckAmount, p27, p28);
end;

function u1.cframe(p29: any, p30: number?, p31: any) -- Line: 81
    -- upvalues: u1 (copy)
    return CFrame.new(u1.stateToRootPosition(p29, p30, p31)) * CFrame.Angles(0, p29.LookYaw, 0);
end;

return table.freeze(u1);