-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local RadialProgress = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.DefuseBomb.RadialProgress);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Signal = require(ReplicatedStorage.Packages.Signal);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local LocalPlayer = Players.LocalPlayer;
local Vector2_new_ret = Vector2.new(0.85, 0.85);
local u2 = nil;
local u3 = nil;

local function isSpectatingOtherRescue(p4) -- Line: 84
    -- upvalues: LocalPlayer (copy), SpectateController (copy)
    local Attribute = LocalPlayer:GetAttribute("IsSpectating");
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if Attribute then
        if CurrentSpectateInstance then
            CurrentSpectateInstance = p4.PlayerName ~= LocalPlayer.Name;
        end;
    else
        CurrentSpectateInstance = Attribute;
    end;

    return CurrentSpectateInstance;
end;

function u1.InitializeProgressBar(p5) -- Line: 93
    -- upvalues: RadialProgress (copy)
    RadialProgress.Initialize(p5, "RescueHostage");
end;

function u1.UpdateProgressBar(p6: table, p7: number) -- Line: 97
    -- upvalues: RadialProgress (copy), Vector2_new_ret (copy)
    RadialProgress.Update(p6, p7, "Hostage", Vector2_new_ret);
end;

function u1.UpdateTimer(p8: table, p9: number) -- Line: 101
    -- upvalues: RadialProgress (copy)
    RadialProgress.SetTimer(p8.Frame, p9);
end;

function u1.UpdateTitle(p10) -- Line: 105
    -- upvalues: RadialProgress (copy)
    RadialProgress.SetTitle(p10.Frame, string.format("%s is rescuing the hostage %s a kit.", p10.PlayerName, p10.HasRescueKit and "with" or "without"));
end;

function u1.StartRescue(u11: table, p12: userdata?) -- Line: 112
    -- upvalues: LocalPlayer (copy), SpectateController (copy), Participants (copy), RunServiceController (copy), Remotes (copy)
    if u11.IsRescuing then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("IsSpectating");
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();
    local v13 = p12 or (Attribute and (CurrentSpectateInstance and CurrentSpectateInstance.Player) or LocalPlayer);
    u11.HasRescueKit = v13:GetAttribute("HasRescueKit");
    u11.PlayerName = Participants.Name(v13);
    u11.RescueTime = u11.HasRescueKit and 1 or 4;
    local Attribute2 = v13:GetAttribute("RescueStartTime");

    if Attribute2 and (Attribute or v13 ~= LocalPlayer) then
        local v14 = tick();

        if Attribute2 <= v14 and v14 - Attribute2 <= u11.RescueTime then
            u11.RescueStartTime = Attribute2;
        else
            u11.RescueStartTime = v14;
        end;
    else
        u11.RescueStartTime = tick();
    end;

    u11.RescueProgress = 0;
    u11.IsRescuing = true;

    if u11.Frame then
        u11.Frame.Visible = true;
    end;

    u11:UpdateProgressBar(0);
    u11:UpdateTimer(u11.RescueTime);
    u11:UpdateTitle();
    u11.Janitor:Add(RunServiceController.BindToHeartbeat("UI.RescueHostage.UpdateProgress", function() -- Line: 150
        -- upvalues: u11 (copy), LocalPlayer (ref), SpectateController (ref)
        if not u11.IsRescuing or u11.IsFinished then
            return;
        end;

        local Attribute3 = LocalPlayer:GetAttribute("IsSpectating");
        local CurrentSpectateInstance2 = SpectateController.GetCurrentSpectateInstance();

        if Attribute3 then
            if CurrentSpectateInstance2 then
                Attribute3 = u11.PlayerName ~= LocalPlayer.Name;
            else
                Attribute3 = CurrentSpectateInstance2;
            end;
        end;

        if Attribute3 and CurrentSpectateInstance2 then
            local Player = CurrentSpectateInstance2.Player;

            if not Player:GetAttribute("IsRescuingHostage") then
                if u11.RescueProgress >= 0.95 then
                    u11:FinishRescue();

                    return;
                end;

                u11:CancelRescue();

                return;
            end;

            local Attribute4 = Player:GetAttribute("RescueStartTime");

            if Attribute4 then
                local v15 = tick();

                if Attribute4 < u11.RescueStartTime and (Attribute4 <= v15 and v15 - Attribute4 <= u11.RescueTime) then
                    u11.RescueStartTime = Attribute4;
                end;
            end;
        end;

        local v16 = tick() - u11.RescueStartTime;
        u11.RescueProgress = math.min(v16 / u11.RescueTime, 1);
        u11:UpdateProgressBar(u11.RescueProgress);
        u11:UpdateTimer((math.max(u11.RescueTime - v16, 0)));

        if u11.RescueProgress < 1 or (u11.IsFinished or Attribute3) then
            return;
        end;

        u11:FinishRescue();
    end), "Disconnect", "ProgressConnection");

    if not Attribute or v13 == LocalPlayer then
        Remotes.Hostage.StartRescue.Send();
    end;

    u11.RescueStarted:Fire();
end;

function u1.CancelRescue(u17) -- Line: 204
    -- upvalues: LocalPlayer (copy), SpectateController (copy), Remotes (copy)
    if not u17.IsRescuing then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("IsSpectating");
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if Attribute then
        if CurrentSpectateInstance then
            CurrentSpectateInstance = u17.PlayerName ~= LocalPlayer.Name;
        end;
    else
        CurrentSpectateInstance = Attribute;
    end;

    u17.IsRescuing = false;
    u17.IsFinished = true;
    u17:UpdateProgressBar(0);

    if u17.Frame then
        u17.Frame.Visible = false;
    end;

    if not CurrentSpectateInstance then
        Remotes.Hostage.CancelRescue.Send();
    end;

    u17.RescueCancelled:Fire();
    task.defer(function() -- Line: 227
        -- upvalues: u17 (copy)
        u17:Destroy();
    end);
end;

function u1.FinishRescue(u18) -- Line: 232
    -- upvalues: LocalPlayer (copy), SpectateController (copy), Remotes (copy)
    if not u18.IsRescuing or u18.IsFinished then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("IsSpectating");
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if Attribute then
        if CurrentSpectateInstance then
            CurrentSpectateInstance = u18.PlayerName ~= LocalPlayer.Name;
        end;
    else
        CurrentSpectateInstance = Attribute;
    end;

    u18.IsFinished = true;
    u18.IsRescuing = false;

    if not CurrentSpectateInstance then
        Remotes.Hostage.PickedUp.Send();
    end;

    u18.RescueFinished:Fire();
    task.delay(0.5, function() -- Line: 251
        -- upvalues: u18 (copy)
        u18:Destroy();
    end);
end;

function u1.new(p19) -- Line: 259
    -- upvalues: u1 (copy), Janitor (copy), Signal (copy)
    local v20 = setmetatable({}, u1);
    v20.Janitor = Janitor.new();
    v20.Frame = p19;
    v20.RescueTime = 4;
    v20.HasRescueKit = false;
    v20.RescueStartTime = 0;
    v20.RescueProgress = 0;
    v20.IsRescuing = false;
    v20.IsFinished = false;
    v20.PlayerName = "";
    v20.RescueCancelled = v20.Janitor:Add(Signal.new());
    v20.RescueFinished = v20.Janitor:Add(Signal.new());
    v20.RescueStarted = v20.Janitor:Add(Signal.new());

    if v20.Frame then
        v20.Frame.Visible = false;
    end;

    v20:InitializeProgressBar();

    return v20;
end;

function u1.Destroy(p21) -- Line: 293
    -- upvalues: u3 (ref)
    if u3 == p21 then
        u3 = nil;
    end;

    if p21.Frame then
        p21.Frame.Visible = false;
    end;

    p21.Janitor:Destroy();
end;

function u1.Initialize(p22, p23) -- Line: 311
    -- upvalues: u2 (ref), GameState (copy), u3 (ref), Router (copy), u1 (copy), LocalPlayer (copy), SpectateController (copy)
    u2 = p23;
    GameState.ListenToState(function(p24, p25) -- Line: 315
        -- upvalues: u3 (ref)
        if (p25 == "Buy Period" or p25 == "Warmup") and u3 then
            u3:Destroy();
            u3 = nil;
        end;
    end);
    Router.observerRouter("Start Rescue Hostage", function() -- Line: 325
        -- upvalues: u3 (ref), u1 (ref), u2 (ref)
        if not u3 then
            u3 = u1.new(u2);
        end;

        u3:StartRescue();

        return nil;
    end);
    Router.observerRouter("Cancel Rescue Hostage", function() -- Line: 335
        -- upvalues: u3 (ref)
        if u3 then
            u3:CancelRescue();
            u3 = nil;
        end;

        return nil;
    end);
    local u26 = nil;

    local function updateSpectateRescue() -- Line: 347
        -- upvalues: LocalPlayer (ref), SpectateController (ref), u3 (ref), u1 (ref), u2 (ref)
        local Attribute = LocalPlayer:GetAttribute("IsSpectating");
        local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

        if Attribute and CurrentSpectateInstance then
            local Player = CurrentSpectateInstance.Player;

            if Player:GetAttribute("IsRescuingHostage") then
                if not u3 then
                    u3 = u1.new(u2);
                end;

                u3:StartRescue(Player);

                return;
            end;

            if u3 then
                u3:CancelRescue();
                u3 = nil;
            end;
        elseif u3 and not LocalPlayer:GetAttribute("IsRescuingHostage") then
            u3:CancelRescue();
            u3 = nil;
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(updateSpectateRescue);
    SpectateController.ListenToSpectate:Connect(function() -- Line: 381, Name: setupSpectateRescueListener
        -- upvalues: u26 (ref), SpectateController (ref), updateSpectateRescue (copy)
        if u26 then
            u26:Disconnect();
            u26 = nil;
        end;

        local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

        if CurrentSpectateInstance then
            u26 = CurrentSpectateInstance.Player:GetAttributeChangedSignal("IsRescuingHostage"):Connect(updateSpectateRescue);
            updateSpectateRescue();
        end;
    end);
    task.wait(0.1);

    if u26 then
        u26:Disconnect();
        u26 = nil;
    end;

    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if CurrentSpectateInstance then
        u26 = CurrentSpectateInstance.Player:GetAttributeChangedSignal("IsRescuingHostage"):Connect(updateSpectateRescue);
        updateSpectateRescue();
    end;
end;

return u1;