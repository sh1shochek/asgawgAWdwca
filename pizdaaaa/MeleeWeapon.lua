-- ReplicatedStorage.Shared.WeaponConstructor.Types.MeleeWeapon
-- Script path: ReplicatedStorage.Shared.WeaponConstructor.Types.MeleeWeapon
-- Decompile time: 3.94 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = game:GetService("RunService"):IsServer();
local SoundManager = require(ReplicatedStorage.Shared.Managers.SoundManager);
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = {};

local function RefreshConfig() -- Line: 21
    -- upvalues: u7 (copy), u5 (ref)
    u7.KnifeRangeLeftClick = u5.Get("Weapon", "KnifeRangeLeftClick");
    u7.KnifeRangeRightClick = u5.Get("Weapon", "KnifeRangeRightClick");
end;

function u1.Init(p8, p9) -- Line: 28
    -- upvalues: u4 (ref), u5 (ref), u2 (copy), u3 (ref), u6 (ref), u7 (copy), RefreshConfig (copy)
    u4 = p8:GetModule("Bullet");
    u5 = p8:GetModule("GameConfiguration");

    if u2 then
        u3 = p8:GetModule("CharacterHandler");
        u6 = p8:GetModule("PlayerHandler");
    end;

    u7.KnifeRangeLeftClick = u5.Get("Weapon", "KnifeRangeLeftClick");
    u7.KnifeRangeRightClick = u5.Get("Weapon", "KnifeRangeRightClick");
    u5.Updated:Connect(RefreshConfig);
end;

function u1.Reset(p10) -- Line: 40
    p10.PacketDirty = true;
    p10.Firing = false;
    p10.Mode = 1;
    p10.Variant = 0;
end;

function u1.SwingOrStab(p11: any, p12: any, p13: boolean, p14: boolean, p15: boolean, p16: any) -- Line: 48
    -- upvalues: u7 (copy), u4 (ref), u2 (copy), SoundManager (copy), u6 (ref)
    p11.PacketDirty = true;
    local v17, v18, v19 = u4.Knife(p12, p14 and u7.KnifeRangeLeftClick or u7.KnifeRangeRightClick, p11, p14, p15, p11.Timer > p11.FireDelay + 0.4, p16);
    p11.Firing = true;
    local v20 = p11.Data.FireRate[p15 and 2 or 1];

    if v17 then
        if p15 then
            v20 = v20 * 1.1;
        elseif p14 then
            v20 = v20 / 0.8;
        end;
    end;

    p11:CalculateNextAttackTime(v20);
    local v21 = Random.new(p11.RandomSeed):NextInteger(1, 2);
    p11.Mode = 1;
    p11.Variant = p15 and 3 or v21;
    p11.CharacterAnimation = p15 and "Stab" or "Fire" .. v21;

    if not p13 then
        p11:StopAllAnimations();
        p11:PlayAnimation(p11.CharacterAnimation, true);
        local v22;

        if v19 == nil then
            v22 = false;
        else
            v22 = next(v19) ~= nil;
        end;

        local v23;

        if v22 then
            v23 = p15 and "Weapons.Knife.Stab" or "Weapons.Knife.HitPlayer";
        else
            v23 = v17 and "Weapons.Knife.HitWall" or "Weapons.Knife.Slash";
        end;

        if u2 then
            local v24 = SoundManager.Pack(v23);
            local Simulation = p12.Simulation;

            if v24 and Simulation then
                u6.BroadcastSound(v24, Simulation.Position, p12.PlayerInstance);
            end;
        else
            SoundManager.Play(v23, {
                LocalReplicated = true
            });
        end;

        if v17 then
            return v18, v19;
        end;
    end;
end;

function u1.TickCommand(p25, p26, p27, p28, p29) -- Line: 125
    -- upvalues: u1 (copy), u2 (copy), u3 (ref)
    local WishBooleans = p27.WishBooleans;
    local v30 = nil;
    local v31 = nil;
    local v32 = nil;

    if WishBooleans.WishFire or WishBooleans.WishFire2 then
        if p25.Timer >= p25.FireDelay then
            v30, v32 = u1.SwingOrStab(p25, p26, p28, WishBooleans.WishFire, WishBooleans.WishFire2, p27.RenderTime);

            if u2 and (v32 and next(v32)) then
                local AllCharacters = u3.GetAllCharacters();

                for i, v in v32 do
                    local v33 = AllCharacters[i];
                    local v34;

                    if v33 then
                        v34 = v33.Modifications.HitPoints;
                    else
                        v34 = v33;
                    end;

                    if v34 then
                        v34.TakeDamage(v33, {
                            Object = v.Object,
                            Amount = v.Damage,
                            Attacker = p26,
                            DamageType = v.DamageType,
                            Penetration = false,
                            DespawnTick = true,
                            Direction = v.Direction,
                            Position = v.Position
                        });
                    end;
                end;

                return v30, v31, v32;
            end;
        elseif p25.Firing then
            p25.PacketDirty = true;
            p25.Firing = false;

            return v30, v31, v32;
        end;
    elseif p25.Firing then
        p25.PacketDirty = true;
        p25.Firing = false;
    end;

    return v30, v31, v32;
end;

return u1;