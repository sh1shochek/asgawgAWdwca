-- ReplicatedStorage.Shared.Utility.SnapshotInterp
-- Script path: ReplicatedStorage.Shared.Utility.SnapshotInterp
-- Decompile time: 6.36 ms

-- Decompiled with Potassium's decompiler.

local u5 = {
    DuckSnap = 0.9,
    YawSnap = 0.5,

    Alpha = function(p1: number, p2: number, p3: number) -- Line: 72, Name: Alpha
        local v4 = p3 - p2;

        return v4 > 0 and math.clamp((p1 - p2) / v4, 0, 1) or 0;
    end
};

function u5.Snap(p6: number, p7: any, p8: any) -- Line: 84
    -- upvalues: u5 (copy)
    if u5.DuckSnap <= p6 then
        return p8;
    end;

    return p7;
end;

function u5.State(p9: any, p10: any, p11: number) -- Line: 98
    -- upvalues: u5 (copy)
    return vector.lerp(p9.Position, p10.Position, p11), u5.Snap(p11, p9.Ducked, p10.Ducked), u5.YawSnap <= p11 and p10.Yaw or p9.Yaw;
end;

return u5;