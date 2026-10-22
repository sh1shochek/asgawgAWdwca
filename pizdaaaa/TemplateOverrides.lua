-- ReplicatedStorage.Shared.TemplateOverrides
-- Script path: ReplicatedStorage.Shared.TemplateOverrides
-- Decompile time: 10.13 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local ValueCodec = require(ReplicatedStorage.Shared.ValueCodec);
local u2 = {};
local u3 = {};
local u4 = nil;

local function EncodeSimEntries() -- Line: 49
    -- upvalues: u2 (copy), ValueCodec (copy)
    local v5 = {};

    for i, v in pairs(u2) do
        local v6 = {
            Key = i,
            Value = ValueCodec.Encode(v)
        };
        table.insert(v5, v6);
    end;

    return v5;
end;

local function EncodeWeaponEntries(p7: string) -- Line: 57
    -- upvalues: u3 (copy), ValueCodec (copy)
    local v8 = {};

    for i, v in pairs(u3[p7] or {}) do
        local v9 = {
            Key = i,
            Value = ValueCodec.Encode(v)
        };
        table.insert(v8, v9);
    end;

    return v8;
end;

function u1.ApplySimulation(p10: table) -- Line: 67
    -- upvalues: u2 (copy)
    for i, v in pairs(u2) do
        if p10[i] ~= nil then
            p10[i] = v;
        end;
    end;
end;

function u1.ApplyWeapon(p11: string, p12: table) -- Line: 75
    -- upvalues: u3 (copy)
    local v13 = u3[p11];

    if not v13 then
        return;
    end;

    for i, v in pairs(v13) do
        if p12[i] ~= nil then
            p12[i] = v;
        end;
    end;
end;

function u1.RecordSimulation(p14: string, p15: any) -- Line: 90
    -- upvalues: u2 (copy)
    u2[p14] = p15;
end;

function u1.RecordWeapon(p16: string, p17: string, p18: any) -- Line: 94
    -- upvalues: u3 (copy)
    local v19 = u3[p16];

    if not v19 then
        v19 = {};
        u3[p16] = v19;
    end;

    v19[p17] = p18;
end;

function u1.ClearSimulation() -- Line: 103
    -- upvalues: u2 (copy)
    table.clear(u2);
end;

function u1.ClearWeapons() -- Line: 107
    -- upvalues: u3 (copy)
    table.clear(u3);
end;

function u1.GetSimulation() -- Line: 111
    -- upvalues: u2 (copy)
    return u2;
end;

function u1.GetWeapons() -- Line: 115
    -- upvalues: u3 (copy)
    return u3;
end;

function u1.HandleSimulationTemplate(p20) -- Line: 122
    -- upvalues: u1 (copy), ValueCodec (copy)
    local v21 = {};

    for _, v in ipairs(p20) do
        if v.Key == "*" then
            u1.ClearSimulation();

            return nil;
        end;

        local v22 = ValueCodec.Decode(v.Value);
        u1.RecordSimulation(v.Key, v22);
        table.insert(v21, {
            Key = v.Key,
            Value = v22
        });
    end;

    return v21;
end;

function u1.HandleWeaponTemplate(p23) -- Line: 138
    -- upvalues: u3 (copy), ValueCodec (copy), u1 (copy)
    local Weapon = p23.Weapon;

    for _, v in ipairs(p23.Entries) do
        if v.Key == "*" then
            u3[Weapon] = nil;

            return Weapon, nil;
        end;
    end;

    local v24 = {};

    for _, v in ipairs(p23.Entries) do
        local v25 = ValueCodec.Decode(v.Value);
        u1.RecordWeapon(Weapon, v.Key, v25);
        table.insert(v24, {
            Key = v.Key,
            Value = v25
        });
    end;

    return Weapon, v24;
end;

function u1.SetSimulation(p26: string, p27: any) -- Line: 158
    -- upvalues: u2 (copy), u4 (ref), ValueCodec (copy)
    u2[p26] = p27;
    u4.Character.CharacterTemplateBalls.FireAll({
        {
            Key = p26,
            Value = ValueCodec.Encode(p27)
        }
    });
end;

function u1.SetWeapon(p28: string, p29: string, p30: any) -- Line: 165
    -- upvalues: u1 (copy), u4 (ref), ValueCodec (copy)
    u1.RecordWeapon(p28, p29, p30);

    if u4 and (u4.Weapon and u4.Weapon.Template) then
        u4.Weapon.Template.FireAll({
            Weapon = p28,
            Entries = {
                {
                    Key = p29,
                    Value = ValueCodec.Encode(p30)
                }
            }
        });
    end;
end;

function u1.ResetSimulation() -- Line: 173
    -- upvalues: u1 (copy), u4 (ref)
    u1.ClearSimulation();
    u4.Character.CharacterTemplateBalls.FireAll({ {
            Key = "*",
            Value = ""
        } });
end;

function u1.ResetWeapons() -- Line: 180
    -- upvalues: u3 (copy), u1 (copy), u4 (ref)
    local v31 = {};

    for i in pairs(u3) do
        table.insert(v31, i);
    end;

    u1.ClearWeapons();

    if u4 and (u4.Weapon and u4.Weapon.Template) then
        for _, v in ipairs(v31) do
            u4.Weapon.Template.FireAll({
                Weapon = v,
                Entries = { {
                        Key = "*",
                        Value = ""
                    } }
            });
        end;
    end;
end;

function u1.SyncToPlayer(p32: userdata) -- Line: 194
    -- upvalues: u4 (ref), u2 (copy), EncodeSimEntries (copy), u3 (copy), EncodeWeaponEntries (copy)
    if not u4 then
        return;
    end;

    if next(u2) and u4.Character then
        u4.Character.CharacterTemplateBalls.Fire(p32, (EncodeSimEntries()));
    end;

    if u4.Weapon and u4.Weapon.Template then
        for i in pairs(u3) do
            u4.Weapon.Template.Fire(p32, {
                Weapon = i,
                Entries = EncodeWeaponEntries(i)
            });
        end;
    end;
end;

function u1.Init(p33) -- Line: 212
    -- upvalues: RunService (copy), u4 (ref)
    if RunService:IsServer() then
        u4 = p33:GetModule("Network");
    end;
end;

function u1.Start(p34) -- Line: 218
    -- upvalues: RunService (copy), Players (copy), u1 (copy)
    if RunService:IsServer() then
        Players.PlayerAdded:Connect(function(p35) -- Line: 220
            -- upvalues: u1 (ref)
            u1.SyncToPlayer(p35);
        end);
    end;
end;

return u1;