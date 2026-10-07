-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.HoverHostage
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.HoverHostage
-- Decompile time: 3.22 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local InputController = require(ReplicatedStorage.Controllers.InputController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local u34 = nil
local u35 = nil
local u36 = nil
local u37 = nil

local function FormatKeybind(a1) -- Line: 31 -- types: a1: string?
    if not a1 then
        return "E"
    end
    return ((a1:gsub("Enum%.KeyCode%.", "")):gsub("Enum%.UserInputType%.", "")):gsub("Enum%.CustomInputType%.", "")
end

local function IsCharacterAlive(a1) -- Line: 39 -- upvalues: CharacterResolver (val) -- types: a1: userdata
    return CharacterResolver.isAliveCharacter(a1.Character)
end

local function ShouldRunUpdate() -- Line: 43 -- upvalues: LocalPlayer (val), CharacterResolver (val)
    local v1 = false
    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        v1 = CharacterResolver.isAliveCharacter(LocalPlayer.Character)
    end
    return v1
end

local function StopUpdateConnection() -- Line: 47 -- upvalues: u37 (ref)
    if u37 then
        u37:Disconnect()
        u37 = nil
    end
end

local function SyncUpdateConnection() -- Line: 54
    -- upvalues: LocalPlayer (val), CharacterResolver (val), u37 (ref), RunServiceController (val), u34 (ref), u0 (val)
    local v1 = false
    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        local v2 = LocalPlayer
        v1 = CharacterResolver.isAliveCharacter(v2.Character)
    end
    if v1 then
        if u37 then
            return
        end
        u37 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(a1) -- Line: 60
            -- upvalues: LocalPlayer (upval), CharacterResolver (upval), u34 (upval), u37 (upval), u0 (upval)
            local v1 = false
            if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                local v2 = LocalPlayer
                v1 = CharacterResolver.isAliveCharacter(v2.Character)
            end
            if v1 then
                v1 = u0.GetHoverState()
                u34.Visible = v1
                return
            end
            u34.Visible = false
            if u37 then
                u37:Disconnect()
                u37 = nil
            end
        end)
        return
    end
    u34.Visible = false
    if u37 then
        u37:Disconnect()
        u37 = nil
    end
end

local function TrackCharacter(a1) -- Line: 77
    -- upvalues: u35 (ref), u36 (ref), SyncUpdateConnection (val), LocalPlayer (val), CharacterResolver (val), u37 (ref)
    -- upvalues: RunServiceController (val), u34 (ref), u0 (val)
    if u35 then
        u35:Disconnect()
        u35 = nil
    end
    if u36 then
        u36:Disconnect()
        u36 = nil
    end
    if a1 then
        u35 = (a1:GetAttributeChangedSignal("Dead")):Connect(SyncUpdateConnection)
        u36 = a1.ChildAdded:Connect(function(a1) -- Line: 89
            -- upvalues: LocalPlayer (upval), CharacterResolver (upval), u37 (upval), RunServiceController (upval)
            -- upvalues: u34 (upval), u0 (upval)
            if a1:IsA("Humanoid") then
                local v1 = false
                if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                    local v2 = LocalPlayer
                    v1 = CharacterResolver.isAliveCharacter(v2.Character)
                end
                if v1 then
                    if u37 then
                        return
                    end
                    u37 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(a1) -- Line: 60
                        -- upvalues: LocalPlayer (upval), CharacterResolver (upval), u34 (upval), u37 (upval)
                        -- upvalues: u0 (upval)
                        local v1 = false
                        if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                            local v2 = LocalPlayer
                            v1 = CharacterResolver.isAliveCharacter(v2.Character)
                        end
                        if v1 then
                            v1 = u0.GetHoverState()
                            u34.Visible = v1
                            return
                        end
                        u34.Visible = false
                        if u37 then
                            u37:Disconnect()
                            u37 = nil
                        end
                    end)
                    return
                end
                u34.Visible = false
                if u37 then
                    u37:Disconnect()
                    u37 = nil
                end
            end
        end)
    end
    local v1 = false
    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        local v2 = LocalPlayer
        v1 = CharacterResolver.isAliveCharacter(v2.Character)
    end
    if v1 then
        if u37 then
            return
        end
        u37 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(a1) -- Line: 60
            -- upvalues: LocalPlayer (upval), CharacterResolver (upval), u34 (upval), u37 (upval), u0 (upval)
            local v1 = false
            if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                local v2 = LocalPlayer
                v1 = CharacterResolver.isAliveCharacter(v2.Character)
            end
            if v1 then
                v1 = u0.GetHoverState()
                u34.Visible = v1
                return
            end
            u34.Visible = false
            if u37 then
                u37:Disconnect()
                u37 = nil
            end
        end)
        return
    end
    u34.Visible = false
    if u37 then
        u37:Disconnect()
        u37 = nil
    end
end

function u0.GetHoverState() -- Line: 102 -- upvalues: CenterScreenRaycast (val)
    return CenterScreenRaycast.GetHoveredHostage(5) ~= nil
end

function u0.Initialize(a1, a2) -- Line: 109
    -- upvalues: u34 (ref), InputController (val), DataController (val), LocalPlayer (val), SyncUpdateConnection (val)
    -- upvalues: TrackCharacter (val), u35 (ref), u36 (ref), CharacterResolver (val), u37 (ref)
    -- upvalues: RunServiceController (val), u0 (val)
    u34 = a2

    local function UpdateFrameText() -- Line: 113 -- upvalues: InputController (upval), u34 (upval)
        local Use = InputController.GetActionKeybind("Use")
        u34.Text = ("[%*] Pick Up Hostage"):format(if Use then ((Use:gsub("Enum%.KeyCode%.", "")):gsub("Enum%.UserInputType%.", "")):gsub("Enum%.CustomInputType%.", "") else "E")
    end

    local Use = InputController.GetActionKeybind("Use")
    u34.Text = ("[%*] Pick Up Hostage"):format(if Use then ((Use:gsub("Enum%.KeyCode%.", "")):gsub("Enum%.UserInputType%.", "")):gsub("Enum%.CustomInputType%.", "") else "E")
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(a1) -- Line: 122 -- upvalues: UpdateFrameText (val)
        if not a1 then
            return
        end
        task.defer(UpdateFrameText)
    end)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(SyncUpdateConnection)
    LocalPlayer.CharacterAdded:Connect(TrackCharacter)
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 132
        -- upvalues: u35 (upval), u36 (upval), LocalPlayer (upval), CharacterResolver (upval), u37 (upval)
        -- upvalues: RunServiceController (upval), u34 (upval), u0 (upval)
        if u35 then
            u35:Disconnect()
            u35 = nil
        end
        if u36 then
            u36:Disconnect()
            u36 = nil
        end
        local v1 = false
        if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
            local v2 = LocalPlayer
            v1 = CharacterResolver.isAliveCharacter(v2.Character)
        end
        if v1 then
            if u37 then
                return
            end
            u37 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(a1) -- Line: 60
                -- upvalues: LocalPlayer (upval), CharacterResolver (upval), u34 (upval), u37 (upval), u0 (upval)
                local v1 = false
                if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                    local v2 = LocalPlayer
                    v1 = CharacterResolver.isAliveCharacter(v2.Character)
                end
                if v1 then
                    v1 = u0.GetHoverState()
                    u34.Visible = v1
                    return
                end
                u34.Visible = false
                if u37 then
                    u37:Disconnect()
                    u37 = nil
                end
            end)
            return
        end
        u34.Visible = false
        if u37 then
            u37:Disconnect()
            u37 = nil
        end
    end)
    TrackCharacter(LocalPlayer.Character)
end

return u0