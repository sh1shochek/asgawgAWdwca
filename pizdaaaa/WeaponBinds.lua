-- ReplicatedStorage.GameClient.BindsController.WeaponBinds
-- Script path: ReplicatedStorage.GameClient.BindsController.WeaponBinds
-- Decompile time: 8.64 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;

local function SwitchWeapon(p7) -- Line: 18
    -- upvalues: u3 (ref), u4 (ref), u2 (ref)
    if not u3.IsAlive() or u4.HasFramePriority() then
        return;
    end;

    local CurrentWeapon = u2.GetCurrentWeapon();
    local v8 = {};

    if not CurrentWeapon then
        return;
    end;

    for i in u2.GetWeaponInventory() do
        table.insert(v8, i);
    end;

    table.sort(v8);
    local table_find_ret = table.find(v8, CurrentWeapon.Slot);

    if table_find_ret and #v8 > 1 then
        u2.UpdateKeyState("WishEquip", v8[(table_find_ret - 1 + p7) % #v8 + 1]);
    end;
end;

local function SwitchPreviousWeapon() -- Line: 42
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), u2 (ref)
    if not u3.IsAlive() or u4.HasFramePriority() then
        return;
    end;

    if u5 and u2.GetWeaponInventory()[u5] then
        u2.UpdateKeyState("WishEquip", u5);
    end;
end;

local u45 = {
    ["Equip Primary"] = {
        Callback = function(p9, p10) -- Line: 54, Name: Callback
            -- upvalues: u3 (ref), u4 (ref), u2 (ref)
            if p10 == Enum.UserInputState.Begin then
                if not u3.IsAlive() then
                    return;
                end;

                if u4.HasFramePriority() then
                    return;
                end;

                if u2.GetWeaponInventory()[1] then
                    u2.UpdateKeyState("WishEquip", 1);
                end;
            end;
        end
    },
    ["Equip Secondary"] = {
        Callback = function(p11, p12) -- Line: 74, Name: Callback
            -- upvalues: u3 (ref), u4 (ref), u2 (ref)
            if p12 == Enum.UserInputState.Begin then
                if not u3.IsAlive() then
                    return;
                end;

                if u4.HasFramePriority() then
                    return;
                end;

                if u2.GetWeaponInventory()[2] then
                    u2.UpdateKeyState("WishEquip", 2);
                end;
            end;
        end
    },
    ["Equip Melee"] = {
        Callback = function(p13, p14) -- Line: 94, Name: Callback
            -- upvalues: u3 (ref), u4 (ref), u2 (ref)
            if p14 == Enum.UserInputState.Begin then
                if not u3.IsAlive() then
                    return;
                end;

                if u4.HasFramePriority() then
                    return;
                end;

                if u2.GetWeaponInventory()[3] then
                    u2.UpdateKeyState("WishEquip", 3);
                end;
            end;
        end
    },
    ["Equip Bomb"] = {
        Callback = function(p15, p16) -- Line: 114, Name: Callback
            -- upvalues: u3 (ref), u4 (ref), u2 (ref)
            if p16 == Enum.UserInputState.Begin then
                if not u3.IsAlive() then
                    return;
                end;

                if u4.HasFramePriority() then
                    return;
                end;

                if u2.GetWeaponInventory()[8] then
                    u2.UpdateKeyState("WishEquip", 8);
                end;
            end;
        end
    },
    ["Weapon Inspect"] = {
        Callback = function(p17, p18) -- Line: 134, Name: Callback
            -- upvalues: u3 (ref), u2 (ref)
            if not u3.IsAlive() then
                return;
            end;

            u2.GetCurrentWeapon();

            if p18 == Enum.UserInputState.Begin then
                u2.UpdateKeyState("WishInspect", true);

                return;
            end;

            if p18 == Enum.UserInputState.End then
                u2.UpdateKeyState("WishInspect", false);
            end;
        end
    },
    ["Weapon Fire"] = {
        Callback = function(p19, p20) -- Line: 150, Name: Callback
            -- upvalues: u3 (ref), u2 (ref)
            if not u3.IsAlive() then
                return;
            end;

            u2.GetCurrentWeapon();

            if p20 == Enum.UserInputState.Begin then
                u2.UpdateKeyState("WishFire", true);

                return;
            end;

            if p20 == Enum.UserInputState.End then
                u2.UpdateKeyState("WishFire", false);
            end;
        end
    },
    ["Weapon Alt Function"] = {
        Callback = function(p21, p22) -- Line: 166, Name: Callback
            -- upvalues: u3 (ref), u2 (ref)
            if not u3.IsAlive() then
                return;
            end;

            u2.GetCurrentWeapon();

            if p22 == Enum.UserInputState.Begin then
                u2.UpdateKeyState("WishFire2", true);

                return;
            end;

            if p22 == Enum.UserInputState.End then
                u2.UpdateKeyState("WishFire2", false);
            end;
        end
    },
    ["Weapon Reload"] = {
        Callback = function(p23, p24) -- Line: 182, Name: Callback
            -- upvalues: u3 (ref), u2 (ref)
            if not u3.IsAlive() then
                return;
            end;

            u2.GetCurrentWeapon();

            if p24 == Enum.UserInputState.Begin then
                u2.UpdateKeyState("WishReload", true);

                return;
            end;

            if p24 == Enum.UserInputState.End then
                u2.UpdateKeyState("WishReload", false);
            end;
        end
    },
    ["Weapon Drop"] = {
        Callback = function(p25, p26) -- Line: 198, Name: Callback
            -- upvalues: u3 (ref), u2 (ref)
            if not u3.IsAlive() then
                return;
            end;

            u2.GetCurrentWeapon();

            if p26 == Enum.UserInputState.Begin then
                u2.UpdateKeyState("WishDrop", true);

                return;
            end;

            if p26 == Enum.UserInputState.End then
                u2.UpdateKeyState("WishDrop", false);
            end;
        end
    },
    ["Equip Previous Weapon"] = {
        Callback = function(p27, p28) -- Line: 214, Name: Callback
            -- upvalues: u3 (ref), u4 (ref), u5 (ref), u2 (ref)
            if p28 == Enum.UserInputState.Begin and u3.IsAlive() then
                if u4.HasFramePriority() then
                    return;
                end;

                if u5 and u2.GetWeaponInventory()[u5] then
                    u2.UpdateKeyState("WishEquip", u5);
                end;
            end;
        end
    },
    ["Weapon Switch Up"] = {
        Callback = function(p29, p30) -- Line: 222, Name: Callback
            -- upvalues: SwitchWeapon (copy)
            if p30 == Enum.UserInputState.Begin then
                SwitchWeapon(-1);
            end;
        end
    },
    ["Weapon Switch Down"] = {
        Callback = function(p31, p32) -- Line: 230, Name: Callback
            -- upvalues: SwitchWeapon (copy)
            if p32 == Enum.UserInputState.Begin then
                SwitchWeapon(1);
            end;
        end
    },
    ["Cycle Grenades"] = {
        Callback = function(p33, p34) -- Line: 238, Name: Callback
            -- upvalues: u3 (ref), u4 (ref), u2 (ref)
            if p34 == Enum.UserInputState.Begin then
                if not u3.IsAlive() or u4.HasFramePriority() then
                    return;
                end;

                local WeaponInventory = u2.GetWeaponInventory();
                local v35 = {};

                if WeaponInventory[4] then
                    table.insert(v35, 4);
                end;

                if WeaponInventory[5] then
                    table.insert(v35, 5);
                end;

                if WeaponInventory[6] then
                    table.insert(v35, 6);
                end;

                if WeaponInventory[7] then
                    table.insert(v35, 7);
                end;

                if #v35 == 0 then
                    return;
                end;

                local CurrentWeapon = u2.GetCurrentWeapon();

                if CurrentWeapon then
                    CurrentWeapon = CurrentWeapon.Slot;
                end;

                local v36 = v35[1];

                if CurrentWeapon and (CurrentWeapon >= 4 and CurrentWeapon <= 7) then
                    local table_find_ret = table.find(v35, CurrentWeapon);

                    if table_find_ret then
                        v36 = v35[table_find_ret % #v35 + 1];
                    end;
                end;

                u2.UpdateKeyState("WishEquip", v36);
            end;
        end
    },
    ["Equip First Grenade"] = {
        Callback = function(p37, p38) -- Line: 273, Name: Callback
            -- upvalues: u3 (ref), u4 (ref), u2 (ref)
            if p38 == Enum.UserInputState.Begin then
                if not u3.IsAlive() or u4.HasFramePriority() then
                    return;
                end;

                if u2.GetWeaponInventory()[4] then
                    u2.UpdateKeyState("WishEquip", 4);
                end;
            end;
        end
    },
    ["Equip Second Grenade"] = {
        Callback = function(p39, p40) -- Line: 286, Name: Callback
            -- upvalues: u3 (ref), u4 (ref), u2 (ref)
            if p40 == Enum.UserInputState.Begin then
                if not u3.IsAlive() or u4.HasFramePriority() then
                    return;
                end;

                if u2.GetWeaponInventory()[5] then
                    u2.UpdateKeyState("WishEquip", 5);
                end;
            end;
        end
    },
    ["Equip Third Grenade"] = {
        Callback = function(p41, p42) -- Line: 299, Name: Callback
            -- upvalues: u3 (ref), u4 (ref), u2 (ref)
            if p42 == Enum.UserInputState.Begin then
                if not u3.IsAlive() or u4.HasFramePriority() then
                    return;
                end;

                if u2.GetWeaponInventory()[6] then
                    u2.UpdateKeyState("WishEquip", 6);
                end;
            end;
        end
    },
    ["Equip Fourth Grenade"] = {
        Callback = function(p43, p44) -- Line: 312, Name: Callback
            -- upvalues: u3 (ref), u4 (ref), u2 (ref)
            if p44 == Enum.UserInputState.Begin then
                if not u3.IsAlive() or u4.HasFramePriority() then
                    return;
                end;

                if u2.GetWeaponInventory()[7] then
                    u2.UpdateKeyState("WishEquip", 7);
                end;
            end;
        end
    }
};

function v1.Get() -- Line: 327
    -- upvalues: u45 (copy)
    return u45;
end;

function v1.Init(p46) -- Line: 333
    -- upvalues: u2 (ref), u3 (ref), u4 (ref)
    u2 = p46:GetModule("WeaponController");
    u3 = p46:GetModule("CharacterController");
    u4 = p46:GetModule("BindsController");
end;

function v1.Start(p47) -- Line: 339
    -- upvalues: u2 (ref), u6 (ref), u5 (ref), u3 (ref)
    u2.OnWeaponChanged:Connect(function(p48) -- Line: 340
        -- upvalues: u6 (ref), u5 (ref)
        if u6 ~= p48.Slot then
            u5 = u6;
            u6 = p48.Slot;
        end;
    end);
    u3.OnCharacterSpawn:Connect(function() -- Line: 347
        -- upvalues: u5 (ref), u6 (ref)
        u5 = nil;
        u6 = nil;
    end);
end;

return v1;