-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Home
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Home
-- Decompile time: 43.90 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local TeleportService = game:GetService("TeleportService");
local LocalPlayer = Players.LocalPlayer;
local GameStats = game:GetService("ReplicatedStorage").GameStats;
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
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local TweenInfo_new_ret = TweenInfo.new(0.4);
local TweenInfo_new_ret2 = TweenInfo.new(0.3);
local TweenInfo_new_ret3 = TweenInfo.new(0.25);
local TweenInfo_new_ret4 = TweenInfo.new(8, Enum.EasingStyle.Quart);
local TweenInfo_new_ret5 = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local PolicyService = game:GetService("PolicyService");
local u23 = nil;

if game:GetService("RunService"):IsStudio() then
    u23 = {
        ArePaidRandomItemsRestricted = false
    };
else
    task.spawn(function() -- Line: 48
        -- upvalues: PolicyService (copy), LocalPlayer (copy), u23 (ref)
        local success, result = pcall(function() -- Line: 49
            -- upvalues: PolicyService (ref), LocalPlayer (ref)
            return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer);
        end);
        u23 = success and result and result or {
            ArePaidRandomItemsRestricted = true
        };
    end);
end;

local function CanBuyCredits() -- Line: 58
    -- upvalues: u23 (ref)
    local v24 = 0;

    while not u23 and v24 < 2 do
        task.wait(0.05);
        v24 = v24 + 0.05;
    end;

    if u23 then
        return u23.ArePaidRandomItemsRestricted == false;
    end;

    return false;
end;

local u25 = nil;
local u26 = nil;
local u27 = nil;
local u28 = {};
local u29 = 1;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = nil;
local u36 = nil;
local u37 = nil;
local u38 = nil;
local u39 = nil;
local u40 = nil;
local u41 = 0;

function u1.DrawRewards() -- Line: 87
    -- upvalues: u5 (ref), u21 (ref), u30 (ref), u39 (ref), TweenService (copy), TweenInfo_new_ret3 (copy)
    u5.new("Rewards", u21.Main);

    for _, v in ipairs({ {
            name = "Promocodes",
            tab = "Promocodes"
        }, {
            name = "Challenges",
            tab = "Challenges"
        }, {
            name = "PlaytimeRewards",
            tab = "Playtime Rewards"
        } }) do
        local u42 = u21.Main.Buttons:FindFirstChild(v.name);

        if u42 then
            local function openTab() -- Line: 100
                -- upvalues: u30 (ref), u39 (ref), v (copy)
                u30.Play("UI.submenu_click");

                if u39 and u39.Activate then
                    u39.Activate(v.tab);
                end;
            end;

            u42.MouseEnter:Connect(function() -- Line: 107
                -- upvalues: u30 (ref), TweenService (ref), u42 (copy), TweenInfo_new_ret3 (ref)
                u30.Play("UI.submenu_dropdown_rollover");
                TweenService:Create(u42, TweenInfo_new_ret3, {
                    BackgroundColor3 = Color3.fromRGB(65, 66, 75)
                }):Play();
                TweenService:Create(u42.RightArrow, TweenInfo_new_ret3, {
                    Position = UDim2.fromScale(0.97, 0.5)
                }):Play();
                TweenService:Create(u42.ImageLabel, TweenInfo_new_ret3, {
                    ImageColor3 = Color3.fromRGB(131, 216, 255)
                }):Play();
            end);
            u42.MouseLeave:Connect(function() -- Line: 114
                -- upvalues: TweenService (ref), u42 (copy), TweenInfo_new_ret3 (ref)
                TweenService:Create(u42, TweenInfo_new_ret3, {
                    BackgroundColor3 = Color3.fromRGB(50, 51, 57)
                }):Play();
                TweenService:Create(u42.RightArrow, TweenInfo_new_ret3, {
                    Position = UDim2.fromScale(0.95, 0.5)
                }):Play();
                TweenService:Create(u42.ImageLabel, TweenInfo_new_ret3, {
                    ImageColor3 = Color3.fromRGB(236, 236, 236)
                }):Play();
            end);
            u42.MouseButton1Click:Connect(openTab);

            if u42:FindFirstChild("RightArrow") then
                u42.RightArrow.MouseButton1Click:Connect(openTab);
            end;
        end;
    end;

    local function openRewards() -- Line: 126
        -- upvalues: u30 (ref), u39 (ref)
        u30.Play("UI.submenu_click");

        if u39 and u39.Activate then
            u39.Activate();
        end;
    end;

    u21.Main.Title.Title.MouseEnter:Connect(function() -- Line: 133
        -- upvalues: u30 (ref), TweenService (ref), u21 (ref), TweenInfo_new_ret3 (ref)
        u30.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u21.Main.Title.Title, TweenInfo_new_ret3, {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play();
    end);
    u21.Main.Title.Title.MouseLeave:Connect(function() -- Line: 138
        -- upvalues: TweenService (ref), u21 (ref), TweenInfo_new_ret3 (ref)
        TweenService:Create(u21.Main.Title.Title, TweenInfo_new_ret3, {
            TextColor3 = Color3.fromRGB(236, 236, 236)
        }):Play();
    end);
    u21.Main.Title.Title.MouseButton1Click:Connect(openRewards);
end;

function u1.DrawBundle() -- Line: 145
    -- upvalues: u5 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u30 (ref), TweenService (copy), TweenInfo_new_ret (copy), u37 (ref), LocalPlayer (copy), u38 (ref), u39 (ref), CanBuyCredits (copy), u28 (ref), u35 (ref), u29 (ref), u1 (copy), TweenInfo_new_ret3 (copy)
    u5.new("Bundle", u16.Main);
    u5.new("Balisong", u17.Main);
    u5.new("Upgrader", u18.Main);
    u5.new("Plus", u19.Main);
    u16.Main.Main.Icon.MouseEnter:Connect(function() -- Line: 152
        -- upvalues: u30 (ref), TweenService (ref), u16 (ref), TweenInfo_new_ret (ref)
        u30.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u16.Main.Main.Icon, TweenInfo_new_ret, {
            Size = UDim2.fromScale(0.82, 0.82)
        }):Play();
    end);
    u16.Main.Main.Icon.MouseLeave:Connect(function() -- Line: 157
        -- upvalues: TweenService (ref), u16 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u16.Main.Main.Icon, TweenInfo_new_ret, {
            Size = UDim2.fromScale(0.75, 0.75)
        }):Play();
    end);
    u16.Main.Main.Icon.MouseButton1Click:Connect(function() -- Line: 161
        -- upvalues: u37 (ref)
        u37.Activate();
    end);
    u17.Main.Main.Icon.MouseEnter:Connect(function() -- Line: 166
        -- upvalues: u30 (ref), TweenService (ref), u17 (ref), TweenInfo_new_ret (ref)
        u30.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u17.Main.Main.Icon, TweenInfo_new_ret, {
            Size = UDim2.fromScale(1, 1)
        }):Play();
    end);
    u17.Main.Main.Icon.MouseLeave:Connect(function() -- Line: 171
        -- upvalues: TweenService (ref), u17 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u17.Main.Main.Icon, TweenInfo_new_ret, {
            Size = UDim2.fromScale(0.9, 0.9)
        }):Play();
    end);

    local function goToBalisong() -- Line: 175
        -- upvalues: u30 (ref), u37 (ref), LocalPlayer (ref)
        u30.Play("UI.submenu_click");

        if u37 and u37.OpenCreditsTab then
            u37.OpenCreditsTab();
        end;

        pcall(function() -- Line: 180
            -- upvalues: LocalPlayer (ref)
            game:GetService("MarketplaceService"):PromptProductPurchase(LocalPlayer, 3714857106);
        end);
    end;

    u17.Main.Main.Icon.MouseButton1Click:Connect(goToBalisong);
    u17.Main.Main.Title.MouseButton1Click:Connect(goToBalisong);
    u17.Main.Main.Tip.MouseButton1Click:Connect(goToBalisong);
    u17.Main.Main.Frame.Blur.MouseButton1Click:Connect(goToBalisong);
    u18.Main.Main.Icon.MouseEnter:Connect(function() -- Line: 191
        -- upvalues: u30 (ref), TweenService (ref), u18 (ref), TweenInfo_new_ret (ref)
        u30.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u18.Main.Main.Icon, TweenInfo_new_ret, {
            Size = UDim2.fromScale(1, 1)
        }):Play();
    end);
    u18.Main.Main.Icon.MouseLeave:Connect(function() -- Line: 196
        -- upvalues: TweenService (ref), u18 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u18.Main.Main.Icon, TweenInfo_new_ret, {
            Size = UDim2.fromScale(0.9, 0.9)
        }):Play();
    end);

    local function goToFuser() -- Line: 200
        -- upvalues: u30 (ref), u38 (ref)
        u30.Play("UI.submenu_click");

        if u38 and u38.Activate then
            u38.Activate("Fuser");
        end;
    end;

    u18.Main.Main.Icon.MouseButton1Click:Connect(goToFuser);
    u18.Main.Main.Title.MouseButton1Click:Connect(goToFuser);
    u18.Main.Main.Tip.MouseButton1Click:Connect(goToFuser);
    u18.Main.Main.Frame.Blur.MouseButton1Click:Connect(goToFuser);
    u19.Main.Main.Icon.MouseEnter:Connect(function() -- Line: 212
        -- upvalues: u30 (ref), TweenService (ref), u19 (ref), TweenInfo_new_ret (ref)
        u30.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u19.Main.Main.Icon, TweenInfo_new_ret, {
            Size = UDim2.fromScale(0.72, 0.72)
        }):Play();
    end);
    u19.Main.Main.Icon.MouseLeave:Connect(function() -- Line: 217
        -- upvalues: TweenService (ref), u19 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u19.Main.Main.Icon, TweenInfo_new_ret, {
            Size = UDim2.fromScale(0.65, 0.65)
        }):Play();
    end);

    local function goToPlus() -- Line: 221
        -- upvalues: u30 (ref), u39 (ref)
        u30.Play("UI.submenu_click");
        u39.Activate("Roblox Plus");
    end;

    u19.Main.Main.Icon.MouseButton1Click:Connect(goToPlus);
    u19.Main.Main.Title.MouseButton1Click:Connect(goToPlus);
    u19.Main.Main.Tip.MouseButton1Click:Connect(goToPlus);
    u19.Main.Main.Frame.Blur.MouseButton1Click:Connect(goToPlus);
    local v43 = CanBuyCredits();
    u28 = {};
    local UnixTimestamp = DateTime.now().UnixTimestamp;

    for i, v in u35 do
        if UnixTimestamp >= v.Date.From and v.Date.To > UnixTimestamp then
            table.insert(u28, {
                id = "Bundle",
                blurName = "Bundle",
                frame = u16,
                indicatorName = v.Name,
                bundle = i
            });
        end;
    end;

    if #u28 == 0 then
        u16.Visible = false;
        u5.Enabled("Bundle", false);
    end;

    if v43 then
        table.insert(u28, {
            id = "Balisong",
            blurName = "Balisong",
            indicatorName = "Balisong",
            frame = u17
        });
    else
        u17.Visible = false;
        u5.Enabled("Balisong", false);
    end;

    table.insert(u28, {
        id = "Plus",
        blurName = "Plus",
        indicatorName = "Plus",
        frame = u19
    });
    table.insert(u28, {
        id = "Upgrader",
        blurName = "Upgrader",
        indicatorName = "Upgrader",
        frame = u18
    });
    local v44 = {};

    for _, v in ipairs(u28) do
        if not v44[v.frame] then
            v44[v.frame] = true;
            local Buttons = v.frame.Main.Buttons;
            Buttons.Left.MouseButton1Click:Connect(function() -- Line: 294
                -- upvalues: u30 (ref), u29 (ref), u28 (ref), u1 (ref)
                u30.Play("UI.submenu_click");
                u1.SetPage(u29 == 1 and #u28 or u29 - 1, -1);
            end);
            Buttons.Right.MouseButton1Click:Connect(function() -- Line: 300
                -- upvalues: u30 (ref), u29 (ref), u28 (ref), u1 (ref)
                u30.Play("UI.submenu_click");
                u1.SetPage(u29 == #u28 and 1 or u29 + 1, 1);
            end);

            for i, v2 in ipairs(u28) do
                local u45 = Buttons:FindFirstChild(v2.indicatorName) or u1.bundleButton(Buttons, i, v2.indicatorName);
                u45.LayoutOrder = i;
                u45.MouseEnter:Connect(function() -- Line: 313
                    -- upvalues: TweenService (ref), u45 (ref), TweenInfo_new_ret3 (ref)
                    TweenService:Create(u45.Bar, TweenInfo_new_ret3, {
                        BackgroundTransparency = 0.4
                    }):Play();
                end);
                u45.MouseLeave:Connect(function() -- Line: 317
                    -- upvalues: TweenService (ref), u45 (ref), TweenInfo_new_ret3 (ref)
                    TweenService:Create(u45.Bar, TweenInfo_new_ret3, {
                        BackgroundTransparency = 0.2
                    }):Play();
                end);
                u45.MouseButton1Click:Connect(function() -- Line: 321
                    -- upvalues: u30 (ref), u1 (ref), i (copy), u29 (ref)
                    u30.Play("UI.submenu_click");
                    u1.SetPage(i, i < u29 and -1 or 1);
                end);
            end;

            if not v43 then
                local Balisong = Buttons:FindFirstChild("Balisong");

                if Balisong then
                    Balisong:Destroy();
                end;
            end;
        end;
    end;

    u1.SetPage(1, 1);
end;

function u1.SetPage(p46, p47) -- Line: 336
    -- upvalues: u1 (copy), u28 (ref), u29 (ref), u5 (ref), CanBuyCredits (copy), u17 (ref), u25 (ref), TweenService (copy), TweenInfo_new_ret5 (copy), u27 (ref), TweenInfo_new_ret4 (copy), u26 (ref)
    u1.ClearBundle();

    if #u28 == 0 then
        return;
    end;

    u29 = #u28 < p46 and 1 or p46;
    local v48 = u28[u29];

    for _, v in ipairs(u28) do
        local v49 = v.frame == v48.frame;
        v.frame.Visible = v49;
        u5.Enabled(v.blurName, v49);
    end;

    if not CanBuyCredits() and u17 then
        u17.Visible = false;
        u5.Enabled("Balisong", false);
    end;

    if v48.id == "Bundle" then
        u25 = v48.bundle;
        u1.UpdateBundle();
    end;

    local Icon = v48.frame.Main.Main.Icon;
    local v50 = v48.id == "Bundle" and 0.75 or (v48.id == "Plus" and 0.65 or 0.9);
    Icon.Size = UDim2.fromScale(v50 - 0.08, v50 - 0.08);
    Icon.Position = UDim2.fromScale(0.5 + 0.06 * p47, 0.5);
    Icon.ImageTransparency = 1;
    TweenService:Create(Icon, TweenInfo_new_ret5, {
        ImageTransparency = 0,
        Size = UDim2.fromScale(v50, v50),
        Position = UDim2.fromScale(0.5, 0.5)
    }):Play();

    for _, v in ipairs(u28) do
        local Buttons = v.frame.Main.Buttons;

        for _, v2 in ipairs(u28) do
            local v51 = Buttons:FindFirstChild(v2.indicatorName);

            if v51 and v51:FindFirstChild("Bar") then
                v51.Bar.Size = UDim2.fromScale(0, 1);
            end;
        end;
    end;

    local v52 = v48.frame.Main.Buttons:FindFirstChild(v48.indicatorName);

    if v52 and v52:FindFirstChild("Bar") then
        u27 = TweenService:Create(v52.Bar, TweenInfo_new_ret4, {
            Size = UDim2.fromScale(1, 1)
        });
        u27:Play();
    end;

    u26 = task.delay(8.2, function() -- Line: 385
        -- upvalues: u26 (ref), u29 (ref), u28 (ref), u1 (ref)
        u26 = nil;
        u1.SetPage(u29 == #u28 and 1 or u29 + 1, 1);
    end);
end;

function u1.UpdateBundle() -- Line: 392
    -- upvalues: u16 (ref), u35 (ref), u25 (ref), TweenService (copy), TweenInfo_new_ret5 (copy)
    if not (u16 and u16:FindFirstChild("Main")) then
        return;
    end;

    local Main = u16.Main:FindFirstChild("Main");

    if not Main then
        return;
    end;

    local v53 = u35 and u35[u25 or 1];

    if not v53 then
        return;
    end;

    Main.ItemName.Text = `{v53.Name} | Bundle`;
    Main.ItemName.TextTransparency = 1;
    Main.Icon.Image = v53.MenuThumbnail;
    TweenService:Create(Main.ItemName, TweenInfo_new_ret5, {
        TextTransparency = 0
    }):Play();
    TweenService:Create(Main.Frame, TweenInfo_new_ret5, {
        BackgroundColor3 = v53.MenuColor
    }):Play();
    TweenService:Create(Main.Frame.Blur, TweenInfo_new_ret5, {
        ImageColor3 = v53.MenuColor
    }):Play();
end;

function u1.ClearBundle(p54) -- Line: 417
    -- upvalues: u27 (ref), u26 (ref)
    if u27 then
        u27:Cancel();
        u27:Destroy();
        u27 = nil;
    end;

    if u26 then
        local v55 = u26;
        u26 = nil;

        if coroutine.running() ~= v55 and coroutine.status(v55) ~= "dead" then
            pcall(task.cancel, v55);
        end;
    end;
end;

function u1.RefreshBlur() -- Line: 433
    -- upvalues: u28 (ref), u29 (ref), u7 (ref), u5 (ref)
    if not u28 or #u28 == 0 then
        return;
    end;

    local v56 = u28[u29];

    for _, v in ipairs(u28) do
        local v57;

        if v.frame == v56.frame then
            v57 = u7 and u7.Visible;
        else
            v57 = false;
        end;

        u5.Enabled(v.blurName, v57);
    end;

    u5.Enabled("Rewards", u7 and u7.Visible);
end;

function u1.DrawRightPanel() -- Line: 449
    -- upvalues: u8 (ref), TweenService (copy), TweenInfo_new_ret (copy), u41 (ref), u1 (copy), u30 (ref), TweenInfo_new_ret2 (copy), UserInputService (copy), LocalPlayer (copy)
    u8.MouseEnter:Connect(function() -- Line: 453
        -- upvalues: TweenService (ref), u8 (ref), TweenInfo_new_ret (ref), u41 (ref), u1 (ref), u30 (ref)
        TweenService:Create(u8, TweenInfo_new_ret, {
            Position = UDim2.new(1, 0, 0, 0)
        }):Play();

        if os.clock() - u41 > 30 then
            task.spawn(u1.RefreshFriends);
        end;

        u30.Play("UI.sidemenu_slidein");
    end);

    local function slideOut() -- Line: 465
        -- upvalues: TweenService (ref), u8 (ref), TweenInfo_new_ret2 (ref), u30 (ref)
        TweenService:Create(u8, TweenInfo_new_ret2, {
            Position = UDim2.new(1.136, 0, 0, 0)
        }):Play();
        u30.Play("UI.sidemenu_slideout");
    end;

    u8.MouseLeave:Connect(function() -- Line: 475
        -- upvalues: UserInputService (ref), slideOut (copy)
        if UserInputService:GetLastInputType() ~= Enum.UserInputType.Touch then
            slideOut();
        end;
    end);
    UserInputService.InputBegan:Connect(function(p58) -- Line: 481
        -- upvalues: u8 (ref), LocalPlayer (ref), slideOut (copy)
        if p58.UserInputType ~= Enum.UserInputType.Touch or u8.Position.X.Scale > 1.13 then
            return;
        end;

        for _, v in LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(p58.Position.X, p58.Position.Y) do
            if v == u8 or v:IsDescendantOf(u8) then
                return;
            end;
        end;

        slideOut();
    end);
    task.defer(u1.RefreshFriends);
    u1.DrawProfile();
end;

function u1.RefreshFriends() -- Line: 497
    -- upvalues: LocalPlayer (copy), u41 (ref), u9 (ref), u40 (ref), u10 (ref), u1 (copy), u30 (ref), TweenService (copy), TweenInfo_new_ret3 (copy), TeleportService (copy)
    local success, result = pcall(LocalPlayer.GetFriendsOnline, LocalPlayer, 50);

    if not success then
        return;
    end;

    u41 = os.clock();

    for _, child in u9:GetChildren() do
        if child.Name == "FriendTemplate" then
            child:Destroy();
        end;
    end;

    local function Rank(p59) -- Line: 512
        -- upvalues: u40 (ref)
        return p59.GameId == game.JobId and 1 or (u40.getMode(p59.PlaceId) and 2 or 3);
    end;

    table.sort(result, function(p60, p61) -- Line: 520
        -- upvalues: u40 (ref)
        local v62 = p60.GameId == game.JobId and 1 or (u40.getMode(p60.PlaceId) and 2 or 3);
        local v63 = p61.GameId == game.JobId and 1 or (u40.getMode(p61.PlaceId) and 2 or 3);

        if v62 == v63 then
            return p60.DisplayName < p61.DisplayName;
        end;

        return v62 < v63;
    end);
    u10.Visible = #result == 0;

    for i = 1, math.min(#result, 10) do
        local u64 = result[i];
        local Mode = u40.getMode(u64.PlaceId);
        local v65 = u64.GameId == game.JobId;
        local v66 = v65 and "In your server" or (Mode and `Playing {Mode}` or (u64.LastLocation or "Online"));
        local v67 = v65 and Color3.fromRGB(172, 195, 220) or (Mode and Color3.fromRGB(167, 255, 135) or Color3.new(1, 1, 1));
        local v68 = u1.friend(u64.VisitorId, u64.DisplayName, u64.UserName, v66, v67);
        v68.LayoutOrder = i + 100;
        local v69;

        if Mode and (u64.GameId and not v65) then
            local u70 = u1.friendJoin(v68);
            u70.MouseEnter:Connect(function() -- Line: 545
                -- upvalues: u30 (ref), TweenService (ref), u70 (copy), TweenInfo_new_ret3 (ref)
                u30.Play("UI.submenu_scroll");
                TweenService:Create(u70, TweenInfo_new_ret3, {
                    BackgroundTransparency = 0.7
                }):Play();
            end);
            u70.MouseLeave:Connect(function() -- Line: 550
                -- upvalues: TweenService (ref), u70 (copy), TweenInfo_new_ret3 (ref)
                TweenService:Create(u70, TweenInfo_new_ret3, {
                    BackgroundTransparency = 0.85
                }):Play();
            end);
            u70.MouseButton1Click:Connect(function() -- Line: 554
                -- upvalues: u30 (ref), u70 (copy), TeleportService (ref), u64 (copy), LocalPlayer (ref)
                u30.Play("UI.submenu_click");
                u70.TextLabel.Text = "JOINING";
                TeleportService:TeleportToPlaceInstance(u64.PlaceId, u64.GameId, LocalPlayer);
            end);
            v69 = i;
        else
            v69 = i;
        end;
    end;
end;

function u1.DrawProfile() -- Line: 577
    -- upvalues: u13 (ref), LocalPlayer (copy), u12 (ref), u1 (copy)
    u13.Text = `{LocalPlayer.DisplayName} (@{LocalPlayer.Name})`;
    u12.Image = `rbxthumb://type=AvatarHeadShot&id={LocalPlayer.UserId}&w=420&h=420`;
    u1.UpdatePins();
end;

function u1.UpdatePin() -- Line: 585
    -- upvalues: u36 (ref), u34 (ref), u20 (ref)
    local v71 = u36.GetLoadoutData().CT["19"];

    if v71 then
        v71 = v71.SkinName;
    end;

    if v71 == "None" then
        u20.Visible = false;

        return;
    end;

    u20.Image = u34.GetItem("Badges", v71).Asset;
    u20.Visible = true;
end;

function u1.UpdatePins() -- Line: 602
    -- upvalues: u14 (ref), u4 (ref), u32 (ref), u34 (ref), u1 (copy), u33 (ref), u31 (ref), u36 (ref)
    for _, v in u14:QueryDescendants("ImageButton") do
        u4:Remove(v.Name);
        v:Destroy();
    end;

    local Badges = u32.Get()["Graphic Art"].Badges;

    if not Badges then
        return;
    end;

    for i, v in Badges do
        if i ~= "None" then
            local u72 = i;

            for i2 in v do
                local Item = u34.GetItem("Badges", u72);

                if Item then
                    local v73 = u1.pin(Item.Asset);
                    v73.Name = u72;
                    u4:Add(u72, v73.MouseButton1Click:Connect(function() -- Line: 632
                        -- upvalues: u32 (ref), u72 (copy), i2 (copy), u33 (ref), u31 (ref), u36 (ref)
                        for _, v2 in { "CT", "T" } do
                            u32.SetEquipped(v2, "Badges", u72, i2);
                            u33.Gui.ChangeLoadoutWeapon.Fire({
                                A = 19,
                                B = 1,
                                C = "Badges",
                                D = u72,
                                E = i2,
                                T = u31.TeamsNum[v2]
                            });
                        end;

                        u36.UpdateBadge(u72);
                    end));
                    break;
                end;
            end;
        end;
    end;

    u1.UpdatePin();
end;

function u1.Init(p74) -- Line: 656
    -- upvalues: u2 (ref), u3 (ref), u30 (ref), u34 (ref), u4 (ref), u6 (ref), u35 (ref), u5 (ref), u32 (ref), u31 (ref), u33 (ref), u40 (ref)
    u2 = p74:GetModule("Gui");
    u3 = u2.GetComponent("MainMenu");
    u30 = p74:GetModule("SoundManager");
    u34 = p74:GetModule("ItemManager");
    u4 = p74:GetModule("Maid").new();
    u6 = p74:GetModule("NewsData");
    u35 = p74:GetModule("BundlesData");
    u5 = p74:GetModule("Blur");
    u32 = p74:GetModule("InventoryData");
    u31 = p74:GetModule("Enums");
    u33 = p74:GetModule("Network");
    u40 = p74:GetModule("GamemodesData");
end;

function u1.Start(p75) -- Line: 672
    -- upvalues: u7 (ref), u3 (ref), u37 (ref), u2 (ref), u36 (ref), u38 (ref), u39 (ref), u1 (copy), u5 (ref), u32 (ref), GameStats (copy), u22 (ref), u29 (ref), u28 (ref)
    u7 = u3.AddTab("Home");
    u3.AddSideButton("Home", u7, "rbxassetid://79273277889898", 10).Activate();
    u37 = u2.GetComponent("Store");
    u36 = u2.GetComponent("Loadout");
    u38 = u2.GetComponent("Inventory");
    u39 = u2.GetComponent("Rewards");
    u1.new();
    u1.frames();
    u1.DrawRightPanel();
    u1.DrawBundle();
    u1.DrawRewards();

    for i, v in {
        RightFrame = u7.RightFrame
    } do
        u5.new(i, v);
    end;

    u32.Updated:Connect(u1.UpdatePins);

    local function UpdateBoost() -- Line: 696
        -- upvalues: GameStats (ref), u22 (ref)
        local Attribute = GameStats:GetAttribute("KreditsBoost");
        u22.Visible = Attribute > 1;
        u22.Title.Text = `WEEKEND BONUS: {Attribute}x KREDITS`;
    end;

    local Attribute = GameStats:GetAttribute("KreditsBoost");
    u22.Visible = Attribute > 1;
    u22.Title.Text = `WEEKEND BONUS: {Attribute}x KREDITS`;
    GameStats:GetAttributeChangedSignal("KreditsBoost"):Connect(UpdateBoost);
    u7:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 706
        -- upvalues: u7 (ref), u1 (ref), u29 (ref), u5 (ref), u28 (ref)
        if u7.Visible then
            u1.SetPage(u29, 1);
            u5.Enabled("Rewards", true);

            return;
        end;

        u1.ClearBundle();

        for _, v in ipairs(u28) do
            u5.Enabled(v.blurName, false);
        end;

        u5.Enabled("Rewards", false);
    end);
end;

function u1.new() -- Line: 722
    -- upvalues: u11 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u13 (ref), u12 (ref), u20 (ref), u14 (ref)
    local ViewportFrame = Instance.new("ViewportFrame");
    ViewportFrame.Name = "ViewportFrame";
    ViewportFrame.Ambient = Color3.new();
    ViewportFrame.LightColor = Color3.new(1, 1, 1);
    ViewportFrame.LightDirection = Vector3.new(0, 0, -1);
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 1);
    ViewportFrame.BackgroundTransparency = 1;
    ViewportFrame.Position = UDim2.fromScale(0.7, 1);
    ViewportFrame.Size = UDim2.fromScale(0.519027, 0.999725);
    ViewportFrame.ZIndex = 0;
    u11 = Instance.new("WorldModel");
    u11.Parent = ViewportFrame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 0.735;
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint.Parent = ViewportFrame;
    ViewportFrame.Parent = u7;
    u8 = Instance.new("ImageButton");
    u8.Name = "RightFrame";
    u8.Active = false;
    u8.AnchorPoint = Vector2.new(1, 0);
    u8.AutoButtonColor = false;
    u8.BackgroundTransparency = 1;
    u8.ImageTransparency = 1;
    u8.Position = UDim2.fromScale(1.136, 0);
    u8.ScaleType = Enum.ScaleType.Crop;
    u8.Selectable = false;
    u8.Size = UDim2.fromScale(0.175, 1);
    u8.ZIndex = 2;
    u9 = Instance.new("Frame");
    u9.Name = "Friends";
    u9.BackgroundTransparency = 1;
    u9.Position = UDim2.fromScale(0, 0.151);
    u9.Size = UDim2.fromScale(1, 0.85);
    u9.ZIndex = 100;
    u10 = Instance.new("Frame");
    u10.Name = "Offline";
    u10.BackgroundTransparency = 1;
    u10.Position = UDim2.fromScale(0, 0.066089);
    u10.Size = UDim2.fromScale(1, 0.277614);
    u10.Visible = false;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "MainText";
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 4;
    TextLabel.Position = UDim2.fromScale(0.239104, 0.160633);
    TextLabel.Size = UDim2.fromScale(0.675352, 0.121326);
    TextLabel.Text = "Friends Online";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = u10;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "SendText";
    TextLabel2.AnchorPoint = Vector2.new(0, 1);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.LayoutOrder = 4;
    TextLabel2.Position = UDim2.fromScale(0.239, 0.433553);
    TextLabel2.Size = UDim2.fromScale(0.729977, 0.13637);
    TextLabel2.Text = "Your friends are not online currently.";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = u10;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "LastText";
    TextLabel3.AnchorPoint = Vector2.new(0, 1);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.LayoutOrder = 4;
    TextLabel3.Position = UDim2.fromScale(0.239, 0.74911);
    TextLabel3.Size = UDim2.fromScale(0.729977, 0.317239);
    TextLabel3.Text = "If you are looking for people to play\nwith, try joining a team or playing gamemodes \nto populate your \'Recent Friends\'\ntab.";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.ZIndex = 9;
    TextLabel3.Parent = u10;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "IconInfo";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://80205853195967";
    ImageLabel.Position = UDim2.new(0.0350001, 5, 0.471645, 0);
    ImageLabel.Size = UDim2.fromScale(0.1, 0.1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = u10;
    u10.Parent = u9;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = u9;
    u9.Parent = u8;
    local Frame = Instance.new("Frame");
    Frame.Name = "Profile";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 0.15);
    Frame.ZIndex = 100;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "User";
    Frame2.BackgroundTransparency = 1;
    Frame2.LayoutOrder = 100;
    Frame2.Position = UDim2.fromScale(0, 0.05);
    Frame2.Selectable = true;
    Frame2.Size = UDim2.fromScale(1, 0.5);
    Frame2.ZIndex = 100;
    u13 = Instance.new("TextLabel");
    u13.Name = "PlayerName";
    u13.AutoLocalize = false;
    u13.BackgroundTransparency = 1;
    u13.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    u13.LayoutOrder = 4;
    u13.Position = UDim2.fromScale(0.248876, 0.15);
    u13.Size = UDim2.fromScale(0.711227, 0.35);
    u13.Text = "WhyNotMyUsername";
    u13.TextColor3 = Color3.new(1, 1, 1);
    u13.TextScaled = true;
    u13.TextXAlignment = Enum.TextXAlignment.Left;
    u13.ZIndex = 9;
    u13.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "ImageLabel";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.02, 0.5);
    Frame3.Size = UDim2.fromScale(0.8, 0.8);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    u12 = Instance.new("ImageLabel");
    u12.Name = "ImageLabel";
    u12.AnchorPoint = Vector2.new(0.5, 0.5);
    u12.BackgroundColor3 = Color3.new();
    u12.BorderColor3 = Color3.new();
    u12.BorderSizePixel = 0;
    u12.Image = "rbxthumb://type=AvatarHeadShot&id=2994385561&w=420&h=420";
    u12.Position = UDim2.fromScale(0.5, 0.5);
    u12.Size = UDim2.fromScale(1, 1);
    u12.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    u12.Parent = Frame3;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Shadow";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://186491278";
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Slice;
    ImageLabel2.Size = UDim2.fromScale(1.4, 1.4);
    ImageLabel2.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel2.ZIndex = -9999;
    ImageLabel2.Parent = Frame3;
    u20 = Instance.new("ImageLabel");
    u20.Name = "Pin";
    u20.AnchorPoint = Vector2.new(0.200000003, 0.200000003);
    u20.BackgroundTransparency = 1;
    u20.Image = "rbxassetid://100429874437897";
    u20.Size = UDim2.fromScale(0.6, 0.6);
    u20.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    u20.ZIndex = 2;
    u20.Parent = Frame3;
    Frame3.Parent = Frame2;
    u14 = Instance.new("Frame");
    u14.Name = "Pins";
    u14.AnchorPoint = Vector2.new(0, 0.5);
    u14.BackgroundTransparency = 1;
    u14.Position = UDim2.fromScale(0.249, 0.7);
    u14.Size = UDim2.fromScale(0.6, 0.4);
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.Parent = u14;
    u14.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Rank";
    Frame4.AnchorPoint = Vector2.new(0, 1);
    Frame4.BackgroundTransparency = 1;
    Frame4.LayoutOrder = 100;
    Frame4.Position = UDim2.fromScale(0, 0.95);
    Frame4.Selectable = true;
    Frame4.Size = UDim2.fromScale(1.003, 0.4);
    Frame4.ZIndex = 100;
    Frame4.Visible = false;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "RankName";
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel4.LayoutOrder = 4;
    TextLabel4.Position = UDim2.fromScale(0.248876, 0.15);
    TextLabel4.Size = UDim2.fromScale(0.711227, 0.35);
    TextLabel4.Text = "Marshal";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = Frame4;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "ImageLabel";
    ImageLabel3.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://0";
    ImageLabel3.Position = UDim2.fromScale(0.0275, 0.5);
    ImageLabel3.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = Frame4;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Bar";
    Frame5.AnchorPoint = Vector2.new(0, 0.5);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.fromScale(0.249, 0.65);
    Frame5.Size = UDim2.fromScale(0.7, 0.15);
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Shadow";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://186491278";
    ImageLabel4.ImageTransparency = 0.6;
    ImageLabel4.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel4.ScaleType = Enum.ScaleType.Slice;
    ImageLabel4.Size = UDim2.new(1, 5, 1, 5);
    ImageLabel4.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel4.ZIndex = -9999;
    ImageLabel4.Parent = Frame5;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "BG";
    Frame6.BackgroundColor3 = Color3.fromRGB(43, 43, 43);
    Frame6.BorderColor3 = Color3.new();
    Frame6.BorderSizePixel = 0;
    Frame6.Size = UDim2.fromScale(1, 1);
    Frame6.Parent = Frame5;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Bar";
    Frame7.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame7.BorderColor3 = Color3.new();
    Frame7.BorderSizePixel = 0;
    Frame7.Size = UDim2.fromScale(0.5, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(63, 106, 124)),
        ColorSequenceKeypoint.new(0.245675, Color3.fromRGB(66, 110, 129)),
        ColorSequenceKeypoint.new(0.861592, Color3.fromRGB(108, 180, 211)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(131, 216, 255))
    });
    UIGradient.Parent = Frame7;
    Frame7.Parent = Frame5;
    Frame5.Parent = Frame4;
    Frame4.Parent = Frame;
    Frame.Parent = u8;
    local Folder = Instance.new("Folder");
    Folder.Name = "Folder";
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Shadow";
    Frame8.AnchorPoint = Vector2.new(1, 0);
    Frame8.BackgroundColor3 = Color3.new();
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Size = UDim2.fromScale(0.04, 1);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.300499, 1), NumberSequenceKeypoint.new(1, 0.6125) });
    UIGradient2.Parent = Frame8;
    Frame8.Parent = Folder;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Lines";
    Frame9.BackgroundTransparency = 1;
    Frame9.ClipsDescendants = true;
    Frame9.Size = UDim2.fromScale(1, 1);
    Frame9.ZIndex = 3;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "ImageLabel";
    ImageLabel5.AnchorPoint = Vector2.new(1, 0);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://118256082193795";
    ImageLabel5.ImageTransparency = 0.95;
    ImageLabel5.Position = UDim2.fromScale(1, -0.058);
    ImageLabel5.ScaleType = Enum.ScaleType.Tile;
    ImageLabel5.Size = UDim2.fromScale(5.71429, 1.058);
    ImageLabel5.TileSize = UDim2.fromScale(0.3, 0.548);
    ImageLabel5.Parent = Frame9;
    Frame9.Parent = Folder;
    Folder.Parent = u8;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Line";
    Frame10.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame10.BackgroundTransparency = 0.6;
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.fromScale(0, 0.15);
    Frame10.Size = UDim2.new(1, 0, 0, 1);
    Frame10.ZIndex = 100;
    Frame10.Parent = u8;
    local Folder2 = Instance.new("Folder");
    Folder2.Name = "Folder";
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Shadow";
    Frame11.AnchorPoint = Vector2.new(1, 0);
    Frame11.BackgroundColor3 = Color3.new();
    Frame11.BorderColor3 = Color3.new();
    Frame11.BorderSizePixel = 0;
    Frame11.Size = UDim2.fromScale(0.04, 1);
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.300499, 1), NumberSequenceKeypoint.new(1, 0.6125) });
    UIGradient3.Parent = Frame11;
    Frame11.Parent = Folder2;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Lines";
    Frame12.BackgroundTransparency = 1;
    Frame12.ClipsDescendants = true;
    Frame12.Size = UDim2.fromScale(1, 1);
    Frame12.ZIndex = 3;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "ImageLabel";
    ImageLabel6.AnchorPoint = Vector2.new(1, 0);
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://118256082193795";
    ImageLabel6.ImageTransparency = 0.95;
    ImageLabel6.Position = UDim2.fromScale(1, -0.058);
    ImageLabel6.ScaleType = Enum.ScaleType.Tile;
    ImageLabel6.Size = UDim2.fromScale(5.71429, 1.058);
    ImageLabel6.TileSize = UDim2.fromScale(0.3, 0.548);
    ImageLabel6.Parent = Frame12;
    Frame12.Parent = Folder2;
    Folder2.Parent = u8;
    u8.Parent = u7;
end;

function u1.friend(p76, p77, p78, p79, p80) -- Line: 1402
    -- upvalues: u9 (ref)
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "FriendTemplate";
    ImageButton.Active = false;
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.new();
    ImageButton.BackgroundTransparency = 0.8;
    ImageButton.BorderColor3 = Color3.new();
    ImageButton.BorderSizePixel = 0;
    ImageButton.LayoutOrder = 100;
    ImageButton.Size = UDim2.fromScale(1, 0.1);
    ImageButton.ZIndex = 100;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundColor3 = Color3.new();
    ImageLabel.BorderColor3 = Color3.new();
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Image = `rbxthumb://type=AvatarHeadShot&id={p76}&w=420&h=420`;
    ImageLabel.Position = UDim2.new(0.035, 5, 0.5, 0);
    ImageLabel.Size = UDim2.fromScale(0.7, 0.7);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = ImageButton;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 5;
    UIAspectRatioConstraint.Parent = ImageButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.new(0, 5, 1, 0);
    Frame.Parent = ImageButton;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) });
    UIGradient.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "PlayerName";
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 4;
    TextLabel.Position = UDim2.fromScale(0.225, 0.15);
    TextLabel.Size = UDim2.fromScale(0.5, 0.35);
    TextLabel.Text = `{p77} (@{p78})`;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = ImageButton;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Status";
    TextLabel2.AnchorPoint = Vector2.new(0, 1);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.LayoutOrder = 4;
    TextLabel2.Position = UDim2.fromScale(0.225, 0.85);
    TextLabel2.Size = UDim2.fromScale(0.5, 0.325);
    TextLabel2.Text = p79;
    TextLabel2.TextColor3 = p80;
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = ImageButton;
    ImageButton.Parent = u9;

    return ImageButton;
end;

function u1.friendJoin(p81) -- Line: 1492
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Join";
    TextButton.AnchorPoint = Vector2.new(1, 0.5);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.fromRGB(167, 255, 135);
    TextButton.BackgroundTransparency = 0.85;
    TextButton.BorderSizePixel = 0;
    TextButton.Position = UDim2.fromScale(0.96, 0.5);
    TextButton.Size = UDim2.fromScale(0.2, 0.5);
    TextButton.Text = "";
    TextButton.ZIndex = 10;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.15, 0);
    UICorner.Parent = TextButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.fromRGB(167, 255, 135);
    UIStroke.Thickness = 1.3;
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.8, 0.55);
    TextLabel.Text = "JOIN";
    TextLabel.TextColor3 = Color3.fromRGB(167, 255, 135);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 11;
    TextLabel.Parent = TextButton;
    TextButton.Parent = p81;

    return TextButton;
end;

function u1.pin(p82) -- Line: 1539
    -- upvalues: u14 (ref)
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "PinTemplate";
    ImageButton.Active = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = p82;
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton.Parent = u14;

    return ImageButton;
end;

function u1.frames() -- Line: 1553
    -- upvalues: u15 (ref), u21 (ref), u2 (ref), u1 (copy), u22 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u34 (ref), u7 (ref)
    u15 = Instance.new("Frame");
    u15.Name = "Frames";
    u15.BackgroundTransparency = 1;
    u15.Position = UDim2.fromScale(-5.77547e-9, 0.00299999);
    u15.Size = UDim2.fromScale(0.175, 1);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0.02, 0);
    UIPadding.PaddingLeft = UDim.new(0.05, 0);
    UIPadding.PaddingRight = UDim.new(0.05, 0);
    UIPadding.PaddingTop = UDim.new(0.02, 0);
    UIPadding.Parent = u15;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.01, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    UIListLayout.Parent = u15;
    u21 = Instance.new("Frame");
    u21.Name = "RewardsFrame";
    u21.BackgroundTransparency = 1;
    u21.Size = UDim2.fromScale(1, 0.9);
    u21.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    u21.LayoutOrder = 1;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Shadow";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://186491278";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Slice;
    ImageLabel.Size = UDim2.new(1, 25, 1, 25);
    ImageLabel.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel.Visible = false;
    ImageLabel.ZIndex = -9999;
    ImageLabel.Parent = u21;
    local Frame = Instance.new("Frame");
    Frame.Name = "Main";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Background";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(12, 10, 10);
    Frame2.BackgroundTransparency = 0.5;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.ZIndex = -1;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(98, 98, 98)) });
    UIGradient.Rotation = 45;
    UIGradient.Parent = Frame2;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Blur";
    ImageButton.Active = false;
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.AutoLocalize = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://6430908053";
    ImageButton.ImageColor3 = Color3.fromRGB(12, 10, 10);
    ImageButton.ImageTransparency = 0.6;
    ImageButton.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.ZIndex = 3;
    ImageButton.Parent = Frame2;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(117, 117, 117);
    UIStroke.Transparency = 0.75;
    UIStroke.Parent = Frame2;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "DOTS";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundColor3 = Color3.fromRGB(16, 16, 16);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.BorderColor3 = Color3.new();
    ImageLabel2.BorderSizePixel = 0;
    ImageLabel2.Image = "rbxassetid://91991932054752";
    ImageLabel2.ImageColor3 = Color3.fromRGB(145, 145, 145);
    ImageLabel2.ImageTransparency = 0.8;
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Tile;
    ImageLabel2.TileSize = u2 and (u2.GetDotsTileSize and u2.GetDotsTileSize()) or UDim2.fromOffset(512, 512);
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.ZIndex = -1;
    ImageLabel2.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Title";
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BackgroundTransparency = 0.95;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Size = UDim2.fromScale(1, 0.22);
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Title";
    TextButton.Active = true;
    TextButton.AnchorPoint = Vector2.new(0, 0.5);
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextButton.Position = UDim2.fromScale(0.225, 0.5);
    TextButton.Selectable = false;
    TextButton.Size = UDim2.fromScale(0.5, 0.55);
    TextButton.Text = "REWARDS";
    TextButton.TextColor3 = Color3.fromRGB(236, 236, 236);
    TextButton.TextScaled = true;
    TextButton.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextButton.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton.ZIndex = 343;
    TextButton.Parent = Frame3;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "ImageLabel";
    ImageLabel3.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://86354349095664";
    ImageLabel3.ImageColor3 = Color3.fromRGB(236, 236, 236);
    ImageLabel3.Position = UDim2.fromScale(0.05, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.65, 0.65);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = Frame3;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Line";
    Frame4.AnchorPoint = Vector2.new(0, 1);
    Frame4.BackgroundColor3 = Color3.fromRGB(117, 117, 117);
    Frame4.BackgroundTransparency = 0.5;
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0, 1);
    Frame4.Size = UDim2.new(1, 0, 0, 1);
    Frame4.ZIndex = 100;
    Frame4.Parent = Frame3;
    Frame3.Parent = Frame;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Buttons";
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0, 0.22);
    Frame5.Size = UDim2.fromScale(1, 0.78);
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout2.Padding = UDim.new(0.05, 0);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout2.Parent = Frame5;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingBottom = UDim.new(0.05, 0);
    UIPadding2.PaddingLeft = UDim.new(0.05, 0);
    UIPadding2.PaddingRight = UDim.new(0.05, 0);
    UIPadding2.PaddingTop = UDim.new(0.05, 0);
    UIPadding2.Parent = Frame5;
    u1.rewardButton(Frame5, "Promocodes", "PROMOCODES", "rbxassetid://119276666158135", 1);
    local v83 = u1.rewardButton(Frame5, "Challenges", "CHALLENGES", "rbxassetid://138287828889172", 2);
    u1.rewardButton(Frame5, "PlaytimeRewards", "PLAYTIME REWARDS", "rbxassetid://107995524735706", 3);
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "New";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundColor3 = Color3.fromRGB(106, 177, 207);
    Frame6.Position = UDim2.fromScale(0.05, 0.04);
    Frame6.Size = UDim2.fromScale(0.14, 0.4);
    Frame6.ZIndex = 10;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.125, 0);
    UICorner.BottomRightRadius = UDim.new(0.125, 0);
    UICorner.CornerRadius = UDim.new(0.125, 0);
    UICorner.TopLeftRadius = UDim.new(0.125, 0);
    UICorner.TopRightRadius = UDim.new(0.125, 0);
    UICorner.Parent = Frame6;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.8, 0.8);
    TextLabel.Text = "NEW";
    TextLabel.TextColor3 = Color3.fromRGB(40, 40, 48);
    TextLabel.TextScaled = true;
    TextLabel.Parent = Frame6;
    Frame6.Parent = v83;
    Frame5.Parent = Frame;
    Frame.Parent = u21;
    u21.Parent = u15;
    u22 = Instance.new("Frame");
    u22.Name = "BoostFrame";
    u22.BackgroundTransparency = 1;
    u22.Size = UDim2.fromScale(1, 0.08);
    u22.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    u22.LayoutOrder = 0;
    u22.Visible = false;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Size = UDim2.fromScale(1, 1);
    TextLabel2.Text = "";
    TextLabel2.TextColor3 = Color3.fromRGB(175, 231, 255);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 343;
    TextLabel2.Parent = u22;
    u22.Parent = u15;
    u16 = Instance.new("Frame");
    u16.Name = "BundleFrame";
    u16.BackgroundTransparency = 1;
    u16.Size = UDim2.fromScale(1, 1);
    u16.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    u16.LayoutOrder = 2;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Shadow";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://186491278";
    ImageLabel4.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel4.ScaleType = Enum.ScaleType.Slice;
    ImageLabel4.Size = UDim2.new(1, 25, 1, 25);
    ImageLabel4.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel4.Visible = false;
    ImageLabel4.ZIndex = -9999;
    ImageLabel4.Parent = u16;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Main";
    Frame7.BackgroundTransparency = 1;
    Frame7.Size = UDim2.fromScale(1, 1);
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Buttons";
    Frame8.AnchorPoint = Vector2.new(0, 1);
    Frame8.BackgroundColor3 = Color3.fromRGB(50, 51, 57);
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Position = UDim2.fromScale(0, 1);
    Frame8.Size = UDim2.fromScale(1, 0.1);
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Left";
    ImageButton2.Active = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://112384474990249";
    ImageButton2.LayoutOrder = -2;
    ImageButton2.Rotation = 90;
    ImageButton2.Selectable = false;
    ImageButton2.Size = UDim2.fromScale(0.6, 0.6);
    ImageButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton2.Parent = Frame8;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "Right";
    ImageButton3.Active = false;
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.Image = "rbxassetid://111836723369257";
    ImageButton3.LayoutOrder = 10000;
    ImageButton3.Rotation = 90;
    ImageButton3.Selectable = false;
    ImageButton3.Size = UDim2.fromScale(0.6, 0.6);
    ImageButton3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton3.Parent = Frame8;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Space";
    Frame9.BackgroundTransparency = 1;
    Frame9.LayoutOrder = -1;
    Frame9.Size = UDim2.fromScale(0.9, 0.6);
    Frame9.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame9.Parent = Frame8;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Space";
    Frame10.BackgroundTransparency = 1;
    Frame10.LayoutOrder = 9999;
    Frame10.Size = UDim2.fromScale(0.9, 0.6);
    Frame10.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame10.Parent = Frame8;
    local UIListLayout3 = Instance.new("UIListLayout");
    UIListLayout3.Name = "UIListLayout";
    UIListLayout3.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout3.Padding = UDim.new(0.01, 0);
    UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout3.Parent = Frame8;
    Frame8.Parent = Frame7;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Line";
    Frame11.AnchorPoint = Vector2.new(0, 1);
    Frame11.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame11.BackgroundTransparency = 0.5;
    Frame11.BorderColor3 = Color3.new();
    Frame11.BorderSizePixel = 0;
    Frame11.Position = UDim2.fromScale(0, 0.9);
    Frame11.Size = UDim2.new(1, 0, 0, 1);
    Frame11.ZIndex = 100;
    Frame11.Parent = Frame7;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Main";
    Frame12.BackgroundTransparency = 1;
    Frame12.Size = UDim2.fromScale(1, 0.9);
    local ImageButton4 = Instance.new("ImageButton");
    ImageButton4.Name = "Icon";
    ImageButton4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton4.BackgroundTransparency = 1;
    ImageButton4.BorderMode = Enum.BorderMode.Inset;
    ImageButton4.Image = "rbxassetid://97681196564846";
    ImageButton4.Interactable = true;
    ImageButton4.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton4.ScaleType = Enum.ScaleType.Fit;
    ImageButton4.Size = UDim2.fromScale(0.75, 0.75);
    ImageButton4.ZIndex = 5;
    ImageButton4.Parent = Frame12;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Title";
    TextButton2.Active = false;
    TextButton2.BackgroundTransparency = 1;
    TextButton2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextButton2.Position = UDim2.fromScale(0.04, 0.0500001);
    TextButton2.Selectable = false;
    TextButton2.Size = UDim2.fromScale(0.5, 0.08);
    TextButton2.Text = "NEW & POPULAR";
    TextButton2.TextColor3 = Color3.fromRGB(236, 236, 236);
    TextButton2.TextScaled = true;
    TextButton2.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextButton2.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton2.ZIndex = 343;
    TextButton2.Parent = Frame12;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Tip";
    TextButton3.Active = false;
    TextButton3.AnchorPoint = Vector2.new(1, 1);
    TextButton3.BackgroundTransparency = 1;
    TextButton3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Light, Enum.FontStyle.Normal);
    TextButton3.Position = UDim2.fromScale(0.99, 0.994);
    TextButton3.Selectable = false;
    TextButton3.Size = UDim2.fromScale(0.5, 0.08);
    TextButton3.Text = "Click for more";
    TextButton3.TextColor3 = Color3.new(1, 1, 1);
    TextButton3.TextScaled = true;
    TextButton3.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextButton3.TextTransparency = 0.8;
    TextButton3.TextXAlignment = Enum.TextXAlignment.Right;
    TextButton3.ZIndex = 343;
    TextButton3.Parent = Frame12;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "ItemName";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.85797);
    TextLabel3.Size = UDim2.fromScale(0.9, 0.0920297);
    TextLabel3.Text = "Alpha | Bundle";
    TextLabel3.TextColor3 = Color3.fromRGB(222, 222, 222);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeTransparency = 0.85;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.Parent = Frame12;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Frame";
    Frame13.AnchorPoint = Vector2.new(0.5, 0);
    Frame13.BackgroundColor3 = Color3.fromRGB(12, 10, 10);
    Frame13.BackgroundTransparency = 0.5;
    Frame13.BorderColor3 = Color3.new();
    Frame13.BorderSizePixel = 0;
    Frame13.Position = UDim2.fromScale(0.5, 0);
    Frame13.Size = UDim2.fromScale(1, 1);
    Frame13.ZIndex = -1;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(98, 98, 98)) });
    UIGradient2.Rotation = 45;
    UIGradient2.Parent = Frame13;
    local ImageButton5 = Instance.new("ImageButton");
    ImageButton5.Name = "Blur";
    ImageButton5.Active = false;
    ImageButton5.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton5.AutoButtonColor = false;
    ImageButton5.AutoLocalize = false;
    ImageButton5.BackgroundTransparency = 1;
    ImageButton5.Image = "rbxassetid://6430908053";
    ImageButton5.ImageColor3 = Color3.fromRGB(12, 10, 10);
    ImageButton5.ImageTransparency = 0.6;
    ImageButton5.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton5.ScaleType = Enum.ScaleType.Fit;
    ImageButton5.Size = UDim2.fromScale(1, 1);
    ImageButton5.ZIndex = 3;
    ImageButton5.Parent = Frame13;
    Frame13.Parent = Frame12;
    Frame12.Parent = Frame7;
    Frame7.Parent = u16;
    u16.Parent = u15;
    u17 = Instance.new("Frame");
    u17.Name = "BalisongFrame";
    u17.BackgroundTransparency = 1;
    u17.Size = UDim2.fromScale(1, 1);
    u17.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    u17.Visible = false;
    u17.LayoutOrder = 2;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Shadow";
    ImageLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://186491278";
    ImageLabel5.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel5.ScaleType = Enum.ScaleType.Slice;
    ImageLabel5.Size = UDim2.new(1, 25, 1, 25);
    ImageLabel5.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel5.Visible = false;
    ImageLabel5.ZIndex = -9999;
    ImageLabel5.Parent = u17;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "Main";
    Frame14.BackgroundTransparency = 1;
    Frame14.Size = UDim2.fromScale(1, 1);
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Buttons";
    Frame15.AnchorPoint = Vector2.new(0, 1);
    Frame15.BackgroundColor3 = Color3.fromRGB(50, 51, 57);
    Frame15.BorderColor3 = Color3.new();
    Frame15.BorderSizePixel = 0;
    Frame15.Position = UDim2.fromScale(0, 1);
    Frame15.Size = UDim2.fromScale(1, 0.1);
    local ImageButton6 = Instance.new("ImageButton");
    ImageButton6.Name = "Left";
    ImageButton6.Active = false;
    ImageButton6.BackgroundTransparency = 1;
    ImageButton6.Image = "rbxassetid://112384474990249";
    ImageButton6.LayoutOrder = -2;
    ImageButton6.Rotation = 90;
    ImageButton6.Selectable = false;
    ImageButton6.Size = UDim2.fromScale(0.6, 0.6);
    ImageButton6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton6.Parent = Frame15;
    local ImageButton7 = Instance.new("ImageButton");
    ImageButton7.Name = "Right";
    ImageButton7.Active = false;
    ImageButton7.BackgroundTransparency = 1;
    ImageButton7.Image = "rbxassetid://111836723369257";
    ImageButton7.LayoutOrder = 10000;
    ImageButton7.Rotation = 90;
    ImageButton7.Selectable = false;
    ImageButton7.Size = UDim2.fromScale(0.6, 0.6);
    ImageButton7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton7.Parent = Frame15;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "Space";
    Frame16.BackgroundTransparency = 1;
    Frame16.LayoutOrder = -1;
    Frame16.Size = UDim2.fromScale(0.9, 0.6);
    Frame16.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame16.Parent = Frame15;
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "Space";
    Frame17.BackgroundTransparency = 1;
    Frame17.LayoutOrder = 9999;
    Frame17.Size = UDim2.fromScale(0.9, 0.6);
    Frame17.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame17.Parent = Frame15;
    local UIListLayout4 = Instance.new("UIListLayout");
    UIListLayout4.Name = "UIListLayout";
    UIListLayout4.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout4.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout4.Padding = UDim.new(0.01, 0);
    UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout4.Parent = Frame15;
    Frame15.Parent = Frame14;
    local Frame18 = Instance.new("Frame");
    Frame18.Name = "Line";
    Frame18.AnchorPoint = Vector2.new(0, 1);
    Frame18.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame18.BackgroundTransparency = 0.5;
    Frame18.BorderColor3 = Color3.new();
    Frame18.BorderSizePixel = 0;
    Frame18.Position = UDim2.fromScale(0, 0.9);
    Frame18.Size = UDim2.new(1, 0, 0, 1);
    Frame18.ZIndex = 100;
    Frame18.Parent = Frame14;
    local Frame19 = Instance.new("Frame");
    Frame19.Name = "Main";
    Frame19.BackgroundTransparency = 1;
    Frame19.Size = UDim2.fromScale(1, 0.9);
    local ImageButton8 = Instance.new("ImageButton");
    ImageButton8.Name = "Icon";
    ImageButton8.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton8.BackgroundTransparency = 1;
    ImageButton8.BorderMode = Enum.BorderMode.Inset;
    ImageButton8.Image = "rbxassetid://124410587555644";
    ImageButton8.Interactable = true;
    ImageButton8.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton8.ScaleType = Enum.ScaleType.Fit;
    ImageButton8.Size = UDim2.fromScale(0.9, 0.9);
    ImageButton8.ZIndex = 5;
    ImageButton8.Parent = Frame19;
    local TextButton4 = Instance.new("TextButton");
    TextButton4.Name = "Title";
    TextButton4.Active = false;
    TextButton4.BackgroundTransparency = 1;
    TextButton4.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextButton4.Position = UDim2.fromScale(0.04, 0.0500001);
    TextButton4.Selectable = false;
    TextButton4.Size = UDim2.fromScale(0.5, 0.08);
    TextButton4.Text = "CREDITS + BONUS";
    TextButton4.TextColor3 = Color3.fromRGB(236, 236, 236);
    TextButton4.TextScaled = true;
    TextButton4.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextButton4.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton4.ZIndex = 343;
    TextButton4.Parent = Frame19;
    local TextButton5 = Instance.new("TextButton");
    TextButton5.Name = "Tip";
    TextButton5.Active = false;
    TextButton5.AnchorPoint = Vector2.new(1, 1);
    TextButton5.BackgroundTransparency = 1;
    TextButton5.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Light, Enum.FontStyle.Normal);
    TextButton5.Position = UDim2.fromScale(0.99, 0.994);
    TextButton5.Selectable = false;
    TextButton5.Size = UDim2.fromScale(0.5, 0.08);
    TextButton5.Text = "Click for more";
    TextButton5.TextColor3 = Color3.new(1, 1, 1);
    TextButton5.TextScaled = true;
    TextButton5.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextButton5.TextTransparency = 0.8;
    TextButton5.TextXAlignment = Enum.TextXAlignment.Right;
    TextButton5.ZIndex = 343;
    TextButton5.Parent = Frame19;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "ItemName";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.5, 0.85797);
    TextLabel4.Size = UDim2.fromScale(0.9, 0.0920297);
    TextLabel4.Text = "12500 Kredits + Balisong | Gold";
    TextLabel4.TextColor3 = Color3.fromRGB(222, 222, 222);
    TextLabel4.TextScaled = true;
    TextLabel4.TextStrokeTransparency = 0.85;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 10;
    TextLabel4.Parent = Frame19;
    local Frame20 = Instance.new("Frame");
    Frame20.Name = "Frame";
    Frame20.AnchorPoint = Vector2.new(0.5, 0);
    Frame20.BackgroundColor3 = Color3.fromRGB(175, 108, 14);
    Frame20.BackgroundTransparency = 0.5;
    Frame20.BorderColor3 = Color3.new();
    Frame20.BorderSizePixel = 0;
    Frame20.Position = UDim2.fromScale(0.5, 0);
    Frame20.Size = UDim2.fromScale(1, 1);
    Frame20.ZIndex = -1;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(98, 98, 98)) });
    UIGradient3.Rotation = 45;
    UIGradient3.Parent = Frame20;
    local ImageButton9 = Instance.new("ImageButton");
    ImageButton9.Name = "Blur";
    ImageButton9.Active = false;
    ImageButton9.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton9.AutoButtonColor = false;
    ImageButton9.AutoLocalize = false;
    ImageButton9.BackgroundTransparency = 1;
    ImageButton9.Image = "rbxassetid://6430908053";
    ImageButton9.ImageColor3 = Color3.fromRGB(175, 108, 14);
    ImageButton9.ImageTransparency = 0.6;
    ImageButton9.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton9.ScaleType = Enum.ScaleType.Fit;
    ImageButton9.Size = UDim2.fromScale(1, 1);
    ImageButton9.ZIndex = 3;
    ImageButton9.Parent = Frame20;
    Frame20.Parent = Frame19;
    local Frame21 = Instance.new("Frame");
    Frame21.Name = "Frame";
    Frame21.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame21.BackgroundTransparency = 1;
    Frame21.Position = UDim2.fromScale(0.5, 0.5);
    Frame21.Size = UDim2.new(1, -10, 1, -20);
    Frame21.Parent = Frame14;
    Frame19.Parent = Frame14;
    Frame14.Parent = u17;
    u17.Parent = u15;
    u18 = Instance.new("Frame");
    u18.Name = "UpgraderFrame";
    u18.BackgroundTransparency = 1;
    u18.Size = UDim2.fromScale(1, 1);
    u18.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    u18.Visible = false;
    u18.LayoutOrder = 2;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "Shadow";
    ImageLabel6.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://186491278";
    ImageLabel6.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel6.ScaleType = Enum.ScaleType.Slice;
    ImageLabel6.Size = UDim2.new(1, 25, 1, 25);
    ImageLabel6.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel6.Visible = false;
    ImageLabel6.ZIndex = -9999;
    ImageLabel6.Parent = u18;
    local Frame22 = Instance.new("Frame");
    Frame22.Name = "Main";
    Frame22.BackgroundTransparency = 1;
    Frame22.Size = UDim2.fromScale(1, 1);
    local Frame23 = Instance.new("Frame");
    Frame23.Name = "Buttons";
    Frame23.AnchorPoint = Vector2.new(0, 1);
    Frame23.BackgroundColor3 = Color3.fromRGB(50, 51, 57);
    Frame23.BorderColor3 = Color3.new();
    Frame23.BorderSizePixel = 0;
    Frame23.Position = UDim2.fromScale(0, 1);
    Frame23.Size = UDim2.fromScale(1, 0.1);
    local ImageButton10 = Instance.new("ImageButton");
    ImageButton10.Name = "Left";
    ImageButton10.Active = false;
    ImageButton10.BackgroundTransparency = 1;
    ImageButton10.Image = "rbxassetid://112384474990249";
    ImageButton10.LayoutOrder = -2;
    ImageButton10.Rotation = 90;
    ImageButton10.Selectable = false;
    ImageButton10.Size = UDim2.fromScale(0.6, 0.6);
    ImageButton10.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton10.Parent = Frame23;
    local ImageButton11 = Instance.new("ImageButton");
    ImageButton11.Name = "Right";
    ImageButton11.Active = false;
    ImageButton11.BackgroundTransparency = 1;
    ImageButton11.Image = "rbxassetid://111836723369257";
    ImageButton11.LayoutOrder = 10000;
    ImageButton11.Rotation = 90;
    ImageButton11.Selectable = false;
    ImageButton11.Size = UDim2.fromScale(0.6, 0.6);
    ImageButton11.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton11.Parent = Frame23;
    local Frame24 = Instance.new("Frame");
    Frame24.Name = "Space";
    Frame24.BackgroundTransparency = 1;
    Frame24.LayoutOrder = -1;
    Frame24.Size = UDim2.fromScale(0.9, 0.6);
    Frame24.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame24.Parent = Frame23;
    local Frame25 = Instance.new("Frame");
    Frame25.Name = "Space";
    Frame25.BackgroundTransparency = 1;
    Frame25.LayoutOrder = 9999;
    Frame25.Size = UDim2.fromScale(0.9, 0.6);
    Frame25.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame25.Parent = Frame23;
    local UIListLayout5 = Instance.new("UIListLayout");
    UIListLayout5.Name = "UIListLayout";
    UIListLayout5.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout5.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout5.Padding = UDim.new(0.01, 0);
    UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout5.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout5.Parent = Frame23;
    Frame23.Parent = Frame22;
    local Frame26 = Instance.new("Frame");
    Frame26.Name = "Line";
    Frame26.AnchorPoint = Vector2.new(0, 1);
    Frame26.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame26.BackgroundTransparency = 0.5;
    Frame26.BorderColor3 = Color3.new();
    Frame26.BorderSizePixel = 0;
    Frame26.Position = UDim2.fromScale(0, 0.9);
    Frame26.Size = UDim2.new(1, 0, 0, 1);
    Frame26.ZIndex = 100;
    Frame26.Parent = Frame22;
    local Frame27 = Instance.new("Frame");
    Frame27.Name = "Main";
    Frame27.BackgroundTransparency = 1;
    Frame27.Size = UDim2.fromScale(1, 0.9);
    local ImageButton12 = Instance.new("ImageButton");
    ImageButton12.Name = "Icon";
    ImageButton12.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton12.BackgroundTransparency = 1;
    ImageButton12.BorderMode = Enum.BorderMode.Inset;
    ImageButton12.Image = "rbxassetid://97886715419466";
    ImageButton12.Interactable = true;
    ImageButton12.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton12.ScaleType = Enum.ScaleType.Fit;
    ImageButton12.Size = UDim2.fromScale(0.9, 0.9);
    ImageButton12.ZIndex = 5;
    ImageButton12.Parent = Frame27;
    local TextButton6 = Instance.new("TextButton");
    TextButton6.Name = "Title";
    TextButton6.Active = false;
    TextButton6.BackgroundTransparency = 1;
    TextButton6.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextButton6.Position = UDim2.fromScale(0.04, 0.0500001);
    TextButton6.Selectable = false;
    TextButton6.Size = UDim2.fromScale(0.5, 0.08);
    TextButton6.Text = "FUSER";
    TextButton6.TextColor3 = Color3.fromRGB(236, 236, 236);
    TextButton6.TextScaled = true;
    TextButton6.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextButton6.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton6.ZIndex = 10;
    TextButton6.Parent = Frame27;
    local TextButton7 = Instance.new("TextButton");
    TextButton7.Name = "Tip";
    TextButton7.Active = false;
    TextButton7.AnchorPoint = Vector2.new(1, 1);
    TextButton7.BackgroundTransparency = 1;
    TextButton7.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Light, Enum.FontStyle.Normal);
    TextButton7.Position = UDim2.fromScale(0.99, 0.994);
    TextButton7.Selectable = false;
    TextButton7.Size = UDim2.fromScale(0.5, 0.08);
    TextButton7.Text = "Click for more";
    TextButton7.TextColor3 = Color3.new(1, 1, 1);
    TextButton7.TextScaled = true;
    TextButton7.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextButton7.TextTransparency = 0.8;
    TextButton7.TextXAlignment = Enum.TextXAlignment.Right;
    TextButton7.ZIndex = 343;
    TextButton7.Parent = Frame27;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "ItemName";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.5, 0.85797);
    TextLabel5.Size = UDim2.fromScale(0.9, 0.0920297);
    TextLabel5.Text = "Level up your skins!";
    TextLabel5.TextColor3 = Color3.fromRGB(222, 222, 222);
    TextLabel5.TextScaled = true;
    TextLabel5.TextStrokeTransparency = 0.85;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.ZIndex = 10;
    TextLabel5.Parent = Frame27;
    local Frame28 = Instance.new("Frame");
    Frame28.Name = "Frame";
    Frame28.AnchorPoint = Vector2.new(0.5, 0);
    Frame28.BackgroundColor3 = Color3.fromRGB(195, 144, 85);
    Frame28.BackgroundTransparency = 0.5;
    Frame28.BorderColor3 = Color3.new();
    Frame28.BorderSizePixel = 0;
    Frame28.Position = UDim2.fromScale(0.5, 0);
    Frame28.Size = UDim2.fromScale(1, 1);
    Frame28.ZIndex = -1;
    local UIGradient4 = Instance.new("UIGradient");
    UIGradient4.Name = "UIGradient";
    UIGradient4.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(98, 98, 98)) });
    UIGradient4.Rotation = 45;
    UIGradient4.Parent = Frame28;
    local ImageButton13 = Instance.new("ImageButton");
    ImageButton13.Name = "Blur";
    ImageButton13.Active = false;
    ImageButton13.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton13.AutoButtonColor = false;
    ImageButton13.AutoLocalize = false;
    ImageButton13.BackgroundTransparency = 1;
    ImageButton13.Image = "rbxassetid://6430908053";
    ImageButton13.ImageColor3 = Color3.fromRGB(195, 144, 85);
    ImageButton13.ImageTransparency = 0.6;
    ImageButton13.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton13.ScaleType = Enum.ScaleType.Fit;
    ImageButton13.Size = UDim2.fromScale(1, 1);
    ImageButton13.ZIndex = 3;
    ImageButton13.Parent = Frame28;
    Frame28.Parent = Frame27;
    local Frame29 = Instance.new("Frame");
    Frame29.Name = "Frame";
    Frame29.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame29.BackgroundTransparency = 1;
    Frame29.Position = UDim2.fromScale(0.5, 0.5);
    Frame29.Size = UDim2.new(1, -10, 1, -20);
    Frame29.Parent = Frame22;
    Frame27.Parent = Frame22;
    Frame22.Parent = u18;
    u18.Parent = u15;
    u19 = u18:Clone();
    u19.Name = "PlusFrame";
    u19.Main.Main.Icon.Image = u34.GetItem("Badges", "Golden Plus").Asset;
    u19.Main.Main.Title.Text = "ROBLOX PLUS";
    u19.Main.Main.ItemName.Text = "Subscribe for the golden badge!";
    u19.Main.Main.Frame.BackgroundColor3 = Color3.fromRGB(214, 171, 82);
    u19.Main.Main.Frame.Blur.ImageColor3 = Color3.fromRGB(214, 171, 82);
    u19.Parent = u15;
    u15.Parent = u7;
end;

function u1.rewardButton(p84, p85, p86, p87, p88) -- Line: 2498
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = p85;
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.fromRGB(50, 51, 57);
    ImageButton.BackgroundTransparency = 0.1;
    ImageButton.InputSink = Enum.InputSink.None;
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(1, 0.3);
    ImageButton.LayoutOrder = p88 or 0;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner.BottomRightRadius = UDim.new(0.1, 0);
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.TopLeftRadius = UDim.new(0.1, 0);
    UICorner.TopRightRadius = UDim.new(0.1, 0);
    UICorner.Parent = ImageButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(117, 117, 117);
    UIStroke.Transparency = 0.25;
    UIStroke.Parent = ImageButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = p87;
    ImageLabel.ImageColor3 = Color3.fromRGB(236, 236, 236);
    ImageLabel.Position = UDim2.fromScale(0.05, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.65, 0.65);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.InputSink = Enum.InputSink.Activate;
    TextLabel.Position = UDim2.fromScale(0.275, 0.5);
    TextLabel.Size = UDim2.fromScale(0.6, 0.425);
    TextLabel.Text = p86;
    TextLabel.TextColor3 = Color3.fromRGB(236, 236, 236);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 343;
    TextLabel.Parent = ImageButton;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "RightArrow";
    ImageButton2.AnchorPoint = Vector2.new(1, 0.5);
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://122092056328472";
    ImageButton2.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageButton2.Position = UDim2.fromScale(0.95, 0.5);
    ImageButton2.Rotation = 180;
    ImageButton2.ScaleType = Enum.ScaleType.Fit;
    ImageButton2.Size = UDim2.fromScale(0.3, 0.3);
    ImageButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton2.Parent = ImageButton;
    ImageButton.Parent = p84;

    return ImageButton;
end;

function u1.bundleButton(p89, p90, p91) -- Line: 2574
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = p91;
    ImageButton.Active = false;
    ImageButton.BackgroundColor3 = Color3.new();
    ImageButton.BackgroundTransparency = 0.7;
    ImageButton.BorderColor3 = Color3.new();
    ImageButton.BorderSizePixel = 0;
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(0.6, 0.6);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton.LayoutOrder = p90;
    local Frame = Instance.new("Frame");
    Frame.Name = "Bar";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.2;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Visible = true;
    Frame.Parent = ImageButton;
    ImageButton.Parent = p89;

    return ImageButton;
end;

return u1;