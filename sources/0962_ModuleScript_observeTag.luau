-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");

function observeTag(u1: string, u2: function, u3: table?)
    -- upvalues: CollectionService (copy)
    local u4 = {};
    local u5 = {};
    local u6 = nil;

    local function IsGoodAncestor(p7: userdata) -- Line: 63
        -- upvalues: u3 (copy)
        if u3 == nil then
            return true;
        end;

        for _, v in u3 do
            if p7:IsDescendantOf(v) then
                return true;
            end;
        end;

        return false;
    end;

    local function AttemptStartup(u8: userdata) -- Line: 77
        -- upvalues: u4 (copy), u2 (copy), u1 (copy)
        u4[u8] = "__inflight__";
        task.defer(function() -- Line: 82
            -- upvalues: u4 (ref), u8 (copy), u2 (ref), u1 (ref)
            if u4[u8] ~= "__inflight__" then
                return;
            end;

            local v12, v13 = xpcall(function(p9: userdata) -- Line: 88
                -- upvalues: u2 (ref)
                local v10 = u2(p9);

                if v10 ~= nil then
                    local v11 = typeof(v10) == "function";
                    assert(v11, "callback must return a function or nil");
                end;

                return v10;
            end, debug.traceback, u8);

            if v12 then
                if u4[u8] == "__inflight__" then
                    u4[u8] = v13;
                elseif v13 ~= nil then
                    task.spawn(v13);

                    return;
                end;

                return;
            end;

            local v14 = string.split(v13, "\n")[1];
            local string_find_ret = string.find(v14, ": ");
            local v15 = not string_find_ret and "" or v14:sub(string_find_ret + 1);
            warn((`error while calling observeTag("{u1}") callback:{v15}\n{v13}`));
        end);
    end;

    local function AttemptCleanup(p16: userdata) -- Line: 120
        -- upvalues: u4 (copy)
        local v17 = u4[p16];
        u4[p16] = "__dead__";

        if typeof(v17) == "function" then
            task.spawn(v17);
        end;
    end;

    local function OnAncestryChanged(u18: userdata) -- Line: 129
        -- upvalues: u3 (copy), u4 (copy), u2 (copy), u1 (copy)
        local v19;

        if u3 == nil then
            v19 = true;
        else
            v19 = false;

            for _, v in u3 do
                if u18:IsDescendantOf(v) then
                    v19 = true;
                    break;
                end;
            end;
        end;

        if v19 then
            if u4[u18] == "__dead__" then
                u4[u18] = "__inflight__";
                task.defer(function() -- Line: 82
                    -- upvalues: u4 (ref), u18 (copy), u2 (ref), u1 (ref)
                    if u4[u18] ~= "__inflight__" then
                        return;
                    end;

                    local v23, v24 = xpcall(function(p20: userdata) -- Line: 88
                        -- upvalues: u2 (ref)
                        local v21 = u2(p20);

                        if v21 ~= nil then
                            local v22 = typeof(v21) == "function";
                            assert(v22, "callback must return a function or nil");
                        end;

                        return v21;
                    end, debug.traceback, u18);

                    if v23 then
                        if u4[u18] == "__inflight__" then
                            u4[u18] = v24;
                        elseif v24 ~= nil then
                            task.spawn(v24);

                            return;
                        end;

                        return;
                    end;

                    local v25 = string.split(v24, "\n")[1];
                    local string_find_ret = string.find(v25, ": ");
                    local v26 = not string_find_ret and "" or v25:sub(string_find_ret + 1);
                    warn((`error while calling observeTag("{u1}") callback:{v26}\n{v24}`));
                end);
            end;
        else
            local v27 = u4[u18];
            u4[u18] = "__dead__";

            if typeof(v27) == "function" then
                task.spawn(v27);
            end;
        end;
    end;

    local function OnInstanceAdded(u28: userdata) -- Line: 139
        -- upvalues: u6 (ref), u4 (copy), u5 (copy), u3 (copy), u2 (copy), u1 (copy)
        if not u6.Connected then
            return;
        end;

        if u4[u28] ~= nil then
            return;
        end;

        u4[u28] = "__dead__";
        u5[u28] = u28.AncestryChanged:Connect(function() -- Line: 149
            -- upvalues: u28 (copy), u3 (ref), u4 (ref), u2 (ref), u1 (ref)
            local u29 = u28;
            local v30;

            if u3 == nil then
                v30 = true;
            else
                v30 = false;

                for _, v in u3 do
                    if u29:IsDescendantOf(v) then
                        v30 = true;
                        break;
                    end;
                end;
            end;

            if v30 then
                if u4[u29] == "__dead__" then
                    u4[u29] = "__inflight__";
                    task.defer(function() -- Line: 82
                        -- upvalues: u4 (ref), u29 (copy), u2 (ref), u1 (ref)
                        if u4[u29] ~= "__inflight__" then
                            return;
                        end;

                        local v34, v35 = xpcall(function(p31: userdata) -- Line: 88
                            -- upvalues: u2 (ref)
                            local v32 = u2(p31);

                            if v32 ~= nil then
                                local v33 = typeof(v32) == "function";
                                assert(v33, "callback must return a function or nil");
                            end;

                            return v32;
                        end, debug.traceback, u29);

                        if v34 then
                            if u4[u29] == "__inflight__" then
                                u4[u29] = v35;
                            elseif v35 ~= nil then
                                task.spawn(v35);

                                return;
                            end;

                            return;
                        end;

                        local v36 = string.split(v35, "\n")[1];
                        local string_find_ret = string.find(v36, ": ");
                        local v37 = not string_find_ret and "" or v36:sub(string_find_ret + 1);
                        warn((`error while calling observeTag("{u1}") callback:{v37}\n{v35}`));
                    end);
                end;
            else
                local v38 = u4[u29];
                u4[u29] = "__dead__";

                if typeof(v38) == "function" then
                    task.spawn(v38);
                end;
            end;
        end);
        local v39;

        if u3 == nil then
            v39 = true;
        else
            v39 = false;

            for _, v in u3 do
                if u28:IsDescendantOf(v) then
                    v39 = true;
                    break;
                end;
            end;
        end;

        if v39 then
            if u4[u28] == "__dead__" then
                u4[u28] = "__inflight__";
                task.defer(function() -- Line: 82
                    -- upvalues: u4 (ref), u28 (copy), u2 (ref), u1 (ref)
                    if u4[u28] ~= "__inflight__" then
                        return;
                    end;

                    local v43, v44 = xpcall(function(p40: userdata) -- Line: 88
                        -- upvalues: u2 (ref)
                        local v41 = u2(p40);

                        if v41 ~= nil then
                            local v42 = typeof(v41) == "function";
                            assert(v42, "callback must return a function or nil");
                        end;

                        return v41;
                    end, debug.traceback, u28);

                    if v43 then
                        if u4[u28] == "__inflight__" then
                            u4[u28] = v44;
                        elseif v44 ~= nil then
                            task.spawn(v44);

                            return;
                        end;

                        return;
                    end;

                    local v45 = string.split(v44, "\n")[1];
                    local string_find_ret = string.find(v45, ": ");
                    local v46 = not string_find_ret and "" or v45:sub(string_find_ret + 1);
                    warn((`error while calling observeTag("{u1}") callback:{v46}\n{v44}`));
                end);
            end;
        else
            local v47 = u4[u28];
            u4[u28] = "__dead__";

            if typeof(v47) == "function" then
                task.spawn(v47);
            end;
        end;
    end;

    u6 = CollectionService:GetInstanceAddedSignal(u1):Connect(OnInstanceAdded);
    local u51 = CollectionService:GetInstanceRemovedSignal(u1):Connect(function(p48: userdata) -- Line: 155, Name: OnInstanceRemoved
        -- upvalues: u4 (copy), u5 (copy)
        local v49 = u4[p48];
        u4[p48] = "__dead__";

        if typeof(v49) == "function" then
            task.spawn(v49);
        end;

        local v50 = u5[p48];

        if v50 then
            v50:Disconnect();
            u5[p48] = nil;
        end;

        u4[p48] = nil;
    end);
    task.defer(function() -- Line: 172
        -- upvalues: u6 (ref), CollectionService (ref), u1 (copy), OnInstanceAdded (copy)
        if not u6.Connected then
            return;
        end;

        for _, v in CollectionService:GetTagged(u1) do
            task.spawn(OnInstanceAdded, v);
        end;
    end);

    return function() -- Line: 183
        -- upvalues: u6 (ref), u51 (ref), u4 (copy), u5 (copy)
        u6:Disconnect();
        u51:Disconnect();
        local v52 = next(u4);

        while v52 do
            local v53 = u4[v52];
            u4[v52] = "__dead__";

            if typeof(v53) == "function" then
                task.spawn(v53);
            end;

            local v54 = u5[v52];

            if v54 then
                v54:Disconnect();
                u5[v52] = nil;
            end;

            u4[v52] = nil;
            v52 = next(u4);
        end;
    end;
end;

return observeTag;