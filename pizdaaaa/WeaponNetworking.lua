-- ReplicatedStorage.GameClient.WeaponController.WeaponNetworking
-- Script path: ReplicatedStorage.GameClient.WeaponController.WeaponNetworking
-- Decompile time: 6.43 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local SoundManager = require(game:GetService("ReplicatedStorage").Shared.Managers.SoundManager);
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

function v1.Init(p12) -- Line: 17
    -- upvalues: u2 (ref), u11 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u9 (ref), u10 (ref)
    u2 = p12:GetModule("Network");
    u11 = p12:GetModule("WeaponConstructor");
    u3 = p12:GetModule("Enums");
    u4 = p12:GetModule("WeaponController");
    u5 = p12:GetModule("WeaponManager");
    u6 = p12:GetModule("CharacterController");
    u7 = p12:GetModule("Gui");
    u9 = p12:GetModule("InventoryData");
    u10 = p12:GetModule("Viewmodel");
end;

function v1.Start(p13) -- Line: 29
    -- upvalues: u8 (ref), u7 (ref), u2 (ref), u6 (ref), u3 (ref), u5 (ref), SoundManager (copy), u4 (ref), u9 (ref), u10 (ref), u11 (ref)
    u8 = u7.GetComponent("Notification");
    local Weapon = u2.Weapon;
    local u14 = nil;
    Weapon.OnWeaponPickup.On(function(p15) -- Line: 40
        -- upvalues: u6 (ref), u3 (ref), u5 (ref), SoundManager (ref), u8 (ref)
        if not u6.IsAlive() then
            return;
        end;

        local v16 = u3.Weapons[p15];

        if not v16 then
            return;
        end;

        local Character = u6.GetCharacter();
        local v17 = u5.Get(v16);

        if v17 then
            v17 = v17.GuiInformation;
        end;

        local v18;

        if v17 == nil then
            v18 = false;
        else
            v18 = v17.LoadoutCategory == "Grenades";
        end;

        local PickupSound, v19 = SoundManager.GetPickupSound(Character.Simulation.Velocity, v18);
        SoundManager.Play(PickupSound, {
            LocalReplicated = not v19
        });
        u8.SetNotifyVisibility(true, "You picked up a " .. v16, 4);
    end);
    Weapon.CreateWeapon.On(function(p20) -- Line: 63
        -- upvalues: u3 (ref), u4 (ref), u14 (ref), u9 (ref)
        local Slot = p20.Slot;
        local ID = p20.ID;
        local v21 = u3.Weapons[ID];
        local v22 = u3.SkinsNum[ID][p20.Skin];
        local KillTrackColor = p20.KillTrackColor;
        local v23 = u4.GetWeaponInventory()[Slot];
        local v24 = nil;

        while v23 and (v23.Replaced and v23.Replaced.Predicted) do
            v24 = v23;
            v23 = v23.Replaced;
        end;

        if v23 and v23.Predicted then
            local Replaced = v23.Replaced;
            v23.Predicted = nil;
            v23.Replaced = nil;

            if Replaced and next(Replaced) then
                Replaced:Destroy();
            end;

            if v24 or v23.Name == v21 and (v23.Skin == v22 and v23.SkinID == p20.SkinId) then
                v23.RefundAvailable = p20.RefundAvailable;

                if not v24 then
                    u14(Slot, true);
                end;

                return;
            end;
        end;

        if not KillTrackColor and (p20.SkinId and u9) then
            local v25 = u9.Get();

            if v25 then
                v25 = v25.Equipment;
            end;

            if v25 then
                v25 = v25[v21];
            end;

            if v25 then
                v25 = v25[v22];
            end;

            if v25 then
                v25 = v25[p20.SkinId];
            end;

            if v25 and v25.KillTrackColor then
                KillTrackColor = v25.KillTrackColor;
            end;
        end;

        u4.new(v21, Slot, p20.Owner, v22, p20.SkinId, p20.Ammo, p20.ReserveAmmo, p20.Mode, p20.Emissive, p20.RefundAvailable, p20.NameTag, p20.KillTrack, KillTrackColor, p20.Stickers);
        u14(Slot, true);
    end);
    u2.Gui.KillTrackUpdate.On(function(p26) -- Line: 130
        -- upvalues: u4 (ref)
        for _, v in u4.GetWeaponInventory() do
            if v.SkinID == p26.SkinId then
                v.KillTrack = p26.KillTrack;
                u4.OnKillTrackChanged:Fire(v);

                return;
            end;
        end;
    end);
    u2.Gui.KillTrackColorUpdate.On(function(p27) -- Line: 140
        -- upvalues: u4 (ref), u10 (ref)
        for _, v in u4.GetWeaponInventory() do
            if v.SkinID == p27.SkinId then
                v.KillTrackColor = p27.Color;

                if v.KillTrackText then
                    v.KillTrackText.TextColor3 = Color3.fromRGB(unpack(p27.Color));
                end;

                if u10 then
                    u10.ApplyKillTrackColor(v);
                end;

                u4.OnKillTrackColorChanged:Fire(v);

                return;
            end;
        end;
    end);
    u9.Updated:Connect(function() -- Line: 156
        -- upvalues: u9 (ref), u4 (ref), u10 (ref)
        local v28 = u9.Get();

        if v28 then
            v28 = v28.Equipment;
        end;

        if not v28 then
            return;
        end;

        for _, v in u4.GetWeaponInventory() do
            if v.SkinID and v.KillTrack ~= nil then
                local v29 = v28[v.Name];

                if v29 then
                    v29 = v29[v.Skin];
                end;

                if v29 then
                    v29 = v29[v.SkinID];
                end;

                if v29 and v29.KillTrackColor then
                    v.KillTrackColor = v29.KillTrackColor;

                    if v.KillTrackText then
                        v.KillTrackText.TextColor3 = Color3.fromRGB(unpack(v29.KillTrackColor));
                    end;

                    if u10 then
                        u10.ApplyKillTrackColor(v);
                    end;
                end;
            end;
        end;
    end);
    local u30 = nil;

    u14 = function(p31: any, p32: boolean?) -- Line: 214, Name: ApplyForceEquip
        -- upvalues: u30 (ref), u4 (ref), u11 (ref)
        if p32 and u30 ~= p31 then
            return;
        end;

        if not u4.GetWeaponInventory()[p31] then
            u30 = p31;

            return;
        end;

        u30 = nil;
        u4.UpdateKeyState("WishEquip", p31);
        u4.AckEquip();
        local CurrentCharacter = u4.GetCurrentCharacter();

        if CurrentCharacter then
            CurrentCharacter = CurrentCharacter.PredictedCommands;
        end;

        if CurrentCharacter then
            for _, v in CurrentCharacter do
                local WishEquip = v.WishEquip;
                v.WishEquip = p31 + (WishEquip - WishEquip % u11.RESET_ACK);
            end;
        end;
    end;

    Weapon.ForceEquip.On(u14);
    Weapon.DestroyWeapon.On(function(p33) -- Line: 260
        -- upvalues: u4 (ref)
        local v34 = u4.GetWeaponInventory()[p33];

        if not v34 or v34.Predicted then
            return;
        end;

        v34:Destroy();
    end);
    Weapon.WeaponReset.On(u4.AckReset);
end;

return v1;