-- ReplicatedStorage.Shared.WeaponConstructor.Bullet
-- Script path: ReplicatedStorage.Shared.WeaponConstructor.Bullet
-- Decompile time: 43.49 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CharacterModel = require(ReplicatedStorage.Shared.CharacterModel);
local UniformRandomStream = require(ReplicatedStorage.Shared.Utility.Math).UniformRandomStream;
local Color3_new_ret = Color3.new(1, 1, 1);
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.IgnoreWater = true;
local RaycastParams_new_ret2 = RaycastParams.new();
RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret2.IgnoreWater = true;
local table_create_ret = table.create(1);
local u2 = {
    [Enum.Material.Wood] = 3,
    [Enum.Material.WoodPlanks] = 3,
    [Enum.Material.Cardboard] = 3,
    [Enum.Material.Plastic] = 2,
    [Enum.Material.SmoothPlastic] = 2
};

local function ResolvePenetrationModifier(p3: any, p4: any, p5: number, p6: number) -- Line: 61
    -- upvalues: u2 (copy)
    local v7 = p3 == Enum.Material.Glass and 3 or (p5 + p6) / 2;

    if p3 == p4 then
        return u2[p4] or v7;
    end;

    return v7;
end;

local u8 = {};
local table_create_ret2 = table.create(1);
local u9 = nil;

local function InvalidateScanFilters() -- Line: 94
    -- upvalues: u8 (copy)
    table.clear(u8);
end;

local u10 = RunService:IsServer();
local u11 = u10 and workspace.CurrentCamera or workspace:WaitForChild("Characters", 30);
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = {};

local function ResolveSurface(p22: userdata, p23: any) -- Line: 122
    -- upvalues: u13 (ref)
    local MaterialPenetrationData = u13.MaterialPenetrationData;
    local v24 = u13.MaterialVariantPenetrationData[p22.MaterialVariant];

    if v24 then
        return v24.Material, v24.PenetrationModifier or MaterialPenetrationData[v24.Material].PenetrationModifier;
    end;

    return p23 or "Default", (p23 and MaterialPenetrationData[p23] or MaterialPenetrationData.Default).PenetrationModifier;
end;

local function ImpactMaterial(p25: userdata) -- Line: 136
    -- upvalues: u13 (ref)
    local v26 = u13.MaterialVariantPenetrationData[p25.MaterialVariant];

    return v26 and (v26.Impact or v26.Material) or p25.Material;
end;

local function RefreshConfig() -- Line: 142
    -- upvalues: u21 (copy), u12 (ref)
    u21.TeammateDamage = u12.Get("Damage", "Teammate");
    u21.HitboxMultipliers = u12.Get("Damage", "HitboxMultipliers");
    u21.DistanceFallOff = u12.Get("Weapon", "DistanceFallOff");
    u21.MinimumPenetrationStartDistance = u12.Get("Weapon", "MinimumPenetrationStartDistance");
    u21.MaxPenetrationDistance = u12.Get("Weapon", "MaxPenetrationDistance");
    u21.PenetrationLossDivisor = u12.Get("Weapon", "PenetrationLossDivisor");
    u21.KnifeCastBoxSize = u12.Get("Weapon", "KnifeCastBoxSize");
    u21.KnifeRewindSlack = u12.Get("Weapon", "KnifeRewindSlack");
    u21.MathHitboxes = u12.Get("LagCompensation", "MathHitboxes");
end;

local function RandomFloat(p27: any, p28: number, p29: number) -- Line: 160
    return p27(p28, p29);
end;

function u1.SpreadOffset(p30: any, p31: any, p32: number, p33: number, p34: number) -- Line: 165
    local Data = p30.Data;
    local v35 = p31(0, 1) * p32;
    local v36 = p31(0, 6.283185307179586);
    local v37 = p34 - 1 + math.floor(p30.RecoilIndex) * (Data.Bullets or 1);
    local v38, v39;

    if v37 < (Data.SpreadOffsetsLength or 0) then
        v38 = buffer.readf32(Data.SpreadOffsets, v37 * 8);
        v39 = buffer.readf32(Data.SpreadOffsets, v37 * 8 + 4);
    else
        v38 = p31(0, 6.283185307179586);
        v39 = p31(0, 1);
    end;

    local v40 = v39 * p33;
    local v41 = v35 * math.cos(v36);
    local v42 = v35 * math.sin(v36);
    local v43 = v40 * math.cos(v38);
    local v44 = v40 * math.sin(v38);

    return v41 + v43, v42 + v44, v41, v42, v43, v44;
end;

local function BuildScanFilter(p45: number, p46: string, p47: boolean?) -- Line: 188
    -- upvalues: u9 (ref), u8 (copy), table_create_ret2 (copy), u11 (copy), u14 (ref), Players (copy)
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Geometry");
    end;

    if u9 ~= Map then
        u9 = Map;
        table.clear(u8);
    end;

    if p47 then
        table_create_ret2[1] = Map;

        return table_create_ret2;
    end;

    local v48 = u8[p45];

    if v48 and v48.Team == p46 then
        return v48.Filter;
    end;

    local v49 = v48 and v48.Filter or {};
    u8[p45] = {
        Filter = v49,
        Team = p46
    };
    table.clear(v49);
    v49[1] = Map;

    for _, child in u11:GetChildren() do
        local v50 = tonumber(child.Name);
        local Entity = u14.GetEntity("Character", v50);

        if Entity then
            Entity = Players:GetPlayerByUserId(Entity.UserId);
        end;

        if v50 ~= p45 and not (Entity and Entity:GetAttribute("SpawnProtected")) then
            table.insert(v49, child);
        end;
    end;

    return v49;
end;

local function CharacterModelOf(p51: userdata) -- Line: 263
    -- upvalues: u11 (copy)
    while p51 and p51.Parent ~= u11 do
        p51 = p51.Parent;
    end;

    return p51;
end;

local function CharacterIdentifierOf(p52: userdata) -- Line: 273
    -- upvalues: u11 (copy)
    while p52 and p52.Parent ~= u11 do
        p52 = p52.Parent;
    end;

    if p52 then
        p52 = tonumber(p52.Name);
    end;

    return p52;
end;

local function MakeHole(p53: vector, p54: vector, p55: userdata?, p56: boolean, p57: boolean?, p58: number?) -- Line: 281
    -- upvalues: u11 (copy), u14 (ref), Players (copy), u13 (ref), Color3_new_ret (copy)
    local v59 = false;

    if p57 and p55.Name == "Head" then
        if not p58 then
            local v60 = p55;

            while p55 and p55.Parent ~= u11 do
                p55 = p55.Parent;
            end;

            if p55 then
                p58 = tonumber(p55.Name);
                p55 = v60;
            else
                p58 = p55;
                p55 = v60;
            end;
        end;

        if p58 then
            local Entity = u14.GetEntity("Character", p58);

            if Entity then
                local PlayerByUserId = Players:GetPlayerByUserId(Entity.UserId);

                if PlayerByUserId then
                    v59 = PlayerByUserId:GetAttribute("HasHelmet");
                end;
            end;
        end;
    end;

    local v61 = {
        Knife = p56
    };
    local v62;

    if p55 then
        local v63 = u13.MaterialVariantPenetrationData[p55.MaterialVariant];
        v62 = (v63 and (v63.Impact or v63.Material) or p55.Material).Value or 0;
    else
        v62 = 0;
    end;

    v61.Material = v62;
    v61.Position = p53;
    v61.Normal = p54;
    v61.Color = p55 and p55.Color or Color3_new_ret;
    v61.IsCharacter = p57;
    v61.IsHeadshot = p57 and p55.Name == "Head" and true or false;
    v61.HasHelmet = v59;

    return v61;
end;

local function AddCharacterHit(p64: table, p65: userdata, p66: table, p67: number?) -- Line: 329
    -- upvalues: u11 (copy)
    if not p67 then
        while p65 and p65.Parent ~= u11 do
            p65 = p65.Parent;
        end;

        if p65 then
            p67 = tonumber(p65.Name);
        else
            p67 = p65;
        end;
    end;

    if p67 and not p64[p67] then
        p64[p67] = p66;
    end;
end;

local function AppendCharacterHit(p68: any, p69: userdata, p70: any, p71: number?) -- Line: 341
    -- upvalues: u11 (copy)
    if not p71 then
        while p69 and p69.Parent ~= u11 do
            p69 = p69.Parent;
        end;

        if p69 then
            p71 = tonumber(p69.Name);
        else
            p71 = p69;
        end;
    end;

    if not p71 then
        return;
    end;

    local v72 = p68[p71];

    if v72 then
        table.insert(v72, p70);

        return;
    end;

    p68[p71] = { p70 };
end;

local function IsTeammate(p73: userdata, p74: string?, p75: number?) -- Line: 359
    -- upvalues: u21 (copy), u14 (ref), u11 (copy)
    if u21.TeammateDamage or not p74 then
        return false;
    end;

    local GetEntity = u14.GetEntity;

    if not p75 then
        while p73 and p73.Parent ~= u11 do
            p73 = p73.Parent;
        end;

        if p73 then
            p75 = tonumber(p73.Name);
        else
            p75 = p73;
        end;
    end;

    local v76 = GetEntity("Character", p75);
    local v77;

    if v76 == nil then
        v77 = false;
    else
        v77 = v76.Data.Team == p74;
    end;

    return v77;
end;

local u78 = nil;
local u79 = 0;
local u80 = {};
local u81 = {};
local table_freeze_ret = table.freeze({});
local u82 = {};

local function BuildClientHitboxSet(p83: number, p84: string?) -- Line: 424
    -- upvalues: CharacterModel (copy), u21 (copy), u11 (copy), u14 (ref), Players (copy), u82 (copy)
    local v85 = 0;
    local v86 = #CharacterModel.HitboxParts;

    if u21.TeammateDamage or not p84 then
        p84 = nil;
    end;

    for _, child in u11:GetChildren() do
        local v87 = tonumber(child.Name);

        if v87 and (v87 ~= p83 and child:IsA("Model")) then
            local Entity = u14.GetEntity("Character", v87);
            local v88;

            if Entity then
                v88 = Players:GetPlayerByUserId(Entity.UserId);
            else
                v88 = Entity;
            end;

            if not (v88 and v88:GetAttribute("SpawnProtected") or p84 and (Entity and Entity.Data.Team == p84)) then
                local PrimaryPart = child.PrimaryPart;
                local HitboxParts = CharacterModel.GetHitboxParts(child);
                local v89 = child;

                for i = 1, v86 do
                    local v90 = HitboxParts[i];
                    local v91;

                    if v90 then
                        local HitboxBox, v92 = CharacterModel.GetHitboxBox(v89, i, v90);
                        v85 = v85 + 1;
                        local v93 = u82[v85];

                        if not v93 then
                            v93 = {};
                            u82[v85] = v93;
                        end;

                        v93.Part = v90;
                        v93.Identifier = v87;
                        v93.CFrame = HitboxBox and v90.CFrame * HitboxBox or v90.CFrame;
                        local v94;

                        if PrimaryPart then
                            v94 = PrimaryPart.CFrame;
                        else
                            v94 = PrimaryPart;
                        end;

                        v93.Root = v94;
                        local Y = v92.Y;
                        local Z = v92.Z;
                        v93.HX = v92.X;
                        v93.HY = Y;
                        v93.HZ = Z;
                        v91 = i;
                    else
                        v91 = i;
                    end;
                end;
            end;
        end;
    end;

    return u82, v85;
end;

local u95 = {};
local u96 = {};
local table_freeze_ret2 = table.freeze({
    Head = 1,
    LowerTorso = 2,
    UpperTorso = 3,
    LeftUpperArm = 4,
    LeftLowerArm = 4,
    LeftHand = 4,
    RightUpperArm = 4,
    RightLowerArm = 4,
    RightHand = 4,
    LeftUpperLeg = 6,
    LeftLowerLeg = 6,
    LeftFoot = 6,
    RightUpperLeg = 6,
    RightLowerLeg = 6,
    RightFoot = 6
});
local table_create_ret3 = table.create(12, (1 / 0));
local table_create_ret4 = table.create(12, false);
local table_create_ret5 = table.create(12, 0);
local table_create_ret6 = table.create(12, Vector3.new(0, 0, 0));

local function KeepCrossing(p97: number, p98: number, p99: any, p100: number, p101: vector) -- Line: 537
    -- upvalues: table_create_ret3 (copy), table_create_ret4 (copy), table_create_ret5 (copy), table_create_ret6 (copy)
    if p98 < table_create_ret3[p97] then
        table_create_ret3[p97] = p98;
        table_create_ret4[p97] = p99;
        table_create_ret5[p97] = p100;
        table_create_ret6[p97] = p101;
    end;
end;

local function ResolveBody(p102: number) -- Line: 547
    -- upvalues: table_create_ret3 (copy), table_create_ret4 (copy)
    local v103 = table_create_ret3[p102 + 1];

    if table_create_ret3[p102 + 2] < v103 or table_create_ret3[p102 + 3] < v103 then
        table_create_ret4[p102 + 1] = false;
    end;

    for i = p102 + 1, p102 + 6 do
        if table_create_ret4[i] then
            return i;
        end;

        local _ = i;
    end;

    return nil;
end;

local function ClearBuckets() -- Line: 565
    -- upvalues: table_create_ret3 (copy), table_create_ret4 (copy)
    table_create_ret3[1] = (1 / 0);
    table_create_ret4[1] = false;
    table_create_ret3[2] = (1 / 0);
    table_create_ret4[2] = false;
    table_create_ret3[3] = (1 / 0);
    table_create_ret4[3] = false;
    table_create_ret3[4] = (1 / 0);
    table_create_ret4[4] = false;
    table_create_ret3[5] = (1 / 0);
    table_create_ret4[5] = false;
    table_create_ret3[6] = (1 / 0);
    table_create_ret4[6] = false;
    table_create_ret3[7] = (1 / 0);
    table_create_ret4[7] = false;
    table_create_ret3[8] = (1 / 0);
    table_create_ret4[8] = false;
    table_create_ret3[9] = (1 / 0);
    table_create_ret4[9] = false;
    table_create_ret3[10] = (1 / 0);
    table_create_ret4[10] = false;
    table_create_ret3[11] = (1 / 0);
    table_create_ret4[11] = false;
    table_create_ret3[12] = (1 / 0);
    table_create_ret4[12] = false;
end;

local function TraceHitboxes(p104: vector, p105: vector, p106: number, p107: any, p108: number?, p109: number?) -- Line: 578
    -- upvalues: u78 (ref), u79 (ref), u80 (copy), ResolveBody (copy), table_create_ret3 (copy), table_create_ret4 (copy), table_create_ret5 (copy), table_create_ret6 (copy), ClearBuckets (copy), u19 (ref), table_freeze_ret2 (copy)
    if not u78 or u79 == 0 then
        return nil;
    end;

    local v110 = p108 or 0;
    local v111 = p109 or 1;
    local v112 = v110 > 0;
    local v113 = v111 > 1;
    local v114 = p106 / v111;
    local v115 = nil;
    local v116 = nil;
    local v117 = nil;
    local v118 = nil;
    local v119 = nil;

    for i = 1, u79 + 1 do
        local v120;

        if i <= u79 then
            v120 = u78[i] or nil;
        else
            v120 = nil;
        end;

        local v121;

        if v120 then
            v121 = v120.Identifier;
        else
            v121 = v120;
        end;

        local v122;

        if v120 and u80[v121] then
            v122 = i;
        else
            if v121 == v119 then
                v121 = v119;
            elseif v119 ~= nil then
                local v123 = ResolveBody(0);

                if v123 and table_create_ret3[v123] * v111 < p106 then
                    p106 = table_create_ret3[v123] * v111;
                    v116 = table_create_ret3[v123];
                    v115 = table_create_ret4[v123];
                    v118 = table_create_ret5[v123];
                    v117 = table_create_ret6[v123];
                end;

                local v124 = v113 and ResolveBody(6) or nil;

                if v124 and table_create_ret3[v124] < p106 then
                    p106 = table_create_ret3[v124];
                    v116 = table_create_ret3[v124];
                    v115 = table_create_ret4[v124];
                    v118 = table_create_ret5[v124];
                    v117 = table_create_ret6[v124];
                end;

                ClearBuckets();
            end;

            if not v120 then
                break;
            end;

            local CFrame = v120.CFrame;
            local v125 = CFrame:PointToObjectSpace(p104);
            local v126 = CFrame:VectorToObjectSpace(p105);
            local v127, v128, v129, v130, v131 = u19.SegmentBox(v125.X, v125.Y, v125.Z, v126.X, v126.Y, v126.Z, v120.HX + v110, v120.HY + v110, v120.HZ + v110);

            if v127 then
                local v132 = v127 < 0 and 0 or v127;
                local v133 = v112 and 1 or (table_freeze_ret2[v120.Part.Name] or 5);
                local vector_create_ret = vector.create(v129, v130, v131);

                if v132 < v114 and v132 < table_create_ret3[v133] then
                    table_create_ret3[v133] = v132;
                    table_create_ret4[v133] = v120;
                    table_create_ret5[v133] = v128;
                    table_create_ret6[v133] = vector_create_ret;
                end;

                if v113 then
                    local v134 = 6 + v133;

                    if v132 < table_create_ret3[v134] then
                        table_create_ret3[v134] = v132;
                        table_create_ret4[v134] = v120;
                        table_create_ret5[v134] = v128;
                        table_create_ret6[v134] = vector_create_ret;
                        v119 = v121;
                        v122 = i;
                    else
                        v119 = v121;
                        v122 = i;
                    end;
                else
                    v119 = v121;
                    v122 = i;
                end;
            else
                v119 = v121;
                v122 = i;
            end;
        end;
    end;

    if not v115 then
        return nil;
    end;

    local Part = v115.Part;
    p107.Instance = Part;
    p107.Position = p104 + p105 * v116;
    p107.Normal = v115.CFrame:VectorToWorldSpace(v117);
    p107.Material = Part.Material;
    p107.Distance = vector.magnitude(p105) * v116;
    p107.IsCharacter = true;
    p107.Identifier = v115.Identifier;
    p107.Root = v115.Root;
    p107.ExitPosition = p104 + p105 * math.min(v118, 1);

    return p107;
end;

local RaycastParams_new_ret3 = RaycastParams.new();
RaycastParams_new_ret3.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret3.IgnoreWater = true;
local u135 = {};

local function TraceBullet(p136: vector, p137: vector, p138: any, p139: number?, p140: table?) -- Line: 732
    -- upvalues: u78 (ref), RaycastParams_new_ret (copy), u11 (copy), u135 (copy), RaycastParams_new_ret3 (copy), TraceHitboxes (copy)
    local vector_magnitude_ret = vector.magnitude(p137);
    local v141;

    if p139 and vector_magnitude_ret > 0 then
        v141 = p137 * ((vector_magnitude_ret + p139) / vector_magnitude_ret) or p137;
    else
        v141 = p137;
    end;

    if u78 then
        local v142 = workspace:Raycast(p136, p137, RaycastParams_new_ret);

        if vector_magnitude_ret <= 0 then
            return v142, false;
        end;

        local v143 = TraceHitboxes(p136, v141, v142 and (v142.Distance / vector_magnitude_ret or 1) or 1, p138, nil, p139 and (vector_magnitude_ret + p139) / vector_magnitude_ret or nil);

        if v143 then
            return v143, true;
        end;

        return v142, false;
    end;

    local v144 = workspace:Raycast(p136, v141, RaycastParams_new_ret);

    if not (v144 and (p139 and not v144.Instance:IsDescendantOf(u11))) then
        return v144, false;
    end;

    local v145 = v144.Distance <= vector_magnitude_ret;
    local v146 = v145 and v144.Distance * (vector_magnitude_ret + p139) / vector_magnitude_ret or vector_magnitude_ret + p139;

    if p140 and #p140 > 1 then
        table.clear(u135);
        table.move(p140, 2, #p140, 1, u135);
        RaycastParams_new_ret3.FilterDescendantsInstances = u135;
        local v147 = workspace:Raycast(p136, p137 * (v146 / vector_magnitude_ret), RaycastParams_new_ret3);

        if v147 then
            return v147, false;
        end;
    end;

    return v145 and v144 and v144 or nil, false;
end;

local u148 = {};
local u149 = {};
local u150 = {};

local function TraceToExit(p151: vector, p152: vector, p153: number, p154: userdata) -- Line: 810
    -- upvalues: table_create_ret (copy), RaycastParams_new_ret2 (copy), u148 (copy), u149 (copy), u150 (copy)
    table_create_ret[1] = p154;
    RaycastParams_new_ret2.FilterDescendantsInstances = table_create_ret;
    local v155 = math.floor(p153 / 0.2776) + 1;
    local v156 = v155 * 0.2776;
    local v157 = 0.001;
    local v158 = 0;

    for i = 1, 16 do
        local v159 = workspace:Raycast(p151 + p152 * v157, p152 * (v156 - v157), RaycastParams_new_ret2);

        if not v159 then
            break;
        end;

        local v160 = v157 + v159.Distance;
        v158 = v158 + 1;
        u148[v158] = v160;
        v157 = v160 + 0.001;

        if v156 <= v157 then
            break;
        end;

        local _ = i;
    end;

    local v161 = 0;

    for i = 1, 16 do
        local v162 = v156 > 0.001 and workspace:Raycast(p151 + p152 * v156, p152 * -(v156 - 0.001), RaycastParams_new_ret2);

        if not v162 then
            break;
        end;

        local v163 = v156 - v162.Distance;
        v161 = v161 + 1;
        u149[v161] = v163;
        u150[v161] = v162;
        v156 = v163 - 0.001;
        local _ = i;
    end;

    local v164 = 1;
    local v165 = 1;
    local v166 = nil;

    for i = 1, v155 do
        local v167 = i * 0.2776;
        local _ = i;

        while v164 <= v158 and u148[v164] <= v167 do
            v165 = v165 + 1;
            v164 = v164 + 1;
        end;

        while v161 >= 1 and u149[v161] <= v167 do
            v165 = v165 - 1;
            v166 = u150[v161];
            v161 = v161 - 1;
        end;

        if v165 <= 0 then
            break;
        end;
    end;

    table.clear(u150);

    return v165 <= 0 and v166 and v166 or nil;
end;

local function PerformHitScan(p168: any, p169: vector, p170: vector, p171: any, p172: any, p173: any, p174: string?, p175: number?, p176: any) -- Line: 891
    -- upvalues: RaycastParams_new_ret (copy), u80 (copy), u21 (copy), TraceBullet (copy), u95 (copy), u10 (copy), u16 (ref), u14 (ref), u11 (copy), MakeHole (copy), u15 (ref), u81 (copy), u13 (ref), u96 (copy), TraceToExit (copy), u2 (copy)
    local Data = p168.Data;
    RaycastParams_new_ret.FilterDescendantsInstances = p176;
    table.clear(u80);
    local Damage = Data.Damage;
    local Penetration = Data.Penetration;
    local Range = Data.Range;
    local RangeModifier = Data.RangeModifier;
    local v177 = Data.HitboxMultipliers or u21.HitboxMultipliers;
    local DistanceFallOff = u21.DistanceFallOff;
    local MinimumPenetrationStartDistance = u21.MinimumPenetrationStartDistance;
    local MaxPenetrationDistance = u21.MaxPenetrationDistance;
    local PenetrationLossDivisor = u21.PenetrationLossDivisor;
    local v178 = {
        StartPosition = p169,
        EndPosition = p169
    };
    table.insert(p172, v178);
    local v179 = p176;
    local v180 = 0;
    local v181 = 4;
    local v182 = 0;

    while Damage > 0 do
        local v183 = p169 + p170 * (Range - v180);
        local v184, v185 = TraceBullet(p169, v183 - p169, u95, 2.7760000000000002, p176);

        if u10 then
            local v186 = v184 and v184.Distance or vector.magnitude(v183 - p169);
            u16.PushDroppedWeapons(u14.GetAllCategoryEntities("DroppedWeapon"), p169, p170, v186, p175);
        end;

        if not v184 then
            v178.EndPosition = v183;
            break;
        end;

        local Instance = v184.Instance;
        local Position = v184.Position;
        local Material = v184.Material;
        local v187 = v185 or Instance:IsDescendantOf(u11);
        local vector_magnitude_ret = vector.magnitude(Position - p169);

        if v187 then
            local v188 = Range - v180;
            vector_magnitude_ret = vector_magnitude_ret * (v188 / (v188 + 2.7760000000000002));
        end;

        v180 = v180 + vector_magnitude_ret;
        local v189 = Damage * RangeModifier ^ (v180 / DistanceFallOff);
        v178.EndPosition = Position;

        if v187 then
            local v190;

            if v185 then
                v190 = v184.Identifier or nil;
            else
                v190 = nil;
            end;

            local v191;

            if u21.TeammateDamage or not p174 then
                v191 = false;
            else
                local GetEntity = u14.GetEntity;

                if not v190 then
                    v190 = Instance;

                    while v190 and v190.Parent ~= u11 do
                        v190 = v190.Parent;
                    end;

                    if v190 then
                        v190 = tonumber(v190.Name);
                    end;
                end;

                local v192 = GetEntity("Character", v190);

                if v192 == nil then
                    v191 = false;
                elseif v192.Data.Team == p174 then
                    v191 = true;
                else
                    v191 = false;
                end;
            end;

            if v191 then
                break;
            end;
        end;

        local v193;

        if v187 then
            v193 = -p170;
        else
            v193 = v184.Normal;
        end;

        local v194;

        if v185 then
            v194 = v184.Identifier or nil;
        else
            v194 = nil;
        end;

        local v195 = MakeHole(Position, v193, Instance, false, v187, v194);
        table.insert(p171, v195);

        if u10 and (not v187 and u15.IsBreakable(Instance)) then
            table.insert(u81, Instance);
            table.insert(u81, Position);
        end;

        if Instance.Name == "nowallbang" then
            break;
        end;

        if v187 then
            local v196 = {
                Damage = v189 * (v177 and v177[Instance.Name] or (u21.HitboxMultipliers[Instance.Name] or 1)),
                DamageType = "Bullet",
                Object = Instance,
                Penetration = v182 > 0,
                Direction = p170,
                Position = Position
            };
            local v197;

            if v185 then
                v197 = v184.Identifier or nil;
            else
                v197 = nil;
            end;

            if not v197 then
                v197 = Instance;

                while v197 and v197.Parent ~= u11 do
                    v197 = v197.Parent;
                end;

                if v197 then
                    v197 = tonumber(v197.Name);
                end;
            end;

            if v197 then
                local v198 = p173[v197];

                if v198 then
                    table.insert(v198, v196);
                else
                    p173[v197] = { v196 };
                end;
            end;
        end;

        local MaterialPenetrationData = u13.MaterialPenetrationData;
        local v199 = u13.MaterialVariantPenetrationData[Instance.MaterialVariant];
        local v200, v201;

        if v199 then
            v200 = v199.Material;
            v201 = v199.PenetrationModifier or MaterialPenetrationData[v199.Material].PenetrationModifier;
        else
            v201 = (Material and MaterialPenetrationData[Material] or MaterialPenetrationData.Default).PenetrationModifier;
            v200 = Material or "Default";
        end;

        if v181 <= 0 or (MinimumPenetrationStartDistance < v180 or (v201 < 0.1 or Penetration <= 0)) then
            break;
        end;

        local v202;

        if v185 then
            u96.Instance = Instance;
            u96.Position = v184.ExitPosition;
            u96.Normal = -v184.Normal;
            u96.Material = v184.Material;
            u96.IsCharacter = true;
            u96.Identifier = v184.Identifier;
            v202 = u96;
        else
            v202 = TraceToExit(Position, p170, MaxPenetrationDistance, v187 and Instance and Instance or v179[1]);
        end;

        if not v202 then
            break;
        end;

        local Material2 = v202.Material;
        local MaterialPenetrationData2 = u13.MaterialPenetrationData;
        local v203 = u13.MaterialVariantPenetrationData[v202.Instance.MaterialVariant];
        local v204, v205;

        if v203 then
            v204 = v203.Material;
            v205 = v203.PenetrationModifier or MaterialPenetrationData2[v203.Material].PenetrationModifier;
        else
            v205 = (Material2 and MaterialPenetrationData2[Material2] or MaterialPenetrationData2.Default).PenetrationModifier;
            v204 = Material2 or "Default";
        end;

        local v206 = v200 == Enum.Material.Glass and 3 or (v201 + v205) / 2;

        if v200 == v204 then
            v206 = u2[v204] or v206;
        end;

        local Instance2 = v202.Instance;
        p169 = v202.Position;
        local vector_magnitude_ret2 = vector.magnitude(p169 - Position);
        local v207 = 1 / v206;
        local v208 = v189 * (v200 == Enum.Material.Glass and 0.05 or 0.16) + math.max(0, 3 / Penetration * 1.25) * (v207 * 3) + v207 * vector_magnitude_ret2 * vector_magnitude_ret2 / PenetrationLossDivisor;
        Damage = v189 - math.max(0, v208);

        if Damage < 1 then
            break;
        end;

        local v209 = v185 or Instance2:IsDescendantOf(u11);

        if v209 then
            local v210;

            if v185 then
                v210 = v184.Identifier or nil;
            else
                v210 = nil;
            end;

            local v211;

            if u21.TeammateDamage or not p174 then
                v211 = false;
            else
                local GetEntity = u14.GetEntity;

                if not v210 then
                    v210 = Instance2;

                    while v210 and v210.Parent ~= u11 do
                        v210 = v210.Parent;
                    end;

                    if v210 then
                        v210 = tonumber(v210.Name);
                    end;
                end;

                local v212 = GetEntity("Character", v210);

                if v212 == nil then
                    v211 = false;
                elseif v212.Data.Team == p174 then
                    v211 = true;
                else
                    v211 = false;
                end;
            end;

            if v211 then
                break;
            end;
        end;

        local v213;

        if v209 then
            v213 = -p170;
        else
            v213 = v202.Normal;
        end;

        local v214;

        if v185 then
            v214 = v184.Identifier or nil;
        else
            v214 = nil;
        end;

        local v215 = MakeHole(p169, v213, Instance2, false, v209, v214);
        table.insert(p171, v215);
        v182 = v182 + 1;
        v181 = v181 - 1;
        table.clear(u80);
        local v216;

        if v187 then
            if v185 then
                u80[v184.Identifier] = true;
                v216 = v179;
            else
                local v217 = v179;
                local v218 = v217;
                local v219 = v217;
                v217 = v218;
                v219 = v218;

                while Instance and Instance.Parent ~= u11 do
                    Instance = Instance.Parent;
                end;

                local table_find_ret = table.find(v218, Instance);

                if table_find_ret then
                    local table_clone_ret = table.clone(v179);
                    table.remove(table_clone_ret, table_find_ret);
                    v216 = v179;
                    v179 = table_clone_ret;
                else
                    v216 = v179;
                    v179 = v217;
                end;
            end;
        else
            v216 = v179;
        end;

        if v179 == p176 then
            v179 = p176;
        else
            RaycastParams_new_ret.FilterDescendantsInstances = v179;
        end;

        p176 = v179;
        v179 = v216;
    end;

    for i = 1, #u81, 2 do
        u15.Hit(u81[i], u81[i + 1]);
        local _ = i;
    end;

    table.clear(u81);
end;

function u1.new(p220, p221, p222, p223) -- Line: 1177
    -- upvalues: u78 (ref), u79 (ref), u10 (copy), u21 (copy), u14 (ref), table_freeze_ret (copy), BuildClientHitboxSet (copy), u20 (ref), UniformRandomStream (copy), BuildScanFilter (copy), u1 (copy), PerformHitScan (copy), u17 (ref), u18 (ref)
    local Simulation = p220.Simulation;
    local Data = p221.Data;
    local v224 = Simulation:BuildShotCFrame(true);
    local Position = v224.Position;
    local LookVector = v224.LookVector;
    local RightVector = v224.RightVector;
    local UpVector = v224.UpVector;
    u78 = nil;
    u79 = 0;

    if u10 then
        if u21.MathHitboxes then
            local v225, v226 = u14.BuildHitboxSet(p220.PlayerInstance, p222, Position, LookVector, nil, Simulation.Team);
            u78 = v225;
            u79 = v226;
            u78 = u78 or table_freeze_ret;
        else
            u14.PushEntitiesToTime("Character", p220.PlayerInstance, p222, Position, LookVector, nil, Simulation.Team);
        end;
    elseif u21.MathHitboxes then
        local v227, v228 = BuildClientHitboxSet(Simulation.Identifier, Simulation.Team);
        u78 = v227;
        u79 = v228;
    end;

    local Inaccuracy = p221:GetInaccuracy(Simulation);
    local Spread = p221:GetSpread(p221);
    local v229;

    if u10 and u20 then
        p223, v229 = u20.Resolve(p220, p221, p223, v224, Inaccuracy, Spread, u78, u79);
    else
        v229 = false;
    end;

    local v230 = UniformRandomStream(p223);
    local v231 = BuildScanFilter(Simulation.Identifier, Simulation.Team, u78 ~= nil);
    local v232 = {};
    local v233 = {};
    local v234 = {};

    for i = 1, Data.Bullets or 1 do
        local v235, v236 = u1.SpreadOffset(p221, v230, Inaccuracy, Spread, i);
        PerformHitScan(p221, Position, vector.normalize(LookVector + v235 * RightVector + v236 * UpVector), v232, v233, v234, Simulation.Team, p222, v231);
        local _ = i;
    end;

    if u10 then
        if u17 and u17.IsServerShots(p220.PlayerInstance) then
            local v237 = {};
            local v238 = nil;

            for _, v in v234 do
                for _, v2 in v[1] and v and v or { v } do
                    if v2.Object then
                        v237[v2.Object] = true;
                    end;

                    if v2.Position and not v238 then
                        v238 = v2.Position;
                    end;
                end;
            end;

            local v239 = u78;
            local v240 = u79;

            if not v239 then
                v239, v240 = u14.GetRewindDebugData();
            end;

            u17.BroadcastServerShot(p220.PlayerInstance, v238, v239, v240, v237);
        end;

        if not u78 then
            u14.Backup();
        end;

        u78 = nil;
        u79 = 0;
    elseif u18 then
        u18.AddClientBodies(Simulation.Identifier);
    end;

    local v241;

    if type(Data.TracerFrequency) == "table" then
        v241 = Data.TracerFrequency[p221.Mode];
    else
        v241 = Data.TracerFrequency;
    end;

    local v242 = v241 or 1;

    if v242 == 0 or not p221:GetSetting("Game", "Graphics & Visuals", "Tracer Every Bullet", false) and (Data.ClipSize - Data.Ammo) % v242 ~= 0 then
        table.clear(v233);
    end;

    return v232, v233, v234, v229;
end;

function u1.Knife(p243, p244, p245, p246, p247, p248, p249) -- Line: 1359
    -- upvalues: u78 (ref), u79 (ref), u21 (copy), u10 (copy), u14 (ref), table_freeze_ret (copy), BuildClientHitboxSet (copy), u80 (copy), RaycastParams_new_ret (copy), BuildScanFilter (copy), TraceBullet (copy), u95 (copy), u11 (copy), TraceHitboxes (copy), u96 (copy), u17 (ref), u18 (ref), u15 (ref), MakeHole (copy)
    local Simulation = p243.Simulation;
    local v250 = Simulation:BuildShotCFrame(false);
    u78 = nil;
    u79 = 0;
    local v251 = p244 + u21.KnifeRewindSlack;

    if u10 then
        if u21.MathHitboxes then
            local v252, v253 = u14.BuildHitboxSet(p243.PlayerInstance, p249, v250.Position, v250.LookVector, v251, Simulation.Team);
            u78 = v252;
            u79 = v253;
            u78 = u78 or table_freeze_ret;
        else
            u14.PushEntitiesToTime("Character", p243.PlayerInstance, p249, v250.Position, v250.LookVector, nil, Simulation.Team, v251);
        end;
    elseif u21.MathHitboxes then
        local v254, v255 = BuildClientHitboxSet(Simulation.Identifier, Simulation.Team);
        u78 = v254;
        u79 = v255;
    end;

    table.clear(u80);
    RaycastParams_new_ret.FilterDescendantsInstances = BuildScanFilter(Simulation.Identifier, Simulation.Team, u78 ~= nil);
    local v256 = v250.LookVector * p244;
    local v257, v258 = TraceBullet(v250.Position, v256, u95);

    if not (v257 and (v258 or v257.Instance:IsDescendantOf(u11))) then
        if u78 then
            local vector_magnitude_ret = vector.magnitude(v256);

            if vector_magnitude_ret > 0 then
                local v259 = TraceHitboxes(v250.Position, v256, v257 and (v257.Distance / vector_magnitude_ret or 1) or 1, u96, 0.625);

                if v259 then
                    v257 = v259;
                    v258 = true;
                end;
            end;
        else
            local v260 = workspace:Spherecast(v250.Position, 0.625, v256, RaycastParams_new_ret);

            if v260 and (v260.Instance:IsDescendantOf(u11) and (not v257 or v260.Distance <= v257.Distance)) then
                v257 = v260;
            end;
        end;
    end;

    if u10 and (u17 and u17.IsServerShots(p243.PlayerInstance)) then
        local v261 = u78;
        local v262 = u79;

        if not v261 then
            v261, v262 = u14.GetRewindDebugData();
        end;

        local v263;

        if v257 then
            if v258 then
                v263 = v257.Instance;
            else
                v263 = v258;
            end;
        else
            v263 = v257;
        end;

        local v264;

        if v263 then
            v264 = v257.Position or nil;
        else
            v264 = nil;
        end;

        u17.BroadcastServerShot(p243.PlayerInstance, v264, v261, v262, v263 and {
            [v263] = true
        } or nil);
    elseif not u10 and u18 then
        u18.AddClientBodies(Simulation.Identifier);
    end;

    local function Restore() -- Line: 1483
        -- upvalues: u10 (ref), u78 (ref), u14 (ref), u79 (ref)
        if u10 and not u78 then
            u14.Backup();
        end;

        u78 = nil;
        u79 = 0;
    end;

    if not v257 then
        if u10 and not u78 then
            u14.Backup();
        end;

        u78 = nil;
        u79 = 0;

        return false, nil, nil;
    end;

    local v265 = false;
    local Instance = v257.Instance;
    local v266 = v258 or Instance:IsDescendantOf(u11);

    if u10 and not v266 then
        u15.Hit(Instance, v257.Position);
    end;

    if v266 then
        local Team = Simulation.Team;
        local v267;

        if v258 then
            v267 = v257.Identifier or nil;
        else
            v267 = nil;
        end;

        local v268;

        if u21.TeammateDamage or not Team then
            v268 = false;
        else
            local GetEntity = u14.GetEntity;

            if not v267 then
                local v269 = Instance;

                while Instance and Instance.Parent ~= u11 do
                    Instance = Instance.Parent;
                end;

                if Instance then
                    v267 = tonumber(Instance.Name);
                    Instance = v269;
                else
                    v267 = Instance;
                    Instance = v269;
                end;
            end;

            local v270 = GetEntity("Character", v267);

            if v270 == nil then
                v268 = false;
            elseif v270.Data.Team == Team then
                v268 = true;
            else
                v268 = false;
            end;
        end;

        if v268 then
            if u10 and not u78 then
                u14.Backup();
            end;

            u78 = nil;
            u79 = 0;

            return false, nil, nil;
        end;
    end;

    if v266 then
        local v271;

        if v258 then
            v271 = v257.Root;
        else
            v271 = v258;
        end;

        local v272 = v271 or Instance.Parent.PrimaryPart.CFrame;
        local v273 = (v272.Position - Simulation.Position) * Vector3.new(1, 0, 1);
        local vector_magnitude_ret = vector.magnitude(v273);

        if vector_magnitude_ret > 0 then
            v273 = v273 / vector_magnitude_ret;
        end;

        local v274 = v272.LookVector * Vector3.new(1, 0, 1);
        local vector_magnitude_ret2 = vector.magnitude(v274);

        if vector_magnitude_ret2 > 0 then
            v274 = v274 / vector_magnitude_ret2;
        end;

        v265 = vector.dot(v273, v274) > 0.475 and true or v265;
    end;

    local v275 = {};
    local v276 = p247 and (v265 and 180 or 65) or (v265 and 90 or (p248 and 40 or 25));

    if v266 then
        local v277 = {
            Damage = v276,
            DamageType = "Slash",
            Object = Instance,
            Direction = v250.LookVector,
            Position = v257.Position
        };
        local v278;

        if v258 then
            v278 = v257.Identifier or nil;
        else
            v278 = nil;
        end;

        if not v278 then
            local v279 = Instance;

            while Instance and Instance.Parent ~= u11 do
                Instance = Instance.Parent;
            end;

            if Instance then
                v278 = tonumber(Instance.Name);
                Instance = v279;
            else
                v278 = Instance;
                Instance = v279;
            end;
        end;

        if v278 and not v275[v278] then
            v275[v278] = v277;
        end;
    end;

    local v280 = MakeHole(v257.Position, v257.Normal, Instance, true, v266, v258 and v257.Identifier or nil);

    if u10 and not u78 then
        u14.Backup();
    end;

    u78 = nil;
    u79 = 0;

    return true, { v280 }, v275;
end;

function u1.Init(p281) -- Line: 1605
    -- upvalues: u12 (ref), u14 (ref), u13 (ref), u15 (ref), u19 (ref), u10 (copy), u20 (ref), u16 (ref), u17 (ref), u18 (ref), ReplicatedStorage (copy), RefreshConfig (copy), u11 (copy), InvalidateScanFilters (copy), Players (copy)
    u12 = p281:GetModule("GameConfiguration");
    u14 = p281:GetModule("Entities");
    u13 = p281:GetModule("Enums");
    u15 = p281:GetModule("Breakables");
    u19 = p281:GetModule("CollisionMath");

    if u10 then
        u20 = p281:GetModule("SpreadGuard");
    end;

    u16 = p281:GetModule("DroppedPhysics");
    u17 = p281:GetModule("ShotDebug");
    u18 = u10 or p281:GetModule("DebugVisualizers");

    if not u18 then
        pcall(function() -- Line: 1625
            -- upvalues: u18 (ref), ReplicatedStorage (ref)
            u18 = require(ReplicatedStorage.ClientModules.DebugVisualizers);
        end);
    end;

    RefreshConfig();
    u12.Updated:Connect(RefreshConfig);
    u11.ChildAdded:Connect(InvalidateScanFilters);
    u11.ChildRemoved:Connect(InvalidateScanFilters);

    local function WatchSpawnProtection(p282) -- Line: 1637
        -- upvalues: InvalidateScanFilters (ref)
        p282:GetAttributeChangedSignal("SpawnProtected"):Connect(InvalidateScanFilters);
    end;

    for _, v in Players:GetPlayers() do
        v:GetAttributeChangedSignal("SpawnProtected"):Connect(InvalidateScanFilters);
    end;

    Players.PlayerAdded:Connect(WatchSpawnProtection);
end;

return u1;