-- TutorialGuide (ModuleScript)
-- full path: ReplicatedStorage.Controllers.TutorialGuide

-- Decompiled with Potassium's decompiler.

local v1 = {};
local HttpService = game:GetService("HttpService");
local PathfindingService = game:GetService("PathfindingService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CatmullRomPath = require(ReplicatedStorage.Components.Common.CatmullRomPath);
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

local function flat(p5: vector) -- Line: 160
    return Vector3.new(p5.X, 0, p5.Z);
end;

local function flatDistance(p6: vector, p7: vector) -- Line: 164
    local v8 = p6 - p7;

    return Vector3.new(v8.X, 0, v8.Z).Magnitude;
end;

local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
local u9 = nil;
local RaycastParams_new_ret2 = RaycastParams.new();
RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
local u10 = nil;

local function isFloorSlab(p11: userdata) -- Line: 179
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

local function collectLanes(p15: userdata?) -- Line: 188
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

local function refreshFloors(p29: userdata?) -- Line: 258
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

local function refreshIgnore() -- Line: 284
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

local function snapToFloor(p36: vector) -- Line: 305
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

local function isClearLine(p40: vector, p41: vector) -- Line: 317
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

local function computePath(p51: vector, p52: vector) -- Line: 419
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

local function lanePath(p55: vector, p56: vector) -- Line: 444
    -- upvalues: u13 (copy), u14 (copy), isClearLine (copy)
    if #u13 == 0 then
        return nil;
    end;

    local v57 = { Vector3.new(p55.X, 0, p55.Z), (Vector3.new(p56.X, 0, p56.Z)) };

    for i, v in u14 do
        v57[i + 2] = v;
    end;

    local u58 = {};

    local function link(p59: number, p60: number, p61: number) -- Line: 454
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

        table.sort(v64, function(p68, p69) -- Line: 479
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

local function walkLeg(p82: vector, p83: vector) -- Line: 535
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

local function sampleCurve(p99: table, p100: number) -- Line: 631
    -- upvalues: CatmullRomPath (copy)
    local v101, v102, v103 = CatmullRomPath.locate(#p99, 0.5, p100);
    local v104 = p99[v101]:Lerp(p99[v102], v103);
    local v105 = p99[math.max(v101 - 1, 1)];
    local v106 = p99[math.min(v101 + 2, #p99)] - v105;

    return v104, Vector3.new(v106.X, 0, v106.Z);
end;

local u107 = {};

local function roundCorners(p108: table) -- Line: 601
    -- upvalues: isClearLine (copy)
    for i = 1, 2 do
        if #p108 < 3 then
            return p108;
        end;

        local v109 = { p108[1] };
        local _ = i;

        for i2 = 2, #p108 - 1 do
            local v110 = p108[i2 - 1];
            local v111 = p108[i2];
            local v112 = p108[i2 + 1];
            local Magnitude = (v111 - v110).Magnitude;
            local Magnitude2 = (v112 - v111).Magnitude;
            local v113;

            if Magnitude < 0.001 or Magnitude2 < 0.001 then
                table.insert(v109, v111);
                v113 = i2;
            else
                local v114 = v111:Lerp(v110, math.min(Magnitude * 0.25, 2) / Magnitude);
                local v115 = v111:Lerp(v112, math.min(Magnitude2 * 0.25, 2) / Magnitude2);

                if isClearLine(v114, v115) then
                    table.insert(v109, v114);
                    table.insert(v109, v115);
                    v113 = i2;
                else
                    table.insert(v109, v111);
                    v113 = i2;
                end;
            end;
        end;

        table.insert(v109, p108[#p108]);
        p108 = v109;
    end;

    return p108;
end;

local function simplify(p116: table) -- Line: 563
    if #p116 < 3 then
        return p116;
    end;

    local table_create_ret = table.create(#p116, false);
    table_create_ret[1] = true;
    table_create_ret[#p116] = true;
    local v117 = {
        { 1, #p116 }
    };

    while #v117 > 0 do
        local table_remove_ret = table.remove(v117);
        local v118 = table_remove_ret[1];
        local v119 = table_remove_ret[2];
        local v120 = p116[v118];
        local Vector3_new_ret = Vector3.new(v120.X, 0, v120.Z);
        local v121 = p116[v119];
        local v122 = Vector3.new(v121.X, 0, v121.Z) - Vector3_new_ret;
        local Magnitude = v122.Magnitude;
        local v123 = 0;
        local v124 = 0;

        for i = v118 + 1, v119 - 1 do
            local v125 = p116[i];
            local Vector3_new_ret2 = Vector3.new(v125.X, 0, v125.Z);
            local v126;

            if Magnitude > 0.001 then
                v126 = v122:Cross(Vector3_new_ret2 - Vector3_new_ret).Magnitude / Magnitude;
            else
                v126 = (Vector3_new_ret2 - Vector3_new_ret).Magnitude;
            end;

            local v127;

            if v123 < v126 then
                v124 = i;
                v123 = v126;
                v127 = v124;
                local v128 = v124;
                v124 = v127;
                v128 = v127;
            else
                v127 = i;
            end;
        end;

        if v123 > 0.5 then
            table_create_ret[v124] = true;
            table.insert(v117, { v118, v124 });
            table.insert(v117, { v124, v119 });
        end;
    end;

    local v129 = {};

    for i, v in p116 do
        if table_create_ret[i] then
            table.insert(v129, v);
        end;
    end;

    return v129;
end;

local function remainingPoints(p130: table, p131: vector) -- Line: 378
    local v132 = #p130;

    if v132 <= 1 then
        return table.clone(p130);
    end;

    local Vector3_new_ret = Vector3.new(p131.X, 0, p131.Z);
    local v133 = {};
    local v134 = {};
    local v135 = (1 / 0);

    for i = 1, v132 - 1 do
        local v136 = p130[i];
        local Vector3_new_ret2 = Vector3.new(v136.X, 0, v136.Z);
        local v137 = p130[i + 1];
        local v138 = Vector3.new(v137.X, 0, v137.Z) - Vector3_new_ret2;
        local v139 = v138:Dot(v138);
        local v140 = v139 <= 1e-6 and 0 or (Vector3_new_ret - Vector3_new_ret2):Dot(v138) / v139;
        v133[i] = (Vector3_new_ret - (Vector3_new_ret2 + v138 * math.clamp(v140, 0, 1))).Magnitude;
        v134[i] = v140;
        v135 = math.min(v135, v133[i]);
        local _ = i;
    end;

    local v141 = 1;

    for i = v132 - 1, 1, -1 do
        if v133[i] <= v135 + 2 then
            v141 = i;
            break;
        end;

        local _ = i;
    end;

    local v142 = v141 + 1;

    if v141 == 1 and v134[1] <= 0 then
        v142 = 1;
    elseif v134[v141] >= 1 then
        v142 = v141 + 2;
    end;

    local math_min_ret = math.min(v142, v132);

    return table.move(p130, math_min_ret, v132, 1, {});
end;

local function decodeRoute() -- Line: 352
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local Attribute = LocalPlayer:GetAttribute("TutorialGuide");

    if typeof(Attribute) ~= "string" then
        return nil;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute);

    if not (success and (typeof(result) == "table" and typeof(result.p) == "table")) then
        return nil;
    end;

    local v143 = {};

    for _, v in result.p do
        if typeof(v) == "table" and typeof(v[1]) == "number" then
            local Vector3_new_ret = Vector3.new(v[1], v[2], v[3]);
            table.insert(v143, Vector3_new_ret);
        end;
    end;

    return #v143 ~= 0 and {
        Points = v143,
        Radius = typeof(result.r) ~= "number" and 5 or result.r,
        Key = Attribute
    } or nil;
end;

for _, v in { 1, -1 } do
    local Vector3_new_ret = Vector3.new(v * 0.6691306063588582, 0, 0.7431448254773942);
    local Vector3_new_ret2 = Vector3.new(-v * 0.7431448254773942, 0, 0.6691306063588582);
    local v144 = Vector3.new(0, 0, -0.83603793) + Vector3_new_ret * 0.6996858843423915;
    local v145 = {
        ClassName = "WedgePart",
        Size = Vector3.new(0.05, 0.63, 0.6996859),
        Offset = CFrame.fromMatrix(v144 + Vector3_new_ret2 * 0.315 - Vector3_new_ret * 0.34984294217119577, Vector3_new_ret2:Cross(Vector3_new_ret), Vector3_new_ret2, Vector3_new_ret)
    };
    table.insert(u107, v145);
    local v146 = {
        ClassName = "Part",
        Size = Vector3.new(0.63, 0.05, 1.5503141),
        Offset = CFrame.fromMatrix(v144 + Vector3_new_ret * 0.7751570578288043 + Vector3_new_ret2 * 0.315, Vector3_new_ret2, Vector3.new(0, 1, 0))
    };
    table.insert(u107, v146);
end;

local u147 = nil;
local u148 = {};

local function ensureFolder() -- Line: 675
    -- upvalues: u147 (ref), u148 (copy)
    if u147 and u147.Parent then
        return u147;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "TutorialGuide";
    Folder.Parent = workspace.CurrentCamera;
    u147 = Folder;
    table.clear(u148);

    return Folder;
end;

local function newPart(p149: string?) -- Line: 687
    -- upvalues: Color3_fromRGB_ret (copy), u147 (ref), u148 (copy)
    local Instance_new_ret = Instance.new(p149 or "Part");
    Instance_new_ret.Anchored = true;
    Instance_new_ret.CanCollide = false;
    Instance_new_ret.CanQuery = false;
    Instance_new_ret.CanTouch = false;
    Instance_new_ret.CastShadow = false;
    Instance_new_ret.Material = Enum.Material.Neon;
    Instance_new_ret.Color = Color3_fromRGB_ret;
    Instance_new_ret.Transparency = 1;
    local v150;

    if u147 and u147.Parent then
        v150 = u147;
    else
        v150 = Instance.new("Folder");
        v150.Name = "TutorialGuide";
        v150.Parent = workspace.CurrentCamera;
        u147 = v150;
        table.clear(u148);
    end;

    Instance_new_ret.Parent = v150;

    return Instance_new_ret;
end;

local function getChevron(p151: number) -- Line: 701
    -- upvalues: u147 (ref), u148 (copy), u107 (copy), Color3_fromRGB_ret (copy)
    if not (u147 and u147.Parent) then
        local Folder = Instance.new("Folder");
        Folder.Name = "TutorialGuide";
        Folder.Parent = workspace.CurrentCamera;
        u147 = Folder;
        table.clear(u148);
    end;

    local v152 = u148[p151];

    if v152 then
        return v152;
    end;

    local v153 = {};

    for _, v in u107 do
        local Instance_new_ret = Instance.new(v.ClassName or "Part");
        Instance_new_ret.Anchored = true;
        Instance_new_ret.CanCollide = false;
        Instance_new_ret.CanQuery = false;
        Instance_new_ret.CanTouch = false;
        Instance_new_ret.CastShadow = false;
        Instance_new_ret.Material = Enum.Material.Neon;
        Instance_new_ret.Color = Color3_fromRGB_ret;
        Instance_new_ret.Transparency = 1;
        local v154;

        if u147 and u147.Parent then
            v154 = u147;
        else
            v154 = Instance.new("Folder");
            v154.Name = "TutorialGuide";
            v154.Parent = workspace.CurrentCamera;
            u147 = v154;
            table.clear(u148);
        end;

        Instance_new_ret.Parent = v154;
        Instance_new_ret.Size = v.Size;
        table.insert(v153, Instance_new_ret);
    end;

    local v155 = {
        Trail = nil,
        Along = 0,
        Traveled = 0,
        Stop = 0,
        Active = false,
        Transparency = 1,
        Parts = v153
    };
    u148[p151] = v155;

    return v155;
end;

local function setChevronTransparency(p156: table, p157: number) -- Line: 719
    if p156.Transparency == p157 then
        return;
    end;

    if math.abs(p156.Transparency - p157) < 0.02 and p157 ~= 1 then
        return;
    end;

    p156.Transparency = p157;

    for _, v in p156.Parts do
        v.Transparency = p157;
    end;
end;

local u158 = {};
local u159 = {};

local function placeChevron(p160: table, p161: vector, p162: vector) -- Line: 736
    -- upvalues: u107 (copy), u158 (copy), u159 (copy)
    local v163 = CFrame.lookAt(p161, p161 + p162) * CFrame.new(0, 0.05, 0);

    for i, v in u107 do
        table.insert(u158, p160.Parts[i]);
        table.insert(u159, v163 * v.Offset);
    end;
end;

local function hideParts() -- Line: 744
    -- upvalues: u148 (copy)
    for _, v in u148 do
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

local u164 = 0;

local function buildTrail(p165: table, p166: vector, p167: number) -- Line: 757
    -- upvalues: refreshIgnore (copy), remainingPoints (copy), walkLeg (copy), u164 (ref), RaycastParams_new_ret (copy), RaycastParams_new_ret2 (copy), u9 (ref), CatmullRomPath (copy), roundCorners (copy), simplify (copy), flatDistance (copy)
    refreshIgnore();
    local v168 = p166;
    local v169 = { p166 };

    for _, v in remainingPoints(p165.Points, p166) do
        local v170 = walkLeg(p166, v);
        p166 = v;

        for i = 2, #v170 do
            table.insert(v169, v170[i]);
            local _ = i;
        end;
    end;

    if p167 ~= u164 then
        return nil;
    end;

    for i = 2, #v169 do
        local v171 = v169[i] - v168;
        local Vector3_new_ret = Vector3.new(v171.X, 0, v171.Z);

        if Vector3_new_ret.Magnitude > 0.5 then
            local v172 = -Vector3_new_ret.Unit * 6;
            local v173 = workspace:Raycast(v168, v172, RaycastParams_new_ret);
            local v174 = not v173 and 6 or math.max(v173.Distance - 0.5, 0);

            if v174 > 0.5 then
                table.insert(v169, 1, v168 + v172.Unit * v174);
            end;

            break;
        end;

        local _ = i;
    end;

    for i, v in v169 do
        local v175 = workspace:Raycast(v + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);
        local v176;

        if v175 then
            local v177 = u9;
            local v178;

            if v177 == nil then
                v178 = false;
            else
                v178 = v175.Instance:IsDescendantOf(v177);
            end;

            v176 = v175.Position + Vector3.new(0, v178 and 0.25 or 0, 0);
        else
            v176 = v;
        end;

        v169[i] = v176;
    end;

    local v179 = CatmullRomPath.spline(roundCorners((simplify(v169))), {
        Alpha = 0.5,
        Step = 0.5,
        Distance = flatDistance
    });
    local v180, v181 = CatmullRomPath.resample(v179, 0.5, flatDistance);

    return #v180 >= 2 and {
        Dense = v180,
        Total = v181,
        Floor = {}
    } or nil;
end;

local function floorSample(p182: table, p183: number) -- Line: 808
    -- upvalues: RaycastParams_new_ret2 (copy), u9 (ref)
    local v184 = p182.Floor[p183];

    if v184 then
        return v184;
    end;

    local v185 = p182.Dense[p183];
    local v186 = workspace:Raycast(v185 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);

    if v186 then
        local v187 = u9;
        local v188;

        if v187 == nil then
            v188 = false;
        else
            v188 = v186.Instance:IsDescendantOf(v187);
        end;

        v185 = v186.Position + Vector3.new(0, v188 and 0.25 or 0, 0);
    end;

    p182.Floor[p183] = v185;

    return v185;
end;

local function floorPointAt(p189: table, p190: number) -- Line: 819
    -- upvalues: CatmullRomPath (copy), RaycastParams_new_ret2 (copy), u9 (ref)
    local Dense = p189.Dense;
    local v191, v192, v193 = CatmullRomPath.locate(#Dense, 0.5, p190);
    Dense[v191]:Lerp(Dense[v192], v193);
    local v194 = Dense[math.max(v191 - 1, 1)];
    local v195 = Dense[math.min(v191 + 2, #Dense)] - v194;
    local Vector3_new_ret = Vector3.new(v195.X, 0, v195.Z);
    local v196, v197, v198 = CatmullRomPath.locate(#p189.Dense, 0.5, p190);
    local v199 = p189.Floor[v196];

    if not v199 then
        v199 = p189.Dense[v196];
        local v200 = workspace:Raycast(v199 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);

        if v200 then
            local v201 = u9;
            local v202;

            if v201 == nil then
                v202 = false;
            else
                v202 = v200.Instance:IsDescendantOf(v201);
            end;

            v199 = v200.Position + Vector3.new(0, v202 and 0.25 or 0, 0);
        end;

        p189.Floor[v196] = v199;
    end;

    local v203 = p189.Floor[v197];

    if not v203 then
        v203 = p189.Dense[v197];
        local v204 = workspace:Raycast(v203 + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret2);

        if v204 then
            local v205 = u9;
            local v206;

            if v205 == nil then
                v206 = false;
            else
                v206 = v204.Instance:IsDescendantOf(v205);
            end;

            v203 = v204.Position + Vector3.new(0, v206 and 0.25 or 0, 0);
        end;

        p189.Floor[v197] = v203;
    end;

    return v199:Lerp(v203, v198), Vector3_new_ret;
end;

local function projectOnto(p207: table, u208: vector, p209: number) -- Line: 827
    local Dense = p207.Dense;

    local function search(p210: number, p211: number) -- Line: 829
        -- upvalues: Dense (copy), u208 (copy)
        local v212 = (1 / 0);

        for i = p210, p211 do
            local v213 = Dense[i] - u208;
            local Magnitude = Vector3.new(v213.X, 0, v213.Z).Magnitude;
            local v214;

            if Magnitude < v212 then
                p210 = i;
                v212 = Magnitude;
                v214 = p210;
                local v215 = p210;
                p210 = v214;
                v215 = v214;
            else
                v214 = i;
            end;
        end;

        return p210, v212;
    end;

    local v216, v217 = search(math.max(1, p209 - 80), (math.min(#Dense, p209 + 80)));

    if v217 > 7 then
        v216, v217 = search(1, #Dense);
    end;

    return (v216 - 1) * 0.5, v217, v216;
end;

local u218 = nil;
local u219 = nil;
local u220 = nil;
local u221 = 0;
local u222 = 0;
local u223 = 1;
local u224 = 0;
local u225 = false;
local u226 = true;
local u227 = 0;
local u228 = false;

local function freeChevron() -- Line: 864
    -- upvalues: u148 (copy), getChevron (copy)
    for _, v in u148 do
        if not v.Active then
            return v;
        end;
    end;

    return getChevron(#u148 + 1);
end;

local function spawnGroup(p229: table) -- Line: 874
    -- upvalues: u221 (ref), u148 (copy), getChevron (copy)
    local math_max_ret = math.max(u221 - 6, 0);
    local v230 = p229.Total - 3;

    for i = 1, 3 do
        local v231 = math_max_ret + (3 - i) * 2.6;
        local v232;

        if v230 - v231 >= 2 then
            v232 = i;
            local v233;

            for _, v in u148 do
                if not v.Active then
                    v233 = v;
                    break;
                end;
            end;

            v233 = getChevron(#u148 + 1);
            v233.Active = true;
            v233.Trail = p229;
            v233.Along = v231;
            v233.Traveled = 0;
            v233.Stop = v230;
        else
            v232 = i;
        end;
    end;
end;

local function draw(p234: number) -- Line: 888
    -- upvalues: u224 (ref), u225 (ref), u221 (ref), u222 (ref), u219 (ref), u226 (ref), u148 (copy), u227 (ref), u228 (ref), u158 (copy), u159 (copy), floorPointAt (copy), placeChevron (copy)
    local v235;

    if u225 then
        v235 = p234;
    else
        v235 = -p234;
    end;

    u224 = math.clamp(u224 + v235 * 3, 0, 1);
    u221 = u221 + (u222 - u221) * math.min(1, p234 * 12);

    if u224 <= 0 or not u219 then
        if not u226 then
            u226 = true;

            for _, v in u148 do
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

        u227 = 1;

        return;
    end;

    u226 = false;

    if u225 and not u228 then
        u227 = u227 + p234;

        if u227 >= 1 then
            u228 = true;
        end;
    end;

    table.clear(u158);
    table.clear(u159);

    for _, v in u148 do
        local Trail = v.Trail;

        if v.Active and Trail then
            local v236 = p234 * 15;
            v.Along = v.Along + v236;
            v.Traveled = v.Traveled + v236;
            local v237 = v.Stop - v.Along;

            if v237 <= 0 then
                v.Active = false;

                if v.Transparency ~= 1 then
                    local _ = math.abs(v.Transparency - 1) < 0.02;
                    v.Transparency = 1;

                    for _, v2 in v.Parts do
                        v2.Transparency = 1;
                    end;
                end;
            else
                local v238 = math.clamp(v.Traveled / 2, 0, 1) * math.clamp(v237 / 6, 0, 1) * u224;
                local v239, v240 = floorPointAt(Trail, v.Along);

                if v240.Magnitude > 0.01 then
                    placeChevron(v, v239, v240.Unit);
                end;

                local v241 = math.floor((1 - v238) / 0.02 + 0.5) * 0.02;

                if v.Transparency ~= v241 then
                    if math.abs(v.Transparency - v241) >= 0.02 or v241 == 1 then
                        v.Transparency = v241;

                        for _, v2 in v.Parts do
                            v2.Transparency = v241;
                        end;
                    end;
                end;
            end;
        end;
    end;

    if #u158 > 0 then
        workspace:BulkMoveTo(u158, u159, Enum.BulkMoveMode.FireCFrameChanged);
    end;
end;

local u242 = false;

local function prewarm() -- Line: 943
    -- upvalues: u242 (ref), getChevron (copy)
    if u242 then
        return;
    end;

    u242 = true;

    for i = 1, 24 do
        getChevron(i);
        local v243;

        if i % 4 == 0 then
            task.wait();
            v243 = i;
        else
            v243 = i;
        end;
    end;
end;

local function track(p244: number) -- Line: 956
    -- upvalues: u164 (ref), u218 (ref), CharacterResolver (copy), u225 (ref), TutorialZones (copy), u219 (ref), u228 (ref), projectOnto (copy), u223 (ref), u222 (ref), prewarm (copy), buildTrail (copy), u227 (ref), u221 (ref), spawnGroup (copy)
    local v245 = false;
    local v246 = nil;

    while p244 == u164 do
        local v247 = u218;
        local LocalCharacter = CharacterResolver.getLocalCharacter();
        local v248;

        if LocalCharacter then
            v248 = CharacterResolver.getRootPart(LocalCharacter);
        else
            v248 = LocalCharacter;
        end;

        if v247 and (v248 and CharacterResolver.isAliveCharacter(LocalCharacter)) then
            local Position = v248.Position;
            local v249 = Position - v247.Points[#v247.Points];
            local Magnitude = Vector3.new(v249.X, 0, v249.Z).Magnitude;
            local v250 = TutorialZones.IsInside(Position);

            if v250 then
                v245 = v250;
            elseif Magnitude <= v247.Radius then
                v245 = true;
            elseif v245 then
                v245 = Magnitude <= math.max(v247.Radius * 1.6, 20);
            end;

            if v245 then
                u225 = false;
                u219 = nil;
                task.wait(0.1);
            else
                local v251 = u219;
                local v252 = v251 == nil and true or u228;

                if v251 then
                    local v253, v254, v255 = projectOnto(v251, Position, u223);
                    u222 = v253;
                    u223 = v255;

                    if v254 > 7 then
                        v246 = v246 or os.clock();
                        v252 = os.clock() - v246 >= 0.75;
                    else
                        v246 = nil;
                    end;
                end;

                if v252 then
                    v246 = nil;
                    prewarm();

                    if p244 ~= u164 then
                        return;
                    end;

                    local v256 = buildTrail(v247, Position, p244);

                    if p244 ~= u164 then
                        return;
                    end;

                    u219 = v256;
                    u228 = false;
                    u227 = 0;
                    u223 = 1;
                    u221 = 0;
                    u222 = 0;

                    if v256 then
                        local Position2 = v248.Position;
                        local Dense = v256.Dense;

                        local function v263(p257: number, p258: number) -- Line: 829
                            -- upvalues: Dense (copy), Position2 (copy)
                            local v259 = (1 / 0);

                            for i = p257, p258 do
                                local v260 = Dense[i] - Position2;
                                local Magnitude2 = Vector3.new(v260.X, 0, v260.Z).Magnitude;
                                local v261;

                                if Magnitude2 < v259 then
                                    p257 = i;
                                    v259 = Magnitude2;
                                    v261 = p257;
                                    local v262 = p257;
                                    p257 = v261;
                                    v262 = v261;
                                else
                                    v261 = i;
                                end;
                            end;

                            return p257, v259;
                        end;

                        local v264, v265 = v263(1, (math.min(#Dense, 81)));

                        if v265 > 7 then
                            v264, v265 = v263(1, #Dense);
                        end;

                        local v266 = (v264 - 1) * 0.5;
                        u223 = v264;
                        u221 = v266;
                        u222 = v266;
                        spawnGroup(v256);
                    end;
                end;

                u225 = u219 ~= nil;
                task.wait(0.1);
            end;
        else
            u225 = false;
            task.wait(0.1);
        end;
    end;
end;

local function sync() -- Line: 1024
    -- upvalues: IsTutorialMode (copy), decodeRoute (copy), u218 (ref), u164 (ref), u219 (ref), u225 (ref), u224 (ref), u226 (ref), u148 (copy), u220 (ref), RunServiceController (copy), draw (copy), track (copy)
    local v267;

    if IsTutorialMode() then
        v267 = decodeRoute();
    else
        v267 = nil;
    end;

    if v267 and (u218 and v267.Key == u218.Key) then
        return;
    end;

    u164 = u164 + 1;
    u218 = v267;
    u219 = nil;

    if not v267 then
        u225 = false;

        return;
    end;

    u224 = 0;
    u226 = true;

    for _, v in u148 do
        v.Active = false;

        if v.Transparency ~= 1 then
            local _ = math.abs(v.Transparency - 1) < 0.02;
            v.Transparency = 1;

            for _, v2 in v.Parts do
                v2.Transparency = 1;
            end;
        end;
    end;

    if not u220 then
        u220 = RunServiceController.BindToHeartbeat("TutorialGuide.Draw", draw);
    end;

    task.spawn(track, u164);
end;

function v1.Start() -- Line: 1046
    -- upvalues: LocalPlayer (copy), sync (copy)
    LocalPlayer:GetAttributeChangedSignal("TutorialGuide"):Connect(sync);
    sync();
end;

return v1;