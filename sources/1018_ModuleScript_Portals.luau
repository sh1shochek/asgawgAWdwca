-- Decompiled with Potassium's decompiler.

local Winding = require(script.Parent:WaitForChild("Winding"));
local v1 = {};

local function addPortalToNodes(p2, p3, p4) -- Line: 16
    p2.nodes[1] = p3;
    p2.next[1] = p3.portals;
    p3.portals = p2;
    p2.nodes[2] = p4;
    p2.next[2] = p4.portals;
    p4.portals = p2;
end;

local function removePortalFromNode(p5, p6) -- Line: 25
    local portals = p6.portals;
    local v7 = nil;
    local v8 = nil;

    while portals ~= nil and portals ~= p5 do
        v8 = portals.nodes[1] == p6 and 1 or 2;
        v7 = portals;
        portals = portals.next[v8];
    end;

    assert(portals == p5, "portal not in node list");
    local v9 = p5.nodes[1] == p6 and 1 or 2;

    if v7 == nil then
        p6.portals = p5.next[v9];
    else
        v7.next[v8] = p5.next[v9];
    end;

    p5.next[v9] = nil;
    p5.nodes[v9] = nil;
end;

local function newPortal(p10, p11) -- Line: 44
    return {
        plane = p10,
        w = p11,
        nodes = {},
        next = {}
    };
end;

local function nodePortals(p12) -- Line: 48
    local portals = p12.portals;
    local v13 = {};

    while portals ~= nil do
        v13[#v13 + 1] = portals;
        portals = portals.next[portals.nodes[1] == p12 and 1 or 2];
    end;

    return v13;
end;

local function makeHeadnodePortals(p14, p15, p16, p17, p18, p19, p20, p21) -- Line: 58
    -- upvalues: newPortal (copy), Winding (copy)
    local v22 = { p16 - 0, p17 - 0, p18 - 0 };
    local v23 = { p19 + 0, p20 + 0, p21 + 0 };
    local v24 = {};
    local v25 = {};

    for i = 1, 3 do
        local v26 = i;

        for i2 = 0, 1 do
            local v27 = { 0, 0, 0, 0 };

            if i2 == 1 then
                v27[v26] = -1;
                v27[4] = -v23[v26];
            else
                v27[v26] = 1;
                v27[4] = v22[v26];
            end;

            local v28 = i2 * 3 + v26;
            v24[v28] = v27;
            local v29 = newPortal(v27, Winding.baseForPlane(v27[1], v27[2], v27[3], v27[4]));
            v25[v28] = v29;
            v29.nodes[1] = p14;
            v29.next[1] = p14.portals;
            p14.portals = v29;
            v29.nodes[2] = p15;
            v29.next[2] = p15.portals;
            p15.portals = v29;
            local _ = i2;
        end;
    end;

    for i = 1, 6 do
        local v30 = i;

        for i2 = 1, 6 do
            local v31;

            if v30 == i2 then
                v31 = i2;
            else
                local v32 = v24[i2];
                v25[v30].w = Winding.clip(v25[v30].w, v32[1], v32[2], v32[3], v32[4], 0.001);
                v31 = i2;
            end;
        end;
    end;
end;

local function makeNodePortal(p33, p34) -- Line: 89
    -- upvalues: Winding (copy), nodePortals (copy), newPortal (copy)
    local plane = p33.plane;
    local v35 = Winding.baseForPlane(plane[1], plane[2], plane[3], plane[4]);

    for _, v in nodePortals(p33) do
        local plane2 = v.plane;

        if v.nodes[1] == p33 then
            v35 = Winding.clip(v35, plane2[1], plane2[2], plane2[3], plane2[4], 0.001);
        else
            v35 = Winding.clip(v35, -plane2[1], -plane2[2], -plane2[3], -plane2[4], 0.001);
        end;

        if v35 == nil then
            break;
        end;
    end;

    if v35 == nil then
        p34.clippedAway = p34.clippedAway + 1;

        return;
    end;

    if Winding.area(v35) < 1e-6 then
        p34.tinyPortals = p34.tinyPortals + 1;

        return;
    end;

    local v36 = newPortal(plane, v35);
    local front = p33.front;
    local back = p33.back;
    v36.nodes[1] = front;
    v36.next[1] = front.portals;
    front.portals = v36;
    v36.nodes[2] = back;
    v36.next[2] = back.portals;
    back.portals = v36;
end;

local function splitNodePortals(p37, p38) -- Line: 115
    -- upvalues: nodePortals (copy), removePortalFromNode (copy), Winding (copy), newPortal (copy)
    local plane = p37.plane;
    local front = p37.front;
    local back = p37.back;

    for _, v in nodePortals(p37) do
        local v39 = v.nodes[1] == p37 and 1 or 2;
        local v40 = v.nodes[3 - v39];
        removePortalFromNode(v, v.nodes[1]);
        removePortalFromNode(v, v.nodes[2]);
        local v41, v42 = Winding.split(v.w, plane[1], plane[2], plane[3], plane[4], 0.001);

        if v41 ~= nil and Winding.area(v41) < 1e-6 then
            p38.tinyPortals = p38.tinyPortals + 1;
            v41 = nil;
        end;

        if v42 ~= nil and Winding.area(v42) < 1e-6 then
            p38.tinyPortals = p38.tinyPortals + 1;
            v42 = nil;
        end;

        if v41 ~= nil or v42 ~= nil then
            if v41 == nil then
                v.w = v42;

                if v39 == 1 then
                    v.nodes[1] = back;
                    v.next[1] = back.portals;
                    back.portals = v;
                    v.nodes[2] = v40;
                    v.next[2] = v40.portals;
                    v40.portals = v;
                else
                    v.nodes[1] = v40;
                    v.next[1] = v40.portals;
                    v40.portals = v;
                    v.nodes[2] = back;
                    v.next[2] = back.portals;
                    back.portals = v;
                end;
            elseif v42 == nil then
                v.w = v41;

                if v39 == 1 then
                    v.nodes[1] = front;
                    v.next[1] = front.portals;
                    front.portals = v;
                    v.nodes[2] = v40;
                    v.next[2] = v40.portals;
                    v40.portals = v;
                else
                    v.nodes[1] = v40;
                    v.next[1] = v40.portals;
                    v40.portals = v;
                    v.nodes[2] = front;
                    v.next[2] = front.portals;
                    front.portals = v;
                end;
            else
                local v43 = newPortal(v.plane, v42);
                v.w = v41;

                if v39 == 1 then
                    v.nodes[1] = front;
                    v.next[1] = front.portals;
                    front.portals = v;
                    v.nodes[2] = v40;
                    v.next[2] = v40.portals;
                    v40.portals = v;
                    v43.nodes[1] = back;
                    v43.next[1] = back.portals;
                    back.portals = v43;
                    v43.nodes[2] = v40;
                    v43.next[2] = v40.portals;
                    v40.portals = v43;
                else
                    v.nodes[1] = v40;
                    v.next[1] = v40.portals;
                    v40.portals = v;
                    v.nodes[2] = front;
                    v.next[2] = front.portals;
                    front.portals = v;
                    v43.nodes[1] = v40;
                    v43.next[1] = v40.portals;
                    v40.portals = v43;
                    v43.nodes[2] = back;
                    v43.next[2] = back.portals;
                    back.portals = v43;
                end;

                p38.splitPortals = p38.splitPortals + 1;
            end;
        end;
    end;
end;

local function makeTreePortals(p44, p45, p46) -- Line: 166
    -- upvalues: makeNodePortal (copy), splitNodePortals (copy), makeTreePortals (copy)
    if p44.leaf then
        return;
    end;

    p45.visited = p45.visited + 1;

    if p46 ~= nil and p45.visited % 4 == 0 then
        p46();
    end;

    makeNodePortal(p44, p45);
    splitNodePortals(p44, p45);
    makeTreePortals(p44.front, p45, p46);
    makeTreePortals(p44.back, p45, p46);
end;

function v1.build(p47, p48, p49, p50, p51, p52, p53, p54, p55) -- Line: 181
    -- upvalues: makeHeadnodePortals (copy), makeTreePortals (copy), nodePortals (copy)
    local v56 = {
        clippedAway = 0,
        tinyPortals = 0,
        splitPortals = 0,
        airPortals = 0,
        solidPortals = 0,
        visited = 0
    };
    makeHeadnodePortals(p47, {
        leaf = true,
        air = false,
        outside = true,
        portals = nil,
        planes = {}
    }, p49, p50, p51, p52, p53, p54);
    makeTreePortals(p47, v56, p55);
    local v57 = {};
    local v58 = {};

    for _, v in p48 do
        if v.air then
            for _, v2 in nodePortals(v) do
                if not v57[v2] then
                    v57[v2] = true;
                    local v59 = v2.nodes[1];
                    local v60 = v2.nodes[2];

                    if v59.air and v60.air then
                        v56.airPortals = v56.airPortals + 1;
                        v58[#v58 + 1] = {
                            front = v59,
                            back = v60,
                            plane = v2.plane,
                            w = v2.w
                        };
                    else
                        v56.solidPortals = v56.solidPortals + 1;
                    end;
                end;
            end;
        end;
    end;

    return v58, v56;
end;

return v1;