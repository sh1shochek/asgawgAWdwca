-- ReplicatedStorage.GameClient.Gui.MatchEnd
-- Script path: ReplicatedStorage.GameClient.Gui.MatchEnd
-- Decompile time: 36.10 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
local ContentProvider = game:GetService("ContentProvider");
local Assets = ReplicatedStorage.Assets;
local GameStats = ReplicatedStorage.GameStats;
local _ = Assets.Idle;
local MatchEnd2 = Assets.Scenes.MatchEnd;
local LocalPlayer = Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
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
local u26 = {};
local u27 = {};
local u28 = {
    CT = Color3.fromRGB(172, 195, 220),
    T = Color3.fromRGB(255, 203, 107)
};
local u29 = {
    ["1"] = {
        Rotation = 35,
        StartPos = UDim2.new(0.25, 0, 1.25, 0)
    },
    ["2"] = {
        Rotation = 25,
        StartPos = UDim2.new(0.45, 0, 1.25, 0)
    },
    ["3"] = {
        Rotation = 15,
        StartPos = UDim2.new(0.5, 0, 1.25, 0)
    },
    ["4"] = {
        Rotation = -15,
        StartPos = UDim2.new(0.55, 0, 1.25, 0)
    },
    ["5"] = {
        Rotation = -25,
        StartPos = UDim2.new(0.75, 0, 1.25, 0)
    }
};
local u30 = {};
local u31 = false;
local u32 = false;
local TweenInfo_new_ret = TweenInfo.new(0.9, Enum.EasingStyle.Quart);
local TweenInfo_new_ret2 = TweenInfo.new(0.5, Enum.EasingStyle.Quart);
local u33 = nil;
local u34 = nil;
local u35 = nil;

local function GetPinThumbail(p36) -- Line: 86
    -- upvalues: HttpService (copy), u15 (ref)
    local Attribute = p36:GetAttribute("WeaponLoadout");

    if not Attribute then
        return;
    end;

    local v37 = HttpService:JSONDecode(Attribute).CT["19"];

    if v37 then
        v37 = v37.SkinName;
    end;

    if v37 and v37 ~= "None" then
        local Item = u15.GetItem("Badges", v37);

        if Item then
            Item = Item.Asset;
        end;

        return Item;
    end;
end;

local function DrawWhenStatsReady() -- Line: 106
    -- upvalues: u31 (ref), u32 (ref), GameStats (copy), u1 (copy)
    if u31 and (not u32 and GameStats:GetAttribute("State") == "MatchEnded") then
        u32 = true;
        u1.Draw();
    end;
end;

local u38 = 0;

function u1.Draw() -- Line: 116
    -- upvalues: u38 (ref), u1 (copy), u12 (ref), u18 (ref), u19 (ref), u20 (ref), GameStats (copy), u17 (ref), TweenService (copy), u23 (ref), u32 (ref), u3 (ref), RunService (copy), u13 (ref), workspace_CurrentCamera (copy), u9 (ref), u10 (ref), u26 (copy), TweenInfo_new_ret2 (copy)
    u38 = 1;
    u1.DrawScene();
    u1.Visible(not u12.FramePriority.MainMenu);
    u1.DrawCards();
    u1.CanvasFrame();
    u1.DrawTop();
    u18.End();
    local u39 = u19.Get("Game", "TimeScale");
    local u40 = u20.Get(GameStats:GetAttribute("Gamemode")).Timers[u17.RoundStatesNum.MatchEnded];
    local v41 = 5 - (u40 - GameStats:GetAttribute("Time"));
    local math_clamp_ret = math.clamp(v41, 0, 5);
    TimeBar.Size = UDim2.fromScale(1 - math_clamp_ret / 5, 0.06);
    TweenService:Create(TimeBar, TweenInfo.new(math_clamp_ret * u39), {
        Size = UDim2.fromScale(1, 0.06)
    }):Play();
    u23.Delay(u23.TimeToTick(math_clamp_ret), function() -- Line: 134
        -- upvalues: GameStats (ref), u32 (ref), u38 (ref), u3 (ref), RunService (ref), u13 (ref), workspace_CurrentCamera (ref), u39 (copy), TweenService (ref), u9 (ref), u10 (ref), u26 (ref), TweenInfo_new_ret2 (ref), u40 (copy), u1 (ref)
        if GameStats:GetAttribute("State") ~= "MatchEnded" or (not u32 or u38 ~= 1) then
            return;
        end;

        u3:Add("FOV", RunService.PostSimulation:Connect(function(p42) -- Line: 139
            -- upvalues: u13 (ref), workspace_CurrentCamera (ref), u39 (ref)
            if not MatchEnd.Visible then
                return;
            end;

            u13.SetFOVAmount((math.lerp(workspace_CurrentCamera.FieldOfView, 50, p42 * u39)));
        end));
        TweenService:Create(u9, TweenInfo.new(2.5 * u39, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            CFrame = u10
        }):Play();

        for _, v in u26 do
            TweenService:Create(v, TweenInfo_new_ret2, {
                GroupTransparency = 1
            }):Play();
        end;

        TweenService:Create(MatchEnd.Canvas, TweenInfo_new_ret2, {
            GroupTransparency = 1
        }):Play();
        local Attribute = GameStats:GetAttribute("Time");
        local math_min_ret = math.min(Attribute, u40 - 5);
        TimeBar.Size = UDim2.fromScale(1 - math_min_ret / (u40 - 5), 0.06);
        TweenService:Create(TimeBar, TweenInfo.new(math_min_ret * u39), {
            Size = UDim2.fromScale(1, 0.06)
        }):Play();
        u1.DrawMapVote();
        u38 = 2;
    end);
end;

function u1.DrawScene() -- Line: 165
    -- upvalues: GameStats (copy), MatchEnd2 (copy), u8 (ref), u9 (ref), u10 (ref), u11 (ref)
    local v43 = MatchEnd2[GameStats:GetAttribute("Map")]:Clone();
    v43.Parent = workspace;
    u8 = v43;
    u9 = v43[Team].Camera;
    u10 = u9.CFrame;
    u9.CFrame = u10 * CFrame.new(0, -1.2, 0);
    u11 = v43[Team].Rigs:GetChildren();
    table.sort(u11, function(p44, p45) -- Line: 179
        return p44.Name < p45.Name;
    end);
end;

function u1.DrawCards() -- Line: 184
    -- upvalues: u28 (copy), u26 (copy), Players (copy), u11 (ref), HttpService (copy), u16 (ref), u29 (copy), GetPinThumbail (copy), u25 (ref), u30 (ref), u17 (ref), u38 (ref), TweenService (copy), u21 (ref)
    local u46 = u28[Team];
    local u47 = 0;

    for _, v in u26 do
        v.Visible = false;
        v.GroupTransparency = 1;
    end;

    local v48 = { "Rifle", "Pistol", "SMG", "Heavy", "Sniper Rifle" };

    for i = #v48, 2, -1 do
        local math_random_ret = math.random(i);
        local v49 = v48[i];
        v48[i] = v48[math_random_ret];
        v48[math_random_ret] = v49;
        local _ = i;
    end;

    for _, v in Players:GetPlayers() do
        if v:GetAttribute("Team") == Team and u47 < 5 then
            u47 = u47 + 1;
            local u50 = u47;
            local v51 = u11[u50];
            local v52 = v48[u50] or "Rifle";
            local Attribute = v:GetAttribute("WeaponLoadout");

            if Attribute then
                Attribute = HttpService:JSONDecode(Attribute);
            end;

            if Attribute then
                Attribute = Attribute[Team];
            end;

            local v53 = {};
            local u54;

            if Attribute then
                u54 = v;

                for _, v2 in Attribute do
                    if v2.WeaponName and u16.GetWeaponClass(v2.WeaponName) == v52 then
                        table.insert(v53, {
                            WeaponName = v2.WeaponName,
                            SkinName = v2.SkinName
                        });
                    end;
                end;
            else
                u54 = v;
            end;

            local v55 = nil;
            local v56, v57;

            if #v53 > 0 then
                local v58 = v53[math.random(#v53)];
                v56 = v58.WeaponName;
                v57 = v58.SkinName;
            else
                if v52 == "Rifle" then
                    v56 = Team == "CT" and "M4A4" or "AK-47";
                elseif v52 == "Pistol" then
                    v56 = Team == "CT" and "USP-S" or "Glock-18";
                elseif v52 == "SMG" then
                    v56 = Team == "CT" and "MP9" or "MAC-10";
                elseif v52 == "Heavy" then
                    v56 = Team == "CT" and "MAG-7" or "Sawed-Off";
                else
                    v56 = v52 == "Sniper Rifle" and "AWP" or v55;
                end;

                v57 = "Stock";
            end;

            local v59;

            if Attribute then
                v59 = Attribute["15"];
            else
                v59 = Attribute;
            end;

            local v60 = v59 and v59.SkinName or `{Team} Agent`;

            if Attribute then
                Attribute = Attribute["16"];
            end;

            local v61 = Attribute and Attribute.WeaponName or `{Team} Gloves`;
            local v62 = Attribute and Attribute.SkinName or "Stock";
            local u63 = u16.new({
                Name = `{Team}_MatchEnd`,
                Agent = v60,
                Gloves = {
                    WeaponName = v61,
                    SkinName = v62
                }
            });
            u63:SetPrimaryPartCFrame(v51.HumanoidRootPart.CFrame);
            u63.Parent = v51;
            u16.AddWeapon(u63, v56, v57);
            local v64 = u16.AnimationIds[v52];

            if v64 then
                local Animation = Instance.new("Animation");
                Animation.AnimationId = v64.Match_End_Begin;
                local v65 = u63.Humanoid.Animator:LoadAnimation(Animation);
                v65.Priority = Enum.AnimationPriority.Action;
                v65.Looped = false;
                local Animation2 = Instance.new("Animation");
                Animation2.AnimationId = v64.Match_End_Idle;
                local u66 = u63.Humanoid.Animator:LoadAnimation(Animation2);
                u66.Priority = Enum.AnimationPriority.Action;
                u66.Looped = true;
                v65:Play();
                v65.Stopped:Once(function() -- Line: 282
                    -- upvalues: u63 (copy), u66 (copy)
                    if u63 and u63.Parent then
                        u66:Play(0.3);
                    end;
                end);
            end;

            task.delay(0.1, function() -- Line: 289
                -- upvalues: u26 (ref), u50 (copy), u47 (ref), u29 (ref), u54 (copy), GetPinThumbail (ref), u25 (ref), u46 (copy), u30 (ref), u17 (ref), u38 (ref), TweenService (ref), u21 (ref)
                local u67 = u26[u50];
                local Card = u67.Card;
                local v68 = u50;

                if u47 == 1 then
                    v68 = 3;
                elseif u47 == 2 then
                    v68 = u50 % 2 == 0 and 4 or 2;
                elseif u47 == 3 then
                    v68 = u50 + 1;
                elseif u47 == 4 then
                    v68 = u50 > 2 and u50 + 1 or u50;
                end;

                local v69 = u29[tostring(v68)];
                Card.UIScale.Scale = 0.75;
                Card.Rotation = v69.Rotation;
                Card.Position = v69.StartPos;
                Card.PlayerIcon.Image = `rbxthumb://type=AvatarHeadShot&id={u54.UserId}&w=150&h=150`;
                Card.Info.PlayerName.Text = u54.Name;
                Card.Pin.Image = GetPinThumbail(u54) or "";
                local Color = u25.GetColor(u54, Team, u46);
                Card.Background.UIStroke.Color = Color;
                Card.Stats.Background.ImageColor3 = Color;
                Card.Stats.ADR.Title.TextColor3 = Color;
                Card.Stats.HSP.Title.TextColor3 = Color;
                Card.Stats.KDA.Title.TextColor3 = Color;
                local v70 = u30[u54.UserId];

                if v70 then
                    Card.Stats.ADR.Text = tostring(v70.MatchADR);
                    Card.Stats.HSP.Text = tostring(v70.MatchHSP) .. "%";
                    Card.Info.PlayerClass.Text = u17.MatchClasses[v70.MatchClass] or "";
                    local v71 = u17.MatchClassInfo[v70.MatchClass];

                    if v71 and v71 ~= "" then
                        Card.Info.ClassInfo.Text = string.format(v71, tonumber(v70.MatchClassInfo) or 0);
                    else
                        Card.Info.ClassInfo.Text = "";
                    end;
                else
                    Card.Stats.ADR.Text = "0";
                    Card.Stats.HSP.Text = "0%";
                    Card.Info.PlayerClass.Text = "The Participant";
                    Card.Info.ClassInfo.Text = "";
                end;

                local v72 = u54:GetAttribute("Kills") or 0;
                local v73 = u54:GetAttribute("Deaths") or 0;
                local v74 = u54:GetAttribute("Assists") or 0;
                Card.Stats.KDA.Text = v72 .. "-" .. v73 .. "-" .. v74;
                u67.Visible = true;
                task.delay(u50 * 0.8 - 0.8, function() -- Line: 349
                    -- upvalues: u38 (ref), TweenService (ref), u67 (copy), Card (copy), u21 (ref)
                    if u38 ~= 1 then
                        return;
                    end;

                    local TweenInfo_new_ret3 = TweenInfo.new(1.15, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
                    local TweenInfo_new_ret4 = TweenInfo.new(0.9, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
                    local TweenInfo_new_ret5 = TweenInfo.new(0.75, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
                    TweenService:Create(u67, TweenInfo_new_ret3, {
                        GroupTransparency = 0
                    }):Play();
                    TweenService:Create(Card, TweenInfo_new_ret4, {
                        Rotation = 0,
                        Position = UDim2.fromScale(0.5, 0.5)
                    }):Play();
                    TweenService:Create(Card.UIScale, TweenInfo_new_ret5, {
                        Scale = 0.375
                    }):Play();
                    u21.Play("UI.cards_select");
                end);
            end);
        end;
    end;
end;

function u1.CanvasFrame() -- Line: 368
    -- upvalues: GameStats (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local Attribute = GameStats:GetAttribute("CTWins");
    local Attribute2 = GameStats:GetAttribute("TWins");
    local v75 = Attribute == Attribute2 and "TIE" or ((Team == "CT" and Attribute2 < Attribute or Team == "T" and Attribute < Attribute2) and "VICTORY" or "DEFEAT");
    local v76;

    if v75 == "VICTORY" then
        v76 = Color3.fromRGB(12, 191, 122);
    elseif v75 == "DEFEAT" then
        v76 = Color3.fromRGB(191, 62, 64);
    else
        v76 = Color3.fromRGB(221, 221, 221);
    end;

    TextLabelState.TextColor3 = v76;
    TextLabelState.UIStroke.Color = v76;
    TextLabelState.PineTree1.TextColor3 = v76;
    TextLabelState.PineTree2.TextColor3 = v76;
    TextLabelState.Text = v75;

    if Team == "CT" then
        ScoreTextLabel.Text = `<font weight="semibold"><b>{Attribute}</b></font>-{Attribute2}`;
    else
        ScoreTextLabel.Text = `{Attribute}-<font weight="semibold"><b>{Attribute2}</b></font>`;
    end;

    MatchEnd.Canvas.GroupTransparency = 1;
    MatchEnd.Canvas.Size = UDim2.fromScale(0.75, 0.15);
    task.wait(0.25);
    TweenService:Create(MatchEnd.Canvas, TweenInfo.new(1, Enum.EasingStyle.Quart), {
        GroupTransparency = 0,
        Size = UDim2.fromScale(0.6, 0.15)
    }):Play();

    for _, v in { MatchEnd.Canvas.Top, MatchEnd.Canvas.Bottom } do
        v.CanvasGroup.UIStroke.Color = v76;
        v.CanvasGroup.ImageLabel.ImageColor3 = v76;
        v.Flash.BackgroundTransparency = 0;
        TweenService:Create(v.Flash, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        }):Play();
    end;
end;

function u1.DrawTop() -- Line: 419
    -- upvalues: GameStats (copy), u3 (ref)
    local Attribute = GameStats:GetAttribute("Time");
    TimeTextLabel.Text = string.format("%02d:%02d", math.floor(Attribute / 60), Attribute % 60);
    u3:Add("Time", GameStats:GetAttributeChangedSignal("Time"):Connect(function() -- Line: 423
        -- upvalues: Attribute (ref), GameStats (ref)
        Attribute = GameStats:GetAttribute("Time");
        TimeTextLabel.Text = string.format("%02d:%02d", math.floor(Attribute / 60), Attribute % 60);
    end));
end;

local u77 = nil;

function u1.DrawMapVote() -- Line: 431
    -- upvalues: HttpService (copy), GameStats (copy), Players (copy), u1 (copy), u14 (ref), u3 (ref), u21 (ref), u24 (ref), u77 (ref), u27 (copy)
    local v78 = HttpService:JSONDecode(GameStats:GetAttribute("MapVote"));
    local v79 = #Players:GetPlayers();

    for i, v in v78 do
        local v80 = u1.newMap(MatchEnd.MapVoting);
        local v81 = u14[i];
        v80.MapName.Text = v81.Name;
        v80.Votes.Text = `{v.Votes}/{v79}`;
        v80.Image = `rbxassetid://{v81.Thumbnail}`;
        v80.Visible = true;
        local Players2 = v80.Players;
        local u82 = i;

        for i2, _ in v.Players or {} do
            u1.newPlayer(Players2, i2);
        end;

        u3:Add(`{u82}_MouseButton1Click`, v80.MouseButton1Click:Connect(function() -- Line: 451
            -- upvalues: u21 (ref), u24 (ref), u82 (copy), u77 (ref)
            u21.Play("UI.generic_press");
            u24.Gui.VoteForMap.Fire(u82);
            u77 = u82;
        end));
        u27[u82] = v80;
    end;

    u77 = nil;
    u3:Add("MapVote", GameStats:GetAttributeChangedSignal("MapVote"):Connect(u1.MapVoteUpdate));
end;

function u1.MapVoteUpdate() -- Line: 467
    -- upvalues: HttpService (copy), GameStats (copy), Players (copy), u27 (copy), u1 (copy), u77 (ref), TweenService (copy)
    local v83 = HttpService:JSONDecode(GameStats:GetAttribute("MapVote"));
    local v84 = #Players:GetPlayers();

    for i, v in u27 do
        local v85 = v83[i];
        v.Votes.Text = `{v85 and (v85.Votes or 0) or 0}/{v84}`;
        local Players2 = v.Players;
        local v86 = v85 and v85.Players or {};
        local v87 = v;

        for _, child in Players2:GetChildren() do
            if child:IsA("ImageButton") and not v86[child.Name] then
                child:Destroy();
            end;
        end;

        for i2 in v86 do
            if not Players2:FindFirstChild((tostring(i2))) then
                u1.newPlayer(Players2, i2);
            end;
        end;

        if u77 == i then
            TweenService:Create(v87.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                Thickness = 2
            }):Play();
        else
            TweenService:Create(v87.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                Thickness = 0
            }):Play();
        end;
    end;
end;

local function SetHUDGameplayVisible(p88) -- Line: 500
    -- upvalues: u5 (ref), u2 (ref), u33 (ref), u34 (ref)
    if not u5 then
        u5 = u2 and u2.Handler and u2.Handler.HUD;
    end;

    local v89 = u33 or u2 and u2.GetComponent("Crosshair");
    u33 = v89;
    local v90 = u34 or u2 and u2.GetComponent("Radar");
    u34 = v90;

    if u33 then
        u33.SetVisible(p88);
    end;

    if u34 then
        u34.Enabled(p88);
    end;

    if u5 then
        if u5:FindFirstChild("Down") then
            u5.Down.Visible = p88;
        end;

        if u5:FindFirstChild("Killfeed") then
            u5.Killfeed.Visible = p88;
        end;

        if u5:FindFirstChild("ui") then
            u5.ui.Visible = p88;
        end;

        if u5:FindFirstChild("Inventory") then
            u5.Inventory.Visible = p88;
        end;

        if u5:FindFirstChild("Money") then
            u5.Money.Visible = p88;
        end;

        if u5:FindFirstChild("Topbar") then
            u5.Topbar.Visible = p88;
        end;

        if u5:FindFirstChild("Notifications") then
            u5.Notifications.Visible = p88;
        end;

        if not p88 and u5:FindFirstChild("Scope") then
            u5.Scope.Visible = false;
        end;
    end;
end;

function u1.Visible(p91) -- Line: 525
    -- upvalues: u5 (ref), u22 (ref), u13 (ref), u9 (ref), u38 (ref), u12 (ref), GameStats (copy), SetHUDGameplayVisible (copy)
    MatchEnd.Visible = p91;

    if u5 then
        u5.Visible = p91;
    end;

    if p91 then
        u22.CleanupSpectateTarget();
        u13.SetTarget(u9);
        u13.SetFOVAmount(u38 == 2 and 50 or 65);
    end;

    u12.SetFramePriority("MatchEnd", p91);
    local v92 = GameStats:GetAttribute("State") == "MatchEnded";
    SetHUDGameplayVisible(not p91 and not v92);
end;

function u1.Destroy() -- Line: 546
    -- upvalues: u3 (ref), u38 (ref), u10 (ref), u8 (ref), u27 (copy), u12 (ref), SetHUDGameplayVisible (copy), u35 (ref)
    u3:Removes("Time", "MapVote", "FOV");
    MatchEnd.Visible = false;
    u38 = 0;
    u10 = nil;

    if u8 then
        u8:Destroy();
    end;

    for i, v in u27 do
        u3:Remove((`{i}_MouseButton1Click`));
        v:Destroy();
    end;

    table.clear(u27);
    u12.SetFramePriority("MatchEnd", false);
    SetHUDGameplayVisible(true);

    if u12.FramePriority.MainMenu then
        return;
    end;

    u35.Activate();
end;

function u1.Init(p93) -- Line: 575
    -- upvalues: u2 (ref), u13 (ref), u14 (ref), u35 (ref), u15 (ref), u24 (ref), u16 (ref), u18 (ref), u12 (ref), u21 (ref), u17 (ref), u3 (ref), u23 (ref), u19 (ref), u20 (ref), u22 (ref), u25 (ref), u1 (copy), ContentProvider (copy), GameStats (copy), SetHUDGameplayVisible (copy), u31 (ref), u32 (ref), u30 (ref), LocalPlayer (copy)
    u2 = p93:GetModule("Gui");
    u13 = p93:GetModule("CameraController");
    u14 = p93:GetModule("GamemodesData").Maps;
    u35 = u2.GetComponent("TeamSelection");
    u15 = p93:GetModule("ItemManager");
    u24 = p93:GetModule("Network");
    u16 = p93:GetModule("CharacterModel");
    u18 = p93:GetModule("Freecam");
    u12 = p93:GetModule("BindsController");
    u21 = p93:GetModule("SoundManager");
    u17 = p93:GetModule("Enums");
    u3 = p93:GetModule("Maid").new();
    u23 = p93:GetModule("Tick");
    u19 = p93:GetModule("GameConfiguration");
    u20 = p93:GetModule("GamemodesConfig");
    u22 = p93:GetModule("Spectate");
    u25 = p93:GetModule("PlayerColor");
    u1.new();
    task.spawn(function() -- Line: 596
        -- upvalues: u16 (ref), ContentProvider (ref)
        local v94 = {};

        for _, v in u16.AnimationIds do
            if v.Match_End_Begin then
                local Animation = Instance.new("Animation");
                Animation.AnimationId = v.Match_End_Begin;
                table.insert(v94, Animation);
            end;

            if v.Match_End_Idle then
                local Animation = Instance.new("Animation");
                Animation.AnimationId = v.Match_End_Idle;
                table.insert(v94, Animation);
            end;
        end;

        if #v94 > 0 then
            pcall(ContentProvider.PreloadAsync, ContentProvider, v94);

            for _, v in v94 do
                v:Destroy();
            end;
        end;
    end);
    local Attribute = GameStats:GetAttribute("State");
    GameStats:GetAttributeChangedSignal("State"):Connect(function() -- Line: 620
        -- upvalues: GameStats (ref), SetHUDGameplayVisible (ref), u31 (ref), u32 (ref), u1 (ref), Attribute (ref), u30 (ref)
        if GameStats:GetAttribute("State") ~= "MatchEnded" then
            if Attribute == "MatchEnded" then
                u1.Destroy();
                table.clear(u30);
                u31 = false;
                u32 = false;
                Attribute = "";
            end;

            return;
        end;

        SetHUDGameplayVisible(false);

        if u31 and (not u32 and GameStats:GetAttribute("State") == "MatchEnded") then
            u32 = true;
            u1.Draw();
        end;

        Attribute = "MatchEnded";
    end);
    Team = LocalPlayer:GetAttribute("Team");
    Team = Team == "Spectator" and "CT" or Team;
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 636
        -- upvalues: LocalPlayer (ref)
        Team = LocalPlayer:GetAttribute("Team");
        Team = Team == "Spectator" and "CT" or Team;
    end);
    u30 = {};
    u24.Gui.MatchEndStats.On(function(p95) -- Line: 651
        -- upvalues: u30 (ref), u31 (ref), u32 (ref), GameStats (ref), u1 (ref)
        table.clear(u30);

        for _, v in pairs(p95) do
            u30[v.UserId] = v;
        end;

        u31 = true;

        if u31 and (not u32 and GameStats:GetAttribute("State") == "MatchEnded") then
            u32 = true;
            u1.Draw();
        end;
    end);
end;

function u1.Start(p96) -- Line: 661
    -- upvalues: u4 (ref), u2 (ref), u34 (ref), u33 (ref), u5 (ref), GameStats (copy), u31 (ref), DrawWhenStatsReady (copy), u7 (ref), u6 (ref)
    u4 = u2.GetComponent("MainMenu");
    u34 = u2.GetComponent("Radar");
    u33 = u2.GetComponent("Crosshair");
    local Handler = u2.Handler;
    MainMenu = Handler.MainMenu;
    u5 = Handler.HUD;

    if GameStats:GetAttribute("State") == "MatchEnded" then
        u31 = true;
        task.spawn(DrawWhenStatsReady);
    end;

    task.delay(1, function() -- Line: 675
        -- upvalues: u7 (ref), Handler (copy), u6 (ref)
        u7 = Handler.Inspect;
        u6 = Handler.CaseInspect;
    end);
end;

function u1.new() -- Line: 683
    -- upvalues: u26 (copy), u1 (copy), u2 (ref)
    MatchEnd = Instance.new("Frame");
    MatchEnd.Name = "MatchEnd";
    MatchEnd.AnchorPoint = Vector2.new(0.5, 0.5);
    MatchEnd.AutoLocalize = false;
    MatchEnd.BackgroundTransparency = 1;
    MatchEnd.Position = UDim2.fromScale(0.5, 0.5);
    MatchEnd.Size = UDim2.fromScale(1, 1);
    MatchEnd.Visible = false;
    local Frame = Instance.new("Frame");
    Frame.Name = "TopFrame";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.AutoLocalize = false;
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.2;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 0);
    Frame.Size = UDim2.fromScale(1, 0.06);
    TimeTextLabel = Instance.new("TextLabel");
    TimeTextLabel.Name = "Time";
    TimeTextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TimeTextLabel.AutoLocalize = false;
    TimeTextLabel.BackgroundTransparency = 1;
    TimeTextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TimeTextLabel.Position = UDim2.new(0.8, 0, 0.5, 2);
    TimeTextLabel.Size = UDim2.fromScale(0.15, 0.8);
    TimeTextLabel.Text = "11:11";
    TimeTextLabel.TextColor3 = Color3.new(1, 1, 1);
    TimeTextLabel.TextScaled = true;
    TimeTextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TimeTextLabel.ZIndex = 8;
    TimeTextLabel.Parent = Frame;
    TimeBar = Instance.new("Frame");
    TimeBar.Name = "Bar";
    TimeBar.AnchorPoint = Vector2.new(0, 1);
    TimeBar.BackgroundColor3 = Color3.fromRGB(100, 148, 150);
    TimeBar.BorderColor3 = Color3.new();
    TimeBar.BorderSizePixel = 0;
    TimeBar.Position = UDim2.fromScale(0, 1);
    TimeBar.Size = UDim2.fromScale(0.885166, 0.06);
    TimeBar.Parent = Frame;
    Frame.Parent = MatchEnd;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "MapVoting";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.16);
    Frame2.Size = UDim2.fromScale(0.2, 0.09);
    Frame2.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.15, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame2;
    Frame2.Parent = MatchEnd;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Cards";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 1.08);
    Frame3.Size = UDim2.fromScale(0.8, 0.307);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    Frame3.ZIndex = 2;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout2.Padding = UDim.new(-0.45, 5);
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout2.Parent = Frame3;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = Frame3;

    for i = 1, 5 do
        u26[i] = u1.newCard(Frame3, i);
        local _ = i;
    end;

    Frame3.Parent = MatchEnd;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Canvas";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.18);
    CanvasGroup.Size = UDim2.fromScale(0.6, 0.15);
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Top";
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.new(0.5, 0, 0, 2);
    Frame4.Size = UDim2.fromScale(1, 0.224805);
    ScoreTextLabel = Instance.new("TextLabel");
    ScoreTextLabel.Name = "TextLabel";
    ScoreTextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ScoreTextLabel.BackgroundTransparency = 1;
    ScoreTextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    ScoreTextLabel.Position = UDim2.fromScale(0.5, 0.5);
    ScoreTextLabel.RichText = true;
    ScoreTextLabel.Size = UDim2.fromScale(1, 0.9);
    ScoreTextLabel.Text = "<font weight=\"semibold\"><b>13</b></font>-10";
    ScoreTextLabel.TextColor3 = Color3.new(1, 1, 1);
    ScoreTextLabel.TextScaled = true;
    ScoreTextLabel.ZIndex = 5;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(12, 191, 122);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.03;
    UIStroke.Transparency = 0.84;
    UIStroke.Parent = ScoreTextLabel;
    ScoreTextLabel.Parent = Frame4;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Flash";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.fromScale(0.5, 0.5);
    Frame5.Size = UDim2.new(1, 0, 1, 4);
    Frame5.ZIndex = 10;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.100423, 0),
        NumberSequenceKeypoint.new(0.900106, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame5;
    Frame5.Parent = Frame4;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "CanvasGroup";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.ClipsDescendants = true;
    Frame6.Position = UDim2.fromScale(0.5, 0.5);
    Frame6.Size = UDim2.fromScale(1, 1);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://138812586531678";
    ImageLabel.ImageColor3 = Color3.fromRGB(12, 191, 122);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.82);
    ImageLabel.ScaleType = Enum.ScaleType.Crop;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel.TileSize = UDim2.fromScale(0.95, 0.9);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.198537, 0.497268),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(0.799373, 0.513661),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = ImageLabel;
    ImageLabel.Parent = Frame6;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.Color = Color3.fromRGB(8, 128, 82);
    UIStroke2.Thickness = 1.7;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 190, 190)), ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 190)) });
    UIGradient3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.198537, 0.497268),
        NumberSequenceKeypoint.new(0.499478, 0),
        NumberSequenceKeypoint.new(0.799373, 0.513661),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient3.Parent = UIStroke2;
    UIStroke2.Parent = Frame6;
    Frame6.Parent = Frame4;
    Frame4.Parent = CanvasGroup;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Bottom";
    Frame7.AnchorPoint = Vector2.new(0.5, 1);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.new(0.5, 0, 1, -2);
    Frame7.Size = UDim2.fromScale(1, 0.661117);
    TextLabelState = Instance.new("TextLabel");
    TextLabelState.Name = "TextLabel";
    TextLabelState.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabelState.BackgroundTransparency = 1;
    TextLabelState.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabelState.Position = UDim2.fromScale(0.5, 0.5);
    TextLabelState.Size = UDim2.fromScale(1, 0.8);
    TextLabelState.Text = "VICTORY";
    TextLabelState.TextColor3 = Color3.fromRGB(12, 191, 122);
    TextLabelState.TextScaled = true;
    TextLabelState.ZIndex = 5;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.Color = Color3.fromRGB(12, 191, 122);
    UIStroke3.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke3.Thickness = 0.03;
    UIStroke3.Transparency = 0.84;
    UIStroke3.Parent = TextLabelState;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "PineTree1";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.275, 0.5);
    TextLabel.Size = UDim2.fromScale(0.025, 1);
    TextLabel.Text = "»";
    TextLabel.TextColor3 = Color3.fromRGB(12, 191, 122);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.7;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = TextLabelState;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "PineTree2";
    TextLabel2.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.725, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.025, 1);
    TextLabel2.Text = "«";
    TextLabel2.TextColor3 = Color3.fromRGB(12, 191, 122);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.7;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = TextLabelState;
    TextLabelState.Parent = Frame7;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Flash";
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.5, 0.5);
    Frame8.Size = UDim2.new(1, 0, 1, 4);
    Frame8.ZIndex = 10;
    local UIGradient4 = Instance.new("UIGradient");
    UIGradient4.Name = "UIGradient";
    UIGradient4.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.100423, 0),
        NumberSequenceKeypoint.new(0.900106, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient4.Parent = Frame8;
    Frame8.Parent = Frame7;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "CanvasGroup";
    Frame9.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame9.BackgroundTransparency = 1;
    Frame9.ClipsDescendants = true;
    Frame9.Position = UDim2.fromScale(0.5, 0.5);
    Frame9.Size = UDim2.fromScale(1, 1);
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "ImageLabel";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://138812586531678";
    ImageLabel2.ImageColor3 = Color3.fromRGB(12, 191, 122);
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Crop;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    local UIGradient5 = Instance.new("UIGradient");
    UIGradient5.Name = "UIGradient";
    UIGradient5.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.198537, 0.497268),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(0.799373, 0.513661),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient5.Parent = ImageLabel2;
    ImageLabel2.Parent = Frame9;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "UIStroke";
    UIStroke4.Color = Color3.fromRGB(8, 128, 82);
    UIStroke4.Thickness = 1.7;
    local UIGradient6 = Instance.new("UIGradient");
    UIGradient6.Name = "UIGradient";
    UIGradient6.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 190, 190)), ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 190)) });
    UIGradient6.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.198537, 0.497268),
        NumberSequenceKeypoint.new(0.499478, 0),
        NumberSequenceKeypoint.new(0.799373, 0.513661),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient6.Parent = UIStroke4;
    UIStroke4.Parent = Frame9;
    Frame9.Parent = Frame7;
    Frame7.Parent = CanvasGroup;
    CanvasGroup.Parent = MatchEnd;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Vignette";
    Frame10.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame10.BackgroundColor3 = Color3.new();
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.fromScale(0.5, 0.5);
    Frame10.Size = UDim2.fromScale(1, 1);
    Frame10.ZIndex = -1;
    local UIGradient7 = Instance.new("UIGradient");
    UIGradient7.Name = "UIGradient";
    UIGradient7.Rotation = 90;
    UIGradient7.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.754098),
        NumberSequenceKeypoint.new(0.100956, 1),
        NumberSequenceKeypoint.new(0.800455, 1),
        NumberSequenceKeypoint.new(1, 0.75)
    });
    UIGradient7.Parent = Frame10;
    Frame10.Parent = MatchEnd;
    MatchEnd.Parent = u2.Handler;
end;

function u1.newMap(p97) -- Line: 1166
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Map";
    ImageButton.Active = false;
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.AutoLocalize = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://131413802758115";
    ImageButton.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton.ScaleType = Enum.ScaleType.Crop;
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(1, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.99, Color3.fromRGB(252, 252, 252)), ColorSequenceKeypoint.new(1, Color3.fromRGB(173, 173, 173)) });
    UIGradient.Rotation = 45;
    UIGradient.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Votes";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.876923, 0.844658);
    TextLabel.Size = UDim2.fromScale(0.161538, 0.2);
    TextLabel.Text = "0/1";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.ZIndex = 8;
    TextLabel.Parent = ImageButton;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "MapName";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.05);
    TextLabel2.Size = UDim2.fromScale(1, 0.2);
    TextLabel2.Text = "Dust II";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.ZIndex = 8;
    TextLabel2.Parent = ImageButton;
    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "UIShadow";
    UIShadow.BlurRadius = UDim.new(0, 20);
    UIShadow.Transparency = 0.18;
    UIShadow.Parent = ImageButton;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.05, 0);
    UICorner.BottomRightRadius = UDim.new(0.05, 0);
    UICorner.CornerRadius = UDim.new(0.05, 0);
    UICorner.TopLeftRadius = UDim.new(0.05, 0);
    UICorner.TopRightRadius = UDim.new(0.05, 0);
    UICorner.Parent = ImageButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Enabled = true;
    UIStroke.Thickness = 0;
    UIStroke.Parent = ImageButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Players";
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.03, 0.844658);
    Frame.Size = UDim2.fromScale(0.7, 0.2);
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(0.01, 0.1);
    UIGridLayout.CellSize = UDim2.fromScale(1, 1);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.StartCorner = Enum.StartCorner.BottomLeft;
    UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.Parent = UIGridLayout;
    UIGridLayout.Parent = Frame;
    Frame.Parent = ImageButton;
    ImageButton.Parent = p97;

    return ImageButton;
end;

function u1.newPlayer(p98, p99) -- Line: 1277
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = p99;
    ImageButton.Active = false;
    ImageButton.BackgroundColor3 = Color3.new();
    ImageButton.BackgroundTransparency = 0.8;
    ImageButton.Image = `rbxthumb://type=AvatarHeadShot&id={p99}&w=420&h=420`;
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(1, 0);
    UICorner.BottomRightRadius = UDim.new(1, 0);
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.TopLeftRadius = UDim.new(1, 0);
    UICorner.TopRightRadius = UDim.new(1, 0);
    UICorner.Parent = ImageButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Parent = ImageButton;
    ImageButton.Parent = p98;
end;

function u1.newCard(p100, p101) -- Line: 1306
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = p101;
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Size = UDim2.fromScale(1, 0.667);
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Scale = 3.6;
    UIScale.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "Card";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 0.667);
    Frame.ZIndex = 5;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Stats";
    Frame2.AutoLocalize = false;
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.05, -0.045);
    Frame2.Size = UDim2.fromScale(0.237887, 0.75);
    Frame2.ZIndex = 5;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "ADR";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0);
    TextLabel.Size = UDim2.fromScale(0.9, 0.6);
    TextLabel.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    TextLabel.Text = "0";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 8;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel2.Size = UDim2.fromScale(1, 0.625);
    TextLabel2.Text = "ADR";
    TextLabel2.TextColor3 = Color3.fromRGB(166, 107, 217);
    TextLabel2.TextScaled = true;
    TextLabel2.ZIndex = 8;
    TextLabel2.Parent = TextLabel;
    TextLabel.Parent = Frame2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "KDA";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.25);
    TextLabel3.Size = UDim2.fromScale(0.9, 0.5);
    TextLabel3.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    TextLabel3.Text = "10-10-5";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 8;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.5, 0.8);
    TextLabel4.Size = UDim2.fromScale(1, 0.75);
    TextLabel4.Text = "KDA";
    TextLabel4.TextColor3 = Color3.fromRGB(166, 107, 217);
    TextLabel4.TextScaled = true;
    TextLabel4.ZIndex = 8;
    TextLabel4.Parent = TextLabel3;
    TextLabel3.Parent = Frame2;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "HSP";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel5.Size = UDim2.fromScale(0.9, 0.5);
    TextLabel5.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    TextLabel5.Text = "0%";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.ZIndex = 8;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Title";
    TextLabel6.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.5, 0.8);
    TextLabel6.Size = UDim2.fromScale(1, 0.75);
    TextLabel6.Text = "HSP";
    TextLabel6.TextColor3 = Color3.fromRGB(166, 107, 217);
    TextLabel6.TextScaled = true;
    TextLabel6.ZIndex = 8;
    TextLabel6.Parent = TextLabel5;
    TextLabel5.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Background";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.ClipsDescendants = true;
    ImageLabel.Image = "rbxassetid://108237102928206";
    ImageLabel.ImageColor3 = Color3.fromRGB(166, 107, 217);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1.2, 1.25);
    ImageLabel.ZIndex = 5;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.600152, 0),
        NumberSequenceKeypoint.new(0.764036, 0.754098),
        NumberSequenceKeypoint.new(0.835562, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = ImageLabel;
    ImageLabel.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Info";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 0.817249);
    Frame3.Size = UDim2.fromScale(0.95, 0.315502);
    Frame3.ZIndex = 5;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "PlayerName";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.5, 0);
    TextLabel7.Size = UDim2.fromScale(0.9, 0.15);
    TextLabel7.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    TextLabel7.Text = "WhyNotMyUsername";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.ZIndex = 8;
    TextLabel7.Parent = Frame3;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Line";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.200000003);
    Frame4.AutoLocalize = false;
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BackgroundTransparency = 0.9;
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.new(0.5, 0, 0.24, 4);
    Frame4.Size = UDim2.new(1, 0, 0, 2);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.100267, 0),
        NumberSequenceKeypoint.new(0.899733, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = Frame4;
    Frame4.Parent = Frame3;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "PlayerClass";
    TextLabel8.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel8.AutoLocalize = false;
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Italic);
    TextLabel8.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel8.Size = UDim2.fromScale(0.9, 0.1);
    TextLabel8.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    TextLabel8.Text = "The Participant";
    TextLabel8.TextColor3 = Color3.new(1, 1, 1);
    TextLabel8.TextScaled = true;
    TextLabel8.ZIndex = 8;
    TextLabel8.Parent = Frame3;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "ClassInfo";
    TextLabel9.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel9.AutoLocalize = false;
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Light, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(0.5, 0.85);
    TextLabel9.Size = UDim2.fromScale(0.9, 0.1);
    TextLabel9.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    TextLabel9.Text = "";
    TextLabel9.TextColor3 = Color3.new(1, 1, 1);
    TextLabel9.TextScaled = true;
    TextLabel9.ZIndex = 8;
    TextLabel9.Parent = Frame3;
    Frame3.Parent = Frame;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Background";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.AutoLocalize = false;
    ImageLabel2.BackgroundColor3 = Color3.fromRGB(79, 79, 79);
    ImageLabel2.Image = "rbxassetid://140584023150304";
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Crop;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.ZIndex = 2;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.05, 0);
    UICorner.BottomRightRadius = UDim.new(0.05, 0);
    UICorner.CornerRadius = UDim.new(0.05, 0);
    UICorner.TopLeftRadius = UDim.new(0.05, 0);
    UICorner.TopRightRadius = UDim.new(0.05, 0);
    UICorner.Parent = ImageLabel2;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(166, 107, 217);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.01;
    UIStroke.Parent = ImageLabel2;
    ImageLabel2.Parent = Frame;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "PlayerIcon";
    ImageLabel3.AnchorPoint = Vector2.new(0.25, 0.150000006);
    ImageLabel3.AutoLocalize = false;
    ImageLabel3.BackgroundColor3 = Color3.fromRGB(52, 52, 52);
    ImageLabel3.Image = "rbxthumb://type=AvatarHeadShot&id=2994385561&w=420&h=420";
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.25);
    ImageLabel3.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel3.ZIndex = 5;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.BottomLeftRadius = UDim.new(1, 0);
    UICorner2.BottomRightRadius = UDim.new(1, 0);
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.TopLeftRadius = UDim.new(1, 0);
    UICorner2.TopRightRadius = UDim.new(1, 0);
    UICorner2.Parent = ImageLabel3;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke2.Thickness = 0.02;
    UIStroke2.Transparency = 0.9;
    UIStroke2.Parent = ImageLabel3;
    ImageLabel3.Parent = Frame;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.BottomLeftRadius = UDim.new(0.05, 0);
    UICorner3.BottomRightRadius = UDim.new(0.05, 0);
    UICorner3.CornerRadius = UDim.new(0.05, 0);
    UICorner3.TopLeftRadius = UDim.new(0.05, 0);
    UICorner3.TopRightRadius = UDim.new(0.05, 0);
    UICorner3.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 0.69;
    UIAspectRatioConstraint.Parent = Frame;
    local UIScale2 = Instance.new("UIScale");
    UIScale2.Name = "UIScale";
    UIScale2.Scale = 0.375;
    UIScale2.Parent = Frame;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Shadow";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://186491278";
    ImageLabel4.ImageColor3 = Color3.new();
    ImageLabel4.Position = UDim2.new(0.5, 0, 0.5, 2);
    ImageLabel4.ScaleType = Enum.ScaleType.Slice;
    ImageLabel4.Size = UDim2.fromScale(1.175, 1.125);
    ImageLabel4.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel4.ZIndex = -1;
    ImageLabel4.Parent = Frame;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Pin";
    ImageLabel5.AutoLocalize = false;
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://100429874437897";
    ImageLabel5.Position = UDim2.fromScale(0.75, 0.04);
    ImageLabel5.Size = UDim2.fromScale(0.2, 0.2);
    ImageLabel5.ZIndex = 5;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.Parent = ImageLabel5;
    ImageLabel5.Parent = Frame;
    Frame.Parent = CanvasGroup;
    local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint3.AspectRatio = 0.69;
    UIAspectRatioConstraint3.Parent = CanvasGroup;
    CanvasGroup.Parent = p100;

    return CanvasGroup;
end;

return u1;