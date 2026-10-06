-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CharacterAnimator = require(ReplicatedStorage.Classes.Character.Classes.CharacterAnimator);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u1 = {};
u1.__index = u1;

local function bind(p2: any, p3: userdata?) -- Line: 30
    -- upvalues: CharacterAnimator (copy), GetWeaponProperties (copy)
    if p2._animator then
        p2._animator:destroy();
        p2._animator = nil;
        p2.Animations = {};
    end;

    if p2.IsDestroyed or not p3 then
        return;
    end;

    local v4 = CharacterAnimator.new(p3, {
        SkipBaseAnimations = true
    });
    v4.Player = p2.Player;
    v4.WeaponName = p2.Weapon;
    local v5 = GetWeaponProperties(p2.Weapon);

    if v5 then
        v5 = v5.CharacterAnimations;
    end;

    if v5 then
        for _, child in ipairs(v5:GetChildren()) do
            if child:IsA("Animation") then
                v4:register(child.Name, child);
                v4.WeaponAnimationNames[child.Name] = true;
            end;
        end;
    end;

    p2._animator = v4;
    p2.Animations = v4.Animations;
end;

function u1.getAnimation(p6: any, p7: string) -- Line: 63
    return p6.Animations[p7];
end;

function u1.play(p8: any, p9: string, ...) -- Line: 67
    local _animator = p8._animator;

    if _animator then
        return _animator:play(p9, ...);
    end;

    return nil;
end;

function u1.stop(p10: any, p11: string, ...) -- Line: 72
    local _animator = p10._animator;

    if _animator then
        _animator:stop(p11, ...);
    end;
end;

function u1.stopAnimations(p12: any, p13: number?) -- Line: 79
    local _animator = p12._animator;

    if _animator then
        _animator:stopAnimations(p13);
    end;
end;

function u1.adjustAnimationSpeed(p14: any, p15: string, p16: number) -- Line: 86
    local _animator = p14._animator;

    if _animator then
        _animator:adjustAnimationSpeed(p15, p16);
    end;
end;

function u1.new(p17: userdata, p18: string, p19: userdata?) -- Line: 96
    -- upvalues: u1 (copy), Janitor (copy), bind (copy), CharacterResolver (copy)
    local u20 = setmetatable({}, u1);
    u20.Janitor = Janitor.new();
    u20.IsDestroyed = false;
    u20.Player = p17;
    u20.Weapon = p18;
    u20.Animations = {};

    if p19 then
        bind(u20, p19);

        return u20;
    end;

    u20.Janitor:Add(CharacterResolver.observeCharacter(p17, function(p21) -- Line: 108
        -- upvalues: bind (ref), u20 (copy)
        bind(u20, p21);
    end));

    return u20;
end;

function u1.destroy(p22) -- Line: 119
    if p22.IsDestroyed then
        return;
    end;

    p22.IsDestroyed = true;

    if p22._animator then
        p22._animator:destroy();
        p22._animator = nil;
    end;

    p22.Animations = {};
    p22.Janitor:Destroy();
end;

return u1;