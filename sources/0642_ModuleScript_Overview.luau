-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Types);
local Format = require(script.Parent.Format);
local Derive = require(script.Parent.Derive);
local Resolve = require(script.Parent.Resolve);
local Selection = require(script.Parent.Selection);
local CareerData = require(script.Parent.CareerData);
local WeaponIcon = require(script.Parent.WeaponIcon);
local LocalPlayer = Players.LocalPlayer;
local GetRankTitle = require(ReplicatedStorage.Components.Common.GetRankTitle);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local LevelsIcon = require(ReplicatedStorage.Database.Custom.GameStats.LevelsIcon);
local table_freeze_ret = table.freeze({ "Counter-Terrorists", "Terrorists" });
local Color3_fromRGB_ret = Color3.fromRGB(219, 43, 43);
local Color3_new_ret = Color3.new(1, 1, 1);
local table_freeze_ret2 = table.freeze({
    Pistol = "1ST ROUND",
    Eco = "$0-999",
    Semi = "$1000-3899",
    Full = "$3900+"
});
local table_freeze_ret3 = table.freeze({ "LOADOUT", "K/D", "ADR", "KAST", "WIN %", "KILLS", "DEATHS" });
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
local u12 = {};

local function GetOrderedLabels(p13: userdata) -- Line: 76
    local v14 = p13:FindFirstChild("Left") or p13;
    local v15 = {};

    for _, child in ipairs(v14:GetChildren()) do
        if child:IsA("TextLabel") then
            table.insert(v15, child);
        end;
    end;

    table.sort(v15, function(p16: userdata, p17: userdata) -- Line: 86
        return p16.Position.X.Scale < p17.Position.X.Scale;
    end);

    return v15;
end;

local function GetBadgeIconFromItem(p18) -- Line: 95
    -- upvalues: Skins (copy)
    if typeof(p18) ~= "table" or (p18.Name ~= "Badge" or typeof(p18.Skin) ~= "string") then
        return "";
    end;

    local SkinInformation = Skins.GetSkinInformation(p18.Name, p18.Skin);

    if not SkinInformation then
        return "";
    end;

    local v19 = typeof(p18.Float) ~= "number" and 0.9999 or p18.Float;

    return Skins.GetWearImageForFloat(SkinInformation, v19) or SkinInformation.imageAssetId or "";
end;

local function PopulatePins() -- Line: 112
    -- upvalues: u12 (ref), DataController (copy), LocalPlayer (copy), table_freeze_ret (copy), GetBadgeIconFromItem (copy)
    if #u12 == 0 then
        return;
    end;

    local v20, v21 = DataController.Get(LocalPlayer, "Inventory", "Loadout");
    local v22 = {};
    local v23 = {};

    for _, v in ipairs(table_freeze_ret) do
        local v24;

        if typeof(v21) == "table" then
            v24 = v21[v];
        else
            v24 = false;
        end;

        local v25;

        if typeof(v24) == "table" then
            v25 = v24.Equipped;
        else
            v25 = false;
        end;

        local v26;

        if typeof(v25) == "table" then
            v26 = v25["Equipped Badge"];
        else
            v26 = false;
        end;

        if typeof(v26) == "string" and (v26 ~= "" and typeof(v20) == "table") then
            for _, v2 in ipairs(v20) do
                if typeof(v2) == "table" and v2._id == v26 then
                    local v27 = typeof(v2.Skin) ~= "string" and "" or v2.Skin;

                    if v27 ~= "" and not v22[v27] then
                        local v28 = GetBadgeIconFromItem(v2);

                        if v28 ~= "" then
                            v22[v27] = true;
                            table.insert(v23, v28);
                        end;
                    end;

                    break;
                end;
            end;
        end;
    end;

    for i, v in ipairs(u12) do
        local v29 = v23[i];
        v.Image = v29 or "";
        v.Visible = v29 ~= nil;
    end;
end;

local function PopulateLevel() -- Line: 161
    -- upvalues: u3 (ref), DataController (copy), LocalPlayer (copy), GetRankTitle (copy), LevelsIcon (copy)
    local Level = u3.Info:FindFirstChild("Level");

    if not Level then
        return;
    end;

    local v30 = DataController.Get(LocalPlayer, "Level");
    local v31, v32, v33;

    if typeof(v30) == "table" then
        v31 = v30.Level or 1;
        v32 = v30.Experience or 0;
        v33 = v30.NextExperienceRequirement or 1000;
    else
        v31 = 1;
        v33 = 1000;
        v32 = 0;
    end;

    local TextLabel = Level:FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = `[{GetRankTitle(v31)} Rank {v31}]`;
    end;

    local Rank = Level:FindFirstChild("Rank");

    if Rank then
        Rank.Image = LevelsIcon[tostring(v31)] or "";
    end;

    local LevelBar = Level:FindFirstChild("LevelBar");

    if LevelBar then
        LevelBar = LevelBar:FindFirstChild("Current");
    end;

    if LevelBar then
        local v34 = v32 / math.max(v33, 1);
        local math_clamp_ret = math.clamp(v34, 0, 1);
        local Y = LevelBar.Size.Y;
        LevelBar.Size = UDim2.new(math_clamp_ret, 0, Y.Scale, Y.Offset);
    end;
end;

local function PopulateProfile(p35) -- Line: 199
    -- upvalues: u3 (ref), LocalPlayer (copy), PopulatePins (copy), PopulateLevel (copy), Resolve (copy), Format (copy), Derive (copy)
    local Player = u3.Info:FindFirstChild("Player");

    if Player then
        Player = Player:FindFirstChild("Avatar");
    end;

    if Player then
        Player.Image = `rbxthumb://type=AvatarHeadShot&id={LocalPlayer.UserId}&w=150&h=150`;
    end;

    local Username = u3.Info:FindFirstChild("Username");

    if Username then
        Username.Text = LocalPlayer.Name;
    end;

    local Verified = u3.Info:FindFirstChild("Verified");

    if Verified then
        Verified.Visible = LocalPlayer.HasVerifiedBadge;
    end;

    PopulatePins();
    PopulateLevel();
    local BasicInfo = u3:FindFirstChild("BasicInfo");

    if not BasicInfo then
        return;
    end;

    Resolve.SetRow(BasicInfo, "Timeplayed", "TIME PLAYED", Format.TimePlayed(p35.SecondsPlayed));
    Resolve.SetRow(BasicInfo, "Kd", "K/D RATIO", Format.Decimal(Derive.KillDeath(p35), 2));
    Resolve.SetRow(BasicInfo, "Winrate", "WIN RATE", Format.Percent(p35.MatchesWon, p35.MatchesPlayed));
end;

local function PaintBodyZone(p36: string, p37: number, p38: number) -- Line: 232
    -- upvalues: u4 (ref), Color3_new_ret (copy), Color3_fromRGB_ret (copy), Derive (copy)
    local Body = u4:FindFirstChild("Body");

    if Body then
        Body = Body:FindFirstChild(p36);
    end;

    if not Body then
        return;
    end;

    Body.ImageColor3 = Color3_new_ret:Lerp(Color3_fromRGB_ret, Derive.HeatWeight(p37, p38));
end;

local function PopulateAccuracy(p39) -- Line: 244
    -- upvalues: u4 (ref), Resolve (copy), Format (copy), Color3_new_ret (copy), Color3_fromRGB_ret (copy), Derive (copy)
    local Accuracy = p39.Accuracy;
    local Info = u4:FindFirstChild("Info");

    if Info then
        local ShotsHit = Accuracy.ShotsHit;
        Resolve.SetRow(Info, "Average", "AVERAGE", Format.Percent(ShotsHit, Accuracy.ShotsFired, 1));
        Resolve.SetRow(Info, "Head", "HEAD", Format.Percent(Accuracy.HeadHits, ShotsHit, 1));
        Resolve.SetRow(Info, "Body", "BODY", Format.Percent(Accuracy.BodyHits, ShotsHit, 1));
        Resolve.SetRow(Info, "Legs", "LEGS", Format.Percent(Accuracy.LegHits, ShotsHit, 1));
    end;

    local HeadHits = Accuracy.HeadHits;
    local ShotsFired = Accuracy.ShotsFired;
    local Body = u4:FindFirstChild("Body");

    if Body then
        Body = Body:FindFirstChild("Head");
    end;

    if Body then
        Body.ImageColor3 = Color3_new_ret:Lerp(Color3_fromRGB_ret, Derive.HeatWeight(HeadHits, ShotsFired));
    end;

    local BodyHits = Accuracy.BodyHits;
    local ShotsFired2 = Accuracy.ShotsFired;
    local Body2 = u4:FindFirstChild("Body");

    if Body2 then
        Body2 = Body2:FindFirstChild("Torso");
    end;

    if Body2 then
        Body2.ImageColor3 = Color3_new_ret:Lerp(Color3_fromRGB_ret, Derive.HeatWeight(BodyHits, ShotsFired2));
    end;

    local LegHits = Accuracy.LegHits;
    local ShotsFired3 = Accuracy.ShotsFired;
    local Body3 = u4:FindFirstChild("Body");

    if Body3 then
        Body3 = Body3:FindFirstChild("Legs");
    end;

    if not Body3 then
        return;
    end;

    Body3.ImageColor3 = Color3_new_ret:Lerp(Color3_fromRGB_ret, Derive.HeatWeight(LegHits, ShotsFired3));
end;

local function PopulateSide(p40: any, p41: string, p42: string) -- Line: 263
    -- upvalues: u6 (ref), Resolve (copy), Format (copy), Derive (copy), WeaponIcon (copy)
    local v43 = u6 and u6:FindFirstChild(p41);

    if not v43 then
        return;
    end;

    local v44 = p40.Sides[p42];

    if not v44 then
        return;
    end;

    local Info = v43:FindFirstChild("Info");

    if Info then
        Resolve.SetRow(Info, "Kd", "K/D RATIO", Format.Ratio(v44.Kills, v44.Deaths));
        Resolve.SetRow(Info, "Win", "WIN %", Format.Percent(v44.RoundsWon, v44.RoundsPlayed));
        Resolve.SetRow(Info, "Kills/Round", "KILLS/ROUND", Format.Decimal(Derive.Divide(v44.Kills, v44.RoundsPlayed), 1));
    end;

    local FavoriteGun = v43:FindFirstChild("FavoriteGun");

    if not FavoriteGun then
        return;
    end;

    local v45, v46 = Derive.FavouriteWeapon(p40, p42);
    local ItemIcon = FavoriteGun:FindFirstChild("ItemIcon");

    if ItemIcon then
        ItemIcon.Image = not v45 and "" or WeaponIcon.Get(v45, p42);
    end;

    local Header = FavoriteGun:FindFirstChild("Header");

    if Header then
        Header = Header:FindFirstChild("Title");
    end;

    if Header then
        Header.Text = not v45 and "FAVORITE WEAPON" or `FAVORITE WEAPON: {string.upper(v45)}`;
    end;

    local Title = FavoriteGun:FindFirstChild("Title");

    if Title then
        Title.Text = `KILLS: {Format.Number(v46)}`;
    end;
end;

local function PopulateKillStats(p47) -- Line: 314
    -- upvalues: u7 (ref), Resolve (copy), Format (copy), Derive (copy)
    local v48 = u7 and u7:FindFirstChild("WinRate");

    if v48 then
        Resolve.SetRow(v48, "Header", "WINS RATE", Format.Percent(p47.MatchesWon, p47.MatchesPlayed));
        local MoreInfo = v48:FindFirstChild("MoreInfo");

        if MoreInfo then
            MoreInfo = MoreInfo:FindFirstChild("Info");
        end;

        if MoreInfo then
            Resolve.SetRow(MoreInfo, "Played", "PLAYED", Format.Number(p47.MatchesPlayed));
            Resolve.SetRow(MoreInfo, "Won", "WON", Format.Number(p47.MatchesWon));
            Resolve.SetRow(MoreInfo, "Lost", "LOST", Format.Number(p47.MatchesLost));
            Resolve.SetRow(MoreInfo, "Tied", "TIED", Format.Number(p47.MatchesTied));
            Resolve.SetRow(MoreInfo, "Clutch", "CLUTCHES 1V1", Format.Number(p47.Clutches));
            Resolve.SetRow(MoreInfo, "FlawlessRounds", "FLAWLESS ROUNDS", Format.Number(p47.FlawlessRounds));
            Resolve.SetRow(MoreInfo, "MVP", "MVPS", Format.Number(p47.RoundMVPs));
            Resolve.SetRow(MoreInfo, "Ace", "ACE ROUNDS", Format.Number(p47.AceRounds));
            Resolve.SetRow(MoreInfo, "OvertimeWins", "OVERTIME WINS", Format.Number(p47.OvertimeWins));
        end;
    end;

    local v49 = u7 and u7:FindFirstChild("KD");

    if v49 then
        Resolve.SetRow(v49, "Header", "K/D RATIO", Format.Decimal(Derive.KillDeath(p47), 2));
        local MoreInfo = v49:FindFirstChild("MoreInfo");

        if MoreInfo then
            MoreInfo = MoreInfo:FindFirstChild("Info");
        end;

        if MoreInfo then
            Resolve.SetRow(MoreInfo, "Kills", "KILLS", Format.Number(p47.Kills));
            Resolve.SetRow(MoreInfo, "Deaths", "DEATHS", Format.Number(p47.Deaths));
            Resolve.SetRow(MoreInfo, "Assists", "ASSISTS", Format.Number(p47.Assists));
            Resolve.SetRow(MoreInfo, "HeadshotKills", "HEADSHOT KILLS", Format.Number(p47.HeadshotKills));
            Resolve.SetRow(MoreInfo, "Kast", "KAST", Format.Share(Derive.Kast(p47), 1));
            Resolve.SetRow(MoreInfo, "ACS", "ACS", Format.Decimal(Derive.CombatScore(p47), 1));
            Resolve.SetRow(MoreInfo, "ADR", "ADR", Format.Decimal(Derive.AverageDamage(p47), 1));
            Resolve.SetRow(MoreInfo, "DamageDelta", "DAMAGE DELTA TOTAL", Format.Signed(Derive.DamageDelta(p47), 1));
            Resolve.SetRow(MoreInfo, "Kill/Round", "KILL/ROUND", Format.Decimal(Derive.Divide(p47.Kills, p47.RoundsPlayed), 2));
        end;
    end;
end;

local function PopulateLoadout(p50) -- Line: 367
    -- upvalues: u8 (ref), GetOrderedLabels (copy), table_freeze_ret3 (copy), CareerData (copy), Resolve (copy), table_freeze_ret2 (copy), Format (copy), Derive (copy)
    if not u8 then
        return;
    end;

    local Header = u8:FindFirstChild("Header");

    if Header then
        local v51 = GetOrderedLabels(Header);

        for i, v in ipairs(table_freeze_ret3) do
            local v52 = v51[i];

            if v52 then
                v52.Text = v;
            end;
        end;
    end;

    local MoreInfo = u8:FindFirstChild("MoreInfo");

    if MoreInfo then
        MoreInfo = MoreInfo:FindFirstChild("Info");
    end;

    if not MoreInfo then
        return;
    end;

    for _, v in ipairs(CareerData.EconomyTiers) do
        local v53 = Resolve.Row(MoreInfo, v, string.upper(v));

        if v53 then
            local v54 = p50.Economy[v];

            if v54 then
                local v55 = GetOrderedLabels(v53);
                local v56 = {
                    string.upper(v),
                    table_freeze_ret2[v] or "",
                    Format.Ratio(v54.Kills, v54.Deaths),
                    Format.Decimal(Derive.Divide(v54.DamageDealt, v54.RoundsPlayed), 1),
                    Format.Percent(v54.KastRounds, v54.RoundsPlayed, 1),
                    Format.Percent(v54.RoundsWon, v54.RoundsPlayed),
                    Format.Number(v54.Kills),
                    Format.Number(v54.Deaths)
                };

                for i, v2 in ipairs(v56) do
                    local v57 = v55[i];

                    if v57 then
                        v57.Text = v2;
                    end;
                end;
            end;
        end;
    end;
end;

local function IsShown(p58: userdata) -- Line: 425
    -- upvalues: u5 (ref)
    while p58 and p58 ~= u5 do
        if p58:IsA("GuiObject") and not p58.Visible then
            return false;
        end;

        p58 = p58.Parent;
    end;

    return true;
end;

local function GetHeaderIcon(p59) -- Line: 441
    if p59 then
        p59 = p59:FindFirstChild("Header");
    end;

    if p59 then
        p59 = p59:FindFirstChild("Icon");
    end;

    if p59 and p59:IsA("GuiButton") then
        return p59;
    end;

    return nil;
end;

local function SetSelectionLink(p60: userdata?, p61: string, p62: userdata?) -- Line: 450
    if p60 then
        p60[p61] = p62;
    end;
end;

local function LinkSelection() -- Line: 458
    -- upvalues: IsShown (copy), u7 (ref), u6 (ref), u8 (ref), CareerData (copy), Resolve (copy), u10 (ref), u3 (ref), u4 (ref), u9 (ref), u2 (ref), u11 (ref)
    local u63 = {};

    local function AddRow(...) -- Line: 462
        -- upvalues: IsShown (ref), u63 (copy)
        local v64 = {};

        for i = 1, select("#", ...) do
            local v65 = select(i, ...);
            local v66;

            if v65 and v65:IsA("GuiObject") then
                local v67 = IsShown(v65);
                v65.Selectable = v67;

                if v67 then
                    table.insert(v64, v65);
                    v66 = i;
                else
                    v66 = i;
                end;
            else
                v66 = i;
            end;
        end;

        if #v64 > 0 then
            table.insert(u63, v64);
        end;
    end;

    local v68 = u7 and u7:FindFirstChild("WinRate");
    local v69 = u7 and u7:FindFirstChild("KD");
    AddRow(v68, v69);
    local v70 = u6 and u6:FindFirstChild("CT");
    local v71 = u6 and u6:FindFirstChild("T");
    AddRow(v70, v71);
    local v72 = u8 and u8:FindFirstChild("MoreInfo");

    if v72 then
        v72 = v72:FindFirstChild("Info");
    end;

    if v72 then
        for _, v in ipairs(CareerData.EconomyTiers) do
            AddRow(Resolve.Row(v72, v, string.upper(v)));
        end;
    end;

    for i, v in ipairs(u63) do
        local v73 = u63[i - 1];
        local v74 = u63[i + 1];
        local v75 = v;

        for i2, v2 in ipairs(v) do
            v2.NextSelectionLeft = v75[i2 - 1];
            v2.NextSelectionRight = v75[i2 + 1];
            local v76;

            if v73 then
                v76 = v73[math.min(i2, #v73)];
            else
                v76 = v73;
            end;

            v2.NextSelectionUp = v76;
            local v77;

            if v74 then
                v77 = v74[math.min(i2, #v74)];
            else
                v77 = v74;
            end;

            v2.NextSelectionDown = v77;
        end;
    end;

    local v78 = u63[1];

    if v78 then
        v78 = v78[1];
    end;

    u10 = v78;
    local v79 = u3;

    if v79 then
        v79 = v79:FindFirstChild("Header");
    end;

    if v79 then
        v79 = v79:FindFirstChild("Icon");
    end;

    if not (v79 and v79:IsA("GuiButton")) then
        v79 = nil;
    end;

    local v80 = u4;

    if v80 then
        v80 = v80:FindFirstChild("Header");
    end;

    if v80 then
        v80 = v80:FindFirstChild("Icon");
    end;

    if not (v80 and v80:IsA("GuiButton")) then
        v80 = nil;
    end;

    local v81 = u10;

    if v81 then
        if v79 then
            v79.NextSelectionRight = v81;
        end;

        if v80 then
            v80.NextSelectionRight = v81;
        end;

        if u9 and u9:IsA("GuiObject") then
            v81.NextSelectionUp = u9;
        end;
    end;

    for i, v in ipairs(u63) do
        local v82;

        if i == 1 then
            v82 = v79;
        else
            v82 = v80 or v79;
        end;

        if v82 then
            v[1].NextSelectionLeft = v82;
        end;
    end;

    local v83;

    if u2 == nil then
        v83 = false;
    else
        v83 = u2.Visible;
    end;

    local v84 = u11;

    if not v83 then
        v81 = nil;
    end;

    if v84 then
        v84.NextSelectionDown = v81;
    end;

    local v85 = u9;
    local v86 = u11;

    if v85 then
        v85.NextSelectionUp = v86;
    end;

    local v87 = u9 and u9:FindFirstChild("DropdownContent");
    local v88 = v87 and v87:IsA("GuiObject") and v87.Visible;

    if u9 and (u9:IsA("GuiObject") and not v88) then
        u9.NextSelectionDown = u10;
    end;
end;

local function SetDropdownOpen(p89: boolean) -- Line: 553
    -- upvalues: u9 (ref), u10 (ref)
    local v90 = u9 and u9:FindFirstChild("DropdownContent");

    if v90 and v90:IsA("GuiObject") then
        v90.Visible = p89;
    end;

    local v91 = u9 and (u9:FindFirstChild("Container") and u9.Container:FindFirstChild("Left")) and u9.Container.Left:FindFirstChild("Reverse");

    if v91 and v91:IsA("GuiObject") then
        v91.Rotation = p89 and 180 or 0;
    end;

    if u9 and u9:IsA("GuiObject") then
        local v92;

        if p89 then
            v92 = nil;
        else
            v92 = u10;
        end;

        u9.NextSelectionDown = v92;
    end;
end;

local function BindDropdown() -- Line: 575
    -- upvalues: u9 (ref), SetDropdownOpen (copy), Selection (copy)
    if not u9 then
        return;
    end;

    local DropdownContent = u9:FindFirstChild("DropdownContent");
    local v93;

    if DropdownContent then
        v93 = DropdownContent:FindFirstChild("Scroll");
    else
        v93 = DropdownContent;
    end;

    if not v93 then
        return;
    end;

    SetDropdownOpen(false);

    if u9:IsA("GuiButton") then
        u9.Activated:Connect(function() -- Line: 589
            -- upvalues: DropdownContent (copy), SetDropdownOpen (ref)
            local v94 = DropdownContent:IsA("GuiObject") and DropdownContent.Visible;
            SetDropdownOpen(not v94);
        end);
    end;

    for _, child in ipairs(v93:GetChildren()) do
        if child:IsA("GuiButton") then
            local Name = child.Name;

            if Selection.Names[Name] ~= nil then
                child.Activated:Connect(function() -- Line: 605
                    -- upvalues: SetDropdownOpen (ref), Selection (ref), Name (copy)
                    SetDropdownOpen(false);
                    Selection.Set(Name);
                end);
            end;
        end;
    end;
end;

function v1.Bind(p95: userdata) -- Line: 615
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u12 (ref), BindDropdown (copy)
    u2 = p95;
    u3 = p95:FindFirstChild("Profile");
    u4 = p95:FindFirstChild("Accuracy");
    u5 = p95:FindFirstChild("LifetimeStats");
    local v96 = u5 and u5:FindFirstChild("Container");
    local v97;

    if v96 then
        v97 = v96:FindFirstChild("TeamStats");
    else
        v97 = v96;
    end;

    if v97 then
        v97 = v97:FindFirstChild("Team");
    end;

    u6 = v97;
    local v98;

    if v96 then
        v98 = v96:FindFirstChild("KillStats");
    else
        v98 = v96;
    end;

    u7 = v98;

    if v96 then
        v96 = v96:FindFirstChild("Loadout");
    end;

    u8 = v96;
    local v99 = u5 and u5:FindFirstChild("Filter");
    u9 = v99;
    u12 = {};
    local v100 = u3 and u3.Info:FindFirstChild("Pins");

    if v100 then
        for _, child in ipairs(v100:GetChildren()) do
            if child:IsA("ImageLabel") then
                table.insert(u12, child);
            end;
        end;

        table.sort(u12, function(p101: userdata, p102: userdata) -- Line: 636
            return p101.Position.X.Scale < p102.Position.X.Scale;
        end);
    end;

    BindDropdown();
end;

function v1.BindTab(p103: userdata?) -- Line: 647
    -- upvalues: u11 (ref), LinkSelection (copy)
    u11 = p103;
    LinkSelection();
end;

function v1.RefreshSelection() -- Line: 655
    -- upvalues: LinkSelection (copy)
    LinkSelection();
end;

function v1.Render() -- Line: 661
    -- upvalues: Selection (copy), CareerData (copy), u5 (ref), u9 (ref), u3 (ref), PopulateProfile (copy), u4 (ref), PopulateAccuracy (copy), u6 (ref), u8 (ref), PopulateSide (copy), PopulateLoadout (copy), PopulateKillStats (copy), LinkSelection (copy)
    local v104 = Selection.Get();
    local Bucket = CareerData.GetBucket(v104);

    if u5 then
        local Title = u5:FindFirstChild("Title");

        if Title then
            Title = Title:FindFirstChild("Title");
        end;

        if Title then
            Title.Text = Selection.Headings[v104] or "LIFETIME STATS";
        end;

        local v105 = u9 and (u9:FindFirstChild("Container") and u9.Container:FindFirstChild("Left")) and u9.Container.Left:FindFirstChild("Title");

        if v105 then
            v105.Text = Selection.Names[v104] or "All Gamemodes";
        end;
    end;

    if u3 then
        PopulateProfile(Bucket);
    end;

    if u4 then
        PopulateAccuracy(Bucket);
    end;

    local v106 = Selection.HasRounds(v104);
    local v107 = u6 and u6.Parent;

    if v107 then
        v107.Visible = v106;
    end;

    if u8 then
        u8.Visible = v106;
    end;

    if v106 then
        PopulateSide(Bucket, "CT", "Counter-Terrorists");
        PopulateSide(Bucket, "T", "Terrorists");
        PopulateLoadout(Bucket);
    end;

    PopulateKillStats(Bucket);
    LinkSelection();
end;

return v1;