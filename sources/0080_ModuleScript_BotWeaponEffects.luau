-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EmitParticles = require(script.Parent.VFXLibary.CreateMuzzleFlash.EmitParticles);
local CreateTracer = require(script.Parent.VFXLibary.CreateTracer);
local Sound = require(ReplicatedStorage.Classes.Sound);
local FlashEffect = require(script.Parent.VFXLibary.FlashEffect);
local v1 = {};

local function playSound(p2: string, p3: string, p4: vector, p5: boolean?) -- Line: 14
    -- upvalues: ReplicatedStorage (copy), Sound (copy), Players (copy), FlashEffect (copy)
    local Sounds = ReplicatedStorage:FindFirstChild("Sounds");
    local v6;

    if Sounds then
        v6 = Sounds:FindFirstChild(p2);
    else
        v6 = nil;
    end;

    if v6 == nil or v6:FindFirstChild(p3) == nil then
        return;
    end;

    local v7 = Sound.new(p2);

    if not p5 then
        v7:PlaySoundAtPosition({
            Class = p2,
            Name = p3,
            Position = p4
        }, nil, FlashEffect.GetAudioFadeMultiplier());

        return;
    end;

    v7:play({
        Parent = Players.LocalPlayer.PlayerGui,
        Name = p3
    }, FlashEffect.GetAudioFadeMultiplier());
    v7:destroy();
end;

function v1.shoot(p8: any, p9: vector, p10: number, p11: boolean?) -- Line: 33
    -- upvalues: EmitParticles (copy), CreateTracer (copy), playSound (copy)
    local v12 = #p8.Muzzles;

    if v12 == 0 then
        return;
    end;

    local v13 = p8.Muzzles[p10 % v12 + 1];
    local v14;

    if p8.MuzzleType then
        v14 = v13:FindFirstChild(p8.MuzzleType);
    else
        v14 = nil;
    end;

    if v14 and not p11 then
        EmitParticles(v14);
    end;

    local v15 = p9 - v13.Position;

    if v15.Magnitude > 0.0001 and not p11 then
        CreateTracer(v15.Magnitude, v13.Position, v15.Unit, true);
    end;

    playSound(p8.Name, "Shoot", v13.Position, p11);
end;

function v1.reloadSound(p16: any, p17: userdata, p18: boolean?) -- Line: 50
    -- upvalues: playSound (copy)
    playSound(p16.Name, "MagOut", p17.Position, p18);
end;

return table.freeze(v1);