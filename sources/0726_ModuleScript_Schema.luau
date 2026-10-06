-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Parent.Enums);
local u1 = {
    ManifestVersion = 1,
    CanonicalGeometryVersion = "MV2G1",
    WalkmeshHeader = "MLWALK1",
    MaxSourceCount = 65535,
    MaxDestructibleCount = 65535,
    MaxEpoch = 65535,
    MaxWalkmeshVertices = 1000000,
    MaxWalkmeshTriangles = 2000000,
    SourceKind = table.freeze({
        Walkmesh = Enums.SupportKind.Walkmesh,
        Barrier = Enums.SupportKind.Barrier,
        Destructible = Enums.SupportKind.Destructible
    })
};
u1.SourceKindName = table.freeze({
    [u1.SourceKind.Walkmesh] = "Walkmesh",
    [u1.SourceKind.Barrier] = "Barrier",
    [u1.SourceKind.Destructible] = "Destructible"
});
u1.Tags = table.freeze({
    Destructible = "MovementV2Destructible",
    Walkmesh = "CustomWalkMesh",
    UnsupportedFloorGrid = "CustomFloorGrid",
    LadderMetadata = "Ladder"
});
u1.Attributes = table.freeze({
    SourceId = "MovementV2SourceId",
    SourceKind = "MovementV2SourceKind",
    DestructibleIndex = "MovementV2DestructibleIndex",
    DestructibleProxy = "MovementV2DestructibleProxy",
    CanonicalGeometry = "MovementV2CanonicalGeometry",
    WalkmeshData = "WalkMeshData",
    Ignore = "IgnoreMovementCollision",
    Climbable = "Climbable",
    PreciseCylinder = "PreciseMovementCylinder",
    ConvexGroup = "MovementConvexGroup",
    DisableSeamMerge = "DisableMovementSeamMerge",
    ManifestVersion = "MovementV2CollisionManifestVersion",
    ManifestEpoch = "MovementV2CollisionEpoch",
    ManifestFingerprint = "MovementV2CollisionFingerprint",
    ManifestSourceCount = "MovementV2CollisionSourceCount",
    ManifestDestructibleCount = "MovementV2CollisionDestructibleCount"
});
u1.BarriersNameLower = "barriers";
u1.ReplicaContainerName = "MovementV2CollisionCatalogs";

function u1.GetSourceKindName(p2: number) -- Line: 65
    -- upvalues: u1 (copy)
    return u1.SourceKindName[p2];
end;

return table.freeze(u1);