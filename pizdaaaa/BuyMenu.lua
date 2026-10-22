-- ReplicatedStorage.GameClient.Gui.HUD.Buymenu
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Buymenu
-- Decompile time: 41.27 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local UserInputService = game:GetService("UserInputService");
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
local u37 = nil;
local u38 = nil;
local u39 = nil;
local u40 = nil;
local u41 = nil;
local u42 = {};
local u43 = nil;
local u44 = nil;

local function GetEquippedWeaponSkin(p45: string, p46: string) -- Line: 35
    -- upvalues: u26 (ref)
    if u26 and u26[p45] then
        for _, v in u26[p45] do
            if v.WeaponName == p46 then
                return v.SkinName;
            end;
        end;
    end;

    return "Stock";
end;

local function SetBuymenuCharacterWeapon(p47: string, p48: string?) -- Line: 46
    -- upvalues: u38 (ref), u36 (ref), u22 (ref), u26 (ref), u40 (ref), u41 (ref), u42 (copy), u39 (ref)
    if not u38 then
        return;
    end;

    local WeaponClass = u36.GetWeaponClass(p47);

    if not WeaponClass then
        return;
    end;

    if not p48 then
        local v49 = u22;

        if u26 and u26[v49] then
            p48 = "Stock";

            for _, v in u26[v49] do
                if v.WeaponName == p47 then
                    p48 = v.SkinName;
                    break;
                end;
            end;
        end;
    end;

    if u40 == p47 and u41 == p48 then
        return;
    end;

    u40 = p47;
    u41 = p48;
    u36.AddWeapon(u38, p47, p48);
    local v50 = u36.AnimationIds[WeaponClass] and u36.AnimationIds[WeaponClass].Loadout;

    if v50 then
        local v51 = u42[v50];

        if not v51 then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = v50;
            v51 = u38.Humanoid.Animator:LoadAnimation(Animation);
            v51.Looped = true;
            u42[v50] = v51;
        end;

        if u39 and u39 ~= v51 then
            u39:Stop(0.1);
        end;

        if not v51.IsPlaying then
            v51:Play(0.1);
        end;

        u39 = v51;
    end;
end;

local Assets = game:GetService("ReplicatedStorage").Assets;
local _ = Assets.RigTemplate;
local _ = Assets.Idle;
local _ = {
    CT = Color3.fromRGB(172, 195, 220),
    T = Color3.fromRGB(255, 203, 107)
};
local u52 = CFrame.new(0, 0.51, -4.35) * CFrame.Angles(0, 3.141592653589793, 0);
local u53 = {
    CT = {
        Equipment = {
            ["1"] = "Kevlar Vest",
            ["2"] = "Kevlar & Helmet",
            ["3"] = "Zeus Laser",
            ["4"] = "Rescue Kit"
        },
        Pistols = {
            ["1"] = "StartingPistol_1",
            ["2"] = "OtherPistols_1",
            ["3"] = "OtherPistols_2",
            ["4"] = "OtherPistols_3",
            ["5"] = "OtherPistols_4"
        },
        MidTier = {
            ["1"] = "MidTier_1",
            ["2"] = "MidTier_2",
            ["3"] = "MidTier_3",
            ["4"] = "MidTier_4",
            ["5"] = "MidTier_5"
        },
        Rifles = {
            ["1"] = "Rifles_1",
            ["2"] = "Rifles_2",
            ["3"] = "Rifles_3",
            ["4"] = "Rifles_4",
            ["5"] = "Rifles_5"
        },
        Grenades = {
            ["1"] = "Flashbang",
            ["2"] = "Smoke Grenade",
            ["3"] = "High Explosive Grenade",
            ["4"] = "Incendiary Grenade",
            ["5"] = "Decoy Grenade"
        }
    },
    T = {
        Equipment = {
            ["1"] = "Kevlar Vest",
            ["2"] = "Kevlar & Helmet",
            ["3"] = "Zeus Laser"
        },
        Pistols = {
            ["1"] = "StartingPistol_1",
            ["2"] = "OtherPistols_1",
            ["3"] = "OtherPistols_2",
            ["4"] = "OtherPistols_3",
            ["5"] = "OtherPistols_4"
        },
        MidTier = {
            ["1"] = "MidTier_1",
            ["2"] = "MidTier_2",
            ["3"] = "MidTier_3",
            ["4"] = "MidTier_4",
            ["5"] = "MidTier_5"
        },
        Rifles = {
            ["1"] = "Rifles_1",
            ["2"] = "Rifles_2",
            ["3"] = "Rifles_3",
            ["4"] = "Rifles_4",
            ["5"] = "Rifles_5"
        },
        Grenades = {
            ["1"] = "Flashbang",
            ["2"] = "Smoke Grenade",
            ["3"] = "High Explosive Grenade",
            ["4"] = "Molotov",
            ["5"] = "Decoy Grenade"
        }
    }
};
local u54 = {
    [Enum.KeyCode.One] = "Equipment",
    [Enum.KeyCode.Two] = "Pistols",
    [Enum.KeyCode.Three] = "MidTier",
    [Enum.KeyCode.Four] = "Rifles",
    [Enum.KeyCode.Five] = "Grenades",
    [Enum.KeyCode.KeypadOne] = "Equipment",
    [Enum.KeyCode.KeypadTwo] = "Pistols",
    [Enum.KeyCode.KeypadThree] = "MidTier",
    [Enum.KeyCode.KeypadFour] = "Rifles",
    [Enum.KeyCode.KeypadFive] = "Grenades"
};
local u55 = {
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.KeypadOne] = "1",
    [Enum.KeyCode.KeypadTwo] = "2",
    [Enum.KeyCode.KeypadThree] = "3",
    [Enum.KeyCode.KeypadFour] = "4",
    [Enum.KeyCode.KeypadFive] = "5"
};
local u56 = nil;
local u57 = false;
local u58 = {};
TweenInfo.new(0.2);
local TweenInfo_new_ret = TweenInfo.new(0.25);
local TweenInfo_new_ret2 = TweenInfo.new(0.5);
local TweenInfo_new_ret3 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local u59 = nil;
local u60 = nil;

local function GetWeaponSlotByName(p61) -- Line: 215
    -- upvalues: u21 (ref)
    for i, v in u21 do
        if v.Name == p61 then
            return v, i;
        end;
    end;
end;

local function GetLoadoutWeaponInfo(p62, p63, p64) -- Line: 223
    -- upvalues: u8 (ref)
    if p62 == "Equipment" or p62 == "Grenades" then
        return p63, "Stock";
    end;

    local v65 = p64[tostring(u8.LoadoutNum[p63])];

    return v65.WeaponName, v65.SkinName;
end;

local function SetWeaponFrameState(p66, p67, p68, p69) -- Line: 231
    -- upvalues: u24 (ref)
    local ItemImage = p66.ItemImage;
    local ItemPrice = p66.ItemPrice;
    local ItemName = p66.ItemName;
    p66.Refund.Visible = p69;

    if p67 then
        p66.UIStroke.Enabled = true;
        p66.Blur.Visible = true;
        p66.BackgroundTransparency = 0;
        ItemImage.ImageColor3 = Color3.fromRGB(255, 255, 255);
        ItemImage.ImageTransparency = 0.75;
        ItemPrice.TextColor3 = Color3.fromRGB(255, 255, 255);
        ItemPrice.TextTransparency = 0.75;
        ItemName.TextColor3 = Color3.fromRGB(255, 255, 255);
        ItemName.TextTransparency = 0.75;

        return;
    end;

    if p68 then
        p66.UIStroke.Enabled = false;
        p66.Blur.Visible = true;
        p66.BackgroundTransparency = 0.4;
        ItemImage.ImageColor3 = u24;
        ItemImage.ImageTransparency = 0.2;
        ItemPrice.TextColor3 = u24;
        ItemPrice.TextTransparency = 0.2;
        ItemName.TextColor3 = u24;
        ItemName.TextTransparency = 0.2;

        return;
    end;

    p66.UIStroke.Enabled = false;
    p66.Blur.Visible = false;
    p66.BackgroundTransparency = 0;
    ItemImage.ImageColor3 = Color3.fromRGB(255, 255, 255);
    ItemImage.ImageTransparency = 0.75;
    ItemPrice.TextColor3 = Color3.fromRGB(255, 255, 255);
    ItemPrice.TextTransparency = 0.75;
    ItemName.TextColor3 = Color3.fromRGB(255, 255, 255);
    ItemName.TextTransparency = 0.75;
end;

local function PredictSpend(p70) -- Line: 279
    -- upvalues: GameStats (copy), u23 (ref), u31 (ref), u1 (copy), LocalPlayer (copy)
    if GameStats:GetAttribute("State") == "Warmup" then
        return;
    end;

    u23 = u23 - p70;
    u31.Text = `${u23}`;
    u1.UpdateWeapons();
    task.delay(1, function() -- Line: 288
        -- upvalues: u23 (ref), LocalPlayer (ref), u31 (ref), u1 (ref)
        u23 = LocalPlayer:GetAttribute("Cash") or 0;
        u31.Text = `${u23}`;
        u1.UpdateWeapons();
    end);
end;

local function Buy(p71: string, p72: string?, p73: boolean) -- Line: 298
    -- upvalues: u12 (ref), u7 (ref), u11 (ref), u8 (ref)
    if p73 or (p72 == "Equipment" or (p72 == "Grenades" or not u12.Get(p71))) then
        u11.Weapon.BuyWeapon.Fire({
            Enum = u8.WeaponsNum[p71],
            Drop = p73
        });

        return;
    end;

    u7.QueueBuy(p71);
end;

function u1.Draw() -- Line: 311
    -- upvalues: GameStats (copy), u15 (ref), u22 (ref), u23 (ref), LocalPlayer (copy), u21 (ref), u7 (ref), u24 (ref), u18 (ref), u26 (ref), u43 (ref), u29 (ref), u53 (copy), u8 (ref), u9 (ref), u12 (ref), u1 (copy), u5 (ref), u28 (ref), u32 (ref), u31 (ref), UserInputService (copy), u56 (ref), u55 (copy), Buy (copy), PredictSpend (copy), u54 (copy), u57 (ref), u3 (ref), u58 (copy), u33 (ref)
    local Attribute = GameStats:GetAttribute("BuyTime");
    local LoseStreaks = u15.Get(GameStats:GetAttribute("Gamemode")).MoneySettings.LoseStreaks;
    local Attribute2 = GameStats:GetAttribute(u22 .. "LoseStreak");
    local v74 = LoseStreaks[Attribute2] and LoseStreaks[Attribute2][u22] or 2700;
    u23 = LocalPlayer:GetAttribute("Cash") or 0;
    u21 = u7.GetWeaponInventory();
    u24 = u18.GetHudColor();
    local v75 = u26[u22];
    local v76 = `{u22}{LocalPlayer:GetAttribute("WeaponLoadout")}`;

    if v76 == u43 then
        for _, child in u29:GetChildren() do
            for _, child2 in child:GetChildren() do
                if child2:IsA("ImageButton") then
                    child2.BackgroundColor3 = Color3.fromRGB(31, 31, 31);
                end;
            end;
        end;
    else
        u43 = v76;

        for _, child in u29:GetChildren() do
            for _, child2 in child:GetChildren() do
                if child2:IsA("ImageButton") then
                    child2:Destroy();
                end;
            end;
        end;

        for i, v in u53[u22] do
            local v77 = u29:FindFirstChild(i);

            if v77 then
                local v78 = i;

                for i2, v2 in v do
                    local v79;

                    if v78 == "Equipment" or v78 == "Grenades" then
                        v79 = v2;
                    else
                        local v80 = v75[tostring(u8.LoadoutNum[v2])];
                        v79 = v80.WeaponName;
                        local _ = v80.SkinName;
                    end;

                    local v81 = u9.GetCategory(v79) or u12.Get(v79);

                    if v81 then
                        local v82 = v81.DisplayName or v79;
                        local v83 = u1.buyItem();
                        v83.Name = i2;
                        v83.ItemName.Text = v82;
                        v83.ItemPrice.Text = `${tostring(v81.Data.Price)}`;
                        v83.Number.Text = i2;
                        v83.ItemImage.Image = `rbxassetid://{v81.GuiInformation.IconHorizontal}`;
                        v83.BackgroundColor3 = Color3.fromRGB(31, 31, 31);
                        v83.LayoutOrder = tonumber(i2) or 0;

                        if v78 == "Equipment" or v78 == "Grenades" then
                            v83.ItemImage.Size = UDim2.new(0.5, 0, 0.4, 0);
                        end;

                        v83.Visible = true;
                        v83.Parent = v77;
                    end;
                end;
            end;
        end;
    end;

    u5:Add("BuyTime", GameStats:GetAttributeChangedSignal("BuyTime"):Connect(function() -- Line: 375
        -- upvalues: Attribute (ref), GameStats (ref), u28 (ref), u1 (ref), u32 (ref)
        Attribute = GameStats:GetAttribute("BuyTime");

        if Attribute >= 0 and (Attribute <= 3 and u28.Visible) then
            u1.Visible();
        end;

        u32.Text = `Buy Time Remaining <font transparency="0" weight="Bold">{Attribute < 0 and "∞" or DateTime.fromUnixTimestamp(Attribute):FormatUniversalTime("m:ss", "en-us")}</font>`;
    end));
    u5:Add("Cash", LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function() -- Line: 385
        -- upvalues: u23 (ref), LocalPlayer (ref), u31 (ref), u1 (ref)
        u23 = LocalPlayer:GetAttribute("Cash");
        u31.Text = `${u23}`;
        u1.UpdateWeapons();
    end));
    u5:Add("CanRefundArmor", LocalPlayer:GetAttributeChangedSignal("CanRefundArmor"):Connect(function() -- Line: 392
        -- upvalues: u1 (ref)
        u1.UpdateWeapons();
    end));
    u5:Add("ArmorValue", LocalPlayer:GetAttributeChangedSignal("ArmorValue"):Connect(function() -- Line: 396
        -- upvalues: u1 (ref)
        u1.UpdateWeapons();
    end));
    u5:Add("HasHelmet", LocalPlayer:GetAttributeChangedSignal("HasHelmet"):Connect(function() -- Line: 400
        -- upvalues: u1 (ref)
        u1.UpdateWeapons();
    end));
    u5:Add("DefuseKit", LocalPlayer:GetAttributeChangedSignal("DefuseKit"):Connect(function() -- Line: 404
        -- upvalues: u1 (ref)
        u1.UpdateWeapons();
    end));
    u5:Add("CanRefundKit", LocalPlayer:GetAttributeChangedSignal("CanRefundKit"):Connect(function() -- Line: 408
        -- upvalues: u1 (ref)
        u1.UpdateWeapons();
    end));
    u5:Add("Binds", UserInputService.InputEnded:Connect(function(p84) -- Line: 412
        -- upvalues: u56 (ref), u55 (ref), u53 (ref), u22 (ref), u26 (ref), u8 (ref), u1 (ref), u9 (ref), u12 (ref), u21 (ref), u23 (ref), Buy (ref), PredictSpend (ref), u54 (ref)
        if not u56 then
            local v85 = u54[p84.KeyCode];

            if v85 then
                u56 = v85;
                u1.SelectNumber(u56);
            end;

            return;
        end;

        local v86 = u55[p84.KeyCode];

        if not v86 then
            u56 = nil;
            u1.SelectNumber();

            return;
        end;

        local v87 = u53[u22][u56][v86];
        local v88 = u56;
        local v89 = u26;

        if u56 ~= "Equipment" and u56 ~= "Grenades" then
            v89 = u26[u22][tostring(u8.LoadoutNum[v87])].WeaponName;
        end;

        u56 = nil;
        u1.SelectNumber();

        if not v89 then
            return;
        end;

        local v90 = u9.GetCategory(v89) or u12.Get(v89);

        if not v90 then
            return;
        end;

        local v91 = nil;

        for _, v in u21 do
            if v.Name == v89 then
                v91 = v;
                break;
            end;
        end;

        if v91 or u23 < v90.Data.Price then
            return;
        end;

        Buy(v89, v88, false);
        PredictSpend(v90.Data.Price);
    end));
    u5:Add("InputBegan", UserInputService.InputBegan:Connect(function(p92) -- Line: 464
        -- upvalues: u57 (ref)
        if p92.KeyCode == Enum.KeyCode.LeftControl then
            u57 = true;
        end;
    end));
    u5:Add("InputEnded", UserInputService.InputEnded:Connect(function(p93) -- Line: 470
        -- upvalues: u57 (ref)
        if p93.KeyCode == Enum.KeyCode.LeftControl then
            u57 = false;
        end;
    end));

    for _, child in u3:GetChildren() do
        local Attribute3 = child:GetAttribute("WeaponName");

        if not Attribute3 then
            return;
        end;

        local Name = child.Name;

        if child:GetAttribute("InBuyZone") == u22 then
            u58[Name] = Attribute3;
        end;

        u5:Add(`{Name}InBuyZone`, child:GetAttributeChangedSignal("InBuyZone"):Connect(function() -- Line: 489
            -- upvalues: child (copy), u22 (ref), u58 (ref), Name (copy), Attribute3 (copy), u1 (ref)
            if child:GetAttribute("InBuyZone") == u22 then
                u58[Name] = Attribute3;
            else
                u58[Name] = nil;
            end;

            u1.UpdateDroppedWeapons();
        end));
    end;

    u5:Add("DroppedWeaponsAdded", u3.ChildAdded:Connect(function(u94) -- Line: 500
        -- upvalues: u22 (ref), u58 (ref), u5 (ref), u1 (ref)
        local Attribute3 = u94:GetAttribute("WeaponName");

        if not Attribute3 then
            return;
        end;

        local Name = u94.Name;

        if u94:GetAttribute("InBuyZone") == u22 then
            u58[Name] = Attribute3;
        end;

        u5:Add(`{Name}InBuyZone`, u94:GetAttributeChangedSignal("InBuyZone"):Connect(function() -- Line: 513
            -- upvalues: u94 (copy), u22 (ref), u58 (ref), Name (copy), Attribute3 (copy), u1 (ref)
            if u94:GetAttribute("InBuyZone") == u22 then
                u58[Name] = Attribute3;
            else
                u58[Name] = nil;
            end;

            u1.UpdateDroppedWeapons();
        end));
        u1.UpdateDroppedWeapons();
    end));
    u5:Add("DroppedWeaponsRemoved", u3.ChildRemoved:Connect(function(p95) -- Line: 525
        -- upvalues: u58 (ref), u5 (ref), u1 (ref)
        local Name = p95.Name;
        u58[Name] = nil;
        u5:Remove((`{Name}InBuyZone`));
        u1.UpdateDroppedWeapons();
    end));
    u31.TextColor3 = u24;
    u31.Text = `${u23}`;
    u33.Text = `Next Round Minimum: ${u23 + v74}`;
    u32.Text = `Buy Time Remaining <font transparency="0" weight="Bold">{Attribute < 0 and "∞" or DateTime.fromUnixTimestamp(Attribute):FormatUniversalTime("m:ss", "en-us")}</font>`;
    u1.UpdateWeapons();
    u1.UpdateDroppedWeapons();
    u1.DrawCharacter();
end;

function u1.UpdateWeapons() -- Line: 544
    -- upvalues: u28 (ref), u21 (ref), u7 (ref), u26 (ref), u22 (ref), u53 (copy), u29 (ref), u8 (ref), u9 (ref), u12 (ref), u10 (ref), u23 (ref), LocalPlayer (copy), u5 (ref), SetWeaponFrameState (copy), u56 (ref), u37 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), u1 (copy), u11 (ref), PredictSpend (copy), SetBuymenuCharacterWeapon (copy), u30 (ref), TweenInfo_new_ret (copy), Buy (copy), u57 (ref), GameStats (copy)
    if not u28.Visible then
        return;
    end;

    u21 = u7.GetWeaponInventory();
    local v96 = u26[u22];

    for i, v in u53[u22] do
        local v97 = u29:FindFirstChild(i);

        if v97 then
            local u98 = i;

            for i2, v2 in v do
                local u99 = v97:FindFirstChild(i2);

                if u99 then
                    local u100, u101;

                    if u98 == "Equipment" or u98 == "Grenades" then
                        u100 = v2;
                        u101 = "Stock";
                    else
                        local v102 = v96[tostring(u8.LoadoutNum[v2])];
                        u100 = v102.WeaponName;
                        u101 = v102.SkinName;
                    end;

                    local u103 = u9.GetCategory(u100) or u12.Get(u100);
                    local u104 = u9.GetItem(u100, u101) or u10.GetWeaponSkin(u100, u101);

                    if u103 then
                        local u105 = u103.DisplayName or u100;
                        local u106;

                        if u104 then
                            u106 = u104.DisplayName or u101;
                        else
                            u106 = u101;
                        end;

                        local GuiInformation = u103.GuiInformation;
                        local LoadoutCategory = GuiInformation.LoadoutCategory;
                        local Price = u103.Data.Price;
                        local v107 = i2;
                        local u108 = nil;
                        local u109;

                        for i3, v3 in u21 do
                            if v3.Name == u100 then
                                u109 = i3;
                                u108 = v3;
                                break;
                            end;
                        end;

                        u109 = nil;
                        local u110;

                        if u108 then
                            if u108.NameTag == "" then
                                u110 = false;
                            else
                                u110 = u108.NameTag;
                            end;
                        end;

                        local u111;

                        if u108 then
                            u111 = u108.KillTrack;
                        end;

                        local u112 = Price <= u23;
                        local v113 = u108 and u108.RefundAvailable;

                        if v113 then
                            local v114;

                            if u98 == "Pistols" then
                                v114 = v107 == "1";
                            else
                                v114 = false;
                            end;

                            v113 = not v114;
                        end;

                        local ItemName = u99.ItemName;
                        local v115;

                        if u110 then
                            v115 = `''{u110}''` or u105;
                        else
                            v115 = u105;
                        end;

                        ItemName.Text = v115;

                        if u111 ~= nil then
                            u99.ItemName.Text = `KillTrackᴷ⁺ {u99.ItemName.Text}`;
                        end;

                        if LoadoutCategory == "Equipment" then
                            if u100 == "Kevlar Vest" or u100 == "Kevlar & Helmet" then
                                if (LocalPlayer:GetAttribute("ArmorValue") or 0) >= 100 then
                                    if u100 == "Kevlar Vest" then
                                        u108 = true;
                                    elseif u100 == "Kevlar & Helmet" then
                                        if LocalPlayer:GetAttribute("HasHelmet") then
                                            u99.ItemImage.Image = `rbxassetid://{GuiInformation.IconHorizontal}`;
                                            u99.ItemName.Text = u105;
                                            u99.ItemPrice.Text = `${Price}`;
                                            u108 = true;
                                        else
                                            Price = u103.Data.HelmetPrice;
                                            u112 = Price <= u23;
                                            u99.ItemImage.Image = `rbxassetid://{GuiInformation.HelmetIcon}`;
                                            u99.ItemName.Text = "Helmet";
                                            u99.ItemPrice.Text = `${Price}`;
                                            u108 = false;
                                        end;
                                    end;
                                elseif u100 == "Kevlar & Helmet" then
                                    u99.ItemImage.Image = `rbxassetid://{GuiInformation.IconHorizontal}`;
                                    u99.ItemName.Text = u105;
                                    u99.ItemPrice.Text = `${Price}`;
                                    u108 = false;
                                else
                                    u108 = false;
                                end;

                                if u108 and LocalPlayer:GetAttribute("CanRefundArmor") == u100 then
                                    v113 = true;
                                end;
                            elseif u100 == "Rescue Kit" then
                                if LocalPlayer:GetAttribute("DefuseKit") then
                                    u108 = true;

                                    if LocalPlayer:GetAttribute("CanRefundKit") then
                                        v113 = true;
                                    end;
                                else
                                    u108 = false;
                                end;
                            end;
                        end;

                        local v116 = `{u98}_{v107}`;
                        u5:Removes(`{v116}_Refund_Enter`, `{v116}_Refund_Leave`, `{v116}_Refund_Click`, `{v116}_Enter`, `{v116}_Leave`, `{v116}_SelectionGained`, `{v116}_SelectionLost`, (`{v116}_Click`));
                        SetWeaponFrameState(u99, u108, u112, v113);

                        if v113 then
                            local Refund = u99.Refund;
                            u5:Add(`{v116}_Refund_Enter`, Refund.MouseEnter:Connect(function() -- Line: 644
                                -- upvalues: u56 (ref), u98 (copy), u37 (ref), TweenService (ref), Refund (copy), TweenInfo_new_ret2 (ref), u1 (ref)
                                if u56 and u56 ~= u98 then
                                    return;
                                end;

                                u37.Play("UI.submenu_scroll");
                                TweenService:Create(Refund, TweenInfo_new_ret2, {
                                    ImageTransparency = 0.1
                                }):Play();
                                u1.UpdateHover(true, Refund, "Refund");
                            end));
                            u5:Add(`{v116}_Refund_Leave`, Refund.MouseLeave:Connect(function() -- Line: 655
                                -- upvalues: u56 (ref), u98 (copy), TweenService (ref), Refund (copy), TweenInfo_new_ret2 (ref), u1 (ref)
                                if u56 and u56 ~= u98 then
                                    return;
                                end;

                                TweenService:Create(Refund, TweenInfo_new_ret2, {
                                    ImageTransparency = 0.4
                                }):Play();
                                u1.UpdateHover(false);
                            end));
                            u5:Add(`{v116}_Refund_Click`, Refund.MouseButton1Click:Connect(function() -- Line: 664
                                -- upvalues: u56 (ref), u98 (copy), u37 (ref), u1 (ref), LoadoutCategory (copy), u8 (ref), u100 (copy), u11 (ref), u109 (copy), PredictSpend (ref), Price (ref)
                                if u56 and u56 ~= u98 then
                                    return;
                                end;

                                u37.Play("UI.submenu_click");
                                u1.UpdateHover(false);

                                if LoadoutCategory == "Equipment" then
                                    u11.Weapon.RefundWeapon.Fire({
                                        Type = "Equipment",
                                        Slot = u8.WeaponsNum[u100]
                                    });
                                else
                                    u11.Weapon.RefundWeapon.Fire({
                                        Type = "Weapon",
                                        Slot = tonumber(u109)
                                    });
                                end;

                                PredictSpend(-Price);
                            end));
                        end;

                        local function Enter() -- Line: 691
                            -- upvalues: u56 (ref), u98 (copy), u100 (copy), SetBuymenuCharacterWeapon (ref), u101 (copy), u37 (ref), TweenService (ref), u99 (copy), TweenInfo_new_ret2 (ref), u30 (ref), u108 (ref), u112 (ref), u1 (ref), u105 (copy), u106 (copy), u103 (copy), u104 (copy), u110 (copy), u111 (copy)
                            if u56 and u56 ~= u98 then
                                return;
                            end;

                            if u100 then
                                SetBuymenuCharacterWeapon(u100, u101);
                            end;

                            u37.Play("UI.submenu_dropdown_rollover");
                            TweenService:Create(u99, TweenInfo_new_ret2, {
                                BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                            }):Play();
                            TweenService:Create(u99.Number, TweenInfo_new_ret2, {
                                TextTransparency = 0.45
                            }):Play();
                            TweenService:Create(u30, TweenInfo_new_ret2, {
                                GroupTransparency = 0
                            }):Play();
                            u1.UpdateInfoFrame(true, u105, u106, u103, u104, u108 and 1 or (u112 and 2 or 3), u110, u111);

                            if not u108 and u112 then
                                TweenService:Create(u99.Blur, TweenInfo_new_ret2, {
                                    ImageTransparency = 0.8
                                }):Play();

                                return;
                            end;

                            TweenService:Create(u99.ItemImage, TweenInfo_new_ret2, {
                                ImageTransparency = 0.5
                            }):Play();
                            TweenService:Create(u99.ItemPrice, TweenInfo_new_ret2, {
                                TextTransparency = 0.5
                            }):Play();
                            TweenService:Create(u99.ItemName, TweenInfo_new_ret2, {
                                TextTransparency = 0.5
                            }):Play();
                        end;

                        local function Leave() -- Line: 718
                            -- upvalues: u56 (ref), u98 (copy), TweenService (ref), u99 (copy), TweenInfo_new_ret (ref), u30 (ref), u1 (ref), u108 (ref), u112 (ref)
                            if u56 and u56 ~= u98 then
                                return;
                            end;

                            TweenService:Create(u99, TweenInfo_new_ret, {
                                BackgroundColor3 = Color3.fromRGB(31, 31, 31)
                            }):Play();
                            TweenService:Create(u99.Number, TweenInfo_new_ret, {
                                TextTransparency = 0.5
                            }):Play();
                            TweenService:Create(u30, TweenInfo_new_ret, {
                                GroupTransparency = 1
                            }):Play();
                            u1.UpdateInfoFrame(false);

                            if not u108 and u112 then
                                TweenService:Create(u99.Blur, TweenInfo_new_ret, {
                                    ImageTransparency = 0.9
                                }):Play();

                                return;
                            end;

                            TweenService:Create(u99.ItemImage, TweenInfo_new_ret, {
                                ImageTransparency = 0.75
                            }):Play();
                            TweenService:Create(u99.ItemPrice, TweenInfo_new_ret, {
                                TextTransparency = 0.75
                            }):Play();
                            TweenService:Create(u99.ItemName, TweenInfo_new_ret, {
                                TextTransparency = 0.75
                            }):Play();
                        end;

                        u5:Add(`{v116}_Enter`, u99.MouseEnter:Connect(Enter));
                        u5:Add(`{v116}_Leave`, u99.MouseLeave:Connect(Leave));
                        u5:Add(`{v116}_SelectionGained`, u99.SelectionGained:Connect(Enter));
                        u5:Add(`{v116}_SelectionLost`, u99.SelectionLost:Connect(Leave));
                        u5:Add(`{v116}_Click`, u99.MouseButton1Click:Connect(function() -- Line: 743
                            -- upvalues: u56 (ref), u98 (copy), u108 (ref), u112 (ref), u37 (ref), Buy (ref), u100 (copy), LoadoutCategory (copy), u57 (ref), GameStats (ref), PredictSpend (ref), Price (ref)
                            if u56 and u56 ~= u98 then
                                return;
                            end;

                            if u108 or not u112 then
                                return;
                            end;

                            u37.Play("UI.submenu_click");
                            local v117 = u57;

                            if v117 then
                                if LoadoutCategory == "Equipment" then
                                    v117 = false;
                                else
                                    v117 = GameStats:GetAttribute("State") ~= "Warmup";
                                end;
                            end;

                            Buy(u100, LoadoutCategory, v117 == true);
                            PredictSpend(Price);
                        end));
                    end;
                end;
            end;
        end;
    end;

    u1.UpdateDroppedWeapons();
end;

function u1.UpdateDroppedWeapons() -- Line: 761
    -- upvalues: u35 (ref), u5 (ref), u58 (copy), u9 (ref), u12 (ref), u21 (ref), u1 (copy), u24 (ref), SetBuymenuCharacterWeapon (copy), u22 (ref), u26 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), TweenInfo_new_ret (copy), u37 (ref), u11 (ref)
    for _, child in u35:GetChildren() do
        for _, child2 in child:GetChildren() do
            if child2:IsA("ImageButton") then
                local Name = child2.Name;
                u5:Removes(`{Name}DroppedWeapons_MouseEnter`, `{Name}DroppedWeapons_MouseLeave`, (`{Name}DroppedWeapons_MouseButton1Click`));
                child2:Destroy();
            end;
        end;
    end;

    local v118 = {};

    for i, v in u58 do
        local v119;

        if v118[v] then
            v119 = v118[v];
            v119.Count = v119.Count + 1;
        else
            local v120 = u9.GetCategory(v) or u12.Get(v);

            if v120 then
                v118[v] = {
                    Count = 0,
                    FirstIdentifier = i,
                    Weapon = v120
                };
                v119 = v118[v];
                v119.Count = v119.Count + 1;
            end;
        end;
    end;

    for i, v in v118 do
        local Weapon = v.Weapon;
        local FirstIdentifier = v.FirstIdentifier;
        local Count = v.Count;
        local u121 = i;
        local v122 = nil;

        for _, v2 in u21 do
            if v2.Name == u121 then
                v122 = v2;
                break;
            end;
        end;

        local v123 = Weapon.DisplayName or u121;
        local LoadoutCategory = Weapon.GuiInformation.LoadoutCategory;
        local v124 = u35:FindFirstChild((LoadoutCategory == "StartingPistol" or LoadoutCategory == "OtherPistols") and "Pistols" or LoadoutCategory);

        if v124 then
            local u125 = u1.dropItem();
            u125.Name = u121;
            local ItemName = u125.ItemName;

            if Count > 1 then
                v123 = `x{Count} {v123}` or v123;
            end;

            ItemName.Text = v123;
            u125.ItemImage.Image = `rbxassetid://{Weapon.GuiInformation.IconHorizontal}`;

            if v122 then
                u125.ItemImage.ImageColor3 = Color3.fromRGB(255, 255, 255);
                u125.ItemImage.ImageTransparency = 0.75;
                u125.ItemName.TextColor3 = Color3.fromRGB(255, 255, 255);
                u125.ItemName.TextTransparency = 0.75;
                u125.BackgroundTransparency = 0.8;
                u125.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            else
                u125.ItemImage.ImageColor3 = u24;
                u125.ItemImage.ImageTransparency = 0.2;
                u125.ItemName.TextColor3 = u24;
                u125.ItemName.TextTransparency = 0.2;
                u125.BackgroundTransparency = 0;
                u125.BackgroundColor3 = Color3.fromRGB(57, 56, 57);
                u5:Add(`{u121}DroppedWeapons_MouseEnter`, u125.MouseEnter:Connect(function() -- Line: 837
                    -- upvalues: u121 (copy), SetBuymenuCharacterWeapon (ref), u22 (ref), u26 (ref), TweenService (ref), u125 (copy), TweenInfo_new_ret2 (ref)
                    if u121 then
                        local v126 = u22;
                        local v127 = u121;
                        local v128;

                        if u26 and u26[v126] then
                            v128 = "Stock";

                            for _, v2 in u26[v126] do
                                if v2.WeaponName == v127 then
                                    v128 = v2.SkinName;
                                    break;
                                end;
                            end;
                        end;

                        SetBuymenuCharacterWeapon(u121, v128);
                    end;

                    TweenService:Create(u125, TweenInfo_new_ret2, {
                        BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    }):Play();
                end));
                u5:Add(`{u121}DroppedWeapons_MouseLeave`, u125.MouseLeave:Connect(function() -- Line: 844
                    -- upvalues: TweenService (ref), u125 (copy), TweenInfo_new_ret (ref)
                    TweenService:Create(u125, TweenInfo_new_ret, {
                        BackgroundColor3 = Color3.fromRGB(57, 56, 57)
                    }):Play();
                end));
                u5:Add(`{u121}DroppedWeapons_MouseButton1Click`, u125.MouseButton1Click:Connect(function() -- Line: 848
                    -- upvalues: u37 (ref), u11 (ref), FirstIdentifier (copy)
                    u37.Play("UI.submenu_click");
                    u11.Weapon.PickUpWeapon.Fire((tonumber(FirstIdentifier)));
                end));
            end;

            u125.Visible = true;
            u125.Parent = v124;
        end;
    end;
end;

function u1.UpdateInfoFrame(p129, p130, p131, p132, p133, p134, p135, p136) -- Line: 860
    -- upvalues: TweenService (copy), u34 (ref), TweenInfo_new_ret (copy), u30 (ref), u13 (ref), u23 (ref)
    if not p129 then
        TweenService:Create(u34, TweenInfo_new_ret, {
            GroupTransparency = 1
        }):Play();

        return;
    end;

    u30.ItemName.Text = p135 and `''{p135}''` or `{p131 and p131 == "Stock" and `{p130}` or `{p130} | {p131}`}`;

    if p136 ~= nil then
        u30.ItemName.Text = `KillTrackᴷ⁺ {u30.ItemName.Text}`;
    end;

    u30.ItemName.TextColor3 = u13[p133 and (p133.Rarity or "Stock") or "Stock"];
    u30.Description.Text = p136 and `KillTrack Confirmed Kills: {p136}\n\n{p133 and p133.Description or p132.GuiInformation.Description}` or `{p133 and p133.Description or p132.GuiInformation.Description}`;

    if p134 == 1 then
        u34.Title.Text = "Currently holding";
        TweenService:Create(u34, TweenInfo_new_ret, {
            GroupTransparency = 0
        }):Play();

        return;
    end;

    if p134 == 2 then
        TweenService:Create(u34, TweenInfo_new_ret, {
            GroupTransparency = 1
        }):Play();

        return;
    end;

    u34.Title.Text = `Need ${p132.Data.Price - u23} more`;
    TweenService:Create(u34, TweenInfo_new_ret, {
        GroupTransparency = 0
    }):Play();
end;

function u1.UpdateHover(p137, p138, p139) -- Line: 893
    -- upvalues: u27 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    if not p137 then
        TweenService:Create(u27, TweenInfo_new_ret, {
            GroupTransparency = 1
        }):Play();

        return;
    end;

    u27.TextLabel.Text = p139;
    local AbsolutePosition = p138.AbsolutePosition;
    u27.Position = UDim2.new(0, AbsolutePosition.X + p138.AbsoluteSize.X + 10, 0, AbsolutePosition.Y + p138.AbsoluteSize.X / 2 + u27.AbsoluteSize.X / 2);
    TweenService:Create(u27, TweenInfo_new_ret, {
        GroupTransparency = 0
    }):Play();
end;

function u1.SelectNumber(p140) -- Line: 906
    -- upvalues: u53 (copy), u22 (ref), u29 (ref)
    for i, v in u53[u22] do
        local v141 = u29:FindFirstChild(i);
        local v142 = CenterTitle:FindFirstChild(i);

        if v141 then
            if p140 and p140 ~= i then
                v141.GroupTransparency = 0.5;
                v142.Title.TextTransparency = 0.5;

                if p140 then
                    v142.Number.Visible = false;
                end;
            else
                v141.GroupTransparency = 0;
                v142.Title.TextTransparency = 0.2;
                v142.Number.Visible = true;
            end;

            local v143 = i;

            for i2, _ in v do
                local v144 = v141:FindFirstChild(i2);

                if v144 then
                    if p140 == v143 then
                        v144.Number.TextTransparency = 0.2;
                    else
                        v144.Number.TextTransparency = 0.5;
                    end;
                end;
            end;
        end;
    end;
end;

function u1.DrawCharacter() -- Line: 940
    -- upvalues: u26 (ref), u22 (ref), u44 (ref), u28 (ref), u36 (ref), u52 (copy), u38 (ref), u39 (ref), u40 (ref), u41 (ref), u42 (copy), u7 (ref), SetBuymenuCharacterWeapon (copy)
    local v145 = u26 and u26[u22] and u26[u22]["16"];
    local v146 = v145 and v145.WeaponName or `{u22} Gloves`;
    local v147 = v145 and v145.SkinName or "Stock";
    local v148 = u26 and u26[u22] and u26[u22]["15"];
    local v149 = v148 and v148.SkinName or `{u22} Agent`;
    local v150 = `{u22}{v149}{v146}{v147}`;

    if v150 ~= u44 then
        if u28.ViewportFrame:FindFirstChildOfClass("WorldModel") then
            u28.ViewportFrame:FindFirstChildOfClass("WorldModel"):Destroy();
        end;

        local WorldModel = Instance.new("WorldModel");
        WorldModel.Parent = u28.ViewportFrame;
        local v151 = u36.new({
            Name = `{u22}_Buymenu`,
            Parent = WorldModel,
            Agent = v149,
            Gloves = {
                WeaponName = v146,
                SkinName = v147
            }
        });
        v151.Parent = WorldModel;
        v151:PivotTo(u52 * CFrame.new(0, -1, 1.2));
        u44 = v150;
        u38 = v151;
        u39 = nil;
        u40 = nil;
        u41 = nil;
        table.clear(u42);
    end;

    local v152 = nil;
    local v153 = nil;
    local v154 = u7 and u7.GetCurrentWeapon and u7.GetCurrentWeapon();

    if v154 and (v154.Name and u36.GetWeaponClass(v154.Name)) then
        v152 = v154.Name;
        v153 = v154.Skin;
    elseif u7 and u7.GetWeaponInventory then
        local WeaponInventory = u7.GetWeaponInventory();

        if WeaponInventory then
            if WeaponInventory[1] and (WeaponInventory[1].Name and u36.GetWeaponClass(WeaponInventory[1].Name)) then
                v152 = WeaponInventory[1].Name;
                v153 = WeaponInventory[1].Skin;
            elseif WeaponInventory[2] and (WeaponInventory[2].Name and u36.GetWeaponClass(WeaponInventory[2].Name)) then
                v152 = WeaponInventory[2].Name;
                v153 = WeaponInventory[2].Skin;
            end;
        end;
    end;

    if not v152 then
        v152 = "AK-47";
        local v155 = u22;

        if u26 and u26[v155] then
            v153 = "Stock";

            for _, v in u26[v155] do
                if v.WeaponName == "AK-47" then
                    v153 = v.SkinName;
                    break;
                end;
            end;
        end;
    end;

    SetBuymenuCharacterWeapon(v152, v153);

    if u39 and not u39.IsPlaying then
        u39:Play(0);
    end;
end;

function u1.Clear() -- Line: 1022
    -- upvalues: u1 (copy), u39 (ref), u53 (copy), u22 (ref), u5 (ref), u58 (copy)
    u1.UpdateHover();

    if u39 then
        u39:Stop(0);
    end;

    for i, v in u53[u22] do
        local v156 = i;

        for i2, _ in v do
            u5:Removes(`{v156}_{i2}_Refund_Enter`, `{v156}_{i2}_Refund_Leave`, `{v156}_{i2}_Refund_Click`, `{v156}_{i2}_Enter`, `{v156}_{i2}_Leave`, (`{v156}_{i2}_Click`));
        end;
    end;

    u5:Removes(
        "BuyTime",
        "Cash",
        "Binds",
        "CanRefundArmor",
        "ArmorValue",
        "HasHelmet",
        "DefuseKit",
        "CanRefundKit"
    );
    u5:Removes("DroppedWeaponsAdded", "DroppedWeaponsRemoved");

    for i in u58 do
        u58[i] = nil;
        u5:Remove((`{i}InBuyZone`));
    end;
end;

function u1.Visible() -- Line: 1048
    -- upvalues: u6 (ref), u28 (ref), u1 (copy), u59 (ref), u14 (ref), u19 (ref), u20 (ref), u60 (ref), GameStats (copy), u25 (ref), u17 (ref), u16 (ref), TweenService (copy), TweenInfo_new_ret3 (copy)
    if u6.Visible then
        local v157 = not u28.Visible;
        local Attribute = GameStats:GetAttribute("BuyTime");

        if v157 and not (u25 and (Attribute < 0 or Attribute > 3)) then
            v157 = false;
        end;

        if u28.Visible ~= v157 then
            u17.SetVisible(not v157);
            u6.Down.Visible = not v157;
            task.spawn(u16.Enabled, not v157);
            u6.Notifications.Visible = not v157;
            u19.SetBuymenuOpen(v157);
            u20.SetBuymenuOpen(v157);

            if u60 and u60.SetBuymenuOpen then
                u60.SetBuymenuOpen(v157);
            end;
        end;

        u28.Visible = v157;
        u14.SetFramePriority("Buymenu", v157);
        u59.HudEdge();

        if not v157 then
            u1.Clear();

            return v157;
        end;

        u28.BackgroundTransparency = 1;
        u28.Main.Position = UDim2.fromScale(0.372, 0.557);
        u28.ViewportFrame.Position = UDim2.fromScale(0.83, 0.5);
        TweenService:Create(u28, TweenInfo_new_ret3, {
            BackgroundTransparency = 0.1
        }):Play();
        TweenService:Create(u28.Main, TweenInfo_new_ret3, {
            Position = UDim2.fromScale(0.372, 0.527)
        }):Play();
        TweenService:Create(u28.ViewportFrame, TweenInfo_new_ret3, {
            Position = UDim2.fromScale(0.8, 0.5)
        }):Play();
        u1.Draw();

        return v157;
    end;

    if u28.Visible then
        u1.Clear();
    end;

    u28.Visible = false;
    u59.HudEdge();
    u14.SetFramePriority("Buymenu");
    u19.SetBuymenuOpen(false);
    u20.SetBuymenuOpen(false);

    if u60 and u60.SetBuymenuOpen then
        u60.SetBuymenuOpen(false);
    end;
end;

function u1.Init(p158) -- Line: 1120
    -- upvalues: u4 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u5 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u36 (ref), u37 (ref), u6 (ref), u1 (copy)
    u4 = p158:GetModule("Gui");
    u7 = p158:GetModule("WeaponController");
    u8 = p158:GetModule("Enums");
    u9 = p158:GetModule("ItemManager");
    u10 = p158:GetModule("SkinManager");
    u11 = p158:GetModule("Network");
    u5 = p158:GetModule("Maid").new();
    u12 = p158:GetModule("WeaponManager");
    u13 = p158:GetModule("RarityColors");
    u14 = p158:GetModule("BindsController");
    u15 = p158:GetModule("GamemodesConfig");
    u36 = p158:GetModule("CharacterModel");
    u37 = p158:GetModule("SoundManager");
    u6 = u4.Handler.HUD;
    u1.new();
    u1.hover();
end;

function u1.Start(p159) -- Line: 1142
    -- upvalues: u2 (ref), u3 (ref), u16 (ref), u4 (ref), u17 (ref), u18 (ref), u19 (ref), u59 (ref), u60 (ref), u20 (ref), u26 (ref), HttpService (copy), LocalPlayer (copy), u28 (ref), u1 (copy), u22 (ref), u25 (ref)
    u2 = workspace:WaitForChild("Debris", 5);
    local v160 = u2 and u2:WaitForChild("DroppedWeapons", 5);
    u3 = v160;
    u16 = u4.GetComponent("Radar");
    u17 = u4.GetComponent("Crosshair");
    u18 = u4.GetComponent("UIColor");
    u19 = u4.GetComponent("Scope");
    u59 = u4.GetComponent("HUD");
    u60 = u4.GetComponent("MobileControls");
    u20 = u4.GetComponent("Chat");
    u26 = HttpService:JSONDecode(LocalPlayer:GetAttribute("WeaponLoadout"));
    LocalPlayer:GetAttributeChangedSignal("WeaponLoadout"):Connect(function() -- Line: 1157
        -- upvalues: u26 (ref), HttpService (ref), LocalPlayer (ref), u28 (ref), u1 (ref)
        u26 = HttpService:JSONDecode(LocalPlayer:GetAttribute("WeaponLoadout"));

        if u28.Visible then
            u1.Draw();
        end;
    end);
    u22 = LocalPlayer:GetAttribute("Team");
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 1166
        -- upvalues: u22 (ref), LocalPlayer (ref), u28 (ref), u1 (ref)
        u22 = LocalPlayer:GetAttribute("Team");

        if u28.Visible then
            u1.Visible();
        end;
    end);
    u25 = LocalPlayer:GetAttribute("InBuyZone");
    LocalPlayer:GetAttributeChangedSignal("InBuyZone"):Connect(function() -- Line: 1175
        -- upvalues: u25 (ref), LocalPlayer (ref), u60 (ref), u28 (ref), u1 (ref)
        u25 = LocalPlayer:GetAttribute("InBuyZone");
        u60.Enabled("Buymenu", u25);

        if u28.Visible then
            u1.Visible();
        end;
    end);
end;

function u1.new() -- Line: 1188
    -- upvalues: u28 (ref), u29 (ref), u31 (ref), u32 (ref), u33 (ref), u35 (ref), u30 (ref), u34 (ref), u6 (ref)
    u28 = Instance.new("Frame");
    u28.Name = "Buymenu";
    u28.AnchorPoint = Vector2.new(0.5, 0.5);
    u28.BackgroundColor3 = Color3.fromRGB(31, 31, 31);
    u28.BackgroundTransparency = 0.1;
    u28.BorderColor3 = Color3.new();
    u28.BorderSizePixel = 0;
    u28.Position = UDim2.fromScale(0.5, 0.5);
    u28.Size = UDim2.fromScale(1, 1);
    local Frame = Instance.new("Frame");
    Frame.Name = "Main";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.372, 0.527);
    Frame.Size = UDim2.fromScale(0.526, 0.791);
    Frame.ZIndex = 5;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Center";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.new();
    Frame2.BackgroundTransparency = 0.35;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 0.386);
    Frame2.Size = UDim2.fromScale(1, 0.68);
    Frame2.ZIndex = 5;
    CenterTitle = Instance.new("Frame");
    CenterTitle.Name = "Title";
    CenterTitle.AnchorPoint = Vector2.new(0.5, 0);
    CenterTitle.BackgroundTransparency = 1;
    CenterTitle.Position = UDim2.fromScale(0.5, 0);
    CenterTitle.Size = UDim2.fromScale(1, 0.06);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Equipment";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.02, 0.5);
    Frame3.Size = UDim2.fromScale(0.15, 1);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = -1;
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.Text = "Equipment";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.2;
    TextLabel.ZIndex = -1;
    TextLabel.Parent = Frame3;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Number";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.LayoutOrder = -1;
    TextLabel2.Position = UDim2.fromScale(0, 0.55);
    TextLabel2.Size = UDim2.fromScale(0.2, 0.8);
    TextLabel2.Text = "1";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.25;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel2.ZIndex = -1;
    TextLabel2.Parent = Frame3;
    Frame3.Parent = CenterTitle;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Pistols";
    Frame4.AnchorPoint = Vector2.new(0, 0.5);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.2, 0.5);
    Frame4.Size = UDim2.fromScale(0.15, 1);
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.LayoutOrder = -1;
    TextLabel3.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel3.Size = UDim2.fromScale(1, 1);
    TextLabel3.Text = "Pistols";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.2;
    TextLabel3.ZIndex = -1;
    TextLabel3.Parent = Frame4;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Number";
    TextLabel4.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel4.LayoutOrder = -1;
    TextLabel4.Position = UDim2.fromScale(0, 0.55);
    TextLabel4.Size = UDim2.fromScale(0.2, 0.8);
    TextLabel4.Text = "2";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.25;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel4.ZIndex = -1;
    TextLabel4.Parent = Frame4;
    Frame4.Parent = CenterTitle;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "MidTier";
    Frame5.AnchorPoint = Vector2.new(0, 0.5);
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0.38, 0.5);
    Frame5.Size = UDim2.fromScale(0.18, 1);
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Title";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel5.LayoutOrder = -1;
    TextLabel5.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel5.Size = UDim2.fromScale(1, 1);
    TextLabel5.Text = "Mid-Tier";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextTransparency = 0.2;
    TextLabel5.ZIndex = -1;
    TextLabel5.Parent = Frame5;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Number";
    TextLabel6.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel6.LayoutOrder = -1;
    TextLabel6.Position = UDim2.fromScale(0, 0.55);
    TextLabel6.Size = UDim2.fromScale(0.166667, 0.8);
    TextLabel6.Text = "3";
    TextLabel6.TextColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextScaled = true;
    TextLabel6.TextTransparency = 0.25;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel6.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel6.ZIndex = -1;
    TextLabel6.Parent = Frame5;
    Frame5.Parent = CenterTitle;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Rifles";
    Frame6.AnchorPoint = Vector2.new(0, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.Position = UDim2.fromScale(0.59, 0.5);
    Frame6.Size = UDim2.fromScale(0.205, 1);
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Title";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel7.LayoutOrder = -1;
    TextLabel7.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel7.Size = UDim2.fromScale(1, 1);
    TextLabel7.Text = "Rifles";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.TextTransparency = 0.2;
    TextLabel7.ZIndex = -1;
    TextLabel7.Parent = Frame6;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "Number";
    TextLabel8.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel8.AutoLocalize = false;
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel8.LayoutOrder = -1;
    TextLabel8.Position = UDim2.fromScale(0, 0.55);
    TextLabel8.Size = UDim2.fromScale(0.142857, 0.8);
    TextLabel8.Text = "4";
    TextLabel8.TextColor3 = Color3.new(1, 1, 1);
    TextLabel8.TextScaled = true;
    TextLabel8.TextTransparency = 0.25;
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel8.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel8.ZIndex = -1;
    TextLabel8.Parent = Frame6;
    Frame6.Parent = CenterTitle;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Grenades";
    Frame7.AnchorPoint = Vector2.new(0, 0.5);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.825, 0.5);
    Frame7.Size = UDim2.fromScale(0.155, 1);
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "Title";
    TextLabel9.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel9.AutoLocalize = false;
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel9.LayoutOrder = -1;
    TextLabel9.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel9.Size = UDim2.fromScale(1, 1);
    TextLabel9.Text = "Grenades";
    TextLabel9.TextColor3 = Color3.new(1, 1, 1);
    TextLabel9.TextScaled = true;
    TextLabel9.TextTransparency = 0.2;
    TextLabel9.ZIndex = -1;
    TextLabel9.Parent = Frame7;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "Number";
    TextLabel10.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel10.AutoLocalize = false;
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel10.LayoutOrder = -1;
    TextLabel10.Position = UDim2.fromScale(0, 0.55);
    TextLabel10.Size = UDim2.fromScale(0.2, 0.8);
    TextLabel10.Text = "5";
    TextLabel10.TextColor3 = Color3.new(1, 1, 1);
    TextLabel10.TextScaled = true;
    TextLabel10.TextTransparency = 0.25;
    TextLabel10.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel10.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel10.ZIndex = -1;
    TextLabel10.Parent = Frame7;
    Frame7.Parent = CenterTitle;
    CenterTitle.Parent = Frame2;
    u29 = Instance.new("Frame");
    u29.Name = "Loadout";
    u29.AnchorPoint = Vector2.new(0.5, 0);
    u29.BackgroundTransparency = 1;
    u29.Position = UDim2.fromScale(0.5, 0.08);
    u29.Size = UDim2.fromScale(1, 0.9);
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Equipment";
    CanvasGroup.AnchorPoint = Vector2.new(0, 0.5);
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(0.02, 0.5);
    CanvasGroup.Size = UDim2.fromScale(0.15, 1);
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(0, 0.02);
    UIGridLayout.CellSize = UDim2.fromScale(1, 0.184);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.Parent = CanvasGroup;
    CanvasGroup.Parent = u29;
    local CanvasGroup2 = Instance.new("CanvasGroup");
    CanvasGroup2.Name = "Pistols";
    CanvasGroup2.AnchorPoint = Vector2.new(0, 0.5);
    CanvasGroup2.BackgroundTransparency = 1;
    CanvasGroup2.Position = UDim2.fromScale(0.2, 0.5);
    CanvasGroup2.Size = UDim2.fromScale(0.15, 1);
    local UIGridLayout2 = Instance.new("UIGridLayout");
    UIGridLayout2.Name = "UIGridLayout";
    UIGridLayout2.CellPadding = UDim2.fromScale(0, 0.02);
    UIGridLayout2.CellSize = UDim2.fromScale(1, 0.184);
    UIGridLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout2.Parent = CanvasGroup2;
    CanvasGroup2.Parent = u29;
    local CanvasGroup3 = Instance.new("CanvasGroup");
    CanvasGroup3.Name = "MidTier";
    CanvasGroup3.AnchorPoint = Vector2.new(0, 0.5);
    CanvasGroup3.BackgroundTransparency = 1;
    CanvasGroup3.Position = UDim2.fromScale(0.38, 0.5);
    CanvasGroup3.Size = UDim2.fromScale(0.18, 1);
    local UIGridLayout3 = Instance.new("UIGridLayout");
    UIGridLayout3.Name = "UIGridLayout";
    UIGridLayout3.CellPadding = UDim2.fromScale(0, 0.02);
    UIGridLayout3.CellSize = UDim2.fromScale(1, 0.184);
    UIGridLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout3.Parent = CanvasGroup3;
    CanvasGroup3.Parent = u29;
    local CanvasGroup4 = Instance.new("CanvasGroup");
    CanvasGroup4.Name = "Rifles";
    CanvasGroup4.AnchorPoint = Vector2.new(0, 0.5);
    CanvasGroup4.BackgroundTransparency = 1;
    CanvasGroup4.Position = UDim2.fromScale(0.59, 0.5);
    CanvasGroup4.Size = UDim2.fromScale(0.205, 1);
    local UIGridLayout4 = Instance.new("UIGridLayout");
    UIGridLayout4.Name = "UIGridLayout";
    UIGridLayout4.CellPadding = UDim2.fromScale(0, 0.02);
    UIGridLayout4.CellSize = UDim2.fromScale(1, 0.184);
    UIGridLayout4.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout4.Parent = CanvasGroup4;
    CanvasGroup4.Parent = u29;
    local CanvasGroup5 = Instance.new("CanvasGroup");
    CanvasGroup5.Name = "Grenades";
    CanvasGroup5.AnchorPoint = Vector2.new(0, 0.5);
    CanvasGroup5.BackgroundTransparency = 1;
    CanvasGroup5.Position = UDim2.fromScale(0.825, 0.5);
    CanvasGroup5.Size = UDim2.fromScale(0.155, 1);
    local UIGridLayout5 = Instance.new("UIGridLayout");
    UIGridLayout5.Name = "UIGridLayout";
    UIGridLayout5.CellPadding = UDim2.fromScale(0, 0.02);
    UIGridLayout5.CellSize = UDim2.fromScale(1, 0.184);
    UIGridLayout5.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout5.Parent = CanvasGroup5;
    CanvasGroup5.Parent = u29;
    u29.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageTransparency = 0.8;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.fromScale(0, 0.00185185);
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel.ZIndex = -1;
    ImageLabel.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Top";
    Frame8.AnchorPoint = Vector2.new(0.5, 1);
    Frame8.BackgroundColor3 = Color3.new();
    Frame8.BackgroundTransparency = 0.35;
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Position = UDim2.fromScale(0.5, 0.042);
    Frame8.Size = UDim2.fromScale(1, 0.041);
    Frame8.ZIndex = 6;
    u31 = Instance.new("TextLabel");
    u31.Name = "Money";
    u31.AnchorPoint = Vector2.new(0, 0.5);
    u31.AutoLocalize = false;
    u31.BackgroundTransparency = 1;
    u31.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    u31.Position = UDim2.fromScale(0.025, 0.5);
    u31.Size = UDim2.fromScale(0.2, 0.85);
    u31.Text = "$52389";
    u31.TextColor3 = Color3.fromRGB(255, 203, 107);
    u31.TextScaled = true;
    u31.TextTransparency = 0.1;
    u31.TextXAlignment = Enum.TextXAlignment.Left;
    u31.ZIndex = 9;
    u31.Parent = Frame8;
    u32 = Instance.new("TextLabel");
    u32.Name = "BuyTime";
    u32.AnchorPoint = Vector2.new(0.5, 0.5);
    u32.AutoLocalize = false;
    u32.BackgroundTransparency = 1;
    u32.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    u32.Position = UDim2.fromScale(0.5, 0.5);
    u32.RichText = true;
    u32.Size = UDim2.fromScale(0.5, 0.8);
    u32.Text = "Buy Time Remaining <font transparency=\"0\" weight=\"Bold\">00:00</font>";
    u32.TextColor3 = Color3.new(1, 1, 1);
    u32.TextScaled = true;
    u32.TextTransparency = 0.5;
    u32.ZIndex = 9;
    u32.Parent = Frame8;
    u33 = Instance.new("TextLabel");
    u33.Name = "NextMin";
    u33.AnchorPoint = Vector2.new(1, 0.5);
    u33.AutoLocalize = false;
    u33.BackgroundTransparency = 1;
    u33.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    u33.Position = UDim2.fromScale(0.99, 0.5);
    u33.RichText = true;
    u33.Size = UDim2.fromScale(0.3, 0.5);
    u33.Text = "Next Round Minimum: $17999";
    u33.TextColor3 = Color3.fromRGB(255, 220, 93);
    u33.TextScaled = true;
    u33.TextXAlignment = Enum.TextXAlignment.Right;
    u33.ZIndex = 9;
    u33.Parent = Frame8;
    Frame8.Parent = Frame;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Dropped";
    Frame9.AnchorPoint = Vector2.new(0.5, 0);
    Frame9.BackgroundColor3 = Color3.new();
    Frame9.BackgroundTransparency = 0.35;
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.Position = UDim2.fromScale(0.5, 0.733333);
    Frame9.Size = UDim2.fromScale(1, 0.266667);
    Frame9.ZIndex = 5;
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "Title";
    TextLabel11.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel11.AutoLocalize = false;
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel11.LayoutOrder = -1;
    TextLabel11.Position = UDim2.fromScale(0.5, 0.48);
    TextLabel11.Size = UDim2.fromScale(0.55, 0.55);
    TextLabel11.Text = "Dropped Weapons";
    TextLabel11.TextColor3 = Color3.new(1, 1, 1);
    TextLabel11.TextScaled = true;
    TextLabel11.TextTransparency = 0.8;
    TextLabel11.ZIndex = -1;
    TextLabel11.Parent = Frame9;
    u35 = Instance.new("Frame");
    u35.Name = "Dropped";
    u35.AnchorPoint = Vector2.new(0.5, 0);
    u35.BackgroundTransparency = 1;
    u35.Position = UDim2.fromScale(0.5, 0.025);
    u35.Size = UDim2.fromScale(1, 0.12);
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Equipment";
    Frame10.AnchorPoint = Vector2.new(0, 0.5);
    Frame10.BackgroundTransparency = 1;
    Frame10.Position = UDim2.fromScale(0.02, 0.5);
    Frame10.Size = UDim2.fromScale(0.15, 1);
    local UIGridLayout6 = Instance.new("UIGridLayout");
    UIGridLayout6.Name = "UIGridLayout";
    UIGridLayout6.CellPadding = UDim2.fromScale(0, 0.125);
    UIGridLayout6.CellSize = UDim2.fromScale(1, 1);
    UIGridLayout6.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout6.Parent = Frame10;
    Frame10.Parent = u35;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Pistols";
    Frame11.AnchorPoint = Vector2.new(0, 0.5);
    Frame11.BackgroundTransparency = 1;
    Frame11.Position = UDim2.fromScale(0.2, 0.5);
    Frame11.Size = UDim2.fromScale(0.15, 1);
    local UIGridLayout7 = Instance.new("UIGridLayout");
    UIGridLayout7.Name = "UIGridLayout";
    UIGridLayout7.CellPadding = UDim2.fromScale(0, 0.125);
    UIGridLayout7.CellSize = UDim2.fromScale(1, 1);
    UIGridLayout7.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout7.Parent = Frame11;
    Frame11.Parent = u35;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "MidTier";
    Frame12.AnchorPoint = Vector2.new(0, 0.5);
    Frame12.BackgroundTransparency = 1;
    Frame12.Position = UDim2.fromScale(0.38, 0.5);
    Frame12.Size = UDim2.fromScale(0.18, 1);
    local UIGridLayout8 = Instance.new("UIGridLayout");
    UIGridLayout8.Name = "UIGridLayout";
    UIGridLayout8.CellPadding = UDim2.fromScale(0, 0.125);
    UIGridLayout8.CellSize = UDim2.fromScale(1, 1);
    UIGridLayout8.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout8.Parent = Frame12;
    Frame12.Parent = u35;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Rifles";
    Frame13.AnchorPoint = Vector2.new(0, 0.5);
    Frame13.BackgroundTransparency = 1;
    Frame13.Position = UDim2.fromScale(0.59, 0.5);
    Frame13.Size = UDim2.fromScale(0.205, 1);
    local UIGridLayout9 = Instance.new("UIGridLayout");
    UIGridLayout9.Name = "UIGridLayout";
    UIGridLayout9.CellPadding = UDim2.fromScale(0, 0.125);
    UIGridLayout9.CellSize = UDim2.fromScale(1, 1);
    UIGridLayout9.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout9.Parent = Frame13;
    Frame13.Parent = u35;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "Grenades";
    Frame14.AnchorPoint = Vector2.new(0, 0.5);
    Frame14.BackgroundTransparency = 1;
    Frame14.Position = UDim2.fromScale(0.825, 0.5);
    Frame14.Size = UDim2.fromScale(0.155, 1);
    local UIGridLayout10 = Instance.new("UIGridLayout");
    UIGridLayout10.Name = "UIGridLayout";
    UIGridLayout10.CellPadding = UDim2.fromScale(0, 0.125);
    UIGridLayout10.CellSize = UDim2.fromScale(1, 1);
    UIGridLayout10.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout10.Parent = Frame14;
    Frame14.Parent = u35;
    u35.Parent = Frame9;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "DOTS";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://91991932054752";
    ImageLabel2.ImageTransparency = 0.8;
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.Position = UDim2.fromScale(0, 0.00185185);
    ImageLabel2.ScaleType = Enum.ScaleType.Tile;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel2.ZIndex = -1;
    ImageLabel2.Parent = Frame9;
    Frame9.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.15;
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint.Parent = Frame;
    Frame.Parent = u28;
    local ViewportFrame = Instance.new("ViewportFrame");
    ViewportFrame.Name = "ViewportFrame";
    ViewportFrame.Ambient = Color3.new();
    ViewportFrame.LightColor = Color3.new(1, 1, 1);
    ViewportFrame.LightDirection = Vector3.new(0, 0, -1);
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    ViewportFrame.BackgroundTransparency = 1;
    ViewportFrame.Position = UDim2.fromScale(0.8, 0.5);
    ViewportFrame.Size = UDim2.fromScale(0.6, 0.9);
    ViewportFrame.ZIndex = 4;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.AspectRatio = 0.8;
    UIAspectRatioConstraint2.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint2.Parent = ViewportFrame;
    u30 = Instance.new("CanvasGroup");
    u30.Name = "InfoFrame";
    u30.AnchorPoint = Vector2.new(0.5, 0.5);
    u30.BackgroundColor3 = Color3.new();
    u30.BackgroundTransparency = 0.35;
    u30.BorderColor3 = Color3.new();
    u30.BorderSizePixel = 0;
    u30.Position = UDim2.fromScale(0.5, 0.6);
    u30.Size = UDim2.fromScale(0.5, 0.15);
    u30.GroupTransparency = 1;
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = "ItemName";
    TextLabel12.AutoLocalize = false;
    TextLabel12.BackgroundTransparency = 1;
    TextLabel12.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel12.LayoutOrder = -1;
    TextLabel12.Position = UDim2.fromScale(0.025, 0.05);
    TextLabel12.Size = UDim2.fromScale(0.5, 0.2);
    TextLabel12.Text = "Standard Weapon";
    TextLabel12.TextColor3 = Color3.new(1, 1, 1);
    TextLabel12.TextScaled = true;
    TextLabel12.TextTransparency = 0.05;
    TextLabel12.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel12.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel12.ZIndex = 2;
    TextLabel12.Parent = u30;
    local TextLabel13 = Instance.new("TextLabel");
    TextLabel13.Name = "Description";
    TextLabel13.AnchorPoint = Vector2.new(0, 1);
    TextLabel13.AutoLocalize = false;
    TextLabel13.BackgroundTransparency = 1;
    TextLabel13.FontFace = Font.new("rbxassetid://12187375422");
    TextLabel13.LayoutOrder = -1;
    TextLabel13.Position = UDim2.fromScale(0.0499996, 0.95);
    TextLabel13.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel13.Text = "Standard issue weapon equipment.";
    TextLabel13.TextColor3 = Color3.new(1, 1, 1);
    TextLabel13.TextScaled = true;
    TextLabel13.TextTransparency = 0.2;
    TextLabel13.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel13.ZIndex = 2;
    TextLabel13.Parent = u30;
    u30.Parent = ViewportFrame;
    u34 = Instance.new("CanvasGroup");
    u34.Name = "YellowFrame";
    u34.AnchorPoint = Vector2.new(0.5, 0.5);
    u34.BackgroundColor3 = Color3.fromRGB(200, 179, 16);
    u34.BorderColor3 = Color3.new();
    u34.BorderSizePixel = 0;
    u34.Position = UDim2.fromScale(0.5, 0.5);
    u34.Size = UDim2.fromScale(0.5, 0.035);
    u34.GroupTransparency = 1;
    u34.Visible = true;
    local TextLabel14 = Instance.new("TextLabel");
    TextLabel14.Name = "Title";
    TextLabel14.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel14.AutoLocalize = false;
    TextLabel14.BackgroundTransparency = 1;
    TextLabel14.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel14.LayoutOrder = -1;
    TextLabel14.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel14.Size = UDim2.fromScale(0.9, 0.85);
    TextLabel14.Text = "Need $1000 more";
    TextLabel14.TextColor3 = Color3.new(1, 1, 1);
    TextLabel14.TextScaled = true;
    TextLabel14.ZIndex = 2;
    TextLabel14.Parent = u34;
    u34.Parent = ViewportFrame;
    ViewportFrame.Parent = u28;
    u28.Visible = false;
    u28.Parent = u6;
end;

function u1.dropItem() -- Line: 1900
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "DropItem";
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.fromRGB(57, 56, 57);
    ImageButton.ImageTransparency = 1;
    ImageButton.Size = UDim2.fromOffset(100, 100);
    ImageButton.Visible = false;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.2, 0);
    UICorner.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "ItemName";
    TextLabel.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = -1;
    TextLabel.Position = UDim2.fromScale(0.95, 0.5);
    TextLabel.Size = UDim2.fromScale(0.65, 0.75);
    TextLabel.Text = "Desert Eagle";
    TextLabel.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.2;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.ZIndex = 2;
    TextLabel.Parent = ImageButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ItemImage";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://100429874437897";
    ImageLabel.ImageColor3 = Color3.fromRGB(255, 203, 107);
    ImageLabel.ImageTransparency = 0.2;
    ImageLabel.Position = UDim2.fromScale(0, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.35, 1);
    ImageLabel.TileSize = UDim2.fromScale(2, 1);
    ImageLabel.ZIndex = 2;
    ImageLabel.Parent = ImageButton;

    return ImageButton;
end;

function u1.dot(p161) -- Line: 1954
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Dot";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://6755657357";
    ImageLabel.ImageColor3 = Color3.fromRGB(65, 195, 255);
    ImageLabel.ImageTransparency = 0.4;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Visible = false;
    ImageLabel.Parent = p161;

    return ImageLabel;
end;

function u1.buyItem() -- Line: 1973
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "BuyItem";
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.fromRGB(31, 31, 31);
    ImageButton.BackgroundTransparency = 0.4;
    ImageButton.ImageTransparency = 1;
    ImageButton.Size = UDim2.fromOffset(100, 100);
    ImageButton.Visible = false;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Number";
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = -1;
    TextLabel.Position = UDim2.fromScale(0.02, 0.05);
    TextLabel.Size = UDim2.fromScale(0.3, 0.3);
    TextLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel.Text = "1";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.5;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.ZIndex = 2;
    TextLabel.Parent = ImageButton;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.08, 0);
    UICorner.Parent = ImageButton;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "ItemName";
    TextLabel2.AnchorPoint = Vector2.new(1, 0);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.LayoutOrder = -1;
    TextLabel2.Position = UDim2.fromScale(0.95, 0.05);
    TextLabel2.Size = UDim2.fromScale(0.5, 0.2);
    TextLabel2.Text = "Standard Weapon";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.75;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel2.ZIndex = 2;
    TextLabel2.Parent = ImageButton;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "ItemPrice";
    TextLabel3.AnchorPoint = Vector2.new(1, 1);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.LayoutOrder = -1;
    TextLabel3.Position = UDim2.fromScale(0.95, 0.95);
    TextLabel3.Size = UDim2.fromScale(0.5, 0.2);
    TextLabel3.Text = "$8866";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.75;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel3.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel3.ZIndex = 2;
    TextLabel3.Parent = ImageButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ItemImage";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://100429874437897";
    ImageLabel.ImageTransparency = 0.75;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel.TileSize = UDim2.fromScale(2, 1);
    ImageLabel.ZIndex = 2;
    ImageLabel.Parent = ImageButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.975);
    Frame.Size = UDim2.fromScale(1, 0.05);
    Frame.ZIndex = 2;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.02, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame;
    Frame.Parent = ImageButton;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Refund";
    ImageButton2.AnchorPoint = Vector2.new(0, 1);
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://122550283505366";
    ImageButton2.ImageTransparency = 0.4;
    ImageButton2.Position = UDim2.fromScale(0.06, 0.94);
    ImageButton2.ScaleType = Enum.ScaleType.Fit;
    ImageButton2.Size = UDim2.fromScale(0.225, 0.225);
    ImageButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton2.ZIndex = 2;
    ImageButton2.Parent = ImageButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner;
    UIStroke.Thickness = 1.25;
    UIStroke.Transparency = 0.2;
    UIStroke.Parent = ImageButton;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Blur";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://6430908053";
    ImageLabel2.ImageTransparency = 0.9;
    ImageLabel2.Interactable = false;
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Crop;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.ZIndex = -1;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = ImageLabel2;
    ImageLabel2.Parent = ImageButton;

    return ImageButton;
end;

function u1.hover() -- Line: 2130
    -- upvalues: u27 (ref), u6 (ref)
    u27 = Instance.new("CanvasGroup");
    u27.Name = "HoverUI";
    u27.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    u27.Position = UDim2.fromScale(0.909802, 0.05539);
    u27.Size = UDim2.fromScale(0.0542232, 0.0413847);
    u27.GroupTransparency = 1;
    u27.ZIndex = 100;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 5);
    UICorner.Parent = u27;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.new(1, -10, 1, -20);
    TextLabel.Text = "Home";
    TextLabel.TextColor3 = Color3.fromRGB(223, 223, 223);
    TextLabel.TextScaled = true;
    TextLabel.Parent = u27;
    u27.Parent = u6;
end;

return u1;