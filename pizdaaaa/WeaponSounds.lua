-- ReplicatedStorage.Shared.Managers.SoundManager.WeaponSounds
-- Script path: ReplicatedStorage.Shared.Managers.SoundManager.WeaponSounds
-- Decompile time: 12.99 ms

-- Decompiled with Potassium's decompiler.

local v1 = {
    ["AK-47"] = {
        equip = "Weapons.AK-47.Equip",
        fire = "Weapons.AK-47.Fire",
        magin = "Weapons.AK-47.Clipin",
        magout = "Weapons.AK-47.Clipout",
        slidestart = "Weapons.AK-47.Boltpull"
    },
    ["AUG A3"] = {
        equip = "Weapons.AUG A3.Draw",
        fire = "Weapons.AUG A3.Fire",
        maghit = "Weapons.AUG A3.Cliphit",
        magin = "Weapons.AUG A3.Clipin",
        magout = "Weapons.AUG A3.Clipout",
        slidefinish = "Weapons.AUG A3.Boltrelease",
        slidestart = "Weapons.AUG A3.Boltpull",
        zoom = "Weapons.AUG A3.Zoom-In"
    },
    AWP = {
        equip = "Weapons.AWP.Draw",
        fire = "Weapons.AWP.Fire",
        maghit = "Weapons.AWP.Cliphit",
        magin = "Weapons.AWP.Clipin",
        magout = "Weapons.AWP.Clipout",
        slidefinish = "Weapons.AWP.Boltforward",
        slidestart = "Weapons.AWP.Boltback",
        zoom = "Weapons.AWP.Zoom"
    },
    ["CZ75-Auto"] = {
        equip = "Weapons.CZ75-Auto.Draw",
        fire = "Weapons.CZ75-Auto.Fire",
        magin = "Weapons.CZ75-Auto.Clipin",
        magout = "Weapons.CZ75-Auto.Clipout",
        slidefinish = "Weapons.CZ75-Auto.Sliderelease",
        slidestart = "Weapons.CZ75-Auto.Slideback"
    },
    ["Desert Eagle"] = {
        equip = "Weapons.Desert Eagle.Draw",
        fire = "Weapons.Desert Eagle.Fire",
        magin = "Weapons.Desert Eagle.Clipin",
        magout = "Weapons.Desert Eagle.Clipout",
        slidefinish = "Weapons.Desert Eagle.Slideforward",
        slidestart = "Weapons.Desert Eagle.Slideback"
    },
    ["Dual Berettas"] = {
        equip = "Weapons.Dual Berettas.Draw",
        fire = "Weapons.Dual Berettas.Fire",
        magin = "Weapons.Dual Berettas.Leftclipin",
        magin2 = "Weapons.Dual Berettas.Rightclipin",
        magout = "Weapons.Dual Berettas.Clipout",
        slidefinish = "Weapons.Dual Berettas.Sliderelease"
    },
    ["Famas F1"] = {
        equip = "Weapons.Famas F1.Draw",
        fire = "Weapons.Famas F1.Fire",
        maghit = "Weapons.Famas F1.Cliphit",
        magin = "Weapons.Famas F1.Clipin",
        magout = "Weapons.Famas F1.Clipout",
        slidefinish = "Weapons.Famas F1.Boltforward",
        slidestart = "Weapons.Famas F1.Boltback"
    },
    ["Five-seveN"] = {
        equip = "Weapons.Five-seveN.Draw",
        fire = "Weapons.Five-seveN.Fire",
        magin = "Weapons.Five-seveN.Clipin",
        magout = "Weapons.Five-seveN.Clipout",
        slidefinish = "Weapons.Five-seveN.Sliderelease",
        slidestart = "Weapons.Five-seveN.Slideback"
    },
    G3SG1 = {
        equip = "Weapons.G3SG1.Draw",
        fire = "Weapons.G3SG1.Fire",
        magin = "Weapons.G3SG1.Clipin",
        magout = "Weapons.G3SG1.Clipout",
        slidefinish = "Weapons.G3SG1.Slideforward",
        slidestart = "Weapons.G3SG1.Slideback",
        zoom = "Weapons.G3SG1.Zoom"
    },
    ["Galil ACE"] = {
        equip = "Weapons.Galil ACE.Draw",
        fire = "Weapons.Galil ACE.Fire",
        magin = "Weapons.Galil ACE.Clipin",
        magout = "Weapons.Galil ACE.Clipout",
        slidefinish = "Weapons.Galil ACE.Boltforward",
        slidestart = "Weapons.Galil ACE.Boltback"
    },
    ["Glock-18"] = {
        equip = "Weapons.Glock-18.Draw",
        fire = "Weapons.Glock-18.Fire",
        magin = "Weapons.Glock-18.Clipin",
        magout = "Weapons.Glock-18.Clipout",
        slidefinish = "Weapons.Glock-18.Sliderelease",
        slidestart = "Weapons.Glock-18.Slideback"
    },
    Knife = {
        equip = "Weapons.Knife.Deploy",
        slash = "Weapons.Knife.Slash",
        stab = "Weapons.Knife.Stab",
        hit_player = "Weapons.Knife.HitPlayer",
        hit_wall = "Weapons.Knife.HitWall"
    },
    ["M4A1-S"] = {
        equip = "Weapons.M4A1-S.Draw",
        fire = "Weapons.M4A1-S.Fire",
        fire_unsilenced = "Weapons.M4A1-S.Fire-Unsilenced",
        maghit = "Weapons.M4A1-S.Cliphit",
        magin = "Weapons.M4A1-S.Clipin",
        magout = "Weapons.M4A1-S.Clipout",
        screw1 = "Weapons.M4A1-S.Silencer-Screw",
        screw2 = "Weapons.M4A1-S.Silencer-Screw",
        screw3 = "Weapons.M4A1-S.Silencer-Screw",
        slidefinish = "Weapons.M4A1-S.Boltforward",
        slidestart = "Weapons.M4A1-S.Boltback"
    },
    M4A4 = {
        equip = "Weapons.M4A4.Draw",
        fire = "Weapons.M4A4.Fire",
        maghit = "Weapons.M4A4.Cliphit",
        magin = "Weapons.M4A4.Clipin",
        magout = "Weapons.M4A4.Clipout",
        slidefinish = "Weapons.M4A4.Boltforward",
        slidestart = "Weapons.M4A4.Boltback"
    },
    ["MAC-10"] = {
        equip = "Weapons.MAC-10.Draw",
        fire = "Weapons.MAC-10.Fire",
        magin = "Weapons.MAC-10.Clipin",
        magout = "Weapons.MAC-10.Clipout",
        slidefinish = "Weapons.MAC-10.Boltforward",
        slidestart = "Weapons.MAC-10.Boltback"
    },
    ["MAG-7"] = {
        equip = "Weapons.MAG-7.Draw",
        fire = "Weapons.MAG-7.Fire",
        magin = "Weapons.MAG-7.Clipin",
        magout = "Weapons.MAG-7.Clipout",
        slidefinish = "Weapons.MAG-7.Pump-Forward",
        slidestart = "Weapons.MAG-7.Pump-Back"
    },
    ["MP5-SD"] = {
        equip = "Weapons.MP5-SD.Draw",
        fire = "Weapons.MP5-SD.Fire",
        magin = "Weapons.MP5-SD.Clipin",
        magout = "Weapons.MP5-SD.Clipout",
        slidefinish = "Weapons.MP5-SD.Slideforward",
        slidestart = "Weapons.MP5-SD.Slideback"
    },
    MP7 = {
        equip = "Weapons.MP7.Draw",
        fire = "Weapons.MP7.Fire",
        magin = "Weapons.MP7.Clipin",
        magout = "Weapons.MP7.Clipout",
        slidefinish = "Weapons.MP7.Slideforward",
        slidestart = "Weapons.MP7.Slideback"
    },
    MP9 = {
        equip = "Weapons.MP9.Draw",
        fire = "Weapons.MP9.Fire",
        magin = "Weapons.MP9.Clipin",
        magout = "Weapons.MP9.Clipout",
        slidefinish = "Weapons.MP9.Boltforward",
        slidestart = "Weapons.MP9.Boltback"
    },
    P2000 = {
        equip = "Weapons.P2000.Draw",
        fire = "Weapons.P2000.Fire",
        magin = "Weapons.P2000.Clipin",
        magout = "Weapons.P2000.Clipout",
        slidefinish = "Weapons.P2000.Sliderelease",
        slidestart = "Weapons.P2000.Slideback"
    },
    P250 = {
        equip = "Weapons.P250.Draw",
        fire = "Weapons.P250.Fire",
        magin = "Weapons.P250.Clipin",
        magout = "Weapons.P250.Clipout",
        slidefinish = "Weapons.P250.Sliderelease",
        slidestart = "Weapons.P250.Slideback"
    },
    P90 = {
        equip = "Weapons.P90.Draw",
        fire = "Weapons.P90.Fire",
        maghit = "Weapons.P90.Cliphit",
        magin = "Weapons.P90.Clipin",
        magout = "Weapons.P90.Clipout",
        slidefinish = "Weapons.P90.Boltforward",
        slidestart = "Weapons.P90.Boltback"
    },
    ["PPSH-41"] = {
        equip = "Weapons.PPSH-41.Draw",
        fire = "Weapons.PPSH-41.Fire",
        magin = "Weapons.PPSH-41.Clipin",
        magout = "Weapons.PPSH-41.Clipout",
        slidefinish = "Weapons.PPSH-41.Boltforward",
        slidestart = "Weapons.PPSH-41.Boltback"
    },
    ["Remington 870"] = {
        equip = "Weapons.Remington 870.Draw",
        fire = "Weapons.Remington 870.Fire",
        magin = "Weapons.Remington 870.Insertshell",
        slidestart = "Weapons.Remington 870.Pump"
    },
    ["SCAR-20"] = {
        equip = "Weapons.SCAR-20.Draw",
        fire = "Weapons.SCAR-20.Fire",
        maghit = "Weapons.SCAR-20.Cliptouch",
        magin = "Weapons.SCAR-20.Clipin",
        magout = "Weapons.SCAR-20.Clipout",
        slidefinish = "Weapons.SCAR-20.Boltforward",
        slidestart = "Weapons.SCAR-20.Boltback",
        zoom = "Weapons.SCAR-20.Zoom"
    },
    ["SG 553"] = {
        equip = "Weapons.SG 553.Draw",
        fire = "Weapons.SG 553.Fire",
        maghit = "Weapons.SG 553.Cliphit",
        magin = "Weapons.SG 553.Clipin",
        magout = "Weapons.SG 553.Clipout",
        slidefinish = "Weapons.SG 553.Boltforward",
        slidestart = "Weapons.SG 553.Boltback"
    },
    ["SSG-08"] = {
        equip = "Weapons.SSG-08.Draw",
        fire = "Weapons.SSG-08.Fire",
        maghit = "Weapons.SSG-08.Cliphit",
        magin = "Weapons.SSG-08.Clipin",
        magout = "Weapons.SSG-08.Clipout",
        slidefinish = "Weapons.SSG-08.Boltforward",
        slidestart = "Weapons.SSG-08.Boltback",
        zoom = "Weapons.SSG-08.Zoom"
    },
    ["Sawed-Off"] = {
        equip = "Weapons.Sawed-Off.Draw",
        fire = "Weapons.Sawed-Off.Fire",
        magin = "Weapons.Sawed-Off.Insertshell",
        slidestart = "Weapons.Sawed-Off.Pump"
    },
    ["TEC-9"] = {
        equip = "Weapons.TEC-9.Draw",
        fire = "Weapons.TEC-9.Fire",
        magin = "Weapons.TEC-9.Clipin",
        magout = "Weapons.TEC-9.Clipout",
        slidefinish = "Weapons.TEC-9.Boltrelease",
        slidestart = "Weapons.TEC-9.Boltpull"
    },
    ["UMP-45"] = {
        equip = "Weapons.UMP-45.Draw",
        fire = "Weapons.UMP-45.Fire",
        magin = "Weapons.UMP-45.Clipin",
        magout = "Weapons.UMP-45.Clipout",
        slidefinish = "Weapons.UMP-45.Boltforward",
        slidestart = "Weapons.UMP-45.Boltback"
    },
    ["USP-S"] = {
        equip = "Weapons.USP-S.Draw",
        fire = "Weapons.USP-S.Fire",
        fire_unsilenced = "Weapons.USP-S.Fire-Unsilenced",
        magin = "Weapons.USP-S.Clipin",
        magout = "Weapons.USP-S.Clipout",
        screw1 = "Weapons.USP-S.SilencerScrew",
        screw2 = "Weapons.USP-S.SilencerScrew",
        screw3 = "Weapons.USP-S.SilencerScrew",
        slidefinish = "Weapons.USP-S.Sliderelease",
        slidestart = "Weapons.USP-S.Slideback"
    },
    XM1014 = {
        equip = "Weapons.XM1014.Draw",
        fire = "Weapons.XM1014.Fire",
        magin = "Weapons.XM1014.Insertshell",
        slidestart = "Weapons.XM1014.Pump"
    },
    Bomb = {
        equip = "Weapons.Bomb.Draw",
        open = "Weapons.Bomb.c4-initiate",
        press = "Weapons.Bomb.c4-press",
        toggle = "Weapons.Bomb.c4_click"
    }
};

for i = 1, 11 do
    v1.Bomb["press" .. i] = v1.Bomb.press;
    local _ = i;
end;

for _, v in v1 do
    table.freeze(v);
end;

table.freeze(v1);

return v1;