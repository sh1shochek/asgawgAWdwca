-- Decompiled with Potassium's decompiler.

local v1 = {};
local HttpService = game:GetService("HttpService");
local PathfindingService = game:GetService("PathfindingService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local TutorialZones = require(ReplicatedStorage.Controllers.TutorialZones);
local LocalPlayer = Players.LocalPlayer;
local u2 = { 3.5, 2 };
local Color3_fromRGB_ret = Color3.fromRGB(255, 236, 60);
local u3 = { "Characters", "TutorialDummies", "TutorialEscorts", "TutorialRetakers", "TutorialCTSquad", "TutorialBAttackers" };
local u4 = { "Range_Entry", "Range_Exit", "Site_Entry", "Site_Exit" };

local function flat(p5: vector) -- Line: 159
    return Vector3.new(p5.X, 0, p5.Z);
end;

local function flatDistance(p6: vector, p7: vector) -- Line: 163
    local v8 = p6 - p7;

    return Vector3.new(v8.X, 0, v8.Z).Magnitude;
end;

local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
local u9 = nil;
local RaycastParams_new_ret2 = RaycastParams.new();
RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
local u10 = nil;

local function isFloorSlab(p11: userdata) -- Line: 178
    local Size = p11.Size;
    local v12;

    if p11.CFrame.UpVector.Y > 0.99 and Size.Y <= 2 then
        v12 = Size.X * Size.Z >= 300;
    else
        v12 = false;
    end;

    return v12;
end;

local u13 = {};
local u14 = {};

local function collectLanes(p15: userdata?) -- Line: 187
    -- upvalues: u13 (copy), u14 (copy)
    table.clear(u13);
    table.clear(u14);

    if not p15 then
        return;
    end;

    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("BasePart") and (descendant.Name == "Arrow" and (descendant.Size.Magnitude <= 8 and descendant.CFrame.UpVector.Y >= 0.99)) then
            local LookVector = descendant.CFrame.LookVector;
            local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);

            if Vector3_new_ret.Magnitude >= 0.5 then
                local Unit = Vector3_new_ret.Unit;

                if Unit.X < -0.5 or math.abs(Unit.X) <= 0.5 and Unit.Z < 0 then
                    Unit = -Unit;
                end;

                local Position = descendant.Position;
                local Vector3_new_ret2 = Vector3.new(Position.X, 0, Position.Z);
                local v16 = nil;

                for _, v in u13 do
                    local v17 = v.Axis:Dot(Unit);

                    if math.abs(v17) >= 0.98 then
                        local v18 = Vector3_new_ret2 - v.Origin;

                        if (v18 - v.Axis * v18:Dot(v.Axis)).Magnitude <= 2 then
                            v16 = v;
                            break;
                        end;
                    end;
                end;

                if v16 then
                    local v19 = (Vector3_new_ret2 - v16.Origin):Dot(v16.Axis);
                    v16.Min = math.min(v16.Min, v19);
                    v16.Max = math.max(v16.Max, v19);
                else
                    table.insert(u13, {
                        Min = 0,
                        Max = 0,
                        Origin = Vector3_new_ret2,
                        Axis = Unit,
                        Joins = {}
                    });
                end;
            end;
        end;
    end;

    for i = 1, #u13 do
        local v20 = i;

        for i2 = i + 1, #u13 do
            local v21 = u13[v20];
            local v22 = u13[i2];
            local v23 = v21.Axis.X * v22.Axis.Z - v21.Axis.Z * v22.Axis.X;
            local v24;

            if math.abs(v23) < 0.2 then
                v24 = i2;
            else
                local v25 = v22.Origin - v21.Origin;
                local v26 = (v25.X * v22.Axis.Z - v25.Z * v22.Axis.X) / v23;
                local v27 = (v25.X * v21.Axis.Z - v25.Z * v21.Axis.X) / v23;

                if v21.Min - 16 <= v26 and (v26 <= v21.Max + 16 and (v22.Min - 16 <= v27 and v27 <= v22.Max + 16)) then
                    table.insert(u14, v21.Origin + v21.Axis * v26);
                    local v28 = #u14;
                    table.insert(v21.Joins, {
                        T = v26,
                        Node = v28
                    });
                    table.insert(v22.Joins, {
                        T = v27,
                        Node = v28
                    });
                    local math_min_ret = math.min(v21.Min, v26);
                    local math_max_ret = math.max(v21.Max, v26);
                    v21.Min = math_min_ret;
                    v21.Max = math_max_ret;
                    local math_min_ret2 = math.min(v22.Min, v27);
                    local math_max_ret2 = math.max(v22.Max, v27);
                    v22.Min = math_min_ret2;
                    v22.Max = math_max_ret2;
                    v24 = i2;
                else
                    v24 = i2;
                end;
            end;
        end;
    end;
end;

local function refreshFloors(p29: userdata?) -- Line: 257
    -- upvalues: u10 (ref), collectLanes (copy), RaycastParams_new_ret2 (copy)
    if p29 == u10 then
        return;
    end;

    u10 = p29;
    collectLanes(p29);
    local v30 = {};
    local v31;

    if p29 then
        v31 = p29:FindFirstChild("Zones");
    else
        v31 = p29;
    end;

    if p29 then
        for _, descendant in p29:GetDescendants() do
            if descendant:IsA("BasePart") and (descendant.CanQuery and (descendant.Transparency < 0.9 and not (v31 and descendant:IsDescendantOf(v31)))) then
                local Size = descendant.Size;
                local v32;

                if descendant.CFrame.UpVector.Y > 0.99 and Size.Y <= 2 then
                    v32 = Size.X * Size.Z >= 300;
                else
                    v32 = false;
                end;

                if v32 then
                    table.insert(v30, descendant);
                end;
            end;
        end;
    end;

    RaycastParams_new_ret2.FilterDescendantsInstances = v30;
end;

local function refreshIgnore() -- Line: 283
    -- upvalues: refreshFloors (copy), u9 (ref), GetRayIgnore (copy), u3 (copy), u4 (copy), RaycastParams_new_ret (copy)
    local Map = workspace:FindFirstChild("Map");
    refreshFloors(Map);

    if Map then
        Map = Map:FindFirstChild("Geometry");
    end;

    u9 = Map;
    local v33 = GetRayIgnore();

    for _, v in u3 do
        local v34 = workspace:FindFirstChild(v);

        if v34 then
            table.insert(v33, v34);
        end;
    end;

    for _, v in u4 do
        local v35 = u9 and u9:FindFirstChild(v);

        if v35 then
            table.insert(v33, v35);
        end;
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v33;
end;

local function snapToFloor(p36: vector) -- Line: 304
    -- upvalues: RaycastParams_new_ret2 (copy), u9 (ref)
    local v37 = workspace:Raycast(p36 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);

    if not v37 then
        return p36;
    end;

    local v38 = u9;
    local v39;

    if v38 == nil then
        v39 = false;
    else
        v39 = v37.Instance:IsDescendantOf(v38);
    end;

    return v37.Position + Vector3.new(0, v39 and 0.25 or 0, 0);
end;

local function isClearLine(p40: vector, p41: vector) -- Line: 316
    -- upvalues: RaycastParams_new_ret2 (copy), u9 (ref), RaycastParams_new_ret (copy)
    local v42 = workspace:Raycast(p40 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);

    if v42 then
        local v43 = u9;
        local v44;

        if v43 == nil then
            v44 = false;
        else
            v44 = v42.Instance:IsDescendantOf(v43);
        end;

        p40 = v42.Position + Vector3.new(0, v44 and 0.25 or 0, 0);
    end;

    local v45 = p40 + Vector3.new(0, 2.6, 0);
    local v46 = workspace:Raycast(p41 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);

    if v46 then
        local v47 = u9;
        local v48;

        if v47 == nil then
            v48 = false;
        else
            v48 = v46.Instance:IsDescendantOf(v47);
        end;

        p41 = v46.Position + Vector3.new(0, v48 and 0.25 or 0, 0);
    end;

    local v49 = p41 + Vector3.new(0, 2.6, 0) - v45;

    if v49.Magnitude < 0.1 then
        return true;
    end;

    local CFrame_lookAt_ret = CFrame.lookAt(v45, v45 + v49);
    local table_clone_ret = table.clone(RaycastParams_new_ret.FilterDescendantsInstances);
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Zones");
    end;

    if Map then
        table.insert(table_clone_ret, Map);
    end;

    local RaycastParams_new_ret3 = RaycastParams.new();
    RaycastParams_new_ret3.FilterType = Enum.RaycastFilterType.Exclude;

    for i = 1, 6 do
        RaycastParams_new_ret3.FilterDescendantsInstances = table_clone_ret;
        local v50 = workspace:Blockcast(CFrame_lookAt_ret, Vector3.new(4.5, 4, 0.2), v49, RaycastParams_new_ret3);

        if not v50 then
            return true;
        end;

        local Instance2 = v50.Instance;

        if not Instance2:IsA("BasePart") or Instance2.Transparency < 0.9 then
            return false;
        end;

        table.insert(table_clone_ret, Instance2);
        local _ = i;
    end;

    return false;
end;

local function computePath(p51: vector, p52: vector) -- Line: 418
    -- upvalues: u2 (copy), PathfindingService (copy)
    for _, v in u2 do
        local v53 = PathfindingService:CreatePath({
            AgentHeight = 5,
            AgentCanJump = true,
            WaypointSpacing = 4,
            AgentRadius = v
        });

        if pcall(v53.ComputeAsync, v53, p51, p52) and v53.Status == Enum.PathStatus.Success then
            local v54 = {};

            for _, v2 in v53:GetWaypoints() do
                table.insert(v54, v2.Position);
            end;

            return v54;
        end;
    end;

    return nil;
end;

local function lanePath(p55: vector, p56: vector) -- Line: 443
    -- upvalues: u13 (copy), u14 (copy), isClearLine (copy)
    if #u13 == 0 then
        return nil;
    end;

    local v57 = { Vector3.new(p55.X, 0, p55.Z), (Vector3.new(p56.X, 0, p56.Z)) };

    for i, v in u14 do
        v57[i + 2] = v;
    end;

    local u58 = {};

    local function link(p59: number, p60: number, p61: number) -- Line: 453
        -- upvalues: u58 (copy)
        u58[p59] = u58[p59] or {};
        table.insert(u58[p59], { p60, p61 });
        u58[p60] = u58[p60] or {};
        table.insert(u58[p60], { p59, p61 });
    end;

    local v62 = p55 - p56;
    link(1, 2, Vector3.new(v62.X, 0, v62.Z).Magnitude * 1.6);

    for _, v in u13 do
        local v63 = v;
        local v64 = {};

        for _, v2 in v.Joins do
            table.insert(v64, {
                T = v2.T,
                Node = v2.Node + 2
            });
        end;

        for i, v2 in { p55, p56 } do
            local v65 = (Vector3.new(v2.X, 0, v2.Z) - v63.Origin):Dot(v63.Axis);
            local math_clamp_ret = math.clamp(v65, v63.Min, v63.Max);
            local v66 = v63.Origin + v63.Axis * math_clamp_ret;
            local v67 = v2 - v66;
            local Magnitude = Vector3.new(v67.X, 0, v67.Z).Magnitude;

            if Magnitude <= 30 and (Magnitude < 1 or isClearLine(v2, (Vector3.new(v66.X, v2.Y, v66.Z)))) then
                table.insert(v57, v66);
                table.insert(v64, {
                    T = math_clamp_ret,
                    Node = #v57
                });
                link(i, #v57, Magnitude * 1.6);
            end;
        end;

        table.sort(v64, function(p68, p69) -- Line: 478
            return p68.T < p69.T;
        end);

        for i = 2, #v64 do
            link(v64[i - 1].Node, v64[i].Node, v64[i].T - v64[i - 1].T);
            local _ = i;
        end;
    end;

    local v70 = { 0 };
    local v71 = {};
    local v72 = {};

    while true do
        local v73 = (1 / 0);
        local v74 = nil;

        for i, v in v70 do
            if not v71[i] and v < v73 then
                v74 = i;
                v73 = v;
            end;
        end;

        if v74 == nil or v74 == 2 then
            if v72[2] == nil or v72[2] == 1 then
                return nil;
            end;

            local v75 = v72[2];
            local v76 = { p56 };

            while v75 and v75 ~= 1 do
                local Vector3_new_ret = Vector3.new(v57[v75].X, p55.Y, v57[v75].Z);
                local v77 = Vector3_new_ret - v76[1];

                if Vector3.new(v77.X, 0, v77.Z).Magnitude > 0.5 then
                    table.insert(v76, 1, Vector3_new_ret);
                end;

                v75 = v72[v75];
            end;

            local v78 = p55 - v76[1];

            if Vector3.new(v78.X, 0, v78.Z).Magnitude > 0.5 then
                table.insert(v76, 1, p55);

                return v76;
            end;

            v76[1] = p55;

            return v76;
        end;

        v71[v74] = true;
        local v79 = u58[v74];

        if v79 then
            for _, v in v79 do
                local v80 = v[1];
                local v81 = v73 + v[2];

                if v81 < (v70[v80] or (1 / 0)) then
                    v70[v80] = v81;
                    v72[v80] = v74;
                end;
            end;
        end;
    end;
end;

local function walkLeg(p82: vector, p83: vector) -- Line: 534
    -- upvalues: lanePath (copy), isClearLine (copy), RaycastParams_new_ret2 (copy), u9 (ref), computePath (copy)
    local v84 = lanePath(p82, p83);

    if v84 then
        return v84;
    end;

    if isClearLine(p82, p83) then
        return { p82, p83 };
    end;

    local v85 = workspace:Raycast(p82 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);
    local v86;

    if v85 then
        local v87 = u9;
        local v88;

        if v87 == nil then
            v88 = false;
        else
            v88 = v85.Instance:IsDescendantOf(v87);
        end;

        v86 = v85.Position + Vector3.new(0, v88 and 0.25 or 0, 0);
    else
        v86 = p82;
    end;

    local v89 = workspace:Raycast(p83 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);
    local v90;

    if v89 then
        local v91 = u9;
        local v92;

        if v91 == nil then
            v92 = false;
        else
            v92 = v89.Instance:IsDescendantOf(v91);
        end;

        v90 = v89.Position + Vector3.new(0, v92 and 0.25 or 0, 0);
    else
        v90 = p83;
    end;

    local v93 = computePath(v86, v90);

    if not v93 then
        local v94 = p82 - p83;
        local Vector3_new_ret = Vector3.new(v94.X, 0, v94.Z);

        if Vector3_new_ret.Magnitude > 3 then
            local v95 = p83 + Vector3_new_ret.Unit * 3;
            local v96 = workspace:Raycast(v95 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);

            if v96 then
                local v97 = u9;
                local v98;

                if v97 == nil then
                    v98 = false;
                else
                    v98 = v96.Instance:IsDescendantOf(v97);
                end;

                v95 = v96.Position + Vector3.new(0, v98 and 0.25 or 0, 0);
            end;

            v93 = computePath(v86, v95);

            if v93 then
                table.insert(v93, p83);
            end;
        end;
    end;

    if not v93 then
        return { p82, p83 };
    end;

    v93[1] = p82;

    return v93;
end;

local function knotGap(p99: vector, p100: vector) -- Line: 629
    local v101 = p99 - p100;
    local v102 = Vector3.new(v101.X, 0, v101.Z).Magnitude ^ 0.5;

    return math.max(v102, 0.0001);
end;

local u103 = {};

local function resample(p104: table) -- Line: 663
    local v105 = { p104[1] };
    local v106 = 0;
    local v107 = 0;

    for i = 2, #p104 do
        local v108 = p104[i - 1];
        local v109 = p104[i];
        local v110 = v108 - v109;
        local Magnitude = Vector3.new(v110.X, 0, v110.Z).Magnitude;
        local v111;

        if Magnitude < 0.001 then
            v111 = i;
        else
            local v112 = 0.5 - v106;
            v111 = i;

            while v112 <= Magnitude do
                table.insert(v105, v108:Lerp(v109, v112 / Magnitude));
                v112 = v112 + 0.5;
            end;

            v106 = Magnitude - (v112 - 0.5);
            v107 = v107 + Magnitude;
        end;
    end;

    local v113 = v105[#v105] - p104[#p104];

    if Vector3.new(v113.X, 0, v113.Z).Magnitude > 0.01 then
        table.insert(v105, p104[#p104]);
    end;

    return v105, v107;
end;

local function remainingPoints(p114: table, p115: vector) -- Line: 377
    local v116 = #p114;

    if v116 <= 1 then
        return table.clone(p114);
    end;

    local Vector3_new_ret = Vector3.new(p115.X, 0, p115.Z);
    local v117 = {};
    local v118 = {};
    local v119 = (1 / 0);

    for i = 1, v116 - 1 do
        local v120 = p114[i];
        local Vector3_new_ret2 = Vector3.new(v120.X, 0, v120.Z);
        local v121 = p114[i + 1];
        local v122 = Vector3.new(v121.X, 0, v121.Z) - Vector3_new_ret2;
        local v123 = v122:Dot(v122);
        local v124 = v123 <= 1e-6 and 0 or (Vector3_new_ret - Vector3_new_ret2):Dot(v122) / v123;
        v117[i] = (Vector3_new_ret - (Vector3_new_ret2 + v122 * math.clamp(v124, 0, 1))).Magnitude;
        v118[i] = v124;
        v119 = math.min(v119, v117[i]);
        local _ = i;
    end;

    local v125 = 1;

    for i = v116 - 1, 1, -1 do
        if v117[i] <= v119 + 2 then
            v125 = i;
            break;
        end;

        local _ = i;
    end;

    local v126 = v125 + 1;

    if v125 == 1 and v118[1] <= 0 then
        v126 = 1;
    elseif v118[v125] >= 1 then
        v126 = v125 + 2;
    end;

    local math_min_ret = math.min(v126, v116);

    return table.move(p114, math_min_ret, v116, 1, {});
end;

local function decodeRoute() -- Line: 351
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local Attribute = LocalPlayer:GetAttribute("TutorialGuide");

    if typeof(Attribute) ~= "string" then
        return nil;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute);

    if not (success and (typeof(result) == "table" and typeof(result.p) == "table")) then
        return nil;
    end;

    local v127 = {};

    for _, v in result.p do
        if typeof(v) == "table" and typeof(v[1]) == "number" then
            local Vector3_new_ret = Vector3.new(v[1], v[2], v[3]);
            table.insert(v127, Vector3_new_ret);
        end;
    end;

    return #v127 ~= 0 and {
        Points = v127,
        Radius = typeof(result.r) ~= "number" and 5 or result.r,
        Key = Attribute
    } or nil;
end;

local function spline(p128: table) -- Line: 634
    local v129 = #p128;

    if v129 < 2 then
        return p128;
    end;

    local v130 = { p128[1] };

    for i = 1, v129 - 1 do
        local v131 = p128[i];
        local v132 = p128[i + 1];
        local v133;

        if i > 1 then
            v133 = p128[i - 1];
        else
            v133 = v131 + (v131 - v132);
        end;

        local v134;

        if i + 2 <= v129 then
            v134 = p128[i + 2];
        else
            v134 = v132 + (v132 - v131);
        end;

        local v135 = v133 - v131;
        local v136 = Vector3.new(v135.X, 0, v135.Z).Magnitude ^ 0.5;
        local math_max_ret = math.max(v136, 0.0001);
        local v137 = v131 - v132;
        local v138 = Vector3.new(v137.X, 0, v137.Z).Magnitude ^ 0.5;
        local v139 = math_max_ret + math.max(v138, 0.0001);
        local v140 = v132 - v134;
        local v141 = Vector3.new(v140.X, 0, v140.Z).Magnitude ^ 0.5;
        local v142 = v139 + math.max(v141, 0.0001);
        local v143 = v131 - v132;
        local v144 = Vector3.new(v143.X, 0, v143.Z).Magnitude / 0.5;
        local math_ceil_ret = math.ceil(v144);
        local math_max_ret2 = math.max(1, math_ceil_ret);
        local _ = i;

        for i2 = 1, math_max_ret2 do
            local v145 = math_max_ret + (v139 - math_max_ret) * (i2 / math_max_ret2);
            local v146 = v131 * ((v139 - v145) / (v139 - math_max_ret)) + v132 * ((v145 - math_max_ret) / (v139 - math_max_ret));
            table.insert(v130, ((v133 * ((math_max_ret - v145) / math_max_ret) + v131 * (v145 / math_max_ret)) * ((v139 - v145) / v139) + v146 * (v145 / v139)) * ((v139 - v145) / (v139 - math_max_ret)) + (v146 * ((v142 - v145) / (v142 - math_max_ret)) + (v132 * ((v142 - v145) / (v142 - v139)) + v134 * ((v145 - v139) / (v142 - v139))) * ((v145 - math_max_ret) / (v142 - math_max_ret))) * ((v145 - math_max_ret) / (v139 - math_max_ret)));
            local _ = i2;
        end;
    end;

    return v130;
end;

local function roundCorners(p147: table) -- Line: 600
    -- upvalues: isClearLine (copy)
    for i = 1, 2 do
        if #p147 < 3 then
            return p147;
        end;

        local v148 = { p147[1] };
        local _ = i;

        for i2 = 2, #p147 - 1 do
            local v149 = p147[i2 - 1];
            local v150 = p147[i2];
            local v151 = p147[i2 + 1];
            local Magnitude = (v150 - v149).Magnitude;
            local Magnitude2 = (v151 - v150).Magnitude;
            local v152;

            if Magnitude < 0.001 or Magnitude2 < 0.001 then
                table.insert(v148, v150);
                v152 = i2;
            else
                local v153 = v150:Lerp(v149, math.min(Magnitude * 0.25, 2) / Magnitude);
                local v154 = v150:Lerp(v151, math.min(Magnitude2 * 0.25, 2) / Magnitude2);

                if isClearLine(v153, v154) then
                    table.insert(v148, v153);
                    table.insert(v148, v154);
                    v152 = i2;
                else
                    table.insert(v148, v150);
                    v152 = i2;
                end;
            end;
        end;

        table.insert(v148, p147[#p147]);
        p147 = v148;
    end;

    return p147;
end;

local function simplify(p155: table) -- Line: 562
    if #p155 < 3 then
        return p155;
    end;

    local table_create_ret = table.create(#p155, false);
    table_create_ret[1] = true;
    table_create_ret[#p155] = true;
    local v156 = {
        { 1, #p155 }
    };

    while #v156 > 0 do
        local table_remove_ret = table.remove(v156);
        local v157 = table_remove_ret[1];
        local v158 = table_remove_ret[2];
        local v159 = p155[v157];
        local Vector3_new_ret = Vector3.new(v159.X, 0, v159.Z);
        local v160 = p155[v158];
        local v161 = Vector3.new(v160.X, 0, v160.Z) - Vector3_new_ret;
        local Magnitude = v161.Magnitude;
        local v162 = 0;
        local v163 = 0;

        for i = v157 + 1, v158 - 1 do
            local v164 = p155[i];
            local Vector3_new_ret2 = Vector3.new(v164.X, 0, v164.Z);
            local v165;

            if Magnitude > 0.001 then
                v165 = v161:Cross(Vector3_new_ret2 - Vector3_new_ret).Magnitude / Magnitude;
            else
                v165 = (Vector3_new_ret2 - Vector3_new_ret).Magnitude;
            end;

            local v166;

            if v162 < v165 then
                v163 = i;
                v162 = v165;
                v166 = v163;
                local v167 = v163;
                v163 = v166;
                v167 = v166;
            else
                v166 = i;
            end;
        end;

        if v162 > 0.5 then
            table_create_ret[v163] = true;
            table.insert(v156, { v157, v163 });
            table.insert(v156, { v163, v158 });
        end;
    end;

    local v168 = {};

    for i, v in p155 do
        if table_create_ret[i] then
            table.insert(v168, v);
        end;
    end;

    return v168;
end;

local function sampleCurve(p169: table, p170: number) -- Line: 688
    local v171 = p170 / 0.5 + 1;
    local math_floor_ret = math.floor(v171);
    local math_clamp_ret = math.clamp(math_floor_ret, 1, #p169);
    local math_min_ret = math.min(math_clamp_ret + 1, #p169);
    local v172 = p169[math_clamp_ret]:Lerp(p169[math_min_ret], v171 - math.floor(v171));
    local v173 = p169[math.max(math_clamp_ret - 1, 1)];
    local v174 = p169[math.min(math_clamp_ret + 2, #p169)] - v173;

    return v172, Vector3.new(v174.X, 0, v174.Z);
end;

for _, v in { 1, -1 } do
    local Vector3_new_ret = Vector3.new(v * 0.6691306063588582, 0, 0.7431448254773942);
    local Vector3_new_ret2 = Vector3.new(-v * 0.7431448254773942, 0, 0.6691306063588582);
    local v175 = Vector3.new(0, 0, -0.83603793) + Vector3_new_ret * 0.6996858843423915;
    local v176 = {
        ClassName = "WedgePart",
        Size = Vector3.new(0.05, 0.63, 0.6996859),
        Offset = CFrame.fromMatrix(v175 + Vector3_new_ret2 * 0.315 - Vector3_new_ret * 0.34984294217119577, Vector3_new_ret2:Cross(Vector3_new_ret), Vector3_new_ret2, Vector3_new_ret)
    };
    table.insert(u103, v176);
    local v177 = {
        ClassName = "Part",
        Size = Vector3.new(0.63, 0.05, 1.5503141),
        Offset = CFrame.fromMatrix(v175 + Vector3_new_ret * 0.7751570578288043 + Vector3_new_ret2 * 0.315, Vector3_new_ret2, Vector3.new(0, 1, 0))
    };
    table.insert(u103, v177);
end;

local u178 = nil;
local u179 = {};

local function ensureFolder() -- Line: 734
    -- upvalues: u178 (ref), u179 (copy)
    if u178 and u178.Parent then
        return u178;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "TutorialGuide";
    Folder.Parent = workspace.CurrentCamera;
    u178 = Folder;
    table.clear(u179);

    return Folder;
end;

local function newPart(p180: string?) -- Line: 746
    -- upvalues: Color3_fromRGB_ret (copy), u178 (ref), u179 (copy)
    local Instance_new_ret = Instance.new(p180 or "Part");
    Instance_new_ret.Anchored = true;
    Instance_new_ret.CanCollide = false;
    Instance_new_ret.CanQuery = false;
    Instance_new_ret.CanTouch = false;
    Instance_new_ret.CastShadow = false;
    Instance_new_ret.Material = Enum.Material.Neon;
    Instance_new_ret.Color = Color3_fromRGB_ret;
    Instance_new_ret.Transparency = 1;
    local v181;

    if u178 and u178.Parent then
        v181 = u178;
    else
        v181 = Instance.new("Folder");
        v181.Name = "TutorialGuide";
        v181.Parent = workspace.CurrentCamera;
        u178 = v181;
        table.clear(u179);
    end;

    Instance_new_ret.Parent = v181;

    return Instance_new_ret;
end;

local function getChevron(p182: number) -- Line: 760
    -- upvalues: u178 (ref), u179 (copy), u103 (copy), Color3_fromRGB_ret (copy)
    if not (u178 and u178.Parent) then
        local Folder = Instance.new("Folder");
        Folder.Name = "TutorialGuide";
        Folder.Parent = workspace.CurrentCamera;
        u178 = Folder;
        table.clear(u179);
    end;

    local v183 = u179[p182];

    if v183 then
        return v183;
    end;

    local v184 = {};

    for _, v in u103 do
        local Instance_new_ret = Instance.new(v.ClassName or "Part");
        Instance_new_ret.Anchored = true;
        Instance_new_ret.CanCollide = false;
        Instance_new_ret.CanQuery = false;
        Instance_new_ret.CanTouch = false;
        Instance_new_ret.CastShadow = false;
        Instance_new_ret.Material = Enum.Material.Neon;
        Instance_new_ret.Color = Color3_fromRGB_ret;
        Instance_new_ret.Transparency = 1;
        local v185;

        if u178 and u178.Parent then
            v185 = u178;
        else
            v185 = Instance.new("Folder");
            v185.Name = "TutorialGuide";
            v185.Parent = workspace.CurrentCamera;
            u178 = v185;
            table.clear(u179);
        end;

        Instance_new_ret.Parent = v185;
        Instance_new_ret.Size = v.Size;
        table.insert(v184, Instance_new_ret);
    end;

    local v186 = {
        Trail = nil,
        Along = 0,
        Traveled = 0,
        Stop = 0,
        Active = false,
        Transparency = 1,
        Parts = v184
    };
    u179[p182] = v186;

    return v186;
end;

local function setChevronTransparency(p187: table, p188: number) -- Line: 778
    if p187.Transparency == p188 then
        return;
    end;

    if math.abs(p187.Transparency - p188) < 0.02 and p188 ~= 1 then
        return;
    end;

    p187.Transparency = p188;

    for _, v in p187.Parts do
        v.Transparency = p188;
    end;
end;

local u189 = {};
local u190 = {};

local function placeChevron(p191: table, p192: vector, p193: vector) -- Line: 795
    -- upvalues: u103 (copy), u189 (copy), u190 (copy)
    local v194 = CFrame.lookAt(p192, p192 + p193) * CFrame.new(0, 0.05, 0);

    for i, v in u103 do
        table.insert(u189, p191.Parts[i]);
        table.insert(u190, v194 * v.Offset);
    end;
end;

local function hideParts() -- Line: 803
    -- upvalues: u179 (copy)
    for _, v in u179 do
        v.Active = false;

        if v.Transparency ~= 1 then
            local _ = math.abs(v.Transparency - 1) < 0.02;
            v.Transparency = 1;

            for _, v2 in v.Parts do
                v2.Transparency = 1;
            end;
        end;
    end;
end;

local u195 = 0;

local function buildTrail(p196: table, p197: vector, p198: number) -- Line: 816
    -- upvalues: refreshIgnore (copy), remainingPoints (copy), walkLeg (copy), u195 (ref), RaycastParams_new_ret (copy), RaycastParams_new_ret2 (copy), u9 (ref), resample (copy), spline (copy), roundCorners (copy), simplify (copy)
    refreshIgnore();
    local v199 = p197;
    local v200 = { p197 };

    for _, v in remainingPoints(p196.Points, p197) do
        local v201 = walkLeg(p197, v);
        p197 = v;

        for i = 2, #v201 do
            table.insert(v200, v201[i]);
            local _ = i;
        end;
    end;

    if p198 ~= u195 then
        return nil;
    end;

    for i = 2, #v200 do
        local v202 = v200[i] - v199;
        local Vector3_new_ret = Vector3.new(v202.X, 0, v202.Z);

        if Vector3_new_ret.Magnitude > 0.5 then
            local v203 = -Vector3_new_ret.Unit * 6;
            local v204 = workspace:Raycast(v199, v203, RaycastParams_new_ret);
            local v205 = not v204 and 6 or math.max(v204.Distance - 0.5, 0);

            if v205 > 0.5 then
                table.insert(v200, 1, v199 + v203.Unit * v205);
            end;

            break;
        end;

        local _ = i;
    end;

    for i, v in v200 do
        local v206 = workspace:Raycast(v + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);
        local v207;

        if v206 then
            local v208 = u9;
            local v209;

            if v208 == nil then
                v209 = false;
            else
                v209 = v206.Instance:IsDescendantOf(v208);
            end;

            v207 = v206.Position + Vector3.new(0, v209 and 0.25 or 0, 0);
        else
            v207 = v;
        end;

        v200[i] = v207;
    end;

    local v210, v211 = resample((spline((roundCorners((simplify(v200)))))));

    return #v210 >= 2 and {
        Dense = v210,
        Total = v211,
        Floor = {}
    } or nil;
end;

local function floorSample(p212: table, p213: number) -- Line: 860
    -- upvalues: RaycastParams_new_ret2 (copy), u9 (ref)
    local v214 = p212.Floor[p213];

    if v214 then
        return v214;
    end;

    local v215 = p212.Dense[p213];
    local v216 = workspace:Raycast(v215 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);

    if v216 then
        local v217 = u9;
        local v218;

        if v217 == nil then
            v218 = false;
        else
            v218 = v216.Instance:IsDescendantOf(v217);
        end;

        v215 = v216.Position + Vector3.new(0, v218 and 0.25 or 0, 0);
    end;

    p212.Floor[p213] = v215;

    return v215;
end;

local function floorPointAt(p219: table, p220: number) -- Line: 871
    -- upvalues: sampleCurve (copy), RaycastParams_new_ret2 (copy), u9 (ref)
    local _, v221 = sampleCurve(p219.Dense, p220);
    local v222 = p220 / 0.5 + 1;
    local math_floor_ret = math.floor(v222);
    local math_clamp_ret = math.clamp(math_floor_ret, 1, #p219.Dense);
    local math_min_ret = math.min(math_clamp_ret + 1, #p219.Dense);
    local v223 = p219.Floor[math_clamp_ret];

    if not v223 then
        v223 = p219.Dense[math_clamp_ret];
        local v224 = workspace:Raycast(v223 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);

        if v224 then
            local v225 = u9;
            local v226;

            if v225 == nil then
                v226 = false;
            else
                v226 = v224.Instance:IsDescendantOf(v225);
            end;

            v223 = v224.Position + Vector3.new(0, v226 and 0.25 or 0, 0);
        end;

        p219.Floor[math_clamp_ret] = v223;
    end;

    local v227 = p219.Floor[math_min_ret];

    if not v227 then
        v227 = p219.Dense[math_min_ret];
        local v228 = workspace:Raycast(v227 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);

        if v228 then
            local v229 = u9;
            local v230;

            if v229 == nil then
                v230 = false;
            else
                v230 = v228.Instance:IsDescendantOf(v229);
            end;

            v227 = v228.Position + Vector3.new(0, v230 and 0.25 or 0, 0);
        end;

        p219.Floor[math_min_ret] = v227;
    end;

    return v223:Lerp(v227, v222 - math.floor(v222)), v221;
end;

local function projectOnto(p231: table, u232: vector, p233: number) -- Line: 881
    local Dense = p231.Dense;

    local function search(p234: number, p235: number) -- Line: 883
        -- upvalues: Dense (copy), u232 (copy)
        local v236 = (1 / 0);

        for i = p234, p235 do
            local v237 = Dense[i] - u232;
            local Magnitude = Vector3.new(v237.X, 0, v237.Z).Magnitude;
            local v238;

            if Magnitude < v236 then
                p234 = i;
                v236 = Magnitude;
                v238 = p234;
                local v239 = p234;
                p234 = v238;
                v239 = v238;
            else
                v238 = i;
            end;
        end;

        return p234, v236;
    end;

    local v240, v241 = search(math.max(1, p233 - 80), (math.min(#Dense, p233 + 80)));

    if v241 > 7 then
        v240, v241 = search(1, #Dense);
    end;

    return (v240 - 1) * 0.5, v241, v240;
end;

local u242 = nil;
local u243 = nil;
local u244 = nil;
local u245 = 0;
local u246 = 0;
local u247 = 1;
local u248 = 0;
local u249 = false;
local u250 = true;
local u251 = 0;
local u252 = false;

local function freeChevron() -- Line: 918
    -- upvalues: u179 (copy), getChevron (copy)
    for _, v in u179 do
        if not v.Active then
            return v;
        end;
    end;

    return getChevron(#u179 + 1);
end;

local function spawnGroup(p253: table) -- Line: 928
    -- upvalues: u245 (ref), u179 (copy), getChevron (copy)
    local math_max_ret = math.max(u245 - 6, 0);
    local v254 = p253.Total - 3;

    for i = 1, 3 do
        local v255 = math_max_ret + (3 - i) * 2.6;
        local v256;

        if v254 - v255 >= 2 then
            v256 = i;
            local v257;

            for _, v in u179 do
                if not v.Active then
                    v257 = v;
                    break;
                end;
            end;

            v257 = getChevron(#u179 + 1);
            v257.Active = true;
            v257.Trail = p253;
            v257.Along = v255;
            v257.Traveled = 0;
            v257.Stop = v254;
        else
            v256 = i;
        end;
    end;
end;

local function draw(p258: number) -- Line: 942
    -- upvalues: u248 (ref), u249 (ref), u245 (ref), u246 (ref), u243 (ref), u250 (ref), u179 (copy), u251 (ref), u252 (ref), u189 (copy), u190 (copy), floorPointAt (copy), placeChevron (copy)
    local v259;

    if u249 then
        v259 = p258;
    else
        v259 = -p258;
    end;

    u248 = math.clamp(u248 + v259 * 3, 0, 1);
    u245 = u245 + (u246 - u245) * math.min(1, p258 * 12);

    if u248 <= 0 or not u243 then
        if not u250 then
            u250 = true;

            for _, v in u179 do
                v.Active = false;

                if v.Transparency ~= 1 then
                    local _ = math.abs(v.Transparency - 1) < 0.02;
                    v.Transparency = 1;

                    for _, v2 in v.Parts do
                        v2.Transparency = 1;
                    end;
                end;
            end;
        end;

        u251 = 1;

        return;
    end;

    u250 = false;

    if u249 and not u252 then
        u251 = u251 + p258;

        if u251 >= 1 then
            u252 = true;
        end;
    end;

    table.clear(u189);
    table.clear(u190);

    for _, v in u179 do
        local Trail = v.Trail;

        if v.Active and Trail then
            local v260 = p258 * 15;
            v.Along = v.Along + v260;
            v.Traveled = v.Traveled + v260;
            local v261 = v.Stop - v.Along;

            if v261 <= 0 then
                v.Active = false;

                if v.Transparency ~= 1 then
                    local _ = math.abs(v.Transparency - 1) < 0.02;
                    v.Transparency = 1;

                    for _, v2 in v.Parts do
                        v2.Transparency = 1;
                    end;
                end;
            else
                local v262 = math.clamp(v.Traveled / 2, 0, 1) * math.clamp(v261 / 6, 0, 1) * u248;
                local v263, v264 = floorPointAt(Trail, v.Along);

                if v264.Magnitude > 0.01 then
                    placeChevron(v, v263, v264.Unit);
                end;

                local v265 = math.floor((1 - v262) / 0.02 + 0.5) * 0.02;

                if v.Transparency ~= v265 then
                    if math.abs(v.Transparency - v265) >= 0.02 or v265 == 1 then
                        v.Transparency = v265;

                        for _, v2 in v.Parts do
                            v2.Transparency = v265;
                        end;
                    end;
                end;
            end;
        end;
    end;

    if #u189 > 0 then
        workspace:BulkMoveTo(u189, u190, Enum.BulkMoveMode.FireCFrameChanged);
    end;
end;

local u266 = false;

local function prewarm() -- Line: 997
    -- upvalues: u266 (ref), getChevron (copy)
    if u266 then
        return;
    end;

    u266 = true;

    for i = 1, 24 do
        getChevron(i);
        local v267;

        if i % 4 == 0 then
            task.wait();
            v267 = i;
        else
            v267 = i;
        end;
    end;
end;

local function track(p268: number) -- Line: 1010
    -- upvalues: u195 (ref), u242 (ref), CharacterResolver (copy), u249 (ref), TutorialZones (copy), u243 (ref), u252 (ref), projectOnto (copy), u247 (ref), u246 (ref), prewarm (copy), buildTrail (copy), u251 (ref), u245 (ref), spawnGroup (copy)
    local v269 = false;
    local v270 = nil;

    while p268 == u195 do
        local v271 = u242;
        local LocalCharacter = CharacterResolver.getLocalCharacter();
        local v272;

        if LocalCharacter then
            v272 = CharacterResolver.getRootPart(LocalCharacter);
        else
            v272 = LocalCharacter;
        end;

        if v271 and (v272 and CharacterResolver.isAliveCharacter(LocalCharacter)) then
            local Position = v272.Position;
            local v273 = Position - v271.Points[#v271.Points];
            local Magnitude = Vector3.new(v273.X, 0, v273.Z).Magnitude;
            local v274 = TutorialZones.IsInside(Position);

            if v274 then
                v269 = v274;
            elseif Magnitude <= v271.Radius then
                v269 = true;
            elseif v269 then
                v269 = Magnitude <= math.max(v271.Radius * 1.6, 20);
            end;

            if v269 then
                u249 = false;
                u243 = nil;
                task.wait(0.1);
            else
                local v275 = u243;
                local v276 = v275 == nil and true or u252;

                if v275 then
                    local v277, v278, v279 = projectOnto(v275, Position, u247);
                    u246 = v277;
                    u247 = v279;

                    if v278 > 7 then
                        v270 = v270 or os.clock();
                        v276 = os.clock() - v270 >= 0.75;
                    else
                        v270 = nil;
                    end;
                end;

                if v276 then
                    v270 = nil;
                    prewarm();

                    if p268 ~= u195 then
                        return;
                    end;

                    local v280 = buildTrail(v271, Position, p268);

                    if p268 ~= u195 then
                        return;
                    end;

                    u243 = v280;
                    u252 = false;
                    u251 = 0;
                    u247 = 1;
                    u245 = 0;
                    u246 = 0;

                    if v280 then
                        local Position2 = v272.Position;
                        local Dense = v280.Dense;

                        local function v287(p281: number, p282: number) -- Line: 883
                            -- upvalues: Dense (copy), Position2 (copy)
                            local v283 = (1 / 0);

                            for i = p281, p282 do
                                local v284 = Dense[i] - Position2;
                                local Magnitude2 = Vector3.new(v284.X, 0, v284.Z).Magnitude;
                                local v285;

                                if Magnitude2 < v283 then
                                    p281 = i;
                                    v283 = Magnitude2;
                                    v285 = p281;
                                    local v286 = p281;
                                    p281 = v285;
                                    v286 = v285;
                                else
                                    v285 = i;
                                end;
                            end;

                            return p281, v283;
                        end;

                        local v288, v289 = v287(1, (math.min(#Dense, 81)));

                        if v289 > 7 then
                            v288, v289 = v287(1, #Dense);
                        end;

                        local v290 = (v288 - 1) * 0.5;
                        u247 = v288;
                        u245 = v290;
                        u246 = v290;
                        spawnGroup(v280);
                    end;
                end;

                u249 = u243 ~= nil;
                task.wait(0.1);
            end;
        else
            u249 = false;
            task.wait(0.1);
        end;
    end;
end;

local function sync() -- Line: 1078
    -- upvalues: IsTutorialMode (copy), decodeRoute (copy), u242 (ref), u195 (ref), u243 (ref), u249 (ref), u248 (ref), u250 (ref), u179 (copy), u244 (ref), RunServiceController (copy), draw (copy), track (copy)
    local v291;

    if IsTutorialMode() then
        v291 = decodeRoute();
    else
        v291 = nil;
    end;

    if v291 and (u242 and v291.Key == u242.Key) then
        return;
    end;

    u195 = u195 + 1;
    u242 = v291;
    u243 = nil;

    if not v291 then
        u249 = false;

        return;
    end;

    u248 = 0;
    u250 = true;

    for _, v in u179 do
        v.Active = false;

        if v.Transparency ~= 1 then
            local _ = math.abs(v.Transparency - 1) < 0.02;
            v.Transparency = 1;

            for _, v2 in v.Parts do
                v2.Transparency = 1;
            end;
        end;
    end;

    if not u244 then
        u244 = RunServiceController.BindToHeartbeat("TutorialGuide.Draw", draw);
    end;

    task.spawn(track, u195);
end;

function v1.Start() -- Line: 1100
    -- upvalues: LocalPlayer (copy), sync (copy)
    LocalPlayer:GetAttributeChangedSignal("TutorialGuide"):Connect(sync);
    sync();
end;

return v1;