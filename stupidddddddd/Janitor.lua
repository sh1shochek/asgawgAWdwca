-- ReplicatedStorage.Shared.Janitor
-- Script path: ReplicatedStorage.Shared.Janitor
-- Decompile time: 5.07 ms

local GetPromiseLibrary = require(script.GetPromiseLibrary)
local RbxScriptConnection = require(script.RbxScriptConnection)
local Symbol = require(script.Symbol)
local u13, u14 = GetPromiseLibrary()
local IndicesReference = Symbol("IndicesReference")
local LinkToInstanceIndex = Symbol("LinkToInstanceIndex")
local u21 = {
    ClassName = "Janitor",
    CurrentlyCleaning = true,
    SuppressInstanceReDestroy = false,
    [IndicesReference] = nil,
}
u21.__index = u21
local u26 = {["function"] = true, thread = true, RBXScriptConnection = "Disconnect"}

function u21.new() -- Line: 62 -- upvalues: IndicesReference (val), u21 (val)
    return (setmetatable({CurrentlyCleaning = false, [IndicesReference] = nil}, u21))
end

function u21.Is(a1) -- Line: 75 -- upvalues: u21 (val)
    local v1 = false
    if type(a1) == "table" then
        v1 = (getmetatable(a1)) == u21
    end
    return v1
end

function u21:Add(a2, a3, a4) -- Line: 159 -- upvalues: IndicesReference (val), u26 (val)
    local v1
    if a4 then
        self:Remove(a4)
        v1 = self[IndicesReference]
        if not v1 then
            self[IndicesReference] = {}
        end
        v1[a4] = a2
    end
    v1 = typeof(a2)
    local v2 = a3 or u26[v1] or "Destroy"
    if v1 == "function" then
        if v2 ~= true then
            warn(string.format(
                "Object is a %s and as such expected `true?` for the method name and instead got %s. Traceback: %s",
                v1,
                tostring(v2),
                debug.traceback(nil, 2)
            ))
        end
    elseif v1 ~= "thread" then
        if not a2[v2] then
            warn(string.format(
                "Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s",
                tostring(a2),
                tostring(v2),
                debug.traceback(nil, 2)
            ))
        end
    elseif v2 ~= true then
        warn(string.format(
            "Object is a %s and as such expected `true?` for the method name and instead got %s. Traceback: %s",
            v1,
            tostring(v2),
            debug.traceback(nil, 2)
        ))
    end
    self[a2] = v2
    return a2
end

function u21.AddPromise(a1, a2) -- Line: 215 -- upvalues: u13 (val), u14 (val)
    if not u13 then
        return a2
    end
    if not u14.is(a2) then
        error(string.format(
            "Invalid argument #1 to 'Janitor:AddPromise' (Promise expected, got %s (%s)) Traceback: %s",
            typeof(a2),
            tostring(a2),
            debug.traceback(nil, 2)
        ))
    end
    if (a2:getStatus()) ~= u14.Status.Started then
        return a2
    end
    local v1 = newproxy(false)
    local v2 = a1:Add(u14.new(function(a1, a2_2, a3) -- Line: 223 -- upvalues: a2 (val)
        if a3(function() -- Line: 224 -- upvalues: a2 (upval)
            local v0, v1
            a2:cancel()
            return
        end) then
            return
        end
        a1(a2)
    end), "cancel", v1)
    v2:finallyCall(a1.Remove, a1, v1)
    return v2
end

function u21:Remove(a2) -- Line: 268 -- upvalues: IndicesReference (val)
    local v1 = self[IndicesReference]
    if v1 then
        local u4 = v1[a2]
        if u4 then
            local v2 = self[u4]
            if v2 then
                local v3
                if v2 ~= true then
                    v3 = u4[v2]
                    if v3 then
                        if not self.SuppressInstanceReDestroy or v2 ~= "Destroy" or typeof(u4) ~= "Instance" then
                            v3(u4)
                        else
                            pcall(v3, u4)
                        end
                    end
                elseif type(u4) ~= "function" then
                    v3 = nil
                    if coroutine.running() ~= u4 then
                        v3 = pcall(function() -- Line: 284 -- upvalues: u4 (val)
                            task.cancel(u4)
                        end)
                    end
                    if not v3 then
                        task.defer(function() -- Line: 290 -- upvalues: u4 (val)
                            if u4 then
                                task.cancel(u4)
                            end
                        end)
                    end
                else
                    u4()
                end
                self[u4] = nil
            end
            v1[a2] = nil
        end
    end
    return self
end

function u21:RemoveNoClean(a2) -- Line: 347 -- upvalues: IndicesReference (val)
    local v1 = self[IndicesReference]
    if v1 then
        local v2 = v1[a2]
        if v2 then
            self[v2] = nil
        end
        v1[a2] = nil
    end
    return self
end

function u21.RemoveList(a1, ...) -- Line: 403 -- upvalues: IndicesReference (val)
    if a1[IndicesReference] then
        local v1 = select("#", ...)
        if v1 == 1 then
            return a1:Remove(...)
        end
        for i = 1, v1 do
            a1:Remove((select(i, ...)))
        end
    end
    return a1
end

function u21.RemoveListNoClean(a1, ...) -- Line: 460 -- upvalues: IndicesReference (val)
    local v1 = a1[IndicesReference]
    if v1 then
        local v2, v3
        local v4 = select("#", ...)
        if v4 == 1 then
            return a1:RemoveNoClean(...)
        end
        for i = 1, v4 do
            v2 = select(i, ...)
            v3 = v1[v2]
            if v3 then
                a1[v3] = nil
            end
            v1[v2] = nil
        end
    end
    return a1
end

function u21.Get(a1, a2) -- Line: 508 -- upvalues: IndicesReference (val)
    local v1 = a1[IndicesReference]
    if v1 then
        return v1[a2]
    end
    return nil
end

function u21.GetAll(a1) -- Line: 538 -- upvalues: IndicesReference (val)
    local v1 = a1[IndicesReference]
    if v1 then
        return (table.freeze(table.clone(v1)))
    end
    return {}
end

local function GetFenv(a1) -- Line: 543 -- upvalues: IndicesReference (val)
    return function() -- Line: 544 -- upvalues: a1 (val), IndicesReference (upval)
        for k, v in next, a1 do
            if k ~= IndicesReference then
                return k, v
            end
        end
    end
end

function u21:Cleanup() -- Line: 570 -- upvalues: IndicesReference (val)
    if not self.CurrentlyCleaning then
        local v1, v2, v3
        self.CurrentlyCleaning = nil

        local function v4() -- Line: 544 -- upvalues: self (val), IndicesReference (upval)
            for k, v in next, self do
                if k ~= IndicesReference then
                    return k, v
                end
            end
        end

        local u53, v5 = v4()
        while u53 do
            if not v5 then
                break
            end
            if v5 ~= true then
                v1 = u53[v5]
                if v1 then
                    if not self.SuppressInstanceReDestroy or v5 ~= "Destroy" then
                        v1(u53)
                    else
                        v3 = u53
                        if typeof(v3) ~= "Instance" then
                            v1(u53)
                        else
                            pcall(v1, u53)
                        end
                    end
                end
            else
                v2 = u53
                if type(v2) ~= "function" then
                    v1 = nil
                    if coroutine.running() ~= u53 then
                        v1 = pcall(function() -- Line: 584 -- upvalues: u53 (ref)
                            task.cancel(u53)
                        end)
                    end
                    if not v1 then
                        task.defer(function() -- Line: 590 -- upvalues: u53 (ref)
                            if u53 then
                                task.cancel(u53)
                            end
                        end)
                    end
                else
                    u53()
                end
            end
            self[u53] = nil
            v1, v2 = v4()
            u53 = v1
        end
        v1 = self[IndicesReference]
        if v1 then
            table.clear(v1)
            self[IndicesReference] = {}
        end
        self.CurrentlyCleaning = false
    end
end

function u21.Destroy(a1) -- Line: 629
    a1:Cleanup()
end

u21.__call = u21.Cleanup

function u21:LinkToInstance(a2, a3) -- Line: 676
    -- upvalues: LinkToInstanceIndex (val)
    local v1 = a3 and newproxy(false) or LinkToInstanceIndex
    return self:Add(a2.Destroying:Connect(function() -- Line: 679 -- upvalues: self (val)
        self:Cleanup()
    end), "Disconnect", v1)
end

function u21.LegacyLinkToInstance(a1, a2, a3) -- Line: 729
    -- upvalues: LinkToInstanceIndex (val), RbxScriptConnection (val)
    local u3 = nil
    local u12 = a2.Parent == nil
    local u16 = setmetatable({}, RbxScriptConnection)
    u3 = a2.AncestryChanged:Connect(function(a1_2, a2) -- Line: 735 -- upvalues: u16 (val), u12 (ref), u3 (ref), a1 (val)
        if u16.Connected then
            u12 = a2 == nil
            if u12 then
                task.defer(function() -- Line: 741 -- upvalues: u16 (upval), u3 (upval), a1 (upval), u12 (upval)
                    if not u16.Connected then
                        return
                    end
                    if not u3.Connected then
                        a1:Cleanup()
                        return
                    end
                    while u12 do
                        if not u3.Connected or not u16.Connected then
                            break
                        end
                        task.wait()
                    end
                    if u16.Connected and u12 then
                        a1:Cleanup()
                    end
                end)
            end
        end
    end)
    u16.Connection = u3
    if u12 then
        local Parent = a2.Parent
        if u16.Connected then
            u12 = Parent == nil
            if u12 then
                task.defer(function() -- Line: 741 -- upvalues: u16 (val), u3 (ref), a1 (val), u12 (ref)
                    if not u16.Connected then
                        return
                    end
                    if not u3.Connected then
                        a1:Cleanup()
                        return
                    end
                    while u12 do
                        if not u3.Connected or not u16.Connected then
                            break
                        end
                        task.wait()
                    end
                    if u16.Connected and u12 then
                        a1:Cleanup()
                    end
                end)
            end
        end
    end
    return (a1:Add(u16, "Disconnect", a3 and newproxy(false) or LinkToInstanceIndex))
end

function u21.LinkToInstances(a1, ...) -- Line: 777 -- upvalues: u21 (val)
    local v1 = u21.new()
    for i, j in {...} do
        v1:Add(a1:LinkToInstance(j, true), "Disconnect")
    end
    return v1
end

function u21.__tostring(a1) -- Line: 786
    return "Janitor"
end

table.freeze(u21)
return u21