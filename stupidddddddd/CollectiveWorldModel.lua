-- ReplicatedStorage.Shared.Zone.ZoneController.CollectiveWorldModel
-- Script path: ReplicatedStorage.Shared.Zone.ZoneController.CollectiveWorldModel
-- Decompile time: 0.52 ms

local v1 = {}
local u1 = nil
local RunService = game:GetService("RunService")

function v1.setupWorldModel(a1) -- Line: 8 -- upvalues: u1 (ref), RunService (val)
    if u1 then
        return u1
    end
    local v1 = if not RunService:IsClient() then "ServerStorage" else "ReplicatedStorage"
    u1 = Instance.new("WorldModel")
    u1.Name = "ZonePlusWorldModel"
    u1.Parent = game:GetService(v1)
    return u1
end

function v1._getCombinedResults(a1, a2, ...) -- Line: 22 -- upvalues: u1 (ref)
    local v1 = workspace[a2](workspace, ...)
    if u1 then
        for k, v in pairs((u1[a2](u1, ...))) do
            table.insert(v1, v)
        end
    end
    return v1
end

function v1.GetPartBoundsInBox(a1, a2, a3, a4) -- Line: 33
    return a1:_getCombinedResults("GetPartBoundsInBox", a2, a3, a4)
end

function v1.GetPartBoundsInRadius(a1, a2, a3, a4) -- Line: 37
    return a1:_getCombinedResults("GetPartBoundsInRadius", a2, a3, a4)
end

function v1.GetPartsInPart(a1, a2, a3) -- Line: 41
    return a1:_getCombinedResults("GetPartsInPart", a2, a3)
end

return v1