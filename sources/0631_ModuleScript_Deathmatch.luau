-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local PlayerInfo = require(ReplicatedStorage.Interface.Screens.Gameplay.Top.PlayerInfo);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(165, 20, 20);
local u2 = nil;
local u3 = nil;
local u4 = {};
local u5 = {};

local function clearFrame(p6) -- Line: 46
    for _, child in ipairs(p6:GetChildren()) do
        if child.ClassName == "Frame" and child.Name ~= "MorePlayers" then
            child:Destroy();
        end;
    end;
end;

local function compareLayoutOrder(p7: userdata, p8: userdata) -- Line: 54
    return p7.LayoutOrder < p8.LayoutOrder;
end;

local function updateFrameVisibility() -- Line: 59
    -- upvalues: u2 (ref), u3 (ref), compareLayoutOrder (copy)
    if not (u2 and u3) then
        return;
    end;

    local v9;

    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        v9 = not u3.Gameplay.Middle.TeamSelection.Visible;
    else
        v9 = false;
    end;

    u2.Visible = v9;

    if not u2.Visible then
        return;
    end;

    local MorePlayers = u2.Players.MorePlayers;
    local v10 = {};

    for _, child in ipairs(u2.Players:GetChildren()) do
        if child.ClassName == "Frame" and child.Name ~= "MorePlayers" then
            table.insert(v10, child);
        end;
    end;

    table.sort(v10, compareLayoutOrder);

    for i, v in ipairs(v10) do
        v.Visible = i <= 5;
    end;

    local math_max_ret = math.max(#v10 - 5, 0);
    MorePlayers.Visible = math_max_ret > 0;
    MorePlayers.Content.Amount.Text = `+{math_max_ret}`;
end;

function u1.createTemplate(u11: userdata) -- Line: 94
    -- upvalues: Profiler (copy), u1 (copy), PlayerInfo (copy), u2 (ref), u4 (copy), updateFrameVisibility (copy)
    Profiler.scope("UI.Deathmatch.CreateTemplate", function() -- Line: 95
        -- upvalues: u11 (copy), u1 (ref), PlayerInfo (ref), u2 (ref), u4 (ref), updateFrameVisibility (ref)
        local Attribute = workspace:GetAttribute("Gamemode");
        local Attribute2 = u11:GetAttribute("Team");

        if Attribute == "Deathmatch" and (Attribute2 == "Terrorists" or Attribute2 == "Counter-Terrorists") then
            u1.cleanupPlayerTemplate(u11);
            local v12 = PlayerInfo.createTemplate(u11, u2.Players);

            if v12 then
                u4[u11] = v12;
            end;

            updateFrameVisibility();
        end;
    end);
end;

function u1.cleanupPlayerTemplate(p13: userdata) -- Line: 112
    -- upvalues: u4 (copy), PlayerInfo (copy), updateFrameVisibility (copy)
    local v14 = u4[p13];
    u4[p13] = nil;

    if v14 then
        PlayerInfo.cleanupTemplate(p13);
        v14:Destroy();
        updateFrameVisibility();
    end;
end;

function u1.playerAdded(u15: userdata) -- Line: 123
    -- upvalues: u5 (copy), Janitor (copy), PlayerInfo (copy), Participants (copy), u1 (copy), updateFrameVisibility (copy)
    local v16 = u5[u15];

    if v16 then
        v16:Destroy();
    end;

    local v17 = Janitor.new();
    u5[u15] = v17;

    local function applyLifeStateToTemplate() -- Line: 132
        -- upvalues: PlayerInfo (ref), Participants (ref), u15 (copy)
        local TemplateByUserId = PlayerInfo.getTemplateByUserId(Participants.Key(u15));

        if not TemplateByUserId then
            return;
        end;

        local v18 = not Participants.IsAlive(u15) or u15:GetAttribute("IsSpectating") == true;
        PlayerInfo.applyTemplateLifeState(TemplateByUserId, v18);
    end;

    local function handleTeamUpdate() -- Line: 142
        -- upvalues: u15 (copy), u1 (ref), applyLifeStateToTemplate (copy)
        local Attribute = u15:GetAttribute("Team");

        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            u1.cleanupPlayerTemplate(u15);

            return;
        end;

        u1.createTemplate(u15);
        applyLifeStateToTemplate();
    end;

    v17:Add(u15:GetAttributeChangedSignal("Team"):Connect(handleTeamUpdate));
    v17:Add(u15:GetAttributeChangedSignal("IsSpectating"):Connect(applyLifeStateToTemplate));
    v17:Add(u15:GetAttributeChangedSignal("Dead"):Connect(applyLifeStateToTemplate));
    v17:Add(u15:GetAttributeChangedSignal("Health"):Connect(applyLifeStateToTemplate));
    v17:Add(u15:GetAttributeChangedSignal("Score"):Connect(function() -- Line: 156
        -- upvalues: updateFrameVisibility (ref)
        task.defer(updateFrameVisibility);
    end));
    local Attribute = u15:GetAttribute("Team");

    if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
        u1.cleanupPlayerTemplate(u15);

        return;
    end;

    u1.createTemplate(u15);
    applyLifeStateToTemplate();
end;

function u1.Initialize(p19, p20) -- Line: 166
    -- upvalues: u3 (ref), u2 (ref), Observers (copy), Color3_fromRGB_ret (copy), GetTimerFormat (copy), Color3_fromRGB_ret2 (copy), Router (copy), updateFrameVisibility (copy)
    u3 = p19;
    u2 = p20;
    Observers.observeAttribute(workspace, "Timer", function(p21) -- Line: 169
        -- upvalues: u2 (ref), Color3_fromRGB_ret (ref), GetTimerFormat (ref), Color3_fromRGB_ret2 (ref), Router (ref)
        local Attribute = workspace:GetAttribute("Gamemode");
        local Attribute2 = workspace:GetAttribute("GameState");
        u2.Time.Timer.TextColor3 = Color3_fromRGB_ret;
        u2.Time.Timer.Text = GetTimerFormat(p21);

        if Attribute == "Deathmatch" and (Attribute2 ~= "Warmup" and p21 <= 10) then
            u2.Time.Timer.TextColor3 = Color3_fromRGB_ret2;
            Router.broadcastRouter("PlayCountdownTimer");
        end;
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(updateFrameVisibility);
    u3.Gameplay.Middle.TeamSelection:GetPropertyChangedSignal("Visible"):Connect(updateFrameVisibility);
    updateFrameVisibility();
end;

function u1.Start() -- Line: 184
    -- upvalues: clearFrame (copy), u2 (ref), Players (copy), u1 (copy), u5 (copy), updateFrameVisibility (copy), Participants (copy)
    clearFrame(u2.Players);

    for _, v in Players:GetPlayers() do
        u1.playerAdded(v);
    end;

    Players.PlayerAdded:Connect(u1.playerAdded);
    Players.PlayerRemoving:Connect(function(p22: userdata) -- Line: 191, Name: removeParticipant
        -- upvalues: u5 (ref), u1 (ref), updateFrameVisibility (ref)
        local v23 = u5[p22];
        u5[p22] = nil;

        if v23 then
            v23:Destroy();
        end;

        u1.cleanupPlayerTemplate(p22);
        updateFrameVisibility();
    end);
    Participants.Observe(function(p24: userdata) -- Line: 203
        -- upvalues: Participants (ref), u1 (ref)
        if Participants.IsBot(p24) then
            u1.playerAdded(p24);
        end;
    end, function(p25: userdata) -- Line: 207
        -- upvalues: Participants (ref), u5 (ref), u1 (ref), updateFrameVisibility (ref)
        if Participants.IsBot(p25) then
            local v26 = u5[p25];
            u5[p25] = nil;

            if v26 then
                v26:Destroy();
            end;

            u1.cleanupPlayerTemplate(p25);
            updateFrameVisibility();
        end;
    end);
end;

return u1;