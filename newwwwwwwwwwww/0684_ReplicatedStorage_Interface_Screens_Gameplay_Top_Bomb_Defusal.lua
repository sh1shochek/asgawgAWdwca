-- Bomb Defusal (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Gameplay.Top.Bomb Defusal

-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local SurvivalState = require(ReplicatedStorage.Components.Common.SurvivalState);
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
local u15 = nil;

local function clearFrame(p16) -- Line: 83
    for _, child in p16:GetChildren() do
        if child.ClassName == "Frame" and child.Name ~= "MorePlayers" then
            child:Destroy();
        end;
    end;
end;

local function IsPlayableTeam(p17) -- Line: 91
    return p17 == "Counter-Terrorists" and true or p17 == "Terrorists";
end;

local function GetPlayerAlive(p18: userdata) -- Line: 95
    -- upvalues: Participants (copy)
    local v19;

    if p18:GetAttribute("IsSpectating") == true then
        v19 = false;
    else
        v19 = Participants.IsAlive(p18);
    end;

    return v19;
end;

local function RefreshTeamHud(p20) -- Line: 99
    -- upvalues: u8 (copy), u9 (copy), u6 (copy), PlayerInfo (copy), Participants (copy)
    local v21 = u8[p20];
    local v22 = u9[p20];
    local v23 = 0;

    for _, v in ipairs(v22) do
        if u6[v] == true then
            v23 = v23 + 1;
        end;
    end;

    v21.playerCountLabel.Text = tostring(v23);
    local v24 = #v22;
    local v25 = v24 > 10;
    local v26 = not v25 and 0 or v24 - 9;
    v21.morePlayersFrame.Visible = v26 > 0;
    v21.morePlayersAmountLabel.Text = `+{v26}`;
    local v27 = v25 and 9 or v24;

    for i, v in ipairs(v22) do
        local TemplateByUserId = PlayerInfo.getTemplateByUserId(Participants.Key(v));

        if TemplateByUserId and TemplateByUserId.Parent == v21.holder then
            TemplateByUserId.Visible = i <= v27;
        end;
    end;
end;

local function RefreshAllTeamHuds() -- Line: 127
    -- upvalues: u2 (copy), RefreshTeamHud (copy)
    for _, v in ipairs(u2) do
        RefreshTeamHud(v);
    end;
end;

local function RemovePlayerFromRoster(p28: userdata) -- Line: 133
    -- upvalues: u7 (copy), u9 (copy)
    local v29 = u7[p28];
    u7[p28] = nil;

    if v29 ~= "Counter-Terrorists" and v29 ~= "Terrorists" then
        return nil;
    end;

    local v30 = u9[v29];

    for i, v in ipairs(v30) do
        if v == p28 then
            table.remove(v30, i);

            return v29;
        end;
    end;

    return v29;
end;

local function SetPlayerRosterTeam(p31: userdata, p32: any) -- Line: 151
    -- upvalues: u7 (copy), RemovePlayerFromRoster (copy), u9 (copy)
    if u7[p31] == p32 then
        return nil;
    end;

    local v33 = RemovePlayerFromRoster(p31);
    u7[p31] = p32;
    table.insert(u9[p32], p31);

    return v33;
end;

local function SetPlayerAliveState(p34: userdata, p35: boolean) -- Line: 162
    -- upvalues: u6 (copy), u7 (copy), RefreshTeamHud (copy)
    if u6[p34] == p35 then
        return;
    end;

    u6[p34] = p35;
    local v36 = u7[p34];

    if v36 == "Counter-Terrorists" and true or v36 == "Terrorists" then
        RefreshTeamHud(v36);
    end;
end;

local function RefreshPlayerAliveState(p37: userdata) -- Line: 174
    -- upvalues: Participants (copy), u6 (copy), u7 (copy), RefreshTeamHud (copy)
    local v38;

    if p37:GetAttribute("IsSpectating") == true then
        v38 = false;
    else
        v38 = Participants.IsAlive(p37);
    end;

    if u6[p37] == v38 then
        return;
    end;

    u6[p37] = v38;
    local v39 = u7[p37];

    if v39 == "Counter-Terrorists" and true or v39 == "Terrorists" then
        RefreshTeamHud(v39);
    end;
end;

local function ResetRosterState() -- Line: 178
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

local function UsesTeamHud(p40) -- Line: 189
    return (p40 == "Bomb Defusal" or p40 == "Hostage Rescue") and true or p40 == "Zombie Survival";
end;

local function CreateWavePanel() -- Line: 195
    -- upvalues: u10 (ref)
    local v41 = u10.Time["Counter-Terrorists"];
    local v42 = v41:Clone();
    v42.Name = "SurvivalWave";
    v42.AnchorPoint = Vector2.new(0.5, 0);
    v42.Position = UDim2.new(0.5, 0, 1.1, v41.Position.Y.Offset);
    v42.ImageLabel.Visible = false;
    v42.Players.Position = UDim2.fromScale(0.5, v42.Players.Position.Y.Scale);
    v42.Players.Size = UDim2.fromScale(0.8, v42.Players.Size.Y.Scale);
    v42.Players.Text = "WAVE";
    v42.Visible = false;
    v42.Parent = u10.Time;

    return v42;
end;

local function RefreshWavePanel() -- Line: 210
    -- upvalues: u11 (ref), SurvivalState (copy)
    local Score = u11.Score;
    local Wave = SurvivalState.GetWave();
    local math_max_ret = math.max(Wave, 1);
    Score.Text = tostring(math_max_ret);
end;

local function UpdateFrameVisibility() -- Line: 215
    -- upvalues: IsSurvivalMode (copy), u12 (ref), u10 (ref), u11 (ref)
    local Attribute = workspace:GetAttribute("Gamemode");
    local v43 = IsSurvivalMode();
    u10.Visible = ((Attribute == "Bomb Defusal" or Attribute == "Hostage Rescue") and true or Attribute == "Zombie Survival") and not u12.Gameplay.Middle.TeamSelection.Visible;
    u10["Counter-Terrorists"].Visible = not v43;
    u10.Terrorists.Visible = not v43;
    u10.Time["Counter-Terrorists"].Visible = not v43;
    u10.Time.Terrorists.Visible = not v43;
    u11.Visible = v43;
end;

local function StopBombGlow() -- Line: 229
    -- upvalues: u15 (ref), u10 (ref)
    if u15 then
        u15:Cancel();
        u15 = nil;
    end;

    u10.Time.Bomb.Glow.ImageTransparency = 0.75;
end;

local function StartBombGlow() -- Line: 238
    -- upvalues: u15 (ref), u10 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    if u15 then
        return;
    end;

    u10.Time.Bomb.Glow.ImageTransparency = 0.75;
    u15 = TweenService:Create(u10.Time.Bomb.Glow, TweenInfo_new_ret, {
        ImageTransparency = 0
    });
    u15:Play();
end;

local function UpdateBombDisplay() -- Line: 250
    -- upvalues: u13 (ref), u15 (ref), u10 (ref), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret (copy), StartBombGlow (copy)
    local v44 = u13;

    if not v44 then
        if u15 then
            u15:Cancel();
            u15 = nil;
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
    local v45 = v44:GetAttribute("Defused") == true;
    u10.Time.Bomb.Glow.ImageColor3 = v45 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
    u10.Time.Bomb.ImageColor3 = v45 and Color3_fromRGB_ret3 or Color3_fromRGB_ret4;

    if not v45 then
        StartBombGlow();

        return;
    end;

    if u15 then
        u15:Cancel();
        u15 = nil;
    end;

    u10.Time.Bomb.Glow.ImageTransparency = 0.75;
end;

local function SetCurrentBomb(p46: userdata?) -- Line: 279
    -- upvalues: u14 (ref), u13 (ref), UpdateBombDisplay (copy)
    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    u13 = p46;

    if u13 then
        u14 = u13:GetAttributeChangedSignal("Defused"):Connect(UpdateBombDisplay);
    end;

    UpdateBombDisplay();
end;

function u1.CreateTemplate(u47: userdata) -- Line: 297
    -- upvalues: Profiler (copy), u1 (copy), PlayerInfo (copy), u10 (ref), u4 (copy)
    Profiler.scope("UI.BombDefusal.CreateTemplate", function() -- Line: 298
        -- upvalues: u47 (copy), u1 (ref), PlayerInfo (ref), u10 (ref), u4 (ref)
        local Attribute = workspace:GetAttribute("Gamemode");
        local Attribute2 = u47:GetAttribute("Team");

        if (Attribute == "Bomb Defusal" or Attribute == "Hostage Rescue") and true or Attribute == "Zombie Survival" then
            u1.CleanupTemplate(u47);
            local v48 = PlayerInfo.createTemplate(u47, u10[Attribute2]);

            if v48 then
                u4[u47] = v48;
            end;
        end;
    end);
end;

function u1.CleanupTemplate(p49: userdata) -- Line: 312
    -- upvalues: u4 (copy), PlayerInfo (copy)
    local v50 = u4[p49];
    u4[p49] = nil;

    if v50 then
        PlayerInfo.cleanupTemplate(p49);
        v50:Destroy();
    end;
end;

function u1.PlayerAdded(u51: userdata) -- Line: 321
    -- upvalues: u5 (copy), Janitor (copy), u7 (copy), RemovePlayerFromRoster (copy), u9 (copy), u6 (copy), Participants (copy), u1 (copy), RefreshTeamHud (copy), LocalPlayer (copy), u2 (copy), PlayerInfo (copy), u3 (copy)
    local v52 = u5[u51];

    if v52 then
        v52:Destroy();
    end;

    local v53 = Janitor.new();
    u5[u51] = v53;

    local function handleTeamUpdate() -- Line: 330
        -- upvalues: u51 (copy), u7 (ref), RemovePlayerFromRoster (ref), u9 (ref), u6 (ref), Participants (ref), u1 (ref), RefreshTeamHud (ref), LocalPlayer (ref), u2 (ref), PlayerInfo (ref)
        local Attribute = u51:GetAttribute("Team");

        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            local v54 = RemovePlayerFromRoster(u51);
            u6[u51] = nil;
            u1.CleanupTemplate(u51);

            if v54 then
                RefreshTeamHud(v54);
            end;

            return;
        end;

        local v55 = u51;
        local v56;

        if u7[v55] == Attribute then
            v56 = nil;
        else
            v56 = RemovePlayerFromRoster(v55);
            u7[v55] = Attribute;
            table.insert(u9[Attribute], v55);
        end;

        local v57 = u51;
        local v58;

        if v57:GetAttribute("IsSpectating") == true then
            v58 = false;
        else
            v58 = Participants.IsAlive(v57);
        end;

        u6[u51] = v58;
        u1.CreateTemplate(u51);

        if v56 then
            RefreshTeamHud(v56);
        end;

        RefreshTeamHud(Attribute);

        if u51 == LocalPlayer then
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

    v53:Add(u51:GetAttributeChangedSignal("Team"):Connect(handleTeamUpdate));

    for _, v in ipairs(u3) do
        v53:Add(u51:GetAttributeChangedSignal(v):Connect(function() -- Line: 371
            -- upvalues: u51 (copy), Participants (ref), u6 (ref), u7 (ref), RefreshTeamHud (ref)
            local v59 = u51;
            local v60;

            if v59:GetAttribute("IsSpectating") == true then
                v60 = false;
            else
                v60 = Participants.IsAlive(v59);
            end;

            if u6[v59] == v60 then
                return;
            end;

            u6[v59] = v60;
            local v61 = u7[v59];

            if v61 == "Counter-Terrorists" and true or v61 == "Terrorists" then
                RefreshTeamHud(v61);
            end;
        end));
    end;

    v53:Add(function() -- Line: 375
        -- upvalues: RemovePlayerFromRoster (ref), u51 (copy), u6 (ref), RefreshTeamHud (ref)
        local v62 = RemovePlayerFromRoster(u51);
        u6[u51] = nil;

        if v62 then
            RefreshTeamHud(v62);
        end;
    end);
    handleTeamUpdate();
end;

function u1.Initialize(p63, p64) -- Line: 389
    -- upvalues: u12 (ref), u10 (ref), u11 (ref), CreateWavePanel (copy), u2 (copy), u8 (copy), Observers (copy), PlayerInfo (copy), Remotes (copy), Participants (copy), u6 (copy), u7 (copy), RefreshTeamHud (copy), GameState (copy), Color3_fromRGB_ret5 (copy), IsSurvivalMode (copy), SurvivalState (copy), GetTimerFormat (copy), Color3_fromRGB_ret6 (copy), RunService (copy), RefreshWavePanel (copy), UpdateFrameVisibility (copy), CollectionService (copy), SetCurrentBomb (copy), u13 (ref), u14 (ref), UpdateBombDisplay (copy)
    u12 = p63;
    u10 = p64;
    u11 = CreateWavePanel();

    for _, v in ipairs(u2) do
        local v65 = u10[v];
        u8[v] = {
            holder = v65,
            playerCountLabel = u10.Time[v].Players,
            morePlayersFrame = v65.MorePlayers,
            morePlayersAmountLabel = v65.MorePlayers.Amount
        };
    end;

    Observers.observeAttribute(workspace, "CTScore", function(p66) -- Line: 403
        -- upvalues: u10 (ref)
        u10.Time["Counter-Terrorists"].Score.Text = tostring(p66);

        return function() -- Line: 405
        end;
    end);
    Observers.observeAttribute(workspace, "TScore", function(p67) -- Line: 408
        -- upvalues: u10 (ref)
        u10.Time.Terrorists.Score.Text = tostring(p67);

        return function() -- Line: 410
        end;
    end);
    Observers.observeAttribute(workspace, "ServerGamemode", function(p68) -- Line: 413
        -- upvalues: PlayerInfo (ref)
        PlayerInfo.refreshCompetitiveColors();

        return function() -- Line: 415
        end;
    end);
    Remotes.UI.UIPlayerKilled.Listen(function(p69) -- Line: 418
        -- upvalues: Participants (ref), PlayerInfo (ref), u6 (ref), u7 (ref), RefreshTeamHud (ref)
        local v70 = tonumber(p69.Victim);
        local v71 = Participants.FromKey(v70);

        if v71 then
            local TemplateByUserId = PlayerInfo.getTemplateByUserId(v70);

            if TemplateByUserId and TemplateByUserId.Parent then
                local v72 = v71:GetAttribute("IsSpectating") == true;

                if not Participants.IsAlive(v71) or v72 then
                    PlayerInfo.applyTemplateLifeState(TemplateByUserId, true);
                end;
            end;

            local v73;

            if v71:GetAttribute("IsSpectating") == true then
                v73 = false;
            else
                v73 = Participants.IsAlive(v71);
            end;

            if u6[v71] ~= v73 then
                u6[v71] = v73;
                local v74 = u7[v71];

                if v74 == "Counter-Terrorists" and true or v74 == "Terrorists" then
                    RefreshTeamHud(v74);
                end;
            end;
        end;

        local v75 = tonumber(p69.Killer);

        if Participants.FromKey(v75) then
            PlayerInfo.incrementTemplateKills(v75);
        end;
    end);
    Remotes.UI.RoundWinner.Listen(function(p76) -- Line: 444
        -- upvalues: PlayerInfo (ref)
        PlayerInfo.setTeammateInfoRevealed(true);
    end);
    GameState.ListenToState(function(p77: string?, p78: string) -- Line: 448
        -- upvalues: PlayerInfo (ref)
        if p78 == "Buy Period" then
            PlayerInfo.setTeammateInfoRevealed(true);

            return;
        end;

        if p77 == "Buy Period" and p78 == "Round In Progress" then
            PlayerInfo.setTeammateInfoRevealed(false);
        end;
    end);

    local function refreshTimerText() -- Line: 459
        -- upvalues: u10 (ref), Color3_fromRGB_ret5 (ref), IsSurvivalMode (ref), SurvivalState (ref), GetTimerFormat (ref), Color3_fromRGB_ret6 (ref)
        local Attribute = workspace:GetAttribute("Timer");
        u10.Time.Timer.TextColor3 = Color3_fromRGB_ret5;

        if typeof(Attribute) ~= "number" then
            local v79;

            if IsSurvivalMode() then
                v79 = SurvivalState.GetWaveElapsed();
            else
                v79 = nil;
            end;

            if v79 then
                u10.Time.Timer.Text = GetTimerFormat((math.floor(v79)));
            end;

            return;
        end;

        local Attribute2 = workspace:GetAttribute("Gamemode");
        local Attribute3 = workspace:GetAttribute("GameState");
        local Attribute4 = workspace:GetAttribute("WaitingForPlayers");

        if Attribute3 == "Warmup" and (typeof(Attribute4) == "string" and Attribute4 ~= "") then
            u10.Time.Timer.Text = Attribute4;

            return;
        end;

        u10.Time.Timer.Text = GetTimerFormat(Attribute);

        if ((Attribute2 == "Bomb Defusal" or Attribute2 == "Hostage Rescue") and true or Attribute2 == "Zombie Survival") and (Attribute3 ~= "Warmup" and Attribute <= 10) then
            u10.Time.Timer.TextColor3 = Color3_fromRGB_ret6;
        end;
    end;

    local u80 = nil;
    local u81 = -1;

    local function refreshWaveClock() -- Line: 494
        -- upvalues: IsSurvivalMode (ref), SurvivalState (ref), u80 (ref), u81 (ref), RunService (ref), refreshTimerText (copy)
        local v82 = IsSurvivalMode() and SurvivalState.GetWaveElapsed() ~= nil;

        if v82 and not u80 then
            u81 = -1;
            u80 = RunService.Heartbeat:Connect(function() -- Line: 498
                -- upvalues: SurvivalState (ref), u81 (ref), refreshTimerText (ref)
                local v83 = SurvivalState.GetWaveElapsed() or 0;
                local math_floor_ret = math.floor(v83);

                if math_floor_ret ~= u81 then
                    u81 = math_floor_ret;
                    refreshTimerText();
                end;
            end);
        elseif not v82 and u80 then
            u80:Disconnect();
            u80 = nil;
        end;

        refreshTimerText();
    end;

    workspace:GetAttributeChangedSignal("Timer"):Connect(refreshTimerText);
    workspace:GetAttributeChangedSignal("WaitingForPlayers"):Connect(refreshTimerText);
    workspace:GetAttributeChangedSignal(SurvivalState.WAVE_STARTED_ATTRIBUTE):Connect(refreshWaveClock);
    refreshWaveClock();
    workspace:GetAttributeChangedSignal(SurvivalState.WAVE_ATTRIBUTE):Connect(RefreshWavePanel);
    local Score = u11.Score;
    local Wave = SurvivalState.GetWave();
    local math_max_ret = math.max(Wave, 1);
    Score.Text = tostring(math_max_ret);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(UpdateFrameVisibility);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(refreshWaveClock);
    u12.Gameplay.Middle.TeamSelection:GetPropertyChangedSignal("Visible"):Connect(UpdateFrameVisibility);
    CollectionService:GetInstanceAddedSignal("Bomb"):Connect(SetCurrentBomb);
    CollectionService:GetInstanceRemovedSignal("Bomb"):Connect(function(p84: userdata) -- Line: 526
        -- upvalues: u13 (ref), u14 (ref), UpdateBombDisplay (ref)
        if p84 == u13 then
            if u14 then
                u14:Disconnect();
                u14 = nil;
            end;

            u13 = nil;

            if u13 then
                u14 = u13:GetAttributeChangedSignal("Defused"):Connect(UpdateBombDisplay);
            end;

            UpdateBombDisplay();
        end;
    end);
    UpdateFrameVisibility();
    local v85 = CollectionService:GetTagged("Bomb")[1];

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    u13 = v85;

    if u13 then
        u14 = u13:GetAttributeChangedSignal("Defused"):Connect(UpdateBombDisplay);
    end;

    UpdateBombDisplay();

    for _, v in ipairs(u2) do
        RefreshTeamHud(v);
    end;
end;

function u1.Start() -- Line: 537
    -- upvalues: clearFrame (copy), u10 (ref), ResetRosterState (copy), Players (copy), u1 (copy), u5 (copy), Participants (copy)
    clearFrame(u10["Counter-Terrorists"]);
    clearFrame(u10.Terrorists);
    ResetRosterState();

    for _, v in Players:GetPlayers() do
        u1.PlayerAdded(v);
    end;

    Players.PlayerAdded:Connect(u1.PlayerAdded);
    Players.PlayerRemoving:Connect(function(p86: userdata) -- Line: 548, Name: removeParticipant
        -- upvalues: u5 (ref), u1 (ref)
        local v87 = u5[p86];
        u5[p86] = nil;

        if v87 then
            v87:Destroy();
        end;

        u1.CleanupTemplate(p86);
    end);
    Participants.Observe(function(p88: userdata) -- Line: 559
        -- upvalues: Participants (ref), u1 (ref)
        if Participants.IsBot(p88) then
            u1.PlayerAdded(p88);
        end;
    end, function(p89: userdata) -- Line: 563
        -- upvalues: Participants (ref), u5 (ref), u1 (ref)
        if Participants.IsBot(p89) then
            local v90 = u5[p89];
            u5[p89] = nil;

            if v90 then
                v90:Destroy();
            end;

            u1.CleanupTemplate(p89);
        end;
    end);
end;

return u1;