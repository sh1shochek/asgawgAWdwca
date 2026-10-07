-- ReplicatedStorage.Packages._Index.sleitnick_observers@0.3.4.observers.observePlayer
-- Script path: ReplicatedStorage.Packages._Index.sleitnick_observers@0.3.4.observers.observePlayer
-- Decompile time: 0.94 ms

local Players = game:GetService("Players")
return function(a1) -- Line: 21 -- upvalues: Players (val) -- types: a1: function
    local u1 = nil
    local u3 = {}

    local function OnPlayerAdded(a1_2) -- Line: 27 -- upvalues: u1 (ref), a1 (val), u3 (val) -- types: a1_2: userdata
        if not u1.Connected then
            return
        end
        task.spawn(function() -- Line: 32 -- upvalues: a1 (upval), a1_2 (val), u1 (upval), u3 (upval)
            local v1 = a1(a1_2)
            if typeof(v1) == "function" then
                if u1.Connected and a1_2.Parent then
                    u3[a1_2] = v1
                    return
                end
                task.spawn(v1)
            end
        end)
    end

    u1 = Players.PlayerAdded:Connect(OnPlayerAdded)
    local u19 = Players.PlayerRemoving:Connect(function(a1) -- Line: 44 -- upvalues: u3 (val) -- types: a1: userdata
        local v1 = u3[a1]
        u3[a1] = nil
        if typeof(v1) == "function" then
            task.spawn(v1)
        end
    end)
    task.defer(function() -- Line: 57 -- upvalues: u1 (ref), Players (upval), OnPlayerAdded (val)
        if not u1.Connected then
            return
        end
        for i, j in Players:GetPlayers() do
            task.spawn(OnPlayerAdded, j)
        end
    end)
    return function() -- Line: 68 -- upvalues: u1 (ref), u19 (ref), u3 (val)
        local v1
        u1:Disconnect()
        u19:Disconnect()
        local v2 = next(u3)
        while v2 do
            v1 = u3[v2]
            u3[v2] = nil
            if typeof(v1) == "function" then
                task.spawn(v1)
            end
            v2 = next(u3)
        end
    end
end