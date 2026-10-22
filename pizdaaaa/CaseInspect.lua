-- ReplicatedStorage.GameClient.Gui.MainMenu.Utils.CaseInspect
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.Utils.CaseInspect
-- Decompile time: 74.94 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    Container = nil,
    onCooldown = false
};
local TweenService = game:GetService("TweenService");
game:GetService("TextService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("Workspace");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
game:GetService("UserInputService");
local Lighting = game:GetService("Lighting");
local PolicyService = game:GetService("PolicyService");
local MarketplaceService = game:GetService("MarketplaceService");
local HttpService = game:GetService("HttpService");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local TweenInfo_new_ret = TweenInfo.new(0.25);
local LocalPlayer = Players.LocalPlayer;
local Idle = ReplicatedStorage.Assets.Idle;

local function HasRobloxSubscription() -- Line: 32
    -- upvalues: RunService (copy), LocalPlayer (copy)
    return RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription;
end;

local u8 = nil;

if RunService:IsStudio() then
    u8 = {
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
    task.spawn(function() -- Line: 54
        -- upvalues: PolicyService (copy), LocalPlayer (copy), u8 (ref)
        local success, result = pcall(function() -- Line: 55
            -- upvalues: PolicyService (ref), LocalPlayer (ref)
            return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer);
        end);
        u8 = success and result and result or {
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

local function GetPolicyInfo() -- Line: 73
    -- upvalues: u8 (ref)
    while not u8 do
        task.wait();
    end;

    return u8;
end;

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
local u27 = 0;

local function CaseRNG(p28, p29) -- Line: 102
    -- upvalues: u21 (ref)
    return u21.OpenCase({
        Data = p28,
        Chances = p29
    }).ItemKey;
end;

function u1.CaseBuy(u30, u31, u32) -- Line: 111
    -- upvalues: u5 (ref), u8 (ref), u23 (ref), RunService (copy), LocalPlayer (copy), u19 (ref), u12 (ref), u22 (ref), u18 (ref), u20 (ref), u10 (ref), u3 (ref), u7 (ref)
    local v33 = u30 ~= nil;
    u5.Credits.Visible = v33;
    u5.Slider.Visible = v33;

    while not u8 do
        task.wait();
    end;

    local u34 = not u8.ArePaidRandomItemsRestricted;

    if u34 then
        u5.Robux.Visible = u5.Credits.Visible;
        u5.Gift.Visible = u5.Credits.Visible;
    else
        u5.Robux.Visible = false;
        u5.Gift.Visible = false;
    end;

    if not v33 then
        u23:Clear();
        u7.Enabled("CaseInspect", false);

        for i, _ in { u5.Credits, u5.Robux, u5.Gift } do
            u3:Removes(`{i}_Price_MouseEnter`, `{i}_Price_MouseLeave`, (`{i}_Price_Button1Click`));
        end;

        u3:Removes("CaseAmount", "PostRender");
        Page.Visible = false;

        return;
    end;

    if u32 and u34 then
        u23.Preload(u32);
        local v35 = u32[1];
        local ProductInfo = u23.GetProductInfo(v35);
        u23:DrawRobux(u5.Robux, v35, (ProductInfo and ProductInfo.PriceInRobux or 50) * 1);
        u23:DrawGift(u5.Gift, v35);
    end;

    local u36;

    if RunService:IsStudio() and true or LocalPlayer.HasRobloxSubscription then
        u36 = math.floor(u30 * 0.9) or u30;
    else
        u36 = u30;
    end;

    u23:DrawCredits(u5.Credits, u30, function() -- Line: 143
        -- upvalues: u5 (ref), u19 (ref), u36 (copy), u12 (ref), u22 (ref), u31 (copy), u18 (ref), u20 (ref)
        local u37 = tonumber(u5.Slider.Value.TextBox.Text) or 1;

        if u19.Get("Credits") < u36 * u37 then
            u12:Create("Not Enough Credits", Color3.fromRGB(255, 151, 153));

            return;
        end;

        u22:Create("Item Purchase", `Are you sure you want to purchase {u37} {u31}?`, function(p38) -- Line: 152
            -- upvalues: u18 (ref), u20 (ref), u31 (ref), u37 (copy), u12 (ref), u36 (ref)
            u18.Gui.BuyStoreItem.Fire({
                C = u20.InventoryCategoriesNum.Containers,
                I = u31,
                A = u37 + (p38 and u20.PayLocked or 0)
            });
            u12:Create(`-${u36 * u37}`, Color3.fromRGB(255, 151, 153));
            task.delay(0.2, function() -- Line: 160
                -- upvalues: u12 (ref), u37 (ref), u31 (ref)
                u12:Create(`+{u37} Container{u37 > 1 and "s" or ""} | {u31}`, Color3.fromRGB(117, 172, 255));
            end);
        end, u36 * u37);
    end);
    u5.Slider.Value.TextBox.Text = "1";
    u10.SetDefault();
    u3:Add("PostRender", RunService.PreRender:Connect(function() -- Line: 169
        -- upvalues: u7 (ref)
        u7.Update(true);
    end));
    u3:Add("CaseAmount", u5.Slider.Value.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 173
        -- upvalues: u5 (ref), u32 (copy), u34 (copy), u23 (ref), u30 (copy), u19 (ref), u36 (copy), u12 (ref), u22 (ref), u31 (copy), u18 (ref), u20 (ref)
        local u39 = tonumber(u5.Slider.Value.TextBox.Text) or 1;

        if u32 and u34 then
            local v40 = u32[u39];
            local ProductInfo = u23.GetProductInfo(u32[1]);
            u23:DrawRobux(u5.Robux, v40, (ProductInfo and ProductInfo.PriceInRobux or 50) * u39);
            u23:DrawGift(u5.Gift, v40);
        end;

        u23:DrawCredits(u5.Credits, u30 * u39, function() -- Line: 185
            -- upvalues: u5 (ref), u19 (ref), u36 (ref), u39 (copy), u12 (ref), u22 (ref), u31 (ref), u18 (ref), u20 (ref)
            local _ = tonumber(u5.Slider.Value.TextBox.Text) or 1;

            if u19.Get("Credits") < u36 * u39 then
                u12:Create("Not Enough Credits", Color3.fromRGB(255, 151, 153));

                return;
            end;

            u22:Create("Item Purchase", `Are you sure you want to purchase {u39} {u31}?`, function(p41) -- Line: 194
                -- upvalues: u18 (ref), u20 (ref), u31 (ref), u39 (ref), u12 (ref), u36 (ref)
                u18.Gui.BuyStoreItem.Fire({
                    C = u20.InventoryCategoriesNum.Containers,
                    I = u31,
                    A = u39 + (p41 and u20.PayLocked or 0)
                });
                u12:Create(`-${u36 * u39}`, Color3.fromRGB(255, 151, 153));
                task.delay(0.2, function() -- Line: 202
                    -- upvalues: u12 (ref), u39 (ref), u31 (ref)
                    u12:Create(`+{u39} Container{u39 > 1 and "s" or ""} | {u31}`, Color3.fromRGB(117, 172, 255));
                end);
            end, u36 * u39);
        end);
    end));
    Page.Visible = true;
end;

local u42 = false;
local u43 = 1;
local u44 = false;

local function GetOwnedContainers(p45) -- Line: 248
    -- upvalues: u26 (ref)
    local v46 = 0;

    for _ in u26.Get().Containers[p45] or {} do
        v46 = v46 + 1;
    end;

    return v46;
end;

local function DrawAmounts(p47) -- Line: 258
    -- upvalues: u26 (ref), u21 (ref), u19 (ref), u43 (ref), u5 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    local v48 = 0;

    for _ in u26.Get().Containers[p47] or {} do
        v48 = v48 + 1;
    end;

    local MaxOpen = u21.GetMaxOpen(u19.Get("Gamepasses"));
    local math_min_ret = math.min(v48, MaxOpen);
    local math_max_ret = math.max(math_min_ret, 1);
    u43 = math.clamp(u43, 1, math_max_ret);

    for i = 1, u21.MaxOpen do
        local v49 = u5.Amount[tostring(i)];
        local v50 = i == u43;
        TweenService:Create(v49, TweenInfo_new_ret, {
            BackgroundColor3 = v50 and Color3.fromRGB(15, 158, 87) or Color3.new(1, 1, 1),
            BackgroundTransparency = v50 and 0 or 0.95
        }):Play();
        v49.Title.TextTransparency = i <= v48 and i <= MaxOpen and 0 or 0.7;
        v49.Locked.Visible = MaxOpen < i;
        local _ = i;
    end;

    u5.Unlock.TextConfirm.Text = u43 > 1 and `UNLOCK {u43} CONTAINERS` or "UNLOCK CONTAINER";
end;

function u1.CaseOpen(u51) -- Line: 275
    -- upvalues: u5 (ref), u7 (ref), u3 (ref), RunService (copy), TweenService (copy), TweenInfo_new_ret (copy), u1 (copy), u42 (ref), u43 (ref), u26 (ref), u12 (ref), u27 (ref), u18 (ref), u44 (ref), DrawAmounts (copy), u19 (ref), u21 (ref), MarketplaceService (copy), LocalPlayer (copy), u25 (ref)
    local Unlock = u5.Unlock;
    local Amount = u5.Amount;
    local v52 = u51 ~= nil;
    Unlock.Visible = v52;
    Amount.Visible = v52;

    if not v52 then
        u7.Enabled("CaseInspect", false);
        u3:Removes("UnEnter", "UnLeave", "UnClick", "PostRender", "AmountUpdate", "AmountPasses");

        for i = 1, u21.MaxOpen do
            u3:Removes(`Amount{i}Enter`, `Amount{i}Leave`, (`Amount{i}Click`));
            local _ = i;
        end;

        return;
    end;

    u7.Enabled("CaseInspect", true);
    u3:Add("PostRender", RunService.PreRender:Connect(function() -- Line: 290
        -- upvalues: u7 (ref)
        u7.Update(true);
    end));
    u3:Add("UnEnter", Unlock.MouseEnter:Connect(function() -- Line: 293
        -- upvalues: TweenService (ref), Unlock (copy), TweenInfo_new_ret (ref)
        if RareItems.Visible then
            return;
        end;

        TweenService:Create(Unlock, TweenInfo_new_ret, {
            BackgroundColor3 = Color3.fromRGB(18, 188, 103)
        }):Play();
    end));
    u3:Add("UnLeave", Unlock.MouseLeave:Connect(function() -- Line: 301
        -- upvalues: TweenService (ref), Unlock (copy), TweenInfo_new_ret (ref)
        TweenService:Create(Unlock, TweenInfo_new_ret, {
            BackgroundColor3 = Color3.fromRGB(15, 158, 87)
        }):Play();
    end));
    u3:Add("UnClick", Unlock.MouseButton1Click:Connect(function() -- Line: 305
        -- upvalues: u1 (ref), u42 (ref), u43 (ref), u51 (copy), u26 (ref), u12 (ref), u27 (ref), u18 (ref), u44 (ref)
        if not (u1.onCooldown or u42) then
            local v53 = 0;

            for _ in u26.Get().Containers[u51] or {} do
                v53 = v53 + 1;
            end;

            if v53 < u43 then
                u12:Create("Not Enough Containers", Color3.fromRGB(255, 151, 153));

                return;
            end;

            u1.onCooldown = true;
            u27 = u27 + 1;
            local u54 = u27;
            u18.Gui.OpenContainer.Fire({
                C = u44 and `{u51}:{u43}:Locked` or `{u51}:{u43}`
            });
            task.delay(15, function() -- Line: 325
                -- upvalues: u27 (ref), u54 (copy), u1 (ref)
                if u27 == u54 then
                    u1.onCooldown = false;
                end;
            end);
        end;
    end));
    u43 = 1;
    DrawAmounts(u51);
    u3:Add("AmountUpdate", u26.Updated:Connect(function() -- Line: 336
        -- upvalues: DrawAmounts (ref), u51 (copy)
        DrawAmounts(u51);
    end));
    u3:Add("AmountPasses", u19.Changed("Gamepasses"):Connect(function() -- Line: 340
        -- upvalues: DrawAmounts (ref), u51 (copy)
        DrawAmounts(u51);
    end));

    for i = 1, u21.MaxOpen do
        local u55 = Amount[tostring(i)];
        u3:Add(`Amount{i}Enter`, u55.MouseEnter:Connect(function() -- Line: 347
            -- upvalues: i (copy), u43 (ref), TweenService (ref), u55 (copy), TweenInfo_new_ret (ref)
            if i == u43 then
                return;
            end;

            TweenService:Create(u55, TweenInfo_new_ret, {
                BackgroundTransparency = 0.9
            }):Play();
        end));
        u3:Add(`Amount{i}Leave`, u55.MouseLeave:Connect(function() -- Line: 355
            -- upvalues: i (copy), u43 (ref), TweenService (ref), u55 (copy), TweenInfo_new_ret (ref)
            if i == u43 then
                return;
            end;

            TweenService:Create(u55, TweenInfo_new_ret, {
                BackgroundTransparency = 0.95
            }):Play();
        end));
        u3:Add(`Amount{i}Click`, u55.MouseButton1Click:Connect(function() -- Line: 363
            -- upvalues: u1 (ref), u42 (ref), i (copy), u21 (ref), u19 (ref), MarketplaceService (ref), LocalPlayer (ref), u51 (copy), u26 (ref), u12 (ref), u43 (ref), DrawAmounts (ref), u25 (ref)
            if u1.onCooldown or u42 then
                return;
            end;

            if i > u21.GetMaxOpen(u19.Get("Gamepasses")) then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, (u21.GetOpenPass(i, u19.Get("Gamepasses"))));

                return;
            end;

            local v56 = 0;

            for _ in u26.Get().Containers[u51] or {} do
                v56 = v56 + 1;
            end;

            if v56 < i then
                u12:Create("Not Enough Containers", Color3.fromRGB(255, 151, 153));

                return;
            end;

            u43 = i;
            DrawAmounts(u51);
            u25.Play("UI.submenu_dropdown_option_select");
        end));
        local _ = i;
    end;
end;

local u57 = false;
local u58 = false;
local u59 = false;
local u60 = {};
local u61 = nil;

local function PlayReelTween(p62, p63, p64) -- Line: 412
    -- upvalues: TweenService (copy), u60 (copy)
    local v65 = TweenService:Create(p62, p63, p64);
    table.insert(u60, v65);
    v65:Play();
end;

local CFrame_new_ret = CFrame.new(
    2.87988281,
    -0.360549927,
    0.0380859375,
    0.804406762,
    0,
    -0.594079018,
    0.00891648885,
    0.999887466,
    0.012073284,
    0.594012022,
    -0.0150089292,
    0.804316163
);
local CFrame_new_ret2 = CFrame.new(
    -0.384765625,
    -0.819229126,
    -0.0712890625,
    -0.148758769,
    0,
    0.988873601,
    -0.0148419328,
    0.999887466,
    -0.00223270943,
    -0.9887622,
    -0.0150089292,
    -0.14874199
);
local u66 = nil;
local u67 = nil;
local u68 = nil;
local u69 = nil;
local u70 = {};

local function PlayModelTrack(p71) -- Line: 426
    -- upvalues: Idle (copy), u66 (ref)
    Idle.AnimationId = `rbxassetid://{p71}`;
    local v72 = u66.AnimationController.Animator:LoadAnimation(Idle);
    v72.Looped = false;
    v72.Priority = Enum.AnimationPriority.Action2;
    v72:Play();

    return v72;
end;

local function Ease(p73, p74, p75) -- Line: 437
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(math.clamp(p73, 0, 1), p74, p75);
end;

local function PoseCapsule(p76, p77, p78, p79) -- Line: 441
    -- upvalues: u70 (copy), u69 (ref)
    for i, v in u70 do
        local v80;

        if i.Name == "CapsuleTop" then
            v80 = p76 * p77;
            i.Transparency = v.Transparency + (1 - v.Transparency) * p78;
        elseif i.Name == "CapsulePlane" then
            v80 = p76 * p79;
        else
            v80 = p76;
        end;

        i.CFrame = u69 * v80 * v.Offset;
    end;
end;

local function RunModelAnimation(u81) -- Line: 456
    -- upvalues: u3 (ref), RunService (copy)
    local os_clock_ret = os.clock();
    u3:Add("ModelAnimation", RunService.PreRender:Connect(function() -- Line: 459
        -- upvalues: u81 (copy), os_clock_ret (copy)
        u81(os.clock() - os_clock_ret);
    end));
end;

local u95 = {
    Cases = {
        Show = function() -- Line: 466, Name: Show
            -- upvalues: u68 (ref), Idle (copy), u66 (ref)
            Idle.AnimationId = `rbxassetid://{u68.Animations.Show}`;
            local v82 = u66.AnimationController.Animator:LoadAnimation(Idle);
            v82.Looped = false;
            v82.Priority = Enum.AnimationPriority.Action2;
            v82:Play();
        end,

        Open = function() -- Line: 470, Name: Open
            -- upvalues: u68 (ref), Idle (copy), u66 (ref)
            Idle.AnimationId = `rbxassetid://{u68.Animations.Open}`;
            local u83 = u66.AnimationController.Animator:LoadAnimation(Idle);
            u83.Looped = false;
            u83.Priority = Enum.AnimationPriority.Action2;
            u83:Play();

            return function() -- Line: 473
                -- upvalues: u83 (copy)
                u83:Stop();
            end;
        end
    },
    Capsules = {
        Show = function() -- Line: 480, Name: Show
            -- upvalues: TweenService (copy), PoseCapsule (copy), u3 (ref), RunService (copy)
            local function u89(p84) -- Line: 481
                -- upvalues: TweenService (ref), PoseCapsule (ref)
                local math_clamp_ret = math.clamp(p84 / 0.32, 0, 1);
                local math_max_ret = math.max(p84 - 0.32, 0);
                local math_sin_ret = math.sin(math_max_ret * 11);
                local v85 = math.abs(math_sin_ret) * 0.55 * math.exp(-math_max_ret * 5);
                local v86 = math.sin(math_max_ret * 14) * 0.2792526803190927 * math.exp(-math_max_ret * 4.5) * math.min(math_max_ret * 20, 1);
                local Quint = Enum.EasingStyle.Quint;
                local Out = Enum.EasingDirection.Out;
                local v87 = (1 - TweenService:GetValue(math.clamp(p84 / 1.1, 0, 1), Quint, Out)) * -3.839724354387525;
                local math_max_ret2 = math.max(p84 - 1.4, 0);
                local v88 = math.sin(math_max_ret2 * 1.4) * 0.06981317007977318 * math.min(math_max_ret2, 1);
                PoseCapsule(CFrame.new(0, (1 - math_clamp_ret * math_clamp_ret) * 4 + v85, 0) * CFrame.Angles((1 - math_clamp_ret) * -0.5235987755982988 + v86 * 0.6, v87 + v88, v86), CFrame.identity, 0, CFrame.identity);
            end;

            local os_clock_ret = os.clock();
            u3:Add("ModelAnimation", RunService.PreRender:Connect(function() -- Line: 459
                -- upvalues: u89 (copy), os_clock_ret (copy)
                u89(os.clock() - os_clock_ret);
            end));
        end,

        Open = function() -- Line: 495, Name: Open
            -- upvalues: u67 (ref), u69 (ref), TweenService (copy), PoseCapsule (copy), Ease (copy), u3 (ref), RunService (copy)
            local Camera = u67.Camera;
            local CFrame2 = Camera.CFrame;
            local v90 = u69.Position + Vector3.new(0, 0.6, 0);
            local CFrame_lookAt_ret = CFrame.lookAt(CFrame2.Position:Lerp(v90, 0.3), v90);

            local function u94(p91) -- Line: 501
                -- upvalues: TweenService (ref), PoseCapsule (ref), Camera (copy), CFrame2 (copy), CFrame_lookAt_ret (copy), Ease (ref)
                local v92 = math.sin(p91 * 55) * 0.12217304763960307 * math.clamp(p91 / 0.6, 0, 1);
                local Quad = Enum.EasingStyle.Quad;
                local Out = Enum.EasingDirection.Out;
                local v93 = v92 * (1 - TweenService:GetValue(math.clamp((p91 - 0.6) / 0.5, 0, 1), Quad, Out));
                local Quad2 = Enum.EasingStyle.Quad;
                local InOut = Enum.EasingDirection.InOut;
                local Value = TweenService:GetValue(math.clamp((p91 - 0.6) / 0.5, 0, 1), Quad2, InOut);
                local Quart = Enum.EasingStyle.Quart;
                local Out2 = Enum.EasingDirection.Out;
                local Value2 = TweenService:GetValue(math.clamp((p91 - 1.1) / 0.6, 0, 1), Quart, Out2);
                local Back = Enum.EasingStyle.Back;
                local Out3 = Enum.EasingDirection.Out;
                local Value3 = TweenService:GetValue(math.clamp((p91 - 1.1) / 0.9, 0, 1), Back, Out3);
                PoseCapsule(CFrame.new(0, math.clamp(p91 / 0.6, 0, 1) * -0.06 * (1 - Value), 0) * CFrame.Angles(v93 * 0.4, 0, v93), CFrame.new(0, Value * 0.35 + Value2 * 4, -Value2 * 1.5) * CFrame.Angles(-Value2 * 0.6981317007977318, Value * 4.1887902047863905 + Value2 * 3.141592653589793, 0), Value2, CFrame.new(0, Value3 * 0.9, 0) * CFrame.Angles(0, Value3 * 3.141592653589793 * 2, 0));
                Camera.CFrame = CFrame2:Lerp(CFrame_lookAt_ret, Ease(p91 / 1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out));
            end;

            local os_clock_ret = os.clock();
            u3:Add("ModelAnimation", RunService.PreRender:Connect(function() -- Line: 459
                -- upvalues: u94 (copy), os_clock_ret (copy)
                u94(os.clock() - os_clock_ret);
            end));

            return function() -- Line: 515
                -- upvalues: u3 (ref), PoseCapsule (ref), Camera (copy), CFrame2 (copy)
                u3:Removes("ModelAnimation");
                PoseCapsule(CFrame.identity, CFrame.identity, 0, CFrame.identity);
                Camera.CFrame = CFrame2;
            end;
        end
    }
};

local function DestroyModel() -- Line: 524
    -- upvalues: u3 (ref), u66 (ref)
    u3:Removes("ModelAnimation");

    if u66 then
        u66:Destroy();
        u66 = nil;
    end;
end;

local function SpawnModel(p96, p97) -- Line: 533
    -- upvalues: u3 (ref), u66 (ref), u67 (ref), u68 (ref), CFrame_new_ret (copy), u69 (ref), u70 (copy), u95 (copy)
    u3:Removes("ModelAnimation");

    if u66 then
        u66:Destroy();
        u66 = nil;
    end;

    u67 = p96;
    u68 = p97;
    u66 = p97.Model:Clone();
    u66:PivotTo(p96.Root.CFrame * CFrame_new_ret);
    u66.Parent = p96;
    u69 = u66:GetPivot();
    table.clear(u70);

    for _, descendant in u66:GetDescendants() do
        if descendant:IsA("BasePart") then
            u70[descendant] = {
                Offset = u69:ToObjectSpace(descendant.CFrame),
                Transparency = descendant.Transparency
            };
        end;
    end;

    u95[p97.Category].Show();
end;

function u1.PlaceRig(p98, p99) -- Line: 553
    -- upvalues: CFrame_new_ret2 (copy)
    p98.Rig.Rig:PivotTo(p98.Root.CFrame * CFrame_new_ret2 + (p99 and Vector3.new(0, 0, 0) or Vector3.new(0, 77, 0)));
end;

function u1.SetModelVisible(p100) -- Line: 557
    -- upvalues: u66 (ref), u67 (ref)
    u66.Parent = p100 and u67 or nil;
end;

local function GetScrollerContainer(p101) -- Line: 561
    -- upvalues: u21 (ref)
    if p101.Items then
        local v102 = {};

        for _, v in p101.Items do
            if v.Rarity ~= "Exceeding Rare" then
                table.insert(v102, v);
            end;
        end;

        return {
            Name = p101.Name,
            Items = v102,
            Chances = {
                ["Exceeding Rare"] = 0
            },
            KillTrackChance = p101.KillTrackChance
        };
    end;

    if not p101.Data then
        return p101;
    end;

    local v103 = {};

    for i, v in p101.Data do
        if i ~= "Exceeding Rare" then
            v103[i] = v;
        end;
    end;

    return u21.NormalizeCaseData({
        Data = v103,
        Category = p101.Category,
        Chances = {
            ["Exceeding Rare"] = 0
        },
        KillTrackChance = p101.KillTrackChance
    });
end;

local function BeginReel() -- Line: 593
    -- upvalues: u1 (copy), u42 (ref), u4 (ref), TweenService (copy), u60 (copy), u95 (copy), u68 (ref)
    u1.VisibleRareItems(false, nil, true);
    u1.ClearResults();
    u42 = true;
    local v104 = TweenService:Create(u4.InventoryInspect.Chances, TweenInfo.new(0.75), {
        AnchorPoint = Vector2.new(1, 1)
    });
    table.insert(u60, v104);
    v104:Play();
    local v105 = TweenService:Create(u4.InventoryInspect, TweenInfo.new(0.75), {
        Position = UDim2.new(0, 0, 1.5, 0)
    });
    table.insert(u60, v105);
    v105:Play();
    local v106 = TweenService:Create(u4.MainInspect.DownBar, TweenInfo.new(0.75), {
        Position = UDim2.new(0.5, 0, 1.1, 0)
    });
    table.insert(u60, v106);
    v106:Play();
    local SkipBar = u4.MainInspect.SkipBar;
    SkipBar.Skip.BackgroundTransparency = 0.9;
    SkipBar.Visible = true;
    local v107 = TweenService:Create(SkipBar, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0.6), {
        Position = UDim2.new(0.5, 0, 1, 0)
    });
    table.insert(u60, v107);
    v107:Play();
    local v108 = u95[u68.Category].Open();
    local v109 = TweenService:Create(workspace.CurrentCamera, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        FieldOfView = 50
    });
    table.insert(u60, v109);
    v109:Play();

    return v108;
end;

local function EndReel(p110) -- Line: 616
    -- upvalues: u60 (copy), u4 (ref), u3 (ref), u5 (ref), u42 (ref)
    for _, v in u60 do
        v:Cancel();
    end;

    table.clear(u60);
    u4.InventoryInspect.Chances.AnchorPoint = Vector2.new(0, 1);
    u4.InventoryInspect.Position = UDim2.new(0, 0, 1, 0);
    u4.MainInspect.DownBar.Position = UDim2.new(0.5, 0, 1, 0);
    u4.MainInspect.SkipBar.Visible = false;
    u4.MainInspect.SkipBar.Position = UDim2.new(0.5, 0, 1.1, 0);
    u3:Removes("CaseClose", "CaseMouseEnter", "CaseMouseLeave", "ScrollerScrolling");
    task.delay(0.5, function() -- Line: 631
        -- upvalues: u5 (ref)
        u5.Close.BackgroundTransparency = 1;
    end);
    workspace.CurrentCamera.FieldOfView = 65;
    u42 = false;
    p110();
end;

function u1.CaseAnimation(p111) -- Line: 642
    -- upvalues: u1 (copy), u11 (ref), u4 (ref), u42 (ref), BeginReel (copy), GetScrollerContainer (copy), u21 (ref), u14 (ref), u16 (ref), u61 (ref), EndReel (copy), u15 (ref), u17 (ref), TweenService (copy), u60 (copy), Lighting (copy), u2 (ref), u3 (ref), u25 (ref)
    u1.onCooldown = false;
    local u112, v113 = unpack(p111:split(":"));
    local u114 = v113 == "KillTrack";
    local Item = u11.GetItem("Containers", u1.Container);

    if not (workspace:FindFirstChild("Scene") and (u4.Visible and not u42)) then
        return;
    end;

    local u115 = BeginReel();
    local u116 = GetScrollerContainer(Item);

    for i = 1, 50 do
        local v117 = u21.OpenCase(u116);

        if v117 then
            local Weapon = v117.Weapon;
            local Skin = v117.Skin;
            local v118 = u11.GetItem(Weapon, Skin) or u14.GetWeaponSkin(Weapon, Skin);
            local v119 = `rbxassetid://{v118.Thumbnail}`;
            local v120 = u16[v118.Rarity];
            u1.AddSkin(u4.SkinsGroup.LupaGroup.ScrollingLupa, v119, v120, UDim2.fromScale(0.909, 0.877), UDim2.fromScale(0.5, 0.482), Vector2.new(0.5, 0.5));
            u1.AddSkin(u4.SkinsGroup.ScrollGroup.MainScroll, v119, v120, UDim2.fromScale(1, 0.965), UDim2.fromScale(0, 0), Vector2.new(0, 0));
        end;

        local v121;

        if i % 10 == 0 then
            task.wait();
            v121 = i;
        else
            v121 = i;
        end;
    end;

    local u122 = false;

    local function Finish() -- Line: 685
        -- upvalues: u122 (ref), u61 (ref), EndReel (ref), u115 (copy), u112 (copy), u11 (ref), u14 (ref), u15 (ref), u17 (ref), u114 (copy), u4 (ref), u1 (ref)
        if u122 then
            return;
        end;

        u122 = true;
        u61 = nil;
        EndReel(u115);
        local v123, v124 = unpack(u112:split("_"));
        local v125 = u11.GetItem(v123, v124) or u14.GetWeaponSkin(v123, v124);
        local v126 = u11.GetCategory(v123) or u15.Get(v123);
        u17.Item(v123, v124, v125.Rarity, v126.GuiInformation.Description, nil, true, nil, nil, nil, u114 and 0 or nil);
        u4.SkinsGroup.GroupTransparency = 1;

        for _, child in u4.InventoryInspect.ScrollingHolder:GetChildren() do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;

        for _, child in u4.SkinsGroup.LupaGroup.ScrollingLupa:GetChildren() do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;

        for _, child in u4.SkinsGroup.ScrollGroup.MainScroll:GetChildren() do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;

        u4.SkinsGroup.LupaGroup.ScrollingLupa.CanvasPosition = Vector2.new(0, 0);
        u4.SkinsGroup.ScrollGroup.MainScroll.CanvasPosition = Vector2.new(0, 0);
        u1.CaseOpen();
        u4.Visible = false;
    end;

    u61 = Finish;
    task.delay(7.25, Finish);
    task.wait(1);

    if u122 then
        return;
    end;

    local v127 = TweenService:Create(u4.SkinsGroup, TweenInfo.new(0.85), {
        GroupTransparency = 0
    });
    table.insert(u60, v127);
    v127:Play();
    Lighting.UI_Blur.Size = 72;
    u2.Handler.DOTS.Visible = true;
    local u128 = nil;
    task.delay(0, function() -- Line: 750
        -- upvalues: u122 (ref), u112 (copy), u11 (ref), u14 (ref), u1 (ref), u4 (ref), u16 (ref), u128 (ref)
        if u122 then
            return;
        end;

        local v129, v130 = unpack(u112:split("_"));
        local v131 = u11.GetItem(v129, v130) or u14.GetWeaponSkin(v129, v130);
        local v132 = `rbxassetid://{v131.Rarity == "Exceeding Rare" and 109157939970080 or v131.Thumbnail}`;
        u1.AddSkin(u4.SkinsGroup.LupaGroup.ScrollingLupa, v132, u16[v131.Rarity], UDim2.fromScale(0.909, 0.877), UDim2.fromScale(0.5, 0.482), Vector2.new(0.5, 0.5), "Love");
        u128 = u1.AddSkin(u4.SkinsGroup.ScrollGroup.MainScroll, v132, u16[v131.Rarity], UDim2.fromScale(1, 0.965), UDim2.fromScale(0, 0), Vector2.new(0, 0), "Love");
    end);
    u4.SkinsGroup.LupaGroup.ScrollingLupa.CanvasPosition = Vector2.new(330, 0);
    task.delay(0.8, function() -- Line: 766
        -- upvalues: u122 (ref), u21 (ref), u116 (copy), u11 (ref), u14 (ref), u16 (ref), u1 (ref), u4 (ref)
        if u122 then
            return;
        end;

        for i = 1, 4 do
            local v133 = u21.OpenCase(u116);
            local v134;

            if v133 then
                local Weapon = v133.Weapon;
                local Skin = v133.Skin;
                local v135 = u11.GetItem(Weapon, Skin) or u14.GetWeaponSkin(Weapon, Skin);
                local v136 = `rbxassetid://{v135.Thumbnail}`;
                local v137 = u16[v135.Rarity];
                u1.AddSkin(u4.SkinsGroup.LupaGroup.ScrollingLupa, v136, v137, UDim2.fromScale(0.909, 0.877), UDim2.fromScale(0.5, 0.482), Vector2.new(0.5, 0.5));
                u1.AddSkin(u4.SkinsGroup.ScrollGroup.MainScroll, v136, v137, UDim2.fromScale(1, 0.965), UDim2.fromScale(0, 0), Vector2.new(0, 0));
                v134 = i;
            else
                v134 = i;
            end;
        end;
    end);
    task.delay(0.01, function() -- Line: 786
        -- upvalues: u122 (ref), u128 (ref), u3 (ref), u4 (ref), u25 (ref), TweenService (ref), u60 (ref)
        if u122 then
            return;
        end;

        local X = u128.AbsoluteSize.X;
        local u138 = 0;
        u3:Add("ScrollerScrolling", u4.SkinsGroup.ScrollGroup.MainScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 794
            -- upvalues: u4 (ref), u138 (ref), X (copy), u25 (ref)
            local X2 = u4.SkinsGroup.ScrollGroup.MainScroll.CanvasPosition.X;

            if X <= X2 - u138 then
                u25.Play("UI.container_scroll");
                u138 = X2;
            end;
        end));
        local v139 = 50.65 * u4.SkinsGroup.ScrollGroup.MainScroll:FindFirstChild("Love").AbsoluteSize.X;
        local v140 = 52.1 * u4.SkinsGroup.LupaGroup.ScrollingLupa:FindFirstChild("Love").AbsoluteSize.X;
        local v141 = TweenService:Create(u4.SkinsGroup.LupaGroup.ScrollingLupa, TweenInfo.new(7.25, Enum.EasingStyle.Quint), {
            CanvasPosition = Vector2.new(v140, 0)
        });
        table.insert(u60, v141);
        v141:Play();
        local v142 = TweenService:Create(u4.SkinsGroup.ScrollGroup.MainScroll, TweenInfo.new(7.25, Enum.EasingStyle.Quint), {
            CanvasPosition = Vector2.new(v139, 0)
        });
        table.insert(u60, v142);
        v142:Play();
    end);
end;

function u1.MultiCaseAnimation(u143) -- Line: 809
    -- upvalues: u1 (copy), u11 (ref), u4 (ref), u42 (ref), BeginReel (copy), GetScrollerContainer (copy), u21 (ref), u14 (ref), u16 (ref), u61 (ref), EndReel (copy), u95 (copy), u68 (ref), TweenService (copy), Lighting (copy), u2 (ref), u60 (copy), u3 (ref), u25 (ref)
    u1.onCooldown = false;
    local Item = u11.GetItem("Containers", u1.Container);

    if not (workspace:FindFirstChild("Scene") and (u4.Visible and not u42)) then
        return;
    end;

    local u144 = BeginReel();
    local u145 = GetScrollerContainer(Item);
    local MultiGroup = u4.MultiGroup;
    local math_min_ret = math.min(0.3, 0.92 / #u143 - 0.02);

    local function AddFiller(p146, p147) -- Line: 827
        -- upvalues: u21 (ref), u145 (copy), u11 (ref), u14 (ref), u1 (ref), u16 (ref)
        local v148 = u21.OpenCase(u145);

        if v148 then
            local v149 = u11.GetItem(v148.Weapon, v148.Skin) or u14.GetWeaponSkin(v148.Weapon, v148.Skin);
            u1.AddSkin(p146, `rbxassetid://{v149.Thumbnail}`, u16[v149.Rarity], UDim2.fromScale(1, 0.965), UDim2.fromScale(0, 0), Vector2.new(0, 0)).LayoutOrder = p147;
        end;
    end;

    local u150 = {};

    for i, v in u143 do
        local v151 = u1.multiRow();
        v151.LayoutOrder = i;
        v151.Size = UDim2.fromScale(1, math_min_ret);

        for i2 = 1, 40 do
            AddFiller(v151.MainScroll, i2);
            local _ = i2;
        end;

        local v152 = v:split(":")[1];
        local v153, v154 = unpack(v152:split("_"));
        local v155 = u11.GetItem(v153, v154) or u14.GetWeaponSkin(v153, v154);
        local v156 = `rbxassetid://{v155.Rarity == "Exceeding Rare" and 109157939970080 or v155.Thumbnail}`;
        u1.AddSkin(v151.MainScroll, v156, u16[v155.Rarity], UDim2.fromScale(1, 0.965), UDim2.fromScale(0, 0), Vector2.new(0, 0), "Love").LayoutOrder = 41;

        for i2 = 42, 51 do
            AddFiller(v151.MainScroll, i2);
            local _ = i2;
        end;

        v151.Parent = MultiGroup;
        u150[i] = v151;
        task.wait();
    end;

    local u157 = false;

    local function v158() -- Line: 864
        -- upvalues: u157 (ref), u61 (ref), EndReel (ref), u144 (copy), u95 (ref), u68 (ref), MultiGroup (copy), u150 (copy), TweenService (ref), Lighting (ref), u2 (ref), u1 (ref), u143 (copy)
        if u157 then
            return;
        end;

        u157 = true;
        u61 = nil;
        EndReel(u144);
        u95[u68.Category].Show();
        MultiGroup.GroupTransparency = 1;

        for _, v in u150 do
            v:Destroy();
        end;

        TweenService:Create(Lighting.UI_Blur, TweenInfo.new(0.5), {
            Size = 0
        }):Play();
        u2.Handler.DOTS.Visible = false;
        u1.ShowResults(u143);
    end;

    u61 = v158;
    task.delay((#u143 - 1) * 0.35 + 5 + 1.75, v158);
    task.wait(1);

    if u157 then
        return;
    end;

    local v159 = TweenService:Create(MultiGroup, TweenInfo.new(0.85), {
        GroupTransparency = 0
    });
    table.insert(u60, v159);
    v159:Play();
    Lighting.UI_Blur.Size = 72;
    u2.Handler.DOTS.Visible = true;

    for i, v in u150 do
        local MainScroll = v.MainScroll;
        local Love = MainScroll.Love;
        local v160 = Love.AbsolutePosition.X - MainScroll.AbsolutePosition.X + MainScroll.CanvasPosition.X + Love.AbsoluteSize.X * (math.random(15, 85) / 100) - MainScroll.AbsoluteSize.X / 2;
        local v161 = TweenService:Create(MainScroll, TweenInfo.new(5 + (i - 1) * 0.35, Enum.EasingStyle.Quint), {
            CanvasPosition = Vector2.new(v160, 0)
        });
        table.insert(u60, v161);
        v161:Play();
    end;

    local MainScroll = u150[#u150].MainScroll;
    local X = MainScroll.Love.AbsoluteSize.X;
    local u162 = 0;
    u3:Add("ScrollerScrolling", MainScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 913
        -- upvalues: MainScroll (copy), u162 (ref), X (copy), u25 (ref)
        local X2 = MainScroll.CanvasPosition.X;

        if X <= X2 - u162 then
            u25.Play("UI.container_scroll");
            u162 = X2;
        end;
    end));
end;

local u163 = 0;

local function TweenResult(p164, p165, p166) -- Line: 926
    -- upvalues: TweenService (copy)
    TweenService:Create(p164, p165, {
        BackgroundTransparency = p166 and 0 or 1
    }):Play();
    TweenService:Create(p164.Gradient, p165, {
        BackgroundTransparency = p166 and 0 or 1
    }):Play();
    TweenService:Create(p164.Rarity, p165, {
        BackgroundTransparency = p166 and 0 or 1
    }):Play();
    TweenService:Create(p164.Blur, p165, {
        ImageTransparency = p166 and 0.7 or 1
    }):Play();
    TweenService:Create(p164.Icon, p165, {
        ImageTransparency = p166 and 0 or 1,
        Position = UDim2.fromScale(0.5, p166 and 0.5 or 0.4)
    }):Play();
    TweenService:Create(p164.WeaponName, p165, {
        TextTransparency = p166 and 0 or 1,
        TextStrokeTransparency = p166 and 0.75 or 1
    }):Play();
    TweenService:Create(p164.UIShadow, p165, {
        Transparency = p166 and 0.5 or 1
    }):Play();
end;

function u1.ShowResults(p167) -- Line: 936
    -- upvalues: u4 (ref), u163 (ref), TweenService (copy), u11 (ref), u14 (ref), u15 (ref), u1 (copy), u16 (ref), u13 (ref), TweenResult (copy), u17 (ref), u3 (ref)
    local Results = u4.Results;
    local u168 = u163;
    Results.Title.TextTransparency = 1;
    Results.Title.Position = UDim2.fromScale(0.5, 0.06);
    TweenService:Create(Results.Title, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        TextTransparency = 0,
        Position = UDim2.fromScale(0.5, 0)
    }):Play();

    for i, v in p167 do
        local v169, v170 = unpack(v:split(":"));
        local u171 = v170 == "KillTrack";
        local u172, u173 = unpack(v169:split("_"));
        local u174 = u11.GetItem(u172, u173) or u14.GetWeaponSkin(u172, u173);
        local u175 = u11.GetCategory(u172) or u15.Get(u172);
        local u176 = u1.resultItem(Results.Holder, `rbxassetid://{u174.Thumbnail}`, u16[u174.Rarity], (`{u171 and "KillTrackᴷ⁺ " or ""}{u175.DisplayName or u172} | {u174.DisplayName or u173}`));
        u176.LayoutOrder = i;
        u176.BackgroundTransparency = 1;
        u176.Gradient.BackgroundTransparency = 1;
        u176.Rarity.BackgroundTransparency = 1;
        u176.Blur.ImageTransparency = 1;
        u176.Icon.ImageTransparency = 1;
        u176.Icon.Position = UDim2.fromScale(0.5, 0.6);
        u176.WeaponName.TextTransparency = 1;
        u176.WeaponName.TextStrokeTransparency = 1;

        if u174.ModelName == "Stickers" and u173:sub(-5) == " Holo" then
            u13.GlowIcon(u176.Icon);
        end;

        TweenResult(u176, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0.15 + i * 0.08), true);
        task.delay(3 + i * 0.08, function() -- Line: 971
            -- upvalues: u168 (copy), u163 (ref), TweenResult (ref), u176 (copy)
            if u168 ~= u163 then
                return;
            end;

            TweenResult(u176, TweenInfo.new(0.4), false);
        end);
        u17.Register(u176, function() -- Line: 979
            -- upvalues: u172 (copy), u173 (copy), u174 (copy), u175 (copy), u171 (copy)
            return table.pack(u172, u173, u174.Rarity, u174.Description or u175.GuiInformation.Description, nil, nil, nil, nil, nil, u171 and 0 or nil);
        end);
        u3:Add(`Result{i}Click`, u176.Icon.MouseButton1Click:Connect(function() -- Line: 983
            -- upvalues: u17 (ref), u176 (copy)
            u17.Browse(u176);
        end));
    end;

    Results.Visible = true;
    task.delay(#p167 * 0.08 + 3, function() -- Line: 990
        -- upvalues: u168 (copy), u163 (ref), TweenService (ref), Results (copy), u1 (ref)
        if u168 ~= u163 then
            return;
        end;

        TweenService:Create(Results.Title, TweenInfo.new(0.4), {
            TextTransparency = 1
        }):Play();
        task.wait(0.4);

        if u168 ~= u163 then
            return;
        end;

        u1.ClearResults();
    end);
end;

function u1.ClearResults() -- Line: 1007
    -- upvalues: u4 (ref), u163 (ref), u3 (ref)
    local Results = u4.Results;
    u163 = u163 + 1;

    for _, child in Results.Holder:GetChildren() do
        if child:IsA("Frame") then
            u3:Removes((`Result{child.LayoutOrder}Click`));
            child:Destroy();
        end;
    end;

    Results.Visible = false;
end;

function u1.SkipAnimation() -- Line: 1024
    -- upvalues: u61 (ref)
    if u61 then
        u61();
    end;
end;

function u1.Back() -- Line: 1030
    -- upvalues: u42 (ref), u1 (copy), u4 (ref), u57 (ref)
    if u42 then
        u1.SkipAnimation();

        return;
    end;

    if RareItems.Visible then
        u1.VisibleRareItems(false);

        return;
    end;

    if not u1.onCooldown and u4.Visible then
        u1.SetVisible(u57);
    end;
end;

function u1.Close() -- Line: 1040
    -- upvalues: u4 (ref), u58 (ref), u59 (ref), u1 (copy), u57 (ref), u3 (ref), u5 (ref), u66 (ref), u7 (ref), u2 (ref)
    if not (u4 and u4.Visible or RareItems and RareItems.Visible) then
        return;
    end;

    u58 = false;
    u59 = false;
    u1.VisibleRareItems(false, nil, true);
    u1.ClearResults();
    u4.Visible = false;

    if u57 then
        u1.CaseBuy();
    else
        u1.CaseOpen();
    end;

    u3:Removes("UIClose", "UIClose2", "UIEnter", "UILeave");
    u3:Removes("UnEnter", "UnLeave", "UnClick", "PostRender");

    for _, child in u4.InventoryInspect.ScrollingHolder:GetChildren() do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    Page.Visible = false;
    task.delay(0.5, function() -- Line: 1069
        -- upvalues: u5 (ref)
        u5.Close.BackgroundTransparency = 1;
    end);
    u3:Removes("ModelAnimation");

    if u66 then
        u66:Destroy();
        u66 = nil;
    end;

    local Scene = workspace:FindFirstChild("Scene");

    if not Scene then
        return;
    end;

    u7.Enabled("CaseInspect", false);
    u1.PlaceRig(Scene, true);
    local v177 = u2 and u2.GetComponent and u2.GetComponent("MainMenu");

    if v177 and v177.CheckSceneUpdate then
        v177.CheckSceneUpdate();
    end;
end;

function u1.SetVisible(u178: boolean, u179: number, p180: number, u181: string, u182: number, u183: boolean?) -- Line: 1093
    -- upvalues: u58 (ref), u59 (ref), u4 (ref), u1 (copy), u57 (ref), u2 (ref), TweenService (copy), u11 (ref), u5 (ref), SpawnModel (copy), u3 (ref), u42 (ref), TweenInfo_new_ret (copy), u44 (ref), u21 (ref), u14 (ref), u13 (ref), u20 (ref), u7 (ref), Lighting (copy), u66 (ref)
    if u58 or u59 then
        return;
    end;

    if u4.Visible then
        u59 = true;
        u1.VisibleRareItems(false, nil, true);
    else
        u58 = true;
    end;

    u57 = u178;
    u2.Handler.Fade.Position = UDim2.fromScale(2, 0.5);
    TweenService:Create(u2.Handler.Fade, TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(-1, 0.5)
    }):Play();
    task.delay(0.07, function() -- Line: 1116
        -- upvalues: u58 (ref), u59 (ref), u4 (ref), u2 (ref), u1 (ref), u11 (ref), u181 (copy), u5 (ref), SpawnModel (ref), u3 (ref), u42 (ref), u178 (copy), TweenService (ref), TweenInfo_new_ret (ref), u44 (ref), u183 (copy), u179 (copy), u182 (copy), u21 (ref), u14 (ref), u13 (ref), u20 (ref), u7 (ref), Lighting (ref), u66 (ref)
        u58 = false;
        u59 = false;
        u4.Visible = not u4.Visible;
        u2.Handler.MainMenu.Visible = not u2.Handler.MainMenu.Visible;
        local Scene = workspace:FindFirstChild("Scene");

        if not Scene then
            return;
        end;

        if not u4.Visible then
            u1.VisibleRareItems(false, nil, true);
            u1.ClearResults();
            u3:Removes(
                "UIClose",
                "UIEnter",
                "UILeave",
                "RareItems_MouseEnter",
                "RareItems_MouseLeave",
                "RareItems_SelectionGained",
                "RareItems_SelectionLost",
                "RareItems_MouseClick"
            );

            if u178 then
                u1.CaseBuy();
            else
                u1.CaseOpen();
            end;

            for _, child in u4.InventoryInspect.ScrollingHolder:GetChildren() do
                if child:IsA("Frame") then
                    child:Destroy();
                end;
            end;

            task.delay(0.5, function() -- Line: 1290
                -- upvalues: u5 (ref)
                u5.Close.BackgroundTransparency = 1;
            end);
            u7.Enabled("CaseInspect", false);

            if Lighting:FindFirstChild("UI_Blur") then
                TweenService:Create(Lighting.UI_Blur, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                    Size = 72
                }):Play();
            end;

            u2.Handler.DOTS.Visible = true;
            u1.PlaceRig(Scene, true);
            u3:Removes("ModelAnimation");

            if u66 then
                u66:Destroy();
                u66 = nil;
            end;

            local v184 = u2 and u2.GetComponent and u2.GetComponent("MainMenu");

            if v184 and v184.CheckSceneUpdate then
                v184.CheckSceneUpdate();
            end;

            return;
        end;

        u1.VisibleRareItems(false, nil, true);
        u1.ClearResults();
        local Item = u11.GetItem("Containers", u181);
        u1.Container = u181;
        local Close = u5.Close;
        u1.PlaceRig(Scene, false);
        SpawnModel(Scene, Item);
        u3:Add("UIClose", Close.MouseButton1Click:Connect(function() -- Line: 1147
            -- upvalues: u1 (ref), u42 (ref), u178 (ref)
            if u1.onCooldown or u42 then
                return;
            end;

            u1.SetVisible(u178);
        end));
        u3:Add("UIClose2", Close.MouseButton2Click:Connect(function() -- Line: 1154
            -- upvalues: u1 (ref), u42 (ref), u178 (ref)
            if u1.onCooldown or u42 then
                return;
            end;

            u1.SetVisible(u178);
        end));
        u3:Add("UIEnter", Close.MouseEnter:Connect(function() -- Line: 1161
            -- upvalues: TweenService (ref), Close (copy), TweenInfo_new_ret (ref)
            if RareItems.Visible then
                return;
            end;

            TweenService:Create(Close, TweenInfo_new_ret, {
                BackgroundTransparency = 0.9
            }):Play();
        end));
        u3:Add("UILeave", Close.MouseLeave:Connect(function() -- Line: 1169
            -- upvalues: TweenService (ref), Close (copy), TweenInfo_new_ret (ref)
            TweenService:Create(Close, TweenInfo_new_ret, {
                BackgroundTransparency = 1
            }):Play();
        end));
        u44 = u183;

        if u178 then
            u1.CaseBuy(u179, u181, Item.Gamepasses);
        else
            u1.CaseOpen(u181);
        end;

        u4.MainIconBackground.Image = `rbxassetid://{u182}`;
        u4.MainInspect.FrameTop.DownText.Text = `Unlock <font weight="Bold">{Item.DisplayName or u181}</font>`;
        local v185 = Item.HoloChance and (`Glow - {math.round(Item.HoloChance * 100)}%` or "KillTrackᴷ⁺ - 10%") or "KillTrackᴷ⁺ - 10%";
        local v186 = Item.HoloChance and Color3.fromRGB(175, 231, 255) or Color3.fromRGB(207, 106, 50);
        local v187 = u4.MainInspect.DownBar.LeftDown.OddsHover.HoverFrame["6"];
        local v188 = u4.InventoryInspect.Chances.Rarities["6"];
        v187.Text = `<font color="rgb(255,255,255)">•</font> {v185}`;
        v188.Text = v185;
        v187.TextColor3 = v186;
        v188.TextColor3 = v186;

        for _, child in u4.InventoryInspect.ScrollingHolder:GetChildren() do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;

        local v189 = u21;
        local v190 = v189.NormalizeCaseData(Item);
        local ItemOdds = v189.GetItemOdds(Item);
        local u191 = {};

        for _, v in v190.Items do
            local v192 = v.Skin ~= "" and `{v.Weapon}_{v.Skin}` or v.Weapon;

            if v.Rarity == "Exceeding Rare" then
                table.insert(u191, v192);
            else
                local Weapon = v.Weapon;
                local Skin = v.Skin;
                local v193 = ItemOdds[v192] or 0;
                local v194 = u11.GetItem(Weapon, Skin) or u14.GetWeaponSkin(Weapon, Skin);
                u13.CreateItem(u4.InventoryInspect.ScrollingHolder, Weapon, Skin, nil, nil, 1, false, v193).LayoutOrder = u20.RarityNum[v194.Rarity];
            end;
        end;

        if #u191 > 0 then
            local u195 = u1.AddRareItem(u4.InventoryInspect.ScrollingHolder);

            local function RareEnter() -- Line: 1241
                -- upvalues: TweenService (ref), u195 (copy)
                if RareItems.Visible then
                    return;
                end;

                TweenService:Create(u195.GradientBack, TweenInfo.new(0.2), {
                    GroupTransparency = 0.15
                }):Play();
            end;

            local function RareLeave() -- Line: 1250
                -- upvalues: TweenService (ref), u195 (copy)
                TweenService:Create(u195.GradientBack, TweenInfo.new(0.2), {
                    GroupTransparency = 0
                }):Play();
            end;

            u3:Add("RareItems_MouseEnter", u195.Icon.MouseEnter:Connect(RareEnter));
            u3:Add("RareItems_MouseLeave", u195.Icon.MouseLeave:Connect(RareLeave));
            u3:Add("RareItems_SelectionGained", u195.Icon.SelectionGained:Connect(RareEnter));
            u3:Add("RareItems_SelectionLost", u195.Icon.SelectionLost:Connect(RareLeave));
            u3:Add("RareItems_MouseClick", u195.Icon.MouseButton1Click:Connect(function() -- Line: 1259
                -- upvalues: u1 (ref), u191 (copy)
                u1.VisibleRareItems(true, u191);
            end));
        end;

        u7.Enabled("CaseInspect", true);
        Lighting.UI_Blur.Size = 0;
        u2.Handler.DOTS.Visible = false;
    end);
end;

function u1.VisibleRareItems(p196, p197, p198) -- Line: 1315
    -- upvalues: u21 (ref), u11 (ref), u1 (copy), u16 (ref), u14 (ref), u15 (ref), u3 (ref), TweenService (copy), u17 (ref), TweenInfo_new_ret (copy)
    if not p196 then
        if not (RareItems and RareItems.Visible) then
            return;
        end;

        local v199 = next;
        local Children, v200 = RareItems.Main.ScrollingHolder:GetChildren();

        for _, v in v199, Children, v200 do
            if v:IsA("CanvasGroup") or v:IsA("Frame") then
                local Name = v.Name;
                u3:Removes(`{Name}_MouseEnter`, `{Name}_MouseLeave`, (`{Name}_MouseClick`));
                v:Destroy();
            end;
        end;

        u3:Removes(
            "RareItemsClose_MouseEnter",
            "RareItemsClose_MouseLeave",
            "RareItemsClose_MouseClick",
            "RareItemsClose_MouseClick2",
            "RareItems_BackdropClick",
            "RareItems_BackdropClick2"
        );

        if p198 then
            RareItems.BackgroundTransparency = 1;
            RareItems.Main.GroupTransparency = 1;
            RareItems.Main.UIStroke.Transparency = 1;
            RareItems.Visible = false;

            return;
        end;

        TweenService:Create(RareItems, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        }):Play();
        TweenService:Create(RareItems.Main, TweenInfo.new(0.2), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(RareItems.Main.UIStroke, TweenInfo.new(0.2), {
            Transparency = 1
        }):Play();
        task.delay(0.2, function() -- Line: 1426
            if not RareItems.Visible or RareItems.Main.GroupTransparency == 1 then
                RareItems.Visible = false;
            end;
        end);

        return;
    end;

    if RareItems.Visible then
        return;
    end;

    local v201 = u21;
    local Item = u11.GetItem("Containers", u1.Container);
    local v202 = Item and (v201.GetItemOdds(Item) or {}) or {};
    local v203 = u16["Exceeding Rare"];

    for _, v in p197 do
        local u204, u205 = unpack(v:split("_"));
        local v206 = v202[v] or math.round((v201.RarityWeights["Exceeding Rare"] or 0.35) / #p197 * 100000) / 100000;
        local u207 = u11.GetItem(u204, u205) or u14.GetWeaponSkin(u204, u205);
        local u208 = u11.GetCategory(u204) or u15.Get(u204);
        local u209 = u1.rareItem(RareItems.Main.ScrollingHolder);
        u209.Name = v;
        u209.Icon.Image = `rbxassetid://{u207.Thumbnail}`;
        u209.WeaponName.Text = `{u208.DisplayName or u204} | {u207.DisplayName or u205} (<font color="rgb({math.round(v203.R * 255)},{math.round(v203.G * 255)},{math.round(v203.B * 255)})">{v206}%</font>)`;
        u3:Add(`{v}_MouseEnter`, u209.Icon.MouseEnter:Connect(function() -- Line: 1340
            -- upvalues: TweenService (ref), u209 (copy)
            TweenService:Create(u209.GradientBack, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.15
            }):Play();
        end));
        u3:Add(`{v}_MouseLeave`, u209.Icon.MouseLeave:Connect(function() -- Line: 1345
            -- upvalues: TweenService (ref), u209 (copy)
            TweenService:Create(u209.GradientBack, TweenInfo.new(0.2), {
                BackgroundTransparency = 0
            }):Play();
        end));
        u17.Register(u209, function() -- Line: 1349
            -- upvalues: u204 (copy), u205 (copy), u207 (copy), u208 (copy)
            return table.pack(u204, u205, u207.Rarity, u207.Description or u208.GuiInformation.Description, nil, nil);
        end);
        u3:Add(`{v}_MouseClick`, u209.Icon.MouseButton1Click:Connect(function() -- Line: 1353
            -- upvalues: u17 (ref), u209 (copy), u1 (ref)
            u17.Browse(u209);
            u1.VisibleRareItems(false, nil, true);
        end));
        u209.Visible = true;
    end;

    local Close = RareItems.Main.RightDown.Close;
    u3:Add("RareItemsClose_MouseEnter", Close.MouseEnter:Connect(function() -- Line: 1363
        -- upvalues: TweenService (ref), Close (copy), TweenInfo_new_ret (ref)
        TweenService:Create(Close, TweenInfo_new_ret, {
            BackgroundTransparency = 0.9
        }):Play();
    end));
    u3:Add("RareItemsClose_MouseLeave", Close.MouseLeave:Connect(function() -- Line: 1367
        -- upvalues: TweenService (ref), Close (copy), TweenInfo_new_ret (ref)
        TweenService:Create(Close, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        }):Play();
    end));
    u3:Add("RareItemsClose_MouseClick", Close.MouseButton1Click:Connect(function() -- Line: 1371
        -- upvalues: u1 (ref)
        u1.VisibleRareItems(false);
    end));
    u3:Add("RareItemsClose_MouseClick2", Close.MouseButton2Click:Connect(function() -- Line: 1375
        -- upvalues: u1 (ref)
        u1.VisibleRareItems(false);
    end));
    u3:Add("RareItems_BackdropClick", RareItems.MouseButton1Click:Connect(function() -- Line: 1379
        -- upvalues: u1 (ref)
        u1.VisibleRareItems(false);
    end));
    u3:Add("RareItems_BackdropClick2", RareItems.MouseButton2Click:Connect(function() -- Line: 1383
        -- upvalues: u1 (ref)
        u1.VisibleRareItems(false);
    end));
    TweenService:Create(RareItems, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.3
    }):Play();
    TweenService:Create(RareItems.Main, TweenInfo.new(0.2), {
        GroupTransparency = 0
    }):Play();
    TweenService:Create(RareItems.Main.UIStroke, TweenInfo.new(0.2), {
        Transparency = 0.35
    }):Play();
    RareItems.Visible = true;
end;

function u1.IsOpeningCase() -- Line: 1435
    -- upvalues: u42 (ref)
    return u42;
end;

function u1.IsOpen() -- Line: 1443
    -- upvalues: u4 (ref), u58 (ref), u59 (ref), u42 (ref)
    return ((u4 ~= nil and u4.Visible or (RareItems ~= nil and RareItems.Visible or u58)) and true or false) and not u59 or u42;
end;

function u1.IsBusy() -- Line: 1447
    -- upvalues: u58 (ref), u59 (ref), u42 (ref), u4 (ref)
    local v210 = u58 or (u59 or u42);

    if not v210 then
        if u4 == nil then
            v210 = false;
        else
            v210 = u4.Visible;
        end;
    end;

    return v210;
end;

function u1.Start(p211) -- Line: 1453
    -- upvalues: u22 (ref), u2 (ref), u24 (ref), u12 (ref), u23 (ref), u4 (ref), u1 (copy), u5 (ref), TweenService (copy), TweenInfo_new_ret (copy), u7 (ref)
    u22 = u2.GetComponent("Notify");
    u24 = u2.GetComponent("Store");
    u12 = u2.GetComponent("MenuNotification");
    u23 = u2.GetComponent("PurchaseButtons").new();
    u4 = u1.new();
    u1.rareItems();
    u5 = u4.MainInspect.DownBar.RightDown;
    local Skip = u4.MainInspect.SkipBar.Skip;
    Skip.MouseEnter:Connect(function() -- Line: 1468
        -- upvalues: TweenService (ref), Skip (copy), TweenInfo_new_ret (ref)
        TweenService:Create(Skip, TweenInfo_new_ret, {
            BackgroundTransparency = 0.8
        }):Play();
    end);
    Skip.MouseLeave:Connect(function() -- Line: 1472
        -- upvalues: TweenService (ref), Skip (copy), TweenInfo_new_ret (ref)
        TweenService:Create(Skip, TweenInfo_new_ret, {
            BackgroundTransparency = 0.9
        }):Play();
    end);
    Skip.MouseButton1Click:Connect(u1.SkipAnimation);
    u7.new("CaseInspect", u4.InventoryInspect).Frame.Size = UDim2.new(1, 0, 1, 0);
    u7.Enabled("CaseInspect", false);
    local u212 = u24.CreditsLabel(Page, true);
    local Page_Title = Page.Title;

    local function FitBalance() -- Line: 1484
        -- upvalues: u212 (copy), TweenService (ref), Page_Title (copy), TweenInfo_new_ret (ref)
        local v213 = u212.Lock.Visible and u212.AbsolutePosition.X - u212.Lock.AbsolutePosition.X + 8 or 0;
        TweenService:Create(Page_Title, TweenInfo_new_ret, {
            Size = UDim2.new(0.559, -v213, 0.45, 0),
            Position = UDim2.new(0.279515, -v213 / 2, 0.525, 0)
        }):Play();
    end;

    u212.Lock:GetPropertyChangedSignal("Visible"):Connect(FitBalance);
    u212:GetPropertyChangedSignal("AbsoluteSize"):Connect(FitBalance);
    FitBalance();
end;

function u1.Init(p214) -- Line: 1495
    -- upvalues: u2 (ref), u3 (ref), u11 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u6 (ref), u21 (ref), u7 (ref), u25 (ref), u26 (ref), HttpService (copy), u4 (ref), u42 (ref), u1 (copy)
    u2 = p214:GetModule("Gui");
    u3 = p214:GetModule("Maid").new();
    u11 = p214:GetModule("ItemManager");
    u13 = p214:GetModule("Inventory");
    u14 = p214:GetModule("SkinManager");
    u15 = p214:GetModule("WeaponManager");
    u16 = p214:GetModule("RarityColors");
    u17 = p214:GetModule("Inspect");
    u18 = p214:GetModule("Network");
    u19 = p214:GetModule("ProfileData");
    u20 = p214:GetModule("Enums");
    u6 = p214:GetModule("Settings");
    u21 = p214:GetModule("CaseSystem");
    u7 = p214:GetModule("Blur");
    u25 = p214:GetModule("SoundManager");
    u26 = p214:GetModule("InventoryData");
    u18.Gui.OpenContainerResult.On(function(p215) -- Line: 1519
        -- upvalues: HttpService (ref), u26 (ref), u4 (ref), u42 (ref), u1 (ref), u2 (ref)
        local v216 = HttpService:JSONDecode(p215);
        u26.Apply(v216.Removed, v216.Added);

        if workspace:FindFirstChild("Scene") and (u4.Visible and not u42) then
            if #v216.Results > 1 then
                u1.MultiCaseAnimation(v216.Results);

                return;
            end;

            u1.CaseAnimation(v216.Results[1]);

            return;
        end;

        local v217 = {};

        for _, v in v216.Results do
            local v218 = { "Item", v:split(":")[1] };
            table.insert(v217, v218);
        end;

        u1.onCooldown = false;
        u2.GetComponent("Rewards").RewardsNotifications(v217);
    end);
end;

function u1.new() -- Line: 1546
    -- upvalues: u2 (ref), u21 (ref), TweenService (copy), u9 (ref), u10 (ref), u6 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "CaseInspect";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Visible = false;
    Frame.Parent = u2.Handler;
    Page = Instance.new("Frame");
    Page.Name = "Page";
    Page.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    Page.BackgroundTransparency = 0.9;
    Page.Position = UDim2.fromScale(0.76, 0.04);
    Page.Size = UDim2.fromScale(0.213008, 0.058);
    Page.Visible = false;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 6.83;
    UIAspectRatioConstraint.Parent = Page;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundColor3 = Color3.new();
    ImageLabel.BackgroundTransparency = 0.9;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.fromRGB(86, 86, 86);
    ImageLabel.ImageTransparency = 0.6;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel.ZIndex = -1;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner.BottomRightRadius = UDim.new(0.1, 0);
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.TopLeftRadius = UDim.new(0.1, 0);
    UICorner.TopRightRadius = UDim.new(0.1, 0);
    UICorner.Parent = ImageLabel;
    ImageLabel.Parent = Page;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner2.BottomRightRadius = UDim.new(0.1, 0);
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.TopLeftRadius = UDim.new(0.1, 0);
    UICorner2.TopRightRadius = UDim.new(0.1, 0);
    UICorner2.Parent = Page;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.279515, 0.525);
    TextLabel.Size = UDim2.fromScale(0.559, 0.45);
    TextLabel.Text = "CURRENT BALANCE:";
    TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel.TextScaled = true;
    TextLabel.Parent = Page;
    Page.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "MainInspect";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.ZIndex = 4;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatio";
    UIAspectRatioConstraint2.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "DownBar";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.fromScale(1, 0.08);
    Frame3.ZIndex = 346;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "RightDown";
    Frame4.BackgroundTransparency = 1;
    Frame4.Size = UDim2.fromScale(1, 1);
    Frame4.ZIndex = 53215;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "PaddingDown";
    UIPadding.PaddingBottom = UDim.new(0.2, 0);
    UIPadding.PaddingLeft = UDim.new(0.01, 0);
    UIPadding.PaddingRight = UDim.new(0.01, 0);
    UIPadding.PaddingTop = UDim.new(0.2, 0);
    UIPadding.Parent = Frame4;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "ListLayoutDown";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0.02, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame4;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Close";
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.LayoutOrder = 10;
    ImageButton.Size = UDim2.fromScale(0.06, 1);
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(0.05, 0);
    UICorner3.Name = "Corner1";
    UICorner3.Parent = ImageButton;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "TextClose";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel2.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.9, 0.6);
    TextLabel2.Text = "CLOSE";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel2.ZIndex = 343;
    TextLabel2.Parent = ImageButton;
    ImageButton.Parent = Frame4;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Line";
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BackgroundTransparency = 0.8;
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.LayoutOrder = 5;
    Frame5.Size = UDim2.new(0, 1, 1.2, 0);
    Frame5.Parent = Frame4;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Unlock";
    ImageButton2.AutoButtonColor = false;
    ImageButton2.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
    ImageButton2.Size = UDim2.fromScale(0.16, 1);
    ImageButton2.Visible = false;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.CornerRadius = UDim.new(0.05, 0);
    UICorner4.Name = "CornerClose";
    UICorner4.Parent = ImageButton2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "TextConfirm";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel3.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel3.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel3.Text = "UNLOCK CONTAINER";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel3.ZIndex = 343;
    TextLabel3.Parent = ImageButton2;
    ImageButton2.Parent = Frame4;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Amount";
    Frame6.BackgroundTransparency = 1;
    Frame6.LayoutOrder = -1;
    Frame6.Size = UDim2.fromScale(9.2, 1);
    Frame6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame6.Visible = false;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "ListLayoutAmount";
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout2.Padding = UDim.new(0.02, 0);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout2.Parent = Frame6;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "TextAmount";
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel4.Size = UDim2.fromScale(3.2, 0.6);
    TextLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel4.Text = "OPEN CASES";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel4.ZIndex = 343;
    TextLabel4.Parent = Frame6;

    for i = 1, u21.MaxOpen do
        local TextButton = Instance.new("TextButton");
        TextButton.Name = tostring(i);
        TextButton.AutoButtonColor = false;
        TextButton.BackgroundColor3 = Color3.new(1, 1, 1);
        TextButton.BackgroundTransparency = 0.95;
        TextButton.LayoutOrder = i;
        TextButton.Size = UDim2.fromScale(1, 1);
        TextButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        TextButton.Text = "";
        local UICorner5 = Instance.new("UICorner");
        UICorner5.Name = "CornerAmount";
        UICorner5.CornerRadius = UDim.new(0.1, 0);
        UICorner5.Parent = TextButton;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Name = "StrokeAmount";
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.Color = Color3.new(1, 1, 1);
        UIStroke.Transparency = 0.875;
        UIStroke.Parent = TextButton;
        local TextLabel5 = Instance.new("TextLabel");
        TextLabel5.Name = "Title";
        TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel5.BackgroundTransparency = 1;
        TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
        TextLabel5.Position = UDim2.fromScale(0.5, 0.5);
        TextLabel5.Size = UDim2.fromScale(0.6, 0.6);
        TextLabel5.Text = tostring(i);
        TextLabel5.TextColor3 = Color3.fromRGB(232, 232, 232);
        TextLabel5.TextScaled = true;
        TextLabel5.ZIndex = 343;
        TextLabel5.Parent = TextButton;
        local ImageLabel2 = Instance.new("ImageLabel");
        ImageLabel2.Name = "Locked";
        ImageLabel2.AnchorPoint = Vector2.new(1, 0);
        ImageLabel2.BackgroundTransparency = 1;
        ImageLabel2.Image = "rbxassetid://108829592125034";
        ImageLabel2.ImageColor3 = Color3.fromRGB(232, 232, 232);
        ImageLabel2.Position = UDim2.fromScale(0.95, 0.05);
        ImageLabel2.ScaleType = Enum.ScaleType.Fit;
        ImageLabel2.Size = UDim2.fromScale(0.4, 0.4);
        ImageLabel2.Visible = false;
        ImageLabel2.ZIndex = 344;
        ImageLabel2.Parent = TextButton;
        TextButton.Parent = Frame6;
        local _ = i;
    end;

    Frame6.Parent = Frame4;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Robux";
    TextButton.Active = false;
    TextButton.AnchorPoint = Vector2.new(1, 0.5);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton.BackgroundTransparency = 0.95;
    TextButton.LayoutOrder = 2;
    TextButton.Position = UDim2.fromScale(0.85, 0.5);
    TextButton.Size = UDim2.fromScale(0.15, 1);
    TextButton.TextTransparency = 1;
    TextButton.Visible = false;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Transparency = 0.875;
    UIStroke.Parent = TextButton;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.Parent = TextButton;
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
    TextLabel5.Parent = TextButton;
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
    TextLabel6.Parent = TextButton;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Sale";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.5, -0.05);
    TextLabel7.RichText = true;
    TextLabel7.Size = UDim2.fromScale(1.4, 0.45);
    TextLabel7.Text = "";
    TextLabel7.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel7.TextScaled = true;
    TextLabel7.TextTransparency = 1;
    TextLabel7.Visible = false;
    TextLabel7.Parent = TextButton;
    TextButton.Parent = Frame4;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Gift";
    TextButton2.Active = false;
    TextButton2.AnchorPoint = Vector2.new(1, 0.5);
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundTransparency = 0.95;
    TextButton2.LayoutOrder = 1;
    TextButton2.Position = UDim2.fromScale(0.95, 0.5);
    TextButton2.Size = UDim2.fromScale(1, 1);
    TextButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextButton2.TextTransparency = 1;
    TextButton2.Visible = false;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Transparency = 0.875;
    UIStroke2.Parent = TextButton2;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UICorner";
    UICorner6.CornerRadius = UDim.new(0.1, 0);
    UICorner6.Parent = TextButton2;
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
    ImageLabel2.Parent = TextButton2;
    TextButton2.Parent = Frame4;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "Credits";
    TextButton3.Active = false;
    TextButton3.AnchorPoint = Vector2.new(1, 0.5);
    TextButton3.AutoButtonColor = false;
    TextButton3.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton3.BackgroundTransparency = 0.95;
    TextButton3.LayoutOrder = 3;
    TextButton3.Position = UDim2.fromScale(0.606394, 0.5);
    TextButton3.Size = UDim2.fromScale(0.15, 1);
    TextButton3.TextTransparency = 1;
    TextButton3.Visible = false;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "Title";
    TextLabel8.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.717602, 0.525);
    TextLabel8.Size = UDim2.fromScale(0.464995, 0.8);
    TextLabel8.RichText = true;
    TextLabel8.Text = "1000";
    TextLabel8.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel8.TextScaled = true;
    TextLabel8.Parent = TextButton3;
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
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke3.Color = Color3.new(1, 1, 1);
    UIStroke3.Transparency = 0.875;
    UIStroke3.Parent = TextButton3;
    local UICorner7 = Instance.new("UICorner");
    UICorner7.Name = "UICorner";
    UICorner7.CornerRadius = UDim.new(0.1, 0);
    UICorner7.Parent = TextButton3;
    TextButton3.Parent = Frame4;
    Frame4.Parent = Frame3;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "LeftDown";
    Frame7.BackgroundTransparency = 1;
    Frame7.Size = UDim2.fromScale(1, 1);
    Frame7.ZIndex = 999;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "PaddingHolder";
    UIPadding2.PaddingBottom = UDim.new(0.2, 0);
    UIPadding2.PaddingLeft = UDim.new(0.01, 0);
    UIPadding2.PaddingRight = UDim.new(0.01, 0);
    UIPadding2.PaddingTop = UDim.new(0.2, 0);
    UIPadding2.Parent = Frame7;
    local UIListLayout3 = Instance.new("UIListLayout");
    UIListLayout3.Name = "LayoutHolder";
    UIListLayout3.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout3.Padding = UDim.new(0.01, 0);
    UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout3.Parent = Frame7;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "OddsHover";
    ImageButton3.AutoButtonColor = false;
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.LayoutOrder = -2;
    ImageButton3.Size = UDim2.fromScale(1, 1);
    ImageButton3.SizeConstraint = Enum.SizeConstraint.RelativeYY;

    local function OddsEnter() -- Line: 2023
        -- upvalues: TweenService (ref), ImageButton3 (copy)
        if RareItems.Visible then
            return;
        end;

        TweenService:Create(ImageButton3.HoverFrame, TweenInfo.new(0.25), {
            GroupTransparency = 0
        }):Play();
        TweenService:Create(ImageButton3, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.7
        }):Play();
    end;

    local function OddsLeave() -- Line: 2033
        -- upvalues: TweenService (ref), ImageButton3 (copy)
        TweenService:Create(ImageButton3.HoverFrame, TweenInfo.new(0.25), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(ImageButton3, TweenInfo.new(0.25), {
            BackgroundTransparency = 1
        }):Play();
    end;

    ImageButton3.MouseEnter:Connect(OddsEnter);
    ImageButton3.MouseLeave:Connect(OddsLeave);
    ImageButton3.SelectionGained:Connect(OddsEnter);
    ImageButton3.SelectionLost:Connect(OddsLeave);
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Icon";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://71861241452800";
    ImageLabel4.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel4.ScaleType = Enum.ScaleType.Fit;
    ImageLabel4.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = ImageButton3;
    local UICorner8 = Instance.new("UICorner");
    UICorner8.Name = "Corner";
    UICorner8.CornerRadius = UDim.new(0.1, 0);
    UICorner8.Parent = ImageButton3;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "HoverFrame";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0);
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(16, 16, 16);
    CanvasGroup.BackgroundTransparency = 0.2;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(0.499999, -3.45);
    CanvasGroup.Size = UDim2.fromScale(4.71844, 3.17);
    CanvasGroup.ZIndex = 2;
    local UICorner9 = Instance.new("UICorner");
    UICorner9.Name = "HoverCorner";
    UICorner9.CornerRadius = UDim.new(0.05, 0);
    UICorner9.Parent = CanvasGroup;
    local UIListLayout4 = Instance.new("UIListLayout");
    UIListLayout4.Name = "UIListLayout";
    UIListLayout4.Padding = UDim.new(0.005, 0);
    UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout4.Parent = CanvasGroup;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "1";
    TextLabel9.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel9.RichText = true;
    TextLabel9.Size = UDim2.fromScale(1, 0.135);
    TextLabel9.Text = "<font color=\"rgb(255,255,255)\">•</font> Exceeding Rare - 0.35%";
    TextLabel9.TextColor3 = Color3.fromRGB(232, 169, 45);
    TextLabel9.TextScaled = true;
    TextLabel9.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel9.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel9.ZIndex = 343;
    TextLabel9.Parent = CanvasGroup;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "2";
    TextLabel10.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel10.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel10.RichText = true;
    TextLabel10.Size = UDim2.fromScale(1, 0.135);
    TextLabel10.Text = "<font color=\"rgb(255,255,255)\">•</font> Covert - 0.85%";
    TextLabel10.TextColor3 = Color3.fromRGB(221, 74, 73);
    TextLabel10.TextScaled = true;
    TextLabel10.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel10.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel10.ZIndex = 343;
    TextLabel10.Parent = CanvasGroup;
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "3";
    TextLabel11.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel11.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel11.RichText = true;
    TextLabel11.Size = UDim2.fromScale(1, 0.135);
    TextLabel11.Text = "<font color=\"rgb(255,255,255)\">•</font> Classified - 3.8%";
    TextLabel11.TextColor3 = Color3.fromRGB(207, 47, 223);
    TextLabel11.TextScaled = true;
    TextLabel11.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel11.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel11.ZIndex = 343;
    TextLabel11.Parent = CanvasGroup;
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = "4";
    TextLabel12.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel12.BackgroundTransparency = 1;
    TextLabel12.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel12.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel12.RichText = true;
    TextLabel12.Size = UDim2.fromScale(1, 0.135);
    TextLabel12.Text = "<font color=\"rgb(255,255,255)\">•</font> Restricted - 16%";
    TextLabel12.TextColor3 = Color3.fromRGB(117, 65, 220);
    TextLabel12.TextScaled = true;
    TextLabel12.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel12.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel12.ZIndex = 343;
    TextLabel12.Parent = CanvasGroup;
    local TextLabel13 = Instance.new("TextLabel");
    TextLabel13.Name = "5";
    TextLabel13.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel13.BackgroundTransparency = 1;
    TextLabel13.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel13.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel13.RichText = true;
    TextLabel13.Size = UDim2.fromScale(1, 0.135);
    TextLabel13.Text = "<font color=\"rgb(255,255,255)\">•</font> Mil-Spec - 79%";
    TextLabel13.TextColor3 = Color3.fromRGB(73, 103, 231);
    TextLabel13.TextScaled = true;
    TextLabel13.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel13.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel13.ZIndex = 343;
    TextLabel13.Parent = CanvasGroup;
    local TextLabel14 = Instance.new("TextLabel");
    TextLabel14.Name = "6";
    TextLabel14.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel14.BackgroundTransparency = 1;
    TextLabel14.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel14.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel14.RichText = true;
    TextLabel14.Size = UDim2.fromScale(1, 0.135);
    TextLabel14.Text = "<font color=\"rgb(255,255,255)\">•</font> KillTrackᴷ⁺ - 10%";
    TextLabel14.TextColor3 = Color3.fromRGB(207, 106, 50);
    TextLabel14.TextScaled = true;
    TextLabel14.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel14.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel14.ZIndex = 343;
    TextLabel14.Parent = CanvasGroup;
    local UIPadding3 = Instance.new("UIPadding");
    UIPadding3.Name = "UIPadding";
    UIPadding3.PaddingBottom = UDim.new(0.1, 0);
    UIPadding3.PaddingLeft = UDim.new(0.05, 0);
    UIPadding3.PaddingRight = UDim.new(0.05, 0);
    UIPadding3.PaddingTop = UDim.new(0.06, 0);
    UIPadding3.Parent = CanvasGroup;
    local TextLabel15 = Instance.new("TextLabel");
    TextLabel15.Name = "0";
    TextLabel15.BackgroundTransparency = 1;
    TextLabel15.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel15.LayoutOrder = 100;
    TextLabel15.Position = UDim2.fromScale(0, 0.02);
    TextLabel15.RichText = true;
    TextLabel15.Size = UDim2.fromScale(1, 0.16);
    TextLabel15.Text = "CONTAINER CHANCES";
    TextLabel15.TextColor3 = Color3.new(1, 1, 1);
    TextLabel15.TextScaled = true;
    TextLabel15.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel15.ZIndex = 343;
    TextLabel15.Parent = CanvasGroup;
    CanvasGroup.Parent = ImageButton3;
    ImageButton3.Parent = Frame7;
    Frame7.Parent = Frame3;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "LineBar";
    Frame8.AnchorPoint = Vector2.new(0, 1);
    Frame8.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame8.BackgroundTransparency = 0.8;
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Size = UDim2.new(1, 0, 0, 1);
    Frame8.Parent = Frame3;
    Frame3.Parent = Frame2;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "SkipBar";
    Frame9.AnchorPoint = Vector2.new(0.5, 1);
    Frame9.BackgroundTransparency = 1;
    Frame9.Position = UDim2.fromScale(0.5, 1.1);
    Frame9.Size = UDim2.fromScale(1, 0.08);
    Frame9.Visible = false;
    Frame9.ZIndex = 346;
    local UIPadding4 = Instance.new("UIPadding");
    UIPadding4.Name = "PaddingSkip";
    UIPadding4.PaddingBottom = UDim.new(0.2, 0);
    UIPadding4.PaddingLeft = UDim.new(0.01, 0);
    UIPadding4.PaddingRight = UDim.new(0.01, 0);
    UIPadding4.PaddingTop = UDim.new(0.2, 0);
    UIPadding4.Parent = Frame9;
    local UIListLayout5 = Instance.new("UIListLayout");
    UIListLayout5.Name = "ListLayoutSkip";
    UIListLayout5.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout5.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout5.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout5.Parent = Frame9;
    local ImageButton4 = Instance.new("ImageButton");
    ImageButton4.Name = "Skip";
    ImageButton4.AutoButtonColor = false;
    ImageButton4.BackgroundColor3 = Color3.new(1, 1, 1);
    ImageButton4.BackgroundTransparency = 0.9;
    ImageButton4.Size = UDim2.fromScale(0.08, 1);
    local UICorner10 = Instance.new("UICorner");
    UICorner10.CornerRadius = UDim.new(0.05, 0);
    UICorner10.Name = "CornerSkip";
    UICorner10.Parent = ImageButton4;
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Name = "StrokeSkip";
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke4.Color = Color3.new(1, 1, 1);
    UIStroke4.Transparency = 0.875;
    UIStroke4.Parent = ImageButton4;
    local TextLabel16 = Instance.new("TextLabel");
    TextLabel16.Name = "TextSkip";
    TextLabel16.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel16.BackgroundTransparency = 1;
    TextLabel16.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel16.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel16.Size = UDim2.fromScale(0.9, 0.6);
    TextLabel16.Text = "SKIP";
    TextLabel16.TextColor3 = Color3.new(1, 1, 1);
    TextLabel16.TextScaled = true;
    TextLabel16.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel16.ZIndex = 343;
    TextLabel16.Parent = ImageButton4;
    ImageButton4.Parent = Frame9;
    Frame9.Parent = Frame2;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "FrameTop";
    Frame10.AnchorPoint = Vector2.new(0.5, 0);
    Frame10.BackgroundTransparency = 1;
    Frame10.Position = UDim2.fromScale(0.5, 0.025);
    Frame10.Size = UDim2.fromScale(0.75, 0.133811);
    local TextLabel17 = Instance.new("TextLabel");
    TextLabel17.Name = "MainText";
    TextLabel17.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel17.BackgroundTransparency = 1;
    TextLabel17.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel17.Position = UDim2.fromScale(0.5, 0.00109355);
    TextLabel17.Size = UDim2.fromScale(0.75, 0.4);
    TextLabel17.Text = "Unlock Container";
    TextLabel17.TextColor3 = Color3.fromRGB(234, 234, 234);
    TextLabel17.TextScaled = true;
    TextLabel17.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel17.ZIndex = 343;
    TextLabel17.Parent = Frame10;
    local TextLabel18 = Instance.new("TextLabel");
    TextLabel18.Name = "DownText";
    TextLabel18.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel18.BackgroundTransparency = 1;
    TextLabel18.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel18.Position = UDim2.fromScale(0.498, 0.42);
    TextLabel18.RichText = true;
    TextLabel18.Size = UDim2.fromScale(0.75, 0.25);
    TextLabel18.Text = "Unlock <font weight=\"Bold\">Epic Case</font>";
    TextLabel18.TextColor3 = Color3.fromRGB(234, 234, 234);
    TextLabel18.TextScaled = true;
    TextLabel18.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel18.ZIndex = 343;
    TextLabel18.Parent = Frame10;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Null";
    Frame11.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame11.BackgroundTransparency = 1;
    Frame11.Position = UDim2.fromScale(0.47, 0.823);
    Frame11.Size = UDim2.fromScale(0.6, 0.221498);
    local TextLabel19 = Instance.new("TextLabel");
    TextLabel19.Name = "MainText";
    TextLabel19.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel19.AutoLocalize = false;
    TextLabel19.BackgroundTransparency = 1;
    TextLabel19.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel19.LayoutOrder = 4;
    TextLabel19.Position = UDim2.fromScale(0.12, 0.5);
    TextLabel19.Size = UDim2.fromScale(1, 1.1);
    TextLabel19.Text = "This container can only be opened once";
    TextLabel19.TextColor3 = Color3.new(1, 1, 1);
    TextLabel19.TextScaled = true;
    TextLabel19.TextTransparency = 0.25;
    TextLabel19.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel19.ZIndex = 9;
    TextLabel19.Parent = Frame11;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "IconInfo";
    ImageLabel5.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://80205853195967";
    ImageLabel5.Position = UDim2.fromScale(0.04, 0.55);
    ImageLabel5.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel5.Parent = Frame11;
    Frame11.Parent = Frame10;
    Frame10.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "InventoryInspect";
    Frame12.AnchorPoint = Vector2.new(0, 1);
    Frame12.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    Frame12.BackgroundTransparency = 0.9;
    Frame12.BorderColor3 = Color3.new();
    Frame12.BorderSizePixel = 0;
    Frame12.ClipsDescendants = true;
    Frame12.Position = UDim2.fromScale(0, 1);
    Frame12.Size = UDim2.fromScale(1, 0.45);
    Frame12.ZIndex = 2;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "DOTS";
    ImageLabel6.BackgroundColor3 = Color3.new();
    ImageLabel6.BackgroundTransparency = 0.9;
    ImageLabel6.Image = "rbxassetid://91991932054752";
    ImageLabel6.ImageColor3 = Color3.fromRGB(86, 86, 86);
    ImageLabel6.ImageTransparency = 0.6;
    ImageLabel6.LayoutOrder = -1;
    ImageLabel6.Position = UDim2.fromScale(0, 0.00185185);
    ImageLabel6.ScaleType = Enum.ScaleType.Tile;
    ImageLabel6.Size = UDim2.fromScale(1, 1);
    ImageLabel6.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel6.ZIndex = -1;
    ImageLabel6.Parent = Frame12;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Chances";
    Frame13.AnchorPoint = Vector2.new(0, 1);
    Frame13.BackgroundColor3 = Color3.fromRGB(63, 63, 76);
    Frame13.BackgroundTransparency = 0.8;
    Frame13.BorderColor3 = Color3.new();
    Frame13.BorderSizePixel = 0;
    Frame13.Visible = true;
    Frame13.Size = UDim2.fromScale(0.1, 0.255597);
    local TextLabel20 = Instance.new("TextLabel");
    TextLabel20.Name = "Title";
    TextLabel20.BackgroundTransparency = 1;
    TextLabel20.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel20.Position = UDim2.fromScale(0, 0.02);
    TextLabel20.RichText = true;
    TextLabel20.Size = UDim2.fromScale(1, 0.16);
    TextLabel20.Text = "CONTAINER CHANCES";
    TextLabel20.TextColor3 = Color3.new(1, 1, 1);
    TextLabel20.TextScaled = true;
    TextLabel20.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel20.ZIndex = 343;
    TextLabel20.Parent = Frame13;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "Rarities";
    Frame14.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame14.BackgroundTransparency = 1;
    Frame14.Position = UDim2.fromScale(0.5, 0.6);
    Frame14.Size = UDim2.fromScale(0.8, 0.8);
    local UIListLayout6 = Instance.new("UIListLayout");
    UIListLayout6.Name = "UIListLayout";
    UIListLayout6.Parent = Frame14;
    local TextLabel21 = Instance.new("TextLabel");
    TextLabel21.Name = "1";
    TextLabel21.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel21.BackgroundTransparency = 1;
    TextLabel21.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel21.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel21.RichText = true;
    TextLabel21.Size = UDim2.fromScale(1, 0.16);
    TextLabel21.Text = "Exceeding Rare - 0.35%";
    TextLabel21.TextColor3 = Color3.fromRGB(232, 169, 45);
    TextLabel21.TextScaled = true;
    TextLabel21.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel21.ZIndex = 343;
    TextLabel21.Parent = Frame14;
    local TextLabel22 = Instance.new("TextLabel");
    TextLabel22.Name = "2";
    TextLabel22.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel22.BackgroundTransparency = 1;
    TextLabel22.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel22.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel22.RichText = true;
    TextLabel22.Size = UDim2.fromScale(1, 0.16);
    TextLabel22.Text = "Covert - 0.85%";
    TextLabel22.TextColor3 = Color3.fromRGB(221, 74, 73);
    TextLabel22.TextScaled = true;
    TextLabel22.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel22.ZIndex = 343;
    TextLabel22.Parent = Frame14;
    local TextLabel23 = Instance.new("TextLabel");
    TextLabel23.Name = "3";
    TextLabel23.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel23.BackgroundTransparency = 1;
    TextLabel23.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel23.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel23.RichText = true;
    TextLabel23.Size = UDim2.fromScale(1, 0.16);
    TextLabel23.Text = "Classified - 3.8%";
    TextLabel23.TextColor3 = Color3.fromRGB(207, 47, 223);
    TextLabel23.TextScaled = true;
    TextLabel23.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel23.ZIndex = 343;
    TextLabel23.Parent = Frame14;
    local TextLabel24 = Instance.new("TextLabel");
    TextLabel24.Name = "4";
    TextLabel24.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel24.BackgroundTransparency = 1;
    TextLabel24.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel24.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel24.RichText = true;
    TextLabel24.Size = UDim2.fromScale(1, 0.16);
    TextLabel24.Text = "Restricted - 16%";
    TextLabel24.TextColor3 = Color3.fromRGB(117, 65, 220);
    TextLabel24.TextScaled = true;
    TextLabel24.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel24.ZIndex = 343;
    TextLabel24.Parent = Frame14;
    local TextLabel25 = Instance.new("TextLabel");
    TextLabel25.Name = "5";
    TextLabel25.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel25.BackgroundTransparency = 1;
    TextLabel25.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel25.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel25.RichText = true;
    TextLabel25.Size = UDim2.fromScale(1, 0.16);
    TextLabel25.Text = "Mil-Spec - 79%";
    TextLabel25.TextColor3 = Color3.fromRGB(73, 103, 231);
    TextLabel25.TextScaled = true;
    TextLabel25.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel25.ZIndex = 343;
    TextLabel25.Parent = Frame14;
    local TextLabel26 = Instance.new("TextLabel");
    TextLabel26.Name = "6";
    TextLabel26.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel26.BackgroundTransparency = 1;
    TextLabel26.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel26.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel26.RichText = true;
    TextLabel26.Size = UDim2.fromScale(1, 0.16);
    TextLabel26.Text = "KillTrackᴷ⁺ - 10%";
    TextLabel26.TextColor3 = Color3.fromRGB(207, 106, 50);
    TextLabel26.TextScaled = true;
    TextLabel26.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel26.ZIndex = 343;
    TextLabel26.Parent = Frame14;
    Frame14.Parent = Frame13;
    Frame13.Parent = Frame12;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "TopUnder";
    Frame15.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    Frame15.BackgroundTransparency = 0.9;
    Frame15.BorderColor3 = Color3.new();
    Frame15.BorderSizePixel = 0;
    Frame15.Position = UDim2.fromScale(-1.27289e-7, 0);
    Frame15.Size = UDim2.fromScale(1, 0.1);
    Frame15.ZIndex = 5;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "LineUnder";
    Frame16.AnchorPoint = Vector2.new(0.5, 1);
    Frame16.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame16.BackgroundTransparency = 0.8;
    Frame16.BorderColor3 = Color3.new();
    Frame16.BorderSizePixel = 0;
    Frame16.Position = UDim2.fromScale(0.5, 1);
    Frame16.Size = UDim2.new(0.95, 0, 0, 1);
    Frame16.Parent = Frame15;
    local TextLabel27 = Instance.new("TextLabel");
    TextLabel27.Name = "Note";
    TextLabel27.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel27.BackgroundTransparency = 1;
    TextLabel27.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel27.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel27.RichText = true;
    TextLabel27.Size = UDim2.fromScale(0.75, 0.55);
    TextLabel27.Text = "Open and receive one of the following";
    TextLabel27.TextColor3 = Color3.new(1, 1, 1);
    TextLabel27.TextScaled = true;
    TextLabel27.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel27.ZIndex = 343;
    TextLabel27.Parent = Frame15;
    local TextLabel28 = Instance.new("TextLabel");
    TextLabel28.Name = "Title";
    TextLabel28.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel28.BackgroundTransparency = 1;
    TextLabel28.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel28.Position = UDim2.fromScale(0.97, 0.5);
    TextLabel28.RichText = true;
    TextLabel28.Size = UDim2.fromScale(0.075, 0.5);
    TextLabel28.Text = "INSPECT ITEMS";
    TextLabel28.TextColor3 = Color3.new(1, 1, 1);
    TextLabel28.TextScaled = true;
    TextLabel28.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel28.ZIndex = 343;
    TextLabel28.Parent = Frame15;
    Frame15.Parent = Frame12;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "ScrollingHolder";
    ScrollingFrame.Active = true;
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.Position = UDim2.fromScale(0.5, 0.1);
    ScrollingFrame.ScrollBarThickness = 8;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.Size = UDim2.fromScale(0.99, 0.697685);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGrid5";
    UIGridLayout.CellPadding = UDim2.fromScale(0.012, 0.2);
    UIGridLayout.CellSize = UDim2.fromScale(0.088, 0.25);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint3.Name = "Constraint5";
    UIAspectRatioConstraint3.AspectRatio = 1.425;
    UIAspectRatioConstraint3.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint3.Parent = UIGridLayout;
    UIGridLayout.Parent = ScrollingFrame;
    local UIPadding5 = Instance.new("UIPadding");
    UIPadding5.Name = "Padding5";
    UIPadding5.PaddingBottom = UDim.new(0.01, 0);
    UIPadding5.PaddingLeft = UDim.new(0.02, 0);
    UIPadding5.PaddingRight = UDim.new(0.04, 0);
    UIPadding5.PaddingTop = UDim.new(0.01, 0);
    UIPadding5.Parent = ScrollingFrame;
    ScrollingFrame.Parent = Frame12;
    Frame12.Parent = Frame;
    local ImageLabel7 = Instance.new("ImageLabel");
    ImageLabel7.Name = "MainIconBackground";
    ImageLabel7.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel7.BackgroundTransparency = 1;
    ImageLabel7.Image = "rbxassetid://100429874437897";
    ImageLabel7.Position = UDim2.fromScale(0.5, 0.45);
    ImageLabel7.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel7.ZIndex = -1;
    ImageLabel7.Visible = false;
    local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint4.Name = "Constraint";
    UIAspectRatioConstraint4.Parent = ImageLabel7;
    ImageLabel7.Parent = Frame;
    local CanvasGroup2 = Instance.new("CanvasGroup");
    CanvasGroup2.Name = "SkinsGroup";
    CanvasGroup2.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup2.BackgroundTransparency = 1;
    CanvasGroup2.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup2.Size = UDim2.fromScale(1, 0.68);
    CanvasGroup2.GroupTransparency = 1;
    CanvasGroup2.Visible = true;
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "CenterLine";
    Frame17.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame17.BackgroundColor3 = Color3.fromRGB(189, 179, 107);
    Frame17.BorderColor3 = Color3.new();
    Frame17.BorderSizePixel = 0;
    Frame17.Position = UDim2.fromScale(0.5, 0.5);
    Frame17.Size = UDim2.new(0, 2, 0.33, 0);
    Frame17.ZIndex = 20;
    local Frame18 = Instance.new("Frame");
    Frame18.Name = "LeftShadow";
    Frame18.AnchorPoint = Vector2.new(1, 0.5);
    Frame18.BackgroundColor3 = Color3.new();
    Frame18.BorderColor3 = Color3.new();
    Frame18.BorderSizePixel = 0;
    Frame18.Position = UDim2.fromScale(0, 0.5);
    Frame18.Size = UDim2.fromScale(2, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIShadow";
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.885246) });
    UIGradient.Parent = Frame18;
    Frame18.Parent = Frame17;
    local Frame19 = Instance.new("Frame");
    Frame19.Name = "RightShadow";
    Frame19.AnchorPoint = Vector2.new(0, 0.5);
    Frame19.BackgroundColor3 = Color3.new();
    Frame19.BorderColor3 = Color3.new();
    Frame19.BorderSizePixel = 0;
    Frame19.Position = UDim2.fromScale(1, 0.5);
    Frame19.Size = UDim2.fromScale(2, 1);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIShadow";
    UIGradient2.Rotation = 180;
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.885246) });
    UIGradient2.Parent = Frame19;
    Frame19.Parent = Frame17;
    Frame17.Parent = CanvasGroup2;
    local CanvasGroup3 = Instance.new("CanvasGroup");
    CanvasGroup3.Name = "LupaGroup";
    CanvasGroup3.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup3.BackgroundColor3 = Color3.new();
    CanvasGroup3.BackgroundTransparency = 0.8;
    CanvasGroup3.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup3.Size = UDim2.fromScale(1, 1);
    CanvasGroup3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    CanvasGroup3.ZIndex = 2;
    local UICorner11 = Instance.new("UICorner");
    UICorner11.Name = "UICorner";
    UICorner11.CornerRadius = UDim.new(1, 0);
    UICorner11.Parent = CanvasGroup3;
    local ScrollingFrame2 = Instance.new("ScrollingFrame");
    ScrollingFrame2.Name = "ScrollingLupa";
    ScrollingFrame2.Active = true;
    ScrollingFrame2.AnchorPoint = Vector2.new(0.5, 0.5);
    ScrollingFrame2.BackgroundTransparency = 1;
    ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.X;
    ScrollingFrame2.CanvasSize = UDim2.fromScale(2, 0);
    ScrollingFrame2.Position = UDim2.fromScale(0.5, 0.5);
    ScrollingFrame2.ScrollBarImageColor3 = Color3.new();
    ScrollingFrame2.ScrollBarThickness = 0;
    ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.X;
    ScrollingFrame2.ScrollingEnabled = false;
    ScrollingFrame2.Size = UDim2.fromScale(1, 0.3);
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Scale = 1.1;
    UIScale.Parent = ScrollingFrame2;
    local UIListLayout7 = Instance.new("UIListLayout");
    UIListLayout7.Name = "UIListLayout";
    UIListLayout7.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout7.Padding = UDim.new(0.022, 0);
    UIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout7.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout7.Parent = ScrollingFrame2;
    ScrollingFrame2.Parent = CanvasGroup3;
    CanvasGroup3.Parent = CanvasGroup2;
    local CanvasGroup4 = Instance.new("CanvasGroup");
    CanvasGroup4.Name = "ScrollGroup";
    CanvasGroup4.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup4.BackgroundTransparency = 1;
    CanvasGroup4.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup4.Size = UDim2.fromScale(2, 0.3);
    CanvasGroup4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local ScrollingFrame3 = Instance.new("ScrollingFrame");
    ScrollingFrame3.Name = "MainScroll";
    ScrollingFrame3.Active = true;
    ScrollingFrame3.AnchorPoint = Vector2.new(0.5, 0.5);
    ScrollingFrame3.AutomaticCanvasSize = Enum.AutomaticSize.X;
    ScrollingFrame3.BackgroundTransparency = 1;
    ScrollingFrame3.CanvasSize = UDim2.fromScale(2, 0);
    ScrollingFrame3.Position = UDim2.fromScale(0.5, 0.5);
    ScrollingFrame3.ScrollBarImageColor3 = Color3.new();
    ScrollingFrame3.ScrollBarThickness = 0;
    ScrollingFrame3.ScrollingDirection = Enum.ScrollingDirection.X;
    ScrollingFrame3.ScrollingEnabled = false;
    ScrollingFrame3.Size = UDim2.fromScale(1, 1);
    local UIListLayout8 = Instance.new("UIListLayout");
    UIListLayout8.Name = "UIListLayout";
    UIListLayout8.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout8.Padding = UDim.new(0.0103, 0);
    UIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout8.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout8.Parent = ScrollingFrame3;
    ScrollingFrame3.Parent = CanvasGroup4;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.2),
        NumberSequenceKeypoint.new(0.3, 0.2),
        NumberSequenceKeypoint.new(0.30512, 1),
        NumberSequenceKeypoint.new(0.695, 1),
        NumberSequenceKeypoint.new(0.7, 0.2),
        NumberSequenceKeypoint.new(0.8, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient3.Parent = CanvasGroup4;
    CanvasGroup4.Parent = CanvasGroup2;
    CanvasGroup2.Parent = Frame;
    local CanvasGroup5 = Instance.new("CanvasGroup");
    CanvasGroup5.Name = "MultiGroup";
    CanvasGroup5.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup5.BackgroundTransparency = 1;
    CanvasGroup5.GroupTransparency = 1;
    CanvasGroup5.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup5.Size = UDim2.fromScale(0.72, 0.68);
    local UIListLayout9 = Instance.new("UIListLayout");
    UIListLayout9.Name = "ListLayoutMulti";
    UIListLayout9.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout9.Padding = UDim.new(0.02, 0);
    UIListLayout9.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout9.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout9.Parent = CanvasGroup5;
    CanvasGroup5.Parent = Frame;
    local Frame20 = Instance.new("Frame");
    Frame20.Name = "Results";
    Frame20.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame20.BackgroundTransparency = 1;
    Frame20.Position = UDim2.fromScale(0.5, 0.38);
    Frame20.Size = UDim2.fromScale(0.8, 0.3);
    Frame20.Visible = false;
    Frame20.ZIndex = 3;
    local TextLabel29 = Instance.new("TextLabel");
    TextLabel29.Name = "Title";
    TextLabel29.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel29.BackgroundTransparency = 1;
    TextLabel29.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel29.Position = UDim2.fromScale(0.5, 0);
    TextLabel29.Size = UDim2.fromScale(1, 0.12);
    TextLabel29.Text = "YOU RECEIVED";
    TextLabel29.TextColor3 = Color3.fromRGB(234, 234, 234);
    TextLabel29.TextScaled = true;
    TextLabel29.Parent = Frame20;
    local Frame21 = Instance.new("Frame");
    Frame21.Name = "Holder";
    Frame21.BackgroundTransparency = 1;
    Frame21.Position = UDim2.fromScale(0, 0.18);
    Frame21.Size = UDim2.fromScale(1, 0.62);
    local UIListLayout10 = Instance.new("UIListLayout");
    UIListLayout10.Name = "ListLayoutResults";
    UIListLayout10.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout10.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout10.Padding = UDim.new(0.015, 0);
    UIListLayout10.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout10.Parent = Frame21;
    Frame21.Parent = Frame20;
    Frame20.Parent = Frame;
    local v219, v220 = u6.NewSlider("Slider", Frame4, 1, 1, 1, 100, false, function() -- Line: 2907
    end, 0, "Slider", nil, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 25, 50, 100 });
    u9 = v219;
    u10 = v220;
    u9.Visible = false;
    u9.Line.Visible = false;
    u9.SlideText.Visible = false;

    return Frame;
end;

function u1.AddSkin(p221: userdata, p222: string, p223, p224, p225, p226, p227: any) -- Line: 2918
    local Frame = Instance.new("Frame");
    Frame.Name = p227 or "SkinFrame";
    Frame.BackgroundColor3 = Color3.fromRGB(112, 108, 115);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(1.2, 1);
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Gradient";
    Frame2.BackgroundColor3 = p223;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.fromScale(1, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(203, 203, 203)) });
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.649626, 1), NumberSequenceKeypoint.new(1, 0) });
    UIGradient.Parent = Frame2;
    Frame2.Parent = Frame;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Icon";
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = p222;
    ImageButton.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.ZIndex = 6;
    ImageButton.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Rarity";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundColor3 = p223;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.fromScale(1, 0.045);
    Frame3.ZIndex = 4;
    Frame3.Parent = Frame;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Blur";
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.AutoLocalize = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://6430908053";
    ImageButton2.ImageTransparency = 0.7;
    ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton2.ScaleType = Enum.ScaleType.Fit;
    ImageButton2.Size = UDim2.fromScale(1, 1);
    ImageButton2.ZIndex = 3;
    ImageButton2.Parent = Frame;
    Frame.Parent = p221;

    return Frame;
end;

function u1.AddRareItem(p228) -- Line: 2992
    -- upvalues: TweenService (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "SkinFrame";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromOffset(100, 100);
    Frame.LayoutOrder = 999999;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Icon";
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://109157939970080";
    ImageButton.Position = UDim2.fromScale(0, -1.30062e-7);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(1, 0.965);
    ImageButton.ZIndex = 5;
    ImageButton.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "RarityColor";
    Frame2.AnchorPoint = Vector2.new(0.5, 1);
    Frame2.BackgroundColor3 = Color3.fromRGB(232, 201, 23);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 1);
    Frame2.Size = UDim2.fromScale(1, 0.035);
    Frame2.ZIndex = 4;
    Frame2.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Shadow";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://186491278";
    ImageLabel.ImageTransparency = 0.24;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Slice;
    ImageLabel.Size = UDim2.new(1, 30, 1, 30);
    ImageLabel.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel.ZIndex = -9999;
    ImageLabel.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "WeaponName";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.RichText = true;
    TextLabel.Position = UDim2.fromScale(0, 1);
    TextLabel.Size = UDim2.fromScale(1, 0.175);
    TextLabel.Text = "★Rare Special Item★";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.75;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Skinname";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0, 1.175);
    TextLabel2.Size = UDim2.fromScale(1, 0.15);
    TextLabel2.Text = "Click to view";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeTransparency = 0.75;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel2.Parent = Frame;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "GradientBack";
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(255, 220, 47);
    CanvasGroup.BorderColor3 = Color3.new();
    CanvasGroup.BorderSizePixel = 0;
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "GradientBack";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundColor3 = Color3.fromRGB(255, 215, 115);
    ImageLabel2.BorderColor3 = Color3.new();
    ImageLabel2.BorderSizePixel = 0;
    ImageLabel2.Image = "rbxassetid://130628562866434";
    ImageLabel2.ImageColor3 = Color3.fromRGB(255, 238, 0);
    ImageLabel2.ImageTransparency = 0.3;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ResampleMode = Enum.ResamplerMode.Pixelated;
    ImageLabel2.Size = UDim2.fromScale(1.5, 1.5);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel2.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame;
    TweenService:Create(ImageLabel2, TweenInfo.new(18, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {
        Rotation = 360
    }):Play();
    Frame.Parent = p228;

    return Frame;
end;

function u1.rareItems() -- Line: 3114
    -- upvalues: u4 (ref)
    RareItems = Instance.new("ImageButton");
    RareItems.Name = "RareItems";
    RareItems:SetAttribute("NoSelect", true);
    RareItems.AutoButtonColor = false;
    RareItems.ImageTransparency = 1;
    RareItems.AnchorPoint = Vector2.new(0.5, 0.5);
    RareItems.BackgroundColor3 = Color3.new();
    RareItems.BackgroundTransparency = 1;
    RareItems.BorderColor3 = Color3.new();
    RareItems.BorderSizePixel = 0;
    RareItems.Position = UDim2.fromScale(0.5, 0.5);
    RareItems.Size = UDim2.fromScale(1, 1);
    RareItems.Active = true;
    RareItems.Interactable = true;
    RareItems.ZIndex = 10000;
    RareItems.LayoutOrder = 10000;
    RareItems.Visible = false;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Main";
    CanvasGroup.Active = true;
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.AutoLocalize = false;
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(22, 22, 25);
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.fromScale(0.55, 0.65);
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.ZIndex = 10;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.fromRGB(199, 199, 199);
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 0.35;
    UIStroke.Parent = CanvasGroup;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "RightDown";
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0, 0.886616);
    Frame.Size = UDim2.fromScale(1, 0.113385);
    Frame.ZIndex = 53215;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "PaddingDown";
    UIPadding.PaddingBottom = UDim.new(0.2, 0);
    UIPadding.PaddingLeft = UDim.new(0.02, 0);
    UIPadding.PaddingRight = UDim.new(0.02, 0);
    UIPadding.PaddingTop = UDim.new(0.2, 0);
    UIPadding.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "ListLayoutDown";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0.02, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Close";
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.LayoutOrder = 10;
    ImageButton.Position = UDim2.fromScale(0.912435, -2.95801e-7);
    ImageButton.Size = UDim2.fromScale(0.087565, 1);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextClose";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.9, 0.6);
    TextLabel.Text = "CLOSE";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel.ZIndex = 343;
    TextLabel.Parent = ImageButton;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "Corner1";
    UICorner.BottomLeftRadius = UDim.new(0.05, 0);
    UICorner.BottomRightRadius = UDim.new(0.05, 0);
    UICorner.CornerRadius = UDim.new(0.05, 0);
    UICorner.TopLeftRadius = UDim.new(0.05, 0);
    UICorner.TopRightRadius = UDim.new(0.05, 0);
    UICorner.Parent = ImageButton;
    ImageButton.Parent = Frame;
    Frame.Parent = CanvasGroup;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel2.Position = UDim2.fromScale(0.5, 0.0183581);
    TextLabel2.Size = UDim2.fromScale(0.75, 0.0700556);
    TextLabel2.Text = "RARE SPECIAL ITEMS";
    TextLabel2.TextColor3 = Color3.fromRGB(234, 234, 234);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel2.ZIndex = 343;
    TextLabel2.Parent = CanvasGroup;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Hint";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.LayoutOrder = 4;
    TextLabel3.Position = UDim2.fromScale(0.5, 0.086572);
    TextLabel3.Size = UDim2.fromScale(1, 0.0391906);
    TextLabel3.Text = "One of the following items may be inside";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 9;
    TextLabel3.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundColor3 = Color3.new();
    ImageLabel.BackgroundTransparency = 0.9;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.fromRGB(86, 86, 86);
    ImageLabel.ImageTransparency = 0.8;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel.ZIndex = -1;
    ImageLabel.Parent = CanvasGroup;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.Parent = CanvasGroup;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "ScrollingHolder";
    ScrollingFrame.Active = true;
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    ScrollingFrame.Position = UDim2.fromScale(0.5, 0.125763);
    ScrollingFrame.ScrollBarThickness = 8;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.Size = UDim2.fromScale(0.99, 0.760853);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "Padding5";
    UIPadding2.PaddingBottom = UDim.new(0.01, 0);
    UIPadding2.PaddingLeft = UDim.new(0.03, 0);
    UIPadding2.PaddingRight = UDim.new(0.03, 0);
    UIPadding2.PaddingTop = UDim.new(0.03, 0);
    UIPadding2.Parent = ScrollingFrame;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGrid5";
    UIGridLayout.CellPadding = UDim2.fromScale(0.012, 0.012);
    UIGridLayout.CellSize = UDim2.fromScale(0.24, 0.315);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.Parent = ScrollingFrame;
    UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 3296
        -- upvalues: ScrollingFrame (copy), UIGridLayout (copy)
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 100);
    end);
    ScrollingFrame.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "LineBar";
    Frame2.AnchorPoint = Vector2.new(0, 1);
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 0.8;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0, 0.9);
    Frame2.Size = UDim2.new(1, 0, 0, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.100956, 1),
        NumberSequenceKeypoint.new(0.199787, 0),
        NumberSequenceKeypoint.new(0.798087, 0),
        NumberSequenceKeypoint.new(0.899044, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame2;
    Frame2.Parent = CanvasGroup;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Icon";
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://109157939970080";
    ImageButton2.Position = UDim2.fromScale(0.014, 0.89);
    ImageButton2.ScaleType = Enum.ScaleType.Fit;
    ImageButton2.Size = UDim2.fromScale(0.12, 0.12);
    ImageButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton2.ZIndex = 5;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "MainText";
    TextLabel4.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel4.LayoutOrder = 4;
    TextLabel4.Position = UDim2.fromScale(1.05, 0.5);
    TextLabel4.Size = UDim2.fromScale(4, 0.3);
    TextLabel4.Text = "Click a knife to inspect";
    TextLabel4.TextColor3 = Color3.fromRGB(222, 222, 222);
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.25;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = ImageButton2;
    ImageButton2.Parent = CanvasGroup;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.58;
    UIAspectRatioConstraint.Parent = CanvasGroup;
    CanvasGroup.Parent = RareItems;
    RareItems.Parent = u4;
end;

function u1.multiRow(p229) -- Line: 3369
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Row";
    CanvasGroup.BackgroundColor3 = Color3.new();
    CanvasGroup.BackgroundTransparency = 0.8;
    CanvasGroup.BorderSizePixel = 0;
    CanvasGroup.Size = UDim2.fromScale(1, 0.2);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0),
        NumberSequenceKeypoint.new(0.85, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = CanvasGroup;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "MainScroll";
    ScrollingFrame.Active = true;
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.CanvasSize = UDim2.fromScale(2, 0);
    ScrollingFrame.Position = UDim2.fromScale(0.5, 0.5);
    ScrollingFrame.ScrollBarImageColor3 = Color3.new();
    ScrollingFrame.ScrollBarThickness = 0;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X;
    ScrollingFrame.ScrollingEnabled = false;
    ScrollingFrame.Size = UDim2.fromScale(1, 0.9);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.Padding = UDim.new(0.005, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = ScrollingFrame;
    ScrollingFrame.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "CenterLine";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(189, 179, 107);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.new(0, 2, 1, 0);
    Frame.ZIndex = 20;
    Frame.Parent = CanvasGroup;
    CanvasGroup.Parent = p229;

    return CanvasGroup;
end;

function u1.resultItem(p230: any, p231: string, p232, p233: string) -- Line: 3427
    -- upvalues: u1 (copy)
    local v234 = u1.AddSkin(p230, p231, p232, UDim2.fromScale(1, 0.965), UDim2.fromScale(0, 0), Vector2.new(0, 0), "Result");
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "WeaponName";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0, 1.04);
    TextLabel.Size = UDim2.fromScale(1, 0.16);
    TextLabel.Text = p233;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.75;
    TextLabel.Parent = v234;
    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "UIShadow";
    UIShadow.BlurRadius = UDim.new(0.1, 0);
    UIShadow.Transparency = 1;
    UIShadow.Parent = v234;

    return v234;
end;

function u1.rareItem(p235) -- Line: 3455
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "SkinFrame";
    CanvasGroup.BackgroundColor3 = Color3.new(1, 1, 1);
    CanvasGroup.ClipsDescendants = false;
    CanvasGroup.LayoutOrder = 10;
    CanvasGroup.Size = UDim2.fromOffset(100, 100);
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Icon";
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://98403897714532";
    ImageButton.Position = UDim2.fromScale(0, -1.20221e-7);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(1, 0.978);
    ImageButton.ZIndex = 5;
    ImageButton.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "RarityColor";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(232, 186, 21);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 1);
    Frame.Size = UDim2.fromScale(1, 0.025);
    Frame.ZIndex = 4;
    Frame.Parent = CanvasGroup;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "WeaponName";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.RichText = true;
    TextLabel.Position = UDim2.fromScale(0.5, 0.84);
    TextLabel.Size = UDim2.fromScale(0.94, 0.126364);
    TextLabel.Text = "Karambit | Crimson";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.6;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.ZIndex = 6;
    TextLabel.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "GradientBack";
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.fromScale(1, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "Gradient";
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 65, 65)),
        ColorSequenceKeypoint.new(0.17128, Color3.fromRGB(99, 99, 99)),
        ColorSequenceKeypoint.new(0.581315, Color3.fromRGB(167, 167, 167)),
        ColorSequenceKeypoint.new(0.690311, Color3.fromRGB(170, 170, 170)),
        ColorSequenceKeypoint.new(0.852941, Color3.fromRGB(154, 154, 154)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(109, 109, 109))
    });
    UIGradient.Rotation = 90;
    UIGradient.Parent = Frame2;
    Frame2.Parent = CanvasGroup;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.04, 0);
    UICorner.BottomRightRadius = UDim.new(0.04, 0);
    UICorner.CornerRadius = UDim.new(0.04, 0);
    UICorner.TopLeftRadius = UDim.new(0.04, 0);
    UICorner.TopRightRadius = UDim.new(0.04, 0);
    UICorner.Parent = CanvasGroup;
    local UIShadow = Instance.new("UIShadow");
    UIShadow.Name = "UIShadow";
    UIShadow.BlurRadius = UDim.new(0.1, 0);
    UIShadow.Parent = CanvasGroup;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 0.92;
    UIStroke.Parent = CanvasGroup;
    CanvasGroup.Parent = p235;

    return CanvasGroup;
end;

return u1;