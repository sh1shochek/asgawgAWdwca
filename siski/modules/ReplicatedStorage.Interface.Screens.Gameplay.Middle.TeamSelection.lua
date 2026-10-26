-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local IsRadarHidden = require(ReplicatedStorage.Components.Common.IsRadarHidden);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local LocalPlayer = Players.LocalPlayer;
local ColorSequence_new_ret = ColorSequence.new(Color3.fromRGB(32, 32, 32));
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(138, 138, 138);
local NumberSequence_new_ret = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.14375), NumberSequenceKeypoint.new(0.318, 1), NumberSequenceKeypoint.new(1, 1) });
local NumberSequence_new_ret2 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.14375), NumberSequenceKeypoint.new(0.183193, 1), NumberSequenceKeypoint.new(1, 1) });
local u2 = false;
local u3 = 0;
local u4 = nil;
local u5 = {};
local u6 = {};
local u7 = nil;
local u8 = nil;

local function retrieveTeamCount(p9: any, p10: userdata?, p11: boolean?) -- Line: 86
    -- upvalues: Participants (copy)
    local v12 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if not (p11 and Participants.IsBot(v) or (v == p10 or v:GetAttribute("Team") ~= p9)) then
            v12 = v12 + 1;
        end;
    end;

    return v12;
end;

local function skipsTeamBalancing() -- Line: 101
    -- upvalues: IsSurvivalMode (copy)
    local Attribute = workspace:GetAttribute("ServerGamemode");
    local Attribute2 = workspace:GetAttribute("Gamemode");

    return Attribute == "Deathmatch" and true or (Attribute2 == "Deathmatch" and true or (Attribute == "Survival" and true or IsSurvivalMode()));
end;

local function areTeamLimitsDisabled() -- Line: 110
    -- upvalues: IsSurvivalMode (copy)
    local v13;

    if workspace:GetAttribute("VIPDisableTeamLimitEnabled") == true then
        v13 = true;
    else
        local Attribute = workspace:GetAttribute("ServerGamemode");
        local Attribute2 = workspace:GetAttribute("Gamemode");
        v13 = Attribute == "Deathmatch" and true or (Attribute2 == "Deathmatch" and true or (Attribute == "Survival" and true or IsSurvivalMode()));
    end;

    return v13;
end;

local function teamHasBot(p14) -- Line: 115
    -- upvalues: Participants (copy), retrieveTeamCount (copy)
    local v15 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == p14 then
            v15 = v15 + 1;
        end;
    end;

    return retrieveTeamCount(p14, nil, true) < v15;
end;

local function chooseBalancedTeam(p16: userdata) -- Line: 119
    -- upvalues: retrieveTeamCount (copy)
    local v17 = retrieveTeamCount("Counter-Terrorists", p16, true);
    local v18 = retrieveTeamCount("Terrorists", p16, true);

    return v17 == v18 and (p16:GetAttribute("Team") == "Terrorists" and "Counter-Terrorists" or "Terrorists") or (v17 < v18 and "Counter-Terrorists" or "Terrorists");
end;

local function isTeamAvailable(p19: userdata, p20: any) -- Line: 132
    -- upvalues: IsTutorialMode (copy), IsSurvivalMode (copy), Participants (copy), retrieveTeamCount (copy)
    if IsTutorialMode() then
        return p20 == "Terrorists" and true or p20 == "Spectators";
    end;

    local v21;

    if workspace:GetAttribute("VIPDisableTeamLimitEnabled") == true then
        v21 = true;
    else
        local Attribute = workspace:GetAttribute("ServerGamemode");
        local Attribute2 = workspace:GetAttribute("Gamemode");
        v21 = (Attribute == "Deathmatch" or (Attribute2 == "Deathmatch" or Attribute == "Survival")) and true or IsSurvivalMode();
    end;

    if v21 then
        return (p20 == "Counter-Terrorists" or p20 == "Terrorists") and true or p20 == "Spectators";
    end;

    if p20 == "Counter-Terrorists" or p20 == "Terrorists" then
        local v22 = 0;

        for _, v in ipairs(Participants.GetAll()) do
            if v ~= nil and v:GetAttribute("Team") == p20 then
                v22 = v22 + 1;
            end;
        end;

        if retrieveTeamCount(p20, nil, true) < v22 then
            return true;
        end;
    end;

    local v23 = retrieveTeamCount("Counter-Terrorists", p19, true);
    local v24 = retrieveTeamCount("Terrorists", p19, true);

    return (p20 == "Terrorists" and v24 < v23 or p20 == "Counter-Terrorists" and v23 < v24) and true or (p20 == "Spectators" and true or v23 == v24);
end;

local function setPlayerTemplateUnhovered(p25: any, p26: string) -- Line: 151
    -- upvalues: Color3_fromRGB_ret2 (copy)
    if not (p25 and p25:IsA("Frame")) then
        return;
    end;

    p25.BackgroundColor3 = p26 == "Counter-Terrorists" and Color3.fromRGB(109, 121, 140) or Color3.fromRGB(131, 111, 66);
    p25.Player.UIStroke.Color = p26 == "Counter-Terrorists" and Color3.fromRGB(50, 56, 65) or Color3.fromRGB(94, 85, 54);
    p25.Player.Avatar.ImageColor3 = Color3_fromRGB_ret2;
end;

local function updateTeamAvailabilityStyles() -- Line: 162
    -- upvalues: IsSurvivalMode (copy), Participants (copy), retrieveTeamCount (copy), u7 (ref), u5 (copy), u6 (copy), ColorSequence_new_ret (copy), setPlayerTemplateUnhovered (copy)
    local v27;

    if workspace:GetAttribute("VIPDisableTeamLimitEnabled") == true then
        v27 = true;
    else
        local Attribute = workspace:GetAttribute("ServerGamemode");
        local Attribute2 = workspace:GetAttribute("Gamemode");
        v27 = Attribute == "Deathmatch" and true or (Attribute2 == "Deathmatch" and true or (Attribute == "Survival" and true or IsSurvivalMode()));
    end;

    local v28 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == "Counter-Terrorists" then
            v28 = v28 + 1;
        end;
    end;

    local v29 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == "Terrorists" then
            v29 = v29 + 1;
        end;
    end;

    local v30 = retrieveTeamCount("Counter-Terrorists", nil, true);
    local v31 = retrieveTeamCount("Terrorists", nil, true);

    for _, v in ipairs({ "Counter-Terrorists", "Terrorists" }) do
        local v32 = u7:FindFirstChild(v);

        if v32 then
            if not u5[v] then
                u5[v] = {
                    TeamTransparency = v32.Team.TextTransparency,
                    PlayersTransparency = v32.Players.TextTransparency,
                    UIGradient = v32.UIGradient.Color,
                    IconOutline = v32.Icon.Outline.ImageTransparency,
                    IconTeam = v32.Icon.Team.ImageTransparency,
                    IconTeamIcon = v32.Icon.Team.Icon.ImageTransparency
                };
            end;

            local v33 = not v27;
            local v34;

            if v33 then
                v34 = v;
                local v35 = 0;

                for _, v2 in ipairs(Participants.GetAll()) do
                    if v2 ~= nil and v2:GetAttribute("Team") == v34 then
                        v35 = v35 + 1;
                    end;
                end;

                v33 = retrieveTeamCount(v34, nil, true) >= v35;

                if v33 then
                    if v34 == "Counter-Terrorists" and v31 < v30 then
                        v33 = true;
                    elseif v34 == "Terrorists" then
                        if v30 < v31 then
                            v33 = true;
                        else
                            v33 = false;
                        end;
                    else
                        v33 = false;
                    end;
                end;
            else
                v34 = v;
            end;

            u6[v34] = v33;
            local v36 = v34 == "Counter-Terrorists" and v28 and v28 or v29;
            local v37 = u5[v34];
            v32.Players.Text = `{v36} Player{v36 == 1 and "" or "s"}`;
            v32.Team.TextTransparency = v33 and 0.5 or v37.TeamTransparency;
            v32.Players.TextTransparency = v33 and 0.5 or v37.PlayersTransparency;
            v32.UIGradient.Color = v33 and ColorSequence_new_ret or v37.UIGradient;
            v32.Icon.Outline.ImageTransparency = v33 and 0.4 or v37.IconOutline;
            v32.Icon.Team.ImageTransparency = v33 and 0.4 or v37.IconTeam;
            v32.Icon.Team.Icon.ImageTransparency = v33 and 0.4 or v37.IconTeamIcon;

            for _, child in ipairs(v32.Container:GetChildren()) do
                if v33 then
                    setPlayerTemplateUnhovered(child, v34);
                end;
            end;
        end;
    end;
end;

local function createButtonAnimation(u38: userdata) -- Line: 203
    -- upvalues: TweenService (copy)
    u38.MouseEnter:Connect(function() -- Line: 204
        -- upvalues: TweenService (ref), u38 (copy)
        TweenService:Create(u38, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.85
        }):Play();
    end);
    u38.MouseLeave:Connect(function() -- Line: 207
        -- upvalues: TweenService (ref), u38 (copy)
        TweenService:Create(u38, TweenInfo.new(0.1), {
            BackgroundTransparency = 1
        }):Play();
    end);
end;

local function isCharacterAlive() -- Line: 212
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy)
    return CharacterResolver.isAliveCharacter(LocalPlayer.Character);
end;

local function getMenuSceneController() -- Line: 217
    -- upvalues: ReplicatedStorage (copy)
    return require(ReplicatedStorage.Controllers.MenuSceneController);
end;

local function createTeamListeners(p39: userdata, u40: any) -- Line: 221
    -- upvalues: u1 (copy), createButtonAnimation (copy)
    p39.MouseButton1Click:Connect(function() -- Line: 222
        -- upvalues: u1 (ref), u40 (copy)
        u1.chooseTeam(u40);
    end);

    if u40 == "Spectators" then
        createButtonAnimation(p39);

        return;
    end;

    u1.createTeamButtonAnimation(p39, u40);
end;

local function destroyPlayerTemplate(p41) -- Line: 232
    -- upvalues: u7 (ref)
    local v42 = u7:FindFirstChild(tostring(p41), true);

    if v42 then
        v42:Destroy();
    end;
end;

function u1.isVisible() -- Line: 242
    -- upvalues: u7 (ref), u8 (ref)
    if not (u7 and (u7.Visible and u8)) then
        return false;
    end;

    local Gameplay = u8:FindFirstChild("Gameplay");

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Bottom");
    end;

    local v43;

    if Gameplay == nil then
        v43 = false;
    else
        v43 = Gameplay:IsA("GuiObject") and not Gameplay.Visible;
    end;

    return v43;
end;

function u1.shouldUseMapCamera() -- Line: 253
    -- upvalues: u1 (copy), CharacterResolver (copy), LocalPlayer (copy)
    local v44 = u1.isVisible() and not CharacterResolver.isAliveCharacter(LocalPlayer.Character);

    return v44;
end;

function u1.ToggleTeamSelection() -- Line: 258
    -- upvalues: EndScreenController (copy), u7 (ref), u1 (copy)
    if EndScreenController.IsActive() then
        return;
    end;

    if u7.Visible then
        u1.closeFrame();

        return;
    end;

    u1.openFrame();
end;

function u1.openFrame() -- Line: 270
    -- upvalues: IsTutorialMode (copy), u8 (ref), LocalPlayer (copy), u1 (copy), EndScreenController (copy), MenuState (copy), u7 (ref), ReplicatedStorage (copy), u4 (ref), CameraController (copy), u2 (ref), GetUserPlatform (copy), updateTeamAvailabilityStyles (copy)
    if IsTutorialMode() then
        if u8.Menu.Visible then
            return;
        end;

        local Attribute = LocalPlayer:GetAttribute("Team");

        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            u1.chooseTeam("Terrorists");
        end;

        return;
    end;

    if EndScreenController.IsActive() then
        return;
    end;

    if MenuState.IsCaseSceneActive() or MenuState.IsInspectActive() then
        return;
    end;

    if u7.Visible then
        return;
    end;

    if u8.Menu.Visible then
        local CurrentScreen = MenuState.GetCurrentScreen();

        if MenuState.IsPreservableScreen(CurrentScreen) then
            local v45 = u8.Menu:FindFirstChild(CurrentScreen);

            if v45 and v45.Visible then
                return;
            end;
        end;
    end;

    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);

    if MenuSceneController.IsActive() then
        MenuSceneController.HideMenuScene(true, false, true);
    end;

    u4 = CameraController.getTargetFOV();

    if u8.Menu.Visible then
        CameraController.setForceLockOverride("Menu", false);
        MenuState.SetBlurEnabled(false);
    end;

    local BuyMenu = u8.Gameplay.Middle:FindFirstChild("BuyMenu");
    u2 = BuyMenu and BuyMenu.Visible or false;

    if u2 then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu).closeFrame();
    end;

    CameraController.setForceLockOverride("TeamSelection", true);

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, true);
    end;

    u8.Gameplay.Bottom.Visible = false;
    u8.Gameplay.Top.Visible = true;
    u8.Gameplay.Visible = true;
    MenuState.HideMenu();
    local table_find_ret = table.find(GetUserPlatform(), "Mobile");

    for _, child in ipairs(u8.Gameplay.Middle:GetChildren()) do
        if child.Name == "Chat" then
            child.Visible = not table_find_ret;
        elseif child.Name == "MobileButtons" then
            local Character = LocalPlayer.Character;

            if Character and Character:IsDescendantOf(workspace) then
                child.Visible = table_find_ret;
            else
                child.Visible = false;
            end;
        else
            child.Visible = child.Name == "Notification" and true or child.Name == "TeamSelection";
        end;
    end;

    updateTeamAvailabilityStyles();
    MenuSceneController.ShowTeamSelectScene();
end;

function u1.closeFrame() -- Line: 361
    -- upvalues: ReplicatedStorage (copy), CameraController (copy), LocalPlayer (copy), u4 (ref), u7 (ref), u8 (ref), MenuState (copy), u2 (ref), GetUserPlatform (copy), IsRadarHidden (copy)
    require(ReplicatedStorage.Controllers.MenuSceneController).HideTeamSelectScene();
    CameraController.setForceLockOverride("TeamSelection", false);

    if LocalPlayer.Character then
        CameraController.setForceLockOverride("Menu", false);
    end;

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, false);
    end;

    local v46 = u4;
    u4 = nil;

    if v46 and not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.updateCameraFOV(v46);
    end;

    local Visible = u7.Visible;
    u7.Visible = false;

    if Visible or not u8.Menu.Visible then
        MenuState.SetScreen(nil);
    end;

    if u8.Menu.Visible then
        u8.Gameplay.Bottom.Visible = false;
        u8.Gameplay.Visible = false;
        u2 = false;
        local TutorialDialogue = u8.Gameplay.Middle:FindFirstChild("TutorialDialogue");

        if TutorialDialogue and TutorialDialogue:IsA("GuiObject") then
            TutorialDialogue.Visible = false;
        end;

        return;
    end;

    u8.Gameplay.Middle.Crosshair.Visible = true;
    u8.Gameplay.Top.Visible = true;
    u8.Gameplay.Bottom.Visible = true;
    local table_find_ret = table.find(GetUserPlatform(), "Mobile");
    local Character = LocalPlayer.Character;
    local v47 = LocalPlayer:GetAttribute("IsSpectating") == true;
    local Attribute = LocalPlayer:GetAttribute("Team");
    local v48 = Attribute == "Counter-Terrorists" and true or Attribute == "Terrorists";

    for _, child in ipairs(u8.Gameplay.Middle:GetChildren()) do
        local v49;

        if Character then
            v49 = Character:IsDescendantOf(workspace);
        else
            v49 = Character;
        end;

        local Name = child.Name;

        if Name == "Chat" then
            child.Visible = not table_find_ret;
        elseif Name == "MobileButtons" then
            local v50;

            if table_find_ret then
                v50 = v49 or (v47 or false);
            else
                v50 = false;
            end;

            child.Visible = v50;
        elseif Name == "Votekick" then
            child.Visible = child:GetAttribute("IsVoteKickActive") == true;
        elseif Name == "Notification" then
            child.Visible = true;
        elseif Name == "SessionStats" then
            child.Visible = not table_find_ret;
        elseif Name == "Crosshair" then
            child.Visible = v49;
        elseif Name == "Radar" then
            local v51;

            if v49 or (v48 or v47) then
                v51 = not IsRadarHidden();
            else
                v51 = v47;
            end;

            child.Visible = v51;
        elseif Name ~= "TutorialDialogue" then
            if Name ~= "TutorialObjective" then
                child.Visible = false;
            end;
        end;
    end;

    if u2 then
        local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu);
        u2 = false;
        BuyMenu.openFrame();
    end;
end;

function u1.chooseTeam(p52) -- Line: 450
    -- upvalues: MenuState (copy), LocalPlayer (copy), Remotes (copy), u1 (copy), isTeamAvailable (copy), u3 (ref)
    MenuState.SetWantsMainMenu(false);

    if LocalPlayer:GetAttribute("Team") ~= p52 then
        if isTeamAvailable(LocalPlayer, p52) and tick() - u3 >= 1 then
            if p52 == "Spectators" then
                LocalPlayer:SetAttribute("PendingSpectateRequestAt", os.clock());
            end;

            Remotes.TeamSelection.SelectTeam.Send(p52);
            u3 = tick();
        end;

        return;
    end;

    if p52 == "Spectators" and not LocalPlayer:GetAttribute("IsSpectating") then
        Remotes.Spectate.StartSpectating.Send();
    end;

    u1.closeFrame();
end;

function u1.createTeamButtonAnimation(p53: userdata, u54: any) -- Line: 472
    -- upvalues: u7 (ref), u6 (copy), ReplicatedStorage (copy), Color3_fromRGB_ret (copy), NumberSequence_new_ret (copy), NumberSequence_new_ret2 (copy), setPlayerTemplateUnhovered (copy)
    local u55 = u7:FindFirstChild(u54);

    if u55 then
        p53.MouseEnter:Connect(function() -- Line: 475
            -- upvalues: u6 (ref), u54 (copy), ReplicatedStorage (ref), u55 (copy), Color3_fromRGB_ret (ref), NumberSequence_new_ret (ref)
            if u6[u54] then
                return;
            end;

            require(ReplicatedStorage.Controllers.MenuSceneController).SetTeamSelectHighlight(u54, true);
            local Outline = u55.Icon.Outline;
            local v56 = u54 == "Counter-Terrorists" and Color3.fromRGB(165, 183, 212);

            if not v56 then
                if u54 == "Terrorists" then
                    v56 = Color3.fromRGB(219, 199, 126);
                else
                    v56 = false;
                end;
            end;

            Outline.ImageColor3 = v56;
            u55.Icon.Team.Icon.ImageColor3 = Color3_fromRGB_ret;
            local Team = u55.Icon.Team;
            local v57 = u54 == "Counter-Terrorists" and Color3.fromRGB(36, 41, 47);

            if not v57 then
                if u54 == "Terrorists" then
                    v57 = Color3.fromRGB(89, 79, 50);
                else
                    v57 = false;
                end;
            end;

            Team.ImageColor3 = v57;
            u55.UIGradient.Transparency = NumberSequence_new_ret;

            for _, child in ipairs(u55.Container:GetChildren()) do
                if child:IsA("Frame") then
                    local v58 = u54 == "Counter-Terrorists" and Color3.fromRGB(126, 140, 187);

                    if not v58 then
                        if u54 == "Terrorists" then
                            v58 = Color3.fromRGB(219, 188, 110);
                        else
                            v58 = false;
                        end;
                    end;

                    child.BackgroundColor3 = v58;
                    local UIStroke = child.Player.UIStroke;
                    local v59 = u54 == "Counter-Terrorists" and Color3.fromRGB(165, 183, 212);

                    if not v59 then
                        if u54 == "Terrorists" then
                            v59 = Color3.fromRGB(219, 199, 126);
                        else
                            v59 = false;
                        end;
                    end;

                    UIStroke.Color = v59;
                    child.Player.Avatar.ImageColor3 = Color3_fromRGB_ret;
                end;
            end;
        end);
        p53.MouseLeave:Connect(function() -- Line: 498
            -- upvalues: u6 (ref), u54 (copy), ReplicatedStorage (ref), u55 (copy), NumberSequence_new_ret2 (ref), setPlayerTemplateUnhovered (ref)
            if u6[u54] then
                return;
            end;

            require(ReplicatedStorage.Controllers.MenuSceneController).SetTeamSelectHighlight(u54, false);
            local Outline = u55.Icon.Outline;
            local v60 = u54 == "Counter-Terrorists" and Color3.fromRGB(107, 119, 138);

            if not v60 then
                if u54 == "Terrorists" then
                    v60 = Color3.fromRGB(127, 115, 73);
                else
                    v60 = false;
                end;
            end;

            Outline.ImageColor3 = v60;
            local Icon = u55.Icon.Team.Icon;
            local v61 = u54 == "Counter-Terrorists" and Color3.fromRGB(131, 131, 131);

            if not v61 then
                if u54 == "Terrorists" then
                    v61 = Color3.fromRGB(182, 182, 182);
                else
                    v61 = false;
                end;
            end;

            Icon.ImageColor3 = v61;
            local Team = u55.Icon.Team;
            local v62 = u54 == "Counter-Terrorists" and Color3.fromRGB(20, 24, 27);

            if not v62 then
                if u54 == "Terrorists" then
                    v62 = Color3.fromRGB(58, 51, 33);
                else
                    v62 = false;
                end;
            end;

            Team.ImageColor3 = v62;
            u55.UIGradient.Transparency = NumberSequence_new_ret2;

            for _, child in ipairs(u55.Container:GetChildren()) do
                setPlayerTemplateUnhovered(child, u54);
            end;
        end);
    end;
end;

function u1.updatePlayerList(u63: userdata, p64: boolean?) -- Line: 517
    -- upvalues: Profiler (copy), Participants (copy), u7 (ref), ReplicatedStorage (copy), Players (copy), updateTeamAvailabilityStyles (copy)
    Profiler.mark("UI.TeamSelection.UpdatePlayerList");
    local Attribute = u63:GetAttribute("Team");
    local v65 = Participants.Key(u63);
    local v66 = u7:FindFirstChild(tostring(v65), true);

    if v66 then
        v66:Destroy();
    end;

    if Attribute == "Counter-Terrorists" or Attribute == "Terrorists" then
        local u67 = ReplicatedStorage.Assets.UI.TeamSelection:FindFirstChild(Attribute);

        if u67 and not p64 then
            local u68 = u7:WaitForChild(Attribute);
            local _, result = pcall(function() -- Line: 527
                -- upvalues: Players (ref), Participants (ref), u63 (copy)
                return Players:GetUserThumbnailAsync(Participants.AvatarUserId(u63), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
            end);
            Profiler.scope("UI.TeamSelection.UpdatePlayerList.CloneRow", function() -- Line: 534
                -- upvalues: u67 (copy), u68 (copy), Participants (ref), u63 (copy), result (copy)
                local v69 = u67:Clone();
                v69.Parent = u68.Container;
                v69.Team.Text = Participants.DisplayName(u63);
                v69.Player.Avatar.Image = result;
                v69.Name = tostring(Participants.Key(u63));
                v69.Visible = true;
            end);
        end;
    end;

    local Players2 = u7["Counter-Terrorists"].Players;
    local v70 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == "Counter-Terrorists" then
            v70 = v70 + 1;
        end;
    end;

    Players2.Text = `{v70} Player(s)`;
    local Players3 = u7.Terrorists.Players;
    local v71 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == "Terrorists" then
            v71 = v71 + 1;
        end;
    end;

    Players3.Text = `{v71} Player(s)`;
    updateTeamAvailabilityStyles();
end;

function u1.Initialize(p72, p73) -- Line: 553
    -- upvalues: u7 (ref), u8 (ref), Observers (copy), u1 (copy), LocalPlayer (copy), Participants (copy), GameState (copy), GetTimerFormat (copy), IsRadarHidden (copy), updateTeamAvailabilityStyles (copy)
    u7 = p73;
    u8 = p72;
    Observers.observePlayer(function(u74: userdata) -- Line: 556
        -- upvalues: u1 (ref), Observers (ref), LocalPlayer (ref), u7 (ref)
        u1.updatePlayerList(u74);
        local u76 = Observers.observeAttribute(u74, "Team", function() -- Line: 558
            -- upvalues: u1 (ref), u74 (copy), LocalPlayer (ref), u7 (ref)
            u1.updatePlayerList(u74);

            if LocalPlayer == u74 and u7.Visible then
                u1.closeFrame();
            end;

            return function() -- Line: 565
                -- upvalues: u74 (ref), u7 (ref)
                local v75 = u7:FindFirstChild(tostring(u74.UserId), true);

                if v75 then
                    v75:Destroy();
                end;
            end;
        end);

        return function() -- Line: 571
            -- upvalues: u1 (ref), u74 (copy), u76 (copy)
            u1.updatePlayerList(u74, true);
            u76();
        end;
    end);
    local u77 = {};
    Participants.Observe(function(u78: userdata) -- Line: 579
        -- upvalues: Participants (ref), u77 (copy), Observers (ref), u1 (ref), u7 (ref)
        if not Participants.IsBot(u78) then
            return;
        end;

        u77[u78] = Observers.observeAttribute(u78, "Team", function() -- Line: 583
            -- upvalues: u1 (ref), u78 (copy), Participants (ref), u7 (ref)
            u1.updatePlayerList(u78);

            return function() -- Line: 585
                -- upvalues: Participants (ref), u78 (ref), u7 (ref)
                local v79 = Participants.Key(u78);
                local v80 = u7:FindFirstChild(tostring(v79), true);

                if v80 then
                    v80:Destroy();
                end;
            end;
        end);
    end, function(p81: userdata) -- Line: 589
        -- upvalues: Participants (ref), u1 (ref), u77 (copy)
        if not Participants.IsBot(p81) then
            return;
        end;

        u1.updatePlayerList(p81, true);
        local v82 = u77[p81];
        u77[p81] = nil;

        if v82 then
            v82();
        end;
    end);
    Observers.observeAttribute(LocalPlayer, "Team", function() -- Line: 602
        -- upvalues: u7 (ref), GameState (ref), u1 (ref)
        if u7.Visible and GameState.GetState() == "Round In Progress" then
            u1.closeFrame();
        end;
    end);
    Observers.observeAttribute(workspace, "Timer", function(p83) -- Line: 609
        -- upvalues: u7 (ref), GetTimerFormat (ref)
        u7.ProgressBar.Timer.Text = GetTimerFormat(p83);
    end);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 614
        -- upvalues: u7 (ref), u1 (ref), u8 (ref), IsRadarHidden (ref)
        if u7.Visible then
            u1.closeFrame();

            return;
        end;

        local Radar = u8.Gameplay.Middle:FindFirstChild("Radar");

        if Radar and (Radar:IsA("GuiObject") and (u8.Gameplay.Visible and not (u8.Menu.Visible or IsRadarHidden()))) then
            Radar.Visible = true;
        end;
    end);

    for _, v in ipairs({ "VIPDisableTeamLimitEnabled", "ServerGamemode", "Gamemode" }) do
        Observers.observeAttribute(workspace, v, updateTeamAvailabilityStyles);
    end;
end;

function u1.Start() -- Line: 638
    -- upvalues: u7 (ref), u1 (copy), createButtonAnimation (copy), LocalPlayer (copy), retrieveTeamCount (copy), ReplicatedStorage (copy), CharacterResolver (copy), u2 (ref), Remotes (copy), SpectateController (copy), MenuState (copy), CameraController (copy), u8 (ref)
    local Button = u7["Counter-Terrorists"].Button;
    local u84 = "Counter-Terrorists";
    Button.MouseButton1Click:Connect(function() -- Line: 222
        -- upvalues: u1 (ref), u84 (copy)
        u1.chooseTeam(u84);
    end);
    u1.createTeamButtonAnimation(Button, "Counter-Terrorists");
    local Spectate = u7.Bottom.Buttons.Spectate;
    local u85 = "Spectators";
    Spectate.MouseButton1Click:Connect(function() -- Line: 222
        -- upvalues: u1 (ref), u85 (copy)
        u1.chooseTeam(u85);
    end);
    createButtonAnimation(Spectate);
    local Button2 = u7.Terrorists.Button;
    local u86 = "Terrorists";
    Button2.MouseButton1Click:Connect(function() -- Line: 222
        -- upvalues: u1 (ref), u86 (copy)
        u1.chooseTeam(u86);
    end);
    u1.createTeamButtonAnimation(Button2, "Terrorists");
    createButtonAnimation(u7.Bottom.Buttons.AutoSelect);
    u7.Bottom.Buttons.AutoSelect.MouseButton1Click:Connect(function() -- Line: 644
        -- upvalues: u1 (ref), LocalPlayer (ref), retrieveTeamCount (ref)
        local chooseTeam = u1.chooseTeam;
        local v87 = LocalPlayer;
        local v88 = retrieveTeamCount("Counter-Terrorists", v87, true);
        local v89 = retrieveTeamCount("Terrorists", v87, true);
        local v90;

        if v88 == v89 then
            v90 = v87:GetAttribute("Team") == "Terrorists" and "Counter-Terrorists" or "Terrorists";
        else
            v90 = v88 < v89 and "Counter-Terrorists" or "Terrorists";
        end;

        chooseTeam(v90);
    end);
    createButtonAnimation(u7.Bottom.Buttons.BackHome);
    u7.Bottom.Buttons.BackHome.MouseButton1Click:Connect(function() -- Line: 649
        -- upvalues: LocalPlayer (ref), ReplicatedStorage (ref), CharacterResolver (ref), u2 (ref), u1 (ref), Remotes (ref), SpectateController (ref), MenuState (ref), CameraController (ref), u8 (ref)
        local v91 = LocalPlayer:GetAttribute("IsSpectating") == true;
        local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);

        if not v91 and CharacterResolver.isAliveCharacter(LocalPlayer.Character) then
            u2 = false;
            u1.closeFrame();
            Top.ShowMainMenuOverGameplay();

            return;
        end;

        local Attribute = LocalPlayer:GetAttribute("Team");

        if Attribute and Attribute ~= "Spectators" then
            Remotes.TeamSelection.SelectTeam.Send("Spectators");
        end;

        SpectateController.Stop(true, true);
        MenuState.SetWantsMainMenu(true);
        u1.closeFrame();
        local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
        CameraController.setForceLockOverride("Menu", true);
        CameraController.setPerspective(true, true);
        u8.Gameplay.Visible = false;
        u8.Gameplay.Bottom.Visible = false;
        u8.Menu.Visible = true;
        Top.ResetToMainMenu();
        MenuSceneController.ShowMenuScene();
    end);
end;

return u1;