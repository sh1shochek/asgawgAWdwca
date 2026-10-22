-- ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Inventory.Upgrader
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Inventory.Upgrader
-- Decompile time: 56.98 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
game:GetService("HttpService");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local PolicyService = game:GetService("PolicyService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
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

if RunService:IsStudio() then
    u15 = {
        AllowedExternalLinkReferences = {},
        AreAdsAllowed = true,
        ArePaidRandomItemsRestricted = false,
        IsContentSharingAllowed = true,
        IsEligibleToPurchaseCommerceProduct = true,
        IsEligibleToPurchaseSubscription = true,
        IsPaidItemTradingAllowed = true,
        IsPhotoToAvatarAllowed = true,
        IsSubjectToChinaPolicies = true
    };
else
    task.spawn(function() -- Line: 35
        -- upvalues: PolicyService (copy), LocalPlayer (copy), u15 (ref)
        local success, result = pcall(function() -- Line: 36
            -- upvalues: PolicyService (ref), LocalPlayer (ref)
            return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer);
        end);
        u15 = success and result and result or {
            AllowedExternalLinkReferences = {},
            AreAdsAllowed = false,
            ArePaidRandomItemsRestricted = true,
            IsContentSharingAllowed = false,
            IsEligibleToPurchaseCommerceProduct = false,
            IsEligibleToPurchaseSubscription = false,
            IsPaidItemTradingAllowed = false,
            IsPhotoToAvatarAllowed = false,
            IsSubjectToChinaPolicies = false
        };
    end);
end;

local function GetPolicyInfo() -- Line: 54
    -- upvalues: u15 (ref), PolicyService (copy), LocalPlayer (copy)
    if not u15 then
        local success, result = pcall(function() -- Line: 56
            -- upvalues: PolicyService (ref), LocalPlayer (ref)
            return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer);
        end);
        u15 = success and result and result or {
            AllowedExternalLinkReferences = {},
            AreAdsAllowed = false,
            ArePaidRandomItemsRestricted = true,
            IsContentSharingAllowed = false,
            IsEligibleToPurchaseCommerceProduct = false,
            IsEligibleToPurchaseSubscription = false,
            IsPaidItemTradingAllowed = false,
            IsPhotoToAvatarAllowed = false,
            IsSubjectToChinaPolicies = false
        };
    end;

    return u15;
end;

local u16 = false;
local u17 = 0;
local u18 = {};
local u19 = 0;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = {
    Inventory = false,
    Exchange = false
};
local u26 = {
    Inventory = "Rarity",
    Exchange = "Rarity"
};
local u27 = {
    Inventory = {
        Equipment = {}
    },
    Exchange = {
        Equipment = {}
    }
};
local u28 = {
    ["2x"] = 50,
    ["4x"] = 25,
    ["8x"] = 12.5,
    ["35percents"] = 35,
    ["50percents"] = 50,
    ["60percents"] = 60
};
local u29 = false;
local u30 = nil;

local function GetAvailableSkinId(p31, p32, p33) -- Line: 123
    -- upvalues: u12 (ref)
    if not u12 then
        return p33;
    end;

    local v34 = u12.Get();

    if not (v34 and v34.Equipment) then
        return p33;
    end;

    local v35 = v34.Equipment[p31];

    if not v35 then
        return p33;
    end;

    local v36 = v35[p32];

    if not v36 then
        return p33;
    end;

    if p33 and (typeof(p33) == "string" and v36[p33]) then
        return p33;
    end;

    local v37 = next(v36);

    if v37 and typeof(v37) == "string" then
        return v37;
    end;

    return p33;
end;

local function spinToValueMath(p38, p39) -- Line: 153
    -- upvalues: u2 (ref), RunService (copy), u10 (ref)
    local v40 = p38 / 100 * 360 + 180 - 180;

    if v40 <= 0 then
        v40 = v40 + 360;
    end;

    local u41 = 180 + p39 * 360 + v40;
    local u42 = p39 + math.random(-10, 10) / 10;
    local os_clock_ret = os.clock();
    local u43 = 0;
    u2:Add("Spin", RunService.RenderStepped:Connect(function() -- Line: 169
        -- upvalues: os_clock_ret (copy), u42 (copy), u41 (copy), u43 (ref), u10 (ref), u2 (ref)
        local v44 = (os.clock() - os_clock_ret) / u42;
        local math_clamp_ret = math.clamp(v44, 0, 1);
        local v45 = 1 - math.pow(1 - math_clamp_ret, 4);
        local v46 = 180 + (u41 - 180) * v45;
        Pointer.Rotation = v46;
        local math_rad_ret = math.rad(v46);
        local v47 = math.sin(math_rad_ret) * 0.41 + 0.5;
        local v48 = 0.5 - math.cos(math_rad_ret) * 0.41;
        Pointer.Position = UDim2.fromScale(v47, v48);

        if v46 - u43 >= 45 then
            u10.Play("UI.upgrader_scroll");
            u43 = v46;
        end;

        if math_clamp_ret >= 1 then
            u2:Remove("Spin");
        end;
    end));

    return u42;
end;

function u1.Draw() -- Line: 201
    -- upvalues: u26 (copy), u30 (ref), u4 (ref), u27 (copy), u18 (ref), TweenService (copy), u29 (ref), u1 (copy), u2 (ref), u28 (copy), u25 (copy), u5 (ref), u6 (ref), u19 (ref), GetAvailableSkinId (copy), u10 (ref), u16 (ref), u17 (ref), u13 (ref), u8 (ref), u24 (ref), u22 (ref), GetPolicyInfo (copy), u23 (ref)
    for i in u26 do
        u30.NewDropDown(false, { "Newest", "Quality", "Alphabetical", "Type", "Equipped", "Highest Value", "Lowest Value" }, "Lowest Value", "Lowest Value", function(p49) -- Line: 263
            -- upvalues: i (copy), u4 (ref), u27 (ref), u26 (ref)
            if i == "Inventory" then
                u4.SetSort(p49);
            else
                u4.Sort(u27[i], p49);
            end;

            u26[i] = p49;
        end, i == "Inventory" and DropButtonInventory or DropButtonExchange);
        u26[i] = "Lowest Value";
    end;

    for i, v in u18 do
        local Item = v.Item;
        local Remove = Item:FindFirstChild("Remove");
        Remove.MouseEnter:Connect(function() -- Line: 279
            -- upvalues: TweenService (ref), Remove (copy)
            TweenService:Create(Remove, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(76, 76, 90)
            }):Play();
        end);
        Remove.MouseLeave:Connect(function() -- Line: 283
            -- upvalues: TweenService (ref), Remove (copy)
            TweenService:Create(Remove, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(52, 52, 62)
            }):Play();
        end);
        Remove.MouseButton1Click:Connect(function() -- Line: 287
            -- upvalues: u29 (ref), u1 (ref), i (copy)
            if u29 then
                return;
            end;

            u1.RemoveItem(i);
        end);
        v.Title.Visible = true;
        v.WeaponBG.Visible = true;
        v.ShineBG.Visible = true;
        Item.Visible = false;
    end;

    for _, v in {
        Min = MinTextBox,
        Max = MaxTextBox
    } do
        local u50 = 0;
        v.Focused:Connect(function() -- Line: 304
            -- upvalues: u50 (ref), v (copy), u2 (ref)
            u50 = tonumber(v.Text) or 0;
            u2:Add("BoxSignal", v:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 307
                -- upvalues: v (ref)
                v.Text = v.Text:gsub("[^%d%.%-]", ""):match("^%-?%d*%.?%d?");
            end));
        end);
        v.FocusLost:Connect(function() -- Line: 314
            -- upvalues: v (copy), u50 (ref), u1 (ref), u2 (ref)
            local v51 = tonumber(v.Text);

            if v.Text == "" or (not v51 or v51 < 0) then
                v.Text = tostring(u50);
            end;

            u1.UpdateExchange();
            u2:Remove("BoxSignal");
        end);
    end;

    for i, v in u28 do
        local u52 = MultipliersFrame[i];
        u52.MouseEnter:Connect(function() -- Line: 330
            -- upvalues: TweenService (ref), u52 (copy)
            TweenService:Create(u52, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(76, 76, 90)
            }):Play();
        end);
        u52.MouseLeave:Connect(function() -- Line: 334
            -- upvalues: TweenService (ref), u52 (copy)
            TweenService:Create(u52, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(52, 52, 62)
            }):Play();
        end);
        u52.MouseButton1Click:Connect(function() -- Line: 338
            -- upvalues: u29 (ref), u25 (ref), v (copy), u27 (ref), u5 (ref), u6 (ref), u1 (ref)
            if u29 then
                return;
            end;

            local Inventory = u25.Inventory;

            if not Inventory then
                return;
            end;

            local v53 = Inventory.Value / (v / 100);
            local v54 = (1 / 0);
            local v55 = nil;

            for _, v2 in u27.Exchange.Equipment do
                local Attribute = v2:GetAttribute("WeaponName");
                local Attribute2 = v2:GetAttribute("SkinName");
                local v56 = u5.GetItem(Attribute, Attribute2) or u6.GetWeaponSkin(Attribute, Attribute2);

                if v56 and v56.Value then
                    local Value = v56.Value;
                    local math_abs_ret = math.abs(Value - v53);

                    if math_abs_ret < v54 then
                        v54 = math_abs_ret;
                        v55 = {
                            WeaponName = Attribute,
                            SkinName = Attribute2,
                            Value = Value
                        };
                    end;
                end;
            end;

            if v55 then
                u1.AddItem("Exchange", v55.WeaponName, v55.SkinName);
            end;
        end);
    end;

    Upgrade.MouseEnter:Connect(function() -- Line: 379
        -- upvalues: u29 (ref), u25 (ref), TweenService (ref)
        if u29 then
            return;
        end;

        local Inventory = u25.Inventory;
        local Exchange = u25.Exchange;

        if not (Inventory and Exchange) then
            return;
        end;

        if Inventory.Value > Exchange.Value then
            return;
        end;

        TweenService:Create(Upgrade, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(244, 231, 55)
        }):Play();
    end);
    Upgrade.MouseLeave:Connect(function() -- Line: 397
        -- upvalues: u29 (ref), u25 (ref), TweenService (ref)
        if u29 then
            return;
        end;

        local Inventory = u25.Inventory;
        local Exchange = u25.Exchange;

        if not (Inventory and Exchange) then
            return;
        end;

        if Inventory.Value > Exchange.Value then
            return;
        end;

        TweenService:Create(Upgrade, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(216, 205, 49)
        }):Play();
    end);
    Upgrade.MouseButton1Click:Connect(function() -- Line: 415
        -- upvalues: u29 (ref), u19 (ref), u1 (ref), u25 (ref), GetAvailableSkinId (ref), u10 (ref), TweenService (ref), u16 (ref), u17 (ref), u13 (ref), u8 (ref)
        if u29 then
            return;
        end;

        if u19 <= 0 then
            u1.UpdateScrollsUI();

            return;
        end;

        local Inventory = u25.Inventory;
        local Exchange = u25.Exchange;

        if not (Inventory and Exchange) then
            return;
        end;

        if Inventory.Value > Exchange.Value then
            return;
        end;

        local v57 = GetAvailableSkinId(Inventory.WeaponName, Inventory.SkinName, Inventory.SkinId);

        if not v57 or typeof(v57) ~= "string" then
            warn("[Upgrader] No valid SkinId found for selected item");
            u1.RemoveItem("Inventory");

            return;
        end;

        Inventory.SkinId = v57;
        u10.Play("UI.upgrader_open");
        u29 = true;
        Upgrade.Title.Text = "FUSING";
        TweenService:Create(Upgrade.Frame, TweenInfo.new(1, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Color3.fromRGB(144, 137, 33)
        }):Play();
        TweenService:Create(Upgrade.Title, TweenInfo.new(1, Enum.EasingStyle.Quart), {
            TextTransparency = 0.5
        }):Play();
        u16 = true;
        u17 = u17 + 1;
        local u58 = u17;

        if u13 and u13.SetPaused then
            u13.SetPaused("Credits", true);
        end;

        task.delay(15, function() -- Line: 462
            -- upvalues: u16 (ref), u17 (ref), u58 (copy), u13 (ref), u29 (ref)
            if u16 and u17 == u58 then
                u16 = false;

                if u13 and u13.SetPaused then
                    u13.SetPaused("Credits", false);
                end;

                u29 = false;
                Upgrade.Title.Text = "FUSE";
            end;
        end);
        u8.Gui.Upgrade.Fire({
            Inventory = {
                WeaponName = Inventory.WeaponName,
                SkinName = Inventory.SkinName,
                SkinId = Inventory.SkinId
            },
            Exchange = {
                WeaponName = Exchange.WeaponName,
                SkinName = Exchange.SkinName
            }
        });
    end);
    Pointer.AnchorPoint = Vector2.new(0.5, 0.5);
    Pointer.Position = UDim2.fromScale(0.5, 0.91);
    Pointer.Rotation = 180;
    u1.UpdateValue();
    local v59 = u24.new();
    v59:DrawCredits(u22, 60, function() -- Line: 495
        -- upvalues: u29 (ref), u8 (ref)
        if u29 then
            return;
        end;

        u8.Gui.BuyFuserScroll.Fire({
            Amount = 1
        });
    end);
    local v60 = GetPolicyInfo();

    if v60 and v60.ArePaidRandomItemsRestricted then
        u23.Visible = false;
        u22.Position = UDim2.fromScale(0.5, 0.952);
    else
        u23.Visible = true;
        u22.Position = UDim2.fromScale(0.05, 0.952);
        v59:DrawRobux(u23, 3714855547);
    end;

    u1.UpdateScrollsUI();
end;

function u1.AddItems(p61) -- Line: 514
    -- upvalues: u27 (copy), u5 (ref), u6 (ref), u29 (ref), u1 (copy), u2 (ref), u4 (ref), u26 (copy)
    for _, v in p61 do
        local Attribute = v:GetAttribute("Id");

        if Attribute and not u27.Inventory.Equipment[Attribute] then
            local Attribute2 = v:GetAttribute("WeaponName");
            local Attribute3 = v:GetAttribute("SkinName");

            if Attribute2 and (Attribute3 and Attribute2 ~= "Stickers") then
                local u62 = u5.GetItem(Attribute2, Attribute3) or u6.GetWeaponSkin(Attribute2, Attribute3);

                if u62 and u62.Value then
                    task.defer(function() -- Line: 536
                        -- upvalues: u29 (ref), v (copy), u1 (ref), u62 (copy), u2 (ref), Attribute (copy), Attribute2 (copy), Attribute3 (copy), u27 (ref)
                        if u29 then
                            repeat
                                v.Visible = false;
                                task.wait(0.1);
                            until not u29;

                            v.Visible = true;
                        end;

                        u1.itemSetup(v, u62.Value);
                        u2:Add(`{Attribute}_MouseButton1Click`, v.Icon.MouseButton1Click:Connect(function() -- Line: 547
                            -- upvalues: v (ref), Attribute2 (ref), Attribute3 (ref), u1 (ref)
                            local Attribute4 = v:GetAttribute("SkinId");
                            local v63 = v:GetAttribute("WeaponName") or Attribute2;
                            local v64 = v:GetAttribute("SkinName") or Attribute3;
                            u1.AddItem("Inventory", v63, v64, Attribute4);
                        end));
                        u27.Inventory.Equipment[Attribute] = v;

                        if v:FindFirstChild("EquipTeam") then
                            v.EquipTeam.Visible = false;
                        end;
                    end);
                end;
            end;
        end;
    end;

    u4.SetSort(u26.Inventory);
    u1.DrawExchange();
end;

function u1.RemoveItems(p65) -- Line: 566
    -- upvalues: u16 (ref), u13 (ref), u27 (copy), u2 (ref), u14 (ref), u1 (copy)
    if u16 or u13 and (u13.IsPaused and u13.IsPaused("Credits")) then
        u16 = false;

        if u13 and u13.SetPaused then
            u13.SetPaused("Credits", false);
        end;
    end;

    for _, v in p65 do
        local Attribute = v:GetAttribute("Id");

        if Attribute and u27.Inventory.Equipment[Attribute] then
            if v:FindFirstChild("Credits") then
                v.Credits:Destroy();
            end;

            u2:Remove((`{Attribute}_MouseButton1Click`));
            u27.Inventory.Equipment[Attribute] = nil;

            if v:FindFirstChild("EquipTeam") then
                v.EquipTeam.Visible = true;
            end;

            if #u14:GetChildren() < 2 then
                u1.ClearExchange();
            end;
        end;
    end;
end;

function u1.Animation(u66) -- Line: 597
    -- upvalues: u25 (copy), u7 (ref), spinToValueMath (copy), u16 (ref), u13 (ref), u29 (ref), u10 (ref), u1 (copy)
    local Inventory = u25.Inventory;
    local Exchange = u25.Exchange;
    local u67 = Inventory and Inventory.Value or 1;
    local v68 = u7.CalculateChance(u67, Exchange and Exchange.Value or 1);
    local v69;

    if u66 then
        v69 = math.random(-v68 / 2, v68 / 2);
    else
        local math_clamp_ret = math.clamp(v68 + 4, 1, 100);

        if math.random(1, 2) == 1 then
            v69 = math.random(-50, -math_clamp_ret / 2) - 0.5;
        else
            v69 = math.random(math_clamp_ret / 2, 50) + 0.5;
        end;
    end;

    local v70 = spinToValueMath(v69, math.random(3, 6));
    task.delay(v70, function() -- Line: 620
        -- upvalues: u16 (ref), u13 (ref), u66 (copy), u29 (ref), u10 (ref), u1 (ref), u7 (ref), u67 (copy)
        Upgrade.Title.Text = "FUSE";
        u16 = false;

        if u13 and u13.SetPaused then
            u13.SetPaused("Credits", false);
        end;

        if u66 then
            u29 = false;
            u10.Play("UI.upgrader_win");
            u1.RemoveItem("Inventory");

            return;
        end;

        local v71 = u7.CalculateCashback(u67);
        CenterTitle.Text = "FAIL";
        UnderCenterTitle.Text = `Loss Bonus: {v71} Credits`;
        CenterTitle.UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 101, 101)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
        UnderCenterTitle.UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 101, 101)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
        task.delay(2, function() -- Line: 649
            -- upvalues: u29 (ref), u1 (ref)
            u29 = false;
            CenterTitle.UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 191, 80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(167, 255, 108)) });
            UnderCenterTitle.UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(167, 255, 108)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(167, 255, 108)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 224, 102)) });
            u1.RemoveItem("Inventory");
        end);
    end);
end;

function u1.UpdateValue() -- Line: 668
    -- upvalues: u25 (copy), u7 (ref), u21 (ref), TweenService (copy)
    local v72 = 50;
    local v73 = 0;
    local v74 = 50;
    local Inventory = u25.Inventory;
    local Exchange = u25.Exchange;
    local v75 = nil;
    local v76 = nil;

    if Inventory and Exchange then
        v75 = Inventory.Value;
        v76 = Exchange.Value;
        v72 = u7.CalculateChance(v75, v76);
        v73 = u7.CalculateCashback(v75);
        local v77 = math.floor((100 - v72) * 100) / 100;
        v74 = math.clamp(v77, 0, 100);
    elseif Inventory then
        v75 = Inventory.Value;
        v73 = u7.CalculateCashback(v75);
        v74 = 50;
    end;

    local math_clamp_ret = math.clamp(v72 * 1.8, 0, 360);
    local math_floor_ret = math.floor(math_clamp_ret);
    CenterTitle.Text = `{v72}%`;

    if u21 then
        u21.Text = `{v73} Kredits cashback on lose - {v74}%`;
    end;

    if v72 < 15 then
        UnderCenterTitle.Text = "very low chance";
    elseif v72 < 25 then
        UnderCenterTitle.Text = "low chance";
    elseif v72 < 45 then
        UnderCenterTitle.Text = "medium chance";
    elseif v72 < 60 then
        UnderCenterTitle.Text = "high chance";
    else
        UnderCenterTitle.Text = "very high chance";
    end;

    for _, v in { Progress, Progress.Center.Progress } do
        local Frame = v.Right.Frame;
        TweenService:Create(v.Left.Frame.UIGradient, TweenInfo.new(1, Enum.EasingStyle.Quart), {
            Rotation = math_floor_ret
        }):Play();
        TweenService:Create(Frame.UIGradient, TweenInfo.new(1, Enum.EasingStyle.Quart), {
            Rotation = 180 - math_floor_ret
        }):Play();
    end;

    if v75 and (v76 and v75 <= v76) then
        TweenService:Create(Upgrade.Frame, TweenInfo.new(1, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Color3.fromRGB(216, 205, 49)
        }):Play();
        TweenService:Create(Upgrade.Title, TweenInfo.new(1, Enum.EasingStyle.Quart), {
            TextTransparency = 0
        }):Play();

        return;
    end;

    TweenService:Create(Upgrade.Frame, TweenInfo.new(1, Enum.EasingStyle.Quart), {
        BackgroundColor3 = Color3.fromRGB(144, 137, 33)
    }):Play();
    TweenService:Create(Upgrade.Title, TweenInfo.new(1, Enum.EasingStyle.Quart), {
        TextTransparency = 0.5
    }):Play();
end;

function u1.DrawExchange() -- Line: 725
    -- upvalues: u6 (ref), u27 (copy), u1 (copy), u5 (ref), u4 (ref), u26 (copy)
    if #ExchangeList:GetChildren() > 2 then
        return;
    end;

    for i, v in u6.GetAllSkins() do
        local v78 = i;

        for i2, v2 in v do
            if v2.Value then
                u27.Exchange.Equipment[`{v78}{i2}`] = u1.CreateItem(ExchangeList, v78, i2);
            end;
        end;
    end;

    for i, v in u5.GetGloveCategories() do
        local v79 = i;

        for i2, v2 in v do
            if v2.Value then
                u27.Exchange.Equipment[`{v79}{i2}`] = u1.CreateItem(ExchangeList, v79, i2);
            end;
        end;
    end;

    u4.SetSort(u26.Inventory);
    u4.Sort(u27.Exchange, u26.Exchange);
    u1.UpdateExchange();
end;

function u1.UpdateExchange() -- Line: 756
    -- upvalues: u27 (copy), u5 (ref), u6 (ref)
    local v80 = tonumber(MaxTextBox.Text) or 10000;
    local v81 = tonumber(MinTextBox.Text) or 0;

    for _, v in u27.Exchange.Equipment do
        local Attribute = v:GetAttribute("WeaponName");
        local Attribute2 = v:GetAttribute("SkinName");
        local v82 = u5.GetItem(Attribute, Attribute2) or u6.GetWeaponSkin(Attribute, Attribute2);

        if v82 and v82.Value then
            local Value = v82.Value;

            if v80 <= Value then
                v.Visible = false;
            elseif Value <= v81 then
                v.Visible = false;
            else
                v.Visible = true;
            end;
        else
            v.Visible = false;
        end;
    end;
end;

function u1.AddItem(p83, p84, p85, p86) -- Line: 781
    -- upvalues: u29 (ref), u18 (ref), u5 (ref), u6 (ref), GetAvailableSkinId (copy), u9 (ref), u25 (copy), u1 (copy)
    if u29 then
        return;
    end;

    local v87 = u18[p83];

    if not (v87 and v87:FindFirstChild("Item")) then
        return;
    end;

    local Item = v87.Item;
    local v88 = u5.GetCategory(p84) or WeaponManager.Get(p84);
    local v89 = u5.GetItem(p84, p85) or u6.GetWeaponSkin(p84, p85);

    if not v89 then
        return;
    end;

    if p83 == "Inventory" then
        p86 = GetAvailableSkinId(p84, p85, p86);

        if not p86 or typeof(p86) ~= "string" then
            warn((`[Upgrader] Could not find valid SkinId for {p84} {p85}`));

            return;
        end;
    end;

    local v90 = u9[v89.Rarity] or Color3.fromRGB(188, 203, 219);
    local v91;

    if v88 then
        v91 = v88.DisplayName or p84;
    else
        v91 = p84;
    end;

    Item.WeaponName.Text = v91;
    Item.SkinName.Text = v89.DisplayName or p85;
    Item.UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v90), ColorSequenceKeypoint.new(1, v90) });
    Item.Credits.Title.Text = v89.Value or 0;
    Item.Icon.Image = `rbxassetid://{v89.Thumbnail}` or "rbxassetid://100429874437897";
    Item.Visible = true;
    v87.Title.Visible = false;
    v87.WeaponBG.Visible = false;
    v87.ShineBG.Visible = false;
    u25[p83] = {
        WeaponName = p84,
        SkinName = p85,
        SkinId = p86,
        Value = v89.Value or 0
    };
    u1.UpdateValue();
end;

function u1.RemoveItem(p92) -- Line: 839
    -- upvalues: u25 (copy), u18 (ref), u29 (ref), u1 (copy)
    if not u25[p92] then
        return;
    end;

    local v93 = u18[p92];
    v93.Title.Visible = true;
    v93.WeaponBG.Visible = true;
    v93.ShineBG.Visible = true;
    v93.Item.Visible = false;
    u25[p92] = false;

    if not u29 then
        u1.UpdateValue();
    end;
end;

function u1.CreateItem(p94: userdata, u95: any, u96: any) -- Line: 858
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u1 (copy), u9 (ref), u2 (ref), u10 (ref), TweenService (copy)
    local u97 = u4.newItem();
    local v98 = u5.GetCategory(u95) or WeaponManager.Get(u95);
    local v99 = u5.GetItem(u95, u96) or u6.GetWeaponSkin(u95, u96);
    local v100 = v98.DisplayName or u95;
    local v101 = v99.DisplayName or u96;
    local ModelName = v99.ModelName;
    local GuiInformation = v98.GuiInformation;

    if not v99.Description then
        local _ = GuiInformation.Description;
    end;

    local Thumbnail = v99.Thumbnail;
    local Rarity = v99.Rarity;
    u1.itemSetup(u97, v99.Value);
    u97.Name = `{ModelName}_{v100}_{v101}_{Rarity}`;
    u97.ItemInfo.Text = v100;
    u97.SkinInfo.Text = v101;
    u97.Amount.Visible = false;
    u97.Locked.Visible = false;
    u97.Rarity.BackgroundColor3 = u9[Rarity];
    u97.Icon.Image = `rbxassetid://{Thumbnail}` or "rbxassetid://100429874437897";
    u97.Parent = p94;
    u97:SetAttribute("WeaponName", u95);
    u97:SetAttribute("SkinName", u96);
    u97:SetAttribute("Rarity", Rarity);
    u97:SetAttribute("Model", ModelName);
    u97:SetAttribute("Value", v99.Value or 0);
    u97:SetAttribute("Tab", GuiInformation.Tab);
    u97:SetAttribute("ALLTab", GuiInformation.ALLTab);
    u97:SetAttribute("Date", 1);
    u97:SetAttribute("Equipped", 4);
    local v102 = `{u95}{u96}`;
    u2:Add(`{v102}_MouseEnter`, u97.MouseEnter:Connect(function() -- Line: 905
        -- upvalues: u10 (ref), TweenService (ref), u97 (copy)
        u10.Play("UI.submenu_scroll");
        TweenService:Create(u97.Selection, TweenInfo.new(0.15), {
            BackgroundTransparency = 0
        }):Play();
    end));
    u2:Add(`{v102}_MouseLeave`, u97.MouseLeave:Connect(function() -- Line: 911
        -- upvalues: TweenService (ref), u97 (copy)
        TweenService:Create(u97.Selection, TweenInfo.new(0.15), {
            BackgroundTransparency = 1
        }):Play();
    end));
    u2:Add(`{v102}_MouseButton1Click`, u97.Icon.MouseButton1Click:Connect(function() -- Line: 915
        -- upvalues: u1 (ref), u95 (copy), u96 (copy)
        u1.AddItem("Exchange", u95, u96);
    end));

    return u97;
end;

function u1.ClearExchange() -- Line: 922
    -- upvalues: u2 (ref)
    for _, child in ExchangeList:GetChildren() do
        local v103 = `{child:GetAttribute("WeaponName")}{child:GetAttribute("SkinName")}`;
        u2:Removes(`{v103}_MouseButton1Click`, `{v103}_MouseLeave`, (`{v103}_MouseEnter`));
        child:Destroy();
    end;
end;

function u1.Init(p104) -- Line: 935
    -- upvalues: u2 (ref), u3 (ref), u8 (ref), u5 (ref), u6 (ref), u4 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u7 (ref), u13 (ref), u1 (copy), u19 (ref)
    u2 = p104:GetModule("Maid").new();
    u3 = p104:GetModule("Enums");
    u8 = p104:GetModule("Network");
    u5 = p104:GetModule("ItemManager");
    u6 = p104:GetModule("SkinManager");
    WeaponManager = p104:GetModule("WeaponManager");
    u4 = p104:GetModule("Inventory");
    u9 = p104:GetModule("RarityColors");
    u10 = p104:GetModule("SoundManager");
    u11 = p104:GetModule("Gui");
    u12 = p104:GetModule("InventoryData");
    u7 = p104:GetModule("FuserConfig");
    u13 = p104:GetModule("ProfileData");
    u8.Gui.UpgradeResult.On(u1.Animation);
    u8.Gui.FuserScrollsUpdate.On(function(p105) -- Line: 949
        -- upvalues: u19 (ref), u1 (ref)
        u19 = p105;
        u1.UpdateScrollsUI();
    end);
end;

function u1.IsSpinning() -- Line: 955
    -- upvalues: u16 (ref)
    return u16;
end;

function u1.Start(p106) -- Line: 959
    -- upvalues: u30 (ref), u11 (ref), u24 (ref)
    u30 = u11.GetComponent("Settings");
    u24 = u11.GetComponent("PurchaseButtons");
end;

function u1.Start2(p107) -- Line: 964
    -- upvalues: u1 (copy)
    u1:Draw();
end;

function u1.UpdateScrollsUI() -- Line: 969
    -- upvalues: u20 (ref), u19 (ref)
    if not u20 then
        return;
    end;

    if u19 <= 0 then
        u20.Text = "No Scrolls — get one to Fuse";
        u20.TextColor3 = Color3.fromRGB(255, 100, 100);

        return;
    end;

    u20.Text = `{u19} Scroll{u19 == 1 and "" or "s"} remaining`;
    u20.TextColor3 = Color3.fromRGB(180, 255, 160);
end;

function u1.itemSetup(p108, p109) -- Line: 983
    local Frame = Instance.new("Frame");
    Frame.Name = "Credits";
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.99, 0);
    Frame.Size = UDim2.fromScale(0.5, 0.2);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.0500001, 0.457503);
    TextLabel.Size = UDim2.fromScale(0.675, 0.914999);
    TextLabel.Text = p109;
    TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.1;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://138240378050344";
    ImageLabel.Position = UDim2.fromScale(1, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    Frame.Parent = p108;
end;

function u1.new(p110) -- Line: 1023
    -- upvalues: u14 (ref), u21 (ref), u20 (ref), u22 (ref), u23 (ref), u18 (ref)
    p110.Name = "Upgrader";
    p110.BackgroundTransparency = 1;
    p110.Position = UDim2.fromScale(0, 0.058);
    p110.Size = UDim2.fromScale(1, 0.942);
    local Frame = Instance.new("Frame");
    Frame.Name = "Background";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 36);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 0);
    Frame.Size = UDim2.fromScale(1, 0.6);
    Frame.ZIndex = -1;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundColor3 = Color3.fromRGB(16, 16, 16);
    ImageLabel.BackgroundTransparency = 0.9;
    ImageLabel.BorderColor3 = Color3.new();
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.fromRGB(97, 97, 97);
    ImageLabel.ImageTransparency = 0.8;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel.ZIndex = -1;
    ImageLabel.Parent = Frame;
    Frame.Parent = p110;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Disclaimer";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.03);
    Frame2.Size = UDim2.fromScale(0.56, 0.03);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "MainText";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 4;
    TextLabel.Position = UDim2.fromScale(0.06, 0.5);
    TextLabel.RichText = true;
    TextLabel.Size = UDim2.fromScale(1.0375, 0.8);
    TextLabel.Text = "Roll for an upgrade based on your item\'s value ratio (max 60% chance). Fails grant a <font transparency=\"0\" weight=\"bold\"><b>10% value cashback (up to 1,250 Credits)</b></font>. Higher-value rewards <font transparency=\"0\" weight=\"bold\"><b>are not guaranteed.</b></font>";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.25;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame2;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "IconInfo";
    ImageLabel2.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://80205853195967";
    ImageLabel2.Position = UDim2.fromScale(0, 0.5);
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = Frame2;
    Frame2.Parent = p110;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Main";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundColor3 = Color3.new(0, 0, 0);
    Frame3.BackgroundTransparency = 0.8;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.fromScale(1, 0.4);
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Line";
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BackgroundTransparency = 0.8;
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Size = UDim2.new(1, 0, 0, 1);
    Frame4.Parent = Frame3;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Line";
    Frame5.AnchorPoint = Vector2.new(0.5, 0);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BackgroundTransparency = 0.8;
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.new(0.5, 0, 0, 1);
    Frame5.Size = UDim2.new(0, 1, 1, 0);
    Frame5.Parent = Frame3;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Inventory";
    Frame6.BackgroundTransparency = 1;
    Frame6.Size = UDim2.fromScale(0.5, 1);
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Top";
    Frame7.BackgroundTransparency = 1;
    Frame7.Size = UDim2.fromScale(1, 0.175);
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.LayoutOrder = 4;
    TextLabel2.Position = UDim2.fromScale(0.04, 0.5);
    TextLabel2.RichText = true;
    TextLabel2.Size = UDim2.fromScale(0.3, 0.4);
    TextLabel2.Text = "Select Item";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.25;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = Frame7;
    DropButtonInventory = Instance.new("TextButton");
    DropButtonInventory.Name = "TextButton";
    DropButtonInventory.AnchorPoint = Vector2.new(1, 0.5);
    DropButtonInventory.BackgroundTransparency = 1;
    DropButtonInventory.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    DropButtonInventory.Position = UDim2.fromScale(0.98, 0.5);
    DropButtonInventory.Size = UDim2.fromScale(0.16, 0.7);
    DropButtonInventory.TextColor3 = Color3.new();
    DropButtonInventory.TextSize = 14;
    DropButtonInventory.TextTransparency = 1;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner.BottomRightRadius = UDim.new(0.1, 0);
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.TopLeftRadius = UDim.new(0.1, 0);
    UICorner.TopRightRadius = UDim.new(0.1, 0);
    UICorner.Parent = DropButtonInventory;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 1.3;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = DropButtonInventory;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "V";
    ImageLabel3.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://125527069434921";
    ImageLabel3.Position = UDim2.fromScale(0.9, 0.5);
    ImageLabel3.Rotation = 90;
    ImageLabel3.Size = UDim2.fromScale(0.4, 0.4);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = DropButtonInventory;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "AutoLeft";
    Frame8.BackgroundTransparency = 1;
    Frame8.Size = UDim2.fromScale(1, 1);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0, 10);
    UIPadding.Parent = Frame8;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "TextLabel";
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0, 0.25);
    TextLabel3.Size = UDim2.fromScale(1, 0.5);
    TextLabel3.Text = "Newest";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel3.Parent = Frame8;
    Frame8.Parent = DropButtonInventory;
    DropButtonInventory.Parent = Frame7;
    Frame7.Parent = Frame6;
    u14 = Instance.new("ScrollingFrame");
    u14.Name = "InventoryList";
    u14.Active = true;
    u14.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    u14.BackgroundTransparency = 1;
    u14.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    u14.Position = UDim2.fromScale(0.05, 0.175);
    u14.ScrollBarThickness = 6;
    u14.ScrollingDirection = Enum.ScrollingDirection.Y;
    u14.Size = UDim2.fromScale(0.85, 0.825);
    u14.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.new(0.03, 0, 0.16, 2);
    UIGridLayout.CellSize = UDim2.fromScale(0.22, 0.24);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 1250
        -- upvalues: u14 (ref), UIGridLayout (copy)
        u14.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 100);
    end);
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.425;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = UIGridLayout;
    UIGridLayout.Parent = u14;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingBottom = UDim.new(0, 2);
    UIPadding2.PaddingLeft = UDim.new(0.012, 0);
    UIPadding2.PaddingRight = UDim.new(0.012, 0);
    UIPadding2.PaddingTop = UDim.new(0, 2);
    UIPadding2.Parent = u14;
    u14.Parent = Frame6;
    Frame6.Parent = Frame3;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Exchange";
    Frame9.BackgroundTransparency = 1;
    Frame9.Position = UDim2.fromScale(0.5, 0);
    Frame9.Size = UDim2.fromScale(0.5, 1);
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Top";
    Frame10.BackgroundTransparency = 1;
    Frame10.Size = UDim2.fromScale(1, 0.175);
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel4.LayoutOrder = 4;
    TextLabel4.Position = UDim2.fromScale(0.04, 0.5);
    TextLabel4.RichText = true;
    TextLabel4.Size = UDim2.fromScale(0.3, 0.4);
    TextLabel4.Text = "Select weapon you want to receive";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.25;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = Frame10;
    DropButtonExchange = Instance.new("TextButton");
    DropButtonExchange.Name = "TextButton";
    DropButtonExchange.AnchorPoint = Vector2.new(1, 0.5);
    DropButtonExchange.BackgroundTransparency = 1;
    DropButtonExchange.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    DropButtonExchange.Position = UDim2.fromScale(0.98, 0.5);
    DropButtonExchange.Size = UDim2.fromScale(0.16, 0.7);
    DropButtonExchange.TextColor3 = Color3.new();
    DropButtonExchange.TextSize = 14;
    DropButtonExchange.TextTransparency = 1;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner2.BottomRightRadius = UDim.new(0.1, 0);
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.TopLeftRadius = UDim.new(0.1, 0);
    UICorner2.TopRightRadius = UDim.new(0.1, 0);
    UICorner2.Parent = DropButtonExchange;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Thickness = 1.3;
    UIStroke2.Transparency = 0.8;
    UIStroke2.Parent = DropButtonExchange;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "V";
    ImageLabel4.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://125527069434921";
    ImageLabel4.Position = UDim2.fromScale(0.9, 0.5);
    ImageLabel4.Rotation = 90;
    ImageLabel4.Size = UDim2.fromScale(0.4, 0.4);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = DropButtonExchange;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "AutoLeft";
    Frame11.BackgroundTransparency = 1;
    Frame11.Size = UDim2.fromScale(1, 1);
    local UIPadding3 = Instance.new("UIPadding");
    UIPadding3.Name = "UIPadding";
    UIPadding3.PaddingLeft = UDim.new(0, 10);
    UIPadding3.Parent = Frame11;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "TextLabel";
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0, 0.25);
    TextLabel5.Size = UDim2.fromScale(1, 0.5);
    TextLabel5.Text = "Newest";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel5.Parent = Frame11;
    Frame11.Parent = DropButtonExchange;
    DropButtonExchange.Parent = Frame10;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "TextButton";
    Frame12.Active = true;
    Frame12.AnchorPoint = Vector2.new(1, 0.5);
    Frame12.BackgroundTransparency = 1;
    Frame12.Position = UDim2.fromScale(0.8, 0.5);
    Frame12.Selectable = true;
    Frame12.Size = UDim2.fromScale(0.2, 0.7);
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner3.BottomRightRadius = UDim.new(0.1, 0);
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.TopLeftRadius = UDim.new(0.1, 0);
    UICorner3.TopRightRadius = UDim.new(0.1, 0);
    UICorner3.Parent = Frame12;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.new(1, 1, 1);
    UIStroke3.Thickness = 1.3;
    UIStroke3.Transparency = 0.8;
    UIStroke3.Parent = Frame12;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Frame";
    Frame13.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame13.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame13.BackgroundTransparency = 0.8;
    Frame13.BorderColor3 = Color3.new();
    Frame13.BorderSizePixel = 0;
    Frame13.Position = UDim2.fromScale(0.5, 0.5);
    Frame13.Size = UDim2.new(0, 1, 1, 0);
    Frame13.Parent = Frame12;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "Frame";
    Frame14.BackgroundTransparency = 1;
    Frame14.Size = UDim2.fromScale(0.5, 1);
    MinTextBox = Instance.new("TextBox");
    MinTextBox.Name = "TextLabel";
    MinTextBox.Active = false;
    MinTextBox.AnchorPoint = Vector2.new(1, 0.5);
    MinTextBox.BackgroundTransparency = 1;
    MinTextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    MinTextBox.PlaceholderColor3 = Color3.fromRGB(189, 189, 189);
    MinTextBox.PlaceholderText = "min";
    MinTextBox.Position = UDim2.fromScale(1, 0.5);
    MinTextBox.Selectable = false;
    MinTextBox.Size = UDim2.fromScale(0.65, 0.5);
    MinTextBox.Text = 0;
    MinTextBox.TextColor3 = Color3.new(1, 1, 1);
    MinTextBox.TextScaled = true;
    MinTextBox.TextXAlignment = Enum.TextXAlignment.Left;
    MinTextBox.TextYAlignment = Enum.TextYAlignment.Bottom;
    MinTextBox.Parent = Frame14;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "ImageLabel";
    ImageLabel5.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://138240378050344";
    ImageLabel5.Position = UDim2.fromScale(0.025, 0.5);
    ImageLabel5.ScaleType = Enum.ScaleType.Fit;
    ImageLabel5.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel5.Parent = Frame14;
    Frame14.Parent = Frame12;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Frame";
    Frame15.AnchorPoint = Vector2.new(1, 0);
    Frame15.BackgroundTransparency = 1;
    Frame15.Position = UDim2.fromScale(1, 0);
    Frame15.Size = UDim2.fromScale(0.5, 1);
    MaxTextBox = Instance.new("TextBox");
    MaxTextBox.Name = "TextLabel";
    MaxTextBox.Active = false;
    MaxTextBox.AnchorPoint = Vector2.new(1, 0.5);
    MaxTextBox.BackgroundTransparency = 1;
    MaxTextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    MaxTextBox.PlaceholderColor3 = Color3.fromRGB(189, 189, 189);
    MaxTextBox.PlaceholderText = "max";
    MaxTextBox.Position = UDim2.fromScale(1, 0.5);
    MaxTextBox.Selectable = false;
    MaxTextBox.Size = UDim2.fromScale(0.65, 0.5);
    MaxTextBox.Text = (1 / 0);
    MaxTextBox.TextColor3 = Color3.new(1, 1, 1);
    MaxTextBox.TextScaled = true;
    MaxTextBox.TextXAlignment = Enum.TextXAlignment.Left;
    MaxTextBox.TextYAlignment = Enum.TextYAlignment.Bottom;
    MaxTextBox.Parent = Frame15;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "ImageLabel";
    ImageLabel6.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://138240378050344";
    ImageLabel6.Position = UDim2.fromScale(0.025, 0.5);
    ImageLabel6.ScaleType = Enum.ScaleType.Fit;
    ImageLabel6.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel6.Parent = Frame15;
    Frame15.Parent = Frame12;
    Frame12.Parent = Frame10;
    Frame10.Parent = Frame9;
    ExchangeList = Instance.new("ScrollingFrame");
    ExchangeList.Name = "ExchangeList";
    ExchangeList.Active = true;
    ExchangeList.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ExchangeList.BackgroundTransparency = 1;
    ExchangeList.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ExchangeList.Position = UDim2.fromScale(0.05, 0.175);
    ExchangeList.ScrollBarThickness = 6;
    ExchangeList.ScrollingDirection = Enum.ScrollingDirection.Y;
    ExchangeList.Size = UDim2.fromScale(0.85, 0.825);
    ExchangeList.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    local UIGridLayout2 = Instance.new("UIGridLayout");
    UIGridLayout2.Name = "UIGridLayout";
    UIGridLayout2.CellPadding = UDim2.new(0.03, 0, 0.16, 2);
    UIGridLayout2.CellSize = UDim2.fromScale(0.22, 0.24);
    UIGridLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 1518
        -- upvalues: UIGridLayout2 (copy)
        ExchangeList.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout2.AbsoluteContentSize.Y + 100);
    end);
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.AspectRatio = 1.425;
    UIAspectRatioConstraint2.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint2.Parent = UIGridLayout2;
    UIGridLayout2.Parent = ExchangeList;
    local UIPadding4 = Instance.new("UIPadding");
    UIPadding4.Name = "UIPadding";
    UIPadding4.PaddingBottom = UDim.new(0, 2);
    UIPadding4.PaddingLeft = UDim.new(0.012, 0);
    UIPadding4.PaddingRight = UDim.new(0.012, 0);
    UIPadding4.PaddingTop = UDim.new(0, 2);
    UIPadding4.Parent = ExchangeList;
    ExchangeList.Parent = Frame9;
    Frame9.Parent = Frame3;
    Frame3.Parent = p110;
    Center = Instance.new("Frame");
    Center.Name = "Center";
    Center.AnchorPoint = Vector2.new(0.5, 0);
    Center.BackgroundTransparency = 1;
    Center.Position = UDim2.fromScale(0.5, 0.06);
    Center.Size = UDim2.fromScale(1, 0.54);
    Center.ZIndex = 5;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "Upgrader";
    Frame16.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame16.BackgroundTransparency = 1;
    Frame16.Position = UDim2.fromScale(0.5, 0.5);
    Frame16.Size = UDim2.fromScale(1, 1);
    Frame16.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame16.ZIndex = 10;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Cashback";
    TextLabel6.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.5, 0);
    TextLabel6.Size = UDim2.fromScale(1, 0.05);
    TextLabel6.Text = "200 Kredits cashback on lose - 50%";
    TextLabel6.TextColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextScaled = true;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 76, 79)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 135, 153)) });
    UIGradient.Rotation = 90;
    UIGradient.Parent = TextLabel6;
    TextLabel6.Parent = Frame16;
    u21 = TextLabel6;
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "Frame";
    Frame17.AnchorPoint = Vector2.new(0.5, 0);
    Frame17.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame17.Position = UDim2.fromScale(0.5, 0.05);
    Frame17.Size = UDim2.fromScale(0.75, 0.75);
    Frame17.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.BottomLeftRadius = UDim.new(1, 0);
    UICorner4.BottomRightRadius = UDim.new(1, 0);
    UICorner4.CornerRadius = UDim.new(1, 0);
    UICorner4.TopLeftRadius = UDim.new(1, 0);
    UICorner4.TopRightRadius = UDim.new(1, 0);
    UICorner4.Parent = Frame17;
    Progress = Instance.new("Frame");
    Progress.Name = "Progress";
    Progress.AnchorPoint = Vector2.new(0.5, 0.5);
    Progress.BackgroundTransparency = 1;
    Progress.Position = UDim2.fromScale(0.5, 0.5);
    Progress.Size = UDim2.fromScale(0.85, 0.85);
    local Frame18 = Instance.new("Frame");
    Frame18.Name = "Center";
    Frame18.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame18.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame18.Position = UDim2.fromScale(0.5, 0.5);
    Frame18.Size = UDim2.fromScale(0.975, 0.975);
    Frame18.ZIndex = 2;
    Progress1 = Instance.new("Frame");
    Progress1.Name = "Progress";
    Progress1.AnchorPoint = Vector2.new(0.5, 0.5);
    Progress1.BackgroundTransparency = 1;
    Progress1.Position = UDim2.fromScale(0.5, 0.5);
    Progress1.Size = UDim2.fromScale(0.9, 0.9);
    local Frame19 = Instance.new("Frame");
    Frame19.Name = "Center";
    Frame19.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame19.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame19.Position = UDim2.fromScale(0.5, 0.5);
    Frame19.Size = UDim2.fromScale(0.75, 0.75);
    Frame19.ZIndex = 2;
    local ImageLabel7 = Instance.new("ImageLabel");
    ImageLabel7.Name = "ImageLabel";
    ImageLabel7.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel7.BackgroundTransparency = 1;
    ImageLabel7.Image = "rbxassetid://80683439196141";
    ImageLabel7.ImageColor3 = Color3.new();
    ImageLabel7.ImageTransparency = 0.9;
    ImageLabel7.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel7.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel7.ZIndex = -1;
    ImageLabel7.Parent = Frame19;
    local ImageLabel8 = Instance.new("ImageLabel");
    ImageLabel8.Name = "ImageLabel";
    ImageLabel8.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel8.BackgroundTransparency = 1;
    ImageLabel8.Image = "rbxassetid://8119252523";
    ImageLabel8.ImageColor3 = Color3.fromRGB(236, 199, 76);
    ImageLabel8.ImageTransparency = 0.8;
    ImageLabel8.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel8.Size = UDim2.fromScale(1, 1);
    ImageLabel8.ZIndex = -1;
    ImageLabel8.Parent = Frame19;
    CenterTitle = Instance.new("TextLabel");
    CenterTitle.Name = "Chance";
    CenterTitle.AnchorPoint = Vector2.new(0.5, 0.5);
    CenterTitle.BackgroundTransparency = 1;
    CenterTitle.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    CenterTitle.Position = UDim2.fromScale(0.5, 0.5);
    CenterTitle.Size = UDim2.fromScale(0.8, 0.3);
    CenterTitle.Text = "50%";
    CenterTitle.TextColor3 = Color3.new(1, 1, 1);
    CenterTitle.TextScaled = true;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 191, 80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(167, 255, 108)) });
    UIGradient2.Rotation = 90;
    UIGradient2.Parent = CenterTitle;
    CenterTitle.Parent = Frame19;
    UnderCenterTitle = Instance.new("TextLabel");
    UnderCenterTitle.Name = "ChanceTitle";
    UnderCenterTitle.AnchorPoint = Vector2.new(0.5, 0.5);
    UnderCenterTitle.BackgroundTransparency = 1;
    UnderCenterTitle.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    UnderCenterTitle.Position = UDim2.fromScale(0.5, 0.65);
    UnderCenterTitle.Size = UDim2.fromScale(0.8, 0.1);
    UnderCenterTitle.Text = "high chance";
    UnderCenterTitle.TextColor3 = Color3.new(1, 1, 1);
    UnderCenterTitle.TextScaled = true;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(167, 255, 108)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(167, 255, 108)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 224, 102)) });
    UIGradient3.Rotation = 90;
    UIGradient3.Parent = UnderCenterTitle;
    UnderCenterTitle.Parent = Frame19;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.BottomLeftRadius = UDim.new(0.5, 0);
    UICorner5.BottomRightRadius = UDim.new(0.5, 0);
    UICorner5.CornerRadius = UDim.new(0.5, 0);
    UICorner5.TopLeftRadius = UDim.new(0.5, 0);
    UICorner5.TopRightRadius = UDim.new(0.5, 0);
    UICorner5.Parent = Frame19;
    Frame19.Parent = Progress1;
    local Frame20 = Instance.new("Frame");
    Frame20.Name = "Background";
    Frame20.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame20.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame20.Position = UDim2.fromScale(0.5, 0.5);
    Frame20.Size = UDim2.new(1, -2, 1, -2);
    Frame20.ZIndex = 0;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UICorner";
    UICorner6.BottomLeftRadius = UDim.new(0.5, 0);
    UICorner6.BottomRightRadius = UDim.new(0.5, 0);
    UICorner6.CornerRadius = UDim.new(0.5, 0);
    UICorner6.TopLeftRadius = UDim.new(0.5, 0);
    UICorner6.TopRightRadius = UDim.new(0.5, 0);
    UICorner6.Parent = Frame20;
    local UIGradient4 = Instance.new("UIGradient");
    UIGradient4.Name = "UIGradient";
    UIGradient4.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 255, 47)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 191, 80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 0)) });
    UIGradient4.Rotation = 90;
    UIGradient4.Parent = Frame20;
    Frame20.Parent = Progress1;
    local Frame21 = Instance.new("Frame");
    Frame21.Name = "Left";
    Frame21.AnchorPoint = Vector2.new(0, 1);
    Frame21.BackgroundTransparency = 1;
    Frame21.ClipsDescendants = true;
    Frame21.Position = UDim2.fromScale(0, 1);
    Frame21.Size = UDim2.new(0.5, 1, 1, 1);
    local Frame22 = Instance.new("Frame");
    Frame22.Name = "Frame";
    Frame22.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame22.Size = UDim2.fromScale(1, 1);
    Frame22.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UIGradient5 = Instance.new("UIGradient");
    UIGradient5.Name = "UIGradient";
    UIGradient5.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 24, 28)), ColorSequenceKeypoint.new(1, Color3.fromRGB(23, 24, 28)) });
    UIGradient5.Rotation = 90;
    UIGradient5.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.501, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient5.Parent = Frame22;
    local UICorner7 = Instance.new("UICorner");
    UICorner7.Name = "UICorner";
    UICorner7.BottomLeftRadius = UDim.new(0.5, 0);
    UICorner7.BottomRightRadius = UDim.new(0.5, 0);
    UICorner7.CornerRadius = UDim.new(0.5, 0);
    UICorner7.TopLeftRadius = UDim.new(0.5, 0);
    UICorner7.TopRightRadius = UDim.new(0.5, 0);
    UICorner7.Parent = Frame22;
    Frame22.Parent = Frame21;
    Frame21.Parent = Progress1;
    local Frame23 = Instance.new("Frame");
    Frame23.Name = "Right";
    Frame23.AnchorPoint = Vector2.new(1, 1);
    Frame23.BackgroundTransparency = 1;
    Frame23.ClipsDescendants = true;
    Frame23.Position = UDim2.fromScale(1, 1);
    Frame23.Size = UDim2.new(0.5, 1, 1, 1);
    local Frame24 = Instance.new("Frame");
    Frame24.Name = "Frame";
    Frame24.AnchorPoint = Vector2.new(1, 0);
    Frame24.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame24.Position = UDim2.fromScale(1, 0);
    Frame24.Size = UDim2.fromScale(1, 1);
    Frame24.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UIGradient6 = Instance.new("UIGradient");
    UIGradient6.Name = "UIGradient";
    UIGradient6.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 24, 28)), ColorSequenceKeypoint.new(1, Color3.fromRGB(23, 24, 28)) });
    UIGradient6.Rotation = 90;
    UIGradient6.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.501, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient6.Parent = Frame24;
    local UICorner8 = Instance.new("UICorner");
    UICorner8.Name = "UICorner";
    UICorner8.BottomLeftRadius = UDim.new(0.5, 0);
    UICorner8.BottomRightRadius = UDim.new(0.5, 0);
    UICorner8.CornerRadius = UDim.new(0.5, 0);
    UICorner8.TopLeftRadius = UDim.new(0.5, 0);
    UICorner8.TopRightRadius = UDim.new(0.5, 0);
    UICorner8.Parent = Frame24;
    Frame24.Parent = Frame23;
    Frame23.Parent = Progress1;
    local Frame25 = Instance.new("Frame");
    Frame25.Name = "Odds";
    Frame25.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame25.BackgroundTransparency = 1;
    Frame25.Position = UDim2.fromScale(0.5, 0.5);
    Frame25.Size = UDim2.fromScale(1, 1);
    Frame25.ZIndex = 100;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "100";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.new(0.5, 0, 0.025, 1);
    TextLabel7.Size = UDim2.fromScale(0.125, 0.075);
    TextLabel7.Text = "100%";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.TextTransparency = 0.9;
    TextLabel7.Parent = Frame25;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "50";
    TextLabel8.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(-0.01, 0.5);
    TextLabel8.Size = UDim2.fromScale(0.125, 0.075);
    TextLabel8.Text = "50%";
    TextLabel8.TextColor3 = Color3.new(1, 1, 1);
    TextLabel8.TextScaled = true;
    TextLabel8.TextTransparency = 0.9;
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel8.Parent = Frame25;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "50";
    TextLabel9.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(1.01, 0.5);
    TextLabel9.Size = UDim2.fromScale(0.125, 0.075);
    TextLabel9.Text = "50%";
    TextLabel9.TextColor3 = Color3.new(1, 1, 1);
    TextLabel9.TextScaled = true;
    TextLabel9.TextTransparency = 0.9;
    TextLabel9.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel9.Parent = Frame25;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "0";
    TextLabel10.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel10.Position = UDim2.fromScale(0.5, 0.975);
    TextLabel10.Size = UDim2.fromScale(0.125, 0.075);
    TextLabel10.Text = "0%";
    TextLabel10.TextColor3 = Color3.new(1, 1, 1);
    TextLabel10.TextScaled = true;
    TextLabel10.TextTransparency = 0.9;
    TextLabel10.Parent = Frame25;
    Frame25.Parent = Progress1;
    Progress1.Parent = Frame18;
    Pointer = Instance.new("ImageLabel");
    Pointer.Name = "Point";
    Pointer.AnchorPoint = Vector2.new(0.5, 0.5);
    Pointer.BackgroundTransparency = 1;
    Pointer.Image = "rbxassetid://123833495788672";
    Pointer.Position = UDim2.fromScale(0.5, 0.91);
    Pointer.Rotation = 180;
    Pointer.ScaleType = Enum.ScaleType.Fit;
    Pointer.Size = UDim2.fromScale(0.175, 0.175);
    Pointer.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Pointer.Parent = Frame18;
    local UICorner9 = Instance.new("UICorner");
    UICorner9.Name = "UICorner";
    UICorner9.BottomLeftRadius = UDim.new(0.5, 0);
    UICorner9.BottomRightRadius = UDim.new(0.5, 0);
    UICorner9.CornerRadius = UDim.new(0.5, 0);
    UICorner9.TopLeftRadius = UDim.new(0.5, 0);
    UICorner9.TopRightRadius = UDim.new(0.5, 0);
    UICorner9.Parent = Frame18;
    Frame18.Parent = Progress;
    local Frame26 = Instance.new("Frame");
    Frame26.Name = "Right";
    Frame26.AnchorPoint = Vector2.new(1, 0.5);
    Frame26.BackgroundTransparency = 1;
    Frame26.ClipsDescendants = true;
    Frame26.Position = UDim2.fromScale(1, 0.5);
    Frame26.Size = UDim2.new(0.5, 1, 1, 0);
    local Frame27 = Instance.new("Frame");
    Frame27.Name = "Frame";
    Frame27.AnchorPoint = Vector2.new(1, 0);
    Frame27.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame27.Position = UDim2.fromScale(1, 0);
    Frame27.Size = UDim2.fromScale(1, 1);
    Frame27.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UIGradient7 = Instance.new("UIGradient");
    UIGradient7.Name = "UIGradient";
    UIGradient7.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 24, 28)), ColorSequenceKeypoint.new(1, Color3.fromRGB(23, 24, 28)) });
    UIGradient7.Rotation = 90;
    UIGradient7.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.501, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient7.Parent = Frame27;
    local UICorner10 = Instance.new("UICorner");
    UICorner10.Name = "UICorner";
    UICorner10.BottomLeftRadius = UDim.new(0.5, 0);
    UICorner10.BottomRightRadius = UDim.new(0.5, 0);
    UICorner10.CornerRadius = UDim.new(0.5, 0);
    UICorner10.TopLeftRadius = UDim.new(0.5, 0);
    UICorner10.TopRightRadius = UDim.new(0.5, 0);
    UICorner10.Parent = Frame27;
    Frame27.Parent = Frame26;
    Frame26.Parent = Progress;
    local Frame28 = Instance.new("Frame");
    Frame28.Name = "Left";
    Frame28.AnchorPoint = Vector2.new(0, 0.5);
    Frame28.BackgroundTransparency = 1;
    Frame28.ClipsDescendants = true;
    Frame28.Position = UDim2.fromScale(0, 0.5);
    Frame28.Size = UDim2.new(0.5, 1, 1, 0);
    local Frame29 = Instance.new("Frame");
    Frame29.Name = "Frame";
    Frame29.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame29.Size = UDim2.fromScale(1, 1);
    Frame29.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UIGradient8 = Instance.new("UIGradient");
    UIGradient8.Name = "UIGradient";
    UIGradient8.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 24, 28)), ColorSequenceKeypoint.new(1, Color3.fromRGB(23, 24, 28)) });
    UIGradient8.Rotation = 90;
    UIGradient8.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.501, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient8.Parent = Frame29;
    local UICorner11 = Instance.new("UICorner");
    UICorner11.Name = "UICorner";
    UICorner11.BottomLeftRadius = UDim.new(0.5, 0);
    UICorner11.BottomRightRadius = UDim.new(0.5, 0);
    UICorner11.CornerRadius = UDim.new(0.5, 0);
    UICorner11.TopLeftRadius = UDim.new(0.5, 0);
    UICorner11.TopRightRadius = UDim.new(0.5, 0);
    UICorner11.Parent = Frame29;
    Frame29.Parent = Frame28;
    Frame28.Parent = Progress;
    local Frame30 = Instance.new("Frame");
    Frame30.Name = "Background";
    Frame30.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame30.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame30.Position = UDim2.fromScale(0.5, 0.5);
    Frame30.Size = UDim2.fromScale(0.99, 0.99);
    Frame30.ZIndex = 0;
    local UICorner12 = Instance.new("UICorner");
    UICorner12.Name = "UICorner";
    UICorner12.BottomLeftRadius = UDim.new(0.5, 0);
    UICorner12.BottomRightRadius = UDim.new(0.5, 0);
    UICorner12.CornerRadius = UDim.new(0.5, 0);
    UICorner12.TopLeftRadius = UDim.new(0.5, 0);
    UICorner12.TopRightRadius = UDim.new(0.5, 0);
    UICorner12.Parent = Frame30;
    local UIGradient9 = Instance.new("UIGradient");
    UIGradient9.Name = "UIGradient";
    UIGradient9.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 255, 47)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 191, 80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 0)) });
    UIGradient9.Rotation = 90;
    UIGradient9.Parent = Frame30;
    Frame30.Parent = Progress;
    Progress.Parent = Frame17;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "UIStroke";
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.Color = Color3.fromRGB(94, 94, 113);
    UIStroke4.Thickness = 1.3;
    UIStroke4.Parent = Frame17;
    Frame17.Parent = Frame16;
    Upgrade = Instance.new("TextButton");
    Upgrade.Name = "Upgrade";
    Upgrade.AnchorPoint = Vector2.new(0.5, 1);
    Upgrade.AutoButtonColor = false;
    Upgrade.BackgroundTransparency = 1;
    Upgrade.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    Upgrade.Position = UDim2.fromScale(0.5, 0.965);
    Upgrade.Size = UDim2.fromScale(0.6, 0.125);
    Upgrade.Text = "";
    Upgrade.TextColor3 = Color3.new();
    Upgrade.TextSize = 14;
    Upgrade.TextTransparency = 1;
    Upgrade.ZIndex = 2;
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "Title";
    TextLabel11.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel11.Position = UDim2.new(0.5, 0, 0.5, 1);
    TextLabel11.Size = UDim2.fromScale(0.5, 0.7);
    TextLabel11.Text = "FUSE";
    TextLabel11.TextColor3 = Color3.fromRGB(47, 47, 47);
    TextLabel11.TextScaled = true;
    TextLabel11.TextTransparency = 0.5;
    TextLabel11.ZIndex = 5;
    TextLabel11.Parent = Upgrade;
    local ImageLabel9 = Instance.new("ImageLabel");
    ImageLabel9.Name = "Shadow";
    ImageLabel9.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel9.BackgroundTransparency = 1;
    ImageLabel9.Image = "rbxassetid://186491278";
    ImageLabel9.ImageTransparency = 0.64;
    ImageLabel9.LayoutOrder = -1;
    ImageLabel9.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel9.ScaleType = Enum.ScaleType.Slice;
    ImageLabel9.Size = UDim2.new(1, 30, 1, 30);
    ImageLabel9.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel9.ZIndex = -9999;
    ImageLabel9.Parent = Upgrade;
    local Frame31 = Instance.new("Frame");
    Frame31.Name = "Frame";
    Frame31.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame31.BackgroundColor3 = Color3.fromRGB(144, 137, 33);
    Frame31.Position = UDim2.fromScale(0.5, 0.5);
    Frame31.Size = UDim2.fromScale(1, 1);
    local UICorner13 = Instance.new("UICorner");
    UICorner13.Name = "UICorner";
    UICorner13.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner13.BottomRightRadius = UDim.new(0.1, 0);
    UICorner13.CornerRadius = UDim.new(0.1, 0);
    UICorner13.TopLeftRadius = UDim.new(0.1, 0);
    UICorner13.TopRightRadius = UDim.new(0.1, 0);
    UICorner13.Parent = Frame31;
    Frame31.Parent = Upgrade;
    Upgrade.Parent = Frame16;
    u20 = Instance.new("TextLabel");
    u20.Name = "ScrollsLabel";
    u20.AnchorPoint = Vector2.new(0.5, 0);
    u20.BackgroundTransparency = 1;
    u20.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    u20.Position = UDim2.fromScale(0.5, 0.98);
    u20.Size = UDim2.fromScale(0.75, 0.0406101);
    u20.Text = "10 Scrolls remaining";
    u20.TextColor3 = Color3.fromRGB(180, 255, 160);
    u20.TextScaled = true;
    u20.ZIndex = 12;
    u20.Parent = Frame16;
    local Frame32 = Instance.new("Frame");
    Frame32.Name = "Multipliers";
    Frame32.AnchorPoint = Vector2.new(0, 1);
    Frame32.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame32.Position = UDim2.fromScale(-0.125, 0.985);
    Frame32.Size = UDim2.fromScale(0.6, 0.125);
    Frame32.Visible = false;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Credits";
    TextButton.Active = true;
    TextButton.Selectable = true;
    TextButton.AnchorPoint = Vector2.new(1, 0.5);
    TextButton.AutoButtonColor = true;
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton.BackgroundTransparency = 0.95;
    TextButton.LayoutOrder = 3;
    TextButton.Position = UDim2.fromScale(0.606394, 0.5);
    TextButton.Size = UDim2.fromScale(0.15, 1);
    TextButton.TextTransparency = 1;
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = "Title";
    TextLabel12.Active = false;
    TextLabel12.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel12.BackgroundTransparency = 1;
    TextLabel12.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel12.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel12.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel12.Text = "50";
    TextLabel12.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel12.TextScaled = true;
    TextLabel12.Parent = TextButton;
    local ImageLabel10 = Instance.new("ImageLabel");
    ImageLabel10.Name = "Icon";
    ImageLabel10.Active = false;
    ImageLabel10.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel10.BackgroundTransparency = 1;
    ImageLabel10.Image = "rbxassetid://138240378050344";
    ImageLabel10.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel10.LayoutOrder = 1;
    ImageLabel10.Position = UDim2.fromScale(0.02, 0.5);
    ImageLabel10.ScaleType = Enum.ScaleType.Fit;
    ImageLabel10.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel10.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel10.Parent = TextButton;
    local UIStroke5 = Instance.new("UIStroke");
    UIStroke5.Name = "UIStroke";
    UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke5.Color = Color3.new(1, 1, 1);
    UIStroke5.Transparency = 0.875;
    UIStroke5.Parent = TextButton;
    local UICorner14 = Instance.new("UICorner");
    UICorner14.Name = "UICorner";
    UICorner14.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner14.BottomRightRadius = UDim.new(0.1, 0);
    UICorner14.CornerRadius = UDim.new(0.1, 0);
    UICorner14.TopLeftRadius = UDim.new(0.1, 0);
    UICorner14.TopRightRadius = UDim.new(0.1, 0);
    UICorner14.Parent = TextButton;
    TextButton.Parent = Frame32;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Robux";
    TextButton2.Active = true;
    TextButton2.Selectable = true;
    TextButton2.AnchorPoint = Vector2.new(1, 0.5);
    TextButton2.AutoButtonColor = true;
    TextButton2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundTransparency = 0.95;
    TextButton2.LayoutOrder = 2;
    TextButton2.Position = UDim2.fromScale(0.85, 0.5);
    TextButton2.Size = UDim2.fromScale(0.15, 1);
    TextButton2.TextTransparency = 1;
    local UIStroke6 = Instance.new("UIStroke");
    UIStroke6.Name = "UIStroke";
    UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke6.Color = Color3.new(1, 1, 1);
    UIStroke6.Transparency = 0.875;
    UIStroke6.Parent = TextButton2;
    local UICorner15 = Instance.new("UICorner");
    UICorner15.Name = "UICorner";
    UICorner15.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner15.BottomRightRadius = UDim.new(0.1, 0);
    UICorner15.CornerRadius = UDim.new(0.1, 0);
    UICorner15.TopLeftRadius = UDim.new(0.1, 0);
    UICorner15.TopRightRadius = UDim.new(0.1, 0);
    UICorner15.Parent = TextButton2;
    local TextLabel13 = Instance.new("TextLabel");
    TextLabel13.Name = "Title";
    TextLabel13.Active = false;
    TextLabel13.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel13.BackgroundTransparency = 1;
    TextLabel13.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel13.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel13.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel13.Text = "25";
    TextLabel13.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel13.TextScaled = true;
    TextLabel13.Parent = TextButton2;
    local TextLabel14 = Instance.new("TextLabel");
    TextLabel14.Name = "Icon";
    TextLabel14.Active = false;
    TextLabel14.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel14.BackgroundTransparency = 1;
    TextLabel14.LayoutOrder = 1;
    TextLabel14.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel14.RichText = true;
    TextLabel14.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel14.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel14.Text = "";
    TextLabel14.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel14.TextScaled = true;
    TextLabel14.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel14.Parent = TextButton2;
    TextButton2.Parent = Frame32;
    local UIGridLayout3 = Instance.new("UIGridLayout");
    UIGridLayout3.Name = "UIGridLayout";
    UIGridLayout3.CellPadding = UDim2.fromScale(0.035, 0);
    UIGridLayout3.CellSize = UDim2.fromScale(0.45, 0.7);
    UIGridLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIGridLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout3.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIGridLayout3.Parent = Frame32;
    local UIStroke7 = Instance.new("UIStroke");
    UIStroke7.Name = "UIStroke";
    UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke7.Color = Color3.fromRGB(94, 94, 113);
    UIStroke7.Thickness = 1.3;
    UIStroke7.Parent = Frame32;
    local UICorner16 = Instance.new("UICorner");
    UICorner16.Name = "UICorner";
    UICorner16.BottomLeftRadius = UDim.new(0.15, 0);
    UICorner16.BottomRightRadius = UDim.new(0.15, 0);
    UICorner16.CornerRadius = UDim.new(0.15, 0);
    UICorner16.TopLeftRadius = UDim.new(0.15, 0);
    UICorner16.TopRightRadius = UDim.new(0.15, 0);
    UICorner16.Parent = Frame32;
    Frame32.Parent = Frame16;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Credits";
    TextButton3.Active = true;
    TextButton3.Selectable = true;
    TextButton3.AnchorPoint = Vector2.new(0.5, 1);
    TextButton3.AutoButtonColor = true;
    TextButton3.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton3.BackgroundTransparency = 0.95;
    TextButton3.LayoutOrder = 3;
    TextButton3.Position = UDim2.fromScale(0.05, 0.952);
    TextButton3.Size = UDim2.fromScale(0.25, 0.1);
    TextButton3.TextTransparency = 1;
    TextButton3.ZIndex = 15;
    local TextLabel15 = Instance.new("TextLabel");
    TextLabel15.Name = "Title";
    TextLabel15.Active = false;
    TextLabel15.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel15.BackgroundTransparency = 1;
    TextLabel15.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel15.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel15.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel15.Text = "60";
    TextLabel15.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel15.TextScaled = true;
    TextLabel15.ZIndex = 16;
    TextLabel15.Parent = TextButton3;
    local ImageLabel11 = Instance.new("ImageLabel");
    ImageLabel11.Name = "Icon";
    ImageLabel11.Active = false;
    ImageLabel11.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel11.BackgroundTransparency = 1;
    ImageLabel11.Image = "rbxassetid://138240378050344";
    ImageLabel11.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel11.LayoutOrder = 1;
    ImageLabel11.Position = UDim2.fromScale(0.02, 0.5);
    ImageLabel11.ScaleType = Enum.ScaleType.Fit;
    ImageLabel11.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel11.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel11.ZIndex = 16;
    ImageLabel11.Parent = TextButton3;
    local UIStroke8 = Instance.new("UIStroke");
    UIStroke8.Name = "UIStroke";
    UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke8.Color = Color3.new(1, 1, 1);
    UIStroke8.Transparency = 0.875;
    UIStroke8.Parent = TextButton3;
    local UICorner17 = Instance.new("UICorner");
    UICorner17.Name = "UICorner";
    UICorner17.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner17.BottomRightRadius = UDim.new(0.1, 0);
    UICorner17.CornerRadius = UDim.new(0.1, 0);
    UICorner17.TopLeftRadius = UDim.new(0.1, 0);
    UICorner17.TopRightRadius = UDim.new(0.1, 0);
    UICorner17.Parent = TextButton3;
    TextButton3.Parent = Frame16;
    local TextButton4 = Instance.new("TextButton");
    TextButton4.Name = "Robux";
    TextButton4.Active = true;
    TextButton4.Selectable = true;
    TextButton4.AnchorPoint = Vector2.new(0.5, 1);
    TextButton4.AutoButtonColor = true;
    TextButton4.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton4.BackgroundTransparency = 0.95;
    TextButton4.LayoutOrder = 2;
    TextButton4.Position = UDim2.fromScale(0.95, 0.952);
    TextButton4.Size = UDim2.fromScale(0.25, 0.1);
    TextButton4.TextTransparency = 1;
    TextButton4.ZIndex = 15;
    local UIStroke9 = Instance.new("UIStroke");
    UIStroke9.Name = "UIStroke";
    UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke9.Color = Color3.new(1, 1, 1);
    UIStroke9.Transparency = 0.875;
    UIStroke9.Parent = TextButton4;
    local UICorner18 = Instance.new("UICorner");
    UICorner18.Name = "UICorner";
    UICorner18.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner18.BottomRightRadius = UDim.new(0.1, 0);
    UICorner18.CornerRadius = UDim.new(0.1, 0);
    UICorner18.TopLeftRadius = UDim.new(0.1, 0);
    UICorner18.TopRightRadius = UDim.new(0.1, 0);
    UICorner18.Parent = TextButton4;
    local TextLabel16 = Instance.new("TextLabel");
    TextLabel16.Name = "Title";
    TextLabel16.Active = false;
    TextLabel16.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel16.BackgroundTransparency = 1;
    TextLabel16.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel16.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel16.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel16.Text = "25";
    TextLabel16.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel16.TextScaled = true;
    TextLabel16.ZIndex = 16;
    TextLabel16.Parent = TextButton4;
    local TextLabel17 = Instance.new("TextLabel");
    TextLabel17.Name = "Icon";
    TextLabel17.Active = false;
    TextLabel17.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel17.BackgroundTransparency = 1;
    TextLabel17.LayoutOrder = 1;
    TextLabel17.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel17.RichText = true;
    TextLabel17.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel17.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel17.Text = "";
    TextLabel17.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel17.TextScaled = true;
    TextLabel17.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel17.ZIndex = 16;
    TextLabel17.Parent = TextButton4;
    TextButton4.Parent = Frame16;
    u22 = TextButton3;
    u23 = TextButton4;
    Frame16.Parent = Center;
    local Frame33 = Instance.new("Frame");
    Frame33.Name = "Item";
    Frame33.AnchorPoint = Vector2.new(0, 0.5);
    Frame33.BackgroundTransparency = 1;
    Frame33.Position = UDim2.fromScale(0.1, 0.5);
    Frame33.Size = UDim2.fromScale(1, 1);
    Frame33.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local Frame34 = Instance.new("Frame");
    Frame34.Name = "Frame";
    Frame34.AnchorPoint = Vector2.new(0.5, 0);
    Frame34.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame34.Position = UDim2.fromScale(0.5, 0);
    Frame34.Size = UDim2.fromScale(0.85, 0.85);
    Frame34.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner19 = Instance.new("UICorner");
    UICorner19.Name = "UICorner";
    UICorner19.BottomLeftRadius = UDim.new(0.05, 0);
    UICorner19.BottomRightRadius = UDim.new(0.05, 0);
    UICorner19.CornerRadius = UDim.new(0.05, 0);
    UICorner19.TopLeftRadius = UDim.new(0.05, 0);
    UICorner19.TopRightRadius = UDim.new(0.05, 0);
    UICorner19.Parent = Frame34;
    local ImageLabel12 = Instance.new("ImageLabel");
    ImageLabel12.Name = "ShineBG";
    ImageLabel12.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel12.BackgroundTransparency = 1;
    ImageLabel12.Image = "rbxassetid://8119252523";
    ImageLabel12.ImageColor3 = Color3.fromRGB(236, 199, 76);
    ImageLabel12.ImageTransparency = 0.8;
    ImageLabel12.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel12.Size = UDim2.fromScale(1, 1);
    ImageLabel12.Visible = false;
    ImageLabel12.ZIndex = -1;
    ImageLabel12.Parent = Frame34;
    local TextLabel18 = Instance.new("TextLabel");
    TextLabel18.Name = "Title";
    TextLabel18.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel18.BackgroundTransparency = 1;
    TextLabel18.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel18.Position = UDim2.fromScale(0.5, 0.05);
    TextLabel18.Size = UDim2.fromScale(0.8, 0.06);
    TextLabel18.Text = "Select item to use";
    TextLabel18.TextColor3 = Color3.new(1, 1, 1);
    TextLabel18.TextScaled = true;
    TextLabel18.Visible = false;
    TextLabel18.Parent = Frame34;
    local TextLabel19 = Instance.new("TextLabel");
    TextLabel19.Name = "Tip";
    TextLabel19.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel19.BackgroundTransparency = 1;
    TextLabel19.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel19.Position = UDim2.fromScale(0.5, 0.12);
    TextLabel19.Size = UDim2.fromScale(0.8, 0.045);
    TextLabel19.Text = "You can select up to 4 items";
    TextLabel19.TextColor3 = Color3.new(1, 1, 1);
    TextLabel19.TextScaled = true;
    TextLabel19.TextTransparency = 0.5;
    TextLabel19.Visible = false;
    TextLabel19.Parent = Frame34;
    local UIStroke10 = Instance.new("UIStroke");
    UIStroke10.Name = "UIStroke";
    UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke10.Color = Color3.fromRGB(94, 94, 113);
    UIStroke10.Thickness = 1.3;
    UIStroke10.Parent = Frame34;
    local ImageLabel13 = Instance.new("ImageLabel");
    ImageLabel13.Name = "WeaponBG";
    ImageLabel13.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel13.BackgroundTransparency = 1;
    ImageLabel13.Image = "rbxassetid://90180761681953";
    ImageLabel13.ImageColor3 = Color3.new();
    ImageLabel13.ImageTransparency = 0.6;
    ImageLabel13.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel13.Rotation = 15;
    ImageLabel13.ScaleType = Enum.ScaleType.Fit;
    ImageLabel13.Size = UDim2.fromScale(1, 1);
    ImageLabel13.Visible = false;
    ImageLabel13.ZIndex = -1;
    ImageLabel13.Parent = Frame34;
    local Frame35 = Instance.new("Frame");
    Frame35.Name = "Item";
    Frame35.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame35.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame35.Position = UDim2.fromScale(0.5, 0.5);
    Frame35.Size = UDim2.fromScale(1, 1);
    local UICorner20 = Instance.new("UICorner");
    UICorner20.Name = "UICorner";
    UICorner20.BottomLeftRadius = UDim.new(0.05, 0);
    UICorner20.BottomRightRadius = UDim.new(0.05, 0);
    UICorner20.CornerRadius = UDim.new(0.05, 0);
    UICorner20.TopLeftRadius = UDim.new(0.05, 0);
    UICorner20.TopRightRadius = UDim.new(0.05, 0);
    UICorner20.Parent = Frame35;
    local UIGradient10 = Instance.new("UIGradient");
    UIGradient10.Name = "UIGradient";
    UIGradient10.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 132, 121)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 132, 121)) });
    UIGradient10.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8125), NumberSequenceKeypoint.new(1, 1) });
    UIGradient10.Parent = Frame35;
    local TextLabel20 = Instance.new("TextLabel");
    TextLabel20.Name = "WeaponName";
    TextLabel20.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel20.BackgroundTransparency = 1;
    TextLabel20.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel20.Position = UDim2.fromScale(0.5, 0.0818148);
    TextLabel20.Size = UDim2.fromScale(0.8, 0.0609074);
    TextLabel20.Text = "AK-47";
    TextLabel20.TextColor3 = Color3.new(1, 1, 1);
    TextLabel20.TextScaled = true;
    TextLabel20.TextTransparency = 0.7;
    TextLabel20.ZIndex = 5;
    TextLabel20.Parent = Frame35;
    local TextLabel21 = Instance.new("TextLabel");
    TextLabel21.Name = "SkinName";
    TextLabel21.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel21.BackgroundTransparency = 1;
    TextLabel21.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel21.Position = UDim2.fromScale(0.5, 0.132722);
    TextLabel21.Size = UDim2.fromScale(0.8, 0.12);
    TextLabel21.Text = "Versailles";
    TextLabel21.TextColor3 = Color3.new(1, 1, 1);
    TextLabel21.TextScaled = true;
    TextLabel21.ZIndex = 5;
    TextLabel21.Parent = Frame35;
    local ImageLabel14 = Instance.new("ImageLabel");
    ImageLabel14.Name = "Icon";
    ImageLabel14.Active = true;
    ImageLabel14.BackgroundTransparency = 1;
    ImageLabel14.Image = "rbxassetid://83403637591361";
    ImageLabel14.Position = UDim2.fromScale(0, 0.025);
    ImageLabel14.ScaleType = Enum.ScaleType.Fit;
    ImageLabel14.Selectable = true;
    ImageLabel14.Size = UDim2.fromScale(1, 1);
    ImageLabel14.Parent = Frame35;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Remove";
    ImageButton.Active = false;
    ImageButton.AnchorPoint = Vector2.new(1, 0);
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.fromRGB(52, 52, 62);
    ImageButton.Position = UDim2.fromScale(0.98, 0.02);
    ImageButton.Selectable = false;
    ImageButton.Size = UDim2.fromScale(0.1, 0.1);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton.ZIndex = 10;
    local UICorner21 = Instance.new("UICorner");
    UICorner21.Name = "UICorner";
    UICorner21.BottomLeftRadius = UDim.new(1, 0);
    UICorner21.BottomRightRadius = UDim.new(1, 0);
    UICorner21.CornerRadius = UDim.new(1, 0);
    UICorner21.TopLeftRadius = UDim.new(1, 0);
    UICorner21.TopRightRadius = UDim.new(1, 0);
    UICorner21.Parent = ImageButton;
    local ImageLabel15 = Instance.new("ImageLabel");
    ImageLabel15.Name = "ImageLabel";
    ImageLabel15.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel15.BackgroundTransparency = 1;
    ImageLabel15.Image = "rbxassetid://101862988176381";
    ImageLabel15.ImageTransparency = 0.5;
    ImageLabel15.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel15.ScaleType = Enum.ScaleType.Fit;
    ImageLabel15.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel15.Parent = ImageButton;
    ImageButton.Parent = Frame35;
    local Frame36 = Instance.new("Frame");
    Frame36.Name = "Credits";
    Frame36.AnchorPoint = Vector2.new(0.5, 1);
    Frame36.BackgroundTransparency = 1;
    Frame36.Position = UDim2.fromScale(0.5, 0.95);
    Frame36.Size = UDim2.fromScale(0.4, 0.1);
    local TextLabel22 = Instance.new("TextLabel");
    TextLabel22.Name = "Title";
    TextLabel22.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel22.BackgroundTransparency = 1;
    TextLabel22.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel22.Position = UDim2.fromScale(0.5, 0.475);
    TextLabel22.Size = UDim2.fromScale(0.75, 0.8);
    TextLabel22.Text = "1000";
    TextLabel22.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel22.TextScaled = true;
    TextLabel22.Parent = Frame36;
    local ImageLabel16 = Instance.new("ImageLabel");
    ImageLabel16.Name = "ImageLabel";
    ImageLabel16.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel16.BackgroundTransparency = 1;
    ImageLabel16.Image = "rbxassetid://138240378050344";
    ImageLabel16.Position = UDim2.fromScale(1, 0.5);
    ImageLabel16.ScaleType = Enum.ScaleType.Fit;
    ImageLabel16.Size = UDim2.fromScale(1, 1);
    ImageLabel16.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel16.Parent = Frame36;
    Frame36.Parent = Frame35;
    Frame35.Parent = Frame34;
    Frame34.Parent = Frame33;
    Frame33.Parent = Center;
    local Frame37 = Instance.new("Frame");
    Frame37.Name = "Exchange";
    Frame37.AnchorPoint = Vector2.new(1, 0.5);
    Frame37.BackgroundTransparency = 1;
    Frame37.Position = UDim2.fromScale(0.9, 0.5);
    Frame37.Size = UDim2.fromScale(1, 1);
    Frame37.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local Frame38 = Instance.new("Frame");
    Frame38.Name = "Frame";
    Frame38.AnchorPoint = Vector2.new(0.5, 0);
    Frame38.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame38.Position = UDim2.fromScale(0.5, 0);
    Frame38.Size = UDim2.fromScale(0.85, 0.85);
    Frame38.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner22 = Instance.new("UICorner");
    UICorner22.Name = "UICorner";
    UICorner22.BottomLeftRadius = UDim.new(0.05, 0);
    UICorner22.BottomRightRadius = UDim.new(0.05, 0);
    UICorner22.CornerRadius = UDim.new(0.05, 0);
    UICorner22.TopLeftRadius = UDim.new(0.05, 0);
    UICorner22.TopRightRadius = UDim.new(0.05, 0);
    UICorner22.Parent = Frame38;
    local UIStroke11 = Instance.new("UIStroke");
    UIStroke11.Name = "UIStroke";
    UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke11.Color = Color3.fromRGB(94, 94, 113);
    UIStroke11.Thickness = 1.3;
    UIStroke11.Parent = Frame38;
    local ImageLabel17 = Instance.new("ImageLabel");
    ImageLabel17.Name = "ShineBG";
    ImageLabel17.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel17.BackgroundTransparency = 1;
    ImageLabel17.Image = "rbxassetid://8119252523";
    ImageLabel17.ImageColor3 = Color3.fromRGB(236, 199, 76);
    ImageLabel17.ImageTransparency = 0.8;
    ImageLabel17.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel17.Size = UDim2.fromScale(1, 1);
    ImageLabel17.ZIndex = -1;
    ImageLabel17.Parent = Frame38;
    local ImageLabel18 = Instance.new("ImageLabel");
    ImageLabel18.Name = "WeaponBG";
    ImageLabel18.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel18.BackgroundTransparency = 1;
    ImageLabel18.Image = "rbxassetid://90180761681953";
    ImageLabel18.ImageColor3 = Color3.new();
    ImageLabel18.ImageTransparency = 0.6;
    ImageLabel18.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel18.Rotation = 15;
    ImageLabel18.ScaleType = Enum.ScaleType.Fit;
    ImageLabel18.Size = UDim2.fromScale(1, 1);
    ImageLabel18.ZIndex = -1;
    ImageLabel18.Parent = Frame38;
    local TextLabel23 = Instance.new("TextLabel");
    TextLabel23.Name = "Title";
    TextLabel23.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel23.BackgroundTransparency = 1;
    TextLabel23.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel23.Position = UDim2.fromScale(0.5, 0.05);
    TextLabel23.Size = UDim2.fromScale(0.8, 0.06);
    TextLabel23.Text = "Select an item to upgrade";
    TextLabel23.TextColor3 = Color3.new(1, 1, 1);
    TextLabel23.TextScaled = true;
    TextLabel23.Parent = Frame38;
    local Frame39 = Instance.new("Frame");
    Frame39.Name = "Item";
    Frame39.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame39.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame39.Position = UDim2.fromScale(0.5, 0.5);
    Frame39.Size = UDim2.fromScale(1, 1);
    Frame39.Visible = false;
    local UICorner23 = Instance.new("UICorner");
    UICorner23.Name = "UICorner";
    UICorner23.BottomLeftRadius = UDim.new(0.05, 0);
    UICorner23.BottomRightRadius = UDim.new(0.05, 0);
    UICorner23.CornerRadius = UDim.new(0.05, 0);
    UICorner23.TopLeftRadius = UDim.new(0.05, 0);
    UICorner23.TopRightRadius = UDim.new(0.05, 0);
    UICorner23.Parent = Frame39;
    local UIGradient11 = Instance.new("UIGradient");
    UIGradient11.Name = "UIGradient";
    UIGradient11.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 132, 121)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 132, 121)) });
    UIGradient11.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8125), NumberSequenceKeypoint.new(1, 1) });
    UIGradient11.Parent = Frame39;
    local TextLabel24 = Instance.new("TextLabel");
    TextLabel24.Name = "WeaponName";
    TextLabel24.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel24.BackgroundTransparency = 1;
    TextLabel24.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel24.Position = UDim2.fromScale(0.5, 0.0818148);
    TextLabel24.Size = UDim2.fromScale(0.8, 0.0609074);
    TextLabel24.Text = "AK-47";
    TextLabel24.TextColor3 = Color3.new(1, 1, 1);
    TextLabel24.TextScaled = true;
    TextLabel24.TextTransparency = 0.7;
    TextLabel24.ZIndex = 5;
    TextLabel24.Parent = Frame39;
    local TextLabel25 = Instance.new("TextLabel");
    TextLabel25.Name = "SkinName";
    TextLabel25.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel25.BackgroundTransparency = 1;
    TextLabel25.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel25.Position = UDim2.fromScale(0.5, 0.132722);
    TextLabel25.Size = UDim2.fromScale(0.8, 0.12);
    TextLabel25.Text = "Versailles";
    TextLabel25.TextColor3 = Color3.new(1, 1, 1);
    TextLabel25.TextScaled = true;
    TextLabel25.ZIndex = 5;
    TextLabel25.Parent = Frame39;
    local ImageLabel19 = Instance.new("ImageLabel");
    ImageLabel19.Name = "Icon";
    ImageLabel19.Active = true;
    ImageLabel19.BackgroundTransparency = 1;
    ImageLabel19.Image = "rbxassetid://83403637591361";
    ImageLabel19.Position = UDim2.fromScale(0, 0.025);
    ImageLabel19.ScaleType = Enum.ScaleType.Fit;
    ImageLabel19.Selectable = true;
    ImageLabel19.Size = UDim2.fromScale(1, 1);
    ImageLabel19.Parent = Frame39;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Remove";
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(1, 0);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.BackgroundColor3 = Color3.fromRGB(52, 52, 62);
    ImageButton2.Position = UDim2.fromScale(0.98, 0.02);
    ImageButton2.Selectable = false;
    ImageButton2.Size = UDim2.fromScale(0.1, 0.1);
    ImageButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton2.ZIndex = 10;
    local UICorner24 = Instance.new("UICorner");
    UICorner24.Name = "UICorner";
    UICorner24.BottomLeftRadius = UDim.new(1, 0);
    UICorner24.BottomRightRadius = UDim.new(1, 0);
    UICorner24.CornerRadius = UDim.new(1, 0);
    UICorner24.TopLeftRadius = UDim.new(1, 0);
    UICorner24.TopRightRadius = UDim.new(1, 0);
    UICorner24.Parent = ImageButton2;
    local ImageLabel20 = Instance.new("ImageLabel");
    ImageLabel20.Name = "ImageLabel";
    ImageLabel20.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel20.BackgroundTransparency = 1;
    ImageLabel20.Image = "rbxassetid://101862988176381";
    ImageLabel20.ImageTransparency = 0.5;
    ImageLabel20.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel20.ScaleType = Enum.ScaleType.Fit;
    ImageLabel20.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel20.Parent = ImageButton2;
    ImageButton2.Parent = Frame39;
    local Frame40 = Instance.new("Frame");
    Frame40.Name = "Credits";
    Frame40.AnchorPoint = Vector2.new(0.5, 1);
    Frame40.BackgroundTransparency = 1;
    Frame40.Position = UDim2.fromScale(0.5, 0.95);
    Frame40.Size = UDim2.fromScale(0.3, 0.1);
    local TextLabel26 = Instance.new("TextLabel");
    TextLabel26.Name = "Title";
    TextLabel26.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel26.BackgroundTransparency = 1;
    TextLabel26.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel26.Position = UDim2.fromScale(0.325, 0.524999);
    TextLabel26.Size = UDim2.fromScale(0.75, 0.8);
    TextLabel26.Text = "1000";
    TextLabel26.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel26.TextScaled = true;
    TextLabel26.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel26.Parent = Frame40;
    local ImageLabel21 = Instance.new("ImageLabel");
    ImageLabel21.Name = "ImageLabel";
    ImageLabel21.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel21.BackgroundTransparency = 1;
    ImageLabel21.Image = "rbxassetid://138240378050344";
    ImageLabel21.ImageColor3 = Color3.fromRGB(240, 240, 240);
    ImageLabel21.Position = UDim2.fromScale(1, 0.5);
    ImageLabel21.Size = UDim2.fromScale(1, 1);
    ImageLabel21.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel21.Parent = Frame40;
    Frame40.Parent = Frame39;
    Frame39.Parent = Frame38;
    Frame38.Parent = Frame37;
    MultipliersFrame = Instance.new("Frame");
    MultipliersFrame.Name = "Multipliers";
    MultipliersFrame.AnchorPoint = Vector2.new(0.5, 1);
    MultipliersFrame.BackgroundTransparency = 1;
    MultipliersFrame.Position = UDim2.fromScale(0.5, 1);
    MultipliersFrame.Size = UDim2.fromScale(1, 0.15);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.02, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = MultipliersFrame;
    local TextButton5 = Instance.new("TextButton");
    TextButton5.Name = "2x";
    TextButton5.Active = false;
    TextButton5.AnchorPoint = Vector2.new(0.5, 0);
    TextButton5.AutoButtonColor = false;
    TextButton5.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    TextButton5.Position = UDim2.fromScale(0.5, 0);
    TextButton5.Selectable = false;
    TextButton5.TextTransparency = 1;
    TextButton5.Size = UDim2.fromScale(0.1, 0.5);
    local UICorner25 = Instance.new("UICorner");
    UICorner25.Name = "UICorner";
    UICorner25.BottomLeftRadius = UDim.new(0.2, 0);
    UICorner25.BottomRightRadius = UDim.new(0.2, 0);
    UICorner25.CornerRadius = UDim.new(0.2, 0);
    UICorner25.TopLeftRadius = UDim.new(0.2, 0);
    UICorner25.TopRightRadius = UDim.new(0.2, 0);
    UICorner25.Parent = TextButton5;
    local UIStroke12 = Instance.new("UIStroke");
    UIStroke12.Name = "UIStroke";
    UIStroke12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke12.Color = Color3.fromRGB(113, 113, 113);
    UIStroke12.Thickness = 2;
    UIStroke12.Transparency = 0.8;
    UIStroke12.Parent = TextButton5;
    local TextLabel27 = Instance.new("TextLabel");
    TextLabel27.Name = "Title";
    TextLabel27.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel27.BackgroundTransparency = 1;
    TextLabel27.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel27.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel27.Size = UDim2.fromScale(0.8, 0.7);
    TextLabel27.Text = "x2";
    TextLabel27.TextColor3 = Color3.new(1, 1, 1);
    TextLabel27.TextScaled = true;
    TextLabel27.TextTransparency = 0.3;
    TextLabel27.Parent = TextButton5;
    TextButton5.Parent = MultipliersFrame;
    local TextButton6 = Instance.new("TextButton");
    TextButton6.Name = "4x";
    TextButton6.Active = false;
    TextButton6.AnchorPoint = Vector2.new(0.5, 0);
    TextButton6.AutoButtonColor = false;
    TextButton6.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    TextButton6.Position = UDim2.fromScale(0.5, 0);
    TextButton6.Selectable = false;
    TextButton6.Size = UDim2.fromScale(0.1, 0.5);
    TextButton6.TextTransparency = 1;
    local UICorner26 = Instance.new("UICorner");
    UICorner26.Name = "UICorner";
    UICorner26.BottomLeftRadius = UDim.new(0.2, 0);
    UICorner26.BottomRightRadius = UDim.new(0.2, 0);
    UICorner26.CornerRadius = UDim.new(0.2, 0);
    UICorner26.TopLeftRadius = UDim.new(0.2, 0);
    UICorner26.TopRightRadius = UDim.new(0.2, 0);
    UICorner26.Parent = TextButton6;
    local UIStroke13 = Instance.new("UIStroke");
    UIStroke13.Name = "UIStroke";
    UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke13.Color = Color3.fromRGB(113, 113, 113);
    UIStroke13.Thickness = 2;
    UIStroke13.Transparency = 0.8;
    UIStroke13.Parent = TextButton6;
    local TextLabel28 = Instance.new("TextLabel");
    TextLabel28.Name = "Title";
    TextLabel28.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel28.BackgroundTransparency = 1;
    TextLabel28.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel28.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel28.Size = UDim2.fromScale(0.8, 0.7);
    TextLabel28.Text = "x4";
    TextLabel28.TextColor3 = Color3.new(1, 1, 1);
    TextLabel28.TextScaled = true;
    TextLabel28.TextTransparency = 0.3;
    TextLabel28.Parent = TextButton6;
    TextButton6.Parent = MultipliersFrame;
    local TextButton7 = Instance.new("TextButton");
    TextButton7.Name = "8x";
    TextButton7.Active = false;
    TextButton7.AnchorPoint = Vector2.new(0.5, 0);
    TextButton7.AutoButtonColor = false;
    TextButton7.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    TextButton7.Position = UDim2.fromScale(0.5, 0);
    TextButton7.Selectable = false;
    TextButton7.Size = UDim2.fromScale(0.1, 0.5);
    TextButton7.TextTransparency = 1;
    local UICorner27 = Instance.new("UICorner");
    UICorner27.Name = "UICorner";
    UICorner27.BottomLeftRadius = UDim.new(0.2, 0);
    UICorner27.BottomRightRadius = UDim.new(0.2, 0);
    UICorner27.CornerRadius = UDim.new(0.2, 0);
    UICorner27.TopLeftRadius = UDim.new(0.2, 0);
    UICorner27.TopRightRadius = UDim.new(0.2, 0);
    UICorner27.Parent = TextButton7;
    local UIStroke14 = Instance.new("UIStroke");
    UIStroke14.Name = "UIStroke";
    UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke14.Color = Color3.fromRGB(113, 113, 113);
    UIStroke14.Thickness = 2;
    UIStroke14.Transparency = 0.8;
    UIStroke14.Parent = TextButton7;
    local TextLabel29 = Instance.new("TextLabel");
    TextLabel29.Name = "Title";
    TextLabel29.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel29.BackgroundTransparency = 1;
    TextLabel29.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel29.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel29.Size = UDim2.fromScale(0.8, 0.7);
    TextLabel29.Text = "x8";
    TextLabel29.TextColor3 = Color3.new(1, 1, 1);
    TextLabel29.TextScaled = true;
    TextLabel29.TextTransparency = 0.3;
    TextLabel29.Parent = TextButton7;
    TextButton7.Parent = MultipliersFrame;
    local TextButton8 = Instance.new("TextButton");
    TextButton8.Name = "35percents";
    TextButton8.Active = false;
    TextButton8.AnchorPoint = Vector2.new(0.5, 0);
    TextButton8.AutoButtonColor = false;
    TextButton8.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    TextButton8.Position = UDim2.fromScale(0.5, 0);
    TextButton8.Selectable = false;
    TextButton8.Size = UDim2.fromScale(0.1, 0.5);
    TextButton8.TextTransparency = 1;
    local UICorner28 = Instance.new("UICorner");
    UICorner28.Name = "UICorner";
    UICorner28.BottomLeftRadius = UDim.new(0.2, 0);
    UICorner28.BottomRightRadius = UDim.new(0.2, 0);
    UICorner28.CornerRadius = UDim.new(0.2, 0);
    UICorner28.TopLeftRadius = UDim.new(0.2, 0);
    UICorner28.TopRightRadius = UDim.new(0.2, 0);
    UICorner28.Parent = TextButton8;
    local UIStroke15 = Instance.new("UIStroke");
    UIStroke15.Name = "UIStroke";
    UIStroke15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke15.Color = Color3.new(1, 1, 1);
    UIStroke15.Thickness = 2;
    local UIGradient12 = Instance.new("UIGradient");
    UIGradient12.Name = "UIGradient";
    UIGradient12.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 35, 35)), ColorSequenceKeypoint.new(1, Color3.fromRGB(113, 113, 113)) });
    UIGradient12.Rotation = 15;
    UIGradient12.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.51875), NumberSequenceKeypoint.new(0.7, 0.8), NumberSequenceKeypoint.new(1, 0.8) });
    UIGradient12.Parent = UIStroke15;
    UIStroke15.Parent = TextButton8;
    local TextLabel30 = Instance.new("TextLabel");
    TextLabel30.Name = "Title";
    TextLabel30.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel30.BackgroundTransparency = 1;
    TextLabel30.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel30.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel30.Size = UDim2.fromScale(0.8, 0.7);
    TextLabel30.Text = "35%";
    TextLabel30.TextColor3 = Color3.new(1, 1, 1);
    TextLabel30.TextScaled = true;
    TextLabel30.TextTransparency = 0.3;
    TextLabel30.Parent = TextButton8;
    TextButton8.Parent = MultipliersFrame;
    local TextButton9 = Instance.new("TextButton");
    TextButton9.Name = "50percents";
    TextButton9.Active = false;
    TextButton9.AnchorPoint = Vector2.new(0.5, 0);
    TextButton9.AutoButtonColor = false;
    TextButton9.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    TextButton9.Position = UDim2.fromScale(0.5, 0);
    TextButton9.Selectable = false;
    TextButton9.Size = UDim2.fromScale(0.1, 0.5);
    TextButton9.TextTransparency = 1;
    local UICorner29 = Instance.new("UICorner");
    UICorner29.Name = "UICorner";
    UICorner29.BottomLeftRadius = UDim.new(0.2, 0);
    UICorner29.BottomRightRadius = UDim.new(0.2, 0);
    UICorner29.CornerRadius = UDim.new(0.2, 0);
    UICorner29.TopLeftRadius = UDim.new(0.2, 0);
    UICorner29.TopRightRadius = UDim.new(0.2, 0);
    UICorner29.Parent = TextButton9;
    local TextLabel31 = Instance.new("TextLabel");
    TextLabel31.Name = "Title";
    TextLabel31.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel31.BackgroundTransparency = 1;
    TextLabel31.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel31.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel31.Size = UDim2.fromScale(0.8, 0.7);
    TextLabel31.Text = "50%";
    TextLabel31.TextColor3 = Color3.new(1, 1, 1);
    TextLabel31.TextScaled = true;
    TextLabel31.TextTransparency = 0.3;
    TextLabel31.Parent = TextButton9;
    local UIStroke16 = Instance.new("UIStroke");
    UIStroke16.Name = "UIStroke";
    UIStroke16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke16.Color = Color3.new(1, 1, 1);
    UIStroke16.Thickness = 2;
    local UIGradient13 = Instance.new("UIGradient");
    UIGradient13.Name = "UIGradient";
    UIGradient13.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 207, 32)), ColorSequenceKeypoint.new(1, Color3.fromRGB(113, 113, 113)) });
    UIGradient13.Rotation = 15;
    UIGradient13.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.51875), NumberSequenceKeypoint.new(0.7, 0.8), NumberSequenceKeypoint.new(1, 0.8) });
    UIGradient13.Parent = UIStroke16;
    UIStroke16.Parent = TextButton9;
    TextButton9.Parent = MultipliersFrame;
    local TextButton10 = Instance.new("TextButton");
    TextButton10.Name = "60percents";
    TextButton10.Active = false;
    TextButton10.AnchorPoint = Vector2.new(0.5, 0);
    TextButton10.AutoButtonColor = false;
    TextButton10.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    TextButton10.Position = UDim2.fromScale(0.5, 0);
    TextButton10.Selectable = false;
    TextButton10.Size = UDim2.fromScale(0.1, 0.5);
    TextButton10.TextTransparency = 1;
    local UICorner30 = Instance.new("UICorner");
    UICorner30.Name = "UICorner";
    UICorner30.BottomLeftRadius = UDim.new(0.2, 0);
    UICorner30.BottomRightRadius = UDim.new(0.2, 0);
    UICorner30.CornerRadius = UDim.new(0.2, 0);
    UICorner30.TopLeftRadius = UDim.new(0.2, 0);
    UICorner30.TopRightRadius = UDim.new(0.2, 0);
    UICorner30.Parent = TextButton10;
    local TextLabel32 = Instance.new("TextLabel");
    TextLabel32.Name = "Title";
    TextLabel32.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel32.BackgroundTransparency = 1;
    TextLabel32.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel32.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel32.Size = UDim2.fromScale(0.8, 0.7);
    TextLabel32.Text = "60%";
    TextLabel32.TextColor3 = Color3.new(1, 1, 1);
    TextLabel32.TextScaled = true;
    TextLabel32.TextTransparency = 0.3;
    TextLabel32.Parent = TextButton10;
    local UIStroke17 = Instance.new("UIStroke");
    UIStroke17.Name = "UIStroke";
    UIStroke17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke17.Color = Color3.new(1, 1, 1);
    UIStroke17.Thickness = 2;
    local UIGradient14 = Instance.new("UIGradient");
    UIGradient14.Name = "UIGradient";
    UIGradient14.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 255, 46)), ColorSequenceKeypoint.new(1, Color3.fromRGB(113, 113, 113)) });
    UIGradient14.Rotation = 15;
    UIGradient14.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.51875), NumberSequenceKeypoint.new(0.7, 0.8), NumberSequenceKeypoint.new(1, 0.8) });
    UIGradient14.Parent = UIStroke17;
    UIStroke17.Parent = TextButton10;
    TextButton10.Parent = MultipliersFrame;
    MultipliersFrame.Parent = Frame37;
    Frame37.Parent = Center;
    local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint3.AspectRatio = 4;
    UIAspectRatioConstraint3.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint3.Parent = Center;
    u18 = {
        Inventory = Center.Item.Frame,
        Exchange = Center.Exchange.Frame
    };
    Center.Parent = p110;
end;

return u1;