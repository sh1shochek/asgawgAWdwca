-- ReplicatedStorage.Components.Common.ItemEquipment
-- Script path: ReplicatedStorage.Components.Common.ItemEquipment
-- Decompile time: 0.71 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataController = require(ReplicatedStorage.Controllers.DataController)

local function isEquipped(a1, a2) -- Line: 6 -- types: a2: string
    if not a1 then
        return false
    end
    for i, j in a1.Loadout or {} do
        if j and j.Options and table.find(j.Options, a2) then
            return true
        end
    end
    for k, n in a1.Equipped or {} do
        if n == a2 then
            return true
        end
    end
    return false
end

return {
    IsEquippedOnTeam = function(a1, a2) -- Line: 25
        -- upvalues: DataController (val), Players (val), isEquipped (val)
        local v1 = DataController.Get(Players.LocalPlayer, "Loadout")
        return (isEquipped(v1 and v1[a2], a1))
    end,
    UpdateStatusFrame = function(a1, a2) -- Line: 30
        -- upvalues: DataController (val), Players (val), isEquipped (val)
        local Status = a1:FindFirstChild("Status")
        if not Status then
            return
        end
        local v1 = Status:FindFirstChild("Counter-Terrorists")
        local Terrorists = Status:FindFirstChild("Terrorists")
        if v1 and Terrorists then
            local v2 = DataController.Get(Players.LocalPlayer, "Loadout")
            v1.Visible = isEquipped(v2 and v2["Counter-Terrorists"], a2)
            Terrorists.Visible = isEquipped(v2 and v2.Terrorists, a2)
        end
    end,
}