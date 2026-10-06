-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);

local function isEquipped(p1: any, p2: string) -- Line: 6
    if not p1 then
        return false;
    end;

    for _, v in p1.Loadout or {} do
        if v and (v.Options and table.find(v.Options, p2)) then
            return true;
        end;
    end;

    for _, v in p1.Equipped or {} do
        if v == p2 then
            return true;
        end;
    end;

    return false;
end;

return {
    IsEquippedOnTeam = function(p3: string, p4: string) -- Line: 25, Name: IsEquippedOnTeam
        -- upvalues: DataController (copy), Players (copy), isEquipped (copy)
        local v5 = DataController.Get(Players.LocalPlayer, "Loadout");

        if v5 then
            v5 = v5[p4];
        end;

        return isEquipped(v5, p3);
    end,

    UpdateStatusFrame = function(p6: userdata, p7: string) -- Line: 30, Name: UpdateStatusFrame
        -- upvalues: DataController (copy), Players (copy), isEquipped (copy)
        local Status = p6:FindFirstChild("Status");

        if not Status then
            return;
        end;

        local v8 = Status:FindFirstChild("Counter-Terrorists");
        local Terrorists = Status:FindFirstChild("Terrorists");

        if v8 and Terrorists then
            local v9 = DataController.Get(Players.LocalPlayer, "Loadout");
            local v10;

            if v9 then
                v10 = v9["Counter-Terrorists"];
            else
                v10 = v9;
            end;

            v8.Visible = isEquipped(v10, p7);

            if v9 then
                v9 = v9.Terrorists;
            end;

            Terrorists.Visible = isEquipped(v9, p7);
        end;
    end
};