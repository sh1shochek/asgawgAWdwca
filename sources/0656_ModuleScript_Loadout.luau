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

local function CanInspectItem(p45) -- Line: 216
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
    Melee = "Melee",
    Gloves = "Glove"
};
local u48 = { "ButtonCT", "ButtonT" };
local u49 = {
    Terrorists = { "Glock-18" },
    ["Counter-Terrorists"] = { "USP-S", "P2000" }
};
local u50 = nil;

local function GetTeamFrame(p51: string) -- Line: 241
    -- upvalues: u50 (ref)
    local v52 = u50.Container.Teams:FindFirstChild(p51);
    local v53;

    if v52 then
        v53 = v52:IsA("Frame");
    else
        v53 = v52;
    end;

    local v54 = `[Loadout] Missing {p51} team panel`;
    assert(v53, v54);

    return v52;
end;

local function ClearFrame(p55: any, p56: table) -- Line: 247
    for _, child in ipairs(p55:GetChildren()) do
        if not table.find(p56, child.Name) then
            child:Destroy();
        end;
    end;
end;

local u57 = { "Charm", "Inspect", "ReplaceCT", "ReplaceT", "Unlock" };

local function GetVisibleInformationFrameButtons() -- Line: 260
    -- upvalues: u57 (copy), u30 (ref)
    local v58 = {};

    for _, v in u57 do
        local v59 = u30[v];

        if v59 and v59.Visible then
            table.insert(v58, v59);
        end;
    end;

    local QuickUnlock = u30:FindFirstChild("QuickUnlock");

    if QuickUnlock and QuickUnlock.Visible then
        table.insert(v58, QuickUnlock);
    end;

    return v58;
end;

local function HasAnyInformationFrameButton() -- Line: 275
    -- upvalues: u30 (ref), GetVisibleInformationFrameButtons (copy)
    local v60;

    if u30 == nil then
        v60 = false;
    else
        v60 = #GetVisibleInformationFrameButtons() > 0;
    end;

    return v60;
end;

local function ItemHasCharm(p61) -- Line: 279
    local Charm = p61.Charm;
    local v62;

    if Charm == nil or Charm == false then
        v62 = false;
    else
        v62 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
    end;

    return v62;
end;

local function FindWeaponSlotOnTeam(p63: string, p64: any, p65: string) -- Line: 284
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v66 = DataController.Get(LocalPlayer, "Loadout");
    local v67 = DataController.Get(LocalPlayer, "Inventory");

    if not (v66 and v67) then
        return nil;
    end;

    local v68 = v66[p64];

    if not (v68 and (v68.Loadout and v68.Loadout[p65])) then
        return nil;
    end;

    for i, v in ipairs(v68.Loadout[p65].Options) do
        if v and v ~= "" then
            local v69 = i;
            local v70 = v;

            for _, v2 in ipairs(v67) do
                if v2._id == v70 and v2.Name == p63 then
                    return v69;
                end;
            end;
        end;
    end;

    return nil;
end;

local function ReplaceItemOnTeam(p71, p72) -- Line: 309
    -- upvalues: GetWeaponProperties (copy), u36 (copy), FindWeaponSlotOnTeam (copy), Remotes (copy), u39 (copy)
    if p71.Type ~= "Weapon" then
        if p71.Type == "Melee" and (p71.Name == "CT Knife" and p72 == "Terrorists" or p71.Name == "T Knife" and p72 == "Counter-Terrorists") then
            return;
        end;

        local v73 = u39[p71.Type];

        if v73 then
            Remotes.Inventory.EquipSpecialItem.Send({
                Identifier = p71._id,
                Path = v73,
                Team = p72
            });
        end;

        return;
    end;

    local success, result = pcall(GetWeaponProperties, p71.Name);
    local v74;

    if success and (result and result.Type) then
        v74 = u36[result.Type];
    else
        v74 = nil;
    end;

    if not v74 then
        return;
    end;

    local v75 = FindWeaponSlotOnTeam(p71.Name, p72, v74) or 1;
    Remotes.Inventory.EquipLoadoutSkin.Send({
        Type = v74,
        Slot = v75 - 1,
        Team = p72,
        Identifier = p71._id
    });
end;

function u1.SetupInformationFrameNavigation() -- Line: 348
    -- upvalues: u30 (ref), GetVisibleInformationFrameButtons (copy)
    if not u30 then
        return;
    end;

    local v76 = GetVisibleInformationFrameButtons();
    table.sort(v76, function(p77, p78) -- Line: 354
        return p77.LayoutOrder < p78.LayoutOrder;
    end);

    for i, v in ipairs(v76) do
        v.NextSelectionUp = v76[i > 1 and i - 1 or #v76];
        v.NextSelectionDown = v76[i < #v76 and i + 1 or 1];
        v.NextSelectionLeft = nil;
        v.NextSelectionRight = nil;
    end;
end;

function u1.SelectFirstInformationFrameButton() -- Line: 366
    -- upvalues: u30 (ref), u1 (copy), GetVisibleInformationFrameButtons (copy), GuiService (copy)
    if not (u30 and u30.Visible) then
        return;
    end;

    u1.SetupInformationFrameNavigation();
    local v79 = GetVisibleInformationFrameButtons()[1];

    if v79 then
        GuiService.SelectedObject = v79;
    end;
end;

function u1.SetupInformationFrame(p80) -- Line: 379
    -- upvalues: Profiler (copy), u30 (ref), u44 (copy), GetWeaponProperties (copy), IsEquippedOnTeam (copy)
    Profiler.mark("UI.Loadout.SetupInformationFrame");
    local v81 = p80.Type == "Weapon";
    local v82 = p80.Type == "Melee";
    local v83 = p80.Type == "Glove";
    local v84 = p80.Type == "Badge";
    local v85 = p80.Type == "Zeus x27";
    local v86;

    if p80 == nil then
        v86 = false;
    else
        v86 = u44[p80.Type] == true;
    end;

    u30.Inspect.Visible = v86;

    if u30.Unlock then
        u30.Unlock.Visible = p80.Type == "Case" and true or p80.Type == "Package";
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

    local v87 = v81 or (v85 or p80.Type == "Charm");

    if u30.Charm then
        u30.Charm.Visible = v87;
        local v88 = v87 and u30.Charm:FindFirstChildWhichIsA("TextLabel", true);

        if v88 then
            if p80.Type == "Charm" then
                v88.Text = "Attach to Weapon";
            else
                local Charm = p80.Charm;
                local v89;

                if Charm == nil or Charm == false then
                    v89 = false;
                else
                    v89 = (type(Charm) == "string" or Charm == true) and true or type(Charm) == "table";
                end;

                v88.Text = v89 and "Detach Charm" or "Attach Charm";
            end;
        end;
    end;

    local u90 = false;
    local u91 = false;

    local function applyTeamRestriction(p92: string?) -- Line: 424
        -- upvalues: u90 (ref), u91 (ref)
        u90 = p92 == "Both" and true or p92 == "Counter-Terrorists";
        u91 = p92 == "Both" and true or p92 == "Terrorists";
    end;

    if v81 then
        local success, result = pcall(GetWeaponProperties, p80.Name);

        if success and result then
            local Team = result.Team;
            u90 = Team == "Both" and true or Team == "Counter-Terrorists";
            u91 = Team == "Both" and true or Team == "Terrorists";
        end;
    elseif v82 then
        if p80.Name == "T Knife" then
            u90 = false;
        else
            u90 = true;
        end;

        if p80.Name == "CT Knife" then
            u91 = false;
        else
            u91 = true;
        end;
    elseif v83 then
        local v93 = GetWeaponProperties(p80.Name);

        if v93 then
            local Team = v93.Team;
            u90 = Team == "Both" and true or Team == "Counter-Terrorists";
            u91 = Team == "Both" and true or Team == "Terrorists";
        end;
    elseif v84 or v85 then
        u90 = true;
        u91 = true;
    end;

    local v94 = IsEquippedOnTeam(p80._id, "Counter-Terrorists");
    local v95 = IsEquippedOnTeam(p80._id, "Terrorists");
    local v96 = v81 or (v82 or (v83 or (v84 or v85)));

    if u30.ReplaceCT then
        u30.ReplaceCT.Visible = v96 and u90 and not v94;
    end;

    if u30.ReplaceT then
        u30.ReplaceT.Visible = v96 and u91 and not v95;
    end;

    local v97 = {
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
    local v98 = {
        UnlockDivider = true
    };

    for _, v in ipairs(v97) do
        v98[v.dividerName] = true;
    end;

    for _, v in ipairs(v97) do
        local v99 = u30:FindFirstChild(v.dividerName);

        if v99 and v.action then
            local v100 = false;

            if v.action.Visible then
                local v101 = v;

                for _, child in ipairs(u30:GetChildren()) do
                    if not (v98[child.Name] or (child == v99 or (child == v101.action or not (child:IsA("Frame") or child:IsA("TextButton")))) or (child.LayoutOrder >= v99.LayoutOrder or not child.Visible)) then
                        v100 = true;
                        break;
                    end;
                end;
            end;

            v99.Visible = v100;
        end;
    end;
end;

local function PositionInformationFrame(p102: userdata?, p103: boolean?) -- Line: 497
    -- upvalues: u30 (ref), UserInputService (copy), Mouse (copy)
    local Parent = u30.Parent.Parent;
    local AbsolutePosition = Parent.AbsolutePosition;
    local AbsoluteSize = Parent.AbsoluteSize;
    local v104 = nil;
    local v105 = nil;

    if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 or p103 then
        if p102 then
            local AbsolutePosition2 = p102.AbsolutePosition;
            local AbsoluteSize2 = p102.AbsoluteSize;
            v104 = AbsolutePosition2.X + AbsoluteSize2.X / 2;
            v105 = AbsolutePosition2.Y + AbsoluteSize2.Y / 2;
        end;
    else
        v104 = Mouse.X;
        v105 = Mouse.Y;
    end;

    local v106, v107;

    if v104 and v105 then
        local v108 = (v104 - AbsolutePosition.X) / AbsoluteSize.X;
        v106 = (v105 - AbsolutePosition.Y) / AbsoluteSize.Y + u30.Size.Y.Scale / 2;

        if 1 - v108 >= u30.Size.X.Scale + 0.01 then
            v107 = v108 + u30.Size.X.Scale / 2 + 0.01;
        else
            v107 = v108 - u30.Size.X.Scale / 2 - 0.01;
        end;
    else
        v107 = 0.5;
        v106 = 0.5;
    end;

    u30.Position = UDim2.fromScale(v107, v106);
end;

local function ShowContextMenu(p109: any, p110, p111: userdata?, u112: boolean?) -- Line: 535
    -- upvalues: DataController (copy), LocalPlayer (copy), u28 (ref), u29 (ref), u30 (ref), Router (copy), u1 (copy), GetVisibleInformationFrameButtons (copy), PositionInformationFrame (copy), Profiler (copy)
    local v113 = DataController.Get(LocalPlayer, "Inventory");

    if v113 then
        for _, v in ipairs(v113) do
            if v._id == p109._id then
                p109 = v;
                break;
            end;
        end;
    end;

    u28 = p109._id;
    u29 = p111;

    if not u30 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    u1.SetupInformationFrame(p109);
    local v114;

    if u30 == nil then
        v114 = false;
    else
        v114 = #GetVisibleInformationFrameButtons() > 0;
    end;

    if not v114 then
        u30.Visible = false;
        u28 = nil;
        u29 = nil;

        return;
    end;

    if u112 then
        u30.Visible = true;
    else
        u30.Visible = not u30.Visible;
    end;

    if u30.Visible then
        PositionInformationFrame(p111, u112);
        Profiler.defer("UI.Loadout.InformationNavigationDeferred", function() -- Line: 577
            -- upvalues: u1 (ref), u112 (copy)
            u1.SetupInformationFrameNavigation();

            if u112 then
                u1.SelectFirstInformationFrameButton();
            end;
        end);

        return;
    end;

    u28 = nil;
    u29 = nil;
end;

local function HideContextMenu() -- Line: 591
    -- upvalues: u30 (ref), u28 (ref), u29 (ref)
    if u30 then
        u30.Visible = false;
    end;

    u28 = nil;
    u29 = nil;
end;

local function GetInventoryItemFromIdentifier(p115: string) -- Line: 602
    -- upvalues: DataController (copy), LocalPlayer (copy)
    for _, v in ipairs(DataController.Get(LocalPlayer, "Inventory") or {}) do
        if v._id == p115 then
            return v;
        end;
    end;

    return nil;
end;

local function GetCurrentInventoryItem() -- Line: 611
    -- upvalues: u28 (ref), GetInventoryItemFromIdentifier (copy)
    if u28 then
        return GetInventoryItemFromIdentifier(u28);
    end;

    return nil;
end;

local u116 = nil;
Collections.ObserveAvailableCollections(function(p117) -- Line: 618
    -- upvalues: u116 (ref)
    u116 = p117;
end);

local function IsWeaponValidForTeam(p118: string?, p119: any) -- Line: 624
    -- upvalues: GetWeaponProperties (copy)
    if not (p118 and (type(p118) == "string" and p118 ~= "")) then
        return false;
    end;

    local success, result = pcall(GetWeaponProperties, p118);

    if success then
        if result == nil or result.Team == nil then
            success = false;
        else
            success = result.Team == "Both" and true or result.Team == p119;
        end;
    end;

    return success;
end;

local function GetSortedLoadoutItemIds() -- Line: 636
    -- upvalues: DataController (copy), LocalPlayer (copy), Sort (copy), u4 (ref), u116 (ref), u38 (copy), u37 (copy), GetWeaponProperties (copy), u2 (ref), u3 (ref), u6 (ref), u43 (copy), u47 (copy), u7 (ref), u5 (ref)
    local v120 = DataController.Get(LocalPlayer, "Inventory");

    if not v120 then
        return {};
    end;

    local SortComparisonFunction = Sort.GetSortComparisonFunction(u4, LocalPlayer, function() -- Line: 642
        -- upvalues: u116 (ref)
        return u116;
    end);
    local v121 = {};
    local v122 = {};

    for _, v in ipairs(v120) do
        if v and (v._id and not (v121[v._id] or (u38[v.Type] or (u37[v.Name] or (not v.Name or type(v.Name) ~= "string"))))) then
            local success, result = pcall(GetWeaponProperties, v.Name);

            if success and (result and result.Team) then
                local Name = v.Name;
                local v123 = u2;
                local v124;

                if Name and (type(Name) == "string" and Name ~= "") then
                    local v125;
                    v124, v125 = pcall(GetWeaponProperties, Name);

                    if v124 then
                        if v125 == nil or v125.Team == nil then
                            v124 = false;
                        else
                            v124 = v125.Team == "Both" and true or v125.Team == v123;
                        end;
                    end;
                else
                    v124 = false;
                end;

                if v124 then
                    v121[v._id] = true;
                    table.insert(v122, v);
                end;
            else
                v121[v._id] = true;
                table.insert(v122, v);
            end;
        end;
    end;

    if u3 then
        v122 = {};

        for _, v in ipairs(v122) do
            if v.Type ~= "Case" and (v.Type ~= "Package" and (v.Type ~= "Charm Capsule" and (v.Type ~= "Sticker Capsule" and (v.Name and type(v.Name) == "string")))) then
                local success, result = pcall(GetWeaponProperties, v.Name);

                if success and (result and result.Type == u3) then
                    table.insert(v122, v);
                end;
            end;
        end;
    end;

    if u6 then
        local v126 = u43[u6.sidebarName];
        local v127 = u47[u6.sidebarName];
        local v128 = u6.teamKey == "CT" and "Counter-Terrorists" or "Terrorists";
        v122 = {};

        for _, v in ipairs(v122) do
            if v.Type == v126 then
                local success, result = pcall(GetWeaponProperties, v.Name);

                if not (v127 and (success and (result and (result.Class and result.Class ~= v127)))) then
                    local Name = v.Name;
                    local v129 = v128 == "Counter-Terrorists" and "T" or "CT";

                    if Name ~= `{v129} Knife` and Name ~= `{v129} Gloves` then
                        local v130 = not (success and (result and result.Team));
                        local Name2 = v.Name;
                        local v131;

                        if Name2 and (type(Name2) == "string" and Name2 ~= "") then
                            local v132;
                            v131, v132 = pcall(GetWeaponProperties, Name2);

                            if v131 then
                                if v132 == nil or v132.Team == nil then
                                    v131 = false;
                                else
                                    v131 = v132.Team == "Both" and true or v132.Team == v128;
                                end;
                            end;
                        else
                            v131 = false;
                        end;

                        if v130 or v131 then
                            table.insert(v122, v);
                        end;
                    end;
                end;
            end;
        end;
    end;

    if u7 then
        v122 = {};

        for _, v in ipairs(v122) do
            if v.Name == u7.weaponName and (u7.skinName == nil and true or v.Skin == u7.skinName) then
                table.insert(v122, v);
            end;
        end;
    end;

    if SortComparisonFunction then
        if u5 then
            table.sort(v122, function(p133, p134) -- Line: 741
                -- upvalues: SortComparisonFunction (copy)
                local v135, v136 = SortComparisonFunction(p133, p134);

                if v136 then
                    return v135;
                end;

                return SortComparisonFunction(p134, p133);
            end);
        else
            table.sort(v122, SortComparisonFunction);
        end;
    end;

    local table_create_ret = table.create(#v122);

    for _, v in ipairs(v122) do
        table.insert(table_create_ret, v._id);
    end;

    return table_create_ret;
end;

local function CreateMissingItemTemplates(p137: userdata, p138: number, p139: number) -- Line: 766
    -- upvalues: u32 (ref), GetInventoryItemFromIdentifier (copy), u1 (copy)
    for i = p138, p139 do
        local v140 = u32[i];
        local v141;

        if v140 then
            v141 = GetInventoryItemFromIdentifier(v140);
        else
            v141 = v140;
        end;

        local v142;

        if v141 and not p137:FindFirstChild(v140) then
            u1.CreateItemTemplate(v141);
            v142 = i;
        else
            v142 = i;
        end;
    end;
end;

local function ApplySortedLayoutOrder(p143: userdata) -- Line: 776
    -- upvalues: u32 (ref)
    for _, child in ipairs(p143:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
            local v144 = child;

            for i, v in ipairs(u32) do
                if v == v144.Name then
                    v144.LayoutOrder = i;
                    break;
                end;
            end;
        end;
    end;
end;

local function RenderLoadoutTemplates() -- Line: 794
    -- upvalues: Profiler (copy), u50 (ref), u33 (ref), u32 (ref), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy)
    Profiler.mark("UI.Loadout.RenderLoadoutTemplates");

    if not u50 then
        return;
    end;

    local Container = u50.Container.List.Container;
    local math_min_ret = math.min(u33 + 25, #u32);
    CreateMissingItemTemplates(Container, u33 + 1, math_min_ret);
    u33 = math_min_ret;
    ApplySortedLayoutOrder(Container);
end;

local function OnLoadoutScrollPositionChanged() -- Line: 809
    -- upvalues: u50 (ref), u33 (ref), u32 (ref), Profiler (copy), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy)
    if not u50 then
        return;
    end;

    local Container = u50.Container.List.Container;
    local v145 = Container.AbsoluteCanvasSize.Y - Container.AbsoluteSize.Y;

    if v145 > 0 and (u33 < #u32 and v145 - Container.CanvasPosition.Y < 200) then
        Profiler.mark("UI.Loadout.RenderLoadoutTemplates");

        if not u50 then
            return;
        end;

        local Container2 = u50.Container.List.Container;
        local math_min_ret = math.min(u33 + 25, #u32);
        CreateMissingItemTemplates(Container2, u33 + 1, math_min_ret);
        u33 = math_min_ret;
        ApplySortedLayoutOrder(Container2);
    end;
end;

local function CalculateLoadoutInitialRenderCount() -- Line: 828
    -- upvalues: u50 (ref), CalculateGridRenderCount (copy)
    return not (u50 and u50.Visible) and 50 or CalculateGridRenderCount(u50.Container.List.Container);
end;

local function RenderInitialLoadoutTemplates() -- Line: 837
    -- upvalues: Profiler (copy), u50 (ref), u33 (ref), CalculateGridRenderCount (copy), u32 (ref), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy), u34 (ref)
    Profiler.mark("UI.Loadout.RenderInitialLoadoutTemplates");

    if not (u50 and u50.Visible) then
        return;
    end;

    local Container = u50.Container.List.Container;
    u33 = 0;
    local v146 = not (u50 and u50.Visible) and 50 or CalculateGridRenderCount(u50.Container.List.Container);
    local math_max_ret = math.max(v146, 50);
    local math_min_ret = math.min(math_max_ret, #u32);
    CreateMissingItemTemplates(Container, 1, math_min_ret);
    ApplySortedLayoutOrder(Container);
    u33 = math_min_ret;
    u34 = false;
end;

local function UpdateLoadoutTemplates() -- Line: 858
    -- upvalues: Profiler (copy), u50 (ref), u32 (ref), u33 (ref), u34 (ref), RenderInitialLoadoutTemplates (copy)
    Profiler.mark("UI.Loadout.UpdateLoadoutTemplates");

    if not u50 then
        return;
    end;

    local Container = u50.Container.List.Container;
    local v147 = {};

    for _, v in ipairs(u32) do
        v147[v] = true;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIPadding" and not v147[child.Name])) then
            child:Destroy();
        end;
    end;

    u33 = 0;
    u34 = true;

    if u50.Visible then
        RenderInitialLoadoutTemplates();
    end;
end;

local function RefreshSortedList() -- Line: 891
    -- upvalues: u50 (ref), u35 (ref), u34 (ref), u32 (ref), GetSortedLoadoutItemIds (copy), UpdateLoadoutTemplates (copy)
    if u50 and u50.Visible then
        u32 = GetSortedLoadoutItemIds();
        UpdateLoadoutTemplates();

        return;
    end;

    u35 = true;
    u34 = true;
end;

local function AnimateSortButton(p148: userdata, p149: boolean) -- Line: 904
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy)
    TweenService:Create(p148, TweenInfo_new_ret, {
        BackgroundTransparency = p149 and 0.85 or 1
    }):Play();
end;

local function FadeCategoryLabels(p150: userdata, p151: boolean) -- Line: 913
    -- upvalues: TweenService (copy)
    local TweenInfo_new_ret2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v152 = p151 and 0 or 1;

    for _, child in ipairs(p150:GetChildren()) do
        if child:IsA("Frame") and (child:FindFirstChild("Price") and child:FindFirstChild("WeaponName")) then
            local Price = child:FindFirstChild("Price");
            local WeaponName = child:FindFirstChild("WeaponName");
            TweenService:Create(Price, TweenInfo_new_ret2, {
                TextTransparency = v152
            }):Play();
            TweenService:Create(WeaponName, TweenInfo_new_ret2, {
                TextTransparency = v152
            }):Play();
        end;
    end;
end;

local function CloseAllDropdowns() -- Line: 934
    -- upvalues: u50 (ref)
    local DropdownContent = u50.Container.List.Top.Weapon.DropdownContent;
    u50.Container.List.Top.Filter.DropdownContent.Visible = false;
    DropdownContent.Visible = false;
end;

local function UpdateResetButtonVisibility() -- Line: 944
    -- upvalues: u50 (ref), u3 (ref), u6 (ref)
    local Reset = u50.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u50.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;
end;

local function CreateDropdownOption(p153: userdata, p154: string, p155: string, p156: number, p157: function) -- Line: 957
    -- upvalues: ReplicatedStorage (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local SortingTemplate = ReplicatedStorage.Assets.UI.Loadout:FindFirstChild("SortingTemplate");

    if not SortingTemplate then
        return nil;
    end;

    local u158 = SortingTemplate:Clone();
    u158.Name = p154;
    u158.LayoutOrder = p156;
    u158.BackgroundTransparency = 1;
    u158.Parent = p153;
    local Frame = u158:FindFirstChild("Frame");

    if Frame then
        local TextButton = Frame:FindFirstChild("TextButton");

        if TextButton then
            TextButton.Text = p155;
        end;

        Frame.BackgroundTransparency = 1;
        Frame.Active = false;
    end;

    u158.MouseEnter:Connect(function() -- Line: 988
        -- upvalues: u158 (copy), TweenService (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u158, TweenInfo_new_ret, {
            BackgroundTransparency = 0.85
        }):Play();
    end);
    u158.MouseLeave:Connect(function() -- Line: 991
        -- upvalues: u158 (copy), TweenService (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u158, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        }):Play();
    end);
    u158.MouseButton1Click:Connect(p157);

    return u158;
end;

local function ClearDropdownOptions(p159: userdata) -- Line: 1001
    for _, child in ipairs(p159:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy();
        end;
    end;
end;

local function GetWeaponsInCategory(p160: string?) -- Line: 1011
    -- upvalues: DataController (copy), LocalPlayer (copy), u38 (copy), u37 (copy), GetWeaponProperties (copy)
    local v161 = DataController.Get(LocalPlayer, "Inventory");

    if not v161 then
        return {};
    end;

    local v162 = {};

    for _, v in ipairs(v161) do
        if not (u38[v.Type] or u37[v.Name]) then
            local success, result = pcall(GetWeaponProperties, v.Name);

            if success and (result and (not p160 or result.Type == p160)) then
                v162[v.Name] = true;
            end;
        end;
    end;

    local v163 = {};

    for i in pairs(v162) do
        table.insert(v163, i);
    end;

    table.sort(v163);

    return v163;
end;

local function GetLoadoutCategoryForWeapon(p164: string) -- Line: 1042
    -- upvalues: GetWeaponProperties (copy), u36 (copy)
    local success, result = pcall(GetWeaponProperties, p164);

    if success and (result and result.Type) then
        return u36[result.Type];
    end;

    return nil;
end;

local function IsValidStarterPistol(p165: string, p166: any) -- Line: 1052
    -- upvalues: u49 (copy)
    local v167 = u49[p166];

    if v167 then
        return table.find(v167, p165) ~= nil;
    end;

    return false;
end;

local function IsMouseOverPlayerFrame(p168) -- Line: 1060
    -- upvalues: u50 (ref), PlayerGui (copy)
    local Teams = u50.Container.Teams;
    local GuiObjectsAtPosition = PlayerGui:GetGuiObjectsAtPosition(p168.X, p168.Y);

    for _, v in ipairs(GuiObjectsAtPosition) do
        if v.Name ~= "DragIcon" and (v == Teams or v:IsDescendantOf(Teams)) then
            return true;
        end;
    end;

    return false;
end;

local function CreateDragIcon(p169) -- Line: 1077
    -- upvalues: GetResolvedSkinInformation (copy), Skins (copy), UDim2_fromScale_ret (copy)
    local v170 = GetResolvedSkinInformation(p169.Name, p169.Skin);

    if not v170 then
        return nil;
    end;

    local v171 = Skins.GetWearImageForFloat(v170, p169.Float or 0.9999) or v170.imageAssetId or "";
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DragIcon";
    ImageLabel.Size = UDim2_fromScale_ret;
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = v171;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.ZIndex = 100;
    ImageLabel.Active = false;

    return ImageLabel;
end;

local function CleanupPendingDrag() -- Line: 1104
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

local u172 = {
    ["Counter-Terrorists"] = Color3.fromHex("5B9BFF"),
    Terrorists = Color3.fromHex("E5B84C")
};
local TweenInfo_new_ret2 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u173 = {};
local u174 = {};

local function AddDropOverlay(p175: userdata?, p176: boolean) -- Line: 1140
    -- upvalues: u172 (copy), u2 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), u174 (copy), u173 (copy)
    if not (p175 and p175:IsA("GuiObject")) then
        return;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = p176 and "DropHighlight" or "DropDim";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BorderSizePixel = 0;
    Frame.Active = false;
    Frame.Selectable = false;
    Frame.Interactable = false;
    Frame.ZIndex = 50;

    if p176 then
        local v177 = u172[u2] or u172["Counter-Terrorists"];
        Frame.BackgroundColor3 = v177;
        Frame.BackgroundTransparency = 0.85;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.Color = v177;
        UIStroke.Thickness = 2;
        UIStroke.Parent = Frame;
        local v178 = TweenService:Create(UIStroke, TweenInfo_new_ret2, {
            Transparency = 0.6
        });
        v178:Play();
        table.insert(u174, v178);
    else
        Frame.BackgroundColor3 = Color3.new(0, 0, 0);
        Frame.BackgroundTransparency = 0.45;
    end;

    Frame.Parent = p175;
    table.insert(u173, Frame);
end;

local function HideAllMoveFrames() -- Line: 1179
    -- upvalues: u174 (copy), u173 (copy)
    for _, v in u174 do
        v:Cancel();
    end;

    table.clear(u174);

    for _, v in u173 do
        v:Destroy();
    end;

    table.clear(u173);
end;

local function CleanupDrag() -- Line: 1193
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

    local v179 = u8;
    u8 = false;
    u10 = nil;
    u11 = nil;
    u12 = nil;
    HideAllMoveFrames();

    if v179 and not u26 then
        u1.RefreshSelectedWeapon();
    end;
end;

local u180 = nil;

local function ShowControllerClickShield() -- Line: 1228
    -- upvalues: u180 (ref), PlayerGui (copy)
    if u180 then
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
    u180 = ScreenGui;
end;

local function HideControllerClickShield() -- Line: 1254
    -- upvalues: u180 (ref), u21 (ref)
    local u181 = u180;

    if not u181 then
        return;
    end;

    task.delay(0.25, function() -- Line: 1259
        -- upvalues: u180 (ref), u181 (copy), u21 (ref)
        if u180 == u181 and not u21 then
            u180 = nil;
            u181:Destroy();
        end;
    end);
end;

local function EnableVirtualCursor(u182: userdata?) -- Line: 1275
    -- upvalues: u21 (ref), GuiService (copy), GamepadNavigation (copy), GamepadService (copy), ShowControllerClickShield (copy)
    if u21 then
        return;
    end;

    u21 = true;
    GuiService.AutoSelectGuiEnabled = false;
    GuiService.SelectedObject = nil;

    if u182 then
        GamepadNavigation.ScrollIntoView(u182);
    end;

    pcall(function() -- Line: 1287
        -- upvalues: GamepadService (ref), u182 (copy)
        GamepadService:EnableGamepadCursor(u182);
    end);
    ShowControllerClickShield();
end;

local function DisableVirtualCursor() -- Line: 1295
    -- upvalues: u21 (ref), GamepadService (copy), GuiService (copy), u180 (ref)
    if not u21 then
        return;
    end;

    u21 = false;
    pcall(function() -- Line: 1300
        -- upvalues: GamepadService (ref)
        GamepadService:DisableGamepadCursor();
    end);
    GuiService.AutoSelectGuiEnabled = true;
    local u183 = u180;

    if not u183 then
        return;
    end;

    task.delay(0.25, function() -- Line: 1259
        -- upvalues: u180 (ref), u183 (copy), u21 (ref)
        if u180 == u183 and not u21 then
            u180 = nil;
            u183:Destroy();
        end;
    end);
end;

local function CleanupControllerHeld(p184: boolean?) -- Line: 1311
    -- upvalues: u23 (ref), CleanupDrag (copy), u19 (ref), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u180 (ref), HideAllMoveFrames (copy), GamepadNavigation (copy)
    local v185 = u23;
    CleanupDrag();
    u19 = nil;
    u23 = nil;
    u22 = false;

    if u21 then
        u21 = false;
        pcall(function() -- Line: 1300
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
        GuiService.AutoSelectGuiEnabled = true;
        local u186 = u180;

        if u186 then
            task.delay(0.25, function() -- Line: 1259
                -- upvalues: u180 (ref), u186 (copy), u21 (ref)
                if u180 == u186 and not u21 then
                    u180 = nil;
                    u186:Destroy();
                end;
            end);
        end;
    end;

    HideAllMoveFrames();

    if p184 and (v185 and GamepadNavigation.IsUsable(v185)) then
        GamepadNavigation.ScrollIntoView(v185);
        GuiService.SelectedObject = v185;
    end;
end;

local function GetSlotIndexInList(p187: userdata, p188: userdata, p189: string) -- Line: 1331
    -- upvalues: DataController (copy), LocalPlayer (copy), u2 (ref)
    local v190 = DataController.Get(LocalPlayer, "Loadout");

    if v190 then
        v190 = v190[u2];
    end;

    local v191 = v190 and v190.Loadout and v190.Loadout[p189];

    if v191 then
        for i, v in ipairs(v191.Options) do
            if v == p187.Name then
                return i;
            end;
        end;
    end;

    local v192 = 0;

    for _, child in ipairs(p188:GetChildren()) do
        if child:IsA("GuiObject") then
            v192 = v192 + 1;

            if child == p187 then
                return v192;
            end;
        end;
    end;

    return 1;
end;

local function GetLoadoutSlotInfo(p193: userdata) -- Line: 1359
    -- upvalues: GetSlotIndexInList (copy)
    local Parent = p193.Parent;

    if not (Parent and Parent:IsA("Frame")) then
        return nil, nil;
    end;

    local Parent2 = Parent.Parent;
    local v194;

    if Parent2 then
        if Parent2.Name == "List" then
            v194 = Parent2.Parent;
        else
            v194 = false;
        end;
    else
        v194 = Parent2;
    end;

    if not (v194 and v194:IsA("Frame")) then
        return nil, nil;
    end;

    local Name = v194.Name;

    if Name == "Mid Tier" or (Name == "Pistols" or Name == "Rifles") then
        return Name, GetSlotIndexInList(Parent, Parent2, Name);
    end;

    return nil, nil;
end;

local function GetInventoryItemFromButton(p195: userdata) -- Line: 1385
    -- upvalues: GetInventoryItemFromIdentifier (copy)
    if p195 and p195:IsA("ImageButton") then
        return GetInventoryItemFromIdentifier(p195.Name);
    end;

    return nil;
end;

local function GetEquippedItemFromButton(p196: userdata) -- Line: 1391
    -- upvalues: GetLoadoutSlotInfo (copy), GetInventoryItemFromIdentifier (copy)
    local Parent = p196.Parent;

    if Parent and Parent:IsA("Frame") then
        local Name = Parent.Name;
        local v197, v198 = GetLoadoutSlotInfo(p196);

        if v197 and v198 then
            return GetInventoryItemFromIdentifier(Name), v197, v198;
        end;
    end;

    return nil, nil, nil;
end;

local u199 = { "Pistols", "Mid Tier", "Rifles" };

local function ShowGunSlotHighlights(p200: function) -- Line: 1411
    -- upvalues: u2 (ref), u50 (ref), u199 (copy), GetSlotIndexInList (copy), AddDropOverlay (copy)
    local v201 = u2 == "Counter-Terrorists" and "CT" or "T";
    local v202 = u50.Container.Teams:FindFirstChild(v201);
    local v203;

    if v202 then
        v203 = v202:IsA("Frame");
    else
        v203 = v202;
    end;

    local v204 = `[Loadout] Missing {v201} team panel`;
    assert(v203, v204);
    local Guns = v202:FindFirstChild("Guns");

    if not Guns then
        return;
    end;

    for _, v in u199 do
        local v205 = Guns:FindFirstChild(v);
        local v206;

        if v205 then
            v206 = v205:FindFirstChild("List");
        else
            v206 = v205;
        end;

        if v205 and v206 then
            local v207 = v;
            local v208 = false;

            for _, child in v206:GetChildren() do
                if child:IsA("Frame") and child:FindFirstChild("Button") then
                    local v209 = p200(v207, (GetSlotIndexInList(child, v206, v207)));
                    AddDropOverlay(child, v209);
                    v208 = v208 or v209;
                end;
            end;

            AddDropOverlay(v205:FindFirstChild("Title"), v208);
        end;
    end;
end;

local function GetEquipmentSlotForItem(p210) -- Line: 1443
    -- upvalues: u39 (copy), GetWeaponProperties (copy), u40 (copy), u2 (ref), u50 (ref)
    local v211 = u39[p210.Type];

    if not v211 then
        local success, success = pcall(GetWeaponProperties, p210.Name);

        if success then
            if success then
                success = success.Class;
            end;
        end;

        v211 = success == "Melee" and "Equipped Melee" or (success == "Glove" and "Equipped Gloves" or nil);
    end;

    if v211 then
        v211 = u40[v211];
    end;

    if not v211 then
        return nil;
    end;

    local v212 = u2 == "Counter-Terrorists" and "CT" or "T";
    local v213 = u50.Container.Teams:FindFirstChild(v212);
    local v214;

    if v213 then
        v214 = v213:IsA("Frame");
    else
        v214 = v213;
    end;

    local v215 = `[Loadout] Missing {v212} team panel`;
    assert(v214, v215);
    local Equipments = v213:FindFirstChild("Equipments");

    if Equipments then
        Equipments = Equipments:FindFirstChild(v211);
    end;

    if Equipments and Equipments:IsA("GuiObject") then
        return Equipments;
    end;

    return nil;
end;

local function ShowMoveFramesForItem(p216) -- Line: 1475
    -- upvalues: HideAllMoveFrames (copy), GetEquipmentSlotForItem (copy), u39 (copy), AddDropOverlay (copy), u2 (ref), u50 (ref), ShowGunSlotHighlights (copy), GetWeaponProperties (copy), u36 (copy), u49 (copy)
    HideAllMoveFrames();
    local v217 = GetEquipmentSlotForItem(p216);

    if u39[p216.Type] ~= nil and true or v217 ~= nil then
        AddDropOverlay(v217, true);
        local v218 = u2 == "Counter-Terrorists" and "CT" or "T";
        local v219 = u50.Container.Teams:FindFirstChild(v218);
        local v220;

        if v219 then
            v220 = v219:IsA("Frame");
        else
            v220 = v219;
        end;

        local v221 = `[Loadout] Missing {v218} team panel`;
        assert(v220, v221);
        AddDropOverlay(v219:FindFirstChild("Viewport"), true);
        ShowGunSlotHighlights(function() -- Line: 1484
            return false;
        end);

        return;
    end;

    local success, result = pcall(GetWeaponProperties, p216.Name);
    local u222;

    if success and (result and result.Type) then
        u222 = u36[result.Type];
    else
        u222 = nil;
    end;

    if not u222 then
        return;
    end;

    local Name = p216.Name;
    local v223 = u2;
    local u224;

    if Name and (type(Name) == "string" and Name ~= "") then
        local v225;
        u224, v225 = pcall(GetWeaponProperties, Name);

        if u224 then
            if v225 == nil or v225.Team == nil then
                u224 = false;
            else
                u224 = v225.Team == "Both" and true or v225.Team == v223;
            end;
        end;
    else
        u224 = false;
    end;

    local Name2 = p216.Name;
    local v226 = u49[u2];
    local u227;

    if v226 then
        u227 = table.find(v226, Name2) ~= nil;
    else
        u227 = false;
    end;

    ShowGunSlotHighlights(function(p228: string, p229: number) -- Line: 1497
        -- upvalues: u224 (copy), u222 (copy), u227 (copy)
        if not u224 or p228 ~= u222 then
            return false;
        end;

        local v230;

        if p228 == "Pistols" and p229 == 1 then
            v230 = not u227;
        else
            v230 = false;
        end;

        return not v230;
    end);
end;

local u231 = nil;

local function GetDropTargetCategory(p232) -- Line: 1515
    -- upvalues: u19 (ref), GetInventoryItemFromIdentifier (copy), u11 (ref), GetWeaponProperties (copy), u36 (copy), u50 (ref), PlayerGui (copy), GetSlotIndexInList (copy)
    local v233 = u19 and GetInventoryItemFromIdentifier(u19);
    local v234 = u11;

    if v234 then
        v233 = v234;
    elseif v233 then
        v233 = v233.Name;
    end;

    if not v233 then
        return nil, nil;
    end;

    local success, result = pcall(GetWeaponProperties, v233);
    local v235;

    if success and (result and result.Type) then
        v235 = u36[result.Type];
    else
        v235 = nil;
    end;

    if not v235 then
        return nil, nil;
    end;

    local Teams = u50.Container.Teams;
    local GuiObjectsAtPosition = PlayerGui:GetGuiObjectsAtPosition(p232.X, p232.Y);
    local v236 = nil;
    local v237 = false;

    for _, v in ipairs(GuiObjectsAtPosition) do
        if v.Name ~= "DragIcon" then
            v237 = (v == Teams or v:IsDescendantOf(Teams)) and true or v237;

            if not v236 then
                local v238 = v;

                while v238 and v238 ~= Teams do
                    local Parent = v238.Parent;

                    if Parent and Parent.Name == "List" then
                        local Parent2 = Parent.Parent;

                        if Parent2 and Parent2.Name == v235 then
                            v236 = GetSlotIndexInList(v238, Parent, v235);
                        end;

                        break;
                    end;

                    v238 = Parent;
                end;
            end;
        end;
    end;

    if v237 then
        return v235, v236;
    end;

    return nil, nil;
end;

local function GetCurrentCategoryOptions(p239: string) -- Line: 1568
    -- upvalues: DataController (copy), LocalPlayer (copy), u2 (ref)
    local v240 = DataController.Get(LocalPlayer, "Loadout");

    if v240 then
        v240 = v240[u2];
    end;

    if v240 and (v240.Loadout and v240.Loadout[p239]) then
        return v240.Loadout[p239].Options;
    end;

    return nil;
end;

local function IsItemEquippedInCategory(p241: string, p242: string) -- Line: 1577
    -- upvalues: DataController (copy), LocalPlayer (copy), u2 (ref)
    local v243 = ipairs;
    local v244 = DataController.Get(LocalPlayer, "Loadout");

    if v244 then
        v244 = v244[u2];
    end;

    local v245;

    if v244 and (v244.Loadout and v244.Loadout[p242]) then
        v245 = v244.Loadout[p242].Options;
    else
        v245 = nil;
    end;

    for i, v in v243(v245 or {}) do
        if v == p241 then
            return true, i;
        end;
    end;

    return false, nil;
end;

local function IsWeaponEquippedInCategory(p246: string, p247: string) -- Line: 1589
    -- upvalues: DataController (copy), LocalPlayer (copy), u2 (ref), GetInventoryItemFromIdentifier (copy)
    local v248 = DataController.Get(LocalPlayer, "Loadout");

    if v248 then
        v248 = v248[u2];
    end;

    local v249;

    if v248 and (v248.Loadout and v248.Loadout[p247]) then
        v249 = v248.Loadout[p247].Options;
    else
        v249 = nil;
    end;

    if not v249 then
        return false, nil, nil;
    end;

    for i, v in ipairs(v249) do
        if v and v ~= "" then
            local v250 = GetInventoryItemFromIdentifier(v);

            if v250 and v250.Name == p246 then
                return true, i, v;
            end;
        end;
    end;

    return false, nil, nil;
end;

local function RefreshSelectedWeaponIfIdle() -- Line: 1613
    -- upvalues: u8 (ref), u19 (ref), u1 (copy)
    if not (u8 or u19) then
        u1.RefreshSelectedWeapon();
    end;
end;

local function SendEquipRequest(p251: any, p252: table) -- Line: 1620
    -- upvalues: u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy)
    if u26 then
        return false;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u253 = u27;
    p251.Send(p252);
    task.delay(5, function() -- Line: 1629
        -- upvalues: u253 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u253 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);

    return true;
end;

local function EquipLoadoutSkin(p254: string, p255: number, p256: string) -- Line: 1640
    -- upvalues: Remotes (copy), u2 (ref), u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy)
    local v257 = {
        Type = p254,
        Slot = p255 - 1,
        Team = u2,
        Identifier = p256
    };

    if u26 then
        return false;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u258 = u27;
    Remotes.Inventory.EquipLoadoutSkin.Send(v257);
    task.delay(5, function() -- Line: 1629
        -- upvalues: u258 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u258 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);

    return true;
end;

local function SwapLoadoutSkins(p259: string, p260: number, p261: number) -- Line: 1649
    -- upvalues: Remotes (copy), u2 (ref), u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy)
    local v262 = {
        Type = p259,
        SlotOne = p260 - 1,
        SlotTwo = p261 - 1,
        Team = u2
    };

    if u26 then
        return false;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u263 = u27;
    Remotes.Inventory.SwapLoadoutSkins.Send(v262);
    task.delay(5, function() -- Line: 1629
        -- upvalues: u263 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u263 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);

    return true;
end;

local function EquipSpecialItem(p264: string, p265: string) -- Line: 1660
    -- upvalues: Remotes (copy), u2 (ref), u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy)
    local v266 = {
        Path = p264,
        Team = u2,
        Identifier = p265
    };

    if u26 then
        return false;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u267 = u27;
    Remotes.Inventory.EquipSpecialItem.Send(v266);
    task.delay(5, function() -- Line: 1629
        -- upvalues: u267 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u267 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);

    return true;
end;

local function GetSpecialItemPathByClass(p268: string) -- Line: 1669
    -- upvalues: GetWeaponProperties (copy)
    local success, success = pcall(GetWeaponProperties, p268);

    if success then
        if success then
            success = success.Class;
        end;
    end;

    return success == "Melee" and "Equipped Melee" or (success == "Glove" and "Equipped Gloves" or nil);
end;

local function u271() -- Line: 1680
    -- upvalues: u50 (ref), u19 (ref), u23 (ref), CleanupDrag (copy), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u180 (ref), HideAllMoveFrames (copy), GamepadNavigation (copy), CloseButtonRegistry (copy)
    if not (u50 and u50.Visible) then
        return;
    end;

    if u19 then
        local v269 = u23;
        CleanupDrag();
        u19 = nil;
        u23 = nil;
        u22 = false;

        if u21 then
            u21 = false;
            pcall(function() -- Line: 1300
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
            local u270 = u180;

            if u270 then
                task.delay(0.25, function() -- Line: 1259
                    -- upvalues: u180 (ref), u270 (copy), u21 (ref)
                    if u180 == u270 and not u21 then
                        u180 = nil;
                        u270:Destroy();
                    end;
                end);
            end;
        end;

        HideAllMoveFrames();

        if v269 and GamepadNavigation.IsUsable(v269) then
            GamepadNavigation.ScrollIntoView(v269);
            GuiService.SelectedObject = v269;
        end;

        CloseButtonRegistry.MarkUsed();
    end;
end;

local function ConnectGamepadPickUp(u272: userdata) -- Line: 1696
    -- upvalues: u19 (ref), u26 (ref), u25 (ref), u231 (ref)
    u272.Activated:Connect(function(p273) -- Line: 1697
        -- upvalues: u19 (ref), u26 (ref), u25 (ref), u231 (ref), u272 (copy)
        if p273 and (p273.UserInputType == Enum.UserInputType.Gamepad1 and not (u19 or (u26 or os.clock() - u25 <= 0.25))) then
            u231(u272);
        end;
    end);
end;

local function ConnectButtonActivation(p274: userdata, u275: function) -- Line: 1711
    p274.MouseButton1Click:Connect(u275);
    p274.Activated:Connect(function(p276) -- Line: 1713
        -- upvalues: u275 (copy)
        if p276 and p276.UserInputType == Enum.UserInputType.Gamepad1 then
            u275();
        end;
    end);
end;

function u1.HandleSpecialItemDrop() -- Line: 1723
    -- upvalues: u10 (ref), u12 (ref), u39 (copy), u11 (ref), GetWeaponProperties (copy), Remotes (copy), u2 (ref), u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy)
    if not (u10 and u12) then
        return;
    end;

    local v277 = u39[u12];

    if not v277 and u11 then
        local success, success = pcall(GetWeaponProperties, u11);

        if success then
            if success then
                success = success.Class;
            end;
        end;

        v277 = success == "Melee" and "Equipped Melee" or (success == "Glove" and "Equipped Gloves" or nil);
    end;

    if not v277 then
        return;
    end;

    local v278 = {
        Path = v277,
        Team = u2,
        Identifier = u10
    };

    if u26 then
        return;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u279 = u27;
    Remotes.Inventory.EquipSpecialItem.Send(v278);
    task.delay(5, function() -- Line: 1629
        -- upvalues: u279 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u279 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);
end;

function u1.HandleDrop(p280: string, p281: number?) -- Line: 1742
    -- upvalues: u10 (ref), u11 (ref), u2 (ref), GetWeaponProperties (copy), u36 (copy), DataController (copy), LocalPlayer (copy), u49 (copy), IsItemEquippedInCategory (copy), Remotes (copy), u26 (ref), u27 (ref), u8 (ref), u19 (ref), u1 (copy), IsWeaponEquippedInCategory (copy)
    if not (u10 and u11) then
        return;
    end;

    local v282 = u11;
    local v283 = u2;
    local v284;

    if v282 and (type(v282) == "string" and v282 ~= "") then
        local v285;
        v284, v285 = pcall(GetWeaponProperties, v282);

        if v284 then
            if v285 == nil or v285.Team == nil then
                v284 = false;
            else
                v284 = v285.Team == "Both" and true or v285.Team == v283;
            end;
        end;
    else
        v284 = false;
    end;

    if not v284 then
        return;
    end;

    local success, result = pcall(GetWeaponProperties, u11);
    local v286;

    if success and (result and result.Type) then
        v286 = u36[result.Type];
    else
        v286 = nil;
    end;

    if v286 ~= p280 then
        return;
    end;

    local v287 = DataController.Get(LocalPlayer, "Loadout");

    if v287 then
        v287 = v287[u2];
    end;

    local v288;

    if v287 and (v287.Loadout and v287.Loadout[p280]) then
        v288 = v287.Loadout[p280].Options;
    else
        v288 = nil;
    end;

    if not v288 then
        return;
    end;

    local v289;

    if p280 == "Pistols" then
        local v290 = u11;
        local v291 = u49[u2];
        local v292;

        if v291 then
            v292 = table.find(v291, v290) ~= nil;
        else
            v292 = false;
        end;

        v289 = v292 and 1 or 2;
    else
        v289 = 1;
    end;

    local v293, v294 = IsItemEquippedInCategory(u10, p280);

    if v293 and v294 then
        if p281 and (v289 <= p281 and (p281 <= #v288 and v294 ~= p281)) then
            local v295 = {
                Type = p280,
                SlotOne = v294 - 1,
                SlotTwo = p281 - 1,
                Team = u2
            };

            if u26 then
                return;
            end;

            u26 = true;
            u27 = u27 + 1;
            local u296 = u27;
            Remotes.Inventory.SwapLoadoutSkins.Send(v295);
            task.delay(5, function() -- Line: 1629
                -- upvalues: u296 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
                if u296 ~= u27 or not u26 then
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

    local v297, v298 = IsWeaponEquippedInCategory(u11, p280);

    if v297 and v298 then
        local v299 = {
            Type = p280,
            Slot = v298 - 1,
            Team = u2,
            Identifier = u10
        };

        if u26 then
            return;
        end;

        u26 = true;
        u27 = u27 + 1;
        local u300 = u27;
        Remotes.Inventory.EquipLoadoutSkin.Send(v299);
        task.delay(5, function() -- Line: 1629
            -- upvalues: u300 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
            if u300 ~= u27 or not u26 then
                return;
            end;

            u26 = false;

            if not (u8 or u19) then
                u1.RefreshSelectedWeapon();
            end;
        end);

        return;
    end;

    if p281 and p281 < v289 then
        return;
    end;

    if v289 <= #v288 then
        v289 = math.clamp(p281 or v289, v289, #v288);
    end;

    local v301 = {
        Type = p280,
        Slot = v289 - 1,
        Team = u2,
        Identifier = u10
    };

    if u26 then
        return;
    end;

    u26 = true;
    u27 = u27 + 1;
    local u302 = u27;
    Remotes.Inventory.EquipLoadoutSkin.Send(v301);
    task.delay(5, function() -- Line: 1629
        -- upvalues: u302 (copy), u27 (ref), u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        if u302 ~= u27 or not u26 then
            return;
        end;

        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);
end;

local function StartItemDrag(p303) -- Line: 1803
    -- upvalues: CreateDragIcon (copy), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), ShowMoveFramesForItem (copy), u1 (copy), PlayerGui (copy), UserInputService (copy), Vector2_new_ret (copy), u13 (ref), RunServiceController (copy)
    local v304 = CreateDragIcon(p303);

    if not v304 then
        return false;
    end;

    u8 = true;
    u9 = v304;
    u10 = p303._id;
    u11 = p303.Name;
    u12 = p303.Type;
    ShowMoveFramesForItem(p303);
    u1.SetSelectedWeapon(p303, true);
    v304.Parent = PlayerGui:FindFirstChild("MainGui") or PlayerGui;
    local MouseLocation = UserInputService:GetMouseLocation();
    v304.Position = UDim2.fromOffset(MouseLocation.X + Vector2_new_ret.X, MouseLocation.Y + Vector2_new_ret.Y);
    u13 = RunServiceController.BindToRenderStep("UI.Loadout.DragIcon", function() -- Line: 1828
        -- upvalues: u9 (ref), UserInputService (ref), Vector2_new_ret (ref)
        if u9 then
            local MouseLocation2 = UserInputService:GetMouseLocation();
            u9.Position = UDim2.fromOffset(MouseLocation2.X + Vector2_new_ret.X, MouseLocation2.Y + Vector2_new_ret.Y);
        end;
    end);

    return true;
end;

local function BeginActualDrag(p305) -- Line: 1841
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

    StartItemDrag(p305);
end;

function u1.OnItemMouseDown(p306: string, p307: boolean?, p308: userdata?) -- Line: 1855
    -- upvalues: UserInputService (copy), u19 (ref), u25 (ref), u8 (ref), u14 (ref), u15 (ref), u17 (ref), u18 (ref), u16 (ref), RunServiceController (copy), GetInventoryItemFromIdentifier (copy), StartItemDrag (copy)
    local MouseLocation = UserInputService:GetMouseLocation();

    if u19 or os.clock() - u25 < 0.25 then
        return;
    end;

    if u8 or u14 then
        return;
    end;

    u14 = p306;
    u15 = MouseLocation;
    u17 = p307 or false;
    u18 = p308;
    u16 = RunServiceController.BindToRenderStep("UI.Loadout.PendingDrag", function() -- Line: 1876
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
                local v309 = u14;

                if u16 then
                    u16:Disconnect();
                    u16 = nil;
                end;

                u14 = nil;
                u15 = nil;
                u17 = false;
                u18 = nil;

                if v309 then
                    v309 = GetInventoryItemFromIdentifier(v309);
                end;

                if v309 then
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

                        StartItemDrag(v309);
                    end;
                end;
            end;
        end;
    end);
end;

function u1.OnItemClick(p310) -- Line: 1901
    -- upvalues: u6 (ref), u1 (copy)
    u6 = nil;
    u1.SortByWeapon(p310.Name);
end;

local function DropDraggedItem() -- Line: 1910
    -- upvalues: UserInputService (copy), GuiService (copy), u12 (ref), u39 (copy), u11 (ref), GetWeaponProperties (copy), IsMouseOverPlayerFrame (copy), u1 (copy), GetDropTargetCategory (copy)
    local MouseLocation = UserInputService:GetMouseLocation();
    local GuiInset = GuiService:GetGuiInset();
    local Vector2_new_ret2 = Vector2.new(MouseLocation.X - GuiInset.X, MouseLocation.Y - GuiInset.Y);
    local v311 = u12 and u39[u12];

    if not v311 and u11 then
        local success, result = pcall(GetWeaponProperties, u11);
        v311 = success and (result and (result.Class == "Melee" or result.Class == "Glove")) and true or v311;
    end;

    if v311 and IsMouseOverPlayerFrame(Vector2_new_ret2) then
        u1.HandleSpecialItemDrop();

        return;
    end;

    if not v311 then
        local v312, v313 = GetDropTargetCategory(Vector2_new_ret2);

        if v312 then
            u1.HandleDrop(v312, v313);
        end;
    end;
end;

function u1.EndDrag() -- Line: 1939
    -- upvalues: u14 (ref), u8 (ref), u17 (ref), u18 (ref), UserInputService (copy), u16 (ref), u15 (ref), GetInventoryItemFromIdentifier (copy), u1 (copy), ShowContextMenu (copy), DropDraggedItem (copy), CleanupDrag (copy)
    if not u14 or u8 then
        if not u8 then
            return;
        end;

        DropDraggedItem();
        CleanupDrag();

        return;
    end;

    local v314 = u14;
    local v315 = u17;
    local v316 = u18;
    local MouseLocation = UserInputService:GetMouseLocation();

    if u16 then
        u16:Disconnect();
        u16 = nil;
    end;

    u14 = nil;
    u15 = nil;
    u17 = false;
    u18 = nil;

    if v314 then
        v314 = GetInventoryItemFromIdentifier(v314);
    end;

    if not v314 then
        return;
    end;

    if v315 then
        u1.OnItemClick(v314);

        return;
    end;

    ShowContextMenu(v314, MouseLocation, v316, false);
end;

u231 = function(u317: userdata) -- Line: 1975
    -- upvalues: CleanupDrag (copy), GetInventoryItemFromIdentifier (copy), GetLoadoutSlotInfo (copy), u19 (ref), u23 (ref), u24 (ref), u22 (ref), u21 (ref), GuiService (copy), GamepadNavigation (copy), GamepadService (copy), ShowControllerClickShield (copy), StartItemDrag (copy), u180 (ref), HideAllMoveFrames (copy)
    CleanupDrag();
    local v318;

    if u317 and u317:IsA("ImageButton") then
        v318 = GetInventoryItemFromIdentifier(u317.Name);
    else
        v318 = nil;
    end;

    if not v318 then
        local Parent = u317.Parent;

        if Parent and Parent:IsA("Frame") then
            local Name = Parent.Name;
            local v319, v320 = GetLoadoutSlotInfo(u317);

            if v319 and v320 then
                v318 = GetInventoryItemFromIdentifier(Name);
            else
                v318 = nil;
            end;
        else
            v318 = nil;
        end;
    end;

    if not v318 then
        return;
    end;

    u19 = v318._id;
    u23 = u317;
    u24 = os.clock();
    u22 = false;

    if not u21 then
        u21 = true;
        GuiService.AutoSelectGuiEnabled = false;
        GuiService.SelectedObject = nil;

        if u317 then
            GamepadNavigation.ScrollIntoView(u317);
        end;

        pcall(function() -- Line: 1287
            -- upvalues: GamepadService (ref), u317 (copy)
            GamepadService:EnableGamepadCursor(u317);
        end);
        ShowControllerClickShield();
    end;

    if not StartItemDrag(v318) then
        local v321 = u23;
        CleanupDrag();
        u19 = nil;
        u23 = nil;
        u22 = false;

        if u21 then
            u21 = false;
            pcall(function() -- Line: 1300
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
            local u322 = u180;

            if u322 then
                task.delay(0.25, function() -- Line: 1259
                    -- upvalues: u180 (ref), u322 (copy), u21 (ref)
                    if u180 == u322 and not u21 then
                        u180 = nil;
                        u322:Destroy();
                    end;
                end);
            end;
        end;

        HideAllMoveFrames();

        if v321 and GamepadNavigation.IsUsable(v321) then
            GamepadNavigation.ScrollIntoView(v321);
            GuiService.SelectedObject = v321;
        end;
    end;
end;

local function u325() -- Line: 1998
    -- upvalues: u25 (ref), u8 (ref), DropDraggedItem (copy), u23 (ref), CleanupDrag (copy), u19 (ref), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u180 (ref), HideAllMoveFrames (copy), GamepadNavigation (copy)
    u25 = os.clock();

    if u8 then
        DropDraggedItem();
    end;

    local v323 = u23;
    CleanupDrag();
    u19 = nil;
    u23 = nil;
    u22 = false;

    if u21 then
        u21 = false;
        pcall(function() -- Line: 1300
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
        GuiService.AutoSelectGuiEnabled = true;
        local u324 = u180;

        if u324 then
            task.delay(0.25, function() -- Line: 1259
                -- upvalues: u180 (ref), u324 (copy), u21 (ref)
                if u180 == u324 and not u21 then
                    u180 = nil;
                    u324:Destroy();
                end;
            end);
        end;
    end;

    HideAllMoveFrames();

    if v323 and GamepadNavigation.IsUsable(v323) then
        GamepadNavigation.ScrollIntoView(v323);
        GuiService.SelectedObject = v323;
    end;
end;

local function InspectInventoryItem(p326) -- Line: 2010
    -- upvalues: u44 (copy), Router (copy), u30 (ref), u28 (ref), u29 (ref)
    local v327;

    if p326 == nil then
        v327 = false;
    else
        v327 = u44[p326.Type] == true;
    end;

    if not v327 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");

    if u30 then
        u30.Visible = false;
    end;

    u28 = nil;
    u29 = nil;
    Router.broadcastRouter("WeaponInspect", p326.Name, p326.Skin, p326.Float, p326.StatTrack, p326.NameTag, p326.Charm, p326.Stickers, p326.Type, p326.Pattern, p326._id, p326.Serial, p326.IsTradeable);
end;

function u1.CreateItemTemplate(p328) -- Line: 2035
    -- upvalues: Profiler (copy), GetResolvedSkinInformation (copy), ReplicatedStorage (copy), Rarities (copy), u50 (ref), Skins (copy), GetSkinDisplayName (copy), script_ItemIcon (copy), u1 (copy), UserInputService (copy), GetInventoryItemFromIdentifier (copy), ShowContextMenu (copy), u19 (ref), u26 (ref), u25 (ref), u231 (ref), UpdateStatusFrame (copy)
    Profiler.mark("UI.Loadout.CreateItemTemplate");
    local _id = p328._id;
    local v329 = GetResolvedSkinInformation(p328.Name, p328.Skin);

    if v329 then
        local u330 = ReplicatedStorage.Assets.UI.Loadout.ItemTemplate:Clone();
        u330.ItemContent.Rarity.BackgroundColor3 = Rarities[v329.rarity].Color;
        u330.Parent = u50.Container.List.Container;
        local v331 = Skins.GetWearImageForFloat(v329, p328.Float or 0.9999) or (v329.imageAssetId or "");
        u330.ItemContent.Content.Icon.Image = v331;
        local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(p328.Name, p328.NameTag);

        if p328.StatTrack then
            WeaponDisplayName = "KillTrak™ " .. WeaponDisplayName or WeaponDisplayName;
        end;

        if p328.Type == "Melee" then
            WeaponDisplayName = "★ " .. WeaponDisplayName;
        end;

        GetSkinDisplayName.ApplyNameLabel(u330.Bottom.Footer.WeaponName, WeaponDisplayName, p328.NameTag);
        u330.Bottom.Footer.SkinName.Text = GetSkinDisplayName(p328.Skin);
        u330.Name = _id;
        local Icon = u330.ItemContent.Content.Icon;
        local v332 = script_ItemIcon.CreateIconDropShadow(Icon, script_ItemIcon.GetDropShadowImageForItem(p328, v331), u330.ItemContent.Content);
        local v333, v334 = script_ItemIcon.CreateIconHoverTweens(Icon, v332);
        u330.MouseEnter:Connect(v333);
        u330.MouseLeave:Connect(v334);
        u330.MouseButton1Down:Connect(function() -- Line: 2074
            -- upvalues: u1 (ref), _id (copy), u330 (copy)
            u1.OnItemMouseDown(_id, false, u330);
        end);
        u330.MouseButton2Click:Connect(function() -- Line: 2078
            -- upvalues: UserInputService (ref), GetInventoryItemFromIdentifier (ref), _id (copy), ShowContextMenu (ref), u330 (copy)
            local MouseLocation = UserInputService:GetMouseLocation();
            local v335 = GetInventoryItemFromIdentifier(_id);

            if v335 then
                ShowContextMenu(v335, MouseLocation, u330, false);
            end;
        end);
        u330.Selectable = true;
        u330.SelectionGained:Connect(v333);
        u330.SelectionLost:Connect(v334);
        u330.Activated:Connect(function(p336) -- Line: 1697
            -- upvalues: u19 (ref), u26 (ref), u25 (ref), u231 (ref), u330 (copy)
            if p336 and (p336.UserInputType == Enum.UserInputType.Gamepad1 and not (u19 or (u26 or os.clock() - u25 <= 0.25))) then
                u231(u330);
            end;
        end);
        UpdateStatusFrame(u330, _id);
    end;
end;

function u1.CreateLoadoutTemplate(p337, p338, p339) -- Line: 2098
    -- upvalues: Profiler (copy), GetResolvedSkinInformation (copy), GetWeaponProperties (copy), ReplicatedStorage (copy), Rarities (copy), Skins (copy), GetSkinDisplayName (copy), script_ItemIcon (copy), u1 (copy), UserInputService (copy), GetInventoryItemFromIdentifier (copy), ShowContextMenu (copy), u172 (copy), u8 (ref), u19 (ref), u26 (ref), u25 (ref), u231 (ref), InspectInventoryItem (copy)
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
        u342.Button.MouseButton1Down:Connect(function() -- Line: 2148
            -- upvalues: u1 (ref), _id (copy), u342 (copy)
            u1.OnItemMouseDown(_id, true, u342);
        end);
        u342.Button.MouseButton2Click:Connect(function() -- Line: 2151
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

        local u352 = u172[p339] or u172["Counter-Terrorists"];

        local function setCardLit(p353: boolean) -- Line: 2163
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

        u342.Button.MouseEnter:Connect(function() -- Line: 2172
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
        u342.Button.MouseLeave:Connect(function() -- Line: 2179
            -- upvalues: u350 (copy), u351 (copy)
            if u350 and u351 then
                u350.Color = u351;
            end;
        end);
        u342.Button.Selectable = true;
        u342.Button.SelectionGained:Connect(function() -- Line: 2184
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
        u342.Button.SelectionLost:Connect(function() -- Line: 2192
            -- upvalues: u348 (copy), u350 (copy), u351 (copy)
            u348();

            if u350 and u351 then
                u350.Color = u351;
            end;
        end);
        local Button = u342.Button;
        Button.Activated:Connect(function(p357) -- Line: 1697
            -- upvalues: u19 (ref), u26 (ref), u25 (ref), u231 (ref), Button (copy)
            if p357 and (p357.UserInputType == Enum.UserInputType.Gamepad1 and not (u19 or (u26 or os.clock() - u25 <= 0.25))) then
                u231(Button);
            end;
        end);
        local Inspect = u342:FindFirstChild("Inspect");

        if Inspect and Inspect:IsA("GuiButton") then
            local function u359() -- Line: 2201
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
            Inspect.Activated:Connect(function(p360) -- Line: 1713
                -- upvalues: u359 (copy)
                if p360 and p360.UserInputType == Enum.UserInputType.Gamepad1 then
                    u359();
                end;
            end);
        end;
    end;
end;

function u1.PopulateWeaponDropdown() -- Line: 2216
    -- upvalues: u50 (ref), ClearDropdownOptions (copy), CreateDropdownOption (copy), u1 (copy), GetWeaponsInCategory (copy), u3 (ref)
    local Scroll = u50.Container.List.Top.Weapon.DropdownContent.Scroll;

    if not (Scroll and (Scroll:IsA("Frame") or Scroll:IsA("ScrollingFrame"))) then
        return;
    end;

    ClearDropdownOptions(Scroll);
    CreateDropdownOption(Scroll, "All", "All Weapons", 0, function() -- Line: 2227
        -- upvalues: u1 (ref), Scroll (copy)
        u1.SortByWeapon(nil);
        Scroll.Parent.Visible = false;
    end);
    local v361 = GetWeaponsInCategory(u3);

    for i, v in ipairs(v361) do
        CreateDropdownOption(Scroll, v, v, i, function() -- Line: 2235
            -- upvalues: u1 (ref), v (copy), Scroll (copy)
            u1.SortByWeapon(v);
            Scroll.Parent.Visible = false;
        end);
    end;
end;

function u1.SortByCategory(p362: string?) -- Line: 2244
    -- upvalues: u3 (ref), u7 (ref), u6 (ref), u50 (ref), u1 (copy), u35 (ref), u34 (ref), u32 (ref), GetSortedLoadoutItemIds (copy), UpdateLoadoutTemplates (copy)
    u3 = p362;
    u7 = nil;
    u6 = nil;
    u50.Container.List.Top.Filter.Container.Left.Title.Text = p362 or "All Categories";
    u1.PopulateWeaponDropdown();
    u50.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";
    local Reset = u50.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u50.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;

    if u50 and u50.Visible then
        u32 = GetSortedLoadoutItemIds();
        UpdateLoadoutTemplates();

        return;
    end;

    u35 = true;
    u34 = true;
end;

function u1.SortByWeapon(p363: string?, p364: string?) -- Line: 2260
    -- upvalues: u7 (ref), u6 (ref), u50 (ref), Sort (copy), u4 (ref), LocalPlayer (copy), u116 (ref), u35 (ref), u34 (ref), u32 (ref), GetSortedLoadoutItemIds (copy), UpdateLoadoutTemplates (copy), u3 (ref)
    u7 = p363 and ({
        weaponName = p363,
        skinName = p364
    } or nil) or nil;
    u6 = nil;
    u50.Container.List.Top.Weapon.Container.Left.Title.Text = p363 or "All Weapons";

    if Sort.GetSortComparisonFunction(u4, LocalPlayer, function() -- Line: 2267
        -- upvalues: u116 (ref)
        return u116;
    end) then
        if u50 and u50.Visible then
            u32 = GetSortedLoadoutItemIds();
            UpdateLoadoutTemplates();
        else
            u35 = true;
            u34 = true;
        end;
    end;

    local Reset = u50.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u50.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;
end;

function u1.SortBySkinMetadata(p365: string) -- Line: 2279
    -- upvalues: Profiler (copy), u4 (ref), u50 (ref), Sort (copy), LocalPlayer (copy), u116 (ref), u35 (ref), u34 (ref), u32 (ref), GetSortedLoadoutItemIds (copy), UpdateLoadoutTemplates (copy)
    Profiler.mark("UI.Loadout.SortBySkinMetadata");
    u4 = p365;
    u50.Container.List.Top.Filter.Container.Left.Title.Text = p365;

    if Sort.GetSortComparisonFunction(p365, LocalPlayer, function() -- Line: 2284
        -- upvalues: u116 (ref)
        return u116;
    end) then
        if not (u50 and u50.Visible) then
            u35 = true;
            u34 = true;

            return;
        end;

        u32 = GetSortedLoadoutItemIds();
        UpdateLoadoutTemplates();
    end;
end;

function u1.UpdateInventoryContainer() -- Line: 2294
    -- upvalues: Profiler (copy), u50 (ref), u35 (ref), u34 (ref), u19 (ref), GetInventoryItemFromIdentifier (copy), u23 (ref), CleanupDrag (copy), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u180 (ref), HideAllMoveFrames (copy), GamepadNavigation (copy), DataController (copy), LocalPlayer (copy), u28 (ref), u30 (ref), u29 (ref), u1 (copy), u4 (ref)
    Profiler.mark("UI.Loadout.UpdateInventoryContainer");

    if not u50 then
        return;
    end;

    if not u50.Visible then
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
            pcall(function() -- Line: 1300
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
            local u367 = u180;

            if u367 then
                task.delay(0.25, function() -- Line: 1259
                    -- upvalues: u180 (ref), u367 (copy), u21 (ref)
                    if u180 == u367 and not u21 then
                        u180 = nil;
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

    for _, child in ipairs(u50.Container.List.Container:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIPadding" and not v369[child.Name])) then
            child:Destroy();
        end;
    end;

    u1.PopulateWeaponDropdown();
    u1.SortBySkinMetadata(u4);
end;

function u1.UpdateLoadoutContainer(p370) -- Line: 2340
    -- upvalues: Profiler (copy), u23 (ref), CleanupDrag (copy), u19 (ref), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u180 (ref), HideAllMoveFrames (copy), GamepadNavigation (copy), u2 (ref), u50 (ref), ClearFrame (copy), GetInventoryItemFromIdentifier (copy), u1 (copy)
    Profiler.mark("UI.Loadout.UpdateLoadoutContainer");
    local v371 = u23;
    CleanupDrag();
    u19 = nil;
    u23 = nil;
    u22 = false;

    if u21 then
        u21 = false;
        pcall(function() -- Line: 1300
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
        GuiService.AutoSelectGuiEnabled = true;
        local u372 = u180;

        if u372 then
            task.delay(0.25, function() -- Line: 1259
                -- upvalues: u180 (ref), u372 (copy), u21 (ref)
                if u180 == u372 and not u21 then
                    u180 = nil;
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
    local v374 = u50.Container.Teams:FindFirstChild(v373);
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
        task.defer(function() -- Line: 2400
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

function u1.UpdateSidebarFrames(p384, p385) -- Line: 2423
    -- upvalues: Profiler (copy), u2 (ref), u50 (ref), u40 (copy), GetInventoryItemFromIdentifier (copy), GetResolvedSkinInformation (copy), Skins (copy), Rarities (copy)
    Profiler.mark("UI.Loadout.UpdateSidebarFrames");
    local v386 = p385 or u2;
    local v387 = v386 == "Counter-Terrorists" and "CT" or "T";
    local v388 = u50.Container.Teams:FindFirstChild(v387);
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

local function GetCurrentTeamKey() -- Line: 2520
    -- upvalues: u2 (ref)
    return u2 == "Counter-Terrorists" and "CT" or "T";
end;

local function ComputeWeaponStats(p402) -- Line: 2525
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

local function PaintWeaponDetails(p410: string, p411: any) -- Line: 2558
    -- upvalues: u50 (ref), GetResolvedSkinInformation (copy), GetWeaponProperties (copy), Rarities (copy), Color3_fromRGB_ret (copy), Skins (copy), GetSkinDisplayName (copy), u400 (copy), u401 (copy), WeaponCategories (copy), CommaNumber (copy), ComputeWeaponStats (copy)
    local v412 = u50.Container.Teams:FindFirstChild(p410);
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

local function GetDefaultSelectedItem() -- Line: 2622
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

function u1.SetSelectedWeapon(p426: any, p427: boolean?) -- Line: 2640
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

function u1.RefreshSelectedWeapon() -- Line: 2655
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

function u1.OnLoadoutItemHover(p433) -- Line: 2666
    -- upvalues: u1 (copy)
    u1.SetSelectedWeapon(p433);
end;

local function SetupSidebarHoverEvents() -- Line: 2672
    -- upvalues: Profiler (copy), u50 (ref), u42 (copy), u31 (copy), u1 (copy), GetInventoryItemFromIdentifier (copy)
    Profiler.mark("UI.Loadout.SetupSidebarHoverEvents");
    local Teams = u50.Container.Teams;

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

                        local function showEquippedItem() -- Line: 2704
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
    ButtonCT = u172["Counter-Terrorists"],
    ButtonT = u172.Terrorists
};

local function UpdateTeamToggle(p441: string) -- Line: 2729
    -- upvalues: u440 (copy), u50 (ref)
    for i, v in u440 do
        local v442 = u50.Teams:FindFirstChild(i);

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

function u1.SelectTeam(p444: string) -- Line: 2768
    -- upvalues: Profiler (copy), u50 (ref), u2 (ref), UpdateTeamToggle (copy), u3 (ref), u7 (ref), u6 (ref), DataController (copy), LocalPlayer (copy), u1 (copy)
    Profiler.mark("UI.Loadout.SelectTeam");
    local CT = u50.Container.Teams:FindFirstChild("CT");
    local v445;

    if CT then
        v445 = CT:IsA("Frame");
    else
        v445 = CT;
    end;

    assert(v445, "[Loadout] Missing CT team panel");
    CT.Visible = p444 == "CT";
    local T = u50.Container.Teams:FindFirstChild("T");
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
    u50.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories";
    u50.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";
    local v447 = DataController.Get(LocalPlayer, "Loadout");
    u1.UpdateLoadoutContainer(v447);
    u1.UpdateSidebarFrames(v447);
    u1.UpdateInventoryContainer();
    u1.PopulateWeaponDropdown();
end;

local function RefreshItemStatusFrames() -- Line: 2794
    -- upvalues: u50 (ref), UpdateStatusFrame (copy)
    if u50 and u50.Visible then
        for _, child in ipairs(u50.Container.List.Container:GetChildren()) do
            if child:IsA("Frame") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
                UpdateStatusFrame(child, child.Name);
            end;
        end;
    end;
end;

function u1.Initialize(p448, p449) -- Line: 2813
    -- upvalues: Profiler (copy), u50 (ref), CleanupDrag (copy), u23 (ref), u19 (ref), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u180 (ref), HideAllMoveFrames (copy), u35 (ref), u1 (copy), u4 (ref), u34 (ref), RenderInitialLoadoutTemplates (copy), u33 (ref), u32 (ref), CreateMissingItemTemplates (copy), ApplySortedLayoutOrder (copy), OnLoadoutScrollPositionChanged (copy), u30 (ref), u28 (ref), u29 (ref), MenuState (copy), Router (copy), CloseButtonRegistry (copy), GetInventoryItemFromIdentifier (copy), InspectInventoryItem (copy), Remotes (copy), UseItemFrame (copy), ReplaceItemOnTeam (copy), script_ItemIcon (copy), FadeCategoryLabels (copy), DataController (copy), LocalPlayer (copy), u26 (ref), SetupSidebarHoverEvents (copy), RefreshItemStatusFrames (copy), u8 (ref), UserInputService (copy), u325 (ref), u14 (ref), u24 (ref), u271 (ref), GetLoadoutSlotInfo (copy), u20 (ref), TweenService (copy), TweenInfo_new_ret (copy), u5 (ref), ClearDropdownOptions (copy), u3 (ref), u7 (ref), u6 (ref)
    Profiler.mark("UI.Loadout.Initialize");
    u50 = p449;
    u50:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2818
        -- upvalues: u50 (ref), CleanupDrag (ref), u23 (ref), u19 (ref), u22 (ref), u21 (ref), GamepadService (ref), GuiService (ref), u180 (ref), HideAllMoveFrames (ref), u35 (ref), u1 (ref), u4 (ref), u34 (ref), RenderInitialLoadoutTemplates (ref)
        if u50.Visible then
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
            pcall(function() -- Line: 1300
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
            local u450 = u180;

            if u450 then
                task.delay(0.25, function() -- Line: 1259
                    -- upvalues: u180 (ref), u450 (copy), u21 (ref)
                    if u180 == u450 and not u21 then
                        u180 = nil;
                        u450:Destroy();
                    end;
                end);
            end;
        end;

        HideAllMoveFrames();
    end);
    local Container = u50.Container.List.Container;
    Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 2839
        -- upvalues: u50 (ref), u33 (ref), u32 (ref), Profiler (ref), CreateMissingItemTemplates (ref), ApplySortedLayoutOrder (ref)
        if not u50 then
            return;
        end;

        local Container2 = u50.Container.List.Container;
        local v451 = Container2.AbsoluteCanvasSize.Y - Container2.AbsoluteSize.Y;

        if v451 > 0 and (u33 < #u32 and v451 - Container2.CanvasPosition.Y < 200) then
            Profiler.mark("UI.Loadout.RenderLoadoutTemplates");

            if not u50 then
                return;
            end;

            local Container3 = u50.Container.List.Container;
            local math_min_ret = math.min(u33 + 25, #u32);
            CreateMissingItemTemplates(Container3, u33 + 1, math_min_ret);
            u33 = math_min_ret;
            ApplySortedLayoutOrder(Container3);
        end;
    end);
    Container:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- Line: 2844
        -- upvalues: Profiler (ref), OnLoadoutScrollPositionChanged (ref)
        Profiler.defer("UI.Loadout.ScrollDeferred", OnLoadoutScrollPositionChanged);
    end);
    local Menu = p448:FindFirstChild("Menu");

    if Menu then
        Menu:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2851
            -- upvalues: Menu (copy), CleanupDrag (ref), u23 (ref), u19 (ref), u22 (ref), u21 (ref), GamepadService (ref), GuiService (ref), u180 (ref), HideAllMoveFrames (ref), u30 (ref), u28 (ref), u29 (ref), MenuState (ref), Router (ref)
            if not Menu.Visible then
                CleanupDrag();
                CleanupDrag();
                u19 = nil;
                u23 = nil;
                u22 = false;

                if u21 then
                    u21 = false;
                    pcall(function() -- Line: 1300
                        -- upvalues: GamepadService (ref)
                        GamepadService:DisableGamepadCursor();
                    end);
                    GuiService.AutoSelectGuiEnabled = true;
                    local u452 = u180;

                    if u452 then
                        task.delay(0.25, function() -- Line: 1259
                            -- upvalues: u180 (ref), u452 (copy), u21 (ref)
                            if u180 == u452 and not u21 then
                                u180 = nil;
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

    u30 = u50.Ignore.Information;

    if u30 then
        u30.Visible = false;
        CloseButtonRegistry.Add(u30, nil, function() -- Line: 2869
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

            local function handleInspectClick() -- Line: 2883
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
            Inspect.Activated:Connect(function(p455) -- Line: 1713
                -- upvalues: handleInspectClick (copy)
                if p455 and p455.UserInputType == Enum.UserInputType.Gamepad1 then
                    handleInspectClick();
                end;
            end);
        end;

        if u30.Charm then
            u30.Charm.Selectable = true;

            local function handleCharmClick() -- Line: 2896
                -- upvalues: Router (ref), u28 (ref), GetInventoryItemFromIdentifier (ref), u30 (ref), u29 (ref), Remotes (ref), u50 (ref), UseItemFrame (ref)
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

                    u50.Visible = false;
                    UseItemFrame.TriggerAction("AttachCharm", v456);
                end;
            end;

            local Charm = u30.Charm;
            Charm.MouseButton1Click:Connect(handleCharmClick);
            Charm.Activated:Connect(function(p458) -- Line: 1713
                -- upvalues: handleCharmClick (copy)
                if p458 and p458.UserInputType == Enum.UserInputType.Gamepad1 then
                    handleCharmClick();
                end;
            end);
        end;

        UseItemFrame.OnClosed:Connect(function() -- Line: 2913
            -- upvalues: MenuState (ref), u50 (ref)
            if MenuState.GetCurrentScreen() == "Loadout" then
                u50.Visible = true;
            end;
        end);

        if u30.Unlock then
            u30.Unlock.Selectable = true;
            u30.Unlock.Visible = false;
        end;

        local function setupReplaceButton(p459: userdata?, u460: any) -- Line: 2924
            -- upvalues: Router (ref), u28 (ref), GetInventoryItemFromIdentifier (ref), u30 (ref), u29 (ref), ReplaceItemOnTeam (ref)
            if not p459 then
                return;
            end;

            p459.Selectable = true;

            local function u462() -- Line: 2930
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
            p459.Activated:Connect(function(p463) -- Line: 1713
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

            local function u466() -- Line: 2930
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
            ReplaceT.Activated:Connect(function(p467) -- Line: 1713
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

            local function u470() -- Line: 2930
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
            ReplaceCT.Activated:Connect(function(p471) -- Line: 1713
                -- upvalues: u470 (copy)
                if p471 and p471.UserInputType == Enum.UserInputType.Gamepad1 then
                    u470();
                end;
            end);
        end;
    end;

    Profiler.spawn("UI.Loadout.PreloadDropShadows", script_ItemIcon.PreloadDropShadows);

    for _, v in ipairs({ "CT", "T" }) do
        local v472 = u50.Container.Teams:FindFirstChild(v);
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
                List.MouseEnter:Connect(function() -- Line: 2956
                    -- upvalues: FadeCategoryLabels (ref), List (copy)
                    FadeCategoryLabels(List, true);
                end);
                List.MouseLeave:Connect(function() -- Line: 2959
                    -- upvalues: FadeCategoryLabels (ref), List (copy)
                    FadeCategoryLabels(List, false);
                end);
            end;
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Loadout", function(p475) -- Line: 2966
        -- upvalues: Profiler (ref), u26 (ref), u1 (ref), SetupSidebarHoverEvents (ref), RefreshItemStatusFrames (ref)
        Profiler.mark("UI.Loadout.LoadoutChanged");
        u26 = false;
        u1.UpdateLoadoutContainer(p475);
        u1.UpdateSidebarFrames(p475, "Counter-Terrorists");
        u1.UpdateSidebarFrames(p475, "Terrorists");
        SetupSidebarHoverEvents();
        RefreshItemStatusFrames();
    end);
    Remotes.Inventory.LoadoutResponse.Listen(function() -- Line: 2978
        -- upvalues: u26 (ref), u8 (ref), u19 (ref), u1 (ref)
        u26 = false;

        if not (u8 or u19) then
            u1.RefreshSelectedWeapon();
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Inventory", function() -- Line: 2983
        -- upvalues: Profiler (ref), u1 (ref), RefreshItemStatusFrames (ref)
        Profiler.mark("UI.Loadout.InventoryChanged");
        u1.UpdateInventoryContainer();
        RefreshItemStatusFrames();
    end);
    UserInputService.InputEnded:Connect(function(p476, p477) -- Line: 2990
        -- upvalues: u19 (ref), u22 (ref), u325 (ref), u8 (ref), u14 (ref), u1 (ref)
        if p476.UserInputType == Enum.UserInputType.MouseButton1 or p476.UserInputType == Enum.UserInputType.Touch then
            if u19 then
                if p476.UserInputType == Enum.UserInputType.MouseButton1 and u22 then
                    u325();
                end;

                return;
            end;

            if u8 or u14 then
                u1.EndDrag();
            end;
        end;
    end);
    UserInputService.InputBegan:Connect(function(p478, p479) -- Line: 3012
        -- upvalues: u19 (ref), u24 (ref), u22 (ref), u271 (ref), u50 (ref), UserInputService (ref), GuiService (ref), GetInventoryItemFromIdentifier (ref), GetLoadoutSlotInfo (ref), InspectInventoryItem (ref)
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
                u271();

                return;
            end;

            if p478.KeyCode == Enum.KeyCode.ButtonX then
                if not u50.Visible or (u19 or UserInputService:GetFocusedTextBox()) then
                    return;
                end;

                local SelectedObject = GuiService.SelectedObject;

                if not (SelectedObject and (SelectedObject:IsA("GuiButton") and SelectedObject:IsDescendantOf(u50))) then
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
    UserInputService.InputEnded:Connect(function(p483, p484) -- Line: 3058
        -- upvalues: u19 (ref), u22 (ref), u325 (ref)
        if p483.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return;
        end;

        if p483.KeyCode == Enum.KeyCode.ButtonA and (u19 and u22) then
            u325();
        end;
    end);
    UserInputService.LastInputTypeChanged:Connect(function(p485) -- Line: 3074
        -- upvalues: u21 (ref), u20 (ref), u23 (ref), CleanupDrag (ref), u19 (ref), u22 (ref), GamepadService (ref), GuiService (ref), u180 (ref), HideAllMoveFrames (ref)
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
                pcall(function() -- Line: 1300
                    -- upvalues: GamepadService (ref)
                    GamepadService:DisableGamepadCursor();
                end);
                GuiService.AutoSelectGuiEnabled = true;
                local u487 = u180;

                if u487 then
                    task.delay(0.25, function() -- Line: 1259
                        -- upvalues: u180 (ref), u487 (copy), u21 (ref)
                        if u180 == u487 and not u21 then
                            u180 = nil;
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
    local Filter = u50.Container.List.Top.Filter;
    local Scroll = Filter.DropdownContent.Scroll;
    Filter.MouseButton1Click:Connect(function() -- Line: 3105
        -- upvalues: Scroll (copy), u50 (ref)
        local Visible = Scroll.Parent.Visible;
        local DropdownContent = u50.Container.List.Top.Weapon.DropdownContent;
        u50.Container.List.Top.Filter.DropdownContent.Visible = false;
        DropdownContent.Visible = false;
        Scroll.Parent.Visible = not Visible;
    end);

    for _, child in ipairs(Scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundTransparency = 1;
            child.MouseEnter:Connect(function() -- Line: 3114
                -- upvalues: child (copy), TweenService (ref), TweenInfo_new_ret (ref)
                TweenService:Create(child, TweenInfo_new_ret, {
                    BackgroundTransparency = 0.85
                }):Play();
            end);
            child.MouseLeave:Connect(function() -- Line: 3117
                -- upvalues: child (copy), TweenService (ref), TweenInfo_new_ret (ref)
                TweenService:Create(child, TweenInfo_new_ret, {
                    BackgroundTransparency = 1
                }):Play();
            end);
            child.MouseButton1Click:Connect(function() -- Line: 3120
                -- upvalues: u1 (ref), child (copy), Scroll (copy)
                u1.SortBySkinMetadata(child.Name);
                Scroll.Parent.Visible = false;
            end);
        end;
    end;

    local Reverse = u50.Container.List.Top.Filter.Container.Left.Reverse;

    if Reverse then
        Reverse.Selectable = true;

        local function u489() -- Line: 3130
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
        Reverse.Activated:Connect(function(p490) -- Line: 1713
            -- upvalues: u489 (copy)
            if p490 and p490.UserInputType == Enum.UserInputType.Gamepad1 then
                u489();
            end;
        end);
    end;

    local Weapon = u50.Container.List.Top.Weapon;
    local Scroll2 = Weapon.DropdownContent.Scroll;

    if Scroll2 and (Scroll2:IsA("Frame") or Scroll2:IsA("ScrollingFrame")) then
        ClearDropdownOptions(Scroll2);
        Weapon.MouseButton1Click:Connect(function() -- Line: 3148
            -- upvalues: Scroll2 (copy), u50 (ref)
            local Visible = Scroll2.Parent.Visible;
            local DropdownContent = u50.Container.List.Top.Weapon.DropdownContent;
            u50.Container.List.Top.Filter.DropdownContent.Visible = false;
            DropdownContent.Visible = false;
            Scroll2.Parent.Visible = not Visible;
        end);
    end;

    local Reset = u50.Container.List.Top.Reset;

    if Reset then
        Reset.Visible = false;
        Reset.MouseButton1Click:Connect(function() -- Line: 3160
            -- upvalues: u3 (ref), u7 (ref), u6 (ref), Weapon (copy), Reset (copy), u1 (ref), u50 (ref), u4 (ref)
            u3 = nil;
            u7 = nil;
            u6 = nil;
            Weapon.Container.Left.Title.Text = "All Weapons";
            Reset.Visible = false;
            u1.PopulateWeaponDropdown();

            for _, child in ipairs(u50.Container.List.Container:GetChildren()) do
                if child:IsA("ImageButton") then
                    child.Visible = true;
                end;
            end;

            u1.SortBySkinMetadata(u4);
        end);
    end;
end;

function u1.ViewInLoadout(p491: string) -- Line: 3184
    -- upvalues: GetInventoryItemFromIdentifier (copy), GetWeaponProperties (copy), u3 (ref), u50 (ref), u1 (copy), u6 (ref), MenuState (copy)
    local v492 = GetInventoryItemFromIdentifier(p491);

    if not v492 then
        return;
    end;

    local Name = v492.Name;
    local Skin = v492.Skin;
    local success, result = pcall(GetWeaponProperties, Name);

    if success and (result and result.Type) then
        u3 = result.Type;
        u50.Container.List.Top.Filter.Container.Left.Title.Text = result.Type;
        u1.PopulateWeaponDropdown();
    end;

    u1.SortByWeapon(Name, Skin);
    local Reset = u50.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u50.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;

    if not u50.Visible then
        MenuState.SetScreen("Loadout");
        u50.Visible = true;
    end;
end;

function u1.Start() -- Line: 3212
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), u1 (copy), SetupSidebarHoverEvents (copy), u3 (ref), u7 (ref), u6 (ref), u50 (ref), u4 (ref), u41 (copy), u19 (ref), u25 (ref), ActivateButton (copy), u2 (ref), MenuState (copy), u23 (ref), CleanupDrag (copy), u22 (ref), u21 (ref), GamepadService (copy), GuiService (copy), u180 (ref), HideAllMoveFrames (copy), u48 (copy), CloseButtonRegistry (copy), GamepadNavigation (copy)
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

    local function ClearFiltersAndShowAll() -- Line: 3234
        -- upvalues: u3 (ref), u7 (ref), u6 (ref), u50 (ref), u1 (ref), u4 (ref)
        u3 = nil;
        u7 = nil;
        u6 = nil;
        u50.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories";
        u50.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";

        for _, child in ipairs(u50.Container.List.Container:GetChildren()) do
            if child:IsA("ImageButton") then
                child.Visible = true;
            end;
        end;

        u1.SortBySkinMetadata(u4);
        local Reset = u50.Container.List.Top:FindFirstChild("Reset");

        if Reset then
            Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u50.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
        end;
    end;

    local u494 = {};

    local function SetupSidebarButtonClicks() -- Line: 3255
        -- upvalues: Profiler (ref), u50 (ref), u41 (ref), u19 (ref), u25 (ref), u6 (ref), ClearFiltersAndShowAll (copy), u3 (ref), u7 (ref), u1 (ref), u4 (ref), u494 (copy)
        Profiler.mark("UI.Loadout.SetupSidebarButtonClicks");

        for _, v in ipairs({ "CT", "T" }) do
            local v495 = u50.Container.Teams:FindFirstChild(v);
            local v496;

            if v495 then
                v496 = v495:IsA("Frame");
            else
                v496 = v495;
            end;

            local v497 = `[Loadout] Missing {v} team panel`;
            assert(v496, v497);
            local Equipments = v495:FindFirstChild("Equipments");
            local u498 = v;

            for _, v2 in ipairs(u41) do
                local v499 = Equipments[v2];
                v499.Selectable = true;
                v499.Active = true;

                local function handleSelection() -- Line: 3268
                    -- upvalues: u19 (ref), u25 (ref), u6 (ref), u498 (copy), v2 (copy), ClearFiltersAndShowAll (ref), u3 (ref), u7 (ref), u50 (ref), u1 (ref), u4 (ref)
                    if u19 or os.clock() - u25 < 0.25 then
                        return;
                    end;

                    local v500 = u6;

                    if v500 then
                        if u6.teamKey == u498 then
                            v500 = u6.sidebarName == v2;
                        else
                            v500 = false;
                        end;
                    end;

                    if v500 then
                        u6 = nil;
                        ClearFiltersAndShowAll();

                        return;
                    end;

                    u3 = nil;
                    u7 = nil;
                    u50.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories";
                    u50.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";
                    u6 = {
                        teamKey = u498,
                        sidebarName = v2
                    };
                    u1.SortBySkinMetadata(u4);
                    local Reset = u50.Container.List.Top:FindFirstChild("Reset");

                    if Reset then
                        Reset.Visible = (u3 ~= nil or u6 ~= nil) and true or u50.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
                    end;
                end;

                local v501 = `{u498}_{v2}`;

                if u494[v501] then
                    u494[v501]:Disconnect();
                end;

                u494[v501] = v499.Activated:Connect(handleSelection);
            end;
        end;
    end;

    SetupSidebarButtonClicks();
    ActivateButton(u50.Teams.ButtonCT);
    ActivateButton(u50.Teams.ButtonT);

    local function SwitchToTeam(p502: string) -- Line: 3321
        -- upvalues: u2 (ref), u1 (ref), u6 (ref), ClearFiltersAndShowAll (copy), Profiler (ref), SetupSidebarButtonClicks (copy)
        if u2 == (p502 == "CT" and "Counter-Terrorists" or "Terrorists") then
            return;
        end;

        u1.SelectTeam(p502);
        u6 = nil;
        ClearFiltersAndShowAll();
        Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks);
    end;

    u50.Teams.ButtonCT.MouseButton1Click:Connect(function() -- Line: 3335
        -- upvalues: u2 (ref), u1 (ref), u6 (ref), ClearFiltersAndShowAll (copy), Profiler (ref), SetupSidebarButtonClicks (copy)
        if u2 == "Counter-Terrorists" then
            return;
        end;

        u1.SelectTeam("CT");
        u6 = nil;
        ClearFiltersAndShowAll();
        Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks);
    end);
    u50.Teams.ButtonT.MouseButton1Click:Connect(function() -- Line: 3339
        -- upvalues: u2 (ref), u1 (ref), u6 (ref), ClearFiltersAndShowAll (copy), Profiler (ref), SetupSidebarButtonClicks (copy)
        if u2 == "Terrorists" then
            return;
        end;

        u1.SelectTeam("T");
        u6 = nil;
        ClearFiltersAndShowAll();
        Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks);
    end);
    MenuState.RegisterBumperOverride(u50, function(p503: boolean) -- Line: 3345
        -- upvalues: u19 (ref), u23 (ref), CleanupDrag (ref), u22 (ref), u21 (ref), GamepadService (ref), GuiService (ref), u180 (ref), HideAllMoveFrames (ref), u2 (ref), MenuState (ref), u50 (ref), u48 (ref), u1 (ref), u6 (ref), ClearFiltersAndShowAll (copy), Profiler (ref), SetupSidebarButtonClicks (copy)
        if u19 then
            CleanupDrag();
            u19 = nil;
            u23 = nil;
            u22 = false;

            if u21 then
                u21 = false;
                pcall(function() -- Line: 1300
                    -- upvalues: GamepadService (ref)
                    GamepadService:DisableGamepadCursor();
                end);
                GuiService.AutoSelectGuiEnabled = true;
                local u504 = u180;

                if u504 then
                    task.delay(0.25, function() -- Line: 1259
                        -- upvalues: u180 (ref), u504 (copy), u21 (ref)
                        if u180 == u504 and not u21 then
                            u180 = nil;
                            u504:Destroy();
                        end;
                    end);
                end;
            end;

            HideAllMoveFrames();
        end;

        local v505 = u2 == "Counter-Terrorists" and "ButtonCT" or "ButtonT";
        local NextBumperTab = MenuState.GetNextBumperTab(u50.Teams, u48, v505, p503);

        if NextBumperTab and NextBumperTab ~= v505 then
            local v506 = NextBumperTab == "ButtonCT" and "CT" or "T";

            if u2 ~= (v506 == "CT" and "Counter-Terrorists" or "Terrorists") then
                u1.SelectTeam(v506);
                u6 = nil;
                ClearFiltersAndShowAll();
                Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks);
            end;
        end;

        local v507 = u50.Teams:FindFirstChild(NextBumperTab or v505);

        if v507 and v507:IsA("GuiObject") then
            GuiService.SelectedObject = v507;
        end;

        return true;
    end, u50, u50.Teams, function() -- Line: 3364
        -- upvalues: u19 (ref)
        return u19 ~= nil;
    end);
    CloseButtonRegistry.AddHandler(function() -- Line: 3369
        -- upvalues: u19 (ref), u50 (ref)
        local v508;

        if u19 == nil then
            v508 = false;
        else
            v508 = u50.Visible;
        end;

        return v508;
    end, function() -- Line: 3371
        -- upvalues: u23 (ref), CleanupDrag (ref), u19 (ref), u22 (ref), u21 (ref), GamepadService (ref), GuiService (ref), u180 (ref), HideAllMoveFrames (ref), GamepadNavigation (ref)
        local v509 = u23;
        CleanupDrag();
        u19 = nil;
        u23 = nil;
        u22 = false;

        if u21 then
            u21 = false;
            pcall(function() -- Line: 1300
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
            local u510 = u180;

            if u510 then
                task.delay(0.25, function() -- Line: 1259
                    -- upvalues: u180 (ref), u510 (copy), u21 (ref)
                    if u180 == u510 and not u21 then
                        u180 = nil;
                        u510:Destroy();
                    end;
                end);
            end;
        end;

        HideAllMoveFrames();

        if v509 and GamepadNavigation.IsUsable(v509) then
            GamepadNavigation.ScrollIntoView(v509);
            GuiService.SelectedObject = v509;
        end;
    end);
    GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function() -- Line: 3378
        -- upvalues: u21 (ref), u19 (ref), GamepadService (ref), u23 (ref), CleanupDrag (ref), u22 (ref), GuiService (ref), u180 (ref), HideAllMoveFrames (ref), GamepadNavigation (ref)
        if u21 and (u19 and not GamepadService.GamepadCursorEnabled) then
            local v511 = u23;
            CleanupDrag();
            u19 = nil;
            u23 = nil;
            u22 = false;

            if u21 then
                u21 = false;
                pcall(function() -- Line: 1300
                    -- upvalues: GamepadService (ref)
                    GamepadService:DisableGamepadCursor();
                end);
                GuiService.AutoSelectGuiEnabled = true;
                local u512 = u180;

                if u512 then
                    task.delay(0.25, function() -- Line: 1259
                        -- upvalues: u180 (ref), u512 (copy), u21 (ref)
                        if u180 == u512 and not u21 then
                            u180 = nil;
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
        end;
    end);
    u50.Teams.ButtonCT.Interactable = true;
    u50.Teams.ButtonT.Interactable = true;
end;

return u1;