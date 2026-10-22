-- ReplicatedStorage.GameClient.Gui.HUD.Chat
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Chat
-- Decompile time: 56.14 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextChatService = game:GetService("TextChatService");
local UserInputService = game:GetService("UserInputService");
local HttpService = game:GetService("HttpService");
local Roles = require(ReplicatedStorage.Shared.Roles);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local TweenInfo_new_ret = TweenInfo.new(0.1);
local TweenInfo_new_ret2 = TweenInfo.new(0.4);
local TweenInfo_new_ret3 = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);

local function IsLocalPlayerDead() -- Line: 49
    -- upvalues: Players (copy), u17 (ref)
    local Attribute = Players.LocalPlayer:GetAttribute("Team");

    if Attribute ~= "T" and Attribute ~= "CT" then
        return false;
    end;

    local v18;

    if u17 == nil then
        v18 = false;
    else
        v18 = u17 <= 0;
    end;

    return v18;
end;

function u1.FrameVisible(p19: boolean) -- Line: 59
    -- upvalues: TweenService (copy), u4 (ref), TweenInfo_new_ret (copy), TweenInfo_new_ret3 (copy)
    TweenService:Create(u4, TweenInfo_new_ret, {
        BackgroundTransparency = p19 and 0.45 or 1
    }):Play();
    u4.Messages.Visible = p19;
    u4.InputFrame.Visible = p19;

    if p19 then
        u4.InputFrame.Position = UDim2.new(0.5, 0, 1, 4);
        TweenService:Create(u4.InputFrame, TweenInfo_new_ret3, {
            Position = UDim2.new(0.5, 0, 1, -8)
        }):Play();
    end;

    u4.NewMessages.Visible = not p19;
end;

local u20 = {
    T = "rgb(234,210,139)",
    CT = "rgb(184,214,239)",
    Spectator = "rgb(255,255,255)"
};
local u21 = {};

local function PushPermanent(p22: userdata) -- Line: 87
    -- upvalues: u4 (ref), u21 (copy)
    p22.Parent = u4.Messages.List;
    table.insert(u21, p22);
    local v23 = #u21 > 128 and table.remove(u21, 1);

    if v23 then
        v23:Destroy();
    end;
end;

local function IsPrefixEnabledForPlayer(p24: userdata?) -- Line: 101
    -- upvalues: Players (copy), u14 (ref), HttpService (copy)
    if not p24 then
        return true;
    end;

    if p24 == Players.LocalPlayer and (u14 and u14.GetPlayerSettings) then
        local success, result = pcall(u14.GetPlayerSettings, u14);

        if success and (result and (result.Game and (result.Game["HUD & UI"] and result.Game["HUD & UI"]["Chat Prefix"] ~= nil))) then
            return result.Game["HUD & UI"]["Chat Prefix"] ~= false;
        end;
    end;

    local Attribute = p24:GetAttribute("PlayerSettings");

    if typeof(Attribute) == "string" then
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute);

        if success and typeof(result) == "table" then
            local Game = result.Game;

            if typeof(Game) == "table" then
                local v25 = Game["HUD & UI"];

                if typeof(v25) == "table" and v25["Chat Prefix"] ~= nil then
                    local v26;

                    if v25["Chat Prefix"] == false then
                        v26 = false;
                    else
                        v26 = v25["Chat Prefix"] ~= 0;
                    end;

                    return v26;
                end;
            end;
        end;
    end;

    return true;
end;

function u1.NewMessage(p27: any, p28: string?) -- Line: 135
    -- upvalues: u1 (copy), u8 (ref), u20 (copy), Players (copy), Roles (copy), IsPrefixEnabledForPlayer (copy), u4 (ref), u21 (copy), TweenService (copy), TweenInfo_new_ret2 (copy)
    local u29 = u1.newMessage();
    local v30 = u1.newMessage();
    local v31 = u8.Teams[p27.Team];
    local v32 = u20[v31] or "rgb(255,255,255)";
    local v33 = p28 == "SYSTEM" and "<font color=\"rgb(255,255,255)\">[SERVER] </font>" or (p28 == "DEAD" and "<font color=\"rgb(198,203,208)\">*DEAD*</font><font color=\"rgb(255,255,255)\"> </font>" or (p28 ~= "TEAM" and "<font color=\"rgb(255,255,255)\">[ALL] </font>" or (v31 == "Spectator" and "" or `<font color="{v32}">[{v31}] </font>`)));
    local v34 = p27.Player or (p27.UserId and Players:GetPlayerByUserId(p27.UserId) or Players:FindFirstChild(p27.Sender));
    local UserId = p27.UserId;

    if not UserId then
        if v34 then
            UserId = v34.UserId;
        else
            UserId = v34;
        end;
    end;

    local v35 = "";

    if UserId then
        UserId = Roles.GetChatPrefix(UserId);
    end;

    if UserId and IsPrefixEnabledForPlayer(v34) then
        v35 = `<font color="{UserId.Color}">{UserId.Tag}</font><font color="rgb(255,255,255)"> </font>`;
    end;

    local v36 = tostring(p27.Sender):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v37 = tostring(p27.Text);

    if p28 == "SYSTEM" then
        v37 = v37:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    end;

    local v38 = `{v33}{v35}<font color="{v32}">{v36}</font>{v31 == "Spectator" and "<font color=\"rgb(255,255,255)\"> </font><font color=\"rgb(198,203,208)\">[SPEC]</font>" or ""}<font color="rgb(255,255,255)">: </font><font color="rgb(255,255,255)">{v37}</font>`;
    u29.Text = v38;
    v30.Text = v38;
    u29.Parent = u4.NewMessages;
    v30.Parent = u4.Messages.List;
    table.insert(u21, v30);
    local v39 = #u21 > 128 and table.remove(u21, 1);

    if v39 then
        v39:Destroy();
    end;

    TweenService:Create(u29, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    TweenService:Create(v30, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    task.delay(15, function() -- Line: 188
        -- upvalues: TweenService (ref), u29 (copy), TweenInfo_new_ret2 (ref)
        TweenService:Create(u29, TweenInfo_new_ret2, {
            TextTransparency = 1
        }):Play();
        task.wait(1);
        u29:Destroy();
    end);
end;

function u1.LocalMessage(p40: string, p41: number?) -- Line: 197
    -- upvalues: u1 (copy), u4 (ref), u21 (copy), TweenService (copy), TweenInfo_new_ret2 (copy)
    local u42 = u1.newMessage();
    local v43 = u1.newMessage();
    local v44 = `<font color="rgb(159,232,86)">+${p41} </font><font color="rgb(255,255,255)">{p40}</font>`;
    u42.Text = v44;
    v43.Text = v44;
    u42.Parent = u4.NewMessages;
    v43.Parent = u4.Messages.List;
    table.insert(u21, v43);
    local v45 = #u21 > 128 and table.remove(u21, 1);

    if v45 then
        v45:Destroy();
    end;

    TweenService:Create(u42, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    TweenService:Create(v43, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    task.delay(15, function() -- Line: 218
        -- upvalues: TweenService (ref), u42 (copy), TweenInfo_new_ret2 (ref)
        TweenService:Create(u42, TweenInfo_new_ret2, {
            TextTransparency = 1
        }):Play();
        task.wait(1);
        u42:Destroy();
    end);
end;

function u1.JoinMessage(p46: string, p47: string) -- Line: 227
    -- upvalues: u1 (copy), u4 (ref), u21 (copy), TweenService (copy), TweenInfo_new_ret2 (copy)
    local u48 = u1.newMessage();
    local v49 = u1.newMessage();
    local v50 = `<font color="rgb(215,215,215)">Player </font><font color="rgb(215,215,215)">{p46} </font><font color="rgb(215,215,215)">{p47}</font>`;
    u48.Text = v50;
    v49.Text = v50;
    u48.Parent = u4.NewMessages;
    v49.Parent = u4.Messages.List;
    table.insert(u21, v49);
    local v51 = #u21 > 128 and table.remove(u21, 1);

    if v51 then
        v51:Destroy();
    end;

    TweenService:Create(u48, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    TweenService:Create(v49, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    task.delay(15, function() -- Line: 248
        -- upvalues: TweenService (ref), u48 (copy), TweenInfo_new_ret2 (ref)
        TweenService:Create(u48, TweenInfo_new_ret2, {
            TextTransparency = 1
        }):Play();
        task.wait(1);
        u48:Destroy();
    end);
end;

function u1.ContainerMessage(p52) -- Line: 257
    -- upvalues: u1 (copy), u9 (ref), u12 (ref), u11 (ref), u10 (ref), u4 (ref), u21 (copy), TweenService (copy), TweenInfo_new_ret2 (copy)
    local u53 = u1.newMessage();
    local v54 = u1.newMessage();
    local v55, v56 = unpack(p52.Text:split(":"));
    local v57, v58 = unpack(v55:split("_"));
    local v59 = u9.GetCategory(v57) or u12.Get(v57);
    local v60 = u9.GetItem(v57, v58) or u11.GetWeaponSkin(v57, v58);
    local v61 = u10[v60.Rarity];
    local v62 = `<font color="rgb(85,170,255)">{p52.Sender}</font><font color="rgb(215,215,215)"> has opened a container and found: </font><font color="rgb({math.round(v61.R * 255)},{math.round(v61.G * 255)},{math.round(v61.B * 255)})">{v56 == "KillTrack" and "KillTrackᴷ⁺ " or ""}{v59.DisplayName or v57} | {v60.DisplayName or v58}</font>`;
    u53.Text = v62;
    v54.Text = v62;
    u53.Parent = u4.NewMessages;
    v54.Parent = u4.Messages.List;
    table.insert(u21, v54);
    local v63 = #u21 > 128 and table.remove(u21, 1);

    if v63 then
        v63:Destroy();
    end;

    TweenService:Create(u53, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    TweenService:Create(v54, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    task.delay(15, function() -- Line: 289
        -- upvalues: TweenService (ref), u53 (copy), TweenInfo_new_ret2 (ref)
        TweenService:Create(u53, TweenInfo_new_ret2, {
            TextTransparency = 1
        }):Play();
        task.wait(1);
        u53:Destroy();
    end);
end;

function u1.JoinTeamMessage(p64: string, p65: string) -- Line: 298
    -- upvalues: u1 (copy), u4 (ref), u21 (copy), TweenService (copy), TweenInfo_new_ret2 (copy)
    local u66 = u1.newMessage();
    local v67 = u1.newMessage();
    local v68 = "";

    if p65 == "T" then
        v68 = `<font color="rgb(228,175,58)">{p64} </font><font color="rgb(228,175,58)">is joining the </font><font color="rgb(228,175,58)">Terrorists</font>`;
    elseif p65 == "CT" then
        v68 = `<font color="rgb(95,153,217)">{p64} </font><font color="rgb(95,153,217)">is joining the </font><font color="rgb(95,153,217)">Counter-Terrorists</font>`;
    elseif p65 == "Spectator" then
        v68 = `<font color="rgb(215,215,215)">{p64} </font><font color="rgb(215,215,215)">is joining the </font><font color="rgb(215,215,215)">Spectators</font>`;
    end;

    u66.Text = v68;
    v67.Text = v68;
    u66.Parent = u4.NewMessages;
    v67.Parent = u4.Messages.List;
    table.insert(u21, v67);
    local v69 = #u21 > 128 and table.remove(u21, 1);

    if v69 then
        v69:Destroy();
    end;

    TweenService:Create(u66, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    TweenService:Create(v67, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    task.delay(15, function() -- Line: 327
        -- upvalues: TweenService (ref), u66 (copy), TweenInfo_new_ret2 (ref)
        TweenService:Create(u66, TweenInfo_new_ret2, {
            TextTransparency = 1
        }):Play();
        task.wait(1);
        u66:Destroy();
    end);
end;

function u1.ChatConnect(u70) -- Line: 336
    -- upvalues: u4 (ref), Players (copy), u17 (ref), u1 (copy), u3 (ref), UserInputService (copy)
    local TextBox = u4.InputFrame.TextBox;
    u4.Messages.List.CanvasPosition = Vector2.new(0, 9999);

    if u70 == "ALL" then
        local Attribute = Players.LocalPlayer:GetAttribute("Team");
        local v71;

        if (Attribute == "T" or Attribute == "CT") and u17 ~= nil then
            v71 = u17 <= 0;
        else
            v71 = false;
        end;

        TextBox.PlaceholderText = v71 and "Say to dead" or "Say to all";
    end;

    if u70 == "TEAM" then
        local Attribute = Players.LocalPlayer:GetAttribute("Team");
        local v72;

        if (Attribute == "T" or Attribute == "CT") and u17 ~= nil then
            v72 = u17 <= 0;
        else
            v72 = false;
        end;

        TextBox.PlaceholderText = v72 and "Say to dead" or "Say to team";
    end;

    local function Submit() -- Line: 352
        -- upvalues: TextBox (copy), u1 (ref), Players (ref), u17 (ref), u70 (copy)
        if TextBox.Text:gsub(" ", "") == "" then
            TextBox.Text = "";
            u1.SetVisible(false);

            return;
        end;

        local Text = TextBox.Text;
        TextBox.Text = "";
        u1.SetVisible(false);
        task.spawn(function() -- Line: 363
            -- upvalues: Players (ref), u17 (ref), u1 (ref), Text (copy), u70 (ref)
            local Attribute = Players.LocalPlayer:GetAttribute("Team");
            local v73;

            if (Attribute == "T" or Attribute == "CT") and u17 ~= nil then
                v73 = u17 <= 0;
            else
                v73 = false;
            end;

            if v73 then
                u1._DeadChannel:SendAsync(Text);

                return;
            end;

            if u70 == "ALL" then
                u1._AllChannel:SendAsync(Text);

                return;
            end;

            if u70 == "TEAM" then
                local v74 = Players.LocalPlayer:GetAttribute("Team") or "Spectator";
                local v75 = u1._TeamChannels[v74];

                if v75 then
                    v75:SendAsync(Text);
                end;
            end;
        end);
    end;

    u3:Add("FocusLost", TextBox.FocusLost:Connect(function(p76, u77) -- Line: 376
        -- upvalues: Players (ref), u4 (ref), u3 (ref), UserInputService (ref), TextBox (copy), u1 (ref), Submit (copy)
        if p76 then
            Submit();

            return;
        end;

        if u77 and (u77.UserInputType == Enum.UserInputType.MouseButton1 or u77.UserInputType == Enum.UserInputType.Touch) then
            for _, v in Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(u77.Position.X, u77.Position.Y) do
                if v == u4.Messages or v:IsDescendantOf(u4.Messages) then
                    u3:Add("ChatRefocus", UserInputService.InputEnded:Connect(function(p78) -- Line: 381
                        -- upvalues: u77 (copy), u3 (ref), u4 (ref), TextBox (ref)
                        if p78.UserInputType ~= u77.UserInputType then
                            return;
                        end;

                        u3:Remove("ChatRefocus");

                        if u4.InputFrame.Visible then
                            TextBox:CaptureFocus();
                        end;
                    end));

                    return;
                end;
            end;
        end;

        task.delay(0.1, function() -- Line: 398
            -- upvalues: u4 (ref), u1 (ref)
            if u4 and (u4.InputFrame and u4.InputFrame.Visible) then
                u1.SetVisible(false);
            end;
        end);
    end));
    local Title = u4.InputFrame:FindFirstChild("Title");

    if Title then
        u3:Add("SendButton_Click", Title.InputBegan:Connect(function(p79) -- Line: 410
            -- upvalues: Submit (copy)
            if p79.UserInputType == Enum.UserInputType.MouseButton1 or p79.UserInputType == Enum.UserInputType.Touch then
                Submit();
            end;
        end));
    end;

    task.delay(0.1, function() -- Line: 417
        -- upvalues: TextBox (copy)
        TextBox:CaptureFocus();
    end);
end;

function u1.SetVisible(p80: boolean, p81: string) -- Line: 422
    -- upvalues: u1 (copy), u15 (ref), u7 (ref), u3 (ref)
    if p80 and (not u1._CanChat or u15() == "Console") then
        return;
    end;

    u7.SetFramePriority("Chat", p80);

    if p80 then
        u1.FrameVisible(p80);
        u1.ChatConnect(p81, p81);

        return;
    end;

    u1.FrameVisible(p80);
    u3:Cleanup();
end;

function u1.SetBuymenuOpen(p82: boolean) -- Line: 453
    -- upvalues: u4 (ref)
    u4.NewMessages.Interactable = not p82;
    u4.Messages.List.Interactable = not p82;
end;

function u1.Init(p83) -- Line: 460
    -- upvalues: u2 (ref), u14 (ref), u5 (ref), u3 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u11 (ref), u12 (ref), u10 (ref), u13 (ref), u15 (ref), u16 (ref)
    u2 = p83:GetModule("Gui");
    u14 = u2.GetComponent("Settings");
    u5 = p83:GetModule("Network");
    u3 = p83:GetModule("Maid").new();
    u6 = p83:GetModule("CameraController");
    u7 = p83:GetModule("BindsController");
    u8 = p83:GetModule("Enums");
    u9 = p83:GetModule("ItemManager");
    u11 = p83:GetModule("SkinManager");
    u12 = p83:GetModule("WeaponManager");
    u10 = p83:GetModule("RarityColors");
    u13 = p83:GetModule("PlayerColor");
    u15 = p83:GetModule("GetUserPlatform");
    u16 = u15() == "Mobile";
end;

function u1.Start(p84) -- Line: 477
    -- upvalues: Players (copy), u17 (ref), u4 (ref), u1 (copy), u15 (ref), UserInputService (copy), TextChatService (copy), u8 (ref), u5 (ref)
    local UserId = Players.LocalPlayer.UserId;
    p84:GetModule("Entities").OnHealthUpdate:Connect(function(p85, p86) -- Line: 480
        -- upvalues: UserId (copy), u17 (ref)
        if p85 == UserId then
            u17 = p86;
        end;
    end);
    u4 = u1.new();
    u4.Visible = u15() ~= "Console";
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 489
        -- upvalues: u4 (ref), u15 (ref)
        u4.Visible = u15() ~= "Console";
    end);
    local AllChat = TextChatService:WaitForChild("AllChat");
    local v87 = {
        T = TextChatService:WaitForChild("Team_T"),
        CT = TextChatService:WaitForChild("Team_CT"),
        Spectator = TextChatService:WaitForChild("Team_Spectator")
    };
    local DeadChat = TextChatService:WaitForChild("DeadChat");
    u1._AllChannel = AllChat;
    u1._TeamChannels = v87;
    u1._DeadChannel = DeadChat;
    u1._CanChat = false;
    task.spawn(function() -- Line: 506
        -- upvalues: TextChatService (ref), Players (ref), u1 (ref)
        local success, result = pcall(function() -- Line: 507
            -- upvalues: TextChatService (ref), Players (ref)
            return TextChatService:CanUserChatAsync(Players.LocalPlayer.UserId);
        end);
        u1._CanChat = success and result;
    end);
    TextChatService.MessageReceived:Connect(function(p88) -- Line: 514
        -- upvalues: Players (ref), u1 (ref), u8 (ref)
        if p88.Status ~= Enum.TextChatMessageStatus.Success then
            return;
        end;

        if not (p88.TextSource and p88.TextChannel) then
            return;
        end;

        if not p88.Text or p88.Text:gsub("%s+", "") == "" then
            return;
        end;

        local Name = p88.TextChannel.Name;
        local v89 = Name:sub(1, 5) == "Team_";
        local v90 = Name == "DeadChat";

        if Name ~= "AllChat" and not (v89 or v90) then
            return;
        end;

        local PlayerByUserId = Players:GetPlayerByUserId(p88.TextSource.UserId);

        if not PlayerByUserId then
            return;
        end;

        local v91 = PlayerByUserId:GetAttribute("Team") or "Spectator";
        u1.NewMessage({
            Sender = PlayerByUserId.Name,
            Player = PlayerByUserId,
            UserId = PlayerByUserId.UserId,
            Team = u8.TeamsNum[v91] or u8.TeamsNum.Spectator,
            Text = p88.Text
        }, v90 and "DEAD" or (v89 and "TEAM" or nil));
    end);
    u5.Gui.NewMessage.On(function(p92) -- Line: 539
        -- upvalues: u1 (ref)
        u1.NewMessage(p92, "SYSTEM");
    end);
    u5.Gui.NewAwardMessage.On(function(p93, p94, p95) -- Line: 543
        -- upvalues: u1 (ref), u8 (ref)
        if p95 then
            u1.LocalMessage(u8.Awards[p94] .. " " .. u8.Weapons[p95], p93);

            return;
        end;

        u1.LocalMessage(u8.Awards[p94], p93);
    end);
    u5.Gui.NewContainerMessage.On(function(p96) -- Line: 551
        -- upvalues: u1 (ref)
        u1.ContainerMessage(p96);
    end);
    u5.Gui.NewMessageTeam.On(function(p97) -- Line: 556
        -- upvalues: u1 (ref), u8 (ref)
        if p97.Text == "" then
            u1.JoinTeamMessage(p97.Sender, u8.Teams[p97.Team]);

            return;
        end;

        u1.JoinMessage(p97.Sender, p97.Text);
    end);
end;

function u1.new() -- Line: 566
    -- upvalues: u16 (ref), u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "chatski";
    Frame.AnchorPoint = Vector2.new(0, 1);
    Frame.BackgroundTransparency = 1;
    Frame.Position = u16 and UDim2.new(0, 16, 0.62, 0) or UDim2.new(0, 16, 0.92, 0);
    Frame.Size = u16 and UDim2.fromScale(0.1, 0.28) or UDim2.fromScale(0.1, 0.4);
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "NewMessages";
    ScrollingFrame.Active = true;
    ScrollingFrame.AnchorPoint = Vector2.new(0, 0.5);
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.Position = UDim2.new(0, -8, 0.5, 0);
    ScrollingFrame.ScrollBarThickness = 8;
    ScrollingFrame.Size = UDim2.new(1, -8, 1, -8);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    UIListLayout.Parent = ScrollingFrame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 4);
    UIPadding.PaddingLeft = UDim.new(0, 4);
    UIPadding.PaddingRight = UDim.new(0, 4);
    UIPadding.PaddingTop = UDim.new(0, 4);
    UIPadding.Parent = ScrollingFrame;
    ScrollingFrame.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = u16 and 1.6 or 1.4;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "InputFrame";
    Frame2.AnchorPoint = Vector2.new(0.5, 1);
    Frame2.BackgroundColor3 = Color3.new();
    Frame2.BackgroundTransparency = 0.35;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.ClipsDescendants = true;
    Frame2.Position = UDim2.new(0.5, 0, 1, -8);
    Frame2.Size = UDim2.new(1, -16, 0.125, 0);
    Frame2.Visible = false;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingBottom = UDim.new(0.22, 0);
    UIPadding2.PaddingLeft = UDim.new(0, 8);
    UIPadding2.PaddingRight = UDim.new(0, 8);
    UIPadding2.PaddingTop = UDim.new(0.22, 0);
    UIPadding2.Parent = Frame2;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.AnchorPoint = Vector2.new(0, 0.5);
    TextBox.BackgroundTransparency = 1;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.PlaceholderColor3 = Color3.new(1, 1, 1);
    TextBox.PlaceholderText = "Say to team";
    TextBox.Position = UDim2.fromScale(0, 0.5);
    TextBox.Size = UDim2.fromScale(0.85, 1);
    TextBox.Text = "";
    TextBox.TextColor3 = Color3.new(1, 1, 1);
    TextBox.TextScaled = true;
    TextBox.TextTransparency = 0.5;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(1, 0.5);
    TextLabel.Size = UDim2.fromScale(0.15, 1);
    TextLabel.Text = "SEND";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.35;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Messages";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BackgroundTransparency = 0.35;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.ClipsDescendants = true;
    Frame3.Position = UDim2.new(0.5, 0, 0, 8);
    Frame3.Size = UDim2.new(1, -16, 0.875, -24);
    Frame3.Visible = false;
    local ScrollingFrame2 = Instance.new("ScrollingFrame");
    ScrollingFrame2.Name = "List";
    ScrollingFrame2.Active = true;
    ScrollingFrame2.AnchorPoint = Vector2.new(0.5, 0.5);
    ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame2.BackgroundColor3 = Color3.new();
    ScrollingFrame2.BackgroundTransparency = 0.5;
    ScrollingFrame2.BorderColor3 = Color3.new();
    ScrollingFrame2.BorderSizePixel = 0;
    ScrollingFrame2.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame2.CanvasSize = UDim2.new();
    ScrollingFrame2.Position = UDim2.fromScale(0.5, 0.5);
    ScrollingFrame2.ScrollBarThickness = 8;
    ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame2.Size = UDim2.new(1, -8, 1, -8);
    ScrollingFrame2.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    local UIPadding3 = Instance.new("UIPadding");
    UIPadding3.Name = "UIPadding";
    UIPadding3.PaddingBottom = UDim.new(0, 4);
    UIPadding3.PaddingLeft = UDim.new(0, 4);
    UIPadding3.PaddingRight = UDim.new(0, 4);
    UIPadding3.PaddingTop = UDim.new(0, 4);
    UIPadding3.Parent = ScrollingFrame2;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout2.Padding = UDim.new(0, 2);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.Parent = ScrollingFrame2;
    ScrollingFrame2.Parent = Frame3;
    Frame3.Parent = Frame;
    Frame.Parent = u2.Handler.HUD;

    return Frame;
end;

function u1.newMessage() -- Line: 725
    -- upvalues: u16 (ref)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AutomaticSize = Enum.AutomaticSize.Y;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.RichText = true;
    TextLabel.Size = UDim2.fromScale(1, 0);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextSize = u16 and 13 or 20;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextTransparency = 1;

    return TextLabel;
end;

return u1;