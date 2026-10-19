-- WeaponStats (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu.WeaponStats

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local u2 = {
    Blue = "Blue",
    Purple = "Purple",
    Pink = "Pink",
    Red = "Red",
    Special = "Gold",
    Forbidden = "Gold"
};
local u3 = {
    Burst = "Burst Fire",
    Dual = "Dual Wield",
    Revolver = "Alt Fire"
};
local u4 = nil;

local function isRatedGun(p5) -- Line: 53
    local v6;

    if p5.Class == "Weapon" and (p5.Slot ~= "Melee" and (typeof(p5.DamagePerPart) == "table" and typeof(p5.FireRate) == "number")) then
        v6 = p5.FireRate > 0;
    else
        v6 = false;
    end;

    return v6;
end;

local function getShotDamage(p7) -- Line: 64
    return p7.DamagePerPart.Torso * (p7.BulletsPerShot or 1);
end;

local function getSpread(p8) -- Line: 70
    return p8.Spread and (p8.Spread.Range and p8.Spread.Range.Min) or 0;
end;

local function widen(p9: table?, p10: number) -- Line: 76
    return p9 and {
        Min = math.min(p9.Min, p10),
        Max = math.max(p9.Max, p10)
    } or {
        Min = p10,
        Max = p10
    };
end;

local function getRanges() -- Line: 85
    -- upvalues: u4 (ref), ReplicatedStorage (copy), GetWeaponProperties (copy), widen (copy)
    if u4 then
        return u4;
    end;

    local v11 = nil;
    local v12 = nil;
    local v13 = nil;

    for _, child in ReplicatedStorage.Database.Custom.Weapons:GetChildren() do
        local v14 = child:IsA("ModuleScript") and GetWeaponProperties(child.Name);

        if v14 then
            local v15;

            if v14.Class == "Weapon" and (v14.Slot ~= "Melee" and (typeof(v14.DamagePerPart) == "table" and typeof(v14.FireRate) == "number")) then
                v15 = v14.FireRate > 0;
            else
                v15 = false;
            end;

            if v15 then
                v11 = widen(v11, 1 / v14.FireRate);
                v12 = widen(v12, v14.Spread and v14.Spread.Range and (v14.Spread.Range.Min or 0) or 0);

                if v14.Recoil and v14.Recoil.Scale then
                    v13 = widen(v13, v14.Recoil.Scale);
                end;
            end;
        end;
    end;

    local v16 = {
        Min = 0,
        Max = 1
    };
    u4 = {
        ShotsPerSecond = v11 or v16,
        Spread = v12 or v16,
        Recoil = v13 or v16
    };

    return u4;
end;

local function scale(p17: number, p18: table) -- Line: 114
    local v19 = (p17 - p18.Min) / math.max(p18.Max - p18.Min, 1e-6);

    return math.clamp(v19, 0, 1);
end;

local function toRating(p20: number) -- Line: 121
    return p20 * 9 + 1;
end;

local function getCategory(p21) -- Line: 127
    return p21.HasScope and not p21.Automatic and "Sniper Rifle" or (p21.Type == "Heavy" and ((p21.BulletsPerShot or 1) > 1 and "Shotgun" or "Machine Gun") or (p21.Type or ""));
end;

local function getSpecial(p22) -- Line: 138
    -- upvalues: u3 (copy)
    return p22.HasScope and "Scope" or (p22.HasSuppressor and "Suppressor" or (u3[p22.ShootingOptions] or "None"));
end;

function v1.Fill(p23: userdata, p24: string, p25: table) -- Line: 152
    -- upvalues: GetWeaponProperties (copy), getRanges (copy), u2 (copy), u3 (copy)
    local v26 = GetWeaponProperties(p24);

    if v26 then
        local v27;

        if v26.Class == "Weapon" and (v26.Slot ~= "Melee" and (typeof(v26.DamagePerPart) == "table" and typeof(v26.FireRate) == "number")) then
            v27 = v26.FireRate > 0;
        else
            v27 = false;
        end;

        if v27 then
            local v28 = getRanges();
            local Spread = v28.Spread;
            local v29 = ((v26.Spread and v26.Spread.Range and (v26.Spread.Range.Min or 0) or 0) - Spread.Min) / math.max(Spread.Max - Spread.Min, 1e-6);
            local math_clamp_ret = math.clamp(v29, 0, 1);
            local math_sqrt_ret = math.sqrt(math_clamp_ret);
            local v30;

            if v26.Recoil and v26.Recoil.Scale then
                local Recoil = v28.Recoil;
                local v31 = (v26.Recoil.Scale - Recoil.Min) / math.max(Recoil.Max - Recoil.Min, 1e-6);
                v30 = 1 - math.clamp(v31, 0, 1);
            else
                v30 = 1;
            end;

            p23:SetAttribute("WeaponName", p25.DisplayName);
            local v32;

            if v26.HasScope and not v26.Automatic then
                v32 = "Sniper Rifle";
            elseif v26.Type == "Heavy" then
                v32 = (v26.BulletsPerShot or 1) > 1 and "Shotgun" or "Machine Gun";
            else
                v32 = v26.Type or "";
            end;

            p23:SetAttribute("Category", v32);
            p23:SetAttribute("SkinName", p25.SkinName or "");
            p23:SetAttribute("Rarity", p25.Rarity and (u2[p25.Rarity] or "Grey") or "Grey");
            p23:SetAttribute("Price", p25.Price);
            p23:SetAttribute("Icon", p25.Icon);
            p23:SetAttribute("Ammo", "");
            p23:SetAttribute("Magazine", (tostring(v26.Rounds or "-")));
            p23:SetAttribute("Reserve", (tostring(v26.Capacity or "-")));
            p23:SetAttribute("Special", v26.HasScope and "Scope" or (v26.HasSuppressor and "Suppressor" or (u3[v26.ShootingOptions] or "None")));
            p23:SetAttribute("Damage", math.min(v26.DamagePerPart.Torso * (v26.BulletsPerShot or 1) / 100, 1) * 9 + 1);
            local ShotsPerSecond = v28.ShotsPerSecond;
            local v33 = (1 / v26.FireRate - ShotsPerSecond.Min) / math.max(ShotsPerSecond.Max - ShotsPerSecond.Min, 1e-6);
            p23:SetAttribute("FireRate", math.clamp(v33, 0, 1) * 9 + 1);
            p23:SetAttribute("Accuracy", (1 - math_sqrt_ret) * 9 + 1);
            p23:SetAttribute("RecoilControl", v30 * 9 + 1);

            return true;
        end;
    end;

    return false;
end;

function v1.Clear(p34: userdata) -- Line: 186
    p34:SetAttribute("WeaponName", "");
    p34:SetAttribute("Category", "");
    p34:SetAttribute("SkinName", "");
    p34:SetAttribute("Rarity", "Grey");
    p34:SetAttribute("Price", "");
    p34:SetAttribute("Icon", "");
    p34:SetAttribute("Ammo", "");
    p34:SetAttribute("Magazine", "-");
    p34:SetAttribute("Reserve", "-");
    p34:SetAttribute("Special", "-");
    p34:SetAttribute("Damage", 0);
    p34:SetAttribute("FireRate", 0);
    p34:SetAttribute("Accuracy", 0);
    p34:SetAttribute("RecoilControl", 0);
end;

return v1;