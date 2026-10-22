-- ReplicatedStorage.GameClient.WeaponController.WeaponInput
-- Script path: ReplicatedStorage.GameClient.WeaponController.WeaponInput
-- Decompile time: 4.53 ms

-- Decompiled with Potassium's decompiler.

return {
    BlockInputs = function(p1) -- Line: 10, Name: BlockInputs
        p1.WishInspect = false;
        p1.WishFire = false;
        p1.WishFire2 = false;
        p1.WishReload = false;
        p1.WishDrop = false;
    end,

    GetCommandMap = function(p2) -- Line: 18, Name: GetCommandMap
        return {
            WishEquip = p2.WishEquip,
            WishBooleans = {
                WishInspect = p2.WishInspect,
                WishFire = p2.WishFire,
                WishFire2 = p2.WishFire2,
                WishReload = p2.WishReload,
                WishDrop = p2.WishDrop
            }
        };
    end
};