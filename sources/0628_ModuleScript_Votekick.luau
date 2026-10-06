-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local u2 = nil;
local u3 = nil;
local u4 = 0;
local u5 = false;

local function ShouldAutoCloseForState(p6: string?) -- Line: 35
    return p6 == "Game Ending" and true or p6 == "Map Voting";
end;

function u1.UpdateAmount(p7: string, p8: number, p9: string) -- Line: 39
    -- upvalues: u2 (ref), LocalPlayer (copy)
    u2.Option[p7].Amount.Text = `{p8}`;

    if LocalPlayer.UserId == tonumber(p9) then
        u2.Result.TextLabel.Text = `You voted: <font color="{p7 == "Yes" and "rgb(90, 186, 55)" or "rgb(255,49,49)"}">{string.upper(p7)}</font>`;
        u2.Result.Visible = true;
    end;
end;

function u1.UpdateFrame(p10: number, p11: number) -- Line: 50
    -- upvalues: Players (copy), u2 (ref)
    local PlayerByUserId = Players:GetPlayerByUserId(p10);
    local PlayerByUserId2 = Players:GetPlayerByUserId(p11);

    if PlayerByUserId then
        u2.Player.Text = `Kick player: {PlayerByUserId.Name}? `;
        u2.Frame.Title.Text = `Vote By: {PlayerByUserId2 and PlayerByUserId2.Name or "Unknown"}`;
        u2.Option.Yes.Amount.Text = "0";
        u2.Option.No.Amount.Text = "0";
    end;
end;

function u1.OpenFrame(p12: number) -- Line: 62
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u4 (ref), LocalPlayer (copy), TweenService (copy), u1 (copy)
    u2.Position = UDim2.fromScale(-0.08, 0.525);
    u2:SetAttribute("IsVoteKickActive", true);
    u2.Result.Visible = false;
    u3 = p12;
    u2.Visible = true;
    u5 = false;
    u4 = u4 + 1;
    local u13 = u4;

    if LocalPlayer.UserId == p12 then
        u2.Result.TextLabel.Text = "You are being vote kicked.";
        u2.Result.Visible = true;
    end;

    TweenService:Create(u2, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.08, 0.525)
    }):Play();
    task.delay(30, function() -- Line: 83
        -- upvalues: u4 (ref), u13 (copy), u1 (ref)
        if u4 == u13 then
            u1.CloseFrame();
        end;
    end);
end;

function u1.CloseFrame() -- Line: 90
    -- upvalues: u4 (ref), u2 (ref), u3 (ref), u5 (ref), TweenService (copy)
    u4 = u4 + 1;
    local u14 = u4;
    u2:SetAttribute("IsVoteKickActive", false);
    u2.Result.Visible = false;
    u3 = nil;
    u5 = false;

    if not u2.Visible then
        u2.Position = UDim2.fromScale(-0.08, 0.525);

        return;
    end;

    local v15 = TweenService:Create(u2, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(-0.08, 0.525)
    });
    v15.Completed:Once(function() -- Line: 107
        -- upvalues: u4 (ref), u14 (copy), u2 (ref)
        if u4 == u14 then
            u2.Visible = false;
        end;
    end);
    v15:Play();
end;

function u1.CastVote(p16: string) -- Line: 115
    -- upvalues: u3 (ref), LocalPlayer (copy), u5 (ref), Remotes (copy)
    if u3 and LocalPlayer.UserId == u3 then
        return;
    end;

    if not u5 then
        u5 = true;

        return (p16 == "Yes" and Remotes.VoteKick.VoteYes or Remotes.VoteKick.VoteNo).Send({
            Amount = 0,
            Voter = tostring(LocalPlayer.UserId)
        });
    end;
end;

function u1.Initialize(p17, p18) -- Line: 133
    -- upvalues: u2 (ref), GetUserPlatform (copy), Remotes (copy), u1 (copy), GameState (copy), ActivateButton (copy), UserInputService (copy)
    u2 = p18;
    u2:SetAttribute("IsVoteKickActive", false);
    u2.Visible = false;
    local v19 = table.find(GetUserPlatform(), "Mobile") ~= nil;
    local Keybinds = u2:FindFirstChild("Keybinds");
    local MobileNoButton = u2:FindFirstChild("MobileNoButton");
    local MobileYesButton = u2:FindFirstChild("MobileYesButton");

    if Keybinds then
        Keybinds.Visible = not v19;
    end;

    if MobileNoButton then
        MobileNoButton.Visible = v19;
    end;

    if MobileYesButton then
        MobileYesButton.Visible = v19;
    end;

    Remotes.VoteKick.VoteNoUpdate.Listen(function(p20) -- Line: 154
        -- upvalues: u1 (ref)
        u1.UpdateAmount("No", p20.Amount, p20.Voter);
    end);
    Remotes.VoteKick.VoteYesUpdate.Listen(function(p21) -- Line: 157
        -- upvalues: u1 (ref)
        u1.UpdateAmount("Yes", p21.Amount, p21.Voter);
    end);
    Remotes.VoteKick.StartVote.Listen(function(p22) -- Line: 160
        -- upvalues: GameState (ref), u1 (ref)
        local State = GameState.GetState();

        if State == "Game Ending" and true or State == "Map Voting" then
            return;
        end;

        local v23 = tonumber(p22.TargetUserId);
        local v24 = tonumber(p22.VoterUserId);
        u1.UpdateFrame(v23, v24);
        u1.OpenFrame(v23);
    end);
    Remotes.VoteKick.EndVote.Listen(function() -- Line: 169
        -- upvalues: u1 (ref)
        u1.CloseFrame();
    end);
    GameState.ListenToState(function(p25, p26) -- Line: 172
        -- upvalues: u1 (ref)
        if p26 == "Game Ending" and true or p26 == "Map Voting" then
            u1.CloseFrame();
        end;
    end);

    if not (v19 and (MobileNoButton and MobileYesButton)) then
        UserInputService.InputBegan:Connect(function(p27: userdata, p28: boolean) -- Line: 190
            -- upvalues: u2 (ref), UserInputService (ref), u1 (ref)
            if p28 or not (u2.Visible and (not UserInputService:GetFocusedTextBox() and p27.UserInputType == Enum.UserInputType.Keyboard)) then
                return;
            end;

            if p27.KeyCode == Enum.KeyCode.K then
                u1.CastVote("Yes");

                return;
            end;

            if p27.KeyCode == Enum.KeyCode.L then
                u1.CastVote("No");
            end;
        end);

        return;
    end;

    ActivateButton(MobileNoButton);
    ActivateButton(MobileYesButton);
    MobileNoButton.Activated:Connect(function() -- Line: 182
        -- upvalues: u1 (ref)
        u1.CastVote("No");
    end);
    MobileYesButton.Activated:Connect(function() -- Line: 185
        -- upvalues: u1 (ref)
        u1.CastVote("Yes");
    end);
end;

return u1;