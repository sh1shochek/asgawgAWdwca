-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local PlayerInfo = require(ReplicatedStorage.Interface.Screens.Gameplay.Top.PlayerInfo);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Color3_fromRGB_ret = Color3.fromRGB(85, 255, 85);
local Color3_fromRGB_ret2 = Color3.fromRGB(250, 31, 31);
local Color3_fromRGB_ret3 = Color3.fromRGB(85, 255, 85);
local Color3_fromRGB_ret4 = Color3.fromRGB(230, 36, 36);
local TweenInfo_new_ret = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true);
local u2 = { "Counter-Terrorists", "Terrorists" };
local Color3_fromRGB_ret5 = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret6 = Color3.fromRGB(165, 20, 20);
local u3 = { "IsSpectating", "Dead", "Health" };
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {
    ["Counter-Terrorists"] = {},
    Terrorists = {}
};
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;

local function clearFrame(p15) -- Line: 77
    for _, child in p15:GetChildren() do
        if child.ClassName == "Frame" and child.Name ~= "MorePlayers" then
            child:Destroy();
        end;
    end;
end;

local function IsPlayableTeam(p16) -- Line: 85
    return p16 == "Counter-Terrorists" and true or p16 == "Terrorists";
end;

local function GetPlayerAlive(p17: userdata) -- Line: 89
    -- upvalues: Participants (copy)
    local v18;

    if p17:GetAttribute("IsSpectating") == true then
        v18 = false;
    else
        v18 = Participants.IsAlive(p17);
    end;

    return v18;
end;

local function RefreshTeamHud(p19) -- Line: 93
    -- upvalues: u8 (copy), u9 (copy), u6 (copy), PlayerInfo (copy), Participants (copy)
    local v20 = u8[p19];
    local v21 = u9[p19];
    local v22 = 0;

    for _, v in ipairs(v21) do
        if u6[v] == true then
            v22 = v22 + 1;
        end;
    end;

    v20.playerCountLabel.Text = tostring(v22);
    local v23 = #v21;
    local v24 = v23 > 10;
    local v25 = not v24 and 0 or v23 - 9;
    v20.morePlayersFrame.Visible = v25 > 0;
    v20.morePlayersAmountLabel.Text = `+{v25}`;
    local v26 = v24 and 9 or v23;

    for i, v in ipairs(v21) do
        local TemplateByUserId = PlayerInfo.getTemplateByUserId(Participants.Key(v));

        if TemplateByUserId and TemplateByUserId.Parent == v20.holder then
            TemplateByUserId.Visible = i <= v26;
        end;
    end;
end;

local function RefreshAllTeamHuds() -- Line: 121
    -- upvalues: u2 (copy), RefreshTeamHud (copy)
    for _, v in ipairs(u2) do
        RefreshTeamHud(v);
    end;
end;

local function RemovePlayerFromRoster(p27: userdata) -- Line: 127
    -- upvalues: u7 (copy), u9 (copy)
    local v28 = u7[p27];
    u7[p27] = nil;

    if v28 ~= "Counter-Terrorists" and v28 ~= "Terrorists" then
        return nil;
    end;

    local v29 = u9[v28];

    for i, v in ipairs(v29) do
        if v == p27 then
            table.remove(v29, i);

            return v28;
        end;
    end;

    return v28;
end;

local function SetPlayerRosterTeam(p30: userdata, p31: any) -- Line: 145
    -- upvalues: u7 (copy), RemovePlayerFromRoster (copy), u9 (copy)
    if u7[p30] == p31 then
        return nil;
    end;

    local v32 = RemovePlayerFromRoster(p30);
    u7[p30] = p31;
    table.insert(u9[p31], p30);

    return v32;
end;

local function SetPlayerAliveState(p33: userdata, p34: boolean) -- Line: 156
    -- upvalues: u6 (copy), u7 (copy), RefreshTeamHud (copy)
    if u6[p33] == p34 then
        return;
    end;

    u6[p33] = p34;
    local v35 = u7[p33];

    if v35 == "Counter-Terrorists" and true or v35 == "Terrorists" then
        RefreshTeamHud(v35);
    end;
end;

local function RefreshPlayerAliveState(p36: userdata) -- Line: 168
    -- upvalues: Participants (copy), u6 (copy), u7 (copy), RefreshTeamHud (copy)
    local v37;

    if p36:GetAttribute("IsSpectating") == true then
        v37 = false;
    else
        v37 = Participants.IsAlive(p36);
    end;

    if u6[p36] == v37 then
        return;
    end;

    u6[p36] = v37;
    local v38 = u7[p36];

    if v38 == "Counter-Terrorists" and true or v38 == "Terrorists" then
        RefreshTeamHud(v38);
    end;
end;

local function ResetRosterState() -- Line: 172
    -- upvalues: u2 (copy), u9 (copy), u7 (copy), u6 (copy), RefreshTeamHud (copy)
    for _, v in ipairs(u2) do
        table.clear(u9[v]);
    end;

    table.clear(u7);
    table.clear(u6);

    for _, v in ipairs(u2) do
        RefreshTeamHud(v);
    end;
end;

local function UpdateFrameVisibility() -- Line: 182
    -- upvalues: u11 (ref), u10 (ref)
    local Attribute = workspace:GetAttribute("Gamemode");
    u10.Visible = (Attribute == "Hostage Rescue" and true or Attribute == "Bomb Defusal") and not u11.Gameplay.Middle.TeamSelection.Visible;
end;

local function StopBombGlow() -- Line: 190
    -- upvalues: u14 (ref), u10 (ref)
    if u14 then
        u14:Cancel();
        u14 = nil;
    end;

    u10.Time.Bomb.Glow.ImageTransparency = 0.75;
end;

local function StartBombGlow() -- Line: 199
    -- upvalues: u14 (ref), u10 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    if u14 then
        return;
    end;

    u10.Time.Bomb.Glow.ImageTransparency = 0.75;
    u14 = TweenService:Create(u10.Time.Bomb.Glow, TweenInfo_new_ret, {
        ImageTransparency = 0
    });
    u14:Play();
end;

local function UpdateBombDisplay() -- Line: 211
    -- upvalues: u12 (ref), u14 (ref), u10 (ref), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret (copy), StartBombGlow (copy)
    local v39 = u12;

    if not v39 then
        if u14 then
            u14:Cancel();
            u14 = nil;
        end;

        u10.Time.Bomb.Glow.ImageTransparency = 0.75;
        u10.Time.Bomb.Glow.ImageColor3 = Color3_fromRGB_ret2;
        u10.Time.Bomb.ImageColor3 = Color3_fromRGB_ret4;
        u10.Time.Timer.Visible = true;
        u10.Time.Bomb.Visible = false;

        return;
    end;

    u10.Time.Timer.Visible = false;
    u10.Time.Bomb.Visible = true;
    local v40 = v39:GetAttribute("Defused") == true;
    u10.Time.Bomb.Glow.ImageColor3 = v40 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
    u10.Time.Bomb.ImageColor3 = v40 and Color3_fromRGB_ret3 or Color3_fromRGB_ret4;

    if not v40 then
        StartBombGlow();

        return;
    end;

    if u14 then
        u14:Cancel();
        u14 = nil;
    end;

    u10.Time.Bomb.Glow.ImageTransparency = 0.75;
end;

local function SetCurrentBomb(p41: userdata?) -- Line: 240
    -- upvalues: u13 (ref), u12 (ref), UpdateBombDisplay (copy)
    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    u12 = p41;

    if u12 then
        u13 = u12:GetAttributeChangedSignal("Defused"):Connect(UpdateBombDisplay);
    end;

    UpdateBombDisplay();
end;

function u1.CreateTemplate(u42: userdata) -- Line: 258
    -- upvalues: Profiler (copy), u1 (copy), PlayerInfo (copy), u10 (ref), u4 (copy)
    Profiler.scope("UI.BombDefusal.CreateTemplate", function() -- Line: 259
        -- upvalues: u42 (copy), u1 (ref), PlayerInfo (ref), u10 (ref), u4 (ref)
        local Attribute = workspace:GetAttribute("Gamemode");
        local Attribute2 = u42:GetAttribute("Team");

        if Attribute == "Bomb Defusal" or Attribute == "Hostage Rescue" then
            u1.CleanupTemplate(u42);
            local v43 = PlayerInfo.createTemplate(u42, u10[Attribute2]);

            if v43 then
                u4[u42] = v43;
            end;
        end;
    end);
end;

function u1.CleanupTemplate(p44: userdata) -- Line: 273
    -- upvalues: u4 (copy), PlayerInfo (copy)
    local v45 = u4[p44];
    u4[p44] = nil;

    if v45 then
        PlayerInfo.cleanupTemplate(p44);
        v45:Destroy();
    end;
end;

function u1.PlayerAdded(u46: userdata) -- Line: 282
    -- upvalues: u5 (copy), Janitor (copy), u7 (copy), RemovePlayerFromRoster (copy), u9 (copy), u6 (copy), Participants (copy), u1 (copy), RefreshTeamHud (copy), LocalPlayer (copy), u2 (copy), PlayerInfo (copy), u3 (copy)
    local v47 = u5[u46];

    if v47 then
        v47:Destroy();
    end;

    local v48 = Janitor.new();
    u5[u46] = v48;

    local function handleTeamUpdate() -- Line: 291
        -- upvalues: u46 (copy), u7 (ref), RemovePlayerFromRoster (ref), u9 (ref), u6 (ref), Participants (ref), u1 (ref), RefreshTeamHud (ref), LocalPlayer (ref), u2 (ref), PlayerInfo (ref)
        local Attribute = u46:GetAttribute("Team");

        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            local v49 = RemovePlayerFromRoster(u46);
            u6[u46] = nil;
            u1.CleanupTemplate(u46);

            if v49 then
                RefreshTeamHud(v49);
            end;

            return;
        end;

        local v50 = u46;
        local v51;

        if u7[v50] == Attribute then
            v51 = nil;
        else
            v51 = RemovePlayerFromRoster(v50);
            u7[v50] = Attribute;
            table.insert(u9[Attribute], v50);
        end;

        local v52 = u46;
        local v53;

        if v52:GetAttribute("IsSpectating") == true then
            v53 = false;
        else
            v53 = Participants.IsAlive(v52);
        end;

        u6[u46] = v53;
        u1.CreateTemplate(u46);

        if v51 then
            RefreshTeamHud(v51);
        end;

        RefreshTeamHud(Attribute);

        if u46 == LocalPlayer then
            for _, v in Participants.GetAll() do
                if v ~= LocalPlayer then
                    local Attribute2 = v:GetAttribute("Team");

                    if Attribute2 == "Counter-Terrorists" and true or Attribute2 == "Terrorists" then
                        u1.CreateTemplate(v);
                    else
                        u1.CleanupTemplate(v);
                    end;
                end;
            end;

            for _, v in ipairs(u2) do
                RefreshTeamHud(v);
            end;
        end;

        PlayerInfo.refreshCompetitiveColors();
    end;

    v48:Add(u46:GetAttributeChangedSignal("Team"):Connect(handleTeamUpdate));

    for _, v in ipairs(u3) do
        v48:Add(u46:GetAttributeChangedSignal(v):Connect(function() -- Line: 332
            -- upvalues: u46 (copy), Participants (ref), u6 (ref), u7 (ref), RefreshTeamHud (ref)
            local v54 = u46;
            local v55;

            if v54:GetAttribute("IsSpectating") == true then
                v55 = false;
            else
                v55 = Participants.IsAlive(v54);
            end;

            if u6[v54] == v55 then
                return;
            end;

            u6[v54] = v55;
            local v56 = u7[v54];

            if v56 == "Counter-Terrorists" and true or v56 == "Terrorists" then
                RefreshTeamHud(v56);
            end;
        end));
    end;

    v48:Add(function() -- Line: 336
        -- upvalues: RemovePlayerFromRoster (ref), u46 (copy), u6 (ref), RefreshTeamHud (ref)
        local v57 = RemovePlayerFromRoster(u46);
        u6[u46] = nil;

        if v57 then
            RefreshTeamHud(v57);
        end;
    end);
    handleTeamUpdate();
end;

function u1.Initialize(p58, p59) -- Line: 350
    -- upvalues: u11 (ref), u10 (ref), u2 (copy), u8 (copy), Observers (copy), PlayerInfo (copy), Remotes (copy), Participants (copy), u6 (copy), u7 (copy), RefreshTeamHud (copy), GameState (copy), Color3_fromRGB_ret5 (copy), GetTimerFormat (copy), Color3_fromRGB_ret6 (copy), UpdateFrameVisibility (copy), CollectionService (copy), SetCurrentBomb (copy), u12 (ref), u13 (ref), UpdateBombDisplay (copy)
    u11 = p58;
    u10 = p59;

    for _, v in ipairs(u2) do
        local v60 = u10[v];
        u8[v] = {
            holder = v60,
            playerCountLabel = u10.Time[v].Players,
            morePlayersFrame = v60.MorePlayers,
            morePlayersAmountLabel = v60.MorePlayers.Amount
        };
    end;

    Observers.observeAttribute(workspace, "CTScore", function(p61) -- Line: 363
        -- upvalues: u10 (ref)
        u10.Time["Counter-Terrorists"].Score.Text = tostring(p61);

        return function() -- Line: 365
        end;
    end);
    Observers.observeAttribute(workspace, "TScore", function(p62) -- Line: 368
        -- upvalues: u10 (ref)
        u10.Time.Terrorists.Score.Text = tostring(p62);

        return function() -- Line: 370
        end;
    end);
    Observers.observeAttribute(workspace, "ServerGamemode", function(p63) -- Line: 373
        -- upvalues: PlayerInfo (ref)
        PlayerInfo.refreshCompetitiveColors();

        return function() -- Line: 375
        end;
    end);
    Remotes.UI.UIPlayerKilled.Listen(function(p64) -- Line: 378
        -- upvalues: Participants (ref), PlayerInfo (ref), u6 (ref), u7 (ref), RefreshTeamHud (ref)
        local v65 = tonumber(p64.Victim);
        local v66 = Participants.FromKey(v65);

        if v66 then
            local TemplateByUserId = PlayerInfo.getTemplateByUserId(v65);

            if TemplateByUserId and TemplateByUserId.Parent then
                local v67 = v66:GetAttribute("IsSpectating") == true;

                if not Participants.IsAlive(v66) or v67 then
                    PlayerInfo.applyTemplateLifeState(TemplateByUserId, true);
                end;
            end;

            local v68;

            if v66:GetAttribute("IsSpectating") == true then
                v68 = false;
            else
                v68 = Participants.IsAlive(v66);
            end;

            if u6[v66] ~= v68 then
                u6[v66] = v68;
                local v69 = u7[v66];

                if v69 == "Counter-Terrorists" and true or v69 == "Terrorists" then
                    RefreshTeamHud(v69);
                end;
            end;
        end;

        local v70 = tonumber(p64.Killer);

        if Participants.FromKey(v70) then
            PlayerInfo.incrementTemplateKills(v70);
        end;
    end);
    Remotes.UI.RoundWinner.Listen(function(p71) -- Line: 404
        -- upvalues: PlayerInfo (ref)
        PlayerInfo.setTeammateInfoRevealed(true);
    end);
    GameState.ListenToState(function(p72: string?, p73: string) -- Line: 408
        -- upvalues: PlayerInfo (ref)
        if p73 == "Buy Period" then
            PlayerInfo.setTeammateInfoRevealed(true);

            return;
        end;

        if p72 == "Buy Period" and p73 == "Round In Progress" then
            PlayerInfo.setTeammateInfoRevealed(false);
        end;
    end);
    Observers.observeAttribute(workspace, "Timer", function(p74) -- Line: 419
        -- upvalues: u10 (ref), Color3_fromRGB_ret5 (ref), GetTimerFormat (ref), Color3_fromRGB_ret6 (ref)
        local Attribute = workspace:GetAttribute("Gamemode");
        local Attribute2 = workspace:GetAttribute("GameState");
        u10.Time.Timer.TextColor3 = Color3_fromRGB_ret5;
        u10.Time.Timer.Text = GetTimerFormat(p74);

        if not (Attribute ~= "Hostage Rescue" and Attribute ~= "Bomb Defusal" or (Attribute2 == "Warmup" or p74 > 10)) then
            u10.Time.Timer.TextColor3 = Color3_fromRGB_ret6;
        end;

        return function() -- Line: 433
        end;
    end, function(p75) -- Line: 434
        return typeof(p75) == "number";
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(UpdateFrameVisibility);
    u11.Gameplay.Middle.TeamSelection:GetPropertyChangedSignal("Visible"):Connect(UpdateFrameVisibility);
    CollectionService:GetInstanceAddedSignal("Bomb"):Connect(SetCurrentBomb);
    CollectionService:GetInstanceRemovedSignal("Bomb"):Connect(function(p76: userdata) -- Line: 443
        -- upvalues: u12 (ref), u13 (ref), UpdateBombDisplay (ref)
        if p76 == u12 then
            if u13 then
                u13:Disconnect();
                u13 = nil;
            end;

            u12 = nil;

            if u12 then
                u13 = u12:GetAttributeChangedSignal("Defused"):Connect(UpdateBombDisplay);
            end;

            UpdateBombDisplay();
        end;
    end);
    local Attribute = workspace:GetAttribute("Gamemode");
    u10.Visible = (Attribute == "Hostage Rescue" and true or Attribute == "Bomb Defusal") and not u11.Gameplay.Middle.TeamSelection.Visible;
    local v77 = CollectionService:GetTagged("Bomb")[1];

    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    u12 = v77;

    if u12 then
        u13 = u12:GetAttributeChangedSignal("Defused"):Connect(UpdateBombDisplay);
    end;

    UpdateBombDisplay();

    for _, v in ipairs(u2) do
        RefreshTeamHud(v);
    end;
end;

function u1.Start() -- Line: 454
    -- upvalues: clearFrame (copy), u10 (ref), ResetRosterState (copy), Players (copy), u1 (copy), u5 (copy), Participants (copy)
    clearFrame(u10["Counter-Terrorists"]);
    clearFrame(u10.Terrorists);
    ResetRosterState();

    for _, v in Players:GetPlayers() do
        u1.PlayerAdded(v);
    end;

    Players.PlayerAdded:Connect(u1.PlayerAdded);
    Players.PlayerRemoving:Connect(function(p78: userdata) -- Line: 465, Name: removeParticipant
        -- upvalues: u5 (ref), u1 (ref)
        local v79 = u5[p78];
        u5[p78] = nil;

        if v79 then
            v79:Destroy();
        end;

        u1.CleanupTemplate(p78);
    end);
    Participants.Observe(function(p80: userdata) -- Line: 476
        -- upvalues: Participants (ref), u1 (ref)
        if Participants.IsBot(p80) then
            u1.PlayerAdded(p80);
        end;
    end, function(p81: userdata) -- Line: 480
        -- upvalues: Participants (ref), u5 (ref), u1 (ref)
        if Participants.IsBot(p81) then
            local v82 = u5[p81];
            u5[p81] = nil;

            if v82 then
                v82:Destroy();
            end;

            u1.CleanupTemplate(p81);
        end;
    end);
end;

return u1;