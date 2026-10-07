-- ReplicatedStorage.Classes.WeaponComponent
-- Script path: ReplicatedStorage.Classes.WeaponComponent
-- Decompile time: 1.26 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local CharacterAnimator = require(script.Classes.CharacterAnimator)
local Viewmodel = require(script.Classes.Viewmodel)

function v1.new(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) -- Line: 29
    -- upvalues: Janitor (val), GetWeaponProperties (val), CharacterAnimator (val), Viewmodel (val), Skins (val)
    debug.profilebegin("WeaponComponent.new")
    local u16 = {}
    debug.profilebegin("WeaponComponent.new.Janitor")
    u16.Janitor = Janitor.new()
    u16.IsDestroyed = false
    debug.profileend()
    u16.OriginalOwner = a10
    u16.Identifier = a2
    u16.StatTrack = a8
    u16.Stickers = a12
    u16.NameTag = a9
    u16.Player = a1
    u16.Character = a13
    u16.Float = a7
    u16.Name = a5
    u16.Charm = a11
    u16.Skin = a6
    u16.Slot = a4
    u16._id = a3
    debug.profilebegin("WeaponComponent.new.GetWeaponProperties")
    u16.Properties = GetWeaponProperties(a5)
    debug.profileend()
    debug.profilebegin("WeaponComponent.new.CharacterAnimator")
    u16.CharacterAnimator = CharacterAnimator.new(u16.Player, a5, a13)
    debug.profileend()
    debug.profilebegin("WeaponComponent.new.Viewmodel")
    local v1 = Viewmodel.claim(u16, a5, a6)
    local v2 = true
    local v3 = v1
    if not v1 then
        local success, result = pcall(Viewmodel.new, u16, a5, a6)
        v2 = success
        v3 = result
    end
    debug.profileend()
    if not v2 then
        debug.profileend()
        error(v3, 2)
    end
    u16.Viewmodel = v3
    debug.profilebegin("WeaponComponent.new.CleanupCallbacks")
    u16.Janitor:Add(function() -- Line: 92 -- upvalues: u16 (val)
        if u16.CharacterAnimator then
            u16.CharacterAnimator:destroy()
            u16.CharacterAnimator = nil
        end
    end)
    u16.Janitor:Add(function() -- Line: 100 -- upvalues: u16 (val)
        if u16.Viewmodel then
            u16.Viewmodel:release()
            u16.Viewmodel = nil
        end
    end)
    debug.profileend()

    function u16:updateStatTrackCounter(a2) -- Line: 109 -- upvalues: Skins (upval)
        self.StatTrack = a2
        if not self.StatTrack then
            return
        end
        local KillTrak = self.Viewmodel.Model:FindFirstChild("KillTrak", true)
        if KillTrak then
            KillTrak.Screen.SurfaceGui.TextLabel.Text = Skins.GetKillTrackValue(a2, self.Name)
        end
    end

    if v1 and a8 then
        u16:updateStatTrackCounter(a8)
    end
    debug.profileend()
    return u16
end

function v1:destroy() -- Line: 133
    debug.profilebegin("WeaponComponent.destroy")
    if self.CharacterAnimator then
        self.CharacterAnimator:destroy()
        self.CharacterAnimator = nil
    end
    if self.Viewmodel then
        self.Viewmodel:release()
        self.Viewmodel = nil
    end
    if self.Janitor then
        self.Janitor:Destroy()
        self.Janitor = nil
    end
    self.updateStatTrackCounter = nil
    self.OriginalOwner = nil
    self.Properties = nil
    self.Identifier = nil
    self.StatTrack = nil
    self.Stickers = nil
    self.NameTag = nil
    self.Player = nil
    self.Character = nil
    self.Float = nil
    self.Name = nil
    self.Charm = nil
    self.Skin = nil
    self.Slot = nil
    self._id = nil
    debug.profileend()
end

return v1