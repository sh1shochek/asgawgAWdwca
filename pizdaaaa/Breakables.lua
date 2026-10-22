-- ReplicatedStorage.Shared.Breakables
-- Script path: ReplicatedStorage.Shared.Breakables
-- Decompile time: 16.24 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = RunService:IsServer();
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local table_create_ret = table.create(256);

local function BuildSurface(p13: userdata) -- Line: 100
    local CFrame2 = p13.CFrame;
    local Size = p13.Size;
    local v14 = { Size.X, Size.Y, Size.Z };
    local v15 = { CFrame2.XVector, CFrame2.YVector, CFrame2.ZVector };
    local v16 = 1;
    local v17 = v14[2] < v14[v16] and 2 or v16;
    local v18 = v14[3] < v14[v17] and 3 or v17;
    local v19 = v18 % 3 + 1;
    local v20 = v19 % 3 + 1;

    if math.abs(v15[v20].Y) <= math.abs(v15[v19].Y) then
        local v21 = v19;
        v19 = v20;
        v20 = v21;
    end;

    local v22 = v15[v20];

    if v22.Y < 0 then
        v22 = -v22;
    end;

    local v23 = v15[v19];
    local v24 = v14[v19];
    local v25 = v14[v20];
    local v26 = (p13:GetAttribute("PaneSize") or 12) * 0.0694;
    local math_floor_ret = math.floor(v24 / v26);
    local math_clamp_ret = math.clamp(math_floor_ret, 1, 16);
    local math_floor_ret2 = math.floor(v25 / v26);
    local math_clamp_ret2 = math.clamp(math_floor_ret2, 1, 16);
    local v27 = v24 / math_clamp_ret;
    local v28 = v25 / math_clamp_ret2;
    local v29 = {
        0,
        0,
        0,
        [v19] = v27,
        [v20] = v28,
        [v18] = v14[v18]
    };
    local v30 = math_clamp_ret * math_clamp_ret2;

    return {
        BrokenCount = 0,
        Broken = false,
        Think = false,
        Changed = false,
        Panes = nil,
        Folder = nil,
        LastPaneSound = 0,
        Part = p13,
        Wide = math_clamp_ret,
        High = math_clamp_ret2,
        PaneWidth = v27,
        PaneHeight = v28,
        PaneSize = vector.create(v29[1], v29[2], v29[3]),
        Normal = v15[v18],
        WidthAxis = v23,
        HeightAxis = v22,
        HalfThickness = v14[v18] * 0.5,
        Rotation = CFrame2.Rotation,
        Corner = CFrame2.Position - v23 * (v24 * 0.5) - v22 * (v25 * 0.5),
        Support = table.create(v30, 1),
        Bits = table.create(v30, "0"),
        Fragility = p13:GetAttribute("Fragility") or 100,
        BreakSound = p13:GetAttribute("BreakSound") or "Impacts.Glass.GlassLargesheetBreak",
        PaneSound = p13:GetAttribute("PaneSound") or "Impacts.Glass.GlassImpactHard",
        CanCollide = p13.CanCollide,
        CanQuery = p13.CanQuery,
        Transparency = p13.Transparency
    };
end;

local function PanePos(p31: any, p32: vector) -- Line: 191
    local v33 = p32 - p31.Corner;

    return vector.dot(v33, p31.WidthAxis) / p31.PaneWidth, vector.dot(v33, p31.HeightAxis) / p31.PaneHeight;
end;

local function PaneCentre(p34: any, p35: number, p36: number) -- Line: 198
    return p34.Corner + p34.WidthAxis * ((p35 + 0.5) * p34.PaneWidth) + p34.HeightAxis * ((p36 + 0.5) * p34.PaneHeight);
end;

local function IsBroken(p37: any, p38: number, p39: number) -- Line: 205
    return (p38 < 0 or (p37.Wide <= p38 or (p39 < 0 or p37.High <= p39))) and true or p37.Support[p38 + p39 * p37.Wide + 1] == -1;
end;

local function GetSupport(p40: any, p41: number, p42: number) -- Line: 213
    local v43 = p40.Support[p41 + p42 * p40.Wide + 1];

    return v43 > 0 and v43 and v43 or 0;
end;

local function SetSupport(p44: any, p45: number, p46: number, p47: number) -- Line: 219
    local v48 = p45 + p46 * p44.Wide + 1;
    p44.Support[v48] = p47;
    local v49 = p47 < 0 and "1" or "0";

    if p44.Bits[v48] ~= v49 then
        p44.Bits[v48] = v49;
        p44.Changed = true;
    end;
end;

local function RecalcSupport(p50: any, p51: number, p52: number) -- Line: 235
    local Wide = p50.Wide;
    local High = p50.High;
    local v53;

    if p52 == High - 1 then
        v53 = 1;
    else
        local v54 = p50.Support[p51 + (p52 + 1) * p50.Wide + 1];
        v53 = v54 > 0 and v54 and v54 or 0;
    end;

    local v55;

    if p52 == 0 then
        v55 = 1.25;
    else
        local v56 = p50.Support[p51 + (p52 - 1) * p50.Wide + 1];
        v55 = (v56 > 0 and v56 and v56 or 0) * 1.25;
    end;

    local v57;

    if p51 == 0 then
        v57 = 1;
    else
        local v58 = p50.Support[p51 - 1 + p52 * p50.Wide + 1];
        v57 = v58 > 0 and v58 and v58 or 0;
    end;

    local v59;

    if p51 == Wide - 1 then
        v59 = 1;
    else
        local v60 = p50.Support[p51 + 1 + p52 * p50.Wide + 1];
        v59 = v60 > 0 and v60 and v60 or 0;
    end;

    local v61;

    if p52 == 0 or p51 == 0 then
        v61 = 1;
    else
        local v62 = p50.Support[p51 - 1 + (p52 - 1) * p50.Wide + 1];
        v61 = v62 > 0 and v62 and v62 or 0;
    end;

    local v63;

    if p52 == 0 or p51 == Wide - 1 then
        v63 = 1;
    else
        local v64 = p50.Support[p51 + 1 + (p52 - 1) * p50.Wide + 1];
        v63 = v64 > 0 and v64 and v64 or 0;
    end;

    local v65;

    if p52 == High - 1 or p51 == Wide - 1 then
        v65 = 0.25;
    else
        local v66 = p50.Support[p51 + 1 + (p52 + 1) * p50.Wide + 1];
        v65 = (v66 > 0 and v66 and v66 or 0) * 0.25;
    end;

    local v67;

    if p52 == High - 1 or p51 == 0 then
        v67 = 0.25;
    else
        local v68 = p50.Support[p51 - 1 + (p52 + 1) * p50.Wide + 1];
        v67 = (v68 > 0 and v68 and v68 or 0) * 0.25;
    end;

    return 0.01 + v53 + v55 + v57 + v59 + v61 + v63 + v65 + v67;
end;

local function ShatterPane(p69: any, p70: number, p71: number) -- Line: 257
    if p70 < 0 or (p69.Wide <= p70 or (p71 < 0 or p69.High <= p71)) then
        return false;
    end;

    if (p70 < 0 or (p69.Wide <= p70 or (p71 < 0 or p69.High <= p71))) and true or p69.Support[p70 + p71 * p69.Wide + 1] == -1 then
        return false;
    end;

    local v72 = p70 + p71 * p69.Wide + 1;
    p69.Support[v72] = -1;

    if p69.Bits[v72] ~= "1" then
        p69.Bits[v72] = "1";
        p69.Changed = true;
    end;

    p69.BrokenCount = p69.BrokenCount + 1;
    p69.Think = true;

    return true;
end;

local function BreakThink(p73) -- Line: 282
    -- upvalues: table_create_ret (copy), RecalcSupport (copy), ShatterPane (copy)
    local Wide = p73.Wide;
    local High = p73.High;

    for i = 0, Wide - 1 do
        local v74 = i;

        for i2 = 0, High - 1 do
            local v75;

            if (v74 < 0 or (p73.Wide <= v74 or (i2 < 0 or p73.High <= i2))) and true or p73.Support[v74 + i2 * p73.Wide + 1] == -1 then
                v75 = i2;
            else
                table_create_ret[v74 + i2 * Wide + 1] = RecalcSupport(p73, v74, i2);
                v75 = i2;
            end;
        end;
    end;

    local v76 = 0.2 * (p73.Fragility / 100);
    local v77 = false;

    for i = 0, Wide - 1 do
        local v78 = i;

        for i2 = 0, High - 1 do
            local v79;

            if (v78 < 0 or (p73.Wide <= v78 or (i2 < 0 or p73.High <= i2))) and true or p73.Support[v78 + i2 * p73.Wide + 1] == -1 then
                v79 = i2;
            else
                local v80 = v78 + i2 * Wide + 1;
                local v81 = table_create_ret[v80] / 6.75;
                local v82 = v78 + i2 * p73.Wide + 1;
                p73.Support[v82] = v81;
                local v83 = v81 < 0 and "1" or "0";

                if p73.Bits[v82] ~= v83 then
                    p73.Bits[v82] = v83;
                    p73.Changed = true;
                end;

                if p73.Support[v80] < v76 then
                    ShatterPane(p73, v78, i2);
                    v79 = i2;
                    v77 = true;
                else
                    v79 = i2;
                end;
            end;
        end;
    end;

    return v77;
end;

local function Die(p84) -- Line: 321
    -- upvalues: u5 (ref), u4 (copy)
    local Part = p84.Part;
    p84.Broken = true;
    Part.CanQuery = false;
    Part.CanCollide = false;
    u5.SetBrushesEnabled(Part, false);
    table.insert(u4, p84);
    p84.Changed = true;
end;

function v1.IsBreakable(p85: userdata) -- Line: 340
    -- upvalues: u3 (copy)
    return u3[p85] ~= nil;
end;

function v1.Contains(p86: vector) -- Line: 347
    -- upvalues: u3 (copy)
    for i in u3 do
        local v87 = i.CFrame:PointToObjectSpace(p86);
        local v88 = i.Size * 0.5 + Vector3.new(0.05, 0.05, 0.05);

        if math.abs(v87.X) <= v88.X and (math.abs(v87.Y) <= v88.Y and math.abs(v87.Z) <= v88.Z) then
            return true;
        end;
    end;

    return false;
end;

function v1.Hit(p89: userdata, p90: vector) -- Line: 369
    -- upvalues: u3 (copy), u2 (copy), u5 (ref), u4 (copy), ShatterPane (copy)
    local v91 = u3[p89];

    if not (v91 and u2) then
        return false;
    end;

    if not v91.Broken then
        local Part = v91.Part;
        v91.Broken = true;
        Part.CanQuery = false;
        Part.CanCollide = false;
        u5.SetBrushesEnabled(Part, false);
        table.insert(u4, v91);
        v91.Changed = true;
    end;

    local v92 = p90 - v91.Corner;
    local v93 = vector.dot(v92, v91.WidthAxis) / v91.PaneWidth;
    local v94 = vector.dot(v92, v91.HeightAxis) / v91.PaneHeight;
    local math_floor_ret = math.floor(v93);
    local math_floor_ret2 = math.floor(v94);
    ShatterPane(v91, math_floor_ret, math_floor_ret2);
    local v95 = v93 - math_floor_ret;
    local v96 = v94 - math_floor_ret2;

    if v95 > 0.8 and math_floor_ret ~= v91.Wide - 1 then
        ShatterPane(v91, math_floor_ret + 1, math_floor_ret2);
    elseif v95 < 0.2 and math_floor_ret ~= 0 then
        ShatterPane(v91, math_floor_ret - 1, math_floor_ret2);
    end;

    if v96 > 0.8 and math_floor_ret2 ~= v91.High - 1 then
        ShatterPane(v91, math_floor_ret, math_floor_ret2 + 1);
    elseif v96 < 0.2 and math_floor_ret2 ~= 0 then
        ShatterPane(v91, math_floor_ret, math_floor_ret2 - 1);
    end;

    if math.random(0, 1) == 0 then
        ShatterPane(v91, math_floor_ret, math_floor_ret2 + 1);

        if math.random(0, 1) == 0 then
            ShatterPane(v91, math_floor_ret, math_floor_ret2 + 2);
        end;
    end;

    return true;
end;

local function TouchPanes(p97) -- Line: 424
    -- upvalues: u6 (ref), u12 (ref), ShatterPane (copy)
    local Normal = p97.Normal;
    local HalfDefaultCollisionBox = u6.HalfDefaultCollisionBox;
    local v98 = math.abs(Normal.X) * HalfDefaultCollisionBox.X + math.abs(Normal.Y) * HalfDefaultCollisionBox.Y + math.abs(Normal.Z) * HalfDefaultCollisionBox.Z + p97.HalfThickness;

    for _, v in u12.GetAllCharacters() do
        local CFrame2 = v.CFrame;

        if CFrame2 then
            local Position = CFrame2.Position;
            local vector_dot_ret = vector.dot(Position - p97.Corner, Normal);

            if v98 >= math.abs(vector_dot_ret) then
                local v99 = Position - HalfDefaultCollisionBox - p97.Corner;
                local v100 = vector.dot(v99, p97.WidthAxis) / p97.PaneWidth;
                local v101 = vector.dot(v99, p97.HeightAxis) / p97.PaneHeight;
                local v102 = Position + HalfDefaultCollisionBox - p97.Corner;
                local v103 = vector.dot(v102, p97.WidthAxis) / p97.PaneWidth;
                local v104 = vector.dot(v102, p97.HeightAxis) / p97.PaneHeight;
                local math_min_ret = math.min(v100, v103);
                local math_max_ret = math.max(0, math_min_ret);
                local math_floor_ret = math.floor(math_max_ret);
                local Wide = p97.Wide;
                local math_max_ret2 = math.max(v100, v103);
                local math_min_ret2 = math.min(Wide, math_max_ret2);
                local math_ceil_ret = math.ceil(math_min_ret2);
                local math_min_ret3 = math.min(v101, v104);
                local math_max_ret3 = math.max(0, math_min_ret3);
                local math_floor_ret2 = math.floor(math_max_ret3);
                local High = p97.High;
                local math_max_ret4 = math.max(v101, v104);
                local math_min_ret4 = math.min(High, math_max_ret4);

                for i = math_floor_ret2, math.ceil(math_min_ret4) - 1 do
                    if math.random(0, 1) == 1 then
                        ShatterPane(p97, math_floor_ret - 1, i);
                    end;

                    local v105 = i;

                    for i2 = math_floor_ret, math_ceil_ret - 1 do
                        ShatterPane(p97, i2, v105);
                        local _ = i2;
                    end;

                    if math.random(0, 1) == 1 then
                        ShatterPane(p97, math_ceil_ret + 1, v105);
                    end;
                end;
            end;
        end;
    end;
end;

local function Step() -- Line: 479
    -- upvalues: u4 (copy), BreakThink (copy), TouchPanes (copy)
    for _, v in u4 do
        if v.BrokenCount < v.Wide * v.High then
            if v.Think then
                v.Think = BreakThink(v);
            end;

            TouchPanes(v);
        end;

        if v.Changed then
            v.Changed = false;
            v.Part:SetAttribute("BrokenPanes", table.concat(v.Bits));
        end;
    end;
end;

local function RestoreAll() -- Line: 498
    -- upvalues: u4 (copy), u5 (ref)
    for _, v in u4 do
        local Part = v.Part;
        Part:SetAttribute("BrokenPanes", nil);
        Part.CanQuery = v.CanQuery;
        Part.CanCollide = v.CanCollide;
        u5.SetBrushesEnabled(Part, true);
        local v106 = v;

        for i = 1, v.Wide * v.High do
            v106.Support[i] = 1;
            v106.Bits[i] = "0";
            local _ = i;
        end;

        v106.BrokenCount = 0;
        v106.Broken = false;
        v106.Think = false;
        v106.Changed = false;
    end;

    table.clear(u4);
end;

local function BuildPanes(p107) -- Line: 534
    -- upvalues: u5 (ref)
    local Part = p107.Part;
    local Folder = Instance.new("Folder");
    Folder.Name = Part.Name .. "_Panes";
    local table_create_ret2 = table.create(p107.Wide * p107.High);

    for i = 0, p107.High - 1 do
        local v108 = i;

        for i2 = 0, p107.Wide - 1 do
            local Part2 = Instance.new("Part");
            Part2.Size = p107.PaneSize;
            Part2.CFrame = CFrame.new(p107.Corner + p107.WidthAxis * ((i2 + 0.5) * p107.PaneWidth) + p107.HeightAxis * ((v108 + 0.5) * p107.PaneHeight)) * p107.Rotation;
            Part2.Anchored = true;
            Part2.CanCollide = false;
            Part2.CanQuery = false;
            Part2.CanTouch = false;
            Part2.CastShadow = false;
            Part2.Color = Part.Color;
            Part2.Material = Part.Material;
            Part2.Transparency = p107.Transparency;
            Part2.Reflectance = Part.Reflectance;
            Part2.Parent = Folder;
            table_create_ret2[i2 + v108 * p107.Wide + 1] = Part2;
            local _ = i2;
        end;
    end;

    Folder.Parent = workspace.Terrain;
    p107.Folder = Folder;
    p107.Panes = table_create_ret2;
    Part.Transparency = 1;
    u5.SetBrushesEnabled(Part, false);
end;

local function ClearPanes(p109) -- Line: 580
    -- upvalues: u5 (ref)
    if not p109.Panes then
        return;
    end;

    p109.Folder:Destroy();
    p109.Folder = nil;
    p109.Panes = nil;

    if p109.Part.Parent then
        p109.Part.Transparency = p109.Transparency;
    end;

    u5.SetBrushesEnabled(p109.Part, true);
end;

local function ApplyBits(p110: any, p111: string?, p112: boolean?) -- Line: 599
    -- upvalues: u5 (ref), BuildPanes (copy), u7 (ref), u8 (ref)
    if p111 then
        if p110.Panes == nil then
            BuildPanes(p110);

            if not p112 then
                u7.Play(p110.BreakSound, {
                    Position = p110.Part.Position
                });
            end;
        end;

        local Panes = p110.Panes;
        local os_clock_ret = os.clock();
        local v113 = 0;

        for i = 1, math.min(#p111, p110.Wide * p110.High) do
            local v114;

            if string.byte(p111, i) == 49 then
                local v115 = Panes[i];

                if v115 then
                    local Position = v115.Position;
                    Panes[i] = nil;
                    v115:Destroy();

                    if p112 then
                        v114 = i;
                    else
                        if v113 < 6 then
                            v113 = v113 + 1;

                            if u8 then
                                u8.CreateBulletSmoke(Position, p110.Normal, "Glass", p110.Part.Color);
                            end;
                        end;

                        if os_clock_ret - p110.LastPaneSound > 0.05 then
                            p110.LastPaneSound = os_clock_ret;
                            u7.Play(p110.PaneSound, {
                                Position = Position
                            });
                            v114 = i;
                        else
                            v114 = i;
                        end;
                    end;
                else
                    v114 = i;
                end;
            else
                v114 = i;
            end;
        end;

        return;
    end;

    if not p110.Panes then
        return;
    end;

    p110.Folder:Destroy();
    p110.Folder = nil;
    p110.Panes = nil;

    if p110.Part.Parent then
        p110.Part.Transparency = p110.Transparency;
    end;

    u5.SetBrushesEnabled(p110.Part, true);
end;

local function Unregister(p116: userdata) -- Line: 660
    -- upvalues: u3 (copy), u2 (copy), u5 (ref), u4 (copy)
    local v117 = u3[p116];

    if not v117 then
        return;
    end;

    if not u2 and v117.Panes then
        v117.Folder:Destroy();
        v117.Folder = nil;
        v117.Panes = nil;

        if v117.Part.Parent then
            v117.Part.Transparency = v117.Transparency;
        end;

        u5.SetBrushesEnabled(v117.Part, true);
    end;

    local table_find_ret = table.find(u4, v117);

    if table_find_ret then
        table.remove(u4, table_find_ret);
    end;

    u3[p116] = nil;
end;

local function Register(u118: userdata) -- Line: 683
    -- upvalues: u3 (copy), BuildSurface (copy), u2 (copy), ApplyBits (copy)
    if u3[u118] or not (u118:IsA("BasePart") and u118:IsDescendantOf(workspace)) then
        return;
    end;

    local u119 = BuildSurface(u118);
    u3[u118] = u119;

    if u2 then
        return;
    end;

    u118:GetAttributeChangedSignal("BrokenPanes"):Connect(function() -- Line: 696
        -- upvalues: ApplyBits (ref), u119 (copy), u118 (copy)
        ApplyBits(u119, u118:GetAttribute("BrokenPanes"));
    end);
    local Attribute = u118:GetAttribute("BrokenPanes");

    if Attribute then
        ApplyBits(u119, Attribute, true);
    end;
end;

local function RegisterAll() -- Line: 708
    -- upvalues: CollectionService (copy), Register (copy)
    for _, v in CollectionService:GetTagged("Breakable") do
        Register(v);
    end;
end;

function v1.Init(p120) -- Line: 716
    -- upvalues: u5 (ref), u6 (ref), ReplicatedStorage (copy), u7 (ref), u11 (ref), u2 (copy), u9 (ref), u10 (ref), u12 (ref), u8 (ref)
    u5 = p120:GetModule("CollisionModule");
    u6 = require(ReplicatedStorage.Shared.CollisionModule.CollisionState);
    u7 = p120:GetModule("SoundManager");
    u11 = p120:GetModule("Tick");

    if not u2 then
        u8 = p120:GetModule("ParticleHandler");

        return;
    end;

    u9 = p120:GetModule("GameTracker");
    u10 = p120:GetModule("Map");
    u12 = p120:GetModule("CharacterHandler");
end;

function v1.Start(p121) -- Line: 732
    -- upvalues: CollectionService (copy), Register (copy), Unregister (copy), u2 (copy), u10 (ref), RegisterAll (copy), u9 (ref), RestoreAll (copy), u11 (ref), Step (copy)
    CollectionService:GetInstanceAddedSignal("Breakable"):Connect(Register);
    CollectionService:GetInstanceRemovedSignal("Breakable"):Connect(Unregister);

    for _, v in CollectionService:GetTagged("Breakable") do
        Register(v);
    end;

    if not u2 then
        workspace.ChildAdded:Connect(function(p122) -- Line: 741
            -- upvalues: CollectionService (ref), Register (ref)
            if p122.Name == "Map" then
                for _, v in CollectionService:GetTagged("Breakable") do
                    Register(v);
                end;
            end;
        end);

        return;
    end;

    u10.OnNewMapAdded:Connect(RegisterAll);
    u9.new(RestoreAll, "BreakablesRoundStart", u9.OnRoundStart);
    u11.PostTick.Connect({
        Priority = 5,
        SubPriority = 2,
        Function = Step
    });
end;

return v1;