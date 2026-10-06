-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {
    ["Counter-Terrorists"] = "rbxassetid://72938147057400",
    Terrorists = "rbxassetid://73218600485628"
};

return require(ReplicatedStorage.Packages.Observers).observeTag("TeamIcon", function(p2: userdata) -- Line: 18
    -- upvalues: u1 (copy)
    local Attribute = p2:GetAttribute("TeamName");
    local v3 = Attribute and u1[Attribute] or nil;

    if v3 then
        p2.Image = v3;
    end;

    return function() -- Line: 26
    end;
end);