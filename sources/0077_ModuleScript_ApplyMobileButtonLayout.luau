-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile);

local function GetBaseline(p1: userdata, p2: string, p3: number) -- Line: 22
    local Attribute = p1:GetAttribute(p2);

    if typeof(Attribute) == "number" then
        p3 = Attribute;
    else
        p1:SetAttribute(p2, p3);
    end;

    return p3;
end;

local function BlendProperty(p4: userdata, p5: string, p6: string, p7: number) -- Line: 33
    local v8 = p4[p6];
    local Attribute = p4:GetAttribute(p5);

    if typeof(Attribute) == "number" then
        v8 = Attribute;
    else
        p4:SetAttribute(p5, v8);
    end;

    p4[p6] = v8 + (1 - v8) * p7;
end;

local function ApplyTransparency(p9: userdata, p10: number) -- Line: 41
    local math_clamp_ret = math.clamp(p10, 0, 1);

    for _, descendant in ipairs(p9:GetDescendants()) do
        if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            local ImageTransparency = descendant.ImageTransparency;
            local Attribute = descendant:GetAttribute("_MobileHUDBaseImageTransparency");

            if typeof(Attribute) == "number" then
                ImageTransparency = Attribute;
            else
                descendant:SetAttribute("_MobileHUDBaseImageTransparency", ImageTransparency);
            end;

            descendant.ImageTransparency = ImageTransparency + (1 - ImageTransparency) * math_clamp_ret;
            local BackgroundTransparency = descendant.BackgroundTransparency;
            local Attribute2 = descendant:GetAttribute("_MobileHUDBaseBackgroundTransparency");

            if typeof(Attribute2) == "number" then
                BackgroundTransparency = Attribute2;
            else
                descendant:SetAttribute("_MobileHUDBaseBackgroundTransparency", BackgroundTransparency);
            end;

            descendant.BackgroundTransparency = BackgroundTransparency + (1 - BackgroundTransparency) * math_clamp_ret;
        elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            local TextTransparency = descendant.TextTransparency;
            local Attribute = descendant:GetAttribute("_MobileHUDBaseTextTransparency");

            if typeof(Attribute) == "number" then
                TextTransparency = Attribute;
            else
                descendant:SetAttribute("_MobileHUDBaseTextTransparency", TextTransparency);
            end;

            descendant.TextTransparency = TextTransparency + (1 - TextTransparency) * math_clamp_ret;
            local BackgroundTransparency = descendant.BackgroundTransparency;
            local Attribute2 = descendant:GetAttribute("_MobileHUDBaseBackgroundTransparency");

            if typeof(Attribute2) == "number" then
                BackgroundTransparency = Attribute2;
            else
                descendant:SetAttribute("_MobileHUDBaseBackgroundTransparency", BackgroundTransparency);
            end;

            descendant.BackgroundTransparency = BackgroundTransparency + (1 - BackgroundTransparency) * math_clamp_ret;
        elseif descendant:IsA("UIStroke") then
            local Transparency = descendant.Transparency;
            local Attribute = descendant:GetAttribute("_MobileHUDBaseImageTransparency");

            if typeof(Attribute) == "number" then
                Transparency = Attribute;
            else
                descendant:SetAttribute("_MobileHUDBaseImageTransparency", Transparency);
            end;

            descendant.Transparency = Transparency + (1 - Transparency) * math_clamp_ret;
        end;
    end;

    local BackgroundTransparency = p9.BackgroundTransparency;
    local Attribute = p9:GetAttribute("_MobileHUDBaseBackgroundTransparency");

    if typeof(Attribute) == "number" then
        BackgroundTransparency = Attribute;
    else
        p9:SetAttribute("_MobileHUDBaseBackgroundTransparency", BackgroundTransparency);
    end;

    p9.BackgroundTransparency = BackgroundTransparency + (1 - BackgroundTransparency) * math_clamp_ret;
end;

return function(p11: userdata, p12: any) -- Line: 61
    -- upvalues: ApplyTransparency (copy)
    p11.Position = UDim2.fromScale(p12.Position.X, p12.Position.Y);
    p11.Size = UDim2.fromScale(p12.Size.X, p12.Size.Y);
    ApplyTransparency(p11, p12.Transparency);
end;