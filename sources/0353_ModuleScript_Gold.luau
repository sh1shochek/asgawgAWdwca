-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Classes.Ragdoll.Types);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local Finishers = Sound.new("Finishers");

local function Activate(p1, p2) -- Line: 22
    -- upvalues: Finishers (copy)
    Finishers:play({
        Name = "Gold",
        Parent = p1.CharacterModel
    });

    if p1.CharacterModel:FindFirstChild("CharacterArmor") then
        p1.CharacterModel.CharacterArmor:Destroy();
    end;

    for _, descendant in ipairs(p1.CharacterModel:GetDescendants()) do
        if descendant:IsA("Shirt") or descendant:IsA("Pants") then
            descendant:Destroy();
        elseif descendant:IsA("BasePart") then
            descendant.Color = Color3.fromRGB(255, 170, 0);
            descendant.Material = Enum.Material.Metal;
        end;
    end;
end;

return {
    Replication = "All",

    Finisher = function(p3: userdata, u4: any) -- Line: 45, Name: Finisher
        -- upvalues: Ragdoll (copy), Activate (copy)
        local u5 = Ragdoll.new(p3, u4);
        u5:OnceAppearanceReady(function() -- Line: 48
            -- upvalues: Activate (ref), u5 (copy), u4 (copy)
            Activate(u5, u4);
        end);

        return {
            OnDestroy = u5.OnDestroy,

            Destroy = function() -- Line: 53, Name: Destroy
                -- upvalues: u5 (copy)
                u5:Destroy();
            end
        };
    end
};