-- ReplicatedStorage.Components.Grenade
-- Script path: ReplicatedStorage.Components.Grenade
-- Decompile time: 8.16 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
require(ReplicatedStorage.Database.Custom.Types)
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent)
local InputController = require(ReplicatedStorage.Controllers.InputController)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity)
local ReplicateCharacterAction = require(ReplicatedStorage.Components.Common.ReplicateCharacterAction)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local CurrentCamera = workspace.CurrentCamera
local u56 = {"StartThrow", "ThrowIdle"}

local function isCompetitiveFreezeTime() -- Line: 80 -- upvalues: GameState (val)
    local v1 = false
    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        v1 = GameState.GetState() == "Buy Period"
    end
    return v1
end

local function stopPlayingTracks(a1, a2) -- Line: 86 -- types: a2: boolean
    local v1, v2 = a2, a1
    for k, v in pairs(a1.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            if not v1 or v.Name ~= "Equip" then
                v2:stop(k)
            end
        end
    end
end

local function isOnThrowCooldown(a1) -- Line: 94
    local v1 = false
    if 0 < a1.LastThrowTime then
        v1 = tick() - a1.LastThrowTime < 0.7
    end
    return v1
end

function u0:stopAllAnimations() -- Line: 101 -- upvalues: stopPlayingTracks (val)
    if self.CharacterAnimator and self.Viewmodel and self.Viewmodel.Animation then
        stopPlayingTracks(self.CharacterAnimator, false)
        stopPlayingTracks(self.Viewmodel.Animation, false)
        return
    end
end

function u0:StartThrow() -- Line: 112
    -- upvalues: GameState (val), CharacterResolver (val), CurrentCamera (val), stopPlayingTracks (val)
    -- upvalues: ReplicateCharacterAction (val)
    if not self.IsDestroyed then
        local v1 = false
        if workspace:GetAttribute("ServerGamemode") == "Competitive" then
            v1 = GameState.GetState() == "Buy Period"
        end
        if not v1 then
            if 0 < self.EquipTime and tick() - self.EquipTime < 0.7 then
                return
            end
            v1 = false
            if 0 < self.LastThrowTime then
                v1 = tick() - self.LastThrowTime < 0.7
            end
            if not v1 then
                if self.ThrowStarted and not self.ThrowFinished then
                    return
                end
                if self.ThrowFinished then
                    self.ThrowFinished = false
                    self.ThrowStarted = false
                    self.Janitor:Remove("ThrowGrenadeFinished")
                    self.Janitor:Remove("ThrowGrenadeStoppedFallback")
                end
                v1 = CharacterResolver.getLocalCharacter()
                if v1 and v1:GetAttribute("Dead") then
                    return
                end
                self.ThrowStarted = true
                if self.Viewmodel and not self.Viewmodel.IsDestroyed and self.Viewmodel.Model then
                    if self.Viewmodel.Model.Parent ~= CurrentCamera then
                        if not self.Viewmodel.equip then
                            return
                        end
                        self.Viewmodel:equip(false)
                    end
                    if self.Viewmodel.Hidden then
                        self.Viewmodel:unhide()
                    end
                    local v2 = false
                    if 0 < self.LastThrowTime then
                        v2 = tick() - self.LastThrowTime < 0.7
                    end
                    if v2 then
                        self.ThrowStarted = false
                        return
                    end
                    if self.Viewmodel.IsDestroyed then
                        return
                    end
                    local Equip = self.Viewmodel.Animation.Animations.Equip
                    if not Equip or not Equip.IsPlaying then
                        self:stopAllAnimations()
                    else
                        stopPlayingTracks(self.Viewmodel.Animation, true)
                        stopPlayingTracks(self.CharacterAnimator, true)
                    end
                    self.CharacterAnimator:play("StartThrow")
                    self.CharacterAnimator:play("ThrowIdle")
                    ReplicateCharacterAction("StartThrow")
                    if self.Viewmodel
                        and not self.Viewmodel.IsDestroyed
                        and self.Viewmodel.Model
                        and self.Viewmodel.Model.Parent == CurrentCamera then
                        local v3 = self.Viewmodel.Animation:play("ThrowIdle")
                        self.Viewmodel.Animation:play("StartThrow")
                        if v3 then
                            v3.Looped = true
                        end
                    end
                    return
                end
                return
            end
        end
    end
end

function u0.Throw(a1, a2) -- Line: 189
    -- upvalues: GameState (val), CharacterResolver (val), CurrentCamera (val), RunService (val)
    -- upvalues: stopPlayingTracks (val), u56 (val), ReplicateCharacterAction (val), Router (val)
    if a1.ThrowFinished then
        return
    end
    local v1 = false
    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        v1 = GameState.GetState() == "Buy Period"
    end
    if v1 then
        if a1.ThrowStarted and not a1.ThrowFinished then
            a1:Cancel()
        end
        return
    end
    v1 = CharacterResolver.getLocalCharacter()
    if v1 and v1:GetAttribute("Dead") then
        return
    end
    if a1.Viewmodel and not a1.Viewmodel.IsDestroyed and a1.Viewmodel.Model then
        local v2, v3
        if a1.Viewmodel.Model.Parent ~= CurrentCamera then
            if not a1.Viewmodel.equip then
                a1.ThrowStarted = false
                return
            else
                a1.Viewmodel:equip(false)
                RunService.Heartbeat:Wait()
                if a1.Viewmodel.Model.Parent ~= CurrentCamera then
                    a1.ThrowStarted = false
                    return
                end
            end
        end
        if a1.Viewmodel.Hidden then
            a1.Viewmodel:unhide()
        end
        if not a1.Viewmodel.Animation then
            a1.ThrowStarted = false
            return
        end
        a1.Janitor:Remove("ThrowGrenadeFinished")
        a1.Janitor:Remove("ThrowGrenadeStoppedFallback")
        local Equip = a1.Viewmodel.Animation.Animations.Equip
        if not Equip or not Equip.IsPlaying then
            v2 = {a1.Viewmodel.Animation, a1.CharacterAnimator}
            v3 = nil
            local v4 = nil
            for i, j in v2, v3, v4 do
                for k, n in u56 do
                    if j.Animations[n] then
                        j:stop(n)
                    end
                end
            end
        else
            a1.Viewmodel.Animation:stop("Equip")
            a1.CharacterAnimator:stop("Equip")
            stopPlayingTracks(a1.Viewmodel.Animation, false)
            stopPlayingTracks(a1.CharacterAnimator, false)
            RunService.Heartbeat:Wait()
        end
        if a1.Viewmodel and not a1.Viewmodel.IsDestroyed and a1.Viewmodel.Animation then
            v2 = a1.Viewmodel.Animation:play(a2)
            if not v2 then
                a1.ThrowStarted = false
                return
            end
            v3 = tick()
            while v2.Length == 0 do
                if not (tick() - v3 < 0.5) then
                    break
                end
                RunService.Heartbeat:Wait()
            end
            if not a1.IsDestroyed and a1.Viewmodel and not a1.Viewmodel.IsDestroyed then
                a1.CharacterAnimator:play("Throw")
                ReplicateCharacterAction("Throw")
                a1.ThrowCompleted = false

                local function completeThrow() -- Line: 287 -- upvalues: a1 (val), Router (upval), a2 (val)
                    if a1.ThrowCompleted then
                        return
                    end
                    a1.ThrowCompleted = true
                    if not a1.IsDestroyed and a1.Identifier then
                        a1.ThrowFinished = true
                        a1.ThrowStarted = false
                        a1.LastThrowTime = tick()
                        if Router.broadcastRouter("PredictGrenadeThrow", a1.Identifier, a2) ~= true then
                            a1.ThrowFinished = false
                            a1.ThrowCompleted = false
                            warn("[Grenade] Could not queue ordered grenade transition")
                        end
                        return
                    end
                end

                if not v2.IsPlaying then
                    a1.ThrowStarted = false
                    return
                end

                local function fallbackThrow() -- Line: 315 -- upvalues: a1 (val), completeThrow (val)
                    if not a1.ThrowCompleted and not a1.IsDestroyed and a1.ThrowStarted and not a1.ThrowFinished then
                        completeThrow()
                    end
                end

                a1.Janitor:Add((v2:GetMarkerReachedSignal("Throw")):Once(completeThrow), "Disconnect", "ThrowGrenadeFinished")
                a1.Janitor:Add(v2.Stopped:Once(function() -- Line: 325 -- upvalues: a1 (val), completeThrow (val)
                    task.delay(0.05, function() -- Line: 326 -- upvalues: a1 (upval), completeThrow (upval)
                        if not a1.ThrowCompleted and not a1.IsDestroyed then
                            completeThrow()
                        end
                    end)
                end), "Disconnect", "ThrowGrenadeStoppedFallback")
                if 0 < v2.Length then
                    local u209 = task.delay(v2.Length * 0.7, fallbackThrow)
                    a1.Janitor:Add(function() -- Line: 336 -- upvalues: u209 (val)
                        task.cancel(u209)
                    end, false, "ThrowGrenadeDelayFallback2")
                end
                local u221 = task.delay(2, fallbackThrow)
                a1.Janitor:Add(function() -- Line: 343 -- upvalues: u221 (val)
                    task.cancel(u221)
                end, false, "ThrowGrenadeDelayFallback3")
                return
            end
            a1.ThrowStarted = false
            return
        end
        a1.ThrowStarted = false
        return
    end
    a1.ThrowStarted = false
end

function u0:Cancel() -- Line: 350 -- upvalues: ReplicateCharacterAction (val)
    if self.ThrowFinished then
        return
    end
    self.Janitor:Remove("ThrowGrenadeFinished")
    self.Janitor:Remove("ThrowGrenadeStoppedFallback")
    self.Janitor:Remove("ThrowGrenadeDelayFallback2")
    self.Janitor:Remove("ThrowGrenadeDelayFallback3")
    self.ThrowFinished = false
    self.ThrowStarted = false
    self.ThrowCompleted = false
    self:stopAllAnimations()
    ReplicateCharacterAction("CancelThrow")
end

function u0.inspect(a1) -- Line: 370 -- upvalues: ReplicateCharacterAction (val)
    if a1.IsInspecting then
        return
    end
    if a1.ThrowStarted and not a1.ThrowFinished then
        a1:Cancel()
    end
    a1.IsInspecting = true
    a1:stopAllAnimations()
    local v1 = a1.Viewmodel.Animation:play("Inspect")
    ReplicateCharacterAction("Inspect")
    task.delay(v1.Length, function() -- Line: 385 -- upvalues: a1 (val)
        a1.IsInspecting = false
    end)
end

function u0.reload(a1) end

function u0.drop(a1) -- Line: 396
    -- upvalues: GameState (val), Remotes (val), GetCharacterVelocity (val), CharacterResolver (val)
    -- upvalues: CurrentCamera (val)
    if workspace:GetAttribute("Gamemode") ~= "Deathmatch"
        and GameState.GetState() ~= "Warmup"
        and a1.Properties.Droppable then
        a1:unequip()
        Remotes.Inventory.DropWeapon.Send({
            CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
            Direction = CurrentCamera.CFrame.LookVector,
            Identifier = a1.Identifier,
        })
        return true
    end
    return false
end

function u0:equip() -- Line: 416 -- upvalues: GameState (val), InputController (val)
    self.EquipTime = tick()
    self.Janitor:Remove("EquipDelayThrow")
    self.Viewmodel.Animation:stopAnimations()
    self.CharacterAnimator:stopAnimations()
    self.ThrowStarted = false
    self.ThrowFinished = false
    self.ThrowCompleted = false
    self.CharacterAnimator:play("Idle")
    self.CharacterAnimator:play("Equip")
    self.Viewmodel:equip(false)
    local u38 = task.delay(0.7, function() -- Line: 428 -- upvalues: self (val), GameState (upval), InputController (upval)
        if self.IsDestroyed or GameState.GetState() == "Buy Period" then
            return
        end
        if InputController.isActionPressed("Fire", {Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2}) then
            self:StartThrow()
        end
    end)
    self.Janitor:Add(function() -- Line: 440 -- upvalues: u38 (val)
        task.cancel(u38)
    end, false, "EquipDelayThrow")
end

function u0:unequip() -- Line: 445
    self.Janitor:Remove("EquipDelayThrow")
    self.CharacterAnimator:stopAnimations()
    self.Viewmodel:unequip()
    self.IsInspecting = false
    if self.ThrowStarted and not self.ThrowFinished then
        self:Cancel()
    end
end

function u0.new(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) -- Line: 458
    -- upvalues: WeaponComponent (val), u0 (val)
    local v1 = WeaponComponent.new(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
    local v2 = setmetatable(v1, u0)
    v2.IsInspecting = false
    v2.ThrowStarted = false
    v2.ThrowFinished = false
    v2.ThrowCompleted = false
    v2.LastThrowTime = 0
    v2.EquipTime = 0
    return v2
end

function u0.destroy(a1) -- Line: 490 -- upvalues: WeaponComponent (val)
    if a1.IsDestroyed then
        return
    end
    a1.IsDestroyed = true
    if a1.Janitor then
        a1.Janitor:Destroy()
        a1.Janitor = nil
    end
    a1.ThrowFinished = nil
    a1.ThrowStarted = nil
    a1.ThrowCompleted = nil
    a1.IsInspecting = nil
    WeaponComponent.destroy(a1)
end

return u0