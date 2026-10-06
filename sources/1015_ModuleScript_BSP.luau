-- Decompiled with Potassium's decompiler.

local Winding = require(script.Parent:WaitForChild("Winding"));
local Brush = require(script.Parent:WaitForChild("Brush"));
local v1 = {};

local function selectSplit(p2) -- Line: 10
    -- upvalues: Brush (copy), Winding (copy)
    local v3 = {};
    local v4 = (-1 / 0);
    local v5 = nil;

    for _, v in p2 do
        for _, v2 in v.sides do
            if not (v2.used or v3[v2.key]) then
                v3[v2.key] = true;
                local nx = v2.nx;
                local ny = v2.ny;
                local nz = v2.nz;
                local d = v2.d;
                local v6 = v2;
                local v7 = 0;
                local v8 = 0;
                local v9 = 0;
                local v10 = 0;

                for _, v11 in p2 do
                    local v12 = Brush.classify(v11, nx, ny, nz, d);

                    if v12 == "front" then
                        v10 = v10 + 1;
                    elseif v12 == "back" then
                        v8 = v8 + 1;
                    else
                        v7 = v7 + 1;
                    end;

                    if v11.keys[v6.key] then
                        v9 = v9 + 1;
                    end;
                end;

                local v13 = v9 * 5 - v7 * 5 - math.abs(v10 - v8);

                if Winding.isAxial(nx, ny, nz) then
                    v13 = v13 + 5;
                end;

                if v4 < v13 then
                    v5 = v6;
                    v4 = v13;
                end;
            end;
        end;
    end;

    return v5;
end;

function v1.build(p14, p15, u16) -- Line: 47
    -- upvalues: selectSplit (copy), Brush (copy)
    local u17 = {};
    local u18 = {
        nodes = 0,
        airLeaves = 0,
        solidLeaves = 0,
        maxDepth = 0,
        splitBrushes = 0
    };

    local function makeLeaf(p19, p20, p21) -- Line: 51
        -- upvalues: u17 (copy), u18 (copy)
        local v22 = {
            leaf = true,
            portals = nil,
            air = p20,
            planes = p19,
            index = #u17 + 1,
            brushes = p21
        };
        u17[#u17 + 1] = v22;

        if p20 then
            local v23 = u18;
            v23.airLeaves = v23.airLeaves + 1;

            return v22;
        end;

        local v24 = u18;
        v24.solidLeaves = v24.solidLeaves + 1;

        return v22;
    end;

    local function build(p25, p26, p27) -- Line: 62
        -- upvalues: u18 (copy), u17 (copy), selectSplit (ref), Brush (ref), u16 (copy), build (copy)
        if u18.maxDepth < p27 then
            u18.maxDepth = p27;
        end;

        if #p25 == 0 then
            local v28 = {
                leaf = true,
                air = true,
                portals = nil,
                planes = p26,
                index = #u17 + 1,
                brushes = p25
            };
            u17[#u17 + 1] = v28;
            local v29 = u18;
            v29.airLeaves = v29.airLeaves + 1;

            return v28;
        end;

        local v30 = selectSplit(p25);

        if v30 == nil then
            local v31 = {
                leaf = true,
                air = false,
                portals = nil,
                planes = p26,
                index = #u17 + 1,
                brushes = p25
            };
            u17[#u17 + 1] = v31;
            local v32 = u18;
            v32.solidLeaves = v32.solidLeaves + 1;

            return v31;
        end;

        local nx = v30.nx;
        local ny = v30.ny;
        local nz = v30.nz;
        local d = v30.d;
        local key = v30.key;
        local v33 = {};
        local v34 = {};

        for _, v in p25 do
            local v35 = Brush.classify(v, nx, ny, nz, d);

            if v35 == "front" then
                Brush.markUsed(v, key);
                v34[#v34 + 1] = v;
            elseif v35 == "back" then
                Brush.markUsed(v, key);
                v33[#v33 + 1] = v;
            else
                local v36, v37 = Brush.split(v, nx, ny, nz, d);
                local v38 = u18;
                v38.splitBrushes = v38.splitBrushes + 1;

                if v36 ~= nil then
                    Brush.markUsed(v36, key);
                    v34[#v34 + 1] = v36;
                end;

                if v37 ~= nil then
                    Brush.markUsed(v37, key);
                    v33[#v33 + 1] = v37;
                end;
            end;
        end;

        local v39 = u18;
        v39.nodes = v39.nodes + 1;

        if u16 ~= nil and u18.nodes % 4 == 0 then
            u16();
        end;

        local v40 = {
            portals = nil,
            plane = {
                nx,
                ny,
                nz,
                d
            }
        };
        local table_clone_ret = table.clone(p26);
        table_clone_ret[#table_clone_ret + 1] = {
            -nx,
            -ny,
            -nz,
            -d
        };
        local table_clone_ret2 = table.clone(p26);
        table_clone_ret2[#table_clone_ret2 + 1] = {
            nx,
            ny,
            nz,
            d
        };
        v40.front = build(v34, table_clone_ret, p27 + 1);
        v40.back = build(v33, table_clone_ret2, p27 + 1);
        v40.front.parent = v40;
        v40.back.parent = v40;

        return v40;
    end;

    return build(p14, table.clone(p15), 0), u17, u18;
end;

function v1.leafTouchesBox(p41, p42, p43, p44, p45, p46, p47, p48) -- Line: 118
    for _, v in p41.planes do
        local v49 = v[1];
        local v50 = v[2];
        local v51 = v[3];
        local v52;

        if v49 > 0 then
            v52 = p42;
        else
            v52 = p45;
        end;

        local v53;

        if v50 > 0 then
            v53 = p43;
        else
            v53 = p46;
        end;

        local v54;

        if v51 > 0 then
            v54 = p44;
        else
            v54 = p47;
        end;

        if p48 < v52 * v49 + v53 * v50 + v54 * v51 - v[4] then
            return false;
        end;
    end;

    return true;
end;

return v1;