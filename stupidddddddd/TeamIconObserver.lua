-- ReplicatedStorage.Controllers.Observers.UI.TeamIconObserver
-- Script path: ReplicatedStorage.Controllers.Observers.UI.TeamIconObserver
-- Decompile time: 0.26 ms

local u9 = {["Counter-Terrorists"] = "rbxassetid://72938147057400", Terrorists = "rbxassetid://73218600485628"}
return (require((game:GetService("ReplicatedStorage")).Packages.Observers)).observeTag("TeamIcon", function(a1) -- Line: 18 -- upvalues: u9 (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute("TeamName")
    local v1 = Attribute and u9[Attribute] or nil
    if v1 then
        a1.Image = v1
    end
    return function() end
end)