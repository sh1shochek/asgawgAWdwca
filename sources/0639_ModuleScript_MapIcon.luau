-- Decompiled with Potassium's decompiler.

local Maps = game:GetService("ReplicatedStorage").Database.Custom.GameStats.Maps;
local u1 = {};
local Rect_new_ret = Rect.new(0, 0, 0, 0);
local table_freeze_ret = table.freeze({
    ["rbxassetid://72973444783842"] = Rect.new(280, 308, 756, 720),
    ["rbxassetid://96627370550320"] = Rect.new(296, 296, 688, 712),
    ["rbxassetid://88605850938693"] = Rect.new(252, 236, 748, 764),
    ["rbxassetid://139602408955630"] = Rect.new(260, 364, 760, 648),
    ["rbxassetid://118014135553992"] = Rect.new(240, 304, 784, 772),
    ["rbxassetid://95578841758233"] = Rect.new(268, 252, 756, 772),
    ["rbxassetid://78468254134558"] = Rect.new(276, 320, 716, 728)
});
local u2 = {};

local function Read(p3: string, p4: string) -- Line: 29
    -- upvalues: u2 (copy), Maps (copy)
    if p3 == "" then
        return "";
    end;

    local v5 = u2[p3];

    if not v5 then
        v5 = {};
        u2[p3] = v5;
    end;

    local v6 = v5[p4];

    if v6 then
        return v6;
    end;

    local v7 = Maps:FindFirstChild(p3);
    local v8 = "";

    if v7 and v7:IsA("ModuleScript") then
        local success, result = pcall(require, v7);

        if success and typeof(result) == "table" then
            v8 = tostring(result[p4] or "");
        end;
    end;

    if v8 ~= "" then
        v5[p4] = v8;
    end;

    return v8;
end;

function u1.Get(p9: string) -- Line: 65
    -- upvalues: Read (copy)
    return Read(p9, "Icon");
end;

function u1.GetRadar(p10: string) -- Line: 72
    -- upvalues: Read (copy), u1 (copy), Rect_new_ret (copy), table_freeze_ret (copy)
    local v11 = Read(p10, "Radar");

    if v11 == "" then
        return u1.Get(p10), Rect_new_ret;
    end;

    return v11, table_freeze_ret[v11] or Rect_new_ret;
end;

return u1;