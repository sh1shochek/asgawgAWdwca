-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Router = require(ReplicatedStorage.Database.Security.Router);
local GuiShown = require(script.Parent.GuiShown);
local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local Color3_fromRGB_ret = Color3.fromRGB(255, 196, 77);
local TweenInfo_new_ret2 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1);
local TweenInfo_new_ret3 = TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local TweenInfo_new_ret4 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local TweenInfo_new_ret5 = TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local TweenInfo_new_ret6 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local u1 = { { 4, 0.85 }, { 8, 0.94 } };

local function multiplyUDim2(p2, p3: number) -- Line: 26
    return UDim2.new(p2.X.Scale * p3, p2.X.Offset, p2.Y.Scale * p3, p2.Y.Offset);
end;

local function createGlowStroke(p4: userdata, p5: number, p6: number) -- Line: 32
    -- upvalues: Color3_fromRGB_ret (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Glow";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.ZIndex = 3;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "GlowStroke";
    UIStroke.Color = Color3_fromRGB_ret;
    UIStroke.Thickness = p5;
    UIStroke.Transparency = p6;
    UIStroke.Parent = Frame;
    Frame.Parent = p4;

    return UIStroke;
end;

local function createGlowInstances(p7: userdata) -- Line: 53
    -- upvalues: createGlowStroke (copy), Color3_fromRGB_ret (copy), TweenService (copy), TweenInfo_new_ret2 (copy), u1 (copy)
    local v8 = createGlowStroke(p7, 1.5, 0.3);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3_fromRGB_ret), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 240, 190)), ColorSequenceKeypoint.new(1, Color3_fromRGB_ret) });
    UIGradient.Parent = v8;
    local v9 = TweenService:Create(UIGradient, TweenInfo_new_ret2, {
        Rotation = 360
    });
    local v10 = {};

    for _, v in ipairs(u1) do
        local v11 = createGlowStroke(p7, v[1], v[2]);
        table.insert(v10, v11);
    end;

    return v8, v10, v9;
end;

local function createShineSweep(p12: userdata) -- Line: 76
    local Frame = Instance.new("Frame");
    Frame.Name = "Shine";
    Frame.Active = false;
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.ZIndex = 150;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Rotation = 20;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 1),
        NumberSequenceKeypoint.new(0.5, 0.55),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Offset = Vector2.new(-1, 0);
    UIGradient.Parent = Frame;
    Frame.Parent = p12;

    return UIGradient;
end;

local function setupCardEffects(u13: userdata, p14: userdata) -- Line: 104
    -- upvalues: createGlowInstances (copy), u1 (copy), TweenService (copy), TweenInfo_new_ret3 (copy), TweenInfo_new_ret4 (copy), TweenInfo_new_ret5 (copy), GuiShown (copy), createShineSweep (copy), TweenInfo_new_ret6 (copy)
    local v15, v16, u17 = createGlowInstances(u13);
    local u18 = {};

    for i, v in ipairs(v16) do
        table.insert(u18, TweenService:Create(v, TweenInfo_new_ret3, {
            Transparency = u1[i][2] - 0.08
        }));
    end;

    local u19 = { TweenService:Create(v15, TweenInfo_new_ret4, {
            Transparency = 0,
            Thickness = 2
        }) };
    local u20 = { TweenService:Create(v15, TweenInfo_new_ret4, {
            Transparency = 0.3,
            Thickness = 1.5
        }) };

    for i, v in ipairs(v16) do
        local v21 = u1[i][2];
        table.insert(u19, TweenService:Create(v, TweenInfo_new_ret4, {
            Transparency = 1
        }));
        table.insert(u20, TweenService:Create(v, TweenInfo_new_ret4, {
            Transparency = v21
        }));
    end;

    local u22 = false;
    p14.MouseEnter:Connect(function() -- Line: 128
        -- upvalues: u22 (ref), u18 (copy), u19 (copy)
        u22 = true;

        for i, v in ipairs(u18) do
            v:Cancel();
            u19[i + 1]:Play();
        end;

        u19[1]:Play();
    end);
    p14.MouseLeave:Connect(function() -- Line: 136
        -- upvalues: u22 (ref), u20 (copy)
        u22 = false;

        for _, v in ipairs(u20) do
            v:Play();
        end;
    end);
    local u23 = false;
    u20[1].Completed:Connect(function() -- Line: 144
        -- upvalues: u23 (ref), u22 (ref), u18 (copy)
        if u23 and not u22 then
            for _, v in ipairs(u18) do
                v:Play();
            end;
        end;
    end);
    local Discount = u13:FindFirstChild("Discount");

    if Discount then
        Discount = Discount:FindFirstChild("Discount");
    end;

    local u24;

    if Discount then
        u24 = TweenService:Create(Discount, TweenInfo_new_ret5, {
            Rotation = Discount.Rotation + 4
        });
    else
        u24 = nil;
    end;

    GuiShown.Observe(u13, function(p25: boolean) -- Line: 159
        -- upvalues: u23 (ref), u22 (ref), u18 (copy), u17 (copy), u24 (copy)
        u23 = p25;
        local v26 = u22 and {} or table.clone(u18);
        table.insert(v26, u17);

        if u24 then
            table.insert(v26, u24);
        end;

        for _, v in v26 do
            if u23 then
                v:Play();
            else
                v:Pause();
            end;
        end;
    end);
    local u27 = createShineSweep(u13);
    task.spawn(function() -- Line: 177
        -- upvalues: TweenService (ref), u27 (copy), TweenInfo_new_ret6 (ref), u13 (copy), u23 (ref)
        local v28 = TweenService:Create(u27, TweenInfo_new_ret6, {
            Offset = Vector2.new(1, 0)
        });

        while u13.Parent do
            if u23 then
                v28:Play();
                v28.Completed:Wait();
                u27.Offset = Vector2.new(-1, 0);
            end;

            task.wait(2.5);
        end;
    end);
end;

return function(p29: userdata, p30: userdata) -- Line: 195
    -- upvalues: setupCardEffects (copy), TweenService (copy), TweenInfo_new_ret (copy), Router (copy)
    setupCardEffects(p29, p30);
    local Size = p29.Size;
    local u31 = TweenService:Create(p29, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * 0.9, Size.X.Offset, Size.Y.Scale * 0.9, Size.Y.Offset)
    });
    local u32 = TweenService:Create(p29, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * 0.95, Size.X.Offset, Size.Y.Scale * 0.95, Size.Y.Offset)
    });
    local u33 = TweenService:Create(p29, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * 0.95, Size.X.Offset, Size.Y.Scale * 0.95, Size.Y.Offset)
    });
    local u34 = TweenService:Create(p29, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * 1, Size.X.Offset, Size.Y.Scale * 1, Size.Y.Offset)
    });
    p30.MouseEnter:Connect(function() -- Line: 204
        -- upvalues: Router (ref), u33 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        u33:Play();
    end);
    p30.MouseLeave:Connect(function() -- Line: 208
        -- upvalues: u34 (copy)
        u34:Play();
    end);
    p30.MouseButton1Down:Connect(function() -- Line: 211
        -- upvalues: Router (ref), u31 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u31:Play();
    end);
    p30.MouseButton1Up:Connect(function() -- Line: 215
        -- upvalues: u32 (copy)
        u32:Play();
    end);
end;