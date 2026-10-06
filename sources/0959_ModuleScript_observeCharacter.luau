-- Decompiled with Potassium's decompiler.

local observePlayer = require(script.Parent.observePlayer);

return function(u1: function) -- Line: 21, Name: observeCharacter
    -- upvalues: observePlayer (copy)
    return observePlayer(function(u2) -- Line: 22
        -- upvalues: u1 (copy)
        local u3 = nil;
        local u4 = nil;

        local function OnCharacterAdded(u5: userdata) -- Line: 27
            -- upvalues: u1 (ref), u2 (copy), u4 (ref), u3 (ref)
            local u6 = nil;
            task.defer(function() -- Line: 31
                -- upvalues: u1 (ref), u2 (ref), u5 (copy), u4 (ref), u6 (ref), u3 (ref)
                local v7 = u1(u2, u5);

                if typeof(v7) == "function" then
                    if u4.Connected and u5.Parent then
                        u6 = v7;
                        u3 = v7;

                        return;
                    end;

                    task.spawn(v7);
                end;
            end);
            local u8 = nil;
            u8 = u5.AncestryChanged:Connect(function(p9, p10) -- Line: 47
                -- upvalues: u8 (ref), u6 (ref), u3 (ref)
                if p10 == nil and u8.Connected then
                    u8:Disconnect();

                    if u6 ~= nil then
                        task.spawn(u6);

                        if u3 == u6 then
                            u3 = nil;
                        end;

                        u6 = nil;
                    end;
                end;
            end);
        end;

        u4 = u2.CharacterAdded:Connect(OnCharacterAdded);
        task.defer(function() -- Line: 65
            -- upvalues: u2 (copy), u4 (ref), OnCharacterAdded (copy)
            if u2.Character and u4.Connected then
                task.spawn(OnCharacterAdded, u2.Character);
            end;
        end);

        return function() -- Line: 72
            -- upvalues: u4 (ref), u3 (ref)
            u4:Disconnect();

            if u3 ~= nil then
                task.spawn(u3);
                u3 = nil;
            end;
        end;
    end);
end;