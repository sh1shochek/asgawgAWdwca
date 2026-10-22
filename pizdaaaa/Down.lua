-- ReplicatedStorage.GameClient.Gui.HUD.Down
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Down
-- Decompile time: 38.91 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
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
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local GameStats = game:GetService("ReplicatedStorage"):WaitForChild("GameStats");
local u34 = nil;
local u35 = {};
local u36 = {
    ["1"] = 0.125,
    ["2"] = 0.14285714285714285,
    ["3"] = 0.16666666666666666,
    ["4"] = 0.16666666666666666,
    ["5"] = 0.16666666666666666,
    ["6"] = 0.16666666666666666,
    ["7"] = 0.14285714285714285,
    ["8"] = 0.16666666666666666,
    ["9"] = 0.16666666666666666,
    ["0"] = 0.16666666666666666,
    [" "] = 0.16666666666666666,
    ["$"] = 0.16666666666666666
};
local u37 = {
    Cards4 = {
        {
            name = "Card4",
            rot = 16,
            z = 5,
            text = "4",
            fx = 0.49,
            fy = 0.92,
            pos = UDim2.new(0.562, 0, 0.23, -3)
        },
        {
            name = "Card3",
            rot = 5,
            z = 4,
            text = "2",
            pos = UDim2.new(0.52, 0, 0.1, -3)
        },
        {
            name = "Card2",
            rot = -6,
            z = 2,
            text = "2",
            pos = UDim2.new(0.48, 0, 0.12, -3)
        },
        {
            name = "Card1",
            rot = -18,
            z = 1,
            text = "2",
            pos = UDim2.new(0.438, 0, 0.25, -3)
        },
        {
            name = "Card5",
            disabled = true
        }
    },
    Cards3 = {
        {
            name = "Card3",
            rot = 8,
            z = 3,
            text = "3",
            pos = UDim2.new(0.53, 0, 0.1, -3)
        },
        {
            name = "Card2",
            rot = 0,
            z = 2,
            text = "2",
            pos = UDim2.new(0.5, 0, 0.08, -3)
        },
        {
            name = "Card1",
            rot = -8,
            z = 1,
            text = "2",
            pos = UDim2.new(0.47, 0, 0.12, -3)
        },
        {
            name = "Card4",
            disabled = true
        },
        {
            name = "Card5",
            disabled = true
        }
    },
    Cards2 = {
        {
            name = "Card2",
            rot = 5,
            z = 2,
            text = "2",
            pos = UDim2.new(0.52, 0, 0.1, -3)
        },
        {
            name = "Card1",
            rot = -6,
            z = 1,
            text = "2",
            pos = UDim2.new(0.48, 0, 0.12, -3)
        },
        {
            name = "Card3",
            disabled = true
        },
        {
            name = "Card4",
            disabled = true
        },
        {
            name = "Card5",
            disabled = true
        }
    },
    Cards1 = {
        {
            name = "Card1",
            rot = 0,
            z = 1,
            text = "1",
            pos = UDim2.new(0.5, 0, 0.08, -3)
        },
        {
            name = "Card2",
            disabled = true
        },
        {
            name = "Card3",
            disabled = true
        },
        {
            name = "Card4",
            disabled = true
        },
        {
            name = "Card5",
            disabled = true
        }
    },
    Cards5 = {
        {
            name = "Card5",
            rot = 16,
            z = 5,
            text = "5",
            fy = 0.92,
            isWhite = true,
            pos = UDim2.new(0.562, 0, 0.23, -3)
        },
        {
            name = "Card4",
            rot = 8,
            z = 4,
            text = "2",
            isWhite = true,
            pos = UDim2.new(0.53, 0, 0.1, -3)
        },
        {
            name = "Card3",
            rot = 0,
            z = 3,
            text = "2",
            isWhite = true,
            pos = UDim2.new(0.5, 0, 0.08, -3)
        },
        {
            name = "Card2",
            rot = -8,
            z = 2,
            text = "2",
            isWhite = true,
            pos = UDim2.new(0.47, 0, 0.12, -3)
        },
        {
            name = "Card1",
            rot = -18,
            z = 1,
            text = "2",
            isWhite = true,
            pos = UDim2.new(0.438, 0, 0.25, -3)
        }
    }
};
local u38 = {};
local TweenInfo_new_ret = TweenInfo.new(0.2);
local TweenInfo_new_ret2 = TweenInfo.new(0.1);
local TweenInfo_new_ret3 = TweenInfo.new(0.25);
local TweenInfo_new_ret4 = TweenInfo.new(0.15);
local u39 = {
    Top = UDim2.new(0.5, 0, 0.49, 0),
    Bottom = UDim2.new(0.5, 0, 0.51, 0),
    Left = UDim2.new(0.49, 0, 0.5, 0),
    Right = UDim2.new(0.51, 0, 0.5, 0)
};
local u40 = {
    CT = Color3.fromRGB(184, 214, 239),
    T = Color3.fromRGB(234, 210, 139),
    Spectator = Color3.fromRGB(255, 255, 255)
};
local LocalPlayer = Players.LocalPlayer;
local LocalPlayer2 = Players.LocalPlayer;
local u41 = nil;
local u42 = nil;
local u43 = nil;

local function zfill(p44, p45) -- Line: 119
    local v46 = tostring(p44);
    local v47 = #v46;

    if p45 <= v47 then
        return v46;
    end;

    return string.rep(" ", p45 - v47) .. v46;
end;

function u1.SetHealth() -- Line: 133
    -- upvalues: u21 (ref), LocalPlayer2 (ref), u32 (ref), u4 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), u14 (ref)
    local Health = u21.GetHealth(LocalPlayer2);

    if not Health then
        return;
    end;

    if Health <= 0 then
        return;
    end;

    local v48 = (u32 == nil or u32 <= Health) and true or false;
    u32 = Health;
    u4.HealthText.Text = Health;
    u4.DropHP.Text = Health;
    local HealthLine = u4.HealthLine;
    local v49 = Health / LocalPlayer2:GetAttribute("MaxHealth");
    TweenService:Create(HealthLine.HealthBar, TweenInfo_new_ret2, {
        Size = UDim2.new(v49, 0, 1, 0)
    }):Play();
    TweenService:Create(HealthLine.RedBar, TweenInfo_new_ret2, {
        Size = UDim2.new(1 - v49, 0, 1, 0)
    }):Play();

    if v48 then
        if Health > 20 then
            TweenService:Create(u4.HPBlur, TweenInfo_new_ret2, {
                ImageTransparency = 1
            }):Play();
        end;

        return;
    end;

    TweenService:Create(u4.HPBlur, TweenInfo_new_ret2, {
        ImageTransparency = 0
    }):Play();
    TweenService:Create(u4.HealthText, TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromScale(1, 0.9),
        Position = UDim2.new(0.5, 0, math.random(400, 500) / 1000, 0)
    }):Play();
    TweenService:Create(u4.HealthLine, TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromScale(1, 0.13),
        Position = UDim2.new(0, 0, math.random(600, 700) / 1000, 0)
    }):Play();
    u14:Delay(0.03, function() -- Line: 187
        -- upvalues: Health (copy), TweenService (ref), u4 (ref), TweenInfo_new_ret2 (ref)
        if Health > 20 then
            TweenService:Create(u4.HPBlur, TweenInfo_new_ret2, {
                ImageTransparency = 0.3
            }):Play();
        end;

        TweenService:Create(u4.HealthText, TweenInfo.new(0.03, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1, 0.8),
            Position = UDim2.new(0.5, math.random(-2, 4), 0.5, 0)
        }):Play();
        TweenService:Create(u4.HealthLine, TweenInfo.new(0.03, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1, 0.1),
            Position = UDim2.new(0, math.random(-2, 4), 0.6, 0)
        }):Play();
    end);
    u14:Delay(0.06, function() -- Line: 205
        -- upvalues: Health (copy), TweenService (ref), u4 (ref), TweenInfo_new_ret2 (ref)
        if Health > 20 then
            TweenService:Create(u4.HPBlur, TweenInfo_new_ret2, {
                ImageTransparency = 0.5
            }):Play();
        end;

        TweenService:Create(u4.HealthLine, TweenInfo_new_ret2, {
            Position = UDim2.new(0, 0, 0.75, 0)
        }):Play();
        TweenService:Create(u4.HealthText, TweenInfo_new_ret2, {
            Position = UDim2.new(0.5, 0, 0.45, 0)
        }):Play();
        TweenService:Create(u4.DropHP, TweenInfo_new_ret2, {
            TextTransparency = 0.5
        }):Play();
    end);
    u14:Delay(0.2, function() -- Line: 216
        -- upvalues: TweenService (ref), u4 (ref)
        TweenService:Create(u4.DropHP, TweenInfo.new(0.5), {
            TextTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.75, 0)
        }):Play();
    end);
    u14:Delay(0.3, function() -- Line: 223
        -- upvalues: Health (copy), TweenService (ref), u4 (ref), TweenInfo_new_ret2 (ref)
        if Health > 20 then
            TweenService:Create(u4.HPBlur, TweenInfo_new_ret2, {
                ImageTransparency = 1
            }):Play();
        end;
    end);
    u14:Delay(0.75, function() -- Line: 229
        -- upvalues: u4 (ref)
        u4.DropHP.Position = UDim2.new(0.5, 0, 0.45, 0);
    end);
end;

function u1.SetArmour() -- Line: 236
    -- upvalues: LocalPlayer2 (ref), u12 (ref)
    u12.Text = LocalPlayer2:GetAttribute("ArmorValue") or "0";
end;

function u1.SetArmourVisible() -- Line: 242
    -- upvalues: LocalPlayer2 (ref), u12 (ref)
    local Attribute = LocalPlayer2:GetAttribute("HasHelmet");
    u12.Parent.Visible = Attribute or false;
end;

function u1.SetAmmo(p50: number) -- Line: 250
    -- upvalues: u9 (ref)
    u9.StoredAmmo.AmmoRightText.Text = p50 or "0";
end;

function u1.SetAmmoIcon(p51: number) -- Line: 254
    -- upvalues: u9 (ref)
    u9.StoredAmmo.AmmoIcon.Image = `rbxassetid://{p51}` or "rbxassetid://98690031947493";
end;

function u1.AmmoEnable(p52: boolean) -- Line: 258
    -- upvalues: u9 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    if p52 then
        u9.AmmoScale.Scale = 0.5;
        TweenService:Create(u9.AmmoScale, TweenInfo_new_ret, {
            Scale = 1
        }):Play();
    end;

    u9.Visible = p52;
end;

function u1.SetAvailableAmmo(p53: number, p54: string) -- Line: 268
    -- upvalues: u9 (ref), u15 (ref), u33 (ref), TweenService (copy), u14 (ref)
    local AmmoLeftText = u9.AmmoLeftText;

    if p53 == nil then
        return;
    end;

    u9.AMBlur.Visible = p53 <= u15.Get(p54).Data.ClipSize * 0.2;
    local v55 = u33 == nil and true or u33 <= p53;
    u33 = p53;

    if v55 then
        AmmoLeftText.Text = p53 or "0";

        return;
    end;

    AmmoLeftText.Text = p53 or "0";
    TweenService:Create(AmmoLeftText, TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromScale(0.5, 1.1),
        Position = UDim2.new(0, 0, math.random(400, 500) / 1000, 0)
    }):Play();
    u14:Delay(0.2, function() -- Line: 294
        -- upvalues: TweenService (ref), AmmoLeftText (copy)
        TweenService:Create(AmmoLeftText, TweenInfo.new(0.03, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, math.random(-2, 4), 0.5, 0),
            Size = UDim2.fromScale(0.5, 1)
        }):Play();
    end);
    u14:Delay(0.05, function() -- Line: 301
        -- upvalues: TweenService (ref), AmmoLeftText (copy)
        TweenService:Create(AmmoLeftText, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0.5, 0)
        }):Play();
    end);
end;

function u1.CircleUpdate() -- Line: 309
    -- upvalues: LocalPlayer2 (ref), u6 (ref), LocalPlayer (copy), u17 (ref), u40 (copy), u16 (ref)
    local Attribute = LocalPlayer2:GetAttribute("Team");
    u6.PlayerIcon.Visible = false;

    if LocalPlayer2 == LocalPlayer then
        if Attribute == "CT" then
            u6.TeamIcon.Image = "rbxassetid://80131603188765";
            u6.TeamIcon.Visible = true;
        elseif Attribute == "T" then
            u6.TeamIcon.Image = "rbxassetid://140248025461311";
            u6.TeamIcon.Visible = true;
        end;

        u6.LeftLine.Visible = true;
        u6.RightLine.Visible = true;
    end;

    if LocalPlayer2 ~= LocalPlayer then
        u6.TeamIcon.Visible = false;
        u6.PlayerIcon.Image = `rbxthumb://type=AvatarHeadShot&id={LocalPlayer2.UserId}&w=420&h=420`;
        u6.PlayerIcon.Visible = true;
        u6.LeftLine.Visible = false;
        u6.RightLine.Visible = false;
    end;

    if u17 and u17.IsCompetitive() then
        u6.CircleStroke.Color = u17.GetColor(LocalPlayer2, Attribute);
    else
        u6.CircleStroke.Color = u40[Attribute];
    end;

    u16.SetUser(LocalPlayer2);
end;

function u1.SetGlowImage(p56: number, p57: string) -- Line: 350
    -- upvalues: u26 (copy)
    local v58 = u26[p56];

    if not v58 or v58.Main.Image == p57 then
        return;
    end;

    v58.Main.Image = p57;

    for _, v in v58.Layers do
        v.Image = p57;
    end;
end;

function u1.SetGlowVisible(p59: number, p60: boolean) -- Line: 363
    -- upvalues: u26 (copy)
    local v61 = u26[p59];

    if not v61 then
        return;
    end;

    for _, v in p60 and v61.Show or v61.Hide do
        v:Play();
    end;
end;

function u1.UpdateRarityGlow() -- Line: 374
    -- upvalues: u27 (ref), u8 (ref), u28 (ref), u29 (ref), u30 (ref), u1 (copy), u26 (copy)
    if not (u27 and u8) then
        return;
    end;

    if u28 == u8 and u29 == u30 then
        return;
    end;

    if u28 and u28 ~= u8 then
        u1.SetGlowVisible(u28, false);
    end;

    for _, v in u26[u8].Layers do
        v.ImageColor3 = u30;
    end;

    u1.SetGlowVisible(u8, true);
    u28 = u8;
    u29 = u30;
end;

function u1.SetRarityGlow(p62: boolean) -- Line: 396
    -- upvalues: u27 (ref), u1 (copy), u28 (ref), u29 (ref)
    u27 = p62;

    if p62 then
        u1.UpdateRarityGlow();

        return;
    end;

    if u28 then
        u1.SetGlowVisible(u28, false);
        u28 = nil;
        u29 = nil;
    end;
end;

function u1.InvUpdate() -- Line: 409
    -- upvalues: LocalPlayer2 (ref), u23 (ref), LocalPlayer (copy), u21 (ref), u25 (ref), u1 (copy), u22 (ref), u15 (ref)
    local v63;

    if LocalPlayer2 then
        v63 = u23.GetWeaponInventory();
    else
        v63 = nil;
    end;

    if LocalPlayer2 ~= LocalPlayer then
        local CharacterByUserId = u21.GetCharacterByUserId(LocalPlayer2.UserId);

        if CharacterByUserId then
            v63 = u21.GetCharacterWeaponInventory(CharacterByUserId.Identifier);
        end;
    end;

    if not v63 then
        return;
    end;

    for i, v in u25 do
        local v64 = v63[i] or v63[tostring(i)];

        if v64 then
            local v65;

            if i < 8 then
                v65 = i > 3;
            else
                v65 = false;
            end;

            local v66 = v65 and v.Parent.Parent or v.Parent;

            if v65 then
                v.Dot.Visible = false;
                v.LayoutOrder = 8 - i;
            end;

            local v67 = `rbxassetid://{u15.Get(v64.Name or u22 and u22.Weapons[v64.NameEnum]).GuiInformation.Icon}`;
            v.Image = v67;
            u1.SetGlowImage(i, v67);
            v66.Visible = true;
        elseif i < 8 and i > 3 then
            v.LayoutOrder = 0;
            v.Image = "";
            u1.SetGlowImage(i, "");
            v.Dot.Visible = true;
            v.Amount.Visible = false;
        else
            v.Parent.Visible = false;
        end;
    end;
end;

function u1.AmmoIconUpdate(p68: string, p69: number?) -- Line: 463
    -- upvalues: u15 (ref), u9 (ref)
    local Data = u15.Get(p68).Data;
    local v70 = Data.AltFunction and Data.AltFunction.Name == "Burst";
    u9.StoredAmmo.AmmoIcon.Image = `rbxassetid://{v70 and p69 == 2 and 123066928709048 or (v70 and not Data.Automatic and 79870209659965 or 98690031947493)}`;
end;

function u1.UpdateEquippedWeapon(p71) -- Line: 471
    -- upvalues: LocalPlayer2 (ref), u23 (ref), HttpService (copy), u8 (ref), u25 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), u19 (ref), u20 (ref), u15 (ref), u10 (ref), u30 (ref), u24 (ref), u1 (copy), LocalPlayer (copy)
    if not p71 and LocalPlayer2 then
        p71 = u23.GetCurrentWeapon();
    end;

    if not p71 then
        return;
    end;

    if typeof(p71) == "string" then
        p71 = HttpService:JSONDecode(p71);
    end;

    local Slot = p71.Slot;

    if u8 then
        local v72;

        if u8 < 8 then
            v72 = u8 > 3;
        else
            v72 = false;
        end;

        local v73 = u25[u8];
        local v74 = v72 and v73.Parent.Parent or v73.Parent;
        TweenService:Create(v73, TweenInfo_new_ret2, {
            ImageTransparency = 0.35
        }):Play();
        TweenService:Create(v74.WeaponName, TweenInfo_new_ret2, {
            TextTransparency = 1
        }):Play();
        TweenService:Create(v73.UIScale, TweenInfo_new_ret2, {
            Scale = v72 and 1 or 0.75
        }):Play();
    end;

    local v75;

    if Slot < 8 then
        v75 = Slot > 3;
    else
        v75 = false;
    end;

    local v76 = u25[Slot];
    local WeaponName = (v75 and v76.Parent.Parent or v76.Parent).WeaponName;
    local Name = p71.Name;
    local v77 = p71.Skin or "Stock";
    local v78 = u19.GetItem(Name, v77) or u20.GetWeaponSkin(Name, v77);
    local v79 = (u19.GetCategory(Name) or u15.Get(Name)).DisplayName or Name;
    local v80 = v78.DisplayName or v77;
    local v81 = p71.OwnerName or p71.Owner;
    local v82;

    if p71.NameTag == "" then
        v82 = false;
    else
        v82 = p71.NameTag;
    end;

    local KillTrack = p71.KillTrack;
    local v83 = v81 and v81 ~= LocalPlayer2.Name and (`{v81}'s ` or "") or "";
    local v84 = v82 and `''{v82}''` or (v80 == "Stock" and v79 and v79 or `{v79} | {v80}`);

    if KillTrack then
        v84 = `KillTrackᴷ⁺ {v84}`;
    end;

    WeaponName.Text = `{v83}{v84}`;
    u10.WeaponText.Text = `{v83}{v84}`;
    TweenService:Create(v76, TweenInfo_new_ret2, {
        ImageTransparency = 0
    }):Play();
    TweenService:Create(WeaponName, TweenInfo_new_ret2, {
        TextTransparency = 0
    }):Play();
    TweenService:Create(v76.UIScale, TweenInfo_new_ret2, {
        Scale = v75 and 1.1 or 0.85
    }):Play();
    u30 = u24[v78.Rarity or "Stock"] or u24.Stock;

    if Slot >= 3 then
        u1.AmmoEnable(false);
    else
        if u8 ~= Slot then
            u1.AmmoEnable(true);
        end;

        u1.AmmoIconUpdate(Name, p71.Mode);

        if LocalPlayer2 == LocalPlayer then
            u1.SetAvailableAmmo(p71.Data.Ammo, Name);
            u1.SetAmmo(p71.Data.ReserveAmmo);
        else
            u1.SetAvailableAmmo(p71.Ammo, Name);
            u1.SetAmmo(p71.ReserveAmmo);
        end;
    end;

    u8 = Slot;
    u1.UpdateRarityGlow();
end;

function u1.UpdateMoney() -- Line: 557
    -- upvalues: LocalPlayer2 (ref), u35 (copy), u36 (copy)
    local Attribute = LocalPlayer2:GetAttribute("Cash");
    local v85 = `${tostring(Attribute)}`;
    local v86 = tostring(v85);
    local v87 = #v86;

    if v87 < 6 then
        v86 = string.rep(" ", 6 - v87) .. v86;
    end;

    local v88 = v86:split("");

    for i, v in u35 do
        local v89 = v:FindFirstChildWhichIsA("UIPageLayout");
        local v90 = v88[i] or " ";
        v89:JumpTo(v[v90]);
        v.Size = UDim2.new(u36[v90], 0, 1, 0);
    end;
end;

function u1.UpdateMoneyBuyZone(p91) -- Line: 573
    -- upvalues: u31 (ref), TweenService (copy), TweenInfo_new_ret3 (copy), u41 (ref)
    if p91 and not u31.Visible then
        u31.BackgroundTransparency = 1;
        u31.ImageTransparency = 1;
        TweenService:Create(u31, TweenInfo_new_ret3, {
            BackgroundTransparency = 0,
            ImageTransparency = 0
        }):Play();
    end;

    u31.Visible = p91;
    u41.Enabled("Buymenu", p91);
end;

local u92 = nil;
local u93 = {};
local u94 = nil;

function u1.CardsColor(p95) -- Line: 592
    -- upvalues: u93 (copy)
    for _, v in ipairs(u93) do
        v.Stroke.Color = p95;
        v.Image.ImageColor3 = p95;
        v.Text.TextColor3 = p95;
    end;
end;

function u1.UpdateCards() -- Line: 600
    -- upvalues: LocalPlayer2 (ref), u92 (ref), u94 (ref), TweenService (copy), u37 (copy)
    local Attribute = LocalPlayer2:GetAttribute("RoundKills");

    if Attribute <= 0 then
        u92.Visible = false;

        return;
    end;

    u92.Visible = true;
    local v96 = Attribute > 5 and 1 or math.max(1, Attribute);
    local u97 = u92[`Card{v96}`];

    if u94 == u97 then
        if Attribute > 5 then
            u97.Frame.CenterText.Text = math.min(Attribute, 99);
            TweenService:Create(u97.Frame.Shine, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                BackgroundTransparency = 0.2
            }):Play();
            TweenService:Create(u97.Frame.Shine.ShineStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                Transparency = 0.2
            }):Play();
            task.delay(0.2, function() -- Line: 621
                -- upvalues: TweenService (ref), u97 (copy)
                TweenService:Create(u97.Frame.Shine, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                    BackgroundTransparency = 1
                }):Play();
                TweenService:Create(u97.Frame.Shine.ShineStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                    Transparency = 1
                }):Play();
            end);
        end;

        return;
    end;

    for _, v in u37[`Cards{v96}`] do
        local u98 = u92[v.name];

        if v.disabled then
            u98.Visible = false;
            u94 = nil;
        else
            u98.Visible = true;
            u98.Frame.CenterText.Text = v.text;

            if u98 == u97 then
                u98.Position = v.pos;
                u98.Rotation = v.rot;
                u98.Frame.Position = UDim2.fromScale(v.fx or 0.5, 1.05);
                u98.Frame.CenterText.Text = math.min(Attribute, 99);
                TweenService:Create(u98.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                    Position = UDim2.fromScale(v.fx or 0.5, v.fy or 0.93)
                }):Play();
                TweenService:Create(u98.Frame.Shine, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                    BackgroundTransparency = 0.2
                }):Play();
                TweenService:Create(u98.Frame.Shine.ShineStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                    Transparency = 0.2
                }):Play();
                task.delay(0.2, function() -- Line: 653
                    -- upvalues: TweenService (ref), u98 (copy)
                    TweenService:Create(u98.Frame.Shine, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                        BackgroundTransparency = 1
                    }):Play();
                    TweenService:Create(u98.Frame.Shine.ShineStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                        Transparency = 1
                    }):Play();
                end);
            else
                TweenService:Create(u98, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                    Position = v.pos,
                    Rotation = v.rot
                }):Play();
                TweenService:Create(u98.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                    Position = UDim2.fromScale(v.fx or 0.5, v.fy or 0.93)
                }):Play();
            end;
        end;
    end;

    u94 = u97;
end;

function u1.Scale(p99) -- Line: 668
    -- upvalues: u43 (ref), u38 (copy)
    if u43 then
        p99 = p99 * 1.4 or p99;
    end;

    for _, v in u38 do
        v.Scale = p99;
    end;
end;

function u1.Init(p100) -- Line: 677
    -- upvalues: u2 (ref), u3 (ref), u15 (ref), u13 (ref), u14 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u42 (ref), u43 (ref), u1 (copy), u27 (ref)
    u2 = p100:GetModule("Gui");
    u3 = p100:GetModule("Maid").new();
    u15 = p100:GetModule("WeaponManager");
    u13 = p100:GetModule("CharacterController");
    u14 = p100:GetModule("Threads");
    u16 = p100:GetModule("UIColor");
    u17 = p100:GetModule("PlayerColor");
    u18 = p100:GetModule("CameraController");
    u19 = p100:GetModule("ItemManager");
    u20 = p100:GetModule("SkinManager");
    u21 = p100:GetModule("Entities");
    u22 = p100:GetModule("Enums");
    u23 = p100:GetModule("WeaponController");
    u24 = p100:GetModule("RarityColors");
    u42 = p100:GetModule("GetUserPlatform");
    u43 = u42() == "Mobile";
    local Component = u2.GetComponent("Settings");
    Component:AddPlayerConnection("Game", "HUD & UI", "HUD Scale", function(p101) -- Line: 697
        -- upvalues: u1 (ref)
        u1.Scale(p101);
    end);
    local PlayerSettings = Component:GetPlayerSettings();
    local v102 = PlayerSettings and PlayerSettings.Game and PlayerSettings.Game["HUD & UI"];

    if v102 then
        v102 = v102["Glow Weapon with Rarity Color"];
    end;

    u27 = v102 == true;
    Component:AddConnection("Game", "HUD & UI", "Glow Weapon with Rarity Color", function(p103) -- Line: 705
        -- upvalues: u1 (ref)
        u1.SetRarityGlow(p103 == true);
    end);
end;

function u1.SetTarget(p104: userdata) -- Line: 710
    -- upvalues: LocalPlayer2 (ref), u3 (ref), u1 (copy), u7 (ref), u21 (ref), LocalPlayer (copy), u23 (ref), u10 (ref)
    LocalPlayer2 = p104;
    u3:Removes(
        "HUD_INV",
        "HUD_WEAPON",
        "HUD_WEAPON_DATA",
        "HUD_TEAM",
        "HUD_COLOR",
        "HUD_HP",
        "HUD_ARMOR",
        "HUD_ARMORVISIBLE",
        "HUD_CASH",
        "HUD_CARDS",
        "HUD_BUYZON",
        "HUD_OnWeaponShoot",
        "HUD_OnWeaponReload",
        "HUD_OnWeaponDestroy",
        "HUD_OnWeaponCreate",
        "HUD_OnWeaponChanged",
        "HUD_OnAmmoCorrected",
        "HUD_OnKillTrackChanged",
        "HUD_DK"
    );
    u1.InvUpdate();
    u1.CircleUpdate();
    u1.SetHealth();
    u1.SetArmour();
    u1.SetArmourVisible();
    u1.UpdateCards();
    u1.UpdateMoney();
    u7.DefuseKit.Visible = LocalPlayer2:GetAttribute("DefuseKit");

    if u21 then
        if u21.OnCharacterCurrentWeapon then
            u3:Add("HUD_INV", u21.OnCharacterCurrentWeapon:Connect(function(p105, p106) -- Line: 736
                -- upvalues: LocalPlayer2 (ref), u21 (ref), u1 (ref)
                if LocalPlayer2 then
                    local Entity = u21.GetEntity("Character", p105);

                    if Entity and Entity.UserId == LocalPlayer2.UserId then
                        u1.InvUpdate();
                    end;
                end;
            end));
            u3:Add("HUD_WEAPON", u21.OnCharacterCurrentWeapon:Connect(function(p107, p108) -- Line: 745
                -- upvalues: LocalPlayer2 (ref), u21 (ref), u1 (ref)
                if LocalPlayer2 then
                    local Entity = u21.GetEntity("Character", p107);

                    if Entity and Entity.UserId == LocalPlayer2.UserId then
                        u1.UpdateEquippedWeapon(p108);
                    end;
                end;
            end));
            local CharacterByUserId = u21.GetCharacterByUserId(LocalPlayer2.UserId);
            local v109 = CharacterByUserId and u21.GetCharacterCurrentWeapon(CharacterByUserId.Identifier);

            if v109 then
                u1.UpdateEquippedWeapon(v109);
            end;
        end;

        if u21.OnCharacterCurrentWeaponInventoryData then
            u3:Add("HUD_WEAPON_DATA", u21.OnCharacterCurrentWeaponInventoryData:Connect(function(p110, p111) -- Line: 768
                -- upvalues: LocalPlayer2 (ref), u21 (ref), u1 (ref)
                if LocalPlayer2 then
                    local Entity = u21.GetEntity("Character", p110);

                    if Entity and Entity.UserId == LocalPlayer2.UserId then
                        u1.UpdateEquippedWeapon(p111);
                        u1.InvUpdate();
                    end;
                end;
            end));
        end;
    end;

    if LocalPlayer2 == LocalPlayer then
        if u23.GetCurrentWeapon() then
            u1.UpdateEquippedWeapon(u23.GetCurrentWeapon());
        end;

        u3:Add("HUD_OnWeaponShoot", u23.OnWeaponShoot:Connect(function(p112) -- Line: 785
            -- upvalues: u1 (ref)
            u1.UpdateEquippedWeapon(p112);
        end));
        u3:Add("HUD_OnWeaponReload", u23.OnWeaponReload:Connect(function(p113) -- Line: 789
            -- upvalues: u1 (ref)
            u1.UpdateEquippedWeapon(p113);
        end));
        u3:Add("HUD_OnAmmoCorrected", u23.OnAmmoCorrected:Connect(function(p114) -- Line: 793
            -- upvalues: u1 (ref)
            u1.UpdateEquippedWeapon(p114);
        end));
        u3:Add("HUD_OnWeaponDestroy", u23.OnWeaponDestroy:Connect(function(p115) -- Line: 797
            -- upvalues: u1 (ref), u23 (ref)
            u1.InvUpdate();
            u1.UpdateEquippedWeapon(u23.GetCurrentWeapon());
        end));
        u3:Add("HUD_OnWeaponCreate", u23.OnWeaponCreate:Connect(function() -- Line: 802
            -- upvalues: u1 (ref), u23 (ref)
            u1.InvUpdate();
            u1.UpdateEquippedWeapon(u23.GetCurrentWeapon());
        end));
        u3:Add("HUD_OnWeaponChanged", u23.OnWeaponChanged:Connect(function(p116) -- Line: 807
            -- upvalues: u1 (ref), u23 (ref)
            u1.InvUpdate();
            u1.UpdateEquippedWeapon(u23.GetCurrentWeapon());
        end));
        u3:Add("HUD_OnKillTrackChanged", u23.OnKillTrackChanged:Connect(function(p117) -- Line: 812
            -- upvalues: u23 (ref), u1 (ref)
            if p117 == u23.GetCurrentWeapon() then
                u1.UpdateEquippedWeapon(p117);
            end;
        end));
    end;

    u3:Add("HUD_TEAM", LocalPlayer2:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 819
        -- upvalues: u1 (ref)
        u1.CircleUpdate();
    end));
    u3:Add("HUD_DK", LocalPlayer2:GetAttributeChangedSignal("DefuseKit"):Connect(function() -- Line: 823
        -- upvalues: u7 (ref), LocalPlayer2 (ref)
        u7.DefuseKit.Visible = LocalPlayer2:GetAttribute("DefuseKit");
    end));
    local UserId = LocalPlayer2.UserId;
    u3:Add("HUD_HP", u21.OnHealthUpdate:Connect(function(p118) -- Line: 829
        -- upvalues: UserId (copy), u1 (ref)
        if p118 == UserId then
            u1.SetHealth();
        end;
    end));
    u3:Add("HUD_ARMOR", LocalPlayer2:GetAttributeChangedSignal("ArmorValue"):Connect(function() -- Line: 835
        -- upvalues: u1 (ref)
        u1.SetArmour();
    end));
    u3:Add("HUD_ARMORVISIBLE", LocalPlayer2:GetAttributeChangedSignal("HasHelmet"):Connect(function() -- Line: 839
        -- upvalues: u1 (ref)
        u1.SetArmourVisible();
    end));
    u3:Add("HUD_CASH", LocalPlayer2:GetAttributeChangedSignal("Cash"):Connect(function() -- Line: 843
        -- upvalues: u1 (ref)
        u1.UpdateMoney();
    end));
    u3:Add("HUD_CARDS", LocalPlayer2:GetAttributeChangedSignal("RoundKills"):Connect(function() -- Line: 847
        -- upvalues: u1 (ref)
        u1.UpdateCards();
    end));
    u3:Add("HUD_BUYZON", LocalPlayer2:GetAttributeChangedSignal("InBuyZone"):Connect(function() -- Line: 851
        -- upvalues: u1 (ref), LocalPlayer2 (ref)
        u1.UpdateMoneyBuyZone(LocalPlayer2:GetAttribute("InBuyZone"));
    end));
    u3:Add("HUD_COLOR", LocalPlayer2:GetAttributeChangedSignal("Color"):Connect(function() -- Line: 855
        -- upvalues: u1 (ref)
        u1.CircleUpdate();
    end));

    if LocalPlayer2 == LocalPlayer then
        u10.Visible = false;

        return;
    end;

    u10.SkinText.Visible = false;
    u10.PlayerText.Text = LocalPlayer2.Name;
    u10.Visible = true;
end;

function u1.Start(p119) -- Line: 875
    -- upvalues: u41 (ref), u2 (ref), u1 (copy), u13 (ref), u3 (ref), u23 (ref), u34 (ref), LocalPlayer (copy), u18 (ref), GameStats (copy), u7 (ref), u11 (ref)
    u41 = u2.GetComponent("MobileControls");
    u1.new();
    u13.OnCharacterSpawn:Connect(function(p120) -- Line: 881
        -- upvalues: u3 (ref), u23 (ref), u34 (ref), u1 (ref), LocalPlayer (ref)
        u3:Add("HUD_WEAPONCHANGED", u23.OnWeaponChanged:Connect(function(p121) -- Line: 882
            -- upvalues: u34 (ref)
            u34 = p121;
        end));
        u1.SetTarget(LocalPlayer);
    end);
    u18.CameraTargetUpdate:Connect(function(p122) -- Line: 889
        -- upvalues: GameStats (ref), u7 (ref), u1 (ref), u11 (ref), u2 (ref)
        if GameStats:GetAttribute("State") == "MatchEnded" then
            return;
        end;

        if p122 == 2 or p122 == 4 then
            u7.Visible = false;
            u1.Visible = false;
            u1.Handler.Visible = false;
            u11.Visible = false;
            u2.Handler.HUD.Notifications.Visible = false;

            return;
        end;

        u7.Visible = true;
        u1.Visible = true;
        u1.Handler.Visible = true;
        u11.Visible = true;
        u2.Handler.HUD.Notifications.Visible = true;
    end);
    GameStats:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 908
        -- upvalues: u1 (ref)
        u1.CircleUpdate();
    end);
    u13.OnCharacterDestroy:Connect(function() -- Line: 912
        -- upvalues: u3 (ref)
        u3:Cleanup();
    end);
end;

function u1.new() -- Line: 919
    -- upvalues: u2 (ref), u38 (copy), u12 (ref), u10 (ref), u92 (ref), u1 (copy), u37 (copy), u7 (ref), u25 (ref), u26 (copy), u11 (ref), u4 (ref), u5 (ref), u9 (ref), u6 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Down";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.99);
    Frame.Size = UDim2.fromScale(0.65, 0.06);
    Frame.ZIndex = 2;
    Frame.Parent = u2.Handler.HUD;
    Frame.Visible = false;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = Frame;
    table.insert(u38, UIScale);
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "DowntRatio";
    UIAspectRatioConstraint.AspectRatio = 15;
    UIAspectRatioConstraint.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Circle";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.4);
    Frame2.Size = UDim2.fromScale(0.9, 0.9);
    Frame2.ZIndex = 99999999;
    Frame2.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "CircleStroke";
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.04;
    UIStroke.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "RightLine";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BackgroundTransparency = 0.5;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.LayoutOrder = 2;
    Frame3.Position = UDim2.new(1, 2, 0.5, 0);
    Frame3.Size = UDim2.new(3.5, 0, 0, 1);
    Frame3.ZIndex = 4;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "RightGradient";
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) });
    UIGradient.Parent = Frame3;
    Frame3.Parent = Frame2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "LeftLine";
    Frame4.AnchorPoint = Vector2.new(1, 0.5);
    Frame4.AutoLocalize = false;
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BackgroundTransparency = 0.5;
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.LayoutOrder = 2;
    Frame4.Position = UDim2.new(0, -2, 0.5, 0);
    Frame4.Size = UDim2.new(3.5, 0, 0, 1);
    Frame4.ZIndex = 4;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "LeftGradient";
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) });
    UIGradient2.Parent = Frame4;
    Frame4.Parent = Frame2;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "CircleRatio";
    UIAspectRatioConstraint2.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint2.Parent = Frame2;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "CircleCorner";
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame2;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "TeamIcon";
    ImageButton.Active = false;
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.AutoLocalize = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://126730144393913";
    ImageButton.ImageColor3 = Color3.fromRGB(255, 255, 255);
    ImageButton.LayoutOrder = 2;
    ImageButton.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(0.8, 0.8);
    ImageButton.Visible = false;
    ImageButton.ZIndex = 5;
    ImageButton.Parent = Frame2;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "PlayerIcon";
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.AutoLocalize = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxthumb://type=AvatarHeadShot&id=2994385561&w=420&h=420";
    ImageButton2.LayoutOrder = 2;
    ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton2.ScaleType = Enum.ScaleType.Fit;
    ImageButton2.Size = UDim2.fromScale(1, 1);
    ImageButton2.Visible = false;
    ImageButton2.ZIndex = 5;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "PlayerCorner";
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = ImageButton2;
    ImageButton2.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "CircleBlur";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundColor3 = Color3.new();
    ImageLabel.Image = "rbxassetid://108060254555731";
    ImageLabel.ImageTransparency = 0.74;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "CircleBlurCorner";
    UICorner3.CornerRadius = UDim.new(1, 0);
    UICorner3.Parent = ImageLabel;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "CircleBlurGradient";
    UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.683391, Color3.fromRGB(143, 143, 143)), ColorSequenceKeypoint.new(1, Color3.fromRGB(126, 126, 126)) });
    UIGradient3.Rotation = 90;
    UIGradient3.Parent = ImageLabel;
    ImageLabel.Parent = Frame2;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Ammo";
    Frame5.AnchorPoint = Vector2.new(0, 0.5);
    Frame5.AutoLocalize = false;
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0.775, 0.500001);
    Frame5.Size = UDim2.fromScale(0.2, 0.9);
    Frame5.Parent = Frame;
    local UIScale2 = Instance.new("UIScale");
    UIScale2.Name = "AmmoScale";
    UIScale2.Scale = 0;
    UIScale2.Parent = Frame5;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "StoredAmmo";
    Frame6.AnchorPoint = Vector2.new(1, 0.5);
    Frame6.AutoLocalize = false;
    Frame6.BackgroundTransparency = 1;
    Frame6.Position = UDim2.fromScale(1, 0.500001);
    Frame6.Size = UDim2.fromScale(0.5, 0.9);
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "AmmoLine";
    Frame7.AnchorPoint = Vector2.new(1, 0.5);
    Frame7.AutoLocalize = false;
    Frame7.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame7.BackgroundTransparency = 0.6;
    Frame7.BorderColor3 = Color3.new();
    Frame7.BorderSizePixel = 0;
    Frame7.Position = UDim2.fromScale(0, 0.5);
    Frame7.Size = UDim2.fromScale(0.025, 0.5);
    Frame7.Parent = Frame6;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "AmmoRightText";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0, 0.5);
    TextLabel.Size = UDim2.fromScale(0.4, 0.5);
    TextLabel.Text = "88";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame6;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "AmmoIcon";
    ImageButton3.Active = false;
    ImageButton3.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton3.AutoButtonColor = false;
    ImageButton3.AutoLocalize = false;
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.Image = "rbxassetid://98690031947493";
    ImageButton3.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton3.ScaleType = Enum.ScaleType.Fit;
    ImageButton3.Size = UDim2.fromScale(0.3, 0.5);
    ImageButton3.ZIndex = 2;
    ImageButton3.Parent = Frame6;
    Frame6.Parent = Frame5;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "AmmoLeftText";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.5, 1);
    TextLabel2.Text = "14";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = Frame5;
    local ImageButton4 = Instance.new("ImageButton");
    ImageButton4.Name = "AMBlur";
    ImageButton4.Active = false;
    ImageButton4.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton4.AutoButtonColor = false;
    ImageButton4.AutoLocalize = false;
    ImageButton4.BackgroundTransparency = 1;
    ImageButton4.Image = "rbxassetid://6430908053";
    ImageButton4.ImageColor3 = Color3.fromRGB(255, 75, 75);
    ImageButton4.ImageTransparency = 0.19;
    ImageButton4.Position = UDim2.fromScale(-0.25, 0.5);
    ImageButton4.ScaleType = Enum.ScaleType.Fit;
    ImageButton4.Size = UDim2.fromScale(1, 1);
    ImageButton4.ZIndex = 0;
    ImageButton4.Visible = false;
    ImageButton4.Parent = Frame5;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Health";
    Frame8.AnchorPoint = Vector2.new(0, 0.5);
    Frame8.AutoLocalize = false;
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.125, 0.5);
    Frame8.Size = UDim2.fromScale(0.065, 0.9);
    Frame8.Parent = Frame;
    local ImageButton5 = Instance.new("ImageButton");
    ImageButton5.Name = "HPBlur";
    ImageButton5.Active = false;
    ImageButton5.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton5.AutoButtonColor = false;
    ImageButton5.AutoLocalize = false;
    ImageButton5.BackgroundTransparency = 1;
    ImageButton5.Image = "rbxassetid://6430908053";
    ImageButton5.ImageColor3 = Color3.fromRGB(255, 75, 75);
    ImageButton5.ImageTransparency = 1;
    ImageButton5.Position = UDim2.fromScale(0, 0.5);
    ImageButton5.ScaleType = Enum.ScaleType.Fit;
    ImageButton5.Size = UDim2.fromScale(1, 1);
    ImageButton5.ZIndex = 0;
    ImageButton5.Parent = Frame8;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "DropHP";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.45);
    TextLabel3.Size = UDim2.fromScale(1, 0.8);
    TextLabel3.Text = "31";
    TextLabel3.TextColor3 = Color3.fromRGB(255, 0, 0);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 1;
    TextLabel3.ZIndex = 8;
    TextLabel3.Parent = Frame8;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "HealthText";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.5, 0.45);
    TextLabel4.Size = UDim2.fromScale(1, 0.8);
    TextLabel4.Text = "100";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = Frame8;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "HealthLine";
    Frame9.AutoLocalize = false;
    Frame9.BackgroundTransparency = 1;
    Frame9.Position = UDim2.fromScale(0, 0.75);
    Frame9.Size = UDim2.fromScale(1, 0.1);
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "HealthBar";
    Frame10.AnchorPoint = Vector2.new(0, 0.5);
    Frame10.AutoLocalize = false;
    Frame10.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame10.BackgroundTransparency = 0.2;
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.fromScale(0, 0.5);
    Frame10.Size = UDim2.fromScale(1, 1);
    Frame10.Parent = Frame9;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "RedBar";
    Frame11.AnchorPoint = Vector2.new(1, 0.5);
    Frame11.AutoLocalize = false;
    Frame11.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame11.BackgroundTransparency = 0.5;
    Frame11.BorderColor3 = Color3.new();
    Frame11.BorderSizePixel = 0;
    Frame11.Position = UDim2.fromScale(1, 0.5);
    Frame11.Size = UDim2.fromScale(0, 1);
    local UIGradient4 = Instance.new("UIGradient");
    UIGradient4.Name = "HealthGradient";
    UIGradient4.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(1, Color3.new()) });
    UIGradient4.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.900115, 1), NumberSequenceKeypoint.new(1, 1) });
    UIGradient4.Parent = Frame11;
    Frame11.Parent = Frame9;
    Frame9.Parent = Frame8;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Shield";
    Frame12.AnchorPoint = Vector2.new(0, 0.5);
    Frame12.AutoLocalize = false;
    Frame12.BackgroundTransparency = 1;
    Frame12.Position = UDim2.fromScale(0.075, 0.5);
    Frame12.Size = UDim2.fromScale(0.04, 1);
    Frame12.Parent = Frame;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "ArmorText";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.5, 0.515);
    TextLabel5.Size = UDim2.fromScale(0.75, 1);
    TextLabel5.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    TextLabel5.Text = "100";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.ZIndex = 9;
    u12 = TextLabel5;
    local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint3.Name = "ArmorRatio";
    UIAspectRatioConstraint3.Parent = TextLabel5;
    TextLabel5.Parent = Frame12;
    local ImageButton6 = Instance.new("ImageButton");
    ImageButton6.Name = "Armor";
    ImageButton6.Active = false;
    ImageButton6.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton6.AutoButtonColor = false;
    ImageButton6.AutoLocalize = false;
    ImageButton6.BackgroundTransparency = 1;
    ImageButton6.Image = "rbxassetid://91731410947069";
    ImageButton6.ImageColor3 = Color3.fromRGB(172, 195, 220);
    ImageButton6.ImageTransparency = 0.2;
    ImageButton6.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton6.ScaleType = Enum.ScaleType.Fit;
    ImageButton6.Size = UDim2.fromScale(1, 0.7);
    ImageButton6.ZIndex = 2;
    local UIScale3 = Instance.new("UIScale");
    UIScale3.Name = "ArmorScale";
    UIScale3.Scale = 1.35;
    UIScale3.Parent = ImageButton6;
    ImageButton6.Parent = Frame12;
    local ImageButton7 = Instance.new("ImageButton");
    ImageButton7.Name = "ArmorHelmet";
    ImageButton7.Active = false;
    ImageButton7.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton7.AutoButtonColor = false;
    ImageButton7.AutoLocalize = false;
    ImageButton7.BackgroundTransparency = 1;
    ImageButton7.Image = "rbxassetid://110203604577722";
    ImageButton7.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton7.ScaleType = Enum.ScaleType.Fit;
    ImageButton7.Size = UDim2.fromScale(1, 0.8);
    ImageButton7.ZIndex = 2;
    local UIScale4 = Instance.new("UIScale");
    UIScale4.Name = "HelmetScale";
    UIScale4.Scale = 1.35;
    UIScale4.Parent = ImageButton7;
    ImageButton7.Parent = Frame12;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Spectating";
    Frame13.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame13.AutoLocalize = false;
    Frame13.BackgroundColor3 = Color3.new();
    Frame13.BackgroundTransparency = 0.5;
    Frame13.BorderColor3 = Color3.new();
    Frame13.BorderSizePixel = 0;
    Frame13.Position = UDim2.fromScale(0.5, 0.4);
    Frame13.Size = UDim2.fromScale(0.55, 1.2);
    Frame13.Parent = Frame;
    Frame13.Visible = false;
    u10 = Frame13;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "ADRTitleText";
    TextLabel6.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.02, 0.8);
    TextLabel6.Size = UDim2.fromScale(0.05, 0.2);
    TextLabel6.Text = "ADR";
    TextLabel6.TextColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextScaled = true;
    TextLabel6.TextTransparency = 0.1;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel6.ZIndex = 9;
    TextLabel6.Parent = Frame13;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "ADRText";
    TextLabel7.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.08, 0.8);
    TextLabel7.Size = UDim2.fromScale(0.2, 0.2);
    TextLabel7.Text = "50";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.TextTransparency = 0.1;
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel7.ZIndex = 9;
    TextLabel7.Parent = Frame13;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "WeaponText";
    TextLabel8.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel8.AutoLocalize = false;
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.98, 0.2);
    TextLabel8.Size = UDim2.fromScale(0.3, 0.25);
    TextLabel8.Text = "";
    TextLabel8.TextColor3 = Color3.new(1, 1, 1);
    TextLabel8.TextScaled = true;
    TextLabel8.TextTransparency = 0.1;
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel8.ZIndex = 9;
    TextLabel8.Parent = Frame13;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "SkinText";
    TextLabel9.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel9.AutoLocalize = false;
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(0.98, 0.5);
    TextLabel9.Size = UDim2.fromScale(0.3, 0.25);
    TextLabel9.Text = "Blood In The Water";
    TextLabel9.TextColor3 = Color3.fromRGB(255, 0, 4);
    TextLabel9.TextScaled = true;
    TextLabel9.TextTransparency = 0.1;
    TextLabel9.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel9.ZIndex = 9;
    TextLabel9.Parent = Frame13;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "PlayerText";
    TextLabel10.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel10.AutoLocalize = false;
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel10.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel10.Size = UDim2.fromScale(0.3, 0.3);
    TextLabel10.Text = "WhyNotMyUsername";
    TextLabel10.TextColor3 = Color3.new(1, 1, 1);
    TextLabel10.TextScaled = true;
    TextLabel10.TextTransparency = 0.1;
    TextLabel10.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel10.ZIndex = 9;
    TextLabel10.Parent = Frame13;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "DOTS";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://91991932054752";
    ImageLabel2.ImageTransparency = 0.6;
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.Position = UDim2.fromScale(0, 0.00185185);
    ImageLabel2.ScaleType = Enum.ScaleType.Tile;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel2.ZIndex = -1;
    ImageLabel2.Parent = Frame13;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "ColorBackground";
    Frame14.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame14.AutoLocalize = false;
    Frame14.BackgroundTransparency = 1;
    Frame14.ClipsDescendants = true;
    Frame14.Position = UDim2.fromScale(0.5, 0.5);
    Frame14.Size = UDim2.fromScale(2, 2);
    Frame14.ZIndex = 0;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Main";
    Frame15.AnchorPoint = Vector2.new(0, 0.5);
    Frame15.AutoLocalize = false;
    Frame15.BackgroundTransparency = 1;
    Frame15.Position = UDim2.fromScale(0, 0.5);
    Frame15.Size = UDim2.fromScale(1, 0.5);
    Frame15.ZIndex = -1;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "Frame";
    Frame16.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame16.AutoLocalize = false;
    Frame16.BackgroundTransparency = 1;
    Frame16.Position = UDim2.fromScale(0.5, 0.5);
    Frame16.Size = UDim2.fromScale(0.5, 1);
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "Left";
    Frame17.AnchorPoint = Vector2.new(1, 0);
    Frame17.AutoLocalize = false;
    Frame17.BackgroundTransparency = 1;
    Frame17.ClipsDescendants = true;
    Frame17.Size = UDim2.fromScale(0.1, 1);
    local Frame18 = Instance.new("Frame");
    Frame18.Name = "Color";
    Frame18.AutoLocalize = false;
    Frame18.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame18.ClipsDescendants = true;
    Frame18.Position = UDim2.fromScale(0.92, 0);
    Frame18.Size = UDim2.fromScale(10, 1);
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = Frame18;
    Frame18.Parent = Frame17;
    Frame17.Parent = Frame16;
    local Frame19 = Instance.new("Frame");
    Frame19.Name = "Right";
    Frame19.AutoLocalize = false;
    Frame19.BackgroundTransparency = 1;
    Frame19.ClipsDescendants = true;
    Frame19.Position = UDim2.fromScale(1, 0);
    Frame19.Size = UDim2.fromScale(0.1, 1);
    local Frame20 = Instance.new("Frame");
    Frame20.Name = "Color";
    Frame20.AnchorPoint = Vector2.new(1, 0);
    Frame20.AutoLocalize = false;
    Frame20.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame20.ClipsDescendants = true;
    Frame20.Position = UDim2.fromScale(0.08, 0);
    Frame20.Size = UDim2.fromScale(10, 1);
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.Parent = Frame20;
    Frame20.Parent = Frame19;
    Frame19.Parent = Frame16;
    Frame16.Parent = Frame15;
    Frame15.Parent = Frame14;
    Frame14.Parent = Frame13;
    local Frame21 = Instance.new("Frame");
    Frame21.Name = "CardsHolder";
    Frame21.BackgroundTransparency = 1;
    Frame21.Position = UDim2.fromScale(-3.13967e-8, 0);
    Frame21.Size = UDim2.fromScale(1, 1);
    Frame21.Parent = Frame;
    u92 = u1.newcard(Frame21, "Cards5", u37.Cards5);
    local Frame22 = Instance.new("Frame");
    Frame22.Name = "Inventory";
    Frame22.AnchorPoint = Vector2.new(1, 1);
    Frame22.AutoLocalize = false;
    Frame22.BackgroundTransparency = 1;
    Frame22.Position = UDim2.fromScale(1, 1);
    Frame22.Size = UDim2.fromScale(0.25, 0.28);
    Frame22.ZIndex = 2;
    local UIScale5 = Instance.new("UIScale");
    UIScale5.Name = "UIScale";
    UIScale5.Parent = Frame22;
    table.insert(u38, UIScale5);
    local Frame23 = Instance.new("Frame");
    Frame23.Name = "Primary";
    Frame23.AnchorPoint = Vector2.new(1, 0);
    Frame23.AutoLocalize = false;
    Frame23.BackgroundTransparency = 1;
    Frame23.Position = UDim2.fromScale(1, 0);
    Frame23.Size = UDim2.fromScale(1, 0.25);
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "Number";
    TextLabel11.AnchorPoint = Vector2.new(0.899999976, 0.200000003);
    TextLabel11.AutoLocalize = false;
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel11.Position = UDim2.fromScale(0.95, 0.1);
    TextLabel11.Size = UDim2.fromScale(0.05, 0.2);
    TextLabel11.Text = "1";
    TextLabel11.TextColor3 = Color3.new(1, 1, 1);
    TextLabel11.TextScaled = true;
    TextLabel11.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel11.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel11.ZIndex = 9;
    TextLabel11.Parent = Frame23;
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = "WeaponName";
    TextLabel12.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel12.AutoLocalize = false;
    TextLabel12.BackgroundTransparency = 1;
    TextLabel12.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel12.Position = UDim2.fromScale(0.5, 1);
    TextLabel12.Size = UDim2.fromScale(0.8, 0.2);
    TextLabel12.Text = "";
    TextLabel12.TextColor3 = Color3.new(1, 1, 1);
    TextLabel12.TextScaled = true;
    TextLabel12.TextTransparency = 0.2;
    TextLabel12.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel12.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel12.ZIndex = 9;
    TextLabel12.Visible = true;
    TextLabel12.Parent = Frame23;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Weapon";
    ImageLabel3.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel3.AutoLocalize = false;
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://100429874437897";
    ImageLabel3.Position = UDim2.fromScale(0.9, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Crop;
    ImageLabel3.Size = UDim2.fromScale(2, 0.8);
    ImageLabel3.ImageTransparency = 0.35;
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.TileSize = UDim2.fromScale(2, 1);
    ImageLabel3.ZIndex = 9;
    local UIScale6 = Instance.new("UIScale");
    UIScale6.Name = "UIScale";
    UIScale6.Scale = 0.75;
    UIScale6.Parent = ImageLabel3;
    ImageLabel3.Parent = Frame23;
    Frame23.Parent = Frame22;
    local Frame24 = Instance.new("Frame");
    Frame24.Name = "Secondary";
    Frame24.AnchorPoint = Vector2.new(1, 0);
    Frame24.AutoLocalize = false;
    Frame24.BackgroundTransparency = 1;
    Frame24.Position = UDim2.fromScale(1, 0.25);
    Frame24.Size = UDim2.fromScale(1, 0.25);
    local TextLabel13 = Instance.new("TextLabel");
    TextLabel13.Name = "Number";
    TextLabel13.AnchorPoint = Vector2.new(0.899999976, 0.200000003);
    TextLabel13.AutoLocalize = false;
    TextLabel13.BackgroundTransparency = 1;
    TextLabel13.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel13.Position = UDim2.fromScale(0.95, 0.1);
    TextLabel13.Size = UDim2.fromScale(0.05, 0.2);
    TextLabel13.Text = "2";
    TextLabel13.TextColor3 = Color3.new(1, 1, 1);
    TextLabel13.TextScaled = true;
    TextLabel13.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel13.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel13.ZIndex = 9;
    TextLabel13.Parent = Frame24;
    local TextLabel14 = Instance.new("TextLabel");
    TextLabel14.Name = "WeaponName";
    TextLabel14.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel14.AutoLocalize = false;
    TextLabel14.BackgroundTransparency = 1;
    TextLabel14.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel14.Position = UDim2.fromScale(0.5, 1);
    TextLabel14.Size = UDim2.fromScale(0.8, 0.2);
    TextLabel14.Text = "";
    TextLabel14.TextColor3 = Color3.new(1, 1, 1);
    TextLabel14.TextScaled = true;
    TextLabel14.TextTransparency = 0.2;
    TextLabel14.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel14.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel14.Visible = true;
    TextLabel14.ZIndex = 9;
    TextLabel14.Parent = Frame24;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Weapon";
    ImageLabel4.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel4.AutoLocalize = false;
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://100429874437897";
    ImageLabel4.ImageTransparency = 0.35;
    ImageLabel4.Position = UDim2.fromScale(0.9, 0.5);
    ImageLabel4.ScaleType = Enum.ScaleType.Crop;
    ImageLabel4.Size = UDim2.fromScale(2, 0.8);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.TileSize = UDim2.fromScale(2, 1);
    ImageLabel4.ZIndex = 9;
    local UIScale7 = Instance.new("UIScale");
    UIScale7.Name = "UIScale";
    UIScale7.Parent = ImageLabel4;
    UIScale7.Scale = 0.75;
    ImageLabel4.Parent = Frame24;
    Frame24.Parent = Frame22;
    local Frame25 = Instance.new("Frame");
    Frame25.Name = "Melee";
    Frame25.AnchorPoint = Vector2.new(1, 0);
    Frame25.AutoLocalize = false;
    Frame25.BackgroundTransparency = 1;
    Frame25.Position = UDim2.fromScale(1, 0.5);
    Frame25.Size = UDim2.fromScale(1, 0.25);
    local TextLabel15 = Instance.new("TextLabel");
    TextLabel15.Name = "Number";
    TextLabel15.AnchorPoint = Vector2.new(0.899999976, 0.200000003);
    TextLabel15.AutoLocalize = false;
    TextLabel15.BackgroundTransparency = 1;
    TextLabel15.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel15.Position = UDim2.fromScale(0.95, 0.1);
    TextLabel15.Size = UDim2.fromScale(0.05, 0.2);
    TextLabel15.Text = "3";
    TextLabel15.TextColor3 = Color3.new(1, 1, 1);
    TextLabel15.TextScaled = true;
    TextLabel15.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel15.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel15.ZIndex = 9;
    TextLabel15.Parent = Frame25;
    local TextLabel16 = Instance.new("TextLabel");
    TextLabel16.Name = "WeaponName";
    TextLabel16.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel16.AutoLocalize = false;
    TextLabel16.BackgroundTransparency = 1;
    TextLabel16.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel16.Position = UDim2.fromScale(0.5, 1);
    TextLabel16.Size = UDim2.fromScale(0.8, 0.2);
    TextLabel16.Text = "";
    TextLabel16.TextColor3 = Color3.new(1, 1, 1);
    TextLabel16.TextScaled = true;
    TextLabel16.TextTransparency = 0.2;
    TextLabel16.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel16.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel16.Visible = true;
    TextLabel16.ZIndex = 9;
    TextLabel16.Parent = Frame25;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Weapon";
    ImageLabel5.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel5.AutoLocalize = false;
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://100429874437897";
    ImageLabel5.ImageTransparency = 0.35;
    ImageLabel5.Position = UDim2.fromScale(0.9, 0.5);
    ImageLabel5.ScaleType = Enum.ScaleType.Crop;
    ImageLabel5.Size = UDim2.fromScale(2, 0.8);
    ImageLabel5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel5.TileSize = UDim2.fromScale(2, 1);
    ImageLabel5.ZIndex = 9;
    local UIScale8 = Instance.new("UIScale");
    UIScale8.Name = "UIScale";
    UIScale8.Parent = ImageLabel5;
    UIScale8.Scale = 0.75;
    ImageLabel5.Parent = Frame25;
    Frame25.Parent = Frame22;
    local Frame26 = Instance.new("Frame");
    Frame26.Name = "Grenade";
    Frame26.AnchorPoint = Vector2.new(1, 0);
    Frame26.AutoLocalize = false;
    Frame26.BackgroundTransparency = 1;
    Frame26.Position = UDim2.fromScale(1, 0.75);
    Frame26.Size = UDim2.fromScale(1, 0.25);
    local TextLabel17 = Instance.new("TextLabel");
    TextLabel17.Name = "Number";
    TextLabel17.AnchorPoint = Vector2.new(0.899999976, 0.200000003);
    TextLabel17.AutoLocalize = false;
    TextLabel17.BackgroundTransparency = 1;
    TextLabel17.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel17.Position = UDim2.fromScale(0.95, 0.1);
    TextLabel17.Size = UDim2.fromScale(0.05, 0.2);
    TextLabel17.Text = "4";
    TextLabel17.TextColor3 = Color3.new(1, 1, 1);
    TextLabel17.TextScaled = true;
    TextLabel17.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel17.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel17.ZIndex = 9;
    TextLabel17.Parent = Frame26;
    local TextLabel18 = Instance.new("TextLabel");
    TextLabel18.Name = "WeaponName";
    TextLabel18.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel18.AutoLocalize = false;
    TextLabel18.BackgroundTransparency = 1;
    TextLabel18.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel18.Position = UDim2.fromScale(0.5, 1);
    TextLabel18.Size = UDim2.fromScale(0.8, 0.2);
    TextLabel18.Text = "";
    TextLabel18.TextColor3 = Color3.new(1, 1, 1);
    TextLabel18.TextScaled = true;
    TextLabel18.TextTransparency = 0.2;
    TextLabel18.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel18.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel18.Visible = true;
    TextLabel18.ZIndex = 9;
    TextLabel18.Parent = Frame26;
    local Frame27 = Instance.new("Frame");
    Frame27.Name = "Weapons";
    Frame27.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame27.AutoLocalize = false;
    Frame27.BackgroundTransparency = 1;
    Frame27.Position = UDim2.fromScale(0.5, 0.4);
    Frame27.Size = UDim2.fromScale(0.900001, 0.8);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame27;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "Weapon2";
    ImageLabel6.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel6.AutoLocalize = false;
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://100429874437897";
    ImageLabel6.ImageTransparency = 0.35;
    ImageLabel6.LayoutOrder = 3;
    ImageLabel6.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel6.ScaleType = Enum.ScaleType.Fit;
    ImageLabel6.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel6.TileSize = UDim2.fromScale(2, 1);
    ImageLabel6.ZIndex = 9;
    local ImageLabel7 = Instance.new("ImageLabel");
    ImageLabel7.Name = "Dot";
    ImageLabel7.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel7.AutoLocalize = false;
    ImageLabel7.BackgroundTransparency = 1;
    ImageLabel7.Image = "rbxassetid://5552526748";
    ImageLabel7.ImageColor3 = Color3.new();
    ImageLabel7.ImageTransparency = 0.5;
    ImageLabel7.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel7.ScaleType = Enum.ScaleType.Fit;
    ImageLabel7.Size = UDim2.fromScale(0.2, 0.2);
    ImageLabel7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel7.Parent = ImageLabel6;
    local TextLabel19 = Instance.new("TextLabel");
    TextLabel19.Name = "Amount";
    TextLabel19.AnchorPoint = Vector2.new(0.800000012, 0.800000012);
    TextLabel19.AutoLocalize = false;
    TextLabel19.BackgroundTransparency = 1;
    TextLabel19.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel19.Position = UDim2.fromScale(1, 1);
    TextLabel19.Size = UDim2.fromScale(0.4, 0.4);
    TextLabel19.Text = "x2";
    TextLabel19.TextColor3 = Color3.new(1, 1, 1);
    TextLabel19.TextScaled = true;
    TextLabel19.TextTransparency = 0.23;
    TextLabel19.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel19.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel19.ZIndex = 9;
    TextLabel19.Parent = ImageLabel6;
    local UIScale9 = Instance.new("UIScale");
    UIScale9.Name = "UIScale";
    UIScale9.Parent = ImageLabel6;
    ImageLabel6.Parent = Frame27;
    local ImageLabel8 = Instance.new("ImageLabel");
    ImageLabel8.Name = "Weapon4";
    ImageLabel8.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel8.AutoLocalize = false;
    ImageLabel8.BackgroundTransparency = 1;
    ImageLabel8.Image = "rbxassetid://100429874437897";
    ImageLabel8.ImageTransparency = 0.35;
    ImageLabel8.LayoutOrder = 1;
    ImageLabel8.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel8.ScaleType = Enum.ScaleType.Fit;
    ImageLabel8.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel8.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel8.TileSize = UDim2.fromScale(2, 1);
    ImageLabel8.ZIndex = 9;
    local ImageLabel9 = Instance.new("ImageLabel");
    ImageLabel9.Name = "Dot";
    ImageLabel9.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel9.AutoLocalize = false;
    ImageLabel9.BackgroundTransparency = 1;
    ImageLabel9.Image = "rbxassetid://5552526748";
    ImageLabel9.ImageColor3 = Color3.new();
    ImageLabel9.ImageTransparency = 0.5;
    ImageLabel9.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel9.ScaleType = Enum.ScaleType.Fit;
    ImageLabel9.Size = UDim2.fromScale(0.2, 0.2);
    ImageLabel9.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel9.Parent = ImageLabel8;
    local TextLabel20 = Instance.new("TextLabel");
    TextLabel20.Name = "Amount";
    TextLabel20.AnchorPoint = Vector2.new(0.800000012, 0.800000012);
    TextLabel20.AutoLocalize = false;
    TextLabel20.BackgroundTransparency = 1;
    TextLabel20.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel20.Position = UDim2.fromScale(1, 1);
    TextLabel20.Size = UDim2.fromScale(0.4, 0.4);
    TextLabel20.Text = "x2";
    TextLabel20.TextColor3 = Color3.new(1, 1, 1);
    TextLabel20.TextScaled = true;
    TextLabel20.TextTransparency = 0.23;
    TextLabel20.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel20.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel20.ZIndex = 9;
    TextLabel20.Parent = ImageLabel8;
    local UIScale10 = Instance.new("UIScale");
    UIScale10.Name = "UIScale";
    UIScale10.Parent = ImageLabel8;
    ImageLabel8.Parent = Frame27;
    local ImageLabel10 = Instance.new("ImageLabel");
    ImageLabel10.Name = "Weapon3";
    ImageLabel10.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel10.AutoLocalize = false;
    ImageLabel10.BackgroundTransparency = 1;
    ImageLabel10.Image = "rbxassetid://100429874437897";
    ImageLabel10.ImageTransparency = 0.35;
    ImageLabel10.LayoutOrder = 2;
    ImageLabel10.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel10.ScaleType = Enum.ScaleType.Fit;
    ImageLabel10.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel10.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel10.TileSize = UDim2.fromScale(2, 1);
    ImageLabel10.ZIndex = 9;
    local ImageLabel11 = Instance.new("ImageLabel");
    ImageLabel11.Name = "Dot";
    ImageLabel11.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel11.AutoLocalize = false;
    ImageLabel11.BackgroundTransparency = 1;
    ImageLabel11.Image = "rbxassetid://5552526748";
    ImageLabel11.ImageColor3 = Color3.new();
    ImageLabel11.ImageTransparency = 0.5;
    ImageLabel11.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel11.ScaleType = Enum.ScaleType.Fit;
    ImageLabel11.Size = UDim2.fromScale(0.2, 0.2);
    ImageLabel11.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel11.Parent = ImageLabel10;
    local TextLabel21 = Instance.new("TextLabel");
    TextLabel21.Name = "Amount";
    TextLabel21.AnchorPoint = Vector2.new(0.800000012, 0.800000012);
    TextLabel21.AutoLocalize = false;
    TextLabel21.BackgroundTransparency = 1;
    TextLabel21.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel21.Position = UDim2.fromScale(1, 1);
    TextLabel21.Size = UDim2.fromScale(0.4, 0.4);
    TextLabel21.Text = "x2";
    TextLabel21.TextColor3 = Color3.new(1, 1, 1);
    TextLabel21.TextScaled = true;
    TextLabel21.TextTransparency = 0.23;
    TextLabel21.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel21.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel21.ZIndex = 9;
    TextLabel21.Parent = ImageLabel10;
    local UIScale11 = Instance.new("UIScale");
    UIScale11.Name = "UIScale";
    UIScale11.Parent = ImageLabel10;
    ImageLabel10.Parent = Frame27;
    local ImageLabel12 = Instance.new("ImageLabel");
    ImageLabel12.Name = "Weapon1";
    ImageLabel12.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel12.AutoLocalize = false;
    ImageLabel12.BackgroundTransparency = 1;
    ImageLabel12.Image = "rbxassetid://100429874437897";
    ImageLabel12.ImageTransparency = 0.35;
    ImageLabel12.LayoutOrder = 4;
    ImageLabel12.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel12.ScaleType = Enum.ScaleType.Fit;
    ImageLabel12.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel12.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel12.TileSize = UDim2.fromScale(2, 1);
    ImageLabel12.ZIndex = 9;
    local ImageLabel13 = Instance.new("ImageLabel");
    ImageLabel13.Name = "Dot";
    ImageLabel13.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel13.AutoLocalize = false;
    ImageLabel13.BackgroundTransparency = 1;
    ImageLabel13.Image = "rbxassetid://5552526748";
    ImageLabel13.ImageColor3 = Color3.new();
    ImageLabel13.ImageTransparency = 0.5;
    ImageLabel13.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel13.ScaleType = Enum.ScaleType.Fit;
    ImageLabel13.Size = UDim2.fromScale(0.2, 0.2);
    ImageLabel13.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel13.Parent = ImageLabel12;
    local TextLabel22 = Instance.new("TextLabel");
    TextLabel22.Name = "Amount";
    TextLabel22.AnchorPoint = Vector2.new(0.800000012, 0.800000012);
    TextLabel22.AutoLocalize = false;
    TextLabel22.BackgroundTransparency = 1;
    TextLabel22.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel22.Position = UDim2.fromScale(1, 1);
    TextLabel22.Size = UDim2.fromScale(0.4, 0.4);
    TextLabel22.Text = "x2";
    TextLabel22.TextColor3 = Color3.new(1, 1, 1);
    TextLabel22.TextScaled = true;
    TextLabel22.TextTransparency = 0.23;
    TextLabel22.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel22.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel22.ZIndex = 9;
    TextLabel22.Parent = ImageLabel12;
    local UIScale12 = Instance.new("UIScale");
    UIScale12.Name = "UIScale";
    UIScale12.Parent = ImageLabel12;
    ImageLabel12.Parent = Frame27;
    Frame27.Parent = Frame26;
    Frame26.Parent = Frame22;
    local Frame28 = Instance.new("Frame");
    Frame28.Name = "Bomb";
    Frame28.AutoLocalize = false;
    Frame28.BackgroundTransparency = 1;
    Frame28.Position = UDim2.fromScale(-0.75, 0.75);
    Frame28.Size = UDim2.fromScale(1, 0.25);
    local TextLabel23 = Instance.new("TextLabel");
    TextLabel23.Name = "Number";
    TextLabel23.AnchorPoint = Vector2.new(0.899999976, 0.200000003);
    TextLabel23.AutoLocalize = false;
    TextLabel23.BackgroundTransparency = 1;
    TextLabel23.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel23.Position = UDim2.fromScale(0.95, 0.1);
    TextLabel23.Size = UDim2.fromScale(0.05, 0.2);
    TextLabel23.Text = "5";
    TextLabel23.TextColor3 = Color3.new(1, 1, 1);
    TextLabel23.TextScaled = true;
    TextLabel23.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel23.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel23.ZIndex = 9;
    TextLabel23.Parent = Frame28;
    local TextLabel24 = Instance.new("TextLabel");
    TextLabel24.Name = "WeaponName";
    TextLabel24.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel24.AutoLocalize = false;
    TextLabel24.BackgroundTransparency = 1;
    TextLabel24.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel24.Position = UDim2.fromScale(0.5, 1);
    TextLabel24.Size = UDim2.fromScale(0.8, 0.2);
    TextLabel24.Text = "";
    TextLabel24.TextColor3 = Color3.new(1, 1, 1);
    TextLabel24.TextScaled = true;
    TextLabel24.TextTransparency = 0.2;
    TextLabel24.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel24.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel24.Visible = true;
    TextLabel24.ZIndex = 9;
    TextLabel24.Parent = Frame28;
    local ImageLabel14 = Instance.new("ImageLabel");
    ImageLabel14.Name = "Weapon";
    ImageLabel14.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel14.AutoLocalize = false;
    ImageLabel14.BackgroundTransparency = 1;
    ImageLabel14.Image = "rbxassetid://100429874437897";
    ImageLabel14.ImageTransparency = 0.35;
    ImageLabel14.Position = UDim2.fromScale(0.9, 0.4);
    ImageLabel14.ScaleType = Enum.ScaleType.Fit;
    ImageLabel14.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel14.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel14.TileSize = UDim2.fromScale(2, 1);
    ImageLabel14.ZIndex = 9;
    local UIScale13 = Instance.new("UIScale");
    UIScale13.Name = "UIScale";
    UIScale13.Parent = ImageLabel14;
    UIScale13.Scale = 0.75;
    ImageLabel14.Parent = Frame28;
    Frame28.Parent = Frame22;
    local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint4.Parent = Frame22;
    local ImageLabel15 = Instance.new("ImageLabel");
    ImageLabel15.Name = "DefuseKit";
    ImageLabel15.AutoLocalize = false;
    ImageLabel15.BackgroundTransparency = 1;
    ImageLabel15.Image = "rbxassetid://95244952063725";
    ImageLabel15.ImageColor3 = Color3.fromRGB(184, 214, 239);
    ImageLabel15.ImageTransparency = 0.15;
    ImageLabel15.LayoutOrder = 4;
    ImageLabel15.Position = UDim2.fromScale(0, 0.775);
    ImageLabel15.ScaleType = Enum.ScaleType.Fit;
    ImageLabel15.Size = UDim2.fromScale(0.15, 0.15);
    ImageLabel15.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel15.TileSize = UDim2.fromScale(2, 1);
    ImageLabel15.ZIndex = 9;
    ImageLabel15.Parent = Frame22;
    Frame22.Parent = u2.Handler.HUD;
    u7 = Frame22;
    u25 = {
        ImageLabel3,
        ImageLabel4,
        ImageLabel5,
        ImageLabel12,
        ImageLabel6,
        ImageLabel10,
        ImageLabel8,
        ImageLabel14
    };

    for i, v in u25 do
        u26[i] = u1.glow(v);
    end;

    u11 = u1.money(u2.Handler.HUD);
    u1.Handler = Frame;
    u4 = Frame8;
    u5 = Frame12;
    u9 = Frame5;
    u6 = Frame2;
end;

function u1.secretNum(p123, p124) -- Line: 2290
    local Frame = Instance.new("Frame");
    Frame.Name = p124;
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.ClipsDescendants = true;
    Frame.Position = UDim2.fromScale(1, 0);
    Frame.Size = UDim2.fromScale(0.167, 1);
    Frame.ZIndex = 9;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "1";
    TextLabel.AnchorPoint = Vector2.new(1, 0);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(1, 0);
    TextLabel.Size = UDim2.fromScale(6, 1);
    TextLabel.Text = "1";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "2";
    TextLabel2.AnchorPoint = Vector2.new(1, 0);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(1, 0);
    TextLabel2.Size = UDim2.fromScale(6, 1);
    TextLabel2.Text = "2";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = Frame;
    local UIPageLayout = Instance.new("UIPageLayout");
    UIPageLayout.Name = "UIPageLayout";
    UIPageLayout.Circular = true;
    UIPageLayout.FillDirection = Enum.FillDirection.Vertical;
    UIPageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIPageLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIPageLayout.TouchInputEnabled = false;
    UIPageLayout.ScrollWheelInputEnabled = false;
    UIPageLayout.GamepadInputEnabled = false;
    UIPageLayout.Parent = Frame;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "3";
    TextLabel3.AnchorPoint = Vector2.new(1, 0);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(1, 0);
    TextLabel3.Size = UDim2.fromScale(6, 1);
    TextLabel3.Text = "3";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel3.ZIndex = 9;
    TextLabel3.Parent = Frame;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "4";
    TextLabel4.AnchorPoint = Vector2.new(1, 0);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(1, 0);
    TextLabel4.Size = UDim2.fromScale(6, 1);
    TextLabel4.Text = "4";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = Frame;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "5";
    TextLabel5.AnchorPoint = Vector2.new(1, 0);
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(1, 0);
    TextLabel5.Size = UDim2.fromScale(6, 1);
    TextLabel5.Text = "5";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel5.ZIndex = 9;
    TextLabel5.Parent = Frame;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "6";
    TextLabel6.AnchorPoint = Vector2.new(1, 0);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(1, 0);
    TextLabel6.Size = UDim2.fromScale(6, 1);
    TextLabel6.Text = "6";
    TextLabel6.TextColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextScaled = true;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel6.ZIndex = 9;
    TextLabel6.Parent = Frame;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "7";
    TextLabel7.AnchorPoint = Vector2.new(1, 0);
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(1, 0);
    TextLabel7.Size = UDim2.fromScale(6, 1);
    TextLabel7.Text = "7";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel7.ZIndex = 9;
    TextLabel7.Parent = Frame;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "8";
    TextLabel8.AnchorPoint = Vector2.new(1, 0);
    TextLabel8.AutoLocalize = false;
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(1, 0);
    TextLabel8.Size = UDim2.fromScale(6, 1);
    TextLabel8.Text = "8";
    TextLabel8.TextColor3 = Color3.new(1, 1, 1);
    TextLabel8.TextScaled = true;
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel8.ZIndex = 9;
    TextLabel8.Parent = Frame;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "9";
    TextLabel9.AnchorPoint = Vector2.new(1, 0);
    TextLabel9.AutoLocalize = false;
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(1, 0);
    TextLabel9.Size = UDim2.fromScale(6, 1);
    TextLabel9.Text = "9";
    TextLabel9.TextColor3 = Color3.new(1, 1, 1);
    TextLabel9.TextScaled = true;
    TextLabel9.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel9.ZIndex = 9;
    TextLabel9.Parent = Frame;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "0";
    TextLabel10.AnchorPoint = Vector2.new(1, 0);
    TextLabel10.AutoLocalize = false;
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel10.Position = UDim2.fromScale(1, 0);
    TextLabel10.Size = UDim2.fromScale(6, 1);
    TextLabel10.Text = "0";
    TextLabel10.TextColor3 = Color3.new(1, 1, 1);
    TextLabel10.TextScaled = true;
    TextLabel10.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel10.ZIndex = 9;
    TextLabel10.Parent = Frame;
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "$";
    TextLabel11.AnchorPoint = Vector2.new(1, 0);
    TextLabel11.AutoLocalize = false;
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel11.Position = UDim2.fromScale(1, 0);
    TextLabel11.Size = UDim2.fromScale(6, 1);
    TextLabel11.Text = "$";
    TextLabel11.TextColor3 = Color3.new(1, 1, 1);
    TextLabel11.TextScaled = true;
    TextLabel11.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel11.ZIndex = 9;
    TextLabel11.Parent = Frame;
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = " ";
    TextLabel12.AnchorPoint = Vector2.new(1, 0);
    TextLabel12.AutoLocalize = false;
    TextLabel12.BackgroundTransparency = 1;
    TextLabel12.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel12.Position = UDim2.fromScale(1, 0);
    TextLabel12.Size = UDim2.fromScale(6, 1);
    TextLabel12.Text = " ";
    TextLabel12.TextColor3 = Color3.new(1, 1, 1);
    TextLabel12.TextScaled = true;
    TextLabel12.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel12.ZIndex = 9;
    TextLabel12.Parent = Frame;
    Frame.Parent = p123;

    return Frame;
end;

function u1.glow(p125: userdata) -- Line: 2545
    -- upvalues: TweenService (copy), TweenInfo_new_ret4 (copy), u39 (copy)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Main";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = p125.Image;
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = p125.ScaleType;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = p125.TileSize;
    ImageLabel.ZIndex = p125.ZIndex + 1;
    ImageLabel.Parent = p125;
    local Amount = p125:FindFirstChild("Amount");

    if Amount then
        Amount.ZIndex = ImageLabel.ZIndex + 1;
    end;

    local v126 = {
        Main = ImageLabel,
        Layers = {},
        Show = { TweenService:Create(ImageLabel, TweenInfo_new_ret4, {
                ImageTransparency = 0
            }) },
        Hide = { TweenService:Create(ImageLabel, TweenInfo_new_ret4, {
                ImageTransparency = 1
            }) }
    };

    for i, v in u39 do
        local ImageLabel2 = Instance.new("ImageLabel");
        ImageLabel2.Name = i;
        ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageLabel2.AutoLocalize = false;
        ImageLabel2.BackgroundTransparency = 1;
        ImageLabel2.Image = p125.Image;
        ImageLabel2.ImageTransparency = 1;
        ImageLabel2.Position = v;
        ImageLabel2.ScaleType = p125.ScaleType;
        ImageLabel2.Size = UDim2.fromScale(1, 1);
        ImageLabel2.TileSize = p125.TileSize;
        ImageLabel2.ZIndex = p125.ZIndex;
        ImageLabel2.Parent = p125;
        table.insert(v126.Layers, ImageLabel2);
        table.insert(v126.Show, TweenService:Create(ImageLabel2, TweenInfo_new_ret4, {
            ImageTransparency = 0
        }));
        table.insert(v126.Hide, TweenService:Create(ImageLabel2, TweenInfo_new_ret4, {
            ImageTransparency = 1
        }));
    end;

    return v126;
end;

function u1.money(p127) -- Line: 2595
    -- upvalues: u38 (copy), u31 (ref), u35 (copy), u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Money";
    Frame.AnchorPoint = Vector2.new(0, 1);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.015, 0.98);
    Frame.Size = UDim2.fromScale(0.8, 0.04);
    Frame.ZIndex = 9;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = Frame;
    table.insert(u38, UIScale);
    u31 = Instance.new("ImageLabel");
    u31.Name = "BuyZone";
    u31.AnchorPoint = Vector2.new(1, 0.5);
    u31.AutoLocalize = false;
    u31.BackgroundColor3 = Color3.fromRGB(124, 204, 129);
    u31.Image = "rbxassetid://76451012510004";
    u31.ImageColor3 = Color3.fromRGB(50, 50, 50);
    u31.Position = UDim2.fromScale(1.4, 0.5);
    u31.ScaleType = Enum.ScaleType.Fit;
    u31.Size = UDim2.fromScale(0.75, 0.75);
    u31.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    u31.ZIndex = 18;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = u31;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint.Parent = u31;
    u31.Parent = Frame;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.AspectRatio = 2.5;
    UIAspectRatioConstraint2.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint2.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint2.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.BackgroundTransparency = 1;
    Frame2.Size = UDim2.fromScale(1, 1);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Parent = Frame2;

    for i = 1, 6 do
        u35[i] = u1.secretNum(Frame2, i);
        local _ = i;
    end;

    Frame2.Parent = Frame;
    Frame.Parent = p127;

    return Frame;
end;

function u1.newcard(p128, p129, p130) -- Line: 2664
    -- upvalues: u93 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = p129;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Visible = false;
    Frame.Parent = p128;

    for _, v in ipairs(p130) do
        local Color3_new_ret = Color3.new(1, 1, 1);
        local Frame2 = Instance.new("Frame");
        Frame2.Name = v.name;
        Frame2.AnchorPoint = Vector2.new(0.5, 1);
        Frame2.AutoLocalize = false;
        Frame2.BackgroundTransparency = 1;
        Frame2.ClipsDescendants = true;
        Frame2.Position = v.pos;
        Frame2.Rotation = v.rot or 0;
        Frame2.Size = UDim2.fromScale(0.8, 5);
        Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Frame2.ZIndex = v.z or 1;
        Frame2.Parent = Frame;
        local Frame3 = Instance.new("Frame");
        Frame3.Name = "Frame";
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame3.AutoLocalize = false;
        Frame3.BackgroundTransparency = 1;
        Frame3.Position = UDim2.fromScale(v.fx or 0.5, v.fy or 0.93);
        Frame3.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
        Frame3.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
        Frame3.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
        Frame3.SelectionBehaviorUp = Enum.SelectionBehavior.Stop;
        Frame3.SelectionGroup = true;
        Frame3.SelectionOrder = 2;
        Frame3.Size = UDim2.fromScale(0.65, 0.16);
        Frame3.Parent = Frame2;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 4);
        UICorner.Parent = Frame3;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Color = Color3_new_ret;
        UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
        UIStroke.Thickness = 0.065;
        UIStroke.Transparency = 0.2;
        UIStroke.Parent = Frame3;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Name = "TopLeftImage";
        ImageLabel.AutoLocalize = false;
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.Image = "rbxassetid://18348431657";

        if not v.isWhite then
            ImageLabel.ImageColor3 = Color3_new_ret;
        end;

        ImageLabel.ImageTransparency = 0.2;
        ImageLabel.Position = UDim2.fromScale(0.05, 0.05);
        ImageLabel.ScaleType = Enum.ScaleType.Fit;
        ImageLabel.Size = UDim2.fromScale(0.35, 0.25);
        ImageLabel.ZIndex = 2;
        ImageLabel.Parent = Frame3;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "CenterText";
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel.AutoLocalize = false;
        TextLabel.BackgroundTransparency = 1;
        TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
        TextLabel.Position = UDim2.fromScale(0.5, 0.5);
        TextLabel.Size = UDim2.fromScale(1, 0.5);
        TextLabel.Text = v.text;
        TextLabel.TextColor3 = Color3_new_ret;
        TextLabel.TextScaled = true;
        TextLabel.ZIndex = 3;
        TextLabel.Parent = Frame3;
        local ImageLabel2 = Instance.new("ImageLabel");
        ImageLabel2.Name = "CardBlur";
        ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageLabel2.BackgroundColor3 = Color3.new();
        ImageLabel2.Image = "rbxassetid://108060254555731";
        ImageLabel2.ImageTransparency = 0.74;
        ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
        ImageLabel2.Size = UDim2.fromScale(1, 1);
        ImageLabel2.Parent = Frame3;
        local Frame4 = Instance.new("Frame");
        Frame4.Name = "Shine";
        Frame4.AnchorPoint = Vector2.new(0.5, 1);
        Frame4.AutoLocalize = false;
        Frame4.BackgroundTransparency = 1;
        Frame4.Position = UDim2.fromScale(0.5, 1.2);
        Frame4.Size = UDim2.new(1, 4, 5, 0);
        Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        Frame4.ZIndex = 55;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Name = "UIShine";
        UIGradient.Rotation = 90;
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.901263, 0.5),
            NumberSequenceKeypoint.new(0.96, 0.8),
            NumberSequenceKeypoint.new(0.975, 1),
            NumberSequenceKeypoint.new(1, 1)
        });
        UIGradient.Parent = Frame4;
        local UIStroke2 = Instance.new("UIStroke");
        UIStroke2.Name = "ShineStroke";
        UIStroke2.Color = Color3.new(1, 1, 1);
        UIStroke2.Thickness = 1.6;
        UIStroke2.Transparency = 1;
        local UIGradient2 = Instance.new("UIGradient");
        UIGradient2.Name = "UIShine";
        UIGradient2.Rotation = 90;
        UIGradient2.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.0413318, 1),
            NumberSequenceKeypoint.new(0.05, 1),
            NumberSequenceKeypoint.new(0.9, 0),
            NumberSequenceKeypoint.new(0.96, 0.6),
            NumberSequenceKeypoint.new(0.975, 1),
            NumberSequenceKeypoint.new(1, 1)
        });
        UIGradient2.Parent = UIStroke2;
        UIStroke2.Parent = Frame4;
        Frame4.Parent = Frame3;
        local UIGradient3 = Instance.new("UIGradient");
        UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.683391, Color3.fromRGB(143, 143, 143)), ColorSequenceKeypoint.new(1, Color3.fromRGB(126, 126, 126)) });
        UIGradient3.Rotation = 90;
        UIGradient3.Parent = ImageLabel2;
        local UICorner2 = Instance.new("UICorner");
        UICorner2.CornerRadius = UDim.new(0, 4);
        UICorner2.Parent = ImageLabel2;
        table.insert(u93, {
            Stroke = UIStroke,
            Image = ImageLabel,
            Text = TextLabel
        });
    end;

    return Frame;
end;

return u1;