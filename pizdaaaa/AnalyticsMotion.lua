-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Analytics.AnalyticsMotion
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Analytics.AnalyticsMotion
-- Decompile time: 14.15 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local TweenService = game:GetService("TweenService");
local u2 = {
    Frame = { "BackgroundTransparency" },
    ScrollingFrame = { "BackgroundTransparency", "ScrollBarImageTransparency" },
    TextLabel = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" },
    TextButton = { "BackgroundTransparency", "TextTransparency" },
    ImageLabel = { "BackgroundTransparency", "ImageTransparency" },
    ImageButton = { "BackgroundTransparency", "ImageTransparency" },
    UIStroke = { "Transparency" }
};
local u3 = {};

local function Collect(p4: userdata, p5: any, p6: any) -- Line: 29
    -- upvalues: u2 (copy), Collect (copy)
    if p6 and p6[p4] then
        return;
    end;

    local v7 = u2[p4.ClassName];

    if v7 then
        for _, v in v7 do
            if p4[v] < 1 then
                table.insert(p5, { p4, v, p4[v] });
            end;
        end;
    end;

    for _, child in p4:GetChildren() do
        Collect(child, p5, p6);
    end;
end;

function u1.Whole(p8: number) -- Line: 51
    local math_round_ret = math.round(p8);

    return tostring(math_round_ret);
end;

function u1.Capture(p9: userdata, p10: any) -- Line: 55
    -- upvalues: Collect (copy)
    local v11 = {};
    Collect(p9, v11, p10);

    return {
        Holder = p9,
        Position = p9.Position,
        Fades = v11
    };
end;

function u1.CaptureChildren(p12: userdata, p13: any) -- Line: 67
    -- upvalues: u1 (copy)
    local v14 = {};

    for _, child in p12:GetChildren() do
        if child:IsA("GuiObject") then
            table.insert(v14, u1.Capture(child, p13));
        end;
    end;

    table.sort(v14, function(p15, p16) -- Line: 76
        if p15.Position.Y.Scale == p16.Position.Y.Scale then
            return p15.Position.X.Scale < p16.Position.X.Scale;
        end;

        return p15.Position.Y.Scale < p16.Position.Y.Scale;
    end);

    return v14;
end;

function u1.Reveal(p17: any, p18: number) -- Line: 87
    -- upvalues: TweenService (copy)
    local TweenInfo_new_ret = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, p18);

    for _, v in p17.Fades do
        local v19, v20, v21 = unpack(v);
        v19[v20] = 1;
        TweenService:Create(v19, TweenInfo_new_ret, {
            [v20] = v21
        }):Play();
    end;

    local Parent = p17.Holder.Parent;

    if Parent and Parent:FindFirstChildWhichIsA("UIGridStyleLayout") then
        return;
    end;

    p17.Holder.Position = p17.Position + UDim2.fromOffset(0, 10);
    TweenService:Create(p17.Holder, TweenInfo_new_ret, {
        Position = p17.Position
    }):Play();
end;

function u1.RevealAll(p22: any, p23: number, p24: number, p25: number?) -- Line: 107
    -- upvalues: u1 (copy)
    for i, v in p22 do
        if p25 and p25 < i then
            break;
        end;

        u1.Reveal(v, p23 + (i - 1) * p24);
    end;
end;

function u1.CountUp(u26: userdata, p27: number, u28: any, p29: number) -- Line: 117
    -- upvalues: u3 (copy), TweenService (copy)
    local v30 = u3[u26];

    if not v30 then
        v30 = Instance.new("NumberValue");
        v30.Changed:Connect(function(p31) -- Line: 123
            -- upvalues: u26 (copy), u28 (copy)
            u26.Text = u28(p31);
        end);
        u3[u26] = v30;
    end;

    v30.Value = 0;
    u26.Text = u28(0);
    TweenService:Create(v30, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, p29), {
        Value = p27
    }):Play();
end;

return u1;