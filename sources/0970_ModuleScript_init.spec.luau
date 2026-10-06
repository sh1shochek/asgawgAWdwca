-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local script_Parent = require(script.Parent);
    describe("Trove", function() -- Line: 4
        -- upvalues: script_Parent (copy)
        local u1 = nil;
        beforeEach(function() -- Line: 7
            -- upvalues: u1 (ref), script_Parent (ref)
            u1 = script_Parent.new();
        end);
        afterEach(function() -- Line: 11
            -- upvalues: u1 (ref)
            if u1 then
                u1:Destroy();
                u1 = nil;
            end;
        end);
        it("should add and clean up roblox instance", function() -- Line: 18
            -- upvalues: u1 (ref)
            local Part = Instance.new("Part");
            Part.Parent = workspace;
            u1:Add(Part);
            u1:Destroy();
            expect(Part.Parent).to.equal(nil);
        end);
        it("should add and clean up roblox connection", function() -- Line: 26
            -- upvalues: u1 (ref)
            local v2 = workspace.Changed:Connect(function() -- Line: 27
            end);
            u1:Add(v2);
            u1:Destroy();
            expect(v2.Connected).to.equal(false);
        end);
        it("should add and clean up a table with a destroy method", function() -- Line: 33
            -- upvalues: u1 (ref)
            local v4 = {
                Destroyed = false,

                Destroy = function(p3) -- Line: 35, Name: Destroy
                    p3.Destroyed = true;
                end
            };
            u1:Add(v4);
            u1:Destroy();
            expect(v4.Destroyed).to.equal(true);
        end);
        it("should add and clean up a table with a disconnect method", function() -- Line: 43
            -- upvalues: u1 (ref)
            local v6 = {
                Connected = true,

                Disconnect = function(p5) -- Line: 45, Name: Disconnect
                    p5.Connected = false;
                end
            };
            u1:Add(v6);
            u1:Destroy();
            expect(v6.Connected).to.equal(false);
        end);
        it("should add and clean up a function", function() -- Line: 53
            -- upvalues: u1 (ref)
            local u7 = false;
            u1:Add(function() -- Line: 55
                -- upvalues: u7 (ref)
                u7 = true;
            end);
            u1:Destroy();
            expect(u7).to.equal(true);
        end);
        it("should allow a custom cleanup method", function() -- Line: 62
            -- upvalues: u1 (ref)
            local v9 = {
                Cleaned = false,

                Cleanup = function(p8) -- Line: 64, Name: Cleanup
                    p8.Cleaned = true;
                end
            };
            u1:Add(v9, "Cleanup");
            u1:Destroy();
            expect(v9.Cleaned).to.equal(true);
        end);
        it("should return the object passed to add", function() -- Line: 72
            -- upvalues: u1 (ref)
            local Part = Instance.new("Part");
            local v10 = u1:Add(Part);
            expect(Part).to.equal(v10);
            u1:Destroy();
        end);
        it("should fail to add object without proper cleanup method", function() -- Line: 79
            -- upvalues: u1 (ref)
            local u11 = {};
            expect(function() -- Line: 81
                -- upvalues: u1 (ref), u11 (copy)
                u1:Add(u11);
            end).to.throw();
        end);
        it("should construct an object and add it", function() -- Line: 86
            -- upvalues: u1 (ref)
            local u12 = {};
            u12.__index = u12;

            function u12.new(p13) -- Line: 89
                -- upvalues: u12 (copy)
                local v14 = setmetatable({}, u12);
                v14._msg = p13;
                v14._destroyed = false;

                return v14;
            end;

            function u12.Destroy(p15) -- Line: 95
                p15._destroyed = true;
            end;

            local v16 = u1:Construct(u12, "abc");
            expect((typeof(v16))).to.equal("table");
            expect((getmetatable(v16))).to.equal(u12);
            expect(v16._msg).to.equal("abc");
            expect(v16._destroyed).to.equal(false);
            u1:Destroy();
            expect(v16._destroyed).to.equal(true);
        end);
        it("should connect to a signal", function() -- Line: 108
            -- upvalues: u1 (ref)
            local v17 = u1:Connect(workspace.Changed, function() -- Line: 109
            end);
            expect((typeof(v17))).to.equal("RBXScriptConnection");
            expect(v17.Connected).to.equal(true);
            u1:Destroy();
            expect(v17.Connected).to.equal(false);
        end);
        it("should remove an object", function() -- Line: 116
            -- upvalues: u1 (ref)
            local v18 = u1:Connect(workspace.Changed, function() -- Line: 117
            end);
            expect(u1:Remove(v18)).to.equal(true);
            expect(v18.Connected).to.equal(false);
        end);
        it("should not remove an object not in the trove", function() -- Line: 122
            -- upvalues: u1 (ref)
            local v19 = workspace.Changed:Connect(function() -- Line: 123
            end);
            expect(u1:Remove(v19)).to.equal(false);
            expect(v19.Connected).to.equal(true);
            v19:Disconnect();
        end);
        it("should attach to instance", function() -- Line: 129
            -- upvalues: u1 (ref)
            local Part = Instance.new("Part");
            Part.Parent = workspace;
            local v20 = u1:AttachToInstance(Part);
            expect(v20.Connected).to.equal(true);
            Part:Destroy();
            expect(v20.Connected).to.equal(false);
        end);
        it("should fail to attach to instance not in hierarchy", function() -- Line: 138
            -- upvalues: u1 (ref)
            local Part = Instance.new("Part");
            expect(function() -- Line: 140
                -- upvalues: u1 (ref), Part (copy)
                u1:AttachToInstance(Part);
            end).to.throw();
        end);
        it("should extend itself", function() -- Line: 145
            -- upvalues: u1 (ref), script_Parent (ref)
            local v21 = u1:Extend();
            local u22 = false;
            v21:Add(function() -- Line: 148
                -- upvalues: u22 (ref)
                u22 = true;
            end);
            expect(v21).to.be.a("table");
            expect((getmetatable(v21))).to.equal(script_Parent);
            u1:Clean();
            expect(u22).to.equal(true);
        end);
        it("should clone an instance", function() -- Line: 157
            -- upvalues: u1 (ref)
            local v23 = u1:Construct(Instance.new, "Part");
            v23.Name = "TroveCloneTest";
            local v24 = u1:Clone(v23);
            expect((typeof(v24))).to.equal("Instance");
            expect(v24).to.never.equal(v23);
            expect(v24.Name).to.equal("TroveCloneTest");
            expect(v23.Name).to.equal(v24.Name);
        end);
        it("should clean up a thread", function() -- Line: 168
            -- upvalues: u1 (ref)
            local coroutine_create_ret = coroutine.create(function() -- Line: 169
            end);
            u1:Add(coroutine_create_ret);
            expect(coroutine.status(coroutine_create_ret)).to.equal("suspended");
            u1:Clean();
            expect(coroutine.status(coroutine_create_ret)).to.equal("dead");
        end);
        it("should not allow objects added during cleanup", function() -- Line: 176
            -- upvalues: u1 (ref)
            expect(function() -- Line: 177
                -- upvalues: u1 (ref)
                u1:Add(function() -- Line: 178
                    -- upvalues: u1 (ref)
                    u1:Add(function() -- Line: 179
                    end);
                end);
                u1:Clean();
            end).to.throw();
        end);
        it("should not allow objects to be removed during cleanup", function() -- Line: 185
            -- upvalues: u1 (ref)
            expect(function() -- Line: 186
                -- upvalues: u1 (ref)
                local function u25() -- Line: 187
                end;

                u1:Add(u25);
                u1:Add(function() -- Line: 189
                    -- upvalues: u1 (ref), u25 (copy)
                    u1:Remove(u25);
                end);
                u1:Clean();
            end).to.throw();
        end);
    end);
end;