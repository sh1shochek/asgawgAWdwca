-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CharacterAnimator = require(script.Classes.CharacterAnimator);
local Viewmodel = require(script.Classes.Viewmodel);

function v1.new(p2: userdata, p3: string, p4: string, p5: number, p6: string, p7: string, p8: number, p9: any, p10: any, p11: string?, p12: any, p13: table, p14: userdata?) -- Line: 29
    -- upvalues: Janitor (copy), GetWeaponProperties (copy), CharacterAnimator (copy), Viewmodel (copy), Skins (copy)
    debug.profilebegin("WeaponComponent.new");
    local u15 = {};
    debug.profilebegin("WeaponComponent.new.Janitor");
    u15.Janitor = Janitor.new();
    u15.IsDestroyed = false;
    debug.profileend();
    u15.OriginalOwner = p11;
    u15.Identifier = p3;
    u15.StatTrack = p9;
    u15.Stickers = p13;
    u15.NameTag = p10;
    u15.Player = p2;
    u15.Character = p14;
    u15.Float = p8;
    u15.Name = p6;
    u15.Charm = p12;
    u15.Skin = p7;
    u15.Slot = p5;
    u15._id = p4;
    debug.profilebegin("WeaponComponent.new.GetWeaponProperties");
    u15.Properties = GetWeaponProperties(p6);
    debug.profileend();
    debug.profilebegin("WeaponComponent.new.CharacterAnimator");
    u15.CharacterAnimator = CharacterAnimator.new(u15.Player, p6, p14);
    debug.profileend();
    debug.profilebegin("WeaponComponent.new.Viewmodel");
    local v16 = Viewmodel.claim(u15, p6, p7);
    local v17, v18;

    if v16 then
        v17 = v16;
        v18 = true;
    else
        v18, v17 = pcall(Viewmodel.new, u15, p6, p7);
    end;

    debug.profileend();

    if not v18 then
        debug.profileend();
        error(v17, 2);
    end;

    u15.Viewmodel = v17;
    debug.profilebegin("WeaponComponent.new.CleanupCallbacks");
    u15.Janitor:Add(function() -- Line: 92
        -- upvalues: u15 (copy)
        if u15.CharacterAnimator then
            u15.CharacterAnimator:destroy();
            u15.CharacterAnimator = nil;
        end;
    end);
    u15.Janitor:Add(function() -- Line: 100
        -- upvalues: u15 (copy)
        if u15.Viewmodel then
            u15.Viewmodel:release();
            u15.Viewmodel = nil;
        end;
    end);
    debug.profileend();

    function u15.updateStatTrackCounter(p19, p20) -- Line: 109
        -- upvalues: Skins (ref)
        p19.StatTrack = p20;

        if not p19.StatTrack then
            return;
        end;

        local KillTrak = p19.Viewmodel.Model:FindFirstChild("KillTrak", true);

        if KillTrak then
            KillTrak.Screen.SurfaceGui.TextLabel.Text = Skins.GetKillTrackValue(p20, p19.Name);
        end;
    end;

    if v16 and p9 then
        u15:updateStatTrackCounter(p9);
    end;

    debug.profileend();

    return u15;
end;

function v1.destroy(p21) -- Line: 133
    debug.profilebegin("WeaponComponent.destroy");

    if p21.CharacterAnimator then
        p21.CharacterAnimator:destroy();
        p21.CharacterAnimator = nil;
    end;

    if p21.Viewmodel then
        p21.Viewmodel:release();
        p21.Viewmodel = nil;
    end;

    if p21.Janitor then
        p21.Janitor:Destroy();
        p21.Janitor = nil;
    end;

    p21.updateStatTrackCounter = nil;
    p21.OriginalOwner = nil;
    p21.Properties = nil;
    p21.Identifier = nil;
    p21.StatTrack = nil;
    p21.Stickers = nil;
    p21.NameTag = nil;
    p21.Player = nil;
    p21.Character = nil;
    p21.Float = nil;
    p21.Name = nil;
    p21.Charm = nil;
    p21.Skin = nil;
    p21.Slot = nil;
    p21._id = nil;
    debug.profileend();
end;

return v1;