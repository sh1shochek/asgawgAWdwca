-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
require(script.Parent.Config);
require(script.Parent.DeterminismTrace);
local PlayerContacts = require(script.Parent.PlayerContacts);
require(script.Parent.PlayerHullClearance);
local ProvenCollisionAdapter = require(script.Parent.ProvenCollisionAdapter);
local ProvenSimulator = require(script.Parent.ProvenSimulator);
require(script.Parent.Types);
local u2 = {
    needsStanding = function(p1) -- Line: 14, Name: needsStanding
        return p1.JumpHullActive and p1.DuckAmount < 0.999;
    end
};

function u2.queryHalfSize(p3, p4) -- Line: 19
    -- upvalues: u2 (copy)
    if u2.needsStanding(p3) then
        return p4.PlayerSizeStanding * 0.5 + Vector3.new(0, p4.GroundProbeDistance + p4.PositionSnapEpsilon, 0);
    end;

    local v5;

    if p3.Stance == "Ducking" then
        v5 = p4.PlayerSizeDucking;
    else
        v5 = p4.PlayerSizeStanding;
    end;

    return v5 * 0.5;
end;

function u2.prepare(p6: any, p7: any, p8: table, p9: any, p10: any, p11: any, p12: any) -- Line: 28
    -- upvalues: u2 (copy), PlayerContacts (copy), ProvenCollisionAdapter (copy), ProvenSimulator (copy)
    if not (u2.needsStanding(p6) and (not p6.OnGround and p7.WorldVelocity.Y <= p10.VelocityEpsilon)) then
        return false;
    end;

    local v13 = p10.PlayerSizeDucking * 0.5;
    local v14 = p10.PlayerSizeStanding * 0.5;
    local DefaultContactEpsilon = PlayerContacts.DefaultContactEpsilon;
    local DefaultSeparationSkin = PlayerContacts.DefaultSeparationSkin;
    local v15 = p7.StartPosition.Y - v13.Y;
    local v16 = p7.Position.Y - v14.Y;
    local v17 = (-1 / 0);
    local v18 = nil;

    for _, v in p8 do
        if v.Id ~= p7.Id then
            local v19;

            if v.Stance == "Ducking" then
                v19 = p10.PlayerSizeDucking;
            else
                v19 = p10.PlayerSizeStanding;
            end;

            local v20 = v19 * 0.5;
            local v21 = v.Position.Y + v20.Y;
            local v22 = p7.Position - v.Position;

            if v21 - DefaultContactEpsilon - DefaultSeparationSkin <= v15 and (v16 <= v21 + p10.GroundProbeDistance + p10.PositionSnapEpsilon and (math.abs(v22.X) < v14.X + v20.X - DefaultContactEpsilon and (math.abs(v22.Z) < v14.Z + v20.Z - DefaultContactEpsilon and (v17 < v21 or v21 == v17 and (v18 ~= nil and v.Id < v18.Id))))) then
                v18 = v;
                v17 = v21;
            end;
        end;
    end;

    if v18 == nil then
        return false;
    end;

    local Vector3_new_ret = Vector3.new(p7.Position.X, v17 + v13.Y + DefaultSeparationSkin, p7.Position.Z);

    if not p9:CanMove(p7.Position, Vector3_new_ret, "Ducking", nil, 1, 1) then
        return false;
    end;

    local v23 = ProvenCollisionAdapter.new(p9, p10, nil, p12, nil, p11);
    local v24, v25 = ProvenSimulator.checkStandingClearance(Vector3_new_ret, v23, p10);

    if v24 then
        return false;
    end;

    p7.Position = v25;
    p7.Stance = "Standing";

    return true;
end;

function u2.restoreWorldGround(p26, p27, p28, p29, p30) -- Line: 82
    -- upvalues: ProvenCollisionAdapter (copy), ProvenSimulator (copy)
    local v31 = ProvenCollisionAdapter.new(p27, p28, p26.Support, p30, nil, p29);
    local v32, v33 = ProvenSimulator.checkStandingClearance(p26.Position, v31, p28);

    if v32 then
        return nil;
    end;

    local v34 = p27:FindGround(v33, "Standing", p28.GroundProbeDistance, 1, p26.Support);

    if v34 == nil then
        return nil;
    end;

    local v35 = v31:PointTest(v34.Position, "standing", true);

    if v35.startSolid or v35.allSolid then
        return nil;
    end;

    return v34;
end;

return table.freeze(u2);