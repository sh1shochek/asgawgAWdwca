-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Debris = workspace:WaitForChild("Debris");
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);

local function isPersistentDebris(p1: userdata) -- Line: 17
    return p1:GetAttribute("PersistentDebris") == true and true or (string.sub(p1.Name, -7) == "_Weapon" and true or string.find(p1.Name, "_WeaponAttachments", 1, true) ~= nil);
end;

return function() -- Line: 31
    -- upvalues: Debris (copy), Ragdoll (copy), Players (copy), DebugFlags (copy)
    local v2 = 0;
    local v3 = 0;

    for _, child in Debris:GetChildren() do
        if not child:IsA("Folder") then
            if child:GetAttribute("PersistentDebris") == true and true or (string.sub(child.Name, -7) == "_Weapon" and true or string.find(child.Name, "_WeaponAttachments", 1, true) ~= nil) then
                v2 = v2 + 1;
            elseif child:IsA("Model") and (child:GetAttribute("CharacterType") ~= nil or child:FindFirstChildOfClass("Humanoid") ~= nil) then
                v2 = v2 + 1;
                Ragdoll.HideCharacterLocally(child);
            else
                v3 = v3 + 1;

                if Players:FindFirstChild(child.Name) then
                    task.delay(0.5, function() -- Line: 56
                        -- upvalues: child (copy)
                        if child and child.Parent then
                            child:Destroy();
                        end;
                    end);
                else
                    child:Destroy();
                end;
            end;
        end;
    end;

    if DebugFlags.IsEnabled("DebrisCleanup") then
        warn(("[DebrisCleanup][Client] CleanupDebris received: destroyed=%d skipped=%d"):format(v3, v2));
    end;
end;