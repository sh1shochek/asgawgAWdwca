-- ReplicatedStorage.Packages._Index.sleitnick_observers@0.3.4.observers.observeProperty
-- Script path: ReplicatedStorage.Packages._Index.sleitnick_observers@0.3.4.observers.observeProperty
-- Decompile time: 0.67 ms

return function(a1, a2, a3) -- Line: 19 -- types: a1: userdata, a2: string, a3: function
    local u3 = nil
    local u4 = nil
    local u5 = 0
    u4 = (a1:GetPropertyChangedSignal(a2)):Connect(function() -- Line: 25 -- upvalues: u3 (ref), u5 (ref), a1 (val), a2 (val), a3 (val), u4 (ref)
        if u3 ~= nil then
            task.spawn(u3)
            u3 = nil
        end
        u5 = u5 + 1
        local u7 = u5
        local u10 = a1[a2]
        task.spawn(function() -- Line: 36 -- upvalues: a3 (upval), u10 (val), u7 (val), u5 (upval), u4 (upval), u3 (upval)
            local v1 = a3(u10)
            if u7 == u5 and u4.Connected then
                u3 = v1
                return
            end
            task.spawn(v1)
        end)
    end)
    task.defer(function() -- Line: 50 -- upvalues: u4 (ref), u3 (ref), u5 (ref), a1 (val), a2 (val), a3 (val)
        if not u4.Connected then
            return
        end
        if u3 ~= nil then
            task.spawn(u3)
            u3 = nil
        end
        u5 = u5 + 1
        local u9 = u5
        local u12 = a1[a2]
        task.spawn(function() -- Line: 36 -- upvalues: a3 (upval), u12 (val), u9 (val), u5 (upval), u4 (upval), u3 (upval)
            local v1 = a3(u12)
            if u9 == u5 and u4.Connected then
                u3 = v1
                return
            end
            task.spawn(v1)
        end)
    end)
    return function() -- Line: 58 -- upvalues: u4 (ref), u3 (ref)
        u4:Disconnect()
        if u3 ~= nil then
            task.spawn(u3)
            u3 = nil
        end
    end
end