-- ReplicatedStorage.GameClient.Gui.HUD.PreparationGrayscale
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.PreparationGrayscale
-- Decompile time: 15.21 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local GameStats = game:GetService("ReplicatedStorage").GameStats;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = 0;
local u9 = 0;
local u10 = 5;
local u11 = 320;
local u12 = 0;
local u13 = false;
local u14 = {};

function u1.IsMenuOpen() -- Line: 34
    -- upvalues: u2 (ref)
    if u2 and u2.HasFramePriority then
        return u2.HasFramePriority() ~= nil;
    end;

    return false;
end;

function u1.GetPreparationTime() -- Line: 39
    -- upvalues: GameStats (copy), u6 (ref), u3 (ref)
    local v15 = GameStats:GetAttribute("Gamemode") or "Casual";

    if u6 and (u3 and u3.RoundStatesNum) then
        local v16 = u6.Get(v15);
        local v17 = v16 and v16.Timers and v16.Timers[u3.RoundStatesNum.Preparation];

        if v17 and v17 > 0 then
            return v17;
        end;
    end;

    local Attribute = GameStats:GetAttribute("Time");

    return (not Attribute or Attribute <= 0) and 5 or Attribute;
end;

function u1.CleanupCC() -- Line: 56
    -- upvalues: Lighting (copy), u14 (ref)
    local PreparationGrayscale = Lighting:FindFirstChild("PreparationGrayscale");

    if PreparationGrayscale and PreparationGrayscale:IsA("ColorCorrectionEffect") then
        PreparationGrayscale:Destroy();
    end;

    u14 = {};
end;

function u1.GetOrCreateCC() -- Line: 62
    -- upvalues: Lighting (copy), u14 (ref)
    local PreparationGrayscale = Lighting:FindFirstChild("PreparationGrayscale");

    if PreparationGrayscale and PreparationGrayscale:IsA("ColorCorrectionEffect") then
        return PreparationGrayscale;
    end;

    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Name = "PreparationGrayscale";
    ColorCorrectionEffect.Saturation = 0;
    ColorCorrectionEffect.Brightness = 0;
    ColorCorrectionEffect.Contrast = 0;
    ColorCorrectionEffect.Enabled = false;
    ColorCorrectionEffect.Parent = Lighting;
    u14 = {};

    return ColorCorrectionEffect;
end;

function u1.ApplyCC(p18, p19) -- Line: 78
    -- upvalues: Lighting (copy), u14 (ref)
    if not p18 or p18.Parent ~= Lighting then
        return;
    end;

    local v20 = -1 * p19;
    local v21 = -0.05 * p19;
    local v22 = 0.1 * p19;
    local v23 = p19 > 0.001;

    if v20 ~= u14.sat then
        p18.Saturation = v20;
        u14.sat = v20;
    end;

    if v21 ~= u14.bri then
        p18.Brightness = v21;
        u14.bri = v21;
    end;

    if v22 ~= u14.con then
        p18.Contrast = v22;
        u14.con = v22;
    end;

    if v23 ~= u14.enabled then
        p18.Enabled = v23;
        u14.enabled = v23;
    end;
end;

function u1.CalculateAlpha() -- Line: 94
    -- upvalues: u13 (ref), u1 (copy), u10 (ref), u12 (ref), GameStats (copy)
    if not u13 then
        return 0;
    end;

    if u1.IsMenuOpen() then
        return 0;
    end;

    if u10 <= 0 then
        return 0;
    end;

    local math_clamp_ret = math.clamp(1 - u12 / u10, 0, 1);
    local Attribute = GameStats:GetAttribute("Time");

    if Attribute and Attribute >= 0 then
        local v24 = math.clamp(Attribute / u10, 0, 1) + 0.15;
        math_clamp_ret = math.min(math_clamp_ret, v24);
    end;

    return math.clamp(math_clamp_ret, 0, 1);
end;

function u1.StopUpdating() -- Line: 112
    -- upvalues: u7 (ref)
    u7:Remove("RenderStep");
end;

function u1.EnsureUpdating() -- Line: 116
    -- upvalues: u7 (ref), RunService (copy), u5 (ref), u13 (ref), u12 (ref), u9 (ref), u1 (copy), u8 (ref)
    u7:Add("RenderStep", RunService.RenderStepped:Connect(function(p25) -- Line: 117
        -- upvalues: u5 (ref), u13 (ref), u12 (ref), u9 (ref), u1 (ref), u8 (ref)
        local v26 = u5 and u5.Get("Game", "TimeScale") or 1;

        if u13 then
            u12 = u12 + p25 * v26;
        end;

        u9 = u1.CalculateAlpha();

        if u1.IsMenuOpen() then
            u8 = 0;
            u1.CleanupCC();

            if not u13 then
                u1.StopUpdating();
            end;

            return;
        end;

        local v27 = 1 - math.exp(-4 * v26 * p25);
        u8 = u8 + (u9 - u8) * math.clamp(v27, 0, 1);

        if u8 > 0.001 or u9 > 0.001 then
            u1.ApplyCC(u1.GetOrCreateCC(), u8);

            return;
        end;

        u8 = 0;
        u1.CleanupCC();

        if not u13 or u9 <= 0.001 then
            u1.StopUpdating();
        end;
    end));
end;

function u1.OnStateChanged() -- Line: 148
    -- upvalues: GameStats (copy), u13 (ref), u12 (ref), u10 (ref), u1 (copy), u11 (ref), u4 (ref), u9 (ref), u8 (ref)
    if GameStats:GetAttribute("State") ~= "Preparation" then
        u13 = false;
        u9 = 0;
        u12 = 0;

        if u8 > 0.001 then
            u1.EnsureUpdating();

            return;
        end;

        u8 = 0;
        u1.CleanupCC();
        u1.StopUpdating();

        return;
    end;

    u13 = true;
    u12 = 0;
    u10 = u1.GetPreparationTime();
    u11 = u4 and u4.TimeToTick(u10) or u10 * 64;
    u9 = 1;
    u8 = u1.IsMenuOpen() and 0 or 1;

    if u8 > 0 then
        u1.ApplyCC(u1.GetOrCreateCC(), u8);
    end;

    u1.EnsureUpdating();
end;

function u1.OnGamemodeChanged() -- Line: 179
    -- upvalues: u13 (ref), u10 (ref), u1 (copy), u4 (ref), u11 (ref), u9 (ref), u8 (ref)
    if not u13 then
        return;
    end;

    u10 = u1.GetPreparationTime();

    if u4 and u4.TimeToTick then
        u11 = u4.TimeToTick(u10);
    end;

    u9 = u1.CalculateAlpha();

    if u9 > 0.001 or u8 > 0.001 then
        u1.EnsureUpdating();
    end;
end;

function u1.GetColorCorrection() -- Line: 193
    -- upvalues: Lighting (copy)
    local PreparationGrayscale = Lighting:FindFirstChild("PreparationGrayscale");

    if not (PreparationGrayscale and (PreparationGrayscale:IsA("ColorCorrectionEffect") and PreparationGrayscale)) then
        PreparationGrayscale = nil;
    end;

    return PreparationGrayscale;
end;

function u1.IsActive() -- Line: 198
    -- upvalues: u13 (ref), u8 (ref)
    return u13 and u8 > 0.001;
end;

function u1.GetAlpha() -- Line: 199
    -- upvalues: u8 (ref)
    return u8;
end;

function u1.GetDuration() -- Line: 200
    -- upvalues: u10 (ref)
    return u10;
end;

function u1.GetTicks() -- Line: 201
    -- upvalues: u11 (ref)
    return u11;
end;

function u1.Init(p28) -- Line: 205
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref)
    u2 = p28:GetModule("BindsController");
    u3 = p28:GetModule("Enums");
    u4 = p28:GetModule("Tick");
    u5 = p28:GetModule("GameConfiguration");
    u6 = p28:GetModule("GamemodesConfig");
    u7 = p28:GetModule("Maid").new();
end;

function u1.Start(p29) -- Line: 214
    -- upvalues: GameStats (copy), u1 (copy)
    GameStats:GetAttributeChangedSignal("State"):Connect(u1.OnStateChanged);
    GameStats:GetAttributeChangedSignal("Gamemode"):Connect(u1.OnGamemodeChanged);
    u1.OnStateChanged();
end;

return u1;