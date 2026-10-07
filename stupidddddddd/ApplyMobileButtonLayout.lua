-- ReplicatedStorage.Components.Common.ApplyMobileButtonLayout
-- Script path: ReplicatedStorage.Components.Common.ApplyMobileButtonLayout
-- Decompile time: 1.48 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile)

local function GetBaseline(a1, a2, a3) -- Line: 22 -- types: a1: userdata, a2: string, a3: number
    local Attribute = a1:GetAttribute(a2)
    if typeof(Attribute) ~= "number" then
        a1:SetAttribute(a2, a3)
    end
    return Attribute
end

local function BlendProperty(a1, a2, a3, a4) -- Line: 33 -- types: a1: userdata, a2: string, a3: string, a4: number
    local v1 = a1[a3]
    local v2 = a1:GetAttribute(a2)
    if typeof(v2) ~= "number" then
        a1:SetAttribute(a2, v1)
    end
    a1[a3] = v2 + (1 - v2) * a4
end

local function ApplyTransparency(a1, a2) -- Line: 41 -- types: a1: userdata, a2: number
    local BackgroundTransparency_2, BackgroundTransparency_3, ImageTransparency, TextTransparency, Transparency, v1
    local v2 = math.clamp(a2, 0, 1)
    local v3 = a1
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("ImageLabel") or v:IsA("ImageButton") then
            ImageTransparency = v.ImageTransparency
            v1 = v:GetAttribute("_MobileHUDBaseImageTransparency")
            if typeof(v1) ~= "number" then
                v:SetAttribute("_MobileHUDBaseImageTransparency", ImageTransparency)
            end
            v.ImageTransparency = v1 + (1 - v1) * v2
            BackgroundTransparency_3 = v.BackgroundTransparency
            v1 = v:GetAttribute("_MobileHUDBaseBackgroundTransparency")
            if typeof(v1) ~= "number" then
                v:SetAttribute("_MobileHUDBaseBackgroundTransparency", BackgroundTransparency_3)
            end
            v.BackgroundTransparency = v1 + (1 - v1) * v2
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then
            TextTransparency = v.TextTransparency
            v1 = v:GetAttribute("_MobileHUDBaseTextTransparency")
            if typeof(v1) ~= "number" then
                v:SetAttribute("_MobileHUDBaseTextTransparency", TextTransparency)
            end
            v.TextTransparency = v1 + (1 - v1) * v2
            BackgroundTransparency_2 = v.BackgroundTransparency
            v1 = v:GetAttribute("_MobileHUDBaseBackgroundTransparency")
            if typeof(v1) ~= "number" then
                v:SetAttribute("_MobileHUDBaseBackgroundTransparency", BackgroundTransparency_2)
            end
            v.BackgroundTransparency = v1 + (1 - v1) * v2
        elseif v:IsA("UIStroke") then
            Transparency = v.Transparency
            v1 = v:GetAttribute("_MobileHUDBaseImageTransparency")
            if typeof(v1) ~= "number" then
                v:SetAttribute("_MobileHUDBaseImageTransparency", Transparency)
            end
            v.Transparency = v1 + (1 - v1) * v2
        end
    end
    local BackgroundTransparency = v3.BackgroundTransparency
    local v4 = v3:GetAttribute("_MobileHUDBaseBackgroundTransparency")
    if typeof(v4) ~= "number" then
        v3:SetAttribute("_MobileHUDBaseBackgroundTransparency", BackgroundTransparency)
    end
    v3.BackgroundTransparency = v4 + (1 - v4) * v2
end

return function(a1, a2) -- Line: 61 -- upvalues: ApplyTransparency (val) -- types: a1: userdata
    a1.Position = UDim2.fromScale(a2.Position.X, a2.Position.Y)
    a1.Size = UDim2.fromScale(a2.Size.X, a2.Size.Y)
    ApplyTransparency(a1, a2.Transparency)
end