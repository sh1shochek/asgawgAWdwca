-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Observers = require(ReplicatedStorage.Packages.Observers);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function clearFrame(p6: userdata, p7: string) -- Line: 38
    for _, child in ipairs(p6:GetChildren()) do
        if child.ClassName == p7 then
            child:Destroy();
        end;
    end;
end;

local function updateVotingFrame(p8: table?) -- Line: 46
    -- upvalues: u3 (ref), Players (copy)
    local Children = u3.MapVote:GetChildren();

    for _, v in ipairs(Children) do
        if v:IsA("ImageButton") then
            local v9 = p8 and p8[v.Name] or v:GetAttribute("Amount");

            if v9 then
                v.Main.Amount.Text = `<font color="rgb(219,199,126)">{v9}</font>/{#Players:GetPlayers()}`;
                v:SetAttribute("Amount", v9);
            end;
        end;
    end;
end;

local function tweenVoteStroke(p10: any, p11: number, p12: number) -- Line: 61
    -- upvalues: TweenService (copy)
    TweenService:Create(p10.Main.UIStroke, TweenInfo.new(0.5), {
        Transparency = p11
    }):Play();
    TweenService:Create(p10.Main.UIStroke, TweenInfo.new(0.5), {
        Thickness = p12
    }):Play();
end;

local function cancelMapVoteBar() -- Line: 70
    -- upvalues: u5 (ref)
    if u5 then
        u5:Cancel();
        u5 = nil;
    end;
end;

local function createVoteButton(p13: number, u14: any) -- Line: 77
    -- upvalues: ReplicatedStorage (copy), Players (copy), u3 (ref), u2 (ref), Remotes (copy), tweenVoteStroke (copy), TweenService (copy)
    local v15 = ReplicatedStorage.Database.Custom.GameStats.Maps:WaitForChild(u14, 10);

    if not v15 then
        warn((`Failed to load map module for {u14} - map may not exist or hasn't replicated yet`));

        return;
    end;

    local v16 = require(v15);

    if not (v16 and v16.Icon) then
        warn((`Map {u14} is missing Icon property`));

        return;
    end;

    local u17 = ReplicatedStorage.Assets.UI.EndScreen.VoteTemplate:Clone();
    u17.Main.Amount.Text = `<font color="rgb(219,199,126)">0</font>/{#Players:GetPlayers()}`;
    u17.Main.Icon.Image = v16.Icon;
    u17.Parent = u3.MapVote;
    u17.Main.Selection.Text = u14;
    u17:SetAttribute("Amount", 0);
    u17.Title.Visible = p13 == 1;
    u17.Voted.Visible = false;
    u17.Name = u14;
    u17.Button.MouseButton1Click:Connect(function() -- Line: 102
        -- upvalues: u2 (ref), u14 (copy), Remotes (ref), tweenVoteStroke (ref), u17 (copy), u3 (ref)
        if u2 ~= u14 then
            Remotes.Map.SubmitMapVote.Send(u14);
            tweenVoteStroke(u17, 0, 5.5);

            if u2 then
                tweenVoteStroke(u3.MapVote:FindFirstChild(u2), 0.75, 1.5);
            end;

            u2 = u14;
        end;
    end);
    u17.Button.MouseEnter:Connect(function() -- Line: 112
        -- upvalues: TweenService (ref), u17 (copy)
        TweenService:Create(u17.Main.Icon.UIScale, TweenInfo.new(0.5), {
            Scale = 1.1
        }):Play();
    end);
    u17.Button.MouseLeave:Connect(function() -- Line: 115
        -- upvalues: TweenService (ref), u17 (copy)
        TweenService:Create(u17.Main.Icon.UIScale, TweenInfo.new(0.5), {
            Scale = 1
        }):Play();
    end);
end;

function u1.CloseFrame() -- Line: 123
    -- upvalues: u3 (ref), CameraController (copy), LocalPlayer (copy), ReplicatedStorage (copy), u4 (ref)
    local Visible = u3.Visible;
    u3.Visible = false;
    CameraController.setForceLockOverride("EndScreen", false);

    if Visible then
        local Attribute = LocalPlayer:GetAttribute("Team");

        if not (LocalPlayer.Character and Attribute) or Attribute == "Spectators" then
            require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection).openFrame();

            return;
        end;
    end;

    if not (require(ReplicatedStorage.Controllers.MenuSceneController).IsActive() or u4.Menu.Visible) then
        return;
    end;

    require(ReplicatedStorage.Interface.Screens.Menu.Top).ResetToMainMenu();

    if not u4.Menu.Visible then
        CameraController.setForceLockOverride("Menu", true);
        u4.Menu.Visible = true;
    end;

    u4.Gameplay.Visible = false;
end;

function u1.Initialize(p18, p19) -- Line: 164
    -- upvalues: u3 (ref), u4 (ref), clearFrame (copy), Remotes (copy), u5 (ref), u2 (ref), createVoteButton (copy), updateVotingFrame (copy), u1 (copy), Observers (copy), GetTimerFormat (copy), GameState (copy), TweenService (copy)
    u3 = p19;
    u4 = p18;
    clearFrame(u3.MapVote, "ImageButton");
    Remotes.Map.StartMapVote.Listen(function(p20: table) -- Line: 168
        -- upvalues: u5 (ref), clearFrame (ref), u3 (ref), u2 (ref), createVoteButton (ref)
        if u5 then
            u5:Cancel();
            u5 = nil;
        end;

        clearFrame(u3.MapVote, "ImageButton");
        u2 = nil;

        for i, v in ipairs(p20) do
            createVoteButton(i, v);
        end;
    end);
    Remotes.Map.UpdateMapVote.Listen(updateVotingFrame);
    Remotes.Map.EndMapVote.Listen(function(p21: string) -- Line: 177
        -- upvalues: u5 (ref), u1 (ref)
        if u5 then
            u5:Cancel();
            u5 = nil;
        end;

        u1.CloseFrame();
    end);
    Observers.observePlayer(function() -- Line: 182
        -- upvalues: updateVotingFrame (ref)
        updateVotingFrame();

        return function() -- Line: 184
            -- upvalues: updateVotingFrame (ref)
            updateVotingFrame();
        end;
    end);
    Observers.observeAttribute(workspace, "Timer", function(p22) -- Line: 188
        -- upvalues: u3 (ref), GetTimerFormat (ref), GameState (ref), u5 (ref), TweenService (ref)
        u3.Top.Timer.Text = GetTimerFormat(p22);

        if GameState.GetState() == "Map Voting" and not u5 then
            local Extra = u3.Top:FindFirstChild("Extra");

            if Extra and p22 > 0 then
                Extra.Size = UDim2.new(0, 0, Extra.Size.Y.Scale, Extra.Size.Y.Offset);
                local v23 = TweenService:Create(Extra, TweenInfo.new(p22 * 1.15, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(1, 0, Extra.Size.Y.Scale, Extra.Size.Y.Offset)
                });
                u5 = v23;
                v23:Play();
            end;
        end;
    end);

    if GameState.GetState() == "Map Voting" then
        local v24 = false;

        for _, child in ipairs(u3.MapVote:GetChildren()) do
            if child:IsA("ImageButton") then
                v24 = true;
                break;
            end;
        end;

        if not v24 then
            Remotes.Map.RequestMapVote.Send();
        end;
    end;
end;

return u1;