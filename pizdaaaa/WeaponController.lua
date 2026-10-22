-- ReplicatedStorage.GameClient.WeaponController
-- Script path: ReplicatedStorage.GameClient.WeaponController
-- Decompile time: 20.81 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundManager = require(ReplicatedStorage.Shared.Managers.SoundManager);
local ValueCodec = require(ReplicatedStorage.Shared.ValueCodec);
local TemplateOverrides = require(ReplicatedStorage.Shared.TemplateOverrides);
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = nil;
local u4 = {
    WishEquip = 2,
    WishInspect = false,
    WishFire = false,
    WishFire2 = false,
    WishReload = false,
    WishDrop = false
};
local u5 = nil;
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
local u6 = GameStats:GetAttribute("State") == "Preparation";
GameStats:GetAttributeChangedSignal("State"):Connect(function() -- Line: 36
    -- upvalues: u6 (ref), GameStats (copy)
    u6 = GameStats:GetAttribute("State") == "Preparation";
end);
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = nil;
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = {
    WishInspect = false,
    WishFire = false,
    WishFire2 = false,
    WishReload = false,
    WishDrop = false
};
local u33 = {
    WishEquip = nil,
    WishBooleans = u32
};

local function GetLoadoutGloves(p34, p35) -- Line: 77
    -- upvalues: HttpService (copy)
    local v36 = HttpService:JSONDecode(p34:GetAttribute("WeaponLoadout"));

    if not v36 then
        return;
    end;

    local v37 = v36[p35];

    if v37 then
        local v38 = v37["16"];

        return {
            WeaponName = v38.WeaponName,
            SkinName = v38.SkinName,
            SkinId = v38.SkinId
        };
    end;
end;

local function GetLoadoutAgent(p39, p40) -- Line: 99
    -- upvalues: HttpService (copy)
    local v41 = HttpService:JSONDecode(p39:GetAttribute("WeaponLoadout"))[p40];

    if v41 then
        v41 = v41["15"].SkinName;
    end;

    return v41;
end;

local function ResolveLoadoutSkin(p42: string) -- Line: 107
    -- upvalues: LocalPlayer (copy), HttpService (copy), u28 (ref)
    local Attribute = LocalPlayer:GetAttribute("WeaponLoadout");

    if Attribute then
        Attribute = HttpService:JSONDecode(Attribute);
    end;

    if Attribute then
        Attribute = Attribute[LocalPlayer:GetAttribute("Team")];
    end;

    for _, v in Attribute or {} do
        if v.WeaponName == p42 then
            local v43 = u28 and u28.Get();
            local v44 = v43 and v43.Equipment and v43.Equipment[p42];
            local v45 = v44 and v44[v.SkinName] and v44[v.SkinName][v.SkinId];
            local v46;

            if v45 then
                v46 = v45.NameTag;
            else
                v46 = v45;
            end;

            if v45 then
                v45 = v45.KillTrack;
            end;

            return v.SkinName, v.SkinId, v46, v45;
        end;
    end;

    return "Stock", "111";
end;

local function PredictBuy(p47: string) -- Line: 138
    -- upvalues: u30 (ref), u13 (ref), u12 (ref), u29 (ref), u2 (copy), u3 (ref), ResolveLoadoutSkin (copy), u1 (copy), LocalPlayer (copy), u4 (copy), u19 (ref)
    local u48 = u30.Get(p47);

    if u48 then
        u48 = u48.Data.Slot;
    end;

    if not u48 then
        return false;
    end;

    local Tick = u13.GetTick();
    u12.Weapon.BuyWeapon.Fire({
        Drop = false,
        Enum = u29.WeaponsNum[p47]
    });
    local u49 = u2[u48];
    local u50 = u3 and u3.Slot;

    if u49 then
        if u49 == u3 then
            u49:Unequip();
        end;

        u2[u48] = nil;
    end;

    local v51, v52, v53, v54 = ResolveLoadoutSkin(p47);
    local u55 = u1.new(p47, u48, LocalPlayer.Name, v51, v52, nil, nil, nil, nil, nil, v53, v54);
    u55.Predicted = true;
    u55.Replaced = u49;
    u55.BuyTick = Tick;
    u4.WishEquip = u48;
    task.delay(3, function() -- Line: 174
        -- upvalues: u55 (copy), u2 (ref), u48 (copy), u49 (copy), u4 (ref), u50 (copy), u19 (ref)
        if not u55.Predicted then
            return;
        end;

        if u2[u48] == u55 then
            if u49 and next(u49) then
                u2[u48] = u49;
            end;

            u4.WishEquip = u50 or u4.WishEquip;
        else
            local v56 = u2[u48];

            while v56 and v56.Replaced ~= u55 do
                v56 = v56.Replaced;
            end;

            if v56 then
                v56.Replaced = u49;
            end;
        end;

        u55:Destroy();
        u19.UpdateWeapons();
    end);

    return true;
end;

function u1.QueueBuy(p57: string) -- Line: 208
    -- upvalues: u31 (ref)
    u31 = p57;
end;

function u1.PushWeaponHistory(p58: any, p59: number) -- Line: 220
    -- upvalues: u16 (ref), u13 (ref)
    for _, v in p58 do
        v.History = v.History or u16.new(u13.HistorySize(2));
        v.History:PushFilled(p59, nil, v.WriteState, v);
    end;
end;

local u60 = false;

function u1.AckEquip() -- Line: 231
    -- upvalues: u60 (ref)
    u60 = true;
end;

local u61 = false;

function u1.AckReset() -- Line: 239
    -- upvalues: u5 (ref), u61 (ref), LocalPlayer (copy)
    if not u5 then
        return;
    end;

    u61 = true;
    u5.Simulation.PreparationStartCommand = (1 / 0);
    u5.RoundSpawn = LocalPlayer:GetAttribute("RoundSpawn");
end;

function u1.new(p62: string, p63: number, p64: string, p65: string, p66: string, p67: number, p68: number, p69: number, p70: any, p71: boolean?, p72: string?, p73: number?, p74: table?, p75: table?) -- Line: 249
    -- upvalues: u2 (copy), u28 (ref), u7 (ref), u1 (copy), u21 (ref), u25 (ref), u15 (ref), SoundManager (copy), u3 (ref), u18 (ref), u24 (ref), u27 (ref), LocalPlayer (copy), GetLoadoutGloves (copy), HttpService (copy), u5 (ref), u19 (ref)
    local v76 = u2[p63];

    if v76 then
        v76:Destroy();
    end;

    local v77 = u28.Get().Equipment[p62];
    local v78 = v77 and v77[p65] and v77[p65][p66];

    if p74 == nil and (p73 ~= nil and (v78 and v78.KillTrackColor)) then
        p74 = v78.KillTrackColor;
    end;

    local v79 = u7.new(p62, p63, p64, p65, p66, p67, p68, p69, p71, p72, p73, p74);
    local u80 = setmetatable(v79, u1);

    if p75 then
        v78 = p75;
    elseif v78 then
        v78 = v78.Stickers;
    end;

    u80.Stickers = v78;

    function u80.SettingAccessor(p81, p82, p83) -- Line: 271
        -- upvalues: u21 (ref)
        local v84 = u21 and u21:GetPlayerSettings();

        if v84 then
            v84 = v84[p81];
        end;

        if v84 then
            v84 = v84[p82];
        end;

        if v84 then
            v84 = v84[p83];
        end;

        return v84;
    end;

    function u80.SettingBlocked(p85) -- Line: 277
        -- upvalues: u25 (ref)
        u25.SetNotifyVisibility(true, p85, 4);
    end;

    u80.Maid = u15.new();
    local AltFunction = u80.Data.AltFunction;
    local v86;

    if AltFunction then
        v86 = AltFunction.Name;
    else
        v86 = AltFunction;
    end;

    if AltFunction then
        if v86 == "Scope" then
            local u87 = 0;
            local WeaponSound = SoundManager.GetWeaponSound(u80.Name, "zoom");
            u80.Maid:Add("ZoomSound", u80.AltFunctionRun:Connect(function() -- Line: 297
                -- upvalues: u80 (copy), u87 (ref), u3 (ref), WeaponSound (copy), SoundManager (ref)
                local v88 = u80.ZoomLevel or 0;

                if v88 ~= u87 and (u80 == u3 and not u80.Resimulating) then
                    if u87 < v88 then
                        if WeaponSound then
                            SoundManager.Play(WeaponSound, {
                                LocalReplicated = true
                            });
                        end;
                    else
                        SoundManager.Play("Other.WeaponZoomOut", {
                            LocalReplicated = true
                        });
                    end;
                end;

                u87 = v88;
            end));
        end;

        if v86 == "Scope" and AltFunction.Type == "Sniper" then
            local Zoom = AltFunction.Zoom;
            local First = Zoom.First;
            local Second = Zoom.Second;
            u80.Maid:Add("RunAltFunction", u80.AltFunctionRun:Connect(function() -- Line: 320
                -- upvalues: u80 (copy), u3 (ref), u18 (ref), First (copy), Second (copy), u24 (ref)
                if u80 ~= u3 then
                    return;
                end;

                local ZoomLevel = u80.ZoomLevel;
                u18.SetWeapon(ZoomLevel, First, Second);
                u24.SetVisible(u80, ZoomLevel == 0);
            end));
        elseif v86 == "Silencer" then
            u80.Maid:Add("Silencer", u80.AltFunctionRun:Connect(function() -- Line: 334
                -- upvalues: u80 (copy), u3 (ref)
                if u80 ~= u3 then
                    return;
                end;

                local Silencer = u80.Viewmodel.Weapon:FindFirstChild("Silencer", true);

                if Silencer and Silencer:IsA("BasePart") then
                    Silencer.Transparency = u80.Mode == 1 and 0 or 1;
                end;
            end));
        elseif v86 == "Burst" then
            u80.Maid:Add("Burst", u80.AltFunctionRun:Connect(function() -- Line: 352
                -- upvalues: u80 (copy), u3 (ref), SoundManager (ref), u25 (ref), u27 (ref)
                if u80 == u3 and not u80.Resimulating then
                    SoundManager.Play("Other.AutoSemiautoSwitch", {
                        LocalReplicated = true
                    });
                end;

                if u80 ~= u3 then
                    return;
                end;

                if not u80.Resimulating then
                    u25.SetNotifyVisibility(true, u80.Mode == 2 and "Switched to burst-fire mode" or (u80.Data.Automatic and "Switched to automatic" or "Switched to semi-automatic"), 4);
                end;

                u27.AmmoIconUpdate(u80.Name, u80.Mode);
            end));
        end;
    end;

    u80.Emissive = p70;
    local Attribute = LocalPlayer:GetAttribute("Team");
    local new = u24.new;
    local v89 = {
        Scale = 0.15,
        Team = Attribute,
        Gloves = GetLoadoutGloves(LocalPlayer, Attribute)
    };
    local v90 = HttpService:JSONDecode(LocalPlayer:GetAttribute("WeaponLoadout"))[Attribute];

    if v90 then
        v90 = v90["15"].SkinName;
    end;

    v89.Agent = v90;
    new(u80, v89);
    u24.RestoreScale(u80);
    u80.Timer = u5 and u5.WeaponTimer or 0;
    u2[p63] = u80;
    u19.UpdateWeapons();
    u1.OnWeaponCreate:Fire(u80);

    return u80;
end;

function u1.Equip(p91, p92, p93) -- Line: 414
    -- upvalues: u3 (ref), u20 (ref), u24 (ref), u1 (copy)
    if p91 == u3 then
        return;
    end;

    if u3 and next(u3) then
        u3:Unequip(p93);
    end;

    u20.Enabled("Weapon Alt Function", p91.Data.AltFunction ~= nil and true or p91.Data.Type == "Melee");
    u20.Enabled("Weapon Drop", not p91.Data.Undroppable);
    u3 = p91;
    u24.SetVisible(p91, true);
    u1.OnWeaponChanged:Fire(p91);

    if not (p93 and p91.WasEquipped) then
        p91.WasEquipped = true;
        u3:PlayAnimation("Equip");
    end;
end;

function u1.Drop(p94, p95, p96, p97) -- Line: 446
    -- upvalues: GameStats (copy), u14 (ref), u25 (ref), u7 (ref), u2 (copy), u3 (ref), u5 (ref), u4 (copy)
    if GameStats:GetAttribute("State") == "Warmup" and not u14.Get("Weapon", "WarmupDrop") then
        u25.SetNotifyVisibility(true, "You cannot drop your Weapon", 4);

        return;
    end;

    if p94.Data.Type == "Melee" then
        u25.SetNotifyVisibility(true, "You cannot drop your Knife", 4);

        return;
    end;

    local NextSlot = u7.GetNextSlot(u2, p94.Slot);
    local v98 = u2[NextSlot];

    if v98 then
        if u3 then
            u25.SetNotifyVisibility(true, "You dropped your " .. u3.Name, 4);
        end;

        v98:Equip(p95 or u5, p97);
        u4.WishEquip = NextSlot;

        return v98;
    end;
end;

function u1.Unequip(p99, p100) -- Line: 480
    -- upvalues: u1 (copy), u5 (ref), u24 (ref), u8 (ref), u4 (copy), u3 (ref)
    if not p100 then
        p99:StopAllAnimations();
    end;

    u1.OnWeaponUnequip:Fire(p99);
    u5.Simulation.CurrentWeapon = nil;
    p99.Equipping = false;
    p99.Reloading = false;
    p99.AmmoClip = false;
    p99.ShotgunShellLoaded = false;
    p99.Firing = false;
    p99.Inspecting = false;

    if p99.IsSniper then
        p99.AltFunctionModule.Clear(p99);
    elseif p99.Data.AltFunction and p99.Data.AltFunction.Name == "ScopeRifle" then
        p99.AltFunctionModule.Clear(p99);
        u24.ResetIronSight(p99);
    elseif p99.Data.AltFunction and p99.Data.AltFunction.Name == "Silencer" then
        if p99.SilencerMode == 4 then
            local Silencer = p99.Viewmodel.Weapon:FindFirstChild("Silencer", true);

            if Silencer and Silencer:IsA("BasePart") then
                Silencer.Transparency = 1;
            end;
        end;

        p99.AltFunctionModule.Clear(p99);
    end;

    u24.SetVisible(p99, false);
    u8.BlockInputs(u4);
    u3 = nil;
end;

function u1.Destroy(p101) -- Line: 524
    -- upvalues: u3 (ref), u24 (ref), u2 (copy), u1 (copy), u19 (ref)
    if p101 == u3 then
        p101:Unequip();
    end;

    p101.Maid:Destroy();
    u24.Destroy(p101);

    if u2[p101.Slot] == p101 then
        u2[p101.Slot] = nil;
    end;

    u1.OnWeaponDestroy:Fire(p101);
    u19.UpdateWeapons();
    table.clear(p101);
    setmetatable(p101, nil);
end;

function u1.GetWeaponInventory() -- Line: 549
    -- upvalues: u2 (copy)
    return u2;
end;

function u1.GetCurrentWeapon() -- Line: 553
    -- upvalues: u3 (ref)
    return u3;
end;

function u1.GetCurrentCharacter() -- Line: 557
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.UpdateKeyState(p102, p103) -- Line: 561
    -- upvalues: u4 (copy)
    u4[p102] = p103;
end;

function u1.GetKeyState(p104) -- Line: 565
    -- upvalues: u4 (copy)
    return u4[p104];
end;

function u1.OnCharacterSpawn(u105) -- Line: 571
    -- upvalues: u5 (ref), u13 (ref), u3 (ref), u4 (copy), u6 (ref), u23 (ref), u8 (ref), u31 (ref), PredictBuy (copy), u7 (ref), u60 (ref), u61 (ref), u32 (copy), u33 (copy), u2 (copy), u9 (ref), u1 (copy)
    u5 = u105;
    u105.CurrentWeaponCommand = nil;
    u105.Maid:Add("Character_ProcessWeapon", u13.OnTick.Connect({
        Function = function(p106) -- Line: 578
            -- upvalues: u3 (ref), u4 (ref), u6 (ref), u23 (ref), u8 (ref), u31 (ref), PredictBuy (ref), u7 (ref), u60 (ref), u61 (ref), u105 (copy), u32 (ref), u33 (ref), u13 (ref), u2 (ref), u9 (ref), u1 (ref)
            if u3 and next(u3) then
                local WishDrop = u4.WishDrop;

                if u6 then
                    if u23.HasFramePriority() then
                        u8.BlockInputs(u4);
                    else
                        local v107 = u3.Data and u3.Data.Type == "Melee";

                        for i, v in u4 do
                            if i ~= "WishInspect" then
                                if i ~= "WishDrop" then
                                    if i ~= "WishFire2" or v107 then
                                        if typeof(v) == "boolean" then
                                            u4[i] = false;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                elseif u23.HasFramePriority() then
                    u8.BlockInputs(u4);
                end;

                if u23.IsOnlyFrame("Buymenu") then
                    u4.WishDrop = WishDrop;
                end;
            end;

            local v108;

            if u31 then
                local v109 = u31;
                u31 = nil;
                v108 = PredictBuy(v109);
            else
                v108 = false;
            end;

            local CommandMap = u8.GetCommandMap(u4);

            if v108 then
                CommandMap.WishEquip = CommandMap.WishEquip + u7.BUY_ACK;
            end;

            if u60 then
                u60 = false;
                CommandMap.WishEquip = CommandMap.WishEquip + u7.EQUIP_ACK;
            end;

            local v110 = u61;

            if v110 then
                u61 = false;
                CommandMap.WishEquip = CommandMap.WishEquip + u7.RESET_ACK;
            end;

            local v111 = u3;
            local v112;

            if v111 then
                if v111.Name == "Dual Berettas" then
                    v112 = v111.Data.Ammo % 2 == 0;
                else
                    v112 = false;
                end;
            else
                v112 = v111;
            end;

            local v113 = false;
            local v114;

            if v111 then
                v114 = v111.Data.AltFunction;
            else
                v114 = v111;
            end;

            if v114 and v114.Name == "Silencer" then
                v113 = v111.Mode == 1;
            end;

            u105.CurrentWeaponCommand = CommandMap;
            local WishBooleans = CommandMap.WishBooleans;
            u32.WishInspect = WishBooleans.WishInspect;
            u32.WishFire = WishBooleans.WishFire;
            u32.WishFire2 = WishBooleans.WishFire2;
            u32.WishReload = WishBooleans.WishReload;
            u32.WishDrop = WishBooleans.WishDrop;
            u33.WishEquip = CommandMap.WishEquip;
            local Tick = u13.GetTick();
            u33.ClientTick = Tick;
            local v115, v116, v117 = u7.ProcessCommand(u105, v111, u2, u33, false, p106);
            CommandMap.Shot = (v115 or (v116 or v117)) ~= nil;
            local v118 = u3;
            u9.Process(v118, v115, v116, v117, v112, v113);

            if v110 and v118 then
                u1.OnAmmoCorrected:Fire(v118);
            end;

            if v118 then
                u105.WeaponSimulationCache:PushFilled(Tick, nil, v118.WriteState, v118);
            end;

            u1.PushWeaponHistory(u2, Tick);
            local Simulation = u105.Simulation;
            u105.SimulationCache:PushFilled(Tick, nil, Simulation.WriteState, Simulation);
        end,

        Priority = 1,
        SubPriority = 2
    }));
end;

function u1.OnCharacterDestroy() -- Line: 704
    -- upvalues: u2 (copy), u31 (ref), u61 (ref), u3 (ref)
    for i, v in u2 do
        local Replaced = v.Replaced;

        while Replaced do
            local Replaced2 = Replaced.Replaced;
            Replaced:Destroy();
            Replaced = Replaced2;
        end;

        v:Destroy();
        u2[i] = nil;
    end;

    u31 = nil;
    u61 = false;
    u3 = nil;
end;

function u1.Init(p119) -- Line: 725
    -- upvalues: u7 (ref), u22 (ref), u23 (ref), u12 (ref), u13 (ref), u16 (ref), u14 (ref), u24 (ref), u17 (ref), u28 (ref), u29 (ref), u30 (ref), u15 (ref), u26 (ref), u1 (copy), u8 (ref), u9 (ref), u10 (ref), u11 (ref)
    u7 = p119:GetModule("WeaponConstructor");
    u22 = p119:GetModule("CharacterController");
    u23 = p119:GetModule("BindsController");
    u12 = p119:GetModule("Network");
    u13 = p119:GetModule("Tick");
    u16 = p119:GetModule("SnapshotRing");
    u14 = p119:GetModule("GameConfiguration");
    u24 = p119:GetModule("Viewmodel");
    u17 = p119:GetModule("Gui");
    u28 = p119:GetModule("InventoryData");
    u29 = p119:GetModule("Enums");
    u30 = p119:GetModule("WeaponManager");
    u15 = p119:GetModule("Maid");
    u26 = p119:GetModule("Signal");
    u1.OnWeaponChanged = u26.new();
    u1.OnWeaponUnequip = u26.new();
    u1.OnWeaponShoot = u26.new();
    u1.OnWeaponReload = u26.new();
    u1.OnWeaponEmpty = u26.new();
    u1.OnWeaponDestroy = u26.new();
    u1.OnWeaponCreate = u26.new();
    u1.OnAmmoCorrected = u26.new();
    u1.OnDataPatched = u26.new();
    u1.OnKillTrackChanged = u26.new();
    u1.OnKillTrackColorChanged = u26.new();
    u8 = p119:GetModule("WeaponInput");
    u9 = p119:GetModule("WeaponEffects");
    u10 = p119:GetModule("WeaponNetworking");
    u11 = p119:GetModule("WeaponAnimations");

    for i, v in u11 do
        if i ~= "Init" then
            u1[i] = v;
        end;
    end;

    u1.__index = setmetatable(u1, u7);
end;

function u1.Start(p120) -- Line: 780
    -- upvalues: u18 (ref), u17 (ref), u19 (ref), u20 (ref), u25 (ref), u21 (ref), u27 (ref), u22 (ref), u1 (copy), SoundManager (copy), u12 (ref), ValueCodec (copy), u2 (copy), TemplateOverrides (copy)
    u18 = u17.GetComponent("Scope");
    u19 = u17.GetComponent("Buymenu");
    u20 = u17.GetComponent("MobileControls");
    u25 = u17.GetComponent("Notification");
    u21 = u17.GetComponent("Settings");
    u27 = u17.GetComponent("Down");
    u22.OnCharacterSpawn:Connect(u1.OnCharacterSpawn);
    u22.OnCharacterDestroy:Connect(u1.OnCharacterDestroy);
    u1.OnWeaponEmpty:Connect(function(p121) -- Line: 796
        -- upvalues: SoundManager (ref)
        SoundManager.Play(p121.Data.Type == "Pistol" and "Other.ClipemptyPistol" or "Other.ClipemptyRifle");
    end);
    u1.OnWeaponReload:Connect(function() -- Line: 802
        -- upvalues: SoundManager (ref)
        SoundManager.Play("Other.MagazineSlide");
    end);

    if u12.Weapon.Constant then
        u12.Weapon.Constant.On(function(p122) -- Line: 809
            -- upvalues: ValueCodec (ref), u2 (ref), u1 (ref)
            local v123 = ValueCodec.Decode(p122.Value);

            if p122.All then
                for _, v in pairs(u2) do
                    if v.Data[p122.Key] ~= nil then
                        v.Data[p122.Key] = v123;
                        u1.OnDataPatched:Fire(v);
                    end;
                end;

                return;
            end;

            local v124 = u2[p122.Slot];

            if v124 and v124.Data[p122.Key] ~= nil then
                v124.Data[p122.Key] = v123;
                u1.OnDataPatched:Fire(v124);
            end;
        end);
    end;

    if u12.Weapon.Template then
        u12.Weapon.Template.On(function(p125) -- Line: 832
            -- upvalues: TemplateOverrides (ref), u2 (ref), u1 (ref)
            local v126, v127 = TemplateOverrides.HandleWeaponTemplate(p125);

            if not v127 then
                return;
            end;

            for _, v in pairs(u2) do
                if v.Name == v126 then
                    local v128 = v;

                    for _, v2 in ipairs(v127) do
                        if v128.Data[v2.Key] ~= nil then
                            v128.Data[v2.Key] = v2.Value;
                            u1.OnDataPatched:Fire(v128);
                        end;
                    end;
                end;
            end;
        end);
    end;

    u1.OnWeaponShoot:Connect(function(p129) -- Line: 852
        -- upvalues: SoundManager (ref)
        local Data = p129.Data;
        local ClipSize = Data.ClipSize;

        if ClipSize and Data.Ammo == math.max(1, ClipSize // 4) then
            SoundManager.Play("Other.Lowammo");
        end;
    end);
end;

return u1;