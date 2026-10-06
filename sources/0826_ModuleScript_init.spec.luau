-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local script_Parent = require(script.Parent);
    it("Should be able to access the raw API dump", function() -- Line: 4
        -- upvalues: script_Parent (copy)
        local v1 = script_Parent.FetchApiDump();
        expect(v1).never.to.equal(nil);
        expect(v1.Classes).never.to.equal(nil);
        expect(v1.Version).never.to.equal(nil);
    end);
    it("Should be able to fetch all classes from the raw API dump", function() -- Line: 12
        -- upvalues: script_Parent (copy)
        local v2 = script_Parent.FetchAllClasses();
        expect(#v2).never.to.equal(0);
        expect(table.find(v2, "Workspace")).never.to.equal(nil);
    end);
    it("Should be able to query class names", function() -- Line: 19
        -- upvalues: script_Parent (copy)
        expect(script_Parent.IsClassRegistered("Workspace")).to.equal(true);
        expect(script_Parent.IsClassRegistered("FakeWorkspace")).to.equal(false);
    end);
    it("Should be able to query class members", function() -- Line: 24
        -- upvalues: script_Parent (copy)
        local v3 = script_Parent.FetchClassMembers("Workspace");
        expect(#v3).never.to.equal(0);

        for _, v in v3 do
            expect(workspace[v]).never.to.equal(nil);
        end;
    end);
    it("Should be able to fetch the member type from a class", function() -- Line: 34
        -- upvalues: script_Parent (copy)
        local v4 = script_Parent.FetchClassMemberType("Workspace", "Gravity");
        expect(v4).to.equal("Property");
    end);
    it("Should be able to fetch the tags for a member of a class", function() -- Line: 40
        -- upvalues: script_Parent (copy)
        local v5 = script_Parent.FetchClassMemberTags("Workspace", "StreamingMinRadius");
        expect(v5.NotScriptable).to.equal(true);
    end);
    it("Should be able to fetch the security for a member of a class", function() -- Line: 46
        -- upvalues: script_Parent (copy)
        local v6 = script_Parent.FetchClassMemberSecurity("Workspace", "StreamingEnabled");
        expect(v6.Read).to.equal("None");
        expect(v6.Write).to.equal("PluginSecurity");
    end);
    it("Should be able to fetch the thread safety for a member of a class", function() -- Line: 53
        -- upvalues: script_Parent (copy)
        local v7 = script_Parent.FetchClassMemberThreadSafety("Workspace", "StreamingEnabled");
        expect(v7).to.equal("ReadSafe");
    end);
    it("Should be able to query class superclass", function() -- Line: 59
        -- upvalues: script_Parent (copy)
        local v8 = script_Parent.FetchClassSuperclass("Workspace");
        expect(v8).to.equal("WorldRoot");
    end);
    it("Should be able to query class superclasses", function() -- Line: 65
        -- upvalues: script_Parent (copy)
        local v9 = script_Parent.FetchClassSuperclasses("Workspace");
        expect(#v9).never.to.equal(0);
        expect(v9[#v9]).to.equal("<<<ROOT>>>");
        expect(v9[1]).to.equal("WorldRoot");
    end);
end;