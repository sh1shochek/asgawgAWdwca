-- ReplicatedStorage.GameClient.Gui.HUD.TopBar
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.TopBar
-- Decompile time: 30.13 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
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
local u17 = false;
local u18 = false;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local LocalPlayer = Players.LocalPlayer;
local GameStats = ReplicatedStorage.GameStats;
local TweenInfo_new_ret = TweenInfo.new(0.1);
local TweenInfo_new_ret2 = TweenInfo.new(0.35, Enum.EasingStyle.Quint);
local Color3_fromRGB_ret = Color3.fromRGB(184, 214, 239);
local Color3_fromRGB_ret2 = Color3.fromRGB(234, 210, 139);
local u22 = {};
local u23 = {
    RoundTime = true,
    RoundEnded = true,
    BombPlanted = true,
    BombDefused = true,
    BombExploded = true
};

function u1.TeamUpdate(p24: string, p25: userdata, p26: userdata) -- Line: 63
    -- upvalues: Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u5 (ref), LocalPlayer (copy)
    p26.Blur.ImageColor3 = p24 == "CT" and Color3_fromRGB_ret or Color3_fromRGB_ret2;
    p26.Parent = u5[p24 .. "Players"];

    if p25 ~= LocalPlayer then
        p26.Icon.UIStroke.Color = p24 == "CT" and Color3_fromRGB_ret or Color3_fromRGB_ret2;
    end;
end;

function u1.UserDeath(p27: userdata, p28: boolean) -- Line: 72
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy)
    local v29 = p28 and 0.9 or 0;
    TweenService:Create(p27.Icon, TweenInfo_new_ret, {
        ImageTransparency = v29
    }):Play();
    TweenService:Create(p27.Blur, TweenInfo_new_ret, {
        BackgroundTransparency = v29
    }):Play();
    TweenService:Create(p27.Icon.UIStroke, TweenInfo_new_ret, {
        Transparency = v29
    }):Play();
end;

function u1.UserTeamUI(p30: userdata, p31: userdata, p32: userdata, p33: number) -- Line: 83
    if p30 ~= "Spectator" and p31 ~= p30 then
        p32.Visible = false;

        return;
    end;

    if not p33 then
        return;
    end;

    if p33 <= 0 then
        p32.Visible = false;

        return;
    end;

    p32.Visible = true;
end;

function u1.TeamAliveCount(p34: string) -- Line: 101
    -- upvalues: u22 (copy), u7 (ref), u5 (ref), TweenService (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    if p34 ~= "Spectator" then
        local v35 = 0;

        for i in u22 do
            local Health = u7.GetHealth(i);

            if i:GetAttribute("Team") == p34 and Health > 0 then
                v35 = v35 + 1;
            end;
        end;

        u5.Score[p34].Alive.TextLabel.Text = v35;
        local Amount = u5["Alive" .. p34].Amount;

        if Amount.Text ~= tostring(v35) then
            Amount.Text = v35;
            Amount.TextColor3 = Color3.new(1, 1, 1);
            TweenService:Create(Amount, TweenInfo.new(1, Enum.EasingStyle.Quart), {
                TextColor3 = p34 == "CT" and Color3_fromRGB_ret or Color3_fromRGB_ret2
            }):Play();
        end;

        return v35;
    end;
end;

function u1.CountMode() -- Line: 137
    -- upvalues: u5 (ref), u17 (ref), u23 (copy), GameStats (copy), u18 (ref), u16 (ref), u15 (ref), TweenService (copy), TweenInfo_new_ret2 (copy)
    if not u5 then
        return;
    end;

    local v36 = u17 and u23[GameStats:GetAttribute("State")] == true;

    if v36 == u18 then
        return;
    end;

    u18 = v36;
    u5.CTPlayers.Visible = not v36;
    u5.TPlayers.Visible = not v36;

    for _, v in { u16, u15 } do
        v.Visible = v36;

        if v36 then
            v.Amount.TextTransparency = 1;
            v.Title.TextTransparency = 1;
            v.BG.Frame.BackgroundTransparency = 1;
            v.BG.Frame.DOTS.ImageTransparency = 1;
            TweenService:Create(v.Amount, TweenInfo_new_ret2, {
                TextTransparency = 0
            }):Play();
            TweenService:Create(v.Title, TweenInfo_new_ret2, {
                TextTransparency = 0
            }):Play();
            TweenService:Create(v.BG.Frame, TweenInfo_new_ret2, {
                BackgroundTransparency = 0.4
            }):Play();
            TweenService:Create(v.BG.Frame.DOTS, TweenInfo_new_ret2, {
                ImageTransparency = 0.5
            }):Play();
        end;
    end;
end;

function u1.KillsUpdate(p37: userdata) -- Line: 172
    for _, child in p37.Hold.Kills:GetChildren() do
        if child:IsA("ImageButton") then
            child.Visible = false;
        end;
    end;

    p37.Hold.Kills.Extra.Visible = false;
end;

function u1.CheckBomb(p38) -- Line: 182
    -- upvalues: u8 (ref)
    if not p38 then
        return false;
    end;

    local v39 = p38[8] or p38["8"];
    local v40;

    if v39 == nil then
        v40 = false;
    else
        v40 = v39.NameEnum == u8.WeaponsNum.Bomb;
    end;

    return v40;
end;

function u1.UpdateBombIcon(p41: userdata, p42: userdata) -- Line: 194
    -- upvalues: LocalPlayer (copy), u1 (copy), u9 (ref), u7 (ref)
    if p42:GetAttribute("Team") ~= "T" then
        p41.Icon.Bomb.Visible = false;

        return;
    end;

    local v43 = false;

    if p42 == LocalPlayer then
        v43 = u1.CheckBomb(u9.GetWeaponInventory());
    else
        local CharacterByUserId = u7.GetCharacterByUserId(p42.UserId);

        if CharacterByUserId then
            v43 = u1.CheckBomb(u7.GetCharacterWeaponInventory(CharacterByUserId.Identifier));
        end;
    end;

    p41.Icon.Bomb.Visible = v43;
end;

function u1.User(u44: userdata) -- Line: 215
    -- upvalues: u1 (copy), LocalPlayer (copy), u7 (ref), u22 (copy), u5 (ref), GameStats (copy), u3 (ref), u6 (ref), u9 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    local u45 = u1.newUser();
    local UserId = u44.UserId;
    local u46 = u44:GetAttribute("Team") or "Spectator";
    local Attribute = LocalPlayer:GetAttribute("Team");
    local Line = u45.Hold.Line;
    local Health = u7.GetHealth(u44);
    local Attribute2 = u44:GetAttribute("MaxHealth");
    local u47 = 0;
    u45.Icon.Image = `rbxthumb://type=AvatarHeadShot&id={UserId}&w=420&h=420`;
    u22[u44] = {
        BarUI = u45
    };
    u1.TeamUpdate(u46, u44, u45);
    u1.UpdateBombIcon(u45, u44);
    u1.TeamAliveCount("CT");
    u1.TeamAliveCount("T");
    u5.Score.CT.Text = GameStats:GetAttribute("CTWins");
    u5.Score.T.Text = GameStats:GetAttribute("TWins");

    if Health <= 0 then
        u1.UserDeath(u45, true);
    elseif Attribute2 then
        Line.HealthBar.Size = UDim2.new(Health / Attribute2, 0, 1, 0);
        Line.RedBar.Size = UDim2.new(1 - Health / Attribute2, 0, 1, 0);
    end;

    u1.UserTeamUI(Attribute, u46, Line, Health);
    u3:Add(`{u44}_Team`, u44:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 259
        -- upvalues: u45 (copy), u46 (ref), u44 (copy), Attribute (ref), LocalPlayer (ref), u1 (ref), Line (copy), Health (ref)
        u45.Icon.Bomb.Visible = false;
        u46 = u44:GetAttribute("Team") or "Spectator";
        Attribute = LocalPlayer:GetAttribute("Team");
        u1.TeamUpdate(u46, u44, u45);
        u1.UserTeamUI(Attribute, u46, Line, Health);
        u1.TeamAliveCount("CT");
        u1.TeamAliveCount("T");
    end));

    if u44 == LocalPlayer then
        u3:Add(`{u44}_CharacterSpawn`, u6.OnCharacterSpawn:Connect(function() -- Line: 281
            -- upvalues: u1 (ref), u45 (copy), u44 (copy), u3 (ref), u9 (ref)
            u1.UpdateBombIcon(u45, u44);
            u3:Add(`{u44}_Bomb`, u9.OnWeaponChanged:Connect(function() -- Line: 284
                -- upvalues: u1 (ref), u45 (ref), u44 (ref)
                u1.UpdateBombIcon(u45, u44);
            end));
            u3:Add(`{u44}_BombCreate`, u9.OnWeaponCreate:Connect(function() -- Line: 287
                -- upvalues: u1 (ref), u45 (ref), u44 (ref)
                u1.UpdateBombIcon(u45, u44);
            end));
            u3:Add(`{u44}_BombDestroy`, u9.OnWeaponDestroy:Connect(function() -- Line: 290
                -- upvalues: u1 (ref), u45 (ref), u44 (ref)
                u1.UpdateBombIcon(u45, u44);
            end));
        end));
        u3:Add(`{u44}_CharacterDestroy`, u6.OnCharacterDestroy:Connect(function() -- Line: 295
            -- upvalues: u45 (copy), u3 (ref), u44 (copy)
            u45.Icon.Bomb.Visible = false;
            u3:Removes(`{u44}_Bomb`, `{u44}_BombCreate`, (`{u44}_BombDestroy`));
        end));
    else
        u3:Add(`{u44}_EntityCreated`, u7.OnEntityCreated:Connect(function(p48) -- Line: 302
            -- upvalues: u7 (ref), u44 (copy), u45 (copy), Attribute (ref), u3 (ref)
            if p48 ~= "Character" then
                return;
            end;

            local CharacterByUserId = u7.GetCharacterByUserId(u44.UserId);

            if not CharacterByUserId then
                return;
            end;

            local v49;

            if Attribute == "T" or Attribute == "Spectator" then
                v49 = CharacterByUserId.WeaponInventory and CharacterByUserId.WeaponInventory[8] ~= nil;
            else
                v49 = false;
            end;

            u45.Icon.Bomb.Visible = v49;
            u3:Add(`{u44}_Bomb`, CharacterByUserId.WeaponInventoryChanged:Connect(function(p50) -- Line: 315
                -- upvalues: u45 (ref), Attribute (ref)
                u45.Icon.Bomb.Visible = (Attribute == "T" or Attribute == "Spectator") and (p50 and p50[8] ~= nil) and true or false;
            end));
        end));
        u3:Add(`{u44}_EntityDestroyed`, u7.OnEntityDestroyed:Connect(function(p51) -- Line: 320
            -- upvalues: u45 (copy), u3 (ref), u44 (copy)
            if p51 ~= "Character" then
                return;
            end;

            u45.Icon.Bomb.Visible = false;
            u3:Remove((`{u44}_Bomb`));
        end));
        local CharacterByUserId = u7.GetCharacterByUserId(u44.UserId);

        if CharacterByUserId then
            local v52;

            if Attribute == "T" or Attribute == "Spectator" then
                v52 = CharacterByUserId.WeaponInventory and CharacterByUserId.WeaponInventory[8] ~= nil;
            else
                v52 = false;
            end;

            u45.Icon.Bomb.Visible = v52;
            u3:Add(`{u44}_Bomb`, CharacterByUserId.WeaponInventoryChanged:Connect(function(p53) -- Line: 334
                -- upvalues: u45 (copy), Attribute (ref)
                u45.Icon.Bomb.Visible = (Attribute == "T" or Attribute == "Spectator") and (p53 and p53[8] ~= nil) and true or false;
            end));
        end;
    end;

    u3:Add(`{u44}_Health`, u7.OnHealthUpdate:Connect(function(p54, p55) -- Line: 342
        -- upvalues: UserId (copy), Health (ref), Attribute2 (ref), u44 (copy), Line (copy), u45 (copy), u1 (ref), u46 (ref), Attribute (ref), TweenService (ref), TweenInfo_new_ret (ref)
        if p54 ~= UserId then
            return;
        end;

        Health = p55;
        Attribute2 = u44:GetAttribute("MaxHealth");

        if not Health then
            return;
        end;

        if Health <= 0 then
            Line.Visible = false;
            u45.Icon.Bomb.Visible = false;
            u1.UserDeath(u45, true);
            u1.TeamAliveCount(u46);

            return;
        end;

        u1.UserDeath(u45, false);
        u1.TeamAliveCount(u46);
        Line.Visible = Attribute == "Spectator" and true or u46 == Attribute;
        TweenService:Create(Line.HealthBar, TweenInfo_new_ret, {
            Size = UDim2.new(Health / Attribute2, 0, 1, 0)
        }):Play();
        TweenService:Create(Line.RedBar, TweenInfo_new_ret, {
            Size = UDim2.new(1 - Health / Attribute2, 0, 1, 0)
        }):Play();
    end));

    local function KillsChanged() -- Line: 382
        -- upvalues: u47 (ref), u44 (copy), u1 (ref), u45 (copy)
        u47 = u44:GetAttribute("RoundKills") or 0;

        if u47 == 0 then
            u1.KillsUpdate(u45);

            return;
        end;

        u1.KillsUpdate(u45);

        if u47 <= 5 then
            for i = 1, 5 do
                u45.Hold.Kills[tostring(i)].Visible = i <= u47;
                local _ = i;
            end;

            u45.Hold.Kills.Extra.Visible = false;

            return;
        end;

        u45.Hold.Kills["1"].Visible = true;
        u45.Hold.Kills.Extra.Visible = true;
        u45.Hold.Kills.Extra.Text = `*{u47}`;
    end;

    KillsChanged();
    u3:Add(`{u44}_Kills`, u44:GetAttributeChangedSignal("RoundKills"):Connect(KillsChanged));

    if u44 ~= LocalPlayer then
        u3:Add(`{u44}_LocalTeam`, LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 416
            -- upvalues: Attribute (ref), LocalPlayer (ref), u1 (ref), u46 (ref), Line (copy), Health (ref), u7 (ref), u44 (copy), u45 (copy)
            Attribute = LocalPlayer:GetAttribute("Team");
            u1.UserTeamUI(Attribute, u46, Line, Health);
            local CharacterByUserId = u7.GetCharacterByUserId(u44.UserId);

            if CharacterByUserId then
                local v56;

                if Attribute == "T" or Attribute == "Spectator" then
                    v56 = CharacterByUserId.WeaponInventory and CharacterByUserId.WeaponInventory[8] ~= nil;
                else
                    v56 = false;
                end;

                u45.Icon.Bomb.Visible = v56;
            end;
        end));
    end;
end;

function u1.UserLeft(p57) -- Line: 434
    -- upvalues: u22 (copy), u3 (ref)
    local v58 = u22[p57];

    if not v58 then
        return;
    end;

    v58.BarUI:Destroy();
    u3:Removes(`{p57}_Team`, `{p57}_Health`, `{p57}_Kills`, `{p57}_LocalTeam`, `{p57}_Bomb`, `{p57}_BombCreate`, `{p57}_BombDestroy`, `{p57}_CharacterSpawn`, `{p57}_CharacterDestroy`, `{p57}_EntityCreated`, (`{p57}_EntityDestroyed`));
    u22[p57] = nil;
end;

function u1.BombEnabled(p59: boolean, p60: boolean) -- Line: 446
    -- upvalues: u5 (ref)
    local Bomb = u5.Score.BG.TimeUI.Time.Bomb;
    local Prong = Bomb.Prong;
    Bomb.Visible = p59;
    Prong.Visible = p60;
end;

function u1.BombAnimate(p61: number, p62: string) -- Line: 454
    -- upvalues: u14 (ref), u12 (ref), u1 (copy), TweenService (copy), u13 (ref)
    if p61 > 234234 or p62 ~= "BombPlanted" then
        if p62 == "BombDefused" then
            u14.Text = "";
            u12.ImageColor3 = Color3.fromRGB(85, 203, 56);
            u1.BombEnabled(true, false);

            return;
        end;

        if p62 == "BombExploded" then
            u14.Text = "";
            u1.BombEnabled(false, false);

            return;
        end;

        u14.Text = string.format("%02d:%02d", math.floor(p61 / 60), p61 % 60);
        u1.BombEnabled(false, false);

        return;
    end;

    u14.Text = "";
    u12.ImageColor3 = Color3.fromRGB(255, 57, 60);
    u1.BombEnabled(true, true);
    TweenService:Create(u12, TweenInfo.new(0.5), {
        ImageTransparency = 0.7
    }):Play();
    TweenService:Create(u13, TweenInfo.new(0.5), {
        ImageTransparency = 0.7
    }):Play();
    task.delay(0.5, function() -- Line: 465
        -- upvalues: TweenService (ref), u12 (ref), u13 (ref)
        TweenService:Create(u12, TweenInfo.new(0.5), {
            ImageTransparency = 0
        }):Play();
        TweenService:Create(u13, TweenInfo.new(0.5), {
            ImageTransparency = 0
        }):Play();
    end);
end;

function u1.GameStats() -- Line: 488
    -- upvalues: GameStats (copy), u14 (ref), TweenService (copy), u19 (ref), u4 (ref), u20 (ref), u1 (copy), u5 (ref), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u21 (ref)
    GameStats:GetAttributeChangedSignal("Time"):Connect(function() -- Line: 489
        -- upvalues: GameStats (ref), u14 (ref), TweenService (ref), u19 (ref), u4 (ref), u20 (ref), u1 (ref)
        local Attribute = GameStats:GetAttribute("Time");
        local Attribute2 = GameStats:GetAttribute("State");

        if Attribute <= 10 then
            u14.TextColor3 = Color3.fromRGB(231, 40, 43);
            u14.TextTransparency = 0.4;
            TweenService:Create(u14, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                TextTransparency = 0
            }):Play();
        else
            u14.TextColor3 = Color3.fromRGB(255, 255, 255);
        end;

        local math_ceil_ret = math.ceil(Attribute);

        if Attribute2 == "Warmup" and (math_ceil_ret >= 1 and math_ceil_ret <= 5) then
            if math_ceil_ret ~= u19 then
                u19 = math_ceil_ret;
                u4.Play("UI.WarmupTimeoutBeep");
            end;
        else
            u19 = nil;
        end;

        local v63 = math_ceil_ret + 1;

        if Attribute2 == "Preparation" and (v63 >= 1 and v63 <= 3) then
            if v63 ~= u20 then
                u20 = v63;
                u4.Play("UI.CounterBeep");
            end;
        else
            u20 = nil;
        end;

        u1.BombAnimate(Attribute, Attribute2);
    end);
    GameStats:GetAttributeChangedSignal("CTWins"):Connect(function() -- Line: 534
        -- upvalues: GameStats (ref), u5 (ref), TweenService (ref), Color3_fromRGB_ret (ref)
        local Attribute = GameStats:GetAttribute("CTWins");
        u5.Score.CT.Text = Attribute;
        u5.Score.CT.TextColor3 = Color3.new(1, 1, 1);
        TweenService:Create(u5.Score.CT, TweenInfo.new(1, Enum.EasingStyle.Quart), {
            TextColor3 = Color3_fromRGB_ret
        }):Play();
    end);
    GameStats:GetAttributeChangedSignal("TWins"):Connect(function() -- Line: 543
        -- upvalues: GameStats (ref), u5 (ref), TweenService (ref), Color3_fromRGB_ret2 (ref)
        local Attribute = GameStats:GetAttribute("TWins");
        u5.Score.T.Text = Attribute;
        u5.Score.T.TextColor3 = Color3.new(1, 1, 1);
        TweenService:Create(u5.Score.T, TweenInfo.new(1, Enum.EasingStyle.Quart), {
            TextColor3 = Color3_fromRGB_ret2
        }):Play();
    end);
    GameStats:GetAttributeChangedSignal("State"):Connect(u1.CountMode);
    u21 = GameStats:GetAttribute("State");
    GameStats:GetAttributeChangedSignal("State"):Connect(function() -- Line: 556
        -- upvalues: GameStats (ref), u21 (ref), u4 (ref)
        local Attribute = GameStats:GetAttribute("State");

        if u21 == "Preparation" and Attribute == "RoundTime" then
            u4.Play("UI.CounterDoneBeep");
        end;

        u21 = Attribute;
    end);
end;

function u1.Scale(p64) -- Line: 568
    -- upvalues: u5 (ref), u11 (ref)
    if not u5 then
        return;
    end;

    if u11 then
        p64 = p64 * 1.6 or p64;
    end;

    u5.UIScale.Scale = p64;
end;

function u1.Init(p65) -- Line: 578
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u7 (ref), u9 (ref), u8 (ref), u6 (ref), u10 (ref), u11 (ref), u1 (copy), u17 (ref)
    u2 = p65:GetModule("Gui");
    u3 = p65:GetModule("Maid").new();
    u4 = p65:GetModule("SoundManager");
    u7 = p65:GetModule("Entities");
    u9 = p65:GetModule("WeaponController");
    u8 = p65:GetModule("Enums");
    u6 = p65:GetModule("CharacterController");
    u10 = p65:GetModule("GetUserPlatform");
    u11 = u10() == "Mobile";
    local Component = u2.GetComponent("Settings");
    Component:AddPlayerConnection("Game", "HUD & UI", "Topbar Scale", function(p66) -- Line: 591
        -- upvalues: u1 (ref)
        u1.Scale(p66);
    end);
    Component:AddConnection("Game", "HUD & UI", "Large Player Count", function(p67) -- Line: 595
        -- upvalues: u17 (ref), u1 (ref)
        u17 = p67;
        u1.CountMode();
    end);
end;

function u1.Start(p68) -- Line: 601
    -- upvalues: u5 (ref), u1 (copy), u15 (ref), u16 (ref), u14 (ref), u12 (ref), u13 (ref), Players (copy)
    u5 = u1.new();
    u15 = u1.newAliveT(u5);
    u16 = u1.newAliveCT(u5);
    u14 = u5.Score.BG.TimeUI.Time;
    u12 = u14.Bomb;
    u13 = u12.Prong;

    for _, v in Players:GetPlayers() do
        u1.User(v);
    end;

    Players.PlayerAdded:Connect(function(p69) -- Line: 617
        -- upvalues: u1 (ref)
        u1.User(p69);
    end);
    Players.PlayerRemoving:Connect(function(p70) -- Line: 621
        -- upvalues: u1 (ref)
        u1.UserLeft(p70);
        u1.TeamAliveCount("CT");
        u1.TeamAliveCount("T");
    end);
    u1.GameStats();
    u1.CountMode();
end;

function u1.new() -- Line: 636
    -- upvalues: u11 (ref), u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Topbar";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.005);
    Frame.Size = UDim2.fromScale(0.55, 0.055);
    Frame.ZIndex = 2;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Scale = u11 and 1.35 or 1;
    UIScale.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Score";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(0.1, 1);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Spectator";
    TextLabel.AnchorPoint = Vector2.new(1, 0);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(12.55, 0.1);
    TextLabel.Size = UDim2.fromScale(0.6, 0.5);
    TextLabel.Text = "0";
    TextLabel.TextColor3 = Color3.fromRGB(234, 234, 234);
    TextLabel.TextScaled = true;
    TextLabel.Visible = false;
    TextLabel.ZIndex = 9;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "AliveSpec";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.fromScale(1, 0.75);
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "AliveSpec";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.5, 0.75);
    TextLabel2.Text = "0";
    TextLabel2.TextColor3 = Color3.fromRGB(234, 234, 234);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = Frame3;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "IconSpec";
    ImageButton.Active = false;
    ImageButton.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.AutoLocalize = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://114953068568514";
    ImageButton.ImageColor3 = Color3.fromRGB(234, 234, 234);
    ImageButton.Position = UDim2.fromScale(0.225, 0.5);
    ImageButton.Size = UDim2.fromScale(0.25, 0.5);
    ImageButton.ZIndex = 2;
    ImageButton.Parent = Frame3;
    Frame3.Parent = TextLabel;
    TextLabel.Parent = Frame2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "CT";
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(-0.05, 0.475);
    TextLabel3.Size = UDim2.fromScale(0.6, 0.5);
    TextLabel3.Text = "0";
    TextLabel3.TextColor3 = Color3.fromRGB(184, 214, 239);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 9;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Alive";
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.AutoLocalize = false;
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.5, 1);
    Frame4.Size = UDim2.fromScale(1, 0.75);
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "TextLabel";
    TextLabel4.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel4.Size = UDim2.fromScale(0.5, 0.75);
    TextLabel4.Text = "0";
    TextLabel4.TextColor3 = Color3.fromRGB(184, 214, 239);
    TextLabel4.TextScaled = true;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = Frame4;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "ImageLabel";
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.AutoLocalize = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://114953068568514";
    ImageButton2.ImageColor3 = Color3.fromRGB(184, 214, 239);
    ImageButton2.Position = UDim2.fromScale(0.225, 0.5);
    ImageButton2.Size = UDim2.fromScale(0.25, 0.5);
    ImageButton2.ZIndex = 2;
    ImageButton2.Parent = Frame4;
    Frame4.Parent = TextLabel3;
    TextLabel3.Parent = Frame2;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "T";
    TextLabel5.AnchorPoint = Vector2.new(1, 0);
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(1.06, 0.475);
    TextLabel5.Size = UDim2.fromScale(0.6, 0.5);
    TextLabel5.Text = "0";
    TextLabel5.TextColor3 = Color3.fromRGB(234, 210, 139);
    TextLabel5.TextScaled = true;
    TextLabel5.ZIndex = 9;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Alive";
    Frame5.AnchorPoint = Vector2.new(0.5, 0);
    Frame5.AutoLocalize = false;
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0.5, 1);
    Frame5.Size = UDim2.fromScale(1, 0.75);
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "TextLabel";
    TextLabel6.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel6.Size = UDim2.fromScale(0.5, 0.75);
    TextLabel6.Text = "0";
    TextLabel6.TextColor3 = Color3.fromRGB(234, 210, 139);
    TextLabel6.TextScaled = true;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel6.ZIndex = 9;
    TextLabel6.Parent = Frame5;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "ImageLabel";
    ImageButton3.Active = false;
    ImageButton3.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton3.AutoButtonColor = false;
    ImageButton3.AutoLocalize = false;
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.Image = "rbxassetid://114953068568514";
    ImageButton3.ImageColor3 = Color3.fromRGB(234, 210, 139);
    ImageButton3.Position = UDim2.fromScale(0.225, 0.5);
    ImageButton3.Size = UDim2.fromScale(0.25, 0.5);
    ImageButton3.ZIndex = 2;
    ImageButton3.Parent = Frame5;
    Frame5.Parent = TextLabel5;
    TextLabel5.Parent = Frame2;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "BG";
    Frame6.AnchorPoint = Vector2.new(0.5, 0);
    Frame6.AutoLocalize = false;
    Frame6.BackgroundTransparency = 1;
    Frame6.LayoutOrder = 1;
    Frame6.Position = UDim2.fromScale(0.5, 0);
    Frame6.Size = UDim2.fromScale(1, 1.5);
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "TimeUI";
    Frame7.AnchorPoint = Vector2.new(0.5, 0);
    Frame7.AutoLocalize = false;
    Frame7.BackgroundColor3 = Color3.new();
    Frame7.BackgroundTransparency = 0.4;
    Frame7.BorderColor3 = Color3.new();
    Frame7.BorderSizePixel = 0;
    Frame7.Position = UDim2.fromScale(0.5, 0);
    Frame7.Size = UDim2.fromScale(1, 0.315);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.new();
    ImageLabel.ImageTransparency = 0.5;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel.ZIndex = -1;
    ImageLabel.Parent = Frame7;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Time";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.5, 0);
    TextLabel7.Size = UDim2.fromScale(1, 1);
    TextLabel7.Text = "00:00";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.ZIndex = 50;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Bomb";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.AutoLocalize = false;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://87244364684003";
    ImageLabel2.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(1.2, 1.2);
    ImageLabel2.Visible = false;
    ImageLabel2.ZIndex = 17;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Prong";
    ImageLabel3.AutoLocalize = false;
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://77942751712327";
    ImageLabel3.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(1, 1);
    ImageLabel3.ZIndex = 17;
    ImageLabel3.Parent = ImageLabel2;
    ImageLabel2.Parent = TextLabel7;
    TextLabel7.Parent = Frame7;
    Frame7.Parent = Frame6;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Frame";
    Frame8.AutoLocalize = false;
    Frame8.BackgroundColor3 = Color3.new();
    Frame8.BackgroundTransparency = 0.4;
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Position = UDim2.fromScale(0, 0.335);
    Frame8.Size = UDim2.fromScale(0.49, 0.665);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.75), NumberSequenceKeypoint.new(1, 1) });
    UIGradient.Parent = Frame8;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "DOTS";
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://91991932054752";
    ImageLabel4.ImageColor3 = Color3.new();
    ImageLabel4.ImageTransparency = 0.5;
    ImageLabel4.LayoutOrder = -1;
    ImageLabel4.ScaleType = Enum.ScaleType.Tile;
    ImageLabel4.Size = UDim2.fromScale(1, 1);
    ImageLabel4.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel4.ZIndex = -1;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = 90;
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.801111, 0.754098), NumberSequenceKeypoint.new(1, 1) });
    UIGradient2.Parent = ImageLabel4;
    ImageLabel4.Parent = Frame8;
    Frame8.Parent = Frame6;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Frame";
    Frame9.AutoLocalize = false;
    Frame9.BackgroundColor3 = Color3.new();
    Frame9.BackgroundTransparency = 0.4;
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.Position = UDim2.fromScale(0.51, 0.335);
    Frame9.Size = UDim2.fromScale(0.49, 0.665);
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Rotation = 90;
    UIGradient3.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.75), NumberSequenceKeypoint.new(1, 1) });
    UIGradient3.Parent = Frame9;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "DOTS";
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://91991932054752";
    ImageLabel5.ImageColor3 = Color3.new();
    ImageLabel5.ImageTransparency = 0.5;
    ImageLabel5.LayoutOrder = -1;
    ImageLabel5.ScaleType = Enum.ScaleType.Tile;
    ImageLabel5.Size = UDim2.fromScale(1, 1);
    ImageLabel5.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel5.ZIndex = -1;
    local UIGradient4 = Instance.new("UIGradient");
    UIGradient4.Name = "UIGradient";
    UIGradient4.Rotation = 90;
    UIGradient4.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.801111, 0.754098), NumberSequenceKeypoint.new(1, 1) });
    UIGradient4.Parent = ImageLabel5;
    ImageLabel5.Parent = Frame9;
    Frame9.Parent = Frame6;
    Frame6.Parent = Frame2;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Enabled = false;
    UIStroke.Transparency = 0.5;
    local UIGradient5 = Instance.new("UIGradient");
    UIGradient5.Name = "UIGradient";
    UIGradient5.Rotation = 90;
    UIGradient5.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.2, 0), NumberSequenceKeypoint.new(1, 1) });
    UIGradient5.Parent = UIStroke;
    UIStroke.Parent = Frame2;
    local UIGradient6 = Instance.new("UIGradient");
    UIGradient6.Name = "UIGradient";
    UIGradient6.Rotation = 90;
    UIGradient6.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.9, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient6.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "CTPlayers";
    Frame10.AutoLocalize = false;
    Frame10.BackgroundTransparency = 1;
    Frame10.Size = UDim2.new(0.45, -1, 1, 0);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0.025, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame10;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0.1, 0);
    UIPadding.PaddingLeft = UDim.new(0.02, 0);
    UIPadding.PaddingRight = UDim.new(0.02, 0);
    UIPadding.PaddingTop = UDim.new(0.05, 0);
    UIPadding.Parent = Frame10;
    Frame10.Parent = Frame;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "TPlayers";
    Frame11.AnchorPoint = Vector2.new(1, 0);
    Frame11.AutoLocalize = false;
    Frame11.BackgroundTransparency = 1;
    Frame11.Position = UDim2.fromScale(1, 0);
    Frame11.Size = UDim2.new(0.45, -1, 1, 0);
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.Padding = UDim.new(0.025, 0);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.Parent = Frame11;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingBottom = UDim.new(0.1, 0);
    UIPadding2.PaddingLeft = UDim.new(0.02, 0);
    UIPadding2.PaddingRight = UDim.new(0.02, 0);
    UIPadding2.PaddingTop = UDim.new(0.05, 0);
    UIPadding2.Parent = Frame11;
    Frame11.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 13;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint.Parent = Frame;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "SpectatorPlayers";
    Frame12.AnchorPoint = Vector2.new(1, 0);
    Frame12.AutoLocalize = false;
    Frame12.BackgroundTransparency = 1;
    Frame12.Position = UDim2.fromScale(1.65, 0);
    Frame12.Size = UDim2.new(0.45, -1, 1, 0);
    Frame12.Visible = false;
    local UIListLayout3 = Instance.new("UIListLayout");
    UIListLayout3.Name = "UIList5";
    UIListLayout3.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout3.Padding = UDim.new(0.025, 0);
    UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout3.Parent = Frame12;
    local UIPadding3 = Instance.new("UIPadding");
    UIPadding3.Name = "UIPadding5";
    UIPadding3.PaddingBottom = UDim.new(0.1, 0);
    UIPadding3.PaddingLeft = UDim.new(0.02, 0);
    UIPadding3.PaddingRight = UDim.new(0.02, 0);
    UIPadding3.PaddingTop = UDim.new(0.05, 0);
    UIPadding3.Parent = Frame12;
    Frame12.Parent = Frame;
    Frame.Parent = u2.Handler.HUD;

    return Frame;
end;

function u1.newUser() -- Line: 1137
    local Frame = Instance.new("Frame");
    Frame.Name = "WarmupPlayer";
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame.ZIndex = 4;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Icon";
    ImageButton.Active = false;
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.AutoLocalize = false;
    ImageButton.BackgroundColor3 = Color3.new();
    ImageButton.BackgroundTransparency = 1;
    ImageButton.BorderColor3 = Color3.new();
    ImageButton.BorderSizePixel = 0;
    ImageButton.Image = "rbxthumb://type=AvatarHeadShot&id=553776256&w=420&h=420";
    ImageButton.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.ZIndex = 2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Blur";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundColor3 = Color3.new();
    ImageLabel.Image = "rbxassetid://108060254555731";
    ImageLabel.ImageTransparency = 0.74;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "BlurGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.683391, Color3.fromRGB(143, 143, 143)), ColorSequenceKeypoint.new(1, Color3.fromRGB(126, 126, 126)) });
    UIGradient.Rotation = 90;
    UIGradient.Parent = ImageLabel;
    ImageLabel.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.LineJoinMode = Enum.LineJoinMode.Miter;
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.06;
    UIStroke.Parent = ImageButton;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Bomb";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://99302422432592";
    ImageLabel2.ImageColor3 = Color3.fromRGB(255, 255, 96);
    ImageLabel2.Position = UDim2.fromScale(0.75, 0.75);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.Visible = false;
    ImageLabel2.Parent = ImageButton;
    ImageButton.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Hold";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 1.1);
    Frame2.Size = UDim2.fromScale(1, 1);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Line";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 1.125);
    Frame3.Size = UDim2.new(1, 3, 0.1, 0);
    Frame3.Visible = false;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "HealthBar";
    Frame4.AnchorPoint = Vector2.new(0, 0.5);
    Frame4.AutoLocalize = false;
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0, 0.5);
    Frame4.Size = UDim2.fromScale(1, 1);
    Frame4.Parent = Frame3;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "RedBar";
    Frame5.AnchorPoint = Vector2.new(1, 0.5);
    Frame5.AutoLocalize = false;
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BackgroundTransparency = 0.5;
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.fromScale(1, 0.5);
    Frame5.Size = UDim2.fromScale(0, 1);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(1, Color3.new()) });
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.900115, 1), NumberSequenceKeypoint.new(1, 1) });
    UIGradient2.Parent = Frame5;
    Frame5.Parent = Frame3;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.Enabled = false;
    UIStroke2.Thickness = 0.4;
    UIStroke2.Transparency = 0.75;
    UIStroke2.Parent = Frame3;
    Frame3.Parent = Frame2;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Kills";
    Frame6.AnchorPoint = Vector2.new(0.5, 0);
    Frame6.AutoLocalize = false;
    Frame6.BackgroundTransparency = 1;
    Frame6.LayoutOrder = 1;
    Frame6.Position = UDim2.fromScale(0.5, 1.2);
    Frame6.Size = UDim2.new(1, 6, 0.3, 0);
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(-0.025, 0);
    UIGridLayout.CellSize = UDim2.fromScale(0.7, 0.7);
    UIGridLayout.FillDirectionMaxCells = 5;
    UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.Parent = UIGridLayout;
    UIGridLayout.Parent = Frame6;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "1";
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.AutoLocalize = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://81595911519807";
    ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton2.ScaleType = Enum.ScaleType.Fit;
    ImageButton2.Size = UDim2.fromScale(0.3, 0.5);
    ImageButton2.Visible = false;
    ImageButton2.ZIndex = 2;
    ImageButton2.Parent = Frame6;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "2";
    ImageButton3.Active = false;
    ImageButton3.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton3.AutoButtonColor = false;
    ImageButton3.AutoLocalize = false;
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.Image = "rbxassetid://81595911519807";
    ImageButton3.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton3.ScaleType = Enum.ScaleType.Fit;
    ImageButton3.Size = UDim2.fromScale(0.3, 0.5);
    ImageButton3.Visible = false;
    ImageButton3.ZIndex = 2;
    ImageButton3.Parent = Frame6;
    local ImageButton4 = Instance.new("ImageButton");
    ImageButton4.Name = "3";
    ImageButton4.Active = false;
    ImageButton4.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton4.AutoButtonColor = false;
    ImageButton4.AutoLocalize = false;
    ImageButton4.BackgroundTransparency = 1;
    ImageButton4.Image = "rbxassetid://81595911519807";
    ImageButton4.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton4.ScaleType = Enum.ScaleType.Fit;
    ImageButton4.Size = UDim2.fromScale(0.3, 0.5);
    ImageButton4.Visible = false;
    ImageButton4.ZIndex = 2;
    ImageButton4.Parent = Frame6;
    local ImageButton5 = Instance.new("ImageButton");
    ImageButton5.Name = "4";
    ImageButton5.Active = false;
    ImageButton5.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton5.AutoButtonColor = false;
    ImageButton5.AutoLocalize = false;
    ImageButton5.BackgroundTransparency = 1;
    ImageButton5.Image = "rbxassetid://81595911519807";
    ImageButton5.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton5.ScaleType = Enum.ScaleType.Fit;
    ImageButton5.Size = UDim2.fromScale(0.3, 0.5);
    ImageButton5.Visible = false;
    ImageButton5.ZIndex = 2;
    ImageButton5.Parent = Frame6;
    local ImageButton6 = Instance.new("ImageButton");
    ImageButton6.Name = "5";
    ImageButton6.Active = false;
    ImageButton6.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton6.AutoButtonColor = false;
    ImageButton6.AutoLocalize = false;
    ImageButton6.BackgroundTransparency = 1;
    ImageButton6.Image = "rbxassetid://81595911519807";
    ImageButton6.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton6.ScaleType = Enum.ScaleType.Fit;
    ImageButton6.Size = UDim2.fromScale(0.3, 0.5);
    ImageButton6.Visible = false;
    ImageButton6.ZIndex = 2;
    ImageButton6.Parent = Frame6;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Extra";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Selectable = true;
    TextLabel.Size = UDim2.fromScale(0.3, 0.5);
    TextLabel.Text = "x6";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel.Visible = false;
    TextLabel.ZIndex = 2;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Scale = 1.3;
    UIScale.Parent = TextLabel;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke3.Thickness = 0.05;
    UIStroke3.Transparency = 0.6;
    UIStroke3.Parent = TextLabel;
    TextLabel.Parent = Frame6;
    Frame6.Parent = Frame2;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame2;
    Frame2.Parent = Frame;

    return Frame;
end;

function u1.newAliveCT(p71: userdata) -- Line: 1414
    local Frame = Instance.new("Frame");
    Frame.Name = "AliveCT";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.new(0.4175, -1, 0.5, 0);
    Frame.Size = UDim2.fromScale(0.065, 1);
    Frame.Visible = false;
    Frame.Parent = p71;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.9, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "BG";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundTransparency = 1;
    Frame2.LayoutOrder = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0);
    Frame2.Size = UDim2.fromScale(1, 1.5);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BackgroundTransparency = 0.4;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 5.75109e-8);
    Frame3.Size = UDim2.fromScale(1, 1);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.new();
    ImageLabel.ImageTransparency = 0.5;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel.ZIndex = -1;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = 90;
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.299703, 0),
        NumberSequenceKeypoint.new(0.4, 0.25),
        NumberSequenceKeypoint.new(0.733, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = ImageLabel;
    ImageLabel.Parent = Frame3;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Rotation = 90;
    UIGradient3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.299703, 0),
        NumberSequenceKeypoint.new(0.4, 0.25),
        NumberSequenceKeypoint.new(0.733, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient3.Parent = Frame3;
    Frame3.Parent = Frame2;
    Frame2.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Amount";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, -0.05);
    TextLabel.Size = UDim2.fromScale(1, 0.773858);
    TextLabel.Text = "0";
    TextLabel.TextColor3 = Color3.fromRGB(184, 214, 239);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 50;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Bomb";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.AutoLocalize = false;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://87244364684003";
    ImageLabel2.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(1.2, 1.2);
    ImageLabel2.Visible = false;
    ImageLabel2.ZIndex = 17;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Prong";
    ImageLabel3.AutoLocalize = false;
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://77942751712327";
    ImageLabel3.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(1, 1);
    ImageLabel3.ZIndex = 17;
    ImageLabel3.Parent = ImageLabel2;
    ImageLabel2.Parent = TextLabel;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Bomb";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.AutoLocalize = false;
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://960098694";
    ImageLabel4.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel4.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel4.ScaleType = Enum.ScaleType.Fit;
    ImageLabel4.Size = UDim2.fromScale(1.2, 1.2);
    ImageLabel4.Visible = false;
    ImageLabel4.ZIndex = 17;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Prong";
    ImageLabel5.AutoLocalize = false;
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://960098729";
    ImageLabel5.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel5.Size = UDim2.fromScale(1, 1);
    ImageLabel5.ZIndex = 17;
    ImageLabel5.Parent = ImageLabel4;
    ImageLabel4.Parent = TextLabel;
    TextLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.6);
    TextLabel2.Size = UDim2.fromScale(1, 0.25);
    TextLabel2.Text = "ALIVE";
    TextLabel2.TextColor3 = Color3.fromRGB(184, 214, 239);
    TextLabel2.TextScaled = true;
    TextLabel2.ZIndex = 50;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "Bomb";
    ImageLabel6.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel6.AutoLocalize = false;
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://87244364684003";
    ImageLabel6.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel6.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel6.ScaleType = Enum.ScaleType.Fit;
    ImageLabel6.Size = UDim2.fromScale(1.2, 1.2);
    ImageLabel6.Visible = false;
    ImageLabel6.ZIndex = 17;
    local ImageLabel7 = Instance.new("ImageLabel");
    ImageLabel7.Name = "Prong";
    ImageLabel7.AutoLocalize = false;
    ImageLabel7.BackgroundTransparency = 1;
    ImageLabel7.Image = "rbxassetid://77942751712327";
    ImageLabel7.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel7.ScaleType = Enum.ScaleType.Fit;
    ImageLabel7.Size = UDim2.fromScale(1, 1);
    ImageLabel7.ZIndex = 17;
    ImageLabel7.Parent = ImageLabel6;
    ImageLabel6.Parent = TextLabel2;
    local ImageLabel8 = Instance.new("ImageLabel");
    ImageLabel8.Name = "Bomb";
    ImageLabel8.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel8.AutoLocalize = false;
    ImageLabel8.BackgroundTransparency = 1;
    ImageLabel8.Image = "rbxassetid://960098694";
    ImageLabel8.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel8.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel8.ScaleType = Enum.ScaleType.Fit;
    ImageLabel8.Size = UDim2.fromScale(1.2, 1.2);
    ImageLabel8.Visible = false;
    ImageLabel8.ZIndex = 17;
    local ImageLabel9 = Instance.new("ImageLabel");
    ImageLabel9.Name = "Prong";
    ImageLabel9.AutoLocalize = false;
    ImageLabel9.BackgroundTransparency = 1;
    ImageLabel9.Image = "rbxassetid://960098729";
    ImageLabel9.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel9.Size = UDim2.fromScale(1, 1);
    ImageLabel9.ZIndex = 17;
    ImageLabel9.Parent = ImageLabel8;
    ImageLabel8.Parent = TextLabel2;
    TextLabel2.Parent = Frame;

    return Frame;
end;

function u1.newAliveT(p72: userdata) -- Line: 1641
    local Frame = Instance.new("Frame");
    Frame.Name = "AliveT";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.new(0.5825, 1, 0.5, 0);
    Frame.Size = UDim2.fromScale(0.065, 1);
    Frame.Visible = false;
    Frame.Parent = p72;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.9, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "BG";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundTransparency = 1;
    Frame2.LayoutOrder = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0);
    Frame2.Size = UDim2.fromScale(1, 1.5);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BackgroundTransparency = 0.4;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 5.75109e-8);
    Frame3.Size = UDim2.fromScale(1, 1);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.new();
    ImageLabel.ImageTransparency = 0.5;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel.ZIndex = -1;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = 90;
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.299703, 0),
        NumberSequenceKeypoint.new(0.4, 0.25),
        NumberSequenceKeypoint.new(0.733, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = ImageLabel;
    ImageLabel.Parent = Frame3;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Rotation = 90;
    UIGradient3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.299703, 0),
        NumberSequenceKeypoint.new(0.4, 0.25),
        NumberSequenceKeypoint.new(0.733, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient3.Parent = Frame3;
    Frame3.Parent = Frame2;
    Frame2.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Amount";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, -0.05);
    TextLabel.Size = UDim2.fromScale(1, 0.773858);
    TextLabel.Text = "0";
    TextLabel.TextColor3 = Color3.fromRGB(234, 210, 139);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 50;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Bomb";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.AutoLocalize = false;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://87244364684003";
    ImageLabel2.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(1.2, 1.2);
    ImageLabel2.Visible = false;
    ImageLabel2.ZIndex = 17;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Prong";
    ImageLabel3.AutoLocalize = false;
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://77942751712327";
    ImageLabel3.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(1, 1);
    ImageLabel3.ZIndex = 17;
    ImageLabel3.Parent = ImageLabel2;
    ImageLabel2.Parent = TextLabel;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Bomb";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.AutoLocalize = false;
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://960098694";
    ImageLabel4.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel4.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel4.ScaleType = Enum.ScaleType.Fit;
    ImageLabel4.Size = UDim2.fromScale(1.2, 1.2);
    ImageLabel4.Visible = false;
    ImageLabel4.ZIndex = 17;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Prong";
    ImageLabel5.AutoLocalize = false;
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://960098729";
    ImageLabel5.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel5.Size = UDim2.fromScale(1, 1);
    ImageLabel5.ZIndex = 17;
    ImageLabel5.Parent = ImageLabel4;
    ImageLabel4.Parent = TextLabel;
    TextLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.6);
    TextLabel2.Size = UDim2.fromScale(1, 0.25);
    TextLabel2.Text = "ALIVE";
    TextLabel2.TextColor3 = Color3.fromRGB(234, 210, 139);
    TextLabel2.TextScaled = true;
    TextLabel2.ZIndex = 50;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "Bomb";
    ImageLabel6.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel6.AutoLocalize = false;
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://87244364684003";
    ImageLabel6.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel6.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel6.ScaleType = Enum.ScaleType.Fit;
    ImageLabel6.Size = UDim2.fromScale(1.2, 1.2);
    ImageLabel6.Visible = false;
    ImageLabel6.ZIndex = 17;
    local ImageLabel7 = Instance.new("ImageLabel");
    ImageLabel7.Name = "Prong";
    ImageLabel7.AutoLocalize = false;
    ImageLabel7.BackgroundTransparency = 1;
    ImageLabel7.Image = "rbxassetid://77942751712327";
    ImageLabel7.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel7.ScaleType = Enum.ScaleType.Fit;
    ImageLabel7.Size = UDim2.fromScale(1, 1);
    ImageLabel7.ZIndex = 17;
    ImageLabel7.Parent = ImageLabel6;
    ImageLabel6.Parent = TextLabel2;
    local ImageLabel8 = Instance.new("ImageLabel");
    ImageLabel8.Name = "Bomb";
    ImageLabel8.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel8.AutoLocalize = false;
    ImageLabel8.BackgroundTransparency = 1;
    ImageLabel8.Image = "rbxassetid://960098694";
    ImageLabel8.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel8.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel8.ScaleType = Enum.ScaleType.Fit;
    ImageLabel8.Size = UDim2.fromScale(1.2, 1.2);
    ImageLabel8.Visible = false;
    ImageLabel8.ZIndex = 17;
    local ImageLabel9 = Instance.new("ImageLabel");
    ImageLabel9.Name = "Prong";
    ImageLabel9.AutoLocalize = false;
    ImageLabel9.BackgroundTransparency = 1;
    ImageLabel9.Image = "rbxassetid://960098729";
    ImageLabel9.ImageColor3 = Color3.fromRGB(255, 57, 60);
    ImageLabel9.Size = UDim2.fromScale(1, 1);
    ImageLabel9.ZIndex = 17;
    ImageLabel9.Parent = ImageLabel8;
    ImageLabel8.Parent = TextLabel2;
    TextLabel2.Parent = Frame;

    return Frame;
end;

return u1;