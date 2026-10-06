-- Decompiled with Potassium's decompiler.

local script_GetPromiseLibrary = require(script.GetPromiseLibrary);
local script_RbxScriptConnection = require(script.RbxScriptConnection);
local script_Symbol = require(script.Symbol);
local u1, u2 = script_GetPromiseLibrary();
local u3 = script_Symbol("IndicesReference");
local u4 = script_Symbol("LinkToInstanceIndex");
local u5 = {
    ClassName = "Janitor",
    CurrentlyCleaning = true,
    SuppressInstanceReDestroy = false,
    [u3] = nil
};
u5.__index = u5;
local u6 = {
    ["function"] = true,
    thread = true,
    RBXScriptConnection = "Disconnect"
};

function u5.new() -- Line: 62
    -- upvalues: u3 (copy), u5 (copy)
    return setmetatable({
        CurrentlyCleaning = false,
        [u3] = nil
    }, u5);
end;

function u5.Is(p7) -- Line: 75
    -- upvalues: u5 (copy)
    local v8;

    if type(p7) == "table" then
        v8 = getmetatable(p7) == u5;
    else
        v8 = false;
    end;

    return v8;
end;

function u5.Add(p9, p10, p11, p12) -- Line: 159
    -- upvalues: u3 (copy), u6 (copy)
    if p12 then
        p9:Remove(p12);
        local v13 = p9[u3];

        if not v13 then
            v13 = {};
            p9[u3] = v13;
        end;

        v13[p12] = p10;
    end;

    local v14 = typeof(p10);
    local v15 = p11 or (u6[v14] or "Destroy");

    if v14 == "function" or v14 == "thread" then
        if v15 ~= true then
            warn(string.format("Object is a %s and as such expected `true?` for the method name and instead got %s. Traceback: %s", v14, tostring(v15), debug.traceback(nil, 2)));
        end;
    elseif not p10[v15] then
        warn(string.format("Object %s doesn\'t have method %s, are you sure you want to add it? Traceback: %s", tostring(p10), tostring(v15), debug.traceback(nil, 2)));
    end;

    p9[p10] = v15;

    return p10;
end;

function u5.AddPromise(p16, u17) -- Line: 215
    -- upvalues: u1 (copy), u2 (copy)
    if not u1 then
        return u17;
    end;

    if not u2.is(u17) then
        error(string.format("Invalid argument #1 to \'Janitor:AddPromise\' (Promise expected, got %s (%s)) Traceback: %s", typeof(u17), tostring(u17), debug.traceback(nil, 2)));
    end;

    if u17:getStatus() ~= u2.Status.Started then
        return u17;
    end;

    local v18 = newproxy(false);
    local v22 = p16:Add(u2.new(function(p19, p20, p21) -- Line: 223
        -- upvalues: u17 (copy)
        if p21(function() -- Line: 224
            -- upvalues: u17 (ref)
            u17:cancel();
        end) then
            return;
        end;

        p19(u17);
    end), "cancel", v18);
    v22:finallyCall(p16.Remove, p16, v18);

    return v22;
end;

function u5.Remove(p23, p24) -- Line: 268
    -- upvalues: u3 (copy)
    local v25 = p23[u3];
    local u26 = v25 and v25[p24];

    if u26 then
        local v27 = p23[u26];

        if v27 then
            if v27 == true then
                if type(u26) == "function" then
                    u26();
                else
                    local v28;

                    if coroutine.running() == u26 then
                        v28 = nil;
                    else
                        v28 = pcall(function() -- Line: 284
                            -- upvalues: u26 (copy)
                            task.cancel(u26);
                        end);
                    end;

                    if not v28 then
                        task.defer(function() -- Line: 290
                            -- upvalues: u26 (copy)
                            if u26 then
                                task.cancel(u26);
                            end;
                        end);
                    end;
                end;
            else
                local v29 = u26[v27];

                if v29 then
                    if p23.SuppressInstanceReDestroy and (v27 == "Destroy" and typeof(u26) == "Instance") then
                        pcall(v29, u26);
                    else
                        v29(u26);
                    end;
                end;
            end;

            p23[u26] = nil;
        end;

        v25[p24] = nil;
    end;

    return p23;
end;

function u5.RemoveNoClean(p30, p31) -- Line: 347
    -- upvalues: u3 (copy)
    local v32 = p30[u3];

    if v32 then
        local v33 = v32[p31];

        if v33 then
            p30[v33] = nil;
        end;

        v32[p31] = nil;
    end;

    return p30;
end;

function u5.RemoveList(p34, ...) -- Line: 403
    -- upvalues: u3 (copy)
    if p34[u3] then
        local v35 = select("#", ...);

        if v35 == 1 then
            return p34:Remove(...);
        end;

        for i = 1, v35 do
            p34:Remove(select(i, ...));
            local _ = i;
        end;
    end;

    return p34;
end;

function u5.RemoveListNoClean(p36, ...) -- Line: 460
    -- upvalues: u3 (copy)
    local v37 = p36[u3];

    if v37 then
        local v38 = select("#", ...);

        if v38 == 1 then
            return p36:RemoveNoClean(...);
        end;

        for i = 1, v38 do
            local v39 = select(i, ...);
            local v40 = v37[v39];

            if v40 then
                p36[v40] = nil;
            end;

            v37[v39] = nil;
            local _ = i;
        end;
    end;

    return p36;
end;

function u5.Get(p41, p42) -- Line: 508
    -- upvalues: u3 (copy)
    local v43 = p41[u3];

    if v43 then
        return v43[p42];
    end;

    return nil;
end;

function u5.GetAll(p44) -- Line: 538
    -- upvalues: u3 (copy)
    local v45 = p44[u3];

    return not v45 and {} or table.freeze(table.clone(v45));
end;

local function GetFenv(u46) -- Line: 543
    -- upvalues: u3 (copy)
    return function() -- Line: 544
        -- upvalues: u46 (copy), u3 (ref)
        for i, v in next, u46 do
            if i ~= u3 then
                return i, v;
            end;
        end;
    end;
end;

function u5.Cleanup(u47) -- Line: 570
    -- upvalues: u3 (copy)
    if not u47.CurrentlyCleaning then
        u47.CurrentlyCleaning = nil;

        local function v48() -- Line: 544
            -- upvalues: u47 (copy), u3 (ref)
            for i, v in next, u47 do
                if i ~= u3 then
                    return i, v;
                end;
            end;
        end;

        local u49, v50 = v48();

        while u49 and v50 do
            if v50 == true then
                if type(u49) == "function" then
                    u49();
                else
                    local v51;

                    if coroutine.running() == u49 then
                        v51 = nil;
                    else
                        v51 = pcall(function() -- Line: 584
                            -- upvalues: u49 (ref)
                            task.cancel(u49);
                        end);
                    end;

                    if not v51 then
                        task.defer(function() -- Line: 590
                            -- upvalues: u49 (ref)
                            if u49 then
                                task.cancel(u49);
                            end;
                        end);
                    end;
                end;
            else
                local v52 = u49[v50];

                if v52 then
                    if u47.SuppressInstanceReDestroy and (v50 == "Destroy" and typeof(u49) == "Instance") then
                        pcall(v52, u49);
                    else
                        v52(u49);
                    end;
                end;
            end;

            u47[u49] = nil;
            u49, v50 = v48();
        end;

        local v53 = u47[u3];

        if v53 then
            table.clear(v53);
            u47[u3] = {};
        end;

        u47.CurrentlyCleaning = false;
    end;
end;

function u5.Destroy(p54) -- Line: 629
    p54:Cleanup();
end;

u5.__call = u5.Cleanup;

function u5.LinkToInstance(u55: table, p56: userdata, p57: boolean?) -- Line: 676
    -- upvalues: u4 (copy)
    local v58 = p57 and newproxy(false) or u4;

    return u55:Add(p56.Destroying:Connect(function() -- Line: 679
        -- upvalues: u55 (copy)
        u55:Cleanup();
    end), "Disconnect", v58);
end;

function u5.LegacyLinkToInstance(u59: table, p60: userdata, p61: boolean?) -- Line: 729
    -- upvalues: u4 (copy), script_RbxScriptConnection (copy)
    local u62 = nil;
    local v63 = p61 and newproxy(false) or u4;
    local u64 = p60.Parent == nil;
    local u65 = setmetatable({}, script_RbxScriptConnection);
    u62 = p60.AncestryChanged:Connect(function(p66, p67) -- Line: 735, Name: ChangedFunction
        -- upvalues: u65 (copy), u64 (ref), u62 (ref), u59 (copy)
        u64 = u65.Connected and p67 == nil;

        if u64 then
            task.defer(function() -- Line: 741
                -- upvalues: u65 (ref), u62 (ref), u59 (ref), u64 (ref)
                if not u65.Connected then
                    return;
                end;

                if not u62.Connected then
                    u59:Cleanup();

                    return;
                end;

                while u64 and (u62.Connected and u65.Connected) do
                    task.wait();
                end;

                if u65.Connected and u64 then
                    u59:Cleanup();
                end;
            end);
        end;
    end);
    u65.Connection = u62;

    if u64 then
        local Parent = p60.Parent;

        if u65.Connected then
            if Parent == nil then
                u64 = true;
            else
                u64 = false;
            end;

            if u64 then
                task.defer(function() -- Line: 741
                    -- upvalues: u65 (copy), u62 (ref), u59 (copy), u64 (ref)
                    if not u65.Connected then
                        return;
                    end;

                    if not u62.Connected then
                        u59:Cleanup();

                        return;
                    end;

                    while u64 and (u62.Connected and u65.Connected) do
                        task.wait();
                    end;

                    if u65.Connected and u64 then
                        u59:Cleanup();
                    end;
                end);
            end;
        end;
    end;

    return u59:Add(u65, "Disconnect", v63);
end;

function u5.LinkToInstances(p68, ...) -- Line: 777
    -- upvalues: u5 (copy)
    local v69 = u5.new();

    for _, v in { ... } do
        v69:Add(p68:LinkToInstance(v, true), "Disconnect");
    end;

    return v69;
end;

function u5.__tostring(p70) -- Line: 786
    return "Janitor";
end;

table.freeze(u5);

return u5;