-- ReplicatedStorage.Shared.Managers.WeaponManager
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager
-- Decompile time: 10.22 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local v2 = {};

for _, v in pairs(script:QueryDescendants("ModuleScript")) do
    u1[v.Name] = require(v);
end;

local u3 = nil;
local u4 = nil;

local function PackPairs(p5: any, p6: string, p7: string) -- Line: 20
    local v8 = 0;

    while p5[v8] ~= nil do
        v8 = v8 + 1;
    end;

    local v9 = 0;

    for _ in p5 do
        v9 = v9 + 1;
    end;

    if v9 ~= v8 then
        error((`WeaponManager: {p6}.{p7} is not a dense 0-based array ({v9} keys, {v8} contiguous)`));
    end;

    local buffer_create_ret = buffer.create(v8 * 8);

    for i = 0, v8 - 1 do
        local v10 = p5[i];
        buffer.writef32(buffer_create_ret, i * 8, v10[1]);
        buffer.writef32(buffer_create_ret, i * 8 + 4, v10[2]);
        local _ = i;
    end;

    return buffer_create_ret, v8;
end;

local Math = require(game:GetService("ReplicatedStorage").Shared.Utility.Math);
local f32 = Math.f32;
local UniformRandomStream = Math.UniformRandomStream;
local u11 = f32(0.55);
local u12 = f32(0.75);

local function Lerp32(p13: number, p14: number, p15: number) -- Line: 69
    -- upvalues: f32 (copy)
    return f32(p14 + f32(p13 * f32(p15 - p14)));
end;

local function GenerateRecoilTable(p16: any, p17: boolean, p18: any) -- Line: 73
    -- upvalues: UniformRandomStream (copy), f32 (copy), u11 (copy), u12 (copy)
    local table_create_ret = table.create(2);

    for i = 1, 2 do
        local v19 = UniformRandomStream(p16.Seed);
        local v20 = f32(p16.Angle[i]);
        local v21 = f32(p16.AngleVariance[i]);
        local v22 = f32(p16.Magnitude[i]);
        local v23 = f32(p16.MagnitudeVariance[i]);
        local buffer_create_ret = buffer.create(512);
        local v24 = 0;
        local v25 = 0;

        for i2 = 0, 63 do
            local v26 = f32(v20 + v19(-v21, v21));
            local v27 = f32(v22 + v19(-v23, v23));

            if p17 and i2 > 0 then
                v24 = f32(v24 + f32(u11 * f32(v26 - v24)));
                v25 = f32(v25 + f32(u11 * f32(v27 - v25)));
            else
                v25 = v27;
                v24 = v26;
            end;

            if p17 and i2 < 4 then
                local v28 = u12;
                v25 = f32(v25 * f32(v28 + f32(f32(i2 / 4) * f32(1 - v28))));
            end;

            buffer.writef32(buffer_create_ret, i2 * 8, v24);
            buffer.writef32(buffer_create_ret, i2 * 8 + 4, v25);
            local _ = i2;
        end;

        table_create_ret[i] = buffer_create_ret;
    end;

    return table_create_ret;
end;

v2.RecoilTableSize = 64;

local function FreezeCatalog(p29) -- Line: 135
    local u30 = {};
    local u31 = {};
    local u32 = 0;

    local function Canonical(p33) -- Line: 144
        -- upvalues: u31 (copy), u32 (ref)
        local v34 = type(p33);

        if v34 == "number" then
            return `n{string.format("%.17g", p33)}`;
        end;

        if v34 == "string" then
            return `s{p33}`;
        end;

        if v34 == "boolean" then
            return `b{tostring(p33)}`;
        end;

        local v35 = u31[p33];

        if not v35 then
            u32 = u32 + 1;
            v35 = `#{u32}`;
            u31[p33] = v35;
        end;

        return v35;
    end;

    local function Intern(p36) -- Line: 166
        -- upvalues: Intern (copy), Canonical (copy), u30 (copy)
        if type(p36) ~= "table" or table.isfrozen(p36) then
            return p36;
        end;

        for i, v in p36 do
            local v37 = Intern(v);

            if v37 ~= v then
                p36[i] = v37;
            end;
        end;

        table.freeze(p36);
        local v38 = {};

        for i, v in p36 do
            local v39 = `{Canonical(i)}\2{Canonical(v)}`;
            table.insert(v38, v39);
        end;

        table.sort(v38);
        local table_concat_ret = table.concat(v38, "\3");
        local v40 = u30[table_concat_ret];

        if v40 then
            return v40;
        end;

        u30[table_concat_ret] = p36;

        return p36;
    end;

    return Intern(p29);
end;

function v2.Get(p41: string) -- Line: 206
    -- upvalues: u1 (ref)
    local v42 = u1[p41];

    if v42 then
        return v42;
    end;
end;

function v2.GetAllWeapons() -- Line: 216
    -- upvalues: u1 (ref)
    return u1;
end;

function v2.Init(p43) -- Line: 222
    -- upvalues: u3 (ref), u4 (ref), u1 (ref), GenerateRecoilTable (copy), PackPairs (copy), FreezeCatalog (copy)
    u3 = p43:GetModule("Enums");
    u4 = p43:GetModule("Table");
    u3.Weapons = { "Kevlar Vest", "Kevlar & Helmet", "Rescue Kit" };
    u3.WeaponsNum = {
        ["Kevlar Vest"] = 1,
        ["Kevlar & Helmet"] = 2,
        ["Rescue Kit"] = 3
    };

    for i, _ in u1 do
        table.insert(u3.Weapons, i);
    end;

    table.sort(u3.Weapons, function(p44, p45) -- Line: 243
        return p44:lower() < p45:lower();
    end);

    for i, v in u3.Weapons do
        u3.WeaponsNum[v] = i;
    end;

    for i, v in u1 do
        local Data = v.Data;

        if Data then
            local Recoil = Data.Recoil;

            if Recoil and Recoil.Seed then
                Recoil.Table = GenerateRecoilTable(Recoil, Data.Automatic == true, i);
            end;

            local SpreadOffsets = Data.SpreadOffsets;

            if type(SpreadOffsets) == "table" then
                local v46, v47 = PackPairs(SpreadOffsets, i, "SpreadOffsets");
                Data.SpreadOffsets = v46;
                Data.SpreadOffsetsLength = v47;
            end;
        end;
    end;

    u1 = FreezeCatalog(u1);
    u3.Weapons = u4.Freeze(u3.Weapons);
    u3.WeaponsNum = u4.Freeze(u3.WeaponsNum);
end;

return v2;