-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips);
local u2 = table.find(GetUserPlatform(), "Mobile") and #GetUserPlatform() <= 1;
local u3 = nil;
local u4 = false;
local u5 = nil;
local u6 = nil;

local function IsCharacterAlive(p7: userdata) -- Line: 49
    -- upvalues: CharacterResolver (copy)
    return CharacterResolver.isAliveCharacter(p7.Character);
end;

local function GetPromptParts() -- Line: 53
    -- upvalues: u5 (ref)
    if not u5 then
        return nil, nil;
    end;

    local TextLabel = u5:FindFirstChild("TextLabel");
    local Keybind = u5:FindFirstChild("Keybind");

    if TextLabel and TextLabel:IsA("TextLabel") then
        if not (Keybind and (Keybind:IsA("ImageButton") and Keybind)) then
            Keybind = nil;
        end;

        return TextLabel, Keybind;
    end;

    warn((`[HoverBomb]: {u5:GetFullName()} has no TextLabel child; the defuse prompt cannot render`));

    return nil, nil;
end;

local function RefreshPrompt() -- Line: 68
    -- upvalues: GetPromptParts (copy), u2 (copy), Tips (copy)
    local v8, v9 = GetPromptParts();

    if not v8 then
        return;
    end;

    if u2 then
        v8.Text = "Hold to Defuse";

        if v9 then
            v9.Visible = false;
        end;

        return;
    end;

    v8.Text = "Defuse Bomb";

    if v9 then
        v9.Visible = Tips.ApplyBindingToKeybind(v9, Tips.ResolveActionBinding("Use"));
    end;
end;

local function LayoutKeybind() -- Line: 88
    -- upvalues: GetPromptParts (copy), u5 (ref)
    local v10, v11 = GetPromptParts();

    if not (v10 and v11) then
        return;
    end;

    local X = u5.AbsoluteSize.X;

    if X <= 0 then
        return;
    end;

    v11.Position = UDim2.fromScale(v10.Position.X.Scale - v10.TextBounds.X / X / 2 - 0.006, v10.Position.Y.Scale);
end;

local function IsBombResolved(p12: userdata?) -- Line: 103
    if p12 then
        return (p12:GetAttribute("Defused") == true or p12:GetAttribute("Exploding") == true) and true or p12:GetAttribute("Exploded") == true;
    end;

    return false;
end;

local function GetActiveBomb() -- Line: 113
    -- upvalues: CollectionService (copy)
    local v13 = CollectionService:GetTagged("Bomb")[1];

    if v13 then
        local v14;

        if v13 then
            v14 = (v13:GetAttribute("Defused") == true or v13:GetAttribute("Exploding") == true) and true or v13:GetAttribute("Exploded") == true;
        else
            v14 = false;
        end;

        if not v14 then
            return v13;
        end;
    end;

    return nil;
end;

local function ShouldRunUpdate() -- Line: 122
    -- upvalues: LocalPlayer (copy), CollectionService (copy)
    local v15;

    if workspace:GetAttribute("Gamemode") == "Bomb Defusal" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
        local v16 = CollectionService:GetTagged("Bomb")[1];

        if v16 then
            local v17;

            if v16 then
                v17 = (v16:GetAttribute("Defused") == true or v16:GetAttribute("Exploding") == true) and true or v16:GetAttribute("Exploded") == true;
            else
                v17 = false;
            end;

            if v17 then
                v16 = nil;
            end;
        else
            v16 = nil;
        end;

        v15 = v16 ~= nil;
    else
        v15 = false;
    end;

    return v15;
end;

local function StopUpdateConnection() -- Line: 128
    -- upvalues: u6 (ref)
    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;
end;

local function CancelMobileDefuseIfNeeded() -- Line: 135
    -- upvalues: u2 (copy), u4 (ref), CollectionService (copy), u3 (ref), Router (copy)
    if not (u2 and u4) then
        return;
    end;

    local v18 = CollectionService:GetTagged("Bomb")[1];
    local v19;

    if v18 then
        v19 = (v18:GetAttribute("Defused") == true or v18:GetAttribute("Exploding") == true) and true or v18:GetAttribute("Exploded") == true;
    else
        v19 = false;
    end;

    u4 = false;
    u3 = nil;

    if not v19 then
        Router.broadcastRouter("Cancel Defuse Bomb");
    end;
end;

local function SyncUpdateConnection() -- Line: 149
    -- upvalues: LocalPlayer (copy), CollectionService (copy), u6 (ref), RunServiceController (copy), u5 (ref), u2 (copy), u4 (ref), u3 (ref), Router (copy), CharacterResolver (copy), u1 (copy), LayoutKeybind (copy)
    local v20;

    if workspace:GetAttribute("Gamemode") == "Bomb Defusal" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
        local v21 = CollectionService:GetTagged("Bomb")[1];

        if v21 then
            local v22;

            if v21 then
                v22 = (v21:GetAttribute("Defused") == true or v21:GetAttribute("Exploding") == true) and true or v21:GetAttribute("Exploded") == true;
            else
                v22 = false;
            end;

            if v22 then
                v21 = nil;
            end;
        else
            v21 = nil;
        end;

        v20 = v21 ~= nil;
    else
        v20 = false;
    end;

    if v20 then
        if u6 then
            return;
        end;

        u6 = RunServiceController.BindToHeartbeat("UI.HoverBomb.Update", function(p23) -- Line: 155
            -- upvalues: LocalPlayer (ref), CollectionService (ref), u5 (ref), u2 (ref), u4 (ref), u3 (ref), Router (ref), u6 (ref), CharacterResolver (ref), u1 (ref), LayoutKeybind (ref)
            local v24;

            if workspace:GetAttribute("Gamemode") == "Bomb Defusal" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
                local v25 = CollectionService:GetTagged("Bomb")[1];

                if v25 then
                    local v26;

                    if v25 then
                        v26 = (v25:GetAttribute("Defused") == true or v25:GetAttribute("Exploding") == true) and true or v25:GetAttribute("Exploded") == true;
                    else
                        v26 = false;
                    end;

                    if v26 then
                        v25 = nil;
                    end;
                else
                    v25 = nil;
                end;

                v24 = v25 ~= nil;
            else
                v24 = false;
            end;

            if v24 then
                if CharacterResolver.isAliveCharacter(LocalPlayer.Character) then
                    local HoverState = u1.GetHoverState();
                    u5.Visible = HoverState;

                    if HoverState then
                        LayoutKeybind();
                    end;

                    if u2 and (u4 and (not HoverState and u2)) then
                        if not u4 then
                            return;
                        end;

                        local v27 = CollectionService:GetTagged("Bomb")[1];
                        local v28;

                        if v27 then
                            v28 = (v27:GetAttribute("Defused") == true or v27:GetAttribute("Exploding") == true) and true or v27:GetAttribute("Exploded") == true;
                        else
                            v28 = false;
                        end;

                        u4 = false;
                        u3 = nil;

                        if not v28 then
                            Router.broadcastRouter("Cancel Defuse Bomb");

                            return;
                        end;
                    end;
                else
                    u5.Visible = false;

                    if u2 and u4 then
                        u4 = false;
                        u3 = nil;
                    end;
                end;

                return;
            end;

            u5.Visible = false;

            if u2 and u4 then
                local v29 = CollectionService:GetTagged("Bomb")[1];
                local v30;

                if v29 then
                    v30 = (v29:GetAttribute("Defused") == true or v29:GetAttribute("Exploding") == true) and true or v29:GetAttribute("Exploded") == true;
                else
                    v30 = false;
                end;

                u4 = false;
                u3 = nil;

                if not v30 then
                    Router.broadcastRouter("Cancel Defuse Bomb");
                end;
            end;

            if u6 then
                u6:Disconnect();
                u6 = nil;
            end;
        end);

        return;
    end;

    u5.Visible = false;

    if u2 and u4 then
        local v31 = CollectionService:GetTagged("Bomb")[1];
        local v32;

        if v31 then
            v32 = (v31:GetAttribute("Defused") == true or v31:GetAttribute("Exploding") == true) and true or v31:GetAttribute("Exploded") == true;
        else
            v32 = false;
        end;

        u4 = false;
        u3 = nil;

        if not v32 then
            Router.broadcastRouter("Cancel Defuse Bomb");
        end;
    end;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;
end;

function u1.IsDefuseAllowed() -- Line: 194
    -- upvalues: IsTutorialMode (copy), LocalPlayer (copy)
    return not IsTutorialMode() or LocalPlayer:GetAttribute("TutorialStep") == "DefuseB";
end;

function u1.IsInDefuseRange() -- Line: 199
    -- upvalues: LocalPlayer (copy), CollectionService (copy)
    if LocalPlayer:GetAttribute("Team") ~= "Counter-Terrorists" then
        return false;
    end;

    local v33 = CollectionService:GetTagged("Bomb")[1];

    if v33 then
        local v34;

        if v33 then
            v34 = (v33:GetAttribute("Defused") == true or v33:GetAttribute("Exploding") == true) and true or v33:GetAttribute("Exploded") == true;
        else
            v34 = false;
        end;

        if v34 then
            v33 = nil;
        end;
    else
        v33 = nil;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character.PrimaryPart;
    end;

    local v35 = v33 and v33:IsA("Model") and v33.PrimaryPart;

    if Character and v35 then
        return (Character.Position - v35.Position).Magnitude <= 5;
    end;

    return false;
end;

function u1.GetHoverState() -- Line: 213
    -- upvalues: LocalPlayer (copy), u1 (copy), CollectionService (copy), u2 (copy), u4 (ref)
    if LocalPlayer:GetAttribute("Team") ~= "Counter-Terrorists" or not u1.IsDefuseAllowed() then
        return false;
    end;

    local v36 = CollectionService:GetTagged("Bomb")[1];

    if v36 then
        local v37;

        if v36 then
            v37 = (v36:GetAttribute("Defused") == true or v36:GetAttribute("Exploding") == true) and true or v36:GetAttribute("Exploded") == true;
        else
            v37 = false;
        end;

        if v37 then
            v36 = nil;
        end;
    else
        v36 = nil;
    end;

    if v36 then
        return u2 and (u4 or LocalPlayer:GetAttribute("IsDefusingBomb") == true) and true or (v36:GetAttribute("CanDefuse") and not v36:GetAttribute("IsGettingDefused") and true or false);
    end;

    return false;
end;

function u1.Initialize(p38, p39) -- Line: 235
    -- upvalues: u5 (ref), GetPromptParts (copy), u2 (copy), Tips (copy), DataController (copy), LocalPlayer (copy), RefreshPrompt (copy), UserInputService (copy), SyncUpdateConnection (copy), CollectionService (copy), u6 (ref), RunServiceController (copy), u4 (ref), u3 (ref), Router (copy), CharacterResolver (copy), u1 (copy), LayoutKeybind (copy)
    u5 = p39;
    local v40, v41 = GetPromptParts();

    if v40 then
        if u2 then
            v40.Text = "Hold to Defuse";

            if v41 then
                v41.Visible = false;
            end;
        else
            v40.Text = "Defuse Bomb";

            if v41 then
                v41.Visible = Tips.ApplyBindingToKeybind(v41, Tips.ResolveActionBinding("Use"));
            end;
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(p42) -- Line: 241
        -- upvalues: RefreshPrompt (ref)
        if not p42 then
            return;
        end;

        task.defer(RefreshPrompt);
    end);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(RefreshPrompt);
    LocalPlayer:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 251
        -- upvalues: LocalPlayer (ref), u5 (ref)
        if LocalPlayer:GetAttribute("Dead") then
            u5.Visible = false;
        end;
    end);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 258
        -- upvalues: u5 (ref)
        u5.Visible = false;
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(SyncUpdateConnection);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(SyncUpdateConnection);
    LocalPlayer.CharacterAdded:Connect(SyncUpdateConnection);
    LocalPlayer.CharacterRemoving:Connect(SyncUpdateConnection);
    CollectionService:GetInstanceAddedSignal("Bomb"):Connect(SyncUpdateConnection);
    CollectionService:GetInstanceRemovedSignal("Bomb"):Connect(SyncUpdateConnection);
    local v43;

    if workspace:GetAttribute("Gamemode") == "Bomb Defusal" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
        local v44 = CollectionService:GetTagged("Bomb")[1];

        if v44 then
            local v45;

            if v44 then
                v45 = (v44:GetAttribute("Defused") == true or v44:GetAttribute("Exploding") == true) and true or v44:GetAttribute("Exploded") == true;
            else
                v45 = false;
            end;

            if v45 then
                v44 = nil;
            end;
        else
            v44 = nil;
        end;

        v43 = v44 ~= nil;
    else
        v43 = false;
    end;

    if v43 then
        if not u6 then
            u6 = RunServiceController.BindToHeartbeat("UI.HoverBomb.Update", function(p46) -- Line: 155
                -- upvalues: LocalPlayer (ref), CollectionService (ref), u5 (ref), u2 (ref), u4 (ref), u3 (ref), Router (ref), u6 (ref), CharacterResolver (ref), u1 (ref), LayoutKeybind (ref)
                local v47;

                if workspace:GetAttribute("Gamemode") == "Bomb Defusal" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
                    local v48 = CollectionService:GetTagged("Bomb")[1];

                    if v48 then
                        local v49;

                        if v48 then
                            v49 = (v48:GetAttribute("Defused") == true or v48:GetAttribute("Exploding") == true) and true or v48:GetAttribute("Exploded") == true;
                        else
                            v49 = false;
                        end;

                        if v49 then
                            v48 = nil;
                        end;
                    else
                        v48 = nil;
                    end;

                    v47 = v48 ~= nil;
                else
                    v47 = false;
                end;

                if v47 then
                    if CharacterResolver.isAliveCharacter(LocalPlayer.Character) then
                        local HoverState = u1.GetHoverState();
                        u5.Visible = HoverState;

                        if HoverState then
                            LayoutKeybind();
                        end;

                        if u2 and (u4 and (not HoverState and u2)) then
                            if not u4 then
                                return;
                            end;

                            local v50 = CollectionService:GetTagged("Bomb")[1];
                            local v51;

                            if v50 then
                                v51 = (v50:GetAttribute("Defused") == true or v50:GetAttribute("Exploding") == true) and true or v50:GetAttribute("Exploded") == true;
                            else
                                v51 = false;
                            end;

                            u4 = false;
                            u3 = nil;

                            if not v51 then
                                Router.broadcastRouter("Cancel Defuse Bomb");

                                return;
                            end;
                        end;
                    else
                        u5.Visible = false;

                        if u2 and u4 then
                            u4 = false;
                            u3 = nil;
                        end;
                    end;

                    return;
                end;

                u5.Visible = false;

                if u2 and u4 then
                    local v52 = CollectionService:GetTagged("Bomb")[1];
                    local v53;

                    if v52 then
                        v53 = (v52:GetAttribute("Defused") == true or v52:GetAttribute("Exploding") == true) and true or v52:GetAttribute("Exploded") == true;
                    else
                        v53 = false;
                    end;

                    u4 = false;
                    u3 = nil;

                    if not v53 then
                        Router.broadcastRouter("Cancel Defuse Bomb");
                    end;
                end;

                if u6 then
                    u6:Disconnect();
                    u6 = nil;
                end;
            end);
        end;
    else
        u5.Visible = false;

        if u2 and u4 then
            local v54 = CollectionService:GetTagged("Bomb")[1];
            local v55;

            if v54 then
                v55 = (v54:GetAttribute("Defused") == true or v54:GetAttribute("Exploding") == true) and true or v54:GetAttribute("Exploded") == true;
            else
                v55 = false;
            end;

            u4 = false;
            u3 = nil;

            if not v55 then
                Router.broadcastRouter("Cancel Defuse Bomb");
            end;
        end;

        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;
    end;

    if u2 then
        UserInputService.TouchStarted:Connect(function(p56: userdata, p57: boolean) -- Line: 273
            -- upvalues: u1 (ref), LocalPlayer (ref), CharacterResolver (ref), u4 (ref), u3 (ref), Router (ref)
            if p57 then
                return;
            end;

            if u1.GetHoverState() and (CharacterResolver.isAliveCharacter(LocalPlayer.Character) and not u4) then
                u3 = p56;
                u4 = true;
                Router.broadcastRouter("Start Defuse Bomb");
            end;
        end);
        UserInputService.TouchEnded:Connect(function(p58: userdata, p59: boolean) -- Line: 288
            -- upvalues: u3 (ref), u4 (ref), Router (ref)
            if p58 == u3 then
                u3 = nil;

                if u4 then
                    u4 = false;
                    Router.broadcastRouter("Cancel Defuse Bomb");
                end;
            end;
        end);
    end;
end;

return u1;