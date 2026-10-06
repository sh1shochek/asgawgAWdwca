-- Decompiled with Potassium's decompiler.

local v1 = {};
local ContentProvider = game:GetService("ContentProvider");
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber);
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration);
local ConfigController = require(ReplicatedStorage.Controllers.ConfigController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ConfigKeys = require(ReplicatedStorage.Database.Custom.ConfigKeys);
require(ReplicatedStorage.Database.Custom.Types);
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts);
local MissionStars = require(ReplicatedStorage.Database.Custom.GameStats.MissionStars);
local MissionIcons = require(ReplicatedStorage.Database.Custom.GameStats.MissionIcons);
local Missions = require(ReplicatedStorage.Database.Custom.GameStats.Missions);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = "hourly";
local u8 = nil;
local u9 = {};
local u10 = { "hourly", "daily", "weekly", "monthly" };
local ColorSequence_new_ret = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 89)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 116)) });
local ColorSequence_new_ret2 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 236, 160)), ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 216, 141)) });
local ColorSequence_new_ret3 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 125, 125)), ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 65, 65)) });

local function isMissionStarRewardClaimed(p11: table?, p12: number) -- Line: 58
    local v13;

    if p11 == nil then
        v13 = false;
    else
        v13 = p11[tostring(p12)] == true;
    end;

    return v13;
end;

local function hasDailyStarToClaim(p14) -- Line: 62
    -- upvalues: MissionStars (copy)
    if not p14 then
        return false;
    end;

    for i = 1, math.clamp(p14.CurrentStreak, 0, #MissionStars) do
        local Rewards = p14.Rewards;
        local v15;

        if Rewards == nil then
            v15 = false;
        else
            v15 = Rewards[tostring(i)] == true;
        end;

        if not v15 then
            return true;
        end;

        local _ = i;
    end;

    return false;
end;

local function hasClaimableMissions(p16: table?) -- Line: 77
    if not p16 then
        return false;
    end;

    for _, v in ipairs(p16) do
        if v.Progress >= v.Target and not v.IsClaimed then
            return true;
        end;
    end;

    return false;
end;

local function getAlertFingerprint(p17: table?, p18: any) -- Line: 91
    -- upvalues: MissionStars (copy)
    local v19 = {};

    if p17 then
        for _, v in ipairs(p17) do
            local v20 = `{v.MissionId}:{v.Progress}:{tostring(v.IsClaimed)}`;
            table.insert(v19, v20);
        end;
    end;

    if p18 then
        for i = 1, math.clamp(p18.CurrentStreak, 0, #MissionStars) do
            local Rewards = p18.Rewards;
            local v21;

            if Rewards == nil then
                v21 = false;
            else
                v21 = Rewards[tostring(i)] == true;
            end;

            local v22;

            if v21 then
                v22 = i;
            else
                local v23 = `star:{i}`;
                table.insert(v19, v23);
                v22 = i;
            end;
        end;
    end;

    return table.concat(v19, "|");
end;

local function updateProgressionAlert(p24: any, p25: table?) -- Line: 115
    -- upvalues: u2 (ref), DataController (copy), LocalPlayer (copy), getAlertFingerprint (copy), hasClaimableMissions (copy), hasDailyStarToClaim (copy), u3 (ref), u8 (ref)
    if not u2 then
        return;
    end;

    local Alert = u2.Menu.Top.Bottom.Buttons.Progression:FindFirstChild("Alert");

    if not (Alert and Alert:IsA("GuiObject")) then
        return;
    end;

    local v26 = p25 or DataController.Get(LocalPlayer, "Missions");
    local v27 = p24 or DataController.Get(LocalPlayer, "MissionStars");
    local v28 = getAlertFingerprint(v26, v27);
    local v29 = hasClaimableMissions(v26) or hasDailyStarToClaim(v27);

    if u3 and u3.Visible then
        u8 = v28;
        Alert.Visible = false;
    else
        if v29 then
            v29 = v28 ~= u8;
        end;

        Alert.Visible = v29;
    end;

    local TextLabel = Alert:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = "!";
    end;
end;

local function getMissionFromId(p30: string) -- Line: 148
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v31 = DataController.Get(LocalPlayer, "Missions");

    if not v31 then
        return nil;
    end;

    for _, v in ipairs(v31) do
        if v.MissionId == p30 then
            return v;
        end;
    end;

    return nil;
end;

local function getMissionCreditRewardAmount(p32) -- Line: 162
    -- upvalues: ConfigKeys (copy), ConfigController (copy)
    local v33 = p32.Rewards[1];

    if not (v33 and (v33.type == "Credits" and typeof(v33.amount) == "number")) then
        return 0;
    end;

    local v34 = ConfigKeys.Shared.MissionCreditRewardMultipliers[p32.Type];
    local v35 = not v34 and 1 or ConfigController.GetRewardMultiplier(v34);

    return math.round(v33.amount * v35);
end;

local function canonicalizeFilter(p36: userdata) -- Line: 173
    -- upvalues: u10 (copy)
    local table_find_ret = table.find(u10, p36.Name);

    if table_find_ret then
        return u10[table_find_ret];
    end;

    return nil;
end;

local function getEarliestExpirationTime(p37) -- Line: 178
    -- upvalues: DataController (copy), LocalPlayer (copy), Missions (copy)
    local v38 = DataController.Get(LocalPlayer, "Missions");

    if not v38 then
        return nil;
    end;

    local v39 = os.time() * 1000;
    local v40 = nil;

    for _, v in ipairs(v38) do
        local MissionDefinition = Missions.GetMissionDefinition(v.MissionId);

        if MissionDefinition and (MissionDefinition.Type == p37 and (v39 < v.ExpiresAt and (not v40 or v.ExpiresAt < v40))) then
            v40 = v.ExpiresAt;
        end;
    end;

    return v40;
end;

local function updateMissionHeader() -- Line: 200
    -- upvalues: getEarliestExpirationTime (copy), u7 (ref), u4 (ref), FormatDuration (copy)
    local v41 = getEarliestExpirationTime(u7);
    local v42;

    if v41 then
        local v43 = (v41 - os.time() * 1000) / 1000;
        local math_floor_ret = math.floor(v43);
        v42 = math.max(0, math_floor_ret);
    else
        v42 = 0;
    end;

    u4.MissionHeader.Title.Text = `{string.upper(u7)} MISSIONS`;
    u4.MissionHeader.Timer.Text = FormatDuration(v42, "IfNeeded");
end;

local function setReward(p44: userdata, p45: any) -- Line: 208
    -- upvalues: ConfigKeys (copy), ConfigController (copy), CommaNumber (copy)
    local v46 = p45.Rewards[1];
    local v47;

    if v46 and (v46.type == "Credits" and typeof(v46.amount) == "number") then
        local v48 = ConfigKeys.Shared.MissionCreditRewardMultipliers[p45.Type];
        local v49 = not v48 and 1 or ConfigController.GetRewardMultiplier(v48);
        v47 = math.round(v46.amount * v49);
    else
        v47 = 0;
    end;

    p44.ItemTemplate.Amount.Text = `x{CommaNumber(v47)}`;
    p44.RewardTemplate.Amount.Text = `x{CommaNumber(v47)}`;
    p44.RewardTemplate.Icon.Image = "rbxassetid://129921992230064";
end;

local function getMissionFingerprint(p50: any, p51: any, p52: number) -- Line: 215
    -- upvalues: ConfigKeys (copy), ConfigController (copy)
    local table_concat = table.concat;
    local v53 = {};
    local MissionId = p51.MissionId;
    local v54 = p50.DisplayName or p50.MissionId;
    local v55 = tostring(p51.Progress);
    local v56 = tostring(p51.Target);
    local v57 = tostring(p51.IsClaimed);
    local v58 = p50.Rewards[1];
    local v59;

    if v58 and (v58.type == "Credits" and typeof(v58.amount) == "number") then
        local v60 = ConfigKeys.Shared.MissionCreditRewardMultipliers[p50.Type];
        local v61 = not v60 and 1 or ConfigController.GetRewardMultiplier(v60);
        v59 = math.round(v58.amount * v61);
    else
        v59 = 0;
    end;

    v53[1], v53[2], v53[3], v53[4], v53[5], v53[6], v53[7] = MissionId, v54, v55, v56, v57, tostring(v59), tostring(p52);

    return table_concat(v53, "|");
end;

local function updateMissionTemplate(p62: userdata, p63: any, p64: any, p65: number) -- Line: 231
    -- upvalues: CommaNumber (copy), MissionIcons (copy), ConfigKeys (copy), ConfigController (copy)
    p62.LayoutOrder = p65;
    local math_max_ret = math.max(p64.Target, 1);
    local v66 = p64.Progress >= p64.Target;
    p62.Title.Text = p63.DisplayName or p63.MissionId;
    p62.Progress.Text = `{CommaNumber(p64.Progress)}/{CommaNumber(p64.Target)}`;
    p62.Bar.Progress.Size = UDim2.fromScale(math.clamp(p64.Progress / math_max_ret, 0, 1), 1);

    if v66 then
        v66 = not p64.IsClaimed;
    end;

    p62.GlowEffect.Visible = v66;
    p62.RewardTemplate.Finish.Visible = p64.IsClaimed;
    p62.ItemTemplate.Icon.Image = MissionIcons[p63.Category] or MissionIcons.Default;
    local v67 = p63.Rewards[1];
    local v68;

    if v67 and (v67.type == "Credits" and typeof(v67.amount) == "number") then
        local v69 = ConfigKeys.Shared.MissionCreditRewardMultipliers[p63.Type];
        local v70 = not v69 and 1 or ConfigController.GetRewardMultiplier(v69);
        v68 = math.round(v67.amount * v70);
    else
        v68 = 0;
    end;

    p62.ItemTemplate.Amount.Text = `x{CommaNumber(v68)}`;
    p62.RewardTemplate.Amount.Text = `x{CommaNumber(v68)}`;
    p62.RewardTemplate.Icon.Image = "rbxassetid://129921992230064";
end;

local function createMissionTemplate(p71: any, p72: any, p73: number) -- Line: 252
    -- upvalues: u6 (ref), updateMissionTemplate (copy), u5 (ref), DataController (copy), LocalPlayer (copy), Router (copy), Remotes (copy)
    local v74 = u6:Clone();
    v74.Name = p72.MissionId;
    v74.Visible = true;
    v74.Active = true;
    v74:SetAttribute("GeneratedMission", true);
    updateMissionTemplate(v74, p71, p72, p73);
    v74.Parent = u5;
    local MissionId = p72.MissionId;
    v74.InputEnded:Connect(function(p75: userdata) -- Line: 266
        -- upvalues: MissionId (copy), DataController (ref), LocalPlayer (ref), Router (ref), Remotes (ref)
        if p75.UserInputType ~= Enum.UserInputType.MouseButton1 and p75.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local v76 = MissionId;
        local v77 = DataController.Get(LocalPlayer, "Missions");
        local v78;

        if v77 then
            v78 = nil;

            for _, v in ipairs(v77) do
                if v.MissionId == v76 then
                    v78 = v;
                    break;
                end;
            end;
        else
            v78 = nil;
        end;

        if v78 and (v78.Progress >= v78.Target and not v78.IsClaimed) then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            Remotes.Dashboard.MissionCompleted.Send(MissionId);
        end;
    end);

    return v74;
end;

local function reconcileMissions(u79: table?) -- Line: 284
    -- upvalues: Profiler (copy), u5 (ref), Missions (copy), u7 (ref), getMissionFingerprint (copy), createMissionTemplate (copy), u9 (copy), updateMissionTemplate (copy), updateMissionHeader (copy)
    Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
        -- upvalues: u5 (ref), u79 (copy), Missions (ref), u7 (ref), getMissionFingerprint (ref), Profiler (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref)
        local v80 = {};

        for _, child in ipairs(u5:GetChildren()) do
            if child:IsA("Frame") and child:GetAttribute("GeneratedMission") then
                v80[child.Name] = child;
            end;
        end;

        local v81 = {};
        local v82 = 0;

        if u79 then
            for _, v in ipairs(u79) do
                local MissionDefinition = Missions.GetMissionDefinition(v.MissionId);

                if MissionDefinition and MissionDefinition.Type == u7 then
                    v82 = v82 + 1;
                    local MissionId = v.MissionId;
                    local v83 = getMissionFingerprint(MissionDefinition, v, v82);
                    local v84 = v80[MissionId];
                    v81[MissionId] = true;

                    if v84 then
                        if u9[MissionId] ~= v83 then
                            Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v84, MissionDefinition, v, v82);
                        end;
                    else
                        Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, MissionDefinition, v, v82);
                    end;

                    u9[MissionId] = v83;
                end;
            end;
        end;

        for i, v in pairs(v80) do
            if not v81[i] then
                Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336
                    -- upvalues: v (copy)
                    v:Destroy();
                end);
                u9[i] = nil;
            end;
        end;

        updateMissionHeader();
    end);
end;

local function renderMissions() -- Line: 346
    -- upvalues: DataController (copy), LocalPlayer (copy), Profiler (copy), u5 (ref), Missions (copy), u7 (ref), getMissionFingerprint (copy), createMissionTemplate (copy), u9 (copy), updateMissionTemplate (copy), updateMissionHeader (copy)
    local u85 = DataController.Get(LocalPlayer, "Missions");
    Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
        -- upvalues: u5 (ref), u85 (copy), Missions (ref), u7 (ref), getMissionFingerprint (ref), Profiler (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref)
        local v86 = {};

        for _, child in ipairs(u5:GetChildren()) do
            if child:IsA("Frame") and child:GetAttribute("GeneratedMission") then
                v86[child.Name] = child;
            end;
        end;

        local v87 = {};
        local v88 = 0;

        if u85 then
            for _, v in ipairs(u85) do
                local MissionDefinition = Missions.GetMissionDefinition(v.MissionId);

                if MissionDefinition and MissionDefinition.Type == u7 then
                    v88 = v88 + 1;
                    local MissionId = v.MissionId;
                    local v89 = getMissionFingerprint(MissionDefinition, v, v88);
                    local v90 = v86[MissionId];
                    v87[MissionId] = true;

                    if v90 then
                        if u9[MissionId] ~= v89 then
                            Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v90, MissionDefinition, v, v88);
                        end;
                    else
                        Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, MissionDefinition, v, v88);
                    end;

                    u9[MissionId] = v89;
                end;
            end;
        end;

        for i, v in pairs(v86) do
            if not v87[i] then
                Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336
                    -- upvalues: v (copy)
                    v:Destroy();
                end);
                u9[i] = nil;
            end;
        end;

        updateMissionHeader();
    end);
end;

local function updateFilterButtons() -- Line: 350
    -- upvalues: u4 (ref), u10 (copy), u7 (ref)
    for _, child in ipairs(u4.ChangeMissionTimes:GetChildren()) do
        if child:IsA("GuiButton") then
            local table_find_ret = table.find(u10, child.Name);
            local v91;

            if table_find_ret then
                v91 = u10[table_find_ret];
            else
                v91 = nil;
            end;

            child.GlowEffect.Visible = v91 == u7;
        end;
    end;
end;

local function openMissionFilter(p92) -- Line: 360
    -- upvalues: u7 (ref), updateFilterButtons (copy), DataController (copy), LocalPlayer (copy), Profiler (copy), u5 (ref), Missions (copy), getMissionFingerprint (copy), createMissionTemplate (copy), u9 (copy), updateMissionTemplate (copy), updateMissionHeader (copy)
    u7 = p92;
    updateFilterButtons();
    local u93 = DataController.Get(LocalPlayer, "Missions");
    Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
        -- upvalues: u5 (ref), u93 (copy), Missions (ref), u7 (ref), getMissionFingerprint (ref), Profiler (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref)
        local v94 = {};

        for _, child in ipairs(u5:GetChildren()) do
            if child:IsA("Frame") and child:GetAttribute("GeneratedMission") then
                v94[child.Name] = child;
            end;
        end;

        local v95 = {};
        local v96 = 0;

        if u93 then
            for _, v in ipairs(u93) do
                local MissionDefinition = Missions.GetMissionDefinition(v.MissionId);

                if MissionDefinition and MissionDefinition.Type == u7 then
                    v96 = v96 + 1;
                    local MissionId = v.MissionId;
                    local v97 = getMissionFingerprint(MissionDefinition, v, v96);
                    local v98 = v94[MissionId];
                    v95[MissionId] = true;

                    if v98 then
                        if u9[MissionId] ~= v97 then
                            Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v98, MissionDefinition, v, v96);
                        end;
                    else
                        Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, MissionDefinition, v, v96);
                    end;

                    u9[MissionId] = v97;
                end;
            end;
        end;

        for i, v in pairs(v94) do
            if not v95[i] then
                Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336
                    -- upvalues: v (copy)
                    v:Destroy();
                end);
                u9[i] = nil;
            end;
        end;

        updateMissionHeader();
    end);
end;

local function setupMissionFilters() -- Line: 366
    -- upvalues: u4 (ref), u10 (copy), ActivateButton (copy), u7 (ref), updateFilterButtons (copy), DataController (copy), LocalPlayer (copy), Profiler (copy), u5 (ref), Missions (copy), getMissionFingerprint (copy), createMissionTemplate (copy), u9 (copy), updateMissionTemplate (copy), updateMissionHeader (copy)
    local v99 = {};

    for _, child in ipairs(u4.ChangeMissionTimes:GetChildren()) do
        if child:IsA("GuiButton") then
            local table_find_ret = table.find(u10, child.Name);
            local u100;

            if table_find_ret then
                u100 = u10[table_find_ret];
            else
                u100 = nil;
            end;

            if u100 and not v99[u100] then
                v99[u100] = true;
                ActivateButton(child);
                child.MouseButton1Click:Connect(function() -- Line: 378
                    -- upvalues: u100 (copy), u7 (ref), updateFilterButtons (ref), DataController (ref), LocalPlayer (ref), Profiler (ref), u5 (ref), Missions (ref), getMissionFingerprint (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref)
                    u7 = u100;
                    updateFilterButtons();
                    local u101 = DataController.Get(LocalPlayer, "Missions");
                    Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
                        -- upvalues: u5 (ref), u101 (copy), Missions (ref), u7 (ref), getMissionFingerprint (ref), Profiler (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref)
                        local v102 = {};

                        for _, child2 in ipairs(u5:GetChildren()) do
                            if child2:IsA("Frame") and child2:GetAttribute("GeneratedMission") then
                                v102[child2.Name] = child2;
                            end;
                        end;

                        local v103 = {};
                        local v104 = 0;

                        if u101 then
                            for _, v in ipairs(u101) do
                                local MissionDefinition = Missions.GetMissionDefinition(v.MissionId);

                                if MissionDefinition and MissionDefinition.Type == u7 then
                                    v104 = v104 + 1;
                                    local MissionId = v.MissionId;
                                    local v105 = getMissionFingerprint(MissionDefinition, v, v104);
                                    local v106 = v102[MissionId];
                                    v103[MissionId] = true;

                                    if v106 then
                                        if u9[MissionId] ~= v105 then
                                            Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v106, MissionDefinition, v, v104);
                                        end;
                                    else
                                        Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, MissionDefinition, v, v104);
                                    end;

                                    u9[MissionId] = v105;
                                end;
                            end;
                        end;

                        for i, v in pairs(v102) do
                            if not v103[i] then
                                Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336
                                    -- upvalues: v (copy)
                                    v:Destroy();
                                end);
                                u9[i] = nil;
                            end;
                        end;

                        updateMissionHeader();
                    end);
                end);
            end;
        end;
    end;

    for _, v in ipairs(u10) do
        local v107 = v99[v];
        local v108 = `Progression is missing its {v} mission filter`;
        assert(v107, v108);
    end;

    updateFilterButtons();
end;

local function attemptStarClaim(p109: number) -- Line: 389
    -- upvalues: DataController (copy), LocalPlayer (copy), Router (copy), Remotes (copy)
    local v110 = DataController.Get(LocalPlayer, "MissionStars");

    if not v110 then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Mission stars are still loading.");

        return;
    end;

    local Rewards = v110.Rewards;
    local v111;

    if Rewards == nil then
        v111 = false;
    else
        v111 = Rewards[tostring(p109)] == true;
    end;

    if v111 then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Star reward already claimed.");

        return;
    end;

    if v110.CurrentStreak < p109 then
        Router.broadcastRouter("CreateMenuNotification", "Error", (`Reach streak day {p109} to claim this reward.`));

        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    Remotes.Dashboard.ClaimStarReward.Send(p109);
end;

local function updateMissionStars(p112) -- Line: 408
    -- upvalues: updateProgressionAlert (copy), MissionStars (copy), u4 (ref), u3 (ref), TweenService (copy), CommaNumber (copy), ColorSequence_new_ret2 (copy), ColorSequence_new_ret (copy), ColorSequence_new_ret3 (copy)
    updateProgressionAlert(p112);
    local v113 = not p112 and 0 or math.clamp(p112.CurrentStreak, 0, #MissionStars);
    local DailyStars = u4.DailyStars;
    local Progress = DailyStars.Bar.Progress;
    local UDim2_fromScale_ret = UDim2.fromScale(v113 / math.max(#MissionStars, 1), 1);

    if u3.Visible then
        TweenService:Create(Progress, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2_fromScale_ret
        }):Play();
    else
        Progress.Size = UDim2_fromScale_ret;
    end;

    u4.StarHeader.Streak.Streak.Text = tostring(v113);

    for i, v in ipairs(MissionStars) do
        local v114 = DailyStars.Container:FindFirstChild((`Template{i}`));
        local v115 = `Progression is missing star template {i}`;
        assert(v114, v115);
        local v116;

        if p112 == nil then
            v116 = false;
        else
            local Rewards = p112.Rewards;

            if Rewards == nil then
                v116 = false;
            else
                v116 = Rewards[tostring(i)] == true;
            end;
        end;

        local v117 = i <= v113;
        v114.ItemTemplate.Amount.Text = `x{CommaNumber(v)}`;
        v114.Title.Text = v116 and "CLAIMED" or (v117 and "CLAIM" or tostring(i));
        v114.Star.Glow.Visible = v117;
        local v118;

        if v116 then
            v118 = ColorSequence_new_ret2;
        elseif v117 then
            v118 = ColorSequence_new_ret;
        else
            v118 = ColorSequence_new_ret3;
        end;

        v114.Star.Icon.UIGradient.Color = v118;
        v114.Title.UIGradient.Color = v118;
        v114.Star.Glow.UIGradient.Color = v118;
    end;
end;

local function setupMissionStars() -- Line: 442
    -- upvalues: MissionStars (copy), u4 (ref), ActivateButton (copy), attemptStarClaim (copy), updateMissionStars (copy), DataController (copy), LocalPlayer (copy)
    for i = 1, #MissionStars do
        local v119 = u4.DailyStars.Container:FindFirstChild((`Template{i}`));
        local v120 = `Progression is missing star template {i}`;
        assert(v119, v120);
        ActivateButton(v119);
        v119.MouseButton1Click:Connect(function() -- Line: 447
            -- upvalues: attemptStarClaim (ref), i (copy)
            attemptStarClaim(i);
        end);
        local _ = i;
    end;

    updateMissionStars((DataController.Get(LocalPlayer, "MissionStars")));
end;

local function setupRefreshButtons() -- Line: 454
    -- upvalues: u4 (ref), ActivateButton (copy), MarketplaceService (copy), LocalPlayer (copy), DevProducts (copy), Router (copy)
    local More = u4.MissionHeader.More;
    ActivateButton(More);
    More.MouseButton1Click:Connect(function() -- Line: 457
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), DevProducts (ref), Router (ref)
        MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts["Refresh Missions"].DevProductId);
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
end;

local function visibilityUpdated(p121: boolean) -- Line: 463
    -- upvalues: DataController (copy), LocalPlayer (copy), updateProgressionAlert (copy), Profiler (copy), u5 (ref), Missions (copy), u7 (ref), getMissionFingerprint (copy), createMissionTemplate (copy), u9 (copy), updateMissionTemplate (copy), updateMissionHeader (copy), updateMissionStars (copy)
    local v122 = DataController.Get(LocalPlayer, "MissionStars");
    updateProgressionAlert(v122, (DataController.Get(LocalPlayer, "Missions")));

    if p121 then
        local u123 = DataController.Get(LocalPlayer, "Missions");
        Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
            -- upvalues: u5 (ref), u123 (copy), Missions (ref), u7 (ref), getMissionFingerprint (ref), Profiler (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref)
            local v124 = {};

            for _, child in ipairs(u5:GetChildren()) do
                if child:IsA("Frame") and child:GetAttribute("GeneratedMission") then
                    v124[child.Name] = child;
                end;
            end;

            local v125 = {};
            local v126 = 0;

            if u123 then
                for _, v in ipairs(u123) do
                    local MissionDefinition = Missions.GetMissionDefinition(v.MissionId);

                    if MissionDefinition and MissionDefinition.Type == u7 then
                        v126 = v126 + 1;
                        local MissionId = v.MissionId;
                        local v127 = getMissionFingerprint(MissionDefinition, v, v126);
                        local v128 = v124[MissionId];
                        v125[MissionId] = true;

                        if v128 then
                            if u9[MissionId] ~= v127 then
                                Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v128, MissionDefinition, v, v126);
                            end;
                        else
                            Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, MissionDefinition, v, v126);
                        end;

                        u9[MissionId] = v127;
                    end;
                end;
            end;

            for i, v in pairs(v124) do
                if not v125[i] then
                    Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336
                        -- upvalues: v (copy)
                        v:Destroy();
                    end);
                    u9[i] = nil;
                end;
            end;

            updateMissionHeader();
        end);
        updateMissionStars(v122);
    end;
end;

function v1.Initialize(p129: any, p130: userdata) -- Line: 474
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), MissionIcons (copy), ContentProvider (copy), setupMissionFilters (copy), setupMissionStars (copy), ActivateButton (copy), MarketplaceService (copy), LocalPlayer (copy), DevProducts (copy), Router (copy), DataController (copy), Profiler (copy), Missions (copy), u7 (ref), getMissionFingerprint (copy), createMissionTemplate (copy), u9 (copy), updateMissionTemplate (copy), updateMissionHeader (copy), updateProgressionAlert (copy), updateMissionStars (copy), ConfigKeys (copy), ConfigController (copy), renderMissions (copy)
    u2 = p129;
    u3 = p130;
    u4 = p130.Missions;
    u5 = u4.MissionsTab;
    u6 = u5.MissionTemplate:Clone();
    u6.Parent = nil;
    u5.MissionTemplate:Destroy();
    local u131 = {};

    for _, v in MissionIcons do
        if not table.find(u131, v) then
            table.insert(u131, v);
        end;
    end;

    task.spawn(function() -- Line: 491
        -- upvalues: ContentProvider (ref), u131 (copy)
        ContentProvider:PreloadAsync(u131);
    end);
    setupMissionFilters();
    setupMissionStars();
    local More = u4.MissionHeader.More;
    ActivateButton(More);
    More.MouseButton1Click:Connect(function() -- Line: 457
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), DevProducts (ref), Router (ref)
        MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts["Refresh Missions"].DevProductId);
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    local u132 = DataController.Get(LocalPlayer, "Missions");
    Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
        -- upvalues: u5 (ref), u132 (copy), Missions (ref), u7 (ref), getMissionFingerprint (ref), Profiler (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref)
        local v133 = {};

        for _, child in ipairs(u5:GetChildren()) do
            if child:IsA("Frame") and child:GetAttribute("GeneratedMission") then
                v133[child.Name] = child;
            end;
        end;

        local v134 = {};
        local v135 = 0;

        if u132 then
            for _, v in ipairs(u132) do
                local MissionDefinition = Missions.GetMissionDefinition(v.MissionId);

                if MissionDefinition and MissionDefinition.Type == u7 then
                    v135 = v135 + 1;
                    local MissionId = v.MissionId;
                    local v136 = getMissionFingerprint(MissionDefinition, v, v135);
                    local v137 = v133[MissionId];
                    v134[MissionId] = true;

                    if v137 then
                        if u9[MissionId] ~= v136 then
                            Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v137, MissionDefinition, v, v135);
                        end;
                    else
                        Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, MissionDefinition, v, v135);
                    end;

                    u9[MissionId] = v136;
                end;
            end;
        end;

        for i, v in pairs(v133) do
            if not v134[i] then
                Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336
                    -- upvalues: v (copy)
                    v:Destroy();
                end);
                u9[i] = nil;
            end;
        end;

        updateMissionHeader();
    end);
    updateProgressionAlert(DataController.Get(LocalPlayer, "MissionStars"), (DataController.Get(LocalPlayer, "Missions")));
    DataController.CreateListener(LocalPlayer, "Missions", function(u138) -- Line: 504
        -- upvalues: Profiler (ref), u3 (ref), u5 (ref), Missions (ref), u7 (ref), getMissionFingerprint (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref), updateProgressionAlert (ref)
        Profiler.scope("UI.Progression.MissionsChanged", function() -- Line: 505
            -- upvalues: u3 (ref), u138 (copy), Profiler (ref), u5 (ref), Missions (ref), u7 (ref), getMissionFingerprint (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref), updateProgressionAlert (ref)
            if u3.Visible then
                local u139 = u138;
                Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
                    -- upvalues: u5 (ref), u139 (copy), Missions (ref), u7 (ref), getMissionFingerprint (ref), Profiler (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref)
                    local v140 = {};

                    for _, child in ipairs(u5:GetChildren()) do
                        if child:IsA("Frame") and child:GetAttribute("GeneratedMission") then
                            v140[child.Name] = child;
                        end;
                    end;

                    local v141 = {};
                    local v142 = 0;

                    if u139 then
                        for _, v in ipairs(u139) do
                            local MissionDefinition = Missions.GetMissionDefinition(v.MissionId);

                            if MissionDefinition and MissionDefinition.Type == u7 then
                                v142 = v142 + 1;
                                local MissionId = v.MissionId;
                                local v143 = getMissionFingerprint(MissionDefinition, v, v142);
                                local v144 = v140[MissionId];
                                v141[MissionId] = true;

                                if v144 then
                                    if u9[MissionId] ~= v143 then
                                        Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v144, MissionDefinition, v, v142);
                                    end;
                                else
                                    Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, MissionDefinition, v, v142);
                                end;

                                u9[MissionId] = v143;
                            end;
                        end;
                    end;

                    for i, v in pairs(v140) do
                        if not v141[i] then
                            Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336
                                -- upvalues: v (copy)
                                v:Destroy();
                            end);
                            u9[i] = nil;
                        end;
                    end;

                    updateMissionHeader();
                end);
            end;

            updateProgressionAlert(nil, u138);
        end);
    end);
    DataController.CreateListener(LocalPlayer, "MissionStars", function(p145) -- Line: 512
        -- upvalues: updateMissionStars (ref)
        updateMissionStars(p145);
    end);

    for _, v in pairs(ConfigKeys.Shared.MissionCreditRewardMultipliers) do
        ConfigController.OnChanged(v, renderMissions);
    end;
end;

function v1.Start() -- Line: 520
    -- upvalues: RunService (copy), u3 (ref), updateMissionHeader (copy), DataController (copy), LocalPlayer (copy), updateProgressionAlert (copy), Profiler (copy), u5 (ref), Missions (copy), u7 (ref), getMissionFingerprint (copy), createMissionTemplate (copy), u9 (copy), updateMissionTemplate (copy), updateMissionStars (copy)
    local u146 = 0;
    RunService.Heartbeat:Connect(function(p147: number) -- Line: 522
        -- upvalues: u3 (ref), u146 (ref), updateMissionHeader (ref)
        if not u3.Visible then
            return;
        end;

        u146 = u146 + p147;

        if u146 >= 1 then
            u146 = 0;
            updateMissionHeader();
        end;
    end);
    u3:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 532
        -- upvalues: u3 (ref), DataController (ref), LocalPlayer (ref), updateProgressionAlert (ref), Profiler (ref), u5 (ref), Missions (ref), u7 (ref), getMissionFingerprint (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref), updateMissionStars (ref)
        local Visible = u3.Visible;
        local v148 = DataController.Get(LocalPlayer, "MissionStars");
        updateProgressionAlert(v148, (DataController.Get(LocalPlayer, "Missions")));

        if Visible then
            local u149 = DataController.Get(LocalPlayer, "Missions");
            Profiler.scope("UI.Progression.ReconcileMissions", function() -- Line: 285
                -- upvalues: u5 (ref), u149 (copy), Missions (ref), u7 (ref), getMissionFingerprint (ref), Profiler (ref), createMissionTemplate (ref), u9 (ref), updateMissionTemplate (ref), updateMissionHeader (ref)
                local v150 = {};

                for _, child in ipairs(u5:GetChildren()) do
                    if child:IsA("Frame") and child:GetAttribute("GeneratedMission") then
                        v150[child.Name] = child;
                    end;
                end;

                local v151 = {};
                local v152 = 0;

                if u149 then
                    for _, v in ipairs(u149) do
                        local MissionDefinition = Missions.GetMissionDefinition(v.MissionId);

                        if MissionDefinition and MissionDefinition.Type == u7 then
                            v152 = v152 + 1;
                            local MissionId = v.MissionId;
                            local v153 = getMissionFingerprint(MissionDefinition, v, v152);
                            local v154 = v150[MissionId];
                            v151[MissionId] = true;

                            if v154 then
                                if u9[MissionId] ~= v153 then
                                    Profiler.scope("UI.Progression.UpdateMissionRow", updateMissionTemplate, v154, MissionDefinition, v, v152);
                                end;
                            else
                                Profiler.scope("UI.Progression.CreateMissionRow", createMissionTemplate, MissionDefinition, v, v152);
                            end;

                            u9[MissionId] = v153;
                        end;
                    end;
                end;

                for i, v in pairs(v150) do
                    if not v151[i] then
                        Profiler.scope("UI.Progression.DestroyMissionRow", function() -- Line: 336
                            -- upvalues: v (copy)
                            v:Destroy();
                        end);
                        u9[i] = nil;
                    end;
                end;

                updateMissionHeader();
            end);
            updateMissionStars(v148);
        end;
    end);
end;

return v1;