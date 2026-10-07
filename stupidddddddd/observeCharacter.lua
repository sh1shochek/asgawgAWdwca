-- ReplicatedStorage.Packages._Index.sleitnick_observers@0.3.4.observers.observeCharacter
-- Script path: ReplicatedStorage.Packages._Index.sleitnick_observers@0.3.4.observers.observeCharacter
-- Decompile time: 0.76 ms

local observePlayer = require(script.Parent.observePlayer)
return function(a1) -- Line: 21 -- upvalues: observePlayer (val) -- types: a1: function
    return observePlayer(function(a1_2) -- Line: 22 -- upvalues: a1 (val)
        local u1 = nil
        local u2 = nil

        local function OnCharacterAdded(a1_3) -- Line: 27
            -- upvalues: a1 (upval), a1_2 (val), u2 (ref), u1 (ref)
            local u1_2 = nil
            task.defer(function() -- Line: 31 -- upvalues: a1 (upval), a1_2 (upval), a1_3 (val), u2 (upval), u1_2 (ref), u1 (upval)
                local v1 = a1(a1_2, a1_3)
                if typeof(v1) == "function" then
                    if u2.Connected and a1_3.Parent then
                        u1_2 = v1
                        u1 = v1
                        return
                    end
                    task.spawn(v1)
                end
            end)
            local u5 = nil
            local v1 = a1_3.AncestryChanged:Connect(function(a1, a2) -- Line: 47 -- upvalues: u5 (ref), u1_2 (ref), u1 (upval)
                if a2 == nil and u5.Connected then
                    u5:Disconnect()
                    if u1_2 ~= nil then
                        task.spawn(u1_2)
                        if u1 == u1_2 then
                            u1 = nil
                        end
                        u1_2 = nil
                    end
                end
            end)
        end

        u2 = a1_2.CharacterAdded:Connect(OnCharacterAdded)
        task.defer(function() -- Line: 65 -- upvalues: a1_2 (val), u2 (ref), OnCharacterAdded (val)
            if a1_2.Character and u2.Connected then
                task.spawn(OnCharacterAdded, a1_2.Character)
            end
        end)
        return function() -- Line: 72 -- upvalues: u2 (ref), u1 (ref)
            u2:Disconnect()
            if u1 ~= nil then
                task.spawn(u1)
                u1 = nil
            end
        end
    end)
end