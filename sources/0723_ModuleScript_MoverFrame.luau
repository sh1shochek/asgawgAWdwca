-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Parent.Enums);
local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
require(script.Parent.Parent.Simulation.Types);
local u1 = {};

local function isFiniteNumber(p2) -- Line: 43
    local v3;

    if typeof(p2) == "number" and (p2 == p2 and p2 > (-1 / 0)) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

local function isFiniteVector3(p4) -- Line: 47
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

local function isFiniteCFrame(p6) -- Line: 54
    if typeof(p6) ~= "CFrame" then
        return false;
    end;

    for _, v in { p6:GetComponents() } do
        local v7;

        if typeof(v) == "number" and (v == v and v > (-1 / 0)) then
            v7 = v < (1 / 0);
        else
            v7 = false;
        end;

        if not v7 then
            return false;
        end;
    end;

    return true;
end;

local function angularVelocity(p8, p9, p10: number) -- Line: 66
    local v11, v12 = p8.Rotation:ToObjectSpace(p9.Rotation):ToAxisAngle();
    local v13;

    if typeof(v12) == "number" and (v12 == v12 and v12 > (-1 / 0)) then
        v13 = v12 < (1 / 0);
    else
        v13 = false;
    end;

    if not v13 or v12 <= 1e-9 then
        return Vector3.new(0, 0, 0), 0;
    end;

    local v14 = p8:VectorToWorldSpace(v11);
    local Magnitude = v14.Magnitude;

    if Magnitude <= 1e-9 then
        return Vector3.new(0, 0, 0), 0;
    end;

    return v14 / Magnitude * (v12 / p10), v12;
end;

local function makeRecord(p15: table, p16: number) -- Line: 80
    -- upvalues: Serial (copy), isFiniteCFrame (copy), angularVelocity (copy), Enums (copy)
    local v17 = Serial.isUInt32(p15.Id) and p15.Id > 0;
    assert(v17, "mover ID must be a non-zero u32");
    local v18 = isFiniteCFrame(p15.PreviousCFrame);
    assert(v18, "mover PreviousCFrame must be finite");
    local v19 = isFiniteCFrame(p15.CFrame);
    assert(v19, "mover CFrame must be finite");
    local Size = p15.Size;
    local v20;

    if typeof(Size) == "Vector3" then
        local X = Size.X;

        if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
            v20 = X < (1 / 0);
        else
            v20 = false;
        end;

        if v20 then
            local Y = Size.Y;

            if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
                v20 = Y < (1 / 0);
            else
                v20 = false;
            end;

            if v20 then
                local Z = Size.Z;

                if typeof(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
                    v20 = Z < (1 / 0);
                else
                    v20 = false;
                end;
            end;
        end;
    else
        v20 = false;
    end;

    if v20 then
        if p15.Size.X > 0 and p15.Size.Y > 0 then
            v20 = p15.Size.Z > 0;
        else
            v20 = false;
        end;
    end;

    assert(v20, "mover Size must be a finite positive Vector3");
    local v21 = p15.SurfaceFriction or 1;
    local v22;

    if typeof(v21) == "number" and (v21 == v21 and v21 > (-1 / 0)) then
        v22 = v21 < (1 / 0);
    else
        v22 = false;
    end;

    if v22 then
        v22 = v21 >= 0;
    end;

    assert(v22, "mover surface friction must be finite and nonnegative");
    local v23, v24 = angularVelocity(p15.PreviousCFrame, p15.CFrame, p16);

    return table.freeze({
        Id = p15.Id,
        Kind = Enums.SupportKind.Mover,
        SourceId = p15.Id,
        PreviousCFrame = p15.PreviousCFrame,
        CFrame = p15.CFrame,
        Size = p15.Size,
        LinearVelocity = (p15.CFrame.Position - p15.PreviousCFrame.Position) / p16,
        AngularVelocity = v23,
        RotationAngle = v24,
        BoundingRadius = (p15.Size * 0.5).Magnitude,
        SurfaceFriction = v21,
        Pushes = p15.Pushes == true
    });
end;

function u1.Build(p25: number, p26: table) -- Line: 111
    -- upvalues: makeRecord (copy)
    local v27;

    if typeof(p25) == "number" and (p25 == p25 and p25 > (-1 / 0)) then
        v27 = p25 < (1 / 0);
    else
        v27 = false;
    end;

    if v27 then
        v27 = p25 > 0;
    end;

    assert(v27, "mover-frame delta time must be finite and positive");
    local v28 = typeof(p26) == "table";
    assert(v28, "mover inputs must be a table");
    local table_create_ret = table.create(#p26);

    for i, v in p26 do
        table_create_ret[i] = makeRecord(v, p25);
    end;

    table.sort(table_create_ret, function(p29, p30) -- Line: 119
        return p29.Id < p30.Id;
    end);
    local v31 = 0;
    local v32 = {};

    for _, v in table_create_ret do
        assert(v31 < v.Id, string.format("duplicate mover ID %d", v.Id));
        v31 = v.Id;
        v32[v.Id] = v;
    end;

    table.freeze(table_create_ret);
    table.freeze(v32);

    return table.freeze({
        Records = table_create_ret,
        ById = v32
    });
end;

function u1.SampleCFrame(p33: table, p34: number) -- Line: 138
    local v35;

    if typeof(p34) == "number" and (p34 == p34 and p34 > (-1 / 0)) then
        v35 = p34 < (1 / 0);
    else
        v35 = false;
    end;

    if v35 then
        if p34 >= 0 then
            v35 = p34 <= 1;
        else
            v35 = false;
        end;
    end;

    assert(v35, "invalid mover time fraction");

    if p34 <= 0 then
        return p33.PreviousCFrame;
    end;

    if p34 >= 1 then
        return p33.CFrame;
    end;

    return p33.PreviousCFrame:Lerp(p33.CFrame, p34);
end;

function u1.VelocityAtPoint(p36: table, p37: vector, p38: number?) -- Line: 150
    -- upvalues: u1 (copy)
    local v39;

    if typeof(p37) == "Vector3" then
        local X = p37.X;

        if typeof(X) == "number" and (X == X and X > (-1 / 0)) then
            v39 = X < (1 / 0);
        else
            v39 = false;
        end;

        if v39 then
            local Y = p37.Y;

            if typeof(Y) == "number" and (Y == Y and Y > (-1 / 0)) then
                v39 = Y < (1 / 0);
            else
                v39 = false;
            end;

            if v39 then
                local Z = p37.Z;

                if typeof(Z) == "number" and (Z == Z and Z > (-1 / 0)) then
                    v39 = Z < (1 / 0);
                else
                    v39 = false;
                end;
            end;
        end;
    else
        v39 = false;
    end;

    assert(v39, "surface point must be a finite Vector3");
    local v40 = u1.SampleCFrame(p36, p38 or 1);

    return p36.LinearVelocity + p36.AngularVelocity:Cross(p37 - v40.Position);
end;

function u1.ResolveSupportMotion(p41: table, p42: any) -- Line: 157
    -- upvalues: Enums (copy), u1 (copy)
    if p42.Kind ~= Enums.SupportKind.Mover or p42.SourceId == 0 then
        return nil;
    end;

    local v43 = p41.ById[p42.SourceId];

    if v43 == nil then
        return nil;
    end;

    local v44 = v43.PreviousCFrame:PointToWorldSpace(p42.Anchor);
    local v45 = v43.CFrame:PointToWorldSpace(p42.Anchor);

    return {
        Kind = Enums.SupportKind.Mover,
        SourceId = v43.Id,
        Delta = v45 - v44,
        Velocity = u1.VelocityAtPoint(v43, v45, 1)
    };
end;

return table.freeze(u1);