-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local EquipInventorySlot = require(ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot);
local GetInventoryItemIcon = require(ReplicatedStorage.Components.Common.GetInventoryItemIcon);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local TouchIntent = require(script.Parent.TouchIntent);
local u2 = { {
        Button = "Primary",
        SlotType = "Primary",
        SlotNumber = 1
    }, {
        Button = "Secondary",
        SlotType = "Secondary",
        SlotNumber = 2
    }, {
        Button = "Melee",
        SlotType = "Melee",
        SlotNumber = 3
    }, {
        Button = "Bomb",
        SlotType = "C4",
        SlotNumber = 5,
        UseRender = true
    } };
local u3 = nil;
local u4 = {};
local u5 = {};
local u6 = nil;

local function getSlotButton(p7: string) -- Line: 56
    -- upvalues: u3 (ref)
    local v8 = u3:FindFirstChild(p7);

    if v8 and v8:IsA("TextButton") then
        return v8;
    end;

    return nil;
end;

local function getGrenadeButton(p9: number) -- Line: 64
    -- upvalues: u3 (ref)
    local v10 = u3:FindFirstChild("Grenade" .. p9);

    if v10 and v10:IsA("TextButton") then
        return v10;
    end;

    return nil;
end;

local function connectSlotTap(u11: any, u12: function) -- Line: 72
    -- upvalues: TouchIntent (copy)
    u11.InputBegan:Connect(function(p13: userdata) -- Line: 73
        -- upvalues: TouchIntent (ref), u11 (copy)
        if p13.UserInputState == Enum.UserInputState.Begin then
            TouchIntent.track(p13, u11);
        end;
    end);
    u11.MouseButton1Click:Connect(function() -- Line: 78
        -- upvalues: TouchIntent (ref), u11 (copy), u12 (copy)
        if not TouchIntent.lastTouchWasDrag(u11) then
            u12();
        end;
    end);
end;

local function isZeus(p14) -- Line: 87
    local v15;

    if typeof(p14.Name) == "string" then
        v15 = string.find(p14.Name, "Zeus") ~= nil;
    else
        v15 = false;
    end;

    return v15;
end;

local function pickSlotItem(p16) -- Line: 92
    local _items = p16._items;

    if p16._settings._strict_type == "Melee" then
        for _, v in _items do
            local v17;

            if typeof(v.Name) == "string" then
                v17 = string.find(v.Name, "Zeus") ~= nil;
            else
                v17 = false;
            end;

            if not v17 then
                return v;
            end;
        end;
    end;

    return _items[1];
end;

local function getSkinRender(p18) -- Line: 105
    -- upvalues: Skins (copy)
    local v19 = (typeof(p18.Skin) ~= "string" or p18.Skin == "") and "Stock" or p18.Skin;
    local SkinInformation = Skins.GetSkinInformation(p18.Name, v19);

    if SkinInformation and (SkinInformation.wearImages and SkinInformation.wearImages[1]) then
        return SkinInformation.wearImages[1].assetId;
    end;

    return SkinInformation and SkinInformation.imageAssetId or nil;
end;

local function setSlotVisuals(p20: any, p21: any, p22: boolean?) -- Line: 115
    -- upvalues: getSkinRender (copy), GetInventoryItemIcon (copy), LocalPlayer (copy)
    local v23;

    if p21 then
        v23 = p22 and getSkinRender(p21) or (GetInventoryItemIcon(p21, LocalPlayer:GetAttribute("Team")) or nil);
    else
        v23 = nil;
    end;

    if v23 then
        p20.WeaponImage.Image = v23;
        p20.WeaponImage.Visible = true;

        return true;
    end;

    p20.WeaponImage.Image = "";
    p20.WeaponImage.Visible = false;
    p20.Equipped.Visible = false;

    return false;
end;

local function isSlotFilled(p24) -- Line: 130
    return p24.WeaponImage.Visible and p24.WeaponImage.Image ~= "";
end;

local function updateSlot(p25: string, p26: any, p27: boolean?) -- Line: 135
    -- upvalues: u3 (ref), setSlotVisuals (copy), u5 (copy), u6 (ref)
    local v28 = u3:FindFirstChild(p25);

    if not (v28 and v28:IsA("TextButton")) then
        v28 = nil;
    end;

    local v29;

    if v28 == nil then
        v29 = false;
    else
        v29 = setSlotVisuals(v28, p26, p27);
    end;

    if u5[p25] ~= v29 then
        u5[p25] = v29;

        if u6 then
            u6(p25, v29);
        end;
    end;
end;

local function refreshEquipped() -- Line: 147
    -- upvalues: InventoryController (copy), u2 (copy), u3 (ref), u4 (copy)
    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v30 = CurrentEquipped and CurrentEquipped.Properties and CurrentEquipped.Properties.Slot;

    if CurrentEquipped then
        CurrentEquipped = CurrentEquipped.Identifier;
    end;

    for _, v in u2 do
        local v31 = u3:FindFirstChild(v.Button);

        if not (v31 and v31:IsA("TextButton")) then
            v31 = nil;
        end;

        if v31 then
            v31.Equipped.Visible = v31.WeaponImage.Visible and v31.WeaponImage.Image ~= "" and v30 == v.SlotType;
        end;
    end;

    for i = 1, 4 do
        local v32 = u3:FindFirstChild("Grenade" .. i);

        if not (v32 and v32:IsA("TextButton")) then
            v32 = nil;
        end;

        local v33;

        if v32 then
            local v34 = u4[i];
            local v35 = v32.WeaponImage.Visible and v32.WeaponImage.Image ~= "";

            if v35 then
                if v30 == "Grenade" and v34 ~= nil then
                    v35 = v34 == CurrentEquipped;
                else
                    v35 = false;
                end;
            end;

            v32.Equipped.Visible = v35;
            v33 = i;
        else
            v33 = i;
        end;
    end;
end;

local function refreshLoadout(p36) -- Line: 172
    -- upvalues: u4 (copy), u3 (ref), GetInventoryItemIcon (copy), LocalPlayer (copy), u5 (copy), u6 (ref), u2 (copy), setSlotVisuals (copy), refreshEquipped (copy)
    local v37 = {};
    local v38 = {};
    table.clear(u4);

    if p36 then
        for _, v in p36 do
            local _strict_type = v._settings._strict_type;

            if _strict_type == "Grenade" then
                v38 = v._items;
            else
                local _items = v._items;
                local v39;

                if v._settings._strict_type == "Melee" then
                    for _, v2 in _items do
                        local v40;

                        if typeof(v2.Name) == "string" then
                            v40 = string.find(v2.Name, "Zeus") ~= nil;
                        else
                            v40 = false;
                        end;

                        if not v40 then
                            v39 = v2;
                            break;
                        end;
                    end;
                end;

                v39 = _items[1];
                v37[_strict_type] = v39;
            end;
        end;
    end;

    for i = 1, 4 do
        local v41 = v38[i];
        local v42;

        if v41 then
            v42 = v41.Identifier or nil;
        else
            v42 = nil;
        end;

        u4[i] = v42;
        local v43 = "Grenade" .. i;
        local v44 = u3:FindFirstChild(v43);

        if not (v44 and v44:IsA("TextButton")) then
            v44 = nil;
        end;

        local v45;

        if v44 == nil then
            v45 = false;
        else
            local v46 = v41 and GetInventoryItemIcon(v41, LocalPlayer:GetAttribute("Team")) or nil;

            if v46 then
                v44.WeaponImage.Image = v46;
                v44.WeaponImage.Visible = true;
                v45 = true;
            else
                v44.WeaponImage.Image = "";
                v44.WeaponImage.Visible = false;
                v44.Equipped.Visible = false;
                v45 = false;
            end;
        end;

        local v47;

        if u5[v43] == v45 then
            v47 = i;
        else
            u5[v43] = v45;

            if u6 then
                u6(v43, v45);
                v47 = i;
            else
                v47 = i;
            end;
        end;
    end;

    for _, v in u2 do
        local Button = v.Button;
        local v48 = v37[v.SlotType];
        local UseRender = v.UseRender;
        local v49 = u3:FindFirstChild(Button);

        if not (v49 and v49:IsA("TextButton")) then
            v49 = nil;
        end;

        local v50;

        if v49 == nil then
            v50 = false;
        else
            v50 = setSlotVisuals(v49, v48, UseRender);
        end;

        if u5[Button] ~= v50 then
            u5[Button] = v50;

            if u6 then
                u6(Button, v50);
            end;
        end;
    end;

    refreshEquipped();
end;

function u1.Refresh() -- Line: 204
    -- upvalues: refreshLoadout (copy), InventoryController (copy)
    refreshLoadout(InventoryController.getCurrentInventory());
end;

function u1.GetSlotButtonNames() -- Line: 209
    -- upvalues: u2 (copy)
    local v51 = {};

    for _, v in u2 do
        table.insert(v51, v.Button);
    end;

    table.insert(v51, "Grenade" .. 1);
    table.insert(v51, "Grenade" .. 2);
    table.insert(v51, "Grenade" .. 3);
    table.insert(v51, "Grenade" .. 4);

    return v51;
end;

function u1.IsSlotFilled(p52: string) -- Line: 220
    -- upvalues: u5 (copy)
    return u5[p52] == true;
end;

function u1.Initialize(p53: userdata, p54: function?) -- Line: 228
    -- upvalues: u3 (ref), u6 (ref), u2 (copy), connectSlotTap (copy), EquipInventorySlot (copy), u4 (copy), InventoryController (copy), refreshLoadout (copy)
    u3 = p53;
    u6 = p54;

    for _, v in u2 do
        local u55 = u3:FindFirstChild(v.Button);

        if not (u55 and u55:IsA("TextButton")) then
            u55 = nil;
        end;

        if u55 then
            connectSlotTap(u55, function() -- Line: 236
                -- upvalues: u55 (copy), EquipInventorySlot (ref), v (copy)
                local v56 = u55;

                if v56.WeaponImage.Visible and v56.WeaponImage.Image ~= "" then
                    EquipInventorySlot(v.SlotNumber);
                end;
            end);
        end;
    end;

    for i = 1, 4 do
        local v57 = u3:FindFirstChild("Grenade" .. i);

        if not (v57 and v57:IsA("TextButton")) then
            v57 = nil;
        end;

        local v58;

        if v57 then
            connectSlotTap(v57, function() -- Line: 248
                -- upvalues: u4 (ref), i (copy), InventoryController (ref)
                if u4[i] then
                    InventoryController.equip(4, i);
                end;
            end);
            v58 = i;
        else
            v58 = i;
        end;
    end;

    refreshLoadout(nil);
end;

function u1.Start() -- Line: 260
    -- upvalues: InventoryController (copy), LocalPlayer (copy), refreshLoadout (copy), refreshEquipped (copy), u1 (copy), Skins (copy)
    InventoryController.OnInventoryChanged:Connect(function(p59) -- Line: 261
        -- upvalues: LocalPlayer (ref), refreshLoadout (ref)
        if LocalPlayer:GetAttribute("IsSpectating") then
            return;
        end;

        refreshLoadout(p59);
    end);
    InventoryController.OnInventoryItemEquipped:Connect(refreshEquipped);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(u1.Refresh);
    Skins.OnItemStockSchemasUpdated:Connect(function() -- Line: 275
        -- upvalues: u1 (ref)
        u1.Refresh();
    end);
    u1.Refresh();
end;

return u1;