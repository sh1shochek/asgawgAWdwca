-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation);
local ItemEquipment = require(ReplicatedStorage.Components.Common.ItemEquipment);
local CalculateGridRenderCount = require(ReplicatedStorage.Components.Common.CalculateGridRenderCount);
local UpdateStatusFrame = ItemEquipment.UpdateStatusFrame;
local IsEquippedOnTeam = ItemEquipment.IsEquippedOnTeam;
local ApplyWearAndSerialBadges = require(ReplicatedStorage.Components.Common.ApplyWearAndSerialBadges);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Buttons = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Buttons);
local Sort = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local UseItemFrame = require(script.Parent.UseItemFrame);
local Loadout = require(script.Parent.Loadout);
local Store = require(script.Parent.Store);
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local u2 = {};
local u3 = table.find(GetUserPlatform(), "PC") ~= nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = 0;
local u9 = false;
local u10 = nil;
local u11 = nil;
local u12 = false;
local u13 = false;
local u14 = nil;
local u15 = 0;
local u16 = nil;
local u17 = {};
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = {};
local u24 = {};
local u25 = {};
local u26 = {};
local u27 = {};
local u28 = false;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = false;
local u33 = {
    ["Charm Capsule"] = "Charm Pack",
    Package = "Package"
};
local u34 = {
    Special = "Drop Gold",
    Red = "Drop Red",
    Pink = "Drop Pink",
    Purple = "Drop Purple",
    Blue = "Drop Blue"
};
local u35 = {
    Glove = "Equipped Gloves",
    Badge = "Equipped Badge",
    ["Zeus x27"] = "Equipped Zeus x27"
};
local u36 = {
    Pistol = "Pistols",
    SMG = "Mid Tier",
    Heavy = "Mid Tier",
    Rifle = "Rifles"
};
local u37 = {};

local function setReverseSortVisual(p38: userdata, p39: boolean) -- Line: 166
    local v40 = p38:FindFirstChildOfClass("ImageLabel");

    if v40 then
        v40.Rotation = p39 and 180 or 0;
    end;
end;

local function ClearQuickOpenPending(p41: string?) -- Line: 173
    -- upvalues: u16 (ref), Store (copy), u13 (ref)
    if p41 and u16 ~= p41 then
        return false;
    end;

    if u16 then
        Store.ClearPendingOpenCaseRequest(u16);
    end;

    u13 = false;
    u16 = nil;

    return true;
end;

local u42 = { "Charm", "Inspect", "ReplaceCT", "ReplaceT", "Unlock" };

local function GetVisibleInformationFrameButtons() -- Line: 190
    -- upvalues: u42 (copy), u18 (ref)
    local v43 = {};

    for _, v in u42 do
        local v44 = u18[v];

        if v44 and v44.Visible then
            table.insert(v43, v44);
        end;
    end;

    local QuickUnlock = u18:FindFirstChild("QuickUnlock");

    if QuickUnlock and QuickUnlock.Visible then
        table.insert(v43, QuickUnlock);
    end;

    return v43;
end;

local function hasAnyInformationFrameButton() -- Line: 205
    -- upvalues: u18 (ref), GetVisibleInformationFrameButtons (copy)
    local v45;

    if u18 == nil then
        v45 = false;
    else
        v45 = #GetVisibleInformationFrameButtons() > 0;
    end;

    return v45;
end;

local function ItemHasCharm(p46) -- Line: 209
    local Charm = p46.Charm;
    local v47;

    if Charm == nil or Charm == false then
        v47 = false;
    else
        v47 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
    end;

    return v47;
end;

local function GetInventoryItemFromIdentifier(p48: table, p49: string) -- Line: 216
    for _, v in ipairs(p48) do
        if v._id == p49 then
            return v;
        end;
    end;

    return nil;
end;

local function IsWeaponEquippedInTeamCategory(p50: string, p51: string, p52: string) -- Line: 231
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v53 = DataController.Get(LocalPlayer, "Loadout");
    local v54 = DataController.Get(LocalPlayer, "Inventory");

    if not (v53 and v54) then
        return false, nil;
    end;

    local v55 = v53[p51];

    if not (v55 and (v55.Loadout and v55.Loadout[p52])) then
        return false, nil;
    end;

    for i, v in ipairs(v55.Loadout[p52].Options) do
        if v and v ~= "" then
            local v56 = i;
            local v57 = v;
            local v58 = nil;

            for _, v2 in ipairs(v54) do
                if v2._id == v57 then
                    v58 = v2;
                    break;
                end;
            end;

            if v58 and v58.Name == p50 then
                return true, v56;
            end;
        end;
    end;

    return false, nil;
end;

local function GetWeaponCategory(p59: string) -- Line: 262
    -- upvalues: GetWeaponProperties (copy), u36 (copy)
    local success, result = pcall(GetWeaponProperties, p59);

    if success and (result and result.Type) then
        return u36[result.Type];
    end;

    return nil;
end;

local function ReplaceItemOnTeam(p60: any, p61: string) -- Line: 273
    -- upvalues: GetWeaponProperties (copy), u36 (copy), IsWeaponEquippedInTeamCategory (copy), Remotes (copy), Top (copy), Loadout (copy), Profiler (copy), u35 (copy)
    if p60.Type ~= "Weapon" then
        if p60.Type ~= "Melee" then
            if u35[p60.Type] then
                Remotes.Inventory.EquipSpecialItem.Send({
                    Identifier = p60._id,
                    Path = u35[p60.Type],
                    Team = p61
                });
            end;

            return;
        end;

        if p60.Name == "CT Knife" and p61 == "Terrorists" or p60.Name == "T Knife" and p61 == "Counter-Terrorists" then
            return;
        end;

        Remotes.Inventory.EquipSpecialItem.Send({
            Path = "Equipped Melee",
            Identifier = p60._id,
            Team = p61
        });

        return;
    end;

    local Name = p60.Name;
    local success, result = pcall(GetWeaponProperties, Name);
    local v62;

    if success and (result and result.Type) then
        v62 = u36[result.Type];
    else
        v62 = nil;
    end;

    if not v62 then
        return;
    end;

    local v63, v64 = IsWeaponEquippedInTeamCategory(Name, p61, v62);

    if v63 and v64 then
        Remotes.Inventory.EquipLoadoutSkin.Send({
            Type = v62,
            Slot = v64 - 1,
            Team = p61,
            Identifier = p60._id
        });

        return;
    end;

    Top.openFrame("Loadout");
    Loadout.SelectTeam(p61 == "Counter-Terrorists" and "CT" or "T");
    Loadout.SortByCategory(nil);
    Loadout.SortByWeapon(Name);
    Profiler.defer("UI.Inventory.LoadoutWeaponFilterDeferred", Loadout.SortByWeapon, Name);
end;

local function SetDropdownOpen(p65: userdata?, p66: boolean) -- Line: 324
    if not p65 then
        return;
    end;

    p65.Visible = p66;
    p65.Active = p66;
    local Scroll = p65:FindFirstChild("Scroll");

    if Scroll and Scroll:IsA("GuiObject") then
        Scroll.Visible = p66;
        Scroll.Active = p66;
    end;
end;

local function setSortDropdownOpen(p67: boolean) -- Line: 339
    -- upvalues: u19 (ref)
    local v68 = u19;

    if not v68 then
        return;
    end;

    v68.Visible = p67;
    v68.Active = p67;
    local Scroll = v68:FindFirstChild("Scroll");

    if Scroll and Scroll:IsA("GuiObject") then
        Scroll.Visible = p67;
        Scroll.Active = p67;
    end;
end;

local function BindSortDropdownFocus(u69: any, u70: userdata, u71: function, u72: string) -- Line: 344
    -- upvalues: GuiService (copy), Profiler (copy)
    local function getInitialSortOption() -- Line: 350
        -- upvalues: u69 (copy), u71 (copy)
        local v73 = u69.Scroll:FindFirstChild(u71());

        if v73 and (v73:IsA("GuiButton") and v73.Selectable) then
            return v73;
        end;

        for _, child in ipairs(u69.Scroll:GetChildren()) do
            if child:IsA("GuiButton") and child.Selectable then
                return child;
            end;
        end;

        return nil;
    end;

    u69:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 363
        -- upvalues: GuiService (ref), u69 (copy), getInitialSortOption (copy), Profiler (ref), u72 (copy), u70 (copy)
        if GuiService.SelectedObject == nil then
            return;
        end;

        if u69.Visible then
            local u74 = getInitialSortOption();

            if u74 then
                Profiler.defer(u72, function() -- Line: 370
                    -- upvalues: u69 (ref), GuiService (ref), u74 (copy)
                    if u69.Visible then
                        GuiService.SelectedObject = u74;
                    end;
                end);
            end;
        else
            local SelectedObject = GuiService.SelectedObject;

            if SelectedObject and SelectedObject:IsDescendantOf(u69.Scroll) then
                GuiService.SelectedObject = u70;
            end;
        end;
    end);
end;

local function BindSearchTap(p75: userdata, u76: userdata) -- Line: 387
    p75.MouseButton1Click:Connect(function() -- Line: 388
        -- upvalues: u76 (copy)
        u76:CaptureFocus();
    end);
    p75.Activated:Connect(function() -- Line: 391
        -- upvalues: u76 (copy)
        u76:CaptureFocus();
    end);
end;

local function IsMouseOverVisibleGui(p77: userdata?, p78) -- Line: 396
    if not (p77 and p77.Visible) then
        return false;
    end;

    local AbsolutePosition = p77.AbsolutePosition;
    local AbsoluteSize = p77.AbsoluteSize;
    local v79;

    if p78.X >= AbsolutePosition.X and (p78.X <= AbsolutePosition.X + AbsoluteSize.X and p78.Y >= AbsolutePosition.Y) then
        v79 = p78.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v79 = false;
    end;

    return v79;
end;

local function IsMouseOverBlockingUI() -- Line: 407
    -- upvalues: Mouse (copy), u20 (ref), u19 (ref), u18 (ref)
    local Vector2_new_ret = Vector2.new(Mouse.X, Mouse.Y);

    if u20.Ignore.ItemNotification.Visible then
        return true;
    end;

    local v80 = u19;
    local v81;

    if v80 and v80.Visible then
        local AbsolutePosition = v80.AbsolutePosition;
        local AbsoluteSize = v80.AbsoluteSize;

        if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
            v81 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v81 = false;
        end;
    else
        v81 = false;
    end;

    if not v81 then
        local v82 = u18;

        if not (v82 and v82.Visible) then
            return false;
        end;

        local AbsolutePosition = v82.AbsolutePosition;
        local AbsoluteSize = v82.AbsoluteSize;

        if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
            v81 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v81 = false;
        end;
    end;

    return v81;
end;

local function shouldRunInventoryUpdate() -- Line: 418
    -- upvalues: u20 (ref)
    local v83;

    if u20 == nil then
        v83 = false;
    else
        v83 = u20.Visible;
    end;

    return v83;
end;

local function stopInventoryUpdate() -- Line: 424
    -- upvalues: u31 (ref)
    if u31 then
        u31:Disconnect();
        u31 = nil;
    end;
end;

local function updateInventoryHeartbeat(p84: number) -- Line: 433
    -- upvalues: Profiler (copy), u20 (ref), u21 (ref), u31 (ref), u3 (copy), u1 (copy)
    Profiler.mark("UI.Inventory.Heartbeat");

    if not (u20 and u21) then
        if u31 then
            u31:Disconnect();
            u31 = nil;
        end;

        return;
    end;

    local v85;

    if u20 == nil then
        v85 = false;
    else
        v85 = u20.Visible;
    end;

    if v85 and (u3 and u20.Visible) then
        u1.UpdateHoverFrame(p84);
    else
        u20.Ignore.Hover.Visible = false;
    end;

    if v85 and u20.Ignore.ItemNotification.Visible then
        u20.Ignore.ItemNotification.Holder.Light.Rotation = u20.Ignore.ItemNotification.Holder.Light.Rotation + p84 * 10;
    end;

    if not v85 and u31 then
        u31:Disconnect();
        u31 = nil;
    end;
end;

local function syncInventoryUpdate() -- Line: 459
    -- upvalues: u20 (ref), u21 (ref), u24 (copy), u25 (copy), u8 (ref), u31 (ref), RunServiceController (copy), updateInventoryHeartbeat (copy)
    if not (u20 and u21) then
        return;
    end;

    local v86 = 0;

    for _, v in ipairs(u24) do
        if not u25[v._id] then
            v86 = v86 + 1;
        end;
    end;

    local Alert = u21.Menu.Top.Bottom.Buttons.Inventory.Alert;
    Alert.TextLabel.Text = v86;
    Alert.Visible = v86 > 0;
    local v87 = #u24;
    local Holder = u20.Ignore.ItemNotification.Holder;
    Holder.Amount.TextLabel.Text = `{u8} / {v87}`;
    Holder.Right.Visible = u8 < v87;
    Holder.Left.Visible = u8 > 1;
    local v88;

    if u20 == nil then
        v88 = false;
    else
        v88 = u20.Visible;
    end;

    if not v88 then
        updateInventoryHeartbeat(0);

        return;
    end;

    if u31 then
        return;
    end;

    u31 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
    updateInventoryHeartbeat(0);
end;

local function CalculateHoverPosition(p89) -- Line: 491
    -- upvalues: u20 (ref), GuiService (copy)
    local AbsolutePosition = u20.AbsolutePosition;
    local AbsoluteSize = u20.Ignore.Hover.AbsoluteSize;
    local AbsolutePosition2 = p89.AbsolutePosition;
    local AbsoluteSize2 = u20.AbsoluteSize;
    local AbsoluteSize3 = p89.AbsoluteSize;
    local v90 = AbsolutePosition2.X - AbsolutePosition.X;
    local v91 = AbsoluteSize2.X - (v90 + AbsoluteSize3.X) >= AbsoluteSize.X + 8 and (v90 + AbsoluteSize3.X + 8 + AbsoluteSize.X / 2) / AbsoluteSize2.X or (v90 - 8 - AbsoluteSize.X / 2) / AbsoluteSize2.X;
    local math_max_ret = math.max((AbsolutePosition2.Y - AbsolutePosition.Y + AbsoluteSize3.Y / 2) / AbsoluteSize2.Y, AbsoluteSize.Y / 2 / AbsoluteSize2.Y);
    local v92 = 1 - AbsoluteSize.Y / 2 / AbsoluteSize2.Y;
    local math_min_ret = math.min(math_max_ret, v92);

    if GuiService:GetGuiInset().Y >= AbsolutePosition.Y + math_min_ret * AbsoluteSize2.Y - AbsoluteSize.Y / 2 then
        math_min_ret = math.min(math_min_ret + 30 / AbsoluteSize2.Y, v92);
    end;

    return UDim2.fromScale(v91, math_min_ret);
end;

local function ReportViewedItems() -- Line: 538
    -- upvalues: u26 (copy), Remotes (copy)
    local v93 = {};

    for i in u26 do
        table.insert(v93, i);
    end;

    table.clear(u26);

    if #v93 > 0 then
        Remotes.Player.NewInventoryItemsSeen.Send({
            Dismissed = false,
            ItemIds = v93
        });
    end;
end;

local function MarkItemViewed(p94: string) -- Line: 549
    -- upvalues: u25 (copy), u26 (copy), u28 (ref), ReportViewedItems (copy)
    if u25[p94] then
        return;
    end;

    u25[p94] = true;
    u26[p94] = true;

    if not u28 then
        u28 = true;
        task.delay(2, function() -- Line: 558
            -- upvalues: u28 (ref), ReportViewedItems (ref)
            u28 = false;
            ReportViewedItems();
        end);
    end;
end;

local function DismissItemNotifications() -- Line: 565
    -- upvalues: u20 (ref), u8 (ref), u29 (ref), u24 (copy), u27 (copy), u26 (copy), Remotes (copy), u23 (ref), u25 (copy), u32 (ref), syncInventoryUpdate (copy)
    u20.Ignore.ItemNotification.Visible = false;
    u8 = 0;
    u29 = nil;
    local os_clock_ret = os.clock();
    local v95 = {};
    local v96 = {};

    for _, v in ipairs(u24) do
        table.insert(v95, v._id);
        v96[v._id] = true;
        u27[v._id] = os_clock_ret;
    end;

    if #v95 > 0 then
        table.clear(u26);
        Remotes.Player.NewInventoryItemsSeen.Send({
            Dismissed = true,
            ItemIds = v95
        });
        local v97 = {};

        for _, v in ipairs(u23) do
            if not v96[v] then
                table.insert(v97, v);
            end;
        end;

        u23 = v97;
    end;

    table.clear(u24);
    table.clear(u25);
    u32 = false;
    syncInventoryUpdate();
end;

local function FindQueuedItemIndex(p98: string) -- Line: 597
    -- upvalues: u24 (copy)
    for i, v in ipairs(u24) do
        if v._id == p98 then
            return i;
        end;
    end;

    return nil;
end;

local function RefreshNewInventoryItems() -- Line: 607
    -- upvalues: u24 (copy), u8 (ref), DataController (copy), LocalPlayer (copy), u23 (ref), u25 (copy), u20 (ref), u32 (ref), u1 (copy), u29 (ref), syncInventoryUpdate (copy)
    local v99 = u24[u8];
    local v100 = {};
    local v101 = DataController.Get(LocalPlayer, "Inventory");

    if type(v101) == "table" then
        for _, v in ipairs(v101) do
            if v._id then
                v100[v._id] = v;
            end;
        end;
    end;

    table.clear(u24);
    local v102 = {};

    for _, v in ipairs(u23) do
        v102[v] = true;
        local v103 = v100[v];

        if v103 then
            table.insert(u24, v103);
        end;
    end;

    for i in u25 do
        if not v102[i] then
            u25[i] = nil;
        end;
    end;

    local v104;

    if u20 == nil then
        v104 = false;
    else
        v104 = u20.Ignore.ItemNotification.Visible;
    end;

    local v105;

    if v104 then
        v105 = u20.Visible;
    else
        v105 = v104;
    end;

    if #u24 == 0 then
        if v104 then
            u20.Ignore.ItemNotification.Visible = false;
        end;

        u8 = 0;
        u32 = false;
    else
        if v99 then
            local _id = v99._id;
            v99 = nil;

            for i, v in ipairs(u24) do
                if v._id == _id then
                    v99 = i;
                    break;
                end;
            end;
        end;

        if v99 then
            u8 = v99;
        else
            local v106 = 0;

            for _, v in ipairs(u24) do
                if not u25[v._id] then
                    break;
                end;

                v106 = v106 + 1;
            end;

            u8 = v106;

            if v105 then
                u1.NextInventoryItem((math.min(v106 + 1, #u24)));
            elseif v104 then
                u20.Ignore.ItemNotification.Visible = false;
            end;
        end;
    end;

    local v107 = u29;

    if v107 then
        local v108 = u29;
        v107 = nil;

        for i, v in ipairs(u24) do
            if v._id == v108 then
                v107 = i;
                break;
            end;
        end;
    end;

    if v107 then
        u29 = nil;

        if u20 and u20.Visible then
            u1.NextInventoryItem(v107);
        else
            u8 = v107 - 1;
        end;
    end;

    syncInventoryUpdate();
end;

local function InspectInventoryItem(p109) -- Line: 683
    -- upvalues: Router (copy)
    Router.broadcastRouter("WeaponInspect", p109.Name, p109.Skin, p109.Float, p109.StatTrack, p109.NameTag, p109.Charm, p109.Stickers, p109.Type, p109.Pattern, p109._id, p109.Serial, p109.IsTradeable);
end;

local function GetIconImage(p110: any, p111: any, p112: boolean) -- Line: 703
    -- upvalues: Skins (copy)
    if not p111 then
        return "";
    end;

    if p112 then
        return p111.imageAssetId or "";
    end;

    if p110.Type ~= "Charm" then
        return Skins.GetWearImageForFloat(p111, p110.Float or 0.9999) or p111.imageAssetId or "";
    end;

    local Pattern = p110.Pattern;

    if Pattern and p111.charmImages then
        for _, v in ipairs(p111.charmImages) do
            if v.pattern == Pattern then
                return v.assetId;
            end;
        end;
    end;

    return p111.imageAssetId or "";
end;

local function GetItemDisplayName(p113: any, p114: any, p115: boolean) -- Line: 728
    -- upvalues: GetSkinDisplayName (copy), u33 (copy)
    local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(p113.Name, p113.NameTag);
    local v116 = p115 and p114.caseType and u33[p114.caseType] or p115 and p114.caseType;

    if v116 then
        WeaponDisplayName = v116;
    elseif p113.StatTrack then
        WeaponDisplayName = "KillTrak™ " .. WeaponDisplayName or WeaponDisplayName;
    end;

    return (p113.Type == "Melee" and "★ " or "") .. WeaponDisplayName;
end;

local function findCharmInventoryItemInList(p117: any, p118: table?) -- Line: 741
    if not (p117 and (p117 ~= false and p118)) then
        return nil;
    end;

    local v119 = nil;

    if type(p117) == "table" then
        p117 = p117._id;
    elseif type(p117) ~= "string" then
        p117 = v119;
    end;

    if not p117 then
        return nil;
    end;

    for _, v in ipairs(p118) do
        if v._id == p117 and v.Type == "Charm" then
            return v;
        end;
    end;

    return nil;
end;

local function syncItemTemplateCharmIcon(p120, p121) -- Line: 767
    -- upvalues: DataController (copy), LocalPlayer (copy), findCharmInventoryItemInList (copy), GetResolvedSkinInformation (copy), GetIconImage (copy)
    local Charm = p120.ItemContent:FindFirstChild("Charm");

    if not (Charm and Charm:IsA("ImageLabel")) then
        return;
    end;

    local v122 = "";

    if p121.Type == "Weapon" then
        local Charm2 = p121.Charm;
        local v123;

        if Charm2 == nil or Charm2 == false then
            v123 = false;
        else
            v123 = (type(Charm2) == "string" or Charm2 == true) and true or type(Charm2) == "table";
        end;

        if v123 then
            local v124 = DataController.Get(LocalPlayer, "Inventory");
            local v125 = findCharmInventoryItemInList(p121.Charm, v124);
            local v126;

            if v125 then
                v126 = GetResolvedSkinInformation(v125.Name, v125.Skin);
            else
                v126 = v125;
            end;

            if v126 then
                v122 = GetIconImage(v125, v126, false);
            end;
        end;
    end;

    if v122 == "" then
        Charm.Visible = false;
        Charm.Image = "";

        return;
    end;

    Charm.Image = v122;
    Charm.Visible = true;
end;

local function GetCollectionNameForItem(p127) -- Line: 792
    -- upvalues: Cases (copy), u10 (ref), GetResolvedSkinInformation (copy)
    if p127.Type ~= "Case" then
        local v128 = GetResolvedSkinInformation(p127.Name, p127.Skin);

        return v128 and v128.collection or nil;
    end;

    local CaseByName = Cases.GetCaseByName(p127.Skin);

    if not (CaseByName and u10) then
        return nil;
    end;

    for _, v in ipairs(u10) do
        if v.cases then
            local v129 = v;

            for _, v2 in ipairs(v.cases) do
                if v2 == CaseByName.name then
                    return v129.name;
                end;
            end;
        end;
    end;

    return nil;
end;

local function GetSortedInventoryData() -- Line: 821
    -- upvalues: DataController (copy), LocalPlayer (copy), u11 (ref), u20 (ref), Sort (copy), u10 (ref), Grenades (copy), u12 (ref)
    local v130 = DataController.Get(LocalPlayer, "Inventory");

    if not v130 then
        return {};
    end;

    local SortComparisonFunction = Sort.GetSortComparisonFunction(u11 or u20.Frame.Right.Top.Filter.Container.Left.Title.Text, LocalPlayer, function() -- Line: 829
        -- upvalues: u10 (ref)
        return u10;
    end);
    local v131 = {};

    for _, v in v130 do
        local v132;

        if v then
            v132 = Grenades[v.Name];
        else
            v132 = v;
        end;

        local v133;

        if v then
            v133 = v.Type == "Case" and true or v.Type == "Package";
        else
            v133 = v;
        end;

        if v and (v._id and v.Name) and (v133 or v.Skin) and not v132 then
            table.insert(v131, v);
        end;
    end;

    if SortComparisonFunction then
        if u12 then
            table.sort(v131, function(p134, p135) -- Line: 847
                -- upvalues: SortComparisonFunction (copy)
                local v136, v137 = SortComparisonFunction(p134, p135);

                if v137 then
                    return v136;
                end;

                return SortComparisonFunction(p135, p134);
            end);

            return v131;
        end;

        table.sort(v131, SortComparisonFunction);
    end;

    return v131;
end;

local function IsNotFiltered(p138: any, p139: table) -- Line: 866
    -- upvalues: Buttons (copy), GetWeaponProperties (copy)
    if not p139 or #p139 == 0 then
        return true;
    end;

    local EffectiveItemType = Buttons.GetEffectiveItemType(p138);
    local v140 = Buttons.IsCapsule(p138);

    for _, v in ipairs(p139) do
        if EffectiveItemType == v then
            return true;
        end;

        if p138.Type and (p138.Type == v and not v140) then
            return true;
        end;

        local v141;

        if p138.Name then
            v141 = GetWeaponProperties(p138.Name);
        else
            v141 = nil;
        end;

        if string.find(v, ":") then
            local string_split_ret = string.split(v, ":");

            if string_split_ret[1] == "Weapon" and (v141 and (v141.Class == "Weapon" and string_split_ret[2] == v141.Type)) then
                return true;
            end;
        elseif v141 and v141.Class == v then
            return true;
        end;
    end;

    return false;
end;

local function SetSearchTokens(p142: table, p143: string) -- Line: 916
    table.clear(p142);

    if p143 ~= "" then
        for _, v in ipairs(string.split(string.lower(p143), " ")) do
            if v ~= "" then
                table.insert(p142, v);
            end;
        end;
    end;
end;

local function MatchesSearchQuery(p144) -- Line: 928
    -- upvalues: u17 (copy), GetSkinDisplayName (copy)
    if #u17 == 0 then
        return true;
    end;

    local v145 = GetSkinDisplayName.GetSearchIdentity(p144.Name, p144.Skin):lower();

    for _, v in ipairs(u17) do
        if string.find(v145, v, 1, true) == nil then
            return false;
        end;
    end;

    return true;
end;

local function ApplyFilterToSortedData(p146: table) -- Line: 943
    -- upvalues: Buttons (copy), u37 (copy), DataController (copy), LocalPlayer (copy), IsNotFiltered (copy), u17 (copy), MatchesSearchQuery (copy)
    local v147 = {};

    for _, v in Buttons do
        if type(v) == "table" then
            for i, v2 in v do
                if u37[i] then
                    for _, v3 in v2.Search do
                        table.insert(v147, v3);
                    end;
                end;
            end;
        end;
    end;

    local v148 = {};
    local v149 = DataController.Get(LocalPlayer, "Inventory");

    if v149 then
        for _, v in ipairs(v149) do
            if v.Charm then
                local v150 = type(v.Charm) == "table" and v.Charm._id;

                if not v150 then
                    if type(v.Charm) == "string" then
                        v150 = v.Charm;
                    else
                        v150 = false;
                    end;
                end;

                if v150 then
                    v148[v150] = true;
                end;
            end;
        end;
    end;

    local v151 = {};

    for _, v in ipairs(p146) do
        local v152 = IsNotFiltered(v, v147);

        if v152 and (v.Type == "Charm" and v148[v._id]) then
            v152 = false;
        end;

        if v152 then
            table.insert(v151, v);
        end;
    end;

    if #u17 > 0 then
        v151 = {};

        for _, v in ipairs(v151) do
            if MatchesSearchQuery(v) then
                table.insert(v151, v);
            end;
        end;
    end;

    return v151;
end;

local function CreateMissingItemTemplates(p153: userdata, p154: number, p155: number) -- Line: 1006
    -- upvalues: u2 (ref), u1 (copy)
    for i = p154, p155 do
        local v156 = u2[i];
        local v157;

        if v156 and not p153:FindFirstChild(v156._id) then
            u1.CreateItemTemplate(v156);
            v157 = i;
        else
            v157 = i;
        end;
    end;
end;

local function ApplySortedLayoutOrder(p158: userdata) -- Line: 1015
    -- upvalues: u2 (ref)
    for _, child in ipairs(p158:GetChildren()) do
        if child:IsA("Frame") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
            local v159 = child;

            for i, v in ipairs(u2) do
                if v._id == v159.Name then
                    v159.LayoutOrder = i;
                    break;
                end;
            end;
        end;
    end;
end;

local function RenderInventoryTemplates() -- Line: 1033
    -- upvalues: Profiler (copy), u20 (ref), u15 (ref), u2 (ref), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy)
    Profiler.mark("UI.Inventory.RenderInventoryTemplates");

    if u20 and u20.Visible then
        local Container = u20.Frame.Right.Container;
        local math_min_ret = math.min(u15 + 25, #u2);
        CreateMissingItemTemplates(Container, u15 + 1, math_min_ret);
        u15 = math_min_ret;
        ApplySortedLayoutOrder(Container);
    end;
end;

local function OnScrollPositionChanged() -- Line: 1046
    -- upvalues: u20 (ref), u15 (ref), u2 (ref), Profiler (copy), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy)
    if u20 and u20.Visible then
        local v160 = u20.Frame.Right.Container.AbsoluteCanvasSize.Y - u20.Frame.Right.Container.AbsoluteSize.Y;

        if v160 > 0 and (u15 < #u2 and v160 - u20.Frame.Right.Container.CanvasPosition.Y < 200) then
            Profiler.mark("UI.Inventory.RenderInventoryTemplates");

            if u20 and u20.Visible then
                local Container = u20.Frame.Right.Container;
                local math_min_ret = math.min(u15 + 25, #u2);
                CreateMissingItemTemplates(Container, u15 + 1, math_min_ret);
                u15 = math_min_ret;
                ApplySortedLayoutOrder(Container);
            end;
        end;
    end;
end;

local function CalculateInitialRenderCount() -- Line: 1065
    -- upvalues: u20 (ref), CalculateGridRenderCount (copy)
    return not (u20 and u20.Visible) and 50 or CalculateGridRenderCount(u20.Frame.Right.Container);
end;

local function RenderInitialTemplates() -- Line: 1074
    -- upvalues: Profiler (copy), u20 (ref), u15 (ref), CalculateGridRenderCount (copy), u2 (ref), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy)
    Profiler.mark("UI.Inventory.RenderInitialTemplates");

    if not (u20 and u20.Visible) then
        return;
    end;

    local Container = u20.Frame.Right.Container;
    u15 = 0;
    local v161 = not (u20 and u20.Visible) and 50 or CalculateGridRenderCount(u20.Frame.Right.Container);
    local math_max_ret = math.max(v161, 50);
    local math_min_ret = math.min(math_max_ret, #u2);
    CreateMissingItemTemplates(Container, 1, math_min_ret);
    ApplySortedLayoutOrder(Container);
    u15 = math_min_ret;
end;

local function IsItemTemplate(p162: userdata) -- Line: 1094
    local v163 = p162:IsA("ImageButton");

    if v163 then
        if p162.Name == "UIGridLayout" or (p162.Name == "UIListLayout" or (p162.Name == "UIPadding" or p162.Name == "Title")) then
            v163 = false;
        else
            v163 = p162.Name ~= "Label";
        end;
    end;

    return v163;
end;

local function UpdateInventoryTemplates() -- Line: 1105
    -- upvalues: Profiler (copy), u20 (ref), u15 (ref), RenderInitialTemplates (copy)
    Profiler.mark("UI.Inventory.UpdateInventoryTemplates");

    if not u20 then
        return;
    end;

    for _, child in ipairs(u20.Frame.Right.Container:GetChildren()) do
        local v164 = child:IsA("ImageButton");

        if v164 then
            if child.Name == "UIGridLayout" or (child.Name == "UIListLayout" or (child.Name == "UIPadding" or child.Name == "Title")) then
                v164 = false;
            else
                v164 = child.Name ~= "Label";
            end;
        end;

        if v164 then
            child:Destroy();
        end;
    end;

    u15 = 0;

    if u20.Visible then
        RenderInitialTemplates();
    end;
end;

local function ApplyCurrentSort() -- Line: 1128
    -- upvalues: Profiler (copy), u20 (ref), u2 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy)
    Profiler.mark("UI.Inventory.ApplyCurrentSort");

    if not u20 then
        return;
    end;

    if not u20.Visible then
        return;
    end;

    u2 = GetSortedInventoryData();
    u2 = ApplyFilterToSortedData(u2);
    UpdateInventoryTemplates();
end;

local function ConnectButtonActivation(p165: userdata, u166: function) -- Line: 1147
    p165.MouseButton1Click:Connect(u166);
    p165.Activated:Connect(function(p167) -- Line: 1149
        -- upvalues: u166 (copy)
        if p167 and p167.UserInputType == Enum.UserInputType.Gamepad1 then
            u166();
        end;
    end);
end;

local function AnimateSortButton(u168: userdata, u169: any, u170: string, u171: userdata, u172: function) -- Line: 1158
    -- upvalues: Router (copy), u18 (ref), u11 (ref), Profiler (copy), u20 (ref), u2 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy)
    u169.Selectable = true;

    local function handleSortOptionClick() -- Line: 1167
        -- upvalues: Router (ref), u18 (ref), u11 (ref), u170 (copy), Profiler (ref), u20 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), u171 (copy), u168 (copy), u169 (copy), u172 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if u18 then
            u18.Visible = false;
        end;

        u11 = u170;
        Profiler.mark("UI.Inventory.ApplyCurrentSort");

        if u20 and u20.Visible then
            u2 = GetSortedInventoryData();
            u2 = ApplyFilterToSortedData(u2);
            UpdateInventoryTemplates();
        end;

        u171.Text = u170;

        for _, child in ipairs(u168:GetChildren()) do
            if child:IsA("TextButton") then
                child.Frame.BackgroundTransparency = child == u169 and 0 or 1;
            end;
        end;

        u172();
    end;

    u169.MouseButton1Click:Connect(handleSortOptionClick);
    u169.Activated:Connect(function(p173) -- Line: 1149
        -- upvalues: handleSortOptionClick (copy)
        if p173 and p173.UserInputType == Enum.UserInputType.Gamepad1 then
            handleSortOptionClick();
        end;
    end);
end;

function u1.CreateItemTemplate(u174) -- Line: 1188
    -- upvalues: Profiler (copy), Cases (copy), GetResolvedSkinInformation (copy), Rarities (copy), GetIconImage (copy), ReplicatedStorage (copy), u20 (ref), GetWeaponProperties (copy), syncItemTemplateCharmIcon (copy), ApplyWearAndSerialBadges (copy), GetSkinDisplayName (copy), u33 (copy), UpdateStatusFrame (copy), Mouse (copy), u19 (ref), u18 (ref), DataController (copy), LocalPlayer (copy), Router (copy), u7 (ref), u4 (ref), u1 (copy), GetVisibleInformationFrameButtons (copy), UserInputService (copy), u6 (ref), u14 (ref), u3 (copy), u5 (ref)
    Profiler.mark("UI.Inventory.CreateItemTemplate");

    if not (u174 and u174._id) then
        return;
    end;

    local v175 = u174.Type == "Case" and true or u174.Type == "Package";
    local v176 = v175 and Cases.GetCaseByName(u174.Skin) or GetResolvedSkinInformation(u174.Name, u174.Skin);

    if not v176 then
        print((`[Inventory] Skipping template creation for item: {u174.Name} | {u174.Skin} (Type: {u174.Type}) - No item information found`));

        return;
    end;

    local v177 = Rarities[v175 and v176.caseRarity or v176.rarity];
    local v178 = GetIconImage(u174, v176, v175);
    local u179 = ReplicatedStorage.Assets.UI.Inventory.ItemTemplate:Clone();
    u179.ItemContent.Rarity.BackgroundColor3 = v177.Color;
    u179.Parent = u20.Frame.Right.Container;
    u179.ItemContent.Content.Icon.Image = v178;
    u179.Name = u174._id;
    local v180 = GetWeaponProperties(u174.Name);

    if v180 and v180.InventoryIconData then
        u179.ItemContent.Content.Icon.ScaleType = v180.InventoryIconData.ScaleType or (u179.ItemContent.Content.Icon.ScaleType or u179.ItemContent.Content.Icon.Position);
        u179.ItemContent.Content.Icon.Size = v180.InventoryIconData.Size or u179.itemTemplate.ItemContent.Content.Icon.Size;
    end;

    syncItemTemplateCharmIcon(u179, u174);
    ApplyWearAndSerialBadges(u179, u174, v176);
    local ApplyNameLabel = GetSkinDisplayName.ApplyNameLabel;
    local WeaponName = u179.Bottom.Footer.WeaponName;
    local v181 = u174;
    local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(v181.Name, v181.NameTag);
    local v182 = v175 and v176.caseType and u33[v176.caseType] or v175 and v176.caseType;

    if v182 then
        WeaponDisplayName = v182;
    elseif v181.StatTrack then
        WeaponDisplayName = "KillTrak™ " .. WeaponDisplayName or WeaponDisplayName;
    end;

    ApplyNameLabel(WeaponName, (v181.Type == "Melee" and "★ " or "") .. WeaponDisplayName, u174.NameTag);
    u179.Bottom.Footer.SkinName.Text = GetSkinDisplayName(v175 and v176.skin or (u174.Skin or ""));
    UpdateStatusFrame(u179, u174._id);
    u179.Selectable = true;

    local function handleItemSelection(u183: boolean?) -- Line: 1245
        -- upvalues: u20 (ref), Mouse (ref), u19 (ref), u18 (ref), DataController (ref), LocalPlayer (ref), u174 (ref), Router (ref), u7 (ref), u179 (copy), u4 (ref), u1 (ref), GetVisibleInformationFrameButtons (ref), UserInputService (ref), Profiler (ref), u6 (ref), u14 (ref)
        if not u20.Ignore.ItemNotification.Visible then
            local Vector2_new_ret = Vector2.new(Mouse.X, Mouse.Y);
            local v184;

            if u20.Ignore.ItemNotification.Visible then
                v184 = true;
            else
                local v185 = u19;

                if v185 and v185.Visible then
                    local AbsolutePosition = v185.AbsolutePosition;
                    local AbsoluteSize = v185.AbsoluteSize;

                    if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
                        v184 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                    else
                        v184 = false;
                    end;
                else
                    v184 = false;
                end;

                if not v184 then
                    local v186 = u18;

                    if v186 and v186.Visible then
                        local AbsolutePosition = v186.AbsolutePosition;
                        local AbsoluteSize = v186.AbsoluteSize;

                        if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
                            v184 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                        else
                            v184 = false;
                        end;
                    else
                        v184 = false;
                    end;
                end;
            end;

            if not v184 then
                local v187 = DataController.Get(LocalPlayer, "Inventory");

                if v187 then
                    for _, v in ipairs(v187) do
                        if v._id == u174._id then
                            u174 = v;
                            break;
                        end;
                    end;
                end;

                local v188 = u174.Type == "Case" and true or u174.Type == "Package";
                local v189 = u174.Type == "Charm Capsule" and true or u174.Type == "Sticker Capsule";
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u7 = u179;
                u4 = u174;
                u1.SetupInformationFrame(u174);
                local v190;

                if u18 == nil then
                    v190 = false;
                else
                    v190 = #GetVisibleInformationFrameButtons() > 0;
                end;

                if not v190 then
                    u18.Visible = false;

                    return;
                end;

                local function positionInformationFrame() -- Line: 1275
                    -- upvalues: u18 (ref), UserInputService (ref), u183 (copy), u179 (ref), Mouse (ref)
                    local Parent = u18.Parent.Parent;
                    local AbsolutePosition = Parent.AbsolutePosition;
                    local AbsoluteSize = Parent.AbsoluteSize;
                    local v191 = nil;
                    local v192 = nil;

                    if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 or u183 then
                        if u179 and u179:IsA("GuiObject") then
                            local AbsolutePosition2 = u179.AbsolutePosition;
                            local AbsoluteSize2 = u179.AbsoluteSize;
                            v191 = AbsolutePosition2.X + AbsoluteSize2.X / 2;
                            v192 = AbsolutePosition2.Y + AbsoluteSize2.Y / 2;
                        end;
                    else
                        v191 = Mouse.X;
                        v192 = Mouse.Y;
                    end;

                    local v193, v194;

                    if v191 then
                        local v195 = (v191 - AbsolutePosition.X) / AbsoluteSize.X;
                        v193 = (v192 - AbsolutePosition.Y) / AbsoluteSize.Y + u18.Size.Y.Scale / 2;

                        if 1 - v195 >= u18.Size.X.Scale + 0.01 then
                            v194 = v195 + u18.Size.X.Scale / 2 + 0.01;
                        else
                            v194 = v195 - u18.Size.X.Scale / 2 - 0.01;
                        end;
                    else
                        v194 = 0.5;
                        v193 = 0.5;
                    end;

                    u18.Position = UDim2.fromScale(v194, v193);
                end;

                if v188 or v189 then
                    u18.Visible = true;
                    positionInformationFrame();
                    u20.Ignore.Hover.Visible = false;

                    if u183 then
                        Profiler.defer("UI.Inventory.InformationNavigationDeferred", function() -- Line: 1317
                            -- upvalues: u1 (ref)
                            u1.SetupInformationFrameNavigation();
                            u1.SelectFirstInformationFrameButton();
                        end);
                    end;

                    return;
                end;

                if u183 then
                    u18.Visible = true;
                else
                    u18.Visible = not u18.Visible;
                end;

                if not u18.Visible then
                    if u6 then
                        u14 = tick();
                    end;

                    return;
                end;

                positionInformationFrame();
                u20.Ignore.Hover.Visible = false;
                Profiler.defer("UI.Inventory.InformationNavigationDeferred", function() -- Line: 1335
                    -- upvalues: u1 (ref), u183 (copy)
                    u1.SetupInformationFrameNavigation();

                    if u183 then
                        u1.SelectFirstInformationFrameButton();
                    end;
                end);
            end;
        end;
    end;

    u179.MouseButton1Click:Connect(function() -- Line: 1346
        -- upvalues: handleItemSelection (copy)
        handleItemSelection(false);
    end);
    u179.Activated:Connect(function(p196) -- Line: 1349
        -- upvalues: handleItemSelection (copy)
        if p196 and p196.UserInputType == Enum.UserInputType.Gamepad1 then
            handleItemSelection(true);
        end;
    end);

    if u3 then
        u179.MouseEnter:Connect(function() -- Line: 1357
            -- upvalues: u5 (ref), u174 (ref), u6 (ref), u179 (copy), u14 (ref)
            u5 = u174;
            u6 = u179;
            u14 = tick();
        end);
        u179.MouseLeave:Connect(function() -- Line: 1363
            -- upvalues: u6 (ref), u5 (ref), u14 (ref)
            u6 = nil;
            u5 = nil;
            u14 = nil;
        end);
    end;
end;

function u1.UpdateInventory(p197) -- Line: 1373
    -- upvalues: Profiler (copy), u20 (ref), u4 (ref), u7 (ref), u5 (ref), u18 (ref), u2 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy)
    Profiler.mark("UI.Inventory.UpdateInventory");

    if not u20 then
        return;
    end;

    if not p197 or type(p197) ~= "table" then
        print("UpdateInventory received invalid inventory data:", p197);

        return;
    end;

    if not u20.Visible then
        return;
    end;

    local Container = u20.Frame.Right.Container;
    local v198 = {};

    for _, v in ipairs(p197) do
        if v and v._id then
            v198[v._id] = true;
        end;
    end;

    if u4 and (u4._id and not v198[u4._id]) then
        u4 = nil;
        u7 = nil;
        u5 = nil;

        if u18 then
            u18.Visible = false;
        end;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        local v199 = child:IsA("ImageButton");

        if v199 then
            if child.Name == "UIGridLayout" or (child.Name == "UIListLayout" or (child.Name == "UIPadding" or child.Name == "Title")) then
                v199 = false;
            else
                v199 = child.Name ~= "Label";
            end;
        end;

        if v199 and not v198[child.Name] then
            child:Destroy();
        end;
    end;

    Profiler.mark("UI.Inventory.ApplyCurrentSort");

    if not u20 then
        return;
    end;

    if not u20.Visible then
        return;
    end;

    u2 = GetSortedInventoryData();
    u2 = ApplyFilterToSortedData(u2);
    UpdateInventoryTemplates();
end;

function u1.UpdateTemplates(p200) -- Line: 1420
    -- upvalues: Profiler (copy), u20 (ref), GetResolvedSkinInformation (copy), Rarities (copy), GetIconImage (copy), syncItemTemplateCharmIcon (copy), UpdateStatusFrame (copy)
    Profiler.mark("UI.Inventory.UpdateTemplates");

    if not (u20 and u20.Visible) then
        return;
    end;

    local Container = u20.Frame.Right.Container;

    if p200 then
        for _, v in ipairs(p200) do
            local v201 = Container:FindFirstChild(v._id);

            if v201 and v201:IsA("Frame") then
                local v202 = GetResolvedSkinInformation(v.Name, v.Skin);

                if v202 then
                    v201.Main.RarityFrame.UIGradient.Color = Rarities[v202.rarity].ColorSequence;
                    v201.Main.Glow.UIGradient.Color = Rarities[v202.rarity].ColorSequence;
                    v201.Main.Icon.Image = GetIconImage(v, v202, false);
                end;

                syncItemTemplateCharmIcon(v201, v);
                UpdateStatusFrame(v201, v._id);
            end;
        end;
    end;
end;

function u1.SetupInformationFrameNavigation() -- Line: 1449
    -- upvalues: u18 (ref), GetVisibleInformationFrameButtons (copy)
    if not u18 then
        return;
    end;

    local v203 = GetVisibleInformationFrameButtons();
    table.sort(v203, function(p204, p205) -- Line: 1455
        return p204.LayoutOrder < p205.LayoutOrder;
    end);

    for i, v in ipairs(v203) do
        v.NextSelectionUp = v203[i > 1 and i - 1 or #v203];
        v.NextSelectionDown = v203[i < #v203 and i + 1 or 1];
        v.NextSelectionLeft = nil;
        v.NextSelectionRight = nil;
    end;
end;

function u1.SetupItemNotificationNavigation() -- Line: 1472
    -- upvalues: u20 (ref)
    if not (u20 and u20.Ignore.ItemNotification) then
        return;
    end;

    local Holder = u20.Ignore.ItemNotification.Holder;
    local v206;

    if Holder.Left.Visible then
        v206 = Holder.Left;
    else
        v206 = nil;
    end;

    local v207;

    if Holder.Right.Visible then
        v207 = Holder.Right;
    else
        v207 = nil;
    end;

    local v208 = {};

    for _, v in { Holder.ViewLoadout, Holder.Continue } do
        if v and v.Visible then
            table.insert(v208, v);
        end;
    end;

    table.sort(v208, function(p209, p210) -- Line: 1487
        return p209.AbsolutePosition.X < p210.AbsolutePosition.X;
    end);
    local v211 = v208[1];
    local v212 = v208[#v208];

    for i, v in ipairs(v208) do
        v.NextSelectionLeft = v208[i - 1] or v206;
        v.NextSelectionRight = v208[i + 1] or v207;
        v.NextSelectionUp = v207 or v206;
        v.NextSelectionDown = nil;
    end;

    if v206 then
        v206.NextSelectionLeft = nil;
        v206.NextSelectionRight = v207 or v211;
        v206.NextSelectionUp = nil;
        v206.NextSelectionDown = v211;
    end;

    if v207 then
        v207.NextSelectionLeft = v206 or v212;
        v207.NextSelectionRight = nil;
        v207.NextSelectionUp = nil;
        v207.NextSelectionDown = v212;
    end;
end;

function u1.EnsureItemNotificationSelection() -- Line: 1516
    -- upvalues: UserInputService (copy), u20 (ref), GuiService (copy), u1 (copy)
    if not (UserInputService.GamepadEnabled and u20.Ignore.ItemNotification.Visible) then
        return;
    end;

    local Holder = u20.Ignore.ItemNotification.Holder;
    local SelectedObject = GuiService.SelectedObject;

    if SelectedObject and (SelectedObject:IsDescendantOf(Holder) and (SelectedObject:IsA("GuiButton") and SelectedObject.Visible)) then
        return;
    end;

    if SelectedObject == Holder.Left and Holder.Right.Visible then
        GuiService.SelectedObject = Holder.Right;

        return;
    end;

    if SelectedObject == Holder.Right and Holder.Left.Visible then
        GuiService.SelectedObject = Holder.Left;

        return;
    end;

    u1.SelectFirstItemNotificationButton();
end;

function u1.SelectFirstItemNotificationButton() -- Line: 1537
    -- upvalues: UserInputService (copy), u20 (ref), GuiService (copy)
    if not UserInputService.GamepadEnabled then
        return;
    end;

    if not (u20 and (u20.Ignore.ItemNotification and u20.Ignore.ItemNotification.Visible)) then
        return;
    end;

    local Holder = u20.Ignore.ItemNotification.Holder;

    if Holder.ViewLoadout and (Holder.ViewLoadout.Visible and Holder.ViewLoadout.Selectable) then
        GuiService.SelectedObject = Holder.ViewLoadout;

        return;
    end;

    if Holder.Continue and (Holder.Continue.Visible and Holder.Continue.Selectable) then
        GuiService.SelectedObject = Holder.Continue;
    end;
end;

function u1.SelectFirstInformationFrameButton() -- Line: 1561
    -- upvalues: u18 (ref), u1 (copy), GetVisibleInformationFrameButtons (copy), GuiService (copy)
    if not (u18 and u18.Visible) then
        return;
    end;

    u1.SetupInformationFrameNavigation();
    local v213 = GetVisibleInformationFrameButtons()[1];

    if v213 then
        GuiService.SelectedObject = v213;
    end;
end;

function u1.SetupInformationFrame(p214) -- Line: 1576
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), u18 (ref), Cases (copy), GetWeaponProperties (copy), IsEquippedOnTeam (copy)
    Profiler.mark("UI.Inventory.SetupInformationFrame");
    local v215 = DataController.Get(LocalPlayer, "Inventory");

    if v215 then
        local _id = p214._id;
        local v216 = nil;

        for _, v in ipairs(v215) do
            if v._id == _id then
                v216 = v;
                break;
            end;
        end;

        p214 = v216 or p214;
    end;

    local v217 = p214.Type == "Weapon";
    local v218 = p214.Type == "Melee";
    local v219 = p214.Type == "Glove";
    local v220 = p214.Type == "Badge";
    local v221 = p214.Type == "Zeus x27";
    u18.Inspect.Visible = v217 or (v219 or (v218 or (v221 or (p214.Type == "Charm" and true or v220))));
    local v222;

    if p214.Type == "Case" then
        v222 = Cases.GetCaseByName(p214.Skin);
    else
        v222 = nil;
    end;

    local Unlock = u18.Unlock;
    local v223;

    if p214.Type == "Package" then
        v223 = true;
    elseif v222 == nil then
        v223 = false;
    else
        v223 = Cases.HasCaseModel(v222.caseId);
    end;

    Unlock.Visible = v223;
    u18.Loadout.Visible = false;
    local QuickUnlock = u18:FindFirstChild("QuickUnlock");

    if QuickUnlock then
        QuickUnlock.Visible = false;
    end;

    local UnlockDivider = u18:FindFirstChild("UnlockDivider");

    if UnlockDivider then
        UnlockDivider.Visible = false;
    end;

    local v224 = v217 or (v221 or p214.Type == "Charm");

    if not u18.Charm then
        warn("[Inventory] InformationFrame.Charm element not found - item type:", p214.Type);
    end;

    if u18.Charm then
        u18.Charm.Visible = v224;
        local v225 = v224 and u18.Charm:FindFirstChildWhichIsA("TextLabel", true);

        if v225 then
            if p214.Type == "Charm" then
                v225.Text = "Attach to Weapon";
            else
                local Charm = p214.Charm;
                local v226;

                if Charm == nil or Charm == false then
                    v226 = false;
                else
                    v226 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
                end;

                v225.Text = v226 and "Detach Charm" or "Attach Charm";
            end;
        end;
    end;

    local u227 = false;
    local u228 = false;

    local function applyTeamRestriction(p229: string?) -- Line: 1631
        -- upvalues: u227 (ref), u228 (ref)
        u227 = p229 == "Both" and true or p229 == "Counter-Terrorists";
        u228 = p229 == "Both" and true or p229 == "Terrorists";
    end;

    if v217 then
        local success, result = pcall(GetWeaponProperties, p214.Name);

        if success and result then
            local Team = result.Team;
            u227 = Team == "Both" and true or Team == "Counter-Terrorists";
            u228 = Team == "Both" and true or Team == "Terrorists";
        end;
    elseif v218 then
        if p214.Name == "T Knife" then
            u227 = false;
        else
            u227 = true;
        end;

        if p214.Name == "CT Knife" then
            u228 = false;
        else
            u228 = true;
        end;
    elseif v219 then
        local v230 = GetWeaponProperties(p214.Name);

        if v230 then
            local Team = v230.Team;
            u227 = Team == "Both" and true or Team == "Counter-Terrorists";
            u228 = Team == "Both" and true or Team == "Terrorists";
        end;
    elseif v220 or v221 then
        u227 = true;
        u228 = true;
    end;

    local v231 = IsEquippedOnTeam(p214._id, "Counter-Terrorists");
    local v232 = IsEquippedOnTeam(p214._id, "Terrorists");
    local v233 = v217 or (v218 or (v219 or (v220 or v221)));

    if u18.ReplaceCT then
        u18.ReplaceCT.Visible = v233 and u227 and not v231;
    end;

    if u18.ReplaceT then
        u18.ReplaceT.Visible = v233 and u228 and not v232;
    end;

    local v234 = {
        {
            dividerName = "CharmDivider",
            action = u18.Charm
        },
        {
            dividerName = "InspectDivider",
            action = u18.Inspect
        },
        {
            dividerName = "ReplaceCTDivider",
            action = u18.ReplaceCT
        },
        {
            dividerName = "ReplaceTDivider",
            action = u18.ReplaceT
        },
        {
            dividerName = "LoadoutDivider",
            action = u18.Loadout
        }
    };
    local v235 = {
        UnlockDivider = true
    };

    for _, v in ipairs(v234) do
        v235[v.dividerName] = true;
    end;

    for _, v in ipairs(v234) do
        local v236 = u18:FindFirstChild(v.dividerName);

        if v236 and v.action then
            local v237 = false;

            if v.action.Visible then
                local v238 = v;

                for _, child in ipairs(u18:GetChildren()) do
                    if not (v235[child.Name] or (child == v236 or (child == v238.action or not (child:IsA("Frame") or child:IsA("TextButton")))) or (child.LayoutOrder >= v236.LayoutOrder or not child.Visible)) then
                        v237 = true;
                        break;
                    end;
                end;
            end;

            v236.Visible = v237;
        end;
    end;
end;

function u1.ShowNewItemNotification(p239) -- Line: 1710
    -- upvalues: Profiler (copy), u24 (copy), u29 (ref), u20 (ref), u30 (ref), u1 (copy), u8 (ref), syncInventoryUpdate (copy)
    Profiler.mark("UI.Inventory.ShowNewItemNotification");
    local _id = p239._id;
    local v240 = nil;

    for i, v in ipairs(u24) do
        if v._id == _id then
            v240 = i;
            break;
        end;
    end;

    if v240 then
        u29 = nil;

        if u20.Visible then
            u30 = p239._id;
            u1.NextInventoryItem(v240);
        else
            u8 = v240 - 1;
        end;
    else
        u29 = p239._id;
    end;

    u20.Visible = true;
    syncInventoryUpdate();
end;

function u1.NextInventoryItem(p241: number) -- Line: 1736
    -- upvalues: Profiler (copy), u24 (copy), u8 (ref), u25 (copy), u26 (copy), u28 (ref), ReportViewedItems (copy), Cases (copy), GetResolvedSkinInformation (copy), Rarities (copy), GetSkinDisplayName (copy), GetIconImage (copy), u20 (ref), u32 (ref), Router (copy), u1 (copy), syncInventoryUpdate (copy)
    Profiler.mark("UI.Inventory.NextInventoryItem");
    local v242 = u24[p241];
    u8 = p241;

    if v242 then
        local _id = v242._id;

        if not u25[_id] then
            u25[_id] = true;
            u26[_id] = true;

            if not u28 then
                u28 = true;
                task.delay(2, function() -- Line: 558
                    -- upvalues: u28 (ref), ReportViewedItems (ref)
                    u28 = false;
                    ReportViewedItems();
                end);
            end;
        end;

        local v243 = v242.Type == "Case" and true or v242.Type == "Package";
        local v244 = v243 and Cases.GetCaseByName(v242.Skin) or GetResolvedSkinInformation(v242.Name, v242.Skin);
        local v245 = Rarities[v244 and (v243 and v244.caseRarity or v244.rarity) or (v242.Rarity or "Blue")] or Rarities.Blue;
        local v246;

        if v243 and (v244 and v244.Skin) then
            v246 = v244.Skin;
        else
            local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(v242.Name, v242.NameTag);

            if v242.StatTrack then
                WeaponDisplayName = "KillTrak™ " .. WeaponDisplayName or WeaponDisplayName;
            end;

            v246 = `{WeaponDisplayName} | {v242.Skin}`;
        end;

        local v247 = GetIconImage(v242, v244, v243);
        local v248;

        if v242.Type == "Case" then
            v248 = false;
        else
            v248 = v242.Type ~= "Package";
        end;

        u20.Ignore.ItemNotification.Holder.ViewLoadout.Visible = v248;
        u20.Ignore.ItemNotification.Holder.RarityFrame.UIGradient.Color = v245.ColorSequence;
        u20.Ignore.ItemNotification.Holder.Background.ImageColor3 = v245.Color;
        u20.Ignore.ItemNotification.Holder.IconShadow.Image = v247;
        u20.Ignore.ItemNotification.Holder.Light.ImageColor3 = v245.Color;
        GetSkinDisplayName.ApplyNameLabel(u20.Ignore.ItemNotification.Holder.WeaponName, v246, v242.NameTag);
        u20.Ignore.ItemNotification.Holder.Icon.Image = v247;
        u20.Ignore.ItemNotification.Visible = true;

        if not u32 then
            u32 = true;
            Router.broadcastRouter("RunInterfaceSound", "New Item Reveal");
        end;

        u20.Ignore.ItemNotification.Holder.Title.TextColor3 = Color3.new(v245.Color.R * 0.56, v245.Color.G * 0.56, v245.Color.B * 0.56);
        Profiler.defer("UI.Inventory.ItemNotificationDeferred", function() -- Line: 1785
            -- upvalues: u1 (ref)
            u1.SetupItemNotificationNavigation();
            u1.EnsureItemNotificationSelection();
        end);
        syncInventoryUpdate();
    end;
end;

local u249 = {
    Blue = 1,
    Purple = 2,
    Pink = 3,
    Red = 4,
    Special = 5,
    Forbidden = 6,
    Stock = 7
};
local u250 = {
    Blue = "Blue",
    Purple = "Purple",
    Pink = "Pink",
    Red = "Red",
    Special = "★ Special",
    Forbidden = "★ Special"
};

local function ClearHoverCollectionFrames(p251: userdata) -- Line: 1815
    for _, child in ipairs(p251:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "UIListLayout" then
            child:Destroy();
        end;
    end;
end;

local function HideHoverCollection() -- Line: 1823
    -- upvalues: u20 (ref), ClearHoverCollectionFrames (copy)
    local Collection = u20.Ignore.Hover.Collection;

    if Collection then
        ClearHoverCollectionFrames(Collection);
        Collection.Visible = false;
    end;

    u20.Ignore.Hover.CollectionName.Visible = false;
    u20.Ignore.Hover.CollectionSpacer.Visible = false;
end;

local function ShowHoverCollection(p252: any, p253: userdata) -- Line: 1833
    -- upvalues: u20 (ref), DataController (copy), LocalPlayer (copy), ClearHoverCollectionFrames (copy), GetResolvedSkinInformation (copy), u249 (copy), ReplicatedStorage (copy), Rarities (copy)
    local Collection = u20.Ignore.Hover.Collection;
    local v254 = DataController.Get(LocalPlayer, "Inventory");
    ClearHoverCollectionFrames(Collection);
    local v255 = {};

    if v254 then
        for _, v in ipairs(v254) do
            if v.Name and v.Skin then
                v255[v.Name .. "|" .. v.Skin] = true;
            end;
        end;
    end;

    local v256 = {};

    for _, v in ipairs(p252.items) do
        if v.itemName and v.skinName then
            local v257 = GetResolvedSkinInformation(v.itemName, v.skinName);

            if v257 then
                table.insert(v256, {
                    item = v,
                    rarity = v257.rarity,
                    rarityOrder = u249[v257.rarity] or 99
                });
            end;
        end;
    end;

    table.sort(v256, function(p258, p259) -- Line: 1862
        if p258.rarityOrder == p259.rarityOrder then
            return p258.item.itemName < p259.item.itemName;
        end;

        return p258.rarityOrder < p259.rarityOrder;
    end);
    local CollectionNameTemplate = ReplicatedStorage.Assets.UI.Inventory.CollectionNameTemplate;

    for i, v in ipairs(v256) do
        local item = v.item;
        local v260 = GetResolvedSkinInformation(item.itemName, item.skinName);

        if v260 and CollectionNameTemplate then
            local v261 = CollectionNameTemplate:Clone();
            v261.Parent = Collection;
            v261.LayoutOrder = i;
            v261.Visible = true;
            local gun = v261.gun;
            gun.Text = "[" .. item.itemName .. "] | " .. item.skinName;
            local v262 = v260.rarity and Rarities[v260.rarity];

            if v262 then
                gun.TextColor3 = v262.Color;
            end;

            gun.Visible = true;
            v261.ImageLabel.Visible = v255[item.itemName .. "|" .. item.skinName] == true;
        end;
    end;

    p253.Visible = true;
    Collection.Visible = true;
    u20.Ignore.Hover.CollectionSpacer.Visible = true;
end;

function u1.UpdateHoverFrame(p263: number) -- Line: 1897
    -- upvalues: u14 (ref), Mouse (copy), u20 (ref), u19 (ref), u18 (ref), u6 (ref), u5 (ref), CalculateHoverPosition (copy), Cases (copy), GetResolvedSkinInformation (copy), GetSkinDisplayName (copy), u33 (copy), GetCollectionNameForItem (copy), Collections (copy), ShowHoverCollection (copy), ClearHoverCollectionFrames (copy), Rarities (copy), u250 (copy), Skins (copy), GetWeaponProperties (copy)
    local v264 = tick() - (u14 or 0);
    local Vector2_new_ret = Vector2.new(Mouse.X, Mouse.Y);
    local v265;

    if u20.Ignore.ItemNotification.Visible then
        v265 = true;
    else
        local v266 = u19;

        if v266 and v266.Visible then
            local AbsolutePosition = v266.AbsolutePosition;
            local AbsoluteSize = v266.AbsoluteSize;

            if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
                v265 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
            else
                v265 = false;
            end;
        else
            v265 = false;
        end;

        if not v265 then
            local v267 = u18;

            if v267 and v267.Visible then
                local AbsolutePosition = v267.AbsolutePosition;
                local AbsoluteSize = v267.AbsoluteSize;

                if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
                    v265 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                else
                    v265 = false;
                end;
            else
                v265 = false;
            end;
        end;
    end;

    if not u20.Visible or (v265 or (u18.Visible or not (u6 and (u5 and v264 > 0.75)))) then
        u20.Ignore.Hover.Visible = false;

        return;
    end;

    u20.Ignore.Hover.Position = CalculateHoverPosition(u6);
    local v268 = u5;
    local v269 = v268.Type == "Case" and true or v268.Type == "Package";
    local v270 = v269 and Cases.GetCaseByName(v268.Skin) or GetResolvedSkinInformation(v268.Name, v268.Skin);

    if v270 then
        local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(v268.Name, v268.NameTag);
        local v271 = v269 and v270.caseType and u33[v270.caseType] or v269 and v270.caseType;

        if v271 then
            WeaponDisplayName = v271;
        elseif v268.StatTrack then
            WeaponDisplayName = "KillTrak™ " .. WeaponDisplayName or WeaponDisplayName;
        end;

        local v272 = (v268.Type == "Melee" and "★ " or "") .. WeaponDisplayName;
        local v273 = GetSkinDisplayName(v269 and v270.skin or v268.Skin);
        GetSkinDisplayName.ApplyNameLabel(u20.Ignore.Hover.ItemName.Frame.ItemName, v272 .. (v273 == "Vanilla" and "" or " | " .. v273), v268.NameTag);
        local v274 = GetCollectionNameForItem(v268);
        u20.Ignore.Hover.ItemName.Frame.Collection.Text = v274 or "";
        local CollectionIcon = u20.Ignore.Hover.ItemName.CollectionIcon;
        local v275;

        if v274 then
            v275 = Collections.GetCollectionByName(v274);
        else
            v275 = v274;
        end;

        if v275 and v275.imageAssetId then
            CollectionIcon.Image = v275.imageAssetId;
            CollectionIcon.Visible = true;
        else
            CollectionIcon.Visible = false;
        end;

        local CollectionName = u20.Ignore.Hover.CollectionName;

        if v274 then
            CollectionName.Text = v274 .. ":";
            CollectionName.Visible = true;
        else
            CollectionName.Visible = false;
        end;

        local v276 = v274 and not v269 and Collections.GetCollectionByName(v274);

        if v276 and v276.items then
            ShowHoverCollection(v276, CollectionName);
        else
            local Collection = u20.Ignore.Hover.Collection;

            if Collection then
                ClearHoverCollectionFrames(Collection);
                Collection.Visible = false;
            end;

            u20.Ignore.Hover.CollectionName.Visible = false;
            u20.Ignore.Hover.CollectionSpacer.Visible = false;
        end;

        local v277;

        if v269 or v268.Type ~= "Weapon" and (v268.Type ~= "Melee" and (v268.Type ~= "Glove" and v268.Type ~= "Zeus x27")) then
            v277 = v270.description;
        else
            v277 = GetResolvedSkinInformation(v268.Type == "Melee" and "T Knife" or (v268.Type == "Glove" and "T Glove" or v268.Name), "Stock");

            if v277 then
                v277 = v277.description;
            end;
        end;

        u20.Ignore.Hover.Description.Text = v277 or "";
        u20.Ignore.Hover.Information.Visible = not (v269 or (v268.Type == "Charm Capsule" and true or v268.Type == "Sticker Capsule"));
        local v278 = v269 and v270.caseRarity or v270.rarity;
        local v279;

        if v278 then
            v279 = Rarities[v278];
        else
            v279 = v278;
        end;

        if v279 then
            u20.Ignore.Hover.Information.Rarity.Label.Text = u250[v278] or v278;
            u20.Ignore.Hover.Information.Rarity.Label.TextColor3 = v279.Color;
        else
            u20.Ignore.Hover.Information.Rarity.Label.Text = "";
        end;

        local Exterior = u20.Ignore.Hover.Information.Exterior;
        local v280, v281;

        if v269 then
            v280 = nil;
            v281 = nil;
        else
            v280, v281 = Skins.GetWearNameForFloat(v270, v268.Float or v270.floatRange.max);
        end;

        if v280 and v281 then
            Exterior.Label.Text = v281;
            Exterior.Visible = true;
        else
            Exterior.Visible = false;
        end;

        local Team = u20.Ignore.Hover.Information.Team.Team;
        local v282 = nil;

        if v268.Type == "Melee" or (v268.Type == "Glove" or (v268.Type == "Badge" or (v268.Type == "Charm" or v268.Type == "Zeus x27"))) then
            v282 = "Both";
        elseif v268.Type == "Weapon" then
            local v283 = GetWeaponProperties(v268.Name);

            if v283 then
                v283 = v283.Team;
            end;

            if v283 then
                v282 = v283 ~= "Counter-Terrorists" and v283 ~= "Terrorists" and "Both" or v283;
            end;
        end;

        if v282 then
            Team.CT.Visible = v282 ~= "Terrorists";
            Team.T.Visible = v282 ~= "Counter-Terrorists";
            Team.Label.Visible = true;
            Team.Label.Text = v282;
        end;
    end;

    u20.Ignore.Hover.Visible = true;
end;

function u1.Initialize(p284, p285) -- Line: 2046
    -- upvalues: Profiler (copy), u21 (ref), u20 (ref), u18 (ref), CloseButtonRegistry (copy), Router (copy), u7 (ref), GuiService (copy), Collections (copy), u10 (ref), u4 (ref), ActivateButton (copy), Remotes (copy), UseItemFrame (copy), MenuState (copy), u13 (ref), Cases (copy), Store (copy), ReplaceItemOnTeam (copy), u8 (ref), u24 (copy), u1 (copy), UserInputService (copy), LocalPlayer (copy), DismissItemNotifications (copy), Loadout (copy), u19 (ref), BindSortDropdownFocus (copy), u11 (ref), u12 (ref), u2 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy), BindSearchTap (copy), DataController (copy), GetResolvedSkinInformation (copy), Rarities (copy), GetIconImage (copy), GetWeaponProperties (copy), syncItemTemplateCharmIcon (copy), GetSkinDisplayName (copy), TweenService (copy), u3 (copy), u5 (ref), u6 (ref), u14 (ref), Sort (copy), u34 (copy), u32 (ref), SetSearchTokens (copy), u22 (ref), ContentProvider (copy), u17 (copy), syncInventoryUpdate (copy), u30 (ref), ReportViewedItems (copy), OnScrollPositionChanged (copy)
    Profiler.mark("UI.Inventory.Initialize");
    u21 = p284;
    u20 = p285;
    u18 = p285.Ignore.Information;
    CloseButtonRegistry.Add(u18, nil, function() -- Line: 2052
        -- upvalues: Router (ref), u18 (ref), u7 (ref), GuiService (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u18.Visible = false;

        if u7 and u7:FindFirstChild("Button") then
            local Button = u7:FindFirstChild("Button");

            if Button and Button:IsA("GuiButton") then
                GuiService.SelectedObject = Button;
            end;
        end;
    end);
    Collections.ObserveAvailableCollections(function(p286) -- Line: 2065
        -- upvalues: u10 (ref)
        u10 = p286;
    end);
    u18.Inspect.Selectable = true;

    local function handleInspectClick() -- Line: 2071
        -- upvalues: Router (ref), u4 (ref), u18 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if u4 then
            u18.Visible = false;
            local v287 = u4;
            Router.broadcastRouter("WeaponInspect", v287.Name, v287.Skin, v287.Float, v287.StatTrack, v287.NameTag, v287.Charm, v287.Stickers, v287.Type, v287.Pattern, v287._id, v287.Serial, v287.IsTradeable);
        end;
    end;

    ActivateButton(u18.Inspect);
    local Inspect = u18.Inspect;
    Inspect.MouseButton1Click:Connect(handleInspectClick);
    Inspect.Activated:Connect(function(p288) -- Line: 1149
        -- upvalues: handleInspectClick (copy)
        if p288 and p288.UserInputType == Enum.UserInputType.Gamepad1 then
            handleInspectClick();
        end;
    end);

    if u18.Charm then
        u18.Charm.Selectable = true;

        local function handleCharmClick() -- Line: 2084
            -- upvalues: Router (ref), u4 (ref), u18 (ref), Remotes (ref), u20 (ref), UseItemFrame (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u4 then
                local Charm = u4.Charm;
                local v289;

                if Charm == nil or Charm == false then
                    v289 = false;
                else
                    v289 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
                end;

                u18.Visible = false;

                if v289 then
                    Remotes.Inventory.RemoveWeaponCharm.Send({
                        WeaponId = u4._id
                    });

                    return;
                end;

                u20.Visible = false;
                UseItemFrame.TriggerAction("AttachCharm", u4);
            end;
        end;

        local Charm = u18.Charm;
        Charm.MouseButton1Click:Connect(handleCharmClick);
        Charm.Activated:Connect(function(p290) -- Line: 1149
            -- upvalues: handleCharmClick (copy)
            if p290 and p290.UserInputType == Enum.UserInputType.Gamepad1 then
                handleCharmClick();
            end;
        end);
    end;

    UseItemFrame.OnItemSelected:Connect(function(p291, p292) -- Line: 2101
        -- upvalues: UseItemFrame (ref)
        local v293 = UseItemFrame.GetActions().Get(p292.ActionType);

        if v293 then
            v293.OnItemSelected(p291, p292);
        end;
    end);
    UseItemFrame.OnClosed:Connect(function(p294) -- Line: 2110
        -- upvalues: MenuState (ref), u20 (ref)
        if MenuState.GetCurrentScreen() == "Inventory" then
            u20.Visible = true;
        end;
    end);
    u18.Unlock.Selectable = true;

    local function handleUnlockClick() -- Line: 2119
        -- upvalues: u13 (ref), Router (ref), u4 (ref), Cases (ref), Store (ref), u18 (ref), u20 (ref)
        if u13 then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if u4 then
            local CaseByName = Cases.GetCaseByName(u4.Skin);

            if not (CaseByName and Cases.HasCaseModel(CaseByName.caseId)) then
                return;
            end;

            Store.OpenCaseContent(CaseByName.caseId, "Open", u4._id);
            u18.Visible = false;
            u20.Visible = false;
        end;
    end;

    local Unlock = u18.Unlock;
    Unlock.MouseButton1Click:Connect(handleUnlockClick);
    Unlock.Activated:Connect(function(p295) -- Line: 1149
        -- upvalues: handleUnlockClick (copy)
        if p295 and p295.UserInputType == Enum.UserInputType.Gamepad1 then
            handleUnlockClick();
        end;
    end);

    local function setupReplaceButton(p296: userdata?, u297: string) -- Line: 2137
        -- upvalues: Router (ref), u4 (ref), u18 (ref), ReplaceItemOnTeam (ref)
        if not p296 then
            return;
        end;

        p296.Selectable = true;

        local function u298() -- Line: 2143
            -- upvalues: Router (ref), u4 (ref), u18 (ref), ReplaceItemOnTeam (ref), u297 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u4 then
                u18.Visible = false;
                ReplaceItemOnTeam(u4, u297);
            end;
        end;

        p296.MouseButton1Click:Connect(u298);
        p296.Activated:Connect(function(p299) -- Line: 1149
            -- upvalues: u298 (copy)
            if p299 and p299.UserInputType == Enum.UserInputType.Gamepad1 then
                u298();
            end;
        end);
    end;

    local ReplaceT = u18.ReplaceT;

    if ReplaceT then
        ReplaceT.Selectable = true;
        local u300 = "Terrorists";

        local function u301() -- Line: 2143
            -- upvalues: Router (ref), u4 (ref), u18 (ref), ReplaceItemOnTeam (ref), u300 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u4 then
                u18.Visible = false;
                ReplaceItemOnTeam(u4, u300);
            end;
        end;

        ReplaceT.MouseButton1Click:Connect(u301);
        ReplaceT.Activated:Connect(function(p302) -- Line: 1149
            -- upvalues: u301 (copy)
            if p302 and p302.UserInputType == Enum.UserInputType.Gamepad1 then
                u301();
            end;
        end);
    end;

    local ReplaceCT = u18.ReplaceCT;

    if ReplaceCT then
        ReplaceCT.Selectable = true;
        local u303 = "Counter-Terrorists";

        local function u304() -- Line: 2143
            -- upvalues: Router (ref), u4 (ref), u18 (ref), ReplaceItemOnTeam (ref), u303 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u4 then
                u18.Visible = false;
                ReplaceItemOnTeam(u4, u303);
            end;
        end;

        ReplaceCT.MouseButton1Click:Connect(u304);
        ReplaceCT.Activated:Connect(function(p305) -- Line: 1149
            -- upvalues: u304 (copy)
            if p305 and p305.UserInputType == Enum.UserInputType.Gamepad1 then
                u304();
            end;
        end);
    end;

    local ItemNotification = u20.Ignore.ItemNotification;

    local function stepItemNotification(p306: number) -- Line: 2157
        -- upvalues: u8 (ref), u24 (ref), Router (ref), u1 (ref)
        local v307 = u8 + p306;

        if v307 >= 1 and v307 <= #u24 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(v307);
        end;
    end;

    ItemNotification.Holder.Left.Selectable = true;
    ItemNotification.Holder.Right.Selectable = true;
    ItemNotification.Holder.Left.MouseButton1Click:Connect(function() -- Line: 2167
        -- upvalues: u8 (ref), u24 (ref), Router (ref), u1 (ref)
        local v308 = u8 + -1;

        if v308 >= 1 and v308 <= #u24 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(v308);
        end;
    end);
    ItemNotification.Holder.Right.MouseButton1Click:Connect(function() -- Line: 2170
        -- upvalues: u8 (ref), u24 (ref), Router (ref), u1 (ref)
        local v309 = u8 + 1;

        if v309 >= 1 and v309 <= #u24 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(v309);
        end;
    end);
    MenuState.RegisterBumperOverride(ItemNotification, function(p310: boolean) -- Line: 2176
        -- upvalues: u8 (ref), u24 (ref), Router (ref), u1 (ref)
        local v311 = u8 + (p310 and -1 or 1);

        if v311 >= 1 and v311 <= #u24 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(v311);
        end;

        return true;
    end, ItemNotification);
    UserInputService.InputBegan:Connect(function(p312: userdata, p313: boolean) -- Line: 2182
        -- upvalues: LocalPlayer (ref), UserInputService (ref), u20 (ref), u8 (ref), u24 (ref), Router (ref), u1 (ref)
        if p313 or (LocalPlayer:GetAttribute("IsPlayerChatting") or (UserInputService:GetFocusedTextBox() or not (u20 and (u20.Ignore.ItemNotification and u20.Ignore.ItemNotification.Visible)))) then
            return;
        end;

        if p312.KeyCode == Enum.KeyCode.Left then
            local v314 = u8 + -1;

            if v314 >= 1 and v314 <= #u24 then
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u1.NextInventoryItem(v314);
            end;

            return;
        end;

        if p312.KeyCode ~= Enum.KeyCode.Right then
            return;
        end;

        local v315 = u8 + 1;

        if v315 >= 1 and v315 <= #u24 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(v315);
        end;
    end);
    u20.Ignore.ItemNotification.Holder.Continue.Selectable = true;
    u20.Ignore.ItemNotification.Holder.ViewLoadout.Selectable = true;

    local function handleContinueClick() -- Line: 2208
        -- upvalues: Router (ref), DismissItemNotifications (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        DismissItemNotifications();
    end;

    local Continue = u20.Ignore.ItemNotification.Holder.Continue;
    Continue.MouseButton1Click:Connect(handleContinueClick);
    Continue.Activated:Connect(function(p316) -- Line: 1149
        -- upvalues: handleContinueClick (copy)
        if p316 and p316.UserInputType == Enum.UserInputType.Gamepad1 then
            handleContinueClick();
        end;
    end);

    local function handleViewLoadoutClick() -- Line: 2215
        -- upvalues: u24 (ref), u8 (ref), Router (ref), DismissItemNotifications (ref), u20 (ref), Loadout (ref)
        local v317 = u24[u8];
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        DismissItemNotifications();

        if v317 and (v317.Type == "Melee" or (v317.Type == "Glove" or (v317.Type == "Weapon" or v317.Type == "Zeus x27"))) then
            u20.Visible = false;
            Loadout.ViewInLoadout(v317._id);
        end;
    end;

    local ViewLoadout = u20.Ignore.ItemNotification.Holder.ViewLoadout;
    ViewLoadout.MouseButton1Click:Connect(handleViewLoadoutClick);
    ViewLoadout.Activated:Connect(function(p318) -- Line: 1149
        -- upvalues: handleViewLoadoutClick (copy)
        if p318 and p318.UserInputType == Enum.UserInputType.Gamepad1 then
            handleViewLoadoutClick();
        end;
    end);
    local Filter = u20.Frame.Right.Top.Filter;
    local DropdownContent = Filter.DropdownContent;
    u19 = DropdownContent;
    Filter.Active = true;
    Filter.Selectable = true;
    local v319 = u19;

    if v319 then
        v319.Visible = false;
        v319.Active = false;
        local Scroll = v319:FindFirstChild("Scroll");

        if Scroll and Scroll:IsA("GuiObject") then
            Scroll.Visible = false;
            Scroll.Active = false;
        end;
    end;

    Filter.Activated:Connect(function() -- Line: 2245, Name: handleSortButtonClick
        -- upvalues: DropdownContent (copy), u19 (ref), Router (ref)
        local v320 = not DropdownContent.Visible;
        local v321 = u19;

        if v321 then
            v321.Visible = v320;
            v321.Active = v320;
            local Scroll = v321:FindFirstChild("Scroll");

            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = v320;
                Scroll.Active = v320;
            end;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    BindSortDropdownFocus(DropdownContent, Filter, function() -- Line: 2251
        -- upvalues: u11 (ref), Filter (copy)
        return u11 or Filter.Container.Left.Title.Text;
    end, "UI.Inventory.SortFocusDeferred");
    local ReverseSort = u20.Frame.Right.Top.ReverseSort;

    local function handleReverseSortButtonClick() -- Line: 2257
        -- upvalues: u12 (ref), ReverseSort (copy), Profiler (ref), u20 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), Router (ref)
        u12 = not u12;
        local v322 = u12;
        local v323 = ReverseSort:FindFirstChildOfClass("ImageLabel");

        if v323 then
            v323.Rotation = v322 and 180 or 0;
        end;

        Profiler.mark("UI.Inventory.ApplyCurrentSort");

        if u20 and u20.Visible then
            u2 = GetSortedInventoryData();
            u2 = ApplyFilterToSortedData(u2);
            UpdateInventoryTemplates();
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end;

    ReverseSort.Selectable = true;
    ReverseSort.Activated:Connect(handleReverseSortButtonClick);

    for _, v in { "Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float", "Serial" } do
        local u324 = DropdownContent.Scroll:FindFirstChild(v);

        if u324 then
            local Scroll = DropdownContent.Scroll;
            local Title = Filter.Container.Left.Title;

            local function u326() -- Line: 2274
                -- upvalues: u19 (ref)
                local v325 = u19;

                if not v325 then
                    return;
                end;

                v325.Visible = false;
                v325.Active = false;
                local Scroll2 = v325:FindFirstChild("Scroll");

                if Scroll2 and Scroll2:IsA("GuiObject") then
                    Scroll2.Visible = false;
                    Scroll2.Active = false;
                end;
            end;

            u324.Selectable = true;

            local function u327() -- Line: 1167
                -- upvalues: Router (ref), u18 (ref), u11 (ref), v (copy), Profiler (ref), u20 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), Title (copy), Scroll (copy), u324 (copy), u326 (copy)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");

                if u18 then
                    u18.Visible = false;
                end;

                u11 = v;
                Profiler.mark("UI.Inventory.ApplyCurrentSort");

                if u20 and u20.Visible then
                    u2 = GetSortedInventoryData();
                    u2 = ApplyFilterToSortedData(u2);
                    UpdateInventoryTemplates();
                end;

                Title.Text = v;

                for _, child in ipairs(Scroll:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.Frame.BackgroundTransparency = child == u324 and 0 or 1;
                    end;
                end;

                u326();
            end;

            u324.MouseButton1Click:Connect(u327);
            u324.Activated:Connect(function(p328) -- Line: 1149
                -- upvalues: u327 (copy)
                if p328 and p328.UserInputType == Enum.UserInputType.Gamepad1 then
                    u327();
                end;
            end);
        end;
    end;

    local Title = u20.Frame.Right.Top.Search.Container.Container.Title;
    BindSearchTap(u20.Frame.Right.Top.Search, Title);
    local TradeUp = u20.Frame.Right.Top.TradeUp;
    local TradeUp2 = u20.Frame.TradeUp;
    local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local Container = TradeUp2.TradeContainer.Container;
    local ItemTemplate = Container.ItemTemplate;
    local Exchange = TradeUp2.TradeContainer.Exchange;
    local ItemTemplate2 = Exchange.ItemTemplate;
    local AddTemplate = Exchange.AddTemplate;
    ItemTemplate.Visible = false;
    ItemTemplate2.Visible = false;
    AddTemplate.Visible = false;
    local u329 = {
        Blue = true,
        Purple = true,
        Pink = true
    };
    local u330 = {
        Blue = "Purple",
        Purple = "Pink",
        Pink = "Red"
    };
    local u331 = { "Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float", "Serial" };

    for _, v in { ItemTemplate, ItemTemplate2, AddTemplate } do
        local v332 = v;

        for _, descendant in ipairs(v:GetDescendants()) do
            if descendant:IsA("GuiObject") then
                descendant.Active = false;

                if descendant:IsA("GuiButton") then
                    descendant.Interactable = false;
                    descendant.Selectable = false;
                end;
            end;
        end;

        if not v332:FindFirstChildOfClass("UIScale") then
            Instance.new("UIScale").Parent = v332;
        end;
    end;

    for _, v in { ItemTemplate, ItemTemplate2 } do
        local Context = v:FindFirstChild("Context");

        if Context and Context:IsA("GuiObject") then
            Context.Visible = false;
        end;
    end;

    for _, v in { Container, Exchange } do
        local v333 = v:FindFirstChildOfClass("UIGridLayout");

        if v333 then
            v333.SortOrder = Enum.SortOrder.LayoutOrder;
        end;
    end;

    local u334 = nil;

    for _, child in ipairs(TradeUp2.Warning:GetChildren()) do
        if child.Name == "WarningForTradeUp" then
            local Container2 = child:FindFirstChild("Container");
            local v335 = Container2 and Container2:FindFirstChild("Left");

            if v335 then
                v335 = v335:FindFirstChild("Title");
            end;

            if v335 and (v335:IsA("TextLabel") and string.find(v335.Text, "Selected For Exchange", 1, true)) then
                u334 = v335;
                break;
            end;
        end;
    end;

    local u336 = "Newest";
    local u337 = false;
    local u338 = {};
    local u339 = {};
    local u340 = nil;
    local u341 = nil;
    local u342 = nil;
    local u343 = {};
    local u344 = true;
    DataController.CreateListener(LocalPlayer, "Inventory", function() -- Line: 2375
        -- upvalues: u344 (ref)
        u344 = true;
    end);

    local function getTradeUpSearchable(p345) -- Line: 2380
        local string_lower_ret = string.lower((p345.Name or "") .. " " .. (p345.Skin or ""));

        if string.find(string_lower_ret, "zeus", 1, true) then
            string_lower_ret = string_lower_ret .. " taser";
        end;

        return string_lower_ret;
    end;

    local function tradeUpMatchesSearch(p346: string) -- Line: 2388
        -- upvalues: u338 (copy)
        if #u338 == 0 then
            return true;
        end;

        for _, v in ipairs(u338) do
            if string.find(p346, v, 1, true) == nil then
                return false;
            end;
        end;

        return true;
    end;

    local u347 = {};
    Collections.ObserveAvailableCollections(function() -- Line: 2402
        -- upvalues: u347 (copy), u344 (ref)
        table.clear(u347);
        u344 = true;
    end);

    local function collectionHasNextTier(p348: string?, p349: string) -- Line: 2406
        -- upvalues: u330 (copy), u10 (ref), u347 (copy), GetResolvedSkinInformation (ref)
        if not p348 or p348 == "" then
            return false;
        end;

        local v350 = u330[p349];

        if not v350 then
            return false;
        end;

        if not u10 then
            return false;
        end;

        local v351 = p348 .. "|" .. v350;
        local v352 = u347[v351];

        if v352 ~= nil then
            return v352;
        end;

        local v353 = false;

        for _, v in ipairs(u10) do
            if v.name == p348 then
                for _, v2 in ipairs(v.items or {}) do
                    local v354 = GetResolvedSkinInformation(v2.itemName, v2.skinName);

                    if v354 and v354.rarity == v350 then
                        v353 = true;
                        break;
                    end;
                end;

                break;
            end;
        end;

        u347[v351] = v353;

        return v353;
    end;

    local u355 = {};

    local function getEligibleTradeUpInfo(p356) -- Line: 2442
        -- upvalues: u355 (copy), GetResolvedSkinInformation (ref), u329 (copy), collectionHasNextTier (copy)
        if p356.Type ~= "Weapon" and p356.Type ~= "Zeus x27" then
            return nil;
        end;

        local v357 = (p356.Name or "") .. "|" .. (p356.Skin or "");
        local v358 = u355[v357];

        if v358 == nil then
            v358 = GetResolvedSkinInformation(p356.Name, p356.Skin);

            if v358 then
                u355[v357] = v358;
            end;
        end;

        if not v358 then
            return nil;
        end;

        local rarity = v358.rarity;

        if not (rarity and u329[rarity]) then
            return nil;
        end;

        if collectionHasNextTier(v358.collection, rarity) then
            return v358;
        end;

        return nil;
    end;

    local function getTradeUpKey(p359, p360) -- Line: 2470
        return tostring(p360.rarity) .. "|" .. (p359.StatTrack and "ST" or "N");
    end;

    local function isTradeUpSelected(p361: string) -- Line: 2474
        -- upvalues: u339 (copy)
        return table.find(u339, p361) ~= nil;
    end;

    local function updateTradeUpWarning() -- Line: 2478
        -- upvalues: u334 (ref), u339 (copy)
        if u334 then
            u334.Text = `{#u339}/{10} Selected For Exchange`;
        end;
    end;

    local function clearRenderedItems(p362: userdata, p363: userdata) -- Line: 2485
        for _, child in ipairs(p362:GetChildren()) do
            if child:IsA("GuiObject") and child ~= p363 then
                child:Destroy();
            end;
        end;
    end;

    local function buildTradeUpFrame(p364: any, p365: userdata, u366: any, p367: any, u368: function) -- Line: 2494
        -- upvalues: Rarities (ref), GetIconImage (ref), GetWeaponProperties (ref), syncItemTemplateCharmIcon (ref), GetSkinDisplayName (ref), Router (ref), TweenService (ref), TweenInfo_new_ret (copy), u3 (ref), u5 (ref), u6 (ref), u14 (ref)
        local v369 = Rarities[p367.rarity];
        local u370 = p364:Clone();
        u370.Name = u366._id;
        u370.Parent = p365;
        u370.Visible = true;
        u370.Selectable = true;
        u370.ItemContent.Rarity.BackgroundColor3 = v369.Color;
        u370.ItemContent.Content.Icon.Image = GetIconImage(u366, p367, false);
        local v371 = GetWeaponProperties(u366.Name);

        if v371 and v371.InventoryIconData then
            u370.ItemContent.Content.Icon.ScaleType = v371.InventoryIconData.ScaleType or u370.ItemContent.Content.Icon.ScaleType;
            u370.ItemContent.Content.Icon.Size = v371.InventoryIconData.Size or u370.ItemContent.Content.Icon.Size;
        end;

        syncItemTemplateCharmIcon(u370, u366);
        local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(u366.Name, u366.NameTag);

        if u366.StatTrack then
            WeaponDisplayName = "KillTrak™ " .. WeaponDisplayName or WeaponDisplayName;
        end;

        GetSkinDisplayName.ApplyNameLabel(u370.Bottom.Footer.WeaponName, WeaponDisplayName, u366.NameTag);
        u370.Bottom.Footer.SkinName.Text = GetSkinDisplayName(u366.Skin or "");
        local Context = u370:FindFirstChild("Context");
        local Inspect2 = u370.ItemContent:FindFirstChild("Inspect");

        if Inspect2 then
            Inspect2.Visible = true;
            Inspect2.Active = true;
            Inspect2.Interactable = true;
            Inspect2.MouseButton1Click:Connect(function() -- Line: 2539
                -- upvalues: Router (ref), u366 (copy)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                local v372 = u366;
                Router.broadcastRouter("WeaponInspect", v372.Name, v372.Skin, v372.Float, v372.StatTrack, v372.NameTag, v372.Charm, v372.Stickers, v372.Type, v372.Pattern, v372._id, v372.Serial, v372.IsTradeable);
            end);
        end;

        local u373 = u370:FindFirstChildOfClass("UIScale");
        u370.MouseEnter:Connect(function() -- Line: 2547
            -- upvalues: Context (copy), Router (ref), TweenService (ref), u373 (copy), TweenInfo_new_ret (ref), u3 (ref), u5 (ref), u366 (copy), u6 (ref), u370 (copy), u14 (ref)
            if Context then
                Context.Visible = true;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
            TweenService:Create(u373, TweenInfo_new_ret, {
                Scale = 0.95
            }):Play();

            if u3 then
                u5 = u366;
                u6 = u370;
                u14 = tick();
            end;
        end);
        u370.MouseLeave:Connect(function() -- Line: 2560
            -- upvalues: Context (copy), TweenService (ref), u373 (copy), TweenInfo_new_ret (ref), u3 (ref), u6 (ref), u370 (copy), u5 (ref), u14 (ref)
            if Context then
                Context.Visible = false;
            end;

            TweenService:Create(u373, TweenInfo_new_ret, {
                Scale = 1
            }):Play();

            if u3 and u6 == u370 then
                u6 = nil;
                u5 = nil;
                u14 = nil;
            end;
        end);
        u370.SelectionGained:Connect(function() -- Line: 2571
            -- upvalues: Context (copy)
            if Context then
                Context.Visible = true;
            end;
        end);
        u370.SelectionLost:Connect(function() -- Line: 2576
            -- upvalues: Context (copy)
            if Context then
                Context.Visible = false;
            end;
        end);
        u370.MouseButton1Down:Connect(function() -- Line: 2581
            -- upvalues: TweenService (ref), u373 (copy), TweenInfo_new_ret (ref)
            TweenService:Create(u373, TweenInfo_new_ret, {
                Scale = 0.9
            }):Play();
        end);
        u370.MouseButton1Up:Connect(function() -- Line: 2584
            -- upvalues: TweenService (ref), u373 (copy), TweenInfo_new_ret (ref)
            TweenService:Create(u373, TweenInfo_new_ret, {
                Scale = 0.95
            }):Play();
        end);
        u370.MouseButton1Click:Connect(function() -- Line: 2589
            -- upvalues: u368 (copy)
            u368();
        end);
        u370.Activated:Connect(function(p374) -- Line: 2592
            -- upvalues: u368 (copy)
            if p374 and p374.UserInputType == Enum.UserInputType.Gamepad1 then
                u368();
            end;
        end);

        return u370;
    end;

    local u375 = {};
    local u376 = 0;
    local u377 = 0;
    local u378 = 0;

    local function renderNextTradeUpBatch(p379: number) -- Line: 2611
        -- upvalues: u376 (ref), u375 (copy), buildTradeUpFrame (copy), ItemTemplate (copy), Container (copy), u341 (ref), u377 (ref)
        local math_min_ret = math.min(u376 + p379, #u375);

        for i = u376 + 1, math_min_ret do
            local u380 = u375[i];
            local v381 = buildTradeUpFrame(ItemTemplate, Container, u380.item, u380.info, function() -- Line: 2621
                -- upvalues: u341 (ref), u380 (copy)
                u341(u380.item, u380.info);
            end);
            u377 = u377 + 1;
            v381.LayoutOrder = u377;
            local _ = i;
        end;

        u376 = math_min_ret;
    end;

    local function rebuildTradeUpPool() -- Line: 2632
        -- upvalues: u344 (ref), u343 (copy), DataController (ref), LocalPlayer (ref), getEligibleTradeUpInfo (copy), Sort (ref), u336 (ref), u10 (ref), u337 (ref)
        u344 = false;
        table.clear(u343);
        local v382 = DataController.Get(LocalPlayer, "Inventory");

        if not v382 then
            return;
        end;

        for _, v in ipairs(v382) do
            if v and v._id then
                local v383 = getEligibleTradeUpInfo(v);

                if v383 then
                    local v384 = {
                        item = v,
                        info = v383,
                        key = tostring(v383.rarity) .. "|" .. (v.StatTrack and "ST" or "N")
                    };
                    local string_lower_ret = string.lower((v.Name or "") .. " " .. (v.Skin or ""));

                    if string.find(string_lower_ret, "zeus", 1, true) then
                        string_lower_ret = string_lower_ret .. " taser";
                    end;

                    v384.searchable = string_lower_ret;
                    table.insert(u343, v384);
                end;
            end;
        end;

        local SortComparisonFunction = Sort.GetSortComparisonFunction(u336, LocalPlayer, function() -- Line: 2656
            -- upvalues: u10 (ref)
            return u10;
        end);

        if SortComparisonFunction then
            table.sort(u343, function(p385, p386) -- Line: 2660
                -- upvalues: u337 (ref), SortComparisonFunction (copy)
                if not u337 then
                    return SortComparisonFunction(p385.item, p386.item);
                end;

                local v387, v388 = SortComparisonFunction(p385.item, p386.item);

                if v388 then
                    return v387;
                end;

                return SortComparisonFunction(p386.item, p385.item);
            end);
        end;
    end;

    local function renderTradeUpContainer() -- Line: 2674
        -- upvalues: u378 (ref), clearRenderedItems (copy), Container (copy), ItemTemplate (copy), u375 (copy), u376 (ref), u377 (ref), u344 (ref), rebuildTradeUpPool (copy), u343 (copy), u339 (copy), u340 (ref), tradeUpMatchesSearch (copy), renderNextTradeUpBatch (copy), TradeUp2 (copy)
        u378 = u378 + 1;
        local u389 = u378;
        clearRenderedItems(Container, ItemTemplate);
        table.clear(u375);
        u376 = 0;
        u377 = 0;

        if u344 then
            rebuildTradeUpPool();
        end;

        for _, v in ipairs(u343) do
            if table.find(u339, v.item._id) == nil and (u340 == nil or v.key == u340) and tradeUpMatchesSearch(v.searchable) then
                table.insert(u375, v);
            end;
        end;

        renderNextTradeUpBatch(25);

        if #u375 > 25 then
            task.defer(function() -- Line: 2700
                -- upvalues: u389 (copy), u378 (ref), TradeUp2 (ref), renderNextTradeUpBatch (ref)
                if u389 == u378 and TradeUp2.Visible then
                    renderNextTradeUpBatch(25);
                end;
            end);
        end;
    end;

    Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 2709
        -- upvalues: TradeUp2 (copy), u376 (ref), u375 (copy), Container (copy), renderNextTradeUpBatch (copy)
        if not TradeUp2.Visible or u376 >= #u375 then
            return;
        end;

        local v390 = Container.AbsoluteCanvasSize.Y - Container.AbsoluteSize.Y;

        if v390 > 0 and v390 - Container.CanvasPosition.Y < 200 then
            renderNextTradeUpBatch(25);
        end;
    end);
    local u391 = {};
    local u392 = {};

    for i = 1, 10 do
        local v393 = AddTemplate:Clone();
        v393.Name = `AddSlot{i}`;
        v393.Visible = true;
        v393.LayoutOrder = i + 100;
        v393.Active = false;
        v393.Interactable = false;
        v393.Selectable = false;
        v393.Parent = Exchange;
        u391[i] = v393;
        u392[v393] = true;
        local _ = i;
    end;

    local function updateExchangePlaceholders() -- Line: 2736
        -- upvalues: u339 (copy), u391 (copy)
        local v394 = #u339;

        for i, v in ipairs(u391) do
            v.Visible = v394 < i;
        end;
    end;

    local function appendExchangeFrame(p395: any, p396: any, p397: number) -- Line: 2744
        -- upvalues: buildTradeUpFrame (copy), ItemTemplate2 (copy), Exchange (copy), u342 (ref)
        local _id = p395._id;
        buildTradeUpFrame(ItemTemplate2, Exchange, p395, p396, function() -- Line: 2751
            -- upvalues: u342 (ref), _id (copy)
            u342(_id);
        end).LayoutOrder = p397;
    end;

    local function renderTradeUpExchange() -- Line: 2759
        -- upvalues: Exchange (copy), ItemTemplate2 (copy), AddTemplate (copy), u392 (copy), DataController (ref), LocalPlayer (ref), u339 (copy), getEligibleTradeUpInfo (copy), buildTradeUpFrame (copy), u342 (ref), u391 (copy)
        for _, child in ipairs(Exchange:GetChildren()) do
            if child:IsA("GuiObject") and (child ~= ItemTemplate2 and (child ~= AddTemplate and not u392[child])) then
                child:Destroy();
            end;
        end;

        local v398 = DataController.Get(LocalPlayer, "Inventory");

        if v398 and #u339 > 0 then
            local v399 = {};

            for _, v in ipairs(v398) do
                if v and v._id then
                    v399[v._id] = v;
                end;
            end;

            local v400 = 0;

            for _, v in ipairs(u339) do
                local v401 = v399[v];
                local v402;

                if v401 then
                    v402 = getEligibleTradeUpInfo(v401);
                else
                    v402 = v401;
                end;

                if v402 then
                    v400 = v400 + 1;
                    local _id = v401._id;
                    buildTradeUpFrame(ItemTemplate2, Exchange, v401, v402, function() -- Line: 2751
                        -- upvalues: u342 (ref), _id (copy)
                        u342(_id);
                    end).LayoutOrder = v400;
                end;
            end;
        end;

        local v403 = #u339;

        for i, v in ipairs(u391) do
            v.Visible = v403 < i;
        end;
    end;

    local function renderTradeUp() -- Line: 2795
        -- upvalues: renderTradeUpContainer (copy), renderTradeUpExchange (copy), u334 (ref), u339 (copy)
        renderTradeUpContainer();
        renderTradeUpExchange();

        if u334 then
            u334.Text = `{#u339}/{10} Selected For Exchange`;
        end;
    end;

    u341 = function(p404, p405) -- Line: 2801, Name: selectTradeUpItem
        -- upvalues: Router (ref), u339 (copy), u340 (ref), renderTradeUpContainer (copy), u375 (copy), u376 (ref), Container (copy), renderNextTradeUpBatch (copy), buildTradeUpFrame (copy), ItemTemplate2 (copy), Exchange (copy), u342 (ref), u391 (copy), u334 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if #u339 >= 10 or table.find(u339, p404._id) ~= nil then
            return;
        end;

        local v406 = tostring(p405.rarity) .. "|" .. (p404.StatTrack and "ST" or "N");

        if u340 and v406 ~= u340 then
            return;
        end;

        local v407 = #u339 == 0;

        if v407 then
            u340 = v406;
        end;

        table.insert(u339, p404._id);

        if v407 then
            renderTradeUpContainer();
        else
            for i, v in ipairs(u375) do
                if v.item._id == p404._id then
                    table.remove(u375, i);

                    if i <= u376 then
                        u376 = u376 - 1;
                        local v408 = Container:FindFirstChild(p404._id);

                        if v408 then
                            v408:Destroy();
                        end;
                    end;

                    break;
                end;
            end;

            if u376 < 50 and u376 < #u375 then
                renderNextTradeUpBatch(50 - u376);
            end;
        end;

        local _id = p404._id;
        buildTradeUpFrame(ItemTemplate2, Exchange, p404, p405, function() -- Line: 2751
            -- upvalues: u342 (ref), _id (copy)
            u342(_id);
        end).LayoutOrder = #u339;
        local v409 = #u339;

        for i, v in ipairs(u391) do
            v.Visible = v409 < i;
        end;

        if u334 then
            u334.Text = `{#u339}/{10} Selected For Exchange`;
        end;
    end;

    u342 = function(p410: string) -- Line: 2848, Name: deselectTradeUpItem
        -- upvalues: Router (ref), u339 (copy), u340 (ref), renderTradeUpContainer (copy), Exchange (copy), u392 (copy), u391 (copy), u334 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local table_find_ret = table.find(u339, p410);

        if not table_find_ret then
            return;
        end;

        table.remove(u339, table_find_ret);

        if #u339 == 0 then
            u340 = nil;
        end;

        renderTradeUpContainer();
        local v411 = Exchange:FindFirstChild(p410);

        if v411 and not u392[v411] then
            v411:Destroy();
        end;

        for i, v in ipairs(u339) do
            local v412 = Exchange:FindFirstChild(v);

            if v412 then
                v412.LayoutOrder = i;
            end;
        end;

        local v413 = #u339;

        for i, v in ipairs(u391) do
            v.Visible = v413 < i;
        end;

        if u334 then
            u334.Text = `{#u339}/{10} Selected For Exchange`;
        end;
    end;

    local function clearTradeUpSelection() -- Line: 2878
        -- upvalues: u339 (copy), u340 (ref)
        table.clear(u339);
        u340 = nil;
    end;

    local u414 = false;
    local u415 = false;
    local u416 = nil;
    local u417 = 0;
    local u418 = nil;
    local u419 = false;
    local u420 = false;
    local u421 = false;
    local Title2 = TradeUp2.Options.Proceed.Container.Title;
    local Text = Title2.Text;
    local Position = TradeUp2.Options.Cancel.Position;
    local Position2 = TradeUp2.Options.Proceed.Position;
    local UDim2_new_ret = UDim2.new(0.405, 0, Position.Y.Scale, Position.Y.Offset);
    local UDim2_new_ret2 = UDim2.new(0.595, 0, Position2.Y.Scale, Position2.Y.Offset);
    local UDim2_new_ret3 = UDim2.new(0.5, 0, Position2.Y.Scale, Position2.Y.Offset);
    local Frame = TradeUp2.TradeContainer.Contract.Frame;
    local Position3 = Frame.Position;
    local UDim2_new_ret4 = UDim2.new(Position3.X.Scale, Position3.X.Offset, 1.5, 0);
    local TweenInfo_new_ret2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local Color3_fromRGB_ret = Color3.fromRGB(49, 75, 114);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "DrawingCanvas";
    Frame2.BackgroundTransparency = 1;
    Frame2.AnchorPoint = Vector2.new(Frame.AnchorPoint.X, 0);
    Frame2.Position = UDim2.new(Position3.X.Scale, Position3.X.Offset, 0, 0);
    Frame2.Size = UDim2.new(Frame.Size.X.Scale, Frame.Size.X.Offset, 1, 0);
    Frame2.ClipsDescendants = true;
    Frame2.ZIndex = 10;
    Frame2.Active = true;
    Frame2.Parent = TradeUp2.TradeContainer.Contract;
    local u422 = 0;
    local u423 = false;
    local u424 = nil;

    local function clearContractDrawing() -- Line: 2942
        -- upvalues: u423 (ref), u424 (ref), u422 (ref), Frame2 (copy)
        u423 = false;
        u424 = nil;
        u422 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;
    end;

    local function toContractCanvasPoint(p425: vector) -- Line: 2952
        -- upvalues: Frame2 (copy)
        local AbsolutePosition = Frame2.AbsolutePosition;
        local AbsoluteSize = Frame2.AbsoluteSize;

        return Vector2.new(math.clamp(p425.X - AbsolutePosition.X, 0, AbsoluteSize.X), (math.clamp(p425.Y - AbsolutePosition.Y, 0, AbsoluteSize.Y)));
    end;

    local function createContractInkFrame() -- Line: 2961
        -- upvalues: Color3_fromRGB_ret (copy)
        local Frame3 = Instance.new("Frame");
        Frame3.BackgroundColor3 = Color3_fromRGB_ret;
        Frame3.BorderSizePixel = 0;
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Frame3.ZIndex = 10;

        return Frame3;
    end;

    local function addContractDrawPoint(p426) -- Line: 2972
        -- upvalues: u422 (ref), u424 (ref), Color3_fromRGB_ret (copy), Frame2 (copy)
        if u422 >= 2500 then
            return;
        end;

        local v427 = u424;

        if v427 and (p426 - v427).Magnitude < 2 then
            return;
        end;

        u422 = u422 + 1;
        local Frame3 = Instance.new("Frame");
        Frame3.BackgroundColor3 = Color3_fromRGB_ret;
        Frame3.BorderSizePixel = 0;
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Frame3.ZIndex = 10;
        Frame3.Position = UDim2.fromOffset(p426.X, p426.Y);
        Frame3.Size = UDim2.fromScale(0.01, 0.01);
        Frame3.Parent = Frame2;

        if v427 then
            local v428 = p426 - v427;
            local v429 = (p426 + v427) / 2;
            local Frame4 = Instance.new("Frame");
            Frame4.BackgroundColor3 = Color3_fromRGB_ret;
            Frame4.BorderSizePixel = 0;
            Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
            Frame4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
            Frame4.ZIndex = 10;
            Frame4.Position = UDim2.fromOffset(v429.X, v429.Y);
            Frame4.Size = UDim2.new(0, v428.Magnitude, 0.01, 0);
            local math_atan_ret = math.atan(v428.Y / v428.X);
            Frame4.Rotation = math.deg(math_atan_ret);
            Frame4.Parent = Frame2;
        end;

        u424 = p426;
    end;

    Frame2.InputBegan:Connect(function(p430) -- Line: 3005
        -- upvalues: u423 (ref), u424 (ref), addContractDrawPoint (copy), toContractCanvasPoint (copy)
        if p430.UserInputType == Enum.UserInputType.MouseButton1 or p430.UserInputType == Enum.UserInputType.Touch then
            u423 = true;
            u424 = nil;
            addContractDrawPoint(toContractCanvasPoint(p430.Position));
        end;
    end);
    UserInputService.InputChanged:Connect(function(p431) -- Line: 3017
        -- upvalues: u423 (ref), addContractDrawPoint (copy), toContractCanvasPoint (copy)
        if not u423 then
            return;
        end;

        if p431.UserInputType == Enum.UserInputType.MouseMovement or p431.UserInputType == Enum.UserInputType.Touch then
            addContractDrawPoint(toContractCanvasPoint(p431.Position));
        end;
    end);
    UserInputService.InputEnded:Connect(function(p432) -- Line: 3029
        -- upvalues: u423 (ref), u424 (ref)
        if p432.UserInputType == Enum.UserInputType.MouseButton1 or p432.UserInputType == Enum.UserInputType.Touch then
            u423 = false;
            u424 = nil;
        end;
    end);
    local u433 = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
    local u434 = { {
            maxLevel = 5,
            title = "Recruit"
        }, {
            maxLevel = 10,
            title = "Private"
        }, {
            maxLevel = 15,
            title = "Corporal"
        }, {
            maxLevel = 20,
            title = "Sergeant"
        }, {
            maxLevel = 25,
            title = "Master Sergeant"
        }, {
            maxLevel = 30,
            title = "Lieutenant"
        }, {
            maxLevel = 35,
            title = "Captain"
        }, {
            maxLevel = 40,
            title = "Global Elite"
        } };
    local u435 = 0;

    local function playRandomTypingSound() -- Line: 3056
        -- upvalues: Router (ref)
        Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
    end;

    local function getContractDate() -- Line: 3061
        -- upvalues: u433 (copy)
        local os_date_ret = os.date("*t");

        return string.format("%s %d, %d", u433[os_date_ret.month], os_date_ret.day, os_date_ret.year);
    end;

    local function getPlayerRankTitle() -- Line: 3066
        -- upvalues: DataController (ref), LocalPlayer (ref), u434 (copy)
        local v436 = DataController.Get(LocalPlayer, "Level");
        local v437 = type(v436) == "table" and tonumber(v436.Level) or 1;

        for _, v in ipairs(u434) do
            if v437 <= v.maxLevel then
                return v.title;
            end;
        end;

        return "Global Elite";
    end;

    local function runContractTypewriter() -- Line: 3078
        -- upvalues: u435 (ref), TradeUp2 (copy), LocalPlayer (ref), u433 (copy), getPlayerRankTitle (copy), Router (ref)
        u435 = u435 + 1;
        local u438 = u435;
        local Frame3 = TradeUp2.TradeContainer.Contract.Frame;
        local v439 = Frame3:FindFirstChild("1");
        local v440 = Frame3:FindFirstChild("2");

        if not (v439 and v440) then
            return;
        end;

        local v441 = {};
        local v442 = {
            label = v439:FindFirstChild("ID"),
            text = tostring(LocalPlayer.UserId)
        };
        local v443 = {
            label = v439:FindFirstChild("Name"),
            text = LocalPlayer.Name
        };
        local v444 = {
            label = v439:FindFirstChild("Number"),
            text = tostring(10)
        };
        local v445 = {
            label = v440:FindFirstChild("Date")
        };
        local os_date_ret = os.date("*t");
        v445.text = string.format("%s %d, %d", u433[os_date_ret.month], os_date_ret.day, os_date_ret.year);
        v441[1], v441[2], v441[3], v441[4], v441[5] = v442, v443, v444, v445, {
    label = v440:FindFirstChild("Rank"),
    text = getPlayerRankTitle()
};
        local u446 = 0;
        local u447 = {};

        for _, v in ipairs(v441) do
            if v.label and v.label:IsA("TextLabel") then
                v.label.Text = "";
                u446 = math.max(u446, #v.text);
                table.insert(u447, v);
            end;
        end;

        task.spawn(function() -- Line: 3109
            -- upvalues: u438 (copy), u435 (ref), u446 (ref), u447 (copy), Router (ref)
            task.wait(0.2);

            if u438 ~= u435 then
                return;
            end;

            for i = 1, u446 do
                task.wait(0.12);

                if u438 ~= u435 then
                    return;
                end;

                local v448 = i;

                for _, v in ipairs(u447) do
                    if v448 <= #v.text then
                        v.label.Text = string.sub(v.text, 1, v448);
                    end;
                end;

                Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
            end;
        end);
    end;

    local u449 = 0;

    local function getTradeUpItemName(p450) -- Line: 3140
        -- upvalues: GetSkinDisplayName (ref)
        if not p450 then
            return "";
        end;

        local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(p450.Name, p450.NameTag);
        local v451 = p450.Skin or "";

        if v451 == "" then
            return WeaponDisplayName;
        end;

        return `{WeaponDisplayName} | {v451}`;
    end;

    local function utf8Prefix(p452: string, p453: number) -- Line: 3153
        local utf8_offset_ret = utf8.offset(p452, p453 + 1);

        if utf8_offset_ret then
            return string.sub(p452, 1, utf8_offset_ret - 1);
        end;

        return p452;
    end;

    local function getContractSlotLabel(p454: number) -- Line: 3162
        -- upvalues: TradeUp2 (copy)
        local Frame3 = TradeUp2.TradeContainer.Contract.Frame;
        local v455 = tostring(p454);
        local v456 = Frame3:FindFirstChild("3") and Frame3["3"]:FindFirstChild(v455) or Frame3:FindFirstChild("4") and Frame3["4"]:FindFirstChild(v455);

        if v456 and v456:IsA("TextLabel") then
            return v456;
        end;

        return nil;
    end;

    local function getContractReceivedLabel() -- Line: 3173
        -- upvalues: TradeUp2 (copy)
        local v457 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

        if v457 then
            v457 = v457:FindFirstChild("Received");
        end;

        if v457 and v457:IsA("TextLabel") then
            return v457;
        end;

        return nil;
    end;

    local function clearContractSlots() -- Line: 3184
        -- upvalues: getContractSlotLabel (copy), TradeUp2 (copy)
        for i = 1, 10 do
            local v458 = getContractSlotLabel(i);
            local v459;

            if v458 then
                v458.Text = "";
                v459 = i;
            else
                v459 = i;
            end;
        end;

        local v460 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

        if v460 then
            v460 = v460:FindFirstChild("Received");
        end;

        if not (v460 and v460:IsA("TextLabel")) then
            v460 = nil;
        end;

        if v460 then
            v460.Text = "";
        end;
    end;

    local function clearContractHeaderFields() -- Line: 3198
        -- upvalues: TradeUp2 (copy)
        local Frame3 = TradeUp2.TradeContainer.Contract.Frame;

        for _, v in { { "1", "ID", "Name", "Number" }, { "2", "Date", "Rank" } } do
            local v461 = Frame3:FindFirstChild(v[1]);
            local v462 = v;

            for i = 2, #v do
                local v463;

                if v461 then
                    v463 = v461:FindFirstChild(v462[i]);
                else
                    v463 = v461;
                end;

                local v464;

                if v463 and v463:IsA("TextLabel") then
                    v463.Text = "";
                    v464 = i;
                else
                    v464 = i;
                end;
            end;
        end;
    end;

    local u465 = nil;

    local function finishTradeUpReveal(u466) -- Line: 3215
        -- upvalues: u465 (ref), GetResolvedSkinInformation (ref), Router (ref), u34 (ref), u32 (ref), u1 (ref), MenuState (ref)
        u465(false);

        if not u466 then
            return;
        end;

        local v467 = GetResolvedSkinInformation(u466.Name, u466.Skin);
        Router.broadcastRouter("RunStoreSound", u34[v467 and v467.rarity or (u466.Rarity or "Blue")] or "Drop Blue");

        local function showNotification() -- Line: 3226
            -- upvalues: u32 (ref), u1 (ref), u466 (copy)
            u32 = false;
            u1.ShowNewItemNotification(u466);
        end;

        local u468 = nil;
        u468 = MenuState.OnInspectStateChanged:Connect(function(p469: boolean) -- Line: 3232
            -- upvalues: u468 (ref), u32 (ref), u1 (ref), u466 (copy)
            if p469 then
                return;
            end;

            u468:Disconnect();
            u468 = nil;
            u32 = false;
            u1.ShowNewItemNotification(u466);
        end);
        Router.broadcastRouter("WeaponInspect", u466.Name, u466.Skin, u466.Float, u466.StatTrack, u466.NameTag, u466.Charm, u466.Stickers, u466.Type, u466.Pattern, u466._id, u466.Serial, u466.IsTradeable);

        if u468 and not Router.broadcastRouter("IsInspectActive") then
            u468:Disconnect();
            u468 = nil;
            u32 = false;
            u1.ShowNewItemNotification(u466);
        end;
    end;

    local function runContractConfirmReveal(u470: table) -- Line: 3252
        -- upvalues: u449 (ref), clearContractSlots (copy), getContractSlotLabel (copy), Router (ref), u418 (ref), TradeUp2 (copy), GetSkinDisplayName (ref), TweenService (ref), finishTradeUpReveal (copy)
        u449 = u449 + 1;
        local u471 = u449;
        clearContractSlots();
        task.spawn(function() -- Line: 3257
            -- upvalues: getContractSlotLabel (ref), u470 (copy), u471 (copy), u449 (ref), Router (ref), u418 (ref), TradeUp2 (ref), GetSkinDisplayName (ref), TweenService (ref), finishTradeUpReveal (ref)
            for i = 1, 10 do
                local v472 = getContractSlotLabel(i);
                local v473 = u470[i] or "";
                local v474;

                if v472 then
                    v474 = i;

                    for i2 = 1, utf8.len(v473) or #v473 do
                        task.wait(0.06);

                        if u471 ~= u449 then
                            return;
                        end;

                        local utf8_offset_ret = utf8.offset(v473, i2 + 1);
                        local v475;

                        if utf8_offset_ret then
                            v475 = string.sub(v473, 1, utf8_offset_ret - 1);
                        else
                            v475 = v473;
                        end;

                        v472.Text = v475;
                        Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                        local _ = i2;
                    end;
                else
                    v474 = i;
                end;
            end;

            while u471 == u449 and u418 == nil do
                task.wait(0.05);
            end;

            if u471 ~= u449 then
                return;
            end;

            local v476 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

            if v476 then
                v476 = v476:FindFirstChild("Received");
            end;

            if not (v476 and v476:IsA("TextLabel")) then
                v476 = nil;
            end;

            local v477 = u418;
            local v478;

            if v477 then
                v478 = GetSkinDisplayName.GetWeaponDisplayName(v477.Name, v477.NameTag);
                local v479 = v477.Skin or "";

                if v479 ~= "" then
                    v478 = `{v478} | {v479}`;
                end;
            else
                v478 = "";
            end;

            if v476 then
                for i = 1, utf8.len(v478) or #v478 do
                    task.wait(0.06);

                    if u471 ~= u449 then
                        return;
                    end;

                    local utf8_offset_ret = utf8.offset(v478, i + 1);
                    local v480;

                    if utf8_offset_ret then
                        v480 = string.sub(v478, 1, utf8_offset_ret - 1);
                    else
                        v480 = v478;
                    end;

                    v476.Text = v480;
                    Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                    local _ = i;
                end;
            end;

            task.wait(0.1);

            if u471 ~= u449 then
                return;
            end;

            local Approved = TradeUp2.TradeContainer.Contract:FindFirstChild("Approved");

            if Approved and Approved:IsA("ImageLabel") then
                Approved.Size = UDim2.fromScale(0.65, 0.65);
                Approved.ImageTransparency = 0.85;
                Approved.Visible = true;
                Router.broadcastRouter("RunInterfaceSound", "TradeUp Approved");

                local function stampStep(p481: number, p482: table) -- Line: 3308
                    -- upvalues: TweenService (ref), Approved (copy)
                    return TweenService:Create(Approved, TweenInfo.new(p481, Enum.EasingStyle.Linear), p482);
                end;

                local v483 = {};
                local v484 = {
                    ImageTransparency = 0,
                    Size = UDim2.fromScale(0.35, 0.35)
                };
                local v485 = TweenService:Create(Approved, TweenInfo.new(0.2, Enum.EasingStyle.Linear), v484);
                local v486 = {
                    Size = UDim2.fromScale(0.365, 0.365)
                };
                v483[1], v483[2], v483[3] = v485, TweenService:Create(Approved, TweenInfo.new(0.03, Enum.EasingStyle.Linear), v486), stampStep(0.03, {
    Size = UDim2.fromScale(0.35, 0.35)
});

                for _, v in ipairs(v483) do
                    v:Play();
                    v.Completed:Wait();

                    if u471 ~= u449 then
                        return;
                    end;
                end;
            end;

            task.wait(1.25);

            if u471 ~= u449 then
                return;
            end;

            finishTradeUpReveal(u418);
        end);
    end;

    local function skipContractReveal() -- Line: 3334
        -- upvalues: u449 (ref), u418 (ref), finishTradeUpReveal (copy)
        u449 = u449 + 1;
        local u487 = u449;
        task.spawn(function() -- Line: 3338
            -- upvalues: u487 (copy), u449 (ref), u418 (ref), finishTradeUpReveal (ref)
            while u487 == u449 and u418 == nil do
                task.wait(0.05);
            end;

            if u487 ~= u449 then
                return;
            end;

            finishTradeUpReveal(u418);
        end);
    end;

    local function setTradeUpItemSelectionState() -- Line: 3350
        -- upvalues: u414 (ref), u419 (ref), u420 (ref), u421 (ref), u435 (ref), u449 (ref), TradeUp2 (copy), Title2 (copy), Text (copy), Position (copy), Position2 (copy), u415 (ref), u21 (ref), u423 (ref), u424 (ref), u422 (ref), Frame2 (copy)
        u414 = false;
        u419 = false;
        u420 = false;
        u421 = false;
        u435 = u435 + 1;
        u449 = u449 + 1;
        TradeUp2.Options.Clear.Visible = true;
        TradeUp2.Options.Proceed.Visible = true;
        TradeUp2.Options.Cancel.Visible = false;
        Title2.Text = Text;
        TradeUp2.Options.Cancel.Position = Position;
        TradeUp2.Options.Proceed.Position = Position2;
        TradeUp2.Top.Visible = true;

        if u415 and (u21 and u21.Menu) then
            u21.Menu.Top.Visible = true;
        end;

        u415 = false;
        TradeUp2.TradeContainer.Container.Visible = true;
        TradeUp2.TradeContainer.Exchange.Visible = true;
        TradeUp2.TradeContainer.Contract.Visible = false;
        u423 = false;
        u424 = nil;
        u422 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;

        for _, child in ipairs(TradeUp2.Warning:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = child.Name ~= "WarningForContract";
            end;
        end;
    end;

    local function setTradeUpContractState() -- Line: 3390
        -- upvalues: u414 (ref), TradeUp2 (copy), Title2 (copy), UDim2_new_ret (copy), UDim2_new_ret2 (copy), u21 (ref), u415 (ref), u423 (ref), u424 (ref), u422 (ref), Frame2 (copy), clearContractHeaderFields (copy), clearContractSlots (copy), u435 (ref), Frame (copy), UDim2_new_ret4 (copy), TweenService (ref), TweenInfo_new_ret2 (copy), Position3 (copy), runContractTypewriter (copy), Router (ref)
        u414 = true;
        TradeUp2.Options.Clear.Visible = false;
        TradeUp2.Options.Proceed.Visible = true;
        TradeUp2.Options.Cancel.Visible = true;
        Title2.Text = "CONFIRM";
        TradeUp2.Options.Cancel.Position = UDim2_new_ret;
        TradeUp2.Options.Proceed.Position = UDim2_new_ret2;
        TradeUp2.Top.Visible = false;

        if u21 and u21.Menu then
            u21.Menu.Top.Visible = false;
            u415 = true;
        end;

        for _, child in ipairs(TradeUp2.Warning:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = false;
            end;
        end;

        u423 = false;
        u424 = nil;
        u422 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;

        clearContractHeaderFields();
        clearContractSlots();
        local Approved = TradeUp2.TradeContainer.Contract:FindFirstChild("Approved");

        if Approved and Approved:IsA("ImageLabel") then
            Approved.Visible = false;
        end;

        TradeUp2.TradeContainer.Container.Visible = false;
        TradeUp2.TradeContainer.Exchange.Visible = false;
        u435 = u435 + 1;
        local u488 = u435;
        Frame.Position = UDim2_new_ret4;

        if not TradeUp2.TradeContainer.Contract.Visible then
            TradeUp2.TradeContainer.Contract.Visible = true;
        end;

        task.delay(0.18, function() -- Line: 3438
            -- upvalues: u488 (copy), u435 (ref), TweenService (ref), Frame (ref), TweenInfo_new_ret2 (ref), Position3 (ref), runContractTypewriter (ref), Router (ref)
            if u488 ~= u435 then
                return;
            end;

            local v489 = TweenService:Create(Frame, TweenInfo_new_ret2, {
                Position = Position3
            });
            v489.Completed:Connect(function() -- Line: 3447
                -- upvalues: u488 (ref), u435 (ref), runContractTypewriter (ref)
                if u488 ~= u435 then
                    return;
                end;

                runContractTypewriter();
            end);
            Router.broadcastRouter("RunInterfaceSound", "TradeUp Contract Slide");
            v489:Play();
        end);
    end;

    u465 = function(p490: boolean) -- Line: 3459, Name: setTradeUpVisible
        -- upvalues: u20 (ref), TradeUp2 (copy), u6 (ref), u5 (ref), u14 (ref), MenuState (ref), u18 (ref), DismissItemNotifications (ref), setTradeUpItemSelectionState (copy), u339 (copy), u340 (ref), renderTradeUp (ref), u414 (ref), u419 (ref), u420 (ref), u421 (ref), u435 (ref), u449 (ref), u423 (ref), u424 (ref), u422 (ref), Frame2 (copy), Position (copy), Position2 (copy), Title2 (copy), Text (copy), u415 (ref), u21 (ref)
        u20.Frame.Categories.Visible = not p490;
        u20.Frame.Right.Visible = not p490;
        TradeUp2.Visible = p490;
        u6 = nil;
        u5 = nil;
        u14 = nil;
        u20.Ignore.Hover.Visible = false;

        if p490 then
            MenuState.EnterTradeUp();

            if u18 then
                u18.Visible = false;
            end;

            if u20.Ignore.ItemNotification.Visible then
                DismissItemNotifications();
            end;

            setTradeUpItemSelectionState();
            table.clear(u339);
            u340 = nil;
            renderTradeUp();

            return;
        end;

        MenuState.ExitTradeUp();
        u414 = false;
        u419 = false;
        u420 = false;
        u421 = false;
        u435 = u435 + 1;
        u449 = u449 + 1;
        u423 = false;
        u424 = nil;
        u422 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;

        TradeUp2.Options.Cancel.Position = Position;
        TradeUp2.Options.Proceed.Position = Position2;
        Title2.Text = Text;

        if u415 and (u21 and u21.Menu) then
            u21.Menu.Top.Visible = true;
        end;

        u415 = false;
    end;

    local Clear = TradeUp2.Options.Clear;
    local Proceed = TradeUp2.Options.Proceed;
    local Cancel = TradeUp2.Options.Cancel;
    ActivateButton(Clear);
    Clear.Selectable = true;

    local function u491() -- Line: 3510
        -- upvalues: Router (ref), u339 (copy), u340 (ref), renderTradeUp (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        table.clear(u339);
        u340 = nil;
        renderTradeUp();
    end;

    Clear.MouseButton1Click:Connect(u491);
    Clear.Activated:Connect(function(p492) -- Line: 1149
        -- upvalues: u491 (copy)
        if p492 and p492.UserInputType == Enum.UserInputType.Gamepad1 then
            u491();
        end;
    end);
    ActivateButton(Proceed);
    Proceed.Selectable = true;

    local function handleTradeUpProceedClick() -- Line: 3519
        -- upvalues: u420 (ref), u414 (ref), u421 (ref), Router (ref), u449 (ref), u418 (ref), finishTradeUpReveal (copy), u416 (ref), u419 (ref), u339 (copy), TradeUp2 (copy), UDim2_new_ret3 (copy), Title2 (copy), DataController (ref), LocalPlayer (ref), GetSkinDisplayName (ref), u417 (ref), Remotes (ref), clearContractSlots (copy), getContractSlotLabel (copy), TweenService (ref), setTradeUpContractState (copy)
        if u420 then
            if u414 and not u421 then
                u421 = true;
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u449 = u449 + 1;
                local u493 = u449;
                task.spawn(function() -- Line: 3338
                    -- upvalues: u493 (copy), u449 (ref), u418 (ref), finishTradeUpReveal (ref)
                    while u493 == u449 and u418 == nil do
                        task.wait(0.05);
                    end;

                    if u493 ~= u449 then
                        return;
                    end;

                    finishTradeUpReveal(u418);
                end);
            end;

            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if not u414 then
            if #u339 == 10 then
                setTradeUpContractState();
            end;

            return;
        end;

        if u416 or (u419 or #u339 ~= 10) then
            return;
        end;

        u420 = true;
        u421 = false;
        TradeUp2.Options.Cancel.Visible = false;
        TradeUp2.Options.Proceed.Position = UDim2_new_ret3;
        Title2.Text = "SKIP";
        local v494 = DataController.Get(LocalPlayer, "Inventory") or {};
        local v495 = {};

        for _, v in ipairs(v494) do
            if v and v._id then
                v495[v._id] = v;
            end;
        end;

        local u496 = {};

        for _, v in ipairs(u339) do
            local v497 = v495[v];
            local v498;

            if v497 then
                v498 = GetSkinDisplayName.GetWeaponDisplayName(v497.Name, v497.NameTag);
                local v499 = v497.Skin or "";

                if v499 ~= "" then
                    v498 = `{v498} | {v499}`;
                end;
            else
                v498 = "";
            end;

            table.insert(u496, v498);
        end;

        u418 = nil;
        u419 = false;
        u417 = u417 + 1;
        local v500 = `TradeUp_{u417}`;
        u416 = v500;
        Remotes.Store.TradeUpItems.Send({
            ItemIds = table.clone(u339),
            RequestId = v500
        });
        u449 = u449 + 1;
        local u501 = u449;
        clearContractSlots();
        task.spawn(function() -- Line: 3257
            -- upvalues: getContractSlotLabel (ref), u496 (copy), u501 (copy), u449 (ref), Router (ref), u418 (ref), TradeUp2 (ref), GetSkinDisplayName (ref), TweenService (ref), finishTradeUpReveal (ref)
            for i = 1, 10 do
                local v502 = getContractSlotLabel(i);
                local v503 = u496[i] or "";
                local v504;

                if v502 then
                    v504 = i;

                    for i2 = 1, utf8.len(v503) or #v503 do
                        task.wait(0.06);

                        if u501 ~= u449 then
                            return;
                        end;

                        local utf8_offset_ret = utf8.offset(v503, i2 + 1);
                        local v505;

                        if utf8_offset_ret then
                            v505 = string.sub(v503, 1, utf8_offset_ret - 1);
                        else
                            v505 = v503;
                        end;

                        v502.Text = v505;
                        Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                        local _ = i2;
                    end;
                else
                    v504 = i;
                end;
            end;

            while u501 == u449 and u418 == nil do
                task.wait(0.05);
            end;

            if u501 ~= u449 then
                return;
            end;

            local v506 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

            if v506 then
                v506 = v506:FindFirstChild("Received");
            end;

            if not (v506 and v506:IsA("TextLabel")) then
                v506 = nil;
            end;

            local v507 = u418;
            local v508;

            if v507 then
                v508 = GetSkinDisplayName.GetWeaponDisplayName(v507.Name, v507.NameTag);
                local v509 = v507.Skin or "";

                if v509 ~= "" then
                    v508 = `{v508} | {v509}`;
                end;
            else
                v508 = "";
            end;

            if v506 then
                for i = 1, utf8.len(v508) or #v508 do
                    task.wait(0.06);

                    if u501 ~= u449 then
                        return;
                    end;

                    local utf8_offset_ret = utf8.offset(v508, i + 1);
                    local v510;

                    if utf8_offset_ret then
                        v510 = string.sub(v508, 1, utf8_offset_ret - 1);
                    else
                        v510 = v508;
                    end;

                    v506.Text = v510;
                    Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                    local _ = i;
                end;
            end;

            task.wait(0.1);

            if u501 ~= u449 then
                return;
            end;

            local Approved = TradeUp2.TradeContainer.Contract:FindFirstChild("Approved");

            if Approved and Approved:IsA("ImageLabel") then
                Approved.Size = UDim2.fromScale(0.65, 0.65);
                Approved.ImageTransparency = 0.85;
                Approved.Visible = true;
                Router.broadcastRouter("RunInterfaceSound", "TradeUp Approved");

                local function v513(p511: number, p512: table) -- Line: 3308
                    -- upvalues: TweenService (ref), Approved (copy)
                    return TweenService:Create(Approved, TweenInfo.new(p511, Enum.EasingStyle.Linear), p512);
                end;

                local v514 = {};
                local v515 = {
                    ImageTransparency = 0,
                    Size = UDim2.fromScale(0.35, 0.35)
                };
                local v516 = TweenService:Create(Approved, TweenInfo.new(0.2, Enum.EasingStyle.Linear), v515);
                local v517 = {
                    Size = UDim2.fromScale(0.365, 0.365)
                };
                v514[1], v514[2], v514[3] = v516, TweenService:Create(Approved, TweenInfo.new(0.03, Enum.EasingStyle.Linear), v517), v513(0.03, {
    Size = UDim2.fromScale(0.35, 0.35)
});

                for _, v in ipairs(v514) do
                    v:Play();
                    v.Completed:Wait();

                    if u501 ~= u449 then
                        return;
                    end;
                end;
            end;

            task.wait(1.25);

            if u501 ~= u449 then
                return;
            end;

            finishTradeUpReveal(u418);
        end);
    end;

    Proceed.MouseButton1Click:Connect(handleTradeUpProceedClick);
    Proceed.Activated:Connect(function(p518) -- Line: 1149
        -- upvalues: handleTradeUpProceedClick (copy)
        if p518 and p518.UserInputType == Enum.UserInputType.Gamepad1 then
            handleTradeUpProceedClick();
        end;
    end);
    ActivateButton(Cancel);
    Cancel.Selectable = true;

    local function handleTradeUpCancelClick() -- Line: 3579
        -- upvalues: u420 (ref), Router (ref), u449 (ref), u419 (ref), u339 (copy), u340 (ref), setTradeUpItemSelectionState (copy), renderTradeUp (ref)
        if u420 then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u449 = u449 + 1;

        if u419 then
            table.clear(u339);
            u340 = nil;
        end;

        setTradeUpItemSelectionState();
        renderTradeUp();
    end;

    Cancel.MouseButton1Click:Connect(handleTradeUpCancelClick);
    Cancel.Activated:Connect(function(p519) -- Line: 1149
        -- upvalues: handleTradeUpCancelClick (copy)
        if p519 and p519.UserInputType == Enum.UserInputType.Gamepad1 then
            handleTradeUpCancelClick();
        end;
    end);
    Remotes.Store.TradeUpCompleted.Listen(function(p520) -- Line: 3597
        -- upvalues: u416 (ref), DataController (ref), LocalPlayer (ref), u419 (ref), u418 (ref)
        local v521;

        if p520 and typeof(p520.RequestId) == "string" then
            v521 = p520.RequestId;
        else
            v521 = nil;
        end;

        if not u416 or v521 ~= u416 then
            return;
        end;

        u416 = nil;
        DataController.ApplyInventoryDelta(LocalPlayer, { p520.InventoryItem }, p520.DeletedItemIds);
        u419 = true;
        u418 = p520.InventoryItem;
    end);
    Remotes.Store.TradeUpDenied.Listen(function(p522) -- Line: 3612
        -- upvalues: u416 (ref), u449 (ref), u420 (ref), u421 (ref), TradeUp2 (copy), u465 (ref)
        local v523;

        if p522 and typeof(p522.RequestId) == "string" then
            v523 = p522.RequestId;
        else
            v523 = nil;
        end;

        if v523 and (u416 and v523 ~= u416) then
            return;
        end;

        u416 = nil;
        u449 = u449 + 1;
        u420 = false;
        u421 = false;

        if TradeUp2.Visible then
            u465(false);
        end;
    end);
    ActivateButton(TradeUp);
    TradeUp.Selectable = true;

    local function u524() -- Line: 3628
        -- upvalues: u465 (ref), Router (ref)
        u465(true);
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end;

    TradeUp.MouseButton1Click:Connect(u524);
    TradeUp.Activated:Connect(function(p525) -- Line: 1149
        -- upvalues: u524 (copy)
        if p525 and p525.UserInputType == Enum.UserInputType.Gamepad1 then
            u524();
        end;
    end);
    u22 = (function() -- Line: 3634, Name: setupTradeUpTopBar
        -- upvalues: u20 (ref), Router (ref), BindSortDropdownFocus (ref), u336 (ref), u337 (ref), u344 (ref), renderTradeUpContainer (copy), u331 (copy), BindSearchTap (ref), TradeUp2 (copy), SetSearchTokens (ref), u338 (copy)
        local Top2 = u20.Frame.TradeUp.Top;
        local Weapon = Top2.Weapon;
        local Click = Weapon.Click;
        local DropdownContent2 = Weapon.DropdownContent;
        local Title3 = Weapon.Container.Left.Title;

        local function setDropdownOpen(p526: boolean) -- Line: 3641
            -- upvalues: DropdownContent2 (copy)
            local v527 = DropdownContent2;

            if not v527 then
                return;
            end;

            v527.Visible = p526;
            v527.Active = p526;
            local Scroll = v527:FindFirstChild("Scroll");

            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = p526;
                Scroll.Active = p526;
            end;
        end;

        Weapon.Active = false;
        Click.Selectable = true;

        if DropdownContent2 then
            DropdownContent2.Visible = false;
            DropdownContent2.Active = false;
            local Scroll = DropdownContent2:FindFirstChild("Scroll");

            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = false;
                Scroll.Active = false;
            end;
        end;

        Click.Activated:Connect(function() -- Line: 3649
            -- upvalues: DropdownContent2 (copy), Router (ref)
            local v528 = not DropdownContent2.Visible;
            local v529 = DropdownContent2;

            if v529 then
                v529.Visible = v528;
                v529.Active = v528;
                local Scroll = v529:FindFirstChild("Scroll");

                if Scroll and Scroll:IsA("GuiObject") then
                    Scroll.Visible = v528;
                    Scroll.Active = v528;
                end;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);
        BindSortDropdownFocus(DropdownContent2, Click, function() -- Line: 3654
            -- upvalues: u336 (ref), Click (copy)
            return u336 or Click.Frame.TextLabel.Text;
        end, "UI.Inventory.TradeUpSortFocusDeferred");
        local ReverseSort2 = Weapon.Container.Left.ReverseSort;
        ReverseSort2.Selectable = true;
        ReverseSort2.Activated:Connect(function() -- Line: 3661
            -- upvalues: u337 (ref), ReverseSort2 (copy), u344 (ref), renderTradeUpContainer (ref), Router (ref)
            u337 = not u337;
            local v530 = u337;
            local v531 = ReverseSort2:FindFirstChildOfClass("ImageLabel");

            if v531 then
                v531.Rotation = v530 and 180 or 0;
            end;

            u344 = true;
            renderTradeUpContainer();
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);

        for _, v in u331 do
            local u532 = DropdownContent2.Scroll:FindFirstChild(v);

            if u532 and u532:IsA("TextButton") then
                u532.Selectable = true;

                local function u534() -- Line: 3674
                    -- upvalues: Router (ref), u336 (ref), v (copy), u344 (ref), Title3 (copy), DropdownContent2 (copy), u532 (copy), renderTradeUpContainer (ref)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    u336 = v;
                    u344 = true;
                    Title3.Text = v;

                    for _, child in ipairs(DropdownContent2.Scroll:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.Frame.BackgroundTransparency = child == u532 and 0 or 1;
                        end;
                    end;

                    renderTradeUpContainer();
                    local v533 = DropdownContent2;

                    if not v533 then
                        return;
                    end;

                    v533.Visible = false;
                    v533.Active = false;
                    local Scroll = v533:FindFirstChild("Scroll");

                    if Scroll and Scroll:IsA("GuiObject") then
                        Scroll.Visible = false;
                        Scroll.Active = false;
                    end;
                end;

                u532.MouseButton1Click:Connect(u534);
                u532.Activated:Connect(function(p535) -- Line: 1149
                    -- upvalues: u534 (copy)
                    if p535 and p535.UserInputType == Enum.UserInputType.Gamepad1 then
                        u534();
                    end;
                end);
            end;
        end;

        local Title4 = Top2.Search.Container.Title;
        BindSearchTap(Top2.Search, Title4);
        Title4:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 3694
            -- upvalues: TradeUp2 (ref), SetSearchTokens (ref), u338 (ref), Title4 (copy), renderTradeUpContainer (ref)
            if not TradeUp2.Visible then
                return;
            end;

            SetSearchTokens(u338, Title4.Text);
            renderTradeUpContainer();
        end);

        return {
            setDropdownOpen = setDropdownOpen,
            searchTextBox = Title4
        };
    end)();
    u20.Frame.TradeUp.Top.TradeUp.Visible = false;
    u465(false);
    clearContractSlots();
    clearContractHeaderFields();
    task.spawn(function() -- Line: 3721
        -- upvalues: TradeUp2 (copy), ContentProvider (ref), u21 (ref)
        local v536 = {};
        local v537 = {};

        for _, descendant in ipairs(TradeUp2.TradeContainer.Contract:GetDescendants()) do
            if (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) and (descendant.Image ~= "" and not v536[descendant.Image]) then
                v536[descendant.Image] = true;
                table.insert(v537, descendant.Image);
            end;
        end;

        if #v537 == 0 then
            return;
        end;

        ContentProvider:PreloadAsync(v537);
        local Frame3 = Instance.new("Frame");
        Frame3.Name = "TradeUpContractImageWarmup";
        Frame3.BackgroundTransparency = 1;
        Frame3.Size = UDim2.fromOffset(1, 1);
        Frame3.Position = UDim2.fromOffset(0, 0);

        for _, v in ipairs(v537) do
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.ImageTransparency = 0.99;
            ImageLabel.Size = UDim2.fromOffset(1, 1);
            ImageLabel.Image = v;
            ImageLabel.Parent = Frame3;
        end;

        Frame3.Parent = u21;
        task.wait(0.5);
        Frame3:Destroy();
    end);

    if u21 and u21.Menu then
        u21.Menu.Top:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3760
            -- upvalues: u414 (ref), u21 (ref)
            if u414 and u21.Menu.Top.Visible then
                u21.Menu.Top.Visible = false;
            end;
        end);
    end;

    Router.observerRouter("ResetInventoryToGrid", function() -- Line: 3768
        -- upvalues: u465 (ref)
        u465(false);
    end);
    Title:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 3773
        -- upvalues: u20 (ref), SetSearchTokens (ref), u17 (ref), Title (copy), Profiler (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref)
        if not u20.Visible then
            return;
        end;

        SetSearchTokens(u17, Title.Text);
        Profiler.mark("UI.Inventory.ApplyCurrentSort");

        if not u20 then
            return;
        end;

        if not u20.Visible then
            return;
        end;

        u2 = GetSortedInventoryData();
        u2 = ApplyFilterToSortedData(u2);
        UpdateInventoryTemplates();
    end);

    local function handleInventoryClosed() -- Line: 3782
        -- upvalues: u19 (ref), u465 (ref), u17 (ref), Title (copy), u338 (copy), u339 (copy), u340 (ref), u22 (ref), UpdateInventoryTemplates (ref)
        local v538 = u19;

        if v538 then
            v538.Visible = false;
            v538.Active = false;
            local Scroll = v538:FindFirstChild("Scroll");

            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = false;
                Scroll.Active = false;
            end;
        end;

        u465(false);
        table.clear(u17);
        Title.Text = "";
        table.clear(u338);
        table.clear(u339);
        u340 = nil;

        if u22 then
            u22.setDropdownOpen(false);
            u22.searchTextBox.Text = "";
        end;

        UpdateInventoryTemplates();
    end;

    u20:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3804
        -- upvalues: syncInventoryUpdate (ref), u20 (ref), Profiler (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), u30 (ref), u24 (ref), u8 (ref), u1 (ref), ReportViewedItems (ref), MenuState (ref), handleInventoryClosed (copy)
        syncInventoryUpdate();

        if u20.Visible then
            Profiler.mark("UI.Inventory.ApplyCurrentSort");

            if u20 and u20.Visible then
                u2 = GetSortedInventoryData();
                u2 = ApplyFilterToSortedData(u2);
                UpdateInventoryTemplates();
            end;

            local v539 = u30;
            u30 = nil;
            local v540 = u24[u8];
            local v541;

            if v539 == nil or (v540 == nil or v540._id ~= v539) then
                v541 = false;
            else
                v541 = u20.Ignore.ItemNotification.Visible;
            end;

            local v542 = #u24;

            if not (v541 or (v542 <= 0 or u8 >= v542)) then
                u1.NextInventoryItem(u8 + 1);
            end;
        else
            u30 = nil;
            ReportViewedItems();

            if not MenuState.IsInspectActive() then
                handleInventoryClosed();
            end;
        end;
    end);
    MenuState.OnInspectStateChanged:Connect(function(p543: boolean) -- Line: 3835
        -- upvalues: u20 (ref), handleInventoryClosed (copy)
        if p543 then
            return;
        end;

        task.defer(function() -- Line: 3839
            -- upvalues: u20 (ref), handleInventoryClosed (ref)
            if not u20.Visible then
                handleInventoryClosed();
            end;
        end);
    end);

    if u21 and u21.Menu then
        u21.Menu:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3848
            -- upvalues: u21 (ref), u20 (ref), handleInventoryClosed (copy), syncInventoryUpdate (ref)
            if not u21.Menu.Visible and u20.Visible then
                u20.Visible = false;
                handleInventoryClosed();
                syncInventoryUpdate();
            end;
        end);
    end;

    u20.Frame.Right.Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 3858
        -- upvalues: OnScrollPositionChanged (ref)
        OnScrollPositionChanged();
    end);
    u20.Frame.Right.Container:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- Line: 3862
        -- upvalues: Profiler (ref), OnScrollPositionChanged (ref)
        Profiler.defer("UI.Inventory.ScrollDeferred", OnScrollPositionChanged);
    end);
end;

function u1.Start() -- Line: 3869
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), UserInputService (copy), u20 (ref), GuiService (copy), Router (copy), DismissItemNotifications (copy), CloseButtonRegistry (copy), u18 (ref), u1 (copy), syncInventoryUpdate (copy), Skins (copy), u27 (copy), u23 (ref), RefreshNewInventoryItems (copy), Remotes (copy), u16 (ref), Store (copy), u13 (ref), u9 (ref), u11 (ref), u2 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy), u4 (ref), UpdateStatusFrame (copy), MenuState (copy), u24 (copy), u8 (ref), CollectionService (copy), u37 (copy), ActivateButton (copy)
    debug.setmemorycategory("UI.Inventory.Start");
    Profiler.mark("UI.Inventory.Start.Begin");
    DataController.WaitForDataLoaded(LocalPlayer);
    Profiler.mark("UI.Inventory.Start.DataLoaded");
    Profiler.mark("UI.Inventory.Start.InitialCategory");
    local u544 = nil;

    local function setupGamepadNavigation() -- Line: 3878
        -- upvalues: Profiler (ref), u544 (ref), UserInputService (ref), u20 (ref), GuiService (ref), Router (ref), DismissItemNotifications (ref), CloseButtonRegistry (ref), u18 (ref)
        Profiler.mark("UI.Inventory.SetupGamepadNavigation");

        if u544 then
            u544:Disconnect();
        end;

        u544 = UserInputService.InputBegan:Connect(function(p545: userdata, p546: boolean) -- Line: 3885
            -- upvalues: u20 (ref), GuiService (ref), Router (ref), DismissItemNotifications (ref), CloseButtonRegistry (ref), u18 (ref)
            if p545.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            if not (u20 and (u20.Visible and not p546)) then
                return;
            end;

            local KeyCode = p545.KeyCode;
            local SelectedObject = GuiService.SelectedObject;
            local v547 = u20 and u20.Ignore.ItemNotification and u20.Ignore.ItemNotification.Visible;

            if KeyCode == Enum.KeyCode.ButtonB then
                if v547 then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    DismissItemNotifications();
                    CloseButtonRegistry.MarkUsed();

                    return;
                end;

                if u18 and u18.Visible then
                    u18.Visible = false;
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    CloseButtonRegistry.MarkUsed();

                    return;
                end;

                if u20 and u20.Tabs.Inventory.Sort.Button.Options.Visible then
                    u20.Tabs.Inventory.Sort.Button.Options.Visible = false;
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    CloseButtonRegistry.MarkUsed();

                    return;
                end;
            end;

            local v548 = KeyCode == Enum.KeyCode.DPadUp;
            local v549;

            if v548 or KeyCode == Enum.KeyCode.DPadDown then
                v549 = SelectedObject and SelectedObject:IsA("GuiButton") and (v548 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown);
            else
                v549 = false;
            end;

            if v547 then
                if v549 and (v549:IsDescendantOf(u20.Ignore.ItemNotification.Holder) and v549.Visible) then
                    GuiService.SelectedObject = v549;
                end;

                return;
            end;

            local v550 = u18 and u18.Visible;

            if v550 then
                if SelectedObject then
                    SelectedObject = SelectedObject:IsDescendantOf(u18);
                end;
            else
                SelectedObject = v550;
            end;

            if v549 and (not SelectedObject or v549:IsDescendantOf(u18)) then
                GuiService.SelectedObject = v549;
            end;
        end);
    end;

    local u551 = nil;

    local function setupSelectionProtection() -- Line: 3953
        -- upvalues: Profiler (ref), u551 (ref), GuiService (ref), u20 (ref), u1 (ref), u18 (ref)
        Profiler.mark("UI.Inventory.SetupSelectionProtection");

        if u551 then
            u551:Disconnect();
        end;

        u551 = GuiService.Changed:Connect(function(p552) -- Line: 3959
            -- upvalues: u20 (ref), GuiService (ref), Profiler (ref), u1 (ref), u18 (ref)
            if p552 ~= "SelectedObject" then
                return;
            end;

            local v553 = u20 and u20.Ignore.ItemNotification;

            if v553 and v553.Visible then
                local Holder = v553.Holder;
                local SelectedObject = GuiService.SelectedObject;

                if SelectedObject and (SelectedObject ~= Holder.Continue and (SelectedObject ~= Holder.ViewLoadout and not (SelectedObject:IsDescendantOf(Holder) and SelectedObject:IsA("GuiButton")))) then
                    Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u1.SelectFirstItemNotificationButton);
                end;

                return;
            end;

            if not (u18 and u18.Visible) then
                return;
            end;

            local SelectedObject = GuiService.SelectedObject;

            if SelectedObject and not SelectedObject:IsDescendantOf(u18) then
                Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u1.SelectFirstInformationFrameButton);
            end;
        end);
    end;

    if u20 then
        u20:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3998
            -- upvalues: u20 (ref), Profiler (ref), u544 (ref), UserInputService (ref), GuiService (ref), Router (ref), DismissItemNotifications (ref), CloseButtonRegistry (ref), u18 (ref), u551 (ref), u1 (ref)
            if u20.Visible then
                Profiler.mark("UI.Inventory.SetupGamepadNavigation");

                if u544 then
                    u544:Disconnect();
                end;

                u544 = UserInputService.InputBegan:Connect(function(p554: userdata, p555: boolean) -- Line: 3885
                    -- upvalues: u20 (ref), GuiService (ref), Router (ref), DismissItemNotifications (ref), CloseButtonRegistry (ref), u18 (ref)
                    if p554.UserInputType ~= Enum.UserInputType.Gamepad1 then
                        return;
                    end;

                    if not (u20 and (u20.Visible and not p555)) then
                        return;
                    end;

                    local KeyCode = p554.KeyCode;
                    local SelectedObject = GuiService.SelectedObject;
                    local v556 = u20 and u20.Ignore.ItemNotification and u20.Ignore.ItemNotification.Visible;

                    if KeyCode == Enum.KeyCode.ButtonB then
                        if v556 then
                            Router.broadcastRouter("RunInterfaceSound", "UI Click");
                            DismissItemNotifications();
                            CloseButtonRegistry.MarkUsed();

                            return;
                        end;

                        if u18 and u18.Visible then
                            u18.Visible = false;
                            Router.broadcastRouter("RunInterfaceSound", "UI Click");
                            CloseButtonRegistry.MarkUsed();

                            return;
                        end;

                        if u20 and u20.Tabs.Inventory.Sort.Button.Options.Visible then
                            u20.Tabs.Inventory.Sort.Button.Options.Visible = false;
                            Router.broadcastRouter("RunInterfaceSound", "UI Click");
                            CloseButtonRegistry.MarkUsed();

                            return;
                        end;
                    end;

                    local v557 = KeyCode == Enum.KeyCode.DPadUp;
                    local v558;

                    if v557 or KeyCode == Enum.KeyCode.DPadDown then
                        v558 = SelectedObject and SelectedObject:IsA("GuiButton") and (v557 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown);
                    else
                        v558 = false;
                    end;

                    if v556 then
                        if v558 and (v558:IsDescendantOf(u20.Ignore.ItemNotification.Holder) and v558.Visible) then
                            GuiService.SelectedObject = v558;
                        end;

                        return;
                    end;

                    local v559 = u18 and u18.Visible;

                    if v559 then
                        if SelectedObject then
                            SelectedObject = SelectedObject:IsDescendantOf(u18);
                        end;
                    else
                        SelectedObject = v559;
                    end;

                    if v558 and (not SelectedObject or v558:IsDescendantOf(u18)) then
                        GuiService.SelectedObject = v558;
                    end;
                end);
                Profiler.mark("UI.Inventory.SetupSelectionProtection");

                if u551 then
                    u551:Disconnect();
                end;

                u551 = GuiService.Changed:Connect(function(p560) -- Line: 3959
                    -- upvalues: u20 (ref), GuiService (ref), Profiler (ref), u1 (ref), u18 (ref)
                    if p560 ~= "SelectedObject" then
                        return;
                    end;

                    local v561 = u20 and u20.Ignore.ItemNotification;

                    if v561 and v561.Visible then
                        local Holder = v561.Holder;
                        local SelectedObject = GuiService.SelectedObject;

                        if SelectedObject and (SelectedObject ~= Holder.Continue and (SelectedObject ~= Holder.ViewLoadout and not (SelectedObject:IsDescendantOf(Holder) and SelectedObject:IsA("GuiButton")))) then
                            Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u1.SelectFirstItemNotificationButton);
                        end;

                        return;
                    end;

                    if not (u18 and u18.Visible) then
                        return;
                    end;

                    local SelectedObject = GuiService.SelectedObject;

                    if SelectedObject and not SelectedObject:IsDescendantOf(u18) then
                        Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u1.SelectFirstInformationFrameButton);
                    end;
                end);

                if UserInputService.GamepadEnabled then
                    Profiler.defer("UI.Inventory.AutoSelectDeferred", function() -- Line: 4004
                        -- upvalues: GuiService (ref), u20 (ref)
                        local v562 = 0;

                        while v562 < 5 do
                            task.wait(0.1);
                            v562 = v562 + 1;

                            if GuiService.SelectedObject or not (u20 and u20.Visible) then
                                break;
                            end;

                            if u20.Frame.Right.Container then
                                for _, child in ipairs(u20.Frame.Right.Container:GetChildren()) do
                                    if child:IsA("Frame") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
                                        local Button = child:FindFirstChild("Button");

                                        if Button and (Button:IsA("GuiButton") and (Button.Selectable and Button.Visible)) then
                                            GuiService.SelectedObject = Button;

                                            return;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end);
                end;
            else
                if u544 then
                    u544:Disconnect();
                    u544 = nil;
                end;

                if u551 then
                    u551:Disconnect();
                    u551 = nil;
                end;
            end;
        end);
    end;

    syncInventoryUpdate();
    Skins.OnItemStockSchemasUpdated:Connect(function(p563) -- Line: 4052
        -- upvalues: Profiler (ref), DataController (ref), LocalPlayer (ref), u1 (ref)
        Profiler.mark("UI.Inventory.ItemStockSchemasUpdated");
        local v564 = DataController.Get(LocalPlayer, "Inventory");
        u1.UpdateTemplates(v564);
    end);
    DataController.CreateListener(LocalPlayer, "New Inventory Items", function(p565) -- Line: 4059
        -- upvalues: Profiler (ref), u27 (ref), u23 (ref), RefreshNewInventoryItems (ref)
        Profiler.mark("UI.Inventory.NewInventoryItemsChanged");

        if type(p565) ~= "table" then
            return;
        end;

        local os_clock_ret = os.clock();

        for i, v in u27 do
            if os_clock_ret - v >= 10 then
                u27[i] = nil;
            end;
        end;

        local v566 = {};

        for _, v in ipairs(p565) do
            if not u27[v] then
                table.insert(v566, v);
            end;
        end;

        u23 = v566;
        RefreshNewInventoryItems();
    end);
    Remotes.Store.CaseOpenDenied.Listen(function(p567) -- Line: 4084
        -- upvalues: u16 (ref), Store (ref), u13 (ref), Router (ref)
        local v568;

        if p567 and typeof(p567.RequestId) == "string" then
            v568 = p567.RequestId;
        else
            v568 = nil;
        end;

        local v569;

        if v568 then
            v569 = u16 == v568;
        else
            v569 = v568;
        end;

        if v569 and (not v568 or u16 == v568) then
            if u16 then
                Store.ClearPendingOpenCaseRequest(u16);
            end;

            u13 = false;
            u16 = nil;
        end;

        if v569 and (p567 and p567.Reason == "RateLimited") then
            local v570 = (tonumber(p567.RetryAfterMs) or 0) / 1000;
            local v571 = v570 <= 0 and "Quick open is rate limited. Please wait a moment and try again." or string.format("Quick open is rate limited. Wait %.1fs and try again.", v570);
            Router.broadcastRouter("CreateMenuNotification", "Error", v571);
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Inventory", function(p572) -- Line: 4099
        -- upvalues: Profiler (ref), u1 (ref), RefreshNewInventoryItems (ref), u9 (ref), u20 (ref), u11 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), u18 (ref), u4 (ref)
        Profiler.mark("UI.Inventory.InventoryChanged");
        u1.UpdateInventory(p572);
        RefreshNewInventoryItems();

        if not u9 then
            u20.Frame.Right.Top.Filter.Container.Left.Title.Text = "Newest";
            u11 = "Newest";
            u9 = true;
        end;

        Profiler.mark("UI.Inventory.ApplyCurrentSort");

        if u20 and u20.Visible then
            u2 = GetSortedInventoryData();
            u2 = ApplyFilterToSortedData(u2);
            UpdateInventoryTemplates();
        end;

        if u18 and (u18.Visible and (u4 and (u4._id and type(p572) == "table"))) then
            local _id = u4._id;
            local v573 = nil;

            for _, v in ipairs(p572) do
                if v._id == _id then
                    v573 = v;
                    break;
                end;
            end;

            if v573 then
                u4 = v573;
                u1.SetupInformationFrame(v573);
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 4127
        -- upvalues: Profiler (ref), u20 (ref), UpdateStatusFrame (ref)
        Profiler.mark("UI.Inventory.LoadoutChanged");

        if u20 and u20.Visible then
            for _, child in ipairs(u20.Frame.Right.Container:GetChildren()) do
                local v574 = child:IsA("ImageButton");

                if v574 then
                    if child.Name == "UIGridLayout" or (child.Name == "UIListLayout" or (child.Name == "UIPadding" or child.Name == "Title")) then
                        v574 = false;
                    else
                        v574 = child.Name ~= "Label";
                    end;
                end;

                if v574 then
                    UpdateStatusFrame(child, child.Name);
                end;
            end;
        end;
    end);
    MenuState.OnInspectStateChanged:Connect(function(p575: boolean) -- Line: 4140
        -- upvalues: Profiler (ref), u24 (ref), u20 (ref), u8 (ref), u1 (ref)
        if not p575 then
            Profiler.defer("UI.Inventory.InspectClosedDeferred", function() -- Line: 4142
                -- upvalues: u24 (ref), u20 (ref), u8 (ref), u1 (ref)
                local v576 = #u24;

                if u20.Visible and (v576 > 0 and u8 < v576) then
                    u1.NextInventoryItem(u8 + 1);
                end;
            end);
        end;
    end);
    Router.observerRouter("QuickOpenResolved", function(p577) -- Line: 4155
        -- upvalues: u16 (ref), Store (ref), u13 (ref)
        if typeof(p577) == "string" then
            if p577 and u16 ~= p577 then
                return;
            end;

            if u16 then
                Store.ClearPendingOpenCaseRequest(u16);
            end;

            u13 = false;
            u16 = nil;
        end;
    end);
    Router.observerRouter("ShowNewItemNotification", u1.ShowNewItemNotification);

    for _, v in CollectionService:GetTagged("CategoryFilter") do
        u37[v.Name] = true;
        ActivateButton(v.Button);
        v.Button.Activated:Connect(function() -- Line: 4168
            -- upvalues: u37 (ref), v (copy), Profiler (ref), u20 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref)
            u37[v.Name] = not u37[v.Name];
            v.Button.ImageLabel.Visible = u37[v.Name];
            Profiler.mark("UI.Inventory.ApplyCurrentSort");

            if not u20 then
                return;
            end;

            if not u20.Visible then
                return;
            end;

            u2 = GetSortedInventoryData();
            u2 = ApplyFilterToSortedData(u2);
            UpdateInventoryTemplates();
        end);
    end;

    for _, v in CollectionService:GetTagged("CategoryButtons") do
        v.Activated:Connect(function() -- Line: 4176
            -- upvalues: v (copy)
            v.Parent[`{v.Name}Filter`].Visible = not v.Parent[`{v.Name}Filter`].Visible;
            v.Icon.Rotation = v.Parent[`{v.Name}Filter`].Visible and 180 or 0;
        end);
    end;
end;

return u1;