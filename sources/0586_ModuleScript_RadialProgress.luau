-- Decompiled with Potassium's decompiler.

local v1 = {};
local Color3_fromRGB_ret = Color3.fromRGB(219, 159, 47);
local Color3_fromRGB_ret2 = Color3.fromRGB(43, 172, 43);
local Color3_fromRGB_ret3 = Color3.fromRGB(182, 45, 45);
local Color3_new_ret = Color3.new(0, 0, 0);
local Color3_new_ret2 = Color3.new(1, 1, 1);
local Color3_fromRGB_ret4 = Color3.fromRGB(255, 200, 0);
local Color3_fromRGB_ret5 = Color3.fromRGB(255, 255, 255);
local NumberSequence_new_ret = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(0.501, 1),
    NumberSequenceKeypoint.new(1, 1)
});

local function formatTime(p2: number) -- Line: 27
    local math_floor_ret = math.floor(p2 / 60);
    local v3 = p2 % 60;
    local math_floor_ret2 = math.floor(v3);
    local math_floor_ret3 = math.floor((v3 - math_floor_ret2) * 1000);

    return string.format("%02d:%02d.%03d", math_floor_ret, math_floor_ret2, math_floor_ret3);
end;

local function getBackgroundColor(p4: number) -- Line: 36
    -- upvalues: Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    local math_clamp_ret = math.clamp(p4, 0, 1);

    if math_clamp_ret <= 0.5 then
        return Color3_fromRGB_ret3:Lerp(Color3_fromRGB_ret, math_clamp_ret * 2);
    end;

    return Color3_fromRGB_ret:Lerp(Color3_fromRGB_ret2, (math_clamp_ret - 0.5) * 2);
end;

local function applyHighContrastText(p5: userdata) -- Line: 51
    -- upvalues: Color3_new_ret (copy), Color3_new_ret2 (copy)
    p5.TextStrokeColor3 = Color3_new_ret;
    p5.TextColor3 = Color3_new_ret2;
    p5.TextStrokeTransparency = 0;
end;

local function animateIcon(p6: any, p7: number, p8: string, p9) -- Line: 58
    -- upvalues: Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret5 (copy)
    if not (p6 and p6.ProgressBar) then
        return;
    end;

    local v10 = p6.ProgressBar:FindFirstChild(p8);

    if not v10 then
        return;
    end;

    local v11 = tick() * (p7 * 0.5 + 0.5) * 3.141592653589793 * 2;
    local math_sin_ret = math.sin(v11);
    local v12 = math_sin_ret * 0.05 + 1;
    local UDim2_new_ret = UDim2.new(p9.X * v12, 0, p9.Y * v12, 0);
    local v13 = Color3_fromRGB_ret4:Lerp(Color3_fromRGB_ret5, (math_sin_ret + 1) / 2);
    v10.Size = UDim2_new_ret;
    v10.ImageColor3 = v13;
end;

function v1.Initialize(p14: any, p15: string) -- Line: 88
    -- upvalues: Color3_fromRGB_ret3 (copy), NumberSequence_new_ret (copy)
    if not (p14.Frame and p14.Frame.ProgressBar) then
        warn((`{p15}: Frame or ProgressBar not found`));

        return;
    end;

    local ProgressBar = p14.Frame.ProgressBar;
    local LeftGradient = ProgressBar:FindFirstChild("LeftGradient");
    local RightGradient = ProgressBar:FindFirstChild("RightGradient");
    local ProgressBarImage = LeftGradient:FindFirstChild("ProgressBarImage");
    local ProgressBarImage2 = RightGradient:FindFirstChild("ProgressBarImage");
    local UIGradient = ProgressBarImage:FindFirstChild("UIGradient");
    local UIGradient2 = ProgressBarImage2:FindFirstChild("UIGradient");
    p14.LeftProgressImage = ProgressBarImage;
    p14.RightProgressImage = ProgressBarImage2;
    p14.LeftGradient = UIGradient;
    p14.RightGradient = UIGradient2;
    ProgressBarImage.ImageColor3 = Color3_fromRGB_ret3;
    ProgressBarImage2.ImageColor3 = Color3_fromRGB_ret3;
    ProgressBarImage.ImageTransparency = 0;
    ProgressBarImage2.ImageTransparency = 0;
    LeftGradient.Visible = true;
    RightGradient.Visible = true;
    ProgressBarImage.Visible = true;
    ProgressBarImage2.Visible = true;
    UIGradient.Transparency = NumberSequence_new_ret;
    UIGradient2.Transparency = NumberSequence_new_ret;
    UIGradient.Rotation = 0;
    UIGradient2.Rotation = 0;
end;

function v1.Update(p16: any, p17: number, p18: string, p19) -- Line: 128
    -- upvalues: Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), animateIcon (copy), Color3_new_ret (copy)
    if not (p16.Frame and p16.Frame.ProgressBar) then
        return;
    end;

    if not (p16.LeftGradient and p16.RightGradient) then
        return;
    end;

    if not (p16.LeftProgressImage and p16.RightProgressImage) then
        return;
    end;

    local math_clamp_ret = math.clamp(p17, 0, 1);
    local math_clamp_ret2 = math.clamp(math_clamp_ret, 0, 1);
    local v20;

    if math_clamp_ret2 <= 0.5 then
        v20 = Color3_fromRGB_ret3:Lerp(Color3_fromRGB_ret, math_clamp_ret2 * 2);
    else
        v20 = Color3_fromRGB_ret:Lerp(Color3_fromRGB_ret2, (math_clamp_ret2 - 0.5) * 2);
    end;

    p16.LeftProgressImage.ImageColor3 = v20;
    p16.RightProgressImage.ImageColor3 = v20;
    local v21 = math_clamp_ret * 180;
    p16.RightGradient.Rotation = 360 - v21;
    p16.LeftGradient.Rotation = v21 + 180;
    animateIcon(p16.Frame, math_clamp_ret, p18, p19);

    if p16.Frame.UIGradient then
        local v22 = v20:Lerp(Color3_new_ret, 0.3);
        p16.Frame.UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v20), ColorSequenceKeypoint.new(1, v22) });
    end;

    local v23 = v20:Lerp(Color3_new_ret, 0.2);

    if p16.Frame.Frame1 then
        p16.Frame.Frame1.BackgroundColor3 = v23;
    end;

    if p16.Frame.Frame2 then
        p16.Frame.Frame2.BackgroundColor3 = v23;
    end;
end;

function v1.SetTimer(p24: any, p25: number) -- Line: 172
    -- upvalues: Color3_new_ret (copy), Color3_new_ret2 (copy)
    if not (p24 and p24.Timer) then
        return;
    end;

    local Timer = p24.Timer;
    local math_floor_ret = math.floor(p25 / 60);
    local v26 = p25 % 60;
    local math_floor_ret2 = math.floor(v26);
    local math_floor_ret3 = math.floor((v26 - math_floor_ret2) * 1000);
    Timer.Text = string.format("%02d:%02d.%03d", math_floor_ret, math_floor_ret2, math_floor_ret3);
    local Timer2 = p24.Timer;
    Timer2.TextStrokeColor3 = Color3_new_ret;
    Timer2.TextColor3 = Color3_new_ret2;
    Timer2.TextStrokeTransparency = 0;
end;

function v1.SetTitle(p27: any, p28: string) -- Line: 180
    -- upvalues: Color3_new_ret (copy), Color3_new_ret2 (copy)
    if not (p27 and p27.Title) then
        return;
    end;

    p27.Title.Text = p28;
    local Title = p27.Title;
    Title.TextStrokeColor3 = Color3_new_ret;
    Title.TextColor3 = Color3_new_ret2;
    Title.TextStrokeTransparency = 0;
end;

return v1;