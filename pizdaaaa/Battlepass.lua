-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.Battlepass
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.Battlepass
-- Decompile time: 62.19 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("HttpService");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;

local function HasRobloxSubscription() -- Line: 18
    -- upvalues: RunService (copy), LocalPlayer (copy)
    return RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription;
end;

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
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = nil;
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = nil;
local u36 = nil;
local u37 = {
    Free = Color3.fromRGB(151, 191, 255),
    Premium = Color3.fromRGB(255, 223, 149),
    White = Color3.fromRGB(255, 255, 255)
};
local u38 = false;
local u39 = nil;
TweenInfo.new(0.25);
TweenInfo.new(0.5);
TweenInfo.new(1);
local u40 = nil;
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = nil;

local function lerp(p45, p46, p47) -- Line: 56
    return p45 + (p46 - p45) * p47;
end;

local function hasSomethingToClaim() -- Line: 60
    -- upvalues: u3 (ref)
    local PlayerBattlepass_Rewards = PlayerBattlepass.Rewards;
    local Levels = u3.Levels;
    local v48 = 0;

    for i, _ in Levels do
        v48 = v48 + Levels[i].XP;

        if v48 <= PlayerBattlepass.XP then
            local _ = Levels[i].Rewards;
            local v49 = i;

            for _, v in hasPremium and { "Free", "Premium" } or { "Free" } do
                if not PlayerBattlepass_Rewards[v][tostring(v49)] then
                    return true;
                end;
            end;
        end;
    end;

    return false;
end;

function u1.Draw() -- Line: 90
    -- upvalues: u4 (ref), u3 (ref), u13 (ref), u20 (ref), u18 (ref), u17 (ref), u22 (ref), u1 (copy), u7 (ref), u8 (ref), u42 (ref), u37 (copy), u43 (ref), u39 (ref), u40 (ref), u35 (ref), u36 (ref), TweenService (copy), u41 (ref), u5 (ref), u44 (ref), UserInputService (copy), u19 (ref), u15 (ref), u23 (ref), u14 (ref), u38 (ref), u16 (ref), u27 (ref)
    u4:Removes(
        "Claiming",
        "BuyPremiumMouseEnter",
        "BuyPremiumMouseLeave",
        "BuyPremiumButton1Click",
        "ClaimAllMouseEnter",
        "ClaimAllMouseLeave",
        "ClaimAllButton1Click",
        "BuyTiersMouseEnter",
        "BuyTiersMouseLeave",
        "BuyTiersButton1Click"
    );
    local v50 = u3.Until - DateTime.now().UnixTimestamp;

    if v50 <= 0 then
        u13.Text = "Ended";
    else
        u13.Text = `{math.round(v50 / 86400)} days`;
    end;

    local PlayerBattlepass_XP = PlayerBattlepass.XP;
    local v51 = 1;
    local v52 = 0;

    for i, v in u3.Levels do
        if v.XP > PlayerBattlepass_XP then
            v52 = v.XP;
            break;
        end;

        PlayerBattlepass_XP = PlayerBattlepass_XP - v.XP;
        v51 = i;
    end;

    u20.Size = UDim2.fromScale(math.clamp(PlayerBattlepass_XP / v52, 0, 1) or 0, 1);
    u18.Text = `{PlayerBattlepass_XP} / {v52}  XP to next level`;
    u17.Text = `LEVEL {v51}`;
    local Levels = u3.Levels;
    local v53 = 0;

    for i, _ in Levels do
        local v54 = u22:FindFirstChild(i) or u1.tierFrame();
        local Main = v54.Main;
        local Rewards = Levels[i].Rewards;
        v54.Name = i;
        v53 = v53 + Levels[i].XP;
        local v55 = v53 <= PlayerBattlepass.XP;
        local u56 = i;

        for _, v in { "Free", "Premium" } do
            u4:Removes(`{u56}{v}MouseEnter`, `{u56}{v}MouseLeave`, (`{u56}{v}Button1Click`));
            local u57 = Main[v];
            local v58 = Rewards[v];
            local u59 = v58[1];
            local u60 = v58[2];

            if u59 == "Credits" then
                u57.Icon.Image = `rbxassetid://{138240378050344}`;
                u57.TextLabel.Text = `{u60}`;
            elseif u59 == "Item" or (u59 == "Container" or u59 == "Graphic Art") then
                local v61, v62 = unpack(u60:split("_"));
                local v63 = u7.GetItem(v61, v62) or u8.GetWeaponSkin(v61, v62);
                local v64 = u7.GetCategory(v61) or u42.Get(v61);
                u57.TextLabel.Text = `{v64.DisplayName or v61} | {v63.DisplayName or v62}`;
            end;

            if v == "Premium" then
                if hasPremium then
                    u57.Icon.ImageTransparency = 0.03;
                    u57.TextLabel.TextTransparency = 0;
                    u57.Locked.Visible = false;
                else
                    u57.Icon.ImageTransparency = 0.6;
                    u57.TextLabel.TextTransparency = 0.6;
                    u57.Locked.Visible = true;
                end;
            end;

            if v55 then
                u57.BackgroundColor3 = u37[v];
                u57.BackgroundTransparency = 0.4;
                u57.UIGradient.Enabled = true;
                u57.UIStroke.Color = u37[v];
                u57.UIStroke.Transparency = 0.2;

                if v ~= "Premium" or hasPremium then
                    if PlayerBattlepass.Rewards[v][tostring(u56)] and true or false then
                        u57.Claimed.Visible = true;
                    else
                        local Hitbox = u57.Hitbox;
                        u43.AddNotice("Rewards");
                        u57.Claimed.Visible = false;
                        u4:Add(`{u56}{v}MouseEnter`, Hitbox.MouseEnter:Connect(function() -- Line: 210
                            -- upvalues: u39 (ref), Hitbox (copy), u40 (ref), u35 (ref), u57 (copy), u36 (ref), u37 (ref), v (copy), TweenService (ref), u41 (ref)
                            u39 = Hitbox;

                            if u40.PlaybackState == Enum.PlaybackState.Playing then
                                u40.Completed:Wait();
                            end;

                            if u39 ~= Hitbox then
                                return;
                            end;

                            u35.Parent = u57;
                            u36.Position = UDim2.fromScale(-0.75, -0.75);
                            u36.BackgroundColor3 = u37[v];
                            TweenService:Create(u36, TweenInfo.new(0.25), {
                                Position = UDim2.fromScale(-0.6, -0.6)
                            }):Play();
                            u41.Play("UI.submenu_dropdown_rollover");
                        end));
                        u4:Add(`{u56}{v}MouseLeave`, Hitbox.MouseLeave:Connect(function() -- Line: 232
                            -- upvalues: u40 (ref), u4 (ref)
                            u40:Play();

                            if claimingTask then
                                task.cancel(claimingTask);
                            end;

                            if claimingTween then
                                claimingTween:Cancel();
                            end;

                            u4:Removes("Claiming");
                        end));
                        u4:Add(`{u56}{v}Button1Click`, Hitbox.MouseButton1Down:Connect(function() -- Line: 244
                            -- upvalues: u40 (ref), u41 (ref), TweenService (ref), u36 (ref), u57 (copy), u5 (ref), v (copy), u56 (copy), u44 (ref), u59 (copy), u60 (copy), u1 (ref), u4 (ref), UserInputService (ref)
                            if u40.PlaybackState == Enum.PlaybackState.Playing then
                                return;
                            end;

                            u41.Play("UI.submenu_dropdown_rollover");
                            claimingTween = TweenService:Create(u36, TweenInfo.new(0.8), {
                                Position = UDim2.fromScale(0.3, 0.3)
                            });
                            claimingTween:Play();
                            claimingTask = task.delay(0.8, function() -- Line: 253
                                -- upvalues: u57 (ref), u5 (ref), v (ref), u56 (ref), u41 (ref), u44 (ref), u59 (ref), u60 (ref), u40 (ref), u1 (ref), u4 (ref)
                                u57.Claimed.Visible = true;
                                u5.Gui.ClaimBattlepassReward.Fire({
                                    P = v == "Premium",
                                    I = tonumber(u56)
                                });
                                u41.Play("UI.submenu_click");
                                u44.RewardsNotifications({
                                    { u59, u60 }
                                });
                                u40:Play();
                                u1.UpdateClaimAllButton();
                                u4:Removes("Claiming", `{u56}{v}MouseEnter`, `{u56}{v}MouseLeave`, (`{u56}{v}Button1Click`));
                            end);
                            u4:Add("Claiming", UserInputService.InputEnded:Connect(function(p65) -- Line: 272
                                -- upvalues: TweenService (ref), u36 (ref), u4 (ref)
                                if p65.UserInputType ~= Enum.UserInputType.MouseButton1 then
                                    return;
                                end;

                                TweenService:Create(u36, TweenInfo.new(0.25), {
                                    Position = UDim2.fromScale(-0.6, -0.6)
                                }):Play();

                                if claimingTask then
                                    task.cancel(claimingTask);
                                end;

                                claimingTween:Cancel();
                                u4:Removes("Claiming");
                            end));
                        end));
                    end;
                end;
            else
                u57.BackgroundColor3 = u37.White;
                u57.BackgroundTransparency = 0.95;
                u57.UIGradient.Enabled = false;
                u57.UIStroke.Color = u37.White;
                u57.UIStroke.Transparency = 0.8;
            end;
        end;

        v54.Tier.Text = `TIER {u56}`;
        local v66 = -1;

        if u56 <= v51 then
            v66 = 1;
        elseif u56 == v51 + 1 then
            v66 = math.clamp(PlayerBattlepass_XP / v52, 0, 1);
        end;

        Main.Frame.UIGradient.Offset = Vector2.new(-0.5 + 1.05 * v66, 1);
        v54.LayoutOrder = u56;
        v54.Visible = true;
        v54.Parent = u22;
    end;

    if hasPremium then
        u19.Visible = true;
        u19.TextTransparency = 1;
        TweenService:Create(u19, TweenInfo.new(1), {
            TextTransparency = 0
        }):Play();
        TweenService:Create(u15, TweenInfo.new(0.5), {
            Transparency = 1
        }):Play();
        TweenService:Create(u15.Title, TweenInfo.new(0.5), {
            Transparency = 1
        }):Play();
        TweenService:Create(u15.UIStroke, TweenInfo.new(0.5), {
            Transparency = 1
        }):Play();
        task.delay(0.5, function() -- Line: 316
            -- upvalues: u15 (ref)
            u15.Visible = false;
        end);
    else
        u15.Visible = true;
        u19.Visible = false;
        u4:Add("BuyPremiumMouseEnter", u15.MouseEnter:Connect(function() -- Line: 323
            -- upvalues: u41 (ref), TweenService (ref), u15 (ref)
            u41.Play("UI.submenu_dropdown_rollover");
            TweenService:Create(u15, TweenInfo.new(0.25), {
                Transparency = 0.15
            }):Play();
        end));
        u4:Add("BuyPremiumMouseLeave", u15.MouseLeave:Connect(function() -- Line: 328
            -- upvalues: TweenService (ref), u15 (ref)
            TweenService:Create(u15, TweenInfo.new(0.25), {
                Transparency = 0.2
            }):Play();
        end));
        u4:Add("BuyPremiumButton1Click", u15.MouseButton1Click:Connect(function() -- Line: 332
            -- upvalues: u23 (ref), u41 (ref), u1 (ref)
            if u23.Visible then
                return;
            end;

            u41.Play("UI.mainmenu_rollover");
            u1.PurchasePremiumPassVisible();
        end));
    end;

    u4:Add("ClaimAllMouseEnter", u14.MouseEnter:Connect(function() -- Line: 343
        -- upvalues: u38 (ref), TweenService (ref), u14 (ref), u41 (ref)
        if not u38 then
            return;
        end;

        TweenService:Create(u14, TweenInfo.new(0.25), {
            Transparency = 0.9
        }):Play();
        u41.Play("UI.submenu_dropdown_rollover");
    end));
    u4:Add("ClaimAllMouseLeave", u14.MouseLeave:Connect(function() -- Line: 352
        -- upvalues: u38 (ref), TweenService (ref), u14 (ref)
        if not u38 then
            return;
        end;

        TweenService:Create(u14, TweenInfo.new(0.25), {
            Transparency = 0.95
        }):Play();
    end));
    u4:Add("ClaimAllButton1Click", u14.MouseButton1Down:Connect(function() -- Line: 360
        -- upvalues: u38 (ref), u41 (ref), u14 (ref), TweenService (ref), u5 (ref), Levels (copy), u4 (ref), UserInputService (ref)
        if not u38 then
            return;
        end;

        u41.Play("UI.submenu_dropdown_rollover");
        local Frame = u14.Claiming.Frame;
        claimingTween = TweenService:Create(Frame, TweenInfo.new(1.6), {
            Position = UDim2.fromScale(0.5, -2.5)
        });
        claimingTween:Play();
        claimingTask = task.delay(1.6, function() -- Line: 371
            -- upvalues: u5 (ref), u41 (ref), Levels (ref), TweenService (ref), Frame (copy)
            u5.Gui.ClaimAllBattlepassRewards.Fire();
            u41.Play("UI.submenu_click");
            task.defer(function() -- Line: 377
                -- upvalues: Levels (ref)
                local PlayerBattlepass_Rewards = PlayerBattlepass.Rewards;

                for i, _ in Levels do
                    local v67 = i;
                    local v68 = 0;

                    for i2 = 1, i do
                        v68 = v68 + Levels[i2].XP;
                        local _ = i2;
                    end;

                    if v68 <= PlayerBattlepass.XP then
                        local Rewards = Levels[v67].Rewards;

                        for _, v in hasPremium and { "Free", "Premium" } or { "Free" } do
                            if not PlayerBattlepass_Rewards[v][tostring(v67)] then
                                PlayerBattlepass_Rewards.RewardsNotifications({ Rewards[v] });
                                task.wait(0.2);
                            end;
                        end;
                    end;
                end;
            end);
            TweenService:Create(Frame, TweenInfo.new(0.25), {
                Position = UDim2.fromScale(-0.825, -2.5)
            }):Play();
        end);
        u4:Add("Claiming", UserInputService.InputEnded:Connect(function(p69) -- Line: 410
            -- upvalues: TweenService (ref), Frame (copy), u4 (ref)
            if p69.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return;
            end;

            TweenService:Create(Frame, TweenInfo.new(0.25), {
                Position = UDim2.fromScale(-0.825, -2.5)
            }):Play();

            if claimingTask then
                task.cancel(claimingTask);
            end;

            claimingTween:Cancel();
            u4:Removes("Claiming");
        end));
    end));
    u4:Add("BuyTiersMouseEnter", u16.MouseEnter:Connect(function() -- Line: 429
        -- upvalues: u41 (ref), TweenService (ref), u16 (ref)
        u41.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u16, TweenInfo.new(0.25), {
            Transparency = 0.6
        }):Play();
    end));
    u4:Add("BuyTiersMouseLeave", u16.MouseLeave:Connect(function() -- Line: 434
        -- upvalues: TweenService (ref), u16 (ref)
        TweenService:Create(u16, TweenInfo.new(0.25), {
            Transparency = 0.85
        }):Play();
    end));
    u4:Add("BuyTiersButton1Click", u16.MouseButton1Click:Connect(function() -- Line: 438
        -- upvalues: u27 (ref), u41 (ref), u1 (ref)
        if u27.Visible then
            return;
        end;

        u41.Play("UI.mainmenu_rollover");
        u1.PurchaseTiersVisible();
    end));
    u1.UpdateClaimAllButton();
end;

function u1.Update() -- Line: 451
    -- upvalues: u3 (ref), u20 (ref), u18 (ref), u17 (ref), u22 (ref), u4 (ref), u37 (copy), u43 (ref), u39 (ref), u40 (ref), u35 (ref), u36 (ref), TweenService (copy), u41 (ref), u5 (ref), u44 (ref), u1 (copy), UserInputService (copy)
    local PlayerBattlepass_XP = PlayerBattlepass.XP;
    local v70 = 1;
    local v71 = 0;

    for i, v in u3.Levels do
        if v.XP > PlayerBattlepass_XP then
            v71 = v.XP;
            break;
        end;

        PlayerBattlepass_XP = PlayerBattlepass_XP - v.XP;
        v70 = i;
    end;

    u20.Size = UDim2.fromScale(math.clamp(PlayerBattlepass_XP / v71, 0, 1) or 0, 1);
    u18.Text = `{PlayerBattlepass_XP} / {v71}  XP to next level`;
    u17.Text = `LEVEL {v70}`;
    local Levels = u3.Levels;
    local v72 = 0;

    for i, _ in Levels do
        local v73 = u22:FindFirstChild(i);
        local Main = v73.Main;
        local Rewards = Levels[i].Rewards;
        v73.Name = i;
        v72 = v72 + Levels[i].XP;
        local v74 = v72 <= PlayerBattlepass.XP;
        local u75 = i;

        for _, v in { "Free", "Premium" } do
            u4:Removes(`{u75}{v}MouseEnter`, `{u75}{v}MouseLeave`, (`{u75}{v}Button1Click`));
            local u76 = Main[v];

            if v74 then
                u76.BackgroundColor3 = u37[v];
                u76.BackgroundTransparency = 0.4;
                u76.UIGradient.Enabled = true;
                u76.UIStroke.Color = u37[v];
                u76.UIStroke.Transparency = 0.2;
                local v77 = PlayerBattlepass.Rewards[v][tostring(u75)] and true or false;
                local u78;

                if v == "Premium" then
                    if hasPremium then
                        u76.Icon.ImageTransparency = 0.03;
                        u76.TextLabel.TextTransparency = 0;
                        u76.Locked.Visible = false;

                        if v77 then
                            u76.Claimed.Visible = true;
                        else
                            u78 = u76.Hitbox;
                            u43.AddNotice("Rewards");
                            u76.Claimed.Visible = false;
                            u4:Add(`{u75}{v}MouseEnter`, u78.MouseEnter:Connect(function() -- Line: 525
                                -- upvalues: u39 (ref), u78 (copy), u40 (ref), u35 (ref), u76 (copy), u36 (ref), u37 (ref), v (copy), TweenService (ref), u41 (ref)
                                u39 = u78;

                                if u40.PlaybackState == Enum.PlaybackState.Playing then
                                    u40.Completed:Wait();
                                end;

                                if u39 ~= u78 then
                                    return;
                                end;

                                u35.Parent = u76;
                                u36.Position = UDim2.fromScale(-0.75, -0.75);
                                u36.BackgroundColor3 = u37[v];
                                TweenService:Create(u36, TweenInfo.new(0.25), {
                                    Position = UDim2.fromScale(-0.6, -0.6)
                                }):Play();
                                u41.Play("UI.submenu_dropdown_rollover");
                            end));
                            u4:Add(`{u75}{v}MouseLeave`, u78.MouseLeave:Connect(function() -- Line: 546
                                -- upvalues: u40 (ref), TweenService (ref), u36 (ref), u4 (ref)
                                u40 = TweenService:Create(u36, TweenInfo.new(0.25), {
                                    Position = UDim2.fromScale(-0.75, -0.75)
                                });
                                u40:Play();

                                if claimingTask then
                                    task.cancel(claimingTask);
                                end;

                                if claimingTween then
                                    claimingTween:Cancel();
                                end;

                                u4:Removes("Claiming");
                            end));
                            u4:Add(`{u75}{v}Button1Click`, u78.MouseButton1Down:Connect(function() -- Line: 559
                                -- upvalues: u40 (ref), u41 (ref), TweenService (ref), u36 (ref), u76 (copy), u5 (ref), v (copy), u75 (copy), u44 (ref), Rewards (copy), u1 (ref), u4 (ref), UserInputService (ref)
                                if u40.PlaybackState == Enum.PlaybackState.Playing then
                                    return;
                                end;

                                u41.Play("UI.submenu_dropdown_rollover");
                                claimingTween = TweenService:Create(u36, TweenInfo.new(0.8), {
                                    Position = UDim2.fromScale(0.3, 0.3)
                                });
                                claimingTween:Play();
                                claimingTask = task.delay(0.8, function() -- Line: 568
                                    -- upvalues: u76 (ref), u5 (ref), v (ref), u75 (ref), u41 (ref), u44 (ref), Rewards (ref), u40 (ref), u1 (ref), u4 (ref)
                                    u76.Claimed.Visible = true;
                                    u5.Gui.ClaimBattlepassReward.Fire({
                                        P = v == "Premium",
                                        I = tonumber(u75)
                                    });
                                    u41.Play("UI.submenu_click");
                                    u44.RewardsNotifications({ Rewards[v] });
                                    u40:Play();
                                    u1.UpdateClaimAllButton();
                                    u4:Removes("Claiming", `{u75}{v}MouseEnter`, `{u75}{v}MouseLeave`, (`{u75}{v}Button1Click`));
                                end);
                                u4:Add("Claiming", UserInputService.InputEnded:Connect(function(p79) -- Line: 587
                                    -- upvalues: TweenService (ref), u36 (ref), u4 (ref)
                                    if p79.UserInputType ~= Enum.UserInputType.MouseButton1 then
                                        return;
                                    end;

                                    TweenService:Create(u36, TweenInfo.new(0.25), {
                                        Position = UDim2.fromScale(-0.6, -0.6)
                                    }):Play();

                                    if claimingTask then
                                        task.cancel(claimingTask);
                                    end;

                                    claimingTween:Cancel();
                                    u4:Removes("Claiming");
                                end));
                            end));
                        end;
                    end;
                elseif v77 then
                    u76.Claimed.Visible = true;
                else
                    u78 = u76.Hitbox;
                    u43.AddNotice("Rewards");
                    u76.Claimed.Visible = false;
                    u4:Add(`{u75}{v}MouseEnter`, u78.MouseEnter:Connect(function() -- Line: 525
                        -- upvalues: u39 (ref), u78 (copy), u40 (ref), u35 (ref), u76 (copy), u36 (ref), u37 (ref), v (copy), TweenService (ref), u41 (ref)
                        u39 = u78;

                        if u40.PlaybackState == Enum.PlaybackState.Playing then
                            u40.Completed:Wait();
                        end;

                        if u39 ~= u78 then
                            return;
                        end;

                        u35.Parent = u76;
                        u36.Position = UDim2.fromScale(-0.75, -0.75);
                        u36.BackgroundColor3 = u37[v];
                        TweenService:Create(u36, TweenInfo.new(0.25), {
                            Position = UDim2.fromScale(-0.6, -0.6)
                        }):Play();
                        u41.Play("UI.submenu_dropdown_rollover");
                    end));
                    u4:Add(`{u75}{v}MouseLeave`, u78.MouseLeave:Connect(function() -- Line: 546
                        -- upvalues: u40 (ref), TweenService (ref), u36 (ref), u4 (ref)
                        u40 = TweenService:Create(u36, TweenInfo.new(0.25), {
                            Position = UDim2.fromScale(-0.75, -0.75)
                        });
                        u40:Play();

                        if claimingTask then
                            task.cancel(claimingTask);
                        end;

                        if claimingTween then
                            claimingTween:Cancel();
                        end;

                        u4:Removes("Claiming");
                    end));
                    u4:Add(`{u75}{v}Button1Click`, u78.MouseButton1Down:Connect(function() -- Line: 559
                        -- upvalues: u40 (ref), u41 (ref), TweenService (ref), u36 (ref), u76 (copy), u5 (ref), v (copy), u75 (copy), u44 (ref), Rewards (copy), u1 (ref), u4 (ref), UserInputService (ref)
                        if u40.PlaybackState == Enum.PlaybackState.Playing then
                            return;
                        end;

                        u41.Play("UI.submenu_dropdown_rollover");
                        claimingTween = TweenService:Create(u36, TweenInfo.new(0.8), {
                            Position = UDim2.fromScale(0.3, 0.3)
                        });
                        claimingTween:Play();
                        claimingTask = task.delay(0.8, function() -- Line: 568
                            -- upvalues: u76 (ref), u5 (ref), v (ref), u75 (ref), u41 (ref), u44 (ref), Rewards (ref), u40 (ref), u1 (ref), u4 (ref)
                            u76.Claimed.Visible = true;
                            u5.Gui.ClaimBattlepassReward.Fire({
                                P = v == "Premium",
                                I = tonumber(u75)
                            });
                            u41.Play("UI.submenu_click");
                            u44.RewardsNotifications({ Rewards[v] });
                            u40:Play();
                            u1.UpdateClaimAllButton();
                            u4:Removes("Claiming", `{u75}{v}MouseEnter`, `{u75}{v}MouseLeave`, (`{u75}{v}Button1Click`));
                        end);
                        u4:Add("Claiming", UserInputService.InputEnded:Connect(function(p79) -- Line: 587
                            -- upvalues: TweenService (ref), u36 (ref), u4 (ref)
                            if p79.UserInputType ~= Enum.UserInputType.MouseButton1 then
                                return;
                            end;

                            TweenService:Create(u36, TweenInfo.new(0.25), {
                                Position = UDim2.fromScale(-0.6, -0.6)
                            }):Play();

                            if claimingTask then
                                task.cancel(claimingTask);
                            end;

                            claimingTween:Cancel();
                            u4:Removes("Claiming");
                        end));
                    end));
                end;
            end;
        end;

        local v80 = -1;

        if u75 <= v70 then
            v80 = 1;
        elseif u75 == v70 + 1 then
            v80 = math.clamp(PlayerBattlepass_XP / v71, 0, 1);
        end;

        Main.Frame.UIGradient.Offset = Vector2.new(-0.5 + 1.05 * v80, 1);
    end;

    u1.UpdateClaimAllButton();
end;

function u1.UpdateClaimAllButton() -- Line: 620
    -- upvalues: u38 (ref), hasSomethingToClaim (copy), TweenService (copy), u14 (ref)
    u38 = hasSomethingToClaim();
    TweenService:Create(u14.Title, TweenInfo.new(0.25), {
        TextTransparency = u38 and 0 or 0.5
    }):Play();
end;

function u1.DrawPurchaseTiers() -- Line: 625
    -- upvalues: u3 (ref), u1 (copy)
    local TiersPrice = u3.TiersPrice;
    local v81 = 0;

    for i, v in TiersPrice do
        u1.tierPurchase(i, v.Tiers, v81);
        v81 = v81 + 1 / (#TiersPrice - 1);
    end;
end;

function u1.PurchaseTiersVisible() -- Line: 636
    -- upvalues: u23 (ref), u27 (ref), u3 (ref), u32 (ref), u30 (ref), RunService (copy), LocalPlayer (copy), u33 (ref), u29 (ref), u28 (ref), UserInputService (copy), u4 (ref), TweenService (copy), u10 (ref), u11 (ref), u5 (ref), u1 (copy), u31 (ref), u21 (ref)
    if u23.Visible then
        return;
    end;

    local Visible = u27.Visible;

    if Visible then
        for i = 1, 3 do
            u4:Removes(`TP{i}MouseEnter`, `TP{i}MouseLeave`, (`TP{i}Button1Click`));
            local _ = i;
        end;

        u4:Removes("TPCloseMouseEnter", "TPCloseMouseLeave", "TPCloseButton1Click");
    else
        local TiersPrice = u3.TiersPrice;
        local u82 = 1;

        local function Update() -- Line: 648
            -- upvalues: u32 (ref), u82 (ref), TiersPrice (copy), u30 (ref), RunService (ref), LocalPlayer (ref), u33 (ref), u29 (ref)
            local v83 = u32[u82];
            local v84 = TiersPrice[u82];
            u30.Credits.Title.RichText = true;

            if (RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription) and typeof(v84.Credits) == "number" then
                u30.Credits.Title.Text = `<s>{v84.Credits}</s> {math.floor(v84.Credits * 0.9)}`;
            else
                u30.Credits.Title.Text = v84.Credits;
            end;

            u30.Robux.Title.Text = v84.Robux;
            u33.Parent = v83;
            u29.Text = `PURCHASE +{v84.Tiers} TIER`;
        end;

        local AbsolutePosition = u28.AbsolutePosition;
        local AbsoluteSize = u28.AbsoluteSize;
        local Vector2_new_ret = Vector2.new(AbsolutePosition.X + AbsoluteSize.X, AbsolutePosition.Y + AbsoluteSize.Y / 1.2);
        local u85 = AbsolutePosition + Vector2.new(0, AbsoluteSize.Y / 3);
        local MouseLocation = UserInputService:GetMouseLocation();

        local function Upd() -- Line: 671
            -- upvalues: TiersPrice (copy), u32 (ref), MouseLocation (ref), u82 (ref), Update (copy)
            local v86 = 10000;
            local v87 = 1;

            for i = 1, #TiersPrice do
                local math_abs_ret = math.abs(MouseLocation.X - u32[i].AbsolutePosition.X);
                local v88;

                if math_abs_ret < v86 then
                    v87 = i;
                    v86 = math_abs_ret;
                    v88 = v87;
                    local v89 = v87;
                    v87 = v88;
                    v89 = v88;
                else
                    v88 = i;
                end;
            end;

            u82 = v87;
            Update();
        end;

        Update();
        u4:Add("Start", UserInputService.InputBegan:Connect(function(p90: userdata) -- Line: 695
            -- upvalues: MouseLocation (ref), UserInputService (ref), u85 (ref), Vector2_new_ret (copy), Upd (copy), u4 (ref)
            if p90.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return;
            end;

            MouseLocation = UserInputService:GetMouseLocation();

            if MouseLocation.X < u85.X or (MouseLocation.Y < u85.Y or (MouseLocation.X > Vector2_new_ret.X or MouseLocation.Y > Vector2_new_ret.Y)) then
                return;
            end;

            Upd();
            u4:Add("InputChanged", UserInputService.InputChanged:Connect(function(p91) -- Line: 707
                -- upvalues: MouseLocation (ref), UserInputService (ref), u85 (ref), Vector2_new_ret (ref), u4 (ref), Upd (ref)
                if p91.UserInputType ~= Enum.UserInputType.MouseMovement then
                    return;
                end;

                MouseLocation = UserInputService:GetMouseLocation();

                if MouseLocation.X >= u85.X and (MouseLocation.Y >= u85.Y and (MouseLocation.X <= Vector2_new_ret.X and MouseLocation.Y <= Vector2_new_ret.Y)) then
                    Upd();

                    return;
                end;

                u4:Removes("InputChanged", "End");
            end));
            u4:Add("End", UserInputService.InputEnded:Connect(function(p92) -- Line: 721
                -- upvalues: u4 (ref)
                if p92.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return;
                end;

                u4:Removes("InputChanged", "End");
            end));
        end));

        for i, v in { u30.Credits, u30.Robux, u30.Gift } do
            u4:Add(`TP{i}MouseEnter`, v.MouseEnter:Connect(function() -- Line: 731
                -- upvalues: TweenService (ref), v (copy)
                TweenService:Create(v, TweenInfo.new(0.5), {
                    BackgroundTransparency = 0.9
                }):Play();
            end));
            u4:Add(`TP{i}MouseLeave`, v.MouseLeave:Connect(function() -- Line: 734
                -- upvalues: TweenService (ref), v (copy)
                TweenService:Create(v, TweenInfo.new(0.5), {
                    BackgroundTransparency = 0.95
                }):Play();
            end));

            if i == 3 then
                u4:Add(`TP{i}Button1Click`, v.MouseButton1Click:Connect(function() -- Line: 739
                end));
            else
                u4:Add(`TP{i}Button1Click`, v.MouseButton1Click:Connect(function() -- Line: 743
                    -- upvalues: u3 (ref), u82 (ref), RunService (ref), LocalPlayer (ref), i (copy), u10 (ref), u11 (ref), u5 (ref), u1 (ref)
                    local u93 = u3.TiersPrice[u82];
                    local Credits = u93.Credits;

                    if RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription then
                        Credits = math.floor(Credits * 0.9) or Credits;
                    end;

                    if i == 1 and u10.Get("Credits") < Credits then
                        u11:Create("Not Enough Credits", Color3.fromRGB(255, 151, 153));

                        return;
                    end;

                    u5.Gui.BuyBattlepassTiers.Fire(u82);

                    if i == 1 then
                        task.spawn(function() -- Line: 757
                            -- upvalues: u11 (ref), Credits (copy), u93 (copy)
                            u11:Create(`-${Credits}`, Color3.fromRGB(255, 151, 153));
                            task.wait(0.2);
                            u11:Create(`Successfully Purchased {u93.Tiers} Battlepass Tiers`, Color3.fromRGB(255, 223, 149));
                        end);
                    end;

                    u1.PurchaseTiersVisible();
                end));
            end;
        end;

        u4:Add("TPCloseMouseEnter", u31.MouseEnter:Connect(function() -- Line: 771
            -- upvalues: TweenService (ref), u31 (ref)
            TweenService:Create(u31, TweenInfo.new(0.5), {
                Transparency = 0.9
            }):Play();
        end));
        u4:Add("TPCloseMouseLeave", u31.MouseLeave:Connect(function() -- Line: 774
            -- upvalues: TweenService (ref), u31 (ref)
            TweenService:Create(u31, TweenInfo.new(0.5), {
                Transparency = 0.95
            }):Play();
        end));
        u4:Add("TPCloseButton1Click", u31.MouseButton1Click:Connect(function() -- Line: 778
            -- upvalues: u1 (ref)
            u1.PurchaseTiersVisible();
        end));
    end;

    TweenService:Create(u21, TweenInfo.new(Visible and 0.5 or 0.25), {
        GroupTransparency = Visible and 0 or 1
    }):Play();
    TweenService:Create(u27, TweenInfo.new(Visible and 0.25 or 0.5), {
        GroupTransparency = Visible and 1 or 0
    }):Play();

    if Visible then
        u21.Visible = true;
        task.delay(0.5, function() -- Line: 793
            -- upvalues: u27 (ref)
            u27.Visible = false;
        end);

        return;
    end;

    u27.Visible = true;
    task.delay(0.5, function() -- Line: 798
        -- upvalues: u21 (ref)
        u21.Visible = false;
    end);
end;

function u1.PurchasePremiumPassVisible() -- Line: 804
    -- upvalues: u27 (ref), u23 (ref), u24 (ref), u25 (ref), u3 (ref), u9 (ref), u4 (ref), u41 (ref), TweenService (copy), RunService (copy), LocalPlayer (copy), u10 (ref), u11 (ref), u5 (ref), u1 (copy), u26 (ref), u21 (ref)
    if u27.Visible then
        return;
    end;

    local Visible = u23.Visible;

    if Visible then
        for i = 1, 2 do
            local v94 = i;

            for i2 = 1, 3 do
                u4:Removes(`BPPurchase{v94}{i2}MouseEnter`, `BPPurchase{v94}{i2}MouseLeave`, (`BPPurchase{v94}{i2}Button1Click`));
                local _ = i2;
            end;
        end;

        u4:Removes("BPPurchaseCloseMouseEnter", "BPPurchaseCloseMouseLeave", "BPPurchaseCloseButton1Click");
    else
        for i, v in { u24, u25 } do
            local u95 = u3.PremiumPrice[u9.Passes[i]];
            local u96 = i;

            for i2, v2 in { v.Credits, v.Robux, v.Gift } do
                u4:Add(`BPPurchase{u96}{i2}MouseEnter`, v2.MouseEnter:Connect(function() -- Line: 816
                    -- upvalues: u41 (ref), TweenService (ref), v2 (copy)
                    u41.Play("UI.submenu_dropdown_rollover");
                    TweenService:Create(v2, TweenInfo.new(0.5), {
                        BackgroundTransparency = 0.9
                    }):Play();
                end));
                u4:Add(`BPPurchase{u96}{i2}MouseLeave`, v2.MouseLeave:Connect(function() -- Line: 821
                    -- upvalues: TweenService (ref), v2 (copy)
                    TweenService:Create(v2, TweenInfo.new(0.5), {
                        BackgroundTransparency = 0.95
                    }):Play();
                end));

                if i2 == 3 then
                    u4:Add(`BPPurchase{u96}{i2}Button1Click`, v2.MouseButton1Click:Connect(function() -- Line: 826
                        -- upvalues: u41 (ref)
                        u41.Play("UI.submenu_click");
                    end));
                else
                    local v97 = u95[v2.Name];
                    v2.Title.RichText = true;

                    if v2.Name == "Credits" and ((RunService:IsStudio() or LocalPlayer.HasRobloxSubscription) and typeof(v97) == "number") then
                        v2.Title.Text = `<s>{v97}</s> {math.floor(v97 * 0.9)}`;
                    else
                        v2.Title.Text = v97;
                    end;

                    u4:Add(`BPPurchase{u96}{i2}Button1Click`, v2.MouseButton1Click:Connect(function() -- Line: 838
                        -- upvalues: u95 (copy), RunService (ref), LocalPlayer (ref), i2 (copy), u10 (ref), u11 (ref), u41 (ref), u5 (ref), u96 (copy), u1 (ref)
                        local Credits = u95.Credits;

                        if RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription then
                            Credits = math.floor(Credits * 0.9) or Credits;
                        end;

                        if i2 == 1 and u10.Get("Credits") < Credits then
                            u11:Create("Not Enough Credits", Color3.fromRGB(255, 151, 153));

                            return;
                        end;

                        u41.Play("UI.submenu_click");
                        u5.Gui.BuyBattlepass.Fire((u96 - 1) * 2 + i2);

                        if i2 == 1 then
                            task.spawn(function() -- Line: 853
                                -- upvalues: u11 (ref), Credits (copy), u96 (ref)
                                u11:Create(`-${Credits}`, Color3.fromRGB(255, 151, 153));
                                task.wait(0.2);
                                u11:Create("Successfully Purchased Premium Battlepass", u96 == 1 and Color3.fromRGB(255, 223, 149) or Color3.fromRGB(117, 172, 255));
                            end);
                        end;

                        u1.PurchasePremiumPassVisible();
                    end));
                end;
            end;
        end;

        u4:Add("BPPurchaseCloseMouseEnter", u26.MouseEnter:Connect(function() -- Line: 868
            -- upvalues: u41 (ref), TweenService (ref), u26 (ref)
            u41.Play("UI.submenu_dropdown_rollover");
            TweenService:Create(u26, TweenInfo.new(0.5), {
                Transparency = 0.9
            }):Play();
        end));
        u4:Add("BPPurchaseCloseMouseLeave", u26.MouseLeave:Connect(function() -- Line: 873
            -- upvalues: TweenService (ref), u26 (ref)
            TweenService:Create(u26, TweenInfo.new(0.5), {
                Transparency = 0.95
            }):Play();
        end));
        u4:Add("BPPurchaseCloseButton1Click", u26.MouseButton1Click:Connect(function() -- Line: 877
            -- upvalues: u41 (ref), u1 (ref)
            u41.Play("UI.mainmenu_rollover");
            u1.PurchasePremiumPassVisible();
        end));
    end;

    TweenService:Create(u21, TweenInfo.new(Visible and 0.5 or 0.25), {
        GroupTransparency = Visible and 0 or 1
    }):Play();
    TweenService:Create(u23, TweenInfo.new(Visible and 0.25 or 0.5), {
        GroupTransparency = Visible and 1 or 0
    }):Play();

    if Visible then
        u21.Visible = true;
        task.delay(0.5, function() -- Line: 896
            -- upvalues: u23 (ref)
            u23.Visible = false;
        end);

        return;
    end;

    u23.Visible = true;
    task.delay(0.5, function() -- Line: 901
        -- upvalues: u21 (ref)
        u21.Visible = false;
    end);
end;

function u1.HasPremium() -- Line: 907
    return hasPremium;
end;

function u1.Init(p98) -- Line: 913
    -- upvalues: u2 (ref), u4 (ref), u3 (ref), u5 (ref), u10 (ref), u9 (ref), u6 (ref), u7 (ref), u8 (ref), u41 (ref), u42 (ref)
    u2 = p98:GetModule("Gui");
    u4 = p98:GetModule("Maid").new();
    u3 = p98:GetModule("BattlepassData");
    u5 = p98:GetModule("Network");
    u10 = p98:GetModule("ProfileData");
    u9 = p98:GetModule("Enums");
    u6 = p98:GetModule("RarityColors");
    u7 = p98:GetModule("ItemManager");
    u8 = p98:GetModule("SkinManager");
    u41 = p98:GetModule("SoundManager");
    u42 = p98:GetModule("WeaponManager");
end;

function u1.Start2(p99) -- Line: 927
    -- upvalues: u43 (ref), u2 (ref), u11 (ref), u44 (ref), u12 (ref), u1 (copy), u10 (ref)
    u43 = u2.GetComponent("MainMenu");
    u11 = u2.GetComponent("MenuNotification");
    u44 = u2.GetComponent("Rewards");
    local Tabs = u2.GetComponent("Rewards").Tabs;
    u12 = Tabs:CreatePage("Battlepass", 1, false, false);
    Tabs:OpenTab("Battlepass");
    u1.new();
    PlayerBattlepass = u10.Get("Battlepass");
    hasPremium = PlayerBattlepass.Premium;
    u10.Changed("Battlepass"):Connect(function(p100) -- Line: 940
        -- upvalues: u1 (ref)
        PlayerBattlepass = p100;

        if hasPremium == PlayerBattlepass.Premium then
            u1.Update();

            return;
        end;

        hasPremium = PlayerBattlepass.Premium;
        u1.Draw();
    end);
    u1.Draw();
    u1.DrawPurchaseTiers();
end;

function u1.new() -- Line: 960
    -- upvalues: u12 (ref), u3 (ref), u23 (ref), u25 (ref), u24 (ref), u26 (ref), u13 (ref), u19 (ref), u17 (ref), u18 (ref), u20 (ref), u16 (ref), u14 (ref), u15 (ref), u21 (ref), u22 (ref), u27 (ref), u28 (ref), u31 (ref), u34 (ref), u32 (ref), u33 (ref), u29 (ref), u30 (ref), u35 (ref), u36 (ref), u40 (ref), TweenService (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.25);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.1);
    TextLabel.Size = UDim2.fromScale(0.8, 0.1);
    TextLabel.Text = "BATTLEPASS";
    TextLabel.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextScaled = true;
    TextLabel.Parent = u12;
    local Frame = Instance.new("Frame");
    Frame.Name = "Line";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(232, 232, 232);
    Frame.BackgroundTransparency = 0.5;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 0.18);
    Frame.Size = UDim2.new(0.4, 0, 0, 2);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.199789, 0),
        NumberSequenceKeypoint.new(0.800211, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame;
    Frame.Parent = u12;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "SeasonTitle";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.25);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.2);
    TextLabel2.Size = UDim2.fromScale(0.8, 0.05);
    TextLabel2.Text = `Season {u3.Season}`;
    TextLabel2.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel2.TextScaled = true;
    TextLabel2.Parent = u12;
    u23 = Instance.new("CanvasGroup");
    u23.Name = "BattlepassPurchase";
    u23.AnchorPoint = Vector2.new(0.5, 0.5);
    u23.BackgroundTransparency = 1;
    u23.Position = UDim2.fromScale(0.5, 0.436364);
    u23.Size = UDim2.fromScale(1, 1.12727);
    u23.Visible = false;
    u23.ZIndex = 10;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Main";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.575);
    Frame2.Size = UDim2.fromScale(0.5, 0.25);
    u25 = Instance.new("Frame");
    u25.Name = "PremiumPlus";
    u25.AnchorPoint = Vector2.new(1, 0);
    u25.BackgroundColor3 = Color3.fromRGB(117, 172, 255);
    u25.BackgroundTransparency = 0.25;
    u25.Position = UDim2.fromScale(0.99, 0);
    u25.Size = UDim2.fromScale(0.48, 1);
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(117, 172, 255);
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 0.2;
    UIStroke.Parent = u25;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(161, 161, 161)), ColorSequenceKeypoint.new(0.716263, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient2.Rotation = 90;
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.409836) });
    UIGradient2.Parent = u25;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.05, 0);
    UICorner.Parent = u25;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.04);
    TextLabel3.Size = UDim2.fromScale(0.9, 0.26);
    TextLabel3.Text = "PREMIUM PASS";
    TextLabel3.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 10;
    TextLabel3.Parent = u25;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.322496, 0.268969);
    TextLabel4.Size = UDim2.fromScale(0.534971, 0.142368);
    TextLabel4.Text = "+10 LEVELS";
    TextLabel4.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel4.TextScaled = true;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 10;
    TextLabel4.Parent = u25;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://104072345722508";
    ImageLabel.ImageColor3 = Color3.fromRGB(117, 172, 255);
    ImageLabel.ImageTransparency = 0.5;
    ImageLabel.LayoutOrder = 1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.7, 0.7);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = u25;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Gift";
    TextButton.Active = false;
    TextButton.AnchorPoint = Vector2.new(0, 1);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton.BackgroundTransparency = 0.95;
    TextButton.Position = UDim2.fromScale(0.735, 0.95);
    TextButton.Size = UDim2.fromScale(0.189, 0.189);
    TextButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton.TextTransparency = 1;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Transparency = 0.875;
    UIStroke2.Parent = TextButton;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = TextButton;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Icon";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://117975901841067";
    ImageLabel2.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel2.LayoutOrder = 1;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = TextButton;
    TextButton.Parent = u25;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Robux";
    TextButton2.Active = false;
    TextButton2.AnchorPoint = Vector2.new(0, 1);
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundTransparency = 0.95;
    TextButton2.Position = UDim2.fromScale(0.415, 0.95);
    TextButton2.Size = UDim2.fromScale(0.3, 0.189);
    TextButton2.TextTransparency = 1;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.new(1, 1, 1);
    UIStroke3.Transparency = 0.875;
    UIStroke3.Parent = TextButton2;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.Parent = TextButton2;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Title";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel5.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel5.Text = "399";
    TextLabel5.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel5.TextScaled = true;
    TextLabel5.Parent = TextButton2;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Icon";
    TextLabel6.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.LayoutOrder = 1;
    TextLabel6.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel6.RichText = true;
    TextLabel6.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel6.Text = "";
    TextLabel6.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel6.TextScaled = true;
    TextLabel6.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel6.Parent = TextButton2;
    TextButton2.Parent = u25;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Credits";
    TextButton3.Active = false;
    TextButton3.AnchorPoint = Vector2.new(0, 1);
    TextButton3.AutoButtonColor = false;
    TextButton3.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton3.BackgroundTransparency = 0.95;
    TextButton3.Position = UDim2.fromScale(0.0400002, 0.95);
    TextButton3.Size = UDim2.fromScale(0.35, 0.189173);
    TextButton3.TextTransparency = 1;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "UIStroke";
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.Color = Color3.new(1, 1, 1);
    UIStroke4.Transparency = 0.875;
    UIStroke4.Parent = TextButton3;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = TextButton3;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Title";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel7.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel7.Text = "1000";
    TextLabel7.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel7.TextScaled = true;
    TextLabel7.Parent = TextButton3;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Icon";
    ImageLabel3.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://138240378050344";
    ImageLabel3.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel3.LayoutOrder = 1;
    ImageLabel3.Position = UDim2.fromScale(0.02, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = TextButton3;
    TextButton3.Parent = u25;
    u25.Parent = Frame2;
    u24 = Instance.new("Frame");
    u24.Name = "Premium";
    u24.BackgroundColor3 = Color3.fromRGB(255, 223, 149);
    u24.BackgroundTransparency = 0.25;
    u24.Position = UDim2.fromScale(0.01, 0);
    u24.Size = UDim2.fromScale(0.48, 1);
    local UIStroke5 = Instance.new("UIStroke");
    UIStroke5.Name = "UIStroke";
    UIStroke5.Color = Color3.fromRGB(255, 223, 149);
    UIStroke5.Thickness = 1.5;
    UIStroke5.Transparency = 0.2;
    UIStroke5.Parent = u24;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(161, 161, 161)), ColorSequenceKeypoint.new(0.716263, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient3.Rotation = 90;
    UIGradient3.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.409836) });
    UIGradient3.Parent = u24;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(0.05, 0);
    UICorner5.Parent = u24;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "Title";
    TextLabel8.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.5, 0.04);
    TextLabel8.Size = UDim2.fromScale(0.9, 0.259914);
    TextLabel8.Text = "PREMIUM PASS";
    TextLabel8.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel8.TextScaled = true;
    TextLabel8.ZIndex = 10;
    TextLabel8.Parent = u24;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Icon";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://110283734201202";
    ImageLabel4.ImageColor3 = Color3.fromRGB(255, 223, 149);
    ImageLabel4.ImageTransparency = 0.5;
    ImageLabel4.LayoutOrder = 1;
    ImageLabel4.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel4.Size = UDim2.fromScale(0.7, 0.7);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = u24;
    local TextButton4 = Instance.new("TextButton");
    TextButton4.Name = "Credits";
    TextButton4.Active = false;
    TextButton4.AnchorPoint = Vector2.new(0, 1);
    TextButton4.AutoButtonColor = false;
    TextButton4.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton4.BackgroundTransparency = 0.95;
    TextButton4.Position = UDim2.fromScale(0.0400002, 0.95);
    TextButton4.Size = UDim2.fromScale(0.35, 0.189173);
    TextButton4.TextTransparency = 1;
    local UIStroke6 = Instance.new("UIStroke");
    UIStroke6.Name = "UIStroke";
    UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke6.Color = Color3.new(1, 1, 1);
    UIStroke6.Transparency = 0.875;
    UIStroke6.Parent = u24;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UICorner";
    UICorner6.CornerRadius = UDim.new(0.1, 0);
    UICorner6.Parent = u24;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "Title";
    TextLabel9.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel9.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel9.Text = "1000";
    TextLabel9.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel9.TextScaled = true;
    TextLabel9.Parent = TextButton4;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Icon";
    ImageLabel5.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://138240378050344";
    ImageLabel5.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel5.LayoutOrder = 1;
    ImageLabel5.Position = UDim2.fromScale(0.02, 0.5);
    ImageLabel5.ScaleType = Enum.ScaleType.Fit;
    ImageLabel5.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel5.Parent = TextButton4;
    TextButton4.Parent = u24;
    local TextButton5 = Instance.new("TextButton");
    TextButton5.Name = "Robux";
    TextButton5.Active = false;
    TextButton5.AnchorPoint = Vector2.new(0, 1);
    TextButton5.AutoButtonColor = false;
    TextButton5.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton5.BackgroundTransparency = 0.95;
    TextButton5.Position = UDim2.fromScale(0.415, 0.95);
    TextButton5.Size = UDim2.fromScale(0.3, 0.189);
    TextButton5.TextTransparency = 1;
    local UIStroke7 = Instance.new("UIStroke");
    UIStroke7.Name = "UIStroke";
    UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke7.Color = Color3.new(1, 1, 1);
    UIStroke7.Transparency = 0.875;
    UIStroke7.Parent = TextButton5;
    local UICorner7 = Instance.new("UICorner");
    UICorner7.Name = "UICorner";
    UICorner7.CornerRadius = UDim.new(0.1, 0);
    UICorner7.Parent = TextButton5;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "Title";
    TextLabel10.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel10.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel10.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel10.Text = "399";
    TextLabel10.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel10.TextScaled = true;
    TextLabel10.Parent = TextButton5;
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "Icon";
    TextLabel11.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.LayoutOrder = 1;
    TextLabel11.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel11.RichText = true;
    TextLabel11.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel11.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel11.Text = "";
    TextLabel11.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel11.TextScaled = true;
    TextLabel11.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel11.Parent = TextButton5;
    TextButton5.Parent = u24;
    local TextButton6 = Instance.new("TextButton");
    TextButton6.Name = "Gift";
    TextButton6.Active = false;
    TextButton6.AnchorPoint = Vector2.new(0, 1);
    TextButton6.AutoButtonColor = false;
    TextButton6.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton6.BackgroundTransparency = 0.95;
    TextButton6.Position = UDim2.fromScale(0.735, 0.95);
    TextButton6.Size = UDim2.fromScale(0.189, 0.189);
    TextButton6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton6.TextTransparency = 1;
    local UIStroke8 = Instance.new("UIStroke");
    UIStroke8.Name = "UIStroke";
    UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke8.Color = Color3.new(1, 1, 1);
    UIStroke8.Transparency = 0.875;
    UIStroke8.Parent = TextButton6;
    local UICorner8 = Instance.new("UICorner");
    UICorner8.Name = "UICorner";
    UICorner8.CornerRadius = UDim.new(0.1, 0);
    UICorner8.Parent = TextButton6;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "Icon";
    ImageLabel6.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://117975901841067";
    ImageLabel6.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel6.LayoutOrder = 1;
    ImageLabel6.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel6.ScaleType = Enum.ScaleType.Fit;
    ImageLabel6.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel6.Parent = TextButton6;
    TextButton6.Parent = u24;
    u24.Parent = Frame2;
    u26 = Instance.new("TextButton");
    u26.Name = "Close";
    u26.Active = false;
    u26.AnchorPoint = Vector2.new(0.5, 0);
    u26.AutoButtonColor = false;
    u26.BackgroundColor3 = Color3.new(1, 1, 1);
    u26.BackgroundTransparency = 0.95;
    u26.Position = UDim2.fromScale(0.5, 1.05);
    u26.Size = UDim2.fromScale(0.2, 0.189173);
    u26.TextTransparency = 1;
    local UIStroke9 = Instance.new("UIStroke");
    UIStroke9.Name = "UIStroke";
    UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke9.Color = Color3.new(1, 1, 1);
    UIStroke9.Transparency = 0.875;
    UIStroke9.Parent = u26;
    local UICorner9 = Instance.new("UICorner");
    UICorner9.Name = "UICorner";
    UICorner9.CornerRadius = UDim.new(0.1, 0);
    UICorner9.Parent = u26;
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = "Title";
    TextLabel12.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel12.BackgroundTransparency = 1;
    TextLabel12.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel12.Position = UDim2.fromScale(0.5, 0.525);
    TextLabel12.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel12.Text = "CLOSE";
    TextLabel12.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel12.TextScaled = true;
    TextLabel12.Parent = u26;
    u26.Parent = Frame2;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 3;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = Frame2;
    Frame2.Parent = u23;
    u23.Parent = u12;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Main";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BackgroundTransparency = 0.8;
    Frame3.Position = UDim2.fromScale(0.5, 0.55);
    Frame3.Size = UDim2.fromScale(0.98, 0.46);
    local UICorner10 = Instance.new("UICorner");
    UICorner10.Name = "UICorner";
    UICorner10.CornerRadius = UDim.new(0.02, 0);
    UICorner10.Parent = Frame3;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Main";
    Frame4.BackgroundTransparency = 1;
    Frame4.Size = UDim2.fromScale(0.24967, 1);
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "EndsIn";
    Frame5.BackgroundColor3 = Color3.new();
    Frame5.BackgroundTransparency = 0.8;
    Frame5.Size = UDim2.fromScale(0.402545, 0.160113);
    local UICorner11 = Instance.new("UICorner");
    UICorner11.Name = "UICorner";
    UICorner11.CornerRadius = UDim.new(0.1, 0);
    UICorner11.Parent = Frame5;
    u13 = Instance.new("TextLabel");
    u13.Name = "Days";
    u13.AnchorPoint = Vector2.new(0.5, 0.5);
    u13.BackgroundTransparency = 1;
    u13.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    u13.Position = UDim2.fromScale(0.5, 0.725);
    u13.Size = UDim2.fromScale(0.9, 0.45);
    u13.Text = "20 days";
    u13.TextColor3 = Color3.new(1, 1, 1);
    u13.TextScaled = true;
    u13.Parent = Frame5;
    local TextLabel13 = Instance.new("TextLabel");
    TextLabel13.Name = "Title";
    TextLabel13.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel13.BackgroundTransparency = 1;
    TextLabel13.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel13.Position = UDim2.fromScale(0.5, 0.35);
    TextLabel13.Size = UDim2.fromScale(0.9, 0.45);
    TextLabel13.Text = "SEASON ENDS IN:";
    TextLabel13.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel13.TextScaled = true;
    TextLabel13.TextTransparency = 0.2;
    TextLabel13.Parent = Frame5;
    Frame5.Parent = Frame4;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Main";
    Frame6.AnchorPoint = Vector2.new(0, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.Position = UDim2.fromScale(0, 0.7);
    Frame6.Size = UDim2.fromScale(1, 0.5);
    u19 = Instance.new("TextLabel");
    u19.Name = "Premium";
    u19.AnchorPoint = Vector2.new(0.5, 0);
    u19.BackgroundTransparency = 1;
    u19.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    u19.Position = UDim2.fromScale(0.485983, 0.78545);
    u19.Size = UDim2.fromScale(0.876942, 0.2);
    u19.Text = "PREMIUM ACTIVATED";
    u19.TextColor3 = Color3.fromRGB(255, 223, 149);
    u19.TextScaled = true;
    u19.Visible = false;
    local UIGradient4 = Instance.new("UIGradient");
    UIGradient4.Name = "UIGradient";
    UIGradient4.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(161, 161, 161)), ColorSequenceKeypoint.new(0.716263, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient4.Rotation = 90;
    UIGradient4.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.409836) });
    UIGradient4.Parent = u19;
    u19.Parent = Frame6;
    u17 = Instance.new("TextLabel");
    u17.Name = "Level";
    u17.AnchorPoint = Vector2.new(0.5, 0);
    u17.BackgroundTransparency = 1;
    u17.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    u17.Position = UDim2.fromScale(0.337067, 0);
    u17.Size = UDim2.fromScale(0.574134, 0.47);
    u17.Text = "LEVEL 55";
    u17.TextColor3 = Color3.fromRGB(232, 232, 232);
    u17.TextScaled = true;
    u17.TextXAlignment = Enum.TextXAlignment.Left;
    u17.Parent = Frame6;
    u18 = Instance.new("TextLabel");
    u18.Name = "XP";
    u18.AnchorPoint = Vector2.new(0.5, 0);
    u18.BackgroundTransparency = 1;
    u18.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    u18.Position = UDim2.fromScale(0.5, 0.53);
    u18.Size = UDim2.fromScale(0.9, 0.182273);
    u18.Text = "999 XP to next level";
    u18.TextColor3 = Color3.fromRGB(232, 232, 232);
    u18.TextScaled = true;
    u18.TextTransparency = 0.4;
    u18.TextXAlignment = Enum.TextXAlignment.Left;
    u18.Parent = Frame6;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "ProgressBar";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.BackgroundColor3 = Color3.new(1, 1, 1);
    CanvasGroup.BackgroundTransparency = 0.9;
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.fromScale(0.9, 0.06);
    u20 = Instance.new("Frame");
    u20.Name = "Frame";
    u20.BackgroundColor3 = Color3.fromRGB(101, 156, 245);
    u20.BackgroundTransparency = 0.2;
    u20.BorderColor3 = Color3.new();
    u20.BorderSizePixel = 0;
    u20.Size = UDim2.fromScale(0.5, 1);
    u20.Parent = CanvasGroup;
    local UICorner12 = Instance.new("UICorner");
    UICorner12.Name = "UICorner";
    UICorner12.CornerRadius = UDim.new(0.2, 0);
    UICorner12.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame6;
    u16 = Instance.new("TextButton");
    u16.Name = "BuyTiers";
    u16.Active = false;
    u16.AnchorPoint = Vector2.new(0.5, 0);
    u16.AutoButtonColor = false;
    u16.BackgroundColor3 = Color3.fromRGB(255, 223, 149);
    u16.BackgroundTransparency = 0.85;
    u16.Position = UDim2.fromScale(0.7, 0.1325);
    u16.Size = UDim2.fromScale(0.125, 0.125);
    u16.Text = "";
    u16.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    u16.TextTransparency = 1;
    local TextLabel14 = Instance.new("TextLabel");
    TextLabel14.Name = "Title";
    TextLabel14.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel14.BackgroundTransparency = 1;
    TextLabel14.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel14.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel14.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel14.Text = "+";
    TextLabel14.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel14.TextScaled = true;
    TextLabel14.Parent = u16;
    local UICorner13 = Instance.new("UICorner");
    UICorner13.Name = "UICorner";
    UICorner13.CornerRadius = UDim.new(0.05, 0);
    UICorner13.Parent = u16;
    local UIGradient5 = Instance.new("UIGradient");
    UIGradient5.Name = "UIGradient";
    UIGradient5.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(161, 161, 161)), ColorSequenceKeypoint.new(0.716263, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient5.Rotation = 90;
    UIGradient5.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.409836) });
    UIGradient5.Parent = u16;
    local UIStroke10 = Instance.new("UIStroke");
    UIStroke10.Name = "UIStroke";
    UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke10.Color = Color3.fromRGB(255, 223, 149);
    UIStroke10.Transparency = 0.2;
    UIStroke10.Parent = u16;
    u16.Parent = Frame6;
    Frame6.Parent = Frame4;
    u14 = Instance.new("TextButton");
    u14.Name = "ClaimAll";
    u14.Active = false;
    u14.AutoButtonColor = false;
    u14.BackgroundColor3 = Color3.new(1, 1, 1);
    u14.BackgroundTransparency = 0.95;
    u14.Position = UDim2.fromScale(0.439091, 0.025);
    u14.Size = UDim2.fromScale(0.51091, 0.12);
    u14.TextTransparency = 1;
    local UIStroke11 = Instance.new("UIStroke");
    UIStroke11.Name = "UIStroke";
    UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke11.Color = Color3.new(1, 1, 1);
    UIStroke11.Transparency = 0.875;
    UIStroke11.Parent = u14;
    local UICorner14 = Instance.new("UICorner");
    UICorner14.Name = "UICorner";
    UICorner14.CornerRadius = UDim.new(0.1, 0);
    UICorner14.Parent = u14;
    local TextLabel15 = Instance.new("TextLabel");
    TextLabel15.Name = "Title";
    TextLabel15.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel15.BackgroundTransparency = 1;
    TextLabel15.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel15.Position = UDim2.fromScale(0.5, 0.525);
    TextLabel15.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel15.Text = "CLAIM ALL";
    TextLabel15.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel15.TextScaled = true;
    TextLabel15.Parent = u14;
    local CanvasGroup2 = Instance.new("CanvasGroup");
    CanvasGroup2.Name = "Claiming";
    CanvasGroup2.BackgroundTransparency = 1;
    CanvasGroup2.Size = UDim2.fromScale(1, 1);
    CanvasGroup2.Visible = true;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Frame";
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame7.BackgroundTransparency = 0.75;
    Frame7.BorderColor3 = Color3.new();
    Frame7.BorderSizePixel = 0;
    Frame7.ClipsDescendants = true;
    Frame7.Position = UDim2.fromScale(-1, -1);
    Frame7.Rotation = 45;
    Frame7.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    Frame7.Size = UDim2.fromScale(2, 2);
    Frame7.Parent = CanvasGroup2;
    local UICorner15 = Instance.new("UICorner");
    UICorner15.Name = "UICorner";
    UICorner15.CornerRadius = UDim.new(0.05, 0);
    UICorner15.Parent = CanvasGroup2;
    CanvasGroup2.Parent = u14;
    u14.Parent = Frame4;
    u15 = Instance.new("ImageButton");
    u15.Name = "PremiumPass";
    u15.Active = false;
    u15.AnchorPoint = Vector2.new(0.5, 0.5);
    u15.AutoButtonColor = false;
    u15.BackgroundColor3 = Color3.fromRGB(255, 223, 149);
    u15.BackgroundTransparency = 0.2;
    u15.Position = UDim2.fromScale(0.5, 0.903582);
    u15.Size = UDim2.fromScale(0.8, 0.142836);
    u15.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    local TextLabel16 = Instance.new("TextLabel");
    TextLabel16.Name = "Title";
    TextLabel16.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel16.BackgroundTransparency = 1;
    TextLabel16.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel16.Position = UDim2.fromScale(0.5, 0.525);
    TextLabel16.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel16.Text = "BUY PREMIUM PASS";
    TextLabel16.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel16.TextScaled = true;
    TextLabel16.Parent = u15;
    local UIStroke12 = Instance.new("UIStroke");
    UIStroke12.Name = "UIStroke";
    UIStroke12.Color = Color3.fromRGB(255, 223, 149);
    UIStroke12.Transparency = 0.2;
    UIStroke12.Parent = u15;
    local UIGradient6 = Instance.new("UIGradient");
    UIGradient6.Name = "UIGradient";
    UIGradient6.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(161, 161, 161)), ColorSequenceKeypoint.new(0.716263, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient6.Rotation = 90;
    UIGradient6.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.409836) });
    UIGradient6.Parent = u15;
    local UICorner16 = Instance.new("UICorner");
    UICorner16.Name = "UICorner";
    UICorner16.CornerRadius = UDim.new(0.05, 0);
    UICorner16.Parent = u15;
    u15.Parent = Frame4;
    Frame4.Parent = Frame3;
    u21 = Instance.new("CanvasGroup");
    u21.Name = "Tiers";
    u21.Active = true;
    u21.AnchorPoint = Vector2.new(0.5, 0.5);
    u21.BackgroundTransparency = 1;
    u21.Position = UDim2.fromScale(0.624835, 0.4875);
    u21.Selectable = true;
    u21.SelectionGroup = true;
    u21.Size = UDim2.fromScale(0.75033, 0.975);
    u22 = Instance.new("ScrollingFrame");
    u22.Name = "ScrollingFrame";
    u22.Active = true;
    u22.AnchorPoint = Vector2.new(0.5, 0.5);
    u22.AutomaticCanvasSize = Enum.AutomaticSize.X;
    u22.BackgroundTransparency = 1;
    u22.CanvasSize = UDim2.fromOffset(2, 0);
    u22.Position = UDim2.fromScale(0.5, 0.5);
    u22.ScrollBarImageColor3 = Color3.new();
    u22.ScrollBarThickness = 0;
    u22.ScrollingDirection = Enum.ScrollingDirection.X;
    u22.Size = UDim2.fromScale(1, 1);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = u22;
    u22.Parent = u21;
    u21.Parent = Frame3;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.AspectRatio = 4;
    UIAspectRatioConstraint2.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint2.Parent = Frame3;
    Frame3.Parent = u12;
    u27 = Instance.new("CanvasGroup");
    u27.Name = "TiersPurchase";
    u27.AnchorPoint = Vector2.new(0.5, 0.5);
    u27.BackgroundTransparency = 1;
    u27.Position = UDim2.fromScale(0.5, 0.436364);
    u27.Size = UDim2.fromScale(1, 1.12727);
    u27.ZIndex = 10;
    u27.Visible = false;
    u28 = Instance.new("Frame");
    u28.Name = "Main";
    u28.AnchorPoint = Vector2.new(0.5, 0.5);
    u28.BackgroundColor3 = Color3.new(1, 1, 1);
    u28.BackgroundTransparency = 0.95;
    u28.Position = UDim2.fromScale(0.5, 0.575);
    u28.Size = UDim2.fromScale(0.5, 0.25);
    u31 = Instance.new("TextButton");
    u31.Name = "Close";
    u31.Active = false;
    u31.AnchorPoint = Vector2.new(0.5, 0);
    u31.AutoButtonColor = false;
    u31.BackgroundColor3 = Color3.new(1, 1, 1);
    u31.BackgroundTransparency = 0.95;
    u31.Position = UDim2.fromScale(0.5, 1.05);
    u31.Size = UDim2.fromScale(0.2, 0.189173);
    u31.TextTransparency = 1;
    local UIStroke13 = Instance.new("UIStroke");
    UIStroke13.Name = "UIStroke";
    UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke13.Color = Color3.new(1, 1, 1);
    UIStroke13.Transparency = 0.875;
    UIStroke13.Parent = u31;
    local UICorner17 = Instance.new("UICorner");
    UICorner17.Name = "UICorner";
    UICorner17.CornerRadius = UDim.new(0.1, 0);
    UICorner17.Parent = u31;
    local TextLabel17 = Instance.new("TextLabel");
    TextLabel17.Name = "Title";
    TextLabel17.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel17.BackgroundTransparency = 1;
    TextLabel17.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel17.Position = UDim2.fromScale(0.5, 0.525);
    TextLabel17.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel17.Text = "CLOSE";
    TextLabel17.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel17.TextScaled = true;
    TextLabel17.Parent = u31;
    u31.Parent = u28;
    local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint3.AspectRatio = 3;
    UIAspectRatioConstraint3.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint3.Parent = u28;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Line";
    Frame8.AnchorPoint = Vector2.new(0.5, 0);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.5, 0.3);
    Frame8.Size = UDim2.fromScale(0.9, 0.1);
    u34 = Instance.new("CanvasGroup");
    u34.Name = "Background";
    u34.AnchorPoint = Vector2.new(0.5, 0.5);
    u34.BackgroundTransparency = 1;
    u34.GroupTransparency = 0.75;
    u34.Position = UDim2.fromScale(0.5, 0.5);
    u34.Size = UDim2.fromScale(1, 0.7);
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Frame";
    Frame9.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame9.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.Position = UDim2.fromScale(0.5, 0.5);
    Frame9.Size = UDim2.fromScale(1, 0.4);
    Frame9.Parent = u34;
    u34.Parent = Frame8;
    u32 = Instance.new("Frame");
    u32.Name = "Main";
    u32.AnchorPoint = Vector2.new(0.5, 0.5);
    u32.BackgroundTransparency = 1;
    u32.Position = UDim2.fromScale(0.5, 0.5);
    u32.Size = UDim2.fromScale(1, 0.7);
    u33 = Instance.new("UIStroke");
    u33.Name = "UIStroke";
    u33.Color = Color3.fromRGB(232, 232, 232);
    u33.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    u33.Thickness = 0.2;
    u33.Transparency = 0.1;
    u32.Parent = Frame8;
    Frame8.Parent = u28;
    u29 = Instance.new("TextLabel");
    u29.Name = "Title";
    u29.AnchorPoint = Vector2.new(0.5, 0.5);
    u29.BackgroundTransparency = 1;
    u29.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    u29.Position = UDim2.fromScale(0.5, 0.136767);
    u29.Size = UDim2.fromScale(0.9, 0.176017);
    u29.Text = "PURCHASE +1 TIER";
    u29.TextColor3 = Color3.fromRGB(232, 232, 232);
    u29.TextScaled = true;
    u29.Parent = u28;
    u30 = Instance.new("Frame");
    u30.Name = "Buttons";
    u30.AnchorPoint = Vector2.new(0.5, 0.5);
    u30.BackgroundTransparency = 1;
    u30.Position = UDim2.fromScale(0.5, 0.8);
    u30.Size = UDim2.fromScale(0.5, 0.25);
    local TextButton7 = Instance.new("TextButton");
    TextButton7.Name = "Credits";
    TextButton7.Active = false;
    TextButton7.AnchorPoint = Vector2.new(0, 0.5);
    TextButton7.AutoButtonColor = false;
    TextButton7.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton7.BackgroundTransparency = 0.95;
    TextButton7.Position = UDim2.fromScale(0, 0.5);
    TextButton7.Size = UDim2.fromScale(0.45, 0.8);
    TextButton7.TextTransparency = 1;
    local UIStroke14 = Instance.new("UIStroke");
    UIStroke14.Name = "UIStroke";
    UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke14.Color = Color3.new(1, 1, 1);
    UIStroke14.Transparency = 0.875;
    UIStroke14.Parent = TextButton7;
    local UICorner18 = Instance.new("UICorner");
    UICorner18.Name = "UICorner";
    UICorner18.CornerRadius = UDim.new(0.1, 0);
    UICorner18.Parent = TextButton7;
    local TextLabel18 = Instance.new("TextLabel");
    TextLabel18.Name = "Title";
    TextLabel18.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel18.BackgroundTransparency = 1;
    TextLabel18.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel18.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel18.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel18.Text = "1000";
    TextLabel18.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel18.TextScaled = true;
    TextLabel18.Parent = TextButton7;
    local ImageLabel7 = Instance.new("ImageLabel");
    ImageLabel7.Name = "Icon";
    ImageLabel7.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel7.BackgroundTransparency = 1;
    ImageLabel7.Image = "rbxassetid://138240378050344";
    ImageLabel7.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel7.LayoutOrder = 1;
    ImageLabel7.Position = UDim2.fromScale(0.02, 0.5);
    ImageLabel7.ScaleType = Enum.ScaleType.Fit;
    ImageLabel7.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel7.Parent = TextButton7;
    TextButton7.Parent = u30;
    local TextButton8 = Instance.new("TextButton");
    TextButton8.Name = "Gift";
    TextButton8.Active = false;
    TextButton8.AnchorPoint = Vector2.new(1, 0.5);
    TextButton8.AutoButtonColor = false;
    TextButton8.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton8.BackgroundTransparency = 0.95;
    TextButton8.Position = UDim2.fromScale(1, 0.5);
    TextButton8.Size = UDim2.fromScale(0.8, 0.8);
    TextButton8.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton8.TextTransparency = 1;
    local UIStroke15 = Instance.new("UIStroke");
    UIStroke15.Name = "UIStroke";
    UIStroke15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke15.Color = Color3.new(1, 1, 1);
    UIStroke15.Transparency = 0.875;
    UIStroke15.Parent = TextButton8;
    local UICorner19 = Instance.new("UICorner");
    UICorner19.Name = "UICorner";
    UICorner19.CornerRadius = UDim.new(0.1, 0);
    UICorner19.Parent = TextButton8;
    local ImageLabel8 = Instance.new("ImageLabel");
    ImageLabel8.Name = "Icon";
    ImageLabel8.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel8.BackgroundTransparency = 1;
    ImageLabel8.Image = "rbxassetid://117975901841067";
    ImageLabel8.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel8.LayoutOrder = 1;
    ImageLabel8.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel8.ScaleType = Enum.ScaleType.Fit;
    ImageLabel8.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel8.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel8.Parent = TextButton8;
    TextButton8.Parent = u30;
    local TextButton9 = Instance.new("TextButton");
    TextButton9.Name = "Robux";
    TextButton9.Active = false;
    TextButton9.AnchorPoint = Vector2.new(0, 0.5);
    TextButton9.AutoButtonColor = false;
    TextButton9.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton9.BackgroundTransparency = 0.95;
    TextButton9.Position = UDim2.fromScale(0.471, 0.5);
    TextButton9.Size = UDim2.fromScale(0.375, 0.8);
    TextButton9.TextTransparency = 1;
    local UIStroke16 = Instance.new("UIStroke");
    UIStroke16.Name = "UIStroke";
    UIStroke16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke16.Color = Color3.new(1, 1, 1);
    UIStroke16.Transparency = 0.875;
    UIStroke16.Parent = TextButton9;
    local UICorner20 = Instance.new("UICorner");
    UICorner20.Name = "UICorner";
    UICorner20.CornerRadius = UDim.new(0.1, 0);
    UICorner20.Parent = TextButton9;
    local TextLabel19 = Instance.new("TextLabel");
    TextLabel19.Name = "Title";
    TextLabel19.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel19.BackgroundTransparency = 1;
    TextLabel19.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel19.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel19.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel19.Text = "399";
    TextLabel19.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel19.TextScaled = true;
    TextLabel19.Parent = TextButton9;
    local TextLabel20 = Instance.new("TextLabel");
    TextLabel20.Name = "Icon";
    TextLabel20.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel20.BackgroundTransparency = 1;
    TextLabel20.LayoutOrder = 1;
    TextLabel20.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel20.RichText = true;
    TextLabel20.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel20.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel20.Text = "";
    TextLabel20.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel20.TextScaled = true;
    TextLabel20.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel20.Parent = TextButton9;
    TextButton9.Parent = u30;
    u30.Parent = u28;
    local UIStroke17 = Instance.new("UIStroke");
    UIStroke17.Name = "UIStroke";
    UIStroke17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke17.Color = Color3.new(1, 1, 1);
    UIStroke17.Transparency = 0.875;
    UIStroke17.Parent = u28;
    local UICorner21 = Instance.new("UICorner");
    UICorner21.Name = "UICorner";
    UICorner21.CornerRadius = UDim.new(0.025, 0);
    UICorner21.Parent = u28;
    u28.Parent = u27;
    u27.Parent = u12;
    u35 = Instance.new("CanvasGroup");
    u35.Name = "Claiming";
    u35.BackgroundTransparency = 1;
    u35.Size = UDim2.fromScale(1, 1);
    u35.Visible = true;
    u36 = Instance.new("Frame");
    u36.Name = "Frame";
    u36.AnchorPoint = Vector2.new(0.5, 0.5);
    u36.BackgroundColor3 = Color3.fromRGB(151, 191, 255);
    u36.BackgroundTransparency = 0.75;
    u36.BorderColor3 = Color3.new();
    u36.BorderSizePixel = 0;
    u36.ClipsDescendants = true;
    u36.Position = UDim2.fromScale(-0.2, -0.2);
    u36.Rotation = 45;
    u36.Size = UDim2.fromScale(2, 2);
    u36.Parent = u35;
    local UICorner22 = Instance.new("UICorner");
    UICorner22.Name = "UICorner";
    UICorner22.CornerRadius = UDim.new(0.05, 0);
    UICorner22.Parent = u35;
    u40 = TweenService:Create(u36, TweenInfo.new(0.25), {
        Position = UDim2.fromScale(-0.75, -0.75)
    });
    u35.Parent = nil;
end;

function u1.tierFrame() -- Line: 2403
    -- upvalues: u22 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "TierFrame";
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0, 0.5);
    Frame.Size = UDim2.fromScale(0.125, 1);
    Frame.Visible = false;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Tier";
    TextButton.Active = false;
    TextButton.AnchorPoint = Vector2.new(0.5, 1);
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextButton.Position = UDim2.fromScale(0.5, 1);
    TextButton.Selectable = false;
    TextButton.Size = UDim2.fromScale(1, 0.079388);
    TextButton.Text = "TIER 1";
    TextButton.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextButton.TextScaled = true;
    TextButton.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextButton.TextTransparency = 0.1;
    TextButton.ZIndex = 343;
    TextButton.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Main";
    Frame2.BackgroundTransparency = 1;
    Frame2.ClipsDescendants = true;
    Frame2.Size = UDim2.fromScale(1, 0.95);
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Frame";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.fromScale(1, 0.04);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.Position = UDim2.fromScale(0.5, 0.5);
    Frame3.Size = UDim2.fromScale(1, 1);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.5, 0);
    UICorner.Parent = Frame3;
    Frame3.Parent = CanvasGroup;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Frame";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0.5, 0.5);
    Frame4.Size = UDim2.fromScale(1, 0.333);
    Frame4.Parent = CanvasGroup;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(101, 156, 245)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(101, 156, 245)),
        ColorSequenceKeypoint.new(0.52, Color3.fromRGB(250, 250, 250)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
    });
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.245902),
        NumberSequenceKeypoint.new(0.45, 0.251),
        NumberSequenceKeypoint.new(0.5, 0.9),
        NumberSequenceKeypoint.new(1, 0.9)
    });
    UIGradient.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame2;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Free";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BackgroundTransparency = 0.95;
    Frame5.Position = UDim2.fromScale(0.5, 0.25);
    Frame5.Size = UDim2.fromScale(0.95, 0.95);
    Frame5.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.05, 0);
    UICorner2.Parent = Frame5;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = Frame5;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://100429874437897";
    ImageLabel.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel.ImageTransparency = 0.03;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.461396);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.9, 0.822793);
    ImageLabel.Parent = Frame5;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 1);
    TextLabel.Size = UDim2.fromScale(0.9, 0.25);
    TextLabel.Text = "100";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.Parent = Frame5;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(161, 161, 161)), ColorSequenceKeypoint.new(0.716263, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient2.Enabled = false;
    UIGradient2.Rotation = 90;
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.409836) });
    UIGradient2.Parent = Frame5;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Claimed";
    ImageLabel2.AnchorPoint = Vector2.new(1, 1);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://79889419533417";
    ImageLabel2.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel2.Position = UDim2.fromScale(0.99, 0.99);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.2, 0.2);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Visible = false;
    ImageLabel2.Parent = Frame5;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Hitbox";
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.ZIndex = 20;
    ImageButton.Parent = Frame5;
    Frame5.Parent = Frame2;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Premium";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame6.BackgroundTransparency = 0.95;
    Frame6.Position = UDim2.fromScale(0.5, 0.75);
    Frame6.Size = UDim2.fromScale(0.95, 0.95);
    Frame6.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "TextLabel";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 1);
    TextLabel2.Size = UDim2.fromScale(0.9, 0.25);
    TextLabel2.Text = "100";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.6;
    TextLabel2.Parent = Frame6;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Icon";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://100429874437897";
    ImageLabel3.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel3.ImageTransparency = 0.6;
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.461396);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.9, 0.822793);
    ImageLabel3.Parent = Frame6;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.05, 0);
    UICorner3.Parent = Frame6;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Transparency = 0.8;
    UIStroke2.Parent = Frame6;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(161, 161, 161)), ColorSequenceKeypoint.new(0.716263, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient3.Enabled = false;
    UIGradient3.Rotation = 90;
    UIGradient3.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.409836) });
    UIGradient3.Parent = Frame6;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Locked";
    ImageLabel4.AnchorPoint = Vector2.new(1, 0.200000003);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://108829592125034";
    ImageLabel4.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel4.Position = UDim2.fromScale(1, 0);
    ImageLabel4.ScaleType = Enum.ScaleType.Fit;
    ImageLabel4.Size = UDim2.fromScale(0.3, 0.25);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = Frame6;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Claimed";
    ImageLabel5.AnchorPoint = Vector2.new(1, 1);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://79889419533417";
    ImageLabel5.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel5.Position = UDim2.fromScale(0.99, 0.99);
    ImageLabel5.ScaleType = Enum.ScaleType.Fit;
    ImageLabel5.Size = UDim2.fromScale(0.2, 0.2);
    ImageLabel5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel5.Visible = false;
    ImageLabel5.Parent = Frame6;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Hitbox";
    ImageButton2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton2.Size = UDim2.fromScale(1, 1);
    ImageButton2.ZIndex = 20;
    ImageButton2.Parent = Frame6;
    Frame6.Parent = Frame2;
    Frame2.Parent = Frame;
    Frame.Parent = u22;

    return Frame;
end;

function u1.tierPurchase(p101, p102, p103) -- Line: 2711
    -- upvalues: u32 (ref), u34 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = p101;
    Frame.AnchorPoint = Vector2.new(p103, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(p103, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.5, 0);
    UICorner.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 1);
    TextLabel.Size = UDim2.fromScale(2.857, 2.857);
    TextLabel.Text = p102;
    TextLabel.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.1;
    TextLabel.Parent = Frame;
    Frame.Parent = u32;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.AnchorPoint = Vector2.new(p103, 0.5);
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.Position = UDim2.fromScale(p103, 0.5);
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.5, 0);
    UICorner2.Parent = Frame2;
    Frame2.Parent = u34;

    return Frame;
end;

return u1;