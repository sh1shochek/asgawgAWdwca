-- ReplicatedStorage.MovementV2.Collision.Schema
-- Script path: ReplicatedStorage.MovementV2.Collision.Schema
-- Decompile time: 0.39 ms

local Enums = require(script.Parent.Parent.Enums)
local u6 = {
    ManifestVersion = 1,
    CanonicalGeometryVersion = "MV2G1",
    WalkmeshHeader = "MLWALK1",
    MaxSourceCount = 65535,
    MaxDestructibleCount = 65535,
    MaxEpoch = 65535,
    MaxWalkmeshVertices = 1000000,
    MaxWalkmeshTriangles = 2000000,
}
u6.SourceKind = table.freeze({
    Walkmesh = Enums.SupportKind.Walkmesh,
    Barrier = Enums.SupportKind.Barrier,
    Destructible = Enums.SupportKind.Destructible,
})
u6.SourceKindName = table.freeze({
    [u6.SourceKind.Walkmesh] = "Walkmesh",
    [u6.SourceKind.Barrier] = "Barrier",
    [u6.SourceKind.Destructible] = "Destructible",
})
u6.Tags = table.freeze({
    Destructible = "MovementV2Destructible",
    Walkmesh = "CustomWalkMesh",
    UnsupportedFloorGrid = "CustomFloorGrid",
    LadderMetadata = "Ladder",
})
u6.Attributes = table.freeze({
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
    ManifestDestructibleCount = "MovementV2CollisionDestructibleCount",
})
u6.BarriersNameLower = "barriers"
u6.ReplicaContainerName = "MovementV2CollisionCatalogs"

function u6.GetSourceKindName(a1) -- Line: 65 -- upvalues: u6 (val) -- types: a1: number
    return u6.SourceKindName[a1]
end

return table.freeze(u6)