-- ReplicatedStorage.Components.Common.VFXLibary.PlayZeusDeath
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.PlayZeusDeath
-- Decompile time: 1.50 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Other = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Other")

local function resolveVictimRagdoll(a1) -- Line: 14
    -- upvalues: Players (val), CollectionService (val)
    local Attribute, v1
    local PlayerByUserId = Players:GetPlayerByUserId(a1)
    if not PlayerByUserId then
        return nil
    end
    local v2 = nil
    local v3 = (-1 / 0)
    for i, j in CollectionService:GetTagged("Ragdoll") do
        if j:IsA("Model") and j.Name == PlayerByUserId.Name then
            v1 = workspace
            if j:IsDescendantOf(v1) then
                Attribute = j:GetAttribute("RagdollCreatedAt")
                if v3 < (if typeof(Attribute) ~= "number" then 0 else Attribute) then
                    v2 = j
                end
            end
        end
    end
    return v2
end

return function(a1) -- Line: 37 -- upvalues: Other (val), resolveVictimRagdoll (val), Debris (val)
    local v1 = tonumber(a1)
    if not v1 then
        return
    end
    local ZeusDeath = Other:FindFirstChild("ZeusDeath")
    if ZeusDeath and ZeusDeath:IsA("ParticleEmitter") then
        local v2 = resolveVictimRagdoll(v1)
        if not v2 then
            local v3 = os.clock() + 0.5
            repeat
                task.wait(0.05)
            until (resolveVictimRagdoll(v1)) or v3 <= os.clock()
        end
        if not v2 then
            return
        end
        local HumanoidRootPart = v2:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            local u43 = ZeusDeath:Clone()
            u43.Enabled = false
            u43.Parent = HumanoidRootPart
            local Attribute = u43:GetAttribute("EmitCount")
            if typeof(Attribute) ~= "number" or not (Attribute > 0) then
                u43.Enabled = true
                task.delay(0.15, function() -- Line: 75 -- upvalues: u43 (val)
                    if u43 and u43.Parent then
                        u43.Enabled = false
                    end
                end)
            else
                u43:Emit(Attribute)
            end
            Debris:AddItem(u43, (math.max(u43.Lifetime.Max, 1)) + 1)
            return
        end
        return
    end
end