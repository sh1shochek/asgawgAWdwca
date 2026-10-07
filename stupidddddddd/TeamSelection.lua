-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection
-- Decompile time: 20.03 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local LocalPlayer = Players.LocalPlayer
local u89 = ColorSequence.new(Color3.fromRGB(32, 32, 32))
local u94 = Color3.fromRGB(255, 255, 255)
local u99 = Color3.fromRGB(138, 138, 138)
local u114 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.14375),
    NumberSequenceKeypoint.new(0.318, 1),
    (NumberSequenceKeypoint.new(1, 1)),
})
local u129 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.14375),
    NumberSequenceKeypoint.new(0.183193, 1),
    (NumberSequenceKeypoint.new(1, 1)),
})
local u130 = false
local u131 = 0
local u132 = nil
local u133 = {}
local u134 = {}
local u135 = nil
local u136 = nil

local function retrieveTeamCount(a1, a2, a3) -- Line: 84
    -- upvalues: Participants (val)
    local v1 = 0
    local v2, v3, v4 = a3, a2, a1
    for i, v in ipairs(Participants.GetAll()) do
        if not v2 then
            if v ~= v3 and v:GetAttribute("Team") == v4 then
                v1 = v1 + 1
            end
        elseif not Participants.IsBot(v) and v ~= v3 and v:GetAttribute("Team") == v4 then
            v1 = v1 + 1
        end
    end
    return v1
end

local function isDeathmatchMode() -- Line: 98
    local v1 = true
    if workspace:GetAttribute("ServerGamemode") ~= "Deathmatch" then
        v1 = workspace:GetAttribute("Gamemode") == "Deathmatch"
    end
    return v1
end

local function areTeamLimitsDisabled() -- Line: 103
    local v1 = true
    if workspace:GetAttribute("VIPDisableTeamLimitEnabled") ~= true then
        v1 = true
        if workspace:GetAttribute("ServerGamemode") ~= "Deathmatch" then
            v1 = workspace:GetAttribute("Gamemode") == "Deathmatch"
        end
    end
    return v1
end

local function chooseBalancedTeam(a1) -- Line: 107 -- upvalues: retrieveTeamCount (val) -- types: a1: userdata
    local v1 = retrieveTeamCount("Counter-Terrorists", a1, true)
    local v2 = retrieveTeamCount("Terrorists", a1, true)
    if v1 == v2 then
        if a1:GetAttribute("Team") == "Terrorists" then
            return "Counter-Terrorists"
        end
        return "Terrorists"
    end
    if v1 < v2 then
        return "Counter-Terrorists"
    end
    return "Terrorists"
end

local function isTeamAvailable(a1, a2) -- Line: 120
    -- upvalues: IsTutorialMode (val), retrieveTeamCount (val)
    local v1
    if IsTutorialMode() then
        v1 = true
        if a2 ~= "Terrorists" then
            v1 = a2 == "Spectators"
        end
        return v1
    end
    v1 = true
    if workspace:GetAttribute("VIPDisableTeamLimitEnabled") ~= true then
        v1 = true
        if workspace:GetAttribute("ServerGamemode") ~= "Deathmatch" then
            v1 = workspace:GetAttribute("Gamemode") == "Deathmatch"
        end
    end
    if v1 then
        v1 = true
        if a2 ~= "Counter-Terrorists" then
            v1 = true
            if a2 ~= "Terrorists" then
                v1 = a2 == "Spectators"
            end
        end
        return v1
    end
    v1 = retrieveTeamCount("Counter-Terrorists", a1, true)
    local v2 = retrieveTeamCount("Terrorists", a1, true)
    if a2 == "Terrorists" and v2 < v1 then
        return true
    end
    if a2 == "Counter-Terrorists" and v1 < v2 then
        return true
    end
    local v3 = true
    if a2 ~= "Spectators" then
        v3 = v1 == v2
    end
    return v3
end

local function setPlayerTemplateUnhovered(a1, a2) -- Line: 136 -- upvalues: u99 (val) -- types: a2: string
    if a1 and a1:IsA("Frame") then
        local v1 = not (a2 ~= "Counter-Terrorists") and Color3.fromRGB(109, 121, 140) or Color3.fromRGB(131, 111, 66)
        a1.BackgroundColor3 = v1
        local UIStroke = a1.Player.UIStroke
        local v2 = not (a2 ~= "Counter-Terrorists") and Color3.fromRGB(50, 56, 65) or Color3.fromRGB(94, 85, 54)
        UIStroke.Color = v2
        a1.Player.Avatar.ImageColor3 = u99
        return
    end
end

local function updateTeamAvailabilityStyles() -- Line: 147
    -- upvalues: Participants (val), retrieveTeamCount (val), u135 (ref), u133 (val), u134 (val), u89 (val)
    -- upvalues: setPlayerTemplateUnhovered (val)
    local v1, v2, v3, v4
    local v5 = true
    if workspace:GetAttribute("VIPDisableTeamLimitEnabled") ~= true then
        v5 = true
        if workspace:GetAttribute("ServerGamemode") ~= "Deathmatch" then
            v5 = workspace:GetAttribute("Gamemode") == "Deathmatch"
        end
    end
    local v6 = 0
    for i, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == "Counter-Terrorists" then
            v6 = v6 + 1
        end
    end
    local v7 = 0
    for i2, i3 in ipairs(Participants.GetAll()) do
        if i3 ~= nil and i3:GetAttribute("Team") == "Terrorists" then
            v7 = v7 + 1
        end
    end
    local v8 = retrieveTeamCount("Counter-Terrorists", nil, true)
    local v9 = retrieveTeamCount("Terrorists", nil, true)
    for i4, j in ipairs({"Counter-Terrorists", "Terrorists"}) do
        v1 = u135:FindFirstChild(j)
        if v1 then
            if not u133[j] then
                v2 = u133
                v3 = {
                    TeamTransparency = v1.Team.TextTransparency,
                    PlayersTransparency = v1.Players.TextTransparency,
                    UIGradient = v1.UIGradient.Color,
                    IconOutline = v1.Icon.Outline.ImageTransparency,
                    IconTeam = v1.Icon.Team.ImageTransparency,
                    IconTeamIcon = v1.Icon.Team.Icon.ImageTransparency,
                }
                v2[j] = v3
            end
            v2 = not v5
            if v2 then
                if j ~= "Counter-Terrorists" then
                    v2 = false
                    if j == "Terrorists" then
                        v2 = v8 < v9
                    end
                else
                    v2 = true
                    if not (v9 < v8) then
                        v2 = false
                        if j == "Terrorists" then
                            v2 = v8 < v9
                        end
                    end
                end
            end
            u134[j] = v2
            v3 = not (j ~= "Counter-Terrorists") and v6 or v7
            v4 = u133[j]
            v1.Players.Text = ("%* Player%*"):format(v3, if v3 ~= 1 then "s" else "")
            v1.Team.TextTransparency = if not v2 then v4.TeamTransparency else 0.5
            v1.Players.TextTransparency = if not v2 then v4.PlayersTransparency else 0.5
            v1.UIGradient.Color = v2 and u89 or v4.UIGradient
            v1.Icon.Outline.ImageTransparency = if not v2 then v4.IconOutline else 0.4
            v1.Icon.Team.ImageTransparency = if not v2 then v4.IconTeam else 0.4
            v1.Icon.Team.Icon.ImageTransparency = if not v2 then v4.IconTeamIcon else 0.4
            for i5, k in ipairs(v1.Container:GetChildren()) do
                if v2 then
                    setPlayerTemplateUnhovered(k, j)
                end
            end
        end
    end
end

local function createButtonAnimation(a1) -- Line: 187 -- upvalues: TweenService (val) -- types: a1: userdata
    a1.MouseEnter:Connect(function() -- Line: 188 -- upvalues: TweenService (upval), a1 (val)
        TweenService:Create(a1, TweenInfo.new(0.1), {BackgroundTransparency = 0.85}):Play()
    end)
    a1.MouseLeave:Connect(function() -- Line: 191 -- upvalues: TweenService (upval), a1 (val)
        TweenService:Create(a1, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
    end)
end

local function isCharacterAlive() -- Line: 196 -- upvalues: CharacterResolver (val), LocalPlayer (val)
    return CharacterResolver.isAliveCharacter(LocalPlayer.Character)
end

local function getMenuSceneController() -- Line: 201 -- upvalues: ReplicatedStorage (val)
    return require(ReplicatedStorage.Controllers.MenuSceneController)
end

local function createTeamListeners(a1, a2) -- Line: 205
    -- upvalues: u0 (val), createButtonAnimation (val)
    a1.MouseButton1Click:Connect(function() -- Line: 206 -- upvalues: u0 (upval), a2 (val)
        u0.chooseTeam(a2)
    end)
    if a2 == "Spectators" then
        createButtonAnimation(a1)
        return
    end
    u0.createTeamButtonAnimation(a1, a2)
end

local function destroyPlayerTemplate(a1) -- Line: 216 -- upvalues: u135 (ref)
    local v1 = u135:FindFirstChild(tostring(a1), true)
    if v1 then
        v1:Destroy()
    end
end

function u0.isVisible() -- Line: 226 -- upvalues: u135 (ref), u136 (ref)
    if u135 and u135.Visible and u136 then
        local Gameplay = u136:FindFirstChild("Gameplay")
        local Bottom = Gameplay and Gameplay:FindFirstChild("Bottom")
        local v1 = false
        if Bottom ~= nil then
            v1 = Bottom:IsA("GuiObject") and not Bottom.Visible
        end
        return v1
    end
    return false
end

function u0.shouldUseMapCamera() -- Line: 237 -- upvalues: u0 (val), CharacterResolver (val), LocalPlayer (val)
    return u0.isVisible() and not CharacterResolver.isAliveCharacter(LocalPlayer.Character)
end

function u0.ToggleTeamSelection() -- Line: 242 -- upvalues: EndScreenController (val), u135 (ref), u0 (val)
    if EndScreenController.IsActive() then
        return
    end
    if u135.Visible then
        u0.closeFrame()
        return
    end
    u0.openFrame()
end

function u0.openFrame() -- Line: 254
    -- upvalues: IsTutorialMode (val), u136 (ref), LocalPlayer (val), u0 (val), EndScreenController (val)
    -- upvalues: MenuState (val), u135 (ref), ReplicatedStorage (val), u132 (ref), CameraController (val), u130 (ref)
    -- upvalues: GetUserPlatform (val), updateTeamAvailabilityStyles (val)
    if IsTutorialMode() then
        if u136.Menu.Visible then
            return
        end
        local Attribute = LocalPlayer:GetAttribute("Team")
        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            u0.chooseTeam("Terrorists")
        end
        return
    end
    if EndScreenController.IsActive() then
        return
    end
    if not MenuState.IsCaseSceneActive() and not MenuState.IsInspectActive() then
        local Character, v1
        if u135.Visible then
            return
        end
        if u136.Menu.Visible then
            local v2 = MenuState.GetCurrentScreen()
            if MenuState.IsPreservableScreen(v2) then
                local v3 = u136.Menu:FindFirstChild(v2)
                if v3 and v3.Visible then
                    return
                end
            end
        end
        local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
        if MenuSceneController.IsActive() then
            MenuSceneController.HideMenuScene(true, false, true)
        end
        u132 = CameraController.getTargetFOV()
        if u136.Menu.Visible then
            CameraController.setForceLockOverride("Menu", false)
            MenuState.SetBlurEnabled(false)
        end
        local BuyMenu = u136.Gameplay.Middle:FindFirstChild("BuyMenu")
        u130 = BuyMenu and BuyMenu.Visible or false
        if u130 then
            require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu).closeFrame()
        end
        CameraController.setForceLockOverride("TeamSelection", true)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            CameraController.setPerspective(true, true)
        end
        u136.Gameplay.Bottom.Visible = false
        u136.Gameplay.Top.Visible = true
        u136.Gameplay.Visible = true
        MenuState.HideMenu()
        local v4 = table.find(GetUserPlatform(), "Mobile")
        for i, v in ipairs(u136.Gameplay.Middle:GetChildren()) do
            if v.Name == "Chat" then
                v.Visible = not v4
            elseif v.Name ~= "MobileButtons" then
                v1 = true
                if v.Name ~= "Notification" then
                    v1 = v.Name == "TeamSelection"
                end
                v.Visible = v1
            else
                Character = LocalPlayer.Character
                if not Character or not Character:IsDescendantOf(workspace) then
                    v.Visible = false
                else
                    v.Visible = v4
                end
            end
        end
        updateTeamAvailabilityStyles()
        MenuSceneController.ShowTeamSelectScene()
        return
    end
end

function u0.closeFrame() -- Line: 345
    -- upvalues: ReplicatedStorage (val), CameraController (val), LocalPlayer (val), u132 (ref), u135 (ref), u136 (ref)
    -- upvalues: MenuState (val), u130 (ref), GetUserPlatform (val), IsTutorialMode (val)
    local Name, v1, v2
    require(ReplicatedStorage.Controllers.MenuSceneController).HideTeamSelectScene()
    CameraController.setForceLockOverride("TeamSelection", false)
    if LocalPlayer.Character then
        CameraController.setForceLockOverride("Menu", false)
    end
    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, false)
    end
    local v3 = u132
    u132 = nil
    if v3 and not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.updateCameraFOV(v3)
    end
    local Visible = u135.Visible
    u135.Visible = false
    if Visible or not u136.Menu.Visible then
        MenuState.SetScreen(nil)
    end
    if u136.Menu.Visible then
        u136.Gameplay.Bottom.Visible = false
        u136.Gameplay.Visible = false
        u130 = false
        local TutorialDialogue = u136.Gameplay.Middle:FindFirstChild("TutorialDialogue")
        if TutorialDialogue and TutorialDialogue:IsA("GuiObject") then
            TutorialDialogue.Visible = false
        end
        return
    end
    u136.Gameplay.Middle.Crosshair.Visible = true
    u136.Gameplay.Top.Visible = true
    u136.Gameplay.Bottom.Visible = true
    local v4 = table.find(GetUserPlatform(), "Mobile")
    local Character = LocalPlayer.Character
    local v5 = LocalPlayer:GetAttribute("IsSpectating") == true
    for i, v in ipairs(u136.Gameplay.Middle:GetChildren()) do
        v1 = Character and Character:IsDescendantOf(workspace)
        Name = v.Name
        if Name == "Chat" then
            v.Visible = not v4
        elseif Name == "MobileButtons" then
            v.Visible = if not v4 then false else v1 or v5 or false
        elseif Name == "Votekick" then
            v2 = v:GetAttribute("IsVoteKickActive") == true
            v.Visible = v2
        elseif Name == "Notification" then
            v.Visible = true
        elseif Name == "SessionStats" then
            v.Visible = not v4
        elseif Name == "Crosshair" then
            v.Visible = v1
        elseif Name == "Radar" then
            v2 = v1 and not IsTutorialMode()
            v.Visible = v2
        elseif Name ~= "TutorialDialogue" and Name ~= "TutorialObjective" then
            v.Visible = false
        end
    end
    if u130 then
        local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu)
        u130 = false
        BuyMenu.openFrame()
    end
end

function u0.chooseTeam(a1) -- Line: 430
    -- upvalues: MenuState (val), LocalPlayer (val), Remotes (val), u0 (val), isTeamAvailable (val), u131 (ref)
    MenuState.SetWantsMainMenu(false)
    if LocalPlayer:GetAttribute("Team") == a1 then
        if a1 == "Spectators" and not LocalPlayer:GetAttribute("IsSpectating") then
            Remotes.Spectate.StartSpectating.Send()
        end
        u0.closeFrame()
        return
    end
    if isTeamAvailable(LocalPlayer, a1) and 1 <= tick() - u131 then
        if a1 == "Spectators" then
            LocalPlayer:SetAttribute("PendingSpectateRequestAt", (os.clock()))
        end
        Remotes.TeamSelection.SelectTeam.Send(a1)
        u131 = tick()
    end
end

function u0.createTeamButtonAnimation(a1, a2) -- Line: 452
    -- upvalues: u135 (ref), u134 (val), ReplicatedStorage (val), u94 (val), u114 (val), u129 (val)
    -- upvalues: setPlayerTemplateUnhovered (val)
    local u6 = u135:FindFirstChild(a2)
    if u6 then
        a1.MouseEnter:Connect(function() -- Line: 455
            -- upvalues: u134 (upval), a2 (val), ReplicatedStorage (upval), u6 (val), u94 (upval), u114 (upval)
            local UIStroke, v1, v2, v3
            if u134[a2] then
                return
            end
            require(ReplicatedStorage.Controllers.MenuSceneController).SetTeamSelectHighlight(a2, true)
            local Outline = u6.Icon.Outline
            if a2 ~= "Counter-Terrorists" then
                v1 = false
                if a2 == "Terrorists" then
                    v1 = Color3.fromRGB(219, 199, 126)
                end
            else
                v1 = Color3.fromRGB(165, 183, 212)
                if not v1 then
                    v1 = false
                    if a2 == "Terrorists" then
                        v1 = Color3.fromRGB(219, 199, 126)
                    end
                end
            end
            Outline.ImageColor3 = v1
            u6.Icon.Team.Icon.ImageColor3 = u94
            local Team = u6.Icon.Team
            if a2 ~= "Counter-Terrorists" then
                v1 = false
                if a2 == "Terrorists" then
                    v1 = Color3.fromRGB(89, 79, 50)
                end
            else
                v1 = Color3.fromRGB(36, 41, 47)
                if not v1 then
                    v1 = false
                    if a2 == "Terrorists" then
                        v1 = Color3.fromRGB(89, 79, 50)
                    end
                end
            end
            Team.ImageColor3 = v1
            u6.UIGradient.Transparency = u114
            for i, v in ipairs(u6.Container:GetChildren()) do
                if v:IsA("Frame") then
                    if a2 ~= "Counter-Terrorists" then
                        v2 = false
                        if a2 == "Terrorists" then
                            v2 = Color3.fromRGB(219, 188, 110)
                        end
                    else
                        v2 = Color3.fromRGB(126, 140, 187)
                        if not v2 then
                            v2 = false
                            if a2 == "Terrorists" then
                                v2 = Color3.fromRGB(219, 188, 110)
                            end
                        end
                    end
                    v.BackgroundColor3 = v2
                    UIStroke = v.Player.UIStroke
                    if a2 ~= "Counter-Terrorists" then
                        v3 = false
                        if a2 == "Terrorists" then
                            v3 = Color3.fromRGB(219, 199, 126)
                        end
                    else
                        v3 = Color3.fromRGB(165, 183, 212)
                        if not v3 then
                            v3 = false
                            if a2 == "Terrorists" then
                                v3 = Color3.fromRGB(219, 199, 126)
                            end
                        end
                    end
                    UIStroke.Color = v3
                    v.Player.Avatar.ImageColor3 = u94
                end
            end
        end)
        a1.MouseLeave:Connect(function() -- Line: 478
            -- upvalues: u134 (upval), a2 (val), ReplicatedStorage (upval), u6 (val), u129 (upval)
            -- upvalues: setPlayerTemplateUnhovered (upval)
            local v1
            if u134[a2] then
                return
            end
            require(ReplicatedStorage.Controllers.MenuSceneController).SetTeamSelectHighlight(a2, false)
            local Outline = u6.Icon.Outline
            if a2 ~= "Counter-Terrorists" then
                v1 = false
                if a2 == "Terrorists" then
                    v1 = Color3.fromRGB(127, 115, 73)
                end
            else
                v1 = Color3.fromRGB(107, 119, 138)
                if not v1 then
                    v1 = false
                    if a2 == "Terrorists" then
                        v1 = Color3.fromRGB(127, 115, 73)
                    end
                end
            end
            Outline.ImageColor3 = v1
            local Icon = u6.Icon.Team.Icon
            if a2 ~= "Counter-Terrorists" then
                v1 = false
                if a2 == "Terrorists" then
                    v1 = Color3.fromRGB(182, 182, 182)
                end
            else
                v1 = Color3.fromRGB(131, 131, 131)
                if not v1 then
                    v1 = false
                    if a2 == "Terrorists" then
                        v1 = Color3.fromRGB(182, 182, 182)
                    end
                end
            end
            Icon.ImageColor3 = v1
            local Team = u6.Icon.Team
            if a2 ~= "Counter-Terrorists" then
                v1 = false
                if a2 == "Terrorists" then
                    v1 = Color3.fromRGB(58, 51, 33)
                end
            else
                v1 = Color3.fromRGB(20, 24, 27)
                if not v1 then
                    v1 = false
                    if a2 == "Terrorists" then
                        v1 = Color3.fromRGB(58, 51, 33)
                    end
                end
            end
            Team.ImageColor3 = v1
            u6.UIGradient.Transparency = u129
            for i, v in ipairs(u6.Container:GetChildren()) do
                setPlayerTemplateUnhovered(v, a2)
            end
        end)
    end
end

function u0.updatePlayerList(a1, a2) -- Line: 497
    -- upvalues: Profiler (val), Participants (val), u135 (ref), ReplicatedStorage (val), Players (val)
    -- upvalues: updateTeamAvailabilityStyles (val)
    Profiler.mark("UI.TeamSelection.UpdatePlayerList")
    local Attribute = a1:GetAttribute("Team")
    local v1 = Participants.Key(a1)
    local v2 = u135:FindFirstChild(tostring(v1), true)
    if v2 then
        v2:Destroy()
    end
    if Attribute == "Counter-Terrorists" or Attribute == "Terrorists" then
        local u34 = ReplicatedStorage.Assets.UI.TeamSelection:FindFirstChild(Attribute)
        if u34 and not a2 then
            local result
            local u41 = u135:WaitForChild(Attribute)
            _, result = pcall(function() -- Line: 507 -- upvalues: Players (upval), Participants (upval), a1 (val)
                return Players:GetUserThumbnailAsync(Participants.AvatarUserId(a1), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
            Profiler.scope("UI.TeamSelection.UpdatePlayerList.CloneRow", function() -- Line: 514 -- upvalues: u34 (val), u41 (val), Participants (upval), a1 (val), result (val)
                local v1 = u34:Clone()
                v1.Parent = u41.Container
                v1.Team.Text = Participants.DisplayName(a1)
                v1.Player.Avatar.Image = result
                v1.Name = tostring((Participants.Key(a1)))
                v1.Visible = true
            end)
        end
    end
    local Players_2 = u135["Counter-Terrorists"].Players
    local v3 = 0
    for i, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == "Counter-Terrorists" then
            v3 = v3 + 1
        end
    end
    Players_2.Text = ("%* Player(s)"):format(v3)
    local Players_3 = u135.Terrorists.Players
    v3 = 0
    for i2, i3 in ipairs(Participants.GetAll()) do
        if i3 ~= nil and i3:GetAttribute("Team") == "Terrorists" then
            v3 = v3 + 1
        end
    end
    Players_3.Text = ("%* Player(s)"):format(v3)
    updateTeamAvailabilityStyles()
end

function u0.Initialize(a1, a2) -- Line: 533
    -- upvalues: u135 (ref), u136 (ref), Observers (val), u0 (val), LocalPlayer (val), Participants (val)
    -- upvalues: GameState (val), GetTimerFormat (val), updateTeamAvailabilityStyles (val)
    u135 = a2
    u136 = a1
    Observers.observePlayer(function(a1) -- Line: 536
        -- upvalues: u0 (upval), Observers (upval), LocalPlayer (upval), u135 (upval)
        u0.updatePlayerList(a1)
        local u10 = Observers.observeAttribute(a1, "Team", function() -- Line: 538 -- upvalues: u0 (upval), a1 (val), LocalPlayer (upval), u135 (upval)
            u0.updatePlayerList(a1)
            if LocalPlayer == a1 and u135.Visible then
                u0.closeFrame()
            end
            return function() -- Line: 545 -- upvalues: a1 (upval), u135 (upval)
                local v1 = u135:FindFirstChild(tostring(a1.UserId), true)
                if v1 then
                    v1:Destroy()
                end
            end
        end)
        return function() -- Line: 551 -- upvalues: u0 (upval), a1 (val), u10 (val)
            u0.updatePlayerList(a1, true)
            u10()
        end
    end)
    local u6 = {}
    Participants.Observe(function(a1) -- Line: 559
        -- upvalues: Participants (upval), u6 (val), Observers (upval), u0 (upval), u135 (upval)
        if not Participants.IsBot(a1) then
            return
        end
        u6[a1] = (Observers.observeAttribute(a1, "Team", function() -- Line: 563 -- upvalues: u0 (upval), a1 (val), Participants (upval), u135 (upval)
            u0.updatePlayerList(a1)
            return function() -- Line: 565 -- upvalues: Participants (upval), a1 (upval), u135 (upval)
                local v1 = Participants.Key(a1)
                local v2 = u135:FindFirstChild(tostring(v1), true)
                if v2 then
                    v2:Destroy()
                end
            end
        end))
    end, function(a1) -- Line: 569 -- upvalues: Participants (upval), u0 (upval), u6 (val) -- types: a1: userdata
        if not Participants.IsBot(a1) then
            return
        end
        u0.updatePlayerList(a1, true)
        local v1 = u6[a1]
        u6[a1] = nil
        if v1 then
            v1()
        end
    end)
    local v1 = LocalPlayer
    Observers.observeAttribute(v1, "Team", function() -- Line: 582 -- upvalues: u135 (upval), GameState (upval), u0 (upval)
        if u135.Visible and GameState.GetState() == "Round In Progress" then
            u0.closeFrame()
        end
    end)
    Observers.observeAttribute(workspace, "Timer", function(a1) -- Line: 589 -- upvalues: u135 (upval), GetTimerFormat (upval)
        u135.ProgressBar.Timer.Text = GetTimerFormat(a1)
    end)
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 594 -- upvalues: u135 (upval), u0 (upval)
        if u135.Visible then
            u0.closeFrame()
        end
    end)
    for i, v in ipairs({"VIPDisableTeamLimitEnabled", "ServerGamemode", "Gamemode"}) do
        Observers.observeAttribute(workspace, v, updateTeamAvailabilityStyles)
    end
end

function u0.Start() -- Line: 606
    -- upvalues: u135 (ref), u0 (val), createButtonAnimation (val), LocalPlayer (val), retrieveTeamCount (val)
    -- upvalues: CharacterResolver (val), Remotes (val), SpectateController (val), MenuState (val)
    -- upvalues: ReplicatedStorage (val), CameraController (val), u136 (ref)
    local Button = u135["Counter-Terrorists"].Button
    local MouseButton1Click = Button.MouseButton1Click
    local u4 = "Counter-Terrorists"
    MouseButton1Click:Connect(function() -- Line: 206 -- upvalues: u0 (upval), u4 (val)
        u0.chooseTeam(u4)
    end)
    u0.createTeamButtonAnimation(Button, "Counter-Terrorists")
    local Spectate = u135.Bottom.Buttons.Spectate
    local MouseButton1Click_2 = Spectate.MouseButton1Click
    local u19 = "Spectators"
    MouseButton1Click_2:Connect(function() -- Line: 206 -- upvalues: u0 (upval), u19 (val)
        u0.chooseTeam(u19)
    end)
    createButtonAnimation(Spectate)
    local Button_2 = u135.Terrorists.Button
    local MouseButton1Click_3 = Button_2.MouseButton1Click
    local u31 = "Terrorists"
    MouseButton1Click_3:Connect(function() -- Line: 206 -- upvalues: u0 (upval), u31 (val)
        u0.chooseTeam(u31)
    end)
    u0.createTeamButtonAnimation(Button_2, "Terrorists")
    createButtonAnimation(u135.Bottom.Buttons.AutoSelect)
    u135.Bottom.Buttons.AutoSelect.MouseButton1Click:Connect(function() -- Line: 612 -- upvalues: u0 (upval), LocalPlayer (upval), retrieveTeamCount (upval)
        local chooseTeam = u0.chooseTeam
        local v1 = LocalPlayer
        local v2 = retrieveTeamCount("Counter-Terrorists", v1, true)
        local v3 = retrieveTeamCount("Terrorists", v1, true)
        chooseTeam(if v2 ~= v3 then if not (v2 < v3) then "Terrorists" else "Counter-Terrorists" else if v1:GetAttribute("Team") ~= "Terrorists" then "Terrorists" else "Counter-Terrorists")
    end)
    createButtonAnimation(u135.Bottom.Buttons.BackHome)
    u135.Bottom.Buttons.BackHome.MouseButton1Click:Connect(function() -- Line: 617
        -- upvalues: LocalPlayer (upval), CharacterResolver (upval), u0 (upval), Remotes (upval)
        -- upvalues: SpectateController (upval), MenuState (upval), ReplicatedStorage (upval), CameraController (upval)
        -- upvalues: u136 (upval)
        if not (LocalPlayer:GetAttribute("IsSpectating") == true)
            and CharacterResolver.isAliveCharacter(LocalPlayer.Character) then
            u0.closeFrame()
            return
        end
        local Attribute = LocalPlayer:GetAttribute("Team")
        if Attribute and Attribute ~= "Spectators" then
            Remotes.TeamSelection.SelectTeam.Send("Spectators")
        end
        SpectateController.Stop(true, true)
        MenuState.SetWantsMainMenu(true)
        u0.closeFrame()
        local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top)
        local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
        CameraController.setForceLockOverride("Menu", true)
        CameraController.setPerspective(true, true)
        u136.Gameplay.Visible = false
        u136.Gameplay.Bottom.Visible = false
        u136.Menu.Visible = true
        Top.ResetToMainMenu()
        MenuSceneController.ShowMenuScene()
    end)
end

return u0