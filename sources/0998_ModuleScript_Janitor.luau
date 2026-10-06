-- Decompiled with Potassium's decompiler.

local Heartbeat = game:GetService("RunService").Heartbeat;
local u1 = newproxy(true);

getmetatable(u1).__tostring = function() -- Line: 11
    return "IndicesReference";
end;

local u2 = newproxy(true);

getmetatable(u2).__tostring = function() -- Line: 16
    return "LinkToInstanceIndex";
end;

local u3 = {
    ClassName = "Janitor",
    __index = {
        CurrentlyCleaning = true,
        [u1] = nil
    }
};
local u4 = {
    ["function"] = true,
    RBXScriptConnection = "Disconnect"
};

function u3.new() -- Line: 40
    -- upvalues: u1 (copy), u3 (copy)
    return setmetatable({
        CurrentlyCleaning = false,
        [u1] = nil
    }, u3);
end;

function u3.Is(p5) -- Line: 52
    -- upvalues: u3 (copy)
    local v6;

    if type(p5) == "table" then
        v6 = getmetatable(p5) == u3;
    else
        v6 = false;
    end;

    return v6;
end;

u3.is = u3.Is;

function u3.__index.Add(p7, p8, p9, p10) -- Line: 65
    -- upvalues: u1 (copy), u4 (copy)
    if p10 == nil then
        p10 = newproxy(false);
    end;

    if p10 then
        p7:Remove(p10);
        local v11 = p7[u1];

        if not v11 then
            v11 = {};
            p7[u1] = v11;
        end;

        v11[p10] = p8;
    end;

    local v12 = p9 or (u4[typeof(p8)] or "Destroy");

    if type(p8) ~= "function" and not p8[v12] then
        warn(string.format("Object %s doesn\'t have method %s, are you sure you want to add it? Traceback: %s", tostring(p8), tostring(v12), debug.traceback(nil, 2)));
    end;

    p7[p8] = v12;

    return p8, p10;
end;

u3.__index.Give = u3.__index.Add;

function u3.__index.AddObject(p13, p14) -- Line: 131
    local v15 = newproxy(false);

    return p13:Add(p14, false, v15), v15;
end;

u3.__index.GiveObject = u3.__index.AddObject;

function u3.__index.Remove(p16, p17) -- Line: 155
    -- upvalues: u1 (copy)
    local v18 = p16[u1];
    local v19 = v18 and v18[p17];

    if v19 then
        local v20 = p16[v19];

        if v20 then
            if v20 == true then
                v19();
            else
                local v21 = v19[v20];

                if v21 then
                    v21(v19);
                end;
            end;

            p16[v19] = nil;
        end;

        v18[p17] = nil;
    end;

    return p16;
end;

function u3.__index.Get(p22, p23) -- Line: 189
    -- upvalues: u1 (copy)
    local v24 = p22[u1];

    if v24 then
        return v24[p23];
    end;
end;

function u3.__index.Cleanup(p25) -- Line: 200
    -- upvalues: u1 (copy)
    if not p25.CurrentlyCleaning then
        p25.CurrentlyCleaning = nil;

        for i, v in next, p25 do
            if i ~= u1 then
                local v26 = type(i);

                if v26 == "string" or v26 == "number" then
                    p25[i] = nil;
                else
                    if v == true then
                        i();
                    else
                        local v27 = i[v];

                        if v27 then
                            v27(i);
                        end;
                    end;

                    p25[i] = nil;
                end;
            end;
        end;

        local v28 = p25[u1];

        if v28 then
            for i in next, v28 do
                v28[i] = nil;
            end;

            p25[u1] = {};
        end;

        p25.CurrentlyCleaning = false;
    end;
end;

u3.__index.Clean = u3.__index.Cleanup;

function u3.__index.Destroy(p29) -- Line: 246
    p29:Cleanup();
end;

u3.__call = u3.__index.Cleanup;
local u30 = {
    Connected = true
};
u30.__index = u30;

function u30.Disconnect(p31) -- Line: 260
    if p31.Connected then
        p31.Connected = false;
        p31.Connection:Disconnect();
    end;
end;

function u30.__tostring(p32) -- Line: 267
    return "Disconnect<" .. tostring(p32.Connected) .. ">";
end;

function u3.__index.LinkToInstance(u33, p34, p35) -- Line: 277
    -- upvalues: u2 (copy), u30 (copy), Heartbeat (copy)
    local u36 = nil;
    local v37 = p35 and newproxy(false) or u2;
    local u38 = p34.Parent == nil;
    local u39 = setmetatable({}, u30);
    u36 = p34.AncestryChanged:Connect(function(p40, p41) -- Line: 283, Name: ChangedFunction
        -- upvalues: u39 (copy), u38 (ref), Heartbeat (ref), u36 (ref), u33 (copy)
        u38 = u39.Connected and p41 == nil;

        if u38 then
            coroutine.wrap(function() -- Line: 289
                -- upvalues: Heartbeat (ref), u39 (ref), u36 (ref), u33 (ref), u38 (ref)
                Heartbeat:Wait();

                if not u39.Connected then
                    return;
                end;

                if not u36.Connected then
                    u33:Cleanup();

                    return;
                end;

                while u38 and (u36.Connected and u39.Connected) do
                    Heartbeat:Wait();
                end;

                if u39.Connected and u38 then
                    u33:Cleanup();
                end;
            end)();
        end;
    end);
    u39.Connection = u36;

    if u38 then
        local Parent = p34.Parent;

        if u39.Connected then
            if Parent == nil then
                u38 = true;
            else
                u38 = false;
            end;

            if u38 then
                coroutine.wrap(function() -- Line: 289
                    -- upvalues: Heartbeat (ref), u39 (copy), u36 (ref), u33 (copy), u38 (ref)
                    Heartbeat:Wait();

                    if not u39.Connected then
                        return;
                    end;

                    if not u36.Connected then
                        u33:Cleanup();

                        return;
                    end;

                    while u38 and (u36.Connected and u39.Connected) do
                        Heartbeat:Wait();
                    end;

                    if u39.Connected and u38 then
                        u33:Cleanup();
                    end;
                end)();
            end;
        end;
    end;

    return u33:Add(u39, "Disconnect", v37);
end;

function u3.__index.LinkToInstances(p42, ...) -- Line: 325
    -- upvalues: u3 (copy)
    local v43 = u3.new();

    for _, v in ipairs({ ... }) do
        v43:Add(p42:LinkToInstance(v, true), "Disconnect");
    end;

    return v43;
end;

for i, v in next, u3.__index do
    local string_lower_ret = string.lower(i);
    local v44 = string.sub(string_lower_ret, 1, 1) .. string.sub(i, 2);
    u3.__index[v44] = v;
end;

return u3;