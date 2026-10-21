-- ReplicatedStorage.Interface.Screens.Menu.Inventory
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Inventory
-- Decompile time: 81.49 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
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
local ItemCard = require(ReplicatedStorage.Components.Common.ItemCard);
local GetIconImage = ItemCard.GetIconImage;
local GetDisplayName = ItemCard.GetDisplayName;
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
    Special = "Drop Gold",
    Red = "Drop Red",
    Pink = "Drop Pink",
    Purple = "Drop Purple",
    Blue = "Drop Blue"
};
local u34 = {
    Glove = "Equipped Gloves",
    Badge = "Equipped Badge",
    ["Zeus x27"] = "Equipped Zeus x27"
};
local u35 = {
    Pistol = "Pistols",
    SMG = "Mid Tier",
    Heavy = "Mid Tier",
    Rifle = "Rifles"
};
local u36 = {};
local u37 = {};
local u38 = {};
local u39 = nil;

local function setReverseSortVisual(p40: userdata, p41: boolean) -- Line: 173
    local v42 = p40:FindFirstChildOfClass("ImageLabel");

    if v42 then
        v42.Rotation = p41 and 180 or 0;
    end;
end;

local function ClearQuickOpenPending(p43: string?) -- Line: 180
    -- upvalues: u16 (ref), Store (copy), u13 (ref)
    if p43 and u16 ~= p43 then
        return false;
    end;

    if u16 then
        Store.ClearPendingOpenCaseRequest(u16);
    end;

    u13 = false;
    u16 = nil;

    return true;
end;

local u44 = { "Charm", "Inspect", "ReplaceCT", "ReplaceT", "Unlock" };

local function GetVisibleInformationFrameButtons() -- Line: 197
    -- upvalues: u44 (copy), u18 (ref)
    local v45 = {};

    for _, v in u44 do
        local v46 = u18[v];

        if v46 and v46.Visible then
            table.insert(v45, v46);
        end;
    end;

    local QuickUnlock = u18:FindFirstChild("QuickUnlock");

    if QuickUnlock and QuickUnlock.Visible then
        table.insert(v45, QuickUnlock);
    end;

    return v45;
end;

local function hasAnyInformationFrameButton() -- Line: 212
    -- upvalues: u18 (ref), GetVisibleInformationFrameButtons (copy)
    local v47;

    if u18 == nil then
        v47 = false;
    else
        v47 = #GetVisibleInformationFrameButtons() > 0;
    end;

    return v47;
end;

local function ItemHasCharm(p48) -- Line: 216
    local Charm = p48.Charm;
    local v49;

    if Charm == nil or Charm == false then
        v49 = false;
    else
        v49 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
    end;

    return v49;
end;

local function GetInventoryItemFromIdentifier(p50: table, p51: string) -- Line: 223
    for _, v in ipairs(p50) do
        if v._id == p51 then
            return v;
        end;
    end;

    return nil;
end;

local function IsWeaponEquippedInTeamCategory(p52: string, p53: string, p54: string) -- Line: 238
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v55 = DataController.Get(LocalPlayer, "Loadout");
    local v56 = DataController.Get(LocalPlayer, "Inventory");

    if not (v55 and v56) then
        return false, nil;
    end;

    local v57 = v55[p53];

    if not (v57 and (v57.Loadout and v57.Loadout[p54])) then
        return false, nil;
    end;

    for i, v in ipairs(v57.Loadout[p54].Options) do
        if v and v ~= "" then
            local v58 = i;
            local v59 = v;
            local v60 = nil;

            for _, v2 in ipairs(v56) do
                if v2._id == v59 then
                    v60 = v2;
                    break;
                end;
            end;

            if v60 and v60.Name == p52 then
                return true, v58;
            end;
        end;
    end;

    return false, nil;
end;

local function GetWeaponCategory(p61: string) -- Line: 269
    -- upvalues: GetWeaponProperties (copy), u35 (copy)
    local success, result = pcall(GetWeaponProperties, p61);

    if success and (result and result.Type) then
        return u35[result.Type];
    end;

    return nil;
end;

local function ReplaceItemOnTeam(p62: any, p63: string) -- Line: 280
    -- upvalues: GetWeaponProperties (copy), u35 (copy), IsWeaponEquippedInTeamCategory (copy), Remotes (copy), Top (copy), Loadout (copy), Profiler (copy), u34 (copy)
    if p62.Type ~= "Weapon" then
        if p62.Type ~= "Melee" then
            if u34[p62.Type] then
                Remotes.Inventory.EquipSpecialItem.Send({
                    Identifier = p62._id,
                    Path = u34[p62.Type],
                    Team = p63
                });
            end;

            return;
        end;

        if p62.Name == "CT Knife" and p63 == "Terrorists" or p62.Name == "T Knife" and p63 == "Counter-Terrorists" then
            return;
        end;

        Remotes.Inventory.EquipSpecialItem.Send({
            Path = "Equipped Melee",
            Identifier = p62._id,
            Team = p63
        });

        return;
    end;

    local Name = p62.Name;
    local success, result = pcall(GetWeaponProperties, Name);
    local v64;

    if success and (result and result.Type) then
        v64 = u35[result.Type];
    else
        v64 = nil;
    end;

    if not v64 then
        return;
    end;

    local v65, v66 = IsWeaponEquippedInTeamCategory(Name, p63, v64);

    if v65 and v66 then
        Remotes.Inventory.EquipLoadoutSkin.Send({
            Type = v64,
            Slot = v66 - 1,
            Team = p63,
            Identifier = p62._id
        });

        return;
    end;

    Top.openFrame("Loadout");
    Loadout.SelectTeam(p63 == "Counter-Terrorists" and "CT" or "T");
    Loadout.SortByCategory(nil);
    Loadout.SortByWeapon(Name);
    Profiler.defer("UI.Inventory.LoadoutWeaponFilterDeferred", Loadout.SortByWeapon, Name);
end;

local function SetDropdownOpen(p67: userdata?, p68: boolean) -- Line: 331
    if not p67 then
        return;
    end;

    p67.Visible = p68;
    p67.Active = p68;
    local Scroll = p67:FindFirstChild("Scroll");

    if Scroll and Scroll:IsA("GuiObject") then
        Scroll.Visible = p68;
        Scroll.Active = p68;
    end;
end;

local function setSortDropdownOpen(p69: boolean) -- Line: 346
    -- upvalues: u19 (ref)
    local v70 = u19;

    if not v70 then
        return;
    end;

    v70.Visible = p69;
    v70.Active = p69;
    local Scroll = v70:FindFirstChild("Scroll");

    if Scroll and Scroll:IsA("GuiObject") then
        Scroll.Visible = p69;
        Scroll.Active = p69;
    end;
end;

local function BindSortDropdownFocus(u71: any, u72: userdata, u73: function, u74: string) -- Line: 351
    -- upvalues: GuiService (copy), Profiler (copy)
    local function getInitialSortOption() -- Line: 357
        -- upvalues: u71 (copy), u73 (copy)
        local v75 = u71.Scroll:FindFirstChild(u73());

        if v75 and (v75:IsA("GuiButton") and v75.Selectable) then
            return v75;
        end;

        for _, child in ipairs(u71.Scroll:GetChildren()) do
            if child:IsA("GuiButton") and child.Selectable then
                return child;
            end;
        end;

        return nil;
    end;

    u71:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 370
        -- upvalues: GuiService (ref), u71 (copy), getInitialSortOption (copy), Profiler (ref), u74 (copy), u72 (copy)
        if GuiService.SelectedObject == nil then
            return;
        end;

        if u71.Visible then
            local u76 = getInitialSortOption();

            if u76 then
                Profiler.defer(u74, function() -- Line: 377
                    -- upvalues: u71 (ref), GuiService (ref), u76 (copy)
                    if u71.Visible then
                        GuiService.SelectedObject = u76;
                    end;
                end);
            end;
        else
            local SelectedObject = GuiService.SelectedObject;

            if SelectedObject and SelectedObject:IsDescendantOf(u71.Scroll) then
                GuiService.SelectedObject = u72;
            end;
        end;
    end);
end;

local function BindSearchTap(p77: userdata, u78: userdata) -- Line: 394
    p77.MouseButton1Click:Connect(function() -- Line: 395
        -- upvalues: u78 (copy)
        u78:CaptureFocus();
    end);
    p77.Activated:Connect(function() -- Line: 398
        -- upvalues: u78 (copy)
        u78:CaptureFocus();
    end);
end;

local function IsMouseOverVisibleGui(p79: userdata?, p80) -- Line: 403
    if not (p79 and p79.Visible) then
        return false;
    end;

    local AbsolutePosition = p79.AbsolutePosition;
    local AbsoluteSize = p79.AbsoluteSize;
    local v81;

    if p80.X >= AbsolutePosition.X and (p80.X <= AbsolutePosition.X + AbsoluteSize.X and p80.Y >= AbsolutePosition.Y) then
        v81 = p80.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v81 = false;
    end;

    return v81;
end;

local function IsMouseOverBlockingUI() -- Line: 414
    -- upvalues: Mouse (copy), u20 (ref), u19 (ref), u18 (ref)
    local Vector2_new_ret = Vector2.new(Mouse.X, Mouse.Y);

    if u20.Ignore.ItemNotification.Visible then
        return true;
    end;

    local v82 = u19;
    local v83;

    if v82 and v82.Visible then
        local AbsolutePosition = v82.AbsolutePosition;
        local AbsoluteSize = v82.AbsoluteSize;

        if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
            v83 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v83 = false;
        end;
    else
        v83 = false;
    end;

    if not v83 then
        local v84 = u18;

        if not (v84 and v84.Visible) then
            return false;
        end;

        local AbsolutePosition = v84.AbsolutePosition;
        local AbsoluteSize = v84.AbsoluteSize;

        if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
            v83 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v83 = false;
        end;
    end;

    return v83;
end;

local function shouldRunInventoryUpdate() -- Line: 425
    -- upvalues: u20 (ref)
    local v85;

    if u20 == nil then
        v85 = false;
    else
        v85 = u20.Visible;
    end;

    return v85;
end;

local function stopInventoryUpdate() -- Line: 431
    -- upvalues: u31 (ref)
    if u31 then
        u31:Disconnect();
        u31 = nil;
    end;
end;

local u86 = { "Hover", "HoverNoCollection", "HoverDefault" };

local function HideHoverFrames(p87: userdata?) -- Line: 445
    -- upvalues: u86 (copy), u20 (ref)
    for _, v in u86 do
        local v88 = u20.Ignore[v];

        if v88 ~= p87 then
            v88.Visible = false;
        end;
    end;
end;

local function updateInventoryHeartbeat(p89: number) -- Line: 456
    -- upvalues: Profiler (copy), u20 (ref), u21 (ref), u31 (ref), u3 (copy), u1 (copy), u86 (copy)
    Profiler.mark("UI.Inventory.Heartbeat");

    if not (u20 and u21) then
        if u31 then
            u31:Disconnect();
            u31 = nil;
        end;

        return;
    end;

    local v90;

    if u20 == nil then
        v90 = false;
    else
        v90 = u20.Visible;
    end;

    if v90 and (u3 and u20.Visible) then
        u1.UpdateHoverFrame(p89);
    else
        for _, v in u86 do
            local v91 = u20.Ignore[v];

            if v91 ~= nil then
                v91.Visible = false;
            end;
        end;
    end;

    if v90 and u20.Ignore.ItemNotification.Visible then
        u20.Ignore.ItemNotification.Holder.Light.Rotation = u20.Ignore.ItemNotification.Holder.Light.Rotation + p89 * 10;
    end;

    if not v90 and u31 then
        u31:Disconnect();
        u31 = nil;
    end;
end;

local function syncInventoryUpdate() -- Line: 482
    -- upvalues: u20 (ref), u21 (ref), u24 (copy), u25 (copy), u8 (ref), u31 (ref), RunServiceController (copy), updateInventoryHeartbeat (copy)
    if not (u20 and u21) then
        return;
    end;

    local v92 = 0;

    for _, v in ipairs(u24) do
        if not u25[v._id] then
            v92 = v92 + 1;
        end;
    end;

    local Alert = u21.Menu.Top.Bottom.Buttons.Inventory.Alert;
    Alert.TextLabel.Text = v92;
    Alert.Visible = v92 > 0;
    local v93 = #u24;
    local Holder = u20.Ignore.ItemNotification.Holder;
    Holder.Amount.TextLabel.Text = `{u8} / {v93}`;
    Holder.Right.Visible = u8 < v93;
    Holder.Left.Visible = u8 > 1;
    local v94;

    if u20 == nil then
        v94 = false;
    else
        v94 = u20.Visible;
    end;

    if not v94 then
        updateInventoryHeartbeat(0);

        return;
    end;

    if u31 then
        return;
    end;

    u31 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
    updateInventoryHeartbeat(0);
end;

local function CalculateHoverPosition(p95: any, p96: userdata) -- Line: 514
    -- upvalues: u20 (ref), GuiService (copy)
    local AbsolutePosition = u20.AbsolutePosition;
    local AbsoluteSize = p96.AbsoluteSize;
    local AbsolutePosition2 = p95.AbsolutePosition;
    local AbsoluteSize2 = u20.AbsoluteSize;
    local AbsoluteSize3 = p95.AbsoluteSize;
    local v97 = AbsolutePosition2.X - AbsolutePosition.X;
    local v98 = AbsoluteSize2.X - (v97 + AbsoluteSize3.X) >= AbsoluteSize.X + 8 and (v97 + AbsoluteSize3.X + 8 + AbsoluteSize.X / 2) / AbsoluteSize2.X or (v97 - 8 - AbsoluteSize.X / 2) / AbsoluteSize2.X;
    local math_max_ret = math.max((AbsolutePosition2.Y - AbsolutePosition.Y + AbsoluteSize3.Y / 2) / AbsoluteSize2.Y, AbsoluteSize.Y / 2 / AbsoluteSize2.Y);
    local v99 = 1 - AbsoluteSize.Y / 2 / AbsoluteSize2.Y;
    local math_min_ret = math.min(math_max_ret, v99);

    if GuiService:GetGuiInset().Y >= AbsolutePosition.Y + math_min_ret * AbsoluteSize2.Y - AbsoluteSize.Y / 2 then
        math_min_ret = math.min(math_min_ret + 30 / AbsoluteSize2.Y, v99);
    end;

    return UDim2.fromScale(v98, math_min_ret);
end;

local function ReportViewedItems() -- Line: 561
    -- upvalues: u26 (copy), Remotes (copy)
    local v100 = {};

    for i in u26 do
        table.insert(v100, i);
    end;

    table.clear(u26);

    if #v100 > 0 then
        Remotes.Player.NewInventoryItemsSeen.Send({
            Dismissed = false,
            ItemIds = v100
        });
    end;
end;

local function MarkItemViewed(p101: string) -- Line: 572
    -- upvalues: u25 (copy), u26 (copy), u28 (ref), ReportViewedItems (copy)
    if u25[p101] then
        return;
    end;

    u25[p101] = true;
    u26[p101] = true;

    if not u28 then
        u28 = true;
        task.delay(2, function() -- Line: 581
            -- upvalues: u28 (ref), ReportViewedItems (ref)
            u28 = false;
            ReportViewedItems();
        end);
    end;
end;

local function DismissItemNotifications() -- Line: 588
    -- upvalues: u20 (ref), u8 (ref), u29 (ref), u24 (copy), u27 (copy), u26 (copy), Remotes (copy), u23 (ref), u25 (copy), u32 (ref), syncInventoryUpdate (copy)
    u20.Ignore.ItemNotification.Visible = false;
    u8 = 0;
    u29 = nil;
    local os_clock_ret = os.clock();
    local v102 = {};
    local v103 = {};

    for _, v in ipairs(u24) do
        table.insert(v102, v._id);
        v103[v._id] = true;
        u27[v._id] = os_clock_ret;
    end;

    if #v102 > 0 then
        table.clear(u26);
        Remotes.Player.NewInventoryItemsSeen.Send({
            Dismissed = true,
            ItemIds = v102
        });
        local v104 = {};

        for _, v in ipairs(u23) do
            if not v103[v] then
                table.insert(v104, v);
            end;
        end;

        u23 = v104;
    end;

    table.clear(u24);
    table.clear(u25);
    u32 = false;
    syncInventoryUpdate();
end;

local function FindQueuedItemIndex(p105: string) -- Line: 620
    -- upvalues: u24 (copy)
    for i, v in ipairs(u24) do
        if v._id == p105 then
            return i;
        end;
    end;

    return nil;
end;

local function RefreshNewInventoryItems() -- Line: 630
    -- upvalues: u24 (copy), u8 (ref), DataController (copy), LocalPlayer (copy), u23 (ref), u25 (copy), u20 (ref), u32 (ref), u1 (copy), u29 (ref), syncInventoryUpdate (copy)
    local v106 = u24[u8];
    local v107 = {};
    local v108 = DataController.Get(LocalPlayer, "Inventory");

    if type(v108) == "table" then
        for _, v in ipairs(v108) do
            if v._id then
                v107[v._id] = v;
            end;
        end;
    end;

    table.clear(u24);
    local v109 = {};

    for _, v in ipairs(u23) do
        v109[v] = true;
        local v110 = v107[v];

        if v110 then
            table.insert(u24, v110);
        end;
    end;

    for i in u25 do
        if not v109[i] then
            u25[i] = nil;
        end;
    end;

    local v111;

    if u20 == nil then
        v111 = false;
    else
        v111 = u20.Ignore.ItemNotification.Visible;
    end;

    local v112;

    if v111 then
        v112 = u20.Visible;
    else
        v112 = v111;
    end;

    if #u24 == 0 then
        if v111 then
            u20.Ignore.ItemNotification.Visible = false;
        end;

        u8 = 0;
        u32 = false;
    else
        if v106 then
            local _id = v106._id;
            v106 = nil;

            for i, v in ipairs(u24) do
                if v._id == _id then
                    v106 = i;
                    break;
                end;
            end;
        end;

        if v106 then
            u8 = v106;
        else
            local v113 = 0;

            for _, v in ipairs(u24) do
                if not u25[v._id] then
                    break;
                end;

                v113 = v113 + 1;
            end;

            u8 = v113;

            if v112 then
                u1.NextInventoryItem((math.min(v113 + 1, #u24)));
            elseif v111 then
                u20.Ignore.ItemNotification.Visible = false;
            end;
        end;
    end;

    local v114 = u29;

    if v114 then
        local v115 = u29;
        v114 = nil;

        for i, v in ipairs(u24) do
            if v._id == v115 then
                v114 = i;
                break;
            end;
        end;
    end;

    if v114 then
        u29 = nil;

        if u20 and u20.Visible then
            u1.NextInventoryItem(v114);
        else
            u8 = v114 - 1;
        end;
    end;

    syncInventoryUpdate();
end;

local function InspectInventoryItem(p116) -- Line: 706
    -- upvalues: Router (copy)
    Router.broadcastRouter("WeaponInspect", p116.Name, p116.Skin, p116.Float, p116.StatTrack, p116.NameTag, p116.Charm, p116.Stickers, p116.Type, p116.Pattern, p116._id, p116.Serial, p116.IsTradeable);
end;

local function GetCollectionNameForItem(p117) -- Line: 726
    -- upvalues: Cases (copy), u10 (ref), GetResolvedSkinInformation (copy)
    if p117.Type ~= "Case" then
        local v118 = GetResolvedSkinInformation(p117.Name, p117.Skin);

        return v118 and v118.collection or nil;
    end;

    local CaseByName = Cases.GetCaseByName(p117.Skin);

    if not (CaseByName and u10) then
        return nil;
    end;

    for _, v in ipairs(u10) do
        if v.cases then
            local v119 = v;

            for _, v2 in ipairs(v.cases) do
                if v2 == CaseByName.name then
                    return v119.name;
                end;
            end;
        end;
    end;

    return nil;
end;

local function GetSortedInventoryData() -- Line: 755
    -- upvalues: DataController (copy), LocalPlayer (copy), u11 (ref), u20 (ref), Sort (copy), u10 (ref), Grenades (copy), u12 (ref)
    local v120 = DataController.Get(LocalPlayer, "Inventory");

    if not v120 then
        return {};
    end;

    local SortComparisonFunction = Sort.GetSortComparisonFunction(u11 or u20.Frame.Right.Top.Filter.Container.Left.Title.Text, LocalPlayer, function() -- Line: 763
        -- upvalues: u10 (ref)
        return u10;
    end);
    local v121 = {};

    for _, v in v120 do
        local v122;

        if v then
            v122 = Grenades[v.Name];
        else
            v122 = v;
        end;

        local v123;

        if v then
            v123 = v.Type == "Case" and true or v.Type == "Package";
        else
            v123 = v;
        end;

        if v and (v._id and v.Name) and (v123 or v.Skin) and not v122 then
            table.insert(v121, v);
        end;
    end;

    if SortComparisonFunction then
        if u12 then
            table.sort(v121, function(p124, p125) -- Line: 781
                -- upvalues: SortComparisonFunction (copy)
                local v126, v127 = SortComparisonFunction(p124, p125);

                if v127 then
                    return v126;
                end;

                return SortComparisonFunction(p125, p124);
            end);

            return v121;
        end;

        table.sort(v121, SortComparisonFunction);
    end;

    return v121;
end;

local function IsNotFiltered(p128: any, p129: table) -- Line: 800
    -- upvalues: Buttons (copy), GetWeaponProperties (copy)
    if not p129 or #p129 == 0 then
        return true;
    end;

    local EffectiveItemType = Buttons.GetEffectiveItemType(p128);
    local v130 = Buttons.IsCapsule(p128);

    for _, v in ipairs(p129) do
        if EffectiveItemType == v then
            return true;
        end;

        if p128.Type and (p128.Type == v and not v130) then
            return true;
        end;

        local v131;

        if p128.Name then
            v131 = GetWeaponProperties(p128.Name);
        else
            v131 = nil;
        end;

        if string.find(v, ":") then
            local string_split_ret = string.split(v, ":");

            if string_split_ret[1] == "Weapon" and (v131 and (v131.Class == "Weapon" and string_split_ret[2] == v131.Type)) then
                return true;
            end;
        elseif v131 and v131.Class == v then
            return true;
        end;
    end;

    return false;
end;

local function SetSearchTokens(p132: table, p133: string) -- Line: 850
    table.clear(p132);

    if p133 ~= "" then
        for _, v in ipairs(string.split(string.lower(p133), " ")) do
            if v ~= "" then
                table.insert(p132, v);
            end;
        end;
    end;
end;

local function MatchesSearchQuery(p134) -- Line: 862
    -- upvalues: u17 (copy), GetSkinDisplayName (copy)
    if #u17 == 0 then
        return true;
    end;

    local v135 = GetSkinDisplayName.GetSearchIdentity(p134.Name, p134.Skin):lower();

    for _, v in ipairs(u17) do
        if string.find(v135, v, 1, true) == nil then
            return false;
        end;
    end;

    return true;
end;

local function GetItemCategoryOption(p136) -- Line: 878
    -- upvalues: u38 (copy), u37 (copy), IsNotFiltered (copy)
    local v137 = u38[p136._id];

    if v137 ~= nil then
        return v137 or nil;
    end;

    local v138 = nil;

    for i, v in u37 do
        if IsNotFiltered(p136, v.Search) then
            v138 = i;
            break;
        end;
    end;

    u38[p136._id] = v138 or false;

    return v138;
end;

local function RefreshCategoryFilterRows(p139: table) -- Line: 897
    -- upvalues: u37 (copy), u39 (ref), u36 (copy)
    for i, v in u37 do
        local v140 = p139[i] or 0;
        v.Count.Text = tostring(v140);
        v.Label.TextTransparency = v140 > 0 and 0 or 0.65;
        v.Count.TextTransparency = v140 > 0 and 0.4 or 0.65;
    end;

    if u39 then
        u39.Visible = next(u36) ~= nil;
    end;
end;

local function ApplyFilterToSortedData(p141: table) -- Line: 911
    -- upvalues: DataController (copy), LocalPlayer (copy), u37 (copy), u36 (copy), MatchesSearchQuery (copy), GetItemCategoryOption (copy), RefreshCategoryFilterRows (copy)
    local v142 = {};
    local v143 = DataController.Get(LocalPlayer, "Inventory");

    if v143 then
        for _, v in ipairs(v143) do
            if v.Charm then
                local v144 = type(v.Charm) == "table" and v.Charm._id;

                if not v144 then
                    if type(v.Charm) == "string" then
                        v144 = v.Charm;
                    else
                        v144 = false;
                    end;
                end;

                if v144 then
                    v142[v144] = true;
                end;
            end;
        end;
    end;

    local v145 = next(u37) ~= nil;
    local v146 = next(u36) ~= nil;
    local v147 = {};
    local v148 = {};

    for _, v in ipairs(p141) do
        if (v.Type ~= "Charm" or not v142[v._id]) and MatchesSearchQuery(v) then
            if v145 then
                local v149 = GetItemCategoryOption(v);

                if v149 then
                    v147[v149] = (v147[v149] or 0) + 1;

                    if not v146 or u36[v149] then
                        table.insert(v148, v);
                    end;
                end;
            else
                table.insert(v148, v);
            end;
        end;
    end;

    RefreshCategoryFilterRows(v147);

    return v148;
end;

local function CreateMissingItemTemplates(p150: userdata, p151: number, p152: number) -- Line: 962
    -- upvalues: u2 (ref), u1 (copy)
    for i = p151, p152 do
        local v153 = u2[i];
        local v154;

        if v153 and not p150:FindFirstChild(v153._id) then
            u1.CreateItemTemplate(v153);
            v154 = i;
        else
            v154 = i;
        end;
    end;
end;

local function ApplySortedLayoutOrder(p155: userdata) -- Line: 971
    -- upvalues: u2 (ref)
    for _, child in ipairs(p155:GetChildren()) do
        if child:IsA("Frame") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
            local v156 = child;

            for i, v in ipairs(u2) do
                if v._id == v156.Name then
                    v156.LayoutOrder = i;
                    break;
                end;
            end;
        end;
    end;
end;

local function RenderInventoryTemplates() -- Line: 989
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

local function OnScrollPositionChanged() -- Line: 1002
    -- upvalues: u20 (ref), u15 (ref), u2 (ref), Profiler (copy), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy)
    if u20 and u20.Visible then
        local v157 = u20.Frame.Right.Container.AbsoluteCanvasSize.Y - u20.Frame.Right.Container.AbsoluteSize.Y;

        if v157 > 0 and (u15 < #u2 and v157 - u20.Frame.Right.Container.CanvasPosition.Y < 200) then
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

local function CalculateInitialRenderCount() -- Line: 1021
    -- upvalues: u20 (ref), CalculateGridRenderCount (copy)
    return not (u20 and u20.Visible) and 50 or CalculateGridRenderCount(u20.Frame.Right.Container);
end;

local function RenderInitialTemplates() -- Line: 1030
    -- upvalues: Profiler (copy), u20 (ref), u15 (ref), CalculateGridRenderCount (copy), u2 (ref), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy)
    Profiler.mark("UI.Inventory.RenderInitialTemplates");

    if not (u20 and u20.Visible) then
        return;
    end;

    local Container = u20.Frame.Right.Container;
    u15 = 0;
    local v158 = not (u20 and u20.Visible) and 50 or CalculateGridRenderCount(u20.Frame.Right.Container);
    local math_max_ret = math.max(v158, 50);
    local math_min_ret = math.min(math_max_ret, #u2);
    CreateMissingItemTemplates(Container, 1, math_min_ret);
    ApplySortedLayoutOrder(Container);
    u15 = math_min_ret;
end;

local function IsItemTemplate(p159: userdata) -- Line: 1050
    local v160 = p159:IsA("ImageButton");

    if v160 then
        if p159.Name == "UIGridLayout" or (p159.Name == "UIListLayout" or (p159.Name == "UIPadding" or p159.Name == "Title")) then
            v160 = false;
        else
            v160 = p159.Name ~= "Label";
        end;
    end;

    return v160;
end;

local function UpdateInventoryTemplates() -- Line: 1061
    -- upvalues: Profiler (copy), u20 (ref), u15 (ref), RenderInitialTemplates (copy)
    Profiler.mark("UI.Inventory.UpdateInventoryTemplates");

    if not u20 then
        return;
    end;

    for _, child in ipairs(u20.Frame.Right.Container:GetChildren()) do
        local v161 = child:IsA("ImageButton");

        if v161 then
            if child.Name == "UIGridLayout" or (child.Name == "UIListLayout" or (child.Name == "UIPadding" or child.Name == "Title")) then
                v161 = false;
            else
                v161 = child.Name ~= "Label";
            end;
        end;

        if v161 then
            child:Destroy();
        end;
    end;

    u15 = 0;

    if u20.Visible then
        RenderInitialTemplates();
    end;
end;

local function ApplyCurrentSort() -- Line: 1084
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

local function RegisterCategoryFilterRow(p162) -- Line: 1103
    -- upvalues: Buttons (copy), u37 (copy), u36 (copy), Profiler (copy), u20 (ref), u2 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy), ActivateButton (copy), Router (copy)
    local string_gsub_ret = string.gsub(p162.Name, " ", "");
    local u163 = nil;
    local v164 = {};

    for _, v in Buttons do
        if type(v) == "table" then
            for i, v2 in v do
                if string.gsub(i, " ", "") == string_gsub_ret then
                    v164 = v2.Search;
                    u163 = i;
                end;
            end;
        end;
    end;

    if not u163 then
        warn((`[Inventory] Category filter row "{p162.Name}" has no matching option`));

        return;
    end;

    local Info = p162.Info;
    local Button = p162.Button;
    local ImageLabel = Button.ImageLabel;
    ImageLabel.Visible = false;
    local v165 = Info:Clone();
    v165.Name = "Count";
    v165.AnchorPoint = Vector2.new(1, 0.5);
    v165.Position = UDim2.fromScale(Button.Position.X.Scale - Button.Size.X.Scale, Info.Position.Y.Scale);
    v165.Size = UDim2.fromScale(0.22, Info.Size.Y.Scale);
    v165.TextXAlignment = Enum.TextXAlignment.Right;
    v165.Text = "";
    v165.Parent = p162;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "RowButton";
    TextButton.Text = "";
    TextButton.BackgroundTransparency = 1;
    TextButton.Size = UDim2.fromScale(1, 1);
    TextButton.ZIndex = Button.ZIndex - 1;
    TextButton.Selectable = false;
    TextButton.Parent = p162;
    u37[u163] = {
        Check = ImageLabel,
        Label = Info,
        Count = v165,
        Search = v164
    };

    local function toggle() -- Line: 1151
        -- upvalues: u36 (ref), u163 (copy), ImageLabel (copy), Profiler (ref), u20 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref)
        local v166 = not u36[u163];
        u36[u163] = v166 and true or nil;
        ImageLabel.Visible = v166;
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

    ActivateButton(Button);
    Button.Activated:Connect(toggle);
    TextButton.Activated:Connect(function() -- Line: 1159
        -- upvalues: Router (ref), u36 (ref), u163 (copy), ImageLabel (copy), Profiler (ref), u20 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local v167 = not u36[u163];
        u36[u163] = v167 and true or nil;
        ImageLabel.Visible = v167;
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

local function ConnectButtonActivation(p168: userdata, u169: function) -- Line: 1168
    p168.MouseButton1Click:Connect(u169);
    p168.Activated:Connect(function(p170) -- Line: 1170
        -- upvalues: u169 (copy)
        if p170 and p170.UserInputType == Enum.UserInputType.Gamepad1 then
            u169();
        end;
    end);
end;

local function AnimateSortButton(u171: userdata, u172: any, u173: string, u174: userdata, u175: function) -- Line: 1179
    -- upvalues: Router (copy), u18 (ref), u11 (ref), Profiler (copy), u20 (ref), u2 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy)
    u172.Selectable = true;

    local function handleSortOptionClick() -- Line: 1188
        -- upvalues: Router (ref), u18 (ref), u11 (ref), u173 (copy), Profiler (ref), u20 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), u174 (copy), u171 (copy), u172 (copy), u175 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if u18 then
            u18.Visible = false;
        end;

        u11 = u173;
        Profiler.mark("UI.Inventory.ApplyCurrentSort");

        if u20 and u20.Visible then
            u2 = GetSortedInventoryData();
            u2 = ApplyFilterToSortedData(u2);
            UpdateInventoryTemplates();
        end;

        u174.Text = u173;

        for _, child in ipairs(u171:GetChildren()) do
            if child:IsA("TextButton") then
                child.Frame.BackgroundTransparency = child == u172 and 0 or 1;
            end;
        end;

        u175();
    end;

    u172.MouseButton1Click:Connect(handleSortOptionClick);
    u172.Activated:Connect(function(p176) -- Line: 1170
        -- upvalues: handleSortOptionClick (copy)
        if p176 and p176.UserInputType == Enum.UserInputType.Gamepad1 then
            handleSortOptionClick();
        end;
    end);
end;

function u1.CreateItemTemplate(u177) -- Line: 1209
    -- upvalues: Profiler (copy), Cases (copy), GetResolvedSkinInformation (copy), ReplicatedStorage (copy), u20 (ref), ItemCard (copy), Mouse (copy), u19 (ref), u18 (ref), DataController (copy), LocalPlayer (copy), Router (copy), u7 (ref), u4 (ref), u1 (copy), GetVisibleInformationFrameButtons (copy), UserInputService (copy), u86 (copy), u6 (ref), u14 (ref), u3 (copy), u5 (ref)
    Profiler.mark("UI.Inventory.CreateItemTemplate");

    if not (u177 and u177._id) then
        return;
    end;

    local v178 = u177.Type == "Case" and true or u177.Type == "Package";
    local v179 = v178 and Cases.GetCaseByName(u177.Skin) or GetResolvedSkinInformation(u177.Name, u177.Skin);

    if not v179 then
        print((`[Inventory] Skipping template creation for item: {u177.Name} | {u177.Skin} (Type: {u177.Type}) - No item information found`));

        return;
    end;

    local u180 = ReplicatedStorage.Assets.UI.Inventory.ItemTemplate:Clone();
    u180.Parent = u20.Frame.Right.Container;
    u180.Name = u177._id;
    ItemCard.Fill(u180, u177, v179, v178);
    u180.Selectable = true;

    local function handleItemSelection(u181: boolean?) -- Line: 1236
        -- upvalues: u20 (ref), Mouse (ref), u19 (ref), u18 (ref), DataController (ref), LocalPlayer (ref), u177 (ref), Router (ref), u7 (ref), u180 (copy), u4 (ref), u1 (ref), GetVisibleInformationFrameButtons (ref), UserInputService (ref), u86 (ref), Profiler (ref), u6 (ref), u14 (ref)
        if not u20.Ignore.ItemNotification.Visible then
            local Vector2_new_ret = Vector2.new(Mouse.X, Mouse.Y);
            local v182;

            if u20.Ignore.ItemNotification.Visible then
                v182 = true;
            else
                local v183 = u19;

                if v183 and v183.Visible then
                    local AbsolutePosition = v183.AbsolutePosition;
                    local AbsoluteSize = v183.AbsoluteSize;

                    if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
                        v182 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                    else
                        v182 = false;
                    end;
                else
                    v182 = false;
                end;

                if not v182 then
                    local v184 = u18;

                    if v184 and v184.Visible then
                        local AbsolutePosition = v184.AbsolutePosition;
                        local AbsoluteSize = v184.AbsoluteSize;

                        if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
                            v182 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                        else
                            v182 = false;
                        end;
                    else
                        v182 = false;
                    end;
                end;
            end;

            if not v182 then
                local v185 = DataController.Get(LocalPlayer, "Inventory");

                if v185 then
                    for _, v in ipairs(v185) do
                        if v._id == u177._id then
                            u177 = v;
                            break;
                        end;
                    end;
                end;

                local v186 = u177.Type == "Case" and true or u177.Type == "Package";
                local v187 = u177.Type == "Charm Capsule" and true or u177.Type == "Sticker Capsule";
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u7 = u180;
                u4 = u177;
                u1.SetupInformationFrame(u177);
                local v188;

                if u18 == nil then
                    v188 = false;
                else
                    v188 = #GetVisibleInformationFrameButtons() > 0;
                end;

                if not v188 then
                    u18.Visible = false;

                    return;
                end;

                local function positionInformationFrame() -- Line: 1266
                    -- upvalues: u18 (ref), UserInputService (ref), u181 (copy), u180 (ref), Mouse (ref)
                    local Parent = u18.Parent.Parent;
                    local AbsolutePosition = Parent.AbsolutePosition;
                    local AbsoluteSize = Parent.AbsoluteSize;
                    local v189 = nil;
                    local v190 = nil;

                    if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 or u181 then
                        if u180 and u180:IsA("GuiObject") then
                            local AbsolutePosition2 = u180.AbsolutePosition;
                            local AbsoluteSize2 = u180.AbsoluteSize;
                            v189 = AbsolutePosition2.X + AbsoluteSize2.X / 2;
                            v190 = AbsolutePosition2.Y + AbsoluteSize2.Y / 2;
                        end;
                    else
                        v189 = Mouse.X;
                        v190 = Mouse.Y;
                    end;

                    local v191, v192;

                    if v189 then
                        local v193 = (v189 - AbsolutePosition.X) / AbsoluteSize.X;
                        v191 = (v190 - AbsolutePosition.Y) / AbsoluteSize.Y + u18.Size.Y.Scale / 2;

                        if 1 - v193 >= u18.Size.X.Scale + 0.01 then
                            v192 = v193 + u18.Size.X.Scale / 2 + 0.01;
                        else
                            v192 = v193 - u18.Size.X.Scale / 2 - 0.01;
                        end;
                    else
                        v192 = 0.5;
                        v191 = 0.5;
                    end;

                    u18.Position = UDim2.fromScale(v192, v191);
                end;

                if v186 or v187 then
                    u18.Visible = true;
                    positionInformationFrame();

                    for _, v in u86 do
                        local v194 = u20.Ignore[v];

                        if v194 ~= nil then
                            v194.Visible = false;
                        end;
                    end;

                    if u181 then
                        Profiler.defer("UI.Inventory.InformationNavigationDeferred", function() -- Line: 1308
                            -- upvalues: u1 (ref)
                            u1.SetupInformationFrameNavigation();
                            u1.SelectFirstInformationFrameButton();
                        end);
                    end;

                    return;
                end;

                if u181 then
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

                for _, v in u86 do
                    local v195 = u20.Ignore[v];

                    if v195 ~= nil then
                        v195.Visible = false;
                    end;
                end;

                Profiler.defer("UI.Inventory.InformationNavigationDeferred", function() -- Line: 1326
                    -- upvalues: u1 (ref), u181 (copy)
                    u1.SetupInformationFrameNavigation();

                    if u181 then
                        u1.SelectFirstInformationFrameButton();
                    end;
                end);
            end;
        end;
    end;

    u180.MouseButton1Click:Connect(function() -- Line: 1337
        -- upvalues: handleItemSelection (copy)
        handleItemSelection(false);
    end);
    u180.Activated:Connect(function(p196) -- Line: 1340
        -- upvalues: handleItemSelection (copy)
        if p196 and p196.UserInputType == Enum.UserInputType.Gamepad1 then
            handleItemSelection(true);
        end;
    end);

    if u3 then
        u180.MouseEnter:Connect(function() -- Line: 1348
            -- upvalues: u5 (ref), u177 (ref), u6 (ref), u180 (copy), u14 (ref)
            u5 = u177;
            u6 = u180;
            u14 = tick();
        end);
        u180.MouseLeave:Connect(function() -- Line: 1354
            -- upvalues: u6 (ref), u5 (ref), u14 (ref)
            u6 = nil;
            u5 = nil;
            u14 = nil;
        end);
    end;
end;

function u1.UpdateInventory(p197) -- Line: 1364
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

function u1.UpdateTemplates(p200) -- Line: 1411
    -- upvalues: Profiler (copy), u20 (ref), Cases (copy), GetResolvedSkinInformation (copy), ItemCard (copy)
    Profiler.mark("UI.Inventory.UpdateTemplates");

    if not (u20 and u20.Visible) then
        return;
    end;

    local Container = u20.Frame.Right.Container;

    if p200 then
        for _, v in ipairs(p200) do
            local v201 = Container:FindFirstChild(v._id);

            if v201 then
                local v202 = v.Type == "Case" and true or v.Type == "Package";
                local v203 = v202 and Cases.GetCaseByName(v.Skin) or GetResolvedSkinInformation(v.Name, v.Skin);

                if v203 then
                    ItemCard.Fill(v201, v, v203, v202);
                end;
            end;
        end;
    end;
end;

function u1.SetupInformationFrameNavigation() -- Line: 1438
    -- upvalues: u18 (ref), GetVisibleInformationFrameButtons (copy)
    if not u18 then
        return;
    end;

    local v204 = GetVisibleInformationFrameButtons();
    table.sort(v204, function(p205, p206) -- Line: 1444
        return p205.LayoutOrder < p206.LayoutOrder;
    end);

    for i, v in ipairs(v204) do
        v.NextSelectionUp = v204[i > 1 and i - 1 or #v204];
        v.NextSelectionDown = v204[i < #v204 and i + 1 or 1];
        v.NextSelectionLeft = nil;
        v.NextSelectionRight = nil;
    end;
end;

function u1.SetupItemNotificationNavigation() -- Line: 1461
    -- upvalues: u20 (ref)
    if not (u20 and u20.Ignore.ItemNotification) then
        return;
    end;

    local Holder = u20.Ignore.ItemNotification.Holder;
    local v207;

    if Holder.Left.Visible then
        v207 = Holder.Left;
    else
        v207 = nil;
    end;

    local v208;

    if Holder.Right.Visible then
        v208 = Holder.Right;
    else
        v208 = nil;
    end;

    local v209 = {};

    for _, v in { Holder.ViewLoadout, Holder.Continue } do
        if v and v.Visible then
            table.insert(v209, v);
        end;
    end;

    table.sort(v209, function(p210, p211) -- Line: 1476
        return p210.AbsolutePosition.X < p211.AbsolutePosition.X;
    end);
    local v212 = v209[1];
    local v213 = v209[#v209];

    for i, v in ipairs(v209) do
        v.NextSelectionLeft = v209[i - 1] or v207;
        v.NextSelectionRight = v209[i + 1] or v208;
        v.NextSelectionUp = v208 or v207;
        v.NextSelectionDown = nil;
    end;

    if v207 then
        v207.NextSelectionLeft = nil;
        v207.NextSelectionRight = v208 or v212;
        v207.NextSelectionUp = nil;
        v207.NextSelectionDown = v212;
    end;

    if v208 then
        v208.NextSelectionLeft = v207 or v213;
        v208.NextSelectionRight = nil;
        v208.NextSelectionUp = nil;
        v208.NextSelectionDown = v213;
    end;
end;

function u1.EnsureItemNotificationSelection() -- Line: 1505
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

function u1.SelectFirstItemNotificationButton() -- Line: 1526
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

function u1.SelectFirstInformationFrameButton() -- Line: 1550
    -- upvalues: u18 (ref), u1 (copy), GetVisibleInformationFrameButtons (copy), GuiService (copy)
    if not (u18 and u18.Visible) then
        return;
    end;

    u1.SetupInformationFrameNavigation();
    local v214 = GetVisibleInformationFrameButtons()[1];

    if v214 then
        GuiService.SelectedObject = v214;
    end;
end;

function u1.SetupInformationFrame(p215) -- Line: 1565
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), u18 (ref), Cases (copy), GetWeaponProperties (copy), IsEquippedOnTeam (copy)
    Profiler.mark("UI.Inventory.SetupInformationFrame");
    local v216 = DataController.Get(LocalPlayer, "Inventory");

    if v216 then
        local _id = p215._id;
        local v217 = nil;

        for _, v in ipairs(v216) do
            if v._id == _id then
                v217 = v;
                break;
            end;
        end;

        p215 = v217 or p215;
    end;

    local v218 = p215.Type == "Weapon";
    local v219 = p215.Type == "Melee";
    local v220 = p215.Type == "Glove";
    local v221 = p215.Type == "Badge";
    local v222 = p215.Type == "Zeus x27";
    u18.Inspect.Visible = v218 or (v220 or v219 or (v222 or (p215.Type == "Charm" and true or v221)));
    local v223;

    if p215.Type == "Case" then
        v223 = Cases.GetCaseByName(p215.Skin);
    else
        v223 = nil;
    end;

    local Unlock = u18.Unlock;
    local v224;

    if p215.Type == "Package" then
        v224 = true;
    elseif v223 == nil then
        v224 = false;
    else
        v224 = Cases.HasCaseModel(v223.caseId);
    end;

    Unlock.Visible = v224;
    u18.Loadout.Visible = false;
    local QuickUnlock = u18:FindFirstChild("QuickUnlock");

    if QuickUnlock then
        QuickUnlock.Visible = false;
    end;

    local UnlockDivider = u18:FindFirstChild("UnlockDivider");

    if UnlockDivider then
        UnlockDivider.Visible = false;
    end;

    local v225 = v218 or (v222 or p215.Type == "Charm");

    if not u18.Charm then
        warn("[Inventory] InformationFrame.Charm element not found - item type:", p215.Type);
    end;

    if u18.Charm then
        u18.Charm.Visible = v225;
        local v226 = v225 and u18.Charm:FindFirstChildWhichIsA("TextLabel", true);

        if v226 then
            if p215.Type == "Charm" then
                v226.Text = "Attach to Weapon";
            else
                local Charm = p215.Charm;
                local v227;

                if Charm == nil or Charm == false then
                    v227 = false;
                else
                    v227 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
                end;

                v226.Text = v227 and "Detach Charm" or "Attach Charm";
            end;
        end;
    end;

    local u228 = false;
    local u229 = false;

    local function applyTeamRestriction(p230: string?) -- Line: 1620
        -- upvalues: u228 (ref), u229 (ref)
        u228 = p230 == "Both" and true or p230 == "Counter-Terrorists";
        u229 = p230 == "Both" and true or p230 == "Terrorists";
    end;

    if v218 then
        local success, result = pcall(GetWeaponProperties, p215.Name);

        if success and result then
            local Team = result.Team;
            u228 = Team == "Both" and true or Team == "Counter-Terrorists";
            u229 = Team == "Both" and true or Team == "Terrorists";
        end;
    elseif v219 then
        if p215.Name == "T Knife" then
            u228 = false;
        else
            u228 = true;
        end;

        if p215.Name == "CT Knife" then
            u229 = false;
        else
            u229 = true;
        end;
    elseif v220 then
        local v231 = GetWeaponProperties(p215.Name);

        if v231 then
            local Team = v231.Team;
            u228 = Team == "Both" and true or Team == "Counter-Terrorists";
            u229 = Team == "Both" and true or Team == "Terrorists";
        end;
    elseif v221 or v222 then
        u228 = true;
        u229 = true;
    end;

    local v232 = IsEquippedOnTeam(p215._id, "Counter-Terrorists");
    local v233 = IsEquippedOnTeam(p215._id, "Terrorists");
    local v234 = v218 or (v219 or (v220 or (v221 or v222)));

    if u18.ReplaceCT then
        u18.ReplaceCT.Visible = v234 and u228 and not v232;
    end;

    if u18.ReplaceT then
        u18.ReplaceT.Visible = v234 and u229 and not v233;
    end;

    local v235 = {
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
    local v236 = {
        UnlockDivider = true
    };

    for _, v in ipairs(v235) do
        v236[v.dividerName] = true;
    end;

    for _, v in ipairs(v235) do
        local v237 = u18:FindFirstChild(v.dividerName);

        if v237 and v.action then
            local v238 = false;

            if v.action.Visible then
                local v239 = v;

                for _, child in ipairs(u18:GetChildren()) do
                    if not (v236[child.Name] or (child == v237 or (child == v239.action or not (child:IsA("Frame") or child:IsA("TextButton")))) or (child.LayoutOrder >= v237.LayoutOrder or not child.Visible)) then
                        v238 = true;
                        break;
                    end;
                end;
            end;

            v237.Visible = v238;
        end;
    end;
end;

function u1.ShowNewItemNotification(p240) -- Line: 1699
    -- upvalues: Profiler (copy), u24 (copy), u29 (ref), u20 (ref), u30 (ref), u1 (copy), u8 (ref), syncInventoryUpdate (copy)
    Profiler.mark("UI.Inventory.ShowNewItemNotification");
    local _id = p240._id;
    local v241 = nil;

    for i, v in ipairs(u24) do
        if v._id == _id then
            v241 = i;
            break;
        end;
    end;

    if v241 then
        u29 = nil;

        if u20.Visible then
            u30 = p240._id;
            u1.NextInventoryItem(v241);
        else
            u8 = v241 - 1;
        end;
    else
        u29 = p240._id;
    end;

    u20.Visible = true;
    syncInventoryUpdate();
end;

function u1.NextInventoryItem(p242: number) -- Line: 1725
    -- upvalues: Profiler (copy), u24 (copy), u8 (ref), u25 (copy), u26 (copy), u28 (ref), ReportViewedItems (copy), Cases (copy), GetResolvedSkinInformation (copy), Rarities (copy), GetSkinDisplayName (copy), GetIconImage (copy), u20 (ref), u32 (ref), Router (copy), u1 (copy), syncInventoryUpdate (copy)
    Profiler.mark("UI.Inventory.NextInventoryItem");
    local v243 = u24[p242];
    u8 = p242;

    if v243 then
        local _id = v243._id;

        if not u25[_id] then
            u25[_id] = true;
            u26[_id] = true;

            if not u28 then
                u28 = true;
                task.delay(2, function() -- Line: 581
                    -- upvalues: u28 (ref), ReportViewedItems (ref)
                    u28 = false;
                    ReportViewedItems();
                end);
            end;
        end;

        local v244 = v243.Type == "Case" and true or v243.Type == "Package";
        local v245 = v244 and Cases.GetCaseByName(v243.Skin) or GetResolvedSkinInformation(v243.Name, v243.Skin);
        local v246 = Rarities[v245 and (v244 and v245.caseRarity or v245.rarity) or (v243.Rarity or "Blue")] or Rarities.Blue;
        local v247;

        if v244 and (v245 and v245.Skin) then
            v247 = v245.Skin;
        else
            local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(v243.Name, v243.NameTag);

            if v243.StatTrack then
                WeaponDisplayName = "KillTrak™ " .. WeaponDisplayName or WeaponDisplayName;
            end;

            v247 = `{WeaponDisplayName} | {GetSkinDisplayName(v243.Skin, true)}`;
        end;

        local v248 = GetIconImage(v243, v245, v244);
        local v249;

        if v243.Type == "Case" then
            v249 = false;
        else
            v249 = v243.Type ~= "Package";
        end;

        u20.Ignore.ItemNotification.Holder.ViewLoadout.Visible = v249;
        u20.Ignore.ItemNotification.Holder.RarityFrame.UIGradient.Color = v246.ColorSequence;
        u20.Ignore.ItemNotification.Holder.Background.ImageColor3 = v246.Color;
        u20.Ignore.ItemNotification.Holder.IconShadow.Image = v248;
        u20.Ignore.ItemNotification.Holder.Light.ImageColor3 = v246.Color;
        GetSkinDisplayName.ApplyNameLabel(u20.Ignore.ItemNotification.Holder.WeaponName, v247, v243.NameTag);
        u20.Ignore.ItemNotification.Holder.Icon.Image = v248;
        u20.Ignore.ItemNotification.Visible = true;

        if not u32 then
            u32 = true;
            Router.broadcastRouter("RunInterfaceSound", "New Item Reveal");
        end;

        u20.Ignore.ItemNotification.Holder.Title.TextColor3 = Color3.new(v246.Color.R * 0.56, v246.Color.G * 0.56, v246.Color.B * 0.56);
        Profiler.defer("UI.Inventory.ItemNotificationDeferred", function() -- Line: 1774
            -- upvalues: u1 (ref)
            u1.SetupItemNotificationNavigation();
            u1.EnsureItemNotificationSelection();
        end);
        syncInventoryUpdate();
    end;
end;

local u250 = {
    Blue = 1,
    Purple = 2,
    Pink = 3,
    Red = 4,
    Special = 5,
    Forbidden = 6,
    Stock = 7
};
local u251 = {
    Blue = "Blue",
    Purple = "Purple",
    Pink = "Pink",
    Red = "Red",
    Special = "★ Special",
    Forbidden = "★ Special"
};
local u252 = nil;

local function GetCollectionRowPrototype(p253: userdata) -- Line: 1811
    -- upvalues: u252 (ref), ReplicatedStorage (copy)
    if not u252 then
        local CollectionNameTemplate = p253:FindFirstChild("CollectionNameTemplate");

        if CollectionNameTemplate then
            CollectionNameTemplate.Parent = nil;
            u252 = CollectionNameTemplate;
        else
            u252 = ReplicatedStorage.Assets.UI.Inventory:FindFirstChild("CollectionNameTemplate");
        end;
    end;

    return u252;
end;

local function ClearHoverCollectionFrames(p254: userdata) -- Line: 1824
    for _, child in ipairs(p254:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "UIListLayout" then
            child:Destroy();
        end;
    end;
end;

local function ShowHoverCollection(p255) -- Line: 1833
    -- upvalues: u20 (ref), DataController (copy), LocalPlayer (copy), u252 (ref), ReplicatedStorage (copy), ClearHoverCollectionFrames (copy), GetResolvedSkinInformation (copy), u250 (copy), Rarities (copy)
    local Collection = u20.Ignore.Hover.Collection;
    local v256 = DataController.Get(LocalPlayer, "Inventory");

    if not u252 then
        local CollectionNameTemplate = Collection:FindFirstChild("CollectionNameTemplate");

        if CollectionNameTemplate then
            CollectionNameTemplate.Parent = nil;
            u252 = CollectionNameTemplate;
        else
            u252 = ReplicatedStorage.Assets.UI.Inventory:FindFirstChild("CollectionNameTemplate");
        end;
    end;

    local v257 = u252;
    ClearHoverCollectionFrames(Collection);
    local v258 = {};

    if v256 then
        for _, v in ipairs(v256) do
            if v.Name and v.Skin then
                v258[v.Name .. "|" .. v.Skin] = true;
            end;
        end;
    end;

    local v259 = {};

    for _, v in ipairs(p255.items) do
        if v.itemName and v.skinName then
            local v260 = GetResolvedSkinInformation(v.itemName, v.skinName);

            if v260 then
                table.insert(v259, {
                    item = v,
                    rarity = v260.rarity,
                    rarityOrder = u250[v260.rarity] or 99
                });
            end;
        end;
    end;

    table.sort(v259, function(p261, p262) -- Line: 1864
        if p261.rarityOrder == p262.rarityOrder then
            return p261.item.itemName < p262.item.itemName;
        end;

        return p261.rarityOrder < p262.rarityOrder;
    end);

    for i, v in ipairs(v259) do
        local item = v.item;
        local v263 = GetResolvedSkinInformation(item.itemName, item.skinName);

        if v263 and v257 then
            local v264 = v257:Clone();
            v264.Parent = Collection;
            v264.LayoutOrder = i;
            v264.Visible = true;
            local gun = v264.gun;
            gun.Text = "[" .. item.itemName .. "] | " .. item.skinName;
            local v265 = v263.rarity and Rarities[v263.rarity];

            if v265 then
                gun.TextColor3 = v265.Color;
            end;

            gun.Visible = true;
            v264.ImageLabel.Visible = v258[item.itemName .. "|" .. item.skinName] == true;
        end;
    end;
end;

local function GetItemTeamLabel(p266) -- Line: 1897
    -- upvalues: GetWeaponProperties (copy)
    if p266.Type == "Melee" or (p266.Type == "Glove" or (p266.Type == "Badge" or (p266.Type == "Charm" or p266.Type == "Zeus x27"))) then
        return "Both";
    end;

    if p266.Type == "Weapon" then
        local v267 = GetWeaponProperties(p266.Name);

        if v267 then
            v267 = v267.Team;
        end;

        if v267 then
            return v267 ~= "Counter-Terrorists" and v267 ~= "Terrorists" and "Both" or v267;
        end;
    end;

    return nil;
end;

local function GetHoverFrame(p268: boolean, p269: string?) -- Line: 1923
    -- upvalues: u20 (ref)
    if p268 then
        return u20.Ignore.Hover;
    end;

    if p269 then
        return u20.Ignore.HoverNoCollection;
    end;

    return u20.Ignore.HoverDefault;
end;

function u1.UpdateHoverFrame(p270: number) -- Line: 1932
    -- upvalues: u14 (ref), Mouse (copy), u20 (ref), u19 (ref), u18 (ref), u6 (ref), u5 (ref), u86 (copy), Cases (copy), GetResolvedSkinInformation (copy), GetCollectionNameForItem (copy), Collections (copy), GetItemTeamLabel (copy), GetDisplayName (copy), GetSkinDisplayName (copy), ShowHoverCollection (copy), Rarities (copy), u251 (copy), Skins (copy), CalculateHoverPosition (copy)
    local v271 = tick() - (u14 or 0);
    local Vector2_new_ret = Vector2.new(Mouse.X, Mouse.Y);
    local v272;

    if u20.Ignore.ItemNotification.Visible then
        v272 = true;
    else
        local v273 = u19;

        if v273 and v273.Visible then
            local AbsolutePosition = v273.AbsolutePosition;
            local AbsoluteSize = v273.AbsoluteSize;

            if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
                v272 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
            else
                v272 = false;
            end;
        else
            v272 = false;
        end;

        if not v272 then
            local v274 = u18;

            if v274 and v274.Visible then
                local AbsolutePosition = v274.AbsolutePosition;
                local AbsoluteSize = v274.AbsoluteSize;

                if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
                    v272 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                else
                    v272 = false;
                end;
            else
                v272 = false;
            end;
        end;
    end;

    if not u20.Visible or (v272 or (u18.Visible or not (u6 and (u5 and v271 > 0.75)))) then
        for _, v in u86 do
            local v275 = u20.Ignore[v];

            if v275 ~= nil then
                v275.Visible = false;
            end;
        end;

        return;
    end;

    local v276 = u5;
    local v277 = v276.Type == "Case" and true or v276.Type == "Package";
    local v278 = v277 and Cases.GetCaseByName(v276.Skin) or GetResolvedSkinInformation(v276.Name, v276.Skin);

    if not v278 then
        for _, v in u86 do
            local v279 = u20.Ignore[v];

            if v279 ~= nil then
                v279.Visible = false;
            end;
        end;

        return;
    end;

    local v280 = GetCollectionNameForItem(v276);
    local v281;

    if v280 and not v277 then
        v281 = Collections.GetCollectionByName(v280);
    else
        v281 = nil;
    end;

    local v282;

    if v281 == nil then
        v282 = false;
    else
        v282 = v281.items ~= nil;
    end;

    local v283 = GetItemTeamLabel(v276);
    local v284;

    if v282 then
        v284 = u20.Ignore.Hover;
    elseif v283 then
        v284 = u20.Ignore.HoverNoCollection;
    else
        v284 = u20.Ignore.HoverDefault;
    end;

    for _, v in u86 do
        local v285 = u20.Ignore[v];

        if v285 ~= v284 then
            v285.Visible = false;
        end;
    end;

    local v286 = GetDisplayName(v276, v278, v277);
    local v287 = GetSkinDisplayName(v277 and v278.skin or v276.Skin);
    GetSkinDisplayName.ApplyNameLabel(v284.ItemName.Frame.ItemName, v286 .. (v287 == "Vanilla" and "" or " | " .. v287), v276.NameTag);
    local CollectionIcon = v284.ItemName.CollectionIcon;
    local v288;

    if v280 then
        v288 = Collections.GetCollectionByName(v280);
    else
        v288 = v280;
    end;

    if v288 then
        v288 = v288.imageAssetId;
    end;

    local v289 = v288 ~= nil;

    if v288 then
        CollectionIcon.Image = v288;
    end;

    CollectionIcon.Visible = v289;
    local UnknownIcon = v284.ItemName:FindFirstChild("UnknownIcon");

    if UnknownIcon then
        UnknownIcon.Visible = not v289;
    end;

    if v282 then
        v284.ItemName.Frame.Collection.Text = v280;
        v284.CollectionName.Text = v280 .. ":";
        ShowHoverCollection(v281);
    end;

    local v290;

    if v277 or v276.Type ~= "Weapon" and (v276.Type ~= "Melee" and (v276.Type ~= "Glove" and v276.Type ~= "Zeus x27")) then
        v290 = v278.description;
    else
        v290 = GetResolvedSkinInformation(v276.Type == "Melee" and "T Knife" or (v276.Type == "Glove" and "T Glove" or v276.Name), "Stock");

        if v290 then
            v290 = v290.description;
        end;
    end;

    v284.Description.Text = v290 or "";
    local Information = v284.Information;
    Information.Visible = not (v277 or (v276.Type == "Charm Capsule" and true or v276.Type == "Sticker Capsule"));
    local v291 = v277 and v278.caseRarity or v278.rarity;
    local v292;

    if v291 then
        v292 = Rarities[v291];
    else
        v292 = v291;
    end;

    if v292 then
        Information.Rarity.Label.Text = u251[v291] or v291;
        Information.Rarity.Label.TextColor3 = v292.Color;
    else
        Information.Rarity.Label.Text = "";
    end;

    local v293, v294;

    if v277 then
        v293 = nil;
        v294 = nil;
    else
        v293, v294 = Skins.GetWearNameForFloat(v278, v276.Float or v278.floatRange.max);
    end;

    local v295;

    if v293 == nil then
        v295 = false;
    else
        v295 = v294 ~= nil;
    end;

    Information.Exterior.Visible = v295;

    if v294 then
        Information.Exterior.Label.Text = v294;
    end;

    local Team = Information:FindFirstChild("Team");

    if Team then
        Team.Visible = v283 ~= nil;

        if v283 then
            local Team2 = Team.Team;
            Team2.CT.Visible = v283 ~= "Terrorists";
            Team2.T.Visible = v283 ~= "Counter-Terrorists";
            Team2.Label.Text = v283;
        end;
    end;

    v284.Position = CalculateHoverPosition(u6, v284);
    v284.Visible = true;
end;

function u1.Initialize(p296, p297) -- Line: 2059
    -- upvalues: Profiler (copy), u21 (ref), u20 (ref), u18 (ref), CloseButtonRegistry (copy), Router (copy), u7 (ref), GuiService (copy), Collections (copy), u10 (ref), u4 (ref), ActivateButton (copy), Remotes (copy), UseItemFrame (copy), MenuState (copy), u13 (ref), Cases (copy), Store (copy), ReplaceItemOnTeam (copy), u8 (ref), u24 (copy), u1 (copy), UserInputService (copy), LocalPlayer (copy), DismissItemNotifications (copy), Loadout (copy), u19 (ref), BindSortDropdownFocus (copy), u11 (ref), u12 (ref), u2 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy), BindSearchTap (copy), Constants (copy), ReplicatedStorage (copy), DataController (copy), GetResolvedSkinInformation (copy), ItemCard (copy), TweenService (copy), u3 (copy), u5 (ref), u6 (ref), u14 (ref), Sort (copy), GetSkinDisplayName (copy), u33 (copy), u32 (ref), u86 (copy), SetSearchTokens (copy), u22 (ref), ContentProvider (copy), u17 (copy), syncInventoryUpdate (copy), u30 (ref), ReportViewedItems (copy), OnScrollPositionChanged (copy)
    Profiler.mark("UI.Inventory.Initialize");
    u21 = p296;
    u20 = p297;
    u18 = p297.Ignore.Information;
    CloseButtonRegistry.Add(u18, nil, function() -- Line: 2065
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
    Collections.ObserveAvailableCollections(function(p298) -- Line: 2078
        -- upvalues: u10 (ref)
        u10 = p298;
    end);
    u18.Inspect.Selectable = true;

    local function handleInspectClick() -- Line: 2084
        -- upvalues: Router (ref), u4 (ref), u18 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if u4 then
            u18.Visible = false;
            local v299 = u4;
            Router.broadcastRouter("WeaponInspect", v299.Name, v299.Skin, v299.Float, v299.StatTrack, v299.NameTag, v299.Charm, v299.Stickers, v299.Type, v299.Pattern, v299._id, v299.Serial, v299.IsTradeable);
        end;
    end;

    ActivateButton(u18.Inspect);
    local Inspect = u18.Inspect;
    Inspect.MouseButton1Click:Connect(handleInspectClick);
    Inspect.Activated:Connect(function(p300) -- Line: 1170
        -- upvalues: handleInspectClick (copy)
        if p300 and p300.UserInputType == Enum.UserInputType.Gamepad1 then
            handleInspectClick();
        end;
    end);

    if u18.Charm then
        u18.Charm.Selectable = true;

        local function handleCharmClick() -- Line: 2097
            -- upvalues: Router (ref), u4 (ref), u18 (ref), Remotes (ref), u20 (ref), UseItemFrame (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u4 then
                local Charm = u4.Charm;
                local v301;

                if Charm == nil or Charm == false then
                    v301 = false;
                else
                    v301 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
                end;

                u18.Visible = false;

                if v301 then
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
        Charm.Activated:Connect(function(p302) -- Line: 1170
            -- upvalues: handleCharmClick (copy)
            if p302 and p302.UserInputType == Enum.UserInputType.Gamepad1 then
                handleCharmClick();
            end;
        end);
    end;

    UseItemFrame.OnItemSelected:Connect(function(p303, p304) -- Line: 2114
        -- upvalues: UseItemFrame (ref)
        local v305 = UseItemFrame.GetActions().Get(p304.ActionType);

        if v305 then
            v305.OnItemSelected(p303, p304);
        end;
    end);
    UseItemFrame.OnClosed:Connect(function(p306) -- Line: 2123
        -- upvalues: MenuState (ref), u20 (ref)
        if MenuState.GetCurrentScreen() == "Inventory" then
            u20.Visible = true;
        end;
    end);
    u18.Unlock.Selectable = true;

    local function handleUnlockClick() -- Line: 2132
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
    Unlock.Activated:Connect(function(p307) -- Line: 1170
        -- upvalues: handleUnlockClick (copy)
        if p307 and p307.UserInputType == Enum.UserInputType.Gamepad1 then
            handleUnlockClick();
        end;
    end);

    local function setupReplaceButton(p308: userdata?, u309: string) -- Line: 2150
        -- upvalues: Router (ref), u4 (ref), u18 (ref), ReplaceItemOnTeam (ref)
        if not p308 then
            return;
        end;

        p308.Selectable = true;

        local function u310() -- Line: 2156
            -- upvalues: Router (ref), u4 (ref), u18 (ref), ReplaceItemOnTeam (ref), u309 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u4 then
                u18.Visible = false;
                ReplaceItemOnTeam(u4, u309);
            end;
        end;

        p308.MouseButton1Click:Connect(u310);
        p308.Activated:Connect(function(p311) -- Line: 1170
            -- upvalues: u310 (copy)
            if p311 and p311.UserInputType == Enum.UserInputType.Gamepad1 then
                u310();
            end;
        end);
    end;

    local ReplaceT = u18.ReplaceT;

    if ReplaceT then
        ReplaceT.Selectable = true;
        local u312 = "Terrorists";

        local function u313() -- Line: 2156
            -- upvalues: Router (ref), u4 (ref), u18 (ref), ReplaceItemOnTeam (ref), u312 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u4 then
                u18.Visible = false;
                ReplaceItemOnTeam(u4, u312);
            end;
        end;

        ReplaceT.MouseButton1Click:Connect(u313);
        ReplaceT.Activated:Connect(function(p314) -- Line: 1170
            -- upvalues: u313 (copy)
            if p314 and p314.UserInputType == Enum.UserInputType.Gamepad1 then
                u313();
            end;
        end);
    end;

    local ReplaceCT = u18.ReplaceCT;

    if ReplaceCT then
        ReplaceCT.Selectable = true;
        local u315 = "Counter-Terrorists";

        local function u316() -- Line: 2156
            -- upvalues: Router (ref), u4 (ref), u18 (ref), ReplaceItemOnTeam (ref), u315 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u4 then
                u18.Visible = false;
                ReplaceItemOnTeam(u4, u315);
            end;
        end;

        ReplaceCT.MouseButton1Click:Connect(u316);
        ReplaceCT.Activated:Connect(function(p317) -- Line: 1170
            -- upvalues: u316 (copy)
            if p317 and p317.UserInputType == Enum.UserInputType.Gamepad1 then
                u316();
            end;
        end);
    end;

    local ItemNotification = u20.Ignore.ItemNotification;

    local function stepItemNotification(p318: number) -- Line: 2170
        -- upvalues: u8 (ref), u24 (ref), Router (ref), u1 (ref)
        local v319 = u8 + p318;

        if v319 >= 1 and v319 <= #u24 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(v319);
        end;
    end;

    ItemNotification.Holder.Left.Selectable = true;
    ItemNotification.Holder.Right.Selectable = true;
    ItemNotification.Holder.Left.MouseButton1Click:Connect(function() -- Line: 2180
        -- upvalues: u8 (ref), u24 (ref), Router (ref), u1 (ref)
        local v320 = u8 + -1;

        if v320 >= 1 and v320 <= #u24 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(v320);
        end;
    end);
    ItemNotification.Holder.Right.MouseButton1Click:Connect(function() -- Line: 2183
        -- upvalues: u8 (ref), u24 (ref), Router (ref), u1 (ref)
        local v321 = u8 + 1;

        if v321 >= 1 and v321 <= #u24 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(v321);
        end;
    end);
    MenuState.RegisterBumperOverride(ItemNotification, function(p322: boolean) -- Line: 2189
        -- upvalues: u8 (ref), u24 (ref), Router (ref), u1 (ref)
        local v323 = u8 + (p322 and -1 or 1);

        if v323 >= 1 and v323 <= #u24 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(v323);
        end;

        return true;
    end, ItemNotification);
    UserInputService.InputBegan:Connect(function(p324: userdata, p325: boolean) -- Line: 2195
        -- upvalues: LocalPlayer (ref), UserInputService (ref), u20 (ref), u8 (ref), u24 (ref), Router (ref), u1 (ref)
        if p325 or (LocalPlayer:GetAttribute("IsPlayerChatting") or (UserInputService:GetFocusedTextBox() or not (u20 and (u20.Ignore.ItemNotification and u20.Ignore.ItemNotification.Visible)))) then
            return;
        end;

        if p324.KeyCode == Enum.KeyCode.Left then
            local v326 = u8 + -1;

            if v326 >= 1 and v326 <= #u24 then
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u1.NextInventoryItem(v326);
            end;

            return;
        end;

        if p324.KeyCode ~= Enum.KeyCode.Right then
            return;
        end;

        local v327 = u8 + 1;

        if v327 >= 1 and v327 <= #u24 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(v327);
        end;
    end);
    u20.Ignore.ItemNotification.Holder.Continue.Selectable = true;
    u20.Ignore.ItemNotification.Holder.ViewLoadout.Selectable = true;

    local function handleContinueClick() -- Line: 2221
        -- upvalues: Router (ref), DismissItemNotifications (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        DismissItemNotifications();
    end;

    local Continue = u20.Ignore.ItemNotification.Holder.Continue;
    Continue.MouseButton1Click:Connect(handleContinueClick);
    Continue.Activated:Connect(function(p328) -- Line: 1170
        -- upvalues: handleContinueClick (copy)
        if p328 and p328.UserInputType == Enum.UserInputType.Gamepad1 then
            handleContinueClick();
        end;
    end);

    local function handleViewLoadoutClick() -- Line: 2228
        -- upvalues: u24 (ref), u8 (ref), Router (ref), DismissItemNotifications (ref), u20 (ref), Loadout (ref)
        local v329 = u24[u8];
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        DismissItemNotifications();

        if v329 and (v329.Type == "Melee" or (v329.Type == "Glove" or (v329.Type == "Weapon" or v329.Type == "Zeus x27"))) then
            u20.Visible = false;
            Loadout.ViewInLoadout(v329._id);
        end;
    end;

    local ViewLoadout = u20.Ignore.ItemNotification.Holder.ViewLoadout;
    ViewLoadout.MouseButton1Click:Connect(handleViewLoadoutClick);
    ViewLoadout.Activated:Connect(function(p330) -- Line: 1170
        -- upvalues: handleViewLoadoutClick (copy)
        if p330 and p330.UserInputType == Enum.UserInputType.Gamepad1 then
            handleViewLoadoutClick();
        end;
    end);
    local Filter = u20.Frame.Right.Top.Filter;
    local DropdownContent = Filter.DropdownContent;
    u19 = DropdownContent;
    Filter.Active = true;
    Filter.Selectable = true;
    local v331 = u19;

    if v331 then
        v331.Visible = false;
        v331.Active = false;
        local Scroll = v331:FindFirstChild("Scroll");

        if Scroll and Scroll:IsA("GuiObject") then
            Scroll.Visible = false;
            Scroll.Active = false;
        end;
    end;

    Filter.Activated:Connect(function() -- Line: 2258, Name: handleSortButtonClick
        -- upvalues: DropdownContent (copy), u19 (ref), Router (ref)
        local v332 = not DropdownContent.Visible;
        local v333 = u19;

        if v333 then
            v333.Visible = v332;
            v333.Active = v332;
            local Scroll = v333:FindFirstChild("Scroll");

            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = v332;
                Scroll.Active = v332;
            end;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    BindSortDropdownFocus(DropdownContent, Filter, function() -- Line: 2264
        -- upvalues: u11 (ref), Filter (copy)
        return u11 or Filter.Container.Left.Title.Text;
    end, "UI.Inventory.SortFocusDeferred");
    local ReverseSort = u20.Frame.Right.Top.ReverseSort;

    local function handleReverseSortButtonClick() -- Line: 2270
        -- upvalues: u12 (ref), ReverseSort (copy), Profiler (ref), u20 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), Router (ref)
        u12 = not u12;
        local v334 = u12;
        local v335 = ReverseSort:FindFirstChildOfClass("ImageLabel");

        if v335 then
            v335.Rotation = v334 and 180 or 0;
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
        local u336 = DropdownContent.Scroll:FindFirstChild(v);

        if u336 then
            local Scroll = DropdownContent.Scroll;
            local Title = Filter.Container.Left.Title;

            local function u338() -- Line: 2287
                -- upvalues: u19 (ref)
                local v337 = u19;

                if not v337 then
                    return;
                end;

                v337.Visible = false;
                v337.Active = false;
                local Scroll2 = v337:FindFirstChild("Scroll");

                if Scroll2 and Scroll2:IsA("GuiObject") then
                    Scroll2.Visible = false;
                    Scroll2.Active = false;
                end;
            end;

            u336.Selectable = true;

            local function u339() -- Line: 1188
                -- upvalues: Router (ref), u18 (ref), u11 (ref), v (copy), Profiler (ref), u20 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), Title (copy), Scroll (copy), u336 (copy), u338 (copy)
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
                        child.Frame.BackgroundTransparency = child == u336 and 0 or 1;
                    end;
                end;

                u338();
            end;

            u336.MouseButton1Click:Connect(u339);
            u336.Activated:Connect(function(p340) -- Line: 1170
                -- upvalues: u339 (copy)
                if p340 and p340.UserInputType == Enum.UserInputType.Gamepad1 then
                    u339();
                end;
            end);
        end;
    end;

    local Title = u20.Frame.Right.Top.Search.Container.Container.Title;
    BindSearchTap(u20.Frame.Right.Top.Search, Title);
    local TradeUp = u20.Frame.Right.Top.TradeUp;
    local TradeUp2 = u20.Frame.TradeUp;
    local Fuse = u20.Frame.Right.Top:FindFirstChild("Fuse");

    if Fuse and not Constants.FUSER_ENABLED then
        Fuse.Visible = false;
    end;

    local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local Container = TradeUp2.TradeContainer.Container;
    local Exchange = TradeUp2.TradeContainer.Exchange;
    local AddTemplate = Exchange.AddTemplate;
    AddTemplate.Visible = false;
    local u341 = ReplicatedStorage.Assets.UI.Inventory.ItemTemplate:Clone();
    local u342 = { "Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float", "Serial" };
    local u343 = {
        Blue = "Purple",
        Purple = "Pink",
        Pink = "Red"
    };
    local u344 = {
        Blue = true,
        Purple = true,
        Pink = true
    };

    for _, v in { u341, AddTemplate } do
        local v345 = v;

        for _, descendant in ipairs(v:GetDescendants()) do
            if descendant:IsA("GuiObject") then
                descendant.Active = false;

                if descendant:IsA("GuiButton") then
                    descendant.Interactable = false;
                    descendant.Selectable = false;
                end;
            end;
        end;

        if not v345:FindFirstChildOfClass("UIScale") then
            Instance.new("UIScale").Parent = v345;
        end;
    end;

    for _, v in { Container, Exchange } do
        local v346 = v:FindFirstChildOfClass("UIGridLayout");

        if v346 then
            v346.SortOrder = Enum.SortOrder.LayoutOrder;
        end;
    end;

    local u347 = nil;

    for _, child in ipairs(TradeUp2.Warning:GetChildren()) do
        if child.Name == "WarningForTradeUp" then
            local Container2 = child:FindFirstChild("Container");
            local v348 = Container2 and Container2:FindFirstChild("Left");

            if v348 then
                v348 = v348:FindFirstChild("Title");
            end;

            if v348 and (v348:IsA("TextLabel") and string.find(v348.Text, "Selected For Exchange", 1, true)) then
                u347 = v348;
                break;
            end;
        end;
    end;

    local ContractHeader = TradeUp2.Warning:FindFirstChild("ContractHeader");

    if ContractHeader then
        ContractHeader = ContractHeader:FindFirstChild("Count");
    end;

    local u349 = "Newest";
    local u350 = false;
    local u351 = {};
    local u352 = {};
    local u353 = nil;
    local u354 = nil;
    local u355 = nil;
    local u356 = {};
    local u357 = true;
    DataController.CreateListener(LocalPlayer, "Inventory", function() -- Line: 2387
        -- upvalues: u357 (ref)
        u357 = true;
    end);

    local function getTradeUpSearchable(p358) -- Line: 2392
        local string_lower_ret = string.lower((p358.Name or "") .. " " .. (p358.Skin or ""));

        if string.find(string_lower_ret, "zeus", 1, true) then
            string_lower_ret = string_lower_ret .. " taser";
        end;

        return string_lower_ret;
    end;

    local function tradeUpMatchesSearch(p359: string) -- Line: 2400
        -- upvalues: u351 (copy)
        if #u351 == 0 then
            return true;
        end;

        for _, v in ipairs(u351) do
            if string.find(p359, v, 1, true) == nil then
                return false;
            end;
        end;

        return true;
    end;

    local u360 = {};
    Collections.ObserveAvailableCollections(function() -- Line: 2414
        -- upvalues: u360 (copy), u357 (ref)
        table.clear(u360);
        u357 = true;
    end);

    local function collectionHasNextTier(p361: string?, p362: string) -- Line: 2418
        -- upvalues: u343 (copy), u10 (ref), u360 (copy), GetResolvedSkinInformation (ref)
        if not p361 or p361 == "" then
            return false;
        end;

        local v363 = u343[p362];

        if not v363 then
            return false;
        end;

        if not u10 then
            return false;
        end;

        local v364 = p361 .. "|" .. v363;
        local v365 = u360[v364];

        if v365 ~= nil then
            return v365;
        end;

        local v366 = false;

        for _, v in ipairs(u10) do
            if v.name == p361 then
                for _, v2 in ipairs(v.items or {}) do
                    local v367 = GetResolvedSkinInformation(v2.itemName, v2.skinName);

                    if v367 and v367.rarity == v363 then
                        v366 = true;
                        break;
                    end;
                end;

                break;
            end;
        end;

        u360[v364] = v366;

        return v366;
    end;

    local u368 = {};

    local function getEligibleTradeUpInfo(p369) -- Line: 2454
        -- upvalues: u368 (copy), GetResolvedSkinInformation (ref), u344 (copy), collectionHasNextTier (copy)
        if p369.Type ~= "Weapon" and p369.Type ~= "Zeus x27" then
            return nil;
        end;

        local v370 = (p369.Name or "") .. "|" .. (p369.Skin or "");
        local v371 = u368[v370];

        if v371 == nil then
            v371 = GetResolvedSkinInformation(p369.Name, p369.Skin);

            if v371 then
                u368[v370] = v371;
            end;
        end;

        if not v371 then
            return nil;
        end;

        local rarity = v371.rarity;

        if not (rarity and u344[rarity]) then
            return nil;
        end;

        if collectionHasNextTier(v371.collection, rarity) then
            return v371;
        end;

        return nil;
    end;

    local function getTradeUpKey(p372, p373) -- Line: 2482
        return tostring(p373.rarity) .. "|" .. (p372.StatTrack and "ST" or "N");
    end;

    local function isTradeUpSelected(p374: string) -- Line: 2486
        -- upvalues: u352 (copy)
        return table.find(u352, p374) ~= nil;
    end;

    local function updateTradeUpWarning() -- Line: 2490
        -- upvalues: u347 (ref), u352 (copy), ContractHeader (copy)
        if u347 then
            u347.Text = `{#u352}/{10} Selected For Exchange`;
        end;

        if ContractHeader then
            ContractHeader.Text = `{#u352} / {10}`;
        end;
    end;

    local function clearRenderedItems(p375: userdata) -- Line: 2500
        for _, child in ipairs(p375:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy();
            end;
        end;
    end;

    local function buildTradeUpFrame(p376: userdata, u377: any, p378: any, p379: string, u380: function) -- Line: 2510
        -- upvalues: u341 (copy), ItemCard (ref), Router (ref), TweenService (ref), TweenInfo_new_ret (copy), u3 (ref), u5 (ref), u6 (ref), u14 (ref)
        local u381 = u341:Clone();
        u381.Name = u377._id;
        u381.Parent = p376;
        u381.Visible = true;
        u381.Selectable = true;
        ItemCard.Fill(u381, u377, p378, false);
        local u382 = u381:FindFirstChild(p379);
        local u383 = u381:FindFirstChildOfClass("UIScale");
        u381.MouseEnter:Connect(function() -- Line: 2530
            -- upvalues: u382 (copy), Router (ref), TweenService (ref), u383 (copy), TweenInfo_new_ret (ref), u3 (ref), u5 (ref), u377 (copy), u6 (ref), u381 (copy), u14 (ref)
            if u382 then
                u382.Visible = true;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
            TweenService:Create(u383, TweenInfo_new_ret, {
                Scale = 0.95
            }):Play();

            if u3 then
                u5 = u377;
                u6 = u381;
                u14 = tick();
            end;
        end);
        u381.MouseLeave:Connect(function() -- Line: 2543
            -- upvalues: u382 (copy), TweenService (ref), u383 (copy), TweenInfo_new_ret (ref), u3 (ref), u6 (ref), u381 (copy), u5 (ref), u14 (ref)
            if u382 then
                u382.Visible = false;
            end;

            TweenService:Create(u383, TweenInfo_new_ret, {
                Scale = 1
            }):Play();

            if u3 and u6 == u381 then
                u6 = nil;
                u5 = nil;
                u14 = nil;
            end;
        end);
        u381.SelectionGained:Connect(function() -- Line: 2554
            -- upvalues: u382 (copy)
            if u382 then
                u382.Visible = true;
            end;
        end);
        u381.SelectionLost:Connect(function() -- Line: 2559
            -- upvalues: u382 (copy)
            if u382 then
                u382.Visible = false;
            end;
        end);
        u381.MouseButton1Down:Connect(function() -- Line: 2564
            -- upvalues: TweenService (ref), u383 (copy), TweenInfo_new_ret (ref)
            TweenService:Create(u383, TweenInfo_new_ret, {
                Scale = 0.9
            }):Play();
        end);
        u381.MouseButton1Up:Connect(function() -- Line: 2567
            -- upvalues: TweenService (ref), u383 (copy), TweenInfo_new_ret (ref)
            TweenService:Create(u383, TweenInfo_new_ret, {
                Scale = 0.95
            }):Play();
        end);
        u381.MouseButton1Click:Connect(function() -- Line: 2572
            -- upvalues: u380 (copy)
            u380();
        end);
        u381.Activated:Connect(function(p384) -- Line: 2575
            -- upvalues: u380 (copy)
            if p384 and p384.UserInputType == Enum.UserInputType.Gamepad1 then
                u380();
            end;
        end);

        return u381;
    end;

    local u385 = {};
    local u386 = 0;
    local u387 = 0;
    local u388 = 0;

    local function renderNextTradeUpBatch(p389: number) -- Line: 2594
        -- upvalues: u386 (ref), u385 (copy), buildTradeUpFrame (copy), Container (copy), u354 (ref), u387 (ref)
        local math_min_ret = math.min(u386 + p389, #u385);

        for i = u386 + 1, math_min_ret do
            local u390 = u385[i];
            local v391 = buildTradeUpFrame(Container, u390.item, u390.info, "Add", function() -- Line: 2604
                -- upvalues: u354 (ref), u390 (copy)
                u354(u390.item, u390.info);
            end);
            u387 = u387 + 1;
            v391.LayoutOrder = u387;
            local _ = i;
        end;

        u386 = math_min_ret;
    end;

    local function rebuildTradeUpPool() -- Line: 2615
        -- upvalues: u357 (ref), u356 (copy), DataController (ref), LocalPlayer (ref), getEligibleTradeUpInfo (copy), Sort (ref), u349 (ref), u10 (ref), u350 (ref)
        u357 = false;
        table.clear(u356);
        local v392 = DataController.Get(LocalPlayer, "Inventory");

        if not v392 then
            return;
        end;

        for _, v in ipairs(v392) do
            if v and v._id then
                local v393 = getEligibleTradeUpInfo(v);

                if v393 then
                    local v394 = {
                        item = v,
                        info = v393,
                        key = tostring(v393.rarity) .. "|" .. (v.StatTrack and "ST" or "N")
                    };
                    local string_lower_ret = string.lower((v.Name or "") .. " " .. (v.Skin or ""));

                    if string.find(string_lower_ret, "zeus", 1, true) then
                        string_lower_ret = string_lower_ret .. " taser";
                    end;

                    v394.searchable = string_lower_ret;
                    table.insert(u356, v394);
                end;
            end;
        end;

        local SortComparisonFunction = Sort.GetSortComparisonFunction(u349, LocalPlayer, function() -- Line: 2639
            -- upvalues: u10 (ref)
            return u10;
        end);

        if SortComparisonFunction then
            table.sort(u356, function(p395, p396) -- Line: 2643
                -- upvalues: u350 (ref), SortComparisonFunction (copy)
                if not u350 then
                    return SortComparisonFunction(p395.item, p396.item);
                end;

                local v397, v398 = SortComparisonFunction(p395.item, p396.item);

                if v398 then
                    return v397;
                end;

                return SortComparisonFunction(p396.item, p395.item);
            end);
        end;
    end;

    local function renderTradeUpContainer() -- Line: 2657
        -- upvalues: u388 (ref), clearRenderedItems (copy), Container (copy), u385 (copy), u386 (ref), u387 (ref), u357 (ref), rebuildTradeUpPool (copy), u356 (copy), u352 (copy), u353 (ref), tradeUpMatchesSearch (copy), renderNextTradeUpBatch (copy), TradeUp2 (copy)
        u388 = u388 + 1;
        local u399 = u388;
        clearRenderedItems(Container);
        table.clear(u385);
        u386 = 0;
        u387 = 0;

        if u357 then
            rebuildTradeUpPool();
        end;

        for _, v in ipairs(u356) do
            if table.find(u352, v.item._id) == nil and (u353 == nil or v.key == u353) and tradeUpMatchesSearch(v.searchable) then
                table.insert(u385, v);
            end;
        end;

        renderNextTradeUpBatch(25);

        if #u385 > 25 then
            task.defer(function() -- Line: 2683
                -- upvalues: u399 (copy), u388 (ref), TradeUp2 (ref), renderNextTradeUpBatch (ref)
                if u399 == u388 and TradeUp2.Visible then
                    renderNextTradeUpBatch(25);
                end;
            end);
        end;
    end;

    Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 2692
        -- upvalues: TradeUp2 (copy), u386 (ref), u385 (copy), Container (copy), renderNextTradeUpBatch (copy)
        if not TradeUp2.Visible or u386 >= #u385 then
            return;
        end;

        local v400 = Container.AbsoluteCanvasSize.Y - Container.AbsoluteSize.Y;

        if v400 > 0 and v400 - Container.CanvasPosition.Y < 200 then
            renderNextTradeUpBatch(25);
        end;
    end);
    local u401 = {};
    local u402 = {};

    for i = 1, 10 do
        local v403 = AddTemplate:Clone();
        v403.Name = `AddSlot{i}`;
        v403.Visible = true;
        v403.LayoutOrder = i + 100;
        v403.Active = false;
        v403.Interactable = false;
        v403.Selectable = false;
        v403.Parent = Exchange;
        u401[i] = v403;
        u402[v403] = true;
        local _ = i;
    end;

    local function updateExchangePlaceholders() -- Line: 2719
        -- upvalues: u352 (copy), u401 (copy)
        local v404 = #u352;

        for i, v in ipairs(u401) do
            v.Visible = v404 < i;
        end;
    end;

    local function appendExchangeFrame(p405: any, p406: any, p407: number) -- Line: 2727
        -- upvalues: buildTradeUpFrame (copy), Exchange (copy), u355 (ref)
        local _id = p405._id;
        buildTradeUpFrame(Exchange, p405, p406, "Remove", function() -- Line: 2734
            -- upvalues: u355 (ref), _id (copy)
            u355(_id);
        end).LayoutOrder = p407;
    end;

    local function renderTradeUpExchange() -- Line: 2742
        -- upvalues: Exchange (copy), AddTemplate (copy), u402 (copy), DataController (ref), LocalPlayer (ref), u352 (copy), getEligibleTradeUpInfo (copy), buildTradeUpFrame (copy), u355 (ref), u401 (copy)
        for _, child in ipairs(Exchange:GetChildren()) do
            if child:IsA("GuiObject") and (child ~= AddTemplate and not u402[child]) then
                child:Destroy();
            end;
        end;

        local v408 = DataController.Get(LocalPlayer, "Inventory");

        if v408 and #u352 > 0 then
            local v409 = {};

            for _, v in ipairs(v408) do
                if v and v._id then
                    v409[v._id] = v;
                end;
            end;

            local v410 = 0;

            for _, v in ipairs(u352) do
                local v411 = v409[v];
                local v412;

                if v411 then
                    v412 = getEligibleTradeUpInfo(v411);
                else
                    v412 = v411;
                end;

                if v412 then
                    v410 = v410 + 1;
                    local _id = v411._id;
                    buildTradeUpFrame(Exchange, v411, v412, "Remove", function() -- Line: 2734
                        -- upvalues: u355 (ref), _id (copy)
                        u355(_id);
                    end).LayoutOrder = v410;
                end;
            end;
        end;

        local v413 = #u352;

        for i, v in ipairs(u401) do
            v.Visible = v413 < i;
        end;
    end;

    local function renderTradeUp() -- Line: 2777
        -- upvalues: renderTradeUpContainer (copy), renderTradeUpExchange (copy), u347 (ref), u352 (copy), ContractHeader (copy)
        renderTradeUpContainer();
        renderTradeUpExchange();

        if u347 then
            u347.Text = `{#u352}/{10} Selected For Exchange`;
        end;

        if ContractHeader then
            ContractHeader.Text = `{#u352} / {10}`;
        end;
    end;

    u354 = function(p414, p415) -- Line: 2783, Name: selectTradeUpItem
        -- upvalues: Router (ref), u352 (copy), u353 (ref), renderTradeUpContainer (copy), u385 (copy), u386 (ref), Container (copy), renderNextTradeUpBatch (copy), buildTradeUpFrame (copy), Exchange (copy), u355 (ref), u401 (copy), u347 (ref), ContractHeader (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if #u352 >= 10 or table.find(u352, p414._id) ~= nil then
            return;
        end;

        local v416 = tostring(p415.rarity) .. "|" .. (p414.StatTrack and "ST" or "N");

        if u353 and v416 ~= u353 then
            return;
        end;

        local v417 = #u352 == 0;

        if v417 then
            u353 = v416;
        end;

        table.insert(u352, p414._id);

        if v417 then
            renderTradeUpContainer();
        else
            for i, v in ipairs(u385) do
                if v.item._id == p414._id then
                    table.remove(u385, i);

                    if i <= u386 then
                        u386 = u386 - 1;
                        local v418 = Container:FindFirstChild(p414._id);

                        if v418 then
                            v418:Destroy();
                        end;
                    end;

                    break;
                end;
            end;

            if u386 < 50 and u386 < #u385 then
                renderNextTradeUpBatch(50 - u386);
            end;
        end;

        local _id = p414._id;
        buildTradeUpFrame(Exchange, p414, p415, "Remove", function() -- Line: 2734
            -- upvalues: u355 (ref), _id (copy)
            u355(_id);
        end).LayoutOrder = #u352;
        local v419 = #u352;

        for i, v in ipairs(u401) do
            v.Visible = v419 < i;
        end;

        if u347 then
            u347.Text = `{#u352}/{10} Selected For Exchange`;
        end;

        if ContractHeader then
            ContractHeader.Text = `{#u352} / {10}`;
        end;
    end;

    u355 = function(p420: string) -- Line: 2830, Name: deselectTradeUpItem
        -- upvalues: Router (ref), u352 (copy), u353 (ref), renderTradeUpContainer (copy), Exchange (copy), u402 (copy), u401 (copy), u347 (ref), ContractHeader (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local table_find_ret = table.find(u352, p420);

        if not table_find_ret then
            return;
        end;

        table.remove(u352, table_find_ret);

        if #u352 == 0 then
            u353 = nil;
        end;

        renderTradeUpContainer();
        local v421 = Exchange:FindFirstChild(p420);

        if v421 and not u402[v421] then
            v421:Destroy();
        end;

        for i, v in ipairs(u352) do
            local v422 = Exchange:FindFirstChild(v);

            if v422 then
                v422.LayoutOrder = i;
            end;
        end;

        local v423 = #u352;

        for i, v in ipairs(u401) do
            v.Visible = v423 < i;
        end;

        if u347 then
            u347.Text = `{#u352}/{10} Selected For Exchange`;
        end;

        if ContractHeader then
            ContractHeader.Text = `{#u352} / {10}`;
        end;
    end;

    local function clearTradeUpSelection() -- Line: 2860
        -- upvalues: u352 (copy), u353 (ref)
        table.clear(u352);
        u353 = nil;
    end;

    local u424 = false;
    local u425 = false;
    local u426 = nil;
    local u427 = 0;
    local u428 = nil;
    local u429 = false;
    local u430 = false;
    local u431 = false;
    local Title2 = TradeUp2.Options.Proceed.Container.Title;
    local Text = Title2.Text;
    local Position = TradeUp2.Options.Cancel.Position;
    local Position2 = TradeUp2.Options.Proceed.Position;
    local UDim2_new_ret = UDim2.new(0.405, 0, Position.Y.Scale, Position.Y.Offset);
    local UDim2_new_ret2 = UDim2.new(0.595, 0, Position2.Y.Scale, Position2.Y.Offset);
    local UDim2_new_ret3 = UDim2.new(0.5, 0, Position2.Y.Scale, Position2.Y.Offset);
    local Size = TradeUp2.Options.Cancel.Size;
    local Size2 = TradeUp2.Options.Proceed.Size;
    local UDim2_fromScale_ret = UDim2.fromScale(0.165, 1);
    local TweenInfo_new_ret2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local u432 = {};
    local u433 = {};

    local function tweenTradeUpOption(p434: userdata, p435: number) -- Line: 2905
        -- upvalues: u432 (copy), u433 (copy), TweenService (ref), TweenInfo_new_ret2 (copy)
        local v436 = u432[p434] or p434.Size;
        local v437 = u433[p434];

        if v437 then
            v437:Cancel();
        end;

        local v438 = TweenService:Create(p434, TweenInfo_new_ret2, {
            Size = UDim2.new(v436.X.Scale * p435, v436.X.Offset, v436.Y.Scale * p435, v436.Y.Offset)
        });
        u433[p434] = v438;
        v438:Play();
    end;

    local function setTradeUpOptionSize(p439: userdata, p440) -- Line: 2918
        -- upvalues: u433 (copy), u432 (copy)
        local v441 = u433[p439];

        if v441 then
            v441:Cancel();
            u433[p439] = nil;
        end;

        u432[p439] = p440;
        p439.Size = p440;
    end;

    local function animateTradeUpOption(u442: userdata) -- Line: 2929
        -- upvalues: u432 (copy), Router (ref), tweenTradeUpOption (copy)
        u432[u442] = u442.Size;
        u442.MouseEnter:Connect(function() -- Line: 2931
            -- upvalues: Router (ref), tweenTradeUpOption (ref), u442 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
            tweenTradeUpOption(u442, 0.95);
        end);
        u442.MouseLeave:Connect(function() -- Line: 2935
            -- upvalues: tweenTradeUpOption (ref), u442 (copy)
            tweenTradeUpOption(u442, 1);
        end);
        u442.MouseButton1Down:Connect(function() -- Line: 2938
            -- upvalues: Router (ref), tweenTradeUpOption (ref), u442 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            tweenTradeUpOption(u442, 0.9);
        end);
        u442.MouseButton1Up:Connect(function() -- Line: 2942
            -- upvalues: tweenTradeUpOption (ref), u442 (copy)
            tweenTradeUpOption(u442, 0.95);
        end);
    end;

    local Frame = TradeUp2.TradeContainer.Contract.Frame;
    local Position3 = Frame.Position;
    local UDim2_new_ret4 = UDim2.new(Position3.X.Scale, Position3.X.Offset, 1.5, 0);
    local TweenInfo_new_ret3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
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
    local u443 = 0;
    local u444 = false;
    local u445 = nil;

    local function clearContractDrawing() -- Line: 2979
        -- upvalues: u444 (ref), u445 (ref), u443 (ref), Frame2 (copy)
        u444 = false;
        u445 = nil;
        u443 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;
    end;

    local function toContractCanvasPoint(p446: vector) -- Line: 2989
        -- upvalues: Frame2 (copy)
        local AbsolutePosition = Frame2.AbsolutePosition;
        local AbsoluteSize = Frame2.AbsoluteSize;

        return Vector2.new(math.clamp(p446.X - AbsolutePosition.X, 0, AbsoluteSize.X), (math.clamp(p446.Y - AbsolutePosition.Y, 0, AbsoluteSize.Y)));
    end;

    local function createContractInkFrame() -- Line: 2998
        -- upvalues: Color3_fromRGB_ret (copy)
        local Frame3 = Instance.new("Frame");
        Frame3.BackgroundColor3 = Color3_fromRGB_ret;
        Frame3.BorderSizePixel = 0;
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Frame3.ZIndex = 10;

        return Frame3;
    end;

    local function addContractDrawPoint(p447) -- Line: 3009
        -- upvalues: u443 (ref), u445 (ref), Color3_fromRGB_ret (copy), Frame2 (copy)
        if u443 >= 2500 then
            return;
        end;

        local v448 = u445;

        if v448 and (p447 - v448).Magnitude < 2 then
            return;
        end;

        u443 = u443 + 1;
        local Frame3 = Instance.new("Frame");
        Frame3.BackgroundColor3 = Color3_fromRGB_ret;
        Frame3.BorderSizePixel = 0;
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Frame3.ZIndex = 10;
        Frame3.Position = UDim2.fromOffset(p447.X, p447.Y);
        Frame3.Size = UDim2.fromScale(0.01, 0.01);
        Frame3.Parent = Frame2;

        if v448 then
            local v449 = p447 - v448;
            local v450 = (p447 + v448) / 2;
            local Frame4 = Instance.new("Frame");
            Frame4.BackgroundColor3 = Color3_fromRGB_ret;
            Frame4.BorderSizePixel = 0;
            Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
            Frame4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
            Frame4.ZIndex = 10;
            Frame4.Position = UDim2.fromOffset(v450.X, v450.Y);
            Frame4.Size = UDim2.new(0, v449.Magnitude, 0.01, 0);
            local math_atan_ret = math.atan(v449.Y / v449.X);
            Frame4.Rotation = math.deg(math_atan_ret);
            Frame4.Parent = Frame2;
        end;

        u445 = p447;
    end;

    Frame2.InputBegan:Connect(function(p451) -- Line: 3042
        -- upvalues: u444 (ref), u445 (ref), addContractDrawPoint (copy), toContractCanvasPoint (copy)
        if p451.UserInputType == Enum.UserInputType.MouseButton1 or p451.UserInputType == Enum.UserInputType.Touch then
            u444 = true;
            u445 = nil;
            addContractDrawPoint(toContractCanvasPoint(p451.Position));
        end;
    end);
    UserInputService.InputChanged:Connect(function(p452) -- Line: 3054
        -- upvalues: u444 (ref), addContractDrawPoint (copy), toContractCanvasPoint (copy)
        if not u444 then
            return;
        end;

        if p452.UserInputType == Enum.UserInputType.MouseMovement or p452.UserInputType == Enum.UserInputType.Touch then
            addContractDrawPoint(toContractCanvasPoint(p452.Position));
        end;
    end);
    UserInputService.InputEnded:Connect(function(p453) -- Line: 3066
        -- upvalues: u444 (ref), u445 (ref)
        if p453.UserInputType == Enum.UserInputType.MouseButton1 or p453.UserInputType == Enum.UserInputType.Touch then
            u444 = false;
            u445 = nil;
        end;
    end);
    local u454 = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
    local u455 = { {
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
    local u456 = 0;

    local function playRandomTypingSound() -- Line: 3093
        -- upvalues: Router (ref)
        Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
    end;

    local function getContractDate() -- Line: 3098
        -- upvalues: u454 (copy)
        local os_date_ret = os.date("*t");

        return string.format("%s %d, %d", u454[os_date_ret.month], os_date_ret.day, os_date_ret.year);
    end;

    local function getPlayerRankTitle() -- Line: 3103
        -- upvalues: DataController (ref), LocalPlayer (ref), u455 (copy)
        local v457 = DataController.Get(LocalPlayer, "Level");
        local v458 = type(v457) == "table" and tonumber(v457.Level) or 1;

        for _, v in ipairs(u455) do
            if v458 <= v.maxLevel then
                return v.title;
            end;
        end;

        return "Global Elite";
    end;

    local function runContractTypewriter() -- Line: 3115
        -- upvalues: u456 (ref), TradeUp2 (copy), LocalPlayer (ref), u454 (copy), getPlayerRankTitle (copy), Router (ref)
        u456 = u456 + 1;
        local u459 = u456;
        local Frame3 = TradeUp2.TradeContainer.Contract.Frame;
        local v460 = Frame3:FindFirstChild("1");
        local v461 = Frame3:FindFirstChild("2");

        if not (v460 and v461) then
            return;
        end;

        local v462 = {};
        local v463 = {
            label = v460:FindFirstChild("ID"),
            text = tostring(LocalPlayer.UserId)
        };
        local v464 = {
            label = v460:FindFirstChild("Name"),
            text = LocalPlayer.Name
        };
        local v465 = {
            label = v460:FindFirstChild("Number"),
            text = tostring(10)
        };
        local v466 = {
            label = v461:FindFirstChild("Date")
        };
        local os_date_ret = os.date("*t");
        v466.text = string.format("%s %d, %d", u454[os_date_ret.month], os_date_ret.day, os_date_ret.year);
        v462[1], v462[2], v462[3], v462[4], v462[5] = v463, v464, v465, v466, {
    label = v461:FindFirstChild("Rank"),
    text = getPlayerRankTitle()
};
        local u467 = 0;
        local u468 = {};

        for _, v in ipairs(v462) do
            if v.label and v.label:IsA("TextLabel") then
                v.label.Text = "";
                u467 = math.max(u467, #v.text);
                table.insert(u468, v);
            end;
        end;

        task.spawn(function() -- Line: 3146
            -- upvalues: u459 (copy), u456 (ref), u467 (ref), u468 (copy), Router (ref)
            task.wait(0.2);

            if u459 ~= u456 then
                return;
            end;

            for i = 1, u467 do
                task.wait(0.12);

                if u459 ~= u456 then
                    return;
                end;

                local v469 = i;

                for _, v in ipairs(u468) do
                    if v469 <= #v.text then
                        v.label.Text = string.sub(v.text, 1, v469);
                    end;
                end;

                Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
            end;
        end);
    end;

    local u470 = 0;

    local function getTradeUpItemName(p471) -- Line: 3177
        -- upvalues: GetSkinDisplayName (ref)
        if not p471 then
            return "";
        end;

        local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(p471.Name, p471.NameTag);
        local v472 = GetSkinDisplayName(p471.Skin or "", true);

        if v472 == "" then
            return WeaponDisplayName;
        end;

        return `{WeaponDisplayName} | {v472}`;
    end;

    local function utf8Prefix(p473: string, p474: number) -- Line: 3190
        local utf8_offset_ret = utf8.offset(p473, p474 + 1);

        if utf8_offset_ret then
            return string.sub(p473, 1, utf8_offset_ret - 1);
        end;

        return p473;
    end;

    local function getContractSlotLabel(p475: number) -- Line: 3199
        -- upvalues: TradeUp2 (copy)
        local Frame3 = TradeUp2.TradeContainer.Contract.Frame;
        local v476 = tostring(p475);
        local v477 = Frame3:FindFirstChild("3") and Frame3["3"]:FindFirstChild(v476) or Frame3:FindFirstChild("4") and Frame3["4"]:FindFirstChild(v476);

        if v477 and v477:IsA("TextLabel") then
            return v477;
        end;

        return nil;
    end;

    local function getContractReceivedLabel() -- Line: 3210
        -- upvalues: TradeUp2 (copy)
        local v478 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

        if v478 then
            v478 = v478:FindFirstChild("Received");
        end;

        if v478 and v478:IsA("TextLabel") then
            return v478;
        end;

        return nil;
    end;

    local function clearContractSlots() -- Line: 3221
        -- upvalues: getContractSlotLabel (copy), TradeUp2 (copy)
        for i = 1, 10 do
            local v479 = getContractSlotLabel(i);
            local v480;

            if v479 then
                v479.Text = "";
                v480 = i;
            else
                v480 = i;
            end;
        end;

        local v481 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

        if v481 then
            v481 = v481:FindFirstChild("Received");
        end;

        if not (v481 and v481:IsA("TextLabel")) then
            v481 = nil;
        end;

        if v481 then
            v481.Text = "";
        end;
    end;

    local function clearContractHeaderFields() -- Line: 3235
        -- upvalues: TradeUp2 (copy)
        local Frame3 = TradeUp2.TradeContainer.Contract.Frame;

        for _, v in { { "1", "ID", "Name", "Number" }, { "2", "Date", "Rank" } } do
            local v482 = Frame3:FindFirstChild(v[1]);
            local v483 = v;

            for i = 2, #v do
                local v484;

                if v482 then
                    v484 = v482:FindFirstChild(v483[i]);
                else
                    v484 = v482;
                end;

                local v485;

                if v484 and v484:IsA("TextLabel") then
                    v484.Text = "";
                    v485 = i;
                else
                    v485 = i;
                end;
            end;
        end;
    end;

    local u486 = nil;

    local function finishTradeUpReveal(u487) -- Line: 3252
        -- upvalues: u486 (ref), GetResolvedSkinInformation (ref), Router (ref), u33 (ref), u32 (ref), u1 (ref), MenuState (ref)
        u486(false);

        if not u487 then
            return;
        end;

        local v488 = GetResolvedSkinInformation(u487.Name, u487.Skin);
        Router.broadcastRouter("RunStoreSound", u33[v488 and v488.rarity or (u487.Rarity or "Blue")] or "Drop Blue");

        local function showNotification() -- Line: 3263
            -- upvalues: u32 (ref), u1 (ref), u487 (copy)
            u32 = false;
            u1.ShowNewItemNotification(u487);
        end;

        local u489 = nil;
        u489 = MenuState.OnInspectStateChanged:Connect(function(p490: boolean) -- Line: 3269
            -- upvalues: u489 (ref), u32 (ref), u1 (ref), u487 (copy)
            if p490 then
                return;
            end;

            u489:Disconnect();
            u489 = nil;
            u32 = false;
            u1.ShowNewItemNotification(u487);
        end);
        Router.broadcastRouter("WeaponInspect", u487.Name, u487.Skin, u487.Float, u487.StatTrack, u487.NameTag, u487.Charm, u487.Stickers, u487.Type, u487.Pattern, u487._id, u487.Serial, u487.IsTradeable);

        if u489 and not Router.broadcastRouter("IsInspectActive") then
            u489:Disconnect();
            u489 = nil;
            u32 = false;
            u1.ShowNewItemNotification(u487);
        end;
    end;

    local function runContractConfirmReveal(u491: table) -- Line: 3289
        -- upvalues: u470 (ref), clearContractSlots (copy), getContractSlotLabel (copy), Router (ref), u428 (ref), TradeUp2 (copy), GetSkinDisplayName (ref), TweenService (ref), finishTradeUpReveal (copy)
        u470 = u470 + 1;
        local u492 = u470;
        clearContractSlots();
        task.spawn(function() -- Line: 3294
            -- upvalues: getContractSlotLabel (ref), u491 (copy), u492 (copy), u470 (ref), Router (ref), u428 (ref), TradeUp2 (ref), GetSkinDisplayName (ref), TweenService (ref), finishTradeUpReveal (ref)
            for i = 1, 10 do
                local v493 = getContractSlotLabel(i);
                local v494 = u491[i] or "";
                local v495;

                if v493 then
                    v495 = i;

                    for i2 = 1, utf8.len(v494) or #v494 do
                        task.wait(0.06);

                        if u492 ~= u470 then
                            return;
                        end;

                        local utf8_offset_ret = utf8.offset(v494, i2 + 1);
                        local v496;

                        if utf8_offset_ret then
                            v496 = string.sub(v494, 1, utf8_offset_ret - 1);
                        else
                            v496 = v494;
                        end;

                        v493.Text = v496;
                        Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                        local _ = i2;
                    end;
                else
                    v495 = i;
                end;
            end;

            while u492 == u470 and u428 == nil do
                task.wait(0.05);
            end;

            if u492 ~= u470 then
                return;
            end;

            local v497 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

            if v497 then
                v497 = v497:FindFirstChild("Received");
            end;

            if not (v497 and v497:IsA("TextLabel")) then
                v497 = nil;
            end;

            local v498 = u428;
            local v499;

            if v498 then
                v499 = GetSkinDisplayName.GetWeaponDisplayName(v498.Name, v498.NameTag);
                local v500 = GetSkinDisplayName(v498.Skin or "", true);

                if v500 ~= "" then
                    v499 = `{v499} | {v500}`;
                end;
            else
                v499 = "";
            end;

            if v497 then
                for i = 1, utf8.len(v499) or #v499 do
                    task.wait(0.06);

                    if u492 ~= u470 then
                        return;
                    end;

                    local utf8_offset_ret = utf8.offset(v499, i + 1);
                    local v501;

                    if utf8_offset_ret then
                        v501 = string.sub(v499, 1, utf8_offset_ret - 1);
                    else
                        v501 = v499;
                    end;

                    v497.Text = v501;
                    Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                    local _ = i;
                end;
            end;

            task.wait(0.1);

            if u492 ~= u470 then
                return;
            end;

            local Approved = TradeUp2.TradeContainer.Contract:FindFirstChild("Approved");

            if Approved and Approved:IsA("ImageLabel") then
                Approved.Size = UDim2.fromScale(0.65, 0.65);
                Approved.ImageTransparency = 0.85;
                Approved.Visible = true;
                Router.broadcastRouter("RunInterfaceSound", "TradeUp Approved");

                local function stampStep(p502: number, p503: table) -- Line: 3345
                    -- upvalues: TweenService (ref), Approved (copy)
                    return TweenService:Create(Approved, TweenInfo.new(p502, Enum.EasingStyle.Linear), p503);
                end;

                local v504 = {};
                local v505 = {
                    ImageTransparency = 0,
                    Size = UDim2.fromScale(0.35, 0.35)
                };
                local v506 = TweenService:Create(Approved, TweenInfo.new(0.2, Enum.EasingStyle.Linear), v505);
                local v507 = {
                    Size = UDim2.fromScale(0.365, 0.365)
                };
                v504[1], v504[2], v504[3] = v506, TweenService:Create(Approved, TweenInfo.new(0.03, Enum.EasingStyle.Linear), v507), stampStep(0.03, {
    Size = UDim2.fromScale(0.35, 0.35)
});

                for _, v in ipairs(v504) do
                    v:Play();
                    v.Completed:Wait();

                    if u492 ~= u470 then
                        return;
                    end;
                end;
            end;

            task.wait(1.25);

            if u492 ~= u470 then
                return;
            end;

            finishTradeUpReveal(u428);
        end);
    end;

    local function skipContractReveal() -- Line: 3371
        -- upvalues: u470 (ref), u428 (ref), finishTradeUpReveal (copy)
        u470 = u470 + 1;
        local u508 = u470;
        task.spawn(function() -- Line: 3375
            -- upvalues: u508 (copy), u470 (ref), u428 (ref), finishTradeUpReveal (ref)
            while u508 == u470 and u428 == nil do
                task.wait(0.05);
            end;

            if u508 ~= u470 then
                return;
            end;

            finishTradeUpReveal(u428);
        end);
    end;

    local function setTradeUpItemSelectionState() -- Line: 3387
        -- upvalues: u424 (ref), u429 (ref), u430 (ref), u431 (ref), u456 (ref), u470 (ref), TradeUp2 (copy), Title2 (copy), Text (copy), Position (copy), Position2 (copy), Size (copy), u433 (copy), u432 (copy), Size2 (copy), u425 (ref), u21 (ref), u444 (ref), u445 (ref), u443 (ref), Frame2 (copy)
        u424 = false;
        u429 = false;
        u430 = false;
        u431 = false;
        u456 = u456 + 1;
        u470 = u470 + 1;
        TradeUp2.Options.Clear.Visible = true;
        TradeUp2.Options.Proceed.Visible = true;
        TradeUp2.Options.Cancel.Visible = false;
        Title2.Text = Text;
        TradeUp2.Options.Cancel.Position = Position;
        TradeUp2.Options.Proceed.Position = Position2;
        local Cancel = TradeUp2.Options.Cancel;
        local v509 = Size;
        local v510 = u433[Cancel];

        if v510 then
            v510:Cancel();
            u433[Cancel] = nil;
        end;

        u432[Cancel] = v509;
        Cancel.Size = v509;
        local Proceed = TradeUp2.Options.Proceed;
        local v511 = Size2;
        local v512 = u433[Proceed];

        if v512 then
            v512:Cancel();
            u433[Proceed] = nil;
        end;

        u432[Proceed] = v511;
        Proceed.Size = v511;
        TradeUp2.Top.Visible = true;

        if u425 and (u21 and u21.Menu) then
            u21.Menu.Top.Visible = true;
        end;

        u425 = false;
        TradeUp2.TradeContainer.Container.Visible = true;
        TradeUp2.TradeContainer.Exchange.Visible = true;
        TradeUp2.TradeContainer.Contract.Visible = false;
        u444 = false;
        u445 = nil;
        u443 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;

        for _, child in ipairs(TradeUp2.Warning:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = child.Name ~= "WarningForContract";
            end;
        end;
    end;

    local function setTradeUpContractState() -- Line: 3429
        -- upvalues: u424 (ref), TradeUp2 (copy), Title2 (copy), UDim2_new_ret (copy), UDim2_new_ret2 (copy), UDim2_fromScale_ret (copy), u433 (copy), u432 (copy), u21 (ref), u425 (ref), u444 (ref), u445 (ref), u443 (ref), Frame2 (copy), clearContractHeaderFields (copy), clearContractSlots (copy), u456 (ref), Frame (copy), UDim2_new_ret4 (copy), TweenService (ref), TweenInfo_new_ret3 (copy), Position3 (copy), runContractTypewriter (copy), Router (ref)
        u424 = true;
        TradeUp2.Options.Clear.Visible = false;
        TradeUp2.Options.Proceed.Visible = true;
        TradeUp2.Options.Cancel.Visible = true;
        Title2.Text = "CONFIRM";
        TradeUp2.Options.Cancel.Position = UDim2_new_ret;
        TradeUp2.Options.Proceed.Position = UDim2_new_ret2;
        local Cancel = TradeUp2.Options.Cancel;
        local v513 = UDim2_fromScale_ret;
        local v514 = u433[Cancel];

        if v514 then
            v514:Cancel();
            u433[Cancel] = nil;
        end;

        u432[Cancel] = v513;
        Cancel.Size = v513;
        local Proceed = TradeUp2.Options.Proceed;
        local v515 = UDim2_fromScale_ret;
        local v516 = u433[Proceed];

        if v516 then
            v516:Cancel();
            u433[Proceed] = nil;
        end;

        u432[Proceed] = v515;
        Proceed.Size = v515;
        TradeUp2.Top.Visible = false;

        if u21 and u21.Menu then
            u21.Menu.Top.Visible = false;
            u425 = true;
        end;

        for _, child in ipairs(TradeUp2.Warning:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = false;
            end;
        end;

        u444 = false;
        u445 = nil;
        u443 = 0;

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
        u456 = u456 + 1;
        local u517 = u456;
        Frame.Position = UDim2_new_ret4;

        if not TradeUp2.TradeContainer.Contract.Visible then
            TradeUp2.TradeContainer.Contract.Visible = true;
        end;

        task.delay(0.18, function() -- Line: 3479
            -- upvalues: u517 (copy), u456 (ref), TweenService (ref), Frame (ref), TweenInfo_new_ret3 (ref), Position3 (ref), runContractTypewriter (ref), Router (ref)
            if u517 ~= u456 then
                return;
            end;

            local v518 = TweenService:Create(Frame, TweenInfo_new_ret3, {
                Position = Position3
            });
            v518.Completed:Connect(function() -- Line: 3488
                -- upvalues: u517 (ref), u456 (ref), runContractTypewriter (ref)
                if u517 ~= u456 then
                    return;
                end;

                runContractTypewriter();
            end);
            Router.broadcastRouter("RunInterfaceSound", "TradeUp Contract Slide");
            v518:Play();
        end);
    end;

    u486 = function(p519: boolean) -- Line: 3500, Name: setTradeUpVisible
        -- upvalues: u20 (ref), TradeUp2 (copy), u6 (ref), u5 (ref), u14 (ref), u86 (ref), MenuState (ref), u18 (ref), DismissItemNotifications (ref), setTradeUpItemSelectionState (copy), u352 (copy), u353 (ref), renderTradeUp (ref), u424 (ref), u429 (ref), u430 (ref), u431 (ref), u456 (ref), u470 (ref), u444 (ref), u445 (ref), u443 (ref), Frame2 (copy), Position (copy), Position2 (copy), Size (copy), u433 (copy), u432 (copy), Size2 (copy), Title2 (copy), Text (copy), u425 (ref), u21 (ref)
        u20.Frame.Categories.Visible = not p519;
        u20.Frame.Right.Visible = not p519;
        TradeUp2.Visible = p519;
        u6 = nil;
        u5 = nil;
        u14 = nil;

        for _, v in u86 do
            local v520 = u20.Ignore[v];

            if v520 ~= nil then
                v520.Visible = false;
            end;
        end;

        if p519 then
            MenuState.EnterTradeUp();

            if u18 then
                u18.Visible = false;
            end;

            if u20.Ignore.ItemNotification.Visible then
                DismissItemNotifications();
            end;

            setTradeUpItemSelectionState();
            table.clear(u352);
            u353 = nil;
            renderTradeUp();

            return;
        end;

        MenuState.ExitTradeUp();
        u424 = false;
        u429 = false;
        u430 = false;
        u431 = false;
        u456 = u456 + 1;
        u470 = u470 + 1;
        u444 = false;
        u445 = nil;
        u443 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;

        TradeUp2.Options.Cancel.Position = Position;
        TradeUp2.Options.Proceed.Position = Position2;
        local Cancel = TradeUp2.Options.Cancel;
        local v521 = Size;
        local v522 = u433[Cancel];

        if v522 then
            v522:Cancel();
            u433[Cancel] = nil;
        end;

        u432[Cancel] = v521;
        Cancel.Size = v521;
        local Proceed = TradeUp2.Options.Proceed;
        local v523 = Size2;
        local v524 = u433[Proceed];

        if v524 then
            v524:Cancel();
            u433[Proceed] = nil;
        end;

        u432[Proceed] = v523;
        Proceed.Size = v523;
        Title2.Text = Text;

        if u425 and (u21 and u21.Menu) then
            u21.Menu.Top.Visible = true;
        end;

        u425 = false;
    end;

    local Clear = TradeUp2.Options.Clear;
    local Proceed = TradeUp2.Options.Proceed;
    local Cancel = TradeUp2.Options.Cancel;
    ActivateButton(Clear);
    Clear.Selectable = true;

    local function u525() -- Line: 3553
        -- upvalues: Router (ref), u352 (copy), u353 (ref), renderTradeUp (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        table.clear(u352);
        u353 = nil;
        renderTradeUp();
    end;

    Clear.MouseButton1Click:Connect(u525);
    Clear.Activated:Connect(function(p526) -- Line: 1170
        -- upvalues: u525 (copy)
        if p526 and p526.UserInputType == Enum.UserInputType.Gamepad1 then
            u525();
        end;
    end);
    animateTradeUpOption(Proceed);
    Proceed.Selectable = true;

    local function handleTradeUpProceedClick() -- Line: 3562
        -- upvalues: u430 (ref), u424 (ref), u431 (ref), Router (ref), u470 (ref), u428 (ref), finishTradeUpReveal (copy), u426 (ref), u429 (ref), u352 (copy), TradeUp2 (copy), UDim2_new_ret3 (copy), Title2 (copy), DataController (ref), LocalPlayer (ref), GetSkinDisplayName (ref), u427 (ref), Remotes (ref), clearContractSlots (copy), getContractSlotLabel (copy), TweenService (ref), setTradeUpContractState (copy)
        if u430 then
            if u424 and not u431 then
                u431 = true;
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u470 = u470 + 1;
                local u527 = u470;
                task.spawn(function() -- Line: 3375
                    -- upvalues: u527 (copy), u470 (ref), u428 (ref), finishTradeUpReveal (ref)
                    while u527 == u470 and u428 == nil do
                        task.wait(0.05);
                    end;

                    if u527 ~= u470 then
                        return;
                    end;

                    finishTradeUpReveal(u428);
                end);
            end;

            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if not u424 then
            if #u352 == 10 then
                setTradeUpContractState();
            end;

            return;
        end;

        if u426 or (u429 or #u352 ~= 10) then
            return;
        end;

        u430 = true;
        u431 = false;
        TradeUp2.Options.Cancel.Visible = false;
        TradeUp2.Options.Proceed.Position = UDim2_new_ret3;
        Title2.Text = "SKIP";
        local v528 = DataController.Get(LocalPlayer, "Inventory") or {};
        local v529 = {};

        for _, v in ipairs(v528) do
            if v and v._id then
                v529[v._id] = v;
            end;
        end;

        local u530 = {};

        for _, v in ipairs(u352) do
            local v531 = v529[v];
            local v532;

            if v531 then
                v532 = GetSkinDisplayName.GetWeaponDisplayName(v531.Name, v531.NameTag);
                local v533 = GetSkinDisplayName(v531.Skin or "", true);

                if v533 ~= "" then
                    v532 = `{v532} | {v533}`;
                end;
            else
                v532 = "";
            end;

            table.insert(u530, v532);
        end;

        u428 = nil;
        u429 = false;
        u427 = u427 + 1;
        local v534 = `TradeUp_{u427}`;
        u426 = v534;
        Remotes.Store.TradeUpItems.Send({
            ItemIds = table.clone(u352),
            RequestId = v534
        });
        u470 = u470 + 1;
        local u535 = u470;
        clearContractSlots();
        task.spawn(function() -- Line: 3294
            -- upvalues: getContractSlotLabel (ref), u530 (copy), u535 (copy), u470 (ref), Router (ref), u428 (ref), TradeUp2 (ref), GetSkinDisplayName (ref), TweenService (ref), finishTradeUpReveal (ref)
            for i = 1, 10 do
                local v536 = getContractSlotLabel(i);
                local v537 = u530[i] or "";
                local v538;

                if v536 then
                    v538 = i;

                    for i2 = 1, utf8.len(v537) or #v537 do
                        task.wait(0.06);

                        if u535 ~= u470 then
                            return;
                        end;

                        local utf8_offset_ret = utf8.offset(v537, i2 + 1);
                        local v539;

                        if utf8_offset_ret then
                            v539 = string.sub(v537, 1, utf8_offset_ret - 1);
                        else
                            v539 = v537;
                        end;

                        v536.Text = v539;
                        Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                        local _ = i2;
                    end;
                else
                    v538 = i;
                end;
            end;

            while u535 == u470 and u428 == nil do
                task.wait(0.05);
            end;

            if u535 ~= u470 then
                return;
            end;

            local v540 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

            if v540 then
                v540 = v540:FindFirstChild("Received");
            end;

            if not (v540 and v540:IsA("TextLabel")) then
                v540 = nil;
            end;

            local v541 = u428;
            local v542;

            if v541 then
                v542 = GetSkinDisplayName.GetWeaponDisplayName(v541.Name, v541.NameTag);
                local v543 = GetSkinDisplayName(v541.Skin or "", true);

                if v543 ~= "" then
                    v542 = `{v542} | {v543}`;
                end;
            else
                v542 = "";
            end;

            if v540 then
                for i = 1, utf8.len(v542) or #v542 do
                    task.wait(0.06);

                    if u535 ~= u470 then
                        return;
                    end;

                    local utf8_offset_ret = utf8.offset(v542, i + 1);
                    local v544;

                    if utf8_offset_ret then
                        v544 = string.sub(v542, 1, utf8_offset_ret - 1);
                    else
                        v544 = v542;
                    end;

                    v540.Text = v544;
                    Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                    local _ = i;
                end;
            end;

            task.wait(0.1);

            if u535 ~= u470 then
                return;
            end;

            local Approved = TradeUp2.TradeContainer.Contract:FindFirstChild("Approved");

            if Approved and Approved:IsA("ImageLabel") then
                Approved.Size = UDim2.fromScale(0.65, 0.65);
                Approved.ImageTransparency = 0.85;
                Approved.Visible = true;
                Router.broadcastRouter("RunInterfaceSound", "TradeUp Approved");

                local function v547(p545: number, p546: table) -- Line: 3345
                    -- upvalues: TweenService (ref), Approved (copy)
                    return TweenService:Create(Approved, TweenInfo.new(p545, Enum.EasingStyle.Linear), p546);
                end;

                local v548 = {};
                local v549 = {
                    ImageTransparency = 0,
                    Size = UDim2.fromScale(0.35, 0.35)
                };
                local v550 = TweenService:Create(Approved, TweenInfo.new(0.2, Enum.EasingStyle.Linear), v549);
                local v551 = {
                    Size = UDim2.fromScale(0.365, 0.365)
                };
                v548[1], v548[2], v548[3] = v550, TweenService:Create(Approved, TweenInfo.new(0.03, Enum.EasingStyle.Linear), v551), v547(0.03, {
    Size = UDim2.fromScale(0.35, 0.35)
});

                for _, v in ipairs(v548) do
                    v:Play();
                    v.Completed:Wait();

                    if u535 ~= u470 then
                        return;
                    end;
                end;
            end;

            task.wait(1.25);

            if u535 ~= u470 then
                return;
            end;

            finishTradeUpReveal(u428);
        end);
    end;

    Proceed.MouseButton1Click:Connect(handleTradeUpProceedClick);
    Proceed.Activated:Connect(function(p552) -- Line: 1170
        -- upvalues: handleTradeUpProceedClick (copy)
        if p552 and p552.UserInputType == Enum.UserInputType.Gamepad1 then
            handleTradeUpProceedClick();
        end;
    end);
    animateTradeUpOption(Cancel);
    Cancel.Selectable = true;

    local function handleTradeUpCancelClick() -- Line: 3622
        -- upvalues: u430 (ref), Router (ref), u470 (ref), u429 (ref), u352 (copy), u353 (ref), setTradeUpItemSelectionState (copy), renderTradeUp (ref)
        if u430 then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u470 = u470 + 1;

        if u429 then
            table.clear(u352);
            u353 = nil;
        end;

        setTradeUpItemSelectionState();
        renderTradeUp();
    end;

    Cancel.MouseButton1Click:Connect(handleTradeUpCancelClick);
    Cancel.Activated:Connect(function(p553) -- Line: 1170
        -- upvalues: handleTradeUpCancelClick (copy)
        if p553 and p553.UserInputType == Enum.UserInputType.Gamepad1 then
            handleTradeUpCancelClick();
        end;
    end);
    Remotes.Store.TradeUpCompleted.Listen(function(p554) -- Line: 3640
        -- upvalues: u426 (ref), DataController (ref), LocalPlayer (ref), u429 (ref), u428 (ref)
        local v555;

        if p554 and typeof(p554.RequestId) == "string" then
            v555 = p554.RequestId;
        else
            v555 = nil;
        end;

        if not u426 or v555 ~= u426 then
            return;
        end;

        u426 = nil;
        DataController.ApplyInventoryDelta(LocalPlayer, { p554.InventoryItem }, p554.DeletedItemIds);
        u429 = true;
        u428 = p554.InventoryItem;
    end);
    Remotes.Store.TradeUpDenied.Listen(function(p556) -- Line: 3655
        -- upvalues: u426 (ref), u470 (ref), u430 (ref), u431 (ref), TradeUp2 (copy), u486 (ref)
        local v557;

        if p556 and typeof(p556.RequestId) == "string" then
            v557 = p556.RequestId;
        else
            v557 = nil;
        end;

        if v557 and (u426 and v557 ~= u426) then
            return;
        end;

        u426 = nil;
        u470 = u470 + 1;
        u430 = false;
        u431 = false;

        if TradeUp2.Visible then
            u486(false);
        end;
    end);
    ActivateButton(TradeUp);
    TradeUp.Selectable = true;

    local function u558() -- Line: 3671
        -- upvalues: u486 (ref), Router (ref)
        u486(true);
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end;

    TradeUp.MouseButton1Click:Connect(u558);
    TradeUp.Activated:Connect(function(p559) -- Line: 1170
        -- upvalues: u558 (copy)
        if p559 and p559.UserInputType == Enum.UserInputType.Gamepad1 then
            u558();
        end;
    end);
    u22 = (function() -- Line: 3677, Name: setupTradeUpTopBar
        -- upvalues: u20 (ref), u349 (ref), Router (ref), BindSortDropdownFocus (ref), u350 (ref), u357 (ref), renderTradeUpContainer (copy), u342 (copy), BindSearchTap (ref), TradeUp2 (copy), SetSearchTokens (ref), u351 (copy)
        local Top2 = u20.Frame.TradeUp.Top;
        local Weapon = Top2.Weapon;
        local Click = Weapon.Click;
        local DropdownContent2 = Weapon.DropdownContent;
        local Title3 = Weapon.Container.Left.Title;
        local v560 = u20.Frame.Right.Top.Filter.DropdownContent.Scroll:Clone();
        DropdownContent2.Scroll:Destroy();
        v560.Parent = DropdownContent2;

        for _, child in v560:GetChildren() do
            if child:IsA("TextButton") then
                child.Frame.BackgroundTransparency = child.Name == u349 and 0 or 1;
            end;
        end;

        local function setDropdownOpen(p561: boolean) -- Line: 3694
            -- upvalues: DropdownContent2 (copy)
            local v562 = DropdownContent2;

            if not v562 then
                return;
            end;

            v562.Visible = p561;
            v562.Active = p561;
            local Scroll = v562:FindFirstChild("Scroll");

            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = p561;
                Scroll.Active = p561;
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

        Click.Activated:Connect(function() -- Line: 3702
            -- upvalues: DropdownContent2 (copy), Router (ref)
            local v563 = not DropdownContent2.Visible;
            local v564 = DropdownContent2;

            if v564 then
                v564.Visible = v563;
                v564.Active = v563;
                local Scroll = v564:FindFirstChild("Scroll");

                if Scroll and Scroll:IsA("GuiObject") then
                    Scroll.Visible = v563;
                    Scroll.Active = v563;
                end;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);
        BindSortDropdownFocus(DropdownContent2, Click, function() -- Line: 3707
            -- upvalues: u349 (ref), Click (copy)
            return u349 or Click.Frame.TextLabel.Text;
        end, "UI.Inventory.TradeUpSortFocusDeferred");
        local ReverseSort2 = Weapon.Container.Left.ReverseSort;
        ReverseSort2.Selectable = true;
        ReverseSort2.Activated:Connect(function() -- Line: 3714
            -- upvalues: u350 (ref), ReverseSort2 (copy), u357 (ref), renderTradeUpContainer (ref), Router (ref)
            u350 = not u350;
            local v565 = u350;
            local v566 = ReverseSort2:FindFirstChildOfClass("ImageLabel");

            if v566 then
                v566.Rotation = v565 and 180 or 0;
            end;

            u357 = true;
            renderTradeUpContainer();
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);

        for _, v in u342 do
            local u567 = DropdownContent2.Scroll:FindFirstChild(v);

            if u567 and u567:IsA("TextButton") then
                u567.Selectable = true;

                local function u569() -- Line: 3727
                    -- upvalues: Router (ref), u349 (ref), v (copy), u357 (ref), Title3 (copy), DropdownContent2 (copy), u567 (copy), renderTradeUpContainer (ref)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    u349 = v;
                    u357 = true;
                    Title3.Text = v;

                    for _, child in ipairs(DropdownContent2.Scroll:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.Frame.BackgroundTransparency = child == u567 and 0 or 1;
                        end;
                    end;

                    renderTradeUpContainer();
                    local v568 = DropdownContent2;

                    if not v568 then
                        return;
                    end;

                    v568.Visible = false;
                    v568.Active = false;
                    local Scroll = v568:FindFirstChild("Scroll");

                    if Scroll and Scroll:IsA("GuiObject") then
                        Scroll.Visible = false;
                        Scroll.Active = false;
                    end;
                end;

                u567.MouseButton1Click:Connect(u569);
                u567.Activated:Connect(function(p570) -- Line: 1170
                    -- upvalues: u569 (copy)
                    if p570 and p570.UserInputType == Enum.UserInputType.Gamepad1 then
                        u569();
                    end;
                end);
            end;
        end;

        local Title4 = Top2.Search.Container.Title;
        BindSearchTap(Top2.Search, Title4);
        Title4:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 3747
            -- upvalues: TradeUp2 (ref), SetSearchTokens (ref), u351 (ref), Title4 (copy), renderTradeUpContainer (ref)
            if not TradeUp2.Visible then
                return;
            end;

            SetSearchTokens(u351, Title4.Text);
            renderTradeUpContainer();
        end);

        return {
            setDropdownOpen = setDropdownOpen,
            searchTextBox = Title4
        };
    end)();
    u20.Frame.TradeUp.Top.TradeUp.Visible = false;
    u486(false);
    clearContractSlots();
    clearContractHeaderFields();
    task.spawn(function() -- Line: 3774
        -- upvalues: TradeUp2 (copy), ContentProvider (ref), u21 (ref)
        local v571 = {};
        local v572 = {};

        for _, descendant in ipairs(TradeUp2.TradeContainer.Contract:GetDescendants()) do
            if (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) and (descendant.Image ~= "" and not v571[descendant.Image]) then
                v571[descendant.Image] = true;
                table.insert(v572, descendant.Image);
            end;
        end;

        if #v572 == 0 then
            return;
        end;

        ContentProvider:PreloadAsync(v572);
        local Frame3 = Instance.new("Frame");
        Frame3.Name = "TradeUpContractImageWarmup";
        Frame3.BackgroundTransparency = 1;
        Frame3.Size = UDim2.fromOffset(1, 1);
        Frame3.Position = UDim2.fromOffset(0, 0);

        for _, v in ipairs(v572) do
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
        u21.Menu.Top:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3813
            -- upvalues: u424 (ref), u21 (ref)
            if u424 and u21.Menu.Top.Visible then
                u21.Menu.Top.Visible = false;
            end;
        end);
    end;

    Router.observerRouter("ResetInventoryToGrid", function() -- Line: 3821
        -- upvalues: u486 (ref)
        u486(false);
    end);
    Title:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 3826
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

    local function handleInventoryClosed() -- Line: 3835
        -- upvalues: u19 (ref), u486 (ref), u17 (ref), Title (copy), u351 (copy), u352 (copy), u353 (ref), u22 (ref), UpdateInventoryTemplates (ref)
        local v573 = u19;

        if v573 then
            v573.Visible = false;
            v573.Active = false;
            local Scroll = v573:FindFirstChild("Scroll");

            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = false;
                Scroll.Active = false;
            end;
        end;

        u486(false);
        table.clear(u17);
        Title.Text = "";
        table.clear(u351);
        table.clear(u352);
        u353 = nil;

        if u22 then
            u22.setDropdownOpen(false);
            u22.searchTextBox.Text = "";
        end;

        UpdateInventoryTemplates();
    end;

    u20:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3857
        -- upvalues: syncInventoryUpdate (ref), u20 (ref), Profiler (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), u30 (ref), u24 (ref), u8 (ref), u1 (ref), ReportViewedItems (ref), MenuState (ref), handleInventoryClosed (copy)
        syncInventoryUpdate();

        if u20.Visible then
            Profiler.mark("UI.Inventory.ApplyCurrentSort");

            if u20 and u20.Visible then
                u2 = GetSortedInventoryData();
                u2 = ApplyFilterToSortedData(u2);
                UpdateInventoryTemplates();
            end;

            local v574 = u30;
            u30 = nil;
            local v575 = u24[u8];
            local v576;

            if v574 == nil or (v575 == nil or v575._id ~= v574) then
                v576 = false;
            else
                v576 = u20.Ignore.ItemNotification.Visible;
            end;

            local v577 = #u24;

            if not (v576 or (v577 <= 0 or u8 >= v577)) then
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
    MenuState.OnInspectStateChanged:Connect(function(p578: boolean) -- Line: 3888
        -- upvalues: u20 (ref), handleInventoryClosed (copy)
        if p578 then
            return;
        end;

        task.defer(function() -- Line: 3892
            -- upvalues: u20 (ref), handleInventoryClosed (ref)
            if not u20.Visible then
                handleInventoryClosed();
            end;
        end);
    end);

    if u21 and u21.Menu then
        u21.Menu:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3901
            -- upvalues: u21 (ref), u20 (ref), handleInventoryClosed (copy), syncInventoryUpdate (ref)
            if not u21.Menu.Visible and u20.Visible then
                u20.Visible = false;
                handleInventoryClosed();
                syncInventoryUpdate();
            end;
        end);
    end;

    u20.Frame.Right.Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 3911
        -- upvalues: OnScrollPositionChanged (ref)
        OnScrollPositionChanged();
    end);
    u20.Frame.Right.Container:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- Line: 3915
        -- upvalues: Profiler (ref), OnScrollPositionChanged (ref)
        Profiler.defer("UI.Inventory.ScrollDeferred", OnScrollPositionChanged);
    end);
end;

function u1.Start() -- Line: 3922
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), UserInputService (copy), u20 (ref), GuiService (copy), Router (copy), DismissItemNotifications (copy), CloseButtonRegistry (copy), u18 (ref), u1 (copy), syncInventoryUpdate (copy), Skins (copy), u27 (copy), u23 (ref), RefreshNewInventoryItems (copy), Remotes (copy), u16 (ref), Store (copy), u13 (ref), u9 (ref), u11 (ref), u2 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy), u4 (ref), UpdateStatusFrame (copy), MenuState (copy), u24 (copy), u8 (ref), CollectionService (copy), RegisterCategoryFilterRow (copy), u39 (ref), ActivateButton (copy), u36 (copy), u37 (copy)
    debug.setmemorycategory("UI.Inventory.Start");
    Profiler.mark("UI.Inventory.Start.Begin");
    DataController.WaitForDataLoaded(LocalPlayer);
    Profiler.mark("UI.Inventory.Start.DataLoaded");
    Profiler.mark("UI.Inventory.Start.InitialCategory");
    local u579 = nil;

    local function setupGamepadNavigation() -- Line: 3931
        -- upvalues: Profiler (ref), u579 (ref), UserInputService (ref), u20 (ref), GuiService (ref), Router (ref), DismissItemNotifications (ref), CloseButtonRegistry (ref), u18 (ref)
        Profiler.mark("UI.Inventory.SetupGamepadNavigation");

        if u579 then
            u579:Disconnect();
        end;

        u579 = UserInputService.InputBegan:Connect(function(p580: userdata, p581: boolean) -- Line: 3938
            -- upvalues: u20 (ref), GuiService (ref), Router (ref), DismissItemNotifications (ref), CloseButtonRegistry (ref), u18 (ref)
            if p580.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            if not (u20 and (u20.Visible and not p581)) then
                return;
            end;

            local KeyCode = p580.KeyCode;
            local SelectedObject = GuiService.SelectedObject;
            local v582 = u20 and u20.Ignore.ItemNotification and u20.Ignore.ItemNotification.Visible;

            if KeyCode == Enum.KeyCode.ButtonB then
                if v582 then
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

            local v583 = KeyCode == Enum.KeyCode.DPadUp;
            local v584;

            if v583 or KeyCode == Enum.KeyCode.DPadDown then
                v584 = SelectedObject and SelectedObject:IsA("GuiButton") and (v583 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown);
            else
                v584 = false;
            end;

            if v582 then
                if v584 and (v584:IsDescendantOf(u20.Ignore.ItemNotification.Holder) and v584.Visible) then
                    GuiService.SelectedObject = v584;
                end;

                return;
            end;

            local v585 = u18 and u18.Visible;

            if v585 then
                if SelectedObject then
                    SelectedObject = SelectedObject:IsDescendantOf(u18);
                end;
            else
                SelectedObject = v585;
            end;

            if v584 and (not SelectedObject or v584:IsDescendantOf(u18)) then
                GuiService.SelectedObject = v584;
            end;
        end);
    end;

    local u586 = nil;

    local function setupSelectionProtection() -- Line: 4006
        -- upvalues: Profiler (ref), u586 (ref), GuiService (ref), u20 (ref), u1 (ref), u18 (ref)
        Profiler.mark("UI.Inventory.SetupSelectionProtection");

        if u586 then
            u586:Disconnect();
        end;

        u586 = GuiService.Changed:Connect(function(p587) -- Line: 4012
            -- upvalues: u20 (ref), GuiService (ref), Profiler (ref), u1 (ref), u18 (ref)
            if p587 ~= "SelectedObject" then
                return;
            end;

            local v588 = u20 and u20.Ignore.ItemNotification;

            if v588 and v588.Visible then
                local Holder = v588.Holder;
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
        u20:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4051
            -- upvalues: u20 (ref), Profiler (ref), u579 (ref), UserInputService (ref), GuiService (ref), Router (ref), DismissItemNotifications (ref), CloseButtonRegistry (ref), u18 (ref), u586 (ref), u1 (ref)
            if u20.Visible then
                Profiler.mark("UI.Inventory.SetupGamepadNavigation");

                if u579 then
                    u579:Disconnect();
                end;

                u579 = UserInputService.InputBegan:Connect(function(p589: userdata, p590: boolean) -- Line: 3938
                    -- upvalues: u20 (ref), GuiService (ref), Router (ref), DismissItemNotifications (ref), CloseButtonRegistry (ref), u18 (ref)
                    if p589.UserInputType ~= Enum.UserInputType.Gamepad1 then
                        return;
                    end;

                    if not (u20 and (u20.Visible and not p590)) then
                        return;
                    end;

                    local KeyCode = p589.KeyCode;
                    local SelectedObject = GuiService.SelectedObject;
                    local v591 = u20 and u20.Ignore.ItemNotification and u20.Ignore.ItemNotification.Visible;

                    if KeyCode == Enum.KeyCode.ButtonB then
                        if v591 then
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

                    local v592 = KeyCode == Enum.KeyCode.DPadUp;
                    local v593;

                    if v592 or KeyCode == Enum.KeyCode.DPadDown then
                        v593 = SelectedObject and SelectedObject:IsA("GuiButton") and (v592 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown);
                    else
                        v593 = false;
                    end;

                    if v591 then
                        if v593 and (v593:IsDescendantOf(u20.Ignore.ItemNotification.Holder) and v593.Visible) then
                            GuiService.SelectedObject = v593;
                        end;

                        return;
                    end;

                    local v594 = u18 and u18.Visible;

                    if v594 then
                        if SelectedObject then
                            SelectedObject = SelectedObject:IsDescendantOf(u18);
                        end;
                    else
                        SelectedObject = v594;
                    end;

                    if v593 and (not SelectedObject or v593:IsDescendantOf(u18)) then
                        GuiService.SelectedObject = v593;
                    end;
                end);
                Profiler.mark("UI.Inventory.SetupSelectionProtection");

                if u586 then
                    u586:Disconnect();
                end;

                u586 = GuiService.Changed:Connect(function(p595) -- Line: 4012
                    -- upvalues: u20 (ref), GuiService (ref), Profiler (ref), u1 (ref), u18 (ref)
                    if p595 ~= "SelectedObject" then
                        return;
                    end;

                    local v596 = u20 and u20.Ignore.ItemNotification;

                    if v596 and v596.Visible then
                        local Holder = v596.Holder;
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
                    Profiler.defer("UI.Inventory.AutoSelectDeferred", function() -- Line: 4057
                        -- upvalues: GuiService (ref), u20 (ref)
                        local v597 = 0;

                        while v597 < 5 do
                            task.wait(0.1);
                            v597 = v597 + 1;

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
                if u579 then
                    u579:Disconnect();
                    u579 = nil;
                end;

                if u586 then
                    u586:Disconnect();
                    u586 = nil;
                end;
            end;
        end);
    end;

    syncInventoryUpdate();
    Skins.OnItemStockSchemasUpdated:Connect(function(p598) -- Line: 4105
        -- upvalues: Profiler (ref), DataController (ref), LocalPlayer (ref), u1 (ref)
        Profiler.mark("UI.Inventory.ItemStockSchemasUpdated");
        local v599 = DataController.Get(LocalPlayer, "Inventory");
        u1.UpdateTemplates(v599);
    end);
    DataController.CreateListener(LocalPlayer, "New Inventory Items", function(p600) -- Line: 4112
        -- upvalues: Profiler (ref), u27 (ref), u23 (ref), RefreshNewInventoryItems (ref)
        Profiler.mark("UI.Inventory.NewInventoryItemsChanged");

        if type(p600) ~= "table" then
            return;
        end;

        local os_clock_ret = os.clock();

        for i, v in u27 do
            if os_clock_ret - v >= 10 then
                u27[i] = nil;
            end;
        end;

        local v601 = {};

        for _, v in ipairs(p600) do
            if not u27[v] then
                table.insert(v601, v);
            end;
        end;

        u23 = v601;
        RefreshNewInventoryItems();
    end);
    Remotes.Store.CaseOpenDenied.Listen(function(p602) -- Line: 4137
        -- upvalues: u16 (ref), Store (ref), u13 (ref), Router (ref)
        local v603;

        if p602 and typeof(p602.RequestId) == "string" then
            v603 = p602.RequestId;
        else
            v603 = nil;
        end;

        local v604;

        if v603 then
            v604 = u16 == v603;
        else
            v604 = v603;
        end;

        if v604 and (not v603 or u16 == v603) then
            if u16 then
                Store.ClearPendingOpenCaseRequest(u16);
            end;

            u13 = false;
            u16 = nil;
        end;

        if v604 and (p602 and p602.Reason == "RateLimited") then
            local v605 = (tonumber(p602.RetryAfterMs) or 0) / 1000;
            local v606 = v605 <= 0 and "Quick open is rate limited. Please wait a moment and try again." or string.format("Quick open is rate limited. Wait %.1fs and try again.", v605);
            Router.broadcastRouter("CreateMenuNotification", "Error", v606);
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Inventory", function(p607) -- Line: 4152
        -- upvalues: Profiler (ref), u1 (ref), RefreshNewInventoryItems (ref), u9 (ref), u20 (ref), u11 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), u18 (ref), u4 (ref)
        Profiler.mark("UI.Inventory.InventoryChanged");
        u1.UpdateInventory(p607);
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

        if u18 and (u18.Visible and (u4 and (u4._id and type(p607) == "table"))) then
            local _id = u4._id;
            local v608 = nil;

            for _, v in ipairs(p607) do
                if v._id == _id then
                    v608 = v;
                    break;
                end;
            end;

            if v608 then
                u4 = v608;
                u1.SetupInformationFrame(v608);
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 4180
        -- upvalues: Profiler (ref), u20 (ref), UpdateStatusFrame (ref)
        Profiler.mark("UI.Inventory.LoadoutChanged");

        if u20 and u20.Visible then
            for _, child in ipairs(u20.Frame.Right.Container:GetChildren()) do
                local v609 = child:IsA("ImageButton");

                if v609 then
                    if child.Name == "UIGridLayout" or (child.Name == "UIListLayout" or (child.Name == "UIPadding" or child.Name == "Title")) then
                        v609 = false;
                    else
                        v609 = child.Name ~= "Label";
                    end;
                end;

                if v609 then
                    UpdateStatusFrame(child, child.Name);
                end;
            end;
        end;
    end);
    MenuState.OnInspectStateChanged:Connect(function(p610: boolean) -- Line: 4193
        -- upvalues: Profiler (ref), u24 (ref), u20 (ref), u8 (ref), u1 (ref)
        if not p610 then
            Profiler.defer("UI.Inventory.InspectClosedDeferred", function() -- Line: 4195
                -- upvalues: u24 (ref), u20 (ref), u8 (ref), u1 (ref)
                local v611 = #u24;

                if u20.Visible and (v611 > 0 and u8 < v611) then
                    u1.NextInventoryItem(u8 + 1);
                end;
            end);
        end;
    end);
    Router.observerRouter("QuickOpenResolved", function(p612) -- Line: 4208
        -- upvalues: u16 (ref), Store (ref), u13 (ref)
        if typeof(p612) == "string" then
            if p612 and u16 ~= p612 then
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
        if v:IsDescendantOf(u20) then
            RegisterCategoryFilterRow(v);
        end;
    end;

    local Reset = u20.Frame.Right.Top:FindFirstChild("Reset");

    if Reset and Reset:IsA("GuiButton") then
        u39 = Reset;
        Reset.Visible = false;
        ActivateButton(Reset);
        Reset.Activated:Connect(function() -- Line: 4229
            -- upvalues: u36 (ref), u37 (ref), Profiler (ref), u20 (ref), u2 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref)
            table.clear(u36);

            for _, v in u37 do
                v.Check.Visible = false;
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
        end);
    end;

    for _, v in CollectionService:GetTagged("CategoryButtons") do
        v.Activated:Connect(function() -- Line: 4239
            -- upvalues: v (copy)
            v.Parent[`{v.Name}Filter`].Visible = not v.Parent[`{v.Name}Filter`].Visible;
            v.Icon.Rotation = v.Parent[`{v.Name}Filter`].Visible and 180 or 0;
        end);
    end;
end;

return u1;