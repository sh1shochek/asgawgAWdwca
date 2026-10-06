-- Decompiled with Potassium's decompiler.

local v1 = {};
local ExperienceNotificationService = game:GetService("ExperienceNotificationService");
local AvatarEditorService = game:GetService("AvatarEditorService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SocialService = game:GetService("SocialService");
local GroupService = game:GetService("GroupService");
local Players = game:GetService("Players");
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local AnimateDashboardCard = require(ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateDashboardCard);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = false;
local Color3_fromRGB_ret = Color3.fromRGB(120, 120, 120);
local u5 = {
    EnableNotifications = "Notifications",
    FavoriteGame = "FavoriteGame",
    InviteFriends = "InviteFriend",
    JoinGroup = "JoinGroup",
    LikeGame = "LikeGame"
};
local u6 = { { "group", "JoinGroup" }, { "favorite", "FavoriteGame" }, { "notification", "Notifications" }, { "like", "LikeGame" } };

local function centerButtonAnchor(p7: userdata) -- Line: 67
    local Size = p7.Size;
    local Position = p7.Position;
    local AnchorPoint = p7.AnchorPoint;
    p7.AnchorPoint = Vector2.new(0.5, 0.5);
    p7.Position = UDim2.new(Position.X.Scale + Size.X.Scale * (0.5 - AnchorPoint.X), Position.X.Offset + Size.X.Offset * (0.5 - AnchorPoint.X), Position.Y.Scale + Size.Y.Scale * (0.5 - AnchorPoint.Y), Position.Y.Offset + Size.Y.Offset * (0.5 - AnchorPoint.Y));
end;

local function getRowButton(p8: userdata) -- Line: 82
    local v9 = p8:FindFirstChild("Redeem") or p8:FindFirstChild("Verify");

    if v9 and v9:IsA("GuiButton") then
        return v9;
    end;

    return nil;
end;

local function getRowTitle(p10: userdata) -- Line: 89
    local Title = p10:FindFirstChild("Title");

    return not Title and "" or string.lower(Title.Text);
end;

local function updateClaimedState(p11: userdata, p12: boolean) -- Line: 96
    local RewardTemplate = p11:FindFirstChild("RewardTemplate");

    if not RewardTemplate then
        return;
    end;

    local Finish = RewardTemplate:FindFirstChild("Finish");
    local Icon = RewardTemplate:FindFirstChild("Icon");
    local Amount = RewardTemplate:FindFirstChild("Amount");

    if Finish then
        Finish.Visible = p12;
    end;

    if Icon then
        Icon.Visible = not p12;
    end;

    if Amount then
        Amount.Visible = not p12;
    end;
end;

local function isRewardClaimed(p13: string) -- Line: 118
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v14 = DataController.Get(LocalPlayer, "PromotionalRewards");
    local v15;

    if typeof(v14) == "table" then
        v15 = v14[p13] == true;
    else
        v15 = false;
    end;

    return v15;
end;

local function hasReferredFriendInServer() -- Line: 125
    -- upvalues: Players (copy), LocalPlayer (copy)
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v:GetAttribute("ReferredByPlayerId") == LocalPlayer.UserId then
            return true;
        end;
    end;

    return false;
end;

local function canSendGameInvite() -- Line: 141
    -- upvalues: SocialService (copy), LocalPlayer (copy)
    for i = 1, 2 do
        local success, result = pcall(function() -- Line: 143
            -- upvalues: SocialService (ref), LocalPlayer (ref)
            return SocialService:CanSendGameInviteAsync(LocalPlayer);
        end);

        if success and typeof(result) == "boolean" then
            return true, result;
        end;

        if not success then
            warn((`Rewards invite availability check failed: {result}`));
        end;

        local v16;

        if i < 2 then
            task.wait(0.35);
            v16 = i;
        else
            v16 = i;
        end;
    end;

    return false, false;
end;

local function setupInviteRow(p17: userdata, p18: userdata) -- Line: 161
    -- upvalues: DataController (copy), LocalPlayer (copy), Router (copy), hasReferredFriendInServer (copy), Remotes (copy), u4 (ref), canSendGameInvite (copy), SocialService (copy)
    p18.MouseButton1Click:Connect(function() -- Line: 162
        -- upvalues: DataController (ref), LocalPlayer (ref), Router (ref), hasReferredFriendInServer (ref), Remotes (ref), u4 (ref), canSendGameInvite (ref), SocialService (ref)
        local v19 = DataController.Get(LocalPlayer, "PromotionalRewards");
        local v20;

        if typeof(v19) == "table" then
            v20 = v19.InviteFriend == true;
        else
            v20 = false;
        end;

        if v20 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.");

            return;
        end;

        if hasReferredFriendInServer() then
            Remotes.Dashboard.RedeemPromotionalReward.Send("InviteFriend");

            return;
        end;

        if u4 then
            return;
        end;

        u4 = true;
        local v21, v22 = canSendGameInvite();

        if v21 and not v22 then
            u4 = false;
            Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites aren\'t available for your account or device.");

            return;
        end;

        local success, result = pcall(function() -- Line: 187
            -- upvalues: SocialService (ref), LocalPlayer (ref)
            SocialService:PromptGameInvite(LocalPlayer);
        end);
        u4 = false;

        if not success then
            warn((`Rewards invite prompt failed: {result}`));
            Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites are unavailable right now. Please try again.");
        end;
    end);
end;

local function setupCodeRow(p23: userdata, p24: userdata) -- Line: 201
    -- upvalues: Router (copy), DataController (copy), LocalPlayer (copy), Remotes (copy)
    local u25 = p23:FindFirstChildWhichIsA("TextBox", true);

    if not u25 then
        warn("Rewards code row is missing its textbox.");

        return;
    end;

    local function submitCode() -- Line: 209
        -- upvalues: u25 (copy), Router (ref), DataController (ref), LocalPlayer (ref), Remotes (ref)
        local string_gsub_ret = string.gsub(u25.Text, "%s+", "");

        if string_gsub_ret == "" then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Please enter a code first.");

            return;
        end;

        local v26 = DataController.Get(LocalPlayer, "Level");
        local v27;

        if typeof(v26) == "table" then
            v27 = v26.Level;
        else
            v27 = nil;
        end;

        if typeof(v27) ~= "number" or v27 < 5 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You need to be at least level 5 to redeem codes.");

            return;
        end;

        Remotes.Dashboard.RedeemCode.Send(string_gsub_ret);
        u25.Text = "";
    end;

    p24.MouseButton1Click:Connect(submitCode);
    u25.FocusLost:Connect(function(p28: boolean) -- Line: 235
        -- upvalues: submitCode (copy)
        if p28 then
            submitCode();
        end;
    end);
end;

local function trackClaimedState(u29: userdata, u30: userdata, u31: string) -- Line: 244
    -- upvalues: Constants (copy), DataController (copy), LocalPlayer (copy), updateClaimedState (copy), Color3_fromRGB_ret (copy)
    local RewardTemplate = u29:FindFirstChild("RewardTemplate");

    if RewardTemplate then
        RewardTemplate = RewardTemplate:FindFirstChild("Amount");
    end;

    if RewardTemplate then
        RewardTemplate.Text = `x{Constants.PROMOTIONAL_REWARD_CREDITS[u31] or 0}`;
    end;

    local Title = u30:FindFirstChild("Title");
    local u32 = not Title and "" or Title.Text;
    local u33;

    if u30:IsA("ImageButton") then
        u33 = u30.ImageColor3;
    else
        u33 = Color3.new(1, 1, 1);
    end;

    local function refreshClaimedState() -- Line: 256
        -- upvalues: u31 (copy), DataController (ref), LocalPlayer (ref), updateClaimedState (ref), u29 (copy), u30 (copy), Color3_fromRGB_ret (ref), u33 (copy), Title (copy), u32 (copy)
        local v34 = u31;
        local v35 = DataController.Get(LocalPlayer, "PromotionalRewards");
        local v36;

        if typeof(v35) == "table" then
            v36 = v35[v34] == true;
        else
            v36 = false;
        end;

        updateClaimedState(u29, v36);
        u30.Interactable = not v36;

        if u30:IsA("ImageButton") then
            local v37;

            if v36 then
                v37 = Color3_fromRGB_ret;
            else
                v37 = u33;
            end;

            u30.ImageColor3 = v37;
        end;

        if Title then
            Title.Text = v36 and "CLAIMED" or u32;
        end;
    end;

    local v38 = DataController.Get(LocalPlayer, "PromotionalRewards");
    local v39;

    if typeof(v38) == "table" then
        v39 = v38[u31] == true;
    else
        v39 = false;
    end;

    updateClaimedState(u29, v39);
    u30.Interactable = not v39;

    if u30:IsA("ImageButton") then
        if v39 then
            u33 = Color3_fromRGB_ret;
        end;

        u30.ImageColor3 = u33;
    end;

    if Title then
        Title.Text = v39 and "CLAIMED" or u32;
    end;

    DataController.CreateListener(LocalPlayer, "PromotionalRewards", refreshClaimedState);
end;

local u44 = {
    Notifications = function() -- Line: 346, Name: promptNotificationsOptIn
        -- upvalues: ExperienceNotificationService (copy), Router (copy)
        local success, result = pcall(function() -- Line: 347
            -- upvalues: ExperienceNotificationService (ref)
            return ExperienceNotificationService:CanPromptOptInAsync();
        end);

        if not (success and result) then
            return false;
        end;

        local success2 = pcall(function() -- Line: 355
            -- upvalues: ExperienceNotificationService (ref)
            ExperienceNotificationService:PromptOptIn();
        end);

        if success2 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Turn on notifications, then press verify again to redeem.");
        end;

        return success2;
    end,

    FavoriteGame = function() -- Line: 308, Name: promptFavoriteGame
        -- upvalues: AvatarEditorService (copy), Router (copy)
        local success, result = pcall(function() -- Line: 309
            -- upvalues: AvatarEditorService (ref)
            return AvatarEditorService:GetFavoriteAsync(114234929420007, Enum.AvatarItemType.Asset);
        end);

        if success and result then
            return false;
        end;

        local u40 = nil;
        local v42 = AvatarEditorService.PromptSetFavoriteCompleted:Connect(function(p41) -- Line: 318
            -- upvalues: u40 (ref)
            u40 = p41;
        end);

        if not pcall(function() -- Line: 322
            -- upvalues: AvatarEditorService (ref)
            AvatarEditorService:PromptSetFavorite(114234929420007, Enum.AvatarItemType.Asset, true);
        end) then
            v42:Disconnect();

            return false;
        end;

        local v43 = os.clock() + 30;

        while u40 == nil and os.clock() < v43 do
            task.wait(0.1);
        end;

        v42:Disconnect();

        if u40 == Enum.AvatarPromptResult.Success then
            return false;
        end;

        Router.broadcastRouter("CreateMenuNotification", "Error", "Favorite the game to redeem this reward.");

        return true;
    end,

    JoinGroup = function() -- Line: 276, Name: promptGroupJoin
        -- upvalues: LocalPlayer (copy), GroupService (copy), Router (copy)
        local success, result = pcall(function() -- Line: 277
            -- upvalues: LocalPlayer (ref)
            return LocalPlayer:IsInGroupAsync(33751825);
        end);

        if success and result then
            return false;
        end;

        local success2, result2 = pcall(function() -- Line: 285
            -- upvalues: GroupService (ref)
            return GroupService:PromptJoinAsync(33751825);
        end);

        if success2 and (result2 == Enum.GroupMembershipStatus.Joined or result2 == Enum.GroupMembershipStatus.AlreadyMember) then
            return false;
        end;

        if not success2 then
            return false;
        end;

        Router.broadcastRouter("CreateMenuNotification", "Error", "Join the group, then press join again to redeem.");

        return true;
    end
};

local function setupPromotionalRow(p45: userdata, p46: userdata, u47: string) -- Line: 376
    -- upvalues: DataController (copy), LocalPlayer (copy), Router (copy), u44 (copy), Remotes (copy)
    p46.MouseButton1Click:Connect(function() -- Line: 377
        -- upvalues: u47 (copy), DataController (ref), LocalPlayer (ref), Router (ref), u44 (ref), Remotes (ref)
        local v48 = u47;
        local v49 = DataController.Get(LocalPlayer, "PromotionalRewards");
        local v50;

        if typeof(v49) == "table" then
            v50 = v49[v48] == true;
        else
            v50 = false;
        end;

        if v50 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.");

            return;
        end;

        local v51 = u44[u47];

        if v51 and v51() then
            return;
        end;

        Remotes.Dashboard.RedeemPromotionalReward.Send(u47);
    end);
end;

local function setupRewardRow(p52: userdata) -- Line: 395
    -- upvalues: centerButtonAnchor (copy), ActivateButton (copy), u5 (copy), trackClaimedState (copy), DataController (copy), LocalPlayer (copy), Router (copy), hasReferredFriendInServer (copy), Remotes (copy), u4 (ref), canSendGameInvite (copy), SocialService (copy), u44 (copy), setupCodeRow (copy), u6 (copy)
    local v53 = p52:FindFirstChild("Redeem") or p52:FindFirstChild("Verify");

    if not (v53 and v53:IsA("GuiButton")) then
        v53 = nil;
    end;

    if not v53 then
        return;
    end;

    centerButtonAnchor(v53);
    ActivateButton(v53);
    local u54 = u5[p52.Name];

    if u54 then
        trackClaimedState(p52, v53, u54);

        if u54 == "InviteFriend" then
            v53.MouseButton1Click:Connect(function() -- Line: 162
                -- upvalues: DataController (ref), LocalPlayer (ref), Router (ref), hasReferredFriendInServer (ref), Remotes (ref), u4 (ref), canSendGameInvite (ref), SocialService (ref)
                local v55 = DataController.Get(LocalPlayer, "PromotionalRewards");
                local v56;

                if typeof(v55) == "table" then
                    v56 = v55.InviteFriend == true;
                else
                    v56 = false;
                end;

                if v56 then
                    Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.");

                    return;
                end;

                if hasReferredFriendInServer() then
                    Remotes.Dashboard.RedeemPromotionalReward.Send("InviteFriend");

                    return;
                end;

                if u4 then
                    return;
                end;

                u4 = true;
                local v57, v58 = canSendGameInvite();

                if v57 and not v58 then
                    u4 = false;
                    Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites aren\'t available for your account or device.");

                    return;
                end;

                local success, result = pcall(function() -- Line: 187
                    -- upvalues: SocialService (ref), LocalPlayer (ref)
                    SocialService:PromptGameInvite(LocalPlayer);
                end);
                u4 = false;

                if not success then
                    warn((`Rewards invite prompt failed: {result}`));
                    Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites are unavailable right now. Please try again.");
                end;
            end);

            return;
        end;

        v53.MouseButton1Click:Connect(function() -- Line: 377
            -- upvalues: u54 (copy), DataController (ref), LocalPlayer (ref), Router (ref), u44 (ref), Remotes (ref)
            local v59 = u54;
            local v60 = DataController.Get(LocalPlayer, "PromotionalRewards");
            local v61;

            if typeof(v60) == "table" then
                v61 = v60[v59] == true;
            else
                v61 = false;
            end;

            if v61 then
                Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.");

                return;
            end;

            local v62 = u44[u54];

            if v62 and v62() then
                return;
            end;

            Remotes.Dashboard.RedeemPromotionalReward.Send(u54);
        end);

        return;
    end;

    local Title = p52:FindFirstChild("Title");
    local v63 = not Title and "" or string.lower(Title.Text);

    if p52:FindFirstChildWhichIsA("TextBox", true) then
        setupCodeRow(p52, v53);

        return;
    end;

    if string.find(v63, "invite") then
        trackClaimedState(p52, v53, "InviteFriend");
        v53.MouseButton1Click:Connect(function() -- Line: 162
            -- upvalues: DataController (ref), LocalPlayer (ref), Router (ref), hasReferredFriendInServer (ref), Remotes (ref), u4 (ref), canSendGameInvite (ref), SocialService (ref)
            local v64 = DataController.Get(LocalPlayer, "PromotionalRewards");
            local v65;

            if typeof(v64) == "table" then
                v65 = v64.InviteFriend == true;
            else
                v65 = false;
            end;

            if v65 then
                Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.");

                return;
            end;

            if hasReferredFriendInServer() then
                Remotes.Dashboard.RedeemPromotionalReward.Send("InviteFriend");

                return;
            end;

            if u4 then
                return;
            end;

            u4 = true;
            local v66, v67 = canSendGameInvite();

            if v66 and not v67 then
                u4 = false;
                Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites aren\'t available for your account or device.");

                return;
            end;

            local success, result = pcall(function() -- Line: 187
                -- upvalues: SocialService (ref), LocalPlayer (ref)
                SocialService:PromptGameInvite(LocalPlayer);
            end);
            u4 = false;

            if not success then
                warn((`Rewards invite prompt failed: {result}`));
                Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites are unavailable right now. Please try again.");
            end;
        end);

        return;
    end;

    for _, v in u6 do
        if string.find(v63, v[1]) then
            trackClaimedState(p52, v53, v[2]);
            local u68 = v[2];
            v53.MouseButton1Click:Connect(function() -- Line: 377
                -- upvalues: u68 (copy), DataController (ref), LocalPlayer (ref), Router (ref), u44 (ref), Remotes (ref)
                local v69 = u68;
                local v70 = DataController.Get(LocalPlayer, "PromotionalRewards");
                local v71;

                if typeof(v70) == "table" then
                    v71 = v70[v69] == true;
                else
                    v71 = false;
                end;

                if v71 then
                    Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.");

                    return;
                end;

                local v72 = u44[u68];

                if v72 and v72() then
                    return;
                end;

                Remotes.Dashboard.RedeemPromotionalReward.Send(u68);
            end);

            return;
        end;
    end;

    warn((`Rewards row "{v63}" has no matching reward.`));
end;

function v1.Initialize(p73: userdata, p74: userdata) -- Line: 437
    -- upvalues: u2 (ref), u3 (ref), setupRewardRow (copy), centerButtonAnchor (copy), ActivateButton (copy)
    u2 = p73;
    u3 = p74;
    u3.Visible = false;
    u3.Active = true;
    local Container = u3:FindFirstChild("Container");

    if Container then
        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA("Frame") then
                setupRewardRow(child);
            end;
        end;
    end;

    local Title = u3:FindFirstChild("Title");

    if Title then
        Title = Title:FindFirstChild("Close");
    end;

    if Title then
        centerButtonAnchor(Title);
        ActivateButton(Title);
        Title.MouseButton1Click:Connect(function() -- Line: 458
            -- upvalues: u3 (ref)
            u3.Visible = false;
        end);
    end;
end;

function v1.Start() -- Line: 466
    -- upvalues: u2 (ref), AnimateDashboardCard (copy), u3 (ref), MenuState (copy)
    local Menu = u2:FindFirstChild("Menu");

    if Menu then
        Menu = Menu:FindFirstChild("Dashboard");
    end;

    if Menu then
        Menu = Menu:FindFirstChild("Rewards");
    end;

    local v75;

    if Menu then
        v75 = Menu:FindFirstChild("Button");
    else
        v75 = Menu;
    end;

    if not v75 then
        warn("Rewards is missing its dashboard button.");

        return;
    end;

    AnimateDashboardCard(Menu, v75);
    v75.MouseButton1Click:Connect(function() -- Line: 479
        -- upvalues: u3 (ref)
        u3.Visible = not u3.Visible;
    end);
    MenuState.OnScreenChanged:Connect(function(p76, p77) -- Line: 484
        -- upvalues: u3 (ref)
        if p77 ~= nil and p77 ~= "Dashboard" then
            u3.Visible = false;
        end;
    end);
end;

return v1;