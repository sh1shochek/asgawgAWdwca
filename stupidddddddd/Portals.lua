-- ReplicatedStorage.Visibility.PortalVis.Portals
-- Script path: ReplicatedStorage.Visibility.PortalVis.Portals
-- Decompile time: 5.18 ms

local makeTreePortals
local Winding = require(script.Parent:WaitForChild("Winding"))
local v1 = {}

local function addPortalToNodes(a1, a2, a3) -- Line: 16
    a1.nodes[1] = a2
    a1.next[1] = a2.portals
    a2.portals = a1
    a1.nodes[2] = a3
    a1.next[2] = a3.portals
    a3.portals = a1
end

local function removePortalFromNode(a1, a2) -- Line: 25
    local v1
    local v2 = nil
    local v3 = nil
    local portals = a2.portals
    local v4, v5 = a1, a2
    while portals ~= nil do
        if portals == v4 then
            break
        end
        v1 = if portals.nodes[1] ~= v5 then 2 else 1
        v2 = portals
        v3 = v1
        portals = portals.next[v1]
    end
    assert(portals == v4, "portal not in node list")
    v1 = if v4.nodes[1] ~= v5 then 2 else 1
    if v2 == nil then
        v5.portals = v4.next[v1]
    else
        v2.next[v3] = v4.next[v1]
    end
    v4.next[v1] = nil
    v4.nodes[v1] = nil
end

local function newPortal(a1, a2) -- Line: 44
    return {plane = a1, w = a2, nodes = {}, next = {}}
end

local function nodePortals(a1) -- Line: 48
    local next
    local v1 = {}
    local portals = a1.portals
    while portals ~= nil do
        v1[#v1 + 1] = portals
        next = portals.next
        portals = next[if portals.nodes[1] ~= a1 then 2 else 1]
    end
    return v1
end

local function makeHeadnodePortals(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 58
    -- upvalues: newPortal (val), Winding (val)
    local v1, v2, v3
    local v4 = {a3 - 0, a4 - 0, a5 - 0}
    local v5 = {a6 + 0, a7 + 0, a8 + 0}
    local v6 = {}
    local v7 = {}
    local v8, v9 = a1, a2
    for i = 1, 3 do
        for j = 0, 1 do
            v1 = {0, 0, 0, 0}
            if j ~= 1 then
                v1[i] = 1
                v1[4] = v4[i]
            else
                v1[i] = -1
                v1[4] = -v5[i]
            end
            v2 = j * 3 + i
            v6[v2] = v1
            v3 = newPortal(v1, Winding.baseForPlane(v1[1], v1[2], v1[3], v1[4]))
            v7[v2] = v3
            v3.nodes[1] = v8
            v3.next[1] = v8.portals
            v8.portals = v3
            v3.nodes[2] = v9
            v3.next[2] = v9.portals
            v9.portals = v3
        end
    end
    for k = 1, 6 do
        for n = 1, 6 do
            if k ~= n then
                v1 = v6[n]
                v7[k].w = Winding.clip(v7[k].w, v1[1], v1[2], v1[3], v1[4], 0.001)
            end
        end
    end
end

local function makeNodePortal(a1, a2) -- Line: 89 -- upvalues: Winding (val), nodePortals (val), newPortal (val)
    local plane_2
    local plane = a1.plane
    local v1 = Winding.baseForPlane(plane[1], plane[2], plane[3], plane[4])
    local v2, v3 = a1, a2
    for i, j in nodePortals(a1) do
        plane_2 = j.plane
        v1 = if j.nodes[1] ~= v2 then Winding.clip(v1, -plane_2[1], -plane_2[2], -plane_2[3], -plane_2[4], 0.001) else Winding.clip(v1, plane_2[1], plane_2[2], plane_2[3], plane_2[4], 0.001)
        if v1 == nil then
            break
        end
    end
    if v1 == nil then
        v3.clippedAway = v3.clippedAway + 1
        return
    end
    if (Winding.area(v1)) < 1e-06 then
        v3.tinyPortals = v3.tinyPortals + 1
        return
    end
    local v4 = newPortal(plane, v1)
    local front = v2.front
    local back = v2.back
    v4.nodes[1] = front
    v4.next[1] = front.portals
    front.portals = v4
    v4.nodes[2] = back
    v4.next[2] = back.portals
    back.portals = v4
end

local function splitNodePortals(a1, a2) -- Line: 115
    -- upvalues: nodePortals (val), removePortalFromNode (val), Winding (val), newPortal (val)
    local v1, v2, v3, v4, v5
    local plane = a1.plane
    local front = a1.front
    local back = a1.back
    for i, j in nodePortals(a1) do
        v1 = if j.nodes[1] ~= a1 then 2 else 1
        v2 = j.nodes[3 - v1]
        removePortalFromNode(j, j.nodes[1])
        removePortalFromNode(j, j.nodes[2])
        v3, v4 = Winding.split(j.w, plane[1], plane[2], plane[3], plane[4], 0.001)
        if v3 ~= nil and (Winding.area(v3)) < 1e-06 then
            v3 = nil
            v6.tinyPortals = v6.tinyPortals + 1
        end
        if v4 ~= nil and (Winding.area(v4)) < 1e-06 then
            v4 = nil
            v6.tinyPortals = v6.tinyPortals + 1
        end
        if v3 ~= nil or v4 ~= nil then
            if v3 == nil then
                j.w = v4
                if v1 ~= 1 then
                    j.nodes[1] = v2
                    j.next[1] = v2.portals
                    v2.portals = j
                    j.nodes[2] = back
                    j.next[2] = back.portals
                    back.portals = j
                else
                    j.nodes[1] = back
                    j.next[1] = back.portals
                    back.portals = j
                    j.nodes[2] = v2
                    j.next[2] = v2.portals
                    v2.portals = j
                end
            elseif v4 ~= nil then
                v5 = newPortal(j.plane, v4)
                j.w = v3
                if v1 ~= 1 then
                    j.nodes[1] = v2
                    j.next[1] = v2.portals
                    v2.portals = j
                    j.nodes[2] = front
                    j.next[2] = front.portals
                    front.portals = j
                    v5.nodes[1] = v2
                    v5.next[1] = v2.portals
                    v2.portals = v5
                    v5.nodes[2] = back
                    v5.next[2] = back.portals
                    back.portals = v5
                else
                    j.nodes[1] = front
                    j.next[1] = front.portals
                    front.portals = j
                    j.nodes[2] = v2
                    j.next[2] = v2.portals
                    v2.portals = j
                    v5.nodes[1] = back
                    v5.next[1] = back.portals
                    back.portals = v5
                    v5.nodes[2] = v2
                    v5.next[2] = v2.portals
                    v2.portals = v5
                end
                v6.splitPortals = v6.splitPortals + 1
            else
                j.w = v3
                if v1 ~= 1 then
                    j.nodes[1] = v2
                    j.next[1] = v2.portals
                    v2.portals = j
                    j.nodes[2] = front
                    j.next[2] = front.portals
                    front.portals = j
                else
                    j.nodes[1] = front
                    j.next[1] = front.portals
                    front.portals = j
                    j.nodes[2] = v2
                    j.next[2] = v2.portals
                    v2.portals = j
                end
            end
        end
    end
end

function makeTreePortals(a1, a2, a3) -- Line: 166
    -- upvalues: makeNodePortal (val), splitNodePortals (val), makeTreePortals (val)
    if a1.leaf then
        return
    end
    a2.visited = a2.visited + 1
    if a3 ~= nil and a2.visited % 4 == 0 then
        a3()
    end
    makeNodePortal(a1, a2)
    splitNodePortals(a1, a2)
    makeTreePortals(a1.front, a2, a3)
    makeTreePortals(a1.back, a2, a3)
end

function v1.build(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 181
    -- upvalues: makeHeadnodePortals (val), makeTreePortals (val), nodePortals (val)
    local v1, v2
    local v3 = {
        clippedAway = 0,
        tinyPortals = 0,
        splitPortals = 0,
        airPortals = 0,
        solidPortals = 0,
        visited = 0,
    }
    makeHeadnodePortals(a1, {leaf = true, air = false, outside = true, planes = {}}, a3, a4, a5, a6, a7, a8)
    makeTreePortals(a1, v3, a9)
    local v4 = {}
    local v5 = {}
    local v6 = nil
    local v7 = nil
    for i, j in a2, v6, v7 do
        if j.air then
            for k, n in nodePortals(j) do
                if not v5[n] then
                    v5[n] = true
                    v1 = n.nodes[1]
                    v2 = n.nodes[2]
                    if not v1.air or not v2.air then
                        v3.solidPortals = v3.solidPortals + 1
                    else
                        v3.airPortals = v3.airPortals + 1
                        v4[#v4 + 1] = {front = v1, back = v2, plane = n.plane, w = n.w}
                    end
                end
            end
        end
    end
    return v4, v3
end

return v1