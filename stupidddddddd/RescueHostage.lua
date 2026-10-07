-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.RescueHostage
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.RescueHostage
-- Decompile time: 5.55 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local RadialProgress = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.DefuseBomb.RadialProgress)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Signal = require(ReplicatedStorage.Packages.Signal)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local LocalPlayer = Players.LocalPlayer
local u66 = Vector2.new(0.85, 0.85)
local u67 = nil
local u68 = nil

local function isSpectatingOtherRescue(a1) -- Line: 84 -- upvalues: LocalPlayer (val), SpectateController (val)
    local Attribute = LocalPlayer:GetAttribute("IsSpectating")
    local v1 = SpectateController.GetCurrentSpectateInstance()
    return Attribute and v1 and a1.PlayerName ~= LocalPlayer.Name
end

function u0.InitializeProgressBar(a1) -- Line: 93 -- upvalues: RadialProgress (val)
    RadialProgress.Initialize(a1, "RescueHostage")
end

function u0.UpdateProgressBar(a1, a2) -- Line: 97
    -- upvalues: RadialProgress (val), u66 (val)
    RadialProgress.Update(a1, a2, "Hostage", u66)
end

function u0:UpdateTimer(a2) -- Line: 101 -- upvalues: RadialProgress (val) -- types: self: table, a2: number
    RadialProgress.SetTimer(self.Frame, a2)
end

function u0:UpdateTitle() -- Line: 105 -- upvalues: RadialProgress (val)
    RadialProgress.SetTitle(
        self.Frame,
        string.format("%s is rescuing the hostage %s a kit.", self.PlayerName, if not self.HasRescueKit then "without" else "with")
    )
end

function u0:StartRescue(a2) -- Line: 112
    -- upvalues: LocalPlayer (val), SpectateController (val), Participants (val), RunServiceController (val)
    -- upvalues: Remotes (val)
    if self.IsRescuing then
        return
    end
    local Attribute = LocalPlayer:GetAttribute("IsSpectating")
    local v1 = SpectateController.GetCurrentSpectateInstance()
    local Player = a2 or Attribute and v1 and v1.Player or LocalPlayer
    self.HasRescueKit = Player:GetAttribute("HasRescueKit")
    self.PlayerName = Participants.Name(Player)
    self.RescueTime = if not self.HasRescueKit then 4 else 1
    local Attribute_2 = Player:GetAttribute("RescueStartTime")
    if not Attribute_2 then
        self.RescueStartTime = tick()
    else
        local v2
        if Attribute then
            v2 = tick()
            if not (Attribute_2 <= v2) or not (v2 - Attribute_2 <= self.RescueTime) then
                self.RescueStartTime = v2
            else
                self.RescueStartTime = Attribute_2
            end
        elseif Player == LocalPlayer then
            self.RescueStartTime = tick()
        else
            v2 = tick()
            if not (Attribute_2 <= v2) or not (v2 - Attribute_2 <= self.RescueTime) then
                self.RescueStartTime = v2
            else
                self.RescueStartTime = Attribute_2
            end
        end
    end
    self.RescueProgress = 0
    self.IsRescuing = true
    if self.Frame then
        self.Frame.Visible = true
    end
    self:UpdateProgressBar(0)
    self:UpdateTimer(self.RescueTime)
    self:UpdateTitle()
    self.Janitor:Add(RunServiceController.BindToHeartbeat("UI.RescueHostage.UpdateProgress", function() -- Line: 150 -- upvalues: self (val), LocalPlayer (upval), SpectateController (upval)
        if self.IsRescuing and not self.IsFinished then
            local Attribute = LocalPlayer:GetAttribute("IsSpectating")
            local v1 = SpectateController.GetCurrentSpectateInstance()
            local v2 = Attribute and v1 and self.PlayerName ~= LocalPlayer.Name
            if v2 and v1 then
                local Player = v1.Player
                if not Player:GetAttribute("IsRescuingHostage") then
                    if 0.95 <= self.RescueProgress then
                        self:FinishRescue()
                        return
                    end
                    self:CancelRescue()
                    return
                end
                local Attribute_2 = Player:GetAttribute("RescueStartTime")
                if Attribute_2 then
                    local v3 = tick()
                    if Attribute_2 < self.RescueStartTime
                        and Attribute_2 <= v3
                        and v3 - Attribute_2 <= self.RescueTime then
                        self.RescueStartTime = Attribute_2
                    end
                end
            end
            local v4 = tick() - self.RescueStartTime
            self.RescueProgress = math.min(v4 / self.RescueTime, 1)
            self:UpdateProgressBar(self.RescueProgress)
            self:UpdateTimer((math.max(self.RescueTime - v4, 0)))
            if 1 <= self.RescueProgress and not self.IsFinished and not v2 then
                self:FinishRescue()
                return
            end
            return
        end
    end), "Disconnect", "ProgressConnection")
    if not Attribute or Player == LocalPlayer then
        Remotes.Hostage.StartRescue.Send()
    end
    self.RescueStarted:Fire()
end

function u0:CancelRescue() -- Line: 204 -- upvalues: LocalPlayer (val), SpectateController (val), Remotes (val)
    if not self.IsRescuing then
        return
    end
    local Attribute = LocalPlayer:GetAttribute("IsSpectating")
    local v1 = SpectateController.GetCurrentSpectateInstance()
    local v2 = Attribute and v1 and self.PlayerName ~= LocalPlayer.Name
    self.IsRescuing = false
    self.IsFinished = true
    self:UpdateProgressBar(0)
    if self.Frame then
        self.Frame.Visible = false
    end
    if not v2 then
        Remotes.Hostage.CancelRescue.Send()
    end
    self.RescueCancelled:Fire()
    task.defer(function() -- Line: 227 -- upvalues: self (val)
        self:Destroy()
    end)
end

function u0:FinishRescue() -- Line: 232 -- upvalues: LocalPlayer (val), SpectateController (val), Remotes (val)
    if self.IsRescuing and not self.IsFinished then
        local Attribute = LocalPlayer:GetAttribute("IsSpectating")
        local v1 = SpectateController.GetCurrentSpectateInstance()
        local v2 = Attribute and v1 and self.PlayerName ~= LocalPlayer.Name
        self.IsFinished = true
        self.IsRescuing = false
        if not v2 then
            Remotes.Hostage.PickedUp.Send()
        end
        self.RescueFinished:Fire()
        task.delay(0.5, function() -- Line: 251 -- upvalues: self (val)
            self:Destroy()
        end)
        return
    end
end

function u0.new(a1) -- Line: 259 -- upvalues: u0 (val), Janitor (val), Signal (val)
    local v1 = setmetatable({}, u0)
    v1.Janitor = Janitor.new()
    v1.Frame = a1
    v1.RescueTime = 4
    v1.HasRescueKit = false
    v1.RescueStartTime = 0
    v1.RescueProgress = 0
    v1.IsRescuing = false
    v1.IsFinished = false
    v1.PlayerName = ""
    v1.RescueCancelled = v1.Janitor:Add((Signal.new()))
    v1.RescueFinished = v1.Janitor:Add((Signal.new()))
    v1.RescueStarted = v1.Janitor:Add((Signal.new()))
    if v1.Frame then
        v1.Frame.Visible = false
    end
    v1:InitializeProgressBar()
    return v1
end

function u0:Destroy() -- Line: 293 -- upvalues: u68 (ref)
    if u68 == self then
        u68 = nil
    end
    if self.Frame then
        self.Frame.Visible = false
    end
    self.Janitor:Destroy()
end

function u0.Initialize(a1, a2) -- Line: 311
    -- upvalues: u67 (ref), GameState (val), u68 (ref), Router (val), u0 (val), LocalPlayer (val)
    -- upvalues: SpectateController (val)
    u67 = a2
    GameState.ListenToState(function(a1, a2) -- Line: 315 -- upvalues: u68 (upval)
        if a2 == "Buy Period" then
            if u68 then
                u68:Destroy()
                u68 = nil
            end
        elseif a2 == "Warmup" and u68 then
            u68:Destroy()
            u68 = nil
        end
    end)
    Router.observerRouter("Start Rescue Hostage", function() -- Line: 325 -- upvalues: u68 (upval), u0 (upval), u67 (upval)
        if not u68 then
            u68 = u0.new(u67)
        end
        u68:StartRescue()
        return nil
    end)
    Router.observerRouter("Cancel Rescue Hostage", function() -- Line: 335 -- upvalues: u68 (upval)
        if u68 then
            u68:CancelRescue()
            u68 = nil
        end
        return nil
    end)
    local u16 = nil

    local function updateSpectateRescue() -- Line: 347
        -- upvalues: LocalPlayer (upval), SpectateController (upval), u68 (upval), u0 (upval), u67 (upval)
        local Attribute = LocalPlayer:GetAttribute("IsSpectating")
        local v1 = SpectateController.GetCurrentSpectateInstance()
        if Attribute and v1 then
            local Player = v1.Player
            if Player:GetAttribute("IsRescuingHostage") then
                if not u68 then
                    u68 = u0.new(u67)
                end
                u68:StartRescue(Player)
                return
            end
            if not u68 then
                return
            end
            u68:CancelRescue()
            u68 = nil
            return
        end
        if u68 and not LocalPlayer:GetAttribute("IsRescuingHostage") then
            u68:CancelRescue()
            u68 = nil
        end
    end

    ;(LocalPlayer:GetAttributeChangedSignal("IsSpectating")):Connect(updateSpectateRescue)
    SpectateController.ListenToSpectate:Connect(function() -- Line: 381 -- upvalues: u16 (ref), SpectateController (upval), updateSpectateRescue (val)
        if u16 then
            u16:Disconnect()
            u16 = nil
        end
        local v1 = SpectateController.GetCurrentSpectateInstance()
        if v1 then
            u16 = (v1.Player:GetAttributeChangedSignal("IsRescuingHostage")):Connect(updateSpectateRescue)
            updateSpectateRescue()
        end
    end)
    task.wait(0.1)
    if u16 then
        u16:Disconnect()
    end
    local v1 = SpectateController.GetCurrentSpectateInstance()
    if v1 then
        local v2 = (v1.Player:GetAttributeChangedSignal("IsRescuingHostage")):Connect(updateSpectateRescue)
        updateSpectateRescue()
    end
end

return u0