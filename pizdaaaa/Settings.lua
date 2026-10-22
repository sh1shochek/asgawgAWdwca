-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Settings
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Settings
-- Decompile time: 181.91 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    Capturing = false,
    flags = {},
    Sliders = {},
    Pickers = {},
    Binds = {}
};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local HttpService = game:GetService("HttpService");
local TextService = game:GetService("TextService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Roles = require(ReplicatedStorage.Shared.Roles);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local u26 = {};
local u27 = {};
local u28 = {};
local u29 = {};
local u30 = {};
local u31 = {};
local u32 = {};
local u33 = {};
local u34 = {};
local u35 = {};
local u36 = {};
local u37 = {};
local u38 = {};
local u39 = {};
local u40 = {};
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = nil;
local u45 = false;
local u46 = nil;
local u47 = {};
local u48 = { "Default", "Optimizations", "Preset 1", "Preset 2", "Preset 3", "Preset 4", "Preset 5" };
local u49 = {
    Potato = {
        Viewmodel = {
            ["Remove Viewmodel Bobbing"] = true,
            ["Remove Viewmodel Sway"] = true,
            ["Remove Viewmodel Texture"] = true,
            ["Remove Viewmodel Sleeves"] = true,
            ["Remove Viewmodel Gloves"] = true
        },
        ["Graphics & Visuals"] = {
            ["Show NameTag"] = false,
            ["Show Nametag"] = {},
            ["Nametag Draw Distance"] = 50,
            ["Character Shadows"] = "No Shadows",
            ["Dropped Weapon Shadows"] = false,
            ["Remove Post Processing Effects"] = true,
            ["Remove Tracers"] = true,
            ["Remove Muzzle Flash"] = true,
            ["Remove Character Accessories"] = true,
            ["Remove Character Textures"] = { "Weapon Textures", "Character Textures", "Glove Textures", "Accessory Textures" },
            ["Remove Ragdolls"] = true,
            ["Limit number of ragdolls"] = true,
            ["Maximum number of ragdolls"] = 1,
            ["Lifetime of ragdolls"] = true,
            ["Ragdoll Life time"] = 1,
            ["Surface Marks"] = false,
            Blood = false,
            ["Impact Smoke & Sparks"] = false,
            ["Limit Bullet Holes"] = true,
            ["Maximum Bullet Holes"] = 1,
            ["Limit Bullet Hole Lifetime"] = true,
            ["Maximum Bullet Hole Lifetime"] = 1
        }
    },
    Medium = {
        Viewmodel = {
            ["Remove Viewmodel Bobbing"] = false,
            ["Remove Viewmodel Sway"] = false,
            ["Remove Viewmodel Texture"] = false,
            ["Remove Viewmodel Sleeves"] = false,
            ["Remove Viewmodel Gloves"] = false
        },
        ["Graphics & Visuals"] = {
            ["Show NameTag"] = true,
            ["Show Nametag"] = { "Pips", "Names", "Health", "Equipment" },
            ["Nametag Draw Distance"] = 150,
            ["Character Shadows"] = "Default",
            ["Dropped Weapon Shadows"] = false,
            ["Remove Post Processing Effects"] = true,
            ["Remove Tracers"] = false,
            ["Remove Muzzle Flash"] = false,
            ["Remove Character Accessories"] = false,
            ["Remove Character Textures"] = {},
            ["Remove Ragdolls"] = false,
            ["Limit number of ragdolls"] = true,
            ["Maximum number of ragdolls"] = 5,
            ["Lifetime of ragdolls"] = true,
            ["Ragdoll Life time"] = 10,
            ["Surface Marks"] = true,
            Blood = false,
            ["Impact Smoke & Sparks"] = true,
            ["Limit Bullet Holes"] = true,
            ["Maximum Bullet Holes"] = 64,
            ["Limit Bullet Hole Lifetime"] = true,
            ["Maximum Bullet Hole Lifetime"] = 15
        }
    },
    High = {
        Viewmodel = {
            ["Remove Viewmodel Bobbing"] = false,
            ["Remove Viewmodel Sway"] = false,
            ["Remove Viewmodel Texture"] = false,
            ["Remove Viewmodel Sleeves"] = false,
            ["Remove Viewmodel Gloves"] = false
        },
        ["Graphics & Visuals"] = {
            ["Show NameTag"] = true,
            ["Show Nametag"] = { "Pips", "Names", "Health", "Equipment" },
            ["Nametag Draw Distance"] = 0,
            ["Character Shadows"] = "Highest",
            ["Dropped Weapon Shadows"] = true,
            ["Remove Post Processing Effects"] = false,
            ["Remove Tracers"] = false,
            ["Remove Muzzle Flash"] = false,
            ["Remove Character Accessories"] = false,
            ["Remove Character Textures"] = {},
            ["Remove Ragdolls"] = false,
            ["Limit number of ragdolls"] = true,
            ["Maximum number of ragdolls"] = 12,
            ["Lifetime of ragdolls"] = false,
            ["Ragdoll Life time"] = 30,
            ["Surface Marks"] = true,
            Blood = true,
            ["Impact Smoke & Sparks"] = true,
            ["Limit Bullet Holes"] = true,
            ["Maximum Bullet Holes"] = 128,
            ["Limit Bullet Hole Lifetime"] = true,
            ["Maximum Bullet Hole Lifetime"] = 30
        }
    }
};
local u50 = nil;
local u51 = false;
local u52 = nil;
local u53 = nil;
local u54 = nil;
local u55 = 0;
local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Quint);
local u56 = { {
        Name = "STANDING STILL",
        Time = 1
    }, {
        Name = "RUNNING",
        Time = 1.4,
        Speed = 1
    }, {
        Name = "STOPPING",
        Time = 0.8
    }, {
        Name = "SPRAYING",
        Time = 1,
        Fire = true
    }, {
        Name = "RECOVERING",
        Time = 1.4
    } };
local u57 = false;
local u58 = false;
local u59 = nil;
local u60 = nil;

local function CanAccessSetting(p61) -- Line: 196
    -- upvalues: u15 (ref), Roles (copy), LocalPlayer (copy)
    if not p61 then
        return true;
    end;

    if p61.Mobile and (u15 and u15() == "PC") then
        return false;
    end;

    if p61.Touch and (u15 and u15() ~= "Mobile") then
        return false;
    end;

    if not p61.Role then
        return true;
    end;

    if type(p61.Role) ~= "table" then
        return Roles.HasRole(LocalPlayer.UserId, p61.Role);
    end;

    for _, v in ipairs(p61.Role) do
        if Roles.HasRole(LocalPlayer.UserId, v) then
            return true;
        end;
    end;

    return false;
end;

local function EncodeCrosshair(p62) -- Line: 222
    local v63 = p62["Crosshair Color"][1];
    local v64 = p62["Crosshair Color"][2];
    local v65 = p62["Crosshair Color"][3];
    local v66 = p62["Crosshair Outline Color"][1];
    local v67 = p62["Crosshair Outline Color"][2];
    local v68 = p62["Crosshair Outline Color"][3];
    local v69 = 0;

    if p62["Crosshair Dot Enabled"] == true then
        v69 = v69 + 16;
    end;

    if p62["Crosshair Follow Recoil"] == true then
        v69 = v69 + 8;
    end;

    if p62["Crosshair T Style"] == true then
        v69 = v69 + 4;
    end;

    if p62["Deployed Weapon Gap"] == true then
        v69 = v69 + 2;
    end;

    if p62["Use Crosshair Color for Scope Dot"] == true then
        v69 = v69 + 1;
    end;

    local math_round_ret = math.round(p62["Crosshair Outline Transparency"] * 100);
    local math_round_ret2 = math.round(p62["Crosshair Transparency"] * 100);
    local string_format_ret = string.format("%02X%02X%02X%02X%02X%02X%02X%01X%02X%01X%02X%02X%02X%02X", math.clamp(v63, 0, 255), math.clamp(v64, 0, 255), math.clamp(v65, 0, 255), math.clamp(p62["Crosshair Gap"], 0, 255), math.clamp(p62["Crosshair Length"], 0, 255), math.clamp(math_round_ret, 0, 255), math.clamp(math_round_ret2, 0, 255), math.clamp(p62["Crosshair Outline"], 0, 15), math.clamp(p62["Crosshair Thickness"], 0, 255), math.clamp(p62["Crosshair Style"] == "Static" and 1 or 0, 0, 15), v69, math.clamp(v66, 0, 255), math.clamp(v67, 0, 255), (math.clamp(v68, 0, 255)));

    if p62["Crosshair Image"] == "" then
        return string_format_ret;
    end;

    local v70 = p62["Crosshair Image Color"][1];
    local v71 = p62["Crosshair Image Color"][2];
    local v72 = p62["Crosshair Image Color"][3];

    return string_format_ret .. string.format("%02X%02X%03X%02X%02X%02X%01X", p62["Crosshair Image Size"], math.round(p62["Crosshair Image Transparency"] * 100), p62["Crosshair Image Rotation"], v70, v71, v72, p62["Pixelated Crosshair Image"] and 1 or 0) .. p62["Crosshair Image"];
end;

local function FitDescriptionSize(p73) -- Line: 268
    -- upvalues: TextService (copy)
    local ItemText = p73.ItemText;
    local Text = ItemText.Text;
    local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
    GetTextBoundsParams.Text = Text;
    GetTextBoundsParams.Font = ItemText.FontFace;
    GetTextBoundsParams.Size = ItemText.TextSize;
    GetTextBoundsParams.Width = (1 / 0);
    local v74 = TextService:GetTextBoundsAsync(GetTextBoundsParams).X + 24 + 4;
    local math_clamp_ret = math.clamp(v74, 200, 280);
    GetTextBoundsParams.Width = math_clamp_ret - 24 - 4;
    local TextBoundsAsync = TextService:GetTextBoundsAsync(GetTextBoundsParams);
    p73.Size = UDim2.fromOffset(math_clamp_ret, TextBoundsAsync.Y + 16 + 4);
end;

local function PositionDescription(p75, p76) -- Line: 289
    local AbsolutePosition = p76.AbsolutePosition;
    local AbsolutePosition2 = p75.Parent.AbsolutePosition;
    local AbsoluteSize = p75.AbsoluteSize;
    local v77 = AbsolutePosition.Y + p76.AbsoluteSize.Y + 4 - AbsolutePosition2.Y;
    local v78 = AbsolutePosition.Y - AbsoluteSize.Y - 4 - AbsolutePosition2.Y;

    if v77 + AbsoluteSize.Y <= p75.Parent.AbsoluteSize.Y then
        v78 = v77 or v78;
    end;

    p75.Position = UDim2.fromOffset(AbsolutePosition.X + p76.AbsoluteSize.X - AbsoluteSize.X - AbsolutePosition2.X, v78);
end;

local function DropPositionY(p79: any, p80: number, p81: number) -- Line: 305
    local v82 = p79.AbsolutePosition.Y + p79.AbsoluteSize.Y + p81;
    local v83 = p79.AbsolutePosition.Y - p80 + p81;

    if v82 + p80 <= workspace.CurrentCamera.ViewportSize.Y then
        v83 = v82 or v83;
    end;

    return v83;
end;

local function LayoutDrop(p84: table) -- Line: 315
    -- upvalues: u7 (ref)
    local math_floor_ret = math.floor(workspace.CurrentCamera.ViewportSize.Y * 0.04);
    local math_max_ret = math.max(math_floor_ret, 22);
    local v85 = #p84 > 8;
    local v86 = 0;

    for _, v in p84 do
        v86 = math.max(v86, #v);
    end;

    u7.ScrollingFrame.Visible = not v85;
    u7.ScrollingFrame2.Visible = v85;
    u7.ScrollingFrame2.CanvasSize = UDim2.fromOffset(0, #p84 * math_max_ret);
    u7.ScrollingFrame2.CanvasPosition = Vector2.zero;
    u7.Size = UDim2.new(math.max(v86 * 0.005, 0.052), 0, 0, math.min(#p84, 8) * math_max_ret + 10);

    return v85 and u7.ScrollingFrame2 or u7.ScrollingFrame, math_max_ret;
end;

local function BindDropScrollClose() -- Line: 334
    -- upvalues: u4 (ref), UserInputService (copy), u7 (ref), u1 (copy)
    u4:Add("Drop-InputChanged", UserInputService.InputChanged:Connect(function(p87) -- Line: 335
        -- upvalues: u7 (ref), u1 (ref)
        if p87.UserInputType == Enum.UserInputType.MouseWheel then
            local Position = p87.Position;
            local AbsolutePosition = u7.AbsolutePosition;
            local AbsoluteSize = u7.AbsoluteSize;
            local v88;

            if Position.X >= AbsolutePosition.X - 10 and (Position.X <= AbsolutePosition.X + AbsoluteSize.X + 10 and Position.Y >= AbsolutePosition.Y - 10) then
                v88 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y + 10;
            else
                v88 = false;
            end;

            if not v88 then
                u1.DropDeactive("GLOBAL");
            end;
        end;
    end));
end;

local function HideDescription() -- Line: 353
    -- upvalues: TweenService (copy), u8 (ref)
    TweenService:Create(u8, TweenInfo.new(0.15), {
        GroupTransparency = 1
    }):Play();
    TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
        Transparency = 1
    }):Play();
end;

local u89 = {};

local function FitMultiDrop(p90) -- Line: 363
    -- upvalues: u89 (copy), TextService (copy)
    local TextLabel = p90.AutoLeft.TextLabel;
    local Text = TextLabel.Text;
    local v91 = u89[Text];

    if not v91 then
        local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
        GetTextBoundsParams.Text = Text;
        GetTextBoundsParams.Font = TextLabel.FontFace;
        GetTextBoundsParams.Size = 100;
        GetTextBoundsParams.Width = (1 / 0);
        local TextBoundsAsync = TextService:GetTextBoundsAsync(GetTextBoundsParams);
        v91 = TextBoundsAsync.X / TextBoundsAsync.Y;
        u89[Text] = v91;
    end;

    if TextLabel.Text ~= Text then
        return;
    end;

    local math_min_ret = math.min(0.045714285714285714 * (v91 * TextLabel.Size.Y.Scale + 1.1), 0.45);
    p90.Size = UDim2.new(math_min_ret, 10, 0.8, 0);
    p90.AutoLeft.uIPaddingauto.PaddingRight = UDim.new(0.05028571428571429 / math_min_ret, 0);
end;

local function DecodeCrosshair(u92) -- Line: 391
    -- upvalues: u11 (ref)
    if type(u92) ~= "string" then
        warn("[Decode] Ошибка: Ожидалась строка, получен " .. type(u92));

        return nil;
    end;

    if #u92 ~= 26 and (#u92 < 41 or #u92 > 59) then
        warn("[Decode] Р С›РЎв‚¬Р С‘Р В±Р С”Р В°: Р СњР ВµР Р†Р ВµРЎР‚Р Р…Р В°РЎРЏ Р Т‘Р В»Р С‘Р Р…Р В° РЎРѓРЎвЂљРЎР‚Р С•Р С”Р С‘ (" .. #u92 .. " Р Р†Р С\194\152Р ВµРЎРѓРЎвЂљР С• 26)");

        return nil;
    end;

    if not string.match(u92, "^%x+$") then
        warn("[Decode] Р С›РЎв‚¬Р С‘Р В±Р С”Р В°: Р РЋРЎвЂљРЎР‚Р С•Р С”Р В° РЎРѓР С•Р Т‘Р ВµРЎР‚Р В¶Р С‘РЎвЂљ Р Р…Р ВµР Т‘Р С•Р С—РЎС“РЎРѓРЎвЂљР С‘Р С\194\152РЎвЂ№Р Вµ РЎРѓР С‘Р С\194\152Р Р†Р С•Р В»РЎвЂ№");

        return nil;
    end;

    local function get(p93, p94) -- Line: 407
        -- upvalues: u92 (copy)
        local string_sub_ret = string.sub(u92, p93, p94);

        return tonumber(string_sub_ret, 16);
    end;

    local string_sub_ret = string.sub(u92, 19, 20);
    local v95 = tonumber(string_sub_ret, 16);
    local v96 = {};
    local v97 = {};
    local string_sub_ret2 = string.sub(u92, 1, 2);
    local v98 = tonumber(string_sub_ret2, 16);
    local string_sub_ret3 = string.sub(u92, 3, 4);
    local v99 = tonumber(string_sub_ret3, 16);
    local string_sub_ret4 = string.sub(u92, 5, 6);
    v97[1], v97[2], v97[3] = v98, v99, tonumber(string_sub_ret4, 16);
    v96["Crosshair Color"] = v97;
    local string_sub_ret5 = string.sub(u92, 7, 8);
    v96["Crosshair Gap"] = tonumber(string_sub_ret5, 16);
    local string_sub_ret6 = string.sub(u92, 9, 10);
    v96["Crosshair Length"] = tonumber(string_sub_ret6, 16);
    local string_sub_ret7 = string.sub(u92, 11, 12);
    v96["Crosshair Outline Transparency"] = tonumber(string_sub_ret7, 16) / 100;
    local string_sub_ret8 = string.sub(u92, 13, 14);
    v96["Crosshair Transparency"] = tonumber(string_sub_ret8, 16) / 100;
    local string_sub_ret9 = string.sub(u92, 15, 15);
    v96["Crosshair Outline"] = tonumber(string_sub_ret9, 16);
    local string_sub_ret10 = string.sub(u92, 16, 17);
    v96["Crosshair Thickness"] = tonumber(string_sub_ret10, 16);
    local string_sub_ret11 = string.sub(u92, 18, 18);
    v96["Crosshair Style"] = tonumber(string_sub_ret11, 16) == 1 and "Static" or "Dynamic";
    v96["Crosshair Dot Enabled"] = bit32.band(v95, 16) > 0;
    v96["Crosshair Follow Recoil"] = bit32.band(v95, 8) > 0;
    v96["Crosshair T Style"] = bit32.band(v95, 4) > 0;
    v96["Deployed Weapon Gap"] = bit32.band(v95, 2) > 0;
    v96["Use Crosshair Color for Scope Dot"] = bit32.band(v95, 1) > 0;
    local v100 = {};
    local string_sub_ret12 = string.sub(u92, 21, 22);
    local v101 = tonumber(string_sub_ret12, 16);
    local string_sub_ret13 = string.sub(u92, 23, 24);
    local v102 = tonumber(string_sub_ret13, 16);
    local string_sub_ret14 = string.sub(u92, 25, 26);
    v100[1], v100[2], v100[3] = v101, v102, tonumber(string_sub_ret14, 16);
    v96["Crosshair Outline Color"] = v100;
    v96["Crosshair Image"] = "";

    if #u92 == 26 then
        return v96;
    end;

    local Crosshair = u11.GetData().Game.Crosshair;
    local string_sub_ret15 = string.sub(u92, 41);
    local string_sub_ret16 = string.sub(u92, 27, 28);
    local v103 = tonumber(string_sub_ret16, 16);
    local string_sub_ret17 = string.sub(u92, 29, 30);
    local v104 = tonumber(string_sub_ret17, 16) / 100;
    local string_sub_ret18 = string.sub(u92, 31, 33);
    local v105 = tonumber(string_sub_ret18, 16);
    local string_sub_ret19 = string.sub(u92, 40, 40);
    local v106 = tonumber(string_sub_ret19, 16);
    local Slider = Crosshair["Crosshair Image Size"].Slider;
    local Slider2 = Crosshair["Crosshair Image Rotation"].Slider;

    if not (u11.ValidText(Crosshair["Crosshair Image"].TextBox, string_sub_ret15) and (v103 >= Slider.Min and (Slider.Max >= v103 and (v105 >= Slider2.Min and (Slider2.Max >= v105 and (v104 <= 1 and v106 <= 1)))))) then
        return nil;
    end;

    v96["Crosshair Image"] = string_sub_ret15;
    v96["Crosshair Image Size"] = v103;
    v96["Crosshair Image Transparency"] = v104;
    v96["Crosshair Image Rotation"] = v105;
    local v107 = {};
    local string_sub_ret20 = string.sub(u92, 34, 35);
    local v108 = tonumber(string_sub_ret20, 16);
    local string_sub_ret21 = string.sub(u92, 36, 37);
    local v109 = tonumber(string_sub_ret21, 16);
    local string_sub_ret22 = string.sub(u92, 38, 39);
    v107[1], v107[2], v107[3] = v108, v109, tonumber(string_sub_ret22, 16);
    v96["Crosshair Image Color"] = v107;
    v96["Pixelated Crosshair Image"] = v106 == 1;

    return v96;
end;

local function EncodeViewmodel(p110) -- Line: 464
    local v111 = 0;

    if p110["Remove Equip Animation on Hand Switch"] == true then
        v111 = v111 + 128;
    end;

    if p110["Remove Viewmodel Sway"] == true then
        v111 = v111 + 64;
    end;

    if p110["Left Arm"] == true then
        v111 = v111 + 32;
    end;

    if p110["Remove Viewmodel Texture"] == true then
        v111 = v111 + 16;
    end;

    if p110["Remove Viewmodel Sleeves"] == true then
        v111 = v111 + 8;
    end;

    if p110["Remove Viewmodel Gloves"] == true then
        v111 = v111 + 4;
    end;

    if p110["Remove Viewmodel Bobbing"] == true then
        v111 = v111 + 1;
    end;

    local v112 = math.round(p110["Viewmodel Offset X"] * 100) + 2000;
    local v113 = math.round(p110["Viewmodel Offset Y"] * 100) + 2000;
    local v114 = math.round(p110["Viewmodel Offset Z"] * 100) + 2000;

    return string.format("%02X%03X%03X%03X", v111, math.clamp(v112, 0, 4095), math.clamp(v113, 0, 4095), (math.clamp(v114, 0, 4095)));
end;

local function DecodeViewmodel(u115) -- Line: 490
    if type(u115) ~= "string" then
        warn("[Decode] Ошибка: Ожидалась строка, получен " .. type(u115));

        return nil;
    end;

    if #u115 ~= 11 then
        warn("[Decode] Ошибка: Неверная длина строки (" .. #u115 .. " вместо 11)");

        return nil;
    end;

    if not string.match(u115, "^%x+$") then
        warn("[Decode] Ошибка: Строка содержит недопустимые символы");

        return nil;
    end;

    local function _(p116, p117) -- Line: 510
        -- upvalues: u115 (copy)
        local string_sub_ret = string.sub(u115, p116, p117);

        return tonumber(string_sub_ret, 16);
    end;

    local string_sub_ret = string.sub(u115, 1, 2);
    local v118 = tonumber(string_sub_ret, 16);
    local v119 = {
        ["Left Arm"] = bit32.band(v118, 32) > 0,
        ["Remove Viewmodel Texture"] = bit32.band(v118, 16) > 0,
        ["Remove Viewmodel Sleeves"] = bit32.band(v118, 8) > 0,
        ["Remove Viewmodel Gloves"] = bit32.band(v118, 4) > 0,
        ["Remove Viewmodel Bobbing"] = bit32.band(v118, 1) > 0,
        ["Remove Viewmodel Sway"] = bit32.band(v118, 64) > 0,
        ["Remove Equip Animation on Hand Switch"] = bit32.band(v118, 128) > 0
    };
    local string_sub_ret2 = string.sub(u115, 3, 5);
    v119["Viewmodel Offset X"] = (tonumber(string_sub_ret2, 16) - 2000) / 100;
    local string_sub_ret3 = string.sub(u115, 6, 8);
    v119["Viewmodel Offset Y"] = (tonumber(string_sub_ret3, 16) - 2000) / 100;
    local string_sub_ret4 = string.sub(u115, 9, 11);
    v119["Viewmodel Offset Z"] = (tonumber(string_sub_ret4, 16) - 2000) / 100;

    return v119;
end;

local function getSavedPlayerSetting(p120, p121, p122) -- Line: 531
    if not p120 then
        return nil;
    end;

    local v123 = p120[p121];

    if v123 and v123[p122] ~= nil then
        return v123[p122];
    end;

    for _, v in p120 do
        if type(v) == "table" and v[p122] ~= nil then
            return v[p122];
        end;
    end;

    return nil;
end;

local function fireConnect(p124, p125, p126, p127) -- Line: 545
    -- upvalues: u43 (ref), u36 (copy), u46 (ref), u26 (copy), u57 (ref), u58 (ref), u27 (copy)
    u43();

    if u36[p126] then
        u46(true);
    end;

    local v128 = u26[p124];

    if v128 then
        v128 = v128[p125];
    end;

    if v128 then
        v128 = v128[p126];
    end;

    if not (v128 and next(v128) or u57 and not u58) then
        v128 = u27[p124];

        if v128 then
            v128 = v128[p125];
        end;

        if v128 then
            v128 = v128[p126];
        end;
    end;

    if not (v128 and next(v128)) then
        return;
    end;

    for _, v in v128 do
        v(p127);
    end;
end;

local u129 = {};
local u130 = {};
local u131 = {};

local function QueueSetting(p132, p133, p134, p135, p136) -- Line: 573
    -- upvalues: u129 (copy), u130 (copy), u131 (copy)
    local v137 = `{p132}/{p133}/{p134}`;

    if not u129[v137] then
        table.insert(u130, v137);
    end;

    u129[v137] = p135;
    u131[v137] = {
        Value = p136,
        Time = os.clock()
    };
end;

local function Matches(p138, p139) -- Line: 584
    if type(p138) == "table" and type(p139) == "table" then
        local v140;

        if p138[1] == p139[1] and p138[2] == p139[2] then
            v140 = p138[3] == p139[3];
        else
            v140 = false;
        end;

        return v140;
    end;

    if type(p138) == "number" and type(p139) == "number" then
        return math.abs(p138 - p139) < 0.001;
    end;

    return p138 == p139;
end;

local function firePlayerConnect(p141, p142, p143, p144) -- Line: 596
    -- upvalues: u58 (ref), u57 (ref), u27 (copy)
    if u58 and u57 then
        return;
    end;

    local v145 = u27[p141];

    if v145 then
        v145 = v145[p142];
    end;

    if v145 then
        v145 = v145[p143];
    end;

    if not (v145 and next(v145)) then
        return;
    end;

    for _, v in v145 do
        v(p144);
    end;
end;

local function restorePlayerConnect() -- Line: 617
    -- upvalues: u18 (ref), u32 (ref), u30 (ref), u27 (copy)
    u18.SetOffsetPresets(u32);

    for i, v in u30 do
        local v146 = u27[i];

        if v146 then
            for i2, v2 in v do
                local v147 = v146[i2];

                if v147 then
                    local v148 = v2;

                    for i3, v3 in v147 do
                        local v149 = v148[i3];

                        if v149 ~= nil then
                            for _, v4 in v3 do
                                task.defer(v4, v149);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

u1.FireConnection = fireConnect;
local u150 = nil;
local u151 = nil;
local u152 = nil;
local u153 = nil;
local u154 = nil;
local u155 = {};
local u156 = 0;
local u157 = { "Equip", "Inspect", "Fire", "Fire", "Fire", "Reload" };

local function OnScreen(p158: userdata) -- Line: 662
    while p158 and p158:IsA("GuiObject") do
        if not p158.Visible then
            return false;
        end;

        p158 = p158.Parent;
    end;

    local v159;

    if p158 == nil then
        v159 = false;
    else
        v159 = p158:IsA("LayerCollector") and p158.Enabled;
    end;

    return v159;
end;

local function PlayPreview(p160) -- Line: 674
    -- upvalues: u156 (ref), u157 (copy), u155 (copy), u19 (ref), u154 (ref)
    while u156 == p160 do
        for _, v in u157 do
            local v161 = u155[u19.PickVariant(u155, v)];

            if v161 then
                v161.Track.Alpha = 0;
                v161.Playing = true;
                u154 = v161;

                repeat
                    task.wait();
                until not v161.Playing or u156 ~= p160;

                if u156 ~= p160 then
                    return;
                end;
            end;
        end;

        task.wait(0.5);
    end;
end;

local function AnimatePreview(p162) -- Line: 700
    -- upvalues: u19 (ref), u155 (copy), u4 (ref), RunService (copy), OnScreen (copy), u154 (ref), PlayPreview (copy), u156 (ref)
    local Rig = u19.GetRig("Weapon", p162);

    if not Rig then
        return;
    end;

    local v163 = u19.LoadRig(Rig);
    local Rig2 = v163.Rig;
    local Scale = Viewmodel:GetScale();
    local u164 = {};

    for i, v in v163.Assets do
        u155[i] = u19.LoadAnimation(v);
    end;

    for _, v in Viewmodel:QueryDescendants("Motor6D") do
        local v165 = v.Part1 and Rig2.limb_name_to_index[v.Part1.Name];

        if v165 then
            u164[v] = Rig2.limb_transforms[v165];
        end;
    end;

    u4:Add("ViewmodelPreview", RunService.RenderStepped:Connect(function(p166) -- Line: 724
        -- upvalues: OnScreen (ref), u154 (ref), u19 (ref), Rig2 (copy), u155 (ref), u164 (copy), Scale (copy)
        if not OnScreen(ViewmodelOffsetFrame) then
            return;
        end;

        if u154 then
            u154:Step(p166);
        end;

        if not u19.Solve(Rig2, u155) then
            return;
        end;

        for i, v in u164 do
            local position = v.position;
            local quat_vector = v.quat_vector;
            i.Transform = CFrame.new(position.x * Scale, position.y * Scale, position.z * Scale, quat_vector.x, quat_vector.y, quat_vector.z, v.quat_scalar);
        end;
    end));
    task.spawn(PlayPreview, u156);
end;

local function BuildViewmodel(p167) -- Line: 752
    -- upvalues: u153 (ref), u156 (ref), u154 (ref), u4 (ref), u155 (copy), u19 (ref), u20 (ref), u17 (ref), u150 (ref), u152 (ref), u16 (ref), u151 (ref), u30 (ref), u1 (copy), AnimatePreview (copy)
    u153 = p167;
    u156 = u156 + 1;
    u154 = nil;
    u4:Remove("ViewmodelPreview");

    for i, v in u155 do
        u19.Remove(v);
        u155[i] = nil;
    end;

    if Viewmodel then
        Viewmodel:Destroy();
        Viewmodel = nil;
    end;

    local v168 = u20.Get(p167);

    if not v168 then
        return;
    end;

    local WeaponSkin = u17.GetWeaponSkin(p167, "Stock");
    u150 = WeaponSkin;
    Viewmodel = v168.Assets.Viewmodel:Clone();
    Viewmodel.Parent = workspace;
    local Viewmodel_Weapon = Viewmodel.Weapon;

    if WeaponSkin and WeaponSkin.Assets then
        for i, v in WeaponSkin.Assets do
            local v169 = Viewmodel_Weapon:FindFirstChild(i);

            if v169 then
                v:Clone().Parent = v169;
            end;
        end;
    end;

    local Viewmodel_Arms = Viewmodel.Arms;
    local ArmsSkin = u17.GetArmsSkin("StockCT");
    u152 = ArmsSkin;
    local Assets = ArmsSkin.Assets;
    local v170 = {};

    for _, child in Assets.Arms:Clone():GetChildren() do
        local v171 = Viewmodel_Arms:FindFirstChild(child.Name);
        local v172;

        if v171 then
            v172 = child;

            for _, child2 in v171:GetChildren() do
                if child2.ClassName == "Motor6D" or child2.ClassName == "Weld" then
                    child2.Parent = v172;
                end;
            end;

            if v171.Transparency ~= 1 then
                v170[v171] = v172;
            end;

            v171:Destroy();
        else
            v172 = child;
        end;

        v172.Parent = Viewmodel_Arms;
    end;

    for _, v in Viewmodel:QueryDescendants("Motor6D, Weld") do
        local v173 = v170[v.Part0];
        local v174 = v170[v.Part1];

        if v173 then
            v.Part0 = v173;
        end;

        if v174 then
            v.Part1 = v174;
        end;
    end;

    local Category = u16.GetCategory("Fingerless");
    local Item = u16.GetItem("Fingerless", "Vanilla");
    u151 = Item;
    local Model = Category.Model;

    if Model then
        Model = Model:Clone();

        for i, v in Item.Assets do
            v:Clone().Parent = Model[i];
        end;
    end;

    local Sleeves = Assets.Sleeves;

    if Sleeves then
        Sleeves = Sleeves:Clone();
    end;

    for i, v in {
        L = "Left",
        R = "Right"
    } do
        local v175 = Viewmodel_Arms:FindFirstChild(v .. " Arm");

        if v175 then
            local v176 = Model and Model:FindFirstChild("Glove" .. i);

            if v176 then
                local Weld = Instance.new("Weld");
                Weld.Part0 = v175;
                Weld.Part1 = v176;
                Weld.C0 = Category[v .. "GloveWeldPosition"];
                Weld.Parent = v175;
                v176.Parent = v175;
            end;

            if Sleeves then
                local v177 = Sleeves:FindFirstChild("Sleeve" .. i);

                if v177 then
                    local Weld = Instance.new("Weld");
                    Weld.Part0 = v175;
                    Weld.Part1 = v177;
                    Weld.C0 = ArmsSkin["Sleeve" .. v .. "Position"];
                    Weld.Parent = v175;
                    v177.Parent = v175;
                end;
            end;
        end;
    end;

    Viewmodel:PivotTo(CFrame.identity);
    Viewmodel:ScaleTo(0.15);
    local v178 = ViewmodelOffsetFrame and ViewmodelOffsetFrame:FindFirstChild("Camera");

    if v178 then
        v178.CFrame = Viewmodel.Arms.RootPart:GetPivot();
        local v179 = u30.Game and u30.Game.Gameplay;
        v178.FieldOfView = v179 and v179["Field Of View"] or 70;
    end;

    task.wait(0.1);

    if u156 ~= u156 then
        return;
    end;

    Viewmodel.Parent = ViewmodelOffsetFrame.ViewportFrame.WorldModel;
    u1.UpdateViewmodelOffset();
    AnimatePreview(p167);
end;

function u1.ViewmodelOffset(p180) -- Line: 887
    -- upvalues: u1 (copy), u30 (ref), u153 (ref), BuildViewmodel (copy)
    ViewmodelOffsetFrame = u1.viewmodelOffset();
    local Camera = Instance.new("Camera");
    Camera.Name = "Camera";
    local v181 = u30.Game and u30.Game.Gameplay;
    Camera.FieldOfView = v181 and v181["Field Of View"] or 70;
    Camera.Parent = ViewmodelOffsetFrame;
    ViewmodelOffsetFrame.ViewportFrame.CurrentCamera = Camera;
    ViewmodelOffsetFrame.Parent = p180;

    local function PresetWeapon(p182) -- Line: 899
        return p182 == "All" and "AK-47" or p182;
    end;

    u1:AddConnection("Game", "Viewmodel", "Viewmodel Preset", function(p183) -- Line: 903
        -- upvalues: u153 (ref), BuildViewmodel (ref)
        if (p183 == "All" and "AK-47" or p183) ~= u153 then
            task.defer(BuildViewmodel, p183 == "All" and "AK-47" or p183);
        end;
    end);
    local v184 = u30.Game.Viewmodel["Viewmodel Preset"];
    task.defer(BuildViewmodel, v184 == "All" and "AK-47" or v184);
    u1.UpdateRemovePreset();
end;

local u185 = {};

local function PreviewApplyNoTexture(p186, p187) -- Line: 915
    -- upvalues: u185 (copy)
    if not p186 then
        return;
    end;

    if not p187 then
        for i, v in u185 do
            if i:IsA("SurfaceAppearance") then
                i.Parent = v;
                u185[i] = nil;
            end;
        end;

        return;
    end;

    for _, v in p186:QueryDescendants("SurfaceAppearance") do
        u185[v] = v.Parent;
        v.Parent = nil;
    end;

    for _, v in p186:QueryDescendants("MeshPart") do
        v.TextureID = "";
    end;
end;

local function PreviewApplyNoGloves(p188, p189) -- Line: 938
    -- upvalues: u185 (copy)
    if not p188 then
        return;
    end;

    if p189 then
        local v190 = p188:FindFirstChild("Left Arm");
        local v191 = v190 and v190:FindFirstChild("GloveL");

        if v191 then
            u185[v191] = v190;
            v191.Parent = nil;
        end;

        local v192 = p188:FindFirstChild("Right Arm");
        local v193 = v192 and v192:FindFirstChild("GloveR");

        if v193 then
            u185[v193] = v192;
            v193.Parent = nil;
        end;
    else
        for i, v in u185 do
            if i:IsA("BasePart") and (i.Name == "GloveL" or i.Name == "GloveR") then
                i.Parent = v;
                u185[i] = nil;
            end;
        end;
    end;
end;

local function PreviewApplyNoSleeves(p194, p195) -- Line: 967
    -- upvalues: u185 (copy)
    if not p194 then
        return;
    end;

    if p195 then
        local v196 = p194:FindFirstChild("Left Arm");
        local v197 = v196 and v196:FindFirstChild("SleeveL");

        if v197 then
            u185[v197] = v196;
            v197.Parent = nil;
        end;

        local v198 = p194:FindFirstChild("Right Arm");
        local v199 = v198 and v198:FindFirstChild("SleeveR");

        if v199 then
            u185[v199] = v198;
            v199.Parent = nil;
        end;
    else
        for i, v in u185 do
            if i:IsA("BasePart") and (i.Name == "SleeveL" or i.Name == "SleeveR") then
                i.Parent = v;
                u185[i] = nil;
            end;
        end;
    end;
end;

local u200 = setmetatable({}, {
    __mode = "k"
});

local function PreviewApplyPBR(p201, p202, p203, p204) -- Line: 998
    -- upvalues: u150 (ref), u151 (ref), u152 (ref), u200 (copy)
    if p201 and (not p204 and (u150 and u150.Assets)) then
        for i, v in u150.Assets do
            local v205 = p201:FindFirstChild(i);

            if v205 then
                local v206 = v205:FindFirstChildOfClass("SurfaceAppearance");

                if p203 and u150.WorldModel then
                    if v206 then
                        v206:Destroy();
                    end;

                    local v207 = u150.WorldModel[i];

                    if v207 then
                        v205.TextureID = v207.Value;
                    end;
                elseif not v206 then
                    v205.TextureID = "";
                    v:Clone().Parent = v205;
                end;
            end;
        end;
    end;

    if not (p202 and u151) then
        return;
    end;

    for i, v in {
        L = "Left",
        R = "Right"
    } do
        local v208 = p202:FindFirstChild(v .. " Arm");

        if v208 then
            v208 = v208:FindFirstChild("Glove" .. i);
        end;

        if v208 then
            local v209 = v208:FindFirstChildOfClass("SurfaceAppearance");

            if p203 and u151.WorldModel then
                if v209 then
                    v209:Destroy();
                end;

                local v210 = u151.WorldModel["Glove" .. i];

                if v210 then
                    v208.TextureID = v210.Value;
                end;
            elseif not v209 and u151.Assets then
                v208.TextureID = "";
                local v211 = u151.Assets["Glove" .. i];

                if v211 then
                    v211:Clone().Parent = v208;
                end;
            end;
        end;
    end;

    if not (p202 and (u152 and u152.WorldModel)) then
        return;
    end;

    local WorldModel = u152.WorldModel;

    for i, v in {
        L = "Left",
        R = "Right"
    } do
        local v212 = p202:FindFirstChild(v .. " Arm");

        if v212 then
            v212 = v212:FindFirstChild("Sleeve" .. i);
        end;

        if v212 then
            if p203 then
                local v213 = v212:FindFirstChildOfClass("SurfaceAppearance");

                if v213 then
                    u200[v212] = v213;
                    v213.Parent = nil;
                end;

                local v214 = WorldModel["Sleeve" .. i];

                if v214 then
                    v212.TextureID = v214.Value;
                end;
            else
                local v215 = u200[v212];

                if v215 then
                    v212.TextureID = "";
                    v215.Parent = v212;
                    u200[v212] = nil;
                end;
            end;
        end;
    end;
end;

function u1.UpdateRemovePreset() -- Line: 1076
    -- upvalues: u30 (ref), u32 (ref)
    if not ViewmodelOffsetFrame then
        return;
    end;

    local v216 = u30.Game.Viewmodel["Viewmodel Preset"];
    local v217;

    if v216 == "All" then
        v217 = false;
    else
        v217 = u32[v216] ~= nil;
    end;

    ViewmodelOffsetFrame.RemovePreset.Visible = v217;
end;

function u1.UpdateViewmodelOffset() -- Line: 1086
    -- upvalues: u30 (ref), u185 (copy), PreviewApplyNoTexture (copy), PreviewApplyNoGloves (copy), PreviewApplyNoSleeves (copy), PreviewApplyPBR (copy), EncodeViewmodel (copy)
    if not Viewmodel then
        return;
    end;

    local v218 = ViewmodelOffsetFrame and ViewmodelOffsetFrame:FindFirstChild("Camera");

    if v218 then
        local v219 = u30.Game and u30.Game.Gameplay;
        v218.FieldOfView = v219 and v219["Field Of View"] or 70;
    end;

    local Viewmodel2 = u30.Game.Viewmodel;
    local v220 = u30.Game.Gameplay["Preferred Viewmodel Left/Right Handedness"] == "Left";
    local CFrame_new_ret = CFrame.new(Viewmodel2["Viewmodel Offset X"] / 10, Viewmodel2["Viewmodel Offset Y"] / 10, Viewmodel2["Viewmodel Offset Z"] / 10);

    if v220 then
        CFrame_new_ret = CFrame.fromMatrix(CFrame_new_ret.Position, CFrame_new_ret.XVector, CFrame_new_ret.YVector, CFrame_new_ret.ZVector * -1) * CFrame.Angles(0, 3.141592653589793, 0);
    end;

    Viewmodel:PivotTo(CFrame_new_ret);
    local v221 = Viewmodel2["Remove Viewmodel Texture"];
    local v222 = Viewmodel2["Remove Viewmodel Sleeves"];
    local v223 = Viewmodel2["Remove Viewmodel Gloves"];
    local v224 = Viewmodel2["Remove PBR Textures on Viewmodel"];
    local Arms = Viewmodel:FindFirstChild("Arms");

    for i, v in u185 do
        i.Parent = v;
    end;

    table.clear(u185);
    PreviewApplyNoTexture(Viewmodel:FindFirstChild("Weapon"), v221);
    PreviewApplyNoGloves(Arms, v223);
    PreviewApplyNoSleeves(Arms, v222);
    PreviewApplyPBR(Viewmodel:FindFirstChild("Weapon"), Arms, v224, v221);
    ViewmodelOffsetFrame.Value.TextBox.Text = EncodeViewmodel(u30.Game.Viewmodel);
end;

function u1.UpdateHudEdges() -- Line: 1134
    -- upvalues: u53 (ref), u30 (ref)
    if not u53 then
        return;
    end;

    local v225 = u30.Game["HUD & UI"];
    u53.Frame.Size = UDim2.fromScale(v225["HUD Edges Vertical"], v225["HUD Edges Horizontal"]);
end;

function u1.IsLeftSide(p226: userdata) -- Line: 1146
    -- upvalues: u9 (ref)
    local AbsoluteSize = u9.AbsoluteSize;

    return AbsoluteSize.X - p226.AbsolutePosition.X > AbsoluteSize.X / 3;
end;

function u1.CrosshairImage(p227: string) -- Line: 1153
    return `rbxthumb://type=Asset&id={p227}&w=420&h=420`;
end;

function u1.SpreadCrosshairFrame() -- Line: 1157
    -- upvalues: u30 (ref), u52 (ref), u55 (ref)
    local Crosshair = u30.Game.Crosshair;
    local Crosshair2 = u52.Crosshair;
    local v228 = Crosshair["Crosshair Gap"] + u55;
    local v229 = Crosshair["Crosshair Image Size"] + u55 * 2;
    Crosshair2.BottomFrame.Position = UDim2.new(0.5, 0, 0.5, v228);
    Crosshair2.TopFrame.Position = UDim2.new(0.5, 0, 0.5, -v228);
    Crosshair2.LeftFrame.Position = UDim2.new(0.5, -v228, 0.5, 0);
    Crosshair2.RightFrame.Position = UDim2.new(0.5, v228, 0.5, 0);
    Crosshair2.Decal.Size = UDim2.fromOffset(v229, v229);
end;

local function PreviewShown() -- Line: 1172
    -- upvalues: u52 (ref)
    local v230 = u52;

    while v230:IsA("GuiObject") do
        if not v230.Visible then
            return false;
        end;

        v230 = v230.Parent;
    end;

    return true;
end;

local function DynamicState(p231: string?) -- Line: 1186
    -- upvalues: u52 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    local State = u52.State;

    if p231 then
        State.Text = p231;
        State.TextTransparency = 0.7;
    end;

    TweenService:Create(State, TweenInfo_new_ret, {
        TextTransparency = p231 and 0.15 or 1
    }):Play();
end;

local function DynamicStep(p232: number) -- Line: 1197
    -- upvalues: u52 (ref), u1 (copy), u54 (ref), u56 (copy), TweenService (copy), TweenInfo_new_ret (copy), u30 (ref), u55 (ref)
    local v233 = u52;
    local v234;

    while true do
        if not v233:IsA("GuiObject") then
            v234 = true;
            break;
        end;

        if not v233.Visible then
            v234 = false;
            break;
        end;

        v233 = v233.Parent;
    end;

    if not v234 then
        u1.StopDynamicPreview(true);

        return;
    end;

    local v235 = u54;
    local Data = v235.Data;
    local v236 = u56[v235.Phase];

    if not v235.Stopping then
        v235.Time = v235.Time + p232;

        if v235.Time >= v236.Time then
            v235.Time = 0;
            v235.Shot = 0;
            v235.Phase = v235.Phase % #u56 + 1;
            v235.Random = Random.new(Data.Recoil.Seed);
            v236 = u56[v235.Phase];
            local Name = v236.Name;
            local State = u52.State;

            if Name then
                State.Text = Name;
                State.TextTransparency = 0.7;
            end;

            TweenService:Create(State, TweenInfo_new_ret, {
                TextTransparency = Name and 0.15 or 1
            }):Play();
        end;
    end;

    local v237 = v235.Stopping and 0 or (v236.Speed or 0);
    local Speed = v235.Speed;
    local math_min_ret = math.min(1, p232 * (v237 > 0 and 4 or 12));
    v235.Speed = math.lerp(Speed, v237, math_min_ret);

    if v236.Fire and not v235.Stopping then
        v235.Shot = v235.Shot - p232;

        if v235.Shot <= 0 then
            v235.Shot = v235.Shot + Data.FireRate[1];
            v235.Penalty = v235.Penalty + Data.Inaccuracy.Fire[1];
            v235.Punch = v235.Punch + Vector2.new(0.8, (v235.Random:NextNumber() - 0.5) * 0.8);
        end;
    end;

    local v238 = Data.Inaccuracy.Stand[1];
    local Penalty = v235.Penalty;
    local math_exp_ret = math.exp(-p232 * v235.Decay / Data.Recovery.Stand);
    v235.Penalty = math.lerp(v238, Penalty, math_exp_ret);
    v235.Punch = v235.Punch * math.exp(-p232 * 6);
    local Crosshair = u30.Game.Crosshair;
    local v239 = math.rad(u30.Game.Gameplay["Field Of View"]) * 0.5;
    local math_tan_ret = math.tan(v239);
    local v240 = math.clamp((v235.Speed - v235.Duck) / (v235.Threshold - v235.Duck), 0, 1) ^ v235.Exponent;
    local v241 = Data.Inaccuracy.Stand[1];
    local v242 = math.min(1, v235.Penalty + v240 * Data.Inaccuracy.Move[1]) - v241;
    local v243 = (v241 + math.max(0, v242) * v235.NonIdleSpreadScale + Data.Spread[1]) * v235.SpreadScale * 320 / math_tan_ret;
    local math_clamp_ret = math.clamp(v243, 0, 250);
    local Offset = v235.Offset;
    local math_min_ret2 = math.min(1, p232 * 12);
    v235.Offset = math.lerp(Offset, math_clamp_ret, math_min_ret2);
    u55 = v235.Offset + (Crosshair["Deployed Weapon Gap"] and Data.CrosshairMinDistance - 4 or 0);
    local v244 = Crosshair["Crosshair Follow Recoil"] and v235.Punch or Vector2.zero;
    local v245 = workspace.CurrentCamera.ViewportSize.Y * 0.5 / math_tan_ret;
    local Crosshair2 = u52.Crosshair;
    local UDim2_new = UDim2.new;
    local math_rad_ret = math.rad(v244.Y);
    local v246 = -math.tan(math_rad_ret) * v245;
    local math_rad_ret2 = math.rad(v244.X);
    Crosshair2.Position = UDim2_new(0.5, v246, 0.5, -math.tan(math_rad_ret2) * v245);
    u1.SpreadCrosshairFrame();

    if v235.Stopping and (v240 == 0 and (v235.Punch.Magnitude < 0.01 and math.abs(v235.Offset - math_clamp_ret) < 0.1)) then
        u1.StopDynamicPreview(true);
    end;
end;

function u1.StartDynamicPreview() -- Line: 1261
    -- upvalues: u54 (ref), u20 (ref), u25 (ref), u24 (ref), u4 (ref), RunService (copy), DynamicStep (copy), u52 (ref), u56 (copy), TweenService (copy), TweenInfo_new_ret (copy)
    if not u54 then
        local Data = u20.Get("AK-47").Data;
        u54 = {
            Phase = 1,
            Time = 0,
            Shot = 0,
            Speed = 0,
            Offset = 0,
            Data = Data,
            Penalty = Data.Inaccuracy.Stand[1],
            Punch = Vector2.zero,
            Random = Random.new(Data.Recoil.Seed),
            Duck = u25.ConstantsTemplate.DuckModifier,
            Threshold = u24.Get("Weapon", "MovementThreshold"),
            Exponent = u24.Get("Weapon", "MovementCurveExponent"),
            Decay = u24.Get("Weapon", "RecoilDecayBase"),
            SpreadScale = u24.Get("Weapon", "SpreadScale") or 1,
            NonIdleSpreadScale = u24.Get("Weapon", "NonIdleSpreadScale") or 1
        };
        u4:Add("DynamicPreview", RunService.Heartbeat:Connect(DynamicStep));
    end;

    u54.Stopping = false;
    u52.Dynamic.Title.Text = "Stop Dynamic Preview";
    local Name = u56[u54.Phase].Name;
    local State = u52.State;

    if Name then
        State.Text = Name;
        State.TextTransparency = 0.7;
    end;

    TweenService:Create(State, TweenInfo_new_ret, {
        TextTransparency = Name and 0.15 or 1
    }):Play();
end;

function u1.StopDynamicPreview(p247: boolean?) -- Line: 1292
    -- upvalues: u54 (ref), u52 (ref), TweenService (copy), TweenInfo_new_ret (copy), u4 (ref), u55 (ref), u1 (copy)
    if not u54 then
        return;
    end;

    u52.Dynamic.Title.Text = "Start Dynamic Preview";
    TweenService:Create(u52.State, TweenInfo_new_ret, {
        TextTransparency = 1
    }):Play();

    if not p247 then
        u54.Stopping = true;

        return;
    end;

    u54 = nil;
    u4:Remove("DynamicPreview");
    u55 = 0;
    u52.Crosshair.Position = UDim2.fromScale(0.5, 0.5);
    u1.SpreadCrosshairFrame();
end;

function u1.DynamicPreviewVisible(p248: boolean) -- Line: 1313
    -- upvalues: u52 (ref), u1 (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local Dynamic = u52.Dynamic;

    if Dynamic.Visible == p248 then
        return;
    end;

    Dynamic.Visible = p248;

    if not p248 then
        u1.StopDynamicPreview(true);

        return;
    end;

    Dynamic.Position = UDim2.new(0.02, 0, 0.98, 6);
    Dynamic.Title.TextTransparency = 1;
    TweenService:Create(Dynamic, TweenInfo_new_ret, {
        Position = UDim2.fromScale(0.02, 0.98)
    }):Play();
    TweenService:Create(Dynamic.Title, TweenInfo_new_ret, {
        TextTransparency = 0
    }):Play();
end;

function u1.UpdateCrosshairFrame() -- Line: 1334
    -- upvalues: u52 (ref), u30 (ref), u1 (copy), EncodeCrosshair (copy), TweenService (copy), TweenInfo_new_ret (copy)
    if not u52 then
        return;
    end;

    local v249 = u30.Game and u30.Game.Crosshair;

    if not v249 then
        return;
    end;

    local v250 = v249["Crosshair Length"] or 2;
    local v251 = v249["Crosshair Thickness"] or 4;
    local v252 = v249["Crosshair Transparency"] or 0;
    local v253 = v249["Crosshair Dot Enabled"];
    local v254 = v249["Crosshair Outline"] or 1;
    local v255 = v249["Crosshair Outline Transparency"] or 0;
    local v256 = v249["Crosshair Outline Color"] or { 0, 0, 0 };
    local v257 = v249["Crosshair T Style"];
    local v258 = v249["Crosshair Color"] or { 22, 122, 255 };
    local v259 = v249["Crosshair Image"];
    local v260 = v259 ~= "";
    local Crosshair = u52:FindFirstChild("Crosshair");

    if not Crosshair then
        return;
    end;

    u1.SpreadCrosshairFrame();
    Crosshair.BottomFrame.Size = UDim2.fromOffset(v251, v250);
    Crosshair.TopFrame.Size = UDim2.fromOffset(v251, v250);
    Crosshair.LeftFrame.Size = UDim2.fromOffset(v250, v251);
    Crosshair.RightFrame.Size = UDim2.fromOffset(v250, v251);
    Crosshair.Dot.Size = UDim2.fromOffset(v251, v251);
    local v261 = typeof(v258) == "Color3" and v258 and v258 or Color3.fromRGB(unpack(v258));
    local v262 = typeof(v256) == "Color3" and v256 and v256 or Color3.fromRGB(unpack(v256));
    Crosshair.BottomFrame.BackgroundColor3 = v261;
    Crosshair.TopFrame.BackgroundColor3 = v261;
    Crosshair.LeftFrame.BackgroundColor3 = v261;
    Crosshair.RightFrame.BackgroundColor3 = v261;
    Crosshair.Dot.BackgroundColor3 = v261;
    Crosshair.BottomFrame.BackgroundTransparency = v252;
    Crosshair.TopFrame.BackgroundTransparency = v252;
    Crosshair.LeftFrame.BackgroundTransparency = v252;
    Crosshair.RightFrame.BackgroundTransparency = v252;
    Crosshair.Dot.BackgroundTransparency = v252;
    local v263;

    if v253 == true then
        v263 = not v260;
    else
        v263 = false;
    end;

    Crosshair.Dot.Visible = v263;
    Crosshair.TopFrame.Visible = not (v257 or v260);
    Crosshair.BottomFrame.Visible = not v260;
    Crosshair.LeftFrame.Visible = not v260;
    Crosshair.RightFrame.Visible = not v260;
    Crosshair.Decal.Visible = v260;

    if v260 then
        Crosshair.Decal.Image = u1.CrosshairImage(v259);
        Crosshair.Decal.ImageColor3 = Color3.fromRGB(unpack(v249["Crosshair Image Color"]));
        Crosshair.Decal.ImageTransparency = v249["Crosshair Image Transparency"];
        Crosshair.Decal.Rotation = v249["Crosshair Image Rotation"];
        Crosshair.Decal.ResampleMode = v249["Pixelated Crosshair Image"] and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default;
    end;

    u1.DynamicPreviewVisible(v249["Crosshair Style"] == "Dynamic");

    for _, child in Crosshair:GetChildren() do
        if child:IsA("Frame") then
            local Border = child:FindFirstChild("Border");

            if Border and Border:IsA("UIStroke") then
                if v254 == 0 then
                    Border.Enabled = false;
                else
                    Border.Transparency = v255;
                    Border.Color = v262;
                    Border.Thickness = v254;
                    Border.Enabled = true;
                end;
            end;
        end;
    end;

    if u52:FindFirstChild("Value") and u52.Value:FindFirstChild("TextBox") then
        local v264 = EncodeCrosshair(v249);
        u52.Value.TextBox.Text = v264;
        TweenService:Create(u52.Value, TweenInfo_new_ret, {
            Size = UDim2.fromScale(math.clamp(#v264 * 0.0125, 0.34, 0.64), 0.07)
        }):Play();
    end;
end;

function u1.SidePreview(u265: userdata, u266: userdata) -- Line: 1430
    -- upvalues: u1 (copy), TweenService (copy)
    local u267 = u1.previewUI();
    local Scale = u265.Position.Y.Scale;
    local u268 = Scale + u265.Size.Y.Scale / 2;
    u267.AnchorPoint = Vector2.new(0, 0.5);
    u267.Position = UDim2.fromScale(0.015, u268);
    u267.Visible = u265.Visible;
    u267.Parent = u265.Parent;
    u266.Size = UDim2.fromScale(1, 1);
    u266.Parent = u267;
    u265.AnchorPoint = Vector2.new(1, 0);
    u265.Position = UDim2.fromScale(0.985, Scale);
    u265:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1446
        -- upvalues: u267 (copy), u265 (copy), u268 (copy), Scale (copy), u266 (copy), TweenService (ref)
        u267.Visible = u265.Visible;

        if not u265.Visible then
            return;
        end;

        u267.Position = UDim2.new(0.015, -16, u268, 0);
        u265.Position = UDim2.new(0.985, 0, Scale, 12);
        u266.ImageTransparency = 1;
        TweenService:Create(u267, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {
            Position = UDim2.fromScale(0.015, u268)
        }):Play();
        TweenService:Create(u265, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {
            Position = UDim2.fromScale(0.985, Scale)
        }):Play();
        TweenService:Create(u266, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
            ImageTransparency = 0
        }):Play();
    end);
end;

function u1.TrackChanged(p269: string, p270: string, p271: string, u272: any, p273: userdata, u274: any, p275: userdata) -- Line: 1463
    -- upvalues: u1 (copy), u44 (ref), u38 (copy)
    local v276 = u272.Slider and p273.SlideText or u272.Toggle and p273.ToggleName or (u272.TextBox and p273.BoxTitle or u272.Keybind and p273.BindTitle or (u272.ColorPicker and p273.colortitle or p273.TextLabel));
    local v277 = u1.changedDot();
    v277.Parent = p273;
    local u278 = {
        Changed = false,
        Tab = p269,
        Page = p270,
        Name = p271,
        Info = u272,
        Frame = p273,
        Label = v276,
        Dot = v277,
        PageFrame = p275,

        Reset = function() -- Line: 1480, Name: Reset
            -- upvalues: u272 (copy), u274 (copy)
            if u272.Keybind then
                u274.Reset();

                return;
            end;

            if u272.ColorPicker then
                u274.SetValue(Color3.fromRGB(unpack(u272.Default)));

                return;
            end;

            if u272.TextBox then
                u274.SetDefault(u274);

                return;
            end;

            u274.SetValue(u272.Default);
        end
    };
    v276:GetPropertyChangedSignal("TextBounds"):Connect(function() -- Line: 1492
        -- upvalues: u278 (copy), u44 (ref)
        if u278.Changed then
            u44(u278);
        end;
    end);
    table.insert(u38, u278);
end;

function u1.NewSection(p279: string, p280: userdata, p281: any) -- Line: 1501
    -- upvalues: u1 (copy)
    local v282 = u1.sectionUI();
    v282.LayoutOrder = p281;
    v282.Title.Text = p279;
    v282.Parent = p280;

    return v282;
end;

function u1.SlideUpdate(p283: number, p284: number, p285: userdata, p286: userdata, p287: userdata, p288: string, p289: boolean, p290: boolean, p291: any, p292: number, p293: boolean, p294: number?, p295: table?) -- Line: 1512
    -- upvalues: LocalPlayer (copy), TweenService (copy), u1 (copy), u13 (ref)
    local v296 = p294 or (LocalPlayer and LocalPlayer:GetMouse().X or 0);
    local math_max_ret = math.max(1, p285.AbsoluteSize.X);
    local v297 = (v296 - p285.AbsolutePosition.X) / math_max_ret;
    local v298;

    if p295 then
        if p292 then
            local table_find_ret = table.find(p295, p292);

            if table_find_ret then
                v298 = (table_find_ret - 1) / (#p295 - 1);
            else
                local v299 = (1 / 0);
                local v300 = 1;

                for i, v in p295 do
                    local math_abs_ret = math.abs(v - p292);

                    if math_abs_ret < v299 then
                        v300 = i;
                        v299 = math_abs_ret;
                    end;
                end;

                v298 = (v300 - 1) / (#p295 - 1);
                p292 = p295[v300];
            end;
        else
            local math_clamp_ret = math.clamp(v297, 0, 1);
            local math_round_ret = math.round(1 + (#p295 - 1) * math_clamp_ret);
            local math_clamp_ret2 = math.clamp(math_round_ret, 1, #p295);
            v298 = (math_clamp_ret2 - 1) / (#p295 - 1);
            p292 = p295[math_clamp_ret2];
        end;
    else
        if p292 then
            v297 = (p292 - p283) / (p284 - p283);
        end;

        v298 = math.clamp(v297, 0, 1);

        if p289 then
            if not p292 then
                local string_format = string.format;
                local v301 = tostring(p283 + (p284 - p283) * v298);
                p292 = tonumber(string_format("%.1f", v301));
            end;
        else
            p292 = p292 or math.round(p283 + (p284 - p283) * v298);
        end;
    end;

    local math_clamp_ret = math.clamp(v298, 0, 1);
    TweenService:Create(p286, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(math_clamp_ret, 0, 1, 0)
    }):Play();

    if not p293 and u1.flags[p288] ~= tonumber(p292) then
        u13.Play("UI.mainmenu_rollover");
    end;

    p287.Text = tostring(p292);
    u1.flags[p288] = tonumber(p292);

    if p290 and p291 then
        p291((tonumber(p292)));
    end;

    return tonumber(p292);
end;

function u1.NewSlider(u302: string, p303: userdata, u304: number, p305: number, u306: number, u307: number, u308: boolean, u309: any, p310: number, p311: string, u312: string, u313: table?) -- Line: 1572
    -- upvalues: u1 (copy), u4 (ref), Mouse (copy), UserInputService (copy), TweenService (copy), u7 (ref), u8 (ref), FitDescriptionSize (copy), PositionDescription (copy)
    local u314 = u1.sliderUI();
    u314.LayoutOrder = p310 or 1;
    u314.SlideText.Text = u302;
    u314.Name = p311 or "Frame";
    u314.Parent = p303;
    u1.flags[u302] = p305;
    local u315 = false;
    local Scroll = u314.Scroll;
    local TextBox = u314.Value.TextBox;
    local u316 = p305;
    local u317 = nil;

    local function EndDrag(p318) -- Line: 1592
        -- upvalues: u315 (ref), u317 (ref), u4 (ref), u302 (copy), Mouse (ref), u316 (ref), u1 (ref), u306 (copy), u307 (copy), Scroll (copy), TextBox (copy), u308 (copy), u309 (copy), u313 (copy)
        if not u315 then
            return;
        end;

        local v319 = u317;

        if v319 then
            if u317.UserInputType == Enum.UserInputType.MouseButton1 then
                v319 = not p318 or p318.UserInputType == Enum.UserInputType.MouseButton1;
            else
                v319 = false;
            end;
        end;

        local v320;

        if p318 == u317 then
            v320 = true;
        else
            v320 = not p318 and u317 and u317.UserInputType == Enum.UserInputType.Touch;
        end;

        if v319 or (v320 or p318 and (p318.UserInputType == Enum.UserInputType.MouseButton1 or p318.UserInputType == Enum.UserInputType.Touch)) then
            u315 = false;
            u317 = nil;
            u4:Removes((`{u302}_InputSlide`));
            u316 = u1.SlideUpdate(u306, u307, Scroll, Scroll.Scroll.Bar, TextBox, u302, u308, true, u309, nil, false, p318 and (p318.Position and p318.Position.X) or Mouse and Mouse.X, u313);
        end;
    end;

    Scroll.InputBegan:Connect(function(p321) -- Line: 1610
        -- upvalues: u315 (ref), u317 (ref), Mouse (ref), u316 (ref), u1 (ref), u306 (copy), u307 (copy), Scroll (copy), TextBox (copy), u302 (copy), u308 (copy), u313 (copy), u4 (ref), UserInputService (ref)
        if p321.UserInputType == Enum.UserInputType.MouseButton1 or p321.UserInputType == Enum.UserInputType.Touch then
            u315 = true;
            u317 = p321;
            u316 = u1.SlideUpdate(u306, u307, Scroll, Scroll.Scroll.Bar, TextBox, u302, u308, false, nil, nil, false, p321.Position and p321.Position.X or Mouse and Mouse.X, u313);
            u4:Add(`{u302}_InputSlide`, UserInputService.InputChanged:Connect(function(p322) -- Line: 1618
                -- upvalues: u317 (ref), Mouse (ref), u316 (ref), u1 (ref), u306 (ref), u307 (ref), Scroll (ref), TextBox (ref), u302 (ref), u308 (ref), u313 (ref)
                local v323 = u317;

                if v323 then
                    if u317.UserInputType == Enum.UserInputType.MouseButton1 then
                        v323 = p322.UserInputType == Enum.UserInputType.MouseMovement;
                    else
                        v323 = false;
                    end;
                end;

                local v324;

                if p322 == u317 then
                    v324 = true;
                else
                    v324 = u317;

                    if v324 then
                        if u317.UserInputType == Enum.UserInputType.Touch then
                            v324 = p322.UserInputType == Enum.UserInputType.Touch;
                        else
                            v324 = false;
                        end;
                    end;
                end;

                if v323 or v324 then
                    u316 = u1.SlideUpdate(u306, u307, Scroll, Scroll.Scroll.Bar, TextBox, u302, u308, false, nil, nil, false, p322.Position and p322.Position.X or Mouse and Mouse.X, u313);
                end;
            end));
        end;
    end);
    UserInputService.InputEnded:Connect(EndDrag);
    u314.MouseEnter:Connect(function() -- Line: 1631
        -- upvalues: TweenService (ref), u314 (copy), u312 (copy), u7 (ref), u8 (ref), FitDescriptionSize (ref), PositionDescription (ref)
        TweenService:Create(u314.SlideText, TweenInfo.new(0.15), {
            TextTransparency = 0
        }):Play();

        if not (u312 and (u312 ~= "" and not u7:GetAttribute("Visible"))) then
            return;
        end;

        u8.ItemText.Text = u312;
        FitDescriptionSize(u8);
        PositionDescription(u8, u314);
        TweenService:Create(u8, TweenInfo.new(0.15), {
            GroupTransparency = 0
        }):Play();
        TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
            Transparency = 0.5
        }):Play();
    end);
    u314.MouseLeave:Connect(function() -- Line: 1656
        -- upvalues: TweenService (ref), u314 (copy), u8 (ref)
        TweenService:Create(u314.SlideText, TweenInfo.new(0.15), {
            TextTransparency = 0.35
        }):Play();
        TweenService:Create(u8, TweenInfo.new(0.15), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
            Transparency = 1
        }):Play();
    end);
    u314.Scroll.InputEnded:Connect(EndDrag);
    u316 = u1.SlideUpdate(u306, u307, Scroll, Scroll.Scroll.Bar, TextBox, u302, u308, false, u309, p305, false, nil, u313);
    TextBox.Focused:Connect(function() -- Line: 1666
        -- upvalues: u4 (ref), u302 (copy), TextBox (copy), u313 (copy), u316 (ref), u1 (ref), u306 (copy), u307 (copy), Scroll (copy), u308 (copy), u309 (copy)
        u4:Add(`{u302}_BoxSignal`, TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1669
            -- upvalues: TextBox (ref), u313 (ref), u316 (ref), u1 (ref), u306 (ref), u307 (ref), Scroll (ref), u302 (ref), u308 (ref), u309 (ref)
            local v325 = TextBox.Text:gsub("[^%d%.%-]", ""):match("^%-?%d*%.?%d?%d?%d?");

            if v325 and TextBox.Text ~= v325 then
                TextBox.Text = v325;
            end;

            local Text = TextBox.Text;

            if tonumber(Text) then
                local v326 = tonumber(Text);

                if u313 then
                    if table.find(u313, v326) then
                        u316 = u1.SlideUpdate(u306, u307, Scroll, Scroll.Scroll.Bar, TextBox, u302, u308, true, u309, v326, false, nil, u313);
                    end;
                else
                    if u307 < v326 then
                        Text = tostring(u307);
                        TextBox.Text = Text;
                    end;

                    if u306 <= tonumber(Text) and (string.sub(Text, -1) ~= "." and not string.match(Text, "%.%d*0$")) then
                        u316 = u1.SlideUpdate(u306, u307, Scroll, Scroll.Scroll.Bar, TextBox, u302, u308, true, u309, (tonumber(Text)));
                    end;
                end;
            end;
        end));
    end);
    TextBox.FocusLost:Connect(function() -- Line: 1701
        -- upvalues: TextBox (copy), u316 (ref), u313 (copy), u1 (ref), u306 (copy), u307 (copy), Scroll (copy), u302 (copy), u308 (copy), u309 (copy), u4 (ref)
        local v327 = tonumber(TextBox.Text);

        if TextBox.Text == "" or not v327 then
            TextBox.Text = tostring(u316);
        elseif u313 then
            u316 = u1.SlideUpdate(u306, u307, Scroll, Scroll.Scroll.Bar, TextBox, u302, u308, true, u309, v327, false, nil, u313);
        elseif v327 < u306 then
            TextBox.Text = tostring(u316);
        else
            u316 = u1.SlideUpdate(u306, u307, Scroll, Scroll.Scroll.Bar, TextBox, u302, u308, true, u309, v327);
        end;

        if TextBox.Text == "-0" then
            TextBox.Text = "0";
        end;

        u4:Removes((`{u302}_BoxSignal`));
    end);
    local v331 = {
        SetDefault = function(p328) -- Line: 1727
            -- upvalues: u316 (ref), u1 (ref), u306 (copy), u307 (copy), Scroll (copy), TextBox (copy), u302 (copy), u308 (copy), u309 (copy), u304 (copy), u313 (copy)
            u316 = u1.SlideUpdate(u306, u307, Scroll, Scroll.Scroll.Bar, TextBox, u302, u308, true, u309, u304, false, nil, u313);
        end,

        SetValue = function(p329, p330) -- Line: 1731
            -- upvalues: TextBox (copy), u316 (ref), u1 (ref), u306 (copy), u307 (copy), Scroll (copy), u302 (copy), u308 (copy), u309 (copy), u313 (copy)
            if TextBox:IsFocused() then
                return;
            end;

            u316 = u1.SlideUpdate(u306, u307, Scroll, Scroll.Scroll.Bar, TextBox, u302, u308, not p330, u309, p329, true, nil, u313);
        end
    };
    v331.SetValue(p305, true);
    u1.Sliders[Scroll] = {
        Name = u302,
        Min = u306,
        Max = u307,
        Percent = u308,
        Values = u313,
        Set = v331.SetValue
    };
    Scroll.NextSelectionLeft = Scroll;
    Scroll.NextSelectionRight = Scroll;

    return u314, v331;
end;

function u1.NewNull(p332: userdata, p333: any) -- Line: 1756
    -- upvalues: u1 (copy)
    local v334 = u1.nullUI();
    v334.LayoutOrder = p333;
    v334.Parent = p332;

    return v334;
end;

function u1.ToggleUpdate(p335: string, p336: userdata, p337: any, p338: boolean, p339: boolean, p340: boolean) -- Line: 1763
    -- upvalues: u1 (copy), u13 (ref), TweenService (copy)
    local ImageLabel = p336.ImageLabel;

    if p338 == nil then
        p338 = not u1.flags[p335];
    end;

    local v341 = p338 and Color3.fromRGB(167, 255, 135) or Color3.fromRGB(0, 0, 0);

    if not p340 then
        u13.Play("UI.mainmenu_rollover");
    end;

    TweenService:Create(ImageLabel, TweenInfo.new(0.25), {
        BackgroundColor3 = v341
    }):Play();
    TweenService:Create(ImageLabel, TweenInfo.new(0.25), {
        BackgroundTransparency = p338 and 0.2 or 0.8
    }):Play();
    u1.flags[p335] = p338;

    if p339 or not p339 and p339 ~= false then
        p337(p338);
    end;
end;

function u1.NewToggle(u342: string, p343: userdata, u344: boolean, p345: boolean, u346: any, p347: any, u348: string) -- Line: 1788
    -- upvalues: u1 (copy), TweenService (copy), u7 (ref), u8 (ref), FitDescriptionSize (copy), PositionDescription (copy)
    local u349 = u1.toggleUI();
    u349.LayoutOrder = p347;
    u349.ToggleName.Text = u342;
    u349.Parent = p343;
    u1.flags[u342] = p345;
    local u350 = false;

    if p345 or p345 == false then
        u1.ToggleUpdate(u342, u349, u346, p345, false);
    end;

    u349.MouseButton1Click:Connect(function() -- Line: 1807
        -- upvalues: u350 (ref), u1 (ref), u342 (copy), u349 (copy), u346 (copy)
        if u350 then
            return;
        end;

        u350 = true;
        task.delay(0.13, function() -- Line: 1814
            -- upvalues: u350 (ref)
            u350 = false;
        end);
        u1.ToggleUpdate(u342, u349, u346);
    end);
    u349.MouseEnter:Connect(function() -- Line: 1821
        -- upvalues: TweenService (ref), u349 (copy), u348 (copy), u7 (ref), u8 (ref), FitDescriptionSize (ref), PositionDescription (ref)
        TweenService:Create(u349.ToggleName, TweenInfo.new(0.15), {
            TextTransparency = 0
        }):Play();

        if not (u348 and (u348 ~= "" and not u7:GetAttribute("Visible"))) then
            return;
        end;

        u8.ItemText.Text = u348;
        FitDescriptionSize(u8);
        PositionDescription(u8, u349);
        TweenService:Create(u8, TweenInfo.new(0.15), {
            GroupTransparency = 0
        }):Play();
        TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
            Transparency = 0.5
        }):Play();
    end);
    u349.MouseLeave:Connect(function() -- Line: 1846
        -- upvalues: TweenService (ref), u349 (copy), u8 (ref)
        TweenService:Create(u349.ToggleName, TweenInfo.new(0.15), {
            TextTransparency = 0.35
        }):Play();
        TweenService:Create(u8, TweenInfo.new(0.15), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
            Transparency = 1
        }):Play();
    end);

    return u349, {
        SetDefault = function(p351) -- Line: 1856
            -- upvalues: u1 (ref), u342 (copy), u349 (copy), u346 (copy), u344 (copy)
            u1.ToggleUpdate(u342, u349, u346, u344);
        end,

        SetValue = function(p352, p353) -- Line: 1859
            -- upvalues: u1 (ref), u342 (copy), u349 (copy), u346 (copy)
            u1.ToggleUpdate(u342, u349, u346, p352, not p353, true);
        end
    };
end;

function u1.NewTextBox(u354: string, p355: userdata, u356: string, p357: string, u358: any, u359: any, p360: any, u361: string) -- Line: 1866
    -- upvalues: u1 (copy), TweenService (copy), u7 (ref), u8 (ref), FitDescriptionSize (copy), PositionDescription (copy), u13 (ref), u4 (ref), u11 (ref)
    local u362 = u1.textBoxUI();
    u362.LayoutOrder = p360;
    u362.BoxTitle.Text = u354;
    u362.Parent = p355;
    local Value = u362.Value;
    local TextBox = Value.TextBox;
    local Count = Value.Count;
    local UIStroke = Value.UIStroke;
    local u363 = p357;
    TextBox.PlaceholderText = u358.Placeholder or "";
    TextBox.Text = p357;
    u1.flags[u354] = p357;

    local function Commit(p364: string, p365: boolean) -- Line: 1884
        -- upvalues: u363 (ref), TextBox (copy), u1 (ref), u354 (copy), u359 (copy)
        local v366 = p364 ~= u363;
        u363 = p364;
        TextBox.Text = p364;
        u1.flags[u354] = p364;

        if p365 and v366 then
            u359(p364);
        end;
    end;

    local function _() -- Line: 1896
        -- upvalues: Count (copy), TextBox (copy), u358 (copy)
        Count.Text = `{#TextBox.Text}/{u358.MaxLength}`;
    end;

    u362.MouseEnter:Connect(function() -- Line: 1900
        -- upvalues: TweenService (ref), u362 (copy), u361 (copy), u7 (ref), u8 (ref), FitDescriptionSize (ref), PositionDescription (ref)
        TweenService:Create(u362.BoxTitle, TweenInfo.new(0.15), {
            TextTransparency = 0
        }):Play();

        if not (u361 and (u361 ~= "" and not u7:GetAttribute("Visible"))) then
            return;
        end;

        u8.ItemText.Text = u361;
        FitDescriptionSize(u8);
        PositionDescription(u8, u362);
        TweenService:Create(u8, TweenInfo.new(0.15), {
            GroupTransparency = 0
        }):Play();
        TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
            Transparency = 0.5
        }):Play();
    end);
    u362.MouseLeave:Connect(function() -- Line: 1915
        -- upvalues: TweenService (ref), u362 (copy), u8 (ref)
        TweenService:Create(u362.BoxTitle, TweenInfo.new(0.15), {
            TextTransparency = 0.35
        }):Play();
        TweenService:Create(u8, TweenInfo.new(0.15), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
            Transparency = 1
        }):Play();
    end);
    TextBox.Focused:Connect(function() -- Line: 1921
        -- upvalues: u13 (ref), Count (copy), TextBox (copy), u358 (copy), TweenService (ref), UIStroke (copy), u4 (ref), u354 (copy), u11 (ref)
        u13.Play("UI.submenu_click");
        Count.Text = `{#TextBox.Text}/{u358.MaxLength}`;
        TweenService:Create(UIStroke, TweenInfo.new(0.2), {
            Transparency = 0.4
        }):Play();
        TweenService:Create(Count, TweenInfo.new(0.2), {
            TextTransparency = 0.5
        }):Play();
        u4:Add(`{u354}_BoxSignal`, TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1928
            -- upvalues: u11 (ref), u358 (ref), TextBox (ref), Count (ref)
            local v367 = u11.CleanText(u358, TextBox.Text);

            if TextBox.Text == v367 then
                Count.Text = `{#TextBox.Text}/{u358.MaxLength}`;

                return;
            end;

            TextBox.Text = v367;
        end));
    end);
    TextBox.FocusLost:Connect(function() -- Line: 1940
        -- upvalues: u4 (ref), u354 (copy), TweenService (ref), Count (copy), u11 (ref), u358 (copy), TextBox (copy), u363 (ref), UIStroke (copy), u13 (ref), u1 (ref), u359 (copy)
        u4:Remove((`{u354}_BoxSignal`));
        TweenService:Create(Count, TweenInfo.new(0.2), {
            TextTransparency = 1
        }):Play();
        local v368 = u11.CleanText(u358, TextBox.Text);

        if not u11.ValidText(u358, v368) then
            TextBox.Text = u363;
            UIStroke.Color = Color3.fromRGB(255, 151, 153);
            UIStroke.Transparency = 0.2;
            TweenService:Create(UIStroke, TweenInfo.new(0.6), {
                Transparency = 0.8,
                Color = Color3.new(1, 1, 1)
            }):Play();
            u13.Play("UI.mainmenu_rollover");

            return;
        end;

        TweenService:Create(UIStroke, TweenInfo.new(0.2), {
            Transparency = 0.8
        }):Play();

        if v368 ~= u363 then
            u13.Play("UI.submenu_dropdown_option_select");
        end;

        local v369 = v368 ~= u363;
        u363 = v368;
        TextBox.Text = v368;
        u1.flags[u354] = v368;

        if v369 then
            u359(v368);
        end;
    end);
    u362.Reset.MouseButton1Click:Connect(function() -- Line: 1967
        -- upvalues: u13 (ref), u356 (copy), u363 (ref), TextBox (copy), u1 (ref), u354 (copy), u359 (copy)
        u13.Play("UI.submenu_click");
        local v370 = u356;
        local v371 = v370 ~= u363;
        u363 = v370;
        TextBox.Text = v370;
        u1.flags[u354] = v370;

        if v371 then
            u359(v370);
        end;
    end);

    return u362, {
        SetDefault = function(p372) -- Line: 1974
            -- upvalues: u356 (copy), u363 (ref), TextBox (copy), u1 (ref), u354 (copy), u359 (copy)
            local v373 = u356;
            local v374 = v373 ~= u363;
            u363 = v373;
            TextBox.Text = v373;
            u1.flags[u354] = v373;

            if v374 then
                u359(v373);
            end;
        end,

        SetValue = function(p375, p376) -- Line: 1977
            -- upvalues: TextBox (copy), u363 (ref), u1 (ref), u354 (copy), u359 (copy)
            if TextBox:IsFocused() then
                return;
            end;

            local v377 = p375 ~= u363;
            u363 = p375;
            TextBox.Text = p375;
            u1.flags[u354] = p375;

            if not p376 and v377 then
                u359(p375);
            end;
        end
    };
end;

local u378 = {
    Return = true,
    Backquote = true,
    CapsLock = true,
    Escape = true
};
local u379 = {
    Unknown = true,
    Thumbstick1 = true,
    Thumbstick2 = true
};
local u380 = {
    RightControl = "Right Ctrl",
    LeftControl = "Left Ctrl",
    LeftShift = "Left Shift",
    RightShift = "Right Shift",
    Semicolon = ";",
    Quote = "\"",
    LeftBracket = "[",
    RightBracket = "]",
    Equals = "=",
    Minus = "-",
    RightAlt = "Right Alt",
    LeftAlt = "LeftAlt",
    One = "1",
    Two = "2",
    Three = "3",
    Four = "4",
    Five = "5",
    Six = "6",
    Seven = "7",
    Eight = "8",
    Nine = "9",
    Zero = "0",
    Comma = ",",
    Period = ".",
    MouseButton1 = "Left Mouse Button",
    MouseButton2 = "Right Mouse Button",
    MouseButton3 = "Middle Mouse Button",
    WheelForward = "Mouse Wheel Up",
    WheelBackward = "Mouse Wheel Down",
    ButtonA = "A",
    ButtonB = "B",
    ButtonX = "X",
    ButtonY = "Y",
    ButtonL1 = "LB",
    ButtonR1 = "RB",
    ButtonL2 = "LT",
    ButtonR2 = "RT",
    ButtonL3 = "Left Stick",
    ButtonR3 = "Right Stick",
    ButtonStart = "Menu",
    ButtonSelect = "View",
    DPadUp = "D-Pad Up",
    DPadDown = "D-Pad Down",
    DPadLeft = "D-Pad Left",
    DPadRight = "D-Pad Right",
    None = "None"
};
local u381 = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.MouseButton2] = true,
    [Enum.UserInputType.MouseButton3] = true
};

function u1.FormatKeybindText(p382) -- Line: 2058
    -- upvalues: u380 (copy)
    return not p382 and "None" or (u380[p382] or (u380[p382.Name] or p382.Name));
end;

function u1.UpdateKeybindText(p383, p384, p385) -- Line: 2066
    -- upvalues: u1 (copy)
    p383[p385].Title.Text = u1.FormatKeybindText(p384[p385]);
end;

function u1.OnKeybindChanged(p386, p387, p388) -- Line: 2070
    -- upvalues: u1 (copy)
    u1.UpdateKeybindText(p386, p387, 1);
    u1.UpdateKeybindText(p386, p387, 2);
    p388(p387);
end;

function u1.StopCapture(p389, p390, p391, p392, p393) -- Line: 2076
    -- upvalues: u1 (copy)
    p389:Removes(p390 .. "_Began", p390 .. "_Changed");
    u1.UpdateKeybindText(p391, p392, p393);
    task.defer(function() -- Line: 2080
        -- upvalues: u1 (ref)
        u1.Capturing = false;
    end);
end;

function u1.SetBind(p394, p395, p396, p397, p398, p399, p400) -- Line: 2085
    -- upvalues: u1 (copy)
    u1.StopCapture(p394, p395, p396, p397, p399);
    local v401 = p399 == 1 and 2 or 1;

    if p397[v401] == p400 then
        p397[v401] = nil;
    end;

    p397[p399] = p400;
    u1.OnKeybindChanged(p396, p397, p398);
end;

function u1.NewKeybind(u402: string, p403: userdata, u404: any, p405: any, u406: any, p407: any, u408: string, u409: boolean) -- Line: 2099
    -- upvalues: u1 (copy), u4 (ref), TweenService (copy), u7 (ref), u8 (ref), FitDescriptionSize (copy), PositionDescription (copy), u13 (ref), UserInputService (copy), u381 (copy), u379 (copy), u378 (copy)
    local u410 = u1.keybindUI();
    u410.LayoutOrder = p407;
    u410.BindTitle.Text = u402;
    u410.Parent = p403;
    local u411 = p405 or table.clone(u404);
    local u412 = { u410.Bind1, u410.Bind2 };
    local u413 = nil;
    u1.UpdateKeybindText(u412, u411, 1);
    u1.UpdateKeybindText(u412, u411, 2);
    u4:Add(`{u402}_MouseEnter`, u410.MouseEnter:Connect(function() -- Line: 2120
        -- upvalues: TweenService (ref), u410 (copy), u408 (copy), u7 (ref), u8 (ref), FitDescriptionSize (ref), PositionDescription (ref)
        TweenService:Create(u410.BindTitle, TweenInfo.new(0.15), {
            TextTransparency = 0
        }):Play();

        if not (u408 and (u408 ~= "" and not u7:GetAttribute("Visible"))) then
            return;
        end;

        u8.ItemText.Text = u408;
        FitDescriptionSize(u8);
        PositionDescription(u8, u410);
        TweenService:Create(u8, TweenInfo.new(0.15), {
            GroupTransparency = 0
        }):Play();
        TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
            Transparency = 0.5
        }):Play();
    end));
    u4:Add(`{u402}_MouseLeave`, u410.MouseLeave:Connect(function() -- Line: 2134
        -- upvalues: TweenService (ref), u410 (copy), u8 (ref)
        TweenService:Create(u410.BindTitle, TweenInfo.new(0.15), {
            TextTransparency = 0.35
        }):Play();
        TweenService:Create(u8, TweenInfo.new(0.15), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
            Transparency = 1
        }):Play();
    end));
    u4:Add(`{u402}_Reset`, u410.Reset.MouseButton1Click:Connect(function() -- Line: 2140
        -- upvalues: u413 (ref), u411 (ref), u404 (copy), u1 (ref), u412 (copy), u406 (copy)
        if u413 then
            u413();
        end;

        u411 = table.clone(u404);
        u1.OnKeybindChanged(u412, u411, u406);
    end));

    for i, v in u412 do
        local function Remove() -- Line: 2153
            -- upvalues: u413 (ref), u411 (ref), i (copy), u1 (ref), u412 (copy), u406 (copy)
            if u413 then
                u413();
            end;

            u411[i] = nil;
            u1.OnKeybindChanged(u412, u411, u406);
        end;

        u1.Binds[v] = Remove;
        u4:Add(`{u402}_Remove{i}`, v:FindFirstChild("Remove").MouseButton1Click:Connect(Remove));
        u4:Add(`{u402}_Button{i}`, v.MouseButton1Click:Connect(function() -- Line: 2170
            -- upvalues: u413 (ref), v (copy), u13 (ref), u1 (ref), u4 (ref), u402 (copy), u412 (copy), u411 (ref), i (copy), UserInputService (ref), u409 (copy), u381 (ref), u379 (ref), u378 (ref), u406 (copy)
            if u413 then
                u413();
            end;

            v.Title.Text = "...";
            u13.Play("UI.submenu_click");
            task.wait();

            u413 = function() -- Line: 2179
                -- upvalues: u1 (ref), u4 (ref), u402 (ref), u412 (ref), u411 (ref), i (ref), u413 (ref)
                u1.StopCapture(u4, u402, u412, u411, i);
                u413 = nil;
            end;

            u1.Capturing = true;
            u4:Add(u402 .. "_Began", UserInputService.InputBegan:Connect(function(p414) -- Line: 2188
                -- upvalues: u409 (ref), u381 (ref), u379 (ref), u378 (ref), u1 (ref), u4 (ref), u402 (ref), u412 (ref), u411 (ref), i (ref), u406 (ref)
                if u409 ~= (p414.UserInputType.Name:find("Gamepad") ~= nil) then
                    return;
                end;

                local Name = p414.KeyCode.Name;
                local v415 = "KeyCode";

                if u381[p414.UserInputType] then
                    Name = p414.UserInputType.Name;
                    v415 = "UserInputType";
                elseif p414.UserInputType ~= Enum.UserInputType.Keyboard and not p414.UserInputType.Name:find("Gamepad") then
                    return;
                end;

                if u379[Name] then
                    return;
                end;

                if u378[Name] then
                    u1.StopCapture(u4, u402, u412, u411, i);

                    return;
                end;

                u1.SetBind(u4, u402, u412, u411, u406, i, Enum[v415][Name]);
            end));
            u4:Add(u402 .. "_Changed", UserInputService.InputChanged:Connect(function(p416) -- Line: 2218
                -- upvalues: u409 (ref), u1 (ref), u4 (ref), u402 (ref), u412 (ref), u411 (ref), u406 (ref), i (ref)
                if not (u409 or (p416.UserInputType ~= Enum.UserInputType.MouseWheel or p416.Position.Z == 0)) then
                    u1.SetBind(u4, u402, u412, u411, u406, i, p416.Position.Z > 0 and "WheelForward" or "WheelBackward");
                end;
            end));
        end));
    end;

    return u410, {
        SetDefault = function() -- Line: 2229, Name: SetDefault
            -- upvalues: u411 (ref), u404 (copy), u1 (ref), u412 (copy)
            u411 = table.clone(u404);
            u1.UpdateKeybindText(u412, u411, 1);
            u1.UpdateKeybindText(u412, u411, 2);
        end,

        Reset = function() -- Line: 2234, Name: Reset
            -- upvalues: u413 (ref), u411 (ref), u404 (copy), u1 (ref), u412 (copy), u406 (copy)
            if u413 then
                u413();
            end;

            u411 = table.clone(u404);
            u1.OnKeybindChanged(u412, u411, u406);
        end
    };
end;

function u1.MouseInside(p417: userdata, p418) -- Line: 2245
    local AbsolutePosition = p417.AbsolutePosition;
    local AbsoluteSize = p417.AbsoluteSize;
    local v419;

    if p418.X >= AbsolutePosition.X and (p418.X <= AbsolutePosition.X + AbsoluteSize.X and p418.Y >= AbsolutePosition.Y) then
        v419 = p418.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v419 = false;
    end;

    return v419;
end;

function u1.FromHex(p420: string) -- Line: 2251
    local v421 = p420:gsub("#", "");

    if #v421 ~= 6 then
        return nil;
    end;

    local v422 = v421:sub(1, 2);
    local v423 = tonumber(v422, 16);
    local v424 = v421:sub(3, 4);
    local v425 = tonumber(v424, 16);
    local v426 = v421:sub(5, 6);
    local v427 = tonumber(v426, 16);

    return v423 and (v425 and (v427 and Color3.fromRGB(v423, v425, v427))) or nil;
end;

function u1.ToHex(p428) -- Line: 2265
    local math_floor_ret = math.floor(p428.R * 255);
    local math_floor_ret2 = math.floor(p428.G * 255);
    local math_floor_ret3 = math.floor(p428.B * 255);

    return string.format("#%02x%02x%02x", math_floor_ret, math_floor_ret2, math_floor_ret3);
end;

function u1.PickerOpen(u429: userdata, u430: userdata) -- Line: 2273
    -- upvalues: u1 (copy), u13 (ref), u15 (ref), Mouse (copy), u4 (ref), UserInputService (copy)
    u429.Visible = not u429.Visible;
    u1.ActivePicker = u429.Visible and u429 and u429 or nil;
    u13.Play("UI.submenu_click");

    if not u429.Visible then
        u4:Removes(
            "PickerEmpty",
            "Hue-InputBegan",
            "Hue-InputEnded",
            "Saturation-InputBegan",
            "Saturation-InputEnded",
            "Lightness-InputBegan",
            "Lightness-InputEnded",
            "Color-InputChanged"
        );

        return;
    end;

    local v431 = u15() == "Console" and u430.AbsolutePosition.Y or Mouse.Y;
    local ViewportSize = workspace.CurrentCamera.ViewportSize;

    if v431 + u429.AbsoluteSize.Y > ViewportSize.Y then
        v431 = ViewportSize.Y - u429.AbsoluteSize.Y;
    end;

    u429.Position = UDim2.new(0.76, 0, 0, v431);
    u4:Add("PickerEmpty", UserInputService.InputBegan:Connect(function(p432) -- Line: 2293
        -- upvalues: u429 (copy), u1 (ref), u430 (copy)
        if p432.UserInputType == Enum.UserInputType.MouseButton1 and u429.Visible then
            local Position = p432.Position;

            if not (u1.MouseInside(u429, Position) or u1.MouseInside(u430, Position)) then
                u1.PickerOpen(u429, u430);
            end;
        end;
    end));
end;

function u1.UpdateHue(p433: any, p434: string, p435: userdata, p436: userdata, p437: any, p438: any, p439: any, p440: any) -- Line: 2310
    -- upvalues: u1 (copy)
    local math_clamp_ret = math.clamp((p433.Position.X - p435.Hue.AbsolutePosition.X) / p435.Hue.AbsoluteSize.X, 0, 1);
    local math_clamp_ret2 = math.clamp((p433.Position.X - p435.Hue.AbsolutePosition.X) / p435.Hue.AbsoluteSize.X * p435.Hue.AbsoluteSize.X, 0, p435.Hue.AbsoluteSize.X - 2);
    p435.Hue.Frame.Position = UDim2.new(0, math_clamp_ret2, 0.5, 0);
    local Color3_fromHSV_ret = Color3.fromHSV(math_clamp_ret, 1, 1);
    p435.Saturation.BackgroundColor3 = Color3_fromHSV_ret;
    local Color3_fromHSV_ret2 = Color3.fromHSV(math_clamp_ret, p439, p440);
    local InputR = p435.RGB.InputR;
    local math_floor_ret = math.floor(Color3_fromHSV_ret2.R * 255);
    InputR.Text = math.clamp(math_floor_ret, 0, 255);
    local InputG = p435.RGB.InputG;
    local math_floor_ret2 = math.floor(Color3_fromHSV_ret2.G * 255);
    InputG.Text = math.clamp(math_floor_ret2, 0, 255);
    local InputB = p435.RGB.InputB;
    local math_floor_ret3 = math.floor(Color3_fromHSV_ret2.B * 255);
    InputB.Text = math.clamp(math_floor_ret3, 0, 255);

    if p436 and p436:FindFirstChild("SelectedColor") then
        p436.SelectedColor.BackgroundColor3 = Color3_fromHSV_ret2;
    end;

    if p434 and p434 ~= "" then
        u1.flags[p434] = Color3.fromRGB(Color3_fromHSV_ret2.r * 255, Color3_fromHSV_ret2.g * 255, Color3_fromHSV_ret2.b * 255);
    end;

    return math_clamp_ret, Color3_fromHSV_ret2, p439, p440;
end;

function u1.UpdateVal(p441: any, p442: string, p443: userdata, p444: userdata, p445: any, p446: any, p447: any, p448: any) -- Line: 2336
    -- upvalues: u1 (copy)
    local math_clamp_ret = math.clamp((p441.Position.X - p443.Saturation.AbsolutePosition.X) / p443.Saturation.AbsoluteSize.X, 0, 1);
    local v449 = 1 - math.clamp((p441.Position.Y - p443.Saturation.AbsolutePosition.Y) / p443.Saturation.AbsoluteSize.Y, 0, 1);
    local math_clamp_ret2 = math.clamp((p441.Position.Y - p443.Saturation.AbsolutePosition.Y) / p443.Saturation.AbsoluteSize.Y * p443.Saturation.AbsoluteSize.Y, 0, p443.Saturation.AbsoluteSize.Y - 4);
    local math_clamp_ret3 = math.clamp((p441.Position.X - p443.Saturation.AbsolutePosition.X) / p443.Saturation.AbsoluteSize.X * p443.Saturation.AbsoluteSize.X, 0, p443.Saturation.AbsoluteSize.X - 4);
    p443.Saturation.Frame.Position = UDim2.new(0, math_clamp_ret3, 0, math_clamp_ret2);
    local Color3_fromHSV_ret = Color3.fromHSV(p445, math_clamp_ret, v449);
    p443.Lightness.Frame.Position = UDim2.new(0, math.clamp((1 - v449) * p443.Lightness.AbsoluteSize.X, 0, p443.Lightness.AbsoluteSize.X - 4), 0.5, 0);
    local InputR = p443.RGB.InputR;
    local math_floor_ret = math.floor(Color3_fromHSV_ret.R * 255);
    InputR.Text = math.clamp(math_floor_ret, 0, 255);
    local InputG = p443.RGB.InputG;
    local math_floor_ret2 = math.floor(Color3_fromHSV_ret.G * 255);
    InputG.Text = math.clamp(math_floor_ret2, 0, 255);
    local InputB = p443.RGB.InputB;
    local math_floor_ret3 = math.floor(Color3_fromHSV_ret.B * 255);
    InputB.Text = math.clamp(math_floor_ret3, 0, 255);

    if p444 and p444:FindFirstChild("SelectedColor") then
        p444.SelectedColor.BackgroundColor3 = Color3_fromHSV_ret;
    end;

    if p442 and p442 ~= "" then
        u1.flags[p442] = Color3.fromRGB(Color3_fromHSV_ret.r * 255, Color3_fromHSV_ret.g * 255, Color3_fromHSV_ret.b * 255);
    end;

    return p445, Color3_fromHSV_ret, math_clamp_ret, v449;
end;

function u1.PickerSet(p450, p451: string, p452: userdata, p453: userdata, p454: any, p455: any, p456: any, p457: any, p458: any, p459: boolean) -- Line: 2370
    -- upvalues: u1 (copy)
    if type(p450) == "table" then
        p450 = Color3.fromRGB(unpack(p450));
    end;

    local v460, v461, v462 = Color3.new(math.clamp(p450.R, 0, 1), math.clamp(p450.G, 0, 1), (math.clamp(p450.B, 0, 1))):ToHSV();
    local Color3_fromHSV_ret = Color3.fromHSV(v460, v461, v462);

    if p453 and p453:FindFirstChild("SelectedColor") then
        p453.SelectedColor.BackgroundColor3 = Color3_fromHSV_ret;
    end;

    p452.Saturation.BackgroundColor3 = Color3.fromHSV(v460, 1, 1);
    p452.Saturation.Frame.Position = UDim2.new(0, math.clamp(v461 * p452.Saturation.AbsoluteSize.X, 0, p452.Saturation.AbsoluteSize.X - 4), 0, (math.clamp((1 - v462) * p452.Saturation.AbsoluteSize.Y, 0, p452.Saturation.AbsoluteSize.Y - 4)));
    p452.Hue.Frame.Position = UDim2.new(0, math.clamp(v460 * p452.Hue.AbsoluteSize.X, 0, p452.Hue.AbsoluteSize.X - 2), 0.5, 0);
    p452.Lightness.Frame.Position = UDim2.new(0, math.clamp((1 - v462) * p452.Lightness.AbsoluteSize.X, 0, p452.Lightness.AbsoluteSize.X - 4), 0.5, 0);
    local InputR = p452.RGB.InputR;
    local math_floor_ret = math.floor(Color3_fromHSV_ret.R * 255);
    InputR.Text = math.clamp(math_floor_ret, 0, 255);
    local InputG = p452.RGB.InputG;
    local math_floor_ret2 = math.floor(Color3_fromHSV_ret.G * 255);
    InputG.Text = math.clamp(math_floor_ret2, 0, 255);
    local InputB = p452.RGB.InputB;
    local math_floor_ret3 = math.floor(Color3_fromHSV_ret.B * 255);
    InputB.Text = math.clamp(math_floor_ret3, 0, 255);
    local Color3_fromRGB_ret = Color3.fromRGB(Color3_fromHSV_ret.R * 255, Color3_fromHSV_ret.G * 255, Color3_fromHSV_ret.B * 255);

    if p451 and p451 ~= "" then
        u1.flags[p451] = Color3_fromRGB_ret;
    end;

    if (p459 or not p459 and p459 ~= false) and p458 then
        p458(Color3_fromRGB_ret);
    end;

    return v460, Color3_fromHSV_ret, v461, v462;
end;

function u1.UpdateLightness(p463: any, p464: string, p465: userdata, p466: userdata, p467: any, p468: any, p469: any, p470: any) -- Line: 2424
    -- upvalues: u1 (copy)
    local v471 = 1 - math.clamp((p463.Position.X - p465.Lightness.AbsolutePosition.X) / p465.Lightness.AbsoluteSize.X, 0, 1);
    local math_clamp_ret = math.clamp((p463.Position.X - p465.Lightness.AbsolutePosition.X) / p465.Lightness.AbsoluteSize.X * p465.Lightness.AbsoluteSize.X, 0, p465.Lightness.AbsoluteSize.X - 4);
    p465.Lightness.Frame.Position = UDim2.new(0, math_clamp_ret, 0.5, 0);
    local Color3_fromHSV_ret = Color3.fromHSV(p467, p469, v471);
    p465.Saturation.Frame.Position = UDim2.new(0, math.clamp(p469 * p465.Saturation.AbsoluteSize.X, 0, p465.Saturation.AbsoluteSize.X - 4), 0, (math.clamp((1 - v471) * p465.Saturation.AbsoluteSize.Y, 0, p465.Saturation.AbsoluteSize.Y - 4)));
    local InputR = p465.RGB.InputR;
    local math_floor_ret = math.floor(Color3_fromHSV_ret.R * 255);
    InputR.Text = math.clamp(math_floor_ret, 0, 255);
    local InputG = p465.RGB.InputG;
    local math_floor_ret2 = math.floor(Color3_fromHSV_ret.G * 255);
    InputG.Text = math.clamp(math_floor_ret2, 0, 255);
    local InputB = p465.RGB.InputB;
    local math_floor_ret3 = math.floor(Color3_fromHSV_ret.B * 255);
    InputB.Text = math.clamp(math_floor_ret3, 0, 255);

    if p466 and p466:FindFirstChild("SelectedColor") then
        p466.SelectedColor.BackgroundColor3 = Color3_fromHSV_ret;
    end;

    if p464 and p464 ~= "" then
        u1.flags[p464] = Color3.fromRGB(Color3_fromHSV_ret.R * 255, Color3_fromHSV_ret.G * 255, Color3_fromHSV_ret.B * 255);
    end;

    return p467, Color3_fromHSV_ret, p469, v471;
end;

function u1.NewColorPicker(u472: string, p473: userdata, u474, p475, u476: any, p477: any, u478: string) -- Line: 2454
    -- upvalues: u1 (copy), TweenService (copy), u7 (ref), u8 (ref), FitDescriptionSize (copy), PositionDescription (copy), u4 (ref), UserInputService (copy)
    local u479, u480 = u1.colorUI();
    u479.SelectedColor:SetAttribute("NoSelect", true);

    for _, v in { u480.Hue, u480.Saturation, u480.Lightness } do
        v:SetAttribute("Select", true);
    end;

    for _, v in { u480.Hue, u480.Lightness } do
        v.NextSelectionLeft = v;
        v.NextSelectionRight = v;
    end;

    u480.Saturation.NextSelectionUp = u480.Saturation;
    u480.Saturation.NextSelectionDown = u480.Saturation;
    u480.Saturation.NextSelectionLeft = u480.Saturation;
    u480.Saturation.NextSelectionRight = u480.Saturation;
    u479.LayoutOrder = p477;
    u479.colortitle.Text = u472;
    u479.Parent = p473;
    u480.Parent = p473.Parent.Parent.Parent.Parent;
    local u481, u482, u483 = Color3.new(math.clamp(p475.R, 0, 1), math.clamp(p475.G, 0, 1), (math.clamp(p475.B, 0, 1))):ToHSV();
    local u484 = false;
    local u485 = false;
    local u486 = false;
    local Color3_fromHSV_ret = Color3.fromHSV(u481, u482, u483);
    u479.MouseEnter:Connect(function() -- Line: 2490
        -- upvalues: TweenService (ref), u479 (copy), u478 (copy), u7 (ref), u8 (ref), FitDescriptionSize (ref), PositionDescription (ref)
        TweenService:Create(u479.colortitle, TweenInfo.new(0.15), {
            TextTransparency = 0
        }):Play();

        if not (u478 and (u478 ~= "" and not u7:GetAttribute("Visible"))) then
            return;
        end;

        u8.ItemText.Text = u478;
        FitDescriptionSize(u8);
        PositionDescription(u8, u479);
        TweenService:Create(u8, TweenInfo.new(0.15), {
            GroupTransparency = 0
        }):Play();
        TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
            Transparency = 0.5
        }):Play();
    end);
    u479.MouseLeave:Connect(function() -- Line: 2515
        -- upvalues: TweenService (ref), u479 (copy), u8 (ref)
        TweenService:Create(u479.colortitle, TweenInfo.new(0.15), {
            TextTransparency = 0.35
        }):Play();
        TweenService:Create(u8, TweenInfo.new(0.15), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
            Transparency = 1
        }):Play();
    end);
    u479.MouseButton1Click:Connect(function() -- Line: 2521
        -- upvalues: u1 (ref), u480 (copy), u479 (copy), Color3_fromHSV_ret (ref), u4 (ref), u484 (ref), u481 (ref), u482 (ref), u483 (ref), u472 (copy), u476 (copy), u485 (ref), u486 (ref), UserInputService (ref)
        u1.PickerOpen(u480, u479);

        if u480.Visible then
            u480.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
            u4:Add("Hue-InputBegan", u480.Hue.InputBegan:Connect(function(p487) -- Line: 2527
                -- upvalues: u484 (ref), u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u1 (ref), u472 (ref), u480 (ref), u479 (ref)
                if p487.UserInputType == Enum.UserInputType.MouseButton1 then
                    u484 = true;
                    local v488, v489, v490, v491 = u1.UpdateHue(p487, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                    u481 = v488;
                    Color3_fromHSV_ret = v489;
                    u482 = v490;
                    u483 = v491;
                end;
            end));
            u4:Add("Hue-InputEnded", u480.Hue.InputEnded:Connect(function(p492) -- Line: 2534
                -- upvalues: u484 (ref), u476 (ref), Color3_fromHSV_ret (ref)
                if p492.UserInputType == Enum.UserInputType.MouseButton1 then
                    u484 = false;
                    u476(Color3.fromRGB(Color3_fromHSV_ret.r * 255, Color3_fromHSV_ret.g * 255, Color3_fromHSV_ret.b * 255));
                end;
            end));
            u4:Add("Saturation-InputBegan", u480.Saturation.InputBegan:Connect(function(p493) -- Line: 2543
                -- upvalues: u485 (ref), u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u1 (ref), u472 (ref), u480 (ref), u479 (ref)
                if p493.UserInputType == Enum.UserInputType.MouseButton1 then
                    u485 = true;
                    local v494, v495, v496, v497 = u1.UpdateVal(p493, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                    u481 = v494;
                    Color3_fromHSV_ret = v495;
                    u482 = v496;
                    u483 = v497;
                end;
            end));
            u4:Add("Saturation-InputEnded", u480.Saturation.InputEnded:Connect(function(p498) -- Line: 2550
                -- upvalues: u485 (ref), u476 (ref), Color3_fromHSV_ret (ref)
                if p498.UserInputType == Enum.UserInputType.MouseButton1 then
                    u485 = false;
                    u476(Color3.fromRGB(Color3_fromHSV_ret.r * 255, Color3_fromHSV_ret.g * 255, Color3_fromHSV_ret.b * 255));
                end;
            end));
            u480.Saturation.Frame.Position = UDim2.new(0, u482 * u480.Saturation.AbsoluteSize.X, 0, (1 - u483) * u480.Saturation.AbsoluteSize.Y);
            u4:Add("Lightness-InputBegan", u480.Lightness.InputBegan:Connect(function(p499) -- Line: 2561
                -- upvalues: u486 (ref), u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u1 (ref), u472 (ref), u480 (ref), u479 (ref)
                if p499.UserInputType == Enum.UserInputType.MouseButton1 then
                    u486 = true;
                    local v500, v501, v502, v503 = u1.UpdateLightness(p499, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                    u481 = v500;
                    Color3_fromHSV_ret = v501;
                    u482 = v502;
                    u483 = v503;
                end;
            end));
            u4:Add("Lightness-InputEnded", u480.Lightness.InputEnded:Connect(function(p504) -- Line: 2568
                -- upvalues: u486 (ref), u476 (ref), Color3_fromHSV_ret (ref)
                if p504.UserInputType == Enum.UserInputType.MouseButton1 then
                    u486 = false;
                    u476(Color3.fromRGB(Color3_fromHSV_ret.r * 255, Color3_fromHSV_ret.g * 255, Color3_fromHSV_ret.b * 255));
                end;
            end));
            u4:Add("Color-InputChanged", UserInputService.InputChanged:Connect(function(p505) -- Line: 2577
                -- upvalues: u484 (ref), u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u1 (ref), u472 (ref), u480 (ref), u479 (ref), u485 (ref), u486 (ref)
                if p505.UserInputType == Enum.UserInputType.MouseMovement then
                    if u484 then
                        local v506, v507, v508, v509 = u1.UpdateHue(p505, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                        u481 = v506;
                        Color3_fromHSV_ret = v507;
                        u482 = v508;
                        u483 = v509;
                    end;

                    if u485 then
                        local v510, v511, v512, v513 = u1.UpdateVal(p505, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                        u481 = v510;
                        Color3_fromHSV_ret = v511;
                        u482 = v512;
                        u483 = v513;
                    end;

                    if u486 then
                        local v514, v515, v516, v517 = u1.UpdateLightness(p505, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                        u481 = v514;
                        Color3_fromHSV_ret = v515;
                        u482 = v516;
                        u483 = v517;
                    end;

                    u480.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
                end;
            end));
        end;
    end);
    u479.SelectedColor.MouseButton1Click:Connect(function() -- Line: 2597
        -- upvalues: u1 (ref), u480 (copy), u479 (copy), Color3_fromHSV_ret (ref), u4 (ref), u484 (ref), u481 (ref), u482 (ref), u483 (ref), u472 (copy), u476 (copy), u485 (ref), u486 (ref), UserInputService (ref)
        u1.PickerOpen(u480, u479);

        if u480.Visible then
            u480.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
            u4:Add("Hue-InputBegan", u480.Hue.InputBegan:Connect(function(p518) -- Line: 2603
                -- upvalues: u484 (ref), u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u1 (ref), u472 (ref), u480 (ref), u479 (ref)
                if p518.UserInputType == Enum.UserInputType.MouseButton1 then
                    u484 = true;
                    local v519, v520, v521, v522 = u1.UpdateHue(p518, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                    u481 = v519;
                    Color3_fromHSV_ret = v520;
                    u482 = v521;
                    u483 = v522;
                end;
            end));
            u4:Add("Hue-InputEnded", u480.Hue.InputEnded:Connect(function(p523) -- Line: 2610
                -- upvalues: u484 (ref), u476 (ref), Color3_fromHSV_ret (ref)
                if p523.UserInputType == Enum.UserInputType.MouseButton1 then
                    u484 = false;
                    u476(Color3.fromRGB(Color3_fromHSV_ret.r * 255, Color3_fromHSV_ret.g * 255, Color3_fromHSV_ret.b * 255));
                end;
            end));
            u4:Add("Saturation-InputBegan", u480.Saturation.InputBegan:Connect(function(p524) -- Line: 2619
                -- upvalues: u485 (ref), u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u1 (ref), u472 (ref), u480 (ref), u479 (ref)
                if p524.UserInputType == Enum.UserInputType.MouseButton1 then
                    u485 = true;
                    local v525, v526, v527, v528 = u1.UpdateVal(p524, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                    u481 = v525;
                    Color3_fromHSV_ret = v526;
                    u482 = v527;
                    u483 = v528;
                end;
            end));
            u4:Add("Saturation-InputEnded", u480.Saturation.InputEnded:Connect(function(p529) -- Line: 2626
                -- upvalues: u485 (ref), u476 (ref), Color3_fromHSV_ret (ref)
                if p529.UserInputType == Enum.UserInputType.MouseButton1 then
                    u485 = false;
                    u476(Color3.fromRGB(Color3_fromHSV_ret.r * 255, Color3_fromHSV_ret.g * 255, Color3_fromHSV_ret.b * 255));
                end;
            end));
            u480.Saturation.Frame.Position = UDim2.new(0, u482 * u480.Saturation.AbsoluteSize.X, 0, (1 - u483) * u480.Saturation.AbsoluteSize.Y);
            u4:Add("Lightness-InputBegan", u480.Lightness.InputBegan:Connect(function(p530) -- Line: 2637
                -- upvalues: u486 (ref), u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u1 (ref), u472 (ref), u480 (ref), u479 (ref)
                if p530.UserInputType == Enum.UserInputType.MouseButton1 then
                    u486 = true;
                    local v531, v532, v533, v534 = u1.UpdateLightness(p530, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                    u481 = v531;
                    Color3_fromHSV_ret = v532;
                    u482 = v533;
                    u483 = v534;
                end;
            end));
            u4:Add("Lightness-InputEnded", u480.Lightness.InputEnded:Connect(function(p535) -- Line: 2644
                -- upvalues: u486 (ref), u476 (ref), Color3_fromHSV_ret (ref)
                if p535.UserInputType == Enum.UserInputType.MouseButton1 then
                    u486 = false;
                    u476(Color3.fromRGB(Color3_fromHSV_ret.r * 255, Color3_fromHSV_ret.g * 255, Color3_fromHSV_ret.b * 255));
                end;
            end));
            u4:Add("Color-InputChanged", UserInputService.InputChanged:Connect(function(p536) -- Line: 2653
                -- upvalues: u484 (ref), u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u1 (ref), u472 (ref), u480 (ref), u479 (ref), u485 (ref), u486 (ref)
                if p536.UserInputType == Enum.UserInputType.MouseMovement then
                    if u484 then
                        local v537, v538, v539, v540 = u1.UpdateHue(p536, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                        u481 = v537;
                        Color3_fromHSV_ret = v538;
                        u482 = v539;
                        u483 = v540;
                    end;

                    if u485 then
                        local v541, v542, v543, v544 = u1.UpdateVal(p536, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                        u481 = v541;
                        Color3_fromHSV_ret = v542;
                        u482 = v543;
                        u483 = v544;
                    end;

                    if u486 then
                        local v545, v546, v547, v548 = u1.UpdateLightness(p536, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483);
                        u481 = v545;
                        Color3_fromHSV_ret = v546;
                        u482 = v547;
                        u483 = v548;
                    end;

                    u480.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
                end;
            end));
        end;
    end);
    u1.PickerSet(p475, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483, u476, false);

    local function applyRGBInputs() -- Line: 2679
        -- upvalues: u480 (copy), u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u1 (ref), u472 (copy), u479 (copy), u476 (copy)
        local v549 = tonumber(u480.RGB.InputR.Text) or 0;
        local math_clamp_ret = math.clamp(v549, 0, 255);
        local v550 = tonumber(u480.RGB.InputG.Text) or 0;
        local math_clamp_ret2 = math.clamp(v550, 0, 255);
        local v551 = tonumber(u480.RGB.InputB.Text) or 0;
        local math_clamp_ret3 = math.clamp(v551, 0, 255);
        local v552, v553, v554, v555 = u1.PickerSet(Color3.fromRGB(math_clamp_ret, math_clamp_ret2, math_clamp_ret3), u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483, u476, true);
        u481 = v552;
        Color3_fromHSV_ret = v553;
        u482 = v554;
        u483 = v555;
        u480.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
    end;

    u480.RGB.InputR.FocusLost:Connect(function() -- Line: 2687
        -- upvalues: u480 (copy), Color3_fromHSV_ret (ref), applyRGBInputs (copy)
        local v556 = tonumber(u480.RGB.InputR.Text);

        if not v556 then
            local InputR = u480.RGB.InputR;
            local math_floor_ret = math.floor(Color3_fromHSV_ret.R * 255);
            InputR.Text = tostring(math_floor_ret);

            return;
        end;

        local InputR = u480.RGB.InputR;
        local math_floor_ret = math.floor(v556);
        local math_clamp_ret = math.clamp(math_floor_ret, 0, 255);
        InputR.Text = tostring(math_clamp_ret);
        applyRGBInputs();
    end);
    u480.RGB.InputG.FocusLost:Connect(function() -- Line: 2694
        -- upvalues: u480 (copy), Color3_fromHSV_ret (ref), applyRGBInputs (copy)
        local v557 = tonumber(u480.RGB.InputG.Text);

        if not v557 then
            local InputG = u480.RGB.InputG;
            local math_floor_ret = math.floor(Color3_fromHSV_ret.G * 255);
            InputG.Text = tostring(math_floor_ret);

            return;
        end;

        local InputG = u480.RGB.InputG;
        local math_floor_ret = math.floor(v557);
        local math_clamp_ret = math.clamp(math_floor_ret, 0, 255);
        InputG.Text = tostring(math_clamp_ret);
        applyRGBInputs();
    end);
    u480.RGB.InputB.FocusLost:Connect(function() -- Line: 2701
        -- upvalues: u480 (copy), Color3_fromHSV_ret (ref), applyRGBInputs (copy)
        local v558 = tonumber(u480.RGB.InputB.Text);

        if not v558 then
            local InputB = u480.RGB.InputB;
            local math_floor_ret = math.floor(Color3_fromHSV_ret.B * 255);
            InputB.Text = tostring(math_floor_ret);

            return;
        end;

        local InputB = u480.RGB.InputB;
        local math_floor_ret = math.floor(v558);
        local math_clamp_ret = math.clamp(math_floor_ret, 0, 255);
        InputB.Text = tostring(math_clamp_ret);
        applyRGBInputs();
    end);
    u480.InputHEX.FocusLost:Connect(function() -- Line: 2708
        -- upvalues: u1 (ref), u480 (copy), Color3_fromHSV_ret (ref), u481 (ref), u482 (ref), u483 (ref), u472 (copy), u479 (copy), u476 (copy)
        local v559 = u1.FromHex(u480.InputHEX.Text);

        if not v559 then
            u480.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);

            return;
        end;

        local v560, v561, v562, v563 = u1.PickerSet(v559, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483, u476, true);
        u481 = v560;
        Color3_fromHSV_ret = v561;
        u482 = v562;
        u483 = v563;
        u480.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
    end);
    u1.Pickers[u480] = {
        Row = u479,
        Hue = u480.Hue,
        Saturation = u480.Saturation,
        Lightness = u480.Lightness,

        Get = function() -- Line: 2745, Name: Get
            -- upvalues: u481 (ref), u482 (ref), u483 (ref)
            return u481, u482, u483;
        end,

        Set = function(p564: number, p565: number, p566: number) -- Line: 2718, Name: ApplyHSV
            -- upvalues: u481 (ref), u482 (ref), u483 (ref), Color3_fromHSV_ret (ref), u479 (copy), u480 (copy), u1 (ref), u472 (copy)
            u481 = p564;
            u482 = p565;
            u483 = p566;
            Color3_fromHSV_ret = Color3.fromHSV(u481, u482, u483);
            u479.SelectedColor.BackgroundColor3 = Color3_fromHSV_ret;
            u480.Saturation.BackgroundColor3 = Color3.fromHSV(u481, 1, 1);
            u480.Saturation.Frame.Position = UDim2.new(0, math.clamp(u482 * u480.Saturation.AbsoluteSize.X, 0, u480.Saturation.AbsoluteSize.X - 4), 0, (math.clamp((1 - u483) * u480.Saturation.AbsoluteSize.Y, 0, u480.Saturation.AbsoluteSize.Y - 4)));
            u480.Hue.Frame.Position = UDim2.new(0, math.clamp(u481 * u480.Hue.AbsoluteSize.X, 0, u480.Hue.AbsoluteSize.X - 2), 0.5, 0);
            u480.Lightness.Frame.Position = UDim2.new(0, math.clamp((1 - u483) * u480.Lightness.AbsoluteSize.X, 0, u480.Lightness.AbsoluteSize.X - 4), 0.5, 0);
            u480.RGB.InputR.Text = math.floor(Color3_fromHSV_ret.R * 255);
            u480.RGB.InputG.Text = math.floor(Color3_fromHSV_ret.G * 255);
            u480.RGB.InputB.Text = math.floor(Color3_fromHSV_ret.B * 255);
            u480.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
            u1.flags[u472] = Color3.fromRGB(Color3_fromHSV_ret.R * 255, Color3_fromHSV_ret.G * 255, Color3_fromHSV_ret.B * 255);
        end,

        Commit = function() -- Line: 2749, Name: Commit
            -- upvalues: u476 (copy), Color3_fromHSV_ret (ref)
            u476(Color3.fromRGB(Color3_fromHSV_ret.R * 255, Color3_fromHSV_ret.G * 255, Color3_fromHSV_ret.B * 255));
        end,

        Close = function() -- Line: 2752, Name: Close
            -- upvalues: u480 (copy), u1 (ref), u479 (copy)
            if u480.Visible then
                u1.PickerOpen(u480, u479);
            end;
        end
    };

    return u479, {
        SetDefault = function(p567) -- Line: 2763
            -- upvalues: u1 (ref), u474 (copy), u472 (copy), u480 (copy), u479 (copy), u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u476 (copy)
            u1.PickerSet(u474, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483, u476);
        end,

        SetValue = function(p568, p569) -- Line: 2766
            -- upvalues: u481 (ref), Color3_fromHSV_ret (ref), u482 (ref), u483 (ref), u1 (ref), u472 (copy), u480 (copy), u479 (copy), u476 (copy)
            local v570, v571, v572, v573 = u1.PickerSet(p568, u472, u480, u479, u481, Color3_fromHSV_ret, u482, u483, u476, not p569);
            u481 = v570;
            Color3_fromHSV_ret = v571;
            u482 = v572;
            u483 = v573;
        end
    };
end;

function u1.SetupColorPicker(u574: userdata, u575: userdata, p576, u577: any) -- Line: 2773
    -- upvalues: u1 (copy)
    local u578, u579, u580 = Color3.new(math.clamp(p576.R, 0, 1), math.clamp(p576.G, 0, 1), (math.clamp(p576.B, 0, 1))):ToHSV();
    local u581 = false;
    local u582 = false;
    local u583 = false;
    local Color3_fromHSV_ret = Color3.fromHSV(u578, u579, u580);

    local function updateColor(p584) -- Line: 2780
        -- upvalues: Color3_fromHSV_ret (ref), u575 (copy), u577 (copy)
        local Color3_fromRGB_ret = Color3.fromRGB(math.round(Color3_fromHSV_ret.R * 255), math.round(Color3_fromHSV_ret.G * 255), (math.round(Color3_fromHSV_ret.B * 255)));

        if u575 and u575:FindFirstChild("SelectedColor") then
            u575.SelectedColor.BackgroundColor3 = Color3_fromHSV_ret;
        end;

        if p584 and u577 then
            u577(Color3_fromRGB_ret);
        end;
    end;

    local u585 = {};
    table.insert(u585, u574.Hue.InputBegan:Connect(function(p586) -- Line: 2792
        -- upvalues: u581 (ref), u578 (ref), Color3_fromHSV_ret (ref), u579 (ref), u580 (ref), u1 (ref), u574 (copy), u575 (copy), updateColor (copy)
        if p586.UserInputType == Enum.UserInputType.MouseButton1 then
            u581 = true;
            local v587, v588, v589, v590 = u1.UpdateHue(p586, "", u574, u575, u578, Color3_fromHSV_ret, u579, u580);
            u578 = v587;
            Color3_fromHSV_ret = v588;
            u579 = v589;
            u580 = v590;
            updateColor(true);
        end;
    end));
    table.insert(u585, u574.Hue.InputEnded:Connect(function(p591) -- Line: 2800
        -- upvalues: u581 (ref), updateColor (copy)
        if p591.UserInputType == Enum.UserInputType.MouseButton1 then
            u581 = false;
            updateColor(true);
        end;
    end));
    table.insert(u585, u574.Saturation.InputBegan:Connect(function(p592) -- Line: 2807
        -- upvalues: u582 (ref), u578 (ref), Color3_fromHSV_ret (ref), u579 (ref), u580 (ref), u1 (ref), u574 (copy), u575 (copy), updateColor (copy)
        if p592.UserInputType == Enum.UserInputType.MouseButton1 then
            u582 = true;
            local v593, v594, v595, v596 = u1.UpdateVal(p592, "", u574, u575, u578, Color3_fromHSV_ret, u579, u580);
            u578 = v593;
            Color3_fromHSV_ret = v594;
            u579 = v595;
            u580 = v596;
            updateColor(true);
        end;
    end));
    table.insert(u585, u574.Saturation.InputEnded:Connect(function(p597) -- Line: 2815
        -- upvalues: u582 (ref), updateColor (copy)
        if p597.UserInputType == Enum.UserInputType.MouseButton1 then
            u582 = false;
            updateColor(true);
        end;
    end));
    table.insert(u585, u574.Lightness.InputBegan:Connect(function(p598) -- Line: 2822
        -- upvalues: u583 (ref), u578 (ref), Color3_fromHSV_ret (ref), u579 (ref), u580 (ref), u1 (ref), u574 (copy), u575 (copy), updateColor (copy)
        if p598.UserInputType == Enum.UserInputType.MouseButton1 then
            u583 = true;
            local v599, v600, v601, v602 = u1.UpdateLightness(p598, "", u574, u575, u578, Color3_fromHSV_ret, u579, u580);
            u578 = v599;
            Color3_fromHSV_ret = v600;
            u579 = v601;
            u580 = v602;
            updateColor(true);
        end;
    end));
    table.insert(u585, u574.Lightness.InputEnded:Connect(function(p603) -- Line: 2830
        -- upvalues: u583 (ref), updateColor (copy)
        if p603.UserInputType == Enum.UserInputType.MouseButton1 then
            u583 = false;
            updateColor(true);
        end;
    end));
    local InputEnded = game:GetService("UserInputService").InputEnded;
    table.insert(u585, InputEnded:Connect(function(p604) -- Line: 2837
        -- upvalues: u581 (ref), u582 (ref), u583 (ref), updateColor (copy)
        if p604.UserInputType == Enum.UserInputType.MouseButton1 and (u581 or (u582 or u583)) then
            u581 = false;
            u582 = false;
            u583 = false;
            updateColor(true);
        end;
    end));
    local InputChanged = game:GetService("UserInputService").InputChanged;
    table.insert(u585, InputChanged:Connect(function(p605) -- Line: 2848
        -- upvalues: u581 (ref), u578 (ref), Color3_fromHSV_ret (ref), u579 (ref), u580 (ref), u1 (ref), u574 (copy), u575 (copy), updateColor (copy), u582 (ref), u583 (ref)
        if p605.UserInputType == Enum.UserInputType.MouseMovement then
            if u581 then
                local v606, v607, v608, v609 = u1.UpdateHue(p605, "", u574, u575, u578, Color3_fromHSV_ret, u579, u580);
                u578 = v606;
                Color3_fromHSV_ret = v607;
                u579 = v608;
                u580 = v609;
                updateColor(true);
            end;

            if u582 then
                local v610, v611, v612, v613 = u1.UpdateVal(p605, "", u574, u575, u578, Color3_fromHSV_ret, u579, u580);
                u578 = v610;
                Color3_fromHSV_ret = v611;
                u579 = v612;
                u580 = v613;
                updateColor(true);
            end;

            if u583 then
                local v614, v615, v616, v617 = u1.UpdateLightness(p605, "", u574, u575, u578, Color3_fromHSV_ret, u579, u580);
                u578 = v614;
                Color3_fromHSV_ret = v615;
                u579 = v616;
                u580 = v617;
                updateColor(true);
            end;

            u574.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
        end;
    end));

    local function v625() -- Line: 2866
        -- upvalues: u574 (copy), u578 (ref), Color3_fromHSV_ret (ref), u579 (ref), u580 (ref), u1 (ref), u575 (copy), u577 (copy)
        local v618 = tonumber(u574.RGB.InputR.Text) or 0;
        local v619 = tonumber(u574.RGB.InputG.Text) or 0;
        local v620 = tonumber(u574.RGB.InputB.Text) or 0;
        local Color3_fromRGB_ret = Color3.fromRGB(math.clamp(v618, 0, 255), math.clamp(v619, 0, 255), (math.clamp(v620, 0, 255)));
        local v621, v622, v623, v624 = u1.PickerSet(Color3_fromRGB_ret, "", u574, u575, u578, Color3_fromHSV_ret, u579, u580, u577, true);
        u578 = v621;
        Color3_fromHSV_ret = v622;
        u579 = v623;
        u580 = v624;
        u574.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
    end;

    table.insert(u585, u574.RGB.InputR.FocusLost:Connect(v625));
    table.insert(u585, u574.RGB.InputG.FocusLost:Connect(v625));
    table.insert(u585, u574.RGB.InputB.FocusLost:Connect(v625));
    table.insert(u585, u574.InputHEX.FocusLost:Connect(function() -- Line: 2879
        -- upvalues: u1 (ref), u574 (copy), Color3_fromHSV_ret (ref), u578 (ref), u579 (ref), u580 (ref), u575 (copy), u577 (copy)
        local v626 = u1.FromHex(u574.InputHEX.Text);

        if not v626 then
            u574.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);

            return;
        end;

        local v627, v628, v629, v630 = u1.PickerSet(v626, "", u574, u575, u578, Color3_fromHSV_ret, u579, u580, u577, true);
        u578 = v627;
        Color3_fromHSV_ret = v628;
        u579 = v629;
        u580 = v630;
        u574.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
    end));
    local v631, v632, v633, v634 = u1.PickerSet(p576, "", u574, u575, u578, Color3_fromHSV_ret, u579, u580, u577, false);
    u578 = v631;
    Color3_fromHSV_ret = v632;
    u579 = v633;
    u580 = v634;
    u574.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);

    return {
        SetColor = function(p635) -- Line: 2893, Name: SetColor
            -- upvalues: u578 (ref), Color3_fromHSV_ret (ref), u579 (ref), u580 (ref), u1 (ref), u574 (copy), u575 (copy), u577 (copy)
            local v636, v637, v638, v639 = u1.PickerSet(p635, "", u574, u575, u578, Color3_fromHSV_ret, u579, u580, u577, false);
            u578 = v636;
            Color3_fromHSV_ret = v637;
            u579 = v638;
            u580 = v639;
            u574.InputHEX.Text = u1.ToHex(Color3_fromHSV_ret);
        end,

        GetColor = function() -- Line: 2897, Name: GetColor
            -- upvalues: Color3_fromHSV_ret (ref)
            return Color3.fromRGB(math.round(Color3_fromHSV_ret.R * 255), math.round(Color3_fromHSV_ret.G * 255), (math.round(Color3_fromHSV_ret.B * 255)));
        end,

        Destroy = function() -- Line: 2900, Name: Destroy
            -- upvalues: u585 (copy)
            for _, v in ipairs(u585) do
                v:Disconnect();
            end;

            table.clear(u585);
        end
    };
end;

function u1.DropClean() -- Line: 2909
    -- upvalues: u7 (ref), u4 (ref)
    for _, child in u7.ScrollingFrame:GetChildren() do
        if child:IsA("TextButton") then
            child:Destroy();
        end;
    end;

    for _, child in u7.ScrollingFrame2:GetChildren() do
        if child:IsA("TextButton") then
            child:Destroy();
        end;
    end;

    u4:Remove("Drop-InputChanged");
end;

function u1.DropDeactive(p640: userdata) -- Line: 2925
    -- upvalues: u7 (ref), u1 (copy), TweenService (copy)
    if not u7 then
        return;
    end;

    if u1.flags.DropDown == p640 then
        if u7.GroupTransparency < 1 then
            u7:SetAttribute("Visible", false);
            TweenService:Create(u7, TweenInfo.new(0.15), {
                GroupTransparency = 1
            }):Play();
            u1.DropClean();

            return true;
        end;
    elseif u7.GroupTransparency < 1 then
        u7:SetAttribute("Visible", false);
        TweenService:Create(u7, TweenInfo.new(0.15), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u1.flags.DropDown, TweenInfo.new(0.15), {
            BackgroundTransparency = 1
        }):Play();
        u1.DropClean();
    end;

    if p640 == "GLOBAL" and u7.GroupTransparency < 1 then
        u7:SetAttribute("Visible", false);
        TweenService:Create(u7, TweenInfo.new(0.15), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u1.flags.DropDown, TweenInfo.new(0.15), {
            BackgroundTransparency = 1
        }):Play();
        u1.DropClean();
    end;
end;

function u1.DropSetOption(p641: userdata, p642: string) -- Line: 2969
    -- upvalues: u1 (copy)
    local v643 = u1.flags[p641];

    if not v643 then
        return;
    end;

    for _, v in v643.options do
        if v == p642 then
            v643.callback(p642);

            if v643.Visual then
                local UDim2_new = UDim2.new;
                local v644 = #v * 0.0065 - 0.038 + math.max(0, (#v - 8) * 0.002);
                p641.Size = UDim2_new(math.clamp(v644, -0.04, 0.25), 89, 0.8, 0);
            end;

            p641.AutoLeft.TextLabel.Text = v;
        end;
    end;
end;

function u1.DropAddOption(p645: userdata, p646: string) -- Line: 2996
    -- upvalues: u1 (copy)
    local v647 = u1.flags[p645];

    if not v647 then
        return;
    end;

    if not v647.options then
        v647.options = {};
    end;

    table.insert(v647.options, p646);
end;

function u1.DropRemoveOption(p648: userdata, p649: string) -- Line: 3011
    -- upvalues: u1 (copy)
    local v650 = u1.flags[p648];

    if not v650 then
        return;
    end;

    if not v650.options then
        return;
    end;

    for i, v in ipairs(v650.options) do
        if v == p649 then
            table.remove(v650.options, i);

            return;
        end;
    end;
end;

function u1.DropCleanOptions(p651: userdata) -- Line: 3031
    -- upvalues: u1 (copy)
    local v652 = u1.flags[p651];

    if not v652 then
        return;
    end;

    if not v652.options then
        return;
    end;

    table.clear(v652.options);
end;

function u1.NewDropDown(u653: boolean, u654: table, u655: string, p656: string, u657: any, u658: userdata, p659: string, p660: userdata, p661: any, u662: string) -- Line: 3046
    -- upvalues: u1 (copy), TweenService (copy), u7 (ref), u8 (ref), FitDescriptionSize (copy), PositionDescription (copy), u13 (ref), LayoutDrop (copy), u4 (ref), UserInputService (copy), HideDescription (copy)
    local u663;

    if u653 then
        u658 = u1.dropdownUI();
        u658.LayoutOrder = p661 or 1;
        u658.TextLabel.Text = p659;
        u658.Parent = p660;
        u663 = u658.DownHold;
        u663.MouseEnter:Connect(function() -- Line: 3067
            -- upvalues: TweenService (ref), u663 (ref)
            TweenService:Create(u663, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play();
            TweenService:Create(u663, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.85
            }):Play();
        end);
        u663.MouseLeave:Connect(function() -- Line: 3072
            -- upvalues: u1 (ref), u663 (ref), u7 (ref), TweenService (ref)
            if u1.flags.DropDown ~= u663 then
                TweenService:Create(u663, TweenInfo.new(0.15), {
                    BackgroundTransparency = 1
                }):Play();

                return;
            end;

            if u7.GroupTransparency < 1 and u7:GetAttribute("Visible") then
                return;
            end;

            TweenService:Create(u663, TweenInfo.new(0.15), {
                BackgroundTransparency = 1
            }):Play();
        end);
        u658.MouseEnter:Connect(function() -- Line: 3084
            -- upvalues: TweenService (ref), u658 (ref), u662 (copy), u7 (ref), u8 (ref), FitDescriptionSize (ref), PositionDescription (ref)
            TweenService:Create(u658.TextLabel, TweenInfo.new(0.15), {
                TextTransparency = 0
            }):Play();

            if not (u662 and (u662 ~= "" and not u7:GetAttribute("Visible"))) then
                return;
            end;

            u8.ItemText.Text = u662;
            FitDescriptionSize(u8);
            PositionDescription(u8, u658);
            TweenService:Create(u8, TweenInfo.new(0.15), {
                GroupTransparency = 0
            }):Play();
            TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
                Transparency = 0.5
            }):Play();
        end);
        u658.MouseLeave:Connect(function() -- Line: 3109
            -- upvalues: TweenService (ref), u658 (ref), u8 (ref)
            TweenService:Create(u658.TextLabel, TweenInfo.new(0.15), {
                TextTransparency = 0.35
            }):Play();
            TweenService:Create(u8, TweenInfo.new(0.15), {
                GroupTransparency = 1
            }):Play();
            TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
                Transparency = 1
            }):Play();
        end);
    else
        u663 = u658;
    end;

    u663.MouseButton1Click:Connect(function() -- Line: 3123
        -- upvalues: u1 (ref), u663 (ref), u13 (ref), LayoutDrop (ref), u654 (copy), u657 (copy), u653 (copy), u7 (ref), TweenService (ref), u4 (ref), UserInputService (ref), HideDescription (ref), u658 (ref)
        if u1.DropDeactive(u663) then
            return;
        end;

        u13.Play("UI.generic_press");
        local GuiInset = game:GetService("GuiService"):GetGuiInset();
        u1.DropClean();
        local v664, v665 = LayoutDrop(u654);

        for _, v in u654 do
            local u666 = u1.dropclick(v, #u654);
            u666.Size = UDim2.new(1, 0, 0, v665);
            u666.Parent = v664;
            u666.MouseButton1Click:Connect(function() -- Line: 3154
                -- upvalues: u657 (ref), v (copy), u653 (ref), u663 (ref), u7 (ref), TweenService (ref), u1 (ref), u13 (ref)
                u657(v);

                if u653 then
                    local UDim2_new = UDim2.new;
                    local v667 = #v * 0.0065 - 0.038 + math.max(0, (#v - 8) * 0.002);
                    u663.Size = UDim2_new(math.clamp(v667, -0.04, 0.25), 89, 0.8, 0);
                end;

                u663.AutoLeft.TextLabel.Text = v;
                u7:SetAttribute("Visible", false);
                TweenService:Create(u7, TweenInfo.new(0.15), {
                    GroupTransparency = 1
                }):Play();
                TweenService:Create(u663, TweenInfo.new(0.15), {
                    BackgroundTransparency = 1
                }):Play();
                u1.DropClean();
                u13.Play("UI.submenu_dropdown_option_select");
            end);
            u666.MouseEnter:Connect(function() -- Line: 3173
                -- upvalues: TweenService (ref), u666 (copy), u663 (ref), u13 (ref)
                TweenService:Create(u666.Back, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0
                }):Play();
                TweenService:Create(u663, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                }):Play();
                u13.Play("UI.submenu_dropdown_rollover");
            end);
            u666.MouseLeave:Connect(function() -- Line: 3180
                -- upvalues: TweenService (ref), u666 (copy)
                TweenService:Create(u666.Back, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1
                }):Play();
            end);
        end;

        u4:Add("Drop-InputChanged", UserInputService.InputChanged:Connect(function(p668) -- Line: 335
            -- upvalues: u7 (ref), u1 (ref)
            if p668.UserInputType == Enum.UserInputType.MouseWheel then
                local Position = p668.Position;
                local AbsolutePosition = u7.AbsolutePosition;
                local AbsoluteSize = u7.AbsoluteSize;
                local v669;

                if Position.X >= AbsolutePosition.X - 10 and (Position.X <= AbsolutePosition.X + AbsoluteSize.X + 10 and Position.Y >= AbsolutePosition.Y - 10) then
                    v669 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y + 10;
                else
                    v669 = false;
                end;

                if not v669 then
                    u1.DropDeactive("GLOBAL");
                end;
            end;
        end));
        HideDescription();
        u7.AnchorPoint = Vector2.new(0, 0);

        if u653 then
            local v670 = u663;
            local Y = u7.AbsoluteSize.Y;
            local Y2 = GuiInset.Y;
            local v671 = v670.AbsolutePosition.Y + v670.AbsoluteSize.Y + Y2;
            local v672 = v670.AbsolutePosition.Y - Y + Y2;

            if v671 + Y <= workspace.CurrentCamera.ViewportSize.Y then
                v672 = v671 or v672;
            end;

            u7.Position = UDim2.fromOffset(u663.AbsolutePosition.X, v672);
        else
            local v673 = u658.AbsolutePosition.Y + u658.AbsoluteSize.Y + GuiInset.Y;
            local v674;

            if u7.ScrollingFrame2.Visible then
                v674 = u7.ScrollingFrame2.AbsoluteSize.Y;
            else
                v674 = u7.ScrollingFrame.AbsoluteSize.Y;
            end;

            if v673 + v674 > workspace.CurrentCamera.ViewportSize.Y then
                v673 = u658.AbsolutePosition.Y - v674 + GuiInset.Y;
            end;

            u7.Position = UDim2.fromOffset(u658.AbsolutePosition.X, v673);
        end;

        local Position = u7.Position;
        u7.Position = Position - UDim2.fromOffset(0, 6);
        TweenService:Create(u7, TweenInfo.new(0.15), {
            GroupTransparency = 0
        }):Play();
        TweenService:Create(u7, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = Position
        }):Play();
        u7:SetAttribute("Visible", true);
        u1.flags.DropDown = u663;
    end);
    u1.flags[u663] = {
        callback = u657,
        options = u654,
        Visual = u653
    };
    u663.AutoLeft.TextLabel.Text = p656;

    if u653 then
        local UDim2_new = UDim2.new;
        local v675 = #p656 * 0.0065 - 0.038 + math.max(0, (#p656 - 8) * 0.002);
        u663.Size = UDim2_new(math.clamp(v675, -0.04, 0.25), 89, 0.8, 0);
    end;

    return u658, {
        SetDefault = function(p676) -- Line: 3247
            -- upvalues: u1 (ref), u663 (ref), u657 (copy), u654 (copy), u653 (copy), u655 (copy)
            u1.flags[u663] = {
                callback = u657,
                options = u654,
                Visual = u653
            };
            u663.AutoLeft.TextLabel.Text = u655;

            if u653 then
                local UDim2_new = UDim2.new;
                local v677 = #u655 * 0.0065 - 0.038 + math.max(0, (#u655 - 8) * 0.002);
                u663.Size = UDim2_new(math.clamp(v677, -0.04, 0.25), 89, 0.8, 0);
            end;
        end,

        SetValue = function(p678, p679) -- Line: 3262
            -- upvalues: u663 (ref), u653 (copy), u657 (copy)
            u663.AutoLeft.TextLabel.Text = p678;

            if u653 then
                local UDim2_new = UDim2.new;
                local v680 = #p678 * 0.0065 - 0.038 + math.max(0, (#p678 - 8) * 0.002);
                u663.Size = UDim2_new(math.clamp(v680, -0.04, 0.25), 89, 0.8, 0);
            end;

            if not p679 then
                u657(p678);
            end;
        end
    };
end;

function u1.MultiList(p681, p682, p683) -- Line: 3277
    -- upvalues: u1 (copy), FitMultiDrop (copy)
    local TextLabel = p681.AutoLeft.TextLabel;
    local v684 = {};

    for _, v in p682 do
        if u1.flags[p681][v] then
            table.insert(v684, v);
        end;
    end;

    if p683 then
        TextLabel.Text = #v684 == 0 and "Any" or (#v684 == 1 and v684[1] or `{#v684} Selected`);

        return;
    end;

    TextLabel.Text = #v684 > 0 and table.concat(v684, ", ") or "None";
    task.spawn(FitMultiDrop, p681);
end;

function u1.NewMultiDropDown(u685: table, u686: table, p687: table, u688: any, p689: string, p690: userdata, p691: any, u692: string, u693: userdata?) -- Line: 3301
    -- upvalues: u1 (copy), TweenService (copy), u7 (ref), u8 (ref), FitDescriptionSize (copy), PositionDescription (copy), LayoutDrop (copy), u13 (ref), u4 (ref), UserInputService (copy), HideDescription (copy)
    local u694, u695;

    if u693 then
        u694 = u693;
        u695 = u694;
        local v696 = u694;
        u694 = u695;
        v696 = u695;
    else
        u694 = u1.dropdownUI();
        u694.LayoutOrder = p691;
        u694.TextLabel.Text = p689;
        u694.Parent = p690;
        u695 = u694.DownHold;
        u694.MouseEnter:Connect(function() -- Line: 3325
            -- upvalues: TweenService (ref), u694 (ref), u692 (copy), u7 (ref), u8 (ref), FitDescriptionSize (ref), PositionDescription (ref)
            TweenService:Create(u694.TextLabel, TweenInfo.new(0.15), {
                TextTransparency = 0
            }):Play();

            if not (u692 and (u692 ~= "" and not u7:GetAttribute("Visible"))) then
                return;
            end;

            u8.ItemText.Text = u692;
            FitDescriptionSize(u8);
            PositionDescription(u8, u694);
            TweenService:Create(u8, TweenInfo.new(0.15), {
                GroupTransparency = 0
            }):Play();
            TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
                Transparency = 0.5
            }):Play();
        end);
        u694.MouseLeave:Connect(function() -- Line: 3350
            -- upvalues: TweenService (ref), u694 (ref), u8 (ref)
            TweenService:Create(u694.TextLabel, TweenInfo.new(0.15), {
                TextTransparency = 0.35
            }):Play();
            TweenService:Create(u8, TweenInfo.new(0.15), {
                GroupTransparency = 1
            }):Play();
            TweenService:Create(u8.UIShadow, TweenInfo.new(0.15), {
                Transparency = 1
            }):Play();
        end);
        u695.MouseEnter:Connect(function() -- Line: 3358
            -- upvalues: TweenService (ref), u695 (ref)
            TweenService:Create(u695, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play();
            TweenService:Create(u695, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.85
            }):Play();
        end);
        u695.MouseLeave:Connect(function() -- Line: 3363
            -- upvalues: u1 (ref), u695 (ref), u7 (ref), TweenService (ref)
            if u1.flags.DropDown ~= u695 then
                TweenService:Create(u695, TweenInfo.new(0.15), {
                    BackgroundTransparency = 1
                }):Play();

                return;
            end;

            if u7.GroupTransparency < 1 and u7:GetAttribute("Visible") then
                return;
            end;

            TweenService:Create(u695, TweenInfo.new(0.15), {
                BackgroundTransparency = 1
            }):Play();
        end);
    end;

    u1.flags[u695] = {};

    for _, v in p687 do
        u1.flags[u695][v] = true;
    end;

    u695.MouseButton1Click:Connect(function() -- Line: 3386
        -- upvalues: u1 (ref), u695 (ref), LayoutDrop (ref), u685 (copy), TweenService (ref), u688 (copy), u693 (copy), u13 (ref), u4 (ref), UserInputService (ref), u7 (ref), HideDescription (ref)
        if u1.DropDeactive(u695) then
            return;
        end;

        local GuiInset = game:GetService("GuiService"):GetGuiInset();
        u1.DropClean();
        local v697, v698 = LayoutDrop(u685);

        for _, v in u685 do
            local u699 = u1.dropclick(v, #u685);
            u699.Size = UDim2.new(1, 0, 0, v698);
            u699.Parent = v697;

            if u1.flags[u695][v] then
                TweenService:Create(u699.Back, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0
                }):Play();
            end;

            u699.MouseButton1Click:Connect(function() -- Line: 3417
                -- upvalues: u1 (ref), u695 (ref), v (copy), TweenService (ref), u699 (copy), u688 (ref), u685 (ref), u693 (ref), u13 (ref)
                if u1.flags[u695][v] then
                    u1.flags[u695][v] = false;
                    TweenService:Create(u699.Back, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1
                    }):Play();
                    u688(u1.flags[u695]);
                    u1.MultiList(u695, u685, u693);

                    return;
                end;

                TweenService:Create(u699.Back, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0
                }):Play();
                u1.flags[u695][v] = true;
                u688(u1.flags[u695]);
                u1.MultiList(u695, u685, u693);
                u13.Play("UI.submenu_dropdown_option_select");
            end);
            u699.MouseEnter:Connect(function() -- Line: 3444
                -- upvalues: u13 (ref), TweenService (ref), u699 (copy), u695 (ref)
                u13.Play("UI.submenu_dropdown_rollover");
                TweenService:Create(u699.Back, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0
                }):Play();
                TweenService:Create(u695, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                }):Play();
            end);
            u699.MouseLeave:Connect(function() -- Line: 3451
                -- upvalues: u1 (ref), u695 (ref), v (copy), TweenService (ref), u699 (copy)
                if u1.flags[u695][v] then
                    return;
                end;

                TweenService:Create(u699.Back, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1
                }):Play();
            end);
        end;

        u4:Add("Drop-InputChanged", UserInputService.InputChanged:Connect(function(p700) -- Line: 335
            -- upvalues: u7 (ref), u1 (ref)
            if p700.UserInputType == Enum.UserInputType.MouseWheel then
                local Position = p700.Position;
                local AbsolutePosition = u7.AbsolutePosition;
                local AbsoluteSize = u7.AbsoluteSize;
                local v701;

                if Position.X >= AbsolutePosition.X - 10 and (Position.X <= AbsolutePosition.X + AbsoluteSize.X + 10 and Position.Y >= AbsolutePosition.Y - 10) then
                    v701 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y + 10;
                else
                    v701 = false;
                end;

                if not v701 then
                    u1.DropDeactive("GLOBAL");
                end;
            end;
        end));
        HideDescription();
        u7.AnchorPoint = Vector2.new(0, 0);
        local v702 = u695;
        local Y = u7.AbsoluteSize.Y;
        local Y2 = GuiInset.Y;
        local v703 = v702.AbsolutePosition.Y + v702.AbsoluteSize.Y + Y2;
        local v704 = v702.AbsolutePosition.Y - Y + Y2;

        if v703 + Y <= workspace.CurrentCamera.ViewportSize.Y then
            v704 = v703 or v704;
        end;

        u7.Position = UDim2.fromOffset(u695.AbsolutePosition.X + u695.AbsoluteSize.X - u7.AbsoluteSize.X, v704);
        local Position = u7.Position;
        u7.Position = Position - UDim2.fromOffset(0, 6);
        TweenService:Create(u7, TweenInfo.new(0.15), {
            GroupTransparency = 0
        }):Play();
        TweenService:Create(u7, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = Position
        }):Play();
        u7:SetAttribute("Visible", true);
        u1.flags.DropDown = u695;
    end);
    u1.MultiList(u695, u685, u693);

    return u694, {
        SetDefault = function(p705) -- Line: 3492
            -- upvalues: u1 (ref), u695 (ref), u685 (copy), u686 (copy), u693 (copy)
            table.clear(u1.flags[u695]);

            for _, v in u685 do
                u1.flags[u695][v] = false;
            end;

            for _, v in u686 do
                u1.flags[u695][v] = true;
            end;

            u1.MultiList(u695, u685, u693);
        end,

        SetValue = function(p706, p707) -- Line: 3503
            -- upvalues: u1 (ref), u695 (ref), u685 (copy), u693 (copy), u688 (copy)
            table.clear(u1.flags[u695]);

            for _, v in u685 do
                u1.flags[u695][v] = false;
            end;

            for _, v in p706 do
                u1.flags[u695][v] = true;
            end;

            u1.MultiList(u695, u685, u693);

            if not p707 then
                u688(u1.flags[u695]);
            end;
        end
    };
end;

function u1.NewCallbackButton(u708: any, p709: string, p710: userdata, p711: any) -- Line: 3520
    -- upvalues: u1 (copy), u13 (ref)
    local u712 = u1.callbackButtonUI();
    u712.LayoutOrder = p711 or 1;
    u712.TextLabel.Text = p709;
    u712.Parent = p710;
    u712.MouseButton1Click:Connect(function() -- Line: 3531
        -- upvalues: u1 (ref), u712 (copy), u13 (ref), u708 (copy)
        if u1.DropDeactive(u712) then
            return;
        end;

        u13.Play("UI.generic_press");
        u708();
    end);

    return u712;
end;

local function decodeKeybind(p713) -- Line: 3546
    -- upvalues: u12 (ref)
    if typeof(p713) ~= "table" then
        return;
    end;

    local v714 = typeof(p713[1]) == "number" and u12.Inputs[p713[1]] or p713[1];
    local v715 = typeof(p713[2]) == "number" and u12.Keybinds[p713[2]] or p713[2];

    if v714 == "MouseWheel" then
        return v715;
    end;

    if v714 ~= "None" and (v714 and (v715 and Enum[v714])) then
        return Enum[v714][v715];
    end;
end;

local function decodeKeybinds(p716, p717) -- Line: 3560
    -- upvalues: decodeKeybind (copy)
    local v718 = p716 or p717;

    return typeof(v718[1]) == "table" and { decodeKeybind(v718[1]), decodeKeybind(v718[2]) } or { decodeKeybind(v718) };
end;

local function IsChanged(p719) -- Line: 3568
    -- upvalues: u30 (ref), decodeKeybinds (copy)
    local Info = p719.Info;
    local v720 = u30[p719.Tab][p719.Page][p719.Name];

    if v720 == nil then
        return false;
    end;

    if Info.Keybind then
        local v721 = decodeKeybinds(Info.Default);

        return v720[1] ~= v721[1] and true or v720[2] ~= v721[2];
    end;

    if Info.MultiDropdown then
        if #v720 ~= #Info.Default then
            return true;
        end;

        for _, v in Info.Default do
            if not table.find(v720, v) then
                return true;
            end;
        end;

        return false;
    end;

    if Info.ColorPicker then
        return (v720[1] ~= Info.Default[1] or v720[2] ~= Info.Default[2]) and true or v720[3] ~= Info.Default[3];
    end;

    if Info.Slider then
        return math.abs(v720 - Info.Default) > 0.001;
    end;

    return v720 ~= Info.Default;
end;

u44 = function(p722) -- Line: 3601, Name: PlaceDot
    local Label = p722.Label;
    p722.Dot.Position = UDim2.new(0, Label.AbsolutePosition.X - p722.Frame.AbsolutePosition.X + Label.TextBounds.X + 8, 0.5, 0);
end;

local function UpdateResetPage() -- Line: 3607
    -- upvalues: u41 (ref), u39 (copy), u32 (ref), u42 (ref), u40 (copy), TweenService (copy)
    local v723;

    if u41 == nil then
        v723 = false;
    elseif u39[u41] == true then
        v723 = true;
    else
        v723 = ViewmodelOffsetFrame;

        if v723 then
            if u41 == ViewmodelOffsetFrame.Parent then
                v723 = next(u32) ~= nil;
            else
                v723 = false;
            end;
        end;
    end;

    u42.Visible = u40[u41] ~= nil;
    u42.Active = v723;
    TweenService:Create(u42.TextLabel, TweenInfo.new(0.2), {
        TextTransparency = v723 and 0 or 0.7
    }):Play();
    TweenService:Create(u42.ImageLabel, TweenInfo.new(0.2), {
        ImageTransparency = v723 and 0 or 0.7
    }):Play();
end;

local function RefreshChanged() -- Line: 3617
    -- upvalues: u45 (ref), u39 (copy), u38 (copy), IsChanged (copy), u44 (ref), TweenService (copy), UpdateResetPage (copy)
    u45 = false;
    table.clear(u39);

    for _, v in u38 do
        local v724 = IsChanged(v);

        if v724 then
            u39[v.PageFrame] = true;
        end;

        if v724 ~= v.Changed then
            v.Changed = v724;

            if v724 then
                u44(v);
            end;

            TweenService:Create(v.Dot, TweenInfo.new(0.2), {
                BackgroundTransparency = v724 and 0.15 or 1
            }):Play();
        end;
    end;

    UpdateResetPage();
end;

u43 = function() -- Line: 3642, Name: QueueChanged
    -- upvalues: u45 (ref), RefreshChanged (copy)
    if u45 then
        return;
    end;

    u45 = true;
    task.defer(RefreshChanged);
end;

function u1.UpdatePlayerSettings(p725, p726) -- Line: 3651
    -- upvalues: HttpService (copy), LocalPlayer (copy), u31 (ref), u32 (ref), u57 (ref), u58 (ref), u18 (ref), u30 (ref), u11 (ref), getSavedPlayerSetting (copy), decodeKeybinds (copy), u12 (ref), u131 (copy), u129 (copy), Matches (copy), fireConnect (copy), u1 (copy), u10 (ref), u43 (ref), u29 (copy), u47 (copy), u46 (ref)
    local v727 = HttpService:JSONDecode(LocalPlayer.PlayerGui:GetAttribute("PlayerSettings"));
    u31 = v727.MapPresets or {};
    u32 = v727.ViewmodelPresets;

    if not u57 or u58 then
        u18.SetOffsetPresets(u32);
    end;

    local v728 = u30;
    u30 = {};

    for i, v in u11.GetData() do
        u30[i] = {};
        local v729 = v727[i];
        local v730 = i;

        for i2, v2 in v do
            u30[v730][i2] = {};
            local v731 = i2;

            for i3, v3 in v2 do
                local v732 = nil;
                local v733 = getSavedPlayerSetting(v729, v731, i3);
                local v734, v735, v736;

                if v3.Toggle then
                    if typeof(v733) == "number" then
                        v733 = v733 == 1;
                        v734 = i3;
                    elseif v733 == nil then
                        v733 = v3.Default;
                        v734 = i3;
                    else
                        v734 = i3;
                    end;

                    if v733 or v733 == false then
                        v735 = `{v730}/{v731}/{v734}`;
                        v736 = u131[v735];

                        if v736 then
                            if u129[v735] or not Matches(v736.Value, v733) and os.clock() - v736.Time <= 5 then
                                v733 = v736.Value;
                            else
                                u131[v735] = nil;
                            end;
                        end;

                        if p725 and u30[v730][v731][v734] ~= v733 then
                            task.defer(fireConnect, v730, v731, v734, v733);
                        end;

                        u30[v730][v731][v734] = v733;
                    end;
                else
                    if not (p726 and (v3.Keybind or v3.MobileControls)) then
                        if v3.Keybind then
                            v733 = decodeKeybinds(v733, v3.Default);
                            v734 = i3;
                        elseif v3.ColorPicker or v3.Slider then
                            v734 = i3;
                        elseif v3.Dropdown then
                            if typeof(v733) == "number" then
                                v733 = u12.SettingsDropdown[v733];
                                v734 = i3;
                            else
                                v734 = i3;
                            end;
                        elseif v3.MultiDropdown then
                            local v737 = {};

                            if v733 then
                                v734 = i3;
                                v733 = v737;

                                for _, v4 in v733 do
                                    if typeof(v4) == "number" then
                                        table.insert(v733, u12.SettingsDropdown[v4]);
                                        v737 = v733;
                                    else
                                        table.insert(v733, v4);
                                        v737 = v733;
                                    end;

                                    v733 = v737;
                                end;
                            else
                                v734 = i3;
                                v733 = v737;
                            end;
                        elseif v3.MobileControls then
                            v734 = i3;
                        elseif v3.TextBox then
                            v734 = i3;
                        else
                            v734 = i3;
                            v733 = v732;
                        end;

                        if v733 or v733 == false then
                            v735 = `{v730}/{v731}/{v734}`;
                            v736 = u131[v735];

                            if v736 then
                                if u129[v735] or not Matches(v736.Value, v733) and os.clock() - v736.Time <= 5 then
                                    v733 = v736.Value;
                                else
                                    u131[v735] = nil;
                                end;
                            end;

                            if p725 and u30[v730][v731][v734] ~= v733 then
                                task.defer(fireConnect, v730, v731, v734, v733);
                            end;

                            u30[v730][v731][v734] = v733;
                        end;
                    end;

                    u30[v730][v731][i3] = v728[v730][v731][i3];
                end;
            end;
        end;
    end;

    u1.UpdateCrosshairFrame();
    u1.UpdateViewmodelOffset();
    u1.UpdateRemovePreset();
    u1.UpdateHudEdges();
    u10.UpdatePlayerSettings();
    u43();

    for i, v in u29 do
        if i == "Maps" then
            for i2, v2 in v do
                local v738 = i2;

                for i3, v3 in v2 do
                    local v739 = u30.Maps and u30.Maps[v738] and u30.Maps[v738][i3];

                    if v739 ~= nil and v3.SetValue then
                        v3.SetValue(v739, true);
                    end;
                end;
            end;
        else
            local v740 = i;

            for i2, v2 in v do
                local v741 = i2;

                for i3, v3 in v2 do
                    local v742 = u30[v740] and u30[v740][v741] and u30[v740][v741][i3];

                    if v742 ~= nil and v3.SetValue then
                        v3.SetValue(v742, true);
                    end;
                end;
            end;
        end;
    end;

    for i, v in u47 do
        local v743 = u31[i];
        v.SetValue(v743 and v743.Selected or "Default", true);
    end;

    u46();
end;

function u1.GetSettingsFromPlayer(p744, p745) -- Line: 3777
    -- upvalues: HttpService (copy), u58 (ref), u18 (ref), u11 (ref), getSavedPlayerSetting (copy), u12 (ref), firePlayerConnect (copy)
    local v746 = p744:GetAttribute("PlayerSettings") and HttpService:JSONDecode(p744:GetAttribute("PlayerSettings"));

    if p745 and not u58 then
        u18.SetOffsetPresets(v746.ViewmodelPresets);
    end;

    local v747 = {};

    for i, v in u11.GetData() do
        if i ~= "Maps" and i ~= "Controls" then
            v747[i] = {};
            local v748 = v746[i];
            local v749 = i;

            for i2, v2 in v do
                v747[v749][i2] = {};
                local v750 = i2;

                for i3, v3 in v2 do
                    local v751 = nil;
                    local v752 = getSavedPlayerSetting(v748, v750, i3);
                    local v753;

                    if v3.Toggle then
                        if typeof(v752) == "number" then
                            v752 = v752 == 1;
                            v753 = i3;
                        else
                            v753 = i3;
                        end;
                    elseif v3.ColorPicker or v3.Slider then
                        v753 = i3;
                    elseif v3.Dropdown then
                        if typeof(v752) == "number" then
                            v752 = u12.SettingsDropdown[v752];
                            v753 = i3;
                        else
                            v753 = i3;
                        end;
                    elseif v3.MultiDropdown then
                        local v754 = {};

                        if v752 then
                            v753 = i3;
                            v752 = v754;

                            for _, v4 in v752 do
                                if typeof(v4) == "number" then
                                    table.insert(v752, u12.SettingsDropdown[v4]);
                                    v754 = v752;
                                else
                                    table.insert(v752, v4);
                                    v754 = v752;
                                end;

                                v752 = v754;
                            end;
                        else
                            v753 = i3;
                            v752 = v754;
                        end;
                    elseif v3.TextBox then
                        v753 = i3;
                    else
                        v753 = i3;
                        v752 = v751;
                    end;

                    if v752 or v752 == false then
                        v747[v749][v750][v753] = v752;

                        if p745 then
                            task.defer(firePlayerConnect, v749, v750, v753, v752);
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v747;
end;

function u1.AddConnection(p755, p756, p757, p758, p759) -- Line: 3852
    -- upvalues: u26 (copy)
    if not u26[p756] then
        u26[p756] = {};
    end;

    if not u26[p756][p757] then
        u26[p756][p757] = {};
    end;

    if not u26[p756][p757][p758] then
        u26[p756][p757][p758] = {};
    end;

    table.insert(u26[p756][p757][p758], p759);
end;

function u1.AddPlayerConnection(p760, p761, p762, p763, p764) -- Line: 3868
    -- upvalues: u27 (copy)
    if not u27[p761] then
        u27[p761] = {};
    end;

    if not u27[p761][p762] then
        u27[p761][p762] = {};
    end;

    if not u27[p761][p762][p763] then
        u27[p761][p762][p763] = {};
    end;

    table.insert(u27[p761][p762][p763], p764);
end;

function u1.DisconnectConnection(p765, p766, p767, p768, p769) -- Line: 3884
    -- upvalues: u26 (copy)
    if not u26[p766] then
        return;
    end;

    if not u26[p766][p767] then
        return;
    end;

    if u26[p766][p767][p768] then
        for i, v in ipairs(u26[p766][p767][p768]) do
            if v == p769 then
                table.remove(u26[p766][p767][p768], i);

                return;
            end;
        end;
    end;
end;

function u1.GetPlayerSettings(p770) -- Line: 3903
    -- upvalues: u30 (ref)
    return u30;
end;

function u1.Spectate(u771) -- Line: 3907
    -- upvalues: u57 (ref), u4 (ref), u1 (copy), restorePlayerConnect (copy)
    if u771 then
        u57 = u771;
        u1.GetSettingsFromPlayer(u771, true);
        u4:Add("SpectateUpdate", u771:GetAttributeChangedSignal("PlayerSettings"):Connect(function() -- Line: 3926
            -- upvalues: u1 (ref), u771 (copy)
            u1.GetSettingsFromPlayer(u771, true);
        end));

        return;
    end;

    if not u57 then
        return;
    end;

    u4:Remove("SpectateUpdate");
    u57 = nil;
    u1.UpdatePlayerSettings(true, true);
    restorePlayerConnect();
end;

local function MarkOptimizationPresetCustom(p772, p773, p774) -- Line: 3931
    -- upvalues: u51 (ref), u50 (ref), u49 (copy)
    if u51 or not u50 then
        return;
    end;

    local v775 = u49.Potato[p773];

    if p772 == "Maps" or p772 == "Game" and (v775 and v775[p774] ~= nil) then
        u50.SetValue("Custom", true);
    end;
end;

local function ApplyOptimizationPreset(p776) -- Line: 3942
    -- upvalues: u49 (copy), u51 (ref), u29 (copy), u11 (ref), u14 (ref), u47 (copy)
    local v777 = u49[p776];

    if not v777 then
        return;
    end;

    u51 = true;

    for i, v in v777 do
        local v778 = i;

        for i2, v2 in v do
            u29.Game[v778][i2].SetValue(v2);
        end;
    end;

    local v779 = p776 == "Potato" and "Optimizations" or "Default";

    for i in u11.GetData().Maps do
        u14.Gui.SelectMapPreset.Fire({
            M = i,
            P = v779
        });
        u47[i].SetValue(v779, true);
    end;

    u51 = false;
end;

local TweenInfo_new_ret2 = TweenInfo.new(0.35, Enum.EasingStyle.Quint);
local u780 = {};
local u781 = {};
local u782 = {};
local u783 = nil;
local u784 = nil;
local u785 = false;

local function SearchWords(p786: string) -- Line: 3974
    local v787 = {};

    for i in string.gmatch(string.lower(p786), "%w+") do
        table.insert(v787, i);
    end;

    return v787;
end;

local function TypoDistance(p788: string, p789: string) -- Line: 3984
    local v790 = {};

    for i = 0, #p788 do
        v790[i] = { i };
        local _ = i;
    end;

    for i = 1, #p789 do
        v790[0][i] = i;
        local _ = i;
    end;

    for i = 1, #p788 do
        local v791 = i;

        for i2 = 1, #p789 do
            local v792 = string.byte(p788, v791) == string.byte(p789, i2) and 0 or 1;
            local math_min_ret = math.min(v790[v791 - 1][i2] + 1, v790[v791][i2 - 1] + 1, v790[v791 - 1][i2 - 1] + v792);

            if v791 > 1 and (i2 > 1 and (string.byte(p788, v791) == string.byte(p789, i2 - 1) and string.byte(p788, v791 - 1) == string.byte(p789, i2))) then
                math_min_ret = math.min(math_min_ret, v790[v791 - 2][i2 - 2] + 1);
            end;

            v790[v791][i2] = math_min_ret;
            local _ = i2;
        end;
    end;

    return v790[#p788][#p789];
end;

local function Subsequence(p793: string, p794: string) -- Line: 4011
    local v795 = 1;
    local v796 = nil;

    for i = 1, #p794 do
        local v797;

        if string.byte(p794, i) == string.byte(p793, v795) then
            v796 = v796 or i;
            v795 = v795 + 1;

            if #p793 < v795 then
                return #p793 / (i - v796 + 1);
            end;

            v797 = i;
        else
            v797 = i;
        end;
    end;

    return nil;
end;

local function WordScore(p798: any, p799: string, p800: boolean) -- Line: 4028
    -- upvalues: TypoDistance (copy), Subsequence (copy)
    for _, v in p798.NameWords do
        if v == p799 then
            return 100;
        end;
    end;

    for _, v in p798.NameWords do
        if string.sub(v, 1, #p799) == p799 then
            return 85;
        end;
    end;

    local v801 = #p799 >= 2 and string.find(p798.Initials, p799, 1, true);

    if v801 then
        return v801 == 1 and 80 or 70;
    end;

    if #p799 >= 4 and string.find(p798.NameJoined, p799, 1, true) then
        return 60;
    end;

    if #p799 >= 2 then
        if string.find(p798.Context, "%f[%w]" .. p799) then
            return 35;
        end;

        if string.find(p798.Options, "%f[%w]" .. p799) then
            return 30;
        end;

        if string.find(p798.Description, "%f[%w]" .. p799) then
            return 20;
        end;
    end;

    if not p800 then
        return 0;
    end;

    local v802 = #p799 >= 8 and 2 or (#p799 >= 5 and 1 or 0);

    if v802 > 0 then
        for _, v in p798.NameWords do
            if math.abs(#v - #p799) <= v802 and TypoDistance(p799, v) <= v802 or #v > #p799 and TypoDistance(p799, (string.sub(v, 1, #p799))) <= v802 then
                return 55;
            end;
        end;
    end;

    local v803;

    if #p799 >= 3 then
        v803 = Subsequence(p799, p798.NameJoined);
    else
        v803 = false;
    end;

    return (not v803 or v803 < 0.5) and 0 or 15 + 25 * v803;
end;

local function EntryScore(p804: any, p805: table, p806: string, p807: boolean) -- Line: 4090
    -- upvalues: WordScore (copy)
    local v808 = 0;

    for _, v in p805 do
        local v809 = WordScore(p804, v, p807);

        if v809 == 0 then
            return 0;
        end;

        v808 = v808 + v809;
    end;

    if string.sub(p804.NameJoined, 1, #p806) == p806 then
        v808 = v808 + 50;
    end;

    return v808;
end;

local function NewSearchEntry(p810: string, p811: string, p812: string, p813: any, p814: userdata) -- Line: 4110
    -- upvalues: SearchWords (copy)
    local v815 = SearchWords(p812);
    local v816 = {};

    for i, v in v815 do
        v816[i] = string.sub(v, 1, 1);
    end;

    return {
        Frame = p814,
        Group = `{p810} / {p811}`,
        Order = p813.LayoutOrder,
        Gamepass = p813.Gamepass,
        NameWords = v815,
        NameJoined = table.concat(v815),
        Initials = table.concat(v816),
        Context = string.lower((`{p810} {p811} {p813.Section or ""}`)),
        Options = string.lower(table.concat(p813.Dropdown or (p813.MultiDropdown or {}), " ")),
        Description = string.lower(p813.Description)
    };
end;

local function CollectMatches(p817: table, p818: string, p819: boolean) -- Line: 4132
    -- upvalues: u23 (ref), u780 (copy), EntryScore (copy)
    local v820 = u23.Get("Gamepasses") or {};
    local v821 = {};

    for _, v in u780 do
        if not v.Gamepass or v820[v.Gamepass] ~= nil then
            local v822 = EntryScore(v, p817, p818, p819);

            if v822 > 0 then
                table.insert(v821, {
                    Entry = v,
                    Score = v822
                });
            end;
        end;
    end;

    return v821;
end;

local function RestoreSearch() -- Line: 4151
    -- upvalues: u781 (copy), u782 (copy)
    for i, v in u781 do
        i.Parent = v.Parent;
        i.LayoutOrder = v.LayoutOrder;
        i.Visible = v.Visible;
    end;

    for _, v in u782 do
        v:Destroy();
    end;

    table.clear(u781);
    table.clear(u782);
end;

local function ShowHint(p823: userdata, p824: string) -- Line: 4166
    -- upvalues: TweenService (copy), TweenInfo_new_ret2 (copy)
    if not p823.Visible then
        p823.TextTransparency = 1;
        TweenService:Create(p823, TweenInfo_new_ret2, {
            TextTransparency = 0
        }):Play();
    end;

    p823.Text = p824;
    p823.Visible = true;
end;

local function RunSearch() -- Line: 4176
    -- upvalues: u785 (ref), u1 (copy), RestoreSearch (copy), u783 (ref), u784 (ref), SearchWords (copy), TweenService (copy), TweenInfo_new_ret2 (copy), CollectMatches (copy), u782 (copy), u781 (copy)
    u785 = false;
    u1.DropDeactive("GLOBAL");
    RestoreSearch();

    if not u783.Visible then
        return;
    end;

    local Text = u784.Box.TextBox.Text;
    local v825 = SearchWords(Text);
    local Hint = u783.Hint;
    u783.CanvasPosition = Vector2.zero;

    if #v825 == 0 then
        if not Hint.Visible then
            Hint.TextTransparency = 1;
            TweenService:Create(Hint, TweenInfo_new_ret2, {
                TextTransparency = 0
            }):Play();
        end;

        Hint.Text = "SEARCH ANY SETTING BY ITS NAME OR DESCRIPTION";
        Hint.Visible = true;
        u784.Box.Count.Text = "";

        return;
    end;

    local table_concat_ret = table.concat(v825);
    local v826 = CollectMatches(v825, table_concat_ret, false);

    if #v826 == 0 then
        v826 = CollectMatches(v825, table_concat_ret, true);
    end;

    table.sort(v826, function(p827, p828) -- Line: 4205
        if p827.Score ~= p828.Score then
            return p827.Score > p828.Score;
        end;

        if p827.Entry.Group == p828.Entry.Group then
            return p827.Entry.Order < p828.Entry.Order;
        end;

        return p827.Entry.Group < p828.Entry.Group;
    end);
    local math_min_ret = math.min(#v826, 40);
    local v829 = {};
    local v830 = {};

    for i = 1, math_min_ret do
        local Entry = v826[i].Entry;
        local v831 = v829[Entry.Group];

        if not v831 then
            v831 = {};
            v829[Entry.Group] = v831;
            table.insert(v830, Entry.Group);
        end;

        table.insert(v831, Entry);
        local _ = i;
    end;

    local v832 = 0;

    for i, v in v830 do
        if i > 1 then
            v832 = v832 + 1;
            table.insert(u782, u1.NewNull(u783, v832));
        end;

        v832 = v832 + 1;
        table.insert(u782, u1.NewSection(v, u783, v832));

        for _, v2 in v829[v] do
            local Frame = v2.Frame;
            u781[Frame] = {
                Parent = Frame.Parent,
                LayoutOrder = Frame.LayoutOrder,
                Visible = Frame.Visible
            };
            v832 = v832 + 1;
            Frame.LayoutOrder = v832;
            Frame.Visible = true;
            Frame.Parent = u783;
        end;
    end;

    if math_min_ret == 0 then
        local v833 = `NO SETTINGS MATCH "{string.upper(Text)}"`;

        if not Hint.Visible then
            Hint.TextTransparency = 1;
            TweenService:Create(Hint, TweenInfo_new_ret2, {
                TextTransparency = 0
            }):Play();
        end;

        Hint.Text = v833;
        Hint.Visible = true;
    else
        Hint.Visible = false;
    end;

    local Count = u784.Box.Count;
    local v834 = math_min_ret > 0 and (`{math_min_ret} RESULT{math_min_ret == 1 and "" or "S"}` or "") or "";

    if Count.Text ~= v834 then
        Count.Text = v834;
        Count.TextTransparency = 0.7;
        TweenService:Create(Count, TweenInfo_new_ret2, {
            TextTransparency = 0
        }):Play();
    end;
end;

local function QueueSearch() -- Line: 4272
    -- upvalues: u785 (ref), RunSearch (copy)
    if u785 then
        return;
    end;

    u785 = true;
    task.defer(RunSearch);
end;

local u835 = nil;

local function GetCondition(p836: string, p837: any, p838: any, p839: string) -- Line: 4288
    if p838.ShowIf then
        return { p838.ShowIf[1], p838.ShowIf[2], false };
    end;

    if p838.HideIf then
        return { p838.HideIf[1], p838.HideIf[2], true };
    end;

    if p836 == "Maps" and (p838.Section and not string.find(p839, "^Override ")) then
        for i, v in p837 do
            if v.Section == p838.Section and string.find(i, "^Override ") then
                return { i, true, false };
            end;
        end;
    end;

    return nil;
end;

local function ConditionMet(p840: string, p841: string, p842: string) -- Line: 4304
    -- upvalues: u11 (ref), GetCondition (copy), u30 (ref), ConditionMet (copy)
    local v843 = u11.GetData()[p840][p841];
    local v844 = GetCondition(p840, v843, v843[p842], p842);

    if not v844 then
        return true;
    end;

    local v845 = v844[1];
    local v846 = u30[p840][p841][v845];

    if v846 == nil then
        v846 = v843[v845].Default;
    end;

    local v847;

    if v846 == v844[2] == v844[3] then
        v847 = false;
    else
        v847 = ConditionMet(p840, p841, v845);
    end;

    return v847;
end;

local function SectionShown(p848) -- Line: 4323
    -- upvalues: ConditionMet (copy)
    for _, v in p848.Settings do
        if ConditionMet(p848.Tab, p848.Page, v) then
            return true;
        end;
    end;

    return false;
end;

local function FrameVisible(p849: userdata, p850: any) -- Line: 4333
    -- upvalues: u34 (copy), u33 (copy), u35 (copy), u37 (copy), u835 (ref), ConditionMet (copy)
    local v851 = u34[p849];
    local v852 = u33[p849];
    local v853 = u35[p849];
    local v854 = u37[p849];
    local v855;

    if (v851 == nil or v851 == u835) and (v852 == nil or p850[v852] ~= nil) then
        v855 = v853 == nil or ConditionMet(v853[1], v853[2], v853[3]);

        if v855 then
            if v854 == nil then
                v855 = true;
            else
                for _, v in v854.Settings do
                    if ConditionMet(v854.Tab, v854.Page, v) then
                        return true;
                    end;
                end;

                v855 = false;
            end;
        end;
    else
        v855 = false;
    end;

    return v855;
end;

local TweenInfo_new_ret3 = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local u856 = {};

local function SetRowVisible(u857: userdata, u858: boolean, p859: boolean?) -- Line: 4350
    -- upvalues: u856 (copy), TweenService (copy), TweenInfo_new_ret3 (copy)
    local u860 = u856[u857];
    u860 = u860;
    local v861;

    if u860 then
        v861 = u860.Tween;
    end;

    local v862;

    if v861 then
        v862 = u860.Target;
    else
        v862 = u857.Visible;
    end;

    if v862 == u858 then
        return;
    end;

    if v861 then
        v861:Cancel();
        u860.Tween = nil;
    end;

    local u863 = u857:FindFirstChildOfClass("UIAspectRatioConstraint");

    if not (p859 and u863) then
        if u860 then
            u860.Openness.Value = 1;
            u857.ClipsDescendants = false;
        end;

        u857.Visible = u858;

        return;
    end;

    if not u860 then
        local AspectRatio = u863.AspectRatio;
        local NumberValue = Instance.new("NumberValue");
        NumberValue.Value = 1;
        NumberValue.Changed:Connect(function(p864) -- Line: 4379
            -- upvalues: u863 (copy), AspectRatio (copy)
            u863.AspectRatio = AspectRatio / math.max(p864, 0.01);
        end);
        u860 = {
            Openness = NumberValue
        };
        u856[u857] = u860;
    end;

    if not u857.Visible then
        u860.Openness.Value = 0;
    end;

    u857.ClipsDescendants = true;
    u857.Visible = true;
    local v865 = TweenService:Create(u860.Openness, TweenInfo_new_ret3, {
        Value = u858 and 1 or 0
    });
    u860.Tween = v865;
    u860.Target = u858;
    v865.Completed:Connect(function(p866) -- Line: 4397
        -- upvalues: u860 (ref), u857 (copy), u858 (copy)
        if p866 ~= Enum.PlaybackState.Completed then
            return;
        end;

        u860.Tween = nil;
        u857.ClipsDescendants = false;
        u857.Visible = u858;
        u860.Openness.Value = 1;
    end);
    v865:Play();
end;

u46 = function(p867: boolean?) -- Line: 4412
    -- upvalues: u23 (ref), u34 (copy), u33 (copy), u35 (copy), u37 (copy), FrameVisible (copy), u781 (copy), SetRowVisible (copy)
    local v868 = u23.Get("Gamepasses") or {};

    for _, v in {
        u34,
        u33,
        u35,
        u37
    } do
        for i in v do
            local v869 = FrameVisible(i, v868);
            local v870 = u781[i];

            if v870 then
                v870.Visible = v869;
            else
                SetRowVisible(i, v869, p867);
            end;
        end;
    end;
end;

local function CollectGroups(u871) -- Line: 4434
    -- upvalues: CanAccessSetting (copy)
    local v872 = {};

    for i, v in u871 do
        if v.Group and (v.Toggle and (v.LayoutOrder and CanAccessSetting(v))) then
            local v873 = v872[v.Group] or {
                Members = {},
                State = {},
                Callbacks = {}
            };
            v872[v.Group] = v873;
            table.insert(v873.Members, i);
        end;
    end;

    for _, v in v872 do
        table.sort(v.Members, function(p874, p875) -- Line: 4448
            -- upvalues: u871 (copy)
            return u871[p874].LayoutOrder < u871[p875].LayoutOrder;
        end);
    end;

    return v872;
end;

local function NewGroupedToggle(u876: any, p877: string, u878: any, p879: any, u880: string, p881: userdata, u882: any) -- Line: 4456
    -- upvalues: u1 (copy)
    local u883 = u878[u880];
    local u884 = u883.Option or u880;
    local v885 = p879[u880];

    if v885 == nil then
        v885 = u883.Default;
    end;

    u876.State[u880] = v885;
    u876.Callbacks[u880] = u882;

    if not u876.Frame then
        local v886 = u878[u876.Members[1]];
        local v887 = {};
        local v888 = {};
        local v889 = {};

        for _, v in u876.Members do
            local v890 = u878[v];
            local v891 = v890.Option or v;
            local v892 = p879[v];
            table.insert(v887, v891);

            if v892 == nil then
                v892 = v890.Default;
            end;

            if v892 then
                table.insert(v889, v891);
            end;

            if v890.Default then
                table.insert(v888, v891);
            end;
        end;

        u876.Options = v887;
        u876.Frame = u1.NewMultiDropDown(v887, v888, v889, function(p893) -- Line: 4489
            -- upvalues: u876 (copy), u878 (copy)
            for _, v in u876.Members do
                local v894 = p893[u878[v].Option or v] == true;

                if v894 ~= u876.State[v] and u876.Callbacks[v] then
                    u876.State[v] = v894;
                    u876.Callbacks[v](v894);
                end;
            end;
        end, p877, p881, v886.LayoutOrder, v886.GroupDescription or v886.Description);
        u876.Visual = u876.Frame.DownHold;
    end;

    return u876.Frame, {
        SetValue = function(p895, p896) -- Line: 4502, Name: Set
            -- upvalues: u876 (copy), u880 (copy), u1 (ref), u884 (copy), u882 (copy)
            u876.State[u880] = p895;
            u1.flags[u876.Visual][u884] = p895;
            u1.MultiList(u876.Visual, u876.Options);

            if not p896 then
                u882(p895);
            end;
        end,

        SetDefault = function() -- Line: 4514, Name: SetDefault
            -- upvalues: u883 (copy), u876 (copy), u880 (copy), u1 (ref), u884 (copy), u882 (copy)
            local Default = u883.Default;
            u876.State[u880] = Default;
            u1.flags[u876.Visual][u884] = Default;
            u1.MultiList(u876.Visual, u876.Options);
            u882(Default);
        end
    };
end;

function u1.Init(p897) -- Line: 4522
    -- upvalues: u2 (ref), u11 (ref), u12 (ref), u3 (ref), u5 (ref), u13 (ref), u14 (ref), u20 (ref), u16 (ref), u17 (ref), u21 (ref), u4 (ref), u10 (ref), u22 (ref), u15 (ref), u18 (ref), u19 (ref), u23 (ref), u24 (ref), u25 (ref)
    u2 = p897:GetModule("Gui");
    u11 = p897:GetModule("SettingsData");
    u12 = p897:GetModule("Enums");
    u3 = u2.GetComponent("MainMenu");
    u5 = p897:GetModule("Tabs");
    u13 = p897:GetModule("SoundManager");
    u14 = p897:GetModule("Network");
    u20 = p897:GetModule("WeaponManager");
    u16 = p897:GetModule("ItemManager");
    u17 = p897:GetModule("SkinManager");
    u21 = p897:GetModule("GamemodesData");
    u4 = p897:GetModule("Maid").new();
    u10 = p897:GetModule("NewMapAdded");
    u22 = p897:GetModule("Spectate");
    u15 = p897:GetModule("GetUserPlatform");
    u18 = p897:GetModule("Viewmodel");
    u19 = p897:GetModule("AnimationManager");
    u23 = p897:GetModule("ProfileData");
    u24 = p897:GetModule("GameConfiguration");
    u25 = p897:GetModule("Config");
end;

function u1.Start(p898) -- Line: 4547
    -- upvalues: u60 (ref), u2 (ref), u59 (ref), u6 (ref), u3 (ref), u9 (ref), u1 (copy), u7 (ref), u8 (ref), u58 (ref), u57 (ref), restorePlayerConnect (copy), LocalPlayer (copy), HttpService (copy), u130 (copy), u14 (ref), u129 (copy), u131 (copy), u28 (copy), u13 (ref), TweenService (copy), u42 (ref), u41 (ref), u38 (copy), u5 (ref), UpdateResetPage (copy), u11 (ref), u12 (ref), u15 (ref), u31 (ref), u48 (copy), u51 (ref), u50 (ref), u49 (copy), u47 (copy), u34 (copy), u40 (copy), ApplyOptimizationPreset (copy), CanAccessSetting (copy), u52 (ref), u53 (ref), CollectGroups (copy), u30 (ref), u33 (copy), u37 (copy), fireConnect (copy), decodeKeybinds (copy), NewGroupedToggle (copy), u29 (copy), u780 (copy), NewSearchEntry (copy), GetCondition (copy), u35 (copy), u36 (copy), u835 (ref), u46 (ref), u783 (ref), u784 (ref), QueueSearch (copy), RestoreSearch (copy), TweenInfo_new_ret2 (copy), u785 (ref), RunSearch (copy), u23 (ref)
    u60 = u2.GetComponent("Notify");
    u59 = u2.GetComponent("MobileButtons");
    u6 = u3.AddTab("Settings");
    u9 = u6.Parent.Parent;
    u3.AddSideButton("Settings", u6, "rbxassetid://74496950794905", 3);
    u1.bottom();
    u7 = u1.newdrop();
    u7:SetAttribute("Visible", false);
    u8 = u1.HoverDescriptionUI();
    local u899 = false;
    local u900 = false;
    u1:AddConnection("Game", "Gameplay", "Use Own Settings While Spectating", function(p901) -- Line: 4562
        -- upvalues: u58 (ref), u900 (ref), u57 (ref), u1 (ref), restorePlayerConnect (ref)
        u58 = p901;

        if u900 then
            return;
        end;

        if not (p901 and u57) then
            if not p901 and u57 then
                u1.GetSettingsFromPlayer(u57, true);
            end;

            return;
        end;

        u900 = true;
        u1.UpdatePlayerSettings(true, true);
        restorePlayerConnect();
        task.defer(function() -- Line: 4577
            -- upvalues: u900 (ref)
            u900 = false;
        end);
    end);
    u1.UpdatePlayerSettings(true);
    LocalPlayer.PlayerGui:GetAttributeChangedSignal("PlayerSettings"):Connect(function() -- Line: 4589
        -- upvalues: u899 (ref), HttpService (ref), LocalPlayer (ref), u1 (ref)
        if u899 then
            return;
        end;

        local v902 = HttpService:JSONDecode(LocalPlayer.PlayerGui:GetAttribute("PlayerSettings"));
        local v903 = v902.FireConnects == true;
        v902.FireConnects = false;
        u1.UpdatePlayerSettings(v903);
    end);
    task.spawn(function() -- Line: 4602
        -- upvalues: u130 (ref), u14 (ref), u129 (ref), u131 (ref)
        while true do
            if not task.wait(0.1) then
                return;
            end;

            for i = 1, 2 do
                local table_remove_ret = table.remove(u130, 1);

                if not table_remove_ret then
                    break;
                end;

                u14.Gui.ChangePlayerSetting.Fire(u129[table_remove_ret]);
                u129[table_remove_ret] = nil;
                u131[table_remove_ret].Time = os.clock();
                local _ = i;
            end;
        end;
    end);
    Reset.MouseButton1Click:Connect(function() -- Line: 4620
        -- upvalues: u60 (ref), u14 (ref), u899 (ref), u28 (ref), u1 (ref), u13 (ref)
        u60:Create("Settings Reset", "Are you sure you want to reset settings to default?", function() -- Line: 4621
            -- upvalues: u14 (ref), u899 (ref), u28 (ref), u1 (ref)
            u14.Gui.ResetPlayerSettings.Fire();
            u899 = true;
            task.delay(1, function() -- Line: 4624
                -- upvalues: u28 (ref), u1 (ref), u899 (ref)
                for _, v in u28 do
                    task.defer(v.SetDefault, v);
                end;

                u1.UpdatePlayerSettings(true);
                u899 = false;
            end);
        end);
        u13.Play("UI.submenu_dropdown_option_select");
    end);
    Reset.MouseEnter:Connect(function() -- Line: 4638
        -- upvalues: u13 (ref), TweenService (ref)
        u13.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(Reset, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.85
        }):Play();
    end);
    Reset.MouseLeave:Connect(function() -- Line: 4644
        -- upvalues: TweenService (ref)
        TweenService:Create(Reset, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        }):Play();
    end);
    u42.MouseButton1Click:Connect(function() -- Line: 4648
        -- upvalues: u42 (ref), u41 (ref), u60 (ref), u14 (ref), u38 (ref), u13 (ref)
        if not u42.Active then
            return;
        end;

        local u904 = u41;
        u60:Create("Reset Page", "Are you sure you want to reset this page to default?", function() -- Line: 4655
            -- upvalues: u904 (copy), u14 (ref), u38 (ref)
            if u904 == ViewmodelOffsetFrame.Parent then
                u14.Gui.ViewmodelPreset.Fire("Reset");
            end;

            for _, v in u38 do
                if v.PageFrame == u904 and v.Changed then
                    task.defer(v.Reset);
                end;
            end;
        end);
        u13.Play("UI.submenu_dropdown_option_select");
    end);
    u42.MouseEnter:Connect(function() -- Line: 4670
        -- upvalues: u42 (ref), u13 (ref), TweenService (ref)
        if not u42.Active then
            return;
        end;

        u13.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u42, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.85
        }):Play();
    end);
    u42.MouseLeave:Connect(function() -- Line: 4680
        -- upvalues: TweenService (ref), u42 (ref)
        TweenService:Create(u42, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        }):Play();
    end);
    local v905 = u5:CreateTab(u6);

    local function WatchPage(u906) -- Line: 4718
        -- upvalues: u41 (ref), UpdateResetPage (ref)
        u906:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4719
            -- upvalues: u906 (copy), u41 (ref), UpdateResetPage (ref)
            if u906.Visible then
                u41 = u906;
                UpdateResetPage();
            end;
        end);
    end;

    for i, v in u11.GetData() do
        local u907 = u12.SettingsTabNum[i];
        local v908 = v905:CreatePage(i, u907, true, false);
        local v909 = {};
        local u910;

        if i == "Maps" then
            u910 = v905:CreatePage("Maps", 1, false, true, v908);
            u1.remode(u910);
            u910:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4719
                -- upvalues: u910 (copy), u41 (ref), UpdateResetPage (ref)
                if u910.Visible then
                    u41 = u910;
                    UpdateResetPage();
                end;
            end);
        else
            u910 = nil;
        end;

        local u911 = i;

        for i2, v2 in v do
            if not (i2 == "Mobile Buttons" and u15() ~= "Mobile" or (i2 == "Controller Binds" and u15() ~= "Console" or i2 == "Keybinds" and u15() == "Mobile")) then
                local u912 = u12.SettingsPageNum[i2];
                local v913, u914, u915;

                if u911 == "Maps" then
                    local v916 = u1.NewNull(u910, -201);
                    local v917 = u1.NewSection("Preset", u910, -200);
                    local v920, v921 = u1.NewDropDown(true, u48, "Default", u31[i2] and (u31[i2].Selected or "Default") or "Default", function(p918) -- Line: 4773
                        -- upvalues: u14 (ref), i2 (copy), u51 (ref), u50 (ref), u49 (ref)
                        u14.Gui.SelectMapPreset.Fire({
                            M = i2,
                            P = p918
                        });
                        local v919 = i2;

                        if not u51 then
                            if not u50 then
                                return;
                            end;

                            local _ = u49.Potato[v919];
                            u50.SetValue("Custom", true);
                        end;
                    end, nil, "Map Preset", u910, -199, "Default disables map overrides. Optimizations enables every performance setting. Presets 1-5 save every map setting.");
                    u47[i2] = v921;
                    u34[v916] = i2;
                    u34[v917] = i2;
                    u34[v920] = i2;
                    v913 = v2;
                    u914 = u910;
                    u915 = i2;
                else
                    u914 = v905:CreatePage(i2, u912, false, true, v908);
                    u1.remode(u914);
                    u40[u914] = true;
                    u914:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4719
                        -- upvalues: u914 (copy), u41 (ref), UpdateResetPage (ref)
                        if u914.Visible then
                            u41 = u914;
                            UpdateResetPage();
                        end;
                    end);

                    if i2 == "Graphics & Visuals" then
                        u1.NewSection("Optimization Preset", u914, -100);
                        local _, v922 = u1.NewDropDown(true, { "Custom", "Potato", "Medium", "High" }, "Custom", "Custom", ApplyOptimizationPreset, nil, "Optimization Preset", u914, -99, "Applies a group of existing graphics, effects, ragdoll, texture, and map settings. Custom leaves your settings unchanged.");
                        u50 = v922;
                        table.insert(u28, v922);
                    end;

                    v913 = v2;
                    u915 = i2;
                    local v923 = false;

                    for _, v3 in v2 do
                        if CanAccessSetting(v3) and not v3.Section then
                            v923 = true;
                            break;
                        end;
                    end;

                    if v923 then
                        u1.NewSection(u915, u914, 0);
                    end;
                end;

                if u915 == "Crosshair" then
                    u52 = u1.crosshairFrame(u914);
                    u1.SidePreview(u914, u52);
                elseif u915 == "Viewmodel" then
                    u1.ViewmodelOffset(u914);
                    u1.SidePreview(u914, ViewmodelOffsetFrame);
                elseif u915 == "HUD & UI" then
                    u53 = u1.hudEdges(u914);
                    u1.SidePreview(u914, u53);
                end;

                if u915 == "Mobile Buttons" then
                    u1.NewCallbackButton(function() -- Line: 4821
                        -- upvalues: u59 (ref)
                        u59.Visible(true);
                    end, "Mobile Controls", u914, 3);
                end;

                table.insert(v909, u915);
                local v924 = {};
                local v925 = {};

                for i3, v3 in v913 do
                    if CanAccessSetting(v3) and v3.Section then
                        local LayoutOrder = v3.LayoutOrder;

                        if not v924[v3.Section] or LayoutOrder < v924[v3.Section] then
                            v924[v3.Section] = LayoutOrder;
                        end;

                        local v926 = v925[v3.Section] or {
                            Conditional = false,
                            Tab = u911,
                            Page = u915,
                            Settings = {}
                        };
                        v925[v3.Section] = v926;
                        table.insert(v926.Settings, i3);
                        v926.Conditional = v926.Conditional or (v3.ShowIf ~= nil and true or v3.HideIf ~= nil);
                    end;
                end;

                local v927 = CollectGroups(v913);

                for i3, v3 in v913 do
                    if v3.LayoutOrder and CanAccessSetting(v3) then
                        local u928 = u12.SettingsNum[i3];
                        local LayoutOrder = v3.LayoutOrder;
                        local v929 = u30[u911][u915][i3];
                        local v930 = nil;
                        local v931 = nil;

                        if v3.Section and v924[v3.Section] then
                            local v932 = u1.NewNull(u914, v924[v3.Section]);
                            local v933 = u1.NewSection(v3.Section, u914, v924[v3.Section]);

                            if u911 == "Maps" then
                                u34[v932] = u915;
                                u34[v933] = u915;
                            end;

                            if v3.Gamepass then
                                u33[v932] = v3.Gamepass;
                                u33[v933] = v3.Gamepass;
                            end;

                            local v934 = v925[v3.Section];

                            if v934.Conditional then
                                u37[v932] = v934;
                                u37[v933] = v934;
                            end;

                            v924[v3.Section] = nil;
                        end;

                        if v3.Slider then
                            v930, v931 = u1.NewSlider(i3, u914, v3.Default, v929 or v3.Default, v3.Slider.Min, v3.Slider.Max, v3.Percent, function(p935) -- Line: 4891
                                -- upvalues: u911 (copy), u915 (copy), i3 (copy), u928 (copy), u907 (copy), u912 (copy), u129 (ref), u130 (ref), u131 (ref), u30 (ref), u1 (ref), fireConnect (ref), u51 (ref), u50 (ref), u49 (ref)
                                local v936 = {
                                    I = u928,
                                    A = u907,
                                    B = u912,
                                    V = math.round(p935 * 1000) / 1000
                                };
                                local v937 = `{u911}/{u915}/{i3}`;

                                if not u129[v937] then
                                    table.insert(u130, v937);
                                end;

                                u129[v937] = v936;
                                u131[v937] = {
                                    Value = p935,
                                    Time = os.clock()
                                };
                                u30[u911][u915][i3] = p935;

                                if u915 == "Crosshair" then
                                    u1.UpdateCrosshairFrame();
                                elseif u915 == "Viewmodel" or u915 == "Gameplay" then
                                    u1.UpdateViewmodelOffset();
                                elseif u915 == "HUD & UI" then
                                    u1.UpdateHudEdges();
                                end;

                                fireConnect(u911, u915, i3, p935);
                                local v938 = u911;
                                local v939 = u915;
                                local v940 = i3;

                                if not u51 then
                                    if not u50 then
                                        return;
                                    end;

                                    local v941 = u49.Potato[v939];

                                    if v938 == "Maps" or v938 == "Game" and (v941 and v941[v940] ~= nil) then
                                        u50.SetValue("Custom", true);
                                    end;
                                end;
                            end, LayoutOrder, nil, v3.Description);
                        elseif v3.ColorPicker then
                            v930, v931 = u1.NewColorPicker(i3, u914, Color3.fromRGB(unpack(v3.Default)), Color3.fromRGB(unpack(v929 or v3.Default)), function(p942) -- Line: 4912
                                -- upvalues: u911 (copy), u915 (copy), i3 (copy), u928 (copy), u907 (copy), u912 (copy), u129 (ref), u130 (ref), u131 (ref), u30 (ref), u1 (ref), fireConnect (ref), u51 (ref), u50 (ref), u49 (ref)
                                local v943 = { math.round(p942.R * 255), math.round(p942.G * 255), (math.round(p942.B * 255)) };
                                local v944 = {
                                    I = u928,
                                    A = u907,
                                    B = u912,
                                    V = v943
                                };
                                local v945 = `{u911}/{u915}/{i3}`;

                                if not u129[v945] then
                                    table.insert(u130, v945);
                                end;

                                u129[v945] = v944;
                                u131[v945] = {
                                    Value = v943,
                                    Time = os.clock()
                                };
                                u30[u911][u915][i3] = v943;

                                if u915 == "Crosshair" then
                                    u1.UpdateCrosshairFrame();
                                end;

                                fireConnect(u911, u915, i3, v943);
                                local v946 = u911;
                                local v947 = u915;
                                local v948 = i3;

                                if not u51 then
                                    if not u50 then
                                        return;
                                    end;

                                    local v949 = u49.Potato[v947];

                                    if v946 == "Maps" or v946 == "Game" and (v949 and v949[v948] ~= nil) then
                                        u50.SetValue("Custom", true);
                                    end;
                                end;
                            end, LayoutOrder, v3.Description);
                        elseif v3.Keybind then
                            local v950 = decodeKeybinds(v3.Default);
                            v930, v931 = u1.NewKeybind(i3, u914, v950, v929, function(p951) -- Line: 4933
                                -- upvalues: u12 (ref), u14 (ref), u928 (copy), u907 (copy), u912 (copy), fireConnect (ref), u911 (copy), u915 (copy), i3 (copy)
                                local v952 = {};

                                for i4 = 1, 2 do
                                    local v953 = p951[i4];
                                    local v954 = type(v953) == "string" and "MouseWheel" or (v953 and (v953.EnumType == Enum.UserInputType and "UserInputType" or "KeyCode") or "None");
                                    v952[i4] = v954 == "None" and { u12.InputsNum.None, 0 } or { u12.InputsNum[v954], u12.KeybindsNum[type(v953) == "string" and v953 and v953 or v953.Name] };
                                    local _ = i4;
                                end;

                                u14.Gui.ChangePlayerSetting.Fire({
                                    I = u928,
                                    A = u907,
                                    B = u912,
                                    V = v952
                                });
                                fireConnect(u911, u915, i3, p951);
                            end, LayoutOrder, v3.Description, u915 == "Controller Binds");
                        elseif v3.Toggle then
                            local function OnToggle(p955) -- Line: 4951
                                -- upvalues: u911 (copy), u915 (copy), i3 (copy), u928 (copy), u907 (copy), u912 (copy), u129 (ref), u130 (ref), u131 (ref), u30 (ref), u1 (ref), fireConnect (ref), u51 (ref), u50 (ref), u49 (ref)
                                local v956 = {
                                    I = u928,
                                    A = u907,
                                    B = u912,
                                    V = p955 and 1 or 0
                                };
                                local v957 = `{u911}/{u915}/{i3}`;

                                if not u129[v957] then
                                    table.insert(u130, v957);
                                end;

                                u129[v957] = v956;
                                u131[v957] = {
                                    Value = p955,
                                    Time = os.clock()
                                };
                                u30[u911][u915][i3] = p955;

                                if u915 == "Crosshair" then
                                    u1.UpdateCrosshairFrame();
                                elseif u915 == "Viewmodel" or u915 == "Gameplay" then
                                    u1.UpdateViewmodelOffset();
                                elseif u915 == "HUD & UI" then
                                    u1.UpdateHudEdges();
                                end;

                                fireConnect(u911, u915, i3, p955);
                                local v958 = u911;
                                local v959 = u915;
                                local v960 = i3;

                                if not u51 then
                                    if not u50 then
                                        return;
                                    end;

                                    local v961 = u49.Potato[v959];

                                    if v958 == "Maps" or v958 == "Game" and (v961 and v961[v960] ~= nil) then
                                        u50.SetValue("Custom", true);
                                    end;
                                end;
                            end;

                            local v962 = v927[v3.Group];

                            if v962 then
                                v930, v931 = NewGroupedToggle(v962, v3.Group, v913, u30[u911][u915], i3, u914, OnToggle);
                            else
                                if v929 == nil then
                                    v929 = v3.Default or v929;
                                end;

                                v930, v931 = u1.NewToggle(i3, u914, v3.Default, v929, OnToggle, LayoutOrder, v3.Description);
                            end;
                        elseif v3.Dropdown then
                            v930, v931 = u1.NewDropDown(true, v3.Dropdown, v3.Default, v929 or v3.Default, function(p963) -- Line: 4979
                                -- upvalues: u911 (copy), u915 (copy), i3 (copy), u928 (copy), u907 (copy), u912 (copy), u12 (ref), u129 (ref), u130 (ref), u131 (ref), u30 (ref), u1 (ref), fireConnect (ref), u51 (ref), u50 (ref), u49 (ref)
                                local v964 = {
                                    I = u928,
                                    A = u907,
                                    B = u912,
                                    V = u12.SettingsDropdownNum[p963]
                                };
                                local v965 = `{u911}/{u915}/{i3}`;

                                if not u129[v965] then
                                    table.insert(u130, v965);
                                end;

                                u129[v965] = v964;
                                u131[v965] = {
                                    Value = p963,
                                    Time = os.clock()
                                };
                                u30[u911][u915][i3] = p963;

                                if u915 == "Crosshair" then
                                    u1.UpdateCrosshairFrame();
                                elseif u915 == "Viewmodel" or u915 == "Gameplay" then
                                    u1.UpdateViewmodelOffset();
                                elseif u915 == "HUD & UI" then
                                    u1.UpdateHudEdges();
                                end;

                                fireConnect(u911, u915, i3, p963);
                                local v966 = u911;
                                local v967 = u915;
                                local v968 = i3;

                                if not u51 then
                                    if not u50 then
                                        return;
                                    end;

                                    local v969 = u49.Potato[v967];

                                    if v966 == "Maps" or v966 == "Game" and (v969 and v969[v968] ~= nil) then
                                        u50.SetValue("Custom", true);
                                    end;
                                end;
                            end, nil, i3, u914, LayoutOrder, v3.Description);
                        elseif v3.MultiDropdown then
                            v930, v931 = u1.NewMultiDropDown(v3.MultiDropdown, v3.Default, v929 or v3.Default, function(p970) -- Line: 5000
                                -- upvalues: u12 (ref), u14 (ref), u928 (copy), u907 (copy), u912 (copy), fireConnect (ref), u911 (copy), u915 (copy), i3 (copy), u51 (ref), u50 (ref), u49 (ref)
                                local v971 = {};

                                for i4, v4 in p970 do
                                    if v4 then
                                        table.insert(v971, u12.SettingsDropdownNum[i4]);
                                    end;
                                end;

                                u14.Gui.ChangePlayerSetting.Fire({
                                    I = u928,
                                    A = u907,
                                    B = u912,
                                    V = v971
                                });
                                fireConnect(u911, u915, i3, p970);
                                local v972 = u911;
                                local v973 = u915;
                                local v974 = i3;

                                if not u51 then
                                    if not u50 then
                                        return;
                                    end;

                                    local v975 = u49.Potato[v973];

                                    if v972 == "Maps" or v972 == "Game" and (v975 and v975[v974] ~= nil) then
                                        u50.SetValue("Custom", true);
                                    end;
                                end;
                            end, i3, u914, LayoutOrder, v3.Description);
                        elseif v3.TextBox then
                            v930, v931 = u1.NewTextBox(i3, u914, v3.Default, v929 or v3.Default, v3.TextBox, function(p976) -- Line: 5022
                                -- upvalues: u911 (copy), u915 (copy), i3 (copy), u928 (copy), u907 (copy), u912 (copy), u129 (ref), u130 (ref), u131 (ref), u30 (ref), u1 (ref), fireConnect (ref), u51 (ref), u50 (ref), u49 (ref)
                                local v977 = {
                                    I = u928,
                                    A = u907,
                                    B = u912,
                                    V = p976
                                };
                                local v978 = `{u911}/{u915}/{i3}`;

                                if not u129[v978] then
                                    table.insert(u130, v978);
                                end;

                                u129[v978] = v977;
                                u131[v978] = {
                                    Value = p976,
                                    Time = os.clock()
                                };
                                u30[u911][u915][i3] = p976;

                                if u915 == "Crosshair" then
                                    u1.UpdateCrosshairFrame();
                                end;

                                fireConnect(u911, u915, i3, p976);
                                local v979 = u911;
                                local v980 = u915;
                                local v981 = i3;

                                if not u51 then
                                    if not u50 then
                                        return;
                                    end;

                                    local v982 = u49.Potato[v980];

                                    if v979 == "Maps" or v979 == "Game" and (v982 and v982[v981] ~= nil) then
                                        u50.SetValue("Custom", true);
                                    end;
                                end;
                            end, LayoutOrder, v3.Description);
                        end;

                        table.insert(u28, v931);
                        u29[u911] = u29[u911] or {};
                        u29[u911][u915] = u29[u911][u915] or {};
                        u29[u911][u915][i3] = v931;
                        local v983 = v927[v3.Group];

                        if u911 ~= "Maps" and not (v983 or v3.MobileControls) then
                            u1.TrackChanged(u911, u915, i3, v3, v930, v931, u914);
                        end;

                        if not v983 or v983.Members[1] == i3 then
                            local v984, v985;

                            if v983 then
                                v984 = i3;
                                v985 = v3;
                                local v986 = {};

                                for _, v4 in v983.Members do
                                    table.insert(v986, v913[v4].Description);
                                end;

                                local v987 = NewSearchEntry(u911, u915, v985.Group, {
                                    LayoutOrder = v985.LayoutOrder,
                                    Section = v985.Section,
                                    Gamepass = v985.Gamepass,
                                    MultiDropdown = v983.Options,
                                    Description = table.concat(v986, " ")
                                }, v930);
                                table.insert(u780, v987);
                            else
                                local v988 = NewSearchEntry(u911, u915, i3, v3, v930);
                                table.insert(u780, v988);
                                v984 = i3;
                                v985 = v3;
                            end;

                            if u911 == "Maps" then
                                u34[v930] = u915;
                            end;

                            if v985.Gamepass then
                                u33[v930] = v985.Gamepass;
                            end;

                            local v989 = GetCondition(u911, v913, v985, v984);

                            if v989 then
                                u35[v930] = { u911, u915, v984 };
                                u36[v989[1]] = true;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        if u911 == "Maps" then
            u1.NewDropDown(true, v909, v909[1], v909[1], function(p990) -- Line: 5090
                -- upvalues: u835 (ref), u46 (ref)
                u835 = p990;
                u46();
            end, nil, "Select Map", u910, nil, "Choose which map\'s settings to view and edit.");
            u835 = v909[1];
        end;
    end;

    u783 = v905:CreatePage("Search", 0, false, false, nil, true);
    u1.remode(u783);
    local u991 = u783;
    u991:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4719
        -- upvalues: u991 (copy), u41 (ref), UpdateResetPage (ref)
        if u991.Visible then
            u41 = u991;
            UpdateResetPage();
        end;
    end);
    u1.searchHintUI().Parent = u783;
    u784 = u1.searchUI();
    u784.Parent = u6;
    local TextBox = u784.Box.TextBox;
    TextBox:GetPropertyChangedSignal("Text"):Connect(QueueSearch);
    TextBox.Focused:Connect(function() -- Line: 5110
        -- upvalues: TweenService (ref), u784 (ref)
        TweenService:Create(u784.Box.Line, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundTransparency = 0.1
        }):Play();
    end);
    TextBox.FocusLost:Connect(function() -- Line: 5114
        -- upvalues: TweenService (ref), u784 (ref)
        TweenService:Create(u784.Box.Line, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundTransparency = 0.6
        }):Play();
    end);
    u783:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 5118
        -- upvalues: u784 (ref), u783 (ref), RestoreSearch (ref), TweenService (ref), TweenInfo_new_ret2 (ref), u785 (ref), RunSearch (ref), u15 (ref), TextBox (copy)
        u784.Visible = u783.Visible;

        if not u783.Visible then
            RestoreSearch();

            return;
        end;

        local Box = u784.Box;
        Box.Line.Size = UDim2.new(0, 0, 0, 2);
        Box.Icon.ImageTransparency = 1;
        Box.TextBox.TextTransparency = 1;
        u783.Position = UDim2.new(0.5, 0, 0.118, 12);
        TweenService:Create(Box.Line, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, 2)
        }):Play();
        TweenService:Create(Box.Icon, TweenInfo_new_ret2, {
            ImageTransparency = 0
        }):Play();
        TweenService:Create(Box.TextBox, TweenInfo_new_ret2, {
            TextTransparency = 0
        }):Play();
        TweenService:Create(u783, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0.5, 0, 0.118, 0)
        }):Play();

        if not u785 then
            u785 = true;
            task.defer(RunSearch);
        end;

        if u15() ~= "Mobile" then
            TextBox:CaptureFocus();
        end;
    end);
    u1.UpdateCrosshairFrame();
    u1.UpdateViewmodelOffset();
    u1.UpdateHudEdges();
    u46();
    u23.Changed("Gamepasses"):Connect(function() -- Line: 5150
        -- upvalues: u46 (ref)
        u46();
    end);
end;

function u1.sectionUI() -- Line: 5157
    local Frame = Instance.new("Frame");
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    local TextLabel = Instance.new("TextLabel");
    Frame.Name = "Section";
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame.BackgroundTransparency = 1;
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.LayoutOrder = 1;
    Frame.Size = UDim2.new(1, 0, 0, 0);
    UIAspectRatioConstraint.Parent = Frame;
    UIAspectRatioConstraint.AspectRatio = 17.5;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.new(0, 2, 0.5, 0);
    TextLabel.Size = UDim2.fromScale(0.5, 0.5);
    TextLabel.Text = "Crosshair";
    TextLabel.TextColor3 = Color3.fromRGB(193, 193, 193);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.1;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;

    return Frame;
end;

function u1.sliderUI() -- Line: 5194
    local TextButton = Instance.new("TextButton");
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    local TextLabel = Instance.new("TextLabel");
    local TextButton2 = Instance.new("TextButton");
    local Frame = Instance.new("Frame");
    local Frame2 = Instance.new("Frame");
    local UICorner = Instance.new("UICorner");
    local Frame3 = Instance.new("Frame");
    local Frame4 = Instance.new("Frame");
    local Frame5 = Instance.new("Frame");
    local UIStroke = Instance.new("UIStroke");
    local UICorner2 = Instance.new("UICorner");
    local TextBox = Instance.new("TextBox");
    TextButton.Name = "Slider";
    TextButton:SetAttribute("NoSelect", true);
    TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.BackgroundTransparency = 1;
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0);
    TextButton.BorderSizePixel = 0;
    TextButton.LayoutOrder = 2;
    TextButton.Size = UDim2.new(1, 0, 0.100000001, 0);
    TextButton.AutoButtonColor = false;
    TextButton.Font = Enum.Font.SourceSans;
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.fromRGB(0, 0, 0);
    TextButton.TextSize = 14;
    UIAspectRatioConstraint.Parent = TextButton;
    UIAspectRatioConstraint.AspectRatio = 17.5;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    TextLabel.Name = "SlideText";
    TextLabel.Parent = TextButton;
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.BorderSizePixel = 0;
    TextLabel.Position = UDim2.new(0, 2, 0.5, 0);
    TextLabel.Size = UDim2.new(0.5, 0, 0.5, 0);
    TextLabel.FontFace = Font.fromId(12187375422, Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Text = "Slider";
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextScaled = true;
    TextLabel.TextSize = 14;
    TextLabel.TextTransparency = 0.35;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton2.Name = "Scroll";
    TextButton2.Parent = TextButton;
    TextButton2.AnchorPoint = Vector2.new(1, 0.5);
    TextButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TextButton2.BackgroundTransparency = 1;
    TextButton2.BorderColor3 = Color3.fromRGB(0, 0, 0);
    TextButton2.BorderSizePixel = 0;
    TextButton2.Position = UDim2.new(0.875, 0, 0.5, 0);
    TextButton2.Size = UDim2.new(0.25, 0, 0.800000012, 0);
    TextButton2.AutoButtonColor = false;
    TextButton2.Font = Enum.Font.SourceSans;
    TextButton2.Text = "";
    TextButton2.TextColor3 = Color3.fromRGB(0, 0, 0);
    TextButton2.TextSize = 14;
    Frame.Name = "Scroll";
    Frame.Parent = TextButton2;
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame.BackgroundTransparency = 0.8;
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.new(0, 0, 0.5, 0);
    Frame.Size = UDim2.new(1, 0, 0.174999997, 0);
    Frame3.Name = "Bar";
    Frame3.Parent = Frame;
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame3.BackgroundTransparency = 0.6;
    Frame3.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.new(0, 0, 0.5, 0);
    Frame3.Size = UDim2.new(0.5, 0, 1, 0);
    Frame2.Name = "Dot";
    Frame2.Parent = Frame3;
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.new(1, 0, 0.5, 0);
    Frame2.Size = UDim2.new(2, 0, 1.55000002, 0);
    Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    UICorner.CornerRadius = UDim.new(0.200000003, 0);
    UICorner.Parent = Frame2;
    Frame4.Name = "Line";
    Frame4.Parent = TextButton;
    Frame4.AnchorPoint = Vector2.new(0.5, 1);
    Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame4.BackgroundTransparency = 0.8;
    Frame4.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.new(0.5, 0, 1, 0);
    Frame4.Size = UDim2.new(1, 0, 0, 1);
    Frame5.Name = "Value";
    Frame5.Parent = TextButton;
    Frame5.AnchorPoint = Vector2.new(1, 0.5);
    Frame5.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame5.BackgroundTransparency = 0.8;
    Frame5.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.new(1, -5, 0.5, 0);
    Frame5.Size = UDim2.new(0.100000001, 0, 0.600000024, 0);
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.1;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = Frame5;
    UICorner2.CornerRadius = UDim.new(0.0500000007, 0);
    UICorner2.Parent = Frame5;
    TextBox.Parent = Frame5;
    TextBox:SetAttribute("NoSelect", true);
    TextBox.AnchorPoint = Vector2.new(0.5, 0.5);
    TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TextBox.BackgroundTransparency = 1;
    TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0);
    TextBox.BorderSizePixel = 0;
    TextBox.Position = UDim2.new(0.5, 0, 0.5, 0);
    TextBox.Size = UDim2.new(0.800000012, 0, 0.800000012, 0);
    TextBox.FontFace = Font.fromId(12187375422, Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178);
    TextBox.Text = "1.05";
    TextBox.TextColor3 = Color3.fromRGB(206, 206, 206);
    TextBox.TextScaled = true;
    TextBox.TextSize = 14;
    TextBox.TextWrapped = true;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;

    return TextButton;
end;

function u1.nullUI() -- Line: 5344
    local Frame = Instance.new("Frame");
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    Frame.Name = "Null";
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame.BackgroundTransparency = 1;
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.LayoutOrder = 3;
    Frame.Size = UDim2.new(1, 0, 0, 0);
    UIAspectRatioConstraint.AspectRatio = 17.5;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = Frame;

    return Frame;
end;

function u1.toggleUI() -- Line: 5363
    local TextButton = Instance.new("TextButton");
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    local TextLabel = Instance.new("TextLabel");
    local Frame = Instance.new("Frame");
    local ImageLabel = Instance.new("ImageLabel");
    local UIStroke = Instance.new("UIStroke");
    local UICorner = Instance.new("UICorner");
    TextButton.Name = "Toggle";
    TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.BackgroundTransparency = 1;
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0);
    TextButton.BorderSizePixel = 0;
    TextButton.LayoutOrder = 2;
    TextButton.Size = UDim2.new(1, 0, 0.100000001, 0);
    TextButton.AutoButtonColor = false;
    TextButton.Font = Enum.Font.SourceSans;
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.fromRGB(0, 0, 0);
    TextButton.TextSize = 14;
    UIAspectRatioConstraint.Name = "UIAspectRatio";
    UIAspectRatioConstraint.AspectRatio = 17.5;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = TextButton;
    TextLabel.Name = "ToggleName";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.BorderSizePixel = 0;
    TextLabel.Position = UDim2.new(0, 2, 0.5, 0);
    TextLabel.Size = UDim2.new(0.5, 0, 0.5, 0);
    TextLabel.FontFace = Font.fromId(12187375422, Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Text = "Toggle";
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextScaled = true;
    TextLabel.TextSize = 14;
    TextLabel.TextTransparency = 0.35;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = TextButton;
    Frame.Name = "Line";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame.BackgroundTransparency = 0.8;
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.new(0.5, 0, 1, 0);
    Frame.Size = UDim2.new(1, 0, 0, 1);
    Frame.Parent = TextButton;
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    ImageLabel.BackgroundTransparency = 0.8;
    ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0);
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Position = UDim2.new(0.980000019, 0, 0.5, 0);
    ImageLabel.Size = UDim2.new(0.5, -4, 0.5, -4);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Parent = TextButton;
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.1;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = ImageLabel;
    UICorner.CornerRadius = UDim.new(0.0500000007, 0);
    UICorner.Parent = ImageLabel;

    return TextButton;
end;

function u1.textBoxUI() -- Line: 5443
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "TextBox";
    TextButton:SetAttribute("NoSelect", true);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.LayoutOrder = 2;
    TextButton.Size = UDim2.fromScale(1, 0.1);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.AspectRatio = 17.5;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "BoxTitle";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.new(0, 2, 0.5, 0);
    TextLabel.Size = UDim2.fromScale(0.5, 0.5);
    TextLabel.Text = "TextBox";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.35;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = TextButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Line";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.8;
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 1);
    Frame.Size = UDim2.new(1, 0, 0, 1);
    Frame.Parent = TextButton;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Value";
    Frame2.AnchorPoint = Vector2.new(1, 0.5);
    Frame2.BackgroundColor3 = Color3.new();
    Frame2.BackgroundTransparency = 0.8;
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.new(0.945, -4, 0.5, 0);
    Frame2.Size = UDim2.fromScale(0.3, 0.65);
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.1;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = Frame2;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.05, 0);
    UICorner.Parent = Frame2;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.AnchorPoint = Vector2.new(0, 0.5);
    TextBox.BackgroundTransparency = 1;
    TextBox.ClearTextOnFocus = false;
    TextBox.ClipsDescendants = true;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178);
    TextBox.Position = UDim2.fromScale(0.04, 0.52);
    TextBox.Size = UDim2.fromScale(0.72, 0.7);
    TextBox.Text = "";
    TextBox.TextColor3 = Color3.fromRGB(206, 206, 206);
    TextBox.TextScaled = true;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Count";
    TextLabel2.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.96, 0.52);
    TextLabel2.Size = UDim2.fromScale(0.2, 0.5);
    TextLabel2.Text = "";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 1;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel2.Parent = Frame2;
    Frame2.Parent = TextButton;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Reset";
    ImageButton.AnchorPoint = Vector2.new(1, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.new();
    ImageButton.BackgroundTransparency = 0.8;
    ImageButton.ImageTransparency = 1;
    ImageButton.Position = UDim2.new(1, -2, 0.5, 0);
    ImageButton.Size = UDim2.fromScale(0.8, 0.8);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0.05, 0);
    UICorner2.Parent = ImageButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://105171726850563";
    ImageLabel.ImageTransparency = 0.1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.65, 0.65);
    ImageLabel.Parent = ImageButton;
    ImageButton.Parent = TextButton;

    return TextButton;
end;

function u1.keybindUI() -- Line: 5569
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "KeyBind";
    TextButton:SetAttribute("NoSelect", true);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.LayoutOrder = 5;
    TextButton.Size = UDim2.fromScale(1, 0.1);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.AspectRatio = 17.5;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "BindTitle";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.new(0, 2, 0.5, 0);
    TextLabel.Size = UDim2.fromScale(0.407953, 0.5);
    TextLabel.Text = "Character Forward";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.35;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = TextButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Line";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.8;
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 1);
    Frame.Size = UDim2.new(1, 0, 0, 1);
    Frame.Parent = TextButton;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Reset";
    ImageButton.AnchorPoint = Vector2.new(1, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.new();
    ImageButton.BackgroundTransparency = 0.8;
    ImageButton.ImageTransparency = 1;
    ImageButton.Position = UDim2.new(1, -2, 0.5, 0);
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(0.8, 0.8);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.05, 0);
    UICorner.Parent = ImageButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://105171726850563";
    ImageLabel.ImageTransparency = 0.1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.65, 0.65);
    ImageLabel.Parent = ImageButton;
    ImageButton.Parent = TextButton;

    local function createBind(p992, p993, p994) -- Line: 5638
        -- upvalues: TextButton (copy)
        local ImageButton2 = Instance.new("ImageButton");
        ImageButton2.Name = p992;
        ImageButton2.AnchorPoint = Vector2.new(1, 0.5);
        ImageButton2.AutoButtonColor = false;
        ImageButton2.BackgroundColor3 = Color3.new();
        ImageButton2.BackgroundTransparency = 0.9;
        ImageButton2.ImageTransparency = 1;
        ImageButton2.Position = p993;
        ImageButton2.Selectable = false;
        ImageButton2.Size = UDim2.fromScale(0.25, 0.7);
        local UIStroke = Instance.new("UIStroke");
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.Color = Color3.new(1, 1, 1);
        UIStroke.Thickness = 2;
        UIStroke.Transparency = 0.9;
        UIStroke.Parent = ImageButton2;
        local UICorner2 = Instance.new("UICorner");
        UICorner2.CornerRadius = UDim.new(0.025, 0);
        UICorner2.Parent = ImageButton2;
        local ImageButton3 = Instance.new("ImageButton");
        ImageButton3.Name = "Remove";
        ImageButton3:SetAttribute("NoSelect", true);
        ImageButton3.AnchorPoint = Vector2.new(1, 0.5);
        ImageButton3.AutoButtonColor = false;
        ImageButton3.BackgroundColor3 = Color3.new();
        ImageButton3.BackgroundTransparency = 0.9;
        ImageButton3.ImageTransparency = 1;
        ImageButton3.Position = UDim2.new(1, -2, 0.5, 0);
        ImageButton3.Selectable = false;
        ImageButton3.Size = UDim2.new(1, -4, 1, -4);
        ImageButton3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        local UICorner3 = Instance.new("UICorner");
        UICorner3.CornerRadius = UDim.new(0.025, 0);
        UICorner3.Parent = ImageButton3;
        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Name = "Title";
        TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
        TextLabel2.Position = UDim2.fromScale(0.5, 0.5);
        TextLabel2.Size = UDim2.fromScale(0.7, 0.7);
        TextLabel2.Text = "X";
        TextLabel2.TextColor3 = Color3.new(1, 1, 1);
        TextLabel2.TextScaled = true;
        TextLabel2.TextTransparency = 0.1;
        TextLabel2.Parent = ImageButton3;
        ImageButton3.Parent = ImageButton2;
        local TextLabel3 = Instance.new("TextLabel");
        TextLabel3.Name = "Title";
        TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
        TextLabel3.BackgroundTransparency = 1;
        TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        TextLabel3.Position = UDim2.new(0, 2, 0.5, 0);
        TextLabel3.Size = UDim2.fromScale(0.829555, 0.7);
        TextLabel3.Text = p994;
        TextLabel3.TextColor3 = Color3.new(1, 1, 1);
        TextLabel3.TextScaled = true;
        TextLabel3.TextTransparency = 0.1;
        TextLabel3.Parent = ImageButton2;
        ImageButton2.Parent = TextButton;

        return ImageButton2;
    end;

    createBind("Bind1", UDim2.fromScale(0.666382, 0.5), "W");
    createBind("Bind2", UDim2.fromScale(0.925, 0.5), "Up Arrow");

    return TextButton;
end;

function u1.colorUI() -- Line: 5715
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "pickerbtn";
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.LayoutOrder = 2;
    TextButton.Size = UDim2.fromScale(1, 0.1);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "colorconsui";
    UIAspectRatioConstraint.AspectRatio = 17.5;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "colortitle";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.new(0, 2, 0.5, 0);
    TextLabel.Size = UDim2.fromScale(0.5, 0.5);
    TextLabel.Text = "Enable Developer Console";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.35;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = TextButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Line";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.8;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 1);
    Frame.Size = UDim2.new(1, 0, 0, 1);
    Frame.Parent = TextButton;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "SelectedColor";
    ImageButton.AnchorPoint = Vector2.new(1, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.AutoLocalize = false;
    ImageButton.Active = false;
    ImageButton.BackgroundColor3 = Color3.fromRGB(47, 255, 179);
    ImageButton.BackgroundTransparency = 0;
    ImageButton.Position = UDim2.fromScale(0.98, 0.5);
    ImageButton.Size = UDim2.fromScale(0.75, 0.75);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "B";
    UIPadding.PaddingBottom = UDim.new(0.25, 0);
    UIPadding.PaddingLeft = UDim.new(0.05, 0);
    UIPadding.PaddingRight = UDim.new(0.05, 0);
    UIPadding.PaddingTop = UDim.new(0.25, 0);
    UIPadding.Parent = ImageButton;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "A";
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = ImageButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "C";
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.06;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = ImageButton;
    ImageButton.Parent = TextButton;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "ColorPickerFrame";
    Frame2.BackgroundColor3 = Color3.fromRGB(38, 38, 38);
    Frame2.Position = UDim2.new(0.76, 0, 0.1, 0);
    Frame2.Size = UDim2.fromScale(0.275, 0.35);
    Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame2.Visible = false;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Saturation";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 4);
    ImageLabel.Image = "rbxassetid://8630797271";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.035);
    ImageLabel.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel.ZIndex = 2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame3.BackgroundTransparency = 0.8;
    Frame3.Position = UDim2.fromOffset(154, 20);
    Frame3.Size = UDim2.fromScale(0.05, 0.05);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke2.Thickness = 0.2;
    UIStroke2.Parent = Frame3;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame3;
    Frame3.Parent = ImageLabel;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.Parent = ImageLabel;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.05, 0);
    UICorner3.Parent = ImageLabel;
    ImageLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.015);
    TextLabel2.Size = UDim2.fromScale(0.9, 0.0746194);
    TextLabel2.Text = "Color Picker";
    TextLabel2.TextColor3 = Color3.fromRGB(225, 225, 225);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Visible = false;
    TextLabel2.Parent = Frame2;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.Color = Color3.new(1, 1, 1);
    UIStroke4.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke4.Thickness = 0.005;
    UIStroke4.Transparency = 0.8;
    UIStroke4.Parent = Frame2;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Hue";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel2.BackgroundColor3 = Color3.new(1, 1, 1);
    ImageLabel2.Image = "rbxassetid://119231954671550";
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.73);
    ImageLabel2.Size = UDim2.fromScale(0.9, 0.03);
    ImageLabel2.ZIndex = 2;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(1, 0);
    UICorner4.Parent = ImageLabel2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Frame";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame4.BackgroundTransparency = 0.8;
    Frame4.Position = UDim2.fromScale(0, 0.5);
    Frame4.Size = UDim2.fromScale(0.75, 1.5);
    Frame4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(1, 0);
    UICorner5.Parent = Frame4;
    local UIStroke5 = Instance.new("UIStroke");
    UIStroke5.Name = "UIStroke";
    UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke5.Color = Color3.new(1, 1, 1);
    UIStroke5.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke5.Thickness = 0.4;
    UIStroke5.Parent = Frame4;
    Frame4.Parent = ImageLabel2;
    ImageLabel2.Parent = Frame2;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UICorner";
    UICorner6.CornerRadius = UDim.new(0.05, 0);
    UICorner6.Parent = Frame2;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.AspectRatio = 0.73;
    UIAspectRatioConstraint2.Parent = Frame2;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "RGB";
    Frame5.AnchorPoint = Vector2.new(0, 1);
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0.05, 0.96);
    Frame5.Size = UDim2.fromScale(0.54, 0.07);
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "InputB";
    TextBox.AnchorPoint = Vector2.new(1, 0);
    TextBox.BackgroundColor3 = Color3.new(1, 1, 1);
    TextBox.BackgroundTransparency = 0.95;
    TextBox.ClipsDescendants = true;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextBox.PlaceholderText = "B";
    TextBox.Position = UDim2.fromScale(1, 0);
    TextBox.Size = UDim2.fromScale(0.3, 1);
    TextBox.Text = "";
    TextBox.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextBox.TextScaled = true;
    TextBox.TextEditable = true;
    TextBox.ClearTextOnFocus = false;
    TextBox.ZIndex = 4;
    local UICorner7 = Instance.new("UICorner");
    UICorner7.Name = "IGNORE";
    UICorner7.CornerRadius = UDim.new(0, 4);
    UICorner7.Parent = TextBox;
    TextBox.Parent = Frame5;
    local TextBox2 = Instance.new("TextBox");
    TextBox2.Name = "InputG";
    TextBox2.AnchorPoint = Vector2.new(0.5, 0);
    TextBox2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextBox2.BackgroundTransparency = 0.95;
    TextBox2.ClipsDescendants = true;
    TextBox2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextBox2.PlaceholderText = "G";
    TextBox2.Position = UDim2.fromScale(0.5, 0);
    TextBox2.Size = UDim2.fromScale(0.3, 1);
    TextBox2.Text = "";
    TextBox2.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextBox2.TextScaled = true;
    TextBox2.TextEditable = true;
    TextBox2.ClearTextOnFocus = false;
    TextBox2.ZIndex = 4;
    local UICorner8 = Instance.new("UICorner");
    UICorner8.Name = "IGNORE";
    UICorner8.CornerRadius = UDim.new(0, 4);
    UICorner8.Parent = TextBox2;
    TextBox2.Parent = Frame5;
    local TextBox3 = Instance.new("TextBox");
    TextBox3.Name = "InputR";
    TextBox3.BackgroundColor3 = Color3.new(1, 1, 1);
    TextBox3.BackgroundTransparency = 0.95;
    TextBox3.ClipsDescendants = true;
    TextBox3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextBox3.PlaceholderText = "R";
    TextBox3.Size = UDim2.fromScale(0.3, 1);
    TextBox3.Text = "";
    TextBox3.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextBox3.TextScaled = true;
    TextBox3.TextEditable = true;
    TextBox3.ClearTextOnFocus = false;
    TextBox3.ZIndex = 4;
    local UICorner9 = Instance.new("UICorner");
    UICorner9.Name = "IGNORE";
    UICorner9.CornerRadius = UDim.new(0, 4);
    UICorner9.Parent = TextBox3;
    TextBox3.Parent = Frame5;
    Frame5.Parent = Frame2;
    local TextBox4 = Instance.new("TextBox");
    TextBox4.Name = "InputHEX";
    TextBox4.AnchorPoint = Vector2.new(1, 1);
    TextBox4.BackgroundColor3 = Color3.new(1, 1, 1);
    TextBox4.BackgroundTransparency = 0.95;
    TextBox4.ClipsDescendants = true;
    TextBox4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextBox4.PlaceholderText = "HEX";
    TextBox4.Position = UDim2.fromScale(0.95, 0.96);
    TextBox4.Size = UDim2.fromScale(0.330421, 0.07);
    TextBox4.Text = "";
    TextBox4.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextBox4.TextScaled = true;
    TextBox4.ClearTextOnFocus = false;
    TextBox4.TextEditable = true;
    TextBox4.ZIndex = 4;
    local UICorner10 = Instance.new("UICorner");
    UICorner10.Name = "IGNORE";
    UICorner10.CornerRadius = UDim.new(0, 4);
    UICorner10.Parent = TextBox4;
    TextBox4.Parent = Frame2;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Lightness";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel3.BackgroundColor3 = Color3.new(1, 1, 1);
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.82);
    ImageLabel3.Size = UDim2.fromScale(0.9, 0.03);
    ImageLabel3.ZIndex = 2;
    local UICorner11 = Instance.new("UICorner");
    UICorner11.Name = "UICorner";
    UICorner11.CornerRadius = UDim.new(1, 0);
    UICorner11.Parent = ImageLabel3;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Frame";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame6.BackgroundTransparency = 0.8;
    Frame6.Position = UDim2.fromScale(0, 0.5);
    Frame6.Size = UDim2.fromScale(0.75, 1.5);
    Frame6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner12 = Instance.new("UICorner");
    UICorner12.Name = "UICorner";
    UICorner12.CornerRadius = UDim.new(1, 0);
    UICorner12.Parent = Frame6;
    local UIStroke6 = Instance.new("UIStroke");
    UIStroke6.Name = "UIStroke";
    UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke6.Color = Color3.new(1, 1, 1);
    UIStroke6.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke6.Thickness = 0.4;
    UIStroke6.Parent = Frame6;
    Frame6.Parent = ImageLabel3;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new()), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient.Rotation = 180;
    UIGradient.Parent = ImageLabel3;
    ImageLabel3.Parent = Frame2;

    return TextButton, Frame2;
end;

function u1.dropdownUI() -- Line: 6097
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Dropdown";
    TextButton:SetAttribute("NoSelect", true);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.LayoutOrder = 4;
    TextButton.Size = UDim2.fromScale(1, 0.1);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 17.5;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.new(0, 2, 0.5, 0);
    TextLabel.Size = UDim2.fromScale(0.5, 0.5);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.35;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = TextButton;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "DownHold";
    TextButton2.AnchorPoint = Vector2.new(1, 0.5);
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundColor3 = Color3.new();
    TextButton2.BackgroundTransparency = 1;
    TextButton2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton2.Position = UDim2.fromScale(0.99, 0.5);
    TextButton2.Size = UDim2.new(-0.013, 89, 0.8, 0);
    TextButton2.Text = "";
    TextButton2.TextColor3 = Color3.new();
    TextButton2.TextSize = 14;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = TextButton2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "V";
    TextLabel2.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(1, 0.5);
    TextLabel2.Rotation = 90;
    TextLabel2.Size = UDim2.fromScale(0.8, 0.6);
    TextLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel2.Text = ">";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.Parent = TextButton2;
    local Frame = Instance.new("Frame");
    Frame.Name = "AutoLeft";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "uIPaddingauto";
    UIPadding.PaddingLeft = UDim.new(0, 10);
    UIPadding.Parent = Frame;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "TextLabel";
    TextLabel3.AnchorPoint = Vector2.new(0, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0, 0.25);
    TextLabel3.Size = UDim2.fromScale(1, 0.5);
    TextLabel3.Text = "YES";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.Parent = Frame;
    Frame.Parent = TextButton2;
    TextButton2.Parent = TextButton;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Line";
    Frame2.AnchorPoint = Vector2.new(0.5, 1);
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 0.8;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 1);
    Frame2.Size = UDim2.new(1, 0, 0, 2);
    Frame2.Parent = TextButton;

    return TextButton;
end;

function u1.newdrop() -- Line: 6215
    -- upvalues: u2 (ref)
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Dropdown";
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Position = UDim2.fromOffset(1108, 394);
    CanvasGroup.Size = UDim2.fromScale(0.051872, 0.129293);
    CanvasGroup.ZIndex = 100;
    local Frame = Instance.new("Frame");
    Frame.Name = "ScrollingFrame";
    Frame.Active = true;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(38, 38, 38);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.Size = UDim2.new(1, 0, 1, -10);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "ScrollingFrame2";
    ScrollingFrame.Active = true;
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38);
    ScrollingFrame.BorderColor3 = Color3.new();
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.ScrollBarImageColor3 = Color3.new(1, 1, 1);
    ScrollingFrame.ScrollBarImageTransparency = 0.6;
    ScrollingFrame.ScrollBarThickness = 3;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -10);
    ScrollingFrame.Parent = CanvasGroup;
    ScrollingFrame.Visible = false;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.Parent = ScrollingFrame;
    Frame.Parent = CanvasGroup;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 3);
    UICorner.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Top";
    Frame2.BackgroundColor3 = Color3.fromRGB(38, 38, 38);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.new(1, 0, 0, 5);
    Frame2.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Bottom";
    Frame3.AnchorPoint = Vector2.new(0, 1);
    Frame3.BackgroundColor3 = Color3.fromRGB(38, 38, 38);
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0, 1);
    Frame3.Size = UDim2.new(1, 0, 0, 5);
    Frame3.Parent = CanvasGroup;
    CanvasGroup.Parent = u2.Handler;

    return CanvasGroup;
end;

function u1.dropclick(p995: string, p996: number) -- Line: 6293
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Button";
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38);
    TextButton.BorderColor3 = Color3.new();
    TextButton.BorderSizePixel = 0;
    TextButton.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextButton.Size = UDim2.fromScale(1, 1 / p996);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new(1, 1, 1);
    TextButton.TextScaled = true;
    TextButton.TextStrokeColor3 = Color3.new(1, 1, 1);
    local Frame = Instance.new("Frame");
    Frame.Name = "Back";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new()), ColorSequenceKeypoint.new(1, Color3.new()) });
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.677596), NumberSequenceKeypoint.new(1, 1) });
    UIGradient.Parent = Frame;
    Frame.Parent = TextButton;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Hold";
    Frame2.BackgroundTransparency = 1;
    Frame2.Size = UDim2.fromScale(1, 1);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.9, 0.5);
    TextLabel.Text = p995;
    TextLabel.TextColor3 = Color3.fromRGB(181, 181, 181);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 2;
    TextLabel.Parent = Frame2;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0, 6);
    UIPadding.Parent = Frame2;
    Frame2.Parent = TextButton;

    return TextButton;
end;

function u1.remode(u997: userdata) -- Line: 6363
    u997.Size = UDim2.new(0.5, 0, 0.88, 0);
    u997.Position = UDim2.new(0.5, 0, 0.118, 0);
    u997.AnchorPoint = Vector2.new(0.5, 0);
    u997.VerticalScrollBarInset = Enum.ScrollBarInset.Always;
    u997.ScrollBarThickness = 6;
    u997.BorderSizePixel = 0;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = u997;
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 6377
        -- upvalues: u997 (copy), UIListLayout (copy)
        u997.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 6);
    end);
end;

function u1.previewUI() -- Line: 6382
    local Frame = Instance.new("Frame");
    Frame.Name = "Preview";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(0.45, 0.45);
    Frame.Visible = false;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.7777777777777777;
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width;
    UIAspectRatioConstraint.Parent = Frame;

    return Frame;
end;

function u1.bottom() -- Line: 6398
    -- upvalues: u42 (ref), u6 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Bottom";
    Frame.Active = true;
    Frame.AnchorPoint = Vector2.new(0, 1);
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = 4;
    Frame.Position = UDim2.fromScale(0, 1);
    Frame.Selectable = true;
    Frame.Size = UDim2.fromScale(1, 0.08);
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 20;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = Frame;
    Reset = Instance.new("TextButton");
    Reset.Name = "Reset";
    Reset.AnchorPoint = Vector2.new(0, 0.5);
    Reset.AutoButtonColor = false;
    Reset.BackgroundTransparency = 1;
    Reset.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    Reset.Position = UDim2.fromScale(0.005, 0.5);
    Reset.Size = UDim2.fromScale(0.05, 0.5);
    Reset.Text = "";
    Reset.TextColor3 = Color3.new();
    Reset.TextSize = 14;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = Reset;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(1, 0.5);
    TextLabel.Size = UDim2.fromScale(0.6, 0.5);
    TextLabel.Text = "RESET";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel.Parent = Reset;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://102287808639769";
    ImageLabel.Position = UDim2.fromScale(0.1, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Reset;
    Reset.Parent = Frame;
    u42 = Instance.new("TextButton");
    u42.Name = "ResetPage";
    u42.AnchorPoint = Vector2.new(0, 0.5);
    u42.AutoButtonColor = false;
    u42.BackgroundTransparency = 1;
    u42.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    u42.Position = UDim2.fromScale(0.06, 0.5);
    u42.Size = UDim2.fromScale(0.075, 0.5);
    u42.Text = "";
    u42.TextColor3 = Color3.new();
    u42.TextSize = 14;
    u42.Visible = false;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = u42;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "TextLabel";
    TextLabel2.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.95, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.7, 0.5);
    TextLabel2.Text = "RESET PAGE";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.7;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel2.Parent = u42;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "ImageLabel";
    ImageLabel2.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://102287808639769";
    ImageLabel2.ImageTransparency = 0.7;
    ImageLabel2.Position = UDim2.fromScale(0.06, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = u42;
    u42.Parent = Frame;
    Frame.Parent = u6;
end;

function u1.changedDot() -- Line: 6561
    local Frame = Instance.new("Frame");
    Frame.Name = "ChangedDot";
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0, 0.5);
    Frame.Size = UDim2.fromScale(0.16, 0.16);
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;

    return Frame;
end;

function u1.callbackButtonUI() -- Line: 6579
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "CallbackButton";
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.LayoutOrder = 4;
    TextButton.Size = UDim2.fromScale(1, 0.1);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 17.5;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.new(0, 2, 0.5, 0);
    TextLabel.Size = UDim2.fromScale(0.5, 0.5);
    TextLabel.Text = "M";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.35;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = TextButton;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Buttom";
    TextLabel2.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextLabel2.BackgroundTransparency = 0.85;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextLabel2.Position = UDim2.fromScale(0.99, 0.5);
    TextLabel2.Size = UDim2.new(0.022158, 89, 0.8, 0);
    TextLabel2.Text = "";
    TextLabel2.TextColor3 = Color3.new();
    TextLabel2.TextSize = 14;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = TextLabel2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "TextLabel";
    TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0, 0.5);
    TextLabel3.Size = UDim2.fromScale(1, 0.7);
    TextLabel3.Text = "OPEN";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.Parent = TextLabel2;
    TextLabel2.Parent = TextButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Line";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.8;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 1);
    Frame.Size = UDim2.new(1, 0, 0, 2);
    Frame.Parent = TextButton;

    return TextButton;
end;

function u1.previewButton(p998: string, p999: string) -- Line: 6664
    -- upvalues: TweenService (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p998;
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.new();
    TextButton.BackgroundTransparency = 0.45;
    TextButton.Text = "";
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = TextButton;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.52);
    TextLabel.Size = UDim2.fromScale(0.88, 0.56);
    TextLabel.Text = p999;
    TextLabel.TextColor3 = Color3.fromRGB(225, 225, 225);
    TextLabel.TextScaled = true;
    TextLabel.Parent = TextButton;
    TextButton.MouseEnter:Connect(function() -- Line: 6701
        -- upvalues: TweenService (ref), TextButton (copy), UIStroke (copy)
        TweenService:Create(TextButton, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.25
        }):Play();
        TweenService:Create(UIStroke, TweenInfo.new(0.15), {
            Transparency = 0.6
        }):Play();
    end);
    TextButton.MouseLeave:Connect(function() -- Line: 6706
        -- upvalues: TweenService (ref), TextButton (copy), UIStroke (copy)
        TweenService:Create(TextButton, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.45
        }):Play();
        TweenService:Create(UIStroke, TweenInfo.new(0.15), {
            Transparency = 0.8
        }):Play();
    end);

    return TextButton;
end;

function u1.previewValue() -- Line: 6714
    -- upvalues: TweenService (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Value";
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.45;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = Frame;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.AnchorPoint = Vector2.new(0.5, 0.5);
    TextBox.BackgroundTransparency = 1;
    TextBox.ClearTextOnFocus = false;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178);
    TextBox.Position = UDim2.fromScale(0.5, 0.52);
    TextBox.Size = UDim2.fromScale(0.92, 0.6);
    TextBox.Text = "";
    TextBox.TextColor3 = Color3.fromRGB(206, 206, 206);
    TextBox.TextScaled = true;
    TextBox.Parent = Frame;
    Frame.MouseEnter:Connect(function() -- Line: 6751
        -- upvalues: TweenService (ref), Frame (copy)
        TweenService:Create(Frame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.25
        }):Play();
    end);
    Frame.MouseLeave:Connect(function() -- Line: 6755
        -- upvalues: TweenService (ref), Frame (copy)
        TweenService:Create(Frame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.45
        }):Play();
    end);
    TextBox.Focused:Connect(function() -- Line: 6759
        -- upvalues: TweenService (ref), UIStroke (copy)
        TweenService:Create(UIStroke, TweenInfo.new(0.15), {
            Transparency = 0.6
        }):Play();
    end);
    TextBox.FocusLost:Connect(function() -- Line: 6763
        -- upvalues: TweenService (ref), UIStroke (copy)
        TweenService:Create(UIStroke, TweenInfo.new(0.15), {
            Transparency = 0.8
        }):Play();
    end);

    return Frame, TextBox;
end;

function u1.crosshairFrame(p1000) -- Line: 6770
    -- upvalues: u1 (copy), DecodeCrosshair (copy), u14 (ref), u13 (ref), u54 (ref)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Crosshair";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://119939440047927";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Crop;
    ImageLabel.Size = UDim2.fromScale(1, 0.5625);
    ImageLabel.BorderSizePixel = 0;
    local Frame = Instance.new("Frame");
    Frame.Name = "Crosshair";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromOffset(50, 50);
    Frame.ZIndex = 10;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "RightFrame";
    Frame2.AnchorPoint = Vector2.new(0, 0.5);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.Position = UDim2.new(0.5, 7, 0.5, 0);
    Frame2.Size = UDim2.fromOffset(10, 2);
    Frame2.ZIndex = 10;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "Border";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Parent = Frame2;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "Corner";
    UICorner.CornerRadius = UDim.new();
    UICorner.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "LeftFrame";
    Frame3.AnchorPoint = Vector2.new(1, 0.5);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.Position = UDim2.new(0.5, -7, 0.5, 0);
    Frame3.Size = UDim2.fromOffset(10, 2);
    Frame3.ZIndex = 10;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "Border";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Parent = Frame3;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "Corner";
    UICorner2.CornerRadius = UDim.new();
    UICorner2.Parent = Frame3;
    Frame3.Parent = Frame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "TopFrame";
    Frame4.AnchorPoint = Vector2.new(0.5, 1);
    Frame4.AutoLocalize = false;
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.Position = UDim2.new(0.5, 0, 0.5, -7);
    Frame4.Size = UDim2.fromOffset(2, 10);
    Frame4.ZIndex = 10;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "Border";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Parent = Frame4;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "Corner";
    UICorner3.CornerRadius = UDim.new();
    UICorner3.Parent = Frame4;
    Frame4.Parent = Frame;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "BottomFrame";
    Frame5.AnchorPoint = Vector2.new(0.5, 0);
    Frame5.AutoLocalize = false;
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.Position = UDim2.new(0.5, 0, 0.5, 7);
    Frame5.Size = UDim2.fromOffset(2, 10);
    Frame5.ZIndex = 10;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "Border";
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.Parent = Frame5;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "Corner";
    UICorner4.CornerRadius = UDim.new();
    UICorner4.Parent = Frame5;
    Frame5.Parent = Frame;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Dot";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.AutoLocalize = false;
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame6.Position = UDim2.fromScale(0.5, 0.5);
    Frame6.Size = UDim2.fromOffset(2, 2);
    Frame6.ZIndex = 10;
    local UIStroke5 = Instance.new("UIStroke");
    UIStroke5.Name = "Border";
    UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke5.Parent = Frame6;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "Corner";
    UICorner5.CornerRadius = UDim.new();
    UICorner5.Parent = Frame6;
    Frame6.Parent = Frame;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Decal";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.AutoLocalize = false;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://503325139";
    ImageLabel2.ImageTransparency = 0.35;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromOffset(30, 18);
    ImageLabel2.Visible = false;
    ImageLabel2.ZIndex = 10;
    ImageLabel2.Parent = Frame;
    Frame.Parent = ImageLabel;
    local v1001, u1002 = u1.previewValue();
    v1001.AnchorPoint = Vector2.new(1, 1);
    v1001.Position = UDim2.fromScale(0.98, 0.98);
    v1001.Size = UDim2.fromScale(0.34, 0.07);
    local u1003 = "";
    local u1004 = false;
    local u1005 = nil;
    u1002.Focused:Connect(function() -- Line: 6921
        -- upvalues: u1003 (ref), u1002 (copy), u1004 (ref), u1005 (ref)
        u1003 = u1002.Text;
        u1004 = true;
        u1005 = tick();
        u1002.SelectionStart = 1;
        u1002.CursorPosition = u1002.Text:len() + 1;
    end);
    u1002.InputEnded:Connect(function(p1006) -- Line: 6929
        -- upvalues: u1004 (ref), u1005 (ref), u1002 (copy)
        if p1006.UserInputType == Enum.UserInputType.Touch or p1006.UserInputType == Enum.UserInputType.MouseButton1 then
            if u1004 and tick() - u1005 <= 0.5 then
                u1002.SelectionStart = 1;
                u1002.CursorPosition = u1002.Text:len() + 1;
            end;

            u1004 = false;
        end;
    end);
    u1002.FocusLost:Connect(function(p1007) -- Line: 6939
        -- upvalues: u1002 (copy), u1003 (ref), DecodeCrosshair (ref), u14 (ref), u1 (ref)
        local v1008 = u1002.Text:gsub(" ", "");

        if u1003 == v1008 then
            return;
        end;

        if v1008 == "" then
            u1002.Text = u1003;

            return;
        end;

        if not DecodeCrosshair(v1008) then
            u1002.Text = u1003;

            return;
        end;

        u14.Gui.CopyCrosshair2.Fire(v1008);
        task.delay(3, function() -- Line: 6955
            -- upvalues: u1 (ref)
            u1.UpdatePlayerSettings(true);
        end);
    end);
    v1001.Parent = ImageLabel;
    local v1009 = u1.previewButton("Dynamic", "Start Dynamic Preview");
    v1009.AnchorPoint = Vector2.new(0, 1);
    v1009.Position = UDim2.fromScale(0.02, 0.98);
    v1009.Size = UDim2.fromScale(0.27, 0.07);
    v1009.Visible = false;
    v1009.MouseButton1Click:Connect(function() -- Line: 6971
        -- upvalues: u13 (ref), u54 (ref), u1 (ref)
        u13.Play("UI.generic_press");

        if u54 and not u54.Stopping then
            u1.StopDynamicPreview();

            return;
        end;

        u1.StartDynamicPreview();
    end);
    v1009.Parent = ImageLabel;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "State";
    TextLabel.AnchorPoint = Vector2.new(0, 1);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.025, 0.895);
    TextLabel.Size = UDim2.fromScale(0.3, 0.045);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 1;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = ImageLabel;
    ImageLabel.Parent = p1000;
    u1.arrows(ImageLabel);

    return ImageLabel;
end;

function u1.viewmodelOffset(p1010) -- Line: 7008
    -- upvalues: u1 (copy), u60 (ref), u30 (ref), u14 (ref), u13 (ref), DecodeViewmodel (copy)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ViewmodelOffset";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://119939440047927";
    ImageLabel.Size = UDim2.fromScale(1, 0.5625);
    local ViewportFrame = Instance.new("ViewportFrame");
    ViewportFrame.Name = "ViewportFrame";
    ViewportFrame.Ambient = Color3.fromRGB(230, 230, 230);
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    ViewportFrame.BackgroundTransparency = 1;
    ViewportFrame.LightColor = Color3.fromRGB(223, 223, 223);
    ViewportFrame.Position = UDim2.fromScale(0.5, 0.5);
    ViewportFrame.Size = UDim2.fromScale(1, 1);
    local WorldModel = Instance.new("WorldModel");
    WorldModel.Name = "WorldModel";
    WorldModel.Parent = ViewportFrame;
    ViewportFrame.Parent = ImageLabel;
    local v1011 = u1.previewButton("RemovePreset", "Remove Preset");
    v1011.AnchorPoint = Vector2.new(1, 0);
    v1011.Position = UDim2.fromScale(0.98, 0.03);
    v1011.Size = UDim2.fromScale(0.2, 0.07);
    v1011.Visible = false;
    v1011.Activated:Connect(function() -- Line: 7035
        -- upvalues: u60 (ref), u30 (ref), u14 (ref), u13 (ref)
        u60:Create("Remove Preset", `Remove the {u30.Game.Viewmodel["Viewmodel Preset"]} preset? It will use the All position again.`, function() -- Line: 7036
            -- upvalues: u14 (ref)
            u14.Gui.ViewmodelPreset.Fire("Remove");
        end);
        u13.Play("UI.submenu_dropdown_option_select");
    end);
    v1011.Parent = ImageLabel;
    local v1012, u1013 = u1.previewValue();
    v1012.AnchorPoint = Vector2.new(1, 1);
    v1012.Position = UDim2.fromScale(0.98, 0.98);
    v1012.Size = UDim2.fromScale(0.34, 0.07);
    local u1014 = "";
    local u1015 = false;
    local u1016 = nil;
    u1013.Focused:Connect(function() -- Line: 7054
        -- upvalues: u1014 (ref), u1013 (copy), u1015 (ref), u1016 (ref)
        u1014 = u1013.Text;
        u1015 = true;
        u1016 = tick();
        u1013.SelectionStart = 1;
        u1013.CursorPosition = u1013.Text:len() + 1;
    end);
    u1013.InputEnded:Connect(function(p1017) -- Line: 7062
        -- upvalues: u1015 (ref), u1016 (ref), u1013 (copy)
        if p1017.UserInputType == Enum.UserInputType.Touch or p1017.UserInputType == Enum.UserInputType.MouseButton1 then
            if u1015 and tick() - u1016 <= 0.5 then
                u1013.SelectionStart = 1;
                u1013.CursorPosition = u1013.Text:len() + 1;
            end;

            u1015 = false;
        end;
    end);
    u1013.FocusLost:Connect(function(p1018) -- Line: 7072
        -- upvalues: u1013 (copy), u1014 (ref), DecodeViewmodel (ref), u14 (ref), u1 (ref)
        local v1019 = u1013.Text:gsub(" ", "");

        if u1014 == v1019 then
            return;
        end;

        if v1019 == "" then
            u1013.Text = u1014;

            return;
        end;

        if not DecodeViewmodel(v1019) then
            u1013.Text = u1014;

            return;
        end;

        u14.Gui.CopyViewmodel2.Fire(v1019);
        task.delay(3, function() -- Line: 7088
            -- upvalues: u1 (ref)
            u1:UpdatePlayerSettings(true);
        end);
    end);
    v1012.Parent = ImageLabel;
    ImageLabel.Parent = p1010;
    u1.arrows(ImageLabel);

    return ImageLabel;
end;

function u1.hudEdges(p1020) -- Line: 7105
    -- upvalues: u1 (copy)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "HudEdges";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://119939440047927";
    ImageLabel.Size = UDim2.fromScale(1, 0.5625);
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.6;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.7, 0.7);
    local Folder = Instance.new("Folder");
    Folder.Name = "Folder";
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.fromOffset(3, 15);
    Frame2.Parent = Folder;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0, 1);
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0, 1);
    Frame3.Size = UDim2.fromOffset(3, 15);
    Frame3.Parent = Folder;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Frame";
    Frame4.AnchorPoint = Vector2.new(1, 1);
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(1, 1);
    Frame4.Size = UDim2.fromOffset(3, 15);
    Frame4.Parent = Folder;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Frame";
    Frame5.AnchorPoint = Vector2.new(1, 0);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.fromScale(1, 0);
    Frame5.Size = UDim2.fromOffset(3, 15);
    Frame5.Parent = Folder;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Frame";
    Frame6.AnchorPoint = Vector2.new(1, 0);
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame6.BorderColor3 = Color3.new();
    Frame6.BorderSizePixel = 0;
    Frame6.Position = UDim2.fromScale(1, 0);
    Frame6.Size = UDim2.fromOffset(15, 3);
    Frame6.Parent = Folder;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Frame";
    Frame7.AnchorPoint = Vector2.new(1, 1);
    Frame7.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame7.BorderColor3 = Color3.new();
    Frame7.BorderSizePixel = 0;
    Frame7.Position = UDim2.fromScale(1, 1);
    Frame7.Size = UDim2.fromOffset(15, 3);
    Frame7.Parent = Folder;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Frame";
    Frame8.AnchorPoint = Vector2.new(0, 1);
    Frame8.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Position = UDim2.fromScale(0, 1);
    Frame8.Size = UDim2.fromOffset(15, 3);
    Frame8.Parent = Folder;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Frame";
    Frame9.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.Size = UDim2.fromOffset(15, 3);
    Frame9.Parent = Folder;
    Folder.Parent = Frame;
    Frame.Parent = ImageLabel;
    ImageLabel.Parent = p1020;
    u1.arrows(ImageLabel);

    return ImageLabel;
end;

function u1.arrows(u1021) -- Line: 7212
    -- upvalues: u21 (ref)
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "RightArrow";
    ImageButton.AnchorPoint = Vector2.new(1, 0.5);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
    ImageButton.ImageTransparency = 1;
    ImageButton.Position = UDim2.fromScale(1, 0.5);
    ImageButton.Size = UDim2.fromScale(0.08, 0.09);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "V";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.6, 0.6);
    TextLabel.Text = ">";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.Parent = ImageButton;
    ImageButton.Parent = u1021;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "LeftArrow";
    ImageButton2.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
    ImageButton2.ImageTransparency = 1;
    ImageButton2.Position = UDim2.fromScale(0, 0.5);
    ImageButton2.Size = UDim2.fromScale(0.08, 0.09);
    ImageButton2.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "V";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.6, 0.6);
    TextLabel2.Text = "<";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = ImageButton2;
    local u1022 = {};
    local u1023 = 1;

    for i in u21.Maps do
        table.insert(u1022, i);
    end;

    local function update() -- Line: 7275
        -- upvalues: u1022 (copy), u1023 (ref), u21 (ref), u1021 (copy)
        u1021.Image = `rbxassetid://{u21.Maps[u1022[u1023]].Thumbnail}`;
    end;

    u1021.Image = `rbxassetid://{u21.Maps[u1022[u1023]].Thumbnail}`;
    ImageButton.MouseButton1Click:Connect(function() -- Line: 7284
        -- upvalues: u1023 (ref), u1022 (copy), u21 (ref), u1021 (copy)
        u1023 = u1023 + 1;

        if u1023 > #u1022 then
            u1023 = 1;
        end;

        u1021.Image = `rbxassetid://{u21.Maps[u1022[u1023]].Thumbnail}`;
    end);
    ImageButton2.MouseButton1Click:Connect(function() -- Line: 7292
        -- upvalues: u1023 (ref), u1022 (copy), u21 (ref), u1021 (copy)
        u1023 = u1023 - 1;

        if u1023 < 1 then
            u1023 = #u1022;
        end;

        u1021.Image = `rbxassetid://{u21.Maps[u1022[u1023]].Thumbnail}`;
    end);
    ImageButton2.Parent = u1021;
end;

function u1.searchUI() -- Line: 7303
    -- upvalues: u15 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Search";
    Frame.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    Frame.BackgroundTransparency = 0.1;
    Frame.BorderSizePixel = 0;
    Frame.Position = u15() == "Mobile" and UDim2.fromScale(0, 0.072) or UDim2.fromScale(0, 0.058);
    Frame.Size = u15() == "Mobile" and UDim2.fromScale(1, 0.072) or UDim2.fromScale(1, 0.058);
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Box";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(0.3, 0.7);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Line";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BackgroundTransparency = 0.6;
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.new(1, 0, 0, 2);
    Frame3.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://136926548005524";
    ImageLabel.Position = UDim2.fromScale(0, 0.45);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame2;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.AnchorPoint = Vector2.new(0, 0.5);
    TextBox.BackgroundTransparency = 1;
    TextBox.ClearTextOnFocus = false;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.PlaceholderColor3 = Color3.new(1, 1, 1);
    TextBox.PlaceholderText = "SEARCH SETTINGS";
    TextBox.Position = UDim2.fromScale(0.09, 0.45);
    TextBox.Size = UDim2.fromScale(0.7, 0.55);
    TextBox.Text = "";
    TextBox.TextColor3 = Color3.new(1, 1, 1);
    TextBox.TextScaled = true;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Count";
    TextLabel.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(1, 0.45);
    TextLabel.Size = UDim2.fromScale(0.2, 0.4);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.Parent = Frame2;
    Frame2.Parent = Frame;

    return Frame;
end;

function u1.searchHintUI() -- Line: 7383
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Hint";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 0;
    TextLabel.Size = UDim2.new(1, 0, 0, 0);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 30;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = TextLabel;

    return TextLabel;
end;

function u1.HoverDescriptionUI() -- Line: 7407
    -- upvalues: u2 (ref)
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "HoverDescription";
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(16, 16, 16);
    CanvasGroup.BackgroundTransparency = 0.1;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Position = UDim2.fromOffset(763, 335);
    CanvasGroup.Size = UDim2.fromScale(0.221117, 0.105116);
    CanvasGroup.Visible = true;
    CanvasGroup.ZIndex = 100;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "ItemCorner";
    UICorner.CornerRadius = UDim.new(0.04, 0);
    UICorner.Parent = CanvasGroup;
    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "UIShadow";
    UIShadow.BlurRadius = UDim.new(0, 20);
    UIShadow.Transparency = 1;
    UIShadow.Parent = CanvasGroup;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "ItemText";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(-9.40824e-8, 4.71869e-8);
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.Text = "AKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some SkinAKR | Some Skin";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextSize = 16;
    TextLabel.TextStrokeTransparency = 0.75;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = CanvasGroup;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "ItemPadding";
    UIPadding.PaddingBottom = UDim.new(0, 8);
    UIPadding.PaddingLeft = UDim.new(0, 12);
    UIPadding.PaddingRight = UDim.new(0, 12);
    UIPadding.PaddingTop = UDim.new(0, 8);
    UIPadding.Parent = CanvasGroup;
    CanvasGroup.Parent = u2.Handler;

    return CanvasGroup;
end;

return u1;