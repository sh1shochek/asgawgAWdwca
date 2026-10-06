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

local function Activate(u2, p3) -- Line: 31
    -- upvalues: LocalPlayer (copy), Finishers (copy)
    u2.Janitor:Add(script.FinisherGui:Clone(), "Destroy", "FinisherGui").Parent = LocalPlayer.PlayerGui;
    local v4 = Finishers:play({
        Name = "LeSunshine",
        Parent = LocalPlayer.PlayerGui
    });

    if not v4 then
        return;
    end;

    u2.Janitor:Add(v4.Ended:Once(function() -- Line: 44
        -- upvalues: u2 (copy)
        u2.Janitor:Remove("FinisherGui");
    end));
end;

return {
    Replication = "All",

    Finisher = function(p5: userdata, p6: any) -- Line: 54, Name: Finisher
        -- upvalues: Ragdoll (copy), LocalPlayer (copy), Activate (copy)
        local u7 = Ragdoll.new(p5, p6);

        if tostring(p6.Victim) == tostring(LocalPlayer.UserId) then
            Activate(u7, p6);
        end;

        return {
            OnDestroy = u7.OnDestroy,

            Destroy = function() -- Line: 62, Name: Destroy
                -- upvalues: u7 (copy)
                u7:Destroy();
            end
        };
    end
};