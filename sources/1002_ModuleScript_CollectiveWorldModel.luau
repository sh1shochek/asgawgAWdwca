-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;
local RunService = game:GetService("RunService");

function v1.setupWorldModel(p3) -- Line: 8
    -- upvalues: u2 (ref), RunService (copy)
    if u2 then
        return u2;
    end;

    local v4 = RunService:IsClient() and "ReplicatedStorage" or "ServerStorage";
    u2 = Instance.new("WorldModel");
    u2.Name = "ZonePlusWorldModel";
    u2.Parent = game:GetService(v4);

    return u2;
end;

function v1._getCombinedResults(p5, p6, ...) -- Line: 22
    -- upvalues: u2 (ref)
    local v7 = workspace[p6](workspace, ...);

    if u2 then
        local v8 = u2[p6](u2, ...);

        for _, v in pairs(v8) do
            table.insert(v7, v);
        end;
    end;

    return v7;
end;

function v1.GetPartBoundsInBox(p9, p10, p11, p12) -- Line: 33
    return p9:_getCombinedResults("GetPartBoundsInBox", p10, p11, p12);
end;

function v1.GetPartBoundsInRadius(p13, p14, p15, p16) -- Line: 37
    return p13:_getCombinedResults("GetPartBoundsInRadius", p14, p15, p16);
end;

function v1.GetPartsInPart(p17, p18, p19) -- Line: 41
    return p17:_getCombinedResults("GetPartsInPart", p18, p19);
end;

return v1;