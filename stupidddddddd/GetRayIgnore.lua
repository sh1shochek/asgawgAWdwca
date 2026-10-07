-- ReplicatedStorage.Components.Common.GetRayIgnore
-- Script path: ReplicatedStorage.Components.Common.GetRayIgnore
-- Decompile time: 1.22 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CurrentCamera = workspace.CurrentCamera
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Debris = workspace:WaitForChild("Debris")
local u17 = {"Cameras", "Barriers", "Ambience"}
local u21 = {"Spawns", "Sites"}

local function addChildren(a1, a2, a3) -- Line: 20 -- types: a1: table, a2: userdata, a3: table
    local v1
    for i, j in a3 do
        v1 = a2:FindFirstChild(j)
        if v1 then
            table.insert(a1, v1)
        end
    end
end

return function() -- Line: 32 -- upvalues: Debris (val), CurrentCamera (val), u17 (val), u21 (val), CharacterResolver (val)
    local v1 = {Debris, CurrentCamera}
    local Map = workspace:FindFirstChild("Map")
    if Map then
        local v2
        for i, j in u17 do
            v2 = Map:FindFirstChild(j)
            if v2 then
                table.insert(v1, v2)
            end
        end
        local Zones = Map:FindFirstChild("Zones")
        if Zones then
            local v3
            for k, n in u21 do
                v3 = Zones:FindFirstChild(n)
                if v3 then
                    table.insert(v1, v3)
                end
            end
        end
    end
    local v4 = CharacterResolver.getLocalCharacter()
    if v4 and v4:IsDescendantOf(workspace) then
        table.insert(v1, v4)
    end
    return v1
end