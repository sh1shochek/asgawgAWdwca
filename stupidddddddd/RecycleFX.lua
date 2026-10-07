-- ReplicatedStorage.Components.Common.RecycleFX
-- Script path: ReplicatedStorage.Components.Common.RecycleFX
-- Decompile time: 1.18 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = workspace:WaitForChild("Debris")
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)

local function isPersistentDebris(a1) -- Line: 17 -- types: a1: userdata
    if a1:GetAttribute("PersistentDebris") == true or string.sub(a1.Name, -7) == "_Weapon" then
        return true
    end
    return string.find(a1.Name, "_WeaponAttachments", 1, true) ~= nil
end

return function() -- Line: 31 -- upvalues: Debris (val), Ragdoll (val), Players (val), DebugFlags (val)
    local v1 = 0
    local v2 = 0
    for i, j in Debris:GetChildren() do
        if not j:IsA("Folder") then
            if if j:GetAttribute("PersistentDebris") ~= true then if string.sub(j.Name, -7) ~= "_Weapon" then string.find(j.Name, "_WeaponAttachments", 1, true) ~= nil else true else true then
                v2 = v2 + 1
            elseif not j:IsA("Model") then
                v1 = v1 + 1
                if not Players:FindFirstChild(j.Name) then
                    j:Destroy()
                else
                    task.delay(0.5, function() -- Line: 56 -- upvalues: j (val)
                        if j and j.Parent then
                            j:Destroy()
                        end
                    end)
                end
            elseif j:GetAttribute("CharacterType") ~= nil then
                v2 = v2 + 1
                Ragdoll.HideCharacterLocally(j)
            elseif j:FindFirstChildOfClass("Humanoid") == nil then
                v1 = v1 + 1
                if not Players:FindFirstChild(j.Name) then
                    j:Destroy()
                else
                    task.delay(0.5, function() -- Line: 56 -- upvalues: j (val)
                        if j and j.Parent then
                            j:Destroy()
                        end
                    end)
                end
            else
                v2 = v2 + 1
                Ragdoll.HideCharacterLocally(j)
            end
        end
    end
    if DebugFlags.IsEnabled("DebrisCleanup") then
        warn(("[DebrisCleanup][Client] CleanupDebris received: destroyed=%d skipped=%d"):format(v1, v2))
    end
end