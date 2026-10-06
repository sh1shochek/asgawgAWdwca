-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local Other = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Other");

local function resolveVictimRagdoll(p1: number) -- Line: 14
    -- upvalues: Players (copy), CollectionService (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p1);

    if not PlayerByUserId then
        return nil;
    end;

    local v2 = (-1 / 0);
    local v3 = nil;

    for _, v in CollectionService:GetTagged("Ragdoll") do
        if v:IsA("Model") and (v.Name == PlayerByUserId.Name and v:IsDescendantOf(workspace)) then
            local Attribute = v:GetAttribute("RagdollCreatedAt");
            local v4 = typeof(Attribute) ~= "number" and 0 or Attribute;

            if v2 < v4 then
                v3 = v;
                v2 = v4;
            end;
        end;
    end;

    return v3;
end;

return function(p5) -- Line: 37
    -- upvalues: Other (copy), resolveVictimRagdoll (copy), Debris (copy)
    local v6 = tonumber(p5);

    if not v6 then
        return;
    end;

    local ZeusDeath = Other:FindFirstChild("ZeusDeath");

    if not (ZeusDeath and ZeusDeath:IsA("ParticleEmitter")) then
        return;
    end;

    local v7 = resolveVictimRagdoll(v6);

    if not v7 then
        local v8 = os.clock() + 0.5;

        repeat
            task.wait(0.05);
            v7 = resolveVictimRagdoll(v6);
        until v7 or v8 <= os.clock();
    end;

    if not v7 then
        return;
    end;

    local HumanoidRootPart = v7:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local u9 = ZeusDeath:Clone();
    u9.Enabled = false;
    u9.Parent = HumanoidRootPart;
    local Attribute = u9:GetAttribute("EmitCount");

    if typeof(Attribute) == "number" and Attribute > 0 then
        u9:Emit(Attribute);
    else
        u9.Enabled = true;
        task.delay(0.15, function() -- Line: 75
            -- upvalues: u9 (copy)
            if u9 and u9.Parent then
                u9.Enabled = false;
            end;
        end);
    end;

    Debris:AddItem(u9, math.max(u9.Lifetime.Max, 1) + 1);
end;