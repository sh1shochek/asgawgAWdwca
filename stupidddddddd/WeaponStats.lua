-- ReplicatedStorage.Interface.Screens.Menu.Career.WeaponStats
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.WeaponStats
-- Decompile time: 11.54 ms

local RenderStats
local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
require(script.Parent.Types)
local Format = require(script.Parent.Format)
local Derive = require(script.Parent.Derive)
local Selection = require(script.Parent.Selection)
local CareerData = require(script.Parent.CareerData)
local WeaponIcon = require(script.Parent.WeaponIcon)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local Router = require(ReplicatedStorage.Database.Security.Router)
local WeaponCategories = require(ReplicatedStorage.Database.Custom.GameStats.WeaponCategories)
local u73 = table.freeze({"Kills", "AllKills", "DamagePerMatch", "KillsPerMatch"})
local u76 = table.freeze({Weapon = true, Filter = true})
local u79 = table.freeze({
    Rifle = "Rifle",
    SMG = "SMG",
    Pistols = "Pistol",
    Shotguns = "Shotgun",
    Snipers = "Sniper",
    Melee = "Melee",
    Special = "Special",
})
local u84 = Color3.fromRGB(66, 66, 66)
local u89 = Color3.new(1, 1, 1)
local u94 = Color3.fromRGB(32, 32, 32)
local u99 = Color3.fromRGB(158, 158, 158)
local u102 = table.freeze({
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
    Inspects = 0,
})
local u103 = nil
local u104 = nil
local u105 = nil
local u106 = nil
local u107 = nil
local u108 = nil
local u109 = nil
local u110 = "Allweapons"
local u111 = nil
local u112 = {}
local u113 = {}
local u114 = {}

local function RoundGroup(a1, a2, a3) -- Line: 119
    -- upvalues: Format (val)
    return {
        Label = a1,
        Read = function(a1) -- Line: 122 -- upvalues: Format (upval), a2 (val)
            return Format.Number(a1[a2])
        end,
        Children = {
            {
                Label = "ROUNDS WON",
                Read = function(a1) -- Line: 128 -- upvalues: Format (upval), a3 (val)
                    return Format.Number(a1[a3])
                end,
            },
            {
                Label = "ROUNDS LOST",
                Read = function(a1) -- Line: 134 -- upvalues: Format (upval), a2 (val), a3 (val)
                    return Format.Number((math.max(a1[a2] - a1[a3], 0)))
                end,
            },
            {
                Label = "WIN %",
                Read = function(a1) -- Line: 140 -- upvalues: Format (upval), a3 (val), a2 (val)
                    return Format.Percent(a1[a3], a1[a2], 1)
                end,
            },
        },
    }
end

local u116 = {}
local v2 = RoundGroup("ROUNDS PLAYED", "RoundsPlayed", "RoundsWon")
local v3 = RoundGroup("RANKED ROUNDS PLAYED", "RankedRoundsPlayed", "RankedRoundsWon")
local v4 = {
    Label = "KILLS",
    Read = function(a1) -- Line: 153 -- upvalues: Format (val)
        return Format.Number(a1.Kills)
    end,
    Children = {
        {
            Label = "WHILE CROUCHING",
            Read = function(a1) -- Line: 159 -- upvalues: Format (val)
                return Format.Number(a1.CrouchKills)
            end,
        },
        {
            Label = "WHILE JUMPING",
            Read = function(a1) -- Line: 165 -- upvalues: Format (val)
                return Format.Number(a1.JumpKills)
            end,
        },
        {
            Label = "WHILE BLIND",
            Read = function(a1) -- Line: 171 -- upvalues: Format (val)
                return Format.Number(a1.BlindKills)
            end,
        },
    },
}
local v5 = {
    Label = "DAMAGE DEALT",
    Read = function(a1) -- Line: 179 -- upvalues: Format (val)
        return Format.Number(a1.Damage)
    end,
    Children = {
        {
            Label = "WHILE CROUCHING",
            Read = function(a1) -- Line: 185 -- upvalues: Format (val)
                return Format.Number(a1.CrouchDamage)
            end,
        },
        {
            Label = "WHILE JUMPING",
            Read = function(a1) -- Line: 191 -- upvalues: Format (val)
                return Format.Number(a1.JumpDamage)
            end,
        },
        {
            Label = "WHILE BLIND",
            Read = function(a1) -- Line: 197 -- upvalues: Format (val)
                return Format.Number(a1.BlindDamage)
            end,
        },
    },
}
local v6 = {
    Label = "ASSISTS",
    Read = function(a1) -- Line: 205 -- upvalues: Format (val)
        return Format.Number(a1.Assists)
    end,
    Children = {
        {
            Label = "WHILE DEAD",
            Read = function(a1) -- Line: 211 -- upvalues: Format (val)
                return Format.Number(a1.DeadAssists)
            end,
        },
    },
}
local v7 = {
    Label = "BULLETS SHOT",
    Read = function(a1) -- Line: 219 -- upvalues: Format (val)
        return Format.Number(a1.ShotsFired)
    end,
    Children = {
        {
            Label = "HITS",
            Read = function(a1) -- Line: 225 -- upvalues: Format (val)
                return Format.Number(a1.ShotsHit)
            end,
        },
        {
            Label = "HIT %",
            Read = function(a1) -- Line: 231 -- upvalues: Format (val)
                return Format.Percent(a1.ShotsHit, a1.ShotsFired, 1)
            end,
        },
        {
            Label = "HEADSHOTS",
            Read = function(a1) -- Line: 237 -- upvalues: Format (val)
                return Format.Number(a1.HeadshotHits)
            end,
        },
        {
            Label = "HEADSHOT %",
            Read = function(a1) -- Line: 243 -- upvalues: Format (val)
                return Format.Percent(a1.HeadshotHits, a1.ShotsHit, 1)
            end,
        },
    },
}
local v8 = {
    Label = "INSPECTS",
    Read = function(a1) -- Line: 251 -- upvalues: Format (val)
        return Format.Number(a1.Inspects)
    end,
    Children = {},
}
local v9 = {
    Label = "RELOADS",
    Read = function(a1) -- Line: 258 -- upvalues: Format (val)
        return Format.Number(a1.Reloads)
    end,
    Children = {},
}
u116[1] = v2
u116[2] = v3
u116[3] = v4
u116[4] = v5
u116[5] = v6
u116[6] = v7
u116[7] = v8
u116[8] = v9

local function GetWeapon(a1) -- Line: 268
    -- upvalues: u102 (val), CareerData (val), Selection (val)
    if not a1 then
        return u102
    end
    return CareerData.GetBucket(Selection.Get()).Weapons[a1] or u102
end

local function GetWeaponOrder(a1) -- Line: 278 -- upvalues: WeaponCategories (val)
    local v1 = table.clone(WeaponCategories.GetWeapons())
    local v2 = {}
    for i, v in ipairs(v1) do
        v2[v] = true
    end
    local v3 = {}
    for k, i2 in pairs(a1.Weapons) do
        if not v2[k] then
            if 0 < i2.Kills or 0 < i2.Damage then
                table.insert(v3, k)
            end
        end
    end
    table.sort(v3)
    for i3, j in ipairs(v3) do
        table.insert(v1, j)
    end
    return v1
end

local function NameStatColumns(a1) -- Line: 303 -- upvalues: u76 (val), u73 (val) -- types: a1: userdata
    local v1 = {}
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("TextLabel") and not u76[v.Name] then
            table.insert(v1, v)
        end
    end
    if #v1 ~= #u73 then
        return
    end
    table.sort(v1, function(a1, a2) -- Line: 315 -- types: a1: userdata, a2: userdata
        return a1.Position.X.Scale < a2.Position.X.Scale
    end)
    for i2, i3 in ipairs(v1) do
        i3.Name = u73[i2]
    end
end

local function SetColumn(a1, a2, a3) -- Line: 326 -- types: a1: userdata, a2: string, a3: string
    local v1 = a1:FindFirstChild(a2)
    if v1 and v1:IsA("TextLabel") then
        v1.Text = a3
    end
end

local function PaintRow(a1, a2) -- Line: 335 -- upvalues: u84 (val), u94 (val) -- types: a1: userdata, a2: boolean
    a1.BackgroundColor3 = if not a2 then u94 else u84
    a1.BackgroundTransparency = if not a2 then 0.3 else 0.05
end

local function AddStatRow(a1, a2, a3, a4) -- Line: 345
    -- upvalues: u107 (ref)
    local v1 = a1:Clone()
    v1.Name = ("Stat_%*"):format(a4)
    v1.LayoutOrder = a4
    v1.Visible = true
    local SelectedOptionText = v1:FindFirstChild("SelectedOptionText")
    if SelectedOptionText and SelectedOptionText:IsA("TextLabel") then
        SelectedOptionText.Text = a2
    end
    local KillsPerMatch = v1:FindFirstChild("KillsPerMatch")
    if KillsPerMatch and KillsPerMatch:IsA("TextLabel") then
        KillsPerMatch.Text = a3
    end
    v1.Parent = u107
    return v1
end

local function ClearStatRows() -- Line: 360 -- upvalues: u107 (ref)
    for i, v in ipairs(u107:GetChildren()) do
        if string.sub(v.Name, 1, 5) == "Stat_" then
            v:Destroy()
        end
    end
end

function RenderStats() -- Line: 370
    -- upvalues: u107 (ref), u108 (ref), u109 (ref), ClearStatRows (val), u111 (ref), u102 (val), CareerData (val)
    -- upvalues: Selection (val), u106 (ref), u116 (val), u112 (val), ActivateButton (val), Router (val)
    -- upvalues: RenderStats (val)
    if u107 and u108 and u109 then
        local ImageLabel, KillsPerMatch, KillsPerMatch_2, Label_2, Label_3, SelectedOptionText, SelectedOptionText_2, v1, v2, v3, v4, v5, v6, v7, v8
        ClearStatRows()
        local v9 = u111
        local v10 = v9 and CareerData.GetBucket(Selection.Get()).Weapons[v9] or u102
        local Title = u106 and u106:FindFirstChild("Title")
        local Title_2 = Title and Title:FindFirstChild("Title")
        if Title_2 then
            Title_2.Text = if not v9 then "STATS" else ("%* STATS"):format((string.upper(v9)))
        end
        local Empty = u107:FindFirstChild("Empty")
        if Empty and Empty:IsA("GuiObject") then
            Empty.Visible = v9 == nil
        end
        if not v9 then
            return
        end
        local v11 = 0
        for i, v in ipairs(u116) do
            v11 = v11 + 1
            v2 = #v.Children > 0 and u112[v.Label] == true
            v4 = u109
            Label_3 = v.Label
            v5 = v.Read(v10)
            v3 = v4:Clone()
            v3.Name = ("Stat_%*"):format(v11)
            v3.LayoutOrder = v11
            v3.Visible = true
            SelectedOptionText = v3:FindFirstChild("SelectedOptionText")
            if SelectedOptionText and SelectedOptionText:IsA("TextLabel") then
                SelectedOptionText.Text = Label_3
            end
            KillsPerMatch = v3:FindFirstChild("KillsPerMatch")
            if KillsPerMatch and KillsPerMatch:IsA("TextLabel") then
                KillsPerMatch.Text = v5
            end
            v3.Parent = u107
            ImageLabel = v3:FindFirstChildWhichIsA("ImageLabel")
            if ImageLabel then
                ImageLabel.Visible = v1
                ImageLabel.Rotation = if not v2 then 180 else 0
            end
            if v1 then
                for i2, i3 in ipairs(v.Children) do
                    v11 = v11 + 1
                    v7 = u108
                    Label_2 = i3.Label
                    v8 = i3.Read(v10)
                    v6 = v7:Clone()
                    v6.Name = ("Stat_%*"):format(v11)
                    v6.LayoutOrder = v11
                    v6.Visible = true
                    SelectedOptionText_2 = v6:FindFirstChild("SelectedOptionText")
                    if SelectedOptionText_2 and SelectedOptionText_2:IsA("TextLabel") then
                        SelectedOptionText_2.Text = Label_2
                    end
                    KillsPerMatch_2 = v6:FindFirstChild("KillsPerMatch")
                    if KillsPerMatch_2 and KillsPerMatch_2:IsA("TextLabel") then
                        KillsPerMatch_2.Text = v8
                    end
                    v6.Parent = u107
                    v6.Visible = v2
                end
                if v3:IsA("GuiButton") then
                    v3.Active = true
                    v3.Selectable = true
                    ActivateButton(v3)
                    local Label = v.Label
                    v3.Activated:Connect(function() -- Line: 427 -- upvalues: Router (upval), u112 (upval), Label (val), RenderStats (upval)
                        Router.broadcastRouter("RunInterfaceSound", "UI Click")
                        u112[Label] = not (u112[Label] == true)
                        RenderStats()
                    end)
                end
            end
        end
        return
    end
end

local function SelectWeapon(a1) -- Line: 438
    -- upvalues: u111 (ref), u114 (val), u94 (val), u84 (val), RenderStats (val)
    if u111 == a1 then
        return
    end
    local v1 = u111 and u114[u111]
    if v1 then
        v1.BackgroundColor3 = u94
        v1.BackgroundTransparency = 0.3
    end
    u111 = a1
    local v2 = u114[a1]
    if v2 then
        v2.BackgroundColor3 = u84
        v2.BackgroundTransparency = 0.05
    end
    RenderStats()
end

local function FocusSelectedRow() -- Line: 460
    -- upvalues: UserInputService (val), MenuState (val), u111 (ref), u114 (val), GuiService (val)
    if UserInputService.GamepadEnabled and not MenuState.IsNavigationSelectionHeld() then
        local v1 = u111
        if not v1 then
            return
        end
        local v2 = u114[v1]
        if not v2 then
            return
        end
        local Hitbox = v2:FindFirstChild("Hitbox")
        if Hitbox and Hitbox:IsA("GuiButton") and Hitbox.Selectable then
            GuiService.SelectedObject = Hitbox
        end
        return
    end
end

local function BindRowSelection(a1, a2) -- Line: 485
    -- upvalues: Router (val), u111 (ref), u114 (val), u94 (val), u84 (val), RenderStats (val), ActivateButton (val)
    local function selectWeapon() -- Line: 486
        -- upvalues: Router (upval), a2 (val), u111 (upval), u114 (upval), u94 (upval), u84 (upval), RenderStats (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        local v1 = a2
        if u111 == v1 then
            return
        end
        local v2 = u111 and u114[u111]
        if v2 then
            v2.BackgroundColor3 = u94
            v2.BackgroundTransparency = 0.3
        end
        u111 = v1
        local v3 = u114[v1]
        if v3 then
            v3.BackgroundColor3 = u84
            v3.BackgroundTransparency = 0.05
        end
        RenderStats()
    end

    local Hitbox = a1:FindFirstChild("Hitbox")
    local Details = a1:FindFirstChild("Details")
    local v1 = nil
    if not Hitbox then
        if Details and Details:IsA("GuiButton") then
            v1 = Details
        end
    elseif Hitbox:IsA("GuiButton") then
        v1 = Hitbox
    elseif Details and Details:IsA("GuiButton") then
        v1 = Details
    end
    if v1 then
        v1.Active = true
        v1.Selectable = true
        ActivateButton(v1)
        v1.Activated:Connect(selectWeapon)
    end
    if Details and Details:IsA("GuiButton") and Details ~= v1 then
        Details.Selectable = false
        Details.Active = true
        ActivateButton(Details)
        Details.Activated:Connect(selectWeapon)
    end
end

local function CreateRow(a1, a2, a3, a4) -- Line: 519
    -- upvalues: u105 (ref), WeaponIcon (val), WeaponCategories (val), Format (val), Derive (val)
    -- upvalues: BindRowSelection (val), u111 (ref), u84 (val), u94 (val), u114 (val), u103 (ref)
    local v1 = u105:Clone()
    v1.Name = ("Weapon_%*"):format(a1)
    v1.LayoutOrder = a4
    v1.Visible = true
    local ItemIcon = v1:FindFirstChild("ItemIcon")
    if ItemIcon then
        ItemIcon.Image = WeaponIcon.Get(a1)
    end
    local v2 = math.max(a2.Matches, 0)
    local v3 = string.upper(a1)
    local Weapon = v1:FindFirstChild("Weapon")
    if Weapon and Weapon:IsA("TextLabel") then
        Weapon.Text = v3
    end
    v3 = WeaponCategories.GetLabel(a1)
    local Filter = v1:FindFirstChild("Filter")
    if Filter and Filter:IsA("TextLabel") then
        Filter.Text = v3
    end
    v3 = Format.Number(a2.Kills)
    local Kills = v1:FindFirstChild("Kills")
    if Kills and Kills:IsA("TextLabel") then
        Kills.Text = v3
    end
    v3 = Format.Percent(a2.Kills, a3, 1)
    local AllKills = v1:FindFirstChild("AllKills")
    if AllKills and AllKills:IsA("TextLabel") then
        AllKills.Text = v3
    end
    v3 = Format.Number((math.round((Derive.Divide(a2.Damage, v2)))))
    local DamagePerMatch = v1:FindFirstChild("DamagePerMatch")
    if DamagePerMatch and DamagePerMatch:IsA("TextLabel") then
        DamagePerMatch.Text = v3
    end
    v3 = Format.Decimal(Derive.Divide(a2.Kills, v2), 1)
    local KillsPerMatch = v1:FindFirstChild("KillsPerMatch")
    if KillsPerMatch and KillsPerMatch:IsA("TextLabel") then
        KillsPerMatch.Text = v3
    end
    BindRowSelection(v1, a1)
    v1.BackgroundColor3 = if not (u111 == a1) then u94 else u84
    v1.BackgroundTransparency = if not v3 then 0.3 else 0.05
    u114[a1] = v1
    v1.Parent = u103
end

local function ClearRows() -- Line: 549 -- upvalues: u114 (val), u103 (ref)
    table.clear(u114)
    for i, v in ipairs(u103:GetChildren()) do
        if v:IsA("Frame") and string.sub(v.Name, 1, 7) == "Weapon_" then
            v:Destroy()
        end
    end
end

local function UpdateFilterButtons() -- Line: 561
    -- upvalues: u113 (val), u110 (ref), u84 (val), u94 (val), u89 (val), u99 (val)
    local SelectedOptionText, v1, v2
    for k, v in pairs(u113) do
        v2 = if not (k == u110) then u94 else u84
        v.BackgroundColor3 = v2
        v.BackgroundTransparency = if not v1 then 0.3 else 0.05
        SelectedOptionText = v:FindFirstChild("SelectedOptionText")
        if SelectedOptionText then
            SelectedOptionText.TextColor3 = if not v1 then u99 else u89
        end
    end
end

local function RenderRows() -- Line: 578
    -- upvalues: u103 (ref), u105 (ref), ClearRows (val), CareerData (val), Selection (val), u79 (val), u110 (ref)
    -- upvalues: GetWeaponOrder (val), WeaponCategories (val), CreateRow (val), u102 (val), u111 (ref), u114 (val)
    -- upvalues: u94 (val), u84 (val), RenderStats (val), FocusSelectedRow (val)
    if u103 and u105 then
        local v1
        ClearRows()
        local v2 = CareerData.GetBucket(Selection.Get())
        local v3 = u79[u110]
        local Kills = v2.Kills
        if Kills <= 0 then
            for k, v in pairs(v2.Weapons) do
                Kills = Kills + v.Kills
            end
        end
        local v4 = 0
        local v5 = nil
        for i, i2 in ipairs((GetWeaponOrder(v2))) do
            if not v3 or WeaponCategories.GetCategory(i2) == v3 then
                v4 = v4 + 1
                v5 = v5 or i2
                v1 = v2.Weapons[i2] or u102
                CreateRow(i2, v1, Kills, v4)
            end
        end
        if u111 ~= nil and u114[u111] then
            RenderStats()
            FocusSelectedRow()
            return
        end
        u111 = nil
        if not v5 then
            RenderStats()
            FocusSelectedRow()
            return
        end
        if u111 ~= v5 then
            local v6 = u111 and u114[u111]
            if v6 then
                v6.BackgroundColor3 = u94
                v6.BackgroundTransparency = 0.3
            end
            u111 = v5
            local v7 = u114[v5]
            if v7 then
                v7.BackgroundColor3 = u84
                v7.BackgroundTransparency = 0.05
            end
            RenderStats()
        end
        FocusSelectedRow()
        return
    end
end

local function SelectFilter(a1) -- Line: 623
    -- upvalues: u110 (ref), UpdateFilterButtons (val), RenderRows (val)
    if u110 == a1 then
        return
    end
    u110 = a1
    UpdateFilterButtons()
    RenderRows()
end

function v1.Bind(a1) -- Line: 636
    -- upvalues: u103 (ref), u104 (ref), u105 (ref), NameStatColumns (val), u106 (ref), u107 (ref), u108 (ref)
    -- upvalues: u109 (ref), u79 (val), u113 (val), ActivateButton (val), Router (val), u110 (ref)
    -- upvalues: UpdateFilterButtons (val), RenderRows (val)
    local WeaponStats = a1:FindFirstChild("WeaponStats")
    if not WeaponStats then
        return
    end
    u103 = WeaponStats:FindFirstChild("Container")
    u104 = WeaponStats:FindFirstChild("Filters")
    if u103 and u104 then
        local v1
        for i, v in ipairs(u103:GetChildren()) do
            if v:IsA("Frame") and v.Name == "Template" then
                if not u105 then
                    u105 = v
                    v.Visible = false
                    NameStatColumns(v)
                else
                    v:Destroy()
                end
            end
        end
        u106 = a1:FindFirstChild("Stats")
        u107 = u106 and u106:FindFirstChild("Container")
        if u107 then
            u108 = u107:FindFirstChild("Template")
            u109 = u107:FindFirstChild("TemplateDrop")
            if u108 then
                u108.Visible = false
            end
            if u109 then
                u109.Visible = false
            end
        end
        for k in pairs(u79) do
            v1 = u104:FindFirstChild(k)
            if v1 and v1:IsA("GuiButton") then
                u113[k] = v1
            end
        end
        local Allweapons = u104:FindFirstChild("Allweapons")
        if Allweapons and Allweapons:IsA("GuiButton") then
            u113.Allweapons = Allweapons
        end
        for k2, i2 in pairs(u113) do
            ActivateButton(i2)
            i2.Selectable = true
            i2.Activated:Connect(function() -- Line: 692
                -- upvalues: Router (upval), k2 (val), u110 (upval), UpdateFilterButtons (upval), RenderRows (upval)
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                local v1 = k2
                if u110 == v1 then
                    return
                end
                u110 = v1
                UpdateFilterButtons()
                RenderRows()
            end)
        end
        UpdateFilterButtons()
        return
    end
end

function v1.Render() -- Line: 703 -- upvalues: RenderRows (val)
    RenderRows()
end

return v1