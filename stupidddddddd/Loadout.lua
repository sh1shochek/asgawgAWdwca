-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.MobileButtons.Loadout
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.MobileButtons.Loadout
-- Decompile time: 5.82 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local EquipInventorySlot = require(ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot)
local GetInventoryItemIcon = require(ReplicatedStorage.Components.Common.GetInventoryItemIcon)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local TouchIntent = require(script.Parent.TouchIntent)
local u38 = {
    {Button = "Primary", SlotType = "Primary", SlotNumber = 1},
    {Button = "Secondary", SlotType = "Secondary", SlotNumber = 2},
    {Button = "Melee", SlotType = "Melee", SlotNumber = 3},
    {Button = "Bomb", SlotType = "C4", SlotNumber = 5, UseRender = true},
}
local u43 = nil
local u44 = {}
local u45 = {}
local u46 = nil

local function getSlotButton(a1) -- Line: 56 -- upvalues: u43 (ref) -- types: a1: string
    local v1 = u43:FindFirstChild(a1)
    if v1 and v1:IsA("TextButton") then
        return v1
    end
    return nil
end

local function getGrenadeButton(a1) -- Line: 64 -- upvalues: u43 (ref) -- types: a1: number
    local v1 = "Grenade" .. a1
    local v2 = u43:FindFirstChild(v1)
    if v2 and v2:IsA("TextButton") then
        return v2
    end
    return nil
end

local function connectSlotTap(a1, a2) -- Line: 72 -- upvalues: TouchIntent (val) -- types: a2: function
    a1.InputBegan:Connect(function(a1_2) -- Line: 73 -- upvalues: TouchIntent (upval), a1 (val) -- types: a1_2: userdata
        if a1_2.UserInputState == Enum.UserInputState.Begin then
            TouchIntent.track(a1_2, a1)
        end
    end)
    a1.MouseButton1Click:Connect(function() -- Line: 78 -- upvalues: TouchIntent (upval), a1 (val), a2 (val)
        if not TouchIntent.lastTouchWasDrag(a1) then
            a2()
        end
    end)
end

local function isZeus(a1) -- Line: 87
    local v1 = false
    if typeof(a1.Name) == "string" then
        v1 = string.find(a1.Name, "Zeus") ~= nil
    end
    return v1
end

local function pickSlotItem(a1) -- Line: 92
    local _items = a1._items
    if a1._settings._strict_type == "Melee" then
        local v1
        local v2 = nil
        local v3 = nil
        for i, j in _items, v2, v3 do
            v1 = false
            if typeof(j.Name) == "string" then
                v1 = string.find(j.Name, "Zeus") ~= nil
            end
            if not v1 then
                return j
            end
        end
    end
    return _items[1]
end

local function getSkinRender(a1) -- Line: 105 -- upvalues: Skins (val)
    local v1 = Skins.GetSkinInformation(a1.Name, if typeof(a1.Skin) ~= "string" then "Stock" else if a1.Skin == "" then "Stock" else a1.Skin)
    if v1 and v1.wearImages and v1.wearImages[1] then
        return v1.wearImages[1].assetId
    end
    return v1 and v1.imageAssetId or nil
end

local function setSlotVisuals(a1, a2, a3) -- Line: 115
    -- upvalues: getSkinRender (val), GetInventoryItemIcon (val), LocalPlayer (val)
    local v1 = if not a2 then nil else a3 and getSkinRender(a2) or GetInventoryItemIcon(a2, LocalPlayer:GetAttribute("Team")) or nil
    if v1 then
        a1.WeaponImage.Image = v1
        a1.WeaponImage.Visible = true
        return true
    end
    a1.WeaponImage.Image = ""
    a1.WeaponImage.Visible = false
    a1.Equipped.Visible = false
    return false
end

local function isSlotFilled(a1) -- Line: 130
    return a1.WeaponImage.Visible and a1.WeaponImage.Image ~= ""
end

local function updateSlot(a1, a2, a3) -- Line: 135
    -- upvalues: u43 (ref), setSlotVisuals (val), u45 (val), u46 (ref)
    local v1 = u43:FindFirstChild(a1)
    local v2 = if not v1 then nil else if not v1:IsA("TextButton") then nil else v1
    v1 = false
    if v2 ~= nil then
        v1 = setSlotVisuals(v2, a2, a3)
    end
    if u45[a1] ~= v1 then
        u45[a1] = v1
        if u46 then
            u46(a1, v1)
        end
    end
end

local function refreshEquipped() -- Line: 147 -- upvalues: InventoryController (val), u38 (val), u43 (ref), u44 (val)
    local Button, Equipped, Equipped_2, Visible, Visible_2, v1, v2, v3, v4
    local v5 = InventoryController.getCurrentEquipped()
    local Properties = v5 and v5.Properties and v5.Properties.Slot
    local Identifier = v5 and v5.Identifier
    local v6 = nil
    local v7 = nil
    for i, j in u38, v6, v7 do
        Button = j.Button
        v1 = u43:FindFirstChild(Button)
        v4 = if not v1 then nil else if not v1:IsA("TextButton") then nil else v1
        if v4 then
            Equipped_2 = v4.Equipped
            Visible_2 = v4.WeaponImage.Visible and v4.WeaponImage.Image ~= "" and Properties == j.SlotType
            Equipped_2.Visible = Visible_2
        end
    end
    for k = 1, 4 do
        v3 = "Grenade" .. k
        v4 = u43:FindFirstChild(v3)
        v2 = if not v4 then nil else if not v4:IsA("TextButton") then nil else v4
        if v2 then
            v3 = u44[k]
            Equipped = v2.Equipped
            Visible = v2.WeaponImage.Visible and v2.WeaponImage.Image ~= ""
            if Visible then
                Visible = false
                if Properties == "Grenade" then
                    Visible = false
                    if v3 ~= nil then
                        Visible = v3 == Identifier
                    end
                end
            end
            Equipped.Visible = Visible
        end
    end
end

local function refreshLoadout(a1) -- Line: 172
    -- upvalues: u44 (val), u43 (ref), GetInventoryItemIcon (val), LocalPlayer (val), u45 (val), u46 (ref), u38 (val)
    -- upvalues: setSlotVisuals (val), refreshEquipped (val)
    local Button, UseRender, v1, v2, v3, v4, v5, v6, v7, v8, v9
    local v10 = {}
    local _items = {}
    table.clear(u44)
    if a1 then
        local _items_2, _strict_type, v11, v12
        v4 = nil
        v5 = nil
        for i, j in a1, v4, v5 do
            _strict_type = j._settings._strict_type
            if _strict_type ~= "Grenade" then
                _items_2 = j._items
                if j._settings._strict_type == "Melee" then
                    v3 = nil
                    v11 = nil
                    for k, n in _items_2, v3, v11 do
                        v12 = false
                        if typeof(n.Name) == "string" then
                            v12 = string.find(n.Name, "Zeus") ~= nil
                        end
                        if not v12 then
                            v10[_strict_type] = n
                            break
                        end
                    end
                end
                v9 = _items_2[1]
                v10[_strict_type] = v9
            else
                _items = j._items
            end
        end
    end
    for m = 1, 4 do
        v6 = _items[m]
        u44[m] = v6 and v6.Identifier or nil
        v7 = "Grenade" .. m
        v9 = u43:FindFirstChild(v7)
        v8 = if not v9 then nil else if not v9:IsA("TextButton") then nil else v9
        v9 = false
        if v8 ~= nil then
            v1 = v6 and GetInventoryItemIcon(v6, LocalPlayer:GetAttribute("Team")) or nil
            if not v1 then
                v8.WeaponImage.Image = ""
                v8.WeaponImage.Visible = false
                v8.Equipped.Visible = false
                v9 = false
            else
                v8.WeaponImage.Image = v1
                v8.WeaponImage.Visible = true
                v9 = true
            end
        end
        if u45[v7] ~= v9 then
            u45[v7] = v9
            if u46 then
                u46(v7, v9)
            end
        end
    end
    v4 = nil
    v5 = nil
    for i5, i6 in u38, v4, v5 do
        Button = i6.Button
        v9 = v10[i6.SlotType]
        UseRender = i6.UseRender
        v3 = u43:FindFirstChild(Button)
        v2 = if not v3 then nil else if not v3:IsA("TextButton") then nil else v3
        v3 = false
        if v2 ~= nil then
            v3 = setSlotVisuals(v2, v9, UseRender)
        end
        if u45[Button] ~= v3 then
            u45[Button] = v3
            if u46 then
                u46(Button, v3)
            end
        end
    end
    refreshEquipped()
end

function u0.Refresh() -- Line: 204 -- upvalues: refreshLoadout (val), InventoryController (val)
    refreshLoadout(InventoryController.getCurrentInventory())
end

function u0.GetSlotButtonNames() -- Line: 209 -- upvalues: u38 (val)
    local v1 = {}
    for i, j in u38 do
        table.insert(v1, j.Button)
    end
    table.insert(v1, "Grenade" .. 1)
    table.insert(v1, "Grenade" .. 2)
    table.insert(v1, "Grenade" .. 3)
    table.insert(v1, "Grenade" .. 4)
    return v1
end

function u0.IsSlotFilled(a1) -- Line: 220 -- upvalues: u45 (val) -- types: a1: string
    return u45[a1] == true
end

function u0.Initialize(a1, a2) -- Line: 228
    -- upvalues: u43 (ref), u46 (ref), u38 (val), connectSlotTap (val), EquipInventorySlot (val), u44 (val)
    -- upvalues: InventoryController (val), refreshLoadout (val)
    local Button, v1, v2, v3, v4
    u43 = a1
    u46 = a2
    local v5 = nil
    local v6 = nil
    for i, j in u38, v5, v6 do
        Button = j.Button
        v4 = u43:FindFirstChild(Button)
        if not v4 or not v4:IsA("TextButton") then
            u64 = nil
        else
            local u64 = v4
        end
        if u64 then
            connectSlotTap(u64, function() -- Line: 236 -- upvalues: u64 (val), EquipInventorySlot (upval), j (val)
                local v1 = u64
                local Visible = v1.WeaponImage.Visible and v1.WeaponImage.Image ~= ""
                if Visible then
                    EquipInventorySlot(j.SlotNumber)
                end
            end)
        end
    end
    for k = 1, 4 do
        v2 = "Grenade" .. k
        v3 = u43:FindFirstChild(v2)
        v1 = if not v3 then nil else if not v3:IsA("TextButton") then nil else v3
        if v1 then
            connectSlotTap(v1, function() -- Line: 248 -- upvalues: u44 (upval), k (val), InventoryController (upval)
                if u44[k] then
                    InventoryController.equip(4, k)
                end
            end)
        end
    end
    refreshLoadout(nil)
end

function u0.Start() -- Line: 260
    -- upvalues: InventoryController (val), LocalPlayer (val), refreshLoadout (val), refreshEquipped (val), u0 (val)
    -- upvalues: Skins (val)
    InventoryController.OnInventoryChanged:Connect(function(a1) -- Line: 261 -- upvalues: LocalPlayer (upval), refreshLoadout (upval)
        if LocalPlayer:GetAttribute("IsSpectating") then
            return
        end
        refreshLoadout(a1)
    end)
    InventoryController.OnInventoryItemEquipped:Connect(refreshEquipped)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(u0.Refresh)
    Skins.OnItemStockSchemasUpdated:Connect(function() -- Line: 275 -- upvalues: u0 (upval)
        u0.Refresh()
    end)
    u0.Refresh()
end

return u0