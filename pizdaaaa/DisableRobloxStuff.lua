-- DisableRobloxStuff
-- Script path: DisableRobloxStuff
-- Decompile time: 35.88 ms

-- Decompiled with Potassium's decompiler.

local StarterGui = game:GetService("StarterGui");
local GuiService = game:GetService("GuiService");
game:GetService("ReplicatedStorage");
local ContextActionService = game:GetService("ContextActionService");
local TextChatService = game:GetService("TextChatService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui;
local table_freeze_ret = table.freeze({ "RbxCameraKeypress", "RbxCameraMouseWheel", "RbxLeaderboardToggle", "RbxBackpackToggle", "RbxEmoteToggle" });
local v1 = nil;
local v2 = nil;

while task.wait(0.1) and (not v1 or v2) do
    v1, v2 = pcall(function() -- Line: 30
        -- upvalues: GuiService (ref), StarterGui (ref), LocalPlayer (ref), PlayerGui (copy), table_freeze_ret (copy), ContextActionService (copy), TextChatService (ref)
        GuiService:SetGameplayPausedNotificationEnabled(false);
        GuiService:SetInspectMenuEnabled(false);

        for _, v in { "ResetButtonCallback", "ChatActive", "PointsNotificationsActive", "BadgesNotificationsActive", "TopbarEnabled", "AvatarContextMenuEnabled" } do
            StarterGui:SetCore(v, false);
        end;

        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);

        for _, child in StarterGui:GetChildren() do
            child:Destroy();
        end;

        LocalPlayer:FindFirstChildOfClass("Backpack"):Destroy();
        LocalPlayer:FindFirstChildOfClass("StarterGear"):Destroy();
        local Freecam = PlayerGui:FindFirstChild("Freecam");

        if Freecam then
            Freecam:Destroy();
        end;

        for _, v in table_freeze_ret do
            ContextActionService:UnbindAction(v);
        end;

        local ChatWindowConfiguration = TextChatService:FindFirstChild("ChatWindowConfiguration");

        if ChatWindowConfiguration then
            ChatWindowConfiguration.Enabled = false;
        end;

        local ChatInputBarConfiguration = TextChatService:FindFirstChild("ChatInputBarConfiguration");

        if ChatInputBarConfiguration then
            ChatInputBarConfiguration.Enabled = false;
        end;

        local BubbleChatConfiguration = TextChatService:FindFirstChild("BubbleChatConfiguration");

        if BubbleChatConfiguration then
            BubbleChatConfiguration.Enabled = false;
        end;

        local ChannelTabsConfiguration = TextChatService:FindFirstChild("ChannelTabsConfiguration");

        if ChannelTabsConfiguration then
            ChannelTabsConfiguration.Enabled = false;
        end;
    end);
end;

Animations = nil;

for _, child in script.Parent:GetChildren() do
    child:Destroy();
end;

script:Destroy();