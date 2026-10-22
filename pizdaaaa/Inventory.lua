-- ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Inventory
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Inventory
-- Decompile time: 82.75 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local HttpService = game:GetService("HttpService");
local PolicyService = game:GetService("PolicyService");
local RunService = game:GetService("RunService");
local u2 = nil;

if RunService:IsStudio() then
    u2 = {
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
    task.spawn(function() -- Line: 33
        -- upvalues: PolicyService (copy), Players (copy), u2 (ref)
        local success, result = pcall(function() -- Line: 34
            -- upvalues: PolicyService (ref), Players (ref)
            return PolicyService:GetPolicyInfoForPlayerAsync(Players.LocalPlayer);
        end);
        u2 = success and result and result or {
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

local function GetPolicyInfo() -- Line: 52
    -- upvalues: u2 (ref), PolicyService (copy), Players (copy)
    if not u2 then
        local success, result = pcall(function() -- Line: 54
            -- upvalues: PolicyService (ref), Players (ref)
            return PolicyService:GetPolicyInfoForPlayerAsync(Players.LocalPlayer);
        end);
        u2 = success and result and result or {
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

    return u2;
end;

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
local u14 = false;
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
local u31 = true;
local u32 = {
    Everything = {
        HasUnder = false,
        Order = 1
    },
    Equipment = {
        HasUnder = true,
        Order = 2,
        Under = { "All Equipment", "Melee", "Pistols", "Mid-Tier", "Rifles", "Misc", "Agents", "Gloves" }
    },
    ["Graphic Art"] = {
        HasUnder = true,
        Order = 3,
        Under = { "All Graphic Art", "Stickers", "Graffiti", "Charms", "Other" }
    },
    Containers = {
        HasUnder = true,
        Order = 4,
        Under = { "All", "Weapon Cases", "Sticker Capsules", "Charms" }
    },
    Display = {
        HasUnder = true,
        Order = 5,
        Under = { "All", "Badges", "Music Kits" }
    }
};
local u33 = {};
local u34 = {};
local u35 = {};
local u36 = nil;
local u37 = {};
local u38 = setmetatable({}, {
    __mode = "k"
});
local TweenInfo_new_ret = TweenInfo.new(0.35, Enum.EasingStyle.Quint);
local u39 = nil;
local u40 = nil;
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = nil;
Color3.fromRGB(207, 106, 50);
local Color3_fromRGB_ret = Color3.fromRGB(175, 231, 255);
local u45 = false;

local function StickerKey(p46) -- Line: 189
    local v47 = {};

    for i, v in p46 or {} do
        local v48 = `{i}:{v.StickerName}`;
        table.insert(v47, v48);
    end;

    table.sort(v47);

    return table.concat(v47, ",");
end;

function u1.GlowIcon(u49: userdata) -- Line: 203
    -- upvalues: Color3_fromRGB_ret (copy), TweenService (copy)
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "GlowShine";
    UIGradient.Rotation = 35;
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.35, Color3_fromRGB_ret),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(205, 175, 255)),
        ColorSequenceKeypoint.new(0.65, Color3_fromRGB_ret),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
    });
    UIGradient.Offset = Vector2.new(-1, 0);
    UIGradient.Parent = u49;
    local u50 = TweenService:Create(UIGradient, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Offset = Vector2.new(1, 0)
    });
    u49.AncestryChanged:Connect(function() -- Line: 219, Name: Update
        -- upvalues: u49 (copy), u50 (copy)
        if u49:IsDescendantOf(game) then
            u50:Play();

            return;
        end;

        u50:Pause();
    end);
    u49.Destroying:Once(function() -- Line: 228
        -- upvalues: u50 (copy)
        u50:Cancel();
        u50:Destroy();
    end);

    if u49:IsDescendantOf(game) then
        u50:Play();

        return;
    end;

    u50:Pause();
end;

function u1.IsLeftSide(p51: userdata) -- Line: 236
    -- upvalues: u7 (ref)
    local AbsoluteSize = u7.AbsoluteSize;

    return AbsoluteSize.X - p51.AbsolutePosition.X > AbsoluteSize.X / 3;
end;

function u1.ItemHover(p52: userdata, p53: string, p54: string, p55: string, p56: string, p57: any, p58: string?, p59: number?) -- Line: 242
    -- upvalues: u8 (ref), u11 (ref), u1 (copy), TweenService (copy)
    local v60;

    if p58 and p58 ~= "" then
        v60 = `''{p58}''`;
    else
        v60 = `{p53} | {p54}`;
    end;

    if p58 and p58 ~= "" then
        p56 = `Name Tag: ''{p58}''\n\n{p56}`;
    end;

    if p59 then
        v60 = `KillTrackᴷ⁺ {v60}`;
        p56 = `KillTrack Confirmed Kills: {p59}\n\n{p56}`;
    end;

    u8.ItemName.Text = v60;
    u8.RarityColor.Text = p55;
    u8.Description.Text = p56;
    u8.RarityColor.TextColor3 = u11[p55] or Color3.fromRGB(188, 203, 219);
    u8.TeamInfo.Text = p57.T and p57.CT and "Both" or (p57.T and "Terrorists" or "Counter-Terrorists");
    u8.TeamIcon.Image = `rbxassetid://{p57.T and p57.CT and "99277837805928" or (p57.T and "118442564192259" or "134307766291506")}`;
    local AbsolutePosition = p52.AbsolutePosition;

    if u1.IsLeftSide(p52) then
        u8.Position = UDim2.new(0, AbsolutePosition.X + p52.AbsoluteSize.X + 20, 0, AbsolutePosition.Y + 20);
    else
        u8.Position = UDim2.new(0, AbsolutePosition.X - u8.AbsoluteSize.X - 20, 0, AbsolutePosition.Y + 20);
    end;

    local Position = u8.Position;
    u8.Position = Position + UDim2.fromOffset(0, 8);
    TweenService:Create(u8, TweenInfo.new(0.15), {
        GroupTransparency = 0
    }):Play();
    TweenService:Create(u8, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = Position
    }):Play();
end;

function u1.LockInfo(p61: userdata, p62: boolean) -- Line: 279
    -- upvalues: TweenService (copy)
    local LockInfo = p61.LockInfo;

    if not p62 then
        local v63 = TweenService:Create(LockInfo, TweenInfo.new(0.15), {
            GroupTransparency = 1
        });
        v63.Completed:Once(function(p64) -- Line: 294
            -- upvalues: LockInfo (copy)
            if p64 == Enum.PlaybackState.Completed then
                LockInfo.Visible = false;
            end;
        end);
        v63:Play();

        return;
    end;

    LockInfo.Visible = true;
    LockInfo.Content.Position = UDim2.fromScale(0, 0.05);
    TweenService:Create(LockInfo, TweenInfo.new(0.2), {
        GroupTransparency = 0
    }):Play();
    TweenService:Create(LockInfo.Content, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0, 0)
    }):Play();
end;

function u1.IsBusy() -- Line: 306
    -- upvalues: u14 (ref)
    return u14;
end;

function u1.CloseClick() -- Line: 310
    -- upvalues: TweenService (copy), u9 (ref), u14 (ref), u10 (ref)
    TweenService:Create(u9, TweenInfo.new(0.15), {
        GroupTransparency = 1
    }):Play();
    u9.Position = UDim2.new(0, 0, -1, 0);
    u14 = false;
    u10:Removes("HoverItem", "TapOutside");
end;

function u1.RightClick(p65: userdata, p66: table) -- Line: 317
    -- upvalues: u20 (ref), u9 (ref), u1 (copy), TweenService (copy), u14 (ref), u10 (ref), u18 (ref), u26 (ref), UserInputService (copy)
    u20.DropDeactive("GLOBAL");

    for _, child in u9.ScrollingFrame:GetChildren() do
        if child:IsA("TextButton") then
            child:Destroy();
        end;
    end;

    for i, v in p66 do
        local v67 = u1.ClickBtn(p66, i, v);
        v67.MouseButton1Click:Connect(function() -- Line: 332
            -- upvalues: TweenService (ref), u9 (ref), u14 (ref), u10 (ref), u18 (ref), v (copy)
            TweenService:Create(u9, TweenInfo.new(0.15), {
                GroupTransparency = 1
            }):Play();
            u9.Position = UDim2.new(0, 0, -1, 0);
            u14 = false;
            u10:Removes("HoverItem", "TapOutside");
            u18.Play("UI.submenu_select");
            v.callback();
        end);
        v67.MouseEnter:Connect(function() -- Line: 345
            -- upvalues: u18 (ref)
            u18.Play("UI.submenu_scroll");
        end);
    end;

    u9.Size = UDim2.new(0.15, 0, #p66 * 0.04, 10);
    TweenService:Create(u9, TweenInfo.new(0.15), {
        GroupTransparency = 0
    }):Play();
    u14 = true;
    local u68 = u26() == "Console" and p65.AbsolutePosition + p65.AbsoluteSize / 2 or UserInputService:GetMouseLocation();
    local AbsoluteSize = p65.AbsoluteSize;
    local AbsolutePosition = p65.AbsolutePosition;

    if u1.IsLeftSide(p65) then
        u9.Position = UDim2.new(0, u68.X + 20, 0, u68.Y);
    else
        u9.Position = UDim2.new(0, u68.X - u9.AbsoluteSize.X - 20, 0, u68.Y);
    end;

    u9.UIScale.Scale = 0.95;
    TweenService:Create(u9.UIScale, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();
    u10:Add("HoverItem", UserInputService.InputChanged:Connect(function(p69, p70) -- Line: 374
        -- upvalues: u68 (ref), AbsolutePosition (copy), AbsoluteSize (copy), u9 (ref), TweenService (ref), u14 (ref), u10 (ref)
        if p69.UserInputType == Enum.UserInputType.MouseMovement then
            u68 = p69.Position;
            local math_abs_ret = math.abs(u68.X - (AbsolutePosition.X + AbsoluteSize.X / 2));
            local math_abs_ret2 = math.abs(u68.Y - (AbsolutePosition.Y + AbsoluteSize.Y / 2));
            local AbsolutePosition2 = u9.AbsolutePosition;
            local AbsoluteSize2 = u9.AbsoluteSize;
            local v71;

            if u68.X >= AbsolutePosition2.X - 15 and (u68.X <= AbsolutePosition2.X + AbsoluteSize2.X + 15 and u68.Y >= AbsolutePosition2.Y - 15) then
                v71 = u68.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y + 15;
            else
                v71 = false;
            end;

            if (AbsoluteSize.X / 2 + 40 < math_abs_ret and true or AbsoluteSize.Y / 2 + 30 < math_abs_ret2) and not v71 then
                TweenService:Create(u9, TweenInfo.new(0.15), {
                    GroupTransparency = 1
                }):Play();
                u9.Position = UDim2.new(0, 0, -1, 0);
                u14 = false;
                u10:Removes("HoverItem", "TapOutside");
            end;
        end;
    end));
    u10:Add("TapOutside", UserInputService.InputBegan:Connect(function(p72) -- Line: 399
        -- upvalues: u9 (ref), AbsolutePosition (copy), AbsoluteSize (copy), u1 (ref)
        if p72.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local AbsolutePosition2 = u9.AbsolutePosition;
        local AbsoluteSize2 = u9.AbsoluteSize;
        local Position = p72.Position;
        local v73;

        if Position.X >= AbsolutePosition2.X and (Position.X <= AbsolutePosition2.X + AbsoluteSize2.X and Position.Y >= AbsolutePosition2.Y) then
            v73 = Position.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y;
        else
            v73 = false;
        end;

        local v74;

        if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
            v74 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v74 = false;
        end;

        if not (v73 or v74) then
            u1.CloseClick();
        end;
    end));
end;

function u1.CreateItem(p75: userdata, u76: any, u77: any, u78: any, u79: any, p80: any, u81: any, u82: any) -- Line: 424
    -- upvalues: u1 (copy), u16 (ref), u17 (ref), u15 (ref), HttpService (copy), u25 (ref), u11 (ref), Players (copy), u10 (ref), StickerKey (copy), u4 (ref), u18 (ref), TweenService (copy), u8 (ref), u12 (ref), u30 (ref), u19 (ref), u39 (ref), u21 (ref), u22 (ref), u38 (copy), u43 (ref)
    local u83 = u1.newItem(u81, u82);
    local EquipTeam = u83.EquipTeam;
    local u84 = u16.GetCategory(u76) or u17.Get(u76);
    local u85 = u16.GetItem(u76, u77) or u15.GetWeaponSkin(u76, u77);

    if u84 and u85 then
        local u86 = u84.DisplayName or u76;
        local u87 = u85.DisplayName or u77;
        local ModelName = u85.ModelName;
        local GuiInformation = u84.GuiInformation;
        local u88 = u85.Description or GuiInformation.Description;
        local Thumbnail = u85.Thumbnail;
        local Rarity = u85.Rarity;
        local u89 = `{HttpService:GenerateGUID()}{u78}`;
        local u90 = p80 or 1;
        local u91 = u25.IsLocked(u78);
        local u92, u93, u94, u95, u96, u97, u98;

        if u79 then
            u92 = u79.EquippedCT;
            u93 = u79.EquippedT;
            u94 = u79.Stickers;
            u95 = u79.Date;
            u96 = u79.NameTag;
            u97 = u79.KillTrack;
            u98 = u79.KillTrackColor;
        else
            u97 = nil;
            u93 = false;
            u95 = nil;
            u92 = false;
            u94 = nil;
            u96 = nil;
            u98 = nil;
        end;

        u83.Name = `{ModelName}_{u86}_{u87}_{Rarity}`;
        local ItemInfo = u83.ItemInfo;
        local v99;

        if u97 == nil then
            v99 = u86;
        else
            v99 = `KillTrackᴷ⁺ {u86}` or u86;
        end;

        ItemInfo.Text = v99;
        local SkinInfo = u83.SkinInfo;
        local v100;

        if u96 then
            v100 = `''{u96}''` or u87;
        else
            v100 = u87;
        end;

        SkinInfo.Text = v100;
        u83.Locked.Visible = u91;
        u83.Rarity.BackgroundColor3 = u11[Rarity] or Color3.fromRGB(188, 203, 219);
        u83.Icon.Image = `rbxassetid://{Thumbnail}` or "rbxassetid://100429874437897";
        EquipTeam.CT.Visible = u92 and true or false;
        EquipTeam.T.Visible = u93 and true or false;

        if ModelName == "Stickers" and u77:sub(-5) == " Holo" then
            u1.GlowIcon(u83.Icon);
        end;

        if u76 == "Badges" then
            local function UpdateBadge() -- Line: 484
                -- upvalues: HttpService (ref), Players (ref), EquipTeam (copy), u77 (copy)
                local v101 = HttpService:JSONDecode(Players.LocalPlayer:GetAttribute("WeaponLoadout")).CT["19"];
                local v102;

                if v101 == nil then
                    v102 = false;
                else
                    v102 = v101.SkinName == u77;
                end;

                EquipTeam.Badge.Visible = v102;
            end;

            local v103 = HttpService:JSONDecode(Players.LocalPlayer:GetAttribute("WeaponLoadout")).CT["19"];
            local v104;

            if v103 == nil then
                v104 = false;
            else
                v104 = v103.SkinName == u77;
            end;

            EquipTeam.Badge.Visible = v104;
            u10:Add(`{u89}_Badge`, Players.LocalPlayer:GetAttributeChangedSignal("WeaponLoadout"):Connect(UpdateBadge));
        end;

        if u90 and u90 > 1 then
            u83.Amount.Text = `x{u90}`;
            u83.Amount.Visible = true;
        else
            u83.Amount.Visible = false;
        end;

        if u81 then
            u83.IconShadow.Image = `rbxassetid://{Thumbnail}` or "rbxassetid://100429874437897";
        end;

        if u94 then
            for i, v in u94 do
                local Item = u16.GetItem("Stickers", v.StickerName);
                u1.newSticker(u83.Stickers, Item.Thumbnail).LayoutOrder = i;
            end;
        end;

        local u105 = StickerKey(u94);

        if u82 then
            u83.Odds.Text = `{u82}%`;
            u83.Odds.TextColor3 = u11[Rarity] or Color3.fromRGB(188, 203, 219);
        end;

        u83.Parent = p75;
        u83:SetAttribute("Id", u89);
        u83:SetAttribute("WeaponName", u76);
        u83:SetAttribute("SkinName", u77);
        u83:SetAttribute("SkinId", u78);
        u83:SetAttribute("NameTag", u96);
        u83:SetAttribute("KillTrack", u97);
        u83:SetAttribute("Rarity", Rarity);
        u83:SetAttribute("Model", ModelName);
        u83:SetAttribute("Value", u85.Value or 0);
        u83:SetAttribute("Tab", u85 and u85.Tab or GuiInformation.Tab);
        u83:SetAttribute("ALLTab", u85 and u85.ALLTab or GuiInformation.ALLTab);
        u83:SetAttribute("Date", u95 or 1);
        u83:SetAttribute("Equipped", u92 and u93 and 1 or (u92 and 2 or (u93 and 3 or 4)));

        if ModelName ~= "Stickers" and ModelName ~= "Containers" then
            local function HoverEnter() -- Line: 539
                -- upvalues: u4 (ref), u18 (ref), TweenService (ref), u83 (copy), u76 (copy), u1 (ref), u86 (copy), u87 (copy), Rarity (copy), u88 (copy), u85 (copy), GuiInformation (copy), u96 (ref), u97 (ref)
                if u4.Handler.CaseInspect.RareItems.Visible then
                    return;
                end;

                u18.Play("UI.submenu_scroll");
                TweenService:Create(u83.Selection, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0
                }):Play();

                if u76 ~= "Agents" then
                    TweenService:Create(u83.Icon, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, 2, 0, -4)
                    }):Play();
                end;

                if u4.Handler:GetAttribute("CurrentTab") == "FUSER" then
                    return;
                end;

                u1.ItemHover(u83, u86, u87, Rarity, u88, u85.Sides or GuiInformation.Sides, u96, u97);
            end;

            local function HoverLeave() -- Line: 557
                -- upvalues: TweenService (ref), u83 (copy), u4 (ref), u8 (ref)
                TweenService:Create(u83.Selection, TweenInfo.new(0.15), {
                    BackgroundTransparency = 1
                }):Play();
                TweenService:Create(u83.Icon, TweenInfo.new(0.2), {
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play();

                if u4.Handler:GetAttribute("CurrentTab") == "FUSER" then
                    return;
                end;

                TweenService:Create(u8, TweenInfo.new(0.15), {
                    GroupTransparency = 1
                }):Play();
            end;

            u10:Add(`{u89}_MouseEnter`, u83.MouseEnter:Connect(HoverEnter));
            u10:Add(`{u89}_MouseLeave`, u83.MouseLeave:Connect(HoverLeave));
            u10:Add(`{u89}_SelectionGained`, u83.Icon.SelectionGained:Connect(HoverEnter));
            u10:Add(`{u89}_SelectionLost`, u83.Icon.SelectionLost:Connect(HoverLeave));
        end;

        u10:Add(`{u89}_LockEnter`, u83.Locked.MouseEnter:Connect(function() -- Line: 574
            -- upvalues: u1 (ref), u83 (copy)
            u1.LockInfo(u83, true);
        end));
        u10:Add(`{u89}_LockLeave`, u83.Locked.MouseLeave:Connect(function() -- Line: 578
            -- upvalues: u1 (ref), u83 (copy)
            u1.LockInfo(u83, false);
        end));
        u10:Add(`{u89}_LockTouch`, u83.Locked.InputBegan:Connect(function(p106) -- Line: 582
            -- upvalues: u1 (ref), u83 (copy)
            if p106.UserInputType == Enum.UserInputType.Touch then
                u1.LockInfo(u83, true);
                task.delay(2.5, u1.LockInfo, u83, false);
            end;
        end));

        if ModelName == "Weapon" then
            u12.Register(u83, function() -- Line: 590
                -- upvalues: u76 (copy), u77 (copy), Rarity (copy), u88 (copy), u94 (ref), u96 (ref), u78 (copy), u97 (ref), u98 (ref)
                return table.pack(u76, u77, Rarity, u88, u94, nil, nil, u96, u78, u97, u98);
            end);
        elseif u76 == "Badges" or (ModelName == "Stickers" or ModelName == "Agent") then
            u12.Register(u83, function() -- Line: 594
                -- upvalues: u76 (copy), u77 (copy), Rarity (copy), u88 (copy)
                return table.pack(u76, u77, Rarity, u88);
            end);
        end;

        local v149 = {
            Activate = function() -- Line: 600, Name: Activate
                -- upvalues: u4 (ref), u30 (ref), u19 (ref), TweenService (ref), u8 (ref), u39 (ref), u85 (copy), GuiInformation (copy), u21 (ref), u76 (copy), u77 (copy), u78 (copy), u25 (ref), u22 (ref), u92 (ref), u93 (ref), u1 (ref), u83 (copy), ModelName (copy), u12 (ref), u38 (ref), u82 (copy), u79 (copy), u81 (copy), u96 (ref), u97 (ref), u84 (copy), u98 (ref), u94 (ref), Thumbnail (copy), u86 (copy), u87 (copy), u43 (ref), u91 (ref)
                if u4.Handler:GetAttribute("CurrentTab") == "FUSER" or u30.Visible then
                    return;
                end;

                if u19 and (u19.IsOpeningCase and u19.IsOpeningCase()) then
                    return;
                end;

                TweenService:Create(u8, TweenInfo.new(0.15), {
                    GroupTransparency = 1
                }):Play();
                local u107 = {};

                local function AddReplaceOptions() -- Line: 619
                    -- upvalues: u39 (ref), u85 (ref), GuiInformation (ref), u21 (ref), u76 (ref), u77 (ref), u78 (ref), u25 (ref), u22 (ref), u92 (ref), u93 (ref), u107 (copy), u1 (ref), u83 (ref)
                    local u108 = nil;
                    local v109 = nil;
                    local u110 = u39 and u39.GetLoadoutData();
                    local v111 = u85.Sides or GuiInformation and GuiInformation.Sides;
                    local v112;

                    if v111 then
                        v112 = v111.CT;
                    else
                        v112 = v111;
                    end;

                    local v113 = v112 and true or false;

                    if v111 then
                        v111 = v111.T;
                    end;

                    local v114 = v111 and true or false;
                    local v115 = GuiInformation and GuiInformation.LoadoutCategory;
                    local u116;

                    if v115 then
                        u116 = u21.LoadoutNum[v115];
                    else
                        u116 = v115;
                    end;

                    local u117 = nil;
                    local u118 = nil;

                    if u116 then
                        if v113 and (u110 and (u110.CT and u110.CT[tostring(u116)])) then
                            u108 = u116;
                        end;

                        if not (v114 and (u110 and (u110.T and u110.T[tostring(u116)]))) then
                            u116 = v109;
                        end;
                    else
                        if v113 and (u110 and u110.CT) then
                            for i, v in u110.CT do
                                if v.WeaponName == u76 then
                                    u108 = tonumber(i);
                                    break;
                                end;
                            end;
                        end;

                        if v114 and (u110 and u110.T) then
                            for i, v in u110.T do
                                if v.WeaponName == u76 then
                                    v109 = tonumber(i);
                                    break;
                                end;
                            end;
                        end;

                        local v119 = {};

                        while v115 and u21.LoadoutNum[`{v115}_{#v119 + 1}`] do
                            local v120 = u21.LoadoutNum[`{v115}_{#v119 + 1}`];
                            table.insert(v119, v120);
                        end;

                        if #v119 == 1 then
                            if not u108 then
                                if v113 and (u110 and u110.CT) then
                                    u108 = v119[1] or nil;
                                else
                                    u108 = nil;
                                end;
                            end;

                            if v109 then
                                u116 = v109;
                            elseif v114 and (u110 and u110.T) then
                                u116 = v119[1] or nil;
                            else
                                u116 = nil;
                            end;
                        elseif #v119 > 1 then
                            if u108 or not (v113 and (u110 and (u110.CT and v119))) then
                                u117 = nil;
                            else
                                u117 = v119;
                            end;

                            if v109 or not (v114 and (u110 and (u110.T and v119))) then
                                u118 = nil;
                            else
                                u118 = v119;
                            end;

                            u116 = v109;
                        else
                            u116 = v109;
                        end;
                    end;

                    local function ReplaceOnTeam(p121, p122) -- Line: 671
                        -- upvalues: u39 (ref), u76 (ref), u77 (ref), u78 (ref), u25 (ref), u22 (ref), u21 (ref)
                        if u39 and u39.SetWeapon then
                            u39.SetWeapon(p121, p122, u76, u77, u78);
                        end;

                        if u25 and u25.SetEquipped then
                            u25.SetEquipped(p121, u76, u77, u78);
                        end;

                        u22.Gui.ChangeLoadoutWeapon.Fire({
                            A = p122,
                            B = u21.InventoryCategoriesNum.Equipment,
                            C = u76,
                            D = u77,
                            E = u78,
                            T = u21.TeamsNum[p121]
                        });
                    end;

                    if u108 and (u116 and not (u92 or u93)) then
                        table.insert(u107, {
                            name = "Replace on Both Teams",

                            callback = function() -- Line: 691, Name: callback
                                -- upvalues: ReplaceOnTeam (copy), u108 (ref), u116 (ref)
                                ReplaceOnTeam("CT", u108);
                                ReplaceOnTeam("T", u116);
                            end
                        });
                    end;

                    if u108 and not u92 then
                        table.insert(u107, {
                            name = "Replace on CT",

                            callback = function() -- Line: 698, Name: callback
                                -- upvalues: ReplaceOnTeam (copy), u108 (ref)
                                ReplaceOnTeam("CT", u108);
                            end
                        });
                    end;

                    if u116 and not u93 then
                        table.insert(u107, {
                            name = "Replace on T",

                            callback = function() -- Line: 704, Name: callback
                                -- upvalues: ReplaceOnTeam (copy), u116 (ref)
                                ReplaceOnTeam("T", u116);
                            end
                        });
                    end;

                    local function PickSlot(u123, p124) -- Line: 709
                        -- upvalues: u110 (copy), ReplaceOnTeam (copy), u1 (ref), u83 (ref)
                        local v125 = {};

                        for _, v in p124 do
                            local v126 = u110[u123][tostring(v)];
                            local v127 = {
                                name = `Replace {v126 and v126.WeaponName or "Empty Slot"}`,

                                callback = function() -- Line: 715, Name: callback
                                    -- upvalues: ReplaceOnTeam (ref), u123 (copy), v (copy)
                                    ReplaceOnTeam(u123, v);
                                end
                            };
                            table.insert(v125, v127);
                        end;

                        u1.RightClick(u83, v125);
                    end;

                    if u117 then
                        table.insert(u107, {
                            name = "Equip on CT",

                            callback = function() -- Line: 724, Name: callback
                                -- upvalues: PickSlot (copy), u117 (ref)
                                PickSlot("CT", u117);
                            end
                        });
                    end;

                    if u118 then
                        table.insert(u107, {
                            name = "Equip on T",

                            callback = function() -- Line: 730, Name: callback
                                -- upvalues: PickSlot (copy), u118 (ref)
                                PickSlot("T", u118);
                            end
                        });
                    end;
                end;

                if ModelName == "Weapon" then
                    table.insert(u107, {
                        name = "Inspect",

                        callback = function() -- Line: 737, Name: callback
                            -- upvalues: u12 (ref), u83 (ref), u38 (ref)
                            u12.Browse(u83, u38[u83]);
                        end
                    });

                    if not u82 then
                        AddReplaceOptions();
                    end;

                    local v128 = u25.Get();

                    if v128 then
                        v128 = v128["Graphic Art"];
                    end;

                    local v129;

                    if v128 then
                        v129 = v128["Name Tags"] or v128.NameTags;
                    else
                        v129 = v128;
                    end;

                    local v130;

                    if v128 then
                        v130 = v128.KillTracks;
                    else
                        v130 = v128;
                    end;

                    local v131 = false;
                    local v132 = false;

                    if v129 then
                        for _, v in v129 do
                            if v and next(v) then
                                v131 = true;
                                break;
                            end;
                        end;
                    end;

                    local v133 = false;
                    local v134 = false;

                    if v130 then
                        for i, v in v130 do
                            if i ~= "KillTrack Painter" and (i ~= "KillTrack Remover" and (v and next(v))) then
                                v132 = true;
                            end;
                        end;

                        v133 = v130["KillTrack Painter"] and next(v130["KillTrack Painter"]) and true or v133;

                        if v130["KillTrack Remover"] and next(v130["KillTrack Remover"]) then
                            v134 = true;
                        end;
                    end;

                    if v131 and (u78 and (u79 and not (u81 or u82))) then
                        table.insert(u107, {
                            name = "Rename",

                            callback = function() -- Line: 779, Name: callback
                                -- upvalues: u12 (ref), u76 (ref), u77 (ref), u78 (ref), u96 (ref), u97 (ref)
                                u12.NameTagApply(u76, u77, u78, u96, u97);
                            end
                        });
                    end;

                    if u96 and (u78 and (u79 and not (u81 or u82))) then
                        table.insert(u107, {
                            name = "Remove Name Tag",

                            callback = function() -- Line: 785, Name: callback
                                -- upvalues: u12 (ref), u76 (ref), u77 (ref), u78 (ref)
                                u12.NameTagRemove(u76, u77, u78);
                            end
                        });
                    end;

                    if v132 and (u97 == nil and (u78 and (u79 and not (u81 or u82)))) then
                        if not (u84 and u84.Data and u84.Data.Type == "Bomb") then
                            table.insert(u107, {
                                name = "Add KillTrack",

                                callback = function() -- Line: 794, Name: callback
                                    -- upvalues: u12 (ref), u76 (ref), u77 (ref), u78 (ref)
                                    u12.KillTrackApply(u76, u77, u78);
                                end
                            });
                        end;
                    end;

                    if v133 and (u97 ~= nil and (u78 and (u79 and not (u81 or u82)))) then
                        table.insert(u107, {
                            name = "Color KillTrack",

                            callback = function() -- Line: 801, Name: callback
                                -- upvalues: u12 (ref), u76 (ref), u77 (ref), u78 (ref), u96 (ref), u97 (ref), u98 (ref)
                                u12.KillTrackColorApply(u76, u77, u78, u96, u97, u98);
                            end
                        });
                    end;

                    if v134 and (u97 ~= nil and (u78 and (u79 and not (u81 or u82)))) then
                        table.insert(u107, {
                            name = "Remove KillTrack",

                            callback = function() -- Line: 807, Name: callback
                                -- upvalues: u12 (ref), u76 (ref), u77 (ref), u78 (ref)
                                u12.KillTrackRemove(u76, u77, u78);
                            end
                        });
                    end;

                    local v135 = false;

                    for _, v in v128.Stickers do
                        if next(v) then
                            v135 = true;
                            break;
                        end;
                    end;

                    local v136 = u94 and #u94 or 0;
                    local v137;

                    if u84.Data == nil then
                        v137 = false;
                    else
                        v137 = u84.Data.Type ~= "Melee";
                    end;

                    if v135 and (v137 and (v136 < 3 and (u78 and (u79 and not (u81 or u82))))) then
                        table.insert(u107, {
                            name = "Apply Sticker",

                            callback = function() -- Line: 825, Name: callback
                                -- upvalues: u1 (ref), u76 (ref), u77 (ref), u78 (ref), Thumbnail (ref), u86 (ref), u87 (ref)
                                u1.DrawStickerApply(false, u76, u77, u78, Thumbnail, u86, u87);
                            end
                        });
                    end;

                    if v136 > 0 and (u78 and (u79 and not (u81 or u82))) then
                        table.insert(u107, {
                            name = "Remove Sticker",

                            callback = function() -- Line: 831, Name: callback
                                -- upvalues: u12 (ref), u76 (ref), u77 (ref), u78 (ref)
                                u12.StickerRemove(u76, u77, u78);
                            end
                        });
                    end;
                end;

                if ModelName == "Stickers" then
                    table.insert(u107, {
                        name = "Inspect",

                        callback = function() -- Line: 838, Name: callback
                            -- upvalues: u12 (ref), u83 (ref), u38 (ref)
                            u12.Browse(u83, u38[u83]);
                        end
                    });
                end;

                if ModelName == "Agent" then
                    table.insert(u107, {
                        name = "Inspect",

                        callback = function() -- Line: 844, Name: callback
                            -- upvalues: u12 (ref), u83 (ref), u38 (ref)
                            u12.Browse(u83, u38[u83]);
                        end
                    });

                    if not u82 then
                        AddReplaceOptions();
                    end;
                end;

                if ModelName == "Stickers" and not (u81 or u82) then
                    table.insert(u107, {
                        name = "Apply Sticker",

                        callback = function() -- Line: 854, Name: callback
                            -- upvalues: u1 (ref), u76 (ref), u77 (ref), u78 (ref), Thumbnail (ref), u86 (ref), u87 (ref)
                            u1.DrawStickerApply(true, u76, u77, u78, Thumbnail, u86, u87);
                        end
                    });
                end;

                if not (u76 ~= "Name Tags" and u76 ~= "KillTracks" or u81) then
                    table.insert(u107, {
                        name = "Use Tool",

                        callback = function() -- Line: 860, Name: callback
                            -- upvalues: u43 (ref)
                            u43:OpenTab("Everything");
                        end
                    });
                end;

                if ModelName == "Containers" then
                    table.insert(u107, {
                        name = "Open Container",

                        callback = function() -- Line: 875, Name: callback
                            -- upvalues: u19 (ref), u77 (ref), Thumbnail (ref), u91 (ref)
                            u19.SetVisible(false, nil, nil, u77, Thumbnail, u91);
                        end
                    });
                end;

                if u76 == "Badges" then
                    table.insert(u107, {
                        name = "Inspect",

                        callback = function() -- Line: 881, Name: callback
                            -- upvalues: u12 (ref), u83 (ref), u38 (ref)
                            u12.Browse(u83, u38[u83]);
                        end
                    });
                    local v138 = u39.GetLoadoutData().CT["19"];

                    if v138 then
                        v138 = v138.SkinName;
                    end;

                    if v138 == u77 then
                        table.insert(u107, {
                            name = "Unequip",

                            callback = function() -- Line: 905, Name: callback
                                -- upvalues: u22 (ref), u21 (ref), u39 (ref)
                                for _, v in { "CT", "T" } do
                                    u22.Gui.ChangeLoadoutWeapon.Fire({
                                        A = 19,
                                        B = 1,
                                        C = "Badges",
                                        D = "None",
                                        E = "50",
                                        T = u21.TeamsNum[v]
                                    });
                                end;

                                u39.UpdateBadge("None");
                            end
                        });
                    else
                        table.insert(u107, {
                            name = "Equip",

                            callback = function() -- Line: 890, Name: callback
                                -- upvalues: u22 (ref), u76 (ref), u77 (ref), u78 (ref), u21 (ref), u39 (ref)
                                for _, v in { "CT", "T" } do
                                    u22.Gui.ChangeLoadoutWeapon.Fire({
                                        A = 19,
                                        B = 1,
                                        C = u76,
                                        D = u77,
                                        E = u78,
                                        T = u21.TeamsNum[v]
                                    });
                                end;

                                u39.UpdateBadge(u77);
                            end
                        });
                    end;
                end;

                if not next(u107) then
                    return;
                end;

                u1.RightClick(u83, u107);
            end,

            Update = function(p139, p140, p141, p142, p143, p144, p145, p146, p147) -- Line: 928, Name: Update
                -- upvalues: u92 (ref), u93 (ref), u94 (ref), u90 (ref), u95 (ref), u96 (ref), u97 (ref), u98 (ref), u83 (copy), u91 (ref), u25 (ref), u87 (copy), u86 (copy), EquipTeam (copy), StickerKey (ref), u105 (ref), u16 (ref), u1 (ref)
                u92 = p139;
                u93 = p140;
                u94 = p141;
                u90 = p142;
                u95 = p143;
                u96 = p144;
                u97 = p145;

                if p147 ~= nil then
                    u98 = p147;
                end;

                if p146 then
                    u83:SetAttribute("SkinId", p146);
                end;

                u91 = u25.IsLocked(u83:GetAttribute("SkinId"));
                u83.Locked.Visible = u91;
                u83.SkinInfo.Text = u96 and u96 ~= "" and `''{u96}''` or u87;
                u83.ItemInfo.Text = u97 ~= nil and `KillTrackᴷ⁺ {u86}` or u86;
                u83:SetAttribute("NameTag", u96);
                u83:SetAttribute("KillTrack", u97);
                EquipTeam.CT.Visible = p139 and true or false;
                EquipTeam.T.Visible = p140 and true or false;
                u83:SetAttribute("Date", u95 or 1);
                u83:SetAttribute("Equipped", u92 and u93 and 1 or (u92 and 2 or (u93 and 3 or 4)));

                if u90 and u90 > 1 then
                    u83.Amount.Text = `x{u90}`;
                    u83.Amount.Visible = true;
                else
                    u83.Amount.Visible = false;
                end;

                local v148 = StickerKey(u94);

                if v148 ~= u105 then
                    u105 = v148;

                    for _, child in u83.Stickers:GetChildren() do
                        if child:IsA("ImageLabel") then
                            child:Destroy();
                        end;
                    end;

                    for i, v in u94 or {} do
                        local Item = u16.GetItem("Stickers", v.StickerName);
                        u1.newSticker(u83.Stickers, Item.Thumbnail).LayoutOrder = i;
                    end;
                end;
            end,

            GetStickers = function() -- Line: 984, Name: GetStickers
                -- upvalues: u94 (ref)
                return u94;
            end,

            Destroy = function() -- Line: 987, Name: Destroy
                -- upvalues: u83 (copy), u10 (ref), u89 (copy)
                u83:Destroy();
                u10:Removes(`{u89}_MouseEnter`, `{u89}_MouseLeave`, `{u89}_SelectionGained`, `{u89}_SelectionLost`, `{u89}_MouseButton2Click`, `{u89}_MouseButton1Click`, `{u89}_Badge`, `{u89}_LockEnter`, `{u89}_LockLeave`, (`{u89}_LockTouch`));
            end
        };
        u10:Add(`{u89}_MouseButton2Click`, u83.Icon.MouseButton2Click:Connect(v149.Activate));
        u10:Add(`{u89}_MouseButton1Click`, u83.Icon.MouseButton1Click:Connect(v149.Activate));

        return u83, v149;
    end;
end;

function u1.DrawStickerApply(p150, u151, u152, u153, p154, p155, p156) -- Line: 1007
    -- upvalues: u30 (ref), u3 (ref), u10 (ref), TweenService (copy), u1 (copy), u34 (copy), u17 (ref), u12 (ref)
    u30.Visible = true;
    u3.Visible = false;
    local PageUnder = u30.PageUnder;
    local Back = PageUnder.Back;
    PageUnder.ItemName.Text = `{p155} | {p156}`;
    PageUnder.ImageLabel.Image = `rbxassetid://{p154}`;
    u10:Add("BackButon_MouseEnter", Back.MouseEnter:Connect(function() -- Line: 1017
        -- upvalues: TweenService (ref), Back (copy)
        TweenService:Create(Back, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.7
        }):Play();
    end));
    u10:Add("BackButon_MouseLeave", Back.MouseLeave:Connect(function() -- Line: 1021
        -- upvalues: TweenService (ref), Back (copy)
        TweenService:Create(Back, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.8
        }):Play();
    end));
    u10:Add("BackButon_MouseClick", Back.MouseButton1Click:Connect(function() -- Line: 1025
        -- upvalues: u1 (ref)
        u1.CloseStickerApply();
    end));

    local function Selectable(p157: userdata, u158: any) -- Line: 1029
        -- upvalues: u10 (ref), TweenService (ref), u1 (ref), u30 (ref)
        local Attribute = p157:GetAttribute("Id");
        local UIStroke = p157.SelectItem.UIStroke;
        p157.SelectItem.Visible = true;
        p157.Visible = true;
        u10:Add(`{Attribute}_MouseEnterSA`, p157.MouseEnter:Connect(function() -- Line: 1036
            -- upvalues: TweenService (ref), UIStroke (copy)
            TweenService:Create(UIStroke, TweenInfo.new(0.1), {
                Thickness = 4
            }):Play();
        end));
        u10:Add(`{Attribute}_MouseLeaveSA`, p157.MouseLeave:Connect(function() -- Line: 1040
            -- upvalues: TweenService (ref), UIStroke (copy)
            TweenService:Create(UIStroke, TweenInfo.new(0.1), {
                Thickness = 0
            }):Play();
        end));
        u10:Add(`{Attribute}_MouseClickSA`, p157.Icon.MouseButton1Click:Connect(function() -- Line: 1044
            -- upvalues: u1 (ref), u158 (copy)
            task.defer(function() -- Line: 1045
                -- upvalues: u1 (ref), u158 (ref)
                u1.CloseStickerApply();
                u158();
            end);
        end));
        p157.Parent = u30.ALL;
    end;

    if p150 then
        for _, v in u34.Equipment do
            if v:GetAttribute("Model") == "Weapon" and #v.Stickers:GetChildren() - 1 < 3 then
                local v159 = u17.Get(v:GetAttribute("WeaponName"));

                if v159 and v159.Data.Type ~= "Melee" then
                    Selectable(v, function() -- Line: 1066
                        -- upvalues: u12 (ref), v (copy), u152 (copy)
                        u12.StickerApply(v:GetAttribute("WeaponName"), v:GetAttribute("SkinName"), v:GetAttribute("SkinId"), u152);
                    end);
                end;
            end;
        end;

        return;
    end;

    for _, v in u34["Graphic Art"] do
        if v:GetAttribute("Model") == "Stickers" then
            Selectable(v, function() -- Line: 1076
                -- upvalues: u12 (ref), u151 (copy), u152 (copy), u153 (copy), v (copy)
                u12.StickerApply(u151, u152, u153, v:GetAttribute("SkinName"));
            end);
        end;
    end;
end;

function u1.CloseStickerApply(p160) -- Line: 1083
    -- upvalues: u30 (ref), u43 (ref), u3 (ref), u34 (copy), u10 (ref), u1 (copy)
    if not u30.Visible then
        return;
    end;

    u30.Visible = false;

    if not p160 then
        u43:OpenTab("Everything");
        u3.Visible = true;
    end;

    for _, v in { u34.Equipment, u34["Graphic Art"] } do
        for _, v2 in v do
            local Attribute = v2:GetAttribute("Id");
            v2.SelectItem.Visible = false;
            v2.SelectItem.UIStroke.Thickness = 0;
            u10:Removes(`{Attribute}_MouseEnterSA`, `{Attribute}_MouseLeaveSA`, (`{Attribute}_MouseClickSA`));
        end;
    end;

    u1.tabSort();
end;

local u168 = {
    Newest = {
        Descending = true,

        Get = function(p161) -- Line: 1109, Name: Get
            return p161:GetAttribute("Date") or 0;
        end
    },
    Quality = {
        Descending = true,

        Get = function(p162) -- Line: 1110, Name: Get
            -- upvalues: u21 (ref)
            return u21.RarityNum[p162:GetAttribute("Rarity")] or 0;
        end
    },
    Alphabetical = {
        Descending = false,

        Get = function(p163) -- Line: 1111, Name: Get
            return p163.Name:lower();
        end
    },
    Type = {
        Descending = true,

        Get = function(p164) -- Line: 1112, Name: Get
            return p164:GetAttribute("Model") or "";
        end
    },
    Equipped = {
        Descending = false,

        Get = function(p165) -- Line: 1113, Name: Get
            return p165:GetAttribute("Equipped") or 0;
        end
    },
    ["Highest Value"] = {
        Descending = true,

        Get = function(p166) -- Line: 1114, Name: Get
            return p166:GetAttribute("Value") or 0;
        end
    },
    ["Lowest Value"] = {
        Descending = false,

        Get = function(p167) -- Line: 1115, Name: Get
            return p167:GetAttribute("Value") or 0;
        end
    }
};

local function CompareAscending(p169, p170) -- Line: 1118
    if p169.Key == p170.Key then
        return p169.Index < p170.Index;
    end;

    return p169.Key < p170.Key;
end;

local function CompareDescending(p171, p172) -- Line: 1126
    if p171.Key == p172.Key then
        return p171.Index < p172.Index;
    end;

    return p171.Key > p172.Key;
end;

function u1.Sort(p173, p174, p175, p176) -- Line: 1134
    -- upvalues: u168 (copy), CompareDescending (copy), CompareAscending (copy), u37 (copy), u38 (copy), u36 (ref)
    local v177 = u168[p174];
    local v178 = 0;
    local v179 = {};

    for _, v in p173 do
        for _, v2 in v do
            v178 = v178 + 1;
            local v180 = {
                Item = v2
            };
            local v181;

            if v177 then
                v181 = v177.Get(v2);
            else
                v181 = v177;
            end;

            v180.Key = v181;
            v180.Index = v178;
            v179[v178] = v180;
        end;
    end;

    if v177 then
        table.sort(v179, v177.Descending and CompareDescending or CompareAscending);
    end;

    for i = 1, v178 do
        v179[i].Item.LayoutOrder = i;
        local _ = i;
    end;

    local v182 = p176 or u37;
    local u183 = {};

    for i, v in v182 do
        u183[v] = i;
    end;

    table.sort(v182, function(p184, p185) -- Line: 1162
        -- upvalues: u183 (copy)
        local Visible = p184.Visible;

        if Visible ~= p185.Visible then
            return Visible;
        end;

        local LayoutOrder = p184.LayoutOrder;
        local LayoutOrder2 = p185.LayoutOrder;

        if LayoutOrder == LayoutOrder2 then
            return u183[p184] < u183[p185];
        end;

        return LayoutOrder < LayoutOrder2;
    end);

    for _, v in v182 do
        u38[v] = v182;
    end;

    local v186 = p175 or u36;

    if v186 then
        v186:Reset();
        v186:LoadNextPage();
    end;
end;

function u1.tabSort() -- Line: 1192
    -- upvalues: u30 (ref), u4 (ref), u3 (ref), u36 (ref), u37 (copy), u34 (copy), u16 (ref), u15 (ref), u42 (ref), u40 (ref), u28 (ref), u44 (ref), u23 (ref), u1 (copy), u13 (ref)
    if u30.Visible then
        return;
    end;

    local Attribute = u4.Handler:GetAttribute("CurrentTab");
    local v187 = false;
    local u188 = nil;

    for _, child in ipairs(u3.PageHolder:GetChildren()) do
        if child.Visible then
            u188 = child;
            break;
        end;
    end;

    if u36 then
        u36:Destroy();
        u36 = nil;
    end;

    table.clear(u37);

    if Attribute == "FUSER" then
        u188 = u188.Main.Inventory.InventoryList or u188;
    end;

    for _, v in u34 do
        for _, v2 in v do
            if v2 then
                if Attribute == "EVERYTHING" or Attribute == "" then
                    table.insert(u37, v2);
                    v187 = true;
                elseif Attribute == "FUSER" then
                    local Attribute2 = v2:GetAttribute("WeaponName");
                    local Attribute3 = v2:GetAttribute("SkinName");

                    if Attribute2 and (Attribute3 and Attribute2 ~= "Stickers") then
                        local v189 = u16.GetItem(Attribute2, Attribute3) or u15.GetWeaponSkin(Attribute2, Attribute3);

                        if v189 and v189.Value then
                            table.insert(u37, v2);
                            v187 = true;
                        end;
                    end;
                else
                    local Attribute2 = v2:GetAttribute("Tab");
                    local Attribute3 = v2:GetAttribute("ALLTab");

                    if Attribute == Attribute2 or Attribute == Attribute3 then
                        table.insert(u37, v2);
                        v187 = true;
                    end;
                end;

                v2.Parent = nil;
            end;
        end;
    end;

    if Attribute == "FUSER" then
        u42 = "Lowest Value";
        u40.AddItems(u37);
        u28.Visible = false;

        if u44 then
            u44.Visible = true;
            v187 = true;
        else
            v187 = true;
        end;
    else
        if u42 == "Lowest Value" or u42 == "Highest Value" then
            u42 = "Quality";
        end;

        u40.RemoveItems(u37);
        u28.Visible = true;

        if u44 then
            u44.Visible = false;
        end;
    end;

    u36 = u23.new(u188, function(p190) -- Line: 1274
        -- upvalues: u37 (ref), u188 (copy)
        local v191 = (p190 - 1) * 20 + 1;
        local v192 = v191 + 20 - 1;

        for i = v191, math.min(v192, #u37) do
            local v193 = u37[i];
            local v194;

            if v193 then
                v193.Parent = u188;
                v194 = i;
            else
                v194 = i;
            end;
        end;

        return #u37 > v192;
    end);
    u1.Sort(u34, u42);

    if v187 then
        u13.Visible = false;

        return;
    end;

    u13.MainText.Text = "Could not find any items for this category.";
    u13.Visible = true;
end;

function u1.showAllItems() -- Line: 1307
    -- upvalues: u34 (copy)
    for _, v in pairs(u34) do
        for _, v2 in pairs(v) do
            if v2 and v2:IsA("Frame") then
                v2.Visible = true;
            end;
        end;
    end;
end;

function u1.SearchItem(p195, p196) -- Line: 1317
    -- upvalues: u37 (copy), TweenService (copy), TweenInfo_new_ret (copy), u36 (ref)
    local v197 = p195.Box.TextBox.Text:lower();
    local v198 = 0;

    for _, v in u37 do
        if v:IsA("Frame") then
            if v197 == "" then
                v.Visible = true;
            else
                local v199 = v.Name:lower();
                local v200 = #v197;
                local v201 = v;
                local v202 = 1;

                for i = 1, #v199 do
                    if v199:sub(i, i) == v197:sub(v202, v202) then
                        v202 = v202 + 1;
                    end;

                    if v200 < v202 then
                        break;
                    end;

                    local _ = i;
                end;

                v201.Visible = v200 < v202;

                if v201.Visible then
                    v198 = v198 + 1;
                end;
            end;
        end;
    end;

    local Count = p195.Box.Count;
    local v203 = v197 == "" and "" or (v198 > 0 and (`{v198} RESULT{v198 == 1 and "" or "S"}` or "NO RESULTS") or "NO RESULTS");

    if Count.Text ~= v203 then
        Count.Text = v203;
        Count.TextTransparency = 0.7;
        TweenService:Create(Count, TweenInfo_new_ret, {
            TextTransparency = 0
        }):Play();
    end;

    if u36 then
        u36:Reset();
        u36:LoadNextPage();
    end;
end;

function u1.SearchOpen(p204) -- Line: 1365
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy), u26 (ref)
    local Box = p204.Box;
    Box.Line.Size = UDim2.new(0, 0, 0, 2);
    Box.Icon.ImageTransparency = 1;
    Box.TextBox.TextTransparency = 1;
    TweenService:Create(Box.Line, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
        Size = UDim2.new(1, 0, 0, 2)
    }):Play();
    TweenService:Create(Box.Icon, TweenInfo_new_ret, {
        ImageTransparency = 0
    }):Play();
    TweenService:Create(Box.TextBox, TweenInfo_new_ret, {
        TextTransparency = 0
    }):Play();

    if u26() ~= "Mobile" then
        Box.TextBox:CaptureFocus();
    end;
end;

function u1.SetSort(p205) -- Line: 1381
    -- upvalues: u20 (ref), u28 (ref)
    u20.DropSetOption(u28, p205);
end;

local u206 = nil;

function u1.Activate(p207: string?) -- Line: 1387
    -- upvalues: u206 (ref), u43 (ref)
    if u206 then
        u206.Activate();
    end;

    if p207 and u43 then
        u43:OpenTab(p207);
    end;
end;

function u1.Start(p208) -- Line: 1396
    -- upvalues: u39 (ref), u4 (ref), u40 (ref), u41 (ref), u3 (ref), u5 (ref), u206 (ref), u7 (ref), u8 (ref), u1 (copy), u9 (ref), u13 (ref), u30 (ref), u27 (ref), u28 (ref), u42 (ref), u20 (ref), u34 (copy), u43 (ref), u6 (ref), u44 (ref), u32 (copy), u35 (copy), u33 (copy), TweenService (copy), u29 (ref), u25 (ref), u31 (ref), u24 (ref), u45 (ref)
    u39 = u4.GetComponent("Loadout");
    u40 = u4.GetComponent("Upgrader");
    u41 = u4.GetComponent("Store");
    u3 = u5.AddTab("Inventory");
    u206 = u5.AddButton("Inventory", u3, UDim2.fromScale(0.075, 0.032), UDim2.fromScale(0.37547, 0.015));
    u7 = u3.Parent.Parent;
    u8 = u1.newHover();
    u9 = u1.newClick();
    u13 = u1.newNull();
    u30 = u1.selectItem();
    u13.Parent = u3;
    local v209, v210 = u1.dropUI();
    u27 = v209;
    u28 = v210;
    u27.Parent = u3;
    local u211 = u1.searchUI();
    u211.Parent = u3;
    u42 = "Quality";
    u20.NewDropDown(false, { "Newest", "Quality", "Alphabetical", "Type", "Equipped", "Highest Value", "Lowest Value" }, "Quality", "Quality", function(p212) -- Line: 1424
        -- upvalues: u1 (ref), u34 (ref), u42 (ref)
        u1.Sort(u34, p212);
        u42 = p212;
    end, u28);
    u43 = u6:CreateTab(u3);
    u44 = u41 and u41.CreditsLabel and (u41.CreditsLabel(u43.TabUI) or u43.TabUI:FindFirstChild("Credits"));

    if u44 then
        u44.Visible = false;
    end;

    for i, v in u32 do
        local v213 = u43:CreatePage(i, v.Order, v.HasUnder, false);
        u1.remode(v213);
        local v214, v215;

        if v.HasUnder then
            v214 = i;
            v215 = {};

            for i2, v2 in v.Under do
                local v216 = u43:CreatePage(v2, i2, false, true, v213);
                u1.remode(v216);
                v215[v2] = v216;
            end;

            u34[v214] = {};
            u35[v214] = {};
        else
            v215 = v213;
            v214 = i;
        end;

        u33[v214] = v215;
    end;

    local u217 = u43:CreatePage("Search", 0, false, false, nil, true);
    u1.remode(u217);
    local v218 = u43:CreatePage("Fuser", 7, false);
    u40.new(v218);
    u211.Box.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1471
        -- upvalues: u1 (ref), u211 (copy), u217 (copy)
        u1.SearchItem(u211, u217);
    end);
    u211.Box.TextBox.Focused:Connect(function() -- Line: 1475
        -- upvalues: TweenService (ref), u211 (copy)
        TweenService:Create(u211.Box.Line, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundTransparency = 0.1
        }):Play();
    end);
    u211.Box.TextBox.FocusLost:Connect(function() -- Line: 1479
        -- upvalues: TweenService (ref), u211 (copy)
        TweenService:Create(u211.Box.Line, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundTransparency = 0.6
        }):Play();
    end);
    local u219 = nil;
    u4.Handler:GetAttributeChangedSignal("CurrentTab"):Connect(function() -- Line: 1485
        -- upvalues: u4 (ref), u211 (copy), u219 (ref), u1 (ref), u217 (copy)
        local v220 = u4.Handler:GetAttribute("CurrentTab") == "";
        u211.Visible = v220;

        if v220 then
            if not u219 then
                u1.SearchOpen(u211);
            end;

            if u211.Box.TextBox.Text ~= "" then
                u1.SearchItem(u211, u217);
            end;
        elseif u219 then
            u1.showAllItems();
        end;

        u219 = v220;
    end);
    u43:OpenTab("Everything");
    u29 = u25.Get();

    local function IsSpecialItem(p221) -- Line: 1510
        return p221.Stickers and next(p221.Stickers) and true or (p221.KillTrack and true or (p221.NameTag and true or false));
    end;

    local function Stacks(p222, p223) -- Line: 1518
        -- upvalues: u25 (ref)
        local v224 = {};

        for i in p223 do
            local v225;

            if u25.IsLocked(i) then
                v225 = `{p222}:Locked` or p222;
            else
                v225 = p222;
            end;

            local v226 = v224[v225] or {
                Amount = 0
            };
            v226.Amount = v226.Amount + 1;
            v226.ItemId = i;
            v224[v225] = v226;
        end;

        return v224;
    end;

    local u227 = 0;

    local function Breathe() -- Line: 1536
        -- upvalues: u227 (ref)
        u227 = u227 + 1;

        if u227 >= 128 then
            u227 = 0;
            task.wait();
        end;
    end;

    local v228 = {};

    for i, v in u29.Equipment do
        local v229 = i;

        for i2, v2 in v do
            local v230 = i2;

            for i3, v3 in v2 do
                if u31 and not (v3.Stickers and next(v3.Stickers) or v3.KillTrack or v3.NameTag or (v3.EquippedCT or (v3.EquippedT or v3.TradeLocked))) then
                    local v231 = v229 .. "_" .. v230;

                    if v228[v231] then
                        local v232 = v228[v231];
                        v232.Amount = v232.Amount + 1;
                    else
                        v228[v231] = {
                            Amount = 1,
                            WeaponName = v229,
                            SkinName = v230,
                            SkinId = i3,
                            SkinInfo = v3
                        };
                    end;
                else
                    local Equipment = u34.Equipment;
                    local Equipment2 = u35.Equipment;
                    local v233, v234 = u1.CreateItem(u33.Everything, v229, v230, i3, v3, 1, false);
                    Equipment[i3] = v233;
                    Equipment2[i3] = v234;
                    u227 = u227 + 1;

                    if u227 >= 128 then
                        u227 = 0;
                        task.wait();
                    end;
                end;
            end;
        end;
    end;

    for i, v in v228 do
        local Equipment = u34.Equipment;
        local Equipment2 = u35.Equipment;
        local v235, v236 = u1.CreateItem(u33.Everything, v.WeaponName, v.SkinName, v.SkinId, v.SkinInfo, v.Amount, false);
        Equipment[i] = v235;
        Equipment2[i] = v236;
        u227 = u227 + 1;

        if u227 >= 128 then
            u227 = 0;
            task.wait();
        end;
    end;

    for i, v in u29["Graphic Art"] do
        local v237 = i;

        for i2, v2 in v do
            if i2 ~= "None" then
                local v238 = i2;

                for i3, v3 in Stacks(i2, v2) do
                    local v239 = u34["Graphic Art"];
                    local v240 = u35["Graphic Art"];
                    local v241, v242 = u1.CreateItem(u33.Everything, v237, v238, v3.ItemId, nil, v3.Amount, false);
                    v239[i3] = v241;
                    v240[i3] = v242;
                    u227 = u227 + 1;

                    if u227 >= 128 then
                        u227 = 0;
                        task.wait();
                    end;
                end;
            end;
        end;
    end;

    for i, v in u29.Containers do
        local v243 = i;

        for i2, v2 in Stacks(i, v) do
            local Containers = u34.Containers;
            local Containers2 = u35.Containers;
            local v244, v245 = u1.CreateItem(u33.Everything, "Containers", v243, v2.ItemId, nil, v2.Amount, false);
            Containers[i2] = v244;
            Containers2[i2] = v245;
            u227 = u227 + 1;

            if u227 >= 128 then
                u227 = 0;
                task.wait();
            end;
        end;
    end;

    function u1.UpdateItems() -- Line: 1632
        -- upvalues: u25 (ref), u24 (ref), u34 (ref), u31 (ref), u35 (ref), u1 (ref), u33 (ref), Stacks (copy)
        local v246 = u25.Get();
        local v247 = u24.Copy(u34);
        local v248 = {};

        for i, v in v246.Equipment do
            local v249 = i;

            for i2, v2 in v do
                local v250 = i2;

                for i3, v3 in v2 do
                    if u31 and not (v3.Stickers and next(v3.Stickers) or v3.KillTrack or v3.NameTag or (v3.EquippedCT or (v3.EquippedT or v3.TradeLocked))) then
                        local v251 = v249 .. "_" .. v250;

                        if v248[v251] then
                            local v252 = v248[v251];
                            v252.Amount = v252.Amount + 1;
                        else
                            v248[v251] = {
                                Amount = 1,
                                WeaponName = v249,
                                SkinName = v250,
                                SkinId = i3,
                                SkinInfo = v3
                            };
                        end;
                    elseif u34.Equipment[i3] then
                        u35.Equipment[i3].Update(v3.EquippedCT, v3.EquippedT, v3.Stickers, 1, v3.Date, v3.NameTag, v3.KillTrack, nil, v3.KillTrackColor);
                        v247.Equipment[i3] = nil;
                    else
                        local Equipment = u34.Equipment;
                        local Equipment2 = u35.Equipment;
                        local v253, v254 = u1.CreateItem(u33.Everything, v249, v250, i3, v3, 1, false);
                        Equipment[i3] = v253;
                        Equipment2[i3] = v254;
                    end;
                end;
            end;
        end;

        for i, v in v248 do
            if u34.Equipment[i] then
                u35.Equipment[i].Update(v.SkinInfo.EquippedCT, v.SkinInfo.EquippedT, v.SkinInfo.Stickers, v.Amount, v.SkinInfo.Date, v.SkinInfo.NameTag, v.SkinInfo.KillTrack, v.SkinId, v.SkinInfo.KillTrackColor);
                v247.Equipment[i] = nil;
            else
                local Equipment = u34.Equipment;
                local Equipment2 = u35.Equipment;
                local v255, v256 = u1.CreateItem(u33.Everything, v.WeaponName, v.SkinName, v.SkinId, v.SkinInfo, v.Amount, false);
                Equipment[i] = v255;
                Equipment2[i] = v256;
            end;
        end;

        for i, v in v246["Graphic Art"] do
            local v257 = i;

            for i2, v2 in v do
                if i2 ~= "None" then
                    local v258 = i2;

                    for i3, v3 in Stacks(i2, v2) do
                        v247["Graphic Art"][i3] = nil;
                        local v259 = u35["Graphic Art"][i3];

                        if v259 then
                            v259.Update(nil, nil, nil, v3.Amount, nil, nil, nil, v3.ItemId);
                        else
                            local v260 = u34["Graphic Art"];
                            local v261 = u35["Graphic Art"];
                            local v262, v263 = u1.CreateItem(u33.Everything, v257, v258, v3.ItemId, nil, v3.Amount, false);
                            v260[i3] = v262;
                            v261[i3] = v263;
                        end;
                    end;
                end;
            end;
        end;

        for i, v in v246.Containers do
            local v264 = i;

            for i2, v2 in Stacks(i, v) do
                v247.Containers[i2] = nil;
                local v265 = u35.Containers[i2];

                if v265 then
                    v265.Update(nil, nil, nil, v2.Amount, nil, nil, nil, v2.ItemId);
                else
                    local Containers = u34.Containers;
                    local Containers2 = u35.Containers;
                    local v266, v267 = u1.CreateItem(u33.Everything, "Containers", v264, v2.ItemId, nil, v2.Amount, false);
                    Containers[i2] = v266;
                    Containers2[i2] = v267;
                end;
            end;
        end;

        for i, v in v247 do
            local v268 = i;

            for i2, _ in v do
                u34[v268][i2] = nil;
                u35[v268][i2].Destroy();
                u35[v268][i2] = nil;
            end;
        end;

        u1.QueueSort();
    end;

    function u1.QueueSort() -- Line: 1758
        -- upvalues: u3 (ref), u4 (ref), u45 (ref), u1 (ref)
        if not (u3.Visible and u4.Handler.MainMenu.Visible) then
            u45 = true;

            return;
        end;

        u45 = false;
        u1.tabSort();
    end;

    local function SortIfDirty() -- Line: 1768
        -- upvalues: u45 (ref), u3 (ref), u4 (ref), u1 (ref)
        if u45 and (u3.Visible and u4.Handler.MainMenu.Visible) then
            u45 = false;
            u1.tabSort();
        end;
    end;

    u25.Updated:Connect(u1.UpdateItems);
    u4.Handler:GetAttributeChangedSignal("CurrentTab"):Connect(u1.QueueSort);
    u3:GetPropertyChangedSignal("Visible"):Connect(SortIfDirty);
    u4.Handler.MainMenu:GetPropertyChangedSignal("Visible"):Connect(SortIfDirty);
    u1.tabSort();
end;

function u1.Init(p269) -- Line: 1786
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u11 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref), u12 (ref), u10 (ref), u19 (ref), u24 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u25 (ref), u26 (ref), u31 (ref), u1 (copy)
    u4 = p269:GetModule("Gui");
    u5 = u4.GetComponent("MainMenu");
    u6 = p269:GetModule("Tabs");
    u11 = p269:GetModule("RarityColors");
    u15 = p269:GetModule("SkinManager");
    u16 = p269:GetModule("ItemManager");
    u17 = p269:GetModule("WeaponManager");
    u18 = p269:GetModule("SoundManager");
    u12 = p269:GetModule("Inspect");
    u10 = p269:GetModule("Maid").new();
    u19 = p269:GetModule("CaseInspect");
    u24 = p269:GetModule("Table");
    u20 = p269:GetModule("Settings");
    u21 = p269:GetModule("Enums");
    u22 = p269:GetModule("Network");
    u23 = p269:GetModule("VirtualScroller");
    u25 = p269:GetModule("InventoryData");
    u26 = p269:GetModule("GetUserPlatform");
    u20:AddConnection("Game", "HUD & UI", "Item Stacking", function(p270) -- Line: 1806
        -- upvalues: u31 (ref), u1 (ref)
        u31 = p270;

        if u1.UpdateItems then
            u1.UpdateItems();
        end;
    end);
end;

function u1.newItem(p271, p272) -- Line: 1814
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromOffset(100, 100);

    if p272 then
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Odds";
        TextLabel.AnchorPoint = Vector2.new(1, 1);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
        TextLabel.Position = UDim2.fromScale(0.995006, 0.964367);
        TextLabel.RichText = true;
        TextLabel.Size = UDim2.fromScale(1, 0.16);
        TextLabel.Text = "2%";
        TextLabel.TextColor3 = Color3.fromRGB(255, 132, 121);
        TextLabel.TextScaled = true;
        TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
        TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
        TextLabel.ZIndex = 343;
        TextLabel.Parent = Frame;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Amount";
    TextLabel.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.965);
    TextLabel.Size = UDim2.fromScale(0.95, 0.2);
    TextLabel.Text = "2x";
    TextLabel.TextColor3 = Color3.fromRGB(255, 220, 93);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.75;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.Visible = true;
    TextLabel.ZIndex = 10;
    TextLabel.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "EquipTeam";
    Frame2.AnchorPoint = Vector2.new(1, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.95, 0.05);
    Frame2.Size = UDim2.fromScale(0.125, 0.125);
    Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame2.ZIndex = 6;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "CT";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://85847931739459";
    ImageLabel.ImageColor3 = Color3.fromRGB(181, 206, 232);
    ImageLabel.ImageTransparency = 0.25;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Visible = false;
    ImageLabel.Parent = Frame2;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0.25, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame2;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "T";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://85847931739459";
    ImageLabel2.ImageColor3 = Color3.fromRGB(255, 232, 99);
    ImageLabel2.ImageTransparency = 0.25;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.Visible = false;
    ImageLabel2.Parent = Frame2;
    local v273 = ImageLabel:Clone();
    v273.Name = "Badge";
    v273.ImageColor3 = Color3.new(1, 1, 1);
    v273.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "SelectItem";
    Frame3.BackgroundTransparency = 1;
    Frame3.Size = UDim2.fromScale(1, 1);
    Frame3.ZIndex = 100;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 0;
    UIStroke.Parent = Frame3;
    Frame3.Parent = Frame;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Locked";
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Size = UDim2.fromScale(0.27, 0.27);
    CanvasGroup.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    CanvasGroup.Visible = false;
    CanvasGroup.ZIndex = 6;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Fold";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.fromRGB(16, 16, 19);
    Frame4.BackgroundTransparency = 0.2;
    Frame4.BorderSizePixel = 0;
    Frame4.Rotation = 45;
    Frame4.Size = UDim2.fromScale(1.414, 1.414);
    Frame4.Parent = CanvasGroup;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Icon";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://108829592125034";
    ImageLabel3.ImageColor3 = Color3.fromRGB(240, 240, 240);
    ImageLabel3.Position = UDim2.fromScale(0.29, 0.29);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.36, 0.36);
    ImageLabel3.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame;
    local CanvasGroup2 = Instance.new("CanvasGroup");
    CanvasGroup2.Name = "LockInfo";
    CanvasGroup2.BackgroundColor3 = Color3.new();
    CanvasGroup2.BackgroundTransparency = 0.4;
    CanvasGroup2.BorderSizePixel = 0;
    CanvasGroup2.GroupTransparency = 1;
    CanvasGroup2.Size = UDim2.fromScale(1, 0.965);
    CanvasGroup2.Visible = false;
    CanvasGroup2.ZIndex = 7;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Content";
    Frame5.BackgroundTransparency = 1;
    Frame5.Size = UDim2.fromScale(1, 1);
    Frame5.Parent = CanvasGroup2;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Icon";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://108829592125034";
    ImageLabel4.ImageColor3 = Color3.fromRGB(240, 240, 240);
    ImageLabel4.Position = UDim2.fromScale(0.5, 0.36);
    ImageLabel4.ScaleType = Enum.ScaleType.Fit;
    ImageLabel4.Size = UDim2.fromScale(0.22, 0.22);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = Frame5;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.6);
    TextLabel2.Size = UDim2.fromScale(0.6, 0.13);
    TextLabel2.Text = "TRADELOCKED";
    TextLabel2.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextLabel2.TextScaled = true;
    TextLabel2.Parent = Frame5;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Text";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.74);
    TextLabel3.Size = UDim2.fromScale(0.6, 0.1);
    TextLabel3.Text = "Can\'t be traded";
    TextLabel3.TextColor3 = Color3.fromRGB(190, 190, 190);
    TextLabel3.TextScaled = true;
    TextLabel3.Parent = Frame5;
    CanvasGroup2.Parent = Frame;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Back";
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame6.BorderColor3 = Color3.new();
    Frame6.BorderSizePixel = 0;
    Frame6.Size = UDim2.fromScale(1, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "BackGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 90, 90)), ColorSequenceKeypoint.new(0.948097, Color3.fromRGB(200, 200, 200)), ColorSequenceKeypoint.new(1, Color3.new()) });
    UIGradient.Rotation = 90;
    UIGradient.Parent = Frame6;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.BorderStrokePosition = Enum.BorderStrokePosition.Inner;
    UIStroke2.Transparency = 0.8;
    UIStroke2.Parent = Frame6;
    Frame6.Parent = Frame;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "ItemInfo";
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0, 1);
    TextLabel4.Size = UDim2.fromScale(1, 0.175);
    TextLabel4.Text = "AKR";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextStrokeTransparency = 0.75;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel4.Parent = Frame;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "SkinInfo";
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0, 1.175);
    TextLabel5.Size = UDim2.fromScale(1, 0.15);
    TextLabel5.Text = "Euphoria";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextStrokeTransparency = 0.75;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel5.Parent = Frame;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Shadow";
    ImageLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://186491278";
    ImageLabel5.ImageTransparency = 0.24;
    ImageLabel5.LayoutOrder = -1;
    ImageLabel5.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel5.ScaleType = Enum.ScaleType.Slice;
    ImageLabel5.Size = UDim2.new(1, 30, 1, 30);
    ImageLabel5.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel5.ZIndex = -9999;
    ImageLabel5.Parent = Frame;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Icon";
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://100429874437897";
    ImageButton.Position = UDim2.fromScale(0, -1.30062e-7);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(1, 0.965);
    ImageButton.ZIndex = 5;
    ImageButton.Parent = Frame;

    if p271 then
        local ImageButton2 = Instance.new("ImageButton");
        ImageButton2.Name = "IconShadow";
        ImageButton2:SetAttribute("NoSelect", true);
        ImageButton2.BackgroundTransparency = 1;
        ImageButton2.Image = "rbxassetid://100429874437897";
        ImageButton2.ImageColor3 = Color3.new();
        ImageButton2.ImageTransparency = 0.8;
        ImageButton2.Position = UDim2.fromOffset(0, 0);
        ImageButton2.ScaleType = Enum.ScaleType.Fit;
        ImageButton2.Size = UDim2.fromScale(1, 0.965);
        ImageButton2.Parent = Frame;
    end;

    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Stickers";
    Frame7.AnchorPoint = Vector2.new(0, 1);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.05, 0.9);
    Frame7.Size = UDim2.fromScale(0.2, 0.2);
    Frame7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame7.ZIndex = 6;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "StickList";
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.Parent = Frame7;
    Frame7.Parent = Frame;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Rarity";
    Frame8.AnchorPoint = Vector2.new(0.5, 1);
    Frame8.BackgroundColor3 = Color3.fromRGB(255, 132, 121);
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Position = UDim2.fromScale(0.5, 1);
    Frame8.Size = UDim2.fromScale(1, 0.035);
    Frame8.ZIndex = 4;
    Frame8.Parent = Frame;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Selection";
    Frame9.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame9.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.Transparency = 1;
    Frame9.Position = UDim2.fromScale(0.5, 0.5);
    Frame9.Size = UDim2.fromScale(1.1, 1);
    Frame9.ZIndex = 0;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "SelectionGradient";
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new()), ColorSequenceKeypoint.new(1, Color3.new()) });
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.199513, 0),
        NumberSequenceKeypoint.new(0.800487, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = Frame9;
    Frame9.Parent = Frame;

    return Frame;
end;

function u1.newSticker(p274, p275) -- Line: 2174
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "1";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = `rbxassetid://{p275}`;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Visible = true;
    ImageLabel.Parent = p274;

    return ImageLabel;
end;

function u1.newNull() -- Line: 2187
    local Frame = Instance.new("Frame");
    Frame.Name = "Null";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.2, 0.035);
    Frame.Visible = false;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "MainText";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 4;
    TextLabel.Position = UDim2.fromScale(0.12, 0.5);
    TextLabel.Size = UDim2.fromScale(1, 1.1);
    TextLabel.Text = "Could not find any items for Charms in your inventory.";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.25;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "IconInfo";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://80205853195967";
    ImageLabel.Position = UDim2.fromScale(0, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;

    return Frame;
end;

function u1.newHover() -- Line: 2230
    -- upvalues: u4 (ref)
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "ItemHover";
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(16, 16, 16);
    CanvasGroup.BackgroundTransparency = 0.1;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Position = UDim2.fromOffset(737, 335);
    CanvasGroup.Size = UDim2.fromScale(0.225, 0.220363);
    CanvasGroup.ZIndex = 100;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "ItemRatio";
    UIAspectRatioConstraint.AspectRatio = 1.8;
    UIAspectRatioConstraint.Parent = CanvasGroup;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "ItemCorner";
    UICorner.CornerRadius = UDim.new(0.025, 0);
    UICorner.Parent = CanvasGroup;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "ItemPadding";
    UIPadding.PaddingBottom = UDim.new(0.075, 0);
    UIPadding.PaddingLeft = UDim.new(0.05, 0);
    UIPadding.PaddingRight = UDim.new(0.05, 0);
    UIPadding.PaddingTop = UDim.new(0.075, 0);
    UIPadding.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "LineTop";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.8;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0, 0.175);
    Frame.Size = UDim2.new(1, 0, 0, 1);
    Frame.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "LineBottom";
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 0.8;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0, 0.525);
    Frame2.Size = UDim2.new(1, 0, 0, 1);
    Frame2.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "TeamIcon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://100429874437897";
    ImageLabel.Position = UDim2.fromScale(0.245, 0.425);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.15, 0.15);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = CanvasGroup;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Description";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0, 0.6);
    TextLabel.Size = UDim2.fromScale(1, 0.4);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.fromRGB(208, 208, 208);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.75;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel.Parent = CanvasGroup;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "RarityColor";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.21, 0.225);
    TextLabel2.Size = UDim2.fromScale(0.5, 0.115);
    TextLabel2.Text = "Red Rifle";
    TextLabel2.TextColor3 = Color3.fromRGB(255, 132, 121);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeTransparency = 0.75;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = CanvasGroup;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "RarityInfo";
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.05, 0.225);
    TextLabel3.Size = UDim2.fromScale(0.16, 0.115);
    TextLabel3.Text = "Rarity: ";
    TextLabel3.TextColor3 = Color3.fromRGB(153, 153, 153);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeTransparency = 0.75;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.Parent = CanvasGroup;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "TeamInfo";
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.3, 0.375);
    TextLabel4.Size = UDim2.fromScale(0.5, 0.115);
    TextLabel4.Text = "Terrosrist";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextStrokeTransparency = 0.75;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.Parent = CanvasGroup;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "TeamTitle";
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.05, 0.375);
    TextLabel5.Size = UDim2.fromScale(0.16, 0.115);
    TextLabel5.Text = "Team:";
    TextLabel5.TextColor3 = Color3.fromRGB(153, 153, 153);
    TextLabel5.TextScaled = true;
    TextLabel5.TextStrokeTransparency = 0.75;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.Parent = CanvasGroup;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "ItemName";
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel6.Size = UDim2.fromScale(1, 0.115);
    TextLabel6.Text = "AKR | Some Skin";
    TextLabel6.TextColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextScaled = true;
    TextLabel6.TextStrokeTransparency = 0.75;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel6.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel6.Parent = CanvasGroup;
    CanvasGroup.Parent = u4.Handler;

    return CanvasGroup;
end;

function u1.newClick() -- Line: 2398
    -- upvalues: u4 (ref)
    local CanvasGroup = Instance.new("CanvasGroup");
    local UICorner = Instance.new("UICorner");
    local Frame = Instance.new("Frame");
    local Frame2 = Instance.new("Frame");
    local Frame3 = Instance.new("Frame");
    local UIListLayout = Instance.new("UIListLayout");
    local UIScale = Instance.new("UIScale");
    CanvasGroup.Name = "InventoryRightClick";
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Position = UDim2.new(0, 0, -1, 0);
    CanvasGroup.Size = UDim2.fromScale(0.15, 0.12);
    CanvasGroup.AnchorPoint = Vector2.new(0, 0.2);
    CanvasGroup.ZIndex = 10;
    CanvasGroup.GroupTransparency = 1;
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 5);
    UICorner.Parent = CanvasGroup;
    UIScale.Name = "UIScale";
    UIScale.Parent = CanvasGroup;
    Frame.Name = "Top";
    Frame.BackgroundColor3 = Color3.fromRGB(38, 38, 38);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.new(1, 0, 0, 5);
    Frame.Parent = CanvasGroup;
    Frame2.Name = "Bottom";
    Frame2.AnchorPoint = Vector2.new(0, 1);
    Frame2.BackgroundColor3 = Color3.fromRGB(38, 38, 38);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0, 1);
    Frame2.Size = UDim2.new(1, 0, 0, 5);
    Frame2.Parent = CanvasGroup;
    Frame3.Name = "ScrollingFrame";
    Frame3.Active = true;
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundColor3 = Color3.fromRGB(38, 38, 38);
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.ClipsDescendants = true;
    Frame3.Position = UDim2.fromScale(0.5, 0.5);
    Frame3.Selectable = true;
    Frame3.SelectionGroup = true;
    Frame3.Size = UDim2.new(1, 0, 1, -10);
    UIListLayout.Name = "UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame3;
    Frame3.Parent = CanvasGroup;
    CanvasGroup.Parent = u4.Handler;

    return CanvasGroup;
end;

function u1.ClickBtn(p276: number, p277: number, p278: string) -- Line: 2461
    -- upvalues: u9 (ref)
    local TextButton = Instance.new("TextButton");
    local TextLabel = Instance.new("TextLabel");
    TextButton.Name = "TextButton";
    TextButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38);
    TextButton.BorderColor3 = Color3.new();
    TextButton.BorderSizePixel = 0;
    TextButton.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextButton.Size = UDim2.fromScale(1, 1 / #p276);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new(1, 1, 1);
    TextButton.TextScaled = true;
    TextButton.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextButton.LayoutOrder = p277;
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.9, 0.5);
    TextLabel.Text = p278.name;
    TextLabel.TextColor3 = Color3.fromRGB(181, 181, 181);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = TextButton;
    TextButton.Parent = u9.ScrollingFrame;

    return TextButton;
end;

function u1.remode(u279: userdata) -- Line: 2502
    u279.Size = UDim2.new(1, 0, 0.88, 0);
    u279.Position = UDim2.new(0.5, 0, 0.118, 0);
    u279.BorderSizePixel = 0;
    u279.AnchorPoint = Vector2.new(0.5, 0);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 20);
    UIPadding.PaddingLeft = UDim.new(0.012, 0);
    UIPadding.PaddingRight = UDim.new(0.012, 0);
    UIPadding.PaddingTop = UDim.new(0, 20);
    UIPadding.Parent = u279;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(0.012, 0.08);
    UIGridLayout.CellSize = UDim2.fromScale(0.1, 0.12);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.425;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = UIGridLayout;
    UIGridLayout.Parent = u279;
    UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 2530
        -- upvalues: u279 (copy), UIGridLayout (copy)
        u279.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 100);
    end);
end;

function u1.selectItem() -- Line: 2535
    -- upvalues: u4 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "SelectItem";
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(-1.91033e-7, 0.0592593);
    Frame.Size = UDim2.fromScale(1, 0.940741);
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "PageUnder";
    Frame2.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    Frame2.BackgroundTransparency = 0.05;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(-1.27289e-7, 0);
    Frame2.Size = UDim2.fromScale(1, 0.075);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://87888833441425";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.85, 0.85);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.47, 0.5);
    TextLabel.RichText = true;
    TextLabel.Size = UDim2.fromScale(0.3, 0.4);
    TextLabel.Text = "SELECT AN ITEM TO USE WITH";
    TextLabel.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.ZIndex = 343;
    TextLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "ItemName";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.53, 0.5);
    TextLabel2.RichText = true;
    TextLabel2.Size = UDim2.fromScale(0.3, 0.35);
    TextLabel2.Text = "Sticker | Abudabi";
    TextLabel2.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 343;
    TextLabel2.Parent = Frame2;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Back";
    ImageButton.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.new();
    ImageButton.BackgroundTransparency = 0.8;
    ImageButton.LayoutOrder = 1;
    ImageButton.Position = UDim2.fromScale(0.01, 0.5);
    ImageButton.Size = UDim2.fromScale(0.05, 0.6);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = ImageButton;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "TextLabel";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel3.Size = UDim2.fromScale(0.9, 0.55);
    TextLabel3.Text = "Back";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel3.ZIndex = 343;
    TextLabel3.Parent = ImageButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = ImageButton;
    ImageButton.Parent = Frame2;
    Frame2.Parent = Frame;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "ALL";
    ScrollingFrame.Active = true;
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.Position = UDim2.fromScale(0.5, 0.075);
    ScrollingFrame.ScrollBarThickness = 8;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.Size = UDim2.fromScale(1, 0.923);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 20);
    UIPadding.PaddingLeft = UDim.new(0.012, 0);
    UIPadding.PaddingRight = UDim.new(0.012, 0);
    UIPadding.PaddingTop = UDim.new(0, 20);
    UIPadding.Parent = ScrollingFrame;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(0.012, 0.08);
    UIGridLayout.CellSize = UDim2.fromScale(0.1, 0.12);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.425;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = UIGridLayout;
    UIGridLayout.Parent = ScrollingFrame;
    ScrollingFrame.Parent = Frame;
    Frame.Parent = u4.Handler.MainMenu;

    return Frame;
end;

function u1.dropUI() -- Line: 2689
    local Frame = Instance.new("Frame");
    Frame.Name = "Right";
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.new(0, 0, 0.058, 0);
    Frame.Size = UDim2.fromScale(1, 0.058);
    Frame.ZIndex = 10;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0.1, 0);
    UIPadding.PaddingLeft = UDim.new(0.01, 0);
    UIPadding.PaddingRight = UDim.new(0.01, 0);
    UIPadding.PaddingTop = UDim.new(0.1, 0);
    UIPadding.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0.008, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://136983534433364";
    ImageLabel.Position = UDim2.fromScale(0.872884, 0.2);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "TextButton";
    TextButton.AnchorPoint = Vector2.new(1, 0.5);
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.Size = UDim2.fromScale(0.1, 1);
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    TextButton.TextTransparency = 1;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 1.3;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = TextButton;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = TextButton;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "AutoLeft";
    Frame2.BackgroundTransparency = 1;
    Frame2.Size = UDim2.fromScale(1, 1);
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingLeft = UDim.new(0, 10);
    UIPadding2.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0, 0.25);
    TextLabel.Size = UDim2.fromScale(1, 0.5);
    TextLabel.Text = "Newest";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.Parent = Frame2;
    Frame2.Parent = TextButton;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "V";
    TextLabel2.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(1, 0.5);
    TextLabel2.Rotation = 90;
    TextLabel2.Size = UDim2.fromScale(0.8, 0.6);
    TextLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel2.Text = ">";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.Parent = TextButton;
    TextButton.Parent = Frame;

    return Frame, TextButton;
end;

function u1.searchUI() -- Line: 2799
    local Frame = Instance.new("Frame");
    Frame.Name = "Search";
    Frame.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    Frame.BackgroundTransparency = 0.1;
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0, 0.058);
    Frame.Size = UDim2.fromScale(1, 0.058);
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Box";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(0.3, 0.7);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Line";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BackgroundTransparency = 0.6;
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.new(1, 0, 0, 2);
    Frame3.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://136926548005524";
    ImageLabel.Position = UDim2.fromScale(0, 0.45);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame2;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.AnchorPoint = Vector2.new(0, 0.5);
    TextBox.BackgroundTransparency = 1;
    TextBox.ClearTextOnFocus = false;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.PlaceholderColor3 = Color3.new(1, 1, 1);
    TextBox.PlaceholderText = "SEARCH INVENTORY";
    TextBox.Position = UDim2.fromScale(0.09, 0.45);
    TextBox.Size = UDim2.fromScale(0.7, 0.55);
    TextBox.Text = "";
    TextBox.TextColor3 = Color3.new(1, 1, 1);
    TextBox.TextScaled = true;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Count";
    TextLabel.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(1, 0.45);
    TextLabel.Size = UDim2.fromScale(0.2, 0.4);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.Parent = Frame2;
    Frame2.Parent = Frame;

    return Frame;
end;

return u1;