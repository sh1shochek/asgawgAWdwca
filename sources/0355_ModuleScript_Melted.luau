-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Classes.Ragdoll.Types);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local Rig = require(ReplicatedStorage.Classes.Ragdoll.Rig);
local Goop = ReplicatedStorage.Assets.Finishers.Goop;

local function Activate(p1, p2) -- Line: 18
    -- upvalues: Rig (copy), Goop (copy)
    local LowerTorso = p1.CharacterModel:FindFirstChild("LowerTorso");

    if not LowerTorso then
        return;
    end;

    Rig.DisableJoint(p1.CharacterModel, "Waist");
    local UpperTorso = p1.CharacterModel:FindFirstChild("UpperTorso");

    if UpperTorso and UpperTorso:IsA("BasePart") then
        local AssemblyLinearVelocity = UpperTorso.AssemblyLinearVelocity;
        local math_random_ret = math.random(-3, 3);
        local math_random_ret2 = math.random(0, 3);
        UpperTorso.AssemblyLinearVelocity = AssemblyLinearVelocity + Vector3.new(math_random_ret, math_random_ret2, math.random(-3, 3));
    end;

    local v3 = Goop:Clone();
    v3.Weld.Part1 = LowerTorso;
    v3.Parent = p1.CharacterModel;
end;

return {
    Replication = "All",

    Finisher = function(p4: userdata, p5: any) -- Line: 44, Name: Finisher
        -- upvalues: Ragdoll (copy), Activate (copy)
        local u6 = Ragdoll.new(p4, p5);
        Activate(u6, p5);

        return {
            OnDestroy = u6.OnDestroy,

            Destroy = function() -- Line: 49, Name: Destroy
                -- upvalues: u6 (copy)
                u6:Destroy();
            end
        };
    end
};