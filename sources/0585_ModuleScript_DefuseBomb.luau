-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local UserInputService = game:GetService("UserInputService");
require(script:WaitForChild("Types"));
local RadialProgress = require(script:WaitForChild("RadialProgress"));
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Signal = require(ReplicatedStorage.Packages.Signal);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips);
local LocalPlayer = Players.LocalPlayer;
local u2 = table.find(GetUserPlatform(), "Mobile") and #GetUserPlatform() <= 1;
local u3 = nil;
local u4 = 0;
local u5 = 0;
local u6 = 0;
local Vector2_new_ret = Vector2.new(0.5, 0.45);
local u7 = nil;
local u8 = nil;

local function getBombModel() -- Line: 103
    -- upvalues: CollectionService (copy)
    return CollectionService:GetTagged("Bomb")[1];
end;

local function isBombResolvedState(p9: userdata?) -- Line: 107
    if p9 then
        return (p9:GetAttribute("Defused") == true or p9:GetAttribute("Exploding") == true) and true or p9:GetAttribute("Exploded") == true;
    end;

    return false;
end;

local function getSyncedDefuseStartTime(p10: userdata, p11: number) -- Line: 117
    local Attribute = p10:GetAttribute("DefuseStartTime");

    if typeof(Attribute) ~= "number" then
        return nil;
    end;

    local ServerTimeNow = workspace:GetServerTimeNow();
    local v12 = ServerTimeNow - Attribute;

    if Attribute <= ServerTimeNow and (v12 >= 0 and v12 <= math.max(p11, 12)) then
        return Attribute;
    end;

    return nil;
end;

local function isSpectatingOtherDefuse(p13) -- Line: 135
    -- upvalues: LocalPlayer (copy), SpectateController (copy)
    local Attribute = LocalPlayer:GetAttribute("IsSpectating");
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if Attribute then
        if CurrentSpectateInstance then
            CurrentSpectateInstance = p13.PlayerName ~= LocalPlayer.Name;
        end;
    else
        CurrentSpectateInstance = Attribute;
    end;

    return CurrentSpectateInstance;
end;

local function resolveFromBombState(p14: any, p15: userdata?) -- Line: 142
    if p15 and p15:GetAttribute("Defused") == true then
        p14:FinishDefuse(true);

        return;
    end;

    p14:CancelDefuse(true);
end;

local function getHoldToDefuseMessage() -- Line: 150
    -- upvalues: UserInputService (copy), Tips (copy)
    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        return "Keep holding the <b>Interact</b> button until the defuse finishes";
    end;

    local ActionKeyText = Tips.GetActionKeyText("Use");

    return not ActionKeyText and "Keep holding the use button until the defuse finishes" or `Keep holding <b>{ActionKeyText}</b> until the defuse finishes`;
end;

local function notifyTutorialDefuseCancelled(p16: any, p17: string?) -- Line: 161
    -- upvalues: IsTutorialMode (copy), LocalPlayer (copy), SpectateController (copy), CollectionService (copy), u5 (ref), Router (copy), UserInputService (copy), Tips (copy)
    if not (IsTutorialMode() and (p16.IsDefusing and not p16.HasSentDefuseRequest)) then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("IsSpectating");
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if Attribute then
        if CurrentSpectateInstance then
            CurrentSpectateInstance = p16.PlayerName ~= LocalPlayer.Name;
        end;
    else
        CurrentSpectateInstance = Attribute;
    end;

    if not CurrentSpectateInstance then
        local v18 = CollectionService:GetTagged("Bomb")[1];
        local v19;

        if v18 then
            v19 = (v18:GetAttribute("Defused") == true or v18:GetAttribute("Exploding") == true) and true or v18:GetAttribute("Exploded") == true;
        else
            v19 = false;
        end;

        if not v19 then
            if os.clock() - u5 < 2 then
                return;
            end;

            u5 = os.clock();
            local broadcastRouter = Router.broadcastRouter;

            if not p17 then
                if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
                    p17 = "Keep holding the <b>Interact</b> button until the defuse finishes";
                else
                    local ActionKeyText = Tips.GetActionKeyText("Use");
                    p17 = not ActionKeyText and "Keep holding the use button until the defuse finishes" or `Keep holding <b>{ActionKeyText}</b> until the defuse finishes`;
                end;
            end;

            broadcastRouter("CreateNotification", "Defuse Cancelled", p17, 3);
        end;
    end;
end;

function u1.InitializeProgressBar(p20) -- Line: 183
    -- upvalues: RadialProgress (copy)
    RadialProgress.Initialize(p20, "DefuseBomb");
end;

function u1.UpdateProgressBar(p21: table, p22: number) -- Line: 187
    -- upvalues: RadialProgress (copy), Vector2_new_ret (copy)
    RadialProgress.Update(p21, p22, "Bomb", Vector2_new_ret);
end;

function u1.UpdateTimer(p23: table, p24: number) -- Line: 191
    -- upvalues: RadialProgress (copy)
    RadialProgress.SetTimer(p23.Frame, p24);
end;

function u1.UpdateTitle(p25) -- Line: 195
    -- upvalues: RadialProgress (copy)
    RadialProgress.SetTitle(p25.Frame, string.format("%s is defusing the bomb %s a kit.", p25.PlayerName, p25.HasDefuseKit and "with" or "without"));
end;

function u1.StartDefuse(u26: table, p27: userdata?) -- Line: 202
    -- upvalues: LocalPlayer (copy), SpectateController (copy), Participants (copy), CollectionService (copy), RunServiceController (copy), notifyTutorialDefuseCancelled (copy), u2 (copy), InputController (copy), Remotes (copy), u6 (ref)
    local Attribute = LocalPlayer:GetAttribute("IsSpectating");
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();
    local v28 = p27 or (Attribute and (CurrentSpectateInstance and CurrentSpectateInstance.Player) or LocalPlayer);

    if u26.IsDefusing and u26.PlayerName == Participants.Name(v28) then
        return;
    end;

    local v29 = CollectionService:GetTagged("Bomb")[1];
    local v30;

    if v29 then
        v30 = (v29:GetAttribute("Defused") == true or v29:GetAttribute("Exploding") == true) and true or v29:GetAttribute("Exploded") == true;
    else
        v30 = false;
    end;

    if v30 then
        return;
    end;

    if v28 == LocalPlayer then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", true);
    end;

    u26.HasDefuseKit = v28:GetAttribute("HasDefuseKit") == true;
    u26.PlayerName = Participants.Name(v28);
    u26.DefuseTime = u26.HasDefuseKit and 5 or 10;
    local DefuseTime = u26.DefuseTime;
    local Attribute2 = v28:GetAttribute("DefuseStartTime");

    if typeof(Attribute2) == "number" then
        local ServerTimeNow = workspace:GetServerTimeNow();
        local v31 = ServerTimeNow - Attribute2;

        if Attribute2 > ServerTimeNow or (v31 < 0 or v31 > math.max(DefuseTime, 12)) then
            Attribute2 = nil;
        end;
    else
        Attribute2 = nil;
    end;

    u26.DefuseStartTime = Attribute2 or workspace:GetServerTimeNow();
    u26.DefuseProgress = 0;
    u26.IsDefusing = true;
    u26.IsFinished = false;
    u26.HasSentDefuseRequest = false;
    u26.HasReceivedServerStartAck = false;
    u26.DefuseSessionId = nil;

    if u26.Frame then
        u26.Frame.Visible = true;
    end;

    u26:UpdateProgressBar(0);
    u26:UpdateTimer(u26.DefuseTime);
    u26:UpdateTitle();
    u26.Janitor:Add(RunServiceController.BindToHeartbeat("UI.DefuseBomb.UpdateProgress", function() -- Line: 245
        -- upvalues: u26 (copy), CollectionService (ref), LocalPlayer (ref), SpectateController (ref), notifyTutorialDefuseCancelled (ref), u2 (ref), InputController (ref), Remotes (ref)
        if not u26.IsDefusing or u26.IsFinished then
            return;
        end;

        local v32 = CollectionService:GetTagged("Bomb")[1];
        local v33;

        if v32 then
            v33 = (v32:GetAttribute("Defused") == true or v32:GetAttribute("Exploding") == true) and true or v32:GetAttribute("Exploded") == true;
        else
            v33 = false;
        end;

        if v33 then
            local v34 = u26;

            if v32 and v32:GetAttribute("Defused") == true then
                v34:FinishDefuse(true);

                return;
            end;

            v34:CancelDefuse(true);

            return;
        end;

        local Attribute3 = LocalPlayer:GetAttribute("IsSpectating");
        local CurrentSpectateInstance2 = SpectateController.GetCurrentSpectateInstance();

        if Attribute3 then
            if CurrentSpectateInstance2 then
                Attribute3 = u26.PlayerName ~= LocalPlayer.Name;
            else
                Attribute3 = CurrentSpectateInstance2;
            end;
        end;

        local DefuseTime2 = u26.DefuseTime;
        local Attribute4 = (Attribute3 and CurrentSpectateInstance2 and CurrentSpectateInstance2.Player or LocalPlayer):GetAttribute("DefuseStartTime");

        if typeof(Attribute4) == "number" then
            local ServerTimeNow = workspace:GetServerTimeNow();
            local v35 = ServerTimeNow - Attribute4;

            if Attribute4 > ServerTimeNow or (v35 < 0 or v35 > math.max(DefuseTime2, 12)) then
                Attribute4 = nil;
            end;
        else
            Attribute4 = nil;
        end;

        if Attribute4 and math.abs(Attribute4 - u26.DefuseStartTime) > 0.001 then
            u26.DefuseStartTime = Attribute4;
        end;

        if Attribute3 and CurrentSpectateInstance2 then
            if not CurrentSpectateInstance2.Player:GetAttribute("IsDefusingBomb") then
                local v36 = u26;

                if v32 and v32:GetAttribute("Defused") == true then
                    v36:FinishDefuse(true);

                    return;
                end;

                v36:CancelDefuse(true);

                return;
            end;
        else
            local Character = LocalPlayer.Character;

            if Character and (Character.PrimaryPart and (v32 and (v32.PrimaryPart and (Character.PrimaryPart.Position - v32.PrimaryPart.Position).Magnitude > 10))) then
                notifyTutorialDefuseCancelled(u26, "Stay next to the bomb until the defuse finishes");
                u26:CancelDefuse(false);

                return;
            end;

            if not (u2 or InputController.isActionActive("Use")) then
                notifyTutorialDefuseCancelled(u26);
                u26:CancelDefuse(false);

                return;
            end;
        end;

        local v37;

        if Attribute3 then
            v37 = false;
        else
            v37 = LocalPlayer:GetAttribute("IsDefusingBomb") == true;

            if v37 then
                u26.HasReceivedServerStartAck = true;
            end;

            if not v37 and (u26.HasReceivedServerStartAck or u26.HasSentDefuseRequest) then
                notifyTutorialDefuseCancelled(u26, "Stand still next to the bomb until the defuse finishes");
                local v38 = u26;

                if v32 and v32:GetAttribute("Defused") == true then
                    v38:FinishDefuse(true);

                    return;
                end;

                v38:CancelDefuse(true);

                return;
            end;
        end;

        local v39 = workspace:GetServerTimeNow() - u26.DefuseStartTime;
        u26.DefuseProgress = math.min(v39 / u26.DefuseTime, 1);
        u26:UpdateProgressBar(u26.DefuseProgress);
        u26:UpdateTimer((math.max(u26.DefuseTime - v39, 0)));

        if Attribute3 or (u26.DefuseProgress < 1 or (u26.HasSentDefuseRequest or not v37)) then
            return;
        end;

        u26.HasSentDefuseRequest = true;
        Remotes.C4.Defused.Send();
    end), "Disconnect", "ProgressConnection");

    if not Attribute or v28 == LocalPlayer then
        u6 = u6 + 1;
        u26.DefuseSessionId = u6;
        Remotes.C4.StartDefuse.Send({
            SessionId = u26.DefuseSessionId
        });
    end;

    u26.DefuseStarted:Fire();
end;

function u1.CancelDefuse(u40: table, p41: boolean?) -- Line: 343
    -- upvalues: LocalPlayer (copy), SpectateController (copy), u8 (ref), Remotes (copy)
    if not u40.IsDefusing then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("IsSpectating");
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if Attribute then
        if CurrentSpectateInstance then
            CurrentSpectateInstance = u40.PlayerName ~= LocalPlayer.Name;
        end;
    else
        CurrentSpectateInstance = Attribute;
    end;

    u40.IsDefusing = false;
    u40.IsFinished = true;

    if not CurrentSpectateInstance then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", nil);
    end;

    if u8 == u40 then
        u8 = nil;
    end;

    u40:UpdateProgressBar(0);

    if u40.Frame then
        u40.Frame.Visible = false;
    end;

    if not (p41 or CurrentSpectateInstance) then
        Remotes.C4.CancelDefuse.Send({
            SessionId = u40.DefuseSessionId
        });
    end;

    u40.DefuseCancelled:Fire();
    task.defer(function() -- Line: 377
        -- upvalues: u40 (copy)
        u40:Destroy();
    end);
end;

function u1.FinishDefuse(u42: table, p43: boolean?) -- Line: 382
    -- upvalues: LocalPlayer (copy), SpectateController (copy), u8 (ref), Remotes (copy)
    if not u42.IsDefusing or u42.IsFinished then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("IsSpectating");
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if Attribute then
        if CurrentSpectateInstance then
            CurrentSpectateInstance = u42.PlayerName ~= LocalPlayer.Name;
        end;
    else
        CurrentSpectateInstance = Attribute;
    end;

    u42.IsFinished = true;
    u42.IsDefusing = false;

    if not CurrentSpectateInstance then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", nil);
    end;

    if u8 == u42 then
        u8 = nil;
    end;

    if not (p43 or CurrentSpectateInstance) then
        Remotes.C4.Defused.Send();
    end;

    u42.DefuseFinished:Fire();

    local function destroy() -- Line: 410
        -- upvalues: u42 (copy)
        u42:Destroy();
    end;

    if p43 then
        task.defer(destroy);

        return;
    end;

    task.delay(0.5, destroy);
end;

function u1.new(p44) -- Line: 423
    -- upvalues: u1 (copy), Janitor (copy), Signal (copy)
    local v45 = setmetatable({}, u1);
    v45.Janitor = Janitor.new();
    v45.Frame = p44;
    v45.DefuseTime = 10;
    v45.HasDefuseKit = false;
    v45.DefuseStartTime = 0;
    v45.DefuseProgress = 0;
    v45.IsDefusing = false;
    v45.IsFinished = false;
    v45.HasSentDefuseRequest = false;
    v45.HasReceivedServerStartAck = false;
    v45.PlayerName = "";
    v45.DefuseCancelled = v45.Janitor:Add(Signal.new());
    v45.DefuseFinished = v45.Janitor:Add(Signal.new());
    v45.DefuseStarted = v45.Janitor:Add(Signal.new());

    if v45.Frame then
        v45.Frame.Visible = false;
    end;

    v45:InitializeProgressBar();

    return v45;
end;

function u1.Destroy(p46) -- Line: 459
    -- upvalues: u8 (ref), LocalPlayer (copy)
    local v47;

    if u8 == nil then
        v47 = false;
    else
        v47 = u8 ~= p46;
    end;

    if p46.PlayerName == LocalPlayer.Name and not v47 then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", nil);
    end;

    if u8 == p46 then
        u8 = nil;
    end;

    if p46.Frame and not v47 then
        p46.Frame.Visible = false;
    end;

    p46.Janitor:Destroy();
end;

function u1.Initialize(p48, p49) -- Line: 483
    -- upvalues: u7 (ref), Router (copy), u3 (ref), IsTutorialMode (copy), LocalPlayer (copy), u4 (ref), CollectionService (copy), u8 (ref), u1 (copy), notifyTutorialDefuseCancelled (copy), SpectateController (copy)
    u7 = p49;
    Router.observerRouter("Start Defuse Bomb", function() -- Line: 487
        -- upvalues: u3 (ref), IsTutorialMode (ref), LocalPlayer (ref), u4 (ref), Router (ref), CollectionService (ref), u8 (ref), u1 (ref), u7 (ref)
        if u3 and workspace:GetServerTimeNow() < u3 then
            return nil;
        end;

        if IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") ~= "DefuseB" then
            if os.clock() - u4 > 2 then
                u4 = os.clock();
                Router.broadcastRouter("CreateNotification", "Not Yet", "Eliminate all the Terrorists before defusing the bomb", 2.5);
            end;

            return nil;
        end;

        local v50 = CollectionService:GetTagged("Bomb")[1];
        local v51;

        if v50 then
            v51 = (v50:GetAttribute("Defused") == true or v50:GetAttribute("Exploding") == true) and true or v50:GetAttribute("Exploded") == true;
        else
            v51 = false;
        end;

        if v51 then
            return nil;
        end;

        if not u8 then
            u8 = u1.new(u7);
        end;

        u8:StartDefuse();

        return nil;
    end);
    Router.observerRouter("Cancel Defuse Bomb", function() -- Line: 522
        -- upvalues: u8 (ref), notifyTutorialDefuseCancelled (ref)
        local v52 = u8;

        if v52 then
            notifyTutorialDefuseCancelled(v52);
            v52:CancelDefuse(false);
            u8 = nil;
        end;

        return nil;
    end);
    local u53 = nil;

    local function updateSpectateDefuse() -- Line: 536
        -- upvalues: LocalPlayer (ref), SpectateController (ref), CollectionService (ref), u8 (ref), u1 (ref), u7 (ref)
        local Attribute = LocalPlayer:GetAttribute("IsSpectating");
        local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

        if Attribute and CurrentSpectateInstance then
            local Player = CurrentSpectateInstance.Player;
            local Attribute2 = Player:GetAttribute("IsDefusingBomb");
            local v54 = CollectionService:GetTagged("Bomb")[1];
            local v55;

            if v54 then
                v55 = (v54:GetAttribute("Defused") == true or v54:GetAttribute("Exploding") == true) and true or v54:GetAttribute("Exploded") == true;
            else
                v55 = false;
            end;

            if v55 then
                if u8 then
                    local v56 = u8;

                    if v54 and v54:GetAttribute("Defused") == true then
                        v56:FinishDefuse(true);
                    else
                        v56:CancelDefuse(true);
                    end;

                    u8 = nil;
                end;

                return;
            end;

            if Attribute2 then
                if not u8 then
                    u8 = u1.new(u7);
                end;

                u8:StartDefuse(Player);

                return;
            end;

            if u8 then
                u8:CancelDefuse(false);
                u8 = nil;
            end;
        elseif u8 and not LocalPlayer:GetAttribute("IsDefusingBomb") then
            u8:CancelDefuse(false);
            u8 = nil;
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(updateSpectateDefuse);
    SpectateController.ListenToSpectate:Connect(function() -- Line: 580, Name: setupSpectateDefuseListener
        -- upvalues: u53 (ref), SpectateController (ref), updateSpectateDefuse (copy)
        if u53 then
            u53:Disconnect();
            u53 = nil;
        end;

        local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

        if CurrentSpectateInstance then
            u53 = CurrentSpectateInstance.Player:GetAttributeChangedSignal("IsDefusingBomb"):Connect(updateSpectateDefuse);
            updateSpectateDefuse();
        end;
    end);
    task.wait(0.1);

    if u53 then
        u53:Disconnect();
        u53 = nil;
    end;

    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if CurrentSpectateInstance then
        u53 = CurrentSpectateInstance.Player:GetAttributeChangedSignal("IsDefusingBomb"):Connect(updateSpectateDefuse);
        updateSpectateDefuse();
    end;
end;

function u1.SetDefuseBlockedUntil(p57: number) -- Line: 602
    -- upvalues: u3 (ref)
    u3 = p57;
end;

return u1;