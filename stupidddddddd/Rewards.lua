-- ReplicatedStorage.Interface.Screens.Menu.Rewards
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Rewards
-- Decompile time: 8.63 ms

local v1 = {}
local ExperienceNotificationService = game:GetService("ExperienceNotificationService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local AnimateDashboardCard = require(ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateDashboardCard)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local LocalPlayer = Players.LocalPlayer
local u67 = nil
local u68 = nil
local u69 = false
local u74 = Color3.fromRGB(120, 120, 120)
local u75 = {
    EnableNotifications = "Notifications",
    FavoriteGame = "FavoriteGame",
    InviteFriends = "InviteFriend",
    JoinGroup = "JoinGroup",
    LikeGame = "LikeGame",
}
local u76 = {
    {"group", "JoinGroup"},
    {"favorite", "FavoriteGame"},
    {"notification", "Notifications"},
    {"like", "LikeGame"},
}

local function centerButtonAnchor(a1) -- Line: 67 -- types: a1: userdata
    local Size = a1.Size
    local Position = a1.Position
    local AnchorPoint = a1.AnchorPoint
    a1.AnchorPoint = Vector2.new(0.5, 0.5)
    a1.Position = UDim2.new(
        Position.X.Scale + Size.X.Scale * (0.5 - AnchorPoint.X),
        Position.X.Offset + Size.X.Offset * (0.5 - AnchorPoint.X),
        Position.Y.Scale + Size.Y.Scale * (0.5 - AnchorPoint.Y),
        Position.Y.Offset + Size.Y.Offset * (0.5 - AnchorPoint.Y)
    )
end

local function getRowButton(a1) -- Line: 82 -- types: a1: userdata
    local Redeem = a1:FindFirstChild("Redeem") or a1:FindFirstChild("Verify")
    if Redeem and Redeem:IsA("GuiButton") then
        return Redeem
    end
    return nil
end

local function getRowTitle(a1) -- Line: 89 -- types: a1: userdata
    local Title = a1:FindFirstChild("Title")
    if Title then
        return (string.lower(Title.Text))
    end
    return ""
end

local function updateClaimedState(a1, a2) -- Line: 96 -- types: a1: userdata, a2: boolean
    local RewardTemplate = a1:FindFirstChild("RewardTemplate")
    if not RewardTemplate then
        return
    end
    local Finish = RewardTemplate:FindFirstChild("Finish")
    local Icon = RewardTemplate:FindFirstChild("Icon")
    local Amount = RewardTemplate:FindFirstChild("Amount")
    if Finish then
        Finish.Visible = a2
    end
    if Icon then
        Icon.Visible = not a2
    end
    if Amount then
        Amount.Visible = not a2
    end
end

local function isRewardClaimed(a1) -- Line: 118
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = DataController.Get(LocalPlayer, "PromotionalRewards")
    local v2 = false
    if typeof(v1) == "table" then
        v2 = v1[a1] == true
    end
    return v2
end

local function hasReferredFriendInServer() -- Line: 125 -- upvalues: Players (val), LocalPlayer (val)
    for i, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and (v:GetAttribute("ReferredByPlayerId")) == LocalPlayer.UserId then
            return true
        end
    end
    return false
end

local function canSendGameInvite() -- Line: 141 -- upvalues: SocialService (val), LocalPlayer (val)
    local result, success
    for i = 1, 2 do
        success, result = pcall(function() -- Line: 143 -- upvalues: SocialService (upval), LocalPlayer (upval)
            return SocialService:CanSendGameInviteAsync(LocalPlayer)
        end)
        if success and typeof(result) == "boolean" then
            return true, result
        end
        if not success then
            warn((("Rewards invite availability check failed: %*"):format(result)))
        end
        if i < 2 then
            task.wait(0.35)
        end
    end
    return false, false
end

local function setupInviteRow(a1, a2) -- Line: 161
    -- upvalues: DataController (val), LocalPlayer (val), Router (val), hasReferredFriendInServer (val), Remotes (val)
    -- upvalues: u69 (ref), canSendGameInvite (val), SocialService (val)
    a2.MouseButton1Click:Connect(function() -- Line: 162
        -- upvalues: DataController (upval), LocalPlayer (upval), Router (upval), hasReferredFriendInServer (upval)
        -- upvalues: Remotes (upval), u69 (upval), canSendGameInvite (upval), SocialService (upval)
        local v1 = DataController.Get(LocalPlayer, "PromotionalRewards")
        local v2 = false
        if typeof(v1) == "table" then
            v2 = v1.InviteFriend == true
        end
        if v2 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.")
            return
        end
        if hasReferredFriendInServer() then
            Remotes.Dashboard.RedeemPromotionalReward.Send("InviteFriend")
            return
        end
        if u69 then
            return
        end
        u69 = true
        v2, v1 = canSendGameInvite()
        if v2 and not v1 then
            u69 = false
            Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites aren't available for your account or device.")
            return
        end
        local success, result = pcall(function() -- Line: 187 -- upvalues: SocialService (upval), LocalPlayer (upval)
            SocialService:PromptGameInvite(LocalPlayer)
        end)
        u69 = false
        if not success then
            warn((("Rewards invite prompt failed: %*"):format(result)))
            Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites are unavailable right now. Please try again.")
        end
    end)
end

local function setupCodeRow(a1, a2) -- Line: 201
    -- upvalues: Router (val), DataController (val), LocalPlayer (val), Remotes (val)
    local TextBox = a1:FindFirstChildWhichIsA("TextBox", true)
    if not TextBox then
        warn("Rewards code row is missing its textbox.")
        return
    end

    local function submitCode() -- Line: 209
        -- upvalues: TextBox (val), Router (upval), DataController (upval), LocalPlayer (upval), Remotes (upval)
        local v1 = string.gsub(TextBox.Text, "%s+", "")
        if v1 == "" then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Please enter a code first.")
            return
        end
        local v2 = DataController.Get(LocalPlayer, "Level")
        local Level = if typeof(v2) ~= "table" then nil else v2.Level
        if typeof(Level) == "number" and not (Level < 5) then
            Remotes.Dashboard.RedeemCode.Send(v1)
            TextBox.Text = ""
            return
        end
        Router.broadcastRouter("CreateMenuNotification", "Error", "You need to be at least level 5 to redeem codes.")
    end

    a2.MouseButton1Click:Connect(submitCode)
    TextBox.FocusLost:Connect(function(a1) -- Line: 235 -- upvalues: submitCode (val) -- types: a1: boolean
        if a1 then
            submitCode()
        end
    end)
end

local function trackClaimedState(a1, a2, a3) -- Line: 244
    -- upvalues: Constants (val), DataController (val), LocalPlayer (val), updateClaimedState (val), u74 (val)
    local RewardTemplate = a1:FindFirstChild("RewardTemplate")
    local Amount = RewardTemplate and RewardTemplate:FindFirstChild("Amount")
    if Amount then
        Amount.Text = ("x%*"):format(Constants.PROMOTIONAL_REWARD_CREDITS[a3] or 0)
    end
    local Title = a2:FindFirstChild("Title")
    local Text = if not Title then "" else Title.Text
    local ImageColor3 = if not a2:IsA("ImageButton") then Color3.new(1, 1, 1) else a2.ImageColor3

    local function refreshClaimedState() -- Line: 256
        -- upvalues: a3 (val), DataController (upval), LocalPlayer (upval), updateClaimedState (upval), a1 (val)
        -- upvalues: a2 (val), u74 (upval), ImageColor3 (val), Title (val), Text (val)
        local v1 = DataController.Get(LocalPlayer, "PromotionalRewards")
        local v2 = false
        if typeof(v1) == "table" then
            v2 = v1[a3] == true
        end
        updateClaimedState(a1, v2)
        a2.Interactable = not v2
        if a2:IsA("ImageButton") then
            a2.ImageColor3 = if not v2 then ImageColor3 else u74
        end
        if Title then
            Title.Text = if not v2 then Text else "CLAIMED"
        end
    end

    local v1 = DataController.Get(LocalPlayer, "PromotionalRewards")
    local v2 = false
    if typeof(v1) == "table" then
        v2 = v1[a3] == true
    end
    updateClaimedState(a1, v2)
    a2.Interactable = not v2
    if a2:IsA("ImageButton") then
        a2.ImageColor3 = if not v2 then ImageColor3 else u74
    end
    if Title then
        Title.Text = if not v2 then Text else "CLAIMED"
    end
    DataController.CreateListener(LocalPlayer, "PromotionalRewards", refreshClaimedState)
end

local u102 = {}

function u102.Notifications() -- Line: 346 -- upvalues: ExperienceNotificationService (val), Router (val)
    local success, result = pcall(function() -- Line: 347 -- upvalues: ExperienceNotificationService (upval)
        return ExperienceNotificationService:CanPromptOptInAsync()
    end)
    if success and result then
        local v1 = pcall(function() -- Line: 355 -- upvalues: ExperienceNotificationService (upval)
            ExperienceNotificationService:PromptOptIn()
        end)
        if v1 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Turn on notifications, then press verify again to redeem.")
        end
        return v1
    end
    return false
end

function u102.FavoriteGame() -- Line: 308 -- upvalues: AvatarEditorService (val), Router (val)
    local success, result = pcall(function() -- Line: 309 -- upvalues: AvatarEditorService (upval)
        return AvatarEditorService:GetFavoriteAsync(114234929420007, Enum.AvatarItemType.Asset)
    end)
    if success and result then
        return false
    end
    local u5 = nil
    local v1 = AvatarEditorService.PromptSetFavoriteCompleted:Connect(function(a1) -- Line: 318 -- upvalues: u5 (ref)
        u5 = a1
    end)
    if not pcall(function() -- Line: 322 -- upvalues: AvatarEditorService (upval)
        local Asset, v0, v1
        v0 = AvatarEditorService
        Asset = Enum.AvatarItemType.Asset
        v0:PromptSetFavorite(114234929420007, Asset, true)
        return
    end) then
        v1:Disconnect()
        return false
    end
    local v2 = os.clock() + 30
    while u5 == nil do
        if not (os.clock() < v2) then
            break
        end
        task.wait(0.1)
    end
    v1:Disconnect()
    if u5 == Enum.AvatarPromptResult.Success then
        return false
    end
    Router.broadcastRouter("CreateMenuNotification", "Error", "Favorite the game to redeem this reward.")
    return true
end

function u102.JoinGroup() -- Line: 276 -- upvalues: LocalPlayer (val), GroupService (val), Router (val)
    local success, result = pcall(function() -- Line: 277 -- upvalues: LocalPlayer (upval)
        return LocalPlayer:IsInGroupAsync(33751825)
    end)
    if success and result then
        return false
    end
    local success_2, result_2 = pcall(function() -- Line: 285 -- upvalues: GroupService (upval)
        return GroupService:PromptJoinAsync(33751825)
    end)
    if not success_2 then
        if success_2 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Join the group, then press join again to redeem.")
            return true
        end
        return false
    end
    if result_2 ~= Enum.GroupMembershipStatus.Joined and result_2 ~= Enum.GroupMembershipStatus.AlreadyMember then
        if not success_2 then
            return false
        end
        Router.broadcastRouter("CreateMenuNotification", "Error", "Join the group, then press join again to redeem.")
        return true
    end
    return false
end

local function setupPromotionalRow(a1, a2, a3) -- Line: 376
    -- upvalues: DataController (val), LocalPlayer (val), Router (val), u102 (val), Remotes (val)
    a2.MouseButton1Click:Connect(function() -- Line: 377
        -- upvalues: a3 (val), DataController (upval), LocalPlayer (upval), Router (upval), u102 (upval)
        -- upvalues: Remotes (upval)
        local v1 = DataController.Get(LocalPlayer, "PromotionalRewards")
        local v2 = false
        if typeof(v1) == "table" then
            v2 = v1[a3] == true
        end
        if v2 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.")
            return
        end
        v2 = u102[a3]
        if v2 and v2() then
            return
        end
        Remotes.Dashboard.RedeemPromotionalReward.Send(a3)
    end)
end

local function setupRewardRow(a1) -- Line: 395
    -- upvalues: centerButtonAnchor (val), ActivateButton (val), u75 (val), trackClaimedState (val)
    -- upvalues: DataController (val), LocalPlayer (val), Router (val), hasReferredFriendInServer (val), Remotes (val)
    -- upvalues: u69 (ref), canSendGameInvite (val), SocialService (val), u102 (val), setupCodeRow (val), u76 (val)
    local u108, v1
    local Redeem = a1:FindFirstChild("Redeem") or a1:FindFirstChild("Verify")
    if not (if not Redeem then nil else if not Redeem:IsA("GuiButton") then nil else Redeem) then
        return
    end
    centerButtonAnchor(v1)
    ActivateButton(v1)
    local u28 = u75[a1.Name]
    if u28 then
        trackClaimedState(a1, v1, u28)
        if u28 == "InviteFriend" then
            v1.MouseButton1Click:Connect(function() -- Line: 162
                -- upvalues: DataController (upval), LocalPlayer (upval), Router (upval)
                -- upvalues: hasReferredFriendInServer (upval), Remotes (upval), u69 (upval), canSendGameInvite (upval)
                -- upvalues: SocialService (upval)
                local v1 = DataController.Get(LocalPlayer, "PromotionalRewards")
                local v2 = false
                if typeof(v1) == "table" then
                    v2 = v1.InviteFriend == true
                end
                if v2 then
                    Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.")
                    return
                end
                if hasReferredFriendInServer() then
                    Remotes.Dashboard.RedeemPromotionalReward.Send("InviteFriend")
                    return
                end
                if u69 then
                    return
                end
                u69 = true
                v2, v1 = canSendGameInvite()
                if v2 and not v1 then
                    u69 = false
                    Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites aren't available for your account or device.")
                    return
                end
                local success, result = pcall(function() -- Line: 187 -- upvalues: SocialService (upval), LocalPlayer (upval)
                    SocialService:PromptGameInvite(LocalPlayer)
                end)
                u69 = false
                if not success then
                    warn((("Rewards invite prompt failed: %*"):format(result)))
                    Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites are unavailable right now. Please try again.")
                end
            end)
            return
        end
        v1.MouseButton1Click:Connect(function() -- Line: 377
            -- upvalues: u28 (val), DataController (upval), LocalPlayer (upval), Router (upval), u102 (upval)
            -- upvalues: Remotes (upval)
            local v1 = DataController.Get(LocalPlayer, "PromotionalRewards")
            local v2 = false
            if typeof(v1) == "table" then
                v2 = v1[u28] == true
            end
            if v2 then
                Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.")
                return
            end
            v2 = u102[u28]
            if v2 and v2() then
                return
            end
            Remotes.Dashboard.RedeemPromotionalReward.Send(u28)
        end)
        return
    end
    local Title = a1:FindFirstChild("Title")
    local v2 = if not Title then "" else string.lower(Title.Text)
    if a1:FindFirstChildWhichIsA("TextBox", true) then
        setupCodeRow(a1, v1)
        return
    end
    if string.find(v2, "invite") then
        trackClaimedState(a1, v1, "InviteFriend")
        v1.MouseButton1Click:Connect(function() -- Line: 162
            -- upvalues: DataController (upval), LocalPlayer (upval), Router (upval), hasReferredFriendInServer (upval)
            -- upvalues: Remotes (upval), u69 (upval), canSendGameInvite (upval), SocialService (upval)
            local v1 = DataController.Get(LocalPlayer, "PromotionalRewards")
            local v2 = false
            if typeof(v1) == "table" then
                v2 = v1.InviteFriend == true
            end
            if v2 then
                Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.")
                return
            end
            if hasReferredFriendInServer() then
                Remotes.Dashboard.RedeemPromotionalReward.Send("InviteFriend")
                return
            end
            if u69 then
                return
            end
            u69 = true
            v2, v1 = canSendGameInvite()
            if v2 and not v1 then
                u69 = false
                Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites aren't available for your account or device.")
                return
            end
            local success, result = pcall(function() -- Line: 187 -- upvalues: SocialService (upval), LocalPlayer (upval)
                SocialService:PromptGameInvite(LocalPlayer)
            end)
            u69 = false
            if not success then
                warn((("Rewards invite prompt failed: %*"):format(result)))
                Router.broadcastRouter("CreateMenuNotification", "Error", "Game invites are unavailable right now. Please try again.")
            end
        end)
        return
    end
    for i, j in u76 do
        if string.find(v2, j[1]) then
            trackClaimedState(a1, v1, j[2])
            u108 = j[2]
            v1.MouseButton1Click:Connect(function() -- Line: 377
                -- upvalues: u108 (val), DataController (upval), LocalPlayer (upval), Router (upval), u102 (upval)
                -- upvalues: Remotes (upval)
                local v1 = DataController.Get(LocalPlayer, "PromotionalRewards")
                local v2 = false
                if typeof(v1) == "table" then
                    v2 = v1[u108] == true
                end
                if v2 then
                    Router.broadcastRouter("CreateMenuNotification", "Error", "You have already redeemed this reward.")
                    return
                end
                v2 = u102[u108]
                if v2 and v2() then
                    return
                end
                Remotes.Dashboard.RedeemPromotionalReward.Send(u108)
            end)
            return
        end
    end
    warn((("Rewards row \"%*\" has no matching reward."):format(v2)))
end

function v1.Initialize(a1, a2) -- Line: 437
    -- upvalues: u67 (ref), u68 (ref), setupRewardRow (val), centerButtonAnchor (val), ActivateButton (val)
    u67 = a1
    u68 = a2
    u68.Visible = false
    u68.Active = true
    local Container = u68:FindFirstChild("Container")
    if Container then
        for i, v in ipairs(Container:GetChildren()) do
            if v:IsA("Frame") then
                setupRewardRow(v)
            end
        end
    end
    local Title = u68:FindFirstChild("Title")
    local Close = Title and Title:FindFirstChild("Close")
    if Close then
        centerButtonAnchor(Close)
        ActivateButton(Close)
        Close.MouseButton1Click:Connect(function() -- Line: 458 -- upvalues: u68 (upval)
            u68.Visible = false
        end)
    end
end

function v1.Start() -- Line: 466 -- upvalues: u67 (ref), AnimateDashboardCard (val), u68 (ref), MenuState (val)
    local Menu = u67:FindFirstChild("Menu")
    local Dashboard = Menu and Menu:FindFirstChild("Dashboard")
    local Rewards = Dashboard and Dashboard:FindFirstChild("Rewards")
    local Button = Rewards and Rewards:FindFirstChild("Button")
    if not Button then
        warn("Rewards is missing its dashboard button.")
        return
    end
    AnimateDashboardCard(Rewards, Button)
    Button.MouseButton1Click:Connect(function() -- Line: 479 -- upvalues: u68 (upval)
        u68.Visible = not u68.Visible
    end)
    MenuState.OnScreenChanged:Connect(function(a1, a2) -- Line: 484 -- upvalues: u68 (upval)
        if a2 ~= nil and a2 ~= "Dashboard" then
            u68.Visible = false
        end
    end)
end

return v1