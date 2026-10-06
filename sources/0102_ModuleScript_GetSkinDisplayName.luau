-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local u1 = {
    ["Zeus x27"] = "Taser"
};
local table_freeze_ret = table.freeze({
    ["Lebron James"] = "LeGoat",
    ["Medal.tv"] = "Medal"
});
local u2 = {};

for i, v in u1 do
    u2[v:lower()] = i;
end;

local u3 = {};

local function replaceCaseInsensitive(p4: string, p5: string, p6: string) -- Line: 23
    if p5 == "" then
        return p4;
    end;

    local v7 = p4:lower();
    local v8 = 1;
    local v9 = {};

    while true do
        local v10, v11 = v7:find(p5, v8, true);

        if not (v10 and v11) then
            break;
        end;

        table.insert(v9, p4:sub(v8, v10 - 1));
        table.insert(v9, p6);
        v8 = v11 + 1;
    end;

    table.insert(v9, p4:sub(v8));

    return table.concat(v9);
end;

function u3.GetNameTag(p12) -- Line: 47
    if typeof(p12) == "string" and p12 ~= "" then
        return p12;
    end;

    return nil;
end;

local function escapeRichText(p13: string) -- Line: 54
    return p13:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
end;

function u3.FormatNameLabelText(p14: string, p15: any) -- Line: 58
    -- upvalues: u3 (copy)
    if u3.GetNameTag(p15) then
        return `<i>{p14:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")}</i>`;
    end;

    return p14;
end;

function u3.ApplyNameLabel(p16: userdata?, p17: string, p18: any) -- Line: 65
    -- upvalues: u3 (copy)
    if not (p16 and (p16:IsA("TextLabel") or (p16:IsA("TextButton") or p16:IsA("TextBox")))) then
        return;
    end;

    local v19 = u3.GetNameTag(p18) ~= nil;

    if p16:GetAttribute("NameTagRichTextDefault") == nil then
        p16:SetAttribute("NameTagRichTextDefault", p16.RichText);
    end;

    if p16:GetAttribute("NameTagFontStyleDefault") == nil then
        p16:SetAttribute("NameTagFontStyleDefault", p16.FontFace.Style.Name);
    end;

    local Attribute = p16:GetAttribute("NameTagFontStyleDefault");
    local FontFace = p16.FontFace;
    local v20;

    if v19 or Attribute == "Italic" then
        v20 = Enum.FontStyle.Italic;
    else
        v20 = Enum.FontStyle.Normal;
    end;

    p16.FontFace = Font.new(FontFace.Family, FontFace.Weight, v20);
    p16.RichText = v19 or p16:GetAttribute("NameTagRichTextDefault") == true;
    p16.Text = u3.FormatNameLabelText(p17, p18);
end;

function u3.GetWeaponDisplayName(p21: string?, p22: any) -- Line: 86
    -- upvalues: u3 (copy), u1 (copy), replaceCaseInsensitive (copy)
    local NameTag = u3.GetNameTag(p22);

    if NameTag then
        return NameTag;
    end;

    if not p21 then
        return "";
    end;

    local v23 = u1[p21];

    if v23 then
        return v23;
    end;

    for i, v in u1 do
        p21 = replaceCaseInsensitive(p21, i:lower(), v);
    end;

    return p21;
end;

function u3.GetSkinDisplayName(p24: string?, p25: boolean?) -- Line: 109
    -- upvalues: table_freeze_ret (copy)
    if not p24 then
        return "";
    end;

    if not p24:find("PATTERN") then
        return table_freeze_ret[p24] or p24;
    end;

    local table_unpack_ret, v26 = table.unpack(p24:split("_PATTERN_"));

    if p25 then
        table_unpack_ret = `{table_unpack_ret} • Pattern {v26}` or table_unpack_ret;
    end;

    return table_unpack_ret;
end;

function u3.GetFullItemDisplayName(p27: string, p28: string, p29: boolean?, p30: boolean?, p31: any) -- Line: 122
    -- upvalues: Skins (copy), u3 (copy)
    local SkinInformation = Skins.GetSkinInformation(p27, p28);

    if not SkinInformation then
        return "";
    end;

    local v32 = p30 == nil and true or p30;
    local WeaponDisplayName = u3.GetWeaponDisplayName(SkinInformation.paintId, p31);

    if WeaponDisplayName:find("PATTERN") then
        local table_unpack_ret, v33 = table.unpack(WeaponDisplayName:split("_PATTERN_"));

        if v32 then
            table_unpack_ret = `{table_unpack_ret} • Pattern {v33}` or table_unpack_ret;
        end;

        return table_unpack_ret;
    end;

    local v34 = `{WeaponDisplayName:split(" | ")[1]} | {u3.GetSkinDisplayName(p28, v32)}`;
    local v35 = p29 and "KillTrak™ " or "";

    if SkinInformation.type == "Melee" or SkinInformation.type == "Glove" then
        v35 = v35 .. "★ ";
    end;

    return `{v35}{v34}`;
end;

function u3.GetInternalSearchQuery(p36: string?) -- Line: 153
    -- upvalues: u2 (copy), replaceCaseInsensitive (copy)
    if not p36 then
        return "";
    end;

    for i, v in u2 do
        p36 = replaceCaseInsensitive(p36, i, v);
    end;

    return p36;
end;

function u3.GetSearchIdentity(p37: string?, p38: string?) -- Line: 166
    -- upvalues: u3 (copy)
    local v39 = p37 or "";
    local WeaponDisplayName = u3.GetWeaponDisplayName(v39);
    local SkinDisplayName = u3.GetSkinDisplayName(p38 or "", true);

    if WeaponDisplayName == v39 then
        return `{v39} | {SkinDisplayName}`;
    end;

    return `{WeaponDisplayName} | {SkinDisplayName} {v39}`;
end;

return setmetatable(u3, {
    __call = function(p40: any, p41: string, p42: boolean?) -- Line: 180, Name: __call
        -- upvalues: u3 (copy)
        return u3.GetSkinDisplayName(p41, p42);
    end
});