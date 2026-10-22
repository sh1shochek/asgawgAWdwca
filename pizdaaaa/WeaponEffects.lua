-- ReplicatedStorage.GameClient.WeaponController.WeaponEffects
-- Script path: ReplicatedStorage.GameClient.WeaponController.WeaponEffects
-- Decompile time: 9.90 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = false;
local u11 = false;
local u12 = false;
local u13 = false;

local function HitList(p14) -- Line: 33
    return p14[1] and p14 and p14 or { p14 };
end;

local function PredictPainSounds(p15, p16) -- Line: 51
    -- upvalues: u12 (ref), u13 (ref), LocalPlayer (copy), u4 (ref), Players (copy), u5 (ref), u2 (ref)
    if not ((u12 or u13) and p16) then
        return;
    end;

    if p15 then
        p15 = p15.Data;
    end;

    if p15 then
        p15 = p15.ArmorRatio;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");

    for i, v in p16 do
        local Entity = u4.GetEntity("Character", i);

        if Entity then
            local UserId = Entity.UserId;

            if UserId then
                if UserId == 0 then
                    UserId = false;
                else
                    UserId = Players:GetPlayerByUserId(UserId);
                end;
            end;

            if UserId and (UserId ~= LocalPlayer and (not Entity.Data or Entity.Data.Team ~= Attribute)) then
                local Health = Entity.Health;

                if Health and Health > 0 then
                    local Attribute2 = UserId:GetAttribute("ArmorValue");
                    local Attribute3 = UserId:GetAttribute("HasHelmet");

                    for _, v2 in v[1] and v and v or { v } do
                        local Object = v2.Object;

                        if Object then
                            Object = Object.Name;
                        end;

                        local v17;

                        if Object == "Head" then
                            v17 = v2.DamageType ~= "Slash";
                        else
                            v17 = false;
                        end;

                        local v18, v19, v20;
                        v18, Attribute2, v19, v20 = u5.ApplyArmor(v2.Damage, Object, Attribute2, Attribute3, p15);

                        if v17 and u13 or not v17 and u12 then
                            u2.PlayPainSound(Object, v20, Attribute3, v2.DamageType);
                        end;

                        Health = Health - v18;

                        if Health <= 0 then
                            break;
                        end;

                        Attribute3 = v19;
                    end;
                end;
            end;
        end;
    end;
end;

function v1.Process(p21, p22, p23, p24, p25, p26) -- Line: 118
    -- upvalues: u7 (ref), u2 (ref), u11 (ref), u10 (ref), PredictPainSounds (copy), u9 (ref), u8 (ref), u3 (ref)
    if p22 then
        local v27 = u7 and u7.IsImpacts and u7.IsImpacts();

        for _, v in p22 do
            if v27 and (not v.Knife and v.Position) then
                u7.AddClientImpact(v.Position);
            end;

            u2.PlayBulletImpact(v);

            if not (v.IsCharacter and not (v.IsHeadshot and u11) and (v.IsHeadshot or not u10)) then
                u2.CreateBulletHole(v);
            end;
        end;
    end;

    if p23 then
        local Viewmodel = p21.Viewmodel;

        if Viewmodel then
            Viewmodel = Viewmodel:FindFirstChild(p26 and "SilencerMuzzle" or (p25 and "LeftMuzzle" or "Muzzle"));
        end;

        local Muzzle = p21.Data.Muzzle;

        if Viewmodel then
            u2.CreateMuzzleFlash(Viewmodel, p26 and "Silencer" or Muzzle);

            for _, v in p23 do
                v.StartPosition = Viewmodel.Position;
                u2.CreateTracer(v);
            end;
        end;
    end;

    PredictPainSounds(p21, p24);

    if p24 and next(p24) then
        u9.Play("Hit");
    end;

    if u8 and p24 then
        u8.ProcessHits(p21, p24);
    end;

    u3.Process(p21, p24);
end;

function v1.Muzzle(p28, p29, p30, p31) -- Line: 173
    -- upvalues: u2 (ref)
    if p29 then
        p29 = p29:FindFirstChild(p31 and "SilencerMuzzle" or (p30 and "LeftMuzzle" or "Muzzle"));
    end;

    local Muzzle = p28.Data.Muzzle;

    if p29 then
        u2.CreateMuzzleFlash(p29, p31 and "Silencer" or Muzzle);
    end;
end;

function v1.Tracer(p32, p33, p34, p35, p36) -- Line: 182
    -- upvalues: u2 (ref)
    if p33 then
        p33 = p33:FindFirstChild(p35 and "SilencerMuzzle" or (p34 and "LeftMuzzle" or "Muzzle"));
    end;

    if p33 then
        u2.CreateTracer({
            StartPosition = p33.Position,
            EndPosition = p36
        });
    end;
end;

function v1.Init(p37) -- Line: 196
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), ReplicatedStorage (copy), u8 (ref)
    u2 = p37:GetModule("ParticleHandler");
    u3 = p37:GetModule("KillPrediction");
    u4 = p37:GetModule("Entities");
    u5 = p37:GetModule("DamageCalculation");
    u6 = p37:GetModule("Gui");
    u7 = p37:GetModule("DebugVisualizers");

    if not u7 then
        pcall(function() -- Line: 204
            -- upvalues: u7 (ref), ReplicatedStorage (ref)
            u7 = require(ReplicatedStorage.ClientModules.DebugVisualizers);
        end);
    end;

    u8 = p37:GetModule("ArcadeEffects");

    if not u8 then
        pcall(function() -- Line: 210
            -- upvalues: u8 (ref), ReplicatedStorage (ref)
            u8 = require(ReplicatedStorage.ClientModules.ArcadeEffects);
        end);
    end;
end;

function v1.Start(p38) -- Line: 216
    -- upvalues: u6 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref)
    local Component = u6.GetComponent("Settings");
    u9 = u6.GetComponent("Haptics");
    local PlayerSettings = Component:GetPlayerSettings();
    local v39 = PlayerSettings.Game and PlayerSettings.Game.Gameplay;

    if v39 then
        u10 = v39["Predict Body Shot Effects"] == true;
        u11 = v39["Predict Head Shot Effects"] == true;
        u12 = v39["Predict Body Sound"] == true;
        u13 = v39["Predict Headshot Sound"] == true;
    end;

    Component:AddConnection("Game", "Gameplay", "Predict Body Shot Effects", function(p40) -- Line: 233
        -- upvalues: u10 (ref)
        u10 = p40;
    end);
    Component:AddConnection("Game", "Gameplay", "Predict Head Shot Effects", function(p41) -- Line: 236
        -- upvalues: u11 (ref)
        u11 = p41;
    end);
    Component:AddConnection("Game", "Gameplay", "Predict Body Sound", function(p42) -- Line: 239
        -- upvalues: u12 (ref)
        u12 = p42;
    end);
    Component:AddConnection("Game", "Gameplay", "Predict Headshot Sound", function(p43) -- Line: 242
        -- upvalues: u13 (ref)
        u13 = p43;
    end);
end;

return v1;