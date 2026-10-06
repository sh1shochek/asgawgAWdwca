-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Types);
local Format = require(script.Parent.Format);
local Derive = require(script.Parent.Derive);
local MapIcon = require(script.Parent.MapIcon);
local CareerData = require(script.Parent.CareerData);
local WeaponIcon = require(script.Parent.WeaponIcon);
local LocalPlayer = Players.LocalPlayer;
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Router = require(ReplicatedStorage.Database.Security.Router);
local u2 = {
    Base = Color3.fromRGB(32, 108, 23),
    Cell = Color3.fromRGB(87, 255, 93)
};
local u3 = {
    Base = Color3.fromRGB(89, 9, 9),
    Cell = Color3.fromRGB(255, 53, 53)
};
local u4 = {
    Base = Color3.fromRGB(108, 95, 23),
    Cell = Color3.fromRGB(255, 236, 87)
};
local table_freeze_ret = table.freeze({ "CombatScore", "Econ", "Plants", "Kills", "Assists", "Assist" });
local Color3_fromRGB_ret = Color3.fromRGB(165, 183, 212);
local Color3_fromRGB_ret2 = Color3.fromRGB(219, 199, 126);
local Color3_fromRGB_ret3 = Color3.fromRGB(95, 95, 95);
local Color3_fromRGB_ret4 = Color3.fromRGB(88, 245, 82);
local Color3_fromRGB_ret5 = Color3.fromRGB(195, 20, 20);
local table_freeze_ret2 = table.freeze({
    Kill = true,
    Death = true
});
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_fromRGB_ret6 = Color3.fromRGB(158, 158, 158);
local Color3_fromRGB_ret7 = Color3.fromRGB(219, 43, 43);
local Color3_new_ret2 = Color3.new(1, 1, 1);
local table_freeze_ret3 = table.freeze({
    BombDefuse = "rbxassetid://138772806705472",
    BombExplode = "rbxassetid://97682949239067",
    BombObjective = "rbxassetid://97682949239067",
    Elimination = "rbxassetid://70876442749327",
    TimeExpiration = "rbxassetid://96043369049959",
    HostageRescue = "rbxassetid://138772806705472"
});
local table_freeze_ret4 = table.freeze({
    Sort_CombatScore = function(p5) -- Line: 110, Name: Sort_CombatScore
        -- upvalues: Derive (copy)
        return Derive.Divide(p5.CombatScore, p5.RoundsPlayed);
    end,

    Sort_KDA = function(p6) -- Line: 113, Name: Sort_KDA
        return p6.Kills - p6.Deaths;
    end,

    Sort_Econ = function(p7) -- Line: 116, Name: Sort_Econ
        -- upvalues: Derive (copy)
        return Derive.EconomyRating(p7.DamageDealt, p7.MoneySpent);
    end,

    Sort_FirstBloods = function(p8) -- Line: 119, Name: Sort_FirstBloods
        return p8.FirstBloods;
    end,

    Sort_Plants = function(p9) -- Line: 122, Name: Sort_Plants
        return p9.Plants;
    end,

    Sort_Defuses = function(p10: any, p11: boolean) -- Line: 125, Name: Sort_Defuses
        if p11 then
            return p10.Rescues;
        end;

        return p10.Defuses;
    end
});
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
local u25 = "Scoreboard";
local u26 = 1;
local u27 = {};
local u28 = "Sort_CombatScore";
local u29 = true;
local u30 = {};
local u31 = {};

local function TeamColor(p32: string) -- Line: 163
    -- upvalues: Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    if p32 == "Counter-Terrorists" then
        return Color3_fromRGB_ret;
    end;

    return Color3_fromRGB_ret2;
end;

local function SetText(p33: userdata?, p34: string, p35: string) -- Line: 169
    if p33 then
        p33 = p33:FindFirstChild(p34);
    end;

    if p33 and p33:IsA("TextLabel") then
        p33.Text = p35;
    end;
end;

local function WeaponName(p36: string?) -- Line: 179
    return (p36 == nil or p36 == "") and "" or string.upper(p36);
end;

local function SetAmount(p37: userdata, p38: string, p39: string) -- Line: 188
    local v40 = p37:FindFirstChild(p38);
    local v41;

    if v40 then
        v41 = v40:FindFirstChild("Amount");
    else
        v41 = v40;
    end;

    if v41 and v41:IsA("TextLabel") then
        v41.Text = p39;

        return;
    end;

    if v40 and v40:IsA("TextLabel") then
        v40.Text = p39;
    end;
end;

local function ResolveAvatarUserId(p42: number) -- Line: 201
    -- upvalues: u24 (ref)
    local v43 = u24;

    if v43 then
        for _, v in ipairs(v43.Players) do
            if v.UserId == p42 and v.AvatarUserId > 0 then
                return v.AvatarUserId;
            end;
        end;
    end;

    return p42;
end;

local function ApplyAvatar(p44: userdata?, p45: number) -- Line: 214
    -- upvalues: ResolveAvatarUserId (copy)
    if not p44 then
        return;
    end;

    local v46 = ResolveAvatarUserId(p45);

    if not (p44:IsA("ImageLabel") or p44:IsA("ImageButton")) then
        p44 = p44:FindFirstChild("Avatar") or p44:FindFirstChildWhichIsA("ImageLabel", true);
    end;

    if p44 and (p44:IsA("ImageLabel") or p44:IsA("ImageButton")) then
        p44.Image = v46 <= 0 and "" or `rbxthumb://type=AvatarHeadShot&id={v46}&w=150&h=150`;
    end;
end;

local function SetAvatar(p47: userdata, p48: string, p49: number) -- Line: 235
    -- upvalues: ApplyAvatar (copy)
    ApplyAvatar(p47:FindFirstChild(p48), p49);
end;

local function PaintPlayerRow(p50: userdata, p51: table) -- Line: 242
    -- upvalues: table_freeze_ret (copy)
    if p50:IsA("GuiObject") then
        p50.BackgroundColor3 = p51.Base;
    end;

    for _, child in ipairs(p50:GetChildren()) do
        if child.Name == "Frame" and (child:IsA("GuiObject") and child.BackgroundTransparency < 1) then
            child.BackgroundColor3 = p51.Base;
        elseif child.Name == "Pattern" then
            if child:IsA("ImageLabel") then
                child.ImageColor3 = p51.Base;
            end;

            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("ImageLabel") then
                    descendant.ImageColor3 = p51.Base;
                end;
            end;
        end;
    end;

    for _, v in ipairs(table_freeze_ret) do
        local v52 = p50:FindFirstChild(v);

        if v52 and (v52:IsA("GuiObject") and v52.BackgroundTransparency < 1) then
            v52.BackgroundColor3 = p51.Cell;
        end;
    end;
end;

local function PaletteFor(p53: number, p54: string, p55: string) -- Line: 272
    -- upvalues: LocalPlayer (copy), u4 (copy), u2 (copy), u3 (copy)
    if p53 == LocalPlayer.UserId then
        return u4;
    end;

    if p54 == p55 then
        return u2;
    end;

    return u3;
end;

local function GetBadgeImage(p56: string, p57: number) -- Line: 281
    -- upvalues: Skins (copy)
    if p56 == "" then
        return "";
    end;

    local SkinInformation = Skins.GetSkinInformation("Badge", p56);

    return SkinInformation and (Skins.GetWearImageForFloat(SkinInformation, p57) or SkinInformation.imageAssetId or "") or "";
end;

local function ClearRows(p58: userdata) -- Line: 296
    for _, child in ipairs(p58:GetChildren()) do
        if string.sub(child.Name, 1, 4) == "Row_" then
            child:Destroy();
        end;
    end;
end;

local function CloneRow(p59: userdata, p60: userdata, p61: number) -- Line: 306
    local v62 = p59:Clone();
    v62.Name = `Row_{p61}`;
    v62.LayoutOrder = p61;
    v62.Visible = true;
    v62.Parent = p60;

    return v62;
end;

function u1.ApplyStatus(p63: userdata, p64: string) -- Line: 319
    p63.TextColor3 = Color3.new(1, 1, 1);
    local v65, v66;

    if p64 == "Victory" then
        p63.Text = "VICTORY";
        v65 = Color3.fromRGB(88, 245, 82);
        v66 = Color3.fromRGB(53, 213, 48);
    elseif p64 == "Defeat" then
        p63.Text = "DEFEAT";
        v65 = Color3.fromRGB(255, 26, 26);
        v66 = Color3.fromRGB(255, 55, 55);
    else
        p63.Text = "DRAW";
        v65 = Color3.fromRGB(224, 214, 148);
        v66 = Color3.fromRGB(176, 170, 138);
    end;

    local v67 = p63:FindFirstChildOfClass("UIGradient");

    if v67 then
        v67.Color = ColorSequence.new(v65, v66);

        return;
    end;

    p63.TextColor3 = v65;
end;

local function PopulateHeader(p68) -- Line: 348
    -- upvalues: u12 (ref), Format (copy), MapIcon (copy), u1 (copy)
    local v69 = p68.Team == "Counter-Terrorists";
    local v70;

    if v69 then
        v70 = p68.CTScore;
    else
        v70 = p68.TScore;
    end;

    local v71;

    if v69 then
        v71 = p68.TScore;
    else
        v71 = p68.CTScore;
    end;

    local v72 = u12;
    local v73 = tostring(v70);

    if v72 then
        v72 = v72:FindFirstChild("YourScore");
    end;

    if v72 and v72:IsA("TextLabel") then
        v72.Text = v73;
    end;

    local v74 = u12;
    local v75 = tostring(v71);

    if v74 then
        v74 = v74:FindFirstChild("EnemyScore");
    end;

    if v74 and v74:IsA("TextLabel") then
        v74.Text = v75;
    end;

    local v76 = u12;
    local v77 = Format.Duration(p68.Duration);

    if v76 then
        v76 = v76:FindFirstChild("Timer");
    end;

    if v76 and v76:IsA("TextLabel") then
        v76.Text = v77;
    end;

    local v78 = u12;
    local v79 = `{p68.ServerGamemode} | {p68.Map}`;

    if v78 then
        v78 = v78:FindFirstChild("Gamemode");
    end;

    if v78 and v78:IsA("TextLabel") then
        v78.Text = v79;
    end;

    local Icon = u12:FindFirstChild("Icon");

    if Icon and Icon:IsA("ImageLabel") then
        Icon.Image = MapIcon.Get(p68.Map);
    end;

    local ImageButton = u12:FindFirstChild("ImageButton");

    if ImageButton and ImageButton:IsA("ImageButton") then
        ImageButton.Image = MapIcon.Get(p68.Map);
    end;

    local Victory = u12:FindFirstChild("Victory");
    local Defeat = u12:FindFirstChild("Defeat");
    local v80 = p68.Result == "Defeat";

    if Victory then
        Victory.Visible = not v80;

        if not v80 then
            u1.ApplyStatus(Victory, p68.Result);
        end;
    end;

    if Defeat then
        Defeat.Visible = v80;

        if v80 then
            u1.ApplyStatus(Defeat, p68.Result);
        end;
    end;
end;

local function SortPlayers(p81: any, u82: boolean) -- Line: 392
    -- upvalues: table_freeze_ret4 (copy), u28 (ref), u29 (ref)
    local table_clone_ret = table.clone(p81.Players);
    local u83 = table_freeze_ret4[u28];
    table.sort(table_clone_ret, function(p84, p85) -- Line: 396
        -- upvalues: u83 (copy), u29 (ref), u82 (copy)
        if u83 then
            local v86 = u83(p84, u82);
            local v87 = u83(p85, u82);

            if v86 == v87 then
                return p84.Kills > p85.Kills;
            end;

            if u29 then
                return v87 < v86;
            end;

            return v86 < v87;
        end;

        local string_lower_ret = string.lower(p84.DisplayName);
        local string_lower_ret2 = string.lower(p85.DisplayName);

        if string_lower_ret == string_lower_ret2 then
            return p84.UserId < p85.UserId;
        end;

        if u29 then
            return string_lower_ret2 < string_lower_ret;
        end;

        return string_lower_ret < string_lower_ret2;
    end);

    return table_clone_ret;
end;

local function UpdateColumnHeadings() -- Line: 419
    -- upvalues: u30 (copy), u28 (ref), Color3_new_ret (copy), Color3_fromRGB_ret6 (copy)
    for i, v in pairs(u30) do
        local v88;

        if i == u28 then
            v88 = Color3_new_ret;
        else
            v88 = Color3_fromRGB_ret6;
        end;

        v.TextColor3 = v88;
    end;
end;

local function PopulateScoreboard(p89) -- Line: 427
    -- upvalues: u14 (ref), u18 (ref), ClearRows (copy), table_freeze_ret4 (copy), u28 (ref), u29 (ref), ApplyAvatar (copy), Skins (copy), Format (copy), Derive (copy), PaintPlayerRow (copy), LocalPlayer (copy), u4 (copy), u2 (copy), u3 (copy)
    local v90 = u14 and u14:FindFirstChild("Main");

    if v90 then
        v90 = v90:FindFirstChild("Main");
    end;

    if not (v90 and u18) then
        return;
    end;

    ClearRows(v90);
    local u91 = p89.Gamemode == "Hostage Rescue";
    local table_clone_ret = table.clone(p89.Players);
    local u92 = table_freeze_ret4[u28];
    table.sort(table_clone_ret, function(p93, p94) -- Line: 396
        -- upvalues: u92 (copy), u29 (ref), u91 (copy)
        if u92 then
            local v95 = u92(p93, u91);
            local v96 = u92(p94, u91);

            if v95 == v96 then
                return p93.Kills > p94.Kills;
            end;

            if u29 then
                return v96 < v95;
            end;

            return v95 < v96;
        end;

        local string_lower_ret = string.lower(p93.DisplayName);
        local string_lower_ret2 = string.lower(p94.DisplayName);

        if string_lower_ret == string_lower_ret2 then
            return p93.UserId < p94.UserId;
        end;

        if u29 then
            return string_lower_ret2 < string_lower_ret;
        end;

        return string_lower_ret < string_lower_ret2;
    end);

    for i, v in ipairs(table_clone_ret) do
        local v97 = u18:Clone();
        v97.Name = `Row_{i}`;
        v97.LayoutOrder = i;
        v97.Visible = true;
        v97.Parent = v90;
        local v98 = `{v.DisplayName} (@{v.Username})`;

        if v.Disconnected then
            v98 = `{v98} (LEFT)`;
        end;

        local v99;

        if v97 then
            v99 = v97:FindFirstChild("PlayerName");
        else
            v99 = v97;
        end;

        if v99 and v99:IsA("TextLabel") then
            v99.Text = v98;
        end;

        local UserId = v.UserId;
        ApplyAvatar(v97:FindFirstChild("Player"), UserId);
        local Badge = v97:FindFirstChild("Badge");

        if Badge then
            local BadgeSkin = v.BadgeSkin;
            local BadgeFloat = v.BadgeFloat;
            local v100;

            if BadgeSkin == "" then
                v100 = "";
            else
                local SkinInformation = Skins.GetSkinInformation("Badge", BadgeSkin);
                v100 = SkinInformation and (Skins.GetWearImageForFloat(SkinInformation, BadgeFloat) or (SkinInformation.imageAssetId or "")) or "";
            end;

            Badge.Image = v100;
            Badge.Visible = v100 ~= "";
        end;

        local v101 = `{v.Kills}/{v.Deaths}/{v.Assists}`;
        local KDA = v97:FindFirstChild("KDA");
        local v102;

        if KDA then
            v102 = KDA:FindFirstChild("Amount");
        else
            v102 = KDA;
        end;

        if v102 and v102:IsA("TextLabel") then
            v102.Text = v101;
        elseif KDA and KDA:IsA("TextLabel") then
            KDA.Text = v101;
        end;

        local v103 = Format.Number(Derive.Divide(v.CombatScore, v.RoundsPlayed));
        local CombatScore = v97:FindFirstChild("CombatScore");
        local v104;

        if CombatScore then
            v104 = CombatScore:FindFirstChild("Amount");
        else
            v104 = CombatScore;
        end;

        if v104 and v104:IsA("TextLabel") then
            v104.Text = v103;
        elseif CombatScore and CombatScore:IsA("TextLabel") then
            CombatScore.Text = v103;
        end;

        local v105 = Format.Number(Derive.EconomyRating(v.DamageDealt, v.MoneySpent));
        local Econ = v97:FindFirstChild("Econ");
        local v106;

        if Econ then
            v106 = Econ:FindFirstChild("Amount");
        else
            v106 = Econ;
        end;

        if v106 and v106:IsA("TextLabel") then
            v106.Text = v105;
        elseif Econ and Econ:IsA("TextLabel") then
            Econ.Text = v105;
        end;

        local v107 = Format.Number(v.FirstBloods);
        local FirstBloods = v97:FindFirstChild("FirstBloods");
        local v108;

        if FirstBloods then
            v108 = FirstBloods:FindFirstChild("Amount");
        else
            v108 = FirstBloods;
        end;

        if v108 and v108:IsA("TextLabel") then
            v108.Text = v107;
        elseif FirstBloods and FirstBloods:IsA("TextLabel") then
            FirstBloods.Text = v107;
        end;

        local v109 = Format.Number(v.Plants);
        local Plants = v97:FindFirstChild("Plants");
        local v110;

        if Plants then
            v110 = Plants:FindFirstChild("Amount");
        else
            v110 = Plants;
        end;

        if v110 and v110:IsA("TextLabel") then
            v110.Text = v109;
        elseif Plants and Plants:IsA("TextLabel") then
            Plants.Text = v109;
        end;

        local v111;

        if u91 then
            v111 = v.Rescues;
        else
            v111 = v.Defuses;
        end;

        local v112 = Format.Number(v111);
        local Defuses = v97:FindFirstChild("Defuses");
        local v113;

        if Defuses then
            v113 = Defuses:FindFirstChild("Amount");
        else
            v113 = Defuses;
        end;

        if v113 and v113:IsA("TextLabel") then
            v113.Text = v112;
        elseif Defuses and Defuses:IsA("TextLabel") then
            Defuses.Text = v112;
        end;

        local v114 = v;

        for _, v2 in ipairs({ "Bomb", "Dead" }) do
            local v115 = v97:FindFirstChild(v2);

            if v115 and v115:IsA("GuiObject") then
                v115.Visible = false;
            end;
        end;

        local Team = v114.Team;
        local Team2 = p89.Team;
        local v116;

        if v114.UserId == LocalPlayer.UserId then
            v116 = u4;
        elseif Team == Team2 then
            v116 = u2;
        else
            v116 = u3;
        end;

        PaintPlayerRow(v97, v116);
    end;
end;

local function BindColumnHeadings() -- Line: 474
    -- upvalues: u14 (ref), table_freeze_ret4 (copy), u30 (copy), Router (copy), u28 (ref), u29 (ref), Color3_new_ret (copy), Color3_fromRGB_ret6 (copy), u24 (ref), PopulateScoreboard (copy)
    local v117 = u14 and u14:FindFirstChild("Header");

    if not v117 then
        return;
    end;

    for _, child in ipairs(v117:GetChildren()) do
        if child:IsA("TextLabel") and (child.Name == "Sort_Player" or table_freeze_ret4[child.Name] ~= nil) then
            local Name = child.Name;
            u30[Name] = child;
            local Hitbox = child:FindFirstChild("Hitbox");

            if Hitbox and Hitbox:IsA("GuiButton") then
                Hitbox.Active = true;
                Hitbox.Activated:Connect(function() -- Line: 494
                    -- upvalues: Router (ref), u28 (ref), Name (copy), u29 (ref), u30 (ref), Color3_new_ret (ref), Color3_fromRGB_ret6 (ref), u24 (ref), PopulateScoreboard (ref)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");

                    if u28 == Name then
                        u29 = not u29;
                    else
                        u28 = Name;
                        u29 = Name ~= "Sort_Player";
                    end;

                    for i, v in pairs(u30) do
                        local v118;

                        if i == u28 then
                            v118 = Color3_new_ret;
                        else
                            v118 = Color3_fromRGB_ret6;
                        end;

                        v.TextColor3 = v118;
                    end;

                    local v119 = u24;

                    if v119 then
                        PopulateScoreboard(v119);
                    end;
                end);
            end;
        end;
    end;

    for i, v in pairs(u30) do
        local v120;

        if i == u28 then
            v120 = Color3_new_ret;
        else
            v120 = Color3_fromRGB_ret6;
        end;

        v.TextColor3 = v120;
    end;
end;

local function GetResultsRow(p121: number) -- Line: 519
    -- upvalues: u15 (ref)
    local v122 = u15 and u15:FindFirstChild((`Results{p121}`));

    if v122 and v122:IsA("Frame") then
        return v122;
    end;

    return nil;
end;

local function GetRoundFrame(p123: number) -- Line: 526
    -- upvalues: u15 (ref)
    local v124 = u15 and u15:FindFirstChild((`Results{p123 <= 12 and 1 or 2}`));

    if not (v124 and v124:IsA("Frame")) then
        v124 = nil;
    end;

    if not v124 then
        return nil;
    end;

    local v125 = v124:FindFirstChild((tostring(p123)));

    if v125 and v125:IsA("GuiObject") then
        return v125;
    end;

    return nil;
end;

local function LayoutRounds(p126: number) -- Line: 539
    -- upvalues: u15 (ref), u31 (copy)
    local v127 = u15 and u15:FindFirstChild((`Results{1}`));

    if not (v127 and v127:IsA("Frame")) then
        v127 = nil;
    end;

    local v128 = u15 and u15:FindFirstChild((`Results{2}`));

    if not (v128 and v128:IsA("Frame")) then
        v128 = nil;
    end;

    if not (v127 and v128) then
        return;
    end;

    local v129 = u31[v127.Name];
    local v130 = u31[v128.Name];
    local v131 = v127:FindFirstChild("1");
    local v132 = v127:FindFirstChildOfClass("UIListLayout");

    if not (v129 and (v130 and (v131 and v132))) then
        return;
    end;

    local math_clamp_ret = math.clamp(p126, 1, 24);
    local math_min_ret = math.min(math_clamp_ret, 12);
    local v133 = math_clamp_ret - math_min_ret;

    for i = 1, 24 do
        local v134 = u15 and u15:FindFirstChild((`Results{i <= 12 and 1 or 2}`));

        if not (v134 and v134:IsA("Frame")) then
            v134 = nil;
        end;

        local v135;

        if v134 then
            v135 = v134:FindFirstChild((tostring(i)));

            if not (v135 and v135:IsA("GuiObject")) then
                v135 = nil;
            end;
        else
            v135 = nil;
        end;

        local v136;

        if v135 then
            v135.Visible = i <= math_clamp_ret;
            v136 = i;
        else
            v136 = i;
        end;
    end;

    v128.Visible = v133 > 0;
    local Scale = v127.Size.X.Scale;
    local v137 = v132.Padding.Scale * Scale;
    local v138 = v131.Size.X.Scale * Scale + v137;
    local v139 = v129.X.Scale - Scale / 2;
    local v140 = v139 + (v130.X.Scale - v129.X.Scale);
    local v141;

    if v133 > 0 then
        v141 = v140 + v133 * v138 - v137;
    else
        v141 = v139 + math_min_ret * v138 - v137;
    end;

    local v142 = (v140 + 12 * v138 - v137 - v141) / 2;
    v127.Position = UDim2.new(v129.X.Scale + v142, v129.X.Offset, v129.Y.Scale, v129.Y.Offset);
    v128.Position = UDim2.new(v130.X.Scale + v142, v130.X.Offset, v130.Y.Scale, v130.Y.Offset);

    for i, v in pairs({
        Previous = v139 - 0.014,
        Next = v141 + 0.014
    }) do
        local v143 = u15:FindFirstChild(i);

        if v143 and v143:IsA("GuiObject") then
            local Position = v143.Position;
            v143.Position = UDim2.new(v + v142, Position.X.Offset, Position.Y.Scale, Position.Y.Offset);
        end;
    end;
end;

local function PaintRound(p144: userdata, p145: any, p146: boolean) -- Line: 597
    -- upvalues: Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), table_freeze_ret3 (copy)
    local Selected = p144:FindFirstChild("Selected");

    if Selected and Selected:IsA("GuiObject") then
        Selected.Visible = p146;
    end;

    if not p145 then
        p144.BackgroundColor3 = Color3_fromRGB_ret3;

        for _, v in ipairs({ "Team1", "Team2" }) do
            local v147 = p144:FindFirstChild(v);

            if v147 and v147:IsA("GuiObject") then
                v147.Visible = false;
            end;
        end;

        return;
    end;

    local v148;

    if p145.Winner == "Counter-Terrorists" then
        v148 = Color3_fromRGB_ret;
    else
        v148 = Color3_fromRGB_ret2;
    end;

    p144.BackgroundColor3 = v148;
    local v149 = p145.Winner == "Terrorists" and "Team1" or "Team2";

    for _, v in ipairs({ "Team1", "Team2" }) do
        local v150 = p144:FindFirstChild(v);

        if v150 then
            local v151 = v == v149;
            v150.Visible = v151;

            if v151 then
                v150.BackgroundTransparency = 0;
                v150.BackgroundColor3 = v148;
                local Icon = v150:FindFirstChild("Icon");

                if Icon then
                    Icon.Image = table_freeze_ret3[p145.WinType] or "rbxassetid://70876442749327";
                    Icon.ImageColor3 = v148;
                    Icon.ImageTransparency = 0;
                end;
            end;
        end;
    end;
end;

local function GetRound(p152: any, p153: number) -- Line: 645
    for _, v in ipairs(p152.Rounds) do
        if v.Round == p153 then
            return v;
        end;
    end;

    return nil;
end;

local function PopulateEventLog(p154) -- Line: 657
    -- upvalues: u15 (ref), u19 (ref), ClearRows (copy), Format (copy), WeaponIcon (copy), ApplyAvatar (copy)
    local v155 = u15 and u15:FindFirstChild("EventLog");

    if not (v155 and u19) then
        return;
    end;

    ClearRows(v155);
    local v156 = u15:FindFirstChild("header") or u15:FindFirstChild("Header");

    if v156 then
        v156 = v156:FindFirstChild("Left");
    end;

    if v156 then
        v156 = v156:FindFirstChild("Label");
    end;

    if v156 then
        v156.Text = not p154 and "EVENT LOG" or `EVENT LOG | ROUND {p154.Round}`;
    end;

    if not p154 then
        return;
    end;

    for i, v in ipairs(p154.Events) do
        local v157 = u19:Clone();
        v157.Name = `Row_{i}`;
        v157.LayoutOrder = i;
        v157.Visible = true;
        v157.Parent = v155;
        local v158 = Format.Duration(v.Time);
        local v159;

        if v157 then
            v159 = v157:FindFirstChild("Time");
        else
            v159 = v157;
        end;

        if v159 and v159:IsA("TextLabel") then
            v159.Text = v158;
        end;

        local v160 = `{math.floor(v.Distance + 0.5)}m`;
        local v161;

        if v157 then
            v161 = v157:FindFirstChild("Meter");
        else
            v161 = v157;
        end;

        if v161 and v161:IsA("TextLabel") then
            v161.Text = v160;
        end;

        local ItemIcon = v157:FindFirstChild("ItemIcon");

        if ItemIcon and ItemIcon:IsA("ImageLabel") then
            ItemIcon.Image = WeaponIcon.Get(v.Weapon);
        end;

        local v162 = v;
        local v163 = {};

        for _, child in ipairs(v157:GetChildren()) do
            if child:IsA("GuiObject") and child.Name == "Player" then
                table.insert(v163, child);
            end;
        end;

        table.sort(v163, function(p164: userdata, p165: userdata) -- Line: 694
            return p164.Position.X.Scale < p165.Position.X.Scale;
        end);

        for i2, v2 in ipairs({ v162.Killer, v162.Victim }) do
            ApplyAvatar(v163[i2], v2);
        end;
    end;
end;

local function PopulateRoundPlayers(u166, p167) -- Line: 707
    -- upvalues: u15 (ref), u20 (ref), ClearRows (copy), PaintPlayerRow (copy), LocalPlayer (copy), u4 (copy), u2 (copy), u3 (copy), ApplyAvatar (copy), Format (copy)
    local v168 = u15 and u15:FindFirstChild("Player");

    if not (v168 and u20) then
        return;
    end;

    ClearRows(v168);

    if not p167 then
        return;
    end;

    local u169 = {};

    for _, v in ipairs(u166.Players) do
        u169[v.UserId] = v;
    end;

    local function TeamOf(p170) -- Line: 724
        -- upvalues: u169 (copy)
        local v171 = u169[p170.UserId];

        return not v171 and "" or v171.Team;
    end;

    local table_clone_ret = table.clone(p167.Players);
    table.sort(table_clone_ret, function(p172, p173) -- Line: 731
        -- upvalues: u169 (copy), u166 (copy)
        local v174 = u169[p172.UserId];
        local v175 = (not v174 and "" or v174.Team) == u166.Team;
        local v176 = u169[p173.UserId];

        if v175 == ((not v176 and "" or v176.Team) == u166.Team) then
            return p172.CombatScore > p173.CombatScore;
        end;

        return v175;
    end);

    for i, v in ipairs(table_clone_ret) do
        local v177 = u20:Clone();
        v177.Name = `Row_{i}`;
        v177.LayoutOrder = i;
        v177.Visible = true;
        v177.Parent = v168;
        local v178 = u169[v.UserId];
        local v179 = u169[v.UserId];
        local v180 = not v179 and "" or v179.Team;
        local Team = u166.Team;
        local v181;

        if v.UserId == LocalPlayer.UserId then
            v181 = u4;
        elseif v180 == Team then
            v181 = u2;
        else
            v181 = u3;
        end;

        PaintPlayerRow(v177, v181);
        local v182;

        if v178 then
            v182 = v178.DisplayName;
        else
            v182 = tostring(v.UserId);
        end;

        local v183;

        if v177 then
            v183 = v177:FindFirstChild("PlayerName");
        else
            v183 = v177;
        end;

        if v183 and v183:IsA("TextLabel") then
            v183.Text = v182;
        end;

        local UserId = v.UserId;
        ApplyAvatar(v177:FindFirstChild("Player"), UserId);
        local v184 = Format.Number(v.CombatScore);
        local CombatScore = v177:FindFirstChild("CombatScore");
        local v185;

        if CombatScore then
            v185 = CombatScore:FindFirstChild("Amount");
        else
            v185 = CombatScore;
        end;

        if v185 and v185:IsA("TextLabel") then
            v185.Text = v184;
        elseif CombatScore and CombatScore:IsA("TextLabel") then
            CombatScore.Text = v184;
        end;

        local v186 = Format.Money(v.MoneySpent);
        local Econ = v177:FindFirstChild("Econ");
        local v187;

        if Econ then
            v187 = Econ:FindFirstChild("Amount");
        else
            v187 = Econ;
        end;

        if v187 and v187:IsA("TextLabel") then
            v187.Text = v186;
        elseif Econ and Econ:IsA("TextLabel") then
            Econ.Text = v186;
        end;

        local v188 = Format.Number(v.Kills);
        local Kills = v177:FindFirstChild("Kills");
        local v189;

        if Kills then
            v189 = Kills:FindFirstChild("Amount");
        else
            v189 = Kills;
        end;

        if v189 and v189:IsA("TextLabel") then
            v189.Text = v188;
        elseif Kills and Kills:IsA("TextLabel") then
            Kills.Text = v188;
        end;

        local v190 = Format.Number(v.Assists);
        local Assist = v177:FindFirstChild("Assist");
        local v191;

        if Assist then
            v191 = Assist:FindFirstChild("Amount");
        else
            v191 = Assist;
        end;

        if v191 and v191:IsA("TextLabel") then
            v191.Text = v190;
        elseif Assist and Assist:IsA("TextLabel") then
            Assist.Text = v190;
        end;

        local Equip = v177:FindFirstChild("Equip");

        if Equip then
            local v192;

            if v.Equip == "" then
                v192 = "NONE";
            else
                local Equip2 = v.Equip;
                v192 = (Equip2 == nil or Equip2 == "") and "" or string.upper(Equip2);
            end;

            local v193;

            if Equip then
                v193 = Equip:FindFirstChild("Gun");
            else
                v193 = Equip;
            end;

            if v193 and v193:IsA("TextLabel") then
                v193.Text = v192;
            end;

            local Armor = v.Armor;

            if Equip then
                Equip = Equip:FindFirstChild("Armor");
            end;

            if Equip and Equip:IsA("TextLabel") then
                Equip.Text = Armor;
            end;
        end;
    end;
end;

local function RenderTimeline() -- Line: 763
    -- upvalues: u24 (ref), u15 (ref), MapIcon (copy), CareerData (copy), u26 (ref), LayoutRounds (copy), PaintRound (copy), PopulateEventLog (copy), PopulateRoundPlayers (copy)
    local v194 = u24;

    if not (v194 and u15) then
        return;
    end;

    local Map = u15:FindFirstChild("Map");

    if Map and Map:IsA("ImageLabel") then
        local Radar, v195 = MapIcon.GetRadar(v194.Map);
        Map.Image = Radar;
        Map.ImageTransparency = 0;
        Map.ImageRectOffset = v195.Min;
        Map.ImageRectSize = Vector2.new(v195.Width, v195.Height);
        Map.Rotation = 90;
        Map.ScaleType = Enum.ScaleType.Fit;
        Map.BackgroundTransparency = 1;
    end;

    local MatchDetails = CareerData.GetMatchDetails(v194.MatchId);
    local v196;

    if MatchDetails then
        local v197 = u26;
        v196 = nil;

        for _, v in ipairs(MatchDetails.Rounds) do
            if v.Round == v197 then
                v196 = v;
                break;
            end;
        end;
    else
        v196 = MatchDetails;
    end;

    local RoundCount = v194.RoundCount;
    LayoutRounds(RoundCount <= 0 and (MatchDetails and #MatchDetails.Rounds or 0) or RoundCount);

    for i = 1, 24 do
        local v198 = u15 and u15:FindFirstChild((`Results{i <= 12 and 1 or 2}`));

        if not (v198 and v198:IsA("Frame")) then
            v198 = nil;
        end;

        local v199;

        if v198 then
            v199 = v198:FindFirstChild((tostring(i)));

            if not (v199 and v199:IsA("GuiObject")) then
                v199 = nil;
            end;
        else
            v199 = nil;
        end;

        local v200;

        if v199 then
            local v201;

            if MatchDetails then
                v200 = i;
                v201 = nil;

                for _, v in ipairs(MatchDetails.Rounds) do
                    if v.Round == v200 then
                        v201 = v;
                        break;
                    end;
                end;
            else
                v200 = i;
                v201 = MatchDetails;
            end;

            PaintRound(v199, v201, v200 == u26);
        else
            v200 = i;
        end;
    end;

    PopulateEventLog(v196);
    PopulateRoundPlayers(v194, v196);
end;

local function SelectRound(p202: number) -- Line: 806
    -- upvalues: u24 (ref), CareerData (copy), Router (copy), u26 (ref), RenderTimeline (copy)
    local v203 = u24;

    if v203 then
        v203 = CareerData.GetMatchDetails(v203.MatchId);
    end;

    if v203 then
        local v204 = nil;

        for _, v in ipairs(v203.Rounds) do
            if v.Round == p202 then
                v204 = v;
                break;
            end;
        end;

        if v204 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u26 = p202;
            RenderTimeline();

            return true;
        end;
    end;

    return false;
end;

local function BindRoundButtons() -- Line: 822
    -- upvalues: u15 (ref), u24 (ref), CareerData (copy), Router (copy), u26 (ref), RenderTimeline (copy), ActivateButton (copy)
    for i = 1, 24 do
        local v205 = u15 and u15:FindFirstChild((`Results{i <= 12 and 1 or 2}`));

        if not (v205 and v205:IsA("Frame")) then
            v205 = nil;
        end;

        local v206;

        if v205 then
            v206 = v205:FindFirstChild((tostring(i)));

            if not (v206 and v206:IsA("GuiObject")) then
                v206 = nil;
            end;
        else
            v206 = nil;
        end;

        local v207;

        if v206 then
            local function Select() -- Line: 830
                -- upvalues: i (copy), u24 (ref), CareerData (ref), Router (ref), u26 (ref), RenderTimeline (ref)
                local v208 = i;
                local v209 = u24;

                if v209 then
                    v209 = CareerData.GetMatchDetails(v209.MatchId);
                end;

                if v209 then
                    local v210 = nil;

                    for _, v in ipairs(v209.Rounds) do
                        if v.Round == v208 then
                            v210 = v;
                            break;
                        end;
                    end;

                    if not v210 then
                        return;
                    end;

                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    u26 = v208;
                    RenderTimeline();
                end;
            end;

            local Hitbox = v206:FindFirstChild("Hitbox");
            local v211 = nil;

            if Hitbox and Hitbox:IsA("GuiButton") then
                v211 = Hitbox;
            elseif v206:IsA("GuiButton") then
                v211 = v206;
            end;

            if v211 then
                v211.Active = true;
                v211.Selectable = true;
                ActivateButton(v211);
                v211.Activated:Connect(Select);
            end;

            if v206:IsA("GuiButton") and v206 ~= v211 then
                v206.Selectable = false;
                v206.Active = true;
                v206.Activated:Connect(Select);
                v207 = i;
            else
                v207 = i;
            end;
        else
            v207 = i;
        end;
    end;
end;

local function BindRoundArrows() -- Line: 861
    -- upvalues: u15 (ref), ActivateButton (copy), u26 (ref), u24 (ref), CareerData (copy), Router (copy), RenderTimeline (copy)
    for i, v in pairs({
        Previous = -1,
        Next = 1
    }) do
        local v212 = u15 and u15:FindFirstChild(i);

        if v212 and v212:IsA("GuiButton") then
            v212.Active = true;
            v212.Selectable = true;
            ActivateButton(v212);
            v212.Activated:Connect(function() -- Line: 871
                -- upvalues: u26 (ref), v (copy), u24 (ref), CareerData (ref), Router (ref), RenderTimeline (ref)
                local v213 = u26 + v;

                while true do
                    if v213 < 1 or v213 > 24 then
                        return;
                    end;

                    local v214 = u24;

                    if v214 then
                        v214 = CareerData.GetMatchDetails(v214.MatchId);
                    end;

                    local v215;

                    if v214 then
                        local v216 = nil;

                        for _, v2 in ipairs(v214.Rounds) do
                            if v2.Round == v213 then
                                v216 = v2;
                                break;
                            end;
                        end;

                        if v216 then
                            Router.broadcastRouter("RunInterfaceSound", "UI Click");
                            u26 = v213;
                            RenderTimeline();
                            v215 = true;
                        else
                            v215 = false;
                        end;
                    else
                        v215 = false;
                    end;

                    if v215 then
                        return;
                    end;

                    v213 = v213 + v;
                end;
            end);
        end;
    end;
end;

local function PaintDamageBlock(p217: userdata?, p218: any) -- Line: 886
    -- upvalues: Format (copy), Color3_new_ret2 (copy), Color3_fromRGB_ret7 (copy), Derive (copy)
    if not p217 then
        return;
    end;

    local v219 = p218.Head + p218.Body + p218.Legs;
    local v220 = Format.Number(v219);
    local v221;

    if p217 then
        v221 = p217:FindFirstChild("Total");
    else
        v221 = p217;
    end;

    if v221 and v221:IsA("TextLabel") then
        v221.Text = v220;
    end;

    local DealtNumbers = p217:FindFirstChild("DealtNumbers");

    if DealtNumbers then
        local v222 = Format.Number(p218.Head);
        local v223;

        if DealtNumbers then
            v223 = DealtNumbers:FindFirstChild("Head");
        else
            v223 = DealtNumbers;
        end;

        if v223 and v223:IsA("TextLabel") then
            v223.Text = v222;
        end;

        local v224 = Format.Number(p218.Body);
        local v225;

        if DealtNumbers then
            v225 = DealtNumbers:FindFirstChild("Body");
        else
            v225 = DealtNumbers;
        end;

        if v225 and v225:IsA("TextLabel") then
            v225.Text = v224;
        end;

        local v226 = Format.Number(p218.Legs);

        if DealtNumbers then
            DealtNumbers = DealtNumbers:FindFirstChild("Legs");
        end;

        if DealtNumbers and DealtNumbers:IsA("TextLabel") then
            DealtNumbers.Text = v226;
        end;
    end;

    local Body = p217:FindFirstChild("Body");

    if not Body then
        return;
    end;

    for i, v in pairs({
        Head = p218.Head,
        Torso = p218.Body,
        Legs = p218.Legs
    }) do
        local v227 = Body:FindFirstChild(i);

        if v227 and v227:IsA("ImageLabel") then
            local v228 = Derive.Divide(v, v219);
            v227.ImageColor3 = Color3_new_ret2:Lerp(Color3_fromRGB_ret7, (math.clamp(v228, 0, 1)));
        end;
    end;
end;

local function TintLabel(p229: userdata, p230: string, p231) -- Line: 919
    local v232 = p229:FindFirstChild(p230);

    if not (v232 and v232:IsA("TextLabel")) then
        return;
    end;

    local v233 = v232:FindFirstChildOfClass("UIGradient");

    if not v233 then
        v232.TextColor3 = p231;

        return;
    end;

    v233.Color = ColorSequence.new(p231);
    v232.TextColor3 = Color3.new(1, 1, 1);
end;

local function PopulateFight(p234: userdata, p235: any, p236: number) -- Line: 936
    -- upvalues: u23 (ref), table_freeze_ret2 (copy), TintLabel (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret5 (copy), WeaponIcon (copy), PaintDamageBlock (copy)
    local v237 = u23:Clone();
    v237.Name = `Row_{p236}`;
    v237.LayoutOrder = p236;
    v237.Visible = true;
    local Outcome = v237:FindFirstChild("Outcome");
    local v238 = table_freeze_ret2[p235.Outcome] == true;

    if Outcome and Outcome:IsA("TextLabel") then
        Outcome.Visible = v238;

        if v238 then
            Outcome.TextTransparency = 0;
        end;
    end;

    local string_upper_ret = string.upper(p235.Outcome);
    local v239;

    if v237 then
        v239 = v237:FindFirstChild("Outcome");
    else
        v239 = v237;
    end;

    if v239 and v239:IsA("TextLabel") then
        v239.Text = string_upper_ret;
    end;

    local v240 = p235.RoundWon and "WON" or "LOST";
    local v241;

    if v237 then
        v241 = v237:FindFirstChild("Status");
    else
        v241 = v237;
    end;

    if v241 and v241:IsA("TextLabel") then
        v241.Text = v240;
    end;

    local v242;

    if p235.Outcome == "Kill" then
        v242 = Color3_fromRGB_ret4;
    else
        v242 = Color3_fromRGB_ret5;
    end;

    TintLabel(v237, "Outcome", v242);
    local v243;

    if p235.RoundWon then
        v243 = Color3_fromRGB_ret4;
    else
        v243 = Color3_fromRGB_ret5;
    end;

    TintLabel(v237, "Status", v243);
    local v244 = tostring(p235.Round);
    local v245;

    if v237 then
        v245 = v237:FindFirstChild("Title");
    else
        v245 = v237;
    end;

    if v245 and v245:IsA("TextLabel") then
        v245.Text = v244;
    end;

    local YourWeapon = p235.YourWeapon;
    local v246 = (YourWeapon == nil or YourWeapon == "") and "" or string.upper(YourWeapon);
    local v247;

    if v237 then
        v247 = v237:FindFirstChild("YourWeaponName");
    else
        v247 = v237;
    end;

    if v247 and v247:IsA("TextLabel") then
        v247.Text = v246;
    end;

    local EnemyWeapon = p235.EnemyWeapon;
    local v248 = (EnemyWeapon == nil or EnemyWeapon == "") and "" or string.upper(EnemyWeapon);
    local v249;

    if v237 then
        v249 = v237:FindFirstChild("EnemyWeaponName");
    else
        v249 = v237;
    end;

    if v249 and v249:IsA("TextLabel") then
        v249.Text = v248;
    end;

    local v250 = `{math.floor(p235.Distance + 0.5)}m`;
    local v251;

    if v237 then
        v251 = v237:FindFirstChild("Range");
    else
        v251 = v237;
    end;

    if v251 and v251:IsA("TextLabel") then
        v251.Text = v250;
    end;

    for _, v in {
        { "YourWeapon", p235.YourWeapon },
        { "EnemyWeapon", p235.EnemyWeapon }
    } do
        local v252 = v237:FindFirstChild(v[1]);

        if v252 and v252:IsA("ImageLabel") then
            v252.Image = WeaponIcon.Get(v[2]);
        end;
    end;

    PaintDamageBlock(v237:FindFirstChild("DamageDealt"), p235.DamageDealt);
    PaintDamageBlock(v237:FindFirstChild("DamageTaken"), p235.DamageTaken);
    v237.Parent = p234;
end;

local function ScaleFightPanel(p253: userdata, p254: number) -- Line: 978
    -- upvalues: u22 (ref)
    if not p253:IsA("GuiObject") or p254 <= 1 then
        return;
    end;

    local Size = u22.Size;
    p253.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * p254, Size.Y.Offset * p254);

    for _, child in ipairs(p253:GetChildren()) do
        if string.sub(child.Name, 1, 4) == "Row_" and child:IsA("GuiObject") then
            local Size2 = child.Size;
            child.Size = UDim2.new(Size2.X.Scale, Size2.X.Offset, Size2.Y.Scale / p254, Size2.Y.Offset);
        end;
    end;

    local v255 = p253:FindFirstChildOfClass("UIListLayout");

    if v255 then
        local Padding = v255.Padding;
        v255.Padding = UDim.new(Padding.Scale / p254, Padding.Offset);
    end;
end;

local function RenderPerformance() -- Line: 1007
    -- upvalues: u24 (ref), u16 (ref), u21 (ref), ClearRows (copy), CareerData (copy), Format (copy), ApplyAvatar (copy), u27 (copy), u22 (ref), u23 (ref), PopulateFight (copy), ScaleFightPanel (copy), ActivateButton (copy), Router (copy), RenderPerformance (copy)
    local v256 = u24;
    local v257 = u16 and u16:FindFirstChild("Frame");

    if not (v256 and (v257 and u21)) then
        return;
    end;

    ClearRows(v257);
    local MatchDetails = CareerData.GetMatchDetails(v256.MatchId);

    if not MatchDetails then
        return;
    end;

    local v258 = 0;

    for _, v in ipairs(MatchDetails.Duels) do
        v258 = v258 + 10;
        local v259 = u21:Clone();
        v259.Name = `Row_{v258}`;
        v259.LayoutOrder = v258;
        v259.Visible = true;
        v259.Parent = v257;
        local YourStats = v259:FindFirstChild("YourStats");

        if YourStats then
            local v260 = Format.Number(v.Kills);
            local Kills = YourStats:FindFirstChild("Kills");
            local v261;

            if Kills then
                v261 = Kills:FindFirstChild("Amount");
            else
                v261 = Kills;
            end;

            if v261 and v261:IsA("TextLabel") then
                v261.Text = v260;
            elseif Kills and Kills:IsA("TextLabel") then
                Kills.Text = v260;
            end;

            local v262 = Format.Number(v.Deaths);
            local Deaths = YourStats:FindFirstChild("Deaths");
            local v263;

            if Deaths then
                v263 = Deaths:FindFirstChild("Amount");
            else
                v263 = Deaths;
            end;

            if v263 and v263:IsA("TextLabel") then
                v263.Text = v262;
            elseif Deaths and Deaths:IsA("TextLabel") then
                Deaths.Text = v262;
            end;

            local v264 = Format.Number(v.Assists);
            local Assists = YourStats:FindFirstChild("Assists");
            local v265;

            if Assists then
                v265 = Assists:FindFirstChild("Amount");
            else
                v265 = Assists;
            end;

            if v265 and v265:IsA("TextLabel") then
                v265.Text = v264;
            elseif Assists and Assists:IsA("TextLabel") then
                Assists.Text = v264;
            end;
        end;

        local v266 = v259:FindFirstChild("Enemy") or v259;
        local v267 = `{v.DisplayName} (@{v.Username})`;
        local v268;

        if v266 then
            v268 = v266:FindFirstChild("PlayerName");
        else
            v268 = v266;
        end;

        if v268 and v268:IsA("TextLabel") then
            v268.Text = v267;
        end;

        local UserId = v.UserId;
        ApplyAvatar(v266:FindFirstChild("Player"), UserId);
        local v269 = u27[v.UserId] == true;
        local v270;

        if v269 and (u22 and u23) then
            local v271 = v258 + 1;
            local v272 = u22:Clone();
            v272.Name = `Row_{v271}`;
            v272.LayoutOrder = v271;
            v272.Visible = true;
            v272.Parent = v257;
            local v273 = v272:FindFirstChild(u23.Name);

            if v273 then
                v273:Destroy();
            end;

            v270 = v;

            for i, v2 in ipairs(v.Fights) do
                PopulateFight(v272, v2, i);
            end;

            ScaleFightPanel(v272, #v270.Fights);
        else
            v270 = v;
        end;

        local Details = v266:FindFirstChild("Details");

        if Details and Details:IsA("GuiButton") then
            ActivateButton(Details);
            local v274 = v269 and "CLOSE" or "DETAILS";
            local v275;

            if Details then
                v275 = Details:FindFirstChild("SelectedOptionText");
            else
                v275 = Details;
            end;

            if v275 and v275:IsA("TextLabel") then
                v275.Text = v274;
            end;

            local UserId2 = v270.UserId;
            Details.Activated:Connect(function() -- Line: 1062
                -- upvalues: Router (ref), u27 (ref), UserId2 (copy), RenderPerformance (ref)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u27[UserId2] = u27[UserId2] ~= true;
                RenderPerformance();
            end);
        end;
    end;
end;

local function SelectTab(p276: string) -- Line: 1074
    -- upvalues: u25 (ref), u24 (ref), u14 (ref), u15 (ref), u16 (ref), u17 (ref), RenderTimeline (copy), RenderPerformance (copy)
    u25 = p276;
    local v277 = u24;
    local v278;

    if v277 == nil then
        v278 = false;
    else
        v278 = v277.Gamemode ~= "Deathmatch";
    end;

    if u14 then
        u14.Visible = p276 == "Scoreboard";
    end;

    if u15 then
        local v279;

        if p276 == "Timeline" then
            v279 = v278;
        else
            v279 = false;
        end;

        u15.Visible = v279;
    end;

    if u16 then
        local v280;

        if p276 == "Performance" then
            v280 = v278;
        else
            v280 = false;
        end;

        u16.Visible = v280;
    end;

    if u17 then
        for _, child in ipairs(u17:GetChildren()) do
            if child:IsA("GuiButton") then
                local SelectedOptionText = child:FindFirstChild("SelectedOptionText");

                if SelectedOptionText then
                    local v281;

                    if child.Name == p276 then
                        v281 = Color3.new(1, 1, 1);
                    else
                        v281 = Color3.fromRGB(158, 158, 158);
                    end;

                    SelectedOptionText.TextColor3 = v281;
                end;

                if child.Name == "Timeline" or child.Name == "Performance" then
                    child.Visible = v278;
                end;
            end;
        end;
    end;

    if p276 == "Timeline" then
        RenderTimeline();

        return;
    end;

    if p276 == "Performance" then
        RenderPerformance();
    end;
end;

function u1.Bind(p282: userdata) -- Line: 1120
    -- upvalues: u12 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), ActivateButton (copy), Router (copy), SelectTab (copy), u1 (copy), u31 (copy), BindColumnHeadings (copy), BindRoundButtons (copy), BindRoundArrows (copy), CareerData (copy), u24 (ref), u26 (ref), u25 (ref), RenderTimeline (copy), RenderPerformance (copy)
    u12 = p282:FindFirstChild("Details");

    if not u12 then
        return;
    end;

    local InputBlocker = p282:FindFirstChild("InputBlocker");

    if InputBlocker and InputBlocker:IsA("GuiButton") then
        InputBlocker.Active = true;
        InputBlocker.Visible = false;
        u13 = InputBlocker;
    end;

    u14 = u12:FindFirstChild("Scoreboard");
    u15 = u12:FindFirstChild("Timeline");
    u16 = u12:FindFirstChild("Peformance") or u12:FindFirstChild("Performance");
    u17 = u12:FindFirstChild("Filters");
    local v283 = u14 and u14:FindFirstChild("Main");

    if v283 then
        v283 = v283:FindFirstChild("Main");
    end;

    if v283 then
        v283 = v283:FindFirstChild("Template");
    end;

    u18 = v283;
    local v284 = u15 and u15:FindFirstChild("EventLog");

    if v284 then
        v284 = v284:FindFirstChild("Template");
    end;

    u19 = v284;
    local v285 = u15 and u15:FindFirstChild("Player");

    if v285 then
        v285 = v285:FindFirstChild("Template");
    end;

    u20 = v285;
    local v286 = u16 and u16:FindFirstChild("Frame");
    local v287;

    if v286 then
        v287 = v286:FindFirstChild("Template");
    else
        v287 = v286;
    end;

    u21 = v287;

    if v286 then
        v286 = v286:FindFirstChild("DetailTemplate");
    end;

    u22 = v286;
    local v288 = u22 and u22:FindFirstChild("FightTemplate");
    u23 = v288;

    for _, v in ipairs({
        u18,
        u19,
        u20,
        u21,
        u22,
        u23
    }) do
        if v and v:IsA("GuiObject") then
            v.Visible = false;
        end;
    end;

    if u17 then
        for _, child in ipairs(u17:GetChildren()) do
            if child:IsA("GuiButton") then
                local Name = child.Name;
                ActivateButton(child);
                child.Activated:Connect(function() -- Line: 1173
                    -- upvalues: Router (ref), SelectTab (ref), Name (copy)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    SelectTab(Name);
                end);
            end;
        end;
    end;

    local Close = u12:FindFirstChild("Close");

    if Close and Close:IsA("GuiButton") then
        ActivateButton(Close);
        Close.Activated:Connect(function() -- Line: 1184
            -- upvalues: Router (ref), u1 (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.Close();
        end);
    end;

    local v289 = u15 and u15:FindFirstChild((`Results{1}`));

    if not (v289 and v289:IsA("Frame")) then
        v289 = nil;
    end;

    if v289 then
        u31[v289.Name] = v289.Position;
    end;

    local v290 = u15 and u15:FindFirstChild((`Results{2}`));

    if not (v290 and v290:IsA("Frame")) then
        v290 = nil;
    end;

    if v290 then
        u31[v290.Name] = v290.Position;
    end;

    BindColumnHeadings();
    BindRoundButtons();
    BindRoundArrows();
    CareerData.MatchLoaded:Connect(function(p291) -- Line: 1202
        -- upvalues: u1 (ref), u24 (ref), u26 (ref), u25 (ref), RenderTimeline (ref), RenderPerformance (ref)
        if not (u1.IsOpen() and (u24 ~= nil and p291.MatchId == u24.MatchId)) then
            return;
        end;

        u26 = #p291.Rounds <= 0 and 1 or p291.Rounds[1].Round;

        if u25 == "Timeline" then
            RenderTimeline();

            return;
        end;

        if u25 == "Performance" then
            RenderPerformance();
        end;
    end);
    u12.Visible = false;
end;

function u1.Open(p292) -- Line: 1220
    -- upvalues: u12 (ref), u24 (ref), u26 (ref), u27 (copy), PopulateHeader (copy), PopulateScoreboard (copy), SelectTab (copy), CareerData (copy), u13 (ref)
    if not u12 then
        return;
    end;

    u24 = p292;
    u26 = 1;
    table.clear(u27);
    PopulateHeader(p292);
    PopulateScoreboard(p292);
    SelectTab("Scoreboard");
    CareerData.RequestMatchDetails(p292.MatchId);

    if u13 then
        u13.Visible = true;
    end;

    u12.Visible = true;
end;

function u1.Close() -- Line: 1243
    -- upvalues: u12 (ref), u13 (ref), u24 (ref)
    if u12 then
        u12.Visible = false;
    end;

    if u13 then
        u13.Visible = false;
    end;

    u24 = nil;
end;

function u1.IsOpen() -- Line: 1255
    -- upvalues: u12 (ref)
    local v293;

    if u12 == nil then
        v293 = false;
    else
        v293 = u12.Visible;
    end;

    return v293;
end;

return u1;