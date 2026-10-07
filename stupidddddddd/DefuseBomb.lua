-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.DefuseBomb
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.DefuseBomb
-- Decompile time: 9.93 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
require(script:WaitForChild("Types"))
local RadialProgress = require(script:WaitForChild("RadialProgress"))
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Signal = require(ReplicatedStorage.Packages.Signal)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local InputController = require(ReplicatedStorage.Controllers.InputController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips)
local LocalPlayer = Players.LocalPlayer
local u98 = table.find(GetUserPlatform(), "Mobile")
if u98 then
    u98 = #GetUserPlatform() <= 1
end
local u99 = nil
local u100 = 0
local u101 = 0
local u102 = 0
local u106 = Vector2.new(0.5, 0.45)
local u107 = nil
local u108 = nil

local function getBombModel() -- Line: 103 -- upvalues: CollectionService (val)
    return CollectionService:GetTagged("Bomb")[1]
end

local function isBombResolvedState(a1) -- Line: 107 -- types: a1: userdata?
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

local function getSyncedDefuseStartTime(a1, a2) -- Line: 117 -- types: a1: userdata, a2: number
    local Attribute = a1:GetAttribute("DefuseStartTime")
    if typeof(Attribute) ~= "number" then
        return nil
    end
    local ServerTimeNow = workspace:GetServerTimeNow()
    local v1 = ServerTimeNow - Attribute
    if Attribute <= ServerTimeNow and v1 >= 0 and v1 <= math.max(a2, 12) then
        return Attribute
    end
    return nil
end

local function isSpectatingOtherDefuse(a1) -- Line: 135 -- upvalues: LocalPlayer (val), SpectateController (val)
    local Attribute = LocalPlayer:GetAttribute("IsSpectating")
    local v1 = SpectateController.GetCurrentSpectateInstance()
    return Attribute and v1 and a1.PlayerName ~= LocalPlayer.Name
end

local function resolveFromBombState(a1, a2) -- Line: 142 -- types: a2: userdata?
    if a2 and a2:GetAttribute("Defused") == true then
        a1:FinishDefuse(true)
        return
    end
    a1:CancelDefuse(true)
end

local function getHoldToDefuseMessage() -- Line: 150 -- upvalues: UserInputService (val), Tips (val)
    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        return "Keep holding the <b>Interact</b> button until the defuse finishes"
    end
    local Use = Tips.GetActionKeyText("Use")
    if Use then
        return (("Keep holding <b>%*</b> until the defuse finishes"):format(Use))
    end
    return "Keep holding the use button until the defuse finishes"
end

local function notifyTutorialDefuseCancelled(a1, a2) -- Line: 161
    -- upvalues: IsTutorialMode (val), LocalPlayer (val), SpectateController (val), CollectionService (val), u101 (ref)
    -- upvalues: Router (val), UserInputService (val), Tips (val)
    if IsTutorialMode() and a1.IsDefusing and not a1.HasSentDefuseRequest then
        local Attribute = LocalPlayer:GetAttribute("IsSpectating")
        local v1 = SpectateController.GetCurrentSpectateInstance()
        local v2 = Attribute and v1 and a1.PlayerName ~= LocalPlayer.Name
        if not v2 then
            local v3 = CollectionService:GetTagged("Bomb")[1]
            if v3 then
                v2 = true
                if v3:GetAttribute("Defused") ~= true then
                    v2 = true
                    if v3:GetAttribute("Exploding") ~= true then
                        v2 = v3:GetAttribute("Exploded") == true
                    end
                end
            else
                v2 = false
            end
            if not v2 then
                if os.clock() - u101 < 2 then
                    return
                end
                u101 = os.clock()
                local broadcastRouter = Router.broadcastRouter
                local v4 = a2
                if not v4 then
                    if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                        local Use = Tips.GetActionKeyText("Use")
                        v4 = if not Use then "Keep holding the use button until the defuse finishes" else ("Keep holding <b>%*</b> until the defuse finishes"):format(Use)
                    else
                        v4 = "Keep holding the <b>Interact</b> button until the defuse finishes"
                    end
                end
                broadcastRouter("CreateNotification", "Defuse Cancelled", v4, 3)
                return
            end
        end
        return
    end
end

function u0.InitializeProgressBar(a1) -- Line: 183 -- upvalues: RadialProgress (val)
    RadialProgress.Initialize(a1, "DefuseBomb")
end

function u0.UpdateProgressBar(a1, a2) -- Line: 187
    -- upvalues: RadialProgress (val), u106 (val)
    RadialProgress.Update(a1, a2, "Bomb", u106)
end

function u0:UpdateTimer(a2) -- Line: 191 -- upvalues: RadialProgress (val) -- types: self: table, a2: number
    RadialProgress.SetTimer(self.Frame, a2)
end

function u0:UpdateTitle() -- Line: 195 -- upvalues: RadialProgress (val)
    RadialProgress.SetTitle(
        self.Frame,
        string.format("%s is defusing the bomb %s a kit.", self.PlayerName, if not self.HasDefuseKit then "without" else "with")
    )
end

function u0:StartDefuse(a2) -- Line: 202
    -- upvalues: LocalPlayer (val), SpectateController (val), Participants (val), CollectionService (val)
    -- upvalues: RunServiceController (val), notifyTutorialDefuseCancelled (val), u98 (val), InputController (val)
    -- upvalues: Remotes (val), u102 (ref)
    local ServerTimeNow_2, v1
    local Attribute = LocalPlayer:GetAttribute("IsSpectating")
    local v2 = SpectateController.GetCurrentSpectateInstance()
    local Player = a2 or Attribute and v2 and v2.Player or LocalPlayer
    if self.IsDefusing and self.PlayerName == Participants.Name(Player) then
        return
    end
    local v3 = CollectionService:GetTagged("Bomb")[1]
    if v3 then
        v1 = true
        if v3:GetAttribute("Defused") ~= true then
            v1 = true
            if v3:GetAttribute("Exploding") ~= true then
                v1 = v3:GetAttribute("Exploded") == true
            end
        end
    else
        v1 = false
    end
    if v1 then
        return
    end
    if Player == LocalPlayer then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", true)
    end
    self.HasDefuseKit = Player:GetAttribute("HasDefuseKit") == true
    self.PlayerName = Participants.Name(Player)
    self.DefuseTime = if not self.HasDefuseKit then 10 else 5
    local DefuseTime = self.DefuseTime
    local Attribute_2 = Player:GetAttribute("DefuseStartTime")
    if typeof(Attribute_2) == "number" then
        local ServerTimeNow = workspace:GetServerTimeNow()
        local v4 = ServerTimeNow - Attribute_2
        ServerTimeNow_2 = if not (Attribute_2 <= ServerTimeNow) then nil else if not (v4 >= 0) then nil else if not (v4 <= math.max(DefuseTime, 12)) then nil else Attribute_2
    else
        ServerTimeNow_2 = nil
    end
    if not ServerTimeNow_2 then
        ServerTimeNow_2 = workspace:GetServerTimeNow()
    end
    self.DefuseStartTime = ServerTimeNow_2
    self.DefuseProgress = 0
    self.IsDefusing = true
    self.IsFinished = false
    self.HasSentDefuseRequest = false
    self.HasReceivedServerStartAck = false
    self.DefuseSessionId = nil
    if self.Frame then
        self.Frame.Visible = true
    end
    self:UpdateProgressBar(0)
    self:UpdateTimer(self.DefuseTime)
    self:UpdateTitle()
    self.Janitor:Add(RunServiceController.BindToHeartbeat("UI.DefuseBomb.UpdateProgress", function() -- Line: 245
        -- upvalues: self (val), CollectionService (upval), LocalPlayer (upval), SpectateController (upval)
        -- upvalues: notifyTutorialDefuseCancelled (upval), u98 (upval), InputController (upval), Remotes (upval)
        if self.IsDefusing and not self.IsFinished then
            local v1, v2, v3, v4
            local v5 = CollectionService:GetTagged("Bomb")[1]
            if v5 then
                v1 = true
                if v5:GetAttribute("Defused") ~= true then
                    v1 = true
                    if v5:GetAttribute("Exploding") ~= true then
                        v1 = v5:GetAttribute("Exploded") == true
                    end
                end
            else
                v1 = false
            end
            if v1 then
                v1 = self
                if v5 and v5:GetAttribute("Defused") == true then
                    v1:FinishDefuse(true)
                    return
                end
                v1:CancelDefuse(true)
                return
            end
            local Attribute = LocalPlayer:GetAttribute("IsSpectating")
            local v6 = SpectateController.GetCurrentSpectateInstance()
            local v7 = Attribute and v6 and self.PlayerName ~= LocalPlayer.Name
            local Player = v7 and v6 and v6.Player or LocalPlayer
            local DefuseTime = self.DefuseTime
            local Attribute_2 = Player:GetAttribute("DefuseStartTime")
            if typeof(Attribute_2) == "number" then
                local ServerTimeNow = workspace:GetServerTimeNow()
                local v8 = ServerTimeNow - Attribute_2
                v2 = if not (Attribute_2 <= ServerTimeNow) then nil else if not (v8 >= 0) then nil else if not (v8 <= math.max(DefuseTime, 12)) then nil else Attribute_2
            else
                v2 = nil
            end
            if v2 and 0.001 < (math.abs(v2 - self.DefuseStartTime)) then
                self.DefuseStartTime = v2
            end
            if v7 and v6 then
                if not v6.Player:GetAttribute("IsDefusingBomb") then
                    v4 = self
                    if v5 and v5:GetAttribute("Defused") == true then
                        v4:FinishDefuse(true)
                        return
                    end
                    v4:CancelDefuse(true)
                    return
                end
                v3 = false
                if not v7 then
                    if LocalPlayer:GetAttribute("IsDefusingBomb") == true then
                        self.HasReceivedServerStartAck = true
                    end
                    if not v3 then
                        if not self.HasReceivedServerStartAck and not self.HasSentDefuseRequest then
                            v4 = (workspace:GetServerTimeNow()) - self.DefuseStartTime
                            self.DefuseProgress = math.min(v4 / self.DefuseTime, 1)
                            self:UpdateProgressBar(self.DefuseProgress)
                            self:UpdateTimer((math.max(self.DefuseTime - v4, 0)))
                            if not v7 and 1 <= self.DefuseProgress and not self.HasSentDefuseRequest and v3 then
                                self.HasSentDefuseRequest = true
                                Remotes.C4.Defused.Send()
                                return
                            end
                            return
                        end
                        notifyTutorialDefuseCancelled(self, "Stand still next to the bomb until the defuse finishes")
                        v4 = self
                        if v5 and v5:GetAttribute("Defused") == true then
                            v4:FinishDefuse(true)
                            return
                        end
                        v4:CancelDefuse(true)
                        return
                    end
                end
                v4 = (workspace:GetServerTimeNow()) - self.DefuseStartTime
                self.DefuseProgress = math.min(v4 / self.DefuseTime, 1)
                self:UpdateProgressBar(self.DefuseProgress)
                self:UpdateTimer((math.max(self.DefuseTime - v4, 0)))
                if not v7 and 1 <= self.DefuseProgress and not self.HasSentDefuseRequest and v3 then
                    self.HasSentDefuseRequest = true
                    Remotes.C4.Defused.Send()
                    return
                end
                return
            end
            local Character = LocalPlayer.Character
            if Character
                and Character.PrimaryPart
                and v5
                and v5.PrimaryPart
                and 10 < (Character.PrimaryPart.Position - v5.PrimaryPart.Position).Magnitude then
                notifyTutorialDefuseCancelled(self, "Stay next to the bomb until the defuse finishes")
                self:CancelDefuse(false)
                return
            end
            if not u98 and not InputController.isActionActive("Use") then
                notifyTutorialDefuseCancelled(self)
                self:CancelDefuse(false)
                return
            end
            v3 = false
            if not v7 then
                if LocalPlayer:GetAttribute("IsDefusingBomb") == true then
                    self.HasReceivedServerStartAck = true
                end
                if not v3 then
                    if not self.HasReceivedServerStartAck and not self.HasSentDefuseRequest then
                        v4 = (workspace:GetServerTimeNow()) - self.DefuseStartTime
                        self.DefuseProgress = math.min(v4 / self.DefuseTime, 1)
                        self:UpdateProgressBar(self.DefuseProgress)
                        self:UpdateTimer((math.max(self.DefuseTime - v4, 0)))
                        if not v7 and 1 <= self.DefuseProgress and not self.HasSentDefuseRequest and v3 then
                            self.HasSentDefuseRequest = true
                            Remotes.C4.Defused.Send()
                            return
                        end
                        return
                    end
                    notifyTutorialDefuseCancelled(self, "Stand still next to the bomb until the defuse finishes")
                    v4 = self
                    if v5 and v5:GetAttribute("Defused") == true then
                        v4:FinishDefuse(true)
                        return
                    end
                    v4:CancelDefuse(true)
                    return
                end
            end
            v4 = (workspace:GetServerTimeNow()) - self.DefuseStartTime
            self.DefuseProgress = math.min(v4 / self.DefuseTime, 1)
            self:UpdateProgressBar(self.DefuseProgress)
            self:UpdateTimer((math.max(self.DefuseTime - v4, 0)))
            if not v7 and 1 <= self.DefuseProgress and not self.HasSentDefuseRequest and v3 then
                self.HasSentDefuseRequest = true
                Remotes.C4.Defused.Send()
                return
            end
            return
        end
    end), "Disconnect", "ProgressConnection")
    if not Attribute or Player == LocalPlayer then
        u102 = u102 + 1
        self.DefuseSessionId = u102
        Remotes.C4.StartDefuse.Send({SessionId = self.DefuseSessionId})
    end
    self.DefuseStarted:Fire()
end

function u0:CancelDefuse(a2) -- Line: 343
    -- upvalues: LocalPlayer (val), SpectateController (val), u108 (ref), Remotes (val)
    if not self.IsDefusing then
        return
    end
    local Attribute = LocalPlayer:GetAttribute("IsSpectating")
    local v1 = SpectateController.GetCurrentSpectateInstance()
    local v2 = Attribute and v1 and self.PlayerName ~= LocalPlayer.Name
    self.IsDefusing = false
    self.IsFinished = true
    if not v2 then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", nil)
    end
    if u108 == self then
        u108 = nil
    end
    self:UpdateProgressBar(0)
    if self.Frame then
        self.Frame.Visible = false
    end
    if not a2 and not v2 then
        Remotes.C4.CancelDefuse.Send({SessionId = self.DefuseSessionId})
    end
    self.DefuseCancelled:Fire()
    task.defer(function() -- Line: 377 -- upvalues: self (val)
        self:Destroy()
    end)
end

function u0:FinishDefuse(a2) -- Line: 382
    -- upvalues: LocalPlayer (val), SpectateController (val), u108 (ref), Remotes (val)
    if self.IsDefusing and not self.IsFinished then
        local Attribute = LocalPlayer:GetAttribute("IsSpectating")
        local v1 = SpectateController.GetCurrentSpectateInstance()
        local v2 = Attribute and v1 and self.PlayerName ~= LocalPlayer.Name
        self.IsFinished = true
        self.IsDefusing = false
        if not v2 then
            LocalPlayer:SetAttribute("IsLocallyDefusingBomb", nil)
        end
        if u108 == self then
            u108 = nil
        end
        if not a2 and not v2 then
            Remotes.C4.Defused.Send()
        end
        self.DefuseFinished:Fire()

        local function destroy() -- Line: 410 -- upvalues: self (val)
            self:Destroy()
        end

        if a2 then
            task.defer(destroy)
            return
        end
        task.delay(0.5, destroy)
        return
    end
end

function u0.new(a1) -- Line: 423 -- upvalues: u0 (val), Janitor (val), Signal (val)
    local v1 = setmetatable({}, u0)
    v1.Janitor = Janitor.new()
    v1.Frame = a1
    v1.DefuseTime = 10
    v1.HasDefuseKit = false
    v1.DefuseStartTime = 0
    v1.DefuseProgress = 0
    v1.IsDefusing = false
    v1.IsFinished = false
    v1.HasSentDefuseRequest = false
    v1.HasReceivedServerStartAck = false
    v1.PlayerName = ""
    v1.DefuseCancelled = v1.Janitor:Add((Signal.new()))
    v1.DefuseFinished = v1.Janitor:Add((Signal.new()))
    v1.DefuseStarted = v1.Janitor:Add((Signal.new()))
    if v1.Frame then
        v1.Frame.Visible = false
    end
    v1:InitializeProgressBar()
    return v1
end

function u0:Destroy() -- Line: 459 -- upvalues: u108 (ref), LocalPlayer (val)
    local v1 = false
    if u108 ~= nil then
        v1 = u108 ~= self
    end
    if self.PlayerName == LocalPlayer.Name and not v1 then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", nil)
    end
    if u108 == self then
        u108 = nil
    end
    if self.Frame and not v1 then
        self.Frame.Visible = false
    end
    self.Janitor:Destroy()
end

function u0.Initialize(a1, a2) -- Line: 483
    -- upvalues: u107 (ref), Router (val), u99 (ref), IsTutorialMode (val), LocalPlayer (val), u100 (ref)
    -- upvalues: CollectionService (val), u108 (ref), u0 (val), notifyTutorialDefuseCancelled (val)
    -- upvalues: SpectateController (val)
    u107 = a2
    Router.observerRouter("Start Defuse Bomb", function() -- Line: 487
        -- upvalues: u99 (upval), IsTutorialMode (upval), LocalPlayer (upval), u100 (upval), Router (upval)
        -- upvalues: CollectionService (upval), u108 (upval), u0 (upval), u107 (upval)
        local v1
        if u99 and (workspace:GetServerTimeNow()) < u99 then
            return nil
        end
        if IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") ~= "DefuseB" then
            if 2 < os.clock() - u100 then
                u100 = os.clock()
                Router.broadcastRouter("CreateNotification", "Not Yet", "Eliminate all the Terrorists before defusing the bomb", 2.5)
            end
            return nil
        end
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
        if v1 then
            return nil
        end
        if not u108 then
            u108 = u0.new(u107)
        end
        u108:StartDefuse()
        return nil
    end)
    Router.observerRouter("Cancel Defuse Bomb", function() -- Line: 522 -- upvalues: u108 (upval), notifyTutorialDefuseCancelled (upval)
        local v1 = u108
        if v1 then
            notifyTutorialDefuseCancelled(v1)
            v1:CancelDefuse(false)
            u108 = nil
        end
        return nil
    end)
    local u12 = nil

    local function updateSpectateDefuse() -- Line: 536
        -- upvalues: LocalPlayer (upval), SpectateController (upval), CollectionService (upval), u108 (upval)
        -- upvalues: u0 (upval), u107 (upval)
        local Attribute = LocalPlayer:GetAttribute("IsSpectating")
        local v1 = SpectateController.GetCurrentSpectateInstance()
        if Attribute and v1 then
            local v2
            local Player = v1.Player
            local Attribute_2 = Player:GetAttribute("IsDefusingBomb")
            local v3 = CollectionService:GetTagged("Bomb")[1]
            if v3 then
                v2 = true
                if v3:GetAttribute("Defused") ~= true then
                    v2 = true
                    if v3:GetAttribute("Exploding") ~= true then
                        v2 = v3:GetAttribute("Exploded") == true
                    end
                end
            else
                v2 = false
            end
            if v2 then
                if u108 then
                    v2 = u108
                    if not v3 or v3:GetAttribute("Defused") ~= true then
                        v2:CancelDefuse(true)
                    else
                        v2:FinishDefuse(true)
                    end
                    u108 = nil
                end
                return
            end
            if Attribute_2 then
                if not u108 then
                    u108 = u0.new(u107)
                end
                u108:StartDefuse(Player)
                return
            end
            if not u108 then
                return
            end
            u108:CancelDefuse(false)
            u108 = nil
            return
        end
        if u108 and not LocalPlayer:GetAttribute("IsDefusingBomb") then
            u108:CancelDefuse(false)
            u108 = nil
        end
    end

    ;(LocalPlayer:GetAttributeChangedSignal("IsSpectating")):Connect(updateSpectateDefuse)
    SpectateController.ListenToSpectate:Connect(function() -- Line: 580 -- upvalues: u12 (ref), SpectateController (upval), updateSpectateDefuse (val)
        if u12 then
            u12:Disconnect()
            u12 = nil
        end
        local v1 = SpectateController.GetCurrentSpectateInstance()
        if v1 then
            u12 = (v1.Player:GetAttributeChangedSignal("IsDefusingBomb")):Connect(updateSpectateDefuse)
            updateSpectateDefuse()
        end
    end)
    task.wait(0.1)
    if u12 then
        u12:Disconnect()
    end
    local v1 = SpectateController.GetCurrentSpectateInstance()
    if v1 then
        local v2 = (v1.Player:GetAttributeChangedSignal("IsDefusingBomb")):Connect(updateSpectateDefuse)
        updateSpectateDefuse()
    end
end

function u0.SetDefuseBlockedUntil(a1) -- Line: 602 -- upvalues: u99 (ref) -- types: a1: number
    u99 = a1
end

return u0