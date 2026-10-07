-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.HoverBomb
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.HoverBomb
-- Decompile time: 8.31 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Router = require(ReplicatedStorage.Database.Security.Router)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips)
local u67 = table.find(GetUserPlatform(), "Mobile")
if u67 then
    u67 = #GetUserPlatform() <= 1
end
local u68 = nil
local u69 = false
local u70 = nil
local u71 = nil

local function IsCharacterAlive(a1) -- Line: 49 -- upvalues: CharacterResolver (val) -- types: a1: userdata
    return CharacterResolver.isAliveCharacter(a1.Character)
end

local function GetPromptParts() -- Line: 53 -- upvalues: u70 (ref)
    if not u70 then
        return nil, nil
    end
    local TextLabel = u70:FindFirstChild("TextLabel")
    local Keybind = u70:FindFirstChild("Keybind")
    if TextLabel and TextLabel:IsA("TextLabel") then
        return TextLabel, Keybind and Keybind:IsA("ImageButton") and Keybind or nil
    end
    warn((("[HoverBomb]: %* has no TextLabel child; the defuse prompt cannot render"):format((u70:GetFullName()))))
    return nil, nil
end

local function RefreshPrompt() -- Line: 68 -- upvalues: GetPromptParts (val), u67 (val), Tips (val)
    local v1, v2 = GetPromptParts()
    if not v1 then
        return
    end
    if u67 then
        v1.Text = "Hold to Defuse"
        if v2 then
            v2.Visible = false
        end
        return
    end
    v1.Text = "Defuse Bomb"
    if v2 then
        v2.Visible = Tips.ApplyBindingToKeybind(v2, Tips.ResolveActionBinding("Use"))
    end
end

local function LayoutKeybind() -- Line: 88 -- upvalues: GetPromptParts (val), u70 (ref)
    local v1, v2 = GetPromptParts()
    if v1 and v2 then
        local X = u70.AbsoluteSize.X
        if X <= 0 then
            return
        end
        v2.Position = UDim2.fromScale(v1.Position.X.Scale - v1.TextBounds.X / X / 2 - 0.006, v1.Position.Y.Scale)
        return
    end
end

local function IsBombResolved(a1) -- Line: 103 -- types: a1: userdata?
    if not a1 then
        return false
    end
    local v1 = true
    if a1:GetAttribute("Defused") ~= true then
        v1 = true
        if a1:GetAttribute("Exploding") ~= true then
            v1 = a1:GetAttribute("Exploded") == true
        end
    end
    return v1
end

local function GetActiveBomb() -- Line: 113 -- upvalues: CollectionService (val)
    local v1 = CollectionService:GetTagged("Bomb")[1]
    if v1 then
        local v2
        if v1 then
            v2 = true
            if v1:GetAttribute("Defused") ~= true then
                v2 = true
                if v1:GetAttribute("Exploding") ~= true then
                    v2 = v1:GetAttribute("Exploded") == true
                end
            end
        else
            v2 = false
        end
        if not v2 then
            return v1
        end
    end
    return nil
end

local function ShouldRunUpdate() -- Line: 122 -- upvalues: LocalPlayer (val), CollectionService (val)
    local v1 = false
    if workspace:GetAttribute("Gamemode") == "Bomb Defusal" then
        v1 = false
        if LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
            local v2
            local v3 = CollectionService:GetTagged("Bomb")[1]
            if not v3 then
                v2 = nil
            else
                local v4
                if v3 then
                    v4 = true
                    if v3:GetAttribute("Defused") ~= true then
                        v4 = true
                        if v3:GetAttribute("Exploding") ~= true then
                            v4 = v3:GetAttribute("Exploded") == true
                        end
                    end
                else
                    v4 = false
                end
                v2 = if v4 then nil else v3
            end
            v1 = v2 ~= nil
        end
    end
    return v1
end

local function StopUpdateConnection() -- Line: 128 -- upvalues: u71 (ref)
    if u71 then
        u71:Disconnect()
        u71 = nil
    end
end

local function CancelMobileDefuseIfNeeded() -- Line: 135
    -- upvalues: u67 (val), u69 (ref), CollectionService (val), u68 (ref), Router (val)
    if u67 and u69 then
        local v1
        local v2 = CollectionService:GetTagged("Bomb")[1]
        if v2 then
            v1 = true
            if v2:GetAttribute("Defused") ~= true then
                v1 = true
                if v2:GetAttribute("Exploding") ~= true then
                    v1 = v2:GetAttribute("Exploded") == true
                end
            end
        else
            v1 = false
        end
        u69 = false
        u68 = nil
        if not v1 then
            Router.broadcastRouter("Cancel Defuse Bomb")
        end
        return
    end
end

local function SyncUpdateConnection() -- Line: 149
    -- upvalues: LocalPlayer (val), CollectionService (val), u71 (ref), RunServiceController (val), u70 (ref), u67 (val)
    -- upvalues: u69 (ref), u68 (ref), Router (val), CharacterResolver (val), u0 (val), LayoutKeybind (val)
    local v1
    local v2 = false
    if workspace:GetAttribute("Gamemode") == "Bomb Defusal" then
        v2 = false
        if LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
            local v3 = CollectionService:GetTagged("Bomb")[1]
            if not v3 then
                v1 = nil
            else
                local v4
                if v3 then
                    v4 = true
                    if v3:GetAttribute("Defused") ~= true then
                        v4 = true
                        if v3:GetAttribute("Exploding") ~= true then
                            v4 = v3:GetAttribute("Exploded") == true
                        end
                    end
                else
                    v4 = false
                end
                v1 = if v4 then nil else v3
            end
            v2 = v1 ~= nil
        end
    end
    if v2 then
        if u71 then
            return
        end
        u71 = RunServiceController.BindToHeartbeat("UI.HoverBomb.Update", function(a1) -- Line: 155
            -- upvalues: LocalPlayer (upval), CollectionService (upval), u70 (upval), u67 (upval), u69 (upval)
            -- upvalues: u68 (upval), Router (upval), u71 (upval), CharacterResolver (upval), u0 (upval)
            -- upvalues: LayoutKeybind (upval)
            local v1, v2
            local v3 = false
            if workspace:GetAttribute("Gamemode") == "Bomb Defusal" then
                v3 = false
                if LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
                    v2 = CollectionService:GetTagged("Bomb")[1]
                    if not v2 then
                        v1 = nil
                    else
                        local v4
                        if v2 then
                            v4 = true
                            if v2:GetAttribute("Defused") ~= true then
                                v4 = true
                                if v2:GetAttribute("Exploding") ~= true then
                                    v4 = v2:GetAttribute("Exploded") == true
                                end
                            end
                        else
                            v4 = false
                        end
                        v1 = if v4 then nil else v2
                    end
                    v3 = v1 ~= nil
                end
            end
            if not v3 then
                u70.Visible = false
                if u67 and u69 then
                    v1 = CollectionService:GetTagged("Bomb")[1]
                    if v1 then
                        v3 = true
                        if v1:GetAttribute("Defused") ~= true then
                            v3 = true
                            if v1:GetAttribute("Exploding") ~= true then
                                v3 = v1:GetAttribute("Exploded") == true
                            end
                        end
                    else
                        v3 = false
                    end
                    u69 = false
                    u68 = nil
                    if not v3 then
                        Router.broadcastRouter("Cancel Defuse Bomb")
                    end
                end
                if u71 then
                    u71:Disconnect()
                    u71 = nil
                end
                return
            end
            v1 = LocalPlayer
            if not CharacterResolver.isAliveCharacter(v1.Character) then
                u70.Visible = false
                if u67 and u69 then
                    u69 = false
                    u68 = nil
                end
                return
            end
            v3 = u0.GetHoverState()
            u70.Visible = v3
            if v3 then
                LayoutKeybind()
            end
            if u67 and u69 and not v3 and u67 then
                if not u69 then
                    return
                end
                v2 = CollectionService:GetTagged("Bomb")[1]
                if v2 then
                    v1 = true
                    if v2:GetAttribute("Defused") ~= true then
                        v1 = true
                        if v2:GetAttribute("Exploding") ~= true then
                            v1 = v2:GetAttribute("Exploded") == true
                        end
                    end
                else
                    v1 = false
                end
                u69 = false
                u68 = nil
                if not v1 then
                    Router.broadcastRouter("Cancel Defuse Bomb")
                    return
                end
            end
        end)
        return
    end
    u70.Visible = false
    if u67 and u69 then
        v1 = CollectionService:GetTagged("Bomb")[1]
        if v1 then
            v2 = true
            if v1:GetAttribute("Defused") ~= true then
                v2 = true
                if v1:GetAttribute("Exploding") ~= true then
                    v2 = v1:GetAttribute("Exploded") == true
                end
            end
        else
            v2 = false
        end
        u69 = false
        u68 = nil
        if not v2 then
            Router.broadcastRouter("Cancel Defuse Bomb")
        end
    end
    if u71 then
        u71:Disconnect()
        u71 = nil
    end
end

function u0.IsDefuseAllowed() -- Line: 194 -- upvalues: IsTutorialMode (val), LocalPlayer (val)
    return not IsTutorialMode() or LocalPlayer:GetAttribute("TutorialStep") == "DefuseB"
end

function u0.IsInDefuseRange() -- Line: 199 -- upvalues: LocalPlayer (val), CollectionService (val)
    local v1
    if LocalPlayer:GetAttribute("Team") ~= "Counter-Terrorists" then
        return false
    end
    local v2 = CollectionService:GetTagged("Bomb")[1]
    if not v2 then
        v1 = nil
    else
        local v3
        if v2 then
            v3 = true
            if v2:GetAttribute("Defused") ~= true then
                v3 = true
                if v2:GetAttribute("Exploding") ~= true then
                    v3 = v2:GetAttribute("Exploded") == true
                end
            end
        else
            v3 = false
        end
        v1 = if v3 then nil else v2
    end
    local Character = LocalPlayer.Character
    local PrimaryPart = Character and Character.PrimaryPart
    local PrimaryPart_2 = v1 and v1:IsA("Model") and v1.PrimaryPart
    if PrimaryPart and PrimaryPart_2 then
        return (PrimaryPart.Position - PrimaryPart_2.Position).Magnitude <= 5
    end
    return false
end

function u0.GetHoverState() -- Line: 213
    -- upvalues: LocalPlayer (val), u0 (val), CollectionService (val), u67 (val), u69 (ref)
    if LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" and u0.IsDefuseAllowed() then
        local v1
        local v2 = CollectionService:GetTagged("Bomb")[1]
        if not v2 then
            v1 = nil
        else
            local v3
            if v2 then
                v3 = true
                if v2:GetAttribute("Defused") ~= true then
                    v3 = true
                    if v2:GetAttribute("Exploding") ~= true then
                        v3 = v2:GetAttribute("Exploded") == true
                    end
                end
            else
                v3 = false
            end
            v1 = if v3 then nil else v2
        end
        if not v1 then
            return false
        end
        if not u67 then
            if v1:GetAttribute("CanDefuse") and not v1:GetAttribute("IsGettingDefused") then
                return true
            end
            return false
        end
        if not u69 and LocalPlayer:GetAttribute("IsDefusingBomb") ~= true then
            if v1:GetAttribute("CanDefuse") and not v1:GetAttribute("IsGettingDefused") then
                return true
            end
            return false
        end
        return true
    end
    return false
end

function u0.Initialize(a1, a2) -- Line: 235
    -- upvalues: u70 (ref), GetPromptParts (val), u67 (val), Tips (val), DataController (val), LocalPlayer (val)
    -- upvalues: RefreshPrompt (val), UserInputService (val), SyncUpdateConnection (val), CollectionService (val)
    -- upvalues: u71 (ref), RunServiceController (val), u69 (ref), u68 (ref), Router (val), CharacterResolver (val)
    -- upvalues: u0 (val), LayoutKeybind (val)
    u70 = a2
    local v1, v2 = GetPromptParts()
    if v1 then
        if not u67 then
            v1.Text = "Defuse Bomb"
            if v2 then
                v2.Visible = Tips.ApplyBindingToKeybind(v2, Tips.ResolveActionBinding("Use"))
            end
        else
            v1.Text = "Hold to Defuse"
            if v2 then
                v2.Visible = false
            end
        end
    end
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(a1) -- Line: 241 -- upvalues: RefreshPrompt (upval)
        if not a1 then
            return
        end
        task.defer(RefreshPrompt)
    end)
    ;(UserInputService:GetPropertyChangedSignal("PreferredInput")):Connect(RefreshPrompt)
    ;(LocalPlayer:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 251 -- upvalues: LocalPlayer (upval), u70 (upval)
        if LocalPlayer:GetAttribute("Dead") then
            u70.Visible = false
        end
    end)
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 258 -- upvalues: u70 (upval)
        u70.Visible = false
    end)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(SyncUpdateConnection)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(SyncUpdateConnection)
    LocalPlayer.CharacterAdded:Connect(SyncUpdateConnection)
    LocalPlayer.CharacterRemoving:Connect(SyncUpdateConnection)
    ;(CollectionService:GetInstanceAddedSignal("Bomb")):Connect(SyncUpdateConnection)
    ;(CollectionService:GetInstanceRemovedSignal("Bomb")):Connect(SyncUpdateConnection)
    v1 = false
    if workspace:GetAttribute("Gamemode") == "Bomb Defusal" then
        v1 = false
        if LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
            local v3 = CollectionService:GetTagged("Bomb")[1]
            if not v3 then
                v2 = nil
            else
                local v4
                if v3 then
                    v4 = true
                    if v3:GetAttribute("Defused") ~= true then
                        v4 = true
                        if v3:GetAttribute("Exploding") ~= true then
                            v4 = v3:GetAttribute("Exploded") == true
                        end
                    end
                else
                    v4 = false
                end
                v2 = if v4 then nil else v3
            end
            v1 = v2 ~= nil
        end
    end
    if not v1 then
        u70.Visible = false
        if u67 and u69 then
            v2 = CollectionService:GetTagged("Bomb")[1]
            if v2 then
                v1 = true
                if v2:GetAttribute("Defused") ~= true then
                    v1 = true
                    if v2:GetAttribute("Exploding") ~= true then
                        v1 = v2:GetAttribute("Exploded") == true
                    end
                end
            else
                v1 = false
            end
            u69 = false
            u68 = nil
            if not v1 then
                Router.broadcastRouter("Cancel Defuse Bomb")
            end
        end
        if u71 then
            u71:Disconnect()
            u71 = nil
        end
    elseif not u71 then
        u71 = RunServiceController.BindToHeartbeat("UI.HoverBomb.Update", function(a1) -- Line: 155
            -- upvalues: LocalPlayer (upval), CollectionService (upval), u70 (upval), u67 (upval), u69 (upval)
            -- upvalues: u68 (upval), Router (upval), u71 (upval), CharacterResolver (upval), u0 (upval)
            -- upvalues: LayoutKeybind (upval)
            local v1, v2
            local v3 = false
            if workspace:GetAttribute("Gamemode") == "Bomb Defusal" then
                v3 = false
                if LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
                    v2 = CollectionService:GetTagged("Bomb")[1]
                    if not v2 then
                        v1 = nil
                    else
                        local v4
                        if v2 then
                            v4 = true
                            if v2:GetAttribute("Defused") ~= true then
                                v4 = true
                                if v2:GetAttribute("Exploding") ~= true then
                                    v4 = v2:GetAttribute("Exploded") == true
                                end
                            end
                        else
                            v4 = false
                        end
                        v1 = if v4 then nil else v2
                    end
                    v3 = v1 ~= nil
                end
            end
            if not v3 then
                u70.Visible = false
                if u67 and u69 then
                    v1 = CollectionService:GetTagged("Bomb")[1]
                    if v1 then
                        v3 = true
                        if v1:GetAttribute("Defused") ~= true then
                            v3 = true
                            if v1:GetAttribute("Exploding") ~= true then
                                v3 = v1:GetAttribute("Exploded") == true
                            end
                        end
                    else
                        v3 = false
                    end
                    u69 = false
                    u68 = nil
                    if not v3 then
                        Router.broadcastRouter("Cancel Defuse Bomb")
                    end
                end
                if u71 then
                    u71:Disconnect()
                    u71 = nil
                end
                return
            end
            v1 = LocalPlayer
            if not CharacterResolver.isAliveCharacter(v1.Character) then
                u70.Visible = false
                if u67 and u69 then
                    u69 = false
                    u68 = nil
                end
                return
            end
            v3 = u0.GetHoverState()
            u70.Visible = v3
            if v3 then
                LayoutKeybind()
            end
            if u67 and u69 and not v3 and u67 then
                if not u69 then
                    return
                end
                v2 = CollectionService:GetTagged("Bomb")[1]
                if v2 then
                    v1 = true
                    if v2:GetAttribute("Defused") ~= true then
                        v1 = true
                        if v2:GetAttribute("Exploding") ~= true then
                            v1 = v2:GetAttribute("Exploded") == true
                        end
                    end
                else
                    v1 = false
                end
                u69 = false
                u68 = nil
                if not v1 then
                    Router.broadcastRouter("Cancel Defuse Bomb")
                    return
                end
            end
        end)
    end
    if u67 then
        UserInputService.TouchStarted:Connect(function(a1, a2) -- Line: 273
            -- upvalues: u0 (upval), LocalPlayer (upval), CharacterResolver (upval), u69 (upval), u68 (upval)
            -- upvalues: Router (upval)
            if a2 then
                return
            end
            if u0.GetHoverState() then
                local v1 = LocalPlayer
                if CharacterResolver.isAliveCharacter(v1.Character) and not u69 then
                    u68 = a1
                    u69 = true
                    Router.broadcastRouter("Start Defuse Bomb")
                end
            end
        end)
        UserInputService.TouchEnded:Connect(function(a1, a2) -- Line: 288 -- upvalues: u68 (upval), u69 (upval), Router (upval) -- types: a1: userdata, a2: boolean
            if a1 == u68 then
                u68 = nil
                if u69 then
                    u69 = false
                    Router.broadcastRouter("Cancel Defuse Bomb")
                end
            end
        end)
    end
end

return u0