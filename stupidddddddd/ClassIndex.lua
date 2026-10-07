-- ReplicatedStorage.Packages.DebugTools.Client.Vendor.ClassIndex
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Vendor.ClassIndex
-- Decompile time: 2.02 ms

local u3 = require(script["generated-api-dump"])
local u7 = require(script["spritesheet-data"])
local v1 = {Public = {}, Private = {}}
v1.Private.SpritesheetClassMap = {}

function v1.Public.FetchApiDump() -- Line: 33 -- upvalues: u3 (val)
    return u3
end

function v1.Public.FetchAllClasses() -- Line: 53 -- upvalues: u3 (val)
    local v1 = {}
    for i in u3.Classes do
        table.insert(v1, i)
    end
    return v1
end

function v1.Public.IsClassRegistered(a1) -- Line: 83 -- upvalues: u3 (val) -- types: a1: string
    if not u3.Classes[a1] then
        return false
    end
    return true
end

function v1.Public.FetchClassMembers(a1, a2, a3) -- Line: 127
    -- upvalues: u3 (val)
    local v1 = u3.Classes[a1]
    local v2 = {}
    if not a2 then
        a2 = "None"
    end
    local v3 = nil
    local v4 = nil
    for i, j in v1.Members, v3, v4 do
        if not j.Tags.NotScriptable or a3 then
            if type(j.Security) ~= "string" then
                if j.Security.Read == a2 then
                    table.insert(v2, i)
                end
            elseif j.Security == a2 then
                table.insert(v2, i)
            end
        end
    end
    return v2
end

function v1.Public.FetchClassIcon(a1) -- Line: 185 -- upvalues: u7 (val) -- types: a1: string
    local File = u7.Content[a1] or u7.Content.File
    return {
        Image = "http://www.roblox.com/asset/?id=16231724441",
        ImageRectOffset = Vector2.new(File.x, File.y),
        ImageRectSize = Vector2.new(File.w, File.h),
    }
end

function v1.Public.FetchClassMemberType(a1, a2) -- Line: 224 -- upvalues: u3 (val) -- types: a1: string, a2: string
    return u3.Classes[a1].Members[a2].MemberType
end

function v1.Public.FetchClassMemberTags(a1, a2) -- Line: 250 -- upvalues: u3 (val) -- types: a1: string, a2: string
    local v1 = u3.Classes[a1].Members[a2]
    local v2 = {}
    for i, j in v1.Tags do
        v2[i] = j
    end
    return v2
end

function v1.Public.FetchClassMemberSecurity(a1, a2) -- Line: 283 -- upvalues: u3 (val) -- types: a1: string, a2: string
    local v1 = u3.Classes[a1].Members[a2]
    local v2 = {}
    if type(v1.Security) == "table" then
        for i, j in v1.Security do
            v2[i] = j
        end
        return v2
    end
    v2.Read = v1.Security
    v2.Write = v1.Security
    return v2
end

function v1.Public.FetchClassMemberThreadSafety(a1, a2) -- Line: 327
    -- upvalues: u3 (val)
    return u3.Classes[a1].Members[a2].ThreadSafety
end

function v1.Public.FetchClassSuperclass(a1) -- Line: 350 -- upvalues: u3 (val) -- types: a1: string
    return u3.Classes[a1].Superclass
end

function v1.Public.FetchClassSuperclasses(a1) -- Line: 373 -- upvalues: u3 (val) -- types: a1: string
    local v1 = u3.Classes[a1]
    local v2 = {}
    while v1 do
        table.insert(v2, v1.Superclass)
        v1 = u3.Classes[v1.Superclass]
    end
    return v2
end

return v1.Public