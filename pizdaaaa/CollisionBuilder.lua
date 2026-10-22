-- ReplicatedStorage.Shared.CollisionModule.CollisionBuilder
-- Script path: ReplicatedStorage.Shared.CollisionModule.CollisionBuilder
-- Decompile time: 15.12 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = game:GetService("RunService"):IsClient();
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = {};

local function KeyLess(p15: number, p16: number) -- Line: 35
    -- upvalues: u14 (copy)
    local v17 = u14[p15];
    local v18 = u14[p16];
    local v19;

    if v17 < v18 then
        v19 = true;
    elseif v17 == v18 then
        v19 = p15 < p16;
    else
        v19 = false;
    end;

    return v19;
end;

local function Round3(p20: buffer, p21: number, p22: number, p23: number) -- Line: 40
    buffer.writef32(p20, 0, p21);
    buffer.writef32(p20, 4, p22);
    buffer.writef32(p20, 8, p23);
    local buffer_readf32_ret = buffer.readf32(p20, 0);
    local buffer_readf32_ret2 = buffer.readf32(p20, 4);
    local buffer_readf32_ret3 = buffer.readf32(p20, 8);

    return vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
end;

local function EnsureEdsCapacity(p24: number) -- Line: 47
    -- upvalues: u3 (ref)
    local GlobalEdsCap = u3.GlobalEdsCap;

    if p24 <= GlobalEdsCap then
        return;
    end;

    repeat
        GlobalEdsCap = GlobalEdsCap * 2;
    until p24 <= GlobalEdsCap;

    local buffer_create_ret = buffer.create(GlobalEdsCap * 4);
    buffer.copy(buffer_create_ret, 0, u3.GlobalEds, 0, u3.GETail * 4);
    u3.GlobalEds = buffer_create_ret;
    u3.GlobalEdsCap = GlobalEdsCap;
end;

local function ProcessCollisionOnInstance(p25: userdata, p26, p27: vector?) -- Line: 57
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), EnsureEdsCapacity (copy)
    local v28 = p25.Name == "Ladder";

    if v28 then
        local v29 = u3;
        v29.LadderAmount = v29.LadderAmount + 1;
    end;

    local v30 = p26 or p25.CFrame;
    local v31, v32, v33, v34, v35, v36 = u4.FindAABB(v30, p27 or p25.Size);
    local vector_create_ret = vector.create(v31, v32, v33);
    local vector_create_ret2 = vector.create(v34, v35, v36);
    local DefaultCollisionBox = u3.DefaultCollisionBox;
    local CrouchCollisionBox = u3.CrouchCollisionBox;
    local PlanesForInstance, v37, v38 = u5:GetPlanesForInstance(p25, DefaultCollisionBox, v30, nil);
    local v39 = v38 or 0;
    local GETail = u3.GETail;
    EnsureEdsCapacity(GETail + v39);
    local GlobalEds = u3.GlobalEds;

    for i = 1, v39 do
        buffer.writef32(GlobalEds, (GETail + i - 1) * 4, v37[i]);
        local _ = i;
    end;

    local v40 = u3;
    v40.GETail = v40.GETail + v39;
    local v41, v42, v43;

    if v39 > 0 and (DefaultCollisionBox.X == CrouchCollisionBox.X and DefaultCollisionBox.Z == CrouchCollisionBox.Z) then
        local v44 = (DefaultCollisionBox.Y - CrouchCollisionBox.Y) * 0.5;
        v41 = u3.GETail;
        EnsureEdsCapacity(v41 + v39);
        local GlobalEds2 = u3.GlobalEds;
        v42 = PlanesForInstance;

        for i = 1, v39 do
            local v45 = v37[i] - math.abs(PlanesForInstance[i].Y) * v44;
            buffer.writef32(GlobalEds2, (v41 + i - 1) * 4, v45);
            local _ = i;
        end;

        local v46 = u3;
        v46.GETail = v46.GETail + v39;
        v43 = v39;
    else
        local v47, v48;
        v42, v47, v48 = u5:GetPlanesForInstance(p25, CrouchCollisionBox, v30, nil);
        v43 = v48 or 0;
        v41 = u3.GETail;
        EnsureEdsCapacity(v41 + v43);
        local GlobalEds2 = u3.GlobalEds;

        for i = 1, v43 do
            buffer.writef32(GlobalEds2, (v41 + i - 1) * 4, v47[i]);
            local _ = i;
        end;

        local v49 = u3;
        v49.GETail = v49.GETail + v43;
    end;

    local v50 = u3;
    v50.HullRecordCount = v50.HullRecordCount + 1;
    local HullRecordCount = u3.HullRecordCount;
    u3.HullInstance[HullRecordCount] = p25;
    u3.HullClimbable[HullRecordCount] = v28 or nil;
    local HalfDefaultCollisionBox = u3.HalfDefaultCollisionBox;
    local HalfCrouchCollisionBox = u3.HalfCrouchCollisionBox;
    local v51 = vector_create_ret - HalfDefaultCollisionBox;
    local v52 = vector_create_ret2 + HalfDefaultCollisionBox;
    local v53 = vector_create_ret - HalfCrouchCollisionBox;
    local v54 = vector_create_ret2 + HalfCrouchCollisionBox;
    u3.StandNormals[HullRecordCount] = PlanesForInstance;
    u3.StandEdsStart[HullRecordCount] = GETail;
    u3.StandHullCount[HullRecordCount] = v39;
    u3.StandMin[HullRecordCount] = v51;
    u3.StandMax[HullRecordCount] = v52;
    u3.CrouchNormals[HullRecordCount] = v42;
    u3.CrouchEdsStart[HullRecordCount] = v41;
    u3.CrouchHullCount[HullRecordCount] = v43;
    u3.CrouchMin[HullRecordCount] = v53;
    u3.CrouchMax[HullRecordCount] = v54;
    u3.TreeMin[HullRecordCount] = vector.min(v51, v53);
    u3.TreeMax[HullRecordCount] = vector.max(v52, v54);

    if v28 then
        local v55 = #u3.StandLadders + 1;
        u3.StandLadders[v55] = HullRecordCount;
        u3.CrouchLadders[v55] = HullRecordCount;
    end;
end;

local function TakePooled(p56: any, p57: any, p58: number, p59: number) -- Line: 147
    local v60 = p56[p58];

    if not v60 then
        v60 = table.create(p59);
        p56[p58] = v60;
        p57[p58] = 0;
    end;

    for i = p59 + 1, p57[p58] do
        v60[i] = nil;
        local _ = i;
    end;

    p57[p58] = p59;

    return v60;
end;

local u61 = nil;
local u62 = nil;

local function SortCenters(p63: any, p64: number, p65: number) -- Line: 161
    -- upvalues: u61 (ref), u62 (ref), u14 (copy), KeyLess (copy)
    for i = 1, p64 do
        local v66 = p63[i];
        local v67 = u61[v66];
        local v68 = u62[v66];
        local v69;

        if p65 == 1 then
            v69 = v67.X + v68.X;
        elseif p65 == 2 then
            v69 = v67.Y + v68.Y;
        else
            v69 = v67.Z + v68.Z;
        end;

        u14[v66] = v69;
        local _ = i;
    end;

    table.sort(p63, KeyLess);
end;

local function BuildNode(p70: any, p71: number, p72: number) -- Line: 172
    -- upvalues: u61 (ref), u62 (ref), u3 (ref), u4 (ref), u9 (copy), SortCenters (copy), u10 (copy), u12 (copy), u11 (copy), u13 (copy), BuildNode (copy)
    if p71 == 0 then
        return 0;
    end;

    local v73 = Vector3.new(inf, inf, inf);
    local v74 = Vector3.new(-inf, -inf, -inf);

    for i = 1, p71 do
        local v75 = p70[i];
        v73 = vector.min(v73, u61[v75]);
        v74 = vector.max(v74, u62[v75]);
        local _ = i;
    end;

    local v76 = 0;
    local v77 = 0;

    if u3.MAX_LEAF_SIZE < p71 and p72 <= 20 then
        local v78 = u4.HalfArea(v73, v74);
        local v79 = v78 * p71;
        local v80 = u9;

        for i = 1, 3 do
            SortCenters(p70, p71, i);
            local v81 = i;
            local v82 = Vector3.new(inf, inf, inf);
            local v83 = Vector3.new(-inf, -inf, -inf);

            for i2 = p71, 2, -1 do
                v82 = vector.min(v82, u61[p70[i2]]);
                v83 = vector.max(v83, u62[p70[i2]]);
                v80[i2] = u4.HalfArea(v82, v83);
                local _ = i2;
            end;

            local v84 = Vector3.new(inf, inf, inf);
            local v85 = Vector3.new(-inf, -inf, -inf);

            for i2 = 1, p71 - 1 do
                v84 = vector.min(v84, u61[p70[i2]]);
                v85 = vector.max(v85, u62[p70[i2]]);
                local v86 = v78 + u4.HalfArea(v84, v85) * i2 + v80[i2 + 1] * (p71 - i2);
                local v87;

                if v86 < v79 then
                    v76 = i2;
                    v77 = v81;
                    v87 = v76;
                    v79 = v86;
                    local v88 = v76;
                    v76 = v87;
                    v88 = v87;
                    v87 = v76;
                else
                    v87 = i2;
                end;
            end;
        end;

        if v77 ~= 0 and v77 ~= 3 then
            SortCenters(p70, p71, v77);
        end;
    end;

    if v76 == 0 then
        local v89 = u3;
        v89.NodeCount = v89.NodeCount + 1;
        local NodeCount = u3.NodeCount;
        u3.NodeMin[NodeCount] = v73;
        u3.NodeMax[NodeCount] = v74;
        u3.NodeLeft[NodeCount] = 0;
        u3.NodeRight[NodeCount] = 0;
        local LeafRecordTail = u3.LeafRecordTail;

        for i = 1, p71 do
            u3.LeafRecords[LeafRecordTail + i] = p70[i];
            local _ = i;
        end;

        local v90 = u3;
        v90.LeafRecordTail = v90.LeafRecordTail + p71;
        u3.NodeRecordStart[NodeCount] = LeafRecordTail;
        u3.NodeRecordCount[NodeCount] = p71;

        return NodeCount;
    end;

    local v91 = p71 - v76;
    local v92 = u10;
    local v93 = u12;
    local v94 = p72 + 1;
    local v95 = v92[v94];

    if not v95 then
        v95 = table.create(v76);
        v92[v94] = v95;
        v93[v94] = 0;
    end;

    local v96 = v76;

    for i = v76 + 1, v93[v94] do
        v95[i] = nil;
        local _ = i;
    end;

    v93[v94] = v76;
    local v97 = u11;
    local v98 = u13;
    local v99 = p72 + 1;
    local v100 = v97[v99];

    if not v100 then
        v100 = table.create(v91);
        v97[v99] = v100;
        v98[v99] = 0;
    end;

    for i = v91 + 1, v98[v99] do
        v100[i] = nil;
        local _ = i;
    end;

    v98[v99] = v91;

    for i = 1, v96 do
        v95[i] = p70[i];
        local _ = i;
    end;

    for i = v96 + 1, p71 do
        v100[i - v96] = p70[i];
        local _ = i;
    end;

    local v101 = BuildNode(v95, v76, p72 + 1);
    local v102 = BuildNode(v100, v91, p72 + 1);
    local v103 = u3;
    v103.NodeCount = v103.NodeCount + 1;
    local NodeCount = u3.NodeCount;
    u3.NodeMin[NodeCount] = v73;
    u3.NodeMax[NodeCount] = v74;
    u3.NodeLeft[NodeCount] = v101;
    u3.NodeRight[NodeCount] = v102;
    u3.NodeRecordStart[NodeCount] = 0;
    u3.NodeRecordCount[NodeCount] = 0;

    return NodeCount;
end;

local function RebuildBVH() -- Line: 258
    -- upvalues: u3 (ref), u61 (ref), u62 (ref), BuildNode (copy)
    u3.NodeCount = 0;
    u3.LeafRecordTail = 0;
    table.clear(u3.NodeMin);
    table.clear(u3.NodeMax);
    table.clear(u3.NodeLeft);
    table.clear(u3.NodeRight);
    table.clear(u3.NodeRecordStart);
    table.clear(u3.NodeRecordCount);
    table.clear(u3.LeafRecords);
    local HullRecordCount = u3.HullRecordCount;
    local table_create_ret = table.create(HullRecordCount);

    for i = 1, HullRecordCount do
        table_create_ret[i] = i;
        local _ = i;
    end;

    u61 = u3.TreeMin;
    u62 = u3.TreeMax;
    u3.BVHRoot = BuildNode(table_create_ret, HullRecordCount, 0);
end;

local function FakeIsA(p104: any, p105: string) -- Line: 282
    return p105 == "Part" and true or p105 == "BasePart";
end;

local function GenerateCollisionBuffer(p106) -- Line: 288
    -- upvalues: u6 (ref), ProcessCollisionOnInstance (copy)
    local buffer_create_ret = buffer.create(12);
    local PartShapeNum = u6.PartShapeNum;
    local v107 = {};

    for i, v in p106 do
        local v108;

        if v.Name == "Ladder" then
            v108 = PartShapeNum.Ladder;
        elseif v:IsA("WedgePart") then
            v108 = PartShapeNum[Enum.PartType.Wedge];
        elseif v:IsA("CornerWedgePart") then
            v108 = PartShapeNum[Enum.PartType.CornerWedge];
        else
            v108 = PartShapeNum[v.Shape];
        end;

        local Position = v.Position;
        local Y = Position.Y;
        local Z = Position.Z;
        buffer.writef32(buffer_create_ret, 0, Position.X);
        buffer.writef32(buffer_create_ret, 4, Y);
        buffer.writef32(buffer_create_ret, 8, Z);
        local buffer_readf32_ret = buffer.readf32(buffer_create_ret, 0);
        local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret, 4);
        local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret, 8);
        local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
        local Size = v.Size;
        local Y2 = Size.Y;
        local Z2 = Size.Z;
        buffer.writef32(buffer_create_ret, 0, Size.X);
        buffer.writef32(buffer_create_ret, 4, Y2);
        buffer.writef32(buffer_create_ret, 8, Z2);
        local buffer_readf32_ret4 = buffer.readf32(buffer_create_ret, 0);
        local buffer_readf32_ret5 = buffer.readf32(buffer_create_ret, 4);
        local buffer_readf32_ret6 = buffer.readf32(buffer_create_ret, 8);
        local vector_create_ret2 = vector.create(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
        v107[i] = {
            Position = vector_create_ret,
            Size = vector_create_ret2,
            Shape = v108
        };
        local v109, v110, v111 = v.CFrame.Rotation:ToEulerAnglesXYZ();
        buffer.writef32(buffer_create_ret, 0, v109);
        buffer.writef32(buffer_create_ret, 4, v110);
        buffer.writef32(buffer_create_ret, 8, v111);
        local buffer_readf32_ret7 = buffer.readf32(buffer_create_ret, 0);
        local buffer_readf32_ret8 = buffer.readf32(buffer_create_ret, 4);
        local buffer_readf32_ret9 = buffer.readf32(buffer_create_ret, 8);
        local vector_create_ret3 = vector.create(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);

        if v109 ~= 0 or (v110 ~= 0 or v111 ~= 0) then
            v107[i].Orientation = vector_create_ret3;
        end;

        local v112 = CFrame.new(vector_create_ret) * CFrame.Angles(vector_create_ret3.X, vector_create_ret3.Y, vector_create_ret3.Z);
        v.CFrame = v112;
        v.Size = vector_create_ret2;
        ProcessCollisionOnInstance(v, v112, vector_create_ret2);
    end;

    return v107;
end;

local function Brief(p113) -- Line: 343
    local Position = p113.CFrame.Position;
    local Size = p113.Size;

    return ("%s [%.1f %.1f %.1f] size %.2f x %.2f x %.2f"):format(p113.ClassName or "buffer", Position.X, Position.Y, Position.Z, Size.X, Size.Y, Size.Z);
end;

local function ReportSkipped(p114: string, p115: any, p116: any) -- Line: 349
    local v117 = {};

    for _, v in p115 do
        v117[v] = true;
    end;

    for _, v in p116 do
        v117[v] = nil;
    end;

    local v118 = 0;
    local v119 = {};

    for i in v117 do
        v118 = v118 + 1;

        if v118 <= 20 then
            v119[v118] = ("%s (%s)"):format(i:GetFullName(), i.ClassName);
        end;
    end;

    if v118 > 0 then
        warn(("[Collision] %s dropped %d brush(es): %s%s"):format(p114, v118, table.concat(v119, ", "), v118 > 20 and ", ..." or ""));
    end;
end;

local function VerifyHulls() -- Line: 388
    -- upvalues: u3 (ref)
    local v120 = 0;
    local v121 = {};

    for i = 1, u3.HullRecordCount do
        local v122 = u3.HullInstance[i];
        local Position = v122.CFrame.Position;
        local v123 = u3.StandNormals[i];
        local v124 = u3.StandHullCount[i];
        local v125 = u3.StandEdsStart[i];
        local GlobalEds = u3.GlobalEds;
        local _ = i;
        local v126 = (-1 / 0);

        for i2 = 1, v124 do
            local v127 = vector.dot(v123[i2], Position) - buffer.readf32(GlobalEds, (v125 + i2 - 1) * 4);
            local v128;

            if v126 < v127 then
                v126 = v127;
                v128 = i2;
            else
                v128 = i2;
            end;
        end;

        if v124 == 0 or v126 > 0 then
            v120 = v120 + 1;

            if v120 <= 10 then
                local Position2 = v122.CFrame.Position;
                local Size = v122.Size;
                v121[v120] = ("\n    %s: %d plane(s), centre %.3f outside"):format(("%s [%.1f %.1f %.1f] size %.2f x %.2f x %.2f"):format(v122.ClassName or "buffer", Position2.X, Position2.Y, Position2.Z, Size.X, Size.Y, Size.Z), v124, v126);
            end;
        end;
    end;

    if v120 > 0 then
        warn(("[Collision] %d brush(es) built a hull that does not contain them:%s%s"):format(v120, table.concat(v121), v120 > 10 and "\n    ..." or ""));
    end;
end;

local function ProcessCollisionBuffer(p129) -- Line: 422
    -- upvalues: u6 (ref), FakeIsA (copy)
    if p129 then
        local table_create_ret = table.create(#p129);
        local PartShapeNum = u6.PartShapeNum;
        local PartShape = u6.PartShape;

        for i, v in p129 do
            local v130 = v.Shape == PartShapeNum.Ladder;
            local CFrame_new_ret = CFrame.new(v.Position);

            if v.Orientation then
                CFrame_new_ret = CFrame_new_ret * CFrame.Angles(v.Orientation.X, v.Orientation.Y, v.Orientation.Z);
            end;

            table_create_ret[i] = {
                Name = v130 and "Ladder" or "Part",
                Size = v.Size,
                CFrame = CFrame_new_ret,
                Shape = v130 and Enum.PartType.Block or PartShape[v.Shape],
                IsA = FakeIsA
            };
        end;

        return table_create_ret;
    end;
end;

function v1.Build(p131, p132, p133) -- Line: 444
    -- upvalues: u3 (ref), GenerateCollisionBuffer (copy), ProcessCollisionBuffer (copy), ProcessCollisionOnInstance (copy), VerifyHulls (copy), RebuildBVH (copy), u5 (ref), u2 (copy)
    if u3.CollisionProccesing then
        return;
    end;

    u3.CollisionProccesing = true;
    local v134 = tick();
    u3.GETail = 0;
    u3.HullRecordCount = 0;
    u3.LadderAmount = 0;
    u3.CurrentBuffer = nil;
    table.clear(u3.HullInstance);
    table.clear(u3.HullClimbable);
    table.clear(u3.StandMin);
    table.clear(u3.StandMax);
    table.clear(u3.StandNormals);
    table.clear(u3.StandEdsStart);
    table.clear(u3.StandHullCount);
    table.clear(u3.CrouchMin);
    table.clear(u3.CrouchMax);
    table.clear(u3.CrouchNormals);
    table.clear(u3.CrouchEdsStart);
    table.clear(u3.CrouchHullCount);
    table.clear(u3.TreeMin);
    table.clear(u3.TreeMax);
    table.clear(u3.StandLadders);
    table.clear(u3.CrouchLadders);

    if p133 then
        local v135 = p131:QueryDescendants("BasePart");
        local v136 = p131:QueryDescendants("BasePart:not(MeshPart, UnionOperation, NegateOperation):not([CanCollide = false])");
        print(("[Collision] %s: %d of %d BasePart(s) baked"):format(p131:GetFullName(), #v136, #v135));
        u3.CurrentBuffer = GenerateCollisionBuffer(v136);
    else
        u3.CurrentBuffer = p131;

        for _, v in ProcessCollisionBuffer(p131) do
            ProcessCollisionOnInstance(v);
        end;
    end;

    if p133 then
        VerifyHulls();
    end;

    RebuildBVH();
    u5:ClearCache();
    u3.CollisionProccesing = false;

    if u2 then
        print(("Collision Time: %.0f ms, %d brush(es)"):format((tick() - v134) * 1000, u3.HullRecordCount));
    end;
end;

function v1.AddStaticParts(p137: table) -- Line: 534
    -- upvalues: u3 (ref), ProcessCollisionOnInstance (copy), RebuildBVH (copy), u5 (ref)
    if u3.CollisionProccesing then
        return;
    end;

    u3.CollisionProccesing = true;

    for _, v in ipairs(p137) do
        ProcessCollisionOnInstance(v);
    end;

    RebuildBVH();
    u5:ClearCache();
    u3.CollisionProccesing = false;
end;

function v1.Init(p138, p139, p140) -- Line: 551
    -- upvalues: u6 (ref), u5 (ref), u7 (ref), u8 (ref), u3 (ref), u4 (ref)
    u6 = p138:GetModule("Enums");
    u5 = require(script.MinkowskiSumInstance);
    u7 = require(script.CoincidentFloors);

    u8 = function(p141) -- Line: 556
        -- upvalues: u5 (ref)
        return u5:GetShapeDef(p141);
    end;

    local CollisionState = require(script.Parent.CollisionState);
    local Module = p138:GetModule("CollisionMath");
    u3 = CollisionState;
    u4 = Module;
end;

function v1.Start2(p142) -- Line: 563
end;

return v1;