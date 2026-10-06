-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PVSCodec = require(ReplicatedStorage.Visibility.PVSCodec);
local v1 = {};
local u2 = { 2.35, 1.7 };
local u3 = { 0.5, 2.7, 5.2 };

local function findBarrierRoot(p4: userdata) -- Line: 32
    return p4:FindFirstChild("Barriers") or p4:FindFirstChild("Barriers", true);
end;

local function regionsOfCell(p5: any, p6: number) -- Line: 40
    local v7 = p5.cells[p6];

    if v7.regions ~= nil and #v7.regions > 0 then
        return v7.regions;
    end;

    local v8 = {};

    for _, v in p5.regions do
        if v.cluster == v7.id or v.cluster == p6 then
            v8[#v8 + 1] = v;
        end;
    end;

    if #v8 == 0 then
        local v9 = v7.size * 0.5;
        v8[1] = {
            cluster = p6,
            minimum = v7.cframe.Position - v9,
            maximum = v7.cframe.Position + v9
        };
    end;

    return v8;
end;

function v1.apply(p10: userdata, u11: any, p12: table?) -- Line: 58
    -- upvalues: u2 (copy), u3 (copy), regionsOfCell (copy), PVSCodec (copy)
    local v13 = p12 or {};
    local u14 = v13.gridPerRegion or 4;
    local v15 = v13.eyeHeights or u2;
    local v16 = v13.targetHeights or u3;
    local u17 = v13.yieldEveryRays or 4000;
    local os_clock_ret = os.clock();
    local v18 = p10:FindFirstChild("Barriers") or p10:FindFirstChild("Barriers", true);
    assert(v18 ~= nil, "PVSSightlinePatch: no Barriers folder");
    local v19 = p10:IsDescendantOf(workspace);
    assert(v19, "PVSSightlinePatch: the map must be in Workspace for raycasts");
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    RaycastParams_new_ret.FilterDescendantsInstances = { v18 };
    RaycastParams_new_ret.RespectCanCollide = false;
    local OverlapParams_new_ret = OverlapParams.new();
    OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    OverlapParams_new_ret.FilterDescendantsInstances = { v18 };
    local RaycastParams_new_ret2 = RaycastParams.new();
    RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
    RaycastParams_new_ret2.FilterDescendantsInstances = { p10 };
    RaycastParams_new_ret2.RespectCanCollide = true;
    local u20 = {
        negativePairs = 0,
        leakingPairs = 0,
        rays = 0,
        rejectedInsideBarrier = 0,
        rejectedNoFloor = 0,
        seconds = 0
    };

    local function samples(p21: number, p22: table) -- Line: 85
        -- upvalues: regionsOfCell (ref), u11 (copy), u14 (copy), OverlapParams_new_ret (copy), u20 (copy), RaycastParams_new_ret2 (copy)
        local v23 = {};

        for _, v in regionsOfCell(u11, p21) do
            local v24 = v.maximum - v.minimum;
            local math_ceil_ret = math.ceil(v24.X / 5);
            local math_clamp_ret = math.clamp(math_ceil_ret, 1, u14);
            local math_ceil_ret2 = math.ceil(v24.Z / 5);
            local math_clamp_ret2 = math.clamp(math_ceil_ret2, 1, u14);
            local v25 = v;

            for i = 1, math_clamp_ret do
                local v26 = v25.minimum.X + (i - 0.5) * v24.X / math_clamp_ret;
                local _ = i;

                for i2 = 1, math_clamp_ret2 do
                    local v27 = v25.minimum.Z + (i2 - 0.5) * v24.Z / math_clamp_ret2;
                    local _ = i2;

                    for _, v2 in p22 do
                        local math_min_ret = math.min(v25.minimum.Y + v2, v25.maximum.Y - 0.1);
                        local Vector3_new_ret = Vector3.new(v26, math_min_ret, v27);

                        if #workspace:GetPartBoundsInBox(CFrame.new(Vector3_new_ret), Vector3.new(0.3, 0.3, 0.3), OverlapParams_new_ret) > 0 then
                            local v28 = u20;
                            v28.rejectedInsideBarrier = v28.rejectedInsideBarrier + 1;
                        elseif workspace:Raycast(Vector3_new_ret, Vector3.new(0, -8, 0), RaycastParams_new_ret2) == nil then
                            local v29 = u20;
                            v29.rejectedNoFloor = v29.rejectedNoFloor + 1;
                        else
                            v23[#v23 + 1] = Vector3_new_ret;
                        end;
                    end;
                end;
            end;
        end;

        return v23;
    end;

    local v30 = #u11.cells;
    local table_create_ret = table.create(v30);
    local table_create_ret2 = table.create(v30);

    for i = 1, v30 do
        table_create_ret[i] = samples(i, v15);
        table_create_ret2[i] = samples(i, v16);
        local v31;

        if i % 16 == 0 then
            task.wait();
            v31 = i;
        else
            v31 = i;
        end;
    end;

    local RowStride = PVSCodec.getRowStride(v30);
    local buffer_fromstring_ret = buffer.fromstring(u11.visibleBytes);
    local v32 = v30 * (v30 - 1) / 2;

    local function clearRay(p33: table, p34: table) -- Line: 127
        -- upvalues: u20 (copy), u17 (copy), RaycastParams_new_ret (copy)
        for _, v in p33 do
            local v35 = v;

            for _, v2 in p34 do
                local v36 = u20;
                v36.rays = v36.rays + 1;

                if u20.rays % u17 == 0 then
                    task.wait();
                end;

                if workspace:Raycast(v35, v2 - v35, RaycastParams_new_ret) == nil then
                    return true;
                end;
            end;
        end;

        return false;
    end;

    local v37 = 0;

    for i = 1, v30 do
        local v38 = i;

        for i2 = i + 1, v30 do
            v37 = v37 + 1;
            local v39;

            if PVSCodec.isVisible(u11, v38, i2) or PVSCodec.isVisible(u11, i2, v38) then
                v39 = i2;
            else
                u20.negativePairs = u20.negativePairs + 1;

                if clearRay(table_create_ret[v38], table_create_ret2[i2]) or clearRay(table_create_ret[i2], table_create_ret2[v38]) then
                    u20.leakingPairs = u20.leakingPairs + 1;
                    PVSCodec.setVisible(buffer_fromstring_ret, RowStride, v38, i2);
                    PVSCodec.setVisible(buffer_fromstring_ret, RowStride, i2, v38);
                    v39 = i2;
                else
                    v39 = i2;
                end;
            end;
        end;

        if v13.onProgress ~= nil then
            v13.onProgress(v37, v32, u20.leakingPairs);
        end;
    end;

    local table_clone_ret = table.clone(u11);
    table_clone_ret.visibleBytes = buffer.tostring(buffer_fromstring_ret);
    u20.seconds = os.clock() - os_clock_ret;

    return table_clone_ret, u20;
end;

return table.freeze(v1);