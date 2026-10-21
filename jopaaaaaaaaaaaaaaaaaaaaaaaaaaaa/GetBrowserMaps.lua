-- ReplicatedStorage.Database.Components.Common.GetBrowserMaps
-- Script path: ReplicatedStorage.Database.Components.Common.GetBrowserMaps
-- Decompile time: 3.35 ms

-- Decompiled with Potassium's decompiler.

local GameStats = game:GetService("ReplicatedStorage").Database.Custom.GameStats;
local table_freeze_ret = table.freeze({ "Casual", "Competitive", "Deathmatch" });

return function() -- Line: 17
    -- upvalues: table_freeze_ret (copy), GameStats (copy)
    local v1 = {};

    for _, v in table_freeze_ret do
        for _, v2 in require((GameStats.Gamemodes:FindFirstChild(v))).Maps do
            if not table.find(v1, v2) then
                local v3 = GameStats.Maps:FindFirstChild(v2);

                if v3 and v3:IsA("ModuleScript") then
                    local success, result = pcall(require, v3);

                    if not (success and (typeof(result) == "table" and result.Hidden == true)) then
                        table.insert(v1, v2);
                    end;
                end;
            end;
        end;
    end;

    return v1;
end;