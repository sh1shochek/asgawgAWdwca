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

local function retrieveTeamCount(p9: any, p10: userdata?, p11: boolean?) -- Line: 84
    -- upvalues: Participants (copy)
    local v12 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if not (p11 and Participants.IsBot(v) or (v == p10 or v:GetAttribute("Team") ~= p9)) then
            v12 = v12 + 1;
        end;
    end;

    return v12;
end;

local function isDeathmatchMode() -- Line: 98
    return workspace:GetAttribute("ServerGamemode") == "Deathmatch" and true or workspace:GetAttribute("Gamemode") == "Deathmatch";
end;

local function areTeamLimitsDisabled() -- Line: 103
    return (workspace:GetAttribute("VIPDisableTeamLimitEnabled") == true or workspace:GetAttribute("ServerGamemode") == "Deathmatch") and true or workspace:GetAttribute("Gamemode") == "Deathmatch";
end;

local function chooseBalancedTeam(p13: userdata) -- Line: 107
    -- upvalues: retrieveTeamCount (copy)
    local v14 = retrieveTeamCount("Counter-Terrorists", p13, true);
    local v15 = retrieveTeamCount("Terrorists", p13, true);

    return v14 == v15 and (p13:GetAttribute("Team") == "Terrorists" and "Counter-Terrorists" or "Terrorists") or (v14 < v15 and "Counter-Terrorists" or "Terrorists");
end;

local function isTeamAvailable(p16: userdata, p17: any) -- Line: 120
    -- upvalues: IsTutorialMode (copy), retrieveTeamCount (copy)
    if IsTutorialMode() then
        return p17 == "Terrorists" and true or p17 == "Spectators";
    end;

    if (workspace:GetAttribute("VIPDisableTeamLimitEnabled") == true or workspace:GetAttribute("ServerGamemode") == "Deathmatch") and true or workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return (p17 == "Counter-Terrorists" or p17 == "Terrorists") and true or p17 == "Spectators";
    end;

    local v18 = retrieveTeamCount("Counter-Terrorists", p16, true);
    local v19 = retrieveTeamCount("Terrorists", p16, true);

    return (p17 == "Terrorists" and v19 < v18 or p17 == "Counter-Terrorists" and v18 < v19) and true or (p17 == "Spectators" and true or v18 == v19);
end;

local function setPlayerTemplateUnhovered(p20: any, p21: string) -- Line: 136
    -- upvalues: Color3_fromRGB_ret2 (copy)
    if not (p20 and p20:IsA("Frame")) then
        return;
    end;

    p20.BackgroundColor3 = p21 == "Counter-Terrorists" and Color3.fromRGB(109, 121, 140) or Color3.fromRGB(131, 111, 66);
    p20.Player.UIStroke.Color = p21 == "Counter-Terrorists" and Color3.fromRGB(50, 56, 65) or Color3.fromRGB(94, 85, 54);
    p20.Player.Avatar.ImageColor3 = Color3_fromRGB_ret2;
end;

local function updateTeamAvailabilityStyles() -- Line: 147
    -- upvalues: Participants (copy), retrieveTeamCount (copy), u7 (ref), u5 (copy), u6 (copy), ColorSequence_new_ret (copy), setPlayerTemplateUnhovered (copy)
    local v22 = (workspace:GetAttribute("VIPDisableTeamLimitEnabled") == true or workspace:GetAttribute("ServerGamemode") == "Deathmatch") and true or workspace:GetAttribute("Gamemode") == "Deathmatch";
    local v23 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == "Counter-Terrorists" then
            v23 = v23 + 1;
        end;
    end;

    local v24 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == "Terrorists" then
            v24 = v24 + 1;
        end;
    end;

    local v25 = retrieveTeamCount("Counter-Terrorists", nil, true);
    local v26 = retrieveTeamCount("Terrorists", nil, true);

    for _, v in ipairs({ "Counter-Terrorists", "Terrorists" }) do
        local v27 = u7:FindFirstChild(v);

        if v27 then
            if not u5[v] then
                u5[v] = {
                    TeamTransparency = v27.Team.TextTransparency,
                    PlayersTransparency = v27.Players.TextTransparency,
                    UIGradient = v27.UIGradient.Color,
                    IconOutline = v27.Icon.Outline.ImageTransparency,
                    IconTeam = v27.Icon.Team.ImageTransparency,
                    IconTeamIcon = v27.Icon.Team.Icon.ImageTransparency
                };
            end;

            local v28 = not v22;

            if v28 then
                if v == "Counter-Terrorists" and v26 < v25 then
                    v28 = true;
                elseif v == "Terrorists" then
                    v28 = v25 < v26;
                else
                    v28 = false;
                end;
            end;

            u6[v] = v28;
            local v29 = v == "Counter-Terrorists" and v23 and v23 or v24;
            local v30 = u5[v];
            v27.Players.Text = `{v29} Player{v29 == 1 and "" or "s"}`;
            v27.Team.TextTransparency = v28 and 0.5 or v30.TeamTransparency;
            v27.Players.TextTransparency = v28 and 0.5 or v30.PlayersTransparency;
            v27.UIGradient.Color = v28 and ColorSequence_new_ret or v30.UIGradient;
            v27.Icon.Outline.ImageTransparency = v28 and 0.4 or v30.IconOutline;
            v27.Icon.Team.ImageTransparency = v28 and 0.4 or v30.IconTeam;
            v27.Icon.Team.Icon.ImageTransparency = v28 and 0.4 or v30.IconTeamIcon;
            local v31 = v;

            for _, child in ipairs(v27.Container:GetChildren()) do
                if v28 then
                    setPlayerTemplateUnhovered(child, v31);
                end;
            end;
        end;
    end;
end;

local function createButtonAnimation(u32: userdata) -- Line: 187
    -- upvalues: TweenService (copy)
    u32.MouseEnter:Connect(function() -- Line: 188
        -- upvalues: TweenService (ref), u32 (copy)
        TweenService:Create(u32, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.85
        }):Play();
    end);
    u32.MouseLeave:Connect(function() -- Line: 191
        -- upvalues: TweenService (ref), u32 (copy)
        TweenService:Create(u32, TweenInfo.new(0.1), {
            BackgroundTransparency = 1
        }):Play();
    end);
end;

local function isCharacterAlive() -- Line: 196
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy)
    return CharacterResolver.isAliveCharacter(LocalPlayer.Character);
end;

local function getMenuSceneController() -- Line: 201
    -- upvalues: ReplicatedStorage (copy)
    return require(ReplicatedStorage.Controllers.MenuSceneController);
end;

local function createTeamListeners(p33: userdata, u34: any) -- Line: 205
    -- upvalues: u1 (copy), createButtonAnimation (copy)
    p33.MouseButton1Click:Connect(function() -- Line: 206
        -- upvalues: u1 (ref), u34 (copy)
        u1.chooseTeam(u34);
    end);

    if u34 == "Spectators" then
        createButtonAnimation(p33);

        return;
    end;

    u1.createTeamButtonAnimation(p33, u34);
end;

local function destroyPlayerTemplate(p35) -- Line: 216
    -- upvalues: u7 (ref)
    local v36 = u7:FindFirstChild(tostring(p35), true);

    if v36 then
        v36:Destroy();
    end;
end;

function u1.isVisible() -- Line: 226
    -- upvalues: u7 (ref), u8 (ref)
    if not (u7 and (u7.Visible and u8)) then
        return false;
    end;

    local Gameplay = u8:FindFirstChild("Gameplay");

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Bottom");
    end;

    local v37;

    if Gameplay == nil then
        v37 = false;
    else
        v37 = Gameplay:IsA("GuiObject") and not Gameplay.Visible;
    end;

    return v37;
end;

function u1.shouldUseMapCamera() -- Line: 237
    -- upvalues: u1 (copy), CharacterResolver (copy), LocalPlayer (copy)
    local v38 = u1.isVisible() and not CharacterResolver.isAliveCharacter(LocalPlayer.Character);

    return v38;
end;

function u1.ToggleTeamSelection() -- Line: 242
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

function u1.openFrame() -- Line: 254
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
            local v39 = u8.Menu:FindFirstChild(CurrentScreen);

            if v39 and v39.Visible then
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

function u1.closeFrame() -- Line: 345
    -- upvalues: ReplicatedStorage (copy), CameraController (copy), LocalPlayer (copy), u4 (ref), u7 (ref), u8 (ref), MenuState (copy), u2 (ref), GetUserPlatform (copy), IsTutorialMode (copy)
    require(ReplicatedStorage.Controllers.MenuSceneController).HideTeamSelectScene();
    CameraController.setForceLockOverride("TeamSelection", false);

    if LocalPlayer.Character then
        CameraController.setForceLockOverride("Menu", false);
    end;

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, false);
    end;

    local v40 = u4;
    u4 = nil;

    if v40 and not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.updateCameraFOV(v40);
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
    local v41 = LocalPlayer:GetAttribute("IsSpectating") == true;

    for _, child in ipairs(u8.Gameplay.Middle:GetChildren()) do
        local v42;

        if Character then
            v42 = Character:IsDescendantOf(workspace);
        else
            v42 = Character;
        end;

        local Name = child.Name;

        if Name == "Chat" then
            child.Visible = not table_find_ret;
        elseif Name == "MobileButtons" then
            local v43;

            if table_find_ret then
                v43 = v42 or (v41 or false);
            else
                v43 = false;
            end;

            child.Visible = v43;
        elseif Name == "Votekick" then
            child.Visible = child:GetAttribute("IsVoteKickActive") == true;
        elseif Name == "Notification" then
            child.Visible = true;
        elseif Name == "SessionStats" then
            child.Visible = not table_find_ret;
        elseif Name == "Crosshair" then
            child.Visible = v42;
        elseif Name == "Radar" then
            if v42 then
                v42 = not IsTutorialMode();
            end;

            child.Visible = v42;
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

function u1.chooseTeam(p44) -- Line: 430
    -- upvalues: MenuState (copy), LocalPlayer (copy), Remotes (copy), u1 (copy), isTeamAvailable (copy), u3 (ref)
    MenuState.SetWantsMainMenu(false);

    if LocalPlayer:GetAttribute("Team") ~= p44 then
        if isTeamAvailable(LocalPlayer, p44) and tick() - u3 >= 1 then
            if p44 == "Spectators" then
                LocalPlayer:SetAttribute("PendingSpectateRequestAt", os.clock());
            end;

            Remotes.TeamSelection.SelectTeam.Send(p44);
            u3 = tick();
        end;

        return;
    end;

    if p44 == "Spectators" and not LocalPlayer:GetAttribute("IsSpectating") then
        Remotes.Spectate.StartSpectating.Send();
    end;

    u1.closeFrame();
end;

function u1.createTeamButtonAnimation(p45: userdata, u46: any) -- Line: 452
    -- upvalues: u7 (ref), u6 (copy), ReplicatedStorage (copy), Color3_fromRGB_ret (copy), NumberSequence_new_ret (copy), NumberSequence_new_ret2 (copy), setPlayerTemplateUnhovered (copy)
    local u47 = u7:FindFirstChild(u46);

    if u47 then
        p45.MouseEnter:Connect(function() -- Line: 455
            -- upvalues: u6 (ref), u46 (copy), ReplicatedStorage (ref), u47 (copy), Color3_fromRGB_ret (ref), NumberSequence_new_ret (ref)
            if u6[u46] then
                return;
            end;

            require(ReplicatedStorage.Controllers.MenuSceneController).SetTeamSelectHighlight(u46, true);
            local Outline = u47.Icon.Outline;
            local v48 = u46 == "Counter-Terrorists" and Color3.fromRGB(165, 183, 212);

            if not v48 then
                if u46 == "Terrorists" then
                    v48 = Color3.fromRGB(219, 199, 126);
                else
                    v48 = false;
                end;
            end;

            Outline.ImageColor3 = v48;
            u47.Icon.Team.Icon.ImageColor3 = Color3_fromRGB_ret;
            local Team = u47.Icon.Team;
            local v49 = u46 == "Counter-Terrorists" and Color3.fromRGB(36, 41, 47);

            if not v49 then
                if u46 == "Terrorists" then
                    v49 = Color3.fromRGB(89, 79, 50);
                else
                    v49 = false;
                end;
            end;

            Team.ImageColor3 = v49;
            u47.UIGradient.Transparency = NumberSequence_new_ret;

            for _, child in ipairs(u47.Container:GetChildren()) do
                if child:IsA("Frame") then
                    local v50 = u46 == "Counter-Terrorists" and Color3.fromRGB(126, 140, 187);

                    if not v50 then
                        if u46 == "Terrorists" then
                            v50 = Color3.fromRGB(219, 188, 110);
                        else
                            v50 = false;
                        end;
                    end;

                    child.BackgroundColor3 = v50;
                    local UIStroke = child.Player.UIStroke;
                    local v51 = u46 == "Counter-Terrorists" and Color3.fromRGB(165, 183, 212);

                    if not v51 then
                        if u46 == "Terrorists" then
                            v51 = Color3.fromRGB(219, 199, 126);
                        else
                            v51 = false;
                        end;
                    end;

                    UIStroke.Color = v51;
                    child.Player.Avatar.ImageColor3 = Color3_fromRGB_ret;
                end;
            end;
        end);
        p45.MouseLeave:Connect(function() -- Line: 478
            -- upvalues: u6 (ref), u46 (copy), ReplicatedStorage (ref), u47 (copy), NumberSequence_new_ret2 (ref), setPlayerTemplateUnhovered (ref)
            if u6[u46] then
                return;
            end;

            require(ReplicatedStorage.Controllers.MenuSceneController).SetTeamSelectHighlight(u46, false);
            local Outline = u47.Icon.Outline;
            local v52 = u46 == "Counter-Terrorists" and Color3.fromRGB(107, 119, 138);

            if not v52 then
                if u46 == "Terrorists" then
                    v52 = Color3.fromRGB(127, 115, 73);
                else
                    v52 = false;
                end;
            end;

            Outline.ImageColor3 = v52;
            local Icon = u47.Icon.Team.Icon;
            local v53 = u46 == "Counter-Terrorists" and Color3.fromRGB(131, 131, 131);

            if not v53 then
                if u46 == "Terrorists" then
                    v53 = Color3.fromRGB(182, 182, 182);
                else
                    v53 = false;
                end;
            end;

            Icon.ImageColor3 = v53;
            local Team = u47.Icon.Team;
            local v54 = u46 == "Counter-Terrorists" and Color3.fromRGB(20, 24, 27);

            if not v54 then
                if u46 == "Terrorists" then
                    v54 = Color3.fromRGB(58, 51, 33);
                else
                    v54 = false;
                end;
            end;

            Team.ImageColor3 = v54;
            u47.UIGradient.Transparency = NumberSequence_new_ret2;

            for _, child in ipairs(u47.Container:GetChildren()) do
                setPlayerTemplateUnhovered(child, u46);
            end;
        end);
    end;
end;

function u1.updatePlayerList(u55: userdata, p56: boolean?) -- Line: 497
    -- upvalues: Profiler (copy), Participants (copy), u7 (ref), ReplicatedStorage (copy), Players (copy), updateTeamAvailabilityStyles (copy)
    Profiler.mark("UI.TeamSelection.UpdatePlayerList");
    local Attribute = u55:GetAttribute("Team");
    local v57 = Participants.Key(u55);
    local v58 = u7:FindFirstChild(tostring(v57), true);

    if v58 then
        v58:Destroy();
    end;

    if Attribute == "Counter-Terrorists" or Attribute == "Terrorists" then
        local u59 = ReplicatedStorage.Assets.UI.TeamSelection:FindFirstChild(Attribute);

        if u59 and not p56 then
            local u60 = u7:WaitForChild(Attribute);
            local _, result = pcall(function() -- Line: 507
                -- upvalues: Players (ref), Participants (ref), u55 (copy)
                return Players:GetUserThumbnailAsync(Participants.AvatarUserId(u55), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
            end);
            Profiler.scope("UI.TeamSelection.UpdatePlayerList.CloneRow", function() -- Line: 514
                -- upvalues: u59 (copy), u60 (copy), Participants (ref), u55 (copy), result (copy)
                local v61 = u59:Clone();
                v61.Parent = u60.Container;
                v61.Team.Text = Participants.DisplayName(u55);
                v61.Player.Avatar.Image = result;
                v61.Name = tostring(Participants.Key(u55));
                v61.Visible = true;
            end);
        end;
    end;

    local Players2 = u7["Counter-Terrorists"].Players;
    local v62 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == "Counter-Terrorists" then
            v62 = v62 + 1;
        end;
    end;

    Players2.Text = `{v62} Player(s)`;
    local Players3 = u7.Terrorists.Players;
    local v63 = 0;

    for _, v in ipairs(Participants.GetAll()) do
        if v ~= nil and v:GetAttribute("Team") == "Terrorists" then
            v63 = v63 + 1;
        end;
    end;

    Players3.Text = `{v63} Player(s)`;
    updateTeamAvailabilityStyles();
end;

function u1.Initialize(p64, p65) -- Line: 533
    -- upvalues: u7 (ref), u8 (ref), Observers (copy), u1 (copy), LocalPlayer (copy), Participants (copy), GameState (copy), GetTimerFormat (copy), updateTeamAvailabilityStyles (copy)
    u7 = p65;
    u8 = p64;
    Observers.observePlayer(function(u66: userdata) -- Line: 536
        -- upvalues: u1 (ref), Observers (ref), LocalPlayer (ref), u7 (ref)
        u1.updatePlayerList(u66);
        local u68 = Observers.observeAttribute(u66, "Team", function() -- Line: 538
            -- upvalues: u1 (ref), u66 (copy), LocalPlayer (ref), u7 (ref)
            u1.updatePlayerList(u66);

            if LocalPlayer == u66 and u7.Visible then
                u1.closeFrame();
            end;

            return function() -- Line: 545
                -- upvalues: u66 (ref), u7 (ref)
                local v67 = u7:FindFirstChild(tostring(u66.UserId), true);

                if v67 then
                    v67:Destroy();
                end;
            end;
        end);

        return function() -- Line: 551
            -- upvalues: u1 (ref), u66 (copy), u68 (copy)
            u1.updatePlayerList(u66, true);
            u68();
        end;
    end);
    local u69 = {};
    Participants.Observe(function(u70: userdata) -- Line: 559
        -- upvalues: Participants (ref), u69 (copy), Observers (ref), u1 (ref), u7 (ref)
        if not Participants.IsBot(u70) then
            return;
        end;

        u69[u70] = Observers.observeAttribute(u70, "Team", function() -- Line: 563
            -- upvalues: u1 (ref), u70 (copy), Participants (ref), u7 (ref)
            u1.updatePlayerList(u70);

            return function() -- Line: 565
                -- upvalues: Participants (ref), u70 (ref), u7 (ref)
                local v71 = Participants.Key(u70);
                local v72 = u7:FindFirstChild(tostring(v71), true);

                if v72 then
                    v72:Destroy();
                end;
            end;
        end);
    end, function(p73: userdata) -- Line: 569
        -- upvalues: Participants (ref), u1 (ref), u69 (copy)
        if not Participants.IsBot(p73) then
            return;
        end;

        u1.updatePlayerList(p73, true);
        local v74 = u69[p73];
        u69[p73] = nil;

        if v74 then
            v74();
        end;
    end);
    Observers.observeAttribute(LocalPlayer, "Team", function() -- Line: 582
        -- upvalues: u7 (ref), GameState (ref), u1 (ref)
        if u7.Visible and GameState.GetState() == "Round In Progress" then
            u1.closeFrame();
        end;
    end);
    Observers.observeAttribute(workspace, "Timer", function(p75) -- Line: 589
        -- upvalues: u7 (ref), GetTimerFormat (ref)
        u7.ProgressBar.Timer.Text = GetTimerFormat(p75);
    end);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 594
        -- upvalues: u7 (ref), u1 (ref)
        if u7.Visible then
            u1.closeFrame();
        end;
    end);

    for _, v in ipairs({ "VIPDisableTeamLimitEnabled", "ServerGamemode", "Gamemode" }) do
        Observers.observeAttribute(workspace, v, updateTeamAvailabilityStyles);
    end;
end;

function u1.Start() -- Line: 606
    -- upvalues: u7 (ref), u1 (copy), createButtonAnimation (copy), LocalPlayer (copy), retrieveTeamCount (copy), CharacterResolver (copy), Remotes (copy), SpectateController (copy), MenuState (copy), ReplicatedStorage (copy), CameraController (copy), u8 (ref)
    local Button = u7["Counter-Terrorists"].Button;
    local u76 = "Counter-Terrorists";
    Button.MouseButton1Click:Connect(function() -- Line: 206
        -- upvalues: u1 (ref), u76 (copy)
        u1.chooseTeam(u76);
    end);
    u1.createTeamButtonAnimation(Button, "Counter-Terrorists");
    local Spectate = u7.Bottom.Buttons.Spectate;
    local u77 = "Spectators";
    Spectate.MouseButton1Click:Connect(function() -- Line: 206
        -- upvalues: u1 (ref), u77 (copy)
        u1.chooseTeam(u77);
    end);
    createButtonAnimation(Spectate);
    local Button2 = u7.Terrorists.Button;
    local u78 = "Terrorists";
    Button2.MouseButton1Click:Connect(function() -- Line: 206
        -- upvalues: u1 (ref), u78 (copy)
        u1.chooseTeam(u78);
    end);
    u1.createTeamButtonAnimation(Button2, "Terrorists");
    createButtonAnimation(u7.Bottom.Buttons.AutoSelect);
    u7.Bottom.Buttons.AutoSelect.MouseButton1Click:Connect(function() -- Line: 612
        -- upvalues: u1 (ref), LocalPlayer (ref), retrieveTeamCount (ref)
        local chooseTeam = u1.chooseTeam;
        local v79 = LocalPlayer;
        local v80 = retrieveTeamCount("Counter-Terrorists", v79, true);
        local v81 = retrieveTeamCount("Terrorists", v79, true);
        local v82;

        if v80 == v81 then
            v82 = v79:GetAttribute("Team") == "Terrorists" and "Counter-Terrorists" or "Terrorists";
        else
            v82 = v80 < v81 and "Counter-Terrorists" or "Terrorists";
        end;

        chooseTeam(v82);
    end);
    createButtonAnimation(u7.Bottom.Buttons.BackHome);
    u7.Bottom.Buttons.BackHome.MouseButton1Click:Connect(function() -- Line: 617
        -- upvalues: LocalPlayer (ref), CharacterResolver (ref), u1 (ref), Remotes (ref), SpectateController (ref), MenuState (ref), ReplicatedStorage (ref), CameraController (ref), u8 (ref)
        if LocalPlayer:GetAttribute("IsSpectating") ~= true and CharacterResolver.isAliveCharacter(LocalPlayer.Character) then
            u1.closeFrame();

            return;
        end;

        local Attribute = LocalPlayer:GetAttribute("Team");

        if Attribute and Attribute ~= "Spectators" then
            Remotes.TeamSelection.SelectTeam.Send("Spectators");
        end;

        SpectateController.Stop(true, true);
        MenuState.SetWantsMainMenu(true);
        u1.closeFrame();
        local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
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