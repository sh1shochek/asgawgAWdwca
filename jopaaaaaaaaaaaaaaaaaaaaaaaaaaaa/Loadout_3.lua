-- ReplicatedStorage.Interface.Screens.Menu.Loadout
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Loadout
-- Decompile time: 58.83 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local GamepadService = game:GetService("GamepadService");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation);
local Router = require(ReplicatedStorage.Database.Security.Router);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local ItemEquipment = require(ReplicatedStorage.Components.Common.ItemEquipment);
local ItemCard = require(ReplicatedStorage.Components.Common.ItemCard);
local CalculateGridRenderCount = require(ReplicatedStorage.Components.Common.CalculateGridRenderCount);
local UpdateStatusFrame = ItemEquipment.UpdateStatusFrame;
local IsEquippedOnTeam = ItemEquipment.IsEquippedOnTeam;
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local UseItemFrame = require(script.Parent.UseItemFrame);
local script_ItemIcon = require(script.ItemIcon);
local Sort = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local WeaponCategories = require(ReplicatedStorage.Database.Custom.GameStats.WeaponCategories);
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber);
local u2 = "Counter-Terrorists";
local u3 = nil;
local u4 = "Newest";
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = false;
local u18 = nil;
local u19 = nil;
local u20 = false;
local u21 = false;
local u22 = false;
local u23 = nil;
local u24 = 0;
local u25 = 0;
local u26 = false;
local u27 = 0;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = {};
local u32 = {};
local u33 = 0;
local u34 = false;
local u35 = false;
local UDim2_fromScale_ret = UDim2.fromScale(0.2, 0.2);
local Vector2_new_ret = Vector2.new(0, 0);
local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u36 = {
    Pistol = "Pistols",
    SMG = "Mid Tier",
    Heavy = "Mid Tier",
    Rifle = "Rifles"
};
local u37 = {
    ["Incendiary Grenade"] = true,
    ["Decoy Grenade"] = true,
    ["Smoke Grenade"] = true,
    ["HE Grenade"] = true,
    Flashbang = true,
    Molotov = true
};
local u38 = {
    Charm = true,
    ["Charm Capsule"] = true,
    Sticker = true,
    ["Sticker Capsule"] = true,
    Grenade = true,
    Case = true,
    Package = true,
    Booth = true
};
local u39 = {
    Glove = "Equipped Gloves",
    Melee = "Equipped Melee",
    ["Zeus x27"] = "Equipped Zeus x27",
    Badge = "Equipped Badge",
    ["Music Kit"] = "Equipped Music Kit",
    Graffiti = "Equipped Graffiti"
};
local u40 = {
    ["Equipped Gloves"] = "Gloves",
    ["Equipped Melee"] = "Melee",
    ["Equipped Zeus x27"] = "Zeus",
    ["Equipped Badge"] = "Badge",
    ["Equipped Music Kit"] = "Music Kit",
    ["Equipped Graffiti"] = "Spray"
};
local u41 = { "Melee", "Gloves", "Zeus", "Badge", "Music Kit", "Spray" };
local u42 = { "Badge", "Gloves", "Melee", "Music Kit", "Spray", "Zeus" };
local u43 = {
    Melee = "Melee",
    Gloves = "Glove",
    Badge = "Badge",
    Zeus = "Zeus x27",
    ["Music Kit"] = "Music Kit",
    Spray = "Graffiti"
};
local u44 = {
    Weapon = true,
    Melee = true,
    Glove = true,
    ["Zeus x27"] = true,
    Badge = true,
    Charm = true
};

local function CanInspectItem(p45) -- Line: 217
    -- upvalues: u44 (copy)
    local v46;

    if p45 == nil then
        v46 = false;
    else
        v46 = u44[p45.Type] == true;
    end;

    return v46;
end;

local u47 = {
    Melee = "Knives",
    Gloves = "Gloves",
    Zeus = "Zeus x27",
    Badge = "Badges",
    ["Music Kit"] = "Music Kits",
    Spray = "Sprays"
};
local u48 = {
    Melee = "Melee",
    Gloves = "Glove"
};
local u49 = { "ButtonCT", "ButtonT" };
local u50 = {
    Terrorists = { "Glock-18" },
    ["Counter-Terrorists"] = { "USP-S", "P2000" }
};
local u51 = nil;

local function GetTeamFrame(p52: string) -- Line: 252
    -- upvalues: u51 (ref)
    local v53 = u51.Container.Teams:FindFirstChild(p52);
    local v54;

    if v53 then
        v54 = v53:IsA("Frame");
    else
        v54 = v53;
    end;

    local v55 = `[Loadout] Missing {p52} team panel`;
    assert(v54, v55);

    return v53;
end;

local function ClearFrame(p56: any, p57: table) -- Line: 258
    for _, child in ipairs(p56:GetChildren()) do
        if not table.find(p57, child.Name) then
            child:Destroy();
        end;
    end;
end;

local u58 = { "Charm", "Inspect", "ReplaceCT", "ReplaceT", "Unlock" };

local function GetVisibleInformationFrameButtons() -- Line: 271
    -- upvalues: u58 (copy), u30 (ref)
    local v59 = {};

    for _, v in u58 do
        local v60 = u30[v];

        if v60 and v60.Visible then
            table.insert(v59, v60);
        end;
    end;

    local QuickUnlock = u30:FindFirstChild("QuickUnlock");

    if QuickUnlock and QuickUnlock.Visible then
        table.insert(v59, QuickUnlock);
    end;

    return v59;
end;

local function HasAnyInformationFrameButton() -- Line: 286
    -- upvalues: u30 (ref), GetVisibleInformationFrameButtons (copy)
    local v61;

    if u30 == nil then
        v61 = false;
    else
        v61 = #GetVisibleInformationFrameButtons() > 0;
    end;

    return v61;
end;

local function ItemHasCharm(p62) -- Line: 290
    local Charm = p62.Charm;
    local v63;

    if Charm == nil or Charm == false then
        v63 = false;
    else
        v63 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
    end;

    return v63;
end;

local function FindWeaponSlotOnTeam(p64: string, p65: any, p66: string) -- Line: 295
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v67 = DataController.Get(LocalPlayer, "Loadout");
    local v68 = DataController.Get(LocalPlayer, "Inventory");

    if not (v67 and v68) then
        return nil;
    end;

    local v69 = v67[p65];

    if not (v69 and (v69.Loadout and v69.Loadout[p66])) then
        return nil;
    end;

    for i, v in ipairs(v69.Loadout[p66].Options) do
        if v and v ~= "" then
            local v70 = i;
            local v71 = v;

            for _, v2 in ipairs(v68) do
                if v2._id == v71 and v2.Name == p64 then
                    return v70;
                end;
            end;
        end;
    end;

    return nil;
end;

local function ReplaceItemOnTeam(p72, p73) -- Line: 320
    -- upvalues: GetWeaponProperties (copy), u36 (copy), FindWeaponSlotOnTeam (copy), Remotes (copy), u39 (copy)
    if p72.Type ~= "Weapon" then
        if p72.Type == "Melee" and (p72.Name == "CT Knife" and p73 == "Terrorists" or p72.Name == "T Knife" and p73 == "Counter-Terrorists") then
            return;
        end;

        local v74 = u39[p72.Type];

        if v74 then
            Remotes.Inventory.EquipSpecialItem.Send({
                Identifier = p72._id,
                Path = v74,
                Team = p73
            });
        end;

        return;
    end;

    local success, result = pcall(GetWeaponProperties, p72.Name);
    local v75;

    if success and (result and result.Type) then
        v75 = u36[result.Type];
    else
        v75 = nil;
    end;

    if not v75 then
        return;
    end;

    local v76 = FindWeaponSlotOnTeam(p72.Name, p73, v75) or 1;
    Remotes.Inventory.EquipLoadoutSkin.Send({
        Type = v75,
        Slot = v76 - 1,
        Team = p73,
        Identifier = p72._id
    });
end;

function u1.SetupInformationFrameNavigation() -- Line: 359
    -- upvalues: u30 (ref), GetVisibleInformationFrameButtons (copy)
    if not u30 then
        return;
    end;

    local v77 = GetVisibleInformationFrameButtons();
    table.sort(v77, function(p78, p79) -- Line: 365
        return p78.LayoutOrder < p79.LayoutOrder;
    end);

    for i, v in ipairs(v77) do
        v.NextSelectionUp = v77[i > 1 and i - 1 or #v77];
        v.NextSelectionDown = v77[i < #v77 and i + 1 or 1];
        v.NextSelectionLeft = nil;
        v.NextSelectionRight = nil;
    end;
end;

function u1.SelectFirstInformationFrameButton() -- Line: 377
    -- upvalues: u30 (ref), u1 (copy), GetVisibleInformationFrameButtons (copy), GuiService (copy)
    if not (u30 and u30.Visible) then
        return;
    end;

    u1.SetupInformationFrameNavigation();
    local v80 = GetVisibleInformationFrameButtons()[1];

    if v80 then
        GuiService.SelectedObject = v80;
    end;
end;

function u1.SetupInformationFrame(p81) -- Line: 390
    -- upvalues: Profiler (copy), u30 (ref), u44 (copy), GetWeaponProperties (copy), IsEquippedOnTeam (copy)
    Profiler.mark("UI.Loadout.SetupInformationFrame");
    local v82 = p81.Type == "Weapon";
    local v83 = p81.Type == "Melee";
    local v84 = p81.Type == "Glove";
    local v85 = p81.Type == "Badge";
    local v86 = p81.Type == "Zeus x27";
    local v87;

    if p81 == nil then
        v87 = false;
    else
        v87 = u44[p81.Type] == true;
    end;

    u30.Inspect.Visible = v87;

    if u30.Unlock then
        u30.Unlock.Visible = p81.Type == "Case" and true or p81.Type == "Package";
    end;

    if u30.Loadout then
        u30.Loadout.Visible = false;
    end;

    local QuickUnlock = u30:FindFirstChild("QuickUnlock");

    if QuickUnlock then
        QuickUnlock.Visible = false;
    end;

    local UnlockDivider = u30:FindFirstChild("UnlockDivider");

    if UnlockDivider then
        UnlockDivider.Visible = false;
    end;

    local v88 = v82 or (v86 or p81.Type == "Charm");

    if u30.Charm then
        u30.Charm.Visible = v88;
        local v89 = v88 and u30.Charm:FindFirstChildWhichIsA("TextLabel", true);

        if v89 then
            if p81.Type == "Charm" then
                v89.Text = "Attach to Weapon";
            else
                local Charm = p81.Charm;
                local v90;

                if Charm == nil or Charm == false then
                    v90 = false;
                else
                    v90 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
                end;

                v89.Text = v90 and "Detach Charm" or "Attach Charm";
            end;
        end;
    end;

    local u91 = false;
    local u92 = false;

    local function applyTeamRestriction(p93: string?) -- Line: 435
        -- upvalues: u91 (ref), u92 (ref)
        u91 = p93 == "Both" and true or p93 == "Counter-Terrorists";
        u92 = p93 == "Both" and true or p93 == "Terrorists";
    end;

    if v82 then
        local success, result = pcall(GetWeaponProperties, p81.Name);

        if success and result then
            local Team = result.Team;
            u91 = Team == "Both" and true or Team == "Counter-Terrorists";
            u92 = Team == "Both" and true or Team == "Terrorists";
        end;
    elseif v83 then
        if p81.Name == "T Knife" then
            u91 = false;
        else
            u91 = true;
        end;

        if p81.Name == "CT Knife" then
            u92 = false;
        else
            u92 = true;
        end;
    elseif v84 then
        local v94 = GetWeaponProperties(p81.Name);

        if v94 then
            local Team = v94.Team;
            u91 = Team == "Both" and true or Team == "Counter-Terrorists";
            u92 = Team == "Both" and true or Team == "Terrorists";
        end;
    elseif v85 or v86 then
        u91 = true;
        u92 = true;
    end;

    local v95 = IsEquippedOnTeam(p81._id, "Counter-Terrorists");
    local v96 = IsEquippedOnTeam(p81._id, "Terrorists");
    local v97 = v82 or (v83 or (v84 or (v85 or v86)));

    if u30.ReplaceCT then
        u30.ReplaceCT.Visible = v97 and u91 and not v95;
    end;

    if u30.ReplaceT then
        u30.ReplaceT.Visible = v97 and u92 and not v96;
    end;

    local v98 = {
        {
            dividerName = "CharmDivider",
            action = u30.Charm
        },
        {
            dividerName = "InspectDivider",
            action = u30.Inspect
        },
        {
            dividerName = "ReplaceCTDivider",
            action = u30.ReplaceCT
        },
        {
            dividerName = "ReplaceTDivider",
            action = u30.ReplaceT
        },
        {
            dividerName = "LoadoutDivider",
            action = u30.Loadout
        }
    };
    local v99 = {
        UnlockDivider = true
    };

    for _, v in ipairs(v98) do
        v99[v.dividerName] = true;
    end;

    for _, v in ipairs(v98) do
        local v100 = u30:FindFirstChild(v.dividerName);

        if v100 and v.action then
            local v101 = false;

            if v.action.Visible then
                local v102 = v;

                for _, child in ipairs(u30:GetChildren()) do
                    if not (v99[child.Name] or (child == v100 or (child == v102.action or not (child:IsA("Frame") or child:IsA("TextButton")))) or (child.LayoutOrder >= v100.LayoutOrder or not child.Visible)) then
                        v101 = true;
                        break;
                    end;
                end;
            end;

            v100.Visible = v101;
        end;
    end;
end;

local function PositionInformationFrame(p103: userdata?, p104: boolean?) -- Line: 508
    -- upvalues: u30 (ref), UserInputService (copy), Mouse (copy)
    local Parent = u30.Parent.Parent;
    local AbsolutePosition = Parent.AbsolutePosition;
    local AbsoluteSize = Parent.AbsoluteSize;
    local v105 = nil;
    local v106 = nil;

    if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 or p104 then
        if p103 then
            local AbsolutePosition2 = p103.AbsolutePosition;
            local AbsoluteSize2 = p103.AbsoluteSize;
            v105 = AbsolutePosition2.X + AbsoluteSize2.X / 2;
            v106 = AbsolutePosition2.Y + AbsoluteSize2.Y / 2;
        end;
    else
        v105 = Mouse.X;
        v106 = Mouse.Y;
    end;

    local v107, v108;

    if v105 and v106 then
        local v109 = (v105 - AbsolutePosition.X) / AbsoluteSize.X;
        v107 = (v106 - AbsolutePosition.Y) / AbsoluteSize.Y + u30.Size.Y.Scale / 2;

        if 1 - v109 >= u30.Size.X.Scale + 0.01 then
            v108 = v109 + u30.Size.X.Scale / 2 + 0.01;
        else
            v108 = v109 - u30.Size.X.Scale / 2 - 0.01;
        end;
    else
        v108 = 0.5;
        v107 = 0.5;
    end;

    u30.Position = UDim2.fromScale(v108, v107);
end;

local function ShowContextMenu(p110: any, p111, p112: userdata?, u113: boolean?) -- Line: 546
    -- upvalues: DataController (copy), LocalPlayer (copy), u28 (ref), u29 (ref), u30 (ref), Router (copy), u1 (copy), GetVisibleInformationFrameButtons (copy), PositionInformationFrame (copy), Profiler (copy)
    local v114 = DataController.Get(LocalPlayer, "Inventory");

    if v114 then
        for _, v in ipairs(v114) do
            if v._id == p110._id then
                p110 = v;
                break;
            end;
        end;
    end;

    u28 = p110._id;
    u29 = p112;

    if not u30 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    u1.SetupInformationFrame(p110);
    local v115;

    if u30 == nil then
        v115 = false;
    else
        v115 = #GetVisibleInformationFrameButtons() > 0;
    end;

    if not v115 then
        u30.Visible = false;
        u28 = nil;
        u29 = nil;

        return;
    end;

    if u113 then
        u30.Visible = true;
    else
        u30.Visible = not u30.Visible;
    end;

    if u30.Visible then
        PositionInformationFrame(p112, u113);
        Profiler.defer("UI.Loadout.InformationNavigationDeferred", function() -- Line: 588
            -- upvalues: u1 (ref), u113 (copy)
            u1.SetupInformationFrameNavigation();

            if u113 then
                u1.SelectFirstInformationFrameButton();
            end;
        end);

        return;
    end;

    u28 = nil;
    u29 = nil;
end;

local function HideContextMenu() -- Line: 602
    -- upvalues: u30 (ref), u28 (ref), u29 (ref)
    if u30 then
        u30.Visible = false;
    end;

    u28 = nil;
    u29 = nil;
end;

local function GetInventoryItemFromIdentifier(p116: string) -- Line: 613
    -- upvalues: DataController (copy), LocalPlayer (copy)
    for _, v in ipairs(DataController.Get(LocalPlayer, "Inventory") or {}) do
        if v._id == p116 then
            return v;
        end;
    end;

    return nil;
end;

local function GetCurrentInventoryItem() -- Line: 622
    -- upvalues: u28 (ref), GetInventoryItemFromIdentifier (copy)
    if u28 then
        return GetInventoryItemFromIdentifier(u28);
    end;

    return nil;
end;

local u117 = nil;
Collections.ObserveAvailableCollections(function(p118) -- Line: 629
    -- upvalues: u117 (ref)
    u117 = p118;
end);

local function IsWeaponValidForTeam(p119: string?, p120: any) -- Line: 635
    -- upvalues: GetWeaponProperties (copy)
    if not (p119 and (type(p119) == "string" and p119 ~= "")) then
        return false;
    end;

    local success, result = pcall(GetWeaponProperties, p119);

    if success then
        if result == nil or result.Team == nil then
            success = false;
        else
            success = result.Team == "Both" and true or result.Team == p120;
        end;
    end;

    return success;
end;

local function GetSortedLoadoutItemIds() -- Line: 647
    -- upvalues: DataController (copy), LocalPlayer (copy), Sort (copy), u4 (ref), u117 (ref), u38 (copy), u37 (copy), GetWeaponProperties (copy), u2 (ref), u3 (ref), u6 (ref), u43 (copy), u48 (copy), u7 (ref), u5 (ref)
    local v121 = DataController.Get(LocalPlayer, "Inventory");

    if not v121 then
        return {};
    end;

    local SortComparisonFunction = Sort.GetSortComparisonFunction(u4, LocalPlayer, function() -- Line: 653
        -- upvalues: u117 (ref)
        return u117;
    end);
    local v122 = {};
    local v123 = {};

    for _, v in ipairs(v121) do
        if v and (v._id and not (v122[v._id] or (u38[v.Type] or (u37[v.Name] or (not v.Name or type(v.Name) ~= "string"))))) then
            local success, result = pcall(GetWeaponProperties, v.Name);

            if success and (result and result.Team) then
                local Name = v.Name;
                local v124 = u2;
                local v125;

                if Name and (type(Name) == "string" and Name ~= "") then
                    local v126;
                    v125, v126 = pcall(GetWeaponProperties, Name);

                    if v125 then
                        if v126 == nil or v126.Team == nil then
                            v125 = false;
                        else
                            v125 = v126.Team == "Both" and true or v126.Team == v124;
                        end;
                    end;
                else
                    v125 = false;
                end;

                if v125 then
                    v122[v._id] = true;
                    table.insert(v123, v);
                end;
            else
                v122[v._id] = true;
                table.insert(v123, v);
            end;
        end;
    end;

    if u3 then
        v123 = {};

        for _, v in ipairs(v123) do
            if v.Type ~= "Case" and (v.Type ~= "Package" and (v.Type ~= "Charm Capsule" and (v.Type ~= "Sticker Capsule" and (v.Name and type(v.Name) == "string")))) then
                local success, result = pcall(GetWeaponProperties, v.Name);

                if success and (result and result.Type == u3) then
                    table.insert(v123, v);
                end;
            end;
        end;
    end;

    if u6 then
        local v127 = u43[u6.sidebarName];
        local v128 = u48[u6.sidebarName];
        local v129 = u6.teamKey == "CT" and "Counter-Terrorists" or "Terrorists";
        v123 = {};

        for _, v in ipairs(v123) do
            if v.Type == v127 then
                local success, result = pcall(GetWeaponProperties, v.Name);

                if not (v128 and (success and (result and (result.Class and result.Class ~= v128)))) then
                    local Name = v.Name;
                    local v130 = v129 == "Counter-Terrorists" and "T" or "CT";

                    if Name ~= `{v130} Knife` and Name ~= `{v130} Glove` then
                        local v131 = not (success and (result and result.Team));
                        local Name2 = v.Name;
                        local v132;

                        if Name2 and (type(Name2) == "string" and Name2 ~= "") then
                            local v133;
                            v132, v133 = pcall(GetWeaponProperties, Name2);

                            if v132 then
                                if v133 == nil or v133.Team == nil then
                                    v132 = false;
                                else
                                    v132 = v133.Team == "Both" and true or v133.Team == v129;
                                end;
                            end;
                        else
                            v132 = false;
                        end;

                        if v131 or v132 then
                            table.insert(v123, v);
                        end;
                    end;
                end;
            end;
        end;
    end;

    if u7 then
        v123 = {};

        for _, v in ipairs(v123) do
            if v.Name == u7.weaponName and (u7.skinName == nil and true or v.Skin == u7.skinName) then
                table.insert(v123, v);
            end;
        end;
    end;

    if SortComparisonFunction then
        if u5 then
            table.sort(v123, function(p134, p135) -- Line: 752
                -- upvalues: SortComparisonFunction (copy)
                local v136, v137 = SortComparisonFunction(p134, p135);

                if v137 then
                    return v136;
                end;

                return SortComparisonFunction(p135, p134);
            end);
        else
            table.sort(v123, SortComparisonFunction);
        end;
    end;

    local table_create_ret = table.create(#v123);

    for _, v in ipairs(v123) do
        table.insert(table_create_ret, v._id);
    end;

    return table_create_ret;
end;

local function CreateMissingItemTemplates(p138: userdata, p139: number, p140: number) -- Line: 777
    -- upvalues: u32 (ref), GetInventoryItemFromIdentifier (copy), u1 (copy)
    for i = p139, p140 do
        local v141 = u32[i];
        local v142;

        if v141 then
            v142 = GetInventoryItemFromIdentifier(v141);
        else
            v142 = v141;
        end;

        local v143;

        if v142 and not p138:FindFirstChild(v141) then
            u1.CreateItemTemplate(v142);
            v143 = i;
        else
            v143 = i;
        end;
    end;
end;

local function ApplySortedLayoutOrder(p144: userdata) -- Line: 787
    -- upvalues: u32 (ref)
    for _, child in ipairs(p144:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
            local v145 = child;

            for i, v in ipairs(u32) do
                if v == v145.Name then
                    v145.LayoutOrder = i;
                    break;
                end;
            end;
        end;
    end;
end;

local function RenderLoadoutTemplates() -- Line: 805
    -- upvalues: Profiler (copy), u51 (ref), u33 (ref), u32 (ref), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy)
    Profiler.mark("UI.Loadout.RenderLoadoutTemplates");

    if not u51 then
        return;
    end;

    local Container = u51.Container.List.Container;
    local math_min_ret = math.min(u33 + 25, #u32);
    CreateMissingItemTemplates(Container, u33 + 1, math_min_ret);
    u33 = math_min_ret;
    ApplySortedLayoutOrder(Container);
end;

local function OnLoadoutScrollPositionChanged() -- Line: 820
    -- upvalues: u51 (ref), u33 (ref), u32 (ref), Profiler (copy), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy)
    if not u51 then
        return;
    end;

    local Container = u51.Container.List.Container;
    local v146 = Container.AbsoluteCanvasSize.Y - Container.AbsoluteSize.Y;

    if v146 > 0 and (u33 < #u32 and v146 - Container.CanvasPosition.Y < 200) then
        Profiler.mark("UI.Loadout.RenderLoadoutTemplates");

        if not u51 then
            return;
        end;

        local Container2 = u51.Container.List.Container;
        local math_min_ret = math.min(u33 + 25, #u32);
        CreateMissingItemTemplates(Container2, u33 + 1, math_min_ret);
        u33 = math_min_ret;
        ApplySortedLayoutOrder(Container2);
    end;
end;

local function CalculateLoadoutInitialRenderCount() -- Line: 839
    -- upvalues: u51 (ref), CalculateGridRenderCount (copy)
    return not (u51 and u51.Visible) and 50 or CalculateGridRenderCount(u51.Container.List.Container);
end;

local function RenderInitialLoadoutTemplates() -- Line: 848
    -- upvalues: Profiler (copy), u51 (ref), u33 (ref), CalculateGridRenderCount (copy), u32 (ref), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy), u34 (ref)
    Profiler.mark("UI.Loadout.RenderInitialLoadoutTemplates");

    if not (u51 and u51.Visible) then
        return;
    end;

    local Container = u51.Container.List.Container;
    u33 = 0;
    local v147 = not (u51 and u51.Visible) and 50 or CalculateGridRenderCount(u51.Container.List.Container);
    local math_max_ret = math.max(v147, 50);
    local math_min_ret = math.min(math_max_ret, #u32);
    CreateMissingItemTemplates(Container, 1, math_min_ret);
    ApplySortedLayoutOrder(Container);
    u33 = math_min_ret;
    u34 = false;
end;

local function UpdateLoadoutTemplates() -- Line: 869
    -- upvalues: Profiler (copy), u51 (ref), u32 (ref), u33 (ref), u34 (ref), RenderInitialLoadoutTemplates (copy)
    Profiler.mark("UI.Loadout.UpdateLoadoutTemplates");

    if not u51 then
        return;
    end;

    local Container = u51.Container.List.Container;
    local v148 = {};

    for _, v in ipairs(u32) do
        v148[v] = true;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIPadding" and not v148[child.Name])) then
            child:Destroy();
        end;
    end;

    u33 = 0;
    u34 = true;

    if u51.Visible then
        RenderInitialLoadoutTemplates();
    end;
end;

local function RefreshSortedList() -- Line: 902
    -- upvalues: u51 (ref), u35 (ref), u34 (ref), u32 (ref), GetSortedLoadoutItemIds (copy), UpdateLoadoutTemplates (copy)
    if u51 and u51.Visible then
        u32 = GetSortedLoadoutItemIds();
        UpdateLoadoutTemplates();

        return;
    end;

    u35 = true;
    u34 = true;
end;

local function AnimateSortButton(p149: userdata, p150: boolean) -- Line: 915
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy)
    TweenService:Create(p149, TweenInfo_new_ret, {
        BackgroundTransparency = p150 and 0.85 or 1
    }):Play();
end;

local function FadeCategoryLabels(p151: userdata, p152: boolean) -- Line: 924
    -- upvalues: TweenService (copy)
    local TweenInfo_new_ret2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v153 = p152 and 0 or 1;

    for _, child in ipairs(p151:GetChildren()) do
        if child:IsA("Frame") and (child:FindFirstChild("Price") and child:FindFirstChild("WeaponName")) then
            local Price = child:FindFirstChild("Price");
            local WeaponName = child:FindFirstChild("WeaponName");
            TweenService:Create(Price, TweenInfo_new_ret2, {
                TextTransparency = v153
            }):Play();
            TweenService:Create(WeaponName, TweenInfo_new_ret2, {
                TextTransparency = v153
            }):Play();
        end;
    end;
end;

local function CloseAllDropdowns() -- Line: 945
    -- upvalues: u51 (ref)
    local DropdownContent = u51.Container.List.Top.Weapon.DropdownContent;
    u51.Container.List.Top.Filter.DropdownContent.Visible = false;
    DropdownContent.Visible = false;
end;

local function UpdateResetButtonVisibility() -- Line: 955
    -- upvalues: u51 (ref), u3 (ref), u6 (ref)
    local Reset = u51.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u51.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;
end;

local function CreateDropdownOption(p154: userdata, p155: string, p156: string, p157: number, p158: function) -- Line: 968
    -- upvalues: ReplicatedStorage (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local SortingTemplate = ReplicatedStorage.Assets.UI.Loadout:FindFirstChild("SortingTemplate");

    if not SortingTemplate then
        return nil;
    end;

    local u159 = SortingTemplate:Clone();
    u159.Name = p155;
    u159.LayoutOrder = p157;
    u159.BackgroundTransparency = 1;
    u159.Parent = p154;
    local Frame = u159:FindFirstChild("Frame");

    if Frame then
        local TextButton = Frame:FindFirstChild("TextButton");

        if TextButton then
            TextButton.Text = p156;
        end;

        Frame.BackgroundTransparency = 1;
        Frame.Active = false;
    end;

    u159.MouseEnter:Connect(function() -- Line: 999
        -- upvalues: u159 (copy), TweenService (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u159, TweenInfo_new_ret, {
            BackgroundTransparency = 0.85
        }):Play();
    end);
    u159.MouseLeave:Connect(function() -- Line: 1002
        -- upvalues: u159 (copy), TweenService (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u159, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        }):Play();
    end);
    u159.MouseButton1Click:Connect(p158);

    return u159;
end;

local function ClearDropdownOptions(p160: userdata) -- Line: 1012
    for _, child in ipairs(p160:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy();
        end;
    end;
end;

local function GetWeaponsInCategory(p161: string?) -- Line: 1022
    -- upvalues: DataController (copy), LocalPlayer (copy), u38 (copy), u37 (copy), GetWeaponProperties (copy)
    local v162 = DataController.Get(LocalPlayer, "Inventory");

    if not v162 then
        return {};
    end;

    local v163 = {};

    for _, v in ipairs(v162) do
        if not (u38[v.Type] or u37[v.Name]) then
            local success, result = pcall(GetWeaponProperties, v.Name);

            if success and (result and (not p161 or result.Type == p161)) then
                v163[v.Name] = true;
            end;
        end;
    end;

    local v164 = {};

    for i in pairs(v163) do
        table.insert(v164, i);
    end;

    table.sort(v164);

    return v164;
end;

local function GetLoadoutCategoryForWeapon(p165: string) -- Line: 1053
    -- upvalues: GetWeaponProperties (copy), u36 (copy)
    local success, result = pcall(GetWeaponProperties, p165);

    if success and (result and result.Type) then
        return u36[result.Type];
    end;

    return nil;
end;

local function IsValidStarterPistol(p166: string, p167: any) -- Line: 1063
    -- upvalues: u50 (copy)
    local v168 = u50[p167];

    if v168 then
        return table.find(v168, p166) ~= nil;
    end;

    return false;
end;

local function IsMouseOverPlayerFrame(p169) -- Line: 1071
    -- upvalues: u51 (ref), PlayerGui (copy)
    local Teams = u51.Container.Teams;
    local GuiObjectsAtPosition = PlayerGui:GetGuiObjectsAtPosition(p169.X, p169.Y);

    for _, v in ipairs(GuiObjectsAtPosition) do
        if v.Name ~= "DragIcon" and (v == Teams or v:IsDescendantOf(Teams)) then
            return true;
        end;
    end;

    return false;
end;

local function CreateDragIcon(p170) -- Line: 1088
    -- upvalues: GetResolvedSkinInformation (copy), Skins (copy), UDim2_fromScale_ret (copy)
    local v171 = GetResolvedSkinInformation(p170.Name, p170.Skin);

    if not v171 then
        return nil;
    end;

    local v172 = Skins.GetWearImageForFloat(v171, p170.Float or 0.9999) or v171.imageAssetId or "";
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DragIcon";
    ImageLabel.Size = UDim2_fromScale_ret;
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = v172;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.ZIndex = 100;
    ImageLabel.Active = false;

    return ImageLabel;
end;

local function CleanupPendingDrag() -- Line: 1115
    -- upvalues: u16 (ref), u14 (ref), u15 (ref), u17 (ref), u18 (ref)
    if u16 then
        u16:Disconnect();
        u16 = nil;
    end;

    u14 = nil;
    u15 = nil;
    u17 = false;
    u18 = nil;
end;

local u173 = {
    ["Counter-Terrorists"] = Color3.fromHex("5B9BFF"),
    Terrorists = Color3.fromHex("E5B84C")
};
local TweenInfo_new_ret2 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u174 = {};
local u175 = {};

local function AddDropOverlay(p176: userdata?, p177: boolean) -- Line: 1151
    -- upvalues: u173 (copy), u2 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), u175 (copy), u174 (copy)
    if not (p176 and p176:IsA("GuiObject")) then
        return;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = p177 and "DropHighlight" or "DropDim";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BorderSizePixel = 0;
    Frame.Active = false;
    Frame.Selectable = false;
    Frame.Interactable = false;
    Frame.ZIndex = 50;

    if p177 then
        local v178 = u173[u2] or u173["Counter-Terrorists"];
        Frame.BackgroundColor3 = v178;
        Frame.BackgroundTransparency = 0.85;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.Color = v178;
        UIStroke.Thickness = 2;
        UIStroke.Parent = Frame;
        local v179 = TweenService:Create(UIStroke, TweenInfo_new_ret2, {
            Transparency = 0.6
        });
        v179:Play();
        table.insert(u175, v179);
    else
        Frame.BackgroundColor3 = Color3.new(0, 0, 0);
        Frame.BackgroundTransparency = 0.45;
    end;

    Frame.Parent = p176;
    table.insert(u174, Frame);
end;

local function HideAllMoveFrames() -- Line: 1190
    -- upvalues: u175 (copy), u174 (copy)
    for _, v in u175 do
        v:Cancel();
    end;

    table.clear(u175);

    for _, v in u174 do
        v:Destroy();
    end;

    table.clear(u174);
end;

local function CleanupDrag() -- Line: 1204
    -- upvalues: u16 (ref), u14 (ref), u15 (ref), u17 (ref), u18 (ref), u13 (ref), u9 (ref), u8 (ref), u10 (ref), u11 (ref), u12 (ref), HideAllMoveFrames (copy), u26 (ref), u1 (copy)
    if u16 then
        u16:Disconnect();
        u16 = nil;
    end;

    u14 = nil;
    u15 = nil;
    u17 = false;
    u18 = nil;

    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    if u9 then
        u9:Destroy();
        u9 = nil;
    end;

    local v180 = u8;
    u8 = false;
    u10 = nil;
    u11 = nil;
    u12 = nil;
    HideAllMoveFrames();

    if v180 and not u26 then
        u1.RefreshSelectedWeapon();
    end;
end;

local u181 = nil;

local function ShowControllerClickShield() -- Line: 1239
    -- upvalues: u181 (ref), PlayerGui (copy)
    if u181 then
        return;
    end;

    local MainGui = PlayerGui:FindFirstChild("MainGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "LoadoutControllerClickShield";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = (not (MainGui and MainGui:IsA("ScreenGui")) and 0 or MainGui.DisplayOrder) + 1;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Sink";
    TextButton.Text = "";
    TextButton.BackgroundTransparency = 1;
    TextButton.AutoButtonColor = false;
    TextButton.Selectable = false;
    TextButton.Active = true;
    TextButton.Size = UDim2.fromScale(1, 1);
    TextButton.Parent = ScreenGui;
    ScreenGui.Parent = PlayerGui;
    u181 = ScreenGui;
end;

local function HideControllerClickShield() -- Line: 1265
    -- upvalues: u181 (ref), u21 (ref)
    local u182 = u181;

    if not u182 then
        return;
    end;

    task.delay(0.25, function() -- Line: 1270
        -- upvalues: u181 (ref), u182 (copy), u21 (ref)
        if u181 == u182 and not u21 then
            u181 = nil;
            u182:Destroy();
        end;
    end);
end;

local function EnableVirtualCursor(u183: userdata?) -- Line: 1286
    -- upvalues: u21 (ref), GuiService (copy), GamepadNavigation (copy), GamepadService (copy), ShowControllerClickShield (copy)
    if u21 then
        return;
    end;

    u21 = true;
    GuiService.AutoSelectGuiEnabled = false;
    GuiService.SelectedObject = nil;

    if u183 then
        GamepadNavigation.ScrollIntoView(u183);
    end;

    pcall(function() -- Line: 1298
        -- upvalues: GamepadService (ref), u183 (copy)
        GamepadService:EnableGamepadCursor(u183);
    end);
    ShowControllerClickShield();
end;

local function DisableVirtualCursor() -- Line: 1306
    -- upvalues: u21 (ref), GamepadService (copy), GuiService (copy), u181 (ref)
    if not u21 then
        return;
    end;

    u21 = false;
    pcall(function() -- Line: 1311
        -- upvalues: GamepadService (ref)
        GamepadService:DisableGamepadCursor();
    end);
    GuiService.AutoSelectGuiEnabled = true;
    local u184 = u181;

    if not u184 then
        return;
    end;

    task.delay(0.25, function() -- Line: 1270
        -- upvalues: u181 (ref), u184 (copy), u21 (ref)
        if u181 == u184 and not u21 then
            u181 = nil;
            u184:Destroy();
        end;
    end);
end;

local function CleanupControllerHeld(p185: boolean?) -- Line: 1322
    -- upvalues: u23 (ref), CleanupDrag (copy), u19 (ref), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u181 (ref), HideAllMoveFrames (copy), GamepadNavigation (copy)
    local v186 = u23;
    CleanupDrag();
    u19 = nil;
    u23 = nil;
    u22 = false;

    if u21 then
        u21 = false;
        pcall(function() -- Line: 1311
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
        GuiService.AutoSelectGuiEnabled = true;
        local u187 = u181;

        if u187 then
            task.delay(0.25, function() -- Line: 1270
                -- upvalues: u181 (ref), u187 (copy), u21 (ref)
                if u181 == u187 and not u21 then
                    u181 = nil;
                    u187:Destroy();
                end;
            end);
        end;
    end;

    HideAllMoveFrames();

    if p185 and (v186 and GamepadNavigation.IsUsable(v186)) then
        GamepadNavigation.ScrollIntoView(v186);
        GuiService.SelectedObject = v186;
    end;
end;

local function GetSlotIndexInList(p188: userdata, p189: userdata, p190: string) -- Line: 1342
    -- upvalues: DataController (copy), LocalPlayer (copy), u2 (ref)
    local v191 = DataController.Get(LocalPlayer, "Loadout");

    if v191 then
        v191 = v191[u2];
    end;

    local v192 = v191 and v191.Loadout and v191.Loadout[p190];

    if v192 then
        for i, v in ipairs(v192.Options) do
            if v == p188.Name then
                return i;
            end;
        end;
    end;

    local v193 = 0;

    for _, child in ipairs(p189:GetChildren()) do
        if child:IsA("GuiObject") then
            v193 = v193 + 1;

            if child == p188 then
                return v193;
            end;
        end;
    end;

    return 1;
end;

local function GetLoadoutSlotInfo(p194: userdata) -- Line: 1370
    -- upvalues: GetSlotIndexInList (copy)
    local Parent = p194.Parent;

    if not (Parent and Parent:IsA("Frame")) then
        return nil, nil;
    end;

    local Parent2 = Parent.Parent;
    local v195;

    if Parent2 then
        if Parent2.Name == "List" then
            v195 = Parent2.Parent;
        else
            v195 = false;
        end;
    else
        v195 = Parent2;
    end;

    if not (v195 and v195:IsA("Frame")) then
        return nil, nil;
    end;

    local Name = v195.Name;

    if Name == "Mid Tier" or (Name == "Pistols" or Name == "Rifles") then
        return Name, GetSlotIndexInList(Parent, Parent2, Name);
    end;

    return nil, nil;
end;

local function GetInventoryItemFromButton(p196: userdata) -- Line: 1396
    -- upvalues: GetInventoryItemFromIdentifier (copy)
    if p196 and p196:IsA("ImageButton") then
        return GetInventoryItemFromIdentifier(p196.Name);
    end;

    return nil;
end;

local function GetEquippedItemFromButton(p197: userdata) -- Line: 1402
    -- upvalues: GetLoadoutSlotInfo (copy), GetInventoryItemFromIdentifier (copy)
    local Parent = p197.Parent;

    if Parent and Parent:IsA("Frame") then
        local Name = Parent.Name;
        local v198, v199 = GetLoadoutSlotInfo(p197);

        if v198 and v199 then
            return GetInventoryItemFromIdentifier(Name), v198, v199;
        end;
    end;

    return nil, nil, nil;
end;

local u200 = { "Pistols", "Mid Tier", "Rifles" };

local function ShowGunSlotHighlights(p201: function) -- Line: 1422
    -- upvalues: u2 (ref), u51 (ref), u200 (copy), GetSlotIndexInList (copy), AddDropOverlay (copy)
    local v202 = u2 == "Counter-Terrorists" and "CT" or "T";
    local v203 = u51.Container.Teams:FindFirstChild(v202);
    local v204;

    if v203 then
        v204 = v203:IsA("Frame");
    else
        v204 = v203;
    end;

    local v205 = `[Loadout] Missing {v202} team panel`;
    assert(v204, v205);
    local Guns = v203:FindFirstChild("Guns");

    if not Guns then
        return;
    end;

    for _, v in u200 do
        local v206 = Guns:FindFirstChild(v);
        local v207;

        if v206 then
            v207 = v206:FindFirstChild("List");
        else
            v207 = v206;
        end;

        if v206 and v207 then
            local v208 = v;
            local v209 = false;

            for _, child in v207:GetChildren() do
                if child:IsA("Frame") and child:FindFirstChild("Button") then
                    local v210 = p201(v208, (GetSlotIndexInList(child, v207, v208)));
                    AddDropOverlay(child, v210);
                    v209 = v209 or v210;
                end;
            end;

            AddDropOverlay(v206:FindFirstChild("Title"), v209);
        end;
    end;
end;

local function GetEquipmentSlotForItem(p211) -- Line: 1454
    -- upvalues: u39 (copy), GetWeaponProperties (copy), u40 (copy), u2 (ref), u51 (ref)
    local v212 = u39[p211.Type];

    if not v212 then
        local success, success = pcall(GetWeaponProperties, p211.Name);

        if success then
            if success then
                success = success.Class;
            end;
        end;

        v212 = success == "Melee" and "Equipped Melee" or (success == "Glove" and "Equipped Gloves" or nil);
    end;

    if v212 then
        v212 = u40[v212];
    end;

    if not v212 then
        return nil;
    end;

    local v213 = u2 == "Counter-Terrorists" and "CT" or "T";
    local v214 = u51.Container.Teams:FindFirstChild(v213);
    local v215;

    if v214 then
        v215 = v214:IsA("Frame");
    else
        v215 = v214;
    end;

    local v216 = `[Loadout] Missing {v213} team panel`;
    assert(v215, v216);
    local Equipments = v214:FindFirstChild("Equipments");

    if Equipments then
        Equipments = Equipments:FindFirstChild(v212);
    end;

    if Equipments and Equipments:IsA("GuiObject") then
        return Equipments;
    end;

    return nil;
end;

local function ShowMoveFramesForItem(p217) -- Line: 1486
    -- upvalues: HideAllMoveFrames (copy), GetEquipmentSlotForItem (copy), u39 (copy), AddDropOverlay (copy), u2 (ref), u51 (ref), ShowGunSlotHighlights (copy), GetWeaponProperties (copy), u36 (copy), u50 (copy)
    HideAllMoveFrames();
    local v218 = GetEquipmentSlotForItem(p217);

    if u39[p217.Type] ~= nil and true or v218 ~= nil then
        AddDropOverlay(v218, true);
        local v219 = u2 == "Counter-Terrorists" and "CT" or "T";
        local v220 = u51.Container.Teams:FindFirstChild(v219);
        local v221;

        if v220 then
            v221 = v220:IsA("Frame");
        else
            v221 = v220;
        end;

        local v222 = `[Loadout] Missing {v219} team panel`;
        assert(v221, v222);
        AddDropOverlay(v220:FindFirstChild("Viewport"), true);
        ShowGunSlotHighlights(function() -- Line: 1495
            return false;
        end);

        return;
    end;

    local success, result = pcall(GetWeaponProperties, p217.Name);
    local u223;

    if success and (result and result.Type) then
        u223 = u36[result.Type];
    else
        u223 = nil;
    end;

    if not u223 then
        return;
    end;

    local Name = p217.Name;
    local v224 = u2;
    local u225;

    if Name and (type(Name) == "string" and Name ~= "") then
        local v226;
        u225, v226 = pcall(GetWeaponProperties, Name);

        if u225 then
            if v226 == nil or v226.Team == nil then
                u225 = false;
            else
                u225 = v226.Team == "Both" and true or v226.Team == v224;
            end;
        end;
    else
        u225 = false;
    end;

    local Name2 = p217.Name;
    local v227 = u50[u2];
    local u228;

    if v227 then
        u228 = table.find(v227, Name2) ~= nil;
    else
        u228 = false;
    end;

    ShowGunSlotHighlights(function(p229: string, p230: number) -- Line: 1508
        -- upvalues: u225 (copy), u223 (copy), u228 (copy)
        if not u225 or p229 ~= u223 then
            return false;
        end;

        local v231;

        if p229 == "Pistols" and p230 == 1 then
            v231 = not u228;
        else
            v231 = false;
        end;

        return not v231;
    end);
end;

local u232 = nil;

local function GetDropTargetCategory(p233) -- Line: 1526
    -- upvalues: u19 (ref), GetInventoryItemFromIdentifier (copy), u11 (ref), GetWeaponProperties (copy), u36 (copy), u51 (ref), PlayerGui (copy), GetSlotIndexInList (copy)
    local v234 = u19 and GetInventoryItemFromIdentifier(u19);
    local v235 = u11;

    if v235 then
        v234 = v235;
    elseif v234 then
        v234 = v234.Name;
    end;

    if not v234 then
        return nil, nil;
    end;

    local success, result = pcall(GetWeaponProperties, v234);
    local v236;

    if success and (result and result.Type) then
        v236 = u36[result.Type];
    else
        v236 = nil;
    end;

    if not v236 then
        return nil, nil;
    end;

    local Teams = u51.Container.Teams;
    local GuiObjectsAtPosition = PlayerGui:GetGuiObjectsAtPosition(p233.X, p233.Y);
    local v237 = nil;
    local v238 = false;

    for _, v in ipairs(GuiObjectsAtPosition) do
        if v.Name ~= "DragIcon" then
            v238 = (v == Teams or v:IsDescendantOf(Teams)) and true or v238;

            if not v237 then
                local v239 = v;

                while v239 and v239 ~= Teams do
                    local Parent = v239.Parent;

                    if Parent and Parent.Name == "List" then
                        local Parent2 = Parent.Parent;

                        if Parent2 and Parent2.Name == v236 then
                            v237 = GetSlotIndexInList(v239, Parent, v236);
                        end;

                        break;
                    end;

                    v239 = Parent;
                end;
            end;
        end;
    end;

    if v238 then
        return v236, v237;
    end;

    return nil, nil;
end;

local function GetCurrentCategoryOptions(p240: string) -- Line: 1579
    -- upvalues: DataController (copy), LocalPlayer (copy), u2 (ref)
    local v241 = DataController.Get(LocalPlayer, "Loadout");

    if v241 then
        v241 = v241[u2];
    end;

    if v241 and (v241.Loadout and v241.Loadout[p240]) then
        return v241.Loadout[p240].Options;
    end;

    return nil;
end;

local function IsItemEquippedInCategory(p242: string, p243: string) -- Line: 1588
    -- upvalues: DataController (copy), LocalPlayer (copy), u2 (ref)
    local v244 = ipairs;
    local v245 = DataController.Get(LocalPlayer, "Loadout");

    if v245 then
        v245 = v245[u2];
    end;

    local v246;

    if v245 and (v245.Loadout and v245.Loadout[p243]) then
        v246 = v245.Loadout[p243].Options;
    else
        v246 = nil;
    end;

    for i, v in v244(v246 or {}) do
        if v == p242 then
            return true, i;
        end;
    end;

    return false, nil;
end;

local function IsWeaponEquippedInCategory(p247: string, p248: string) -- Line: 1600
    -- upvalues: DataController (copy), LocalPlayer (copy), u2 (ref), GetInventoryItemFromIdentifier (copy)
    local v249 = DataController.Get(LocalPlayer, "Loadout");

    if v249 then
        v249 = v249[u2];
    end;

    local v250;

    if v249 and (v249.Loadout and v249.Loadout[p248]) then
        v250 = v249.Loadout[p248].Options;
    else
        v250 = nil;
    end;

    if not v250 then
        return false, nil, nil;
    end;

    for i, v in ipairs(v250) do
        if v and v ~= "" then
            local v251 = GetInventoryItemFromIdentifier(v);

            if v251 and v251.Name == p247 then
                return true, i, v;
            end;
        end;
    end;

    return false, nil, nil;
end;

local function RefreshSelectedWeaponIfIdle() -- Line: 1624
    -- upvalues: u8 (ref), u19 (ref), u1 (copy)
    if not (u8 or u19) then
        u1.RefreshSelectedWeapon();
    end;
end;

local function SendEquipRequest(p252: any, p253: table) -- Line: 1631
    -- upvalues: u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy)
    if u26 then
        return false;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u254 = u27;
    p252.Send(p253);
    task.delay(5, function() -- Line: 1640
        -- upvalues: u254 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u254 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);

    return true;
end;

local function EquipLoadoutSkin(p255: string, p256: number, p257: string) -- Line: 1651
    -- upvalues: Remotes (copy), u2 (ref), u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy)
    local v258 = {
        Type = p255,
        Slot = p256 - 1,
        Team = u2,
        Identifier = p257
    };

    if u26 then
        return false;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u259 = u27;
    Remotes.Inventory.EquipLoadoutSkin.Send(v258);
    task.delay(5, function() -- Line: 1640
        -- upvalues: u259 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u259 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);

    return true;
end;

local function SwapLoadoutSkins(p260: string, p261: number, p262: number) -- Line: 1660
    -- upvalues: Remotes (copy), u2 (ref), u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy)
    local v263 = {
        Type = p260,
        SlotOne = p261 - 1,
        SlotTwo = p262 - 1,
        Team = u2
    };

    if u26 then
        return false;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u264 = u27;
    Remotes.Inventory.SwapLoadoutSkins.Send(v263);
    task.delay(5, function() -- Line: 1640
        -- upvalues: u264 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u264 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);

    return true;
end;

local function EquipSpecialItem(p265: string, p266: string) -- Line: 1671
    -- upvalues: Remotes (copy), u2 (ref), u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy)
    local v267 = {
        Path = p265,
        Team = u2,
        Identifier = p266
    };

    if u26 then
        return false;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u268 = u27;
    Remotes.Inventory.EquipSpecialItem.Send(v267);
    task.delay(5, function() -- Line: 1640
        -- upvalues: u268 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u268 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);

    return true;
end;

local function GetSpecialItemPathByClass(p269: string) -- Line: 1680
    -- upvalues: GetWeaponProperties (copy)
    local success, success = pcall(GetWeaponProperties, p269);

    if success then
        if success then
            success = success.Class;
        end;
    end;

    return success == "Melee" and "Equipped Melee" or (success == "Glove" and "Equipped Gloves" or nil);
end;

local function u272() -- Line: 1691
    -- upvalues: u51 (ref), u19 (ref), u23 (ref), CleanupDrag (copy), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u181 (ref), HideAllMoveFrames (copy), GamepadNavigation (copy), CloseButtonRegistry (copy)
    if not (u51 and u51.Visible) then
        return;
    end;

    if u19 then
        local v270 = u23;
        CleanupDrag();
        u19 = nil;
        u23 = nil;
        u22 = false;

        if u21 then
            u21 = false;
            pcall(function() -- Line: 1311
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
            local u271 = u181;

            if u271 then
                task.delay(0.25, function() -- Line: 1270
                    -- upvalues: u181 (ref), u271 (copy), u21 (ref)
                    if u181 == u271 and not u21 then
                        u181 = nil;
                        u271:Destroy();
                    end;
                end);
            end;
        end;

        HideAllMoveFrames();

        if v270 and GamepadNavigation.IsUsable(v270) then
            GamepadNavigation.ScrollIntoView(v270);
            GuiService.SelectedObject = v270;
        end;

        CloseButtonRegistry.MarkUsed();
    end;
end;

local function ConnectGamepadPickUp(u273: userdata) -- Line: 1707
    -- upvalues: u19 (ref), u26 (ref), u25 (ref), u232 (ref)
    u273.Activated:Connect(function(p274) -- Line: 1708
        -- upvalues: u19 (ref), u26 (ref), u25 (ref), u232 (ref), u273 (copy)
        if p274 and (p274.UserInputType == Enum.UserInputType.Gamepad1 and not (u19 or (u26 or os.clock() - u25 <= 0.25))) then
            u232(u273);
        end;
    end);
end;

local function ConnectButtonActivation(p275: userdata, u276: function) -- Line: 1722
    p275.MouseButton1Click:Connect(u276);
    p275.Activated:Connect(function(p277) -- Line: 1724
        -- upvalues: u276 (copy)
        if p277 and p277.UserInputType == Enum.UserInputType.Gamepad1 then
            u276();
        end;
    end);
end;

function u1.HandleSpecialItemDrop() -- Line: 1734
    -- upvalues: u10 (ref), u12 (ref), u39 (copy), u11 (ref), GetWeaponProperties (copy), Remotes (copy), u2 (ref), u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy)
    if not (u10 and u12) then
        return;
    end;

    local v278 = u39[u12];

    if not v278 and u11 then
        local success, success = pcall(GetWeaponProperties, u11);

        if success then
            if success then
                success = success.Class;
            end;
        end;

        v278 = success == "Melee" and "Equipped Melee" or (success == "Glove" and "Equipped Gloves" or nil);
    end;

    if not v278 then
        return;
    end;

    local v279 = {
        Path = v278,
        Team = u2,
        Identifier = u10
    };

    if u26 then
        return;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u280 = u27;
    Remotes.Inventory.EquipSpecialItem.Send(v279);
    task.delay(5, function() -- Line: 1640
        -- upvalues: u280 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u280 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);
end;

function u1.HandleDrop(p281: string, p282: number?) -- Line: 1753
    -- upvalues: u10 (ref), u11 (ref), u2 (ref), GetWeaponProperties (copy), u36 (copy), DataController (copy), LocalPlayer (copy), u50 (copy), IsItemEquippedInCategory (copy), Remotes (copy), u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy), IsWeaponEquippedInCategory (copy)
    if not (u10 and u11) then
        return;
    end;

    local v283 = u11;
    local v284 = u2;
    local v285;

    if v283 and (type(v283) == "string" and v283 ~= "") then
        local v286;
        v285, v286 = pcall(GetWeaponProperties, v283);

        if v285 then
            if v286 == nil or v286.Team == nil then
                v285 = false;
            else
                v285 = v286.Team == "Both" and true or v286.Team == v284;
            end;
        end;
    else
        v285 = false;
    end;

    if not v285 then
        return;
    end;

    local success, result = pcall(GetWeaponProperties, u11);
    local v287;

    if success and (result and result.Type) then
        v287 = u36[result.Type];
    else
        v287 = nil;
    end;

    if v287 ~= p281 then
        return;
    end;

    local v288 = DataController.Get(LocalPlayer, "Loadout");

    if v288 then
        v288 = v288[u2];
    end;

    local v289;

    if v288 and (v288.Loadout and v288.Loadout[p281]) then
        v289 = v288.Loadout[p281].Options;
    else
        v289 = nil;
    end;

    if not v289 then
        return;
    end;

    local v290;

    if p281 == "Pistols" then
        local v291 = u11;
        local v292 = u50[u2];
        local v293;

        if v292 then
            v293 = table.find(v292, v291) ~= nil;
        else
            v293 = false;
        end;

        v290 = v293 and 1 or 2;
    else
        v290 = 1;
    end;

    local v294, v295 = IsItemEquippedInCategory(u10, p281);

    if v294 and v295 then
        if p282 and (v290 <= p282 and (p282 <= #v289 and v295 ~= p282)) then
            local v296 = {
                Type = p281,
                SlotOne = v295 - 1,
                SlotTwo = p282 - 1,
                Team = u2
            };

            if u26 then
                return;
            end;

            u26 = true;
            u27 = u27 + 1;
            local u297 = u27;
            Remotes.Inventory.SwapLoadoutSkins.Send(v296);
            task.delay(5, function() -- Line: 1640
                -- upvalues: u297 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
                if u297 ~= u27 or not u26 then
                    return;
                end;

                u26 = false;

                if not (u8 or u19) then
                    u1.RefreshSelectedWeapon();
                end;
            end);
        end;

        return;
    end;

    local v298, v299 = IsWeaponEquippedInCategory(u11, p281);

    if v298 and v299 then
        local v300 = {
            Type = p281,
            Slot = v299 - 1,
            Team = u2,
            Identifier = u10
        };

        if u26 then
            return;
        end;

        u26 = true;
        u27 = u27 + 1;
        local u301 = u27;
        Remotes.Inventory.EquipLoadoutSkin.Send(v300);
        task.delay(5, function() -- Line: 1640
            -- upvalues: u301 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
            if u301 ~= u27 or not u26 then
                return;
            end;

            u26 = false;

            if not (u8 or u19) then
                u1.RefreshSelectedWeapon();
            end;
        end);

        return;
    end;

    if p282 and p282 < v290 then
        return;
    end;

    if v290 <= #v289 then
        v290 = math.clamp(p282 or v290, v290, #v289);
    end;

    local v302 = {
        Type = p281,
        Slot = v290 - 1,
        Team = u2,
        Identifier = u10
    };

    if u26 then
        return;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u303 = u27;
    Remotes.Inventory.EquipLoadoutSkin.Send(v302);
    task.delay(5, function() -- Line: 1640
        -- upvalues: u303 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u303 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);
end;

local function StartItemDrag(p304) -- Line: 1814
    -- upvalues: CreateDragIcon (copy), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), ShowMoveFramesForItem (copy), u1 (copy), PlayerGui (copy), UserInputService (copy), Vector2_new_ret (copy), u13 (ref), RunServiceController (copy)
    local v305 = CreateDragIcon(p304);

    if not v305 then
        return false;
    end;

    u8 = true;
    u9 = v305;
    u10 = p304._id;
    u11 = p304.Name;
    u12 = p304.Type;
    ShowMoveFramesForItem(p304);
    u1.SetSelectedWeapon(p304, true);
    v305.Parent = PlayerGui:FindFirstChild("MainGui") or PlayerGui;
    local MouseLocation = UserInputService:GetMouseLocation();
    v305.Position = UDim2.fromOffset(MouseLocation.X + Vector2_new_ret.X, MouseLocation.Y + Vector2_new_ret.Y);
    u13 = RunServiceController.BindToRenderStep("UI.Loadout.DragIcon", function() -- Line: 1839
        -- upvalues: u9 (ref), UserInputService (ref), Vector2_new_ret (ref)
        if u9 then
            local MouseLocation2 = UserInputService:GetMouseLocation();
            u9.Position = UDim2.fromOffset(MouseLocation2.X + Vector2_new_ret.X, MouseLocation2.Y + Vector2_new_ret.Y);
        end;
    end);

    return true;
end;

local function BeginActualDrag(p306) -- Line: 1852
    -- upvalues: u16 (ref), u14 (ref), u15 (ref), u17 (ref), u18 (ref), u8 (ref), u19 (ref), StartItemDrag (copy)
    if u16 then
        u16:Disconnect();
        u16 = nil;
    end;

    u14 = nil;
    u15 = nil;
    u17 = false;
    u18 = nil;

    if u8 or u19 then
        return;
    end;

    StartItemDrag(p306);
end;

function u1.OnItemMouseDown(p307: string, p308: boolean?, p309: userdata?) -- Line: 1866
    -- upvalues: UserInputService (copy), u19 (ref), u25 (ref), u8 (ref), u14 (ref), u15 (ref), u17 (ref), u18 (ref), u16 (ref), RunServiceController (copy), GetInventoryItemFromIdentifier (copy), StartItemDrag (copy)
    local MouseLocation = UserInputService:GetMouseLocation();

    if u19 or os.clock() - u25 < 0.25 then
        return;
    end;

    if u8 or u14 then
        return;
    end;

    u14 = p307;
    u15 = MouseLocation;
    u17 = p308 or false;
    u18 = p309;
    u16 = RunServiceController.BindToRenderStep("UI.Loadout.PendingDrag", function() -- Line: 1887
        -- upvalues: u14 (ref), u15 (ref), u19 (ref), u16 (ref), u17 (ref), u18 (ref), UserInputService (ref), GetInventoryItemFromIdentifier (ref), u8 (ref), StartItemDrag (ref)
        if u14 and u15 then
            if u19 then
                if u16 then
                    u16:Disconnect();
                    u16 = nil;
                end;

                u14 = nil;
                u15 = nil;
                u17 = false;
                u18 = nil;

                return;
            end;

            if (UserInputService:GetMouseLocation() - u15).Magnitude >= 10 then
                local v310 = u14;

                if u16 then
                    u16:Disconnect();
                    u16 = nil;
                end;

                u14 = nil;
                u15 = nil;
                u17 = false;
                u18 = nil;

                if v310 then
                    v310 = GetInventoryItemFromIdentifier(v310);
                end;

                if v310 then
                    if u16 then
                        u16:Disconnect();
                        u16 = nil;
                    end;

                    u14 = nil;
                    u15 = nil;
                    u17 = false;
                    u18 = nil;

                    if not u8 then
                        if u19 then
                            return;
                        end;

                        StartItemDrag(v310);
                    end;
                end;
            end;
        end;
    end);
end;

function u1.OnItemClick(p311) -- Line: 1912
    -- upvalues: u6 (ref), u1 (copy)
    u6 = nil;
    u1.SortByWeapon(p311.Name);
end;

local function DropDraggedItem() -- Line: 1921
    -- upvalues: UserInputService (copy), GuiService (copy), u12 (ref), u39 (copy), u11 (ref), GetWeaponProperties (copy), IsMouseOverPlayerFrame (copy), u1 (copy), GetDropTargetCategory (copy)
    local MouseLocation = UserInputService:GetMouseLocation();
    local GuiInset = GuiService:GetGuiInset();
    local Vector2_new_ret2 = Vector2.new(MouseLocation.X - GuiInset.X, MouseLocation.Y - GuiInset.Y);
    local v312 = u12 and u39[u12];

    if not v312 and u11 then
        local success, result = pcall(GetWeaponProperties, u11);
        v312 = success and (result and (result.Class == "Melee" or result.Class == "Glove")) and true or v312;
    end;

    if v312 and IsMouseOverPlayerFrame(Vector2_new_ret2) then
        u1.HandleSpecialItemDrop();

        return;
    end;

    if not v312 then
        local v313, v314 = GetDropTargetCategory(Vector2_new_ret2);

        if v313 then
            u1.HandleDrop(v313, v314);
        end;
    end;
end;

function u1.EndDrag() -- Line: 1950
    -- upvalues: u14 (ref), u8 (ref), u17 (ref), u18 (ref), UserInputService (copy), u16 (ref), u15 (ref), GetInventoryItemFromIdentifier (copy), u1 (copy), ShowContextMenu (copy), DropDraggedItem (copy), CleanupDrag (copy)
    if not u14 or u8 then
        if not u8 then
            return;
        end;

        DropDraggedItem();
        CleanupDrag();

        return;
    end;

    local v315 = u14;
    local v316 = u17;
    local v317 = u18;
    local MouseLocation = UserInputService:GetMouseLocation();

    if u16 then
        u16:Disconnect();
        u16 = nil;
    end;

    u14 = nil;
    u15 = nil;
    u17 = false;
    u18 = nil;

    if v315 then
        v315 = GetInventoryItemFromIdentifier(v315);
    end;

    if not v315 then
        return;
    end;

    if v316 then
        u1.OnItemClick(v315);

        return;
    end;

    ShowContextMenu(v315, MouseLocation, v317, false);
end;

u232 = function(u318: userdata) -- Line: 1986
    -- upvalues: CleanupDrag (copy), GetInventoryItemFromIdentifier (copy), GetLoadoutSlotInfo (copy), u19 (ref), u23 (ref), u24 (ref), u22 (ref), u21 (ref), GuiService (copy), GamepadNavigation (copy), GamepadService (copy), ShowControllerClickShield (copy), StartItemDrag (copy), u181 (ref), HideAllMoveFrames (copy)
    CleanupDrag();
    local v319;

    if u318 and u318:IsA("ImageButton") then
        v319 = GetInventoryItemFromIdentifier(u318.Name);
    else
        v319 = nil;
    end;

    if not v319 then
        local Parent = u318.Parent;

        if Parent and Parent:IsA("Frame") then
            local Name = Parent.Name;
            local v320, v321 = GetLoadoutSlotInfo(u318);

            if v320 and v321 then
                v319 = GetInventoryItemFromIdentifier(Name);
            else
                v319 = nil;
            end;
        else
            v319 = nil;
        end;
    end;

    if not v319 then
        return;
    end;

    u19 = v319._id;
    u23 = u318;
    u24 = os.clock();
    u22 = false;

    if not u21 then
        u21 = true;
        GuiService.AutoSelectGuiEnabled = false;
        GuiService.SelectedObject = nil;

        if u318 then
            GamepadNavigation.ScrollIntoView(u318);
        end;

        pcall(function() -- Line: 1298
            -- upvalues: GamepadService (ref), u318 (copy)
            GamepadService:EnableGamepadCursor(u318);
        end);
        ShowControllerClickShield();
    end;

    if not StartItemDrag(v319) then
        local v322 = u23;
        CleanupDrag();
        u19 = nil;
        u23 = nil;
        u22 = false;

        if u21 then
            u21 = false;
            pcall(function() -- Line: 1311
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
            local u323 = u181;

            if u323 then
                task.delay(0.25, function() -- Line: 1270
                    -- upvalues: u181 (ref), u323 (copy), u21 (ref)
                    if u181 == u323 and not u21 then
                        u181 = nil;
                        u323:Destroy();
                    end;
                end);
            end;
        end;

        HideAllMoveFrames();

        if v322 and GamepadNavigation.IsUsable(v322) then
            GamepadNavigation.ScrollIntoView(v322);
            GuiService.SelectedObject = v322;
        end;
    end;
end;

local function u326() -- Line: 2009
    -- upvalues: u25 (ref), u8 (ref), DropDraggedItem (copy), u23 (ref), CleanupDrag (copy), u19 (ref), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u181 (ref), HideAllMoveFrames (copy), GamepadNavigation (copy)
    u25 = os.clock();

    if u8 then
        DropDraggedItem();
    end;

    local v324 = u23;
    CleanupDrag();
    u19 = nil;
    u23 = nil;
    u22 = false;

    if u21 then
        u21 = false;
        pcall(function() -- Line: 1311
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
        GuiService.AutoSelectGuiEnabled = true;
        local u325 = u181;

        if u325 then
            task.delay(0.25, function() -- Line: 1270
                -- upvalues: u181 (ref), u325 (copy), u21 (ref)
                if u181 == u325 and not u21 then
                    u181 = nil;
                    u325:Destroy();
                end;
            end);
        end;
    end;

    HideAllMoveFrames();

    if v324 and GamepadNavigation.IsUsable(v324) then
        GamepadNavigation.ScrollIntoView(v324);
        GuiService.SelectedObject = v324;
    end;
end;

local function InspectInventoryItem(p327) -- Line: 2021
    -- upvalues: u44 (copy), Router (copy), u30 (ref), u28 (ref), u29 (ref)
    local v328;

    if p327 == nil then
        v328 = false;
    else
        v328 = u44[p327.Type] == true;
    end;

    if not v328 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");

    if u30 then
        u30.Visible = false;
    end;

    u28 = nil;
    u29 = nil;
    Router.broadcastRouter("WeaponInspect", p327.Name, p327.Skin, p327.Float, p327.StatTrack, p327.NameTag, p327.Charm, p327.Stickers, p327.Type, p327.Pattern, p327._id, p327.Serial, p327.IsTradeable);
end;

function u1.CreateItemTemplate(p329) -- Line: 2046
    -- upvalues: Profiler (copy), GetResolvedSkinInformation (copy), ReplicatedStorage (copy), u51 (ref), ItemCard (copy), script_ItemIcon (copy), u1 (copy), UserInputService (copy), GetInventoryItemFromIdentifier (copy), ShowContextMenu (copy), u19 (ref), u26 (ref), u25 (ref), u232 (ref)
    Profiler.mark("UI.Loadout.CreateItemTemplate");
    local _id = p329._id;
    local v330 = GetResolvedSkinInformation(p329.Name, p329.Skin);

    if v330 then
        local u331 = ReplicatedStorage.Assets.UI.Inventory.ItemTemplate:Clone();
        u331.Name = _id;
        u331.Parent = u51.Container.List.Container;
        ItemCard.Fill(u331, p329, v330, false);
        local Icon = u331.ItemContent.Content.Icon;
        local v332 = script_ItemIcon.CreateIconDropShadow(Icon, script_ItemIcon.GetDropShadowImageForItem(p329, Icon.Image), u331.ItemContent.Content);
        local v333, v334 = script_ItemIcon.CreateIconHoverTweens(Icon, v332);
        u331.MouseEnter:Connect(v333);
        u331.MouseLeave:Connect(v334);
        u331.MouseButton1Down:Connect(function() -- Line: 2069
            -- upvalues: u1 (ref), _id (copy), u331 (copy)
            u1.OnItemMouseDown(_id, false, u331);
        end);
        u331.MouseButton2Click:Connect(function() -- Line: 2073
            -- upvalues: UserInputService (ref), GetInventoryItemFromIdentifier (ref), _id (copy), ShowContextMenu (ref), u331 (copy)
            local MouseLocation = UserInputService:GetMouseLocation();
            local v335 = GetInventoryItemFromIdentifier(_id);

            if v335 then
                ShowContextMenu(v335, MouseLocation, u331, false);
            end;
        end);
        u331.Selectable = true;
        u331.SelectionGained:Connect(v333);
        u331.SelectionLost:Connect(v334);
        u331.Activated:Connect(function(p336) -- Line: 1708
            -- upvalues: u19 (ref), u26 (ref), u25 (ref), u232 (ref), u331 (copy)
            if p336 and (p336.UserInputType == Enum.UserInputType.Gamepad1 and not (u19 or (u26 or os.clock() - u25 <= 0.25))) then
                u232(u331);
            end;
        end);
    end;
end;

function u1.CreateLoadoutTemplate(p337, p338, p339) -- Line: 2090
    -- upvalues: Profiler (copy), GetResolvedSkinInformation (copy), GetWeaponProperties (copy), ReplicatedStorage (copy), Rarities (copy), Skins (copy), GetSkinDisplayName (copy), script_ItemIcon (copy), u1 (copy), UserInputService (copy), GetInventoryItemFromIdentifier (copy), ShowContextMenu (copy), u173 (copy), u8 (ref), u19 (ref), u26 (ref), u25 (ref), u232 (ref), InspectInventoryItem (copy)
    Profiler.mark("UI.Loadout.CreateLoadoutTemplate");
    local _id = p338._id;
    local v340 = GetResolvedSkinInformation(p338.Name, p338.Skin);
    local success, result = pcall(GetWeaponProperties, p338.Name);
    local v341 = success and (result and result.Cost) or 0;

    if v340 then
        local u342 = ReplicatedStorage.Assets.UI.Loadout:FindFirstChild(p339 == "Counter-Terrorists" and "LoadoutTemplateCT" or "LoadoutTemplateT"):Clone();
        u342.Rarity.BackgroundColor3 = Rarities[v340.rarity].Color;
        u342.Parent = p337;
        u342.Name = _id;
        local v343 = Skins.GetWearImageForFloat(v340, p338.Float or 0.9999) or (v340.imageAssetId or "");
        u342.Content.Footer.Cost.Text = "$" .. tostring(v341);
        GetSkinDisplayName.ApplyNameLabel(u342.Content.Footer.Frame.WeaponName, GetSkinDisplayName.GetWeaponDisplayName(p338.Name, p338.NameTag), p338.NameTag);
        local SkinName = u342.Content.Footer.Frame.SkinName;
        SkinName.Text = GetSkinDisplayName(p338.Skin);
        local v344 = Rarities[v340.rarity];

        if v344 then
            local v345;

            if v340.rarity == "Forbidden" then
                v345 = Color3.fromRGB(200, 60, 60);
            else
                v345 = v344.Color;
            end;

            SkinName.TextColor3 = v345;
        end;

        u342.Content.Icon.Image = v343;
        local Icon = u342.Content.Icon;
        local v346 = script_ItemIcon.CreateIconDropShadow(Icon, script_ItemIcon.GetDropShadowImageForItem(p338, v343), u342.Content);
        local u347, u348 = script_ItemIcon.CreateIconHoverTweens(Icon, v346);
        u342.Button.MouseEnter:Connect(u347);
        u342.Button.MouseLeave:Connect(u348);
        u342.Button.MouseButton1Down:Connect(function() -- Line: 2140
            -- upvalues: u1 (ref), _id (copy), u342 (copy)
            u1.OnItemMouseDown(_id, true, u342);
        end);
        u342.Button.MouseButton2Click:Connect(function() -- Line: 2143
            -- upvalues: UserInputService (ref), GetInventoryItemFromIdentifier (ref), _id (copy), ShowContextMenu (ref), u342 (copy)
            local MouseLocation = UserInputService:GetMouseLocation();
            local v349 = GetInventoryItemFromIdentifier(_id);

            if v349 then
                ShowContextMenu(v349, MouseLocation, u342, false);
            end;
        end);
        local u350 = u342:FindFirstChildOfClass("UIStroke");
        local u351;

        if u350 then
            u351 = u350.Color;
        else
            u351 = u350;
        end;

        local u352 = u173[p339] or u173["Counter-Terrorists"];

        local function setCardLit(p353: boolean) -- Line: 2155
            -- upvalues: u8 (ref), u19 (ref), u350 (copy), u351 (copy), u352 (copy)
            if p353 and (u8 or u19) then
                return;
            end;

            if u350 and u351 then
                local v354;

                if p353 then
                    v354 = u352;
                else
                    v354 = u351;
                end;

                u350.Color = v354;
            end;
        end;

        u342.Button.MouseEnter:Connect(function() -- Line: 2164
            -- upvalues: GetInventoryItemFromIdentifier (ref), _id (copy), u1 (ref), u8 (ref), u19 (ref), u350 (copy), u351 (copy), u352 (copy)
            local v355 = GetInventoryItemFromIdentifier(_id);

            if v355 then
                u1.OnLoadoutItemHover(v355);
            end;

            if not u8 then
                if u19 then
                    return;
                end;

                if u350 and u351 then
                    u350.Color = u352;
                end;
            end;
        end);
        u342.Button.MouseLeave:Connect(function() -- Line: 2171
            -- upvalues: u350 (copy), u351 (copy)
            if u350 and u351 then
                u350.Color = u351;
            end;
        end);
        u342.Button.Selectable = true;
        u342.Button.SelectionGained:Connect(function() -- Line: 2176
            -- upvalues: GetInventoryItemFromIdentifier (ref), _id (copy), u1 (ref), u347 (copy), u8 (ref), u19 (ref), u350 (copy), u351 (copy), u352 (copy)
            local v356 = GetInventoryItemFromIdentifier(_id);

            if v356 then
                u1.OnLoadoutItemHover(v356);
            end;

            u347();

            if not u8 then
                if u19 then
                    return;
                end;

                if u350 and u351 then
                    u350.Color = u352;
                end;
            end;
        end);
        u342.Button.SelectionLost:Connect(function() -- Line: 2184
            -- upvalues: u348 (copy), u350 (copy), u351 (copy)
            u348();

            if u350 and u351 then
                u350.Color = u351;
            end;
        end);
        local Button = u342.Button;
        Button.Activated:Connect(function(p357) -- Line: 1708
            -- upvalues: u19 (ref), u26 (ref), u25 (ref), u232 (ref), Button (copy)
            if p357 and (p357.UserInputType == Enum.UserInputType.Gamepad1 and not (u19 or (u26 or os.clock() - u25 <= 0.25))) then
                u232(Button);
            end;
        end);
        local Inspect = u342:FindFirstChild("Inspect");

        if Inspect and Inspect:IsA("GuiButton") then
            local function u359() -- Line: 2193
                -- upvalues: u8 (ref), u19 (ref), u25 (ref), GetInventoryItemFromIdentifier (ref), _id (copy), InspectInventoryItem (ref)
                if u8 or (u19 or os.clock() - u25 < 0.25) then
                    return;
                end;

                local v358 = GetInventoryItemFromIdentifier(_id);

                if v358 then
                    InspectInventoryItem(v358);
                end;
            end;

            Inspect.MouseButton1Click:Connect(u359);
            Inspect.Activated:Connect(function(p360) -- Line: 1724
                -- upvalues: u359 (copy)
                if p360 and p360.UserInputType == Enum.UserInputType.Gamepad1 then
                    u359();
                end;
            end);
        end;
    end;
end;

function u1.PopulateWeaponDropdown() -- Line: 2208
    -- upvalues: u51 (ref), ClearDropdownOptions (copy), CreateDropdownOption (copy), u1 (copy), GetWeaponsInCategory (copy), u3 (ref)
    local Scroll = u51.Container.List.Top.Weapon.DropdownContent.Scroll;

    if not (Scroll and (Scroll:IsA("Frame") or Scroll:IsA("ScrollingFrame"))) then
        return;
    end;

    ClearDropdownOptions(Scroll);
    CreateDropdownOption(Scroll, "All", "All Weapons", 0, function() -- Line: 2219
        -- upvalues: u1 (ref), Scroll (copy)
        u1.SortByWeapon(nil);
        Scroll.Parent.Visible = false;
    end);
    local v361 = GetWeaponsInCategory(u3);

    for i, v in ipairs(v361) do
        CreateDropdownOption(Scroll, v, v, i, function() -- Line: 2227
            -- upvalues: u1 (ref), v (copy), Scroll (copy)
            u1.SortByWeapon(v);
            Scroll.Parent.Visible = false;
        end);
    end;
end;

function u1.SortByCategory(p362: string?) -- Line: 2236
    -- upvalues: u3 (ref), u7 (ref), u6 (ref), u51 (ref), u1 (copy), u35 (ref), u34 (ref), u32 (ref), GetSortedLoadoutItemIds (copy), UpdateLoadoutTemplates (copy)
    u3 = p362;
    u7 = nil;
    u6 = nil;
    u51.Container.List.Top.Filter.Container.Left.Title.Text = p362 or "All Categories";
    u1.PopulateWeaponDropdown();
    u51.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";
    local Reset = u51.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u51.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;

    if u51 and u51.Visible then
        u32 = GetSortedLoadoutItemIds();
        UpdateLoadoutTemplates();

        return;
    end;

    u35 = true;
    u34 = true;
end;

function u1.SortByWeapon(p363: string?, p364: string?) -- Line: 2252
    -- upvalues: u7 (ref), u6 (ref), u51 (ref), Sort (copy), u4 (ref), LocalPlayer (copy), u117 (ref), u35 (ref), u34 (ref), u32 (ref), GetSortedLoadoutItemIds (copy), UpdateLoadoutTemplates (copy), u3 (ref)
    u7 = p363 and ({
        weaponName = p363,
        skinName = p364
    } or nil) or nil;
    u6 = nil;
    u51.Container.List.Top.Weapon.Container.Left.Title.Text = p363 or "All Weapons";

    if Sort.GetSortComparisonFunction(u4, LocalPlayer, function() -- Line: 2259
        -- upvalues: u117 (ref)
        return u117;
    end) then
        if u51 and u51.Visible then
            u32 = GetSortedLoadoutItemIds();
            UpdateLoadoutTemplates();
        else
            u35 = true;
            u34 = true;
        end;
    end;

    local Reset = u51.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u51.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;
end;

function u1.SortBySkinMetadata(p365: string) -- Line: 2271
    -- upvalues: Profiler (copy), u4 (ref), u51 (ref), Sort (copy), LocalPlayer (copy), u117 (ref), u35 (ref), u34 (ref), u32 (ref), GetSortedLoadoutItemIds (copy), UpdateLoadoutTemplates (copy)
    Profiler.mark("UI.Loadout.SortBySkinMetadata");
    u4 = p365;
    u51.Container.List.Top.Filter.Container.Left.Title.Text = p365;

    if Sort.GetSortComparisonFunction(p365, LocalPlayer, function() -- Line: 2276
        -- upvalues: u117 (ref)
        return u117;
    end) then
        if not (u51 and u51.Visible) then
            u35 = true;
            u34 = true;

            return;
        end;

        u32 = GetSortedLoadoutItemIds();
        UpdateLoadoutTemplates();
    end;
end;

function u1.UpdateInventoryContainer() -- Line: 2286
    -- upvalues: Profiler (copy), u51 (ref), u35 (ref), u34 (ref), u19 (ref), GetInventoryItemFromIdentifier (copy), u23 (ref), CleanupDrag (copy), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u181 (ref), HideAllMoveFrames (copy), GamepadNavigation (copy), DataController (copy), LocalPlayer (copy), u28 (ref), u30 (ref), u29 (ref), u1 (copy), u4 (ref)
    Profiler.mark("UI.Loadout.UpdateInventoryContainer");

    if not u51 then
        return;
    end;

    if not u51.Visible then
        u35 = true;
        u34 = true;

        return;
    end;

    if u19 and not GetInventoryItemFromIdentifier(u19) then
        local v366 = u23;
        CleanupDrag();
        u19 = nil;
        u23 = nil;
        u22 = false;

        if u21 then
            u21 = false;
            pcall(function() -- Line: 1311
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
            local u367 = u181;

            if u367 then
                task.delay(0.25, function() -- Line: 1270
                    -- upvalues: u181 (ref), u367 (copy), u21 (ref)
                    if u181 == u367 and not u21 then
                        u181 = nil;
                        u367:Destroy();
                    end;
                end);
            end;
        end;

        HideAllMoveFrames();

        if v366 and GamepadNavigation.IsUsable(v366) then
            GamepadNavigation.ScrollIntoView(v366);
            GuiService.SelectedObject = v366;
        end;
    end;

    local v368 = DataController.Get(LocalPlayer, "Inventory");
    local v369 = {};

    for _, v in ipairs(v368) do
        if v and v._id then
            v369[v._id] = true;
        end;
    end;

    if u28 and not v369[u28] then
        if u30 then
            u30.Visible = false;
        end;

        u28 = nil;
        u29 = nil;
    end;

    for _, child in ipairs(u51.Container.List.Container:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIPadding" and not v369[child.Name])) then
            child:Destroy();
        end;
    end;

    u1.PopulateWeaponDropdown();
    u1.SortBySkinMetadata(u4);
end;

function u1.UpdateLoadoutContainer(p370) -- Line: 2332
    -- upvalues: Profiler (copy), u23 (ref), CleanupDrag (copy), u19 (ref), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u181 (ref), HideAllMoveFrames (copy), GamepadNavigation (copy), u2 (ref), u51 (ref), ClearFrame (copy), GetInventoryItemFromIdentifier (copy), u1 (copy)
    Profiler.mark("UI.Loadout.UpdateLoadoutContainer");
    local v371 = u23;
    CleanupDrag();
    u19 = nil;
    u23 = nil;
    u22 = false;

    if u21 then
        u21 = false;
        pcall(function() -- Line: 1311
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
        GuiService.AutoSelectGuiEnabled = true;
        local u372 = u181;

        if u372 then
            task.delay(0.25, function() -- Line: 1270
                -- upvalues: u181 (ref), u372 (copy), u21 (ref)
                if u181 == u372 and not u21 then
                    u181 = nil;
                    u372:Destroy();
                end;
            end);
        end;
    end;

    HideAllMoveFrames();

    if v371 and GamepadNavigation.IsUsable(v371) then
        GamepadNavigation.ScrollIntoView(v371);
        GuiService.SelectedObject = v371;
    end;

    local v373 = u2 == "Counter-Terrorists" and "CT" or "T";
    local v374 = u51.Container.Teams:FindFirstChild(v373);
    v374 = v374;
    local v375;

    if v374 then
        v375 = v374:IsA("Frame");
    else
        v375 = v374;
    end;

    local v376 = `[Loadout] Missing {v373} team panel`;
    assert(v375, v376);
    local Guns = v374:FindFirstChild("Guns");
    local SelectedObject = GuiService.SelectedObject;
    local v377 = nil;
    local u378 = nil;

    for _, v in ipairs({ "Mid Tier", "Pistols", "Rifles" }) do
        local List = Guns:FindFirstChild(v).List;

        if SelectedObject and SelectedObject:IsDescendantOf(List) then
            v377 = v;

            while SelectedObject.Parent and SelectedObject.Parent ~= List do
                SelectedObject = SelectedObject.Parent;
            end;

            u378 = SelectedObject.Name;
            break;
        end;
    end;

    for _, v in ipairs({ "Mid Tier", "Pistols", "Rifles" }) do
        local List = Guns:FindFirstChild(v).List;
        ClearFrame(List, { "UIListLayout", "Frame" });
        local v379 = p370[u2];
        local v380 = `[Loadout] Failed to get player team loadout for {u2}`;
        assert(v379, v380);
        local v381 = 0;

        for _, v2 in ipairs(v379.Loadout[v].Options) do
            local v382 = GetInventoryItemFromIdentifier(v2);

            if v382 then
                u1.CreateLoadoutTemplate(List, v382, u2);

                if List:FindFirstChild(v382._id) then
                    v381 = v381 + 1;
                end;
            end;
        end;

        local Title = Guns:FindFirstChild(v):FindFirstChild("Title");

        if Title then
            Title = Title:FindFirstChild("Count");
        end;

        if Title and Title:IsA("TextLabel") then
            Title.Text = `{v381} {v381 == 1 and "ITEM" or "ITEMS"}`;
        end;
    end;

    u1.RefreshSelectedWeapon();

    if v377 then
        local List = Guns:FindFirstChild(v377).List;
        task.defer(function() -- Line: 2392
            -- upvalues: GuiService (ref), GamepadNavigation (ref), u378 (ref), List (copy)
            if GuiService.SelectedObject ~= nil and GamepadNavigation.IsUsable(GuiService.SelectedObject) then
                return;
            end;

            local v383 = u378 and List:FindFirstChild(u378);

            if v383 then
                v383 = v383:FindFirstChild("Button");
            end;

            if not v383 then
                for _, child in List:GetChildren() do
                    v383 = child:IsA("Frame") and child:FindFirstChild("Button") or nil;

                    if v383 then
                        break;
                    end;
                end;
            end;

            if v383 and (v383:IsA("GuiObject") and GamepadNavigation.IsUsable(v383)) then
                GuiService.SelectedObject = v383;
            end;
        end);
    end;
end;

function u1.UpdateSidebarFrames(p384, p385) -- Line: 2415
    -- upvalues: Profiler (copy), u2 (ref), u51 (ref), u40 (copy), GetInventoryItemFromIdentifier (copy), GetResolvedSkinInformation (copy), Skins (copy), Rarities (copy)
    Profiler.mark("UI.Loadout.UpdateSidebarFrames");
    local v386 = p385 or u2;
    local v387 = v386 == "Counter-Terrorists" and "CT" or "T";
    local v388 = u51.Container.Teams:FindFirstChild(v387);
    local v389;

    if v388 then
        v389 = v388:IsA("Frame");
    else
        v389 = v388;
    end;

    local v390 = `[Loadout] Missing {v387} team panel`;
    assert(v389, v390);
    local Equipments = v388:FindFirstChild("Equipments");

    if not Equipments then
        return;
    end;

    local v391 = p384[v386];

    if not (v391 and v391.Equipped) then
        return;
    end;

    for i, v in pairs(u40) do
        local v392 = v391.Equipped[i];
        local v393 = Equipments:FindFirstChild(v);

        if v393 then
            local v394 = nil;
            local v395 = false;
            local v396;

            if v392 and v392 ~= "" then
                v396 = GetInventoryItemFromIdentifier(v392);

                if v396 then
                    local v397 = GetResolvedSkinInformation(v396.Name, v396.Skin);

                    if v397 then
                        local v398 = Skins.GetWearImageForFloat(v397, v396.Float or 0.9999) or (v397.imageAssetId or "");
                        v393.Container.Icon.Image = v398;
                        v393.Container.Icon.Visible = true;
                        v393.Rarity.BackgroundColor3 = Rarities[v397.rarity].Color;
                        v393.Rarity.Visible = true;
                        v395 = true;
                    end;
                else
                    v396 = v394;
                end;
            else
                v396 = v394;
            end;

            if not v395 then
                v393.Container.Icon.Visible = false;
                v393.Rarity.Visible = false;
            end;

            if v396 then
                v396 = v396._id;
            end;

            v393:SetAttribute("EquippedItemId", v396);
            v393:SetAttribute("SidebarName", v);
            v393:SetAttribute("TeamKey", v386 == "Counter-Terrorists" and "CT" or "T");
        end;
    end;
end;

local u399 = {};
local Color3_fromRGB_ret = Color3.fromRGB(200, 60, 60);
local u400 = {
    Glove = "Gloves",
    Melee = "Knife",
    Badge = "Badge",
    ["Music Kit"] = "Music Kit",
    Graffiti = "Spray",
    ["Zeus x27"] = "Zeus"
};
local u401 = {
    RIFLE = "Rifle",
    SNIPER = "Sniper",
    SMG = "SMG",
    PISTOL = "Pistol",
    HEAVY = "Heavy",
    MELEE = "Knife"
};

local function GetCurrentTeamKey() -- Line: 2512
    -- upvalues: u2 (ref)
    return u2 == "Counter-Terrorists" and "CT" or "T";
end;

local function ComputeWeaponStats(p402) -- Line: 2517
    if type(p402) ~= "table" or (type(p402.Spread) ~= "table" or type(p402.DamagePerPart) ~= "table") then
        return nil;
    end;

    local v403 = p402.FireModes and p402.FireModes.Primary;
    local v404 = v403 and v403.FireRate or p402.FireRate;
    local v405 = v403 and v403.Spread or p402.Spread;
    local Torso = p402.DamagePerPart.Torso;

    if type(v404) ~= "number" or (v404 <= 0 or (type(Torso) ~= "number" or type(p402.WalkSpeed) ~= "number")) then
        return nil;
    end;

    local v406 = p402.BulletsPerShot or 1;
    local v407 = v405.Range and (v405.Range.Min or 0) or 0;
    local v408 = v405.PerShot or 0;
    local v409 = {};
    local math_clamp_ret = math.clamp(Torso * (v406 <= 1 and 1 or v406 * 0.35) / 143, 0, 1);
    v409.Damage = math.sqrt(math_clamp_ret) * 100;
    v409.FireRate = math.clamp(60 / v404 / 900, 0, 1) * 100;
    v409.Accuracy = 100 / (1 + v407 * 0.6 + v408 * 0.1);
    v409.Mobility = math.clamp((p402.WalkSpeed - 10) / 10.2, 0, 1) * 100;

    for i, v in v409 do
        local math_round_ret = math.round(v);
        v409[i] = math.max(math_round_ret, 4);
    end;

    return v409;
end;

local function PaintWeaponDetails(p410: string, p411: any) -- Line: 2550
    -- upvalues: u51 (ref), GetResolvedSkinInformation (copy), GetWeaponProperties (copy), Rarities (copy), Color3_fromRGB_ret (copy), Skins (copy), GetSkinDisplayName (copy), u400 (copy), u401 (copy), WeaponCategories (copy), CommaNumber (copy), ComputeWeaponStats (copy)
    local v412 = u51.Container.Teams:FindFirstChild(p410);
    local v413;

    if v412 then
        v413 = v412:IsA("Frame");
    else
        v413 = v412;
    end;

    local v414 = `[Loadout] Missing {p410} team panel`;
    assert(v413, v414);
    local Viewport = v412:FindFirstChild("Viewport");

    if Viewport then
        Viewport = Viewport:FindFirstChild("Details");
    end;

    if not Viewport then
        return;
    end;

    Viewport.Visible = p411 ~= nil;

    if not p411 then
        return;
    end;

    local v415 = GetResolvedSkinInformation(p411.Name, p411.Skin);
    local success, result = pcall(GetWeaponProperties, p411.Name);

    if not success then
        result = nil;
    end;

    local v416;

    if v415 then
        v416 = Rarities[v415.rarity];
    else
        v416 = v415;
    end;

    local v417;

    if v415 and v415.rarity == "Forbidden" then
        v417 = Color3_fromRGB_ret;
    elseif v416 then
        v417 = v416.Color;
    else
        v417 = Rarities.Stock.Color;
    end;

    Viewport.Render.Image = v415 and (Skins.GetWearImageForFloat(v415, p411.Float or 0.9999) or (v415.imageAssetId or "")) or "";
    local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(p411.Name, p411.NameTag);

    if p411.StatTrack then
        WeaponDisplayName = "KillTrak™ " .. WeaponDisplayName;
    end;

    if p411.Type == "Melee" then
        WeaponDisplayName = "★ " .. WeaponDisplayName;
    end;

    GetSkinDisplayName.ApplyNameLabel(Viewport.WeaponName, WeaponDisplayName, p411.NameTag);
    Viewport.SkinLine.SkinName.Text = GetSkinDisplayName(p411.Skin);
    Viewport.SkinLine.SkinName.TextColor3 = v417;
    Viewport.SkinLine.Diamond.BackgroundColor3 = v417;
    local v418;

    if result then
        v418 = result.Class;
    else
        v418 = result;
    end;

    local v419 = u400[p411.Type] or (v418 == "Glove" and "Gloves" or (v418 == "Melee" and "Knife" or (u401[WeaponCategories.GetLabel(p411.Name)] or "Equipment")));
    local v420;

    if result then
        v420 = result.Cost;
    else
        v420 = result;
    end;

    local Meta = Viewport.Meta;

    if type(v420) == "number" and v420 > 0 then
        v419 = `{v419}  ·  ${CommaNumber(v420)}`;
    end;

    Meta.Text = v419;
    local v421;

    if p411.Type == "Weapon" then
        v421 = ComputeWeaponStats(result);
    else
        v421 = nil;
    end;

    Viewport.Stats.Visible = v421 ~= nil;
    Viewport.Divider.Visible = v421 ~= nil;

    if v421 then
        for i, v in v421 do
            local v422 = Viewport.Stats:FindFirstChild(i);

            if v422 then
                v422.Track.Fill.Size = UDim2.fromScale(v / 100, 1);
                v422.Value.Text = tostring(v);
            end;
        end;
    end;
end;

local function GetDefaultSelectedItem() -- Line: 2614
    -- upvalues: DataController (copy), LocalPlayer (copy), u2 (ref), GetInventoryItemFromIdentifier (copy)
    for _, v in { "Rifles", "Mid Tier", "Pistols" } do
        local v423 = DataController.Get(LocalPlayer, "Loadout");

        if v423 then
            v423 = v423[u2];
        end;

        local v424;

        if v423 and (v423.Loadout and v423.Loadout[v]) then
            v424 = v423.Loadout[v].Options;
        else
            v424 = nil;
        end;

        for _, v2 in v424 or {} do
            local v425;

            if v2 == "" then
                v425 = nil;
            else
                v425 = GetInventoryItemFromIdentifier(v2) or nil;
            end;

            if v425 then
                return v425;
            end;
        end;
    end;

    return nil;
end;

function u1.SetSelectedWeapon(p426: any, p427: boolean?) -- Line: 2632
    -- upvalues: u8 (ref), u19 (ref), u2 (ref), u399 (copy), PaintWeaponDetails (copy)
    if not p426 then
        return;
    end;

    if not p427 and (u8 or u19) then
        return;
    end;

    local v428 = u2 == "Counter-Terrorists" and "CT" or "T";

    if not p427 then
        u399[v428] = p426._id;
    end;

    PaintWeaponDetails(v428, p426);
end;

function u1.RefreshSelectedWeapon() -- Line: 2647
    -- upvalues: u2 (ref), u399 (copy), GetInventoryItemFromIdentifier (copy), IsEquippedOnTeam (copy), GetDefaultSelectedItem (copy), PaintWeaponDetails (copy)
    local v429 = u2 == "Counter-Terrorists" and "CT" or "T";
    local v430 = u399[v429];
    local v431;

    if v430 then
        v431 = GetInventoryItemFromIdentifier(v430);
    else
        v431 = v430;
    end;

    if not (v431 and IsEquippedOnTeam(v430, u2)) then
        v431 = GetDefaultSelectedItem();
        local v432;

        if v431 then
            v432 = v431._id;
        else
            v432 = v431;
        end;

        u399[v429] = v432;
    end;

    PaintWeaponDetails(v429, v431);
end;

function u1.OnLoadoutItemHover(p433) -- Line: 2658
    -- upvalues: u1 (copy)
    u1.SetSelectedWeapon(p433);
end;

local function SetupSidebarHoverEvents() -- Line: 2664
    -- upvalues: Profiler (copy), u51 (ref), u42 (copy), u31 (copy), u1 (copy), GetInventoryItemFromIdentifier (copy)
    Profiler.mark("UI.Loadout.SetupSidebarHoverEvents");
    local Teams = u51.Container.Teams;

    for _, v in ipairs({ "CT", "T" }) do
        local v434 = Teams:FindFirstChild(v);

        if v434 then
            local Equipments = v434:FindFirstChild("Equipments");

            if Equipments then
                local v435 = v;

                for _, v2 in ipairs(u42) do
                    local u436 = Equipments:FindFirstChild(v2);

                    if u436 then
                        local v437 = v435 .. "_" .. v2;
                        local v438 = v437 .. "_Selection";

                        for _, v3 in { v437, v438 } do
                            local v439 = u31[v3];

                            if v439 then
                                v439:Disconnect();
                            end;
                        end;

                        local function showEquippedItem() -- Line: 2696
                            -- upvalues: u436 (copy), u1 (ref), GetInventoryItemFromIdentifier (ref)
                            local Attribute = u436:GetAttribute("EquippedItemId");

                            if Attribute and Attribute ~= "" then
                                u1.SetSelectedWeapon((GetInventoryItemFromIdentifier(Attribute)));
                            end;
                        end;

                        u31[v437] = u436.MouseEnter:Connect(showEquippedItem);
                        u31[v438] = u436.SelectionGained:Connect(showEquippedItem);
                    end;
                end;
            end;
        end;
    end;
end;

local u440 = {
    ButtonCT = u173["Counter-Terrorists"],
    ButtonT = u173.Terrorists
};

local function UpdateTeamToggle(p441: string) -- Line: 2721
    -- upvalues: u440 (copy), u51 (ref)
    for i, v in u440 do
        local v442 = u51.Teams:FindFirstChild(i);

        if v442 and v442:IsA("GuiObject") then
            local v443 = i == `Button{p441}`;
            local InactiveDim = v442:FindFirstChild("InactiveDim");

            if not InactiveDim then
                InactiveDim = Instance.new("Frame");
                InactiveDim.Name = "InactiveDim";
                InactiveDim.BackgroundColor3 = Color3.new(0, 0, 0);
                InactiveDim.BackgroundTransparency = 0.45;
                InactiveDim.BorderSizePixel = 0;
                InactiveDim.Size = UDim2.fromScale(1, 1);
                InactiveDim.ZIndex = 20;
                InactiveDim.Interactable = false;
                InactiveDim.Parent = v442;
            end;

            InactiveDim.Visible = not v443;
            local ActiveBar = v442:FindFirstChild("ActiveBar");

            if not ActiveBar then
                ActiveBar = Instance.new("Frame");
                ActiveBar.Name = "ActiveBar";
                ActiveBar.BackgroundColor3 = v;
                ActiveBar.BorderSizePixel = 0;
                ActiveBar.AnchorPoint = Vector2.new(0.5, 1);
                ActiveBar.Position = UDim2.fromScale(0.5, 1);
                ActiveBar.Size = UDim2.new(1, 0, 0, 3);
                ActiveBar.ZIndex = 20;
                ActiveBar.Interactable = false;
                ActiveBar.Parent = v442;
            end;

            ActiveBar.Visible = v443;
        end;
    end;
end;

function u1.SelectTeam(p444: string) -- Line: 2760
    -- upvalues: Profiler (copy), u51 (ref), u2 (ref), UpdateTeamToggle (copy), u3 (ref), u7 (ref), u6 (ref), DataController (copy), LocalPlayer (copy), u1 (copy)
    Profiler.mark("UI.Loadout.SelectTeam");
    local CT = u51.Container.Teams:FindFirstChild("CT");
    local v445;

    if CT then
        v445 = CT:IsA("Frame");
    else
        v445 = CT;
    end;

    assert(v445, "[Loadout] Missing CT team panel");
    CT.Visible = p444 == "CT";
    local T = u51.Container.Teams:FindFirstChild("T");
    local v446;

    if T then
        v446 = T:IsA("Frame");
    else
        v446 = T;
    end;

    assert(v446, "[Loadout] Missing T team panel");
    T.Visible = p444 == "T";
    u2 = p444 == "CT" and "Counter-Terrorists" or (p444 == "T" and "Terrorists" or false);
    UpdateTeamToggle(p444);
    u3 = nil;
    u7 = nil;
    u6 = nil;
    u51.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories";
    u51.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";
    local v447 = DataController.Get(LocalPlayer, "Loadout");
    u1.UpdateLoadoutContainer(v447);
    u1.UpdateSidebarFrames(v447);
    u1.UpdateInventoryContainer();
    u1.PopulateWeaponDropdown();
end;

local function RefreshItemStatusFrames() -- Line: 2786
    -- upvalues: u51 (ref), UpdateStatusFrame (copy)
    if u51 and u51.Visible then
        for _, child in ipairs(u51.Container.List.Container:GetChildren()) do
            if child:IsA("GuiButton") then
                UpdateStatusFrame(child, child.Name);
            end;
        end;
    end;
end;

function u1.Initialize(p448, p449) -- Line: 2801
    -- upvalues: Profiler (copy), u51 (ref), CleanupDrag (copy), u23 (ref), u19 (ref), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u181 (ref), HideAllMoveFrames (copy), u35 (ref), u1 (copy), u4 (ref), u34 (ref), RenderInitialLoadoutTemplates (copy), u33 (ref), u32 (ref), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy), OnLoadoutScrollPositionChanged (copy), u30 (ref), u28 (ref), u29 (ref), MenuState (copy), Router (copy), CloseButtonRegistry (copy), GetInventoryItemFromIdentifier (copy), InspectInventoryItem (copy), Remotes (copy), UseItemFrame (copy), ReplaceItemOnTeam (copy), script_ItemIcon (copy), FadeCategoryLabels (copy), DataController (copy), LocalPlayer (copy), u26 (ref), SetupSidebarHoverEvents (copy), RefreshItemStatusFrames (copy), u8 (ref), UserInputService (copy), u326 (ref), u14 (ref), u24 (ref), u272 (ref), GetLoadoutSlotInfo (copy), u20 (ref), TweenService (copy), TweenInfo_new_ret (copy), u5 (ref), ClearDropdownOptions (copy), u3 (ref), u7 (ref), u6 (ref)
    Profiler.mark("UI.Loadout.Initialize");
    u51 = p449;
    u51:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2806
        -- upvalues: u51 (ref), CleanupDrag (ref), u23 (ref), u19 (ref), u22 (ref), u21 (ref), GamepadService (ref), GuiService (ref), u181 (ref), HideAllMoveFrames (ref), u35 (ref), u1 (ref), u4 (ref), u34 (ref), RenderInitialLoadoutTemplates (ref)
        if u51.Visible then
            if u35 then
                u35 = false;
                u1.SortBySkinMetadata(u4);
            end;

            if u34 then
                RenderInitialLoadoutTemplates();
            end;

            return;
        end;

        CleanupDrag();
        CleanupDrag();
        u19 = nil;
        u23 = nil;
        u22 = false;

        if u21 then
            u21 = false;
            pcall(function() -- Line: 1311
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
            local u450 = u181;

            if u450 then
                task.delay(0.25, function() -- Line: 1270
                    -- upvalues: u181 (ref), u450 (copy), u21 (ref)
                    if u181 == u450 and not u21 then
                        u181 = nil;
                        u450:Destroy();
                    end;
                end);
            end;
        end;

        HideAllMoveFrames();
    end);
    local Container = u51.Container.List.Container;
    Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 2827
        -- upvalues: u51 (ref), u33 (ref), u32 (ref), Profiler (ref), CreateMissingItemTemplates (ref), ApplySortedLayoutOrder (ref)
        if not u51 then
            return;
        end;

        local Container2 = u51.Container.List.Container;
        local v451 = Container2.AbsoluteCanvasSize.Y - Container2.AbsoluteSize.Y;

        if v451 > 0 and (u33 < #u32 and v451 - Container2.CanvasPosition.Y < 200) then
            Profiler.mark("UI.Loadout.RenderLoadoutTemplates");

            if not u51 then
                return;
            end;

            local Container3 = u51.Container.List.Container;
            local math_min_ret = math.min(u33 + 25, #u32);
            CreateMissingItemTemplates(Container3, u33 + 1, math_min_ret);
            u33 = math_min_ret;
            ApplySortedLayoutOrder(Container3);
        end;
    end);
    Container:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- Line: 2832
        -- upvalues: Profiler (ref), OnLoadoutScrollPositionChanged (ref)
        Profiler.defer("UI.Loadout.ScrollDeferred", OnLoadoutScrollPositionChanged);
    end);
    local Menu = p448:FindFirstChild("Menu");

    if Menu then
        Menu:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2839
            -- upvalues: Menu (copy), CleanupDrag (ref), u23 (ref), u19 (ref), u22 (ref), u21 (ref), GamepadService (ref), GuiService (ref), u181 (ref), HideAllMoveFrames (ref), u30 (ref), u28 (ref), u29 (ref), MenuState (ref), Router (ref)
            if not Menu.Visible then
                CleanupDrag();
                CleanupDrag();
                u19 = nil;
                u23 = nil;
                u22 = false;

                if u21 then
                    u21 = false;
                    pcall(function() -- Line: 1311
                        -- upvalues: GamepadService (ref)
                        GamepadService:DisableGamepadCursor();
                    end);
                    GuiService.AutoSelectGuiEnabled = true;
                    local u452 = u181;

                    if u452 then
                        task.delay(0.25, function() -- Line: 1270
                            -- upvalues: u181 (ref), u452 (copy), u21 (ref)
                            if u181 == u452 and not u21 then
                                u181 = nil;
                                u452:Destroy();
                            end;
                        end);
                    end;
                end;

                HideAllMoveFrames();

                if u30 then
                    u30.Visible = false;
                end;

                u28 = nil;
                u29 = nil;

                if MenuState.IsInspectActive() then
                    Router.broadcastRouter("WeaponInspectClose");
                end;
            end;
        end);
    end;

    u30 = u51.Ignore.Information;

    if u30 then
        u30.Visible = false;
        CloseButtonRegistry.Add(u30, nil, function() -- Line: 2857
            -- upvalues: Router (ref), u29 (ref), u30 (ref), u28 (ref), GuiService (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            local v453 = u29;

            if u30 then
                u30.Visible = false;
            end;

            u28 = nil;
            u29 = nil;

            if v453 then
                local Button = v453:FindFirstChild("Button");

                if Button and Button:IsA("GuiButton") then
                    GuiService.SelectedObject = Button;
                end;
            end;
        end);

        if u30.Inspect then
            u30.Inspect.Selectable = true;

            local function handleInspectClick() -- Line: 2871
                -- upvalues: u28 (ref), GetInventoryItemFromIdentifier (ref), InspectInventoryItem (ref), Router (ref)
                local v454;

                if u28 then
                    v454 = GetInventoryItemFromIdentifier(u28);
                else
                    v454 = nil;
                end;

                if v454 then
                    InspectInventoryItem(v454);

                    return;
                end;

                Router.broadcastRouter("RunInterfaceSound", "UI Click");
            end;

            local Inspect = u30.Inspect;
            Inspect.MouseButton1Click:Connect(handleInspectClick);
            Inspect.Activated:Connect(function(p455) -- Line: 1724
                -- upvalues: handleInspectClick (copy)
                if p455 and p455.UserInputType == Enum.UserInputType.Gamepad1 then
                    handleInspectClick();
                end;
            end);
        end;

        if u30.Charm then
            u30.Charm.Selectable = true;

            local function handleCharmClick() -- Line: 2884
                -- upvalues: Router (ref), u28 (ref), GetInventoryItemFromIdentifier (ref), u30 (ref), u29 (ref), Remotes (ref), u51 (ref), UseItemFrame (ref)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                local v456;

                if u28 then
                    v456 = GetInventoryItemFromIdentifier(u28);
                else
                    v456 = nil;
                end;

                if v456 then
                    local Charm = v456.Charm;
                    local v457;

                    if Charm == nil or Charm == false then
                        v457 = false;
                    else
                        v457 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
                    end;

                    if u30 then
                        u30.Visible = false;
                    end;

                    u28 = nil;
                    u29 = nil;

                    if v457 then
                        Remotes.Inventory.RemoveWeaponCharm.Send({
                            WeaponId = v456._id
                        });

                        return;
                    end;

                    u51.Visible = false;
                    UseItemFrame.TriggerAction("AttachCharm", v456);
                end;
            end;

            local Charm = u30.Charm;
            Charm.MouseButton1Click:Connect(handleCharmClick);
            Charm.Activated:Connect(function(p458) -- Line: 1724
                -- upvalues: handleCharmClick (copy)
                if p458 and p458.UserInputType == Enum.UserInputType.Gamepad1 then
                    handleCharmClick();
                end;
            end);
        end;

        UseItemFrame.OnClosed:Connect(function() -- Line: 2901
            -- upvalues: MenuState (ref), u51 (ref)
            if MenuState.GetCurrentScreen() == "Loadout" then
                u51.Visible = true;
            end;
        end);

        if u30.Unlock then
            u30.Unlock.Selectable = true;
            u30.Unlock.Visible = false;
        end;

        local function setupReplaceButton(p459: userdata?, u460: any) -- Line: 2912
            -- upvalues: Router (ref), u28 (ref), GetInventoryItemFromIdentifier (ref), u30 (ref), u29 (ref), ReplaceItemOnTeam (ref)
            if not p459 then
                return;
            end;

            p459.Selectable = true;

            local function u462() -- Line: 2918
                -- upvalues: Router (ref), u28 (ref), GetInventoryItemFromIdentifier (ref), u30 (ref), u29 (ref), ReplaceItemOnTeam (ref), u460 (copy)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                local v461;

                if u28 then
                    v461 = GetInventoryItemFromIdentifier(u28);
                else
                    v461 = nil;
                end;

                if v461 then
                    if u30 then
                        u30.Visible = false;
                    end;

                    u28 = nil;
                    u29 = nil;
                    ReplaceItemOnTeam(v461, u460);
                end;
            end;

            p459.MouseButton1Click:Connect(u462);
            p459.Activated:Connect(function(p463) -- Line: 1724
                -- upvalues: u462 (copy)
                if p463 and p463.UserInputType == Enum.UserInputType.Gamepad1 then
                    u462();
                end;
            end);
        end;

        local ReplaceT = u30.ReplaceT;

        if ReplaceT then
            ReplaceT.Selectable = true;
            local u464 = "Terrorists";

            local function u466() -- Line: 2918
                -- upvalues: Router (ref), u28 (ref), GetInventoryItemFromIdentifier (ref), u30 (ref), u29 (ref), ReplaceItemOnTeam (ref), u464 (copy)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                local v465;

                if u28 then
                    v465 = GetInventoryItemFromIdentifier(u28);
                else
                    v465 = nil;
                end;

                if v465 then
                    if u30 then
                        u30.Visible = false;
                    end;

                    u28 = nil;
                    u29 = nil;
                    ReplaceItemOnTeam(v465, u464);
                end;
            end;

            ReplaceT.MouseButton1Click:Connect(u466);
            ReplaceT.Activated:Connect(function(p467) -- Line: 1724
                -- upvalues: u466 (copy)
                if p467 and p467.UserInputType == Enum.UserInputType.Gamepad1 then
                    u466();
                end;
            end);
        end;

        local ReplaceCT = u30.ReplaceCT;

        if ReplaceCT then
            ReplaceCT.Selectable = true;
            local u468 = "Counter-Terrorists";

            local function u470() -- Line: 2918
                -- upvalues: Router (ref), u28 (ref), GetInventoryItemFromIdentifier (ref), u30 (ref), u29 (ref), ReplaceItemOnTeam (ref), u468 (copy)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                local v469;

                if u28 then
                    v469 = GetInventoryItemFromIdentifier(u28);
                else
                    v469 = nil;
                end;

                if v469 then
                    if u30 then
                        u30.Visible = false;
                    end;

                    u28 = nil;
                    u29 = nil;
                    ReplaceItemOnTeam(v469, u468);
                end;
            end;

            ReplaceCT.MouseButton1Click:Connect(u470);
            ReplaceCT.Activated:Connect(function(p471) -- Line: 1724
                -- upvalues: u470 (copy)
                if p471 and p471.UserInputType == Enum.UserInputType.Gamepad1 then
                    u470();
                end;
            end);
        end;
    end;

    Profiler.spawn("UI.Loadout.PreloadDropShadows", script_ItemIcon.PreloadDropShadows);

    for _, v in ipairs({ "CT", "T" }) do
        local v472 = u51.Container.Teams:FindFirstChild(v);
        local v473;

        if v472 then
            v473 = v472:IsA("Frame");
        else
            v473 = v472;
        end;

        local v474 = `[Loadout] Missing {v} team panel`;
        assert(v473, v474);
        local Guns = v472:FindFirstChild("Guns");

        for _, v2 in ipairs({ "Mid Tier", "Pistols", "Rifles" }) do
            local List = Guns:FindFirstChild(v2).List;

            if List and List:IsA("Frame") then
                List.MouseEnter:Connect(function() -- Line: 2944
                    -- upvalues: FadeCategoryLabels (ref), List (copy)
                    FadeCategoryLabels(List, true);
                end);
                List.MouseLeave:Connect(function() -- Line: 2947
                    -- upvalues: FadeCategoryLabels (ref), List (copy)
                    FadeCategoryLabels(List, false);
                end);
            end;
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Loadout", function(p475) -- Line: 2954
        -- upvalues: Profiler (ref), u26 (ref), u1 (ref), SetupSidebarHoverEvents (ref), RefreshItemStatusFrames (ref)
        Profiler.mark("UI.Loadout.LoadoutChanged");
        u26 = false;
        u1.UpdateLoadoutContainer(p475);
        u1.UpdateSidebarFrames(p475, "Counter-Terrorists");
        u1.UpdateSidebarFrames(p475, "Terrorists");
        SetupSidebarHoverEvents();
        RefreshItemStatusFrames();
    end);
    Remotes.Inventory.LoadoutResponse.Listen(function() -- Line: 2966
        -- upvalues: u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Inventory", function() -- Line: 2971
        -- upvalues: Profiler (ref), u1 (ref), RefreshItemStatusFrames (ref)
        Profiler.mark("UI.Loadout.InventoryChanged");
        u1.UpdateInventoryContainer();
        RefreshItemStatusFrames();
    end);
    UserInputService.InputEnded:Connect(function(p476, p477) -- Line: 2978
        -- upvalues: u19 (ref), u22 (ref), u326 (ref), u8 (ref), u14 (ref), u1 (ref)
        if p476.UserInputType == Enum.UserInputType.MouseButton1 or p476.UserInputType == Enum.UserInputType.Touch then
            if u19 then
                if p476.UserInputType == Enum.UserInputType.MouseButton1 and u22 then
                    u326();
                end;

                return;
            end;

            if u8 or u14 then
                u1.EndDrag();
            end;
        end;
    end);
    UserInputService.InputBegan:Connect(function(p478, p479) -- Line: 3000
        -- upvalues: u19 (ref), u24 (ref), u22 (ref), u272 (ref), u51 (ref), UserInputService (ref), GuiService (ref), GetInventoryItemFromIdentifier (ref), GetLoadoutSlotInfo (ref), InspectInventoryItem (ref)
        if p478.UserInputType == Enum.UserInputType.MouseButton1 then
            if u19 and os.clock() - u24 > 0.05 then
                u22 = true;
            end;

            return;
        end;

        if p478.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return;
        end;

        if p478.KeyCode == Enum.KeyCode.ButtonA then
            if u19 and os.clock() - u24 > 0.05 then
                u22 = true;
            end;
        else
            if p478.KeyCode == Enum.KeyCode.ButtonB then
                u272();

                return;
            end;

            if p478.KeyCode == Enum.KeyCode.ButtonX then
                if not u51.Visible or (u19 or UserInputService:GetFocusedTextBox()) then
                    return;
                end;

                local SelectedObject = GuiService.SelectedObject;

                if not (SelectedObject and (SelectedObject:IsA("GuiButton") and SelectedObject:IsDescendantOf(u51))) then
                    return;
                end;

                local v480;

                if SelectedObject and SelectedObject:IsA("ImageButton") then
                    v480 = GetInventoryItemFromIdentifier(SelectedObject.Name);
                else
                    v480 = nil;
                end;

                if not v480 then
                    local Parent = SelectedObject.Parent;

                    if Parent and Parent:IsA("Frame") then
                        local Name = Parent.Name;
                        local v481, v482 = GetLoadoutSlotInfo(SelectedObject);

                        if v481 and v482 then
                            v480 = GetInventoryItemFromIdentifier(Name);
                        else
                            v480 = nil;
                        end;
                    else
                        v480 = nil;
                    end;
                end;

                local Attribute = SelectedObject:GetAttribute("EquippedItemId");

                if not (v480 or (type(Attribute) ~= "string" or Attribute == "")) then
                    v480 = GetInventoryItemFromIdentifier(Attribute);
                end;

                if v480 then
                    InspectInventoryItem(v480);
                end;
            end;
        end;
    end);
    UserInputService.InputEnded:Connect(function(p483, p484) -- Line: 3046
        -- upvalues: u19 (ref), u22 (ref), u326 (ref)
        if p483.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return;
        end;

        if p483.KeyCode == Enum.KeyCode.ButtonA and (u19 and u22) then
            u326();
        end;
    end);
    UserInputService.LastInputTypeChanged:Connect(function(p485) -- Line: 3062
        -- upvalues: u21 (ref), u20 (ref), u23 (ref), CleanupDrag (ref), u19 (ref), u22 (ref), GamepadService (ref), GuiService (ref), u181 (ref), HideAllMoveFrames (ref)
        if u21 and (p485 ~= Enum.UserInputType.Keyboard and p485 ~= Enum.UserInputType.Touch) then
            return;
        end;

        local v486 = u20;
        u20 = p485 == Enum.UserInputType.Gamepad1;

        if v486 and not u20 then
            CleanupDrag();
            u19 = nil;
            u23 = nil;
            u22 = false;

            if u21 then
                u21 = false;
                pcall(function() -- Line: 1311
                    -- upvalues: GamepadService (ref)
                    GamepadService:DisableGamepadCursor();
                end);
                GuiService.AutoSelectGuiEnabled = true;
                local u487 = u181;

                if u487 then
                    task.delay(0.25, function() -- Line: 1270
                        -- upvalues: u181 (ref), u487 (copy), u21 (ref)
                        if u181 == u487 and not u21 then
                            u181 = nil;
                            u487:Destroy();
                        end;
                    end);
                end;
            end;

            HideAllMoveFrames();
        end;

        if not v486 and u20 then
            CleanupDrag();
        end;
    end);
    u20 = UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1;
    local Filter = u51.Container.List.Top.Filter;
    local Scroll = Filter.DropdownContent.Scroll;
    Filter.MouseButton1Click:Connect(function() -- Line: 3093
        -- upvalues: Scroll (copy), u51 (ref)
        local Visible = Scroll.Parent.Visible;
        local DropdownContent = u51.Container.List.Top.Weapon.DropdownContent;
        u51.Container.List.Top.Filter.DropdownContent.Visible = false;
        DropdownContent.Visible = false;
        Scroll.Parent.Visible = not Visible;
    end);

    for _, child in ipairs(Scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundTransparency = 1;
            child.MouseEnter:Connect(function() -- Line: 3102
                -- upvalues: child (copy), TweenService (ref), TweenInfo_new_ret (ref)
                TweenService:Create(child, TweenInfo_new_ret, {
                    BackgroundTransparency = 0.85
                }):Play();
            end);
            child.MouseLeave:Connect(function() -- Line: 3105
                -- upvalues: child (copy), TweenService (ref), TweenInfo_new_ret (ref)
                TweenService:Create(child, TweenInfo_new_ret, {
                    BackgroundTransparency = 1
                }):Play();
            end);
            child.MouseButton1Click:Connect(function() -- Line: 3108
                -- upvalues: u1 (ref), child (copy), Scroll (copy)
                u1.SortBySkinMetadata(child.Name);
                Scroll.Parent.Visible = false;
            end);
        end;
    end;

    local Reverse = u51.Container.List.Top.Filter.Container.Left.Reverse;

    if Reverse then
        Reverse.Selectable = true;

        local function u489() -- Line: 3118
            -- upvalues: u5 (ref), Reverse (copy), u1 (ref), u4 (ref), Router (ref)
            u5 = not u5;
            local v488 = Reverse:FindFirstChildOfClass("ImageLabel");

            if v488 then
                v488.Rotation = u5 and 180 or 0;
            end;

            u1.SortBySkinMetadata(u4);
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end;

        Reverse.MouseButton1Click:Connect(u489);
        Reverse.Activated:Connect(function(p490) -- Line: 1724
            -- upvalues: u489 (copy)
            if p490 and p490.UserInputType == Enum.UserInputType.Gamepad1 then
                u489();
            end;
        end);
    end;

    local Weapon = u51.Container.List.Top.Weapon;
    local Scroll2 = Weapon.DropdownContent.Scroll;

    if Scroll2 and (Scroll2:IsA("Frame") or Scroll2:IsA("ScrollingFrame")) then
        ClearDropdownOptions(Scroll2);
        Weapon.MouseButton1Click:Connect(function() -- Line: 3136
            -- upvalues: Scroll2 (copy), u51 (ref)
            local Visible = Scroll2.Parent.Visible;
            local DropdownContent = u51.Container.List.Top.Weapon.DropdownContent;
            u51.Container.List.Top.Filter.DropdownContent.Visible = false;
            DropdownContent.Visible = false;
            Scroll2.Parent.Visible = not Visible;
        end);
    end;

    local Reset = u51.Container.List.Top.Reset;

    if Reset then
        Reset.Visible = false;
        Reset.MouseButton1Click:Connect(function() -- Line: 3148
            -- upvalues: u3 (ref), u7 (ref), u6 (ref), Weapon (copy), Reset (copy), u1 (ref), u51 (ref), u4 (ref)
            u3 = nil;
            u7 = nil;
            u6 = nil;
            Weapon.Container.Left.Title.Text = "All Weapons";
            Reset.Visible = false;
            u1.PopulateWeaponDropdown();

            for _, child in ipairs(u51.Container.List.Container:GetChildren()) do
                if child:IsA("ImageButton") then
                    child.Visible = true;
                end;
            end;

            u1.SortBySkinMetadata(u4);
        end);
    end;
end;

function u1.ViewInLoadout(p491: string) -- Line: 3172
    -- upvalues: GetInventoryItemFromIdentifier (copy), GetWeaponProperties (copy), u3 (ref), u51 (ref), u1 (copy), u6 (ref), MenuState (copy)
    local v492 = GetInventoryItemFromIdentifier(p491);

    if not v492 then
        return;
    end;

    local Name = v492.Name;
    local Skin = v492.Skin;
    local success, result = pcall(GetWeaponProperties, Name);

    if success and (result and result.Type) then
        u3 = result.Type;
        u51.Container.List.Top.Filter.Container.Left.Title.Text = result.Type;
        u1.PopulateWeaponDropdown();
    end;

    u1.SortByWeapon(Name, Skin);
    local Reset = u51.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u51.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;

    if not u51.Visible then
        MenuState.SetScreen("Loadout");
        u51.Visible = true;
    end;
end;

function u1.Start() -- Line: 3200
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), u1 (copy), SetupSidebarHoverEvents (copy), u3 (ref), u7 (ref), u6 (ref), u51 (ref), u4 (ref), u47 (copy), u41 (copy), u19 (ref), u25 (ref), ActivateButton (copy), u2 (ref), MenuState (copy), u23 (ref), CleanupDrag (copy), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u181 (ref), HideAllMoveFrames (copy), u49 (copy), CloseButtonRegistry (copy), GamepadNavigation (copy)
    debug.setmemorycategory("UI.Loadout.Start");
    Profiler.mark("UI.Loadout.Start.Begin");
    DataController.WaitForDataLoaded(LocalPlayer);
    Profiler.mark("UI.Loadout.Start.DataLoaded");
    u1.SelectTeam("CT");
    Profiler.mark("UI.Loadout.Start.InitialTeam");
    local v493 = DataController.Get(LocalPlayer, "Loadout");

    if v493 then
        u1.UpdateSidebarFrames(v493, "Counter-Terrorists");
        u1.UpdateSidebarFrames(v493, "Terrorists");
        SetupSidebarHoverEvents();
    end;

    u1.PopulateWeaponDropdown();
    u1.SortBySkinMetadata("Newest");

    local function ClearFiltersAndShowAll() -- Line: 3222
        -- upvalues: u3 (ref), u7 (ref), u6 (ref), u51 (ref), u1 (ref), u4 (ref)
        u3 = nil;
        u7 = nil;
        u6 = nil;
        u51.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories";
        u51.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";

        for _, child in ipairs(u51.Container.List.Container:GetChildren()) do
            if child:IsA("ImageButton") then
                child.Visible = true;
            end;
        end;

        u1.SortBySkinMetadata(u4);
        local Reset = u51.Container.List.Top:FindFirstChild("Reset");

        if Reset then
            Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u51.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
        end;
    end;

    local function GetEquipmentSlotTitle(p494: string) -- Line: 3243
        -- upvalues: u47 (ref)
        return u47[p494] or p494;
    end;

    local u495 = {};

    local function SetupSidebarButtonClicks() -- Line: 3249
        -- upvalues: Profiler (ref), u51 (ref), u41 (ref), u19 (ref), u25 (ref), u6 (ref), ClearFiltersAndShowAll (copy), u3 (ref), u7 (ref), u47 (ref), u1 (ref), u4 (ref), u495 (copy)
        Profiler.mark("UI.Loadout.SetupSidebarButtonClicks");

        for _, v in ipairs({ "CT", "T" }) do
            local v496 = u51.Container.Teams:FindFirstChild(v);
            local v497;

            if v496 then
                v497 = v496:IsA("Frame");
            else
                v497 = v496;
            end;

            local v498 = `[Loadout] Missing {v} team panel`;
            assert(v497, v498);
            local Equipments = v496:FindFirstChild("Equipments");
            local u499 = v;

            for _, v2 in ipairs(u41) do
                local v500 = Equipments[v2];
                v500.Selectable = true;
                v500.Active = true;

                local function handleSelection() -- Line: 3262
                    -- upvalues: u19 (ref), u25 (ref), u6 (ref), u499 (copy), v2 (copy), ClearFiltersAndShowAll (ref), u3 (ref), u7 (ref), u51 (ref), u47 (ref), u1 (ref), u4 (ref)
                    if u19 or os.clock() - u25 < 0.25 then
                        return;
                    end;

                    local v501 = u6;

                    if v501 then
                        if u6.teamKey == u499 then
                            v501 = u6.sidebarName == v2;
                        else
                            v501 = false;
                        end;
                    end;

                    if v501 then
                        u6 = nil;
                        ClearFiltersAndShowAll();

                        return;
                    end;

                    u3 = nil;
                    u7 = nil;
                    u51.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories";
                    local v502 = v2;
                    u51.Container.List.Top.Weapon.Container.Left.Title.Text = u47[v502] or v502;
                    u6 = {
                        teamKey = u499,
                        sidebarName = v2
                    };
                    u1.SortBySkinMetadata(u4);
                    local Reset = u51.Container.List.Top:FindFirstChild("Reset");

                    if Reset then
                        Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u51.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
                    end;
                end;

                local v503 = `{u499}_{v2}`;

                if u495[v503] then
                    u495[v503]:Disconnect();
                end;

                u495[v503] = v500.Activated:Connect(handleSelection);
            end;
        end;
    end;

    SetupSidebarButtonClicks();
    ActivateButton(u51.Teams.ButtonCT);
    ActivateButton(u51.Teams.ButtonT);

    local function SwitchToTeam(p504: string) -- Line: 3315
        -- upvalues: u2 (ref), u1 (ref), u6 (ref), ClearFiltersAndShowAll (copy), Profiler (ref), SetupSidebarButtonClicks (copy)
        if u2 == (p504 == "CT" and "Counter-Terrorists" or "Terrorists") then
            return;
        end;

        u1.SelectTeam(p504);
        u6 = nil;
        ClearFiltersAndShowAll();
        Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks);
    end;

    u51.Teams.ButtonCT.MouseButton1Click:Connect(function() -- Line: 3329
        -- upvalues: u2 (ref), u1 (ref), u6 (ref), ClearFiltersAndShowAll (copy), Profiler (ref), SetupSidebarButtonClicks (copy)
        if u2 == "Counter-Terrorists" then
            return;
        end;

        u1.SelectTeam("CT");
        u6 = nil;
        ClearFiltersAndShowAll();
        Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks);
    end);
    u51.Teams.ButtonT.MouseButton1Click:Connect(function() -- Line: 3333
        -- upvalues: u2 (ref), u1 (ref), u6 (ref), ClearFiltersAndShowAll (copy), Profiler (ref), SetupSidebarButtonClicks (copy)
        if u2 == "Terrorists" then
            return;
        end;

        u1.SelectTeam("T");
        u6 = nil;
        ClearFiltersAndShowAll();
        Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks);
    end);
    MenuState.RegisterBumperOverride(u51, function(p505: boolean) -- Line: 3339
        -- upvalues: u19 (ref), u23 (ref), CleanupDrag (ref), u22 (ref), u21 (ref), GamepadService (ref), GuiService (ref), u181 (ref), HideAllMoveFrames (ref), u2 (ref), MenuState (ref), u51 (ref), u49 (ref), u1 (ref), u6 (ref), ClearFiltersAndShowAll (copy), Profiler (ref), SetupSidebarButtonClicks (copy)
        if u19 then
            CleanupDrag();
            u19 = nil;
            u23 = nil;
            u22 = false;

            if u21 then
                u21 = false;
                pcall(function() -- Line: 1311
                    -- upvalues: GamepadService (ref)
                    GamepadService:DisableGamepadCursor();
                end);
                GuiService.AutoSelectGuiEnabled = true;
                local u506 = u181;

                if u506 then
                    task.delay(0.25, function() -- Line: 1270
                        -- upvalues: u181 (ref), u506 (copy), u21 (ref)
                        if u181 == u506 and not u21 then
                            u181 = nil;
                            u506:Destroy();
                        end;
                    end);
                end;
            end;

            HideAllMoveFrames();
        end;

        local v507 = u2 == "Counter-Terrorists" and "ButtonCT" or "ButtonT";
        local NextBumperTab = MenuState.GetNextBumperTab(u51.Teams, u49, v507, p505);

        if NextBumperTab and NextBumperTab ~= v507 then
            local v508 = NextBumperTab == "ButtonCT" and "CT" or "T";

            if u2 ~= (v508 == "CT" and "Counter-Terrorists" or "Terrorists") then
                u1.SelectTeam(v508);
                u6 = nil;
                ClearFiltersAndShowAll();
                Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks);
            end;
        end;

        local v509 = u51.Teams:FindFirstChild(NextBumperTab or v507);

        if v509 and v509:IsA("GuiObject") then
            GuiService.SelectedObject = v509;
        end;

        return true;
    end, u51, u51.Teams, function() -- Line: 3358
        -- upvalues: u19 (ref)
        return u19 ~= nil;
    end);
    CloseButtonRegistry.AddHandler(function() -- Line: 3363
        -- upvalues: u19 (ref), u51 (ref)
        local v510;

        if u19 == nil then
            v510 = false;
        else
            v510 = u51.Visible;
        end;

        return v510;
    end, function() -- Line: 3365
        -- upvalues: u23 (ref), CleanupDrag (ref), u19 (ref), u22 (ref), u21 (ref), GamepadService (ref), GuiService (ref), u181 (ref), HideAllMoveFrames (ref), GamepadNavigation (ref)
        local v511 = u23;
        CleanupDrag();
        u19 = nil;
        u23 = nil;
        u22 = false;

        if u21 then
            u21 = false;
            pcall(function() -- Line: 1311
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
            local u512 = u181;

            if u512 then
                task.delay(0.25, function() -- Line: 1270
                    -- upvalues: u181 (ref), u512 (copy), u21 (ref)
                    if u181 == u512 and not u21 then
                        u181 = nil;
                        u512:Destroy();
                    end;
                end);
            end;
        end;

        HideAllMoveFrames();

        if v511 and GamepadNavigation.IsUsable(v511) then
            GamepadNavigation.ScrollIntoView(v511);
            GuiService.SelectedObject = v511;
        end;
    end);
    GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function() -- Line: 3372
        -- upvalues: u21 (ref), u19 (ref), GamepadService (ref), u23 (ref), CleanupDrag (ref), u22 (ref), GuiService (ref), u181 (ref), HideAllMoveFrames (ref), GamepadNavigation (ref)
        if u21 and (u19 and not GamepadService.GamepadCursorEnabled) then
            local v513 = u23;
            CleanupDrag();
            u19 = nil;
            u23 = nil;
            u22 = false;

            if u21 then
                u21 = false;
                pcall(function() -- Line: 1311
                    -- upvalues: GamepadService (ref)
                    GamepadService:DisableGamepadCursor();
                end);
                GuiService.AutoSelectGuiEnabled = true;
                local u514 = u181;

                if u514 then
                    task.delay(0.25, function() -- Line: 1270
                        -- upvalues: u181 (ref), u514 (copy), u21 (ref)
                        if u181 == u514 and not u21 then
                            u181 = nil;
                            u514:Destroy();
                        end;
                    end);
                end;
            end;

            HideAllMoveFrames();

            if v513 and GamepadNavigation.IsUsable(v513) then
                GamepadNavigation.ScrollIntoView(v513);
                GuiService.SelectedObject = v513;
            end;
        end;
    end);
    u51.Teams.ButtonCT.Interactable = true;
    u51.Teams.ButtonT.Interactable = true;
end;

return u1;