-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.Classes.Ragdoll.Types);
local LocalPlayer = Players.LocalPlayer;
local Sound = require(ReplicatedStorage.Classes.Sound);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local Finishers = Sound.new("Finishers");

local function IsLocalPlayer(p1) -- Line: 25
    -- upvalues: LocalPlayer (copy)
    return tostring(p1) == tostring(LocalPlayer.UserId);
end;

return {
    Replication = "All",

    Finisher = function(p2: userdata, p3: any) -- Line: 35, Name: Finisher
        -- upvalues: Ragdoll (copy), LocalPlayer (copy), Finishers (copy)
        local u4 = Ragdoll.new(p2, p3);

        if tostring(p3.Victim) == tostring(LocalPlayer.UserId) then
            Finishers:play({
                Name = "Fling",
                Parent = LocalPlayer.PlayerGui
            });
        end;

        return {
            OnDestroy = u4.OnDestroy,

            Destroy = function() -- Line: 43, Name: Destroy
                -- upvalues: u4 (copy)
                u4:Destroy();
            end
        };
    end
};