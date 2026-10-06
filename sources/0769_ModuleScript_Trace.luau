-- Decompiled with Potassium's decompiler.

local DeterminismTrace = require(script.Parent.Parent.DeterminismTrace);
require(script.Parent.Parent.ProvenTypes);
local v1 = {};
local u2 = nil;

function v1.bind(p3) -- Line: 14
    -- upvalues: u2 (ref)
    u2 = p3;
end;

function v1.isActive() -- Line: 18
    -- upvalues: u2 (ref)
    return u2 ~= nil;
end;

function v1.line(p4: number) -- Line: 22
    -- upvalues: u2 (ref)
    return u2 == nil and 0 or debug.info(p4 + 1, "l");
end;

function v1.state(p5: string, p6: any, p7: number) -- Line: 30
    -- upvalues: DeterminismTrace (copy), u2 (ref)
    DeterminismTrace.checkpoint(u2, p5, p6, nil, nil, nil, "ReplicatedStorage.MovementV2.Simulation.ProvenSimulator", p7);
end;

function v1.vector(p8: string, p9: vector, p10: vector, p11: number?, p12: number?, p13: number) -- Line: 34
    -- upvalues: DeterminismTrace (copy), u2 (ref)
    DeterminismTrace.vector(u2, p8, p9, p10, p11, p12, nil, "ReplicatedStorage.MovementV2.Simulation.ProvenSimulator", p13);
end;

return table.freeze(v1);