-- ReplicatedStorage.Shared.FOW.Blob
-- Script path: ReplicatedStorage.Shared.FOW.Blob
-- Decompile time: 6.26 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");

function v1.Folder(p2: string?, p3: string) -- Line: 47
    -- upvalues: ReplicatedStorage (copy)
    if not p2 then
        return nil;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Maps");
    end;

    if Assets then
        Assets = Assets:FindFirstChild(p2);
    end;

    if Assets then
        Assets = Assets:FindFirstChild(p3);
    end;

    return Assets;
end;

function v1.Chunks(p4: userdata) -- Line: 61
    local v5 = {};

    while true do
        local v6 = p4:FindFirstChild((tostring(#v5 + 1)));

        if not v6 then
            break;
        end;

        local v7 = require(v6);
        table.insert(v5, v7);
    end;

    return v5;
end;

function v1.Decode(p8: table) -- Line: 88
    local table_create_ret = table.create(256, 0);

    for i = 1, 64 do
        table_create_ret[string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", i)] = i - 1;
        local _ = i;
    end;

    local v9 = 0;

    for _, v in p8 do
        v9 = v9 + #v;
    end;

    local v10 = p8[#p8];
    local v11 = string.sub(v10, -1) == "=" and 1 or 0;
    local v12 = string.sub(v10, -2, -2) == "=" and 1 or 0;
    local v13 = v9 // 4 * 3 - (v11 + v12);
    local buffer_create_ret = buffer.create(v13);
    local v14 = 0;

    for _, v in p8 do
        local v15 = v;

        for i = 1, #v, 4 do
            local string_byte_ret, v16, v17, v18 = string.byte(v15, i, i + 3);
            local v19 = table_create_ret[string_byte_ret] * 262144 + table_create_ret[v16] * 4096 + table_create_ret[v17] * 64 + table_create_ret[v18];
            buffer.writeu8(buffer_create_ret, v14, v19 // 65536);

            if v14 + 1 < v13 then
                buffer.writeu8(buffer_create_ret, v14 + 1, v19 // 256 % 256);
            end;

            if v14 + 2 < v13 then
                buffer.writeu8(buffer_create_ret, v14 + 2, v19 % 256);
            end;

            v14 = v14 + 3;
            local _ = i;
        end;

        task.wait();
    end;

    return buffer_create_ret;
end;

return table.freeze(v1);