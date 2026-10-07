-- ReplicatedStorage.Packages._Index.sleitnick_observers@0.3.4.observers.observeTag
-- Script path: ReplicatedStorage.Packages._Index.sleitnick_observers@0.3.4.observers.observeTag
-- Decompile time: 4.81 ms

local CollectionService = game:GetService("CollectionService")

function observeTag(a1, a2, a3) -- Line: 56
    -- upvalues: CollectionService (val)
    local u3 = {}
    local u4 = {}
    local u5 = nil

    local function IsGoodAncestor(a1) -- Line: 63 -- upvalues: a3 (val) -- types: a1: userdata
        if a3 == nil then
            return true
        end
        for i, j in a3 do
            if a1:IsDescendantOf(j) then
                return true
            end
        end
        return false
    end

    local function AttemptStartup(a1_2) -- Line: 77 -- upvalues: u3 (val), a2 (val), a1 (val) -- types: a1_2: userdata
        u3[a1_2] = "__inflight__"
        task.defer(function() -- Line: 82 -- upvalues: u3 (upval), a1_2 (val), a2 (upval), a1 (upval)
            if u3[a1_2] ~= "__inflight__" then
                return
            end
            local success, result = xpcall(function(a1) -- Line: 88 -- upvalues: a2 (upval) -- types: a1: userdata
                local v1 = a2(a1)
                if v1 ~= nil then
                    assert(typeof(v1) == "function", "callback must return a function or nil")
                end
                return v1
            end, debug.traceback, a1_2)
            if success then
                if u3[a1_2] ~= "__inflight__" then
                    if result == nil then
                        return
                    end
                    task.spawn(result)
                    return
                end
                u3[a1_2] = result
                return
            end
            local v1 = ""
            local v2 = string.split(result, "\n")[1]
            local v3 = string.find(v2, ": ")
            if v3 then
                v1 = v2:sub(v3 + 1)
            end
            local v4 = a1
            warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(v4, v1, result)))
        end)
    end

    local function AttemptCleanup(a1) -- Line: 120 -- upvalues: u3 (val) -- types: a1: userdata
        local v1 = u3[a1]
        u3[a1] = "__dead__"
        if typeof(v1) == "function" then
            task.spawn(v1)
        end
    end

    local function OnAncestryChanged(a1_2) -- Line: 129
        -- upvalues: a3 (val), u3 (val), a2 (val), a1 (val)
        local v1
        if a3 ~= nil then
            for i, j in a3 do
                if a1_2:IsDescendantOf(j) then
                    if true then
                        if u3[a1_2] ~= "__dead__" then
                            return
                        end
                        u3[a1_2] = "__inflight__"
                        task.defer(function() -- Line: 82 -- upvalues: u3 (upval), a1_2 (val), a2 (upval), a1 (upval)
                            if u3[a1_2] ~= "__inflight__" then
                                return
                            end
                            local success, result = xpcall(function(a1) -- Line: 88 -- upvalues: a2 (upval) -- types: a1: userdata
                                local v1 = a2(a1)
                                if v1 ~= nil then
                                    assert(typeof(v1) == "function", "callback must return a function or nil")
                                end
                                return v1
                            end, debug.traceback, a1_2)
                            if success then
                                if u3[a1_2] ~= "__inflight__" then
                                    if result == nil then
                                        return
                                    end
                                    task.spawn(result)
                                    return
                                end
                                u3[a1_2] = result
                                return
                            end
                            local v1 = ""
                            local v2 = string.split(result, "\n")[1]
                            local v3 = string.find(v2, ": ")
                            if v3 then
                                v1 = v2:sub(v3 + 1)
                            end
                            local v4 = a1
                            warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(v4, v1, result)))
                        end)
                        return
                    end
                    v1 = u3[a1_2]
                    u3[a1_2] = "__dead__"
                    if typeof(v1) == "function" then
                        task.spawn(v1)
                    end
                    return
                end
            end
            v1 = false
        else
            v1 = true
        end
        if v1 then
            if u3[a1_2] ~= "__dead__" then
                return
            end
            u3[a1_2] = "__inflight__"
            task.defer(function() -- Line: 82 -- upvalues: u3 (upval), a1_2 (val), a2 (upval), a1 (upval)
                if u3[a1_2] ~= "__inflight__" then
                    return
                end
                local success, result = xpcall(function(a1) -- Line: 88 -- upvalues: a2 (upval) -- types: a1: userdata
                    local v1 = a2(a1)
                    if v1 ~= nil then
                        assert(typeof(v1) == "function", "callback must return a function or nil")
                    end
                    return v1
                end, debug.traceback, a1_2)
                if success then
                    if u3[a1_2] ~= "__inflight__" then
                        if result == nil then
                            return
                        end
                        task.spawn(result)
                        return
                    end
                    u3[a1_2] = result
                    return
                end
                local v1 = ""
                local v2 = string.split(result, "\n")[1]
                local v3 = string.find(v2, ": ")
                if v3 then
                    v1 = v2:sub(v3 + 1)
                end
                local v4 = a1
                warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(v4, v1, result)))
            end)
            return
        end
        v1 = u3[a1_2]
        u3[a1_2] = "__dead__"
        if typeof(v1) == "function" then
            task.spawn(v1)
        end
    end

    local function OnInstanceAdded(a1_2) -- Line: 139
        -- upvalues: u5 (ref), u3 (val), u4 (val), a3 (val), a2 (val), a1 (val)
        local v1
        if not u5.Connected or u3[a1_2] ~= nil then
            return
        end
        u3[a1_2] = "__dead__"
        u4[a1_2] = (a1_2.AncestryChanged:Connect(function() -- Line: 149 -- upvalues: a1_2 (val), a3 (upval), u3 (upval), a2 (upval), a1 (upval)
            local v1
            local u0 = a1_2
            if a3 ~= nil then
                for i, j in a3 do
                    if u0:IsDescendantOf(j) then
                        if true then
                            if u3[u0] ~= "__dead__" then
                                return
                            end
                            u3[u0] = "__inflight__"
                            task.defer(function() -- Line: 82 -- upvalues: u3 (upval), u0 (val), a2 (upval), a1 (upval)
                                if u3[u0] ~= "__inflight__" then
                                    return
                                end
                                local success, result = xpcall(function(a1) -- Line: 88 -- upvalues: a2 (upval) -- types: a1: userdata
                                    local v1 = a2(a1)
                                    if v1 ~= nil then
                                        assert(typeof(v1) == "function", "callback must return a function or nil")
                                    end
                                    return v1
                                end, debug.traceback, u0)
                                if success then
                                    if u3[u0] ~= "__inflight__" then
                                        if result == nil then
                                            return
                                        end
                                        task.spawn(result)
                                        return
                                    end
                                    u3[u0] = result
                                    return
                                end
                                local v1 = ""
                                local v2 = string.split(result, "\n")[1]
                                local v3 = string.find(v2, ": ")
                                if v3 then
                                    v1 = v2:sub(v3 + 1)
                                end
                                local v4 = a1
                                warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(v4, v1, result)))
                            end)
                            return
                        end
                        v1 = u3[u0]
                        u3[u0] = "__dead__"
                        if typeof(v1) == "function" then
                            task.spawn(v1)
                        end
                        return
                    end
                end
                v1 = false
            else
                v1 = true
            end
            if v1 then
                if u3[u0] ~= "__dead__" then
                    return
                end
                u3[u0] = "__inflight__"
                task.defer(function() -- Line: 82 -- upvalues: u3 (upval), u0 (val), a2 (upval), a1 (upval)
                    if u3[u0] ~= "__inflight__" then
                        return
                    end
                    local success, result = xpcall(function(a1) -- Line: 88 -- upvalues: a2 (upval) -- types: a1: userdata
                        local v1 = a2(a1)
                        if v1 ~= nil then
                            assert(typeof(v1) == "function", "callback must return a function or nil")
                        end
                        return v1
                    end, debug.traceback, u0)
                    if success then
                        if u3[u0] ~= "__inflight__" then
                            if result == nil then
                                return
                            end
                            task.spawn(result)
                            return
                        end
                        u3[u0] = result
                        return
                    end
                    local v1 = ""
                    local v2 = string.split(result, "\n")[1]
                    local v3 = string.find(v2, ": ")
                    if v3 then
                        v1 = v2:sub(v3 + 1)
                    end
                    local v4 = a1
                    warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(v4, v1, result)))
                end)
                return
            end
            v1 = u3[u0]
            u3[u0] = "__dead__"
            if typeof(v1) == "function" then
                task.spawn(v1)
            end
        end))
        if a3 ~= nil then
            for i, j in a3 do
                if a1_2:IsDescendantOf(j) then
                    if true then
                        if u3[a1_2] ~= "__dead__" then
                            return
                        end
                        u3[a1_2] = "__inflight__"
                        task.defer(function() -- Line: 82 -- upvalues: u3 (upval), a1_2 (val), a2 (upval), a1 (upval)
                            if u3[a1_2] ~= "__inflight__" then
                                return
                            end
                            local success, result = xpcall(function(a1) -- Line: 88 -- upvalues: a2 (upval) -- types: a1: userdata
                                local v1 = a2(a1)
                                if v1 ~= nil then
                                    assert(typeof(v1) == "function", "callback must return a function or nil")
                                end
                                return v1
                            end, debug.traceback, a1_2)
                            if success then
                                if u3[a1_2] ~= "__inflight__" then
                                    if result == nil then
                                        return
                                    end
                                    task.spawn(result)
                                    return
                                end
                                u3[a1_2] = result
                                return
                            end
                            local v1 = ""
                            local v2 = string.split(result, "\n")[1]
                            local v3 = string.find(v2, ": ")
                            if v3 then
                                v1 = v2:sub(v3 + 1)
                            end
                            local v4 = a1
                            warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(v4, v1, result)))
                        end)
                        return
                    end
                    v1 = u3[a1_2]
                    u3[a1_2] = "__dead__"
                    if typeof(v1) == "function" then
                        task.spawn(v1)
                    end
                    return
                end
            end
            v1 = false
        else
            v1 = true
        end
        if v1 then
            if u3[a1_2] ~= "__dead__" then
                return
            end
            u3[a1_2] = "__inflight__"
            task.defer(function() -- Line: 82 -- upvalues: u3 (upval), a1_2 (val), a2 (upval), a1 (upval)
                if u3[a1_2] ~= "__inflight__" then
                    return
                end
                local success, result = xpcall(function(a1) -- Line: 88 -- upvalues: a2 (upval) -- types: a1: userdata
                    local v1 = a2(a1)
                    if v1 ~= nil then
                        assert(typeof(v1) == "function", "callback must return a function or nil")
                    end
                    return v1
                end, debug.traceback, a1_2)
                if success then
                    if u3[a1_2] ~= "__inflight__" then
                        if result == nil then
                            return
                        end
                        task.spawn(result)
                        return
                    end
                    u3[a1_2] = result
                    return
                end
                local v1 = ""
                local v2 = string.split(result, "\n")[1]
                local v3 = string.find(v2, ": ")
                if v3 then
                    v1 = v2:sub(v3 + 1)
                end
                local v4 = a1
                warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(v4, v1, result)))
            end)
            return
        end
        v1 = u3[a1_2]
        u3[a1_2] = "__dead__"
        if typeof(v1) == "function" then
            task.spawn(v1)
        end
    end

    u5 = (CollectionService:GetInstanceAddedSignal(a1)):Connect(OnInstanceAdded)
    local u32 = (CollectionService:GetInstanceRemovedSignal(a1)):Connect(function(a1) -- Line: 155 -- upvalues: u3 (val), u4 (val) -- types: a1: userdata
        local v1 = u3[a1]
        u3[a1] = "__dead__"
        if typeof(v1) == "function" then
            task.spawn(v1)
        end
        v1 = u4[a1]
        if v1 then
            v1:Disconnect()
            u4[a1] = nil
        end
        u3[a1] = nil
    end)
    task.defer(function() -- Line: 172 -- upvalues: u5 (ref), CollectionService (upval), a1 (val), OnInstanceAdded (val)
        if not u5.Connected then
            return
        end
        for i, j in CollectionService:GetTagged(a1) do
            task.spawn(OnInstanceAdded, j)
        end
    end)
    return function() -- Line: 183 -- upvalues: u5 (ref), u32 (ref), u3 (val), u4 (val)
        local v1
        u5:Disconnect()
        u32:Disconnect()
        local v2 = next(u3)
        while v2 do
            v1 = u3[v2]
            u3[v2] = "__dead__"
            if typeof(v1) == "function" then
                task.spawn(v1)
            end
            v1 = u4[v2]
            if v1 then
                v1:Disconnect()
                u4[v2] = nil
            end
            u3[v2] = nil
            v2 = next(u3)
        end
    end
end

return observeTag