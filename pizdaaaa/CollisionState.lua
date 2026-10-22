-- ReplicatedStorage.Shared.CollisionModule.CollisionState
-- Script path: ReplicatedStorage.Shared.CollisionModule.CollisionState
-- Decompile time: 5.94 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    SkinThickness = 0.05,
    SkinThicknessVector = Vector3.new(0.05, 0.05, 0.05),
    DefaultCollisionBox = Vector3.new(0, 0, 0),
    CrouchCollisionBox = Vector3.new(0, 0, 0),
    HalfDefaultCollisionBox = Vector3.new(0, 0, 0),
    HalfCrouchCollisionBox = Vector3.new(0, 0, 0),
    MAX_LEAF_SIZE = 4,
    Generation = 0,
    HullRecordCount = 0,
    HullInstance = {},
    HullClimbable = {},
    StandMin = {},
    StandMax = {},
    StandNormals = {},
    StandEdsStart = {},
    StandHullCount = {},
    CrouchMin = {},
    CrouchMax = {},
    CrouchNormals = {},
    CrouchEdsStart = {},
    CrouchHullCount = {},
    TreeMin = {},
    TreeMax = {},
    GlobalEdsCap = 8192,
    GlobalEds = buffer.create(32768),
    GETail = 0,
    NodeMin = {},
    NodeMax = {},
    NodeLeft = {},
    NodeRight = {},
    NodeRecordStart = {},
    NodeRecordCount = {},
    NodeCount = 0,
    LeafRecords = {},
    LeafRecordTail = 0,
    BVHRoot = 0,
    StandLadders = {},
    CrouchLadders = {},
    LadderAmount = 0,
    CurrentBuffer = nil,
    CollisionProccesing = false,
    ClipsFolder = nil
};

function u1.Reset() -- Line: 67
    -- upvalues: u1 (copy)
    local v2 = u1;

    if v2.ClipsFolder then
        v2.ClipsFolder:Destroy();
        v2.ClipsFolder = nil;
    end;

    v2.CurrentBuffer = nil;
    v2.CollisionProccesing = false;
    v2.HullRecordCount = 0;
    v2.LadderAmount = 0;
    v2.GETail = 0;
    v2.NodeCount = 0;
    v2.LeafRecordTail = 0;
    v2.BVHRoot = 0;
    table.clear(v2.HullInstance);
    table.clear(v2.HullClimbable);
    table.clear(v2.StandMin);
    table.clear(v2.StandMax);
    table.clear(v2.StandNormals);
    table.clear(v2.StandEdsStart);
    table.clear(v2.StandHullCount);
    table.clear(v2.CrouchMin);
    table.clear(v2.CrouchMax);
    table.clear(v2.CrouchNormals);
    table.clear(v2.CrouchEdsStart);
    table.clear(v2.CrouchHullCount);
    table.clear(v2.TreeMin);
    table.clear(v2.TreeMax);
    table.clear(v2.NodeMin);
    table.clear(v2.NodeMax);
    table.clear(v2.NodeLeft);
    table.clear(v2.NodeRight);
    table.clear(v2.NodeRecordStart);
    table.clear(v2.NodeRecordCount);
    table.clear(v2.LeafRecords);
    table.clear(v2.StandLadders);
    table.clear(v2.CrouchLadders);
end;

return u1;