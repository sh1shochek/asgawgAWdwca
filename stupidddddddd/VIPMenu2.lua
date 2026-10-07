-- ReplicatedStorage.Controllers.InputController.Actions.VIPMenu
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.VIPMenu
-- Decompile time: 1.24 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local LocalPlayer = Players.LocalPlayer
local u17 = nil
local u18 = 0

local function getVIPMenu() -- Line: 23 -- upvalues: u17 (ref), ReplicatedStorage (val)
    if u17 then
        return u17
    end
    local success, result = pcall(function() -- Line: 28 -- upvalues: ReplicatedStorage (upval)
        return require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu)
    end)
    if success then
        return result
    end
    warn((("Failed to load VIPMenu module: %*"):format((tostring(result)))))
    return nil
end

local function toggleVIPMenu() -- Line: 43 -- upvalues: u18 (ref), LocalPlayer (val), u17 (ref), ReplicatedStorage (val)
    local v1
    local v2 = os.clock()
    if v2 - u18 < 0.15 then
        return
    end
    u18 = v2
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        return
    end
    if not u17 then
        local success, result = pcall(function() -- Line: 28 -- upvalues: ReplicatedStorage (upval)
            return require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu)
        end)
        if success then
            v1 = result
        else
            warn((("Failed to load VIPMenu module: %*"):format((tostring(result)))))
            v1 = nil
        end
    else
        v1 = u17
    end
    if v1 then
        v1.toggleFrame()
    end
end

return (table.freeze({
    Name = "VIP Menu",
    Group = "Default",
    Category = "UI Keys",
    BindPriority = Enum.ContextActionPriority.High.Value + 1,
    Callback = function(a1, a2) -- Line: 63
        -- upvalues: u18 (ref), LocalPlayer (val), u17 (ref), ReplicatedStorage (val)
        local v1
        if a1 ~= Enum.UserInputState.Begin then
            return
        end
        local v2 = os.clock()
        if v2 - u18 < 0.15 then
            return
        end
        u18 = v2
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return
        end
        if not u17 then
            local success, result = pcall(function() -- Line: 28 -- upvalues: ReplicatedStorage (upval)
                return require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu)
            end)
            if success then
                v1 = result
            else
                warn((("Failed to load VIPMenu module: %*"):format((tostring(result)))))
                v1 = nil
            end
        else
            v1 = u17
        end
        if v1 then
            v1.toggleFrame()
        end
    end,
}))