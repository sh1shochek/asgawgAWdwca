-- ReplicatedStorage.MovementV2.Collision.QuickHull
-- Script path: ReplicatedStorage.MovementV2.Collision.QuickHull
-- Decompile time: 13.26 ms

local u0 = {}
u0.__index = u0

function u0.new(a1, a2) -- Line: 6 -- upvalues: u0 (val) -- types: a1: vector, a2: number
    return (setmetatable({point = a1, index = a2}, u0))
end

local u2 = {}
u2.__index = u2

function u2.new() -- Line: 19 -- upvalues: u2 (val)
    return (setmetatable({}, u2))
end

function u2:clear() -- Line: 26
    self.head = nil
    self.tail = nil
end

function u2:first() -- Line: 31
    return self.head
end

function u2:isEmpty() -- Line: 35
    return self.head == nil
end

function u2:add(a2) -- Line: 39
    if not self.head then
        self.head = a2
    else
        self.tail.next = a2
    end
    a2.prev = self.tail
    a2.next = nil
    self.tail = a2
end

function u2:addAll(a2) -- Line: 50
    if not self.head then
        self.head = a2
    else
        self.tail.next = a2
    end
    a2.prev = self.tail
    local next = a2
    while next.next do
        next = next.next
    end
    self.tail = next
end

function u2:insertBefore(a2, a3) -- Line: 63
    a3.prev = a2.prev
    a3.next = a2
    if not a3.prev then
        self.head = a3
    else
        a3.prev.next = a3
    end
    a2.prev = a3
end

function u2:remove(a2) -- Line: 74
    if not a2.prev then
        self.head = a2.next
    else
        a2.prev.next = a2.next
    end
    if a2.next then
        a2.next.prev = a2.prev
        return
    end
    self.tail = a2.prev
end

function u2:removeChain(a2, a3) -- Line: 87
    if not a2.prev then
        self.head = a3.next
    else
        a2.prev.next = a3.next
    end
    if a3.next then
        a3.next.prev = a2.prev
        return
    end
    self.tail = a2.prev
end

local u12 = {}
u12.__index = u12

function u12.new(a1, a2) -- Line: 103 -- upvalues: u12 (val)
    return (setmetatable({vertex = a1, face = a2}, u12))
end

function u12:head() -- Line: 113
    return self.vertex
end

function u12:tail() -- Line: 117
    if self.prev then
        return self.prev.vertex
    end
    return nil
end

function u12:lengthSquared() -- Line: 121
    local v1 = self:tail()
    if not v1 then
        return -1
    end
    local v2 = self:head().point - v1.point
    return v2.X * v2.X + v2.Y * v2.Y + v2.Z * v2.Z
end

function u12:setOpposite(a2) -- Line: 130
    self.opposite = a2
    a2.opposite = self
end

local u18 = {}
u18.__index = u18

function u18.new() -- Line: 138 -- upvalues: u18 (val)
    return (setmetatable({
        normal = Vector3.new(0, 0, 0),
        centroid = Vector3.new(0, 0, 0),
        offset = 0,
        mark = 0,
        nVertices = 0,
        area = 0,
    }, u18))
end

function u18.createTriangle(a1, a2, a3, a4) -- Line: 151 -- upvalues: u18 (val), u12 (val) -- types: a4: number?
    local v1 = u18.new()
    local v2 = u12.new(a1, v1)
    local v3 = u12.new(a2, v1)
    local v4 = u12.new(a3, v1)
    v2.next = v3
    v3.prev = v2
    v3.next = v4
    v4.prev = v3
    v4.next = v2
    v2.prev = v4
    v1.edge = v2
    v1:computeNormalAndCentroid(a4 or 0)
    return v1
end

function u18:getEdge(a2) -- Line: 169 -- types: self: table, a2: number
    local edge = self.edge
    local v1 = a2
    while v1 > 0 do
        edge = edge.next
        v1 = v1 - 1
    end
    while v1 < 0 do
        edge = edge.prev
        v1 = v1 + 1
    end
    return edge
end

function u18:computeNormal() -- Line: 182
    local v1
    local edge = self.edge
    local next = edge.next
    local next_2 = next.next
    local v2 = next:head().point - edge:head().point
    self.nVertices = 2
    self.normal = Vector3.new(0, 0, 0)
    while next_2 ~= edge do
        v1 = v2
        v2 = next_2:head().point - edge:head().point
        self.normal = self.normal + v1:Cross(v2)
        next_2 = next_2.next
        self.nVertices = self.nVertices + 1
    end
    self.area = self.normal.Magnitude
    if 0 < self.area then
        self.normal = self.normal / self.area
        return
    end
    self.normal = Vector3.new(0, 1, 0)
end

function u18:computeNormalMinArea(a2) -- Line: 207 -- types: self: table, a2: number
    local v1
    self:computeNormal()
    if a2 <= self.area then
        return
    end
    local v2 = 0
    local v3 = nil
    local edge = self.edge
    repeat
        v1 = edge:lengthSquared()
        if v2 < v1 then
            v2 = v1
            v3 = edge
        end
        edge = edge.next
    until edge == v4.edge
    if v3 and not (v2 <= 0) then
        v1 = v3:tail()
        if not v1 then
            return
        end
        local Unit = (v3:head().point - v1.point).Unit
        v4.normal = v4.normal - Unit * v4.normal:Dot(Unit)
        if 0 < v4.normal.Magnitude then
            v4.normal = v4.normal.Unit
            return
        end
        v4.normal = Vector3.new(0, 1, 0)
        return
    end
end

function u18:computeCentroid() -- Line: 243
    self.centroid = Vector3.new(0, 0, 0)
    local edge = self.edge
    repeat
        self.centroid = self.centroid + edge:head().point
        edge = edge.next
    until edge == self.edge
    self.centroid = self.centroid / self.nVertices
end

function u18:computeNormalAndCentroid(a2) -- Line: 253 -- types: self: table, a2: number?
    if not a2 or not (a2 > 0) then
        self:computeNormal()
    else
        self:computeNormalMinArea(a2)
    end
    self:computeCentroid()
    self.offset = self.normal:Dot(self.centroid)
end

function u18:distanceToPlane(a2) -- Line: 263 -- types: self: table, a2: vector
    return (self.normal:Dot(a2)) - self.offset
end

function u18:connectHalfEdges(a2, a3) -- Line: 267
    local opposite
    if a2.opposite.face ~= a3.opposite.face then
        a2.next = a3
        a3.prev = a2
        return nil
    end
    local face = a3.opposite.face
    if a2 == self.edge then
        self.edge = a3
    end
    local v1 = nil
    if face.nVertices ~= 3 then
        opposite = a3.opposite.next
        if face.edge == opposite.prev then
            face.edge = opposite
        end
        opposite.prev = opposite.prev.prev
        opposite.prev.next = opposite
    else
        opposite = a3.opposite.prev.opposite
        face.mark = 2
        v1 = face
    end
    a3.prev = a2.prev
    a3.prev.next = a3
    a3:setOpposite(opposite)
    face:computeNormalAndCentroid()
    return v1
end

function u18:mergeAdjacentFaces(a2, a3) -- Line: 302
    local face = a2.opposite.face
    table.insert(a3, face)
    face.mark = 2
    local prev = a2.prev
    local next = a2.next
    local prev_2 = a2.opposite.prev
    local next_2 = a2.opposite.next
    while prev.opposite.face == face do
        prev = prev.prev
        next_2 = next_2.next
    end
    while next.opposite.face == face do
        next = next.next
        prev_2 = prev_2.prev
    end
    local next_3 = next_2
    while next_3 ~= prev_2.next do
        next_3.face = self
        next_3 = next_3.next
    end
    self.edge = next
    local v1 = self:connectHalfEdges(prev_2, next)
    if v1 then
        table.insert(a3, v1)
    end
    v1 = self:connectHalfEdges(prev, next_2)
    if v1 then
        table.insert(a3, v1)
    end
    self:computeNormalAndCentroid()
    return a3
end

function u18:collectIndices() -- Line: 345
    local v1 = {}
    local edge = self.edge
    repeat
        table.insert(v1, (edge:head()).index)
        edge = edge.next
    until edge == self.edge
    return v1
end

local u30 = {}
u30.__index = u30
local u31 = {"X", "Y", "Z"}

local function getAxisValue(a1, a2) -- Line: 360 -- types: a1: vector, a2: number
    if a2 == 1 then
        return a1.X
    end
    if a2 == 2 then
        return a1.Y
    end
    return a1.Z
end

local function appendArray(a1, a2) -- Line: 370 -- types: a1: table, a2: table
    local v1 = table.clone(a1)
    for i, v in ipairs(a2) do
        table.insert(v1, v)
    end
    return v1
end

local function distancePointToLine(a1, a2, a3) -- Line: 378 -- types: a1: vector, a2: vector, a3: vector
    local v1 = a3 - a2
    if v1.Magnitude <= 0 then
        error("line points are identical")
    end
    return (a1 - a2):Cross(v1).Magnitude / v1.Magnitude
end

function u30.new(a1) -- Line: 386 -- upvalues: u2 (val), u30 (val), u0 (val) -- types: a1: table
    assert(#a1 >= 4, "cannot build a simplex out of < 4 points")
    local v1 = {
        tolerance = -1,
        faces = {},
        newFaces = {},
        claimed = u2.new(),
        unclaimed = u2.new(),
        vertices = {},
    }
    local v2 = setmetatable(v1, u30)
    for i, v in ipairs(a1) do
        table.insert(v2.vertices, (u0.new(v, i)))
    end
    return v2
end

function u30:addVertexToFace(a2, a3) -- Line: 405
    a2.face = a3
    if not a3.outside then
        self.claimed:add(a2)
    else
        self.claimed:insertBefore(a3.outside, a2)
    end
    a3.outside = a2
end

function u30:removeVertexFromFace(a2, a3) -- Line: 415
    if a2 == a3.outside then
        if not a2.next or a2.next.face ~= a3 then
            a3.outside = nil
        else
            a3.outside = a2.next
        end
    end
    self.claimed:remove(a2)
end

function u30:removeAllVerticesFromFace(a2) -- Line: 426
    if not a2.outside then
        return nil
    end
    local outside_2 = a2.outside
    while outside_2.next do
        if outside_2.next.face ~= a2 then
            break
        end
        outside_2 = outside_2.next
    end
    self.claimed:removeChain(a2.outside, outside_2)
    outside_2.next = nil
    return a2.outside
end

function u30:deleteFaceVertices(a2, a3) -- Line: 440
    local next
    local v1 = self:removeAllVerticesFromFace(a2)
    if not v1 then
        return
    end
    if not a3 then
        self.unclaimed:addAll(v1)
        return
    end
    local v2 = v1
    local v3, v4 = a3, self
    while v2 do
        next = v2.next
        if not (v4.tolerance < (v3:distanceToPlane(v2.point))) then
            v4.unclaimed:add(v2)
        else
            v4:addVertexToFace(v2, v3)
        end
        v2 = next
    end
end

function u30:resolveUnclaimedPoints(a2) -- Line: 463
    local next, point, v1, v2
    local v3 = self.unclaimed:first()
    local v4, v5 = self, a2
    while v3 do
        next = v3.next
        v2 = nil
        for i, v in ipairs(v5) do
            if v.mark == 0 then
                point = v3.point
                v1 = v:distanceToPlane(point)
                if v4.tolerance < v1 then
                    v2 = v
                    if 1000 * v4.tolerance < v1 then
                        break
                    end
                end
            end
        end
        if v2 then
            v4:addVertexToFace(v3, v2)
        end
        v3 = next
    end
end

function u30:computeExtremes() -- Line: 490 -- upvalues: u31 (val)
    local X, point, v1
    local v2 = {self.vertices[1], self.vertices[1], self.vertices[1]}
    local v3 = {self.vertices[1], self.vertices[1], self.vertices[1]}
    local v4 = {
        self.vertices[1].point.X,
        self.vertices[1].point.Y,
        self.vertices[1].point.Z,
    }
    local v5 = {
        self.vertices[1].point.X,
        self.vertices[1].point.Y,
        self.vertices[1].point.Z,
    }
    local v6 = #self.vertices
    for i = 2, v6 do
        v1 = self.vertices[i]
        for i2, v in ipairs(u31) do
            point = v1.point
            X = if i2 ~= 1 then if i2 ~= 2 then point.Z else point.Y else point.X
            if X < v4[i2] then
                v4[i2] = X
                v2[i2] = v1
            end
            if v5[i2] < X then
                v5[i2] = X
                v3[i2] = v1
            end
        end
    end
    self.tolerance = ((math.max(math.abs(v4[1]), (math.abs(v5[1])))) + math.max(math.abs(v4[2]), (math.abs(v5[2]))) + math.max(math.abs(v4[3]), (math.abs(v5[3])))) * 0.0003
    return v2, v3
end

function u30:createInitialSimplex() -- Line: 520 -- upvalues: u31 (val), u18 (val)
    local X, X_2, point_5, point_6, point_7, point_8, v1, v2, v3
    local v4, v5 = self:computeExtremes()
    local v6 = 0
    local v7 = 1
    local v8 = self
    for i, v in ipairs(u31) do
        point_7 = v5[i].point
        X = if i ~= 1 then if i ~= 2 then point_7.Z else point_7.Y else point_7.X
        point_8 = v4[i].point
        X_2 = if i ~= 1 then if i ~= 2 then point_8.Z else point_8.Y else point_8.X
        v1 = X - X_2
        if v6 < v1 then
            v6 = v1
            v7 = i
        end
    end
    local v9 = v4[v7]
    local v10 = v5[v7]
    if v6 <= v8.tolerance then
        return nil
    end
    local v11 = nil
    local v12 = 0
    for i2, i3 in ipairs(v8.vertices) do
        if i3 ~= v9 and i3 ~= v10 then
            point_5 = i3.point
            point_6 = v9.point
            v3 = v10.point - point_6
            if v3.Magnitude <= 0 then
                error("line points are identical")
            end
            v2 = (point_5 - point_6):Cross(v3).Magnitude / v3.Magnitude
            if v12 < v2 then
                v12 = v2
                v11 = i3
            end
        end
    end
    if v11 and not (v12 <= v8.tolerance) then
        local v13 = (v9.point - v10.point):Cross(v10.point - v11.point)
        if v13.Magnitude <= v8.tolerance then
            return nil
        end
        local Unit = v13.Unit
        v1 = v9.point:Dot(Unit)
        local v14 = nil
        local v15 = 0
        for i4, j in ipairs(v8.vertices) do
            if j ~= v9 and j ~= v10 and j ~= v11 then
                v3 = math.abs((Unit:Dot(j.point)) - v1)
                if v15 < v3 then
                    v15 = v3
                    v14 = j
                end
            end
        end
        if v14 and not (v15 <= v8.tolerance) then
            local point, v16, v17, v18, v19, v20
            if not (v14.point:Dot(Unit) - v1 < 0) then
                v17 = {
                    u18.createTriangle(v9, v11, v10),
                    u18.createTriangle(v14, v9, v10),
                    u18.createTriangle(v14, v10, v11),
                    (u18.createTriangle(v14, v11, v9)),
                }
                v16 = table.clone({})
                for i5, k in ipairs(v17) do
                    table.insert(v16, k)
                end
                for n = 0, 2 do
                    v18 = (n + 1) % 3
                    ;(v16[n + 2]:getEdge(2)):setOpposite((v16[1]:getEdge((3 - n) % 3)))
                    ;(v16[n + 2]:getEdge(0)):setOpposite((v16[v18 + 2]:getEdge(1)))
                end
            else
                v17 = {
                    u18.createTriangle(v9, v10, v11),
                    u18.createTriangle(v14, v10, v9),
                    u18.createTriangle(v14, v11, v10),
                    (u18.createTriangle(v14, v9, v11)),
                }
                v16 = table.clone({})
                for i6, m in ipairs(v17) do
                    table.insert(v16, m)
                end
                for i52 = 0, 2 do
                    v18 = (i52 + 1) % 3
                    ;(v16[i52 + 2]:getEdge(2)):setOpposite((v16[1]:getEdge(v18)))
                    ;(v16[i52 + 2]:getEdge(1)):setOpposite((v16[v18 + 2]:getEdge(0)))
                end
            end
            v8.faces = v16
            for i7, i62 in ipairs(v8.vertices) do
                if i62 ~= v9 and i62 ~= v10 and i62 ~= v11 and i62 ~= v14 then
                    v19 = nil
                    for i8, i72 in ipairs(v16) do
                        point = i62.point
                        v20 = i72:distanceToPlane(point)
                        if v8.tolerance < v20 then
                            v19 = i72
                        end
                    end
                    if v19 then
                        v8:addVertexToFace(i62, v19)
                    end
                end
            end
            return true
        end
        return nil
    end
    return nil
end

function u30:reindexFaceAndVertices() -- Line: 628
    local v1 = {}
    for i, v in ipairs(self.faces) do
        if v.mark == 0 then
            table.insert(v1, v)
        end
    end
    self.faces = v1
end

function u30:collectFaces(a2) -- Line: 638 -- types: self: table, a2: boolean?
    local v1, v2
    local v3 = {}
    for i, v in ipairs(self.faces) do
        assert(v.mark == 0, "attempt to include a destroyed face in the hull")
        v1 = v:collectIndices()
        if not v4 then
            v2 = #v1 - 2
            for i2 = 1, v2 do
                table.insert(v3, {v1[1], v1[i2 + 1], v1[i2 + 2]})
            end
        else
            table.insert(v3, v1)
        end
    end
    return v3
end

function u30:nextVertexToAdd() -- Line: 654
    local v1
    if self.claimed:isEmpty() then
        return nil
    end
    local face = self.claimed:first().face
    local outside = face.outside
    local v2 = 0
    local v3 = nil
    while outside do
        if outside.face ~= face then
            break
        end
        v1 = face:distanceToPlane(outside.point)
        if v2 < v1 then
            v3 = outside
        end
        outside = outside.next
    end
    return v3
end

function u30:computeHorizon(a2, a3, a4, a5) -- Line: 676 -- types: self: table, a2: vector
    local face, opposite
    self:deleteFaceVertices(a4)
    a4.mark = 2
    local next = if not a3 then a4:getEdge(0) else a3.next
    local v1 = a3 or next
    local v2, v3, v4 = a2, self, a5
    repeat
        opposite = next.opposite
        face = opposite.face
        if face.mark == 0 then
            if not (v3.tolerance < (face:distanceToPlane(v2))) then
                table.insert(v4, next)
            else
                v3:computeHorizon(v2, opposite, face, v4)
            end
        end
        next = next.next
    until next == v1
end

function u30:addAdjoiningFace(a2, a3) -- Line: 700 -- upvalues: u18 (val)
    local v1 = u18.createTriangle(a2, a3:tail(), a3:head())
    table.insert(self.faces, v1)
    ;(v1:getEdge(-1)):setOpposite(a3.opposite)
    return v1:getEdge(0)
end

function u30:addNewFaces(a2, a3) -- Line: 707
    local v1
    self.newFaces = {}
    local v2 = nil
    local v3 = nil
    local v4, v5 = a2, self
    for i, v in ipairs(a3) do
        v1 = v5:addAdjoiningFace(v4, v)
        if not v2 then
            v2 = v1
        else
            v1.next:setOpposite(v3)
        end
        table.insert(v5.newFaces, v1.face)
        v3 = v1
    end
    if v2 and v3 then
        v2.next:setOpposite(v3)
    end
end

function u30.oppositeFaceDistance(a1, a2) -- Line: 728
    return a2.face:distanceToPlane(a2.opposite.face.centroid)
end

function u30:doAdjacentMerge(a2, a3) -- Line: 732 -- types: self: table, a3: number
    local v1, v2, v3, v4, v5
    local edge = a2.edge
    local v6 = 0
    local v7 = true
    local v8 = a2
    while true do
        if v8.nVertices < v6 then
            error("merge recursion limit exceeded")
        end
        v3 = false
        if v2 == 2 then
            v4 = true
            v5 = v1:oppositeFaceDistance(edge)
            if not (-v1.tolerance < v5) then
                v4 = v1.tolerance < (v1:oppositeFaceDistance(edge.opposite))
            end
            v3 = v4
        elseif not (edge.opposite.face.area < v8.area) then
            v4 = v1:oppositeFaceDistance(edge.opposite)
            if not (-v1.tolerance < v4) then
                v4 = v1:oppositeFaceDistance(edge)
                if -v1.tolerance < v4 then
                    v7 = false
                end
            else
                v3 = true
            end
        else
            v4 = v1:oppositeFaceDistance(edge)
            if not (-v1.tolerance < v4) then
                v4 = v1:oppositeFaceDistance(edge.opposite)
                if -v1.tolerance < v4 then
                    v7 = false
                end
            else
                v3 = true
            end
        end
        if v3 then
            for i, v in ipairs((v8:mergeAdjacentFaces(edge, {}))) do
                v1:deleteFaceVertices(v, v8)
            end
            return true
        end
        edge = edge.next
        v6 = v6 + 1
        if edge == v8.edge then
            if not v7 then
                v8.mark = 1
            end
            return false
        end
    end
end

function u30:addVertexToHull(a2) -- Line: 783
    local v1 = {}
    self.unclaimed:clear()
    self:removeVertexFromFace(a2, a2.face)
    self:computeHorizon(a2.point, nil, a2.face, v1)
    self:addNewFaces(a2, v1)
    local v2 = self
    for i, v in ipairs(self.newFaces) do
        if v.mark == 0 then
            while v2:doAdjacentMerge(v, 1) do end
        end
    end
    for i2, i3 in ipairs(v2.newFaces) do
        if i3.mark == 1 then
            i3.mark = 0
            while v2:doAdjacentMerge(i3, 2) do end
        end
    end
    v2:resolveUnclaimedPoints(v2.newFaces)
end

function u30:build() -- Line: 808
    if not self:createInitialSimplex() then
        return false
    end
    local v1 = self:nextVertexToAdd()
    while v1 do
        self:addVertexToHull(v1)
        v1 = self:nextVertexToAdd()
    end
    self:reindexFaceAndVertices()
    return true
end

function u30.GenerateHull(a1) -- Line: 823 -- upvalues: u30 (val) -- types: a1: table
    local v1 = u30.new(a1)
    if not v1:build() then
        return nil
    end
    local v2 = {}
    for i, v in ipairs(v1:collectFaces(false)) do
        table.insert(v2, {
            v1.vertices[v[1]].point,
            v1.vertices[v[2]].point,
            v1.vertices[v[3]].point,
        })
    end
    return v2
end

return u30