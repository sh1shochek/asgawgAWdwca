-- ReplicatedStorage.Visibility.PVSSightlinePatch
-- Script path: ReplicatedStorage.Visibility.PVSSightlinePatch
-- Decompile time: 3.94 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PVSCodec = require(ReplicatedStorage.Visibility.PVSCodec)
local v1 = {}
local u10 = {2.35, 1.7}
local u13 = {0.5, 2.7, 5.2}

local function findBarrierRoot(a1) -- Line: 32 -- types: a1: userdata
    local Barriers = a1:FindFirstChild("Barriers")
    if Barriers then
        return Barriers
    end
    return a1:FindFirstChild("Barriers", true)
end

local function regionsOfCell(a1, a2) -- Line: 40 -- types: a2: number
    local v1 = a1.cells[a2]
    if v1.regions ~= nil and #v1.regions > 0 then
        return v1.regions
    end
    local v2 = {}
    local v3 = nil
    local v4 = nil
    local v5 = a2
    for i, j in a1.regions, v3, v4 do
        if j.cluster == v1.id or j.cluster == v5 then
            v2[#v2 + 1] = j
        end
    end
    if #v2 == 0 then
        local v6 = v1.size * 0.5
        v2[1] = {
            cluster = v5,
            minimum = v1.cframe.Position - v6,
            maximum = v1.cframe.Position + v6,
        }
    end
    return v2
end

function v1.apply(a1, a2, a3) -- Line: 58
    -- upvalues: u10 (val), u13 (val), regionsOfCell (val), PVSCodec (val)
    local v1
    local v2 = a3 or {}
    local u7 = v2.gridPerRegion or 4
    local eyeHeights = v2.eyeHeights or u10
    local targetHeights = v2.targetHeights or u13
    local u147 = v2.yieldEveryRays or 4000
    local v3 = os.clock()
    local Barriers = a1:FindFirstChild("Barriers")
    assert((if not Barriers then a1:FindFirstChild("Barriers", true) else Barriers) ~= nil, "PVSSightlinePatch: no Barriers folder")
    assert(a1:IsDescendantOf(workspace), "PVSSightlinePatch: the map must be in Workspace for raycasts")
    local u150 = RaycastParams.new()
    u150.FilterType = Enum.RaycastFilterType.Include
    u150.FilterDescendantsInstances = {v1}
    u150.RespectCanCollide = false
    local u56 = OverlapParams.new()
    u56.FilterType = Enum.RaycastFilterType.Include
    u56.FilterDescendantsInstances = {v1}
    local u61 = RaycastParams.new()
    u61.FilterType = Enum.RaycastFilterType.Include
    u61.FilterDescendantsInstances = {a1}
    u61.RespectCanCollide = true
    local u294 = {
        negativePairs = 0,
        leakingPairs = 0,
        rays = 0,
        rejectedInsideBarrier = 0,
        rejectedNoFloor = 0,
        seconds = 0,
    }

    local function samples(a1, a2_2) -- Line: 85
        -- upvalues: regionsOfCell (upval), a2 (val), u7 (val), u56 (val), u294 (val), u61 (val)
        local v1, v2, v3, v4, v5, v6, v7
        local v8 = {}
        for i, j in regionsOfCell(a2, a1) do
            v6 = j.maximum - j.minimum
            v7 = math.clamp(math.ceil(v6.X / 5), 1, u7)
            v1 = math.clamp(math.ceil(v6.Z / 5), 1, u7)
            for k = 1, v7 do
                v2 = j.minimum.X + (k - 0.5) * v6.X / v7
                for n = 1, v1 do
                    v3 = j.minimum.Z + (n - 0.5) * v6.Z / v1
                    for m, i5 in a2_2 do
                        v4 = Vector3.new(v2, math.min(j.minimum.Y + i5, j.maximum.Y - 0.1), v3)
                        v5 = #workspace:GetPartBoundsInBox(
                            CFrame.new(v4),
                            Vector3.new(0.30000001192092896, 0.30000001192092896, 0.30000001192092896),
                            u56
                        )
                        if not (v5 > 0) then
                            v5 = workspace
                            if v5:Raycast(v4, Vector3.new(0, -8, 0), u61) ~= nil then
                                v8[#v8 + 1] = v4
                            else
                                v5 = u294
                                v5.rejectedNoFloor = v5.rejectedNoFloor + 1
                            end
                        else
                            v5 = u294
                            v5.rejectedInsideBarrier = v5.rejectedInsideBarrier + 1
                        end
                    end
                end
            end
        end
        return v8
    end

    local v4 = #a2.cells
    local v5 = table.create(v4)
    local v6 = table.create(v4)
    for i = 1, v4 do
        v5[i] = (samples(i, eyeHeights))
        v6[i] = (samples(i, targetHeights))
        if i % 16 == 0 then
            task.wait()
        end
    end
    local v7 = PVSCodec.getRowStride(v4)
    local v8 = buffer.fromstring(a2.visibleBytes)

    local function clearRay(a1, a2) -- Line: 127
        -- upvalues: u294 (val), u147 (val), u150 (val)
        local v1, v2, v3, v4
        local v5 = nil
        local v6 = nil
        for i, j in a1, v5, v6 do
            v3 = nil
            v4 = nil
            for k, n in a2, v3, v4 do
                v1 = u294
                v1.rays = v1.rays + 1
                if u294.rays % u147 == 0 then
                    task.wait()
                end
                v1 = workspace
                v2 = n - j
                if v1:Raycast(j, v2, u150) == nil then
                    return true
                end
            end
        end
        return false
    end

    local v9 = v4 * (v4 - 1) / 2
    local v10 = 0
    for j = 1, v4 do
        for k = j + 1, v4 do
            v10 = v10 + 1
            if not PVSCodec.isVisible(a2, j, k) and not PVSCodec.isVisible(a2, k, j) then
                u294.negativePairs = u294.negativePairs + 1
                if clearRay(v5[j], v6[k]) or clearRay(v5[k], v6[j]) then
                    u294.leakingPairs = u294.leakingPairs + 1
                    PVSCodec.setVisible(v8, v7, j, k)
                    PVSCodec.setVisible(v8, v7, k, j)
                end
            end
        end
        if v2.onProgress ~= nil then
            v2.onProgress(v10, v9, u294.leakingPairs)
        end
    end
    local v11 = table.clone(a2)
    v11.visibleBytes = buffer.tostring(v8)
    u294.seconds = os.clock() - v3
    return v11, u294
end

return table.freeze(v1)