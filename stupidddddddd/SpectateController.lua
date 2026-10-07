-- ReplicatedStorage.Controllers.SpectateController
-- Script path: ReplicatedStorage.Controllers.SpectateController
-- Decompile time: 25.31 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration)
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local RemoteCharacters = require(ReplicatedStorage.Controllers.CharacterController.RemoteCharacters)
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam)
local CharacterActions = require(ReplicatedStorage.Database.Components.CharacterActions)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local Spectate = require(ReplicatedStorage.Classes.Spectate)
local Freecam = require(ReplicatedStorage.Classes.Freecam)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Promise = require(ReplicatedStorage.Shared.Promise)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local CurrentCamera = workspace.CurrentCamera
local u126 = Signal.new()
u0.ListenToSpectate = u126
local u128 = Signal.new()
u0.ListenToFreecam = u128
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local u134 = {"TeamSelection", "BuyMenu", "Leaderboard", "Votekick"}
local u139 = "First-Person"
local u140 = {}
local u141 = 0
local u142 = false
local u143 = 1
local u144 = 1
local u145 = 0
local u146 = 0
local u147 = nil
local u148 = 0
local u149 = nil
local u150 = nil
local u151 = {"First-Person", "Third-Person", "Free-Cam"}
local u155 = nil
local u156 = nil

local function GetCurrentGamemode() -- Line: 99
    local Attribute = workspace:GetAttribute("ServerGamemode")
    if Attribute ~= "Competitive" and Attribute ~= "Deathmatch" then
        return "Casual"
    end
    return Attribute
end

local function IsOnPlayingTeam(a1) -- Line: 109 -- upvalues: IsPlayingTeam (val) -- types: a1: userdata
    return IsPlayingTeam(a1:GetAttribute("Team"))
end

local function HasAliveCharacterReplicated(a1) -- Line: 115
    -- upvalues: Participants (val), CharacterResolver (val)
    if Participants.IsBot(a1) then
        return Participants.IsAlive(a1)
    end
    return CharacterResolver.isAlivePlayer(a1)
end

local function IsCharacterAlive(a1) -- Line: 126
    -- upvalues: IsPlayingTeam (val), LocalPlayer (val), u142 (ref), HasAliveCharacterReplicated (val)
    if not IsPlayingTeam(a1:GetAttribute("Team")) then
        return false
    end
    if a1 == LocalPlayer and u142 then
        return false
    end
    return HasAliveCharacterReplicated(a1)
end

local function IsCompetitiveRestrictedLocalSpectate() -- Line: 139
    -- upvalues: LocalPlayer (val), IsPlayingTeam (val), u142 (ref), Participants (val), CharacterResolver (val)
    local v1 = false
    local Attribute = workspace:GetAttribute("ServerGamemode")
    if (if Attribute == "Competitive" then Attribute else if Attribute ~= "Deathmatch" then "Casual" else Attribute) == "Competitive" then
        v1 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
        if v1 then
            local v2 = LocalPlayer
            v1 = not (if IsPlayingTeam(v2:GetAttribute("Team")) then if v2 ~= LocalPlayer then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else if not u142 then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else false else false)
        end
    end
    return v1
end

local function DestroyFreecam() -- Line: 145 -- upvalues: u156 (ref)
    if u156 then
        u156:Destroy()
        u156 = nil
    end
end

local function ResetSpectatePerspective() -- Line: 154 -- upvalues: u139 (ref), u143 (ref)
    u139 = "First-Person"
    u143 = 1
end

local function EnforceCompetitiveSpectatePerspective() -- Line: 161
    -- upvalues: LocalPlayer (val), IsPlayingTeam (val), u142 (ref), Participants (val), CharacterResolver (val)
    -- upvalues: u139 (ref), u143 (ref), u155 (ref), u156 (ref)
    local v1 = false
    local Attribute = workspace:GetAttribute("ServerGamemode")
    if (if Attribute == "Competitive" then Attribute else if Attribute ~= "Deathmatch" then "Casual" else Attribute) == "Competitive" then
        v1 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
        if v1 then
            local v2 = LocalPlayer
            v1 = not (if IsPlayingTeam(v2:GetAttribute("Team")) then if v2 ~= LocalPlayer then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else if not u142 then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else false else false)
        end
    end
    if not v1 then
        return
    end
    u139 = "First-Person"
    u143 = 1
    if u155 and u155.PerspectiveState ~= "First-Person" then
        u155:Switch("First-Person")
    end
    if u156 then
        u156:Destroy()
        u156 = nil
    end
end

local function IsValidSpectateTargetForLocalPlayer(a1) -- Line: 175
    -- upvalues: LocalPlayer (val), IsPlayingTeam (val), u142 (ref), Participants (val), CharacterResolver (val)
    if a1 ~= LocalPlayer then
        if if IsPlayingTeam(a1:GetAttribute("Team")) then if a1 ~= LocalPlayer then if not Participants.IsBot(a1) then CharacterResolver.isAlivePlayer(a1) else Participants.IsAlive(a1) else if not u142 then if not Participants.IsBot(a1) then CharacterResolver.isAlivePlayer(a1) else Participants.IsAlive(a1) else false else false then
            local v1 = false
            local Attribute = workspace:GetAttribute("ServerGamemode")
            if (if Attribute == "Competitive" then Attribute else if Attribute ~= "Deathmatch" then "Casual" else Attribute) == "Competitive" then
                v1 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
                if v1 then
                    local v2 = LocalPlayer
                    v1 = not (if IsPlayingTeam(v2:GetAttribute("Team")) then if v2 ~= LocalPlayer then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else if not u142 then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else false else false)
                end
            end
            return not v1 or (LocalPlayer:GetAttribute("Team")) == a1:GetAttribute("Team")
        end
    end
    return false
end

local function GetSpectateBombModel() -- Line: 185 -- upvalues: CollectionService (val)
    local v1
    for i, v in ipairs(CollectionService:GetTagged("Bomb")) do
        if v:IsA("Model") and v.PrimaryPart then
            v1 = workspace
            if v:IsDescendantOf(v1) then
                return v
            end
        end
    end
    return nil
end

local function StopBombSpectate() -- Line: 197 -- upvalues: u150 (ref), LocalPlayer (val), u149 (ref)
    if u150 and LocalPlayer.ReplicationFocus == u150 then
        LocalPlayer.ReplicationFocus = nil
    end
    u149 = nil
    u150 = nil
end

local function RenderBombSpectate() -- Line: 208
    -- upvalues: u149 (ref), u150 (ref), LocalPlayer (val), CurrentCamera (val)
    local v1 = u149
    if v1 and v1.Parent then
        local PrimaryPart = v1.PrimaryPart
        if not PrimaryPart then
            return false
        end
        if u150 ~= PrimaryPart then
            u150 = PrimaryPart
            LocalPlayer.ReplicationFocus = PrimaryPart
        end
        CurrentCamera.CameraType = Enum.CameraType.Follow
        CurrentCamera.CameraSubject = PrimaryPart
        return true
    end
    return false
end

local function GetKillerPlayer() -- Line: 233
    -- upvalues: LocalPlayer (val), Participants (val), IsPlayingTeam (val), u142 (ref), CharacterResolver (val)
    local Attribute = LocalPlayer:GetAttribute("LastKiller")
    local Attribute_2 = LocalPlayer:GetAttribute("LastKillerKey")
    if not Attribute and not Attribute_2 then
        return nil
    end
    LocalPlayer:SetAttribute("LastKiller", nil)
    LocalPlayer:SetAttribute("LastKillerKey", nil)
    local v1 = Participants.FromKey(Attribute_2) or Attribute and Participants.FromName(Attribute)
    if v1 then
        local v2
        if v1 == LocalPlayer then
            v2 = false
        else
            local v3 = if IsPlayingTeam(v1:GetAttribute("Team")) then if v1 ~= LocalPlayer then if not Participants.IsBot(v1) then CharacterResolver.isAlivePlayer(v1) else Participants.IsAlive(v1) else if not u142 then if not Participants.IsBot(v1) then CharacterResolver.isAlivePlayer(v1) else Participants.IsAlive(v1) else false else false
            if v3 then
                v3 = false
                local Attribute_3 = workspace:GetAttribute("ServerGamemode")
                if (if Attribute_3 == "Competitive" then Attribute_3 else if Attribute_3 ~= "Deathmatch" then "Casual" else Attribute_3) == "Competitive" then
                    v3 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
                    if v3 then
                        local v4 = LocalPlayer
                        v3 = not (if IsPlayingTeam(v4:GetAttribute("Team")) then if v4 ~= LocalPlayer then if not Participants.IsBot(v4) then CharacterResolver.isAlivePlayer(v4) else Participants.IsAlive(v4) else if not u142 then if not Participants.IsBot(v4) then CharacterResolver.isAlivePlayer(v4) else Participants.IsAlive(v4) else false else false)
                    end
                end
                v2 = not v3 or (LocalPlayer:GetAttribute("Team")) == v1:GetAttribute("Team")
            else
                v2 = false
            end
        end
        if v2 then
            return v1
        end
    end
    return nil
end

local function IsReturningToMainMenu() -- Line: 252 -- upvalues: MenuState (val)
    if not MenuState.WantsMainMenu() then
        return false
    end
    local v1 = MenuState.GetMenuFrame()
    local v2 = false
    if v1 ~= nil then
        v2 = v1.Visible == true
    end
    return v2
end

local function ShouldBeSpectating() -- Line: 261
    -- upvalues: MenuState (val), ReplicatedStorage (val), LocalPlayer (val), IsPlayingTeam (val), u142 (ref)
    -- upvalues: Participants (val), CharacterResolver (val)
    if not MenuState.IsCaseSceneActive() then
        local v1
        if MenuState.WantsMainMenu() then
            local v2 = MenuState.GetMenuFrame()
            v1 = false
            if v2 ~= nil then
                v1 = v2.Visible == true
            end
        else
            v1 = false
        end
        if not v1 then
            if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
                return false
            end
            local v3 = LocalPlayer
            if not (if IsPlayingTeam(v3:GetAttribute("Team")) then if v3 ~= LocalPlayer then if not Participants.IsBot(v3) then CharacterResolver.isAlivePlayer(v3) else Participants.IsAlive(v3) else if not u142 then if not Participants.IsBot(v3) then CharacterResolver.isAlivePlayer(v3) else Participants.IsAlive(v3) else false else false) then
                v3 = LocalPlayer
                if IsPlayingTeam(v3:GetAttribute("Team")) then
                    v3 = require(ReplicatedStorage.Database.Components.GameState).GetState()
                    local v4 = false
                    if v3 ~= "Game Ending" then
                        v4 = v3 ~= "Map Voting"
                    end
                    return v4
                end
            end
            return false
        end
    end
    return false
end

local function SpectateKillerOrNext() -- Line: 283 -- upvalues: GetKillerPlayer (val), u0 (val)
    local v1 = GetKillerPlayer()
    if v1 then
        u0.SetNextPlayer(v1)
        return
    end
    u0.Next()
end

local function StartSpectatingOnDeath() -- Line: 293
    -- upvalues: ShouldBeSpectating (val), CharacterResolver (val), Ragdoll (val), u155 (ref), u156 (ref)
    -- upvalues: CameraController (val), Constants (val), GetKillerPlayer (val), u0 (val)
    if not ShouldBeSpectating() then
        return
    end
    local v1 = CharacterResolver.getLocalCharacter()
    if v1 then
        Ragdoll.HideCharacterLocally(v1)
    end
    if not u155 and not u156 then
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
        CameraController.setPerspective(true, false)
        local v2 = GetKillerPlayer()
        if v2 then
            u0.SetNextPlayer(v2)
            return
        end
        u0.Next()
        return
    end
end

local function UpdateCharacters() -- Line: 314
    -- upvalues: LocalPlayer (val), u140 (val), Participants (val), IsPlayingTeam (val), u142 (ref)
    -- upvalues: CharacterResolver (val)
    local v1
    local Attribute = workspace:GetAttribute("ServerGamemode")
    local v2 = (if Attribute == "Competitive" then Attribute else if Attribute ~= "Deathmatch" then "Casual" else Attribute) == "Competitive"
    local Attribute_2 = LocalPlayer:GetAttribute("Team")
    table.clear(u140)
    for i, v in ipairs((Participants.GetAll())) do
        v1 = not v2
        if not v1 then
            v1 = true
            if Attribute_2 ~= "Spectators" then
                v1 = v:GetAttribute("Team") == Attribute_2
            end
        end
        if v1
            and v ~= LocalPlayer
            and (if IsPlayingTeam(v:GetAttribute("Team")) then if v ~= LocalPlayer then if not Participants.IsBot(v) then CharacterResolver.isAlivePlayer(v) else Participants.IsAlive(v) else if not u142 then if not Participants.IsBot(v) then CharacterResolver.isAlivePlayer(v) else Participants.IsAlive(v) else false else false) then
            table.insert(u140, v)
        end
    end
end

local function IncrementSpectateIndex(a1) -- Line: 331
    -- upvalues: UpdateCharacters (val), u140 (val), u147 (ref), u155 (ref), u144 (ref)
    UpdateCharacters()
    if #u140 > 0 then
        local Player = u147 or u155 and u155.Player
        local v1 = Player and table.find(u140, Player)
        if v1 then
            u144 = v1
        end
        u144 = u144 + a1
        if u144 <= 0 then
            u144 = #u140
            return
        end
        local v2 = u144
        if #u140 < v2 then
            u144 = 1
        end
    end
end

local function IsSpectateInputBlockedByUi() -- Line: 352
    -- upvalues: GuiService (val), UserInputService (val), MenuState (val), u134 (val)
    local v1
    if GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() ~= nil then
        return true
    end
    local v2 = MenuState.GetMenuFrame()
    if v2 and v2.Visible then
        return true
    end
    local v3 = MenuState.GetMainGui()
    if not v3 then
        return false
    end
    local Gameplay = v3:FindFirstChild("Gameplay")
    local Middle = Gameplay and Gameplay:FindFirstChild("Middle")
    if not Middle then
        return false
    end
    for i, j in u134 do
        v1 = Middle:FindFirstChild(j)
        if v1 and v1:IsA("GuiObject") and v1.Visible then
            return true
        end
    end
    return false
end

local function ReleaseMenuMouseLock() -- Line: 391
    -- upvalues: IsSpectateInputBlockedByUi (val), MenuState (val), CameraController (val)
    if not IsSpectateInputBlockedByUi() and not MenuState.IsCaseSceneActive() and not MenuState.IsInspectActive() then
        CameraController.resetForceLockOverride()
        return
    end
end

function u0.GetCurrentSpectateInstance() -- Line: 402 -- upvalues: u155 (ref)
    return u155
end

function u0.IsLocalPlayerDead() -- Line: 409 -- upvalues: u142 (ref)
    return u142
end

function u0.IsTakingOverCamera() -- Line: 416 -- upvalues: MenuState (val), ShouldBeSpectating (val), LocalPlayer (val)
    local v1
    if MenuState.WantsMainMenu() then
        local v2 = MenuState.GetMenuFrame()
        v1 = false
        if v2 ~= nil then
            v1 = v2.Visible == true
        end
    else
        v1 = false
    end
    if v1 then
        return false
    end
    return ShouldBeSpectating() or LocalPlayer:GetAttribute("IsSpectating") == true
end

function u0.IsFreecamActive() -- Line: 426 -- upvalues: u156 (ref), u155 (ref)
    local v1 = true
    if u156 == nil then
        v1 = false
        if u155 ~= nil then
            v1 = u155.FreecamInstance ~= nil
        end
    end
    return v1
end

function u0.CanSwitchPerspective() -- Line: 433
    -- upvalues: u155 (ref), LocalPlayer (val), IsPlayingTeam (val), u142 (ref), Participants (val)
    -- upvalues: CharacterResolver (val)
    local v1 = false
    if u155 ~= nil then
        local v2 = false
        local Attribute = workspace:GetAttribute("ServerGamemode")
        if (if Attribute == "Competitive" then Attribute else if Attribute ~= "Deathmatch" then "Casual" else Attribute) == "Competitive" then
            v2 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
            if v2 then
                local v3 = LocalPlayer
                v2 = not (if IsPlayingTeam(v3:GetAttribute("Team")) then if v3 ~= LocalPlayer then if not Participants.IsBot(v3) then CharacterResolver.isAlivePlayer(v3) else Participants.IsAlive(v3) else if not u142 then if not Participants.IsBot(v3) then CharacterResolver.isAlivePlayer(v3) else Participants.IsAlive(v3) else false else false)
            end
        end
        v1 = not v2
    end
    return v1
end

function u0.IsSpectatingNow() -- Line: 440 -- upvalues: u155 (ref), u156 (ref), LocalPlayer (val)
    local v1 = true
    if u155 == nil then
        v1 = true
        if u156 == nil then
            v1 = LocalPlayer:GetAttribute("IsSpectating") == true
        end
    end
    return v1
end

function u0.GetPlayer() -- Line: 447
    -- upvalues: LocalPlayer (val), IsPlayingTeam (val), u142 (ref), Participants (val), CharacterResolver (val)
    -- upvalues: u155 (ref)
    local v1 = LocalPlayer
    if if IsPlayingTeam(v1:GetAttribute("Team")) then if v1 ~= LocalPlayer then if not Participants.IsBot(v1) then CharacterResolver.isAlivePlayer(v1) else Participants.IsAlive(v1) else if not u142 then if not Participants.IsBot(v1) then CharacterResolver.isAlivePlayer(v1) else Participants.IsAlive(v1) else false else false then
        return LocalPlayer
    end
    if u155 then
        return u155.Player
    end
    return nil
end

function u0.SetNextPlayer(a1) -- Line: 456
    -- upvalues: u155 (ref), u147 (ref), LocalPlayer (val), IsPlayingTeam (val), u142 (ref), Participants (val)
    -- upvalues: CharacterResolver (val), u0 (val), Remotes (val), u148 (ref), RemoteCharacters (val)
    -- upvalues: CharacterGeneration (val), ClientCharacterPresentation (val), u139 (ref), Spectate (val)
    local v1, v2, v3
    local Player = u155 and u155.Player
    u147 = nil
    if a1 == LocalPlayer then
        v1 = false
    else
        v2 = if IsPlayingTeam(a1:GetAttribute("Team")) then if a1 ~= LocalPlayer then if not Participants.IsBot(a1) then CharacterResolver.isAlivePlayer(a1) else Participants.IsAlive(a1) else if not u142 then if not Participants.IsBot(a1) then CharacterResolver.isAlivePlayer(a1) else Participants.IsAlive(a1) else false else false
        if v2 then
            v2 = false
            local Attribute = workspace:GetAttribute("ServerGamemode")
            if (if Attribute == "Competitive" then Attribute else if Attribute ~= "Deathmatch" then "Casual" else Attribute) == "Competitive" then
                v2 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
                if v2 then
                    v3 = LocalPlayer
                    v2 = not (if IsPlayingTeam(v3:GetAttribute("Team")) then if v3 ~= LocalPlayer then if not Participants.IsBot(v3) then CharacterResolver.isAlivePlayer(v3) else Participants.IsAlive(v3) else if not u142 then if not Participants.IsBot(v3) then CharacterResolver.isAlivePlayer(v3) else Participants.IsAlive(v3) else false else false)
                end
            end
            v1 = not v2 or (LocalPlayer:GetAttribute("Team")) == a1:GetAttribute("Team")
        else
            v1 = false
        end
    end
    if not v1 then
        u0.Next()
        return
    end
    v1 = Participants.IsBot(a1)
    Remotes.Spectate.SpectatePlayer.Send(if not v1 then a1.Name else tostring((Participants.Key(a1))))
    v2 = if not v1 then CharacterResolver.getPlayerCharacter(a1) else Participants.Character(a1)
    if v1 and not CharacterResolver.isAliveCharacter(v2) then
        u147 = a1
        u148 = os.clock()
        return
    end
    local v4 = Player == a1
    v3 = u155 and u155.Character == v2
    local v5 = if IsPlayingTeam(a1:GetAttribute("Team")) then if a1 ~= LocalPlayer then if not Participants.IsBot(a1) then CharacterResolver.isAlivePlayer(a1) else Participants.IsAlive(a1) else if not u142 then if not Participants.IsBot(a1) then CharacterResolver.isAlivePlayer(a1) else Participants.IsAlive(a1) else false else false
    if v4 and v3 and v5 then
        if not v1 then
            RemoteCharacters.SetPinnedPlayer(a1)
        end
        return
    end
    u0.Stop(false, true)
    if not v1 then
        RemoteCharacters.SetPinnedPlayer(a1)
        local Attribute_3 = a1:GetAttribute(CharacterGeneration.AttributeName)
        if typeof(Attribute_3) == "number" then
            ClientCharacterPresentation.Create(a1, Attribute_3)
        end
        v2 = CharacterResolver.getPlayerCharacter(a1)
    end
    if v2 and v5 and CharacterResolver.resolve(v2) then
        local v6 = false
        local Attribute_4 = workspace:GetAttribute("ServerGamemode")
        if (if Attribute_4 == "Competitive" then Attribute_4 else if Attribute_4 ~= "Deathmatch" then "Casual" else Attribute_4) == "Competitive" then
            v6 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
            if v6 then
                local v7 = LocalPlayer
                v6 = not (if IsPlayingTeam(v7:GetAttribute("Team")) then if v7 ~= LocalPlayer then if not Participants.IsBot(v7) then CharacterResolver.isAlivePlayer(v7) else Participants.IsAlive(v7) else if not u142 then if not Participants.IsBot(v7) then CharacterResolver.isAlivePlayer(v7) else Participants.IsAlive(v7) else false else false)
            end
        end
        local v8 = if not v6 then u139 else "First-Person"
        u155 = if not v1 then Spectate.new(a1, v2, v8) else Spectate.newBot(a1, v2, v8)
        if u139 ~= "First-Person" then
            v6:Switch(u139)
        end
        u0.ListenToSpectate:Fire(a1)
        v6.StopSpectating:Once(function() -- Line: 506 -- upvalues: u0 (upval)
            u0.Stop(false, true)
            u0.Next()
        end)
        return
    end
    RemoteCharacters.SetPinnedPlayer(nil)
    u0.Next()
end

function u0.Switch() -- Line: 522
    -- upvalues: LocalPlayer (val), IsPlayingTeam (val), u142 (ref), Participants (val), CharacterResolver (val)
    -- upvalues: u139 (ref), u143 (ref), u155 (ref), u156 (ref), u151 (val)
    local v1 = false
    local Attribute = workspace:GetAttribute("ServerGamemode")
    if (if Attribute == "Competitive" then Attribute else if Attribute ~= "Deathmatch" then "Casual" else Attribute) == "Competitive" then
        v1 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
        if v1 then
            local v2 = LocalPlayer
            v1 = not (if IsPlayingTeam(v2:GetAttribute("Team")) then if v2 ~= LocalPlayer then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else if not u142 then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else false else false)
        end
    end
    if not v1 then
        local v3 = u143 + 1
        u143 = if not (#u151 < v3) then u143 + 1 else 1
        u139 = u151[u143]
        if u155 then
            u155:Switch(u139)
        end
        return
    end
    u139 = "First-Person"
    u143 = 1
    if u155 then
        u155:Switch("First-Person")
    end
    if u156 then
        u156:Destroy()
        u156 = nil
    end
end

function u0.UpdateIndex(a1) -- Line: 541
    -- upvalues: UpdateCharacters (val), u140 (val), u147 (ref), u155 (ref), u144 (ref), Promise (val)
    -- upvalues: IsPlayingTeam (val), LocalPlayer (val), u142 (ref), Participants (val), CharacterResolver (val)
    -- upvalues: u0 (val)
    UpdateCharacters()
    if #u140 > 0 then
        local Player = u147 or u155 and u155.Player
        local v1 = Player and table.find(u140, Player)
        if v1 then
            u144 = v1
        end
        u144 = u144 + a1
        if not (u144 <= 0) then
            local v2 = u144
            if #u140 < v2 then
                u144 = 1
            end
        else
            u144 = #u140
        end
    end
    return Promise.new(function(a1, a2) -- Line: 544
        -- upvalues: u140 (upval), u144 (upval), IsPlayingTeam (upval), LocalPlayer (upval), u142 (upval)
        -- upvalues: Participants (upval), CharacterResolver (upval), UpdateCharacters (upval), u0 (upval)
        local v1 = u140[u144]
        if v1
            and (if IsPlayingTeam(v1:GetAttribute("Team")) then if v1 ~= LocalPlayer then if not Participants.IsBot(v1) then CharacterResolver.isAlivePlayer(v1) else Participants.IsAlive(v1) else if not u142 then if not Participants.IsBot(v1) then CharacterResolver.isAlivePlayer(v1) else Participants.IsAlive(v1) else false else false) then
            a1(v1)
            return
        end
        UpdateCharacters()
        if #u140 > 0 then
            u144 = 1
            a1(u140[1])
            return
        end
        u0.Stop(false, false)
        a2("No players alive to spectate")
    end)
end

local function SpectateByOffset(a1) -- Line: 564 -- upvalues: u0 (val) -- types: a1: number
    return ((u0.UpdateIndex(a1)):andThen(function(a1) -- Line: 566 -- upvalues: u0 (upval) -- types: a1: userdata
        u0.SetNextPlayer(a1)
    end)):catch(function() end)
end

function u0.Next() -- Line: 574 -- upvalues: SpectateByOffset (val)
    return SpectateByOffset(1)
end

function u0.Previous() -- Line: 578 -- upvalues: SpectateByOffset (val)
    return SpectateByOffset(-1)
end

function u0.IsControllerPress(a1) -- Line: 589 -- upvalues: UserInputService (val) -- types: a1: userdata
    local v1
    if string.match(a1.UserInputType.Name, "^Gamepad%d+$") then
        return true
    end
    for i, j in UserInputService:GetConnectedGamepads() do
        for k, n in UserInputService:GetGamepadState(j) do
            v1 = true
            if n.KeyCode ~= Enum.KeyCode.ButtonR2 then
                v1 = n.KeyCode == Enum.KeyCode.ButtonL2
            end
            if v1 and 0.1 < n.Position.Z then
                return true
            end
        end
    end
    return false
end

function u0.RequestSwitch(a1) -- Line: 607
    -- upvalues: u0 (val), LocalPlayer (val), IsPlayingTeam (val), u142 (ref), Participants (val)
    -- upvalues: CharacterResolver (val), u155 (ref), u156 (ref), u146 (ref)
    if not u0.IsSpectatingNow() then
        return
    end
    local v1 = LocalPlayer
    if (if IsPlayingTeam(v1:GetAttribute("Team")) then if v1 ~= LocalPlayer then if not Participants.IsBot(v1) then CharacterResolver.isAlivePlayer(v1) else Participants.IsAlive(v1) else if not u142 then if not Participants.IsBot(v1) then CharacterResolver.isAlivePlayer(v1) else Participants.IsAlive(v1) else false else false)
        and u155 == nil
        and u156 == nil then
        return
    end
    local v2 = os.clock()
    if v2 - u146 < 0.15 then
        return
    end
    u146 = v2
    if a1 < 0 then
        u0.Previous()
        return
    end
    u0.Next()
end

function u0.Stop(a1, a2) -- Line: 632
    -- upvalues: u150 (ref), LocalPlayer (val), u149 (ref), RemoteCharacters (val), u147 (ref), u155 (ref)
    -- upvalues: Remotes (val), u156 (ref), u126 (val)
    if u150 and LocalPlayer.ReplicationFocus == u150 then
        LocalPlayer.ReplicationFocus = nil
    end
    u149 = nil
    u150 = nil
    RemoteCharacters.SetPinnedPlayer(nil)
    u147 = nil
    if u155 then
        u155:Destroy()
        u155 = nil
    end
    if a1 and LocalPlayer:GetAttribute("IsSpectating") then
        Remotes.Spectate.StopSpectating.Send()
    end
    if a2 and u156 then
        u156:Destroy()
        u156 = nil
    end
    u126:Fire()
end

function u0.Broadcast() -- Line: 656
    -- upvalues: LocalPlayer (val), u145 (ref), InventoryController (val), MenuState (val)
    -- upvalues: BlackMarketSceneController (val), Remotes (val), CurrentCamera (val)
    local Attribute = LocalPlayer:GetAttribute("Spectators")
    local v1 = if not Attribute then 0.2 else if not (Attribute > 0) then 0.2 else 0.016666666666666666
    if v1 <= u145 then
        local v2 = InventoryController.getCurrentEquipped()
        u145 = u145 - v1
        if v2 then
            local MainGui = LocalPlayer.PlayerGui:FindFirstChild("MainGui") and LocalPlayer.PlayerGui.MainGui:FindFirstChild("Menu")
            local Inspect = MainGui and MainGui:FindFirstChild("Inspect")
            if Inspect and Inspect.Visible then
                return
            end
            if not MenuState.IsCaseSceneActive() and not BlackMarketSceneController.IsActive() then
                Remotes.Spectate.UpdateCameraCFrame.Send({CameraCFrame = CurrentCamera.CFrame, UserId = LocalPlayer.UserId})
                return
            end
            return
        end
    end
end

local function UpdatePendingBotTarget() -- Line: 685
    -- upvalues: u147 (ref), CharacterResolver (val), Participants (val), u0 (val), LocalPlayer (val)
    -- upvalues: IsPlayingTeam (val), u142 (ref), u148 (ref), u155 (ref)
    local v1
    local v2 = u147
    if not v2 then
        return
    end
    if CharacterResolver.isAliveCharacter(Participants.Character(v2)) then
        u0.SetNextPlayer(v2)
        return
    end
    if v2 == LocalPlayer then
        v1 = false
    else
        local v3 = if IsPlayingTeam(v2:GetAttribute("Team")) then if v2 ~= LocalPlayer then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else if not u142 then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else false else false
        if v3 then
            v3 = false
            local Attribute = workspace:GetAttribute("ServerGamemode")
            if (if Attribute == "Competitive" then Attribute else if Attribute ~= "Deathmatch" then "Casual" else Attribute) == "Competitive" then
                v3 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
                if v3 then
                    local v4 = LocalPlayer
                    v3 = not (if IsPlayingTeam(v4:GetAttribute("Team")) then if v4 ~= LocalPlayer then if not Participants.IsBot(v4) then CharacterResolver.isAlivePlayer(v4) else Participants.IsAlive(v4) else if not u142 then if not Participants.IsBot(v4) then CharacterResolver.isAlivePlayer(v4) else Participants.IsAlive(v4) else false else false)
                end
            end
            v1 = not v3 or (LocalPlayer:GetAttribute("Team")) == v2:GetAttribute("Team")
        else
            v1 = false
        end
    end
    if not v1 or 1.5 < os.clock() - u148 then
        u147 = nil
        if u155 then
            u0.SetNextPlayer(u155.Player)
        end
    end
end

function u0.Render(a1) -- Line: 707
    -- upvalues: u141 (ref), u145 (ref), LocalPlayer (val), IsPlayingTeam (val), u142 (ref), Participants (val)
    -- upvalues: CharacterResolver (val), u139 (ref), u143 (ref), u155 (ref), u156 (ref), u0 (val), u150 (ref)
    -- upvalues: u149 (ref), BlackMarketSceneController (val), CurrentCamera (val), CameraController (val)
    -- upvalues: ShouldBeSpectating (val), MenuState (val), UserInputService (val), IsSpectateInputBlockedByUi (val)
    -- upvalues: UpdatePendingBotTarget (val), Router (val), UpdateCharacters (val), u140 (val), u147 (ref), u144 (ref)
    -- upvalues: GetSpectateBombModel (val), Constants (val), Freecam (val), u128 (val)
    local v1, v2, v3
    u141 = u141 + a1
    u145 = u145 + a1
    local v4 = false
    local Attribute = workspace:GetAttribute("ServerGamemode")
    if (if Attribute == "Competitive" then Attribute else if Attribute ~= "Deathmatch" then "Casual" else Attribute) == "Competitive" then
        v4 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
        if v4 then
            v2 = LocalPlayer
            v4 = not (if IsPlayingTeam(v2:GetAttribute("Team")) then if v2 ~= LocalPlayer then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else if not u142 then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else false else false)
        end
    end
    if v4 then
        v1 = false
        local Attribute_2 = workspace:GetAttribute("ServerGamemode")
        if (if Attribute_2 == "Competitive" then Attribute_2 else if Attribute_2 ~= "Deathmatch" then "Casual" else Attribute_2) == "Competitive" then
            v1 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
            if v1 then
                v3 = LocalPlayer
                v1 = not (if IsPlayingTeam(v3:GetAttribute("Team")) then if v3 ~= LocalPlayer then if not Participants.IsBot(v3) then CharacterResolver.isAlivePlayer(v3) else Participants.IsAlive(v3) else if not u142 then if not Participants.IsBot(v3) then CharacterResolver.isAlivePlayer(v3) else Participants.IsAlive(v3) else false else false)
            end
        end
        if v1 then
            u139 = "First-Person"
            u143 = 1
            if u155 and u155.PerspectiveState ~= "First-Person" then
                u155:Switch("First-Person")
            end
            if u156 then
                u156:Destroy()
                u156 = nil
            end
        end
    end
    if u142 then
        v2 = LocalPlayer
        if if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) then
            u142 = false
        end
    end
    v2 = LocalPlayer
    v1 = if IsPlayingTeam(v2:GetAttribute("Team")) then if v2 ~= LocalPlayer then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else if not u142 then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else false else false
    if v1 then
        u0.Broadcast()
        if u150 and LocalPlayer.ReplicationFocus == u150 then
            LocalPlayer.ReplicationFocus = nil
        end
        u149 = nil
        u150 = nil
        if u155 then
            u0.Stop(true, true)
        end
        if u156 then
            u156:Destroy()
            u156 = nil
        end
        v2 = LocalPlayer
        v1 = if IsPlayingTeam(v2:GetAttribute("Team")) then if v2 ~= LocalPlayer then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else if not u142 then if not Participants.IsBot(v2) then CharacterResolver.isAlivePlayer(v2) else Participants.IsAlive(v2) else false else false
        if v1 and not BlackMarketSceneController.IsActive() then
            v1 = CharacterResolver.getLocalCharacter()
            v2 = CharacterResolver.getCameraPart(v1) or CharacterResolver.getRootPart(v1)
            if v2 then
                CurrentCamera.CameraType = Enum.CameraType.Custom
                CurrentCamera.CameraSubject = v2
            end
            CameraController.setPerspective(true, false)
            return
        end
        return
    end
    if not ShouldBeSpectating() and not LocalPlayer:GetAttribute("IsSpectating") then
        if u155 then
            u0.Stop(false, true)
            return
        end
        if u150 and LocalPlayer.ReplicationFocus == u150 then
            LocalPlayer.ReplicationFocus = nil
        end
        u149 = nil
        u150 = nil
        return
    end
    if MenuState.WantsMainMenu() then
        v2 = MenuState.GetMenuFrame()
        v1 = false
        if v2 ~= nil then
            v1 = v2.Visible == true
        end
    else
        v1 = false
    end
    if v1 then
        if u155 then
            u0.Stop(false, true)
            return
        end
        if u150 and LocalPlayer.ReplicationFocus == u150 then
            LocalPlayer.ReplicationFocus = nil
        end
        u149 = nil
        u150 = nil
        return
    end
    if not MenuState.IsCaseSceneActive() and not BlackMarketSceneController.IsActive() then
        if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter
            and not IsSpectateInputBlockedByUi()
            and not MenuState.IsCaseSceneActive()
            and not MenuState.IsInspectActive() then
            CameraController.resetForceLockOverride()
        end
        UpdatePendingBotTarget()
        if u155 then
            if u150 and LocalPlayer.ReplicationFocus == u150 then
                LocalPlayer.ReplicationFocus = nil
            end
            u149 = nil
            u150 = nil
            if Router.broadcastRouter("IsInspectActive") then
                return
            end
            u155:Render(a1)
            if not u156 then
                return
            end
            u156:Destroy()
            u156 = nil
            return
        end
        if u141 >= 0.2 then
            u141 = 0
            UpdateCharacters()
            if #u140 > 0 then
                local Player = u147 or u155 and u155.Player
                v2 = Player and table.find(u140, Player)
                if v2 then
                    u144 = v2
                end
                u144 = u144 + 1
                if not (u144 <= 0) then
                    v3 = u144
                    if #u140 < v3 then
                        u144 = 1
                    end
                else
                    u144 = #u140
                end
            end
        end
        if u147 then
            return
        end
        if u140[u144] then
            if u150 and LocalPlayer.ReplicationFocus == u150 then
                LocalPlayer.ReplicationFocus = nil
            end
            u149 = nil
            u150 = nil
            u0.Next()
            return
        end
        if not v4 then
            if u150 and LocalPlayer.ReplicationFocus == u150 then
                LocalPlayer.ReplicationFocus = nil
            end
            u149 = nil
            u150 = nil
            if not u156 then
                v2 = Freecam.new()
                u156 = v2
                v2:Start()
                u128:Fire(true)
                return
            end
            return
        end
        if not u149 or not u149.Parent then
            u149 = GetSpectateBombModel()
            if u149 then
                CameraController.setPerspective(false, false)
                CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
            end
        end
        if not u149 then
            if u150 and LocalPlayer.ReplicationFocus == u150 then
                LocalPlayer.ReplicationFocus = nil
            end
            u149 = nil
            u150 = nil
        else
            v3 = u149
            if not v3 then
                v2 = false
            elseif v3.Parent then
                local PrimaryPart = v3.PrimaryPart
                if PrimaryPart then
                    if u150 ~= PrimaryPart then
                        u150 = PrimaryPart
                        LocalPlayer.ReplicationFocus = PrimaryPart
                    end
                    CurrentCamera.CameraType = Enum.CameraType.Follow
                    CurrentCamera.CameraSubject = PrimaryPart
                    v2 = true
                else
                    v2 = false
                end
            else
                v2 = false
            end
            if not v2 then
                if u150 and LocalPlayer.ReplicationFocus == u150 then
                    LocalPlayer.ReplicationFocus = nil
                end
                u149 = nil
                u150 = nil
            end
        end
        if u156 then
            u156:Destroy()
            u156 = nil
        end
        return
    end
end

function u0.Initialize() -- Line: 814
    -- upvalues: Observers (val), LocalPlayer (val), MenuState (val), IsSpectateInputBlockedByUi (val)
    -- upvalues: CameraController (val), Constants (val), u155 (ref), GetKillerPlayer (val), u0 (val), Remotes (val)
    -- upvalues: Participants (val), CharacterResolver (val), u142 (ref), StartSpectatingOnDeath (val)
    -- upvalues: IsPlayingTeam (val), u139 (ref), u143 (ref), ReplicatedStorage (val), RunServiceController (val)
    Observers.observeAttribute(LocalPlayer, "IsSpectating", function(a1) -- Line: 816
        -- upvalues: LocalPlayer (upval), MenuState (upval), IsSpectateInputBlockedByUi (upval)
        -- upvalues: CameraController (upval), Constants (upval), u155 (upval), GetKillerPlayer (upval), u0 (upval)
        if a1 then
            LocalPlayer:SetAttribute("PendingSpectateRequestAt", nil)
            if not MenuState.IsCaseSceneActive() then
                local v1
                if MenuState.WantsMainMenu() then
                    local v2 = MenuState.GetMenuFrame()
                    v1 = false
                    if v2 ~= nil then
                        v1 = v2.Visible == true
                    end
                else
                    v1 = false
                end
                if not v1 then
                    if not IsSpectateInputBlockedByUi()
                        and not MenuState.IsCaseSceneActive()
                        and not MenuState.IsInspectActive() then
                        CameraController.resetForceLockOverride()
                    end
                    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
                    CameraController.setPerspective(true, false)
                    if not u155 then
                        v1 = GetKillerPlayer()
                        if not v1 then
                            u0.Next()
                        else
                            u0.SetNextPlayer(v1)
                        end
                    end
                end
            end
        end
        return function() -- Line: 831 -- upvalues: u0 (upval)
            u0.Stop(false, true)
        end
    end)
    Remotes.Character.CharacterDied.Listen(function() -- Line: 837
        -- upvalues: LocalPlayer (upval), Participants (upval), CharacterResolver (upval), u142 (upval)
        -- upvalues: StartSpectatingOnDeath (upval)
        local v1 = LocalPlayer
        if if not Participants.IsBot(v1) then CharacterResolver.isAlivePlayer(v1) else Participants.IsAlive(v1) then
            u142 = false
            return
        end
        u142 = true
        StartSpectatingOnDeath()
    end)
    LocalPlayer.CharacterAdded:Connect(function(a1) -- Line: 848
        -- upvalues: u142 (upval), LocalPlayer (upval), IsPlayingTeam (upval), CharacterResolver (upval)
        -- upvalues: MenuState (upval), u139 (upval), u143 (upval), u0 (upval), Remotes (upval), u155 (upval)
        -- upvalues: Participants (upval), StartSpectatingOnDeath (upval)
        u142 = false
        local v1 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"))
        local v2 = CharacterResolver.isAliveCharacter(a1)
        local Attribute = LocalPlayer:GetAttribute("PendingSpectateRequestAt")
        local v3 = false
        if Attribute ~= nil then
            v3 = os.clock() - Attribute < 3
        end
        if not v1 then
            if u155 and u155.Player then
                Remotes.Spectate.SpectatePlayer.Send(if not u155.IsBot then u155.Player.Name else tostring((Participants.Key(u155.Player))))
            end
        elseif v2 then
            MenuState.SetWantsMainMenu(false)
            u139 = "First-Person"
            u143 = 1
            u0.Stop(not v3, true)
            if not v3 and LocalPlayer:GetAttribute("IsSpectating") then
                Remotes.Spectate.StopSpectating.Send()
            end
        elseif u155 and u155.Player then
            Remotes.Spectate.SpectatePlayer.Send(if not u155.IsBot then u155.Player.Name else tostring((Participants.Key(u155.Player))))
        end
        local u83 = (a1:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 875 -- upvalues: a1 (val), StartSpectatingOnDeath (upval)
            if a1:GetAttribute("Dead") then
                StartSpectatingOnDeath()
            end
        end)
        local u84 = nil
        local v4 = a1.AncestryChanged:Connect(function(a1, a2) -- Line: 881 -- upvalues: u83 (val), u84 (ref)
            if not a2 then
                u83:Disconnect()
                u84:Disconnect()
            end
        end)
    end)
    ;(require(ReplicatedStorage.Database.Components.GameState)).ListenToState(function(a1, a2) -- Line: 890 -- upvalues: u0 (upval)
        if a2 == "Game Ending" or a2 == "Map Voting" then
            u0.Stop(false, true)
        end
    end)
    RunServiceController.BindToRenderStep("SpectateController.Render", function(a1) -- Line: 896 -- upvalues: u0 (upval) -- types: a1: number
        u0.Render(a1)
    end)
end

function u0.Start() -- Line: 901
    -- upvalues: Remotes (val), u155 (ref), Players (val), CharacterGeneration (val), CharacterActions (val)
    -- upvalues: UserInputService (val), LocalPlayer (val), u0 (val), IsSpectateInputBlockedByUi (val), GuiService (val)
    -- upvalues: CurrentCamera (val)
    Remotes.Character.Action.Listen(function(a1) -- Line: 903
        -- upvalues: u155 (upval), Players (upval), CharacterGeneration (upval), CharacterActions (upval)
        if u155 and typeof(a1) == "table" then
            local PlayerByUserId = if typeof(a1.UserId) ~= "number" then nil else Players:GetPlayerByUserId(a1.UserId)
            if PlayerByUserId and PlayerByUserId == u155.Player then
                if (CharacterGeneration.Get(PlayerByUserId.Character)) ~= a1.Generation then
                    return
                end
                local v1 = CharacterActions.ToName(a1.ActionId)
                if v1 then
                    u155:AddSpectateEvent(v1)
                end
                return
            end
            return
        end
    end)
    UserInputService.InputBegan:Connect(function(a1) -- Line: 922
        -- upvalues: LocalPlayer (upval), u0 (upval), IsSpectateInputBlockedByUi (upval), GuiService (upval)
        if not LocalPlayer:GetAttribute("IsPlayerChatting") and u0.IsSpectatingNow() then
            local v1
            if a1.KeyCode == Enum.KeyCode.Space then
                u0.Switch()
                return
            end
            if a1.KeyCode == Enum.KeyCode.ButtonA then
                if not IsSpectateInputBlockedByUi() and GuiService.SelectedObject == nil then
                    u0.Switch()
                end
                return
            end
            if not (a1.KeyCode == Enum.KeyCode.ButtonL1) and a1.KeyCode ~= Enum.KeyCode.ButtonR1 then
                local v2 = a1.UserInputType == Enum.UserInputType.MouseButton1
                v1 = a1.UserInputType == Enum.UserInputType.MouseButton2
                if not v2 and not v1 then
                    return
                end
                if not IsSpectateInputBlockedByUi() and not u0.IsControllerPress(a1) then
                    local v3 = if not v2 then 1 else -1
                    u0.RequestSwitch(v3)
                    return
                end
                return
            end
            if not IsSpectateInputBlockedByUi() then
                local v4
                v1 = if not v4 then 1 else -1
                u0.RequestSwitch(v1)
            end
            return
        end
    end)
    if UserInputService.TouchEnabled then
        UserInputService.TouchStarted:Connect(function(a1, a2) -- Line: 965
            -- upvalues: LocalPlayer (upval), u0 (upval), CurrentCamera (upval)
            if not a2 and not LocalPlayer:GetAttribute("IsPlayerChatting") then
                u0.RequestSwitch(if not (a1.Position.X < CurrentCamera.ViewportSize.X / 2) then 1 else -1)
                return
            end
        end)
    end
end

return u0