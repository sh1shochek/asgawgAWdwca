-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local script_Parent = require(script.Parent);
    describe("Copy (Deep)", function() -- Line: 4
        -- upvalues: script_Parent (copy)
        it("should create a deep table copy", function() -- Line: 5
            -- upvalues: script_Parent (ref)
            local v1 = {
                a = {
                    b = {
                        c = {
                            d = 32
                        }
                    }
                }
            };
            local v2 = script_Parent.Copy(v1, true);
            expect(v1).never.to.equal(v2);
            expect(v1.a).never.to.equal(v2.a);
            expect(v2.a.b.c.d).to.equal(v1.a.b.c.d);
        end);
    end);
    describe("Copy (Shallow)", function() -- Line: 14
        -- upvalues: script_Parent (copy)
        it("should create a shallow dictionary copy", function() -- Line: 15
            -- upvalues: script_Parent (ref)
            local v3 = {
                a = {
                    b = {
                        c = {
                            d = 32
                        }
                    }
                }
            };
            local v4 = script_Parent.Copy(v3);
            expect(v4).never.to.equal(v3);
            expect(v4.a).to.equal(v3.a);
            expect(v4.a.b.c.d).to.equal(v3.a.b.c.d);
        end);
        it("should create a shallow array copy", function() -- Line: 23
            -- upvalues: script_Parent (ref)
            local v5 = { 10, 20, 30, 40 };
            local v6 = script_Parent.Copy(v5);
            expect(v6).never.to.equal(v5);

            for i, v in ipairs(v5) do
                expect(v6[i]).to.equal(v);
            end;
        end);
    end);
    describe("Sync", function() -- Line: 33
        -- upvalues: script_Parent (copy)
        it("should sync tables", function() -- Line: 34
            -- upvalues: script_Parent (ref)
            local v7 = {
                a = 32,
                b = 64,
                c = 128,
                e = {
                    h = 1
                }
            };
            local v8 = script_Parent.Sync({
                a = 32,
                b = 10,
                d = 1,
                e = {
                    h = 2,
                    n = 2
                },
                f = {
                    x = 10
                }
            }, v7);
            expect(v8.a).to.equal(v7.a);
            expect(v8.b).to.equal(10);
            expect(v8.c).to.equal(v7.c);
            expect(v8.d).never.to.be.ok();
            expect(v8.e.h).to.equal(2);
            expect(v8.e.n).never.to.be.ok();
            expect(v8.f).never.to.be.ok();
        end);
    end);
    describe("Reconcile", function() -- Line: 48
        -- upvalues: script_Parent (copy)
        it("should reconcile table", function() -- Line: 49
            -- upvalues: script_Parent (ref)
            local v9 = {
                kills = 0,
                deaths = 0,
                xp = 10,
                stuff2 = "abc",
                stuff = {},
                stuff3 = { "data" }
            };
            local v10 = {
                kills = 10,
                deaths = 4,
                extra = 5,
                stuff3 = true,
                stuff = { "abc", "xyz" },
                stuff2 = {
                    abc = 10
                }
            };
            local v11 = script_Parent.Reconcile(v10, v9);
            expect(v11).never.to.equal(v10);
            expect(v11).never.to.equal(v9);
            expect(v11.kills).to.equal(10);
            expect(v11.deaths).to.equal(4);
            expect(v11.xp).to.equal(10);
            expect(v11.stuff[1]).to.equal("abc");
            expect(v11.stuff[2]).to.equal("xyz");
            expect(v11.extra).to.equal(5);
            expect((type(v11.stuff2))).to.equal("table");
            expect(v11.stuff2).never.to.equal(v10.stuff2);
            expect(v11.stuff2.abc).to.equal(10);
            expect((type(v11.stuff3))).to.equal("boolean");
            expect(v11.stuff3).to.equal(true);
        end);
    end);
    describe("SwapRemove", function() -- Line: 70
        -- upvalues: script_Parent (copy)
        it("should swap remove index", function() -- Line: 71
            -- upvalues: script_Parent (ref)
            local v12 = { 1, 2, 3, 4, 5 };
            script_Parent.SwapRemove(v12, 3);
            expect(#v12).to.equal(4);
            expect(v12[3]).to.equal(5);
        end);
    end);
    describe("SwapRemoveFirstValue", function() -- Line: 79
        -- upvalues: script_Parent (copy)
        it("should swap remove first value given", function() -- Line: 80
            -- upvalues: script_Parent (ref)
            local v13 = { "hello", "world", "goodbye", "planet" };
            script_Parent.SwapRemoveFirstValue(v13, "world");
            expect(#v13).to.equal(3);
            expect(v13[2]).to.equal("planet");
        end);
    end);
    describe("Map", function() -- Line: 88
        -- upvalues: script_Parent (copy)
        it("should map table", function() -- Line: 89
            -- upvalues: script_Parent (ref)
            local v15 = script_Parent.Map({ {
                    FirstName = "John",
                    LastName = "Doe"
                }, {
                    FirstName = "Jane",
                    LastName = "Smith"
                } }, function(p14) -- Line: 94
                return p14.FirstName .. " " .. p14.LastName;
            end);
            expect(v15[1]).to.equal("John Doe");
            expect(v15[2]).to.equal("Jane Smith");
        end);
    end);
    describe("Filter", function() -- Line: 102
        -- upvalues: script_Parent (copy)
        it("should filter table", function() -- Line: 103
            -- upvalues: script_Parent (ref)
            local v18 = script_Parent.Filter({ 10, 20, 30, 40, 50, 60, 70, 80, 90 }, function(p16) -- Line: 105
                local v17;

                if p16 >= 30 then
                    v17 = p16 <= 60;
                else
                    v17 = false;
                end;

                return v17;
            end);
            expect(#v18).to.equal(4);
            expect(v18[1]).to.equal(30);
            expect(v18[#v18]).to.equal(60);
        end);
    end);
    describe("Reduce", function() -- Line: 114
        -- upvalues: script_Parent (copy)
        it("should reduce table with numbers", function() -- Line: 115
            -- upvalues: script_Parent (ref)
            local v21 = script_Parent.Reduce({ 1, 2, 3, 4, 5 }, function(p19, p20) -- Line: 117
                return p19 + p20;
            end);
            expect(v21).to.equal(15);
        end);
        it("should reduce table", function() -- Line: 123
            -- upvalues: script_Parent (ref)
            local v24 = script_Parent.Reduce({ {
                    Score = 10
                }, {
                    Score = 20
                }, {
                    Score = 30
                } }, function(p22, p23) -- Line: 125
                return p22 + p23.Score;
            end, 0);
            expect(v24).to.equal(60);
        end);
        it("should reduce table with initial value", function() -- Line: 131
            -- upvalues: script_Parent (ref)
            local v27 = script_Parent.Reduce({ {
                    Score = 10
                }, {
                    Score = 20
                }, {
                    Score = 30
                } }, function(p25, p26) -- Line: 133
                return p25 + p26.Score;
            end, 40);
            expect(v27).to.equal(100);
        end);
        it("should reduce functions", function() -- Line: 139
            -- upvalues: script_Parent (ref)
            local v33 = script_Parent.Reduce({ function(p28) -- Line: 140, Name: Square
                    return p28 * p28;
                end, function(p29) -- Line: 143, Name: Double
                    return p29 * 2;
                end }, function(u30, u31) -- Line: 146
                return function(p32) -- Line: 147
                    -- upvalues: u30 (copy), u31 (copy)
                    return u30(u31(p32));
                end;
            end)(10);
            expect(v33).to.equal(400);
        end);
    end);
    describe("Assign", function() -- Line: 156
        -- upvalues: script_Parent (copy)
        it("should assign tables", function() -- Line: 157
            -- upvalues: script_Parent (ref)
            local v34 = script_Parent.Assign({
                a = 32,
                x = 100
            }, {
                b = 64,
                c = 128
            }, {
                a = 10,
                c = 100,
                d = 200
            });
            expect(v34.a).to.equal(10);
            expect(v34.b).to.equal(64);
            expect(v34.c).to.equal(100);
            expect(v34.d).to.equal(200);
            expect(v34.x).to.equal(100);
        end);
    end);
    describe("Extend", function() -- Line: 170
        -- upvalues: script_Parent (copy)
        it("should extend tables", function() -- Line: 171
            -- upvalues: script_Parent (ref)
            local v35 = script_Parent.Extend({ "a", "b", "c" }, { "d", "e", "f" });
            expect(table.concat(v35)).to.equal("abcdef");
        end);
    end);
    describe("Reverse", function() -- Line: 179
        -- upvalues: script_Parent (copy)
        it("should create a table in reverse", function() -- Line: 180
            -- upvalues: script_Parent (ref)
            local v36 = script_Parent.Reverse({ 1, 2, 3 });
            expect(table.concat(v36)).to.equal("321");
        end);
    end);
    describe("Shuffle", function() -- Line: 187
        -- upvalues: script_Parent (copy)
        it("should shuffle a table", function() -- Line: 188
            -- upvalues: script_Parent (ref)
            local u37 = { 1, 2, 3, 4, 5 };
            expect(function() -- Line: 190
                -- upvalues: script_Parent (ref), u37 (copy)
                script_Parent.Shuffle(u37);
            end).never.to.throw();
        end);
    end);
    describe("Sample", function() -- Line: 196
        -- upvalues: script_Parent (copy)
        it("should sample a table", function() -- Line: 197
            -- upvalues: script_Parent (ref)
            local v38 = script_Parent.Sample({ 1, 2, 3, 4, 5 }, 3);
            expect(#v38).to.equal(3);
        end);
    end);
    describe("Flat", function() -- Line: 204
        -- upvalues: script_Parent (copy)
        it("should flatten table", function() -- Line: 205
            -- upvalues: script_Parent (ref)
            local v39 = script_Parent.Flat({ 1, 2, 3, { 4, 5, { 6, 7 } } }, 3);
            expect(table.concat(v39)).to.equal("1234567");
        end);
    end);
    describe("FlatMap", function() -- Line: 212
        -- upvalues: script_Parent (copy)
        it("should map and flatten table", function() -- Line: 213
            -- upvalues: script_Parent (ref)
            local v41 = script_Parent.FlatMap({ 1, 2, 3, 4, 5, 6, 7 }, function(p40) -- Line: 215
                return { p40, p40 * 2 };
            end);
            expect(table.concat(v41)).to.equal("12243648510612714");
        end);
    end);
    describe("Keys", function() -- Line: 222
        -- upvalues: script_Parent (copy)
        it("should give all keys of table", function() -- Line: 223
            -- upvalues: script_Parent (ref)
            local v42 = script_Parent.Keys({
                a = 1,
                b = 2,
                c = 3
            });
            expect(#v42).to.equal(3);
            expect(table.find(v42, "a")).to.be.ok();
            expect(table.find(v42, "b")).to.be.ok();
            expect(table.find(v42, "c")).to.be.ok();
        end);
    end);
    describe("Values", function() -- Line: 233
        -- upvalues: script_Parent (copy)
        it("should give all values of table", function() -- Line: 234
            -- upvalues: script_Parent (ref)
            local v43 = script_Parent.Values({
                a = 1,
                b = 2,
                c = 3
            });
            expect(#v43).to.equal(3);
            expect(table.find(v43, 1)).to.be.ok();
            expect(table.find(v43, 2)).to.be.ok();
            expect(table.find(v43, 3)).to.be.ok();
        end);
    end);
    describe("Find", function() -- Line: 244
        -- upvalues: script_Parent (copy)
        it("should find item in array", function() -- Line: 245
            -- upvalues: script_Parent (ref)
            local v45, v46 = script_Parent.Find({ 10, 20, 30 }, function(p44) -- Line: 247
                return p44 == 20;
            end);
            expect(v45).to.be.ok();
            expect(v46).to.equal(2);
            expect(v45).to.equal(20);
        end);
        it("should find item in dictionary", function() -- Line: 255
            -- upvalues: script_Parent (ref)
            local v48, v49 = script_Parent.Find({ {
                    Score = 10
                }, {
                    Score = 20
                }, {
                    Score = 30
                } }, function(p47) -- Line: 257
                return p47.Score == 20;
            end);
            expect(v48).to.be.ok();
            expect(v49).to.equal(2);
            expect(v48.Score).to.equal(20);
        end);
    end);
    describe("Every", function() -- Line: 266
        -- upvalues: script_Parent (copy)
        it("should see every value is above 20", function() -- Line: 267
            -- upvalues: script_Parent (ref)
            local v51 = script_Parent.Every({ 21, 40, 200 }, function(p50) -- Line: 269
                return p50 > 20;
            end);
            expect(v51).to.equal(true);
        end);
        it("should see every value is not above 20", function() -- Line: 275
            -- upvalues: script_Parent (ref)
            local v53 = script_Parent.Every({ 20, 40, 200 }, function(p52) -- Line: 277
                return p52 > 20;
            end);
            expect(v53).never.to.equal(true);
        end);
    end);
    describe("Some", function() -- Line: 284
        -- upvalues: script_Parent (copy)
        it("should see some value is above 20", function() -- Line: 285
            -- upvalues: script_Parent (ref)
            local v55 = script_Parent.Some({ 5, 40, 1 }, function(p54) -- Line: 287
                return p54 > 20;
            end);
            expect(v55).to.equal(true);
        end);
        it("should see some value is not above 20", function() -- Line: 293
            -- upvalues: script_Parent (ref)
            local v57 = script_Parent.Some({ 5, 15, 1 }, function(p56) -- Line: 295
                return p56 > 20;
            end);
            expect(v57).never.to.equal(true);
        end);
    end);
    describe("Truncate", function() -- Line: 302
        -- upvalues: script_Parent (copy)
        it("should truncate an array", function() -- Line: 303
            -- upvalues: script_Parent (ref)
            local v58 = { 1, 2, 3, 4, 5 };
            local v59 = script_Parent.Truncate(v58, 3);
            expect(#v59).to.equal(3);
            expect(v59[1]).to.equal(v58[1]);
            expect(v59[2]).to.equal(v58[2]);
            expect(v59[3]).to.equal(v58[3]);
        end);
        it("should truncate an array with out of bounds sizes", function() -- Line: 312
            -- upvalues: script_Parent (ref)
            local u60 = { 1, 2, 3, 4, 5 };
            expect(function() -- Line: 314
                -- upvalues: script_Parent (ref), u60 (copy)
                script_Parent.Truncate(u60, -1);
            end).to.never.throw();
            expect(function() -- Line: 317
                -- upvalues: script_Parent (ref), u60 (copy)
                script_Parent.Truncate(u60, #u60 + 1);
            end).to.never.throw();
            local v61 = script_Parent.Truncate(u60, #u60 + 10);
            expect(#v61).to.equal(#u60);
            expect(v61).to.never.equal(u60);
        end);
    end);
    describe("Lock", function() -- Line: 326
        -- upvalues: script_Parent (copy)
        it("should lock a table", function() -- Line: 327
            -- upvalues: script_Parent (ref)
            local u62 = {
                abc = {
                    xyz = {
                        num = 32
                    }
                }
            };
            expect(function() -- Line: 329
                -- upvalues: u62 (copy)
                u62.abc.xyz.num = 64;
            end).never.to.throw();
            local v63 = script_Parent.Lock(u62);
            expect(u62.abc.xyz.num).to.equal(64);
            expect(u62).to.equal(v63);
            expect(function() -- Line: 335
                -- upvalues: u62 (copy)
                u62.abc.xyz.num = 10;
            end).to.throw();
        end);
    end);
    describe("Zip", function() -- Line: 341
        -- upvalues: script_Parent (copy)
        it("should zip arrays together", function() -- Line: 342
            -- upvalues: script_Parent (ref)
            local v64 = { 1, 2, 3, 4, 5 };
            local v65 = { 9, 8, 7, 6, 5 };
            local v66 = { 1, 1, 1, 1, 1 };
            local v67 = 0;

            for i, v in script_Parent.Zip(v64, v65, v66) do
                expect(v[1]).to.equal(v64[i]);
                expect(v[2]).to.equal(v65[i]);
                expect(v[3]).to.equal(v66[i]);
                v67 = i;
            end;

            expect(v67).to.equal((math.min(#v64, #v65, #v66)));
        end);
        it("should zip arrays of different lengths together", function() -- Line: 356
            -- upvalues: script_Parent (ref)
            local v68 = { 1, 2, 3, 4, 5 };
            local v69 = { 9, 8, 7, 6 };
            local v70 = { 1, 1, 1 };
            local v71 = 0;

            for i, v in script_Parent.Zip(v68, v69, v70) do
                expect(v[1]).to.equal(v68[i]);
                expect(v[2]).to.equal(v69[i]);
                expect(v[3]).to.equal(v70[i]);
                v71 = i;
            end;

            expect(v71).to.equal((math.min(#v68, #v69, #v70)));
        end);
        it("should zip maps together", function() -- Line: 370
            -- upvalues: script_Parent (ref)
            local v72 = {
                a = 10,
                b = 20,
                c = 30
            };
            local v73 = {
                a = 100,
                b = 200,
                c = 300
            };
            local v74 = {
                a = 3000,
                b = 2000,
                c = 3000
            };

            for i, v in script_Parent.Zip(v72, v73, v74) do
                expect(v[1]).to.equal(v72[i]);
                expect(v[2]).to.equal(v73[i]);
                expect(v[3]).to.equal(v74[i]);
            end;
        end);
        it("should zip maps of different keys together", function() -- Line: 381
            -- upvalues: script_Parent (ref)
            local v75 = {
                a = 10,
                b = 20,
                c = 30,
                d = 40
            };
            local v76 = {
                a = 100,
                b = 200,
                c = 300,
                z = 10
            };
            local v77 = {
                a = 3000,
                b = 2000,
                c = 3000,
                x = 0
            };

            for i, v in script_Parent.Zip(v75, v76, v77) do
                expect(v[1]).to.equal(v75[i]);
                expect(v[2]).to.equal(v76[i]);
                expect(v[3]).to.equal(v77[i]);
            end;
        end);
    end);
    describe("IsEmpty", function() -- Line: 393
        -- upvalues: script_Parent (copy)
        it("should detect that table is empty", function() -- Line: 394
            -- upvalues: script_Parent (ref)
            local v78 = script_Parent.IsEmpty({});
            expect(v78).to.equal(true);
        end);
        it("should detect that array is not empty", function() -- Line: 400
            -- upvalues: script_Parent (ref)
            local v79 = script_Parent.IsEmpty({ 10, 20, 30 });
            expect(v79).to.equal(false);
        end);
        it("should detect that dictionary is not empty", function() -- Line: 406
            -- upvalues: script_Parent (ref)
            local v80 = script_Parent.IsEmpty({
                a = 10,
                b = 20,
                c = 30
            });
            expect(v80).to.equal(false);
        end);
    end);
    describe("JSON", function() -- Line: 413
        -- upvalues: script_Parent (copy)
        it("should encode json", function() -- Line: 414
            -- upvalues: script_Parent (ref)
            local v81 = script_Parent.EncodeJSON({
                hello = "world"
            });
            expect(v81).to.equal("{\"hello\":\"world\"}");
        end);
        it("should decode json", function() -- Line: 420
            -- upvalues: script_Parent (ref)
            local v82 = script_Parent.DecodeJSON("{\"hello\":\"world\"}");
            expect(v82).to.be.a("table");
            expect(v82.hello).to.equal("world");
        end);
    end);
end;