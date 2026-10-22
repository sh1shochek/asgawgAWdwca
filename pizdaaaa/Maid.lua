-- ReplicatedStorage.Shared.Utility.Maid
-- Script path: ReplicatedStorage.Shared.Utility.Maid
-- Decompile time: 6.09 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};

local function Remove(p2, p3) -- Line: 8
    local v4 = p2.Buffer[p3];

    if v4 then
        v4:Disconnect();
        p2.Buffer[p3] = nil;
    end;
end;

local function Add(p5: any, p6: string, p7: any) -- Line: 17
    local v8 = p5.Buffer[p6];

    if v8 then
        v8:Disconnect();
        p5.Buffer[p6] = nil;
    end;

    p5.Buffer[p6] = p7;
end;

local function Removes(p9, ...) -- Line: 22
    for i = 1, select("#", ...) do
        local v10 = select(i, ...);
        local v11;

        if v10 == nil then
            v11 = i;
        else
            local v12 = p9.Buffer[v10];

            if v12 then
                v12:Disconnect();
                p9.Buffer[v10] = nil;
                v11 = i;
            else
                v11 = i;
            end;
        end;
    end;
end;

local function Cleanup(p13) -- Line: 34
    for i, _ in p13.Buffer do
        local v14 = p13.Buffer[i];

        if v14 then
            v14:Disconnect();
            p13.Buffer[i] = nil;
        end;
    end;
end;

local function Destroy(p15) -- Line: 40
    p15:Cleanup();
    table.clear(p15);
end;

function v1.new() -- Line: 46
    -- upvalues: Add (copy), Remove (copy), Removes (copy), Cleanup (copy), Destroy (copy)
    return {
        Buffer = {},
        Add = Add,
        Remove = Remove,
        Removes = Removes,
        Cleanup = Cleanup,
        Destroy = Destroy
    };
end;

return v1;