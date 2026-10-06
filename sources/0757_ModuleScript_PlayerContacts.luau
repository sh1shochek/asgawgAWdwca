-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Parent.Enums);
local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
local Config = require(script.Parent.Config);
local DeterminismTrace = require(script.Parent.DeterminismTrace);
local u1 = {
    DefaultIterations = 4,
    DefaultContactEpsilon = 0.002,
    DefaultSeparationSkin = 0.0005,

    newScratch = function() -- Line: 75, Name: newScratch
        return {
            HalfSizes = {},
            PairA = {},
            PairB = {},
            Deltas = {},
            Counts = {},
            Contacts = {},
            SupportTopById = {},
            SupportLowerById = {},
            SupportAnchorById = {},
            BodiesById = {},
            SupportsById = {}
        };
    end
};

local function isFiniteNumber(p2) -- Line: 96
    local v3;

    if typeof(p2) == "number" and (p2 == p2 and p2 > (-1 / 0)) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

local function isFiniteVector3(p4) -- Line: 100
    local v5;

    if typeof(p4) == "Vector3" then
        local X = p4.X;

        if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
            v5 = X < (1 / 0);
        else
            v5 = false;
        end;

        if v5 then
            local Y = p4.Y;

            if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
                v5 = Y < (1 / 0);
            else
                v5 = false;
            end;

            if v5 then
                local Z = p4.Z;

                if typeof(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
                    v5 = Z < (1 / 0);
                else
                    v5 = false;
                end;
            end;
        end;
    else
        v5 = false;
    end;

    return v5;
end;

local function traceFor(p6: table, p7: number) -- Line: 107
    if p6.TraceBodyId == p7 then
        return p6.TraceRecorder;
    end;

    local TraceRecordersById = p6.TraceRecordersById;

    if TraceRecordersById == nil then
        return nil;
    end;

    return TraceRecordersById[p7];
end;

local function traceBody(p8: table, p9: string, p10: table, p11: number?, p12: number?) -- Line: 115
    -- upvalues: DeterminismTrace (copy)
    local Id = p10.Id;
    local v13;

    if p8.TraceBodyId == Id then
        v13 = p8.TraceRecorder;
    else
        local TraceRecordersById = p8.TraceRecordersById;

        if TraceRecordersById == nil then
            v13 = nil;
        else
            v13 = TraceRecordersById[Id];
        end;
    end;

    if v13 == nil then
        return;
    end;

    DeterminismTrace.vector(v13, p9, p10.Position, p10.WorldVelocity, p11, p12, nil, "ReplicatedStorage.MovementV2.Simulation.PlayerContacts", debug.info(2, "l"));
end;

local function halfSize(p14: table, p15: any) -- Line: 133
    local v16;

    if p14.Stance == "Ducking" then
        v16 = p15.PlayerSizeDucking;
    else
        v16 = p15.PlayerSizeStanding;
    end;

    return v16 * 0.5;
end;

function u1.toWorldVelocity(p17: vector, p18: any) -- Line: 137
    -- upvalues: Enums (copy)
    if p18.Kind == Enums.SupportKind.None then
        return p17;
    end;

    return p17 + p18.Velocity;
end;

function u1.carryDelta(p19: vector, p20: vector, p21: number, p22: number) -- Line: 142
    return p19 / math.max(1, p22) - p20 * p21;
end;

function u1.fromWorldVelocity(p23: vector, p24: any) -- Line: 152
    -- upvalues: Enums (copy)
    if p24.Kind == Enums.SupportKind.None then
        return p23;
    end;

    return p23 - p24.Velocity;
end;

local function validateBodies(p25: table) -- Line: 156
    -- upvalues: Serial (copy)
    local v26 = 0;
    local v27 = 0;

    for _, v in p25 do
        local v28 = Serial.isUInt32(v.Id) and v.Id > 0;
        assert(v28, "player contact body ID must be a non-zero u32");
        assert(v26 < v.Id, "player contact bodies must be strictly sorted by ID");
        local StartPosition = v.StartPosition;
        local v29;

        if typeof(StartPosition) == "Vector3" then
            local X = StartPosition.X;

            if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
                v29 = X < (1 / 0);
            else
                v29 = false;
            end;

            if v29 then
                local Y = StartPosition.Y;

                if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
                    v29 = Y < (1 / 0);
                else
                    v29 = false;
                end;

                if v29 then
                    local Z = StartPosition.Z;

                    if typeof(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
                        v29 = Z < (1 / 0);
                    else
                        v29 = false;
                    end;
                end;
            end;
        else
            v29 = false;
        end;

        assert(v29, "invalid player contact start position");
        local Position = v.Position;
        local v30;

        if typeof(Position) == "Vector3" then
            local X = Position.X;

            if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
                v30 = X < (1 / 0);
            else
                v30 = false;
            end;

            if v30 then
                local Y = Position.Y;

                if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
                    v30 = Y < (1 / 0);
                else
                    v30 = false;
                end;

                if v30 then
                    local Z = Position.Z;

                    if typeof(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
                        v30 = Z < (1 / 0);
                    else
                        v30 = false;
                    end;
                end;
            end;
        else
            v30 = false;
        end;

        assert(v30, "invalid player contact position");
        local WorldVelocity = v.WorldVelocity;
        local v31;

        if typeof(WorldVelocity) == "Vector3" then
            local X = WorldVelocity.X;

            if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
                v31 = X < (1 / 0);
            else
                v31 = false;
            end;

            if v31 then
                local Y = WorldVelocity.Y;

                if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
                    v31 = Y < (1 / 0);
                else
                    v31 = false;
                end;

                if v31 then
                    local Z = WorldVelocity.Z;

                    if typeof(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
                        v31 = Z < (1 / 0);
                    else
                        v31 = false;
                    end;
                end;
            end;
        else
            v31 = false;
        end;

        assert(v31, "invalid player contact velocity");
        assert(v.Stance == "Standing" and true or v.Stance == "Ducking", "invalid player contact stance");
        local v32 = typeof(v.OwnsMotion) == "boolean";
        assert(v32, "invalid player contact motion ownership");

        if v.OwnsMotion then
            v27 = v27 + 1;
        end;

        v26 = v.Id;
    end;

    assert(v27 <= 1, "player contact solve may write only one moving body");
end;

local function axisComponent(p33: vector, p34: number) -- Line: 175
    if p34 == 1 then
        return p33.X;
    end;

    if p34 == 2 then
        return p33.Y;
    end;

    return p33.Z;
end;

local function axisVector(p35: number) -- Line: 185
    return p35 == 1 and Vector3.new(1, 0, 0) or (p35 == 2 and Vector3.new(0, 1, 0) or Vector3.new(0, 0, 1));
end;

local function axisPriority(p36: number) -- Line: 195
    return p36 == 2 and 1 or (p36 == 1 and 2 or 3);
end;

local function sweptPair(p37: table, p38: table, p39: vector, p40: number) -- Line: 201
    if math.min(p37.StartPosition.X, p37.Position.X) > math.max(p38.StartPosition.X, p38.Position.X) + p39.X or (math.min(p38.StartPosition.X, p38.Position.X) > math.max(p37.StartPosition.X, p37.Position.X) + p39.X or (math.min(p37.StartPosition.Y, p37.Position.Y) > math.max(p38.StartPosition.Y, p38.Position.Y) + p39.Y or (math.min(p38.StartPosition.Y, p38.Position.Y) > math.max(p37.StartPosition.Y, p37.Position.Y) + p39.Y or (math.min(p37.StartPosition.Z, p37.Position.Z) > math.max(p38.StartPosition.Z, p38.Position.Z) + p39.Z or math.min(p38.StartPosition.Z, p38.Position.Z) > math.max(p37.StartPosition.Z, p37.Position.Z) + p39.Z)))) then
        return nil, nil;
    end;

    local v41 = p37.StartPosition - p38.StartPosition;

    if math.abs(v41.X) < p39.X and (math.abs(v41.Y) < p39.Y and math.abs(v41.Z) < p39.Z) then
        return nil, nil;
    end;

    local v42 = p37.Position - p37.StartPosition - (p38.Position - p38.StartPosition);
    local v43 = 0;
    local v44 = 1;
    local v45 = 0;
    local v46 = 1;
    local v47 = 0;
    local v48 = Vector3.new(0, 0, 0);

    for i = 1, 3 do
        local v49;

        if i == 1 then
            v49 = v41.X;
        elseif i == 2 then
            v49 = v41.Y;
        else
            v49 = v41.Z;
        end;

        local v50;

        if i == 1 then
            v50 = v42.X;
        elseif i == 2 then
            v50 = v42.Y;
        else
            v50 = v42.Z;
        end;

        local v51;

        if i == 1 then
            v51 = p39.X;
        elseif i == 2 then
            v51 = p39.Y;
        else
            v51 = p39.Z;
        end;

        local math_max_ret = math.max(v51 - p40, 0);
        local v52;

        if math.abs(v50) <= 1e-9 then
            if v49 < -v51 or v51 < v49 then
                return nil, nil;
            end;

            if v49 <= -math_max_ret or math_max_ret <= v49 then
                return nil, nil;
            end;

            v52 = i;
        else
            local v53 = (-v51 - v49) / v50;
            local v54 = (v51 - v49) / v50;
            local math_min_ret = math.min(v53, v54);
            local math_max_ret2 = math.max(v53, v54);

            if v47 + 1e-9 < math_min_ret or math.abs(math_min_ret - v47) <= 1e-9 and (v43 == 0 or (i == 2 and 1 or (i == 1 and 2 or 3)) < (v43 == 2 and 1 or (v43 == 1 and 2 or 3))) then
                v47 = math.max(math_min_ret, 0);
                v48 = (i == 1 and Vector3.new(1, 0, 0) or (i == 2 and Vector3.new(0, 1, 0) or Vector3.new(0, 0, 1))) * (v50 > 0 and -1 or 1);
                v43 = i;
            end;

            v44 = math.min(v44, math_max_ret2);
            local v55 = (-math_max_ret - v49) / v50;
            local v56 = (math_max_ret - v49) / v50;
            local math_min_ret2 = math.min(v55, v56);
            v45 = math.max(v45, math_min_ret2);
            local math_max_ret3 = math.max(v55, v56);
            v46 = math.min(v46, math_max_ret3);

            if v44 < v47 or v46 <= v45 then
                return nil, nil;
            end;

            v52 = i;
        end;
    end;

    local math_max_ret = math.max(v45, 0);
    local math_min_ret = math.min(v46, 1);

    if math_min_ret <= math_max_ret or (math_min_ret <= 0 or (math_max_ret >= 1 or (v47 >= 1 or v48 == Vector3.new(0, 0, 0)))) then
        return nil, nil;
    end;

    return v47, v48;
end;

local function overlapContact(p57: table, p58: table, p59: vector, p60: number) -- Line: 284
    local v61 = p57.Position - p58.Position;
    local v62 = p59.X - math.abs(v61.X);
    local v63 = p59.Y - math.abs(v61.Y);
    local v64 = p59.Z - math.abs(v61.Z);

    if v62 < -p60 or (v63 < -p60 or v64 < -p60) then
        return nil, nil;
    end;

    local v65;

    if v62 < v63 - p60 then
        v63 = v62;
        v65 = 1;
    else
        v65 = 2;
    end;

    if v64 < v63 - p60 then
        v63 = v64;
        v65 = 3;
    end;

    if v65 == 2 and (v62 <= 0 or v64 <= 0) then
        if v62 <= v64 then
            v64 = v62;
            v65 = 1;
        else
            v65 = 3;
        end;
    else
        v64 = v63;
    end;

    local v66;

    if v65 == 1 then
        v66 = v61.X;
    elseif v65 == 2 then
        v66 = v61.Y;
    else
        v66 = v61.Z;
    end;

    return (v65 == 1 and Vector3.new(1, 0, 0) or (v65 == 2 and Vector3.new(0, 1, 0) or Vector3.new(0, 0, 1))) * (v66 > 0 and 1 or (v66 < 0 and -1 or (p57.Id < p58.Id and -1 or 1))), v64;
end;

local function accumulateMoverCorrection(p67: table, p68: table, p69: vector, p70: number, p71: table, p72: table) -- Line: 318
    if p70 <= 0 then
        return;
    end;

    if p67.OwnsMotion then
        p68 = p67;
    elseif not p68.OwnsMotion then
        p68 = nil;
    end;

    if p68 == nil then
        return;
    end;

    if p68 ~= p67 then
        p69 = -p69;
    end;

    local v73 = -(p68.Position - p68.StartPosition):Dot(p69);
    local math_max_ret = math.max(v73, 0);

    if math_max_ret <= 1e-9 then
        return;
    end;

    local v74 = p69 * math.min(p70, math_max_ret);
    local v75 = p71[p68.Id] or Vector3.new(0, 0, 0);
    local Id = p68.Id;
    local v76;

    if math.abs(v74.X) > math.abs(v75.X) then
        v76 = v74.X;
    else
        v76 = v75.X;
    end;

    local v77;

    if math.abs(v74.Y) > math.abs(v75.Y) then
        v77 = v74.Y;
    else
        v77 = v75.Y;
    end;

    local v78;

    if math.abs(v74.Z) > math.abs(v75.Z) then
        v78 = v74.Z;
    else
        v78 = v75.Z;
    end;

    p71[Id] = Vector3.new(v76, v77, v78);
    p72[p68.Id] = (p72[p68.Id] or 0) + 1;
end;

local function applyCorrections(p79: table, p80: table, p81: table, p82: function?, p83: table, p84: string) -- Line: 352
    -- upvalues: DeterminismTrace (copy)
    local v85 = 0;

    for _, v in p79 do
        local v86 = p80[v.Id];

        if v86 ~= nil then
            local v87 = p81[v.Id] or 1;
            local v88 = v.Position + v86;
            local v89 = p82 == nil and true or p82(v, v88);
            local v90 = typeof(v89) == "boolean";
            assert(v90, "player contact CanOccupy must return a boolean");
            local v91;

            if v89 then
                v.Position = v88;
                v91 = v;
            else
                v91 = v;

                for i = 1, 3 do
                    local v92;

                    if i == 1 then
                        v92 = v86.X;
                    elseif i == 2 then
                        v92 = v86.Y;
                    else
                        v92 = v86.Z;
                    end;

                    local v93;

                    if v92 == 0 then
                        v93 = i;
                    else
                        local v94 = v91.Position + (i == 1 and Vector3.new(1, 0, 0) or (i == 2 and Vector3.new(0, 1, 0) or Vector3.new(0, 0, 1))) * v92;
                        local v95 = assert(p82)(v91, v94);
                        local v96 = typeof(v95) == "boolean";
                        assert(v96, "player contact CanOccupy must return a boolean");

                        if v95 then
                            v91.Position = v94;
                            v93 = i;
                        else
                            v85 = v85 + 1;
                            v93 = i;
                        end;
                    end;
                end;
            end;

            local v97 = v89 and 1 or 0;
            local Id = v91.Id;
            local v98;

            if p83.TraceBodyId == Id then
                v98 = p83.TraceRecorder;
            else
                local TraceRecordersById = p83.TraceRecordersById;

                if TraceRecordersById == nil then
                    v98 = nil;
                else
                    v98 = TraceRecordersById[Id];
                end;
            end;

            if v98 ~= nil then
                DeterminismTrace.vector(v98, p84, v91.Position, v91.WorldVelocity, v97, v87, nil, "ReplicatedStorage.MovementV2.Simulation.PlayerContacts", debug.info(2, "l"));
            end;
        end;
    end;

    return v85;
end;

local function removeInwardVelocity(p99: table, p100: table, p101: vector, p102: table) -- Line: 393
    -- upvalues: DeterminismTrace (copy)
    local v103 = p99.WorldVelocity:Dot(p101);

    if p99.OwnsMotion and v103 < 0 then
        p99.WorldVelocity = p99.WorldVelocity - p101 * v103;
        local Id = p100.Id;
        local Id2 = p99.Id;
        local v104;

        if p102.TraceBodyId == Id2 then
            v104 = p102.TraceRecorder;
        else
            local TraceRecordersById = p102.TraceRecordersById;

            if TraceRecordersById == nil then
                v104 = nil;
            else
                v104 = TraceRecordersById[Id2];
            end;
        end;

        if v104 ~= nil then
            DeterminismTrace.vector(v104, "playerContacts.velocityClip", p99.Position, p99.WorldVelocity, v103, Id, nil, "ReplicatedStorage.MovementV2.Simulation.PlayerContacts", debug.info(2, "l"));
        end;
    end;

    local v105 = p100.WorldVelocity:Dot(p101);

    if p100.OwnsMotion and v105 > 0 then
        p100.WorldVelocity = p100.WorldVelocity - p101 * v105;
        local Id = p100.Id;
        local v106;

        if p102.TraceBodyId == Id then
            v106 = p102.TraceRecorder;
        else
            local TraceRecordersById = p102.TraceRecordersById;

            if TraceRecordersById == nil then
                v106 = nil;
            else
                v106 = TraceRecordersById[Id];
            end;
        end;

        if v106 == nil then
            return;
        end;

        DeterminismTrace.vector(v106, "playerContacts.velocityClip", p100.Position, p100.WorldVelocity, v105, p99.Id, nil, "ReplicatedStorage.MovementV2.Simulation.PlayerContacts", debug.info(2, "l"));
    end;
end;

function u1.solve(p107: table, p108: table?) -- Line: 407
    -- upvalues: validateBodies (copy), Config (copy), u1 (copy), DeterminismTrace (copy), sweptPair (copy), accumulateMoverCorrection (copy), applyCorrections (copy), overlapContact (copy), removeInwardVelocity (copy), Enums (copy)
    validateBodies(p107);
    local v109 = p108 or {};
    local v110 = v109.Config or Config.Default;
    local v111 = v109.Iterations or u1.DefaultIterations;
    local v112 = v109.ContactEpsilon or u1.DefaultContactEpsilon;
    local v113 = v109.SeparationSkin or u1.DefaultSeparationSkin;
    local v114 = v109.Scratch or u1.newScratch();
    local v115;

    if v111 % 1 == 0 and v111 >= 1 then
        v115 = v111 <= 8;
    else
        v115 = false;
    end;

    assert(v115, "invalid player contact iteration count");
    local v116;

    if typeof(v112) == "number" and (v112 == v112 and v112 > (-1 / 0)) then
        v116 = v112 < (1 / 0);
    else
        v116 = false;
    end;

    if v116 then
        if v112 >= 0 then
            v116 = v112 <= 0.1;
        else
            v116 = false;
        end;
    end;

    assert(v116, "invalid player contact epsilon");
    local v117;

    if typeof(v113) == "number" and (v113 == v113 and v113 > (-1 / 0)) then
        v117 = v113 < (1 / 0);
    else
        v117 = false;
    end;

    if v117 then
        if v113 >= 0 then
            v117 = v113 <= 0.1;
        else
            v117 = false;
        end;
    end;

    assert(v117, "invalid player separation skin");
    local HalfSizes = v114.HalfSizes;
    table.clear(HalfSizes);
    local v118 = nil;

    for _, v in p107 do
        local v119;

        if v.Stance == "Ducking" then
            v119 = v110.PlayerSizeDucking;
        else
            v119 = v110.PlayerSizeStanding;
        end;

        HalfSizes[v.Id] = v119 * 0.5;

        if v.OwnsMotion then
            v118 = v;
        end;

        local v120 = v.OwnsMotion and 1 or 0;
        local Id = v.Id;
        local v121;

        if v109.TraceBodyId == Id then
            v121 = v109.TraceRecorder;
        else
            local TraceRecordersById = v109.TraceRecordersById;

            if TraceRecordersById == nil then
                v121 = nil;
            else
                v121 = TraceRecordersById[Id];
            end;
        end;

        if v121 ~= nil then
            DeterminismTrace.vector(v121, "playerContacts.input", v.Position, v.WorldVelocity, v120, 0, nil, "ReplicatedStorage.MovementV2.Simulation.PlayerContacts", debug.info(2, "l"));
        end;
    end;

    local PairA = v114.PairA;
    local PairB = v114.PairB;
    table.clear(PairA);
    table.clear(PairB);

    if v118 ~= nil then
        for _, v in p107 do
            if v ~= v118 then
                local v122 = #PairA + 1;
                local v123;

                if v.Id < v118.Id then
                    v123 = v;
                else
                    v123 = v118;
                end;

                PairA[v122] = v123;
                local v124;

                if v.Id < v118.Id then
                    v124 = v118;
                else
                    v124 = v;
                end;

                PairB[v122] = v124;
            end;
        end;
    end;

    local Deltas = v114.Deltas;
    local Counts = v114.Counts;
    table.clear(Deltas);
    table.clear(Counts);
    local v125 = 0;

    for i, v in PairA do
        local v126 = PairB[i];
        local v127, v128 = sweptPair(v, v126, HalfSizes[v.Id] + HalfSizes[v126.Id], (math.max(v113, 1e-7)));

        if v127 ~= nil and v128 ~= nil then
            local v129 = -(v.Position - v.StartPosition - (v126.Position - v126.StartPosition)):Dot(v128) * (1 - v127);

            if v129 > 0 then
                accumulateMoverCorrection(v, v126, v128, v129 + v113, Deltas, Counts);
                v125 = v125 + 1;
            end;
        end;
    end;

    local v130 = 0 + applyCorrections(p107, Deltas, Counts, v109.CanOccupy, v109, "playerContacts.sweptCorrection");

    for i = 1, v111 do
        table.clear(Deltas);
        table.clear(Counts);
        local _ = i;

        for i2, v in PairA do
            local v131 = PairB[i2];
            local v132, v133 = overlapContact(v, v131, HalfSizes[v.Id] + HalfSizes[v131.Id], v112);

            if v132 ~= nil and (v133 ~= nil and v133 > 0) then
                accumulateMoverCorrection(v, v131, v132, v133 + v113, Deltas, Counts);
            end;
        end;

        if next(Deltas) == nil then
            break;
        end;

        v130 = v130 + applyCorrections(p107, Deltas, Counts, v109.CanOccupy, v109, "playerContacts.overlapCorrection");
    end;

    local v134 = v109.CollectContacts ~= false;
    local Contacts = v114.Contacts;
    local SupportTopById = v114.SupportTopById;
    local SupportLowerById = v114.SupportLowerById;
    local SupportAnchorById = v114.SupportAnchorById;
    table.clear(Contacts);
    table.clear(SupportTopById);
    table.clear(SupportLowerById);
    table.clear(SupportAnchorById);

    for i, v in PairA do
        local v135 = PairB[i];
        local v136, v137 = overlapContact(v, v135, HalfSizes[v.Id] + HalfSizes[v135.Id], v112);

        if v136 ~= nil and v137 ~= nil then
            if v134 then
                Contacts[#Contacts + 1] = {
                    A = v.Id,
                    B = v135.Id,
                    Normal = v136,
                    Penetration = math.max(v137, 0)
                };
            end;

            removeInwardVelocity(v, v135, v136, v109);

            if math.abs(v136.Y) > 0.5 then
                local v138;

                if v136.Y > 0 then
                    v138 = v;
                else
                    v138 = v135;
                end;

                if v136.Y <= 0 then
                    v135 = v;
                end;

                local v139 = v135.Position.Y + HalfSizes[v135.Id].Y;

                if v138.Position.Y - HalfSizes[v138.Id].Y >= v139 - v112 - v113 and v138.WorldVelocity.Y - v135.WorldVelocity.Y <= v110.GroundClearVelocity then
                    local v140 = SupportTopById[v138.Id];

                    if v140 == nil or (v140 < v139 or v139 == v140 and v135.Id < (SupportLowerById[v138.Id] or (1 / 0))) then
                        SupportTopById[v138.Id] = v139;
                        SupportLowerById[v138.Id] = v135.Id;
                        SupportAnchorById[v138.Id] = v138.Position - v135.Position;
                    end;
                end;
            end;
        end;
    end;

    local BodiesById = v114.BodiesById;
    table.clear(BodiesById);

    for _, v in p107 do
        BodiesById[v.Id] = v;
    end;

    local SupportsById = v114.SupportsById;
    table.clear(SupportsById);

    for i, v in SupportLowerById do
        local WorldVelocity = assert(BodiesById[v]).WorldVelocity;
        SupportsById[i] = {
            Kind = Enums.SupportKind.Player,
            SourceId = v,
            Anchor = assert(SupportAnchorById[i]),
            Velocity = Vector3.new(WorldVelocity.X, 0, WorldVelocity.Z)
        };
        local v141 = assert(BodiesById[i]);
        local Id = v141.Id;
        local v142;

        if v109.TraceBodyId == Id then
            v142 = v109.TraceRecorder;
        else
            local TraceRecordersById = v109.TraceRecordersById;

            if TraceRecordersById == nil then
                v142 = nil;
            else
                v142 = TraceRecordersById[Id];
            end;
        end;

        if v142 ~= nil then
            DeterminismTrace.vector(v142, "playerContacts.support", v141.Position, v141.WorldVelocity, 0, v, nil, "ReplicatedStorage.MovementV2.Simulation.PlayerContacts", debug.info(2, "l"));
        end;
    end;

    for _, v in p107 do
        local v143 = SupportLowerById[v.Id] or 0;
        local Id = v.Id;
        local v144;

        if v109.TraceBodyId == Id then
            v144 = v109.TraceRecorder;
        else
            local TraceRecordersById = v109.TraceRecordersById;

            if TraceRecordersById == nil then
                v144 = nil;
            else
                v144 = TraceRecordersById[Id];
            end;
        end;

        if v144 ~= nil then
            DeterminismTrace.vector(v144, "playerContacts.final", v.Position, v.WorldVelocity, v130, v143, nil, "ReplicatedStorage.MovementV2.Simulation.PlayerContacts", debug.info(2, "l"));
        end;
    end;

    return {
        Contacts = Contacts,
        SupportsById = SupportsById,
        UnresolvedCount = v130,
        SweptContactCount = v125
    };
end;

return table.freeze(u1);