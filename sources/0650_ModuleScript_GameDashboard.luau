-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local Votekick = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Votekick);
local LocalPlayer = Players.LocalPlayer;
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection);
local u2 = nil;
local u3 = nil;

local function ClearFrame(p4: userdata) -- Line: 36
    for _, child in ipairs(p4:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;
end;

local function IsActiveTeamPlayer(p5: userdata) -- Line: 46
    -- upvalues: Votekick (copy)
    return Votekick.GetActiveTeam(p5:GetAttribute("Team")) ~= nil;
end;

local function GetActiveTeamPlayerCount() -- Line: 52
    -- upvalues: Players (copy), Votekick (copy)
    local v6 = 0;

    for _, v in ipairs(Players:GetPlayers()) do
        if Votekick.GetActiveTeam(v:GetAttribute("Team")) ~= nil then
            v6 = v6 + 1;
        end;
    end;

    return v6;
end;

function u1.PlayerAdded(u7) -- Line: 65
    -- upvalues: LocalPlayer (copy), Votekick (copy), u3 (ref), ReplicatedStorage (copy), Router (copy), Remotes (copy)
    if LocalPlayer == u7 or Votekick.GetActiveTeam(u7:GetAttribute("Team")) == nil then
        return;
    end;

    if not u3.Menu.VoteKick.Container:FindFirstChild((tostring(u7.UserId))) then
        local v8 = ReplicatedStorage.Assets.UI.VoteKick.PlayerTemplate:Clone();
        v8.PlayerIcon.Image = `rbxthumb://type=AvatarHeadShot&id={u7.UserId}&w=420&h=420`;
        v8.PlayerInfo.Username.Text = `@{u7.Name}`;
        v8.PlayerInfo.Nickname.Text = u7.DisplayName;
        v8.Parent = u3.Menu.VoteKick.Container;
        v8.Name = tostring(u7.UserId);
        v8.MouseButton1Click:Connect(function() -- Line: 77
            -- upvalues: Router (ref), Remotes (ref), u7 (copy), u3 (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            Remotes.VoteKick.CallVote.Send((tostring(u7.UserId)));
            u3.Menu.VoteKick.Visible = false;
        end);
    end;
end;

function u1.RefreshVoteKickEntries() -- Line: 87
    -- upvalues: ClearFrame (copy), u3 (ref), Players (copy), u1 (copy)
    ClearFrame(u3.Menu.VoteKick.Container);

    for _, v in ipairs(Players:GetPlayers()) do
        u1.PlayerAdded(v);
    end;
end;

function u1.OpenChooseTeam() -- Line: 97
    -- upvalues: LocalPlayer (copy), TeamSelection (copy)
    local Attribute = LocalPlayer:GetAttribute("IsSpectating");
    local Attribute2 = LocalPlayer:GetAttribute("Team");

    if Attribute2 ~= "Counter-Terrorists" and Attribute2 ~= "Terrorists" and Attribute ~= true then
        return;
    end;

    if Attribute then
        TeamSelection.openFrame();

        return;
    end;

    if LocalPlayer.Character then
        TeamSelection.ToggleTeamSelection();
    end;
end;

function u1.Initialize(p9, p10) -- Line: 122
    -- upvalues: u3 (ref), u2 (ref), u1 (copy), Players (copy)
    u3 = p9;
    u2 = p10;
    u1.RefreshVoteKickEntries();
    Players.PlayerAdded:Connect(function(p11) -- Line: 127
        -- upvalues: u1 (ref)
        u1.PlayerAdded(p11);
    end);
    Players.PlayerRemoving:Connect(function(p12) -- Line: 130
        -- upvalues: u3 (ref)
        local v13 = u3.Menu.VoteKick.Container:FindFirstChild((tostring(p12.UserId)));

        if v13 then
            v13:Destroy();
        end;
    end);
end;

function u1.Start() -- Line: 140
    -- upvalues: ActivateButton (copy), u3 (ref), CloseButtonRegistry (copy), Router (copy), u2 (ref), u1 (copy), Votekick (copy), LocalPlayer (copy), DataController (copy), GetActiveTeamPlayerCount (copy)
    ActivateButton(u3.Menu.VoteKick.Buttons.Close);
    CloseButtonRegistry.Add(u3.Menu.VoteKick, u3.Menu.VoteKick.Buttons.Close, function() -- Line: 143
        -- upvalues: Router (ref), u3 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u3.Menu.VoteKick.Visible = false;
    end);
    ActivateButton(u2.ChooseTeam);
    u2.ChooseTeam.MouseButton1Click:Connect(function() -- Line: 149
        -- upvalues: u1 (ref)
        u1.OpenChooseTeam();
    end);
    ActivateButton(u2.VoteKick);
    u2.VoteKick.MouseButton1Click:Connect(function() -- Line: 154
        -- upvalues: Router (ref), u3 (ref), Votekick (ref), LocalPlayer (ref), DataController (ref), GetActiveTeamPlayerCount (ref), u1 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local VoteKick = u3.Menu:FindFirstChild("VoteKick");

        if not VoteKick then
            return;
        end;

        local ActiveTeam = Votekick.GetActiveTeam(LocalPlayer:GetAttribute("Team"));

        if LocalPlayer:GetAttribute("IsSpectating") and not ActiveTeam then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You cannot vote kick while spectating as a spectator.");

            return;
        end;

        if not ActiveTeam then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You must be on a team to start a vote kick.");

            return;
        end;

        local v14 = DataController.Get(LocalPlayer, "Level");
        local v15;

        if typeof(v14) == "table" then
            v15 = tonumber(v14.Level);
        else
            v15 = nil;
        end;

        if not v15 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Your data is still loading. Please try again in a moment.");

            return;
        end;

        if v15 < Votekick.MIN_LEVEL then
            Router.broadcastRouter("CreateMenuNotification", "Error", (`You need to be level {Votekick.MIN_LEVEL} to vote kick players.`));

            return;
        end;

        if GetActiveTeamPlayerCount() < Votekick.MINIMUM_ACTIVE_PLAYERS then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Not enough active players to start a vote kick.");

            return;
        end;

        pcall(function() -- Line: 188
            -- upvalues: u1 (ref)
            u1.RefreshVoteKickEntries();
        end);
        VoteKick.Visible = true;
    end);
end;

return u1;