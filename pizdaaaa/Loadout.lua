-- ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Loadout
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.MainSection.Loadout
-- Decompile time: 82.23 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local GuiService = game:GetService("GuiService");
local workspace_CurrentCamera = workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;
local _ = game:GetService("ReplicatedStorage").Assets.Idle;
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
local u16 = {
    CT = Color3.fromRGB(172, 195, 220),
    T = Color3.fromRGB(255, 203, 107)
};
local u17 = {
    Equipment = {},
    ["Graphic Art"] = {}
};
local u18 = {};
local u19 = {
    StartingPistol = {
        ["1"] = UDim2.fromScale(1, 0.9)
    },
    OtherPistols = {
        ["1"] = UDim2.fromScale(1, 0.237),
        ["2"] = UDim2.fromScale(1, 0.237),
        ["3"] = UDim2.fromScale(1, 0.237),
        ["4"] = UDim2.fromScale(1, 0.237)
    },
    MidTier = {
        ["1"] = UDim2.fromScale(1, 0.19),
        ["2"] = UDim2.fromScale(1, 0.19),
        ["3"] = UDim2.fromScale(1, 0.19),
        ["4"] = UDim2.fromScale(1, 0.19),
        ["5"] = UDim2.fromScale(1, 0.19)
    },
    Rifles = {
        ["1"] = UDim2.fromScale(1, 0.19),
        ["2"] = UDim2.fromScale(1, 0.19),
        ["3"] = UDim2.fromScale(1, 0.19),
        ["4"] = UDim2.fromScale(1, 0.19),
        ["5"] = UDim2.fromScale(1, 0.19)
    }
};
local u20 = {
    CT = { "Agents", "Gloves", "Melee", "Music Kits", "Badges", "Graffiti" },
    T = { "Agents", "Gloves", "Melee", "Bomb", "Music Kits", "Badges", "Graffiti" }
};
local u21 = {
    CT = {
        Equipment = { "133302129992833", "117819809688631", "82947240831557", "93205492640717" },
        Grenades = { "91186462910790", "98246620979640", "73707831826167", "133852651202736", "123383191348718" }
    },
    T = {
        Equipment = { "133302129992833", "117819809688631", "82947240831557", "" },
        Grenades = { "91186462910790", "98246620979640", "73707831826167", "106079926169309", "123383191348718" }
    }
};
local u22 = {
    ["Music Kits"] = "78655238439008",
    Graffiti = "133661668263985",
    Badges = "93125581632960"
};
local u23 = {
    StartingPistol = "Starting Pistol",
    OtherPistols = "Other Pistols",
    MidTier = "Mid-Tier",
    Rifles = "Rifles",
    Gloves = "Gloves",
    Melee = "Melee",
    Agents = "Agents",
    Badges = "Badges",
    Bomb = "Bomb",
    ["Music Kits"] = "Music Kits",
    Graffiti = "Graffiti"
};
local u24 = {
    ["Starting Pistol"] = "StartingPistol",
    ["Other Pistols"] = "OtherPistols",
    ["Mid-Tier"] = "MidTier",
    Rifles = "Rifles",
    Gloves = "Gloves",
    Melee = "Melee",
    Agents = "Agents",
    Badges = "Badges",
    Bomb = "Bomb",
    ["Music Kits"] = "Music Kits",
    Graffiti = "Graffiti"
};
local u25 = "CT";
local u26 = u16[u25];
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = {};
local u36 = nil;
local u37 = nil;
local u38 = nil;
local u39 = nil;
local u40 = {};
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = nil;
local u45 = nil;
local u46 = nil;
local u47 = nil;
local u48 = nil;
local u49 = nil;
local u50 = nil;
local u51 = false;
local u52 = nil;
local u53 = nil;
local u54 = nil;
local u55 = true;
local u56 = nil;
local u57 = setmetatable({}, {
    __mode = "k"
});
local u58 = false;
local u59 = 0;
local u60 = false;
local u61 = false;
local TweenInfo_new_ret = TweenInfo.new(0.25);
local TweenInfo_new_ret2 = TweenInfo.new(0.35, Enum.EasingStyle.Quint);
local u62 = nil;
local u63 = nil;
local u64 = nil;

local function SearchWords(p65: string) -- Line: 192
    local v66 = {};

    for i in string.gmatch(string.lower(p65), "%w+") do
        table.insert(v66, i);
    end;

    return v66;
end;

local function SearchMatch(p67: any, p68: table) -- Line: 202
    local string_gsub_ret = string.gsub(string.lower((`{p67.Name}{p67.SkinInfo.Text}`)), "%W", "");

    for _, v in p68 do
        if not string.find(string_gsub_ret, v, 1, true) then
            return false;
        end;
    end;

    return true;
end;

local function QueueSearch() -- Line: 214
    -- upvalues: u60 (ref), u1 (copy)
    if u60 then
        return;
    end;

    u60 = true;
    task.defer(function() -- Line: 221
        -- upvalues: u60 (ref), u1 (ref)
        u60 = false;
        u1.UpdateWeaponSorting();
    end);
end;

local function RenderSlots() -- Line: 227
    -- upvalues: u19 (copy), u6 (ref), u25 (ref), u43 (ref), u45 (ref), u44 (ref), u46 (ref), u5 (ref), u26 (ref)
    for i, v in u19 do
        local v69 = i;

        for i2, v2 in v do
            local v70 = u6[u25];
            local v71 = u43.LoadoutNum[`{v69}_{i2}`];
            local v72 = v70[tostring(v71)];
            local WeaponName = v72.WeaponName;
            local SkinName = v72.SkinName;
            local v73 = u45.GetItem(WeaponName, SkinName) or u44.GetWeaponSkin(WeaponName, SkinName);
            local v74 = u45.GetCategory(WeaponName) or u46.Get(WeaponName);
            local v75 = v74.DisplayName or WeaponName;
            v2.Rarity.BackgroundColor3 = u5[v73.Rarity];
            v2.Icon.Image = `rbxassetid://{v73.Thumbnail}`;
            v2.IconShadow.Image = `rbxassetid://{v73.Thumbnail}`;
            v2.WeaponName.Text = v75;
            v2.Price.Text = `${v74.Data.Price}`;
            v2.CanvasGroup.GroupColor3 = u26;
            v2.WeaponName.TextColor3 = u26;
            v2:SetAttribute("WeaponName", WeaponName);
            v2:SetAttribute("SkinName", SkinName);
            v2:SetAttribute("SkinId", v72.SkinId);
        end;
    end;
end;

local function ItemClick(u76, u77, u78, u79, u80, u81) -- Line: 254
    -- upvalues: u31 (ref), u47 (ref), u38 (ref), u1 (copy), UserInputService (copy), u2 (ref), TweenService (copy), u37 (ref), u19 (copy), u30 (ref), u43 (ref), u25 (ref), u22 (copy), u33 (ref), u5 (ref), u6 (ref), u54 (ref), u42 (ref), u62 (ref), u36 (ref), u59 (ref), HttpService (copy), LocalPlayer (copy), RenderSlots (copy), u26 (ref), u4 (ref), u56 (ref), u35 (copy), TweenInfo_new_ret (copy), u51 (ref), workspace_CurrentCamera (copy), GuiService (copy)
    if u31 then
        return;
    end;

    local Icon = u76.Icon;
    u31 = u76;
    u47.Play("UI.inventory_item_pickup");
    local table_find_ret = table.find(u38, u77);
    local AbsoluteSize = Icon.AbsoluteSize;
    local u82 = u1.hold(AbsoluteSize, Icon.Image);
    local MouseLocation = UserInputService:GetMouseLocation();
    local v83 = u2.Handler.MainMenu:GetAttribute("TopInset") or 0;
    u82.Position = UDim2.new(0, MouseLocation.X - u82.AbsoluteSize.X / 2, 0, MouseLocation.Y - u82.AbsoluteSize.Y / 2 - v83);
    TweenService:Create(u82, TweenInfo.new(0.5), {
        Size = UDim2.new(0, AbsoluteSize.X * 1.1, 0, AbsoluteSize.Y * 1.1)
    }):Play();

    if table_find_ret then
        u37.Visible = true;
    else
        for _, v in u19[u77] do
            if v == u76 then
                v.GroupTransparency = 0.75;
            end;

            v.CanvasGroup.Visible = true;
            v.ImageLabel.Visible = true;
            v.Rarity.Position = UDim2.new(0.5, 0, 1, -3);
            v.Rarity.Size = UDim2.new(1, -6, 0, 3);
        end;
    end;

    local function Finish() -- Line: 291
        -- upvalues: u30 (ref), u76 (copy), u47 (ref), table_find_ret (copy), u43 (ref), u77 (copy), u81 (copy), u25 (ref), u22 (ref), u33 (ref), u5 (ref), Icon (copy), u6 (ref), u54 (ref), u42 (ref), u62 (ref), u36 (ref), u79 (copy), u80 (copy), u78 (copy), u19 (ref), u59 (ref), u31 (ref), HttpService (ref), LocalPlayer (ref), RenderSlots (ref), u37 (ref), u26 (ref), u4 (ref), u56 (ref), u82 (copy)
        if u30 and u30 ~= u76 then
            local v84 = u30.Parent and u30.Parent.Name;
            u47.Play("UI.inventory_item_putdown");
            local Attribute = u76:GetAttribute("WeaponName");
            local Attribute2 = u76:GetAttribute("SkinName");
            local Attribute3 = u76:GetAttribute("SkinId");
            local v85 = table_find_ret and u43.LoadoutNum[`{u77}`] or u43.LoadoutNum[`{v84}_{u30.Name}`];
            local v86 = u43.InventoryCategoriesNum[u81 or "Equipment"];
            local v87 = u43.TeamsNum[u25];

            if table_find_ret then
                local v88 = u22[u77];

                if v88 then
                    for _, v in { "CT", "T" } do
                        local v89 = u33[`{v}_Character`].Equipment[u77];

                        if Attribute2 == "None" then
                            v89.Rarity.BackgroundColor3 = u5.Stock;
                            v89.DefaultIcon.Image = `rbxassetid://{v88}`;
                            v89.DefaultIcon.Visible = true;
                            v89.Icon.Visible = false;
                        else
                            v89.Icon.Image = Icon.Image;
                            v89.Rarity.BackgroundColor3 = u76.Rarity.BackgroundColor3;
                            v89.DefaultIcon.Visible = false;
                            v89.Icon.Visible = true;
                        end;

                        if u6 and u6[v] then
                            u6[v][tostring(v85)] = {
                                WeaponName = Attribute,
                                SkinName = Attribute2,
                                SkinId = Attribute3
                            };
                        end;

                        u54.SetEquipped(v, Attribute, Attribute2, Attribute3);
                        u42.Gui.ChangeLoadoutWeapon.Fire({
                            A = v85,
                            B = v86,
                            C = Attribute,
                            D = Attribute2,
                            E = Attribute3,
                            T = u43.TeamsNum[v]
                        });
                    end;

                    task.delay(0.5, function() -- Line: 344
                        -- upvalues: u62 (ref)
                        u62.UpdatePin();
                    end);
                else
                    local v90 = u36[u77];
                    v90.Icon.Image = Icon.Image;
                    v90.Rarity.BackgroundColor3 = u76.Rarity.BackgroundColor3;
                    v90.DefaultIcon.Visible = false;
                    v90.Icon.Visible = true;

                    if u6 and u6[u25] then
                        u6[u25][tostring(v85)] = {
                            WeaponName = Attribute,
                            SkinName = Attribute2,
                            SkinId = Attribute3
                        };
                    end;

                    u54.SetEquipped(u25, Attribute, Attribute2, Attribute3);
                    u42.Gui.ChangeLoadoutWeapon.Fire({
                        A = v85,
                        B = v86,
                        C = Attribute,
                        D = Attribute2,
                        E = Attribute3,
                        T = v87
                    });
                end;
            elseif u77 == v84 then
                local Image = u30.Icon.Image;
                local BackgroundColor3 = u30.Rarity.BackgroundColor3;
                local Text = u30.WeaponName.Text;
                local Text2 = u30.Price.Text;
                local Attribute4 = u30:GetAttribute("WeaponName");
                local Attribute5 = u30:GetAttribute("SkinName");
                local Attribute6 = u30:GetAttribute("SkinId");
                u30.WeaponName.Text = u79;
                u30.Price.Text = u80;
                u30.Icon.Image = Icon.Image;
                u30.IconShadow.Image = Icon.Image;
                u30.Rarity.BackgroundColor3 = u76.Rarity.BackgroundColor3;
                u30:SetAttribute("WeaponName", Attribute);
                u30:SetAttribute("SkinName", Attribute2);
                u30:SetAttribute("SkinId", Attribute3);

                if u78 then
                    u76.WeaponName.Text = Text;
                    u76.Price.Text = Text2;
                    u76.Icon.Image = Image;
                    u76.IconShadow.Image = Image;
                    u76.Rarity.BackgroundColor3 = BackgroundColor3;
                    u76:SetAttribute("WeaponName", Attribute4);
                    u76:SetAttribute("SkinName", Attribute5);
                    u76:SetAttribute("SkinId", Attribute6);
                else
                    for _, v in u19[u77] do
                        if v ~= u30 and v:GetAttribute("WeaponName") == Attribute then
                            v.Icon.Image = Image;
                            v.Rarity.BackgroundColor3 = BackgroundColor3;
                            v.IconShadow.Image = Image;
                            v.WeaponName.Text = Text;
                            v.Price.Text = Text2;
                            v:SetAttribute("WeaponName", Attribute4);
                            v:SetAttribute("SkinName", Attribute5);
                            v:SetAttribute("SkinId", Attribute6);
                        end;
                    end;
                end;

                if u6 and u6[u25] then
                    u6[u25][tostring(v85)] = {
                        WeaponName = Attribute,
                        SkinName = Attribute2,
                        SkinId = Attribute3
                    };
                end;

                u54.SetEquipped(u25, Attribute, Attribute2, Attribute3);
                u42.Gui.ChangeLoadoutWeapon.Fire({
                    A = v85,
                    B = v86,
                    C = Attribute,
                    D = Attribute2,
                    E = Attribute3,
                    T = v87
                });
                u59 = u59 + 1;
                local u91 = u59;
                task.delay(1, function() -- Line: 441
                    -- upvalues: u91 (copy), u59 (ref), u31 (ref), u6 (ref), HttpService (ref), LocalPlayer (ref), RenderSlots (ref)
                    if u91 ~= u59 or u31 then
                        return;
                    end;

                    u6 = HttpService:JSONDecode(LocalPlayer:GetAttribute("WeaponLoadout"));
                    RenderSlots();
                end);
            end;
        end;

        if table_find_ret then
            u37.Visible = false;
        else
            for _, v in u19[u77] do
                v.CanvasGroup.Visible = false;
                v.ImageLabel.Visible = false;
                v.Rarity.Position = UDim2.new(0.5, 0, 1, 0);
                v.Rarity.Size = UDim2.new(1, 0, 0, 3);
                v.Transparency = 0.9;
                v.GroupTransparency = 0;
                v.CanvasGroup.GroupColor3 = u26;
            end;
        end;

        u31 = nil;
        u4:Removes("InputEnded", "HoldConnect");
        u56.Override(nil);
        u82:Destroy();
    end;

    local function InputEnded(p92: userdata) -- Line: 476
        -- upvalues: Finish (copy)
        if p92.UserInputType ~= Enum.UserInputType.MouseButton1 and p92.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        Finish();
    end;

    local u93 = nil;

    local function SetHoverTarget(p94) -- Line: 486
        -- upvalues: u93 (ref), table_find_ret (copy), u33 (ref), u35 (ref), TweenService (ref), TweenInfo_new_ret (ref), u30 (ref), u47 (ref)
        if u93 == p94 then
            return;
        end;

        if u93 then
            if table_find_ret then
                local v95 = u35[u93 == u33.CT_Character and "CT" or "T"];

                if v95 then
                    TweenService:Create(v95, TweenInfo_new_ret, {
                        Transparency = 1
                    }):Play();
                end;

                TweenService:Create(u93, TweenInfo_new_ret, {
                    BackgroundTransparency = 1
                }):Play();
            else
                TweenService:Create(u93, TweenInfo.new(0.1), {
                    Transparency = 0.9,
                    BackgroundColor3 = Color3.new(0, 0, 0)
                }):Play();
            end;
        end;

        u93 = p94;
        u30 = p94;

        if p94 then
            u47.Play("UI.mainmenu_rollover");

            if table_find_ret then
                local v96 = u35[p94 == u33.CT_Character and "CT" or "T"];

                if v96 and v96.Visible then
                    TweenService:Create(v96, TweenInfo_new_ret, {
                        Transparency = 0.65
                    }):Play();
                end;
            elseif p94.CanvasGroup and p94.CanvasGroup.Visible then
                TweenService:Create(p94, TweenInfo.new(0.25), {
                    Transparency = 0.65
                }):Play();
            end;
        end;
    end;

    if u51 then
        local function GetTouchTarget(p97) -- Line: 526
            -- upvalues: LocalPlayer (ref), table_find_ret (copy), u33 (ref), u19 (ref), u77 (copy)
            local v98 = LocalPlayer:FindFirstChildOfClass("PlayerGui");
            local v99 = v98 and (v98:GetGuiObjectsAtPosition(p97.X, p97.Y) or {}) or {};

            if table_find_ret then
                for _, v in { "CT", "T" } do
                    local v100 = u33[`{v}_Character`];

                    if v100 then
                        local Hitbox = v100:FindFirstChild("Hitbox");

                        for _, v2 in v99 do
                            if v2 == Hitbox or (v2 == v100 or v2:IsDescendantOf(v100)) then
                                return v100;
                            end;
                        end;

                        local AbsolutePosition = v100.AbsolutePosition;
                        local AbsoluteSize2 = v100.AbsoluteSize;

                        if p97.X >= AbsolutePosition.X and (p97.X <= AbsolutePosition.X + AbsoluteSize2.X and (p97.Y >= AbsolutePosition.Y and p97.Y <= AbsolutePosition.Y + AbsoluteSize2.Y)) then
                            return v100;
                        end;
                    end;
                end;
            else
                local v101 = u19[u77];

                if v101 then
                    for _, v in v101 do
                        local v102 = v;

                        for _, v2 in v99 do
                            if v2 == v102 or v2:IsDescendantOf(v102) then
                                return v102;
                            end;
                        end;

                        local AbsolutePosition = v102.AbsolutePosition;
                        local AbsoluteSize2 = v102.AbsoluteSize;

                        if p97.X >= AbsolutePosition.X and (p97.X <= AbsolutePosition.X + AbsoluteSize2.X and (p97.Y >= AbsolutePosition.Y and p97.Y <= AbsolutePosition.Y + AbsoluteSize2.Y)) then
                            return v102;
                        end;
                    end;
                end;
            end;

            return nil;
        end;

        u4:Add("HoldConnect", UserInputService.TouchMoved:Connect(function(p103) -- Line: 565
            -- upvalues: u2 (ref), workspace_CurrentCamera (ref), GuiService (ref), u82 (copy), GetTouchTarget (copy), SetHoverTarget (copy)
            local v104 = u2.Handler.AbsoluteSize - workspace_CurrentCamera.ViewportSize;
            local GuiInset = GuiService:GetGuiInset();
            local Vector2_new_ret = Vector2.new(p103.Position.X + v104.X / 2, p103.Position.Y + v104.Y / 2 + GuiInset.Y);
            local v105 = u2.Handler.MainMenu:GetAttribute("TopInset") or 0;
            u82.Position = UDim2.new(0, Vector2_new_ret.X - u82.AbsoluteSize.X / 2, 0, Vector2_new_ret.Y - u82.AbsoluteSize.Y / 2 - v105);
            SetHoverTarget((GetTouchTarget(p103.Position)));
        end));
        u4:Add("InputEnded", UserInputService.TouchEnded:Connect(function(p106) -- Line: 581
            -- upvalues: GetTouchTarget (copy), u30 (ref), Finish (copy)
            local v107 = GetTouchTarget(p106.Position);

            if v107 then
                u30 = v107;
            end;

            if p106.UserInputType ~= Enum.UserInputType.MouseButton1 and p106.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            Finish();
        end));
    elseif u56.Navigating() then
        local function GamepadTarget(p108: userdata) -- Line: 589
            -- upvalues: table_find_ret (copy), u33 (ref), u19 (ref), u77 (copy)
            if table_find_ret then
                for _, v in { "CT", "T" } do
                    local v109 = u33[`{v}_Character`];

                    if v109 and (p108 == v109 or p108:IsDescendantOf(v109)) then
                        return v109;
                    end;
                end;

                return nil;
            end;

            for _, v in u19[u77] do
                if p108 == v or p108:IsDescendantOf(v) then
                    return v;
                end;
            end;

            return nil;
        end;

        local function Follow() -- Line: 611
            -- upvalues: GuiService (ref), SetHoverTarget (copy), GamepadTarget (copy), u2 (ref), u82 (copy), TweenService (ref)
            local SelectedObject = GuiService.SelectedObject;

            if not SelectedObject then
                return;
            end;

            SetHoverTarget((GamepadTarget(SelectedObject)));
            local v110 = SelectedObject.AbsolutePosition + SelectedObject.AbsoluteSize / 2 - u2.Handler.MainMenu.AbsolutePosition;
            local AbsoluteSize2 = u82.AbsoluteSize;
            TweenService:Create(u82, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                Position = UDim2.fromOffset(v110.X - AbsoluteSize2.X / 2, v110.Y - AbsoluteSize2.Y / 2)
            }):Play();
        end;

        Follow();
        u4:Add("HoldConnect", GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(Follow));
        u56.Override(function(p111) -- Line: 629
            -- upvalues: Finish (copy), SetHoverTarget (copy)
            if p111 == Enum.KeyCode.ButtonX then
                Finish();

                return true;
            end;

            if p111 ~= Enum.KeyCode.ButtonB then
                return false;
            end;

            SetHoverTarget(nil);
            Finish();

            return true;
        end);
    else
        u4:Add("HoldConnect", UserInputService.InputChanged:Connect(function(p112) -- Line: 642
            -- upvalues: UserInputService (ref), u82 (copy)
            if p112.UserInputType ~= Enum.UserInputType.MouseMovement then
                return;
            end;

            local MouseLocation2 = UserInputService:GetMouseLocation();
            u82.Position = UDim2.new(0, MouseLocation2.X - u82.AbsoluteSize.X / 2, 0, MouseLocation2.Y - u82.AbsoluteSize.Y / 2);
        end));
        u4:Add("InputEnded", UserInputService.InputEnded:Connect(InputEnded));
    end;
end;

local u113 = {};

local function GetEquippedWeaponSkin(p114: string, p115: string) -- Line: 657
    -- upvalues: u6 (ref)
    if u6 and u6[p114] then
        for _, v in u6[p114] do
            if v.WeaponName == p115 then
                return v.SkinName;
            end;
        end;
    end;

    return "Stock";
end;

local function GetDefaultWeapon(p116: string) -- Line: 668
    -- upvalues: u6 (ref)
    if p116 == "T" then
        local v117 = "AK-47";

        if u6 and u6.T then
            for _, v in u6.T do
                if v.WeaponName == "AK-47" then
                    return v117, v.SkinName;
                end;
            end;
        end;

        return v117, "Stock";
    end;

    local v118 = false;
    local v119 = "Stock";
    local v120 = false;
    local v121 = "Stock";

    if u6 and u6.CT then
        for _, v in u6.CT do
            if v.WeaponName == "M4A1-S" then
                v119 = v.SkinName;
                v118 = true;
            elseif v.WeaponName == "M4A4" then
                v121 = v.SkinName;
                v120 = true;
            end;
        end;
    end;

    if v118 and not v120 then
        return "M4A1-S", v119;
    end;

    if v120 then
        return "M4A4", v121;
    end;

    if v118 then
        return "M4A1-S", v119;
    end;

    return "M4A4", "Stock";
end;

local function SetCharacterWeapon(p122: string, p123: string, p124: string?) -- Line: 701
    -- upvalues: u113 (copy), u53 (ref), u6 (ref), u7 (ref)
    local v125 = u113[p122];

    if not (v125 and v125.Model) then
        return;
    end;

    local WeaponClass = u53.GetWeaponClass(p123);

    if not WeaponClass then
        return;
    end;

    if not p124 then
        if u6 and u6[p122] then
            p124 = "Stock";

            for _, v in u6[p122] do
                if v.WeaponName == p123 then
                    p124 = v.SkinName;
                    break;
                end;
            end;
        end;
    end;

    if v125.CurrentWeapon == p123 and v125.CurrentSkin == p124 then
        return;
    end;

    v125.CurrentWeapon = p123;
    v125.CurrentSkin = p124;
    u53.AddWeapon(v125.Model, p123, p124);
    local v126 = u53.AnimationIds[WeaponClass] and u53.AnimationIds[WeaponClass].Loadout;

    if v126 then
        local v127 = v125.Tracks[v126];

        if not v127 then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = v126;
            v127 = v125.Model.Humanoid.Animator:LoadAnimation(Animation);
            v127.Looped = true;
            v125.Tracks[v126] = v127;
        end;

        if v125.CurrentTrack and v125.CurrentTrack ~= v127 then
            v125.CurrentTrack:Stop(0.1);
        end;

        if not v127.IsPlaying and u7.Visible then
            v127:Play(0.1);
        end;

        v125.CurrentTrack = v127;
    end;
end;

local function PlayCharacters() -- Line: 746
    -- upvalues: u7 (ref), u2 (ref), u113 (copy)
    local v128 = u7.Visible and u2.Handler.MainMenu.Visible;

    for _, v in u113 do
        local CurrentTrack = v.CurrentTrack;

        if CurrentTrack then
            if v128 then
                CurrentTrack:Play(0);
            else
                CurrentTrack:Stop(0);
            end;
        end;
    end;
end;

local function SetCharacterAgent(p129: string) -- Line: 764
    -- upvalues: u113 (copy), u1 (copy), u53 (ref)
    local v130 = u113[p129];

    if not (v130 and v130.Model) then
        return;
    end;

    local LoadoutData = u1.GetLoadoutData();

    if LoadoutData then
        LoadoutData = LoadoutData[p129];
    end;

    if LoadoutData then
        LoadoutData = LoadoutData["15"];
    end;

    local v131 = LoadoutData and LoadoutData.SkinName or `{p129} Agent`;

    if v130.AgentName == v131 then
        return;
    end;

    if v130.AgentAdded then
        u53.RemoveAgent(v130.Model, v130.AgentAdded);
    end;

    v130.AgentName = v131;
    v130.AgentAdded = u53.ApplyAgent(v130.Model, v131);
end;

local function SetCharacterGloves(p132: string) -- Line: 787
    -- upvalues: u113 (copy), u1 (copy), u53 (ref)
    local v133 = u113[p132];

    if not (v133 and v133.Model) then
        return;
    end;

    local LoadoutData = u1.GetLoadoutData();

    if LoadoutData then
        LoadoutData = LoadoutData[p132];
    end;

    if LoadoutData then
        LoadoutData = LoadoutData["16"];
    end;

    local v134 = LoadoutData and LoadoutData.WeaponName or `{p132} Gloves`;
    local v135 = LoadoutData and LoadoutData.SkinName or "Stock";

    if v133.GloveWeapon == v134 and v133.GloveSkin == v135 then
        return;
    end;

    for _, v in v133.GloveAccessories or {} do
        v:Destroy();
    end;

    v133.GloveWeapon = v134;
    v133.GloveSkin = v135;
    v133.GloveAccessories = u53.ApplyGloves(v133.Model, v134, v135);
end;

function u1.Draw() -- Line: 813
    -- upvalues: u36 (ref), u33 (ref), u25 (ref), u37 (ref), u35 (copy), u38 (ref), u20 (copy), u39 (ref), u21 (copy), u19 (copy), u34 (ref), u6 (ref), u43 (ref), u45 (ref), u44 (ref), u46 (ref), u1 (copy), u5 (ref), u26 (ref), u4 (ref), SetCharacterWeapon (copy), u31 (ref), TweenService (copy), u30 (ref), u27 (ref), u23 (copy), u15 (ref), u29 (ref), ItemClick (copy), u57 (copy), u56 (ref), u49 (ref), u63 (ref), u24 (copy), u22 (copy), TweenInfo_new_ret (copy), u54 (ref), u42 (ref), u62 (ref), u53 (ref), u113 (copy), SetCharacterAgent (copy), SetCharacterGloves (copy), GetDefaultWeapon (copy), u47 (ref), u16 (copy), u8 (ref), RenderSlots (copy)
    u36 = u33[`{u25}_Character`].Equipment;
    u37 = u35[u25];
    u38 = u20[u25];
    u39 = u21[u25];

    for i, v in u39 do
        local v136 = u33.Center[i];

        for i2, v2 in v do
            v136[tostring(i2)].Icon.Image = `rbxassetid://{v2}`;
        end;
    end;

    for i, v in u19 do
        local v137 = u34[i];
        local Title = v137[`{i}_Misc`].Title;
        local u138 = v;
        local u139 = i;

        for i2, v2 in v do
            local v140 = u6[u25];
            local v141 = u43.LoadoutNum[`{u139}_{i2}`];
            local v142 = v140[tostring(v141)];
            local WeaponName = v142.WeaponName;
            local SkinName = v142.SkinName;
            local v143 = u45.GetItem(WeaponName, SkinName) or u44.GetWeaponSkin(WeaponName, SkinName);
            local v144 = u45.GetCategory(WeaponName) or u46.Get(WeaponName);
            local u145 = u1.loadoutFrame(v137, v2);
            local Icon = u145.Icon;
            local v146 = v144.DisplayName or WeaponName;
            u145.Rarity.BackgroundColor3 = u5[v143.Rarity];
            u145.CanvasGroup.GroupColor3 = u26;
            Icon.Image = `rbxassetid://{v143.Thumbnail}`;
            u145.IconShadow.Image = `rbxassetid://{v143.Thumbnail}`;
            u145.WeaponName.Text = v146;
            u145.Price.Text = `${v144.Data.Price}`;
            u145:SetAttribute("WeaponName", WeaponName);
            u145:SetAttribute("SkinName", SkinName);
            u145:SetAttribute("SkinId", v142.SkinId);
            u145.Name = i2;
            u145.LayoutOrder = i2;
            u4:Add(`{u139}{i2}IconMouseEnter`, Icon.InputBegan:Connect(function(p147) -- Line: 858
                -- upvalues: u145 (copy), SetCharacterWeapon (ref), u25 (ref), u31 (ref), TweenService (ref), Icon (copy), u30 (ref)
                if p147.UserInputType ~= Enum.UserInputType.MouseMovement and p147.UserInputType ~= Enum.UserInputType.Touch then
                    return;
                end;

                local Attribute = u145:GetAttribute("WeaponName");
                local Attribute2 = u145:GetAttribute("SkinName");

                if Attribute then
                    SetCharacterWeapon(u25, Attribute, Attribute2);
                end;

                if u31 then
                    u30 = u145;

                    if u145.CanvasGroup.Visible then
                        TweenService:Create(u145, TweenInfo.new(0.25), {
                            Transparency = 0.65
                        }):Play();
                    end;

                    return;
                end;

                TweenService:Create(Icon, TweenInfo.new(0.25), {
                    Position = UDim2.new(0, 2, 0, -5)
                }):Play();
                TweenService:Create(u145, TweenInfo.new(0.25), {
                    BackgroundColor3 = Color3.new(1, 1, 1)
                }):Play();
            end));
            u4:Add(`{u139}{i2}IconMouseLeave`, Icon.InputEnded:Connect(function(p148) -- Line: 882
                -- upvalues: u30 (ref), u145 (copy), TweenService (ref), Icon (copy)
                if p148.UserInputType ~= Enum.UserInputType.MouseMovement and p148.UserInputType ~= Enum.UserInputType.Touch then
                    return;
                end;

                if u30 == u145 then
                    task.wait();
                    u30 = nil;
                end;

                TweenService:Create(Icon, TweenInfo.new(0.25), {
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play();
                TweenService:Create(u145, TweenInfo.new(0.1), {
                    Transparency = 0.9,
                    BackgroundColor3 = Color3.new(0, 0, 0)
                }):Play();
            end));

            u57[Icon] = function() -- Line: 896, Name: Pick
                -- upvalues: u31 (ref), u27 (ref), u23 (ref), u139 (copy), u15 (ref), u1 (ref), u29 (ref), u145 (copy), ItemClick (ref)
                if u31 then
                    return;
                end;

                u27 = u23[u139];
                u15.TextBox.Text = "";
                u1.UpdateSorting();
                u29 = u145:GetAttribute("WeaponName");
                u1.UpdateWeaponSorting();
                ItemClick(u145, u139, true, u145.WeaponName.Text, u145.Price.Text);
            end;

            u4:Add(`{u139}{i2}IconMouseButton1Down`, Icon.MouseButton1Down:Connect(function() -- Line: 913
                -- upvalues: u56 (ref), u31 (ref), u27 (ref), u23 (ref), u139 (copy), u15 (ref), u1 (ref), u29 (ref), u145 (copy), ItemClick (ref)
                if u56.Navigating() then
                    return;
                end;

                if u31 then
                    return;
                end;

                u27 = u23[u139];
                u15.TextBox.Text = "";
                u1.UpdateSorting();
                u29 = u145:GetAttribute("WeaponName");
                u1.UpdateWeaponSorting();
                ItemClick(u145, u139, true, u145.WeaponName.Text, u145.Price.Text);
            end));
            u4:Add(`{u139}{i2}IconMouseButton2Click`, Icon.MouseButton2Click:Connect(function() -- Line: 921
                -- upvalues: u31 (ref), u43 (ref), u19 (ref), u49 (ref), u145 (copy), u63 (ref)
                if u31 then
                    return;
                end;

                local v149 = {};
                table.insert(v149, {
                    name = "Inspect",

                    callback = function() -- Line: 928, Name: callback
                        -- upvalues: u43 (ref), u19 (ref), u49 (ref), u145 (ref)
                        local v150 = {};

                        for i3 = 0, 14 do
                            local table_unpack_ret, v151 = table.unpack(u43.Loadout[i3]:split("_"));
                            table.insert(v150, u19[table_unpack_ret][v151]);
                            local _ = i3;
                        end;

                        u49.Browse(u145, v150);
                    end
                });

                if not next(v149) then
                    return;
                end;

                u63.RightClick(u145, v149);
            end));
            u49.Register(u145, function() -- Line: 947
                -- upvalues: u145 (copy), u45 (ref), u44 (ref), u46 (ref)
                local Attribute = u145:GetAttribute("WeaponName");
                local Attribute2 = u145:GetAttribute("SkinName");
                local Attribute3 = u145:GetAttribute("SkinId");
                local v152 = u45.GetItem(Attribute, Attribute2) or u44.GetWeaponSkin(Attribute, Attribute2);
                local v153 = u45.GetCategory(Attribute) or u46.Get(Attribute);
                local v154 = MenuInventory.Equipment and (MenuInventory.Equipment[Attribute] and MenuInventory.Equipment[Attribute][Attribute2]) and MenuInventory.Equipment[Attribute][Attribute2][Attribute3];
                local v155;

                if v154 then
                    v155 = v154.Stickers;
                else
                    v155 = v154;
                end;

                local v156;

                if v154 then
                    v156 = v154.NameTag;
                else
                    v156 = v154;
                end;

                local v157;

                if v154 then
                    v157 = v154.KillTrack;
                else
                    v157 = v154;
                end;

                if v154 then
                    v154 = v154.KillTrackColor;
                end;

                return table.pack(Attribute, Attribute2, v152.Rarity, v152.Description or v153.GuiInformation.Description, v155, nil, nil, v156, Attribute3, v157, v154);
            end);
            u138[i2] = u145;
        end;

        u4:Add(`{u139}MouseEnter`, v137.MouseEnter:Connect(function() -- Line: 963
            -- upvalues: u31 (ref), u138 (copy), TweenService (ref), u24 (ref), u27 (ref), u139 (copy), Title (copy)
            if u31 then
                return;
            end;

            for _, v2 in u138 do
                TweenService:Create(v2.Price, TweenInfo.new(0.25), {
                    TextTransparency = 0
                }):Play();
                TweenService:Create(v2.WeaponName, TweenInfo.new(0.25), {
                    TextTransparency = 0
                }):Play();
            end;

            if u24[u27] == u139 then
                return;
            end;

            TweenService:Create(Title.TextLabel, TweenInfo.new(0.25), {
                TextColor3 = Color3.new(1, 1, 1)
            }):Play();
            TweenService:Create(Title.ImageLabel, TweenInfo.new(0.25), {
                ImageColor3 = Color3.new(1, 1, 1)
            }):Play();
        end));
        u4:Add(`{u139}MouseLeave`, v137.MouseLeave:Connect(function() -- Line: 980
            -- upvalues: u24 (ref), u27 (ref), u139 (copy), TweenService (ref), Title (copy), u26 (ref), u31 (ref), u138 (copy)
            if u24[u27] ~= u139 then
                TweenService:Create(Title.TextLabel, TweenInfo.new(0.25), {
                    TextColor3 = u26
                }):Play();
                TweenService:Create(Title.ImageLabel, TweenInfo.new(0.25), {
                    ImageColor3 = u26
                }):Play();
            end;

            if u31 then
                return;
            end;

            for _, v2 in u138 do
                TweenService:Create(v2.Price, TweenInfo.new(0.1), {
                    TextTransparency = 1
                }):Play();
                TweenService:Create(v2.WeaponName, TweenInfo.new(0.1), {
                    TextTransparency = 1
                }):Play();
            end;
        end));
        u4:Add(`{u139}MouseButton1Click`, Title.MouseButton1Click:Connect(function() -- Line: 995
            -- upvalues: u31 (ref), u27 (ref), u23 (ref), u139 (copy), u1 (ref)
            if u31 then
                return;
            end;

            u27 = u23[u139];
            u1.UpdateSorting();
        end));
    end;

    for i, v in { "CT", "T" } do
        local u158 = v == "CT" and "T" or "CT";
        local u159 = u33[`{v}_Character`];
        local u160 = u35[v];
        local Equipment = u159.Equipment;
        local u161 = u20[v];
        local u162 = u21[v];
        u160.Visible = false;
        local v163 = i;
        local u164 = v;

        for i2, v2 in u161 do
            local v165 = u6[u164];
            local v166 = u43.LoadoutNum[`{v2}`];
            local v167 = v165[tostring(v166)];
            local WeaponName = v167.WeaponName;
            local SkinName = v167.SkinName;
            local u168 = u1.equipmentFrame(Equipment, v2, i2);
            local u169 = u22[v2];
            u4:Add(`{u164}{i2}{v2}MouseEnter`, u168.MouseEnter:Connect(function() -- Line: 1046
                -- upvalues: u164 (copy), u25 (ref), TweenService (ref), u168 (copy), TweenInfo_new_ret (ref)
                if u164 ~= u25 then
                    return;
                end;

                TweenService:Create(u168, TweenInfo_new_ret, {
                    BackgroundTransparency = 0.6,
                    BackgroundColor3 = Color3.new(1, 1, 1)
                }):Play();
            end));
            u4:Add(`{u164}{i2}{v2}MouseLeave`, u168.MouseLeave:Connect(function() -- Line: 1053
                -- upvalues: TweenService (ref), u168 (copy), TweenInfo_new_ret (ref)
                TweenService:Create(u168, TweenInfo_new_ret, {
                    BackgroundTransparency = 0.9,
                    BackgroundColor3 = Color3.new(0, 0, 0)
                }):Play();
            end));
            u4:Add(`{u164}{i2}{v2}MouseButton1Click`, u168.MouseButton1Click:Connect(function() -- Line: 1056
                -- upvalues: u31 (ref), u164 (copy), u25 (ref), u27 (ref), u23 (ref), v2 (copy), u1 (ref)
                if u31 then
                    return;
                end;

                if u164 ~= u25 then
                    return;
                end;

                u27 = u23[v2];
                u1.UpdateSorting();
            end));
            u4:Add(`{u164}{i2}{v2}MouseButton2Click`, u168.MouseButton2Click:Connect(function() -- Line: 1069
                -- upvalues: u31 (ref), u164 (copy), u25 (ref), v2 (copy), u33 (ref), u5 (ref), u169 (copy), u54 (ref), u42 (ref), u43 (ref), u62 (ref)
                if u31 or (u164 ~= u25 or v2 ~= "Badges" and v2 ~= "Grafitti") then
                    return;
                end;

                for _, v3 in { "CT", "T" } do
                    local v170 = u33[`{v3}_Character`].Equipment[v2];
                    v170.Rarity.BackgroundColor3 = u5.Stock;
                    v170.DefaultIcon.Image = `rbxassetid://{u169}`;
                    v170.DefaultIcon.Visible = true;
                    v170.Icon.Visible = false;

                    if v2 == "Badges" then
                        u54.SetEquipped(v3, "Badges", "None", "50");
                        u42.Gui.ChangeLoadoutWeapon.Fire({
                            A = 19,
                            B = 1,
                            C = "Badges",
                            D = "None",
                            E = "50",
                            T = u43.TeamsNum[v3]
                        });
                    elseif v2 == "Grafitti" then
                        u54.SetEquipped(v3, "Grafitti", "None", "51");
                        u42.Gui.ChangeLoadoutWeapon.Fire({
                            A = 20,
                            B = 1,
                            C = "Grafitti",
                            D = "None",
                            E = "51",
                            T = u43.TeamsNum[v3]
                        });
                    end;
                end;

                task.delay(0.5, function() -- Line: 1106
                    -- upvalues: u62 (ref)
                    u62.UpdatePin();
                end);
            end));

            if u169 and SkinName == "None" then
                u168.Rarity.BackgroundColor3 = u5.Stock;
                u168.DefaultIcon.Image = `rbxassetid://{u169}`;
                u168.DefaultIcon.Visible = true;
                u168.Icon.Visible = false;
            else
                local v171 = u45.GetItem(WeaponName, SkinName) or u44.GetWeaponSkin(WeaponName, SkinName);
                u168.Rarity.BackgroundColor3 = u5[v171.Rarity];
                u168.Icon.Image = `rbxassetid://{v171.Thumbnail}`;
                u168.DefaultIcon.Visible = false;
                u168.Icon.Visible = true;
            end;
        end;

        local Camera = Instance.new("Camera");
        local WorldModel = Instance.new("WorldModel");
        WorldModel.Parent = u159.Character;
        Camera.CFrame = CFrame.lookAt(Vector3.new(0, 0, -6), Vector3.new(0, 0, 0));
        Camera.Parent = u159.Character;
        u159.Character.CurrentCamera = Camera;
        local v172 = u53.new({
            Name = `{u164}_Loadout`,
            Parent = WorldModel
        });
        v172.Parent = WorldModel;
        u113[u164] = {
            CurrentWeapon = nil,
            CurrentSkin = nil,
            CurrentTrack = nil,
            Model = v172,
            Tracks = {}
        };
        SetCharacterAgent(u164);
        SetCharacterGloves(u164);
        local v173, v174 = GetDefaultWeapon(u164);
        SetCharacterWeapon(u164, v173, v174);
        v172:PivotTo(CFrame.new(0, -0.2, -0.8));
        local ImageButton = Instance.new("ImageButton");
        ImageButton.Name = "Hitbox";
        ImageButton.AnchorPoint = Vector2.new(v163 - 1, 0.5);
        ImageButton.BackgroundTransparency = 1;
        ImageButton.ImageTransparency = 1;
        ImageButton.Position = UDim2.fromScale(v163 - 1, 0.5);
        ImageButton.Size = UDim2.fromScale(1.08316, 1);
        ImageButton.Parent = u159;
        u4:Add(`{u164}HitboxMouseButton1Click`, ImageButton.MouseButton1Click:Connect(function() -- Line: 1175
            -- upvalues: u31 (ref), u25 (ref), u164 (copy), u47 (ref), u37 (ref), u160 (copy), u36 (ref), Equipment (copy), u38 (ref), u161 (copy), u39 (ref), u162 (copy), u26 (ref), u16 (ref), TweenService (ref), u8 (ref), u158 (copy), u159 (copy), u33 (ref), u19 (ref), u34 (ref), u24 (ref), u27 (ref), RenderSlots (ref), u1 (ref)
            if u31 then
                return;
            end;

            if u25 == u164 then
                return;
            end;

            u47.Play("UI.submenu_click");
            u47.Play("UI.generic_press");
            u25 = u164;
            u37 = u160;
            u36 = Equipment;
            u38 = u161;
            u39 = u162;
            u26 = u16[u164];
            TweenService:Create(u8[u164], TweenInfo.new(0.25), {
                Transparency = 0
            }):Play();
            TweenService:Create(u8[u164][`{u164}_Line`], TweenInfo.new(0.25), {
                Transparency = 0
            }):Play();
            TweenService:Create(u8[u158], TweenInfo.new(0.25), {
                Transparency = 1
            }):Play();
            TweenService:Create(u8[u158][`{u158}_Line`], TweenInfo.new(0.25), {
                Transparency = 1
            }):Play();
            local v175 = u159;
            local v176 = u33[`{u158}_Character`];
            local Equip = v175.Equip;
            local Equip2 = v176.Equip;
            Equip.BackgroundTransparency = 0;
            Equip.TextLabel.TextColor3 = Color3.new();
            Equip2.BackgroundTransparency = 1;
            Equip2.TextLabel.TextColor3 = Equip2.BackgroundColor3;
            v175.GroupTransparency = 0;
            v176.GroupTransparency = 0.5;

            for i2, v2 in u39 do
                local v177 = u33.Center[i2];

                for i3, v3 in v2 do
                    v177[tostring(i3)].Icon.Image = `rbxassetid://{v3}`;
                end;
            end;

            for i2, _ in u19 do
                local Title = u34[i2][`{i2}_Misc`].Title;

                if i2 == u24[u27] then
                    Title.TextLabel.TextColor3 = Color3.new();
                    Title.ImageLabel.ImageColor3 = Color3.new();
                else
                    Title.TextLabel.TextColor3 = u26;
                    Title.ImageLabel.ImageColor3 = u26;
                end;

                Title.BackgroundColor3 = u26;
            end;

            RenderSlots();
            u1.UpdateWeaponSorting();
        end));
        u4:Add(`{u164}HitboxMouseEnter`, ImageButton.InputBegan:Connect(function(p178) -- Line: 1237
            -- upvalues: u47 (ref), u31 (ref), u30 (ref), ImageButton (copy), u160 (copy), TweenService (ref), TweenInfo_new_ret (ref)
            if p178.UserInputType ~= Enum.UserInputType.MouseMovement and p178.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            u47.Play("UI.mainmenu_rollover");

            if not u31 then
                return;
            end;

            u30 = ImageButton.Parent;

            if u160.Visible then
                TweenService:Create(u160, TweenInfo_new_ret, {
                    Transparency = 0.65
                }):Play();
            end;
        end));
        u4:Add(`{u164}HitboxMouseLeave`, ImageButton.InputEnded:Connect(function(p179) -- Line: 1259
            -- upvalues: u30 (ref), ImageButton (copy), TweenService (ref), u159 (copy), TweenInfo_new_ret (ref), u160 (copy)
            if p179.UserInputType ~= Enum.UserInputType.MouseMovement and p179.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            if u30 == ImageButton.Parent then
                task.wait();
                u30 = nil;
            end;

            TweenService:Create(u159, TweenInfo_new_ret, {
                BackgroundTransparency = 1
            }):Play();
            TweenService:Create(u160, TweenInfo_new_ret, {
                Transparency = 1
            }):Play();
        end));
    end;
end;

function u1.DrawSorting() -- Line: 1279
    -- upvalues: u1 (copy), u15 (ref), QueueSearch (copy), TweenService (copy), u7 (ref), TweenInfo_new_ret2 (copy), u13 (ref), u14 (ref), u28 (ref), u64 (ref), u63 (ref), u17 (copy), u41 (ref), u40 (copy), u27 (ref), u12 (ref), u29 (ref), u4 (ref), TweenInfo_new_ret (copy), u47 (ref), u31 (ref)
    local _, v180 = u1.dropUIRight();
    u1.dropUILeft();
    u15 = u1.searchUI();
    u15.TextBox:GetPropertyChangedSignal("Text"):Connect(QueueSearch);
    u15.TextBox.Focused:Connect(function() -- Line: 1287
        -- upvalues: TweenService (ref), u15 (ref)
        TweenService:Create(u15.Line, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundTransparency = 0.1
        }):Play();
    end);
    u15.TextBox.FocusLost:Connect(function() -- Line: 1291
        -- upvalues: TweenService (ref), u15 (ref)
        TweenService:Create(u15.Line, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundTransparency = 0.6
        }):Play();
    end);
    u7:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1295
        -- upvalues: u7 (ref), u15 (ref), TweenService (ref), TweenInfo_new_ret2 (ref)
        if not u7.Visible then
            return;
        end;

        u15.Line.Size = UDim2.new(0, 0, 0, 2);
        u15.Icon.ImageTransparency = 1;
        u15.TextBox.TextTransparency = 1;
        TweenService:Create(u15.Line, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, 2)
        }):Play();
        TweenService:Create(u15.Icon, TweenInfo_new_ret2, {
            ImageTransparency = 0
        }):Play();
        TweenService:Create(u15.TextBox, TweenInfo_new_ret2, {
            TextTransparency = 0
        }):Play();
    end);
    u13.Visible = false;
    u14.Visible = false;
    u28 = "Equipped";
    u64.NewDropDown(false, { "Newest", "Quality", "Alphabetical", "Type", "Equipped" }, "Equipped", "Equipped", function(p181) -- Line: 1313
        -- upvalues: u63 (ref), u17 (ref), u41 (ref), u40 (ref), u28 (ref)
        u63.Sort(u17, p181, u41, u40);
        u28 = p181;
    end, v180);
    u64.DropSetOption(v180, u28);
    u27 = "All Items";
    u64.NewDropDown(false, { "All Items", "Starting Pistol", "Other Pistols", "Mid-Tier", "Rifles", "Agents", "Gloves", "Melee" }, "All Items", "All Items", function(p182) -- Line: 1322
        -- upvalues: u27 (ref), u1 (ref)
        u27 = p182;
        u1.UpdateSorting();
    end, u12);
    u29 = "All";
    u64.NewDropDown(false, { "All" }, "All", "All", function(p183) -- Line: 1328
        -- upvalues: u29 (ref), u1 (ref)
        u29 = p183;
        u1.UpdateWeaponSorting();
    end, u13);
    u4:Add("Cancel_MouseEnter", u14.MouseEnter:Connect(function() -- Line: 1333
        -- upvalues: TweenService (ref), u14 (ref), TweenInfo_new_ret (ref), u47 (ref)
        TweenService:Create(u14, TweenInfo_new_ret, {
            BackgroundTransparency = 0.7
        }):Play();
        u47.Play("UI.mainmenu_rollover");
    end));
    u4:Add("Cancel_MouseLeave", u14.MouseLeave:Connect(function() -- Line: 1338
        -- upvalues: TweenService (ref), u14 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u14, TweenInfo_new_ret, {
            BackgroundTransparency = 0.8
        }):Play();
    end));
    u4:Add("Cancel_MouseButton1Click", u14.MouseButton1Click:Connect(function() -- Line: 1341
        -- upvalues: u31 (ref), u27 (ref), u1 (ref)
        if u31 then
            return;
        end;

        u27 = "All Items";
        u1.UpdateSorting();
    end));
    u1.UpdateSorting();
end;

function u1.UpdateSorting() -- Line: 1354
    -- upvalues: u12 (ref), u27 (ref), u19 (copy), u34 (ref), u24 (copy), TweenService (copy), u26 (ref), u1 (copy), u64 (ref), u13 (ref), u14 (ref), u46 (ref), u29 (ref)
    u12.AutoLeft.TextLabel.Text = u27;

    for i in u19 do
        local Title = u34[i][`{i}_Misc`].Title;

        if u27 == "All Items" or i ~= u24[u27] then
            Title.ImageLabel.Image = "rbxassetid://118345726873781";
            TweenService:Create(Title.TextLabel, TweenInfo.new(0.25), {
                TextColor3 = u26
            }):Play();
            TweenService:Create(Title.ImageLabel, TweenInfo.new(0.25), {
                ImageColor3 = u26
            }):Play();
            TweenService:Create(Title, TweenInfo.new(0.25), {
                Transparency = 1
            }):Play();
        else
            Title.ImageLabel.Image = "rbxassetid://113205381648147";
            TweenService:Create(Title.TextLabel, TweenInfo.new(0.25), {
                TextColor3 = Color3.new()
            }):Play();
            TweenService:Create(Title.ImageLabel, TweenInfo.new(0.25), {
                ImageColor3 = Color3.new()
            }):Play();
            TweenService:Create(Title, TweenInfo.new(0.25), {
                Transparency = 0
            }):Play();
        end;
    end;

    if u27 == "All Items" then
        u1.UpdateWeaponSorting();
        u64.DropCleanOptions(u13);
        u13.Visible = false;
        u14.Visible = false;

        return;
    end;

    u64.DropCleanOptions(u13);
    u64.DropAddOption(u13, "All");

    for i, v in u46.GetAllWeapons() do
        if v.GuiInformation.LoadoutCategory == u24[u27] then
            u64.DropAddOption(u13, i);
        end;
    end;

    u29 = "All";
    u1.UpdateWeaponSorting();
    u13.Visible = true;
    u14.Visible = true;
end;

function u1.UpdateWeaponSorting() -- Line: 1406
    -- upvalues: u13 (ref), u29 (ref), u40 (copy), SearchWords (copy), u15 (ref), u17 (copy), u45 (ref), u46 (ref), u44 (ref), u25 (ref), u27 (ref), u24 (copy), SearchMatch (copy), TweenService (copy), TweenInfo_new_ret2 (copy), u41 (ref), u52 (ref), u11 (ref), u63 (ref), u28 (ref)
    u13.AutoLeft.TextLabel.Text = u29;
    table.clear(u40);
    local v184 = SearchWords(u15.TextBox.Text);

    for _, v in u17 do
        for _, v2 in v do
            local Attribute = v2:GetAttribute("WeaponName");
            local Attribute2 = v2:GetAttribute("SkinName");
            local v185 = u45.GetCategory(Attribute) or u46.Get(Attribute);
            local v186 = u45.GetItem(Attribute, Attribute2) or u44.GetWeaponSkin(Attribute, Attribute2);
            v2.Parent = nil;

            if (v186.Sides and v186.Sides[u25] or not v186.Sides and v185.GuiInformation.Sides[u25]) and ((Attribute ~= "CT Agent" or u25 == "CT") and ((Attribute ~= "T Agent" or u25 == "T") and ((u27 == "All Items" or v185.GuiInformation.LoadoutCategory == u24[u27]) and not (u27 ~= "All Items" and (u29 ~= "All" and Attribute ~= u29) or #v184 > 0 and not SearchMatch(v2, v184))))) then
                table.insert(u40, v2);
            end;
        end;
    end;

    local Count = u15.Count;
    local v187 = #v184 == 0 and "" or (#u40 > 0 and (`{#u40} RESULT{#u40 == 1 and "" or "S"}` or "NO RESULTS") or "NO RESULTS");

    if Count.Text ~= v187 then
        Count.Text = v187;
        Count.TextTransparency = 0.7;
        TweenService:Create(Count, TweenInfo_new_ret2, {
            TextTransparency = 0
        }):Play();
    end;

    if u41 then
        u41:Destroy();
        u41 = nil;
    end;

    u41 = u52.new(u11, function(p188) -- Line: 1460
        -- upvalues: u40 (ref), u11 (ref)
        local v189 = (p188 - 1) * 20 + 1;
        local v190 = v189 + 20 - 1;

        for i = v189, math.min(v190, #u40) do
            local v191 = u40[i];
            local v192;

            if v191 then
                v191.Parent = u11;
                v192 = i;
            else
                v192 = i;
            end;
        end;

        return #u40 > v190;
    end);
    u63.Sort(u17, u28, u41, u40);
end;

function u1.CreateItem(p193: userdata, u194: string, u195: string, p196: string, p197: any, p198: number, u199: string) -- Line: 1485
    -- upvalues: u63 (ref), u45 (ref), u44 (ref), u46 (ref), HttpService (copy), u4 (ref), TweenService (copy), SetCharacterWeapon (copy), u25 (ref), u31 (ref), ItemClick (copy), u57 (copy), u56 (ref)
    local u200, v201 = u63.CreateItem(p193, u194, u195, p196, p197, p198, true);

    if u200 then
        local Icon = u200.Icon;
        local v202 = u45.GetItem(u194, u195) or u44.GetWeaponSkin(u194, u195);
        local u203 = u45.GetCategory(u194) or u46.Get(u194);
        local GuiInformation = u203.GuiInformation;
        local LoadoutCategory = GuiInformation.LoadoutCategory;
        local u204 = v202.Sides or GuiInformation.Sides;
        local u205 = u203.Data and (`${u203.Data.Price}` or "") or "";
        local u206 = `{HttpService:GenerateGUID()}{p196}`;
        u4:Add(`{u206}_MouseEnter`, Icon.MouseEnter:Connect(function() -- Line: 1509
            -- upvalues: TweenService (ref), Icon (copy), u194 (copy), SetCharacterWeapon (ref), u25 (ref), u195 (copy)
            TweenService:Create(Icon, TweenInfo.new(0.25), {
                Position = UDim2.new(0, 2, 0, -5)
            }):Play();

            if u194 then
                SetCharacterWeapon(u25, u194, u195);
            end;
        end));
        u4:Add(`{u206}_MouseLeave`, Icon.MouseLeave:Connect(function() -- Line: 1516
            -- upvalues: TweenService (ref), Icon (copy)
            TweenService:Create(Icon, TweenInfo.new(0.25), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play();
        end));

        u57[Icon] = function() -- Line: 1520, Name: Pick
            -- upvalues: u31 (ref), u204 (copy), u25 (ref), ItemClick (ref), u200 (copy), LoadoutCategory (copy), u203 (copy), u194 (copy), u205 (copy), u199 (copy)
            if u31 then
                return;
            end;

            if not u204[u25] then
                return;
            end;

            ItemClick(u200, LoadoutCategory, false, u203.DisplayName or u194, u205, u199);
        end;

        u4:Add(`{u206}_MouseMouseButton1Down`, Icon.MouseButton1Down:Connect(function() -- Line: 1534
            -- upvalues: u56 (ref), u31 (ref), u204 (copy), u25 (ref), ItemClick (ref), u200 (copy), LoadoutCategory (copy), u203 (copy), u194 (copy), u205 (copy), u199 (copy)
            if u56.Navigating() then
                return;
            end;

            if u31 then
                return;
            end;

            if not u204[u25] then
                return;
            end;

            ItemClick(u200, LoadoutCategory, false, u203.DisplayName or u194, u205, u199);
        end));

        function v201.Destroy2() -- Line: 1542
            -- upvalues: u57 (ref), Icon (copy), u4 (ref), u206 (copy)
            u57[Icon] = nil;
            u4:Removes(`{u206}_MouseEnter`, `{u206}_MouseLeave`, (`{u206}_MouseMouseButton1Down`));
        end;

        return u200, v201;
    end;
end;

function u1.UpdateBadge(p207) -- Line: 1550
    -- upvalues: u33 (ref), u5 (ref), u45 (ref)
    for _, v in { "CT", "T" } do
        local Badges = u33[`{v}_Character`].Equipment.Badges;

        if p207 == "None" then
            Badges.Rarity.BackgroundColor3 = u5.Stock;
            Badges.DefaultIcon.Image = "rbxassetid://93125581632960";
            Badges.DefaultIcon.Visible = true;
            Badges.Icon.Visible = false;
        else
            local Item = u45.GetItem("Badges", p207);
            Badges.Rarity.BackgroundColor3 = u5[Item.Rarity];
            Badges.Icon.Image = `rbxassetid://{Item.Thumbnail}`;
            Badges.DefaultIcon.Visible = false;
            Badges.Icon.Visible = true;
        end;
    end;
end;

function u1.ResetWeapon(p208, p209) -- Line: 1574
    -- upvalues: u19 (copy), u43 (ref), u6 (ref), u45 (ref), u44 (ref), u46 (ref), u5 (ref), u33 (ref), u22 (copy)
    for i, v in u19 do
        local v210 = i;

        for i2, v2 in v do
            if v2:GetAttribute("WeaponName") == p209 then
                local v211 = u43.LoadoutNum[`{v210}_{i2}`];
                local v212 = u6[p208][tostring(v211)];
                local WeaponName = v212.WeaponName;
                local SkinName = v212.SkinName;
                local v213 = u45.GetItem(WeaponName, SkinName) or u44.GetWeaponSkin(WeaponName, SkinName);
                local v214 = u45.GetCategory(WeaponName) or u46.Get(WeaponName);

                if v214 then
                    p209 = v214.DisplayName or p209;
                end;

                v2.Rarity.BackgroundColor3 = u5[v213 and (v213.Rarity or "Stock") or "Stock"];
                v2.Icon.Image = `rbxassetid://{v213.Thumbnail}`;
                v2.IconShadow.Image = `rbxassetid://{v213.Thumbnail}`;
                v2.WeaponName.Text = p209;

                if v214 and (v214.Data and v214.Data.Price) then
                    v2.Price.Text = `${v214.Data.Price}`;
                end;

                v2:SetAttribute("WeaponName", WeaponName);
                v2:SetAttribute("SkinName", SkinName);
                v2:SetAttribute("SkinId", v212.SkinId);

                return;
            end;
        end;
    end;

    local v215 = u33 and u33[`{p208}_Character`];

    if v215 and v215:FindFirstChild("Equipment") then
        local LoadoutCategory = (u45.GetCategory(p209) or u46.Get(p209)).GuiInformation.LoadoutCategory;
        local v216 = v215.Equipment:FindFirstChild(LoadoutCategory);

        if v216 then
            local v217 = u22[LoadoutCategory];

            if v217 then
                v216.Rarity.BackgroundColor3 = u5.Stock;
                v216.DefaultIcon.Image = `rbxassetid://{v217}`;
                v216.DefaultIcon.Visible = true;
                v216.Icon.Visible = false;

                return;
            end;

            local v218 = u43.LoadoutNum[`{LoadoutCategory}`];
            local v219 = u6[p208][tostring(v218)];
            local WeaponName = v219.WeaponName;
            local SkinName = v219.SkinName;
            local v220 = u45.GetItem(WeaponName, SkinName) or u44.GetWeaponSkin(WeaponName, SkinName);
            v216.Rarity.BackgroundColor3 = u5[v220 and (v220.Rarity or "Stock") or "Stock"];

            if v220 and v220.Thumbnail then
                v216.Icon.Image = `rbxassetid://{v220.Thumbnail}`;
            end;

            v216.DefaultIcon.Visible = false;
            v216.Icon.Visible = true;
        end;
    end;
end;

function u1.SetWeapon(p221: string, p222: number, p223: string, p224: string, p225: string) -- Line: 1644
    -- upvalues: u6 (ref), u43 (ref), u45 (ref), u44 (ref), u46 (ref), u25 (ref), u19 (copy), u5 (ref), u33 (ref), u22 (copy), u113 (copy), SetCharacterWeapon (copy)
    if u6 and u6[p221] then
        u6[p221][tostring(p222)] = {
            WeaponName = p223,
            SkinName = p224,
            SkinId = p225
        };
    end;

    local v226 = u43.Loadout[p222];

    if not v226 then
        return;
    end;

    local v227 = u45.GetItem(p223, p224) or u44.GetWeaponSkin(p223, p224);
    local v228 = u45.GetCategory(p223) or u46.Get(p223);

    if v226:find("_") then
        local v229, v230 = unpack(v226:split("_"));

        if u25 == p221 and (u19[v229] and u19[v229][v230]) then
            local v231 = u19[v229][v230];
            local v232;

            if v228 then
                v232 = v228.DisplayName or p223;
            else
                v232 = p223;
            end;

            v231.Rarity.BackgroundColor3 = u5[v227 and (v227.Rarity or "Stock") or "Stock"];
            v231.Icon.Image = `rbxassetid://{v227 and (v227.Thumbnail or 0) or 0}`;
            v231.IconShadow.Image = `rbxassetid://{v227 and v227.Thumbnail or 0}`;
            v231.WeaponName.Text = v232;

            if v228 and (v228.Data and v228.Data.Price) then
                v231.Price.Text = `${v228.Data.Price}`;
            end;

            v231:SetAttribute("WeaponName", p223);
            v231:SetAttribute("SkinName", p224);
            v231:SetAttribute("SkinId", p225);
        end;
    else
        local v233 = u33 and u33[`{p221}_Character`];

        if v233 then
            v233 = v233.Equipment:FindFirstChild(v226);
        end;

        if v233 then
            local v234 = u22[v226];

            if v234 and p224 == "None" then
                v233.Rarity.BackgroundColor3 = u5.Stock;
                v233.DefaultIcon.Image = `rbxassetid://{v234}`;
                v233.DefaultIcon.Visible = true;
                v233.Icon.Visible = false;
            else
                v233.Rarity.BackgroundColor3 = u5[v227 and (v227.Rarity or "Stock") or "Stock"];
                v233.Icon.Image = `rbxassetid://{v227 and v227.Thumbnail or 0}`;
                v233.DefaultIcon.Visible = false;
                v233.Icon.Visible = true;
            end;
        end;
    end;

    if u113[p221] and u113[p221].CurrentWeapon == p223 then
        SetCharacterWeapon(p221, p223, p224);
    end;
end;

function u1.GetLoadoutData() -- Line: 1703
    -- upvalues: u6 (ref), LocalPlayer (copy), HttpService (copy)
    local v235 = not u6 and LocalPlayer:GetAttribute("WeaponLoadout");

    if v235 then
        u6 = HttpService:JSONDecode(v235);
    end;

    return u6;
end;

function u1.IsHolding() -- Line: 1715
    -- upvalues: u31 (ref)
    return u31 ~= nil;
end;

function u1.GetSlots() -- Line: 1719
    -- upvalues: u19 (copy)
    return u19;
end;

function u1.Init(p236) -- Line: 1723
    -- upvalues: u2 (ref), u42 (ref), u3 (ref), u64 (ref), u4 (ref), u43 (ref), u5 (ref), u44 (ref), u45 (ref), u46 (ref), u63 (ref), u47 (ref), u48 (ref), u49 (ref), u50 (ref), u51 (ref), u52 (ref), u53 (ref), u54 (ref), u56 (ref), u55 (ref), u1 (copy)
    u2 = p236:GetModule("Gui");
    u42 = p236:GetModule("Network");
    u3 = u2.GetComponent("MainMenu");
    u64 = u2.GetComponent("Settings");
    u4 = p236:GetModule("Maid").new();
    u43 = p236:GetModule("Enums");
    u5 = p236:GetModule("RarityColors");
    u44 = p236:GetModule("SkinManager");
    u45 = p236:GetModule("ItemManager");
    u46 = p236:GetModule("WeaponManager");
    u63 = u2.GetComponent("Inventory");
    u47 = p236:GetModule("SoundManager");
    u48 = p236:GetModule("Table");
    u49 = p236:GetModule("Inspect");
    u50 = p236:GetModule("GetUserPlatform");
    u51 = u50() == "Mobile";
    u52 = p236:GetModule("VirtualScroller");
    u53 = p236:GetModule("CharacterModel");
    u54 = p236:GetModule("InventoryData");
    u56 = u2.GetComponent("Gamepad");
    u64:AddConnection("Game", "HUD & UI", "Item Stacking", function(p237) -- Line: 1745
        -- upvalues: u55 (ref), u1 (ref)
        u55 = p237;

        if u1.UpdateItems then
            u1.UpdateItems();
        end;
    end);
end;

function u1.Start(p238) -- Line: 1753
    -- upvalues: u7 (ref), u3 (ref), u62 (ref), u2 (ref), u1 (copy), u6 (ref), HttpService (copy), LocalPlayer (copy), u113 (copy), SetCharacterAgent (copy), SetCharacterGloves (copy), u58 (ref), u31 (ref), RenderSlots (copy), SetCharacterWeapon (copy), GetDefaultWeapon (copy), u56 (ref), u57 (copy), GuiService (copy)
    u7 = u3.AddTab("Loadout");
    u3.AddButton("Loadout", u7, UDim2.fromScale(0.075, 0.032), UDim2.fromScale(0.43976, 0.015));
    u62 = u2.GetComponent("Home");
    u1.new();
    u6 = HttpService:JSONDecode(LocalPlayer:GetAttribute("WeaponLoadout"));
    LocalPlayer:GetAttributeChangedSignal("WeaponLoadout"):Connect(function() -- Line: 1762
        -- upvalues: u6 (ref), HttpService (ref), LocalPlayer (ref), u113 (ref), SetCharacterAgent (ref), SetCharacterGloves (ref), u58 (ref), u31 (ref), RenderSlots (ref), u1 (ref), SetCharacterWeapon (ref), GetDefaultWeapon (ref)
        u6 = HttpService:JSONDecode(LocalPlayer:GetAttribute("WeaponLoadout"));

        for i in u113 do
            SetCharacterAgent(i);
            SetCharacterGloves(i);
        end;

        if u58 and not u31 then
            RenderSlots();

            for i, v in u6 do
                local v239 = i;
                local v240 = false;

                for i2, v2 in v do
                    u1.SetWeapon(v239, tonumber(i2), v2.WeaponName, v2.SkinName, v2.SkinId);
                    v240 = v240 or u113[v239].CurrentWeapon == v2.WeaponName;
                end;

                if not v240 then
                    SetCharacterWeapon(v239, GetDefaultWeapon(v239));
                end;
            end;
        end;
    end);
    u56.Action(Enum.KeyCode.ButtonX, function() -- Line: 1788
        -- upvalues: u57 (ref), GuiService (ref), u31 (ref), u7 (ref)
        local v241 = u57[GuiService.SelectedObject];

        if u31 or not (v241 and u7.Visible) then
            return false;
        end;

        v241();

        return true;
    end);
end;

function u1.Start2(p242) -- Line: 1801
    -- upvalues: u54 (ref), u55 (ref), u17 (copy), u18 (copy), u1 (copy), u11 (ref), u48 (ref), u7 (ref), u61 (ref), u2 (ref), PlayCharacters (copy), u58 (ref), u63 (ref), u28 (ref), u41 (ref), u40 (copy)
    MenuInventory = u54.Get();

    local function IsSpecialItem(p243) -- Line: 1804
        return p243.Stickers and next(p243.Stickers) and true or (p243.KillTrack and true or ((p243.EmissiveStrength or p243.EmissiveColor) and true or (p243.NameTag and p243.NameTag ~= "" and true or false)));
    end;

    local v244 = {};

    for i, v in MenuInventory.Equipment do
        local v245 = i;

        for i2, v2 in v do
            local v246 = i2;

            for i3, v3 in v2 do
                if u55 and not (v3.Stickers and next(v3.Stickers) or (v3.KillTrack or (v3.EmissiveStrength or v3.EmissiveColor)) or v3.NameTag and v3.NameTag ~= "" or (v3.EquippedCT or (v3.EquippedT or v3.TradeLocked))) then
                    local v247 = v245 .. "_" .. v246;

                    if v244[v247] then
                        local v248 = v244[v247];
                        v248.Amount = v248.Amount + 1;
                    else
                        v244[v247] = {
                            Amount = 1,
                            WeaponName = v245,
                            SkinName = v246,
                            SkinId = i3,
                            SkinInfo = v3
                        };
                    end;
                else
                    local Equipment = u17.Equipment;
                    local v249, v250 = u1.CreateItem(u11, v245, v246, i3, v3, 1, "Equipment");
                    Equipment[i3] = v249;
                    u18[i3] = v250;
                end;
            end;
        end;
    end;

    for i, v in v244 do
        local Equipment = u17.Equipment;
        local v251, v252 = u1.CreateItem(u11, v.WeaponName, v.SkinName, v.SkinId, v.SkinInfo, v.Amount, "Equipment");
        Equipment[i] = v251;
        u18[i] = v252;
    end;

    for i, v in MenuInventory["Graphic Art"] do
        if i == "Badges" or i == "Graffiti" then
            local v253 = i;

            for i2, v2 in v do
                if i2 ~= "None" then
                    local v254 = i2;
                    local v255 = 0;
                    local v256 = "";

                    for i3, _ in v2 do
                        v255 = v255 + 1;
                        v256 = i3;
                    end;

                    local v257 = u17["Graphic Art"];
                    local v258, v259 = u1.CreateItem(u11, v253, v254, v256, v2, v255, "Graphic Art");
                    v257[v254] = v258;
                    u18[v254] = v259;
                end;
            end;
        end;
    end;

    function u1.UpdateItems() -- Line: 1885
        -- upvalues: u54 (ref), u48 (ref), u17 (ref), u55 (ref), u18 (ref), u1 (ref), u11 (ref), u7 (ref), u61 (ref)
        MenuInventory = u54.Get();
        local v260 = u48.Copy(u17);
        local v261 = {};

        for i, v in MenuInventory.Equipment do
            local v262 = i;

            for i2, v2 in v do
                local v263 = i2;

                for i3, v3 in v2 do
                    if u55 and not (v3.Stickers and next(v3.Stickers) or (v3.KillTrack or (v3.EmissiveStrength or v3.EmissiveColor)) or v3.NameTag and v3.NameTag ~= "" or (v3.EquippedCT or (v3.EquippedT or v3.TradeLocked))) then
                        local v264 = v262 .. "_" .. v263;

                        if v261[v264] then
                            local v265 = v261[v264];
                            v265.Amount = v265.Amount + 1;
                        else
                            v261[v264] = {
                                Amount = 1,
                                WeaponName = v262,
                                SkinName = v263,
                                SkinId = i3,
                                SkinInfo = v3
                            };
                        end;
                    elseif u17.Equipment[i3] then
                        u18[i3].Update(v3.EquippedCT, v3.EquippedT, v3.Stickers, 1, v3.Date, v3.NameTag, v3.KillTrack);
                        v260.Equipment[i3] = nil;
                    else
                        local Equipment = u17.Equipment;
                        local v266, v267 = u1.CreateItem(u11, v262, v263, i3, v3, 1, "Equipment");
                        Equipment[i3] = v266;
                        u18[i3] = v267;
                    end;
                end;
            end;
        end;

        for i, v in v261 do
            if u17.Equipment[i] then
                u18[i].Update(v.SkinInfo.EquippedCT, v.SkinInfo.EquippedT, v.SkinInfo.Stickers, v.Amount, v.SkinInfo.Date, v.SkinInfo.NameTag, v.SkinInfo.KillTrack);
                v260.Equipment[i] = nil;
            else
                local Equipment = u17.Equipment;
                local v268, v269 = u1.CreateItem(u11, v.WeaponName, v.SkinName, v.SkinId, v.SkinInfo, v.Amount, "Equipment");
                Equipment[i] = v268;
                u18[i] = v269;
            end;
        end;

        for i, v in MenuInventory["Graphic Art"] do
            if i == "Badges" or i == "Graffiti" then
                local v270 = i;

                for i2, v2 in v do
                    if i2 ~= "None" then
                        local v271 = v2;
                        local v272 = i2;
                        local v273 = 0;
                        local v274 = "";

                        for i3, _ in v2 do
                            v273 = v273 + 1;
                            v274 = i3;
                        end;

                        if v273 > 0 then
                            v260["Graphic Art"][v272] = nil;
                            local v275 = u18[v272];

                            if v275 then
                                v275.Update(v271.EquippedCT, v271.EquippedT, nil, v273, nil);
                            else
                                local v276 = u17["Graphic Art"];
                                local v277, v278 = u1.CreateItem(u11, v270, v272, v274, v271, v273, "Graphic Art");
                                v276[v272] = v277;
                                u18[v272] = v278;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        for i, v in v260 do
            local v279 = i;

            for i2, _ in v do
                if u18[i2] then
                    u18[i2].Destroy2();
                    u18[i2].Destroy();
                    u18[i2] = nil;
                end;

                u17[v279][i2] = nil;
            end;
        end;

        if u7.Visible then
            u1.UpdateWeaponSorting();

            return;
        end;

        u61 = true;
    end;

    u54.Updated:Connect(u1.UpdateItems);
    u2.Handler.MainMenu:GetPropertyChangedSignal("Visible"):Connect(PlayCharacters);
    u7:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2011
        -- upvalues: PlayCharacters (ref), u7 (ref), u61 (ref), u1 (ref)
        PlayCharacters();

        if u7.Visible and u61 then
            u61 = false;
            u1.UpdateWeaponSorting();
        end;
    end);
    u1.Draw();
    u1.DrawSorting();
    u58 = true;
    u63.Sort(u17, u28, u41, u40);
end;

function u1.new() -- Line: 2030
    -- upvalues: u9 (ref), u10 (ref), u11 (ref), u7 (ref), u1 (copy)
    u9 = Instance.new("Frame");
    u10 = Instance.new("Frame");
    local Frame = Instance.new("Frame");
    Instance.new("Frame");
    Instance.new("UIPadding");
    Instance.new("UIListLayout");
    Instance.new("ImageLabel");
    Instance.new("TextButton");
    Instance.new("UIStroke");
    Instance.new("UICorner");
    Instance.new("TextLabel");
    Instance.new("ImageLabel");
    Instance.new("TextButton");
    Instance.new("UIStroke");
    Instance.new("UICorner");
    Instance.new("TextLabel");
    Instance.new("ImageLabel");
    Instance.new("ImageButton");
    Instance.new("ImageLabel");
    Instance.new("UICorner");
    Instance.new("Frame");
    Instance.new("UIPadding");
    Instance.new("UIListLayout");
    Instance.new("ImageLabel");
    Instance.new("TextButton");
    Instance.new("UIStroke");
    Instance.new("UICorner");
    Instance.new("TextLabel");
    Instance.new("ImageLabel");
    u11 = Instance.new("ScrollingFrame");
    local UIGridLayout = Instance.new("UIGridLayout");
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    local UIPadding = Instance.new("UIPadding");
    u9.Name = "LoadoutInventory";
    u9.Parent = u7;
    u9.AnchorPoint = Vector2.new(0, 1);
    u9.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    u9.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u9.BorderSizePixel = 0;
    u9.Position = UDim2.new(0, 0, 1, 0);
    u9.Size = UDim2.new(1, 0, 0.349999994, 0);
    u10.Name = "Top";
    u10.Parent = u9;
    u10.AnchorPoint = Vector2.new(0, 1);
    u10.BackgroundColor3 = Color3.fromRGB(40, 40, 48);
    u10.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u10.BorderSizePixel = 0;
    u10.Position = UDim2.new(-1.27289169e-7, 0, 0.162593111, 0);
    u10.Size = UDim2.new(1.00000012, 0, 0.165000007, 0);
    Frame.Name = "Line";
    Frame.Parent = u10;
    Frame.AnchorPoint = Vector2.new(0, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(160, 160, 163);
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.new(-1.36239166e-7, 0, 0, 0);
    Frame.Size = UDim2.new(1, 0, 0, 2);
    Frame.ZIndex = 5;
    u11.Name = "LoadoutInventoryList";
    u11.Parent = u9;
    u11.Active = true;
    u11.AnchorPoint = Vector2.new(0.5, 0);
    u11.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    u11.BackgroundTransparency = 1;
    u11.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u11.BorderSizePixel = 0;
    u11.Position = UDim2.new(0.5, 0, 0.165000007, 0);
    u11.Size = UDim2.new(0.99000001, 0, 0.834999979, 0);
    u11.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    u11.ScrollBarThickness = 8;
    u11.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    u11.CanvasSize = UDim2.new(0, 0, 0, 0);
    u11.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    u11.ScrollingDirection = Enum.ScrollingDirection.Y;
    UIGridLayout.Name = "UIGridLayout55";
    UIGridLayout.Parent = u11;
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.CellPadding = UDim2.new(0.0199999996, 0, 0.200000003, 0);
    UIGridLayout.CellSize = UDim2.new(0.119999997, 0, 0.449999988, 0);
    UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 2116
        -- upvalues: u11 (ref), UIGridLayout (copy)
        u11.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 100);
    end);
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint55";
    UIAspectRatioConstraint.Parent = UIGridLayout;
    UIAspectRatioConstraint.AspectRatio = 1.425;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIPadding.Name = "UIPadding55";
    UIPadding.Parent = u11;
    UIPadding.PaddingBottom = UDim.new(0.00999999978, 100);
    UIPadding.PaddingLeft = UDim.new(0.0500000007, 0);
    UIPadding.PaddingRight = UDim.new(0.119999997, 0);
    UIPadding.PaddingTop = UDim.new(0.00999999978, 0);
    u1.topLoad();
end;

function u1.topLoad() -- Line: 2135
    -- upvalues: u32 (ref), u7 (ref), u8 (ref), u33 (ref), u35 (copy), u1 (copy), u34 (ref)
    u32 = Instance.new("Frame");
    u32.Name = "TopLoad";
    u32.BackgroundTransparency = 1;
    u32.Size = UDim2.fromScale(1, 0.65);
    u32.Parent = u7;
    u8 = Instance.new("Folder");
    u8.Name = "Teams";
    local Frame = Instance.new("Frame");
    Frame.Name = "T";
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.BackgroundColor3 = Color3.fromRGB(229, 204, 104);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(1, 0);
    Frame.Size = UDim2.fromScale(0.705, 1);
    Frame.Visible = true;
    Frame.Transparency = 1;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "T_UIGradient";
    UIGradient.Rotation = 180;
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.5) });
    UIGradient.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "T_Line";
    Frame2.BackgroundColor3 = Color3.fromRGB(229, 204, 104);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.fromScale(0.003, 1);
    Frame2.AnchorPoint = Vector2.new(1, 0);
    Frame2.Parent = Frame;
    Frame2.Transparency = 1;
    Frame.Parent = u8;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "CT";
    Frame3.BackgroundColor3 = Color3.fromRGB(44, 113, 176);
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Size = UDim2.fromScale(0.705, 1);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "CT_UIGradient";
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.5) });
    UIGradient2.Parent = Frame3;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "CT_Line";
    Frame4.AnchorPoint = Vector2.new(0, 0);
    Frame4.BackgroundColor3 = Color3.fromRGB(44, 113, 176);
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(1, 0);
    Frame4.Size = UDim2.fromScale(0.003, 1);
    Frame4.Parent = Frame3;
    Frame3.Parent = u8;
    u8.Parent = u32;
    u33 = Instance.new("Frame");
    u33.Name = "MainTopLoadout";
    u33.AnchorPoint = Vector2.new(0.5, 0);
    u33.BackgroundTransparency = 1;
    u33.Position = UDim2.fromScale(0.5, 0);
    u33.Size = UDim2.fromScale(0.4, 1);
    u33.ZIndex = 5;
    u33.Parent = u32;
    u35.CT = u1.canvasGroupTeam("CT", UDim2.fromScale(-0.00841844, 0.00360192));
    u35.T = u1.canvasGroupTeam("T", UDim2.fromScale(1.008, 0.00360192));
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.15;
    UIAspectRatioConstraint.Parent = u33;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "T_Character";
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.GroupTransparency = 0.5;
    CanvasGroup.Position = UDim2.fromScale(1.05, 0);
    CanvasGroup.Size = UDim2.fromScale(0.5, 1);
    local ViewportFrame = Instance.new("ViewportFrame");
    ViewportFrame.Name = "Character";
    ViewportFrame.Ambient = Color3.fromRGB(213, 213, 213);
    ViewportFrame.LightColor = Color3.new(1, 1, 1);
    ViewportFrame.LightDirection = Vector3.new(1, 0, 1);
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    ViewportFrame.BackgroundTransparency = 1;
    ViewportFrame.Position = UDim2.fromScale(0.4, 0.5);
    ViewportFrame.Size = UDim2.fromScale(0.8, 0.704768);
    ViewportFrame.ZIndex = 4;
    ViewportFrame.Parent = CanvasGroup;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Equipment";
    Frame5.AnchorPoint = Vector2.new(1, 0.5);
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(1, 0.5);
    Frame5.Size = UDim2.fromScale(0.18, 1);
    Frame5.ZIndex = 2;
    Frame5.LayoutOrder = 1;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "T_UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame5;
    Frame5.Parent = CanvasGroup;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Equip";
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.BackgroundColor3 = Color3.fromRGB(255, 203, 107);
    TextButton.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Italic);
    TextButton.Position = UDim2.fromScale(0.4, 0.15);
    TextButton.Size = UDim2.fromScale(0.25, 0.055);
    TextButton.TextColor3 = Color3.new();
    TextButton.TextScaled = true;
    TextButton.TextTransparency = 1;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = TextButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.fromRGB(255, 203, 107);
    UIStroke.Thickness = 2.5;
    UIStroke.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Italic);
    TextLabel.Position = UDim2.new(0.5, -2, 0.5, 0);
    TextLabel.Size = UDim2.fromScale(1, 0.75);
    TextLabel.Text = "EQUIP T";
    TextLabel.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel.TextScaled = true;
    TextLabel.Parent = TextButton;
    TextButton.Parent = CanvasGroup;
    CanvasGroup.Parent = u33;
    local CanvasGroup2 = Instance.new("CanvasGroup");
    CanvasGroup2.Name = "CT_Character";
    CanvasGroup2.AnchorPoint = Vector2.new(1, 0);
    CanvasGroup2.BackgroundTransparency = 1;
    CanvasGroup2.Position = UDim2.fromScale(-0.05, 0);
    CanvasGroup2.Size = UDim2.fromScale(0.5, 1);
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Equipment";
    Frame6.AnchorPoint = Vector2.new(0, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.Position = UDim2.fromScale(0, 0.5);
    Frame6.Size = UDim2.fromScale(0.18, 1);
    Frame6.ZIndex = 2;
    Frame6.LayoutOrder = 1;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "CT_UIListLayout";
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout2.Parent = Frame6;
    Frame6.Parent = CanvasGroup2;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Equip";
    TextButton2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundColor3 = Color3.fromRGB(151, 201, 250);
    TextButton2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Italic);
    TextButton2.Position = UDim2.fromScale(0.6, 0.15);
    TextButton2.Size = UDim2.fromScale(0.25, 0.055);
    TextButton2.Text = "EQUIP CT";
    TextButton2.TextColor3 = Color3.new();
    TextButton2.TextScaled = true;
    TextButton2.TextTransparency = 1;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = TextButton2;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.fromRGB(151, 201, 250);
    UIStroke2.Thickness = 2.5;
    UIStroke2.Parent = TextButton2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "TextLabel";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Italic);
    TextLabel2.Position = UDim2.new(0.5, -2, 0.5, 0);
    TextLabel2.Size = UDim2.fromScale(1, 0.75);
    TextLabel2.Text = "EQUIP CT";
    TextLabel2.TextColor3 = Color3.new();
    TextLabel2.TextScaled = true;
    TextLabel2.Parent = TextButton2;
    TextButton2.Parent = CanvasGroup2;
    local ViewportFrame2 = Instance.new("ViewportFrame");
    ViewportFrame2.Name = "Character";
    ViewportFrame2.Ambient = Color3.fromRGB(213, 213, 213);
    ViewportFrame2.LightColor = Color3.new(1, 1, 1);
    ViewportFrame2.LightDirection = Vector3.new(1, 0, 1);
    ViewportFrame2.AnchorPoint = Vector2.new(0.5, 0.5);
    ViewportFrame2.BackgroundTransparency = 1;
    ViewportFrame2.Position = UDim2.fromScale(0.6, 0.5);
    ViewportFrame2.Size = UDim2.fromScale(0.8, 0.704768);
    ViewportFrame2.ZIndex = 4;
    ViewportFrame2.Parent = CanvasGroup2;
    CanvasGroup2.Parent = u33;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Center";
    Frame7.AnchorPoint = Vector2.new(0.5, 1);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.5, 0.975);
    Frame7.Size = UDim2.fromScale(1, 0.925);
    Frame7.Parent = u33;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Equipment";
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0, 0.04);
    Frame8.Size = UDim2.fromScale(0.098, 0.96);
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "1";
    Frame9.AnchorPoint = Vector2.new(0.5, 0);
    Frame9.BackgroundColor3 = Color3.new();
    Frame9.BackgroundTransparency = 0.9;
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.Position = UDim2.fromScale(0.499999, 0);
    Frame9.Size = UDim2.fromScale(1, 0.24);
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Icon";
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://100429874437897";
    ImageButton.ImageColor3 = Color3.new();
    ImageButton.ImageTransparency = 0.8;
    ImageButton.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(1, 0.6);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageButton.Parent = Frame9;
    Frame9.Parent = Frame8;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "2";
    Frame10.AnchorPoint = Vector2.new(0.5, 0);
    Frame10.BackgroundColor3 = Color3.new();
    Frame10.BackgroundTransparency = 0.9;
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.fromScale(0.5, 0.25);
    Frame10.Size = UDim2.fromScale(1, 0.24);
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Icon";
    ImageButton2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://100429874437897";
    ImageButton2.ImageColor3 = Color3.new();
    ImageButton2.ImageTransparency = 0.8;
    ImageButton2.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton2.ScaleType = Enum.ScaleType.Fit;
    ImageButton2.Size = UDim2.fromScale(1, 0.6);
    ImageButton2.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageButton2.Parent = Frame10;
    Frame10.Parent = Frame8;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "3";
    Frame11.AnchorPoint = Vector2.new(0.5, 0);
    Frame11.BackgroundColor3 = Color3.new();
    Frame11.BackgroundTransparency = 0.9;
    Frame11.BorderColor3 = Color3.new();
    Frame11.BorderSizePixel = 0;
    Frame11.Position = UDim2.fromScale(0.5, 0.5);
    Frame11.Size = UDim2.fromScale(1, 0.24);
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "Icon";
    ImageButton3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton3.AutoButtonColor = false;
    ImageButton3.BackgroundTransparency = 1;
    ImageButton3.Image = "rbxassetid://100429874437897";
    ImageButton3.ImageColor3 = Color3.new();
    ImageButton3.ImageTransparency = 0.8;
    ImageButton3.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton3.ScaleType = Enum.ScaleType.Fit;
    ImageButton3.Size = UDim2.fromScale(1, 0.6);
    ImageButton3.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageButton3.Parent = Frame11;
    Frame11.Parent = Frame8;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "4";
    Frame12.AnchorPoint = Vector2.new(0.5, 0);
    Frame12.BackgroundColor3 = Color3.new();
    Frame12.BackgroundTransparency = 0.9;
    Frame12.BorderColor3 = Color3.new();
    Frame12.BorderSizePixel = 0;
    Frame12.Position = UDim2.fromScale(0.5, 0.75);
    Frame12.Size = UDim2.fromScale(1, 0.24);
    local ImageButton4 = Instance.new("ImageButton");
    ImageButton4.Name = "Icon";
    ImageButton4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton4.AutoButtonColor = false;
    ImageButton4.BackgroundTransparency = 1;
    ImageButton4.Image = "rbxassetid://100429874437897";
    ImageButton4.ImageColor3 = Color3.new();
    ImageButton4.ImageTransparency = 0.8;
    ImageButton4.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton4.ScaleType = Enum.ScaleType.Fit;
    ImageButton4.Size = UDim2.fromScale(1, 0.6);
    ImageButton4.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageButton4.Parent = Frame12;
    Frame12.Parent = Frame8;
    local UIListLayout3 = Instance.new("UIListLayout");
    UIListLayout3.Name = "UIListLayout";
    UIListLayout3.Padding = UDim.new(0.01, 0);
    UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout3.Parent = Frame8;
    Frame8.Parent = Frame7;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Grenades";
    Frame13.AnchorPoint = Vector2.new(1, 0);
    Frame13.BackgroundTransparency = 1;
    Frame13.Position = UDim2.fromScale(1, 0.04);
    Frame13.Size = UDim2.fromScale(0.098, 0.96);
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "1";
    Frame14.AnchorPoint = Vector2.new(0.5, 0);
    Frame14.BackgroundColor3 = Color3.new();
    Frame14.BackgroundTransparency = 0.9;
    Frame14.BorderColor3 = Color3.new();
    Frame14.BorderSizePixel = 0;
    Frame14.Position = UDim2.fromScale(0.499999, 0);
    Frame14.Size = UDim2.fromScale(1, 0.19);
    local ImageButton5 = Instance.new("ImageButton");
    ImageButton5.Name = "Icon";
    ImageButton5.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton5.AutoButtonColor = false;
    ImageButton5.BackgroundTransparency = 1;
    ImageButton5.Image = "rbxassetid://100429874437897";
    ImageButton5.ImageColor3 = Color3.new();
    ImageButton5.ImageTransparency = 0.8;
    ImageButton5.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton5.ScaleType = Enum.ScaleType.Fit;
    ImageButton5.Size = UDim2.fromScale(1, 0.6);
    ImageButton5.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageButton5.Parent = Frame14;
    Frame14.Parent = Frame13;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "2";
    Frame15.AnchorPoint = Vector2.new(0.5, 0);
    Frame15.BackgroundColor3 = Color3.new();
    Frame15.BackgroundTransparency = 0.9;
    Frame15.BorderColor3 = Color3.new();
    Frame15.BorderSizePixel = 0;
    Frame15.Position = UDim2.fromScale(0.5, 0.2);
    Frame15.Size = UDim2.fromScale(1, 0.19);
    local ImageButton6 = Instance.new("ImageButton");
    ImageButton6.Name = "Icon";
    ImageButton6.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton6.AutoButtonColor = false;
    ImageButton6.BackgroundTransparency = 1;
    ImageButton6.Image = "rbxassetid://100429874437897";
    ImageButton6.ImageColor3 = Color3.new();
    ImageButton6.ImageTransparency = 0.8;
    ImageButton6.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton6.ScaleType = Enum.ScaleType.Fit;
    ImageButton6.Size = UDim2.fromScale(1, 0.6);
    ImageButton6.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageButton6.Parent = Frame15;
    Frame15.Parent = Frame13;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "3";
    Frame16.AnchorPoint = Vector2.new(0.5, 0);
    Frame16.BackgroundColor3 = Color3.new();
    Frame16.BackgroundTransparency = 0.9;
    Frame16.BorderColor3 = Color3.new();
    Frame16.BorderSizePixel = 0;
    Frame16.Position = UDim2.fromScale(0.5, 0.4);
    Frame16.Size = UDim2.fromScale(1, 0.19);
    local ImageButton7 = Instance.new("ImageButton");
    ImageButton7.Name = "Icon";
    ImageButton7.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton7.AutoButtonColor = false;
    ImageButton7.BackgroundTransparency = 1;
    ImageButton7.Image = "rbxassetid://100429874437897";
    ImageButton7.ImageColor3 = Color3.new();
    ImageButton7.ImageTransparency = 0.8;
    ImageButton7.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton7.ScaleType = Enum.ScaleType.Fit;
    ImageButton7.Size = UDim2.fromScale(1, 0.6);
    ImageButton7.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageButton7.Parent = Frame16;
    Frame16.Parent = Frame13;
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "4";
    Frame17.AnchorPoint = Vector2.new(0.5, 0);
    Frame17.BackgroundColor3 = Color3.new();
    Frame17.BackgroundTransparency = 0.9;
    Frame17.BorderColor3 = Color3.new();
    Frame17.BorderSizePixel = 0;
    Frame17.Position = UDim2.fromScale(0.5, 0.6);
    Frame17.Size = UDim2.fromScale(1, 0.19);
    local ImageButton8 = Instance.new("ImageButton");
    ImageButton8.Name = "Icon";
    ImageButton8.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton8.AutoButtonColor = false;
    ImageButton8.BackgroundTransparency = 1;
    ImageButton8.Image = "rbxassetid://100429874437897";
    ImageButton8.ImageColor3 = Color3.new();
    ImageButton8.ImageTransparency = 0.8;
    ImageButton8.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton8.ScaleType = Enum.ScaleType.Fit;
    ImageButton8.Size = UDim2.fromScale(1, 0.6);
    ImageButton8.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageButton8.Parent = Frame17;
    Frame17.Parent = Frame13;
    local Frame18 = Instance.new("Frame");
    Frame18.Name = "5";
    Frame18.AnchorPoint = Vector2.new(0.5, 0);
    Frame18.BackgroundColor3 = Color3.new();
    Frame18.BackgroundTransparency = 0.9;
    Frame18.BorderColor3 = Color3.new();
    Frame18.BorderSizePixel = 0;
    Frame18.Position = UDim2.fromScale(0.5, 0.8);
    Frame18.Size = UDim2.fromScale(1, 0.19);
    local ImageButton9 = Instance.new("ImageButton");
    ImageButton9.Name = "Icon";
    ImageButton9.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton9.AutoButtonColor = false;
    ImageButton9.BackgroundTransparency = 1;
    ImageButton9.Image = "rbxassetid://100429874437897";
    ImageButton9.ImageColor3 = Color3.new();
    ImageButton9.ImageTransparency = 0.8;
    ImageButton9.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton9.ScaleType = Enum.ScaleType.Fit;
    ImageButton9.Size = UDim2.fromScale(1, 0.6);
    ImageButton9.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageButton9.Parent = Frame18;
    Frame18.Parent = Frame13;
    local UIListLayout4 = Instance.new("UIListLayout");
    UIListLayout4.Name = "UIListLayout";
    UIListLayout4.Padding = UDim.new(0.01, 0);
    UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout4.Parent = Frame13;
    Frame13.Parent = Frame7;
    u34 = Instance.new("Frame");
    u34.Name = "CenterMainLoadout";
    u34.AnchorPoint = Vector2.new(0.5, 1);
    u34.BackgroundTransparency = 1;
    u34.Position = UDim2.fromScale(0.5, 1);
    u34.Size = UDim2.fromScale(0.78, 0.96);
    local ImageButton10 = Instance.new("ImageButton");
    ImageButton10.ImageTransparency = 1;
    ImageButton10.Name = "MidTier";
    ImageButton10.AnchorPoint = Vector2.new(0.5, 0);
    ImageButton10.BackgroundTransparency = 1;
    ImageButton10.Position = UDim2.fromScale(0.5, 0);
    ImageButton10.Size = UDim2.fromScale(0.31, 1);
    local UIListLayout5 = Instance.new("UIListLayout");
    UIListLayout5.Name = "MidTier_UIListLayout";
    UIListLayout5.Padding = UDim.new(0.01, 0);
    UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout5.Parent = ImageButton10;
    local Folder = Instance.new("Folder");
    Folder.Name = "MidTier_Misc";
    local TextButton3 = Instance.new("TextButton");
    TextButton3.TextTransparency = 1;
    TextButton3.Name = "Title";
    TextButton3.AnchorPoint = Vector2.new(0, 1);
    TextButton3.BackgroundTransparency = 1;
    TextButton3.Position = UDim2.fromScale(0, -3.28578e-9);
    TextButton3.Size = UDim2.fromScale(1, 0.04);
    TextButton3.BackgroundColor3 = Color3.fromRGB(181, 206, 232);
    TextButton3.TextTransparency = 1;
    TextButton3.BorderSizePixel = 0;
    TextButton3.Text = "";
    TextButton3.AutoButtonColor = false;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "TextLabel";
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Light, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.15, 0);
    TextLabel3.Size = UDim2.fromScale(0.8, 1);
    TextLabel3.Text = "MID-TIER";
    TextLabel3.TextColor3 = Color3.fromRGB(181, 206, 232);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.ZIndex = 343;
    TextLabel3.Parent = TextButton3;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://118345726873781";
    ImageLabel.ImageColor3 = Color3.fromRGB(181, 206, 232);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = TextButton3;
    TextButton3.Parent = Folder;
    Folder.Parent = ImageButton10;
    ImageButton10.Parent = u34;
    local ImageButton11 = Instance.new("ImageButton");
    ImageButton11.ImageTransparency = 1;
    ImageButton11.Name = "StartingPistol";
    ImageButton11.BackgroundTransparency = 1;
    ImageButton11.Position = UDim2.fromScale(0, -1.30062e-8);
    ImageButton11.Size = UDim2.fromScale(0.31, 0.2);
    local Folder2 = Instance.new("Folder");
    Folder2.Name = "StartingPistol_Misc";
    local TextButton4 = Instance.new("TextButton");
    TextButton4.TextTransparency = 1;
    TextButton4.Name = "Title";
    TextButton4.BackgroundTransparency = 1;
    TextButton4.AnchorPoint = Vector2.new(0, 1);
    TextButton4.BackgroundColor3 = Color3.fromRGB(181, 206, 232);
    TextButton4.BorderColor3 = Color3.new();
    TextButton4.BorderSizePixel = 0;
    TextButton4.Position = UDim2.fromScale(0, -4.87732e-8);
    TextButton4.Size = UDim2.fromScale(1, 0.2);
    TextButton4.BackgroundColor3 = Color3.fromRGB(181, 206, 232);
    TextButton4.TextTransparency = 1;
    TextButton4.BorderSizePixel = 0;
    TextButton4.Text = "";
    TextButton4.AutoButtonColor = false;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "TextLabel";
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Light, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.15, 0);
    TextLabel4.Size = UDim2.fromScale(0.8, 1);
    TextLabel4.Text = "STARTING PISTOL";
    TextLabel4.TextColor3 = Color3.fromRGB(181, 206, 232);
    TextLabel4.TextScaled = true;
    TextLabel4.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 343;
    TextLabel4.Parent = TextButton4;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "ImageLabel";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://118345726873781";
    ImageLabel2.ImageColor3 = Color3.fromRGB(181, 206, 232);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = TextButton4;
    TextButton4.Parent = Folder2;
    Folder2.Parent = ImageButton11;
    ImageButton11.Parent = u34;
    local ImageButton12 = Instance.new("ImageButton");
    ImageButton12.ImageTransparency = 1;
    ImageButton12.Name = "Rifles";
    ImageButton12.AnchorPoint = Vector2.new(1, 0);
    ImageButton12.BackgroundTransparency = 1;
    ImageButton12.Position = UDim2.fromScale(1, 0);
    ImageButton12.Size = UDim2.fromScale(0.31, 1);
    local Folder3 = Instance.new("Folder");
    Folder3.Name = "Rifles_Misc";
    local TextButton5 = Instance.new("TextButton");
    TextButton5.TextTransparency = 1;
    TextButton5.Name = "Title";
    TextButton5.AnchorPoint = Vector2.new(0, 1);
    TextButton5.BackgroundTransparency = 1;
    TextButton5.Position = UDim2.fromScale(0, -3.28578e-9);
    TextButton5.Size = UDim2.fromScale(1, 0.04);
    TextButton5.BackgroundColor3 = Color3.fromRGB(181, 206, 232);
    TextButton5.TextTransparency = 1;
    TextButton5.BorderSizePixel = 0;
    TextButton5.Text = "";
    TextButton5.AutoButtonColor = false;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "TextLabel";
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Light, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.15, 0);
    TextLabel5.Size = UDim2.fromScale(0.8, 1);
    TextLabel5.Text = "RIFLES";
    TextLabel5.TextColor3 = Color3.fromRGB(181, 206, 232);
    TextLabel5.TextScaled = true;
    TextLabel5.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.ZIndex = 343;
    TextLabel5.Parent = TextButton5;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "ImageLabel";
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://113205381648147";
    ImageLabel3.ImageColor3 = Color3.fromRGB(181, 206, 232);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(1, 1);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = TextButton5;
    TextButton5.Parent = Folder3;
    Folder3.Parent = ImageButton12;
    local UIListLayout6 = Instance.new("UIListLayout");
    UIListLayout6.Name = "Rifles_UIListLayout";
    UIListLayout6.Padding = UDim.new(0.01, 0);
    UIListLayout6.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout6.Parent = ImageButton12;
    ImageButton12.Parent = u34;
    local ImageButton13 = Instance.new("ImageButton");
    ImageButton13.ImageTransparency = 1;
    ImageButton13.Name = "OtherPistols";
    ImageButton13.BackgroundTransparency = 1;
    ImageButton13.Position = UDim2.fromScale(-1.02449e-7, 0.25);
    ImageButton13.Size = UDim2.fromScale(0.31, 0.75);
    local Folder4 = Instance.new("Folder");
    Folder4.Name = "OtherPistols_Misc";
    local TextButton6 = Instance.new("TextButton");
    TextButton6.TextTransparency = 1;
    TextButton6.Name = "Title";
    TextButton6.AnchorPoint = Vector2.new(0, 1);
    TextButton6.BackgroundTransparency = 1;
    TextButton6.Position = UDim2.fromScale(0, -5.24131e-8);
    TextButton6.Size = UDim2.fromScale(1, 0.05);
    TextButton6.BackgroundColor3 = Color3.fromRGB(181, 206, 232);
    TextButton6.TextTransparency = 1;
    TextButton6.Text = "";
    TextButton6.BorderSizePixel = 0;
    TextButton6.Text = "";
    TextButton6.AutoButtonColor = false;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "TextLabel";
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Light, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.15, 0);
    TextLabel6.Size = UDim2.fromScale(0.8, 1);
    TextLabel6.Text = "OTHER PISTOLS";
    TextLabel6.TextColor3 = Color3.fromRGB(181, 206, 232);
    TextLabel6.TextScaled = true;
    TextLabel6.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel6.ZIndex = 343;
    TextLabel6.Parent = TextButton6;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "ImageLabel";
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://118345726873781";
    ImageLabel4.ImageColor3 = Color3.fromRGB(181, 206, 232);
    ImageLabel4.ScaleType = Enum.ScaleType.Fit;
    ImageLabel4.Size = UDim2.fromScale(1, 1);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = TextButton6;
    TextButton6.Parent = Folder4;
    Folder4.Parent = ImageButton13;
    local UIListLayout7 = Instance.new("UIListLayout");
    UIListLayout7.Name = "OtherPistols_UIListLayout";
    UIListLayout7.Padding = UDim.new(0.013, 0);
    UIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout7.Parent = ImageButton13;
    ImageButton13.Parent = u34;
    u34.Parent = Frame7;
end;

function u1.canvasGroupTeam(p280, p281) -- Line: 2931
    -- upvalues: u16 (copy), u33 (ref)
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "CanvasGroup";
    CanvasGroup.AnchorPoint = Vector2.new(p280 == "CT" and 1 or 0, 0);
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.GroupColor3 = u16[p280];
    CanvasGroup.Position = p281;
    CanvasGroup.Size = UDim2.fromScale(0.541582, 0.979964);
    CanvasGroup.Parent = u33;
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.AnchorPoint = Vector2.new(0, 0.055555556);
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0, 0.0555556);
    Frame2.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame2.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0, 0.111111112);
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0, 0.111111);
    Frame3.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame3.Parent = CanvasGroup;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Frame";
    Frame4.AnchorPoint = Vector2.new(0, 0.166666672);
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0, 0.166667);
    Frame4.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame4.Parent = CanvasGroup;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Frame";
    Frame5.AnchorPoint = Vector2.new(0, 0.222222224);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.fromScale(0, 0.222222);
    Frame5.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame5.Parent = CanvasGroup;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Frame";
    Frame6.AnchorPoint = Vector2.new(0, 0.277777791);
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame6.BorderColor3 = Color3.new();
    Frame6.BorderSizePixel = 0;
    Frame6.Position = UDim2.fromScale(0, 0.277778);
    Frame6.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame6.Parent = CanvasGroup;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Frame";
    Frame7.AnchorPoint = Vector2.new(0, 0.333333343);
    Frame7.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame7.BorderColor3 = Color3.new();
    Frame7.BorderSizePixel = 0;
    Frame7.Position = UDim2.fromScale(0, 0.333333);
    Frame7.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame7.Parent = CanvasGroup;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Frame";
    Frame8.AnchorPoint = Vector2.new(0, 0.388888896);
    Frame8.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Position = UDim2.fromScale(0, 0.388889);
    Frame8.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame8.Parent = CanvasGroup;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Frame";
    Frame9.AnchorPoint = Vector2.new(0, 0.444444448);
    Frame9.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.Position = UDim2.fromScale(0, 0.444444);
    Frame9.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame9.Parent = CanvasGroup;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Frame";
    Frame10.AnchorPoint = Vector2.new(0, 0.5);
    Frame10.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.fromScale(0, 0.5);
    Frame10.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame10.Parent = CanvasGroup;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Frame";
    Frame11.AnchorPoint = Vector2.new(0, 0.555555582);
    Frame11.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame11.BorderColor3 = Color3.new();
    Frame11.BorderSizePixel = 0;
    Frame11.Position = UDim2.fromScale(0, 0.555556);
    Frame11.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame11.Parent = CanvasGroup;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Frame";
    Frame12.AnchorPoint = Vector2.new(0, 0.611111104);
    Frame12.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame12.BorderColor3 = Color3.new();
    Frame12.BorderSizePixel = 0;
    Frame12.Position = UDim2.fromScale(0, 0.611111);
    Frame12.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame12.Parent = CanvasGroup;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Frame";
    Frame13.AnchorPoint = Vector2.new(0, 0.666666687);
    Frame13.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame13.BorderColor3 = Color3.new();
    Frame13.BorderSizePixel = 0;
    Frame13.Position = UDim2.fromScale(0, 0.666667);
    Frame13.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame13.Parent = CanvasGroup;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "Frame";
    Frame14.AnchorPoint = Vector2.new(0, 0.722222209);
    Frame14.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame14.BorderColor3 = Color3.new();
    Frame14.BorderSizePixel = 0;
    Frame14.Position = UDim2.fromScale(0, 0.722222);
    Frame14.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame14.Parent = CanvasGroup;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Frame";
    Frame15.AnchorPoint = Vector2.new(0, 0.777777791);
    Frame15.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame15.BorderColor3 = Color3.new();
    Frame15.BorderSizePixel = 0;
    Frame15.Position = UDim2.fromScale(0, 0.777778);
    Frame15.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame15.Parent = CanvasGroup;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "Frame";
    Frame16.AnchorPoint = Vector2.new(0, 0.833333313);
    Frame16.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame16.BorderColor3 = Color3.new();
    Frame16.BorderSizePixel = 0;
    Frame16.Position = UDim2.fromScale(0, 0.833333);
    Frame16.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame16.Parent = CanvasGroup;
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "Frame";
    Frame17.AnchorPoint = Vector2.new(0, 0.888888896);
    Frame17.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame17.BorderColor3 = Color3.new();
    Frame17.BorderSizePixel = 0;
    Frame17.Position = UDim2.fromScale(0, 0.888889);
    Frame17.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame17.Parent = CanvasGroup;
    local Frame18 = Instance.new("Frame");
    Frame18.Name = "Frame";
    Frame18.AnchorPoint = Vector2.new(0, 0.944444418);
    Frame18.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame18.BorderColor3 = Color3.new();
    Frame18.BorderSizePixel = 0;
    Frame18.Position = UDim2.fromScale(0, 0.944444);
    Frame18.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame18.Parent = CanvasGroup;
    local Frame19 = Instance.new("Frame");
    Frame19.Name = "Frame";
    Frame19.AnchorPoint = Vector2.new(0, 1);
    Frame19.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame19.BorderColor3 = Color3.new();
    Frame19.BorderSizePixel = 0;
    Frame19.Position = UDim2.fromScale(0, 1);
    Frame19.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame19.Parent = CanvasGroup;
    local Frame20 = Instance.new("Frame");
    Frame20.Name = "Frame";
    Frame20.AnchorPoint = Vector2.new(1, 0);
    Frame20.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame20.BorderColor3 = Color3.new();
    Frame20.BorderSizePixel = 0;
    Frame20.Position = UDim2.fromScale(1, 0);
    Frame20.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame20.Parent = CanvasGroup;
    local Frame21 = Instance.new("Frame");
    Frame21.Name = "Frame";
    Frame21.AnchorPoint = Vector2.new(1, 0.055555556);
    Frame21.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame21.BorderColor3 = Color3.new();
    Frame21.BorderSizePixel = 0;
    Frame21.Position = UDim2.fromScale(1, 0.0555556);
    Frame21.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame21.Parent = CanvasGroup;
    local Frame22 = Instance.new("Frame");
    Frame22.Name = "Frame";
    Frame22.AnchorPoint = Vector2.new(1, 0.111111112);
    Frame22.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame22.BorderColor3 = Color3.new();
    Frame22.BorderSizePixel = 0;
    Frame22.Position = UDim2.fromScale(1, 0.111111);
    Frame22.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame22.Parent = CanvasGroup;
    local Frame23 = Instance.new("Frame");
    Frame23.Name = "Frame";
    Frame23.AnchorPoint = Vector2.new(1, 0.166666672);
    Frame23.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame23.BorderColor3 = Color3.new();
    Frame23.BorderSizePixel = 0;
    Frame23.Position = UDim2.fromScale(1, 0.166667);
    Frame23.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame23.Parent = CanvasGroup;
    local Frame24 = Instance.new("Frame");
    Frame24.Name = "Frame";
    Frame24.AnchorPoint = Vector2.new(1, 0.222222224);
    Frame24.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame24.BorderColor3 = Color3.new();
    Frame24.BorderSizePixel = 0;
    Frame24.Position = UDim2.fromScale(1, 0.222222);
    Frame24.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame24.Parent = CanvasGroup;
    local Frame25 = Instance.new("Frame");
    Frame25.Name = "Frame";
    Frame25.AnchorPoint = Vector2.new(1, 0.277777791);
    Frame25.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame25.BorderColor3 = Color3.new();
    Frame25.BorderSizePixel = 0;
    Frame25.Position = UDim2.fromScale(1, 0.277778);
    Frame25.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame25.Parent = CanvasGroup;
    local Frame26 = Instance.new("Frame");
    Frame26.Name = "Frame";
    Frame26.AnchorPoint = Vector2.new(1, 0.333333343);
    Frame26.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame26.BorderColor3 = Color3.new();
    Frame26.BorderSizePixel = 0;
    Frame26.Position = UDim2.fromScale(1, 0.333333);
    Frame26.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame26.Parent = CanvasGroup;
    local Frame27 = Instance.new("Frame");
    Frame27.Name = "Frame";
    Frame27.AnchorPoint = Vector2.new(1, 0.388888896);
    Frame27.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame27.BorderColor3 = Color3.new();
    Frame27.BorderSizePixel = 0;
    Frame27.Position = UDim2.fromScale(1, 0.388889);
    Frame27.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame27.Parent = CanvasGroup;
    local Frame28 = Instance.new("Frame");
    Frame28.Name = "Frame";
    Frame28.AnchorPoint = Vector2.new(1, 0.444444448);
    Frame28.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame28.BorderColor3 = Color3.new();
    Frame28.BorderSizePixel = 0;
    Frame28.Position = UDim2.fromScale(1, 0.444444);
    Frame28.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame28.Parent = CanvasGroup;
    local Frame29 = Instance.new("Frame");
    Frame29.Name = "Frame";
    Frame29.AnchorPoint = Vector2.new(1, 0.5);
    Frame29.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame29.BorderColor3 = Color3.new();
    Frame29.BorderSizePixel = 0;
    Frame29.Position = UDim2.fromScale(1, 0.5);
    Frame29.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame29.Parent = CanvasGroup;
    local Frame30 = Instance.new("Frame");
    Frame30.Name = "Frame";
    Frame30.AnchorPoint = Vector2.new(1, 0.555555582);
    Frame30.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame30.BorderColor3 = Color3.new();
    Frame30.BorderSizePixel = 0;
    Frame30.Position = UDim2.fromScale(1, 0.555556);
    Frame30.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame30.Parent = CanvasGroup;
    local Frame31 = Instance.new("Frame");
    Frame31.Name = "Frame";
    Frame31.AnchorPoint = Vector2.new(1, 0.611111104);
    Frame31.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame31.BorderColor3 = Color3.new();
    Frame31.BorderSizePixel = 0;
    Frame31.Position = UDim2.fromScale(1, 0.611111);
    Frame31.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame31.Parent = CanvasGroup;
    local Frame32 = Instance.new("Frame");
    Frame32.Name = "Frame";
    Frame32.AnchorPoint = Vector2.new(1, 0.666666687);
    Frame32.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame32.BorderColor3 = Color3.new();
    Frame32.BorderSizePixel = 0;
    Frame32.Position = UDim2.fromScale(1, 0.666667);
    Frame32.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame32.Parent = CanvasGroup;
    local Frame33 = Instance.new("Frame");
    Frame33.Name = "Frame";
    Frame33.AnchorPoint = Vector2.new(1, 0.722222209);
    Frame33.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame33.BorderColor3 = Color3.new();
    Frame33.BorderSizePixel = 0;
    Frame33.Position = UDim2.fromScale(1, 0.722222);
    Frame33.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame33.Parent = CanvasGroup;
    local Frame34 = Instance.new("Frame");
    Frame34.Name = "Frame";
    Frame34.AnchorPoint = Vector2.new(1, 0.777777791);
    Frame34.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame34.BorderColor3 = Color3.new();
    Frame34.BorderSizePixel = 0;
    Frame34.Position = UDim2.fromScale(1, 0.777778);
    Frame34.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame34.Parent = CanvasGroup;
    local Frame35 = Instance.new("Frame");
    Frame35.Name = "Frame";
    Frame35.AnchorPoint = Vector2.new(1, 0.833333313);
    Frame35.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame35.BorderColor3 = Color3.new();
    Frame35.BorderSizePixel = 0;
    Frame35.Position = UDim2.fromScale(1, 0.833333);
    Frame35.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame35.Parent = CanvasGroup;
    local Frame36 = Instance.new("Frame");
    Frame36.Name = "Frame";
    Frame36.AnchorPoint = Vector2.new(1, 0.888888896);
    Frame36.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame36.BorderColor3 = Color3.new();
    Frame36.BorderSizePixel = 0;
    Frame36.Position = UDim2.fromScale(1, 0.888889);
    Frame36.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame36.Parent = CanvasGroup;
    local Frame37 = Instance.new("Frame");
    Frame37.Name = "Frame";
    Frame37.AnchorPoint = Vector2.new(1, 0.944444418);
    Frame37.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame37.BorderColor3 = Color3.new();
    Frame37.BorderSizePixel = 0;
    Frame37.Position = UDim2.fromScale(1, 0.944444);
    Frame37.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame37.Parent = CanvasGroup;
    local Frame38 = Instance.new("Frame");
    Frame38.Name = "Frame";
    Frame38.AnchorPoint = Vector2.new(1, 1);
    Frame38.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame38.BorderColor3 = Color3.new();
    Frame38.BorderSizePixel = 0;
    Frame38.Position = UDim2.fromScale(1, 1);
    Frame38.Size = UDim2.new(0, 3, 0.0366667, 0);
    Frame38.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://6805220123";
    ImageLabel.ImageColor3 = Color3.new();
    ImageLabel.ImageTransparency = 0.7;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Parent = CanvasGroup;
    local Frame39 = Instance.new("Frame");
    Frame39.Name = "Frame";
    Frame39.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame39.BorderColor3 = Color3.new();
    Frame39.BorderSizePixel = 0;
    Frame39.Size = UDim2.new(0.066, 0, 0, 3);
    Frame39.Parent = CanvasGroup;
    local Frame40 = Instance.new("Frame");
    Frame40.Name = "Frame";
    Frame40.AnchorPoint = Vector2.new(0.100000001, 0);
    Frame40.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame40.BorderColor3 = Color3.new();
    Frame40.BorderSizePixel = 0;
    Frame40.Position = UDim2.fromScale(0.1, 0);
    Frame40.Size = UDim2.new(0.066, 0, 0, 3);
    Frame40.Parent = CanvasGroup;
    local Frame41 = Instance.new("Frame");
    Frame41.Name = "Frame";
    Frame41.AnchorPoint = Vector2.new(0.200000003, 0);
    Frame41.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame41.BorderColor3 = Color3.new();
    Frame41.BorderSizePixel = 0;
    Frame41.Position = UDim2.fromScale(0.2, 0);
    Frame41.Size = UDim2.new(0.066, 0, 0, 3);
    Frame41.Parent = CanvasGroup;
    local Frame42 = Instance.new("Frame");
    Frame42.Name = "Frame";
    Frame42.AnchorPoint = Vector2.new(0.300000012, 0);
    Frame42.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame42.BorderColor3 = Color3.new();
    Frame42.BorderSizePixel = 0;
    Frame42.Position = UDim2.fromScale(0.3, 0);
    Frame42.Size = UDim2.new(0.066, 0, 0, 3);
    Frame42.Parent = CanvasGroup;
    local Frame43 = Instance.new("Frame");
    Frame43.Name = "Frame";
    Frame43.AnchorPoint = Vector2.new(0.400000006, 0);
    Frame43.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame43.BorderColor3 = Color3.new();
    Frame43.BorderSizePixel = 0;
    Frame43.Position = UDim2.fromScale(0.4, 0);
    Frame43.Size = UDim2.new(0.066, 0, 0, 3);
    Frame43.Parent = CanvasGroup;
    local Frame44 = Instance.new("Frame");
    Frame44.Name = "Frame";
    Frame44.AnchorPoint = Vector2.new(0.5, 0);
    Frame44.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame44.BorderColor3 = Color3.new();
    Frame44.BorderSizePixel = 0;
    Frame44.Position = UDim2.fromScale(0.5, 0);
    Frame44.Size = UDim2.new(0.066, 0, 0, 3);
    Frame44.Parent = CanvasGroup;
    local Frame45 = Instance.new("Frame");
    Frame45.Name = "Frame";
    Frame45.AnchorPoint = Vector2.new(0.600000024, 0);
    Frame45.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame45.BorderColor3 = Color3.new();
    Frame45.BorderSizePixel = 0;
    Frame45.Position = UDim2.fromScale(0.6, 0);
    Frame45.Size = UDim2.new(0.066, 0, 0, 3);
    Frame45.Parent = CanvasGroup;
    local Frame46 = Instance.new("Frame");
    Frame46.Name = "Frame";
    Frame46.AnchorPoint = Vector2.new(0.699999988, 0);
    Frame46.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame46.BorderColor3 = Color3.new();
    Frame46.BorderSizePixel = 0;
    Frame46.Position = UDim2.fromScale(0.7, 0);
    Frame46.Size = UDim2.new(0.066, 0, 0, 3);
    Frame46.Parent = CanvasGroup;
    local Frame47 = Instance.new("Frame");
    Frame47.Name = "Frame";
    Frame47.AnchorPoint = Vector2.new(0.800000012, 0);
    Frame47.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame47.BorderColor3 = Color3.new();
    Frame47.BorderSizePixel = 0;
    Frame47.Position = UDim2.fromScale(0.8, 0);
    Frame47.Size = UDim2.new(0.066, 0, 0, 3);
    Frame47.Parent = CanvasGroup;
    local Frame48 = Instance.new("Frame");
    Frame48.Name = "Frame";
    Frame48.AnchorPoint = Vector2.new(0.899999976, 0);
    Frame48.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame48.BorderColor3 = Color3.new();
    Frame48.BorderSizePixel = 0;
    Frame48.Position = UDim2.fromScale(0.9, 0);
    Frame48.Size = UDim2.new(0.066, 0, 0, 3);
    Frame48.Parent = CanvasGroup;
    local Frame49 = Instance.new("Frame");
    Frame49.Name = "Frame";
    Frame49.AnchorPoint = Vector2.new(1, 0);
    Frame49.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame49.BorderColor3 = Color3.new();
    Frame49.BorderSizePixel = 0;
    Frame49.Position = UDim2.fromScale(1, 0);
    Frame49.Size = UDim2.new(0.066, 0, 0, 3);
    Frame49.Parent = CanvasGroup;
    local Frame50 = Instance.new("Frame");
    Frame50.Name = "Frame";
    Frame50.AnchorPoint = Vector2.new(1, 1);
    Frame50.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame50.BorderColor3 = Color3.new();
    Frame50.BorderSizePixel = 0;
    Frame50.Position = UDim2.fromScale(1, 1);
    Frame50.Size = UDim2.new(0.066, 0, 0, 3);
    Frame50.Parent = CanvasGroup;
    local Frame51 = Instance.new("Frame");
    Frame51.Name = "Frame";
    Frame51.AnchorPoint = Vector2.new(0.899999976, 1);
    Frame51.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame51.BorderColor3 = Color3.new();
    Frame51.BorderSizePixel = 0;
    Frame51.Position = UDim2.fromScale(0.9, 1);
    Frame51.Size = UDim2.new(0.066, 0, 0, 3);
    Frame51.Parent = CanvasGroup;
    local Frame52 = Instance.new("Frame");
    Frame52.Name = "Frame";
    Frame52.AnchorPoint = Vector2.new(0.800000012, 1);
    Frame52.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame52.BorderColor3 = Color3.new();
    Frame52.BorderSizePixel = 0;
    Frame52.Position = UDim2.fromScale(0.8, 1);
    Frame52.Size = UDim2.new(0.066, 0, 0, 3);
    Frame52.Parent = CanvasGroup;
    local Frame53 = Instance.new("Frame");
    Frame53.Name = "Frame";
    Frame53.AnchorPoint = Vector2.new(0.699999988, 1);
    Frame53.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame53.BorderColor3 = Color3.new();
    Frame53.BorderSizePixel = 0;
    Frame53.Position = UDim2.fromScale(0.7, 1);
    Frame53.Size = UDim2.new(0.066, 0, 0, 3);
    Frame53.Parent = CanvasGroup;
    local Frame54 = Instance.new("Frame");
    Frame54.Name = "Frame";
    Frame54.AnchorPoint = Vector2.new(0.600000024, 1);
    Frame54.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame54.BorderColor3 = Color3.new();
    Frame54.BorderSizePixel = 0;
    Frame54.Position = UDim2.fromScale(0.6, 1);
    Frame54.Size = UDim2.new(0.066, 0, 0, 3);
    Frame54.Parent = CanvasGroup;
    local Frame55 = Instance.new("Frame");
    Frame55.Name = "Frame";
    Frame55.AnchorPoint = Vector2.new(0.5, 1);
    Frame55.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame55.BorderColor3 = Color3.new();
    Frame55.BorderSizePixel = 0;
    Frame55.Position = UDim2.fromScale(0.5, 1);
    Frame55.Size = UDim2.new(0.066, 0, 0, 3);
    Frame55.Parent = CanvasGroup;
    local Frame56 = Instance.new("Frame");
    Frame56.Name = "Frame";
    Frame56.AnchorPoint = Vector2.new(0.400000006, 1);
    Frame56.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame56.BorderColor3 = Color3.new();
    Frame56.BorderSizePixel = 0;
    Frame56.Position = UDim2.fromScale(0.4, 1);
    Frame56.Size = UDim2.new(0.066, 0, 0, 3);
    Frame56.Parent = CanvasGroup;
    local Frame57 = Instance.new("Frame");
    Frame57.Name = "Frame";
    Frame57.AnchorPoint = Vector2.new(0.300000012, 1);
    Frame57.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame57.BorderColor3 = Color3.new();
    Frame57.BorderSizePixel = 0;
    Frame57.Position = UDim2.fromScale(0.3, 1);
    Frame57.Size = UDim2.new(0.066, 0, 0, 3);
    Frame57.Parent = CanvasGroup;
    local Frame58 = Instance.new("Frame");
    Frame58.Name = "Frame";
    Frame58.AnchorPoint = Vector2.new(0.200000003, 1);
    Frame58.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame58.BorderColor3 = Color3.new();
    Frame58.BorderSizePixel = 0;
    Frame58.Position = UDim2.fromScale(0.2, 1);
    Frame58.Size = UDim2.new(0.066, 0, 0, 3);
    Frame58.Parent = CanvasGroup;
    local Frame59 = Instance.new("Frame");
    Frame59.Name = "Frame";
    Frame59.AnchorPoint = Vector2.new(0.100000001, 1);
    Frame59.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame59.BorderColor3 = Color3.new();
    Frame59.BorderSizePixel = 0;
    Frame59.Position = UDim2.fromScale(0.1, 1);
    Frame59.Size = UDim2.new(0.066, 0, 0, 3);
    Frame59.Parent = CanvasGroup;
    local Frame60 = Instance.new("Frame");
    Frame60.Name = "Frame";
    Frame60.AnchorPoint = Vector2.new(0, 1);
    Frame60.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame60.BorderColor3 = Color3.new();
    Frame60.BorderSizePixel = 0;
    Frame60.Position = UDim2.fromScale(0, 1);
    Frame60.Size = UDim2.new(0.066, 0, 0, 3);
    Frame60.Parent = CanvasGroup;
    CanvasGroup.Visible = false;

    return CanvasGroup;
end;

function u1.loadoutFrame(p282, p283, p284) -- Line: 3551
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "1";
    CanvasGroup.BackgroundColor3 = Color3.new(0, 0, 0);
    CanvasGroup.BackgroundTransparency = 0.9;
    CanvasGroup.BorderSizePixel = 0;
    CanvasGroup.Position = UDim2.fromScale(0, -2.14491e-8);
    CanvasGroup.Size = p283;
    local Frame = Instance.new("Frame");
    Frame.Name = "Rarity";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(255, 132, 121);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 1);
    Frame.Size = UDim2.new(1, 0, 0, 3);
    Frame.Parent = CanvasGroup;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "IconShadow";
    ImageButton:SetAttribute("NoSelect", true);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://100429874437897";
    ImageButton.ImageColor3 = Color3.new();
    ImageButton.ImageTransparency = 0.8;
    ImageButton.Position = UDim2.fromOffset(0, 0);
    ImageButton.ScaleType = Enum.ScaleType.Fit;
    ImageButton.Size = UDim2.fromScale(1, 0.965);
    ImageButton.Parent = CanvasGroup;
    ImageButton.Visible = true;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "WeaponName";
    TextLabel.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.95);
    TextLabel.Size = UDim2.fromScale(0.95, 0.175);
    TextLabel.Text = "AKR";
    TextLabel.TextColor3 = Color3.fromRGB(151, 201, 250);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.Parent = CanvasGroup;
    TextLabel.TextTransparency = 1;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Price";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.95);
    TextLabel2.Size = UDim2.fromScale(0.95, 0.175);
    TextLabel2.Text = "$9999";
    TextLabel2.TextColor3 = Color3.fromRGB(191, 191, 191);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel2.Parent = CanvasGroup;
    TextLabel2.TextTransparency = 1;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Icon";
    ImageButton2.BackgroundTransparency = 1;
    ImageButton2.Image = "rbxassetid://100429874437897";
    ImageButton2.Position = UDim2.fromScale(0, -1.30062e-7);
    ImageButton2.ScaleType = Enum.ScaleType.Fit;
    ImageButton2.Size = UDim2.fromScale(1, 0.965);
    ImageButton2.ZIndex = 2;
    ImageButton2.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://6805220123";
    ImageLabel.ImageColor3 = Color3.new();
    ImageLabel.ImageTransparency = 0.75;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Parent = CanvasGroup;
    ImageLabel.Visible = false;
    CanvasGroup.Parent = p282;
    local CanvasGroup2 = Instance.new("CanvasGroup");
    CanvasGroup2.Name = "CanvasGroup";
    CanvasGroup2.BackgroundTransparency = 1;
    CanvasGroup2.Size = UDim2.fromScale(1, 1);
    CanvasGroup2.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.new(0, 3, 0.2, 0);
    Frame2.Parent = CanvasGroup2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Size = UDim2.new(0.2, 0, 0, 3);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame3.Parent = CanvasGroup2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Frame";
    Frame4.AnchorPoint = Vector2.new(0, 0.5);
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0, 0.5);
    Frame4.Size = UDim2.new(0, 3, 0.2, 0);
    Frame4.Parent = CanvasGroup2;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Frame";
    Frame5.AnchorPoint = Vector2.new(0, 1);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.fromScale(0, 1);
    Frame5.Size = UDim2.new(0, 3, 0.2, 0);
    Frame5.Parent = CanvasGroup2;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Frame";
    Frame6.AnchorPoint = Vector2.new(0.5, 0);
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame6.BorderColor3 = Color3.new();
    Frame6.BorderSizePixel = 0;
    Frame6.Position = UDim2.fromScale(0.5, 0);
    Frame6.Size = UDim2.new(0.2, 0, 0, 3);
    Frame6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame6.Parent = CanvasGroup2;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Frame";
    Frame7.AnchorPoint = Vector2.new(1, 0);
    Frame7.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame7.BorderColor3 = Color3.new();
    Frame7.BorderSizePixel = 0;
    Frame7.Position = UDim2.fromScale(1, 0);
    Frame7.Size = UDim2.new(0.2, 0, 0, 3);
    Frame7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame7.Parent = CanvasGroup2;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Frame";
    Frame8.AnchorPoint = Vector2.new(1, 1);
    Frame8.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Position = UDim2.fromScale(1, 1);
    Frame8.Size = UDim2.new(0, 3, 0.2, 0);
    Frame8.Parent = CanvasGroup2;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Frame";
    Frame9.AnchorPoint = Vector2.new(1, 0.5);
    Frame9.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.Position = UDim2.fromScale(1, 0.5);
    Frame9.Size = UDim2.new(0, 3, 0.2, 0);
    Frame9.Parent = CanvasGroup2;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Frame";
    Frame10.AnchorPoint = Vector2.new(1, 0);
    Frame10.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.fromScale(1, 0);
    Frame10.Size = UDim2.new(0, 3, 0.2, 0);
    Frame10.Parent = CanvasGroup2;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Frame";
    Frame11.AnchorPoint = Vector2.new(0.25, 0);
    Frame11.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame11.BorderColor3 = Color3.new();
    Frame11.BorderSizePixel = 0;
    Frame11.Position = UDim2.fromScale(0.25, 0);
    Frame11.Size = UDim2.new(0.2, 0, 0, 3);
    Frame11.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame11.Parent = CanvasGroup2;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Frame";
    Frame12.AnchorPoint = Vector2.new(0.75, 0);
    Frame12.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame12.BorderColor3 = Color3.new();
    Frame12.BorderSizePixel = 0;
    Frame12.Position = UDim2.fromScale(0.75, 0);
    Frame12.Size = UDim2.new(0.2, 0, 0, 3);
    Frame12.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame12.Parent = CanvasGroup2;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Frame";
    Frame13.AnchorPoint = Vector2.new(0, 1);
    Frame13.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame13.BorderColor3 = Color3.new();
    Frame13.BorderSizePixel = 0;
    Frame13.Position = UDim2.fromScale(0, 1);
    Frame13.Size = UDim2.new(0.2, 0, 0, 3);
    Frame13.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame13.Parent = CanvasGroup2;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "Frame";
    Frame14.AnchorPoint = Vector2.new(0.25, 1);
    Frame14.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame14.BorderColor3 = Color3.new();
    Frame14.BorderSizePixel = 0;
    Frame14.Position = UDim2.fromScale(0.25, 1);
    Frame14.Size = UDim2.new(0.2, 0, 0, 3);
    Frame14.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame14.Parent = CanvasGroup2;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Frame";
    Frame15.AnchorPoint = Vector2.new(0.5, 1);
    Frame15.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame15.BorderColor3 = Color3.new();
    Frame15.BorderSizePixel = 0;
    Frame15.Position = UDim2.fromScale(0.5, 1);
    Frame15.Size = UDim2.new(0.2, 0, 0, 3);
    Frame15.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame15.Parent = CanvasGroup2;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "Frame";
    Frame16.AnchorPoint = Vector2.new(0.75, 1);
    Frame16.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame16.BorderColor3 = Color3.new();
    Frame16.BorderSizePixel = 0;
    Frame16.Position = UDim2.fromScale(0.75, 1);
    Frame16.Size = UDim2.new(0.2, 0, 0, 3);
    Frame16.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame16.Parent = CanvasGroup2;
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "Frame";
    Frame17.AnchorPoint = Vector2.new(1, 1);
    Frame17.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame17.BorderColor3 = Color3.new();
    Frame17.BorderSizePixel = 0;
    Frame17.Position = UDim2.fromScale(1, 1);
    Frame17.Size = UDim2.new(0.2, 0, 0, 3);
    Frame17.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame17.Parent = CanvasGroup2;
    CanvasGroup2.Parent = CanvasGroup;

    return CanvasGroup;
end;

function u1.equipmentFrame(p285, p286, p287) -- Line: 3823
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = p286;
    ImageButton.AnchorPoint = Vector2.new(0.5, 0);
    ImageButton.BackgroundColor3 = Color3.new();
    ImageButton.BackgroundTransparency = 0.9;
    ImageButton.BorderColor3 = Color3.new();
    ImageButton.BorderSizePixel = 0;
    ImageButton.Position = UDim2.fromScale(0.5, 0.25);
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.ImageTransparency = 1;
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageButton.LayoutOrder = p287;
    local Frame = Instance.new("Frame");
    Frame.Name = "Rarity";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 1);
    Frame.Size = UDim2.fromScale(1, 0.035);
    Frame.Parent = ImageButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://100429874437897";
    ImageLabel.Position = UDim2.fromScale(0, -1.30062e-7);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 0.965);
    ImageLabel.Interactable = false;
    ImageLabel.Active = false;
    ImageLabel.Parent = ImageButton;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "DefaultIcon";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://93125581632960";
    ImageLabel2.ImageColor3 = Color3.fromRGB(231, 231, 231);
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.Visible = false;
    ImageLabel2.Interactable = false;
    ImageLabel2.Active = false;
    ImageLabel2.Parent = ImageButton;
    ImageButton.Parent = p285;

    return ImageButton;
end;

function u1.hold(p288, p289) -- Line: 3877
    -- upvalues: u2 (ref)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Position = UDim2.new(0, -500, 0, -500);
    ImageLabel.Size = UDim2.new(0, p288.X * 0.9, 0, p288.Y * 0.9);
    ImageLabel.ZIndex = 5;
    ImageLabel.Image = p289;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Parent = u2.Handler.MainMenu;

    return ImageLabel;
end;

function u1.searchUI() -- Line: 3892
    -- upvalues: u10 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Search";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.24, 0.7);
    Frame.ZIndex = 2;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Line";
    Frame2.AnchorPoint = Vector2.new(0.5, 1);
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 0.6;
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 1);
    Frame2.Size = UDim2.new(1, 0, 0, 2);
    Frame2.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://136926548005524";
    ImageLabel.Position = UDim2.fromScale(0, 0.45);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.AnchorPoint = Vector2.new(0, 0.5);
    TextBox.BackgroundTransparency = 1;
    TextBox.ClearTextOnFocus = false;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.PlaceholderColor3 = Color3.new(1, 1, 1);
    TextBox.PlaceholderText = "SEARCH LOADOUT";
    TextBox.Position = UDim2.fromScale(0.11, 0.45);
    TextBox.Size = UDim2.fromScale(0.62, 0.55);
    TextBox.Text = "";
    TextBox.TextColor3 = Color3.new(1, 1, 1);
    TextBox.TextScaled = true;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Count";
    TextLabel.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(1, 0.45);
    TextLabel.Size = UDim2.fromScale(0.25, 0.4);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.Parent = Frame;
    Frame.Parent = u10;

    return Frame;
end;

function u1.dropUIRight() -- Line: 3964
    -- upvalues: u10 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Right";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "TextButton";
    TextButton.AnchorPoint = Vector2.new(1, 0.5);
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.Size = UDim2.fromScale(0.1, 1);
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    TextButton.TextTransparency = 1;
    TextButton.LayoutOrder = 2;
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
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0, 10);
    UIPadding.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0, 0.25);
    TextLabel.Size = UDim2.fromScale(1, 0.5);
    TextLabel.Text = "Equipped";
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
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://136983534433364";
    ImageLabel.Position = UDim2.fromScale(0.872884, 0.2);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.LayoutOrder = 1;
    ImageLabel.Parent = Frame;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingBottom = UDim.new(0.1, 0);
    UIPadding2.PaddingLeft = UDim.new(0.01, 0);
    UIPadding2.PaddingRight = UDim.new(0.01, 0);
    UIPadding2.PaddingTop = UDim.new(0.1, 0);
    UIPadding2.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0.008, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame;
    Frame.Parent = u10;

    return Frame, TextButton;
end;

function u1.dropUILeft() -- Line: 4076
    -- upvalues: u12 (ref), u13 (ref), u14 (ref), u10 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Left";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
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
    UIListLayout.Padding = UDim.new(0.008, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://118345726873781";
    ImageLabel.LayoutOrder = 1;
    ImageLabel.Position = UDim2.fromScale(0.872884, 0.2);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    u12 = Instance.new("TextButton");
    u12.Name = "FirstTextButton";
    u12.AnchorPoint = Vector2.new(1, 0.5);
    u12.BackgroundTransparency = 1;
    u12.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    u12.LayoutOrder = 2;
    u12.Size = UDim2.fromScale(0.1, 1);
    u12.TextColor3 = Color3.new();
    u12.TextSize = 14;
    u12.TextTransparency = 1;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 1.3;
    UIStroke.Transparency = 0.8;
    UIStroke.Parent = u12;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = u12;
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
    TextLabel.Text = "Equipped";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.Parent = Frame2;
    Frame2.Parent = u12;
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
    TextLabel2.Parent = u12;
    u12.Parent = Frame;
    u13 = Instance.new("TextButton");
    u13.Name = "SecondTextButton";
    u13.AnchorPoint = Vector2.new(1, 0.5);
    u13.BackgroundTransparency = 1;
    u13.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    u13.LayoutOrder = 2;
    u13.Size = UDim2.fromScale(0.1, 1);
    u13.TextColor3 = Color3.new();
    u13.TextSize = 14;
    u13.TextTransparency = 1;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Thickness = 1.3;
    UIStroke2.Transparency = 0.8;
    UIStroke2.Parent = u13;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = u13;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "AutoLeft";
    Frame3.BackgroundTransparency = 1;
    Frame3.Size = UDim2.fromScale(1, 1);
    local UIPadding3 = Instance.new("UIPadding");
    UIPadding3.Name = "UIPadding";
    UIPadding3.PaddingLeft = UDim.new(0, 10);
    UIPadding3.Parent = Frame3;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "TextLabel";
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0, 0.25);
    TextLabel3.Size = UDim2.fromScale(1, 0.5);
    TextLabel3.Text = "Equipped";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel3.Parent = Frame3;
    Frame3.Parent = u13;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "V";
    TextLabel4.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(1, 0.5);
    TextLabel4.Rotation = 90;
    TextLabel4.Size = UDim2.fromScale(0.8, 0.6);
    TextLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel4.Text = ">";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.Parent = u13;
    u13.Parent = Frame;
    u14 = Instance.new("ImageButton");
    u14.Name = "Cancel";
    u14.AutoButtonColor = false;
    u14.BackgroundColor3 = Color3.new(1, 1, 1);
    u14.BackgroundTransparency = 0.8;
    u14.LayoutOrder = 5;
    u14.Size = UDim2.fromScale(1, 1);
    u14.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "ImageLabel99";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://89969940365114";
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = u14;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorne3r";
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.Parent = u14;
    u14.Parent = Frame;
    Frame.Parent = u10;
end;

return u1;