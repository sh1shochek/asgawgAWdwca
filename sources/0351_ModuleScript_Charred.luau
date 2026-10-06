-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Classes.Ragdoll.Types);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local Fire = Instance.new("Fire", nil);
Fire.Color = Color3.fromRGB(235, 135, 65);
Fire.Heat = 12;
Fire.Size = 10;

local function Activate(p1, p2) -- Line: 21
    -- upvalues: Fire (copy)
    p1.Janitor:Add(Fire:Clone()).Parent = p1.CharacterModel.PrimaryPart;

    if p1.CharacterModel:FindFirstChild("CharacterArmor") then
        p1.CharacterModel.CharacterArmor:Destroy();
    end;

    for _, descendant in ipairs(p1.CharacterModel:GetDescendants()) do
        if descendant:IsA("Shirt") or descendant:IsA("Pants") then
            descendant:Destroy();
        elseif descendant:IsA("BasePart") then
            descendant.Material = Enum.Material.CorrodedMetal;
            descendant.Color = Color3.fromRGB(60, 30, 5);
        end;
    end;
end;

return {
    Replication = "All",

    Finisher = function(p3: userdata, u4: any) -- Line: 44, Name: Finisher
        -- upvalues: Ragdoll (copy), Activate (copy)
        local u5 = Ragdoll.new(p3, u4);
        u5:OnceAppearanceReady(function() -- Line: 47
            -- upvalues: Activate (ref), u5 (copy), u4 (copy)
            Activate(u5, u4);
        end);

        return {
            OnDestroy = u5.OnDestroy,

            Destroy = function() -- Line: 52, Name: Destroy
                -- upvalues: u5 (copy)
                u5:Destroy();
            end
        };
    end
};