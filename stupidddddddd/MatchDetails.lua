-- ReplicatedStorage.Interface.Screens.Menu.Career.MatchDetails
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.MatchDetails
-- Decompile time: 35.39 ms

local RenderPerformance
local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Types)
local Format = require(script.Parent.Format)
local Derive = require(script.Parent.Derive)
local MapIcon = require(script.Parent.MapIcon)
local CareerData = require(script.Parent.CareerData)
local WeaponIcon = require(script.Parent.WeaponIcon)
local LocalPlayer = Players.LocalPlayer
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Router = require(ReplicatedStorage.Database.Security.Router)
local u59 = {}
u59.Base = Color3.fromRGB(32, 108, 23)
u59.Cell = Color3.fromRGB(87, 255, 93)
local u70 = {}
u70.Base = Color3.fromRGB(89, 9, 9)
u70.Cell = Color3.fromRGB(255, 53, 53)
local u81 = {}
u81.Base = Color3.fromRGB(108, 95, 23)
u81.Cell = Color3.fromRGB(255, 236, 87)
local u100 = table.freeze({"CombatScore", "Econ", "Plants", "Kills", "Assists", "Assist"})
local u105 = Color3.fromRGB(165, 183, 212)
local u110 = Color3.fromRGB(219, 199, 126)
local u115 = Color3.fromRGB(95, 95, 95)
local u120 = Color3.fromRGB(88, 245, 82)
local u125 = Color3.fromRGB(195, 20, 20)
local u128 = table.freeze({Kill = true, Death = true})
local u133 = Color3.new(1, 1, 1)
local u138 = Color3.fromRGB(158, 158, 158)
local u143 = Color3.fromRGB(219, 43, 43)
local u148 = Color3.new(1, 1, 1)
local u151 = table.freeze({
    BombDefuse = "rbxassetid://138772806705472",
    BombExplode = "rbxassetid://97682949239067",
    BombObjective = "rbxassetid://97682949239067",
    Elimination = "rbxassetid://70876442749327",
    TimeExpiration = "rbxassetid://96043369049959",
    HostageRescue = "rbxassetid://138772806705472",
})
local u160 = table.freeze({
    Sort_CombatScore = function(a1) -- Line: 110 -- upvalues: Derive (val)
        return Derive.Divide(a1.CombatScore, a1.RoundsPlayed)
    end,
    Sort_KDA = function(a1) -- Line: 113
        return a1.Kills - a1.Deaths
    end,
    Sort_Econ = function(a1) -- Line: 116 -- upvalues: Derive (val)
        return Derive.EconomyRating(a1.DamageDealt, a1.MoneySpent)
    end,
    Sort_FirstBloods = function(a1) -- Line: 119
        return a1.FirstBloods
    end,
    Sort_Plants = function(a1) -- Line: 122
        return a1.Plants
    end,
    Sort_Defuses = function(a1, a2) -- Line: 125 -- types: a2: boolean
        if a2 then
            return a1.Rescues
        end
        return a1.Defuses
    end,
})
local u161 = nil
local u162 = nil
local u163 = nil
local u164 = nil
local u165 = nil
local u166 = nil
local u167 = nil
local u168 = nil
local u169 = nil
local u170 = nil
local u171 = nil
local u172 = nil
local u173 = nil
local u174 = "Scoreboard"
local u175 = 1
local u176 = {}
local u177 = "Sort_CombatScore"
local u178 = true
local u179 = {}
local u180 = {}

local function TeamColor(a1) -- Line: 163 -- upvalues: u105 (val), u110 (val) -- types: a1: string
    if a1 == "Counter-Terrorists" then
        return u105
    end
    return u110
end

local function SetText(a1, a2, a3) -- Line: 169 -- types: a1: userdata?, a2: string, a3: string
    local v1 = a1 and a1:FindFirstChild(a2)
    if v1 and v1:IsA("TextLabel") then
        v1.Text = a3
    end
end

local function WeaponName(a1) -- Line: 179 -- types: a1: string?
    if a1 ~= nil and a1 ~= "" then
        return string.upper(a1)
    end
    return ""
end

local function SetAmount(a1, a2, a3) -- Line: 188 -- types: a1: userdata, a2: string, a3: string
    local v1 = a1:FindFirstChild(a2)
    local Amount = v1 and v1:FindFirstChild("Amount")
    if Amount and Amount:IsA("TextLabel") then
        Amount.Text = a3
        return
    end
    if v1 and v1:IsA("TextLabel") then
        v1.Text = a3
    end
end

local function ResolveAvatarUserId(a1) -- Line: 201 -- upvalues: u173 (ref) -- types: a1: number
    local v1 = u173
    if v1 then
        for i, v in ipairs(v1.Players) do
            if v.UserId == a1 and 0 < v.AvatarUserId then
                return v.AvatarUserId
            end
        end
    end
    return a1
end

local function ApplyAvatar(a1, a2) -- Line: 214
    -- upvalues: ResolveAvatarUserId (val)
    if not a1 then
        return
    end
    local v1 = ResolveAvatarUserId(a2)
    local v2 = a1
    if not a1:IsA("ImageLabel") and not a1:IsA("ImageButton") then
        v2 = a1:FindFirstChild("Avatar") or a1:FindFirstChildWhichIsA("ImageLabel", true)
    end
    if v2 then
        if v2:IsA("ImageLabel") or v2:IsA("ImageButton") then
            v2.Image = if not (v1 > 0) then "" else ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(v1)
        end
    end
end

local function SetAvatar(a1, a2, a3) -- Line: 235
    -- upvalues: ApplyAvatar (val)
    ApplyAvatar(a1:FindFirstChild(a2), a3)
end

local function PaintPlayerRow(a1, a2) -- Line: 242 -- upvalues: u100 (val) -- types: a1: userdata, a2: table
    local v1
    if a1:IsA("GuiObject") then
        a1.BackgroundColor3 = a2.Base
    end
    local v2, v3 = a1, a2
    for i, v in ipairs(a1:GetChildren()) do
        if v.Name ~= "Frame" then
            if v.Name == "Pattern" then
                if v:IsA("ImageLabel") then
                    v.ImageColor3 = v3.Base
                end
                for i2, i3 in ipairs(v:GetDescendants()) do
                    if i3:IsA("ImageLabel") then
                        i3.ImageColor3 = v3.Base
                    end
                end
            end
        elseif not v:IsA("GuiObject") then
            if v.Name == "Pattern" then
                if v:IsA("ImageLabel") then
                    v.ImageColor3 = v3.Base
                end
                for i4, j in ipairs(v:GetDescendants()) do
                    if j:IsA("ImageLabel") then
                        j.ImageColor3 = v3.Base
                    end
                end
            end
        elseif v.BackgroundTransparency < 1 then
            v.BackgroundColor3 = v3.Base
        elseif v.Name == "Pattern" then
            if v:IsA("ImageLabel") then
                v.ImageColor3 = v3.Base
            end
            for i5, k in ipairs(v:GetDescendants()) do
                if k:IsA("ImageLabel") then
                    k.ImageColor3 = v3.Base
                end
            end
        end
    end
    for i6, n in ipairs(u100) do
        v1 = v2:FindFirstChild(n)
        if v1 and v1:IsA("GuiObject") and v1.BackgroundTransparency < 1 then
            v1.BackgroundColor3 = v3.Cell
        end
    end
end

local function PaletteFor(a1, a2, a3) -- Line: 272
    -- upvalues: LocalPlayer (val), u81 (val), u59 (val), u70 (val)
    if a1 == LocalPlayer.UserId then
        return u81
    end
    if a2 == a3 then
        return u59
    end
    return u70
end

local function GetBadgeImage(a1, a2) -- Line: 281 -- upvalues: Skins (val) -- types: a1: string, a2: number
    if a1 == "" then
        return ""
    end
    local v1 = Skins.GetSkinInformation("Badge", a1)
    if not v1 then
        return ""
    end
    return Skins.GetWearImageForFloat(v1, a2) or v1.imageAssetId or ""
end

local function ClearRows(a1) -- Line: 296 -- types: a1: userdata
    for i, v in ipairs(a1:GetChildren()) do
        if string.sub(v.Name, 1, 4) == "Row_" then
            v:Destroy()
        end
    end
end

local function CloneRow(a1, a2, a3) -- Line: 306 -- types: a1: userdata, a2: userdata, a3: number
    local v1 = a1:Clone()
    v1.Name = ("Row_%*"):format(a3)
    v1.LayoutOrder = a3
    v1.Visible = true
    v1.Parent = a2
    return v1
end

function u0.ApplyStatus(a1, a2) -- Line: 319 -- types: a1: userdata, a2: string
    local v1, v2
    a1.TextColor3 = Color3.new(1, 1, 1)
    if a2 == "Victory" then
        a1.Text = "VICTORY"
        v1 = Color3.fromRGB(88, 245, 82)
        v2 = Color3.fromRGB(53, 213, 48)
    elseif a2 ~= "Defeat" then
        a1.Text = "DRAW"
        v1 = Color3.fromRGB(224, 214, 148)
        v2 = Color3.fromRGB(176, 170, 138)
    else
        a1.Text = "DEFEAT"
        v1 = Color3.fromRGB(255, 26, 26)
        v2 = Color3.fromRGB(255, 55, 55)
    end
    local UIGradient = a1:FindFirstChildOfClass("UIGradient")
    if UIGradient then
        UIGradient.Color = ColorSequence.new(v1, v2)
        return
    end
    a1.TextColor3 = v1
end

local function PopulateHeader(a1) -- Line: 348 -- upvalues: u161 (ref), Format (val), MapIcon (val), u0 (val)
    local v1
    local CTScore = if not (a1.Team == "Counter-Terrorists") then a1.TScore else a1.CTScore
    local TScore = if not v1 then a1.CTScore else a1.TScore
    local v2 = u161
    local v3 = tostring(CTScore)
    local YourScore = v2 and v2:FindFirstChild("YourScore")
    if YourScore and YourScore:IsA("TextLabel") then
        YourScore.Text = v3
    end
    v2 = u161
    v3 = tostring(TScore)
    local EnemyScore = v2 and v2:FindFirstChild("EnemyScore")
    if EnemyScore and EnemyScore:IsA("TextLabel") then
        EnemyScore.Text = v3
    end
    v2 = u161
    v3 = Format.Duration(a1.Duration)
    local Timer = v2 and v2:FindFirstChild("Timer")
    if Timer and Timer:IsA("TextLabel") then
        Timer.Text = v3
    end
    v2 = u161
    v3 = ("%* | %*"):format(a1.ServerGamemode, a1.Map)
    local Gamemode = v2 and v2:FindFirstChild("Gamemode")
    if Gamemode and Gamemode:IsA("TextLabel") then
        Gamemode.Text = v3
    end
    local Icon = u161:FindFirstChild("Icon")
    if Icon and Icon:IsA("ImageLabel") then
        Icon.Image = MapIcon.Get(a1.Map)
    end
    local ImageButton = u161:FindFirstChild("ImageButton")
    if ImageButton and ImageButton:IsA("ImageButton") then
        ImageButton.Image = MapIcon.Get(a1.Map)
    end
    local Victory = u161:FindFirstChild("Victory")
    local Defeat = u161:FindFirstChild("Defeat")
    local v4 = a1.Result == "Defeat"
    if Victory then
        Victory.Visible = not v4
        if not v4 then
            u0.ApplyStatus(Victory, a1.Result)
        end
    end
    if Defeat then
        Defeat.Visible = v4
        if v4 then
            u0.ApplyStatus(Defeat, a1.Result)
        end
    end
end

local function SortPlayers(a1, a2) -- Line: 392 -- upvalues: u160 (val), u177 (ref), u178 (ref) -- types: a2: boolean
    local v1 = table.clone(a1.Players)
    local u7 = u160[u177]
    table.sort(v1, function(a1, a2_2) -- Line: 396 -- upvalues: u7 (val), u178 (upval), a2 (val)
        local v1, v2
        if not u7 then
            v1 = string.lower(a1.DisplayName)
            v2 = string.lower(a2_2.DisplayName)
            if v1 == v2 then
                return a1.UserId < a2_2.UserId
            end
            if u178 then
                return v2 < v1
            end
            return v1 < v2
        end
        v1 = u7(a1, a2)
        v2 = u7(a2_2, a2)
        if v1 == v2 then
            return a2_2.Kills < a1.Kills
        end
        if u178 then
            return v2 < v1
        end
        return v1 < v2
    end)
    return v1
end

local function UpdateColumnHeadings() -- Line: 419 -- upvalues: u179 (val), u177 (ref), u133 (val), u138 (val)
    local v1
    for k, v in pairs(u179) do
        v1 = if k ~= u177 then u138 else u133
        v.TextColor3 = v1
    end
end

local function PopulateScoreboard(a1) -- Line: 427
    -- upvalues: u163 (ref), u167 (ref), ClearRows (val), u160 (val), u177 (ref), u178 (ref), ApplyAvatar (val)
    -- upvalues: Skins (val), Format (val), Derive (val), PaintPlayerRow (val), LocalPlayer (val), u81 (val), u59 (val)
    -- upvalues: u70 (val)
    local Main = u163 and u163:FindFirstChild("Main")
    local Main_2 = Main and Main:FindFirstChild("Main")
    if Main_2 and u167 then
        local Amount, Amount_2, Amount_3, Amount_4, Amount_5, Amount_6, Badge, BadgeFloat, BadgeSkin, CombatScore, Defuses, Econ, FirstBloods, KDA, Plants, PlayerName, Team, Team_2, UserId, UserId_2, imageAssetId, v1, v2, v3, v4, v5, v6
        ClearRows(Main_2)
        local u459 = a1.Gamemode == "Hostage Rescue"
        local v7 = table.clone(a1.Players)
        local u29 = u160[u177]
        table.sort(v7, function(a1, a2) -- Line: 396 -- upvalues: u29 (val), u178 (upval), u459 (val)
            local v1, v2
            if not u29 then
                v1 = string.lower(a1.DisplayName)
                v2 = string.lower(a2.DisplayName)
                if v1 == v2 then
                    return a1.UserId < a2.UserId
                end
                if u178 then
                    return v2 < v1
                end
                return v1 < v2
            end
            v1 = u29(a1, u459)
            v2 = u29(a2, u459)
            if v1 == v2 then
                return a2.Kills < a1.Kills
            end
            if u178 then
                return v2 < v1
            end
            return v1 < v2
        end)
        for i, v in ipairs(v7) do
            v1 = u167:Clone()
            v1.Name = ("Row_%*"):format(i)
            v1.LayoutOrder = i
            v1.Visible = true
            v1.Parent = Main_2
            v2 = ("%* (@%*)"):format(v.DisplayName, v.Username)
            v3 = if not v.Disconnected then v2 else ("%* (LEFT)"):format(v2)
            PlayerName = v1 and v1:FindFirstChild("PlayerName")
            if PlayerName and PlayerName:IsA("TextLabel") then
                PlayerName.Text = v3
            end
            UserId = v.UserId
            ApplyAvatar(v1:FindFirstChild("Player"), UserId)
            Badge = v1:FindFirstChild("Badge")
            if Badge then
                BadgeSkin = v.BadgeSkin
                BadgeFloat = v.BadgeFloat
                if BadgeSkin ~= "" then
                    v5 = Skins.GetSkinInformation("Badge", BadgeSkin)
                    imageAssetId = if v5 then Skins.GetWearImageForFloat(v5, BadgeFloat) or v5.imageAssetId or "" else ""
                else
                    imageAssetId = ""
                end
                Badge.Image = imageAssetId
                Badge.Visible = imageAssetId ~= ""
            end
            v4 = ("%*/%*/%*"):format(v.Kills, v.Deaths, v.Assists)
            KDA = v1:FindFirstChild("KDA")
            Amount = KDA and KDA:FindFirstChild("Amount")
            if not Amount then
                if KDA and KDA:IsA("TextLabel") then
                    KDA.Text = v4
                end
            elseif Amount:IsA("TextLabel") then
                Amount.Text = v4
            elseif KDA and KDA:IsA("TextLabel") then
                KDA.Text = v4
            end
            v4 = Format.Number(Derive.Divide(v.CombatScore, v.RoundsPlayed))
            CombatScore = v1:FindFirstChild("CombatScore")
            Amount_2 = CombatScore and CombatScore:FindFirstChild("Amount")
            if not Amount_2 then
                if CombatScore and CombatScore:IsA("TextLabel") then
                    CombatScore.Text = v4
                end
            elseif Amount_2:IsA("TextLabel") then
                Amount_2.Text = v4
            elseif CombatScore and CombatScore:IsA("TextLabel") then
                CombatScore.Text = v4
            end
            v4 = Format.Number(Derive.EconomyRating(v.DamageDealt, v.MoneySpent))
            Econ = v1:FindFirstChild("Econ")
            Amount_3 = Econ and Econ:FindFirstChild("Amount")
            if not Amount_3 then
                if Econ and Econ:IsA("TextLabel") then
                    Econ.Text = v4
                end
            elseif Amount_3:IsA("TextLabel") then
                Amount_3.Text = v4
            elseif Econ and Econ:IsA("TextLabel") then
                Econ.Text = v4
            end
            v4 = Format.Number(v.FirstBloods)
            FirstBloods = v1:FindFirstChild("FirstBloods")
            Amount_4 = FirstBloods and FirstBloods:FindFirstChild("Amount")
            if not Amount_4 then
                if FirstBloods and FirstBloods:IsA("TextLabel") then
                    FirstBloods.Text = v4
                end
            elseif Amount_4:IsA("TextLabel") then
                Amount_4.Text = v4
            elseif FirstBloods and FirstBloods:IsA("TextLabel") then
                FirstBloods.Text = v4
            end
            v4 = Format.Number(v.Plants)
            Plants = v1:FindFirstChild("Plants")
            Amount_5 = Plants and Plants:FindFirstChild("Amount")
            if not Amount_5 then
                if Plants and Plants:IsA("TextLabel") then
                    Plants.Text = v4
                end
            elseif Amount_5:IsA("TextLabel") then
                Amount_5.Text = v4
            elseif Plants and Plants:IsA("TextLabel") then
                Plants.Text = v4
            end
            v4 = Format.Number(if not u459 then v.Defuses else v.Rescues)
            Defuses = v1:FindFirstChild("Defuses")
            Amount_6 = Defuses and Defuses:FindFirstChild("Amount")
            if not Amount_6 then
                if Defuses and Defuses:IsA("TextLabel") then
                    Defuses.Text = v4
                end
            elseif Amount_6:IsA("TextLabel") then
                Amount_6.Text = v4
            elseif Defuses and Defuses:IsA("TextLabel") then
                Defuses.Text = v4
            end
            for i2, i3 in ipairs({"Bomb", "Dead"}) do
                v6 = v1:FindFirstChild(i3)
                if v6 and v6:IsA("GuiObject") then
                    v6.Visible = false
                end
            end
            UserId_2 = v.UserId
            Team = v.Team
            Team_2 = v8.Team
            PaintPlayerRow(v1, if UserId_2 ~= LocalPlayer.UserId then if Team ~= Team_2 then u70 else u59 else u81)
        end
        return
    end
end

local function BindColumnHeadings() -- Line: 474
    -- upvalues: u163 (ref), u160 (val), u179 (val), Router (val), u177 (ref), u178 (ref), u133 (val), u138 (val)
    -- upvalues: u173 (ref), PopulateScoreboard (val)
    local Hitbox, v1
    local Header = u163 and u163:FindFirstChild("Header")
    if not Header then
        return
    end
    for i, v in ipairs(Header:GetChildren()) do
        if v:IsA("TextLabel") then
            if v.Name == "Sort_Player" or u160[v.Name] ~= nil then
                local Name = v.Name
                u179[Name] = v
                Hitbox = v:FindFirstChild("Hitbox")
                if Hitbox and Hitbox:IsA("GuiButton") then
                    Hitbox.Active = true
                    Hitbox.Activated:Connect(function() -- Line: 494
                        -- upvalues: Router (upval), u177 (upval), Name (val), u178 (upval), u179 (upval), u133 (upval)
                        -- upvalues: u138 (upval), u173 (upval), PopulateScoreboard (upval)
                        local v1
                        Router.broadcastRouter("RunInterfaceSound", "UI Click")
                        if u177 ~= Name then
                            u177 = Name
                            u178 = Name ~= "Sort_Player"
                        else
                            u178 = not u178
                        end
                        for k, v in pairs(u179) do
                            v1 = if k ~= u177 then u138 else u133
                            v.TextColor3 = v1
                        end
                        local v2 = u173
                        if v2 then
                            PopulateScoreboard(v2)
                        end
                    end)
                end
            end
        end
    end
    for k, i2 in pairs(u179) do
        v1 = if k ~= u177 then u138 else u133
        i2.TextColor3 = v1
    end
end

local function GetResultsRow(a1) -- Line: 519 -- upvalues: u164 (ref) -- types: a1: number
    local v1 = u164 and u164:FindFirstChild((("Results%*"):format(a1)))
    if v1 and v1:IsA("Frame") then
        return v1
    end
    return nil
end

local function GetRoundFrame(a1) -- Line: 526 -- upvalues: u164 (ref) -- types: a1: number
    local v1
    local v2 = if not (a1 <= 12) then 2 else 1
    local v3 = u164 and u164:FindFirstChild((("Results%*"):format(v2)))
    if not (if not v3 then nil else if not v3:IsA("Frame") then nil else v3) then
        return nil
    end
    v2 = v1:FindFirstChild((tostring(a1)))
    if v2 and v2:IsA("GuiObject") then
        return v2
    end
    return nil
end

local function LayoutRounds(a1) -- Line: 539 -- upvalues: u164 (ref), u180 (val) -- types: a1: number
    local v1 = u164 and u164:FindFirstChild((("Results%*"):format(1)))
    local v2 = if not v1 then nil else if not v1:IsA("Frame") then nil else v1
    local v3 = u164 and u164:FindFirstChild((("Results%*"):format(2)))
    v1 = if not v3 then nil else if not v3:IsA("Frame") then nil else v3
    if v2 and v1 then
        v3 = u180[v2.Name]
        local v4 = u180[v1.Name]
        local v5 = v2:FindFirstChild("1")
        local UIListLayout = v2:FindFirstChildOfClass("UIListLayout")
        if v3 and v4 and v5 and UIListLayout then
            local Position, v6, v7, v8, v9, v10
            local v11 = math.clamp(a1, 1, 24)
            local v12 = math.min(v11, 12)
            local v13 = v11 - v12
            for i = 1, 24 do
                v8 = if i > 12 then 2 else 1
                v9 = u164 and u164:FindFirstChild((("Results%*"):format(v8)))
                v7 = if not v9 then nil else if not v9:IsA("Frame") then nil else v9
                if v7 then
                    v8 = v7:FindFirstChild((tostring(i)))
                    v6 = if not v8 then nil else if not v8:IsA("GuiObject") then nil else v8
                else
                    v6 = nil
                end
                if v6 then
                    v6.Visible = i <= v11
                end
            end
            v1.Visible = v13 > 0
            local Scale = v2.Size.X.Scale
            local v14 = UIListLayout.Padding.Scale * Scale
            local v15 = v5.Size.X.Scale * Scale + v14
            v6 = v3.X.Scale - Scale / 2
            v7 = v6 + (v4.X.Scale - v3.X.Scale)
            v8 = v7 + 12 * v15 - v14
            v9 = if not (v13 > 0) then v6 + v12 * v15 - v14 else v7 + v13 * v15 - v14
            local v16 = (v8 - v9) / 2
            v2.Position = UDim2.new(v3.X.Scale + v16, v3.X.Offset, v3.Y.Scale, v3.Y.Offset)
            v1.Position = UDim2.new(v4.X.Scale + v16, v4.X.Offset, v4.Y.Scale, v4.Y.Offset)
            for k, v in pairs({Previous = v6 - 0.014, Next = v9 + 0.014}) do
                v10 = u164:FindFirstChild(k)
                if v10 and v10:IsA("GuiObject") then
                    Position = v10.Position
                    v10.Position = UDim2.new(v + v16, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
                end
            end
            return
        end
        return
    end
end

local function PaintRound(a1, a2, a3) -- Line: 597
    -- upvalues: u115 (val), u105 (val), u110 (val), u151 (val)
    local Icon, v1, v2, v3
    local Selected = a1:FindFirstChild("Selected")
    if Selected and Selected:IsA("GuiObject") then
        Selected.Visible = a3
    end
    if not a2 then
        local v4
        a1.BackgroundColor3 = u115
        for i2, i3 in ipairs({"Team1", "Team2"}) do
            v4 = a1:FindFirstChild(i3)
            if v4 and v4:IsA("GuiObject") then
                v4.Visible = false
            end
        end
        return
    end
    a1.BackgroundColor3 = if a2.Winner ~= "Counter-Terrorists" then u110 else u105
    local v5 = if a2.Winner ~= "Terrorists" then "Team2" else "Team1"
    local v6 = ipairs
    local v7, v8 = a1, a2
    for i, v in v6({"Team1", "Team2"}) do
        v1 = v7:FindFirstChild(v)
        if v1 then
            v1.Visible = v == v5
            if v2 then
                v1.BackgroundTransparency = 0
                v1.BackgroundColor3 = v3
                Icon = v1:FindFirstChild("Icon")
                if Icon then
                    Icon.Image = u151[v8.WinType] or "rbxassetid://70876442749327"
                    Icon.ImageColor3 = v3
                    Icon.ImageTransparency = 0
                end
            end
        end
    end
end

local function GetRound(a1, a2) -- Line: 645 -- types: a2: number
    for i, v in ipairs(a1.Rounds) do
        if v.Round == a2 then
            return v
        end
    end
    return nil
end

local function PopulateEventLog(a1) -- Line: 657
    -- upvalues: u164 (ref), u168 (ref), ClearRows (val), Format (val), WeaponIcon (val), ApplyAvatar (val)
    local EventLog = u164 and u164:FindFirstChild("EventLog")
    if EventLog and u168 then
        local ItemIcon, Meter, Time, v1, v2, v3
        ClearRows(EventLog)
        local header = u164:FindFirstChild("header") or u164:FindFirstChild("Header")
        local Left = header and header:FindFirstChild("Left")
        local Label = Left and Left:FindFirstChild("Label")
        if Label then
            Label.Text = if not a1 then "EVENT LOG" else ("EVENT LOG | ROUND %*"):format(a1.Round)
        end
        if not a1 then
            return
        end
        for i, v in ipairs(a1.Events) do
            v1 = u168:Clone()
            v1.Name = ("Row_%*"):format(i)
            v1.LayoutOrder = i
            v1.Visible = true
            v1.Parent = EventLog
            v2 = Format.Duration(v.Time)
            Time = v1 and v1:FindFirstChild("Time")
            if Time and Time:IsA("TextLabel") then
                Time.Text = v2
            end
            v2 = ("%*m"):format((math.floor(v.Distance + 0.5)))
            Meter = v1 and v1:FindFirstChild("Meter")
            if Meter and Meter:IsA("TextLabel") then
                Meter.Text = v2
            end
            ItemIcon = v1:FindFirstChild("ItemIcon")
            if ItemIcon and ItemIcon:IsA("ImageLabel") then
                ItemIcon.Image = WeaponIcon.Get(v.Weapon)
            end
            v3 = {}
            for i2, i3 in ipairs(v1:GetChildren()) do
                if i3:IsA("GuiObject") and i3.Name == "Player" then
                    table.insert(v3, i3)
                end
            end
            table.sort(v3, function(a1, a2) -- Line: 694 -- types: a1: userdata, a2: userdata
                return a1.Position.X.Scale < a2.Position.X.Scale
            end)
            for i4, j in ipairs({v.Killer, v.Victim}) do
                ApplyAvatar(v3[i4], j)
            end
        end
        return
    end
end

local function PopulateRoundPlayers(a1, a2) -- Line: 707
    -- upvalues: u164 (ref), u169 (ref), ClearRows (val), PaintPlayerRow (val), LocalPlayer (val), u81 (val), u59 (val)
    -- upvalues: u70 (val), ApplyAvatar (val), Format (val)
    local Player = u164 and u164:FindFirstChild("Player")
    if Player and u169 then
        local Amount, Amount_2, Amount_3, Amount_4, Armor, Armor_2, Assist, CombatScore, DisplayName, Econ, Equip, Equip_2, Gun, Kills, PlayerName, Team, Team_2, UserId, UserId_3, v1, v2, v3, v4, v5
        ClearRows(Player)
        if not a2 then
            return
        end
        local u362 = {}
        for i, v in ipairs(a1.Players) do
            u362[v.UserId] = v
        end

        local function TeamOf(a1) -- Line: 724 -- upvalues: u362 (val)
            local v1 = u362[a1.UserId]
            if v1 then
                return v1.Team
            end
            return ""
        end

        local v6 = table.clone(a2.Players)
        table.sort(v6, function(a1_2, a2) -- Line: 731 -- upvalues: u362 (val), a1 (val)
            local v1 = u362[a1_2.UserId]
            local v2 = (if not v1 then "" else v1.Team) == a1.Team
            local v3 = u362[a2.UserId]
            if v2 ~= ((if not v3 then "" else v3.Team) == a1.Team) then
                return v2
            end
            return a2.CombatScore < a1_2.CombatScore
        end)
        for i2, i3 in ipairs(v6) do
            v1 = u169:Clone()
            v1.Name = ("Row_%*"):format(i2)
            v1.LayoutOrder = i2
            v1.Visible = true
            v1.Parent = Player
            v2 = u362[i3.UserId]
            UserId = i3.UserId
            v5 = u362[i3.UserId]
            Team = if not v5 then "" else v5.Team
            Team_2 = a1.Team
            PaintPlayerRow(v1, if UserId ~= LocalPlayer.UserId then if Team ~= Team_2 then u70 else u59 else u81)
            DisplayName = if not v2 then tostring(i3.UserId) else v2.DisplayName
            PlayerName = v1 and v1:FindFirstChild("PlayerName")
            if PlayerName and PlayerName:IsA("TextLabel") then
                PlayerName.Text = DisplayName
            end
            UserId_3 = i3.UserId
            ApplyAvatar(v1:FindFirstChild("Player"), UserId_3)
            v3 = Format.Number(i3.CombatScore)
            CombatScore = v1:FindFirstChild("CombatScore")
            Amount = CombatScore and CombatScore:FindFirstChild("Amount")
            if not Amount then
                if CombatScore and CombatScore:IsA("TextLabel") then
                    CombatScore.Text = v3
                end
            elseif Amount:IsA("TextLabel") then
                Amount.Text = v3
            elseif CombatScore and CombatScore:IsA("TextLabel") then
                CombatScore.Text = v3
            end
            v3 = Format.Money(i3.MoneySpent)
            Econ = v1:FindFirstChild("Econ")
            Amount_2 = Econ and Econ:FindFirstChild("Amount")
            if not Amount_2 then
                if Econ and Econ:IsA("TextLabel") then
                    Econ.Text = v3
                end
            elseif Amount_2:IsA("TextLabel") then
                Amount_2.Text = v3
            elseif Econ and Econ:IsA("TextLabel") then
                Econ.Text = v3
            end
            v3 = Format.Number(i3.Kills)
            Kills = v1:FindFirstChild("Kills")
            Amount_3 = Kills and Kills:FindFirstChild("Amount")
            if not Amount_3 then
                if Kills and Kills:IsA("TextLabel") then
                    Kills.Text = v3
                end
            elseif Amount_3:IsA("TextLabel") then
                Amount_3.Text = v3
            elseif Kills and Kills:IsA("TextLabel") then
                Kills.Text = v3
            end
            v3 = Format.Number(i3.Assists)
            Assist = v1:FindFirstChild("Assist")
            Amount_4 = Assist and Assist:FindFirstChild("Amount")
            if not Amount_4 then
                if Assist and Assist:IsA("TextLabel") then
                    Assist.Text = v3
                end
            elseif Amount_4:IsA("TextLabel") then
                Amount_4.Text = v3
            elseif Assist and Assist:IsA("TextLabel") then
                Assist.Text = v3
            end
            Equip = v1:FindFirstChild("Equip")
            if Equip then
                if i3.Equip == "" then
                    v4 = "NONE"
                else
                    Equip_2 = i3.Equip
                    v4 = if Equip_2 == nil then "" else if Equip_2 ~= "" then string.upper(Equip_2) else ""
                end
                Gun = Equip and Equip:FindFirstChild("Gun")
                if Gun and Gun:IsA("TextLabel") then
                    Gun.Text = v4
                end
                Armor = i3.Armor
                Armor_2 = Equip and Equip:FindFirstChild("Armor")
                if Armor_2 and Armor_2:IsA("TextLabel") then
                    Armor_2.Text = Armor
                end
            end
        end
        return
    end
end

local function RenderTimeline() -- Line: 763
    -- upvalues: u173 (ref), u164 (ref), MapIcon (val), CareerData (val), u175 (ref), LayoutRounds (val)
    -- upvalues: PaintRound (val), PopulateEventLog (val), PopulateRoundPlayers (val)
    local v1 = u173
    if v1 and u164 then
        local RoundCount, v2, v3, v4, v5, v6, v7
        local Map = u164:FindFirstChild("Map")
        if Map and Map:IsA("ImageLabel") then
            v4, v5 = MapIcon.GetRadar(v1.Map)
            Map.Image = v4
            Map.ImageTransparency = 0
            Map.ImageRectOffset = v5.Min
            Map.ImageRectSize = Vector2.new(v5.Width, v5.Height)
            Map.Rotation = 90
            Map.ScaleType = Enum.ScaleType.Fit
            Map.BackgroundTransparency = 1
        end
        v4 = CareerData.GetMatchDetails(v1.MatchId)
        v5 = v4
        if v5 then
            local v8 = u175
            for i, v in ipairs(v4.Rounds) do
                if v.Round == v8 then
                    RoundCount = v1.RoundCount
                    if RoundCount <= 0 then
                        RoundCount = if not v4 then 0 else #v4.Rounds
                    end
                    LayoutRounds(RoundCount)
                    for i2 = 1, 24 do
                        v2 = if i2 > 12 then 2 else 1
                        v3 = u164 and u164:FindFirstChild((("Results%*"):format(v2)))
                        v7 = if not v3 then nil else if not v3:IsA("Frame") then nil else v3
                        if v7 then
                            v2 = v7:FindFirstChild((tostring(i2)))
                            v6 = if not v2 then nil else if not v2:IsA("GuiObject") then nil else v2
                        else
                            v6 = nil
                        end
                        if v6 then
                            v7 = v4
                            if v7 then
                                for i3, j in ipairs(v4.Rounds) do
                                    if j.Round == i2 then
                                        PaintRound(v6, j, i2 == u175)
                                        break
                                    end
                                end
                                v7 = nil
                            end
                            PaintRound(v6, v7, i2 == u175)
                        end
                    end
                    PopulateEventLog(v)
                    PopulateRoundPlayers(v1, v5)
                    return
                end
            end
            v5 = nil
        end
        RoundCount = v1.RoundCount
        if RoundCount <= 0 then
            RoundCount = if not v4 then 0 else #v4.Rounds
        end
        LayoutRounds(RoundCount)
        for k = 1, 24 do
            v2 = if k > 12 then 2 else 1
            v3 = u164 and u164:FindFirstChild((("Results%*"):format(v2)))
            v7 = if not v3 then nil else if not v3:IsA("Frame") then nil else v3
            if v7 then
                v2 = v7:FindFirstChild((tostring(k)))
                v6 = if not v2 then nil else if not v2:IsA("GuiObject") then nil else v2
            else
                v6 = nil
            end
            if v6 then
                v7 = v4
                if v7 then
                    for i4, n in ipairs(v4.Rounds) do
                        if n.Round == k then
                            PaintRound(v6, n, k == u175)
                            break
                        end
                    end
                    v7 = nil
                end
                PaintRound(v6, v7, k == u175)
            end
        end
        PopulateEventLog(v5)
        PopulateRoundPlayers(v1, v5)
        return
    end
end

local function SelectRound(a1) -- Line: 806
    -- upvalues: u173 (ref), CareerData (val), Router (val), u175 (ref), RenderTimeline (val)
    local v1 = u173
    local v2 = v1 and CareerData.GetMatchDetails(v1.MatchId)
    if v2 then
        for i, v in ipairs(v2.Rounds) do
            if v.Round == a1 then
                if not v then
                    return false
                end
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                u175 = a1
                RenderTimeline()
                return true
            end
        end
        if nil then
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u175 = a1
            RenderTimeline()
            return true
        end
    end
    return false
end

local function BindRoundButtons() -- Line: 822
    -- upvalues: u164 (ref), u173 (ref), CareerData (val), Router (val), u175 (ref), RenderTimeline (val)
    -- upvalues: ActivateButton (val)
    local Hitbox, Select, v1, v2, v3, v4
    for i = 1, 24 do
        v3 = if i > 12 then 2 else 1
        v4 = u164 and u164:FindFirstChild((("Results%*"):format(v3)))
        v2 = if not v4 then nil else if not v4:IsA("Frame") then nil else v4
        if v2 then
            v3 = v2:FindFirstChild((tostring(i)))
            v1 = if not v3 then nil else if not v3:IsA("GuiObject") then nil else v3
        else
            v1 = nil
        end
        if v1 then
            function Select() -- Line: 830
                -- upvalues: i (val), u173 (upval), CareerData (upval), Router (upval), u175 (upval)
                -- upvalues: RenderTimeline (upval)
                local v1 = i
                local v2 = u173
                local v3 = v2 and CareerData.GetMatchDetails(v2.MatchId)
                if v3 then
                    for i2, v in ipairs(v3.Rounds) do
                        if v.Round == v1 then
                            if not v then
                                return
                            end
                            Router.broadcastRouter("RunInterfaceSound", "UI Click")
                            u175 = v1
                            RenderTimeline()
                            return
                        end
                    end
                    if true then
                        return
                    end
                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    u175 = v1
                    RenderTimeline()
                end
            end

            Hitbox = v1:FindFirstChild("Hitbox")
            v4 = nil
            if not Hitbox then
                if v1:IsA("GuiButton") then
                    v4 = v1
                end
            elseif Hitbox:IsA("GuiButton") then
                v4 = Hitbox
            elseif v1:IsA("GuiButton") then
                v4 = v1
            end
            if v4 then
                v4.Active = true
                v4.Selectable = true
                ActivateButton(v4)
                v4.Activated:Connect(Select)
            end
            if v1:IsA("GuiButton") and v1 ~= v4 then
                v1.Selectable = false
                v1.Active = true
                v1.Activated:Connect(Select)
            end
        end
    end
end

local function BindRoundArrows() -- Line: 861
    -- upvalues: u164 (ref), ActivateButton (val), u175 (ref), u173 (ref), CareerData (val), Router (val)
    -- upvalues: RenderTimeline (val)
    local v1
    for k, v in pairs({Previous = -1, Next = 1}) do
        v1 = u164 and u164:FindFirstChild(k)
        if v1 and v1:IsA("GuiButton") then
            v1.Active = true
            v1.Selectable = true
            ActivateButton(v1)
            v1.Activated:Connect(function() -- Line: 871
                -- upvalues: u175 (upval), v (val), u173 (upval), CareerData (upval), Router (upval)
                -- upvalues: RenderTimeline (upval)
                local v1, v2, v3
                local v4 = u175 + v
                while v4 >= 1 do
                    if not (v4 <= 24) then
                        break
                    end
                    v2 = u173
                    v3 = v2 and CareerData.GetMatchDetails(v2.MatchId)
                    if not v3 then
                        v1 = false
                    else
                        for i, i2 in ipairs(v3.Rounds) do
                            if i2.Round == v4 then
                                if i2 then
                                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                                    u175 = v4
                                    RenderTimeline()
                                    v1 = true
                                else
                                    v1 = false
                                end
                                if v1 then
                                    return
                                end
                                v4 = v4 + v
                                break
                            end
                        end
                        if nil then
                            Router.broadcastRouter("RunInterfaceSound", "UI Click")
                            u175 = v4
                            RenderTimeline()
                            v1 = true
                        else
                            v1 = false
                        end
                    end
                    if v1 then
                        return
                    end
                    v4 = v4 + v
                end
            end)
        end
    end
end

local function PaintDamageBlock(a1, a2) -- Line: 886
    -- upvalues: Format (val), u148 (val), u143 (val), Derive (val)
    local v1
    if not a1 then
        return
    end
    local v2 = a2.Head + a2.Body + a2.Legs
    local v3 = Format.Number(v2)
    local Total = a1 and a1:FindFirstChild("Total")
    if Total and Total:IsA("TextLabel") then
        Total.Text = v3
    end
    local DealtNumbers = a1:FindFirstChild("DealtNumbers")
    if DealtNumbers then
        local v4 = Format.Number(a2.Head)
        local Head = DealtNumbers and DealtNumbers:FindFirstChild("Head")
        if Head and Head:IsA("TextLabel") then
            Head.Text = v4
        end
        v4 = Format.Number(a2.Body)
        local Body = DealtNumbers and DealtNumbers:FindFirstChild("Body")
        if Body and Body:IsA("TextLabel") then
            Body.Text = v4
        end
        v4 = Format.Number(a2.Legs)
        local Legs = DealtNumbers and DealtNumbers:FindFirstChild("Legs")
        if Legs and Legs:IsA("TextLabel") then
            Legs.Text = v4
        end
    end
    local Body_2 = a1:FindFirstChild("Body")
    if not Body_2 then
        return
    end
    for k, v in pairs({Head = a2.Head, Torso = a2.Body, Legs = a2.Legs}) do
        v1 = Body_2:FindFirstChild(k)
        if v1 and v1:IsA("ImageLabel") then
            v1.ImageColor3 = u148:Lerp(u143, (math.clamp(Derive.Divide(v, v2), 0, 1)))
        end
    end
end

local function TintLabel(a1, a2, a3) -- Line: 919 -- types: a1: userdata, a2: string, a3: userdata
    local v1 = a1:FindFirstChild(a2)
    if v1 and v1:IsA("TextLabel") then
        local UIGradient = v1:FindFirstChildOfClass("UIGradient")
        if not UIGradient then
            v1.TextColor3 = a3
            return
        end
        UIGradient.Color = ColorSequence.new(a3)
        v1.TextColor3 = Color3.new(1, 1, 1)
        return
    end
end

local function PopulateFight(a1, a2, a3) -- Line: 936
    -- upvalues: u172 (ref), u128 (val), TintLabel (val), u120 (val), u125 (val), WeaponIcon (val)
    -- upvalues: PaintDamageBlock (val)
    local v1
    local v2 = u172:Clone()
    v2.Name = ("Row_%*"):format(a3)
    v2.LayoutOrder = a3
    v2.Visible = true
    local Outcome = v2:FindFirstChild("Outcome")
    local v3 = u128[a2.Outcome] == true
    if Outcome and Outcome:IsA("TextLabel") then
        Outcome.Visible = v3
        if v3 then
            Outcome.TextTransparency = 0
        end
    end
    local v4 = string.upper(a2.Outcome)
    local Outcome_2 = v2 and v2:FindFirstChild("Outcome")
    if Outcome_2 and Outcome_2:IsA("TextLabel") then
        Outcome_2.Text = v4
    end
    v4 = if not a2.RoundWon then "LOST" else "WON"
    local Status = v2 and v2:FindFirstChild("Status")
    if Status and Status:IsA("TextLabel") then
        Status.Text = v4
    end
    TintLabel(v2, "Outcome", if a2.Outcome ~= "Kill" then u125 else u120)
    TintLabel(v2, "Status", if not a2.RoundWon then u125 else u120)
    v4 = tostring(a2.Round)
    local Title = v2 and v2:FindFirstChild("Title")
    if Title and Title:IsA("TextLabel") then
        Title.Text = v4
    end
    local YourWeapon = a2.YourWeapon
    v4 = if YourWeapon == nil then "" else if YourWeapon ~= "" then string.upper(YourWeapon) else ""
    local YourWeaponName = v2 and v2:FindFirstChild("YourWeaponName")
    if YourWeaponName and YourWeaponName:IsA("TextLabel") then
        YourWeaponName.Text = v4
    end
    local EnemyWeapon = a2.EnemyWeapon
    v4 = if EnemyWeapon == nil then "" else if EnemyWeapon ~= "" then string.upper(EnemyWeapon) else ""
    local EnemyWeaponName = v2 and v2:FindFirstChild("EnemyWeaponName")
    if EnemyWeaponName and EnemyWeaponName:IsA("TextLabel") then
        EnemyWeaponName.Text = v4
    end
    v4 = ("%*m"):format((math.floor(a2.Distance + 0.5)))
    local Range = v2 and v2:FindFirstChild("Range")
    if Range and Range:IsA("TextLabel") then
        Range.Text = v4
    end
    for i, j in {{"YourWeapon", a2.YourWeapon}, {"EnemyWeapon", a2.EnemyWeapon}} do
        v1 = v2:FindFirstChild(j[1])
        if v1 and v1:IsA("ImageLabel") then
            v1.Image = WeaponIcon.Get(j[2])
        end
    end
    PaintDamageBlock(v2:FindFirstChild("DamageDealt"), a2.DamageDealt)
    PaintDamageBlock(v2:FindFirstChild("DamageTaken"), a2.DamageTaken)
    v2.Parent = a1
end

local function ScaleFightPanel(a1, a2) -- Line: 978 -- upvalues: u171 (ref) -- types: a1: userdata, a2: number
    if a1:IsA("GuiObject") and not (a2 <= 1) then
        local Offset_2, Scale_2, Size_2, new_3, v1
        local Size = u171.Size
        a1.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * a2, Size.Y.Offset * a2)
        for i, v in ipairs(a1:GetChildren()) do
            if string.sub(v.Name, 1, 4) == "Row_" and v:IsA("GuiObject") then
                Size_2 = v.Size
                new_3 = UDim2.new
                Scale_2 = Size_2.X.Scale
                Offset_2 = Size_2.X.Offset
                v1 = Size_2.Y.Scale / a2
                v.Size = new_3(Scale_2, Offset_2, v1, Size_2.Y.Offset)
            end
        end
        local UIListLayout = a1:FindFirstChildOfClass("UIListLayout")
        if UIListLayout then
            local Padding = UIListLayout.Padding
            UIListLayout.Padding = UDim.new(Padding.Scale / a2, Padding.Offset)
        end
        return
    end
end

function RenderPerformance() -- Line: 1007
    -- upvalues: u173 (ref), u165 (ref), u170 (ref), ClearRows (val), CareerData (val), Format (val), ApplyAvatar (val)
    -- upvalues: u176 (val), u171 (ref), u172 (ref), PopulateFight (val), ScaleFightPanel (val), ActivateButton (val)
    -- upvalues: Router (val), RenderPerformance (val)
    local v1 = u173
    local Frame = u165 and u165:FindFirstChild("Frame")
    if v1 and Frame and u170 then
        local Amount, Amount_2, Amount_3, Assists, Deaths, Details, Kills, PlayerName, SelectedOptionText, UserId_2, YourStats, v2, v3, v4, v5, v6, v7
        ClearRows(Frame)
        local v8 = CareerData.GetMatchDetails(v1.MatchId)
        if not v8 then
            return
        end
        local v9 = 0
        for i, v in ipairs(v8.Duels) do
            v9 = v9 + 10
            v7 = u170:Clone()
            v7.Name = ("Row_%*"):format(v9)
            v7.LayoutOrder = v9
            v7.Visible = true
            v7.Parent = Frame
            YourStats = v7:FindFirstChild("YourStats")
            if YourStats then
                v2 = Format.Number(v.Kills)
                Kills = YourStats:FindFirstChild("Kills")
                Amount = Kills and Kills:FindFirstChild("Amount")
                if not Amount then
                    if Kills and Kills:IsA("TextLabel") then
                        Kills.Text = v2
                    end
                elseif Amount:IsA("TextLabel") then
                    Amount.Text = v2
                elseif Kills and Kills:IsA("TextLabel") then
                    Kills.Text = v2
                end
                v2 = Format.Number(v.Deaths)
                Deaths = YourStats:FindFirstChild("Deaths")
                Amount_2 = Deaths and Deaths:FindFirstChild("Amount")
                if not Amount_2 then
                    if Deaths and Deaths:IsA("TextLabel") then
                        Deaths.Text = v2
                    end
                elseif Amount_2:IsA("TextLabel") then
                    Amount_2.Text = v2
                elseif Deaths and Deaths:IsA("TextLabel") then
                    Deaths.Text = v2
                end
                v2 = Format.Number(v.Assists)
                Assists = YourStats:FindFirstChild("Assists")
                Amount_3 = Assists and Assists:FindFirstChild("Amount")
                if not Amount_3 then
                    if Assists and Assists:IsA("TextLabel") then
                        Assists.Text = v2
                    end
                elseif Amount_3:IsA("TextLabel") then
                    Amount_3.Text = v2
                elseif Assists and Assists:IsA("TextLabel") then
                    Assists.Text = v2
                end
            end
            v2 = v7:FindFirstChild("Enemy") or v7
            v3 = ("%* (@%*)"):format(v.DisplayName, v.Username)
            PlayerName = v2 and v2:FindFirstChild("PlayerName")
            if PlayerName and PlayerName:IsA("TextLabel") then
                PlayerName.Text = v3
            end
            UserId_2 = v.UserId
            ApplyAvatar(v2:FindFirstChild("Player"), UserId_2)
            if u176[v.UserId] == true and u171 and u172 then
                v5 = u171
                v6 = v9 + 1
                v4 = v5:Clone()
                v4.Name = ("Row_%*"):format(v6)
                v4.LayoutOrder = v6
                v4.Visible = true
                v4.Parent = Frame
                v5 = v4:FindFirstChild(u172.Name)
                if v5 then
                    v5:Destroy()
                end
                for i2, i3 in ipairs(v.Fights) do
                    PopulateFight(v4, i3, i2)
                end
                ScaleFightPanel(v4, #v.Fights)
            end
            Details = v2:FindFirstChild("Details")
            if Details and Details:IsA("GuiButton") then
                ActivateButton(Details)
                v5 = if not v3 then "DETAILS" else "CLOSE"
                SelectedOptionText = Details and Details:FindFirstChild("SelectedOptionText")
                if SelectedOptionText and SelectedOptionText:IsA("TextLabel") then
                    SelectedOptionText.Text = v5
                end
                local UserId = v.UserId
                Details.Activated:Connect(function() -- Line: 1062 -- upvalues: Router (upval), u176 (upval), UserId (val), RenderPerformance (upval)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    u176[UserId] = not (u176[UserId] == true)
                    RenderPerformance()
                end)
            end
        end
        return
    end
end

local function SelectTab(a1) -- Line: 1074
    -- upvalues: u174 (ref), u173 (ref), u163 (ref), u164 (ref), u165 (ref), u166 (ref), RenderTimeline (val)
    -- upvalues: RenderPerformance (val)
    local v1, v2, v3
    u174 = a1
    local v4 = u173
    local v5 = false
    if v4 ~= nil then
        v5 = v4.Gamemode ~= "Deathmatch"
    end
    if u163 then
        u163.Visible = a1 == "Scoreboard"
    end
    if u164 then
        v2 = u164
        v3 = false
        if a1 == "Timeline" then
            v3 = v5
        end
        v2.Visible = v3
    end
    if u165 then
        v2 = u165
        v3 = false
        if a1 == "Performance" then
            v3 = v5
        end
        v2.Visible = v3
    end
    if not u166 then
        v1 = a1
    else
        local SelectedOptionText, v6
        for i, v in ipairs(u166:GetChildren()) do
            if v:IsA("GuiButton") then
                SelectedOptionText = v:FindFirstChild("SelectedOptionText")
                if SelectedOptionText then
                    v6 = if v.Name ~= a1 then Color3.fromRGB(158, 158, 158) else Color3.new(1, 1, 1)
                    SelectedOptionText.TextColor3 = v6
                end
                if v.Name == "Timeline" or v.Name == "Performance" then
                    v.Visible = v5
                end
            end
        end
    end
    if v1 == "Timeline" then
        RenderTimeline()
        return
    end
    if v1 == "Performance" then
        RenderPerformance()
    end
end

function u0.Bind(a1) -- Line: 1120
    -- upvalues: u161 (ref), u162 (ref), u163 (ref), u164 (ref), u165 (ref), u166 (ref), u167 (ref), u168 (ref)
    -- upvalues: u169 (ref), u170 (ref), u171 (ref), u172 (ref), ActivateButton (val), Router (val), SelectTab (val)
    -- upvalues: u0 (val), u180 (val), BindColumnHeadings (val), BindRoundButtons (val), BindRoundArrows (val)
    -- upvalues: CareerData (val), u173 (ref), u175 (ref), u174 (ref), RenderTimeline (val), RenderPerformance (val)
    u161 = a1:FindFirstChild("Details")
    if not u161 then
        return
    end
    local InputBlocker = a1:FindFirstChild("InputBlocker")
    if InputBlocker and InputBlocker:IsA("GuiButton") then
        InputBlocker.Active = true
        InputBlocker.Visible = false
        u162 = InputBlocker
    end
    u163 = u161:FindFirstChild("Scoreboard")
    u164 = u161:FindFirstChild("Timeline")
    u165 = u161:FindFirstChild("Peformance") or u161:FindFirstChild("Performance")
    u166 = u161:FindFirstChild("Filters")
    local Main = u163 and u163:FindFirstChild("Main")
    local Main_2 = Main and Main:FindFirstChild("Main")
    u167 = Main_2 and Main_2:FindFirstChild("Template")
    local EventLog = u164 and u164:FindFirstChild("EventLog")
    u168 = EventLog and EventLog:FindFirstChild("Template")
    local Player = u164 and u164:FindFirstChild("Player")
    u169 = Player and Player:FindFirstChild("Template")
    local Frame = u165 and u165:FindFirstChild("Frame")
    u170 = Frame and Frame:FindFirstChild("Template")
    u171 = Frame and Frame:FindFirstChild("DetailTemplate")
    u172 = u171 and u171:FindFirstChild("FightTemplate")
    for i, v in ipairs({u167, u168, u169, u170, u171, u172}) do
        if v and v:IsA("GuiObject") then
            v.Visible = false
        end
    end
    if u166 then
        for i2, i3 in ipairs(u166:GetChildren()) do
            if i3:IsA("GuiButton") then
                local Name = i3.Name
                ActivateButton(i3)
                i3.Activated:Connect(function() -- Line: 1173 -- upvalues: Router (upval), SelectTab (upval), Name (val)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    SelectTab(Name)
                end)
            end
        end
    end
    local Close = u161:FindFirstChild("Close")
    if Close and Close:IsA("GuiButton") then
        ActivateButton(Close)
        Close.Activated:Connect(function() -- Line: 1184 -- upvalues: Router (upval), u0 (upval)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u0.Close()
        end)
    end
    local v1 = u164 and u164:FindFirstChild((("Results%*"):format(1)))
    local v2 = if not v1 then nil else if not v1:IsA("Frame") then nil else v1
    if v2 then
        u180[v2.Name] = v2.Position
    end
    v1 = u164 and u164:FindFirstChild((("Results%*"):format(2)))
    v2 = if not v1 then nil else if not v1:IsA("Frame") then nil else v1
    if v2 then
        u180[v2.Name] = v2.Position
    end
    BindColumnHeadings()
    BindRoundButtons()
    BindRoundArrows()
    CareerData.MatchLoaded:Connect(function(a1) -- Line: 1202
        -- upvalues: u0 (upval), u173 (upval), u175 (upval), u174 (upval), RenderTimeline (upval)
        -- upvalues: RenderPerformance (upval)
        if u0.IsOpen() and u173 ~= nil and a1.MatchId == u173.MatchId then
            u175 = if not (#a1.Rounds > 0) then 1 else a1.Rounds[1].Round
            if u174 == "Timeline" then
                RenderTimeline()
                return
            end
            if u174 == "Performance" then
                RenderPerformance()
            end
            return
        end
    end)
    u161.Visible = false
end

function u0.Open(a1) -- Line: 1220
    -- upvalues: u161 (ref), u173 (ref), u175 (ref), u176 (val), PopulateHeader (val), PopulateScoreboard (val)
    -- upvalues: SelectTab (val), CareerData (val), u162 (ref)
    if not u161 then
        return
    end
    u173 = a1
    u175 = 1
    table.clear(u176)
    PopulateHeader(a1)
    PopulateScoreboard(a1)
    SelectTab("Scoreboard")
    CareerData.RequestMatchDetails(a1.MatchId)
    if u162 then
        u162.Visible = true
    end
    u161.Visible = true
end

function u0.Close() -- Line: 1243 -- upvalues: u161 (ref), u162 (ref), u173 (ref)
    if u161 then
        u161.Visible = false
    end
    if u162 then
        u162.Visible = false
    end
    u173 = nil
end

function u0.IsOpen() -- Line: 1255 -- upvalues: u161 (ref)
    local Visible = false
    if u161 ~= nil then
        Visible = u161.Visible
    end
    return Visible
end

return u0