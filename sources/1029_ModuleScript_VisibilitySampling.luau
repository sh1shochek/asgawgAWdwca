-- Decompiled with Potassium's decompiler.

local u1 = {};

local function quantize(p2: number, p3: number) -- Line: 9
    return math.round(p2 / p3);
end;

local function appendOrientedBox(p4: table, p5: vector, p6: vector, p7: vector, p8: vector, p9: number, p10: number, p11: number, p12: number) -- Line: 13
    for i = 0, 1 do
        local v13;

        if i == 1 then
            v13 = p7 * p11;
        else
            v13 = p7 * -p10;
        end;

        local _ = i;

        for i2 = -1, 1, 2 do
            p4[#p4 + 1] = p5 + v13 + p6 * (p9 * i2) + p8 * (p12 * -1);
            p4[#p4 + 1] = p5 + v13 + p6 * (p9 * i2) + p8 * (p12 * 1);
            local _ = i2;
        end;
    end;
end;

u1.appendOrientedBox = appendOrientedBox;

function u1.orientedBox(p14: vector, p15: number, p16: number, p17: number, p18: number, p19: number) -- Line: 39
    -- upvalues: appendOrientedBox (copy)
    local CFrame_Angles_ret = CFrame.Angles(0, p15, 0);
    local table_create_ret = table.create(8);
    appendOrientedBox(table_create_ret, p14, CFrame_Angles_ret.RightVector, Vector3.new(0, 1, 0), CFrame_Angles_ret.LookVector, p16, p17, p18, p19);

    return table_create_ret;
end;

function u1.orientedPartBox(p20, p21: vector, p22: number?) -- Line: 64
    local math_max_ret = math.max(p22 or 0, 0);
    local v23 = p21 * 0.5 + Vector3.new(1, 1, 1) * math_max_ret;
    local table_create_ret = table.create(8);

    for _, v in { -1, 1 } do
        local v24 = v;

        for _, v2 in { -1, 1 } do
            local v25 = v2;

            for _, v3 in { -1, 1 } do
                table_create_ret[#table_create_ret + 1] = p20:PointToWorldSpace((Vector3.new(v23.X * v24, v23.Y * v25, v23.Z * v3)));
            end;
        end;
    end;

    return table_create_ret;
end;

function u1.capsuleBox(p26: vector, p27: vector, p28: number) -- Line: 81
    local v29 = p27 - p26;
    local Magnitude = v29.Magnitude;
    local v30 = Magnitude <= 0.00001 and Vector3.new(0, 1, 0) or v29 / Magnitude;
    local v31 = v30:Dot(Vector3.new(0, 1, 0));
    local Unit = v30:Cross(math.abs(v31) < 0.9 and Vector3.new(0, 1, 0) or Vector3.new(1, 0, 0)).Unit;
    local Unit2 = Unit:Cross(v30).Unit;
    local math_max_ret = math.max(p28, 0);
    local table_create_ret = table.create(8);

    for _, v in { p26 - v30 * math_max_ret, p27 + v30 * math_max_ret } do
        local v32 = v;

        for _, v2 in { -1, 1 } do
            local v33 = v2;

            for _, v3 in { -1, 1 } do
                table_create_ret[#table_create_ret + 1] = v32 + Unit * (math_max_ret * v33) + Unit2 * (math_max_ret * v3);
            end;
        end;
    end;

    return table_create_ret;
end;

function u1.pointBoxes(p34: table, p35: number) -- Line: 102
    local v36 = Vector3.new(1, 1, 1) * math.max(p35, 0);
    local table_create_ret = table.create(#p34);

    for _, v in p34 do
        local v37 = v - v36;
        local v38 = v + v36;
        local table_create_ret2 = table.create(8);

        for i = 0, 1 do
            local v39 = i;

            for i2 = 0, 1 do
                local v40 = i2;

                for i3 = 0, 1 do
                    local v41;

                    if v39 == 0 then
                        v41 = v37.X;
                    else
                        v41 = v38.X;
                    end;

                    local v42;

                    if v40 == 0 then
                        v42 = v37.Y;
                    else
                        v42 = v38.Y;
                    end;

                    local v43;

                    if i3 == 0 then
                        v43 = v37.Z;
                    else
                        v43 = v38.Z;
                    end;

                    table_create_ret2[#table_create_ret2 + 1] = Vector3.new(v41, v42, v43);
                    local _ = i3;
                end;
            end;
        end;

        table_create_ret[#table_create_ret + 1] = table_create_ret2;
    end;

    return table_create_ret;
end;

function u1.animatedCapsuleFallback(p44: vector, p45: number, p46: number, p47: vector, p48: number, p49: number, p50: number, p51: number, p52: number?) -- Line: 126
    -- upvalues: u1 (copy)
    local math_max_ret = math.max(p51, 0);
    local math_max_ret2 = math.max(p52 or 0, 0);
    local v53 = { (u1.orientedBox(p44, p45, p47.X + p48 + math_max_ret, p47.Y + math_max_ret2 + math_max_ret, p47.Y + p49 + math_max_ret, p47.Z + p48 + math_max_ret)) };

    if p50 <= 0 then
        return v53;
    end;

    local LookVector = CFrame.Angles(0, p45, 0).LookVector;
    local math_clamp_ret = math.clamp(p46, -1, 1);
    local math_max_ret3 = math.max(1 - math_clamp_ret * math_clamp_ret, 0);
    local v54 = LookVector * math.sqrt(math_max_ret3) + Vector3.new(0, 1, 0) * math_clamp_ret;
    local v55 = math.max(0.65, p47.X + p48) + math_max_ret;
    local v56 = p44 + Vector3.new(0, 1, 0) * math.max(p47.Y * 0.25, 0.5) + LookVector * math.max(p47.Z * 0.5, 0.25);
    v53[#v53 + 1] = u1.capsuleBox(v56, v56 + v54 * (p47.Z + p48 + p50), v55);

    return v53;
end;

function u1.fingerprint(p57: table, p58: number?) -- Line: 168
    local v59 = p58 or 0.05;
    local v60 = (v59 <= 0 or v59 ~= v59) and 0.05 or v59;
    local table_create_ret = table.create(#p57 + 1);
    table_create_ret[1] = tostring(#p57);

    for i, v in p57 do
        table_create_ret[i + 1] = `{math.round(v.X / v60)},{math.round(v.Y / v60)},{math.round(v.Z / v60)}`;
    end;

    return table.concat(table_create_ret, ";");
end;

function u1.orientedBodyFallback(p61: vector, p62: number, p63: vector, p64: number, p65: number, p66: number, p67: number?) -- Line: 182
    -- upvalues: appendOrientedBox (copy)
    local CFrame_Angles_ret = CFrame.Angles(0, p62, 0);
    local LookVector = CFrame_Angles_ret.LookVector;
    local v68 = p63.Z + p64;
    local v69 = {};
    appendOrientedBox(v69, p61, CFrame_Angles_ret.RightVector, Vector3.new(0, 1, 0), LookVector, p63.X + p64, p63.Y + math.max(p67 or 0, 0), p63.Y + p65, v68);
    v69[#v69 + 1] = p61 + LookVector * (v68 + p66) + Vector3.new(0, 1, 0) * math.max(p63.Y * 0.35, 0.5);

    return v69;
end;

return table.freeze(u1);