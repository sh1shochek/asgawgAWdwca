-- ReplicatedStorage.GameClient.Entities
-- Script path: ReplicatedStorage.GameClient.Entities
-- Decompile time: 23.76 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local Players = game:GetService("Players");
local SnapshotInterp = require(ReplicatedStorage.Shared.Utility.SnapshotInterp);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = {};
local u12 = {};
local u13 = { "Character", "DroppedWeapon", "Bomb" };
local u14 = {};
local u15 = nil;
local u16 = {};
local u17 = {};
local u18 = {};
local u19 = {};
local u20 = { "Reloading", "Firing", "Ammo", "ReserveAmmo", "Mode", "ZoomLevel", "Variant" };
local u21 = {};
local u22 = {};
local u23 = 0;
local u24 = 0;
local u25 = 0;
local u26 = 0;
local u27 = 0;
local u28 = 0;
local u29 = 0;
local u30 = 0;
local u31 = 0;
local u32 = 0;
local u33 = 0;
local u34 = 0;
local u35 = nil;
local u36 = 0;
local u37 = 0;
local u38 = 0;
local u39 = 0;
local u40 = 0;
local table_create_ret = table.create(128, -1);

local function ShotPlayhead(p41: number, p42: number, p43: number) -- Line: 102
    return math.min(p41, p42 + p43 * 7);
end;

local u44 = {};
local u45 = nil;
local u46 = nil;

local function ShouldAckSnapshot(p47: number, p48: number, p49: number, p50: number) -- Line: 115
    -- upvalues: u44 (copy)
    return p48 == 0 and true or p47 - p49 >= p50 * u44.SnapshotAckEvery;
end;

local function RefreshConfig() -- Line: 120
    -- upvalues: u44 (copy), u7 (ref), u46 (ref), u39 (ref), u36 (ref), u35 (ref)
    local TickRate = u44.TickRate;

    for i, v in u7.GetEntityTiming(u46) do
        u44[i] = v;
    end;

    u39 = u44.MaxRenderBuffer;
    u36 = math.min(u36, u39);

    if TickRate ~= u44.TickRate then
        u35 = nil;
        u36 = 0;
    end;
end;

local u51 = nil;
local u52 = nil;

local function Stamp(p53: number, p54: number) -- Line: 150
    -- upvalues: u44 (copy), u35 (ref), u52 (ref), u51 (ref)
    local v55 = p53 / u44.TickRate;
    local v56 = p54 - v55;

    if u35 then
        if math.abs(v56 - u35) > u44.ClockResyncThreshold then
            u52 = u52 or p54;

            if p54 - u52 >= 0.5 then
                u35 = v56;
                u52 = nil;
            end;
        else
            u52 = nil;
        end;
    else
        u35 = v56;
        u52 = nil;
    end;

    local v57 = u44.ClockDriftStep * math.clamp((u51 and (p54 - u51 or 0) or 0) * u44.TickRate, 0, 4);
    u35 = u35 + math.clamp(v56 - u35, -v57, v57);
    u51 = p54;

    return u35 + v55;
end;

local function ReportEntityError(p58: any, p59: string, p60: string) -- Line: 189
    p58.InterpolationFailed = true;
    warn((`[Entities] {p59} {p58.Identifier} removed from interpolation: {p60}`));
end;

local function FindBracket(p61: any, p62: number) -- Line: 212
    for i = p61.Count - 1, 1, -1 do
        local v63 = p61:Get(i);

        if v63 and v63.DisplayTick <= p62 then
            return v63, p61:Get(i + 1);
        end;

        local _ = i;
    end;

    return nil, nil;
end;

local function Teleported(p64, p65) -- Line: 242
    return p64.NoInterpParity ~= p65.NoInterpParity;
end;

local function CanExtrapolate(p66: number, p67: number?, p68: number) -- Line: 257
    -- upvalues: u44 (copy)
    local v69 = p68 - p66;

    if u44.SnapshotTimeout <= v69 then
        return false;
    end;

    if p67 == nil or p66 - p67 <= u44.SnapshotInterval * u44.IdleSnapshotIntervals then
        return u44.MaxExtrapolation - v69 > 0;
    end;

    return false;
end;

local function PoseNewest(p70: any, p71: string, p72: any, p73: number) -- Line: 276
    -- upvalues: u44 (copy)
    local success, result = pcall(p70.Interpolate, p70, p72.Snapshot, p72.Snapshot, 1, u44.SnapshotInterval, p73);

    if not success then
        p70.InterpolationFailed = true;
        warn((`[Entities] {p71} {p70.Identifier} removed from interpolation: {result}`));
    end;
end;

local function SetFogCulled(p74: any, p75: boolean, p76: boolean) -- Line: 304
    p74.FogCulled = p75;

    if not p76 and p74.ApplyCull then
        p74:ApplyCull();
    end;
end;

local function StepEntity(p77: any, p78: string, p79: number, p80: number, p81: number) -- Line: 312
    -- upvalues: u40 (ref), u44 (copy), u29 (ref), FindBracket (copy)
    local Snapshots = p77.Snapshots;

    if Snapshots.Count == 0 then
        p77.FogCulled = p77.PendingFogCulled == true;

        if p77.ApplyCull then
            p77:ApplyCull();
        end;

        return;
    end;

    local v82 = Snapshots:Newest();

    if Snapshots.Count == 1 then
        u40 = u40 + 1;
        p77.Branch = "one";
        p77.FogCulled = v82.FogCulled == true;
        local success, result = pcall(p77.Interpolate, p77, v82.Snapshot, v82.Snapshot, 1, u44.SnapshotInterval, p80);

        if not success then
            p77.InterpolationFailed = true;
            warn((`[Entities] {p78} {p77.Identifier} removed from interpolation: {result}`));
        end;

        return;
    end;

    local v83 = Snapshots:Get(1);

    if p79 <= v83.DisplayTick then
        u40 = u40 + 1;
        p77.Branch = "behind";
        p77.FogCulled = v83.FogCulled == true;
        local success, result = pcall(p77.Interpolate, p77, v83.Snapshot, v83.Snapshot, 1, u44.SnapshotInterval, p80);

        if not success then
            p77.InterpolationFailed = true;
            warn((`[Entities] {p78} {p77.Identifier} removed from interpolation: {result}`));
        end;

        return;
    end;

    if v82.DisplayTick > p79 then
        local v84, v85 = FindBracket(Snapshots, p79);

        if not (v84 and v85) then
            u40 = u40 + 1;
            p77.Branch = "nobracket";

            return;
        end;

        p77.FogCulled = (v85.FogCulled or v84.FogCulled) == true;
        local v86 = v85.DisplayTick - v84.DisplayTick;
        local v87 = v86 / u44.TickRate;
        local v88 = v86 > 0 and (math.clamp((p79 - v84.DisplayTick) / v86, 0, 1) or 1) or 1;
        p77.Branch = "blend";

        if v84.Snapshot.NoInterpParity ~= v85.Snapshot.NoInterpParity or v84.FogCulled ~= v85.FogCulled then
            p77.Branch = "tpblend";
            v88 = 1;
        end;

        local success, result = pcall(p77.Interpolate, p77, v84.Snapshot, v85.Snapshot, v88, v87, p80);

        if not success then
            p77.InterpolationFailed = true;
            warn((`[Entities] {p78} {p77.Identifier} removed from interpolation: {result}`));
        end;

        return;
    end;

    local v89 = Snapshots:Get(Snapshots.Count - 1);
    local v90 = (v82.DisplayTick - v89.DisplayTick) / u44.TickRate;
    local v91 = u29;
    local LastChangedArrival = p77.LastChangedArrival;
    local v92 = p81 - v91;
    local v93;

    if u44.SnapshotTimeout <= v92 or LastChangedArrival ~= nil and v91 - LastChangedArrival > u44.SnapshotInterval * u44.IdleSnapshotIntervals then
        v93 = false;
    else
        v93 = u44.MaxExtrapolation - v92 > 0;
    end;

    local v94 = not (v93 or p77.DecodeGap);

    if v94 then
        if p77.LastChangedArrival == nil then
            v94 = false;
        else
            v94 = p81 - u29 <= u44.SnapshotTimeout;
        end;
    end;

    if not v94 then
        u40 = u40 + 1;
    end;

    p77.FogCulled = v82.FogCulled == true;

    if not (v93 and (p77.Extrapolate and (v90 > 0 and not v82.FogCulled))) then
        p77.Branch = "hold";
        local success, result = pcall(p77.Interpolate, p77, v82.Snapshot, v82.Snapshot, 1, u44.SnapshotInterval, p80);

        if not success then
            p77.InterpolationFailed = true;
            warn((`[Entities] {p78} {p77.Identifier} removed from interpolation: {result}`));
        end;

        return;
    end;

    if v89.Snapshot.NoInterpParity ~= v82.Snapshot.NoInterpParity then
        p77.Branch = "teleport";
        local success, result = pcall(p77.Interpolate, p77, v82.Snapshot, v82.Snapshot, 1, u44.SnapshotInterval, p80);

        if not success then
            p77.InterpolationFailed = true;
            warn((`[Entities] {p78} {p77.Identifier} removed from interpolation: {result}`));
        end;

        return;
    end;

    p77.Branch = "extrap";
    local math_min_ret = math.min((p79 - v82.DisplayTick) / u44.TickRate, u44.MaxExtrapolation);
    local success, result = pcall(p77.Extrapolate, p77, v89.Snapshot, v82.Snapshot, math_min_ret, v90, p80);

    if not success then
        p77.InterpolationFailed = true;
        warn((`[Entities] {p78} {p77.Identifier} removed from interpolation: {result}`));
    end;
end;

local function FlushMovement() -- Line: 524
    -- upvalues: u13 (copy), u16 (copy), u21 (copy), u22 (copy)
    local v95 = 0;

    for _, v in u13 do
        for _, v2 in u16[v] do
            local PrimaryPart = v2.PrimaryPart;
            local CFrame = v2.CFrame;

            if PrimaryPart and (CFrame and (v2.Movable and not (v2.Culled or (v2.OldCFrame == CFrame or not PrimaryPart.Parent)))) then
                v2.OldCFrame = CFrame;
                v95 = v95 + 1;
                u21[v95] = PrimaryPart;
                u22[v95] = CFrame;
            end;
        end;
    end;

    if v95 == 0 then
        return;
    end;

    workspace:BulkMoveTo(u21, u22, Enum.BulkMoveMode.FireCFrameChanged);
    table.clear(u21);
    table.clear(u22);
end;

local function Step(p96: number) -- Line: 581
    -- upvalues: u28 (ref), u37 (ref), u44 (copy), u36 (ref), u38 (ref), u39 (ref), u26 (ref), u35 (ref), u27 (ref), u23 (ref), u24 (ref), u25 (ref), u1 (copy), u13 (copy), u16 (copy), u11 (copy), StepEntity (copy), FlushMovement (copy)
    local os_clock_ret = os.clock();

    if u28 > 0 then
        u37 = u28 - (os_clock_ret - (u44.InterpolationDelay + u36));

        if u37 < 0 then
            u38 = u38 + 1;
        end;

        local HeadroomAttackMargin = u44.HeadroomAttackMargin;
        u39 = u44.MaxRenderBuffer;

        if u44.MarginFloor <= 0 then
            u39 = 0;
            u36 = 0;
        end;

        if u37 < HeadroomAttackMargin then
            local v97 = u36 + math.min(HeadroomAttackMargin - u37, p96);
            u36 = math.min(v97, u39);
        else
            u36 = math.max(u36 - u44.HeadroomDecay * p96, 0);
        end;
    end;

    u26 = u35 and (os_clock_ret - (u44.InterpolationDelay + u36) - u35) * u44.TickRate or 0;

    if u27 > 0 then
        u23 = u26 / u44.TickRate;
        u24 = math.min(u26, u27 + u44.SnapshotWaitMultiplier * 7) / u44.TickRate;
        u25 = u1.GetReceivedMask(u24);
    end;

    for _, v in u13 do
        local v98 = u16[v];

        if next(v98) then
            local v99 = u11[v];

            if v99 then
                v99 = v99.BeginFrame;
            end;

            if v99 then
                v99(u26);
            end;

            local v100 = v;

            for _, v2 in v98 do
                if not v2.InterpolationFailed then
                    StepEntity(v2, v100, u26, p96, os_clock_ret);
                end;
            end;
        end;
    end;

    FlushMovement();
end;

local function BufferSnapshot(p101: any, p102: string, p103: number, p104: number, p105: buffer, p106: number, p107: number) -- Line: 653
    -- upvalues: u12 (copy), u5 (ref), u1 (copy), u14 (copy)
    local v108 = u12[p102];

    if not v108 then
        return false;
    end;

    local v109 = p101.Snapshots:Newest();

    if v109 and p103 <= v109.Tick then
        return true;
    end;

    local v110;

    if p104 == 0 then
        v110 = v108:UnpackScheme(p105);

        if not v110 then
            return false;
        end;
    else
        local ByTick = p101.Snapshots:GetByTick(p104);

        if not ByTick then
            return false;
        end;

        local Snapshot = ByTick.Snapshot;
        local v111;

        if next(Snapshot) then
            v111 = v108.ScratchUnpack or nil;
        else
            v111 = nil;
        end;

        local v112 = v108:UnpackScheme(p105, v111);

        if not v112 then
            return false;
        end;

        v110 = u5.ApplyDelta(Snapshot, v112);
    end;

    local v113 = p101.Snapshots:Push(p103, p106, v110);
    v113.DisplayTick = math.max(p103 + (v110.DisplayOffset or 0), v109 and v109.DisplayTick or (-1 / 0));
    v113.FogCulled = false;
    p101.LastChangedArrival = p107;
    p101.DecodeGap = nil;
    local v114;

    if p102 == "Character" then
        v114 = v110.Health;
    else
        v114 = false;
    end;

    if v114 and v114 ~= p101.Health then
        p101.Health = v114;
        u1.OnHealthUpdate:Fire(p101.UserId, v114);

        if v114 <= 0 then
            table.insert(u14, p101.Identifier);
        end;
    end;

    return true;
end;

local function CarryForward(p115: any, p116: number, p117: number, p118: boolean) -- Line: 717
    local Snapshots = p115.Snapshots;
    local v119 = Snapshots:Newest();

    if not v119 then
        p115.PendingFogCulled = p118;

        return true;
    end;

    if p116 <= v119.Tick then
        return true;
    end;

    if p115.DecodeGap and not p118 then
        return false;
    end;

    local v120 = Snapshots:Push(p116, p117, v119.Snapshot);
    v120.DisplayTick = v119.DisplayTick + (p116 - v119.Tick);
    v120.FogCulled = p118;

    return true;
end;

local function CreateEntity(p121: number, p122: number, p123: any) -- Line: 749
    -- upvalues: u3 (ref), u16 (copy), u11 (copy), u6 (ref), u45 (ref), u1 (copy)
    local v124 = u3.EntityTypes[p121];

    if not v124 then
        warn((`[Entities] unknown entity type {p121} for identifier {p122}`));

        return;
    end;

    local v125 = u16[v124];

    if v125[p122] then
        return;
    end;

    local v126 = u11[v124];

    if not (v126 and p123) then
        return;
    end;

    local success, result = pcall(v126.new, p122, p123);

    if not (success and result) then
        warn((`[Entities] failed to create {v124} {p122}: {result}`));

        return;
    end;

    if v124 == "Character" and result.Health <= 0 then
        pcall(result.Destroy, result);

        return;
    end;

    result.Snapshots = u6.new(u45);
    v125[p122] = result;
    u1.OnEntityCreated:Fire(v124, p122, result);

    if v124 == "Character" then
        u1.OnHealthUpdate:Fire(result.UserId, result.Health);
    end;
end;

local function DestroyEntity(p127: string, p128: number) -- Line: 794
    -- upvalues: u16 (copy), u1 (copy), u17 (copy), u18 (copy), u19 (copy)
    local v129 = u16[p127];

    if not v129 then
        return;
    end;

    local v130 = v129[p128];

    if not v130 then
        return;
    end;

    u1.OnEntityDestroyed:Fire(p127, p128, v130);
    v129[p128] = nil;

    if p127 == "Character" then
        u1.OnHealthUpdate:Fire(v130.UserId, 0);
        u17[p128] = nil;
        u18[p128] = nil;
        u19[p128] = nil;
    end;

    local success, result = pcall(v130.Destroy, v130);

    if not success then
        warn((`[Entities] failed to destroy {p127} {p128}: {result}`));
    end;
end;

function u1.GetEntity(p131: string, p132: number) -- Line: 828
    -- upvalues: u16 (copy)
    local v133 = u16[p131];

    if v133 then
        v133 = v133[p132];
    end;

    return v133;
end;

function u1.GetHealth(p134: userdata) -- Line: 839
    -- upvalues: Players (copy), u15 (ref), u1 (copy)
    if p134 == Players.LocalPlayer then
        return u15 or 0;
    end;

    local CharacterByUserId = u1.GetCharacterByUserId(p134.UserId);

    return CharacterByUserId and CharacterByUserId.Health or 0;
end;

function u1.SetLocalHealth(p135: number?) -- Line: 851
    -- upvalues: u15 (ref), u1 (copy), Players (copy)
    if p135 == nil or p135 == u15 then
        return;
    end;

    u15 = p135;
    u1.OnHealthUpdate:Fire(Players.LocalPlayer.UserId, p135);
end;

function u1.GetAllCategoryEntities(p136: string) -- Line: 860
    -- upvalues: u16 (copy)
    return u16[p136] or {};
end;

function u1.GetCharacterByUserId(p137: number) -- Line: 864
    -- upvalues: u16 (copy)
    for _, v in u16.Character do
        if v.UserId == p137 then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetCharacterCurrentWeapon(p138: number) -- Line: 874
    -- upvalues: u17 (copy)
    return u17[p138];
end;

function u1.GetCharacterWeaponInventory(p139: number) -- Line: 878
    -- upvalues: u19 (copy)
    return u19[p139];
end;

function u1.GetStateAtTime(p140: any, p141: number?) -- Line: 882
    -- upvalues: u44 (copy), FindBracket (copy), SnapshotInterp (copy)
    local Snapshots = p140.Snapshots;

    if not (p141 and (p141 > 0 and (Snapshots and Snapshots.Count > 0))) then
        return p140.Position, p140.Ducked, p140.Yaw;
    end;

    local v142 = p141 * u44.TickRate;
    local v143, v144 = FindBracket(Snapshots, v142);

    if not (v143 and v144) then
        return p140.Position, p140.Ducked, p140.Yaw;
    end;

    local v145 = SnapshotInterp.Alpha(v142, v143.DisplayTick, v144.DisplayTick);

    return SnapshotInterp.State(v143.Snapshot, v144.Snapshot, v143.Snapshot.NoInterpParity ~= v144.Snapshot.NoInterpParity and 1 or v145);
end;

function u1.GetRenderTime() -- Line: 905
    -- upvalues: u23 (ref)
    return u23;
end;

function u1.GetShotView() -- Line: 910
    -- upvalues: u24 (ref), u25 (ref)
    return u24, u25;
end;

function u1.GetReceivedMask(p146: number) -- Line: 921
    -- upvalues: u44 (copy), table_create_ret (copy)
    local SnapshotWaitMultiplier = u44.SnapshotWaitMultiplier;
    local v147 = math.floor(p146 * u44.TickRate) / SnapshotWaitMultiplier;
    local v148 = math.floor(v147) * SnapshotWaitMultiplier;
    local v149 = 0;

    for i = 0, 15 do
        local v150 = v148 + (i - 7) * SnapshotWaitMultiplier;
        local v151;

        if table_create_ret[v150 % 128 + 1] == v150 then
            v149 = v149 + bit32.lshift(1, i);
            v151 = i;
        else
            v151 = i;
        end;
    end;

    return v149;
end;

function u1.GetPlayheadTick() -- Line: 950
    -- upvalues: u26 (ref), u44 (copy)
    return u26, u44.TickRate or 64;
end;

function u1.GetLatestSnapshotTick() -- Line: 963
    -- upvalues: u27 (ref)
    return u27;
end;

function u1.GetInterpolationStats() -- Line: 987
    -- upvalues: u44 (copy), u36 (ref), u37 (ref), u38 (ref), u40 (ref), u31 (ref), u32 (ref), u33 (ref)
    return (u44.InterpolationDelay or 0) + u36, u36, u37, u38, u40, u31, u32, u33;
end;

function u1.Destroy(p152: string, p153: number) -- Line: 991
    -- upvalues: DestroyEntity (copy)
    DestroyEntity(p152, p153);
end;

function u1.Init(p154) -- Line: 997
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u10 (ref), u9 (ref), u1 (copy), u11 (copy), u13 (copy), u16 (copy), u44 (copy), u46 (ref), u39 (ref), u36 (ref), u35 (ref), RefreshConfig (copy)
    u2 = p154:GetModule("Network");
    u3 = p154:GetModule("Enums");
    u4 = p154:GetModule("Tick");
    u5 = p154:GetModule("Table");
    u6 = p154:GetModule("SnapshotRing");
    u7 = p154:GetModule("GameConfiguration");
    u8 = p154:GetModule("BufferScheme");
    u10 = p154:GetModule("CharacterController");
    u9 = p154:GetModule("Signal");
    u1.OnCharacterCurrentWeapon = u9.new();
    u1.OnCharacterCurrentWeaponInventoryData = u9.new();
    u1.OnEntityCreated = u9.new();
    u1.OnEntityDestroyed = u9.new();
    u1.OnHealthUpdate = u9.new();
    u11.Character = p154:GetModule("Character");
    u11.DroppedWeapon = p154:GetModule("DroppedWeapon");
    u11.Bomb = p154:GetModule("Bomb");

    for _, v in u13 do
        u16[v] = {};
    end;

    local TickRate = u44.TickRate;

    for i, v in u7.GetEntityTiming(u46) do
        u44[i] = v;
    end;

    u39 = u44.MaxRenderBuffer;
    u36 = math.min(u36, u39);

    if TickRate ~= u44.TickRate then
        u35 = nil;
        u36 = 0;
    end;

    u7.Updated:Connect(RefreshConfig);
end;

function u1.Start(p155) -- Line: 1030
    -- upvalues: u12 (copy), u8 (ref), u45 (ref), u4 (ref), u44 (copy), u46 (ref), u7 (ref), u39 (ref), u36 (ref), u35 (ref), u2 (ref), CreateEntity (copy), u3 (ref), DestroyEntity (copy), u10 (ref), u1 (copy), u27 (ref), Stamp (copy), u29 (ref), table_create_ret (copy), u34 (ref), u31 (ref), u32 (ref), u28 (ref), u13 (copy), u16 (copy), BufferSnapshot (copy), u33 (ref), u14 (copy), u30 (ref), u18 (copy), u17 (copy), u19 (copy), u20 (copy), Step (copy)
    u12.Character = u8.GetScheme("EntityCharacter");
    u12.DroppedWeapon = u8.GetScheme("EntityDroppedWeapon");
    u12.Bomb = u8.GetScheme("EntityBomb");
    u12.CharacterWeaponInventoryData = u8.GetScheme("CharacterWeaponInventoryData");
    u12.CharacterWeaponData = u8.GetScheme("CharacterWeaponData");
    local v156 = u4.HistorySize(u44.ClientHistorySeconds);
    u45 = math.max(v156, u44.ClientHistoryMinSnapshots);
    local Component = p155:GetModule("Gui").GetComponent("Settings");
    local Game = Component:GetPlayerSettings().Game;

    if Game then
        Game = Game.Gameplay;
    end;

    if Game then
        Game = Game["Interpolation Ticks"];
    end;

    u46 = Game;
    local TickRate = u44.TickRate;

    for i, v in u7.GetEntityTiming(u46) do
        u44[i] = v;
    end;

    u39 = u44.MaxRenderBuffer;
    u36 = math.min(u36, u39);

    if TickRate ~= u44.TickRate then
        u35 = nil;
        u36 = 0;
    end;

    Component:AddConnection("Game", "Gameplay", "Interpolation Ticks", function(p157) -- Line: 1049
        -- upvalues: u46 (ref), u44 (ref), u7 (ref), u39 (ref), u36 (ref), u35 (ref)
        u46 = math.floor(p157);
        local TickRate2 = u44.TickRate;

        for i, v in u7.GetEntityTiming(u46) do
            u44[i] = v;
        end;

        u39 = u44.MaxRenderBuffer;
        u36 = math.min(u36, u39);

        if TickRate2 ~= u44.TickRate then
            u35 = nil;
            u36 = 0;
        end;
    end);
    u2.Entity.OnPlayerConnected.On(function(p158) -- Line: 1056
        -- upvalues: CreateEntity (ref)
        for i, v in p158 do
            local v159 = i;

            for i2, v2 in v do
                CreateEntity(v159, i2, v2);
            end;
        end;
    end);
    u2.Entity.CreateEntity.On(function(p160) -- Line: 1064
        -- upvalues: CreateEntity (ref)
        CreateEntity(p160.Type, p160.Identifier, p160.Data);
    end);
    u2.Entity.DestroyEntity.On(function(p161) -- Line: 1068
        -- upvalues: u3 (ref), DestroyEntity (ref)
        local v162 = u3.EntityTypes[p161.Type];

        if v162 then
            DestroyEntity(v162, p161.Identifier);
        end;
    end);
    u10.OnCharacterDestroy:Connect(function() -- Line: 1078
        -- upvalues: u1 (ref)
        u1.SetLocalHealth(0);
    end);
    u2.Entity.EntitySnapshot.On(function(p163: number, p164: number, p165: any) -- Line: 1082
        -- upvalues: u27 (ref), Stamp (ref), u29 (ref), table_create_ret (ref), u34 (ref), u44 (ref), u31 (ref), u32 (ref), u28 (ref), u13 (ref), u3 (ref), u16 (ref), BufferSnapshot (ref), u33 (ref), u14 (ref), DestroyEntity (ref), u30 (ref), u2 (ref)
        if not p165 or p163 <= u27 then
            return;
        end;

        local os_clock_ret = os.clock();
        local v166 = Stamp(p163, os_clock_ret);
        u29 = os_clock_ret;
        table_create_ret[p163 % 128 + 1] = p163;

        if u27 < p163 then
            if u34 > 0 then
                local v167 = p163 - u34 - u44.SnapshotWaitMultiplier;

                if v167 > 0 then
                    u31 = u31 + 1;
                    u32 = u32 + v167;
                end;
            end;

            u34 = p163;
            u27 = p163;
            u28 = v166;
        end;

        local v168 = true;

        for _, v in u13 do
            local v169 = u3.EntityTypesNum[v];

            if v169 then
                v169 = p165[v169];
            end;

            local v170 = v;

            for i, v2 in u16[v] do
                if not v2.InterpolationFailed then
                    local v171;

                    if v169 then
                        v171 = v169[i];
                    else
                        v171 = v169;
                    end;

                    local v172;

                    if v171 and buffer.len(v171) == 0 then
                        local Snapshots = v2.Snapshots;
                        local v173 = Snapshots:Newest();

                        if v173 then
                            if p163 <= v173.Tick then
                                v172 = true;
                            else
                                local _ = v2.DecodeGap;
                                local v174 = Snapshots:Push(p163, v166, v173.Snapshot);
                                v174.DisplayTick = v173.DisplayTick + (p163 - v173.Tick);
                                v174.FogCulled = true;
                                v172 = true;
                            end;
                        else
                            v2.PendingFogCulled = true;
                            v172 = true;
                        end;
                    elseif v171 then
                        v172 = BufferSnapshot(v2, v170, p163, p164, v171, v166, os_clock_ret);

                        if not v172 then
                            v2.DecodeGap = true;
                            u33 = u33 + 1;
                        end;
                    else
                        local Snapshots = v2.Snapshots;
                        local v175 = Snapshots:Newest();

                        if v175 then
                            if p163 <= v175.Tick then
                                v172 = true;
                            elseif v2.DecodeGap then
                                v172 = false;
                            else
                                local v176 = Snapshots:Push(p163, v166, v175.Snapshot);
                                v176.DisplayTick = v175.DisplayTick + (p163 - v175.Tick);
                                v176.FogCulled = false;
                                v172 = true;
                            end;
                        else
                            v2.PendingFogCulled = false;
                            v172 = true;
                        end;
                    end;

                    if not v172 then
                        v168 = false;
                    end;
                end;
            end;

            if v168 and v169 then
                local v177 = u16[v170];

                for i in v169 do
                    if not v177[i] then
                        v168 = false;
                        break;
                    end;
                end;
            end;
        end;

        for _, v in u14 do
            DestroyEntity("Character", v);
        end;

        table.clear(u14);

        if v168 and u30 < p163 and (p164 == 0 or p163 - u30 >= u44.SnapshotWaitMultiplier * u44.SnapshotAckEvery) then
            u30 = p163;
            u2.Entity.AckSnapshot.Fire(p163);
        end;
    end);
    u2.Entity.CharacterCurrentWeapon.On(function(p178) -- Line: 1186
        -- upvalues: u12 (ref), u18 (ref), u3 (ref), u17 (ref), u16 (ref), u1 (ref)
        local v179 = u12.CharacterWeaponData:UnpackScheme(p178.Data);
        u18[p178.Identifier] = v179;
        p178.Data = nil;

        for i, v in v179 do
            p178[i] = v;
        end;

        p178.Skin = u3.SkinsNum[p178.Name][p178.Skin];
        p178.Name = u3.Weapons[p178.Name];
        local Identifier = p178.Identifier;
        local v180 = u17[Identifier];
        u17[Identifier] = p178;
        local v181 = u16.Character[Identifier];

        if v181 then
            v181.CharacterCurrentWeapon = p178;

            if not (v180 and (v180.Name == p178.Name and v180.Skin == p178.Skin)) then
                v181.CurrentWeaponChanged:Fire(p178);
            end;
        end;

        u1.OnCharacterCurrentWeapon:Fire(Identifier, p178);
    end);
    u2.Entity.CharacterWeaponInventorySlot.On(function(p182) -- Line: 1215
        -- upvalues: u12 (ref), u19 (ref), u16 (ref), u3 (ref)
        local Identifier = p182.Identifier;
        local v183 = u12.CharacterWeaponData:UnpackScheme(p182.Data);
        p182.Data = nil;

        for i, v in v183 do
            p182[i] = v;
        end;

        if p182.Name == 0 then
            local v184 = u19[Identifier];

            if not v184 then
                return;
            end;

            v184[p182.Slot] = nil;
            local v185 = u16.Character[Identifier];

            if v185 then
                v185.WeaponInventoryChanged:Fire(v184);
            end;

            return;
        end;

        p182.Skin = u3.SkinsNum[p182.Name][p182.Skin];
        p182.Name = u3.Weapons[p182.Name];
        local v186 = u19[Identifier];

        if not v186 then
            v186 = {};
            u19[Identifier] = v186;
        end;

        v186[p182.Slot] = p182;
        local v187 = u16.Character[Identifier];

        if v187 then
            v187.WeaponInventory = v186;
            v187.WeaponInventoryChanged:Fire(v186);
        end;
    end);
    u2.Entity.CharacterCurrentWeaponInventoryData.On(function(p188) -- Line: 1261
        -- upvalues: u17 (ref), u18 (ref), u19 (ref), u12 (ref), u20 (ref), u16 (ref), u1 (ref)
        local Identifier = p188.Identifier;
        local v189 = u17[Identifier];
        local v190 = u18[Identifier];

        if not (v189 and (v190 and v189.Slot == p188.Slot)) then
            return;
        end;

        local v191 = u19[Identifier];

        if v191 then
            v191 = v191[p188.Slot];
        end;

        local v192 = u12.CharacterWeaponInventoryData:UnpackScheme(p188.State);

        for _, v in u20 do
            local v193 = v190[v];
            v189[v] = v193;

            if v191 then
                v191[v] = v193;
            end;
        end;

        for i, v in v192 do
            v189[i] = v;

            if v191 then
                v191[i] = v;
            end;
        end;

        local v194 = u16.Character[Identifier];

        if v194 then
            v194.CurrentWeaponInventoryDataChanged:Fire(v189);
        end;

        u1.OnCharacterCurrentWeaponInventoryData:Fire(Identifier, v189);
    end);
    u4.PostTick.Connect({
        Function = Step,
        Priority = 1,
        SubPriority = 1
    });
end;

return u1;