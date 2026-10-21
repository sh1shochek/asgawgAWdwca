-- Players.jypit54U65.PlayerGui.MainGui.Gameplay.Middle.BuyMenuRetired.WeaponStats.StatsController
-- Script path: Players.jypit54U65.PlayerGui.MainGui.Gameplay.Middle.BuyMenuRetired.WeaponStats.StatsController
-- Decompile time: 3.69 ms

-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
local u1 = { "Damage", "FireRate", "Accuracy", "RecoilControl" };
local u2 = {
    Grey = Color3.fromRGB(176, 195, 217),
    Blue = Color3.fromRGB(75, 105, 255),
    Purple = Color3.fromRGB(136, 71, 255),
    Pink = Color3.fromRGB(211, 44, 230),
    Red = Color3.fromRGB(235, 75, 75),
    Gold = Color3.fromRGB(226, 196, 34)
};
local Color3_fromRGB_ret = Color3.fromRGB(205, 75, 60);
local Color3_fromRGB_ret2 = Color3.fromRGB(225, 180, 60);
local Color3_fromRGB_ret3 = Color3.fromRGB(110, 200, 75);
local Color3_fromRGB_ret4 = Color3.fromRGB(12, 12, 14);
local Color3_fromRGB_ret5 = Color3.fromRGB(203, 203, 203);

local function colourFor(p3) -- Line: 16
    -- upvalues: Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy)
    local v4 = p3 / 10;

    if v4 < 0.5 then
        return Color3_fromRGB_ret:Lerp(Color3_fromRGB_ret2, v4 * 2);
    end;

    return Color3_fromRGB_ret2:Lerp(Color3_fromRGB_ret3, (v4 - 0.5) * 2);
end;

local function refresh() -- Line: 22
    -- upvalues: script_Parent (copy), u2 (copy), u1 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret5 (copy)
    local Attribute = script_Parent:GetAttribute("Magazine");
    local Attribute2 = script_Parent:GetAttribute("Reserve");
    local Attribute3 = script_Parent:GetAttribute("Ammo");

    if Attribute3 and Attribute3 ~= "" then
        Attribute, Attribute2 = string.match(Attribute3, "(%d+)%s*/%s*(%d+)");
    end;

    local Render = script_Parent.Render;
    Render.WeaponName.Text = script_Parent:GetAttribute("WeaponName") or "";
    local string_upper_ret = string.upper(script_Parent:GetAttribute("Category") or "");
    local string_upper_ret2 = string.upper(script_Parent:GetAttribute("SkinName") or "");
    local v5 = u2[script_Parent:GetAttribute("Rarity") or ""] or u2.Grey;
    local string_format_ret = string.format("#%02X%02X%02X", v5.R * 255, v5.G * 255, v5.B * 255);
    local v6 = string_upper_ret2 == "" and "" or ("<font color=\"" .. string_format_ret .. "\">" .. string_upper_ret2 .. "</font>" or "");
    Render.Category.Text = string_upper_ret ~= "" and string_upper_ret2 ~= "" and string_upper_ret .. "  •  " .. v6 or string_upper_ret .. v6;
    Render.Glow.ImageColor3 = v5;
    Render.Price.Value.Text = script_Parent:GetAttribute("Price") or "";
    Render.Price.Visible = (script_Parent:GetAttribute("Price") or "") ~= "";
    Render.Icon.Image = script_Parent:GetAttribute("Icon") or "";
    script_Parent.Info.Magazine.Value.Text = Attribute or "-";
    script_Parent.Info.Reserve.Value.Text = Attribute2 or "-";
    script_Parent.Info.Special.Value.Text = script_Parent:GetAttribute("Special") or "None";

    for _, v in ipairs(u1) do
        local v7 = script_Parent.Stats[v];
        local v8 = script_Parent:GetAttribute(v) or 0;
        local math_clamp_ret = math.clamp(v8, 0, 10);
        local Value = v7.Value;
        local math_floor_ret = math.floor(math_clamp_ret + 0.5);
        Value.Text = tostring(math_floor_ret);
        v7.Track.Fill.Size = UDim2.fromScale(math_clamp_ret / 10, 1);
        local v9 = math_clamp_ret / 10;
        local v10;

        if v9 < 0.5 then
            v10 = Color3_fromRGB_ret:Lerp(Color3_fromRGB_ret2, v9 * 2);
        else
            v10 = Color3_fromRGB_ret2:Lerp(Color3_fromRGB_ret3, (v9 - 0.5) * 2);
        end;

        v7.Track.Fill.BackgroundColor3 = v10;
        v7.Track.Fill.Glow.ImageColor3 = v10;
        v7.Value.TextColor3 = v10;

        for _, child in ipairs(v7.Track:GetChildren()) do
            if child.Name == "Tick" then
                local v11 = child.Position.X.Scale < math_clamp_ret / 10;
                child.ZIndex = 7;
                child.BackgroundColor3 = v11 and Color3_fromRGB_ret4 or Color3_fromRGB_ret5;
                child.BackgroundTransparency = v11 and 0 or 0.8;
            end;
        end;
    end;
end;

local u12 = false;
script_Parent.AttributeChanged:Connect(function() -- Line: 63
    -- upvalues: u12 (ref), refresh (copy)
    if u12 then
        return;
    end;

    u12 = true;
    task.defer(function() -- Line: 66
        -- upvalues: u12 (ref), refresh (ref)
        u12 = false;
        refresh();
    end);
end);
refresh();