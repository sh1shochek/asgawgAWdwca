-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
require(script.Parent.Types);
local Format = require(script.Parent.Format);
local Derive = require(script.Parent.Derive);
local Selection = require(script.Parent.Selection);
local CareerData = require(script.Parent.CareerData);
local WeaponIcon = require(script.Parent.WeaponIcon);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Router = require(ReplicatedStorage.Database.Security.Router);
local WeaponCategories = require(ReplicatedStorage.Database.Custom.GameStats.WeaponCategories);
local table_freeze_ret = table.freeze({ "Kills", "AllKills", "DamagePerMatch", "KillsPerMatch" });
local table_freeze_ret2 = table.freeze({
    Weapon = true,
    Filter = true
});
local table_freeze_ret3 = table.freeze({
    Rifle = "Rifle",
    SMG = "SMG",
    Pistols = "Pistol",
    Shotguns = "Shotgun",
    Snipers = "Sniper",
    Melee = "Melee",
    Special = "Special"
});
local Color3_fromRGB_ret = Color3.fromRGB(66, 66, 66);
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_fromRGB_ret2 = Color3.fromRGB(32, 32, 32);
local Color3_fromRGB_ret3 = Color3.fromRGB(158, 158, 158);
local table_freeze_ret4 = table.freeze({
    Kills = 0,
    Damage = 0,
    Matches = 0,
    RoundsPlayed = 0,
    RoundsWon = 0,
    RankedRoundsPlayed = 0,
    RankedRoundsWon = 0,
    CrouchKills = 0,
    JumpKills = 0,
    BlindKills = 0,
    CrouchDamage = 0,
    JumpDamage = 0,
    BlindDamage = 0,
    Assists = 0,
    DeadAssists = 0,
    ShotsFired = 0,
    ShotsHit = 0,
    HeadshotHits = 0,
    Reloads = 0,
    Inspects = 0
});
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = "Allweapons";
local u10 = nil;
local u11 = {};
local u12 = {};
local u13 = {};

local function RoundGroup(p14: string, u15: string, u16: string) -- Line: 119
    -- upvalues: Format (copy)
    return {
        Label = p14,

        Read = function(p17) -- Line: 122, Name: Read
            -- upvalues: Format (ref), u15 (copy)
            return Format.Number(p17[u15]);
        end,

        Children = {
            {
                Label = "ROUNDS WON",

                Read = function(p18) -- Line: 128, Name: Read
                    -- upvalues: Format (ref), u16 (copy)
                    return Format.Number(p18[u16]);
                end
            },
            {
                Label = "ROUNDS LOST",

                Read = function(p19) -- Line: 134, Name: Read
                    -- upvalues: Format (ref), u15 (copy), u16 (copy)
                    return Format.Number((math.max(p19[u15] - p19[u16], 0)));
                end
            },
            {
                Label = "WIN %",

                Read = function(p20) -- Line: 140, Name: Read
                    -- upvalues: Format (ref), u16 (copy), u15 (copy)
                    return Format.Percent(p20[u16], p20[u15], 1);
                end
            }
        }
    };
end;

local u38 = {
    RoundGroup("ROUNDS PLAYED", "RoundsPlayed", "RoundsWon"),
    RoundGroup("RANKED ROUNDS PLAYED", "RankedRoundsPlayed", "RankedRoundsWon"),
    {
        Label = "KILLS",

        Read = function(p21) -- Line: 153, Name: Read
            -- upvalues: Format (copy)
            return Format.Number(p21.Kills);
        end,

        Children = {
            {
                Label = "WHILE CROUCHING",

                Read = function(p22) -- Line: 159, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Number(p22.CrouchKills);
                end
            },
            {
                Label = "WHILE JUMPING",

                Read = function(p23) -- Line: 165, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Number(p23.JumpKills);
                end
            },
            {
                Label = "WHILE BLIND",

                Read = function(p24) -- Line: 171, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Number(p24.BlindKills);
                end
            }
        }
    },
    {
        Label = "DAMAGE DEALT",

        Read = function(p25) -- Line: 179, Name: Read
            -- upvalues: Format (copy)
            return Format.Number(p25.Damage);
        end,

        Children = {
            {
                Label = "WHILE CROUCHING",

                Read = function(p26) -- Line: 185, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Number(p26.CrouchDamage);
                end
            },
            {
                Label = "WHILE JUMPING",

                Read = function(p27) -- Line: 191, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Number(p27.JumpDamage);
                end
            },
            {
                Label = "WHILE BLIND",

                Read = function(p28) -- Line: 197, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Number(p28.BlindDamage);
                end
            }
        }
    },
    {
        Label = "ASSISTS",

        Read = function(p29) -- Line: 205, Name: Read
            -- upvalues: Format (copy)
            return Format.Number(p29.Assists);
        end,

        Children = {
            {
                Label = "WHILE DEAD",

                Read = function(p30) -- Line: 211, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Number(p30.DeadAssists);
                end
            }
        }
    },
    {
        Label = "BULLETS SHOT",

        Read = function(p31) -- Line: 219, Name: Read
            -- upvalues: Format (copy)
            return Format.Number(p31.ShotsFired);
        end,

        Children = {
            {
                Label = "HITS",

                Read = function(p32) -- Line: 225, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Number(p32.ShotsHit);
                end
            },
            {
                Label = "HIT %",

                Read = function(p33) -- Line: 231, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Percent(p33.ShotsHit, p33.ShotsFired, 1);
                end
            },
            {
                Label = "HEADSHOTS",

                Read = function(p34) -- Line: 237, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Number(p34.HeadshotHits);
                end
            },
            {
                Label = "HEADSHOT %",

                Read = function(p35) -- Line: 243, Name: Read
                    -- upvalues: Format (copy)
                    return Format.Percent(p35.HeadshotHits, p35.ShotsHit, 1);
                end
            }
        }
    },
    {
        Label = "INSPECTS",

        Read = function(p36) -- Line: 251, Name: Read
            -- upvalues: Format (copy)
            return Format.Number(p36.Inspects);
        end,

        Children = {}
    },
    {
        Label = "RELOADS",

        Read = function(p37) -- Line: 258, Name: Read
            -- upvalues: Format (copy)
            return Format.Number(p37.Reloads);
        end,

        Children = {}
    }
};

local function GetWeapon(p39: string?) -- Line: 268
    -- upvalues: table_freeze_ret4 (copy), CareerData (copy), Selection (copy)
    if p39 then
        return CareerData.GetBucket(Selection.Get()).Weapons[p39] or table_freeze_ret4;
    end;

    return table_freeze_ret4;
end;

local function GetWeaponOrder(p40) -- Line: 278
    -- upvalues: WeaponCategories (copy)
    local table_clone_ret = table.clone(WeaponCategories.GetWeapons());
    local v41 = {};

    for _, v in ipairs(table_clone_ret) do
        v41[v] = true;
    end;

    local v42 = {};

    for i, v in pairs(p40.Weapons) do
        if not (v41[i] or v.Kills <= 0 and v.Damage <= 0) then
            table.insert(v42, i);
        end;
    end;

    table.sort(v42);

    for _, v in ipairs(v42) do
        table.insert(table_clone_ret, v);
    end;

    return table_clone_ret;
end;

local function NameStatColumns(p43: userdata) -- Line: 303
    -- upvalues: table_freeze_ret2 (copy), table_freeze_ret (copy)
    local v44 = {};

    for _, child in ipairs(p43:GetChildren()) do
        if child:IsA("TextLabel") and not table_freeze_ret2[child.Name] then
            table.insert(v44, child);
        end;
    end;

    if #v44 ~= #table_freeze_ret then
        return;
    end;

    table.sort(v44, function(p45: userdata, p46: userdata) -- Line: 315
        return p45.Position.X.Scale < p46.Position.X.Scale;
    end);

    for i, v in ipairs(v44) do
        v.Name = table_freeze_ret[i];
    end;
end;

local function SetColumn(p47: userdata, p48: string, p49: string) -- Line: 326
    local v50 = p47:FindFirstChild(p48);

    if v50 and v50:IsA("TextLabel") then
        v50.Text = p49;
    end;
end;

local function PaintRow(p51: userdata, p52: boolean) -- Line: 335
    -- upvalues: Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    local v53;

    if p52 then
        v53 = Color3_fromRGB_ret;
    else
        v53 = Color3_fromRGB_ret2;
    end;

    p51.BackgroundColor3 = v53;
    p51.BackgroundTransparency = p52 and 0.05 or 0.3;
end;

local function AddStatRow(p54: userdata, p55: string, p56: string, p57: number) -- Line: 345
    -- upvalues: u6 (ref)
    local v58 = p54:Clone();
    v58.Name = `Stat_{p57}`;
    v58.LayoutOrder = p57;
    v58.Visible = true;
    local SelectedOptionText = v58:FindFirstChild("SelectedOptionText");

    if SelectedOptionText and SelectedOptionText:IsA("TextLabel") then
        SelectedOptionText.Text = p55;
    end;

    local KillsPerMatch = v58:FindFirstChild("KillsPerMatch");

    if KillsPerMatch and KillsPerMatch:IsA("TextLabel") then
        KillsPerMatch.Text = p56;
    end;

    v58.Parent = u6;

    return v58;
end;

local function ClearStatRows() -- Line: 360
    -- upvalues: u6 (ref)
    for _, child in ipairs(u6:GetChildren()) do
        if string.sub(child.Name, 1, 5) == "Stat_" then
            child:Destroy();
        end;
    end;
end;

local function RenderStats() -- Line: 370
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), ClearStatRows (copy), u10 (ref), table_freeze_ret4 (copy), CareerData (copy), Selection (copy), u5 (ref), u38 (copy), u11 (copy), ActivateButton (copy), Router (copy), RenderStats (copy)
    if not (u6 and (u7 and u8)) then
        return;
    end;

    ClearStatRows();
    local v59 = u10;
    local v60;

    if v59 then
        v60 = CareerData.GetBucket(Selection.Get()).Weapons[v59] or table_freeze_ret4;
    else
        v60 = table_freeze_ret4;
    end;

    local v61 = u5 and u5:FindFirstChild("Title");

    if v61 then
        v61 = v61:FindFirstChild("Title");
    end;

    if v61 then
        v61.Text = not v59 and "STATS" or `{string.upper(v59)} STATS`;
    end;

    local Empty = u6:FindFirstChild("Empty");

    if Empty and Empty:IsA("GuiObject") then
        Empty.Visible = v59 == nil;
    end;

    if not v59 then
        return;
    end;

    local v62 = 0;

    for _, v in ipairs(u38) do
        v62 = v62 + 1;
        local v63 = #v.Children > 0;
        local v64;

        if v63 then
            v64 = u11[v.Label] == true;
        else
            v64 = v63;
        end;

        local Label = v.Label;
        local v65 = v.Read(v60);
        local v66 = u8:Clone();
        v66.Name = `Stat_{v62}`;
        v66.LayoutOrder = v62;
        v66.Visible = true;
        local SelectedOptionText = v66:FindFirstChild("SelectedOptionText");

        if SelectedOptionText and SelectedOptionText:IsA("TextLabel") then
            SelectedOptionText.Text = Label;
        end;

        local KillsPerMatch = v66:FindFirstChild("KillsPerMatch");

        if KillsPerMatch and KillsPerMatch:IsA("TextLabel") then
            KillsPerMatch.Text = v65;
        end;

        v66.Parent = u6;
        local v67 = v66:FindFirstChildWhichIsA("ImageLabel");

        if v67 then
            v67.Visible = v63;
            v67.Rotation = v64 and 0 or 180;
        end;

        if v63 then
            local v68 = v;

            for _, v2 in ipairs(v.Children) do
                v62 = v62 + 1;
                local Label2 = v2.Label;
                local v69 = v2.Read(v60);
                local v70 = u7:Clone();
                v70.Name = `Stat_{v62}`;
                v70.LayoutOrder = v62;
                v70.Visible = true;
                local SelectedOptionText2 = v70:FindFirstChild("SelectedOptionText");

                if SelectedOptionText2 and SelectedOptionText2:IsA("TextLabel") then
                    SelectedOptionText2.Text = Label2;
                end;

                local KillsPerMatch2 = v70:FindFirstChild("KillsPerMatch");

                if KillsPerMatch2 and KillsPerMatch2:IsA("TextLabel") then
                    KillsPerMatch2.Text = v69;
                end;

                v70.Parent = u6;
                v70.Visible = v64;
            end;

            if v66:IsA("GuiButton") then
                v66.Active = true;
                v66.Selectable = true;
                ActivateButton(v66);
                local Label2 = v68.Label;
                v66.Activated:Connect(function() -- Line: 427
                    -- upvalues: Router (ref), u11 (ref), Label2 (copy), RenderStats (ref)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    u11[Label2] = u11[Label2] ~= true;
                    RenderStats();
                end);
            end;
        end;
    end;
end;

local function SelectWeapon(p71: string) -- Line: 438
    -- upvalues: u10 (ref), u13 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), RenderStats (copy)
    if u10 == p71 then
        return;
    end;

    local v72 = u10 and u13[u10];

    if v72 then
        v72.BackgroundColor3 = Color3_fromRGB_ret2;
        v72.BackgroundTransparency = 0.3;
    end;

    u10 = p71;
    local v73 = u13[p71];

    if v73 then
        v73.BackgroundColor3 = Color3_fromRGB_ret;
        v73.BackgroundTransparency = 0.05;
    end;

    RenderStats();
end;

local function FocusSelectedRow() -- Line: 460
    -- upvalues: UserInputService (copy), MenuState (copy), u10 (ref), u13 (copy), GuiService (copy)
    if not UserInputService.GamepadEnabled or MenuState.IsNavigationSelectionHeld() then
        return;
    end;

    local v74 = u10;

    if not v74 then
        return;
    end;

    local v75 = u13[v74];

    if not v75 then
        return;
    end;

    local Hitbox = v75:FindFirstChild("Hitbox");

    if Hitbox and (Hitbox:IsA("GuiButton") and Hitbox.Selectable) then
        GuiService.SelectedObject = Hitbox;
    end;
end;

local function BindRowSelection(p76: userdata, u77: string) -- Line: 485
    -- upvalues: Router (copy), u10 (ref), u13 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), RenderStats (copy), ActivateButton (copy)
    local function selectWeapon() -- Line: 486
        -- upvalues: Router (ref), u77 (copy), u10 (ref), u13 (ref), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret (ref), RenderStats (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local v78 = u77;

        if u10 == v78 then
            return;
        end;

        local v79 = u10 and u13[u10];

        if v79 then
            v79.BackgroundColor3 = Color3_fromRGB_ret2;
            v79.BackgroundTransparency = 0.3;
        end;

        u10 = v78;
        local v80 = u13[v78];

        if v80 then
            v80.BackgroundColor3 = Color3_fromRGB_ret;
            v80.BackgroundTransparency = 0.05;
        end;

        RenderStats();
    end;

    local Hitbox = p76:FindFirstChild("Hitbox");
    local Details = p76:FindFirstChild("Details");
    local v81 = nil;

    if Hitbox and Hitbox:IsA("GuiButton") then
        v81 = Hitbox;
    elseif Details then
        if Details:IsA("GuiButton") then
            v81 = Details;
        end;
    end;

    if v81 then
        v81.Active = true;
        v81.Selectable = true;
        ActivateButton(v81);
        v81.Activated:Connect(selectWeapon);
    end;

    if Details and (Details:IsA("GuiButton") and Details ~= v81) then
        Details.Selectable = false;
        Details.Active = true;
        ActivateButton(Details);
        Details.Activated:Connect(selectWeapon);
    end;
end;

local function CreateRow(p82: string, p83: any, p84: number, p85: number) -- Line: 519
    -- upvalues: u4 (ref), WeaponIcon (copy), WeaponCategories (copy), Format (copy), Derive (copy), BindRowSelection (copy), u10 (ref), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u13 (copy), u2 (ref)
    local v86 = u4:Clone();
    v86.Name = `Weapon_{p82}`;
    v86.LayoutOrder = p85;
    v86.Visible = true;
    local ItemIcon = v86:FindFirstChild("ItemIcon");

    if ItemIcon then
        ItemIcon.Image = WeaponIcon.Get(p82);
    end;

    local math_max_ret = math.max(p83.Matches, 0);
    local string_upper_ret = string.upper(p82);
    local Weapon = v86:FindFirstChild("Weapon");

    if Weapon and Weapon:IsA("TextLabel") then
        Weapon.Text = string_upper_ret;
    end;

    local Label = WeaponCategories.GetLabel(p82);
    local Filter = v86:FindFirstChild("Filter");

    if Filter and Filter:IsA("TextLabel") then
        Filter.Text = Label;
    end;

    local v87 = Format.Number(p83.Kills);
    local Kills = v86:FindFirstChild("Kills");

    if Kills and Kills:IsA("TextLabel") then
        Kills.Text = v87;
    end;

    local v88 = Format.Percent(p83.Kills, p84, 1);
    local AllKills = v86:FindFirstChild("AllKills");

    if AllKills and AllKills:IsA("TextLabel") then
        AllKills.Text = v88;
    end;

    local Number = Format.Number;
    local v89 = Derive.Divide(p83.Damage, math_max_ret);
    local v90 = Number((math.round(v89)));
    local DamagePerMatch = v86:FindFirstChild("DamagePerMatch");

    if DamagePerMatch and DamagePerMatch:IsA("TextLabel") then
        DamagePerMatch.Text = v90;
    end;

    local v91 = Format.Decimal(Derive.Divide(p83.Kills, math_max_ret), 1);
    local KillsPerMatch = v86:FindFirstChild("KillsPerMatch");

    if KillsPerMatch and KillsPerMatch:IsA("TextLabel") then
        KillsPerMatch.Text = v91;
    end;

    BindRowSelection(v86, p82);
    local v92 = u10 == p82;
    local v93;

    if v92 then
        v93 = Color3_fromRGB_ret;
    else
        v93 = Color3_fromRGB_ret2;
    end;

    v86.BackgroundColor3 = v93;
    v86.BackgroundTransparency = v92 and 0.05 or 0.3;
    u13[p82] = v86;
    v86.Parent = u2;
end;

local function ClearRows() -- Line: 549
    -- upvalues: u13 (copy), u2 (ref)
    table.clear(u13);

    for _, child in ipairs(u2:GetChildren()) do
        if child:IsA("Frame") and string.sub(child.Name, 1, 7) == "Weapon_" then
            child:Destroy();
        end;
    end;
end;

local function UpdateFilterButtons() -- Line: 561
    -- upvalues: u12 (copy), u9 (ref), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_new_ret (copy), Color3_fromRGB_ret3 (copy)
    for i, v in pairs(u12) do
        local v94 = i == u9;
        local v95;

        if v94 then
            v95 = Color3_fromRGB_ret;
        else
            v95 = Color3_fromRGB_ret2;
        end;

        v.BackgroundColor3 = v95;
        v.BackgroundTransparency = v94 and 0.05 or 0.3;
        local SelectedOptionText = v:FindFirstChild("SelectedOptionText");

        if SelectedOptionText then
            local v96;

            if v94 then
                v96 = Color3_new_ret;
            else
                v96 = Color3_fromRGB_ret3;
            end;

            SelectedOptionText.TextColor3 = v96;
        end;
    end;
end;

local function RenderRows() -- Line: 578
    -- upvalues: u2 (ref), u4 (ref), ClearRows (copy), CareerData (copy), Selection (copy), table_freeze_ret3 (copy), u9 (ref), GetWeaponOrder (copy), WeaponCategories (copy), CreateRow (copy), table_freeze_ret4 (copy), u10 (ref), u13 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), RenderStats (copy), FocusSelectedRow (copy)
    if not (u2 and u4) then
        return;
    end;

    ClearRows();
    local Bucket = CareerData.GetBucket(Selection.Get());
    local v97 = table_freeze_ret3[u9];
    local Kills = Bucket.Kills;

    if Kills <= 0 then
        for _, v in pairs(Bucket.Weapons) do
            Kills = Kills + v.Kills;
        end;
    end;

    local v98 = 0;
    local v99 = nil;

    for _, v in ipairs((GetWeaponOrder(Bucket))) do
        if not v97 or WeaponCategories.GetCategory(v) == v97 then
            v98 = v98 + 1;
            CreateRow(v, Bucket.Weapons[v] or table_freeze_ret4, Kills, v98);
            v99 = v99 or v;
        end;
    end;

    if u10 == nil or not u13[u10] then
        u10 = nil;

        if v99 then
            if u10 ~= v99 then
                local v100 = u10 and u13[u10];

                if v100 then
                    v100.BackgroundColor3 = Color3_fromRGB_ret2;
                    v100.BackgroundTransparency = 0.3;
                end;

                u10 = v99;
                local v101 = u13[v99];

                if v101 then
                    v101.BackgroundColor3 = Color3_fromRGB_ret;
                    v101.BackgroundTransparency = 0.05;
                end;

                RenderStats();
            end;

            FocusSelectedRow();

            return;
        end;
    end;

    RenderStats();
    FocusSelectedRow();
end;

local function SelectFilter(p102: string) -- Line: 623
    -- upvalues: u9 (ref), UpdateFilterButtons (copy), RenderRows (copy)
    if u9 == p102 then
        return;
    end;

    u9 = p102;
    UpdateFilterButtons();
    RenderRows();
end;

function v1.Bind(p103: userdata) -- Line: 636
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), NameStatColumns (copy), u5 (ref), u6 (ref), u7 (ref), u8 (ref), table_freeze_ret3 (copy), u12 (copy), ActivateButton (copy), Router (copy), u9 (ref), UpdateFilterButtons (copy), RenderRows (copy)
    local WeaponStats = p103:FindFirstChild("WeaponStats");

    if not WeaponStats then
        return;
    end;

    u2 = WeaponStats:FindFirstChild("Container");
    u3 = WeaponStats:FindFirstChild("Filters");

    if not (u2 and u3) then
        return;
    end;

    for _, child in ipairs(u2:GetChildren()) do
        if child:IsA("Frame") and child.Name == "Template" then
            if u4 then
                child:Destroy();
            else
                u4 = child;
                child.Visible = false;
                NameStatColumns(child);
            end;
        end;
    end;

    u5 = p103:FindFirstChild("Stats");
    local v104 = u5 and u5:FindFirstChild("Container");
    u6 = v104;

    if u6 then
        u7 = u6:FindFirstChild("Template");
        u8 = u6:FindFirstChild("TemplateDrop");

        if u7 then
            u7.Visible = false;
        end;

        if u8 then
            u8.Visible = false;
        end;
    end;

    for i in pairs(table_freeze_ret3) do
        local v105 = u3:FindFirstChild(i);

        if v105 and v105:IsA("GuiButton") then
            u12[i] = v105;
        end;
    end;

    local Allweapons = u3:FindFirstChild("Allweapons");

    if Allweapons and Allweapons:IsA("GuiButton") then
        u12.Allweapons = Allweapons;
    end;

    for i, v in pairs(u12) do
        ActivateButton(v);
        v.Selectable = true;
        v.Activated:Connect(function() -- Line: 692
            -- upvalues: Router (ref), i (copy), u9 (ref), UpdateFilterButtons (ref), RenderRows (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            local v106 = i;

            if u9 == v106 then
                return;
            end;

            u9 = v106;
            UpdateFilterButtons();
            RenderRows();
        end);
    end;

    UpdateFilterButtons();
end;

function v1.Render() -- Line: 703
    -- upvalues: RenderRows (copy)
    RenderRows();
end;

return v1;