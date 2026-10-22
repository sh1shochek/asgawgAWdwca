-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard
-- Decompile time: 20.22 ms

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
local Router = require(ReplicatedStorage.Database.Security.Router);
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
local v4 = {
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
};
local u5 = {
    Deathmatch = v4,
    ["Bomb Defusal"] = v3,
    ["Hostage Rescue"] = v3,
    ["Zombie Survival"] = v4
};
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_fromRGB_ret = Color3.fromRGB(139, 128, 98);
local Color3_fromRGB_ret2 = Color3.fromRGB(165, 183, 212);
local Color3_fromRGB_ret3 = Color3.fromRGB(219, 199, 126);
local Color3_fromRGB_ret4 = Color3.fromRGB(81, 81, 81);
local Color3_fromRGB_ret5 = Color3.fromRGB(95, 95, 95);
local Color3_fromRGB_ret6 = Color3.fromRGB(255, 255, 255);
local u6 = { "Team1", "Team2" };
local u7 = {
    BombDefuse = "rbxassetid://138772806705472",
    BombExplode = "rbxassetid://97682949239067",
    BombObjective = "rbxassetid://97682949239067",
    Elimination = "rbxassetid://70876442749327",
    TimeExpiration = "rbxassetid://96043369049959",
    HostageRescue = "rbxassetid://138772806705472"
};
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = false;
local u13 = {};
local u14 = {};

local function commaNumber(p15: number) -- Line: 133
    return tostring(p15):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function clearFrame(p16: userdata) -- Line: 137
    for _, child in ipairs(p16:GetChildren()) do
        if child.ClassName == "Frame" then
            child:Destroy();
        end;
    end;
end;

local function getPlayersOnTeam(p17) -- Line: 145
    -- upvalues: Participants (copy)
    local v18 = {};

    for _, v in ipairs((Participants.GetAll())) do
        if v:GetAttribute("Team") == p17 then
            table.insert(v18, v);
        end;
    end;

    return v18;
end;

local function lightenTowardWhite(p19) -- Line: 157
    -- upvalues: Color3_new_ret (copy)
    return p19:Lerp(Color3_new_ret, 0.2);
end;

local function getMousePositionInLeaderboard() -- Line: 161
    -- upvalues: UserInputService (copy), GuiService (copy), u8 (ref)
    local MouseLocation = UserInputService:GetMouseLocation();
    local GuiInset = GuiService:GetGuiInset();
    local AbsolutePosition = u8.AbsolutePosition;
    local AbsoluteSize = u8.AbsoluteSize;

    return UDim2.fromScale((MouseLocation.X - GuiInset.X - AbsolutePosition.X) / AbsoluteSize.X, (MouseLocation.Y - GuiInset.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
end;

local function resetProfileInspect() -- Line: 174
    -- upvalues: u9 (ref), u10 (ref), ProfileInspect (copy)
    if not u9 then
        return;
    end;

    u9.Visible = false;

    if u10 then
        u9.Position = u10;
    end;

    ProfileInspect.Reset();
end;

local function openProfileInspect(p20: userdata) -- Line: 186
    -- upvalues: u9 (ref), getMousePositionInLeaderboard (copy), ProfileInspect (copy)
    if not u9 then
        return;
    end;

    u9.Position = getMousePositionInLeaderboard();
    ProfileInspect.Populate(p20);
    u9.Visible = true;
end;

local function bindPlayerRowInteractions(u21: userdata, u22: userdata, p23: any) -- Line: 196
    -- upvalues: Color3_new_ret (copy), u9 (ref), getMousePositionInLeaderboard (copy), ProfileInspect (copy)
    local BackgroundColor3 = u21.BackgroundColor3;
    local u24 = false;

    local function applyBackgroundColor() -- Line: 204
        -- upvalues: u21 (copy), u24 (ref), BackgroundColor3 (copy), Color3_new_ret (ref)
        local v25;

        if u24 then
            v25 = BackgroundColor3:Lerp(Color3_new_ret, 0.2);
        else
            v25 = BackgroundColor3;
        end;

        u21.BackgroundColor3 = v25;
    end;

    u21.Active = true;
    p23:Add(u21.MouseEnter:Connect(function() -- Line: 211
        -- upvalues: u24 (ref), u21 (copy), BackgroundColor3 (copy), Color3_new_ret (ref)
        u24 = true;
        local v26;

        if u24 then
            v26 = BackgroundColor3:Lerp(Color3_new_ret, 0.2);
        else
            v26 = BackgroundColor3;
        end;

        u21.BackgroundColor3 = v26;
    end));
    p23:Add(u21.MouseLeave:Connect(function() -- Line: 215
        -- upvalues: u24 (ref), u21 (copy), BackgroundColor3 (copy), Color3_new_ret (ref)
        u24 = false;
        local v27;

        if u24 then
            v27 = BackgroundColor3:Lerp(Color3_new_ret, 0.2);
        else
            v27 = BackgroundColor3;
        end;

        u21.BackgroundColor3 = v27;
    end));
    p23:Add(u21.InputBegan:Connect(function(p28: userdata) -- Line: 219
        -- upvalues: u22 (copy), u9 (ref), getMousePositionInLeaderboard (ref), ProfileInspect (ref)
        if p28.UserInputType == Enum.UserInputType.MouseButton1 then
            if not u9 then
                return;
            end;

            u9.Position = getMousePositionInLeaderboard();
            ProfileInspect.Populate(u22);
            u9.Visible = true;
        end;
    end));
end;

local function getCharactersAlive(p29: table) -- Line: 226
    -- upvalues: RemoveFromArray (copy), Participants (copy)
    return RemoveFromArray(p29, function(p30, p31) -- Line: 227
        -- upvalues: Participants (ref)
        return not Participants.IsAlive(p31);
    end);
end;

local function updateAliveCounts() -- Line: 232
    -- upvalues: u8 (ref), getPlayersOnTeam (copy), RemoveFromArray (copy), Participants (copy)
    if not u8 then
        return;
    end;

    local Attribute = workspace:GetAttribute("Gamemode");

    if Attribute ~= "Bomb Defusal" and Attribute ~= "Hostage Rescue" then
        return;
    end;

    local v32 = getPlayersOnTeam("Counter-Terrorists");
    local v33 = getPlayersOnTeam("Terrorists");
    local v36 = RemoveFromArray(v32, function(p34, p35) -- Line: 227
        -- upvalues: Participants (ref)
        return not Participants.IsAlive(p35);
    end);
    local v39 = RemoveFromArray(v33, function(p37, p38) -- Line: 227
        -- upvalues: Participants (ref)
        return not Participants.IsAlive(p38);
    end);
    u8.Team.CT.Alive.Text = `ALIVE {tostring(#v36)}/{tostring(#v32)}`;
    u8.Team.T.Alive.Text = `ALIVE {tostring(#v39)}/{tostring(#v33)}`;
end;

local function observeAliveCountPlayer(p40: userdata) -- Line: 255
    -- upvalues: u14 (copy), Janitor (copy), updateAliveCounts (copy)
    local v41 = u14[p40];

    if v41 then
        v41:Destroy();
    end;

    local v42 = Janitor.new();
    u14[p40] = v42;
    v42:Add(p40:GetAttributeChangedSignal("Team"):Connect(updateAliveCounts));
    v42:Add(p40:GetAttributeChangedSignal("IsSpectating"):Connect(updateAliveCounts));
    v42:Add(p40:GetAttributeChangedSignal("Dead"):Connect(updateAliveCounts));
    v42:Add(p40:GetAttributeChangedSignal("Health"):Connect(updateAliveCounts));
    updateAliveCounts();
end;

local function updateGamemode() -- Line: 271
    -- upvalues: u8 (ref), u5 (copy), u2 (copy)
    local Attribute = workspace:GetAttribute("Gamemode");
    u8.Team.CT.Score.Visible = Attribute ~= "Deathmatch";
    u8.Team.T.Score.Visible = Attribute ~= "Deathmatch";
    local v43 = `{Attribute} | {workspace:GetAttribute("Map")}`;
    u8.TopInfo.Gamemode.Text = v43;
    u8.Top.TopInfo.Gamemode.Text = v43;
    local v44 = u5[Attribute];

    if not v44 then
        return;
    end;

    u8["Counter-Terrorists"].Position = v44.CounterTerroristsPosition;
    u8.Terrorists.Position = v44.TerroristsPosition;
    local Text = u8.Text;

    for _, v in ipairs(u2) do
        Text[v].Position = v44.Headers[v];
    end;

    u8["Counter-Terrorists"].Size = v44.Size;
    u8.Terrorists.Size = v44.Size;
    u8.DeathmatchDivider.Visible = v44.IsDeathmatch;
    u8.Team.Visible = not v44.IsDeathmatch;
end;

local function isCompetitiveRoundsMode() -- Line: 297
    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        return false;
    end;

    local Attribute = workspace:GetAttribute("Gamemode");

    return Attribute == "Bomb Defusal" and true or Attribute == "Hostage Rescue";
end;

local function getRoundFrame(p45: number) -- Line: 305
    -- upvalues: u8 (ref)
    if not u8 then
        return nil;
    end;

    local v46 = u8:FindFirstChild(p45 <= 12 and "Results1" or "Results2");

    return v46 and v46:FindFirstChild((tostring(p45))) or nil;
end;

local function isPostHalftime() -- Line: 313
    local Attribute = workspace:GetAttribute("HalftimeRound");
    local Attribute2 = workspace:GetAttribute("CurrentRound");
    local v47;

    if Attribute == nil or Attribute2 == nil then
        v47 = false;
    else
        v47 = Attribute < Attribute2;
    end;

    return v47;
end;

local function teamColor(p48: string) -- Line: 319
    -- upvalues: Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy)
    if p48 == "Counter-Terrorists" then
        return Color3_fromRGB_ret2;
    end;

    return Color3_fromRGB_ret3;
end;

local function getTeamSlotName(p49: number, p50: string) -- Line: 324
    local v51 = p50 == "Terrorists";
    local v52;

    if p49 <= 12 then
        local Attribute = workspace:GetAttribute("HalftimeRound");
        local Attribute2 = workspace:GetAttribute("CurrentRound");

        if Attribute == nil or Attribute2 == nil then
            v52 = false;
        else
            v52 = Attribute < Attribute2;
        end;
    else
        v52 = false;
    end;

    if v52 then
        v51 = not v51;
    end;

    return v51 and "Team1" or "Team2";
end;

local function decodeRoundResults() -- Line: 331
    -- upvalues: HttpService (copy)
    local Attribute = workspace:GetAttribute("RoundResults");

    if typeof(Attribute) ~= "string" or Attribute == "" then
        return {};
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute);

    return (not success or typeof(result) ~= "table") and {} or result;
end;

local function applyLossBonusVisibility() -- Line: 343
    -- upvalues: u8 (ref)
    if not u8 then
        return;
    end;

    local v53;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local Attribute = workspace:GetAttribute("Gamemode");
        v53 = Attribute == "Bomb Defusal" and true or Attribute == "Hostage Rescue";
    else
        v53 = false;
    end;

    for _, v in ipairs({ "LossBonus", "Results1", "Results2", "Spilter" }) do
        local v54 = u8:FindFirstChild(v);

        if v54 then
            v54.Visible = v53;
        end;
    end;
end;

local function paintLossBar(p55: userdata?, p56: number, p57) -- Line: 356
    -- upvalues: Color3_fromRGB_ret4 (copy)
    if not p55 then
        return;
    end;

    local math_clamp_ret = math.clamp(p56, 0, 4);

    for i = 1, 4 do
        local v58 = p55:FindFirstChild((tostring(i)));
        local v59;

        if v58 then
            v58.BackgroundColor3 = i <= math_clamp_ret and p57 and p57 or Color3_fromRGB_ret4;
            v59 = i;
        else
            v59 = i;
        end;
    end;
end;

local function applyLossBars() -- Line: 367
    -- upvalues: u8 (ref), paintLossBar (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret2 (copy)
    if not u8 then
        return;
    end;

    local LossBonus = u8:FindFirstChild("LossBonus");

    if not LossBonus then
        return;
    end;

    local v60 = workspace:GetAttribute("TLossStreak") or 0;
    local v61 = workspace:GetAttribute("CTLossStreak") or 0;
    paintLossBar(LossBonus:FindFirstChild("Bar1"), v60, Color3_fromRGB_ret3);
    paintLossBar(LossBonus:FindFirstChild("Bar2"), v61, Color3_fromRGB_ret2);
end;

local function resetRoundFrame(p62: userdata) -- Line: 379
    -- upvalues: Color3_fromRGB_ret5 (copy), u6 (copy)
    p62.BackgroundColor3 = Color3_fromRGB_ret5;

    for _, v in ipairs(u6) do
        local v63 = p62:FindFirstChild(v);

        if v63 then
            v63.Visible = false;
            v63.BackgroundTransparency = 0;
            local Icon = v63:FindFirstChild("Icon");

            if Icon then
                Icon.Image = "";
                Icon.ImageTransparency = 0;
            end;
        end;
    end;
end;

local function paintRoundResult(p64: userdata, p65: string, p66: string, p67: number) -- Line: 395
    -- upvalues: Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), u7 (copy)
    local v68;

    if p65 == "Counter-Terrorists" then
        v68 = Color3_fromRGB_ret2;
    else
        v68 = Color3_fromRGB_ret3;
    end;

    p64.BackgroundColor3 = v68;
    local v69 = p65 == "Terrorists";
    local v70;

    if p67 <= 12 then
        local Attribute = workspace:GetAttribute("HalftimeRound");
        local Attribute2 = workspace:GetAttribute("CurrentRound");

        if Attribute == nil or Attribute2 == nil then
            v70 = false;
        else
            v70 = Attribute < Attribute2;
        end;
    else
        v70 = false;
    end;

    if v70 then
        v69 = not v69;
    end;

    local v71 = v69 and "Team1" or "Team2";
    local v72 = p64:FindFirstChild(v71);
    local v73 = p64:FindFirstChild(v71 == "Team1" and "Team2" or "Team1");

    if v72 then
        v72.Visible = true;
        v72.BackgroundTransparency = 0;
        local v74;

        if p65 == "Counter-Terrorists" then
            v74 = Color3_fromRGB_ret2;
        else
            v74 = Color3_fromRGB_ret3;
        end;

        v72.BackgroundColor3 = v74;
        local Icon = v72:FindFirstChild("Icon");

        if Icon then
            Icon.Image = u7[p66] or "rbxassetid://70876442749327";
            local v75;

            if p65 == "Counter-Terrorists" then
                v75 = Color3_fromRGB_ret2;
            else
                v75 = Color3_fromRGB_ret3;
            end;

            Icon.ImageColor3 = v75;
            Icon.ImageTransparency = 0;
        end;
    end;

    if v73 then
        v73.Visible = false;
    end;
end;

local function hasRoundResult(p76: table, p77: number) -- Line: 422
    for _, v in ipairs(p76) do
        if v.round == p77 then
            return true;
        end;
    end;

    return false;
end;

local function applyTrophy(p78: string?, p79: table) -- Line: 431
    -- upvalues: u8 (ref), Color3_new_ret (copy)
    if not u8 then
        return;
    end;

    local Attribute = workspace:GetAttribute("RoundsToWin");

    if not Attribute then
        return;
    end;

    if p78 ~= "Counter-Terrorists" and p78 ~= "Terrorists" then
        return;
    end;

    local v80 = workspace:GetAttribute("CTScore") or 0;
    local v81 = workspace:GetAttribute("TScore") or 0;
    local v82 = v80 + v81 + (Attribute - (p78 == "Counter-Terrorists" and v80 and v80 or v81));

    if v82 < 1 or v82 > 24 then
        return;
    end;

    local v83;

    if u8 then
        local v84 = u8:FindFirstChild(v82 <= 12 and "Results1" or "Results2");

        if v84 then
            v83 = v84:FindFirstChild((tostring(v82))) or nil;
        else
            v83 = nil;
        end;
    else
        v83 = nil;
    end;

    if not v83 then
        return;
    end;

    local v85 = false;

    for _, v in ipairs(p79) do
        if v.round == v82 then
            v85 = true;
            break;
        end;
    end;

    if v85 then
        return;
    end;

    local v86 = p78 == "Terrorists";
    local v87;

    if v82 <= 12 then
        local Attribute2 = workspace:GetAttribute("HalftimeRound");
        local Attribute3 = workspace:GetAttribute("CurrentRound");

        if Attribute2 == nil or Attribute3 == nil then
            v87 = false;
        else
            v87 = Attribute2 < Attribute3;
        end;
    else
        v87 = false;
    end;

    if v87 then
        v86 = not v86;
    end;

    local v88 = v83:FindFirstChild(v86 and "Team1" or "Team2");

    if not v88 then
        return;
    end;

    v88.Visible = true;
    v88.BackgroundTransparency = 1;
    local Icon = v88:FindFirstChild("Icon");

    if Icon then
        Icon.Image = "rbxassetid://4857633530";
        Icon.ImageColor3 = Color3_new_ret;
        Icon.ImageTransparency = 0;
    end;
end;

local function refreshResults() -- Line: 473
    -- upvalues: u8 (ref), resetRoundFrame (copy), decodeRoundResults (copy), paintRoundResult (copy), Color3_fromRGB_ret6 (copy), applyTrophy (copy), LocalPlayer (copy)
    if not u8 then
        return;
    end;

    local v89;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local Attribute = workspace:GetAttribute("Gamemode");
        v89 = Attribute == "Bomb Defusal" and true or Attribute == "Hostage Rescue";
    else
        v89 = false;
    end;

    if not v89 then
        return;
    end;

    for i = 1, 24 do
        local v90;

        if u8 then
            local v91 = u8:FindFirstChild(i <= 12 and "Results1" or "Results2");

            if v91 then
                v90 = v91:FindFirstChild((tostring(i))) or nil;
            else
                v90 = nil;
            end;
        else
            v90 = nil;
        end;

        local v92;

        if v90 then
            resetRoundFrame(v90);
            v92 = i;
        else
            v92 = i;
        end;
    end;

    local v93 = decodeRoundResults();

    for _, v in ipairs(v93) do
        local round = v.round;
        local v94;

        if u8 then
            local v95 = u8:FindFirstChild(round <= 12 and "Results1" or "Results2");
            v94 = v95 and v95:FindFirstChild((tostring(round))) or nil;
        else
            v94 = nil;
        end;

        if v94 then
            paintRoundResult(v94, v.winner, v.winType, v.round);
        end;
    end;

    local Attribute = workspace:GetAttribute("CurrentRound");

    if Attribute and (Attribute >= 1 and Attribute <= 24) then
        local v96 = false;

        for _, v in ipairs(v93) do
            if v.round == Attribute then
                v96 = true;
                break;
            end;
        end;

        if not v96 then
            local v97;

            if u8 then
                local v98 = u8:FindFirstChild(Attribute <= 12 and "Results1" or "Results2");
                v97 = v98 and v98:FindFirstChild((tostring(Attribute))) or nil;
            else
                v97 = nil;
            end;

            if v97 then
                v97.BackgroundColor3 = Color3_fromRGB_ret6;
            end;
        end;
    end;

    applyTrophy(LocalPlayer:GetAttribute("Team"), v93);
end;

local function isTextObject(p99: userdata) -- Line: 516
    return p99:IsA("TextLabel") or p99:IsA("TextButton");
end;

local function isImageObject(p100: userdata) -- Line: 520
    return p100:IsA("ImageLabel") or p100:IsA("ImageButton");
end;

local function storeTransparencyRecursive(p101: userdata, p102: table) -- Line: 525
    -- upvalues: storeTransparencyRecursive (copy)
    if p101:IsA("Frame") then
        p102[p101] = {
            BackgroundTransparency = p101.BackgroundTransparency
        };
    elseif p101:IsA("TextLabel") or p101:IsA("TextButton") then
        p102[p101] = {
            BackgroundTransparency = p101.BackgroundTransparency,
            TextTransparency = p101.TextTransparency
        };
    elseif p101:IsA("ImageLabel") or p101:IsA("ImageButton") then
        p102[p101] = {
            BackgroundTransparency = p101.BackgroundTransparency,
            ImageTransparency = p101.ImageTransparency
        };
    end;

    for _, child in p101:GetChildren() do
        storeTransparencyRecursive(child, p102);
    end;
end;

local function setDeadTransparencyRecursive(p103: userdata) -- Line: 548
    -- upvalues: setDeadTransparencyRecursive (copy)
    if p103:IsA("Frame") then
        p103.BackgroundTransparency = 1;
    elseif p103:IsA("TextLabel") or p103:IsA("TextButton") then
        p103.TextTransparency = 0.5;
        p103.BackgroundTransparency = 1;
    elseif p103:IsA("ImageLabel") or p103:IsA("ImageButton") then
        p103.ImageTransparency = 0.5;
        p103.BackgroundTransparency = 1;
    end;

    for _, child in ipairs(p103:GetChildren()) do
        setDeadTransparencyRecursive(child);
    end;
end;

local function restoreTransparencyRecursive(p104: userdata, p105: table) -- Line: 564
    -- upvalues: restoreTransparencyRecursive (copy)
    local v106 = p105[p104];

    if v106 then
        if p104:IsA("Frame") then
            p104.BackgroundTransparency = v106.BackgroundTransparency;
        elseif p104:IsA("TextLabel") or p104:IsA("TextButton") then
            p104.TextTransparency = v106.TextTransparency;
            p104.BackgroundTransparency = v106.BackgroundTransparency;
        elseif p104:IsA("ImageLabel") or p104:IsA("ImageButton") then
            p104.ImageTransparency = v106.ImageTransparency;
            p104.BackgroundTransparency = v106.BackgroundTransparency;
        end;
    end;

    for _, child in ipairs(p104:GetChildren()) do
        restoreTransparencyRecursive(child, p105);
    end;
end;

local function releaseParticipant(p107: userdata) -- Line: 585
    -- upvalues: u14 (copy), u1 (copy), updateAliveCounts (copy)
    local v108 = u14[p107];
    u14[p107] = nil;

    if v108 then
        v108:Destroy();
    end;

    u1.cleanup(p107);
    updateAliveCounts();
end;

function u1.createTemplate(u109: userdata, u110: any, p111: any) -- Line: 598
    -- upvalues: ReplicatedStorage (copy), Participants (copy), GetBadgeIcon (copy), storeTransparencyRecursive (copy), LocalPlayer (copy), Color3_fromRGB_ret (copy), bindPlayerRowInteractions (copy), Observers (copy), setDeadTransparencyRecursive (copy), restoreTransparencyRecursive (copy), DataController (copy), HttpService (copy)
    local u112 = ReplicatedStorage.Assets.UI.Leaderboard[u110]:Clone();
    u112.Player.Image = Participants.HeadshotImage(u109);
    u112.PlayerName.Text = `{Participants.DisplayName(u109)} (@{Participants.Name(u109)})`;
    local v113 = GetBadgeIcon(u109, u110);
    u112.Badge.Visible = v113 ~= "";
    u112.Badge.Image = v113;
    u112.Assists.Amount.Text = "0";
    u112.Deaths.Amount.Text = "0";
    u112.Score.Amount.Text = "0";
    u112.Kills.Amount.Text = "0";
    u112.MVPs.Amount.Text = "0";
    u112.Money.Amount.Text = "";
    u112.LayoutOrder = 1;
    u112.Ping.Text = "0";
    local u114 = {
        [u112] = {
            BackgroundTransparency = u112.BackgroundTransparency
        }
    };

    for _, child in u112:GetChildren() do
        storeTransparencyRecursive(child, u114);
    end;

    if u109 == LocalPlayer then
        u112.BackgroundColor3 = Color3_fromRGB_ret;
    end;

    bindPlayerRowInteractions(u112, u109, p111);

    local function isTeammate() -- Line: 639
        -- upvalues: u109 (copy), LocalPlayer (ref)
        return u109:GetAttribute("Team") == LocalPlayer:GetAttribute("Team");
    end;

    local function updateMoneyVisibility() -- Line: 646
        -- upvalues: u109 (copy), LocalPlayer (ref), u112 (copy)
        local Attribute = workspace:GetAttribute("Gamemode");

        if u109:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") and Attribute ~= "Deathmatch" then
            u112.Money.Amount.Text = "";

            return;
        end;

        local Attribute2 = u109:GetAttribute("Money");
        u112.Money.Amount.Text = Attribute2 == nil and "" or (`${tostring(Attribute2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}` or "");
    end;

    p111:Add(Observers.observeAttribute(u109, "Money", updateMoneyVisibility));
    updateMoneyVisibility();
    local u115 = u112.Player:FindFirstChildOfClass("UIStroke");

    local function updateTeamColors() -- Line: 660
        -- upvalues: u115 (copy), u109 (copy), LocalPlayer (ref)
        if not u115 then
            return;
        end;

        if u109:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
            u115.Enabled = false;

            return;
        end;

        local Attribute = u109:GetAttribute("CompetitivePlayerColor");

        if not Attribute then
            u115.Enabled = false;

            return;
        end;

        u115.Color = Attribute;
        u115.Enabled = true;
    end;

    if u115 then
        if u109:GetAttribute("Team") == LocalPlayer:GetAttribute("Team") then
            local Attribute = u109:GetAttribute("CompetitivePlayerColor");

            if Attribute then
                u115.Color = Attribute;
                u115.Enabled = true;
            else
                u115.Enabled = false;
            end;
        else
            u115.Enabled = false;
        end;
    end;

    local function updateTeamDependentState() -- Line: 683
        -- upvalues: updateMoneyVisibility (copy), u115 (copy), u109 (copy), LocalPlayer (ref)
        updateMoneyVisibility();

        if not u115 then
            return;
        end;

        if u109:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
            u115.Enabled = false;

            return;
        end;

        local Attribute = u109:GetAttribute("CompetitivePlayerColor");

        if not Attribute then
            u115.Enabled = false;

            return;
        end;

        u115.Color = Attribute;
        u115.Enabled = true;
    end;

    p111:Add(Observers.observeAttribute(LocalPlayer, "Team", updateTeamDependentState));
    p111:Add(Observers.observeAttribute(u109, "Team", updateTeamDependentState));
    p111:Add(Observers.observeAttribute(u109, "CompetitivePlayerColor", updateTeamColors));
    p111:Add(Observers.observeAttribute(u109, "Kills", function(p116) -- Line: 693
        -- upvalues: u112 (copy)
        u112.Kills.Amount.Text = tostring(p116):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        u112.LayoutOrder = -p116;
    end));

    for _, v in ipairs({ "Deaths", "Assists", "Score", "MVPs" }) do
        p111:Add(Observers.observeAttribute(u109, v, function(p117) -- Line: 700
            -- upvalues: u112 (copy), v (copy)
            u112[v].Amount.Text = tostring(p117):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        end));
    end;

    p111:Add(Observers.observeAttribute(u109, "Ping", function(p118) -- Line: 706
        -- upvalues: u112 (copy)
        u112.Ping.Text = p118;
    end));

    local function updateDeadSymbol() -- Line: 711
        -- upvalues: u109 (copy), Participants (ref), u112 (copy), setDeadTransparencyRecursive (ref), u114 (copy), restoreTransparencyRecursive (ref)
        local v119 = u109:GetAttribute("IsSpectating") == true;
        local v120 = not Participants.IsAlive(u109) or v119;

        if u112:FindFirstChild("Dead") then
            u112.Dead.Visible = v120;
        end;

        if not v120 then
            local v121 = u114[u112];

            if v121 then
                u112.BackgroundTransparency = v121.BackgroundTransparency;
            end;

            for _, child in ipairs(u112:GetChildren()) do
                restoreTransparencyRecursive(child, u114);
            end;

            return;
        end;

        if u112:FindFirstChild("Bomb") then
            u112.Bomb.Visible = false;
        end;

        if u112:FindFirstChild("DefuseKit") then
            u112.DefuseKit.Visible = false;
        end;

        u112.BackgroundTransparency = 1;

        for _, child in ipairs(u112:GetChildren()) do
            setDeadTransparencyRecursive(child);
        end;
    end;

    local u122 = nil;
    p111:Add(Observers.observeAttribute(u109, "IsSpectating", updateDeadSymbol));

    local function updateLifeState() -- Line: 747
        -- upvalues: updateDeadSymbol (copy), u122 (ref)
        updateDeadSymbol();

        if u122 then
            u122();
        end;
    end;

    p111:Add(u109:GetAttributeChangedSignal("Dead"):Connect(updateLifeState));
    p111:Add(u109:GetAttributeChangedSignal("Health"):Connect(updateLifeState));
    p111:Add(u109:GetAttributeChangedSignal("CompetitivePlayerColor"):Connect(updateTeamColors));
    updateDeadSymbol();

    if not Participants.IsBot(u109) then
        local u124 = DataController.CreateListener(u109, `Loadout.{u110}.Equipped.Equipped Badge`, function() -- Line: 760
            -- upvalues: GetBadgeIcon (ref), u109 (copy), u110 (copy), u112 (copy)
            local v123 = GetBadgeIcon(u109, u110);
            u112.Badge.Image = v123;
            u112.Badge.Visible = v123 ~= "";
        end);
        p111:Add(function() -- Line: 767
            -- upvalues: DataController (ref), u109 (copy), u110 (copy), u124 (copy)
            DataController.RemoveListener(u109, `Loadout.{u110}.Equipped.Equipped Badge`, u124);
        end);
    end;

    u122 = function() -- Line: 773
        -- upvalues: u109 (copy), LocalPlayer (ref), Participants (ref), u110 (copy), u112 (copy), HttpService (ref)
        local v125 = u109:GetAttribute("Team") == LocalPlayer:GetAttribute("Team");
        local v126 = u109:GetAttribute("IsSpectating") == true;
        local v127 = Participants.IsAlive(u109) and not v126;

        if u110 == "Terrorists" then
            local Bomb = u112:FindFirstChild("Bomb");

            if Bomb then
                local Attribute = u109:GetAttribute("Slot5");

                if not Attribute then
                    Bomb.Visible = false;

                    return;
                end;

                local v128 = HttpService:JSONDecode(Attribute);

                if v125 then
                    if v127 then
                        if v128 then
                            v128 = v128.Weapon == "C4";
                        end;
                    else
                        v128 = v127;
                    end;
                else
                    v128 = v125;
                end;

                Bomb.Visible = v128;
            end;
        else
            local v129 = u110 == "Counter-Terrorists" and u112:FindFirstChild("DefuseKit");

            if v129 then
                local Attribute = u109:GetAttribute("HasDefuseKit");

                if v125 then
                    if v127 then
                        v127 = Attribute == true;
                    end;
                else
                    v127 = v125;
                end;

                v129.Visible = v127;
            end;
        end;
    end;

    if u110 == "Terrorists" then
        p111:Add(Observers.observeAttribute(u109, "Slot5", function() -- Line: 806
            -- upvalues: u122 (ref), u112 (copy)
            u122();

            return function() -- Line: 809
                -- upvalues: u112 (ref)
                if u112:FindFirstChild("Bomb") then
                    u112.Bomb.Visible = false;
                end;
            end;
        end));
    elseif u110 == "Counter-Terrorists" then
        p111:Add(Observers.observeAttribute(u109, "HasDefuseKit", function() -- Line: 817
            -- upvalues: u122 (ref), u112 (copy)
            u122();

            return function() -- Line: 819
                -- upvalues: u112 (ref)
                if u112:FindFirstChild("DefuseKit") then
                    u112.DefuseKit.Visible = false;
                end;
            end;
        end));
    end;

    p111:Add(Observers.observeAttribute(LocalPlayer, "Team", u122));
    u122();

    return u112;
end;

function u1.openFrame() -- Line: 836
    -- upvalues: EndScreenController (copy), GameState (copy), u8 (ref), u1 (copy), u12 (ref)
    if EndScreenController.IsActive() or GameState.GetState() == "Map Voting" then
        if u8 and u8.Visible then
            u1.closeFrame();
        end;

        return;
    end;

    u12 = false;
    u8.Visible = true;
end;

function u1.CreateSnapshot() -- Line: 850
    -- upvalues: u9 (ref), u10 (ref), ProfileInspect (copy), u8 (ref)
    if u9 then
        u9.Visible = false;

        if u10 then
            u9.Position = u10;
        end;

        ProfileInspect.Reset();
    end;

    local v130 = u8:Clone();
    local ProfileInspect2 = v130:FindFirstChild("ProfileInspect");

    if ProfileInspect2 then
        ProfileInspect2:Destroy();
    end;

    v130.Visible = true;

    return v130;
end;

function u1.IsOpen() -- Line: 861
    -- upvalues: u8 (ref)
    local v131;

    if u8 == nil then
        v131 = false;
    else
        v131 = u8.Visible;
    end;

    return v131;
end;

function u1.closeFrame() -- Line: 865
    -- upvalues: u8 (ref), u12 (ref), u9 (ref), u10 (ref), ProfileInspect (copy), CameraController (copy)
    u8.Visible = false;
    u12 = false;

    if u9 then
        u9.Visible = false;

        if u10 then
            u9.Position = u10;
        end;

        ProfileInspect.Reset();
    end;

    CameraController.setForceLockOverride("Leaderboard", false);
end;

function u1.IsRightClickUnlockActive() -- Line: 872
    -- upvalues: u12 (ref)
    return u12;
end;

function u1.characterAdded(u132: userdata, u133: any) -- Line: 876
    -- upvalues: Profiler (copy), Janitor (copy), u1 (copy), u8 (ref), u13 (copy)
    Profiler.scope("UI.Leaderboard.CharacterAdded", function() -- Line: 877
        -- upvalues: Janitor (ref), u1 (ref), u132 (copy), u133 (copy), u8 (ref), u13 (ref)
        local v134 = Janitor.new();
        u1.cleanup(u132);
        local u135 = u1.createTemplate(u132, u133, v134);
        u135.Parent = u8:FindFirstChild(u133);
        v134:Add(function() -- Line: 882
            -- upvalues: u135 (copy)
            u135:Destroy();
        end);
        u13[u132] = v134;
    end);
end;

function u1.observePlayer(u136: userdata) -- Line: 889
    -- upvalues: Observers (copy), u1 (copy)
    Observers.observeAttribute(u136, "Team", function(p137) -- Line: 890
        -- upvalues: u1 (ref), u136 (copy)
        if p137 == "Terrorists" or p137 == "Counter-Terrorists" then
            u1.characterAdded(u136, p137);
        end;

        return function() -- Line: 896
            -- upvalues: u1 (ref), u136 (ref)
            u1.cleanup(u136);
        end;
    end);
end;

function u1.cleanup(p138: userdata) -- Line: 902
    -- upvalues: u13 (copy)
    local v139 = u13[p138];
    u13[p138] = nil;

    if v139 then
        v139:Destroy();
    end;
end;

function u1.Initialize(p140, p141) -- Line: 913
    -- upvalues: u8 (ref), Router (copy), u1 (copy), u9 (ref), u10 (ref), ProfileInspect (copy), u11 (ref), UserInputService (copy), u12 (ref), CameraController (copy), Observers (copy), updateGamemode (copy), updateAliveCounts (copy), applyLossBonusVisibility (copy), applyLossBars (copy), refreshResults (copy), LocalPlayer (copy), GetTimerFormat (copy), observeAliveCountPlayer (copy), u14 (copy), Participants (copy)
    u8 = p141;
    Router.observerRouter("CreateLeaderboardSnapshot", u1.CreateSnapshot);
    u9 = p141:FindFirstChild("ProfileInspect");

    if u9 then
        u10 = u9.Position;
        u9.Visible = false;
        ProfileInspect.Bind(u9);
    end;

    if u11 then
        u11:Disconnect();
        u11 = nil;
    end;

    u11 = UserInputService.InputBegan:Connect(function(p142: userdata) -- Line: 930
        -- upvalues: u8 (ref), u12 (ref), CameraController (ref)
        if p142.UserInputType == Enum.UserInputType.MouseButton2 and (u8 and u8.Visible) then
            u12 = true;
            CameraController.setForceLockOverride("Leaderboard", true);
        end;
    end);
    Observers.observeAttribute(workspace, "Gamemode", function() -- Line: 938
        -- upvalues: updateGamemode (ref), updateAliveCounts (ref), applyLossBonusVisibility (ref), applyLossBars (ref), refreshResults (ref)
        updateGamemode();
        updateAliveCounts();
        applyLossBonusVisibility();
        applyLossBars();
        refreshResults();
    end);
    Observers.observeAttribute(workspace, "Map", updateGamemode);
    Observers.observeAttribute(workspace, "ServerGamemode", function() -- Line: 946
        -- upvalues: applyLossBonusVisibility (ref), applyLossBars (ref), refreshResults (ref)
        applyLossBonusVisibility();
        applyLossBars();
        refreshResults();
    end);
    Observers.observeAttribute(workspace, "GameState", function(p143: string?) -- Line: 951
        -- upvalues: u1 (ref), updateAliveCounts (ref)
        if p143 == "Map Voting" then
            u1.closeFrame();
        end;

        updateAliveCounts();
    end);
    Observers.observeAttribute(workspace, "CTScore", function(p144) -- Line: 959
        -- upvalues: u8 (ref), refreshResults (ref)
        u8.Team.CT.Score.Text = tostring(p144);
        refreshResults();

        return function() -- Line: 962
            -- upvalues: u8 (ref)
            u8.Team.CT.Score.Text = "";
        end;
    end);
    Observers.observeAttribute(workspace, "TScore", function(p145) -- Line: 968
        -- upvalues: u8 (ref), refreshResults (ref)
        u8.Team.T.Score.Text = tostring(p145);
        refreshResults();

        return function() -- Line: 971
            -- upvalues: u8 (ref)
            u8.Team.T.Score.Text = "";
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

    local function refreshTimer() -- Line: 995
        -- upvalues: GetTimerFormat (ref), u8 (ref)
        local Attribute = workspace:GetAttribute("Timer");
        local v146 = typeof(Attribute) ~= "number" and "" or GetTimerFormat(Attribute);
        u8.TopInfo.Timer.Text = v146;
        u8.Top.TopInfo.Timer.Text = v146;
    end;

    workspace:GetAttributeChangedSignal("Timer"):Connect(refreshTimer);
    local Attribute = workspace:GetAttribute("Timer");
    local v147 = typeof(Attribute) ~= "number" and "" or GetTimerFormat(Attribute);
    u8.TopInfo.Timer.Text = v147;
    u8.Top.TopInfo.Timer.Text = v147;
    Observers.observePlayer(function(u148: userdata) -- Line: 1005
        -- upvalues: u1 (ref), observeAliveCountPlayer (ref), u14 (ref), updateAliveCounts (ref)
        u1.observePlayer(u148);
        observeAliveCountPlayer(u148);

        return function() -- Line: 1008
            -- upvalues: u148 (copy), u14 (ref), u1 (ref), updateAliveCounts (ref)
            local v149 = u148;
            local v150 = u14[v149];
            u14[v149] = nil;

            if v150 then
                v150:Destroy();
            end;

            u1.cleanup(v149);
            updateAliveCounts();
        end;
    end);
    Participants.Observe(function(p151: userdata) -- Line: 1014
        -- upvalues: Participants (ref), u1 (ref), observeAliveCountPlayer (ref)
        if Participants.IsBot(p151) then
            u1.observePlayer(p151);
            observeAliveCountPlayer(p151);
        end;
    end, function(p152: userdata) -- Line: 1019
        -- upvalues: Participants (ref), u14 (ref), u1 (ref), updateAliveCounts (ref)
        if Participants.IsBot(p152) then
            local v153 = u14[p152];
            u14[p152] = nil;

            if v153 then
                v153:Destroy();
            end;

            u1.cleanup(p152);
            updateAliveCounts();
        end;
    end);
end;

function u1.Start() -- Line: 1026
    -- upvalues: clearFrame (copy), u8 (ref), updateAliveCounts (copy)
    clearFrame((u8:WaitForChild("Counter-Terrorists")));
    clearFrame((u8:WaitForChild("Terrorists")));
    updateAliveCounts();
end;

return u1;