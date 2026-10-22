-- ReplicatedStorage.GameClient.Gui.Misc.Haptics
-- Script path: ReplicatedStorage.GameClient.Gui.Misc.Haptics
-- Decompile time: 7.34 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local LocalPlayer = Players.LocalPlayer;
local u6 = {};
local u7 = true;
local u8 = 1;
local u9 = true;
local u10 = nil;
local u11 = {
    Hover = { { 0, 0.1 }, { 25, 0 } },
    Edge = { { 0, 0.35 }, { 35, 0.35 }, { 70, 0 } },
    Click = { { 0, 0.3 }, { 45, 0 } },
    Back = { { 0, 0.25 }, { 30, 0.25 }, { 60, 0 } },
    Tab = { { 0, 0.22 }, { 50, 0 } },
    Empty = { { 0, 0.2 }, { 30, 0 } },
    Hit = { { 0, 0.3 }, { 35, 0 } },
    Kill = { { 0, 0.7 }, { 60, 0.7 }, { 90, 0 }, { 140, 0.9 }, { 200, 0.9 }, { 260, 0 } },
    Fire = { { 0, 1 }, { 30, 0.8 }, { 110, 0 } },
    Damage = { { 0, 1 }, { 60, 0.85 }, { 260, 0 } },
    Explosion = { { 0, 1 }, { 120, 0.9 }, { 350, 0.55 }, { 600, 0.25 }, { 1100, 0 } },
    Death = { { 0, 1 }, { 80, 0.9 }, { 200, 0.55 }, { 420, 0 } }
};

local function Emit(p12: string, p13: number) -- Line: 39
    -- upvalues: u6 (copy), u11 (copy)
    local v14 = u6[p12];
    local v15 = {};

    for _, v in u11[p12] do
        table.insert(v15, FloatCurveKey.new(v[1], v[2] * p13, Enum.KeyInterpolationMode.Linear));
    end;

    v14:Stop();
    v14:SetWaveformKeys(v15);
    v14:Play();
end;

function u1.Play(p16: string, p17: number?) -- Line: 54
    -- upvalues: u7 (ref), u4 (ref), Emit (copy), u8 (ref)
    if not u7 or u4() ~= "Console" then
        return;
    end;

    Emit(p16, (math.clamp((p17 or 1) * u8, 0, 1)));
end;

function u1.Death() -- Line: 62
    -- upvalues: u9 (ref), u4 (ref), Emit (copy)
    if u9 and u4() == "Mobile" then
        Emit("Death", 1);
    end;
end;

function u1.Fire(p18) -- Line: 68
    -- upvalues: u1 (copy)
    local Data = p18.Data;
    u1.Play("Fire", (math.clamp(Data.Damage * Data.Bullets / 120, 0.25, 1)));
end;

function u1.Init(p19) -- Line: 76
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u7 (ref), u8 (ref), u9 (ref)
    u2 = p19:GetModule("Gui");
    u3 = p19:GetModule("Settings");
    u4 = p19:GetModule("GetUserPlatform");
    u5 = p19:GetModule("WeaponController");
    u3:AddConnection("Controls", "Controller Binds", "Controller Vibration", function(p20) -- Line: 82
        -- upvalues: u7 (ref)
        u7 = p20;
    end);
    u3:AddConnection("Controls", "Controller Binds", "Vibration Strength", function(p21) -- Line: 86
        -- upvalues: u8 (ref)
        u8 = p21;
    end);
    u3:AddConnection("Controls", "Mobile Buttons", "Death Vibration", function(p22) -- Line: 90
        -- upvalues: u9 (ref)
        u9 = p22;
    end);
end;

function u1.Start(p23) -- Line: 95
    -- upvalues: u11 (copy), u6 (copy), u5 (ref), u1 (copy), LocalPlayer (copy), u10 (ref)
    local Folder = Instance.new("Folder");
    Folder.Name = "Haptics";
    Folder.Parent = workspace;

    for i in u11 do
        local HapticEffect = Instance.new("HapticEffect");
        HapticEffect.Name = i;
        HapticEffect.Type = Enum.HapticEffectType.Custom;
        HapticEffect.Parent = Folder;
        u6[i] = HapticEffect;
    end;

    u5.OnWeaponShoot:Connect(u1.Fire);
    u5.OnWeaponEmpty:Connect(function() -- Line: 111
        -- upvalues: u1 (ref)
        u1.Play("Empty");
    end);
    local Module = p23:GetModule("Entities");
    local UserId = LocalPlayer.UserId;
    u10 = Module.GetHealth(LocalPlayer);
    Module.OnHealthUpdate:Connect(function(p24, p25) -- Line: 120
        -- upvalues: UserId (copy), u10 (ref), u1 (ref)
        if p24 ~= UserId then
            return;
        end;

        if p25 and (u10 and p25 < u10) then
            u1.Play("Damage", (math.clamp((u10 - p25) / 60, 0.3, 1)));
        end;

        u10 = p25;
    end);
end;

return u1;