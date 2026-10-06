-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Signal = require(ReplicatedStorage.Packages.Signal);
local u1 = false;
local u4 = {
    Changed = Signal.new(),

    IsLeftHanded = function() -- Line: 14, Name: IsLeftHanded
        -- upvalues: u1 (ref)
        return u1;
    end,

    IsPlayerLeftHanded = function(p2: userdata?) -- Line: 19, Name: IsPlayerLeftHanded
        -- upvalues: Players (copy), u1 (ref)
        if p2 == Players.LocalPlayer then
            return u1;
        end;

        local v3;

        if p2 == nil then
            v3 = false;
        else
            v3 = p2:GetAttribute("ViewmodelLeftHanded") == true;
        end;

        return v3;
    end
};

function u4.SetLeftHanded(p5: boolean) -- Line: 26
    -- upvalues: u1 (ref), u4 (copy), ReplicatedStorage (copy)
    if u1 ~= p5 then
        u1 = p5;
        u4.Changed:Fire(p5);
        require(ReplicatedStorage.Database.Security.Remotes).Player.SetViewmodelHand.Send(p5);
    end;
end;

function u4.Toggle() -- Line: 35
    -- upvalues: u4 (copy), u1 (ref)
    u4.SetLeftHanded(not u1);
end;

return table.freeze(u4);