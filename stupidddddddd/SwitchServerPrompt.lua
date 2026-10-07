-- ReplicatedStorage.Interface.Screens.Menu.SwitchServerPrompt
-- Script path: ReplicatedStorage.Interface.Screens.Menu.SwitchServerPrompt
-- Decompile time: 1.15 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation)
local u31 = nil
local u32 = nil

local function GetPromptPlatform() -- Line: 31 -- upvalues: GetUserPlatform (val)
    local v1 = GetUserPlatform()
    if table.find(v1, "Mobile") then
        return "Mobile"
    end
    if table.find(v1, "Console") and not table.find(v1, "PC") then
        return "Console"
    end
    return nil
end

function v1.Initialize(a1, a2) -- Line: 45
    -- upvalues: u31 (ref), ActivateButton (val), u32 (ref), Remotes (val), GamepadNavigation (val)
    u31 = a2
    u31.Visible = false
    local Buttons = u31.Buttons.Buttons
    ActivateButton(Buttons.Yes)
    ActivateButton(Buttons.No)
    Buttons.Yes.MouseButton1Click:Connect(function() -- Line: 52 -- upvalues: u31 (upval), u32 (upval), Remotes (upval)
        u31.Visible = false
        if u32 then
            local v1 = u32
            Remotes.Modes.SelectGamemode.Send((("%*Server"):format(v1)))
        end
    end)
    Buttons.No.MouseButton1Click:Connect(function() -- Line: 58 -- upvalues: u31 (upval)
        u31.Visible = false
    end)
    GamepadNavigation.TrapPopup(u31, function() -- Line: 62 -- upvalues: Buttons (val)
        return Buttons.Yes
    end)
end

function v1.Start() -- Line: 69
    -- upvalues: GetPromptPlatform (val), GetUserPlatform (val), Constants (val), u32 (ref), u31 (ref)
    local v1 = GetPromptPlatform()
    warn((("[SwitchServerPrompt] platforms=%* promptPlatform=%* "):format(table.concat(GetUserPlatform(), ","), v1)) .. (("placeId=%* isDeviceServer=%* "):format(game.PlaceId, Constants.IS_DEVICE_SERVER)) .. (("target=%* "):format(v1 and Constants.GetDeviceServerPlaceId(v1, game.PlaceId))) .. ("isVIP=%*"):format((workspace:GetAttribute("IsVIPServer"))))
    if not v1 then
        return
    end
    if not Constants.IS_DEVICE_SERVER and Constants.GetDeviceServerPlaceId(v1, game.PlaceId) then
        if workspace:GetAttribute("IsVIPServer") == true then
            return
        end
        u32 = v1
        u31.TextLabel.Text = ("Do you want to join %* only servers?"):format(v1)
        u31.Visible = true
        return
    end
end

return v1