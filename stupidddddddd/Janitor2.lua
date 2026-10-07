-- ReplicatedStorage.Shared.Zone.Janitor
-- Script path: ReplicatedStorage.Shared.Zone.Janitor
-- Decompile time: 3.22 ms

local v1
local Heartbeat = (game:GetService("RunService")).Heartbeat
local u8 = newproxy(true)
local v2 = getmetatable(u8)

function v2.__tostring() -- Line: 11
    return "IndicesReference"
end

local u15 = newproxy(true)
local v3 = getmetatable(u15)

function v3.__tostring() -- Line: 16
    return "LinkToInstanceIndex"
end

local u20 = {ClassName = "Janitor", __index = {CurrentlyCleaning = true, [u8] = nil}}
local u24 = {["function"] = true, RBXScriptConnection = "Disconnect"}

function u20.new() -- Line: 40 -- upvalues: u8 (val), u20 (val)
    return (setmetatable({CurrentlyCleaning = false, [u8] = nil}, u20))
end

function u20.Is(a1) -- Line: 52 -- upvalues: u20 (val)
    local v1 = false
    if type(a1) == "table" then
        v1 = (getmetatable(a1)) == u20
    end
    return v1
end

u20.is = u20.Is

function u20.__index:Add(a2, a3, a4) -- Line: 65 -- upvalues: u8 (val), u24 (val)
    if a4 == nil then
        a4 = newproxy(false)
    end
    if a4 then
        self:Remove(a4)
        local v1 = self[u8]
        if not v1 then
            self[u8] = {}
        end
        v1[a4] = a2
    end
    local v2 = a3 or u24[typeof(a2)] or "Destroy"
    if type(a2) ~= "function" and not a2[v2] then
        warn(string.format(
            "Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s",
            tostring(a2),
            tostring(v2),
            debug.traceback(nil, 2)
        ))
    end
    self[a2] = v2
    return a2, a4
end

u20.__index.Give = u20.__index.Add

function u20.__index.AddObject(a1, a2) -- Line: 131
    local v1 = newproxy(false)
    return (a1:Add(a2, false, v1)), v1
end

u20.__index.GiveObject = u20.__index.AddObject

function u20.__index:Remove(a2) -- Line: 155 -- upvalues: u8 (val)
    local v1 = self[u8]
    if v1 then
        local v2 = v1[a2]
        if v2 then
            local v3 = self[v2]
            if v3 then
                if v3 ~= true then
                    local v4 = v2[v3]
                    if v4 then
                        v4(v2)
                    end
                else
                    v2()
                end
                self[v2] = nil
            end
            v1[a2] = nil
        end
    end
    return self
end

function u20.__index.Get(a1, a2) -- Line: 189 -- upvalues: u8 (val)
    local v1 = a1[u8]
    if v1 then
        return v1[a2]
    end
end

function u20.__index:Cleanup() -- Line: 200 -- upvalues: u8 (val)
    if not self.CurrentlyCleaning then
        local v1, v2
        self.CurrentlyCleaning = nil
        local v3 = next
        local v4 = nil
        local v5 = self
        for k, v in v3, self, v4 do
            if k ~= u8 then
                v1 = type(k)
                if v1 ~= "string" then
                    if v1 ~= "number" then
                        if v ~= true then
                            v2 = k[v]
                            if v2 then
                                v2(k)
                            end
                        else
                            k()
                        end
                    end
                end
                v5[k] = nil
            end
        end
        v3 = v5[u8]
        if v3 then
            for k2 in next, v3 do
                v3[k2] = nil
            end
            v5[u8] = {}
        end
        v5.CurrentlyCleaning = false
    end
end

u20.__index.Clean = u20.__index.Cleanup

function u20.__index.Destroy(a1) -- Line: 246
    a1:Cleanup()
end

u20.__call = u20.__index.Cleanup
local u53 = {Connected = true}
u53.__index = u53

function u53:Disconnect() -- Line: 260
    if self.Connected then
        self.Connected = false
        self.Connection:Disconnect()
    end
end

function u53.__tostring(a1) -- Line: 267
    return "Disconnect<" .. (tostring(a1.Connected)) .. ">"
end

function u20.__index:LinkToInstance(a2, a3) -- Line: 277 -- upvalues: u15 (val), u53 (val), Heartbeat (val)
    local u3 = nil
    local u12 = a2.Parent == nil
    local u16 = setmetatable({}, u53)
    u3 = a2.AncestryChanged:Connect(function(a1, a2) -- Line: 283 -- upvalues: u16 (val), u12 (ref), Heartbeat (upval), u3 (ref), self (val)
        if u16.Connected then
            u12 = a2 == nil
            if u12 then
                coroutine.wrap(function() -- Line: 289 -- upvalues: Heartbeat (upval), u16 (upval), u3 (upval), self (upval), u12 (upval)
                    Heartbeat:Wait()
                    if not u16.Connected then
                        return
                    end
                    if not u3.Connected then
                        self:Cleanup()
                        return
                    end
                    while u12 do
                        if not u3.Connected or not u16.Connected then
                            break
                        end
                        Heartbeat:Wait()
                    end
                    if u16.Connected and u12 then
                        self:Cleanup()
                    end
                end)()
            end
        end
    end)
    u16.Connection = u3
    if u12 then
        local Parent = a2.Parent
        if u16.Connected then
            u12 = Parent == nil
            if u12 then
                coroutine.wrap(function() -- Line: 289 -- upvalues: Heartbeat (upval), u16 (val), u3 (ref), self (val), u12 (ref)
                    Heartbeat:Wait()
                    if not u16.Connected then
                        return
                    end
                    if not u3.Connected then
                        self:Cleanup()
                        return
                    end
                    while u12 do
                        if not u3.Connected or not u16.Connected then
                            break
                        end
                        Heartbeat:Wait()
                    end
                    if u16.Connected and u12 then
                        self:Cleanup()
                    end
                end)()
            end
        end
    end
    return (self:Add(u16, "Disconnect", a3 and newproxy(false) or u15))
end

function u20.__index.LinkToInstances(a1, ...) -- Line: 325 -- upvalues: u20 (val)
    local v1 = u20.new()
    for i, v in ipairs({...}) do
        v1:Add(a1:LinkToInstance(v, true), "Disconnect")
    end
    return v1
end

for k, v in next, u20.__index do
    v1 = (string.sub(string.lower(k), 1, 1)) .. string.sub(k, 2)
    u20.__index[v1] = v
end
return u20