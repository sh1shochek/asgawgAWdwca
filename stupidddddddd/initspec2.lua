-- ReplicatedStorage.Packages._Index.sleitnick_table-util@1.2.1.table-util.init.spec
-- Script path: ReplicatedStorage.Packages._Index.sleitnick_table-util@1.2.1.table-util.init.spec
-- Decompile time: 6.93 ms

return function() -- Line: 1
    local Parent = require(script.Parent)
    describe("Copy (Deep)", function() -- Line: 4 -- upvalues: Parent (val)
        it("should create a deep table copy", function() -- Line: 5 -- upvalues: Parent (upval)
            local v1 = {a = {b = {c = {d = 32}}}}
            local v2 = Parent.Copy(v1, true)
            expect(v1).never.to.equal(v2)
            expect(v1.a).never.to.equal(v2.a)
            expect(v2.a.b.c.d).to.equal(v1.a.b.c.d)
        end)
    end)
    describe("Copy (Shallow)", function() -- Line: 14 -- upvalues: Parent (val)
        it("should create a shallow dictionary copy", function() -- Line: 15 -- upvalues: Parent (upval)
            local v1 = {a = {b = {c = {d = 32}}}}
            local v2 = Parent.Copy(v1)
            expect(v2).never.to.equal(v1)
            expect(v2.a).to.equal(v1.a)
            expect(v2.a.b.c.d).to.equal(v1.a.b.c.d)
        end)
        it("should create a shallow array copy", function() -- Line: 23 -- upvalues: Parent (upval)
            local v1 = {10, 20, 30, 40}
            local v2 = Parent.Copy(v1)
            expect(v2).never.to.equal(v1)
            for i, v in ipairs(v1) do
                expect(v2[i]).to.equal(v)
            end
        end)
    end)
    describe("Sync", function() -- Line: 33 -- upvalues: Parent (val)
        it("should sync tables", function() -- Line: 34 -- upvalues: Parent (upval)
            local v1 = {a = 32, b = 64, c = 128, e = {h = 1}}
            local v2 = Parent.Sync({
                a = 32,
                b = 10,
                d = 1,
                e = {h = 2, n = 2},
                f = {x = 10},
            }, v1)
            expect(v2.a).to.equal(v1.a)
            expect(v2.b).to.equal(10)
            expect(v2.c).to.equal(v1.c)
            expect(v2.d).never.to.be.ok()
            expect(v2.e.h).to.equal(2)
            expect(v2.e.n).never.to.be.ok()
            expect(v2.f).never.to.be.ok()
        end)
    end)
    describe("Reconcile", function() -- Line: 48 -- upvalues: Parent (val)
        it("should reconcile table", function() -- Line: 49 -- upvalues: Parent (upval)
            local v1 = {
                kills = 0,
                deaths = 0,
                xp = 10,
                stuff2 = "abc",
                stuff = {},
                stuff3 = {"data"},
            }
            local v2 = {
                kills = 10,
                deaths = 4,
                extra = 5,
                stuff3 = true,
                stuff = {"abc", "xyz"},
                stuff2 = {abc = 10},
            }
            local v3 = Parent.Reconcile(v2, v1)
            expect(v3).never.to.equal(v2)
            expect(v3).never.to.equal(v1)
            expect(v3.kills).to.equal(10)
            expect(v3.deaths).to.equal(4)
            expect(v3.xp).to.equal(10)
            expect(v3.stuff[1]).to.equal("abc")
            expect(v3.stuff[2]).to.equal("xyz")
            expect(v3.extra).to.equal(5)
            expect((type(v3.stuff2))).to.equal("table")
            expect(v3.stuff2).never.to.equal(v2.stuff2)
            expect(v3.stuff2.abc).to.equal(10)
            expect((type(v3.stuff3))).to.equal("boolean")
            expect(v3.stuff3).to.equal(true)
        end)
    end)
    describe("SwapRemove", function() -- Line: 70 -- upvalues: Parent (val)
        it("should swap remove index", function() -- Line: 71 -- upvalues: Parent (upval)
            local v1 = {1, 2, 3, 4, 5}
            Parent.SwapRemove(v1, 3)
            expect(#v1).to.equal(4)
            expect(v1[3]).to.equal(5)
        end)
    end)
    describe("SwapRemoveFirstValue", function() -- Line: 79 -- upvalues: Parent (val)
        it("should swap remove first value given", function() -- Line: 80 -- upvalues: Parent (upval)
            local v1 = {"hello", "world", "goodbye", "planet"}
            Parent.SwapRemoveFirstValue(v1, "world")
            expect(#v1).to.equal(3)
            expect(v1[2]).to.equal("planet")
        end)
    end)
    describe("Map", function() -- Line: 88 -- upvalues: Parent (val)
        it("should map table", function() -- Line: 89 -- upvalues: Parent (upval)
            local v1 = Parent.Map({{FirstName = "John", LastName = "Doe"}, {FirstName = "Jane", LastName = "Smith"}}, function(a1) -- Line: 94
                return a1.FirstName .. " " .. a1.LastName
            end)
            expect(v1[1]).to.equal("John Doe")
            expect(v1[2]).to.equal("Jane Smith")
        end)
    end)
    describe("Filter", function() -- Line: 102 -- upvalues: Parent (val)
        it("should filter table", function() -- Line: 103 -- upvalues: Parent (upval)
            local v1 = Parent.Filter({10, 20, 30, 40, 50, 60, 70, 80, 90}, function(a1) -- Line: 105
                local v1 = false
                if a1 >= 30 then
                    v1 = a1 <= 60
                end
                return v1
            end)
            expect(#v1).to.equal(4)
            expect(v1[1]).to.equal(30)
            expect(v1[#v1]).to.equal(60)
        end)
    end)
    describe("Reduce", function() -- Line: 114 -- upvalues: Parent (val)
        it("should reduce table with numbers", function() -- Line: 115 -- upvalues: Parent (upval)
            local v1 = Parent.Reduce({1, 2, 3, 4, 5}, function(a1, a2) -- Line: 117
                return a1 + a2
            end)
            expect(v1).to.equal(15)
        end)
        it("should reduce table", function() -- Line: 123 -- upvalues: Parent (upval)
            local v1 = Parent.Reduce({{Score = 10}, {Score = 20}, {Score = 30}}, function(a1, a2) -- Line: 125
                return a1 + a2.Score
            end, 0)
            expect(v1).to.equal(60)
        end)
        it("should reduce table with initial value", function() -- Line: 131 -- upvalues: Parent (upval)
            local v1 = Parent.Reduce({{Score = 10}, {Score = 20}, {Score = 30}}, function(a1, a2) -- Line: 133
                return a1 + a2.Score
            end, 40)
            expect(v1).to.equal(100)
        end)
        it("should reduce functions", function() -- Line: 139 -- upvalues: Parent (upval)
            local v1 = Parent.Reduce({
                function(a1) -- Line: 140
                    return a1 * a1
                end,
                function(a1) -- Line: 143
                    return a1 * 2
                end,
            }, function(a1, a2) -- Line: 146
                return function(a1_2) -- Line: 147 -- upvalues: a1 (val), a2 (val)
                    return a1(a2(a1_2))
                end
            end)(10)
            expect(v1).to.equal(400)
        end)
    end)
    describe("Assign", function() -- Line: 156 -- upvalues: Parent (val)
        it("should assign tables", function() -- Line: 157 -- upvalues: Parent (upval)
            local v1 = Parent.Assign({a = 32, x = 100}, {b = 64, c = 128}, {a = 10, c = 100, d = 200})
            expect(v1.a).to.equal(10)
            expect(v1.b).to.equal(64)
            expect(v1.c).to.equal(100)
            expect(v1.d).to.equal(200)
            expect(v1.x).to.equal(100)
        end)
    end)
    describe("Extend", function() -- Line: 170 -- upvalues: Parent (val)
        it("should extend tables", function() -- Line: 171 -- upvalues: Parent (upval)
            local v1 = Parent.Extend({"a", "b", "c"}, {"d", "e", "f"})
            expect(table.concat(v1)).to.equal("abcdef")
        end)
    end)
    describe("Reverse", function() -- Line: 179 -- upvalues: Parent (val)
        it("should create a table in reverse", function() -- Line: 180 -- upvalues: Parent (upval)
            local v1 = Parent.Reverse({1, 2, 3})
            expect(table.concat(v1)).to.equal("321")
        end)
    end)
    describe("Shuffle", function() -- Line: 187 -- upvalues: Parent (val)
        it("should shuffle a table", function() -- Line: 188 -- upvalues: Parent (upval)
            local u0 = {1, 2, 3, 4, 5}
            expect(function() -- Line: 190 -- upvalues: Parent (upval), u0 (val)
                Parent.Shuffle(u0)
            end).never.to.throw()
        end)
    end)
    describe("Sample", function() -- Line: 196 -- upvalues: Parent (val)
        it("should sample a table", function() -- Line: 197 -- upvalues: Parent (upval)
            local v1 = Parent.Sample({1, 2, 3, 4, 5}, 3)
            expect(#v1).to.equal(3)
        end)
    end)
    describe("Flat", function() -- Line: 204 -- upvalues: Parent (val)
        it("should flatten table", function() -- Line: 205 -- upvalues: Parent (upval)
            local v1 = Parent.Flat({1, 2, 3, {4, 5, {6, 7}}}, 3)
            expect(table.concat(v1)).to.equal("1234567")
        end)
    end)
    describe("FlatMap", function() -- Line: 212 -- upvalues: Parent (val)
        it("should map and flatten table", function() -- Line: 213 -- upvalues: Parent (upval)
            local v1 = Parent.FlatMap({1, 2, 3, 4, 5, 6, 7}, function(a1) -- Line: 215
                return {a1, a1 * 2}
            end)
            expect(table.concat(v1)).to.equal("12243648510612714")
        end)
    end)
    describe("Keys", function() -- Line: 222 -- upvalues: Parent (val)
        it("should give all keys of table", function() -- Line: 223 -- upvalues: Parent (upval)
            local v1 = Parent.Keys({a = 1, b = 2, c = 3})
            expect(#v1).to.equal(3)
            expect(table.find(v1, "a")).to.be.ok()
            expect(table.find(v1, "b")).to.be.ok()
            expect(table.find(v1, "c")).to.be.ok()
        end)
    end)
    describe("Values", function() -- Line: 233 -- upvalues: Parent (val)
        it("should give all values of table", function() -- Line: 234 -- upvalues: Parent (upval)
            local v1 = Parent.Values({a = 1, b = 2, c = 3})
            expect(#v1).to.equal(3)
            expect(table.find(v1, 1)).to.be.ok()
            expect(table.find(v1, 2)).to.be.ok()
            expect(table.find(v1, 3)).to.be.ok()
        end)
    end)
    describe("Find", function() -- Line: 244 -- upvalues: Parent (val)
        it("should find item in array", function() -- Line: 245 -- upvalues: Parent (upval)
            local v1, v2 = Parent.Find({10, 20, 30}, function(a1) -- Line: 247
                return a1 == 20
            end)
            expect(v1).to.be.ok()
            expect(v2).to.equal(2)
            expect(v1).to.equal(20)
        end)
        it("should find item in dictionary", function() -- Line: 255 -- upvalues: Parent (upval)
            local v1, v2 = Parent.Find({{Score = 10}, {Score = 20}, {Score = 30}}, function(a1) -- Line: 257
                return a1.Score == 20
            end)
            expect(v1).to.be.ok()
            expect(v2).to.equal(2)
            expect(v1.Score).to.equal(20)
        end)
    end)
    describe("Every", function() -- Line: 266 -- upvalues: Parent (val)
        it("should see every value is above 20", function() -- Line: 267 -- upvalues: Parent (upval)
            local v1 = Parent.Every({21, 40, 200}, function(a1) -- Line: 269
                return a1 > 20
            end)
            expect(v1).to.equal(true)
        end)
        it("should see every value is not above 20", function() -- Line: 275 -- upvalues: Parent (upval)
            local v1 = Parent.Every({20, 40, 200}, function(a1) -- Line: 277
                return a1 > 20
            end)
            expect(v1).never.to.equal(true)
        end)
    end)
    describe("Some", function() -- Line: 284 -- upvalues: Parent (val)
        it("should see some value is above 20", function() -- Line: 285 -- upvalues: Parent (upval)
            local v1 = Parent.Some({5, 40, 1}, function(a1) -- Line: 287
                return a1 > 20
            end)
            expect(v1).to.equal(true)
        end)
        it("should see some value is not above 20", function() -- Line: 293 -- upvalues: Parent (upval)
            local v1 = Parent.Some({5, 15, 1}, function(a1) -- Line: 295
                return a1 > 20
            end)
            expect(v1).never.to.equal(true)
        end)
    end)
    describe("Truncate", function() -- Line: 302 -- upvalues: Parent (val)
        it("should truncate an array", function() -- Line: 303 -- upvalues: Parent (upval)
            local v1 = {1, 2, 3, 4, 5}
            local v2 = Parent.Truncate(v1, 3)
            expect(#v2).to.equal(3)
            expect(v2[1]).to.equal(v1[1])
            expect(v2[2]).to.equal(v1[2])
            expect(v2[3]).to.equal(v1[3])
        end)
        it("should truncate an array with out of bounds sizes", function() -- Line: 312 -- upvalues: Parent (upval)
            local u0 = {1, 2, 3, 4, 5}
            expect(function() -- Line: 314 -- upvalues: Parent (upval), u0 (val)
                Parent.Truncate(u0, -1)
            end).to.never.throw()
            expect(function() -- Line: 317 -- upvalues: Parent (upval), u0 (val)
                Parent.Truncate(u0, #u0 + 1)
            end).to.never.throw()
            local v1 = Parent.Truncate(u0, #u0 + 10)
            expect(#v1).to.equal(#u0)
            expect(v1).to.never.equal(u0)
        end)
    end)
    describe("Lock", function() -- Line: 326 -- upvalues: Parent (val)
        it("should lock a table", function() -- Line: 327 -- upvalues: Parent (upval)
            local u0 = {abc = {xyz = {num = 32}}}
            expect(function() -- Line: 329 -- upvalues: u0 (val)
                u0.abc.xyz.num = 64
            end).never.to.throw()
            local v1 = Parent.Lock(u0)
            expect(u0.abc.xyz.num).to.equal(64)
            expect(u0).to.equal(v1)
            expect(function() -- Line: 335 -- upvalues: u0 (val)
                u0.abc.xyz.num = 10
            end).to.throw()
        end)
    end)
    describe("Zip", function() -- Line: 341 -- upvalues: Parent (val)
        it("should zip arrays together", function() -- Line: 342 -- upvalues: Parent (upval)
            local v1 = {1, 2, 3, 4, 5}
            local v2 = {9, 8, 7, 6, 5}
            local v3 = {1, 1, 1, 1, 1}
            local v4 = 0
            for i, j in Parent.Zip(v1, v2, v3) do
                v4 = i
                expect(j[1]).to.equal(v1[i])
                expect(j[2]).to.equal(v2[i])
                expect(j[3]).to.equal(v3[i])
            end
            ;(expect(v4)).to.equal((math.min(#v1, #v2, #v3)))
        end)
        it("should zip arrays of different lengths together", function() -- Line: 356 -- upvalues: Parent (upval)
            local v1 = {1, 2, 3, 4, 5}
            local v2 = {9, 8, 7, 6}
            local v3 = {1, 1, 1}
            local v4 = 0
            for i, j in Parent.Zip(v1, v2, v3) do
                v4 = i
                expect(j[1]).to.equal(v1[i])
                expect(j[2]).to.equal(v2[i])
                expect(j[3]).to.equal(v3[i])
            end
            ;(expect(v4)).to.equal((math.min(#v1, #v2, #v3)))
        end)
        it("should zip maps together", function() -- Line: 370 -- upvalues: Parent (upval)
            local v1 = {a = 10, b = 20, c = 30}
            local v2 = {a = 100, b = 200, c = 300}
            local v3 = {a = 3000, b = 2000, c = 3000}
            for i, j in Parent.Zip(v1, v2, v3) do
                expect(j[1]).to.equal(v1[i])
                expect(j[2]).to.equal(v2[i])
                expect(j[3]).to.equal(v3[i])
            end
        end)
        it("should zip maps of different keys together", function() -- Line: 381 -- upvalues: Parent (upval)
            local v1 = {a = 10, b = 20, c = 30, d = 40}
            local v2 = {a = 100, b = 200, c = 300, z = 10}
            local v3 = {a = 3000, b = 2000, c = 3000, x = 0}
            for i, j in Parent.Zip(v1, v2, v3) do
                expect(j[1]).to.equal(v1[i])
                expect(j[2]).to.equal(v2[i])
                expect(j[3]).to.equal(v3[i])
            end
        end)
    end)
    describe("IsEmpty", function() -- Line: 393 -- upvalues: Parent (val)
        it("should detect that table is empty", function() -- Line: 394 -- upvalues: Parent (upval)
            local v1 = Parent.IsEmpty({})
            expect(v1).to.equal(true)
        end)
        it("should detect that array is not empty", function() -- Line: 400 -- upvalues: Parent (upval)
            local v1 = Parent.IsEmpty({10, 20, 30})
            expect(v1).to.equal(false)
        end)
        it("should detect that dictionary is not empty", function() -- Line: 406 -- upvalues: Parent (upval)
            local v1 = Parent.IsEmpty({a = 10, b = 20, c = 30})
            expect(v1).to.equal(false)
        end)
    end)
    describe("JSON", function() -- Line: 413 -- upvalues: Parent (val)
        it("should encode json", function() -- Line: 414 -- upvalues: Parent (upval)
            local v1 = Parent.EncodeJSON({hello = "world"})
            expect(v1).to.equal("{\"hello\":\"world\"}")
        end)
        it("should decode json", function() -- Line: 420 -- upvalues: Parent (upval)
            local v1 = Parent.DecodeJSON("{\"hello\":\"world\"}")
            expect(v1).to.be.a("table")
            expect(v1.hello).to.equal("world")
        end)
    end)
end