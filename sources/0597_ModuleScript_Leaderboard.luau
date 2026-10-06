-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetBadgeIcon = require(ReplicatedStorage.Components.Common.GetBadgeIcon);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local ProfileInspect = require(script:WaitForChild("ProfileInspect"));
local u2 = { "Ping", "Money", "Kills", "Deaths", "Assists", "MVPs", "Score" };
local v3 = {
    IsDeathmatch = false,
    CounterTerroristsPosition = UDim2.fromScale(0.582, 0.782),
    TerroristsPosition = UDim2.fromScale(0.582, 0.355),
    Size = UDim2.fromScale(0.762, 0.365),
    Headers = {
        Ping = UDim2.fromScale(0.26958, 0.53351),
        Money = UDim2.fromScale(0.63825, 0.66217),
        Kills = UDim2.fromScale(0.70308, 0.66217),
        Deaths = UDim2.fromScale(0.75921, 0.66217),
        Assists = UDim2.fromScale(0.82029, 0.66217),
        MVPs = UDim2.fromScale(0.88294, 0.66217),
        Score = UDim2.fromScale(0.93732, 0.66217)
    }
};
local u4 = {
    Deathmatch = {
        IsDeathmatch = true,
        CounterTerroristsPosition = UDim2.fromScale(0.503, 0.785),
        TerroristsPosition = UDim2.fromScale(0.503, 0.364),
        Size = UDim2.fromScale(0.921, 0.365),
        Headers = {
            Ping = UDim2.fromScale(0.12539, 0.53351),
            Money = UDim2.fromScale(0.57099, 0.66217),
            Kills = UDim2.fromScale(0.64935, 0.66217),
            Deaths = UDim2.fromScale(0.71718, 0.66217),
            Assists = UDim2.fromScale(0.79102, 0.66217),
            MVPs = UDim2.fromScale(0.86673, 0.66217),
            Score = UDim2.fromScale(0.93246, 0.66217)
        }
    },
    ["Bomb Defusal"] = v3,
    ["Hostage Rescue"] = v3
};
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_fromRGB_ret = Color3.fromRGB(139, 128, 98);
local Color3_fromRGB_ret2 = Color3.fromRGB(165, 183, 212);
local Color3_fromRGB_ret3 = Color3.fromRGB(219, 199, 126);
local Color3_fromRGB_ret4 = Color3.fromRGB(81, 81, 81);
local Color3_fromRGB_ret5 = Color3.fromRGB(95, 95, 95);
local Color3_fromRGB_ret6 = Color3.fromRGB(255, 255, 255);
local u5 = { "Team1", "Team2" };
local u6 = {
    BombDefuse = "rbxassetid://138772806705472",
    BombExplode = "rbxassetid://97682949239067",
    BombObjective = "rbxassetid://97682949239067",
    Elimination = "rbxassetid://70876442749327",
    TimeExpiration = "rbxassetid://96043369049959",
    HostageRescue = "rbxassetid://138772806705472"
};
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = false;
local u12 = {};
local u13 = {};

local function commaNumber(p14: number) -- Line: 129
    return tostring(p14):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function clearFrame(p15: userdata) -- Line: 133
    for _, child in ipairs(p15:GetChildren()) do
        if child.ClassName == "Frame" then
            child:Destroy();
        end;
    end;
end;

local function getPlayersOnTeam(p16) -- Line: 141
    -- upvalues: Participants (copy)
    local v17 = {};

    for _, v in ipairs((Participants.GetAll())) do
        if v:GetAttribute("Team") == p16 then
            table.insert(v17, v);
        end;
    end;

    return v17;
end;

local function lightenTowardWhite(p18) -- Line: 153
    -- upvalues: Color3_new_ret (copy)
    return p18:Lerp(Color3_new_ret, 0.2);
end;

local function getMousePositionInLeaderboard() -- Line: 157
    -- upvalues: UserInputService (copy), GuiService (copy), u7 (ref)
    local MouseLocation = UserInputService:GetMouseLocation();
    local GuiInset = GuiService:GetGuiInset();
    local AbsolutePosition = u7.AbsolutePosition;
    local AbsoluteSize = u7.AbsoluteSize;

    return UDim2.fromScale((MouseLocation.X - GuiInset.X - AbsolutePosition.X) / AbsoluteSize.X, (MouseLocation.Y - GuiInset.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
end;

local function resetProfileInspect() -- Line: 170
    -- upvalues: u8 (ref), u9 (ref), ProfileInspect (copy)
    if not u8 then
        return;
    end;

    u8.Visible = false;

    if u9 then
        u8.Position = u9;
    end;

    ProfileInspect.Reset();
end;

local function openProfileInspect(p19: userdata) -- Line: 182
    -- upvalues: u8 (ref), getMousePositionInLeaderboard (copy), ProfileInspect (copy)
    if not u8 then
        return;
    end;

    u8.Position = getMousePositionInLeaderboard();
    ProfileInspect.Populate(p19);
    u8.Visible = true;
end;

local function bindPlayerRowInteractions(u20: userdata, u21: userdata, p22: any) -- Line: 192
    -- upvalues: Color3_new_ret (copy), u8 (ref), getMousePositionInLeaderboard (copy), ProfileInspect (copy)
    local BackgroundColor3 = u20.BackgroundColor3;
    local u23 = false;

    local function applyBackgroundColor() -- Line: 200
        -- upvalues: u20 (copy), u23 (ref), BackgroundColor3 (copy), Color3_new_ret (ref)
        local v24;

        if u23 then
            v24 = BackgroundColor3:Lerp(Color3_new_ret, 0.2);
        else
            v24 = BackgroundColor3;
        end;

        u20.BackgroundColor3 = v24;
    end;

    u20.Active = true;
    p22:Add(u20.MouseEnter:Connect(function() -- Line: 207
        -- upvalues: u23 (ref), u20 (copy), BackgroundColor3 (copy), Color3_new_ret (ref)
        u23 = true;
        local v25;

        if u23 then
            v25 = BackgroundColor3:Lerp(Color3_new_ret, 0.2);
        else
            v25 = BackgroundColor3;
        end;

        u20.BackgroundColor3 = v25;
    end));
    p22:Add(u20.MouseLeave:Connect(function() -- Line: 211
        -- upvalues: u23 (ref), u20 (copy), BackgroundColor3 (copy), Color3_new_ret (ref)
        u23 = false;
        local v26;

        if u23 then
            v26 = BackgroundColor3:Lerp(Color3_new_ret, 0.2);
        else
            v26 = BackgroundColor3;
        end;

        u20.BackgroundColor3 = v26;
    end));
    p22:Add(u20.InputBegan:Connect(function(p27: userdata) -- Line: 215
        -- upvalues: u21 (copy), u8 (ref), getMousePositionInLeaderboard (ref), ProfileInspect (ref)
        if p27.UserInputType == Enum.UserInputType.MouseButton1 then
            if not u8 then
                return;
            end;

            u8.Position = getMousePositionInLeaderboard();
            ProfileInspect.Populate(u21);
            u8.Visible = true;
        end;
    end));
end;

local function getCharactersAlive(p28: table) -- Line: 222
    -- upvalues: RemoveFromArray (copy), Participants (copy)
    return RemoveFromArray(p28, function(p29, p30) -- Line: 223
        -- upvalues: Participants (ref)
        return not Participants.IsAlive(p30);
    end);
end;

local function updateAliveCounts() -- Line: 228
    -- upvalues: u7 (ref), getPlayersOnTeam (copy), RemoveFromArray (copy), Participants (copy)
    if not u7 then
        return;
    end;

    local Attribute = workspace:GetAttribute("Gamemode");

    if Attribute ~= "Bomb Defusal" and Attribute ~= "Hostage Rescue" then
        return;
    end;

    local v31 = getPlayersOnTeam("Counter-Terrorists");
    local v32 = getPlayersOnTeam("Terrorists");
    local v35 = RemoveFromArray(v31, function(p33, p34) -- Line: 223
        -- upvalues: Participants (ref)
        return not Participants.IsAlive(p34);
    end);
    local v38 = RemoveFromArray(v32, function(p36, p37) -- Line: 223
        -- upvalues: Participants (ref)
        return not Participants.IsAlive(p37);
    end);
    u7.Team.CT.Alive.Text = `ALIVE {tostring(#v35)}/{tostring(#v31)}`;
    u7.Team.T.Alive.Text = `ALIVE {tostring(#v38)}/{tostring(#v32)}`;
end;

local function observeAliveCountPlayer(p39: userdata) -- Line: 251
    -- upvalues: u13 (copy), Janitor (copy), updateAliveCounts (copy)
    local v40 = u13[p39];

    if v40 then
        v40:Destroy();
    end;

    local v41 = Janitor.new();
    u13[p39] = v41;
    v41:Add(p39:GetAttributeChangedSignal("Team"):Connect(updateAliveCounts));
    v41:Add(p39:GetAttributeChangedSignal("IsSpectating"):Connect(updateAliveCounts));
    v41:Add(p39:GetAttributeChangedSignal("Dead"):Connect(updateAliveCounts));
    v41:Add(p39:GetAttributeChangedSignal("Health"):Connect(updateAliveCounts));
    updateAliveCounts();
end;

local function updateGamemode() -- Line: 267
    -- upvalues: u7 (ref), u4 (copy), u2 (copy)
    local Attribute = workspace:GetAttribute("Gamemode");
    u7.Team.CT.Score.Visible = Attribute ~= "Deathmatch";
    u7.Team.T.Score.Visible = Attribute ~= "Deathmatch";
    local v42 = `{Attribute} | {workspace:GetAttribute("Map")}`;
    u7.TopInfo.Gamemode.Text = v42;
    u7.Top.TopInfo.Gamemode.Text = v42;
    local v43 = u4[Attribute];

    if not v43 then
        return;
    end;

    u7["Counter-Terrorists"].Position = v43.CounterTerroristsPosition;
    u7.Terrorists.Position = v43.TerroristsPosition;
    local Text = u7.Text;

    for _, v in ipairs(u2) do
        Text[v].Position = v43.Headers[v];
    end;

    u7["Counter-Terrorists"].Size = v43.Size;
    u7.Terrorists.Size = v43.Size;
    u7.DeathmatchDivider.Visible = v43.IsDeathmatch;
    u7.Team.Visible = not v43.IsDeathmatch;
end;

local function isCompetitiveRoundsMode() -- Line: 293
    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        return false;
    end;

    local Attribute = workspace:GetAttribute("Gamemode");

    return Attribute == "Bomb Defusal" and true or Attribute == "Hostage Rescue";
end;

local function getRoundFrame(p44: number) -- Line: 301
    -- upvalues: u7 (ref)
    if not u7 then
        return nil;
    end;

    local v45 = u7:FindFirstChild(p44 <= 12 and "Results1" or "Results2");

    return v45 and v45:FindFirstChild((tostring(p44))) or nil;
end;

local function isPostHalftime() -- Line: 309
    local Attribute = workspace:GetAttribute("HalftimeRound");
    local Attribute2 = workspace:GetAttribute("CurrentRound");
    local v46;

    if Attribute == nil or Attribute2 == nil then
        v46 = false;
    else
        v46 = Attribute < Attribute2;
    end;

    return v46;
end;

local function teamColor(p47: string) -- Line: 315
    -- upvalues: Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy)
    if p47 == "Counter-Terrorists" then
        return Color3_fromRGB_ret2;
    end;

    return Color3_fromRGB_ret3;
end;

local function getTeamSlotName(p48: number, p49: string) -- Line: 320
    local v50 = p49 == "Terrorists";
    local v51;

    if p48 <= 12 then
        local Attribute = workspace:GetAttribute("HalftimeRound");
        local Attribute2 = workspace:GetAttribute("CurrentRound");

        if Attribute == nil or Attribute2 == nil then
            v51 = false;
        else
            v51 = Attribute < Attribute2;
        end;
    else
        v51 = false;
    end;

    if v51 then
        v50 = not v50;
    end;

    return v50 and "Team1" or "Team2";
end;

local function decodeRoundResults() -- Line: 327
    -- upvalues: HttpService (copy)
    local Attribute = workspace:GetAttribute("RoundResults");

    if typeof(Attribute) ~= "string" or Attribute == "" then
        return {};
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute);

    return (not success or typeof(result) ~= "table") and {} or result;
end;

local function applyLossBonusVisibility() -- Line: 339
    -- upvalues: u7 (ref)
    if not u7 then
        return;
    end;

    local v52;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local Attribute = workspace:GetAttribute("Gamemode");
        v52 = Attribute == "Bomb Defusal" and true or Attribute == "Hostage Rescue";
    else
        v52 = false;
    end;

    for _, v in ipairs({ "LossBonus", "Results1", "Results2", "Spilter" }) do
        local v53 = u7:FindFirstChild(v);

        if v53 then
            v53.Visible = v52;
        end;
    end;
end;

local function paintLossBar(p54: userdata?, p55: number, p56) -- Line: 352
    -- upvalues: Color3_fromRGB_ret4 (copy)
    if not p54 then
        return;
    end;

    local math_clamp_ret = math.clamp(p55, 0, 4);

    for i = 1, 4 do
        local v57 = p54:FindFirstChild((tostring(i)));
        local v58;

        if v57 then
            v57.BackgroundColor3 = i <= math_clamp_ret and p56 and p56 or Color3_fromRGB_ret4;
            v58 = i;
        else
            v58 = i;
        end;
    end;
end;

local function applyLossBars() -- Line: 363
    -- upvalues: u7 (ref), paintLossBar (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret2 (copy)
    if not u7 then
        return;
    end;

    local LossBonus = u7:FindFirstChild("LossBonus");

    if not LossBonus then
        return;
    end;

    local v59 = workspace:GetAttribute("TLossStreak") or 0;
    local v60 = workspace:GetAttribute("CTLossStreak") or 0;
    paintLossBar(LossBonus:FindFirstChild("Bar1"), v59, Color3_fromRGB_ret3);
    paintLossBar(LossBonus:FindFirstChild("Bar2"), v60, Color3_fromRGB_ret2);
end;

local function resetRoundFrame(p61: userdata) -- Line: 375
    -- upvalues: Color3_fromRGB_ret5 (copy), u5 (copy)
    p61.BackgroundColor3 = Color3_fromRGB_ret5;

    for _, v in ipairs(u5) do
        local v62 = p61:FindFirstChild(v);

        if v62 then
            v62.Visible = false;
            v62.BackgroundTransparency = 0;
            local Icon = v62:FindFirstChild("Icon");

            if Icon then
                Icon.Image = "";
                Icon.ImageTransparency = 0;
            end;
        end;
    end;
end;

local function paintRoundResult(p63: userdata, p64: string, p65: string, p66: number) -- Line: 391
    -- upvalues: Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), u6 (copy)
    local v67;

    if p64 == "Counter-Terrorists" then
        v67 = Color3_fromRGB_ret2;
    else
        v67 = Color3_fromRGB_ret3;
    end;

    p63.BackgroundColor3 = v67;
    local v68 = p64 == "Terrorists";
    local v69;

    if p66 <= 12 then
        local Attribute = workspace:GetAttribute("HalftimeRound");
        local Attribute2 = workspace:GetAttribute("CurrentRound");

        if Attribute == nil or Attribute2 == nil then
            v69 = false;
        else
            v69 = Attribute < Attribute2;
        end;
    else
        v69 = false;
    end;

    if v69 then
        v68 = not v68;
    end;

    local v70 = v68 and "Team1" or "Team2";
    local v71 = p63:FindFirstChild(v70);
    local v72 = p63:FindFirstChild(v70 == "Team1" and "Team2" or "Team1");

    if v71 then
        v71.Visible = true;
        v71.BackgroundTransparency = 0;
        local v73;

        if p64 == "Counter-Terrorists" then
            v73 = Color3_fromRGB_ret2;
        else
            v73 = Color3_fromRGB_ret3;
        end;

        v71.BackgroundColor3 = v73;
        local Icon = v71:FindFirstChild("Icon");

        if Icon then
            Icon.Image = u6[p65] or "rbxassetid://70876442749327";
            local v74;

            if p64 == "Counter-Terrorists" then
                v74 = Color3_fromRGB_ret2;
            else
                v74 = Color3_fromRGB_ret3;
            end;

            Icon.ImageColor3 = v74;
            Icon.ImageTransparency = 0;
        end;
    end;

    if v72 then
        v72.Visible = false;
    end;
end;

local function hasRoundResult(p75: table, p76: number) -- Line: 418
    for _, v in ipairs(p75) do
        if v.round == p76 then
            return true;
        end;
    end;

    return false;
end;

local function applyTrophy(p77: string?, p78: table) -- Line: 427
    -- upvalues: u7 (ref), Color3_new_ret (copy)
    if not u7 then
        return;
    end;

    local Attribute = workspace:GetAttribute("RoundsToWin");

    if not Attribute then
        return;
    end;

    if p77 ~= "Counter-Terrorists" and p77 ~= "Terrorists" then
        return;
    end;

    local v79 = workspace:GetAttribute("CTScore") or 0;
    local v80 = workspace:GetAttribute("TScore") or 0;
    local v81 = v79 + v80 + (Attribute - (p77 == "Counter-Terrorists" and v79 and v79 or v80));

    if v81 < 1 or v81 > 24 then
        return;
    end;

    local v82;

    if u7 then
        local v83 = u7:FindFirstChild(v81 <= 12 and "Results1" or "Results2");

        if v83 then
            v82 = v83:FindFirstChild((tostring(v81))) or nil;
        else
            v82 = nil;
        end;
    else
        v82 = nil;
    end;

    if not v82 then
        return;
    end;

    local v84 = false;

    for _, v in ipairs(p78) do
        if v.round == v81 then
            v84 = true;
            break;
        end;
    end;

    if v84 then
        return;
    end;

    local v85 = p77 == "Terrorists";
    local v86;

    if v81 <= 12 then
        local Attribute2 = workspace:GetAttribute("HalftimeRound");
        local Attribute3 = workspace:GetAttribute("CurrentRound");

        if Attribute2 == nil or Attribute3 == nil then
            v86 = false;
        else
            v86 = Attribute2 < Attribute3;
        end;
    else
        v86 = false;
    end;

    if v86 then
        v85 = not v85;
    end;

    local v87 = v82:FindFirstChild(v85 and "Team1" or "Team2");

    if not v87 then
        return;
    end;

    v87.Visible = true;
    v87.BackgroundTransparency = 1;
    local Icon = v87:FindFirstChild("Icon");

    if Icon then
        Icon.Image = "rbxassetid://4857633530";
        Icon.ImageColor3 = Color3_new_ret;
        Icon.ImageTransparency = 0;
    end;
end;

local function refreshResults() -- Line: 469
    -- upvalues: u7 (ref), resetRoundFrame (copy), decodeRoundResults (copy), paintRoundResult (copy), Color3_fromRGB_ret6 (copy), applyTrophy (copy), LocalPlayer (copy)
    if not u7 then
        return;
    end;

    local v88;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local Attribute = workspace:GetAttribute("Gamemode");
        v88 = Attribute == "Bomb Defusal" and true or Attribute == "Hostage Rescue";
    else
        v88 = false;
    end;

    if not v88 then
        return;
    end;

    for i = 1, 24 do
        local v89;

        if u7 then
            local v90 = u7:FindFirstChild(i <= 12 and "Results1" or "Results2");

            if v90 then
                v89 = v90:FindFirstChild((tostring(i))) or nil;
            else
                v89 = nil;
            end;
        else
            v89 = nil;
        end;

        local v91;

        if v89 then
            resetRoundFrame(v89);
            v91 = i;
        else
            v91 = i;
        end;
    end;

    local v92 = decodeRoundResults();

    for _, v in ipairs(v92) do
        local round = v.round;
        local v93;

        if u7 then
            local v94 = u7:FindFirstChild(round <= 12 and "Results1" or "Results2");
            v93 = v94 and v94:FindFirstChild((tostring(round))) or nil;
        else
            v93 = nil;
        end;

        if v93 then
            paintRoundResult(v93, v.winner, v.winType, v.round);
        end;
    end;

    local Attribute = workspace:GetAttribute("CurrentRound");

    if Attribute and (Attribute >= 1 and Attribute <= 24) then
        local v95 = false;

        for _, v in ipairs(v92) do
            if v.round == Attribute then
                v95 = true;
                break;
            end;
        end;

        if not v95 then
            local v96;

            if u7 then
                local v97 = u7:FindFirstChild(Attribute <= 12 and "Results1" or "Results2");
                v96 = v97 and v97:FindFirstChild((tostring(Attribute))) or nil;
            else
                v96 = nil;
            end;

            if v96 then
                v96.BackgroundColor3 = Color3_fromRGB_ret6;
            end;
        end;
    end;

    applyTrophy(LocalPlayer:GetAttribute("Team"), v92);
end;

local function isTextObject(p98: userdata) -- Line: 512
    return p98:IsA("TextLabel") or p98:IsA("TextButton");
end;

local function isImageObject(p99: userdata) -- Line: 516
    return p99:IsA("ImageLabel") or p99:IsA("ImageButton");
end;

local function storeTransparencyRecursive(p100: userdata, p101: table) -- Line: 521
    -- upvalues: storeTransparencyRecursive (copy)
    if p100:IsA("Frame") then
        p101[p100] = {
            BackgroundTransparency = p100.BackgroundTransparency
        };
    elseif p100:IsA("TextLabel") or p100:IsA("TextButton") then
        p101[p100] = {
            BackgroundTransparency = p100.BackgroundTransparency,
            TextTransparency = p100.TextTransparency
        };
    elseif p100:IsA("ImageLabel") or p100:IsA("ImageButton") then
        p101[p100] = {
            BackgroundTransparency = p100.BackgroundTransparency,
            ImageTransparency = p100.ImageTransparency
        };
    end;

    for _, child in p100:GetChildren() do
        storeTransparencyRecursive(child, p101);
    end;
end;

local function setDeadTransparencyRecursive(p102: userdata) -- Line: 544
    -- upvalues: setDeadTransparencyRecursive (copy)
    if p102:IsA("Frame") then
        p102.BackgroundTransparency = 1;
    elseif p102:IsA("TextLabel") or p102:IsA("TextButton") then
        p102.TextTransparency = 0.5;
        p102.BackgroundTransparency = 1;
    elseif p102:IsA("ImageLabel") or p102:IsA("ImageButton") then
        p102.ImageTransparency = 0.5;
        p102.BackgroundTransparency = 1;
    end;

    for _, child in ipairs(p102:GetChildren()) do
        setDeadTransparencyRecursive(child);
    end;
end;

local function restoreTransparencyRecursive(p103: userdata, p104: table) -- Line: 560
    -- upvalues: restoreTransparencyRecursive (copy)
    local v105 = p104[p103];

    if v105 then
        if p103:IsA("Frame") then
            p103.BackgroundTransparency = v105.BackgroundTransparency;
        elseif p103:IsA("TextLabel") or p103:IsA("TextButton") then
            p103.TextTransparency = v105.TextTransparency;
            p103.BackgroundTransparency = v105.BackgroundTransparency;
        elseif p103:IsA("ImageLabel") or p103:IsA("ImageButton") then
            p103.ImageTransparency = v105.ImageTransparency;
            p103.BackgroundTransparency = v105.BackgroundTransparency;
        end;
    end;

    for _, child in ipairs(p103:GetChildren()) do
        restoreTransparencyRecursive(child, p104);
    end;
end;

local function releaseParticipant(p106: userdata) -- Line: 581
    -- upvalues: u13 (copy), u1 (copy), updateAliveCounts (copy)
    local v107 = u13[p106];
    u13[p106] = nil;

    if v107 then
        v107:Destroy();
    end;

    u1.cleanup(p106);
    updateAliveCounts();
end;

function u1.createTemplate(u108: userdata, u109: any, p110: any) -- Line: 594
    -- upvalues: ReplicatedStorage (copy), Participants (copy), GetBadgeIcon (copy), storeTransparencyRecursive (copy), LocalPlayer (copy), Color3_fromRGB_ret (copy), bindPlayerRowInteractions (copy), Observers (copy), setDeadTransparencyRecursive (copy), restoreTransparencyRecursive (copy), DataController (copy), HttpService (copy)
    local u111 = ReplicatedStorage.Assets.UI.Leaderboard[u109]:Clone();
    u111.Player.Image = Participants.HeadshotImage(u108);
    u111.PlayerName.Text = `{Participants.DisplayName(u108)} (@{Participants.Name(u108)})`;
    local v112 = GetBadgeIcon(u108, u109);
    u111.Badge.Visible = v112 ~= "";
    u111.Badge.Image = v112;
    u111.Assists.Amount.Text = "0";
    u111.Deaths.Amount.Text = "0";
    u111.Score.Amount.Text = "0";
    u111.Kills.Amount.Text = "0";
    u111.MVPs.Amount.Text = "0";
    u111.Money.Amount.Text = "";
    u111.LayoutOrder = 1;
    u111.Ping.Text = "0";
    local u113 = {
        [u111] = {
            BackgroundTransparency = u111.BackgroundTransparency
        }
    };

    for _, child in u111:GetChildren() do
        storeTransparencyRecursive(child, u113);
    end;

    if u108 == LocalPlayer then
        u111.BackgroundColor3 = Color3_fromRGB_ret;
    end;

    bindPlayerRowInteractions(u111, u108, p110);

    local function isTeammate() -- Line: 635
        -- upvalues: u108 (copy), LocalPlayer (ref)
        return u108:GetAttribute("Team") == LocalPlayer:GetAttribute("Team");
    end;

    local function updateMoneyVisibility() -- Line: 642
        -- upvalues: u108 (copy), LocalPlayer (ref), u111 (copy)
        local Attribute = workspace:GetAttribute("Gamemode");

        if u108:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") and Attribute ~= "Deathmatch" then
            u111.Money.Amount.Text = "";

            return;
        end;

        local Attribute2 = u108:GetAttribute("Money");
        u111.Money.Amount.Text = Attribute2 == nil and "" or (`${tostring(Attribute2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}` or "");
    end;

    p110:Add(Observers.observeAttribute(u108, "Money", updateMoneyVisibility));
    updateMoneyVisibility();
    local u114 = u111.Player:FindFirstChildOfClass("UIStroke");

    local function updateTeamColors() -- Line: 656
        -- upvalues: u114 (copy), u108 (copy), LocalPlayer (ref)
        if not u114 then
            return;
        end;

        if u108:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
            u114.Enabled = false;

            return;
        end;

        local Attribute = u108:GetAttribute("CompetitivePlayerColor");

        if not Attribute then
            u114.Enabled = false;

            return;
        end;

        u114.Color = Attribute;
        u114.Enabled = true;
    end;

    if u114 then
        if u108:GetAttribute("Team") == LocalPlayer:GetAttribute("Team") then
            local Attribute = u108:GetAttribute("CompetitivePlayerColor");

            if Attribute then
                u114.Color = Attribute;
                u114.Enabled = true;
            else
                u114.Enabled = false;
            end;
        else
            u114.Enabled = false;
        end;
    end;

    local function updateTeamDependentState() -- Line: 679
        -- upvalues: updateMoneyVisibility (copy), u114 (copy), u108 (copy), LocalPlayer (ref)
        updateMoneyVisibility();

        if not u114 then
            return;
        end;

        if u108:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
            u114.Enabled = false;

            return;
        end;

        local Attribute = u108:GetAttribute("CompetitivePlayerColor");

        if not Attribute then
            u114.Enabled = false;

            return;
        end;

        u114.Color = Attribute;
        u114.Enabled = true;
    end;

    p110:Add(Observers.observeAttribute(LocalPlayer, "Team", updateTeamDependentState));
    p110:Add(Observers.observeAttribute(u108, "Team", updateTeamDependentState));
    p110:Add(Observers.observeAttribute(u108, "CompetitivePlayerColor", updateTeamColors));
    p110:Add(Observers.observeAttribute(u108, "Kills", function(p115) -- Line: 689
        -- upvalues: u111 (copy)
        u111.Kills.Amount.Text = tostring(p115):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        u111.LayoutOrder = -p115;
    end));

    for _, v in ipairs({ "Deaths", "Assists", "Score", "MVPs" }) do
        p110:Add(Observers.observeAttribute(u108, v, function(p116) -- Line: 696
            -- upvalues: u111 (copy), v (copy)
            u111[v].Amount.Text = tostring(p116):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        end));
    end;

    p110:Add(Observers.observeAttribute(u108, "Ping", function(p117) -- Line: 702
        -- upvalues: u111 (copy)
        u111.Ping.Text = p117;
    end));

    local function updateDeadSymbol() -- Line: 707
        -- upvalues: u108 (copy), Participants (ref), u111 (copy), setDeadTransparencyRecursive (ref), u113 (copy), restoreTransparencyRecursive (ref)
        local v118 = u108:GetAttribute("IsSpectating") == true;
        local v119 = not Participants.IsAlive(u108) or v118;

        if u111:FindFirstChild("Dead") then
            u111.Dead.Visible = v119;
        end;

        if not v119 then
            local v120 = u113[u111];

            if v120 then
                u111.BackgroundTransparency = v120.BackgroundTransparency;
            end;

            for _, child in ipairs(u111:GetChildren()) do
                restoreTransparencyRecursive(child, u113);
            end;

            return;
        end;

        if u111:FindFirstChild("Bomb") then
            u111.Bomb.Visible = false;
        end;

        if u111:FindFirstChild("DefuseKit") then
            u111.DefuseKit.Visible = false;
        end;

        u111.BackgroundTransparency = 1;

        for _, child in ipairs(u111:GetChildren()) do
            setDeadTransparencyRecursive(child);
        end;
    end;

    local u121 = nil;
    p110:Add(Observers.observeAttribute(u108, "IsSpectating", updateDeadSymbol));

    local function updateLifeState() -- Line: 743
        -- upvalues: updateDeadSymbol (copy), u121 (ref)
        updateDeadSymbol();

        if u121 then
            u121();
        end;
    end;

    p110:Add(u108:GetAttributeChangedSignal("Dead"):Connect(updateLifeState));
    p110:Add(u108:GetAttributeChangedSignal("Health"):Connect(updateLifeState));
    p110:Add(u108:GetAttributeChangedSignal("CompetitivePlayerColor"):Connect(updateTeamColors));
    updateDeadSymbol();

    if not Participants.IsBot(u108) then
        local u123 = DataController.CreateListener(u108, `Loadout.{u109}.Equipped.Equipped Badge`, function() -- Line: 756
            -- upvalues: GetBadgeIcon (ref), u108 (copy), u109 (copy), u111 (copy)
            local v122 = GetBadgeIcon(u108, u109);
            u111.Badge.Image = v122;
            u111.Badge.Visible = v122 ~= "";
        end);
        p110:Add(function() -- Line: 763
            -- upvalues: DataController (ref), u108 (copy), u109 (copy), u123 (copy)
            DataController.RemoveListener(u108, `Loadout.{u109}.Equipped.Equipped Badge`, u123);
        end);
    end;

    u121 = function() -- Line: 769
        -- upvalues: u108 (copy), LocalPlayer (ref), Participants (ref), u109 (copy), u111 (copy), HttpService (ref)
        local v124 = u108:GetAttribute("Team") == LocalPlayer:GetAttribute("Team");
        local v125 = u108:GetAttribute("IsSpectating") == true;
        local v126 = Participants.IsAlive(u108) and not v125;

        if u109 == "Terrorists" then
            local Bomb = u111:FindFirstChild("Bomb");

            if Bomb then
                local Attribute = u108:GetAttribute("Slot5");

                if not Attribute then
                    Bomb.Visible = false;

                    return;
                end;

                local v127 = HttpService:JSONDecode(Attribute);

                if v124 then
                    if v126 then
                        if v127 then
                            v127 = v127.Weapon == "C4";
                        end;
                    else
                        v127 = v126;
                    end;
                else
                    v127 = v124;
                end;

                Bomb.Visible = v127;
            end;
        else
            local v128 = u109 == "Counter-Terrorists" and u111:FindFirstChild("DefuseKit");

            if v128 then
                local Attribute = u108:GetAttribute("HasDefuseKit");

                if v124 then
                    if v126 then
                        v126 = Attribute == true;
                    end;
                else
                    v126 = v124;
                end;

                v128.Visible = v126;
            end;
        end;
    end;

    if u109 == "Terrorists" then
        p110:Add(Observers.observeAttribute(u108, "Slot5", function() -- Line: 802
            -- upvalues: u121 (ref), u111 (copy)
            u121();

            return function() -- Line: 805
                -- upvalues: u111 (ref)
                if u111:FindFirstChild("Bomb") then
                    u111.Bomb.Visible = false;
                end;
            end;
        end));
    elseif u109 == "Counter-Terrorists" then
        p110:Add(Observers.observeAttribute(u108, "HasDefuseKit", function() -- Line: 813
            -- upvalues: u121 (ref), u111 (copy)
            u121();

            return function() -- Line: 815
                -- upvalues: u111 (ref)
                if u111:FindFirstChild("DefuseKit") then
                    u111.DefuseKit.Visible = false;
                end;
            end;
        end));
    end;

    p110:Add(Observers.observeAttribute(LocalPlayer, "Team", u121));
    u121();

    return u111;
end;

function u1.openFrame() -- Line: 832
    -- upvalues: EndScreenController (copy), GameState (copy), u7 (ref), u1 (copy), u11 (ref)
    if EndScreenController.IsActive() or GameState.GetState() == "Map Voting" then
        if u7 and u7.Visible then
            u1.closeFrame();
        end;

        return;
    end;

    u11 = false;
    u7.Visible = true;
end;

function u1.IsOpen() -- Line: 844
    -- upvalues: u7 (ref)
    local v129;

    if u7 == nil then
        v129 = false;
    else
        v129 = u7.Visible;
    end;

    return v129;
end;

function u1.closeFrame() -- Line: 848
    -- upvalues: u7 (ref), u11 (ref), u8 (ref), u9 (ref), ProfileInspect (copy), CameraController (copy)
    u7.Visible = false;
    u11 = false;

    if u8 then
        u8.Visible = false;

        if u9 then
            u8.Position = u9;
        end;

        ProfileInspect.Reset();
    end;

    CameraController.setForceLockOverride("Leaderboard", false);
end;

function u1.IsRightClickUnlockActive() -- Line: 855
    -- upvalues: u11 (ref)
    return u11;
end;

function u1.characterAdded(u130: userdata, u131: any) -- Line: 859
    -- upvalues: Profiler (copy), Janitor (copy), u1 (copy), u7 (ref), u12 (copy)
    Profiler.scope("UI.Leaderboard.CharacterAdded", function() -- Line: 860
        -- upvalues: Janitor (ref), u1 (ref), u130 (copy), u131 (copy), u7 (ref), u12 (ref)
        local v132 = Janitor.new();
        u1.cleanup(u130);
        local u133 = u1.createTemplate(u130, u131, v132);
        u133.Parent = u7:FindFirstChild(u131);
        v132:Add(function() -- Line: 865
            -- upvalues: u133 (copy)
            u133:Destroy();
        end);
        u12[u130] = v132;
    end);
end;

function u1.observePlayer(u134: userdata) -- Line: 872
    -- upvalues: Observers (copy), u1 (copy)
    Observers.observeAttribute(u134, "Team", function(p135) -- Line: 873
        -- upvalues: u1 (ref), u134 (copy)
        if p135 == "Terrorists" or p135 == "Counter-Terrorists" then
            u1.characterAdded(u134, p135);
        end;

        return function() -- Line: 879
            -- upvalues: u1 (ref), u134 (ref)
            u1.cleanup(u134);
        end;
    end);
end;

function u1.cleanup(p136: userdata) -- Line: 885
    -- upvalues: u12 (copy)
    local v137 = u12[p136];
    u12[p136] = nil;

    if v137 then
        v137:Destroy();
    end;
end;

function u1.Initialize(p138, p139) -- Line: 896
    -- upvalues: u7 (ref), u8 (ref), u9 (ref), ProfileInspect (copy), u10 (ref), UserInputService (copy), u11 (ref), CameraController (copy), Observers (copy), updateGamemode (copy), updateAliveCounts (copy), applyLossBonusVisibility (copy), applyLossBars (copy), refreshResults (copy), u1 (copy), LocalPlayer (copy), GetTimerFormat (copy), observeAliveCountPlayer (copy), u13 (copy), Participants (copy)
    u7 = p139;
    u8 = p139:FindFirstChild("ProfileInspect");

    if u8 then
        u9 = u8.Position;
        u8.Visible = false;
        ProfileInspect.Bind(u8);
    end;

    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;

    u10 = UserInputService.InputBegan:Connect(function(p140: userdata) -- Line: 911
        -- upvalues: u7 (ref), u11 (ref), CameraController (ref)
        if p140.UserInputType == Enum.UserInputType.MouseButton2 and (u7 and u7.Visible) then
            u11 = true;
            CameraController.setForceLockOverride("Leaderboard", true);
        end;
    end);
    Observers.observeAttribute(workspace, "Gamemode", function() -- Line: 919
        -- upvalues: updateGamemode (ref), updateAliveCounts (ref), applyLossBonusVisibility (ref), applyLossBars (ref), refreshResults (ref)
        updateGamemode();
        updateAliveCounts();
        applyLossBonusVisibility();
        applyLossBars();
        refreshResults();
    end);
    Observers.observeAttribute(workspace, "Map", updateGamemode);
    Observers.observeAttribute(workspace, "ServerGamemode", function() -- Line: 927
        -- upvalues: applyLossBonusVisibility (ref), applyLossBars (ref), refreshResults (ref)
        applyLossBonusVisibility();
        applyLossBars();
        refreshResults();
    end);
    Observers.observeAttribute(workspace, "GameState", function(p141: string?) -- Line: 932
        -- upvalues: u1 (ref), updateAliveCounts (ref)
        if p141 == "Map Voting" then
            u1.closeFrame();
        end;

        updateAliveCounts();
    end);
    Observers.observeAttribute(workspace, "CTScore", function(p142) -- Line: 940
        -- upvalues: u7 (ref), refreshResults (ref)
        u7.Team.CT.Score.Text = tostring(p142);
        refreshResults();

        return function() -- Line: 943
            -- upvalues: u7 (ref)
            u7.Team.CT.Score.Text = "";
        end;
    end);
    Observers.observeAttribute(workspace, "TScore", function(p143) -- Line: 949
        -- upvalues: u7 (ref), refreshResults (ref)
        u7.Team.T.Score.Text = tostring(p143);
        refreshResults();

        return function() -- Line: 952
            -- upvalues: u7 (ref)
            u7.Team.T.Score.Text = "";
        end;
    end);
    Observers.observeAttribute(workspace, "RoundResults", refreshResults);
    Observers.observeAttribute(workspace, "CurrentRound", refreshResults);
    Observers.observeAttribute(workspace, "RoundsToWin", refreshResults);
    Observers.observeAttribute(workspace, "HalftimeRound", refreshResults);
    Observers.observeAttribute(workspace, "CTLossStreak", applyLossBars);
    Observers.observeAttribute(workspace, "TLossStreak", applyLossBars);
    Observers.observeAttribute(LocalPlayer, "Team", refreshResults);
    applyLossBonusVisibility();
    applyLossBars();
    refreshResults();
    Observers.observeAttribute(workspace, "Timer", function(p144) -- Line: 976
        -- upvalues: GetTimerFormat (ref), u7 (ref)
        local v145 = GetTimerFormat(p144);
        u7.TopInfo.Timer.Text = v145;
        u7.Top.TopInfo.Timer.Text = v145;
    end);
    Observers.observePlayer(function(u146: userdata) -- Line: 983
        -- upvalues: u1 (ref), observeAliveCountPlayer (ref), u13 (ref), updateAliveCounts (ref)
        u1.observePlayer(u146);
        observeAliveCountPlayer(u146);

        return function() -- Line: 986
            -- upvalues: u146 (copy), u13 (ref), u1 (ref), updateAliveCounts (ref)
            local v147 = u146;
            local v148 = u13[v147];
            u13[v147] = nil;

            if v148 then
                v148:Destroy();
            end;

            u1.cleanup(v147);
            updateAliveCounts();
        end;
    end);
    Participants.Observe(function(p149: userdata) -- Line: 992
        -- upvalues: Participants (ref), u1 (ref), observeAliveCountPlayer (ref)
        if Participants.IsBot(p149) then
            u1.observePlayer(p149);
            observeAliveCountPlayer(p149);
        end;
    end, function(p150: userdata) -- Line: 997
        -- upvalues: Participants (ref), u13 (ref), u1 (ref), updateAliveCounts (ref)
        if Participants.IsBot(p150) then
            local v151 = u13[p150];
            u13[p150] = nil;

            if v151 then
                v151:Destroy();
            end;

            u1.cleanup(p150);
            updateAliveCounts();
        end;
    end);
end;

function u1.Start() -- Line: 1004
    -- upvalues: clearFrame (copy), u7 (ref), updateAliveCounts (copy)
    clearFrame((u7:WaitForChild("Counter-Terrorists")));
    clearFrame((u7:WaitForChild("Terrorists")));
    updateAliveCounts();
end;

return u1;