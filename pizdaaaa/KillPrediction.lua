-- ReplicatedStorage.GameClient.KillPrediction
-- Script path: ReplicatedStorage.GameClient.KillPrediction
-- Decompile time: 11.19 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = true;
local u8 = setmetatable({}, {
    __mode = "k"
});

local function HitList(p9) -- Line: 60
    return p9[1] and p9 and p9 or { p9 };
end;

local function ImpulseOf(p10: any, p11: string?, p12: string?, p13: number) -- Line: 66
    -- upvalues: u5 (ref)
    if p11 ~= "Bullet" then
        return p11 ~= "Slash" and 0 or p13 * u5.DamageImpulseScale * u5.PushScale;
    end;

    local v14;

    if p10 then
        v14 = p10.Data;
    else
        v14 = p10;
    end;

    if p10 then
        p10 = p10.Name;
    end;

    if v14 then
        v14 = v14.Type;
    end;

    return u5.GetBulletImpulse(p10, v14, p12 == "Head");
end;

function v1.Process(p15, p16) -- Line: 87
    -- upvalues: u7 (ref), LocalPlayer (copy), u2 (ref), Players (copy), u8 (copy), u5 (ref), u6 (ref), u4 (ref)
    if not (u7 and (p16 and next(p16))) then
        return;
    end;

    local v17;

    if p15 then
        v17 = p15.Data;
    else
        v17 = p15;
    end;

    if v17 then
        v17 = v17.ArmorRatio;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");

    for i, v in p16 do
        local Entity = u2.GetEntity("Character", i);

        if Entity and Entity.Branch ~= "extrap" then
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
                local Attribute2 = UserId:GetAttribute("ArmorValue");
                local Attribute3 = UserId:GetAttribute("HasHelmet");
                local v18 = u8[Entity];

                if not v18 then
                    v18 = {
                        Force = Vector3.new(0, 0, 0),
                        ForceLimb = 0,
                        Until = 0
                    };
                    u8[Entity] = v18;
                end;

                if Health and os.clock() < v18.Until then
                    Health = math.min(Health, v18.Health);

                    if Attribute2 and v18.ArmorValue then
                        Attribute2 = math.min(Attribute2, v18.ArmorValue);
                    end;

                    if Attribute3 then
                        Attribute3 = v18.HasHelmet;
                    end;
                end;

                if Health and Health > 0 then
                    local Force = v18.Force;
                    local ForceLimb = v18.ForceLimb;
                    local v19 = i;

                    for _, v2 in v[1] and v and v or { v } do
                        local Object = v2.Object;

                        if Object then
                            Object = Object.Name;
                        end;

                        local Damage = v2.Damage;
                        local Direction = v2.Direction;
                        local DamageType = v2.DamageType;
                        local v20;

                        if DamageType == "Bullet" then
                            local v21;

                            if p15 then
                                v21 = p15.Data;
                            else
                                v21 = p15;
                            end;

                            local v22;

                            if p15 then
                                v22 = p15.Name;
                            else
                                v22 = p15;
                            end;

                            if v21 then
                                v21 = v21.Type;
                            end;

                            v20 = u5.GetBulletImpulse(v22, v21, Object == "Head");
                        else
                            v20 = DamageType ~= "Slash" and 0 or Damage * u5.DamageImpulseScale * u5.PushScale;
                        end;

                        if v20 > 0 and (Direction and vector.magnitude(Direction) > 1e-6) then
                            Force = Force + vector.normalize(Direction) * (v20 / u5.UnitsPerStud);
                            ForceLimb = u5.LimbIndex[Object] or ForceLimb;
                        end;

                        local v23;
                        v23, Attribute2, Attribute3 = u6.ApplyArmor(Damage, Object, Attribute2, Attribute3, v17);
                        Health = Health - v23;

                        if Health <= 0 then
                            break;
                        end;
                    end;

                    v18.Force = Force;
                    v18.ForceLimb = ForceLimb;
                    v18.Health = Health;
                    v18.ArmorValue = Attribute2;
                    v18.HasHelmet = Attribute3;
                    v18.Until = os.clock() + u4.PredictionWindow();

                    if Health <= 0 then
                        u4.PredictDeath(v19, Entity, UserId, {
                            Identifier = v19,
                            Force = Force,
                            ForceLimb = ForceLimb,
                            Velocity = Entity.Velocity or Vector3.new(0, 0, 0),
                            Origin = Entity.Position
                        });
                    end;
                end;
            end;
        end;
    end;
end;

function v1.Init(p24) -- Line: 206
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref)
    u2 = p24:GetModule("Entities");
    u3 = p24:GetModule("Gui");
    u4 = p24:GetModule("Ragdoll");
    u5 = p24:GetModule("RagdollData");
    u6 = p24:GetModule("DamageCalculation");
end;

function v1.Start(p25) -- Line: 214
    -- upvalues: u3 (ref), u7 (ref)
    local Component = u3.GetComponent("Settings");
    Component:AddConnection("Game", "Gameplay", "Predict Kill Ragdolls", function(p26) -- Line: 217
        -- upvalues: u7 (ref)
        u7 = p26;
    end);
    local PlayerSettings = Component:GetPlayerSettings();
    local v27 = PlayerSettings.Game and PlayerSettings.Game.Gameplay;

    if v27 then
        u7 = v27["Predict Kill Ragdolls"] ~= false;
    end;
end;

return v1;